//
//  RatingPicker.swift
//  CRI
//
//  Created by Dong Kang on 6/4/20.
//  Copyright © 2020 Yooniverse. All rights reserved.
//

import SwiftUI

struct RatingPicker: View {
	
	@Binding var happyRating: Float
	@Binding var euphoricRating: Float
	@Binding var relaxedRating: Float
	@Binding var upliftedRating: Float
	@Binding var creativeRating: Float
	
	@Binding var stressRating: Float
	@Binding var anxietyRating: Float
	@Binding var depressionRating: Float
	@Binding var painRating: Float
	@Binding var insomniaRating: Float
	
	@Binding var drymouthRating: Float
	@Binding var dryeyesRating: Float
	@Binding var paranoidRating: Float
	@Binding var dizzyRating: Float
	@Binding var anxiousRating: Float
	
	
    var body: some View {
			ScrollView(.vertical, showsIndicators: false) {
				VStack {
					Text("Feelings ...").font(Font.custom("AirbnbCerealApp-Medium", size: 16.0)).foregroundColor(Color.black.opacity(0.7))
					Pill(selectedRating: self._happyRating, labelText: "Happy", color: Color("Green")).frame(height: 50).padding(.horizontal)
					Pill(selectedRating: self._euphoricRating, labelText: "Euphoric", color: Color("Green")).frame(height: 50).padding(.horizontal)
					Pill(selectedRating: self._relaxedRating, labelText: "Relaxed", color: Color("Green")).frame(height: 50).padding(.horizontal)
					Pill(selectedRating: self._upliftedRating, labelText: "Uplifted", color: Color("Green")).frame(height: 50).padding(.horizontal)
					Pill(selectedRating: self._creativeRating, labelText: "Creative", color: Color("Green")).frame(height: 50).padding(.horizontal)
				}
				Divider()
				VStack {
					Text("Helps with ...").font(Font.custom("AirbnbCerealApp-Medium", size: 16.0)).foregroundColor(Color.black.opacity(0.7))
					Pill(selectedRating: self._stressRating, labelText: "Stress", color: Color("Green")).frame(height: 50).padding(.horizontal)
					Pill(selectedRating: self._anxietyRating, labelText: "Anxiety", color: Color("Green")).frame(height: 50).padding(.horizontal)
					Pill(selectedRating: self._depressionRating, labelText: "Depression", color: Color("Green")).frame(height: 50).padding(.horizontal)
					Pill(selectedRating: self._painRating, labelText: "Pain", color: Color("Green")).frame(height: 50).padding(.horizontal)
					Pill(selectedRating: self._insomniaRating, labelText: "Insomnia", color: Color("Green")).frame(height: 50).padding(.horizontal)
				}
				Divider()
				VStack {
					Text("Negatives ...").font(Font.custom("AirbnbCerealApp-Medium", size: 16.0)).foregroundColor(Color.black.opacity(0.7))
					Pill(selectedRating: self._drymouthRating, labelText: "Dry Mouth", color: Color.red.opacity(0.7)).frame(height: 50).padding(.horizontal)
					Pill(selectedRating: self._dryeyesRating, labelText: "Dry Eyes", color: Color.red.opacity(0.7)).frame(height: 50).padding(.horizontal)
					Pill(selectedRating: self._paranoidRating, labelText: "Paranoid", color: Color.red.opacity(0.7)).frame(height: 50).padding(.horizontal)
					Pill(selectedRating: self._dizzyRating, labelText: "Dizzy", color: Color.red.opacity(0.7)).frame(height: 50).padding(.horizontal)
					Pill(selectedRating: self._anxiousRating, labelText: "Anxious", color: Color.red.opacity(0.7)).frame(height: 50).padding(.horizontal)
				}

				Spacer().frame(height: 100.0)
				
			}.frame(width: UIScreen.main.bounds.width)
	}
}
