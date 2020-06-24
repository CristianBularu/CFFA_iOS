//
//  InfoView.swift
//  CFFA
//
//  Created by Cristian Bularu on 2/22/20.
//  Copyright © 2020 Cristian Bularu. All rights reserved.
//

import UIKit

class InfoView: OwnableView {
    static let identifier = "InfoView"
    @IBOutlet weak private var image: UIImageView!
    @IBOutlet weak private var generalLabel: UILabel!
    @IBOutlet weak private var detailedLabel: UILabel!
    
    static func instanciateWith(image: UIImage, generalText: String, detailedText: String) -> OwnableView {
        let infoView = (UINib(nibName: identifier, bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! InfoView)
        infoView.image.image = image
        infoView.generalLabel.text = generalText
        infoView.detailedLabel.text = detailedText
        return infoView
    }
}
