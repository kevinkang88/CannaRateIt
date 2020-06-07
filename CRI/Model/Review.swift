//
//  Review.swift
//  CRI
//
//  Created by Dong Kang on 5/30/20.
//  Copyright © 2020 Yooniverse. All rights reserved.
//

import Foundation

struct Review: Hashable, Codable, Identifiable {
	var id: String?
	var userID: String
	var productID: String
	var averageRating: Float
	var reviewText: String
	
	var anxietyRating: Float
	var anxiousRating: Float
	var creativeRating: Float
	var depressionRating: Float
	var dizzyRating: Float
	var dryeyesRating: Float
	var drymouthRating: Float
	var euphoricRating: Float
	var happyRating: Float
	var insomniaRating: Float
	var painRating: Float
	var paranoidRating: Float
	var relaxedRating: Float
	var stressRating: Float
	var upliftedRating: Float
	
	enum Category: String, CaseIterable, Codable, Hashable {
		case userID
		case productID
		case averageRating
		case reviewText
		case anxietyRating
		case anxiousRating
		case creativeRating
		case depressionRating
		case dizzyRating
		case dryeyesRating
		case drymouthRating
		case euphoricRating
		case happyRating
		case insomniaRating
		case painRating
		case paranoidRating
		case relaxedRating
		case stressRating
		case upliftedRating
	}
}
