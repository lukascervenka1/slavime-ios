import Foundation
import UserNotifications

final class NotificationService {
    static let shared = NotificationService()
    private init() {}

    // MARK: – Permission

    func requestPermission() async -> Bool {
        let center = UNUserNotificationCenter.current()
        let settings = await center.notificationSettings()
        switch settings.authorizationStatus {
        case .authorized, .provisional: return true
        case .notDetermined:
            return (try? await center.requestAuthorization(options: [.alert, .sound, .badge])) ?? false
        default: return false
        }
    }

    // MARK: – Schedule all for person

    func scheduleAll(for person: Person) {
        cancelAll(for: person)

        // Svátek
        if let (m, d) = person.nameDayComponents {
            if person.notifyOnDay {
                schedule(id: "\(person.id)-nameday-on",
                         title: "🎉 Dnes má svátek \(person.name)!",
                         body: "Nezapomeň popřát.",
                         month: m, day: d, hour: person.notifyHour, minute: person.notifyMinute)
            }
            if person.notifyDayBefore {
                let (bm, bd) = dayBefore(month: m, day: d)
                schedule(id: "\(person.id)-nameday-before",
                         title: "Zítra má svátek \(person.name)",
                         body: "Připrav si přání na zítra.",
                         month: bm, day: bd, hour: 20, minute: 0)
            }
            if person.giftReminderNameDay {
                scheduleGiftReminder(personId: person.id.uuidString, personName: person.name,
                                     eventMonth: m, eventDay: d,
                                     daysBefore: person.giftDaysBeforeNameDay,
                                     eventKind: "nameday", eventLabel: "svátek")
            }
        }

        // Narozeniny
        if let (m, d) = person.birthdayComponents {
            let ageStr: String = {
                guard let year = person.birthYear else { return "" }
                return " (\(Calendar.current.component(.year, from: Date()) - year + 1) let)"
            }()
            if person.notifyOnDay {
                schedule(id: "\(person.id)-birthday-on",
                         title: "🎂 Dnes má narozeniny \(person.name)\(ageStr)!",
                         body: "Nezapomeň popřát.",
                         month: m, day: d, hour: person.notifyHour, minute: person.notifyMinute)
            }
            if person.notifyDayBefore {
                let (bm, bd) = dayBefore(month: m, day: d)
                schedule(id: "\(person.id)-birthday-before",
                         title: "Zítra má narozeniny \(person.name)",
                         body: "Připrav si přání na zítra.",
                         month: bm, day: bd, hour: 20, minute: 0)
            }
            if person.giftReminderBirthday {
                scheduleGiftReminder(personId: person.id.uuidString, personName: person.name,
                                     eventMonth: m, eventDay: d,
                                     daysBefore: person.giftDaysBeforeBirthday,
                                     eventKind: "birthday", eventLabel: "narozeniny")
            }
        }
    }

    func cancelAll(for person: Person) {
        let center = UNUserNotificationCenter.current()
        let prefix = person.id.uuidString
        center.getPendingNotificationRequests { requests in
            let ids = requests.filter { $0.identifier.hasPrefix(prefix) }.map(\.identifier)
            center.removePendingNotificationRequests(withIdentifiers: ids)
        }
    }

    // MARK: – Gift reminder

    func scheduleGiftReminder(personId: String, personName: String,
                              eventMonth: Int, eventDay: Int,
                              daysBefore: Int, eventKind: String, eventLabel: String) {
        guard let comps = giftReminderComponents(eventMonth: eventMonth, eventDay: eventDay, daysBefore: daysBefore)
        else { return }

        let content = UNMutableNotificationContent()
        content.title = "🎁 Dárek pro \(personName)"
        content.body = "\(personName) má za \(daysBefore) dní \(eventLabel). Už máš dárek?"
        content.sound = .default
        content.categoryIdentifier = "GIFT_REMINDER"
        content.userInfo = ["personId": personId, "eventKind": eventKind]

        let trigger = UNCalendarNotificationTrigger(dateMatching: comps, repeats: true)
        let request = UNNotificationRequest(
            identifier: "\(personId)-gift-\(eventKind)",
            content: content,
            trigger: trigger
        )
        UNUserNotificationCenter.current().add(request)
    }

