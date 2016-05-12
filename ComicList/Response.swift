//
//  Response.swift
//  ComicList
//
//  Created by Guillermo Gonzalez on 16/01/16.
//  Copyright © 2016 Guillermo Gonzalez. All rights reserved.
//

import Foundation

struct Response {
    let status: UInt
    let message: String
    
    var succeeded: Bool {
        return status == 1
    }
    
    var result: JSONDictionary? {
        return payload as? JSONDictionary
    }
    
    var results: [JSONDictionary]? {
        return payload as? [JSONDictionary]
    }
    
    private let payload: AnyObject?
}

extension Response: JSONDecodable {
    init?(dictionary: JSONDictionary) {
        guard let status = dictionary["status_code"] as? UInt,
            message = dictionary["error"] as? String else {
                return nil
        }
        
        self.status = status
        self.message = message
        self.payload = dictionary["results"]
    }
}
