//
//  SketchCustomizeViewController.swift
//  CFFA
//
//  Created by Cristian Bularu on 6/8/20.
//  Copyright © 2020 Cristian Bularu. All rights reserved.
//

import UIKit

class SketchCustomizeViewController: CustomViewController, StoryboardInstantiable {
    static var storyboardName: String = "SketchCustomizeViewController"

    @IBOutlet weak private var stickerImageView: UIImageView!
    @IBOutlet weak private var textsImageView: UIImageView!
    @IBOutlet weak private var stickerLabel: UILabel!
    @IBOutlet weak private var textsLabel: UILabel!
    
    @IBOutlet weak var customView: CustomView!
    @IBOutlet weak private var stickersCollectionView: UICollectionView!
    @IBOutlet weak private var fontsCollectionView: UICollectionView!
    
    private let stickersArray = [#imageLiteral(resourceName: "noun_Sector_88212"), #imageLiteral(resourceName: "noun_Pie_88253"), #imageLiteral(resourceName: "noun_Star_88211"), #imageLiteral(resourceName: "noun_square_88266"), #imageLiteral(resourceName: "noun_trefoil_88229"), #imageLiteral(resourceName: "noun_Diamond_2901832")]
    private let fontsArray = ["SavoyeLetPlain", "SnellRoundhand-Black", "Zapfino", "Superclarendon-Black", "Papyrus", "Noteworthy-Bold", "MarkerFelt-Wide", "GillSans-UltraBold", "Georgia-BoldItalic", "Futura-CondensedExtraBold", "Cochin-BoldItalic", "BradleyHandITCTT-Bold", "AmericanTypewriter-Bold"]
    
    private var stickersOn: Bool {
        get {return stickerLabel.isEnabled}
        set {
            stickerLabel.isEnabled = newValue
            textsLabel.isEnabled = !newValue
            
            stickerImageView.image = newValue ? #imageLiteral(resourceName: "stickersOnIcon") : #imageLiteral(resourceName: "stickersIcon")
            textsImageView.image = newValue ? #imageLiteral(resourceName: "textsIcon") : #imageLiteral(resourceName: "textsOnIcon")
            
            fontsCollectionView.isHidden = newValue
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        stickersCollectionView.register(UINib(nibName: StickersCollectionViewCell.identifier, bundle: nil), forCellWithReuseIdentifier: StickersCollectionViewCell.identifier)
        fontsCollectionView.register(UINib(nibName: FontsCollectionViewCell.identifier, bundle: nil), forCellWithReuseIdentifier: FontsCollectionViewCell.identifier)
    }
    
    @IBAction func nextAction() {
        let renderer = UIGraphicsImageRenderer(size: customView.bounds.size)
        let image = renderer.image { ctx in
            customView.drawHierarchy(in: customView.bounds, afterScreenUpdates: true)
        }
        if let imageData = image.jpegData(compressionQuality: 1) {
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
    
    @IBAction func popAction() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func TextTaped(_ sender: UITapGestureRecognizer) {
        stickersOn = false
    }
    
    @IBAction func StickersTaped(_ sender: UITapGestureRecognizer) {
        stickersOn = true
    }
}

extension SketchCustomizeViewController: UICollectionViewDelegate, UICollectionViewDataSource {


    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == stickersCollectionView {
            return stickersArray.count
        }
        return fontsArray.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == stickersCollectionView {
            let stickerCell = collectionView.dequeueReusableCell(withReuseIdentifier: StickersCollectionViewCell.identifier, for: indexPath) as! StickersCollectionViewCell
            stickerCell.setUp(image: stickersArray[indexPath.row])
            return stickerCell
        }
        let fontCell = collectionView.dequeueReusableCell(withReuseIdentifier: FontsCollectionViewCell.identifier, for: indexPath) as! FontsCollectionViewCell
        fontCell.setUp(fontName: fontsArray[indexPath.row])
        return fontCell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == stickersCollectionView {
            print("\(indexPath.row)")
        } else {
            print("\(indexPath.row)")
        }
    }
}

extension SketchCustomizeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == stickersCollectionView {
            return CGSize(width: collectionView.frame.height * 0.66, height: collectionView.frame.height * 0.66)
        }
        return CGSize(width: collectionView.frame.height * 1.98, height: collectionView.frame.height * 0.66)
    }
}
