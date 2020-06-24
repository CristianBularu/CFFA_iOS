//
//  UpRiseMenuView.swift
//  CFFA
//
//  Created by Cristian Bularu on 3/2/20.
//  Copyright © 2020 Cristian Bularu. All rights reserved.
//

import UIKit

class UpRiseMenuView: OwnableView {
    static let identifier = "UpRiseMenuView"

    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var button1: CustomButton!
    @IBOutlet weak var button2: CustomButton!
    
    private var complition1: (()->())?
    private var complition2: (()->())?
    
    static func instantiateWith(infoText: String, button1Text: String, button2Text: String, button1Handler: @escaping(()->()), button2Handler: @escaping(()->())) -> UpRiseMenuView {
        let upRiseMenuView = (UINib(nibName: UpRiseMenuView.identifier, bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! UpRiseMenuView)
        upRiseMenuView.complition1 = button1Handler
        upRiseMenuView.complition2 = button2Handler
        upRiseMenuView.infoLabel.text = infoText
        upRiseMenuView.button1.setTitle(button1Text, for: .normal)
        upRiseMenuView.button2.setTitle(button2Text, for: .normal)
        return upRiseMenuView
    }
    
    @IBAction func button1Action() {
        owner.dismiss {
            self.complition1?()
        }
    }
    
    @IBAction func button2Action() {
        owner.dismiss {
            self.complition2?()
        }
    }
    @IBAction private func cancel() {
        owner.dismiss {}
    }
}
