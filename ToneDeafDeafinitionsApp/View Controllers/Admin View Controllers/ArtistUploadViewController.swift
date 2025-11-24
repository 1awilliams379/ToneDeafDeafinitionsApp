//
//  ArtistUploadViewController.swift
//  ToneDeafDeafinitionsApp
//
//  Created by Tone Deaf on 8/20/20.
//  Copyright © 2020 GITEM Solutions. All rights reserved.
//

import UIKit
import FirebaseDatabase

class ArtistUploadViewController: UIViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!

    @IBOutlet weak var artistNameTextField: UITextField! {
        didSet {
            let placeholderText = NSAttributedString(string: "Name",
                                                     attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray.withAlphaComponent(0.4)])
            
            artistNameTextField.attributedPlaceholder = placeholderText
        }
    }
    @IBOutlet weak var artistLegalNameTextField: UITextField! {
        didSet {
            let placeholderText = NSAttributedString(string: "Name",
                                                     attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray.withAlphaComponent(0.4)])
            
            artistLegalNameTextField.attributedPlaceholder = placeholderText
        }
    }
    @IBOutlet weak var altNameTextField: UITextField!
    @IBOutlet weak var instagramTextField: UITextField! {
        didSet {
            let placeholderText = NSAttributedString(string: "URL",
                                                     attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray.withAlphaComponent(0.4)])
            
            instagramTextField.attributedPlaceholder = placeholderText
        }
    }
    @IBOutlet weak var spotifyTextField: UITextField! {
        didSet {
            let placeholderText = NSAttributedString(string: "spotify:artist:",
                                                     attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray.withAlphaComponent(0.4)])
            
            spotifyTextField.attributedPlaceholder = placeholderText
        }
    }
    @IBOutlet weak var appleTextField: UITextField! {
        didSet {
            let placeholderText = NSAttributedString(string: "id=",
                                                     attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray.withAlphaComponent(0.4)])
            
            appleTextField.attributedPlaceholder = placeholderText
        }
    }
    @IBOutlet weak var twitterTextField: UITextField! {
        didSet {
            let placeholderText = NSAttributedString(string: "URL",
                                                     attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray.withAlphaComponent(0.4)])
            
            twitterTextField.attributedPlaceholder = placeholderText
        }
    }
    @IBOutlet weak var facebookTextField: UITextField! {
        didSet {
            let placeholderText = NSAttributedString(string: "URL",
                                                     attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray.withAlphaComponent(0.4)])
            
            facebookTextField.attributedPlaceholder = placeholderText
        }
    }
    @IBOutlet weak var souncloudTextField: UITextField! {
        didSet {
            let placeholderText = NSAttributedString(string: "URL",
                                                     attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray.withAlphaComponent(0.4)])
            
            souncloudTextField.attributedPlaceholder = placeholderText
        }
    }
    @IBOutlet weak var youtubeMusicTextField: UITextField! {
        didSet {
            let placeholderText = NSAttributedString(string: "URL",
                                                     attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray.withAlphaComponent(0.4)])
            
            youtubeMusicTextField.attributedPlaceholder = placeholderText
        }
    }
    @IBOutlet weak var amazonTextField: UITextField! {
        didSet {
            let placeholderText = NSAttributedString(string: "URL",
                                                     attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray.withAlphaComponent(0.4)])
            
            amazonTextField.attributedPlaceholder = placeholderText
        }
    }
    @IBOutlet weak var deezerTextField: UITextField! {
        didSet {
            let placeholderText = NSAttributedString(string: "URL",
                                                     attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray.withAlphaComponent(0.4)])
            
            deezerTextField.attributedPlaceholder = placeholderText
        }
    }
    @IBOutlet weak var napsterTextField: UITextField! {
        didSet {
            let placeholderText = NSAttributedString(string: "URL",
                                                     attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray.withAlphaComponent(0.4)])
            
            napsterTextField.attributedPlaceholder = placeholderText
        }
    }
    @IBOutlet weak var tidalTextField: UITextField! {
        didSet {
            let placeholderText = NSAttributedString(string: "URL",
                                                     attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray.withAlphaComponent(0.4)])
            
            tidalTextField.attributedPlaceholder = placeholderText
        }
    }
    @IBOutlet weak var spinrillaTextField: UITextField! {
        didSet {
            let placeholderText = NSAttributedString(string: "URL",
                                                     attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray.withAlphaComponent(0.4)])
            
            spinrillaTextField.attributedPlaceholder = placeholderText
        }
    }
    @IBOutlet weak var youtubeTextField: UITextField!{
        didSet {
            let placeholderText = NSAttributedString(string: "URL",
                                                     attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray.withAlphaComponent(0.4)])
            
            youtubeTextField.attributedPlaceholder = placeholderText
        }
    }
    
    var progressView:UIProgressView!
    var totalProgress:Float = 1
    var progressCompleted:Float = 0
    
    var alertView:UIAlertController!
    
    var activeTextField : UITextField? = nil
    
    private var artistName:String!
    private var artistLegalName:String!
    var altName:Array<String> = [""]
    var date:Date!
    var tDAppId = ""
    var genid = ""
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dismissKeyboardOnTap()
        setUpElements()
        // call the 'keyboardWillShow' function when the view controller receive the notification that a keyboard is going to be shown
            NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
          
              // call the 'keyboardWillHide' function when the view controlelr receive notification that keyboard is going to be hidden
            NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func setUpElements() {
        Utilities.styleTextField(artistNameTextField)
        addBottomLineToText(artistNameTextField)
        artistNameTextField.delegate = self
        
        Utilities.styleTextField(altNameTextField)
        addBottomLineToText(altNameTextField)
        altNameTextField.delegate = self
        
        Utilities.styleTextField(instagramTextField)
        addBottomLineToText(instagramTextField)
        instagramTextField.delegate = self
        
        Utilities.styleTextField(spotifyTextField)
        addBottomLineToText(spotifyTextField)
        spotifyTextField.delegate = self
        
        Utilities.styleTextField(appleTextField)
        addBottomLineToText(appleTextField)
        appleTextField.delegate = self
        
        Utilities.styleTextField(twitterTextField)
        addBottomLineToText(twitterTextField)
        twitterTextField.delegate = self
        
        Utilities.styleTextField(facebookTextField)
        facebookTextField.delegate = self
        addBottomLineToText(facebookTextField)
        addBottomLineToText(souncloudTextField)
        souncloudTextField.delegate = self
        addBottomLineToText(youtubeMusicTextField)
        youtubeMusicTextField.delegate = self
        addBottomLineToText(amazonTextField)
        amazonTextField.delegate = self
        addBottomLineToText(deezerTextField)
        deezerTextField.delegate = self
        addBottomLineToText(tidalTextField)
        tidalTextField.delegate = self
        addBottomLineToText(napsterTextField)
        napsterTextField.delegate = self
        addBottomLineToText(spinrillaTextField)
        spinrillaTextField.delegate = self
        addBottomLineToText(youtubeTextField)
        youtubeTextField.delegate = self
        Utilities.styleTextField(souncloudTextField)
        Utilities.styleTextField(youtubeMusicTextField)
        Utilities.styleTextField(amazonTextField)
        Utilities.styleTextField(deezerTextField)
        Utilities.styleTextField(tidalTextField)
        Utilities.styleTextField(napsterTextField)
        Utilities.styleTextField(spinrillaTextField)
        Utilities.styleTextField(youtubeTextField)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {

      guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {

        // if keyboard size is not available for some reason, dont do anything
        return
      }
        
        let contentInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: keyboardSize.height , right: 0.0)
            scrollView.contentInset = contentInsets
            scrollView.scrollIndicatorInsets = contentInsets
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
      // move back the root view origin to zero
        let contentInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
                
            
            // reset back the content inset to zero after keyboard is gone
            scrollView.contentInset = contentInsets
            scrollView.scrollIndicatorInsets = contentInsets
      self.view.frame.origin.y = 0
    }
    
    deinit {
        print("📗 Artist Upload being deallocated from memory. OS reclaiming")
    }
    
    @IBAction func uploadArtistButtonTapped(_ sender: Any) {
        guard artistNameTextField.text != "" else {
            Utilities.showError2("Artist name required"  ,actionText: "Ok")
            return
        }
        if altNameTextField.text != ""{
            let atext = altNameTextField.text!.trimmingCharacters(in: .whitespaces).split(separator: ",").map { String($0) }
                   altName = atext
        }
        artistName = artistNameTextField.text!
        if artistLegalNameTextField.text != "" {
            artistLegalName = artistLegalNameTextField.text!
        }
        date = Date()
        if spotifyTextField.text != "", spotifyTextField.text!.count > 3 {
            totalProgress+=1
        }
        if appleTextField.text != "", appleTextField.text!.count > 3 {
            totalProgress+=1
        }
        if youtubeTextField.text != "", youtubeTextField.text!.count > 3 {
            totalProgress+=1
        }
        if souncloudTextField.text != "", souncloudTextField.text!.count > 3 {
            totalProgress+=1
        }
        if youtubeMusicTextField.text != "", youtubeMusicTextField.text!.count > 3 {
            totalProgress+=1
        }
        if amazonTextField.text != "", amazonTextField.text!.count > 3 {
            totalProgress+=1
        }
        if deezerTextField.text != "", deezerTextField.text!.count > 3 {
            totalProgress+=1
        }
        if tidalTextField.text != "", tidalTextField.text!.count > 3 {
            totalProgress+=1
        }
        if napsterTextField.text != "", napsterTextField.text!.count > 3 {
            totalProgress+=1
        }
        if spinrillaTextField.text != "", spinrillaTextField.text!.count > 3 {
            totalProgress+=1
        }
        if twitterTextField.text != "", twitterTextField.text!.count > 3 {
            totalProgress+=1
        }
        if facebookTextField.text != "", facebookTextField.text!.count > 3 {
            totalProgress+=1
        }
        if instagramTextField.text != "", instagramTextField.text!.count > 3 {
            totalProgress+=1
        }
        
        alertView = UIAlertController(title: "Uploading \(artistName!)", message: "Preparing...", preferredStyle: .alert)
        alertView.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: {[weak self] _ in
            guard let strongSelf = self else {return}
            
        }))
        alertView.view.tintColor = Constants.Colors.redApp
        //  Show it to your users
        present(alertView, animated: true, completion: { [weak self] in
            guard let strongSelf = self else {return}
            //  Add your progressbar after alert is shown (and measured)
            let margin:CGFloat = 8.0
            let rect = CGRect(x: margin, y: 72.0, width: strongSelf.alertView.view.frame.width - margin * 2.0 , height: 1.5)
            strongSelf.progressView = UIProgressView(frame: rect)
            strongSelf.progressView.alpha = 0
            strongSelf.progressView!.progress = 0
            strongSelf.progressView!.tintColor = Constants.Colors.redApp
            strongSelf.alertView.view.addSubview(strongSelf.progressView!)
            UIView.animate(withDuration: 0.2, animations: {
                strongSelf.progressView.alpha = 1
                strongSelf.view.layoutSubviews()
            })
            strongSelf.generateAppId()
        })
    }
    func gatherUploadData() {
        spotifyData()
        appleData()
        instagramData()
        youtubeData()
        twitterData()
        facebookData()
        soundcloudData()
        youtubeMusicData()
        amazonData()
        deezerData()
        spinrillaData()
        napsterData()
        tidalData()
    }
    
    func generateAppId() {
        alertView.message = "Generating artist app ID..."
        genid = StorageManager.shared.generateRandomNumber(digits: 6)
        DatabaseManager.shared.checkIfPersonAppIdExists(appid: genid, completion: { [weak self] result in
            guard let strongSelf = self else {return}
            if result == true {
                strongSelf.generateAppId()
                
            } else {
                strongSelf.progressCompleted+=1
                strongSelf.progressView.progress = (strongSelf.progressCompleted/strongSelf.totalProgress)
                print("\(strongSelf.progressCompleted) out of \(strongSelf.totalProgress)")
                strongSelf.tDAppId = strongSelf.genid
                if strongSelf.progressCompleted == strongSelf.totalProgress {
                    strongSelf.basicArtist()
                } else {
                    strongSelf.gatherUploadData()
                }
            }
        })
    }
    
    func instagramData() {
        guard instagramTextField.text != "" else {return}
        guard instagramTextField.text!.count > 15 else {return}
        
            alertView.message = "Gathering Instagram info..."
        let url = instagramTextField.text!
        
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone(identifier: "EDT")
        formatter.dateFormat = "MMMM dd, yyyy"
        let newDate = formatter.string(from: date)
        
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "HH:mm:ss a"
        timeFormatter.timeZone = TimeZone(identifier: "EDT")
        let newTime = timeFormatter.string(from: date)
        
        let artistRandomKey = ("\(artistName!)--\(newDate)--\(newTime)--\(tDAppId)")
        
        
        var RequiredInfoMap = [String : Any]()
        RequiredInfoMap = [
            "Name" : artistName!,
            "Tone Deaf App Id" : tDAppId,
            "Alternate Names" : altName,
            "Followers" : 0,
            "Time Registered To App" : newTime,
            "Date Registered To App" : newDate,
            "Instagram Profile URL" : url,
            "Linked To Account" : "",
            "Songs": [""],
            "Albums": [""],
            "Videos": [""]
        ]
        
        let RequiredRef = Database.database().reference().child("Registered Artists").child(artistRandomKey)
        RequiredRef.updateChildValues(RequiredInfoMap) { [weak self] (error, songRef) in
            guard let strongSelf = self else {return}
            if let error = error {
                print("📕 Failed to upload dictionary to database: \(error)")
                Utilities.showError2("Failed to Upload. Please try again.", actionText: "OK")
                return
            } else {
                strongSelf.progressCompleted+=1
                strongSelf.progressView.progress = (strongSelf.progressCompleted/strongSelf.totalProgress)
                print("\(strongSelf.progressCompleted) out of \(strongSelf.totalProgress)")
                if strongSelf.progressCompleted == strongSelf.totalProgress {
                    strongSelf.alertView.dismiss(animated: true, completion: {[weak self] in
                        guard let strongSelf = self else {return}
                        Utilities.successBarBanner("Upload successful.")
                        _ = strongSelf.navigationController?.popViewController(animated: true)
                    })
                }
            }
        }
        
        Database.database().reference().child("All Content IDs").observeSingleEvent(of: .value, with: {[weak self] snap in
            guard let strongSelf = self else {return}
            var arr = snap.value as! [String]
            if !arr.contains("\(strongSelf.tDAppId)Æ\(strongSelf.artistName!)") {
                arr.append("\(strongSelf.tDAppId)Æ\(strongSelf.artistName!)")
            }
            Database.database().reference().child("All Content IDs").setValue(arr)
        })
        
        Database.database().reference().child("Registered Artists").child("All Artist IDs").observeSingleEvent(of: .value, with: {[weak self] snap in
            guard let strongSelf = self else {return}
            var arr = snap.value as! [String]
            if !arr.contains("\(strongSelf.tDAppId)Æ\(strongSelf.artistName!)") {
                arr.append("\(strongSelf.tDAppId)Æ\(strongSelf.artistName!)")
            }
            Database.database().reference().child("Registered Artists").child("All Artist IDs").setValue(arr)
        })
    }
    
    func spotifyData() {
        guard spotifyTextField.text != "" else {return}
        guard spotifyTextField.text!.count > 15 else {
            Utilities.showError2("Failed to Upload. Invalid Spotify URL.", actionText: "OK")
            return}
        
            alertView.message = "Gathering Spotify info..."
        let songId = String((spotifyTextField.text?.suffix(22))!)
        let token = (UserDefaults.standard.object(forKey: "SPTaccesstoken") as? String)!
//        SpotifyRequest.shared.getArtistInfo(accessToken: token, id: songId, name: artistName, altName: altName, mainRole: "", dateobj: date, appid: tDAppId, legal: artistLegalName, tag: "art", completion: {[weak self] result in
//            guard let strongSelf = self else {return}
//            switch result {
//            case .success(_):
//                strongSelf.progressCompleted+=1
//                strongSelf.progressView.progress = (strongSelf.progressCompleted/strongSelf.totalProgress)
//                print("\(strongSelf.progressCompleted) out of \(strongSelf.totalProgress)")
//                if strongSelf.progressCompleted == strongSelf.totalProgress {
//                    strongSelf.alertView.dismiss(animated: true, completion: {[weak self] in
//                        guard let strongSelf = self else {return}
//                        Utilities.successBarBanner("Upload successful.")
//                        _ = strongSelf.navigationController?.popViewController(animated: true)
//                    })
//                }
//            case .failure(let err):
//            print(err)
//                Utilities.showError2("Failed to Upload. Please try again.", actionText: "OK")
//            }
//        })
    }
    
    func appleData() {
        guard appleTextField.text != "" else {return}
        guard appleTextField.text!.count > 15 else {return}
        alertView.message = "Gathering Apple Music info..."
        let artistId = String((appleTextField.text?.suffix(10))!)
//        AppleMusicRequest.shared.getAppleMusicArtist(id: artistId, name: artistName, altName: altName, mainRole: "", dateobj: date, appid: tDAppId, legal: artistLegalName, tag: "art", completion: {[weak self] result in
//            guard let strongSelf = self else {return}
//            switch result {
//            case .success(_):
//                strongSelf.progressCompleted+=1
//                strongSelf.progressView.progress = (strongSelf.progressCompleted/strongSelf.totalProgress)
//                print("\(strongSelf.progressCompleted) out of \(strongSelf.totalProgress)")
//                if strongSelf.progressCompleted == strongSelf.totalProgress {
//                    strongSelf.alertView.dismiss(animated: true, completion: {[weak self] in
//                        guard let strongSelf = self else {return}
//                        Utilities.successBarBanner("Upload successful.")
//                        _ = strongSelf.navigationController?.popViewController(animated: true)
//                    })
//                }
//            case .failure(let err):
//            print(err)
//                Utilities.showError2("Failed to Upload. Please try again.", actionText: "OK")
//            }
//        })
    }
    
    func twitterData() {
        guard twitterTextField.text != "" else {return}
        guard twitterTextField.text!.count > 15 else {return}
        alertView.message = "Gathering Twitter info..."
        let url = twitterTextField.text!
        
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone(identifier: "EDT")
        formatter.dateFormat = "MMMM dd, yyyy"
        let newDate = formatter.string(from: date)
        
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "HH:mm:ss a"
        timeFormatter.timeZone = TimeZone(identifier: "EDT")
        let newTime = timeFormatter.string(from: date)
        
        let artistRandomKey = ("\(artistName!)--\(newDate)--\(newTime)--\(tDAppId)")
        
        
        var RequiredInfoMap = [String : Any]()
        RequiredInfoMap = [
            "Name" : artistName!,
            "Tone Deaf App Id" : tDAppId,
            "Alternate Names" : altName,
            "Followers" : 0,
            "Time Registered To App" : newTime,
            "Date Registered To App" : newDate,
            "Twitter Profile URL" : url,
            "Linked To Account" : "",
            "Songs": [""],
            "Albums": [""],
            "Videos": [""]
        ]
        
        let RequiredRef = Database.database().reference().child("Registered Artists").child(artistRandomKey)
        if let legal = artistLegalName {
            RequiredRef.child("Legal Name").setValue(legal)
        }
        RequiredRef.updateChildValues(RequiredInfoMap) { [weak self] (error, songRef) in
            guard let strongSelf = self else {return}
            if let error = error {
                print("📕 Failed to upload dictionary to database: \(error)")
                Utilities.showError2("Failed to Upload. Please try again.", actionText: "OK")
                return
            } else {
                strongSelf.progressCompleted+=1
                strongSelf.progressView.progress = (strongSelf.progressCompleted/strongSelf.totalProgress)
                print("\(strongSelf.progressCompleted) out of \(strongSelf.totalProgress)")
                if strongSelf.progressCompleted == strongSelf.totalProgress {
                    strongSelf.alertView.dismiss(animated: true, completion: {[weak self] in
                        guard let strongSelf = self else {return}
                        Utilities.successBarBanner("Upload successful.")
                        _ = strongSelf.navigationController?.popViewController(animated: true)
                    })
                }
            }
        }
        
        Database.database().reference().child("All Content IDs").observeSingleEvent(of: .value, with: {[weak self] snap in
            guard let strongSelf = self else {return}
            var arr = snap.value as! [String]
            if !arr.contains("\(strongSelf.tDAppId)Æ\(strongSelf.artistName!)") {
                arr.append("\(strongSelf.tDAppId)Æ\(strongSelf.artistName!)")
            }
            Database.database().reference().child("All Content IDs").setValue(arr)
        })
        
        Database.database().reference().child("Registered Artists").child("All Artist IDs").observeSingleEvent(of: .value, with: {[weak self] snap in
            guard let strongSelf = self else {return}
            var arr = snap.value as! [String]
            if !arr.contains("\(strongSelf.tDAppId)Æ\(strongSelf.artistName!)") {
                arr.append("\(strongSelf.tDAppId)Æ\(strongSelf.artistName!)")
            }
            Database.database().reference().child("Registered Artists").child("All Artist IDs").setValue(arr)
        })
    }
    
    func facebookData() {
        guard facebookTextField.text != "" else {return}
        guard facebookTextField.text!.count > 15 else {return}
        alertView.message = "Gathering Facebook info..."
        let url = facebookTextField.text!
        
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone(identifier: "EDT")
        formatter.dateFormat = "MMMM dd, yyyy"
        let newDate = formatter.string(from: date)
        
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "HH:mm:ss a"
        timeFormatter.timeZone = TimeZone(identifier: "EDT")
        let newTime = timeFormatter.string(from: date)
        
        let artistRandomKey = ("\(artistName!)--\(newDate)--\(newTime)--\(tDAppId)")
        
        
        var RequiredInfoMap = [String : Any]()
        RequiredInfoMap = [
            "Name" : artistName!,
            "Tone Deaf App Id" : tDAppId,
            "Alternate Names" : altName,
            "Followers" : 0,
            "Time Registered To App" : newTime,
            "Date Registered To App" : newDate,
            "Facebook Profile URL" : url,
            "Linked To Account" : "",
            "Songs": [""],
            "Albums": [""],
            "Videos": [""]
        ]
        
        let RequiredRef = Database.database().reference().child("Registered Artists").child(artistRandomKey)
        if let legal = artistLegalName {
            RequiredRef.child("Legal Name").setValue(legal)
        }
        RequiredRef.updateChildValues(RequiredInfoMap) { [weak self] (error, songRef) in
            guard let strongSelf = self else {return}
            if let error = error {
                print("📕 Failed to upload dictionary to database: \(error)")
                Utilities.showError2("Failed to Upload. Please try again.", actionText: "OK")
                return
            } else {
                strongSelf.progressCompleted+=1
                strongSelf.progressView.progress = (strongSelf.progressCompleted/strongSelf.totalProgress)
                print("\(strongSelf.progressCompleted) out of \(strongSelf.totalProgress)")
                if strongSelf.progressCompleted == strongSelf.totalProgress {
                    strongSelf.alertView.dismiss(animated: true, completion: {[weak self] in
                        guard let strongSelf = self else {return}
                        Utilities.successBarBanner("Upload successful.")
                        _ = strongSelf.navigationController?.popViewController(animated: true)
                    })
                }
            }
        }
        
        Database.database().reference().child("All Content IDs").observeSingleEvent(of: .value, with: {[weak self] snap in
            guard let strongSelf = self else {return}
            var arr = snap.value as! [String]
            if !arr.contains("\(strongSelf.tDAppId)Æ\(strongSelf.artistName!)") {
                arr.append("\(strongSelf.tDAppId)Æ\(strongSelf.artistName!)")
            }
            Database.database().reference().child("All Content IDs").setValue(arr)
        })
        
        Database.database().reference().child("Registered Artists").child("All Artist IDs").observeSingleEvent(of: .value, with: {[weak self] snap in
            guard let strongSelf = self else {return}
            var arr = snap.value as! [String]
            if !arr.contains("\(strongSelf.tDAppId)Æ\(strongSelf.artistName!)") {
                arr.append("\(strongSelf.tDAppId)Æ\(strongSelf.artistName!)")
            }
            Database.database().reference().child("Registered Artists").child("All Artist IDs").setValue(arr)
        })
    }
    
    func youtubeData() {
        guard youtubeTextField.text != "" else {return}
        guard youtubeTextField.text!.count > 15 else {return}
        alertView.message = "Gathering Youtube info..."
        let url = youtubeTextField.text!
        
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone(identifier: "EDT")
        formatter.dateFormat = "MMMM dd, yyyy"
        let newDate = formatter.string(from: date)
        
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "HH:mm:ss a"
        timeFormatter.timeZone = TimeZone(identifier: "EDT")
        let newTime = timeFormatter.string(from: date)
        
        let artistRandomKey = ("\(artistName!)--\(newDate)--\(newTime)--\(tDAppId)")
        
        
        var RequiredInfoMap = [String : Any]()
        RequiredInfoMap = [
            "Name" : artistName!,
            "Tone Deaf App Id" : tDAppId,
            "Alternate Names" : altName,
            "Followers" : 0,
            "Time Registered To App" : newTime,
            "Date Registered To App" : newDate,
            "Youtube Channel URL" : url,
            "Linked To Account" : "",
            "Songs": [""],
            "Albums": [""],
            "Videos": [""]
        ]
        
        let RequiredRef = Database.database().reference().child("Registered Artists").child(artistRandomKey)
        if let legal = artistLegalName {
            RequiredRef.child("Legal Name").setValue(legal)
        }
        RequiredRef.updateChildValues(RequiredInfoMap) { [weak self] (error, songRef) in
            guard let strongSelf = self else {return}
            if let error = error {
                print("📕 Failed to upload dictionary to database: \(error)")
                Utilities.showError2("Failed to Upload. Please try again.", actionText: "OK")
                return
            } else {
                strongSelf.progressCompleted+=1
                strongSelf.progressView.progress = (strongSelf.progressCompleted/strongSelf.totalProgress)
                print("\(strongSelf.progressCompleted) out of \(strongSelf.totalProgress)")
                if strongSelf.progressCompleted == strongSelf.totalProgress {
                    strongSelf.alertView.dismiss(animated: true, completion: {[weak self] in
                        guard let strongSelf = self else {return}
                        Utilities.successBarBanner("Upload successful.")
                        _ = strongSelf.navigationController?.popViewController(animated: true)
                    })
                }
            }
        }
        
        Database.database().reference().child("All Content IDs").observeSingleEvent(of: .value, with: {[weak self] snap in
            guard let strongSelf = self else {return}
            var arr = snap.value as! [String]
            if !arr.contains("\(strongSelf.tDAppId)Æ\(strongSelf.artistName!)") {
                arr.append("\(strongSelf.tDAppId)Æ\(strongSelf.artistName!)")
            }
            Database.database().reference().child("All Content IDs").setValue(arr)
        })
        
        Database.database().reference().child("Registered Artists").child("All Artist IDs").observeSingleEvent(of: .value, with: {[weak self] snap in
            guard let strongSelf = self else {return}
            var arr = snap.value as! [String]
            if !arr.contains("\(strongSelf.tDAppId)Æ\(strongSelf.artistName!)") {
                arr.append("\(strongSelf.tDAppId)Æ\(strongSelf.artistName!)")
            }
            Database.database().reference().child("Registered Artists").child("All Artist IDs").setValue(arr)
        })
    }
    
    func soundcloudData() {
        guard souncloudTextField.text != "" else {return}
        guard souncloudTextField.text!.count > 15 else {return}
        alertView.message = "Gathering Soundcloud info..."
        let url = souncloudTextField.text!
        
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone(identifier: "EDT")
        formatter.dateFormat = "MMMM dd, yyyy"
        let newDate = formatter.string(from: date)
        
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "HH:mm:ss a"
        timeFormatter.timeZone = TimeZone(identifier: "EDT")
        let newTime = timeFormatter.string(from: date)
        
        let artistRandomKey = ("\(artistName!)--\(newDate)--\(newTime)--\(tDAppId)")
        
        
        var RequiredInfoMap = [String : Any]()
        RequiredInfoMap = [
            "Name" : artistName!,
            "Tone Deaf App Id" : tDAppId,
            "Alternate Names" : altName,
            "Followers" : 0,
            "Time Registered To App" : newTime,
            "Date Registered To App" : newDate,
            "Soundcloud Profile URL" : url,
            "Linked To Account" : "",
            "Songs": [""],
            "Albums": [""],
            "Videos": [""]
        ]
        
        let RequiredRef = Database.database().reference().child("Registered Artists").child(artistRandomKey)
        if let legal = artistLegalName {
            RequiredRef.child("Legal Name").setValue(legal)
        }
        RequiredRef.updateChildValues(RequiredInfoMap) { [weak self] (error, songRef) in
            guard let strongSelf = self else {return}
            if let error = error {
                print("📕 Failed to upload dictionary to database: \(error)")
                Utilities.showError2("Failed to Upload. Please try again.", actionText: "OK")
                return
            } else {
                strongSelf.progressCompleted+=1
                strongSelf.progressView.progress = (strongSelf.progressCompleted/strongSelf.totalProgress)
                print("\(strongSelf.progressCompleted) out of \(strongSelf.totalProgress)")
                if strongSelf.progressCompleted == strongSelf.totalProgress {
                    strongSelf.alertView.dismiss(animated: true, completion: {[weak self] in
                        guard let strongSelf = self else {return}
                        Utilities.successBarBanner("Upload successful.")
                        _ = strongSelf.navigationController?.popViewController(animated: true)
                    })
                }
            }
        }
        
        Database.database().reference().child("All Content IDs").observeSingleEvent(of: .value, with: {[weak self] snap in
            guard let strongSelf = self else {return}
            var arr = snap.value as! [String]
            if !arr.contains("\(strongSelf.tDAppId)Æ\(strongSelf.artistName!)") {
                arr.append("\(strongSelf.tDAppId)Æ\(strongSelf.artistName!)")
            }
            Database.database().reference().child("All Content IDs").setValue(arr)
        })
        
        Database.database().reference().child("Registered Artists").child("All Artist IDs").observeSingleEvent(of: .value, with: {[weak self] snap in
            guard let strongSelf = self else {return}
            var arr = snap.value as! [String]
            if !arr.contains("\(strongSelf.tDAppId)Æ\(strongSelf.artistName!)") {
                arr.append("\(strongSelf.tDAppId)Æ\(strongSelf.artistName!)")
            }
            Database.database().reference().child("Registered Artists").child("All Artist IDs").setValue(arr)
        })
    }
    
    func youtubeMusicData() {
        guard youtubeMusicTextField.text != "" else {return}
        guard youtubeMusicTextField.text!.count > 15 else {return}
        alertView.message = "Gathering Youtube Music info..."
        let url = youtubeMusicTextField.text!
        
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone(identifier: "EDT")
        formatter.dateFormat = "MMMM dd, yyyy"
        let newDate = formatter.string(from: date)
        
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "HH:mm:ss a"
        timeFormatter.timeZone = TimeZone(identifier: "EDT")
        let newTime = timeFormatter.string(from: date)
        
        let artistRandomKey = ("\(artistName!)--\(newDate)--\(newTime)--\(tDAppId)")
        
        
        var RequiredInfoMap = [String : Any]()
        RequiredInfoMap = [
            "Name" : artistName!,
            "Tone Deaf App Id" : tDAppId,
            "Alternate Names" : altName,
            "Followers" : 0,
            "Time Registered To App" : newTime,
            "Date Registered To App" : newDate,
            "Youtube Music Profile URL" : url,
            "Linked To Account" : "",
            "Songs": [""],
            "Albums": [""],
            "Videos": [""]
        ]
        
        let RequiredRef = Database.database().reference().child("Registered Artists").child(artistRandomKey)
        if let legal = artistLegalName {
            RequiredRef.child("Legal Name").setValue(legal)
        }
        RequiredRef.updateChildValues(RequiredInfoMap) { [weak self] (error, songRef) in
            guard let strongSelf = self else {return}
            if let error = error {
                print("📕 Failed to upload dictionary to database: \(error)")
                Utilities.showError2("Failed to Upload. Please try again.", actionText: "OK")
                return
            } else {
                strongSelf.progressCompleted+=1
                strongSelf.progressView.progress = (strongSelf.progressCompleted/strongSelf.totalProgress)
                print("\(strongSelf.progressCompleted) out of \(strongSelf.totalProgress)")
                if strongSelf.progressCompleted == strongSelf.totalProgress {
                    strongSelf.alertView.dismiss(animated: true, completion: {[weak self] in
                        guard let strongSelf = self else {return}
                        Utilities.successBarBanner("Upload successful.")
                        _ = strongSelf.navigationController?.popViewController(animated: true)
                    })
                }
            }
        }
        
        Database.database().reference().child("All Content IDs").observeSingleEvent(of: .value, with: {[weak self] snap in
            guard let strongSelf = self else {return}
            var arr = snap.value as! [String]
            if !arr.contains("\(strongSelf.tDAppId)Æ\(strongSelf.artistName!)") {
                arr.append("\(strongSelf.tDAppId)Æ\(strongSelf.artistName!)")
            }
            Database.database().reference().child("All Content IDs").setValue(arr)
        })
        
        Database.database().reference().child("Registered Artists").child("All Artist IDs").observeSingleEvent(of: .value, with: {[weak self] snap in
            guard let strongSelf = self else {return}
            var arr = snap.value as! [String]
            if !arr.contains("\(strongSelf.tDAppId)Æ\(strongSelf.artistName!)") {
                arr.append("\(strongSelf.tDAppId)Æ\(strongSelf.artistName!)")
            }
            Database.database().reference().child("Registered Artists").child("All Artist IDs").setValue(arr)
        })
    }
    
    func amazonData() {
        guard amazonTextField.text != "" else {return}
        guard amazonTextField.text!.count > 15 else {return}
        alertView.message = "Gathering Amazon Music info..."
        let url = amazonTextField.text!
        
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone(identifier: "EDT")
        formatter.dateFormat = "MMMM dd, yyyy"
        let newDate = formatter.string(from: date)
        
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "HH:mm:ss a"
        timeFormatter.timeZone = TimeZone(identifier: "EDT")
        let newTime = timeFormatter.string(from: date)
        
        let artistRandomKey = ("\(artistName!)--\(newDate)--\(newTime)--\(tDAppId)")
        
        
        var RequiredInfoMap = [String : Any]()
        RequiredInfoMap = [
            "Name" : artistName!,
            "Tone Deaf App Id" : tDAppId,
            "Alternate Names" : altName,
            "Followers" : 0,
            "Time Registered To App" : newTime,
            "Date Registered To App" : newDate,
            "Amazon Profile URL" : url,
            "Linked To Account" : "",
            "Songs": [""],
            "Albums": [""],
            "Videos": [""]
        ]
        
        let RequiredRef = Database.database().reference().child("Registered Artists").child(artistRandomKey)
        if let legal = artistLegalName {
            RequiredRef.child("Legal Name").setValue(legal)
        }
        RequiredRef.updateChildValues(RequiredInfoMap) { [weak self] (error, songRef) in
            guard let strongSelf = self else {return}
            if let error = error {
                print("📕 Failed to upload dictionary to database: \(error)")
                Utilities.showError2("Failed to Upload. Please try again.", actionText: "OK")
                return
            } else {
                strongSelf.progressCompleted+=1
                strongSelf.progressView.progress = (strongSelf.progressCompleted/strongSelf.totalProgress)
                print("\(strongSelf.progressCompleted) out of \(strongSelf.totalProgress)")
                if strongSelf.progressCompleted == strongSelf.totalProgress {
                    strongSelf.alertView.dismiss(animated: true, completion: {[weak self] in
                        guard let strongSelf = self else {return}
                        Utilities.successBarBanner("Upload successful.")
                        _ = strongSelf.navigationController?.popViewController(animated: true)
                    })
                }
            }
        }
        
        Database.database().reference().child("All Content IDs").observeSingleEvent(of: .value, with: {[weak self] snap in
            guard let strongSelf = self else {return}
            var arr = snap.value as! [String]
            if !arr.contains("\(strongSelf.tDAppId)Æ\(strongSelf.artistName!)") {
                arr.append("\(strongSelf.tDAppId)Æ\(strongSelf.artistName!)")
            }
            Database.database().reference().child("All Content IDs").setValue(arr)
        })
        
        Database.database().reference().child("Registered Artists").child("All Artist IDs").observeSingleEvent(of: .value, with: {[weak self] snap in
            guard let strongSelf = self else {return}
            var arr = snap.value as! [String]
            if !arr.contains("\(strongSelf.tDAppId)Æ\(strongSelf.artistName!)") {
                arr.append("\(strongSelf.tDAppId)Æ\(strongSelf.artistName!)")
            }
            Database.database().reference().child("Registered Artists").child("All Artist IDs").setValue(arr)
        })
    }
    
    func deezerData() {
        guard deezerTextField.text != "" else {return}
        guard deezerTextField.text!.count > 15 else {return}
        alertView.message = "Gathering Deezer info..."
        let url = deezerTextField.text!
        
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone(identifier: "EDT")
        formatter.dateFormat = "MMMM dd, yyyy"
        let newDate = formatter.string(from: date)
        
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "HH:mm:ss a"
        timeFormatter.timeZone = TimeZone(identifier: "EDT")
        let newTime = timeFormatter.string(from: date)
        
        let artistRandomKey = ("\(artistName!)--\(newDate)--\(newTime)--\(tDAppId)")
        
        
        var RequiredInfoMap = [String : Any]()
        RequiredInfoMap = [
            "Name" : artistName!,
            "Tone Deaf App Id" : tDAppId,
            "Alternate Names" : altName,
            "Followers" : 0,
            "Time Registered To App" : newTime,
            "Date Registered To App" : newDate,
            "Deezer Profile URL" : url,
            "Linked To Account" : "",
            "Songs": [""],
            "Albums": [""],
            "Videos": [""]
        ]
        
        let RequiredRef = Database.database().reference().child("Registered Artists").child(artistRandomKey)
        if let legal = artistLegalName {
            RequiredRef.child("Legal Name").setValue(legal)
        }
        RequiredRef.updateChildValues(RequiredInfoMap) { [weak self] (error, songRef) in
            guard let strongSelf = self else {return}
            if let error = error {
                print("📕 Failed to upload dictionary to database: \(error)")
                Utilities.showError2("Failed to Upload. Please try again.", actionText: "OK")
                return
            } else {
                strongSelf.progressCompleted+=1
                strongSelf.progressView.progress = (strongSelf.progressCompleted/strongSelf.totalProgress)
                print("\(strongSelf.progressCompleted) out of \(strongSelf.totalProgress)")
                if strongSelf.progressCompleted == strongSelf.totalProgress {
                    strongSelf.alertView.dismiss(animated: true, completion: {[weak self] in
                        guard let strongSelf = self else {return}
                        Utilities.successBarBanner("Upload successful.")
                        _ = strongSelf.navigationController?.popViewController(animated: true)
                    })
                }
            }
        }
        
        Database.database().reference().child("All Content IDs").observeSingleEvent(of: .value, with: {[weak self] snap in
            guard let strongSelf = self else {return}
            var arr = snap.value as! [String]
            if !arr.contains("\(strongSelf.tDAppId)Æ\(strongSelf.artistName!)") {
                arr.append("\(strongSelf.tDAppId)Æ\(strongSelf.artistName!)")
            }
            Database.database().reference().child("All Content IDs").setValue(arr)
        })
        
        Database.database().reference().child("Registered Artists").child("All Artist IDs").observeSingleEvent(of: .value, with: {[weak self] snap in
            guard let strongSelf = self else {return}
            var arr = snap.value as! [String]
            if !arr.contains("\(strongSelf.tDAppId)Æ\(strongSelf.artistName!)") {
                arr.append("\(strongSelf.tDAppId)Æ\(strongSelf.artistName!)")
            }
            Database.database().reference().child("Registered Artists").child("All Artist IDs").setValue(arr)
        })
    }
    
    func spinrillaData() {
        guard spinrillaTextField.text != "" else {return}
        guard spinrillaTextField.text!.count > 15 else {return}
        alertView.message = "Gathering Spinrilla info..."
        let url = spinrillaTextField.text!
        
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone(identifier: "EDT")
        formatter.dateFormat = "MMMM dd, yyyy"
        let newDate = formatter.string(from: date)
        
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "HH:mm:ss a"
        timeFormatter.timeZone = TimeZone(identifier: "EDT")
        let newTime = timeFormatter.string(from: date)
        
        let artistRandomKey = ("\(artistName!)--\(newDate)--\(newTime)--\(tDAppId)")
        
        
        var RequiredInfoMap = [String : Any]()
        RequiredInfoMap = [
            "Name" : artistName!,
            "Tone Deaf App Id" : tDAppId,
            "Alternate Names" : altName,
            "Followers" : 0,
            "Time Registered To App" : newTime,
            "Date Registered To App" : newDate,
            "Spinrilla Profile URL" : url,
            "Linked To Account" : "",
            "Songs": [""],
            "Albums": [""],
            "Videos": [""]
        ]
        
        let RequiredRef = Database.database().reference().child("Registered Artists").child(artistRandomKey)
        if let legal = artistLegalName {
            RequiredRef.child("Legal Name").setValue(legal)
        }
        RequiredRef.updateChildValues(RequiredInfoMap) { [weak self] (error, songRef) in
            guard let strongSelf = self else {return}
            if let error = error {
                print("📕 Failed to upload dictionary to database: \(error)")
                Utilities.showError2("Failed to Upload. Please try again.", actionText: "OK")
                return
            } else {
                strongSelf.progressCompleted+=1
                strongSelf.progressView.progress = (strongSelf.progressCompleted/strongSelf.totalProgress)
                print("\(strongSelf.progressCompleted) out of \(strongSelf.totalProgress)")
                if strongSelf.progressCompleted == strongSelf.totalProgress {
                    strongSelf.alertView.dismiss(animated: true, completion: {[weak self] in
                        guard let strongSelf = self else {return}
                        Utilities.successBarBanner("Upload successful.")
                        _ = strongSelf.navigationController?.popViewController(animated: true)
                    })
                }
            }
        }
        
        Database.database().reference().child("All Content IDs").observeSingleEvent(of: .value, with: {[weak self] snap in
            guard let strongSelf = self else {return}
            var arr = snap.value as! [String]
            if !arr.contains("\(strongSelf.tDAppId)Æ\(strongSelf.artistName!)") {
                arr.append("\(strongSelf.tDAppId)Æ\(strongSelf.artistName!)")
            }
            Database.database().reference().child("All Content IDs").setValue(arr)
        })
        
        Database.database().reference().child("Registered Artists").child("All Artist IDs").observeSingleEvent(of: .value, with: {[weak self] snap in
            guard let strongSelf = self else {return}
            var arr = snap.value as! [String]
            if !arr.contains("\(strongSelf.tDAppId)Æ\(strongSelf.artistName!)") {
                arr.append("\(strongSelf.tDAppId)Æ\(strongSelf.artistName!)")
            }
            Database.database().reference().child("Registered Artists").child("All Artist IDs").setValue(arr)
        })
    }
    
    func napsterData() {
        guard napsterTextField.text != "" else {return}
        guard napsterTextField.text!.count > 15 else {return}
        alertView.message = "Gathering Napster info..."
        let url = napsterTextField.text!
        
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone(identifier: "EDT")
        formatter.dateFormat = "MMMM dd, yyyy"
        let newDate = formatter.string(from: date)
        
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "HH:mm:ss a"
        timeFormatter.timeZone = TimeZone(identifier: "EDT")
        let newTime = timeFormatter.string(from: date)
        
        let artistRandomKey = ("\(artistName!)--\(newDate)--\(newTime)--\(tDAppId)")
        
        
        var RequiredInfoMap = [String : Any]()
        RequiredInfoMap = [
            "Name" : artistName!,
            "Tone Deaf App Id" : tDAppId,
            "Alternate Names" : altName,
            "Followers" : 0,
            "Time Registered To App" : newTime,
            "Date Registered To App" : newDate,
            "Napster Profile URL" : url,
            "Linked To Account" : "",
            "Songs": [""],
            "Albums": [""],
            "Videos": [""]
        ]
        
        let RequiredRef = Database.database().reference().child("Registered Artists").child(artistRandomKey)
        if let legal = artistLegalName {
            RequiredRef.child("Legal Name").setValue(legal)
        }
        RequiredRef.updateChildValues(RequiredInfoMap) { [weak self] (error, songRef) in
            guard let strongSelf = self else {return}
            if let error = error {
                print("📕 Failed to upload dictionary to database: \(error)")
                Utilities.showError2("Failed to Upload. Please try again.", actionText: "OK")
                return
            } else {
                strongSelf.progressCompleted+=1
                strongSelf.progressView.progress = (strongSelf.progressCompleted/strongSelf.totalProgress)
                print("\(strongSelf.progressCompleted) out of \(strongSelf.totalProgress)")
                if strongSelf.progressCompleted == strongSelf.totalProgress {
                    strongSelf.alertView.dismiss(animated: true, completion: {[weak self] in
                        guard let strongSelf = self else {return}
                        Utilities.successBarBanner("Upload successful.")
                        _ = strongSelf.navigationController?.popViewController(animated: true)
                    })
                }
            }
        }
        
        Database.database().reference().child("All Content IDs").observeSingleEvent(of: .value, with: {[weak self] snap in
            guard let strongSelf = self else {return}
            var arr = snap.value as! [String]
            if !arr.contains("\(strongSelf.tDAppId)Æ\(strongSelf.artistName!)") {
                arr.append("\(strongSelf.tDAppId)Æ\(strongSelf.artistName!)")
            }
            Database.database().reference().child("All Content IDs").setValue(arr)
        })
        
        Database.database().reference().child("Registered Artists").child("All Artist IDs").observeSingleEvent(of: .value, with: {[weak self] snap in
            guard let strongSelf = self else {return}
            var arr = snap.value as! [String]
            if !arr.contains("\(strongSelf.tDAppId)Æ\(strongSelf.artistName!)") {
                arr.append("\(strongSelf.tDAppId)Æ\(strongSelf.artistName!)")
            }
            Database.database().reference().child("Registered Artists").child("All Artist IDs").setValue(arr)
        })
    }
    
    func tidalData() {
        guard tidalTextField.text != "" else {return}
        guard tidalTextField.text!.count > 15 else {return}
        alertView.message = "Gathering Tidal info..."
        let url = tidalTextField.text!
        
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone(identifier: "EDT")
        formatter.dateFormat = "MMMM dd, yyyy"
        let newDate = formatter.string(from: date)
        
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "HH:mm:ss a"
        timeFormatter.timeZone = TimeZone(identifier: "EDT")
        let newTime = timeFormatter.string(from: date)
        
        let artistRandomKey = ("\(artistName!)--\(newDate)--\(newTime)--\(tDAppId)")
        
        
        var RequiredInfoMap = [String : Any]()
        RequiredInfoMap = [
            "Name" : artistName!,
            "Tone Deaf App Id" : tDAppId,
            "Alternate Names" : altName,
            "Followers" : 0,
            "Time Registered To App" : newTime,
            "Date Registered To App" : newDate,
            "Tidal Profile URL" : url,
            "Linked To Account" : "",
            "Songs": [""],
            "Albums": [""],
            "Videos": [""]
        ]
        
        let RequiredRef = Database.database().reference().child("Registered Artists").child(artistRandomKey)
        if let legal = artistLegalName {
            RequiredRef.child("Legal Name").setValue(legal)
        }
        RequiredRef.updateChildValues(RequiredInfoMap) { [weak self] (error, songRef) in
            guard let strongSelf = self else {return}
            if let error = error {
                print("📕 Failed to upload dictionary to database: \(error)")
                Utilities.showError2("Failed to Upload. Please try again.", actionText: "OK")
                return
            } else {
                strongSelf.progressCompleted+=1
                strongSelf.progressView.progress = (strongSelf.progressCompleted/strongSelf.totalProgress)
                print("\(strongSelf.progressCompleted) out of \(strongSelf.totalProgress)")
                if strongSelf.progressCompleted == strongSelf.totalProgress {
                    strongSelf.alertView.dismiss(animated: true, completion: {[weak self] in
                        guard let strongSelf = self else {return}
                        Utilities.successBarBanner("Upload successful.")
                        _ = strongSelf.navigationController?.popViewController(animated: true)
                    })
                }
            }
        }
        
        Database.database().reference().child("All Content IDs").observeSingleEvent(of: .value, with: {[weak self] snap in
            guard let strongSelf = self else {return}
            var arr = snap.value as! [String]
            if !arr.contains("\(strongSelf.tDAppId)Æ\(strongSelf.artistName!)") {
                arr.append("\(strongSelf.tDAppId)Æ\(strongSelf.artistName!)")
            }
            Database.database().reference().child("All Content IDs").setValue(arr)
        })
        
        Database.database().reference().child("Registered Artists").child("All Artist IDs").observeSingleEvent(of: .value, with: {[weak self] snap in
            guard let strongSelf = self else {return}
            var arr = snap.value as! [String]
            if !arr.contains("\(strongSelf.tDAppId)Æ\(strongSelf.artistName!)") {
                arr.append("\(strongSelf.tDAppId)Æ\(strongSelf.artistName!)")
            }
            Database.database().reference().child("Registered Artists").child("All Artist IDs").setValue(arr)
        })
    }
    
    func basicArtist() {
    alertView.message = "Gathering Basic info..."
    
    let formatter = DateFormatter()
    formatter.timeZone = TimeZone(identifier: "EDT")
    formatter.dateFormat = "MMMM dd, yyyy"
    let newDate = formatter.string(from: date)
    
    let timeFormatter = DateFormatter()
    timeFormatter.dateFormat = "HH:mm:ss a"
    timeFormatter.timeZone = TimeZone(identifier: "EDT")
    let newTime = timeFormatter.string(from: date)
    
    let artistRandomKey = ("\(artistName!)--\(newDate)--\(newTime)--\(tDAppId)")
    
    
    var RequiredInfoMap = [String : Any]()
    RequiredInfoMap = [
        "Name" : artistName!,
        "Tone Deaf App Id" : tDAppId,
        "Alternate Names" : altName,
        "Followers" : 0,
        "Time Registered To App" : newTime,
        "Date Registered To App" : newDate,
        "Linked To Account" : "",
        "Songs": [""],
        "Albums": [""],
        "Videos": [""]
    ]
    
    let RequiredRef = Database.database().reference().child("Registered Artists").child(artistRandomKey)
        if let legal = artistLegalName {
            RequiredRef.child("Legal Name").setValue(legal)
        }
    RequiredRef.updateChildValues(RequiredInfoMap) { [weak self] (error, songRef) in
        guard let strongSelf = self else {return}
        if let error = error {
            print("📕 Failed to upload dictionary to database: \(error)")
            Utilities.showError2("Failed to Upload. Please try again.", actionText: "OK")
            return
        } else {
            strongSelf.alertView.dismiss(animated: true, completion: {[weak self] in
                guard let strongSelf = self else {return}
                Utilities.successBarBanner("Upload successful.")
                _ = strongSelf.navigationController?.popViewController(animated: true)
            })
        }
    }
    
    Database.database().reference().child("All Content IDs").observeSingleEvent(of: .value, with: {[weak self] snap in
        guard let strongSelf = self else {return}
        var arr = snap.value as! [String]
        if !arr.contains("\(strongSelf.tDAppId)Æ\(strongSelf.artistName!)") {
            arr.append("\(strongSelf.tDAppId)Æ\(strongSelf.artistName!)")
        }
        Database.database().reference().child("All Content IDs").setValue(arr)
    })
    
    Database.database().reference().child("Registered Artists").child("All Artist IDs").observeSingleEvent(of: .value, with: {[weak self] snap in
        guard let strongSelf = self else {return}
        var arr = snap.value as! [String]
        if !arr.contains("\(strongSelf.tDAppId)Æ\(strongSelf.artistName!)") {
            arr.append("\(strongSelf.tDAppId)Æ\(strongSelf.artistName!)")
        }
        Database.database().reference().child("Registered Artists").child("All Artist IDs").setValue(arr)
    })
    }
    
    func addBottomLineToText(_ textfield:UITextField) {
        let bottomLine = CALayer()

        bottomLine.frame = CGRect(x: 0,
                                  y: textfield.frame.height - 1,
                                  width: textfield.frame.size.width - 40,//textfield.frame.width,
                                  height: 2)

        bottomLine.backgroundColor = UIColor.init(red: 182/255, green: 0/255, blue: 3/255, alpha: 0.87).cgColor

        textfield.layer.addSublayer(bottomLine)
    }
    
    func dismissKeyboardOnTap() {
        let tap = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        scrollView.keyboardDismissMode = .onDrag
    }
    
}

extension ArtistUploadViewController : UITextFieldDelegate {
  // when user select a textfield, this method will be called
  func textFieldDidBeginEditing(_ textField: UITextField) {
    // set the activeTextField to the selected textfield
    self.activeTextField = textField
  }
    
  // when user click 'done' or dismiss the keyboard
  func textFieldDidEndEditing(_ textField: UITextField) {
    self.activeTextField = nil
  }
}
