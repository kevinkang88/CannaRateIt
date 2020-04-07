//
//  ContentView.swift
//  CRI
//
//  Created by Dong Kang on 3/18/20.
//  Copyright © 2020 Yooniverse. All rights reserved.
//

import SwiftUI

import Firebase

struct ExploreView: View {
	
    @ObservedObject var selectedCategoryStore = SelectedCategoryStore()
				
    var body: some View {
		NavigationView {
			VStack(alignment: .leading, spacing: 0.0) {
				
				CategoryPickerView(selectedCategory: $selectedCategoryStore.selectedCategory).padding()
				
				List {
					ForEach(0..<self.selectedCategoryStore.sections.count, id: \.self) { section in
						Section(header: HStack {
							Text("\(self.selectedCategoryStore.sections[section])".capitalized)
								.font(Font.system(size: 22.0, weight: .bold, design: .default))
								.foregroundColor(.black)
								.padding()
								Spacer()
							}.background(Color.white).listRowInsets(EdgeInsets(top: 0,leading: 0,bottom: 0,trailing: 0))
						) {
							ScrollView(.horizontal, showsIndicators: false) {
								HStack(alignment: .center, spacing: 25.0) {
									ForEach(self.selectedCategoryStore.rows(section: section), id: \.self) { product in
										ProductCardCell(product: product).frame(width: 160, height: 240, alignment: .center)
									}
								}.frame(height: 240)
							}

						}
					}
				}
			}.onAppear {
				self.selectedCategoryStore.selectedCategory = "edible"
			}.navigationBarTitle("Explore", displayMode: .automatic)
		}
    }
}

// make an object that listens for change of selectedCategory
class SelectedCategoryStore: ObservableObject {
	
	@Published var selectedCategory: String = "edible" {
		didSet {
			self.fetchProductsFromFirebase(selectedCategory: selectedCategory)
		}
	}
	
	@Published var loadedProducts: [String: [Product]] = [:]
	
    var sections: [String] { loadedProducts.keys.map { $0 } }
    func rows(section: Int) -> [Product] { loadedProducts[sections[section]]! }

	private func fetchProductsFromFirebase(selectedCategory: String) {
		var products = [Product]()
		let query = Firestore.firestore().collection("products").whereField("category", isEqualTo: self.selectedCategory)
		query.getDocuments { snap, err in
			if err != nil {
                print((err?.localizedDescription)!)
				return
			}
			
			for doc in (snap?.documentChanges)! {
				let id = doc.document.documentID
                let name = doc.document.data()["name"] as! String
                let brand = doc.document.data()["brand"] as! String
				let category = Product.Category(rawValue: doc.document.data()["category"] as! String) as! Product.Category
				let mainIngredient = Product.MainIngredient(rawValue: doc.document.data()["mainIngredient"] as! String) as! Product.MainIngredient
				let primaryImage = doc.document.data()["primaryImage"] as! String
				let isTrending = doc.document.data()["isTrending"] as! Bool
				let averageRating = doc.document.data()["averageRating"] as! Float
				let updatedDate = (doc.document.data()["lastUpdated"] as! Timestamp).dateValue() as! Date
				
				products.append(Product(id: id, name: name, brand: brand, category: category, mainIngredient: mainIngredient, primaryImage: primaryImage, isTrending: isTrending, averageRating: averageRating, lastUpdated: updatedDate))
			}
			
			// ["trending: [Product], "most reviewed": [Product], "latest": [Product]]
			
			let trendingProducts = products.filter { product -> Bool in
				return product.isTrending
			}
			
			var result = ["trending": trendingProducts]
			
			let byLastUpdatedProducts = products.sorted { (product1, product2) -> Bool in
				return product1.lastUpdated ?? Date() > product2.lastUpdated ?? Date()
			}
			
			result["latest"] = byLastUpdatedProducts
			
			self.loadedProducts = result
		}
		
	}
}
