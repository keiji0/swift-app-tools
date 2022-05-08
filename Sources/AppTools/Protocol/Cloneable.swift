//
//  Cloneable.swift
//
//
//  Created by keiji0 on 2021/09/04
//
//

import Foundation

/// クローンできる
/// NSCopyingtはAnyObjectでしかcopyできないが、
/// Value型でもAPIを統一するためにcloneすることができるインターフェースを提供
public protocol Cloneable {
    func clone() -> Self
}
