//
//  FontsCollectionViewCell.swift
//  CFFA
//
//  Created by Cristian Bularu on 6/8/20.
//  Copyright © 2020 Cristian Bularu. All rights reserved.
//

import UIKit

class FontsCollectionViewCell: UICollectionViewCell {
    static let identifier = "FontsCollectionViewCell"
    @IBOutlet weak var fontLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setUp(fontName: String) {
        fontLabel.font = UIFont.init(name: fontName, size: 18)
        fontLabel.text = String(fontName.prefix(5))
    }

}
