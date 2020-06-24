//
//  AccountResponses.swift
//  CFFA
//
//  Created by Cristian Bularu on 2/17/20.
//  Copyright © 2020 Cristian Bularu. All rights reserved.
//

import Foundation

struct ReAuthentification: Codable {
    var id: String
    var name: String
    var `extension`: String?
    var email: String
    var accessToken: String
    var refreshToken: String
}
