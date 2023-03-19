//
//  Sequence.swift
//  
//  
//  Created by keiji0 on 2023/03/20
//  
//

extension Sequence {
    /// 隣接する要素をペアにしたシーケンス
    public var pairwise: some Sequence<(Element, Element)> {
        AnySequence(zip(self, dropFirst()))
    }
}
