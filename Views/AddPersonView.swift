import SwiftUI
import SwiftData
import PhotosUI

struct AddPersonView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss

    var editingPerson: Person? = nil

    // Identity
    @State private var name = ""
    @State private var lastName = ""
    @State private var selectedCategory = "Ostatní"
    @State private var emoji = "🎂"
    @State private var selectedColorHex = Person.availableColors[6]

    // Foto
    @State private var photoData: Data? = nil
    @State private var photoPickerItem: PhotosPickerItem? = nil
    @State private var showAvatarOptions = false
    @State private var showEmojiPicker = false
    @State private var showPhotoPicker = false

    // Svátek
    @State private var useCustomNameDay = false
    @State private var nameDayMonth = 1
    @State private var nameDayDay = 1
    @State private var suggestions: [(month: Int, day: Int, name: String)] = []

    // Narozeniny
    @State private var hasBirthday = false
    @State private var birthDate = Calendar.current.date(byAdding: .year, value: -30, to: Date()) ?? Date()
    @State private var includeYear = true

    // Dárek
    @State private var giftForNameDay = false
    @State private var giftDaysNameDay = 7
    @State private var giftForBirthday = false
    @State private var giftDaysBirthday = 7
    @State private var giftNote = ""

    // Výročí
    @State private var anniversaries: [(title: String, icon: String, month: Int, day: Int, year: Int?)] = []
    @State private var showAddAnniversary = false

    // Oslava
    @State private var hasParty = false
    @State private var partyDate = Calendar.current.date(bySettingHour: 17, minute: 0, second: 0, of: Date()) ?? Date()
    @State private var partyRepeatsYearly = false

    // Notifikace
    @State private var notifyDayBefore = true
    @State private var notifyOnDay = true
    @State private var notifyTime = Calendar.current.date(bySettingHour: 9, minute: 0, second: 0, of: Date()) ?? Date()

    // Kalendář
    @State private var addToCalendar = true

    private let months = ["Leden","Únor","Březen","Duben","Květen","Červen",
                          "Červenec","Srpen","Září","Říjen","Listopad","Prosinec"]

    var body: some View {
        NavigationStack {
            Form {

                // MARK: – Avatar
                Section {
                    VStack(spacing: 16) {
                        // Avatar tlačítko
                        Button { showAvatarOptions = true } label: {
                            ZStack(alignment: .bottomTrailing) {
                                avatarPreview
                                // edit badge
                                ZStack {
                                    Circle().fill(Color(.systemBackground)).frame(width: 28, height: 28)
                                    Image(systemName: "pencil.circle.fill")
                                        .font(.system(size: 26))
                                        .foregroundStyle(.blue)
                                }
                                .offset(x: 4, y: 4)
                            }
                        }
                        .buttonStyle(.plain)
                        .confirmationDialog("Změnit avatar", isPresented: $showAvatarOptions, titleVisibility: .visible) {
                            Button("Fotka z galerie") { showPhotoPicker = true }
                            Button("Vybrat emoji") { showEmojiPicker = true }
                            if photoData != nil {
                                Button("Odebrat fotku", role: .destructive) { photoData = nil }
                            }
                            Button("Zrušit", role: .cancel) {}
                        }
                        .photosPicker(isPresented: $showPhotoPicker, selection: $photoPickerItem, matching: .images)
                        .onChange(of: photoPickerItem) { _, item in
                            Task {
                                if let data = try? await item?.loadTransferable(type: Data.self) {
                                    photoData = data
                                }
                            }
                        }

                        TextField("Jméno", text: $name)
                            .font(.title3)
                            .multilineTextAlignment(.center)
                            .onChange(of: name) { _, v in
                                suggestions = NameDayService.shared.suggestions(for: v)
                            }
                        TextField("Příjmení (volitelné)", text: $lastName)
                            .font(.subheadline)
                            .multilineTextAlignment(.center)
                            .foregroundStyle(.secondary)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 8)
                    .listRowBackground(Color.clear)

                    // Suggestions
                    if !suggestions.isEmpty && !name.isEmpty {
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 8) {
                                ForEach(suggestions.prefix(8), id: \.name) { s in
                                    Button {
                                        name = s.name; suggestions = []
                                    } label: {
                                        Text(s.name)
                                            .font(.subheadline)
                                            .padding(.horizontal, 12).padding(.vertical, 6)
                                            .background(Color.secondary.opacity(0.15), in: Capsule())
                                    }
                                    .buttonStyle(.plain)
                                }
                            }
                        }
                        .listRowBackground(Color.clear)
                        .listRowInsets(EdgeInsets())
                    }
                }

                // MARK: – Barva
                Section("Barva") {
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 6), spacing: 12) {
                        ForEach(Person.availableColors, id: \.self) { hex in
                            Button { selectedColorHex = hex } label: {
                                ZStack {
                                    Circle()
                                        .fill(Color(hex: hex)?.gradient ?? Color.blue.gradient)
                                        .frame(width: 36, height: 36)
                                    if hex == selectedColorHex {
                                        Image(systemName: "checkmark").font(.caption.bold()).foregroundStyle(.white)
                                    }
                                }
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    .padding(.vertical, 4)
                }

                // MARK: – Kategorie
                Section {
                    Picker("Kategorie", selection: $selectedCategory) {
                        ForEach(Person.categories, id: \.self) { cat in
                            Text(cat).tag(cat)
                        }
                    }
                    .pickerStyle(.segmented)
                    .listRowBackground(Color.clear)
                    .listRowInsets(EdgeInsets(top: 6, leading: 0, bottom: 6, trailing: 0))
                } header: {
                    Label("Kategorie", systemImage: "tag.fill").textCase(nil)
                }

                // MARK: – Svátek
                Section {
                    Toggle("Zadat datum ručně", isOn: $useCustomNameDay)
                    if useCustomNameDay {
                        Picker("Měsíc", selection: $nameDayMonth) {
                            ForEach(1...12, id: \.self) { Text(months[$0-1]).tag($0) }
                        }
                        Picker("Den", selection: $nameDayDay) {
                            ForEach(1...daysInMonth(nameDayMonth), id: \.self) { Text("\($0).").tag($0) }
                        }
                    } else if let found = detectedNameDay {
                        LabeledContent("Nalezeno") { Text(found).foregroundStyle(.secondary) }
                    } else if !name.isEmpty {
                        LabeledContent("Svátek") { Text("Nenalezeno – zadej ručně").foregroundStyle(.orange) }
                    }
                } header: {
                    Label("Svátek", systemImage: "sun.max.fill").textCase(nil)
                }

                // MARK: – Narozeniny
                Section {
                    Toggle("Přidat narozeniny", isOn: $hasBirthday.animation())
                    if hasBirthday {
                        Toggle("Zahrnout rok (věk)", isOn: $includeYear)
                        DatePicker(
                            "Datum narození",
                            selection: $birthDate,
                            in: ...Date(),
                            displayedComponents: [.date]
                        )
                    }
                } header: {
                    Label("Narozeniny", systemImage: "birthday.cake.fill").textCase(nil)
                }

                // MARK: – Oslava
                Section {
                    Toggle("Přidat datum oslavy", isOn: $hasParty.animation())
                    if hasParty {
                        DatePicker(
                            "Datum a čas oslavy",
                            selection: $partyDate,
                            displayedComponents: [.date, .hourAndMinute]
                        )
                    }
                } header: {
                    Label("Oslava", systemImage: "balloon.2.fill").textCase(nil)
                } footer: {
                    if hasParty { Text("Datum oslavy se automaticky přidá do Kalendáře.") }
                }

                // MARK: – Výročí
                Section {
                    ForEach(anniversaries.indices, id: \.self) { i in
                        HStack(spacing: 12) {
                            Text(anniversaries[i].icon).font(.title3)
                            VStack(alignment: .leading, spacing: 2) {
                                Text(anniversaries[i].title).font(.subheadline)
                                Text(anniversaryDateString(month: anniversaries[i].month,
                                                           day: anniversaries[i].day,
                                                           year: anniversaries[i].year))
                                    .font(.caption).foregroundStyle(.secondary)
                            }
                            Spacer()
                            Button(role: .destructive) {
                                anniversaries.remove(at: i)
                            } label: {
                                Image(systemName: "trash")
                                    .foregroundStyle(.red)
                                    .font(.subheadline)
                            }
                            .buttonStyle(.plain)
                        }
                    }

                    Button {
                        showAddAnniversary = true
                    } label: {
                        Label("Přidat výročí", systemImage: "plus.circle")
                    }
                } header: {
                    Label("Výročí", systemImage: "heart.text.square.fill").textCase(nil)
                }
                .sheet(isPresented: $showAddAnniversary) {
                    AnniversaryPickerView { title, icon, month, day, year in
                        anniversaries.append((title: title, icon: icon, month: month, day: day, year: year))
                    }
                }

                // MARK: – Dárek
                Section {
                    if nameDayComponents != nil {
                        Toggle("Připomínka na dárek – svátek", isOn: $giftForNameDay.animation())
                        if giftForNameDay {
                            Stepper("Za \(giftDaysNameDay) dní předem", value: $giftDaysNameDay, in: 1...60)
                        }
                    }
                    if hasBirthday {
                        Toggle("Připomínka na dárek – narozeniny", isOn: $giftForBirthday.animation())
                        if giftForBirthday {
                            Stepper("Za \(giftDaysBirthday) dní předem", value: $giftDaysBirthday, in: 1...60)
                        }
                    }
                    if nameDayComponents == nil && !hasBirthday {
                        Text("Nejprve zadej svátek nebo narozeniny.")
                            .foregroundStyle(.secondary).font(.subheadline)
                    }
                    // Poznámka – tip na dárek
                    TextField("Tip na dárek (volitelné)…", text: $giftNote, axis: .vertical)
                        .lineLimit(2...4)
                        .font(.subheadline)
                } header: {
                    Label("Dárek", systemImage: "gift.fill").textCase(nil)
                } footer: {
                    Text("Notifikace se zeptá \"Už máš dárek?\" s možností potvrdit nebo přeplánovat.")
                }

                // MARK: – Notifikace
                Section("Notifikace") {
                    Toggle("Den před (20:00)", isOn: $notifyDayBefore)
                    Toggle("V den události", isOn: $notifyOnDay)
                    if notifyOnDay {
                        DatePicker("Čas", selection: $notifyTime, displayedComponents: .hourAndMinute)
                    }
                }

                // MARK: – Kalendář
                Section {
                    Toggle("Přidat svátek/narozeniny do Kalendáře", isOn: $addToCalendar)
                } header: {
                    Label("iOS Kalendář", systemImage: "calendar").textCase(nil)
                }
            }
            .navigationTitle(editingPerson == nil ? "Přidat osobu" : "Upravit osobu")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) { Button("Zrušit") { dismiss() } }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Uložit") { save() }
                        .disabled(name.trimmingCharacters(in: .whitespaces).isEmpty)
                        .bold()
                }
            }
            .sheet(isPresented: $showEmojiPicker) {
                EmojiPickerView(selectedEmoji: $emoji).presentationDetents([.medium, .large])
            }
            .onAppear { loadEditing() }
        }
    }

    // MARK: – Party date month/day bindings (pro roční opakování)

    private var partyMonthBinding: Binding<Int> {
        Binding(
            get: { Calendar.current.component(.month, from: partyDate) },
            set: { m in
                let d = Calendar.current.component(.day, from: partyDate)
                let h = Calendar.current.component(.hour, from: partyDate)
                let min = Calendar.current.component(.minute, from: partyDate)
                var c = DateComponents()
                c.year = Calendar.current.component(.year, from: Date())
                c.month = m; c.day = d; c.hour = h; c.minute = min
                partyDate = Calendar.current.date(from: c) ?? partyDate
            }
        )
    }

    private var partyDayBinding: Binding<Int> {
        Binding(
            get: { Calendar.current.component(.day, from: partyDate) },
            set: { d in
                let m = Calendar.current.component(.month, from: partyDate)
                let h = Calendar.current.component(.hour, from: partyDate)
                let min = Calendar.current.component(.minute, from: partyDate)
                var c = DateComponents()
                c.year = Calendar.current.component(.year, from: Date())
                c.month = m; c.day = d; c.hour = h; c.minute = min
                partyDate = Calendar.current.date(from: c) ?? partyDate
            }
        )
    }

    // MARK: – Avatar preview

    @ViewBuilder
    private var avatarPreview: some View {
        if let data = photoData, let uiImg = UIImage(data: data) {
            Image(uiImage: uiImg)
                .resizable()
                .scaledToFill()
                .frame(width: 90, height: 90)
                .clipShape(Circle())
        } else {
            ZStack {
                Circle()
                    .fill((Color(hex: selectedColorHex) ?? .blue).gradient)
                    .frame(width: 90, height: 90)
                Text(emoji).font(.system(size: 44))
            }
        }
    }

    // MARK: – Helpers

    private var nameDayComponents: (month: Int, day: Int)? {
        if useCustomNameDay { return (nameDayMonth, nameDayDay) }
        return NameDayService.shared.nameDay(for: name)
    }

    private var detectedNameDay: String? {
        guard !name.isEmpty, let (m, d) = NameDayService.shared.nameDay(for: name) else { return nil }
        return formatDate(month: m, day: d)
    }

    private func formatDate(month: Int, day: Int) -> String {
        var c = DateComponents(); c.month = month; c.day = day
        c.year = Calendar.current.component(.year, from: Date())
        guard let date = Calendar.current.date(from: c) else { return "" }
        let f = DateFormatter(); f.locale = Locale(identifier: "cs_CZ"); f.dateFormat = "d. MMMM"
        return f.string(from: date)
    }

    private func anniversaryDateString(month: Int, day: Int, year: Int?) -> String {
        var parts: [String] = []
        var c = DateComponents(); c.month = month; c.day = day; c.year = 2024
        if let date = Calendar.current.date(from: c) {
            let f = DateFormatter(); f.locale = Locale(identifier: "cs_CZ"); f.dateFormat = "d. MMMM"
            parts.append(f.string(from: date))
        }
        if let y = year { parts.append(String(y)) }
        return parts.joined(separator: " ")
    }

    private func daysInMonth(_ month: Int) -> Int {
        var c = DateComponents(); c.year = 2024; c.month = month
        return Calendar.current.range(of: .day, in: .month, for: Calendar.current.date(from: c)!)?.count ?? 31
    }

    private func loadEditing() {
        guard let p = editingPerson else { return }
        name = p.name; lastName = p.lastName; selectedCategory = p.category
        emoji = p.emoji; selectedColorHex = p.colorHex
        photoData = p.photoData
        notifyDayBefore = p.notifyDayBefore; notifyOnDay = p.notifyOnDay
        notifyTime = Calendar.current.date(bySettingHour: p.notifyHour, minute: p.notifyMinute, second: 0, of: Date()) ?? Date()
        if let m = p.customMonth, let d = p.customDay {
            useCustomNameDay = true; nameDayMonth = m; nameDayDay = d
        }
        if let m = p.birthMonth, let d = p.birthDay {
            hasBirthday = true
            var c = DateComponents(); c.month = m; c.day = d
            c.year = p.birthYear ?? Calendar.current.component(.year, from: Date())
            birthDate = Calendar.current.date(from: c) ?? Date()
            includeYear = p.birthYear != nil
        }
        giftForNameDay = p.giftReminderNameDay; giftDaysNameDay = p.giftDaysBeforeNameDay
        giftForBirthday = p.giftReminderBirthday; giftDaysBirthday = p.giftDaysBeforeBirthday
        giftNote = p.giftNote
        if let pd = p.partyDate { hasParty = true; partyDate = pd }
        partyRepeatsYearly = p.partyRepeatsYearly
        anniversaries = p.anniversaries.map { (title: $0.title, icon: $0.icon, month: $0.month, day: $0.day, year: $0.year) }
    }

    private func save() {
        let cal = Calendar.current
        let trimmed = name.trimmingCharacters(in: .whitespaces)
        let hour = cal.component(.hour, from: notifyTime)
        let minute = cal.component(.minute, from: notifyTime)
        let bMonth = hasBirthday ? cal.component(.month, from: birthDate) : nil
        let bDay   = hasBirthday ? cal.component(.day,   from: birthDate) : nil
        let bYear  = (hasBirthday && includeYear) ? cal.component(.year, from: birthDate) : nil

        let person: Person
        if let existing = editingPerson {
            if let id = existing.calendarNameDayId  { CalendarService.shared.removeEvent(id: id) }
            if let id = existing.calendarBirthdayId { CalendarService.shared.removeEvent(id: id) }
            if let id = existing.calendarPartyId    { CalendarService.shared.removeEvent(id: id) }
            existing.name = trimmed; existing.lastName = lastName.trimmingCharacters(in: .whitespaces)
            existing.category = selectedCategory
            existing.emoji = emoji; existing.colorHex = selectedColorHex
            existing.photoData = photoData
            existing.customMonth = useCustomNameDay ? nameDayMonth : nil
            existing.customDay   = useCustomNameDay ? nameDayDay   : nil
            existing.birthMonth = bMonth; existing.birthDay = bDay; existing.birthYear = bYear
            existing.notifyDayBefore = notifyDayBefore; existing.notifyOnDay = notifyOnDay
            existing.notifyHour = hour; existing.notifyMinute = minute
            existing.giftReminderNameDay = giftForNameDay; existing.giftDaysBeforeNameDay = giftDaysNameDay
            existing.giftReminderBirthday = giftForBirthday; existing.giftDaysBeforeBirthday = giftDaysBirthday
            existing.giftNote = giftNote
            existing.partyDate = hasParty ? partyDate : nil
            existing.partyRepeatsYearly = partyRepeatsYearly
            person = existing
        } else {
            person = Person(
                name: trimmed,
                lastName: lastName.trimmingCharacters(in: .whitespaces),
                category: selectedCategory,
                emoji: emoji, colorHex: selectedColorHex,
                customMonth: useCustomNameDay ? nameDayMonth : nil,
                customDay:   useCustomNameDay ? nameDayDay   : nil,
                birthMonth: bMonth, birthDay: bDay, birthYear: bYear,
                notifyDayBefore: notifyDayBefore, notifyOnDay: notifyOnDay,
                notifyHour: hour, notifyMinute: minute,
                giftReminderNameDay: giftForNameDay, giftDaysBeforeNameDay: giftDaysNameDay,
                giftReminderBirthday: giftForBirthday, giftDaysBeforeBirthday: giftDaysBirthday,
                giftNote: giftNote,
                partyDate: hasParty ? partyDate : nil
            )
            person.photoData = photoData
            modelContext.insert(person)
        }

        // Synchronizuj výročí
        let existing = person.anniversaries
        for ann in existing { modelContext.delete(ann) }
        for a in anniversaries {
            let ann = Anniversary(title: a.title, icon: a.icon, month: a.month, day: a.day, year: a.year)
            ann.person = person
            modelContext.insert(ann)
        }

        try? modelContext.save()

        Task {
            if await NotificationService.shared.requestPermission() {
                NotificationService.shared.scheduleAll(for: person)
            }
            if addToCalendar, await CalendarService.shared.requestPermission() {
                if let (m, d) = person.nameDayComponents {
                    person.calendarNameDayId = CalendarService.shared.addYearlyEvent(
                        title: "🎉 Svátek – \(person.displayName)", month: m, day: d)
                }
                if let (m, d) = person.birthdayComponents {
                    person.calendarBirthdayId = CalendarService.shared.addYearlyEvent(
                        title: "🎂 Narozeniny – \(person.displayName)", month: m, day: d)
                }
                if let pd = person.partyDate {
                    person.calendarPartyId = CalendarService.shared.addSingleEvent(
                        title: "🎉 Oslava – \(person.displayName)",
                        startDate: pd,
                        notes: "Oslava přidána přes aplikaci Slavíme.")
                }
            }
        }
        dismiss()
    }
}

