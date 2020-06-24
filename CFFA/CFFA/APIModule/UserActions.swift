//
//  UserActions.swift
//  CFFA
//
//  Created by Cristian Bularu on 2/18/20.
//  Copyright © 2020 Cristian Bularu. All rights reserved.
//

import Foundation

class UserActions {
    
    static func Guest(userId: String, postPage: UInt = 1, complition: @escaping (ResponseType, ProfileWithPosts?)->()) {
        
        let queryItems = [
            URLQueryItem(name: "userId", value: "\(userId)"),
            URLQueryItem(name: "postPage", value: "\(postPage)")
        ]
        let request = APIModule.buildURLRequest(.Guest, "GET", auth: true, queryItems: queryItems)
        APIModule.executeRequest(urlRequest: request) { (responseType, data) in
            switch responseType {
            case .Ok:
                do {
                    let profileWithPosts = try APIModule.decoder.decode(ProfileWithPosts.self, from: data!)
                    complition(.Ok, profileWithPosts)
                }
                catch {
                    APIModule.AppError("Parse Error: Guest: \(error)")
                    complition(.AppError, nil)
                }
            case .Unauthorize:
                APIModule.RefreshTokenWithRecursion(recursion: {
                    Guest(userId: userId, postPage: postPage, complition: complition)
                }) { (responseType) in
                    complition(responseType, nil)
                }
            default:
                complition(responseType, nil)
            }
        }
    }
    
    static func Profile(pageOwnPosts: UInt = 1, pageFavoritePosts: UInt = 1, pageSubscriptions: UInt = 1, pageSketches: UInt = 1, complition: @escaping (ResponseType, IndexProfileWithPosts?)->()) {
        
        let queryItems = [
            URLQueryItem(name: "pageOwnPosts", value: "\(pageOwnPosts)"),
            URLQueryItem(name: "pageFavoritePosts", value: "\(pageFavoritePosts)"),
            URLQueryItem(name: "pageSubscriptions", value: "\(pageSubscriptions)"),
            URLQueryItem(name: "pageSketches", value: "\(pageSketches)")
        ]
        let request = APIModule.buildURLRequest(.Profile, "GET", auth: true, queryItems: queryItems)
        APIModule.executeRequest(urlRequest: request) { (responseType, data) in
            switch responseType {
            case .Ok:
                do {
                    let indexProfileWithPosts = try APIModule.decoder.decode(IndexProfileWithPosts.self, from: data!)
                    complition(.Ok, indexProfileWithPosts)
                }
                catch {
                    APIModule.AppError("Parse Error: Profile: \(error)")
                    complition(.AppError, nil)
                }
            case .Unauthorize:
                APIModule.RefreshTokenWithRecursion(recursion: {
                    Profile(pageOwnPosts: pageOwnPosts, pageFavoritePosts: pageFavoritePosts, pageSubscriptions: pageSubscriptions, pageSketches: pageSketches, complition: complition)
                }) { (responseType) in
                    complition(responseType, nil)
                }
            default:
                complition(responseType, nil)
            }
        }
    }
    
    static func Subscribe(userId: String, complition: @escaping (ResponseType)->()) {
        
        let queryItems = [
            URLQueryItem(name: "userId", value: "\(userId)"),
        ]
        let request = APIModule.buildURLRequest(.Subscribe, "GET", auth: true, queryItems: queryItems)
        APIModule.executeRequest(urlRequest: request) { (responseType, data) in
            switch responseType {
            case .Unauthorize:
                APIModule.RefreshTokenWithRecursion(recursion: {
                    Subscribe(userId: userId, complition: complition)
                }) { (responseType) in
                    complition(responseType)
                }
            default:
                complition(responseType)
            }
        }
    }
    
    static func UnSubscribe(userId: String, complition: @escaping (ResponseType)->()) {
        
        let queryItems = [
            URLQueryItem(name: "userId", value: "\(userId)"),
        ]
        let request = APIModule.buildURLRequest(.UnSubscribe, "GET", auth: true, queryItems: queryItems)
        APIModule.executeRequest(urlRequest: request) { (responseType, data) in
            switch responseType {
            case .Unauthorize:
                APIModule.RefreshTokenWithRecursion(recursion: {
                    UnSubscribe(userId: userId, complition: complition)
                }) { (responseType) in
                    complition(responseType)
                }
            default:
                complition(responseType)
            }
        }
    }
    
    static func ChangeName(fullName: String, complition: @escaping (ResponseType, [String]?)->()) {
        
        let validation = UserChangeName(fullName: fullName).preRequestValidation()
        if !validation.succsess {
            complition(.AppError, validation.errors)
            return
        }
        let request = APIModule.buildURLRequest(.ChangeName, "POST", auth: true, body: validation.result!)
        APIModule.executeRequest(urlRequest: request) { (responseType, data) in
            switch responseType {
            case .ConflictInfo:
                let errorString = String(data: data!, encoding: .utf8) ?? ""
                complition(.ConflictInfo, [errorString])
            case .Unauthorize:
                APIModule.RefreshTokenWithRecursion(recursion: {
                    ChangeName(fullName: fullName, complition: complition)
                }) { (responseType) in
                    complition(responseType, nil)
                }
            default:
                complition(responseType, nil)
            }
        }
    }
    
    static func ChangePassword(oldPassword: String, newPassword: String, complition: @escaping (ResponseType, [String]?)->()) {
        
        let validation = UserChangePassword(oldPassword: oldPassword, newPassword: newPassword).preRequestValidation()
        if !validation.succsess {
            complition(.AppError, validation.errors)
            return
        }
        let request = APIModule.buildURLRequest(.ChangePassword, "POST", auth: true, body: validation.result!)
        APIModule.executeRequest(urlRequest: request) { (responseType, data) in
            switch responseType {
            case .ConflictInfo:
                let errorString = String(data: data!, encoding: .utf8) ?? ""
                complition(.ConflictInfo, [errorString])
            case .Unauthorize:
                APIModule.RefreshTokenWithRecursion(recursion: {
                    ChangePassword(oldPassword: oldPassword, newPassword: newPassword, complition: complition)
                }) { (responseType) in
                    complition(responseType, nil)
                }
            default:
                complition(responseType, nil)
            }
        }
    }
    
    static func UserDisable(complition: @escaping (ResponseType)->()) {
        let request = APIModule.buildURLRequest(.UserDisable, "GET", auth: true)
        APIModule.executeRequest(urlRequest: request) { (responseType, data) in
            complition(responseType)
        }
    }
    
    static func changeIcon(imgData: Data, complition: @escaping (ResponseType)->()) {
        let request = APIModule.buildMPFDURLRequest(.ChangeIcon, params: nil, imgData: imgData)
        APIModule.executeRequest(urlRequest: request) { (responseType, data) in
            print(responseType)
            complition(responseType)
        }
    }
}
