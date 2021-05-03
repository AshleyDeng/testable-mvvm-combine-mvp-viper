//
//  UserTableViewCell.swift
//  testable-mvvm-mvp-viper
//
//  Created by Ashley Deng on 2021-05-03.
//

import UIKit

class UserTableViewCell: UITableViewCell {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
}
