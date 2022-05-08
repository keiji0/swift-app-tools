//
//  ManagedObjectModelContainer.swift
//  
//  
//  Created by keiji0 on 2022/04/09
//  
//

import Foundation
import CoreData

/// NSManagedObjectModelを管理するコンテナ
public final class ManagedObjectModelContainer {
    /// インスタンスへのアクセス
    public static let shared = ManagedObjectModelContainer()
    
    /// モデルを取得
    public func model(_ name: String, _ bundle: Bundle = Bundle.main) -> NSManagedObjectModel {
        let url = bundle.url(forResource: name, withExtension: "momd")!
        return model(url)
    }
    
    // MARK: - Private
    
    private init() {}
    
    /// ManagedObjectModelは複数生成できないようなのでキャッシュする
    private var cacheMap = [URL: NSManagedObjectModel]()
    
    /// ManageObjectを取得
    private func model(_ url: URL) -> NSManagedObjectModel {
        if let model = self.cacheMap[url] {
            return model
        } else {
            let model = NSManagedObjectModel(contentsOf: url)!
            self.cacheMap[url] = model
            return model
        }
    }
}
