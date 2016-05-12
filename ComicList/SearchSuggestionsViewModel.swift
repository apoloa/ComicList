//
//  SearchSuggestionsViewModel.swift
//  ComicList
//
//  Created by Guillermo Gonzalez on 08/01/16.
//  Copyright © 2016 Guillermo Gonzalez. All rights reserved.
//

import Foundation
import RxSwift

protocol SearchSuggestionsViewModelType: class {
    
    /// The search query
    var query: Variable<String> { get }
    
    /// The search suggestions
    var suggestions: Observable<[String]> { get }
}

final class SearchSuggestionsViewModel: SearchSuggestionsViewModelType {
    
    let query = Variable("")
    private let session = ComicVineSession()

    private(set) lazy var suggestions: Observable<[String]> = self.query.asObservable()
        .filter { query in
            // Ignore query strings with less than 3 characters
            query.characters.count > 2
        }
        // This will avoid making unnecessary requests if the user types too fast
        .throttle(0.3, scheduler: MainScheduler.instance)
        .flatMap { query in
            // When the query string changes, any ongoing request will be cancelled
            // and a new request will be made with the new query.
            //
            // The results are flattened into the resulting Observer
            self.session.suggestedVolumes(query)
                // Do not forward any errors, otherwise bindings will crash
                .catchErrorJustReturn([])
        }
        .map { volumes in
            // Convert volumes into titles, removing any duplicates
            var titles: [String] = []
            
            for volume in volumes where !titles.contains(volume.title) {
                titles.append(volume.title)
            }
            
            return titles
        }
        // Make sure events are delivered in the main thread
        .observeOn(MainScheduler.instance)
        // Make sure multiple subscriptions share the side effects
        .shareReplay(1)
}
