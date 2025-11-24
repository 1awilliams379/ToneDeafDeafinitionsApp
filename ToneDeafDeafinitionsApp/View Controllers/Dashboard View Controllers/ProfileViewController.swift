//
//  ProfileViewController.swift
//  ToneDeafDeafinitionsApp
//
//  Created by Tone Deaf on 8/4/20.
//  Copyright © 2020 GITEM Solutions. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage
import FBSDKLoginKit
import GoogleSignIn
import MarqueeLabel
import SkeletonView

class ProfileViewController: UIViewController {
    
    static let shared = ProfileViewController()
    
    @IBOutlet weak var profileTableView: UITableView!
    @IBOutlet weak var tableViewHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var logoutButton: UIButton!
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var spotifyLogin: UIButton!
    @IBOutlet weak var loginaccount: MarqueeLabel!{
        didSet {
            if currentUser != nil {
                loginaccount.text = "Account Type · \(currentAppUser.accountType)"
            }
           
        }
    }
    @IBOutlet weak var loginStatus: MarqueeLabel!{
        didSet {
            if currentUser != nil {
                guard let user = currentUser?.email else {
                    loginStatus.text = ""
                    return}
                loginStatus.text = "\(user)"
            }
           
        }
    }
    
    var skelvar = 0
    var artistArray:[String]!
    var guestArray:[String]!
    var listenerArray:[String]!
    
    let SpotifyClientID = "a4fae7208fd5486e8230d9a3c10baa32"
    let SpotifyRedirectURL = URL(string: "ToneDeafDeafinitionsApp://spotify-login-callback")!

    lazy var configuration = SPTConfiguration(
      clientID: SpotifyClientID,
      redirectURL: SpotifyRedirectURL
    )
    
    deinit {
        print("Profile being deallocated from memory. OS reclaiming")
        NotificationCenter.default.removeObserver(self)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        profileTableView.delegate = self
        profileTableView.dataSource = self
        profileTableView.allowsSelection = true
        profileTableView.allowsMultipleSelection = true
        profileTableView.allowsSelectionDuringEditing = true
        profileTableView.allowsMultipleSelectionDuringEditing = true
        profileTableView.remembersLastFocusedIndexPath = true
        profileTableView.isUserInteractionEnabled = true
        createObservers()
        setUpElements()
        setArray()
        skelvar = 0
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        profileTableView.allowsSelection = true
        profileTableView.allowsMultipleSelection = true
        profileTableView.allowsSelectionDuringEditing = true
        profileTableView.allowsMultipleSelectionDuringEditing = true
        profileTableView.remembersLastFocusedIndexPath = true
        profileTableView.isUserInteractionEnabled = true
        
        setArray()
        profileTableView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if skelvar == 0 {
            profileTableView.isSkeletonable = true
            profileTableView.showAnimatedGradientSkeleton(usingGradient: .init(baseColor: UIColor.init(red: 22/255, green: 22/255, blue: 22/255, alpha: 1)), animation: nil, transition: .crossDissolve(0.25))
        }
    skelvar+=1
        //tableview.showAnimatedSkeleton(usingColor: .wetAsphalt, transition: .crossDissolve(0.25))
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        
    }
    
    func hideskeleton(tableview: UITableView) {
        DispatchQueue.main.async {
        tableview.stopSkeletonAnimation()
        tableview.hideSkeleton(reloadDataAfter: false, transition: .crossDissolve(0.25))
        tableview.reloadData()
            self.tableViewHeightConstraint.constant = self.profileTableView.contentSize.height
            self.view.layoutSubviews()
        }
    }
    
