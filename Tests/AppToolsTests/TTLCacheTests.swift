//
//  TTLCacheTests.swift
//  
//  
//  Created by keiji0 on 2023/01/15
//  
//

import XCTest
@testable import AppTools

let ttl = 0.5

final class TTLCacheTests: XCTestCase {
    private let cache = Cache(ttl)
    
    func test_キャッシュされる() {
        let obj = Object()
        cache.set("hoge", obj)
        XCTAssertEqual(cache.get("hoge"), obj)
    }
    
    func test_参照が切れかつ寿命が切れるとキャッシュは残らない() {
        var obj: Object! = .init()
        cache.set("hoge", obj)
        obj = nil
        Thread.sleep(forTimeInterval: ttl)
        cache.purge()
        XCTAssertEqual(cache.get("hoge"), nil)
    }
    
    func test_寿命が切れても参照が残っていればキャッシュされる() {
        let obj = Object()
        cache.set("hoge", obj)
        Thread.sleep(forTimeInterval: ttl)
        XCTAssertEqual(cache.get("hoge"), obj)
    }
    
    func test_寿命が残っていて参照が切れた場合はキャッシュが残っている() {
        var obj: Object! = .init()
        cache.set("hoge", obj)
        obj = nil
        XCTAssertNotNil(cache.get("hoge"))
    }
}

private typealias Cache = TTLCache<String, Object>
private class Object : Equatable {
    static func == (lhs: Object, rhs: Object) -> Bool {
        lhs === rhs
    }
}
