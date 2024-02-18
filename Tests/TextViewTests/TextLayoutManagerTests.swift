//
//  TextLayoutManagerTests.swift
//  
//  
//  Created by keiji0 on 2022/12/29
//  
//

import Foundation
import XCTest
import Combine
@testable import AppToolsTextView

class TextLayoutManagerTests: XCTestCase {
    private let layoutManager = TextLayoutManager()
    private let contentStorage = TextContentStorage()
    private let container = TextContainer()
    private var textStorage : NSTextStorage { contentStorage.textStorage! }
    private var navigation: NSTextSelectionNavigation { layoutManager.textSelectionNavigation }
    private var documentRange: NSTextRange { layoutManager.documentRange }
    
    override func setUp() {
        super.setUp()
        container.size.width = 200
        container.lineFragmentPadding = 0
        layoutManager.textContainer = container
        contentStorage.addTextLayoutManager(layoutManager)
    }
    
    func test_lineCount() {
        textStorage.mutableString.append("")
        XCTAssertEqual(layoutManager.lineCount, 0)
        textStorage.mutableString.append("1")
        XCTAssertEqual(layoutManager.lineCount, 1)
        textStorage.mutableString.append("\n")
        XCTAssertEqual(layoutManager.lineCount, 2)
        textStorage.mutableString.setString("\n")
        XCTAssertEqual(layoutManager.lineCount, 2)
    }
    
    func test_TextRange_containsWithEnd() {
        textStorage.mutableString.append("1")
        XCTAssertTrue(documentRange.containsWithEnd(documentRange.endLocation))
    }
    
    func test_isFirstLine_中身がある() {
        textStorage.mutableString.append("12345")
        XCTAssertTrue(layoutManager.isFirstLine(contentStorage.documentRange.location))
    }
    
    func test_isFirstLine_一行の末尾でも問題ない() {
        textStorage.mutableString.append("0")
        XCTAssertTrue(layoutManager.isFirstLine(contentStorage.documentRange.endLocation))
    }
    
    func test_isFirstLine_空行でも問題ない() {
        textStorage.mutableString.append("")
        XCTAssertTrue(layoutManager.isFirstLine(contentStorage.documentRange.location))
    }
    
    func test_isFirstLine_選択範囲外だった場合失敗する() {
        let lm = TextLayoutManager()
        let cs = TextContentStorage()
        let tc = TextContainer()
        tc.size.width = 200
        lm.textContainer = tc
        cs.addTextLayoutManager(lm)
        cs.textStorage?.mutableString.append("hoge")
        
        textStorage.mutableString.append("h")
        
        // 無理やり範囲外の場所を作る
        let outsizeLocation = cs.location(
            cs.documentRange.location,
            offsetBy: 2
        )!
        XCTAssertFalse(layoutManager.isFirstLine(outsizeLocation))
    }
    
    func test_isLastLine_中身がある() {
        textStorage.mutableString.append("12345")
        XCTAssertTrue(layoutManager.isLastLine(contentStorage.documentRange.endLocation))
    }
    
    func test_isLastLine_2行でも問題ない() {
        contentStorage.paddingLine()
        contentStorage.paddingLine()
        XCTAssertTrue(layoutManager.isLastLine(contentStorage.documentRange.endLocation))
    }
    
    func test_isLastLine_2フラグメントでも問題ない() {
        textStorage.mutableString.append("1\n2")
        XCTAssertTrue(layoutManager.isLastLine(contentStorage.documentRange.endLocation))
    }
    func test_isLastLine_二行で1行目の末尾だった場合でも最後の行とみなす() {
        contentStorage.paddingLine()
        let lineEndLocation = contentStorage.documentRange.endLocation
        textStorage.mutableString.append("1")
        XCTAssertTrue(layoutManager.isLastLine(lineEndLocation))
    }
    
    func test_textLineFragment_先頭行の取得() {
        contentStorage.paddingLine()
        contentStorage.paddingLine("1")
        layoutManager.ensureLayout(for: layoutManager.documentRange)
        XCTAssertEqual(
            layoutManager.textLineFragment(for: layoutManager.documentRange.location),
            layoutManager.textLineFragments[0]
        )
        XCTAssertEqual(
            layoutManager.textLineFragment(for: layoutManager.documentRange.endLocation),
            layoutManager.textLineFragments[1]
        )
    }
    
    struct Editor {
        let layoutManager = TextLayoutManager()
        let contentStorage = TextContentStorage()
        let container = TextContainer()
        init() {
            container.size.width = 200
            layoutManager.textContainer = container
            contentStorage.addTextLayoutManager(layoutManager)
        }
    }
}
