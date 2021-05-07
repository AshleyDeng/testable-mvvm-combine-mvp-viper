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
    
    let users = PublishSubject<[User]>()
    let error = PublishSubject<String>()
    let isLoading = ActivityIndicator()
    
    init(service: UserServices) {
        userRepository = service
    }
    
    func fetchData() {
        userRepository
            .loadUsers()
            .trackActivity(isLoading)
            .subscribe(
                onNext: handleResponse(_:),
                onError: handleError(_:)
            ).disposed(by: bag)
    }
    
    private func handleResponse(_ response: UserRepoResponse) {
        switch response {
        case .success(let data):
            users.onNext(data)
        default:
            break
        }
    }
    
    private func handleError(_ err: Error) {
        error.onNext(err.localizedDescription)
    }
}
