//
//  WeakObjectTests.swift
//  
//  
//  Created by keiji0 on 2023/01/07
//  
//

import Foundation
import XCTest
@testable import AppTools

final class WeakObjectTests: XCTestCase {
    class Foo { }
    func test_強参照していない() {
        var val: Foo! = .init()
        let weakObject = WeakObject(val)
        XCTAssertNotNil(weakObject.value)
        val = nil
        XCTAssertNil(weakObject.value)
    }
    
    func test_コレクションでも解放される() {
        var collection: [WeakObject<Foo>] = .init()
        var val1: Foo! = .init()
        var val2: Foo! = .init()
        collection.append(.init(val1))
        collection.append(.init(val2))
        XCTAssertEqual(collection.filter{ $0.hasValue }.count, 2)
        val1 = nil
        XCTAssertEqual(collection.filter{ $0.hasValue }.count, 1)
        val2 = nil
        XCTAssertEqual(collection.filter{ $0.hasValue }.count, 0)
    }
}

