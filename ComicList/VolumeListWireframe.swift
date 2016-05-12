//
//  VolumeListWireframe.swift
//  ComicList
//
//  Created by Guillermo Gonzalez on 08/01/16.
//  Copyright © 2016 Guillermo Gonzalez. All rights reserved.
//

import UIKit

protocol VolumeListWireframeType: class {
    
    func installSearchInViewController(viewController: UIViewController)
    
    func presentVolumeDetailWithSummary(summary: VolumeSummary, fromViewController viewController: UIViewController)
}

final class VolumeListWireframe: NSObject {
    
    private unowned let navigationController: UINavigationController
    
    private var searchController: UISearchController?
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    private func presentSearchResultsWithQuery(query: String) {
        let wireframe = SearchResultsWireframe(navigationController: navigationController)
        let viewController = SearchResultsViewController(wireframe: wireframe, query: query)
        
        self.navigationController.pushViewController(viewController, animated: true)
    }
}

extension VolumeListWireframe: VolumeListWireframeType {
    
    func installSearchInViewController(viewController: UIViewController) {
        let suggestionsViewController = SearchSuggestionsViewController()
        suggestionsViewController.delegate = self
        
        searchController = UISearchController(searchResultsController: suggestionsViewController)
        searchController?.searchResultsUpdater = suggestionsViewController
        searchController?.hidesNavigationBarDuringPresentation = false
        searchController?.searchBar.delegate = self
        
        searchController?.searchBar.placeholder = NSLocalizedString("Search Comic Vine", comment: "")
        searchController?.searchBar.searchBarStyle = .Minimal
        searchController?.searchBar.searchFieldTextColor = UIColor.whiteColor()
        searchController?.searchBar.keyboardAppearance = .Dark
        
        viewController.navigationItem.titleView = searchController?.searchBar
        viewController.definesPresentationContext = true
    }
    
    func presentVolumeDetailWithSummary(summary: VolumeSummary, fromViewController viewController: UIViewController) {
        
        let detailViewController = VolumeDetailViewController(summary: summary)
        navigationController.pushViewController(detailViewController, animated: true)
    }
}

extension VolumeListWireframe: SearchSuggestionsViewControllerDelegate {
    
    func searchSuggestionsViewController(viewController: SearchSuggestionsViewController, didSelectSuggestion suggestion: String) {
        
        presentSearchResultsWithQuery(suggestion)
    }
}

extension VolumeListWireframe: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        
        presentSearchResultsWithQuery(searchBar.text ?? "")
    }
}
