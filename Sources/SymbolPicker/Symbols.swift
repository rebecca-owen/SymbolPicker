//
//  Symbols.swift
//  SymbolPicker
//
//  Created by Yubo Qin on 1/12/23.
//

import Foundation

/// Represents a category of emoji with a name and list of emoji characters.
struct EmojiCategory: Codable {
    let name: String
    let emoji: [String]
}

/// Container for emoji categories loaded from JSON.
struct EmojiData: Codable {
    let categories: [EmojiCategory]
}

/// Simple singleton class for providing symbols and emoji lists per platform availability.
class Symbols {
    /// Singleton instance.
    static let shared = Symbols()

    /// Array of all available symbol name strings.
    let allSymbols: [String]

    /// Array of emoji categories with their emoji.
    let emojiCategories: [EmojiCategory]

    /// Flattened array of all emoji across all categories.
    var allEmoji: [String] {
        emojiCategories.flatMap { $0.emoji }
    }

    private init() {
        // Load symbols based on platform availability
        if #available(iOS 26.0, macOS 26.0, tvOS 26.0, watchOS 26.0, visionOS 26.0, *) {
            self.allSymbols = Self.fetchSymbols(fileName: "sfsymbol7unrestricted")
        } else if #available(iOS 18.0, macOS 15.0, tvOS 18.0, watchOS 11.0, visionOS 2.0, *) {
            self.allSymbols = Self.fetchSymbols(fileName: "sfsymbol6unrestricted")
        } else if #available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, visionOS 1.0, *) {
            self.allSymbols = Self.fetchSymbols(fileName: "sfsymbol5unrestricted")
        } else if #available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *) {
            self.allSymbols = Self.fetchSymbols(fileName: "sfsymbol4unrestricted")
        } else {
            allSymbols = Self.fetchSymbols(fileName: "sfsymbol")
        }

        // Load emoji from JSON
        self.emojiCategories = Self.fetchEmoji()
    }

    private static func fetchSymbols(fileName: String) -> [String] {
        guard let path = Bundle.module.path(forResource: fileName, ofType: "txt"),
              let content = try? String(contentsOfFile: path)
        else {
            #if DEBUG
                assertionFailure("[SymbolPicker] Failed to load bundle resource file.")
            #endif
            return []
        }
        return content
            .split(separator: "\n")
            .map { String($0) }
    }

    private static func fetchEmoji() -> [EmojiCategory] {
        guard let path = Bundle.module.path(forResource: "emoji", ofType: "json"),
              let data = try? Data(contentsOf: URL(fileURLWithPath: path)),
              let emojiData = try? JSONDecoder().decode(EmojiData.self, from: data)
        else {
            #if DEBUG
                assertionFailure("[SymbolPicker] Failed to load emoji resource file.")
            #endif
            return []
        }
        return emojiData.categories
    }
}
