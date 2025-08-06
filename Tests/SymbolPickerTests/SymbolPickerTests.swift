//
//  SymbolPickerTests.swift
//  SymbolPickerTests
//
//  Created by Yubo Qin on 2/23/23.
//

@testable import SymbolPicker
import XCTest

final class SymbolPickerTests: XCTestCase {
    func testSymbols() {
        let allSymbols = Symbols.shared.allSymbols
        for symbol in allSymbols {
            assertImage(systemName: symbol)
        }
    }

    private func assertImage(systemName: String) {
        #if os(iOS) || os(watchOS) || os(tvOS)
            XCTAssertNotNil(UIImage(systemName: systemName))
        #else
            XCTAssertNotNil(NSImage(systemSymbolName: systemName, accessibilityDescription: nil))
        #endif
    }
}
