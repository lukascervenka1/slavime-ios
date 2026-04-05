import SwiftUI

/// Zobrazí se, když uživatel tapne "Připomenout znovu" na notifikaci o dárku.
struct GiftReminderPickerView: View {
    let person: Person
    let eventKind: String   // "nameday" nebo "birthday"

    @Environment(\.dismiss) private var dismiss
    @State private var reminderDate = Calendar.current.date(
        byAdding: .day, value: 3, to: Date()
    ) ?? Date()

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    HStack(spacing: 14) {
                        ZStack {
                            Circle()
                                .fill((Color(hex: person.colorHex) ?? .blue).gradient)
                                .frame(width: 50, height: 50)
                            Text(person.emoji).font(.system(size: 22))
                        }
                        VStack(alignment: .leading, spacing: 3) {
                            Text(person.name).font(.headline)
                            Text(eventKind == "nameday" ? "Svátek" : "Narozeniny")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }
                    }
                    .listRowBackground(Color.clear)
                }

                Section("Kdy tě má připomenout?") {
                    DatePicker(
                        "Datum a čas",
                        selection: $reminderDate,
                        in: Date()...,
                        displayedComponents: [.date, .hourAndMinute]
                    )
                    .datePickerStyle(.graphical)
                }

                Section {
                    Button {
                        scheduleAndDismiss()
                    } label: {
                        Label("Nastavit připomínku", systemImage: "bell.badge.fill")
                            .frame(maxWidth: .infinity)
                            .bold()
                    }
                    .buttonStyle(.borderedProminent)
                    .listRowBackground(Color.clear)
                }
            }
            .navigationTitle("Připomínka na dárek")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Zrušit") { dismiss() }
                }
            }
        }
    }

    private func scheduleAndDismiss() {
        NotificationService.shared.scheduleOneTimeGiftReminder(
            for: person,
            eventKind: eventKind,
            at: reminderDate
        )
        dismiss()
    }
}
