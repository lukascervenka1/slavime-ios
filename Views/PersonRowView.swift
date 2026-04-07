import SwiftUI

struct EventRowView: View {
    let event: UpcomingEvent

    var body: some View {
        HStack(spacing: 14) {
            // Avatar
            ZStack {
                Circle()
                    .fill((Color(hex: event.person.colorHex) ?? .blue).gradient)
                    .frame(width: 50, height: 50)
                Text(event.person.emoji)
                    .font(.system(size: 22))
            }

            // Info
            VStack(alignment: .leading, spacing: 4) {
                Text(event.person.displayName)
                    .font(.headline)

                HStack(spacing: 5) {
                    Image(systemName: event.kindIcon)
                        .font(.caption.weight(.semibold))
                    Text(event.kindLabel)
                        .font(.subheadline)
                }
                .foregroundStyle(event.kindColor)

                if !event.isToday {
                    Text(event.formattedDate)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }

            Spacer()

            // Days badge
            if event.isToday {
                Image(systemName: "star.fill")
                    .foregroundStyle(.yellow)
                    .font(.title3)
            } else {
                VStack(spacing: 1) {
                    Text("\(event.daysUntil)")
                        .font(.title2.bold())
                        .foregroundStyle(event.kindColor)
                    Text("dní")
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                }
                .frame(minWidth: 40)
            }
        }
        .padding(.vertical, 5)
    }
}

// MARK: – Color from hex (shared extension)
extension Color {
    init?(hex: String) {
        var str = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        if str.hasPrefix("#") { str.removeFirst() }
        guard str.count == 6, let value = UInt64(str, radix: 16) else { return nil }
        let r = Double((value >> 16) & 0xFF) / 255
        let g = Double((value >> 8)  & 0xFF) / 255
        let b = Double(value         & 0xFF) / 255
        self.init(red: r, green: g, blue: b)
    }
}
