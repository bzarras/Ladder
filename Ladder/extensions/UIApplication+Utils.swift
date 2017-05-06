//
//  UIApplication+Utils.swift
//  Ladder
//
//  Created by BZ Logic9s on 3/5/17.
//  Copyright © 2017 Ladder. All rights reserved.
//

import UIKit
import CoreData

extension UIApplication {
    
    var managedObjectContext: NSManagedObjectContext {
        return (self.delegate as! AppDelegate).persistentContainer.viewContext
    }
    
    func saveAndReportErrors() {
        (self.delegate as! AppDelegate).saveContext()
    }
}
