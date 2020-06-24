//
//  CustomFormViewController.swift
//  CFFA
//
//  Created by Cristian Bularu on 2/24/20.
//  Copyright © 2020 Cristian Bularu. All rights reserved.
//

import UIKit

class CustomFormViewController: CustomViewController, UITextFieldDelegate {

    private var inputFields: [UITextField]!
    private var constraints: [NSLayoutConstraint]!
    private var underLines: [UIView]!
    private var currentTextField = -1
    
    func initCustomFormFields(inputFields: [UITextField], placeHolderConstraints: [NSLayoutConstraint], underLines: [UIView]) {
        self.inputFields = inputFields
        self.constraints = placeHolderConstraints
        self.underLines = underLines
    }
    
    func inputFIeldTappedWith(tag: Int?) {
        let inputField = inputFields.first(where: { (txtField) -> Bool in
            return txtField.tag == tag
        })
        inputField?.becomeFirstResponder()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        let nextField = inputFields.first(where: { (txtField) -> Bool in
            return txtField.tag == textField.tag + 1
        })
        if nextField != nil {
            nextField?.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        let constraint = constraints.first { (constraint) -> Bool in
            constraint.identifier == "\(textField.tag)"
        }
        constraint?.constant = textField.frame.height
        
        currentTextField = textField.tag
        adjustLinesColor()
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        currentTextField = -1
        adjustLinesColor()
    }
    
    func adjustLinesColor() {
        
        for textField in inputFields {
            if textField.tag == currentTextField {
                continue
            }
            let constraint = constraints.first { (constraint) -> Bool in
                constraint.identifier == "\(textField.tag)"
            }
            if textField.text?.count ?? 0 > 0 {
                constraint?.constant = textField.frame.height
            } else {
                constraint?.constant = 8
            }
        }
        self.view.layoutIfNeeded()
        
        let underLine = underLines.first { (view) -> Bool in
            return view.tag == currentTextField
        }
        for view in underLines {
            if underLine != view {
                view.backgroundColor = UIColor(rgb: 0xAAAAAA)
            } else {
                view.backgroundColor = UIColor(rgb: 0x522CB5)
            }
        }
    }
}
