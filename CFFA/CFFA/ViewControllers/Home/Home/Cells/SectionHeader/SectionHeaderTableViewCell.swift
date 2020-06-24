//
//  SectionHeaderTableViewCell.swift
//  CFFA
//
//  Created by Cristian Bularu on 2/27/20.
//  Copyright © 2020 Cristian Bularu. All rights reserved.
//

import UIKit

class SectionHeaderTableViewCell: UITableViewCell {
    static var identifier = "SectionHeaderTableViewCell"

    @IBOutlet weak private var titleLabel: UILabel!
    private var viewAllHandler: (()->())?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setUp(title: String, viewAllHandler: @escaping(()->())) {
        self.titleLabel.text = title
        self.viewAllHandler = viewAllHandler
    }
    
    @IBAction func viewAll() {
        viewAllHandler?()
    }
}
