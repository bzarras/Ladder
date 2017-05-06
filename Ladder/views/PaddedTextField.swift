//
//  PaddedTextField.swift
//  Ladder
//
//  Created by BZ Logic9s on 3/25/17.
//  Copyright © 2017 Ladder. All rights reserved.
//

import UIKit

class PaddedTextField: UITextField {
    
    private let padding = UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, padding)
    }
    
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, padding)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, padding)
    }
}
