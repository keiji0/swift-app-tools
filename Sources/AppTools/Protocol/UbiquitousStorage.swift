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
    func gets<Value: Decodable>(_ key: UbiquitousStorageKey) throws -> [Value]
    /// 値を格納
    func set<Value: Encodable>(_ key: UbiquitousStorageKey, _ value: Value) throws
}

/// 設定キーの一覧
/// アプリーケーション側でキーを定義する
extension UbiquitousStorageKey {
}

/// キー
/// UbiquitousStorageにデータを保存するにはキーがこの必要になる
public struct UbiquitousStorageKey {
    /// 初期化処理
    public init(_ type: SharedType, _ key: String) {
        self.sharedType = type
        self.key = key
    }

    /// キー
    public let key: String
    /// 共有タイプ
    public let sharedType: SharedType
    /// 共有タイプ一覧
    public enum SharedType {
        /// 全デバイスで共有
        case all
        /// デバイス固有の情報
        case own
    }
}
