//
//  SearchResultsWireframe.swift
//  ComicList
//
//  Created by Guillermo Gonzalez on 11/01/16.
//  Copyright © 2016 Guillermo Gonzalez. All rights reserved.
//

import UIKit

protocol SearchResultsWireframeType: class {
    
    func presentVolumeDetailWithSummary(summary: VolumeSummary, fromViewController viewController: UIViewController)
}

final class SearchResultsWireframe {
    
    private unowned let navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
}

extension SearchResultsWireframe: SearchResultsWireframeType {
    
    func presentVolumeDetailWithSummary(summary: VolumeSummary, fromViewController viewController: UIViewController) {
        
        let detailViewController = VolumeDetailViewController(summary: summary)
        navigationController.pushViewController(detailViewController, animated: true)
    }
}
