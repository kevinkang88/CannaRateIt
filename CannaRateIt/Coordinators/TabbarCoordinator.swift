//
//  TabbarCoordinator.swift
//  CannaRateIt
//
//  Created by Dong Kang on 10/6/18.
//  Copyright © 2018 Yooniverse. All rights reserved.
//

import Foundation
import UIKit

class TabbarCoordinator: Coordinator {
    let window: UIWindow
    
    init(window: UIWindow) {
        self.window = window
    }
    
    func start() {
        let tabbarController = UITabBarController()
        
        let exploreProductsCoordinator = ExploreProductsCoordinator()
        exploreProductsCoordinator.start()
		
        guard let exploreProductsNavigationController = exploreProductsCoordinator.navigationController else {
            return
        }
		
        tabbarController.setViewControllers([exploreProductsNavigationController], animated: true)
		
        self.window.rootViewController = tabbarController
        self.window.makeKeyAndVisible()
    }
}