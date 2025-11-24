//
//  PersonUploadViewController.swift
//  ToneDeafDeafinitionsApp
//
//  Created by Tone Deaf on 9/4/20.
//  Copyright © 2020 GITEM Solutions. All rights reserved.
//

import UIKit
import FirebaseDatabase

class PersonUploadViewController: UIViewController {
    
    @IBOutlet weak var scrollView:UIScrollView!
    @IBOutlet weak var personAltNamesTableView: UITableView!
    @IBOutlet weak var personAltNamesHeightConstraint: NSLayoutConstraint!

    @IBOutlet weak var personNameTextField: UITextField! {
        didSet {
            let placeholderText = NSAttributedString(string: "Name",
                                                     attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray.withAlphaComponent(0.4)])
            
            personNameTextField.attributedPlaceholder = placeholderText
        }
    }
    @IBOutlet weak var personLegalNameTextField: UITextField! {
        didSet {
            let placeholderText = NSAttributedString(string: "Name",
                                                     attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray.withAlphaComponent(0.4)])
            
            personLegalNameTextField.attributedPlaceholder = placeholderText
        }
    }
    @IBOutlet weak var spotifyTextField: UITextField! {
        didSet {
            let placeholderText = NSAttributedString(string: "?si=",
                                                     attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray.withAlphaComponent(0.4)])
            
            spotifyTextField.attributedPlaceholder = placeholderText
        }
    }
    @IBOutlet weak var appleTextField: UITextField! {
        didSet {
            let placeholderText = NSAttributedString(string: "artist/",
                                                     attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray.withAlphaComponent(0.4)])
            
            appleTextField.attributedPlaceholder = placeholderText
        }
    }
    @IBOutlet weak var facebookTextField: UITextField! {
        didSet {
            let placeholderText = NSAttributedString(string: "URL",
                                                     attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray.withAlphaComponent(0.4)])
            
            facebookTextField.attributedPlaceholder = placeholderText
        }
    }
    @IBOutlet weak var tikTokTextField: UITextField! {
        didSet {
            let placeholderText = NSAttributedString(string: "URL",
                                                     attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray.withAlphaComponent(0.4)])
            
            tikTokTextField.attributedPlaceholder = placeholderText
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
            let placeholderText = NSAttributedString(string: "artist/",
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
    
    @IBOutlet weak var instagramTextField: UITextField! {
        didSet {
            let placeholderText = NSAttributedString(string: "IG link",
                                                     attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray.withAlphaComponent(0.4)])
            
            instagramTextField.attributedPlaceholder = placeholderText
        }
    }
    
    @IBOutlet weak var twitterTextField: UITextField! {
        didSet {
            let placeholderText = NSAttributedString(string: "Profile link",
                                                     attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray.withAlphaComponent(0.4)])
            
            twitterTextField.attributedPlaceholder = placeholderText
        }
    }
    @IBOutlet weak var mainRoleTextField: UITextField!{
        didSet {
            let placeholderText = NSAttributedString(string: "Select Role",
                                                     attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray.withAlphaComponent(0.4)])
            
            mainRoleTextField.attributedPlaceholder = placeholderText
        }
    }
    @IBOutlet weak var verificationLevelTextField: UITextField!{
        didSet {
            let placeholderText = NSAttributedString(string: "Select Level",
                                                     attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray.withAlphaComponent(0.4)])
            
            verificationLevelTextField.attributedPlaceholder = placeholderText
        }
    }
    @IBOutlet weak var industryCertificationControl: UISegmentedControl!
    
    var verificationLevelPickerView = UIPickerView()
    var verificationLevelArr:[Character] = Constants.Verification.verificationLevels
    var verificationLevel:Character!
    
    var industryCertified:Bool = false
    
    var mainRolePickerView = UIPickerView()
    var roleArr:[String] = ["Artist", "Producer", "Engineer", "Writer", "Videographer"]
    var role:String = ""
    
    var progressView:UIProgressView!
    var totalProgress:Float = 1
    var progressCompleted:Float = 0
    
    var alertView:UIAlertController!
    
    var activeTextField : UITextField? = nil
    
    private var personName:String!
    private var personLegalName:String!
    var altName:Array<String> = []
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
        print("📗 Person Upload being deallocated from memory. OS reclaiming")
    }
    
    func setUpElements() {
        Utilities.styleTextField(personNameTextField)
        addBottomLineToText(personNameTextField)
        
        personAltNamesTableView.delegate = self
        personAltNamesTableView.dataSource = self
        personAltNamesHeightConstraint.constant = CGFloat(50*(altName.count))
        
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
        
        Utilities.styleTextField(mainRoleTextField)
        addBottomLineToText(mainRoleTextField)
        mainRoleTextField.delegate = self
        
        Utilities.styleTextField(personLegalNameTextField)
        addBottomLineToText(personLegalNameTextField)
        personLegalNameTextField.delegate = self
        
        Utilities.styleTextField(tikTokTextField)
        addBottomLineToText(tikTokTextField)
        tikTokTextField.delegate = self
        
        Utilities.styleTextField(verificationLevelTextField)
        addBottomLineToText(verificationLevelTextField)
        verificationLevelTextField.delegate = self
        
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
        
        
        mainRoleTextField.inputView = mainRolePickerView
        mainRolePickerView.delegate = self
        mainRolePickerView.dataSource = self
        pickerViewToolbar(textField: mainRoleTextField, pickerView: mainRolePickerView)
        
        verificationLevelTextField.inputView = verificationLevelPickerView
        verificationLevelPickerView.delegate = self
        verificationLevelPickerView.dataSource = self
        pickerViewToolbar(textField: verificationLevelTextField, pickerView: verificationLevelPickerView)
        
    }
    
    @IBAction func addAltNameTapped(_ sender: Any) {
        let alertC = UIAlertController(title: "Add Alternate Name",
                                                message: "Please type in a name.",
                                                preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Add", style: .default, handler: {[weak self] _ in
            guard let strongSelf = self else {return}
            let field = alertC.textFields![0]
            if field.text != "" {
                guard let name = field.text else {return}
                var newNames:[String] = []
                newNames = strongSelf.altName
                newNames.append(name)
                strongSelf.altName = newNames
                strongSelf.personAltNamesTableView.reloadData()
                strongSelf.personAltNamesHeightConstraint.constant = CGFloat(50*(newNames.count))
                alertC.dismiss(animated: true, completion: nil)
            } else {
                alertC.dismiss(animated: true, completion: nil)
            }
        })
        alertC.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alertC.addAction(okAction)
        alertC.addTextField()
        alertC.view.tintColor = Constants.Colors.redApp
        self.present(alertC, animated: true)
    }
    
    @IBAction func industryCertificationChanged(_ sender: Any) {
        if industryCertificationControl.selectedSegmentIndex == 1 {
            industryCertificationControl.selectedSegmentTintColor = .systemGreen
            industryCertified = true
            //true
        } else {
            industryCertificationControl.selectedSegmentTintColor = Constants.Colors.redApp
            industryCertified = false
            //false
        }
    }
    
    @IBAction func uploadPersonButtonTapped(_ sender: Any) {
        date = Date()
        guard personNameTextField.text != "" else {
            Utilities.showError2("Person name required"  ,actionText: "Ok")
            return
        }
        guard mainRoleTextField.text != "" else {
            Utilities.showError2("Person role required"  ,actionText: "Ok")
            return
        }
        guard verificationLevelTextField.text != "" else {
            Utilities.showError2("Verification Level required"  ,actionText: "Ok")
            return
        }
        if personLegalNameTextField.text != "" {
            personLegalName = personLegalNameTextField.text!
        }
        personName = personNameTextField.text!
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
        if tikTokTextField.text != "", tikTokTextField.text!.count > 3 {
            totalProgress+=1
        }
        alertView = UIAlertController(title: "Uploading \(personName!)", message: "Preparing...", preferredStyle: .alert)
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
    
    func generateAppId() {
        genid = StorageManager.shared.generateRandomNumber(digits: 6)
        DatabaseManager.shared.checkIfPersonAppIdExists(appid: genid, completion: { [weak self] result in
            guard let strongSelf = self else {return}
            print(result)
            
            if result == true {
                strongSelf.generateAppId()
            } else {
                strongSelf.progressCompleted+=1
                strongSelf.progressView.progress = (strongSelf.progressCompleted/strongSelf.totalProgress)
                print("\(strongSelf.progressCompleted) out of \(strongSelf.totalProgress)")
                strongSelf.tDAppId = strongSelf.genid
                if strongSelf.progressCompleted == strongSelf.totalProgress {
                    strongSelf.basicPerson()
                } else {
                    strongSelf.gatherUploadData()
                }
                
            }
        })
    }
    
    func gatherUploadData() {
        
        spotifyData()
        appleData()
        instagramData()
        twitterData()
        facebookData()
        soundcloudData()
        youTubeMusicData()
        youtubeData()
        amazonData()
        deezerData()
        spinrillaData()
        napsterData()
        tidalData()
        tiktokData()
        
//        if spotifyTextField.text != "" {
//            spotifyData()
//        } else {
//            saveManualSpotifyProducer()
//        }
//        if appleTextField.text!.count < 15 {
//
//            saveManualAppleProducer()
//        }
    }
    
    func spotifyData() {
        guard spotifyTextField.text != "" else {return}
        guard spotifyTextField.text!.count > 15 else {
            Utilities.showError2("Please enter a valid Spotify URL."  ,actionText: "Ok")
            return}
        alertView.message = "Gathering Spotify info..."
        var spotUrl = spotifyTextField.text!
        if let dotRange = spotUrl.range(of: "?") {
            spotUrl.removeSubrange(dotRange.lowerBound..<spotUrl.endIndex)
        }
        let songId = String(spotUrl.suffix(22))
        let token = (UserDefaults.standard.object(forKey: "SPTaccesstoken") as? String)!
        SpotifyRequest.shared.getArtistInfo(accessToken: token, id: songId, name: personName, altName: altName, mainRole: role, dateobj: date, appid: tDAppId, legal: personLegalName, tag: "pro", certifi: industryCertified, verifi: verificationLevel, completion: {[weak self] result in
            guard let strongSelf = self else {return}
            switch result {
            case .success(_):
                strongSelf.progressCompleted+=1
                strongSelf.progressView.progress = (strongSelf.progressCompleted/strongSelf.totalProgress)
                print("\(strongSelf.progressCompleted) out of \(strongSelf.totalProgress)")
                if strongSelf.progressCompleted == strongSelf.totalProgress {
                    strongSelf.alertView.dismiss(animated: true, completion: {
                        Utilities.successBarBanner("Upload successful.")
                        _ = strongSelf.navigationController?.popViewController(animated: true)
                    })
                }
            case .failure(let err):
            print(err)
                strongSelf.alertView.dismiss(animated: true, completion: {
//                    strongSelf.progressCompleted = 0
//                    strongSelf.totalProgress = 1
                    Utilities.showError2("Failed to Upload. Please try again. \(err)", actionText: "OK")
                    //_ = strongSelf.navigationController?.popViewController(animated: true)
                })
            }
        })
    }
    
    func appleData() {
        guard appleTextField.text != "" else {return}
        guard appleTextField.text!.count > 15 else {
            Utilities.showError2("Please enter a valid Apple URL."  ,actionText: "Ok")
            return}
        alertView.message = "Gathering Apple Music info..."
        let artistId = String((appleTextField.text?.suffix(10))!)
        AppleMusicRequest.shared.getAppleMusicArtist(id: artistId, name: personName, altName: altName, mainRole: role, dateobj: date, appid: tDAppId, legal: personLegalName, tag: "pro", certifi: industryCertified, verifi: verificationLevel, completion: {[weak self] result in
            guard let strongSelf = self else {return}
            switch result {
            case .success(_):
                strongSelf.progressCompleted+=1
                strongSelf.progressView.progress = (strongSelf.progressCompleted/strongSelf.totalProgress)
                print("\(strongSelf.progressCompleted) out of \(strongSelf.totalProgress)")
                if strongSelf.progressCompleted == strongSelf.totalProgress {
                    strongSelf.alertView.dismiss(animated: true, completion: {
                        Utilities.successBarBanner("Upload successful.")
                        _ = strongSelf.navigationController?.popViewController(animated: true)
                    })
                }
            case .failure(let err):
            print(err)
                Utilities.showError2("Failed to Upload. Please try again.", actionText: "OK")
            }
        })
    }
    
    func tiktokData() {
        guard tikTokTextField.text != "" else {return}
        guard tikTokTextField.text!.count > 15 else {return}
        alertView.message = "Gathering TikTok info..."
        let url = tikTokTextField.text!
        
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone(identifier: "EDT")
        formatter.dateFormat = "MMMM dd, yyyy"
        let newDate = formatter.string(from: date)
        
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "HH:mm:ss a"
        timeFormatter.timeZone = TimeZone(identifier: "EDT")
        let newTime = timeFormatter.string(from: date)
        
        let artistRandomKey = ("\(personName!)--\(newDate)--\(newTime)--\(tDAppId)")
        
        
        var RequiredInfoMap = [String : Any]()
        RequiredInfoMap = [
            "Name" : personName!,
            "Tone Deaf App Id" : tDAppId,
            "Alternate Names" : altName,
            "Main Role": role,
            "Followers" : 0,
            "Time Registered To App" : newTime,
            "Date Registered To App" : newDate,
            "TikTok": [
                "URL": url,
                "Active Status": false
            ],
            "Songs": [],
            "Albums": [],
            "Videos": [],
            "Beats": [],
            "Instrumentals": [],
            "Active Status": false,
            "Verification Level": String(verificationLevel) as? String,
            "Industry Certified": industryCertified
        ]
        
        let RequiredRef = Database.database().reference().child("Registered Persons").child(artistRandomKey)
        if let legal = personLegalName {
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
            if !(snap.value is NSNull) {
                var arr = snap.value as! [String]
                if !arr.contains("\(strongSelf.tDAppId)") {
                    arr.append("\(strongSelf.tDAppId)")
                }
                Database.database().reference().child("All Content IDs").setValue(arr)
            }
            else {
                let arr = ["\(strongSelf.tDAppId)Æ\(strongSelf.personName!)"]
                Database.database().reference().child("All Content IDs").setValue(arr)
            }
        })
    
        Database.database().reference().child("Registered Persons").child("All Person IDs").observeSingleEvent(of: .value, with: {[weak self] snap in
            guard let strongSelf = self else {return}
            if !(snap.value is NSNull) {
                var arr = snap.value as! [String]
                if !arr.contains("\(strongSelf.tDAppId)") {
                    arr.append("\(strongSelf.tDAppId)")
                }
                Database.database().reference().child("Registered Persons").child("All Person IDs").setValue(arr)
            }
            else {
                let arr = ["\(strongSelf.tDAppId)Æ\(strongSelf.personName!)"]
                Database.database().reference().child("Registered Persons").child("All Person IDs").setValue(arr)
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
        
        let personRandomKey = ("\(personName!)--\(newDate)--\(newTime)--\(tDAppId)")
        
        
        var RequiredInfoMap = [String : Any]()
        RequiredInfoMap = [
            "Name" : personName!,
            "Tone Deaf App Id" : tDAppId,
            "Alternate Names" : altName,
            "Main Role": role,
            "Followers" : 0,
            "Time Registered To App" : newTime,
            "Date Registered To App" : newDate,
            "Instagram": [
                "URL": url,
                "Active Status": false
            ],
            "Songs": [],
            "Albums": [],
            "Videos": [],
            "Beats": [],
            "Instrumentals": [],
            "Active Status": false,
            "Verification Level": String(verificationLevel),
            "Industry Certified": industryCertified
        ]
        
        let RequiredRef = Database.database().reference().child("Registered Persons").child(personRandomKey)
        if let legal = personLegalName {
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
            if !(snap.value is NSNull) {
                var arr = snap.value as! [String]
                if !arr.contains("\(strongSelf.tDAppId)") {
                    arr.append("\(strongSelf.tDAppId)")
                }
                Database.database().reference().child("All Content IDs").setValue(arr)
            }
            else {
                let arr = ["\(strongSelf.tDAppId)"]
                Database.database().reference().child("All Content IDs").setValue(arr)
            }
        })
        
        Database.database().reference().child("Registered Persons").child("All Person IDs").observeSingleEvent(of: .value, with: {[weak self] snap in
            guard let strongSelf = self else {return}
            if !(snap.value is NSNull) {
                var arr = snap.value as! [String]
                if !arr.contains("\(strongSelf.tDAppId)") {
                    arr.append("\(strongSelf.tDAppId)")
                }
                Database.database().reference().child("Registered Persons").child("All Person IDs").setValue(arr)
            }
            else {
                let arr = ["\(strongSelf.tDAppId)"]
                Database.database().reference().child("Registered Persons").child("All Person IDs").setValue(arr)
            }
        })
    }
    
    func twitterData() {
        guard twitterTextField.text != "" else {return}
        guard twitterTextField.text!.count > 15 else {return}
        alertView.message = "Gathering Twitter info..."
        
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone(identifier: "EDT")
        formatter.dateFormat = "MMMM dd, yyyy"
        let newDate = formatter.string(from: date)
        
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "HH:mm:ss a"
        timeFormatter.timeZone = TimeZone(identifier: "EDT")
        let newTime = timeFormatter.string(from: date)
        
        let artistRandomKey = ("\(personName!)--\(newDate)--\(newTime)--\(tDAppId)")
        DispatchQueue.main.async {[weak self] in
            guard let strongSelf = self else {return}
            var url = strongSelf.twitterTextField.text!
            var videoId = ""
            
            if !url.contains("twitter.com/") {
                mediumImpactGenerator.impactOccurred()
                Utilities.showError2("Twitter url Invalid error", actionText: "OK")
                return
            }
            if let dotRange = url.range(of: "?s=") {
                url.removeSubrange(dotRange.lowerBound..<url.endIndex)
            }
            if let range = url.range(of: "twitter.com/") {
                url.removeSubrange(url.startIndex..<range.lowerBound)
            }
            
            let split = String(url.dropFirst(12))
            videoId = String(split)
             
            TwitterRequest.shared.getPerson(username: videoId, completion: { result in
                switch result {
                case.success(let person):
                    var RequiredInfoMap = [String : Any]()
                    RequiredInfoMap = [
                        "Name" : strongSelf.personName!,
                        "Tone Deaf App Id" : strongSelf.tDAppId,
                        "Alternate Names" : strongSelf.altName,
                        "Main Role": strongSelf.role,
                        "Followers" : 0,
                        "Time Registered To App" : newTime,
                        "Date Registered To App" : newDate,
                        "Twitter" : [
                            "id": person.twitterId,
                            "Date Created": person.dateCreated,
                            "Name": person.name,
                            "Username": person.userName,
                            "Profile Image URL": person.profileImageURL,
                            "URL": person.url,
                            "Active Status": false
                        ],
                        "Songs": [],
                        "Albums": [],
                        "Videos": [],
                        "Beats": [],
                        "Instrumentals": [],
                        "Active Status": false,
                        "Verification Level": String(strongSelf.verificationLevel),
                        "Industry Certified": strongSelf.industryCertified
                    ]
                    
                    let RequiredRef = Database.database().reference().child("Registered Persons").child(artistRandomKey)
                    if let legal = strongSelf.personLegalName {
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
                        if !(snap.value is NSNull) {
                            var arr = snap.value as! [String]
                            if !arr.contains("\(strongSelf.tDAppId)") {
                                arr.append("\(strongSelf.tDAppId)")
                            }
                            Database.database().reference().child("All Content IDs").setValue(arr)
                        }
                        else {
                            let arr = ["\(strongSelf.tDAppId)"]
                            Database.database().reference().child("All Content IDs").setValue(arr)
                        }
                    })
                    
                    Database.database().reference().child("Registered Persons").child("All Person IDs").observeSingleEvent(of: .value, with: {[weak self] snap in
                        guard let strongSelf = self else {return}
                        if !(snap.value is NSNull) {
                            var arr = snap.value as! [String]
                            if !arr.contains("\(strongSelf.tDAppId)") {
                                arr.append("\(strongSelf.tDAppId)")
                            }
                            Database.database().reference().child("Registered Persons").child("All Person IDs").setValue(arr)
                        }
                        else {
                            let arr = ["\(strongSelf.tDAppId)"]
                            Database.database().reference().child("Registered Persons").child("All Person IDs").setValue(arr)
                        }
                    })
                case .failure(let error):
                    mediumImpactGenerator.impactOccurred()
                    Utilities.showError2("Twitter Person error", actionText: "OK")
                    return
                }
            })
        }
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
        
        let artistRandomKey = ("\(personName!)--\(newDate)--\(newTime)--\(tDAppId)")
        
        
        var RequiredInfoMap = [String : Any]()
        RequiredInfoMap = [
            "Name" : personName!,
            "Tone Deaf App Id" : tDAppId,
            "Alternate Names" : altName,
            "Main Role": role,
            "Followers" : 0,
            "Time Registered To App" : newTime,
            "Date Registered To App" : newDate,
            "Facebook": [
                "URL": url,
                "Active Status": false
            ],
            "Songs": [],
            "Albums": [],
            "Videos": [],
            "Beats": [],
            "Instrumentals": [],
            "Active Status": false,
            "Verification Level": String(verificationLevel),
            "Industry Certified": industryCertified
        ]
        
        let RequiredRef = Database.database().reference().child("Registered Persons").child(artistRandomKey)
        if let legal = personLegalName {
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
            if !(snap.value is NSNull) {
                var arr = snap.value as! [String]
                if !arr.contains("\(strongSelf.tDAppId)") {
                    arr.append("\(strongSelf.tDAppId)")
                }
                Database.database().reference().child("All Content IDs").setValue(arr)
            }
            else {
                let arr = ["\(strongSelf.tDAppId)"]
                Database.database().reference().child("All Content IDs").setValue(arr)
            }
        })
        
        Database.database().reference().child("Registered Persons").child("All Person IDs").observeSingleEvent(of: .value, with: {[weak self] snap in
            guard let strongSelf = self else {return}
            if !(snap.value is NSNull) {
                var arr = snap.value as! [String]
                if !arr.contains("\(strongSelf.tDAppId)") {
                    arr.append("\(strongSelf.tDAppId)")
                }
                Database.database().reference().child("Registered Persons").child("All Person IDs").setValue(arr)
            }
            else {
                let arr = ["\(strongSelf.tDAppId)"]
                Database.database().reference().child("Registered Persons").child("All Person IDs").setValue(arr)
            }
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
        
        let artistRandomKey = ("\(personName!)--\(newDate)--\(newTime)--\(tDAppId)")
        
        
        var RequiredInfoMap = [String : Any]()
        RequiredInfoMap = [
            "Name" : personName!,
            "Tone Deaf App Id" : tDAppId,
            "Alternate Names" : altName,
            "Main Role": role,
            "Followers" : 0,
            "Time Registered To App" : newTime,
            "Date Registered To App" : newDate,
            "Youtube": [
                "URL": url,
                "Active Status": false
            ],
            "Songs": [],
            "Albums": [],
            "Videos": [],
            "Beats": [],
            "Instrumentals": [],
            "Active Status": false,
            "Verification Level": String(verificationLevel),
            "Industry Certified": industryCertified
        ]
        
        let RequiredRef = Database.database().reference().child("Registered Persons").child(artistRandomKey)
        if let legal = personLegalName {
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
            if !(snap.value is NSNull) {
                var arr = snap.value as! [String]
                if !arr.contains("\(strongSelf.tDAppId)") {
                    arr.append("\(strongSelf.tDAppId)")
                }
                Database.database().reference().child("All Content IDs").setValue(arr)
            }
            else {
                let arr = ["\(strongSelf.tDAppId)"]
                Database.database().reference().child("All Content IDs").setValue(arr)
            }
        })
        
        Database.database().reference().child("Registered Persons").child("All Person IDs").observeSingleEvent(of: .value, with: {[weak self] snap in
            guard let strongSelf = self else {return}
            if !(snap.value is NSNull) {
                var arr = snap.value as! [String]
                if !arr.contains("\(strongSelf.tDAppId)") {
                    arr.append("\(strongSelf.tDAppId)")
                }
                Database.database().reference().child("Registered Persons").child("All Person IDs").setValue(arr)
            }
            else {
                let arr = ["\(strongSelf.tDAppId)"]
                Database.database().reference().child("Registered Persons").child("All Person IDs").setValue(arr)
            }
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
        
        let artistRandomKey = ("\(personName!)--\(newDate)--\(newTime)--\(tDAppId)")
        
        
        var RequiredInfoMap = [String : Any]()
        RequiredInfoMap = [
            "Name" : personName!,
            "Tone Deaf App Id" : tDAppId,
            "Alternate Names" : altName,
            "Main Role": role,
            "Followers" : 0,
            "Time Registered To App" : newTime,
            "Date Registered To App" : newDate,
            "Soundcloud": [
                "URL": url,
                "Active Status": false
            ],
            "Songs": [],
            "Albums": [],
            "Videos": [],
            "Beats": [],
            "Instrumentals": [],
            "Active Status": false,
            "Verification Level": String(verificationLevel),
            "Industry Certified": industryCertified
        ]
        
        let RequiredRef = Database.database().reference().child("Registered Persons").child(artistRandomKey)
        if let legal = personLegalName {
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
            if !(snap.value is NSNull) {
                var arr = snap.value as! [String]
                if !arr.contains("\(strongSelf.tDAppId)") {
                    arr.append("\(strongSelf.tDAppId)")
                }
                Database.database().reference().child("All Content IDs").setValue(arr)
            }
            else {
                let arr = ["\(strongSelf.tDAppId)"]
                Database.database().reference().child("All Content IDs").setValue(arr)
            }
        })
        
        Database.database().reference().child("Registered Persons").child("All Person IDs").observeSingleEvent(of: .value, with: {[weak self] snap in
            guard let strongSelf = self else {return}
            if !(snap.value is NSNull) {
                var arr = snap.value as! [String]
                if !arr.contains("\(strongSelf.tDAppId)") {
                    arr.append("\(strongSelf.tDAppId)")
                }
                Database.database().reference().child("Registered Persons").child("All Person IDs").setValue(arr)
            }
            else {
                let arr = ["\(strongSelf.tDAppId)"]
                Database.database().reference().child("Registered Persons").child("All Person IDs").setValue(arr)
            }
        })
    }
    
    func youTubeMusicData() {
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
        
        let artistRandomKey = ("\(personName!)--\(newDate)--\(newTime)--\(tDAppId)")
        
        
        var RequiredInfoMap = [String : Any]()
        RequiredInfoMap = [
            "Name" : personName!,
            "Tone Deaf App Id" : tDAppId,
            "Alternate Names" : altName,
            "Main Role": role,
            "Followers" : 0,
            "Time Registered To App" : newTime,
            "Date Registered To App" : newDate,
            "Youtube Music": [
                "URL": url,
                "Active Status": false
            ],
            "Songs": [],
            "Albums": [],
            "Videos": [],
            "Beats": [],
            "Instrumentals": [],
            "Active Status": false,
            "Verification Level": String(verificationLevel),
            "Industry Certified": industryCertified
        ]
        
        let RequiredRef = Database.database().reference().child("Registered Persons").child(artistRandomKey)
        if let legal = personLegalName {
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
            if !(snap.value is NSNull) {
                var arr = snap.value as! [String]
                if !arr.contains("\(strongSelf.tDAppId)") {
                    arr.append("\(strongSelf.tDAppId)")
                }
                Database.database().reference().child("All Content IDs").setValue(arr)
            }
            else {
                let arr = ["\(strongSelf.tDAppId)"]
                Database.database().reference().child("All Content IDs").setValue(arr)
            }
        })
        
        Database.database().reference().child("Registered Persons").child("All Person IDs").observeSingleEvent(of: .value, with: {[weak self] snap in
            guard let strongSelf = self else {return}
            if !(snap.value is NSNull) {
                var arr = snap.value as! [String]
                if !arr.contains("\(strongSelf.tDAppId)") {
                    arr.append("\(strongSelf.tDAppId)")
                }
                Database.database().reference().child("Registered Persons").child("All Person IDs").setValue(arr)
            }
            else {
                let arr = ["\(strongSelf.tDAppId)"]
                Database.database().reference().child("Registered Persons").child("All Person IDs").setValue(arr)
            }
        })
    }
    
    func amazonData() {
        guard amazonTextField.text != "" else {return}
        guard amazonTextField.text!.count > 15 else {return}
        alertView.message = "Gathering Amazon info..."
        let url = amazonTextField.text!
        
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone(identifier: "EDT")
        formatter.dateFormat = "MMMM dd, yyyy"
        let newDate = formatter.string(from: date)
        
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "HH:mm:ss a"
        timeFormatter.timeZone = TimeZone(identifier: "EDT")
        let newTime = timeFormatter.string(from: date)
        
        let artistRandomKey = ("\(personName!)--\(newDate)--\(newTime)--\(tDAppId)")
        
        
        var RequiredInfoMap = [String : Any]()
        RequiredInfoMap = [
            "Name" : personName!,
            "Tone Deaf App Id" : tDAppId,
            "Alternate Names" : altName,
            "Main Role": role,
            "Followers" : 0,
            "Time Registered To App" : newTime,
            "Date Registered To App" : newDate,
            "Amazon Music": [
                "URL": url,
                "Active Status": false
            ],
            "Songs": [],
            "Albums": [],
            "Videos": [],
            "Beats": [],
            "Instrumentals": [],
            "Active Status": false,
            "Verification Level": String(verificationLevel),
            "Industry Certified": industryCertified
        ]
        
        let RequiredRef = Database.database().reference().child("Registered Persons").child(artistRandomKey)
        if let legal = personLegalName {
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
            if !(snap.value is NSNull) {
                var arr = snap.value as! [String]
                if !arr.contains("\(strongSelf.tDAppId)") {
                    arr.append("\(strongSelf.tDAppId)")
                }
                Database.database().reference().child("All Content IDs").setValue(arr)
            }
            else {
                let arr = ["\(strongSelf.tDAppId)"]
                Database.database().reference().child("All Content IDs").setValue(arr)
            }
        })
        
        Database.database().reference().child("Registered Persons").child("All Person IDs").observeSingleEvent(of: .value, with: {[weak self] snap in
            guard let strongSelf = self else {return}
            if !(snap.value is NSNull) {
                var arr = snap.value as! [String]
                if !arr.contains("\(strongSelf.tDAppId)") {
                    arr.append("\(strongSelf.tDAppId)")
                }
                Database.database().reference().child("Registered Persons").child("All Person IDs").setValue(arr)
            }
            else {
                let arr = ["\(strongSelf.tDAppId)"]
                Database.database().reference().child("Registered Persons").child("All Person IDs").setValue(arr)
            }
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
        
        let artistRandomKey = ("\(personName!)--\(newDate)--\(newTime)--\(tDAppId)")
        DispatchQueue.main.async {[weak self] in
            guard let strongSelf = self else {return}
            var url = strongSelf.twitterTextField.text!
            var videoId = ""
            
            if !url.contains("artist/") && !url.contains("deezer.com/") {
                mediumImpactGenerator.impactOccurred()
                Utilities.showError2("Deezer url Invalid error", actionText: "OK")
                return
            }
            if let dotRange = url.range(of: "?") {
                url.removeSubrange(dotRange.lowerBound..<url.endIndex)
            }
            if let range = url.range(of: "artist/") {
                url.removeSubrange(url.startIndex..<range.lowerBound)
            }
            videoId = String(url.dropFirst(6))
             
            DeezerRequest.shared.getDeezerPerson(id: videoId, completion: { result in
                switch result {
                case.success(let person):
                    var RequiredInfoMap = [String : Any]()
                    RequiredInfoMap = [
                        "Name" : strongSelf.personName!,
                        "Tone Deaf App Id" : strongSelf.tDAppId,
                        "Alternate Names" : strongSelf.altName,
                        "Main Role": strongSelf.role,
                        "Followers" : 0,
                        "Time Registered To App" : newTime,
                        "Date Registered To App" : newDate,
                        "Deezer" : [
                            "id": person.id,
                            "Name": person.name,
                            "Profile Image URL": person.profileImageURL,
                            "URL": person.url,
                            "Active Status": false
                        ],
                        "Songs": [],
                        "Albums": [],
                        "Videos": [],
                        "Beats": [],
                        "Instrumentals": [],
                        "Active Status": false,
                        "Verification Level": String(strongSelf.verificationLevel),
                        "Industry Certified": strongSelf.industryCertified
                    ]
                    
                    let RequiredRef = Database.database().reference().child("Registered Persons").child(artistRandomKey)
                    if let legal = strongSelf.personLegalName {
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
                        if !(snap.value is NSNull) {
                            var arr = snap.value as! [String]
                            if !arr.contains("\(strongSelf.tDAppId)") {
                                arr.append("\(strongSelf.tDAppId)")
                            }
                            Database.database().reference().child("All Content IDs").setValue(arr)
                        }
                        else {
                            let arr = ["\(strongSelf.tDAppId)"]
                            Database.database().reference().child("All Content IDs").setValue(arr)
                        }
                    })
                    
                    Database.database().reference().child("Registered Persons").child("All Person IDs").observeSingleEvent(of: .value, with: {[weak self] snap in
                        guard let strongSelf = self else {return}
                        if !(snap.value is NSNull) {
                            var arr = snap.value as! [String]
                            if !arr.contains("\(strongSelf.tDAppId)") {
                                arr.append("\(strongSelf.tDAppId)")
                            }
                            Database.database().reference().child("Registered Persons").child("All Person IDs").setValue(arr)
                        }
                        else {
                            let arr = ["\(strongSelf.tDAppId)"]
                            Database.database().reference().child("Registered Persons").child("All Person IDs").setValue(arr)
                        }
                    })
                case .failure(let error):
                    mediumImpactGenerator.impactOccurred()
                    Utilities.showError2("Twitter Person error", actionText: "OK")
                    return
                }
            })
        }
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
        
        let artistRandomKey = ("\(personName!)--\(newDate)--\(newTime)--\(tDAppId)")
        
        
        var RequiredInfoMap = [String : Any]()
        RequiredInfoMap = [
            "Name" : personName!,
            "Tone Deaf App Id" : tDAppId,
            "Alternate Names" : altName,
            "Main Role": role,
            "Followers" : 0,
            "Time Registered To App" : newTime,
            "Date Registered To App" : newDate,
            "Spinrilla": [
                "URL": url,
                "Active Status": false
            ],
            "Songs": [],
            "Albums": [],
            "Videos": [],
            "Beats": [],
            "Instrumentals": [],
            "Active Status": false,
            "Verification Level": String(verificationLevel),
            "Industry Certified": industryCertified
        ]
        
        let RequiredRef = Database.database().reference().child("Registered Persons").child(artistRandomKey)
        if let legal = personLegalName {
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
            if !(snap.value is NSNull) {
                var arr = snap.value as! [String]
                if !arr.contains("\(strongSelf.tDAppId)") {
                    arr.append("\(strongSelf.tDAppId)")
                }
                Database.database().reference().child("All Content IDs").setValue(arr)
            }
            else {
                let arr = ["\(strongSelf.tDAppId)"]
                Database.database().reference().child("All Content IDs").setValue(arr)
            }
        })
        
        Database.database().reference().child("Registered Persons").child("All Person IDs").observeSingleEvent(of: .value, with: {[weak self] snap in
            guard let strongSelf = self else {return}
            if !(snap.value is NSNull) {
                var arr = snap.value as! [String]
                if !arr.contains("\(strongSelf.tDAppId)") {
                    arr.append("\(strongSelf.tDAppId)")
                }
                Database.database().reference().child("Registered Persons").child("All Person IDs").setValue(arr)
            }
            else {
                let arr = ["\(strongSelf.tDAppId)"]
                Database.database().reference().child("Registered Persons").child("All Person IDs").setValue(arr)
            }
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
        
        let artistRandomKey = ("\(personName!)--\(newDate)--\(newTime)--\(tDAppId)")
        
        
        var RequiredInfoMap = [String : Any]()
        RequiredInfoMap = [
            "Name" : personName!,
            "Tone Deaf App Id" : tDAppId,
            "Alternate Names" : altName,
            "Main Role": role,
            "Followers" : 0,
            "Time Registered To App" : newTime,
            "Date Registered To App" : newDate,
            "Napster": [
                "URL": url,
                "Active Status": false
            ],
            "Songs": [],
            "Albums": [],
            "Videos": [],
            "Beats": [],
            "Instrumentals": [],
            "Active Status": false,
            "Verification Level": String(verificationLevel),
            "Industry Certified": industryCertified
        ]
        
        let RequiredRef = Database.database().reference().child("Registered Persons").child(artistRandomKey)
        if let legal = personLegalName {
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
            if !(snap.value is NSNull) {
                var arr = snap.value as! [String]
                if !arr.contains("\(strongSelf.tDAppId)") {
                    arr.append("\(strongSelf.tDAppId)")
                }
                Database.database().reference().child("All Content IDs").setValue(arr)
            }
            else {
                let arr = ["\(strongSelf.tDAppId)"]
                Database.database().reference().child("All Content IDs").setValue(arr)
            }
        })
        
        Database.database().reference().child("Registered Persons").child("All Person IDs").observeSingleEvent(of: .value, with: {[weak self] snap in
            guard let strongSelf = self else {return}
            if !(snap.value is NSNull) {
                var arr = snap.value as! [String]
                if !arr.contains("\(strongSelf.tDAppId)") {
                    arr.append("\(strongSelf.tDAppId)")
                }
                Database.database().reference().child("Registered Persons").child("All Person IDs").setValue(arr)
            }
            else {
                let arr = ["\(strongSelf.tDAppId)"]
                Database.database().reference().child("Registered Persons").child("All Person IDs").setValue(arr)
            }
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
        
        let artistRandomKey = ("\(personName!)--\(newDate)--\(newTime)--\(tDAppId)")
        
        
        var RequiredInfoMap = [String : Any]()
        RequiredInfoMap = [
            "Name" : personName!,
            "Tone Deaf App Id" : tDAppId,
            "Alternate Names" : altName,
            "Main Role": role,
            "Followers" : 0,
            "Time Registered To App" : newTime,
            "Date Registered To App" : newDate,
            "Tidal": [
                "URL": url,
                "Active Status": false
            ],
            "Songs": [],
            "Albums": [],
            "Videos": [],
            "Beats": [],
            "Instrumentals": [],
            "Active Status": false,
            "Verification Level": String(verificationLevel),
            "Industry Certified": industryCertified
        ]
        
        let RequiredRef = Database.database().reference().child("Registered Persons").child(artistRandomKey)
        if let legal = personLegalName {
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
            if !(snap.value is NSNull) {
                var arr = snap.value as! [String]
                if !arr.contains("\(strongSelf.tDAppId)") {
                    arr.append("\(strongSelf.tDAppId)")
                }
                Database.database().reference().child("All Content IDs").setValue(arr)
            }
            else {
                let arr = ["\(strongSelf.tDAppId)"]
                Database.database().reference().child("All Content IDs").setValue(arr)
            }
        })
        
        Database.database().reference().child("Registered Persons").child("All Person IDs").observeSingleEvent(of: .value, with: {[weak self] snap in
            guard let strongSelf = self else {return}
            if !(snap.value is NSNull) {
                var arr = snap.value as! [String]
                if !arr.contains("\(strongSelf.tDAppId)") {
                    arr.append("\(strongSelf.tDAppId)")
                }
                Database.database().reference().child("Registered Persons").child("All Person IDs").setValue(arr)
            }
            else {
                let arr = ["\(strongSelf.tDAppId)"]
                Database.database().reference().child("Registered Persons").child("All Person IDs").setValue(arr)
            }
        })
    }
    
    func basicPerson() {
    alertView.message = "Gathering Basic info..."
    
    let formatter = DateFormatter()
    formatter.timeZone = TimeZone(identifier: "EDT")
    formatter.dateFormat = "MMMM dd, yyyy"
    let newDate = formatter.string(from: date)
    
    let timeFormatter = DateFormatter()
    timeFormatter.dateFormat = "HH:mm:ss a"
    timeFormatter.timeZone = TimeZone(identifier: "EDT")
    let newTime = timeFormatter.string(from: date)
    
    let artistRandomKey = ("\(personName!)--\(newDate)--\(newTime)--\(tDAppId)")
    
    var RequiredInfoMap = [String : Any]()
    RequiredInfoMap = [
        "Name" : personName!,
        "Tone Deaf App Id" : tDAppId,
        "Alternate Names" : altName,
        "Main Role": role,
        "Followers" : 0,
        "Time Registered To App" : newTime,
        "Date Registered To App" : newDate,
        "Songs": [],
        "Albums": [],
        "Videos": [],
        "Beats": [],
        "Instrumentals": [],
        "Active Status": false,
        "Verification Level": String(verificationLevel),
        "Industry Certified": industryCertified
    ]
    
    let RequiredRef = Database.database().reference().child("Registered Persons").child(artistRandomKey)
        if let legal = personLegalName {
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
            if !(snap.value is NSNull) {
                var arr = snap.value as! [String]
                if !arr.contains("\(strongSelf.tDAppId)") {
                    arr.append("\(strongSelf.tDAppId)")
                }
                Database.database().reference().child("All Content IDs").setValue(arr)
            }
            else {
                let arr = ["\(strongSelf.tDAppId)"]
                Database.database().reference().child("All Content IDs").setValue(arr)
            }
        })
        
        Database.database().reference().child("Registered Persons").child("All Person IDs").observeSingleEvent(of: .value, with: {[weak self] snap in
            guard let strongSelf = self else {return}
            if !(snap.value is NSNull) {
                var arr = snap.value as! [String]
                if !arr.contains("\(strongSelf.tDAppId)") {
                    arr.append("\(strongSelf.tDAppId)")
                }
                Database.database().reference().child("Registered Persons").child("All Person IDs").setValue(arr)
            }
            else {
                let arr = ["\(strongSelf.tDAppId)"]
                Database.database().reference().child("Registered Persons").child("All Person IDs").setValue(arr)
            }
        })
    }
    
    //MARK: - Utilities

    func addBottomLineToText(_ textfield:UITextField) {
        let bottomLine = CALayer()

        bottomLine.frame = CGRect(x: 0,
                                  y: textfield.frame.height - 1,
                                  width: textfield.frame.size.width - 40,//textfield.frame.width,
                                  height: 2)

        bottomLine.backgroundColor = UIColor.init(red: 182/255, green: 0/255, blue: 3/255, alpha: 0.87).cgColor

        textfield.layer.addSublayer(bottomLine)
    }
    
    //MARK: - Keyboard Dismissals
    
    func dismissKeyboardOnTap() {
        let tap = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        scrollView.keyboardDismissMode = .onDrag
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @objc func dismissKeyboard2() {
        
        view.endEditing(true)
    }
}

extension PersonUploadViewController : UITextFieldDelegate {
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

extension PersonUploadViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        var nor = 0
        switch pickerView {
        case mainRolePickerView:
            nor = roleArr.count
        case verificationLevelPickerView:
            nor = verificationLevelArr.count
        default:
            break
        }
        return nor
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        var nor = ""
        switch pickerView {
        case mainRolePickerView:
            nor = roleArr[row]
        case verificationLevelPickerView:
            nor = String(verificationLevelArr[row])
        default:
            break
        }
        return nor
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch pickerView {
        case mainRolePickerView:
            mainRoleTextField.text = roleArr[row]
            role = roleArr[row]
        case verificationLevelPickerView:
            verificationLevelTextField.text = String(verificationLevelArr[row])
            verificationLevel = verificationLevelArr[row]
        default:
            break
        }
    }
    
    func pickerViewToolbar(textField:UITextField, pickerView:UIPickerView) {
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor.init(red: 182/255, green: 0/255, blue: 3/255, alpha: 1)
        toolBar.sizeToFit()

        var doneButton = UIBarButtonItem()
           doneButton = UIBarButtonItem(title: "Select", style: UIBarButtonItem.Style.done, target: self, action: #selector(dismissKeyboard2))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItem.Style.plain, target: self, action: #selector(dismissKeyboard))

        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true

        textField.inputView = pickerView
        textField.inputAccessoryView = toolBar
    }
}

extension PersonUploadViewController : UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch tableView {
        case personAltNamesTableView:
            if !altName.isEmpty {
                return altName.count
            } else {
                return 0
            }
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch tableView {
        case personAltNamesTableView:
            let cell = tableView.dequeueReusableCell(withIdentifier: "editPersonAltNameCell", for: indexPath) as! EditPersonAltNameTableCell
            cell.name.text = altName[indexPath.row]
            return cell
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch tableView {
        case personAltNamesTableView:
            let alertC = UIAlertController(title: "Edit Alternate Name",
                                                    message: "",
                                                    preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Modify", style: .default, handler: {[weak self] _ in
                guard let strongSelf = self else {return}
                let field = alertC.textFields![0]
                if field.text != "" {
                    guard let name = field.text else {return}
                    var newNames:[String] = []
                    newNames = strongSelf.altName
                    newNames[indexPath.row] = name
                    strongSelf.altName = newNames
                    strongSelf.personAltNamesTableView.reloadData()
                    strongSelf.personAltNamesHeightConstraint.constant = CGFloat(50*(newNames.count))
                    alertC.dismiss(animated: true, completion: nil)
                } else {
                    alertC.dismiss(animated: true, completion: nil)
                }
            })
            alertC.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            alertC.addAction(okAction)
            alertC.addTextField()
            let field = alertC.textFields![0]
            field.text = altName[indexPath.row]
            alertC.view.tintColor = Constants.Colors.redApp
            self.present(alertC, animated: true)
        default:
            break
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            switch tableView {
            case personAltNamesTableView:
                altName.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
                personAltNamesHeightConstraint.constant = CGFloat(50*(altName.count))
            default:
                break
            }
        }
    }
    
    
}
