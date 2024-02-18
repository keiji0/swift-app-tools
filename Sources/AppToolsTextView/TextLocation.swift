//
//  TextLocation.swift
//  
//  
//  Created by keiji0 on 2022/12/29
//  
//

import Foundation
import AppToolsCrossPlatform

extension TextLocation {
    public func isEqual(_ location: some TextLocation) -> Bool {
        TextRange(location: self) == TextRange(location: location)
    }
}
