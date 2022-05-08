//
//  InstancePool.swift
//  
//  
//  Created by keiji0 on 2022/02/20
//  
//

import Foundation

/// インスタンスプール
/// 参照がなくなるまで同一のインスタンスを使い回すケースに使用する
public final class InstancePool<Id: Hashable, Instance: AnyObject> {
    
    public typealias Factory = (Id) -> Instance
    
    public init(factory: Factory? = nil) {
        self.factory = factory
    }
    
    /// Idが存在している場合にオブジェクトを取得
    /// 参照は保持されないので一時的に使用したい場合に使う
    public func get(_ id: Id) -> Instance? {
        pool[id]?.instance
    }
    
    /// Idが存在しているか？
    public func isExist(_ id: Id) -> Bool {
        pool[id] != nil
    }

    public func ref(_ id: Id) -> Instance {
        ref(id, factory: self.factory!)
    }
    
    public func ref(_ id: Id, factory: @escaping Factory) -> Instance {
        if let item = pool[id] {
            item.count += 1
            return item.instance
        }
        let item = Item(factory(id))
        pool[id] = item
        return item.instance
    }

    public func unref(_ id: Id) {
        guard let item = pool[id], 0 < item.count else {
            assert(false)
            return
        }
        item.count -= 1
        if item.count == 0 {
            pool[id] = nil
        }
    }
    
    public func clear() {
        pool.removeAll()
    }
    
    // MARK: - Private
    
    private class Item {
        var count: Int = 1
        let instance: Instance
        init(_ ins: Instance){
            self.instance = ins
        }
    }
    private var pool = [Id: Item]()
    private var factory: Factory?
}

