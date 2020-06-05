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
					self.addProductFormDataStore.showPartialSheet = true
				}
			}.frame(height: 60.0)
			
			GeometryReader { geometry in
				HStack {
					Text("Rating").font(Font.custom("AirbnbCerealApp-Medium", size: 12.0)).foregroundColor(Color.black.opacity(0.7)).padding(.horizontal)
					Text("\(String(format: "%.1f", self.addProductFormDataStore.rating))"
					).font(Font.custom("AirbnbCerealApp-Medium", size: 14.0))
					Spacer()
				}.frame(width: geometry.size.width, height: 60.0).background(Color.gray.opacity(0.2)).cornerRadius(8).onTapGesture {
					self.addProductFormDataStore.showRatingsPicker = true
					self.addProductFormDataStore.showPartialSheet = true
				}
			}.frame(height: 60.0)
	
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

			
			
		}
		.padding(.horizontal)
		.sheet(isPresented: self.$showImagePicker) {
			PhotoCaptureView(showImagePicker: self.$showImagePicker, image: self.$addProductFormDataStore.image)}
		.partialSheet(presented: self.$addProductFormDataStore.showPartialSheet, backgroundColor: Color.white, handlerBarColor: Color.black, enableCover: false, coverColor: Color.black.opacity(0.8)) {
			Group {
				if self.addProductFormDataStore.showRatingsPicker {
										RatingPicker(happyRating: self.$addProductFormDataStore.happyRating, euphoricRating: self.$addProductFormDataStore.euphoricRating, relaxedRating: self.$addProductFormDataStore.relaxedRating, upliftedRating: self.$addProductFormDataStore.upliftedRating, creativeRating: self.$addProductFormDataStore.creativeRating, stressRating: self.$addProductFormDataStore.stressRating, anxietyRating: self.$addProductFormDataStore.anxietyRating, depressionRating: self.$addProductFormDataStore.depressionRating, painRating: self.$addProductFormDataStore.painRating, insomniaRating: self.$addProductFormDataStore.insomniaRating, drymouthRating: self.$addProductFormDataStore.drymouthRating, dryeyesRating: self.$addProductFormDataStore.dryeyesRating, paranoidRating: self.$addProductFormDataStore.paranoidRating, dizzyRating: self.$addProductFormDataStore.dizzyRating, anxiousRating: self.$addProductFormDataStore.anxiousRating)
				} else {
					CategoryPickerWheel(selectedCategoryIndex: self.$addProductFormDataStore.selectedCategoryIndex)
				}
			}
		}
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
	
	@Published var showCategoryPicker: Bool = false {
		didSet {
			if showCategoryPicker == true {
				showRatingsPicker = false
			}
		}
	}
	
	@Published var showRatingsPicker: Bool = false {
		didSet {
			if showRatingsPicker == true {
				showCategoryPicker = false
			}
		}
	}
	
	@Published var showPartialSheet: Bool = false
	
	func categoryOrRatingView(happyRating: Binding<Float>, euphoricRating: Binding<Float>, relaxedRating: Binding<Float>, upliftedRating: Binding<Float>, creativeRating: Binding<Float>, stressRating: Binding<Float>, anxietyRating: Binding<Float>, depressionRating: Binding<Float>, painRating: Binding<Float>, insomniaRating: Binding<Float>, drymouthRating: Binding<Float>, dryeyesRating: Binding<Float>, paranoidRating: Binding<Float>, dizzyRating: Binding<Float>, anxiousRating: Binding<Float>, selectedCategoryIndex: Binding<Int>) -> some View {
		return Group {
			if showRatingsPicker && showPartialSheet {
				RatingPicker(happyRating: happyRating, euphoricRating: euphoricRating, relaxedRating: relaxedRating, upliftedRating: upliftedRating, creativeRating: creativeRating, stressRating: stressRating, anxietyRating: anxietyRating, depressionRating: depressionRating, painRating: painRating, insomniaRating: insomniaRating, drymouthRating: drymouthRating, dryeyesRating: dryeyesRating, paranoidRating: paranoidRating, dizzyRating: dizzyRating, anxiousRating: anxietyRating)
			} else {
				CategoryPickerWheel(selectedCategoryIndex: selectedCategoryIndex)
			}
		}

	}
		
	@Published var happyRating: Float = 0.0 {
		didSet {
			self.calculateRating()
		}
	}
	@Published var euphoricRating: Float = 0.0 {
		didSet {
			self.calculateRating()
		}
	}
	@Published var relaxedRating: Float = 0.0 {
		didSet {
			self.calculateRating()
		}
	}
	@Published var upliftedRating: Float = 0.0 {
		didSet {
			self.calculateRating()
		}
	}
	@Published var creativeRating: Float = 0.0 {
		didSet {
			self.calculateRating()
		}
	}

	@Published var stressRating: Float = 0.0 {
		didSet {
			self.calculateRating()
		}
	}
	@Published var anxietyRating: Float = 0.0 {
		didSet {
			self.calculateRating()
		}
	}
	@Published var depressionRating: Float = 0.0 {
		didSet {
			self.calculateRating()
		}
	}
	@Published var painRating: Float = 0.0 {
		didSet {
			self.calculateRating()
		}
	}
	@Published var insomniaRating: Float = 0.0 {
		didSet {
			self.calculateRating()
		}
	}
	
	@Published var drymouthRating: Float = 0.0 {
		didSet {
			self.calculateRating()
		}
	}
	@Published var dryeyesRating: Float = 0.0 {
		didSet {
			self.calculateRating()
		}
	}
	@Published var paranoidRating: Float = 0.0 {
		didSet {
			self.calculateRating()
		}
	}
	@Published var dizzyRating: Float = 0.0 {
		didSet {
			self.calculateRating()
		}
	}
	@Published var anxiousRating: Float = 0.0 {
		didSet {
			self.calculateRating()
		}
	}
	
	private func calculateRating() {
		self.rating = (happyRating + euphoricRating + relaxedRating + upliftedRating + creativeRating + stressRating + anxietyRating + depressionRating + painRating + insomniaRating + (5 - drymouthRating) + (5 - dryeyesRating) + (5 - paranoidRating) + (5 - dizzyRating) + (5 - anxiousRating)) / 15.0
	}
	
	let categories = ["drop","vape","edible","pet","topical"]
	
	func addProductToFirebase() {
		
		let callbackToken = UUID().uuidString
		
		let data: [String: Any] =  [
			"averageRating": self.rating,
			"brand": self.brandName,
			"category": categories[self.selectedCategoryIndex],
			"isTrending": false,
			"lastUpdated": Date(),
			"mainIngredient": "cbd",
			"name": productName,
			"token": callbackToken,
			"totalRatings": 1
		]
		
		Firestore.firestore().collection("products").addDocument(data: data) { error in
			let query = Firestore.firestore().collection("products").whereField("token", isEqualTo: callbackToken)
			query.getDocuments { (snapshot, error) in
				if error != nil {
					print((error?.localizedDescription)!)
					return
				}
				
				if let documentID = snapshot?.documents.first?.documentID {
					// add review
					let data: [String: Any] = ["productID": documentID,
											   "userID": Auth.auth().currentUser?.uid,
											   "reviewText": "",
											   "averageRating": self.rating,
											   "happyRating": self.happyRating,
											   "euphoricRating": self.euphoricRating,
											   "relaxedRating": self.relaxedRating,
											   "upliftedRating": self.upliftedRating,
											   "creativeRating": self.creativeRating,
											   "stressRating": self.stressRating,
											   "anxietyRating": self.anxiousRating,
											   "depressionRating": self.depressionRating,
											   "painRating": self.painRating,
											   "insomniaRating": self.insomniaRating,
											   "drymouthRating": self.drymouthRating,
											   "dryeyesRating": self.dryeyesRating,
											   "paranoidRating": self.paranoidRating,
											   "dizzyRating": self.dizzyRating,
											   "anxiousRating":self.anxiousRating,
												"lastUpdated": Date()
												]
					Firestore.firestore().collection("reviews").addDocument(data: data) { error in
					}
					
					
					let imageFileName = "\(documentID).jpeg"
					let storageRef = Storage.storage().reference().child("products/\(imageFileName)")
					if let imageData = self.image!.jpegData(compressionQuality: 0.8) {
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
