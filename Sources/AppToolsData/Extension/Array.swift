//
//  Array.swift
//  
//  
//  Created by keiji0 on 2023/03/25
//  
//

import Foundation

extension Array {
    /// 指定要素を削除する
    public mutating func removeFirst(of element: Element) where Element: Equatable {
        guard let index = firstIndex(of: element) else {
            return
        }
        remove(at: index)
    }
}
