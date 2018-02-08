//
//  UserCenterHeaderView.swift
//  https://github.com/xiaopin/weibo-UserCenter.git
//
//  Created by nhope on 2018/2/6.
//  Copyright © 2018年 xiaopin. All rights reserved.
//

import UIKit

class UserCenterHeaderView: UIView {

    let backgroundImageView = UIImageView()
    let avatarImageView = UIImageView()
    let usernameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 15.0)
        label.textColor = UIColor(red: 17/255.0, green: 17/255.0, blue: 17/255.0, alpha: 1.0)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        
        ([backgroundImageView, avatarImageView, usernameLabel] as! [UIView]).forEach {
            self.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        backgroundImageView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        backgroundImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        backgroundImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        backgroundImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        
        let avatarImageSize: CGFloat = 72.0
        avatarImageView.layer.cornerRadius = avatarImageSize * 0.5
        avatarImageView.layer.masksToBounds = true
        avatarImageView.widthAnchor.constraint(equalToConstant: avatarImageSize).isActive = true
        avatarImageView.heightAnchor.constraint(equalToConstant: avatarImageSize).isActive = true
        avatarImageView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        avatarImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        
        usernameLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        usernameLabel.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: 20).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
