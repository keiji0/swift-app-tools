//
//  OpenOptions.swift
//  
//  
//  Created by keiji0 on 2022/04/23
//  
//

import Foundation
import SQLite3

/// sqlite3_openへのオプション
public struct OpenOptions: OptionSet {
    public let rawValue: Int32
    
    public static let readOnly     = OpenOptions(rawValue: SQLITE_OPEN_READONLY)
    public static let readWrite    = OpenOptions(rawValue: SQLITE_OPEN_READWRITE)
    public static let create       = OpenOptions(rawValue: SQLITE_OPEN_CREATE)
    public static let noMutex      = OpenOptions(rawValue: SQLITE_OPEN_NOMUTEX)
    public static let fullMutex    = OpenOptions(rawValue: SQLITE_OPEN_FULLMUTEX)
    public static let sharedCache  = OpenOptions(rawValue: SQLITE_OPEN_SHAREDCACHE)
    public static let privateCache = OpenOptions(rawValue: SQLITE_OPEN_PRIVATECACHE)
    public static let `default`: OpenOptions = [.readWrite, .create]

    public init(rawValue: Int32) {
        self.rawValue = rawValue
    }
}
