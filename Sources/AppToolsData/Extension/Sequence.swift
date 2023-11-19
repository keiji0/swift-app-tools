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
    
    /// シーケンス同士を繋いだシーケンスを取得
    /// 要素は同じだが別の型のシーケンスを繋げれることができる
    public func spliced(_ seq: some Sequence<Element>) -> some Sequence<Element> {
        SplicedSequence(self, seq)
    }
    
    /// シーケンスを配列に変更
    public var array: [Element] {
        .init(self)
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

private struct SplicedSequence<S1: Sequence, S2: Sequence> : Sequence, IteratorProtocol where S1.Element == S2.Element {
    private var itr1: S1.Iterator
    private var itr2: S2.Iterator
    
    init(_ s1: S1, _ s2: S2) {
        itr1 = s1.makeIterator()
        itr2 = s2.makeIterator()
    }
    
    mutating func next() -> S1.Element? {
        itr1.next() ?? itr2.next()
    }
}
