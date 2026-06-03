import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var people: [Person]

    @AppStorage("dailyDigestEnabled") private var dailyDigestEnabled = false
    @AppStorage("dailyDigestHour")    private var dailyDigestHour    = 8
    @AppStorage("dailyDigestMinute")  private var dailyDigestMinute  = 0

    @State private var showingAdd = false
    @State private var showingImport = false
    @State private var showingSettings = false
    @State private var editingPerson: Person? = nil
    @State private var detailPerson: Person? = nil
    @State private var searchText = ""
    @State private var selectedCategory: String? = nil
    @State private var giftReminderPerson: Person? = nil
    @State private var giftReminderEventKind = ""

    var body: some View {
        // Vypočítáme jednou – zamezíme vícenásobnému výpočtu per render
        let allEvents = upcomingEvents
        let categoryEvents = selectedCategory == nil
            ? allEvents
            : allEvents.filter { $0.person.category == selectedCategory }
        let filteredEvents = searchText.isEmpty
            ? categoryEvents
            : categoryEvents.filter { $0.person.displayName.localizedCaseInsensitiveContains(searchText) }
        let unknownPeople = people
            .filter { $0.nameDayComponents == nil && $0.birthdayComponents == nil }
            .filter { selectedCategory == nil || $0.category == selectedCategory }

        NavigationStack {
            ScrollView {
                LazyVStack(spacing: 20, pinnedViews: []) {
                    // Dnešní karta – vždy viditelná
                    TodayCard(
                        allEvents: allEvents,
                        onTapPerson: { detailPerson = $0 }
                    )
                    .padding(.horizontal)

                    // Filtr kategorií
                    CategoryFilterBar(selected: $selectedCategory)
                        .padding(.horizontal)

                    // Nadcházející – horizontální scroll (všechna budoucí, max 15)
                    let upcoming = categoryEvents.filter { $0.daysUntil > 0 }
                    if !upcoming.isEmpty && searchText.isEmpty {
                        UpcomingStrip(events: upcoming, onTap: { detailPerson = $0.person })
                    }

                    // Všechny události (karty)
                    if !filteredEvents.isEmpty {
                        VStack(alignment: .leading, spacing: 10) {
                            SectionHeader(title: searchText.isEmpty ? "Všichni" : "Výsledky", icon: "person.2")
                            ForEach(filteredEvents) { event in
                                EventCard(event: event)
                                    .onTapGesture { detailPerson = event.person }
                                    .contextMenu {
                                        Button { detailPerson = event.person } label: {
                                            Label("Detail", systemImage: "info.circle")
                                        }
                                        Button { editingPerson = event.person } label: {
                                            Label("Upravit", systemImage: "pencil")
                                        }
                                        Button(role: .destructive) { deletePerson(event.person) } label: {
                                            Label("Smazat", systemImage: "trash")
                                        }
                                    }
                            }
                        }
                        .padding(.horizontal)
                    }

                    // Osoby bez data
                    if !unknownPeople.isEmpty && searchText.isEmpty {
                        VStack(alignment: .leading, spacing: 10) {
                            SectionHeader(title: "Bez data", icon: "questionmark.circle")
                            ForEach(unknownPeople) { person in
                                UnknownPersonCard(person: person)
                                    .onTapGesture { detailPerson = person }
                                    .contextMenu {
                                        Button { detailPerson = person } label: {
                                            Label("Detail", systemImage: "info.circle")
                                        }
                                        Button { editingPerson = person } label: {
                                            Label("Upravit", systemImage: "pencil")
                                        }
                                        Button(role: .destructive) { deletePerson(person) } label: {
                                            Label("Smazat", systemImage: "trash")
                                        }
                                    }
                            }
                        }
                        .padding(.horizontal)
                    }

                    // Empty state – pouze pokud nikdo není přidaný
                    if people.isEmpty {
                        EmptyAddCard { showingAdd = true }
                            .padding(.horizontal)
                    } else if filteredEvents.isEmpty && unknownPeople.isEmpty {
                        // Lidé jsou, ale nemají nastavená žádná data
                        EmptyAddCard { showingAdd = true }
                            .padding(.horizontal)
                    }

                    Spacer(minLength: 40)
                }
                .padding(.top, 8)
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("Svátky & Narozeniny")
            .searchable(text: $searchText, prompt: "Hledat jméno…")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        showingSettings = true
                    } label: {
                        Image(systemName: "gearshape")
                            .font(.system(size: 17))
                    }
                }
                ToolbarItem(placement: .primaryAction) {
                    Menu {
                        Button {
                            showingAdd = true
                        } label: {
                            Label("Přidat ručně", systemImage: "person.badge.plus")
                        }
                        Button {
                            showingImport = true
                        } label: {
                            Label("Importovat z kontaktů", systemImage: "person.2.badge.plus")
                        }
                    } label: {
                        Image(systemName: "plus")
                            .font(.system(size: 17, weight: .semibold))
                    }
                }
            }
            .sheet(isPresented: $showingAdd) { AddPersonView() }
            .sheet(isPresented: $showingImport) { ContactImportView() }
            .sheet(isPresented: $showingSettings) { SettingsView() }
            .sheet(item: $editingPerson) { AddPersonView(editingPerson: $0) }
            .sheet(item: $detailPerson) { PersonDetailView(person: $0) }
            .sheet(item: $giftReminderPerson) { person in
                GiftReminderPickerView(person: person, eventKind: giftReminderEventKind)
            }
            .onAppear {
                handleGiftReminderDeepLink()
                if dailyDigestEnabled {
                    NotificationService.shared.scheduleDailyDigest(
                        hour: dailyDigestHour, minute: dailyDigestMinute, people: people
                    )
                }
            }
        }
    }

    // MARK: – Computed

    private var upcomingEvents: [UpcomingEvent] {
        var events: [UpcomingEvent] = []
        let cal = Calendar.current
        let today = cal.startOfDay(for: Date())
        for person in people {
            if let (m, d) = person.nameDayComponents {
                let next = NameDayService.shared.nextOccurrence(month: m, day: d)
                let days = cal.dateComponents([.day], from: today, to: cal.startOfDay(for: next)).day ?? 0
                events.append(UpcomingEvent(person: person, kind: .nameDay, month: m, day: d, daysUntil: days))
            }
            if let (m, d) = person.birthdayComponents {
                let next = NameDayService.shared.nextOccurrence(month: m, day: d)
                let days = cal.dateComponents([.day], from: today, to: cal.startOfDay(for: next)).day ?? 0
                events.append(UpcomingEvent(person: person, kind: .birthday, month: m, day: d, daysUntil: days))
            }
        }
        return events.sorted { $0.daysUntil < $1.daysUntil }
    }

    // MARK: – Actions

    private func deletePerson(_ person: Person) {
        NotificationService.shared.cancelAll(for: person)
        if let id = person.calendarNameDayId  { CalendarService.shared.removeEvent(id: id) }
        if let id = person.calendarBirthdayId { CalendarService.shared.removeEvent(id: id) }
        if let id = person.calendarPartyId    { CalendarService.shared.removeEvent(id: id) }
        modelContext.delete(person)
    }

    private func handleGiftReminderDeepLink() {
        guard let idStr = UserDefaults.standard.string(forKey: "giftRemindLaterPersonId"),
              let id = UUID(uuidString: idStr),
              let person = people.first(where: { $0.id == id }) else { return }
        UserDefaults.standard.removeObject(forKey: "giftRemindLaterPersonId")
        giftReminderEventKind = UserDefaults.standard.string(forKey: "giftRemindLaterEventKind") ?? "nameday"
        UserDefaults.standard.removeObject(forKey: "giftRemindLaterEventKind")
        giftReminderPerson = person
    }
}

