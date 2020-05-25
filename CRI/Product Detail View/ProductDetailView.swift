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
		VStack {
			ZStack(alignment: .topLeading) {
				ImageView(withURL: "products/\(product.id ?? "").jpeg").frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height / 1.8, alignment: .center)
							.edgesIgnoringSafeArea(.top)
				
				Button(action: {
					 self.presentation.wrappedValue.dismiss()
				}) {
					Image("back-icon").resizable().frame(width: 50, height: 50, alignment: .center)
				}
			}
			
			Spacer()
		}.navigationBarTitle("") //this must be empty
		.navigationBarHidden(true)
		.navigationBarBackButtonHidden(true)
		
    }
}
