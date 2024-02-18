//
//  TextLayoutFragmentTests.swift
//  
//  
//  Created by keiji0 on 2022/12/30
//  
//

import Foundation
import XCTest
import Combine
import AppToolsCrossPlatform
@testable import AppToolsTextView

class TextLayoutFragmentTests: XCTestCase {
    private let layoutManager = TextLayoutManager()
    private let contentStorage = TextContentStorage()
    private let container = TextContainer()
    private var textStorage : NSTextStorage { contentStorage.textStorage! }
    private var navigation: NSTextSelectionNavigation { layoutManager.textSelectionNavigation }
    private var documentRange: NSTextRange { layoutManager.documentRange }
    
    override func setUp() {
        super.setUp()
        container.size.width = 200
        layoutManager.textContainer = container
        contentStorage.addTextLayoutManager(layoutManager)
    }
    
    func test_paddingLine() {
        textStorage.mutableString.append("")
        XCTAssertEqual(layoutManager.lineCount, 0)
        contentStorage.paddingLine()
        XCTAssertEqual(layoutManager.lineCount, 1)
        textStorage.mutableString.append("0")
        XCTAssertEqual(layoutManager.lineCount, 2)
        
        textStorage.mutableString.deleteCharacters(in: .init(location: 0, length: textStorage.mutableString.length))
        XCTAssertEqual(layoutManager.lineCount, 0)
        contentStorage.paddingLine()
        XCTAssertEqual(layoutManager.lineCount, 1)
        contentStorage.paddingLine()
        XCTAssertEqual(layoutManager.lineCount, 2)
    }
    
    func test_textLineRanges_1行の場合TextFragmentとLineFragmentは一致する() {
        contentStorage.paddingLine()
        let textLayoutFragment = layoutManager.firstTextLayoutFragment!
        let textLineRange = textLayoutFragment.textLineRanges.first!
        XCTAssertTrue(textLayoutFragment.rangeInElement.isEqual(to: textLineRange))
    }
    
    func test_textLineRanges_2行の場合TextFragmentとLineFragmentのUnionは一致する() {
        contentStorage.paddingLine()
        contentStorage.paddingLine()
        let textLayoutFragment = layoutManager.firstTextLayoutFragment!
        let textLineRanges = textLayoutFragment.textLineRanges
        let unionRange = textLineRanges[0].union(textLineRanges[1])
        XCTAssertTrue(textLayoutFragment.rangeInElement.isEqual(to: unionRange))
    }
}
