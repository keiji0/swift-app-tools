//
//  TextSelection.swift
//  
//  
//  Created by keiji0 on 2022/12/27
//  
//

import Foundation
import AppToolsCrossPlatform

extension TextSelection {
    /// TextSelection同士で差分があるか判定
    func isDiff(_ b: TextSelection) -> Bool {
        textRanges != b.textRanges
        || granularity != b.granularity
        || affinity != b.affinity
        || isTransient != b.isTransient
        || anchorPositionOffset != b.anchorPositionOffset
        || isLogical != b.isLogical
    }
}
