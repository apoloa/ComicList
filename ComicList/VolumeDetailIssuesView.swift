//
//  VolumeDetailIssuesView.swift
//  ComicList
//
//  Created by Guillermo Gonzalez on 11/01/16.
//  Copyright © 2016 Guillermo Gonzalez. All rights reserved.
//

import UIKit

class VolumeDetailIssuesView: UIStackView {

    @IBOutlet private weak var titleLabel: UILabel! {
        didSet {
            titleLabel.text = NSLocalizedString("Issues", comment: "")
            titleLabel.textColor = UIColor(named: .DarkText)
        }
    }
    
    @IBOutlet private(set) weak var collectionView: UICollectionView! {
        didSet {
            collectionView.backgroundColor = UIColor(named: .DetailBackground)
            collectionView.register(IssueCell)
        }
    }
}
