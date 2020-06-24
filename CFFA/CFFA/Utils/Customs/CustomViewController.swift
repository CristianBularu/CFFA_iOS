//
//  CustomViewController.swift
//  CFFA
//
//  Created by Cristian Bularu on 2/24/20.
//  Copyright © 2020 Cristian Bularu. All rights reserved.
//

import UIKit

class CustomViewController: UIViewController, UIGestureRecognizerDelegate {

    override var preferredStatusBarStyle: UIStatusBarStyle  { return .darkContent }
    
    var parentCustomViewController: CustomViewController?
    var canPushProfile = true
    var canPushPost = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
    }
    
    func seekToPush(viewController: CustomViewController) {
        print(self)
        let count = self.navigationController?.viewControllers.count ?? 0
        print(count)
        print(viewController.parentCustomViewController == self)
        
        func push() {
            viewController.parentCustomViewController = self
            self.navigationController?.pushViewController(viewController, animated: true)
        }
        
        func recursive() {
            if let parent = self.parentCustomViewController {
                self.navigationController?.popToViewController(parent, animated: true)
                parent.seekToPush(viewController: viewController)
            }
        }
        
        if viewController is PostViewController {
            if self.canPushPost {
                viewController.canPushProfile = self.canPushProfile
                viewController.canPushPost = false
                push()
            } else {
                recursive()
            }
        } else if viewController is ProfileViewController {
            if self.canPushProfile {
                viewController.canPushProfile = false
                viewController.canPushPost = self.canPushPost
                push()
            } else {
               recursive()
            }
        }
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }

    func startIndicator() -> LoadingView {
        let loadingView = LoadingView.instantiate(size: self.view.frame.size)
        self.view.addSubview(loadingView)
        loadingView.start()
        self.view.isUserInteractionEnabled = false
        return loadingView
    }

    func stopIndicator(loadingView: LoadingView) {
        loadingView.stop {
            loadingView.removeFromSuperview()
            self.view.isUserInteractionEnabled = true
        }
    }

    @objc private func willShow(notification: Notification) {

        guard let keyboardRect = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
            return
        }
        self.constraintToAdjust.constant = keyboardRect.height + 10
        UIView.animate(withDuration: 0.2) {
            self.view.layoutIfNeeded()
        }
    }
    
    @objc private func willHide(notification: Notification) {
        guard ((notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue) != nil else {
            return
        }
        self.constraintToAdjust.constant = initialHeight
        UIView.animate(withDuration: 0.2) {
            self.view.layoutIfNeeded()
        }
    }
    
    private var constraintToAdjust: NSLayoutConstraint!
    private var initialHeight: CGFloat = 10
    func addKeyboardObservers(constraint: NSLayoutConstraint) {
        self.constraintToAdjust = constraint
        initialHeight = self.constraintToAdjust.constant
        NotificationCenter.default.addObserver(self, selector: #selector(willShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(willHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func removeObservers() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
}