// MARK: – Today card

struct TodayCard: View {
    let allEvents: [UpcomingEvent]
    let onTapPerson: (Person) -> Void

    @State private var showCalendar = false

    private var todayCalendarNames: [String] { NameDayService.shared.todaysNames() }
    private var tomorrowCalendarNames: [String] { NameDayService.shared.tomorrowsNames() }
    private var todayPersonEvents: [UpcomingEvent] { allEvents.filter { $0.isToday } }
    private var zodiac: (name: String, symbol: String) { NameDayService.shared.zodiacSign() }
    private var todayHoliday: String? { NameDayService.shared.publicHoliday() }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {

            // Header row
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text(weekdayStr)
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(.secondary)
                        .textCase(.uppercase)
                    Text(dateStr)
                        .font(.title2.bold())
                    // Znamení zvěrokruhu
                    HStack(spacing: 3) {
                        Image(systemName: "moon.stars.fill")
                            .font(.caption2)
                            .foregroundStyle(.secondary)
                        Text(zodiac.name)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
                Spacer()
                Button { showCalendar = true } label: {
                    Group {
                        if todayPersonEvents.isEmpty {
                            Image(systemName: "calendar")
                                .foregroundStyle(.secondary)
                        } else {
                            Image(systemName: "party.popper.fill")
                                .foregroundStyle(Color.orange)
                        }
                    }
                    .font(.system(size: 28))
                }
                .buttonStyle(.plain)
            }
            .padding(.horizontal, 18)
            .padding(.top, 18)
            .padding(.bottom, 14)
            .sheet(isPresented: $showCalendar) {
                CalendarBrowseView()
                    .presentationDetents([.large])
            }

            Divider().padding(.horizontal, 14)

            // Státní svátek
            if let holiday = todayHoliday {
                HStack(spacing: 6) {
                    Image(systemName: "flag.fill")
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(.red)
                    Text(holiday)
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(.red)
                        .textCase(.uppercase)
                }
                .padding(.horizontal, 18)
                .padding(.top, 14)
            }

            // Svátek z kalendáře
            if !todayCalendarNames.isEmpty {
                VStack(alignment: .leading, spacing: 6) {
                    Label("Svátek dle kalendáře", systemImage: "sun.max.fill")
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(.orange)
                        .textCase(.uppercase)
                    Text(todayCalendarNames.joined(separator: " · "))
                        .font(.title3.bold())
                }
                .padding(.horizontal, 18)
                .padding(.top, todayHoliday != nil ? 8 : 14)
            }

            // Osoby ze seznamu – dnes slaví
            if !todayPersonEvents.isEmpty {
                VStack(spacing: 8) {
                    ForEach(todayPersonEvents) { event in
                        Button { onTapPerson(event.person) } label: {
                            HStack(spacing: 12) {
                                PersonAvatarView(person: event.person, size: 44)
                                VStack(alignment: .leading, spacing: 2) {
                                    Text(event.person.displayName).font(.headline).foregroundStyle(.primary)
                                    Label(event.kindLabel, systemImage: event.kindIcon)
                                        .font(.subheadline)
                                        .foregroundStyle(event.kindColor)
                                }
                                Spacer()
                                Text("Dnes")
                                    .font(.caption.bold())
                                    .padding(.horizontal, 10).padding(.vertical, 5)
                                    .background(event.kindColor.opacity(0.12), in: Capsule())
                                    .foregroundStyle(event.kindColor)
                            }
                            .padding(.horizontal, 14).padding(.vertical, 10)
                            .background(event.kindColor.opacity(0.07), in: RoundedRectangle(cornerRadius: 12))
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.horizontal, 14)
                .padding(.top, 10)
            } else if todayCalendarNames.isEmpty {
                Text("Dnes nikdo neslaví svátek.")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .padding(.horizontal, 18)
                    .padding(.top, 14)
            }

            // Zítřejší teaser
            if !tomorrowCalendarNames.isEmpty {
                Divider().padding(.horizontal, 14).padding(.top, 14)
                HStack(spacing: 6) {
                    Text("Zítra slaví svátek: ")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                    + Text(tomorrowCalendarNames.joined(separator: ", "))
                        .font(.subheadline.bold())
                        .foregroundStyle(.secondary)
                }
                .padding(.horizontal, 18)
                .padding(.top, 10)
            }

            Spacer().frame(height: 18)
        }
        .background(Color(.secondarySystemGroupedBackground), in: RoundedRectangle(cornerRadius: 20))
        .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 4)
    }

