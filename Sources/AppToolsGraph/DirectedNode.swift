//
//  DirectedNode.swift
//  
//  
//  Created by keiji0 on 2023/04/02
//  
//

import Foundation
import AppToolsData

/// グラフのノードを表すプロトコル
/// 隣接リストで表されたグラフの頂点
public protocol DirectedNode : Node {
    associatedtype Targets: Collection<Self>
    /// 関連するノードへのリスト
    /// edgesとかではなくtargetsにしているのは有向グラフであるから
    var targets: Targets { get }
}

extension DirectedNode {
    /// 自身を含めたパスからtargetsを辿りながらノードを取得
    public func node(_ path: some Sequence<ID>) -> Self? {
        guard let (first, rest) = path.firstWithRest,
              first == id else {
            return nil
        }
        return target(rest)
    }
    
    /// 指定パスからノードを取得
    public func target(_ path: some Sequence<ID>) -> Self? {
        var current = self
        for targetId in path {
            guard let res = current.targets.first(targetId) else {
                return nil
            }
            current = res
        }
        return current
    }
    
    /// 指定ターゲットが存在するか確認
    public func hasTarget(_ path: some Sequence<ID>) -> Bool {
        target(path) != nil
    }
    
    /// ターゲットが存在するか
    public func hasTarget(_ targetId: ID) -> Bool {
        targets.contains(where: { $0.id == targetId })
    }
    
    /// パスを辿ったノード一覧を取得
    public func targets(_ path: some Sequence<ID>) -> some Sequence<Self> {
        PathNodeSequence(self, path)
    }
    
    /// 子孫シーケンスを取得
    public var descendants: some Sequence<Self> {
        TraverseSequence(self, \Self.targets)
    }
    
    /// 子孫パス一覧を取得
    public var descendantsPath: some Sequence<[ID]> {
        TraverseSequenceWithPath(self).lazy.map{ path, node in
            path + node.id
        }
    }
    
    /// 子孫パス一覧を取得
    /// 一度出現した同一ノードは探索から除外されます。
    public var uniqueDescendantsPath: some Sequence<[ID]> {
        var visited = Set<ID>()
        return TraverseSequenceWithPath(self) { node, _ in
            return node.targets.filter { target in
                visited.insert(target.id).inserted
            }
        }.lazy.map{ path, node in
            path + node.id
        }
    }
}

extension Sequence where Element: DirectedNode {
    func first(_ id: Element.ID) -> Element? {
        first(where: { $0.id == id })
    }
}

extension DirectedNode where Targets: BidirectionalCollection {
    /// 深さ優先で末尾の子孫ターゲットを取得
    public var lastDescendant: Self? {
        targets.last?.innerLastDescendant
    }
    
    private var innerLastDescendant: Self? {
        if let lastTarget = targets.last {
            lastTarget.innerLastDescendant
        } else {
            self
        }
    }
}

private struct PathNodeSequence<Node: DirectedNode, Path: Sequence<Node.ID>> : Sequence, IteratorProtocol {
    var node: Node
    var itr: Path.Iterator
    
    init(_ node: Node, _ path: Path) {
        self.node = node
        self.itr = path.makeIterator()
    }
    
    mutating func next() -> Node? {
        guard let nextTargetId = itr.next(),
              let target = node.targets.first(nextTargetId) else {
            return nil
        }
        self.node = target
        return target
    }
}
