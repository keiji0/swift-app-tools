//
//  Sequence+NodePath.swift
//
//  
//  Created by keiji0 on 2023/04/08
//  
//

import Foundation

extension Sequence where Element: GraphNodeId {
    /// 指定パスは内包するパスかどうか？
    /// - Parameter path: 対象のパス
    /// - Returns: 内包していればtrue
    /// 同じパスであれば内包しているとみなす
    public func containsPath(_ path: some Sequence<Element>) -> Bool {
        var a = self.makeIterator()
        var b = path.makeIterator()
        while let nodeA = a.next() {
            guard let nodeB = b.next(), nodeA == nodeB else {
                return false
            }
        }
        return true
    }
    
    /// 正しいパスかどうか検証
    /// - Parameter root: パスの起点となるノード
    /// - Returns: 正しいばあいはtrueを返す
    public func isValid<Node: DirectedGraphNode>(_ root: Node) -> Bool where Node.ID == Element {
        root.isExists(self)
    }
}

/// NodePathを比較する
///
/// NodePathにおける比較とは
/// * 要素が多いものが多い。つまり長いパスが大きい
/// * 同一要素数の場合NodeIdで比較する
public func < <Path: Sequence>(lhs: Path, rhs: Path) -> Bool where Path.Element: GraphNodeId, Path.Element: Comparable {
    var itrA = lhs.makeIterator()
    var itrB = rhs.makeIterator()
    while let nodeA = itrA.next() {
        guard let nodeB = itrB.next() else {
            return false
        }
        guard nodeA < nodeB else {
            return true
        }
    }
    
    return true
}
