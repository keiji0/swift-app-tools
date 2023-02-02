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
    public convenience init(name: String, bundle: Bundle = Bundle.main, inMemory: Bool = false) {
        self.init(name: name, managedObjectModelName: name, bundle: bundle, inMemory: inMemory)
    }
    
    /// データ名とマッピンングモデルが違う場合の指定
    public convenience init(name: String, managedObjectModelName: String, bundle: Bundle = Bundle.main, inMemory: Bool = false) {
        let model = ManagedObjectModelContainer.shared.model(managedObjectModelName, bundle)
        self.init(name: name, managedObjectModel: model)
        if inMemory {
            persistentStoreDescriptions[0].url = URL(fileURLWithPath: "/dev/null")
        }
    }
    
    /// メモリ上で動く指定
    public convenience init(name: String, managedObjectModel model: NSManagedObjectModel, inMemory: Bool = false) {
        self.init(name: name, managedObjectModel: model)
        if inMemory {
            persistentStoreDescriptions[0].url = URL(fileURLWithPath: "/dev/null")
        }
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
