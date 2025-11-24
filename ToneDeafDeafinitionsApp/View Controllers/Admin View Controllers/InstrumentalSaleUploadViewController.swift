//
//  InstrumentalSaleUploadViewController.swift
//  ToneDeafDeafinitionsApp
//
//  Created by Tone Deaf on 10/29/20.
//  Copyright © 2020 GITEM Solutions. All rights reserved.
//

import UIKit
import FirebaseDatabase

class InstrumentalSaleUploadViewController: UIViewController {
    
    @IBOutlet weak var instrumentalsTextField: UITextField! {
        didSet {
            let placeholderText = NSAttributedString(string: "Select Instrumental",
                                                        attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray.withAlphaComponent(0.4)])
            
            instrumentalsTextField.attributedPlaceholder = placeholderText
        }
    }
    @IBOutlet weak var priceTextField: CurrencyTextField! {
        didSet {
            let placeholderText = NSAttributedString(string: "Price",
                                                        attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray.withAlphaComponent(0.4)])
            
            priceTextField.attributedPlaceholder = placeholderText
        }
    }
    @IBOutlet weak var quantityTextField: UITextField! {
        didSet {
            let placeholderText = NSAttributedString(string: "Quantity",
                                                        attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray.withAlphaComponent(0.4)])
            
            quantityTextField.attributedPlaceholder = placeholderText
        }
    }
    @IBOutlet weak var uploadButton: UIButton!
    
    var instrumentalsPickerView = UIPickerView()
    var selectedInstrumental:InstrumentalData!
    var chosenInstrumental = ""
    var chosenInstrumentalNames = ""
    var chosenInstrumentalRef = ""
    var iprice:Double?
    var quantity:Int?
    var date:String!
    
    var progressView:UIProgressView!
    var totalProgress:Float = 3
    var progressCompleted:Float = 0
    var alertView:UIAlertController!
    
    var uploadCompletionStatus1:Bool!
    var uploadCompletionStatus2:Bool!
    var uploadCompletionStatus3:Bool!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dismissKeyboardOnTap()
        DatabaseManager.shared.fetchAllInstrumentalsFromDatabase(completion: { instrumental in
            AllInstrumentalsInDatabaseArray = instrumental
        })
        Utilities.styleTextField(priceTextField)
        addBottomLineToText(priceTextField)
        priceTextField.keyboardType = .numberPad
        
        Utilities.styleTextField(quantityTextField)
        addBottomLineToText(quantityTextField)
        quantityTextField.keyboardType = .numberPad
        
        Utilities.styleTextField(instrumentalsTextField)
        addBottomLineToText(instrumentalsTextField)
        instrumentalsTextField.inputView = instrumentalsPickerView
        instrumentalsPickerView.delegate = self
        instrumentalsPickerView.dataSource = self
        pickerViewToolbar(textField: instrumentalsTextField, pickerView: instrumentalsPickerView)
    }
    
    @IBAction func uploadTapped(_ sender: Any) {
        date = getCurrentLocalDate()
        if priceTextField.text != "" && priceTextField.text != "$0.00"{
            if let price = Double(priceTextField.text!.replacingOccurrences(of: "$", with: "")) {
                iprice = price
            }
        }
        if quantityTextField.text != "" {
            if let quan = Int(quantityTextField.text!) {
                quantity = quan
            }
        }
        alertView = UIAlertController(title: "Uploading \(chosenInstrumentalNames)", message: "Preparing...", preferredStyle: .alert)
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
            strongSelf.gatherUpload()
        })
    }
    
    func gatherUpload() {
        let queue = DispatchQueue(label: "myhjvkinstr saleSethQkitssssseue")
        let group = DispatchGroup()
        let array = [1,2,3]

        for i in array {
            print(i)
            group.enter()
            queue.async { [weak self] in
                guard let strongSelf = self else {return}
                switch i {
                case 1:
                    //print("null")
                    strongSelf.setStoreInfo(completion: {[weak self] done in
                        guard let strongSelf = self else {return}
                        if done == false {
                            Utilities.showError2("Store Info Storing Failed.", actionText: "OK")
                            strongSelf.uploadCompletionStatus1 = false
                        }
                        else {
                            strongSelf.uploadCompletionStatus1 = true
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
                    strongSelf.updateProducers(completion: {[weak self] done in
                        guard let strongSelf = self else {return}
                        if done == false {
                            Utilities.showError2("Producer Updating Failed.", actionText: "OK")
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
                case 3:
                    //print("null")
                    strongSelf.updateArtists(completion: {[weak self] done in
                        guard let strongSelf = self else {return}
                        if done == false {
                            Utilities.showError2("Artist Updating Failed.", actionText: "OK")
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
                    print("Sale error")
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
                print("📗 Instrumental Sale data saved to database successfully.")
                strongSelf.alertView.dismiss(animated: true, completion: {
                    Utilities.successBarBanner("Upload successful.")
                    _ = strongSelf.navigationController?.popViewController(animated: true)
                })
            }
        }
        
        
        
        
        
    }
    
    func setStoreInfo(completion: @escaping ((Bool) -> Void)) {
        let ref = Database.database().reference().child("Music Content").child("Instrumentals").child(chosenInstrumentalRef).child("Store Info")
        var RequiredInfoMa = [String : Any]()
        RequiredInfoMa = [
            "Number of Purchases" : 0,
            "Date Uploaded": date!,
            "Merch Type": "Instrumental",
            "Quantity": quantity as Any,
            "Retail Price": iprice as Any
        ]
        
        ref.updateChildValues(RequiredInfoMa) {[weak self] (error, songRef) in
            guard let strongSelf = self else {return}
            if let error = error {
                print("📕 Failed to upload dictionary to database: \(error)")
                completion(false)
                return
            } else {
                Database.database().reference().child("Merch").child("\(strongSelf.chosenInstrumental.trimmingCharacters(in: .whitespacesAndNewlines))Æ\(strongSelf.chosenInstrumentalNames.trimmingCharacters(in: .whitespacesAndNewlines))").updateChildValues(RequiredInfoMa)
                completion(true)
                return
            }
        }
    }
    
    func updateProducers(completion: @escaping ((Bool) -> Void)) {
        for pro in selectedInstrumental.producers {
            let word = pro.split(separator: "Æ")
            let id = word[0]
            Database.database().reference().child("Registered Producers").observeSingleEvent(of: .value, with: {[weak self] snapshot in
                guard let strongSelf = self else {return}
                for produce in snapshot.children {
                    let data = produce as! DataSnapshot
                    let key = data.key
                    if key.contains(id) == true {
                        strongSelf.fetchProMerch(cat: key, completion: { merch in
                            var newarr = merch
                            if !newarr.contains("\(strongSelf.chosenInstrumental.trimmingCharacters(in: .whitespacesAndNewlines))Æ\(strongSelf.chosenInstrumentalNames.trimmingCharacters(in: .whitespacesAndNewlines))") {
                                newarr.append("\(strongSelf.chosenInstrumental.trimmingCharacters(in: .whitespacesAndNewlines))Æ\(strongSelf.chosenInstrumentalNames.trimmingCharacters(in: .whitespacesAndNewlines))")
                                Database.database().reference().child("Registered Producers").child(key).child("Merch").setValue(newarr)
                                completion(true)
                            } else {
                                completion(true)
                            }
                        })
                    }
                }
            })
        }
    }
    
    func fetchProMerch(cat: String, completion: @escaping (([String]) -> Void)) {
        let ref = Database.database().reference().child("Registered Producers").child(cat).child("Merch")
        ref.observeSingleEvent(of: .value, with: { snapshot in
            var mysongsArray:[String] = []
            if let val = snapshot.value {
                let valu = val as? [String]
                guard let value = valu else {return}
                if value[0] != "" {
                    mysongsArray = value
                    print("producer merch from db \(mysongsArray)")
                    completion(mysongsArray)
                } else {
                    completion(mysongsArray)
                }
            } else {
                completion(mysongsArray)
            }
        })
    }
    
    func updateArtists(completion: @escaping ((Bool) -> Void)) {
        for pro in selectedInstrumental.artist! {
            let word = pro.split(separator: "Æ")
            let id = word[0]
            Database.database().reference().child("Registered Artists").observeSingleEvent(of: .value, with: {[weak self] snapshot in
                guard let strongSelf = self else {return}
                for produce in snapshot.children {
                    let data = produce as! DataSnapshot
                    let key = data.key
                    if key.contains(id) == true {
                        
                        strongSelf.fetchArtMerch(cat: key, completion: { merch in
                            
                            var newarr = merch
                            if !newarr.contains("\(strongSelf.chosenInstrumental.trimmingCharacters(in: .whitespacesAndNewlines))Æ\(strongSelf.chosenInstrumentalNames.trimmingCharacters(in: .whitespacesAndNewlines))") {
                                newarr.append("\(strongSelf.chosenInstrumental.trimmingCharacters(in: .whitespacesAndNewlines))Æ\(strongSelf.chosenInstrumentalNames.trimmingCharacters(in: .whitespacesAndNewlines))")
                                Database.database().reference().child("Registered Artists").child(key).child("Merch").setValue(newarr)
                                completion(true)
                            } else {
                                completion(true)
                            }
                        })
                    }
                }
            })
        }
    }
    
    func fetchArtMerch(cat: String, completion: @escaping (([String]) -> Void)) {
        let ref = Database.database().reference().child("Registered Artists").child(cat).child("Merch")
        ref.observeSingleEvent(of: .value, with: { snapshot in
            var mysongsArray:[String] = []
            
            if let val = snapshot.value {
                
                let valu = val as? [String]
                guard let value = valu else {
                    completion(mysongsArray)
                    return}
                if value[0] != "" {
                    mysongsArray = value
                    print("artist merch from db \(mysongsArray)")
                    completion(mysongsArray)
                    return
                } else {
                    completion(mysongsArray)
                    return
                }
            } else {
                
                completion(mysongsArray)
                return
            }
        })
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func dismissKeyboardOnTap() {
        let tap = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        //scrollView1.keyboardDismissMode = .onDrag
    }
    
}

extension InstrumentalSaleUploadViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        var number = 0
        number = AllInstrumentalsInDatabaseArray.count
        return number
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        var number = ""
        number = "\(AllInstrumentalsInDatabaseArray[row].instrumentalName ) -- \(AllInstrumentalsInDatabaseArray[row].toneDeafAppId)"
        return number
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedInstrumental = AllInstrumentalsInDatabaseArray[row]
        chosenInstrumentalRef = "\(instrumentalContentType)--\(AllInstrumentalsInDatabaseArray[row].instrumentalName!.replacingOccurrences(of: " (Instrumental)", with: ""))--\(AllInstrumentalsInDatabaseArray[row].dateRegisteredToApp!)--\(AllInstrumentalsInDatabaseArray[row].timeRegisteredToApp!)--\(AllInstrumentalsInDatabaseArray[row].toneDeafAppId)"
        chosenInstrumental = AllInstrumentalsInDatabaseArray[row].toneDeafAppId.trimmingCharacters(in: .whitespacesAndNewlines)
        chosenInstrumentalNames = AllInstrumentalsInDatabaseArray[row].instrumentalName!.trimmingCharacters(in: .whitespacesAndNewlines)
        instrumentalsTextField.text = chosenInstrumentalNames
    }
    
    func pickerViewToolbar(textField:UITextField, pickerView:UIPickerView) {
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor.init(red: 182/255, green: 0/255, blue: 3/255, alpha: 1)
        toolBar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.plain, target: self, action: #selector(dismissKeyboard))
        var cancelButton = UIBarButtonItem()
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
            cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItem.Style.plain, target: self, action: #selector(dismissKeyboard))

        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true

        textField.inputView = pickerView
        textField.inputAccessoryView = toolBar
    }
}
