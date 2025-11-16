//
//  SymbolPicker.swift
//  SymbolPicker
//
//  Created by Yubo Qin on 2/14/22.
//

import SwiftUI

// MARK: - Hierarchical Image Utility

extension Image {
    /// Creates a system image with hierarchical rendering applied automatically,
    /// except for symbols that don't support hierarchical rendering
    /// - Parameter systemName: The SF Symbol name
    /// - Returns: Image with hierarchical rendering applied where supported
    static func systemHierarchical(_ systemName: String) -> Image {
        let symbolsWithoutHierarchicalSupport: Set<String> = [
            "shippingbox.and.arrow.backward.fill",
        ]

        let image = Image(systemName: systemName)

        if symbolsWithoutHierarchicalSupport.contains(systemName) {
            return image
        } else {
            if #available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *) {
                return image.symbolRenderingMode(.hierarchical)
            } else {
                // Fallback on earlier versions: return the plain image
                return image
            }
        }
    }
}

/// Represents the type of item being picked (symbol or emoji).
public enum PickerType: String, CaseIterable {
    case symbols = "Symbols"
    case emoji = "Emoji"
}

/// A simple and cross-platform SFSymbol and Emoji picker for SwiftUI.
public struct SymbolPicker: View {
    // MARK: - Static consts

    private static var symbols: [String] {
        Symbols.shared.allSymbols
    }

    private static let commonSymbols: [String] = [
        "figure.run",
        "figure.walk.motion",
        "fork.knife",
        "book",
        "drop.circle",
        "flame.fill",
        "gamecontroller",
        "cup.and.saucer.fill",
        "bed.double",
        "toilet.fill",
        "pencil.and.outline",
        "trash",
        "graduationcap",
        "figure.2.and.child.holdinghands",
        "figure.pool.swim",
        "dumbbell.fill",
        "basketball",
        "trophy.fill",
        "sun.haze.fill",
        "zzz",
        "dollarsign",
        "heart.square",
        "star",
        "camera",
        "quote.opening",
        "phone.arrow.up.right.fill",
        "basket",
        "dice",
        "paintbrush.pointed.fill",
        "wrench.adjustable.fill",
        "stethoscope",
        "frying.pan",
        "washer",
        "cooktop.fill",
        "sink",
        "headphones",
        "tv",
        "radio",
        "guitars.fill",
        "airplane",
        "car.fill",
        "pawprint.fill",
        "leaf.fill",
        "shoeprints.fill",
        "wineglass",
    ]

    private static var gridDimension: CGFloat {
        #if os(iOS)
            return 64
        #elseif os(tvOS)
            return 128
        #elseif os(macOS)
            return 48
        #else
            return 48
        #endif
    }

    private static var symbolSize: CGFloat {
        #if os(iOS)
            return 24
        #elseif os(tvOS)
            return 48
        #elseif os(macOS)
            return 24
        #else
            return 24
        #endif
    }

    private static var symbolCornerRadius: CGFloat {
        #if os(iOS)
            return 8
        #elseif os(tvOS)
            return 12
        #elseif os(macOS)
            return 8
        #else
            return 8
        #endif
    }

    private static var unselectedItemBackgroundColor: Color {
        #if os(iOS)
            return Color(UIColor.systemBackground)
        #else
            return .clear
        #endif
    }

    private static var selectedItemBackgroundColor: Color {
        #if os(tvOS)
            return Color.gray.opacity(0.3)
        #else
            return Color.accentColor
        #endif
    }

    private static var backgroundColor: Color {
        #if os(iOS)
            return Color(UIColor.systemGroupedBackground)
        #else
            return .clear
        #endif
    }

    // MARK: - Properties

    private let suggestedSymbols: [String]?
    private let enableEmojiPicker: Bool
    private let enableIntelligentSuggestions: Bool
    private let contextString: String?

    @Binding public var symbol: String
    @State private var searchText = ""
    @State private var selectedPickerType: PickerType = .symbols
    @State private var intelligentSymbolSuggestions: [String] = []
    @State private var intelligentEmojiSuggestions: [String] = []
    @Environment(\.presentationMode) private var presentationMode

    // MARK: - Public Init

