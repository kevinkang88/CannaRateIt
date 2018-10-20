//
//  Environment.swift
//  CannaRateIt
//
//  Created by Dong Kang on 10/20/18.
//  Copyright © 2018 Yooniverse. All rights reserved.
//

import Foundation

public enum PlistKey {
	case BaseURL
	
	func value() -> String {
		switch self {
		case .BaseURL:
			return "base_url"
		}
	}
}

public struct Environment {
	fileprivate var plist: [String: Any] {
		get {
			if let dict = Bundle.main.infoDictionary {
				return dict
			} else {
				fatalError("no plist found")
			}
		}
	}
	
	func getValue(key: PlistKey) -> String {
		switch key {
		case .BaseURL:
			return plist[PlistKey.BaseURL.value()] as! String
		}
	}
}
