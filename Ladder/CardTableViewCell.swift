//
//  CardTableViewCell.swift
//  Ladder
//
//  Created by BZ Logic9s on 6/4/17.
//  Copyright © 2017 Ladder. All rights reserved.
//

import UIKit

class CardTableViewCell: UITableViewCell {
    
    static let margin: CGFloat = 8
    
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
    
    init(reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = .greyBackground
        self.contentView.addSubviews([self.cardView])
        self.contentView.addConstraints(withVisualFormat: "|-\(CardTableViewCell.margin)-[container]-\(CardTableViewCell.margin)-|", views: ["container": self.cardView])
        self.contentView.addConstraints(withVisualFormat: "V:|-\(CardTableViewCell.margin/2)-[container]-\(CardTableViewCell.margin/2)-|", views: ["container": self.cardView])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
