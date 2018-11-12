//
//  ExploreProductsViewController.swift
//  CannaRateIt
//
//  Created by Dong Kang on 10/6/18.
//  Copyright © 2018 Yooniverse. All rights reserved.
//

import Foundation
import UIKit

class ExploreProductsViewController: UIViewController, UISearchControllerDelegate, UISearchResultsUpdating, UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource {
	
	@IBOutlet weak var tableView: UITableView!
	var coordinator: ExploreProductsCoordinator?
	
	func updateSearchResults(for searchController: UISearchController) {
		
	}
	
    var viewModel = ExploreProductsViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
		self.coordinator = ExploreProductsCoordinator()
		let searchController = UISearchController(searchResultsController: nil)
		searchController.searchResultsUpdater = self
		searchController.obscuresBackgroundDuringPresentation = false
		searchController.searchBar.placeholder = "Search here..."
		definesPresentationContext = true
		searchController.searchBar.delegate = self
		searchController.searchBar.sizeToFit()
		
		self.navigationItem.searchController = searchController
		
		self.navigationItem.hidesSearchBarWhenScrolling = false
		navigationController?.navigationBar.prefersLargeTitles = false
		navigationItem.largeTitleDisplayMode = .never
		
		tableView.delegate = self
		tableView.dataSource = self
		tableView.register(ProductSearchResultsCell.self, forCellReuseIdentifier: "Cell")
		tableView.register(UINib(nibName: "ProductSearchResultsCell", bundle: nil), forCellReuseIdentifier: "Cell")
		tableView.tableFooterView = UIView()
    }
	
	func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
		if let query = searchBar.text {
			ProductsService().search(query: query) { (products, error) in
				if error != nil || products?.count ?? 0 < 1 {
					print(error)
					return
				}
				DispatchQueue.main.async {
					self.foundData = products
					self.tableView.reloadData()
				}
			}
		}
	}
	
	var foundData: [Product]?
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as? ProductSearchResultsCell else {
			return UITableViewCell()
		}
		
		if let foundData = foundData {
			let productData = foundData[indexPath.row]
			cell.brandNameLabel.text = productData.brandName
			cell.flavorLabel.text = productData.flavor
			cell.categoriesLabel.text = productData.category
			cell.strainTypeLabel.text = productData.strainType
		}
		
		return cell
	}
	
	func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		if let foundDataCount = foundData?.count {
			return foundDataCount
		}
		return 0
	}
	
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return 240
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		//
		guard let foundData = self.foundData else {
			return
		}
		print("yellow")
		let productSelected = foundData[indexPath.row]
		coordinator?.navigate(from: self, to: ProductViewController(), with: "showProductView", and: self.viewModel)
	}
}
