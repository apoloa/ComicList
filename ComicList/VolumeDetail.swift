//
//  VolumeDetail.swift
//  ComicList
//
//  Created by Guillermo Gonzalez on 22/01/16.
//  Copyright © 2016 Guillermo Gonzalez. All rights reserved.
//

import Foundation

struct VolumeDetail {
    let title: String
    let description: String
}

extension VolumeDetail: JSONDecodable {
    init?(dictionary: JSONDictionary) {
        guard let title = dictionary["name"] as? String else {
            return nil
        }
        
        self.title = title
        self.description = dictionary["description"] as? String ?? ""
    }
}
