//
//  VolumeListViewModel.swift
//  ComicList
//
//  Created by Guillermo Gonzalez on 31/12/15.
//  Copyright © 2015 Guillermo Gonzalez. All rights reserved.
//

import Foundation
import CoreData

/// Represents a volume list view model
protocol VolumeListViewModelType: class {

    /// Called when comics are inserted or removed
    var didUpdateList: () -> () { get set }
    
    /// The number of volumes in the list
    var numberOfVolumes: Int { get }
    
    /// Returns the volume item at a given position
    subscript(position: Int) -> VolumeListItem { get }
    
    /// Returns the volume summary at a given position
    subscript(position: Int) -> VolumeSummary { get }
}

final class VolumeListViewModel: NSObject {
    
    // MARK: - Properties
    
    var didUpdateList: () -> () = {}
    
    private let store = VolumeListStore.sharedStore
    private let fetchedResultsController: NSFetchedResultsController
    
    override init() {
        self.fetchedResultsController = NSFetchedResultsController(
            fetchRequest: ManagedVolume.defaultFetchRequest(),
            managedObjectContext: store.context,
            sectionNameKeyPath: nil,
            cacheName: nil)
        
        super.init()
        
        fetchedResultsController.delegate = self
        try! fetchedResultsController.performFetch()
    }
    
    private subscript(position: Int) -> ManagedVolume {
        assert(position < numberOfVolumes, "Position out of range")
        
        let indexPath = NSIndexPath(forItem: position, inSection: 0)
        guard let volume = fetchedResultsController.objectAtIndexPath(indexPath) as? ManagedVolume else {
            fatalError("Couldn't get volume at position \(position)")
        }
        
        return volume
    }
}

extension VolumeListViewModel: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        didUpdateList()
    }
}

extension VolumeListViewModel: VolumeListViewModelType {
    var numberOfVolumes: Int {
        return fetchedResultsController.sections?.first?.numberOfObjects ?? 0
    }
    
    subscript(position: Int) -> VolumeListItem {
        let volume: ManagedVolume = self[position]
        
        return VolumeListItem(imageURL: volume.imageURL, title: volume.title)
    }
    
    subscript(position: Int) -> VolumeSummary {
        let volume: ManagedVolume = self[position]
        
        return VolumeSummary(
            identifier: volume.identifier,
            title:  volume.title,
            imageURL:  volume.imageURL,
            publisherName: volume.publisher)
    }
}
