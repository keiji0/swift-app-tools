//
//  LayoutManager.swift
//  
//  
//  Created by keiji0 on 2023/01/04
//  
//

import Foundation
import AppToolsCrossPlatform

extension LayoutManager {
    /// 行数を取得
    var lineCount: Int {
        var numberOfLines = 0
        lineFragmentEach { _, _ in
            numberOfLines += 1
        }
        if string.last == "\n" {
            numberOfLines += 1
        }
        return numberOfLines
    }
    
    var firstTextRect: NSRect {
        guard 0 < numberOfGlyphs else {
            return NSRect()
        }
        var lineRange = NSRange(location: NSNotFound, length: 0)
        lineFragmentRect(forGlyphAt: 0, effectiveRange: &lineRange)
        
        // 末尾に改行があると表示可能領域が幅として認識されるので改行は除外しておく
        if 0 < lineRange.length && string[Range(lineRange, in: string)!].last! == "\n" {
            lineRange.length -= 1
        }
        return boundingRect(forGlyphRange: lineRange, in: textContainer!)
    }
    
    func location(toFirstLineX x: CGFloat) -> Int {
        let ghyphRate = UnsafeMutablePointer<CGFloat>.allocate(capacity: 1)
        let idx = glyphIndex(
            for: CGPoint(x: x, y: 0),
               in: textContainer!,
               fractionOfDistanceThroughGlyph: ghyphRate)
        return idx + (0.5 < ghyphRate.pointee ? 1 : 0)
    }
    
    func location(toLastLineX x: CGFloat) -> Int {
        let rect = usedRect(for: textContainer!)
        let ghyphRate = UnsafeMutablePointer<CGFloat>.allocate(capacity: 1)
        let idx = glyphIndex(
            for: CGPoint(x: x, y: rect.size.height-1),
               in: textContainer!,
               fractionOfDistanceThroughGlyph: ghyphRate
        )
        return idx + (0.5 < ghyphRate.pointee ? 1 : 0)
    }
    
    func locationX(location: Int) -> CGFloat {
        if location < numberOfGlyphs {
            return self.location(forGlyphAt: location).x
        } else {
            let rect = boundingRect(forGlyphRange: NSRange(location: location-1, length: 1), in: textContainer!)
            return rect.origin.x + rect.size.width
        }
    }
    
    /// 指定グリフIndexが最初の行か？
    func isFirstLine(forGlyphAt: Int) -> Bool {
        let numberOfGlyphs = numberOfGlyphs
        
        if numberOfGlyphs == 0 { return true }
        if numberOfGlyphs == forGlyphAt && string.last == "\n" { return false }
        
        let pos = max(0, min(forGlyphAt, numberOfGlyphs - 1))
        let rect = lineFragmentRect(forGlyphAt: pos, effectiveRange: nil)
        return rect.origin.y == 0
    }
    
    /// 指定グリフIndexが最後の行か？
    func isLastLine(forGlyphAt: Int) -> Bool {
        let numberOfGlyphs = numberOfGlyphs
        
        if numberOfGlyphs <= forGlyphAt { return true }
        if numberOfGlyphs == 0 { return true }

        let lastRect = lineFragmentRect(forGlyphAt: numberOfGlyphs-1, effectiveRange: nil)
        let rect = lineFragmentRect(forGlyphAt: forGlyphAt, effectiveRange: nil)
        
        return lastRect.origin == rect.origin
            && string.last != "\n"
    }
    
    // MARK: - Private
    
    private var textContainer: TextContainer? {
        textContainers.first
    }
    
    private var string: String {
        textStorage?.string ?? ""
    }
    
    private func lineFragmentEach(_ block: (NSRect, NSRange)->Void) {
        var index = 0
        var lineRange = NSRange(location: NSNotFound, length: 0)

        while index < numberOfGlyphs {
            let rect = lineFragmentRect(forGlyphAt: index, effectiveRange: &lineRange)
            block(rect, lineRange)
            index = NSMaxRange(lineRange)
        }
    }
}
