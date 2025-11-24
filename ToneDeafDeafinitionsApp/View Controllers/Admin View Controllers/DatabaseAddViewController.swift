//
//  DatabaseAddViewController.swift
//  ToneDeafDeafinitionsApp
//
//  Created by Tone Deaf on 7/6/22.
//  Copyright © 2022 GITEM Solutions. All rights reserved.
//

import UIKit
import MarqueeLabel
import BEMCheckBox

class DatabaseAddViewController: UIViewController {

    @IBOutlet weak var keyStackView: UIStackView!
    @IBOutlet weak var valueStackView: UIStackView!
    @IBOutlet weak var pairStackView: UIStackView!
    @IBOutlet weak var nodeStackView: UIStackView!
    @IBOutlet weak var nodeTextfield: UITextField! {
        didSet {
            let placeholderText = NSAttributedString(string: "node",
                                                     attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray.withAlphaComponent(0.4)])
            
            nodeTextfield.attributedPlaceholder = placeholderText
        }
    }
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
    @IBOutlet weak var keyValueCheckbox: BEMCheckBox!
    @IBOutlet weak var nodeCheckbox: BEMCheckBox!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
            Utilities.styleTextField(keyTextfield)
            addBottomLineToText(keyTextfield)
        
        Utilities.styleTextField(valueTextField)
        addBottomLineToText(valueTextField)
        
        Utilities.styleTextField(nodeTextfield)
        addBottomLineToText(nodeTextfield)
        
    }
    
    
    
    @IBAction func keyValueTapped(_ sender: Any) {
        if !keyValueCheckbox.on {
            keyValueCheckbox.on = true
            nodeCheckbox.on = false
            nodeStackView.isHidden = true
        } else {
            nodeCheckbox.on = false
            nodeStackView.isHidden = true
        }
    }
    
    @IBAction func nodeTapped(_ sender: Any) {
        if !nodeCheckbox.on {
            nodeCheckbox.on = true
            keyValueCheckbox.on = false
            nodeStackView.isHidden = false
        } else {
            nodeStackView.isHidden = false
            keyValueCheckbox.on = false
        }
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
