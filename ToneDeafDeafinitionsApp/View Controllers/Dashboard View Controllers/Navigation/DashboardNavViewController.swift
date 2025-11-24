//
//  DashboardNavViewController.swift
//  ToneDeafDeafinitionsApp
//
//  Created by Tone Deaf on 8/29/20.
//  Copyright © 2020 GITEM Solutions. All rights reserved.
//

import UIKit

class DashboardNavViewController: UINavigationController {
    var beatInfo:BeatData!

    @IBOutlet weak var tabItem: UITabBarItem!
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(beatInfoh), name: DashToBeatInfoSegNotify, object: nil)
    }

    @objc func beatInfoh(notification: Notification) {
        beatInfo = (notification.object as! BeatData)
        performSegue(withIdentifier: "dashToBeatInfo", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "dashToBeatInfo" {
            if let viewController: BeatInfoDetailViewController = segue.destination as? BeatInfoDetailViewController {
                viewController.recievedBeat = beatInfo
            }
        }
    }
}
