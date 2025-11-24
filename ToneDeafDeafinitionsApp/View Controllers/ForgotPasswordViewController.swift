//
//  ForgotPasswordViewController.swift
//  ToneDeafDeafinitionsApp
//
//  Created by Tone Deaf on 7/30/20.
//  Copyright © 2020 GITEM Solutions. All rights reserved.
//

import UIKit

class ForgotPasswordViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var textFieldEMail: UITextField! {
        didSet {
            let placeholderText = NSAttributedString(string: "E-Mail",
                                                        attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray.withAlphaComponent(0.4)])
            
            textFieldEMail.attributedPlaceholder = placeholderText
        }
    }
    @IBOutlet weak var resetButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpElements()

        // Do any additional setup after loading the view.
    }
    
    func setUpElements() {
    //Style Elements
    Utilities.styleTextField(textFieldEMail)
    Utilities.styleFilledButton(resetButton)
    addBottomLineToText(textFieldEMail)
    textFieldEMail.setLeftIcon(UIImage(named: "mail")!)
    textFieldEMail.delegate = self
    }
    
    @IBAction func resetButtonTapped(_ sender: Any) {
    }
    
    func addBottomLineToText(_ textfield:UITextField) {
        let bottomLine = CALayer()
        
        bottomLine.frame = CGRect(x: 0,
                                  y: textfield.frame.height - 1,
                                  width: view.frame.size.width - 60,//textfield.frame.width,
                                  height: 2)
        
        bottomLine.backgroundColor = UIColor.init(red: 182/255, green: 0/255, blue: 3/255, alpha: 1).cgColor
        
        textfield.layer.addSublayer(bottomLine)
    }
    
    func dismissKeyboardOnTap() {
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
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
