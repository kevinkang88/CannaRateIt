//
//  CategoryPickerView.swift
//  CRI
//
//  Created by Dong Kang on 5/31/20.
//  Copyright © 2020 Yooniverse. All rights reserved.
//

import SwiftUI

import Combine

struct CategoryPickerWheel: View {
	
	@Binding var selectedCategoryIndex: Int
	
	let categories = ["drop","vape","edible","pet","topical"]
	
    var body: some View {
		VStack {
			Picker(selection: self.$selectedCategoryIndex, label: Text("")) {
				ForEach(0..<categories.count) {
					Text(self.categories[$0])
				}
			}.labelsHidden()
		}
	}
}
