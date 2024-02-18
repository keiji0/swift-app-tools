//
//  TextLayoutFragment.swift
//  
//  
//  Created by keiji0 on 2022/12/30
//  
//

import AppToolsCrossPlatform

extension TextLayoutFragment {
    /// テキスト行の範囲一覧を取得
    /// textLineFragmentが返すRangeはローカルRangeなのでテキストレイアウトが原点の範囲を返す
    public var textLineRanges: [TextRange] {
        textLineFragmentWithRanges.map {
            $0.1
        }
    }
    
    /// テキスト行と範囲一覧を取得
    public var textLineFragmentWithRanges: [(TextLineFragment, TextRange)] {
        guard let textLayoutManager else {
            return []
        }
        let textLineFragments = self.textLineFragments
        var res = [(TextLineFragment, TextRange)]()
        res.reserveCapacity(textLineFragments.count)
        var location = rangeInElement.location
        for lineFragments in textLineFragments {
            let characterRange = lineFragments.characterRange
            let endLocation = textLayoutManager.location(location, offsetBy: characterRange.length)!
            let range = TextRange(location: location, end: endLocation)!
            location = endLocation
            res.append((lineFragments, range))
        }
        return res
    }
    
    /// 最後の行の範囲を取得
    public var lastTextLineRange: TextRange {
        textLineRanges.last ?? rangeInElement
    }
}
