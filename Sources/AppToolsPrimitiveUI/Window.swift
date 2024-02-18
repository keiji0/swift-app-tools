//
//  Window.swift
//  
//  
//  Created by keiji0 on 2022/12/24
//  
//

import Foundation
import Combine

/// Window
/// FirstResponderを保持している
open class Window : View {
    
    public override init() {
        super.init()
    }
    
    /// ファーストレスポンダーを保持する
    /// どこも刺していない場合はWindowがファーストレスポンダーになる
    /// Setterはなく、ResponderをFirstにしたいときはResponder.isFirstを使用する
    public internal(set) var firstResponder: Responder {
        get {
            _firstResponder ?? self
        }
        set {
            _firstResponder = newValue
        }
    }
    private weak var _firstResponder: Responder?
}
