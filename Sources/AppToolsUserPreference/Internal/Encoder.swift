//
//  Encoder.swift
//  
//  
//  Created by keiji0 on 2022/05/03
//  
//

import Foundation
import AppToolsData

func encode<Value: Encodable>(_ value: Value) throws -> SerializedValue {
    switch value {
    case let v as Data:
        return v
    case let v as Date:
        return v
    default:
        let encoder = ObjectEncoder()
        try value.encode(to: encoder)
        return encoder.value
    }
}

/// SwiftのObjectに変換するEncoder
private final class ObjectEncoder: Encoder {

    let codingPath: [CodingKey]
    let userInfo: [CodingUserInfoKey : Any] = [:]
    private var container: ObjectContainer? = nil
    
    init(codingPath: [CodingKey] = []) {
        self.codingPath = codingPath
    }

    func container<Key>(keyedBy type: Key.Type) -> KeyedEncodingContainer<Key> where Key : CodingKey {
        let container = KeyedContainer<Key>(codingPath: codingPath)
        self.container = container
        return KeyedEncodingContainer(container)
    }

    func unkeyedContainer() -> UnkeyedEncodingContainer {
        let container = UnkeyedContainer(codingPath: codingPath)
        self.container = container
        return container
    }

    func singleValueContainer() -> SingleValueEncodingContainer {
        let container = SingleContainer(codingPath: codingPath)
        self.container = container
        return container
    }
    
    var value: SerializedValue {
        container!.value
    }
}

private protocol ObjectContainer: AnyObject {
    var value: SerializedValue { get }
}

private final class SingleContainer: ObjectContainer, SingleValueEncodingContainer {
    
    let codingPath: [CodingKey]
    var value: SerializedValue { storedValue! }
    
    private var storedValue: SerializedValue?
    
    init(codingPath: [CodingKey]) {
        self.codingPath = codingPath
    }
    
    func encodeNil() throws {
        self.storedValue = serializedNilValue
    }
    
    func encode(_ value: Bool) throws {
        self.storedValue = value
    }
    
    func encode(_ value: String) throws {
        self.storedValue = value
    }
    
    func encode(_ value: Double) throws {
        self.storedValue = value
    }
    
    func encode(_ value: Float) throws {
        self.storedValue = value
    }
    
    func encode(_ value: Int) throws {
        self.storedValue = value
    }
    
    func encode(_ value: Int8) throws {
        self.storedValue = value
    }
    
    func encode(_ value: Int16) throws {
        self.storedValue = value
    }
    
    func encode(_ value: Int32) throws {
        self.storedValue = value
    }
    
    func encode(_ value: Int64) throws {
        self.storedValue = value
    }
    
    func encode(_ value: UInt) throws {
        self.storedValue = value
    }
    
    func encode(_ value: UInt8) throws {
        self.storedValue = value
    }
    
    func encode(_ value: UInt16) throws {
        self.storedValue = value
    }
    
    func encode(_ value: UInt32) throws {
        self.storedValue = value
    }
    
    func encode(_ value: UInt64) throws {
        self.storedValue = value
    }
    
    func encode<V>(_ value: V) throws where V : Encodable {
        self.storedValue = try AppToolsUserPreference.encode(value)
    }
}

private final class UnkeyedContainer: ObjectContainer, UnkeyedEncodingContainer {
    
    let codingPath: [CodingKey]
    var count: Int { store.count }
    
    var value: SerializedValue {
        var res = [SerializedValue]()
        store.forEach {
            res.append($0.value)
        }
        return res
    }
    
    private var store = [any ObjectContainer]()
    
    init(codingPath: [CodingKey]) {
        self.codingPath = codingPath
    }

    func encodeNil() throws {
        var container = nestedSingleValueContainer()
        try container.encodeNil()
    }
    
    func encode<Value>(_ value: Value) throws where Value : Encodable {
        var container = nestedSingleValueContainer()
        try container.encode(value)
    }
    
    private func nestedSingleValueContainer() -> any SingleValueEncodingContainer {
        let newPath = codingPath + [ AnyCodingKey(intValue: count) ]
        let container = SingleContainer(codingPath: newPath)
        self.store.append(container)
        return container
    }

    func nestedContainer<NestedKey>(keyedBy keyType: NestedKey.Type) -> KeyedEncodingContainer<NestedKey> where NestedKey : CodingKey {
        let newPath = codingPath + [ AnyCodingKey(intValue: count) ]
        let container = KeyedContainer<NestedKey>(codingPath: newPath)
        self.store.append(container)
        return KeyedEncodingContainer(container)
    }

    func nestedUnkeyedContainer() -> UnkeyedEncodingContainer {
        let newPath = codingPath + [ AnyCodingKey(intValue: count) ]
        let container = UnkeyedContainer(codingPath: newPath)
        self.store.append(container)
        return container
    }

    func superEncoder() -> Encoder {
        fatalError()
    }
}

private final class KeyedContainer<Key: CodingKey> : ObjectContainer, KeyedEncodingContainerProtocol {
    
    var value: SerializedValue {
        var res = [String: SerializedValue]()
        store.forEach { key, container in
            res[key.stringValue] = container.value
        }
        return res
    }
    
    let codingPath: [CodingKey]
    
    private var store = [AnyCodingKey: ObjectContainer]()
    
    init(codingPath: [CodingKey]) {
        self.codingPath = codingPath
    }
    
    func encodeNil(forKey key: Key) throws {
        var container = nestedSingleValueContainer(forKey: key)
        try container.encodeNil()
    }
    
    func encode<Value: Encodable>(_ value: Value, forKey key: Key) throws {
        var container = nestedSingleValueContainer(forKey: key)
        try container.encode(value)
    }
    
    private func nestedSingleValueContainer(forKey key: Key) -> SingleValueEncodingContainer {
        let newPath = codingPath + [ AnyCodingKey(key) ]
        let container = SingleContainer(codingPath: newPath)
        self.store[.init(key)] = container
        return container
    }
    
    func nestedContainer<NestedKey>(keyedBy keyType: NestedKey.Type, forKey key: Key) -> KeyedEncodingContainer<NestedKey> where NestedKey : CodingKey {
        let newPath = codingPath + [ AnyCodingKey(key) ]
        let container = KeyedContainer<NestedKey>(codingPath: newPath)
        self.store[.init(key)] = container
        return KeyedEncodingContainer(container)
    }
    
    func nestedUnkeyedContainer(forKey key: Key) -> UnkeyedEncodingContainer {
        let newPath = codingPath + [ AnyCodingKey(key) ]
        let container = UnkeyedContainer(codingPath: newPath)
        self.store[.init(key)] = container
        return container
    }
    
    func superEncoder() -> Encoder {
        fatalError()
    }
    
    func superEncoder(forKey key: Key) -> Encoder {
        fatalError()
    }
}

