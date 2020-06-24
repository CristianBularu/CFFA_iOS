//
//  CustomNavigationController.swift
//  CFFA
//
//  Created by Cristian Bularu on 2/24/20.
//  Copyright © 2020 Cristian Bularu. All rights reserved.
//

import UIKit

class CustomNavigationController: UINavigationController {
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    static func customInit(rootViewController: UIViewController) -> CustomNavigationController {
        let navController = CustomNavigationController(rootViewController: rootViewController)
        return navController
    }
}
