//
//  AppDelegate.swift
//  ToneDeafDeafinitionsApp
//
//  Created by Tone Deaf on 7/26/20.
//  Copyright © 2020 GITEM Solutions. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseCore
import FirebaseDatabase
import FBSDKCoreKit
import FBSDKLoginKit
import GoogleSignIn
import Braintree
//import FacebookCore

let imageCache = NSCache<NSString, UIImage>()

@UIApplicationMain class AppDelegate: UIResponder, UIApplicationDelegate, GIDSignInDelegate, SPTAppRemoteDelegate, SPTAppRemotePlayerStateDelegate {
    
    var backgroundSessionCompletionHandler : (() -> Void)?
    var window: UIWindow?
    let audioCache = NSCache<NSString, UIImage>()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        // Override point for customization after application launch.
        ApplicationDelegate.shared.application(
            application,
            didFinishLaunchingWithOptions: launchOptions
        )
        FirebaseApp.configure()
        
        GIDSignIn.sharedInstance()?.clientID = FirebaseApp.app()?.options.clientID
        GIDSignIn.sharedInstance()?.delegate = self
        
        BTAppSwitch.setReturnURLScheme("com.gitemsolutions.ToneDeafDeafinitionsApp.tonedeaf.payments")
        
        imageCache.countLimit = 100
        imageCache.totalCostLimit = 1024 * 1024 * 200
        
        Database.database().isPersistenceEnabled = true
        Database.database().reference().keepSynced(true)
        
        lightImpactGenerator.prepare()
        mediumImpactGenerator.prepare()
        heavyImpactGenerator.prepare()
        
        let userDefaults = UserDefaults.standard
        if userDefaults.value(forKey: "appFirstTimeOpend") == nil {
        } else {
            
            print("📘 Returning")
            
        }
        
        return true
    
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        guard error == nil else {
            if let error = error {
                print("📕 Google Sign in failed \(error)")
                Utilities.showError2("Failed to sign in with Google.", actionText: "Ok")
            }
            print("📗 Connected to google account \(String(describing: user))")
            return
        }
        
        guard let user = user else {
            print("📕 Google user not found.")
            return
        }
        
        print("📗 Google Sign in Successful \(user)")
        
        guard let email = user.profile.email,
        let userName = user.profile.name
        else {
            print("📕 Google user not communicated proprerly.")
            return
        }
        print("📗 \(email) : \(userName)")
        
