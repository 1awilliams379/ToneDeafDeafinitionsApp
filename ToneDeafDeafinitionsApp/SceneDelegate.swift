//
//  SceneDelegate.swift
//  ToneDeafDeafinitionsApp
//
//  Created by Tone Deaf on 7/26/20.
//  Copyright © 2020 GITEM Solutions. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import  GoogleSignIn
import FirebaseAuth
//import FacebookCore


class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    //let storyboard = UIStoryboard(name: "Main", bundle: nil)


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let _ = (scene as? UIWindowScene) else { return }
        
        BeatsFreePaidTabBarViewController.shared.viewDidLayoutSubviews()
        
        let fontAttributes = [NSAttributedString.Key.font: UIFont(name: "AvenirNextCondensed-DemiBold", size: 17)]
        UITabBarItem.appearance().setTitleTextAttributes(fontAttributes as [NSAttributedString.Key : Any], for: .normal)
        // add these lines
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
            
            let accType = UserDefaults.standard.object(forKey: "accType") as? String
            
        if accType != nil && Auth.auth().currentUser != nil {
            if accType == AdminAccount {
                print("📘 User already logged in. Rebooting session with \(accType) Account")
                let adminDashboardNavBarController = storyboard.instantiateViewController(identifier: "adminDashboardNavigationController")
                window?.rootViewController = adminDashboardNavBarController
            } else {
                print("📘 User already logged in. Rebooting session with \(currentUser?.email) \(accType) Account")
                    DashboardTabBarViewController.shared.AccountStatusDelegate.accountTypeChanged(acctype: accType!, user: Auth.auth().currentUser!, uid: Auth.auth().currentUser!.uid)
            }
        }
            
        
    }
    
    func changeRootViewController(_ vc: UIViewController, animated: Bool = true) {
        guard let window = self.window else {
            return
        }
        
        // change the root view controller to your specific view controller
        window.rootViewController = vc
        
        UIView.transition(with: window,
        duration: 0.5,
        options: [.curveEaseInOut],
        animations: nil,
        completion: nil)
    }
    
    func changeRootViewController2(_ vc: UIViewController, animated: Bool = true) {
        guard let window = self.window else {
            return
        }
        
        // change the root view controller to your specific view controller
        window.rootViewController = vc
        
        UIView.transition(with: window,
        duration: 0.5,
        options: [.transitionCrossDissolve],
        animations: nil,
        completion: nil)
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        BeatsFreePaidTabBarViewController.shared.viewDidLayoutSubviews()
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not neccessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        BeatsFreePaidTabBarViewController.shared.viewDidLayoutSubviews()
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        BeatsFreePaidTabBarViewController.shared.viewDidLayoutSubviews()
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        BeatsFreePaidTabBarViewController.shared.viewDidLayoutSubviews()
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        BeatsFreePaidTabBarViewController.shared.viewDidLayoutSubviews()
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }
    
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
      if let openURLContext = URLContexts.first {
        ApplicationDelegate.shared.application(UIApplication.shared, open:
        openURLContext.url, sourceApplication:
        openURLContext.options.sourceApplication, annotation:
        openURLContext.options.annotation)
        
        }
        if let url = URLContexts.first?.url {
                    print(url)
                    let urlStr = url.absoluteString //1
                    // Parse the custom URL as per your requirement.
                    let component = urlStr.components(separatedBy: "=") // 2
                    if component.count > 1, let appId = component.last { // 3
                        print(appId)
                        let topViewController = self.window?.rootViewController as? DashboardTabBarViewController
                        //let currentVC = topViewController?.presentingViewController as? DashboardViewController
                        //currentVC?.data.text = "Application Id : " + appId
                    }
                }
        
    }
            

}


