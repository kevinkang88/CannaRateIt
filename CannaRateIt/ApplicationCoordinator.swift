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
    
    init(window: UIWindow) {
        self.window = window
    }
    
    func start() { 
        showTabbar()
    }
    
    private func showTabbar() {
        let tabbarCoordinator = TabbarCoordinator(window: window)
        tabbarCoordinator.start()
    }
}
