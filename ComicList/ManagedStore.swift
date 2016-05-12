//
//  ManagedStore.swift
//  ComicList
//
//  Created by Guillermo Gonzalez on 17/01/16.
//  Copyright © 2016 Guillermo Gonzalez. All rights reserved.
//

import Foundation
import CoreData

final class ManagedStore {
    
    // MARK: - Properties
    
    let persistentStoreCoordinator: NSPersistentStoreCoordinator
    
    var model: NSManagedObjectModel {
        return persistentStoreCoordinator.managedObjectModel
    }
    
    var URL: NSURL? {
        return persistentStoreCoordinator.persistentStores.first?.URL
    }
    
    // MARK: - Initialization
    
    init(URL: NSURL? = nil, model: NSManagedObjectModel = NSManagedObjectModel.mergedModelFromBundles(nil)!) throws {
        self.persistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: model)
        
        let type = (URL != nil) ? NSSQLiteStoreType : NSInMemoryStoreType
        let options = [
            NSMigratePersistentStoresAutomaticallyOption: true,
            NSInferMappingModelAutomaticallyOption: true
        ]
        
        try self.persistentStoreCoordinator.addPersistentStoreWithType(type, configuration: nil, URL: URL, options: options)
    }
    
    convenience init(documentName: String, model: NSManagedObjectModel = NSManagedObjectModel.mergedModelFromBundles(nil)!) throws {
        let documentURL = NSURL.documentsDirectoryURL.URLByAppendingPathComponent(documentName)
        try self.init(URL: documentURL, model: model)
    }
    
    static func temporaryStore() throws -> ManagedStore {
        return try ManagedStore(URL: NSURL.temporaryFileURL())
    }
    
    // MARK: - Context creation
    
    func contextWithConcurrencyType(type: NSManagedObjectContextConcurrencyType) -> NSManagedObjectContext {
        let context = NSManagedObjectContext(concurrencyType: type)
        context.persistentStoreCoordinator = persistentStoreCoordinator
        
        return context
    }
}