// MARK: – Anniversary picker

struct AnniversaryPickerView: View {
    var onSave: (String, String, Int, Int, Int?) -> Void
    @Environment(\.dismiss) private var dismiss

    @State private var selectedPresetId = Anniversary.presets[0].id
    @State private var customTitle = ""
    @State private var date = Calendar.current.date(byAdding: .year, value: -1, to: Date()) ?? Date()
    @State private var includeYear = true

    private var selectedPreset: AnniversaryPreset {
        Anniversary.presets.first { $0.id == selectedPresetId } ?? Anniversary.presets[0]
    }
    private var isCustom: Bool { selectedPresetId == "custom" }

    @ViewBuilder
    private func presetRows() -> some View {
        ForEach(Anniversary.presets, id: \.id) { (preset: AnniversaryPreset) in
            Button {
                selectedPresetId = preset.id
                if preset.id != "custom" { customTitle = "" }
            } label: {
                HStack(spacing: 14) {
                    Text(preset.icon).font(.title3).frame(width: 28)
                    Text(preset.title).foregroundStyle(.primary)
                    Spacer()
                    if preset.id == selectedPresetId {
                        Image(systemName: "checkmark")
                            .foregroundStyle(Color.accentColor)
                            .fontWeight(.semibold)
                    }
                }
            }
            .buttonStyle(.plain)
        }
    }

