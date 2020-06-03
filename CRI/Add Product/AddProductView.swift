	//
//  AddProductView.swift
//  CRI
//
//  Created by Dong Kang on 4/7/20.
//  Copyright © 2020 Yooniverse. All rights reserved.
//

import SwiftUI
	
import Firebase
import FirebaseStorage


struct AddProductView: View {
	
	@Binding var isVisible: Bool
	
	let categories: [Category] = [Category(iconName: "drops-category", categoryName: "drop"),
								  	Category(iconName: "vapes-category", categoryName: "vapes"),
									Category(iconName: "edibles-category", categoryName: "edible"),
								  	Category(iconName: "pets-category", categoryName: "pet"),
								  	Category(iconName: "topicals-category", categoryName: "topicals")]
	
	@ObservedObject var addProductFormDataStore = AddProductFormDataStore()
	
	@State var showImagePicker = false
		
    var body: some View {
			ScrollView {
				
				HStack {
					Button(action: {
						self.isVisible = false
					}) {
						Image("close-icon").renderingMode(.template).resizable().frame(width: 40, height: 40, alignment: .center).foregroundColor(Color.black)
					}.padding(.vertical)
					
					Spacer()
				}
				
			
				Button(action: {
					self.showImagePicker = true
				}) {
					if self.addProductFormDataStore.image == nil {
						Text("Add Image").font(Font.custom("AirbnbCerealApp-Medium", size: 14.0))
						.foregroundColor(Color.black.opacity(0.9))
						.padding()
						.overlay(
							RoundedRectangle(cornerRadius: 8)
								.stroke(Color.black.opacity(0.9), lineWidth: 2))
					} else {
						Text("Added").font(Font.custom("AirbnbCerealApp-Medium", size: 14.0))
						.foregroundColor(Color.green)
						.padding()
						.overlay(
							RoundedRectangle(cornerRadius: 8)
								.stroke(Color.green, lineWidth: 2))
					}

				}.padding(.vertical)
				
					
				HStack {
					Text("Product name").font(Font.custom("AirbnbCerealApp-Medium", size: 12.0)).foregroundColor(Color.black.opacity(0.7)).padding(.leading).padding(.vertical)
					TextField("", text: self.$addProductFormDataStore.productName, onEditingChanged: { changed in
						print(changed)
					}) {
						print("commit yo man")
					}.padding(.trailing).padding(.vertical)
				}.background(Color.gray.opacity(0.2)).cornerRadius(8)
				
				HStack {
					Text("Brand").font(Font.custom("AirbnbCerealApp-Medium", size: 12.0)).foregroundColor(Color.black.opacity(0.7)).padding(.leading).padding(.vertical)
					TextField("", text: self.$addProductFormDataStore.brandName, onEditingChanged: { changed in
						print(changed)
					}) {
						print("commit yo man")
					}.padding(.trailing).padding(.vertical)
				}.background(Color.gray.opacity(0.2)).cornerRadius(8)
				
				GeometryReader { geometry in
					HStack {
						Text("Category").font(Font.custom("AirbnbCerealApp-Medium", size: 12.0)).foregroundColor(Color.black.opacity(0.7)).padding(.horizontal)
						Text("\(self.addProductFormDataStore.categories[self.addProductFormDataStore.selectedCategoryIndex])"
						).font(Font.custom("AirbnbCerealApp-Medium", size: 14.0))
						Spacer()
					}.frame(width: geometry.size.width, height: 60.0).background(Color.gray.opacity(0.2)).cornerRadius(8).onTapGesture {
						self.addProductFormDataStore.showCategoryPicker = true
					}
				}.frame(height: 60.0)
				

				Stepper(onIncrement: {
					if self.addProductFormDataStore.rating <= 4.5 {
						self.addProductFormDataStore.rating += 0.5
					}
				}, onDecrement: {
					if self.addProductFormDataStore.rating >= 0.5 {
						self.addProductFormDataStore.rating -= 0.5
					}
				}) {
					Text("Rating: \(String(format: "%.1f", self.addProductFormDataStore.rating))").font(Font.custom("AirbnbCerealApp-Medium", size: 12.0)).foregroundColor(Color.black.opacity(0.7))
				}.padding(.leading).padding(.vertical).background(Color.gray.opacity(0.2)).cornerRadius(8)
				
				VStack(alignment: .center) {
					GeometryReader { geometry in
						Button(action: {
							self.addProductFormDataStore.addProductToFirebase()
							self.isVisible = false
						}) {
							Text("Create").font(Font.custom("AirbnbCerealApp-Medium", size: 14.0))
								.frame(width: geometry.size.width - 4,alignment: .center)
							.padding(.vertical)
							.foregroundColor(Color("OceanBlue"))
							.overlay(
								RoundedRectangle(cornerRadius: 8)
								.stroke(Color("OceanBlue"), lineWidth: 3)).offset(x: 2)
						}.disabled(self.addProductFormDataStore.productName == "" || self.addProductFormDataStore.brandName == "" || self.addProductFormDataStore.image == nil)
						}.frame(maxHeight: 50.0, alignment: .center).padding(.vertical)
				}
				

				Spacer()

				
				
			}.padding(.horizontal).sheet(isPresented: self.$showImagePicker) {
					PhotoCaptureView(showImagePicker: self.$showImagePicker, image: self.$addProductFormDataStore.image)
			}
			
					
		.partialSheet(presented: self.$addProductFormDataStore.showCategoryPicker, backgroundColor: Color.white, handlerBarColor: Color.black, enableCover: false, coverColor: Color.black.opacity(0.8)) {
			
			CategoryPickerWheel(selectedCategoryIndex: self.$addProductFormDataStore.selectedCategoryIndex)
			
		}
	
}

class AddProductFormDataStore: ObservableObject {
	@Published var productName: String = ""
	@Published var brandName: String = ""
	@Published var selectedCategoryIndex: Int = 0 {
		didSet {
			if oldValue != selectedCategoryIndex {
				showCategoryPicker = false
			}
		}
	}
	@Published var rating: Float = 0.0
	@Published var image: UIImage? = nil
	
	@Published var showCategoryPicker: Bool = false
	
	let categories = ["drop","vape","edible","pet","topical"]
	
	func addProductToFirebase() {
		
		let callbackToken = UUID().uuidString
		
		let data: [String: Any] =  ["averageRating": self.rating,
		   "brand": self.brandName,
		   "category": categories[self.selectedCategoryIndex],
		   "isTrending": false,
		   "lastUpdated": Date(),
		   "mainIngredient": "cbd",
		   "name": productName,
		   "token": callbackToken]
		
		Firestore.firestore().collection("products").addDocument(data: data) { error in
			let query = Firestore.firestore().collection("products").whereField("token", isEqualTo: callbackToken)
			query.getDocuments { (snapshot, error) in
				if error != nil {
					print((error?.localizedDescription)!)
					return
				}
				
				if let documentID = snapshot?.documents.first?.documentID {
					let imageFileName = "\(documentID).jpeg"
					let storageRef = Storage.storage().reference().child("products/\(imageFileName)")
					if let imageData = self.image!.jpegData(compressionQuality: 0.5) {
						storageRef.putData(imageData, metadata: nil) { (metaData, error) in
							print(metaData)
							print(error)
						}
					}
				}
				

			}
		}
	}
	
	}}
