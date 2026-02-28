import Combine
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

// MARK: - Custom ASCII Item

struct CustomASCIIItem: Codable, Identifiable {
    let id: String
    let name: String
    let art: String
    let categoryId: String
    
    func toASCIIItem() -> ASCIIItem {
        ASCIIItem(id: id, name: name, art: art)
    }
}

// MARK: - Custom ASCII Store

final class CustomASCIIStore: ObservableObject {
    static let shared = CustomASCIIStore()

    private let defaults: UserDefaults
    private let key = "asciboard.customItems"

    @Published private(set) var customItems: [CustomASCIIItem] = []

    private init() {
        // Use App Group suite so both the main app and keyboard extension share custom items.
        defaults = UserDefaults(suiteName: "group.io.github.zachop.asciboard") ?? .standard
        loadCustomItems()
    }

    private func loadCustomItems() {
        if let data = defaults.data(forKey: key),
           let items = try? JSONDecoder().decode([CustomASCIIItem].self, from: data) {
            customItems = items
        }
    }

    private func saveCustomItems() {
        if let data = try? JSONEncoder().encode(customItems) {
            defaults.set(data, forKey: key)
        }
    }

    func add(name: String, art: String, categoryId: String) {
        let id = "custom_\(UUID().uuidString)"
        let item = CustomASCIIItem(id: id, name: name, art: art, categoryId: categoryId)
        customItems.append(item)
        saveCustomItems()
    }

    func delete(_ item: CustomASCIIItem) {
        customItems.removeAll { $0.id == item.id }
        saveCustomItems()
    }

    func items(for categoryId: String) -> [ASCIIItem] {
        customItems
            .filter { $0.categoryId == categoryId }
            .map { $0.toASCIIItem() }
    }

    var allCustomASCIIItems: [ASCIIItem] {
        customItems.map { $0.toASCIIItem() }
    }
}

// MARK: - Favorites Store

final class FavoritesStore: ObservableObject {
    static let shared = FavoritesStore()

    private let defaults: UserDefaults
    private let key = "asciboard.favorites"
    private let orderKey = "asciboard.favorites.order"

    @Published private(set) var favoriteIDs: Set<String> = []
    @Published private(set) var favoriteOrder: [String] = []

    private init() {
        // Use App Group suite so both the main app and keyboard extension share favorites.
        // If the App Group entitlement isn't configured, fall back to standard defaults.
        defaults = UserDefaults(suiteName: "group.io.github.zachop.asciboard") ?? .standard
        let stored = defaults.stringArray(forKey: key) ?? []
        favoriteIDs = Set(stored)
        // Load order; fall back to stored array order for existing users
        let order = defaults.stringArray(forKey: orderKey) ?? stored
        favoriteOrder = order.filter { favoriteIDs.contains($0) }
    }

    func isFavorite(_ item: ASCIIItem) -> Bool {
        favoriteIDs.contains(item.id)
    }

    func toggle(_ item: ASCIIItem) {
        if favoriteIDs.contains(item.id) {
            favoriteIDs.remove(item.id)
            favoriteOrder.removeAll { $0 == item.id }
        } else {
            favoriteIDs.insert(item.id)
            favoriteOrder.append(item.id)
        }
        defaults.set(Array(favoriteIDs), forKey: key)
        defaults.set(favoriteOrder, forKey: orderKey)
    }

    var favoriteItems: [ASCIIItem] {
        let lookup = Dictionary(uniqueKeysWithValues: ASCIILibrary.allItems.map { ($0.id, $0) })
        return favoriteOrder.compactMap { lookup[$0] }
    }
}
