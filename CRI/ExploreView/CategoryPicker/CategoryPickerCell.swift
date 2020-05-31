//
//  CategoryPickerCell.swift
//  CRI
//
//  Created by Dong Kang on 3/21/20.
//  Copyright © 2020 Yooniverse. All rights reserved.
//

import SwiftUI

struct CategoryPickerCell: View {
	
	struct Constants {
		static let cellWidth: CGFloat = 44.0
	}
		
    @Binding var selectedCategory: String
	
	private let iconName: String
	private let categoryName: String
	
			
	init(iconName: String, categoryName: String, selectedCategory: Binding<String>) {
		self.iconName = iconName
		self.categoryName = categoryName
		self._selectedCategory = selectedCategory
	}
	
    var body: some View {
		VStack(alignment: .center) {
			if self._selectedCategory.wrappedValue == self.categoryName {
				Image(self.iconName).renderingMode(.template).resizable().frame(width: Constants.cellWidth, height: Constants.cellWidth, alignment: .center).foregroundColor(Color("OceanBlue")).overlay(RoundedRectangle(cornerRadius: 10).stroke(Color("OceanBlue"), lineWidth: 2))
				Text(self.categoryName.capitalized).font(Font.custom("AirbnbCerealApp-Light", size: 10.0)).foregroundColor(Color("OceanBlue"))
			} else {
				Image(self.iconName).renderingMode(.template).resizable().frame(width: Constants.cellWidth, height: Constants.cellWidth, alignment: .center).foregroundColor(Color.black.opacity(0.6)).overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.black.opacity(0.6), lineWidth: 2))
				Text(self.categoryName.capitalized).font(Font.custom("AirbnbCerealApp-Light", size: 10.0))
			}
		}.onTapGesture {
			self.selectedCategory = self.categoryName
		}
	}
}

//struct CategoryPickerCell_Previews: PreviewProvider {
//    static var previews: some View {
//		CategoryPickerCell(iconName: "pet-category", categoryName: "pet")
//    }
//}
