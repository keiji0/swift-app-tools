//
//  HistoryTests.swift
//  
//  
//  Created by keiji0 on 2022/07/25
//  
//

import XCTest
import Combine
@testable import AppTools

fileprivate struct Item: Equatable, Codable {
    let name: String
}

final class HistoryTests: XCTestCase {

    private var history = History<Item>()
    
    func test_デフォルトは何も設定されていない() {
        XCTAssertEqual(history.current, nil)
    }
    
    func test_デフォルトはバックできない() {
        XCTAssertFalse(history.canBack)
    }
    
    func test_デフォルトは進むできない() {
        XCTAssertFalse(history.canForward)
    }
    
    func test_履歴を追加() {
        XCTAssertEqual(
            history.$current.receiveEvents {
                history.append(.init(name: "foo1"))
            },
            [nil, .init(name: "foo1")]
        )
        XCTAssertEqual(
            history.$current.receiveEvents {
                history.append(.init(name: "foo2"))
            },
            [.init(name: "foo1"), .init(name: "foo2")]
        )
    }
    
    func test_バックできる() {
        history.append(.init(name: "foo1"))
        XCTAssertTrue(history.canBack)
        history.append(.init(name: "foo2"))
        XCTAssertEqual(
            history.$current.receiveLastEvent { history.back() },
            .init(name: "foo1")
        )
    }
    
    func test_次に進むことができる() {
        history.append(.init(name: "1"))
        history.append(.init(name: "2"))
        history.back()
        XCTAssertTrue(history.canForward)
        XCTAssertEqual(
            history.$current.receiveLastEvent { history.forward() },
            .init(name: "2")
        )
    }
    
    func test_Encodeできる() {
        XCTAssertEqual(encodedHistory(), history)
        
        history.append(.init(name: "foo"))
        XCTAssertEqual(encodedHistory(), history)
        
        history.append(.init(name: "foo2"))
        history.back()
        XCTAssertEqual(encodedHistory(), history)
        
        history.forward()
        XCTAssertEqual(encodedHistory(), history)
    }
    
    // MARK: - Private
    
    private func testCodable() {
        let data = try! JSONEncoder().encode(history)
        let history2 = try! JSONDecoder().decode(History<Item>.self, from: data)
        XCTAssertEqual(history, history2)
    }
    
    private func encodedHistory() -> History<Item> {
        let data = try! JSONEncoder().encode(history)
        return try! JSONDecoder().decode(History<Item>.self, from: data)
    }
}
