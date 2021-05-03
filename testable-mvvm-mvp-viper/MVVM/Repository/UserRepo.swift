//
//  UserServices.swift
//  testable-mvvm-mvp-viper
//
//  Created by Ashley Deng on 2021-05-03.
//

import RxSwift

enum UserRepoError: Error {
    case urlError
    case networkError
    case parserError
}

typealias UserRepoResponse = Result<[User], UserRepoError>

protocol UserServices {
    func loadUsers() -> Observable<UserRepoResponse>
}

class UserRepository: UserServices {
    func loadUsers() -> Observable<UserRepoResponse> {
        guard let url = URL(string: "https://jsonplaceholder.typicode.com/users") else {
            return Observable.error(UserRepoError.urlError)
        }
        
        return URLSession.shared
            .rx.response(request: URLRequest(url: url))
            .retry(3)
            .observe(on: MainScheduler.instance)
            .map { (response, data) -> UserRepoResponse in
                guard 200 ..< 300 ~= response.statusCode else {
                    return .failure(.networkError)
                }
                
                do {
                    let result = try JSONDecoder().decode([User].self, from: data)
                    return .success(result)
                }
                catch {
                    return .failure(.parserError)
                }
            }
    }
}
