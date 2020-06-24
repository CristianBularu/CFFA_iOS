//
//  StickersCollectionViewCell.swift
//  CFFA
//
//  Created by Cristian Bularu on 6/8/20.
//  Copyright © 2020 Cristian Bularu. All rights reserved.
//

import UIKit

class StickersCollectionViewCell: UICollectionViewCell {
    static let identifier = "StickersCollectionViewCell"

    @IBOutlet weak var imageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setUp(image: UIImage) {
        imageView.image = image
    }
}
