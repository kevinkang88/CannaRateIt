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
	var coordinator: ProductCoordinator?
	
	@IBOutlet weak var brandName: UILabel!
	@IBOutlet weak var flavor: UILabel!
	@IBOutlet weak var strainType: UILabel!
	@IBOutlet weak var category: UILabel!
	@IBOutlet weak var subCategory: UILabel!
	@IBOutlet weak var rating: UILabel!
	
	@IBOutlet weak var addCommentButton: UIButton!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		guard let viewModel = self.viewModel, let navigationController = self.navigationController else {
			return
		}
		
		self.coordinator = ProductCoordinator(navigationController: navigationController, viewModel: viewModel)
		brandName.text = viewModel.product.brandName
		flavor.text = viewModel.product.flavor
		strainType.text = viewModel.product.strainType
		category.text = viewModel.product.category
		subCategory.text = viewModel.product.subCategory
		if let rating = viewModel.product.rating {
			self.rating.text = "\(rating)"
		}
	}
	
	@IBAction func addCommentButtonTapped(_ sender: Any) {
		if let coordinator = self.coordinator {
			coordinator.navigate(from: self, to: AddCommentViewController(), with: "showAddCommentView", and: nil)
		}
	}
}
