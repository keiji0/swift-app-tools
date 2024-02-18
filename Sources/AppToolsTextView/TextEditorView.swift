//
//  TextEditorView.swift
//  
//  
//  Created by keiji0 on 2023/02/15
//  
//

import Foundation
import AppToolsPrimitiveUI
import AppToolsCrossPlatform
import Combine

/// ノードテキストを編集するためのエディター
/// TextStorageをコンテナにレイアウトした状態のテキストビューを提供します
/// 高さはTextStorageによって動的に変わります
open class TextEditorView: View {
    
    public init(_ storage: LimitedContentStorage, _ textContainer: TextContainer) {
        self.container = textContainer
        self.layoutManager = .init()
        self.storage = storage
        super.init()
        layoutManager.addTextContainer(container)
        storage.addLayoutManager(layoutManager)
        subscribe()
    }
    
    /// テキストコンテナ
    public let container: TextContainer
    /// テキストレイアウトマネージャー
    public let layoutManager: LayoutManager
    /// テキストストレージ
    public let storage: LimitedContentStorage
    
    /// テキストの選択領域を返します
    @Published public var selectedRange = NSRange()
    
    /// 文字列表現
    public var string: String {
        storage.string
    }
    
    /// 全選択した状態の領域
    public var allRange: NSRange {
        NSRange(location: 0, length: string.count)
    }
    
    /// 現在行が最後の行にいるか？
    public var isLastLine: Bool {
        let pos = selectedRange.location
        return isLastLine(forGlyphAt: pos)
    }

    /// 現在行が最初の行にいるか？
    public var isFirstLine: Bool {
        let pos = selectedRange.location
        return isFirstLine(forGlyphAt: pos)
    }

    /// 最後にいるか？
    public var isLast: Bool {
        string.count <= selectedRange.location
    }

    /// 最初にいるか？
    public var isFirst: Bool {
        selectedRange.location == 0
    }

    /// 選択を解除する
    public func unselect() {
        if 0 < selectedRange.length {
            selectedRange.length = 0
        }
    }
    
    /// 最初へ移動
    public func gotoFirst() {
        selectedRange = NSMakeRange(0, 0)
    }

    /// 最後へ移動
    public func gotoLast() {
        selectedRange = NSMakeRange(string.count, 0)
    }

    /// 行数を取得
    public var lineCount: Int { layoutManager.lineCount }
    
    /// 最初の行のテキスト領域を取得
    public var firstTextRect: NSRect { layoutManager.firstTextRect }
    
    public func setLocation(toFirstLineX x: CGFloat) {
        selectedRange = .init(
            location: layoutManager.location(toFirstLineX: x),
            length: 0
        )
    }
    
    public func setLocation(toLastLineX x: CGFloat) {
        selectedRange = .init(
            location: layoutManager.location(toLastLineX: x),
            length: 0
        )
    }
    
    public func locationX(location: Int) -> CGFloat {
        layoutManager.locationX(location: location)
    }
    
    /// 現在のカーソルのX座標
    public var locationX: CGFloat {
        locationX(location: selectedRange.location)
    }
    
    /// 指定グリフIndexが最初の行か？
    public func isFirstLine(forGlyphAt: Int) -> Bool {
        layoutManager.isFirstLine(forGlyphAt: forGlyphAt)
    }
    
    /// 指定グリフIndexが最後の行か？
    public func isLastLine(forGlyphAt: Int) -> Bool {
        layoutManager.isLastLine(forGlyphAt: forGlyphAt)
    }
    
    // MARK: - private
    
    private var subscriptions = Set<AnyCancellable>()
    
    private func subscribe() {
        subscriptions.removeAll()
        $isFirstResponder.sink { [unowned self] in
            if $0 == false {
                selectedRange = .init()
            }
        }.store(in: &subscriptions)
    }
}
