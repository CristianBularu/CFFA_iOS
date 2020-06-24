//
//  AccountActions.swift
//  CFFA
//
//  Created by Cristian Bularu on 2/18/20.
//  Copyright © 2020 Cristian Bularu. All rights reserved.
//

import Foundation

class AccountActions {
    
    static func SignIn(email: String, password: String, complition: @escaping (ResponseType, [String]?)->()) {
        
        let validation = AccountSignIn(email: email, password: password).preRequestValidation()
        if !validation.succsess {
            complition(.AppError, validation.errors)
            return
        }
        let request = APIModule.buildURLRequest(.SignIn, "POST", auth: false, body: validation.result!)
        APIModule.executeRequest(urlRequest: request) { (responseType, data) in
            switch responseType {
            case .Ok, .UnConfirmed:
                do {
                    let reAuthentification = try APIModule.decoder.decode(ReAuthentification.self, from: data!)
                    UDefaults.authenInfo = reAuthentification
                    complition(responseType, nil)
                }
                catch {
                    APIModule.AppError("Parse Error: SignIn: \(error)")
                    complition(.AppError, nil)
                }
            case .ConflictInfo:
                let errorString = String(data: data!, encoding: .utf8) ?? ""
                complition(.ConflictInfo, [errorString])
            default:
                complition(responseType, nil)
            }
        }
    }
    
    static func SignUp(email: String, fullName: String, password: String, file: Data?, complition: @escaping (ResponseType, [String]?)->()) {
        
        let validation = AccountSignUp(email: email, fullName: fullName, password: password, file: file).preRequestValidation()
        if !validation.succsess {
            complition(.AppError, validation.errors)
            return
        }
        let request = APIModule.buildURLRequest(.SignUp, "POST", auth: false, body: validation.result!)
        APIModule.executeRequest(urlRequest: request) { (responseType, data) in
            switch responseType {
            case .ConflictInfo:
                let errorString = String(data: data!, encoding: .utf8) ?? ""
                complition(.ConflictInfo, [errorString])
            default:
                complition(responseType, nil)
            }
        }
    }
    
    static func ResetPassword(email: String, token: String, newPassword: String, complition: @escaping (ResponseType, [String]?)->()) {
        
        let validation = AccountResetPassword(email: email, token: token, newPassword: newPassword).preRequestValidation()
        if !validation.succsess {
            complition(.AppError, validation.errors)
            return
        }
        let request = APIModule.buildURLRequest(.ResetPassword, "POST", auth: false, body: validation.result!)
        APIModule.executeRequest(urlRequest: request) { (responseType, data) in
            switch responseType {
            case .Ok:
                do {
                    let reAuthentification = try APIModule.decoder.decode(ReAuthentification.self, from: data!)
                    UDefaults.authenInfo = reAuthentification
                    complition(.Ok, nil)
                }
                catch {
                    APIModule.AppError("Parse Error: ResetPassword: \(error)")
                    complition(.AppError, nil)
                }
            case .ConflictInfo:
                let errorString = String(data: data!, encoding: .utf8) ?? ""
                complition(.ConflictInfo, [errorString])
            default:
                complition(responseType, nil)
            }
        }
    }
    
    static func ConfirmEmail(email: String, token: String, complition: @escaping (ResponseType, [String]?)->()) {
        
        let validation = AccountConfirmEmail(email: email, token: token).preRequestValidation()
        if !validation.succsess {
            complition(.AppError, validation.errors)
            return
        }
        let request = APIModule.buildURLRequest(.ConfirmEmail, "POST", auth: false, body: validation.result!)
        APIModule.executeRequest(urlRequest: request) { (responseType, data) in
            switch responseType {
            case .Ok:
                do {
                    let reAuthentification = try APIModule.decoder.decode(ReAuthentification.self, from: data!)
                    UDefaults.authenInfo = reAuthentification
                    complition(.Ok, nil)
                }
                catch {
                    APIModule.AppError("Parse Error: ConfirmEmail: \(error)")
                    complition(.AppError, nil)
                }
            case .ConflictInfo:
                let errorString = String(data: data!, encoding: .utf8) ?? ""
                complition(.ConflictInfo, [errorString])
            default:
                complition(responseType, nil)
            }
        }
    }
    
    static func SentResetPasswordToken(email: String, complition: @escaping (ResponseType, [String]?)->()) {
        
        let validation = AccountSentResetPasswordToken(email: email).preRequestValidation()
        if !validation.succsess {
            complition(.AppError, validation.errors)
            return
        }
        let request = APIModule.buildURLRequest(.SentResetPasswordToken, "POST", auth: false, body: validation.result!)
        APIModule.executeRequest(urlRequest: request) { (responseType, data) in
            switch responseType {
            case .ConflictInfo:
                let errorString = String(data: data!, encoding: .utf8) ?? ""
                complition(.ConflictInfo, [errorString])
            default:
                complition(responseType, nil)
            }
        }
    }
    
    static func SendEmailConfirmationToken(email: String, complition: @escaping (ResponseType, [String]?)->()) {
        
        let validation = AccountSentResetPasswordToken(email: email).preRequestValidation()
        if !validation.succsess {
            complition(.AppError, validation.errors)
            return
        }
        let request = APIModule.buildURLRequest(.SendEmailConfirmationToken, "POST", auth: false, body: validation.result!)
        APIModule.executeRequest(urlRequest: request) { (responseType, data) in
            switch responseType {
            case .ConflictInfo:
                let errorString = String(data: data!, encoding: .utf8) ?? ""
                complition(.ConflictInfo, [errorString])
            default:
                complition(responseType, nil)
            }
        }
    }
    
    static func RefreshToken(complition: @escaping (Bool)->()) {
        
        guard let authInfo = UDefaults.authenInfo else {
            complition(false)
            return
        }
        let validation = AccountRefreshToken(email: authInfo.email, refreshToken: authInfo.refreshToken).preRequestValidation()
        if !validation.succsess {
            complition(false)
            return
        }
        let request = APIModule.buildURLRequest(.RefreshToken, "POST", auth: false, body: validation.result!)
        APIModule.executeRequest(urlRequest: request) { (responseType, data) in
            switch responseType {
            case .Ok:
                do {
                    let reAuthentification = try APIModule.decoder.decode(ReAuthentification.self, from: data!)
                    UDefaults.authenInfo = reAuthentification
                    complition(true)
                }
                catch {
                    APIModule.AppError("Parse Error: RefreshToken: \(error)")
                    complition(false)
                }
            default:
                complition(false)
           }
       }
    }
    
    static func TestAuthentification(complition: @escaping (ResponseType)->()) {
        
        let request = APIModule.buildURLRequest(.TestAuthentification, "GET", auth: true)
        APIModule.executeRequest(urlRequest: request) { (responseType, data) in
            complition(responseType)
            return
        }
    }
}
