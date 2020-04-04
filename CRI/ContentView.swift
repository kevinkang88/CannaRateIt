//
//  ContentView.swift
//  CRI
//
//  Created by Dong Kang on 3/18/20.
//  Copyright © 2020 Yooniverse. All rights reserved.
//

import SwiftUI

struct ExploreView: View {
	
	@State var selectedFruit: String = "edible"
			
    var body: some View {
		VStack(alignment: .leading, spacing: 0.0) {
			
			CategoryPickerView(selectedCategory: $selectedFruit)
			
			List {
				Section(header: Text("Trending \(selectedFruit)")) {
					Text("row1")
					Text("row2")
				}
			}
		}
    }
}
