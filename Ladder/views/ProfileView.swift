//
//  ProfileView.swift
//  Ladder
//
//  Created by BZ Logic9s on 1/22/17.
//  Copyright © 2017 Ladder. All rights reserved.
//

import UIKit

class ProfileView: UIView {
    
    private let imageDimension: CGFloat = 90
    
    lazy var image: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        // make image round
        imageView.layer.masksToBounds = false
        imageView.layer.cornerRadius = self.imageDimension / 2
        imageView.clipsToBounds = true
        return imageView
    }()
    
    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = .bigAppFont
        label.textColor = .black
        return label
    }()
    
    lazy var detailsStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .fill
        stack.distribution = .equalSpacing
        stack.spacing = 5
        return stack
    }()
    
    lazy var detailLabelsStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .trailing
        stack.distribution = .fillEqually
        stack.spacing = 5
        return stack
    }()
    
    let companyLabel = UILabel()
    let titleLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        self.layer.shadowOpacity = 0.6
        self.layer.shadowColor = UIColor.lightGray.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 1)
        self.layer.shadowRadius = 1
        
        [self.companyLabel, self.titleLabel].forEach {
            $0.font = .mediumAppFont
            $0.textColor = .darkGray
        }
        
        self.addSubviews([self.image, self.nameLabel, self.companyLabel, self.titleLabel, self.detailLabelsStack, self.detailsStack])
        
        let viewDict: [String: UIView] = [
            "image": self.image,
            "name": self.nameLabel,
            "title": self.titleLabel,
            "company": self.companyLabel,
            "detailLabels": self.detailLabelsStack,
            "details": self.detailsStack
        ]
        self.addConstraints(withVisualFormat: "|-\(UIView.commonMargin)-[image(\(self.imageDimension))]", views: viewDict)
        self.addConstraints(withVisualFormat: "V:|-\(UIView.commonMargin)-[image(\(self.imageDimension))]", views: viewDict)
        self.addConstraint(NSLayoutConstraint(item: self.nameLabel, attribute: .top, relatedBy: .equal, toItem: self.image, attribute: .top))
        self.addConstraints(withVisualFormat: "[image]-\(UIView.commonMargin)-[name]", views: viewDict)
        self.addConstraints(withVisualFormat: "[image]-\(UIView.commonMargin)-[company]", views: viewDict)
        self.addConstraints(withVisualFormat: "[image]-\(UIView.commonMargin)-[title]", views: viewDict)
        self.addConstraints(withVisualFormat: "V:[name]-10-[company]-5-[title]", views: viewDict)
        self.addConstraints(withVisualFormat: "|-\(UIView.commonMargin)-[detailLabels(90)]-\(UIView.commonMargin)-[details]|", views: viewDict)
        self.addConstraint(NSLayoutConstraint(item: self.detailLabelsStack, attribute: .top, relatedBy: .equal, toItem: self.detailsStack, attribute: .top))
        self.addConstraint(NSLayoutConstraint(item: self.detailLabelsStack, attribute: .height, relatedBy: .equal, toItem: self.detailsStack, attribute: .height))
        self.addConstraints(withVisualFormat: "V:[image]-\(UIView.commonMargin * 2)-[details]-\(UIView.commonMargin)-|", views: viewDict)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
