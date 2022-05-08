//
//  TextInputStream.swift
//  
//  
//  Created by keiji0 on 2021/09/09
//  
//

import Foundation

/// 文字列をストリーム形式で読み込むクラス
public final class TextInputStream {
    
    public init(_ text: String) {
        self.text = text
        self.here = text.startIndex
    }
    
    public func reset() {
        self.here = text.startIndex
    }
    
    public func readChar() -> Character? {
        guard isProgress else { return nil }
        let char = text[here]
        dropChar()
        return char
    }
    
    public func peekChar() -> Character? {
        guard isProgress else { return nil }
        return text[here]
    }
    
    public func dropChar() {
        guard isProgress else { return }
        here = text.index(after: here)
    }
    
    public func move(_ index: String.Index) {
        here = index
    }
    
    public func move(offsetBy offset: Int) {
        guard isProgress else { return }
        here = text.index(here, offsetBy: offset)
    }
    
    public var isProgress: Bool {
        here < text.endIndex
    }
    
    public var prevCharacter: Character? {
        guard !isStart else { return nil }
        let prevIndex = text.index(before: here)
        guard text.startIndex <= prevIndex else { return nil }
        return text[prevIndex]
    }
    
    public var isEnd: Bool {
        !isProgress
    }
    
    public var isStart: Bool {
        text.startIndex == here
    }
    
    public func afterText() -> String {
        String(text[here..<text.endIndex])
    }
    
    public func skipWhitespace() {
        while let char = peekChar() {
            if char.isWhitespace {
                dropChar()
            } else {
                return
            }
        }
    }
    
    /// ワードを読み込む
    public func readWord() -> String {
        var res = ""
        while let char = peekChar() {
            if char.isWhitespace {
                return res
            } else {
                res.append(char)
                dropChar()
            }
        }
        return res
    }
    
    // MARK: - Private
    
    private let text: String
    private(set) var here: String.Index
}