    private var weekdayStr: String {
        let f = DateFormatter(); f.locale = Locale(identifier: "cs_CZ"); f.dateFormat = "EEEE"
        return f.string(from: Date())
    }
    private var dateStr: String {
        let f = DateFormatter(); f.locale = Locale(identifier: "cs_CZ"); f.dateFormat = "d. MMMM"
        return f.string(from: Date())
    }
}

// MARK: – Upcoming horizontal strip

struct UpcomingStrip: View {
    let events: [UpcomingEvent]
    let onTap: (UpcomingEvent) -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            SectionHeader(title: "Nadcházející", icon: "calendar.badge.clock")
                .padding(.horizontal)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(events.prefix(15)) { event in
                        Button { onTap(event) } label: {
                            VStack(spacing: 10) {
                                PersonAvatarView(person: event.person, size: 54)
                                Text(event.person.displayName)
                                    .font(.caption.bold())
                                    .lineLimit(1)
                                    .frame(maxWidth: 80)
                                VStack(spacing: 1) {
                                    Text("\(event.daysUntil)")
                                        .font(.headline.bold())
                                        .foregroundStyle(event.kindColor)
                                    Text("dní")
                                        .font(.caption2)
                                        .foregroundStyle(.secondary)
                                }
                                Image(systemName: event.kindIcon)
                                    .font(.caption2)
                                    .foregroundStyle(event.kindColor)
                            }
                            .frame(width: 88)
                            .padding(.vertical, 14)
                            .padding(.horizontal, 4)
                            .background(Color(.secondarySystemGroupedBackground), in: RoundedRectangle(cornerRadius: 16))
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.horizontal)
            }
        }
    }
}

// MARK: – Event card (full-width row)

struct EventCard: View {
    let event: UpcomingEvent

