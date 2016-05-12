//
//  SpacerView.swift
//  ComicList
//
//  Created by Guillermo Gonzalez on 09/01/16.
//  Copyright © 2016 Guillermo Gonzalez. All rights reserved.
//

import UIKit

final class SpacerView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupView()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setupView()
    }
    
    private func setupView() {
        setContentCompressionResistancePriority(1, forAxis: .Horizontal)
        setContentCompressionResistancePriority(1, forAxis: .Vertical)
        
        setContentHuggingPriority(1, forAxis: .Horizontal)
        setContentHuggingPriority(1, forAxis: .Vertical)
    }
    
    override func intrinsicContentSize() -> CGSize {
        return CGSize(width: 9999, height: 9999)
    }
}
