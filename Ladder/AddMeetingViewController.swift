//
//  AddMeetingViewController.swift
//  Ladder
//
//  Created by BZ Logic9s on 11/20/17.
//  Copyright © 2017 Ladder. All rights reserved.
//

import Foundation
import UIKit

class AddMeetingViewController: UIViewController {
    
    private lazy var datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .dateAndTime
        return datePicker
    }()
    
    private lazy var titleInput: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Title"
        return textField
    }()
    
    private lazy var descriptionInput: UITextView = {
        let textView = UITextView()
        return textView
    }()
    
    private lazy var stackContainer: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [self.titleInput, self.datePicker, self.descriptionInput])
        stack.axis = .vertical
        stack.distribution = .equalSpacing
        stack.alignment = .leading
        return stack
    }()
    
    override func viewDidLoad() {
        self.title = "Add Meeting"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(self.didTapDone))
        self.view.addSubviews([self.stackContainer])
        self.view.make(subviews: [self.stackContainer], flushAlongAxes: [.horizontal, .vertical], withPadding: 8)
    }
    
    // MARK: - Actions
    
    @objc func didTapDone() {
        // will want to gather up the input data here and make a new meeting instance
        self.navigationController?.popViewController(animated: true)
    }
 }
