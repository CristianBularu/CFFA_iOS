//
//  HomeActions.swift
//  CFFA
//
//  Created by Cristian Bularu on 2/18/20.
//  Copyright © 2020 Cristian Bularu. All rights reserved.
//

import Foundation

class HomeActions {
    
    static func Threads(complition: @escaping (ResponseType, HomeThreads?)->()) {
        
        let request = APIModule.buildURLRequest(.Threads, "GET", auth: true)
        APIModule.executeRequest(urlRequest: request) { (responseType, data) in
            switch responseType {
                case .Ok:
                do {
                    let threads = try APIModule.decoder.decode(HomeThreads.self, from: data!)
                    complition(.Ok, threads)
                }
                catch {
                    APIModule.AppError("Parse Error: Threads: \(error)")
                    complition(.AppError, nil)
                }
            default:
                complition(responseType, nil)
            }
        }
    }
    
    static func Popular(page: UInt = 1, complition: @escaping (ResponseType, [PostFull]?)->()) {
        
        let queryItems = [
            URLQueryItem(name: "page", value: "\(page)")
        ]
        let request = APIModule.buildURLRequest(.Popular, "GET", auth: true, queryItems: queryItems)
        APIModule.executeRequest(urlRequest: request) { (responseType, data) in
            switch responseType {
            case .Ok:
                do {
                    let posts = try APIModule.decoder.decode([PostFull].self, from: data!)
                    complition(.Ok, posts)
                }
                catch {
                    APIModule.AppError("Parse Error: Popular: \(error)")
                    complition(.AppError, nil)
                }
            default:
                complition(responseType, nil)
            }
        }
    }
    
    static func Fresh(page: UInt = 1, complition: @escaping (ResponseType, [PostFull]?)->()) {
        
        let queryItems = [
            URLQueryItem(name: "page", value: "\(page)")
        ]
        let request = APIModule.buildURLRequest(.Fresh, "GET", auth: true, queryItems: queryItems)
        APIModule.executeRequest(urlRequest: request) { (responseType, data) in
            switch responseType {
                case .Ok:
                    do {
                        let posts = try APIModule.decoder.decode([PostFull].self, from: data!)
                        complition(.Ok, posts)
                    }
                    catch {
                        APIModule.AppError("Parse Error: Fresh: \(error)")
                        complition(.AppError, nil)
                    }
            default:
                complition(responseType, nil)
            }
        }
    }
    
    static func Feed(page: UInt = 1, complition: @escaping (ResponseType, [PostFull]?)->()) {
        
        let queryItems = [
            URLQueryItem(name: "page", value: "\(page)")
        ]
        let request = APIModule.buildURLRequest(.Feed, "GET", auth: true, queryItems: queryItems)
        APIModule.executeRequest(urlRequest: request) { (responseType, data) in
            switch responseType {
            case .Ok:
                do {
                    let posts = try APIModule.decoder.decode([PostFull].self, from: data!)
                    complition(.Ok, posts)
                }
                catch {
                    APIModule.AppError("Parse Error: Feed: \(error)")
                    complition(.AppError, nil)
                }
            case .Unauthorize:
                APIModule.RefreshTokenWithRecursion(recursion: {
                    Feed(page: page, complition: complition)
                }) { (responseType) in
                    complition(responseType, nil)
                }
            default:
                complition(responseType, nil)
            }
        }
    }
    
    static func SearchPosts(like: String, page: UInt = 1, complition: @escaping (ResponseType, [PostOnly]?)->()) {
        let queryItems = [
            URLQueryItem(name: "like", value: "\(like)"),
            URLQueryItem(name: "page", value: "\(page)")
        ]
        let request = APIModule.buildURLRequest(.SearchPosts, "GET", auth: false, queryItems: queryItems)
        APIModule.executeRequest(urlRequest: request) { (responseType, data) in
            switch responseType {
            case .Ok:
                do {
                    let posts = try APIModule.decoder.decode([PostOnly].self, from: data!)
                    complition(.Ok, posts)
                }
                catch {
                    APIModule.AppError("Parse Error: SearchPosts: \(error)")
                    complition(.AppError, nil)
                }
            default:
                complition(responseType, nil)
            }
        }
    }
    
    static func SearchUsers(like: String, page: UInt = 1, complition: @escaping (ResponseType, [Profile]?)->()) {
        let queryItems = [
            URLQueryItem(name: "like", value: "\(like)"),
            URLQueryItem(name: "page", value: "\(page)")
        ]
        let request = APIModule.buildURLRequest(.SearchUsers, "GET", auth: true, queryItems: queryItems)
        APIModule.executeRequest(urlRequest: request) { (responseType, data) in
            switch responseType {
            case .Ok:
                do {
                    let users = try APIModule.decoder.decode([Profile].self, from: data!)
                    complition(.Ok, users)
                }
                catch {
                    APIModule.AppError("Parse Error: SearchUsers: \(error)")
                    complition(.AppError, nil)
                }
            default:
                complition(responseType, nil)
            }
        }
    }
}
