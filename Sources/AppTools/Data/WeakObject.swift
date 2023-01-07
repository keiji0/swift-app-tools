//
//  WeakObject.swift
//  
//  
//  Created by keiji0 on 2023/01/07
//  
//

import Foundation

/// 弱い参照を持つオブジェクト
/// コレクションなどweak指定できなところで使用する
public struct WeakObject<T: AnyObject> {
    public init(_ value: T) {
        self.value = value
    }
    
    /// 参照している値
    public private(set) weak var value : T?
    /// 値を保持しているか？
    public var hasValue: Bool { value != nil }
}
