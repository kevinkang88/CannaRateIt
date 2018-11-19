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
	private var viewModel: ProductViewModel
	
	init(navigationController: UINavigationController, viewModel: ProductViewModel) {
		self.navigationController = navigationController
		self.viewModel = viewModel
		self.viewController = ProductViewController(nibName: "ProductViewController", bundle: nil)
		self.viewController.viewModel = viewModel
	}
	
	func start() {
		self.navigationController.pushViewController(viewController, animated: true)
	} 
}
