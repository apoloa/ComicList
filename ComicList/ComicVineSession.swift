//
//  ComicVineSession.swift
//  ComicList
//
//  Created by Guillermo Gonzalez on 14/01/16.
//  Copyright © 2016 Guillermo Gonzalez. All rights reserved.
//

import Foundation
import RxSwift

enum ComicVineError: ErrorType {
    case CouldNotDecodeJSON
    case BadStatus(status: UInt, message: String)
    case Other(NSError)
}

extension ComicVineError: CustomDebugStringConvertible {
    var debugDescription: String {
        switch self {
        case .CouldNotDecodeJSON:
            return "Could not decode JSON"
        case let .BadStatus(status, message):
            return "Bad status: \(status), \(message)"
        case let .Other(error):
            return "Other error: \(error)"
        }
    }
}

final class ComicVineSession {
    
    func object<T: JSONDecodable>(resource: Resource) -> Observable<T> {
        return response(resource).map { response in
            guard let result = response.result,
                object: T = decode(result) else {
                    throw ComicVineError.CouldNotDecodeJSON
            }
            
            return object
        }
    }
    
    func objects<T: JSONDecodable>(resource: Resource) -> Observable<[T]> {
        return response(resource).map { response in
            guard let results = response.results,
                objects: [T] = decode(results) else {
                    throw ComicVineError.CouldNotDecodeJSON
            }
            
            return objects
        }
    }
    
    func response(resource: Resource) -> Observable<Response> {
        let request = resource.requestWithBaseURL(baseURL)
        
        return data(request).map { data in
            guard let response: Response = decode(data) else {
                throw ComicVineError.CouldNotDecodeJSON
            }
            
            guard response.succeeded else {
                throw ComicVineError.BadStatus(status: response.status, message: response.message)
            }
            
            return response
        }
    }
    
    // MARK: - Private
    
    private let session: NSURLSession = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration())
    private let key = "1c405a814e621e1a4cb5baadf6b7600967be361b"
    private let baseURL = NSURL(string: "http://www.comicvine.com/api")!
    
    private func data(request: NSURLRequest) -> Observable<NSData> {
        
        return Observable.create { observer in
            let task = self.session.dataTaskWithRequest(request) { data, response, error in
                
                if let error = error {
                    observer.onError(ComicVineError.Other(error))
                } else {
                    // With a typical web service we should check the HTTP status code,
                    // but Comic Vine always returns 200 OK and its own status code in
                    // the JSON response
                    observer.onNext(data ?? NSData())
                }
            }
            
            task.resume()
            
            return AnonymousDisposable {
                task.cancel()
            }
        }
    }
}

extension ComicVineSession {
    
    func suggestedVolumes(query: String) -> Observable<[Volume]> {
        return objects(ComicVine.Suggestions(key: key, query: query))
    }
    
    func searchVolumes(query: String, page: UInt) -> Observable<[JSONDictionary]> {
        return response(ComicVine.Search(key: key, query: query, page: page)).map { response in
            guard let results = response.results else {
                throw ComicVineError.CouldNotDecodeJSON
            }
            
            return results
        }
    }
    
    func volumeDetail(identifier: Int) -> Observable<VolumeDetail> {
        return object(ComicVine.VolumeDetail(key: key, identifier: identifier))
    }
    
    func volumeIssues(identifier: Int) -> Observable<[Issue]>{
        return objects(ComicVine.Issues(key: key, identifier: identifier))
    }
}
