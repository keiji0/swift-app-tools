//
//  RangeReplaceableCollection.swift
//  
//  
//  Created by keiji0 on 2023/03/26
//  
//

import Foundation

extension RangeReplaceableCollection {
    /// コレクション結合
    /// 結合を少し見やすくするため
    /// [1, 2] + 3 -> [ 1, 2, 3 ]
    static public func +(left: Self, right: Element) -> Self {
        left + CollectionOfOne(right)
    }
}
