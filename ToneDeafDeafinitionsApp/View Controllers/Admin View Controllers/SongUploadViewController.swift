//
//  SongUploadViewController.swift
//  ToneDeafDeafinitionsApp
//
//  Created by Tone Deaf on 8/16/20.
//  Copyright © 2020 GITEM Solutions. All rights reserved.
//

import UIKit
import Alamofire
import FirebaseDatabase

class SongUploadViewController: UIViewController {
    
    @IBOutlet weak var artistsTableView: UITableView!
    @IBOutlet weak var artistsHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var producersTableView: UITableView!
    @IBOutlet weak var producersHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var writersTableView: UITableView!
    @IBOutlet weak var writersHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var mixEngineerTableView: UITableView!
    @IBOutlet weak var mixEngineerHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var masteringEngineerTableView: UITableView!
    @IBOutlet weak var masteringEngineerHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var recordingEngineerTableView: UITableView!
    @IBOutlet weak var recordingEngineerHeightConstraint: NSLayoutConstraint!
    
    var songName = ""
    var songArtists:Array<String> = []
    var songArtistsNames:[String] = []
    var songProducers:Array<String> = []
    var songProducerNames:[String] = []
    var songWriters:Array<String> = []
    var songWriterNames:[String] = []
    var songMixEngineer:Array<String> = []
    var songMixEngineerNames:[String] = []
    var songMasteringEngineer:Array<String> = []
    var songMasteringEngineerNames:[String] = []
    var songRecordingEngineer:Array<String> = []
    var songRecordingEngineerNames:[String] = []
    var date:Date!
    var tDAppId = ""
    var chosenArtist = ""
    var chosenArtistNames = ""
    var artistref:[String] = []
    var chosenProducer = ""
    var chosenProducerNames = ""
    var producerref:[String] = []
    var chosenWriter = ""
    var chosenWriterNames = ""
    var writerref:[String] = []
    var chosenMixEng = ""
    var chosenMixEngNames = ""
    var mixEngref:[String] = []
    var chosenMasterEng = ""
    var chosenMasterEngNames = ""
    var masterEngref:[String] = []
    var chosenRecEng = ""
    var chosenRecEngNames = ""
    var recEngref:[String] = []
    
    var songUploadVideos:[String] = []
    
