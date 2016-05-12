//
//  SearchSuggestionsViewController.swift
//  ComicList
//
//  Created by Guillermo Gonzalez on 08/01/16.
//  Copyright © 2016 Guillermo Gonzalez. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

protocol SearchSuggestionsViewControllerDelegate: class {
    func searchSuggestionsViewController(viewController: SearchSuggestionsViewController, didSelectSuggestion suggestion: String)
}

final class SearchSuggestionsViewController: UITableViewController {

    // MARK: - Properties
    
    weak var delegate: SearchSuggestionsViewControllerDelegate?
    
    private let viewModel: SearchSuggestionsViewModelType
    
    private let disposeBag = DisposeBag()
    
    // MARK: - Initialization
    
    init(viewModel: SearchSuggestionsViewModelType = SearchSuggestionsViewModel()) {
        self.viewModel = viewModel
        
        super.init(style: .Plain)
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
    
    // MARK: - UITableViewDelegate
    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        cell.backgroundColor = UIColor.clearColor()
    }
    
    // MARK: - Private
    
    private func setupView() {
        tableView.backgroundColor = UIColor(named: .Background).colorWithAlphaComponent(0.3)
        
        let effect = UIBlurEffect(style: .Light)
        let blurView = UIVisualEffectView(effect: effect)
        
        tableView.backgroundView = blurView
        tableView.separatorEffect = UIVibrancyEffect(forBlurEffect: effect)
        
        tableView.register(UITableViewCell)
    }
    
    private func setupBindings() {
        tableView.dataSource = nil
        
        viewModel.suggestions
            .bindTo(tableView.rx_itemsWithCellFactory) { tableView, index, suggestion in
                let cell: UITableViewCell = tableView.dequeueReusableCell()
                cell.textLabel?.text = suggestion
                
                return cell
            }
            .addDisposableTo(disposeBag)

        tableView
            .rx_modelSelected(String)
            .subscribeNext { [unowned self] suggestion in
                self.delegate?.searchSuggestionsViewController(self, didSelectSuggestion: suggestion)
            }
            .addDisposableTo(disposeBag)
    }
}

// MARK: - UISearchResultsUpdating

extension SearchSuggestionsViewController: UISearchResultsUpdating {
    
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        viewModel.query.value = searchController.searchBar.text ?? ""
    }
}
