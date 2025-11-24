//
//  GoToInstagramProfile.swift
//  ToneDeafDeafinitionsApp
//
//  Created by Tone Deaf on 10/5/20.
//  Copyright © 2020 GITEM Solutions. All rights reserved.
//

import Foundation
import QuickLook

extension UIActivity.ActivityType {
    static let instagramProfile =
        UIActivity.ActivityType("com.gitemsolutions.ToneDeafDeafinitionsApp")
}

class GoToInstagramProfileActivity: UIActivity {
    var artistName = "name"
    override class var activityCategory: UIActivity.Category {
        return .action
    }

    override var activityType: UIActivity.ActivityType? {
        return .instagramProfile
    }

    override var activityTitle: String? {
        return NSLocalizedString("Profile on Instagram", comment: "activity title")
    }

    override var activityImage: UIImage? {
        //return UIImage(named: "igglyph.png")
        return UIImage(named: "instagramIcon")
    }
    
    override func canPerform(withActivityItems activityItems: [Any]) -> Bool {
        for case is String in activityItems {
            return true
        }

        return false
    }
    
    var igurl: String!

    override func prepare(withActivityItems activityItems: [Any]) {
        for act in activityItems {
            if act is String, (act as! String).contains("instagram") {
                self.igurl = act as! String
            }
            return
        }
    }

    override func perform() {
        let instagramHooks = igurl
        let instagramUrl = URL(string: instagramHooks!)
        if UIApplication.shared.canOpenURL(instagramUrl!)
            {
            UIApplication.shared.openURL(instagramUrl!)
                self.activityDidFinish(true)
             } else {
                //redirect to safari because the user doesn't have Instagram
                UIApplication.shared.openURL(URL(string: "http://instagram.com/")!)
                self.activityDidFinish(true)
            }
    }
}

//extension GoToInstagramProfileActivity: QLPreviewControllerDataSource {
//    override var activityViewController: UIViewController? {
//        guard let image = self.mustachioedImage else {
//            return nil
//        }
//
//        let viewController = QLPreviewController()
//        viewController.dataSource = self
//        return viewController
//    }
//
//    // MARK: QLPreviewControllerDataSource
//
//    func numberOfPreviewItems(in controller: QLPreviewController) -> Int {
//        return self.mustachioedImage != nil ? 1 : 0
//    }
//
//    func previewController(_ controller: QLPreviewController, previewItemAt index: Int) -> QLPreviewItem {
//        return self.mustachioedImage! as! QLPreviewItem
//    }
//}
