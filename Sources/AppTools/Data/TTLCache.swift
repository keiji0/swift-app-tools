//
//  TTLCache.swift
//  
//  
//  Created by keiji0 on 2023/01/15
//  
//

import Foundation

/// 有効期限つきのキャッシュ
/// 有効期限が切れたとしても参照が残っていれば残す
/// 参照が追加されるたびに有効期限はリセットされる
public class TTLCache<Key, Object> where Key : Hashable,  Object : AnyObject {
    
    // MARK: - Constructor
    
    /// 有効期限を指定して生成する
    /// - Parameter ttl: 有効期限
    public init(_ ttl: TimeInterval = 3.0) {
        self.ttl = ttl
    }
    
    // MARK: - Members
    
    private let ttl: TimeInterval
    private var ttlStorage = [Key: Reference]()
    private var weakStorage = [Key: WeakObject<Object>]()
    private var purgedAt: Date = .init()
    
    // MARK: - Public Methods
    
    /// キャッシュされた値を取得
    /// - Parameter key: キー
    /// - Returns: キャッシュされたものがあればオブジェクトを返す
    public func get(_ key: Key) -> Object? {
        if let container = weakStorage[key],
           let value = container.value {
            ttlStorage[key] = .init(value)
            return value
        }
        return nil
    }
    
    /// キャッシュを設定する
    /// - Parameters:
    ///   - key: キー
    ///   - value: キャッシュしたいオブジェクト
    public func set(_ key: Key, _ object: Object) {
        purge()
        weakStorage[key] = .init(object)
        ttlStorage[key] = .init(object)
    }
    
    // MARK: - Private
    
    func purge() {
        guard shouldPurge else {
            return
        }
        let now = Date()
        for elem in ttlStorage {
            if ttl < elem.value.referenceAt.distance(to: now) {
                ttlStorage[elem.key] = nil
            }
        }
        purgedAt = .init()
    }
    
    private var shouldPurge: Bool {
        ttl < purgedAt.distance(to: .init())
    }
    
    private struct Reference {
        init(_ object: Object) {
            self.object = object
        }
        let referenceAt: Date = .init()
        let object: Object
    }
}
