//
//  History.swift
//  
//  
//  Created by keiji0 on 2022/07/25
//  
//

import Foundation
import Combine

/// ヒストリ管理
/// 戻る/進むのデータ処理機能を提供します
public final class History<Item> {
    /// 現在のアイテム
    /// アプリケーションはこの値を監視することでUIへ反映します
    @Published private(set) public var current: Item
    /// 戻るアイテム一覧
    public private(set) var backQueue = [Item]()
    /// 進むアイテム一覧
    public private(set) var forwardQueue = [Item]()
    
    /// 生成
    /// - Parameter current: 最初にアイテムがあれば設定
    public init(_ top: Item) {
        self.current = top
    }
    
    /// 履歴がなくデフォルトが先頭にいるか
    public var isTop: Bool {
        backQueue.isEmpty
    }
    
    /// 履歴に追加
    /// - Parameter item: 履歴に追加するアイテム
    /// 進むキューはクリアされます
    public func append(_ item: Item) {
        // 戻る履歴に保存
        backQueue.append(current)
        // 進む履歴はクリアしておく
        forwardQueue.removeAll()
        
        current = item
    }
    
    /// 進むことができるか？
    public var canForward: Bool {
        forwardQueue.isAny
    }
    
    /// 進む
    /// バックした履歴を再度進める。実行前にcanForwardで確認する必要があります
    /// 成功時にバックキューに現在のItemを追加します
    public func forward() {
        assert(canForward)
        let top = forwardQueue.popLast()!
        backQueue.append(current)
        current = top
    }
    
    /// 戻ることができるか？
    public var canBack: Bool {
        backQueue.isAny
    }
    
    /// 戻す
    /// 実行前にcanBackで確認する必要があります。
    /// 成功時にフォワードキューに現在のItemを追加します
    public func back()  {
        assert(canBack)
        let last = backQueue.popLast()!
        forwardQueue.append(current)
        current = last
    }
}

/// ItemがCodableであればHistoryは復元できる
extension History: Codable where Item: Codable {
    
    enum CodingKeys: CodingKey {
        case current
        case backQueue
        case forwardQueue
    }
    
    public convenience init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.init(try values.decode(Item.self, forKey: .current))
        self.backQueue = try values.decode([Item].self, forKey: .backQueue)
        self.forwardQueue = try values.decode([Item].self, forKey: .forwardQueue)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(current, forKey: .current)
        try container.encode(backQueue, forKey: .backQueue)
        try container.encode(forwardQueue, forKey: .forwardQueue)
    }
}

/// Itemに同一性があればHistoryも同一になる
/// テストとかに使うぐらい
extension History: Equatable where Item: Equatable {
    public static func == (lhs: History, rhs: History) -> Bool {
        lhs.current == rhs.current
        && lhs.backQueue == rhs.backQueue
        && lhs.forwardQueue == rhs.forwardQueue
    }
}
