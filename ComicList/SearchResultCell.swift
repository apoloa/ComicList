//
//  SearchResultCell.swift
//  ComicList
//
//  Created by Guillermo Gonzalez on 09/01/16.
//  Copyright © 2016 Guillermo Gonzalez. All rights reserved.
//

import UIKit
import Kingfisher

class SearchResultCell: UITableViewCell {

    @IBOutlet private weak var coverImageView: UIImageView!
    
    @IBOutlet private weak var titleLabel: UILabel! {
        didSet {
            titleLabel.textColor = UIColor(named: .DarkText)
        }
    }
    
    @IBOutlet private weak var publisherLabel: UILabel! {
        didSet {
            publisherLabel.textColor = UIColor(named: .LightText)
        }
    }
    
    var result: SearchResult? {
        didSet {
            titleLabel.text = result?.title
            publisherLabel.text = result?.publisherName
            
            if let imageURL = result?.imageURL {
                coverImageView.kf_setImageWithURL(imageURL)
            }
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        coverImageView.kf_cancelDownloadTask()
        coverImageView.image = nil;
    }
}

extension SearchResultCell: NibLoadableView {}
