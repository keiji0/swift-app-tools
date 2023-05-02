//
//  TraverseSequence.swift
//  
//  
//  Created by keiji0 on 2023/03/30
//  
//

/// `TraverseSequence` は、与えられたノードから始めて、
/// 指定された `KeyPath` でアクセスされるターゲットノードを深さ優先探索で巡回するための構造体です。
/// 初めに自分自身がふくまれます。
public struct TraverseSequence
<Node: Identifiable, Targets: Sequence<Node>>
: Sequence, IteratorProtocol
{
    private var visited = Set<Node.ID>()
    private var stack: [Node]
    private let nextTargets: (Node) -> Targets

    public init(_ base: Node, _ nextTargets: @escaping (Node) -> Targets) {
        self.stack = [base]
        self.nextTargets = nextTargets
    }

    public mutating func next() -> Node? {
        while let next = stack.popLast() {
            if visited.insert(next.id).inserted {
                stack.append(contentsOf: nextTargets(next).reversed())
                return next
            }
        }
        return nil
    }
}

/// `TraverseSequenceWithPath` は、与えられたノードから始めて、
/// 指定された `KeyPath` でアクセスされるターゲットノードを深さ優先探索で巡回するための構造体です。
/// 初めに自分自身がふくまれます。また巡回にパスが入ります。
public struct TraverseSequenceWithPath
<Node: Identifiable, Targets: Sequence<Node>>
: Sequence, IteratorProtocol
{
    private var visited = Set<Node.ID>()
    private var stack: [Target]
    private let nextTargets: (Node) -> Targets

    private struct Target {
        let node: Node
        let path: [Node.ID]
    }

    public init(_ base: Node, _ nextTargets: @escaping (Node) -> Targets) {
        self.nextTargets = nextTargets
        self.stack = [ .init(node: base, path: []) ]
    }

    public mutating func next() -> ([Node.ID], Node)? {
        while let next = stack.popLast() {
            if visited.insert(next.node.id).inserted {
                stack.append(contentsOf: nextTargets(next.node).reversed().map {
                    .init(
                        node: $0,
                        path: next.path + next.node.id
                    )
                })
                return (next.path, next.node)
            }
        }
        return nil
    }
}
