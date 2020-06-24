//
//  UDefaults.swift
//  CFFA
//
//  Created by Cristian Bularu on 2/16/20.
//  Copyright © 2020 Cristian Bularu. All rights reserved.
//
import UIKit
import Foundation

//struct MyWebInfo: Codable {
//    var Id: String
//    var name: String
//    var email: String
//    var accesssToken: String
//    var refreshToken: String
//}

class UDefaults {
    
    static var imageCache: [String:String] {
        get {
            return UserDefaults.standard.object(forKey: "ImageCache") as? [String:String] ?? [String:String]()
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "ImageCache")
        }
    }
    
    static var connectionFailDisplayed: Bool {
        get
        {
            return UserDefaults.standard.bool(forKey: "connectionFailDisplayed")
        }
        set
        {
            UserDefaults.standard.set(newValue, forKey: "connectionFailDisplayed")
        }
    }
    
    static var finishedBoarding: Bool {
        get
        {
            return UserDefaults.standard.bool(forKey: "finishedBoarding")
        }
        set
        {
            UserDefaults.standard.set(newValue, forKey: "finishedBoarding")
        }
    }
    
    static var firstLaunch: Bool {
        get
        {
            return !UserDefaults.standard.bool(forKey: "firstLaunch")
        }
        set
        {
            UserDefaults.standard.set(!newValue, forKey: "firstLaunch")
        }
    }
    
    static var globalTint: Int {
        get
        {
            return UserDefaults.standard.integer(forKey: "globalTint")
        }
        set
        {
            UserDefaults.standard.set(newValue, forKey: "globalTint")
        }
    }
    
    static var authenInfo: ReAuthentification? {
        get
        {
            if let savedInfo = UserDefaults.standard.object(forKey: "authenInfo") as? Data {
                if let loadedInfo = try? APIModule.decoder.decode(ReAuthentification.self, from: savedInfo) {
                    return loadedInfo
                }
                APIModule.AppError("Parse Error: get ReAuthentification")
            }
            return nil
        }
        set
        {
            if let encoded = try? APIModule.encoder.encode(newValue) {
                UserDefaults.standard.set(encoded, forKey: "authenInfo")
            } else {
                APIModule.AppError("Parse Error: set ReAuthentification")
            }
        }
    }
}


