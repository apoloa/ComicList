//
//  SearchResultsViewModel.swift
//  ComicList
//
//  Created by Guillermo Gonzalez on 09/01/16.
//  Copyright © 2016 Guillermo Gonzalez. All rights reserved.
//

import Foundation
import CoreData
import RxSwift

protocol SearchResultsViewModelType: class {
    
    /// The search query
    var query: String { get }
    
    /// Called when there are new search results
    var didUpdateResults: () -> () { get set }
    
    /// The current number of search results
    var numberOfResults: Int { get }
    
    /// Returns the search result at a given position
    subscript(position: Int) -> SearchResult { get }
    
    /// Returns the volume summary at a given position
    subscript(position: Int) -> VolumeSummary { get }
    
    /// Fetches the next page of results
    func nextPage() -> Observable<Void>
}

final class SearchResultsViewModel: NSObject {
    
    // MARK: - Properties
    
    let query: String
    
    var didUpdateResults: () -> () = {}
    
    private let session = ComicVineSession()
    private var currentPage: UInt = 1
    
    private let store: ManagedStore
    private let writeContext: NSManagedObjectContext
    private let readContext: NSManagedObjectContext
    private let fetchedResultsController: NSFetchedResultsController
    
    private var observer: NSObjectProtocol!
    
    // MARK: - Initialization
    
    init(query: String) {
        self.query = query
        self.store = try! ManagedStore.temporaryStore()
        self.writeContext = store.contextWithConcurrencyType(.PrivateQueueConcurrencyType)
        self.readContext = store.contextWithConcurrencyType(.MainQueueConcurrencyType)
        
        self.fetchedResultsController = NSFetchedResultsController(
            fetchRequest: ManagedVolume.defaultFetchRequest(),
            managedObjectContext: self.readContext,
            sectionNameKeyPath: nil,
            cacheName: nil)
        
        super.init()
        
        fetchedResultsController.delegate = self
        try! fetchedResultsController.performFetch()
        
        let nc = NSNotificationCenter.defaultCenter()
        let context = readContext
        
        self.observer = nc.addObserverForName(NSManagedObjectContextDidSaveNotification, object: writeContext, queue: nil) { notification in
            context.performBlock {
                context.mergeChangesFromContextDidSaveNotification(notification)
            }
        }
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(observer)
    }
    
    private subscript(position: Int) -> ManagedVolume {
        assert(position < numberOfResults, "Position out of range")
        
        let indexPath = NSIndexPath(forRow: position, inSection: 0)
        guard let volume = fetchedResultsController.objectAtIndexPath(indexPath) as? ManagedVolume else {
            fatalError("Couldn't get volume at position \(position)")
        }
        
        return volume
    }
}

extension SearchResultsViewModel: SearchResultsViewModelType {
    var numberOfResults: Int {
        return fetchedResultsController.sections?.first?.numberOfObjects ?? 0
    }
    
    subscript(position: Int) -> SearchResult {
        let volume: ManagedVolume = self[position]
        
        return SearchResult(
            imageURL: volume.imageURL,
            title: volume.title,
            publisherName: volume.publisher)
    }
    
    subscript(position: Int) -> VolumeSummary {
        let volume: ManagedVolume = self[position]
        
        return VolumeSummary(
            identifier: volume.identifier,
            title:  volume.title,
            imageURL:  volume.imageURL,
            publisherName: volume.publisher)
    }
    
    func nextPage() -> Observable<Void> {
        let context = writeContext
        
        return session.searchVolumes(query, page: currentPage)
            .doOn(onNext: { [weak self] dictionaries in
                let _: [ManagedVolume] = decode(dictionaries, insertingIntoContext: context)
                
                context.performBlockAndWait {
                    do {
                        try context.save()
                        self?.currentPage += 1
                    } catch {
                        print("Couldn't save search results")
                        context.rollback()
                    }
                }
            })
            .map { _ in () }
            .observeOn(MainScheduler.instance)
            .shareReplay(1)
    }
}

extension SearchResultsViewModel: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        didUpdateResults()
    }
}
