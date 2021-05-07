//
//  TabBarController.swift
//  testable-mvvm-mvp-viper
//
//  Created by Ashley Deng on 2021-04-30.
//

import UIKit
import RxSwift

class TabBarController: UITabBarController {
    
    var isOnline: Bool = true
    
    init(isOnline: Bool) {
        self.isOnline = isOnline
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewControllers()
    }
    
    private func setupViewControllers() {
        let userViewModel = isOnline ? UsersViewModel(service: UserRemoteRepo()) : UsersViewModel(service: UserLocalRepo())
        
        let mvvmNav = getNavController(MVVMViewController(viewModel: userViewModel), title: "MVVM", image: UIImage(systemName: "tram.tunnel.fill")!)
        let combineNav = getNavController(CombineViewController(), title: "Combine", image: UIImage(systemName: "arrow.triangle.merge")!)
        let mvpNav = getNavController(MVPViewController(), title: "MVP", image: UIImage(systemName: "gamecontroller.fill")!)
        let viperNav = getNavController(VIPERViewController(), title: "VIPER", image: UIImage(systemName: "bonjour")!)
        
        viewControllers = [mvvmNav, combineNav, mvpNav, viperNav]
    }
    
    private func getNavController(_ viewController: UIViewController, title: String, image: UIImage) -> UINavigationController {
        let nav = UINavigationController(rootViewController: viewController)
        viewController.navigationItem.title = title
        nav.title = title
        nav.tabBarItem.image = image
        
        return nav
    }
}
