//
//  ExploreProductsViewController.swift
//  CannaRateIt
//
//  Created by Dong Kang on 10/6/18.
//  Copyright © 2018 Yooniverse. All rights reserved.
//

import Foundation
import UIKit

class ExploreProductsViewController: UIViewController {
    var viewModel = ExploreProductsViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.topItem?.title = viewModel.navigationBarTitle
    }
}
