//
//  Pill.swift
//  CRI
//
//  Created by Dong Kang on 6/3/20.
//  Copyright © 2020 Yooniverse. All rights reserved.
//

import SwiftUI

struct Pill: View {
	
	@Binding var selectedRating: Float
	
	var labelText: String
	
	var color: Color
	
    var body: some View {
		GeometryReader { geometry in
			ZStack(alignment: .leading) {
				HStack(spacing: 0) {
					
					Button(action: {
						self.selectedRating = self.selectedRating == 1.0 ? 0.0 : 1.0
					}) {
						Text("")
						.frame(width: geometry.size.width / 5, height: 50)
						.foregroundColor(.white)
							.background(self.selectedRating > 0 ? RoundedCorners(color: self.color, tl: 30, tr: 0, bl: 30, br: 0) : RoundedCorners(color: .white, tl: 30, tr: 0, bl: 30, br: 0))
					}
					Button(action: {
						self.selectedRating = 2.0
					}) {
						Text("")
						.frame(width: geometry.size.width / 5, height: 50)
						.foregroundColor(.white)
							.background(self.selectedRating > 1 ? RoundedCorners(color: self.color, tl: 0, tr: 0, bl: 0, br: 0) : RoundedCorners(color: .white, tl: 0, tr: 0, bl: 0, br: 0))
					}
					Button(action: {
						self.selectedRating = 3.0
					}) {
						Text("")
						.frame(width: geometry.size.width / 5, height: 50)
						.foregroundColor(.white)
						.background(self.selectedRating > 2 ? RoundedCorners(color: self.color, tl: 0, tr: 0, bl: 0, br: 0) : RoundedCorners(color: .white, tl: 0, tr: 0, bl: 0, br: 0))
					}
					Button(action: {
						self.selectedRating = 4.0
					}) {
						Text("")
						.frame(width: geometry.size.width / 5, height: 50)
						.foregroundColor(.white)
						.background(self.selectedRating > 3 ? RoundedCorners(color: self.color, tl: 0, tr: 0, bl: 0, br: 0) : RoundedCorners(color: .white, tl: 0, tr: 0, bl: 0, br: 0))
					}
					Button(action: {
						self.selectedRating = 5.0
					}) {
						Text("")
						.frame(width: geometry.size.width / 5, height: 50)
						.foregroundColor(.white)
							.background(self.selectedRating > 4 ? RoundedCorners(color: self.color, tl: 0, tr: 30, bl: 0, br: 30) : RoundedCorners(color: .white, tl: 0, tr: 30, bl: 0, br: 30))
					}
				}
				Text("\(self.labelText) \(Int(self.selectedRating / 5 * 100))%").font(Font.custom("AirbnbCerealApp-Medium", size: 14.0)).foregroundColor(Color.black.opacity(0.3)).padding(.leading)
			}

		}
	}
}
