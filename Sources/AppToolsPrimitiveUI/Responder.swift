//
//  Responder.swift
//  
//  
//  Created by keiji0 on 2022/12/24
//  
//

import Foundation
import Combine

open class Responder: NSObject {
    
    /// 所属しているWindow
    public var window: Window? {
        lastResponder as? Window
    }
    
    /// ファーストレスポンダーの設定
    @FirstResponderValue
    public var isFirstResponder
    
    /// 次のレスポンダーを返す
    /// 継承側がオーバーライドします
    public var nextResponder: Responder? { nil }
    
    /// 最後のレスポンダーを返す
    /// nextResponderを辿って最後のものを返します
    public var lastResponder: Responder? {
        guard let nextResponder else {
            return self
        }
        return nextResponder.lastResponder
    }
    
    /// レスポンスチェーンを返す
    public var responseChain: [Responder] {
        guard let nextResponder else {
            return [self]
        }
        return [self] + nextResponder.responseChain
    }
    
    /// 同一性の確認
    public static func == (lhs: Responder, rhs: Responder) -> Bool {
        lhs === rhs
    }
    
    @propertyWrapper
    public struct FirstResponderValue {
        
        public init() { }
        
        fileprivate let subject = PassthroughSubject<Bool, Never>()
        public var projectedValue: some Publisher<Bool, Never> { subject }
        
        public var wrappedValue: Bool {
            get { fatalError() }
            set { fatalError() }
        }
        
        public static subscript(
            _enclosingInstance instance: Responder,
            wrapped wrappedKeyPath: ReferenceWritableKeyPath<Responder, Bool>,
            storage storageKeyPath: ReferenceWritableKeyPath<Responder, Self>
        ) -> Bool {
            get {
                guard let window = instance.window else {
                    return false
                }
                return window.firstResponder == instance
            }
            set {
                guard let window = instance.window,
                      instance.isFirstResponder != newValue else {
                    return
                }
                if newValue {
                    // 自身がFirstResponderではなくFirstResponderになろうとしているケース
                    let oldFirstResponder = window.firstResponder
                    window.firstResponder = instance
                    oldFirstResponder[keyPath: storageKeyPath].subject.send(false)
                    instance[keyPath: storageKeyPath].subject.send(true)
                } else {
                    window.firstResponder = window
                    // 自身を解除してWindowをFirstResponderに戻す
                    instance[keyPath: storageKeyPath].subject.send(false)
                    // Windowも送信
                    window[keyPath: storageKeyPath].subject.send(true)
                }
            }
        }
    }
}
