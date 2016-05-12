//
//  ManagedVolume.swift
//  ComicList
//
//  Created by Guillermo Gonzalez on 17/01/16.
//  Copyright © 2016 Guillermo Gonzalez. All rights reserved.
//

import CoreData

final class ManagedVolume: NSManagedObject {
    
    @NSManaged var identifier: Int
    @NSManaged var title: String
    @NSManaged var publisher: String?
    @NSManaged private var imageURLString: String?
    
    @NSManaged private(set) var insertionDate: NSDate
    
    var imageURL: NSURL? {
        get {
            return (imageURLString != nil) ? NSURL(string: imageURLString!) : nil
        }
        
        set {
            imageURLString = newValue?.absoluteString
        }
    }
    
    override func awakeFromInsert() {
        super.awakeFromInsert()
        insertionDate = NSDate()
    }
}

extension ManagedVolume {
    static func defaultFetchRequest() -> NSFetchRequest {
        let fetchRequest = NSFetchRequest(entityName: ManagedVolume.entityName)
        
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "insertionDate", ascending: true)]
        fetchRequest.fetchBatchSize = 20
        
        return fetchRequest
    }
    
    static func fetchRequestForVolumeWithIdentifier(identifier: Int) -> NSFetchRequest {
        let predicate = NSPredicate(format: "identifier == %d", identifier)
        
        let fetchRequest = NSFetchRequest(entityName: ManagedVolume.entityName)
        fetchRequest.predicate = predicate
        fetchRequest.fetchLimit = 1
        
        return fetchRequest
    }
}

extension ManagedVolume: ManagedObjectType {
    static var entityName: String {
        return "Volume"
    }
}

extension ManagedVolume: ManagedJSONDecodable {
    func updateWithJSONDictionary(dictionary: JSONDictionary) {
        guard let identifier = dictionary["id"] as? Int,
            title = dictionary["name"] as? String else {
                return
        }
        
        self.identifier = identifier
        self.title = title
        self.publisher = (dictionary as NSDictionary).valueForKeyPath("publisher.name") as? String
        self.imageURLString = (dictionary as NSDictionary).valueForKeyPath("image.small_url") as? String
    }
}
