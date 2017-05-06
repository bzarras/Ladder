//
//  ActivityViewController.swift
//  Ladder
//
//  Created by BZ Logic9s on 3/18/17.
//  Copyright © 2017 Ladder. All rights reserved.
//

import UIKit

class BogusViewController: UIViewController {
    static let shared = BogusViewController()
    
    override func viewDidLoad() {
        self.view.backgroundColor = .clear
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.add, target: self, action: #selector(push))
    }
    
    func push() {
        self.navigationController?.pushViewController(ActivityViewController(), animated: true)
    }
}

class ActivityViewController: UIViewController {
    
    init() {
        super.init(nibName: nil, bundle: nil)
        self.title = "Activity"
        self.navigationItem.titleView = UIImageView(image: #imageLiteral(resourceName: "logo"))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.add, target: self, action: #selector(push)) // just a test
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
    
    func push() {
        self.navigationController?.pushViewController(BogusViewController.shared, animated: true)
    }
}
