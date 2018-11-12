//
//  AuthService.swift
//  CannaRateIt
//
//  Created by Dong Kang on 10/21/18.
//  Copyright © 2018 Yooniverse. All rights reserved.
//

import Foundation

struct ProductsService {
	func search(query: String, onComplete: @escaping ((_ products: [Product]?, _ error: Error?)->Void)) {
		guard let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else {
			return 
		}
		let urlString = "\(Environment().getValue(key: .baseURL))" + "products/search/\(String(describing: encodedQuery))"

		let url = URL(string: urlString)
		var request = URLRequest(url: url!)
		request.httpMethod = "GET"
		guard let token = UserDefaults.standard.string(forKey: "authToken") as? String else {
			return
		}
		request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

		let task = URLSession.shared.dataTask(with: request) { data, response, error in
			guard let data = data, error == nil else {
				onComplete(nil,error)
				return
			}
			do {
				let responseArray = try JSONDecoder().decode([Product].self, from: data)
				onComplete(responseArray, nil)
			} catch(let error) {
				onComplete(nil, error)
			}

		}
		
		task.resume()
	}
	
	init() {}
}