    /// Initializes `SymbolPicker` with a string binding that captures the raw value of
    /// user-selected SFSymbol or emoji.
    /// - Parameters:
    ///   - symbol: String binding to store user selection.
    ///   - suggestedSymbols: Optional array of symbol names to feature at the top of the list.
    ///   - contextString: Optional context string to generate AI suggestions before user searches (e.g., "fitness", "food", "travel").
    ///   - enableEmojiPicker: Whether to enable the emoji picker tab (default: true).
    ///   - enableIntelligentSuggestions: Whether to enable AI-powered suggestions based on search (default: true, requires iOS 26+).
    public init(
        symbol: Binding<String>,
        suggestedSymbols: [String]? = nil,
        contextString: String? = nil,
        enableEmojiPicker: Bool = true,
        enableIntelligentSuggestions: Bool = true
    ) {
        _symbol = symbol
        self.suggestedSymbols = suggestedSymbols
        self.contextString = contextString
        self.enableEmojiPicker = enableEmojiPicker
        self.enableIntelligentSuggestions = enableIntelligentSuggestions
    }

    // MARK: - View Components

    @ViewBuilder
    private var pickerView: some View {
        if enableEmojiPicker {
            #if os(iOS)
            if #available(iOS 13.0, *) {
                Picker("Type", selection: $selectedPickerType) {
                    ForEach(PickerType.allCases, id: \.self) { type in
                        Text(type.rawValue).tag(type)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding(.horizontal)
            }
            #elseif os(macOS)
            Picker("Type", selection: $selectedPickerType) {
                ForEach(PickerType.allCases, id: \.self) { type in
                    Text(type.rawValue).tag(type)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding(.horizontal)
            #else
            Picker("Type", selection: $selectedPickerType) {
                ForEach(PickerType.allCases, id: \.self) { type in
                    Text(type.rawValue).tag(type)
                }
            }
            .padding(.horizontal)
            #endif
        }
    }

    @ViewBuilder
    private var searchableSymbolGrid: some View {
        #if os(iOS)
            if #available(iOS 15.0, *) {
                VStack(spacing: 8) {
                    pickerView
                    if selectedPickerType == .symbols {
                        symbolGrid
                    } else {
                        emojiGrid
                    }
                }
                .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always))
            } else {
                VStack {
                    TextField(LocalizedString("search_placeholder"), text: $searchText)
                        .padding(8)
                        .padding(.horizontal, 8)
                        .background(Color(UIColor.systemGray5))
                        .cornerRadius(8.0)
                        .padding(.horizontal, 16.0)
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                    pickerView
                    if selectedPickerType == .symbols {
                        symbolGrid
                    } else {
                        emojiGrid
                    }
                }
                .padding(.top)
            }
        #elseif os(tvOS)
            VStack {
                TextField(LocalizedString("search_placeholder"), text: $searchText)
                    .padding(.horizontal, 8)
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
                pickerView
                if selectedPickerType == .symbols {
                    symbolGrid
                } else {
                    emojiGrid
                }
            }

        /// `searchable` is crashing on tvOS 16
        ///
        /// symbolGrid
        ///     .searchable(text: $searchText, placement: .automatic)
        #elseif os(macOS)
            VStack(spacing: 0) {
                HStack {
                    TextField(LocalizedString("search_placeholder"), text: $searchText)
                        .textFieldStyle(.plain)
                        .font(.system(size: 18.0))
                        .disableAutocorrection(true)

                    Button {
                        presentationMode.wrappedValue.dismiss()
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .resizable()
                            .frame(width: 16.0, height: 16.0)
                    }
                    .buttonStyle(.borderless)
                }
                .padding()

                Divider()

                pickerView
                    .padding(.top, 8)

                if selectedPickerType == .symbols {
                    symbolGrid
                } else {
                    emojiGrid
                }
            }
        #else
            VStack(spacing: 8) {
                pickerView
                if selectedPickerType == .symbols {
                    symbolGrid
                } else {
                    emojiGrid
                }
            }
            .searchable(text: $searchText, placement: .automatic)
        #endif
    }

