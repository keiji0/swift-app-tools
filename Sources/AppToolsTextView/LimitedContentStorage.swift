//
//  ContentStorage.swift
//  Untree
//  
//  Created by keiji0 on 2021/10/04
//  
//

import Foundation
import Combine
import AppToolsCrossPlatform

/// 属性の制約をつけたコンテンツストレージ
open class LimitedContentStorage: TextStorage, TextStorageDelegate {
    
    public struct Theme {
        public init(font: Font,
                    textColor: Color,
                    paragraphStyle: ParagraphStyle) {
            self.font = font
            self.textcolor = textColor
            self.paragraphStyle = paragraphStyle
        }
        public let font: Font
        public let textcolor: Color
        public let paragraphStyle: ParagraphStyle
    }

    public let theme: Theme
    
    public enum Event {
        case updated
    }
    
    public var publisher: some Publisher<Event, Never> { subject }
    
    public init(_ theme: Theme) {
        self.theme = theme
        super.init()
        self.delegate = self
    }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public required init?(pasteboardPropertyList propertyList: Any, ofType type: AppToolsCrossPlatform.Pasteboard.PasteboardType) {
        fatalError("init(pasteboardPropertyList:ofType:) has not been implemented")
    }
    
    public override var string: String {
        storage.string
    }
    
    public override func attributes(at location: Int, effectiveRange range: NSRangePointer?) -> [NSAttributedString.Key : Any] {
        storage.attributes(at: location, effectiveRange: range)
    }

    public override func replaceCharacters(in range: NSRange, with str: String) {
        beginEditing()
        storage.replaceCharacters(in: range, with: str)
        edited(.editedCharacters, range: range, changeInLength: str.count - range.length)
        endEditing()
    }
    
    public override func setAttributes(_ attrs: [NSAttributedString.Key : Any]?, range: NSRange) {
        beginEditing()
        storage.setAttributes(attrs, range: range)
        edited(.editedAttributes, range: range, changeInLength: 0)
        endEditing()
    }
    
    // MARK: - NSTextStorageDelegate
    
    public func textStorage(_ textStorage: TextStorage,
                            didProcessEditing editedMask: TextStorageEditActions,
                            range editedRange: NSRange,
                            changeInLength delta: Int) {
        defer { subject.send(.updated) }
        guard editedMask.contains(.editedAttributes) else {
            return
        }
        stripAttributes(editedRange)
    }
    
    // MARK: private
    
    private let storage = NSMutableAttributedString()
    private let subject = PassthroughSubject<Event, Never>()
    
    /// 不要な属性を削除
    private func stripAttributes(_ range: NSRange) {
        // 文字は固定色
        addAttributes([
            .foregroundColor: theme.textcolor,
            .underlineColor: theme.textcolor,
        ], range: range)

        enumerateAttributes(in: range) { attrs, range, _ in
            for (key, val) in attrs {
                switch key {
                case .font:
                    guard let font = val as? Font else { continue }
                    removeAttribute(key, range: range)
                    addAttribute(key, value: theme.font, range: range)
                    if font.fontDescriptor.symbolicTraits.contains(.italic) {
                        applyFontTraits(.italicFontMask, range: range)
                    }
                    if font.fontDescriptor.symbolicTraits.contains(.bold) {
                        applyFontTraits(.boldFontMask, range: range)
                    }

                case .underlineStyle, .underlineColor, .link, .strikethroughStyle, .foregroundColor:
                    break

                default:
                    removeAttribute(key, range: range)
                }
            }
        }
        
        addAttributes([
            .paragraphStyle: theme.paragraphStyle
        ], range: range)
        
        // 絵文字など特別な指定が必要な属性があるので
        fixAttributes(in: range)
    }
}
