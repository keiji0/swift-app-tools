//
//  SequenceTests.swift
//  
//  
//  Created by keiji0 on 2023/03/26
//  
//

import Foundation
import XCTest
@testable import AppTools

final class SequenceTests: XCTestCase {
    func test_要素同士のシーケンスを取得できる() {
        XCTAssertEqual([[1, 2], [2, 3]], [1, 2, 3].pairwise.map{
            [ $0.0, $0.1 ]
        })
    }
    
    func test_要素同士の比較ができる() {
        XCTAssertTrue([1, 2, 3].isEqual([1, 2, 3, 99].dropLast()))
        XCTAssertFalse([1, 2, 3].isEqual([1, 2, 3, 99]))
    }
}
