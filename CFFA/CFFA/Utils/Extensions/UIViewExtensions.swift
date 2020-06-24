//
//  UIViewExtensions.swift
//  CFFA
//
//  Created by Cristian Bularu on 2/23/20.
//  Copyright © 2020 Cristian Bularu. All rights reserved.
//

import UIKit


extension UIView {
    func addSubViewCustom(subView: UIView) {
        subView.frame = CGRect(origin: .zero, size: self.frame.size)
        self.addSubview(subView)
        self.addNeededMarginConstraints(contentSubView: subView)
        self.layoutIfNeeded()
    }
    func addNeededMarginConstraints(contentSubView: UIView) {
        self.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: contentSubView,
            attribute: .leading,
            relatedBy: .equal,
            toItem: self,
            attribute: .leading,
            multiplier: 1,
            constant: 0).isActive = true

        NSLayoutConstraint(item: contentSubView,
            attribute: .top,
            relatedBy: .equal,
            toItem: self,
            attribute: .top,
            multiplier: 1,
            constant: 0).isActive = true

        NSLayoutConstraint(item: contentSubView,
            attribute: .trailing,
            relatedBy: .equal,
            toItem: self,
            attribute: .trailing,
            multiplier: 1,
            constant: 0).isActive = true

        NSLayoutConstraint(item: contentSubView,
            attribute: .bottom,
            relatedBy: .equal,
            toItem: self,
            attribute: .bottom,
            multiplier: 1,
            constant: 0).isActive = true
    }
}
