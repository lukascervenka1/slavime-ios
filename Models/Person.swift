import Foundation
import SwiftData

@Model
class Person {
    var id: UUID
    var name: String
    var lastName: String
    var category: String        // "Rodina" | "Práce" | "Přátelé" | "Ostatní"
    var emoji: String
    var colorHex: String
    var photoData: Data?

    // Svátek
    var customMonth: Int?
    var customDay: Int?

    // Narozeniny
    var birthMonth: Int?
    var birthDay: Int?
    var birthYear: Int?

    // Notifikace – svátek/narozeniny
    var notifyDayBefore: Bool
    var notifyOnDay: Bool
    var notifyHour: Int
    var notifyMinute: Int

    // Dárek
    var giftReminderNameDay: Bool
    var giftDaysBeforeNameDay: Int       // kolik dní před svátkem
    var giftReminderBirthday: Bool
    var giftDaysBeforeBirthday: Int      // kolik dní před narozeninami
    var giftNote: String                 // tip na dárek (volitelná poznámka)

    // Oslava (konkrétní datum + čas)
    var partyDate: Date?
    var partyRepeatsYearly: Bool

    // Výročí
    @Relationship(deleteRule: .cascade, inverse: \Anniversary.person)
    var anniversaries: [Anniversary] = []

    // iOS Kalendář – event identifiers
    var calendarNameDayId: String?
    var calendarBirthdayId: String?
    var calendarPartyId: String?

    var displayName: String { lastName.isEmpty ? name : "\(name) \(lastName)" }

    static let categories = ["Rodina", "Práce", "Přátelé", "Ostatní"]

    init(
        name: String,
        lastName: String = "",
        category: String = "Ostatní",
        emoji: String = "🎂",
        colorHex: String,
        customMonth: Int? = nil,
        customDay: Int? = nil,
        birthMonth: Int? = nil,
        birthDay: Int? = nil,
        birthYear: Int? = nil,
        notifyDayBefore: Bool = true,
        notifyOnDay: Bool = true,
        notifyHour: Int = 9,
        notifyMinute: Int = 0,
        giftReminderNameDay: Bool = false,
        giftDaysBeforeNameDay: Int = 7,
        giftReminderBirthday: Bool = false,
        giftDaysBeforeBirthday: Int = 7,
        giftNote: String = "",
        partyDate: Date? = nil,
        partyRepeatsYearly: Bool = false
    ) {
        self.id = UUID()
        self.name = name
        self.lastName = lastName
        self.category = category
        self.emoji = emoji
        self.colorHex = colorHex
        self.customMonth = customMonth
        self.customDay = customDay
        self.birthMonth = birthMonth
        self.birthDay = birthDay
        self.birthYear = birthYear
        self.notifyDayBefore = notifyDayBefore
        self.notifyOnDay = notifyOnDay
        self.notifyHour = notifyHour
        self.notifyMinute = notifyMinute
        self.giftReminderNameDay = giftReminderNameDay
        self.giftDaysBeforeNameDay = giftDaysBeforeNameDay
        self.giftReminderBirthday = giftReminderBirthday
        self.giftDaysBeforeBirthday = giftDaysBeforeBirthday
        self.giftNote = giftNote
        self.partyDate = partyDate
        self.partyRepeatsYearly = partyRepeatsYearly
    }

    var nameDayComponents: (month: Int, day: Int)? {
        if let m = customMonth, let d = customDay { return (m, d) }
        return NameDayService.shared.nameDay(for: name)
    }

    var birthdayComponents: (month: Int, day: Int)? {
        guard let m = birthMonth, let d = birthDay else { return nil }
        return (m, d)
    }

    static let availableColors: [String] = [
        "#FF6B6B", "#FF9F43", "#FFC107", "#A8E063",
        "#26de81", "#2BCBBA", "#45AAF2", "#4B7BEC",
        "#A55EEA", "#FC5C65", "#8D8D8D", "#2C3E50"
    ]
}
