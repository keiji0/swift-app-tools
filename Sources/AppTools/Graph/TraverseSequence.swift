//
//  TraverseSequence.swift
//  
//  
//  Created by keiji0 on 2023/03/30
//  
//

/// `TraverseSequence` は、与えられたノードから始めて、
/// 巡回ノードを受け取り次の巡回先のノードを取得する関数に従った深さ優先探索で巡回するためのシーケンスです。
/// 初めに自分自身がふくまれます。必要に応じて`dropFirst`して自身を除外してください。
/// 循環しないような制御はないのでNextTargets内で状況を保存したもので空コレクションを返すことで循環しないように制御します。
public struct TraverseSequence
<Node: Identifiable, Targets: Sequence<Node>>
: Sequence, IteratorProtocol
{
    private var stack: [Node]
    private let nextTargets: (Node) -> Targets

    public init(_ base: Node, _ nextTargets: @escaping (Node) -> Targets) {
        self.stack = [base]
        self.nextTargets = nextTargets
    }

    public mutating func next() -> Node? {
        guard let next = stack.popLast() else {
            return nil
        }
        stack.append(contentsOf: nextTargets(next).reversed())
        return next
    }
}

/// `TraverseSequenceWithPath` は、与えられたノードから始めて、
/// 巡回ノードを受け取り次の巡回先のノードを取得する関数に従った深さ優先探索で巡回するためのシーケンスです。
/// 循環しないような制御はないのでNextTargets内で状況を保存したもので空コレクションを返すことで循環しないように制御します。
public struct TraverseSequenceWithPath
<Node: Identifiable, Targets: Sequence<Node>>
: Sequence, IteratorProtocol
{
    public typealias Path = [Node.ID]
    private var stack: [Target]
    private let nextTargets: (Path, Node) -> Targets

    private struct Target {
        let node: Node
        let path: Path
    }

    public init(_ base: Node, _ nextTargets: @escaping (Path, Node) -> Targets) {
        self.nextTargets = nextTargets
        self.stack = [ .init(node: base, path: []) ]
    }

    public mutating func next() -> (Path, Node)? {
        guard let next = stack.popLast() else {
            return nil
        }
        
        stack.append(contentsOf: nextTargets(next.path, next.node).reversed().map {
            .init(
                node: $0,
                path: next.path + next.node.id
            )
        })
        return (next.path, next.node)
    }
}
