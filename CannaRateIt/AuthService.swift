//
//  AuthService.swift
//  CannaRateIt
//
//  Created by Dong Kang on 10/21/18.
//  Copyright © 2018 Yooniverse. All rights reserved.
//

import Foundation

enum Result<Value> {
	case success(Value)
	case failure(Error)
}

struct AuthService {
	func login(_ email: String?, _ password: String?) {
		// prepare json data
		let json: [String: Any] = ["email": "yooniverse88@gmail.com",
								   "password": "password1"]
		let jsonData = try? JSONSerialization.data(withJSONObject: json)
		
		let url = URL(string: "\(Environment().getValue(key: .baseURL) + "authenticate/")")
			var request = URLRequest(url: url!)
		request.httpMethod = "POST"
		request.setValue("application/json", forHTTPHeaderField: "Content-Type")
		request.httpBody = jsonData
		let task = URLSession.shared.dataTask(with: request) { data, response, error in
			guard let data = data, error == nil else {
				print(error?.localizedDescription ?? "No data")
				return
			}
			let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
			if let responseJSON = responseJSON as? [String: Any],
				let token = responseJSON["auth_token"] {
				print(responseJSON)
				
				let ud = UserDefaults.standard
				ud.set(token, forKey: "authToken")
			}
		}
		
		task.resume()
	}
	
	init() {}
}
