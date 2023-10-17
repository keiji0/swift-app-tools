//
//  NSObject.swift
//  
//  
//  Created by keiji0 on 2022/03/21
//  
//

import Foundation

extension NSObject {
    public var rawMemoryAddrress: UnsafeMutableRawPointer {
        Unmanaged.passUnretained(self).toOpaque()
    }
}
