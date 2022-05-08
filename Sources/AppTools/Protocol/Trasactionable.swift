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
    /// トランザクションの開始
    func begin() 
    /// トランザクションの終了
    func end() throws
}

extension Trasactionable {
    /// トランザクションブロック
    public func begin(_ block: () -> Void) throws {
        begin()
        block()
        try end()
    }

    /// トランザクションブロック値を返す
    public func begin<T>(_ block: () -> T) throws -> T {
        begin()
        let res = block()
        try end()
        return res
    }
}

public protocol TransactionParent: Trasactionable {
    var transaction: Trasactionable { get }
}

extension TransactionParent {
    public func begin() {
        transaction.begin()
    }
    public func end() throws {
        try  transaction.end()
    }
}