        guard let authentication = user.authentication else {
            print("📕 Missing Auth object from google user")
            return }
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken,
                                                          accessToken: authentication.accessToken)
        print(credential)
        DatabaseManager.shared.checkMemberEmail(with: email, completion: { exists in
            if !exists {
                let actionSheet = UIAlertController(title: "Account Type", message: "Artist accounts will require verification.", preferredStyle: .actionSheet)
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
                    FirebaseAuth.Auth.auth().currentUser?.link(with: credential,  completion: { authResult, error in
                                                    guard authResult != nil, error == nil else {
                                                    print("📕 Failed to login new app user with google credential. \(error)")
                                                    return
                                                }
                        let currUser = authResult?.user
                        let currUID = authResult?.user.uid
                        
                        DashboardTabBarViewController.shared.AccountStatusDelegate.accountTypeChanged(acctype: ListenerAccount, user: currUser!, uid: currUID!)
                        
                                                print("📙 in initiating database input")
                                                guard let uid = Auth.auth().currentUser?.uid else {
                                                print("📕 Google user not signed in yet.")
                                                return }
                                                let modelName = UIDevice.modelName
                                                let phone = ""
                        //get anonymous cart, plays and favorites, braintreeId, downloads
                                              //delete anonymous
                                          //Database.database().reference().child("Users").child(uid).removeValue()
                                                //TODO - add to dictionary below. place anonymous cart, plays and favorites
                        let ref = Database.database().reference().child("Users").child(uid)
                        ref.child("Email").setValue(email)
                        ref.child("Phone Number").setValue(phone)
                        ref.child("Current Device Model").setValue(modelName)
                        ref.child("Full Name").setValue(userName)
                        ref.child("Account Type").setValue(ListenerAccount)
                        ref.child("uid").setValue(uid)
                        ref.child("Google Account Connected").setValue("Connected")
                        currentAppUser.accountType = ListenerAccount
                        currentAppUser.currentDevice = modelName
                        currentAppUser.email = email
                        currentAppUser.phone = phone
                        currentAppUser.name = userName
                        currentAppUser.uid = uid
                        currentAppUser.googleConnected = true
                        print("📗 Google Sign in Successful with firebase")
                        NotificationCenter.default.post(name: .didLogInNotification, object: nil)
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
                                                FirebaseAuth.Auth.auth().currentUser?.link(with: credential, completion: { authResult, error in
                            guard authResult != nil, error == nil else {
                            print("📕 Failed to login new app user with google credential.")
                            return
                        }
                        let currUser = authResult?.user
                                               let currUID = authResult?.user.uid
                                               
                                               DashboardTabBarViewController.shared.AccountStatusDelegate.accountTypeChanged(acctype: CreatorAccount, user: currUser!, uid: currUID!)
                                                    
                        print("📙 in initiating database input")
                        guard let uid = Auth.auth().currentUser?.uid else {
                        print("📕 Google user not signed in yet.")
                        return }
                        let modelName = UIDevice.modelName
                        let phone = ""
                                                    
                                                    //get anonymous cart, plays and favorites, braintreeId, downloads
                                                    //delete anonymous
                                                    //Database.database().reference().child("Users").child(uid).removeValue()
                                                    //place anonymous cart, plays and favorites
                                                    
                                                    let ref = Database.database().reference().child("Users").child(uid)
                                                    ref.child("Email").setValue(email)
                                                    ref.child("Phone Number").setValue(phone)
                                                    ref.child("Current Device Model").setValue(modelName)
                                                    ref.child("Full Name").setValue(userName)
                                                    ref.child("Account Type").setValue(CreatorAccount)
                                                    ref.child("uid").setValue(uid)
                                                    ref.child("Google Account Connected").setValue("Connected")
                                                    currentAppUser.accountType = CreatorAccount
                                                    currentAppUser.currentDevice = modelName
                                                    currentAppUser.email = email
                                                    currentAppUser.phone = phone
                                                    currentAppUser.name = userName
                                                    currentAppUser.uid = uid
                                                    currentAppUser.googleConnected = true
                                                    print("📗 Google Sign in Successful with firebase")
                                                    NotificationCenter.default.post(name: .didLogInNotification, object: nil)
                                                    Utilities.successBarBanner("Login successful.")
                        print("📗 Database update successful")
                    })

                }))
                
                actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                NotificationCenter.default.post(name: OpenTheAlertNotify, object: actionSheet)
                
                
                
                

            }
            else if exists {
                DatabaseManager.shared.checkIfGoogleAccountIsAlreadyConnected(email: email, completion: { connected in
                    if !connected {
                        //Setup Profile Link
                        Utilities.showError2("E-mail already registered. Sign in and connect your google account through the user profile tab.", actionText: "Ok")
                    } else {
                        //get anonymous cart, plays and favorites, braintreeId, downloads
                            //delete anonymous
                              //TODO - add to dictionary below. place anonymous cart, plays and favorites
                        
                        let tempAcc = accountType
                        accountType = AnonymousAccount
                        ViewController.shared.logout()
                        accountType = tempAcc
                        
                        FirebaseAuth.Auth.auth().signIn(with: credential, completion: { authResult, error in
                            guard authResult != nil, error == nil else {
                                print("📕 Failed to login existing google account with credential.")
                                return
                            }
                            guard let authResult = authResult else {
                                print("Account sign in mishap. in result")
                                return
                            }
                            
                            
                            
                            let currUser = authResult.user
                            let currUID = authResult.user.uid
                            
                            
                            DatabaseManager.shared.getUserData(with: currUID, completion: {[weak self] user in
                                guard let strongSelf = self else {return}
                                currentAppUser = user
                                accountType = user.accountType
                                if accountType == AdminAccount {
                                    DashboardTabBarViewController.shared.AccountStatusDelegate.accountTypeChanged(acctype: accountType, user: currUser, uid: currUID)
                                    strongSelf.updateSignInDatabaseInfoAndSignIn(result: authResult, acctype: accountType)
                                } else {
                                    DashboardTabBarViewController.shared.AccountStatusDelegate.accountTypeChanged(acctype: accountType, user: currUser, uid: currUID)
                                    strongSelf.updateSignInDatabaseInfoAndSignIn(result: authResult, acctype: accountType)
                                }
                            })
                            
                        })
                    }
                })
            }
        
        })
    
    }
    
    func updateSignInDatabaseInfoAndSignIn(result: AuthDataResult, acctype: String) {
        print("📙 in initiating database input")
        guard let uid = Auth.auth().currentUser?.uid else {
        print("📕 Google user not signed in yet.")
        return }
        
        let modelName = UIDevice.modelName
        
        let values = ["Current Device Model": modelName]

        
        let acc = acctype
        
        Database.database().reference().child("Users").child(uid).updateChildValues(values, withCompletionBlock: { (error, ref) in
        if let error = error {
            print("📕 Failed to update database values with error: ", error.localizedDescription)
         Utilities.showError2("Internal error, please try again.", actionText: "Ok")
            return
        }
            print("📗 Google Sign in Successful with firebase")
            NotificationCenter.default.post(name: .didLogInNotification, object: nil)
            Utilities.successBarBanner("Login successful.")
        })
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        print("📙 Google user was disconnected")
    }
    
    func application(_ application: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any])
      -> Bool {
        if url.scheme?.localizedCaseInsensitiveCompare("com.gitemsolutions.ToneDeafDeafinitionsApp.tonedeaf.payments") == .orderedSame {
                return BTAppSwitch.handleOpen(url, options: options)
            }
        
        
      return GIDSignIn.sharedInstance().handle(url)
    }
    
    func application(_ application: UIApplication, willContinueUserActivityWithType userActivityType: String) -> Bool {
        
        return false
    }
    
    func application(_ application: UIApplication, handleEventsForBackgroundURLSession identifier: String, completionHandler: @escaping () -> Void) {
            backgroundSessionCompletionHandler = completionHandler
        }
    
    func appRemoteDidEstablishConnection(_ appRemote: SPTAppRemote) {
      print("connected")
    }
    func appRemote(_ appRemote: SPTAppRemote, didDisconnectWithError error: Error?) {
      print("disconnected")
    }
    func appRemote(_ appRemote: SPTAppRemote, didFailConnectionAttemptWithError error: Error?) {
      print("failed")
    }
    func playerStateDidChange(_ playerState: SPTAppRemotePlayerState) {
      print("player state changed")
    }

}

extension UIAlertController {
   
    private static var globalPresentationWindow: UIWindow?
   
    func presentGlobally(animated: Bool, completion: (() -> Void)?) {
        UIAlertController.globalPresentationWindow = UIWindow(frame: UIScreen.main.bounds)
        UIAlertController.globalPresentationWindow?.rootViewController = UIViewController()
        UIAlertController.globalPresentationWindow?.windowLevel = UIWindow.Level.alert + 1
        UIAlertController.globalPresentationWindow?.backgroundColor = .clear
        UIAlertController.globalPresentationWindow?.makeKeyAndVisible()
        UIAlertController.globalPresentationWindow?.rootViewController?.present(self, animated: animated, completion: completion)
    }
   
    open override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        UIAlertController.globalPresentationWindow?.isHidden = true
        UIAlertController.globalPresentationWindow = nil
    }
   
}

