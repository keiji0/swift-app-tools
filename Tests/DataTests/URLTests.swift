//
//  URLTests.swift
//  
//  
//  Created by keiji0 on 2022/08/03
//  
//

import Foundation
import XCTest
@testable import AppToolsData

final class URLTests: XCTestCase {
    func test_URLのspecificPartが取得できる() {
        XCTAssertEqual(URL(string: "foo:body")!.specificPart, "body")
        XCTAssertEqual(URL(string: ":body")!.specificPart, "body")
    }
    
    func test_URLのspecificPartが空でも問題ない() {
        XCTAssertEqual(URL(string: "foo:")!.specificPart!, "")
    }
    
    func test_そもそもスキームがない場合は取得できない() {
        XCTAssertNil(URL(string: "body")!.specificPart)
    }
}
