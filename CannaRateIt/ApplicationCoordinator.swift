//
//  ApplicationCoordinator.swift
//  CannaRateIt
//
//  Created by Dong Kang on 9/16/18.
//  Copyright © 2018 Yooniverse. All rights reserved.
//

import Foundation
import UIKit

class ApplicationCoordinator: Coordinator {
    let window: UIWindow
    let rootViewController: UITabBarController
    
    init(window: UIWindow) {
        self.window = window
        rootViewController = UITabBarController()
        
        // Code below is for testing purposes   // 5
        let emptyViewController = UIViewController()
        emptyViewController.view.backgroundColor = .cyan
        rootViewController.viewControllers = [emptyViewController]
    }
    
    func start() { 
        window.rootViewController = rootViewController
        window.makeKeyAndVisible()
    }
}
