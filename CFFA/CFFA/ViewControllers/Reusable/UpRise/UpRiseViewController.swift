//
//  UpRiseViewController.swift
//  CFFA
//
//  Created by Cristian Bularu on 2/22/20.
//  Copyright © 2020 Cristian Bularu. All rights reserved.
//

import UIKit

class UpRiseViewController: CustomViewController, PPopUpDismisser, StoryboardInstantiable {
    static var storyboardName = "UpRiseViewController"
    
    @IBOutlet weak private var backgroundView: UIView!
    @IBOutlet weak private var panableView: UIView!
    @IBOutlet weak private var panableMidConstraint: NSLayoutConstraint!
    @IBOutlet weak private var roundedHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak private var roundedView: UIView!
    //@IBOutlet weak private var contentBottomInsetsConstraint: NSLayoutConstraint!
    //@IBOutlet weak private var contentTopSafeInsetsConstraint: NSLayoutConstraint!
    @IBOutlet weak var contentView: UIView!//contentBottomInsetsConstraint//contentTopSafeInsetsConstraint
    @IBOutlet weak var contentBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var contentTopConstraint: NSLayoutConstraint!
    
    private var desiredHeight: CGFloat!
    var contentSubView: UIView!
    
    static func instantiateWith(_ view: POwnableView, presentOn: UIViewController) {
        let upRiseViewController = UpRiseViewController.instantiate()
        upRiseViewController.contentSubView = view
        upRiseViewController.modalPresentationStyle = .overCurrentContext
        view.setOwner(owner: upRiseViewController)
        presentOn.present(upRiseViewController, animated: false)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        desiredHeight = contentSubView.frame.height
        roundedHeightConstraint.constant = desiredHeight
        //Make 2 corners round
        self.roundedView.clipsToBounds = true
        self.roundedView.layer.cornerRadius = 40
        self.roundedView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        setUpHeightAccording()
        resizeUpRise(to: self.view.frame.size)
        
        self.panableMidConstraint.constant = self.view.frame.height
        self.panableView.layoutIfNeeded()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        UIView.animate(withDuration: 0.3) {
            self.backgroundView.alpha = 0.5
            self.panableMidConstraint.constant = 0
            self.panableView.layoutIfNeeded()
            self.view.layoutSubviews()
        }
    }
    
    private func resizeUpRise(to size: CGSize) {
        let requiredHeight = contentTopConstraint.constant + contentBottomConstraint.constant
        
        if desiredHeight > size.height - requiredHeight {
            roundedHeightConstraint.constant = size.height - requiredHeight
        } else {
            roundedHeightConstraint.constant = contentTopConstraint.constant + contentBottomConstraint.constant + desiredHeight
        }
        contentView.layoutIfNeeded()
        contentView.layoutSubviews()
        roundedView.layoutIfNeeded()
    }

    private func setUpHeightAccording() {
        contentView.backgroundColor = .clear
        contentSubView.frame = contentView.frame
        contentView.addSubViewCustom(subView: contentSubView)
        
        let keyWindow = UIApplication.shared.connectedScenes
            .filter({$0.activationState == .foregroundActive})
            .map({$0 as? UIWindowScene})
            .compactMap({$0})
            .first?.windows
            .filter({$0.isKeyWindow}).first
        contentBottomConstraint.constant = (keyWindow?.safeAreaInsets.bottom ?? 0) + 8
    }
    
    func dismiss(complition: @escaping () -> Void) {
        self.privateDismiss {
            complition()
        }
    }
    
    @IBAction func tapGesture(_ sender: UITapGestureRecognizer = UITapGestureRecognizer()) {
        
        self.dismiss {}
    }
    
    private func privateDismiss(_ complition: @escaping () -> Void ) {
        
        UIView.animate(withDuration: 0.2, animations: {
            self.backgroundView.alpha = 0
            self.panableView.frame = CGRect(x: self.initialFrameX, y: self.panableView.frame.height, width: self.panableView.frame.width, height: self.panableView.frame.height)
        }) { (bool) in
            self.dismiss(animated: false) {
                complition()
            }
        }
    }
    
    private var initialTouchPoint = CGPoint(x: 0, y: 0)
    private var initialFrameX = CGFloat(0)
    @IBAction func panGesture(_ sender: UIPanGestureRecognizer) {
        let touchPoint = sender.location(in: self.view.window)
        let velocity = sender.velocity(in: self.view).y
        if sender.state == .began {
            initialTouchPoint = touchPoint
            initialFrameX = self.panableView.frame.minX
        } else if sender.state == .changed {
            if touchPoint.y - initialTouchPoint.y > 0 {
                self.panableView.frame = CGRect(x: initialFrameX, y: touchPoint.y - initialTouchPoint.y, width: self.panableView.frame.width, height: self.panableView.frame.height)
                backgroundView.alpha = 0.5 - (touchPoint.y - initialTouchPoint.y) / (contentView.frame.height * 3)
            } else {
                self.panableView.frame = CGRect(x: initialFrameX, y: 0, width: self.panableView.frame.width, height: self.panableView.frame.height)
                self.backgroundView.alpha = 0.5
            }
            
        } else if sender.state == .ended  || sender.state == .cancelled {
            if touchPoint.y - initialTouchPoint.y  > contentView.frame.height/2 || velocity > 400 {
                let elapseDuration = 0.25 - Double(velocity) * 0.00005
                UIView.animate(withDuration: elapseDuration, animations: {
                    self.backgroundView.alpha = 0
                    self.panableView.frame = CGRect(x: self.initialFrameX, y: self.panableView.frame.height, width: self.panableView.frame.width, height: self.panableView.frame.height)
                }) { (bool) in
                    self.dismiss(animated: false)
                }
            } else  {
                UIView.animate(withDuration: 0.25) {
                    self.panableView.frame = CGRect(x: self.initialFrameX, y: 0, width: self.panableView.frame.width, height: self.panableView.frame.height)
                    self.backgroundView.alpha = 0.5
                }
            }
        }
    }
}
