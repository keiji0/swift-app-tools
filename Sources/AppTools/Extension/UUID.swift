//
//  UUID.swift
//  
//  
//  Created by keiji0 on 2022/04/09
//  
//

import Foundation

extension UUID {
    /// null UUIDを定義
    public static let null = UUID(uuid: (
        0, 0, 0, 0,
        0, 0, 0, 0,
        0, 0, 0, 0,
        0, 0, 0, 0
        ))
    
    /// full UUIDを定義
    public static let full = UUID(uuid: (
        255, 255, 255, 255,
        255, 255, 255, 255,
        255, 255, 255, 255,
        255, 255, 255, 255
    ))
}
