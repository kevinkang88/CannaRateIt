//
//  RemoteImageURL.swift
//  CannaRateIt
//
//  Created by Dong Kang on 9/23/19.
//  Copyright © 2019 Yooniverse. All rights reserved.
//

import Foundation
import SwiftUI
import UIKit
import Combine

import FirebaseStorage

class ImageLoader: ObservableObject {
    var didChange = PassthroughSubject<Data, Never>()
    var data = Data() {
        didSet {
            didChange.send(data)
        }
    }

    init(ref:String) {
		
		let storageRef = Storage.storage().reference().child("/\(ref)")
		storageRef.getData(maxSize: 1 * 700 * 700) { data, error in
			if let error = error {
				print("erroed out \(error)")
			} else {
				guard let data = data else { return }
				DispatchQueue.main.async {
					self.data = data
				}
			}
			
		}
    }
}
