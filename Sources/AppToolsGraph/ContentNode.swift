//
//  ContentNode.swift
//
//  
//  Created by keiji0 on 2024/03/19
//  
//

public protocol ContentNode: Node {
    associatedtype Content: NodeContent
    var content: Content { get }
}

public protocol NodeContent {
}

extension String: NodeContent {
}
