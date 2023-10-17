import XCTest
import Combine
import AppToolsData
@testable import AppToolsUserPreference

final class SerializedValueTests: XCTestCase {
    override func setUp() {
        super.setUp()
        let appDomain = Bundle.main.bundleIdentifier
        UserDefaults.standard.removePersistentDomain(forName: appDomain!)
    }

    override class func tearDown() {
    }
    
    func test_Nilをエンコードできる() {
        struct Foo: Codable, Equatable {
            var v1: Int? = nil
            init(_ v: Int? = nil) {
                self.v1 = v
            }
            func encode(to encoder: Encoder) throws {
                var container = encoder.singleValueContainer()
                if let v1 = v1 {
                    try container.encode(v1)
                } else {
                    try container.encodeNil()
                }
            }
            init(from decoder: Decoder) throws {
                let container = try decoder.singleValueContainer()
                self.v1 = container.decodeNil() ? nil : try container.decode(Int.self)
            }
        }
        do {
            let v1 = Foo(234)
            let v2 = convert(v1, "foo")
            XCTAssertEqual(v1, v2)
        }
        do {
            let v1 = Foo()
            let v2 = convert(v1, "foo")
            XCTAssertEqual(v1, v2)
        }
    }
    
    func test_Data型をエンコードできる() {
        struct Foo: Codable, Equatable {
            var data: Data = "abcdefg".data(using: .utf8)!
        }
        let v1 = Foo()
        let v2 = convert(v1)
        XCTAssertEqual(v1, v2)
    }
    
    func test_Date型をエンコードできる() {
        struct Foo: Codable, Equatable {
            var date: Date = .init()
        }
        let v1 = Foo()
        let v2 = convert(v1)
        XCTAssertEqual(v1, v2)
    }
    
    func test_全ての型をエンコードできる() {
        struct Foo: Codable, Equatable {
            var bool: Bool = false
            var string: String = "abc"
            var double: Double = 3.123
            var float: Float = 1.234
            var inti: Int = 123
            var int8: Int8 = 123
            var int16: Int16 = 123
            var int32: Int32 = 123
            var int64: Int64 = 123
            var uint: UInt = 123
            var uint8: UInt8 = 123
            var uint16: UInt16 = 123
            var uint32: UInt32 = 123
            var uint64: UInt64 = 123
            var date: Date = .init()
            var data: Data = "abcdefg".data(using: .utf8)!
            var array: [Int] = [1, 2, 3]
            var dictionary: [String: Int] = ["a": 1, "b": 2, "c": 3]
        }
        let v1 = Foo()
        let v2 = convert(v1, "bar")
        XCTAssertEqual(v1, v2)
    }
    
    func test_入れ子になったStruct() {
        struct Foo: Codable, Equatable {
            var v1: Int = 123
        }
        struct Bar: Codable, Equatable {
            var foo: Foo = .init()
        }
        let v1 = Bar()
        let v2 = convert(v1)
        XCTAssertEqual(v1, v2)
    }
    
    func test_複数型の配列() {
        struct Foo: Codable, Equatable {
            var v1: Int = 123
            var v2: String = "123"
            init() {}
            func encode(to encoder: Encoder) throws {
                var container = encoder.unkeyedContainer()
                try container.encode(v1)
                try container.encode(v2)
            }
            init(from decoder: Decoder) throws {
                var container = try decoder.unkeyedContainer()
                self.v1 = try container.decode(Int.self)
                self.v2 = try container.decode(String.self)
            }
        }
        let v1 = Foo()
        let v2 = convert(v1)
        XCTAssertEqual(v1, v2)
    }
    
    func test_Codableを要素に持つ配列() {
        struct Foo: Codable, Equatable {
            var uuid = UUID()
        }
        struct Bar: Codable, Equatable {
            var foo = [Foo](arrayLiteral: .init())
        }
        let v1 = Bar()
        let v2 = convert(v1)
        XCTAssertEqual(v1, v2)
    }
    
    // MARK: - Private
    
    private func convert<T: Codable>(_ value: T, _ key: String = "$test") -> T {
        let serializedValue = try! encode(value)
        Self.userStore.set(serializedValue, forKey: key)
        let anyValue = Self.userStore.get(forKey: key)!
        return try! decode(T.self, from: anyValue)
    }
    
    private static var userStore: any KeyValueStorable {
        UserDefaults.standard
    }
}
