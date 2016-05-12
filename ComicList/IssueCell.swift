//
//  IssueCell.swift
//  ComicList
//
//  Created by Guillermo Gonzalez on 11/01/16.
//  Copyright © 2016 Guillermo Gonzalez. All rights reserved.
//

import UIKit
import Kingfisher

class IssueCell: UICollectionViewCell {

    @IBOutlet private weak var imageView: UIImageView!
    
    @IBOutlet private weak var titleLabel: UILabel! {
        didSet {
            titleLabel.textColor = UIColor(named: .DarkText)
        }
    }
    
    var summary: IssueSummary? {
        didSet {
            titleLabel.text = summary?.title
            
            if let imageURL = summary?.imageURL {
                imageView.kf_setImageWithURL(imageURL)
            }
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        imageView.kf_cancelDownloadTask()
        imageView.image = nil
    }
}

extension IssueCell: NibLoadableView {}
