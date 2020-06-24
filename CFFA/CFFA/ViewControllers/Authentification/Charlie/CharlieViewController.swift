//
//  CharlieViewController.swift
//  CFFA
//
//  Created by Cristian Bularu on 2/19/20.
//  Copyright © 2020 Cristian Bularu. All rights reserved.
//

import UIKit

class CharlieViewController: CustomFormViewController, StoryboardInstantiable {
    static var storyboardName = "CharlieViewController"
    override var preferredStatusBarStyle: UIStatusBarStyle  { return .darkContent }
    @IBOutlet weak var errorLabel: UILabel!
    
    @IBOutlet weak var nameLabel: UITextField!
    @IBOutlet weak var emailLabel: UITextField!
    @IBOutlet weak private var passwordTextFieldd: UITextField!
    @IBOutlet weak private var confirmPasswordTextField: UITextField!
    
    @IBOutlet var placeHolderConstraints: [NSLayoutConstraint]!
    
    @IBOutlet var underLines: [UIView]!
    
    private var currentTextField = -1
    
    @IBOutlet var inputFields: [UITextField]!
    
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var otherLoginHolderView: UIView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        super.initCustomFormFields(inputFields: inputFields, placeHolderConstraints: placeHolderConstraints, underLines: underLines)
        
        let otherLoginView = OtherLoginView.instantiateWith(googleComplition: {
                    print("Google Log In Page")
                }, facebookComplition: {
                    print("Facebook Log In Page")
                }) {
                    print("Apple Log In Page")
                }
        otherLoginHolderView.addSubViewCustom(subView: otherLoginView)
        addKeyboardObservers(constraint: bottomConstraint)
    }
    
    deinit {
        removeObservers()
    }
    
    @IBAction func logIn() {
        
        if let list = self.navigationController?.children {
            if list[list.count-2] is BetaViewController {
                self.navigationController?.popViewController(animated: true)
            } else { self.navigationController?.pushViewController(BetaViewController.instantiate(), animated: true)
            }
        }
    }
    
    @IBAction func SignUp() {

        let validation = AccountSignUp(email: emailLabel.text ?? "", fullName: nameLabel.text ?? "", password: passwordTextFieldd.text ?? "", file: nil).preRequestValidation()
        let matchError: String? = passwordTextFieldd.text == confirmPasswordTextField.text ? nil : "Confirmation password does not match."
        
        if validation.succsess {
            if matchError == nil {
                let loadingView = startIndicator()
                AccountActions.SignUp(email: emailLabel.text!, fullName: nameLabel.text!, password: passwordTextFieldd.text!, file: nil) { (ResponseType, errors) in
                    DispatchQueue.main.async {
                        self.stopIndicator(loadingView: loadingView)
                        if ResponseType == .Ok {
                            self.continueSignUp()
                        } else {
                            self.errorLabel.text = ""
                            for error in errors ?? [String]() {
                                self.errorLabel.text! += error + ". "
                            }
                            self.errorLabel.text! += matchError ?? ""
                        }
                    }
                }
            } else {
                errorLabel.text = matchError
            }
        } else {
            self.errorLabel.text = ""
            for error in validation.errors {
                self.errorLabel.text! += error + " "
            }
            self.errorLabel.text! += matchError ?? ""
        }
    }
    
    @IBAction func tapOnInputField(_ sender: UITapGestureRecognizer) {
        inputFIeldTappedWith(tag: sender.view?.tag)
    }
    
    private func continueSignUp() {
        let email = emailLabel.text!
        let accountSetUpViewController = AccountSetUpViewController.instantiate()
        accountSetUpViewController.beforeWillAppearComplition = {
            let infoView = InfoView.instanciateWith(image: #imageLiteral(resourceName: "illustrationVerifiedAccount"), generalText: "Verified!", detailedText: "Your account has been verified successfully!")
            let reusableViewController = ReusablePopUpViewController.instantiateWith(infoView)
            accountSetUpViewController.present(reusableViewController, animated: false)
            UDefaults.finishedBoarding = true
        }
        ConfirmationViewController.instantiateWith(email: email, type: .Email, presentOn: self) { self.navigationController?.pushViewController(accountSetUpViewController, animated: true)
        }
    }
    
    @IBAction func editingChanged(_ sender: UITextField) {
//        let infoView = InfoView.instanciateWith(image: #imageLiteral(resourceName: "illustrationPassword"), generalText: "Password reset successful!", detailedText: "You have successfully reset your password. Please use your new password when logging in.")
//        let reusableViewController = ReusablePopUpViewController.instantiateWith(infoView)
//        self.present(reusableViewController, animated: false)
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
    
//    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//
//        let nextField = inputFields.first(where: { (txtField) -> Bool in
//            return txtField.tag == textField.tag + 1
//        })
//        if nextField != nil {
//            nextField?.becomeFirstResponder()
//        } else {
//            textField.resignFirstResponder()
//        }
//
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
