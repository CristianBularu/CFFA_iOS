//
//  CreatePostViewController.swift
//  CFFA
//
//  Created by Cristian Bularu on 6/9/20.
//  Copyright © 2020 Cristian Bularu. All rights reserved.
//

import UIKit

class CreatePostViewController: CustomFormViewController, StoryboardInstantiable {
    static var storyboardName: String = "CreatePostViewController"
    
    @IBOutlet weak private var cameraImageView: UIImageView!
    @IBOutlet weak private var imageView: UIImageView!
    @IBOutlet weak private var publishBtn: CustomButton!
    
    @IBOutlet weak private var titleTextField: UITextField!
    @IBOutlet weak private var descriptionTextView: UITextView!
    
    @IBOutlet var underLines: [UIView]!
    @IBOutlet var placeHolderConstraints: [NSLayoutConstraint]!
    @IBOutlet var inputFields: [UITextField]!
    @IBOutlet weak private var bottomConstraint: NSLayoutConstraint!
    
    
    private var localBool1 = false
    private var addedPhoto: Bool {
        get {return localBool1}
        set {
            localBool1 = newValue
            cameraImageView.isHidden = newValue
            //publishBtn.isEnabled = newValue
        }
    }
    
    private var sketchId: UInt64!
    
    static func instantiateWith(sketchId: UInt64, pushOn: UIViewController) {
        let createPostViewController = CreatePostViewController.instantiate()
        createPostViewController.sketchId = sketchId
        pushOn.navigationController?.pushViewController(createPostViewController, animated: true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        super.initCustomFormFields(inputFields: inputFields, placeHolderConstraints: placeHolderConstraints, underLines: underLines)
        addKeyboardObservers(constraint: bottomConstraint)
    }
    
    @IBAction func popAction() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func changeImageAction(_ sender: UITapGestureRecognizer) {
        showPhotoChoose()
    }
    
    @IBAction func publishAction() {
        if addedPhoto && !(titleTextField.text?.isEmpty ?? true) {
            if let imgData = imageView.image?.jpegData(compressionQuality: 1) {
                PostActions.Create(sketchId: sketchId, title: titleTextField.text!, bodyText: descriptionTextView.text, imgData: imgData) { (responseType, errors) in
                    DispatchQueue.main.async {
                        print(responseType)
                        self.navigationController?.popViewController(animated: true)
                    }
                }
            }
        } else if !addedPhoto {
            showPhotoChoose()
        } else {
            titleTextField.becomeFirstResponder()
        }
    }
    
    @IBAction func tapOutside(_ sender: UITapGestureRecognizer) {
        titleTextField.resignFirstResponder()
        descriptionTextView.resignFirstResponder()
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

extension CreatePostViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            self.addedPhoto = true
            self.imageView.image = pickedImage
        }
        picker.dismiss(animated: true, completion: nil)
    }
}

//extension CreatePostViewController: UITextFieldDelegate {
//    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        textField.resignFirstResponder()
//        return true
//    }
//}

extension CreatePostViewController: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
            return true
        }
        return true
    }
}
