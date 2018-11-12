//
//  Coordinator.swift
//  CannaRateIt
//
//  Created by Dong Kang on 9/15/18.
//  Copyright © 2018 Yooniverse. All rights reserved.
//

import Foundation
import UIKit
protocol Coordinator {
    func start()
    
    func stop()
    
    func navigate(from source: UIViewController, to destination: UIViewController, with identifier: String?, and sender: AnyObject?)
}

extension Coordinator {
    func stop(){}
        
    
    func navigate(from source: UIViewController, to destination: UIViewController, with identifier: String?, and sender: AnyObject?){}
}

