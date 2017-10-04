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
        case buttons
        case userData
        static let all = [profile, buttons, userData]
    }
    
    private enum UserDataType: Int {
        case notes, meetings
    }
    
    fileprivate let notePlaceholder = "Add note"
    fileprivate let noteInputHeight: CGFloat = 31
    
    var user: User?
    var userIsSelf: Bool {
        return self.user?.id == "self"
    }
    private var currentRowType: UserDataType = .notes {
        didSet {
            self.tableView.reloadSections(IndexSet(integer: Section.userData.rawValue), with: .fade)
        }
    }
    
    lazy var profileView: ProfileView = {
        return ProfileView(frame: .zero)
    }()
    
    lazy var notesToggle: UISegmentedControl = {
        let control = UISegmentedControl()
        control.insertSegment(withTitle: "Notes", at: 0, animated: false)
        control.insertSegment(withTitle: "Meetings", at: 1, animated: false)
        control.selectedSegmentIndex = 0
        control.tintColor = .mainApp
        control.addTarget(self, action: #selector(didToggleNotesOrMeetings), for: .valueChanged)
        return control
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
        let rightItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(self.didTapAdd))
        rightItem.tintColor = .mainApp
        self.navigationItem.setRightBarButton(rightItem, animated: true)
        
        self.view.backgroundColor = .greyBackground
        self.view.addSubviews([self.tableView])
        self.view.addConstraints(withVisualFormat: "V:|[table][bottom]", views: ["table": self.tableView, "bottom": self.bottomLayoutGuide])
        self.view.addConstraints(withVisualFormat: "|[table]|", views: ["table": self.tableView])
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard let user = self.user else { return }
        ProfileView.configure(profileView: self.profileView, withUser: user)
        self.tableView.reloadData()
    }
    
    // MARK: - Actions
    
    @objc func didTapAdd() {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alertController.addAction(UIAlertAction(title: "Add Note", style: .default, handler: { [weak self] action in
            self?.didTapAddNote()
        }))
        alertController.addAction(UIAlertAction(title: "Add Meeting", style: .default, handler: { [weak self] action in
            self?.didTapAddMeeting()
        }))
        alertController.addAction(UIAlertAction(title: "Edit Contact", style: .default, handler: { [weak self] action in
            self?.didTapEdit()
        }))
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alertController.view.tintColor = .mainApp
        self.present(alertController, animated: true, completion: nil)
    }
    
    func didTapEdit() {
        let vc = AddContactViewController(user: self.user)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func didTapAddNote() {
        let vc = AddNoteViewController()
        vc.delegate = self
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func didTapAddMeeting() {
        // TODO: Implement this
    }
    
    @objc func didToggleNotesOrMeetings(segmentedControl: UISegmentedControl) {
        self.currentRowType = UserDataType(rawValue: segmentedControl.selectedSegmentIndex) ?? .notes
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
        case .buttons:
            return 1
        case .userData:
            switch self.currentRowType {
            case .notes:
                return self.user?.notes?.count ?? 0
            case .meetings:
                return self.user?.meetings?.count ?? 0
            }
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let section = Section(rawValue: section) else { preconditionFailure() }
        switch section {
        case .profile: return nil
        case .buttons: return nil
        case .userData:
            return self.userIsSelf ? nil : TableHeaderView(text: self.currentRowType == .notes ? "Notes" : "Meetings")
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        guard let section = Section(rawValue: section) else { preconditionFailure() }
        switch section {
        case .profile: return 0
        case .buttons: return 0
        case .userData:
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
        case .buttons:
            let identifier = "buttons"
            let buttonCell = tableView.dequeueReusableCell(withIdentifier: identifier) ?? UITableViewCell(style: .subtitle, reuseIdentifier: identifier)
            buttonCell.contentView.addSubviews([self.notesToggle])
            buttonCell.contentView.addConstraints(withVisualFormat: "|-[control]-|", views: ["control": self.notesToggle])
            buttonCell.contentView.addConstraints(withVisualFormat: "V:|-[control]-|", views: ["control": self.notesToggle])
            buttonCell.backgroundColor = .greyBackground
            return buttonCell
        case .userData:
            switch self.currentRowType {
            case .notes:
                guard let note = self.user?.notes?.reversed[indexPath.row] as? Note else { preconditionFailure() }
                let identifier = "note"
                let noteCell = tableView.dequeueReusableCell(withIdentifier: identifier) as? ActivityTableViewCell ?? ActivityTableViewCell(reuseIdentifier: identifier)
                noteCell.headerLabel.text = "You said"
                noteCell.bodyLabel.text = note.body
                noteCell.timestampLabel.text = (note.timestamp as Date?)?.timeAgoSinceNow
                return noteCell
            case .meetings:
                // TODO: build a cell here for meetings
                return ActivityTableViewCell(reuseIdentifier: "meetings")
            }
            
        }
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        guard let section = Section(rawValue: indexPath.section), section == .userData else { return nil }
        switch self.currentRowType {
        case .notes:
            let deleteAction = UITableViewRowAction(style: UITableViewRowActionStyle.destructive, title: "Delete") { (action, indexPath) in
                guard let note = self.user?.notes?.reversed[indexPath.row] as? Note else { return }
                self.user?.removeFromNotes(note)
                UIApplication.shared.managedObjectContext.delete(note)
                UIApplication.shared.saveAndReportErrors()
                self.tableView.reloadData()
            }
            return [deleteAction]
        default:
            return nil
        }
        
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
        insertedNote.timestamp = Date()
        self.user?.addToNotes(insertedNote)
        UIApplication.shared.saveAndReportErrors()
        self.tableView.reloadData()
    }
}
