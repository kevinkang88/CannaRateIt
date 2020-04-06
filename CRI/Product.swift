//
//  TinyProduct.swift
//  CannaRateIt
//
//  Created by Dong Kang on 9/23/19.
//  Copyright © 2019 Yooniverse. All rights reserved.
//

import Foundation

struct Product: Hashable, Codable, Identifiable {
	// only optional for exporting
	var id: String?
	var name: String
	var brand: String
	var category: Category
	var mainIngredient: MainIngredient
	var primaryImage: String
	var isTrending: Bool
	var averageRating: Float
	var lastUpdated: Date?
	
	enum Category: String, CaseIterable, Codable, Hashable {
		case capsule = "capsule"
		case drop = "drop"
		case edible = "edible"
		case pet = "pet"
		case topical = "topical"
		case vape = "vape"
	}
	
	enum MainIngredient: String, CaseIterable, Codable, Hashable {
		case cbd = "cbd"
	}
}
