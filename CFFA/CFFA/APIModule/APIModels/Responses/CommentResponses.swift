//
//  CommentResponses.swift
//  CFFA
//
//  Created by Cristian Bularu on 2/17/20.
//  Copyright © 2020 Cristian Bularu. All rights reserved.
//

import Foundation

struct Comment: Codable {
    var parentId: UInt64?
    var commentId: UInt64
    var upVotes: UInt
    var downVotes: UInt
    var bodyText: String
    var creationTime: Date
    var user: Profile
    var replies: [Comment]?
    var viewerId: String?
    var viewerVoted: Bool?
}

class CommentRef {
    var comment: Comment
    init(_ comment: Comment) {
        self.comment = comment
    }
}

