//
//  CastegoryPickerView.swift
//  CRI
//
//  Created by Dong Kang on 3/28/20.
//  Copyright © 2020 Yooniverse. All rights reserved.
//

import SwiftUI

struct CategoryPickerView: View {
	
	let categories: [Category] = [Category(iconName: "edible-category", categoryName: "edible"),
								  Category(iconName: "pet-category", categoryName: "pet")]
	
	@State var selectedFruit: String = "edible"
	
    var body: some View {
		HStack(alignment: .center, spacing: 20.0) {
			ForEach(self.categories, id: \.self) { category in
				CategoryPickerCell(iconName: category.iconName, categoryName: category.categoryName, selectedCategory: self.$selectedFruit)
            }
			Spacer()
		}
	}
}

// TODO: Move to separate file

import Combine

class CategoryPickerViewModel: ObservableObject, Identifiable {
	@Published var currentlySelectedCategoryName: String = "edible"
	
	func updateSelectedCategoryName(name: String) {
		self.currentlySelectedCategoryName = name
	}
}

// TODO: Move to separate file

struct Category: Hashable {
	var iconName: String
	var categoryName: String
}

//struct CastegoryPickerView_Previews: PreviewProvider {
//    static var previews: some View {
//        CategoryPickerView()
//    }
//}
