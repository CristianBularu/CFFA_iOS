//
//  APIModule.swift
//  CFFA
//
//  Created by Cristian Bularu on 2/16/20.
//  Copyright © 2020 Cristian Bularu. All rights reserved.
//

import Foundation
import UIKit

//add here
//add in Actions
enum APICalls: String {
    case SignIn = "/Account/LogIn"                                  //ReAuthentification
    case SignUp = "/Account/SignUp"                                 //Ok
    case ConfirmEmail = "/Account/ConfirmEmail"                      //ReAuthentification
    case ResetPassword = "/Account/ResetPassword"                   //ReAuthentification
    case SentResetPasswordToken = "/Account/SentResetPasswordToken" //Ok
    case RefreshToken = "/Account/RefreshToken"                     //ReAuthentification
    case SendEmailConfirmationToken = "/Account/SendEmailConfirmationToken"//Ok
    case TestAuthentification = "/Account/TestAuthentification"     //Ok
    
    
    case CommentGet = "/Comment/Get"                                //[Comment]
    case CommentCreate = "/Comment/Create"                          //Ok
    case CommentUpdate = "/Comment/Update"                          //Ok
    case CommentUpVote = "/Comment/UpVote"                          //Ok
    case CommentDownVote = "/Comment/DownVote"                      //Ok
    case CommentDisable = "/Comment/Disable"                        //Ok
    
    case Threads = "/Home/Threads"                                  //HomeThreads
    case Popular = "/Home/Popular"                                  //[PostOnly]
    case Fresh = "/Home/Fresh"                                      //[PostOnly]
    case Feed = "/Home/Feed"                                        //[PostOnly]
    case SearchPosts = "/Home/SearchPosts"                          //[PostOnly]
    case SearchUsers = "/Home/SearchUsers"                          //[Profile]
    
    case PostGet = "/Post/Get"                                      //PostFullWithComments
    case PostCreate = "/Post/Create"                                //Ok
    case PostUpdate = "/Post/Update"                                //Ok
    case PostUpVote = "/Post/UpVote"                                //Ok
    case PostDownVote = "/Post/DownVote"                            //Ok
    case PostFavorite = "/Post/Favorite"                            //Ok
    case PostUnFavorite = "/Post/UnFavorite"                        //Ok
    case PostDisable = "/Post/Disable"                              //Ok
    case PostCreateSketch = "/Post/CreateSketch"                    //Sketch
    case PostTrySketch = "/Post/TrySketch"
    
    case Guest = "/User/Guest"                                      //ProfileWithPosts
    case Profile = "/User/Profile"                                  //IndexProfileWithPosts
    case Subscribe = "/User/Subscribe"                              //Ok
    case UnSubscribe = "/User/UnSubscribe"                          //Ok
    case ChangeName = "/User/ChangeName"                            //Ok
    case ChangePassword = "/User/ChangePassword"                    //Ok
    case UserDisable = "/User/Disable"                              //Ok
    case ChangeIcon = "/User/ChangeIcon"                            //Ok
}

enum ResponseType {
    case Ok
    case Unauthorize
    case ConflictInfo
    case ConflictUnknown
    case AppError
    case UnConfirmed
}

extension Dictionary {
    func percentEncoded() -> Data? {
        return map { key, value in
            let escapedKey = "\(key)".addingPercentEncoding(withAllowedCharacters: .urlQueryValueAllowed) ?? ""
            let escapedValue = "\(value)".addingPercentEncoding(withAllowedCharacters: .urlQueryValueAllowed) ?? ""
            return escapedKey + "=" + escapedValue
        }
        .joined(separator: "&")
        .data(using: .utf8)
    }
}

extension CharacterSet {
    static let urlQueryValueAllowed: CharacterSet = {
        let generalDelimitersToEncode = ":#[]@" // does not include "?" or "/" due to RFC 3986 - Section 3.4
        let subDelimitersToEncode = "!$&'()*+,;="

        var allowed = CharacterSet.urlQueryAllowed
        allowed.remove(charactersIn: "\(generalDelimitersToEncode)\(subDelimitersToEncode)")
        return allowed
    }()
}

class RecursionCounters {
    var counter = 0
    let maxRecursions = 1
}

class APIModule {
    static let scheme = "http"
//    static let addressHome = "109.185.158.90"
//    static let addressHome = "192.168.0.100"
    static let addressHome = "91.242.87.76"
    static let port = 82
    private static var recursionCounter = RecursionCounters()
    