    var uploadCompletionStatus1:Bool!
    var uploadCompletionStatus2:Bool!
    var uploadCompletionStatus3:Bool!
    var uploadCompletionStatus4:Bool!
    var uploadCompletionStatus5:Bool!
    var uploadCompletionStatus6:Bool!
    var uploadCompletionStatus7:Bool!
    var uploadCompletionStatus8:Bool!
    var uploadCompletionStatus9:Bool!
    var uploadCompletionStatus10:Bool!
    var uploadCompletionStatus11:Bool!
    var uploadCompletionStatus12:Bool!
    var uploadCompletionStatus13:Bool!
    var uploadCompletionStatus14:Bool!
    var uploadCompletionStatus15:Bool!
    var uploadCompletionStatus16:Bool!
    var uploadCompletionStatus17:Bool!
    var uploadCompletionStatus18:Bool!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var songNameTextField: UITextField! {
        didSet {
            let placeholderText = NSAttributedString(string: "Name",
                                                     attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray.withAlphaComponent(0.4)])
            
            songNameTextField.attributedPlaceholder = placeholderText
        }
    }
    @IBOutlet weak var artistTextField: UITextField! {
        didSet {
            let placeholderText = NSAttributedString(string: "Person(s)",
                                                     attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray.withAlphaComponent(0.4)])
            
            artistTextField.attributedPlaceholder = placeholderText
        }
    }
    @IBOutlet weak var producerTextField: UITextField! {
        didSet {
            let placeholderText = NSAttributedString(string: "Person(s)",
                                                     attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray.withAlphaComponent(0.4)])
            
            producerTextField.attributedPlaceholder = placeholderText
        }
    }
    @IBOutlet weak var writerTextField: UITextField! {
        didSet {
            let placeholderText = NSAttributedString(string: "Person(s)",
                                                     attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray.withAlphaComponent(0.4)])
            
            writerTextField.attributedPlaceholder = placeholderText
        }
    }
    @IBOutlet weak var engineerMixTextField: UITextField! {
        didSet {
            let placeholderText = NSAttributedString(string: "Person(s)",
                                                     attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray.withAlphaComponent(0.4)])
            
            engineerMixTextField.attributedPlaceholder = placeholderText
        }
    }
    @IBOutlet weak var engineerRecordingTextField: UITextField! {
        didSet {
            let placeholderText = NSAttributedString(string: "Person(s)",
                                                     attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray.withAlphaComponent(0.4)])
            
            engineerRecordingTextField.attributedPlaceholder = placeholderText
        }
    }
    @IBOutlet weak var engineerMasteringTextField: UITextField! {
        didSet {
            let placeholderText = NSAttributedString(string: "Person(s)",
                                                     attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray.withAlphaComponent(0.4)])
            
            engineerMasteringTextField.attributedPlaceholder = placeholderText
        }
    }
    @IBOutlet weak var spotifyTextField: UITextField! {
        didSet {
            let placeholderText = NSAttributedString(string: "spotify:track:",
                                                     attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray.withAlphaComponent(0.4)])
            
            spotifyTextField.attributedPlaceholder = placeholderText
        }
    }
    @IBOutlet weak var appleMusicTextField: UITextField! {
        didSet {
            let placeholderText = NSAttributedString(string: "i=",
                                                     attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray.withAlphaComponent(0.4)])
            
            appleMusicTextField.attributedPlaceholder = placeholderText
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
            let placeholderText = NSAttributedString(string: "track/",
                                                     attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray.withAlphaComponent(0.4)])
            
            deezerTextField.attributedPlaceholder = placeholderText
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
    @IBOutlet weak var napsterTextField: UITextField! {
        didSet {
            let placeholderText = NSAttributedString(string: "URL",
                                                     attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray.withAlphaComponent(0.4)])
            
            napsterTextField.attributedPlaceholder = placeholderText
        }
    }
    @IBOutlet weak var verificationLevelTextField: UITextField!{
        didSet {
            let placeholderText = NSAttributedString(string: "Select Level",
                                                     attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray.withAlphaComponent(0.4)])
            
            verificationLevelTextField.attributedPlaceholder = placeholderText
        }
    }
    @IBOutlet weak var remixControl: UISegmentedControl!
    @IBOutlet weak var remixOfStackView: UIStackView!
    @IBOutlet weak var remixOfTextField: UITextField!{
        didSet {
            let placeholderText = NSAttributedString(string: "If album has standard edition in app",
                                                     attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray.withAlphaComponent(0.4)])
            
            remixOfTextField.attributedPlaceholder = placeholderText
        }
    }
    @IBOutlet weak var otherVersionsControl: UISegmentedControl!
    @IBOutlet weak var otherVersionsOfStackView: UIStackView!
    @IBOutlet weak var otherVersionsOfTextField: UITextField!{
        didSet {
            let placeholderText = NSAttributedString(string: "If album has standard edition in app",
                                                     attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray.withAlphaComponent(0.4)])
            
            otherVersionsOfTextField.attributedPlaceholder = placeholderText
        }
    }
    @IBOutlet weak var industryCertificationControl: UISegmentedControl!
    @IBOutlet weak var explicitControl: UISegmentedControl!
    
    var progressView:UIProgressView!
    var totalProgress:Float = 36
    var progressCompleted:Float = 0
    var alertView:UIAlertController!
    
    var verificationLevelPickerView = UIPickerView()
    var verificationLevelArr:[Character] = Constants.Verification.verificationLevels
    var verificationLevel:Character!
    
    var industryCertified:Bool = false
    var explicit:Bool = false
    
    var personPickerView = UIPickerView()
    var producerPickerView = UIPickerView()
    var remixOfPickerView = UIPickerView()
    var otherVersionsOfPickerView = UIPickerView()
    var loadcount = 0
    
    var remixAlbum = false
    var remixOf:String!
    var remixHold:[String]!
    var otherVersionsAlbum = false
    var otherVersionsOf:String!
    var otherVersionsHold:[String]!

    override func viewDidLoad() {
        super.viewDidLoad()
        dismissKeyboardOnTap()
        setUpElements()
        if loadcount == 0 {
            DatabaseManager.shared.fetchAllPersonsFromDatabase(completion: {person in
                AllPersonsInDatabaseArray = person
                //AllPersonsInDatabaseCount = AllPersonsInDatabaseArray.count
            })
            DatabaseManager.shared.fetchAllSongsFromDatabase(completion: {songs in
                AllSongsInDatabaseArray = songs
                //AllPersonsInDatabaseCount = AllPersonsInDatabaseArray.count
            })
        }
        // call the 'keyboardWillShow' function when the view controller receive the notification that a keyboard is going to be shown
            NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
          
              // call the 'keyboardWillHide' function when the view controlelr receive notification that keyboard is going to be hidden
            NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        loadcount+=1
        // Do any additional setup after loading the view.
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
    
    func setUpElements() {
        Utilities.styleTextField(songNameTextField)
        addBottomLineToText(songNameTextField)
        songNameTextField.delegate = self
        
        Utilities.styleTextField(artistTextField)
        addBottomLineToText(artistTextField)
        artistTextField.delegate = self
        
        Utilities.styleTextField(producerTextField)
        addBottomLineToText(producerTextField)
        producerTextField.delegate = self
        
        Utilities.styleTextField(writerTextField)
        addBottomLineToText(writerTextField)
        writerTextField.delegate = self
        
        Utilities.styleTextField(engineerMixTextField)
        addBottomLineToText(engineerMixTextField)
        engineerMixTextField.delegate = self
        
        Utilities.styleTextField(engineerRecordingTextField)
        addBottomLineToText(engineerRecordingTextField)
        engineerRecordingTextField.delegate = self
        
        Utilities.styleTextField(engineerMasteringTextField)
        addBottomLineToText(engineerMasteringTextField)
        engineerMasteringTextField.delegate = self
        
        Utilities.styleTextField(spotifyTextField)
        addBottomLineToText(spotifyTextField)
        spotifyTextField.delegate = self
        
        Utilities.styleTextField(appleMusicTextField)
        addBottomLineToText(appleMusicTextField)
        appleMusicTextField.delegate = self
        
        Utilities.styleTextField(remixOfTextField)
        addBottomLineToText(remixOfTextField)
        remixOfTextField.delegate = self
        
        Utilities.styleTextField(otherVersionsOfTextField)
        addBottomLineToText(otherVersionsOfTextField)
        otherVersionsOfTextField.delegate = self
        
        Utilities.styleTextField(verificationLevelTextField)
        addBottomLineToText(verificationLevelTextField)
        verificationLevelTextField.delegate = self
        
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
        Utilities.styleTextField(souncloudTextField)
        Utilities.styleTextField(youtubeMusicTextField)
        Utilities.styleTextField(amazonTextField)
        Utilities.styleTextField(deezerTextField)
        Utilities.styleTextField(tidalTextField)
        Utilities.styleTextField(napsterTextField)
        Utilities.styleTextField(spinrillaTextField)
        
        artistTextField.inputView = personPickerView
        personPickerView.delegate = self
        personPickerView.dataSource = self
        pickerViewToolbar(textField: artistTextField, pickerView: personPickerView)
        textFieldShouldClear(artistTextField)
        
        verificationLevelTextField.inputView = verificationLevelPickerView
        verificationLevelPickerView.delegate = self
        verificationLevelPickerView.dataSource = self
        pickerViewToolbar(textField: verificationLevelTextField, pickerView: verificationLevelPickerView)
        textFieldShouldClear(verificationLevelTextField)
        
        producerTextField.inputView = personPickerView
        pickerViewToolbar(textField: producerTextField, pickerView: personPickerView)
        textFieldShouldClear(producerTextField)
        
        writerTextField.inputView = personPickerView
        pickerViewToolbar(textField: writerTextField, pickerView: personPickerView)
        textFieldShouldClear(writerTextField)
        
        engineerMixTextField.inputView = personPickerView
        pickerViewToolbar(textField: engineerMixTextField, pickerView: personPickerView)
        textFieldShouldClear(engineerMixTextField)
        
        engineerRecordingTextField.inputView = personPickerView
        pickerViewToolbar(textField: engineerRecordingTextField, pickerView: personPickerView)
        textFieldShouldClear(engineerRecordingTextField)
        
        engineerMasteringTextField.inputView = personPickerView
        pickerViewToolbar(textField: engineerMasteringTextField, pickerView: personPickerView)
        textFieldShouldClear(engineerMasteringTextField)
        
        remixOfTextField.inputView = remixOfPickerView
        remixOfPickerView.delegate = self
        remixOfPickerView.dataSource = self
        pickerViewToolbar(textField: remixOfTextField, pickerView: remixOfPickerView)
        textFieldShouldClear(remixOfTextField)
        
        otherVersionsOfTextField.inputView = otherVersionsOfPickerView
        otherVersionsOfPickerView.delegate = self
        otherVersionsOfPickerView.dataSource = self
        pickerViewToolbar(textField: otherVersionsOfTextField, pickerView: otherVersionsOfPickerView)
        textFieldShouldClear(otherVersionsOfTextField)
    }
    
    deinit {
        print("📗 Song Upload being deallocated from memory. OS reclaiming")
    }
    
    @IBAction func explicitChanged(_ sender: Any) {
        if explicitControl.selectedSegmentIndex == 1 {
            explicitControl.selectedSegmentTintColor = .systemGreen
            explicit = true
            //true
        } else {
            explicitControl.selectedSegmentTintColor = Constants.Colors.redApp
            explicit = false
            //false
        }
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
    
    @IBAction func remixChanged(_ sender: Any) {
        lightImpactGenerator.impactOccurred(intensity: 0.75)
        if remixControl.selectedSegmentIndex == 1 {
            remixControl.selectedSegmentTintColor = .systemGreen
            remixAlbum = true
            remixOfStackView.isHidden = false
            //true
        } else {
            remixControl.selectedSegmentTintColor = Constants.Colors.redApp
            remixAlbum = false
            remixOf = nil
            remixOfTextField.text = ""
            //false
            remixOfStackView.isHidden = true
        }
    }
    
    @IBAction func otherVersionsChanged(_ sender: Any) {
        lightImpactGenerator.impactOccurred(intensity: 0.75)
        if otherVersionsControl.selectedSegmentIndex == 1 {
            otherVersionsControl.selectedSegmentTintColor = .systemGreen
            otherVersionsAlbum = true
            otherVersionsOfStackView.isHidden = false
            //true
        } else {
            otherVersionsControl.selectedSegmentTintColor = Constants.Colors.redApp
            otherVersionsAlbum = false
            otherVersionsOf = nil
            otherVersionsOfTextField.text = ""
            //false
            otherVersionsOfStackView.isHidden = true
        }
    }
    
    @IBAction func uploadSongsButtonTapped(_ sender: Any) {
        date = Date()
        guard songNameTextField.text != "" else {
            Utilities.showError2("Song name required"  ,actionText: "Ok")
            return
        }
        guard artistTextField.text != "" else {
            Utilities.showError2("Song artists required"  ,actionText: "Ok")
            return
        }
        guard producerTextField.text != "" else {
            Utilities.showError2("Song producer required."  ,actionText: "Ok")
            return
        }
        guard verificationLevelTextField.text != "" else {
            Utilities.showError2("Verification Level required"  ,actionText: "Ok")
            return
        }
        songName = songNameTextField.text!
        alertView = UIAlertController(title: "Uploading \(songName)", message: "Preparing...", preferredStyle: .alert)
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
    
    func gruntwork(completion: @escaping (([String]) -> Void)) {
        var allArray:[String] = []
        Database.database().reference().child("Registered Artists").observeSingleEvent(of: .value, with: { snap in
            for child in snap.children {
                let sub = child as! DataSnapshot
                let key = sub.key
                    let dvalue = sub.value as! [String:Any]
                    let id = dvalue["Tone Deaf App Id"] as! String
                    let name = dvalue["Name"] as! String
                    let dbid = "\(id)"
                    allArray.append(dbid)
                
            }
            Database.database().reference().child("Registered Artists").child("All Artist IDs").setValue(allArray)
            completion(allArray)
            
        })
    }
    
    func gatherUploadData() {
        let queue = DispatchQueue(label: "myhjvkhQueue")
        let group = DispatchGroup()
        let array = [4, 5, 6, 7,8,9,10,11,12,13,14,15,16,17,18]

        for i in array {
            print(i)
            group.enter()
            queue.async { [weak self] in
                guard let strongSelf = self else {return}
                switch i {
                case 4:
                    
                    strongSelf.spotifySong(completion: {[weak self] done in
                        guard let strongSelf = self else {return}
                        print(done)
                        if done == false {
                            Utilities.showError2("Spotify upload Failed.", actionText: "OK")
                            strongSelf.uploadCompletionStatus4 = false
                        }
                        else {
                            strongSelf.uploadCompletionStatus4 = true
                            strongSelf.progressCompleted+=1
                            DispatchQueue.main.async {
                                strongSelf.progressView.progress = (strongSelf.progressCompleted/strongSelf.totalProgress)
                                print("\(strongSelf.progressCompleted) out of \(strongSelf.totalProgress)")
                            }
                            print("done \(i)")
                        }
                        group.leave()
                    })
                case 5:
                    strongSelf.appleMusicSong(completion: {[weak self] done in
                        guard let strongSelf = self else {return}
                        if done == false {
                            Utilities.showError2("Apple upload Failed.", actionText: "OK")
                            strongSelf.uploadCompletionStatus5 = false
                        }
                        else {
                            strongSelf.uploadCompletionStatus5 = true
                            strongSelf.progressCompleted+=1
                            DispatchQueue.main.async {
                                strongSelf.progressView.progress = (strongSelf.progressCompleted/strongSelf.totalProgress)
                                print("\(strongSelf.progressCompleted) out of \(strongSelf.totalProgress)")
                            }
                            print("done \(i)")
                        }
                        group.leave()
                    })
                case 6:
                    strongSelf.soundcloudSong(completion: {[weak self] done in
                        guard let strongSelf = self else {return}
                        if done == false {
                            Utilities.showError2("Soundcloud upload Failed.", actionText: "OK")
                            strongSelf.uploadCompletionStatus6 = false
                        }
                        else {
                            strongSelf.uploadCompletionStatus6 = true
                            strongSelf.progressCompleted+=1
                            DispatchQueue.main.async {
                                strongSelf.progressView.progress = (strongSelf.progressCompleted/strongSelf.totalProgress)
                                print("\(strongSelf.progressCompleted) out of \(strongSelf.totalProgress)")
                            }
                            print("done \(i)")
                        }
                        group.leave()
                    })
                case 7:
                    strongSelf.youtubeMusicSong(completion: {[weak self] done in
                        guard let strongSelf = self else {return}
                        if done == false {
                            Utilities.showError2("Youtube Music upload Failed.", actionText: "OK")
                            strongSelf.uploadCompletionStatus7 = false
                        }
                        else {
                            strongSelf.uploadCompletionStatus7 = true
                            strongSelf.progressCompleted+=1
                            DispatchQueue.main.async {
                                strongSelf.progressView.progress = (strongSelf.progressCompleted/strongSelf.totalProgress)
                                print("\(strongSelf.progressCompleted) out of \(strongSelf.totalProgress)")
                            }
                            print("done \(i)")
                        }
                        group.leave()
                    })
                case 8:
                    strongSelf.amazonSong(completion: {[weak self] done in
                        guard let strongSelf = self else {return}
                        if done == false {
                            Utilities.showError2("Amazon upload Failed.", actionText: "OK")
                            strongSelf.uploadCompletionStatus8 = false
                        }
                        else {
                            strongSelf.uploadCompletionStatus8 = true
                            strongSelf.progressCompleted+=1
                            DispatchQueue.main.async {
                                strongSelf.progressView.progress = (strongSelf.progressCompleted/strongSelf.totalProgress)
                                print("\(strongSelf.progressCompleted) out of \(strongSelf.totalProgress)")
                            }
                            print("done \(i)")
                        }
                        group.leave()
                    })
                case 9:
                    strongSelf.tidalSong(completion: {[weak self] done in
                        guard let strongSelf = self else {return}
                        if done == false {
                            Utilities.showError2("Tidal upload Failed.", actionText: "OK")
                            strongSelf.uploadCompletionStatus9 = false
                        }
                        else {
                            strongSelf.uploadCompletionStatus9 = true
                            strongSelf.progressCompleted+=1
                            DispatchQueue.main.async {
                                strongSelf.progressView.progress = (strongSelf.progressCompleted/strongSelf.totalProgress)
                                print("\(strongSelf.progressCompleted) out of \(strongSelf.totalProgress)")
                            }
                            print("done \(i)")
                        }
                        group.leave()
                    })
                case 10:
                    strongSelf.spinrillaSong(completion: {[weak self] done in
                        guard let strongSelf = self else {return}
                        if done == false {
                            Utilities.showError2("Spinrilla upload Failed.", actionText: "OK")
                            strongSelf.uploadCompletionStatus10 = false
                        }
                        else {
                            strongSelf.uploadCompletionStatus10 = true
                            strongSelf.progressCompleted+=1
                            DispatchQueue.main.async {
                                strongSelf.progressView.progress = (strongSelf.progressCompleted/strongSelf.totalProgress)
                                print("\(strongSelf.progressCompleted) out of \(strongSelf.totalProgress)")
                            }
                            print("done \(i)")
                        }
                        group.leave()
                    })
                case 11:
                    strongSelf.deezerSong(completion: {[weak self] done in
                        guard let strongSelf = self else {return}
                        if done == false {
                            Utilities.showError2("Deezer upload Failed.", actionText: "OK")
                            strongSelf.uploadCompletionStatus11 = false
                        }
                        else {
                            strongSelf.uploadCompletionStatus11 = true
                            strongSelf.progressCompleted+=1
                            DispatchQueue.main.async {
                                strongSelf.progressView.progress = (strongSelf.progressCompleted/strongSelf.totalProgress)
                                print("\(strongSelf.progressCompleted) out of \(strongSelf.totalProgress)")
                            }
                            print("done \(i)")
                        }
                        group.leave()
                    })
                case 12:
                    strongSelf.napsterSong(completion: {[weak self] done in
                        guard let strongSelf = self else {return}
                        if done == false {
                            Utilities.showError2("Napster upload Failed.", actionText: "OK")
                            strongSelf.uploadCompletionStatus12 = false
                        }
                        else {
                            strongSelf.uploadCompletionStatus12 = true
                            strongSelf.progressCompleted+=1
                            DispatchQueue.main.async {
                                strongSelf.progressView.progress = (strongSelf.progressCompleted/strongSelf.totalProgress)
                                print("\(strongSelf.progressCompleted) out of \(strongSelf.totalProgress)")
                            }
                            print("done \(i)")
                        }
                        group.leave()
                    })
                case 13:
                    strongSelf.getArtistRefs(completion: {[weak self] done in
                        guard let strongSelf = self else {return}
                        if done == false {
                            Utilities.showError2("artist reference fetch Failed.", actionText: "OK")
                            strongSelf.uploadCompletionStatus13 = false
                        }
                        else {
                            strongSelf.uploadCompletionStatus13 = true
                            strongSelf.progressCompleted+=1
                            DispatchQueue.main.async {
                                strongSelf.progressView.progress = (strongSelf.progressCompleted/strongSelf.totalProgress)
                                print("\(strongSelf.progressCompleted) out of \(strongSelf.totalProgress)")
                            }
                            print("done \(i)")
                        }
                        group.leave()
                    })
                case 14:
                    strongSelf.getProducerRefs(completion: {[weak self] done in
                        guard let strongSelf = self else {return}
                        if done == false {
                            Utilities.showError2("producer reference fetch Failed.", actionText: "OK")
                            strongSelf.uploadCompletionStatus14 = false
                        }
                        else {
                            strongSelf.uploadCompletionStatus14 = true
                            strongSelf.progressCompleted+=1
                            DispatchQueue.main.async {
                                strongSelf.progressView.progress = (strongSelf.progressCompleted/strongSelf.totalProgress)
                                print("\(strongSelf.progressCompleted) out of \(strongSelf.totalProgress)")
                            }
                            print("done \(i)")
                        }
                        group.leave()
                    })
                case 15:
                    strongSelf.getWriterRefs(completion: {[weak self] done in
                        guard let strongSelf = self else {return}
                        if done == false {
                            Utilities.showError2("writer reference fetch Failed.", actionText: "OK")
                            strongSelf.uploadCompletionStatus15 = false
                        }
                        else {
                            strongSelf.uploadCompletionStatus15 = true
                            strongSelf.progressCompleted+=1
                            DispatchQueue.main.async {
                                strongSelf.progressView.progress = (strongSelf.progressCompleted/strongSelf.totalProgress)
                                print("\(strongSelf.progressCompleted) out of \(strongSelf.totalProgress)")
                            }
                            print("done \(i)")
                        }
                        group.leave()
                    })
                case 16:
                    strongSelf.getMixEngineerRefs(completion: {[weak self] done in
                        guard let strongSelf = self else {return}
                        if done == false {
                            Utilities.showError2("mix engineer reference fetch Failed.", actionText: "OK")
                            strongSelf.uploadCompletionStatus16 = false
                        }
                        else {
                            strongSelf.uploadCompletionStatus16 = true
                            strongSelf.progressCompleted+=1
                            DispatchQueue.main.async {
                                strongSelf.progressView.progress = (strongSelf.progressCompleted/strongSelf.totalProgress)
                                print("\(strongSelf.progressCompleted) out of \(strongSelf.totalProgress)")
                            }
                            print("done \(i)")
                        }
                        group.leave()
                    })
                case 17:
                    strongSelf.getMasteringEngineerRefs(completion: {[weak self] done in
                        guard let strongSelf = self else {return}
                        if done == false {
                            Utilities.showError2("Mastering Engineer reference fetch Failed.", actionText: "OK")
                            strongSelf.uploadCompletionStatus17 = false
                        }
                        else {
                            strongSelf.uploadCompletionStatus17 = true
                            strongSelf.progressCompleted+=1
                            DispatchQueue.main.async {
                                strongSelf.progressView.progress = (strongSelf.progressCompleted/strongSelf.totalProgress)
                                print("\(strongSelf.progressCompleted) out of \(strongSelf.totalProgress)")
                            }
                            print("done \(i)")
                        }
                        group.leave()
                    })
                case 18:
                    strongSelf.getRecordingEngineerRefs(completion: {[weak self] done in
                        guard let strongSelf = self else {return}
                        if done == false {
                            Utilities.showError2("recording engineer reference fetch Failed.", actionText: "OK")
                            strongSelf.uploadCompletionStatus18 = false
                        }
                        else {
                            strongSelf.uploadCompletionStatus18 = true
                            strongSelf.progressCompleted+=1
                            DispatchQueue.main.async {
                                strongSelf.progressView.progress = (strongSelf.progressCompleted/strongSelf.totalProgress)
                                print("\(strongSelf.progressCompleted) out of \(strongSelf.totalProgress)")
                            }
                            print("done \(i)")
                        }
                        group.leave()
                    })
                default:
                    print("error")
                }
            }
        }
        
        group.notify(queue: DispatchQueue.main) {[weak self] in
            guard let strongSelf = self else {return}
            if strongSelf.uploadCompletionStatus1 == false || strongSelf.uploadCompletionStatus2 == false || strongSelf.uploadCompletionStatus3 == false || strongSelf.uploadCompletionStatus4 == false || strongSelf.uploadCompletionStatus5 == false || strongSelf.uploadCompletionStatus6 == false || strongSelf.uploadCompletionStatus7 == false || strongSelf.uploadCompletionStatus8 == false || strongSelf.uploadCompletionStatus9 == false || strongSelf.uploadCompletionStatus10 == false || strongSelf.uploadCompletionStatus11 == false || strongSelf.uploadCompletionStatus12 == false || strongSelf.uploadCompletionStatus13 == false || strongSelf.uploadCompletionStatus14 == false || strongSelf.uploadCompletionStatus15 == false || strongSelf.uploadCompletionStatus16 == false || strongSelf.uploadCompletionStatus17 == false || strongSelf.uploadCompletionStatus18 == false {
                Utilities.showError2("Upload Failed.", actionText: "OK")
                return
            } else {
                let categorty = "\(songContentTag)--\(strongSelf.songName)--\(strongSelf.tDAppId)"
                let RequiredRef = Database.database().reference().child("Music Content").child("Songs").child(categorty).child("REQUIRED")
                if strongSelf.songUploadVideos.isEmpty || strongSelf.songUploadVideos == [""] {
                    RequiredRef.child("Videos").setValue([])
                }
                let bqueue = DispatchQueue(label: "myhjvsdfbhgdfxkhQueue")
                let bgroup = DispatchGroup()
                var barray = [19, 20, 21, 22, 23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41]

                for i in barray {
                    print(i)
                    bgroup.enter()
                    bqueue.async { [weak self] in
                        guard let strongSelf = self else {return}
                        switch i {
                        case 19:
                            strongSelf.updateSongVideos(completion: { done in
                                if done == false {
                                    Utilities.showError2("Song videos failed to update.", actionText: "OK")
                                }
                                else {
                                    strongSelf.uploadCompletionStatus1 = true
                                    strongSelf.progressCompleted+=1
                                    DispatchQueue.main.async {
                                        strongSelf.progressView.progress = (strongSelf.progressCompleted/strongSelf.totalProgress)
                                        print("\(strongSelf.progressCompleted) out of \(strongSelf.totalProgress)")
                                    }
                                    print("done \(i)")
                                    bgroup.leave()
                                    
                                }
                            })
                        case 20:
                            strongSelf.updateArtistSongs(completion: { done in
                                if done == false {
                                    Utilities.showError2("Artist songs failed to update.", actionText: "OK")
                                }
                                else {
                                    strongSelf.uploadCompletionStatus1 = true
                                    strongSelf.progressCompleted+=1
                                    DispatchQueue.main.async {
                                        strongSelf.progressView.progress = (strongSelf.progressCompleted/strongSelf.totalProgress)
                                        print("\(strongSelf.progressCompleted) out of \(strongSelf.totalProgress)")
                                    }
                                    print("done \(i)")
                                    bgroup.leave()
                                }
                            })
                        case 21:
                            strongSelf.updateArtistVideos(completion: { done in
                                if done == false {
                                    Utilities.showError2("Artist videos failed to update.", actionText: "OK")
                                }
                                else {
                                    strongSelf.uploadCompletionStatus1 = true
                                    strongSelf.progressCompleted+=1
                                    DispatchQueue.main.async {
                                        strongSelf.progressView.progress = (strongSelf.progressCompleted/strongSelf.totalProgress)
                                        print("\(strongSelf.progressCompleted) out of \(strongSelf.totalProgress)")
                                    }
                                    print("done \(i)")
                                    bgroup.leave()
                                }
                            })
                        case 22:
                            strongSelf.updateProducerSongs(completion: { done in
                                if done == false {
                                    Utilities.showError2("Producer songs failed to update.", actionText: "OK")
                                }
                                else {
                                    strongSelf.uploadCompletionStatus1 = true
                                    strongSelf.progressCompleted+=1
                                    DispatchQueue.main.async {
                                        strongSelf.progressView.progress = (strongSelf.progressCompleted/strongSelf.totalProgress)
                                        print("\(strongSelf.progressCompleted) out of \(strongSelf.totalProgress)")
                                    }
                                    print("done \(i)")
                                    bgroup.leave()
                                }
                            })
                        case 23:
                        strongSelf.updateProducerVideos(completion: { done in
                            if done == false {
                                Utilities.showError2("Producer Videos failed to update.", actionText: "OK")
                            }
                            else {
                                strongSelf.uploadCompletionStatus1 = true
                                strongSelf.progressCompleted+=1
                                DispatchQueue.main.async {
                                    strongSelf.progressView.progress = (strongSelf.progressCompleted/strongSelf.totalProgress)
                                    print("\(strongSelf.progressCompleted) out of \(strongSelf.totalProgress)")
                                }
                                print("done \(i)")
                                bgroup.leave()
                            }
                        })
                        case 24:
                            strongSelf.updateWriterSongs(completion: { done in
                                if done == false {
                                    Utilities.showError2("Writer songs failed to update.", actionText: "OK")
                                }
                                else {
                                    strongSelf.uploadCompletionStatus1 = true
                                    strongSelf.progressCompleted+=1
                                    DispatchQueue.main.async {
                                        strongSelf.progressView.progress = (strongSelf.progressCompleted/strongSelf.totalProgress)
                                        print("\(strongSelf.progressCompleted) out of \(strongSelf.totalProgress)")
                                    }
                                    print("done \(i)")
                                    bgroup.leave()
                                }
                            })
                        case 25:
                        strongSelf.updateWriterVideos(completion: { done in
                            if done == false {
                                Utilities.showError2("Writer Videos failed to update.", actionText: "OK")
                            }
                            else {
                                strongSelf.uploadCompletionStatus1 = true
                                strongSelf.progressCompleted+=1
                                DispatchQueue.main.async {
                                    strongSelf.progressView.progress = (strongSelf.progressCompleted/strongSelf.totalProgress)
                                    print("\(strongSelf.progressCompleted) out of \(strongSelf.totalProgress)")
                                }
                                print("done \(i)")
                                bgroup.leave()
                            }
                        })
                        case 26:
                            strongSelf.updateMixEngineerSongs(completion: { done in
                                if done == false {
                                    Utilities.showError2("Mix Engineer songs failed to update.", actionText: "OK")
                                }
                                else {
                                    strongSelf.uploadCompletionStatus1 = true
                                    strongSelf.progressCompleted+=1
                                    DispatchQueue.main.async {
                                        strongSelf.progressView.progress = (strongSelf.progressCompleted/strongSelf.totalProgress)
                                        print("\(strongSelf.progressCompleted) out of \(strongSelf.totalProgress)")
                                    }
                                    print("done \(i)")
                                    bgroup.leave()
                                }
                            })
                        case 27:
                        strongSelf.updateMixEngineerVideos(completion: { done in
                            if done == false {
                                Utilities.showError2("Mix Engineer Videos failed to update.", actionText: "OK")
                            }
                            else {
                                strongSelf.uploadCompletionStatus1 = true
                                strongSelf.progressCompleted+=1
                                DispatchQueue.main.async {
                                    strongSelf.progressView.progress = (strongSelf.progressCompleted/strongSelf.totalProgress)
                                    print("\(strongSelf.progressCompleted) out of \(strongSelf.totalProgress)")
                                }
                                print("done \(i)")
                                bgroup.leave()
                            }
                        })
                        case 28:
                            strongSelf.updateMasteringEngineerSongs(completion: { done in
                                if done == false {
                                    Utilities.showError2("Mastering Engineer songs failed to update.", actionText: "OK")
                                }
                                else {
                                    strongSelf.uploadCompletionStatus1 = true
                                    strongSelf.progressCompleted+=1
                                    DispatchQueue.main.async {
                                        strongSelf.progressView.progress = (strongSelf.progressCompleted/strongSelf.totalProgress)
                                        print("\(strongSelf.progressCompleted) out of \(strongSelf.totalProgress)")
                                    }
                                    print("done \(i)")
                                    bgroup.leave()
                                }
                            })
                        case 29:
                        strongSelf.updateMasteringEngineerVideos(completion: { done in
                            if done == false {
                                Utilities.showError2("Mastering Engineer Videos failed to update.", actionText: "OK")
                            }
                            else {
                                strongSelf.uploadCompletionStatus1 = true
                                strongSelf.progressCompleted+=1
                                DispatchQueue.main.async {
                                    strongSelf.progressView.progress = (strongSelf.progressCompleted/strongSelf.totalProgress)
                                    print("\(strongSelf.progressCompleted) out of \(strongSelf.totalProgress)")
                                }
                                print("done \(i)")
                                bgroup.leave()
                            }
                        })
                        case 30:
                            strongSelf.updateRecordingEngineerSongs(completion: { done in
                                if done == false {
                                    Utilities.showError2("Recording Engineer songs failed to update.", actionText: "OK")
                                }
                                else {
                                    strongSelf.uploadCompletionStatus1 = true
                                    strongSelf.progressCompleted+=1
                                    DispatchQueue.main.async {
                                        strongSelf.progressView.progress = (strongSelf.progressCompleted/strongSelf.totalProgress)
                                        print("\(strongSelf.progressCompleted) out of \(strongSelf.totalProgress)")
                                    }
                                    print("done \(i)")
                                    bgroup.leave()
                                }
                            })
                        case 31:
                        strongSelf.updateRecordingEngineerVideos(completion: { done in
                            if done == false {
                                Utilities.showError2("Recording Engineer Videos failed to update.", actionText: "OK")
                            }
                            else {
                                strongSelf.uploadCompletionStatus1 = true
                                strongSelf.progressCompleted+=1
                                DispatchQueue.main.async {
                                    strongSelf.progressView.progress = (strongSelf.progressCompleted/strongSelf.totalProgress)
                                    print("\(strongSelf.progressCompleted) out of \(strongSelf.totalProgress)")
                                }
                                print("done \(i)")
                                bgroup.leave()
                            }
                        })
                        case 32:
                        strongSelf.updateArtistRoles(completion: { done in
                            if done == false {
                                Utilities.showError2("Artist Roles failed to update.", actionText: "OK")
                            }
                            else {
                                strongSelf.uploadCompletionStatus1 = true
                                strongSelf.progressCompleted+=1
                                DispatchQueue.main.async {
                                    strongSelf.progressView.progress = (strongSelf.progressCompleted/strongSelf.totalProgress)
                                    print("\(strongSelf.progressCompleted) out of \(strongSelf.totalProgress)")
                                }
                                print("done \(i)")
                                bgroup.leave()
                            }
                        })
                        case 33:
                        strongSelf.updateProducerRoles(completion: { done in
                            if done == false {
                                Utilities.showError2("Producer Roles failed to update.", actionText: "OK")
                            }
                            else {
                                strongSelf.uploadCompletionStatus1 = true
                                strongSelf.progressCompleted+=1
                                DispatchQueue.main.async {
                                    strongSelf.progressView.progress = (strongSelf.progressCompleted/strongSelf.totalProgress)
                                    print("\(strongSelf.progressCompleted) out of \(strongSelf.totalProgress)")
                                }
                                print("done \(i)")
                                bgroup.leave()
                            }
                        })
                        case 34:
                        strongSelf.updateWriterRoles(completion: { done in
                            if done == false {
                                Utilities.showError2("Writer Roles failed to update.", actionText: "OK")
                            }
                            else {
                                strongSelf.uploadCompletionStatus1 = true
                                strongSelf.progressCompleted+=1
                                DispatchQueue.main.async {
                                    strongSelf.progressView.progress = (strongSelf.progressCompleted/strongSelf.totalProgress)
                                    print("\(strongSelf.progressCompleted) out of \(strongSelf.totalProgress)")
                                }
                                print("done \(i)")
                                bgroup.leave()
                            }
                        })
                        case 35:
                        strongSelf.updateMixEngineerRoles(completion: { done in
                            if done == false {
                                Utilities.showError2("Mix Engineer Roles failed to update.", actionText: "OK")
                            }
                            else {
                                strongSelf.uploadCompletionStatus1 = true
                                strongSelf.progressCompleted+=1
                                DispatchQueue.main.async {
                                    strongSelf.progressView.progress = (strongSelf.progressCompleted/strongSelf.totalProgress)
                                    print("\(strongSelf.progressCompleted) out of \(strongSelf.totalProgress)")
                                }
                                print("done \(i)")
                                bgroup.leave()
                            }
                        })
                        case 36:
                        strongSelf.updateMasteringEngineerRoles(completion: { done in
                            if done == false {
                                Utilities.showError2("Mastering Engineer Roles failed to update.", actionText: "OK")
                            }
                            else {
                                strongSelf.uploadCompletionStatus1 = true
                                strongSelf.progressCompleted+=1
                                DispatchQueue.main.async {
                                    strongSelf.progressView.progress = (strongSelf.progressCompleted/strongSelf.totalProgress)
                                    print("\(strongSelf.progressCompleted) out of \(strongSelf.totalProgress)")
                                }
                                print("done \(i)")
                                bgroup.leave()
                            }
                        })
                        case 37:
                        strongSelf.updateRecordingEngineerRoles(completion: { done in
                            if done == false {
                                Utilities.showError2("Recording Engineer Roles failed to update.", actionText: "OK")
                            }
                            else {
                                strongSelf.uploadCompletionStatus1 = true
                                strongSelf.progressCompleted+=1
                                DispatchQueue.main.async {
                                    strongSelf.progressView.progress = (strongSelf.progressCompleted/strongSelf.totalProgress)
                                    print("\(strongSelf.progressCompleted) out of \(strongSelf.totalProgress)")
                                }
                                print("done \(i)")
                                bgroup.leave()
                            }
                        })
                        case 38:
                            strongSelf.addAllIDs(completion: { done in
                                if done == false {
                                    Utilities.showError2("IDs failed to update.", actionText: "OK")
                                }
                                else {
                                    strongSelf.uploadCompletionStatus1 = true
                                    strongSelf.progressCompleted+=1
                                    DispatchQueue.main.async {
                                        strongSelf.progressView.progress = (strongSelf.progressCompleted/strongSelf.totalProgress)
                                        print("\(strongSelf.progressCompleted) out of \(strongSelf.totalProgress)")
                                    }
                                    print("done \(i)")
                                    bgroup.leave()
                                }
                            })
                        case 39:
                            strongSelf.addSongIDs(completion: { done in
                                if done == false {
                                    Utilities.showError2("IDs failed to update.", actionText: "OK")
                                }
                                else {
                                    strongSelf.uploadCompletionStatus1 = true
                                    strongSelf.progressCompleted+=1
                                    DispatchQueue.main.async {
                                        strongSelf.progressView.progress = (strongSelf.progressCompleted/strongSelf.totalProgress)
                                        print("\(strongSelf.progressCompleted) out of \(strongSelf.totalProgress)")
                                    }
                                    print("done \(i)")
                                    bgroup.leave()
                                }
                            })
                        case 40:
                            strongSelf.storeRemixToStandardEdition(completion: { done in
                                if let done = done {
                                    Utilities.showError2("Remix failed to update.", actionText: "OK")
                                }
                                else {
                                    strongSelf.uploadCompletionStatus1 = true
                                    strongSelf.progressCompleted+=1
                                    DispatchQueue.main.async {
                                        strongSelf.progressView.progress = (strongSelf.progressCompleted/strongSelf.totalProgress)
                                        print("\(strongSelf.progressCompleted) out of \(strongSelf.totalProgress)")
                                    }
                                    print("done \(i)")
                                    bgroup.leave()
                                }
                            })
                        case 41:
                            strongSelf.storeOtherVersionToStandardEditionSong(completion: { done in
                                if let done = done {
                                    Utilities.showError2("storeOtherVersion failed to update.", actionText: "OK")
                                }
                                else {
                                    strongSelf.uploadCompletionStatus1 = true
                                    strongSelf.progressCompleted+=1
                                    DispatchQueue.main.async {
                                        strongSelf.progressView.progress = (strongSelf.progressCompleted/strongSelf.totalProgress)
                                        print("\(strongSelf.progressCompleted) out of \(strongSelf.totalProgress)")
                                    }
                                    print("done \(i)")
                                    bgroup.leave()
                                }
                            })
                        default:
                            print("error")
                        }
                    }
                }
                bgroup.notify(queue: DispatchQueue.main) {
                    strongSelf.songArtists = []
                    strongSelf.songArtistsNames = []
                    strongSelf.songUploadVideos = []
                    strongSelf.songProducers = []
                    strongSelf.songRecordingEngineer = []
                    strongSelf.songWriters = []
                    strongSelf.songMixEngineer = []
                    strongSelf.songMasteringEngineer = []
                    strongSelf.writerTextField.text = ""
                    strongSelf.engineerMixTextField.text = ""
                    strongSelf.engineerMasteringTextField.text = ""
                    strongSelf.engineerRecordingTextField.text = ""
                    strongSelf.producerTextField.text = ""
                    strongSelf.songNameTextField.text = ""
                    strongSelf.artistTextField.text = ""
                    strongSelf.verificationLevelTextField.text = ""
                    strongSelf.appleMusicTextField.text = ""
                    strongSelf.spotifyTextField.text = ""
                    print("📗 Song data saved to database successfully.")
                    strongSelf.alertView.dismiss(animated: true, completion: {
                        Utilities.successBarBanner("Upload successful.")
                        _ = strongSelf.navigationController?.popViewController(animated: true)
                    })
                }
            }
        }
    }
    
    func addAllIDs(completion: @escaping ((Bool) -> Void)) {
        Database.database().reference().child("All Content IDs").observeSingleEvent(of: .value, with: {[weak self] snap in
            guard let strongSelf = self else {return}
            if !(snap.value is NSNull)
            {
                var arr = snap.value as! [String]
                arr.append("\(strongSelf.tDAppId)")
                Database.database().reference().child("All Content IDs").setValue(arr)
                completion(true)
            }
            else
            {
                let arr = ["\(strongSelf.tDAppId)"]
                Database.database().reference().child("All Content IDs").setValue(arr)
                completion(true)
                return
            }
        })
    }
    
    func addSongIDs(completion: @escaping ((Bool) -> Void)) {
        Database.database().reference().child("Music Content").child("Songs").child("All Song IDs").observeSingleEvent(of: .value, with: {[weak self] snap in
            guard let strongSelf = self else {return}
            if !(snap.value is NSNull) {
                var arr = snap.value as! [String]
                arr.append("\(strongSelf.tDAppId)")
                Database.database().reference().child("Music Content").child("Songs").child("All Song IDs").setValue(arr)
                completion(true)
            }
            else {
                let arr = ["\(strongSelf.tDAppId)"]
                Database.database().reference().child("Music Content").child("Songs").child("All Song IDs").setValue(arr)
                completion(true)
                return
            }
        })
    }
    
    func updateSongVideos(completion: @escaping ((Bool) -> Void)) {
        let categorty = "\(songContentTag)--\(songName)--\(tDAppId)"
        var RequiredVidsInfoMap = [String : Any]()
        RequiredVidsInfoMap = [
            "Videos" : songUploadVideos]
        
        Database.database().reference().child("Music Content").child("Songs").child(categorty).child("REQUIRED").updateChildValues(RequiredVidsInfoMap) {(error, songRef) in
            if let error = error {
                Utilities.showError2("Failed to update videos in song required dictionary.", actionText: "OK")
                print("📕 Failed to update videos in song reqquired dictionary: \(error)")
                return
            } else {
                
                completion(true)
            }
        }
    }
    
    func updateArtistVideos(completion: @escaping ((Bool) -> Void)) {
        var count = 0
        for artist in artistref {
            if songUploadVideos != [] {
                getPersonVideosInDB(cat: artist, completion: {[weak self] videos in
                    guard let strongSelf = self else {return}
                    var myvideosArray:Array<String> = []
                    myvideosArray = videos
                    //print("Videos in DB  for \(artist): \(videos)")
                    //print("Videos appending: \(strongSelf.songUploadVideos)")
                    myvideosArray.append(contentsOf: strongSelf.songUploadVideos)
                    //print("Videos Arry for \(artist): \(myvideosArray)")
                    if myvideosArray != [] {
                        Database.database().reference().child("Registered Persons").child(artist).child("Videos").setValue(myvideosArray)
                    }
                    count+=1
                    if count == strongSelf.artistref.count {
                        
                        completion(true)
                    }
                })
            } else {
                count+=1
                if count == artistref.count {
                    completion(true)
                }
            }
        }
    }
    
    func updateArtistSongs(completion: @escaping ((Bool) -> Void)) {
        var count = 0
        for artist in artistref {
            getPersonSongsInDB(cat: artist, completion: {[weak self] songs in
                guard let strongSelf = self else {return}
                var mysongsArray:[String] = songs
                mysongsArray.append("\(strongSelf.tDAppId)")
                Database.database().reference().child("Registered Persons").child(artist).child("Songs").setValue(mysongsArray)
                count+=1
                if count == strongSelf.artistref.count {
                    completion(true)
                }
                
            })
        }
    }
    
    func updateArtistRoles(completion: @escaping ((Bool) -> Void)) {
        print("ARole ", artistref)
        var count = 0
        for artist in artistref {
            let ref = Database.database().reference().child("Registered Persons").child(artist).child("Roles").child("Artist")
            ref.observeSingleEvent(of: .value, with: {[weak self] snapshot in
                guard let strongSelf = self else {return}
                print("snapp",snapshot.value)
                var theysongArray:[String] = []
                if !(snapshot.value is NSNull) {
                    let val = snapshot.value
                    let valu = val as? [String]
                    guard let value = valu else {return}
                    if value[0] != "" {
                        theysongArray = value
                    }
                    theysongArray.append("\(strongSelf.tDAppId)")
                    ref.setValue(theysongArray)
                    count+=1
                    print("count ", count, strongSelf.artistref.count)
                    print("songarr ", theysongArray)
                    if count == strongSelf.artistref.count {
                        completion(true)
                    }
                } else {
                    theysongArray.append("\(strongSelf.tDAppId)")
                    ref.setValue(theysongArray)
                    count+=1
                    if count == strongSelf.artistref.count {
                        completion(true)
                    }
                }
            })
        }
    }
    
    
    func updateProducerVideos(completion: @escaping ((Bool) -> Void)) {
        var count = 0
        for producer in producerref {
            if songUploadVideos != [] {
                getPersonVideosInDB(cat: producer, completion: {[weak self] videos in
                guard let strongSelf = self else {return}
                    
                    var myvideosArray:Array<String> = []
                    myvideosArray = videos
                    //print("Videos in DB  for \(artist): \(videos)")
                    //print("Videos appending: \(strongSelf.songUploadVideos)")
                    myvideosArray.append(contentsOf: strongSelf.songUploadVideos)
                    //print("Videos Arry for \(artist): \(myvideosArray)")
                    if myvideosArray != [] {
                        Database.database().reference().child("Registered Persons").child(producer).child("Videos").setValue(myvideosArray)
                    }
                    count+=1
                    if count == strongSelf.producerref.count {
                        completion(true)
                    }
                })
            } else {
                count+=1
                if count == producerref.count {
                    completion(true)
                }
            }
        }
    }
    
    func updateProducerSongs(completion: @escaping ((Bool) -> Void)) {
        var count = 0
        for producer in producerref {
            getPersonSongsInDB(cat: producer, completion: {[weak self] songs in
            guard let strongSelf = self else {return}
                
                var mysongsArray:[String] = songs
                mysongsArray.append("\(strongSelf.tDAppId)")
                Database.database().reference().child("Registered Persons").child(producer).child("Songs").setValue(mysongsArray)
                count+=1
                if count == strongSelf.producerref.count {
                    completion(true)
                }
            })
        }
    }
    
    func updateProducerRoles(completion: @escaping ((Bool) -> Void)) {
        
        if producerref.isEmpty {
            completion(true)
            return
        }
        var count = 0
        for producer in producerref {
            let ref = Database.database().reference().child("Registered Persons").child(producer).child("Roles").child("Producer")
            ref.observeSingleEvent(of: .value, with: {[weak self] snapshot in
                guard let strongSelf = self else {return}
                var theysongArray:[String] = []
                if !(snapshot.value is NSNull) {
                    let val = snapshot.value
                    let valu = val as? [String]
                    guard let value = valu else {return}
                    if value[0] != "" {
                        theysongArray = value
                    }
                    theysongArray.append("\(strongSelf.tDAppId)")
                    ref.setValue(theysongArray)
                    count+=1
                    if count == strongSelf.producerref.count {
                        completion(true)
                    }
                } else {
                    theysongArray.append("\(strongSelf.tDAppId)")
                    ref.setValue(theysongArray)
                    count+=1
                    if count == strongSelf.producerref.count {
                        completion(true)
                    }
                }
            })
        }
    }
    
    func updateWriterVideos(completion: @escaping ((Bool) -> Void)) {
        if writerref.isEmpty {
            completion(true)
            return
        }
        var count = 0
        for writer in writerref {
            if songUploadVideos != [] {
                getPersonVideosInDB(cat: writer, completion: {[weak self] videos in
                    guard let strongSelf = self else {return}
                    var myvideosArray:Array<String> = []
                    myvideosArray = videos
                    //print("Videos in DB  for \(artist): \(videos)")
                    //print("Videos appending: \(strongSelf.songUploadVideos)")
                    myvideosArray.append(contentsOf: strongSelf.songUploadVideos)
                    //print("Videos Arry for \(artist): \(myvideosArray)")
                    if myvideosArray != [] {
                        Database.database().reference().child("Registered Persons").child(writer).child("Videos").setValue(myvideosArray)
                    }
                    count+=1
                    if count == strongSelf.writerref.count {
                        
                        completion(true)
                    }
                })
            } else {
                count+=1
                if count == writerref.count {
                    completion(true)
                }
            }
        }
    }
    
    func updateWriterSongs(completion: @escaping ((Bool) -> Void)) {
        if writerref.isEmpty {
            completion(true)
            return
        }
        var count = 0
        for writer in writerref {
            getPersonSongsInDB(cat: writer, completion: {[weak self] songs in
                guard let strongSelf = self else {return}
                var mysongsArray:[String] = songs
                mysongsArray.append("\(strongSelf.tDAppId)")
                Database.database().reference().child("Registered Persons").child(writer).child("Songs").setValue(mysongsArray)
                
                count+=1
                if count == strongSelf.writerref.count {
                    completion(true)
                }
                
            })
        }
    }
    
    func updateWriterRoles(completion: @escaping ((Bool) -> Void)) {
        if writerref.isEmpty {
            completion(true)
            return
        }
        var count = 0
        for writer in writerref {
            let ref = Database.database().reference().child("Registered Persons").child(writer).child("Roles").child("Writer")
            ref.observeSingleEvent(of: .value, with: {[weak self] snapshot in
                guard let strongSelf = self else {return}
                var theysongArray:[String] = []
                if !(snapshot.value is NSNull) {
                    let val = snapshot.value
                    let valu = val as? [String]
                    guard let value = valu else {return}
                    if value[0] != "" {
                        theysongArray = value
                    }
                    theysongArray.append("\(strongSelf.tDAppId)")
                    ref.setValue(theysongArray)
                    count+=1
                    if count == strongSelf.writerref.count {
                        completion(true)
                    }
                } else {
                    theysongArray.append("\(strongSelf.tDAppId)")
                    ref.setValue(theysongArray)
                    count+=1
                    if count == strongSelf.writerref.count {
                        completion(true)
                    }
                }
            })
        }
    }
    
    func updateMixEngineerVideos(completion: @escaping ((Bool) -> Void)) {
        if mixEngref.isEmpty {
            completion(true)
            return
        }
        var count = 0
        for engie in mixEngref {
            if songUploadVideos != [] {
                getPersonVideosInDB(cat: engie, completion: {[weak self] videos in
                    guard let strongSelf = self else {return}
                    var myvideosArray:Array<String> = []
                    myvideosArray = videos
                    //print("Videos in DB  for \(artist): \(videos)")
                    //print("Videos appending: \(strongSelf.songUploadVideos)")
                    myvideosArray.append(contentsOf: strongSelf.songUploadVideos)
                    //print("Videos Arry for \(artist): \(myvideosArray)")
                    if myvideosArray != [] {
                        Database.database().reference().child("Registered Persons").child(engie).child("Videos").setValue(myvideosArray)
                    }
                    count+=1
                    if count == strongSelf.mixEngref.count {
                        
                        completion(true)
                    }
                })
            } else {
                count+=1
                if count == mixEngref.count {
                    completion(true)
                }
            }
        }
    }
    
    func updateMixEngineerSongs(completion: @escaping ((Bool) -> Void)) {
        if mixEngref.isEmpty {
            completion(true)
            return
        }
        var count = 0
        for engie in mixEngref {
            getPersonSongsInDB(cat: engie, completion: {[weak self] songs in
                guard let strongSelf = self else {return}
                var mysongsArray:[String] = songs
                mysongsArray.append("\(strongSelf.tDAppId)")
                Database.database().reference().child("Registered Persons").child(engie).child("Songs").setValue(mysongsArray)
                
                count+=1
                if count == strongSelf.mixEngref.count {
                    completion(true)
                }
                
            })
        }
    }
    
    func updateMixEngineerRoles(completion: @escaping ((Bool) -> Void)) {
        if mixEngref.isEmpty {
            completion(true)
            return
        }
        var count = 0
        for engie in mixEngref {
            let ref = Database.database().reference().child("Registered Persons").child(engie).child("Roles").child("Engineer").child("Mix Engineer")
            ref.observeSingleEvent(of: .value, with: {[weak self] snapshot in
                guard let strongSelf = self else {return}
                var theysongArray:[String] = []
                if !(snapshot.value is NSNull) {
                    let val = snapshot.value
                    let valu = val as? [String]
                    guard let value = valu else {return}
                    if value[0] != "" {
                        theysongArray = value
                    }
                    theysongArray.append("\(strongSelf.tDAppId)")
                    ref.setValue(theysongArray)
                    count+=1
                    if count == strongSelf.mixEngref.count {
                        completion(true)
                    }
                } else {
                    theysongArray.append("\(strongSelf.tDAppId)")
                    ref.setValue(theysongArray)
                    count+=1
                    if count == strongSelf.mixEngref.count {
                        completion(true)
                    }
                }
            })
        }
    }
    
    func updateMasteringEngineerVideos(completion: @escaping ((Bool) -> Void)) {
        if masterEngref.isEmpty {
            completion(true)
            return
        }
        var count = 0
        for engie in masterEngref {
            if songUploadVideos != [] {
                getPersonVideosInDB(cat: engie, completion: {[weak self] videos in
                    guard let strongSelf = self else {return}
                    var myvideosArray:Array<String> = []
                    myvideosArray = videos
                    //print("Videos in DB  for \(artist): \(videos)")
                    //print("Videos appending: \(strongSelf.songUploadVideos)")
                    myvideosArray.append(contentsOf: strongSelf.songUploadVideos)
                    //print("Videos Arry for \(artist): \(myvideosArray)")
                    if myvideosArray != [] {
                        Database.database().reference().child("Registered Persons").child(engie).child("Videos").setValue(myvideosArray)
                    }
                    count+=1
                    if count == strongSelf.masterEngref.count {
                        
                        completion(true)
                    }
                })
            } else {
                count+=1
                if count == masterEngref.count {
                    completion(true)
                }
            }
        }
    }
    
    func updateMasteringEngineerSongs(completion: @escaping ((Bool) -> Void)) {
        if masterEngref.isEmpty {
            completion(true)
            return
        }
        var count = 0
        for engie in masterEngref {
            getPersonSongsInDB(cat: engie, completion: {[weak self] songs in
                guard let strongSelf = self else {return}
                var mysongsArray:[String] = songs
                mysongsArray.append("\(strongSelf.tDAppId)")
                Database.database().reference().child("Registered Persons").child(engie).child("Songs").setValue(mysongsArray)
                
                count+=1
                if count == strongSelf.recEngref.count {
                    completion(true)
                }
                
            })
        }
    }
    
    func updateMasteringEngineerRoles(completion: @escaping ((Bool) -> Void)) {
        if masterEngref.isEmpty {
            completion(true)
            return
        }
        var count = 0
        for engie in masterEngref {
            let ref = Database.database().reference().child("Registered Persons").child(engie).child("Roles").child("Engineer").child("Mastering Engineer")
            ref.observeSingleEvent(of: .value, with: { [weak self] snapshot in
                guard let strongSelf = self else {return}
                var theysongArray:[String] = []
                if !(snapshot.value is NSNull) {
                    let val = snapshot.value
                    let valu = val as? [String]
                    guard let value = valu else {return}
                    if value[0] != "" {
                        theysongArray = value
                    }
                    theysongArray.append("\(strongSelf.tDAppId)")
                    ref.setValue(theysongArray)
                    count+=1
                    if count == strongSelf.masterEngref.count {
                        completion(true)
                    }
                } else {
                    theysongArray.append("\(strongSelf.tDAppId)")
                    ref.setValue(theysongArray)
                    count+=1
                    if count == strongSelf.masterEngref.count {
                        completion(true)
                    }
                }
            })
        }
    }
    
    func updateRecordingEngineerVideos(completion: @escaping ((Bool) -> Void)) {
        if recEngref.isEmpty {
            completion(true)
            return
        }
        var count = 0
        for engie in recEngref {
            if songUploadVideos != [] {
                getPersonVideosInDB(cat: engie, completion: {[weak self] videos in
                    guard let strongSelf = self else {return}
                    var myvideosArray:Array<String> = []
                    myvideosArray = videos
                    //print("Videos in DB  for \(artist): \(videos)")
                    //print("Videos appending: \(strongSelf.songUploadVideos)")
                    myvideosArray.append(contentsOf: strongSelf.songUploadVideos)
                    //print("Videos Arry for \(artist): \(myvideosArray)")
                    if myvideosArray != [] {
                        Database.database().reference().child("Registered Persons").child(engie).child("Videos").setValue(myvideosArray)
                    }
                    count+=1
                    if count == strongSelf.recEngref.count {
                        
                        completion(true)
                    }
                })
            } else {
                count+=1
                if count == recEngref.count {
                    completion(true)
                }
            }
        }
    }
    
    func updateRecordingEngineerSongs(completion: @escaping ((Bool) -> Void)) {
        if recEngref.isEmpty {
            completion(true)
            return
        }
        var count = 0
        for engie in recEngref {
            getPersonSongsInDB(cat: engie, completion: {[weak self] songs in
                guard let strongSelf = self else {return}
                var mysongsArray:[String] = songs
                mysongsArray.append("\(strongSelf.tDAppId)")
                Database.database().reference().child("Registered Persons").child(engie).child("Songs").setValue(mysongsArray)
                
                count+=1
                if count == strongSelf.recEngref.count {
                    completion(true)
                }
                
            })
        }
    }
    
    func updateRecordingEngineerRoles(completion: @escaping ((Bool) -> Void)) {
        if recEngref.isEmpty {
            completion(true)
            return
        }
        var count = 0
        for engie in recEngref {
            let ref = Database.database().reference().child("Registered Persons").child(engie).child("Roles").child("Engineer").child("Recording Engineer")
            ref.observeSingleEvent(of: .value, with: {[weak self] snapshot in
                guard let strongSelf = self else {return}
                var theysongArray:[String] = []
                if !(snapshot.value is NSNull) {
                    let val = snapshot.value
                    let valu = val as? [String]
                    guard let value = valu else {return}
                    if value[0] != "" {
                        theysongArray = value
                    }
                    theysongArray.append("\(strongSelf.tDAppId)")
                    ref.setValue(theysongArray)
                    count+=1
                    if count == strongSelf.recEngref.count {
                        completion(true)
                    }
                } else {
                    theysongArray.append("\(strongSelf.tDAppId)")
                    ref.setValue(theysongArray)
                    count+=1
                    if count == strongSelf.recEngref.count {
                        completion(true)
                    }
                }
            })
        }
    }
    
    func getArtistRefs(completion: @escaping ((Bool) -> Void)) {
        //var tick = 0
        for artist in songArtists {
            Database.database().reference().child("Registered Persons").observeSingleEvent(of: .value, with: {[weak self] snapshot in
                guard let strongSelf = self else {return}
                for artis in snapshot.children {

                    let data = artis as! DataSnapshot
                    let key = data.key
                    if data.key.contains(artist) == true {
                        strongSelf.artistref.append(key)
                    }
                }
                
            })
        }
        completion(true)
    }
    
    func getPersonSongsInDB(cat: String, completion: @escaping (Array<String>) -> Void) {
        let ref = Database.database().reference().child("Registered Persons").child(cat).child("Songs")
        ref.observeSingleEvent(of: .value, with: { snapshot in
            var mysongsArray:[String] = []
            if let val = snapshot.value {
                let valu = val as? [String]
                guard let value = valu else {
                    completion(mysongsArray)
                    return}
                if value[0] != "" {
                    mysongsArray = value
                }
                completion(mysongsArray)
            } else {
                completion(mysongsArray)
            }
        })
    }
    
    func getPersonVideosInDB(cat: String, completion: @escaping (Array<String>) -> Void) {
        let ref = Database.database().reference().child("Registered Persons").child(cat).child("Videos")
        ref.observeSingleEvent(of: .value, with: { snapshot in
            
            var mysongsArray:[String] = []
            
            if let val = snapshot.value {
                let valu = val as? [String]
                guard let value = valu else {
                    completion(mysongsArray)
                    return}
                if value[0] != "" {
                    mysongsArray = value
                }
                print("videos from db \(mysongsArray)")
                completion(mysongsArray)
            } else {
                completion(mysongsArray)
            }
            //print(val)
        })
    }
    
    func getProducerRefs(completion: @escaping ((Bool) -> Void)) {
        //var tick = 0
        for producer in songProducers {
            Database.database().reference().child("Registered Persons").observeSingleEvent(of: .value, with: {[weak self] snapshot in
                guard let strongSelf = self else {return}
                for produce in snapshot.children {

                    let data = produce as! DataSnapshot
                    let key = data.key
                    if data.key.contains(producer) == true {
                        strongSelf.producerref.append(key)
                    }
                }
                
            })
        }
        completion(true)
    }
    
    func getWriterRefs(completion: @escaping ((Bool) -> Void)) {
        //var tick = 0
        for writer in songWriters {
            Database.database().reference().child("Registered Persons").observeSingleEvent(of: .value, with: {[weak self] snapshot in
                guard let strongSelf = self else {return}
                for write in snapshot.children {

                    let data = write as! DataSnapshot
                    let key = data.key
                    if data.key.contains(writer) == true {
                        strongSelf.writerref.append(key)
                    }
                }
                
            })
        }
        completion(true)
    }
    
    
    func getMixEngineerRefs(completion: @escaping ((Bool) -> Void)) {
        //var tick = 0
        for mixEng in songMixEngineer {
            Database.database().reference().child("Registered Persons").observeSingleEvent(of: .value, with: {[weak self] snapshot in
                guard let strongSelf = self else {return}
                for mixEn in snapshot.children {

                    let data = mixEn as! DataSnapshot
                    let key = data.key
                    if data.key.contains(mixEng) == true {
                        strongSelf.mixEngref.append(key)
                    }
                }
                
            })
        }
        completion(true)
    }
    
    func getMasteringEngineerRefs(completion: @escaping ((Bool) -> Void)) {
        //var tick = 0
        for masEng in songMasteringEngineer {
            Database.database().reference().child("Registered Persons").observeSingleEvent(of: .value, with: {[weak self] snapshot in
                guard let strongSelf = self else {return}
                for masEn in snapshot.children {

                    let data = masEn as! DataSnapshot
                    let key = data.key
                    if data.key.contains(masEng) == true {
                        strongSelf.masterEngref.append(key)
                    }
                }
                
            })
        }
        completion(true)
    }
    
    func getRecordingEngineerRefs(completion: @escaping ((Bool) -> Void)) {
        //var tick = 0
        for recEng in songRecordingEngineer {
            Database.database().reference().child("Registered Persons").observeSingleEvent(of: .value, with: {[weak self] snapshot in
                guard let strongSelf = self else {return}
                for recEn in snapshot.children {

                    let data = recEn as! DataSnapshot
                    let key = data.key
                    if data.key.contains(recEng) == true {
                        strongSelf.recEngref.append(key)
                    }
                }
                
            })
        }
        completion(true)
    }
    
    func generateAppId() {
        let genid = StorageManager.shared.generateRandomNumber(digits: 10)
        DatabaseManager.shared.checkIfAppIdExists(appid: genid, completion: { [weak self] result in
            guard let strongSelf = self else {return}
            //print(result)
            
            if result == true {
                strongSelf.generateAppId()
                
            } else {
                strongSelf.uploadCompletionStatus4 = true
                strongSelf.progressCompleted+=1
                strongSelf.progressView.progress = (strongSelf.progressCompleted/strongSelf.totalProgress)
                print("\(strongSelf.progressCompleted) out of \(strongSelf.totalProgress)")
                strongSelf.tDAppId = genid
                strongSelf.gatherUploadData()
                //print(strongSelf.tDAppId)
                
            }
        })
    }
    
    func generateVideoAppId(completion: @escaping ((String) -> Void)) {
        let genid = StorageManager.shared.generateRandomNumber(digits: 9)
        DatabaseManager.shared.checkIfVideoAppIdExists(appid: genid, completion: { [weak self] result in
            guard let strongSelf = self else {return}
            //print(result)
            
            if result == true {
                strongSelf.generateVideoAppId(completion: {_ in 
                    
                })
                
            } else {
                strongSelf.uploadCompletionStatus1 = true
                strongSelf.progressCompleted+=1
                strongSelf.progressView.progress = (strongSelf.progressCompleted/strongSelf.totalProgress)
                print("\(strongSelf.progressCompleted) out of \(strongSelf.totalProgress)")
                print(genid)
                completion(genid)
                
            }
        })
    }
    
    func spotifySong(completion: @escaping ((Bool) -> Void)) {
        DispatchQueue.main.async {[weak self] in
            guard let strongSelf = self else {return}
            guard strongSelf.spotifyTextField.text != "" else {
                completion(true)
                return}
            guard strongSelf.spotifyTextField.text!.count > 15 else {
                Utilities.showError2("Failed to Upload. Spotify url invalid.", actionText: "OK")
                completion(true)
                return}
            var spotUrl = strongSelf.spotifyTextField.text!
            if let dotRange = spotUrl.range(of: "?") {
                spotUrl.removeSubrange(dotRange.lowerBound..<spotUrl.endIndex)
            }
            let songId = String(spotUrl.suffix(22))
            let token = (UserDefaults.standard.object(forKey: "SPTaccesstoken") as? String)!
            
            SpotifyRequest.shared.getTrackInfo(accessToken: token, id: songId, name: strongSelf.songName, artists: strongSelf.songArtists, producers: strongSelf.songProducers, writers: strongSelf.songWriters, mixEngineer: strongSelf.songMixEngineer, masteringEngineer: strongSelf.songMasteringEngineer, recordingEngineer: strongSelf.songRecordingEngineer, dateobj: strongSelf.date, appid: strongSelf.tDAppId, instsongid: "", instrContentRandomKey: "", certifi: strongSelf.industryCertified, verifi: strongSelf.verificationLevel, explicit: strongSelf.explicit, completion: { done in
                guard done == true else {
                    
                    Utilities.showError2("Failed to Upload. Spotify failure. Please try again.", actionText: "OK")
                    completion(false)
                    return
                }
                print("Spotify Completion True")
                completion(true)
                return
            })
        }
        
    }
    
    func appleMusicSong(completion: @escaping ((Bool) -> Void)) {
        DispatchQueue.main.async {[weak self] in
            guard let strongSelf = self else {return}
            guard strongSelf.appleMusicTextField.text != "" else {
                completion(true)
                return}
            guard strongSelf.appleMusicTextField.text!.count > 15 else {
                Utilities.showError2("Failed to Upload. Apple Music url invalid.", actionText: "OK")
                completion(true)
                return}
            let songId = String((strongSelf.appleMusicTextField.text?.suffix(10))!)
            AppleMusicRequest.shared.getAppleMusicSong(id: songId, name: strongSelf.songName, artists: strongSelf.songArtists, producers: strongSelf.songProducers, writers: strongSelf.songWriters, mixEngineer: strongSelf.songMixEngineer, masteringEngineer: strongSelf.songMasteringEngineer, recordingEngineer: strongSelf.songRecordingEngineer, dateobj: strongSelf.date, appid: strongSelf.tDAppId, instsongid: "", instrContentRandomKey: "", certifi: strongSelf.industryCertified, verifi: strongSelf.verificationLevel, explicit: strongSelf.explicit, completion: { done in
                guard done == true else {
                    Utilities.showError2("Failed to Upload. Please try again.", actionText: "OK")
                    completion(false)
                    return
                }
                completion(true)
                return
            })
        }
    }
    
    func soundcloudSong(completion: @escaping ((Bool) -> Void)) {
        var url = ""
        DispatchQueue.main.async {[weak self] in
            guard let strongSelf = self else {return}
            guard strongSelf.souncloudTextField.text != "" else {
            completion(true)
            return}
            guard strongSelf.souncloudTextField.text!.count > 15 else {
            Utilities.showError2("Failed to Upload. Soundcloud url invalid.", actionText: "OK")
            completion(false)
            return}
            url = strongSelf.souncloudTextField.text!
            let formatter = DateFormatter()
            formatter.timeZone = TimeZone(identifier: "EDT")
            formatter.dateFormat = "MMMM dd, yyyy"
            let newDate = formatter.string(from: strongSelf.date)
            
            let timeFormatter = DateFormatter()
            timeFormatter.dateFormat = "HH:mm:ss a"
            timeFormatter.timeZone = TimeZone(identifier: "EDT")
            let newTime = timeFormatter.string(from: strongSelf.date)
            
            let categorty = "\(songContentTag)--\(strongSelf.songName)--\(strongSelf.tDAppId)"
            let soundcloudContentRandomKey = ("\(soundcloudMusicContentType)--\(strongSelf.songName)--\(newDate)--\(newTime)")
            
            var RequiredInfoMa = [String : Any]()
            RequiredInfoMa = [
                "Tone Deaf App Id" : strongSelf.tDAppId,
                "Name" : strongSelf.songName,
                "Artist" : strongSelf.songArtists,
                "Producers" : strongSelf.songProducers,
                "Writers": strongSelf.songWriters,
                "Engineers": [
                    "Mix Engineer": strongSelf.songMixEngineer,
                    "Mastering Engineer": strongSelf.songMasteringEngineer,
                    "Recording Engineer": strongSelf.songRecordingEngineer
                ],
                "Number of Favorites Overall" : 0,
                "Instrumentals": [],
                "Albums" : [],
                "Date Registered To App": newDate,
                "Time Registered To App": newTime,
                "Verification Level": String(strongSelf.verificationLevel),
                "Industry Certified": strongSelf.industryCertified,
                "Explicit": strongSelf.explicit,
                "Active Status": false
            ]
            
            let RequiredRef = Database.database().reference().child("Music Content").child("Songs").child(categorty).child("REQUIRED")
            
            if strongSelf.songUploadVideos.isEmpty || strongSelf.songUploadVideos == [""] {
                RequiredRef.child("Videos").setValue([])
            }
            
            RequiredRef.updateChildValues(RequiredInfoMa) { (error, songRef) in
                if let error = error {
                    print("📕 Failed to upload dictionary to database: \(error)")
                    completion(false)
                    return
                } else {
                    var SongInfoMap = [String : Any]()
                    SongInfoMap = [
                        "url" : url,
                        "Active Status": false]
                    
                    let SongRef = Database.database().reference().child("Music Content").child("Songs").child(categorty).child(soundcloudContentRandomKey)
                    
                    SongRef.updateChildValues(SongInfoMap) { [weak self] (error, songRef) in
                        guard let strongSelf = self else {return}
                        if let error = error {
                            print("📕 Failed to upload dictionary to database: \(error)")
                            Utilities.showError2("Failed to Upload. Please try again.", actionText: "OK")
                            completion(false)
                            return
                        } else {
                            print("📗 Soundcloud data for \(strongSelf.songName) saved to database successfully.")
                            completion(true)
                            return
                        }
                    }
                }
            }
        }
        
    }
    
    func youtubeMusicSong(completion: @escaping ((Bool) -> Void)) {
        var url = ""
        DispatchQueue.main.async {[weak self] in
            guard let strongSelf = self else {return}
            guard strongSelf.youtubeMusicTextField.text != "" else {
            completion(true)
            return}
            guard strongSelf.youtubeMusicTextField.text!.count > 15 else {
            Utilities.showError2("Failed to Upload. Youtube Music url invalid.", actionText: "OK")
            completion(false)
            return}
            url = strongSelf.youtubeMusicTextField.text!
            
            let formatter = DateFormatter()
            formatter.timeZone = TimeZone(identifier: "EDT")
            formatter.dateFormat = "MMMM dd, yyyy"
            let newDate = formatter.string(from: strongSelf.date)
            
            let timeFormatter = DateFormatter()
            timeFormatter.dateFormat = "HH:mm:ss a"
            timeFormatter.timeZone = TimeZone(identifier: "EDT")
            let newTime = timeFormatter.string(from: strongSelf.date)
            
            let categorty = "\(songContentTag)--\(strongSelf.songName)--\(strongSelf.tDAppId)"
            let youtubeMusicContentRandomKey = ("\(youtubeMusicContentType)--\(strongSelf.songName)--\(newDate)--\(newTime)")
            
            var RequiredInfoMa = [String : Any]()
            RequiredInfoMa = [
                "Tone Deaf App Id" : strongSelf.tDAppId,
                "Name" : strongSelf.songName,
                "Artist" : strongSelf.songArtists,
                "Producers" : strongSelf.songProducers,
                "Writers": strongSelf.songWriters,
                "Engineers": [
                    "Mix Engineer": strongSelf.songMixEngineer,
                    "Mastering Engineer": strongSelf.songMasteringEngineer,
                    "Recording Engineer": strongSelf.songRecordingEngineer
                ],
                "Number of Favorites Overall" : 0,
                "Instrumentals": [],
                "Albums" : [],
                "Date Registered To App": newDate,
                "Time Registered To App": newTime,
                "Verification Level": String(strongSelf.verificationLevel),
                "Industry Certified": strongSelf.industryCertified,
                "Explicit": strongSelf.explicit,
                "Active Status": false
            ]
            
            let RequiredRef = Database.database().reference().child("Music Content").child("Songs").child(categorty).child("REQUIRED")
            RequiredRef.updateChildValues(RequiredInfoMa) { [weak self] (error, songRef) in
                guard let strongSelf = self else {return}
                if let error = error {
                    print("📕 Failed to upload dictionary to database: \(error)")
                    completion(false)
                    return
                } else {
                    var SongInfoMap = [String : Any]()
                    SongInfoMap = [
                        "url" : url,
                        "Active Status": false]
                    
                    let SongRef = Database.database().reference().child("Music Content").child("Songs").child(categorty).child(youtubeMusicContentRandomKey)
                    
                    SongRef.updateChildValues(SongInfoMap) { [weak self] (error, songRef) in
                        guard let strongSelf = self else {return}
                        if let error = error {
                            print("📕 Failed to upload dictionary to database: \(error)")
                            Utilities.showError2("Failed to Upload. Please try again.", actionText: "OK")
                            completion(false)
                            return
                        } else {
                            print("📗 Soundcloud data for \(strongSelf.songName) saved to database successfully.")
                            completion(true)
                            return
                        }
                    }
                }
            }
        }
    }
    
    func amazonSong(completion: @escaping ((Bool) -> Void)) {
        var url = ""
        DispatchQueue.main.async {[weak self] in
            guard let strongSelf = self else {return}
            guard strongSelf.amazonTextField.text != "" else {
            completion(true)
            return}
            guard strongSelf.amazonTextField.text!.count > 15 else {
            Utilities.showError2("Failed to Upload. Amazon url invalid.", actionText: "OK")
            completion(false)
            return}
            url = strongSelf.amazonTextField.text!
            
            let formatter = DateFormatter()
            formatter.timeZone = TimeZone(identifier: "EDT")
            formatter.dateFormat = "MMMM dd, yyyy"
            let newDate = formatter.string(from: strongSelf.date)
            
            let timeFormatter = DateFormatter()
            timeFormatter.dateFormat = "HH:mm:ss a"
            timeFormatter.timeZone = TimeZone(identifier: "EDT")
            let newTime = timeFormatter.string(from: strongSelf.date)
            
            let categorty = "\(songContentTag)--\(strongSelf.songName)--\(strongSelf.tDAppId)"
            let amazonContentRandomKey = ("\(amazonMusicContentType)--\(strongSelf.songName)--\(newDate)--\(newTime)")
            
            var RequiredInfoMa = [String : Any]()
            RequiredInfoMa = [
                "Tone Deaf App Id" : strongSelf.tDAppId,
                "Name" : strongSelf.songName,
                "Artist" : strongSelf.songArtists,
                "Producers" : strongSelf.songProducers,
                "Writers": strongSelf.songWriters,
                "Engineers": [
                    "Mix Engineer": strongSelf.songMixEngineer,
                    "Mastering Engineer": strongSelf.songMasteringEngineer,
                    "Recording Engineer": strongSelf.songRecordingEngineer
                ],
                "Number of Favorites Overall" : 0,
                "Instrumentals": [],
                "Albums" : [],
                "Date Registered To App": newDate,
                "Time Registered To App": newTime,
                "Verification Level": String(strongSelf.verificationLevel),
                "Industry Certified": strongSelf.industryCertified,
                "Explicit": strongSelf.explicit,
                "Active Status": false
            ]
            
            let RequiredRef = Database.database().reference().child("Music Content").child("Songs").child(categorty).child("REQUIRED")
            RequiredRef.updateChildValues(RequiredInfoMa) { [weak self] (error, songRef) in
                guard let strongSelf = self else {return}
                if let error = error {
                    print("📕 Failed to upload dictionary to database: \(error)")
                    completion(false)
                    return
                } else {
                    var SongInfoMap = [String : Any]()
                    SongInfoMap = [
                        "url" : url,
                        "Active Status": false
                    ]
                    
                    let SongRef = Database.database().reference().child("Music Content").child("Songs").child(categorty).child(amazonContentRandomKey)
                    
                    SongRef.updateChildValues(SongInfoMap) { [weak self] (error, songRef) in
                        guard let strongSelf = self else {return}
                        if let error = error {
                            print("📕 Failed to upload dictionary to database: \(error)")
                            Utilities.showError2("Failed to Upload. Please try again.", actionText: "OK")
                            completion(false)
                            return
                        } else {
                            print("📗 Soundcloud data for \(strongSelf.songName) saved to database successfully.")
                            completion(true)
                            return
                        }
                    }
                }
            }
        }
    }
    
    func tidalSong(completion: @escaping ((Bool) -> Void)) {
        var url = ""
        DispatchQueue.main.async {[weak self] in
            guard let strongSelf = self else {return}
            guard strongSelf.tidalTextField.text != "" else {
            completion(true)
            return}
            guard strongSelf.tidalTextField.text!.count > 15 else {
            Utilities.showError2("Failed to Upload. Tidal url invalid.", actionText: "OK")
            completion(false)
            return}
            url = strongSelf.tidalTextField.text!
            
            let formatter = DateFormatter()
            formatter.timeZone = TimeZone(identifier: "EDT")
            formatter.dateFormat = "MMMM dd, yyyy"
            let newDate = formatter.string(from: strongSelf.date)
            
            let timeFormatter = DateFormatter()
            timeFormatter.dateFormat = "HH:mm:ss a"
            timeFormatter.timeZone = TimeZone(identifier: "EDT")
            let newTime = timeFormatter.string(from: strongSelf.date)
            
            let categorty = "\(songContentTag)--\(strongSelf.songName)--\(strongSelf.tDAppId)"
            let tidalContentRandomKey = ("\(tidalMusicContentType)--\(strongSelf.songName)--\(newDate)--\(newTime)")
            
            var RequiredInfoMa = [String : Any]()
            RequiredInfoMa = [
                "Tone Deaf App Id" : strongSelf.tDAppId,
                "Name" : strongSelf.songName,
                "Artist" : strongSelf.songArtists,
                "Producers" : strongSelf.songProducers,
                "Writers": strongSelf.songWriters,
                "Engineers": [
                    "Mix Engineer": strongSelf.songMixEngineer,
                    "Mastering Engineer": strongSelf.songMasteringEngineer,
                    "Recording Engineer": strongSelf.songRecordingEngineer
                ],
                "Number of Favorites Overall" : 0,
                "Instrumentals": [],
                "Albums" : [],
                "Date Registered To App": newDate,
                "Time Registered To App": newTime,
                "Verification Level": String(strongSelf.verificationLevel),
                "Industry Certified": strongSelf.industryCertified,
                "Explicit": strongSelf.explicit,
                "Active Status": false
            ]
            
            let RequiredRef = Database.database().reference().child("Music Content").child("Songs").child(categorty).child("REQUIRED")
            RequiredRef.updateChildValues(RequiredInfoMa) { [weak self] (error, songRef) in
                guard let strongSelf = self else {return}
                if let error = error {
                    print("📕 Failed to upload dictionary to database: \(error)")
                    completion(false)
                    return
                } else {
                    var SongInfoMap = [String : Any]()
                    SongInfoMap = [
                        "url" : url,
                        "Active Status": false]
                    
                    let SongRef = Database.database().reference().child("Music Content").child("Songs").child(categorty).child(tidalContentRandomKey)
                    
                    SongRef.updateChildValues(SongInfoMap) { [weak self] (error, songRef) in
                        guard let strongSelf = self else {return}
                        if let error = error {
                            print("📕 Failed to upload dictionary to database: \(error)")
                            Utilities.showError2("Failed to Upload. Please try again.", actionText: "OK")
                            completion(false)
                            return
                        } else {
                            print("📗 Soundcloud data for \(strongSelf.songName) saved to database successfully.")
                            completion(true)
                            return
                        }
                    }
                }
            }
        }
    }
    
    func spinrillaSong(completion: @escaping ((Bool) -> Void)) {
        var url = ""
        DispatchQueue.main.async {[weak self] in
            guard let strongSelf = self else {return}
            guard strongSelf.spinrillaTextField.text != "" else {
            completion(true)
            return}
            guard strongSelf.spinrillaTextField.text!.count > 15 else {
            Utilities.showError2("Failed to Upload. Spinrilla url invalid.", actionText: "OK")
            completion(false)
            return}
            url = strongSelf.spinrillaTextField.text!
            
            let formatter = DateFormatter()
            formatter.timeZone = TimeZone(identifier: "EDT")
            formatter.dateFormat = "MMMM dd, yyyy"
            let newDate = formatter.string(from: strongSelf.date)
            
            let timeFormatter = DateFormatter()
            timeFormatter.dateFormat = "HH:mm:ss a"
            timeFormatter.timeZone = TimeZone(identifier: "EDT")
            let newTime = timeFormatter.string(from: strongSelf.date)
            
            let categorty = "\(songContentTag)--\(strongSelf.songName)--\(strongSelf.tDAppId)"
            let spinrillaContentRandomKey = ("\(spinrillaMusicContentType)--\(strongSelf.songName)--\(newDate)--\(newTime)")
            
            var RequiredInfoMa = [String : Any]()
            RequiredInfoMa = [
                "Tone Deaf App Id" : strongSelf.tDAppId,
                "Name" : strongSelf.songName,
                "Artist" : strongSelf.songArtists,
                "Producers" : strongSelf.songProducers,
                "Writers": strongSelf.songWriters,
                "Engineers": [
                    "Mix Engineer": strongSelf.songMixEngineer,
                    "Mastering Engineer": strongSelf.songMasteringEngineer,
                    "Recording Engineer": strongSelf.songRecordingEngineer
                ],
                "Number of Favorites Overall" : 0,
                "Instrumentals": [],
                "Albums" : [],
                "Date Registered To App": newDate,
                "Time Registered To App": newTime,
                "Verification Level": String(strongSelf.verificationLevel),
                "Industry Certified": strongSelf.industryCertified,
                "Explicit": strongSelf.explicit,
                "Active Status": false
            ]
            
            let RequiredRef = Database.database().reference().child("Music Content").child("Songs").child(categorty).child("REQUIRED")
            RequiredRef.updateChildValues(RequiredInfoMa) { [weak self] (error, songRef) in
                guard let strongSelf = self else {return}
                if let error = error {
                    print("📕 Failed to upload dictionary to database: \(error)")
                    completion(false)
                    return
                } else {
                    var SongInfoMap = [String : Any]()
                    SongInfoMap = [
                        "url" : url,
                        "Active Status": false]
                    
                    let SongRef = Database.database().reference().child("Music Content").child("Songs").child(categorty).child(spinrillaContentRandomKey)
                    
                    SongRef.updateChildValues(SongInfoMap) { [weak self] (error, songRef) in
                        guard let strongSelf = self else {return}
                        if let error = error {
                            print("📕 Failed to upload dictionary to database: \(error)")
                            Utilities.showError2("Failed to Upload. Please try again.", actionText: "OK")
                            completion(false)
                            return
                        } else {
                            print("📗 Spinrilla data for \(strongSelf.songName) saved to database successfully.")
                            completion(true)
                            return
                        }
                    }
                }
            }
        }
        
    }
    
    func napsterSong(completion: @escaping ((Bool) -> Void)) {
        var url = ""
        DispatchQueue.main.async {[weak self] in
            guard let strongSelf = self else {return}
            guard strongSelf.napsterTextField.text != "" else {
            completion(true)
            return}
            guard strongSelf.napsterTextField.text!.count > 15 else {
            Utilities.showError2("Failed to Upload. Napster url invalid.", actionText: "OK")
            completion(false)
            return}
            url = strongSelf.napsterTextField.text!
            
            let formatter = DateFormatter()
            formatter.timeZone = TimeZone(identifier: "EDT")
            formatter.dateFormat = "MMMM dd, yyyy"
            let newDate = formatter.string(from: strongSelf.date)
            
            let timeFormatter = DateFormatter()
            timeFormatter.dateFormat = "HH:mm:ss a"
            timeFormatter.timeZone = TimeZone(identifier: "EDT")
            let newTime = timeFormatter.string(from: strongSelf.date)
            
            let categorty = "\(songContentTag)--\(strongSelf.songName)--\(strongSelf.songArtistsNames.joined(separator: ", "))--\(strongSelf.tDAppId)"
            let napsterContentRandomKey = ("\(napsterMusicContentType)--\(strongSelf.songName)--\(newDate)--\(newTime)")
            
            var RequiredInfoMa = [String : Any]()
            RequiredInfoMa = [
                "Tone Deaf App Id" : strongSelf.tDAppId,
                "Name" : strongSelf.songName,
                "Artist" : strongSelf.songArtists,
                "Producers" : strongSelf.songProducers,
                "Writers": strongSelf.songWriters,
                "Engineers": [
                    "Mix Engineer": strongSelf.songMixEngineer,
                    "Mastering Engineer": strongSelf.songMasteringEngineer,
                    "Recording Engineer": strongSelf.songRecordingEngineer
                ],
                "Number of Favorites Overall" : 0,
                "Instrumentals": [],
                "Albums" : [],
                "Date Registered To App": newDate,
                "Time Registered To App": newTime,
                "Verification Level": String(strongSelf.verificationLevel),
                "Industry Certified": strongSelf.industryCertified,
                "Explicit": strongSelf.explicit,
                "Active Status": false
            ]
            
            let RequiredRef = Database.database().reference().child("Music Content").child("Songs").child(categorty).child("REQUIRED")
            RequiredRef.updateChildValues(RequiredInfoMa) { [weak self] (error, songRef) in
                guard let strongSelf = self else {return}
                if let error = error {
                    print("📕 Failed to upload dictionary to database: \(error)")
                    completion(false)
                    return
                } else {
                    var SongInfoMap = [String : Any]()
                    SongInfoMap = [
                        "url" : url,
                        "Active Status": false]
                    
                    let SongRef = Database.database().reference().child("Music Content").child("Songs").child(categorty).child(napsterContentRandomKey)
                    
                    SongRef.updateChildValues(SongInfoMap) { [weak self] (error, songRef) in
                        guard let strongSelf = self else {return}
                        if let error = error {
                            print("📕 Failed to upload dictionary to database: \(error)")
                            Utilities.showError2("Failed to Upload. Please try again.", actionText: "OK")
                            completion(false)
                            return
                        } else {
                            print("📗 Napster data for \(strongSelf.songName) saved to database successfully.")
                            completion(true)
                            return
                        }
                    }
                }
            }
        }
    }
    
    func deezerSong(completion: @escaping ((Bool) -> Void)) {
        DispatchQueue.main.async {[weak self] in
            guard let strongSelf = self else {return}
            guard strongSelf.deezerTextField.text != "" else {
                completion(true)
                return}
            guard strongSelf.deezerTextField.text!.count > 15 else {
                Utilities.showError2("Failed to Upload. Deezer Music url invalid.", actionText: "OK")
                completion(true)
                return}
            var deezUrl = strongSelf.deezerTextField.text!
            if let dotRange = deezUrl.range(of: "?") {
                deezUrl.removeSubrange(dotRange.lowerBound..<deezUrl.endIndex)
            }
            let songId = String(deezUrl.suffix(10))
            DeezerRequest.shared.getSongInfo(id: songId, name: strongSelf.songName, artists: strongSelf.songArtists, producers: strongSelf.songProducers, writers: strongSelf.songWriters, mixEngineer: strongSelf.songMixEngineer, masteringEngineer: strongSelf.songMasteringEngineer, recordingEngineer: strongSelf.songRecordingEngineer, dateobj: strongSelf.date, appid: strongSelf.tDAppId, instsongid: "", instrContentRandomKey: "", certifi: strongSelf.industryCertified, verifi: strongSelf.verificationLevel, explicit: strongSelf.explicit, completion: { done in
                guard done == true else {
                    Utilities.showError2("Failed to Upload Deezer Song. Please try again.", actionText: "OK")
                    completion(false)
                    return
                }
                completion(true)
                return
            })
        }
    }
    
    func storeRemixToStandardEdition(completion: @escaping ((Error?) -> Void)) {
        let categorty = "\(songContentTag)--\(songName)--\(tDAppId)"
        let RequiredRef = Database.database().reference().child("Music Content").child("Songs").child(categorty).child("REQUIRED").child("Remix")
        if remixAlbum != false {
            let item:NSDictionary = [
                "Status": true,
                "Standard Edition": remixOf
            ]
            RequiredRef.setValue(item)
        }
        if remixOf == nil  {
            completion(nil)
            return
        }
        DatabaseManager.shared.findSongById(songId: remixOf!, completion: {[weak self] result in
            guard let strongSelf = self else {return}
            switch result {
            case .success(let songv):
                if var arr = songv.remixes {
                    if !arr.contains(strongSelf.tDAppId) {
                        arr.append(strongSelf.tDAppId)
                    }
                    Database.database().reference().child("Music Content").child("Songs").child("\(songContentTag)--\(songv.name)--\(songv.toneDeafAppId)").child("REQUIRED").child("Remixes").setValue(arr.sorted(), withCompletionBlock: { error, reference in
                        if let error = error {
                            completion(error)
                            return
                        }
                        else {
                            completion(nil)
                            return
                        }
                    })
                } else {
                    let arr = [strongSelf.tDAppId]
                    Database.database().reference().child("Music Content").child("Songs").child("\(songContentTag)--\(songv.name)--\(songv.toneDeafAppId)").child("REQUIRED").child("Remixes").setValue(arr.sorted(), withCompletionBlock: { error, reference in
                        if let error = error {
                            completion(error)
                            return
                        }
                        else {
                            completion(nil)
                            return
                        }
                    })
                }
            case .failure(let err):
                print("fufhedkfjv ", err)
            default:
                break
            }
        })
    }
    
    func storeOtherVersionToStandardEditionSong(completion: @escaping ((Error?) -> Void)) {
        let categorty = "\(songContentTag)--\(songName)--\(tDAppId)"
        let RequiredRef = Database.database().reference().child("Music Content").child("Songs").child(categorty).child("REQUIRED").child("Other Version")
        if otherVersionsAlbum != false {
            let item:NSDictionary = [
                "Status": true,
                "Standard Edition": otherVersionsOf
            ]
            RequiredRef.setValue(item)
        }
        if otherVersionsOf == nil  {
            completion(nil)
            return
        }
        DatabaseManager.shared.findSongById(songId: otherVersionsOf!, completion: {[weak self] result in
            guard let strongSelf = self else {return}
            switch result {
            case .success(let songv):
                if var arr = songv.otherVersions {
                    if !arr.contains(strongSelf.tDAppId) {
                        arr.append(strongSelf.tDAppId)
                    }
                    Database.database().reference().child("Music Content").child("Songs").child("\(songContentTag)--\(songv.name)--\(songv.toneDeafAppId)").child("REQUIRED").child("Other Versions").setValue(arr.sorted(), withCompletionBlock: { error, reference in
                        if let error = error {
                            completion(error)
                            return
                        }
                        else {
                            completion(nil)
                            return
                        }
                    })
                } else {
                    let arr = [strongSelf.tDAppId]
                    Database.database().reference().child("Music Content").child("Songs").child("\(songContentTag)--\(songv.name)--\(songv.toneDeafAppId)").child("REQUIRED").child("Other Versions").setValue(arr.sorted(), withCompletionBlock: { error, reference in
                        if let error = error {
                            completion(error)
                            return
                        }
                        else {
                            completion(nil)
                            return
                        }
                    })
                }
            case .failure(let err):
                print("fufhedkfjv ", err)
            default:
                break
            }
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
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @objc func dismissKeyboard2() {
        songArtists.append("\(chosenArtist.trimmingCharacters(in: .whitespacesAndNewlines))")
        songArtistsNames.append(chosenArtistNames.trimmingCharacters(in: .whitespacesAndNewlines))
        artistTextField.text = songArtistsNames.joined(separator: ", ")
        songArtists.sort()
        view.endEditing(true)
    }
    
    @objc func dismissKeyboard3() {
        songProducers.append("\(chosenProducer.trimmingCharacters(in: .whitespacesAndNewlines))")
        songProducerNames.append(chosenProducerNames.trimmingCharacters(in: .whitespacesAndNewlines))
        producerTextField.text = songProducerNames.joined(separator: ", ")
        songProducers.sort()
        view.endEditing(true)
    }
    
    @objc func dismissKeyboard4() {
        songWriters.append("\(chosenWriter.trimmingCharacters(in: .whitespacesAndNewlines))")
        songWriterNames.append(chosenWriterNames.trimmingCharacters(in: .whitespacesAndNewlines))
        writerTextField.text = songWriterNames.joined(separator: ", ")
        songWriters.sort()
        view.endEditing(true)
    }
    
    @objc func dismissKeyboard5() {
        songMixEngineer.append("\(chosenMixEng.trimmingCharacters(in: .whitespacesAndNewlines))")
        songMixEngineerNames.append(chosenMixEngNames.trimmingCharacters(in: .whitespacesAndNewlines))
        engineerMixTextField.text = songMixEngineerNames.joined(separator: ", ")
        songMixEngineer.sort()
        view.endEditing(true)
    }
    
    @objc func dismissKeyboard6() {
        songMasteringEngineer.append("\(chosenMasterEng.trimmingCharacters(in: .whitespacesAndNewlines))")
        songMasteringEngineerNames.append(chosenMasterEngNames.trimmingCharacters(in: .whitespacesAndNewlines))
        engineerMasteringTextField.text = songMasteringEngineerNames.joined(separator: ", ")
        songMasteringEngineer.sort()
        view.endEditing(true)
    }
    
    @objc func dismissKeyboard7() {
        songRecordingEngineer.append("\(chosenRecEng.trimmingCharacters(in: .whitespacesAndNewlines))")
        songRecordingEngineerNames.append(chosenRecEngNames.trimmingCharacters(in: .whitespacesAndNewlines))
        engineerRecordingTextField.text = songRecordingEngineerNames.joined(separator: ", ")
        songRecordingEngineer.sort()
        view.endEditing(true)
    }
    
    @objc func dismissKeyboard8() {
        remixOf = remixHold[0]
        remixOfTextField.text = remixHold[1]
        view.endEditing(true)
    }
    
    @objc func dismissKeyboard9() {
        otherVersionsOf = otherVersionsHold[0]
        otherVersionsOfTextField.text = otherVersionsHold[1]
        view.endEditing(true)
    }

}

extension SongUploadViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        var nor = 0
        switch pickerView {
        case personPickerView:
            nor = AllPersonsInDatabaseArray.count
        case verificationLevelPickerView:
            nor = verificationLevelArr.count
        case remixOfPickerView:
            nor = AllSongsInDatabaseArray.count
        case otherVersionsOfPickerView:
            nor = AllSongsInDatabaseArray.count
        default:
            break
        }
        return nor
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        var nor = ""
        switch pickerView {
        case personPickerView:
            nor = "\(AllPersonsInDatabaseArray[row].name ?? "person") -- \(AllPersonsInDatabaseArray[row].toneDeafAppId)"
        case verificationLevelPickerView:
            nor = String(verificationLevelArr[row])
        case remixOfPickerView:
            if component == 0 {
                nor = "\(AllSongsInDatabaseArray[row].name) -- \(AllSongsInDatabaseArray[row].toneDeafAppId)"
            }
        case otherVersionsOfPickerView:
            if component == 0 {
                nor = "\(AllSongsInDatabaseArray[row].name) -- \(AllSongsInDatabaseArray[row].toneDeafAppId)"
            }
        default:
            break
        }
        return nor
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == personPickerView {
            if artistTextField.isEditing {
                chosenArtist = AllPersonsInDatabaseArray[row].toneDeafAppId.trimmingCharacters(in: .whitespacesAndNewlines)
                chosenArtistNames = AllPersonsInDatabaseArray[row].name!.trimmingCharacters(in: .whitespacesAndNewlines)
            }
            if producerTextField.isEditing {
                chosenProducer = AllPersonsInDatabaseArray[row].toneDeafAppId.trimmingCharacters(in: .whitespacesAndNewlines)
                chosenProducerNames = AllPersonsInDatabaseArray[row].name!.trimmingCharacters(in: .whitespacesAndNewlines)
            }
            if writerTextField.isEditing {
                chosenWriter = AllPersonsInDatabaseArray[row].toneDeafAppId.trimmingCharacters(in: .whitespacesAndNewlines)
                chosenWriterNames = AllPersonsInDatabaseArray[row].name!.trimmingCharacters(in: .whitespacesAndNewlines)
            }
            if engineerMixTextField.isEditing {
                chosenMixEng = AllPersonsInDatabaseArray[row].toneDeafAppId.trimmingCharacters(in: .whitespacesAndNewlines)
                chosenMixEngNames = AllPersonsInDatabaseArray[row].name!.trimmingCharacters(in: .whitespacesAndNewlines)
            }
            if engineerMasteringTextField.isEditing {
                chosenMasterEng = AllPersonsInDatabaseArray[row].toneDeafAppId.trimmingCharacters(in: .whitespacesAndNewlines)
                chosenMasterEngNames = AllPersonsInDatabaseArray[row].name!.trimmingCharacters(in: .whitespacesAndNewlines)
            }
            if engineerRecordingTextField.isEditing {
                chosenRecEng = AllPersonsInDatabaseArray[row].toneDeafAppId.trimmingCharacters(in: .whitespacesAndNewlines)
                chosenRecEngNames = AllPersonsInDatabaseArray[row].name!.trimmingCharacters(in: .whitespacesAndNewlines)
            }
        }
        
        if pickerView == verificationLevelPickerView {
            verificationLevelTextField.text = String(verificationLevelArr[row])
            verificationLevel = verificationLevelArr[row]
        }
        if pickerView == remixOfPickerView {
            remixHold = [AllSongsInDatabaseArray[row].toneDeafAppId, AllSongsInDatabaseArray[row].name]
        }
        if pickerView == otherVersionsOfPickerView {
            otherVersionsHold = [AllSongsInDatabaseArray[row].toneDeafAppId, AllSongsInDatabaseArray[row].name]
        }
    }
    
    func pickerViewToolbar(textField:UITextField, pickerView:UIPickerView) {
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor.init(red: 182/255, green: 0/255, blue: 3/255, alpha: 1)
        toolBar.sizeToFit()

        var doneButton = UIBarButtonItem()
        if pickerView == remixOfPickerView {
            doneButton = UIBarButtonItem(title: "Select", style: UIBarButtonItem.Style.done, target: self, action: #selector(dismissKeyboard8))
        } else
        if pickerView == otherVersionsOfPickerView {
            doneButton = UIBarButtonItem(title: "Select", style: UIBarButtonItem.Style.done, target: self, action: #selector(dismissKeyboard9))
        } else
        if pickerView == personPickerView {
            switch textField {
            case artistTextField:
                doneButton = UIBarButtonItem(title: "Add", style: UIBarButtonItem.Style.done, target: self, action: #selector(dismissKeyboard2))
            case producerTextField:
                doneButton = UIBarButtonItem(title: "Add", style: UIBarButtonItem.Style.done, target: self, action: #selector(dismissKeyboard3))
            case writerTextField:
                doneButton = UIBarButtonItem(title: "Add", style: UIBarButtonItem.Style.done, target: self, action: #selector(dismissKeyboard4))
            case engineerMixTextField:
                doneButton = UIBarButtonItem(title: "Add", style: UIBarButtonItem.Style.done, target: self, action: #selector(dismissKeyboard5))
            case engineerMasteringTextField:
                doneButton = UIBarButtonItem(title: "Add", style: UIBarButtonItem.Style.done, target: self, action: #selector(dismissKeyboard6))
            case engineerRecordingTextField:
                doneButton = UIBarButtonItem(title: "Add", style: UIBarButtonItem.Style.done, target: self, action: #selector(dismissKeyboard7))
            default:
                break
            }
        } else {
            doneButton = UIBarButtonItem(title: "Select", style: UIBarButtonItem.Style.done, target: self, action: #selector(dismissKeyboard))
        }
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItem.Style.plain, target: self, action: #selector(dismissKeyboard))

        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true

        textField.inputView = pickerView
        textField.inputAccessoryView = toolBar
    }
}

extension SongUploadViewController: UITextFieldDelegate {
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        switch textField {
        case artistTextField:
            songArtists = []
            songArtistsNames = []
            return true
        case producerTextField:
            songProducers = []
            songProducerNames = []
            return true
        case writerTextField:
            songWriters = []
            songWriterNames = []
            return true
        case engineerMixTextField:
            songMixEngineer = []
            songMixEngineerNames = []
            return true
        case engineerMasteringTextField:
            songMasteringEngineer = []
            songMasteringEngineerNames = []
            return true
        case engineerRecordingTextField:
            songRecordingEngineer = []
            songRecordingEngineerNames = []
            return true
        case remixOfTextField:
            remixOf = nil
            remixHold = nil
            return true
        case otherVersionsOfTextField:
            otherVersionsOf = nil
            otherVersionsHold = nil
            return true
        default:
            return true
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        switch textField {
        case artistTextField:
            personPickerView.selectRow(0, inComponent: 0, animated: false)
            chosenArtist = AllPersonsInDatabaseArray[0].toneDeafAppId.trimmingCharacters(in: .whitespacesAndNewlines)
            chosenArtistNames = AllPersonsInDatabaseArray[0].name!.trimmingCharacters(in: .whitespacesAndNewlines)
        case producerTextField:
            personPickerView.selectRow(0, inComponent: 0, animated: false)
            chosenProducer = AllPersonsInDatabaseArray[0].toneDeafAppId.trimmingCharacters(in: .whitespacesAndNewlines)
            chosenProducerNames = AllPersonsInDatabaseArray[0].name!.trimmingCharacters(in: .whitespacesAndNewlines)
        case writerTextField:
            personPickerView.selectRow(0, inComponent: 0, animated: false)
            chosenWriter = AllPersonsInDatabaseArray[0].toneDeafAppId.trimmingCharacters(in: .whitespacesAndNewlines)
            chosenWriterNames = AllPersonsInDatabaseArray[0].name!.trimmingCharacters(in: .whitespacesAndNewlines)
        case engineerMixTextField:
            personPickerView.selectRow(0, inComponent: 0, animated: false)
            chosenMixEng = AllPersonsInDatabaseArray[0].toneDeafAppId.trimmingCharacters(in: .whitespacesAndNewlines)
            chosenMixEngNames = AllPersonsInDatabaseArray[0].name!.trimmingCharacters(in: .whitespacesAndNewlines)
        case engineerMasteringTextField:
            personPickerView.selectRow(0, inComponent: 0, animated: false)
            chosenMasterEng = AllPersonsInDatabaseArray[0].toneDeafAppId.trimmingCharacters(in: .whitespacesAndNewlines)
            chosenMasterEngNames = AllPersonsInDatabaseArray[0].name!.trimmingCharacters(in: .whitespacesAndNewlines)
        case engineerRecordingTextField:
            personPickerView.selectRow(0, inComponent: 0, animated: false)
            chosenRecEng = AllPersonsInDatabaseArray[0].toneDeafAppId.trimmingCharacters(in: .whitespacesAndNewlines)
            chosenRecEngNames = AllPersonsInDatabaseArray[0].name!.trimmingCharacters(in: .whitespacesAndNewlines)
        default:
            break
        }
    }
}

