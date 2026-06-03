import Foundation
import SwiftData

struct AnniversaryPreset: Identifiable {
    let id: String
    let title: String
    let icon: String
}

@Model
class Anniversary {
    var id: UUID
    var title: String
    var icon: String
    var month: Int
    var day: Int
    var year: Int?

    @Relationship(deleteRule: .nullify)
    var person: Person?

    init(title: String, icon: String, month: Int, day: Int, year: Int? = nil) {
        self.id = UUID()
        self.title = title
        self.icon = icon
        self.month = month
        self.day = day
        self.year = year
    }

    static let presets: [AnniversaryPreset] = [
        .init(id: "wedding",    title: "Výročí svatby",     icon: "💍"),
        .init(id: "relation",   title: "Výročí vztahu",     icon: "❤️"),
        .init(id: "firstdate",  title: "První rande",       icon: "💕"),
        .init(id: "friendship", title: "Výročí přátelství", icon: "🤝"),
        .init(id: "custom",     title: "Vlastní výročí",    icon: "⭐"),
    ]
}
