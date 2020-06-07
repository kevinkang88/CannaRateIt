//
//  AddReview.swift
//  CRI
//
//  Created by Dong Kang on 5/26/20.
//  Copyright © 2020 Yooniverse. All rights reserved.
//

import SwiftUI
import Combine

import Firebase

struct AddReview: View {
				
	var productID: String
	
	@ObservedObject var dataStore: AddReviewFormDataStore
	
	@Binding var isVisible: Bool
				
    var body: some View {
		VStack {
			HStack {
				Button(action: {
					self.isVisible = false
				}) {
					Image("close-icon").renderingMode(.template).resizable().frame(width: 40, height: 40, alignment: .center).foregroundColor(Color.black)
				}.padding(.vertical)
				
				Spacer()
			}
			
			MultilineTextView(text: self.$dataStore.reviewText).frame(minHeight: 150, maxHeight: 150)
			
			GeometryReader { geometry in
				HStack {
					Text("Rating").font(Font.custom("AirbnbCerealApp-Medium", size: 12.0)).foregroundColor(Color.black.opacity(0.7)).padding(.horizontal)
					Text("\(String(format: "%.1f", self.dataStore.rating))"
					).font(Font.custom("AirbnbCerealApp-Medium", size: 14.0))
					Spacer()
				}.frame(width: geometry.size.width, height: 60.0).background(Color.gray.opacity(0.2)).cornerRadius(8).onTapGesture {
					self.dataStore.showPartialSheet = true
				}
			}.frame(height: 60.0)

			
			GeometryReader { geometry in
			Button(action: {
				self.dataStore.addReviewTooFirebase()
				self.isVisible = false
				
			}) {
				Text("Submit").font(Font.custom("AirbnbCerealApp-Medium", size: 14.0))
					.frame(width: geometry.size.width - 4,alignment: .center)
				.padding(.vertical)
				.foregroundColor(Color("OceanBlue"))
				.overlay(
					RoundedRectangle(cornerRadius: 8)
					.stroke(Color("OceanBlue"), lineWidth: 3)).offset(x: 2)
			}.disabled(self.dataStore.reviewText == "")
			}.frame(maxHeight: 50.0, alignment: .center).padding(.vertical)
			
			Spacer()
		}.padding(.horizontal)
		.onAppear {
			self.dataStore.productID = self.productID
			self.dataStore.isVisible = self.isVisible
		}.partialSheet(presented: self.$dataStore.showPartialSheet, backgroundColor: Color.white, handlerBarColor: Color.black, enableCover: false, coverColor: Color.black.opacity(0.8)) {
			RatingPicker(happyRating: self.$dataStore.happyRating, euphoricRating: self.$dataStore.euphoricRating, relaxedRating: self.$dataStore.relaxedRating, upliftedRating: self.$dataStore.upliftedRating, creativeRating: self.$dataStore.creativeRating, stressRating: self.$dataStore.stressRating, anxietyRating: self.$dataStore.anxietyRating, depressionRating: self.$dataStore.depressionRating, painRating: self.$dataStore.painRating, insomniaRating: self.$dataStore.insomniaRating, drymouthRating: self.$dataStore.drymouthRating, dryeyesRating: self.$dataStore.dryeyesRating, paranoidRating: self.$dataStore.paranoidRating, dizzyRating: self.$dataStore.dizzyRating, anxiousRating: self.$dataStore.anxiousRating)
		}.padding()
	}
}

class AddReviewFormDataStore: ObservableObject {
	
	@Published var isVisible = true
	@Published var reviewText: String = "" {
		didSet {
			self.finalReviewText = self.reviewText
		}
	}
	@Published var rating: Float = 0.0
	
	@Published var showPartialSheet: Bool = false
	
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
	
	var finalReviewText = ""
	
	var productID: String = ""
	
	static let shared = AddReviewFormDataStore()
	
    @Environment(\.presentationMode) private var presentation
		
	func addReviewTooFirebase() {
		Firestore.firestore().collection("products").document(self.productID).getDocument { snapshot, error in
			if error != nil {
				print(error?.localizedDescription)
				return
			}
						
			let totalRatings = snapshot?.data()!["totalRatings"] as? Int
			let averageRating = snapshot?.data()!["averageRating"] as? Double
			
			Firestore.firestore().collection("products").document(self.productID).updateData(
				[
					"totalRatings": totalRatings! + 1,
					"averageRating": (((Float(averageRating!) * Float(totalRatings!)) + self.rating) / Float(totalRatings! + 1))
			]) { _ in
				let data: [String: Any] = ["productID": self.productID,
										   "userID": Auth.auth().currentUser?.uid,
										   "reviewText": self.finalReviewText,
										   "averageRating": self.rating,
										   "happyRating": self.happyRating,
										   "euphoricRating": self.euphoricRating,
										   "relaxedRating": self.relaxedRating,
										   "upliftedRating": self.upliftedRating,
										   "creativeRating": self.creativeRating,
										   "stressRating": self.stressRating,
										   "anxietyRating": self.anxietyRating,
										   "depressionRating": self.depressionRating,
										   "painRating": self.painRating,
										   "insomniaRating": self.insomniaRating,
										   "drymouthRating": self.drymouthRating,
										   "dryeyesRating": self.dryeyesRating,
										   "paranoidRating": self.paranoidRating,
										   "dizzyRating": self.dizzyRating,
										   "anxiousRating":self.anxiousRating,
										   "isProductCreator": false,
											"lastUpdated": Date()
											]
				Firestore.firestore().collection("reviews").addDocument(data: data) { error in
					self.isVisible = false
				}
				
			}
			
		}
	}
}


struct MultilineTextView: UIViewRepresentable {
    @Binding var text: String
		
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    func makeUIView(context: Context) -> UITextView {
        let view = UITextView()
        view.delegate = context.coordinator
        view.isScrollEnabled = true
        view.isEditable = true
        view.isUserInteractionEnabled = true
		view.backgroundColor = UIColor.gray.withAlphaComponent(0.2)
		view.layer.borderWidth = 0.0
		view.layer.cornerRadius = 8.0
		view.font = UIFont(name:"AirbnbCerealApp-Medium",size:14)
		
        return view
    }

    func updateUIView(_ uiView: UITextView, context: Context) {
		uiView.text = text
    }
	
	class Coordinator : NSObject, UITextViewDelegate {

		 var parent: MultilineTextView

		 init(_ uiTextView: MultilineTextView) {
			 self.parent = uiTextView
		 }

		 func textViewDidChange(_ textView: UITextView) {
			self.parent.text = textView.text
		 }
	 }
	
}
