//
//  AddNoteViewController.swift
//  Ladder
//
//  Created by BZ Logic9s on 7/3/17.
//  Copyright © 2017 Ladder. All rights reserved.
//

import UIKit

protocol AddNoteDelegate: AnyObject {
    func addNoteViewController(didAddNote: String)
}

class AddNoteViewController: UIViewController {
    
    lazy var textView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.smallAppFont
        textView.textColor = .black
        textView.backgroundColor = .white
        textView.textContainerInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        textView.returnKeyType = .default
        textView.delegate = self
        return textView
    }()
    weak var delegate: AddNoteDelegate?
    
    override func viewDidLoad() {
        self.title = "Add Note"
        
        let rightItem = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.plain, target: self, action: #selector(didTapDone))
        self.navigationItem.setRightBarButton(rightItem, animated: true)
        
        self.view.addSubviews([self.textView])
        self.view.addConstraints(withVisualFormat: "|[textView]|", views: ["textView": self.textView])
        self.view.addConstraints(withVisualFormat: "V:[top][text][bottom]", views: ["top": self.topLayoutGuide, "text": self.textView, "bottom": self.bottomLayoutGuide])
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.textView.becomeFirstResponder()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.textView.resignFirstResponder()
    }
    
    // MARK: - Private
    
    @objc func didTapDone() {
        let resigned = self.textView.resignFirstResponder()
        guard resigned else { return }
        self.navigationController?.popViewController(animated: true)
    }
}

extension AddNoteViewController: UITextViewDelegate {
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        return true
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        guard !textView.text.trimmingCharacters(in: .whitespaces).isEmpty else { return }
        self.delegate?.addNoteViewController(didAddNote: textView.text)
    }
}
