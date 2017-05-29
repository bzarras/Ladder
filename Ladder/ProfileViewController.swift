//
//  ProfileViewController.swift
//  Ladder
//
//  Created by BZ Logic9s on 1/22/17.
//  Copyright © 2017 Ladder. All rights reserved.
//

import UIKit
import CoreData

class ProfileViewController: UIViewController, KeyboardAvoiding {
    
    fileprivate enum Section: Int {
        case profile
        case notes
        static let all = [profile, notes]
    }
    
    fileprivate let notePlaceholder = "Add note"
    fileprivate let noteInputHeight: CGFloat = 31
    
    var user: User?
    
    lazy var profileView: ProfileView = {
        let profileView = ProfileView(frame: .zero)
        profileView.image.image = #imageLiteral(resourceName: "example-profile-pic")
        profileView.nameLabel.text = "Ben Zarras"
        profileView.titleLabel.text = "Software Engineer"
        return profileView
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
    
    // I can't get the event when the return key is tapped, so I will need to make a custom subclass that has a "done" button in the corner of the text view, like in messages
    // I should also subclass the textview delegate class to have a method that gets called when the done button is pressed, then override the text view's delegate with that custom one
    lazy var noteInputView: UITextView = {
        let textView = UITextView()
        textView.text = self.notePlaceholder
        textView.font = UIFont.smallAppFont
        textView.textColor = .lightGray
        textView.layer.cornerRadius = self.noteInputHeight / 2
        textView.backgroundColor = .white
        textView.layer.borderWidth = 0.5
        textView.layer.borderColor = UIColor.lightGray.cgColor
        textView.textContainerInset = UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)
        textView.returnKeyType = .default
        textView.delegate = self
        return textView
    }()
    
    lazy var noteViewContainer: UIView = {
        let noteFieldContainer = UIView()
        noteFieldContainer.backgroundColor = .greyBackground
        noteFieldContainer.addSubviews([self.noteInputView])
        noteFieldContainer.addConstraints(withVisualFormat: "|-[note]-|", views: ["note": self.noteInputView])
        noteFieldContainer.addConstraints(withVisualFormat: "V:|-[note(31)]-|", views: ["note": self.noteInputView])
        return noteFieldContainer
    }()
    
    var bottomConstraint: NSLayoutConstraint?
    weak var keyboardAvoidingVC: UIViewController?
    
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
    }
    
    override func viewDidLoad() {
        self.navigationItem.titleView = UIImageView(image: #imageLiteral(resourceName: "logo-green"))
        let rightItem = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(self.didTapEdit))
        rightItem.tintColor = .mainApp
        self.navigationItem.setRightBarButton(rightItem, animated: true)
        
        // Keyboard Avoiding
        self.bottomConstraint = NSLayoutConstraint(item: self.noteViewContainer, attribute: .bottom, relatedBy: .equal, toItem: self.bottomLayoutGuide, attribute: .top, multiplier: 1, constant: 0)
        self.keyboardAvoidingVC = self
        
        self.view.backgroundColor = .white
        self.view.addSubviews([self.tableView, self.noteViewContainer])
        self.view.addConstraints(withVisualFormat: "V:|[table][input]", views: ["table": self.tableView, "input": self.noteViewContainer])
        
        if let noteViewContainerBottomConstraint = self.bottomConstraint {
            self.view.addConstraint(noteViewContainerBottomConstraint)
        }
        self.view.addConstraints(withVisualFormat: "|[table]|", views: ["table": self.tableView])
        self.view.addConstraints(withVisualFormat: "|[noteField]|", views: ["noteField": self.noteViewContainer])
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let user = self.user {
            ProfileView.configure(profileView: self.profileView, withUser: user)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.startKeyboardAvoiding()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        self.stopKeyboardAvoiding()
    }
    
    // MARK: - Actions
    
    func didTapEdit() {
        let vc = AddContactViewController(user: self.user)
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension ProfileViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return Section.all.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let section = Section(rawValue: section) else { preconditionFailure() }
        switch section {
        case .profile:
            return 1
        default:
            return 0 // fix this later
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
        default:
            return UITableViewCell(style: .subtitle, reuseIdentifier: "THIS_IS_A_PLACEHOLDER") // COME BACK TO THIS LATER
        }
    }
    
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        guard let section = Section(rawValue: indexPath.section) else { preconditionFailure() }
        return section != .profile
    }
}

extension ProfileViewController: UITextViewDelegate {
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        return true
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        self.showPlaceholderIfNeeded(for: textView, editingBegan: true)
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        self.showPlaceholderIfNeeded(for: textView, editingBegan: false)
    }
    
    private func showPlaceholderIfNeeded(for textView: UITextView, editingBegan: Bool) {
        if editingBegan {
            guard textView.textColor == .lightGray else { return }
            textView.text = nil
            textView.textColor = .black
        } else {
            guard textView.text == nil else { return }
            textView.text = self.notePlaceholder
            textView.textColor = .lightGray
        }
    }
}
