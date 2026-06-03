import SwiftUI
import SwiftData

struct SettingsView: View {
    @Query private var people: [Person]
    @Environment(\.dismiss) private var dismiss

    @AppStorage("dailyDigestEnabled") private var enabled = false
    @AppStorage("dailyDigestHour")    private var hour    = 8
    @AppStorage("dailyDigestMinute")  private var minute  = 0

    @State private var notificationPermissionDenied = false
    @State private var digestTime = Date()

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    Toggle(isOn: $enabled) {
                        VStack(alignment: .leading, spacing: 3) {
                            Text("Ranní přehled svátků")
                                .font(.body)
                            Text("Každý den upozornění kdo slaví")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    }
                    .onChange(of: enabled) { _, newValue in
                        Task { await handleToggle(newValue) }
                    }

                    if enabled {
                        DatePicker(
                            "Čas notifikace",
                            selection: $digestTime,
                            displayedComponents: .hourAndMinute
                        )
                        .onChange(of: digestTime) { _, newTime in
                            let cal = Calendar.current
                            hour   = cal.component(.hour,   from: newTime)
                            minute = cal.component(.minute, from: newTime)
                            reschedule()
                        }
                    }
                } header: {
                    Label("Denní přehled", systemImage: "bell.badge.fill").textCase(nil)
                } footer: {
                    if enabled {
                        Text("Každé ráno dostaneš upozornění se jmény slavícími svátek nebo narozeniny – ze svého seznamu i z českého kalendáře.")
                    } else {
                        Text("Zapni, aby tě aplikace každé ráno připomněla kdo dnes slaví.")
                    }
                }

                if notificationPermissionDenied {
                    Section {
                        HStack(spacing: 12) {
                            Image(systemName: "exclamationmark.triangle.fill")
                                .foregroundStyle(.orange)
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Notifikace zamítnuty")
                                    .font(.subheadline.bold())
                                Text("Povol notifikace v Nastavení → Slavíme.")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                        }
                        Button("Otevřít Nastavení") {
                            if let url = URL(string: UIApplication.openSettingsURLString) {
                                UIApplication.shared.open(url)
                            }
                        }
                    }
                }

                Section {
                    LabeledContent("Sledované osoby", value: "\(people.count)")
                    LabeledContent("Osoby se svátkem", value: "\(people.filter { $0.nameDayComponents != nil }.count)")
                    LabeledContent("Osoby s narozeninami", value: "\(people.filter { $0.birthdayComponents != nil }.count)")
                } header: {
                    Label("Statistiky", systemImage: "chart.bar.fill").textCase(nil)
                }
            }
            .navigationTitle("Nastavení")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Hotovo") { dismiss() }
                        .bold()
                }
            }
            .onAppear { loadTime() }
        }
    }

    private func loadTime() {
        var c = DateComponents()
        c.hour = hour; c.minute = minute
        digestTime = Calendar.current.date(from: c) ?? Date()
        Task { await checkPermission() }
    }

    private func checkPermission() async {
        let settings = await UNUserNotificationCenter.current().notificationSettings()
        await MainActor.run {
            notificationPermissionDenied = settings.authorizationStatus == .denied
        }
    }

    private func handleToggle(_ newValue: Bool) async {
        if newValue {
            let granted = await NotificationService.shared.requestPermission()
            if !granted {
                await MainActor.run {
                    enabled = false
                    notificationPermissionDenied = true
                }
                return
            }
            reschedule()
        } else {
            NotificationService.shared.cancelDailyDigest()
        }
    }

    private func reschedule() {
        guard enabled else { return }
        NotificationService.shared.scheduleDailyDigest(hour: hour, minute: minute, people: people)
    }
}

import UserNotifications
