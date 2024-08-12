//
//  NSResponder.swift
//  AppTools
//  
//  Created by keiji0 on 2024/08/12
//  
//

#if os(macOS)

import AppKit

extension NSResponder {
    public var isFirstResponder: Bool {
        NSApp.windows.contains {
            $0.firstResponder === self
        }
    }
    
    @discardableResult
    public func setFirstResponder(_ isFirstResponder: Bool = true) -> Bool {
        guard let view = self as? NSView else {
            return false
        }
        if isFirstResponder {
            view.window?.makeFirstResponder(self)
            return true
        } else if view.window?.firstResponder === self {
            // 自身じゃないと解除はしない
            view.window?.makeFirstResponder(nil)
            return true
        } else {
            return false
        }
    }
}

#endif
