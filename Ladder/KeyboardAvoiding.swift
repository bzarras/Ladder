//
//  KeyboardAvoiding.swift
//  Ladder
//
//  Created by BZ Logic9s on 5/6/17.
//  Copyright © 2017 Ladder. All rights reserved.
//

import UIKit

protocol KeyboardAvoiding {
    var bottomConstraint: NSLayoutConstraint? { get set }
    weak var keyboardAvoidingVC: UIViewController? { get set }
}

protocol KeyboardAvoidingWithScrollView: KeyboardAvoiding {
    var scrollView: UIScrollView? { get }
}

extension KeyboardAvoiding {
    func keyboardWillChange(_ notification: Notification) {
        guard let vc = keyboardAvoidingVC,
            let keyboardFrame = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
        else { return }
        let duration = TimeInterval((notification.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber)?.floatValue ?? 0)
        if keyboardFrame.origin.y < UIScreen.main.bounds.height {
            self.bottomConstraint?.constant = -(keyboardFrame.height - vc.bottomLayoutGuide.length)
        } else {
            self.bottomConstraint?.constant = 0
        }
        
        if let _ = self.bottomConstraint {
            UIView.animate(withDuration: duration, animations: {
                vc.view.layoutIfNeeded()
            })
        }
        
        let newFrame = vc.view.convert(keyboardFrame, from: UIApplication.shared.delegate?.window ?? nil)
        if let keyboardAvoidingWithScrollView = self as? KeyboardAvoidingWithScrollView {
            keyboardAvoidingWithScrollView.scrollView?.contentInset.bottom = abs(newFrame.origin.y - vc.view.frame.height)
        }
    }
    
    func startKeyboardAvoiding() {
        NotificationCenter.default.addObserver(forName: Notification.Name.UIKeyboardWillChangeFrame, object: nil, queue: nil, using: self.keyboardWillChange(_:))
    }
    
    func stopKeyboardAvoiding() {
        NotificationCenter.default.removeObserver(self, name: Notification.Name.UIKeyboardWillChangeFrame, object: nil)
    }
}
