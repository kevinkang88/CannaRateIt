//
//  ExploreProductsViewController.swift
//  CannaRateIt
//
//  Created by Dong Kang on 10/6/18.
//  Copyright © 2018 Yooniverse. All rights reserved.
//

import Foundation
import UIKit

class ExploreProductsViewController: UIViewController, UISearchControllerDelegate, UISearchResultsUpdating, UISearchBarDelegate {
	
	@IBOutlet weak var tableView: UITableView!
	
	func updateSearchResults(for searchController: UISearchController) {
		
	}
	
    var viewModel = ExploreProductsViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
		
    }
	
	func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
		if let query = searchBar.text {
			ProductsService().search(query: query) { (products, error) in
				if error != nil || products?.count ?? 0 < 1 {
					print(error)
					return
				}
				
				
				
				
			}
		}
	}
}
