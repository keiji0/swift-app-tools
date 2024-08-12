//
//  NSUbiquitousKeyValueStore+KeyValueStorable.swift
//  
//  
//  Created by keiji0 on 2023/01/31
//  
//

import Foundation
import AppToolsData

extension Foundation.NSUbiquitousKeyValueStore : AppToolsData.KeyValueStorable {
    public func get(forKey key: String) -> Any? {
        object(forKey: key)
    }
    
    public func remove(forKey key: String) {
        removeObject(forKey: key)
    }
    
    public var keys: [String] {
        .init(dictionaryRepresentation.keys)
    }
}
