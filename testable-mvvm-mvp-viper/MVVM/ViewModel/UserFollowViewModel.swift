//
//  UserFollowViewModel.swift
//  testable-mvvm-mvp-viper
//
//  Created by Ashley Deng on 2021-05-07.
//

import Foundation

struct UserFollowViewModel {
    let user: User
    var following: Bool
    
    init(with model: User) {
        user = model
        following = false
    }
}
