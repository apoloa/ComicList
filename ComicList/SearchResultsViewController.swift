//
//  SearchResultsViewController.swift
//  ComicList
//
//  Created by Guillermo Gonzalez on 09/01/16.
//  Copyright © 2016 Guillermo Gonzalez. All rights reserved.
//

import UIKit
import RxSwift

class SearchResultsViewController: UITableViewController {
    
    // MARK: - Properties
    
    private let viewModel: SearchResultsViewModelType
    
    private let wireframe: SearchResultsWireframeType
    
    private let disposeBag = DisposeBag()
    
    // MARK: - Initialization
    
    init(wireframe: SearchResultsWireframeType, viewModel: SearchResultsViewModelType) {
        self.wireframe = wireframe
        self.viewModel = viewModel
        
        super.init(style: .Plain)
    }
    
    convenience init(wireframe: SearchResultsWireframeType, query: String) {
        self.init(wireframe: wireframe, viewModel: SearchResultsViewModel(query: query))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        setupBindings()
        nextPage()
    }

    // MARK: - UITableViewDataSource

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfResults
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: SearchResultCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
        cell.result = viewModel[indexPath.row]
        
        return cell
    }
    
    // MARK: - UITableViewDelegate
    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        cell.backgroundColor = UIColor.clearColor()
        
        if indexPath.row == viewModel.numberOfResults - 1 {
            nextPage()
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        wireframe.presentVolumeDetailWithSummary(viewModel[indexPath.row], fromViewController: self)
    }
    
    // MARK: - Private
    
    private func setupView() {
        title = viewModel.query
        
        tableView.backgroundColor = UIColor(named: .Background)
        tableView.register(SearchResultCell)
    }
    
    private func setupBindings() {
        viewModel.didUpdateResults = tableView.reloadData
    }
    
    private func nextPage() {
        viewModel.nextPage().subscribeNext {
            // loading = false
        }.addDisposableTo(disposeBag)
    }
}
