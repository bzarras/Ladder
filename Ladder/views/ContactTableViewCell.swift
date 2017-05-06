//
//  ContactTableViewCell.swift
//  Ladder
//
//  Created by BZ Logic9s on 3/5/17.
//  Copyright © 2017 Ladder. All rights reserved.
//

import UIKit

class ContactTableViewCell: UITableViewCell {
    
    lazy var cardView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 2
        // might want to ditch the shadow
        view.layer.shadowOpacity = 0.6
        view.layer.shadowColor = UIColor.lightGray.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 1)
        view.layer.shadowRadius = 1
        return view
    }()
    
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
    
    init(reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        
        self.cardView.addSubviews([self.avatar, self.nameLabel, self.companyLabel, self.jobTitleLabel])
        let views: [String: Any] = ["image": self.avatar, "name": self.nameLabel, "company": self.companyLabel, "job": self.jobTitleLabel]
        self.cardView.addConstraints(withVisualFormat: "|-\(UIView.commonMargin)-[image]", views: views)
        self.cardView.addConstraints(withVisualFormat: "[image]-\(UIView.commonMargin)-[name]", views: views)
        self.cardView.addConstraints(withVisualFormat: "[image]-\(UIView.commonMargin)-[company]", views: views)
        self.cardView.addConstraints(withVisualFormat: "[image]-\(UIView.commonMargin)-[job]", views: views)
        self.cardView.addConstraints(withVisualFormat: "V:|-\(UIView.commonMargin)-[image]", views: views)
        self.cardView.addConstraint(NSLayoutConstraint(item: self.nameLabel, attribute: .top, relatedBy: .equal, toItem: self.avatar, attribute: .top))
        self.cardView.addConstraints(withVisualFormat: "V:[name]-10-[company]-5-[job]-\(UIView.commonMargin)-|", views: views)
        
        self.backgroundColor = .greyBackground
        self.contentView.addSubviews([self.cardView])
        self.contentView.addConstraints(withVisualFormat: "|-10-[container]-10-|", views: ["container": self.cardView])
        self.contentView.addConstraints(withVisualFormat: "V:|-5-[container]-5-|", views: ["container": self.cardView])
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
