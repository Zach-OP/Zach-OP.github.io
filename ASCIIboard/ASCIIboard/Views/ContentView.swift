import SwiftUI

struct ContentView: View {
    @StateObject private var favorites = FavoritesStore.shared

    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Label("Home", systemImage: "keyboard")
                }

            GalleryView()
                .tabItem {
                    Label("Browse", systemImage: "square.grid.2x2")
                }

            FavoritesView()
                .tabItem {
                    Label("Favorites", systemImage: "star.fill")
                }

            SetupGuideView()
                .tabItem {
                    Label("Setup", systemImage: "gear")
                }
        }
        .environmentObject(favorites)
    }
}
