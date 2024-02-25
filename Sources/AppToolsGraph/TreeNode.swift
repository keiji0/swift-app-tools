//
//  TreeNode.swift
//
//  
//  Created by keiji0 on 2023/11/04
//  
//

import Foundation

/// ツリーノード。参照は1つだけを持つ
public protocol TreeNode: BidirectionalNode {
    /// 参照元のノード一覧
    /// 順序に意味はなく参照元を辿れるぐらいの意味合い
    var parent: Self? { get }
}

extension TreeNode {
    public var isRoot: Bool {
        parent == nil
    }
    
    /// リーフノードか？
    public var isLeaf: Bool {
        targets.isEmpty
    }
    
    /// BidirectionalNodeに適用するためにソース一覧を取得できるようにしておく
    public var sources: some Collection<Self> {
        if let parent {
            [parent]
        } else {
            [Self]()
        }
    }
    
    /// 親から見たインデックスを取得
    public var indexFromParent: Targets.Index? {
        guard let parent else {
            return nil
        }
        return parent.targets.firstIndex {
            $0.id == id
        }
    }
    
    /// 兄弟かどうか？
    public func isSibling(_ node: Self) -> Bool {
        guard // 自分自身は兄弟ではない
              id != node.id,
              let parent, let otherParent = node.parent else {
            return false
        }
        return parent.id == otherParent.id
    }
    
    /// 次の兄弟ノードを取得。次というのはTargetsのコレクションでいうところのAfterにあたる
    public var nextSibling: Self? {
        guard let parent,
              let index = parent.targets.firstIndex(where: { $0.id == id }) else {
            return nil
        }
        
        let nextIndex = parent.targets.index(after: index)
        guard nextIndex < parent.targets.endIndex else {
            return nil
        }
        return parent.targets[nextIndex]
    }
    
    /// 親の次の兄弟を取得、存在しなければさらに親を辿る
    private var deepParentNextSibling: Self? {
        guard let parent else {
            return nil
        }
        if let nextSibling = parent.nextSibling {
            return nextSibling
        }
        return parent.deepParentNextSibling
    }
}

extension TreeNode where Targets: BidirectionalCollection, Targets.Element == Self {
    /// 前の兄弟ノードを取得。前というのはTargetsのコレクションでいうところのAfterにあたる
    public var previousSibling: Self? {
        guard let parent,
              let index = parent.targets.firstIndex(where: { $0.id == id }) else {
            return nil
        }
        
        let prevIndex = parent.targets.index(before: index)
        guard parent.targets.startIndex <= prevIndex else {
            return nil
        }
        return parent.targets[prevIndex]
    }
    
    /// ツリーを行に見立てた場合の次の行となるノードを取得
    public var nextRow: Self? {
        // 子がいるなら最初の子供を返す
        if let firstChild = targets.first {
            return firstChild
        }
        // 兄弟がいるなら次の兄弟を返す
        if let nextSibling = nextSibling {
            return nextSibling
        }
        // なければ親を辿って次の兄弟を探す
        return deepParentNextSibling
    }
    
    /// ツリーを行に見立てた場合の前の行となるノードを取得
    public var previousRow: Self? {
        if let previousSibling {
            previousSibling.lastDescendant ?? previousSibling
        } else {
            parent
        }
    }
}
