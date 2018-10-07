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
    var viewController: ExploreProductsViewController?
	
    init() {
        self.viewController = ExploreProductsViewController(nibName: "ExploreProductsViewController", bundle: nil)
    }
    
    func start() {
    }
}
