//
//  NSTextLayoutManager.swift
//  
//  
//  Created by keiji0 on 2022/12/25
//  
//

import Foundation
import AppToolsCrossPlatform

extension TextLayoutManager {
    /// 先頭のレイアウトフラグメントを取得する
    /// 空の可能性もあるので見つからなかった場合はnilが変える
    public var firstTextLayoutFragment: TextLayoutFragment? {
        var res: TextLayoutFragment?
        enumerateTextLayoutFragments(from: documentRange.location, options: [.ensuresLayout]) { layoutFragment in
            res = layoutFragment
            return false
        }
        return res
    }
    
    /// 末尾のレイアウトフラグメントを取得する
    /// 空の可能性もあるので見つからなかった場合はnilが変える
    public var lastTextLayoutFragment: TextLayoutFragment? {
        var res: TextLayoutFragment?
        enumerateTextLayoutFragments(from: documentRange.endLocation, options: [.reverse, .ensuresLayout]) { layoutFragment in
            res = layoutFragment
            return false
        }
        return res
    }
    
    /// 選択中のテキストレイアウトフラグメントを取得
    public var selectedTextLayoutFragment: TextLayoutFragment? {
        guard let textRange = textSelections.first?.textRanges.first else {
            return nil
        }
        return textLayoutFragment(for: textRange.location)
    }
    
    /// 全てのレイアウトフラグメントを取得
    public var textLayoutFragments: [TextLayoutFragment] {
        var res = [TextLayoutFragment]()
        enumerateTextLayoutFragments(from: documentRange.location, options: [.ensuresLayout]) { layoutFragment in
            res.append(layoutFragment)
            return true
        }
        return res
    }
    
    /// 最初の行フラグメントを取得なければnilが返る
    public var firstTextLineFragment: TextLineFragment? {
        firstTextLayoutFragment?.textLineFragments.first
    }
    
    /// 最後 の行フラグメントを取得なければnilが返る
    public var lastTextLineFragment: TextLineFragment? {
        lastTextLayoutFragment?.textLineFragments.last
    }
    
    /// 指定場所にあるTextLineFragmentを取得
    public func textLineFragment(for location: TextLocation) -> TextLineFragment? {
        if location.isEqual(documentRange.endLocation) {
            return lastTextLineFragment
        }
        guard let layoutFragment = textLayoutFragment(for: location) else {
            return nil
        }
        for kv in layoutFragment.textLineFragmentWithRanges {
            let range = kv.1
            if range.containsWithEnd(location) {
                return kv.0
            }
        }
        return nil
    }
    
    /// TextLineFragmentを取得
    public var textLineFragments: [TextLineFragment] {
        textLayoutFragments.flatMap {
            $0.textLineFragments
        }
    }
    
    /// 選択しているテキスト範囲を取得
    public var textSelection: TextSelection? {
        get { textSelections.first }
        set {
            if let newValue {
                textSelections = [ newValue ]
            } else {
                textSelections.removeAll()
            }
        }
    }
    
    /// 開始位置
    public var firstTextSelection: TextSelection {
        .init(
            documentRange.location,
            affinity: .downstream
        )
    }
    
    /// 選択反映を更新する
    public func updateTextSelection(direction: TextSelectionNavigation.Direction,
                                    destination: TextSelectionNavigation.Destination,
                                    extending: Bool = false) {
        guard let textSelection else {
            return
        }
        self.textSelection = textSelectionNavigation.destinationSelection(
            for: textSelection,
            direction: direction,
            destination: destination,
            extending: extending,
            confined: false
        )
    }
    
    /// 行数を取得
    public var lineCount: Int {
        var count: Int = 0
        enumerateTextLayoutFragments(from: documentRange.location, options: [.ensuresLayout]) { layoutFragment in
            count += layoutFragment.textLineFragments.count
            return true
        }
        return count
    }
    
    /// 指定場所が最初の行か判定
    /// 空だった場合に開始もしくは終了位置が指定された場合は最初の行とみなす
    public func isFirstLine(_ location: TextLocation) -> Bool {
        guard let firstTextLineFragment else {
            return TextRange(location: location).isEqual(to: documentRange)
        }
        // lineFragmentからRangeを取得しているので失敗することはないはず
        let lineTextRange = TextRange(firstTextLineFragment.characterRange, in: textContentManager!)!
        return lineTextRange.containsWithEnd(location)
    }
    
    /// 指定場所が最後の行か判定
    /// 空だった場合に開始もしくは終了位置が指定された場合は最後の行とみなす
    public func isLastLine(_ location: TextLocation) -> Bool {
        // 末尾なら最後の行とする
        if location.isEqual(documentRange.endLocation) {
            return true
        }

        // 最後のフラグメントを取得
        guard let lastTextLayoutFragment else {
            // なければ空行なので範囲外かどうかだけ確認
            return TextRange(location: location).isEqual(to: documentRange)
        }
        
        return lastTextLayoutFragment.lastTextLineRange.containsWithEnd(location)
    }
    
    /// 開始行の指定X座標に移動
    public func setLocation(toFirstLineX x: CGFloat) {
    }
    
    /// 末尾行の指定X座標に移動
    public func setLocation(toLastLineX x: CGFloat) {
    }
    
    /// 現在のカーソルのX座標
    public var locationX: CGFloat {
        0
    }
    
    /// レイアウトしたテキストを取得
    var layoutText: String {
        textLayoutFragments.flatMap {
            $0.textLineFragments.map {
                $0.attributedString.string
            }
        }.joined(separator: "\n")
    }
}
