//
//  UserServices.swift
//  testable-mvvm-mvp-viper
//
//  Created by Ashley Deng on 2021-05-03.
//

import RxSwift

enum UserRepoError: Error {
    case noLocalData
    case urlError
    case networkError
    case parserError
}

typealias UserRepoResponse = Result<[User], UserRepoError>
typealias UserFollowResponse = Result<Bool, UserRepoError>

protocol UserServices {
    func loadUsers() -> Observable<UserRepoResponse>
    func followUser(with id: Int) -> Observable<UserFollowResponse>
}

private enum UserRepoConstants {
    static let USER_KEY = "local_cached_users"
}

class UserRemoteRepo: UserServices {
    private let defaults = UserDefaults.standard
    
    func loadUsers() -> Observable<UserRepoResponse> {
        guard let url = URL(string: "https://jsonplaceholder.typicode.com/users") else {
            return Observable.error(UserRepoError.urlError)
        }
        
        return URLSession.shared
            .rx.response(request: URLRequest(url: url))
            .retry(3)
            .observe(on: MainScheduler.instance)
            .map { [weak self] (response, data) -> UserRepoResponse in
                guard 200 ..< 300 ~= response.statusCode else {
                    return .failure(.networkError)
                }
                
                do {
                    let result = try JSONDecoder().decode([User].self, from: data)
                    self?.defaults.setValue(data, forKey: UserRepoConstants.USER_KEY)
                    return .success(result)
                }
                catch {
                    return .failure(.parserError)
                }
            }
    }
    
    func followUser(with id: Int) -> Observable<UserFollowResponse> {
        return Observable.create { observer in
            Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { _ in
                observer.onNext(.success(true))
                observer.onCompleted()
            }
            
            return Disposables.create()
        }
    }
}

class UserLocalRepo: UserServices {
    private let defaults = UserDefaults.standard
    
    func loadUsers() -> Observable<UserRepoResponse> {
        
        let response: UserRepoResponse
        do {
            let users: [User] = try defaults.getObject(forKey: UserRepoConstants.USER_KEY, castTo: [User].self)
            response = users.isEmpty ? UserRepoResponse.failure(.noLocalData) : UserRepoResponse.success(users)
        }
        catch {
            response = UserRepoResponse.failure(.parserError)
        }
        
        return Observable.create {
            $0.onNext(response)
            $0.onCompleted()
            return Disposables.create()
        }
    }
    
    func followUser(with id: Int) -> Observable<UserFollowResponse> {
        return Observable.create { observer in
            Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { _ in
                observer.onNext(.success(false))
                observer.onCompleted()
            }
            
            return Disposables.create()
        }
    }
}