    /// Naplánuje jednorázovou připomínku na dárek na konkrétní datum (z "Připomenout znovu")
    func scheduleOneTimeGiftReminder(for person: Person, eventKind: String, at date: Date) {
        let content = UNMutableNotificationContent()
        content.title = "🎁 Dárek pro \(person.name)"
        content.body = "Nezapomeň koupit dárek pro \(person.name)!"
        content.sound = .default
        content.categoryIdentifier = "GIFT_REMINDER"
        content.userInfo = ["personId": person.id.uuidString, "eventKind": eventKind]

        let comps = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: date)
        let trigger = UNCalendarNotificationTrigger(dateMatching: comps, repeats: false)
        let request = UNNotificationRequest(
            identifier: "\(person.id)-gift-\(eventKind)-onetime-\(Int(date.timeIntervalSince1970))",
            content: content,
            trigger: trigger
        )
        UNUserNotificationCenter.current().add(request)
    }

    // MARK: – Daily digest

    /// Naplánuje denní ranní přehled na dalších 7 dní.
    /// Volej při každém spuštění aplikace, pokud je funkce zapnuta.
    func scheduleDailyDigest(hour: Int, minute: Int, people: [Person]) {
        cancelDailyDigest()
        let cal = Calendar.current
        let today = cal.startOfDay(for: Date())

        for dayOffset in 0...6 {
            guard let targetDate = cal.date(byAdding: .day, value: dayOffset, to: today) else { continue }
            let month = cal.component(.month, from: targetDate)
            let day   = cal.component(.day,   from: targetDate)

            let calendarNames = NameDayService.shared.names(forMonth: month, day: day)
            let myPeople = people.filter {
                ($0.nameDayComponents?.month == month && $0.nameDayComponents?.day == day) ||
                ($0.birthdayComponents?.month == month && $0.birthdayComponents?.day == day)
            }

            let content = UNMutableNotificationContent()
            content.sound = .default

            if myPeople.isEmpty {
                guard !calendarNames.isEmpty else { continue }
                let names = calendarNames.prefix(4).joined(separator: ", ")
                content.title = dayOffset == 0 ? "Dnes slaví svátek" : "Zítra slaví svátek"
                content.body = names
            } else {
                let nameDayPeople = myPeople.filter {
                    $0.nameDayComponents?.month == month && $0.nameDayComponents?.day == day
                }
                let birthdayPeople = myPeople.filter {
                    $0.birthdayComponents?.month == month && $0.birthdayComponents?.day == day
                }
                var parts: [String] = []
                if !nameDayPeople.isEmpty {
                    parts.append("🎉 Svátek: " + nameDayPeople.map(\.displayName).joined(separator: ", "))
                }
                if !birthdayPeople.isEmpty {
                    parts.append("🎂 Narozeniny: " + birthdayPeople.map(\.displayName).joined(separator: ", "))
                }
                if !calendarNames.isEmpty {
                    parts.append("📅 " + calendarNames.prefix(3).joined(separator: ", "))
                }
                content.title = dayOffset == 0 ? "Slavíme dnes!" : "Slavíme zítra!"
                content.body = parts.joined(separator: "\n")
            }

            var dc = cal.dateComponents([.year, .month, .day], from: targetDate)
            dc.hour = hour; dc.minute = minute
            let trigger = UNCalendarNotificationTrigger(dateMatching: dc, repeats: false)
            let year = cal.component(.year, from: targetDate)
            let id = "daily-digest-\(year)-\(String(format: "%02d", month))-\(String(format: "%02d", day))"
            UNUserNotificationCenter.current().add(
                UNNotificationRequest(identifier: id, content: content, trigger: trigger)
            )
        }
    }

    func cancelDailyDigest() {
        UNUserNotificationCenter.current().getPendingNotificationRequests { requests in
            let ids = requests
                .filter { $0.identifier.hasPrefix("daily-digest-") }
                .map(\.identifier)
            UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ids)
        }
    }

    // MARK: – Private

    private func schedule(id: String, title: String, body: String,
                          month: Int, day: Int, hour: Int, minute: Int) {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = .default

        var dc = DateComponents()
        dc.month = month; dc.day = day; dc.hour = hour; dc.minute = minute
        let trigger = UNCalendarNotificationTrigger(dateMatching: dc, repeats: true)
        UNUserNotificationCenter.current().add(
            UNNotificationRequest(identifier: id, content: content, trigger: trigger)
        )
    }

    private func dayBefore(month: Int, day: Int) -> (Int, Int) {
        var comps = DateComponents()
        comps.month = month; comps.day = day
        comps.year = Calendar.current.component(.year, from: Date())
        let cal = Calendar.current
        guard let date = cal.date(from: comps),
              let prev = cal.date(byAdding: .day, value: -1, to: date) else { return (month, day) }
        return (cal.component(.month, from: prev), cal.component(.day, from: prev))
    }

    private func giftReminderComponents(eventMonth: Int, eventDay: Int, daysBefore: Int) -> DateComponents? {
        var comps = DateComponents()
        comps.month = eventMonth; comps.day = eventDay
        comps.year = Calendar.current.component(.year, from: Date())
        let cal = Calendar.current
        guard let eventDate = cal.date(from: comps),
              let reminderDate = cal.date(byAdding: .day, value: -daysBefore, to: eventDate) else { return nil }
        var result = DateComponents()
        result.month  = cal.component(.month,  from: reminderDate)
        result.day    = cal.component(.day,    from: reminderDate)
        result.hour   = 10
        result.minute = 0
        return result
    }
}
