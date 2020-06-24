//
//  TrySketch.swift
//  CFFA
//
//  Created by Cristian Bularu on 5/30/20.
//  Copyright © 2020 Cristian Bularu. All rights reserved.
//

import Foundation

struct TrySketch {
    
    
    var sketchId: UInt64
    var leafs: UInt
    var height: Float
    
//    func emptyValidator() -> (succsess: Bool, errors: [String]) {
//        return (true, [])
//    }
//    
//    func TrySketchValidator(leafs: UInt, height: Float) -> (succsess: Bool, errors: [String]) {
//        var errors = [String]()
//        if leafs < 13 {
//            errors.append("Please select a resonable amount of leafs / papers your book has")
//        }
//        if height < 0 {
//            errors.append("Please select a resonable height a single page of your book has")
//        }
//        if errors.count != 0 {
//            return (false, errors)
//        }
//        return (true, [])
//    }
//
//    func preRequestValidation() -> (succsess: Bool, result: Data?, errors: [String]) {
//        return ParseResult(codable: self, validator: TrySketchValidator(leafs: leafs, height: height))
//    }
}
