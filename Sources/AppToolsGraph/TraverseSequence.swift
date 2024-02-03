//
//  TraverseSequence.swift
//  
//  
//  Created by keiji0 on 2023/03/30
//  
//

/// `TraverseSequence` は、与えられたノードから始めて、
/// 巡回ノードを受け取り次の巡回先のノードを取得する関数に従った深さ優先探索で巡回するためのシーケンスです。
struct TraverseSequence
<Node: Identifiable, Targets: Sequence<Node>>
: Sequence, IteratorProtocol
{
    private var stack: [Node]
    private let nextTargets: (Node) -> Targets
    private var visited = Set<Node.ID>()

    init(_ base: Node, _ nextTargets: @escaping (Node) -> Targets) {
        self.stack = .init(nextTargets(base).reversed())
        self.nextTargets = nextTargets
    }
    
    mutating func next() -> Node? {
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
///  `Sequence.Element`にはパスとノードが入ります。
///  パスはノードへのパスでノード自体は含まれません。
struct TraverseSequenceWithPath
<Node: Identifiable, Targets: Sequence<Node>>
: Sequence, IteratorProtocol
{
    typealias Path = [Node.ID]
    typealias NextTargets = KeyPath<Node, Targets>
    typealias NextTargetsWithPath = (Node, Path) -> Targets
    
    private var stack: [Target]
    private let nextTargets: NextTargetsWithPath

    private struct Target {
        let node: Node
        let path: Path
    }

    init(_ base: Node, _ nextTargets: @escaping NextTargetsWithPath) {
        self.nextTargets = nextTargets
        self.stack = .init()
        append([], .init(node: base, path: [ ]))
    }
    
    init(_ base: Node, _ nextTargets: NextTargets) {
        self.init(base) { node, _ in
            node[keyPath: nextTargets]
        }
    }
    
    init(_ base: Node) where Node: DirectedNode, Targets == Node.Targets {
        self.init(base) { node, _ in
            node.targets
        }
    }
    
    init(origin node: Node) where Targets == [Node] {
        self.nextTargets = { _, _ in [] }
        self.stack = [.init(
            node: node,
            path: [node.id]
        )]
    }
    
    mutating func next() -> (Path, Node)? {
        guard let next = stack.popLast() else {
            return nil
        }
        
        append(next.path, next)
        return (next.path, next.node)
    }
    
    private mutating func append(_  path: Path, _ target: Target) {
        stack.append(contentsOf: nextTargets(target.node, path).reversed().map {
            .init(
                node: $0,
                path: target.path + [ target.node.id ]
            )
        })
    }
}
