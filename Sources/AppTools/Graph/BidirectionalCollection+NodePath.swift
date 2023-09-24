//
//  BidirectionalCollection+NodePath.swift
//
//  
//  Created by keiji0 on 2023/04/09
//  
//

import Foundation

extension BidirectionalCollection where Element: GraphNodeId {
    /// 親を取得
    /// 要素が1つかなければルートなので親は存在せずnilが返る
    public var parent: SubSequence? {
        let res = dropLast()
        return res.isEmpty ? nil : res
    }
    
    /// 親のノードIDを取得
    public var parentNodeId: Element? {
        1 < count
        ? self[index(endIndex, offsetBy: -2)]
        : nil
    }
    
    /// 親と最後の要素を同時に取得
    public var parentAndLast: (SubSequence, Element)? {
        guard let parent = parent,
              let last = last else {
            return nil
        }
        return (parent, last)
    }
    
    /// パス一覧を取得
    public var sources: [SubSequence] {
        indices.map {
            prefix(through: $0)
        }
    }
    
    /// 親の一覧を取得
    public var parents: [SubSequence] {
        indices.dropLast().map {
            prefix(through: $0)
        }
    }
    
    /// 親子ペアを取得
    public var parentChild: Pair<Element, Element>? {
        guard let parent = parentNodeId,
              let child = last else {
            return nil
        }
        return .init(parent, child)
    }
}
