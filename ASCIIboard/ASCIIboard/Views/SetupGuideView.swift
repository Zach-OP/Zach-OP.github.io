import SwiftUI

struct SetupGuideView: View {
    var body: some View {
        NavigationStack {
            List {
                introSection
                stepsSection
                tipsSection
                openSettingsSection
            }
            .listStyle(.insetGrouped)
            .navigationTitle("Setup Guide")
        }
    }

    // MARK: - Sections

    private var introSection: some View {
        Section {
            Text("Add ASCIIboard as a keyboard in iOS Settings so you can use it anywhere you type — messages, notes, email, and more.")
                .foregroundColor(.secondary)
                .padding(.vertical, 4)
        } header: {
            Text("Getting Started")
        }
    }

    private var stepsSection: some View {
        Section {
            SetupStep(
                number: 1,
                title: "Open Settings",
                description: "Open the iOS Settings app on your device.",
                icon: "gear"
            )
            SetupStep(
                number: 2,
                title: "Go to Keyboards",
                description: "Navigate to General → Keyboard → Keyboards, then tap \"Add New Keyboard…\"",
                icon: "keyboard"
            )
            SetupStep(
                number: 3,
                title: "Select ASCIIboard",
                description: "Find \"ASCIIboard\" in the list and tap it to add the keyboard.",
                icon: "plus.circle"
            )
            SetupStep(
                number: 4,
                title: "Allow Full Access (Optional)",
                description: "Tap ASCIIboard in your keyboard list and enable \"Allow Full Access\" to sync favorites across the app and keyboard.",
                icon: "checkmark.shield"
            )
        } header: {
            Text("Setup Steps")
        }
    }

    private var tipsSection: some View {
        Section {
            TipRow(icon: "globe", text: "Switch keyboards by tapping the 🌐 globe icon while typing.")
            TipRow(icon: "hand.tap", text: "Tap any ASCII art in the keyboard to instantly insert it.")
            TipRow(icon: "magnifyingglass", text: "Use the search icon in the keyboard to find specific art quickly.")
            TipRow(icon: "square.grid.2x2", text: "Browse by category using the tabs at the top of the keyboard.")
            TipRow(icon: "star", text: "Star favorites in the app — they appear at the top in the keyboard.")
        } header: {
            Text("Usage Tips")
        }
    }

    private var openSettingsSection: some View {
        Section {
            Button {
                if let url = URL(string: UIApplication.openSettingsURLString) {
                    UIApplication.shared.open(url)
                }
            } label: {
                HStack {
                    Spacer()
                    Label("Open Settings", systemImage: "arrow.up.right.square")
                        .font(.headline)
                    Spacer()
                }
            }
        }
    }
}

// MARK: - Reusable Components

struct SetupStep: View {
    let number: Int
    let title: String
    let description: String
    let icon: String

    var body: some View {
        HStack(alignment: .top, spacing: 14) {
            ZStack {
                Circle()
                    .fill(Color.accentColor)
                    .frame(width: 34, height: 34)
                Text("\(number)")
                    .font(.headline)
                    .foregroundColor(.white)
            }

            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.headline)
                Text(description)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
        .padding(.vertical, 4)
    }
}

struct TipRow: View {
    let icon: String
    let text: String

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: icon)
                .frame(width: 22)
                .foregroundColor(.accentColor)
            Text(text)
                .font(.subheadline)
                .foregroundColor(.secondary)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(.vertical, 2)
    }
}
