//
//  PdfManager.swift
//  CFFA
//
//  Created by Cristian Bularu on 5/30/20.
//  Copyright © 2020 Cristian Bularu. All rights reserved.
//

import Foundation
import UIKit
import PDFKit


class PdfManager {
    
    static let cacheUrl = try! FileManager.default.url(for: .cachesDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
   
    
    static func getPdfData(sketchId: UInt64, leafs: UInt, height: Float, complition: @escaping (Data) -> ()) {
        let fileName = "pdf/\(sketchId)_\(leafs)_\(height).pdf"
        
        if let data64 = getBlindFromCache(fileName: fileName) {
            complition(data64)
        } else {
            getFromServer(sketchId: sketchId, leafs: leafs, height: height) { data in
                if let data64 = Data(base64Encoded: data) {
                    saveToCache(fileName: fileName, data: data64)
                    complition(data64)
                }
            }
        }
    }
    
    private static func getBlindFromCache(fileName: String) -> Data? {
        let fileURL = cacheUrl.appendingPathComponent(fileName)
        return try? Data.init(contentsOf: fileURL)
    }
    
    private static func getFromServer(sketchId: UInt64, leafs: UInt, height: Float, complition: @escaping (Data) -> ()) {
        PostActions.TrySketch(sketchId: sketchId, leafs: leafs, height: height) { (responseType, data, errors) in
            if let data = data {
                complition(data)
            }
        }
    }
    
    private static func saveToCache(fileName: String, data: Data) {
        let fileURL = cacheUrl.appendingPathComponent(fileName)
        try? data.write(to: fileURL)
    }
}
