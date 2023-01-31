//
//  KeyValueStorable.swift
//  
//  
//  Created by keiji0 on 2023/01/31
//  
//

import Foundation

/// KeyValueストアプロトコル
/// 実際にストレージに保存するかどうかは実装次第
/// UserDefaultsを扱いやすくするためのプロトコルでもある
public protocol KeyValueStorable {
    /// 指定したキーの値を取得
    /// - Parameter forKey: 取得キー
    /// - Returns: 存在しない場合はnilが返る
    func get(forKey: String) -> Any?
    
    
    /// 指定したキーへ値を設定する
    /// - Parameters:
    ///   - value: 保存したい値
    ///   - forKey: 設定したいキー
    func set(_ value: Any?, forKey: String)
    
    /// 指定したキーの値を削除する
    /// - Parameter forKey: 削除したいキー
    func remove(forKey: String)
    
    /// 設定された値全てを取得
    var keys: [String] { get }
}
