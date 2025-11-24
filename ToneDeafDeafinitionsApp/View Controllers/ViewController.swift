//
//  ViewController.swift
//  ToneDeafDeafinitionsApp
//
//  Created by Tone Deaf on 7/26/20.
//  Copyright © 2020 GITEM Solutions. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import TTGSnackbar
import FBSDKLoginKit
import FBSDKCoreKit
import GoogleSignIn

class ViewController: UIViewController {
    
    // MARK: - Initilizers
    
    @IBOutlet weak var scrollview: UIScrollView!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var textFieldEMail: UITextField! {
        didSet {
            let placeholderText = NSAttributedString(string: "E-Mail",
                                                        attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray.withAlphaComponent(0.4)])
            
            textFieldEMail.attributedPlaceholder = placeholderText
        }
    }
    @IBOutlet weak var passwordTextField: UITextField! {
        didSet {
            let placeholderText = NSAttributedString(string: "Password",
                                                        attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray.withAlphaComponent(0.4)])
            
            passwordTextField.attributedPlaceholder = placeholderText
        }
    }
    @IBOutlet weak var forgotPassword: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var register: UIButton!
    @IBOutlet weak var guestLogin: UIButton!
    @IBOutlet weak var fbLogin: FBLoginButton!
    @IBOutlet weak var googleLoginButton: GIDSignInButton!
    
    var adminTimer:Timer!
    var admincount = false
    
    static let shared = ViewController()
    var uid = Auth.auth().currentUser?.uid
    let acc = UserDefaults.standard.object(forKey: "accType") as? String
    
    private var loginObserver: NSObjectProtocol?
    
    
    // MARK: - View Set Up
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tap = UITapGestureRecognizer(target: self, action: #selector(adminButtonTapped))
            tap.numberOfTapsRequired = 10
        tap.numberOfTouchesRequired = 2
            view.addGestureRecognizer(tap)
        loginObserver = NotificationCenter.default.addObserver(forName: .didLogInNotification,
                                               object: nil,
                                               queue: .main,
                                               using: { [weak self] _ in
                                                guard let strongSelf = self else {
                                                    return
                                                }
                                                strongSelf.transitionToDashboard()
                                                
        })
        setUpElements()
        dismissKeyboardOnTap()
    }
    
    @objc func adminButtonTapped() {
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
                strongSelf.loginButton.setTitle("Admin Login", for: .normal)
                alertController.dismiss(animated: true, completion: nil)
                strongSelf.adminTimer = Timer.scheduledTimer(timeInterval: 60.0, target: strongSelf, selector: #selector(strongSelf.admintimerset), userInfo: nil, repeats: false)
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
        loginButton.setTitle("Login", for: .normal)
        view.layoutSubviews()
        adminTimer.invalidate()
        adminTimer = nil
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        guard let acc = acc else {
            print("No AccountType linked.")
            return
        }
        print("📙 acctype: \(acc)")
        if acc == "Anonymous" {
            guestLogin.isEnabled = false
            guestLogin.isHidden = true
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
        
    }
    
    func setUpElements() {
        //Style Elements
        Utilities.styleTextField(passwordTextField)
        Utilities.styleTextField(textFieldEMail)
        Utilities.styleFilledButton(loginButton)
        addBottomLineToText(textFieldEMail)
        addBottomLineToText(passwordTextField)
        textFieldEMail.setLeftIcon(UIImage(named: "mail")!)
        passwordTextField.setLeftIcon(UIImage(named: "password")!)
        passwordTextField.delegate = self
        textFieldEMail.delegate = self
        fbLogin.delegate = self
        
        GIDSignIn.sharedInstance()?.presentingViewController = self
        
//        if let token = AccessToken.current,
//            !token.isExpired {
//            transitionToDashboard()
//        }

        fbLogin.permissions = ["public_profile", "email"]
        
    }
    
    deinit {
        print("View Controller being deallocated from memory. OS reclaiming")
        if let observer = loginObserver {
            NotificationCenter.default.removeObserver(observer)
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK: - Tapped Actions
    
    @IBAction func forgotPasswordTapped(_ sender: Any) {
    }
    
    @IBAction func loginTapped(_ sender: Any) {
         validateCredentials()
    }
    
    @IBAction func registerTapped(_ sender: Any) {
        //performSegue(withIdentifier: "toRegistration", sender: register)
    }
    
    @IBAction func guestLoginTapped(_ sender: Any) {
        //signInAnnonymously()
    }
    
    // MARK: - Sign In
    
    func validateCredentials() {
        
        textFieldEMail.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        
        if textFieldEMail.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            Utilities.showError2("E-Mail is required.", actionText: "OK")
        }
        if passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            Utilities.showError2("Password is required.", actionText: "OK")
        }
        else{
            let email = textFieldEMail.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
                           
            logUserIn(withEmail: email, password: password)
        }
        
        
    }
    
    func logUserIn(withEmail email: String, password: String) {
        anonymousLogOut()
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] result, error in
            guard let strongSelf = self else {
                return
            }
            if let x = error {
                let err = x as NSError
                switch err.code {
                case AuthErrorCode.wrongPassword.rawValue:
                    Utilities.showError2("Invalid password.", actionText: "OK")
                    return
                case AuthErrorCode.invalidEmail.rawValue:
                    Utilities.showError2("Invalid email.", actionText: "OK")
                    return
                default:
                    Utilities.showError2("Error: \(err.localizedDescription)", actionText: "OK")
                    return
                }
            }
            else {
                guard let currUser = result?.user else {
                    return
                }
                guard let currUID = result?.user.uid else {
                    return
                }
                
                guard let result = result else {
                    print("Account sign in mishap. in result")
                    return
                }
                
                DatabaseManager.shared.getUserData(with: currUID, completion: { user in
                    currentAppUser = user
                    accountType = user.accountType
                    if accountType == AdminAccount {
                        DashboardTabBarViewController.shared.AccountStatusDelegate.accountTypeChanged(acctype: accountType, user: currUser, uid: currUID)
                        strongSelf.updateSignInDatabaseInfoAndSignInAdmin(result: result)
                    } else {
                        DashboardTabBarViewController.shared.AccountStatusDelegate.accountTypeChanged(acctype: accountType, user: currUser, uid: currUID)
                        strongSelf.updateSignInDatabaseInfoAndSignIn(result: result)
                    }
                })
            }
        }
    }
    
    func updateSignInDatabaseInfoAndSignIn(result: AuthDataResult) {
        let modelName = UIDevice.modelName
        
        Database.database().reference().child("Users").child(uid!).removeValue()
        guard let uid = currentUID else {
            return
        }
        let values = ["Current Device Model": modelName]
        
        Database.database().reference().child("Users").child(uid).updateChildValues(values, withCompletionBlock: { [weak self] (error, ref) in
            guard let strongSelf = self else {
                return
            }
        if let error = error {
            print("📕 Failed to update database values with error: ", error.localizedDescription)
         Utilities.showError2("Internal error, please try again.", actionText: "Ok")
            return
        }
        strongSelf.transitionToDashboard()
        Utilities.successBarBanner("Login successful.")
        })
    }
    
    func updateSignInDatabaseInfoAndSignInAdmin(result: AuthDataResult) {
        let modelName = UIDevice.modelName
        let values = ["Current Device Model": modelName]
        
        Database.database().reference().child("Users").child(uid!).removeValue()
        
        guard let uid = currentUID else {
            return
        }
        
        Database.database().reference().child("Users").child(uid).updateChildValues(values, withCompletionBlock: { [weak self] (error, ref) in
            guard let strongSelf = self else {
                return
            }
        if let error = error {
            print("📕 Failed to update database values with error: ", error.localizedDescription)
         Utilities.showError2("Internal error, please try again.", actionText: "Ok")
            return
        }
        strongSelf.transitionToAdminDashboard()
        Utilities.successBarBanner("Login successful.")
        })
    }
    
    public func signInAnnonymously() {
        Auth.auth().signInAnonymously { [weak self] (result, error) in
            guard let strongSelf = self else {
                return
            }
            if let error = error {
                print("📕 \(error.localizedDescription)")
                Utilities.showError2("Failed to sign in anonymously, please try again.", actionText: "Ok")
                return
            }
            
            guard let currUser = result?.user else {
                return
            }
            guard let currUID = result?.user.uid else {
                return
            }
            
            //Update delegate in dashboard tab bar controller of the account type status change
            DashboardTabBarViewController.shared.AccountStatusDelegate.accountTypeChanged(acctype: AnonymousAccount, user: currUser, uid: currUID)
            
            let modelName = UIDevice.modelName
            let uid = Auth.auth().currentUser?.uid
            let values = ["Email": "",
                          "Phone Number": "",
                          "Current Device Model": modelName,
                          "Full Name": "",
                          "Account Type": AnonymousAccount,
                          "uid": uid,
                          "Facebook Account Connected": "No",
                          "Google Account Connected": "No",
                          "Apple Account Connected": "No",
                          "Twitter Account Connected": "No"]
            
            currentAppUser = UserData(accountType: AnonymousAccount, email: "", uid: uid!, name: "", phone: "", appleConnected: false, googleConnected: false, facebookConnected: false, twitterConnected: false, paypalConnected: false, squareConnected: false, spotifyConnected: false, currentDevice: modelName, favorites: [], downloads: [], brainTreeID: nil, brainTreeCT: nil)
            
            
            Database.database().reference().child("Users").child(uid!).updateChildValues(values, withCompletionBlock: { [weak self] (error, ref) in
                guard let strongSelf = self else {
                    return
                }
                if let error = error {
                    print("Failed to update database values with error: ", error.localizedDescription)
                    Utilities.showError2("Internal error, please try again.", actionText: "Ok")
                    return
                }
            })
            print("📗 Anonymous sign in successful")
            //Utilities.successBarBanner("Sign successful.")
        }
    }
    
    public func signInAnnonymously(completion: @escaping () -> Void) {
        Auth.auth().signInAnonymously { [weak self] (result, error) in
            guard let strongSelf = self else {
                return
            }
            if let error = error {
                print("📕 \(error.localizedDescription)")
                Utilities.showError2("Failed to sign in anonymously, please try again.", actionText: "Ok")
                return
            }
            
            guard let currUser = result?.user else {
                return
            }
            guard let currUID = result?.user.uid else {
                return
            }
            
            //Update delegate in dashboard tab bar controller of the account type status change
            DashboardTabBarViewController.shared.AccountStatusDelegate.accountTypeChanged(acctype: AnonymousAccount, user: currUser, uid: currUID)
            
            let modelName = UIDevice.modelName
            let uid = Auth.auth().currentUser?.uid
            let values = ["Email": "",
                          "Phone Number": "",
                          "Current Device Model": modelName,
                          "Full Name": "",
                          "Account Type": AnonymousAccount,
                          "uid": uid,
                          "Facebook Account Connected": "No",
                          "Google Account Connected": "No",
                          "Apple Account Connected": "No",
                          "Twitter Account Connected": "No"]
            
            currentAppUser = UserData(accountType: AnonymousAccount, email: "", uid: uid!, name: "", phone: "", appleConnected: false, googleConnected: false, facebookConnected: false, twitterConnected: false, paypalConnected: false, squareConnected: false, spotifyConnected: false, currentDevice: modelName, favorites: [], downloads: [], brainTreeID: nil, brainTreeCT: nil)
            
            
            Database.database().reference().child("Users").child(uid!).updateChildValues(values, withCompletionBlock: { [weak self] (error, ref) in
                guard let strongSelf = self else {
                    return
                }
                if let error = error {
                    print("Failed to update database values with error: ", error.localizedDescription)
                    Utilities.showError2("Internal error, please try again.", actionText: "Ok")
                    return
                } else {
                    print("📗 Anonymous sign in successful")
                    completion()
                    return
                }
            })
            //Utilities.successBarBanner("Sign successful.")
        }
    }
    
    // MARK: - Sign Out
    
    public func logout() {
            if accountType == AnonymousAccount{
                anonymousLogOut()
            }
            else {
                let user = Auth.auth().currentUser
                FBSDKLoginKit.LoginManager().logOut()
                GIDSignIn.sharedInstance()?.signOut()
                let firebaseAuth = Auth.auth()
                do {
                    try firebaseAuth.signOut()
                    print("📗 User: \(String(describing: uid)) sign out successful")
                    Utilities.successBarBanner("Successfully Signed Out.")
            
                } catch let signOutError as NSError {
                    Utilities.showError2("Error signing out: \(signOutError)"  ,actionText: "Ok")
                    print ("Error signing out: %@", signOutError)
                }
            }
        }
        
    public func anonymousLogOut() {
            let user = Auth.auth().currentUser
        let nuid = user?.uid
        if Auth.auth().currentUser != nil{
            Database.database().reference().child("Users").child(nuid!).removeValue()
        }
            let auth = Auth.auth()
            do {
                try auth.signOut()
                user?.delete(completion: { (error) in
                    if let error = error {
                        print ("Error signing out: \(String(describing: error))")
                    }
                })
                
                print("📗 Anonymous User: \(String(describing: nuid)) sign out & deletion successful")
            } catch(let err) {
                print ("Error signing out: \(err.localizedDescription) ")
            }
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
    
    // MARK: - Keyboard
    
    func dismissKeyboardOnTap() {
        let tap = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        scrollview.keyboardDismissMode = .onDrag
    }
    
    // MARK: - Transitions
    
    func transitionToDashboard() {
        DashboardTabBarViewController.shared.AccountStatusDelegate.accountTypeChanged(acctype: accountType, user: currentUser!, uid: currentUID!)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let dashboardTabBarController = storyboard.instantiateViewController(identifier: "dashboardTabBarController")
        (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(dashboardTabBarController)
    }
    
    public func transitionToAdminDashboard() {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let adminDashboardNavBarController = storyboard.instantiateViewController(identifier: "adminDashboardNavigationController")
            (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(adminDashboardNavBarController)
        }
    
//    public func presentSheet(sheet: UIAlertController) {
//        present(sheet, animated: true)
//    }
    

    
}

// MARK: - Extensions

extension UITextField {
    func setLeftIcon(_ image:UIImage) {
        let iconView = UIImageView(frame: CGRect(x: 0, y: 5, width: 20, height: 20))
        iconView.image = image
        iconView.tintColor = UIColor.white
        let iconContainerView : UIView = UIView(frame: CGRect(x: 20, y: 0, width: 30, height: 30))
        iconContainerView.addSubview(iconView)
        leftView = iconContainerView
        leftViewMode = .always
    }
}

extension ViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == textFieldEMail {
            passwordTextField.becomeFirstResponder()
        }
        else if textField == passwordTextField {
            validateCredentials()
        }
        
        return true
    }
}

