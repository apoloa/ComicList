//
//  VolumeDetailHeaderView.swift
//  ComicList
//
//  Created by Guillermo Gonzalez on 11/01/16.
//  Copyright © 2016 Guillermo Gonzalez. All rights reserved.
//

import UIKit
import Kingfisher
import RxSwift

class VolumeDetailHeaderView: UIStackView {
    
    @IBOutlet private weak var imageView: UIImageView!
    
    @IBOutlet private weak var actionButton: UIButton! {
        didSet {
            actionButton.tintColor = UIColor(named: .ButtonTint)
        }
    }
    
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
    
    @IBAction private func didTapActionButton(sender: UIButton) {
        actionHandler()
    }
    
    var actionHandler: () -> () = {}
    
    /// Bindable sink for the button title
    var buttonTitle: AnyObserver<String> {
        return AnyObserver { [weak self] event in
            MainScheduler.ensureExecutingOnScheduler()
            
            switch event {
            case let .Next(value):
                self?.actionButton.setTitle(value, forState: .Normal)
            case let .Error(error):
                fatalError("Binding error: \(error)")
            case .Completed:
                break
            }
        }
    }
    
    var summary: VolumeSummary? {
        didSet {
            titleLabel.text = summary?.title
            publisherLabel.text = summary?.publisherName
            
            if let imageURL = summary?.imageURL {
                imageView.kf_setImageWithURL(imageURL)
            }
        }
    }
}
