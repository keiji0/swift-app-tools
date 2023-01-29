//
//  UbiquitousCoreStorage.swift
//  
//  
//  Created by keiji0 on 2022/04/29
//  
//

import Foundation

/// デバイス間で共有されるストレージ
public protocol UbiquitousStorage : AnyObject {
    /// キーに格納された値を取得
    func get<Value: Decodable>(_ key: UbiquitousStorageKey) throws -> Value?
    /// 全てのデバイスのキーを取得
    /// Valueのオーダーは保証しない
    func gets<Value: Decodable>(_ key: UbiquitousStorageKey) throws -> [Value]
    /// 値を格納
    func set<Value: Encodable>(_ key: UbiquitousStorageKey, _ value: Value) throws
}

extension UbiquitousStorage {
    /// 型指定で取得
    public func get<Value: Decodable>(_ type: Value.Type, _ key: UbiquitousStorageKey) throws -> Value? {
        try get(key)
    }
    
    /// 型指定で取得
    public func gets<Value: Decodable>(_ type: Value.Type, _ key: UbiquitousStorageKey) throws -> [Value] {
        try gets(key)
    }
}

/// 設定キーの一覧
/// アプリーケーション側でキーを定義する
extension UbiquitousStorageKey {
}

/// キー
/// UbiquitousStorageにデータを保存するにはキーがこの必要になる
public struct UbiquitousStorageKey {
    /// 初期化処理
    public init(_ type: SharedType, _ key: Key) {
        self.sharedType = type
        self.key = key
    }

    /// キー
    public let key: Key
    /// 共有タイプ
    public let sharedType: SharedType
    
    /// キータイプ
    public typealias Key = String
    /// 共有タイプ一覧
    public enum SharedType {
        /// 全デバイスで共有
        case all
        /// デバイス固有の情報
        case own
    }
}
