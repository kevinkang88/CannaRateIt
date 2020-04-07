//
//  ProductCardCell.swift
//  CRI
//
//  Created by Dong Kang on 4/6/20.
//  Copyright © 2020 Yooniverse. All rights reserved.
//

import SwiftUI

struct ProductCardCell: View {
	
	var product: Product
	
	init(product: Product) {
		self.product = product
	}
	
    var body: some View {
		VStack(alignment: .leading) {
			VStack(alignment: .center) {
				ZStack(alignment: .topLeading) {
					ImageView(withURL: self.product.primaryImage ?? "").frame(width: 160, height: 213, alignment: .center).clipped().cornerRadius(20).colorMultiply(.gray)
					VStack(alignment: .leading, spacing: 10.0) {
						Text(self.product.name).font(Font.system(size: 16.0, weight: .bold, design: .monospaced)).lineLimit(3).padding(.leading).padding(.top).foregroundColor(.white).opacity(1.0)
						Text("by \(self.product.brand)").font(Font.system(size: 12.0, weight: .medium, design: .monospaced)).lineLimit(2).padding(.horizontal).foregroundColor(.white).opacity(0.8)
					}
				}
				
				Stars(count: Int(self.product.averageRating)).padding(.top, -40)
				
				Spacer().frame(height: 8.0)
			}.cornerRadius(20.0)
			Text("Updated 2 days ago").font(Font.custom("AirbnbCerealApp-Light", size: 10.0)).padding(.horizontal, 10.0)
		}
    }
}

//struct ProductCardCell_Previews: PreviewProvider {
//    static var previews: some View {
//        ProductCardCell()
//    }
//}

extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape( RoundedCorner(radius: radius, corners: corners) )
    }
}

struct RoundedCorner: Shape {

    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}