    public static var decoder: JSONDecoder {
        let decoder = JSONDecoder()
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy'-'MM'-'dd HH':'mm':'ss'Z'"
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        decoder.dateDecodingStrategy = .formatted(dateFormatter)
        return decoder
    }
    
    public static var encoder: JSONEncoder {
        let encoder = JSONEncoder()
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy'-'MM'-'dd HH':'mm':'ss'Z'"
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        encoder.dateEncodingStrategy = .formatted(dateFormatter)
        return encoder
    }
    
    static func AppError(_ errorMSG: String) {
        print("!APP ERROR: \(errorMSG)")
    }
    
    static func buildURLRequest(_ apiCall: APICalls, _ method: String, auth: Bool, queryItems: [URLQueryItem]? = nil, body: Data? = nil) -> URLRequest {
       
        var urlComponents = URLComponents()
        urlComponents.scheme = scheme
        urlComponents.host = addressHome
        urlComponents.path = apiCall.rawValue
        urlComponents.queryItems = queryItems
        urlComponents.port = port
        let url = urlComponents.url!
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = method
        request.httpBody = body
        if auth {
            if let accessToken = UDefaults.authenInfo?.accessToken {
                request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
            }
        }
        //request.timeoutInterval = 10
        return request
    }
    
    static func buildMPFDURLRequest(_ apiCall: APICalls, params: [String:String]?, imgData: Data) -> URLRequest {
        
        let boundary = "\(UUID().uuidString)"
        let mimeType = "image/jpeg"
        let filename = "o.jpg"
        let br = "\r\n"
        var body = Data()
        
        var urlComponents = URLComponents()
        urlComponents.scheme = scheme
        urlComponents.host = addressHome
        urlComponents.port = port
        urlComponents.path = apiCall.rawValue
        let url = urlComponents.url!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        if let accessToken = UDefaults.authenInfo?.accessToken {
            request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        }
        
        for (key, value) in params ?? [String:String]() {
            body.append("--\(boundary + br)")
            body.append("Content-Disposition: form-data; name=\"\(key)\"\(br + br)")
            body.append("\(value + br)")
        }
        
        body.append("--\(boundary + br)")
        body.append("Content-Disposition: form-data; name=\"File\"; filename=\"\(filename)\"\(br)")
        body.append("Content-Type: \(mimeType + br + br)")
        body.append(imgData)
        body.append(br)
        
        body.append("--\(boundary)--\(br)")
        request.httpBody = body
        return request
    }
    
    static func executeRequest(urlRequest: URLRequest, complition: @escaping (ResponseType, Data?)->() ) {
        
        let task = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            guard let data = data,
                let response = response as? HTTPURLResponse,
                error == nil else {                                              // check for fundamental networking error
                print("error", error ?? "Unknown error")
                    complition(.AppError, nil)
                return
            }
            print(response)
            print(String(data: data, encoding: .utf8)!)
            if response.statusCode == 200 || response.statusCode == 201 {
                complition(.Ok, data)
            } else if response.statusCode == 401 {
                complition(.Unauthorize, data)
                return
            } else if response.statusCode == 403 {
                return complition(.UnConfirmed, data)
            } else if response.statusCode == 409 {
                complition(.ConflictInfo, data)
                return
            } else if response.statusCode == 400 {
                complition(.ConflictInfo, data)
            } else {
                complition(.ConflictUnknown, data)
                return
            }
        }
        task.resume()
    }
    
    static func RefreshTokenWithRecursion(recursion: @escaping ()->(), finalFail: @escaping (ResponseType)->()){
        if UDefaults.authenInfo?.accessToken.isEmpty ?? true {
            finalFail(.Unauthorize)
            return
        }
        AccountActions.RefreshToken { (ok) in
            if !ok {
                finalFail(.Unauthorize)
                return
            }
            if recursionCounter.counter < recursionCounter.maxRecursions {
                recursionCounter.counter += 1
                recursion()
            } else {
                recursionCounter.counter = 0
                finalFail(.ConflictUnknown)
                APIModule.AppError("Second Recursion fail authentification")
            }
        }
    }
}



extension Data {
    mutating func append(_ string: String) {
        if let data = string.data(using: .utf8) {
            append(data)
        }
    }
}
