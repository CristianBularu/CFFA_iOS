//
//  AccountRequests.swift
//  CFFA
//
//  Created by Cristian Bularu on 2/17/20.
//  Copyright © 2020 Cristian Bularu. All rights reserved.
//

import Foundation

protocol PreRequestValidator: Codable {
    func preRequestValidation() -> (succsess: Bool, result: Data?, errors: [String])
}

func ParseResult<T: PreRequestValidator>(codable: T, validator: (succsess:Bool, errors: [String])) -> (succsess: Bool, result: Data?, errors: [String]) {
    let (succsess, _): (Bool, [String]) = validator
    if succsess {
        if let data = try? APIModule.encoder.encode(codable) {
            return (validator.succsess, data, validator.errors)
        }
        APIModule.AppError("Parse Error: PreRequestValidator")
    }
    return (false, nil, validator.errors)
}

func AccountValidator(email: String? = nil, password: String? = nil, fullName: String? = nil) -> (succsess: Bool, errors: [String]) {
    var errors = [String]()
    if email != nil && !isValidEmail(email!) {
        errors.append("Email is not valid.")
    }
    if fullName != nil && (fullName!.count < 4 || fullName!.count > 55) {
        errors.append("Full Name length must range between 4 and 55 characters")
    }
    if password != nil && (password!.count < 6 || password!.count > 99) {
        errors.append("Password length must range between 6 and 99 characters")
    }
    if errors.count != 0 {
        return (false, errors)
    }
    return (true, [])
}

func isValidEmail(_ email: String) -> Bool {
    let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

    let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
    return emailPred.evaluate(with: email)
}

struct AccountSignUp: PreRequestValidator {
    var email: String
    var fullName: String
    var password: String
    var file: Data?
    
    init(email: String, fullName: String, password: String, file: Data?) {
        self.email = email
        self.fullName = fullName
        self.password = password
        self.file = file
    }
    
    func preRequestValidation() -> (succsess: Bool, result: Data?, errors: [String]) {
        return ParseResult(codable: self, validator: AccountValidator(email: email, password: password, fullName: fullName))
    }
}

struct AccountSignIn: PreRequestValidator {
    var email: String
    var password: String
    
    init(email: String, password: String) {
        self.email = email
        self.password = password
    }
    
    func preRequestValidation() -> (succsess: Bool, result: Data?, errors: [String]) {
        return ParseResult(codable: self, validator: AccountValidator(email: email, password: password))
    }
}

struct AccountResetPassword: PreRequestValidator {
    var email: String
    var token: String
    var newPassword: String
    
    init(email: String, token: String, newPassword: String) {
        self.email = email
        self.token = token
        self.newPassword = newPassword
    }
    
    func preRequestValidation() -> (succsess: Bool, result: Data?, errors: [String]) {
        return ParseResult(codable: self, validator: AccountValidator(email: email, password: newPassword))
    }
}

struct AccountSentResetPasswordToken: PreRequestValidator {
    var email: String
    
    init(email: String) {
        self.email = email
    }
    
    func preRequestValidation() -> (succsess: Bool, result: Data?, errors: [String]) {
        return ParseResult(codable: self, validator: AccountValidator(email: email))
    }
}

struct AccountConfirmEmail: PreRequestValidator {
    var email: String
    var token: String
    
    init(email: String, token: String) {
        self.email = email
        self.token = token
    }
    
    func preRequestValidation() -> (succsess: Bool, result: Data?, errors: [String]) {
        return ParseResult(codable: self, validator: AccountValidator(email: email))
    }
}

struct AccountRefreshToken: PreRequestValidator {
    var email: String
    var refreshToken: String
    
    init(email: String, refreshToken: String) {
        self.email = email
        self.refreshToken = refreshToken
    }
    
    func preRequestValidation() -> (succsess: Bool, result: Data?, errors: [String]) {
        return ParseResult(codable: self, validator: AccountValidator(email: email))
    }
}


