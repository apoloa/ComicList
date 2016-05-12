//
//  VolumeListItemCell.swift
//  ComicList
//
//  Created by Guillermo Gonzalez on 27/12/15.
//  Copyright © 2015 Guillermo Gonzalez. All rights reserved.
//

import UIKit
import Kingfisher

final class VolumeListItemCell: UICollectionViewCell {

    @IBOutlet private weak var imageView: UIImageView!
    
    @IBOutlet private weak var textLabel: UILabel! {
        didSet {
            textLabel.textColor = UIColor(named: .DarkText)
        }
    }
    
    var item: VolumeListItem? {
        didSet {
            textLabel.text = item?.title
            
            if let imageURL = item?.imageURL {
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

extension VolumeListItemCell: NibLoadableView {}
