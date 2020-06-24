//
//  HomeCollectionViewCell.swift
//  CFFA
//
//  Created by Cristian Bularu on 2/26/20.
//  Copyright © 2020 Cristian Bularu. All rights reserved.
//

import UIKit

class HomeCollectionViewCell: UICollectionViewCell {
    static let identifier = "HomeCollectionViewCell"

    @IBOutlet weak var customView: CustomView!
    @IBOutlet weak private var image: CustomImageView!
    @IBOutlet weak private var label: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setUp(post: PostOnly, width: Double) {
        //TODO: Fetch image, cache | post.bmpPath
        self.image.image = #imageLiteral(resourceName: "illustrationAddPhotoPost")
        self.label.text = post.title
        image.cornerRadius = width * 0.1
        let nameIn = "\(post.id)"
        PhotoManager.getImage(photoType: .PostPhoto, photoName: nameIn, photoSize: .Original, extension: post.extension ?? ".jpg") { (image, nameOut, response, error) in
            DispatchQueue.main.async {
                if image != nil && nameIn == nameOut {
                    self.image.image = image
                }
            }
        }
        
    }
}
