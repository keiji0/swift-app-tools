//
//  TreeNodeTests.swift
//
//  
//  Created by keiji0 on 2023/11/04
//  
//

import Foundation
import Testing
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

struct TreeNdoeTests {
    
    @Test func Parentを持つ() {
        let a = Node("a", .init("b"))
        #expect(a.parent?.id == "b")
    }
    
    @Test func Parentは空の場合もある() {
        let a = Node("a")
        #expect(a.parent == nil)
    }
    
    @Test func 双方向ノードとしても機能する() {
        let a = Node("a", .init("b"))
        #expect(a.sources.map{$0.id} == ["b"])
    }
    
    private let root = Node("root")
    private let nodeA = Node("a")
    private let nodeB = Node("b")
    private let nodeC = Node("c")
    private let nodeE = Node("e")
    
    @Test func 前の兄弟ノードを取得() {
        root.append(nodeA)
        root.append(nodeB)
        
        #expect(nodeA.previousSibling == nil)
        #expect(nodeB.previousSibling?.id == nodeA.id)
    }
    
    @Test func 次の兄弟ノードを取得() {
        root.append(nodeA)
        root.append(nodeB)
        
        #expect(nodeA.nextSibling?.id == nodeB.id)
        #expect(nodeB.nextSibling == nil)
    }
    
    @Test func 次の行ノードを取得() {
        root.append(nodeA)
        nodeA.append(nodeB)
        root.append(nodeC)
        
        #expect(nodeA.nextRow?.id == nodeB.id)
        #expect(nodeB.nextRow?.id == nodeC.id)
        #expect(Node("dummy").nextRow == nil)
    }
    
    @Test func 前の行ノードを取得_単純に前の兄弟() {
        root.append(nodeA)
        root.append(nodeB)
        #expect(nodeB.previousRow?.id == nodeA.id)
    }
    
    @Test func 前の行ノードを取得_前の兄弟が子供を持っていた() {
        root.append(nodeA)
        nodeA.append(nodeB)
        nodeB.append(nodeE)
        root.append(nodeC)
        #expect(nodeC.previousRow?.id == nodeE.id)
    }
    
    @Test func 前の行ノードを取得_前の兄弟がいないので親を取得() {
        root.append(nodeA)
        #expect(nodeA.previousRow?.id == root.id)
    }
    
    @Test func 兄弟ノードか判定できる() {
        root.append(nodeA)
        root.append(nodeB)
        #expect(nodeA.isSibling(nodeB))
        #expect(nodeB.isSibling(nodeA))
    }
    
    @Test func 親がない同士は兄弟ノードではない() {
        #expect(!nodeA.isSibling(nodeB))
    }
    
    @Test func 親からのインデックスを取得できる() {
        root.append(nodeA)
        root.append(nodeB)
        root.append(nodeC)
        #expect(root.indexFromParent == nil)
        #expect(nodeA.indexFromParent == 0)
        #expect(nodeB.indexFromParent == 1)
        #expect(nodeC.indexFromParent == 2)
    }
}
