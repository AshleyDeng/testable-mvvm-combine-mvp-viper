//
//  UserTableViewCell.swift
//  testable-mvvm-mvp-viper
//
//  Created by Ashley Deng on 2021-05-03.
//

import UIKit

protocol UserFollowDelegate: AnyObject {
    func didFollowUser(with viewModel: UserFollowViewModel)
}

class UserTableViewCell: UITableViewCell {
    
    private var viewModel: UserFollowViewModel?
    weak var delegate: UserFollowDelegate?
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        return label
    }()
    
    private let emailLabel: UILabel = {
        let label = UILabel()
        label.textColor = .secondaryLabel
        return label
    }()
    
    private let followButton: UIButton = {
        let button = UIButton()
        return button
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(nameLabel)
        contentView.addSubview(emailLabel)
        contentView.addSubview(followButton)
        contentView.clipsToBounds = true
        
        followButton.addTarget(self, action: #selector(didTapFollow), for: .touchUpInside)
    }
    
    @objc func didTapFollow() {
        guard var viewModel = viewModel else { return }
        
        viewModel.following.toggle()
        delegate?.didFollowUser(with: viewModel)
        prepareForReuse()
        configure(with: viewModel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        nameLabel.frame = CGRect(x: 10,
                                 y: 5,
                                 width: contentView.frame.size.width,
                                 height: contentView.frame.size.height / 2)
        
        emailLabel.frame = CGRect(x: 10,
                                  y: contentView.frame.size.height / 2,
                                  width: contentView.frame.size.width,
                                  height: contentView.frame.size.height / 2)
        
        followButton.frame = CGRect(x: contentView.frame.size.width - 120,
                                    y: 10,
                                    width: 110,
                                    height: contentView.frame.size.height - 20)
    }
    
    override func prepareForReuse() {
        nameLabel.text = nil
        emailLabel.text = nil
        followButton.setTitle(nil, for: .normal)
        followButton.setTitleColor(nil, for: .normal)
        followButton.layer.borderWidth = 0
        followButton.layer.borderColor = nil
        followButton.backgroundColor = nil
    }
    
    func configure(with viewModel: UserFollowViewModel) {
        self.viewModel = viewModel
        nameLabel.text = viewModel.user.name
        emailLabel.text = viewModel.user.email
        
        if viewModel.following {
            followButton.setTitle("Unfollow", for: .normal)
            followButton.setTitleColor(.black, for: .normal)
            followButton.layer.borderWidth = 1
            followButton.layer.borderColor = UIColor.black.cgColor
            followButton.backgroundColor = .white
        }
        else {
            followButton.setTitle("Follow", for: .normal)
            followButton.setTitleColor(.white, for: .normal)
            followButton.layer.borderWidth = 1
            followButton.layer.borderColor = UIColor.link.cgColor
            followButton.backgroundColor = .link
        }
    }
}
