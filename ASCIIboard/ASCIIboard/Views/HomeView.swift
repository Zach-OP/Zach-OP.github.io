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
                VStack(spacing: 0) {
                    graffitiHero
                    VStack(spacing: 24) {
                        statsRow
                        setupBanner
                        featuredSection
                    }
                    .padding(.top, 20)
                    .padding(.bottom, 24)
                }
            }
            .background(Color(.systemGroupedBackground))
            // Transparent nav bar — the gradient behind it does the colouring.
            .toolbarBackground(.hidden, for: .navigationBar)
            // Keep status-bar icons and inline title in white.
            .toolbarColorScheme(.dark, for: .navigationBar)
            .navigationTitle("ASCIIboard")
            .navigationBarTitleDisplayMode(.inline)
        }
    }

    // MARK: - Graffiti Hero Banner

    private var graffitiHero: some View {
        GeometryReader { geo in
            ZStack {
                // NOTE: gradient lives in .background below so it can extend
                // behind the navigation bar via ignoresSafeArea(edges: .top).

                // Scattered ASCII art graffiti pieces
                ForEach(graffitiPieces, id: \.text) { piece in
                    Text(piece.text)
                        .font(.system(size: piece.fontSize, design: .monospaced))
                        .foregroundColor(piece.color)
                        .opacity(piece.opacity)
                        .rotationEffect(.degrees(piece.rotation))
                        .position(
                            x: geo.size.width  * piece.relX,
                            y: geo.size.height * piece.relY
                        )
                }

                // Centered app name + tagline
                VStack(spacing: 6) {
                    Text("ASCIIboard")
                        .font(.system(size: 34, weight: .black, design: .monospaced))
                        .foregroundColor(.white)
                        .shadow(color: .black.opacity(0.6), radius: 8, x: 0, y: 2)
                    Text("Your ASCII Art Keyboard")
                        .font(.system(size: 13, weight: .medium))
                        .foregroundColor(.white.opacity(0.6))
                        .tracking(1.5)
                }

                // Bottom fade into the page background
                LinearGradient(
                    colors: [.clear, Color(.systemGroupedBackground)],
                    startPoint: .center,
                    endPoint: .bottom
                )
            }
            .clipped()
        }
        .frame(height: 220)
        // Applying the gradient here — outside the GeometryReader — lets
        // ignoresSafeArea push its startPoint all the way to the top of the
        // screen, so the gradient continues seamlessly behind the nav bar.
        .background(
            LinearGradient(
                colors: [Color(red: 0.08, green: 0.08, blue: 0.10),
                         Color(red: 0.12, green: 0.13, blue: 0.16)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea(edges: .top)
        )
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

// MARK: - Graffiti Piece Data

private struct GraffitiPiece {
    let text: String
    let relX: CGFloat   // 0…1 relative to banner width
    let relY: CGFloat   // 0…1 relative to banner height
    let rotation: Double
    let fontSize: CGFloat
    let opacity: Double
    let color: Color
}

// Positions are hand-tuned so pieces feel randomly scattered but
// avoid the centre where the title sits.
private let graffitiPieces: [GraffitiPiece] = [
    // Top-left cluster
    GraffitiPiece(text: "¯\\_(ツ)_/¯",      relX: 0.10, relY: 0.18, rotation: -14, fontSize: 13, opacity: 0.55, color: .accentColor),
    GraffitiPiece(text: "░▒▓█▓▒░",          relX: 0.22, relY: 0.06, rotation:   3, fontSize: 11, opacity: 0.22, color: .white),
    GraffitiPiece(text: "ʕ•ᴥ•ʔ",            relX: 0.05, relY: 0.58, rotation:  18, fontSize: 17, opacity: 0.42, color: .white),

    // Top-right cluster
    GraffitiPiece(text: "(╯°□°）╯︵ ┻━┻",   relX: 0.72, relY: 0.12, rotation:   9, fontSize: 10, opacity: 0.38, color: .accentColor),
    GraffitiPiece(text: "(◕‿◕)",             relX: 0.88, relY: 0.30, rotation: -11, fontSize: 18, opacity: 0.45, color: .white),
    GraffitiPiece(text: "★ ☆ ★",            relX: 0.80, relY: 0.68, rotation:  -6, fontSize: 13, opacity: 0.28, color: .accentColor),

    // Left edge
    GraffitiPiece(text: "✦ ✧ ✦",            relX: -0.02, relY: 0.40, rotation: -22, fontSize: 15, opacity: 0.30, color: .accentColor),
    GraffitiPiece(text: "щ(ಠ益ಠщ)",         relX: 0.14, relY: 0.82, rotation: -10, fontSize: 11, opacity: 0.35, color: .accentColor),

    // Right edge
    GraffitiPiece(text: "(ง'̀-'́)ง",           relX: 1.01, relY: 0.55, rotation:  14, fontSize: 13, opacity: 0.38, color: .white),
    GraffitiPiece(text: "♥ ♦ ♣ ♠",          relX: 0.90, relY: 0.85, rotation:   7, fontSize: 12, opacity: 0.25, color: .white),

    // Bottom scattered
    GraffitiPiece(text: "ヽ(°〇°)ﾉ",        relX: 0.35, relY: 0.90, rotation:  -8, fontSize: 12, opacity: 0.30, color: .accentColor),
    GraffitiPiece(text: "ヾ(⌐■_■)ノ♪",      relX: 0.60, relY: 0.82, rotation:  12, fontSize: 11, opacity: 0.28, color: .white),

    // Mid-left / mid-right (avoid dead centre)
    GraffitiPiece(text: "( ͡° ͜ʖ ͡°)",        relX: 0.18, relY: 0.46, rotation:  20, fontSize: 14, opacity: 0.32, color: .white),
    GraffitiPiece(text: "٩(◕‿◕｡)۶",         relX: 0.82, relY: 0.48, rotation:  -9, fontSize: 12, opacity: 0.30, color: .accentColor),
]

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
                Button {
                    favorites.toggle(item)
                } label: {
                    Image(systemName: favorites.isFavorite(item) ? "star.fill" : "star")
                        .foregroundColor(favorites.isFavorite(item) ? .yellow : .secondary)
                }

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
