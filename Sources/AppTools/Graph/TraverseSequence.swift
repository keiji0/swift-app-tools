//
//  TraverseSequence.swift
//  
//  
//  Created by keiji0 on 2023/03/30
//  
//

/// `TraverseSequence` は、与えられたノードから始めて、
/// 巡回ノードを受け取り次の巡回先のノードを取得する関数に従った深さ優先探索で巡回するためのシーケンスです。
public struct TraverseSequence
<Node: Identifiable, Targets: Sequence<Node>>
: Sequence, IteratorProtocol
{
    private var stack: [Node]
    private let nextTargets: (Node) -> Targets
    private var visited = Set<Node.ID>()

    public init(_ base: Node, _ nextTargets: @escaping (Node) -> Targets) {
        self.stack = .init(nextTargets(base).reversed())
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
        self.stack = .init(nextTargets([], base).reversed().map {
            .init(node: $0, path: [ base.id] )
        })
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
