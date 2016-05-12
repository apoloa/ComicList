//
//  Volume.swift
//  ComicList
//
//  Created by Guillermo Gonzalez on 14/01/16.
//  Copyright © 2016 Guillermo Gonzalez. All rights reserved.
//

import Foundation

struct Volume {
    let title: String
}

extension Volume: JSONDecodable {
    init?(dictionary: JSONDictionary) {
        guard let title = dictionary["name"] as? String else {
            return nil
        }
        
        self.title = title
    }
}
