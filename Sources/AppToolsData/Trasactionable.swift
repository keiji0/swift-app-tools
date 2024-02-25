//
//  Trasactionable.swift
//  
//  
//  Created by keiji0 on 2022/04/09
//  
//

import Foundation

/// トランザクションを提供することができるプロトコル
public protocol Trasactionable : AnyObject {
    /// トランザクションを開始。例外が発生するとロールバックされる
    func begin(_ block: () throws -> Void) throws
}

extension Trasactionable {
    /// トランザクション開始(返り値あり)
    public func begin<T>(_ block: () throws -> T) throws -> T {
        var res: T?
        try begin {
            res = try block()
        }
        return res!
    }
}

public protocol TransactionIdentifiable: Identifiable {
    init()
}

public protocol IdentifiedTrasactionable: Trasactionable {
    associatedtype TransactionId: TransactionIdentifiable
    func begin(_ transactionId: TransactionId, _ block: () throws -> Void) throws
}

extension IdentifiedTrasactionable {
    func begin(_ block: () throws -> Void) throws {
        try begin(.init(), block)
    }
    
    func begin<T>(_ transactionId: TransactionId, _ block: () throws -> T) throws -> T {
        var res: T?
        try begin(transactionId) {
            res = try block()
        }
        return res!
    }
}
