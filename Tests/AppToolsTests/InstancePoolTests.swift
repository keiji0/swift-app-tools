//
//  InstancePoolTests.swift
//  
//  
//  Created by keiji0 on 2022/06/25
//  
//

import XCTest
@testable import AppTools

final class InstancePoolTests: XCTestCase {
    func test_インスタンスを共有できる() {
        XCTAssertEqual(pool.ref("foo"), pool.ref("foo"))
    }
    func test_参照がなくなると破棄されている() {
        final class AnyInstance {
            init(_ finisher: @escaping ()->Void) {
                self.finisher = finisher
            }
            deinit {
                self.finisher()
            }
            private let finisher: ()->Void
        }
        
        var status: String = ""
        let finisher = {
            status = "finished"
        }
        
        let pool = InstancePool<String, AnyInstance> { _ in
            .init(finisher)
        }
        do {
            _ = pool.ref("hoge")
        }
        XCTAssertTrue(status == "finished")
    }
    
    func test_インスタンスの直接参照できる() {
        let handle = pool.ref("foo")
        XCTAssertEqual(pool["foo"], handle.instance)
    }
    
    func test_インスタンスが存在しないときはnilが返る() {
        XCTAssertNil(pool["foo"])
    }
    
    // MARK: - Private
    
    private final class AnyInstance : Equatable {
        let id: String
        init(_ id: String) {
            self.id = id
        }
        static func == (lhs: InstancePoolTests.AnyInstance, rhs: InstancePoolTests.AnyInstance) -> Bool {
            lhs.id == rhs.id
        }
    }
    
    private let pool = InstancePool<String, AnyInstance> {
        .init($0)
    }
}

