//
//  ProductDetailView.swift
//  CRI
//
//  Created by Dong Kang on 5/9/20.
//  Copyright © 2020 Yooniverse. All rights reserved.
//

import SwiftUI

struct ProductDetailView: View {
	
	var product: Product
		
    @Environment(\.presentationMode) private var presentation
	
	init(product: Product) {
		self.product = product
	}
	
    var body: some View {
		ZStack(alignment: .top) {
			VStack {
				ZStack(alignment: .topLeading) {
					ImageView(withURL: "products/\(product.id ?? "").jpeg").frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height / 1.8, alignment: .center)
								.edgesIgnoringSafeArea(.top)
					
					Button(action: {
						 self.presentation.wrappedValue.dismiss()
					}) {
						Image("back-icon").renderingMode(.template).resizable().frame(width: 50, height: 50, alignment: .center).foregroundColor(Color.black)
					}.offset(y: 30.0)
				}
				
				Spacer()
			}
			
			
			ScrollView {
				
				Spacer().frame(height: 20.0)
				
				HStack {
					Text(product.name).font(Font.custom("AirbnbCerealApp-Medium", size: 20.0))
						.foregroundColor(Color.black).padding(.leading).padding(.top)
					Spacer()
				}
				
				HStack {
					Text(product.brand).font(Font.custom("AirbnbCerealApp-Light", size: 16.0))
						.foregroundColor(Color.gray).padding(.leading)
					
					Image("approval-icon").renderingMode(.template).resizable().aspectRatio(contentMode: .fit).frame(width: 20, height: 20).foregroundColor(Color.green)
					Spacer()
				}
				
				Divider().padding()
				
				HStack {
					HStack {
						Image("star").resizable().renderingMode(.template).frame(width: 16, height: 16, alignment: .center).foregroundColor(.white)
						Text("4.0").font(Font.custom("AirbnbCerealApp-Medium", size: 14.0)).foregroundColor(Color.white)
					}.padding(.all, 8.0).background(Color.orange).cornerRadius(10.0, corners: .allCorners)
					
					Spacer()
				}.padding(.leading)
				
				HStack {
					Text("Reviews").font(Font.custom("AirbnbCerealApp-Medium", size: 24.0)).foregroundColor(Color.black).padding()
					Spacer()
				}
				
				
				Spacer()
			}.background(Color.white).frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height / 2).cornerRadius(30.0, corners: .allCorners).offset(y: UIScreen.main.bounds.height / 2.5)
			
			
		}.navigationBarTitle("") //this must be empty
		.navigationBarHidden(true)
			.navigationBarBackButtonHidden(true).frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
		
	}
}
