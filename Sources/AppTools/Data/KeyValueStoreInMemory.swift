//
//  KeyValueStoreInMemory.swift
//  
//  
//  Created by keiji0 on 2023/01/31
//  
//

import Foundation

/// メモリ上のKeyValueStore
final class KeyValueStoreInMemory : KeyValueStorable {
    private var store = [String: Any]()
    
    public init() { }
    
    public func get(forKey key: String) -> Any? {
        store[key]
    }
    
    public func set(_ value: Any?, forKey key: String) {
        store[key] = value
    }
    
    public func remove(forKey key: String) {
        store[key] = nil
    }
    
    public var keys: [String] {
        .init(store.keys)
    }
}
