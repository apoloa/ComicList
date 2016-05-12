//
//  VolumeListViewController.swift
//  ComicList
//
//  Created by Guillermo Gonzalez on 27/12/15.
//  Copyright © 2015 Guillermo Gonzalez. All rights reserved.
//

import UIKit

final class VolumeListViewController: UIViewController {
    
    // MARK: - Properties
    
    @IBOutlet private weak var collectionView: UICollectionView! {
        didSet {
            collectionView.register(VolumeListItemCell)
            collectionView.backgroundColor = UIColor(named: .Background)
        }
    }
    
    private let viewModel: VolumeListViewModelType
    private let wireframe: VolumeListWireframeType
    
    // MARK: - Initialization
    
    init(wireframe: VolumeListWireframeType, viewModel: VolumeListViewModelType = VolumeListViewModel()) {
        self.wireframe = wireframe
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: NSBundle(forClass: self.dynamicType))
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        wireframe.installSearchInViewController(self)        
        setupBindings()
    }
    
    // MARK: - Private
    
    private func setupBindings() {
        viewModel.didUpdateList = collectionView.reloadData
    }
}

// MARK: - UICollectionViewDataSource

extension VolumeListViewController: UICollectionViewDataSource {
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfVolumes
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell: VolumeListItemCell = collectionView.dequeueReusableCell(forIndexPath: indexPath)
        cell.item = viewModel[indexPath.item]
        
        return cell
    }
}

// MARK: - UICollectionViewDelegate

extension VolumeListViewController: UICollectionViewDelegate {
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        wireframe.presentVolumeDetailWithSummary(viewModel[indexPath.row], fromViewController: self)
    }
}
