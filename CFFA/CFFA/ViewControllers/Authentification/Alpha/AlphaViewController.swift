//
//  AlphaViewController.swift
//  CFFA
//
//  Created by Cristian Bularu on 2/19/20.
//  Copyright © 2020 Cristian Bularu. All rights reserved.
//

import UIKit

class AlphaViewController: CustomViewController, StoryboardInstantiable {
    static var storyboardName: String = "AlphaViewController"
    override var preferredStatusBarStyle: UIStatusBarStyle  { return .lightContent }
    @IBOutlet var stars: [UIView]!
    
    
    @IBOutlet var bigLabels: [UILabel]!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        adjustStars()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }
    
    
    private func adjustStars() {
        for starView in stars {
            starView.layer.cornerRadius = starView.frame.width/5
            starView.transform = CGAffineTransform(rotationAngle: CGFloat(7 * Double.pi / 180));
        }
    }
    
    @IBAction func SignUp() {
        self.navigationController?.pushViewController(CharlieViewController.instantiate(), animated: true)
    }
    
    @IBAction func SignIn() {
        self.navigationController?.pushViewController(BetaViewController.instantiate(), animated: true)
    }
    
    @IBAction func ContinueAsGuest() {
//        self.present(ConnectionFailViewController.instantiate(), animated: true) {
//            print("Done")
//        }
        
        UDefaults.finishedBoarding = true
        self.navigationController?.popViewController(animated: true)
        
//        PostActions.TrySketch(sketchId: 30, leafs: 25, height: 25) { (responseType, tempUrl, errors) in
//            
//            if tempUrl != nil {
//                DispatchQueue.main.async {
//                    let pdfViewController = PdfViewController.instantiateWith(pdfUrl: tempUrl!)
//                    self.present(pdfViewController, animated: true)
//                    //self.navigationController?.pushViewController(pdfViewController, animated: true)
//                }
//            }
//        }
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
