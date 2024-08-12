//
//  NSButton.swift
//  AppTools
//  
//  Created by keiji0 on 2024/08/12
//  
//

#if os(macOS)

import AppKit

private var key = 0

@objc private class ClosureSleeve: NSObject {
    let closure:()->()
    
    init(_ closure: @escaping()->()) {
        self.closure = closure
    }
    
    @objc func invoke(_ sender: Any?) {
        closure()
    }
}

extension NSButton {
    public func addAction(_ closure: @escaping()->()) {
        let sleeve = ClosureSleeve(closure)
        objc_setAssociatedObject(self, &key, sleeve, .OBJC_ASSOCIATION_RETAIN)
        target = sleeve
        action = #selector(ClosureSleeve.invoke(_:))
    }
}

#endif
