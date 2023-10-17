//
//  UserPreferences.swift
//
//  Created by keiji0 on 2021/02/19.
//

import Foundation
import AppToolsData

/// ユーザー設定を提供するプロトコル
public protocol UserPreferences: AnyObject {
    /// 保存先を取得
    /// デフォルトはUserDefaults.standardが提供される
    var store: any KeyValueStorable { get }
    
    /// カテゴリ
    /// KeyValueStorableのkeyのプレフィックになります
    /// Preferenceを分けたい場合に使用します
    var category: Category { get }
}

extension UserPreferences {
    /// デフォルトのストアを提供
    var store: KeyValueStorable { UserDefaults.standard }
    
    /// デフォルトのカテゴリを提供
    var category: Category { .default }
    
    /// カテゴリ内の値を削除する
    public func removeAll() {
        for key in keys {
            store.remove(forKey: key)
        }
    }
    
    /// 設定されている全てのキーを取得
    var keys: [String] {
        store.keys.filter {
            category.contains($0)
        }
    }
}
