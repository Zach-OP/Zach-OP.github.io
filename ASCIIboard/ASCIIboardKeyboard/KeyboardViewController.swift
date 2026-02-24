import UIKit
import SwiftUI

/// The entry point for the ASCIIboard keyboard extension.
/// Embeds a SwiftUI KeyboardView inside the UIInputViewController using UIHostingController.
final class KeyboardViewController: UIInputViewController {

    private var hostingController: UIHostingController<KeyboardView>?

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupKeyboardView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Refresh the globe key visibility in case it changed.
        updateKeyboardView()
    }

    // MARK: - Setup

    private func makeKeyboardView() -> KeyboardView {
        KeyboardView(
            needsGlobeKey: needsInputModeSwitchKey,
            onInsert: { [weak self] text in
                self?.textDocumentProxy.insertText(text)
            },
            onDelete: { [weak self] in
                self?.textDocumentProxy.deleteBackward()
            },
            onSwitchKeyboard: { [weak self] in
                self?.advanceToNextInputMode()
            }
        )
    }

    private func setupKeyboardView() {
        let keyboardView = makeKeyboardView()
        let hc = UIHostingController(rootView: keyboardView)
        hostingController = hc

        addChild(hc)
        view.addSubview(hc.view)
        hc.didMove(toParent: self)

        hc.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            hc.view.topAnchor.constraint(equalTo: view.topAnchor),
            hc.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            hc.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            hc.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }

    private func updateKeyboardView() {
        hostingController?.rootView = makeKeyboardView()
    }

    // MARK: - Required UIInputViewController Stubs

    override func textWillChange(_ textInput: UITextInput?) {}
    override func textDidChange(_ textInput: UITextInput?) {}
}
