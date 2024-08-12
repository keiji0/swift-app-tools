//
//  NSEventModifierFlags.swift
//  AppTools
//  
//  Created by keiji0 on 2024/08/12
//  
//

#if os(macOS)

import AppKit
import AppToolsCrossPlatform

extension NSEvent.ModifierFlags {
    var keyModifierFlags: KeyModifierFlags {
        var flags = KeyModifierFlags()
        if contains(.capsLock) { flags.insert(.capsLock) }
        if contains(.shift) { flags.insert(.shift) }
        if contains(.control) { flags.insert(.control) }
        if contains(.option) { flags.insert(.option) }
        if contains(.command) { flags.insert(.command) }
        return flags
    }
}

#endif
