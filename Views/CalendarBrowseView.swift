import SwiftUI
import SwiftData

struct CalendarBrowseView: View {
    @Query private var people: [Person]
    @Environment(\.dismiss) private var dismiss

    @State private var displayedMonth: Date = {
        let cal = Calendar.current
        return cal.date(from: cal.dateComponents([.year, .month], from: Date())) ?? Date()
    }()
    @State private var selectedDate: Date? = Date()

    private let cal: Calendar = {
        var c = Calendar.current
        c.locale = Locale(identifier: "cs_CZ")
        return c
    }()

    private let weekdayLabels = ["Po", "Út", "St", "Čt", "Pá", "So", "Ne"]

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {

                // MARK: – Navigace měsíce
                HStack(spacing: 0) {
                    Button { changeMonth(-1) } label: {
                        Image(systemName: "chevron.left")
                            .font(.title3.weight(.semibold))
                            .frame(width: 44, height: 44)
                    }
                    Spacer()
                    Text(monthYearStr)
                        .font(.title3.bold())
                    Spacer()
                    Button { changeMonth(1) } label: {
                        Image(systemName: "chevron.right")
                            .font(.title3.weight(.semibold))
                            .frame(width: 44, height: 44)
                    }
                }
                .padding(.horizontal, 8)
                .padding(.top, 4)

                // MARK: – Záhlaví dnů
                HStack(spacing: 0) {
                    ForEach(weekdayLabels, id: \.self) { label in
                        Text(label)
                            .font(.caption.bold())
                            .foregroundStyle(.secondary)
                            .frame(maxWidth: .infinity)
                    }
                }
                .padding(.horizontal, 8)
                .padding(.vertical, 6)

                Divider().padding(.horizontal, 8)

                // MARK: – Grid dnů
                let days = daysInMonth()
                LazyVGrid(
                    columns: Array(repeating: GridItem(.flexible(), spacing: 2), count: 7),
                    spacing: 2
                ) {
                    ForEach(0..<days.count, id: \.self) { i in
                        if let date = days[i] {
                            let month = cal.component(.month, from: date)
                            let day   = cal.component(.day,   from: date)
                            let calNames = NameDayService.shared.names(forMonth: month, day: day)
                            let evs = eventsFor(date: date)
                            let isSel = selectedDate.map { cal.isDate($0, inSameDayAs: date) } ?? false
                            let year  = cal.component(.year, from: displayedMonth)
                            let isHoliday = NameDayService.shared.publicHoliday(forMonth: month, day: day, year: year) != nil

                            DayCell(
                                date: date,
                                isSelected: isSel,
                                isToday: cal.isDateInToday(date),
                                isPublicHoliday: isHoliday,
                                nameDayName: calNames.first,
                                events: evs
                            )
                            .onTapGesture { selectedDate = date }
                        } else {
                            Color.clear
                                .frame(height: 68)
                        }
                    }
                }
                .padding(.horizontal, 8)
                .padding(.top, 4)

                Divider().padding(.top, 8)

                // MARK: – Detail vybraného dne
                if let date = selectedDate {
                    DayDetailPanel(
                        date: date,
                        calNames: allNamesFor(date: date),
                        holiday: holidayFor(date: date),
                        events: eventsFor(date: date)
                    )
                } else {
                    Spacer()
                }
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("Kalendář svátků")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Zavřít") { dismiss() }
                }
                ToolbarItem(placement: .primaryAction) {
                    Button("Dnes") {
                        let now = Date()
                        displayedMonth = cal.date(from: cal.dateComponents([.year, .month], from: now)) ?? now
                        selectedDate = now
                    }
                    .font(.subheadline)
                }
            }
        }
    }

    // MARK: – Helpers

    private var monthYearStr: String {
        let f = DateFormatter()
        f.locale = Locale(identifier: "cs_CZ")
        f.dateFormat = "LLLL yyyy"
        let s = f.string(from: displayedMonth)
        return s.prefix(1).uppercased() + s.dropFirst()
    }

    private func changeMonth(_ delta: Int) {
        displayedMonth = cal.date(byAdding: .month, value: delta, to: displayedMonth) ?? displayedMonth
    }

    private func daysInMonth() -> [Date?] {
        let comps = cal.dateComponents([.year, .month], from: displayedMonth)
        guard let firstDay = cal.date(from: comps),
              let range = cal.range(of: .day, in: .month, for: firstDay) else { return [] }

        // Offset: Czech week starts Monday (weekday 2). Sunday=1 → offset 6, Mon=2 → 0, etc.
        let firstWeekday = cal.component(.weekday, from: firstDay)
        let offset = (firstWeekday - 2 + 7) % 7

        var days: [Date?] = Array(repeating: nil, count: offset)
        for day in range {
            if let d = cal.date(byAdding: .day, value: day - 1, to: firstDay) {
                days.append(d)
            }
        }
        while days.count % 7 != 0 { days.append(nil) }
        return days
    }

    private func eventsFor(date: Date) -> [(person: Person, kind: EventKind)] {
        let m = cal.component(.month, from: date)
        let d = cal.component(.day,   from: date)
        var result: [(Person, EventKind)] = []
        for person in people {
            if let (pm, pd) = person.nameDayComponents, pm == m, pd == d {
                result.append((person, .nameDay))
            }
            if let (bm, bd) = person.birthdayComponents, bm == m, bd == d {
                result.append((person, .birthday))
            }
        }
        return result
    }

    private func allNamesFor(date: Date) -> [String] {
        let m = cal.component(.month, from: date)
        let d = cal.component(.day,   from: date)
        return NameDayService.shared.names(forMonth: m, day: d)
    }

    private func holidayFor(date: Date) -> String? {
        NameDayService.shared.publicHoliday(for: date)
    }
}

