import SwiftUI

struct FavoritesView: View {
    @EnvironmentObject private var favorites: FavoritesStore

    @State private var searchText = ""
    @State private var sortOrder: SortOrder = .dateAdded

    private enum SortOrder: String, CaseIterable, Identifiable {
        case dateAdded = "Date Added"
        case name = "Name"
        case category = "Category"
        var id: Self { self }
    }

    /// Map from item ID → category name, built once per render cycle.
    private var categoryNameByID: [String: String] {
        var map: [String: String] = [:]
        for category in ASCIILibrary.categories {
            for item in category.items {
                map[item.id] = category.name
            }
        }
        return map
    }

    private var displayedItems: [ASCIIItem] {
        var items = favorites.favoriteItems
        if !searchText.isEmpty {
            let q = searchText.lowercased()
            items = items.filter { $0.name.lowercased().contains(q) || $0.art.lowercased().contains(q) }
        }
        switch sortOrder {
        case .dateAdded: return items.reversed()
        case .name:      return items.sorted { $0.name < $1.name }
        case .category:
            let map = categoryNameByID
            return items.sorted { (map[$0.id] ?? "Custom") < (map[$1.id] ?? "Custom") }
        }
    }

    var body: some View {
        NavigationStack {
            Group {
                if favorites.favoriteItems.isEmpty {
                    emptyState(noFavorites: true)
                } else if displayedItems.isEmpty {
                    emptyState(noFavorites: false)
                } else {
                    List(displayedItems) { item in
                        GalleryItemRow(item: item)
                            .listRowBackground(Color(.secondarySystemGroupedBackground))
                            .listRowInsets(EdgeInsets(top: 6, leading: 16, bottom: 6, trailing: 16))
                            .swipeActions(edge: .trailing) {
                                Button(role: .destructive) {
                                    favorites.toggle(item)
                                } label: {
                                    Label("Unfavorite", systemImage: "star.slash")
                                }
                            }
                    }
                    .listStyle(.plain)
                }
            }
            .navigationTitle("Favorites")
            .background(Color(.systemGroupedBackground))
            .searchable(text: $searchText, prompt: "Search favorites…")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Menu {
                        Picker("Sort By", selection: $sortOrder) {
                            ForEach(SortOrder.allCases) {
                                Text($0.rawValue).tag($0)
                            }
                        }
                    } label: {
                        Image(systemName: "arrow.up.arrow.down")
                    }
                }
            }
        }
    }

    private func emptyState(noFavorites: Bool) -> some View {
        VStack(spacing: 16) {
            Image(systemName: noFavorites ? "star" : "magnifyingglass")
                .font(.system(size: 52))
                .foregroundColor(.secondary)
            Text(noFavorites ? "No Favorites Yet" : "No Results")
                .font(.title2.bold())
            Text(noFavorites
                 ? "Tap the ★ on any ASCII art to save it here."
                 : "No favorites match \"\(searchText)\".")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
