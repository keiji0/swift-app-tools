//
//  NodePathTests.swift
//  
//  
//  Created by keiji0 on 2023/04/08
//  
//

import XCTest
@testable import AppToolsGraph

extension Int: NodeId{}

final class NodePathTests: XCTestCase {
    func test_同じパスは内包されている() {
        XCTAssertTrue([1, 2, 3].containsPath([1, 2, 3]))
    }
    
    func test_パスの内包確認できる() {
        XCTAssertTrue([1, 2].containsPath([1, 2, 3]))
    }
    
    func test_パスが長ければ内包されていない() {
        XCTAssertTrue([1, 2].containsPath([1, 2, 3]))
    }
    
    func test_空パスは無条件に内包しているとみなす() {
        XCTAssertTrue([].containsPath([1, 2, 3]))
        XCTAssertTrue([].containsPath([1, 3]))
        XCTAssertTrue([Int]().containsPath([]))
    }
    
    func test_親パスを取得することができる() {
        XCTAssertEqual([1, 2].parent, [1])
        XCTAssertEqual([1, 2, 3].parent, [1, 2])
    }
    
    func test_空の場合はnilが返る() {
        XCTAssertEqual([1].parent, nil)
        XCTAssertEqual([0].parent, nil)
    }
    
    func test_パスのノードパスを取得でk() {
        XCTAssertEqual([1].parent, nil)
        XCTAssertEqual([0].parent, nil)
    }
    
    func test_親のノードIDを取得できる() {
        XCTAssertEqual([1, 2].parentNodeId, 1)
        XCTAssertEqual([1].parentNodeId, nil)
    }
    
    func test_ソース一覧取得することができる() {
        XCTAssertEqual(
            [1, 2, 3].sources,
            [
                [1],
                [1, 2],
                [1, 2, 3],
            ])
    }
    
    func test_親一覧取得することができる() {
        XCTAssertEqual(
            [1, 2, 3].parents,
            [
                [1],
                [1, 2],
            ])
    }
    
    func test_要素数が多いものが大きい() {
        let a = [1]
        let b = [1, 2]
        XCTAssertTrue(a < b)
    }
    
    func test_同一要素数の場合はNodeId比較する() {
        let a = [1, 2]
        let b = [1, 1]
        XCTAssertTrue(b < a)
    }
    
    func test_内包したパスを除外できる() {
        let path1 = [ 1, 2 ]
        let path2 = [ 1, 2, 3 ]
        let paths = [ path1, path2 ]
        XCTAssertEqual(paths.nonIncludedPaths.count, 1)
        XCTAssertEqual(paths.nonIncludedPaths.first, path1)
    }
    
    func test_内包したパスの正規化ができる後から上書きする() {
        let path1 = [ 1, 2 ]
        let path2 = [ 1, 2, 3]
        let path3 = [ 1 ]
        let paths = [ path1, path2, path3 ]
        XCTAssertEqual(paths.nonIncludedPaths.count, 1)
        XCTAssertEqual(paths.nonIncludedPaths.first, path3)
    }
    
    func test_兄弟同士なら共存() {
        let path1 = [ 1, 2, 3]
        let path2 = [ 1, 2, 4 ]
        let paths = [ path1, path2 ]
        
        XCTAssertEqual(paths.nonIncludedPaths.count, 2)
        XCTAssertTrue(paths.nonIncludedPaths.contains(path1))
        XCTAssertTrue(paths.nonIncludedPaths.contains(path2))
    }
}

