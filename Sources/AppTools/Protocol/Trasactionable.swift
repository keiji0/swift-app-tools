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

public protocol TransactionParent: Trasactionable {
    var transaction: Trasactionable { get }
}

extension TransactionParent {
    public func begin(_ block: () throws -> Void) throws {
        try transaction.begin {
            try block()
        }
    }
}