    var body: some View {
        NavigationStack {
            Form {
                Section("Typ výročí") {
                    presetRows()
                }

                if isCustom {
                    Section("Název") {
                        TextField("Název výročí", text: $customTitle)
                    }
                }

                Section("Datum") {
                    Toggle("Zahrnout rok (počet let)", isOn: $includeYear)
                    DatePicker(
                        "Datum",
                        selection: $date,
                        in: ...Date(),
                        displayedComponents: [.date]
                    )
                }
            }
            .navigationTitle("Přidat výročí")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) { Button("Zrušit") { dismiss() } }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Přidat") {
                        let cal = Calendar.current
                        let m = cal.component(.month, from: date)
                        let d = cal.component(.day,   from: date)
                        let y = includeYear ? cal.component(.year, from: date) : nil
                        let title = isCustom
                            ? (customTitle.trimmingCharacters(in: .whitespaces).isEmpty ? "Výročí" : customTitle.trimmingCharacters(in: .whitespaces))
                            : selectedPreset.title
                        onSave(title, selectedPreset.icon, m, d, y)
                        dismiss()
                    }
                    .bold()
                }
            }
        }
    }
}

// MARK: – Emoji picker

struct EmojiPickerView: View {
    @Binding var selectedEmoji: String
    @Environment(\.dismiss) private var dismiss

