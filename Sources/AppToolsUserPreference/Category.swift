//
//  Category.swift
//  
//  
//  Created by keiji0 on 2022/05/08
//  
//

import Foundation

/// UserPreferenceのカテゴリ
public struct Category: Equatable, Hashable {
    /// カテゴリ名
    public let name: String
    /// カテゴリの生成
    public init(_ name: String) {
        self.name = name
    }
    
    func contains(_ key: String) -> Bool {
        key.hasPrefix(storedName)
    }
    
    func key(_ key: String) -> String {
        "\(storedName).\(key)"
    }
    
    /// 保存時に使用するカテゴリ名
    private var storedName: String { "\(name)" }
}

extension Category {
    /// 初期カテゴリ
    public static let `default` = Category("default")
}
