//
//  NSRange.swift
//  
//  
//  Created by keiji0 on 2022/12/29
//  
//

import Foundation
import AppToolsCrossPlatform

extension NSRange {

    static let notFound = NSRange(location: NSNotFound, length: 0)

    var isEmpty: Bool {
        length == 0
    }

    init(_ textRange: AppToolsCrossPlatform.TextRange, in textContentManager: TextContentManager) {
        let offset = textContentManager.offset(
            from: textContentManager.documentRange.location,
            to: textRange.location
        )
        let length = textContentManager.offset(
            from: textRange.location,
            to: textRange.endLocation
        )
        self.init(location: offset, length: length)
    }

    init(_ textLocation: some TextLocation, in textContentManager: TextContentManager) {
        let offset = textContentManager.offset(
            from: textContentManager.documentRange.location,
            to: textLocation
        )
        self.init(location: offset, length: 0)
    }
}
