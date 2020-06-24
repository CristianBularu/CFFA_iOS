//
//  PhotoManager.swift
//  CFFA
//
//  Created by Cristian Bularu on 3/2/20.
//  Copyright © 2020 Cristian Bularu. All rights reserved.
//

import Foundation
import UIKit


enum PhotoType: String {
    case ProfileIcon = "User"
    case PostPhoto = "Post"
    case Sketch = "Sketch"
}

enum PhotoSize: String {
    case Small = "s"
    case Medium = "m"
    case Original = "o"
}

class PhotoManager {
    
    static func getImage(photoType type: PhotoType, photoName name: String, photoSize size: PhotoSize, extension ext: String, completion: @escaping (UIImage?, String, URLResponse?, Error?) -> ()) {
        let path = "/\(type.rawValue)/\(name)/\(size.rawValue)\(ext)"
        if let cacheImage = getFromCache(realPath: path) {
            completion(cacheImage, name, nil, nil)
        } else {
            var urlComponents = URLComponents()
            urlComponents.scheme = APIModule.scheme
            urlComponents.host = APIModule.addressHome
            urlComponents.path = path
            urlComponents.port = APIModule.port
            let url = urlComponents.url
            if let url = url {
                getData(from: url) { (data, response, error) in
                    if data != nil {
                        if let image = UIImage(data: data!) {
                            saveToCache(realPath: path, image: image)
                            completion(image, name, nil, nil)
                            return
                        }
                    }
                    completion(nil, name, response, error)
                }
            }
        }
    }
    
    private static func saveToCache(realPath: String, image: UIImage) {
        let uniqId = UUID().uuidString
        let fileURL = try! FileManager.default
        .url(for: .cachesDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            .appendingPathComponent(uniqId)
        do {
            guard let data = image.jpegData(compressionQuality: 1) else {return}
            try data.write(to: fileURL)
            var dict = UDefaults.imageCache
            dict[realPath] = uniqId
            UDefaults.imageCache = dict
        } catch {
            print(error)
        }
    }
    
    private static func getFromCache(realPath: String) -> UIImage? {
        var dict = UDefaults.imageCache
        if let uniqId = dict[realPath] {
            let fileURL = try! FileManager.default
            .url(for: .cachesDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            .appendingPathComponent(uniqId)
            let image = UIImage(contentsOfFile: fileURL.path)
            if image == nil {
                dict.removeValue(forKey: realPath)
                UDefaults.imageCache = dict
            }
            return image
        }
        
        return nil
    }
    
    private static func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
}
