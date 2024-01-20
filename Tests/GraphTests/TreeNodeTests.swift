//
//  TreeNodeTests.swift
//
//  
//  Created by keiji0 on 2023/11/04
//  
//

import Foundation
import XCTest
@testable import AppToolsGraph


private final class Node: TreeNode {
    let id: String
    private(set) var targets: [Node] = []
    var parent: Node?
    
    init(_ id: String, _ parent: Node? = nil) {
        self.id = id
        parent?.append(self)
    }
    
    func append(_ node: Node) {
        targets.append(node)
        node.parent = self
    }
}

final class TreeNdoeTests: XCTestCase {
    
    func test_Parentを持つ() {
        let a = Node("a", .init("b"))
        XCTAssertEqual(a.parent?.id, "b")
    }
    
    func test_Parentは空の場合もある() {
        let a = Node("a")
        XCTAssertNil(a.parent)
    }
    
    func test_双方向ノードとしても機能する() {
        let a = Node("a", .init("b"))
        XCTAssertEqual(a.sources.map{$0.id}, ["b"])
    }
    
    private let root = Node("root")
    private let nodeA = Node("a")
    private let nodeB = Node("b")
    private let nodeC = Node("c")
    private let nodeE = Node("e")
    
    func test_前の兄弟ノードを取得() {
        root.append(nodeA)
        root.append(nodeB)
        
        XCTAssertNil(nodeA.previousSibling)
        XCTAssertEqual(nodeB.previousSibling?.id, nodeA.id)
    }
    
    func test_次の兄弟ノードを取得() {
        root.append(nodeA)
        root.append(nodeB)
        
        XCTAssertEqual(nodeA.nextSibling?.id, nodeB.id)
        XCTAssertNil(nodeB.nextSibling)
    }
    
    func test_次の行ノードを取得() {
        root.append(nodeA)
        nodeA.append(nodeB)
        root.append(nodeC)
        
        XCTAssertEqual(nodeA.nextRow?.id, nodeB.id)
        XCTAssertEqual(nodeB.nextRow?.id, nodeC.id)
        XCTAssertNil(Node("dummy").nextRow)
    }
    
    func test_前の行ノードを取得_単純に前の兄弟() {
        root.append(nodeA)
        root.append(nodeB)
        XCTAssertEqual(nodeB.previousRow?.id, nodeA.id)
    }
    
    func test_前の行ノードを取得_前の兄弟が子供を持っていた() {
        root.append(nodeA)
        nodeA.append(nodeB)
        nodeB.append(nodeE)
        root.append(nodeC)
        XCTAssertEqual(nodeC.previousRow?.id, nodeE.id)
    }
    
    func test_前の行ノードを取得_前の兄弟がいないので親を取得() {
        root.append(nodeA)
        XCTAssertEqual(nodeA.previousRow?.id, root.id)
    }
    
    func test_兄弟ノードか判定できる() {
        root.append(nodeA)
        root.append(nodeB)
        XCTAssertTrue(nodeA.isSibling(nodeB))
        XCTAssertTrue(nodeB.isSibling(nodeA))
    }
    
    func test_親がない同士は兄弟ノードではない() {
        XCTAssertFalse(nodeA.isSibling(nodeB))
    }
    
    func test_親からのインデックスを取得できる() {
        root.append(nodeA)
        root.append(nodeB)
        root.append(nodeC)
        XCTAssertEqual(root.indexFromParent, nil)
        XCTAssertEqual(nodeA.indexFromParent, 0)
        XCTAssertEqual(nodeB.indexFromParent, 1)
        XCTAssertEqual(nodeC.indexFromParent, 2)
    }
}
