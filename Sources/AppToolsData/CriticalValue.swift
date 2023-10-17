//
//  CriticalValue.swift
//  
//  
//  Created by keiji0 on 2021/09/24
//  
//

import Foundation

/// スレッドセーフな値
public struct CriticalValue<Value> {
    
    private var _value: Value
    private var lock = NSLock()
    
    public init(_ value: Value) {
        self._value = value
    }
    
    public var value: Value {
        get {
            lock.lock()
            defer { lock.unlock() }
            return _value
        }
        set {
            lock.lock()
            defer { lock.unlock() }
            _value = newValue
        }
    }
}

extension CriticalValue: CustomStringConvertible where Value: CustomStringConvertible {
    public var description: String {
        value.description
    }
}
