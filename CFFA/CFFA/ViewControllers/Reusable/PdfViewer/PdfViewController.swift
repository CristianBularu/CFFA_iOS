//
//  PdfViewController.swift
//  CFFA
//
//  Created by Cristian Bularu on 5/31/20.
//  Copyright © 2020 Cristian Bularu. All rights reserved.
//

import UIKit
import PDFKit

class PdfViewController: UIViewController, StoryboardInstantiable {
    static var storyboardName: String = "PdfViewController"

    
    @IBOutlet weak var pdfView: PDFView!
    private var pdfData: Data!
    
    static func instantiateWith(pdfData: Data, presentOn: UIViewController) {
        let pdfViewController = PdfViewController.instantiate()
//        pdfViewController.pdfUrl = pdfUrl
        pdfViewController.pdfData = pdfData
        presentOn.present(pdfViewController, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let pdfDocument = PDFDocument(data: pdfData) {
            pdfView.autoScales = true
            pdfView.displayMode = .singlePageContinuous
            pdfView.displayDirection = .vertical
            pdfView.document = pdfDocument
        }
    }
    
    @IBAction func dismiss() {
        self.dismiss(animated: true)
    }
    
    @IBAction func share() {
        print("sharePdf")//TODO: Share
    }
    
}
