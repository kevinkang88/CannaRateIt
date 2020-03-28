//
//  CastegoryPickerView.swift
//  CRI
//
//  Created by Dong Kang on 3/28/20.
//  Copyright © 2020 Yooniverse. All rights reserved.
//

import SwiftUI

struct CastegoryPickerView: View {
    var body: some View {
		HStack(alignment: .center, spacing: 20.0) {
			CategoryPickerCell(iconName: "edible-category", categoryName: "edible")
			CategoryPickerCell(iconName: "pet-category", categoryName: "pet")
			Spacer()
		}
	}
}

struct CastegoryPickerView_Previews: PreviewProvider {
    static var previews: some View {
        CastegoryPickerView()
    }
}
