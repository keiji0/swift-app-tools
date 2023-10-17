//
//  TraverseSequenceTests.swift
//  
//  
//  Created by keiji0 on 2023/03/30
//  
//

import Foundation
import XCTest
@testable import AppToolsGraph


final class TraverseSequenceTests: XCTestCase {
    class Node: Identifiable {
        let id: String
        var targets: [Node]
        init(_ id: String, _ targets: some Sequence<Node> = EmptyCollection()) {
            self.id = id
            self.targets = .init(targets)
        }
    }
    
    func test_開始地点は含まない() {
        let root = Node("root", [
            Node("a")
        ])
        XCTAssertEqual(
            ["a"],
            Array(TraverseSequence(root, \Node.targets).map{ $0.id })
        )
    }
    
    func test_開始地点は含まないWithPath() {
        let root = Node("root", [
            Node("a")
        ])
        XCTAssertEqual(
            ["a"],
            Array(TraverseSequenceWithPath(root, { node, _ in node.targets }).map{ $0.1.id })
        )
    }
    
    func test_ノードをトラバースできる() {
        let root = Node("root", [
            Node("a", [
                Node("a-a")
            ]),
            Node("b")
        ])
        XCTAssertEqual(
            ["a", "a-a", "b"],
            Array(TraverseSequence(root, \Node.targets).map{ $0.id })
        )
    }
    
    func test_パス付きのトラバースができる() {
        let root = Node("root", [
            Node("a", [
                Node("a-a")
            ]),
            Node("b")
        ])
        
        XCTAssertEqual(
            [
                [ "root", "a" ],
                [ "root", "a", "a-a" ],
                [ "root", "b" ],
            ],
            Array(TraverseSequenceWithPath(root, \Node.targets).map{ $0.0 + [ $0.1.id ] })
        )
    }
}
