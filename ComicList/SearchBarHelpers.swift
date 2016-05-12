//
//  SearchBarHelpers.swift
//  ComicList
//
//  Created by Guillermo Gonzalez on 10/02/16.
//  Copyright © 2016 Guillermo Gonzalez. All rights reserved.
//

import UIKit

extension UISearchBar {
    
    var searchFieldTextColor: UIColor? {
        get {
            return self.valueForKeyPath("searchField.textColor") as? UIColor
        }
        
        set {
            self.setValue(newValue, forKeyPath: "searchField.textColor")
        }
    }
}
