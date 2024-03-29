//
//  Storage.swift
//  
//  
//  Created by keiji0 on 2022/04/09
//  
//

import Foundation
import AppToolsData
import CoreData
import os

/// UbiquitousStorageのストレージ
final class Storage : Trasactionable {
    
    // MARK: - Internal
    
    init(_ context: NSManagedObjectContext) {
        self.context = context
    }
    
    func getConfigure(_ device: UUID, _ key: String) -> Data? {
        getConfigure(device, key)?.value
    }
    
    func getConfigures(_ key: String) -> [(UUID, Data)] {
        getConfigures(key).map {
            ($0.device!, $0.value!)
        }
    }
    
    func setConfigure(_ device: UUID, _ key: String, _ value: Data) {
        try! begin {
            if let configure: ConfigureMO = getConfigure(device, key) {
                configure.value = value
            } else {
                let configure = ConfigureMO(context: context)
                configure.device = device
                configure.key = key
                configure.value = value
            }
            Logger.main.info("setConfigure: device=\(device), key=\(key), value=\(value)")
        }
    }
    
    // MARK: - Trasactionable
    
    func begin(_ block: () throws -> Void) throws {
        transactionNestLevel += 1
        defer { transactionNestLevel -= 1 }
        do {
            try block()
            if transactionNestLevel == 1 {
                try commit()
            }
        } catch let e {
            context.rollback()
            throw e
        }
    }
    
    // MARK: - Private;
    
    private let context: NSManagedObjectContext
    private var transactionNestLevel: Int = 0
    
    private func getConfigures(_ key: String) -> [ConfigureMO] {
        let request: NSFetchRequest<ConfigureMO> = ConfigureMO.fetchRequest()
        request.predicate = NSPredicate(format: "key = %@", key as CVarArg)
        return try! context.fetch(request)
    }
    
    private func getConfigure(_ device: UUID, _ key: String) -> ConfigureMO? {
        let request: NSFetchRequest<ConfigureMO> = ConfigureMO.fetchRequest()
        request.predicate = NSPredicate(
            format: "key = %@ AND device = %@",
            key as CVarArg,
            device as CVarArg)
        return try! context.fetch(request).first
    }
    
    private func commit() throws {
        if context.hasChanges {
            try context.save()
        }
    }
}