    var body: some View {
        HStack(spacing: 14) {
            PersonAvatarView(person: event.person, size: 52)

            VStack(alignment: .leading, spacing: 4) {
                Text(event.person.displayName).font(.headline)
                HStack(spacing: 5) {
                    Image(systemName: event.kindIcon).font(.caption.weight(.semibold))
                    Text(event.kindLabel).font(.subheadline)
                }
                .foregroundStyle(event.kindColor)
                if !event.isToday {
                    Text(event.formattedDate).font(.caption).foregroundStyle(.secondary)
                }
            }

            Spacer()

            Group {
                if event.isToday {
                    Text("Dnes!")
                        .font(.subheadline.bold())
                        .foregroundStyle(event.kindColor)
                        .padding(.horizontal, 10).padding(.vertical, 6)
                        .background(event.kindColor.opacity(0.12), in: Capsule())
                } else if event.daysUntil == 1 {
                    Text("Zítra")
                        .font(.subheadline.bold())
                        .foregroundStyle(.orange)
                        .padding(.horizontal, 10).padding(.vertical, 6)
                        .background(Color.orange.opacity(0.1), in: Capsule())
                } else {
                    VStack(spacing: 0) {
                        Text("\(event.daysUntil)").font(.title3.bold()).foregroundStyle(event.kindColor)
                        Text("dní").font(.caption2).foregroundStyle(.secondary)
                    }
                    .frame(minWidth: 40)
                }
            }
        }
        .padding(14)
        .background(Color(.secondarySystemGroupedBackground), in: RoundedRectangle(cornerRadius: 16))
    }
}

// MARK: – Unknown person card

struct UnknownPersonCard: View {
    let person: Person
    var body: some View {
        HStack(spacing: 14) {
            PersonAvatarView(person: person, size: 52)
            VStack(alignment: .leading, spacing: 3) {
                Text(person.displayName).font(.headline)
                Label("Žádné datum", systemImage: "questionmark.circle")
                    .font(.subheadline).foregroundStyle(.secondary)
            }
            Spacer()
        }
        .padding(14)
        .background(Color(.secondarySystemGroupedBackground), in: RoundedRectangle(cornerRadius: 16))
    }
}

// MARK: – Empty add card

struct EmptyAddCard: View {
    let onTap: () -> Void
    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 14) {
                ZStack {
                    Circle().fill(Color.accentColor.opacity(0.1)).frame(width: 52, height: 52)
                    Image(systemName: "person.badge.plus")
                        .font(.system(size: 22)).foregroundStyle(Color.accentColor)
                }
                VStack(alignment: .leading, spacing: 3) {
                    Text("Přidat první osobu").font(.headline)
                    Text("Zadej jméno a nastav připomínky").font(.subheadline).foregroundStyle(.secondary)
                }
                Spacer()
                Image(systemName: "chevron.right").foregroundStyle(.secondary).font(.caption)
            }
            .padding(14)
            .background(Color(.secondarySystemGroupedBackground), in: RoundedRectangle(cornerRadius: 16))
        }
        .buttonStyle(.plain)
    }
}

// MARK: – Category filter bar

struct CategoryFilterBar: View {
    @Binding var selected: String?

    private let chips: [(label: String, value: String?, icon: String)] = [
        ("Vše",      nil,        "person.2"),
        ("Rodina",   "Rodina",   "house.fill"),
        ("Práce",    "Práce",    "briefcase.fill"),
        ("Přátelé",  "Přátelé",  "person.2.fill"),
        ("Ostatní",  "Ostatní",  "star.fill"),
    ]

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(chips, id: \.label) { chip in
                    let isActive = selected == chip.value
                    Button {
                        withAnimation(.easeInOut(duration: 0.2)) {
                            selected = chip.value
                        }
                    } label: {
                        Label(chip.label, systemImage: chip.icon)
                            .font(.subheadline.weight(isActive ? .semibold : .regular))
                            .foregroundStyle(isActive ? .white : .primary)
                            .padding(.horizontal, 14)
                            .padding(.vertical, 7)
                            .background(
                                Capsule().fill(isActive ? Color.accentColor : Color(.secondarySystemGroupedBackground))
                            )
                    }
                    .buttonStyle(.plain)
                }
            }
        }
    }
}

// MARK: – Section header

struct SectionHeader: View {
    let title: String
    let icon: String
    var body: some View {
        Label(title, systemImage: icon)
            .font(.subheadline.bold())
            .foregroundStyle(.secondary)
            .textCase(.uppercase)
    }
}

// MARK: – Reusable person avatar (foto nebo emoji)

struct PersonAvatarView: View {
    let person: Person
    let size: CGFloat

    var body: some View {
        Group {
            if let data = person.photoData, let uiImg = UIImage(data: data) {
                Image(uiImage: uiImg)
                    .resizable()
                    .scaledToFill()
                    .frame(width: size, height: size)
                    .clipShape(Circle())
            } else {
                ZStack {
                    Circle()
                        .fill((Color(hex: person.colorHex) ?? .blue).gradient)
                        .frame(width: size, height: size)
                    Text(person.emoji)
                        .font(.system(size: size * 0.48))
                }
            }
        }
    }
}
