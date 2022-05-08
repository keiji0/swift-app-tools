//
//  Treeable.swift
//
//
//  Created by keiji0 on 2021/09/02
//
//

import Foundation

/// 子を持つ親ノード
public protocol TreeParentable: Nodeable {
    /// 子供はコレクションプロトコルを有する
    associatedtype Children: Collection where Children.Element == Self
    /// 子要素を提供
    var children: Children { get }
}

extension TreeParentable where Self: Hashable {
    /// 要素が含まれている判定する
    /// - Parameter where: 判定ブロック
    /// - Returns: 含まれている場合はtrue
    public func contains(where predicate: (Self) -> Bool) -> Bool {
        var result = false
        walk {
            result = predicate($0)
            return !result
        }
        return result
    }

    /// 全てのノードを探索する
    /// - Parameter block: 探索ブロック
    public func forEach(_ block: (Self) -> Void) {
        walk {
            block($0)
            return true
        }
    }

    /// ノードを探索する
    /// - Parameter block: 探索ブロック、falseが返るまで実行
    public func walk(_ block: (Self) -> Bool) {
        var set = Set<Self>()
        walkInner(block, &set)
    }

    @discardableResult
    private func walkInner(_ block: (Self) -> Bool, _ set: inout Set<Self>) -> Bool {
        if set.contains(self) {
            return true
        }
        guard block(self) else {
            return false
        }
        set.insert(self)
        for child in children {
            guard child.walkInner(block, &set) else {
                return false
            }
        }
        return true
    }
}
