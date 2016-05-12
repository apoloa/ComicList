//
//  VolumeDetailViewModel.swift
//  ComicList
//
//  Created by Guillermo Gonzalez on 11/01/16.
//  Copyright © 2016 Guillermo Gonzalez. All rights reserved.
//

import Foundation
import RxSwift

protocol VolumeDetailViewModelType: class {
    
    /// The button title depends on the volume status
    var buttonTitle: Observable<String> { get }
    
    /// The volume summary
    var summary: VolumeSummary { get }
    
    /// The volume description
    var description: Observable<String> { get }
    
    /// The issues for this volume
    var issues: Observable<[IssueSummary]> { get }
    
    /// Adds or removes the volume
    func addOrRemove()
}

final class VolumeDetailViewModel: VolumeDetailViewModelType {
    
    private let session = ComicVineSession()
    private let store = VolumeListStore.sharedStore
    
    private let owned: Variable<Bool>
    
    // MARK: - Initialization
    
    init(summary: VolumeSummary) {
        self.summary = summary
        self.owned = Variable(store.containsVolume(summary.identifier))
    }
    
    // MARK: - VolumeDetailViewModelType
    
    var buttonTitle: Observable<String> {
        return owned.asObservable().map { $0 ? "Remove" : "Add" }
    }
    
    let summary: VolumeSummary
    
    private(set) lazy var description: Observable<String> = self.session.volumeDetail(self.summary.identifier)
        .map { $0.description }
        .catchErrorJustReturn("")
        // Make the description is delivered on the main thread
        .observeOn(MainScheduler.instance)
        // Strip out the HTML markup
        .map { description in
            let data = description.dataUsingEncoding(NSUTF8StringEncoding)!
            let options: [String: AnyObject] = [
                NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType,
                NSCharacterEncodingDocumentAttribute: NSUTF8StringEncoding
            ]
            
            let attributedText = try NSMutableAttributedString(data: data, options: options, documentAttributes: nil)
            return attributedText.string
        }
        // Initial value will be an empty string
        .startWith("")
        // Make sure multiple subscriptions share the side effects
        .shareReplay(1)
    
    private(set) lazy var issues: Observable<[IssueSummary]> =  self.session.volumeIssues(self.summary.identifier)
        .observeOn(MainScheduler.instance)
        .map { issues in
            var issuesSumary: [IssueSummary] = []
            for issue in issues {
                issuesSumary.append(IssueSummary(title: issue.name, imageURL: issue.imageURL))
            }
            return issuesSumary
        }
        .shareReplay(1)
    
    
    func addOrRemove() {
        do {
            if owned.value {
                try store.removeVolume(summary.identifier)
            } else {
                try store.addVolume(summary)
            }
            owned.value = !owned.value
        } catch let error {
            print("Error adding or removing volume: \(error)")
        }
    }
}
