//
//  Stars.swift
//  CannaRateIt
//
//  Created by Dong Kang on 9/28/19.
//  Copyright © 2019 Yooniverse. All rights reserved.
//

import SwiftUI

struct Stars: View {
	private var count: Int
	
	init(count: Int) {
		self.count = count
	}
	
    var body: some View {
		HStack(spacing: 0) {
			ForEach((0..<count), id: \.self) { index in
				Image("star").resizable().renderingMode(.template).frame(width: 20, height: 20, alignment: .center).foregroundColor(.yellow)
			}
		}.accentColor(.yellow)
		
    }
}

struct Stars_Previews: PreviewProvider {
    static var previews: some View {
		Stars(count: 4)
    }
}
