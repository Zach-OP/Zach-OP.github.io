import SwiftUI

struct CreateASCIIView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var customStore: CustomASCIIStore
    
    @State private var artText: String = ""
    @State private var artName: String = ""
    @State private var selectedCategoryId: String = "emoticons"
    @State private var showingSavedConfirmation: Bool = false
    
    private let availableCategories = [
        ("emoticons", "Emoticons", "face.smiling"),
        ("animals", "Animals", "pawprint.fill"),
        ("reactions", "Reactions", "hand.thumbsup.fill"),
        ("symbols", "Symbols", "sparkles"),
        ("dividers", "Dividers", "minus"),
        ("art", "Art", "paintbrush.fill"),
        ("text", "Text", "textformat"),
    ]
    
    private var canSave: Bool {
        !artText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        !artName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    artInputSection
                    nameInputSection
                    categorySelectionSection
                    previewSection
                }
                .padding()
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("Create ASCII Art")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        saveCustomArt()
                    }
                    .disabled(!canSave)
                    .bold()
                }
            }
            .alert("Saved!", isPresented: $showingSavedConfirmation) {
                Button("OK") {
                    dismiss()
                }
            } message: {
                Text("Your custom ASCII art has been saved and will appear in the \(categoryName(for: selectedCategoryId)) and Custom categories.")
            }
        }
    }
    
    // MARK: - Art Input Section
    
    private var artInputSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Label("ASCII Art", systemImage: "paintbrush")
                .font(.headline)
            
            VStack(spacing: 12) {
                TextEditor(text: $artText)
                    .font(.system(.body, design: .monospaced))
                    .frame(minHeight: 120)
                    .padding(8)
                    .background(Color(.secondarySystemGroupedBackground))
                    .cornerRadius(10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color(.separator), lineWidth: 0.5)
                    )
                
                Button {
                    if let clipboard = UIPasteboard.general.string {
                        artText = clipboard
                    }
                } label: {
                    Label("Paste from Clipboard", systemImage: "doc.on.clipboard")
                        .font(.subheadline)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 10)
                }
                .buttonStyle(.bordered)
            }
            
            Text("Enter or paste your ASCII art above")
                .font(.caption)
                .foregroundColor(.secondary)
        }
    }
    
    // MARK: - Name Input Section
    
    private var nameInputSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Label("Name", systemImage: "textformat")
                .font(.headline)
            
            TextField("e.g., Happy Face", text: $artName)
                .textFieldStyle(.roundedBorder)
                .autocorrectionDisabled()
            
            Text("Give your ASCII art a descriptive name")
                .font(.caption)
                .foregroundColor(.secondary)
        }
    }
    
    // MARK: - Category Selection Section
    
    private var categorySelectionSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Label("Category", systemImage: "folder")
                .font(.headline)
            
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 100))], spacing: 10) {
                ForEach(availableCategories, id: \.0) { category in
                    CategoryButton(
                        id: category.0,
                        name: category.1,
                        icon: category.2,
                        isSelected: selectedCategoryId == category.0
                    ) {
                        selectedCategoryId = category.0
                    }
                }
            }
            
            Text("Your art will appear in the selected category and the Custom category")
                .font(.caption)
                .foregroundColor(.secondary)
        }
    }
    
    // MARK: - Preview Section
    
    private var previewSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Label("Preview", systemImage: "eye")
                .font(.headline)
            
            if !artText.isEmpty {
                VStack(alignment: .leading, spacing: 8) {
                    if !artName.isEmpty {
                        Text(artName)
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    
                    Text(artText)
                        .font(.system(.body, design: .monospaced))
                        .foregroundColor(.primary)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
                .background(Color(.secondarySystemGroupedBackground))
                .cornerRadius(10)
            } else {
                Text("Your preview will appear here")
                    .font(.body)
                    .foregroundColor(.secondary)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding()
                    .background(Color(.secondarySystemGroupedBackground))
                    .cornerRadius(10)
            }
        }
    }
    
    // MARK: - Helper Methods
    
    private func saveCustomArt() {
        let trimmedArt = artText.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedName = artName.trimmingCharacters(in: .whitespacesAndNewlines)
        
        customStore.add(name: trimmedName, art: trimmedArt, categoryId: selectedCategoryId)
        showingSavedConfirmation = true
    }
    
    private func categoryName(for id: String) -> String {
        availableCategories.first { $0.0 == id }?.1 ?? "Unknown"
    }
}

// MARK: - Category Button

struct CategoryButton: View {
    let id: String
    let name: String
    let icon: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 6) {
                Image(systemName: icon)
                    .font(.title2)
                Text(name)
                    .font(.caption)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 12)
            .background(
                isSelected
                    ? Color.accentColor.opacity(0.2)
                    : Color(.secondarySystemGroupedBackground)
            )
            .foregroundColor(isSelected ? .accentColor : .primary)
            .cornerRadius(10)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(isSelected ? Color.accentColor : Color.clear, lineWidth: 2)
            )
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    CreateASCIIView()
        .environmentObject(CustomASCIIStore.shared)
}
