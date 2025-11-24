//
//  AdminDashboardViewController.swift
//  ToneDeafDeafinitionsApp
//
//  Created by Tone Deaf on 7/26/20.
//  Copyright © 2020 GITEM Solutions. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage
import FBSDKLoginKit
import GoogleSignIn
import FBSDKCoreKit
import NVActivityIndicatorView
//import FacebookLogin

class AdminDashboardViewController: UIViewController {

    @IBOutlet weak var logOutButton: UIBarButtonItem!
    @IBOutlet weak var addBeatsCard: UIView!
    @IBOutlet weak var deleteBeatsCard: UIView!
    @IBOutlet weak var addSongsCard: UIView!
    @IBOutlet weak var editSongsCard: UIView!
    @IBOutlet weak var addMerchCard: UIView!
    @IBOutlet weak var deleteMerchCard: UIView!
    @IBOutlet weak var addBeatsButton: UIButton!
    @IBOutlet weak var addAlbumCard: UIView!
    @IBOutlet weak var editAlbumCard: UIView!
    @IBOutlet weak var addArtist: UIView!
    @IBOutlet weak var deleteArtistCard: UIView!
    @IBOutlet weak var addPerson: UIView!
    @IBOutlet weak var deletePersonCard: UIView!
    var spinnerDim:UIView!
    var spinner:NVActivityIndicatorView!
    
    
    let uid = Auth.auth().currentUser?.uid
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SpotifyRequest.shared.setAccessToken()
        setUpElements()
    }
    
    
    func createObservers(){
        NotificationCenter.default.addObserver(self, selector: #selector(openAlert(notificantion:)), name: OpenTheAlertAdminNotify, object: nil)
        
//        NotificationCenter.default.addObserver(self, selector: #selector(showSpinner(notificantion:)), name: adminDashboardStartSpinnerNotify, object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(hideSpinner(notificantion:)), name: adminDashboardStopSpinnerNotify, object: nil)
    }
    
    
    @objc func showSpinner(notificantion:Notification) {
        let screenSize: CGRect = UIScreen.main.bounds
        spinnerDim = UIView(frame: CGRect(x: 0, y: 0, width: screenSize.width, height: screenSize.height))
        spinnerDim.backgroundColor = .black
        spinnerDim.alpha = 0.85
//        spinnerDim.isHidden = true
        self.view.addSubview(spinnerDim)
        
        spinner = NVActivityIndicatorView(frame: CGRect(x: spinnerDim.center.x-25, y: spinnerDim.center.y-25, width: 50, height: 50), type: .circleStrokeSpin, color: Constants.Colors.redApp, padding: 0)
        spinnerDim.addSubview(spinner)
        spinnerDim.isHidden = false
        
        spinner.startAnimating()
    }
    
    @objc func hideSpinner(notificantion:Notification) {
        if spinnerDim != nil {
            spinnerDim.removeFromSuperview()
            spinnerDim.isHidden = true
            spinner.stopAnimating()
        }
    }
    
    func setUpElements(){
        createObservers()
        addBeatsCard.layer.cornerRadius = 10
        deleteBeatsCard.layer.cornerRadius = 10
        addSongsCard.layer.cornerRadius = 10
        editSongsCard.layer.cornerRadius = 10
        addMerchCard.layer.cornerRadius = 10
        deleteMerchCard.layer.cornerRadius = 10
        addAlbumCard.layer.cornerRadius = 10
        editAlbumCard.layer.cornerRadius = 10
        addArtist.layer.cornerRadius = 10
        deleteArtistCard.layer.cornerRadius = 10
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @objc func openAlert(notificantion:Notification) { 
        let ac = notificantion.object as! UIAlertController
        self.present(ac, animated: true)
    }
    
    
    @IBAction func addBeatsTapped(_ sender: Any) {
        
        
    }
    
    @IBAction func esitSongsTapped(_ sender: Any) {
        performSegue(withIdentifier: "adminDashboardToEditSongs", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "editPersonToTonesPick" {
            if let viewController: SelectTonesPickItemViewController = segue.destination as? SelectTonesPickItemViewController {
                viewController.array = "person"
                viewController.prevPage = "adminDash"
            }
        }
        if segue.identifier == "editSongToTonesPick" {
            if let viewController: SelectTonesPickItemViewController = segue.destination as? SelectTonesPickItemViewController {
                viewController.array = "song"
                viewController.prevPage = "adminDash"
            }
        }
        if segue.identifier == "editAlbumToTonesPick" {
            if let viewController: SelectTonesPickItemViewController = segue.destination as? SelectTonesPickItemViewController {
                viewController.array = "album"
                viewController.prevPage = "adminDash"
            }
        }
        if segue.identifier == "editVideoToTonesPick" {
            if let viewController: SelectTonesPickItemViewController = segue.destination as? SelectTonesPickItemViewController {
                viewController.array = "video"
                viewController.prevPage = "adminDash"
            }
        }
    }
    
    @IBAction func manageUsersButton(_ sender: Any) {
        FaceBookRequest.shared.getFacebookVideo(id: "1600625341", completion: { vdeo in
            
        })
    }
    
    @IBAction func logOutTapped(_ sender: Any) {
        let actionSheet = UIAlertController(title: "",
                                      message: "",
                                      preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Log Out",
                                      style: .destructive,
                                      handler: { [weak self] _ in
                                        guard let strongSelf = self else {return}
                                        let actionSheet = UIAlertController(title: "",
                                                                      message: "",
                                                                      preferredStyle: .actionSheet)
                                        actionSheet.addAction(UIAlertAction(title: "Log Out",
                                                                      style: .destructive,
                                                                      handler: { [weak self] _ in
                                                                        
                                                                        self?.logout()
                                                                        
                                                                        
                                                                        
                                        }))
                                        
                                        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                                        
                                        strongSelf.present(actionSheet, animated: true)
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
    
    func transitionToLogin() {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let loginNavController = storyboard.instantiateViewController(identifier: "loginVC")

            (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(loginNavController)
    }

}
