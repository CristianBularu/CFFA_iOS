//
//  ConfirmationViewController.swift
//  CFFA
//
//  Created by Cristian Bularu on 2/19/20.
//  Copyright © 2020 Cristian Bularu. All rights reserved.
//

import UIKit

enum ConfirmationType {
    case Email
    case PasswordReset
}

class ConfirmationViewController: CustomViewController, StoryboardInstantiable {
    static var storyboardName = "ConfirmationViewController"
    
    private var controllerType: ConfirmationType = .Email
    
    private var emailAddress = "geac.mc@gmail.com"
    private var password = ""
    
    @IBOutlet weak private var hiddenInputField: UITextField!
    
    @IBOutlet weak private var bottomConstraint: NSLayoutConstraint!
    
    @IBOutlet private var pinLabels: [UILabel]!
    
    @IBOutlet weak private var verifyButton: CustomButton!
    
    @IBOutlet weak private var emailAddressLabel: UILabel!
    
    @IBOutlet weak private var errorLabel: UILabel!
    
    @IBOutlet weak private var backBtn: UIButton!
    
    @IBOutlet weak private var descriptivLabel: UILabel!
    
    @IBOutlet weak var hoverView: UIView!
    ///Executed when confirmed
    private var complition: (()->())?
    
    private var lastValidText = ""
    
    
    private var errorString = ""
    
    static func instantiateWith(email: String, password: String = "", type: ConfirmationType, presentOn: UIViewController, complition: @escaping ()->()) {
        let confirmationViewController = ConfirmationViewController.instantiate()
        confirmationViewController.emailAddress = email
        confirmationViewController.password = password
        confirmationViewController.controllerType = type
        confirmationViewController.complition = complition
        presentOn.present(confirmationViewController, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        sendResetPassswordToken()
        addKeyboardObservers(constraint: bottomConstraint)
        setUpView()
        mapLastValidTextToUI()
    }
    
    deinit {
        removeObservers()
    }
    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        self.hiddenInputField.becomeFirstResponder()
//    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.hiddenInputField.becomeFirstResponder()
    }
    
    @IBAction func back() {
        self.dismiss(animated: true)
    }
    
    @IBAction func Submit() {
        let loadingView = startIndicator()
        if controllerType == .Email {
            AccountActions.ConfirmEmail(email: emailAddress, token: hiddenInputField.text!) { (responseType, errors) in
                DispatchQueue.main.async {
                    self.stopIndicator(loadingView: loadingView)
                    if responseType == .Ok {
                        self.dismiss(animated: false) {
                            self.complition?()
                        }
                    } else {
                        self.errorLabel.text = ""
                        for error in errors ?? [String]() {
                            self.errorLabel.text! += error + " "
                        }
                        self.mapLastValidTextToUI()
                    }
                }
            }
        } else {
            AccountActions.ResetPassword(email: emailAddress, token: hiddenInputField.text!, newPassword: password) { (responseType, errors) in
                DispatchQueue.main.async {
                    self.stopIndicator(loadingView: loadingView)
                    if responseType == .Ok {
                        self.dismiss(animated: true) {
                            self.complition?()
                        }
                    } else {
                        self.errorLabel.text = ""
                        for error in errors ?? [String]() {
                            self.errorLabel.text! += error + " "
                        }
                        self.mapLastValidTextToUI()
                    }
                }
            }
        }
    }
    
    @IBAction func resend() {
        let loadingView = startIndicator()
        if controllerType == .Email {
            AccountActions.SendEmailConfirmationToken(email: emailAddress) { (responseType, errors) in
                DispatchQueue.main.async {
                    self.stopIndicator(loadingView: loadingView)
                    if responseType != .Ok {
                        print("Somethng wrong with confirmation email token.")
                    }
                }
            }
        } else {
            AccountActions.SentResetPasswordToken(email: emailAddress) { (responseType, errors) in
                DispatchQueue.main.async {
                    self.stopIndicator(loadingView: loadingView)
                    if responseType != .Ok {
                        print("Somethng wrong with reset password token.")
                    }
                }
            }
        }
    }
    
    private func sendResetPassswordToken() {
        let loadingView = startIndicator()
        AccountActions.SentResetPasswordToken(email: emailAddress) { (responseType, errors) in
            DispatchQueue.main.async {
                self.stopIndicator(loadingView: loadingView)
                if responseType != .Ok {
                    print("Somethng wrong with reset password token.")
                }
            }
        }
    }
    
    @IBAction func editingChanged(_ sender: UITextField) {
        if sender.text?.count ?? 0 > 4 {
            sender.text = lastValidText
            return
        }
        errorString = ""
        errorLabel.text = ""
        lastValidText = sender.text ?? ""
        mapLastValidTextToUI()
    }
    
    private func mapLastValidTextToUI() {
        for label in pinLabels {
            label.text = ""
            label.layer.borderColor = UIColor(rgb: 0xE9E9ED).cgColor
        }
        for (index, ch) in lastValidText.enumerated() {
            let labelIndex = pinLabels.firstIndex { (label) -> Bool in
                return label.tag == index
            }
            let label = pinLabels[labelIndex ?? 0]
            label.text = "\(ch)"
            label.layer.borderColor = UIColor(rgb: 0x522CB5).cgColor
        }
        if lastValidText.count == 4 {
            verifyButton.isEnabled = true
        } else {
            verifyButton.isEnabled = false
        }
        
        if errorString.count != 0 {
            for label in pinLabels {
                label.layer.borderColor = UIColor(rgb: 0xFF7750).cgColor
            }
        }
    }
    
    private func setUpView() {
        backBtn.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi*1.5))
        descriptivLabel.text = controllerType == .PasswordReset ? "Reset Password" : "Confirm Account"
        emailAddressLabel.text = emailAddress
        for label in pinLabels {
            label.layer.cornerRadius = 15
            label.layer.borderWidth = 1
            label.layer.borderColor = UIColor(rgb: 0xE9E9ED).cgColor
        }
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))

            hoverView.addGestureRecognizer(tap)
            hoverView.isUserInteractionEnabled = true
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        hiddenInputField.becomeFirstResponder()
    }
}
