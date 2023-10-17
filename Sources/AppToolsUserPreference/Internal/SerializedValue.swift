//
//  SerializedValue.swift
//  
//  
//  Created by keiji0 on 2022/05/06
//  
//

import Foundation

/// シリアライズ可能な値
/// UserDefaultsに格納可能なものを定義する
protocol SerializedValue {}
extension Bool: SerializedValue {}
extension String: SerializedValue {}
extension Double: SerializedValue {}
extension Float: SerializedValue {}
extension Int: SerializedValue {}
extension Int8: SerializedValue {}
extension Int16: SerializedValue {}
extension Int32: SerializedValue {}
extension Int64: SerializedValue {}
extension UInt: SerializedValue {}
extension UInt8: SerializedValue {}
extension UInt16: SerializedValue {}
extension UInt32: SerializedValue {}
extension UInt64: SerializedValue {}
extension Date: SerializedValue {}
extension Data: SerializedValue {}
extension Array: SerializedValue where Element == SerializedValue {}
extension Dictionary: SerializedValue where Key == String, Value == SerializedValue {}
extension NSNumber: SerializedValue {}
extension NSData: SerializedValue {}
extension NSDate: SerializedValue {}
extension NSString: SerializedValue {}

/// nullは格納できないためStringで代用する
/// plistもString("$null")なので中身もそれに合わせておく
/// https://github.com/apple/swift-corelibs-foundation/blob/main/Sources/Foundation/PropertyListEncoder.swift#L1801-L1807
let serializedNilValue: String = String("$null")

struct AnyCodingKey : Hashable, CodingKey {
    
    let stringValue: String
    let intValue: Int?
    
    init<Key: CodingKey>(_ base: Key) {
        self.intValue = base.intValue
        self.stringValue = base.stringValue
    }
    
    init(stringValue: String) {
        self.stringValue = stringValue
        self.intValue = nil
    }
    
    init(intValue: Int) {
        self.stringValue = "\(intValue)"
        self.intValue = intValue
    }
}

func makeValue(_ any: Any) -> SerializedValue {
    switch any {
    case let v as SerializedValue:
        return v
        
    case let v as Array<Any>:
        return v.map { makeValue($0) }
        
    case let v as Dictionary<String, Any>:
        return v.mapValues { makeValue($0) }
        
    default:
        fatalError()
    }
}
