//
//  CastegoryPickerView.swift
//  CRI
//
//  Created by Dong Kang on 3/28/20.
//  Copyright © 2020 Yooniverse. All rights reserved.
//

import SwiftUI

struct CategoryPickerView: View {
	
	let categories: [Category] = [Category(iconName: "drops-category", categoryName: "drop"),
								  	Category(iconName: "vapes-category", categoryName: "vapes"),
									Category(iconName: "edibles-category", categoryName: "edible"),
								  	Category(iconName: "pets-category", categoryName: "pet"),
								  	Category(iconName: "topicals-category", categoryName: "topicals")]
	
    @Binding var selectedCategory: String
	
	init(selectedCategory: Binding<String>) {
		self._selectedCategory = selectedCategory
		
        
		
	}

    var body: some View {
		ScrollView(.horizontal, showsIndicators: false, content: {
			HStack(alignment: .center, spacing: 20.0) {
				ForEach(self.categories, id: \.self) { category in
					CategoryPickerCell(iconName: category.iconName, categoryName: category.categoryName, selectedCategory: self.$selectedCategory).padding(.leading, 2.0)
				}
				Spacer()
			}.frame(height: 70.0)
			}).frame(height: 70.0)
		
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
