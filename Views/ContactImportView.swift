import SwiftUI
import SwiftData
import Contacts

struct ContactImportView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss

    @State private var contacts: [CNContact] = []
    @State private var selected: Set<String> = []
    @State private var searchText = ""
    @State private var permissionDenied = false
    @State private var isLoading = true

    private var filtered: [CNContact] {
        if searchText.isEmpty { return contacts }
        let q = searchText.lowercased()
        return contacts.filter {
            $0.givenName.lowercased().contains(q) ||
            $0.familyName.lowercased().contains(q)
        }
    }

    var body: some View {
        NavigationStack {
            Group {
                if isLoading {
                    ProgressView("Načítám kontakty…")
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else if permissionDenied {
                    permissionDeniedView
                } else if contacts.isEmpty {
                    ContentUnavailableView("Žádné kontakty", systemImage: "person.slash", description: Text("V adresáři nejsou žádné kontakty se jménem."))
                } else {
                    contactList
                }
            }
            .navigationTitle("Import z kontaktů")
            .navigationBarTitleDisplayMode(.inline)
            .searchable(text: $searchText, prompt: "Hledat jméno…")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Zrušit") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Importovat (\(selected.count))") { importSelected() }
                        .bold()
                        .disabled(selected.isEmpty)
                }
            }
        }
        .task { await loadContacts() }
    }

    // MARK: – Contact list

    private var contactList: some View {
        List(filtered, id: \.identifier) { contact in
            let isSelected = selected.contains(contact.identifier)
            Button {
                if isSelected {
                    selected.remove(contact.identifier)
                } else {
                    selected.insert(contact.identifier)
                }
            } label: {
                HStack(spacing: 14) {
                    ZStack {
                        Circle()
                            .fill(Color.accentColor.opacity(0.12))
                            .frame(width: 44, height: 44)
                        Text(initials(contact))
                            .font(.headline)
                            .foregroundStyle(Color.accentColor)
                    }

                    VStack(alignment: .leading, spacing: 2) {
                        Text(fullName(contact))
                            .font(.headline)
                            .foregroundStyle(.primary)
                        if let bday = contact.birthday {
                            let parts = [bday.day.map { "\($0)." }, bday.month.flatMap { monthName($0) }]
                                .compactMap { $0 }
                            if !parts.isEmpty {
                                Label(parts.joined(separator: " "), systemImage: "birthday.cake")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                        }
                    }

                    Spacer()

                    Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                        .foregroundStyle(isSelected ? Color.accentColor : Color.secondary.opacity(0.4))
                        .font(.title3)
                }
                .contentShape(Rectangle())
            }
            .buttonStyle(.plain)
        }
        .listStyle(.plain)
        .overlay(alignment: .bottom) {
            if !selected.isEmpty {
                selectionBar
                    .padding(.bottom, 8)
            }
        }
    }

    private var selectionBar: some View {
        HStack {
            Text("\(selected.count) vybráno")
                .font(.subheadline.bold())
            Spacer()
            Button("Zrušit výběr") { selected.removeAll() }
                .font(.subheadline)
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 12)
        .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 14))
        .padding(.horizontal)
    }

    private var permissionDeniedView: some View {
        VStack(spacing: 16) {
            Image(systemName: "person.slash.fill")
                .font(.system(size: 48))
                .foregroundStyle(.secondary)
            Text("Přístup k kontaktům zamítnut")
                .font(.headline)
            Text("Povol přístup v Nastavení → Slavíme → Kontakty.")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            Button("Otevřít Nastavení") {
                if let url = URL(string: UIApplication.openSettingsURLString) {
                    UIApplication.shared.open(url)
                }
            }
            .buttonStyle(.bordered)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding()
    }

    // MARK: – Load contacts

    private func loadContacts() async {
        let store = CNContactStore()
        do {
            let status = CNContactStore.authorizationStatus(for: .contacts)
            if status == .notDetermined {
                let granted = try await store.requestAccess(for: .contacts)
                if !granted {
                    await MainActor.run { permissionDenied = true; isLoading = false }
                    return
                }
            } else if status == .denied || status == .restricted {
                await MainActor.run { permissionDenied = true; isLoading = false }
                return
            }

            let keys: [CNKeyDescriptor] = [
                CNContactGivenNameKey as CNKeyDescriptor,
                CNContactFamilyNameKey as CNKeyDescriptor,
                CNContactBirthdayKey as CNKeyDescriptor,
                CNContactThumbnailImageDataKey as CNKeyDescriptor,
                CNContactImageDataAvailableKey as CNKeyDescriptor,
            ]
            let request = CNContactFetchRequest(keysToFetch: keys)
            request.sortOrder = .givenName

            var result: [CNContact] = []
            try store.enumerateContacts(with: request) { contact, _ in
                if !contact.givenName.trimmingCharacters(in: .whitespaces).isEmpty {
                    result.append(contact)
                }
            }
            await MainActor.run { contacts = result; isLoading = false }
        } catch {
            await MainActor.run { permissionDenied = true; isLoading = false }
        }
    }

    // MARK: – Import

    private func importSelected() {
        let colors = Person.availableColors
        var colorIndex = 0

        let toImport = contacts.filter { selected.contains($0.identifier) }
        for contact in toImport {
            let firstName = contact.givenName.trimmingCharacters(in: .whitespaces)
            let lastName  = contact.familyName.trimmingCharacters(in: .whitespaces)

            var birthMonth: Int? = nil
            var birthDay:   Int? = nil
            var birthYear:  Int? = nil
            if let bday = contact.birthday {
                birthMonth = bday.month
                birthDay   = bday.day
                birthYear  = bday.year
            }

            let person = Person(
                name: firstName,
                lastName: lastName,
                category: "Ostatní",
                emoji: "🎂",
                colorHex: colors[colorIndex % colors.count],
                birthMonth: birthMonth,
                birthDay: birthDay,
                birthYear: birthYear
            )
            if contact.imageDataAvailable, let imgData = contact.thumbnailImageData {
                person.photoData = imgData
            }
            modelContext.insert(person)
            colorIndex += 1
        }
        try? modelContext.save()
        dismiss()
    }

    // MARK: – Helpers

    private func fullName(_ c: CNContact) -> String {
        [c.givenName, c.familyName].filter { !$0.isEmpty }.joined(separator: " ")
    }

    private func initials(_ c: CNContact) -> String {
        let parts = [c.givenName.first, c.familyName.first].compactMap { $0 }
        return String(parts.prefix(2))
    }

    private func monthName(_ m: Int) -> String? {
        guard (1...12).contains(m) else { return nil }
        let f = DateFormatter()
        f.locale = Locale(identifier: "cs_CZ")
        f.dateFormat = "MMMM"
        var c = DateComponents(); c.month = m; c.day = 1; c.year = 2024
        return f.string(from: Calendar.current.date(from: c) ?? Date())
    }
}
