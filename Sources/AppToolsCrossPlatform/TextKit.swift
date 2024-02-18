//
//  TextKit.swift
//  
//  
//  Created by keiji0 on 2022/12/25
//  
//

#if os(macOS)
import AppKit
#elseif os(iOS)
import UIKit
#endif

public typealias TextLayoutManager = NSTextLayoutManager
public typealias TextLayoutFragment = NSTextLayoutFragment
public typealias TextContentManager = NSTextContentManager
public typealias TextLineFragment = NSTextLineFragment
public typealias TextSelection = NSTextSelection
public typealias TextRange = NSTextRange
public typealias TextLocation = NSTextLocation
public typealias TextViewportLayoutControllerDelegate = NSTextViewportLayoutControllerDelegate
public typealias TextContainer = NSTextContainer
public typealias TextContentStorage = NSTextContentStorage
public typealias TextStorage = NSTextStorage
public typealias TextStorageDelegate = NSTextStorageDelegate
public typealias TextStorageEditActions = NSTextStorageEditActions
public typealias ParagraphStyle = NSParagraphStyle
public typealias MutableParagraphStyle = NSMutableParagraphStyle
public typealias TextViewportLayoutController = NSTextViewportLayoutController
public typealias LayoutManager = NSLayoutManager
public typealias TextSelectionNavigation = NSTextSelectionNavigation
public typealias LayoutManagerDelegate = NSLayoutManagerDelegate
