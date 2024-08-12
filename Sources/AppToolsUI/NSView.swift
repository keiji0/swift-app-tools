//
//  NSView.swift
//  AppTools
//  
//  Created by keiji0 on 2024/08/12
//  
//

#if os(macOS)

import AppKit

extension NSView {
    
    /// スーパービューを探す
    /// - Parameter predicate: 一致条件
    public func findSuperView(_ predicate: (NSView)->Bool) -> NSView? {
        guard let superview = superview else {
            return nil
        }
        guard predicate(superview) else {
            return superview.findSuperView(predicate)
        }
        return superview
    }
    
    /// 親をたどり最初に一致した型のインスタンスを返す
    public func findSuperView<SuperView: NSView>(_ type: SuperView.Type) -> SuperView? {
        findSuperView({
            $0 is SuperView
        }) as? SuperView
    }
    
    /// 子を辿っていき最初に見つけたViewを取得
    public func findSubview(_ predicate: (NSView) -> Bool) -> NSView? {
        for subview in subviews {
            if predicate(subview) {
                return subview
            }
            if let subview = subview.findSubview(predicate) {
                return subview
            }
        }
        return nil
    }
    
    public func findSubview<Subview: NSView>(_ type: Subview.Type) -> Subview? {
        findSubview({
            $0 is Subview
        }) as? Subview
    }
    
    /// 背景色を設定する
    /// 主にデバッグ用
    @IBInspectable public var backgroundColor: NSColor? {
        get {
            guard let layer = layer, let backgroundColor = layer.backgroundColor else {return nil}
            return NSColor(cgColor: backgroundColor)
        }
        set {
            wantsLayer = true
            layer?.backgroundColor = newValue?.cgColor
        }
    }
}

#endif
