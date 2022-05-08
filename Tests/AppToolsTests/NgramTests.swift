//
//  NgramTests.swift
//  
//  
//  Created by keiji0 on 2021/09/26
//  
//

import XCTest
@testable import AppTools

final class NgramTests: XCTestCase {
    func test_空文字() {
        let ngram = Ngram(2)
        let tokens = ngram.tokens(text: "")
        XCTAssertEqual(tokens, [])
    }
    
    func test_分割しない短さの文字列1() {
        let ngram = Ngram(2)
        let tokens = ngram.tokens(text: "あ")
        XCTAssertEqual(tokens, [["あ"]])
    }
    
    func test_分割しない短さの文字列2() {
        let ngram = Ngram(2)
        let tokens = ngram.tokens(text: "あい")
        XCTAssertEqual(tokens, [["あい"]])
    }
    
    func test_空白なしの単純な分割() {
        let ngram = Ngram(2)
        let tokens = ngram.tokens(text: "あいう")
        XCTAssertEqual(tokens, [["あい", "いう"]])
    }
    
    func test_前後空白ありの単純な分割() {
        let ngram = Ngram(2)
        let tokens = ngram.tokens(text: "  あいう ")
        XCTAssertEqual(tokens, [["あい", "いう"]])
    }
    
    func test_途中空白あり分割() {
        let ngram = Ngram(2)
        let tokens = ngram.tokens(text: "あい う")
        XCTAssertEqual(tokens, [["あい"], ["う"]])
    }
    
    func test_全角空白分割() {
        let ngram = Ngram(2)
        let tokens = ngram.tokens(text: "あい　う")
        XCTAssertEqual(tokens, [["あい"], ["う"]])
    }
}
