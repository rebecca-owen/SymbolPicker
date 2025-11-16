# SymbolPicker

A simple and cross-platform SFSymbol and Emoji picker for SwiftUI

![](https://img.shields.io/badge/License-MIT-green)
![](https://img.shields.io/badge/Platform-iOS%20%7C%20macOS%20%7C%20tvOS%20%7C%20watchOS-blue)

## Features

SymbolPicker provides a simple and cross-platform interface for picking SFSymbols and Emoji with intelligent search functionality. The picker is implemented with SwiftUI and supports iOS, macOS, tvOS and watchOS platforms.

### Key Features

- **5,800+ SF Symbols** with platform-aware loading (iOS 14-26+)
- **1,000+ Emoji** organized in 10 categories
- **AI-Powered Suggestions** using Apple Intelligence (iOS 26+) with keyword-based fallback
- **Intelligent Search** across symbols, emoji, and categories
- **Cross-Platform** support for iOS, macOS, tvOS, and watchOS
- **Customizable** suggested symbols and optional emoji picker
- **Hierarchical Rendering** for modern SF Symbols (iOS 15+)
- **100% Backward Compatible** with existing implementations

![](/Screenshots/demo.png)

## Usage

### Requirements

* iOS 14.0+ / macOS 12.0+ / tvOS 14.0+ / watchOS 8.0+
* Xcode 13.0+
* Swift 5.0+

### Installation

SymbolPicker is available as a Swift Package. Add this repo to your project through Xcode GUI or `Package.swift`.

```swift
dependencies: [
    .package(url: "https://github.com/xnth97/SymbolPicker.git", .upToNextMajor(from: "1.4.0"))
]
```

### Basic Example

It is suggested to use SymbolPicker within a `sheet`.

```swift
import SwiftUI
import SymbolPicker

struct ContentView: View {
    @State private var iconPickerPresented = false
    @State private var icon = "pencil"

    var body: some View {
        Button {
            iconPickerPresented = true
        } label: {
            HStack {
                // Display symbol or emoji
                if icon.unicodeScalars.first?.properties.isEmoji == true {
                    Text(icon)
                } else {
                    Image(systemName: icon)
                }
                Text(icon)
            }
        }
        .sheet(isPresented: $iconPickerPresented) {
            SymbolPicker(symbol: $icon)
        }
    }
}
```

### Advanced Examples

**With Custom Suggestions:**

```swift
SymbolPicker(
    symbol: $icon,
    suggestedSymbols: ["star", "heart", "bookmark", "tag"]
)
```

**With Context-Based AI Suggestions:**

```swift
// AI will suggest fitness-related symbols/emoji even before user searches
SymbolPicker(
    symbol: $icon,
    contextString: "fitness"
)

// Or for a food-related feature
SymbolPicker(
    symbol: $icon,
    contextString: "food and drink"
)
```

**Symbols Only (Disable Emoji):**

```swift
SymbolPicker(
    symbol: $icon,
    enableEmojiPicker: false
)
```

**Disable AI Suggestions:**

```swift
SymbolPicker(
    symbol: $icon,
    enableIntelligentSuggestions: false
)
```

**Full Configuration:**

```swift
SymbolPicker(
    symbol: $icon,
    suggestedSymbols: ["camera", "photo", "video"],
    contextString: "photography",
    enableEmojiPicker: true,
    enableIntelligentSuggestions: true
)
```

## New in Version 2.0

- [x] **Emoji Picker** - 1,000+ emoji organized in 10 categories
- [x] **AI-Powered Suggestions** - Apple Intelligence integration (iOS 26+) with keyword fallback
- [x] **Enhanced UX** - Segmented control, category organization, better visual hierarchy
- [x] **Intelligent Search** - Real-time suggestions across symbols and emoji
- [x] **Hierarchical Rendering** - Modern SF Symbol rendering (iOS 15+)

See [CLAUDE.md](CLAUDE.md) for detailed documentation of new features and architecture.

## TODO

- [x] Emoji support
- [x] AI-powered suggestions
- [x] Categories support (for emoji)
- [x] Multiplatform support
- [x] Platform availability support
- [ ] Inline UI
- [ ] Recents tracking
- [ ] Favorites support
- [ ] Codegen from latest SF Symbols

## License

SymbolPicker is available under the MIT license. See the [LICENSE](LICENSE) file for more info.
