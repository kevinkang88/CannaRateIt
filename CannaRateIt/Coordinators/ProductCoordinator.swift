//
//  ProductCoordinator.swift
//  CannaRateIt
//
//  Created by Dong Kang on 10/30/18.
//  Copyright © 2018 Yooniverse. All rights reserved.
//

import Foundation
import UIKit

class ProductCoordinator: Coordinator {
	private var navigationController: UINavigationController
	private var viewController: ProductViewController
	
	 init(navigationController: UINavigationController) {
		self.navigationController = navigationController
		self.viewController = ProductViewController(nibName: "ProductViewController", bundle: nil)
	}
	
	func start() {
		self.navigationController.pushViewController(viewController, animated: true)
	} 
}
