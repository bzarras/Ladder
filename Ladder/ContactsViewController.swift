//
//  ContactsViewController.swift
//  Ladder
//
//  Created by BZ Logic9s on 1/22/17.
//  Copyright © 2017 Ladder. All rights reserved.
//

import UIKit

class ContactsViewController: UIViewController {
    
    enum Section: Int {
        case empty
        case loaded
        static var all = [empty, loaded]
    }
    
    fileprivate var contacts: [User] {
        return UsersService.shared.fetchAllUsers()
    }
    
    fileprivate lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.estimatedRowHeight = 100 // need this for the rows to initially size themselves correctly
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.separatorStyle = .none
        tableView.contentInset = UIEdgeInsets(top: 5, left: 0, bottom: 5, right: 0) // 5 is to compensate for half-padding on top cell and bottom cell
        tableView.backgroundColor = UIColor.greyBackground
        tableView.showsVerticalScrollIndicator = false
        return tableView
    }()
    
    override func viewDidLoad() {
        self.title = "Contacts"
        self.tabBarItem = UITabBarItem(title: self.title, image: #imageLiteral(resourceName: "contacts"), tag: 2)
        self.navigationItem.titleView = UIImageView(image: #imageLiteral(resourceName: "logo-green"))
        let rightItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(self.didTapAddContact))
        rightItem.tintColor = .mainApp
        self.navigationItem.setRightBarButton(rightItem, animated: true)
        
        self.view.backgroundColor = .white
        self.view.addSubviews([self.tableView])
        let views: [String: Any] = ["top": self.topLayoutGuide, "table": self.tableView, "bottom": self.bottomLayoutGuide]
        self.view.addConstraints(withVisualFormat: "|[table]|", views: views)
        self.view.addConstraints(withVisualFormat: "V:|[table]|", views: views)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tableView.reloadData()
    }
    
    // MARK: - Actions
    
    func didTapAddContact() {
        self.navigationController?.pushViewController(AddContactViewController(), animated: true)
    }
}

extension ContactsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        tableView.isScrollEnabled = !self.contacts.isEmpty // seems like a fine place to put this
        return Section.all.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let section = Section(rawValue: section) else { preconditionFailure() }
        switch section {
        case .empty:
            return self.contacts.isEmpty ? 1 : 0
        case .loaded:
            return self.contacts.count
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let section = Section(rawValue: indexPath.section) else { preconditionFailure() }
        switch section {
        case .loaded:
            let user = self.contacts[indexPath.row]
            let profileVC = ProfileViewController(forUser: user)
            self.navigationController?.pushViewController(profileVC, animated: true)
        default:()
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let section = Section(rawValue: indexPath.section) else { preconditionFailure() }
        switch section {
        case .empty:
            let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "empty")
            let arrowImageView = UIImageView(image: #imageLiteral(resourceName: "arrow-big"))
            let message = UILabel()
            message.text = "Tap the + to\nadd a contact!"
            message.textColor = .lightGray
            message.font = .bigAppFont
            message.numberOfLines = 0
            message.textAlignment = .center
            cell.contentView.addSubviews([arrowImageView, message])
            cell.contentView.addConstraints([
                NSLayoutConstraint(item: arrowImageView, attribute: .top, relatedBy: .equal, toItem: cell.contentView, attribute: .top, multiplier: 1, constant: UIView.commonMargin),
                NSLayoutConstraint(item: arrowImageView, attribute: .leading, relatedBy: .equal, toItem: cell.contentView, attribute: .centerX),
                NSLayoutConstraint(item: message, attribute: .top, relatedBy: .equal, toItem: arrowImageView, attribute: .bottom, multiplier: 1, constant: UIView.commonMargin),
                NSLayoutConstraint(item: message, attribute: .centerX, relatedBy: .equal, toItem: cell.contentView, attribute: .centerX),
                NSLayoutConstraint(item: message, attribute: .bottom, relatedBy: .equal, toItem: cell.contentView, attribute: .bottom)
            ])
            cell.backgroundColor = .greyBackground
            return cell
        case .loaded:
            let reuseId = "contactCell"
            let cell = tableView.dequeueReusableCell(withIdentifier: reuseId) as? ContactTableViewCell ?? ContactTableViewCell(reuseIdentifier: reuseId)
            let contact = self.contacts[indexPath.row]
            cell.nameLabel.text = "\(contact.firstname ?? "") \(contact.lastname ?? "")"
            cell.companyLabel.text = contact.company
            cell.jobTitleLabel.text = contact.title
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        guard let section = Section(rawValue: indexPath.section) else { preconditionFailure() }
        return section == .loaded
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction(style: UITableViewRowActionStyle.destructive, title: "Delete") { (action, indexPath) in
            let user = self.contacts[indexPath.row]
            UsersService.shared.delete(user: user)
            self.tableView.reloadData()
        }
        return [deleteAction]
    }
    
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        guard let section = Section(rawValue: indexPath.section) else { preconditionFailure() }
        return section == .loaded
    }
}
