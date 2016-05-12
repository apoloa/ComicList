//
//  ManagedObjectType.swift
//  ComicList
//
//  Created by Guillermo Gonzalez on 17/01/16.
//  Copyright © 2016 Guillermo Gonzalez. All rights reserved.
//

import Foundation
import CoreData

protocol ManagedObjectType {
    static var entityName: String { get }
}

protocol ManagedJSONDecodable {
    func updateWithJSONDictionary(dictionary: JSONDictionary)
}

func decode<T: NSManagedObject where T: ManagedObjectType, T: ManagedJSONDecodable>(dictionaries: [JSONDictionary], insertingIntoContext context: NSManagedObjectContext) -> [T] {
    
    var objects: [T] = []
    
    context.performBlockAndWait {
        objects = dictionaries.map { dictionary in
            let object = NSEntityDescription.insertNewObjectForEntityForName(T.entityName, inManagedObjectContext: context) as! T
            
            object.updateWithJSONDictionary(dictionary)
            return object
        }
    }
    
    return objects
}
