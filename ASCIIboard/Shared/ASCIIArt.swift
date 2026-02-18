import Foundation

// MARK: - Core Data Models

struct ASCIICategory: Identifiable, Codable, Equatable, Hashable {
    let id: String
    let name: String
    let systemIcon: String
    let items: [ASCIIItem]

    static func == (lhs: ASCIICategory, rhs: ASCIICategory) -> Bool {
        lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

struct ASCIIItem: Identifiable, Codable, Equatable, Hashable {
    let id: String
    let name: String
    let art: String

    static func == (lhs: ASCIIItem, rhs: ASCIIItem) -> Bool {
        lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

// MARK: - Favorites Store

final class FavoritesStore: ObservableObject {
    static let shared = FavoritesStore()

    private let defaults: UserDefaults
    private let key = "asciboard.favorites"

    @Published private(set) var favoriteIDs: Set<String> = []

    private init() {
        // Use App Group suite so both the main app and keyboard extension share favorites.
        // If the App Group entitlement isn't configured, fall back to standard defaults.
        defaults = UserDefaults(suiteName: "group.io.github.zachop.asciboard") ?? .standard
        let stored = defaults.stringArray(forKey: key) ?? []
        favoriteIDs = Set(stored)
    }

    func isFavorite(_ item: ASCIIItem) -> Bool {
        favoriteIDs.contains(item.id)
    }

    func toggle(_ item: ASCIIItem) {
        if favoriteIDs.contains(item.id) {
            favoriteIDs.remove(item.id)
        } else {
            favoriteIDs.insert(item.id)
        }
        defaults.set(Array(favoriteIDs), forKey: key)
    }

    var favoriteItems: [ASCIIItem] {
        let allItems = ASCIILibrary.allItems
        return allItems.filter { favoriteIDs.contains($0.id) }
    }
}
