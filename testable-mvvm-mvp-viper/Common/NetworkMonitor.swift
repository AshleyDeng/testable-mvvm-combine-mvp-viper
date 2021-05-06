//
//  NetworkMonitor.swift
//  testable-mvvm-mvp-viper
//
//  Created by Ashley Deng on 2021-05-05.
//

import Foundation
import Network
import RxSwift
import RxCocoa

protocol NetworkDetectable {
    var isOnline: BehaviorRelay<Bool> { get }
}

class NetworkMonitor: NetworkDetectable {
    var isOnline = BehaviorRelay<Bool>(value: true)
    private let monitor = NWPathMonitor()
    
    init() {
        monitor.pathUpdateHandler = { path in
            if path.status == .satisfied {
                self.isOnline.accept(true)
                print("We're connected!")
            } else {
                self.isOnline.accept(false)
                print("No connection.")
            }
        }
        
        let queue = DispatchQueue.global(qos: .background)
        monitor.start(queue: queue)
    }
}
