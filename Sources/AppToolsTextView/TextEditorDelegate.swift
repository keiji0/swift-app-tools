//
//  TextEditorDelegate.swift
//  
//  
//  Created by keiji0 on 2022/03/19
//  
//

import Foundation

/// テキストエディタデリゲート
///
/// テキストエディタで発生するイベントの代理で処理するためのプロトコル
/// 必要なものをピックアップして実装する。
/// また全ての処理はBoolを返しOverrideした際にはtrueを返す
public protocol TextEditorDelegate: AnyObject {
    
    func deleteBackward(_ modifierFlags: KeyModifierFlags) -> Bool
    
    func insertTab(_ modifierFlags: KeyModifierFlags) -> Bool
    func insertBacktab(_ modifierFlags: KeyModifierFlags) -> Bool
    func insertNewline(_ modifierFlags: KeyModifierFlags) -> Bool
    
    func moveToRightEndOfLine(_ modifierFlags: KeyModifierFlags) -> Bool
    func moveToLeftEndOfLine(_ modifierFlags: KeyModifierFlags) -> Bool
    func moveUp(_ modifierFlags: KeyModifierFlags) -> Bool
    func moveDown(_ modifierFlags: KeyModifierFlags) -> Bool
    func moveRight(_ modifierFlags: KeyModifierFlags) -> Bool
    func moveLeft(_ modifierFlags: KeyModifierFlags) -> Bool
    func moveForward(_ modifierFlags: KeyModifierFlags) -> Bool
    func moveBackward(_ modifierFlags: KeyModifierFlags) -> Bool
    
    func cancelOperation(_ modifierFlags: KeyModifierFlags) -> Bool
    
    func moveUpAndModifySelection(_ modifierFlags: KeyModifierFlags) -> Bool
    func moveDownAndModifySelection(_ modifierFlags: KeyModifierFlags) -> Bool
}

public extension TextEditorDelegate {
    func deleteBackward(_ modifierFlags: KeyModifierFlags) -> Bool { false }
    
    func insertTab(_ modifierFlags: KeyModifierFlags) -> Bool { false }
    func insertBacktab(_ modifierFlags: KeyModifierFlags) -> Bool { false }
    func insertNewline(_ modifierFlags: KeyModifierFlags) -> Bool { false }
    
    func moveToRightEndOfLine(_ modifierFlags: KeyModifierFlags) -> Bool { false }
    func moveToLeftEndOfLine(_ modifierFlags: KeyModifierFlags) -> Bool { false }
    func moveUp(_ modifierFlags: KeyModifierFlags) -> Bool { false }
    func moveDown(_ modifierFlags: KeyModifierFlags) -> Bool { false }
    func moveRight(_ modifierFlags: KeyModifierFlags) -> Bool { false }
    func moveForward(_ modifierFlags: KeyModifierFlags) -> Bool { false }
    func moveLeft(_ modifierFlags: KeyModifierFlags) -> Bool { false }
    func moveBackward(_ modifierFlags: KeyModifierFlags) -> Bool { false }
    
    func cancelOperation(_ modifierFlags: KeyModifierFlags) -> Bool { false }
    
    func moveUpAndModifySelection(_ modifierFlags: KeyModifierFlags) -> Bool { false }
    func moveDownAndModifySelection(_ modifierFlags: KeyModifierFlags) -> Bool { false }
}
