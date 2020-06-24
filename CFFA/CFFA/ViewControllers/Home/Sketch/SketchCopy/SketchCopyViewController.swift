//
//  SketchCopyViewController.swift
//  CFFA
//
//  Created by Cristian Bularu on 6/1/20.
//  Copyright © 2020 Cristian Bularu. All rights reserved.
//

import UIKit

class SketchCopyViewController: CustomViewController, StoryboardInstantiable, UITextFieldDelegate {
static var storyboardName = "SketchCopyViewController"
    
    @IBOutlet weak private var backBtn: UIButton!
    @IBOutlet weak private var imageView: UIImageView!
    @IBOutlet weak private var leafsTextField: UITextField!
    @IBOutlet weak private var heightTextField: UITextField!
    @IBOutlet weak private var bottomConstraint: NSLayoutConstraint!
    //private var complition: ((UInt, Float)->())?
    private var complition1: (()->())?
    private var presenter: UIViewController!
    private var sketchId: UInt64!
    
    private var img: UIImage? = nil
    private var image: UIImage? {
        get {img}
        set {
            img = newValue
            imageView?.image = newValue
        }
    }
    
    static func instanciateWith(sketchId: UInt64, ext: String, presentOn: UIViewController) {
        let sketchCopyViewController = SketchCopyViewController.instantiate()
        //sketchCopyViewController.complition = complition
        sketchCopyViewController.presenter = presentOn
        let nameIn = "\(sketchId)"
        sketchCopyViewController.sketchId = sketchId
        PhotoManager.getImage(photoType: .Sketch, photoName: nameIn, photoSize: .Medium, extension: ext) { (image, name, response, error) in
            sketchCopyViewController.image = image
        }
        
        presentOn.present(sketchCopyViewController, animated: true)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpView()
        addKeyboardObservers(constraint: bottomConstraint)
        // Do any additional setup after loading the view.
    }
    
    @IBAction private func tryIt() {
        
        if (leafsTextField.text?.isEmpty ?? true) || (heightTextField.text?.isEmpty ?? true) {
            return
        }
        let leafs = UInt(leafsTextField.text!)!
        if let height = Float(heightTextField.text!) {
            self.dismiss(animated: true) {
                //self.complition?(leafs, height)
                PdfManager.getPdfData(sketchId: self.sketchId, leafs: leafs, height: height) { (data) in
                    DispatchQueue.main.async {
                        PdfViewController.instantiateWith(pdfData: data, presentOn: self.presenter)
                    }
                }
            }
        } else {
            heightTextField.backgroundColor = .red
        }
    }
    
    @IBAction func createPost() {
        self.dismiss(animated: true) {
            CreatePostViewController.instantiateWith(sketchId: self.sketchId, pushOn: self.presenter)
        }
    }
    
    @IBAction func back() {
        self.dismiss(animated: true)
    }
    
    func setUpView() {
//        leafsTextField.delegate = self
//        heightTextField.delegate = self
        backBtn.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi*1.5))
        imageView.image = image ?? imageView.image
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        var allowedChars = "1234567890"
        if textField == heightTextField {
            allowedChars.append(".")
        }
        let allowedCharSet = CharacterSet(charactersIn: allowedChars)
        let typedCharacterSet = CharacterSet(charactersIn: string)
        
        return allowedCharSet.isSuperset(of: typedCharacterSet)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == leafsTextField {
            heightTextField.becomeFirstResponder()
            return false
        }
        heightTextField.resignFirstResponder()
        return true
    }

}
