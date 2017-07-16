//
//  ActivityTableViewCell.swift
//  Ladder
//
//  Created by BZ Logic9s on 6/4/17.
//  Copyright © 2017 Ladder. All rights reserved.
//

import UIKit

class ActivityTableViewCell: CardTableViewCell {
    
    lazy var headerLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = UIColor.lightGray
        label.textAlignment = .left
        label.numberOfLines = 1
        label.lineBreakMode = .byTruncatingTail
        return label
    }()
    
    lazy var timestampLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = UIColor.lightGray
        label.textAlignment = .right
        label.numberOfLines = 1
        label.lineBreakMode = .byTruncatingMiddle
        return label
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.mediumAppFont
        label.textColor = UIColor.black
        label.textAlignment = .left
        label.numberOfLines = 1
        label.lineBreakMode = .byTruncatingTail
        return label
    }()
    
    lazy var bodyLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.mediumAppFont
        label.textColor = UIColor.darkGray
        label.textAlignment = .left
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    private lazy var stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .leading
        stack.distribution = .equalSpacing
        return stack
    }()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        self.cardView.addSubviews([self.headerLabel, self.timestampLabel, self.stackView])
        self.cardView.addConstraints(withVisualFormat: "|-[header]", views: ["header": self.headerLabel])
        self.cardView.addConstraints(withVisualFormat: "[time]-|", views: ["time": self.timestampLabel])
        [self.headerLabel, self.timestampLabel].forEach { self.cardView.addConstraints(withVisualFormat: "V:|-8-[v]", views: ["v": $0]) }
        self.cardView.addConstraints(withVisualFormat: "|-[stack]-|", views: ["stack": self.stackView])
        self.cardView.addConstraints(withVisualFormat: "V:[header]-16-[stack]-8-|", views: ["header": self.headerLabel, "stack": self.stackView])
        
        self.stackView.addArrangedSubview(self.titleLabel)
        self.stackView.addArrangedSubview(self.bodyLabel)
    }
    
    override func prepareForReuse() {
        self.headerLabel.text = nil
        self.timestampLabel.text = nil
        self.titleLabel.text = nil
        self.bodyLabel.text = nil
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
