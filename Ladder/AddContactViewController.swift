//
//  AddContactViewController.swift
//  Ladder
//
//  Created by BZ Logic9s on 3/5/17.
//  Copyright © 2017 Ladder. All rights reserved.
//

import UIKit

class AddContactViewController: UIViewController {
    
    fileprivate lazy var firstnameField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "First name"
        return textField
    }()
    
    fileprivate lazy var lastnameField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Last name"
        return textField
    }()
    
    fileprivate lazy var companyField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Company"
        return textField
    }()
    
    fileprivate lazy var titleField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Title"
        return textField
    }()
    
    fileprivate lazy var schoolField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Education"
        return textField
    }()
    
    fileprivate lazy var emailField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Email"
        textField.keyboardType = .emailAddress
        return textField
    }()
    
    fileprivate lazy var phoneField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Phone"
        textField.keyboardType = .numbersAndPunctuation
        return textField
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .equalSpacing
        stackView.spacing = UIView.commonMargin
        return stackView
    }()
    
    fileprivate var user: User?
    
    required init(user: User? = nil) {
        self.user = user
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        self.title = "Add Contact"
        self.navigationItem.setRightBarButton(UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(self.didTapDone)), animated: true)
        self.navigationItem.setLeftBarButton(UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(self.didTapCancel)), animated: true)
        self.navigationController?.navigationBar.tintColor = .white
        self.view.backgroundColor = .white
        
        UIApplication.shared.saveAndReportErrors()
        if let user = self.user {
            self.title = "Edit Contact"
            self.populateFields(forUser: user)
        } else {
            self.user = UsersService.shared.createNewUser()
        }
        
        [self.firstnameField, self.lastnameField, self.companyField, self.titleField, self.schoolField, self.emailField, self.phoneField].forEach {
            $0.delegate = self
            $0.returnKeyType = .next
            self.stackView.addArrangedSubview($0)
        }
        
        self.view.addSubviews([self.stackView])
        self.view.addConstraints(withVisualFormat: "|-\(UIView.commonMargin)-[stack]-\(UIView.commonMargin)-|", views: ["stack": self.stackView])
        self.view.addConstraints(withVisualFormat: "V:[top]-\(UIView.commonMargin)-[stack]", views: ["top": self.topLayoutGuide, "stack": self.stackView])
    }
    
    func populateFields(forUser user: User) {
        self.firstnameField.text = user.firstname
        self.lastnameField.text = user.lastname
        self.companyField.text = user.company
        self.titleField.text = user.title
        self.schoolField.text = user.school
        self.emailField.text = user.email1
        self.phoneField.text = user.phone
    }
    
    // MARK: - Actions
    
    func didTapDone() {
        let firstResponder = self.stackView.arrangedSubviews.filter { return $0.isFirstResponder }.first
        if let textField = firstResponder as? UITextField {
            let _ = self.textFieldShouldReturn(textField)
            self.textFieldDidEndEditing(textField)
        }
        guard let _ = user?.firstname, let _ = user?.lastname else {
            UsersService.shared.rollback()
            let _ = self.navigationController?.popViewController(animated: true)
            return
        }
        UsersService.shared.save()
        let _ = self.navigationController?.popViewController(animated: true)
    }
    
    func didTapCancel() {
        UsersService.shared.rollback()
        let _ = self.navigationController?.popViewController(animated: true)
    }
}

extension AddContactViewController: UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let text = textField.text?.trimmingCharacters(in: .whitespacesAndNewlines), !text.characters.isEmpty else { return }
        switch textField {
        case self.firstnameField:
            self.user?.firstname = text
        case self.lastnameField:
            self.user?.lastname = text
        case self.emailField:
            self.user?.email1 = text
        case self.companyField:
            self.user?.company = text
        case self.titleField:
            self.user?.title = text
        case self.schoolField:
            self.user?.school = text
        case self.phoneField:
            self.user?.phone = text
        default:()
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let text = textField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        switch textField {
        case self.firstnameField:
            if let chars = text?.characters, chars.isEmpty {
                let alert = UIAlertController(title: "Whoops", message: "First name is a required field", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { action in
                    alert.dismiss(animated: true, completion: nil)
                }))
                self.present(alert, animated: true, completion: nil)
                return false
            } else {
                self.lastnameField.becomeFirstResponder()
            }
        case self.lastnameField:
            if let chars = text?.characters, chars.isEmpty {
                let alert = UIAlertController(title: "Whoops", message: "Last name is a required field", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { action in
                    alert.dismiss(animated: true, completion: nil)
                }))
                self.present(alert, animated: true, completion: nil)
                return false
            } else {
                self.companyField.becomeFirstResponder()
            }
        case self.companyField:
            self.titleField.becomeFirstResponder()
        case self.titleField:
            self.schoolField.becomeFirstResponder()
        case self.schoolField:
            self.emailField.becomeFirstResponder()
        case self.emailField:
            self.phoneField.becomeFirstResponder()
        default:()
        }
        textField.resignFirstResponder()
        return true
    }
}
