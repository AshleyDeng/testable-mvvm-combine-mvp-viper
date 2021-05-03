//
//  TabBarController.swift
//  testable-mvvm-mvp-viper
//
//  Created by Ashley Deng on 2021-04-30.
//

import UIKit

class TabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let mvvmNav = getNavController(MVVMViewController(), title: "MVVM", image: UIImage(systemName: "tram.tunnel.fill")!)
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
