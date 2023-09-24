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
    func test_要素が一つのときの時はペアがないので空() {
        XCTAssertEqual([1].pairwise.map{$1}.count, 0)
    }
    
    func test_要素同士のシーケンスを取得できる() {
        XCTAssertEqual([[1, 2], [2, 3]], [1, 2, 3].pairwise.map{
            [ $0.0, $0.1 ]
        })
    }
    
    func test_要素同士の比較ができる() {
        XCTAssertTrue([1, 2, 3].isEqual([1, 2, 3, 99].dropLast()))
        XCTAssertFalse([1, 2, 3].isEqual([1, 2, 3, 99]))
    }
    
    func test_シーケンス同士を繋ぐことができる() {
        let s1 = [ 1, 2, 3 ]
        let s2 = [ 3, 4 ].dropFirst()
        let s3 = s1.spliced(s2)
        XCTAssertEqual(Array(s3), [ 1, 2, 3, 4 ])
    }
}
