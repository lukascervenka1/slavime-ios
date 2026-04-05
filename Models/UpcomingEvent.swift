import Foundation
import SwiftUI

struct UpcomingEvent: Identifiable {
    enum Kind {
        case nameDay
        case birthday
    }

    let id = UUID()
    let person: Person
    let kind: Kind
    let month: Int
    let day: Int
    let daysUntil: Int

    var isToday: Bool { daysUntil == 0 }
    var isTomorrow: Bool { daysUntil == 1 }

    var kindLabel: String {
        switch kind {
        case .nameDay: return "Svátek"
        case .birthday:
            if let year = person.birthYear {
                // Rok příští occurrence = správný rok pro výpočet věku
                let nextOcc = NameDayService.shared.nextOccurrence(month: month, day: day)
                let eventYear = Calendar.current.component(.year, from: nextOcc)
                let age = eventYear - year
                return "Narozeniny · \(age) let"
            }
            return "Narozeniny"
        }
    }

    var kindIcon: String {
        switch kind {
        case .nameDay: return "sun.max.fill"
        case .birthday: return "birthday.cake.fill"
        }
    }

    var kindColor: Color {
        switch kind {
        case .nameDay: return Color(hex: person.colorHex) ?? .blue
        case .birthday: return .pink
        }
    }

    var formattedDate: String {
        var comps = DateComponents()
        comps.month = month
        comps.day = day
        comps.year = Calendar.current.component(.year, from: Date())
        guard let date = Calendar.current.date(from: comps) else { return "" }
        let fmt = DateFormatter()
        fmt.locale = Locale(identifier: "cs_CZ")
        fmt.dateFormat = "d. MMMM"
        return fmt.string(from: date)
    }
}
