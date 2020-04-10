//
//  ContentView.swift
//  CRI
//
//  Created by Dong Kang on 3/18/20.
//  Copyright © 2020 Yooniverse. All rights reserved.
//

import SwiftUI

import Firebase

import FirebaseStorage

struct ExploreView: View {
	
    @ObservedObject var selectedCategoryStore = SelectedCategoryStore()
	
	@State var showAddProductSheet = false
	
	init() {
		// To remove only extra separators below the list:
		UITableView.appearance().tableFooterView = UIView()

		// To remove all separators including the actual ones:
		UITableView.appearance().separatorStyle = .none
	}
				
    var body: some View {
		NavigationView {
			ZStack(alignment: .bottom) {
				VStack(alignment: .leading) {
				VStack(alignment: .leading) {
					Spacer().frame(height: 10)
					Text("Explore").padding(.top).font(Font.custom("AirbnbCerealApp-ExtraBold", size: 26.0))
					Text("CBD Products!").font(Font.custom("AirbnbCerealApp-Black", size: 26.0))
				}.padding(.horizontal)
				
				VStack(alignment: .center) {
					HStack {
						Text("Search something").foregroundColor(Color.gray.opacity(0.5)).frame(height: 65.0, alignment: .leading).padding()
						Spacer()
						VStack {
							Image("search").renderingMode(.template).resizable().frame(width: 20, height: 20).foregroundColor(Color.white).padding()
						}.frame(width: 65, height: 65).background(Color("Blue"))
						
					}.frame(width: UIScreen.main.bounds.width - 30.0, height: 65).background(Color.gray.opacity(0.2)).cornerRadius(15)
				}.padding(.horizontal, 15.0)
									Spacer().frame(height: 10)
					VStack(alignment: .leading) {
					CategoryPickerView(selectedCategory: $selectedCategoryStore.selectedCategory).padding().padding(.leading, 2.0)
									
					List {
						ForEach(0..<self.selectedCategoryStore.sections.count, id: \.self) { section in
							Section(header: HStack {
								Text("\(self.selectedCategoryStore.sections[section])".capitalized)
									.font(Font.custom("AirbnbCerealApp-Black", size: 22.0))
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
				}
						
				Spacer(minLength: 11)
			}
			
				
				Button(action: {
					self.showAddProductSheet.toggle()
				}) {
					Image("plus").resizable().renderingMode(.template).foregroundColor(Color("Blue"))
				}.frame(width: 80, height: 80, alignment: .center)
				
			}.onAppear {
				self.selectedCategoryStore.selectedCategory = "edible"
			}.navigationBarHidden(true)
		}.sheet(isPresented: $showAddProductSheet) {
			AddProductView()
		}.edgesIgnoringSafeArea(.top)
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
				let isTrending = doc.document.data()["isTrending"] as! Bool
				let averageRating = doc.document.data()["averageRating"] as! Float
				let updatedDate = (doc.document.data()["lastUpdated"] as! Timestamp).dateValue() as! Date
				
				products.append(Product(id: id, name: name, brand: brand, category: category, mainIngredient: mainIngredient, isTrending: isTrending, averageRating: averageRating, lastUpdated: updatedDate))
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
