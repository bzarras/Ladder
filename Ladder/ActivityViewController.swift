//
//  ActivityViewController.swift
//  Ladder
//
//  Created by BZ Logic9s on 3/18/17.
//  Copyright © 2017 Ladder. All rights reserved.
//

import UIKit
import DateToolsSwift

class ActivityViewController: UIViewController {
    
    fileprivate var showsEmptyState: Bool {
        return self.activityService.fetchedResultsController.fetchedObjects?.isEmpty ?? true
    }
    
    fileprivate var activityService = ActivityService()
    
    fileprivate lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.estimatedRowHeight = 100 // need this for the rows to initially size themselves correctly
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.separatorStyle = .none
        tableView.contentInset = UIEdgeInsets(top: CardTableViewCell.margin/2, left: 0, bottom: CardTableViewCell.margin/2, right: 0) // 4 is to compensate for half-padding on top cell and bottom cell
        tableView.backgroundColor = .greyBackground
        tableView.sectionIndexColor = .mainApp
        tableView.sectionIndexBackgroundColor = .greyBackground
        tableView.showsVerticalScrollIndicator = false
        return tableView
    }()
    
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
        self.view.addSubviews([self.tableView])
        let views: [String: Any] = ["top": self.topLayoutGuide, "table": self.tableView, "bottom": self.bottomLayoutGuide]
        self.view.addConstraints(withVisualFormat: "|[table]|", views: views)
        self.view.addConstraints(withVisualFormat: "V:|[table]|", views: views)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.activityService.performFetch()
        self.tableView.reloadData()
    }
}

extension ActivityViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        tableView.isScrollEnabled = !self.showsEmptyState
        return self.showsEmptyState ? 1 : (self.activityService.fetchedResultsController.sections?.count ?? 0)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.showsEmptyState ? 1 : (self.activityService.fetchedResultsController.fetchedObjects?.count ?? 0)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if self.showsEmptyState {
            let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "empty")
            let message = UILabel()
            message.text = "No activity yet.\n\nAdd a contact\nto see activity."
            message.textColor = .lightGray
            message.font = .bigAppFont
            message.numberOfLines = 0
            message.textAlignment = .center
            cell.contentView.addSubviews([message])
            cell.contentView.addConstraint(NSLayoutConstraint(item: message, attribute: .centerX, relatedBy: .equal, toItem: cell.contentView, attribute: .centerX))
            cell.contentView.addConstraints(withVisualFormat: "V:|[message(==\(self.view.bounds.height))]|", views: ["message": message])
            cell.backgroundColor = .greyBackground
            return cell
        } else {
            guard let activity = activityService.fetchedResultsController.object(at: indexPath) as? Activity else { preconditionFailure() }
            let cell = tableView.dequeueReusableCell(withIdentifier: "activity") as? ActivityTableViewCell ?? ActivityTableViewCell(reuseIdentifier: "activity")
            cell.headerLabel.text = activity.header
            cell.timestampLabel.text = (activity.timestamp as Date?)?.timeAgoSinceNow
            cell.titleLabel.text = activity.title
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let activity = activityService.fetchedResultsController.object(at: indexPath) as? Activity else { preconditionFailure() }
        let user = activity.user
        let vc = ProfileViewController(forUser: user)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return !self.showsEmptyState
    }
}
