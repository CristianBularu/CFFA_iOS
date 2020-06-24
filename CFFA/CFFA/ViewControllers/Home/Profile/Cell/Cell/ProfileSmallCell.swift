//
//  ProfileSmallCell.swift
//  CFFA
//
//  Created by Cristian Bularu on 3/14/20.
//  Copyright © 2020 Cristian Bularu. All rights reserved.
//

import UIKit

class ProfileSmallCell: UICollectionViewCell {
    static let identifier = "ProfileSmallCell"

    @IBOutlet weak var displayedImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    private var postSketchRef: PostSketchRef!
    
    func setUp(_ _postSketchRef: PostSketchRef) {
        self.postSketchRef = _postSketchRef
        let isPost = postSketchRef.post != nil
        let isSketch = postSketchRef.sketch != nil
        self.displayedImageView.image = nil
        if isPost {
            let nameIn = "\(self.postSketchRef.post!.id)"
            PhotoManager.getImage(photoType: .PostPhoto, photoName: nameIn, photoSize: .Medium, extension: self.postSketchRef.post!.extension ?? ".jpg") { (image, nameOut, response, errors) in
                DispatchQueue.main.async {
                    if isPost && nameIn == nameOut && image != nil {
                        self.displayedImageView.image = image
                    }
                }
            }
        } else if isSketch {
            let nameIn = "\(self.postSketchRef.sketch!.id)"
            PhotoManager.getImage(photoType: .Sketch, photoName: nameIn, photoSize: .Medium, extension: self.postSketchRef.sketch!.extension) { (image, nameOut, response, errors) in
                DispatchQueue.main.async {
                    if isSketch && nameIn == nameOut && image != nil {
                        self.displayedImageView.image = image
                    }
                }
            }
        }
    }

}
