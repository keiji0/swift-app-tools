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
        zip(self, dropFirst())
    }
}

extension Sequence where Element : Equatable {
    public func isEqual(_ other: some Sequence<Element>) -> Bool {
        var a = self.makeIterator()
        var b = other.makeIterator()
        while let elem = a.next() {
            guard elem == b.next() else {
                return false
            }
        }
        return b.next() == nil ? true : false
    }
}
