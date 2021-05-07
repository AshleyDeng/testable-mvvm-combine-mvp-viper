//
//  UserFollowViewModel.swift
//  testable-mvvm-mvp-viper
//
//  Created by Ashley Deng on 2021-05-07.
//

import Foundation

struct UserFollowViewModel {
    let name: String
    let email: String
    var following: Bool
    
    init(with model: User) {
        name = model.name
        email = model.email
        following = false
    }
}