// MARK: - Facebook

// Facebook Login
extension ViewController: LoginButtonDelegate {
    func loginButtonDidLogOut(_ loginButton: FBLoginButton) {
        //null - not used in this application
    }
    
    func loginButton(_ loginButton: FBLoginButton, didCompleteWith result: LoginManagerLoginResult?, error: Error?) {
        guard let token = result?.token?.tokenString else {
            Utilities.showError2("Facebook login failed. ", actionText: "Ok")
            return
        }

        insertFacebookUserToAppDatabase(token)
            print("📗 FB success")
    }
    func insertFacebookUserToAppDatabase (_ token:String) {
        let facebookRequest = FBSDKLoginKit.GraphRequest(graphPath: "me",
                                                         parameters: ["fields":"email, name, id"],
                                                         tokenString: token,
                                                         version: nil,
                                                         httpMethod: .get)
        facebookRequest.start(completion: {_, result, error in
            guard let result = result as? [String: Any],
                error == nil else {
                    print("📕 Graph request failed")
                    return
            }
            print("📗 \(result)")
            guard let userName = result["name"] as? String,
                let email = result["email"] as? String else {
                    print("📕 failed to get email and name from graph request results")
                    return
            }
            let credential = FacebookAuthProvider.credential(withAccessToken: token)
            
            DatabaseManager.shared.checkMemberEmail(with: email, completion: { exists in
                if !exists {
                    let actionSheet = UIAlertController(title: "Account Type", message: "Creator accounts are for creators(Producers, Artists, Engineers, Sound Designers, etc.) and will require verification.", preferredStyle: .actionSheet)
                    actionSheet.addAction(UIAlertAction(title: ListenerAccount, style: .default, handler: {_ in
                        accountType = ListenerAccount
                        UserDefaults.standard.set(accountType, forKey: "accType")
                         let newAcc = UserDefaults.standard.object(forKey: "accType") as? String
                        guard let acc = newAcc else {
                            print("No AccountType linked.")
                            return
                        }
                        print("📙 updated acctype: \(acc)")
                                                print("📗 user with email: \(email) does not exist in database. Proceeding with sign in")
                        FirebaseAuth.Auth.auth().currentUser?.link(with: credential,  completion: { [weak self] authResult, error in
                            guard let strongSelf = self else {
                                return
                            }
                            guard authResult != nil, error == nil else {
                                print("📕 Failed to login new app user with facebook credential.")
                                return
                            }
                            let currUser = authResult?.user
                            let currUID = authResult?.user.uid
                            
                            DashboardTabBarViewController.shared.AccountStatusDelegate.accountTypeChanged(acctype: ListenerAccount, user: currUser!, uid: currUID!)
                            
                                                    print("📙 in initiating database input")
                                                    guard let uid = Auth.auth().currentUser?.uid else {
                                                    print("📕 facebook user not signed in yet.")
                                                    return }
                                                    let modelName = UIDevice.modelName
                                                    let phone = ""
                                                    
                            //TODO //get anonymous cart, plays and favorites, braintreeId, downloads
                                                  //delete anonymous
                                              Database.database().reference().child("Users").child("Anonymous").child(uid).removeValue()
                                                    //TODO - add to dictionary below. place anonymous cart, plays and favorites
                                                    let values = ["Email": email, "Phone Number":phone, "Current Device Model": modelName, "Full Name": userName, "Facebook Account Connected": "Connected", "Google Account Connected": "No", "Apple Account Connected": "No", "Twitter Account Connected": "No"]
                                                    print("📗 Database values: \(values)")
                                                    
                                                    Database.database().reference().child("Users").child(acc).child(uid).updateChildValues(values, withCompletionBlock: { (error, ref) in
                                                        if let error = error {
                                                            print("Failed to update database values with error: ", error.localizedDescription)
                                                            Utilities.showError2("Internal error, please try again.", actionText: "Ok")
                                                            return
                                                        }
                                                    })
                                                    print("📗 Facebook Sign in Successful with firebase")
                            strongSelf.transitionToDashboard()
                                                    Utilities.successBarBanner("Login successful.")
                                                    print("📗 Database update successful")
                                                })
                                                    
                    }))
                    actionSheet.addAction(UIAlertAction(title: "Creator",
                                                        style: .default,
                                                  handler: {_ in
                        accountType = CreatorAccount
                        UserDefaults.standard.set(accountType, forKey: "accType")
                                                    let newAcc = UserDefaults.standard.object(forKey: "accType") as? String
                                                    guard let acc = newAcc else {
                                                        print("No AccountType linked.")
                                                        return
                                                    }
                                                    print("📗 user with email: \(email) does not exist in database. Proceeding with sign in")
                                                    FirebaseAuth.Auth.auth().currentUser?.link(with: credential, completion: { [weak self] authResult, error in
                                                        guard let strongSelf = self else {
                                                            return
                                                        }
                                                        guard authResult != nil, error == nil else {
                                                            print("📕 Failed to login new app user with facebook credential.")
                                                            return
                            }
                            let currUser = authResult?.user
                                                   let currUID = authResult?.user.uid
                                                   
                                                   DashboardTabBarViewController.shared.AccountStatusDelegate.accountTypeChanged(acctype: CreatorAccount, user: currUser!, uid: currUID!)
                                                        
                            print("📙 in initiating database input")
                            guard let uid = Auth.auth().currentUser?.uid else {
                            print("📕 Facebook user not signed in yet.")
                            return }
                            let modelName = UIDevice.modelName
                            let phone = ""
                            
                            ////get anonymous cart, plays and favorites, braintreeId, downloads
                                //delete anonymous
                            Database.database().reference().child("Users").child("Anonymous").child(uid).removeValue()
                                  //place anonymous cart, plays and favorites
                            
                            let values = ["Email": email, "Phone Number":phone, "Current Device Model": modelName, "Full Name": userName, "Facebook Account Connected": "Connected", "Google Account Connected": "No", "Apple Account Connected": "No", "Twitter Account Connected": "No"]
                            print("📗 Database values: \(values)")
                            
                            Database.database().reference().child("Users").child(acc).child(uid).updateChildValues(values, withCompletionBlock: { [weak self] (error, ref) in
                                guard let strongSelf = self else {
                                    return
                                }
                                if let error = error {
                                    print("Failed to update database values with error: ", error.localizedDescription)
                                    Utilities.showError2("Internal error, please try again.", actionText: "Ok")
                                    return
                                }
                            })
                            print("📗 Facebook Sign in Successful with firebase")
                            NotificationCenter.default.post(name: .didLogInNotification, object: nil)
                            Utilities.successBarBanner("Login successful.")
                            print("📗 Database update successful")
                        })

                    }))
                    
                    actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                    ViewController().present(actionSheet, animated: true, completion: nil)
                    
                    
                    
                    

                }
                else if exists {
                    DatabaseManager.shared.checkIfFacebookAccountIsAlreadyConnected(email: email, completion: { [weak self] connected in
                        guard let strongSelf = self else {
                            return
                        }
                        if !connected {
                            //Setup Profile Link
                            Utilities.showError2("E-mail already registered. Sign in and connect your facebook account through the user profile tab.", actionText: "Ok")
                        } else {
                            //TODO //get anonymous cart, plays and favorites, braintreeId, downloads
                                //delete anonymous
                                  //TODO - add to dictionary below. place anonymous cart, plays and favorites
                            
                            let tempAcc = accountType
                            accountType = AnonymousAccount
                            ViewController.shared.logout()
                            accountType = tempAcc
                            
                            FirebaseAuth.Auth.auth().signIn(with: credential, completion: { authResult, error in
                                guard authResult != nil, error == nil else {
                                    print("📕 Failed to login existing facebook account with credential.")
                                    return
                                }
                                guard let authResult = authResult else {
                                    print("Account sign in mishap. in result")
                                    return
                                }
                                
                                
                                
                                let currUser = authResult.user
                                let currUID = authResult.user.uid
                                DatabaseManager.shared.listenerAccountType(with: currUID, completion: { [weak self] Listener, stringResult  in
                                    guard let strongSelf = self else {
                                        return
                                    }
                                    if !Listener {
                                        DatabaseManager.shared.creatorAccountType(with: currUID, completion: { [weak self] Creator, stringResult  in
                                            guard let strongSelf = self else {
                                                return
                                            }
                                            if !Creator {
                                                DatabaseManager.shared.adminAccountType(with: currUID, completion: { [weak self] Admin, stringResult  in
                                                    guard let strongSelf = self else {
                                                        return
                                                    }
                                                            if !Admin {
                                                                print("📕 shouldnt get here. CODE ERROR")
                                                            } else {
                                                                DashboardTabBarViewController.shared.AccountStatusDelegate.accountTypeChanged(acctype: stringResult, user: currUser, uid: currUID)
                                                                strongSelf.updateFacebookSignInDatabaseInfoAndSignIn(result: authResult, acctype: stringResult)
                                                            }
                                                        })
                                            } else {
                                                DashboardTabBarViewController.shared.AccountStatusDelegate.accountTypeChanged(acctype: stringResult, user: currUser, uid: currUID)
                                                strongSelf.updateFacebookSignInDatabaseInfoAndSignIn(result: authResult, acctype: stringResult)
                                            }
                                        })
                                    } else {
                                        DashboardTabBarViewController.shared.AccountStatusDelegate.accountTypeChanged(acctype: stringResult, user: currUser, uid: currUID)
                                        strongSelf.updateFacebookSignInDatabaseInfoAndSignIn(result: authResult, acctype: stringResult)
                                    }
                                })
                                
                            })
                        }
                    })
                }
            
            })
        })
    }
    
    func updateFacebookSignInDatabaseInfoAndSignIn(result: AuthDataResult, acctype: String) {
        print("📙 in initiating database input")
        guard let uid = Auth.auth().currentUser?.uid else {
        print("📕 Facebook user not signed in yet.")
        return }
        
        let modelName = UIDevice.modelName
        
        let values = ["Current Device Model": modelName]

        
        let acc = acctype
        
        Database.database().reference().child("Users").child(acc).child(uid).updateChildValues(values, withCompletionBlock: { [weak self] (error, ref) in
            guard let strongSelf = self else {
                return
            }
        if let error = error {
            print("📕 Failed to update database values with error: ", error.localizedDescription)
         Utilities.showError2("Internal error, please try again.", actionText: "Ok")
            return
        }
            print("📗 Facebook Sign in Successful with firebase")
            strongSelf.transitionToDashboard()
            Utilities.successBarBanner("Login successful.")
        })
    }
    
    
}

class AdminKeyVerification: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
