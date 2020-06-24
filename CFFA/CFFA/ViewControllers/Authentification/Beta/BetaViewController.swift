//
//  BetaViewController.swift
//  CFFA
//
//  Created by Cristian Bularu on 2/19/20.
//  Copyright © 2020 Cristian Bularu. All rights reserved.
//

import UIKit

class BetaViewController: CustomFormViewController, StoryboardInstantiable {
    static var storyboardName = "BetaViewController"
    
    override var preferredStatusBarStyle: UIStatusBarStyle  { return .darkContent }
    
    @IBOutlet weak private var errorLabel: UILabel!
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak private var passwordTextFieldd: UITextField!
    
    @IBOutlet var placeHolderConstraints: [NSLayoutConstraint]!
    
    @IBOutlet var underLines: [UIView]!
    
    @IBOutlet var inputFields: [UITextField]!
    
    private var currentTextField = -1
    
    @IBOutlet weak var otherLoginHolderView: UIView!
    
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
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
    
    @IBAction func logIn(_ sender: Any) {
        
        let validation = AccountSignIn.init(email: emailTextField.text ?? "", password: passwordTextFieldd.text ?? "").preRequestValidation()
        if validation.errors.count > 0 {
            errorLabel.text = ""
            for errorMSG in validation.errors {
                errorLabel.text! += errorMSG + " "
            }
        } else {
            let loadingView = startIndicator()
            AccountActions.SignIn(email: emailTextField.text!, password: passwordTextFieldd.text!) { (ResponseType, errors) in
                DispatchQueue.main.async {
                    self.stopIndicator(loadingView: loadingView)
                    if ResponseType == .Ok {
                        UDefaults.finishedBoarding = true
                        self.navigationController?.popToRootViewController(animated: false)
                    } else if ResponseType == .UnConfirmed {
                        self.continueSignUp()
                    }else {
                        self.errorLabel.text = ""
                        for errorMSG in errors ?? [String]() {
                            self.errorLabel.text! += errorMSG + " "
                        }
                    }
                }
            }
        }
    }
    
    @IBAction func tapOnInputField(_ sender: UITapGestureRecognizer) {
        inputFIeldTappedWith(tag: sender.view?.tag)
    }
    
    private func continueSignUp() {
        let email = emailTextField.text!
        let accountSetUpViewController = AccountSetUpViewController.instantiate()
        accountSetUpViewController.beforeWillAppearComplition = {
            let infoView = InfoView.instanciateWith(image: #imageLiteral(resourceName: "illustrationVerifiedAccount"), generalText: "Verified!", detailedText: "Your account has been verified successfully!")
            let reusableViewController = ReusablePopUpViewController.instantiateWith(infoView)
            accountSetUpViewController.present(reusableViewController, animated: false)
        }
        ConfirmationViewController.instantiateWith(email: email, type: .Email, presentOn: self) { self.navigationController?.pushViewController(accountSetUpViewController, animated: true)
        }
    }
    
    @IBAction func signUp() {
        
        if let list = self.navigationController?.children {
            
            if list[list.count-2]is CharlieViewController {
                self.navigationController?.popViewController(animated: true)
            } else { self.navigationController?.pushViewController(CharlieViewController.instantiate(), animated: true)
            }
        }
    }
    
    @IBAction func forgotPassword() {
        self.navigationController?.pushViewController(ResetPasswordViewController.instantiate(), animated: true)
    }
    
    @IBAction func editingChanged(_ sender: UITextField) {
        
        errorLabel.text = ""
    }
    
    @IBAction func touchDownEYE(_ sender: UIButton) {
        passwordTextFieldd.isSecureTextEntry = false
    }
    
    @IBAction func touchUpEYE(_ sender: UIButton) {
        passwordTextFieldd.isSecureTextEntry = true
        
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
