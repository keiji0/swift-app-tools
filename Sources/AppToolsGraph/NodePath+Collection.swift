//
//  NodePathCollection.swift
//
//  
//  Created by keiji0 on 2023/06/17
//  
//

extension Collection where Element: Collection, Element.Element : NodeId {
    /// 内包したパスを除外した一覧を取得
    ///
    /// 例えば:
    /// 1. A->B
    /// 2. A->B->C
    /// があったと場合、2.は1.に内包されているので2.を除外したパス一覧を取得することができる。
    public var nonIncludedPaths: [[Element.Element]] {
        var nodes = [InnerNode<Element.Element>]()
        for path in self {
            guard let nodeId = path.first else {
                continue;
            }
            
            if let node = nodes.first(where: { $0.id == nodeId }) {
                node.write(path.dropFirst())
            } else {
                let node = InnerNode(nodeId)
                nodes.append(node)
                node.write(path.dropFirst())
            }
        }
        
        return nodes.flatMap {
            $0.paths
        }
    }
}
    
private class InnerNode<NodeId> where NodeId: AppToolsGraph.NodeId {
    init(_ id: NodeId) {
        self.id = id
    }
    
    let id: NodeId
    var children = [InnerNode]()
    var isLeaf: Bool = false
    
    func write(_ path: some Collection<NodeId>) {
        if isLeaf {
            return
        }
        guard let nid = path.first else {
            isLeaf = true
            children.removeAll() // リーフになった瞬間子は不要
            return
        }
        
        if let child = children.first(where: { $0.id == nid }) {
            child.write(path.dropFirst())
        } else {
            let child = InnerNode(nid)
            children.append(child)
            child.write(path.dropFirst())
        }
    }
    
    var paths: [[NodeId]] {
        children.isEmpty
        ? [ [id] ]
        : children.flatMap {
            $0.paths.map {
                [ self.id ] + $0
            }
        }
    }
}
