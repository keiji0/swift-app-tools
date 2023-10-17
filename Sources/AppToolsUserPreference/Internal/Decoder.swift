//
//  Decoder.swift
//  
//  
//  Created by keiji0 on 2022/05/06
//  
//

import Foundation

func decode<Value>(_ type: Value.Type, from value: Any) throws -> Value where Value : Decodable {
    switch value {
    case let v as Data:
        return v as! Value
    case let v as Date:
        return v as! Value
    default:
        let decoder = ObjectDecoder(makeValue(value))
        return try Value(from: decoder)
    }
}

private final class ObjectDecoder: Decoder {

    let codingPath: [CodingKey]
    var userInfo = [CodingUserInfoKey : Any]()
    let store: SerializedValue
    
    init(_ value: SerializedValue, codingPath: [CodingKey] = []) {
        self.store = value
        self.codingPath = codingPath
    }

    func singleValueContainer() throws -> SingleValueDecodingContainer {
        SingleContainer(store, codingPath: codingPath)
    }
    
    func unkeyedContainer() throws -> UnkeyedDecodingContainer {
        UnkeyedContainer(store, codingPath: codingPath)
    }

    func container<Key>(keyedBy type: Key.Type) throws -> KeyedDecodingContainer<Key> where Key : CodingKey {
        let container = try KeyedContainer<Key>(store, codingPath: codingPath)
        return KeyedDecodingContainer(container)
    }
}

private class SingleContainer: SingleValueDecodingContainer {
    
    let codingPath: [CodingKey]
    let value: SerializedValue
    
    init(_ value: SerializedValue, codingPath: [CodingKey]) {
        self.value = value
        self.codingPath = codingPath
    }
    
    func decodeNil() -> Bool {
        switch value {
        case let v as String:
            return v == serializedNilValue
        default:
            return false
        }
    }
    
    func decode(_ type: Bool.Type) throws -> Bool {
        value as! Bool
    }
    
    func decode(_ type: String.Type) throws -> String {
        value as! String
    }
    
    func decode(_ type: Double.Type) throws -> Double {
        value as! Double
    }
    
    func decode(_ type: Float.Type) throws -> Float {
        value as! Float
    }
    
    func decode(_ type: Int.Type) throws -> Int {
        value as! Int
    }
    
    func decode(_ type: Int8.Type) throws -> Int8 {
        value as! Int8
    }
    
    func decode(_ type: Int16.Type) throws -> Int16 {
        value as! Int16
    }
    
    func decode(_ type: Int32.Type) throws -> Int32 {
        value as! Int32
    }
    
    func decode(_ type: Int64.Type) throws -> Int64 {
        value as! Int64
    }
    
    func decode(_ type: UInt.Type) throws -> UInt {
        value as! UInt
    }
    
    func decode(_ type: UInt8.Type) throws -> UInt8 {
        value as! UInt8
    }
    
    func decode(_ type: UInt16.Type) throws -> UInt16 {
        value as! UInt16
    }
    
    func decode(_ type: UInt32.Type) throws -> UInt32 {
        value as! UInt32
    }
    
    func decode(_ type: UInt64.Type) throws -> UInt64 {
        value as! UInt64
    }
    
    func decode<T>(_ type: T.Type) throws -> T where T : Decodable {
        try AppToolsUserPreference.decode(type, from: value)
    }
}

private struct UnkeyedContainer: UnkeyedDecodingContainer {
    
    let codingPath: [CodingKey]
    let value: [SerializedValue]
    var count: Int? { value.count }
    
    var isAtEnd: Bool {
        guard let count = self.count else {
            return true
        }
        return count <= currentIndex
    }
    var currentIndex: Int = 0
    
    init(_ value: Any, codingPath: [CodingKey]) {
        self.value = value as! [SerializedValue]
        self.codingPath = codingPath
    }
    
    mutating func decodeNil() throws -> Bool {
        switch try decode() {
        case let v as String:
            return v == serializedNilValue
        default:
            return false
        }
    }
    
    mutating func decode<T>(_ type: T.Type) throws -> T where T : Decodable {
        try SingleContainer(try decode(), codingPath: currentPath).decode(type)
    }
    
    mutating func nestedContainer<NestedKey>(keyedBy type: NestedKey.Type) throws -> KeyedDecodingContainer<NestedKey> where NestedKey : CodingKey {
        KeyedDecodingContainer(try KeyedContainer<NestedKey>(try decode(), codingPath: currentPath))
    }
    
    mutating func nestedUnkeyedContainer() throws -> UnkeyedDecodingContainer {
        UnkeyedContainer(try decode(), codingPath: currentPath)
    }
    
    func superDecoder() throws -> Decoder {
        fatalError()
    }
    
    private mutating func decode() throws -> SerializedValue {
        assert(!isAtEnd)
        defer { self.currentIndex += 1 }
        return value[currentIndex]
    }
    
    private var currentPath: [CodingKey] {
        codingPath + [ AnyCodingKey(intValue: count!) ]
    }
}

private struct KeyedContainer<Key: CodingKey> : KeyedDecodingContainerProtocol {
    
    let codingPath: [CodingKey]
    var allKeys: [Key] { value.keys.map { .init(stringValue: $0)! } }
    private let value: [String: SerializedValue]
    
    init(_ value: SerializedValue, codingPath: [CodingKey]) throws {
        self.value = value as! Dictionary<String, SerializedValue>
        self.codingPath = codingPath
    }
    
    func contains(_ key: Key) -> Bool {
        value[.init(key.stringValue)] != nil
    }
    
    func decodeNil(forKey key: Key) throws -> Bool {
        switch value[.init(key.stringValue)] {
        case let v as String:
            return v == serializedNilValue
        default:
            return false
        }
    }
    
    func decode<T>(_ type: T.Type, forKey key: Key) throws -> T where T: Decodable {
        let newPath = self.codingPath + [ key ]
        return try SingleContainer(try decode(key), codingPath: newPath).decode(type)
    }
    
    private func decode(_ key: Key) throws -> SerializedValue {
        guard let v = value[key.stringValue] else {
            fatalError()
        }
        return v
    }
    
    func nestedContainer<NestedKey>(keyedBy type: NestedKey.Type, forKey key: Key) throws -> KeyedDecodingContainer<NestedKey> where NestedKey : CodingKey {
        let newPath = self.codingPath + [ key ]
        let container = try KeyedContainer<NestedKey>(try decode(key), codingPath: newPath)
        return KeyedDecodingContainer(container)
    }
    
    func nestedUnkeyedContainer(forKey key: Key) throws -> UnkeyedDecodingContainer {
        let newPath = self.codingPath + [ key ]
        return UnkeyedContainer(try decode(key), codingPath: newPath)
    }
    
    func superDecoder() throws -> Decoder {
        fatalError()
    }
    
    func superDecoder(forKey key: Key) throws -> Decoder {
        fatalError()
    }
}

private func keyedStore(_ value: Any) throws -> [AnyCodingKey: SerializedValue] {
    var res = [AnyCodingKey: SerializedValue]()
    switch value {
    case let dict as Dictionary<String, SerializedValue>:
        for (k, v) in dict {
            res[.init(stringValue: k)] = v
        }
    case let dict as Dictionary<Int, SerializedValue>:
        for (k, v) in dict {
            res[.init(intValue: k)] = v
        }
    default:
        fatalError()
    }
    return res
}