    func createObservers(){
                NotificationCenter.default.addObserver(self, selector: #selector(ProfileViewController.updatedAccType), name: AccountChangedNotify, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(goToLogin), name: GoToLoginNotify, object: nil)
            }
    
        @objc func updatedAccType(notification: NSNotification) {
            print("📘 change login button \(accountType)")
            
            loginStatus.textColor = .white
            guard let user = currentUser?.email else {
                loginStatus.text = ""
                return}
            loginStatus.text = ("\(user)")
            loginaccount.text = "Account Type · \(currentAppUser.accountType)"
        }
    
    func setUpElements() {
            logoutButton.isHidden = true
            signInButton.isHidden = true

    }
    
    func setArray() {
        if currentAppUser.accountType == CreatorAccount {
            artistArray = []
            artistArray = ["downgrade","favorites", "following","lyrics","orders","downloads", "connections","documents","contact","settings", "logout"]
            
        } else if currentAppUser.accountType == AnonymousAccount {
            guestArray = []
            guestArray = ["favorites","contact","settings","login"]
        } else {
            listenerArray = []
            listenerArray = ["upgrade", "favorites","following","orders","downloads", "connections","documents","contact","settings", "logout"]
            
        }
        hideskeleton(tableview: profileTableView)
    }
    
    
    @IBAction func spotifyButtonTapped(_ sender: Any) {
    }
    
    @objc func goToLogin() {
        performSegue(withIdentifier: "profileToLogin", sender: nil)
    }
    
    @IBAction func logoutButtonTapped(_ sender: Any) {
        let actionSheet = UIAlertController(title: "",
                                      message: "",
                                      preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Log Out",
                                      style: .destructive,
                                      handler: { [weak self] _ in
                                        self?.logout()
                                        
                                        
                                        
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        present(actionSheet, animated: true)
    }
    
    public func logout() {
        ViewController.shared.logout()
        ViewController.shared.signInAnnonymously(completion: {
            ViewController.shared.transitionToDashboard()
        })
    }

    

}

extension ProfileViewController: UITableViewDelegate, UITableViewDataSource, SkeletonTableViewDataSource {
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
                performSegue(withIdentifier: "profileToChangeAccountType", sender: nil)
            case "favorites":
                performSegue(withIdentifier: "profileToFavorites", sender: nil)
            case "logout":
                let actionSheet = UIAlertController(title: "Are you sure you want to sign out?",
                                              message: "Any items in cart will be removed.",
                                              preferredStyle: .actionSheet)
                actionSheet.addAction(UIAlertAction(title: "Log Out",
                                              style: .destructive,
                                              handler: { [weak self] _ in
                                                self?.logout()
                }))
                
                actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                actionSheet.view.tintColor = Constants.Colors.redApp
                present(actionSheet, animated: true)
                //NotificationCenter.default.post(name: OpenTheAlertNotify, object: actionSheet)
            case "connections":
                performSegue(withIdentifier: "profileToConnections", sender: nil)
            case "orders":
                print("jwince")
            case "contact":
                print("jwince")
            case "settings":
                print("jwince")
            case "downloads":
                performSegue(withIdentifier: "profileToDownloads", sender: nil)
            default:
                print("jwince")
            }
        case ListenerAccount:
            let array = listenerArray[indexPath.row]
            switch array {
            case "upgrade":
                performSegue(withIdentifier: "profileToChangeAccountType", sender: nil)
            case "favorites":
                performSegue(withIdentifier: "profileToFavorites", sender: nil)
            case "logout":
                let actionSheet = UIAlertController(title: "Are you sure you want to sign out?",
                                              message: "Any items in cart will be removed.",
                                              preferredStyle: .actionSheet)
                actionSheet.addAction(UIAlertAction(title: "Log Out",
                                              style: .destructive,
                                              handler: { [weak self] _ in
                                                self?.logout()
                }))
                
                actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                actionSheet.view.tintColor = Constants.Colors.redApp
                present(actionSheet, animated: true)
                //NotificationCenter.default.post(name: OpenTheAlertNotify, object: actionSheet)
            case "connections":
                NotificationCenter.default.post(name: OpenTheSheetNotify, object: "connections")
            case "orders":
                print("jwince")
            case "contact":
                print("jwince")
            case "settings":
                print("jwince")
            default:
                print("jwince")
            }
        default:
            let array = guestArray[indexPath.row]
            switch array {
            case "favorites":
                performSegue(withIdentifier: "profileToFavorites", sender: nil)
            default:
                performSegue(withIdentifier: "profileToLogin", sender: nil)
            }
            //NotificationCenter.default.post(name: GoToLoginNotify, object: nil)
        }
    }
}

class ProfileTableViewControlller: UITableView {
    override var intrinsicContentSize: CGSize {
        layoutIfNeeded()
        return CGSize(width: UIView.noIntrinsicMetric, height: contentSize.height)
    }
}

class ProfileTableCellController: UITableViewCell {
    
    @IBOutlet weak var labeltext: MarqueeLabel!
    @IBOutlet weak var chevron: UIImageView!
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var button: UIButton!
    
    var cont = ""
    
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
    
    @IBAction func cellTapped(_ sender: Any) {
        
        
    }
    
