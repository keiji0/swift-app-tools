//
//  View.swift
//  
//  
//  Created by keiji0 on 2022/12/24
//  
//

import Foundation

/// Viewクラス
/// ViewはResponderであり階層構造になっている
/// superViewは参照を持たないため 、子は派生クラスで所有します。
open class View : Responder {
    public override init() {
        super.init()
    }
    
    /// 親View
    /// ViewをコントロールしているViewが設定する
    public weak var superview: View? {
        willSet(newSuperView) {
            precondition(!(self is Window))
            precondition(newSuperView !== self)
        }
    }
    
    /// 次のレスポンダーを返す、Viewの場合は親Viewになる
    public override var nextResponder: Responder? {
        superview
    }
    
    /// SuperViewから除外する
    public func removeFromSuperview() {
        superview = nil
    }
    
    /// サブビューを追加する
    /// - Parameter subview: 追加したいサブビュー
    public func addSubview(_ subview: View) {
        subview.superview = self
    }
    
    /// スーパービューを探す
    /// - Parameter predicate: 一致条件
    public func findSuperview(_ predicate: (View) -> Bool) -> View? {
        guard let superview = superview else {
            return nil
        }
        guard predicate(superview) else {
            return superview.findSuperview(predicate)
        }
        return superview
    }
    
    /// 親をたどり最初に一致した型のインスタンスを返す
    public func findSuperview<Superview: View>(_ type: Superview.Type) -> Superview? {
        findSuperview({
            $0 is Superview
        }) as? Superview
    }
}
