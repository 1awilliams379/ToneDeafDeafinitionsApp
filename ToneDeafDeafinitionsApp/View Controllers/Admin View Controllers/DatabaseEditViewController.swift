//
//  DatabaseEditViewController.swift
//  ToneDeafDeafinitionsApp
//
//  Created by Tone Deaf on 7/5/22.
//  Copyright © 2022 GITEM Solutions. All rights reserved.
//

import UIKit
import MarqueeLabel

class DatabaseEditViewController: UIViewController {
    
    @IBOutlet weak var keyStackView: UIStackView!
    @IBOutlet weak var valueStackView: UIStackView!
    @IBOutlet weak var keyLabel: MarqueeLabel!
    @IBOutlet weak var valueLabel: MarqueeLabel!
    @IBOutlet weak var keyTextfield: UITextField! {
        didSet {
            let placeholderText = NSAttributedString(string: "key",
                                                     attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray.withAlphaComponent(0.4)])
            
            keyTextfield.attributedPlaceholder = placeholderText
        }
    }
    @IBOutlet weak var valueTextField: UITextField! {
        didSet {
            let placeholderText = NSAttributedString(string: "value",
                                                     attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray.withAlphaComponent(0.4)])
            
            valueTextField.attributedPlaceholder = placeholderText
        }
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
            Utilities.styleTextField(keyTextfield)
            addBottomLineToText(keyTextfield)
        
        Utilities.styleTextField(valueTextField)
        addBottomLineToText(valueTextField)
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
