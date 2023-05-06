//
//  BidirectionalGraphTests.swift
//  
//  
//  Created by keiji0 on 2023/04/02
//  
//

import XCTest
@testable import AppTools

extension String: GraphNodeId {}

final class BidirectionalGraphTests: XCTestCase {
    
    final class Node: BidirectionalGraphNode, CustomStringConvertible, Hashable {
        let id: String
        private(set) var targets = [Node]()
        private(set) var sources = [Node]()
        
        init(_ id: String) {
            self.id = id
        }
        
        var description: String { id }
        
        func append(_ node: Node) {
            targets.append(node)
            node.sources.append(self)
        }
        
        static func == (lhs: Node, rhs: Node) -> Bool {
            lhs.id == rhs.id
        }
        
        public func hash(into hasher: inout Hasher) {
            hasher.combine(id)
        }
    }
    
    let root = Node("root")
    let nodeA = Node("a")
    let nodeB = Node("b")
    let nodeB1 = Node("b1")
    let nodeB2 = Node("b2")
    let nodeC = Node("c")
    
    private func importPatternA() {
        root.append(nodeA)
        nodeA.append(nodeB1)
        nodeB1.append(nodeC)
        nodeA.append(nodeB2)
    }
    
    func test_pathsオリジンから参照されているパスを取得できる() {
        root.append(nodeA)
        nodeA.append(nodeB)
        XCTAssertEqual(
            nodeB.ancestorPaths,
            [
                [root.id, nodeA.id, nodeB.id]
            ])
    }
    
    func test_paths複数箇所から参照されているパスを取得できる() {
        root.append(nodeA)
        root.append(nodeB)
        nodeA.append(nodeC)
        nodeB.append(nodeC)
        XCTAssertEqual(
            nodeC.ancestorPaths,
            [
                [ root.id, nodeA.id, nodeC.id],
                [ root.id, nodeB.id, nodeC.id],
            ])
    }
    
    func test_paths複数箇所から参照されているパスを取得できる_循環している() {
        root.append(nodeA)
        nodeA.append(nodeB)
        root.append(nodeB)
        XCTAssertEqual(
            nodeB.ancestorPaths,
            [
                [ root.id, nodeA.id, nodeB.id ],
                [ root.id, nodeB.id],
            ])
    }
}
