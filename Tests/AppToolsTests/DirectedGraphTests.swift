//
//  DirectedGraphTests.swift
//  
//  
//  Created by keiji0 on 2023/04/02
//  
//

import XCTest
@testable import AppTools

final class DirectedGraphTests: XCTestCase {
    
    final class Node: DirectedGraphNode, CustomStringConvertible {
        let id: String
        var targets = [Node]()
        
        init(_ id: String) {
            self.id = id
        }
        
        var description: String { id }
    }
    
    let nodeA = Node("a")
    let nodeB1 = Node("b1")
    let nodeB2 = Node("b2")
    let nodeC = Node("c")
    
    private func importPatternA() {
        nodeA.targets.append(nodeB1)
        nodeB1.targets.append(nodeC)
        nodeA.targets.append(nodeB2)
    }

    func test_子孫の一覧を取得することができる() {
        importPatternA()
        // 並びが一緒
        XCTAssertEqual(
            [ "b1", "c", "b2" ],
            nodeA.deepTargets.map{ $0.id }
        )
        // パスも取得できる
        XCTAssertEqual(
            [
                [ "a" ],
                [ "a", "b1" ],
                [ "a", "b1", "c" ],
                [ "a", "b2" ],
            ],
            nodeA.descendantPaths.map{ $0 }
        )
    }
    
    func test_パスの存在チェック_空パスは存在しない() {
        importPatternA()
        XCTAssertFalse(nodeA.isExists([]))
    }
    
    func test_パスの存在チェック_パスが存在する() {
        importPatternA()
        for path in nodeA.descendantPaths {
            XCTAssertTrue(nodeA.isExists(path))
        }
    }
    
    func test_存在しない場合でも大丈夫() {
        importPatternA()
        XCTAssertTrue(!nodeA.isExists([nodeA.id, nodeC.id]))
    }
}
