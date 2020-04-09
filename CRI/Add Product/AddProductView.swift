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
	
	@ObservedObject var addProductFormDataStore = AddProductFormDataStore()
	
	@State var showImagePicker = false
	
    var body: some View {
		NavigationView {
			VStack {
				
				Button(action: {
					self.showImagePicker = true
				}) {
					if self.addProductFormDataStore.image == nil {
						Text("+ Image")
						.fontWeight(.semibold)
						.font(.subheadline)
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
					
				}
				
				Button(action: {
					self.addProductFormDataStore.addProductToFirebase()
				}) {
					Text("Create")
					.fontWeight(.semibold)
					.font(.subheadline)
					.padding(.horizontal, 60.0)
					.foregroundColor(Color("Blue"))
					.padding()
					.overlay(
						RoundedRectangle(cornerRadius: 20)
							.stroke(Color("Blue"), lineWidth: 3))
				}.padding(.top)
				
				Spacer()

				
			}.padding(.horizontal)
			
			.navigationBarTitle("Add Product")
		}.sheet(isPresented: self.$showImagePicker) {
			PhotoCaptureView(showImagePicker: self.$showImagePicker, image: self.$addProductFormDataStore.image)
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
	@Published var image: UIImage? = nil
	
	func addProductToFirebase() {
		
		let callbackToken = UUID().uuidString
		
		let data: [String: Any] =  ["averageRating": self.rating,
		   "brand": self.brandName,
		   "category": self.selectedCategory,
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
	
}
