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
			
			Stepper(onIncrement: {
				if self.dataStore.rating <= 4.5 {
					self.dataStore.rating += 0.5
				}
			}, onDecrement: {
				if self.dataStore.rating >= 0.5 {
					self.dataStore.rating -= 0.5
				}
			}) {
				Text("Rating: \(String(format: "%.1f", self.dataStore.rating))").font(Font.custom("AirbnbCerealApp-Medium", size: 12.0)).foregroundColor(Color.black.opacity(0.7))
			}.padding(.leading).padding(.vertical).background(Color.gray.opacity(0.2)).cornerRadius(8)

			
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
		}.onAppear {
			self.dataStore.productID = self.productID
		}.padding()
	}
}

class AddReviewFormDataStore: ObservableObject {
	@Published var reviewText: String = "" {
		didSet {
			self.finalReviewText = self.reviewText
			print(reviewText)
			print(finalReviewText)
		}
	}
	@Published var rating: Float = 0.0
	
	var finalReviewText = ""
	
	var productID: String = ""
	
	static let shared = AddReviewFormDataStore()
	
    @Environment(\.presentationMode) private var presentation
		
	func addReviewTooFirebase() {
		let data: [String: Any] = ["productID": self.productID,
								   "userID": Auth.auth().currentUser?.uid,
								   "reviewText": self.reviewText,
								   "rating": self.rating
								   ]
		print(self.reviewText)
		print(self.rating)
		Firestore.firestore().collection("reviews").addDocument(data: data) { error in
			 self.presentation.wrappedValue.dismiss()
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
			 print("text now: \(String(describing: textView.text!))")
			self.parent.text = textView.text
		 }
	 }
	
}
