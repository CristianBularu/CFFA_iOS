//
//  CommentActions.swift
//  CFFA
//
//  Created by Cristian Bularu on 2/18/20.
//  Copyright © 2020 Cristian Bularu. All rights reserved.
//

import Foundation



class CommentActions {
    
    
    
    static func CommentGet(postId: UInt64, page: UInt = 1, complition: @escaping (ResponseType, [Comment]?)->()) {
        
        let queryItems = [
            URLQueryItem(name: "postId", value: "\(postId)"),
            URLQueryItem(name: "page", value: "\(page)")
        ]
        let request = APIModule.buildURLRequest(.CommentGet, "GET", auth: true, queryItems: queryItems)
        APIModule.executeRequest(urlRequest: request) { (responseType, data) in
            switch responseType {
            case .Ok:
                do {
                    let comment = try APIModule.decoder.decode([Comment].self, from: data!)
                    complition(.Ok, comment)
                }
                catch {
                    APIModule.AppError("Parse Error: CommentGet: \(error)")
                    complition(.AppError, nil)
                }
            case .Unauthorize:
                APIModule.RefreshTokenWithRecursion(recursion: {
                    CommentGet(postId: postId, page: page, complition: complition)
                }) { (responseType) in
                    complition(responseType, nil)
                }
            default:
                complition(responseType, nil)
            }
        }
    }
    
    static func UpVote(commentId: UInt64, complition: @escaping (ResponseType)->()) {
        
        let queryItems = [
            URLQueryItem(name: "commentId", value: "\(commentId)")
        ]
        let request = APIModule.buildURLRequest(.CommentUpVote, "GET", auth: true, queryItems: queryItems)
        APIModule.executeRequest(urlRequest: request) { (responseType, data) in
            switch responseType {
            case .Unauthorize:
                APIModule.RefreshTokenWithRecursion(recursion: {
                    UpVote(commentId: commentId, complition: complition)
                }) { (responseType) in
                    complition(responseType)
                }
            default:
                complition(responseType)
            }
        }
    }
    
    static func DownVote(commentId: UInt64, complition: @escaping (ResponseType)->()) {
        
        let queryItems = [
            URLQueryItem(name: "commentId", value: "\(commentId)")
        ]
        let request = APIModule.buildURLRequest(.CommentDownVote, "GET", auth: true, queryItems: queryItems)
        APIModule.executeRequest(urlRequest: request) { (responseType, data) in
            switch responseType {
            case .Unauthorize:
                APIModule.RefreshTokenWithRecursion(recursion: {
                    DownVote(commentId: commentId, complition: complition)
                }) { (responseType) in
                    complition(responseType)
                }
            default:
                complition(responseType)
            }
        }
    }
    
    static func Disable(commentId: UInt64, complition: @escaping (ResponseType)->()) {
        
        let queryItems = [
            URLQueryItem(name: "commentId", value: "\(commentId)")
        ]
        let request = APIModule.buildURLRequest(.CommentDisable, "GET", auth: true, queryItems: queryItems)
        APIModule.executeRequest(urlRequest: request) { (responseType, data) in
            switch responseType {
            case .Unauthorize:
                APIModule.RefreshTokenWithRecursion(recursion: {
                    Disable(commentId: commentId, complition: complition)
                }) { (responseType) in
                    complition(responseType)
                }
            default:
                complition(responseType)
            }
        }
    }
    
    static func Create(postId: UInt64, parentId: UInt64? = nil, bodyText: String, complition: @escaping (ResponseType, [String]?)->()) {
        
        let validation = CommentCreate(postId: postId, parentId: parentId, bodyText: bodyText).preRequestValidation()
        if !validation.succsess {
            complition(.AppError, validation.errors)
            return
        }
        let request = APIModule.buildURLRequest(.CommentCreate, "POST", auth: true, body: validation.result!)
        APIModule.executeRequest(urlRequest: request) { (responseType, data) in
            switch responseType {
            case .ConflictInfo:
                let errorString = String(data: data!, encoding: .utf8) ?? ""
                complition(.ConflictInfo, [errorString])
            case .Unauthorize:
                APIModule.RefreshTokenWithRecursion(recursion: {
                    Create(postId: postId, bodyText: bodyText, complition: complition)
                }) { (responseType) in
                    complition(responseType, nil)
                }
            default:
                complition(responseType, nil)
            }
        }
    }
    
    static func Update(commentId: UInt64, bodyText: String, complition: @escaping (ResponseType, [String]?)->()) {
        
        let validation = CommentUpdate(commentId: commentId, bodyText: bodyText).preRequestValidation()
        if !validation.succsess {
            complition(.AppError, validation.errors)
            return
        }
        let request = APIModule.buildURLRequest(.CommentUpdate, "POST", auth: true, body: validation.result!)
        APIModule.executeRequest(urlRequest: request) { (responseType, data) in
            switch responseType {
            case .ConflictInfo:
                let errorString = String(data: data!, encoding: .utf8) ?? ""
                complition(.ConflictInfo, [errorString])
            case .Unauthorize:
                APIModule.RefreshTokenWithRecursion(recursion: {
                    Update(commentId: commentId, bodyText: bodyText, complition: complition)
                }) { (responseType) in
                    complition(responseType, nil)
                }
            default:
                complition(responseType, nil)
            }
        }
    }
}
