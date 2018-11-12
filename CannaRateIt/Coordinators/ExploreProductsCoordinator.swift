//
//  ExploreProductsCoordinator.swift
//  CannaRateIt
//
//  Created by Dong Kang on 9/18/18.
//  Copyright © 2018 Yooniverse. All rights reserved.
//

import Foundation
import UIKit

class ExploreProductsCoordinator: Coordinator {
    var navigationController: UINavigationController?
    private var viewController: ExploreProductsViewController?
	
    init() {
        self.viewController = ExploreProductsViewController(nibName: "ExploreProductsViewController", bundle: nil)
        if let viewController = self.viewController {
            self.navigationController = UINavigationController(rootViewController: viewController)
        }
    }
    
    func start() {
        self.viewController?.tabBarItem = UITabBarItem(tabBarSystemItem: .search, tag: 0)
    }
	
	func navigate(from source: UIViewController, to destination: UIViewController, with identifier: String?, and sender: AnyObject?) {
		if let navigationController = source.navigationController,
			let destination = destination as? ProductViewController, let _ = sender as? ExploreProductsViewModel {
			let productCoordinator = ProductCoordinator(navigationController: navigationController)
			productCoordinator.start()
		}
	}
}
