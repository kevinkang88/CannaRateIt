//
//  BarGraph.swift
//  CRI
//
//  Created by Dong Kang on 6/6/20.
//  Copyright © 2020 Yooniverse. All rights reserved.
//

import SwiftUI

struct BarGraph: View {
	
	var titleLabel: String
	var valueRatio: Float
	var color: String
	
    var body: some View {
		GeometryReader { geometry in
			VStack(alignment: .leading, spacing: 0.0) {
				HStack {
					Text(self.titleLabel).font(Font.custom("AirbnbCerealApp-Medium", size: 14.0)).foregroundColor(Color.black.opacity(0.7))
					Text(String(format: "%.0f%%", (self.valueRatio) * 100)).font(Font.custom("AirbnbCerealApp-Light", size: 12.0)).foregroundColor(Color.black.opacity(0.7))
					Spacer()
				}
				ZStack(alignment: .leading) {
					Rectangle().frame(width: geometry.size.width, height: 5.0).foregroundColor(Color.black.opacity(0.2))
					Rectangle().frame(width: geometry.size.width * CGFloat(self.valueRatio), height: 5.0).foregroundColor(Color("\(self.color)"))
				}
			}
		}
    }
}
