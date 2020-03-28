//
//  CategoryPickerCell.swift
//  CRI
//
//  Created by Dong Kang on 3/21/20.
//  Copyright © 2020 Yooniverse. All rights reserved.
//

import SwiftUI

struct CategoryPickerCell: View {
	
	@State var isPressed: Bool = false
	
	private let iconName: String
	private let categoryName: String
		
	init(iconName: String, categoryName: String) {
		self.iconName = iconName
		self.categoryName = categoryName
	}
	
    var body: some View {
		VStack(alignment: .center) {
			if self.isPressed {
				Image(self.iconName).renderingMode(.template).resizable().frame(width: 65.0, height: 65.0, alignment: .center).foregroundColor(Color("Blue")).overlay(RoundedRectangle(cornerRadius: 10).stroke(Color("Blue"), lineWidth: 4))
				Text(self.categoryName).foregroundColor(Color("Blue"))
			} else {
				Image(self.iconName).resizable().frame(width: 65.0, height: 65.0, alignment: .center).overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.black, lineWidth: 4))
				Text(self.categoryName)
			}
		}.onTapGesture {
			self.isPressed = !self.isPressed
		}
    }
}

struct CategoryPickerCell_Previews: PreviewProvider {
    static var previews: some View {
		CategoryPickerCell(iconName: "pet-category", categoryName: "pet")
    }
}
