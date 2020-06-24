//
//  ReusablePopUpViewController.swift
//  CFFA
//
//  Created by Cristian Bularu on 2/22/20.
//  Copyright © 2020 Cristian Bularu. All rights reserved.
//

import UIKit

protocol PPopUpDismisser {
    func dismiss(complition: @escaping () -> Void)
}

protocol POwnableView where Self: UIView {
    func setOwner(owner: PPopUpDismisser)
}

class OwnableView: UIView, POwnableView {
    internal var owner: PPopUpDismisser!
    
    func setOwner(owner: PPopUpDismisser) {
        self.owner = owner
    }
}

class ReusablePopUpViewController: CustomViewController, PPopUpDismisser, StoryboardInstantiable {
    static var storyboardName: String = "ReusablePopUpViewController"
    
    @IBOutlet weak var contentView: UIView!
    private var autoDismiss = true
    
    var contentSubView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.alpha = 0
        contentView.addSubViewCustom(subView: contentSubView)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if autoDismiss {
            DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
                self.dismiss {}
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.2) {
                self.view.alpha = 1
            }
        }
    }
    
    @IBAction func backgroundTapped(_ sender: UITapGestureRecognizer) {
        self.dismiss {}
    }
    
    static func instantiateWith(_ view: POwnableView, autoDismiss: Bool = true) -> ReusablePopUpViewController {
        let reusableViewController = ReusablePopUpViewController.instantiate()
        reusableViewController.autoDismiss = autoDismiss
        reusableViewController.contentSubView = view
        reusableViewController.modalPresentationStyle = .overCurrentContext
        view.setOwner(owner: reusableViewController)
        
        return reusableViewController
    }
    
    func dismiss(complition: @escaping () -> Void) {
        UIView.animate(withDuration: 0.2, animations: {
            self.view.alpha = 0
        }) { (ok) in
            self.dismiss(animated: false) {
                complition()
            }
        }
    }
}
