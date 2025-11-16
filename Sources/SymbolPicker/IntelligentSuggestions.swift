//
//  IntelligentSuggestions.swift
//  SymbolPicker
//
//  AI-powered suggestions using Apple Intelligence (iOS 26+)
//

import Foundation

#if canImport(Intelligence)
import Intelligence
#endif

/// Service for generating intelligent symbol and emoji suggestions based on text input.
@available(iOS 14.0, macOS 12.0, tvOS 14.0, watchOS 8.0, *)
class IntelligentSuggestions {
    /// Singleton instance.
    static let shared = IntelligentSuggestions()

    private init() {}

    /// Suggests relevant symbols based on input text using Apple Intelligence or keyword matching.
    /// - Parameters:
    ///   - text: The input text to analyze
    ///   - maxSuggestions: Maximum number of suggestions to return (default: 10)
    /// - Returns: Array of suggested symbol names
    func suggestSymbols(for text: String, maxSuggestions: Int = 10) async -> [String] {
        guard !text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            return []
        }

        // Use Apple Intelligence on iOS 26+
        if #available(iOS 26.0, macOS 26.0, tvOS 26.0, watchOS 26.0, visionOS 26.0, *) {
            return await suggestSymbolsWithAppleIntelligence(for: text, maxSuggestions: maxSuggestions)
        } else {
            // Fallback to keyword-based matching
            return suggestSymbolsWithKeywords(for: text, maxSuggestions: maxSuggestions)
        }
    }

    /// Suggests relevant emoji based on input text using Apple Intelligence or keyword matching.
    /// - Parameters:
    ///   - text: The input text to analyze
    ///   - maxSuggestions: Maximum number of suggestions to return (default: 10)
    /// - Returns: Array of suggested emoji
    func suggestEmoji(for text: String, maxSuggestions: Int = 10) async -> [String] {
        guard !text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            return []
        }

        // Use Apple Intelligence on iOS 26+
        if #available(iOS 26.0, macOS 26.0, tvOS 26.0, watchOS 26.0, visionOS 26.0, *) {
            return await suggestEmojiWithAppleIntelligence(for: text, maxSuggestions: maxSuggestions)
        } else {
            // Fallback to keyword-based matching
            return suggestEmojiWithKeywords(for: text, maxSuggestions: maxSuggestions)
        }
    }

    // MARK: - Apple Intelligence Integration (iOS 26+)

    @available(iOS 26.0, macOS 26.0, tvOS 26.0, watchOS 26.0, visionOS 26.0, *)
    private func suggestSymbolsWithAppleIntelligence(for text: String, maxSuggestions: Int) async -> [String] {
        // Note: This is a forward-looking API design for iOS 26 Apple Intelligence integration
        // When iOS 26 is released, this should be updated to use the actual Apple Intelligence APIs
        // For now, we'll use the semantic analysis approach with keyword matching as a placeholder

        #if canImport(Intelligence)
        // Future implementation will use Apple Intelligence Foundation Models
        // Example conceptual API (not yet available):
        // let suggestions = try? await IntelligenceFoundation.shared.suggestSymbols(
        //     forContext: text,
        //     maxResults: maxSuggestions
        // )
        // return suggestions ?? []
        #endif

        // Enhanced keyword matching as placeholder until Apple Intelligence APIs are available
        return suggestSymbolsWithKeywords(for: text, maxSuggestions: maxSuggestions)
    }

    @available(iOS 26.0, macOS 26.0, tvOS 26.0, watchOS 26.0, visionOS 26.0, *)
    private func suggestEmojiWithAppleIntelligence(for text: String, maxSuggestions: Int) async -> [String] {
        // Note: This is a forward-looking API design for iOS 26 Apple Intelligence integration
        // When iOS 26 is released, this should be updated to use the actual Apple Intelligence APIs

        #if canImport(Intelligence)
        // Future implementation will use Apple Intelligence Foundation Models
        // Example conceptual API (not yet available):
        // let suggestions = try? await IntelligenceFoundation.shared.suggestEmoji(
        //     forContext: text,
        //     maxResults: maxSuggestions
        // )
        // return suggestions ?? []
        #endif

        // Enhanced keyword matching as placeholder until Apple Intelligence APIs are available
        return suggestEmojiWithKeywords(for: text, maxSuggestions: maxSuggestions)
    }

    // MARK: - Keyword-Based Matching (Fallback)

    private func suggestSymbolsWithKeywords(for text: String, maxSuggestions: Int) -> [String] {
        let lowercasedText = text.lowercased()
        let words = lowercasedText.components(separatedBy: .whitespacesAndNewlines)
            .filter { !$0.isEmpty }

        // Keyword to symbol mappings
        let keywordMappings: [String: [String]] = [
            // Common concepts
            "home": ["house", "house.fill", "building.2", "door.left.hand.open"],
            "work": ["briefcase", "briefcase.fill", "building.2", "desktopcomputer"],
            "love": ["heart", "heart.fill", "heart.circle", "heart.square"],
            "favorite": ["star", "star.fill", "heart", "heart.fill"],
            "important": ["exclamationmark", "star", "flag", "flag.fill"],
            "photo": ["camera", "camera.fill", "photo", "photo.fill"],
            "music": ["music.note", "music.note.list", "headphones", "speaker.wave.2"],
            "video": ["video", "video.fill", "play.rectangle", "film"],
            "mail": ["envelope", "envelope.fill", "mail", "mail.stack"],
            "message": ["message", "message.fill", "bubble.left", "bubble.right"],
            "phone": ["phone", "phone.fill", "iphone", "phone.circle"],
            "calendar": ["calendar", "calendar.circle", "calendar.badge.clock"],
            "time": ["clock", "clock.fill", "timer", "alarm"],
            "location": ["mappin", "mappin.circle", "map", "location"],
            "search": ["magnifyingglass", "magnifyingglass.circle", "doc.text.magnifyingglass"],
            "settings": ["gearshape", "gearshape.fill", "gear", "slider.horizontal.3"],
            "user": ["person", "person.fill", "person.circle", "person.crop.circle"],
            "people": ["person.2", "person.3", "person.2.fill", "person.3.fill"],
            "food": ["fork.knife", "takeoutbag.and.cup.and.straw", "cup.and.saucer"],
            "drink": ["cup.and.saucer", "wineglass", "mug"],
            "weather": ["cloud", "sun.max", "cloud.rain", "cloud.sun"],
            "car": ["car", "car.fill", "car.2", "car.circle"],
            "travel": ["airplane", "airplane.circle", "suitcase", "map"],
            "shopping": ["cart", "cart.fill", "bag", "bag.fill"],
            "money": ["dollarsign", "dollarsign.circle", "creditcard", "banknote"],
            "health": ["heart.text.square", "cross.case", "medical.thermometer"],
            "fitness": ["figure.run", "figure.walk", "figure.strengthtraining.traditional"],
            "sport": ["sportscourt", "football", "basketball", "baseball"],
            "book": ["book", "book.fill", "books.vertical", "text.book.closed"],
            "education": ["graduationcap", "pencil", "book"],
            "nature": ["leaf", "leaf.fill", "tree", "sun.max"],
            "animal": ["pawprint", "hare", "tortoise", "ant"],
            "folder": ["folder", "folder.fill", "folder.badge.plus"],
            "file": ["doc", "doc.fill", "doc.text", "doc.plaintext"],
            "trash": ["trash", "trash.fill", "trash.circle"],
            "download": ["arrow.down.circle", "arrow.down.to.line", "icloud.and.arrow.down"],
            "upload": ["arrow.up.circle", "arrow.up.to.line", "icloud.and.arrow.up"],
            "share": ["square.and.arrow.up", "square.and.arrow.up.fill"],
            "delete": ["trash", "xmark.circle", "minus.circle"],
            "add": ["plus", "plus.circle", "plus.square"],
            "remove": ["minus", "minus.circle", "xmark"],
            "check": ["checkmark", "checkmark.circle", "checkmark.square"],
            "warning": ["exclamationmark.triangle", "exclamationmark.circle"],
            "error": ["xmark.octagon", "exclamationmark.triangle"],
            "info": ["info.circle", "questionmark.circle"],
            "lock": ["lock", "lock.fill", "lock.circle"],
            "unlock": ["lock.open", "lock.open.fill"],
            "security": ["lock.shield", "checkmark.shield", "key"],
            "wifi": ["wifi", "wifi.circle"],
            "bluetooth": ["bluetooth", "antenna.radiowaves.left.and.right"],
            "battery": ["battery.100", "battery.25", "bolt.fill"],
            "power": ["power", "bolt", "bolt.fill"],
        ]

        var matchedSymbols: [(symbol: String, score: Int)] = []
        let allSymbols = Symbols.shared.allSymbols

        // Score symbols based on keyword matches
        for symbol in allSymbols {
            var score = 0

            // Direct keyword match
            for word in words {
                if let mapping = keywordMappings[word] {
                    if mapping.contains(symbol) {
                        score += 10
                    }
                }

                // Partial match in symbol name
                if symbol.lowercased().contains(word) {
                    score += 5
                }
            }

            // Exact text match
            if symbol.lowercased().contains(lowercasedText) {
                score += 15
            }

            if score > 0 {
                matchedSymbols.append((symbol, score))
            }
        }

        // Sort by score and return top results
        return matchedSymbols
            .sorted { $0.score > $1.score }
            .prefix(maxSuggestions)
            .map { $0.symbol }
    }

    private func suggestEmojiWithKeywords(for text: String, maxSuggestions: Int) -> [String] {
        let lowercasedText = text.lowercased()
        let words = lowercasedText.components(separatedBy: .whitespacesAndNewlines)
            .filter { !$0.isEmpty }

        // Keyword to emoji mappings
        let keywordMappings: [String: [String]] = [
            "love": ["❤️", "😍", "🥰", "💕", "💖", "💗", "💓", "💞", "💘", "💝"],
            "happy": ["😀", "😃", "😄", "😁", "😊", "🙂", "😺", "🥳", "🎉"],
            "sad": ["😢", "😭", "😞", "😔", "☹️", "🙁", "😿"],
            "angry": ["😠", "😡", "🤬", "😤"],
            "laugh": ["😂", "🤣", "😹"],
            "cool": ["😎", "🆒", "👍", "🤘"],
            "food": ["🍔", "🍕", "🍟", "🌭", "🍿", "🥗", "🍝", "🍜"],
            "drink": ["☕️", "🍺", "🍷", "🥤", "🧋", "🍹", "🥂"],
            "animal": ["🐶", "🐱", "🐭", "🐹", "🐰", "🦊", "🐻", "🐼"],
            "nature": ["🌲", "🌳", "🌴", "🌱", "🌿", "☘️", "🍀", "🌾"],
            "sport": ["⚽️", "🏀", "🏈", "⚾️", "🎾", "🏐", "🏉"],
            "travel": ["✈️", "🚗", "🚕", "🚙", "🚌", "🚎", "🏎", "🚓"],
            "heart": ["❤️", "🧡", "💛", "💚", "💙", "💜", "🖤", "🤍", "🤎"],
            "star": ["⭐️", "🌟", "✨", "💫"],
            "fire": ["🔥"],
            "water": ["💧", "💦", "🌊"],
            "sun": ["☀️", "🌞", "🌅", "🌄"],
            "moon": ["🌙", "🌛", "🌜", "🌚", "🌝"],
            "celebration": ["🎉", "🎊", "🎈", "🎁", "🎂", "🍾"],
            "music": ["🎵", "🎶", "🎸", "🎹", "🎤", "🎧"],
            "work": ["💼", "👔", "💻", "🖥", "⌨️"],
            "home": ["🏠", "🏡"],
            "money": ["💰", "💵", "💴", "💶", "💷", "💸", "💳"],
            "time": ["⏰", "⏱", "⏲", "⌛️", "⏳", "🕐"],
            "phone": ["📱", "☎️", "📞"],
            "computer": ["💻", "🖥", "⌨️", "🖱"],
            "book": ["📖", "📚", "📕", "📗", "📘", "📙"],
            "hand": ["👋", "🤚", "🖐", "✋", "👌"],
            "thumbsup": ["👍"],
            "thumbsdown": ["👎"],
            "clap": ["👏"],
            "pray": ["🙏"],
            "strong": ["💪"],
            "think": ["🤔"],
            "sleep": ["😴", "💤"],
            "party": ["🥳", "🎉", "🎊"],
            "gift": ["🎁"],
            "yes": ["✅", "👍", "☑️"],
            "no": ["❌", "👎", "⛔️"],
            "warning": ["⚠️", "⚡️"],
            "stop": ["🛑", "✋"],
            "check": ["✅", "✔️", "☑️"],
        ]

        var matchedEmoji: [(emoji: String, score: Int)] = []
        let allCategories = Symbols.shared.emojiCategories

        // Score emoji based on keyword matches
        for category in allCategories {
            for emoji in category.emoji {
                var score = 0

                // Check if category name matches any word
                for word in words {
                    if category.name.lowercased().contains(word) {
                        score += 3
                    }

                    // Keyword mapping match
                    if let mapping = keywordMappings[word] {
                        if mapping.contains(emoji) {
                            score += 15
                        }
                    }
                }

                // Check if any keyword matches category
                if let _ = keywordMappings[lowercasedText] {
                    score += 2
                }

                if score > 0 {
                    matchedEmoji.append((emoji, score))
                }
            }
        }

        // Sort by score and return top results
        return matchedEmoji
            .sorted { $0.score > $1.score }
            .prefix(maxSuggestions)
            .map { $0.emoji }
    }
}
