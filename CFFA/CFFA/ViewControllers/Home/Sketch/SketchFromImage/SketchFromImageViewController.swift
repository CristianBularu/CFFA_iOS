//
//  SketchFromImageViewController.swift
//  CFFA
//
//  Created by Cristian Bularu on 3/15/20.
//  Copyright © 2020 Cristian Bularu. All rights reserved.
//
import CoreImage
import CoreImage.CIFilterBuiltins
import UIKit

class SketchFromImageViewController: UIViewController, StoryboardInstantiable {
    static var storyboardName: String = "SketchFromImageViewController"
    
    @IBOutlet weak var displayedImageView: UIImageView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var slider2: UISlider!
    @IBOutlet weak var slider3: UISlider!
    @IBOutlet weak var slider4: UISlider!
    @IBOutlet weak var slider5: UISlider!
    
    @IBOutlet weak var collectionHeightConstraint: NSLayoutConstraint!
    
    private var algs = [(String, UIImage)]()
    private var image: UIImage!
    private var testingImage: UIImage!
    
    static func instantiateWith(_ image: UIImage, presentOn: UIViewController) {
        let vc = SketchFromImageViewController.instantiate()
        vc.image = image
        presentOn.navigationController?.pushViewController(vc, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.displayedImageView.image = image
        
        
        let ciImage = CIImage(image: image)
        let paramsLanczosScale: [(Any, String)] = [(0.3, kCIInputScaleKey)]
        if let output = ciImage?
            .apply(.lanczosScaleTransform(), parameters: paramsLanczosScale) {
            let context = CIContext()
            if let cgImage = context.createCGImage(output, from: output.extent) {
                self.testingImage = UIImage(cgImage: cgImage)
            }
        }
        getAlgs()
    }
    
    @IBAction func popAction() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func nextAction() {
        //TODO: Get Real Image
        if let imageData = displayedImageView.image?.jpegData(compressionQuality: 1) {
            PostActions.CreateSketch(imgData: imageData) { (responseType, sketch, errors) in
                DispatchQueue.main.async {
                    self.navigationController?.popViewController(animated: true)
                    if sketch != nil {
                        SketchCopyViewController.instanciateWith(sketchId: sketch!.id, ext: sketch!.extension, presentOn: self.navigationController!.viewControllers.last!)
                    }
                }
            }
        }
    }
    
    func getAlgs() {
        let ciImage = CIImage(image: testingImage)
        //let paramsEdgeWork: [(Any, String)] = [(3, kCIInputRadiusKey)]
        let paramsLineOverly: [(Any, String)] = [(0.7, "inputNRNoiseLevel"), (0.71, "inputNRSharpness"), (1, "inputEdgeIntensity"), (1, "inputThreshold"), (50, "inputContrast")]
        let paramsNoiceReduction: [(Any, String)] = [(0.02, forKey: "inputNoiseLevel"), (0.4, forKey: kCIInputSharpnessKey)]
        if let output = ciImage?
            .apply(.lineOverlay(), parameters: paramsLineOverly)?
            //.apply(.edgeWork(), parameters: paramsEdgeWork)?
            .apply(.noiseReduction(), parameters: paramsNoiceReduction) {
            let context = CIContext()
            if let cgImage = context.createCGImage(output, from: output.extent) {
                self.displayedImageView.image = UIImage(cgImage: cgImage)
            }
        }
    }
    
    func adjust(_ value: Float,_ value2: Float,_ value3: Float, _ value4: Float, _ value5: Float) {
        let ciImage = CIImage(image: testingImage)
        let paramsLineOverly: [(Any, String)] = [(value, "inputNRNoiseLevel"), (value2, "inputNRSharpness"), (value4, "inputEdgeIntensity"), (value5, "inputThreshold"), (50.0, "inputContrast")]
        let paramsNoiceReduction: [(Any, String)] = [(value3, forKey: "inputNoiseLevel"), (0.4, forKey: kCIInputSharpnessKey)]
        if let output = ciImage?
            .apply(.lineOverlay(), parameters: paramsLineOverly)?
            //.apply(.edgeWork(), parameters: paramsEdgeWork)?
            .apply(.noiseReduction(), parameters: paramsNoiceReduction) {
            let context = CIContext()
            if let cgImage = context.createCGImage(output, from: output.extent) {
                DispatchQueue.main.async {
                    self.displayedImageView.image = UIImage(cgImage: cgImage)
                }
            }
        }
    }
    
    @IBAction func sliderChanged(_ sender: UISlider) {
        let value = sender.value
        let value2 = slider2.value
        let value3 = slider3.value
        let value4 = slider4.value
        let value5 = slider5.value
        DispatchQueue.global().async {
            self.adjust(value, value2, value3, value4, value5)
        }
    }
    
    @IBAction func slider2Changed(_ sender: UISlider) {
        let value = sender.value
        let value1 = slider.value
        let value3 = slider3.value
        let value4 = slider4.value
        let value5 = slider5.value
        DispatchQueue.global().async {
            self.adjust(value1, value, value3, value4, value5)
        }
    }
    
    @IBAction func slider3Changed(_ sender: UISlider) {
        let value = sender.value
        let value1 = slider.value
        let value2 = slider2.value
        let value4 = slider4.value
        let value5 = slider5.value
        DispatchQueue.global().async {
            self.adjust(value1, value2, value, value4, value5)
        }
    }
    
    @IBAction func slider4Changed(_ sender: UISlider) {
        let value = sender.value
        let value1 = slider.value
        let value2 = slider2.value
        let value3 = slider3.value
        let value5 = slider5.value
        DispatchQueue.global().async {
            self.adjust(value1, value2, value3, value, value5)
        }
    }
    
    @IBAction func slider5Changed(_ sender: UISlider) {
        let value = sender.value
        let value1 = slider.value
        let value2 = slider2.value
        let value3 = slider3.value
        let value4 = slider4.value
        
        DispatchQueue.global().async {
            self.adjust(value1, value2, value3, value4, value)
        }
    }
}

extension CIImage {
    func apply(_ filter: CIFilter, parameters: [(Any?, String)]? = nil) -> CIImage? {
        filter.setValue(self, forKey: kCIInputImageKey)
        for item in parameters ?? [(Any?, String)](){
            filter.setValue(item.0, forKey: item.1)
        }
        return filter.outputImage
    }
}

extension SketchFromImageViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return algs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AdjustAlghorithmCell.identifier, for: indexPath) as! AdjustAlghorithmCell
        cell.setUp(algs[indexPath.row])
        return cell
    } 
}
