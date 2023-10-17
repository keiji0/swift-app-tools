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
     public var deepSources: some Sequence<Self> {
         TraverseSequence(self, \Self.sources)
     }
    
    /// ソースをルートまで辿っていき、このノードへの全てのパスを取得
    public var ancestorPaths: [[ID]] {
        func traverse(_ node: Self, _ visited: [Pair<ID, ID>]) -> [[ID]] {
            if node.sources.isEmpty {
                return [[node.id]]
            }
            
            var paths = [[ID]]()
            for source in node.sources {
                let pair = Pair<ID, ID>(source.id, node.id)
                if visited.contains(pair) {
                    continue
                }
                for path in traverse(source, visited + [pair]) {
                    paths.append(path + node.id)
                }
            }
            return paths
        }
        return traverse(self, [])
    }
}
