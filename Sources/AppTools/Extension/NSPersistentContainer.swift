//
//  NSPersistentContainer.swift
//  
//  
//  Created by keiji0 on 2022/04/09
//  
//

import Foundation
import CoreData

extension NSPersistentContainer {
    
    /// バンドルを指定して生成
    public convenience init(name: String, bundle: Bundle = Bundle.main) {
        self.init(name: name, managedObjectModelName: name, bundle: bundle)
    }
    
    /// データ名とマッピンングモデルが違う場合の指定
    public convenience init(name: String, managedObjectModelName: String, bundle: Bundle = Bundle.main) {
        let model = ManagedObjectModelContainer.shared.model(managedObjectModelName, bundle)
        self.init(name: name, managedObjectModel: model)
    }
    
    /// データをリセットする
    public func dataReset() throws {
        let coordinator = self.persistentStoreCoordinator
        for store in coordinator.persistentStores {
            try coordinator.destroyPersistentStore(
                at: store.url!, ofType: store.type, options: nil)
        }
        try loadPersistent()
    }
    
    /// データのロード
    public func loadPersistent() throws {
        var error: Error? = nil
        loadPersistentStores { description, loadError in
            error = loadError
        }
        if let error = error {
            throw error
        }
    }
}