// MARK: – Typ události (zrcadlí UpcomingEvent.EventKind)

enum EventKind {
    case nameDay, birthday
    var icon: String  { self == .nameDay ? "sun.max.fill" : "birthday.cake.fill" }
    var label: String { self == .nameDay ? "Svátek" : "Narozeniny" }
    var color: Color  { self == .nameDay ? .orange : .pink }
}

// MARK: – Buňka dne

struct DayCell: View {
    let date: Date
    let isSelected: Bool
    let isToday: Bool
    let isPublicHoliday: Bool
    let nameDayName: String?
    let events: [(person: Person, kind: EventKind)]

    private let cal = Calendar.current

    var body: some View {
        VStack(spacing: 2) {
            // Číslo dne
            Text("\(cal.component(.day, from: date))")
                .font(.system(size: 15, weight: isToday || isSelected ? .bold : .regular))
                .foregroundStyle(
                    isSelected ? .white :
                    isToday ? Color.accentColor :
                    isPublicHoliday ? Color.red :
                    Color.primary
                )
                .frame(width: 28, height: 28)
                .background(
                    Circle().fill(isSelected ? Color.accentColor : Color.clear)
                )

            // Jméno svátku
            if let name = nameDayName {
                Text(name)
                    .font(.system(size: 8, weight: .regular))
                    .foregroundStyle(isSelected ? Color.accentColor : .secondary)
                    .lineLimit(1)
                    .truncationMode(.tail)
                    .frame(maxWidth: .infinity)
            } else {
                Color.clear.frame(height: 10)
            }

            // Tečky pro lidi
            if !events.isEmpty {
                HStack(spacing: 2) {
                    ForEach(0..<min(events.count, 3), id: \.self) { i in
                        Circle()
                            .fill(events[i].kind.color)
                            .frame(width: 4, height: 4)
                    }
                }
            } else {
                Color.clear.frame(height: 4)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 4)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(isToday && !isSelected ? Color.accentColor.opacity(0.07) : Color.clear)
        )
    }
}

// MARK: – Detail vybraného dne

struct DayDetailPanel: View {
    let date: Date
    let calNames: [String]
    let holiday: String?
    let events: [(person: Person, kind: EventKind)]

    private let cal: Calendar = {
        var c = Calendar.current
        c.locale = Locale(identifier: "cs_CZ")
        return c
    }()

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 14) {

                // Datum + státní svátek + kalendářní svátek
                HStack(alignment: .top) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(dateStr).font(.headline)
                        if let h = holiday {
                            HStack(spacing: 4) {
                                Image(systemName: "flag.fill").foregroundStyle(.red).font(.caption)
                                Text(h).font(.subheadline.weight(.semibold)).foregroundStyle(.red)
                            }
                        }
                        if !calNames.isEmpty {
                            HStack(spacing: 4) {
                                Image(systemName: "sun.max.fill").foregroundStyle(.orange).font(.caption)
                                Text(calNames.joined(separator: " · ")).font(.subheadline).foregroundStyle(.secondary)
                            }
                        } else if holiday == nil {
                            Text("Žádný svátek dle kalendáře").font(.subheadline).foregroundStyle(.secondary)
                        }
                    }
                    Spacer()
                }
                .padding(.horizontal)
                .padding(.top, 14)

                // Lidé slavící v tento den
                if events.isEmpty {
                    HStack {
                        Spacer()
                        Label("Nikdo ze seznamu neslaví", systemImage: "person.slash")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                        Spacer()
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 14)
                } else {
                    VStack(spacing: 8) {
                        ForEach(0..<events.count, id: \.self) { i in
                            let ev = events[i]
                            HStack(spacing: 12) {
                                PersonAvatarView(person: ev.person, size: 44)
                                VStack(alignment: .leading, spacing: 2) {
                                    Text(ev.person.name).font(.headline)
                                    Label(ev.kind.label, systemImage: ev.kind.icon)
                                        .font(.subheadline)
                                        .foregroundStyle(ev.kind.color)
                                }
                                Spacer()
                                Image(systemName: ev.kind.icon)
                                    .foregroundStyle(ev.kind.color)
                                    .font(.title3)
                            }
                            .padding(12)
                            .background(Color(.secondarySystemGroupedBackground), in: RoundedRectangle(cornerRadius: 12))
                            .padding(.horizontal)
                        }
                    }
                    .padding(.bottom, 14)
                }
            }
        }
        .frame(maxHeight: 200)
    }

    private var dateStr: String {
        let f = DateFormatter()
        f.locale = Locale(identifier: "cs_CZ")
        f.dateFormat = "EEEE d. MMMM yyyy"
        let s = f.string(from: date)
        return s.prefix(1).uppercased() + s.dropFirst()
    }
}
