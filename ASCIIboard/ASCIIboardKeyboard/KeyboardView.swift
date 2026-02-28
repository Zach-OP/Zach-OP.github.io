import SwiftUI

// MARK: - Root Keyboard View

/// The SwiftUI root view for the ASCIIboard custom keyboard extension.
struct KeyboardView: View {
    let needsGlobeKey: Bool
    let onInsert: (String) -> Void
    let onDelete: () -> Void
    let onSwitchKeyboard: () -> Void

    @State private var selectedCategoryId: String = ASCIILibrary.categories.first?.id ?? "emoticons"
    @State private var searchText: String = ""
    @State private var isSearching: Bool = false
    @State private var lastInsertedId: String? = nil

    @StateObject private var favorites = FavoritesStore.shared
    @StateObject private var customStore = CustomASCIIStore.shared

    private var visibleCategories: [ASCIICategory] {
        var all = ASCIILibrary.builtInCategories
        if !customStore.customItems.isEmpty {
            all.insert(ASCIILibrary.customCategory, at: 0)
        }
        return all
    }

    private var displayedItems: [ASCIIItem] {
        if isSearching && !searchText.isEmpty {
            let q = searchText.lowercased()
            return visibleCategories.flatMap { $0.items }.filter {
                $0.name.lowercased().contains(q) || $0.art.lowercased().contains(q)
            }
        }
        return visibleCategories.first(where: { $0.id == selectedCategoryId })?.items ?? []
    }

    var body: some View {
        VStack(spacing: 0) {
            categoryTabBar
            Divider()
            contentArea
            Divider()
            bottomToolbar
        }
        .background(Color(.systemGroupedBackground))
    }

    // MARK: - Category Tab Bar

    private var categoryTabBar: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 2) {
                ForEach(visibleCategories) { category in
                    categoryTab(for: category)
                }
            }
            .padding(.horizontal, 8)
        }
        .frame(height: 52)
        .background(Color(.secondarySystemGroupedBackground))
    }

    private func categoryTab(for category: ASCIICategory) -> some View {
        let isSelected = selectedCategoryId == category.id && !isSearching

        return Button {
            selectedCategoryId = category.id
            if isSearching {
                isSearching = false
                searchText = ""
            }
        } label: {
            VStack(spacing: 2) {
                Image(systemName: category.systemIcon)
                    .font(.system(size: 17))
                Text(category.name)
                    .font(.system(size: 9, weight: .medium))
            }
            .foregroundColor(isSelected ? Color.accentColor : Color(.label).opacity(0.6))
            .frame(minWidth: 52)
            .padding(.vertical, 6)
            .background(
                isSelected
                    ? Color.accentColor.opacity(0.12)
                    : Color.clear
            )
            .cornerRadius(8)
        }
        .animation(.easeInOut(duration: 0.15), value: isSelected)
    }

    // MARK: - Content Area

    private var contentArea: some View {
        VStack(spacing: 0) {
            if isSearching {
                searchBar
                    .padding(.horizontal, 8)
                    .padding(.top, 6)
            }

            if displayedItems.isEmpty {
                emptyState
            } else {
                itemsScrollView
            }
        }
        .frame(maxHeight: 200)
        .background(Color(.systemGroupedBackground))
    }

    private var searchBar: some View {
        HStack(spacing: 6) {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.secondary)
                .font(.system(size: 14))
            TextField("Search ASCII art…", text: $searchText)
                .font(.system(size: 14))
                .autocorrectionDisabled()
            if !searchText.isEmpty {
                Button { searchText = "" } label: {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.secondary)
                        .font(.system(size: 14))
                }
            }
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 7)
        .background(Color(.secondarySystemGroupedBackground))
        .cornerRadius(10)
    }

    private var emptyState: some View {
        VStack(spacing: 8) {
            Image(systemName: "magnifyingglass")
                .font(.largeTitle)
                .foregroundColor(.secondary)
            Text(isSearching ? "No results for \"\(searchText)\"" : "No items")
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding()
    }

    private var itemsScrollView: some View {
        ScrollView(.vertical, showsIndicators: false) {
            LazyVStack(spacing: 5) {
                ForEach(displayedItems) { item in
                    KeyboardItemButton(
                        item: item,
                        isJustInserted: lastInsertedId == item.id,
                        isFavorite: favorites.isFavorite(item)
                    ) {
                        lastInsertedId = item.id
                        onInsert(item.art)
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            if lastInsertedId == item.id {
                                lastInsertedId = nil
                            }
                        }
                    }
                }
            }
            .padding(.horizontal, 8)
            .padding(.vertical, 6)
        }
    }

    // MARK: - Bottom Toolbar

    private var bottomToolbar: some View {
        HStack(spacing: 4) {
            if needsGlobeKey {
                KeyboardToolbarButton(systemImage: "globe", action: onSwitchKeyboard)
            }

            KeyboardToolbarButton(
                systemImage: isSearching ? "xmark" : "magnifyingglass"
            ) {
                isSearching.toggle()
                if !isSearching { searchText = "" }
            }

            Spacer()

            KeyboardToolbarButton(systemImage: "delete.left", action: onDelete)
        }
        .padding(.horizontal, 10)
        .frame(height: 44)
        .background(Color(.secondarySystemGroupedBackground))
    }
}

// MARK: - Keyboard Item Button

struct KeyboardItemButton: View {
    let item: ASCIIItem
    let isJustInserted: Bool
    let isFavorite: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 8) {
                if isFavorite {
                    Image(systemName: "star.fill")
                        .font(.system(size: 10))
                        .foregroundColor(.yellow)
                }

                VStack(alignment: .leading, spacing: 2) {
                    Text(item.name)
                        .font(.system(size: 10))
                        .foregroundColor(.secondary)
                    Text(item.art)
                        .font(.system(size: 14, design: .monospaced))
                        .foregroundColor(isJustInserted ? .green : .primary)
                        .lineLimit(2)
                        .fixedSize(horizontal: false, vertical: true)
                }

                Spacer()

                Image(systemName: isJustInserted ? "checkmark" : "arrow.up.left")
                    .font(.system(size: 11))
                    .foregroundColor(isJustInserted ? .green : Color(.tertiaryLabel))
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(
                isJustInserted
                    ? Color.green.opacity(0.1)
                    : Color(.secondarySystemGroupedBackground)
            )
            .cornerRadius(8)
        }
        .buttonStyle(.plain)
        .animation(.easeInOut(duration: 0.2), value: isJustInserted)
    }
}

// MARK: - Toolbar Button

struct KeyboardToolbarButton: View {
    let systemImage: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Image(systemName: systemImage)
                .font(.system(size: 18))
                .frame(width: 44, height: 44)
                .contentShape(Rectangle())
        }
        .foregroundColor(.primary)
        .buttonStyle(.plain)
    }
}
