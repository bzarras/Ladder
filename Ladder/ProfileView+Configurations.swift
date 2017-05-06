//
//  ProfileView+Configurations.swift
//  Ladder
//
//  Created by BZ Logic9s on 3/4/17.
//  Copyright © 2017 Ladder. All rights reserved.
//

import UIKit

extension ProfileView {
    
    static func configure(profileView: ProfileView, withUser user: User) {
        guard let firstname = user.firstname, let lastname = user.lastname else { return }
        profileView.nameLabel.text = "\(firstname) \(lastname)"
        profileView.image.image = #imageLiteral(resourceName: "avatar-big")
        profileView.companyLabel.text = user.company
        profileView.titleLabel.text = user.title
        
        // clean out any existing views in the stackviews
        profileView.detailsStack.arrangedSubviews.forEach {
            profileView.detailsStack.removeArrangedSubview($0)
            $0.removeFromSuperview()
        }
        profileView.detailLabelsStack.arrangedSubviews.forEach {
            profileView.detailLabelsStack.removeArrangedSubview($0)
            $0.removeFromSuperview()
        }
        
        // add items to the stackviews
        if let school = user.school, !school.characters.isEmpty {
            let title = SmallProfileDetailLabel(withText: "Education")
            let label = ProfileDetailLabel(withText: school)
            profileView.detailsStack.addArrangedSubview(label)
            profileView.detailLabelsStack.addArrangedSubview(title)
        }
        if let email1 = user.email1, !email1.characters.isEmpty {
            let title = SmallProfileDetailLabel(withText: "Email 1")
            let label = ProfileDetailLabel(withText: email1)
            profileView.detailsStack.addArrangedSubview(label)
            profileView.detailLabelsStack.addArrangedSubview(title)
        }
        if let phone = user.phone, !phone.characters.isEmpty {
            let title = SmallProfileDetailLabel(withText: "Phone")
            let label = ProfileDetailLabel(withText: phone)
            profileView.detailsStack.addArrangedSubview(label)
            profileView.detailLabelsStack.addArrangedSubview(title)
        }
    }
    
}

class ProfileDetailLabel: UILabel {
    init(withText text: String?) {
        super.init(frame: .zero)
        self.font = .mediumAppFont
        self.textColor = .darkGray
        self.lineBreakMode = .byWordWrapping
        self.numberOfLines = 0
        self.text = text
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class SmallProfileDetailLabel: UILabel {
    init(withText text: String?) {
        super.init(frame: .zero)
        self.font = .smallAppFont
        self.textColor = .lightGray
        self.text = text
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
