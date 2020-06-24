//
//  PostResponses.swift
//  CFFA
//
//  Created by Cristian Bularu on 2/17/20.
//  Copyright © 2020 Cristian Bularu. All rights reserved.
//

import Foundation


struct PostOnly: Codable {
    var id: UInt64
    var title: String
    var `extension`: String?
}

struct PostAuthor: Codable {
    var id: UInt64
    var title: String
    var `extension`: String?
    var user: Profile
}

struct PostFull: Codable {
    var id: UInt64
    var title: String
    var `extension`: String?
    var user: Profile
    var bodyText: String?
    var creationTime: Date
    var viewerId: String?
    var sketch: Sketch
    var underPost: UnderPost
}

struct PostFullWithComments: Codable {
    var id: UInt64
    var title: String
    var `extension`: String?
    var user: Profile
    var bodyText: String?
    var creationTime: Date
    var viewerId: String?
    var sketch: Sketch
    var underPost: UnderPost
    var comments: [Comment]?
}

struct UnderPost: Codable {
    var upVotes: UInt
    var downVotes: UInt
    var comments: UInt
    var favorite: Bool?
    var viewerVote: Bool?
    var id: UInt64
}

class PostFullRef {
    var post: PostFull
    init(_ post: PostFull) {
        self.post = post
    }
}

class PostFullWithCommentsRef {
    var post: PostFullWithComments
    init(_ post: PostFullWithComments) {
        self.post = post
    }
}

class PostSketchRef {
    var post: PostOnly?
    var sketch: Sketch?
    init(_ post: PostOnly? = nil, _ sketch: Sketch? = nil) {
        self.post = post
        self.sketch = sketch
    }
}
