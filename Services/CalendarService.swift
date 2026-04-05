import EventKit
import Foundation

final class CalendarService {
    static let shared = CalendarService()
    private let store = EKEventStore()
    private init() {}

    // MARK: – Permission

    func requestPermission() async -> Bool {
        if #available(iOS 17, *) {
            return (try? await store.requestFullAccessToEvents()) ?? false
        } else {
            return await withCheckedContinuation { cont in
                store.requestAccess(to: .event) { granted, _ in cont.resume(returning: granted) }
            }
        }
    }

    // MARK: – Roční opakující se událost (svátek / narozeniny)

    @discardableResult
    func addYearlyEvent(title: String, month: Int, day: Int) -> String? {
        let event = EKEvent(eventStore: store)
        event.title = title
        event.isAllDay = true
        event.calendar = store.defaultCalendarForNewEvents

        var comps = DateComponents()
        comps.month = month; comps.day = day
        comps.year = Calendar.current.component(.year, from: Date())
        guard let date = Calendar.current.date(from: comps) else { return nil }
        event.startDate = date
        event.endDate   = date
        event.recurrenceRules = [EKRecurrenceRule(recurrenceWith: .yearly, interval: 1, end: nil)]

        try? store.save(event, span: .futureEvents, commit: true)
        return event.eventIdentifier
    }

    // MARK: – Roční opakující se oslava (jen měsíc+den+čas)

    @discardableResult
    func addYearlyPartyEvent(title: String, month: Int, day: Int, hour: Int, minute: Int) -> String? {
        let event = EKEvent(eventStore: store)
        event.title    = title
        event.calendar = store.defaultCalendarForNewEvents

        var comps = DateComponents()
        comps.year = Calendar.current.component(.year, from: Date())
        comps.month = month; comps.day = day
        comps.hour = hour; comps.minute = minute
        guard let date = Calendar.current.date(from: comps) else { return nil }
        event.startDate = date
        event.endDate   = date.addingTimeInterval(3 * 3600)
        event.recurrenceRules = [EKRecurrenceRule(recurrenceWith: .yearly, interval: 1, end: nil)]

        try? store.save(event, span: .futureEvents, commit: true)
        return event.eventIdentifier
    }

    // MARK: – Jednorázová událost (oslava)

    @discardableResult
    func addSingleEvent(title: String, startDate: Date, durationHours: Int = 3, notes: String? = nil) -> String? {
        let event = EKEvent(eventStore: store)
        event.title     = title
        event.notes     = notes
        event.calendar  = store.defaultCalendarForNewEvents
        event.startDate = startDate
        event.endDate   = startDate.addingTimeInterval(TimeInterval(durationHours * 3600))

        try? store.save(event, span: .thisEvent, commit: true)
        return event.eventIdentifier
    }

    // MARK: – Smazání

    func removeEvent(id: String) {
        guard let event = store.event(withIdentifier: id) else { return }
        try? store.remove(event, span: .futureEvents, commit: true)
    }
}
