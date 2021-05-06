//
//  NetworkMonitor.swift
//  testable-mvvm-mvp-viper
//
//  Created by Ashley Deng on 2021-05-05.
//

import Foundation
import Network
import RxSwift

protocol NetworkDetectable {
    var isOnline: PublishSubject<Bool> { get }
}

class NetworkMonitor: NetworkDetectable {
    var isOnline = PublishSubject<Bool>()
    private let monitor = NWPathMonitor()
    
    init() {
        monitor.pathUpdateHandler = { path in
            if path.status == .satisfied {
                self.isOnline.onNext(true)
                print("We're connected!")
            } else {
                self.isOnline.onNext(false)
                print("No connection.")
            }
        }
        
        let queue = DispatchQueue.global(qos: .background)
        monitor.start(queue: queue)
    }
}
