//
//  BidirectionalNode.swift
//  
//  
//  Created by keiji0 on 2023/04/02
//  
//

import Foundation
import AppToolsData

/// 双方向ノードを表すグラフノード
public protocol BidirectionalNode: DirectedNode {
    associatedtype Sources: Collection<Self>
    /// 参照元のノード一覧
    /// 順序に意味はなく参照元を辿れるぐらいの意味合い
    var sources: Sources { get }
}

extension BidirectionalNode {
    /// 再帰的にSourcesを辿ったノードの一覧
    public var ancestors: some Sequence<Self> {
         TraverseSequence(self, \Self.sources)
    }
    
    /// 指定したノードまで辿っていきこのノードへのパスを取得
    /// * 同一のソースとペアになるパスは除外される
    /// * originNodeIdから参照がなければパスには含まれない
    public func uniqueAncestorsPath(origin originNodeId: ID) -> some Sequence<[ID]> {
        if originNodeId == id {
            return TraverseSequenceWithPath(origin: self)
                .lazy.filter{ _ in true }
                .map{ path, _ in path }
        }
        
        var visited = Set<Pair<ID, ID>>()
        return TraverseSequenceWithPath(self) { node, _ in
            if node.id == originNodeId {
                [Self]()
            } else {
                node.sources.filter { source in
                    visited.insert(.init(source.id, node.id)).inserted
                }
            }
        }.lazy.filter{ path, node in
            node.id == originNodeId
        }.map{ path, node in
            [node.id] + path.reversed()
        }
    }
}
