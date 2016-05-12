//
//  VolumeDetailViewController.swift
//  ComicList
//
//  Created by Guillermo Gonzalez on 09/01/16.
//  Copyright © 2016 Guillermo Gonzalez. All rights reserved.
//

import UIKit
import RxSwift

class VolumeDetailViewController: UIViewController {

    // MARK: - Properties
    
    @IBOutlet private weak var headerView: VolumeDetailHeaderView!
    
    @IBOutlet weak var descriptionView: VolumeDetailDescriptionView!
    
    @IBOutlet weak var issuesView: VolumeDetailIssuesView!
    
    private let viewModel: VolumeDetailViewModelType
    
    private let disposeBag = DisposeBag()
    
    // MARK: - Initialization
    
    init(viewModel: VolumeDetailViewModelType) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: NSBundle(forClass: self.dynamicType))
    }
    
    convenience init(summary: VolumeSummary) {
        self.init(viewModel: VolumeDetailViewModel(summary: summary))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        setupBindings()
    }

    // MARK: - Private
    
    private func setupView() {
        view.backgroundColor = UIColor(named: .DetailBackground)
    }
    
    private func setupBindings() {
        
        headerView.summary = viewModel.summary
        headerView.actionHandler = viewModel.addOrRemove
        
        viewModel.buttonTitle
            .bindTo(headerView.buttonTitle)
            .addDisposableTo(disposeBag)
        
        viewModel.description
            .bindTo(descriptionView.descriptionLabel.rx_text)
            .addDisposableTo(disposeBag)
        
        viewModel.description
            .map { $0.isEmpty }
            .bindTo(descriptionView.rx_hidden)
            .addDisposableTo(disposeBag)
        
        viewModel.issues
            .bindTo(issuesView.collectionView.rx_itemsWithCellFactory) { collectionView, item, issue in
                
                let cell: IssueCell = collectionView.dequeueReusableCell(forItem: item)
                cell.summary = issue
                
                return cell
            }
            .addDisposableTo(disposeBag)
    }
}
