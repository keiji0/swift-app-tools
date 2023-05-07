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
/// 循環したノードの場合IsStopでコンストラクタに渡すことで制御できる
///  `Sequence.Element`にはパスとノードが入ります。
///  パスはノードへのパスでノード自体は含まれません。
public struct TraverseSequenceWithPath
<Node: Identifiable, Targets: Sequence<Node>>
: Sequence, IteratorProtocol
{
    public typealias Path = [Node.ID]
    public typealias IsStop = (Path, Node) -> Bool
    public typealias NextTargets = (Node) -> Targets
    
    private var stack: [Target]
    private let nextTargets: NextTargets
    private let isStop: IsStop

    private struct Target {
        let node: Node
        let path: Path
    }

    public init(_ base: Node, _ nextTargets: @escaping NextTargets, isStop: @escaping IsStop) {
        self.nextTargets = nextTargets
        self.stack = .init()
        self.isStop = isStop
        append(.init(node: base, path: [ ]))
    }
    
    public init(_ base: Node, _ nextTargets: @escaping NextTargets) {
        self.init(base, nextTargets) { _, _ in false }
    }

    public mutating func next() -> (Path, Node)? {
        guard let next = stack.popLast() else {
            return nil
        }
        if isStop(next.path, next.node) {
            return nil
        }
        
        append(next)
        return (next.path, next.node)
    }
    
    private mutating func append(_ target: Target) {
        stack.append(contentsOf: nextTargets(target.node).reversed().map {
            .init(
                node: $0,
                path: target.path + [ target.node.id ]
            )
        })
    }
}
