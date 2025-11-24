//
//  BeatsFreePaidTabBarViewController.swift
//  ToneDeafDeafinitionsApp
//
//  Created by Tone Deaf on 8/2/20.
//  Copyright © 2020 GITEM Solutions. All rights reserved.
//

import UIKit
import SideMenu

class BeatsFreePaidTabBarViewController: UITabBarController {
    
    static let shared = BeatsFreePaidTabBarViewController()

    @IBOutlet weak var freePaidTabBar: UITabBar!
    @IBOutlet weak var beatsTabBarItem: UITabBarItem!
    
    var beatInfo:BeatData!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidLayoutSubviews() {
        self.tabBar.frame = CGRect(x: 0, y: 0, width: tabBar.frame.size.width, height: tabBar.frame.size.height)
        super.viewDidLayoutSubviews()

    }
    
    @IBAction func profileTapped(_ sender: Any) {
        SideMenuManager.default.rightMenuNavigationController = profileSideMenu
        profileSideMenu.presentationStyle = .viewSlideOutMenuIn
        //profileSideMenu.setNavigationBarHidden(true, animated: false)
        present(profileSideMenu, animated: true, completion: nil)
    }
    
    @IBAction func cartTapped(_ sender: Any) {
        NotificationCenter.default.post(name: OpenTheCartNotify, object: nil)
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

extension BeatsFreePaidTabBarViewController: SideMenuNavigationControllerDelegate {

    func sideMenuWillAppear(menu: SideMenuNavigationController, animated: Bool) {
        print("SideMenu Appearing! (animated: \(animated))")
    }

    func sideMenuDidAppear(menu: SideMenuNavigationController, animated: Bool) {
        print("SideMenu Appeared! (animated: \(animated))")
    }

    func sideMenuWillDisappear(menu: SideMenuNavigationController, animated: Bool) {
        print("SideMenu Disappearing! (animated: \(animated))")
    }

    func sideMenuDidDisappear(menu: SideMenuNavigationController, animated: Bool) {
        print("SideMenu Disappeared! (animated: \(animated))")
        SideMenuManager.default.rightMenuNavigationController = filterMenu
        filterMenu.setNavigationBarHidden(true, animated: false)
        filterMenu.presentationStyle = .viewSlideOutMenuIn
    }
}
