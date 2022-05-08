//
//  Comparable.swift
//  
//  
//  Created by keiji0 on 2021/10/17
//  
//

import Foundation

extension Comparable {
    
    public func clamp<T: Comparable>(_ lower: T, _ upper: T) -> T {
        return min(max(self as! T, lower), upper)
    }
    
    public func clamp<T: Comparable>(lower: T, _ upper: T) -> T {
        return min(max(self as! T, lower), upper)
    }
}
