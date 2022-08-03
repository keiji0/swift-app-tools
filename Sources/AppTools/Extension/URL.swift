//
//  URL.swift
//  
//  
//  Created by keiji0 on 2022/08/03
//  
//

import Foundation

extension URL {
    /// URLのscheme-specific-partを返す
    public var specificPart: String? {
        guard let scheme else {
            return nil
        }
        let str = absoluteString
        return String(str.suffix(str.count - scheme.count - 1))
    }
}
