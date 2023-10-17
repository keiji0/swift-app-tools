//
//  Versionable.swift
//  
//  
//  Created by keiji0 on 2022/04/22
//  
//

import Foundation

/// バージョン情報
public struct Version : Equatable, Comparable {
    
    public init(_ value: UInt = 1) {
        self.no = value
    }
    
    /// バージョン番号
    public let no: UInt
    
    /// 初期バージョンかどうか？
    public var isFirst: Bool {
        no == 1
    }
    
    /// 次のバージョン
    public var next: Version {
        Version(no + 1)
    }
    
    public static func < (lhs: Version, rhs: Version) -> Bool {
        lhs.no < rhs.no
    }
}

/// バージョン管理可能なプロトコル
public protocol Versionable {
    /// バージョンを取得、設定できる
    var version: Version { get set }
}
