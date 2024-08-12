//
//  KeyModifierFlags.swift
//  
//  
//  Created by keiji0 on 2022/03/19
//  
//

import Foundation

/// 修飾キーを扱いやすくしたフラグ一覧
public struct KeyModifierFlags : OptionSet {
    
    public let rawValue: UInt
    public init(rawValue: UInt) { self.rawValue = rawValue }
    
    public static let capsLock = Self(rawValue: 1 << 0)
    public static let shift = Self(rawValue: 1 << 1)
    public static let control = Self(rawValue: 1 << 2)
    public static let option = Self(rawValue: 1 << 3)
    public static let command = Self(rawValue: 1 << 4)
}
