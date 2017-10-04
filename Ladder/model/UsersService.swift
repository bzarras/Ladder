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
        self.fetchRequest.predicate = NSPredicate(format: "id != 'self'", argumentArray: nil)
        self.fetchRequest.sortDescriptors = [NSSortDescriptor(key: "lastname", ascending: true), NSSortDescriptor(key: "firstname", ascending: true)]
        self.fetchedResultsController = NSFetchedResultsController(fetchRequest: self.fetchRequest, managedObjectContext: UIApplication.shared.managedObjectContext, sectionNameKeyPath: "firstCharOfLastName", cacheName: nil)
    }
    
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
    
    func fetchUserIdentity() -> User {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
        fetchRequest.predicate = NSPredicate(format: "id == 'self'", argumentArray: nil)
        do {
            let identityUsers = try UIApplication.shared.managedObjectContext.fetch(fetchRequest) as? [User]
            if let identityUsersArray = identityUsers, let identityUser = identityUsersArray.first {
                return identityUser
            } else {
                let newIdentiyUser = self.createNewUser()
                newIdentiyUser.firstname = "Your"
                newIdentiyUser.lastname = "Name"
                newIdentiyUser.id = "self"
                UIApplication.shared.saveAndReportErrors()
                return newIdentiyUser
            }
        } catch {
            fatalError("\(error)")
        }
    }
    
    func createNewUser() -> User {
        let insertedUser = NSEntityDescription.insertNewObject(forEntityName: "User", into: UIApplication.shared.managedObjectContext) as! User
        return insertedUser
    }
    
    func save() {
        if let newUsers = UIApplication.shared.managedObjectContext.insertedObjects as? Set<User> {
            newUsers.forEach { newUser in
                if newUser.id == nil {
                    newUser.id = UUID().uuidString
                }
                let insertedActivity = NSEntityDescription.insertNewObject(forEntityName: "Activity", into: UIApplication.shared.managedObjectContext) as! Activity
                insertedActivity.header = "New Contact"
                insertedActivity.title = "\(newUser.firstname ?? "") \(newUser.lastname ?? "")"
                if let company = newUser.company {
                    insertedActivity.body = "\(company)"
                }
                insertedActivity.timestamp = Date()
                insertedActivity.user = newUser
            }
        }
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
    @objc dynamic var firstCharOfLastName: String? {
        let firstChar = self.lastname?.characters.first
        guard let c = firstChar else { return nil }
        return String(c)
    }
}
