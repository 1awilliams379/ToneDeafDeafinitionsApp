//
//  InstrumentalUploadViewController.swift
//  ToneDeafDeafinitionsApp
//
//  Created by Tone Deaf on 8/23/20.
//  Copyright © 2020 GITEM Solutions. All rights reserved.
//

import UIKit
import MobileCoreServices
import FirebaseDatabase
import FirebaseStorage

class InstrumentalUploadViewController: UIViewController {
    
    static let shared = InstrumentalUploadViewController()
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
    var uploadCompletionStatus19:Bool!
    var uploadCompletionStatus20:Bool!
    var uploadCompletionStatus21:Bool!
    var uploadCompletionStatus22:Bool!
    var uploadCompletionStatus23:Bool!
    var uploadCompletionStatus24:Bool!
    
    var dateobj = Date()
    var date:Date!
    var time:Date!
    var currdate:String!
    var currtime:String!
    var selectedFileURL:URL?
    var songAppId:String!
    var tDAppId = ""
    var genid = ""
    var songArtist:Array<String> = []
    var downloadURL:String!
    
    var instrumentalRandomKey:String!
    
    
    var spotifyurl:String!
    var appleurl:String!
    var soundcloudurl:String!
    var youtubemusicurl:String!
    var amazonurl:String!
    var deezerurl:String!
    var spinrillaurl:String!
    var napsterurl:String!
    var tidalurl:String!
    
    
    var videoAppId:String = ""
    var instrumentalProducers:[String]!
    var personref:[String] = []
    var videoref:[String] = []
    var albumref:[String] = []
    var video = ""
    
    var chosenSongs = ""
    var chosenSongNames = ""
    
    var songAttatched:SongData!
    
    var spotify:SpotifySongData?
    var apple:AppleMusicSongData?
    var deezer:DeezerSongData?
    
    var AllSongsInDatabaseArray:[SongData]!
    
    @IBOutlet weak var scrollView:UIScrollView!

