//
//  PostActions.swift
//  CFFA
//
//  Created by Cristian Bularu on 2/18/20.
//  Copyright © 2020 Cristian Bularu. All rights reserved.
//

import Foundation

class PostActions {
    
    static func PostGet(postId: UInt64, page: UInt = 1, complition: @escaping (ResponseType, PostFullWithComments?)->()) {
        
        let queryItems = [
            URLQueryItem(name: "postId", value: "\(postId)"),
            URLQueryItem(name: "page", value: "\(page)")
        ]
        let request = APIModule.buildURLRequest(.PostGet, "GET", auth: true, queryItems: queryItems)
        APIModule.executeRequest(urlRequest: request) { (responseType, data) in
            switch responseType {
            case .Ok:
                do {
                    let post = try APIModule.decoder.decode(PostFullWithComments.self, from: data!)
                    complition(.Ok, post)
                }
                catch {
                    APIModule.AppError("Parse Error: PostGet: \(error)")
                    complition(.AppError, nil)
                }
            default:
                complition(responseType, nil)
            }
        }
    }
    
    static func UpVote(postId: UInt64, complition: @escaping (ResponseType)->()) {
        
        let queryItems = [
            URLQueryItem(name: "postId", value: "\(postId)")
        ]
        let request = APIModule.buildURLRequest(.PostUpVote, "GET", auth: true, queryItems: queryItems)
        APIModule.executeRequest(urlRequest: request) { (responseType, data) in
            switch responseType {
            case .Unauthorize:
                APIModule.RefreshTokenWithRecursion(recursion: {
                    UpVote(postId: postId, complition: complition)
                }) { (responseType) in
                    complition(responseType)
                }
            default:
                complition(responseType)
            }
        }
    }
    
    static func DownVote(postId: UInt64, complition: @escaping (ResponseType)->()) {
        
        let queryItems = [
            URLQueryItem(name: "postId", value: "\(postId)")
        ]
        let request = APIModule.buildURLRequest(.PostDownVote, "GET", auth: true, queryItems: queryItems)
        APIModule.executeRequest(urlRequest: request) { (responseType, data) in
            switch responseType {
            case .Unauthorize:
                APIModule.RefreshTokenWithRecursion(recursion: {
                    DownVote(postId: postId, complition: complition)
                }) { (responseType) in
                    complition(responseType)
                }
            default:
                complition(responseType)
            }
        }
    }
    
    static func Favorite(postId: UInt64, complition: @escaping (ResponseType)->()) {
        
        let queryItems = [
            URLQueryItem(name: "postId", value: "\(postId)")
        ]
        let request = APIModule.buildURLRequest(.PostFavorite, "GET", auth: true, queryItems: queryItems)
        APIModule.executeRequest(urlRequest: request) { (responseType, data) in
            switch responseType {
            case .Unauthorize:
                APIModule.RefreshTokenWithRecursion(recursion: {
                    Favorite(postId: postId, complition: complition)
                }) { (responseType) in
                    complition(responseType)
                }
            default:
                complition(responseType)
            }
        }
    }
    
    static func UnFavorite(postId: UInt64, complition: @escaping (ResponseType)->()) {
        
        let queryItems = [
            URLQueryItem(name: "postId", value: "\(postId)")
        ]
        let request = APIModule.buildURLRequest(.PostUnFavorite, "GET", auth: true, queryItems: queryItems)
        APIModule.executeRequest(urlRequest: request) { (responseType, data) in
            switch responseType {
            case .Unauthorize:
                APIModule.RefreshTokenWithRecursion(recursion: {
                    UnFavorite(postId: postId, complition: complition)
                }) { (responseType) in
                    complition(responseType)
                }
            default:
                complition(responseType)
            }
        }
    }
    
    static func Create(sketchId: UInt64, title: String, bodyText: String, imgData: Data, complition: @escaping (ResponseType, [String]?)->()) {
        
        let validation = PostCreate(title: title, bodyText: bodyText, file: imgData).preRequestValidation()
        if !validation.succsess {
            complition(.AppError, validation.errors)
            return
        }
        let params = ["SketchId":"\(sketchId)","Title": "\(title)", "BodyText": "\(bodyText)"]
        let request = APIModule.buildMPFDURLRequest(.PostCreate, params: params, imgData: imgData)
//        let request = APIModule.buildURLRequest(.PostCreate, "POST", auth: true, body: validation.result!)
        APIModule.executeRequest(urlRequest: request) { (responseType, data) in
            switch responseType {
            case .ConflictInfo:
                let errorString = String(data: data!, encoding: .utf8) ?? ""
                complition(.ConflictInfo, [errorString])
            case .Unauthorize:
                APIModule.RefreshTokenWithRecursion(recursion: {
                    Create(sketchId: sketchId, title: title, bodyText: bodyText, imgData: imgData, complition: complition)
                }) { (responseType) in
                    complition(responseType, nil)
                }
            default:
                complition(responseType, nil)
            }
        }
    }
    
