//
//  DirectedGraphTests.swift
//  
//  
//  Created by keiji0 on 2023/04/02
//  
//

import XCTest
@testable import AppToolsGraph

final class DirectedGraphTests: XCTestCase {
    
    final class Node: DirectedNode, CustomStringConvertible, Equatable {
        let id: String
        var targets = [Node]()
        
        init(_ id: String) {
            self.id = id
        }
        
        var description: String { id }
        
        static func == (lhs: DirectedGraphTests.Node, rhs: DirectedGraphTests.Node) -> Bool {
            lhs.id == rhs.id
        }
    }
    
    let root = Node("root")
    let nodeA = Node("a")
    let nodeB = Node("b")
    let nodeB1 = Node("b1")
    let nodeB2 = Node("b2")
    let nodeC = Node("c")
    let nodeE = Node("e")
    
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
            nodeA.descendants.map{ $0.id }
        )
    }
    
    func test_子孫のパス一覧を取得することができる_循環したノードは除外される() {
        let root = Node("root")
        // A
        //   B
        // C
        //   A
        // E
        root.targets.append(nodeA)
        nodeA.targets.append(nodeB)
        root.targets.append(nodeC)
        nodeC.targets.append(nodeA)
        root.targets.append(nodeE)
        
        XCTAssertEqual(
            [
                [ root.id, nodeA.id ],
                [ root.id, nodeA.id, nodeB.id ],
                [ root.id, nodeC.id ],
                [ root.id, nodeE.id ],
            ],
            root.uniqueDescendantsPath.map{ $0 }
        )
    }
    
    func test_最後の子孫を取得できる() {
        XCTAssertNil(root.lastDescendant)
        root.targets.append(nodeA)
        XCTAssertEqual(root.lastDescendant, nodeA)
        nodeA.targets.append(nodeB)
        nodeA.targets.append(nodeC)
        XCTAssertEqual(root.lastDescendant, nodeC)
    }
    
    func test_パスからノードを取得() {
        root.targets.append(nodeA)
        nodeA.targets.append(nodeB)
        nodeB.targets.append(nodeC)
        XCTAssertEqual(root.node([root.id, nodeA.id]), nodeA)
        XCTAssertNil(root.node([nodeA.id]))
    }
    
    func test_パスからターゲットを取得() {
        root.targets.append(nodeA)
        nodeA.targets.append(nodeB)
        nodeB.targets.append(nodeC)
        XCTAssertEqual(root.target([nodeA.id]), nodeA)
        XCTAssertEqual(root.target([nodeA.id, nodeB.id]), nodeB)
        XCTAssertNil(root.target([nodeA.id, nodeC.id]))
    }
    
    func test_パスからターゲット一覧を取得() {
        nodeA.targets.append(nodeB)
        nodeB.targets.append(nodeC)
        XCTAssertEqual(nodeA.targets(["a"]).array, [])
        XCTAssertEqual(nodeA.targets(["b"]).array, [nodeB])
        XCTAssertEqual(nodeA.targets(["b", "c"]).array, [nodeB, nodeC])
        XCTAssertEqual(nodeA.targets(["b", "a"]).array, [nodeB])
    }
    
    private func importPatternB() {
        root.targets.append(nodeA)
        root.targets.append(nodeB)
    }
}
