//
//  ComicVine.swift
//  ComicList
//
//  Created by Guillermo Gonzalez on 14/01/16.
//  Copyright © 2016 Guillermo Gonzalez. All rights reserved.
//

import Foundation

enum ComicVine {
    case Suggestions(key: String, query: String)
    case Search(key: String, query: String, page: UInt)
    case VolumeDetail(key: String, identifier: Int)
    case Issues(key:String, identifier: Int)
}

extension ComicVine: Resource {
    
    var path: String {
        switch self {
        case .Suggestions, .Search:
            return "search"
        case let .VolumeDetail(_, identifier):
            return "volume/4050-\(identifier)"
        case .Issues:
            return "issues"
        }
        
    }
    
    var parameters: [String: String] {
        switch self {
        case let .Suggestions(key, query):
            return [
                "api_key": key,
                "format": "json",
                "field_list": "name",
                "limit": "10",
                "page": "1",
                "query": query,
                "resources": "volume"
            ]
            
        case let .Search(key, query, page):
            return [
                "api_key": key,
                "format": "json",
                "field_list": "id,image,name,publisher",
                "limit": "20",
                "page": "\(page)",
                "query": query,
                "resources": "volume"
            ]
        case let .VolumeDetail(key, _):
            return [
                "api_key": key,
                "format": "json",
                "field_list": "name,description",
            ]
        case let .Issues(key, identifier):
            return [
                "api_key":key,
                "field_list": "id,image,name,volume",
                "filter" : "volume:\(identifier)",
                "format":"json"
            ]
        }
        
    }
    
}
