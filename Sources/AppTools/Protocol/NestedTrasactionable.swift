//
//  NestedTrasactionable.swift
//  
//  
//  Created by keiji0 on 2022/04/09
//  
//

import Foundation

/// ネストされたトランザクションを提供
/// beginがネストされて呼ばれても、呼び出し元に一致するendが呼ばれるまでcommitされない
public protocol NestedTrasactionable : Trasactionable {
    /// トランザクションのネストレベル
    /// 0から始まるプロパティを提供するだけ
    /// publicになるのは致したがない
    var transactionNestLevel: Int { get set }
    
    /// データをコミットする
    func commit() throws
}

extension NestedTrasactionable {
    
    public func begin() {
        self.transactionNestLevel += 1
    }

    public func end() throws {
        assert(0 < transactionNestLevel)
        self.transactionNestLevel -= 1
        guard isTopLevelTransaction else { return }
        try commit()
    }
    
    // MARK: - Private
    
    private var isTopLevelTransaction: Bool {
        transactionNestLevel == 0
    }
}
