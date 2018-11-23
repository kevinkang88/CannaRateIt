//
//  AddCommentsCoordinator.swift
//  CannaRateIt
//
//  Created by Dong Kang on 11/22/18.
//  Copyright © 2018 Yooniverse. All rights reserved.
//

import Foundation
import UIKit

class AddCommentsCoordinator: Coordinator {
	private var navigationController: UINavigationController
	private var viewController: AddCommentViewController
	
	init(navigationController: UINavigationController) {
		self.navigationController = navigationController
		self.viewController = AddCommentViewController(nibName: "AddCommentViewController", bundle: nil)
	}
	
	func start() {
		self.navigationController.present(viewController, animated: true, completion: nil)
	}
}
