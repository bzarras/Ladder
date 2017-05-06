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
    
    lazy var noteField: PaddedTextField = {
        let textField = PaddedTextField()
        textField.placeholder = "Add note"
        textField.layer.cornerRadius = 31 / 2 // 31 is the frame height of the text field
        textField.backgroundColor = .white
        textField.layer.borderWidth = 0.5
        textField.layer.borderColor = UIColor.lightGray.cgColor
        textField.returnKeyType = .done
        textField.delegate = self
        return textField
    }()
    
    lazy var noteFieldContainer: UIView = {
        let noteFieldContainer = UIView()
        noteFieldContainer.backgroundColor = .greyBackground
        noteFieldContainer.addSubviews([self.noteField])
        noteFieldContainer.addConstraints(withVisualFormat: "|-[note]-|", views: ["note": self.noteField])
        noteFieldContainer.addConstraints(withVisualFormat: "V:|-[note]-|", views: ["note": self.noteField])
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
        self.navigationItem.titleView = UIImageView(image: #imageLiteral(resourceName: "logo"))
        let rightItem = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(self.didTapEdit))
        rightItem.tintColor = .white
        self.navigationItem.setRightBarButton(rightItem, animated: true)
        
        // Keyboard Avoiding
        self.bottomConstraint = NSLayoutConstraint(item: self.noteFieldContainer, attribute: .bottom, relatedBy: .equal, toItem: self.bottomLayoutGuide, attribute: .top, multiplier: 1, constant: 0)
        self.keyboardAvoidingVC = self
        
        self.view.backgroundColor = .white
        self.view.addSubviews([self.tableView, self.noteFieldContainer])
        self.view.addConstraints(withVisualFormat: "V:|[table][input][bottom]", views: ["table": self.tableView, "input": self.noteFieldContainer, "bottom": self.bottomLayoutGuide])
        
        if let noteViewContainerBottomConstraint = self.bottomConstraint {
            self.view.addConstraint(noteViewContainerBottomConstraint)
        }
        self.view.addConstraints(withVisualFormat: "|[table]|", views: ["table": self.tableView])
        self.view.addConstraints(withVisualFormat: "|[noteField]|", views: ["noteField": self.noteFieldContainer])
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(notification:)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide(notification:)), name: .UIKeyboardWillHide, object: nil)
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
    
    func keyboardWillShow(notification: NSNotification) {
        print("keyboard will show")
    }
    
    func keyboardWillHide(notification: NSNotification) {
        print("keyboard will hide")
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

extension ProfileViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
