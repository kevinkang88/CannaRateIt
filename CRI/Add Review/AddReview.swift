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
			MultilineTextView(text: self.$dataStore.reviewText).frame(minHeight: 150, maxHeight: 150).border(Color.black, width: 1.0)
			Stepper("Rating: \(String(format: "%.1f", self.dataStore.rating))", onIncrement: {
				if self.dataStore.rating <= 4.5 {
					self.dataStore.rating += 0.5
				}
			}, onDecrement: {
				if self.dataStore.rating >= 0.5 {
					self.dataStore.rating -= 0.5
				}
			}).padding(.top)
			Button(action: {
				self.dataStore.addReviewTooFirebase()
				self.isVisible = false
			}) {
				Text("submit")
			}
			Spacer()
		}.onAppear {
			self.dataStore.productID = self.productID
		}
	}
}

class AddReviewFormDataStore: ObservableObject {
	@Published var reviewText: String = "review here yo" {
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
