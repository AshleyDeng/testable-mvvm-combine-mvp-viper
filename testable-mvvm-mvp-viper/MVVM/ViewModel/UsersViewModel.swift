//
//  UsersViewModel.swift
//  testable-mvvm-mvp-viper
//
//  Created by Ashley Deng on 2021-05-01.
//

import RxSwift

class UsersViewModel {
    private let userRepository: UserServices
    private let bag = DisposeBag()
    
    var users = PublishSubject<[User]>()
    
    init(service: UserServices) {
        userRepository = service
    }
    
    func fetchData() {
        userRepository
            .loadUsers()
            .subscribe(
                onNext: { response in
                    switch response {
                    case .success(let users):
                        self.users.onNext(users)
                    case .failure(let error):
                        print(error)
                    }
                })
            .disposed(by: bag)
    }
}
