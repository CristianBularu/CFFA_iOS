//
//  TopHeaderTableViewCell.swift
//  CFFA
//
//  Created by Cristian Bularu on 2/27/20.
//  Copyright © 2020 Cristian Bularu. All rights reserved.
//

import UIKit

class TopHeaderTableViewCell: UITableViewCell {
    static let identifier = "TopHeaderTableViewCell"

    @IBOutlet weak var profileButton: CustomButton!
    
    private var profileHandler: (()->())?
    private var searchHandler: (()->())?
    private var notifHandler: (()->())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setUp(path: String?, profileHandler: @escaping(()->()),
               searchHandler: @escaping(()->()),
               notifHandler: @escaping(()->())) {
        self.profileHandler = profileHandler
        self.searchHandler = searchHandler
        self.notifHandler = notifHandler
        
        if let userInfo = UDefaults.authenInfo {
            let nameIn = userInfo.id
            PhotoManager.getImage(photoType: .ProfileIcon, photoName: nameIn, photoSize: .Small, extension: userInfo.extension ?? ".jpg") { (image, nameOut, response, error) in
                DispatchQueue.main.async {
                    if nameIn == nameOut {
                        self.profileButton.setImage(image ?? #imageLiteral(resourceName: "illustrationAddPhoto"), for: .normal)
                    }
                }
            }
        }
    }
    
    @IBAction func openProfile() {
        profileHandler?()
    }
    
    @IBAction func openSearch() {
        searchHandler?()
    }
    
    @IBAction func openNotif() {
        notifHandler?()
    }
}
