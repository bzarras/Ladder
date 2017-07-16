//
//  ContactTableViewCell.swift
//  Ladder
//
//  Created by BZ Logic9s on 3/5/17.
//  Copyright © 2017 Ladder. All rights reserved.
//

import UIKit

class ContactTableViewCell: CardTableViewCell {
    
    lazy var avatar: UIImageView = {
        let imageView = UIImageView(image: #imageLiteral(resourceName: "avatar"))
        return imageView
    }()
    
    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20)
        return label
    }()
    
    lazy var companyLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.darkGray
        return label
    }()
    
    lazy var jobTitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.darkGray
        return label
    }()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        self.cardView.addSubviews([self.avatar, self.nameLabel, self.companyLabel, self.jobTitleLabel])
        let views: [String: Any] = ["image": self.avatar, "name": self.nameLabel, "company": self.companyLabel, "job": self.jobTitleLabel]
        self.cardView.addConstraints(withVisualFormat: "|-\(UIView.commonMargin)-[image]", views: views)
        self.cardView.addConstraints(withVisualFormat: "[image]-\(UIView.commonMargin)-[name]", views: views)
        self.cardView.addConstraints(withVisualFormat: "[image]-\(UIView.commonMargin)-[company]", views: views)
        self.cardView.addConstraints(withVisualFormat: "[image]-\(UIView.commonMargin)-[job]", views: views)
        self.cardView.addConstraints(withVisualFormat: "V:|-\(UIView.commonMargin)-[image]", views: views)
        self.cardView.addConstraint(NSLayoutConstraint(item: self.nameLabel, attribute: .top, relatedBy: .equal, toItem: self.avatar, attribute: .top))
        self.cardView.addConstraints(withVisualFormat: "V:[name]-10-[company]-5-[job]-\(UIView.commonMargin)-|", views: views)
    }
    
    override func prepareForReuse() {
        [self.nameLabel, self.companyLabel, self.jobTitleLabel].forEach {
            $0.text = nil
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
