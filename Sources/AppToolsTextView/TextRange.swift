//
//  TextRange.swift
//  
//  
//  Created by keiji0 on 2022/12/29
//  
//

import Foundation
import AppToolsCrossPlatform

extension AppToolsCrossPlatform.TextRange {

    public convenience init?(_ nsRange: NSRange, in textContentManager: TextContentManager) {
        guard let start = textContentManager.location(
            textContentManager.documentRange.location,
            offsetBy: nsRange.location
        ) else {
            return nil
        }
        let end = textContentManager.location(start, offsetBy: nsRange.length)
        self.init(location: start, end: end)
    }
    
    public convenience init?(_ nsRange: NSRange, in textContentManager: TextLayoutManager) {
        guard let start = textContentManager.location(
            textContentManager.documentRange.location,
            offsetBy: nsRange.location
        ) else {
            return nil
        }
        let end = textContentManager.location(start, offsetBy: nsRange.length)
        self.init(location: start, end: end)
    }

    public func length(in textContentManager: TextContentManager) -> Int {
        textContentManager.offset(from: location, to: endLocation)
    }
    
    /// 末尾を含めたテキストが範囲に存在するかチェック
    public func containsWithEnd(_ location: some TextLocation) -> Bool {
        if contains(location) {
            return true
        }
        return endLocation.isEqual(location)
    }
}
