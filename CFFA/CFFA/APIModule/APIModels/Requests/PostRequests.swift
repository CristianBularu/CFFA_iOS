//
//  PostRequests.swift
//  CFFA
//
//  Created by Cristian Bularu on 2/17/20.
//  Copyright © 2020 Cristian Bularu. All rights reserved.
//

import Foundation

func PostValidator(title: String? = nil, bodyText: String? = nil) -> (succsess: Bool, errors: [String]) {
    var errors = [String]()
    if title != nil && (title!.count < 4 || title!.count > 55) {
        errors.append("Full Name length must range between 4 and 55 characters")
    }
    if bodyText != nil && bodyText!.count > 500 {
        errors.append("Description can not be longer than 500 characters")
    }
    if errors.count != 0 {
        return (false, errors)
    }
    return (true, [])
}



struct PostCreate: PreRequestValidator {
    var title: String
    var bodyText: String
    var file: Data?
    
    init(title: String, bodyText: String, file: Data?) {
        self.title = title
        self.bodyText = bodyText
        self.file = file
    }
    
    func preRequestValidation() -> (succsess: Bool, result: Data?, errors: [String]) {
        
        return ParseResult(codable: self, validator: PostValidator(title: title, bodyText: bodyText))
    }
}

struct PostUpdate: Codable, PreRequestValidator {
    var Id: UInt64
    var Title: String
    var BodyText: String
    var File: Data?
    
    init(Id: UInt64, title: String, bodyText: String, file: Data?) {
        self.Id = Id
        self.Title = title
        self.BodyText = bodyText
        self.File = file
    }
    
    func preRequestValidation() -> (succsess: Bool, result: Data?, errors: [String]) {
        return ParseResult(codable: self, validator: PostValidator(title: Title, bodyText: BodyText))
    }
}