    let sections: [(title: String, emojis: [String])] = [
        ("Oslavy", ["🎂","🎉","🎁","🥳","🎊","🎈","🎀","🥂","🧁","🍰","🪅","🧨","🎆","🎇","✨","🌟"]),
        ("Lidé",   ["👤","👩","👨","🧑","👧","👦","👵","👴","👩‍🦱","👨‍🦱","👩‍🦳","👨‍🦳","👩‍🦰","👨‍🦰","🧔","🧒"]),
        ("Profese",["👩‍💻","👨‍💻","🧑‍🎤","👩‍🍳","👨‍🍳","👩‍⚕️","👨‍⚕️","👩‍🏫","👨‍🏫","👩‍🎨","👨‍🎨","🧑‍🚀","👷","💼","🎓","👑"]),
        ("Srdce",  ["❤️","🩷","🧡","💛","💚","💙","💜","🖤","🤍","🤎","💕","💞","💓","💗","💝","💘"]),
        ("Příroda",["🌸","🌺","🌹","🌻","🌼","🌷","🍀","🌿","🌈","☀️","🌙","⭐","🌊","🏔️","🌴","🦋"]),
        ("Zvířata",["🐶","🐱","🐰","🦊","🐼","🐨","🦁","🐸","🐧","🦄","🐯","🐻","🐺","🦝","🐹","🦜"]),
        ("Aktivity",["⚽","🏀","🎾","🏊","🎯","🎮","🎵","🎸","🎨","✈️","🏖️","🧗","🚴","🏋️","🎭","🎬"]),
        ("Jídlo",  ["🍕","🍔","🌮","🍣","🍜","🍦","🍫","🍓","🍇","🍉","☕","🧃","🍺","🍷","🥤","🧋"]),
        ("Symboly",["💎","🏆","🥇","🔮","🪄","💌","📸","🎀","🌠","⚡","🔥","💫","🌀","🎯","🎲","🃏"]),
    ]

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    ForEach(sections, id: \.title) { section in
                        VStack(alignment: .leading, spacing: 10) {
                            Text(section.title)
                                .font(.caption.bold())
                                .foregroundStyle(.secondary)
                                .textCase(.uppercase)
                                .padding(.horizontal)

                            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 8), spacing: 8) {
                                ForEach(section.emojis, id: \.self) { e in
                                    Button {
                                        selectedEmoji = e; dismiss()
                                    } label: {
                                        Text(e)
                                            .font(.system(size: 30))
                                            .padding(6)
                                            .background(
                                                selectedEmoji == e
                                                    ? Color.accentColor.opacity(0.2)
                                                    : Color.clear,
                                                in: RoundedRectangle(cornerRadius: 8)
                                            )
                                    }
                                    .buttonStyle(.plain)
                                }
                            }
                            .padding(.horizontal)
                        }
                    }
                }
                .padding(.vertical)
            }
            .navigationTitle("Vyber emoji")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Zavřít") { dismiss() }
                }
            }
        }
    }
}
