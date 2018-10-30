//
//  Product.swift
//  CannaRateIt
//
//  Created by Dong Kang on 10/27/18.
//  Copyright © 2018 Yooniverse. All rights reserved.
//

import Foundation

struct Product: Decodable {
	var brandName: String
	var flavor: String
	var strainType: String
	var category: String
	var subCategory: String?
	var rating: Double?
	
	init(brandName: String, flavor: String, strainType: String, category: String,_ subCategory: String? = nil, _ rating: Double? = nil) {
		self.brandName = brandName
		self.flavor = flavor
		self.strainType = strainType
		self.category = category
		self.subCategory = subCategory
		self.rating = rating
	}
	
	enum CodingKeys: String, CodingKey {
		case brandName = "brand_name", flavor = "flavor", strainType = "strain_type", category = "category", subCategory = "sub_category", rating = "rating"
	}
}
