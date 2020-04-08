	//
//  AddProductView.swift
//  CRI
//
//  Created by Dong Kang on 4/7/20.
//  Copyright © 2020 Yooniverse. All rights reserved.
//

import SwiftUI

struct AddProductView: View {
	
	@ObservedObject var addProductFormDataStore = AddProductFormDataStore()
	
	@State var showImagePicker = false
	@State private var image : Image? = nil
	
    var body: some View {
		NavigationView {
			VStack {
				
				Button(action: {
					self.showImagePicker = true
				}) {
					if self.image == nil {
						Text("+ Image")
						.fontWeight(.regular)
						.font(.headline)
						.foregroundColor(Color.gray)
						.padding()
						.overlay(
							RoundedRectangle(cornerRadius: 20)
								.stroke(Color.gray, lineWidth: 3))
					} else {
						Text("Added")
						.fontWeight(.regular)
						.font(.headline)
						.foregroundColor(Color.gray)
						.padding()
						.overlay(
							RoundedRectangle(cornerRadius: 20)
								.stroke(Color.gray, lineWidth: 3))
					}

				}.padding(.top)
				
				VStack(alignment: .leading) {
					Text("Product name").padding(.top)
					TextField("Name", text: self.$addProductFormDataStore.productName, onEditingChanged: { changed in
						print(changed)
					}) {
						print("commit yo man")
					}.textFieldStyle(RoundedBorderTextFieldStyle())

					Text("Brand").padding(.top)
					TextField("Brand", text: self.$addProductFormDataStore.brandName, onEditingChanged: { changed in
						print(changed)
					}) {
						print("commit yo man")
					}.textFieldStyle(RoundedBorderTextFieldStyle())
					
					Text("Category").padding(.top)
					CategoryPickerView(selectedCategory: self.$addProductFormDataStore.selectedCategory)
					
					Stepper("Rating: \(String(format: "%.1f", self.addProductFormDataStore.rating))", onIncrement: {
						if self.addProductFormDataStore.rating <= 4.5 {
							self.addProductFormDataStore.rating += 0.5
						}
					}, onDecrement: {
						if self.addProductFormDataStore.rating >= 0.5 {
							self.addProductFormDataStore.rating -= 0.5
						}
					}).padding(.top)
					
					Button(action: {
						print("submittingto the firebase")
					}) {
						Text("create")
					}.padding(.top)
					
					Spacer()
				}
				
				
			}.padding(.horizontal)
			
			.navigationBarTitle("Add Product")
		}.sheet(isPresented: self.$showImagePicker) {
			PhotoCaptureView(showImagePicker: self.$showImagePicker, image: self.$image)
		}
        
    }
}

struct AddProductView_Previews: PreviewProvider {
    static var previews: some View {
        AddProductView()
    }
}

class AddProductFormDataStore: ObservableObject {
	@Published var productName: String = ""
	@Published var brandName: String = ""
	@Published var selectedCategory: String = ""
	@Published var rating: Float = 0.0
	
	func addProductToFirebase() {
		print("adding")
	}
}
