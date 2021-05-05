//
//  UsersViewModel.swift
//  testable-mvvm-mvp-viper
//
//  Created by Ashley Deng on 2021-05-01.
//

import RxSwift
import RxCocoa

class UserViewModel {
    private let userRepository: UserServices
    private let bag = DisposeBag()
    
    let users = PublishSubject<[User]>()
    let isLoading = ActivityIndicator()
    
    init(service: UserServices) {
        userRepository = service
    }
    
    func fetchData() {
        userRepository
            .loadUsers()
            .trackActivity(isLoading)
            .subscribe(onNext: handleResponse(_:))
            .disposed(by: bag)
    }
    
    private func handleResponse(_ response: UserRepoResponse) {
        switch response {
        case .success(let data):
            users.onNext(data)
        case .failure(let error):
            print(error)
        }
    }
}
