//
//  ConnectionsBottomSheetViewController.swift
//  ToneDeafDeafinitionsApp
//
//  Created by Tone Deaf on 10/3/20.
//  Copyright © 2020 GITEM Solutions. All rights reserved.
//

import UIKit
import SkeletonView

class ConnectionsViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var skelvar = 0
    var artistArray:[String]!
    var guestArray:[String]!
    var listenerArray:[String]!
    var visualEffectView:UIVisualEffectView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        setArray()
        skelvar = 0
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if skelvar == 0 {
//            tableView.isSkeletonable = true
//            tableView.showAnimatedGradientSkeleton(usingGradient: .init(baseColor: UIColor.init(red: 22/255, green: 22/255, blue: 22/255, alpha: 1)), animation: nil, transition: .crossDissolve(0.25))
        }
    skelvar+=1
    }
    
    override func viewWillAppear(_ animated: Bool) {
            self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
          self.navigationController?.navigationBar.shadowImage = UIImage()
          self.navigationController?.navigationBar.isTranslucent = true
    }
    
    func hideskeleton(tableview: UITableView) {
        DispatchQueue.main.async {
        tableview.stopSkeletonAnimation()
        tableview.hideSkeleton(reloadDataAfter: false, transition: .crossDissolve(0.25))
        tableview.reloadData()
            self.view.layoutSubviews()
        }
    }
    
    deinit {
        print("Connections being deallocated from memory. OS reclaiming")
        NotificationCenter.default.removeObserver(self)
    }
    
    func setArray() {
        if currentAppUser.accountType == CreatorAccount {
            artistArray = []
            if currentAppUser.appleConnected != false {
                artistArray.append("apple connected")
            } else {
                artistArray.append("apple")
            }
            if currentAppUser.googleConnected != false {
                artistArray.append("google connected")
            } else {
                artistArray.append("google")
            }
            if currentAppUser.facebookConnected != false {
                artistArray.append("facebook connected")
            } else {
                artistArray.append("facebook")
            }
            if currentAppUser.spotifyConnected != false {
                artistArray.append("spotify connected")
            } else {
                artistArray.append("spotify")
            }
            if currentAppUser.twitterConnected != false {
                artistArray.append("twitter connected")
            } else {
                artistArray.append("twitter")
            }
            if currentAppUser.paypalConnected != false {
                artistArray.append("paypal connected")
            } else {
                artistArray.append("paypal")
            }
            if currentAppUser.squareConnected != false {
                artistArray.append("square connected")
            } else {
                artistArray.append("square")
            }
        } else if currentAppUser.accountType == AnonymousAccount {
            guestArray = []
            
        } else {
            listenerArray = []
            if currentAppUser.appleConnected != false {
                listenerArray.append("apple connected")
            } else {
                listenerArray.append("apple")
            }
            if currentAppUser.googleConnected != false {
                listenerArray.append("google connected")
            } else {
                listenerArray.append("google")
            }
            if currentAppUser.facebookConnected != false {
                listenerArray.append("facebook connected")
            } else {
                listenerArray.append("facebook")
            }
            if currentAppUser.spotifyConnected != false {
                listenerArray.append("spotify connected")
            } else {
                listenerArray.append("spotify")
            }
            if currentAppUser.twitterConnected != false {
                listenerArray.append("twitter connected")
            } else {
                listenerArray.append("twitter")
            }
            if currentAppUser.paypalConnected != false {
                listenerArray.append("paypal connected")
            } else {
                listenerArray.append("paypal")
            }
            if currentAppUser.squareConnected != false {
                listenerArray.append("square connected")
            } else {
                listenerArray.append("square")
            }
            
        }
        //hideskeleton(tableview: tableView)
    }
    
}

extension ConnectionsViewController: UITableViewDelegate, UITableViewDataSource, SkeletonTableViewDataSource {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60//Your custom row height
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch currentAppUser.accountType {
        case CreatorAccount:
            return artistArray.count
        case ListenerAccount:
            return listenerArray.count
        default:
            return guestArray.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch currentAppUser.accountType {
        case CreatorAccount:
            let cell = tableView.dequeueReusableCell(withIdentifier: "profileCell", for: indexPath) as! ProfileTableCellController
            if !artistArray.isEmpty {
                let array = artistArray[indexPath.row]
                cell.funcSetTemp(array: array)
            }
            return cell
        case ListenerAccount:
            let cell = tableView.dequeueReusableCell(withIdentifier: "profileCell", for: indexPath) as! ProfileTableCellController
            if !listenerArray.isEmpty {
                let array = listenerArray[indexPath.row]
                cell.funcSetTemp(array: array)
            }
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "profileCell", for: indexPath) as! ProfileTableCellController
            if !guestArray.isEmpty{
                let array = guestArray[indexPath.row]
                cell.funcSetTemp(array: array)
            }
            return cell
        }
    }
    
    func collectionSkeletonView(_ skeletonView: UITableView, cellIdentifierForRowAt indexPath: IndexPath) -> ReusableCellIdentifier {
            return "profileCell"
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        switch currentAppUser.accountType {
        case CreatorAccount:
            let array = artistArray[indexPath.row]
            switch array {
            case "downgrade":
                print("jbirgvu")
            case "logout":
                print("hdjsfgn")
            case "connections":
                print("hdjsfgn")
            default:
                print("jwince")
            }
        case ListenerAccount:
            let array = listenerArray[indexPath.row]
            switch array {
            case "upgrade":
                print("jbirgvu")
            case "logout":
                print("hdjsfgn")
            case "connections":
                print("hdjsfgn")
            default:
                print("jwince")
            }
        default:
            let array = guestArray[indexPath.row]
            //NotificationCenter.default.post(name: GoToLoginNotify, object: nil)
        }
    }
}
