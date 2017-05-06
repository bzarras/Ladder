//
//  UIView+Utils.swift
//  Ladder
//
//  Created by BZ Logic9s on 1/22/17.
//  Copyright © 2017 Ladder. All rights reserved.
//

import UIKit

extension UIView {
    
    static let commonMargin: CGFloat = 16
    
    func addSubviews(_ views: [UIView]) {
        views.forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            self.addSubview($0)
        }
    }
    
    func addConstraints(withVisualFormat vfl: String, views: [String: Any]) {
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: vfl, options: [], metrics: nil, views: views))
    }
    
}

extension NSLayoutConstraint {
    
    static func constraints(withVisualFormat vfl: String, views: [String: Any]) -> [NSLayoutConstraint] {
        return NSLayoutConstraint.constraints(withVisualFormat: vfl, options: [], metrics: nil, views: views)
    }
    
    convenience init(item view1: Any, attribute attribute1: NSLayoutAttribute, relatedBy: NSLayoutRelation, toItem view2: Any, attribute attribute2: NSLayoutAttribute) {
        self.init(item: view1, attribute: attribute1, relatedBy: relatedBy, toItem: view2, attribute: attribute2, multiplier: 1, constant: 0)
    }
}
