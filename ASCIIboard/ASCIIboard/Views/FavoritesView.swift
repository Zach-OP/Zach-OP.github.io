import SwiftUI

struct FavoritesView: View {
    @EnvironmentObject private var favorites: FavoritesStore

    var body: some View {
        NavigationStack {
            Group {
                if favorites.favoriteItems.isEmpty {
                    emptyState
                } else {
                    List(favorites.favoriteItems) { item in
                        GalleryItemRow(item: item)
                            .listRowBackground(Color(.secondarySystemGroupedBackground))
                            .listRowInsets(EdgeInsets(top: 6, leading: 16, bottom: 6, trailing: 16))
                    }
                    .listStyle(.plain)
                }
            }
            .navigationTitle("Favorites")
            .background(Color(.systemGroupedBackground))
        }
    }

    private var emptyState: some View {
        ContentUnavailableView(
            "No Favorites Yet",
            systemImage: "star",
            description: Text("Tap the ★ on any ASCII art to save it here.")
        )
    }
}
