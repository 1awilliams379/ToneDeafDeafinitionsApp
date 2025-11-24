//
//  ServicesUploadViewController.swift
//  ToneDeafDeafinitionsApp
//
//  Created by Tone Deaf on 10/30/20.
//  Copyright © 2020 GITEM Solutions. All rights reserved.
//

import UIKit
import FirebaseDatabase

class ServicesUploadViewController: UIViewController {
    
    @IBOutlet weak var nameTextField: UITextField! {
        didSet {
            let placeholderText = NSAttributedString(string: "Name",
                                                        attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray.withAlphaComponent(0.4)])
            
            nameTextField.attributedPlaceholder = placeholderText
        }
    }
    @IBOutlet weak var serviceTextField: UITextField! {
        didSet {
            let placeholderText = NSAttributedString(string: "Select Service",
                                                        attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray.withAlphaComponent(0.4)])
            
            serviceTextField.attributedPlaceholder = placeholderText
        }
    }
    @IBOutlet weak var descriptionTextField: UITextView!
    @IBOutlet weak var priceTextField: CurrencyTextField! {
        didSet {
            let placeholderText = NSAttributedString(string: "Price",
                                                        attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray.withAlphaComponent(0.4)])
            
            priceTextField.attributedPlaceholder = placeholderText
        }
    }
    @IBOutlet weak var uploadButton: UIButton!
    
    var date:String!
    var tDAppId:String!
    var servicesPickerView = UIPickerView()
    var chosenService = ""
    var serviceName:String!
    var serviceDescription:String!
    var servicePrice:Double?
    
    var uploadCompletionStatus1:Bool!
    var uploadCompletionStatus2:Bool!
    var uploadCompletionStatus3:Bool!
    
    var toneServices:[String] = ["Mixing","Mastering","Engineering","Custom Beats","Custom Loops"]
    
    var progressView:UIProgressView!
    var totalProgress:Float = 3
    var progressCompleted:Float = 0
    var alertView:UIAlertController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpElements()
        dismissKeyboardOnTap()
    }

    func setUpElements() {
        Utilities.styleTextField(nameTextField)
        addBottomLineToText(nameTextField)
        
        Utilities.styleTextField(serviceTextField)
        addBottomLineToText(serviceTextField)
        serviceTextField.inputView = servicesPickerView
        servicesPickerView.delegate = self
        servicesPickerView.dataSource = self
        pickerViewToolbar(textField: serviceTextField, pickerView: servicesPickerView)
        
        Utilities.styleTextField(priceTextField)
        addBottomLineToText(priceTextField)
        priceTextField.keyboardType = .numberPad
    }
    
    @IBAction func uploadTapped(_ sender: Any) {
        date = getCurrentLocalDate()
        guard nameTextField.text != "" else {
            Utilities.showError2("Name required" ,actionText: "Ok")
            return
        }
        guard serviceTextField.text != "" else {
            Utilities.showError2("Service required"  ,actionText: "Ok")
            return
        }
        guard descriptionTextField.text != "" else {
            Utilities.showError2("Description required"  ,actionText: "Ok")
            return
        }
        if priceTextField.text != "" && priceTextField.text != "$0.00"{
            if let price = Double(priceTextField.text!.replacingOccurrences(of: "$", with: "")) {
                servicePrice = price
            }
        }
        serviceName = nameTextField.text!
        serviceDescription = descriptionTextField.text!
        alertView = UIAlertController(title: "Uploading \(serviceName!)", message: "Preparing...", preferredStyle: .alert)
        alertView.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alertView.view.tintColor = Constants.Colors.redApp
        //  Show it to your users
        present(alertView, animated: true, completion: { [weak self] in
            guard let strongSelf = self else {return}
            //  Add your progressbar after alert is shown (and measured)
            let margin:CGFloat = 8.0
            let rect = CGRect(x: margin, y: 72.0, width: strongSelf.alertView.view.frame.width - margin * 2.0 , height: 1.5)
            strongSelf.progressView = UIProgressView(frame: rect)
            strongSelf.progressView.alpha = 0
            strongSelf.progressView!.progress = 0
            strongSelf.progressView!.tintColor = Constants.Colors.redApp
            strongSelf.alertView.view.addSubview(strongSelf.progressView!)
            UIView.animate(withDuration: 0.2, animations: {
                strongSelf.progressView.alpha = 1
                strongSelf.view.layoutSubviews()
            })
            strongSelf.generateAppId()
        })
    }
    
    func generateAppId() {
        let genid = StorageManager.shared.generateRandomNumber(digits: 20)
        DatabaseManager.shared.checkIfAppIdExists(appid: genid, completion: { [weak self] result in
            guard let strongSelf = self else {return}
            if result == true {
                strongSelf.generateAppId()
            } else {
                strongSelf.uploadCompletionStatus1 = true
                strongSelf.progressCompleted+=1
                strongSelf.progressView.progress = (strongSelf.progressCompleted/strongSelf.totalProgress)
                print("\(strongSelf.progressCompleted) out of \(strongSelf.totalProgress)")
                strongSelf.tDAppId = genid
                strongSelf.gatherUploadData()
            }
        })
    }
    
    func gatherUploadData() {
        let queue = DispatchQueue(label: "myhjvkhQkitssssseue")
        let group = DispatchGroup()
        let array = [1,2]

        for i in array {
            print(i)
            group.enter()
            queue.async { [weak self] in
                guard let strongSelf = self else {return}
                switch i {
                case 1:
                    //print("null")
                    strongSelf.storeService(completion: {[weak self] done in
                        guard let strongSelf = self else {return}
                        if done == false {
                            Utilities.showError2("Service DB Storing Failed.", actionText: "OK")
                            strongSelf.uploadCompletionStatus2 = false
                        }
                        else {
                            strongSelf.uploadCompletionStatus2 = true
                            strongSelf.progressCompleted+=1
                            DispatchQueue.main.async {
                                strongSelf.progressView.progress = (strongSelf.progressCompleted/strongSelf.totalProgress)
                                print("\(strongSelf.progressCompleted) out of \(strongSelf.totalProgress)")
                                
                            }
                            print("done \(i)")
                        }
                        group.leave()
                    })
                case 2:
                    //print("null")
                    strongSelf.updateTone(completion: {[weak self] done in
                        guard let strongSelf = self else {return}
                        if done == false {
                            Utilities.showError2("Tone Update Failed.", actionText: "OK")
                            strongSelf.uploadCompletionStatus3 = false
                        }
                        else {
                            strongSelf.uploadCompletionStatus3 = true
                            strongSelf.progressCompleted+=1
                            DispatchQueue.main.async {
                                strongSelf.progressView.progress = (strongSelf.progressCompleted/strongSelf.totalProgress)
                                print("\(strongSelf.progressCompleted) out of \(strongSelf.totalProgress)")
                                
                            }
                            print("done \(i)")
                        }
                        group.leave()
                    })
                default:
                    print("Kit error")
                }
            }
        }
        
        group.notify(queue: DispatchQueue.main) { [weak self] in
            guard let strongSelf = self else {return}
            if strongSelf.uploadCompletionStatus1 == false || strongSelf.uploadCompletionStatus2 == false || strongSelf.uploadCompletionStatus3 == false {
                strongSelf.alertView.dismiss(animated: true, completion: nil)
                Utilities.showError2("Upload Failed.", actionText: "OK")
                return
            } else {
                print("📗 Service data saved to database successfully.")
                strongSelf.alertView.dismiss(animated: true, completion: {
                    Utilities.successBarBanner("Upload successful.")
                    _ = strongSelf.navigationController?.popViewController(animated: true)
                })
            }
        }
    }
    
    func storeService(completion: @escaping ((Bool) -> Void)) {
        DispatchQueue.main.async {[weak self] in
            guard let strongSelf = self else {return}
            
            var RequiredInfoMa = [String : Any]()
            RequiredInfoMa = [
                "Tone Deaf App Id" : strongSelf.tDAppId!,
                "Name" : strongSelf.serviceName!,
                "Description" : strongSelf.serviceDescription!,
                "Retail Price" : strongSelf.servicePrice as Any,
                "Number of Favorites" : 0,
                "Number of Purchases" : 0,
                "Date Uploaded": strongSelf.date!,
                "Merch Type": "Service",
                "Service Type": strongSelf.chosenService
            ]

            let RequiredRef = Database.database().reference().child("Merch").child("\(strongSelf.tDAppId!)Æ\(strongSelf.serviceName!)")
            RequiredRef.updateChildValues(RequiredInfoMa) { (error, songRef) in
                if let error = error {
                    print("📕 Failed to upload dictionary to database: \(error)")
                    completion(false)
                    return
                } else {
                    Database.database().reference().child("All Content IDs") .observeSingleEvent(of: .value, with: {[weak self] snap in
                        guard let strongSelf = self else {return}
                        var arr = snap.value as! [String]
                        if !arr.contains("\(strongSelf.tDAppId!)Æ\(strongSelf.serviceName!)") {
                            arr.append("\(strongSelf.tDAppId!)Æ\(strongSelf.serviceName!)")
                        }
                        Database.database().reference().child("All Content IDs").setValue(arr)
                        completion(true)
                    })
                }
            }
        }
    }
    
    func updateTone(completion: @escaping ((Bool) -> Void)) {
        let ref = Database.database().reference().child("Registered Producers").child("Tone Deaf--October 08, 2020--12:44:36 PM--89377").child("Merch")
        ref.observeSingleEvent(of: .value, with: {[weak self] snap in
            guard let strongSelf = self else {return}
            var newArr:[String] = []
            if let val = snap.value as? [String] {
                newArr = val
                if !newArr.contains("\(strongSelf.tDAppId!)Æ\(strongSelf.serviceName!)") {
                    newArr.append("\(strongSelf.tDAppId!)Æ\(strongSelf.serviceName!)")
                }
                ref.setValue(newArr)
                    Database.database().reference().child("Merch").child("\(strongSelf.tDAppId!)Æ\(strongSelf.serviceName!)").child("Producers").setValue(["89377ÆTone Deaf"])
                    completion(true)
            } else {
                if !newArr.contains("\(strongSelf.tDAppId!)Æ\(strongSelf.serviceName!)") {
                    newArr.append("\(strongSelf.tDAppId!)Æ\(strongSelf.serviceName!)")
                }
                ref.setValue(newArr)
                Database.database().reference().child("Merch").child("\(strongSelf.tDAppId!)Æ\(strongSelf.serviceName!)").child("Producers").setValue(["89377ÆTone Deaf"])
                completion(true)
            }
        })
    }
    
    func dismissKeyboardOnTap() {
        let tap = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        //scrollView1.keyboardDismissMode = .onDrag
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

extension ServicesUploadViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        var number = 0
            number = toneServices.count
        return number
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        var number = ""
            number = toneServices[row]
        return number
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
       
            chosenService = toneServices[row]
            serviceTextField.text = toneServices[row]
    }
    
    func pickerViewToolbar(textField:UITextField, pickerView:UIPickerView) {
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor.init(red: 182/255, green: 0/255, blue: 3/255, alpha: 1)
        toolBar.sizeToFit()
        var doneButton = UIBarButtonItem()
        var cancelButton = UIBarButtonItem()
        doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.done, target: self, action: #selector(dismissKeyboard))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItem.Style.plain, target: self, action: #selector(dismissKeyboard))
        
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        textField.inputView = pickerView
        textField.inputAccessoryView = toolBar
    }
}
