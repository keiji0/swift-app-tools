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
    /// 指定パスからノードを取得
    public func target(_ path: some Sequence<ID>) -> Self? {
        var itr = path.makeIterator()
        guard let root = itr.next(),
              id == root else {
            return nil
        }
        
        var current = self
        while let child = itr.next() {
            guard let res = current.targets.first(child) else {
                return nil
            }
            current = res
        }
        
        return current
    }
    
    /// パスを辿ったノード一覧を取得
    public func targets(_ path: some Sequence<ID>) -> some Sequence<Self> {
        PathNodeSequence(self, path)
    }
    
    /// ターゲットが存在するか
    public func hasTarget(_ targetId: ID) -> Bool {
        targets.contains(where: { $0.id == targetId })
    }
    
    /// 子孫一覧を再帰的に取得するシーケンス
    /// 深さ優先で探索されます
    public var deepTargets: some Sequence<Self> {
        TraverseSequence(self, \Self.targets)
    }
    
    /// 子孫パス一覧を取得
    public var descendantPaths: some Sequence<[ID]> {
        TraverseSequenceWithPath(self).lazy.map{ path, node in
            path + node.id
        }
    }
    
    /// 子孫パス一覧を取得
    /// 一度出現した同一ノードは探索から除外されます。
    public var uniqueDescendantPaths: some Sequence<[ID]> {
        var visited = Set<ID>()
        return TraverseSequenceWithPath(self) { node, _ in
            return node.targets.filter { target in
                visited.insert(target.id).inserted
            }
        }.lazy.map{ path, node in
            path + node.id
        }
    }
    
    /// 指定パスが存在するのかチェック
    public func isExists(_ path: some Sequence<ID>) -> Bool {
        target(path) != nil
    }
}

extension Sequence where Element: DirectedNode {
    func first(_ id: Element.ID) -> Element? {
        first(where: { $0.id == id })
    }
}

extension DirectedNode where Targets: BidirectionalCollection {
    /// 末尾のターゲットを再起的に辿った最後にあるターゲット
    /// ターゲットがなければ自身のノードが返る
    public var deepLastTarget: Self? {
        guard let lastTarget = targets.last else {
            return self
        }
        return lastTarget.deepLastTarget
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
