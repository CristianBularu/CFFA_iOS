//
//  AdjustAlghorithmCell.swift
//  CFFA
//
//  Created by Cristian Bularu on 3/15/20.
//  Copyright © 2020 Cristian Bularu. All rights reserved.
//

import UIKit

class AdjustAlghorithmCell: UICollectionViewCell {
    static let identifier = "AdjustAlghorithmCell"

    @IBOutlet weak private var imageView: CustomImageView!
    @IBOutlet weak private var titleLabel: UILabel!
    
    func setUp(_ tuple: (String,UIImage)) {
        self.titleLabel.text = tuple.0
        self.imageView.image = tuple.1
    }
}
