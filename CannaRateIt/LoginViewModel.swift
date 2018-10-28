//
//  LoginViewModel.swift
//  CannaRateIt
//
//  Created by Dong Kang on 10/21/18.
//  Copyright © 2018 Yooniverse. All rights reserved.
//

import Foundation

class LoginViewModel {
	private(set) var authService: AuthService!
	
	init(service: AuthService) {
		self.authService = service
	}
}

extension LoginViewModel {
	
}
