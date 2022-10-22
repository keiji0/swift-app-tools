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
    
    /// インスタンスのファクトリ関数
    public typealias Factory = (Id) -> Instance
    
    public init(_ factory: @escaping Factory) {
        self.factory = factory
    }
    
    /// インスタンスのハンドル。参照が切れると破棄される
    public final class Handle : Equatable {
        /// インスタンスへの参照
        public let instance: Instance
        
        public static func == (lhs: InstancePool.Handle, rhs: InstancePool.Handle) -> Bool {
            lhs.instance === rhs.instance
        }
        
        fileprivate init(_ pool: Pool, _ id: Id) {
            self.id = id
            self.pool = pool
            self.instance = pool.ref(id)
        }
        
        deinit {
            pool.unref(id)
        }
        
        private let id: Id
        private unowned let pool: Pool
    }
    
    /// インスタンスを参照
    public func ref(_ id: Id) -> Handle {
        .init(self, id)
    }
    
    /// インスタンスを直接参照
    public subscript(index: Id) -> Instance? {
        pool[index]?.instance
    }
    
    /// プールしているインスタンスを解放する
    public func clear() {
        pool.removeAll()
    }
    
    // MARK: - File Private
    
    fileprivate typealias Pool = InstancePool<Id, Instance>
    
    /// インスタンスを参照
    fileprivate func ref(_ id: Id) -> Instance {
        ref(id, factory: self.factory)
    }
    
    fileprivate func ref(_ id: Id, factory: @escaping Factory) -> Instance {
        if let item = pool[id] {
            item.count += 1
            return item.instance
        }
        let item = Item(factory(id))
        pool[id] = item
        return item.instance
    }

    fileprivate func unref(_ id: Id) {
        guard let item = pool[id], 0 < item.count else {
            assert(false)
            return
        }
        item.count -= 1
        if item.count == 0 {
            pool[id] = nil
        }
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
    private let factory: Factory
}

