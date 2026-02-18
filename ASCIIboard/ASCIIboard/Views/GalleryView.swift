import SwiftUI

struct GalleryView: View {
    @EnvironmentObject private var favorites: FavoritesStore
    @State private var searchText = ""
    @State private var selectedCategoryId: String? = nil

    private var displayedCategories: [ASCIICategory] {
        ASCIILibrary.categories
    }

    private var filteredItems: [ASCIIItem] {
        if !searchText.isEmpty {
            return ASCIILibrary.items(matching: searchText)
        }
        if let id = selectedCategoryId,
           let category = ASCIILibrary.category(withId: id) {
            return category.items
        }
        return ASCIILibrary.allItems
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                categoryBar
                Divider()
                itemList
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("Browse")
            .searchable(text: $searchText, prompt: "Search ASCII art…")
        }
    }

    // MARK: - Category Bar

    private var categoryBar: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                CategoryChip(
                    title: "All",
                    icon: "square.grid.2x2",
                    isSelected: selectedCategoryId == nil
                ) {
                    selectedCategoryId = nil
                }

                ForEach(displayedCategories) { category in
                    CategoryChip(
                        title: category.name,
                        icon: category.systemIcon,
                        isSelected: selectedCategoryId == category.id
                    ) {
                        selectedCategoryId = category.id
                    }
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
        }
        .background(Color(.secondarySystemGroupedBackground))
    }

    // MARK: - Item List

    @ViewBuilder
    private var itemList: some View {
        if filteredItems.isEmpty {
            ContentUnavailableView.search(text: searchText)
        } else {
            List(filteredItems) { item in
                GalleryItemRow(item: item)
                    .listRowBackground(Color(.secondarySystemGroupedBackground))
                    .listRowInsets(EdgeInsets(top: 6, leading: 16, bottom: 6, trailing: 16))
            }
            .listStyle(.plain)
        }
    }
}

// MARK: - Category Chip

struct CategoryChip: View {
    let title: String
    let icon: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 5) {
                Image(systemName: icon)
                    .font(.caption)
                Text(title)
                    .font(.subheadline.weight(.medium))
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 7)
            .background(
                isSelected ? Color.accentColor : Color(.tertiarySystemGroupedBackground)
            )
            .foregroundColor(isSelected ? .white : .primary)
            .clipShape(Capsule())
        }
        .animation(.easeInOut(duration: 0.15), value: isSelected)
    }
}

// MARK: - Gallery Item Row

struct GalleryItemRow: View {
    let item: ASCIIItem
    @EnvironmentObject private var favorites: FavoritesStore
    @State private var copied = false

    var body: some View {
        HStack(spacing: 12) {
            VStack(alignment: .leading, spacing: 4) {
                Text(item.name)
                    .font(.caption)
                    .foregroundColor(.secondary)
                Text(item.art)
                    .font(.system(.body, design: .monospaced))
                    .lineLimit(3)
                    .fixedSize(horizontal: false, vertical: true)
            }

            Spacer()

            VStack(spacing: 10) {
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
        .padding(.vertical, 4)
    }
}
