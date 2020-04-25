//
//  TinyProduct.swift
//  CannaRateIt
//
//  Created by Dong Kang on 9/23/19.
//  Copyright © 2019 Yooniverse. All rights reserved.
//

import Foundation

import Fuse

struct Product: Hashable, Codable, Identifiable, Fuseable {
	// only optional for exporting
	var id: String?
	var name: String
	var brand: String
	var category: Category
	var mainIngredient: MainIngredient
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
	
	var properties: [FuseProperty] {
		return [
			FuseProperty(name: self.name, weight: 0.6),
			FuseProperty(name: self.brand, weight: 0.4)
		]
	}
}
