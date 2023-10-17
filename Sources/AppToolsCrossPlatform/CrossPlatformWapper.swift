//
//  CrossPlatformWapper.swift
//  
//  
//  Created by keiji0 on 2022/05/08
//  
//

import Foundation

// Frameworks
#if os(OSX)
    import Cocoa
#else
    import UIKit
#endif

// UIKit/Cocoa Classes
#if os(OSX)
    public typealias CKView = NSView
    public typealias CKFont = NSFont
    public typealias CKColor = NSColor
    public typealias CKImage = NSImage
    public typealias CKBezierPath = NSBezierPath
    public typealias CKViewController = NSViewController
#else
    public typealias CKView = UIView
    public typealias CKFont = UIFont
    public typealias CKColor = UIColor
    public typealias CKImage = UIImage
    public typealias CKBezierPath = UIBezierPath
    public typealias CKViewController = UIViewController
#endif
