//
//  ActivityViewController.swift
//  Ladder
//
//  Created by BZ Logic9s on 3/18/17.
//  Copyright © 2017 Ladder. All rights reserved.
//

import UIKit

class ActivityViewController: UIViewController {
    
    init() {
        super.init(nibName: nil, bundle: nil)
        self.title = "Activity"
        self.navigationItem.titleView = UIImageView(image: #imageLiteral(resourceName: "logo-green"))
        self.tabBarItem = UITabBarItem(title: self.title, image: #imageLiteral(resourceName: "home"), tag: 0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        self.view.backgroundColor = .greyBackground
        
        let tempView = UILabel()
        tempView.text = "Activity"
        tempView.textColor = UIColor.lightGray
        tempView.font = UIFont.bigAppFont
        
        self.view.addSubviews([tempView])
        self.view.addConstraints([
            NSLayoutConstraint(item: tempView, attribute: .centerY, relatedBy: .equal, toItem: self.view, attribute: .centerY),
            NSLayoutConstraint(item: tempView, attribute: .centerX, relatedBy: .equal, toItem: self.view, attribute: .centerX)
            ])
    }
}
