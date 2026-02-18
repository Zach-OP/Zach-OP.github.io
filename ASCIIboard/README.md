# ASCIIboard

A custom iOS keyboard app that lets you instantly paste ASCII art and emoticons anywhere you type.

```
  ___  ___  ___ ___ ___ _                        _
 / _ \/ __||  _|_ _|_ _| |__  ___  __ _  _ _  __| |
| (_) \__ \| (_) || | | || '_ \/ _ \/ _` || '_|/ _` |
 \__\_\___/ \___||_||___|_|_|_\___/\__,_||_|  \__,_|
```

---

## Features

- **100+ pieces** of ASCII art across 7 categories: Emoticons, Animals, Reactions, Symbols, Dividers, Art, and Text
- **Instant insert** — tap any item in the keyboard to insert it directly into any text field
- **Search** — find art by name or content with the in-keyboard search bar
- **Favorites** — star items in the main app; they are highlighted in the keyboard
- **Copy to clipboard** — one tap to copy any art from the browse or home screen
- **No internet required** — everything is built in; no server, no tracking
- **iOS 16+ / iPadOS 16+**, SwiftUI throughout

---

## Project Structure

```
ASCIIboard/
├── project.yml                       # XcodeGen project spec
├── Makefile                          # Dev convenience commands
│
├── Shared/                           # Compiled into BOTH targets
│   ├── ASCIIArt.swift                # Data models: ASCIICategory, ASCIIItem, FavoritesStore
│   └── ASCIILibrary.swift            # All ASCII art data (7 categories, 100+ items)
│
├── ASCIIboard/                       # Main app target
│   ├── Info.plist
│   ├── App/
│   │   └── ASCIIboardApp.swift       # @main SwiftUI entry point
│   └── Views/
│       ├── ContentView.swift         # Root tab-bar container
│       ├── HomeView.swift            # Home tab: logo, stats, featured art, setup banner
│       ├── GalleryView.swift         # Browse tab: category filter + searchable list
│       ├── FavoritesView.swift       # Favorites tab: starred items
│       └── SetupGuideView.swift      # Setup tab: step-by-step keyboard activation guide
│
└── ASCIIboardKeyboard/               # Keyboard extension target
    ├── Info.plist
    ├── KeyboardViewController.swift  # UIInputViewController; hosts SwiftUI via UIHostingController
    └── KeyboardView.swift            # Full SwiftUI keyboard UI
```

---

## Getting Started

### Prerequisites

| Tool | Install |
|------|---------|
| Xcode 15+ | [Mac App Store](https://apps.apple.com/app/xcode/id497799835) |
| XcodeGen | `brew install xcodegen` |

### First-time setup

```bash
# Clone the repo (or cd into the ASCIIboard/ folder in this repo)
cd ASCIIboard

# Install XcodeGen (if needed) and generate the Xcode project
make setup

# Open in Xcode
make open
```

### Subsequent runs

```bash
# Regenerate after editing project.yml
make generate

# Open without regenerating
open ASCIIboard.xcodeproj
```

---

## Configuration

### Bundle IDs

Edit `project.yml` to set your own bundle ID prefix:

```yaml
options:
  bundleIdPrefix: com.yourname   # change this
```

The two targets will use:
- `<prefix>.asciboard` — main app
- `<prefix>.asciboard.keyboard` — keyboard extension

### App Group (for Favorites sync)

To sync favorites between the main app and keyboard extension, add an App Group entitlement to both targets in Xcode's **Signing & Capabilities** tab:

```
group.<your-bundle-id-prefix>.asciboard
```

Then update the `suiteName` in `Shared/ASCIIArt.swift`:

```swift
defaults = UserDefaults(suiteName: "group.com.yourname.asciboard") ?? .standard
```

> Without the App Group, favorites sync is skipped and each target uses its own standard UserDefaults. The keyboard still works fully.

### Full Access

The keyboard extension's `Info.plist` sets `RequestsOpenAccess = true` to enable the App Group shared UserDefaults. If you don't need favorites sync, you can set it to `false` — users won't be prompted to grant full access.

---

## Adding ASCII Art

All art lives in `Shared/ASCIILibrary.swift`. To add a new item:

```swift
ASCIIItem(id: "my_art", name: "My Art", art: "(ツ)")
```

To add a new category:

```swift
static let myCategory = ASCIICategory(
    id: "my_category",
    name: "My Category",
    systemIcon: "star",           // SF Symbol name
    items: [ /* ASCIIItems */ ]
)
```

Then add it to the `categories` array:

```swift
static let categories: [ASCIICategory] = [
    emoticons,
    animals,
    // ...
    myCategory,   // add here
]
```

---

## Architecture

```
┌─────────────────────────────────────────────────────────┐
│                     Shared Layer                         │
│  ASCIILibrary (static data) · FavoritesStore (shared    │
│  UserDefaults via App Group) · ASCIIArt models           │
└───────────────┬─────────────────────────┬───────────────┘
                │                         │
   ┌────────────▼──────────┐  ┌───────────▼──────────────┐
   │      Main App          │  │    Keyboard Extension     │
   │  SwiftUI TabView       │  │  UIInputViewController    │
   │  Home / Browse /       │  │  + UIHostingController    │
   │  Favorites / Setup     │  │  wrapping SwiftUI         │
   │                        │  │  KeyboardView             │
   │  Copy to clipboard     │  │                           │
   │  Favorites management  │  │  textDocumentProxy        │
   └────────────────────────┘  │  .insertText()            │
                               └──────────────────────────┘
```

### Key design decisions

- **Shared sources** — `Shared/` is compiled into both targets, eliminating duplication. No framework target needed for this scale.
- **SwiftUI keyboard** — The extension uses `UIHostingController` to host SwiftUI inside `UIInputViewController`. This is the recommended modern pattern.
- **No Full Access required for core features** — The keyboard inserts text via `textDocumentProxy`; Full Access is only needed for the optional favorites sync via App Group.
- **Static data** — Art is hardcoded in Swift, not a JSON bundle resource, to avoid resource-loading complexity inside an extension.

---

## Running on Device

Custom keyboard extensions **cannot be tested in the iOS Simulator** — you must run on a physical device:

1. Connect your iPhone or iPad
2. In Xcode, select your device as the run destination
3. Run the `ASCIIboard` scheme
4. On the device, go to **Settings → General → Keyboard → Keyboards → Add New Keyboard** and select **ASCIIboard**
5. Open any app with a text field, tap the text field, and switch to ASCIIboard using the 🌐 globe key

---

## License

MIT — see `LICENSE` for details.
