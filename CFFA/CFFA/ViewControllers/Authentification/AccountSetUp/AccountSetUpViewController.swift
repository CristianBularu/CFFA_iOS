//
//  AccountSetUpViewController.swift
//  CFFA
//
//  Created by Cristian Bularu on 2/19/20.
//  Copyright © 2020 Cristian Bularu. All rights reserved.
//

import UIKit
///To be presented
class AccountSetUpViewController: CustomViewController, StoryboardInstantiable {
    static var storyboardName = "AccountSetUpViewController"
    
    @IBOutlet weak var addPhotoBtn: CustomButton!
    @IBOutlet weak private var profilePicture: UIImageView!
    override var preferredStatusBarStyle: UIStatusBarStyle  { return .darkContent }
    var beforeWillAppearComplition: (() ->())?
    private var localBool1 = false
    private var addedPhoto: Bool {
        get {return localBool1}
        set {
            localBool1 = newValue
            addPhotoBtn.setTitle(newValue ? "Looks good" : "Add a photo", for: .normal)
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        beforeWillAppearComplition?()
        beforeWillAppearComplition = nil
        super.viewWillAppear(animated)
    }
    
    @IBAction func tapGestureAddPhoto(_ sender: Any) {
        showPhotoChoose()
    }
    
    @IBAction func buttonAddPhoto() {
        if addedPhoto {
            if let imgData = profilePicture.image?.jpegData(compressionQuality: 1) {
                UserActions.changeIcon(imgData: imgData) { (responseType) in
                    if responseType == .Ok {
                        DispatchQueue.main.async {
                            self.navigationController?.popToRootViewController(animated: true)
                        }
                    }
                }
            }
        } else {
            showPhotoChoose()
        }
    }
    
    @IBAction func skip() {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    private func showPhotoChoose() {
        let upRiseMenuView = UpRiseMenuView.instantiateWith(infoText: "Add profile photo", button1Text: "Take a photo", button2Text: "Choose from galery", button1Handler: {
            self.displayCamera()
        }) {
            self.displayLibrary()
        }
        UpRiseViewController.instantiateWith(upRiseMenuView, presentOn: self)
    }
    
    private func displayCamera() {
        let imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .camera
        imagePicker.delegate = self
        self.present(imagePicker, animated: true)
    }
    
    private func displayLibrary() {
        let imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        self.present(imagePicker, animated: true)
    }
}

extension AccountSetUpViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            self.addedPhoto = true
            self.addPhotoBtn.titleLabel?.text = "Continue"
            self.profilePicture.image = pickedImage
        }
        picker.dismiss(animated: true, completion: nil)
    }
}
