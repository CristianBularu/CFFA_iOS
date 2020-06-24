//
//  UserResponses.swift
//  CFFA
//
//  Created by Cristian Bularu on 2/17/20.
//  Copyright © 2020 Cristian Bularu. All rights reserved.
//

import Foundation

struct Profile: Codable {
    var id: String
    var fullName: String
    var `extension`: String?
}

struct ProfileWithPosts: Codable {
    var id: String
    var fullName: String
    var `extension`: String?
    var subscriptionsCount: UInt
    var subscribersCount: UInt
    var postsCount: UInt
    var subscribed: Bool
    var posts: [PostOnly]?
}

struct IndexProfileWithPosts: Codable {
    var id: String
    var fullName: String
    var `extension`: String?
    var subscriptionsCount: UInt
    var subscribersCount: UInt
    var postsCount: UInt
    var subscribed: Bool
    var posts: [PostOnly]?
    var userName: String?
    var email: String
    var favoritePosts: [PostOnly]?
    //var subscriptions: [Profile]?
    var sketches: [Sketch]?
}
