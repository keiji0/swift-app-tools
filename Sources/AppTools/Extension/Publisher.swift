//
//  Publisher.swift
//  
//  
//  Created by keiji0 on 2022/07/25
//  
//

import Combine

extension Publisher {
    /// Publisherから発生したイベント一覧を取得
    /// - Parameter block: イベントを発生させるために手続き
    /// - Returns: 発生したイベント一覧
    /// テストなどに使う想定
    public func receiveEvents(_ block: () -> Void) -> [Output] where Failure == Never {
        var events = [Output]()
        let canceler = sink {
            events.append($0)
        }
        defer { canceler.cancel() }
        block()
        return events
    }
    
    /// Publisherから発生した最後のイベント
    /// - Parameter block: イベントを発生させるために手続き
    /// - Returns: 発生したイベント一覧
    /// テストなどに使う想定
    public func receiveLastEvent(_ block: () -> Void) -> Output where Failure == Never {
        receiveEvents(block).last!
    }
}
