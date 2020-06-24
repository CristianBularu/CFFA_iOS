//
//  LoadingView.swift
//  CFFA
//
//  Created by Cristian Bularu on 2/24/20.
//  Copyright © 2020 Cristian Bularu. All rights reserved.
//

import UIKit

class LoadingView: UIView {
    static var identifier = "LoadingView"
    
    @IBOutlet private var indicator: UIActivityIndicatorView!
    @IBOutlet weak private var VEffect: UIVisualEffectView!
    private var vEffect: UIVisualEffectView!
    
    static func instantiate(size: CGSize) -> LoadingView {
        let loadingView = (UINib(nibName: identifier, bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! LoadingView)
        loadingView.frame = CGRect(origin: .zero, size: size)
        loadingView.vEffect = loadingView.VEffect
        loadingView.VEffect = nil
        return loadingView
    }
    func start() {
        UIView.animate(withDuration: 0.2) {
            self.alpha = 1
            self.VEffect = self.vEffect
        }
    }
    
    func stop(complition: @escaping(()->())) {
        UIView.animate(withDuration: 0.2, animations: {
            self.VEffect = nil
            self.alpha = 0
        }) { (ok) in
            complition()
        }
    }
}
