//
//  PostTableViewCell.swift
//  CFFA
//
//  Created by Cristian Bularu on 3/3/20.
//  Copyright © 2020 Cristian Bularu. All rights reserved.
//

import UIKit

class PostTableViewCell: UITableViewCell {
    static let identifier = "PostTableViewCell"
    
    @IBOutlet weak var postImageView: UIImageView!
    
    func setUp(post: PostFullWithCommentsRef) {
        let nameIn = "\(post.post.id)"
        PhotoManager.getImage(photoType: .PostPhoto, photoName: nameIn, photoSize: .Original, extension: post.post.extension ?? ".jpg") { (image, nameOut, response, error) in
            DispatchQueue.main.async {
                if image != nil && nameIn == nameOut {
                    self.postImageView.image = image
                }
            }
        }
    }
}