    private var symbolGrid: some View {
        ScrollView {
            // Intelligent suggestions from AI (if enabled and search is active OR context is provided)
            if enableIntelligentSuggestions && !intelligentSymbolSuggestions.isEmpty {
                Text(searchText.isEmpty ? "Suggested for You" : "AI Suggestions")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .foregroundColor(.secondary)
                    .padding(.leading)
                    .font(.headline)

                LazyVGrid(columns: [GridItem(.adaptive(minimum: Self.gridDimension, maximum: Self.gridDimension))]) {
                    ForEach(intelligentSymbolSuggestions, id: \.self) { thisSymbol in
                        symbolButton(for: thisSymbol)
                    }
                }
                .padding(.horizontal)
            }

            if searchText.isEmpty {
                // Combine suggested and common, preserving order and removing duplicates
                let featured: [String] = {
                    var seen = Set<String>()
                    let merged = (suggestedSymbols ?? []) + Self.commonSymbols
                    return merged.filter { seen.insert($0).inserted }
                }()

                if !featured.isEmpty {
                    Text("Suggested")
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .foregroundColor(.secondary)
                        .padding(.leading)

                    LazyVGrid(columns: [GridItem(.adaptive(minimum: Self.gridDimension, maximum: Self.gridDimension))]) {
                        ForEach(featured, id: \.self) { thisSymbol in
                            symbolButton(for: thisSymbol)
                        }
                    }
                    .padding(.horizontal)
                }
            }

            Text("All Symbols")
                .frame(maxWidth: .infinity, alignment: .leading)
                .foregroundColor(.secondary)
                .padding(.leading)
            LazyVGrid(columns: [GridItem(.adaptive(minimum: Self.gridDimension, maximum: Self.gridDimension))]) {
                ForEach(Self.symbols.filter { searchText.isEmpty ? true : $0.localizedCaseInsensitiveContains(searchText) }, id: \.self) { thisSymbol in
                    symbolButton(for: thisSymbol)
                }
            }
            .padding(.horizontal)
        }
        .onAppear {
            // Load context-based suggestions when view appears
            if enableIntelligentSuggestions, let context = contextString, !context.isEmpty {
                Task {
                    intelligentSymbolSuggestions = await IntelligentSuggestions.shared.suggestSymbols(for: context)
                }
            }
        }
        .onChange(of: searchText) { newValue in
            if enableIntelligentSuggestions && !newValue.isEmpty {
                Task {
                    intelligentSymbolSuggestions = await IntelligentSuggestions.shared.suggestSymbols(for: newValue)
                }
            } else if enableIntelligentSuggestions, let context = contextString, !context.isEmpty {
                // Restore context-based suggestions when search is cleared
                Task {
                    intelligentSymbolSuggestions = await IntelligentSuggestions.shared.suggestSymbols(for: context)
                }
            } else {
                intelligentSymbolSuggestions = []
            }
        }
    }

    private func symbolButton(for thisSymbol: String) -> some View {
        Button {
            symbol = thisSymbol
            presentationMode.wrappedValue.dismiss()
        } label: {
            if thisSymbol == symbol {
                Image.systemHierarchical(thisSymbol)
                    .font(.system(size: Self.symbolSize))
                #if os(tvOS)
                    .frame(minWidth: Self.gridDimension, minHeight: Self.gridDimension)
                #else
                    .frame(maxWidth: .infinity, minHeight: Self.gridDimension)
                #endif
                    .background(Self.selectedItemBackgroundColor)
                    .cornerRadius(Self.symbolCornerRadius)
                    .foregroundColor(.white)
            } else {
                Image.systemHierarchical(thisSymbol)
                    .font(.system(size: Self.symbolSize))
                    .frame(maxWidth: .infinity, minHeight: Self.gridDimension)
                    .background(Self.unselectedItemBackgroundColor)
                    .cornerRadius(Self.symbolCornerRadius)
                    .foregroundColor(.primary)
            }
        }
        .buttonStyle(.plain)
        #if os(iOS)
            .hoverEffect(.lift)
        #endif
    }

