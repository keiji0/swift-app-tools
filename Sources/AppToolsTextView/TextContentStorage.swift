//
//  TextContentStorage.swift
//  
//  
//  Created by keiji0 on 2022/12/30
//  
//

import Foundation
import AppToolsCrossPlatform

extension TextContentStorage {
    /// レイアウトに行を埋める
    /// - Parameter chractor: 埋めたい文字
    public func paddingLine(_ character: Character = "0") {
        guard let textLayoutManager = textLayoutManagers.first else {
            return
        }
        guard let textStorage else {
            return
        }
        // 行がなければ追加しておく
        textStorage.mutableString.append(.init(character))
        
        // 最後の行が追加されるまで埋めていく
        let lineCount = textLayoutManager.lineCount
        while lineCount == textLayoutManager.lineCount {
            textStorage.mutableString.append(.init(character))
        }
        
        let removeRange = NSRange(location: textStorage.mutableString.length - 1, length: 1)
        textStorage.mutableString.deleteCharacters(in: removeRange)
    }
}
