//
//  TraverseSequenceTests.swift
//  
//  
//  Created by keiji0 on 2023/03/30
//  
//

import Foundation
import XCTest
@testable import AppTools


final class TraverseSequenceTests: XCTestCase {
    class Node: Identifiable {
        let id: String
        var targets: [Node]
        init(_ id: String, _ targets: some Sequence<Node> = EmptyCollection()) {
            self.id = id
            self.targets = .init(targets)
        }
    }
    
    func test_ノードをトラバースできる() {
        let root = Node("root", [
            Node("a", [
                Node("a-a")
            ]),
            Node("b")
        ])
        XCTAssertEqual(
            ["root", "a", "a-a", "b"],
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
                [ "root" ],
                [ "root", "a" ],
                [ "root", "a", "a-a" ],
                [ "root", "b" ],
            ],
            Array(TraverseSequenceWithPath(root, { (path, node) in
                node.targets
            }).map{ $0 + [ $1.id ] })
        )
    }
}
    