    func funcSetTemp(array: String) {
        cont = array
        switch array {
        case "upgrade":
            labeltext.text = "Upgrade Account"
            icon.image = UIImage(named: "chevrons-up")
            chevron.isHidden = false
        case "logout":
            labeltext.text = "Sign Out"
            icon.image = UIImage(named: "logout")
            chevron.isHidden = true
        case "login":
            labeltext.text = "Sign In"
            icon.image = UIImage(named: "user")
            chevron.isHidden = false
        case "connections":
            labeltext.text = "Connections"
            icon.image = UIImage(systemName: "link")
            chevron.isHidden = false
        case "orders":
            labeltext.text = "Orders"
            icon.image = UIImage(named: "package")
            chevron.isHidden = false
        case "contact":
            labeltext.text = "Contact Us"
            icon.image = UIImage(systemName: "envelope.open")
            chevron.isHidden = false
        case "favorites":
            labeltext.text = "Favorites"
            icon.image = UIImage(systemName: "heart.fill")
            chevron.isHidden = false
        case "lyrics":
            labeltext.text = "Lyrics"
            icon.image = UIImage(named: "notes")
            chevron.isHidden = false
        case "documents":
            labeltext.text = "My Documents"
            icon.image = UIImage(systemName: "newspaper")
            chevron.isHidden = false
        case "downloads":
            labeltext.text = "Downloads"
            icon.image = UIImage(named: "tablerdownload")
            chevron.isHidden = false
        case "following":
            labeltext.text = "Following"
            icon.image = UIImage(systemName: "person.3.fill")
            chevron.isHidden = false
        case "settings":
            labeltext.text = "Settings"
            icon.image = UIImage(systemName: "gear")
            chevron.isHidden = false
        case "apple":
            labeltext.text = "Connect To Apple Account"
            icon.image = UIImage(named: "apple")
            chevron.isHidden = false
        case "apple connected":
            labeltext.text = "Apple Connected"
            icon.image = UIImage(named: "apple")
            chevron.isHidden = false
            chevron.image = UIImage(named: "checks")
            chevron.tintColor = .green
        case "google":
            labeltext.text = "Connect To Google Account"
            icon.image = UIImage(named: "google")
            chevron.isHidden = false
        case "google connected":
            labeltext.text = "Google Connected"
            icon.image = UIImage(named: "google")
            chevron.isHidden = false
            chevron.image = UIImage(named: "checks")
            chevron.tintColor = .green
        case "facebook":
            labeltext.text = "Connect To Facebook Account"
            icon.image = UIImage(named: "facebookIcon")
            chevron.isHidden = false
        case "facebook connected":
            labeltext.text = "Facebook Connected"
            icon.image = UIImage(named: "facebookIcon")
            chevron.isHidden = false
            chevron.image = UIImage(named: "checks")
            chevron.tintColor = .green
        case "spotify":
            labeltext.text = "Connect To Spotify Account"
            icon.image = UIImage(named: "SpotifyIcon")
            chevron.isHidden = false
        case "spotify connected":
            labeltext.text = "Spotify Connected"
            icon.image = UIImage(named: "SpotifyIcon")
            chevron.isHidden = false
            chevron.image = UIImage(named: "checks")
            chevron.tintColor = .green
        case "twitter":
            labeltext.text = "Connect To Twitter Account"
            icon.image = UIImage(named: "twitter")
            chevron.isHidden = false
        case "twitter connected":
            labeltext.text = "Twitter Connected"
            icon.image = UIImage(named: "twitter")
            chevron.isHidden = false
            chevron.image = UIImage(named: "checks")
            chevron.tintColor = .green
        case "paypal":
            labeltext.text = "Connect To Paypal Account"
            icon.image = UIImage(named: "")
            chevron.isHidden = false
        case "paypal connected":
            labeltext.text = "Paypal Connected"
            icon.image = UIImage(named: "")
            chevron.isHidden = false
            chevron.image = UIImage(named: "checks")
            chevron.tintColor = .green
        case "square":
            labeltext.text = "Connect To Square Account"
            icon.image = UIImage(named: "")
            chevron.isHidden = false
        case "square connected":
            labeltext.text = "Square Connected"
            icon.image = UIImage(named: "")
            chevron.isHidden = false
            chevron.image = UIImage(named: "checks")
            chevron.tintColor = .green
        default:
            labeltext.text = "Downgrade Account"
            icon.image = UIImage(named: "trending-down")
            chevron.isHidden = false
        }
    }
    
}
