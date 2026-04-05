import SwiftUI
import SwiftData
import UserNotifications

@main
struct SvatekApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        WindowGroup {
            ContentView()
                .modelContainer(Self.makeContainer())
        }
    }

    // Pokud SwiftData selže na migraci (změna modelu), smaže starý store a začne znovu.
    private static func makeContainer() -> ModelContainer {
        do {
            return try ModelContainer(for: Person.self)
        } catch {
            let storeURL = URL.applicationSupportDirectory.appending(path: "default.store")
            try? FileManager.default.removeItem(at: storeURL)
            return try! ModelContainer(for: Person.self)
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate, UNUserNotificationCenterDelegate {

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil
    ) -> Bool {
        let center = UNUserNotificationCenter.current()
        center.delegate = self
        registerNotificationCategories(center: center)
        return true
    }

    // MARK: – Notification categories (gift reminder actions)

    private func registerNotificationCategories(center: UNUserNotificationCenter) {
        let boughtAction = UNNotificationAction(
            identifier: "GIFT_BOUGHT",
            title: "✓ Mám dárek",
            options: []
        )
        let remindLaterAction = UNNotificationAction(
            identifier: "GIFT_REMIND_LATER",
            title: "⏰ Připomenout znovu",
            options: [.foreground]   // otevře aplikaci
        )
        let skipAction = UNNotificationAction(
            identifier: "GIFT_SKIP",
            title: "Nekupuju nic",
            options: [.destructive]
        )
        let giftCategory = UNNotificationCategory(
            identifier: "GIFT_REMINDER",
            actions: [boughtAction, remindLaterAction, skipAction],
            intentIdentifiers: []
        )
        center.setNotificationCategories([giftCategory])
    }

    // MARK: – Handle actions

    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        didReceive response: UNNotificationResponse,
        withCompletionHandler completionHandler: @escaping () -> Void
    ) {
        let userInfo = response.notification.request.content.userInfo
        let personIdStr = userInfo["personId"] as? String ?? ""
        let eventKind  = userInfo["eventKind"]  as? String ?? ""

        switch response.actionIdentifier {
        case "GIFT_BOUGHT":
            // Zrušit dárkové připomínky pro tuto osobu
            center.getPendingNotificationRequests { requests in
                let ids = requests
                    .filter { $0.identifier.hasPrefix("\(personIdStr)-gift-\(eventKind)") }
                    .map(\.identifier)
                center.removePendingNotificationRequests(withIdentifiers: ids)
            }

        case "GIFT_REMIND_LATER":
            // App se otevře (foreground) – předáme info přes UserDefaults
            UserDefaults.standard.set(personIdStr, forKey: "giftRemindLaterPersonId")
            UserDefaults.standard.set(eventKind,   forKey: "giftRemindLaterEventKind")

        case "GIFT_SKIP":
            center.getPendingNotificationRequests { requests in
                let ids = requests
                    .filter { $0.identifier.hasPrefix("\(personIdStr)-gift") }
                    .map(\.identifier)
                center.removePendingNotificationRequests(withIdentifiers: ids)
            }

        default:
            break
        }
        completionHandler()
    }

    // Zobrazit notifikaci i když je aplikace otevřená
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
    ) {
        completionHandler([.banner, .sound])
    }
}
