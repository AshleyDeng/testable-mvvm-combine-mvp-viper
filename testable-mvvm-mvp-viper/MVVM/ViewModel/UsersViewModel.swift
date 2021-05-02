//
//  UsersViewModel.swift
//  testable-mvvm-mvp-viper
//
//  Created by Ashley Deng on 2021-05-01.
//

import RxSwift

class UsersViewModel {
    var users = PublishSubject<[User]>()
    
    func fetchData() {
        guard let url = URL(string: "https://jsonplaceholder.typicode.com/users") else { return }
        
        defer {
            task.resume()
        }
        
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
            guard let data = data, error == nil else { return }
            
            do {
                let result = try JSONDecoder().decode([User].self, from: data)
                self?.users.onNext(result)
            }
            catch {
                print(error)
            }
        }
    }
}
