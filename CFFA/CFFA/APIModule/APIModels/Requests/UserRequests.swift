//
//  UserRequests.swift
//  CFFA
//
//  Created by Cristian Bularu on 2/17/20.
//  Copyright © 2020 Cristian Bularu. All rights reserved.
//

import Foundation

struct UserChangeName: PreRequestValidator {
    var fullName: String
    
    init(fullName: String) {
        self.fullName = fullName
    }
    
    func preRequestValidation() -> (succsess: Bool, result: Data?, errors: [String]) {
        return ParseResult(codable: self, validator: AccountValidator(fullName: fullName))
    }
}

struct UserChangePassword: PreRequestValidator {
    var oldPassword: String
    var newPassword: String
    
    init(oldPassword: String, newPassword: String) {
        self.oldPassword = oldPassword
        self.newPassword = newPassword
    }
    
    func preRequestValidation() -> (succsess: Bool, result: Data?, errors: [String]) {
        return ParseResult(codable: self, validator: AccountValidator(password: newPassword))
    }
}
