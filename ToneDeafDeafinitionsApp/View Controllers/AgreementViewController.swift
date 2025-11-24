//
//  AgreementViewController.swift
//  ToneDeafDeafinitionsApp
//
//  Created by Tone Deaf on 10/21/20.
//  Copyright © 2020 GITEM Solutions. All rights reserved.
//

import UIKit
import PDFKit

class AgreementViewController: UIViewController {

    @IBOutlet weak var pdfViewer: UIView!
    @IBOutlet weak var consentMessage: UILabel!
    @IBOutlet weak var agreeButton: UIButton!
    @IBOutlet weak var closeButton: UIButton!
    
    var pdfGoing:Data!
    
    var agreeIndex:Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        closeButton.layer.cornerRadius = 7
        agreeButton.layer.cornerRadius = 7
        closeButton.addTarget(self, action: #selector(cancelTapped), for: .touchUpInside)
        agreeButton.addTarget(self, action: #selector(agreeTapped), for: .touchUpInside)
        let pdfView = PDFView(frame: pdfViewer.bounds)
        pdfView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        pdfView.autoScales = true
        pdfView.document = PDFDocument(data: pdfGoing)
        pdfViewer.addSubview(pdfView)
        // Do any additional setup after loading the view.
    }

    @objc func cancelTapped() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func agreeTapped() {
        
        NotificationCenter.default.post(name: CheckoutSuccessfulAgreeNotify, object: agreeIndex)
        self.dismiss(animated: true, completion: nil)
    }
}