    static func Update(sketchId: UInt64, Id: UInt64, title: String, bodyText: String, imgData: Data?, complition: @escaping (ResponseType, [String]?)->()) {
        
        let validation = PostUpdate(Id: Id, title: title, bodyText: bodyText, file: imgData).preRequestValidation()
        if !validation.succsess {
            complition(.AppError, validation.errors)
            return
        }
        
        var request: URLRequest
        if imgData != nil {
            let params = [
            "SketchId":"\(sketchId)",
            "Id":"\(Id)",
            "Title": "\(title)",
            "BodyText": "\(bodyText)"]
            request = APIModule.buildMPFDURLRequest(.PostCreate, params: params, imgData: imgData!)
        } else {
            request = APIModule.buildURLRequest(.PostUpdate, "POST", auth: true, body: validation.result!)
        }
        APIModule.executeRequest(urlRequest: request) { (responseType, data) in
            switch responseType {
            case .ConflictInfo:
                let errorString = String(data: data!, encoding: .utf8) ?? ""
                complition(.ConflictInfo, [errorString])
            case .Unauthorize:
                APIModule.RefreshTokenWithRecursion(recursion: {
                    Update(sketchId: sketchId, Id: Id, title: title, bodyText: bodyText, imgData: imgData, complition: complition)
                }) { (responseType) in
                    complition(responseType, nil)
                }
            default:
                complition(responseType, nil)
            }
        }
    }
    
    static func PostDisable(postId: UInt64, complition: @escaping (ResponseType)->()) {
        
        let queryItems = [
            URLQueryItem(name: "postId", value: "\(postId)")
        ]
        let request = APIModule.buildURLRequest(.PostDisable, "GET", auth: true, queryItems: queryItems)
        APIModule.executeRequest(urlRequest: request) { (responseType, data) in
            switch responseType {
            case .Unauthorize:
                APIModule.RefreshTokenWithRecursion(recursion: {
                    PostDisable(postId: postId, complition: complition)
                }) { (responseType) in
                    complition(responseType)
                }
            default:
                complition(responseType)
            }
        }
    }
    
    static func CreateSketch(imgData: Data, complition: @escaping (ResponseType, Sketch?, [String]?)->()) {
        
        let request = APIModule.buildMPFDURLRequest(.PostCreateSketch, params: nil, imgData: imgData)
        
        APIModule.executeRequest(urlRequest: request) { (responseType, data) in
            switch responseType {
            case .Ok:
                do {
                    let sketch = try APIModule.decoder.decode(Sketch.self, from: data!)
                    complition(.Ok, sketch, nil)
                }
                catch {
                    APIModule.AppError("Parse Error: CreateSketch: \(error)")
                    complition(.AppError, nil, nil)
                }
            case .ConflictInfo:
                let errorString = String(data: data!, encoding: .utf8) ?? ""
                complition(responseType, nil, [errorString])
            case .Unauthorize:
                APIModule.RefreshTokenWithRecursion(recursion: {
                    CreateSketch(imgData: imgData, complition: complition)
                }) { (responseType) in
                    complition(responseType, nil, nil)
                }
            default:
                complition(responseType, nil, nil)
            }
        }
    }
    
    static func TrySketch(sketchId: UInt64, leafs: UInt, height: Float, complition: @escaping (ResponseType, Data?, [String]?)->()) {
        
        let queryItems = [
            URLQueryItem(name: "sketchId", value: "\(sketchId)"),
            URLQueryItem(name: "leafs", value: "\(leafs)"),
            URLQueryItem(name: "height", value: "\(height)")
        ]
        let request = APIModule.buildURLRequest(.PostTrySketch, "GET", auth: true, queryItems: queryItems)
        
        APIModule.executeRequest(urlRequest: request) { (responseType, data) in
            guard data != nil else { return }
            switch responseType {
            case .Ok:
                complition(responseType, data, nil)
//                guard let encoded64 = String(data: data!, encoding: .utf8) else {
//                    APIModule.AppError("TrySketch: Could not parse data to String")
//                    return
//                }
//                PdfManager.encoded64ToPDF(encoded64, complition: { (tempURL) in
//                    complition(responseType, tempURL, nil)
//                })
                
            case .ConflictInfo:
                let errorString = String(data: data!, encoding: .utf8) ?? ""
                complition(responseType, nil, [errorString])
            case .Unauthorize:
                APIModule.RefreshTokenWithRecursion(recursion: {
                    TrySketch(sketchId: sketchId, leafs: leafs, height: height, complition: complition)
                }) { (responseType) in
                    complition(responseType, nil, nil)
                }
            default:
                complition(responseType, nil, nil)
            }
            
        }
        
    }
}
