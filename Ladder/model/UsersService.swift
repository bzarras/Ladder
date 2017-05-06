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
    
    private init() {}
    
    func fetchAllUsers() -> [User] {
        if self.users.isEmpty {
            let moc = UIApplication.shared.managedObjectContext
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
            do {
                let users = try moc.fetch(fetchRequest) as! [User]
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
