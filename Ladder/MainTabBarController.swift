//
//  MainTabBarController.swift
//  Ladder
//
//  Created by BZ Logic9s on 1/22/17.
//  Copyright © 2017 Ladder. All rights reserved.
//

import UIKit

class MainTabBarController: UITabBarController {
    
    var activityViewController = ActivityViewController()
    var updatesViewController = UpdatesViewController()
    var profileViewController = ProfileViewController(forUser: nil)
    var contactsViewController = ContactsViewController()
    
    override func viewDidLoad() {
        self.tabBar.tintColor = UIColor.mainApp
        let activityNavController = UINavigationController(rootViewController: self.activityViewController)
        let updatesNavController = UINavigationController(rootViewController: self.updatesViewController)
        let profileNavController = UINavigationController(rootViewController: self.profileViewController)
        let contactsNavController = UINavigationController(rootViewController: self.contactsViewController)
        let navControllers = [activityNavController, updatesNavController, contactsNavController, profileNavController]
        navControllers.forEach {
            $0.navigationBar.barStyle = .default
            $0.navigationBar.isTranslucent = false
            $0.navigationBar.tintColor = .mainApp
        }
        self.setViewControllers(navControllers, animated: true)
        self.selectedViewController = contactsNavController
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}
