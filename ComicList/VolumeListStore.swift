//
//  VolumeListDataSource.swift
//  ComicList
//
//  Created by Guillermo Gonzalez on 23/01/16.
//  Copyright © 2016 Guillermo Gonzalez. All rights reserved.
//

import Foundation
import CoreData

class VolumeListStore {
    
    static let sharedStore = VolumeListStore(documentName: "My Comics")
    
    private let managedStore: ManagedStore
    let context: NSManagedObjectContext
    
    private init(documentName: String) {
        self.managedStore = try! ManagedStore(documentName: documentName)
        self.context = managedStore.contextWithConcurrencyType(.MainQueueConcurrencyType)
    }
    
    func containsVolume(identifier: Int) -> Bool {
        let fetchRequest = ManagedVolume.fetchRequestForVolumeWithIdentifier(identifier)
        let count = context.countForFetchRequest(fetchRequest, error: nil)
        
        return (count != NSNotFound) && (count > 0)
    }
    
    func removeVolume(identifier: Int) throws {
        let fetchRequest = ManagedVolume.fetchRequestForVolumeWithIdentifier(identifier)
        let volumes = try context.executeFetchRequest(fetchRequest) as! [NSManagedObject]
        
        if volumes.count > 0 {
            context.deleteObject(volumes[0])
            try context.save()
        }
    }
    
    func addVolume(summary: VolumeSummary) throws {
        let volume = NSEntityDescription.insertNewObjectForEntityForName(ManagedVolume.entityName, inManagedObjectContext: context) as! ManagedVolume
        
        volume.identifier = summary.identifier
        volume.title = summary.title
        volume.publisher = summary.publisherName
        volume.imageURL = summary.imageURL
        
        try context.save()
    }
}
