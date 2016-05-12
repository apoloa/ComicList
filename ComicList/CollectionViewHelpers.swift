//
//  CollectionViewHelpers.swift
//  ComicList
//
//  Created by Guillermo Gonzalez on 31/12/15.
//  Copyright © 2015 Guillermo Gonzalez. All rights reserved.
//

import Foundation
import UIKit

protocol ReusableView: class {
    static var defaultReuseIdentifier: String { get }
}

protocol NibLoadableView: class {
    static var nibName: String { get }
}

extension ReusableView where Self: UIView {
    static var defaultReuseIdentifier: String {
        return String(Self)
    }
}

extension NibLoadableView where Self: UIView {
    static var nibName: String {
        return String(Self)
    }
}

extension UICollectionViewCell: ReusableView {}

extension UICollectionView {
    
    func register<T: UICollectionViewCell where T: ReusableView>(_: T.Type) {
        registerClass(T.self, forCellWithReuseIdentifier: T.defaultReuseIdentifier)
    }
    
    func register<T: UICollectionViewCell where T: ReusableView, T: NibLoadableView>(_: T.Type) {
        let bundle = NSBundle(forClass: T.self)
        let nib = UINib(nibName: T.nibName, bundle: bundle)
        
        registerNib(nib, forCellWithReuseIdentifier: T.defaultReuseIdentifier)
    }
    
    func dequeueReusableCell<T: UICollectionViewCell where T: ReusableView>(forIndexPath indexPath: NSIndexPath) -> T {
        guard let cell = dequeueReusableCellWithReuseIdentifier(T.defaultReuseIdentifier, forIndexPath: indexPath) as? T else {
            fatalError("Could not dequeue cell with identifier: \(T.defaultReuseIdentifier)")
        }
        
        return cell
    }
    
    func dequeueReusableCell<T: UICollectionViewCell where T: ReusableView>(forItem item: Int) -> T {
        return dequeueReusableCell(forIndexPath: NSIndexPath(forItem: item, inSection: 0))
    }
}
