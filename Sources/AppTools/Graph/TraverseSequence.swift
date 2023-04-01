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
<Node: Identifiable, Targets: Sequence<Node>, TargetKeyPath: KeyPath<Node, Targets>>
: Sequence, IteratorProtocol
{
    private var visited = Set<Node.ID>()
    private var stack: [Node]
    private let keyPath: TargetKeyPath

    public init(_ base: Node, _ keyPath: TargetKeyPath) {
        self.keyPath = keyPath
        self.stack = [base]
    }

    public mutating func next() -> Node? {
        while let next = stack.popLast() {
            if visited.insert(next.id).inserted {
                stack.append(contentsOf: next[keyPath: keyPath].reversed())
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
<Node: Identifiable, Targets: Sequence<Node>, TargetKeyPath: KeyPath<Node, Targets>>
: Sequence, IteratorProtocol
{
    private var visited = Set<Node.ID>()
    private var stack: [Target]
    private let keyPath: TargetKeyPath

    private struct Target {
        let node: Node
        let path: [Node.ID]
    }

    public init(_ base: Node, _ keyPath: TargetKeyPath) {
        self.keyPath = keyPath
        self.stack = [ .init(node: base, path: []) ]
    }

    public mutating func next() -> ([Node.ID], Node)? {
        while let next = stack.popLast() {
            if visited.insert(next.node.id).inserted {
                stack.append(contentsOf: next.node[keyPath: keyPath].reversed().map {
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
