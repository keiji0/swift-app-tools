//
//  Pair.swift
//  
//  
//  Created by keiji0 on 2023/04/02
//  
//

public struct Pair<First, Second> {
    public let first: First
    public let second: Second
    public init(_ first: First, _ second: Second) {
        self.first = first
        self.second = second
    }
}

extension Pair : Equatable where First: Equatable, Second: Equatable { }
extension Pair : Hashable where First: Hashable, Second: Hashable { }
extension Pair : Comparable where First: Comparable, Second: Comparable {
    public static func < (lhs: Self, rhs: Self) -> Bool {
        lhs.first < rhs.first && lhs.second < rhs.second
    }
}

extension Pair : Codable where First: Codable, Second: Codable {
}
