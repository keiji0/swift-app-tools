//
//  Int64.swift
//
//
//  Created by keiji0 on 2021/08/28
//
//

import Foundation

extension Int64 {
    /// UInt64を大小保ったままInt64に変換
    /// - Parameter uint64: 変換元のUInt64
    /// Uint64を以下の条件でInt64に変換する
    /// Int64.min == Int64(forOrder: UInt64.min)
    /// Int64.max == Int64(forOrder: UInt64.max)
    public init(forOrder uint64: UInt64) {
        let int64 = Int64(bitPattern: uint64)
        if int64.signum() < 0 {
            self = Int64.max + int64 + 1
        } else {
            self = Int64.min + int64
        }
    }
}
