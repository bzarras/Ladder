//
//  ActivityService.swift
//  Ladder
//
//  Created by BZ Logic9s on 6/4/17.
//  Copyright © 2017 Ladder. All rights reserved.
//

import UIKit
import CoreData

class ActivityService {
    
    private let fetchRequest: NSFetchRequest<NSFetchRequestResult>
    let fetchedResultsController: NSFetchedResultsController<NSFetchRequestResult>
    
    init() {
        self.fetchRequest = NSFetchRequest(entityName: "Activity")
        self.fetchRequest.sortDescriptors = [NSSortDescriptor(key: "timestamp", ascending: false)]
        self.fetchedResultsController = NSFetchedResultsController(fetchRequest: self.fetchRequest, managedObjectContext: UIApplication.shared.managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
        self.performFetch()
    }
    
    func performFetch() {
        do {
            try self.fetchedResultsController.performFetch()
        } catch {
            fatalError("\(error)")
        }
    }
}
