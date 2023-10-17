//
//  ReferenceArray.swift
//
//
//  Created by keiji0 on 2021/09/05
//
//

import Foundation

public final class ReferenceArray<Element>: RangeReplaceableCollection {
    public typealias Index = Int
    private var collection = [Element]()
    
    public init() {
    }

    public init(_ elements: Element ...) {
        collection = .init(elements)
    }

    public init<T: Collection>(_ collection: T)
    where T.Element == Element {
        for v in collection {
            self.collection.append(v)
        }
    }

    public var startIndex: Index {
        collection.startIndex
    }

    public var endIndex: Index {
        collection.endIndex
    }

    public func index(after i: Index) -> Index {
        collection.index(after: i)
    }

    public subscript(position: Index) -> Element {
        collection[position]
    }

    public func replaceSubrange<C>(_ subrange: Range<Index>, with newElements: C)
    where C: Collection, Element == C.Element {
        collection.replaceSubrange(subrange, with: newElements)
    }

    public func removeSubrange(_ bounds: Range<Index>) {
        collection.removeSubrange(bounds)
    }

    public var last: Element? {
        self[safe: count - 1]
    }

    public func swapAt(_ a: Index, _ b: Index) {
        collection.swapAt(a, b)
    }

    public func sort(by areInIncreasingOrder: (Element, Element) -> Bool) {
        collection.sort(by: areInIncreasingOrder)
    }
}

extension ReferenceArray: Equatable where Element: Equatable {
    public static func == (lhs: ReferenceArray<Element>, rhs: ReferenceArray<Element>) -> Bool {
        lhs.collection == rhs.collection
    }
}
