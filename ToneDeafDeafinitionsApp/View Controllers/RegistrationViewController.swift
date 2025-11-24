//
//  RegistrationViewController.swift
//  ToneDeafDeafinitionsApp
//
//  Created by Tone Deaf on 7/26/20.
//  Copyright © 2020 GITEM Solutions. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import NotificationBannerSwift
import TTGSnackbar

class RegistrationViewController: UIViewController {

    @IBOutlet weak var textFieldEmail: UITextField! {
        didSet {
            let placeholderText = NSAttributedString(string: "E-Mail",
                                                        attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray.withAlphaComponent(0.4)])
            
            textFieldEmail.attributedPlaceholder = placeholderText
        }
    }
    @IBOutlet weak var textFieldPassword: UITextField! {
        didSet {
            let placeholderText = NSAttributedString(string: "Password",
                                                        attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray.withAlphaComponent(0.4)])
            
            textFieldPassword.attributedPlaceholder = placeholderText
        }
    }
    @IBOutlet weak var textFieldConfirm: UITextField! {
        didSet {
            let placeholderText = NSAttributedString(string: "Confirm",
                                                     attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray.withAlphaComponent(0.4)])
            
            textFieldConfirm.attributedPlaceholder = placeholderText
        }
    }
    @IBOutlet weak var textfieldMobileNumber: UITextField! {
        didSet {
            let placeholderText = NSAttributedString(string: "Mobile Number (Optional)",
                                                        attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray.withAlphaComponent(0.4)])
            
            textfieldMobileNumber.attributedPlaceholder = placeholderText
        }
    }
    @IBOutlet weak var whyNumberButton: UIButton!
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var backToLoginButton: UIButton!
    @IBOutlet weak var scrollview: UIScrollView!
    @IBOutlet var whyNumberPopOver: UIView!
    
    var adminTimer:Timer!
    var admincount = false
    
    var acc = UserDefaults.standard.object(forKey: "accType") as? String
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tap = UITapGestureRecognizer(target: self, action: #selector(adminButtonTapped))
            tap.numberOfTapsRequired = 10
        tap.numberOfTouchesRequired = 2
            view.addGestureRecognizer(tap)
        guard let acc = acc else {
            print("No AccountType linked.")
            return
        }
        print("📙 acctype: \(acc)")
        // Do any additional setup after loading the view.
        setUpElements()
        dismissKeyboardOnTap()
        //navigationController?.navigationBar.isHidden = false
    }
    
    func setUpElements() {
        //Style Elements
        Utilities.styleTextField(textFieldPassword)
        Utilities.styleTextField(textFieldEmail)
        Utilities.styleTextField(textFieldConfirm)
        Utilities.styleTextField(textfieldMobileNumber)
        Utilities.styleFilledButton(registerButton)
        addBottomLineToText(textFieldEmail)
        addBottomLineToText(textFieldPassword)
        addBottomLineToText(textFieldConfirm)
        addBottomLineToText(textfieldMobileNumber)
        textFieldEmail.setLeftIcon(UIImage(named: "mail")!)
        textFieldPassword.setLeftIcon(UIImage(named: "password")!)
        textFieldConfirm.setLeftIcon(UIImage(named: "password")!)
        textfieldMobileNumber.setLeftIcon(UIImage(named: "smartphone")!)
        textFieldPassword.delegate = self
        textFieldEmail.delegate = self
        textfieldMobileNumber.delegate = self
        textFieldConfirm.delegate = self
        
        whyNumberPopOver.layer.cornerRadius = 10
    }
    
    @objc func adminButtonTapped() {
        print("taped admin")
        var adminkey = ""
        Database.database().reference().child("Admin Key").observeSingleEvent(of: .value, with: { snap in
            adminkey = snap.value as! String
        })
        alertController = UIAlertController(title: "Admin Key",
                                                message: "Please typie in your admin key code.",
                                                preferredStyle: .alert)

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        { (action) in
            // ...
        }
        let okAction = UIAlertAction(title: "Verify", style: .default, handler: {[weak self] _ in
            guard let strongSelf = self else {return}
            let answer = alertController.textFields![0]
            if answer.text == adminkey {
                strongSelf.registerButton.setTitle("Admin Register", for: .normal)
                alertController.dismiss(animated: true, completion: nil)
                strongSelf.adminTimer = Timer.scheduledTimer(timeInterval: 30.0, target: strongSelf, selector: #selector(strongSelf.admintimerset), userInfo: nil, repeats: false)
                strongSelf.admincount = true
                strongSelf.view.layoutSubviews()
            } else {
                alertController.dismiss(animated: true, completion: nil)
            }
        })
        alertController.addAction(cancelAction)
        alertController.addAction(okAction)
        alertController.addTextField()

//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        let vc3 = storyboard.instantiateViewController(identifier: "adminKeyVerification") as AdminKeyVerification
//        vc3.preferredContentSize = CGSize(width: 300, height: 300) // 4 default cell heights.
//        alertController.setValue(vc3, forKey: "contentViewController")
        alertController.view.tintColor = UIColor.init(red: 182/255, green: 0/255, blue: 3/255, alpha: 1)
        self.present(alertController, animated: true)
        {
            // ...
        }
    }
    
    @objc func admintimerset() {
        admincount = false
        registerButton.setTitle("Register", for: .normal)
        view.layoutSubviews()
        adminTimer.invalidate()
        adminTimer = nil
    }
    
    @IBAction func whyNumberTapped(_ sender: Any) {
        view.addSubview(whyNumberPopOver)
        whyNumberPopOver.center = self.view.center
    }
    
    @IBAction func gotItButton(_ sender: Any) {
        whyNumberPopOver.removeFromSuperview()
    }
    
    @IBAction func toLoginTapped(_ sender: Any) {
        _ = navigationController?.popViewController(animated: true)
    }
    @IBAction func registerTapped(_ sender: Any) {
        validateCredentials()
    }
    
    func validateCredentials() {
        textFieldEmail.resignFirstResponder()
        textfieldMobileNumber.resignFirstResponder()
        textFieldConfirm.resignFirstResponder()
        textFieldPassword.resignFirstResponder()
        
        if textFieldEmail.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            Utilities.showError2("E-Mail required", actionText: "OK")
            return
        }
        if textFieldPassword.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            Utilities.showError2("Password required.", actionText: "OK")
            return
        }
        if textFieldConfirm.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            Utilities.showError2("Password confirmation required.", actionText: "OK")
            return
        }
        if textFieldConfirm.text != textFieldPassword.text {
            Utilities.showError2("Passwords must match.", actionText: "OK")
            return
        }
        else{
            let email = textFieldEmail.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let password = textFieldPassword.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let phone = textfieldMobileNumber.text!.trimmingCharacters(in: .whitespacesAndNewlines)
                           
            createUser(withEmail: email, password: password, phone: phone)
        }
        
    }
    
    
    
    func createUser(withEmail email: String, password: String, phone: String) {
        let user = Auth.auth().currentUser
        if user != nil {
            
            DatabaseManager.shared.checkMemberEmail(with: email, completion: { [weak self] exist in
                guard let strongSelf = self else {return}
                if !exist {
                    strongSelf.registerAndAuthenticate(email, password, phone)
                } else {
                    Utilities.showError2("Email alreay registered.", actionText: "OK")
                    return
                }
            })
        } else {
            fatalError()
            print("📕📕📕📕📕 close app now")
    }
        
}
    
    fileprivate func registerAndAuthenticate(_ email: String, _ password: String, _ phone: String) {
        let credential = EmailAuthProvider.credential(withEmail: email, password: password)
        Auth.auth().currentUser?.link(with: credential, completion: { [weak self] (result, error) in
            guard let strongSelf = self else {
                return
            }
            
            if let x = error {
                let err = x as NSError
                switch err.code {
                case AuthErrorCode.wrongPassword.rawValue:
                    return Utilities.showError2("Password invalid", actionText: "OK")
                case AuthErrorCode.invalidEmail.rawValue:
                    return Utilities.showError2("E-Mail invalid", actionText: "OK")
                case AuthErrorCode.accountExistsWithDifferentCredential.rawValue:
                    return Utilities.showError2("Account", actionText: "OK")
                case AuthErrorCode.emailAlreadyInUse.rawValue:
                    return Utilities.showError2("Account with that e-Mail address already exists.", actionText: "Ok")
                default:
                    return Utilities.showError2(err.localizedDescription, actionText: "OK")
                }
                //return
            }
            else {
                if strongSelf.admincount == true {
                    accountType = AdminAccount
                    UserDefaults.standard.set(accountType, forKey: "accType")
                    let newAcc = UserDefaults.standard.object(forKey: "accType") as? String
                                            let modelName = UIDevice.modelName
                                            let name = ""
                                            guard let acc = newAcc else {
                                           print("No AccountType linked.")
                                           return
                                       }
                    print("📙 updated acctype: \(acc)")
                    
                                            guard let uid = result?.user.uid else { return }
                    //get anonymous cart, plays and favorites, braintreeId, downloads
                                          //delete anonymous
                                      Database.database().reference().child("Users").child(uid).removeValue()
                                      //place anonymous cart, plays and favorites
                                            
                                            let values = ["Email": email,
                                                          "Phone Number":phone,
                                                          "Current Device Model": modelName,
                                                          "Full Name": name,
                                                          "Account Type": AdminAccount,
                                                          "uid": uid,
                                                          "Facebook Account Connected": "No",
                                                          "Google Account Connected": "No",
                                                          "Apple Account Connected": "No",
                                                          "Twitter Account Connected": "No"]
                                            
                    currentAppUser.accountType = AdminAccount
                    currentAppUser.currentDevice = modelName
                    currentAppUser.email = email
                    currentAppUser.phone = phone
                    currentAppUser.name = name
                    currentAppUser.uid = uid
                    
                                            Database.database().reference().child("Users").child(uid).updateChildValues(values, withCompletionBlock: { (error, ref) in
                                                if let error = error {
                                                    print("Failed to update database values with error: ", error.localizedDescription)
                                                    Utilities.showError2("Internal error, please try again.", actionText: "Ok")
                                                    return
                                                }
                                                strongSelf.transitionToAdminDashboard()
                                                Utilities.successBarBanner("Sign Up successful.")
                                            })
                } else {
                    let actionSheet = UIAlertController(title: "Account Type", message: "Artist accounts will require verification.", preferredStyle: .actionSheet)
                    actionSheet.addAction(UIAlertAction(title: "Listener", style: .default, handler: {_ in
                        accountType = "Listener"
                        UserDefaults.standard.set(accountType, forKey: "accType")
                        let newAcc = UserDefaults.standard.object(forKey: "accType") as? String
                                                let modelName = UIDevice.modelName
                                                let name = ""
                                                guard let acc = newAcc else {
                                               print("No AccountType linked.")
                                               return
                                           }
                        print("📙 updated acctype: \(acc)")
                        
                                                guard let uid = result?.user.uid else { return }
                        //get anonymous cart, plays and favorites, braintreeId, downloads
                                              //delete anonymous
                                          Database.database().reference().child("Users").child(uid).removeValue()
                                          //place anonymous cart, plays and favorites
                                                
                                                let values = ["Email": email,
                                                              "Phone Number":phone,
                                                              "Current Device Model": modelName,
                                                              "Full Name": name,
                                                              "Account Type": ListenerAccount,
                                                              "uid": uid,
                                                              "Facebook Account Connected": "No",
                                                              "Google Account Connected": "No",
                                                              "Apple Account Connected": "No",
                                                              "Twitter Account Connected": "No"]
                                                
                        currentAppUser.accountType = ListenerAccount
                        currentAppUser.currentDevice = modelName
                        currentAppUser.email = email
                        currentAppUser.phone = phone
                        currentAppUser.name = name
                        currentAppUser.uid = uid
                        
                                                Database.database().reference().child("Users").child(uid).updateChildValues(values, withCompletionBlock: { (error, ref) in
                                                    if let error = error {
                                                        print("Failed to update database values with error: ", error.localizedDescription)
                                                        Utilities.showError2("Internal error, please try again.", actionText: "Ok")
                                                        return
                                                    }
                                                    strongSelf.transitionToDashboard()
                                                    Utilities.successBarBanner("Sign Up successful.")
                                                })
                                                    
                    }))
                    actionSheet.addAction(UIAlertAction(title: "Creator",
                                                        style: .default,
                                                  handler: {_ in
                        accountType = "Creator"
                        UserDefaults.standard.set(accountType, forKey: "accType")
                                                    let newAcc = UserDefaults.standard.object(forKey: "accType") as? String
                                                         let modelName = UIDevice.modelName
                                                         let name = ""
                                                         guard let acc = newAcc else {
                                                        print("No AccountType linked.")
                                                        return
                                                    }
                        guard let uid = result?.user.uid else { return}
                        print("📙 updated acctype: \(acc)")
                                                    
                                                    //get anonymous cart, plays and favorites, braintreeId, downloads
                            //delete anonymous
                        Database.database().reference().child("Users").child(uid).removeValue()
                                                    //place anonymous cart, plays and favorites
                                                    let values = ["Email": email,
                                                                  "Phone Number":phone,
                                                                  "Current Device Model": modelName,
                                                                  "Full Name": name,
                                                                  "Account Type": CreatorAccount,
                                                                  "uid": uid,
                                                                  "Facebook Account Connected": "No",
                                                                  "Google Account Connected": "No",
                                                                  "Apple Account Connected": "No",
                                                                  "Twitter Account Connected": "No"]
                                                    currentAppUser.accountType = CreatorAccount
                                                    currentAppUser.currentDevice = modelName
                                                    currentAppUser.email = email
                                                    currentAppUser.phone = phone
                                                    currentAppUser.name = name
                                                    currentAppUser.uid = uid
                                                    
                                                    Database.database().reference().child("Users").child(uid).updateChildValues(values, withCompletionBlock: { (error, ref) in
                                                        if let error = error {
                                                            print("Failed to update database values with error: ", error.localizedDescription)
                                                            Utilities.showError2("Internal error, please try again.", actionText: "Ok")
                                                            return
                            }
                            strongSelf.transitionToDashboard()
                            Utilities.successBarBanner("Sign Up successful.")
                        })

                    }))
                    actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                    
                    self?.present(actionSheet, animated: true)
                }
                
            }
        })
        
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
            let tap = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
            tap.cancelsTouchesInView = false
            view.addGestureRecognizer(tap)
            scrollview.keyboardDismissMode = .onDrag
        }
    
    func transitionToDashboard() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let dashboardTabBarController = storyboard.instantiateViewController(identifier: "dashboardTabBarController")
        (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(dashboardTabBarController)
    }
    
    func transitionToAdminDashboard() {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let adminDashboardNavBarController = storyboard.instantiateViewController(identifier: "adminDashboardNavigationController")
            (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(adminDashboardNavBarController)
        }


}

extension RegistrationViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == textFieldEmail {
            textFieldPassword.becomeFirstResponder()
        }
        else if textField == textFieldPassword {
            textFieldConfirm.becomeFirstResponder()
        }
        else if textField == textFieldConfirm {
            textfieldMobileNumber.becomeFirstResponder()
        }
        else if textField == textfieldMobileNumber {
            validateCredentials()
        }
        
        return true
    }
}
