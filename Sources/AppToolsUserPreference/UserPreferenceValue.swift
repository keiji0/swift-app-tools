//
//  UserPreferenceValue.swift
//  
//  
//  Created by keiji0 on 2022/05/08
//  
//

import Foundation
import Combine

/// UserDefaultsを使いやすくするためのプロパティラッパー
///
/// UserPreferencesをConformしたclassのプロパティに設定します
/// プロパティはCodableに適用されていればどんな型でも定義することができます。
@propertyWrapper
public struct UserPreferenceValue<Value: Codable> {
    
    public init(_ key: String, defaultValue value: Value) {
        self.key = key
        self.defaultValue = value
    }
    
    public init(key: String, defaultValue value: Value) {
        self.key = key
        self.defaultValue = value
    }

    public var wrappedValue: Value {
        get {
            fatalError()
        }
        set {
            fatalError()
        }
    }

    public var projectedValue: AnyPublisher<Value, Never> {
        subject.eraseToAnyPublisher()
    }
    
    public static subscript<EnclosingSelf>(
        _enclosingInstance enclosingSelf: EnclosingSelf,
        wrapped wrappedKeyPath: ReferenceWritableKeyPath<EnclosingSelf, Value>,
        storage storageKeyPath: ReferenceWritableKeyPath<EnclosingSelf, Self>
    ) -> Value {
        get {
            let userPreference = enclosingSelf as! UserPreferences
            let this = enclosingSelf[keyPath: storageKeyPath]
            return userPreference.get(this.key) ?? this.defaultValue
        }
        set {
            let userPreference = enclosingSelf as! UserPreferences
            let this = enclosingSelf[keyPath: storageKeyPath]
            userPreference.set(this.key, newValue)
            this.subject.send(newValue)
        }
    }
    
    private let key: String
    private let defaultValue: Value
    private let subject = PassthroughSubject<Value, Never>()
}

extension UserPreferences {
    fileprivate func set<Value: Codable>(_ key: String, _ value: Value?) {
        let v = try! encode(value)
        store.set(v, forKey: category.key(key))
    }
    
    fileprivate func get<Value: Codable>(_ key: String) -> Value? {
        guard let value = store.get(forKey: category.key(key)) else {
            return nil
        }
        return try! decode(Value.self, from: value)
    }
}