    @IBOutlet weak var songIdTextField: UITextField! {
        didSet {
            let placeholderText = NSAttributedString(string: "Name",
                                                     attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray.withAlphaComponent(0.4)])
            
            songIdTextField.attributedPlaceholder = placeholderText
        }
    }
    @IBOutlet weak var textFieldBeatFile: UITextField! {
        didSet {
            let placeholderText = NSAttributedString(string: "File",
                                                        attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray.withAlphaComponent(0.4)])
            
            textFieldBeatFile.attributedPlaceholder = placeholderText
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
    @IBOutlet weak var verificationLevelTextField: UITextField!{
        didSet {
            let placeholderText = NSAttributedString(string: "Select Level",
                                                     attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray.withAlphaComponent(0.4)])
            
            verificationLevelTextField.attributedPlaceholder = placeholderText
        }
    }
    @IBOutlet weak var industryCertificationControl: UISegmentedControl!
    
    var progressView:UIProgressView!
    var totalProgress:Float = 7
    var progressCompleted:Float = 0
    var alertView:UIAlertController!
    
    var verificationLevelPickerView = UIPickerView()
    var verificationLevelArr:[Character] = Constants.Verification.verificationLevels
    var verificationLevel:Character!
    
    var industryCertified:Bool = false
    
    var songsPickerView = UIPickerView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dismissKeyboardOnTap()
        setUpElements()
        DatabaseManager.shared.fetchAllSongsFromDatabase(completion: {[weak self] songs in
            guard let strongSelf = self else {return}
            strongSelf.AllSongsInDatabaseArray = songs
        })
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
    
    func setUpElements() {
        Utilities.styleTextField(songIdTextField)
        addBottomLineToText(songIdTextField)
        
        Utilities.styleTextField(spotifyTextField)
        addBottomLineToText(spotifyTextField)
        
        Utilities.styleTextField(appleMusicTextField)
        addBottomLineToText(appleMusicTextField)
        
        Utilities.styleTextField(textFieldBeatFile)
        addBottomLineToText(textFieldBeatFile)
        
        addBottomLineToText(souncloudTextField)
        addBottomLineToText(youtubeMusicTextField)
        addBottomLineToText(amazonTextField)
        addBottomLineToText(deezerTextField)
        addBottomLineToText(tidalTextField)
        addBottomLineToText(napsterTextField)
        addBottomLineToText(spinrillaTextField)
        Utilities.styleTextField(souncloudTextField)
        Utilities.styleTextField(youtubeMusicTextField)
        Utilities.styleTextField(amazonTextField)
        Utilities.styleTextField(deezerTextField)
        Utilities.styleTextField(tidalTextField)
        Utilities.styleTextField(napsterTextField)
        Utilities.styleTextField(spinrillaTextField)
        
        Utilities.styleTextField(verificationLevelTextField)
        addBottomLineToText(verificationLevelTextField)
        verificationLevelTextField.delegate = self
        
        songIdTextField.inputView = songsPickerView
        songsPickerView.delegate = self
        songsPickerView.dataSource = self
        pickerViewToolbar(textField: songIdTextField, pickerView: songsPickerView)
        
        verificationLevelTextField.inputView = verificationLevelPickerView
        verificationLevelPickerView.delegate = self
        verificationLevelPickerView.dataSource = self
        pickerViewToolbar(textField: verificationLevelTextField, pickerView: verificationLevelPickerView)
        textFieldShouldClear(verificationLevelTextField)
    }
    
    @IBAction func fileTapped(_ sender: Any) {
        openFiles()
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
    
    @IBAction func uploadInstrumentalButtonTapped(_ sender: Any) {
        videoAppId = ""
        dateobj = Date()
        guard songIdTextField.text != "" else {
            Utilities.showError2("Song Id required"  ,actionText: "Ok")
            return
        }
        if spotifyTextField.text != "" {
            guard spotifyTextField.text!.count > 15 else {return}
            spotifyurl = spotifyTextField.text!
        }
        if appleMusicTextField.text != "" {
            guard appleMusicTextField.text!.count > 15 else {return}
            appleurl = appleMusicTextField.text!
        }
        if souncloudTextField.text != "" {
            guard souncloudTextField.text!.count > 15 else {return}
            soundcloudurl = souncloudTextField.text!
        }
        if youtubeMusicTextField.text != "" {
            guard youtubeMusicTextField.text!.count > 15 else {return}
            youtubemusicurl = youtubeMusicTextField.text!
        }
        if amazonTextField.text != "" {
            guard amazonTextField.text!.count > 15 else {return}
            amazonurl = amazonTextField.text!
        }
        if deezerTextField.text != "" {
            guard deezerTextField.text!.count > 15 else {return}
            deezerurl = deezerTextField.text!
        }
        if spinrillaTextField.text != "" {
            guard spinrillaTextField.text!.count > 15 else {return}
            spinrillaurl = spinrillaTextField.text!
        }
        if napsterTextField.text != "" {
            guard napsterTextField.text!.count > 15 else {return}
            napsterurl = napsterTextField.text!
        }
        if tidalTextField.text != "" {
            guard tidalTextField.text!.count > 15 else {return}
            tidalurl = tidalTextField.text!
        }
        guard verificationLevelTextField.text != "" else {
            mediumImpactGenerator.impactOccurred()
            Utilities.showError2("Verification Level required"  ,actionText: "Ok")
            return
        }
        generateAppId()
    }
    
    func generateAppId() {
        //print("Stop")
        genid = StorageManager.shared.generateRandomNumber(digits: 12)
        DatabaseManager.shared.checkIfAppIdExists(appid: genid, completion: { [weak self] result in
            guard let strongSelf = self else {return}
            print(result)
            
            if result == true {
                strongSelf.generateAppId()
                
            } else {
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
                strongSelf.tDAppId = strongSelf.genid
                strongSelf.getSongData()
                
            }
        })
    }
    
    func getSongData() {
        processSongId(completion: {[weak self] error in
            guard let strongSelf = self else {return}
            if let error = error {
                Utilities.showError2("song id proccessing Failed: \(error)", actionText: "OK")
                mediumImpactGenerator.impactOccurred()
                return
            }
            else {
                print("song id proccessing done")
                strongSelf.getSongDataP2()
            }
        })
    }
    
    func getSongDataP2() {
        var newArr:[String] = []
        if !songAttatched.songProducers.isEmpty {
            newArr.append("Producer")
        }
        if let two = songAttatched.songMixEngineer {
            if !two.isEmpty {
                newArr.append("Mix Engineer")
            }
        }
        if let two = songAttatched.songMasteringEngineer {
            if !two.isEmpty {
                newArr.append("Mastering Engineer")
            }
        }
        var arr = Array(GlobalFunctions.shared.combine(songAttatched.songProducers,songAttatched.songMixEngineer,songAttatched.songMasteringEngineer))
        var dict:[String:String] = [:]
        for val in arr {
            dict["BLANK\(val)"] = val
        }
        
        
        DispatchQueue.global(qos: .userInitiated).async {[weak self] in
            guard let strongSelf = self else {return}
            
            let semaphore = DispatchSemaphore(value: 0)
            let semap = DispatchSemaphore(value: 0)
            var counter = 0
            for i in 0 ... newArr.count-1 {
                
                DispatchQueue.main.async {
                    alertController = UIAlertController(title: "Select \(newArr[i]) Role",
                                                        message: "Select persons from \(strongSelf.songAttatched.name) that are invlolved as a \(newArr[i]) with the instrumental",
                                                        preferredStyle: .alert)
                    
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let vc3 = storyboard.instantiateViewController(identifier: "editPersonRolesSongsForAlbumPopoverTableViewController") as
                    EditPersonRolesSongsForAlbumPopoverTableViewController
                    vc3.preferredContentSize = CGSize(width: 350, height: 350) // 4 default cell heights.
                    vc3.trackArr = dict
                    alertController.setValue(vc3, forKey: "contentViewController")
                    
                    let addAction = UIAlertAction(title: "Select Persons", style: .default, handler: {[weak self] _ in
                        guard let strongSelf = self else {return}
                        var newRoleArr:[String] = []
                        let cc = alertController.value(forKey: "contentViewController") as! EditPersonRolesSongsForAlbumPopoverTableViewController
                        for a in 1 ... (cc.trackArr.count) {
                            if let cell = cc.tableViewPopover.cellForRow(at: IndexPath(row: a-1, section: 0)) as? EditRolesSongsForAlbumPopoverTableCellController {
                                if cell.checkbox.on {
                                    switch newArr[i] {
                                    case "Producer":
                                        if !strongSelf.songAttatched.songProducers.contains(cell.appId.text!) {
                                            strongSelf.songAttatched.songProducers.append(cell.appId.text!)
                                        }
                                    case "Mix Engineer":
                                        if var two = strongSelf.songAttatched.songMixEngineer as? [String] {
                                            if !two.contains(cell.appId.text!) {
                                                two.append(cell.appId.text!)
                                            }
                                            strongSelf.songAttatched.songMixEngineer = two
                                        }
                                    case "Mastering Engineer":
                                        if var two = strongSelf.songAttatched.songMasteringEngineer as? [String] {
                                            if !two.contains(cell.appId.text!) {
                                                two.append(cell.appId.text!)
                                            }
                                            strongSelf.songAttatched.songMasteringEngineer = two
                                        }
                                    default:
                                        break
                                    }
                                } else {
                                    switch newArr[i] {
                                    case "Producer":
                                        if let dex = strongSelf.songAttatched.songProducers.firstIndex(of: cell.appId.text!)
                                        {
                                            strongSelf.songAttatched.songProducers.remove(at: Int(dex))
                                        }
                                    case "Mix Engineer":
                                        if let dex = strongSelf.songAttatched.songMixEngineer?.firstIndex(of: cell.appId.text!)
                                        {
                                            strongSelf.songAttatched.songMixEngineer!.remove(at: Int(dex))
                                        }
                                    case "Mastering Engineer":
                                        if let dex = strongSelf.songAttatched.songMasteringEngineer?.firstIndex(of: cell.appId.text!)
                                        {
                                            strongSelf.songAttatched.songMasteringEngineer!.remove(at: Int(dex))
                                        }
                                    default:
                                        break
                                    }
                                }
                            }
                        }
                        counter+=1
                        alertController.dismiss(animated: true, completion: nil)
                        if newArr.count != 1 {
                            semap.signal()
                        }
                        if counter == newArr.count {
                            semaphore.signal()
                        }
                    })
                    
                    let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
                    { (action) in
                        // ...
                    }
                    
                    alertController.addAction(cancelAction)
                    alertController.addAction(addAction)
                    alertController.view.tintColor = Constants.Colors.redApp
                    strongSelf.present(alertController, animated: true) { [weak self] in
                        guard let strongSelf = self else {return}
                        let cc = alertController.value(forKey: "contentViewController") as! EditPersonRolesSongsForAlbumPopoverTableViewController
                        for a in 1 ... (cc.trackArr.count) {
                            if let cell = cc.tableViewPopover.cellForRow(at: IndexPath(row: a-1, section: 0)) as? EditRolesSongsForAlbumPopoverTableCellController {
                                if newArr[i] == "Producer" {
                                    if strongSelf.songAttatched.songProducers.contains(cell.appId.text!) {
                                        cell.checkbox.setOn(true, animated: false)
                                    }
                                }
                                if newArr[i] == "Mix Engineer" {
                                    if let two = strongSelf.songAttatched.songMixEngineer {
                                        if two.contains(cell.appId.text!) {
                                            cell.checkbox.setOn(true, animated: false)
                                        }
                                    }
                                }
                                if newArr[i] == "Mastering Engineer" {
                                    if let two = strongSelf.songAttatched.songMasteringEngineer {
                                        if two.contains(cell.appId.text!) {
                                            cell.checkbox.setOn(true, animated: false)
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
                if newArr.count != 1 {
                    semap.wait()
                }
            }
            
            semaphore.wait()
            
            
                
            DispatchQueue.main.async {
                strongSelf.alertView = UIAlertController(title: "Uploading \(strongSelf.songAttatched.name) Instrumental", message: "Preparing...", preferredStyle: .alert)
                strongSelf.alertView.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                strongSelf.alertView.view.tintColor = Constants.Colors.redApp
                //  Show it to your users
                strongSelf.present(strongSelf.alertView, animated: true, completion: { [weak self] in
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
                    strongSelf.getPersonRefs(completion: { [weak self] error in
                        guard let strongSelf = self else {return}
                        if let error = error {
                            Utilities.showError2("retrieving producer refs Failed: \(error)", actionText: "OK")
                            mediumImpactGenerator.impactOccurred()
                            return
                        }
                        else {
                            print("retrieving producer refs done")
                            strongSelf.gatherUploadData()
                        }
                    })
                })
            }
        }
    }
    
    func gatherUploadData() {
        let instqueue = DispatchQueue(label: "myhjinstrumentalshjfktyhdikhQueue")
        let instgroup = DispatchGroup()
        let array:[Int] = [1,2,3]
        for i in array {
            instgroup.enter()
            instqueue.async { [weak self] in
                guard let strongSelf = self else {return}
                switch i {
                case 1:
                    strongSelf.uploadCompletionStatus1 = false
                    strongSelf.uploadAudio(id: strongSelf.songAppId, completion: { error in
                        if let error = error {
                            Utilities.showError2("uploading audio Failed: \(error)", actionText: "OK")
                            mediumImpactGenerator.impactOccurred()
                            strongSelf.uploadCompletionStatus1 = false
                            return
                        }
                        else {
                            strongSelf.uploadCompletionStatus1 = true
                            print("uploading audio done \(i)")
                        }
                        instgroup.leave()
                    })
                case 2:
                    strongSelf.uploadCompletionStatus2 = false
                    strongSelf.getAlbumRefs(completion: { error in
                        if let error = error {
                            Utilities.showError2("album refs Failed: \(error)", actionText: "OK")
                            mediumImpactGenerator.impactOccurred()
                            strongSelf.uploadCompletionStatus2 = false
                            return
                        }
                        else {
                            strongSelf.uploadCompletionStatus2 = true
                            print("album refs done \(i)")
                        }
                        instgroup.leave()
                    })
                case 3:
                    strongSelf.uploadCompletionStatus3 = false
                    strongSelf.getVideoRefs(completion: { error in
                        if let error = error {
                            Utilities.showError2("video refs Failed: \(error)", actionText: "OK")
                            mediumImpactGenerator.impactOccurred()
                            strongSelf.uploadCompletionStatus3 = false
                            return
                        }
                        else {
                            strongSelf.uploadCompletionStatus3 = true
                            print("video refs done \(i)")
                        }
                        instgroup.leave()
                    })
                default:
                    print("instrumental oopsie")
                }
                
            }
            
        }
        instgroup.notify(queue: DispatchQueue.main) {[weak self] in
            guard let strongSelf = self else {return}
            if strongSelf.uploadCompletionStatus1 == false || strongSelf.uploadCompletionStatus2 == false || strongSelf.uploadCompletionStatus3 == false {
                
                Utilities.showError2("Upload Failed.", actionText: "OK")
                return
            } else {
                strongSelf.saveBeatInfoToDatabase(song: strongSelf.songAttatched, id: strongSelf.songAppId)
            }
        }
        
    }
    
    func saveBeatInfoToDatabase(song:SongData, id: String) {
        //MARK: - Graphing
        var imageurl:String!
        let queue = DispatchQueue(label: "myinstrumentalhblhjbknkhjvkhQueue")
        let group = DispatchGroup()
        var array:[String] = []
        if spotifyurl != "" {
            totalProgress+=2
            array.append(spotifyMusicContentType)
        }
        if appleurl != "" {
            totalProgress+=2
            array.append(appleMusicContentType)
        }
        if deezerurl != "" {
            totalProgress+=2
            array.append(deezerMusicContentType)
        }

        for i in array {
            group.enter()
            queue.async { [weak self] in
                guard let strongSelf = self else {return}
                switch i {
                case spotifyMusicContentType:
                    strongSelf.spotifyGraph(completion: {[weak self] error in
                        guard let strongSelf = self else {return}
                        if let error = error {
                            Utilities.showError2("Spotify Graph Failed. \(error)", actionText: "OK")
                            strongSelf.uploadCompletionStatus2 = false
                        }
                        else {
                            strongSelf.uploadCompletionStatus2 = true
                            strongSelf.progressCompleted+=1
                            DispatchQueue.main.async {
                                strongSelf.progressView.progress = (strongSelf.progressCompleted/strongSelf.totalProgress)
                                print("\(strongSelf.progressCompleted) out of \(strongSelf.totalProgress)")
                                
                            }
                            print("done \(i)")
                        }
                        group.leave()
                    })
                case appleMusicContentType:
                    strongSelf.appleMusicGraph(completion: {[weak self] error in
                        guard let strongSelf = self else {return}
                        if let error = error {
                            Utilities.showError2("Apple Graph Failed. \(error)", actionText: "OK")
                            strongSelf.uploadCompletionStatus3 = false
                        }
                        else {
                            strongSelf.uploadCompletionStatus3 = true
                            strongSelf.progressCompleted+=1
                            DispatchQueue.main.async {
                                strongSelf.progressView.progress = (strongSelf.progressCompleted/strongSelf.totalProgress)
                                print("\(strongSelf.progressCompleted) out of \(strongSelf.totalProgress)")
                                
                            }
                            print("done \(i)")
                        }
                        group.leave()
                    })
                case deezerMusicContentType:
                    strongSelf.deezerGraph(completion: {[weak self] error in
                        guard let strongSelf = self else {return}
                        if let error = error {
                            Utilities.showError2("Deezer Graph Failed. \(error)", actionText: "OK")
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
                default:
                    print("error")
                }
            }
        }
        
        group.notify(queue: DispatchQueue.main) {[weak self] in
            guard let strongSelf = self else {return}
            if strongSelf.uploadCompletionStatus2 == false || strongSelf.uploadCompletionStatus3 == false || strongSelf.uploadCompletionStatus4 == false {
                Utilities.showError2("Upload Failed.", actionText: "OK")
                return
            } else {
                //MARK: - Storing
                let bqueue = DispatchQueue(label: "myhjinstrumentalsvsdfhvhjjjjbhgdfxkhQueue")
                let bgroup = DispatchGroup()
                var barray = ["Required", "All Content", "All Instrumentals", "Song"]
                if strongSelf.spotify != nil {
                    barray.append(spotifyMusicContentType)
                }
                if strongSelf.apple != nil {
                    barray.append(appleMusicContentType)
                }
                if strongSelf.deezer != nil {
                    barray.append(deezerMusicContentType)
                }
                if strongSelf.soundcloudurl != nil {
                    strongSelf.totalProgress+=1
                    barray.append(soundcloudMusicContentType)
                }
                if strongSelf.youtubemusicurl != nil {
                    strongSelf.totalProgress+=1
                    barray.append(youtubeMusicContentType)
                }
                if strongSelf.amazonurl != nil {
                    strongSelf.totalProgress+=1
                    barray.append(amazonMusicContentType)
                }
                if strongSelf.tidalurl != nil {
                    strongSelf.totalProgress+=1
                    barray.append(tidalMusicContentType)
                }
                if strongSelf.napsterurl != nil {
                    strongSelf.totalProgress+=1
                    barray.append(napsterMusicContentType)
                }
                if strongSelf.spinrillaurl != nil {
                    strongSelf.totalProgress+=1
                    barray.append(spinrillaMusicContentType)
                }
                if !strongSelf.personref.isEmpty {
                    strongSelf.totalProgress+=1
                    barray.append("Person")
                }
                if !strongSelf.videoref.isEmpty {
                    strongSelf.totalProgress+=1
                    barray.append("Video")
                }
                if !strongSelf.albumref.isEmpty {
                    strongSelf.totalProgress+=1
                    barray.append("Album")
                }
                if !strongSelf.songAttatched.songProducers.isEmpty {
                    strongSelf.totalProgress+=1
                    barray.append("Producer")
                }
                if let _ = strongSelf.songAttatched.songMixEngineer {
                    strongSelf.totalProgress+=1
                    barray.append("Mix Engineer")
                }
                if let _ = strongSelf.songAttatched.songMasteringEngineer {
                    strongSelf.totalProgress+=1
                    barray.append("Mastering Engineer")
                }
                for i in barray {
                    bgroup.enter()
                    bqueue.async { [weak self] in
                        guard let strongSelf = self else {return}
                        switch i {
                        case "Required":
                            strongSelf.requiredData(song: song, id: id, completion: { error in
                                if let error = error {
                                    strongSelf.uploadCompletionStatus6 = false
                                    Utilities.showError2("Required Data failed to store. \(error)", actionText: "OK")
                                }
                                else {
                                    strongSelf.uploadCompletionStatus6 = true
                                    strongSelf.progressCompleted+=1
                                    DispatchQueue.main.async {
                                        strongSelf.progressView.progress = (strongSelf.progressCompleted/strongSelf.totalProgress)
                                        print("\(strongSelf.progressCompleted) out of \(strongSelf.totalProgress)")
                                    }
                                    print("done \(i)")
                                    bgroup.leave()
                                    
                                }
                            })
                        case "All Content":
                            strongSelf.storeAllContentId(completion: { error in
                                if let error = error {
                                    strongSelf.uploadCompletionStatus7 = false
                                    Utilities.showError2("All Content failed to store. \(error)", actionText: "OK")
                                }
                                else {
                                    strongSelf.uploadCompletionStatus7 = true
                                    strongSelf.progressCompleted+=1
                                    DispatchQueue.main.async {
                                        strongSelf.progressView.progress = (strongSelf.progressCompleted/strongSelf.totalProgress)
                                        print("\(strongSelf.progressCompleted) out of \(strongSelf.totalProgress)")
                                    }
                                    print("done \(i)")
                                    bgroup.leave()
                                    
                                }
                            })
                        case "All Instrumentals":
                            strongSelf.storeInstrumentalId(completion: { error in
                                if let error = error {
                                    strongSelf.uploadCompletionStatus8 = false
                                    Utilities.showError2("All Instrumentals Id failed to store. \(error)", actionText: "OK")
                                }
                                else {
                                    strongSelf.uploadCompletionStatus8 = true
                                    strongSelf.progressCompleted+=1
                                    DispatchQueue.main.async {
                                        strongSelf.progressView.progress = (strongSelf.progressCompleted/strongSelf.totalProgress)
                                        print("\(strongSelf.progressCompleted) out of \(strongSelf.totalProgress)")
                                    }
                                    print("done \(i)")
                                    bgroup.leave()
                                    
                                }
                            })
                        case spotifyMusicContentType:
                            strongSelf.spotifyStore(completion: { error in
                                if let error = error {
                                    strongSelf.uploadCompletionStatus9 = false
                                    Utilities.showError2("Spotify failed to store. \(error)", actionText: "OK")
                                }
                                else {
                                    strongSelf.uploadCompletionStatus9 = true
                                    strongSelf.progressCompleted+=1
                                    DispatchQueue.main.async {
                                        strongSelf.progressView.progress = (strongSelf.progressCompleted/strongSelf.totalProgress)
                                        print("\(strongSelf.progressCompleted) out of \(strongSelf.totalProgress)")
                                    }
                                    print("done \(i)")
                                    bgroup.leave()
                                    
                                }
                            })
                        case appleMusicContentType:
                            strongSelf.appleStore(completion: { error in
                                if let error = error {
                                    strongSelf.uploadCompletionStatus10 = false
                                    Utilities.showError2("Apple Music failed to store. \(error)", actionText: "OK")
                                }
                                else {
                                    strongSelf.uploadCompletionStatus10 = true
                                    strongSelf.progressCompleted+=1
                                    DispatchQueue.main.async {
                                        strongSelf.progressView.progress = (strongSelf.progressCompleted/strongSelf.totalProgress)
                                        print("\(strongSelf.progressCompleted) out of \(strongSelf.totalProgress)")
                                    }
                                    print("done \(i)")
                                    bgroup.leave()
                                    
                                }
                            })
                        case deezerMusicContentType:
                            strongSelf.deezerStore(completion: { error in
                                if let error = error {
                                    strongSelf.uploadCompletionStatus11 = false
                                    Utilities.showError2("Deezer failed to store. \(error)", actionText: "OK")
                                }
                                else {
                                    strongSelf.uploadCompletionStatus11 = true
                                    strongSelf.progressCompleted+=1
                                    DispatchQueue.main.async {
                                        strongSelf.progressView.progress = (strongSelf.progressCompleted/strongSelf.totalProgress)
                                        print("\(strongSelf.progressCompleted) out of \(strongSelf.totalProgress)")
                                    }
                                    print("done \(i)")
                                    bgroup.leave()
                                    
                                }
                            })
                        case soundcloudMusicContentType:
                            strongSelf.soundcloudStore(completion: { error in
                                if let error = error {
                                    strongSelf.uploadCompletionStatus12 = false
                                    Utilities.showError2("Soundcloud failed to store. \(error)", actionText: "OK")
                                }
                                else {
                                    strongSelf.uploadCompletionStatus12 = true
                                    strongSelf.progressCompleted+=1
                                    DispatchQueue.main.async {
                                        strongSelf.progressView.progress = (strongSelf.progressCompleted/strongSelf.totalProgress)
                                        print("\(strongSelf.progressCompleted) out of \(strongSelf.totalProgress)")
                                    }
                                    print("done \(i)")
                                    bgroup.leave()
                                    
                                }
                            })
                        case youtubeMusicContentType:
                            strongSelf.youtubeMusicStore(completion: { error in
                                if let error = error {
                                    strongSelf.uploadCompletionStatus13 = false
                                    Utilities.showError2("Youtube Music failed to store. \(error)", actionText: "OK")
                                }
                                else {
                                    strongSelf.uploadCompletionStatus13 = true
                                    strongSelf.progressCompleted+=1
                                    DispatchQueue.main.async {
                                        strongSelf.progressView.progress = (strongSelf.progressCompleted/strongSelf.totalProgress)
                                        print("\(strongSelf.progressCompleted) out of \(strongSelf.totalProgress)")
                                    }
                                    print("done \(i)")
                                    bgroup.leave()
                                    
                                }
                            })
                        case amazonMusicContentType:
                            strongSelf.amazonMusicStore(completion: { error in
                                if let error = error {
                                    strongSelf.uploadCompletionStatus14 = false
                                    Utilities.showError2("Amazon Music failed to store. \(error)", actionText: "OK")
                                }
                                else {
                                    strongSelf.uploadCompletionStatus14 = true
                                    strongSelf.progressCompleted+=1
                                    DispatchQueue.main.async {
                                        strongSelf.progressView.progress = (strongSelf.progressCompleted/strongSelf.totalProgress)
                                        print("\(strongSelf.progressCompleted) out of \(strongSelf.totalProgress)")
                                    }
                                    print("done \(i)")
                                    bgroup.leave()
                                    
                                }
                            })
                        case tidalMusicContentType:
                            strongSelf.tidalStore(completion: { error in
                                if let error = error {
                                    strongSelf.uploadCompletionStatus15 = false
                                    Utilities.showError2("Tidal failed to store. \(error)", actionText: "OK")
                                }
                                else {
                                    strongSelf.uploadCompletionStatus15 = true
                                    strongSelf.progressCompleted+=1
                                    DispatchQueue.main.async {
                                        strongSelf.progressView.progress = (strongSelf.progressCompleted/strongSelf.totalProgress)
                                        print("\(strongSelf.progressCompleted) out of \(strongSelf.totalProgress)")
                                    }
                                    print("done \(i)")
                                    bgroup.leave()
                                    
                                }
                            })
                        case napsterMusicContentType:
                            strongSelf.napsterStore(completion: { error in
                                if let error = error {
                                    strongSelf.uploadCompletionStatus16 = false
                                    Utilities.showError2("Napster failed to store. \(error)", actionText: "OK")
                                }
                                else {
                                    strongSelf.uploadCompletionStatus16 = true
                                    strongSelf.progressCompleted+=1
                                    DispatchQueue.main.async {
                                        strongSelf.progressView.progress = (strongSelf.progressCompleted/strongSelf.totalProgress)
                                        print("\(strongSelf.progressCompleted) out of \(strongSelf.totalProgress)")
                                    }
                                    print("done \(i)")
                                    bgroup.leave()
                                    
                                }
                            })
                        case spinrillaMusicContentType:
                            strongSelf.spinrillaStore(completion: { error in
                                if let error = error {
                                    strongSelf.uploadCompletionStatus17 = false
                                    Utilities.showError2("Spinrilla failed to store. \(error)", actionText: "OK")
                                }
                                else {
                                    strongSelf.uploadCompletionStatus17 = true
                                    strongSelf.progressCompleted+=1
                                    DispatchQueue.main.async {
                                        strongSelf.progressView.progress = (strongSelf.progressCompleted/strongSelf.totalProgress)
                                        print("\(strongSelf.progressCompleted) out of \(strongSelf.totalProgress)")
                                    }
                                    print("done \(i)")
                                    bgroup.leave()
                                    
                                }
                            })
                        case "Person":
                            strongSelf.updatePersonInstrumentals(completion: { error in
                                if let error = error {
                                    strongSelf.uploadCompletionStatus18 = false
                                    Utilities.showError2("Spinrilla failed to store. \(error)", actionText: "OK")
                                }
                                else {
                                    strongSelf.uploadCompletionStatus18 = true
                                    strongSelf.progressCompleted+=1
                                    DispatchQueue.main.async {
                                        strongSelf.progressView.progress = (strongSelf.progressCompleted/strongSelf.totalProgress)
                                        print("\(strongSelf.progressCompleted) out of \(strongSelf.totalProgress)")
                                    }
                                    print("done \(i)")
                                    bgroup.leave()
                                    
                                }
                            })
                        case "Video":
                            strongSelf.updateVideoInstrumentals(completion: { error in
                                if let error = error {
                                    strongSelf.uploadCompletionStatus19 = false
                                    Utilities.showError2("Spinrilla failed to store. \(error)", actionText: "OK")
                                }
                                else {
                                    strongSelf.uploadCompletionStatus19 = true
                                    strongSelf.progressCompleted+=1
                                    DispatchQueue.main.async {
                                        strongSelf.progressView.progress = (strongSelf.progressCompleted/strongSelf.totalProgress)
                                        print("\(strongSelf.progressCompleted) out of \(strongSelf.totalProgress)")
                                    }
                                    print("done \(i)")
                                    bgroup.leave()
                                    
                                }
                            })
                        case "Album":
                            strongSelf.updateAlbumInstrumentals(completion: { error in
                                if let error = error {
                                    strongSelf.uploadCompletionStatus20 = false
                                    Utilities.showError2("Spinrilla failed to store. \(error)", actionText: "OK")
                                }
                                else {
                                    strongSelf.uploadCompletionStatus20 = true
                                    strongSelf.progressCompleted+=1
                                    DispatchQueue.main.async {
                                        strongSelf.progressView.progress = (strongSelf.progressCompleted/strongSelf.totalProgress)
                                        print("\(strongSelf.progressCompleted) out of \(strongSelf.totalProgress)")
                                    }
                                    print("done \(i)")
                                    bgroup.leave()
                                    
                                }
                            })
                        case "Song":
                            strongSelf.updateSongInstrumentals(completion: { error in
                                if let error = error {
                                    strongSelf.uploadCompletionStatus21 = false
                                    Utilities.showError2("Spinrilla failed to store. \(error)", actionText: "OK")
                                }
                                else {
                                    strongSelf.uploadCompletionStatus21 = true
                                    strongSelf.progressCompleted+=1
                                    DispatchQueue.main.async {
                                        strongSelf.progressView.progress = (strongSelf.progressCompleted/strongSelf.totalProgress)
                                        print("\(strongSelf.progressCompleted) out of \(strongSelf.totalProgress)")
                                    }
                                    print("done \(i)")
                                    bgroup.leave()
                                    
                                }
                            })
                        case "Producer":
                            strongSelf.updateProducerRoles(completion: { error in
                                if let error = error {
                                    strongSelf.uploadCompletionStatus22 = false
                                    Utilities.showError2("Producer Roles failed to store. \(error)", actionText: "OK")
                                }
                                else {
                                    strongSelf.uploadCompletionStatus22 = true
                                    strongSelf.progressCompleted+=1
                                    DispatchQueue.main.async {
                                        strongSelf.progressView.progress = (strongSelf.progressCompleted/strongSelf.totalProgress)
                                        print("\(strongSelf.progressCompleted) out of \(strongSelf.totalProgress)")
                                    }
                                    print("done \(i)")
                                    bgroup.leave()
                                    
                                }
                            })
                        case "Mix Engineer":
                            strongSelf.updateMixEngineerRoles(completion: { error in
                                if let error = error {
                                    strongSelf.uploadCompletionStatus23 = false
                                    Utilities.showError2("Mix Engineer Roles failed to store. \(error)", actionText: "OK")
                                }
                                else {
                                    strongSelf.uploadCompletionStatus23 = true
                                    strongSelf.progressCompleted+=1
                                    DispatchQueue.main.async {
                                        strongSelf.progressView.progress = (strongSelf.progressCompleted/strongSelf.totalProgress)
                                        print("\(strongSelf.progressCompleted) out of \(strongSelf.totalProgress)")
                                    }
                                    print("done \(i)")
                                    bgroup.leave()
                                    
                                }
                            })
                        case "Mastering Engineer":
                            strongSelf.updateMasteringEngineerRoles(completion: { error in
                                if let error = error {
                                    strongSelf.uploadCompletionStatus24 = false
                                    Utilities.showError2("Mastering Engineer Roles failed to store. \(error)", actionText: "OK")
                                }
                                else {
                                    strongSelf.uploadCompletionStatus24 = true
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
                    guard let strongSelf = self else {return}
                    if strongSelf.uploadCompletionStatus6 == false || strongSelf.uploadCompletionStatus7 == false || strongSelf.uploadCompletionStatus8 == false || strongSelf.uploadCompletionStatus9 == false || strongSelf.uploadCompletionStatus10 == false || strongSelf.uploadCompletionStatus11 == false || strongSelf.uploadCompletionStatus12 == false || strongSelf.uploadCompletionStatus13 == false || strongSelf.uploadCompletionStatus14 == false || strongSelf.uploadCompletionStatus15 == false || strongSelf.uploadCompletionStatus16 == false || strongSelf.uploadCompletionStatus17 == false || strongSelf.uploadCompletionStatus18 == false || strongSelf.uploadCompletionStatus19 == false || strongSelf.uploadCompletionStatus20 == false || strongSelf.uploadCompletionStatus21 == false || strongSelf.uploadCompletionStatus22 == false || strongSelf.uploadCompletionStatus23 == false || strongSelf.uploadCompletionStatus24 == false {
                        Utilities.showError2("Upload Failed.", actionText: "OK")
                        return
                    } else {
                        strongSelf.appleMusicTextField.text = ""
                        strongSelf.spotifyTextField.text = ""
                        print("📗 Instrumental data saved to database successfully.")
                        strongSelf.alertView.dismiss(animated: true, completion: {
                            Utilities.successBarBanner("Upload successful.")
                            _ = strongSelf.navigationController?.popViewController(animated: true)
                        })
                    }
                }
            }
        }
    }
    
    //MARK: - Gathering Data
    func processSongId(completion: @escaping (Error?) -> Void) {
        date = dateobj
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone(identifier: "EDT")
        formatter.dateFormat = "MMMM dd, yyyy"
        currdate = formatter.string(from: date!)
        
        time = dateobj
        let timeFormatter = DateFormatter()
        timeFormatter.timeZone = TimeZone(identifier: "EDT")
        timeFormatter.dateFormat = "HH:mm:ss a"
        currtime = timeFormatter.string(from: time!)
        
        let id = chosenSongs
        DatabaseManager.shared.findSongById(songId: id, completion: {[weak self] result in
            guard let strongSelf = self else {return}
            switch result {
            case .success(let song):
                strongSelf.instrumentalRandomKey = ("\(instrumentalContentType)--\(song.name)--\(strongSelf.tDAppId)")
                strongSelf.songAttatched = song
                strongSelf.songAppId = id
                strongSelf.instrumentalProducers = song.songProducers
//                strongSelf.progressCompleted+=1
//                strongSelf.progressView.progress = (strongSelf.progressCompleted/strongSelf.totalProgress)
//                print("\(strongSelf.progressCompleted) out of \(strongSelf.totalProgress)")
                completion(nil)
            case .failure(let error):
                print("Song ID proccessing error \(error)")
            }
        })
        
    }
    
    func getPersonRefs(completion: @escaping ((Error?) -> Void)) {
        var tick = 0
        let arr = Array(GlobalFunctions.shared.combine(songAttatched.songProducers,songAttatched.songMixEngineer,songAttatched.songMasteringEngineer))
        for producer in arr {
            Database.database().reference().child("Registered Persons").observeSingleEvent(of: .value, with: {[weak self] snapshot in
                guard let strongSelf = self else {return}
                for produce in snapshot.children {

                    let data = produce as! DataSnapshot
                    let key = data.key
                    if data.key.contains(producer) == true {
                        strongSelf.personref.append(key)
                    }
                }
                tick+=1
                if tick == arr.count {
                    strongSelf.progressCompleted+=1
                    strongSelf.progressView.progress = (strongSelf.progressCompleted/strongSelf.totalProgress)
                    print("\(strongSelf.progressCompleted) out of \(strongSelf.totalProgress)")
                    completion(nil)
                }
            })
        }
    }
    
    func getAlbumRefs(completion: @escaping ((Error?) -> Void)) {
        var tick = 0
        if let arr = songAttatched.albums {
            if !arr.isEmpty {
                for id in arr {
                    DatabaseManager.shared.findAlbumById(albumId: id, completion: {[weak self] result in
                        guard let strongSelf = self else {return}
                        switch result {
                        case .success(let item):
                            let ref = ("\(albumContentTag)--\(item.name)--\(item.toneDeafAppId)")
                            strongSelf.albumref.append(ref)
                            tick+=1
                            if arr.count == tick {
                                strongSelf.progressCompleted+=1
                                strongSelf.progressView.progress = (strongSelf.progressCompleted/strongSelf.totalProgress)
                                print("\(strongSelf.progressCompleted) out of \(strongSelf.totalProgress)")
                                completion(nil)
                            }
                        case .failure(let error):
                            print("Album ID proccessing error \(error)")
                        }
                    })
                }
            }
            else {
                completion(nil)
            }
        }
        else {
            completion(nil)
        }
    }
    
    func getVideoRefs(completion: @escaping ((Error?) -> Void)) {
        var tick = 0
        if let arr = songAttatched.videos {
            for id in arr {
                DatabaseManager.shared.findVideoById(videoid: id, completion: {[weak self] result in
                    guard let strongSelf = self else {return}
                    switch result {
                    case .success(let item):
                        let ref = ("\(videoContentTag)--\(item.title.replacingOccurrences(of: ".", with: " ").replacingOccurrences(of: "#", with: " ").replacingOccurrences(of: "$", with: " ").replacingOccurrences(of: "[", with: " ").replacingOccurrences(of: "]", with: " ").replacingOccurrences(of: ":", with: " "))--\(item.toneDeafAppId)")
                        strongSelf.videoref.append(ref)
                        tick+=1
                        if arr.count == tick {
                            strongSelf.progressCompleted+=1
                            strongSelf.progressView.progress = (strongSelf.progressCompleted/strongSelf.totalProgress)
                            print("\(strongSelf.progressCompleted) out of \(strongSelf.totalProgress)")
                            completion(nil)
                        }
                    case .failure(let error):
                        print("Album ID proccessing error \(error)")
                    }
                })
            }
        }
        else {
            completion(nil)
        }
    }
    
    func uploadAudio(id: String, completion: @escaping ((Error?) -> Void)) {
        
        guard let dataAudio = selectedFileURL else {
            return
        }
        let fileNNameAudio = "\(instrumentalContentType)--\(tDAppId)"
        
        StorageManager.shared.uploadAudio(with: dataAudio, fileName: fileNNameAudio, type: "instrumental", completion: {[weak self] result in
            guard let strongSelf = self else {return}
            switch result {
            case.success(let downloadURL):
                strongSelf.downloadURL = downloadURL
                strongSelf.progressCompleted+=1
                strongSelf.progressView.progress = (strongSelf.progressCompleted/strongSelf.totalProgress)
                print("\(strongSelf.progressCompleted) out of \(strongSelf.totalProgress)")
                UserDefaults.standard.set(downloadURL,forKey: "beatAudio")
                print("📗 Audio stored successfully \(StorageManager.audioURL).")
                completion(nil)
                return
            case .failure(let error):
                print("Storage manager error: \(error.localizedDescription)")
                return
            }
        })
    }
    
    //MARK: - Graphing Data
    func spotifyGraph(completion: @escaping ((Error?) -> Void)) {
        DispatchQueue.main.async {[weak self] in
            guard let strongSelf = self else {return}
            guard strongSelf.spotifyTextField.text != "" else {
                completion(nil)
                return}
            guard strongSelf.spotifyTextField.text!.count > 15 else {
                completion(nil)
                return}
            let songId = String((strongSelf.spotifyTextField.text?.suffix(22))!)
            let token = (UserDefaults.standard.object(forKey: "SPTaccesstoken") as? String)!
            SpotifyRequest.shared.getTrackInfo(accessToken: token, id: songId, completion: { result in
                switch result {
                case.success(let song):
                    strongSelf.spotify = song
                    completion(nil)
                case.failure(let err):
                    print("Asgsdbrdfxnb ", err)
                default:
                    break
                }
            })
        }
        
    }
    
    func appleMusicGraph(completion: @escaping ((Error?) -> Void)) {
        DispatchQueue.main.async {[weak self] in
            guard let strongSelf = self else {return}
            guard strongSelf.appleMusicTextField.text != "" else {
                completion(nil)
                return}
            guard strongSelf.appleMusicTextField.text!.count > 15 else {
                completion(nil)
                return}
            let songId = String((strongSelf.appleMusicTextField.text?.suffix(10))!)
            AppleMusicRequest.shared.getAppleMusicSong(id: songId, completion: { result in
                switch result {
                case.success(let song):
                    strongSelf.apple = song
                    completion(nil)
                case.failure(let err):
//                    completion(InstrumentalUploadErrors.appleMusicURLInvalid(err)
                    print("Asgsdbrdfxnb ", err)
                default:
                    break
                }
            })
        }
    }
    
    func deezerGraph(completion: @escaping ((Error?) -> Void)) {
        DispatchQueue.main.async {[weak self] in
            guard let strongSelf = self else {return}
            guard strongSelf.deezerTextField.text != "" else {
                completion(nil)
                return}
            guard strongSelf.deezerTextField.text!.count > 15 else {
                completion(nil)
                return}
            var deezUrl = strongSelf.deezerTextField.text!
            if let dotRange = deezUrl.range(of: "?") {
                deezUrl.removeSubrange(dotRange.lowerBound..<deezUrl.endIndex)
            }
            let songId = String(deezUrl.suffix(10))
            DeezerRequest.shared.getDeezerSong(id: songId, completion: { result in
                switch result {
                case.success(let song):
                    strongSelf.deezer = song
                    completion(nil)
                case.failure(let err):
                    print("Asgsdbrdfxnb ", err)
                default:
                    break
                }
            })
        }
        
    }
    
    //MARK: - Storing Data
    func requiredData(song:SongData, id: String, completion: @escaping ((Error?) -> Void)) {
        let SongRef = Database.database().reference().child("Music Content").child("Instrumentals").child(instrumentalRandomKey)
        
        var InstrumentalInfoMap = [String : Any]()
        InstrumentalInfoMap = [
            "Name" : "\(song.name) (Instrumental)",
            "Songs" : [song.toneDeafAppId],
            "Videos": song.videos,
            "Producers" : song.songProducers,
            "Artists" : song.songArtist,
            "Engineers": [
                "Mix Engineer": song.songMixEngineer,
                "Mastering Engineer": song.songMasteringEngineer,
            ],
            "Albums": song.albums,
            "Audio URL" : downloadURL!,
            "Time Uploaded To App" : currtime!,
            "Date Uploaded To App" : currdate!,
            "Duration" : StorageManager.beatDuration,
            "Number of Favorites" : 0,
            "Tone Deaf App Id" : tDAppId,
            "Verification Level": String(verificationLevel),
            "Industry Certified": industryCertified,
            "Active Status": false
        ]
        
        SongRef.updateChildValues(InstrumentalInfoMap) { [weak self] (error, ref) in
            guard let strongSelf = self else {return}
            if let error = error {
                print("📕 Failed to upload dictionary to database: \(error)")
                return
            } else {
                completion(nil)
            }
        }
    }
    
    func storeAllContentId(completion: @escaping ((Error?) -> Void)) {
        Database.database().reference().child("All Content IDs").observeSingleEvent(of: .value, with: {[weak self] snap in
            guard let strongSelf = self else {return}
            if !(snap.value is NSNull) {
                var arr = snap.value as! [String]
                arr.append("\(strongSelf.tDAppId)")
                Database.database().reference().child("All Content IDs").setValue(arr)
                completion(nil)
            }
            else {
                let arr = ["\(strongSelf.tDAppId)"]
                Database.database().reference().child("All Content IDs").setValue(arr)
                completion(nil)
                return
            }
        })
    }
    
    func storeInstrumentalId(completion: @escaping (Error?) -> Void) {
        Database.database().reference().child("Music Content").child("Instrumentals").child("All Instrumental IDs").observeSingleEvent(of: .value, with: {[weak self] snap in
            guard let strongSelf = self else {return}
            if !(snap.value is NSNull) {
                var arr = snap.value as! [String]
                arr.append("\(strongSelf.tDAppId)")
                Database.database().reference().child("Music Content").child("Instrumentals").child("All Instrumental IDs").setValue(arr)
                completion(nil)
            }
            else {
                let arr = ["\(strongSelf.tDAppId)"]
                Database.database().reference().child("Music Content").child("Instrumentals").child("All Instrumental IDs").setValue(arr)
                completion(nil)
                return
            }
        })
    }
    
    func spotifyStore(completion: @escaping (Error?) -> Void) {
        let categorty = "\(instrumentalRandomKey!)--\(songAttatched.name)--\(tDAppId)"
        let spotifyContentRandomKey = ("\(spotifyMusicContentType)--\(songAttatched.name)--\(currdate!)--\(currtime!)")
        guard let spotify = spotify else {
            return
        }
        
        var SongInfoMap = [String : Any]()
        SongInfoMap = [
            "Name" : spotify.spotifyName,
            "Artist 1" : spotify.spotifyArtist1,
            "Artist 1 URL" : spotify.spotifyArtist1URL,
            "Artist 2" : spotify.spotifyArtist2,
            "Artist 2 URL" : spotify.spotifyArtist2URL,
            "Artist 3" : spotify.spotifyArtist3,
            "Artist 3 URL" : spotify.spotifyArtist3URL,
            "Artist 4" : spotify.spotifyArtist4,
            "Artist 4 URL" : spotify.spotifyArtist4URL,
            "Artist 5" : spotify.spotifyArtist5,
            "Artist 5 URL" : spotify.spotifyArtist5URL,
            "Artist 6" : spotify.spotifyArtist6,
            "Artist 6 URL" : spotify.spotifyArtis6URL,
            "Explicity" : spotify.spotifyExplicity,
            "Preview URL" : spotify.spotifyPreviewURL,
            "ISRC" : spotify.spotifyISRC,
            "Date Released On Spotify" : spotify.spotifyDateSPT,
            "Time Uploaded To App" : spotify.spotifyTimeIA,
            "Date Uploaded To App" : spotify.spotifyDateIA,
            "Duration" : spotify.spotifyDuration,
            "Artwork URL" : spotify.spotifyArtworkURL,
            "Song URL" : spotify.spotifySongURL,
            "Number of Favorites" : spotify.spotifyFavorites,
            "Track Number" : spotify.spotifyTrackNumber,
            "Album Type" : spotify.spotifyAlbumType,
            "Spotify Id" : spotify.spotifyId,
            "Active Status": false
        ]
        
        let SongRef = Database.database().reference().child("Music Content").child("Instrumentals").child(categorty).child(spotifyContentRandomKey)
        
        SongRef.updateChildValues(SongInfoMap) { (error, _) in
            if let error = error {
                print("📕 Failed to upload dictionary to database: \(error)")
                Utilities.showError2("Failed to Upload. Please try again.", actionText: "OK")
                completion(error)
                return
            } else {
                completion(nil)
                return
            }
        }
    }
    
    func appleStore(completion: @escaping (Error?) -> Void) {
        let categorty = "\(instrumentalRandomKey!)--\(songAttatched.name)--\(tDAppId)"
        let appleContentRandomKey = ("\(appleMusicContentType)--\(songAttatched.name)--\(currdate!)--\(currtime!)")
        guard let apple = apple else {
            return
        }
        
        var SongInfoMap = [String : Any]()
        SongInfoMap = [
            "Name" : apple.appleName,
            "Artist" : apple.appleArtist,
            "Explicity" : apple.appleExplicity,
            "Preview URL" : apple.applePreviewURL,
            "ISRC" : apple.appleISRC,
            "Date Released On Apple" : apple.appleDateAPPL,
            "Time Uploaded To App" : apple.appleTimeIA,
            "Date Uploaded To App" : apple.appleDateIA,
            "Duration" : apple.appleDuration,
            "Artwork URL" : apple.appleArtworkURL,
            "Song URL" : apple.appleSongURL,
            "Album Name" : apple.appleAlbumName,
            "Composers" : apple.applecomposers,
            "Genres" : apple.appleGenres,
            "Number of Favorites" : apple.appleFavorites,
            "Track Number" : apple.appleTrackNumber,
            "Apple Music Id" : apple.appleMusicId,
            "Active Status": false
        ]
        
        let SongRef = Database.database().reference().child("Music Content").child("Instrumentals").child(categorty).child(appleContentRandomKey)
        
        SongRef.updateChildValues(SongInfoMap) { (error, _) in
            if let error = error {
                print("📕 Failed to upload dictionary to database: \(error)")
                Utilities.showError2("Failed to Upload. Please try again.", actionText: "OK")
                completion(error)
                return
            } else {
                completion(nil)
                return
            }
        }
    }
    
    func deezerStore(completion: @escaping (Error?) -> Void) {
        let categorty = "\(instrumentalRandomKey!)--\(songAttatched.name)--\(tDAppId)"
        let deezerContentRandomKey = ("\(deezerMusicContentType)--\(songAttatched.name)--\(currdate!)--\(currtime!)")
        guard let deezer = deezer else {
            return
        }
        
        var SongInfoMap = [String : Any]()
        SongInfoMap = [
            "Name" : deezer.name,
            "Artist" : deezer.artist,
            "Preview URL" : deezer.previewURL,
            "ISRC" : deezer.isrc,
            "Date Released On Deezer" : deezer.deezerDate,
            "Time Uploaded To App" : deezer.timeIA,
            "Date Uploaded To App" : deezer.dateIA,
            "Duration" : deezer.duration,
            "Artwork URL" : deezer.imageurl,
            "Song URL" : deezer.url,
            "Deezer Music Id" : deezer.deezerID,
            "Active Status" : false
        ]
        
        let SongRef = Database.database().reference().child("Music Content").child("Instrumentals").child(categorty).child(deezerContentRandomKey)
        
        SongRef.updateChildValues(SongInfoMap) { (error, _) in
            if let error = error {
                print("📕 Failed to upload dictionary to database: \(error)")
                Utilities.showError2("Failed to Upload. Please try again.", actionText: "OK")
                completion(error)
                return
            } else {
                completion(nil)
                return
            }
        }
    }
    
    func soundcloudStore(completion: @escaping ((Error?) -> Void)) {
        var url = ""
        DispatchQueue.main.async {[weak self] in
            guard let strongSelf = self else {return}
            url = strongSelf.soundcloudurl
            
            let categorty = "\(strongSelf.instrumentalRandomKey!)--\(strongSelf.songAttatched.name)--\(strongSelf.tDAppId)"
            let soundcloudContentRandomKey = ("\(soundcloudMusicContentType)--\(strongSelf.songAttatched.name)--\(strongSelf.currdate!)--\(strongSelf.currtime!)")
            
            var SongInfoMap = [String : Any]()
            SongInfoMap = [
                "url" : url,
                "Active Status": false]
            
            let SongRef = Database.database().reference().child("Music Content").child("Instrumentals").child(categorty).child(soundcloudContentRandomKey)
            
            SongRef.updateChildValues(SongInfoMap) { [weak self] (error, songRef) in
                guard let strongSelf = self else {return}
                if let error = error {
                    print("📕 Failed to upload dictionary to database: \(error)")
                    Utilities.showError2("Failed to Upload. Please try again.", actionText: "OK")
                    completion(error)
                    return
                } else {
                    completion(nil)
                    return
                }
            }
        }
    }
    
    func youtubeMusicStore(completion: @escaping ((Error?) -> Void)) {
        var url = ""
        DispatchQueue.main.async {[weak self] in
            guard let strongSelf = self else {return}
            url = strongSelf.youtubemusicurl
            
            let categorty = "\(strongSelf.instrumentalRandomKey!)--\(strongSelf.songAttatched.name)--\(strongSelf.tDAppId)"
            let contentRandomKey = ("\(youtubeMusicContentType)--\(strongSelf.songAttatched.name)--\(strongSelf.currdate!)--\(strongSelf.currtime!)")
            
            var SongInfoMap = [String : Any]()
            SongInfoMap = [
                "url" : url,
                "Active Status": false]
            
            let SongRef = Database.database().reference().child("Music Content").child("Instrumentals").child(categorty).child(contentRandomKey)
            
            SongRef.updateChildValues(SongInfoMap) { [weak self] (error, songRef) in
                guard let strongSelf = self else {return}
                if let error = error {
                    print("📕 Failed to upload dictionary to database: \(error)")
                    Utilities.showError2("Failed to Upload. Please try again.", actionText: "OK")
                    completion(error)
                    return
                } else {
                    completion(nil)
                    return
                }
            }
        }
    }
    
    func amazonMusicStore(completion: @escaping ((Error?) -> Void)) {
        var url = ""
        DispatchQueue.main.async {[weak self] in
            guard let strongSelf = self else {return}
            url = strongSelf.amazonurl
            
            let categorty = "\(strongSelf.instrumentalRandomKey!)--\(strongSelf.songAttatched.name)--\(strongSelf.tDAppId)"
            let contentRandomKey = ("\(amazonMusicContentType)--\(strongSelf.songAttatched.name)--\(strongSelf.currdate!)--\(strongSelf.currtime!)")
            
            var SongInfoMap = [String : Any]()
            SongInfoMap = [
                "url" : url,
                "Active Status": false]
            
            let SongRef = Database.database().reference().child("Music Content").child("Instrumentals").child(categorty).child(contentRandomKey)
            
            SongRef.updateChildValues(SongInfoMap) { [weak self] (error, songRef) in
                guard let strongSelf = self else {return}
                if let error = error {
                    print("📕 Failed to upload dictionary to database: \(error)")
                    Utilities.showError2("Failed to Upload. Please try again.", actionText: "OK")
                    completion(error)
                    return
                } else {
                    completion(nil)
                    return
                }
            }
        }
    }
    
    func tidalStore(completion: @escaping ((Error?) -> Void)) {
        var url = ""
        DispatchQueue.main.async {[weak self] in
            guard let strongSelf = self else {return}
            url = strongSelf.tidalurl
            
            let categorty = "\(strongSelf.instrumentalRandomKey!)--\(strongSelf.songAttatched.name)--\(strongSelf.tDAppId)"
            let contentRandomKey = ("\(tidalMusicContentType)--\(strongSelf.songAttatched.name)--\(strongSelf.currdate!)--\(strongSelf.currtime!)")
            
            var SongInfoMap = [String : Any]()
            SongInfoMap = [
                "url" : url,
                "Active Status": false]
            
            let SongRef = Database.database().reference().child("Music Content").child("Instrumentals").child(categorty).child(contentRandomKey)
            
            SongRef.updateChildValues(SongInfoMap) { [weak self] (error, songRef) in
                guard let strongSelf = self else {return}
                if let error = error {
                    print("📕 Failed to upload dictionary to database: \(error)")
                    Utilities.showError2("Failed to Upload. Please try again.", actionText: "OK")
                    completion(error)
                    return
                } else {
                    completion(nil)
                    return
                }
            }
        }
    }
    
    func napsterStore(completion: @escaping ((Error?) -> Void)) {
        var url = ""
        DispatchQueue.main.async {[weak self] in
            guard let strongSelf = self else {return}
            url = strongSelf.napsterurl
            
            let categorty = "\(strongSelf.instrumentalRandomKey!)--\(strongSelf.songAttatched.name)--\(strongSelf.tDAppId)"
            let contentRandomKey = ("\(napsterMusicContentType)--\(strongSelf.songAttatched.name)--\(strongSelf.currdate!)--\(strongSelf.currtime!)")
            
            var SongInfoMap = [String : Any]()
            SongInfoMap = [
                "url" : url,
                "Active Status": false]
            
            let SongRef = Database.database().reference().child("Music Content").child("Instrumentals").child(categorty).child(contentRandomKey)
            
            SongRef.updateChildValues(SongInfoMap) { [weak self] (error, songRef) in
                guard let strongSelf = self else {return}
                if let error = error {
                    print("📕 Failed to upload dictionary to database: \(error)")
                    Utilities.showError2("Failed to Upload. Please try again.", actionText: "OK")
                    completion(error)
                    return
                } else {
                    completion(nil)
                    return
                }
            }
        }
    }
    
    func spinrillaStore(completion: @escaping ((Error?) -> Void)) {
        var url = ""
        DispatchQueue.main.async {[weak self] in
            guard let strongSelf = self else {return}
            url = strongSelf.tidalurl
            
            let categorty = "\(strongSelf.instrumentalRandomKey!)--\(strongSelf.songAttatched.name)--\(strongSelf.tDAppId)"
            let contentRandomKey = ("\(spinrillaMusicContentType)--\(strongSelf.songAttatched.name)--\(strongSelf.currdate!)--\(strongSelf.currtime!)")
            
            var SongInfoMap = [String : Any]()
            SongInfoMap = [
                "url" : url,
                "Active Status": false]
            
            let SongRef = Database.database().reference().child("Music Content").child("Instrumentals").child(categorty).child(contentRandomKey)
            
            SongRef.updateChildValues(SongInfoMap) { [weak self] (error, songRef) in
                guard let strongSelf = self else {return}
                if let error = error {
                    print("📕 Failed to upload dictionary to database: \(error)")
                    Utilities.showError2("Failed to Upload. Please try again.", actionText: "OK")
                    completion(error)
                    return
                } else {
                    completion(nil)
                    return
                }
            }
        }
    }
    
    func updatePersonInstrumentals(completion: @escaping ((Error?) -> Void)) {
        var count = 0
        for item in personref {
            getPersonInstrumentalsInDB(cat: item, completion: {[weak self] instrumentals in
                guard let strongSelf = self else {return}
                var arr = instrumentals
                arr.append(strongSelf.tDAppId)
                let ref = Database.database().reference().child("Registered Persons").child(item).child("Instrumentals")
                ref.setValue(arr, withCompletionBlock: {(error, _) in
                    if let error = error {
                        completion(error)
                    }
                    else {
                        count+=1
                        if count == strongSelf.personref.count {
                            completion(nil)
                        }
                    }
                })
            })
        }
    }
    
    func updateVideoInstrumentals(completion: @escaping ((Error?) -> Void)) {
        var count = 0
        for item in videoref {
            getVideoInstrumentalsInDB(vidcat: item, completion: {[weak self] instrumentals in
                guard let strongSelf = self else {return}
                var arr = instrumentals
                arr.append(strongSelf.tDAppId)
                let ref = Database.database().reference().child("Music Content").child("Videos").child(item).child("Instrumentals")
                ref.setValue(arr, withCompletionBlock: {(error, _) in
                    if let error = error {
                        completion(error)
                    }
                    else {
                        count+=1
                        if count == strongSelf.videoref.count {
                            completion(nil)
                        }
                    }
                })
            })
        }
    }
    
    func updateAlbumInstrumentals(completion: @escaping ((Error?) -> Void)) {
        var count = 0
        for item in albumref {
            getAlbumInstrumentalsInDB(albcat: item, completion: {[weak self] instrumentals in
                guard let strongSelf = self else {return}
                var arr = instrumentals
                arr.append(strongSelf.tDAppId)
                let ref = Database.database().reference().child("Music Content").child("Albums").child(item).child("REQUIRED").child("Instrumentals")
                ref.setValue(arr, withCompletionBlock: {(error, _) in
                    if let error = error {
                        completion(error)
                    }
                    else {
                        count+=1
                        if count == strongSelf.albumref.count {
                            completion(nil)
                        }
                    }
                })
            })
        }
    }
    
    func updateSongInstrumentals(completion: @escaping ((Error?) -> Void)) {
        let item = "\(songContentTag)--\(songAttatched.name)--\(songAttatched.toneDeafAppId)"
        getSongInstrumentalsInDB(cat: item, completion: {[weak self] instrumentals in
            guard let strongSelf = self else {return}
            var arr = instrumentals
            arr.append(strongSelf.tDAppId)
            let ref = Database.database().reference().child("Music Content").child("Songs").child(item).child("REQUIRED").child("Instrumentals")
            ref.setValue(arr, withCompletionBlock: {(error, _) in
                if let error = error {
                    completion(error)
                }
                else {
                    completion(nil)
                }
            })
        })
    }
    
    func updateProducerRoles(completion: @escaping ((Error?) -> Void)) {
        let arr = songAttatched.songProducers
        if !arr.isEmpty {
            var count = 0
            for per in arr {
                for ref in personref {
                    if ref.contains(per) {
                        let referenceDB = Database.database().reference().child("Registered Persons").child(ref)
                        getPersonRolesInDB(ref: referenceDB, completion: {[weak self] roles in
                            guard let strongSelf = self else {return}
                            if var curole = roles["Producer"] as? [String] {
                                if !curole.contains(strongSelf.tDAppId) {
                                    curole.append(strongSelf.tDAppId)
                                }
                                referenceDB.child("Roles").child("Producer").setValue(curole, withCompletionBlock:  { error, reference in
                                    if let error = error {
                                        completion(error)
                                        return
                                    }
                                    else {
                                        count+=1
                                        if count == arr.count {
                                            completion(nil)
                                        }
                                    }
                                })
                            } else {
                                var curole:[String] = []
                                if !curole.contains(strongSelf.tDAppId) {
                                    curole.append(strongSelf.tDAppId)
                                }
                                referenceDB.child("Roles").child("Producer").setValue(curole, withCompletionBlock:  { error, reference in
                                    if let error = error {
                                        completion(error)
                                        return
                                    }
                                    else {
                                        count+=1
                                        if count == arr.count {
                                            completion(nil)
                                        }
                                    }
                                })
                            }
                        })
                    }
                }
            }
        } else {
            completion(nil)
        }
    }
    
    func updateMixEngineerRoles(completion: @escaping ((Error?) -> Void)) {
        if let arr = songAttatched.songMixEngineer {
            if !arr.isEmpty {
                var count = 0
                for per in arr {
                    for ref in personref {
                        if ref.contains(per) {
                            let referenceDB = Database.database().reference().child("Registered Persons").child(ref)
                            getPersonRolesInDB(ref: referenceDB, completion: {[weak self] roles in
                                guard let strongSelf = self else {return}
                                if var curolee = roles["Engineer"] as? NSDictionary {
                                    let eng = curolee.mutableCopy() as! NSMutableDictionary
                                    if var curole = eng ["Mix Engineer"] as? [String] {
                                        if !curole.contains(strongSelf.tDAppId) {
                                            curole.append(strongSelf.tDAppId)
                                        }
                                        referenceDB.child("Roles").child("Engineer").child("Mix Engineer").setValue(curole, withCompletionBlock:  { error, reference in
                                            if let error = error {
                                                completion(error)
                                                return
                                            }
                                            else {
                                                count+=1
                                                if count == arr.count {
                                                    completion(nil)
                                                }
                                            }
                                        })
                                    } else {
                                        var curole:[String] = []
                                        if !curole.contains(strongSelf.tDAppId) {
                                            curole.append(strongSelf.tDAppId)
                                        }
                                        referenceDB.child("Roles").child("Engineer").child("Mix Engineer").setValue(curole, withCompletionBlock:  { error, reference in
                                            if let error = error {
                                                completion(error)
                                                return
                                            }
                                            else {
                                                count+=1
                                                if count == arr.count {
                                                    completion(nil)
                                                }
                                            }
                                        })
                                    }
                                } else {
                                    var curole:[String] = []
                                    if !curole.contains(strongSelf.tDAppId) {
                                        curole.append(strongSelf.tDAppId)
                                    }
                                    referenceDB.child("Roles").child("Engineer").child("Mix Engineer").setValue(curole, withCompletionBlock:  { error, reference in
                                        if let error = error {
                                            completion(error)
                                            return
                                        }
                                        else {
                                            count+=1
                                            if count == arr.count {
                                                completion(nil)
                                            }
                                        }
                                    })
                                }
                            })
                        }
                    }
                }
            } else {
                completion(nil)
            }
        } else {
            completion(nil)
        }
    }
    
    func updateMasteringEngineerRoles(completion: @escaping ((Error?) -> Void)) {
        if let arr = songAttatched.songMasteringEngineer {
            if !arr.isEmpty {
                var count = 0
                for per in arr {
                    for ref in personref {
                        if ref.contains(per) {
                            let referenceDB = Database.database().reference().child("Registered Persons").child(ref)
                            getPersonRolesInDB(ref: referenceDB, completion: {[weak self] roles in
                                guard let strongSelf = self else {return}
                                if var curolee = roles["Engineer"] as? NSDictionary {
                                    let eng = curolee.mutableCopy() as! NSMutableDictionary
                                    if var curole = eng ["Mastering Engineer"] as? [String] {
                                        if !curole.contains(strongSelf.tDAppId) {
                                            curole.append(strongSelf.tDAppId)
                                        }
                                        referenceDB.child("Roles").child("Engineer").child("Mastering Engineer").setValue(curole, withCompletionBlock:  { error, reference in
                                            if let error = error {
                                                completion(error)
                                                return
                                            }
                                            else {
                                                count+=1
                                                if count == arr.count {
                                                    completion(nil)
                                                }
                                            }
                                        })
                                    } else {
                                        var curole:[String] = []
                                        if !curole.contains(strongSelf.tDAppId) {
                                            curole.append(strongSelf.tDAppId)
                                        }
                                        referenceDB.child("Roles").child("Engineer").child("Mastering Engineer").setValue(curole, withCompletionBlock:  { error, reference in
                                            if let error = error {
                                                completion(error)
                                                return
                                            }
                                            else {
                                                count+=1
                                                if count == arr.count {
                                                    completion(nil)
                                                }
                                            }
                                        })
                                    }
                                } else {
                                    var curole:[String] = []
                                    if !curole.contains(strongSelf.tDAppId) {
                                        curole.append(strongSelf.tDAppId)
                                    }
                                    referenceDB.child("Roles").child("Engineer").child("Mastering Engineer").setValue(curole, withCompletionBlock:  { error, reference in
                                        if let error = error {
                                            completion(error)
                                            return
                                        }
                                        else {
                                            count+=1
                                            if count == arr.count {
                                                completion(nil)
                                            }
                                        }
                                    })
                                }
                            })
                        }
                    }
                }
            } else {
                completion(nil)
            }
        } else {
            completion(nil)
        }
    }
    
    //MARK: - Storing Helpers
    func getSongInstrumentalsInDB(cat: String, completion: @escaping (Array<String>) -> Void) {
        let ref = Database.database().reference().child("Music Content").child("Songs").child(cat).child("REQUIRED").child("Instrumentals")
        ref.observeSingleEvent(of: .value, with: { snapshot in
            var myinstArray:[String] = []
            if let val = snapshot.value {
                let valu = val as? [String]
                guard let value = valu else {
                    completion(myinstArray)
                    return
                }
                if value[0] != "" {
                    myinstArray = value
                }
                completion(myinstArray)
            } else {
                completion(myinstArray)
            }
        })
    }
    
    func getAlbumInstrumentalsInDB(albcat: String, completion: @escaping (Array<String>) -> Void) {
        let ref = Database.database().reference().child("Music Content").child("Albums").child(albcat).child("REQUIRED").child("Instrumentals")
        ref.observeSingleEvent(of: .value, with: { snapshot in
            var mysongsArray:[String] = []
            if let val = snapshot.value {
                let valu = val as? [String]
                guard let value = valu else {
                    completion(mysongsArray)
                    return
                }
                if value[0] != "" {
                    mysongsArray = value
                }
                print("instru from album db \(mysongsArray)")
                completion(mysongsArray)
            } else {
                completion(mysongsArray)
            }
        })
    }
    
    func getVideoInstrumentalsInDB(vidcat: String, completion: @escaping (Array<String>) -> Void) {
        let ref = Database.database().reference().child("Music Content").child("Videos").child(vidcat).child("Instrumentals")
        ref.observeSingleEvent(of: .value, with: { snapshot in
            var mysongsArray:[String] = []
            if let val = snapshot.value {
                let valu = val as? [String]
                guard let value = valu else {
                    completion(mysongsArray)
                    return
                }
                if value[0] != "" {
                    mysongsArray = value
                }
                print("videos from db \(mysongsArray)")
                completion(mysongsArray)
            } else {
                completion(mysongsArray)
            }
        })
    }
    
    func getPersonInstrumentalsInDB(cat: String, completion: @escaping (Array<String>) -> Void) {
        let ref = Database.database().reference().child("Registered Persons").child(cat).child("Instrumentals")
        ref.observeSingleEvent(of: .value, with: { snapshot in
            var mysongsArray:[String] = []
            if let val = snapshot.value {
                let valu = val as? [String]
                guard let value = valu else {
                    completion(mysongsArray)
                    return
                }
                if value[0] != "" {
                    mysongsArray = value
                }
                print("videos from db \(mysongsArray)")
                completion(mysongsArray)
            } else {
                completion(mysongsArray)
            }
        })
    }
    
    func getPersonRolesInDB(ref: DatabaseReference, completion: @escaping ((NSDictionary) -> Void)) {
        ref.child("Roles").observeSingleEvent(of: .value, with: { snapshot in
            var dict:NSDictionary = [:]
            if let val = snapshot.value {
                let valu = val as? NSDictionary
                guard let value = valu else {
                    completion(dict)
                    return}
                dict = value
                completion(dict)
            } else {
                completion(dict)
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
    
    func dismissKeyboardOnTap() {
        let tap = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        //scrollView.keyboardDismissMode = .onDrag
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @objc func dismissKeyboard2() {
        songIdTextField.text = chosenSongNames
        view.endEditing(true)
    }

}

extension InstrumentalUploadViewController: UIDocumentPickerDelegate {
    
    func openFiles() {
        
        let documentPicker = UIDocumentPickerViewController(documentTypes: [kUTTypeMP3 as String], in: .import)
        documentPicker.delegate = self
        documentPicker.allowsMultipleSelection = false
        present(documentPicker, animated: true, completion: nil)
    }
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        let newUrls = urls.compactMap { (url: URL) -> URL? in
            // Create file URL to temporary folder
            var tempURL = URL(fileURLWithPath: NSTemporaryDirectory())
            // Apend filename (name+extension) to URL
            tempURL.appendPathComponent(url.lastPathComponent)
            do {
                // If file with same name exists remove it (replace file with new one)
                if FileManager.default.fileExists(atPath: tempURL.path) {
                    try FileManager.default.removeItem(atPath: tempURL.path)
                }
                // Move file from app_id-Inbox to tmp/filename
                try FileManager.default.moveItem(atPath: url.path, toPath: tempURL.path)
                return tempURL
            } catch {
                
                print(error.localizedDescription)
                return nil
            }
        }
        
        selectedFileURL = newUrls.first
        guard selectedFileURL == newUrls.first else {
            return
        }
        
        let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let sandboxFileURL = dir.appendingPathComponent(selectedFileURL!.lastPathComponent)
        
        if FileManager.default.fileExists(atPath: sandboxFileURL.path) {
            print("\(sandboxFileURL.lastPathComponent) already already Exists")
            textFieldBeatFile.text = selectedFileURL!.lastPathComponent as String
        }
        else {
            do {
                try FileManager.default.copyItem(at: selectedFileURL!, to: sandboxFileURL)
                textFieldBeatFile.text = selectedFileURL!.lastPathComponent as String
                print("📗 \(textFieldBeatFile.text!)")
            }
            catch {
                print("Error: \(error)")
            }
        }
    }
    
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        
    }
}

extension InstrumentalUploadViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        var nor = 0
        switch pickerView {
        case songsPickerView:
            nor = AllSongsInDatabaseArray.count
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
        case songsPickerView:
            nor = "\(AllSongsInDatabaseArray[row].name) -- \(AllSongsInDatabaseArray[row].toneDeafAppId)"
        case verificationLevelPickerView:
            nor = String(verificationLevelArr[row])
        default:
            break
        }
        return nor
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch pickerView {
        case songsPickerView:
            chosenSongs = AllSongsInDatabaseArray[row].toneDeafAppId.trimmingCharacters(in: .whitespacesAndNewlines)
            //print(chosenSongs)
            chosenSongNames = AllSongsInDatabaseArray[row].name.trimmingCharacters(in: .whitespacesAndNewlines)
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

        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.done, target: self, action: #selector(dismissKeyboard2))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItem.Style.plain, target: self, action: #selector(dismissKeyboard))

        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true

        textField.inputView = pickerView
        textField.inputAccessoryView = toolBar
    }
}

extension InstrumentalUploadViewController: UITextFieldDelegate {
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        switch textField {
        case verificationLevelTextField:
            verificationLevel = nil
            return true
        default:
            return true
        }
    }
    
}

public enum InstrumentalUploadErrors: Error {
    case appleMusicURLInvalid
}
