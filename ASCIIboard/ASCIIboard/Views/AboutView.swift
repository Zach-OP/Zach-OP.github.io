import SwiftUI

struct AboutView: View {
    @Environment(\.dismiss) private var dismiss

    private var appVersion: String {
        Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "—"
    }
    private var buildNumber: String {
        Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "—"
    }

    var body: some View {
        NavigationStack {
            List {
                Section {
                    HStack {
                        Spacer()
                        VStack(spacing: 12) {
                            Image(uiImage: UIImage(named: "AppIcon") ?? UIImage())
                                .resizable()
                                .frame(width: 90, height: 90)
                                .cornerRadius(20)
                                .shadow(color: .black.opacity(0.15), radius: 8, x: 0, y: 4)
                            Text("ASCIIboard")
                                .font(.system(size: 22, weight: .black, design: .monospaced))
                            Text("Your ASCII Art Keyboard")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                        .padding(.vertical, 12)
                        Spacer()
                    }
                }
                .listRowBackground(Color.clear)

                Section("App Info") {
                    LabeledContent("Version", value: appVersion)
                    LabeledContent("Build", value: buildNumber)
                }

                Section("Developer") {
                    Label("Zach Stedt", systemImage: "person.fill")
                    Button {
                        UIApplication.shared.open(URL(string: "https://github.com/Zach-OP")!)
                    } label: {
                        Label("github.com/Zach-OP", systemImage: "link")
                    }
                }
            }
            .listStyle(.insetGrouped)
            .navigationTitle("About")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") { dismiss() }
                }
            }
        }
    }
}
