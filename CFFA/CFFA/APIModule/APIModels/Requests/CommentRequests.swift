//
//  CommentRequests.swift
//  CFFA
//
//  Created by Cristian Bularu on 2/17/20.
//  Copyright © 2020 Cristian Bularu. All rights reserved.
//

import Foundation

func CommentValidator(bodyText: String? = nil) -> (succsess: Bool, errors: [String]) {
    var errors = [String]()
    if bodyText != nil && bodyText!.count > 500 {
        errors.append("Description can not be longer than 500 characters")
    }
    if errors.count != 0 {
        return (false, errors)
    }
    return (true, [])
}

struct CommentCreate: PreRequestValidator {
    var postId: UInt64
    var parentId: UInt64?
    var bodyText: String
    
    init(postId: UInt64, parentId: UInt64? = nil, bodyText: String) {
        self.postId = postId
        self.parentId = parentId
        self.bodyText = bodyText
    }
    
    func preRequestValidation() -> (succsess: Bool, result: Data?, errors: [String]) {
        return ParseResult(codable: self, validator: CommentValidator(bodyText: bodyText))
    }
}

struct CommentUpdate: PreRequestValidator {
    var commentId: UInt64
    var bodyText: String
    
    init(commentId: UInt64, bodyText: String) {
        self.commentId = commentId
        self.bodyText = bodyText
    }
    
    func preRequestValidation() -> (succsess: Bool, result: Data?, errors: [String]) {
        return ParseResult(codable: self, validator: CommentValidator(bodyText: bodyText))
    }
}

