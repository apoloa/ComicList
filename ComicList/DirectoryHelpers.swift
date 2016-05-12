//
//  DirectoryHelpers.swift
//  ComicList
//
//  Created by Guillermo Gonzalez on 17/01/16.
//  Copyright © 2016 Guillermo Gonzalez. All rights reserved.
//

import Foundation

extension NSURL {
    static func temporaryFileURL() -> NSURL {
        let fileURL = NSURL(fileURLWithPath: NSTemporaryDirectory())
        return fileURL.URLByAppendingPathComponent(NSUUID().UUIDString)
    }
    
    static var documentsDirectoryURL: NSURL {
        return try! NSFileManager.defaultManager().URLForDirectory(.DocumentDirectory, inDomain: .UserDomainMask, appropriateForURL: nil, create: true)
    }
}
