//
//  OtherLoginView.swift
//  CFFA
//
//  Created by Cristian Bularu on 2/23/20.
//  Copyright © 2020 Cristian Bularu. All rights reserved.
//

import UIKit

class OtherLoginView: UIView {
    static var identifier = "OtherLoginView"
    
    private var googleComplition: (()->())?
    private var facebookComplition: (()->())?
    private var appleComplition: (()->())?
    
    static func instantiateWith(googleComplition: @escaping ()->(),
                                facebookComplition: @escaping ()->(),
                                appleComplition: @escaping ()->()) -> OtherLoginView {
        let otherLoginView = (UINib(nibName: OtherLoginView.identifier, bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! OtherLoginView)
        otherLoginView.googleComplition = googleComplition
        otherLoginView.facebookComplition = facebookComplition
        otherLoginView.appleComplition = appleComplition
        return otherLoginView
    }
    
//    func setUp(googleComplition: @escaping ()->(),
//    facebookComplition: @escaping ()->(),
//    appleComplition: @escaping ()->()) {
//        self.googleComplition = googleComplition
//        self.facebookComplition = facebookComplition
//        self.appleComplition = appleComplition
//    }

    @IBAction private func googleAction(_ sender: Any) {
        googleComplition?()
    }
    @IBAction private func facebookAction(_ sender: Any) {
        facebookComplition?()
    }
    @IBAction private func appleAction(_ sender: Any) {
        appleComplition?()
    }
}