    private var emojiGrid: some View {
        ScrollView {
            // Intelligent suggestions from AI (if enabled and search is active OR context is provided)
            if enableIntelligentSuggestions && !intelligentEmojiSuggestions.isEmpty {
                Text(searchText.isEmpty ? "Suggested for You" : "AI Suggestions")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .foregroundColor(.secondary)
                    .padding(.leading)
                    .font(.headline)

                LazyVGrid(columns: [GridItem(.adaptive(minimum: Self.gridDimension, maximum: Self.gridDimension))]) {
                    ForEach(intelligentEmojiSuggestions, id: \.self) { emoji in
                        emojiButton(for: emoji)
                    }
                }
                .padding(.horizontal)
            }

            // Display emoji by category
            let categories = Symbols.shared.emojiCategories
            let filteredCategories = searchText.isEmpty ? categories : categories.map { category in
                EmojiCategory(
                    name: category.name,
                    emoji: category.emoji.filter { $0.localizedCaseInsensitiveContains(searchText) || category.name.localizedCaseInsensitiveContains(searchText) }
                )
            }.filter { !$0.emoji.isEmpty }

            ForEach(filteredCategories.indices, id: \.self) { index in
                let category = filteredCategories[index]
                if !category.emoji.isEmpty {
                    Text(category.name)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .foregroundColor(.secondary)
                        .padding(.leading)
                        .font(.headline)

                    LazyVGrid(columns: [GridItem(.adaptive(minimum: Self.gridDimension, maximum: Self.gridDimension))]) {
                        ForEach(category.emoji, id: \.self) { emoji in
                            emojiButton(for: emoji)
                        }
                    }
                    .padding(.horizontal)
                }
            }
        }
        .onAppear {
            // Load context-based suggestions when view appears
            if enableIntelligentSuggestions, let context = contextString, !context.isEmpty {
                Task {
                    intelligentEmojiSuggestions = await IntelligentSuggestions.shared.suggestEmoji(for: context)
                }
            }
        }
        .onChange(of: searchText) { newValue in
            if enableIntelligentSuggestions && !newValue.isEmpty {
                Task {
                    intelligentEmojiSuggestions = await IntelligentSuggestions.shared.suggestEmoji(for: newValue)
                }
            } else if enableIntelligentSuggestions, let context = contextString, !context.isEmpty {
                // Restore context-based suggestions when search is cleared
                Task {
                    intelligentEmojiSuggestions = await IntelligentSuggestions.shared.suggestEmoji(for: context)
                }
            } else {
                intelligentEmojiSuggestions = []
            }
        }
    }

    private func emojiButton(for emoji: String) -> some View {
        Button {
            symbol = emoji
            presentationMode.wrappedValue.dismiss()
        } label: {
            Text(emoji)
                .font(.system(size: Self.symbolSize * 1.2))
                .frame(maxWidth: .infinity, minHeight: Self.gridDimension)
                .background(emoji == symbol ? Self.selectedItemBackgroundColor : Self.unselectedItemBackgroundColor)
                .cornerRadius(Self.symbolCornerRadius)
        }
        .buttonStyle(.plain)
        #if os(iOS)
            .hoverEffect(.lift)
        #endif
    }

    public var body: some View {
        #if !os(macOS)
            NavigationView {
                ZStack {
                    #if os(iOS)
                        Self.backgroundColor.edgesIgnoringSafeArea(.all)
                    #endif
                    searchableSymbolGrid
                }
                #if os(iOS)
                .navigationBarTitleDisplayMode(.inline)
                #endif
                #if !os(tvOS)
                /// tvOS can use back button on remote
                .toolbar {
                    ToolbarItem(placement: .cancellationAction) {
                        Button(LocalizedString("cancel")) {
                            presentationMode.wrappedValue.dismiss()
                        }
                    }
                }
                #endif
            }
            .navigationViewStyle(.stack)
        #else
            searchableSymbolGrid
                .frame(width: 540, height: 320, alignment: .center)
                .background(.regularMaterial)
        #endif
    }
}

private func LocalizedString(_ key: String) -> String {
    NSLocalizedString(key, bundle: .module, comment: "")
}

struct SymbolPicker_Previews: PreviewProvider {
    @State static var symbol: String = "square.and.arrow.up"

    static var previews: some View {
        Group {
            SymbolPicker(symbol: Self.$symbol, suggestedSymbols: ["book", "flame.fill", "cup.and.saucer.fill"])
            SymbolPicker(symbol: Self.$symbol)
                .preferredColorScheme(.dark)
        }
    }
}
