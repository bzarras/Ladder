//
//  ProfileViewController.swift
//  Ladder
//
//  Created by BZ Logic9s on 1/22/17.
//  Copyright © 2017 Ladder. All rights reserved.
//

import UIKit
import CoreData
import DateToolsSwift

class ProfileViewController: UIViewController {
    
    fileprivate enum Section: Int {
        case profile
        case notes
        static let all = [profile, notes]
    }
    
    fileprivate let notePlaceholder = "Add note"
    fileprivate let noteInputHeight: CGFloat = 31
    
    var user: User?
    var userIsSelf: Bool {
        return self.user?.id == "self"
    }
    
    lazy var profileView: ProfileView = {
        return ProfileView(frame: .zero)
    }()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.separatorStyle = .none
        tableView.backgroundColor = .greyBackground
        return tableView
    }()
    
    lazy var addNoteButton: UIButton = {
        let button = UIButton()
        button.setTitle("Add Note", for: .normal)
        button.setTitleColor(UIColor.mainApp, for: .normal)
        button.addTarget(self, action: #selector(didTapAddNote), for: .touchUpInside)
        return button
    }()
    
    required init(forUser user: User?) {
        self.user = user
        super.init(nibName: nil, bundle: nil)
        self.commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func commonInit() {
        self.title = "Profile"
        self.tabBarItem = UITabBarItem(title: "Profile", image: #imageLiteral(resourceName: "profile"), tag: 3)
        if self.user == nil {
            self.user = UsersService.shared.fetchUserIdentity()
        }
    }
    
    override func viewDidLoad() {
        if self == self.navigationController?.viewControllers.first { // show app logo if we got here directly from the home screen
            self.navigationItem.titleView = UIImageView(image: #imageLiteral(resourceName: "logo-green"))
        } else {
            self.navigationItem.title = "Contact"
        }
        let rightItem = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(self.didTapEdit))
        rightItem.tintColor = .mainApp
        self.navigationItem.setRightBarButton(rightItem, animated: true)
        
        self.view.backgroundColor = .greyBackground
        self.view.addSubviews([self.tableView, self.addNoteButton])
        self.view.addConstraints(withVisualFormat: "V:|[table][button][bottom]", views: ["table": self.tableView, "button": self.addNoteButton, "bottom": self.bottomLayoutGuide])
        self.view.addConstraints(withVisualFormat: "|[table]|", views: ["table": self.tableView])
        self.view.addConstraint(NSLayoutConstraint(item: self.addNoteButton, attribute: .centerX, relatedBy: .equal, toItem: self.view, attribute: .centerX))
        self.addNoteButton.isHidden = self.userIsSelf
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard let user = self.user else { return }
        ProfileView.configure(profileView: self.profileView, withUser: user)
        self.tableView.reloadData()
    }
    
    // MARK: - Actions
    
    func didTapEdit() {
        let vc = AddContactViewController(user: self.user)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func didTapAddNote() {
        let vc = AddNoteViewController()
        vc.delegate = self
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

// MARK: - UITableViewDelegate and DataSource

extension ProfileViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return Section.all.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let section = Section(rawValue: section) else { preconditionFailure() }
        switch section {
        case .profile:
            return 1
        case .notes:
            return user?.notes?.count ?? 0
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let section = Section(rawValue: section) else { preconditionFailure() }
        switch section {
        case .profile: return nil
        case .notes:
            return self.userIsSelf ? nil : TableHeaderView(text: "Notes")
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        guard let section = Section(rawValue: section) else { preconditionFailure() }
        switch section {
        case .profile: return 0
        case .notes:
            return self.userIsSelf ? 0 : TableHeaderView.font.lineHeight + CardTableViewCell.margin
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let section = Section(rawValue: indexPath.section) else { preconditionFailure() }
        switch section {
        case .profile:
            let identifier = "profile"
            let profileCell = tableView.dequeueReusableCell(withIdentifier: identifier) ?? UITableViewCell(style: .subtitle, reuseIdentifier: identifier)
            profileCell.contentView.addSubviews([self.profileView])
            profileCell.contentView.addConstraints(withVisualFormat: "|[v]|", views: ["v": self.profileView])
            profileCell.contentView.addConstraints(withVisualFormat: "V:|[v]|", views: ["v": self.profileView])
            return profileCell
        case .notes:
            guard let note = user?.notes?.reversed[indexPath.row] as? Note else { preconditionFailure() }
            let identifier = "note"
            let noteCell = tableView.dequeueReusableCell(withIdentifier: identifier) as? ActivityTableViewCell ?? ActivityTableViewCell(reuseIdentifier: identifier)
            noteCell.headerLabel.text = "You said"
            noteCell.bodyLabel.text = note.body
            noteCell.timestampLabel.text = (note.timestamp as Date?)?.timeAgoSinceNow
            return noteCell
        }
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        guard let section = Section(rawValue: indexPath.section), section == .notes else { return nil }
        let deleteAction = UITableViewRowAction(style: UITableViewRowActionStyle.destructive, title: "Delete") { (action, indexPath) in
            guard let note = self.user?.notes?.reversed[indexPath.row] as? Note else { return }
            self.user?.removeFromNotes(note)
            UIApplication.shared.managedObjectContext.delete(note)
            UIApplication.shared.saveAndReportErrors()
            self.tableView.reloadData()
        }
        return [deleteAction]
    }
    
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return false
    }
}

// MARK: - AddNoteDelegate

extension ProfileViewController: AddNoteDelegate {
    func addNoteViewController(didAddNote note: String) {
        let insertedNote = NSEntityDescription.insertNewObject(forEntityName: "Note", into: UIApplication.shared.managedObjectContext) as! Note
        insertedNote.body = note
        insertedNote.timestamp = NSDate()
        user?.addToNotes(insertedNote)
        UIApplication.shared.saveAndReportErrors()
        self.tableView.reloadData()
    }
}
