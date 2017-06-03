//
//  UsersService.swift
//  Ladder
//
//  Created by BZ Logic9s on 3/5/17.
//  Copyright © 2017 Ladder. All rights reserved.
//

import UIKit
import CoreData

class UsersService {
    static let shared = UsersService()
    
    private var users: [User] = []
    
    private let fetchRequest: NSFetchRequest<NSFetchRequestResult>
    let fetchedResultsController: NSFetchedResultsController<NSFetchRequestResult>
    
    private init() {
        self.fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
        self.fetchRequest.sortDescriptors = [NSSortDescriptor(key: "lastname", ascending: true), NSSortDescriptor(key: "firstname", ascending: true)]
        self.fetchedResultsController = NSFetchedResultsController(fetchRequest: self.fetchRequest, managedObjectContext: UIApplication.shared.managedObjectContext, sectionNameKeyPath: "firstCharOfLastName", cacheName: nil)
    }
    
    // TODO: This may not be needed anymore because we handle everything through the fetchedResultsController
    func fetchAllUsers() -> [User] {
        if self.users.isEmpty {
            do {
                try self.fetchedResultsController.performFetch()
                guard let users = self.fetchedResultsController.fetchedObjects as? [User] else { preconditionFailure() }
                self.users = users
            } catch {
                fatalError("\(error)")
            }
        }
        return self.users
    }
    
    func createNewUser() -> User {
        let insertedUser = NSEntityDescription.insertNewObject(forEntityName: "User", into: UIApplication.shared.managedObjectContext) as! User
        return insertedUser
    }
    
    func save() {
        UIApplication.shared.saveAndReportErrors()
        self.users = []
    }
    
    func delete(user: User) {
        UIApplication.shared.managedObjectContext.delete(user)
        self.save()
    }
    
    func rollback() {
        UIApplication.shared.managedObjectContext.rollback()
    }
}

fileprivate extension User {
    dynamic var firstCharOfLastName: String? {
        let firstChar = self.lastname?.characters.first
        guard let c = firstChar else { return nil }
        return String(c)
    }
}
