//
//  Issues.swift
//  ComicList
//
//  Created by Adrian Polo Alcaide on 13/05/16.
//  Copyright © 2016 Guillermo Gonzalez. All rights reserved.
//

import Foundation

struct Issue{
    let name : String
    private let imageURLString : String
    var imageURL: NSURL?{
        get{
            return NSURL(string: imageURLString)
        }
    }
}

extension Issue:JSONDecodable{
    init?(dictionary: JSONDictionary) {
        guard let name = dictionary["name"] as? String else{
            return nil
        }
        guard let imageURLString = (dictionary as NSDictionary).valueForKeyPath("image.small_url") as? String else{
            return nil
        }
        
        self.name = name
        self.imageURLString = imageURLString
    }
}