//
//  TableHeaderView.swift
//  Ladder
//
//  Created by BZ Logic9s on 7/16/17.
//  Copyright © 2017 Ladder. All rights reserved.
//

import UIKit

class TableHeaderView: UIView {
    
    static let font = UIFont.smallAppFont
    
    var label: UILabel = {
        let label = UILabel()
        label.font = TableHeaderView.font
        label.textColor = UIColor.mainApp
        label.numberOfLines = 1
        label.textAlignment = .left
        label.lineBreakMode = .byTruncatingMiddle
        return label
    }()
    
    init(text: String) {
        self.label.text = text
        super.init(frame: .zero)
        self.addSubviews([self.label])
        let viewDict = ["label": self.label]
        self.addConstraints(withVisualFormat: "|-\(CardTableViewCell.margin)-[label]|", views: viewDict)
        self.addConstraints(withVisualFormat: "V:|-\(CardTableViewCell.margin/2)-[label]-\(CardTableViewCell.margin/2)-|", views: viewDict)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
