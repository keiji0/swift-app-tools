//
//  Collection.swift
//
//
//  Created by keiji0 on 2021/08/29
//
//

import Foundation

extension Collection {
    public subscript(safe index: Index) -> Element? {
        indices.contains(index) ? self[index] : nil
    }

    public var isAny: Bool {
        !isEmpty
    }

    public func contains<Elements: Collection>(_ elements: Elements) -> Bool
    where
        Elements.Element == Element,
        Element: Equatable
    {
        for element in elements {
            guard contains(element) else {
                return false
            }
        }
        return true
    }
    
    public func unorderEqual<T: Collection>(_ items: T) -> Bool where Self.Element == T.Element, Element: Equatable {
        guard items.count == self.count else {
            return false
        }
        for item in items {
            guard self.contains(item) else {
                return false
            }
        }
        return true
    }
}
