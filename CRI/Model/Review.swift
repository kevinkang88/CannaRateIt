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
	var rating: Float
	var reviewText: String
	
	enum Category: String, CaseIterable, Codable, Hashable {
		case userID
		case productID
		case rating
		case reviewText
	}
}
