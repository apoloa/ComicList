//
//  VolumeDetailDescriptionView.swift
//  ComicList
//
//  Created by Guillermo Gonzalez on 11/01/16.
//  Copyright © 2016 Guillermo Gonzalez. All rights reserved.
//

import UIKit

class VolumeDetailDescriptionView: UIStackView {

    @IBOutlet private weak var titleLabel: UILabel! {
        didSet {
            titleLabel.text = NSLocalizedString("About", comment: "")
            titleLabel.textColor = UIColor(named: .DarkText)
        }
    }
    
    @IBOutlet private(set) weak var descriptionLabel: UILabel! {
        didSet {
            descriptionLabel.textColor = UIColor(named: .DarkText)
        }
    }
}
