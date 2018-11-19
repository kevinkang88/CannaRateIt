//
//  ProductViewController.swift
//  CannaRateIt
//
//  Created by Dong Kang on 10/30/18.
//  Copyright © 2018 Yooniverse. All rights reserved.
//

import Foundation
import UIKit

class ProductViewController: UIViewController {
	
	var viewModel: ProductViewModel?
	
	@IBOutlet weak var brandName: UILabel!
	@IBOutlet weak var flavor: UILabel!
	@IBOutlet weak var strainType: UILabel!
	@IBOutlet weak var category: UILabel!
	@IBOutlet weak var subCategory: UILabel!
	@IBOutlet weak var rating: UILabel!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		guard let viewModel = self.viewModel else {
			return
		}
		
		brandName.text = viewModel.product.brandName
		flavor.text = viewModel.product.flavor
		strainType.text = viewModel.product.strainType
		category.text = viewModel.product.category
		subCategory.text = viewModel.product.subCategory
		if let rating = viewModel.product.rating {
			self.rating.text = "\(rating)"
		}
	}
}
