//
//  BeatsNavigationViewController.swift
//  ToneDeafDeafinitionsApp
//
//  Created by Tone Deaf on 8/2/20.
//  Copyright © 2020 GITEM Solutions. All rights reserved.
//

import UIKit

class BeatsNavigationViewController: UINavigationController {
    
    var beatInfo:BeatData!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(beatInfoh), name: FreePaidToBeatInfoSegNotify, object: nil)
    }

    @objc func beatInfoh(notification: Notification) {
        beatInfo = (notification.object as! BeatData)
        performSegue(withIdentifier: "beatsToBeatInfo", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "beatsToBeatInfo" {
            if let viewController: BeatInfoDetailViewController = segue.destination as? BeatInfoDetailViewController {
                viewController.recievedBeat = beatInfo
            }
        }
    }

}
