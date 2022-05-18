//
//  UndoQueueTests.swift
//  
//  
//  Created by keiji0 on 2022/05/17
//  
//

import XCTest
@testable import AppTools

final class UndoQueueTests: XCTestCase {
    
    // MARK: - Undo
    
    func test_最初はUndoできない() {
        XCTAssertFalse(undoQueue.canUndo)
    }
    
    func test_Undoを登録できる() {
        undoQueue.register("a")
        XCTAssertTrue(undoQueue.canUndo)
    }
    
    func test_Undoの結果を確認() {
        undoQueue.register("a")
        XCTAssertEqual(undoQueue.undo(), "a")
    }
    
    func test_Undo実行後空になるとUndoできなくなる() {
        undoQueue.register("a")
        _ = undoQueue.undo()
        XCTAssertFalse(undoQueue.canUndo)
    }
    
    func test_最初はRedoできない() {
        XCTAssertFalse(undoQueue.canRedo)
    }
    
    func test_UndoしないとRedoできない() {
        undoQueue.register("a")
        XCTAssertFalse(undoQueue.canRedo)
        
        _ = undoQueue.undo()
        XCTAssertEqual(undoQueue.redo(), "a")
        XCTAssertFalse(undoQueue.canRedo)
    }
    
    func test_色々試す() {
        undoQueue.register("a")
        undoQueue.register("b")
        undoQueue.register("c")
        
        XCTAssertEqual(undoQueue.undo(), "c")
        XCTAssertEqual(undoQueue.undo(), "b")
        XCTAssertEqual(undoQueue.undo(), "a")
        
        XCTAssertEqual(undoQueue.redo(), "a")
        XCTAssertEqual(undoQueue.redo(), "b")
        XCTAssertEqual(undoQueue.redo(), "c")
        
        XCTAssertEqual(undoQueue.undo(), "c")
        XCTAssertEqual(undoQueue.undo(), "b")
        XCTAssertEqual(undoQueue.undo(), "a")
    }
    
    // MARK: - Private
    
    private let undoQueue = UndoStack<String>()
}
