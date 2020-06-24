//
//  ResetPasswordViewController.swift
//  CFFA
//
//  Created by Cristian Bularu on 2/19/20.
//  Copyright © 2020 Cristian Bularu. All rights reserved.
//

import UIKit

class ResetPasswordViewController: CustomFormViewController, StoryboardInstantiable {
    static var storyboardName = "ResetPasswordViewController"
    override var preferredStatusBarStyle: UIStatusBarStyle  { return .darkContent }
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    @IBOutlet var underLines: [UIView]!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak private var passwordTextFieldd: UITextField!
    @IBOutlet weak private var confirmPasswordTextField: UITextField!
    @IBOutlet var placeHolderConstraints: [NSLayoutConstraint]!
    
    @IBOutlet var inputFields: [UITextField]!
    @IBOutlet weak var errorLabel: UILabel!
    
    private var currentTextField = -1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        super.initCustomFormFields(inputFields: inputFields, placeHolderConstraints: placeHolderConstraints, underLines: underLines)
        addKeyboardObservers(constraint: bottomConstraint)
    }
    
    deinit {
        removeObservers()
    }
    
    @IBAction func back() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func receiveConfirmationCode() {
        let validation = AccountResetPassword.init(email: emailTextField.text ?? "", token: "blank", newPassword: passwordTextFieldd.text ?? "").preRequestValidation()
        let matchError = passwordTextFieldd.text == confirmPasswordTextField.text ? nil : "Confirmation password does not match."
        if validation.succsess {
            if matchError == nil {
                continueReceiveConfirmationCode()
            } else {
                errorLabel.text = matchError
            }
        } else {
            errorLabel.text = ""
            for error in validation.errors {
                errorLabel.text! += error
            }
            errorLabel.text! += matchError ?? ""
        }
    }
    
    private func continueReceiveConfirmationCode() {
//        let initialHome = InitialHomeViewController.instantiate()
//        initialHome.beforeWillAppearComplition = {
//            let infoView = InfoView.instanciateWith(image: #imageLiteral(resourceName: "illustrationPassword"), generalText: "Password reset successful!", detailedText: "You have successfully reset your password. Please use your new password when logging in.")
//            let reusableViewController = ReusablePopUpViewController.instantiateWith(infoView)
//            initialHome.present(reusableViewController, animated: false)
//        }
        
        
        let initialHome = self.navigationController?.viewControllers[0] as? HomeViewController
        
        initialHome?.beforeWillAppearComplition = {
            let infoView = InfoView.instanciateWith(image: #imageLiteral(resourceName: "illustrationPassword"), generalText: "Password reset successful!", detailedText: "You have successfully reset your password. Please use your new password when logging in.")
            let popUpViewController = ReusablePopUpViewController.instantiateWith(infoView)
            initialHome?.present(popUpViewController, animated: true)
        }
        
        ConfirmationViewController.instantiateWith(email: emailTextField.text!, password: passwordTextFieldd.text! ,type: .PasswordReset, presentOn: self) {
            
            self.navigationController?.popToRootViewController(animated: true)
        }
    }
    
    @IBAction func editingChanged(_ sender: UITextField) {
        
        errorLabel.text = ""
    }
    
    @IBAction func touchDownEYE(_ sender: UIButton) {
        if sender.tag == 0 {
            passwordTextFieldd.isSecureTextEntry = false
        } else {
            confirmPasswordTextField.isSecureTextEntry = false
        }
    }
    
    @IBAction func touchUpEYE(_ sender: UIButton) {
        if sender.tag == 0 {
            passwordTextFieldd.isSecureTextEntry = true
        } else {
            confirmPasswordTextField.isSecureTextEntry = true
        }
    }
    
    @IBAction func tapOnInputField(_ sender: UITapGestureRecognizer) {
        inputFIeldTappedWith(tag: sender.view?.tag)
    }
    //    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        
//        //textField.resignFirstResponder()
//        let nextField = inputFields.first(where: { (txtField) -> Bool in
//            return txtField.tag == textField.tag + 1
//        })
//        if nextField != nil {
//            nextField?.becomeFirstResponder()
//        } else {
//            textField.resignFirstResponder()
//        }
//        return true
//    }
//    
//    func textFieldDidBeginEditing(_ textField: UITextField) {
//        
//        let constraint = placeHolderConstraints.first { (constraint) -> Bool in
//            constraint.identifier == "\(textField.tag)"
//        }
//        constraint?.constant = textField.frame.height
//        
//        currentTextField = textField.tag
//        adjustLinesColor()
//    }
//    
//    func textFieldDidEndEditing(_ textField: UITextField) {
//        currentTextField = -1
//        adjustLinesColor()
//    }
//    
//    private func adjustLinesColor() {
//        
//        for textField in inputFields {
//            if textField.tag == currentTextField {
//                continue
//            }
//            let constraint = placeHolderConstraints.first { (constraint) -> Bool in
//                constraint.identifier == "\(textField.tag)"
//            }
//            if textField.text?.count ?? 0 > 0 {
//                constraint?.constant = textField.frame.height
//            } else {
//                constraint?.constant = 8
//            }
//        }
//        self.view.layoutIfNeeded()
//        
//        let underLine = underLines.first { (view) -> Bool in
//            return view.tag == currentTextField
//        }
//        for view in underLines {
//            if underLine != view {
//                view.backgroundColor = UIColor(rgb: 0xAAAAAA)
//            } else {
//                view.backgroundColor = UIColor(rgb: 0x522CB5)
//            }
//        }
//    }
}
