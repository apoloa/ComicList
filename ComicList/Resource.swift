//
//  Resource.swift
//  ComicList
//
//  Created by Guillermo Gonzalez on 16/01/16.
//  Copyright © 2016 Guillermo Gonzalez. All rights reserved.
//

import Foundation

enum Method: String {
    case GET = "GET"
}

protocol Resource {
    var method: Method { get }
    var path: String { get }
    var parameters: [String: String] { get }
    
    func requestWithBaseURL(baseURL: NSURL) -> NSURLRequest
}

extension Resource {
    
    var method: Method {
        return .GET
    }
    
    var parameters: [String: String] {
        return [:]
    }
    
    func requestWithBaseURL(baseURL: NSURL) -> NSURLRequest {
        let URL = baseURL.URLByAppendingPathComponent(path)
        
        // NSURLComponents can fail due to programming errors, so
        // prefer crashing than returning an optional
        
        guard let components = NSURLComponents(URL: URL, resolvingAgainstBaseURL: false) else {
            fatalError("Unable to create URL components from \(URL)")
        }
        
        components.queryItems = parameters.map { NSURLQueryItem(name: $0, value: $1) }
        
        guard let finalURL = components.URL else {
            fatalError("Unable to retrieve final URL")
        }
        
        let request = NSMutableURLRequest(URL: finalURL)
        request.HTTPMethod = method.rawValue
        
        return request
    }
}
