import SwiftUI

struct PersonDetailView: View {
    let person: Person
    @Environment(\.dismiss) private var dismiss
    @State private var showingEdit = false

    private var origin: NameOrigin? {
        NameOriginService.shared.origin(for: person.name)
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    heroSection

                    if let o = origin {
                        originCard(o)
                    }

                    datesCard

                    if !person.anniversaries.isEmpty {
                        anniversariesCard
                    }

                    if !person.giftNote.isEmpty {
                        giftNoteCard
                    }

                    Spacer(minLength: 24)
                }
                .padding(.horizontal)
                .padding(.top, 8)
            }
            .background(Color(.systemGroupedBackground))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Zavřít") { dismiss() }
                }
                ToolbarItem(placement: .primaryAction) {
                    Button("Upravit") { showingEdit = true }
                        .fontWeight(.semibold)
                }
            }
            .sheet(isPresented: $showingEdit) {
                AddPersonView(editingPerson: person)
            }
        }
    }

    // MARK: – Hero

    private var heroSection: some View {
        VStack(spacing: 14) {
            PersonAvatarView(person: person, size: 96)
            VStack(spacing: 6) {
                Text(person.displayName)
                    .font(.largeTitle.bold())
                    .multilineTextAlignment(.center)
                Label(person.category, systemImage: categoryIcon(person.category))
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(categoryColor(person.category))
                    .padding(.horizontal, 10)
                    .padding(.vertical, 4)
                    .background(categoryColor(person.category).opacity(0.12), in: Capsule())
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 28)
        .background(Color(.secondarySystemGroupedBackground), in: RoundedRectangle(cornerRadius: 20))
    }

    private func categoryIcon(_ cat: String) -> String {
        switch cat {
        case "Rodina":  return "house.fill"
        case "Práce":   return "briefcase.fill"
        case "Přátelé": return "person.2.fill"
        default:        return "star.fill"
        }
    }

    private func categoryColor(_ cat: String) -> Color {
        switch cat {
        case "Rodina":  return .green
        case "Práce":   return .blue
        case "Přátelé": return .orange
        default:        return .purple
        }
    }

    // MARK: – Původ jména

    private func originCard(_ o: NameOrigin) -> some View {
        VStack(alignment: .leading, spacing: 14) {
            Label("Původ jména", systemImage: "book.closed.fill")
                .font(.caption.weight(.semibold))
                .foregroundStyle(.secondary)
                .textCase(.uppercase)

            HStack(alignment: .top, spacing: 12) {
                VStack(alignment: .leading, spacing: 6) {
                    Text(o.language)
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(Color.accentColor)
                        .padding(.horizontal, 9)
                        .padding(.vertical, 3)
                        .background(Color.accentColor.opacity(0.1), in: Capsule())
                    Text(o.meaning)
                        .font(.title3.bold())
                        .fixedSize(horizontal: false, vertical: true)
                }
                Spacer()
                Text(languageEmoji(o.language))
                    .font(.system(size: 44))
            }

            Divider()

            VStack(alignment: .leading, spacing: 6) {
                Label("Zajímavost", systemImage: "lightbulb.fill")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(.orange)
                Text(o.funFact)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
        .padding()
        .background(Color(.secondarySystemGroupedBackground), in: RoundedRectangle(cornerRadius: 16))
    }

    // MARK: – Datum

    private var datesCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            Label("Datum", systemImage: "calendar")
                .font(.caption.weight(.semibold))
                .foregroundStyle(.secondary)
                .textCase(.uppercase)

            if let (m, d) = person.nameDayComponents {
                let days = daysUntil(month: m, day: d)
                dateRow(
                    icon: "sun.max.fill", iconColor: .orange,
                    label: "Svátek",
                    dateStr: "\(d). \(monthName(m))",
                    daysUntil: days
                )
            }

            if let (m, d) = person.birthdayComponents {
                if person.nameDayComponents != nil {
                    Divider()
                }
                let days  = daysUntil(month: m, day: d)
                let zodiac = zodiacFor(month: m, day: d)
                dateRow(
                    icon: "birthday.cake.fill", iconColor: .pink,
                    label: person.birthYear.map { "Narozeniny · slaví \(upcomingAge(birthYear: $0, month: m, day: d)) let" } ?? "Narozeniny",
                    dateStr: person.birthYear.map { "\(d). \(monthName(m)) \($0)" } ?? "\(d). \(monthName(m))",
                    daysUntil: days,
                    subtitle: "\(zodiac.symbol) \(zodiac.name)"
                )
            }

            if person.nameDayComponents == nil && person.birthdayComponents == nil {
                Text("Žádné datum není nastaveno")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
        }
        .padding()
        .background(Color(.secondarySystemGroupedBackground), in: RoundedRectangle(cornerRadius: 16))
    }

    private func dateRow(
        icon: String,
        iconColor: Color,
        label: String,
        dateStr: String,
        daysUntil: Int,
        subtitle: String? = nil
    ) -> some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .foregroundStyle(iconColor)
                .frame(width: 24)
            VStack(alignment: .leading, spacing: 2) {
                Text(label)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                Text(dateStr)
                    .font(.subheadline.weight(.semibold))
                if let subtitle {
                    Text(subtitle)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
            Spacer()
            if daysUntil == 0 {
                Text("Dnes!")
                    .font(.subheadline.bold())
                    .foregroundStyle(iconColor)
                    .padding(.horizontal, 10).padding(.vertical, 5)
                    .background(iconColor.opacity(0.12), in: Capsule())
            } else if daysUntil == 1 {
                Text("Zítra")
                    .font(.subheadline.bold())
                    .foregroundStyle(.orange)
                    .padding(.horizontal, 10).padding(.vertical, 5)
                    .background(Color.orange.opacity(0.1), in: Capsule())
            } else {
                VStack(alignment: .trailing, spacing: 0) {
                    Text("za \(daysUntil)")
                        .font(.headline.bold())
                        .foregroundStyle(iconColor)
                    Text("dní")
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                }
            }
        }
    }

    // MARK: – Výročí

    private var anniversariesCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            Label("Výročí", systemImage: "heart.text.square.fill")
                .font(.caption.weight(.semibold))
                .foregroundStyle(.secondary)
                .textCase(.uppercase)

            ForEach(person.anniversaries.sorted { $0.month < $1.month || ($0.month == $1.month && $0.day < $1.day) }) { ann in
                let days = daysUntil(month: ann.month, day: ann.day)

                if ann.id != person.anniversaries.first?.id {
                    Divider()
                }

                HStack(spacing: 12) {
                    Text(ann.icon)
                        .font(.title3)
                        .frame(width: 24)
                    VStack(alignment: .leading, spacing: 2) {
                        Text(ann.title)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                        Text(anniversaryDateString(ann))
                            .font(.subheadline.weight(.semibold))
                        if let year = ann.year {
                            let nextDate = NameDayService.shared.nextOccurrence(month: ann.month, day: ann.day)
                            let eventYear = Calendar.current.component(.year, from: nextDate)
                            let count = eventYear - year
                            Text("\(count). výročí")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    }
                    Spacer()
                    if days == 0 {
                        Text("Dnes!")
                            .font(.subheadline.bold())
                            .foregroundStyle(Color.pink)
                            .padding(.horizontal, 10).padding(.vertical, 5)
                            .background(Color.pink.opacity(0.12), in: Capsule())
                    } else if days == 1 {
                        Text("Zítra")
                            .font(.subheadline.bold())
                            .foregroundStyle(.orange)
                            .padding(.horizontal, 10).padding(.vertical, 5)
                            .background(Color.orange.opacity(0.1), in: Capsule())
                    } else {
                        VStack(alignment: .trailing, spacing: 0) {
                            Text("za \(days)")
                                .font(.headline.bold())
                                .foregroundStyle(Color.pink)
                            Text("dní")
                                .font(.caption2)
                                .foregroundStyle(.secondary)
                        }
                    }
                }
            }
        }
        .padding()
        .background(Color(.secondarySystemGroupedBackground), in: RoundedRectangle(cornerRadius: 16))
    }

    private func anniversaryDateString(_ ann: Anniversary) -> String {
        var comps = DateComponents()
        comps.month = ann.month; comps.day = ann.day; comps.year = 2024
        guard let date = Calendar.current.date(from: comps) else { return "" }
        let f = DateFormatter(); f.locale = Locale(identifier: "cs_CZ"); f.dateFormat = "d. MMMM"
        var parts = [f.string(from: date)]
        if let y = ann.year { parts.append(String(y)) }
        return parts.joined(separator: " ")
    }

    // MARK: – Tip na dárek

    private var giftNoteCard: some View {
        VStack(alignment: .leading, spacing: 10) {
            Label("Tip na dárek", systemImage: "gift.fill")
                .font(.caption.weight(.semibold))
                .foregroundStyle(.secondary)
                .textCase(.uppercase)
            Text(person.giftNote)
                .font(.subheadline)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(.secondarySystemGroupedBackground), in: RoundedRectangle(cornerRadius: 16))
    }

    // MARK: – Helpers

    private func zodiacFor(month: Int, day: Int) -> (name: String, symbol: String) {
        var c = DateComponents()
        c.year = 2024; c.month = month; c.day = day
        let date = Calendar.current.date(from: c) ?? Date()
        return NameDayService.shared.zodiacSign(for: date)
    }

    private func daysUntil(month: Int, day: Int) -> Int {
        let next = NameDayService.shared.nextOccurrence(month: month, day: day)
        let cal = Calendar.current
        return cal.dateComponents(
            [.day],
            from: cal.startOfDay(for: Date()),
            to: cal.startOfDay(for: next)
        ).day ?? 0
    }

    /// Věk, který osoba oslaví na svých příštích narozeninách
    private func upcomingAge(birthYear: Int, month: Int, day: Int) -> Int {
        let cal = Calendar.current
        let today = Date()
        let currentYear  = cal.component(.year,  from: today)
        let currentMonth = cal.component(.month, from: today)
        let currentDay   = cal.component(.day,   from: today)
        // Narozeniny letos ještě nenastaly (nebo jsou dnes) → slaví letos
        if currentMonth < month || (currentMonth == month && currentDay <= day) {
            return currentYear - birthYear
        }
        // Narozeniny letos už proběhly → slaví příští rok
        return currentYear + 1 - birthYear
    }

    private func monthName(_ m: Int) -> String {
        let f = DateFormatter()
        f.locale = Locale(identifier: "cs_CZ")
        f.dateFormat = "MMMM"
        var c = DateComponents(); c.month = m; c.day = 1; c.year = 2024
        return f.string(from: Calendar.current.date(from: c) ?? Date())
    }

    private func languageEmoji(_ lang: String) -> String {
        if lang.contains("Hebrej")                    { return "📜" }
        if lang.contains("Řeck")                      { return "🏛️" }
        if lang.contains("Latin")                     { return "🏛️" }
        if lang.contains("Germán") || lang.contains("Anglosas") { return "⚔️" }
        if lang.contains("Slovan")                    { return "🌿" }
        if lang.contains("Severk") || lang.contains("Skandin")  { return "❄️" }
        if lang.contains("Kelt")                      { return "☘️" }
        if lang.contains("Aramej")                    { return "📜" }
        if lang.contains("Frank")                     { return "⚔️" }
        return "🌍"
    }
}
