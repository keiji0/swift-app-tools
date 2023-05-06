//
//  DirectedGraphNode.swift
//  
//  
//  Created by keiji0 on 2023/04/02
//  
//

import Foundation

/// グラフのノードを表すプロトコル
/// 隣接リストで表されたグラフの頂点
public protocol DirectedGraphNode : GraphNode {
    associatedtype Targets: Collection<Self>
    /// 関連するノードへのリスト
    /// edgesとかではなくtargetsにしているのは有向グラフであるから
    var targets: Targets { get }
}

extension DirectedGraphNode {
    /// 指定パスからノードを取得
    public func target(_ path: some Sequence<ID>) -> Self? {
        var itr = path.makeIterator()
        guard let root = itr.next(),
              id == root else {
            return nil
        }
        
        var current = self
        while let child = itr.next() {
            guard let res = current.targets.first(where: { $0.id == child }) else {
                return nil
            }
            current = res
        }
        
        return current
    }
    
    /// 指定パスが存在するのかチェック
    public func isExists(_ path: some Sequence<ID>) -> Bool {
        target(path) != nil
    }
}
