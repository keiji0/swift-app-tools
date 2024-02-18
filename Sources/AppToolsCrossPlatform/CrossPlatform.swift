//
//  CrossPlatform.swift
//
//  
//  Created by keiji0 on 2024/01/03
//  
//

#if os(macOS)
@_exported import AppKit
#elseif os(iOS)
@_exported import UIKit
#endif
