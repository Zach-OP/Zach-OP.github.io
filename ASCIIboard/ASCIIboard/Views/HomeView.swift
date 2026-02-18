import SwiftUI

struct HomeView: View {
    @EnvironmentObject private var favorites: FavoritesStore

    private let featured: [ASCIIItem] = [
        ASCIIItem(id: "shrug",      name: "Shrug",       art: "¯\\_(ツ)_/¯"),
        ASCIIItem(id: "flip",       name: "Table Flip",  art: "(╯°□°）╯︵ ┻━┻"),
        ASCIIItem(id: "lenny",      name: "Lenny Face",  art: "( ͡° ͜ʖ ͡°)"),
        ASCIIItem(id: "bear",       name: "Bear",        art: "ʕ•ᴥ•ʔ"),
        ASCIIItem(id: "celebrate",  name: "Celebrate",   art: "٩(◕‿◕｡)۶"),
    ]

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    logoHeader
                    statsRow
                    setupBanner
                    featuredSection
                }
                .padding(.bottom, 24)
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("ASCIIboard")
            .navigationBarTitleDisplayMode(.large)
        }
    }

    // MARK: - Logo Header

    private var logoHeader: some View {
        VStack(spacing: 8) {
            Text("""
  ___  ___  ___ ___ ___ _
 / _ \\/ __||  _|_ _|_ _| |_  ___  __ _  _ _  __| |
| (_) \\__ \\| (_) || | | || . \\/ _ \\/ _` || '_|/ _` |
 \\__\\_\\___/ \\___||_||___|_|_|\\___/\\__,_||_|  \\__,_|
""")
            .font(.system(size: 10, design: .monospaced))
            .foregroundColor(.accentColor)
            .minimumScaleFactor(0.3)
            .lineLimit(4)

            Text("Your ASCII Art Keyboard")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .padding(.top, 8)
        .padding(.horizontal)
    }

    // MARK: - Stats

    private var statsRow: some View {
        HStack(spacing: 12) {
            StatCard(
                value: "\(ASCIILibrary.categories.count)",
                label: "Categories"
            )
            StatCard(
                value: "\(ASCIILibrary.allItems.count)",
                label: "Art Pieces"
            )
            StatCard(
                value: "\(favorites.favoriteIDs.count)",
                label: "Favorites"
            )
        }
        .padding(.horizontal)
    }

    // MARK: - Setup Banner

    private var setupBanner: some View {
        NavigationLink(destination: SetupGuideView()) {
            HStack(spacing: 14) {
                Image(systemName: "keyboard.badge.ellipsis")
                    .font(.title2)
                    .foregroundColor(.accentColor)

                VStack(alignment: .leading, spacing: 2) {
                    Text("Enable ASCIIboard")
                        .font(.headline)
                        .foregroundColor(.primary)
                    Text("Tap to open the setup guide")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }

                Spacer()

                Image(systemName: "chevron.right")
                    .foregroundColor(.secondary)
            }
            .padding()
            .background(Color(.secondarySystemGroupedBackground))
            .cornerRadius(14)
            .padding(.horizontal)
        }
    }

    // MARK: - Featured Section

    private var featuredSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Popular")
                .font(.title2.bold())
                .padding(.horizontal)

            VStack(spacing: 8) {
                ForEach(featured) { item in
                    ASCIIItemRow(item: item)
                }
            }
            .padding(.horizontal)
        }
    }
}

// MARK: - Reusable Components

struct StatCard: View {
    let value: String
    let label: String

    var body: some View {
        VStack(spacing: 4) {
            Text(value)
                .font(.title.bold())
                .foregroundColor(.accentColor)
            Text(label)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 14)
        .background(Color(.secondarySystemGroupedBackground))
        .cornerRadius(12)
    }
}

struct ASCIIItemRow: View {
    let item: ASCIIItem
    @State private var copied = false
    @EnvironmentObject private var favorites: FavoritesStore

    var body: some View {
        HStack(spacing: 12) {
            VStack(alignment: .leading, spacing: 4) {
                Text(item.name)
                    .font(.caption)
                    .foregroundColor(.secondary)
                Text(item.art)
                    .font(.system(.body, design: .monospaced))
                    .lineLimit(3)
            }

            Spacer()

            HStack(spacing: 8) {
                // Favorite toggle
                Button {
                    favorites.toggle(item)
                } label: {
                    Image(systemName: favorites.isFavorite(item) ? "star.fill" : "star")
                        .foregroundColor(favorites.isFavorite(item) ? .yellow : .secondary)
                }

                // Copy button
                Button {
                    UIPasteboard.general.string = item.art
                    copied = true
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                        copied = false
                    }
                } label: {
                    Image(systemName: copied ? "checkmark" : "doc.on.doc")
                        .foregroundColor(copied ? .green : .accentColor)
                }
            }
        }
        .padding()
        .background(Color(.secondarySystemGroupedBackground))
        .cornerRadius(12)
    }
}
