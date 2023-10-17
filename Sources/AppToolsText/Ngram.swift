//
//  Ngram.swift
//  
//  
//  Created by keiji0 on 2021/09/26
//  
//

import Foundation

public struct Ngram {
    
    public init(_ num: Int) {
        assert(0 < num)
        self.num = num
    }
    
    public func tokens(text: String) -> [[String]] {
        text.components(separatedBy: .whitespacesAndNewlines).filter({ !$0.isEmpty }).map {
            tokens(word: $0)
        }
    }
    
    public func token(_ text: String) -> [String] {
        tokens(word: text)
    }
    
    // MARK: - Private
    
    private let num: Int
    
    private func tokens(word text: String) -> [String] {
        var res = [String]()
        var here = text.startIndex
        while here < text.endIndex {
            let token = String(text[here..<text.endIndex].prefix(num))
            if token.count < num {
                if here == text.startIndex {
                    res.append(token)
                }
                break
            }
            res.append(token)
            here = text.index(after: here)
        }
        return res
    }
}
