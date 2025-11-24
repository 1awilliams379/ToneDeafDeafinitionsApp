//
//  VideoUploadViewController.swift
//  ToneDeafDeafinitionsApp
//
//  Created by Tone Deaf on 7/2/22.
//  Copyright © 2022 GITEM Solutions. All rights reserved.
//

import UIKit
import FirebaseDatabase
import MusicKit

class VideoUploadViewController: UIViewController {
    
    let ytsemaphore = DispatchSemaphore(value: 1)
    let igtvsemaphore = DispatchSemaphore(value: 1)
    let instagramPostsemaphore = DispatchSemaphore(value: 1)
    let facebooksemaphore = DispatchSemaphore(value: 1)
    let worldstarsemaphore = DispatchSemaphore(value: 1)
    let appleMusicsemaphore = DispatchSemaphore(value: 1)
    let twittersemaphore = DispatchSemaphore(value: 1)
    let tiktoksemaphore = DispatchSemaphore(value: 1)
    let ytstoresemaphore = DispatchSemaphore(value: 1)
    let igtvstoresemaphore = DispatchSemaphore(value: 1)
    let instagramPoststoresemaphore = DispatchSemaphore(value: 1)
    let facebookstoresemaphore = DispatchSemaphore(value: 1)
    let worldstarstoresemaphore = DispatchSemaphore(value: 1)
    let appleMusicstoresemaphore = DispatchSemaphore(value: 1)
    let twitterstoresemaphore = DispatchSemaphore(value: 1)
    let tiktokstoresemaphore = DispatchSemaphore(value: 1)
    let videographerstoresemaphore = DispatchSemaphore(value: 1)
    let videographerrolesemaphore = DispatchSemaphore(value: 1)
    let personstoresemaphore = DispatchSemaphore(value: 1)
    let songstoresemaphore = DispatchSemaphore(value: 1)
    let albumstoresemaphore = DispatchSemaphore(value: 1)
    let instrumentalstoresemaphore = DispatchSemaphore(value: 1)
    let beatstoresemaphore = DispatchSemaphore(value: 1)
    
    var videouploadCompletionStatus1:Bool!
    var videouploadCompletionStatus2:Bool!
    var videouploadCompletionStatus3:Bool!
    var videouploadCompletionStatus4:Bool!
    var videouploadCompletionStatus5:Bool!
    var videouploadCompletionStatus6:Bool!
    var videouploadCompletionStatus7:Bool!
    var videouploadCompletionStatus8:Bool!
    var videouploadCompletionStatus9:Bool!
    var videouploadCompletionStatus10:Bool!
    var videouploadCompletionStatus11:Bool!
    var videouploadCompletionStatus12:Bool!
    var videouploadCompletionStatus13:Bool!
    var videouploadCompletionStatus14:Bool!
    var videouploadCompletionStatus15:Bool!
    var videouploadCompletionStatus16:Bool!
    var videouploadCompletionStatus17:Bool!
    var videouploadCompletionStatus18:Bool!
    var videouploadCompletionStatus19:Bool!
    var videouploadCompletionStatus20:Bool!
    var videouploadCompletionStatus21:Bool!
    var videouploadCompletionStatus22:Bool!
    var videouploadCompletionStatus23:Bool!
    var videouploadCompletionStatus24:Bool!
    var videouploadCompletionStatus25:Bool!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var personTableView: UITableView!
    @IBOutlet weak var personHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var videographersTableView: UITableView!
    @IBOutlet weak var videographersHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var songsTableView: UITableView!
    @IBOutlet weak var songsHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var albumsTableView: UITableView!
    @IBOutlet weak var albumsHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var instrumaentalsTableView: UITableView!
    @IBOutlet weak var instrumentalsHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var beatsTableView: UITableView!
    @IBOutlet weak var beatsHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var youtubeTableView: UITableView!
    @IBOutlet weak var youtubeHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var iGTVTableView: UITableView!
    @IBOutlet weak var iGTVHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var instagramPostTableView: UITableView!
    @IBOutlet weak var instagramPostHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var facebookPostTableView: UITableView!
    @IBOutlet weak var facebookHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var worldstarTableView: UITableView!
    @IBOutlet weak var worldstarHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var twitterTableView: UITableView!
    @IBOutlet weak var twitterHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var appleMusicTableView: UITableView!
    @IBOutlet weak var appleMusicHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var tikTokTableView: UITableView!
    @IBOutlet weak var tikTokHeightConstraint: NSLayoutConstraint!

    @IBOutlet weak var nameTextField: UITextField! {
        didSet {
            let placeholderText = NSAttributedString(string: "Name of video",
                                                     attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray.withAlphaComponent(0.4)])
            
            nameTextField.attributedPlaceholder = placeholderText
        }
    }
    @IBOutlet weak var youtubeTextField: UITextField! {
        didSet {
            let placeholderText = NSAttributedString(string: "Must include 'watch/'",
                                                     attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray.withAlphaComponent(0.4)])
            
            youtubeTextField.attributedPlaceholder = placeholderText
        }
    }
    @IBOutlet weak var iGTVTextField: UITextField! {
        didSet {
            let placeholderText = NSAttributedString(string: "URL",
                                                     attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray.withAlphaComponent(0.4)])
            
            iGTVTextField.attributedPlaceholder = placeholderText
        }
    }
    @IBOutlet weak var instagramPostTextField: UITextField! {
        didSet {
            let placeholderText = NSAttributedString(string: "URL",
                                                     attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray.withAlphaComponent(0.4)])
            
            instagramPostTextField.attributedPlaceholder = placeholderText
        }
    }
    @IBOutlet weak var facebookPostTextField: UITextField! {
        didSet {
            let placeholderText = NSAttributedString(string: "URL",
                                                     attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray.withAlphaComponent(0.4)])
            
            facebookPostTextField.attributedPlaceholder = placeholderText
        }
    }
    @IBOutlet weak var worldstarTextField: UITextField! {
        didSet {
            let placeholderText = NSAttributedString(string: "URL",
                                                     attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray.withAlphaComponent(0.4)])
            
            worldstarTextField.attributedPlaceholder = placeholderText
        }
    }
    @IBOutlet weak var twitterTextField: UITextField! {
        didSet {
            let placeholderText = NSAttributedString(string: "URL",
                                                     attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray.withAlphaComponent(0.4)])
            
            twitterTextField.attributedPlaceholder = placeholderText
        }
    }
    @IBOutlet weak var appleMusicTextField: UITextField! {
        didSet {
            let placeholderText = NSAttributedString(string: "URL",
                                                     attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray.withAlphaComponent(0.4)])
            
            appleMusicTextField.attributedPlaceholder = placeholderText
        }
    }
    @IBOutlet weak var tikTokTextField: UITextField! {
        didSet {
            let placeholderText = NSAttributedString(string: "URL",
                                                     attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray.withAlphaComponent(0.4)])
            
            tikTokTextField.attributedPlaceholder = placeholderText
        }
    }
    @IBOutlet weak var typeTextField: UITextField! {
        didSet {
            let placeholderText = NSAttributedString(string: "Select Type",
                                                     attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray.withAlphaComponent(0.4)])
            
            typeTextField.attributedPlaceholder = placeholderText
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
    
    @IBOutlet weak var youtubeAddButton: UIButton!
    @IBOutlet weak var iGTVAddButton: UIButton!
    @IBOutlet weak var instagramPostAddButton: UIButton!
    @IBOutlet weak var facebookAddButton: UIButton!
    @IBOutlet weak var worldstarAddButton: UIButton!
    @IBOutlet weak var twitterAddButton: UIButton!
    @IBOutlet weak var appleMusicAddButton: UIButton!
    @IBOutlet weak var tikTokAddButton: UIButton!
    
    let personTextField =  UITextField(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    let videographersTextField =  UITextField(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    let songsTextField =  UITextField(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    let albumsTextField =  UITextField(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    let instrumentalsTextField =  UITextField(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    let beatsTextField =  UITextField(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    
    var typeArr:[String] = Constants.Videos.typeArr
    var chosenType:String!

    var progressView:UIProgressView!
    var totalProgress:Float = 3
    var progressCompleted:Float = 0
    
    var verificationLevelPickerView = UIPickerView()
    var verificationLevelArr:[Character] = Constants.Verification.verificationLevels
    var verificationLevel:Character!
    
    var industryCertified:Bool = false
    
    var personPickerView = UIPickerView()
    var songsPickerView = UIPickerView()
    var albumsPickerView = UIPickerView()
    var instrumentalsPickerView = UIPickerView()
    var beatsPickerView = UIPickerView()
    var typePickerView = UIPickerView()
    var loadcount = 0
    
    var chosenVideographer:PersonData!
    var videographerArr:[PersonData] = []
    var videographernames:[String] = []
    var chosenPerson:PersonData!
    var personArr:[PersonData] = []
    var personnames:[String] = []
    var chosenSong:SongData!
    var songArr:[SongData] = []
    var songnames:[String] = []
    var chosenAlbum:AlbumData!
    var albumArr:[AlbumData] = []
    var albumnames:[String] = []
    var chosenInstrumental:InstrumentalData!
    var instrumentalArr:[InstrumentalData] = []
    var instrumentalnames:[String] = []
    var chosenBeat:BeatData!
    var beatArr:[BeatData] = []
    var beatnames:[String] = []
    
    var officialRelationArr:[String] = []
    var audioRelationArr:[String] = []
    var instrumentalRelationArr:[String] = []
    var lyricRelationArr:[String] = []
    var otherRelationArr:[String] = []
    
    var youtubeArr:[String] = []
    var iGTVArr:[String] = []
    var instagramPostArr:[String] = []
    var facebookPostArr:[String] = []
    var worldstarArr:[String] = []
    var twitterArr:[String] = []
    var appleMusicArr:[String] = []
    var tikTokArr:[String] = []

    var alertView:UIAlertController!
    
    var tDAppId:String!
    var videoDBID:String!
    var date:Date!
    var currtime = ""
    var currdate = ""
    
    var videoToUpload:VideoData!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dismissKeyboardOnTap()
        setUpElements()
        if loadcount == 0 {
            DatabaseManager.shared.fetchAllPersonsFromDatabase(completion: {person in
                AllPersonsInDatabaseArray = person
            })
            DatabaseManager.shared.fetchAllAlbumsFromDatabase(completion: {person in
                AllAlbumsInDatabaseArray = person
            })
            DatabaseManager.shared.fetchAllSongsFromDatabase(completion: {person in
                AllSongsInDatabaseArray = person
            })
            DatabaseManager.shared.fetchAllInstrumentalsFromDatabase(completion: {person in
                AllInstrumentalsInDatabaseArray = person
            })
            DatabaseManager.shared.fetchAllBeatsFromDatabase(completion: {person in
                AllBeatsInDatabaseArray = person
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
        Utilities.styleTextField(nameTextField)
        addBottomLineToText(nameTextField)
        nameTextField.delegate = self
        
        Utilities.styleTextField(youtubeTextField)
        addBottomLineToText(youtubeTextField)
        youtubeTextField.delegate = self
        youtubeAddButton.isHidden = true
        
        Utilities.styleTextField(iGTVTextField)
        addBottomLineToText(iGTVTextField)
        iGTVTextField.delegate = self
        iGTVAddButton.isHidden = true
        
        Utilities.styleTextField(instagramPostTextField)
        addBottomLineToText(instagramPostTextField)
        instagramPostTextField.delegate = self
        instagramPostAddButton.isHidden = true
        
        Utilities.styleTextField(facebookPostTextField)
        addBottomLineToText(facebookPostTextField)
        facebookPostTextField.delegate = self
        facebookAddButton.isHidden = true
        
        Utilities.styleTextField(worldstarTextField)
        addBottomLineToText(worldstarTextField)
        worldstarTextField.delegate = self
        worldstarAddButton.isHidden = true
        
        Utilities.styleTextField(twitterTextField)
        addBottomLineToText(twitterTextField)
        twitterTextField.delegate = self
        twitterAddButton.isHidden = true
        
        Utilities.styleTextField(appleMusicTextField)
        addBottomLineToText(appleMusicTextField)
        appleMusicTextField.delegate = self
        appleMusicAddButton.isHidden = true
        
        Utilities.styleTextField(tikTokTextField)
        addBottomLineToText(tikTokTextField)
        tikTokTextField.delegate = self
        tikTokAddButton.isHidden = true
        
        Utilities.styleTextField(verificationLevelTextField)
        addBottomLineToText(verificationLevelTextField)
        verificationLevelTextField.delegate = self
        
        Utilities.styleTextField(typeTextField)
        addBottomLineToText(typeTextField)
        typeTextField.delegate = self
        
            view.addSubview(videographersTextField)
        videographersTextField.inputView = personPickerView
        personPickerView.delegate = self
        personPickerView.dataSource = self
        pickerViewToolbar(textField: videographersTextField, pickerView: personPickerView)
        textFieldShouldClear(videographersTextField)
        
            view.addSubview(personTextField)
        personTextField.inputView = personPickerView
        personPickerView.delegate = self
        personPickerView.dataSource = self
        pickerViewToolbar(textField: personTextField, pickerView: personPickerView)
        textFieldShouldClear(personTextField)
        
            view.addSubview(songsTextField)
        songsTextField.inputView = songsPickerView
        songsPickerView.delegate = self
        songsPickerView.dataSource = self
        pickerViewToolbar(textField: songsTextField, pickerView: songsPickerView)
        textFieldShouldClear(songsTextField)
        
            view.addSubview(albumsTextField)
        albumsTextField.inputView = albumsPickerView
        albumsPickerView.delegate = self
        albumsPickerView.dataSource = self
        pickerViewToolbar(textField: albumsTextField, pickerView: albumsPickerView)
        textFieldShouldClear(albumsTextField)
        
            view.addSubview(instrumentalsTextField)
        instrumentalsTextField.inputView = instrumentalsPickerView
        instrumentalsPickerView.delegate = self
        instrumentalsPickerView.dataSource = self
        pickerViewToolbar(textField: instrumentalsTextField, pickerView: instrumentalsPickerView)
        textFieldShouldClear(instrumentalsTextField)
        
            view.addSubview(beatsTextField)
        beatsTextField.inputView = beatsPickerView
        beatsPickerView.delegate = self
        beatsPickerView.dataSource = self
        pickerViewToolbar(textField: beatsTextField, pickerView: beatsPickerView)
        textFieldShouldClear(beatsTextField)
        
        typeTextField.inputView = typePickerView
        typePickerView.delegate = self
        typePickerView.dataSource = self
        pickerViewToolbar(textField: typeTextField, pickerView: typePickerView)
        textFieldShouldClear(typeTextField)
        
        verificationLevelTextField.inputView = verificationLevelPickerView
        verificationLevelPickerView.delegate = self
        verificationLevelPickerView.dataSource = self
        pickerViewToolbar(textField: verificationLevelTextField, pickerView: verificationLevelPickerView)
        textFieldShouldClear(verificationLevelTextField)
        
        videographersTableView.delegate = self
        videographersTableView.dataSource = self
        videographersHeightConstraint.constant = CGFloat(50*(videographerArr.count))
        personTableView.delegate = self
        personTableView.dataSource = self
        personHeightConstraint.constant = CGFloat(50*(personArr.count))
        songsTableView.delegate = self
        songsTableView.dataSource = self
        songsHeightConstraint.constant = CGFloat(50*(songArr.count))
        albumsTableView.delegate = self
        albumsTableView.dataSource = self
        albumsHeightConstraint.constant = CGFloat(50*(albumArr.count))
        instrumaentalsTableView.delegate = self
        instrumaentalsTableView.dataSource = self
        instrumentalsHeightConstraint.constant = CGFloat(50*(instrumentalArr.count))
        beatsTableView.dataSource = self
        beatsTableView.delegate = self
        beatsHeightConstraint.constant = CGFloat(50*(beatArr.count))
        youtubeTableView.dataSource = self
        youtubeTableView.delegate = self
        youtubeHeightConstraint.constant = CGFloat(50*(youtubeArr.count))
        iGTVTableView.dataSource = self
        iGTVTableView.delegate = self
        iGTVHeightConstraint.constant = CGFloat(50*(iGTVArr.count))
        instagramPostTableView.dataSource = self
        instagramPostTableView.delegate = self
        instagramPostHeightConstraint.constant = CGFloat(50*(instagramPostArr.count))
        facebookPostTableView.dataSource = self
        facebookPostTableView.delegate = self
        facebookHeightConstraint.constant = CGFloat(50*(facebookPostArr.count))
        worldstarTableView.dataSource = self
        worldstarTableView.delegate = self
        worldstarHeightConstraint.constant = CGFloat(50*(worldstarArr.count))
        twitterTableView.dataSource = self
        twitterTableView.delegate = self
        twitterHeightConstraint.constant = CGFloat(50*(twitterArr.count))
        appleMusicTableView.dataSource = self
        appleMusicTableView.delegate = self
        appleMusicHeightConstraint.constant = CGFloat(50*(appleMusicArr.count))
        tikTokTableView.dataSource = self
        tikTokTableView.delegate = self
        tikTokHeightConstraint.constant = CGFloat(50*(tikTokArr.count))
        
    }
    
    deinit {
        print("📗 Video Upload being deallocated from memory. OS reclaiming")
    }
    
    @IBAction func addVideographerTapped(_ sender: Any) {
        chosenVideographer = AllPersonsInDatabaseArray[0]
        videographersTextField.becomeFirstResponder()
    }
    
    @IBAction func addPersonTapped(_ sender: Any) {
        chosenPerson = AllPersonsInDatabaseArray[0]
        personTextField.becomeFirstResponder()
    }
    
    @IBAction func addSongTapped(_ sender: Any) {
        chosenSong = AllSongsInDatabaseArray[0]
        songsTextField.becomeFirstResponder()
    }
    
    @IBAction func addAlbumTapped(_ sender: Any) {
        chosenAlbum = AllAlbumsInDatabaseArray[0]
        albumsTextField.becomeFirstResponder()
    }
    
    @IBAction func addInstrumentalTapped(_ sender: Any) {
        chosenInstrumental = AllInstrumentalsInDatabaseArray[0]
        instrumentalsTextField.becomeFirstResponder()
    }
    
    @IBAction func addBeatTapped(_ sender: Any) {
        chosenBeat = AllBeatsInDatabaseArray[0]
        beatsTextField.becomeFirstResponder()
    }
    
    @IBAction func addYoutubeTapped(_ sender: Any) {
        guard youtubeTextField.text != "" else {
            return}
        guard youtubeTextField.text!.count > 15 else {
            mediumImpactGenerator.impactOccurred()
            Utilities.showError2("Invalid Youtube URL.", actionText: "OK")
            return}
        guard !youtubeArr.contains(youtubeTextField.text!) else {
            mediumImpactGenerator.impactOccurred()
            Utilities.showError2("URL already added.", actionText: "OK")
            return}
        youtubeArr.append(youtubeTextField.text!)
        youtubeTextField.text = ""
        youtubeAddButton.isHidden = true
        youtubeTableView.reloadData()
        youtubeHeightConstraint.constant = CGFloat(50*(youtubeArr.count))
        view.endEditing(true)
    }
    
    @IBAction func addIGTVTapped(_ sender: Any) {
        guard iGTVTextField.text != "" else {
            return}
        guard iGTVTextField.text!.count > 15 else {
            mediumImpactGenerator.impactOccurred()
            Utilities.showError2("Invalid iGTV URL.", actionText: "OK")
            return}
        guard !iGTVArr.contains(iGTVTextField.text!) else {
            mediumImpactGenerator.impactOccurred()
            Utilities.showError2("URL already added.", actionText: "OK")
            return}
        iGTVArr.append(iGTVTextField.text!)
        iGTVTextField.text = ""
        iGTVAddButton.isHidden = true
        iGTVTableView.reloadData()
        iGTVHeightConstraint.constant = CGFloat(50*(iGTVArr.count))
        view.endEditing(true)
    }
    
    @IBAction func addInstagramPostTapped(_ sender: Any) {
        guard instagramPostTextField.text != "" else {
            return}
        guard instagramPostTextField.text!.count > 15 else {
            mediumImpactGenerator.impactOccurred()
            Utilities.showError2("Invalid Instagram URL.", actionText: "OK")
            return}
        guard !instagramPostArr.contains(instagramPostTextField.text!) else {
            mediumImpactGenerator.impactOccurred()
            Utilities.showError2("URL already added.", actionText: "OK")
            return}
        instagramPostArr.append(instagramPostTextField.text!)
        instagramPostTextField.text = ""
        instagramPostAddButton.isHidden = true
        instagramPostTableView.reloadData()
        instagramPostHeightConstraint.constant = CGFloat(50*(instagramPostArr.count))
        view.endEditing(true)
    }
    
    @IBAction func addFacebookPostTapped(_ sender: Any) {
        guard facebookPostTextField.text != "" else {
            return}
        guard facebookPostTextField.text!.count > 15 else {
            mediumImpactGenerator.impactOccurred()
            Utilities.showError2("Invalid Facebook URL.", actionText: "OK")
            return}
        guard !facebookPostArr.contains(facebookPostTextField.text!) else {
            mediumImpactGenerator.impactOccurred()
            Utilities.showError2("URL already added.", actionText: "OK")
            return}
        facebookPostArr.append(facebookPostTextField.text!)
        facebookPostTextField.text = ""
        facebookAddButton.isHidden = true
        facebookPostTableView.reloadData()
        facebookHeightConstraint.constant = CGFloat(50*(facebookPostArr.count))
        view.endEditing(true)
    }
    
    @IBAction func addWorldstarTapped(_ sender: Any) {
        guard worldstarTextField.text != "" else {
            return}
        guard worldstarTextField.text!.count > 15 else {
            mediumImpactGenerator.impactOccurred()
            Utilities.showError2("Invalid Worldstar URL.", actionText: "OK")
            return}
        guard !worldstarArr.contains(worldstarTextField.text!) else {
            mediumImpactGenerator.impactOccurred()
            Utilities.showError2("URL already added.", actionText: "OK")
            return}
        worldstarArr.append(worldstarTextField.text!)
        worldstarTextField.text = ""
        worldstarAddButton.isHidden = true
        worldstarTableView.reloadData()
        worldstarHeightConstraint.constant = CGFloat(50*(worldstarArr.count))
        view.endEditing(true)
    }
    
    @IBAction func addAppleMusicTapped(_ sender: Any) {
        guard appleMusicTextField.text != "" else {
            return}
        guard appleMusicTextField.text!.count > 15 else {
            mediumImpactGenerator.impactOccurred()
            Utilities.showError2("Invalid Apple Music URL.", actionText: "OK")
            return}
        guard !appleMusicArr.contains(appleMusicTextField.text!) else {
            mediumImpactGenerator.impactOccurred()
            Utilities.showError2("URL already added.", actionText: "OK")
            return}
        appleMusicArr.append(appleMusicTextField.text!)
        appleMusicTextField.text = ""
        appleMusicAddButton.isHidden = true
        appleMusicTableView.reloadData()
        appleMusicHeightConstraint.constant = CGFloat(50*(appleMusicArr.count))
        view.endEditing(true)
    }
    
    @IBAction func addTwitterTapped(_ sender: Any) {
        guard twitterTextField.text != "" else {
            return}
        guard twitterTextField.text!.count > 15 else {
            mediumImpactGenerator.impactOccurred()
            Utilities.showError2("Invalid Twitter URL.", actionText: "OK")
            return}
        guard !twitterArr.contains(twitterTextField.text!) else {
            mediumImpactGenerator.impactOccurred()
            Utilities.showError2("URL already added.", actionText: "OK")
            return}
        twitterArr.append(twitterTextField.text!)
        twitterTextField.text = ""
        twitterAddButton.isHidden = true
        twitterTableView.reloadData()
        twitterHeightConstraint.constant = CGFloat(50*(twitterArr.count))
        view.endEditing(true)
    }
    
    @IBAction func addTikTokTapped(_ sender: Any) {
        guard tikTokTextField.text != "" else {
            return}
        guard tikTokTextField.text!.count > 15 else {
            Utilities.showError2("Invalid Tik Tok URL.", actionText: "OK")
            return}
        guard !tikTokArr.contains(tikTokTextField.text!) else {
            mediumImpactGenerator.impactOccurred()
            Utilities.showError2("URL already added.", actionText: "OK")
            return}
        tikTokArr.append(tikTokTextField.text!)
        tikTokTextField.text = ""
        tikTokAddButton.isHidden = true
        tikTokTableView.reloadData()
        tikTokHeightConstraint.constant = CGFloat(50*(tikTokArr.count))
        view.endEditing(true)
    }
    
    @IBAction func industryCertificationChanged(_ sender: Any) {
        lightImpactGenerator.impactOccurred(intensity: 0.75)
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
    
    func addBottomLineToText(_ textfield:UITextField) {
        let bottomLine = CALayer()

        bottomLine.frame = CGRect(x: 0,
                                  y: textfield.frame.height - 1,
                                  width: textfield.frame.size.width - 40,//textfield.frame.width,
                                  height: 2)

        bottomLine.backgroundColor = UIColor.init(red: 182/255, green: 0/255, blue: 3/255, alpha: 0.87).cgColor

        textfield.layer.addSublayer(bottomLine)
    }
    
    
    //MARK: - Upload Sequence
    
    @IBAction func uploadButtonTapped(_ sender: Any) {
        uploadVideo()
    }
    
    func uploadVideo() {
        guard nameTextField.text != "" else {
            mediumImpactGenerator.impactOccurred()
            Utilities.showError2("Video name required.", actionText: "OK")
            return}
        
        guard chosenType != nil && chosenType != "" else {
            mediumImpactGenerator.impactOccurred()
            Utilities.showError2("Video type required.", actionText: "OK")
            return}
        guard verificationLevelTextField.text != "" else {
            mediumImpactGenerator.impactOccurred()
            Utilities.showError2("Verification Level required"  ,actionText: "Ok")
            return
        }
        
        date = Date()
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "HH:mm:ss a"
        timeFormatter.timeZone = TimeZone(identifier: "EDT")
        currtime = timeFormatter.string(from: date)
        
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone(identifier: "EDT")
        formatter.dateFormat = "MMMM dd, yyyy"
        currdate = formatter.string(from: date)
        
        alertView = UIAlertController(title: "Uploading \(nameTextField.text!)", message: "Preparing...", preferredStyle: .alert)
        alertView.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: {[weak self] _ in
            
        }))
        alertView.view.tintColor = Constants.Colors.redApp
        //  Show it to your users
        present(alertView, animated: true, completion: { [weak self] in
            guard let strongSelf = self else {return}
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
        alertView.message = "Creating App Id"
        let genid = StorageManager.shared.generateRandomNumber(digits: 9)
        DatabaseManager.shared.checkIfAppIdExists(appid: genid, completion: { [weak self] result in
            guard let strongSelf = self else {return}
            if result == true {
                strongSelf.generateAppId()
            } else {
                strongSelf.tDAppId = genid
                strongSelf.videoDBID = ("\(videoContentTag)--\(strongSelf.nameTextField.text!.replacingOccurrences(of: ".", with: " ").replacingOccurrences(of: "#", with: " ").replacingOccurrences(of: "$", with: " ").replacingOccurrences(of: "[", with: " ").replacingOccurrences(of: "]", with: " ").replacingOccurrences(of: ":", with: " "))--\(genid)")
                strongSelf.videoToUpload = VideoData(title: strongSelf.nameTextField.text!, toneDeafAppId: genid, persons: nil, videographers: nil, albums: nil, instrumentals: nil, merch: nil, songs: nil, beats: nil, favorites: 0, type: "", timeIA: "", dateIA: "", viewsIA: 0, manualThumbnailURL: nil, isActive: false, youtube: nil, igtv: nil, instagramPost: nil, facebookPost: nil, worldstar: nil, twitter: nil, appleMusic: nil, tikTok: nil, industryCerified: nil, verificationLevel: nil)
                strongSelf.progressCompleted+=1
                DispatchQueue.main.async {
                    strongSelf.progressView.progress = (strongSelf.progressCompleted/strongSelf.totalProgress)
                    print("\(strongSelf.progressCompleted) out of \(strongSelf.totalProgress)")
                    
                }
                strongSelf.gatherUploadData()
            }
        })
    }
    
    func gatherUploadData() {
        
        var uploadDataArray:[String] = []
        let vidzqueue = DispatchQueue(label: "myhjvideoshjfktyhdikhQueue")
        let vidzgroup = DispatchGroup()
        var array:[Int] = []
        if youtubeArr.count > 0 {
            totalProgress += Float(youtubeArr.count*2)
            array.append(1)
        }
        if iGTVArr.count > 0 {
            totalProgress += Float(iGTVArr.count*2)
            array.append(2)
        }
        if instagramPostArr.count > 0 {
            totalProgress += Float(instagramPostArr.count*2)
            array.append(3)
        }
        if facebookPostArr.count > 0 {
            totalProgress += Float(facebookPostArr.count*2)
            array.append(4)
        }
        if worldstarArr.count > 0 {
            totalProgress += Float(worldstarArr.count*2)
            array.append(5)
        }
        if twitterArr.count > 0 {
            totalProgress += Float(twitterArr.count*2)
            array.append(6)
        }
        if appleMusicArr.count > 0 {
            totalProgress += Float(appleMusicArr.count*2)
            array.append(7)
        }
        if tikTokArr.count > 0 {
            totalProgress += Float(tikTokArr.count*2)
            array.append(8)
        }
        for i in array {
            vidzgroup.enter()
            vidzqueue.async { [weak self] in
                guard let strongSelf = self else {return}
                switch i {
                case 1:
                    strongSelf.videouploadCompletionStatus1 = false
                    strongSelf.youtubeData(completion: { error,done in
                        if done == false {
                            guard let error = error else {return}
                            Utilities.showError2("Youtube  Video upload Failed: \(error)", actionText: "OK")
                            mediumImpactGenerator.impactOccurred()
                            strongSelf.videouploadCompletionStatus1 = false
                        }
                        else {
                            
                            uploadDataArray.append("YT")
                            strongSelf.videouploadCompletionStatus1 = true
                            print("video Youtube graphing done \(i)")
                        }
                        vidzgroup.leave()
                    })
                case 2:
                    strongSelf.videouploadCompletionStatus2 = false
                    strongSelf.iGTVData(completion: { error,done in
                        if done == false {
                            guard let error = error else {return}
                            Utilities.showError2("IGTV  Video upload Failed: \(error)", actionText: "OK")
                            mediumImpactGenerator.impactOccurred()
                            strongSelf.videouploadCompletionStatus2 = false
                        }
                        else {
                            
                            uploadDataArray.append("IGTV")
                            strongSelf.videouploadCompletionStatus2 = true
                            print("video IGTV graphing done \(i)")
                        }
                        vidzgroup.leave()
                    })
                case 3:
                    strongSelf.videouploadCompletionStatus3 = false
                    strongSelf.instagramPostData(completion: { error,done in
                        if done == false {
                            guard let error = error else {return}
                            Utilities.showError2("Instagram Post Video upload Failed: \(error)", actionText: "OK")
                            mediumImpactGenerator.impactOccurred()
                            strongSelf.videouploadCompletionStatus3 = false
                        }
                        else {
                            uploadDataArray.append("INST")
                            strongSelf.videouploadCompletionStatus3 = true
                            print("video Instagram Post graphing done \(i)")
                        }
                        vidzgroup.leave()
                    })
                case 4:
                    strongSelf.videouploadCompletionStatus4 = false
                    strongSelf.facebookPostData(completion: { error,done in
                        if done == false {
                            guard let error = error else {return}
                            Utilities.showError2("Facebook Post Video upload Failed: \(error)", actionText: "OK")
                            mediumImpactGenerator.impactOccurred()
                            strongSelf.videouploadCompletionStatus4 = false
                        }
                        else {
                            uploadDataArray.append("FACE")
                            strongSelf.videouploadCompletionStatus4 = true
                            print("video Facebook Post graphing done \(i)")
                        }
                        vidzgroup.leave()
                    })
                case 5:
                    strongSelf.videouploadCompletionStatus5 = false
                    strongSelf.worldstarData(completion: { error,done in
                        if done == false {
                            guard let error = error else {return}
                            Utilities.showError2("Worldstar Video upload Failed: \(error)", actionText: "OK")
                            mediumImpactGenerator.impactOccurred()
                            strongSelf.videouploadCompletionStatus5 = false
                        }
                        else {
                            uploadDataArray.append("WDST")
                            strongSelf.videouploadCompletionStatus5 = true
                            print("video Worldstar graphing done \(i)")
                        }
                        vidzgroup.leave()
                    })
                case 6:
                    strongSelf.videouploadCompletionStatus6 = false
                    strongSelf.twitterData(completion: { error,done in
                        if done == false {
                            guard let error = error else {return}
                            Utilities.showError2("Twitter  Video upload Failed: \(error)", actionText: "OK")
                            mediumImpactGenerator.impactOccurred()
                            strongSelf.videouploadCompletionStatus6 = false
                        }
                        else {
                            
                            uploadDataArray.append("TWIT")
                            strongSelf.videouploadCompletionStatus6 = true
                            print("video Twitter graphing done \(i)")
                        }
                        vidzgroup.leave()
                    })
                case 7:
                    strongSelf.videouploadCompletionStatus7 = false
                    strongSelf.appleMusicData(completion: { error,done in
                        if done == false {
                            guard let error = error else {return}
                            Utilities.showError2("Apple Music Video upload Failed: \(error)", actionText: "OK")
                            mediumImpactGenerator.impactOccurred()
                            strongSelf.videouploadCompletionStatus7 = false
                        }
                        else {
                            
                            uploadDataArray.append("APPL")
                            strongSelf.videouploadCompletionStatus7 = true
                            print("video Apple Music graphing done \(i)")
                        }
                        vidzgroup.leave()
                    })
                case 8:
                    strongSelf.videouploadCompletionStatus8 = false
                    strongSelf.tikTokData(completion: { error,done in
                        if done == false {
                            guard let error = error else {return}
                            Utilities.showError2("Tik Tok Video upload Failed: \(error)", actionText: "OK")
                            mediumImpactGenerator.impactOccurred()
                            strongSelf.videouploadCompletionStatus8 = false
                        }
                        else {
                            uploadDataArray.append("TKTK")
                            strongSelf.videouploadCompletionStatus8 = true
                            print("video Tik Tok graphing done \(i)")
                        }
                        vidzgroup.leave()
                    })
                default:
                    print("video oopsie")
                }
                
            }
            
        }
        vidzgroup.notify(queue: DispatchQueue.main) {[weak self] in
            guard let strongSelf = self else {return}
            if strongSelf.videouploadCompletionStatus1 == false ||  strongSelf.videouploadCompletionStatus2 == false ||  strongSelf.videouploadCompletionStatus3 == false ||  strongSelf.videouploadCompletionStatus4 == false ||  strongSelf.videouploadCompletionStatus5 == false ||  strongSelf.videouploadCompletionStatus6 == false || strongSelf.videouploadCompletionStatus7 == false || strongSelf.videouploadCompletionStatus8 == false {
                
                Utilities.showError2("Upload Failed.", actionText: "OK")
                return
            } else {
                strongSelf.storeUploadData(uploadArr: uploadDataArray)
            }
        }
    }
    
    func storeUploadData(uploadArr: [String]) {
        var uploadDataArray:[String] = uploadArr
        let storevidzqueue = DispatchQueue(label: "myhjstorevideoshjfktyhdikhQueue")
        let storevidzgroup = DispatchGroup()
        uploadDataArray.append("All Content IDs")
        uploadDataArray.append("All Video IDs")
        if videographerArr.count > 0 {
            totalProgress += Float(videographerArr.count*2)
            uploadDataArray.append("Videographer")
            uploadDataArray.append("vRoles")
        }
        if personArr.count > 0 {
            totalProgress += Float(personArr.count)
            uploadDataArray.append("Person")
        }
        if songArr.count > 0 {
            totalProgress += Float(songArr.count)
            uploadDataArray.append("Song")
        }
        if albumArr.count > 0 {
            totalProgress += Float(albumArr.count)
            uploadDataArray.append("Album")
        }
        if instrumentalArr.count > 0 {
            totalProgress += Float(instrumentalArr.count)
            uploadDataArray.append("Instrumental")
        }
        if beatArr.count > 0 {
            totalProgress += Float(beatArr.count)
            uploadDataArray.append("Beat")
        }
        
        for i in uploadDataArray {
            storevidzgroup.enter()
            storevidzqueue.async { [weak self] in
                guard let strongSelf = self else {return}
                switch i {
                case "YT":
                    strongSelf.videouploadCompletionStatus9 = false
                    strongSelf.youtubeStore(data: strongSelf.videoToUpload.youtube!, completion: { error,done in
                        if done == false {
                            guard let error = error else {return}
                            Utilities.showError2("Store Youtube Video upload Failed: \(error)", actionText: "OK")
                            mediumImpactGenerator.impactOccurred()
                            strongSelf.videouploadCompletionStatus9 = false
                        }
                        else {
                            strongSelf.videouploadCompletionStatus9 = true
                            print("video Youtube storing done \(i)")
                        }
                        storevidzgroup.leave()
                    })
                case "IGTV":
                    strongSelf.videouploadCompletionStatus10 = false
                    strongSelf.iGTVStore(data: strongSelf.videoToUpload.igtv!, completion: { error,done in
                        if done == false {
                            guard let error = error else {return}
                            Utilities.showError2("Store IGTV Video upload Failed: \(error)", actionText: "OK")
                            mediumImpactGenerator.impactOccurred()
                            strongSelf.videouploadCompletionStatus10 = false
                        }
                        else {
                            strongSelf.videouploadCompletionStatus10 = true
                            print("video IGTV storing done \(i)")
                        }
                        storevidzgroup.leave()
                    })
                case "INST":
                    strongSelf.videouploadCompletionStatus11 = false
                    strongSelf.instagramPostStore(data: strongSelf.videoToUpload.instagramPost!, completion: { error,done in
                        if done == false {
                            guard let error = error else {return}
                            Utilities.showError2("Store Instagram Post Video upload Failed: \(error)", actionText: "OK")
                            mediumImpactGenerator.impactOccurred()
                            strongSelf.videouploadCompletionStatus11 = false
                        }
                        else {
                            strongSelf.videouploadCompletionStatus11 = true
                            print("video Instagram Post storing done \(i)")
                        }
                        storevidzgroup.leave()
                    })
                case "FACE":
                    strongSelf.videouploadCompletionStatus12 = false
                    strongSelf.facebookPostStore(data: strongSelf.videoToUpload.facebookPost!, completion: { error,done in
                        if done == false {
                            guard let error = error else {return}
                            Utilities.showError2("Store Facebook Post Video upload Failed: \(error)", actionText: "OK")
                            mediumImpactGenerator.impactOccurred()
                            strongSelf.videouploadCompletionStatus12 = false
                        }
                        else {
                            strongSelf.videouploadCompletionStatus12 = true
                            print("video Facebook Post storing done \(i)")
                        }
                        storevidzgroup.leave()
                    })
                case "WDST":
                    strongSelf.videouploadCompletionStatus13 = false
                    strongSelf.worldstarStore(data: strongSelf.videoToUpload.worldstar!, completion: { error,done in
                        if done == false {
                            guard let error = error else {return}
                            Utilities.showError2("Store Worldstar Video upload Failed: \(error)", actionText: "OK")
                            mediumImpactGenerator.impactOccurred()
                            strongSelf.videouploadCompletionStatus13 = false
                        }
                        else {
                            strongSelf.videouploadCompletionStatus13 = true
                            print("video Worldstar storing done \(i)")
                        }
                        storevidzgroup.leave()
                    })
                case "TWIT":
                    strongSelf.videouploadCompletionStatus14 = false
                    strongSelf.twitterStore(data: strongSelf.videoToUpload.twitter!, completion: { error,done in
                        if done == false {
                            guard let error = error else {return}
                            Utilities.showError2("Store Twitter Video upload Failed: \(error)", actionText: "OK")
                            mediumImpactGenerator.impactOccurred()
                            strongSelf.videouploadCompletionStatus14 = false
                        }
                        else {
                            strongSelf.videouploadCompletionStatus14 = true
                            print("video Twitter storing done \(i)")
                        }
                        storevidzgroup.leave()
                    })
                case "APPL":
                    strongSelf.videouploadCompletionStatus15 = false
                    strongSelf.appleMusicStore(data: strongSelf.videoToUpload.appleMusic!, completion: { error,done in
                        if done == false {
                            guard let error = error else {return}
                            Utilities.showError2("Store Apple Music Video upload Failed: \(error)", actionText: "OK")
                            mediumImpactGenerator.impactOccurred()
                            strongSelf.videouploadCompletionStatus15 = false
                        }
                        else {
                            strongSelf.videouploadCompletionStatus15 = true
                            print("video Apple Music storing done \(i)")
                        }
                        storevidzgroup.leave()
                    })
                case "TKTK":
                    strongSelf.videouploadCompletionStatus16 = false
                    strongSelf.tikTokStore(data: strongSelf.videoToUpload.tikTok!, completion: { error,done in
                        if done == false {
                            guard let error = error else {return}
                            Utilities.showError2("Store Tik Tok Video upload Failed: \(error)", actionText: "OK")
                            mediumImpactGenerator.impactOccurred()
                            strongSelf.videouploadCompletionStatus16 = false
                        }
                        else {
                            strongSelf.videouploadCompletionStatus16 = true
                            print("video Tik Tok storing done \(i)")
                        }
                        storevidzgroup.leave()
                    })
                case "Videographer":
                    strongSelf.videouploadCompletionStatus17 = false
                    strongSelf.storeVideographers(data: strongSelf.videographerArr, completion: { error,done in
                        if done == false {
                            guard let error = error else {return}
                            Utilities.showError2("videographer storing Failed: \(error)", actionText: "OK")
                            mediumImpactGenerator.impactOccurred()
                            strongSelf.videouploadCompletionStatus17 = false
                        }
                        else {
                            strongSelf.videouploadCompletionStatus17 = true
                            print("videographer storing done \(i)")
                        }
                        storevidzgroup.leave()
                    })
                case "vRoles":
                    strongSelf.videouploadCompletionStatus18 = false
                    strongSelf.storeVideographerRoles(data: strongSelf.videographerArr, completion: { error,done in
                        
                        if done == false {
                            guard let error = error else {return}
                            Utilities.showError2("videographer role storing Failed: \(error)", actionText: "OK")
                            mediumImpactGenerator.impactOccurred()
                            strongSelf.videouploadCompletionStatus18 = false
                        }
                        else {
                            strongSelf.videouploadCompletionStatus18 = true
                            print("videographer role storing done \(i)")
                        }
                        storevidzgroup.leave()
                    })
                case "Person":
                    strongSelf.videouploadCompletionStatus19 = false
                    strongSelf.storePersons(data: strongSelf.personArr, completion: { error,done in
                        if done == false {
                            guard let error = error else {return}
                            
                            Utilities.showError2("person storing Failed: \(error)", actionText: "OK")
                            mediumImpactGenerator.impactOccurred()
                            strongSelf.videouploadCompletionStatus19 = false
                        }
                        else {
                            strongSelf.videouploadCompletionStatus19 = true
                            print("person storing done \(i)")
                        }
                        storevidzgroup.leave()
                    })
                case "Album":
                    strongSelf.videouploadCompletionStatus20 = false
                    strongSelf.storeAlbums(data: strongSelf.albumArr, completion: { error,done in
                        if done == false {
                            guard let error = error else {return}
                            
                            Utilities.showError2("album storing Failed: \(error)", actionText: "OK")
                            mediumImpactGenerator.impactOccurred()
                            strongSelf.videouploadCompletionStatus20 = false
                        }
                        else {
                            strongSelf.videouploadCompletionStatus20 = true
                            print("album storing done \(i)")
                        }
                        storevidzgroup.leave()
                    })
                case "Song":
                    strongSelf.videouploadCompletionStatus21 = false
                    strongSelf.storeSongs(data: strongSelf.songArr, completion: { error,done in
                        if done == false {
                            guard let error = error else {return}
                            
                            Utilities.showError2("song storing Failed: \(error)", actionText: "OK")
                            mediumImpactGenerator.impactOccurred()
                            strongSelf.videouploadCompletionStatus21 = false
                        }
                        else {
                            strongSelf.videouploadCompletionStatus21 = true
                            print("song storing done \(i)")
                        }
                        storevidzgroup.leave()
                    })
                case "All Content IDs":
                    strongSelf.videouploadCompletionStatus24 = false
                    strongSelf.updateAllContentIDs(completion: { error,done in
                        if done == false {
                            guard let error = error else {return}
                            
                            Utilities.showError2("all Content ID storing Failed: \(error)", actionText: "OK")
                            mediumImpactGenerator.impactOccurred()
                            strongSelf.videouploadCompletionStatus24 = false
                        }
                        else {
                            strongSelf.videouploadCompletionStatus24 = true
                            print("all content ID storing done \(i)")
                        }
                        storevidzgroup.leave()
                    })
                case "All Video IDs":
                    strongSelf.videouploadCompletionStatus25 = false
                    strongSelf.updateAllVideoIDs(completion: { error,done in
                        if done == false {
                            guard let error = error else {return}
                            
                            Utilities.showError2("all Video ID storing Failed: \(error)", actionText: "OK")
                            mediumImpactGenerator.impactOccurred()
                            strongSelf.videouploadCompletionStatus25 = false
                        }
                        else {
                            strongSelf.videouploadCompletionStatus25 = true
                            print("all Video ID storing done \(i)")
                        }
                        storevidzgroup.leave()
                    })
                
                default:
                    print("video oopsie")
                }
                
            }
            
        }
        storevidzgroup.notify(queue: DispatchQueue.main) {[weak self] in
            guard let strongSelf = self else {return}
            if strongSelf.videouploadCompletionStatus9 == false ||  strongSelf.videouploadCompletionStatus10 == false ||  strongSelf.videouploadCompletionStatus11 == false ||  strongSelf.videouploadCompletionStatus12 == false ||  strongSelf.videouploadCompletionStatus13 == false ||  strongSelf.videouploadCompletionStatus14 == false || strongSelf.videouploadCompletionStatus15 == false || strongSelf.videouploadCompletionStatus16 == false || strongSelf.videouploadCompletionStatus17 == false || strongSelf.videouploadCompletionStatus18 == false ||  strongSelf.videouploadCompletionStatus19 == false ||  strongSelf.videouploadCompletionStatus20 == false || strongSelf.videouploadCompletionStatus21 == false || strongSelf.videouploadCompletionStatus22 == false || strongSelf.videouploadCompletionStatus23 == false || strongSelf.videouploadCompletionStatus24 == false || strongSelf.videouploadCompletionStatus25 == false {
                Utilities.showError2("Upload Failed.", actionText: "OK")
                return
            } else {
                strongSelf.alertView.dismiss(animated: true, completion: {
                    Utilities.successBarBanner("Upload successful.")
                    _ = strongSelf.navigationController?.popViewController(animated: true)
                })
            }
        }
    }
    
    //MARK: - All IDs Store
    func updateAllContentIDs(completion: @escaping (Error?, Bool) -> Void) {
            Database.database().reference().child("All Content IDs").observeSingleEvent(of: .value, with: {[weak self] snap in
                guard let strongSelf = self else {return}
                if !(snap.value is NSNull) {
                    var arr = snap.value as! [String]
                    arr.append("\(strongSelf.videoToUpload.toneDeafAppId)")
                    Database.database().reference().child("All Content IDs").setValue(arr)
                    completion(nil,true)
                }
                else {
                    let arr = ["\(strongSelf.videoToUpload.toneDeafAppId)"]
                    Database.database().reference().child("All Content IDs").setValue(arr)
                    completion(nil,true)
                    return
                }
            })
    }
    
    func updateAllVideoIDs(completion: @escaping (Error?, Bool) -> Void) {
        Database.database().reference().child("Music Content").child("Videos").child("All Video IDs").observeSingleEvent(of: .value, with: {[weak self] snap in
                guard let strongSelf = self else {return}
                if !(snap.value is NSNull) {
                    var arr = snap.value as! [String]
                    arr.append("\(strongSelf.videoToUpload.toneDeafAppId)")
                    Database.database().reference().child("Music Content").child("Videos").child("All Video IDs").setValue(arr)
                    completion(nil,true)
                }
                else {
                    let arr = ["\(strongSelf.videoToUpload.toneDeafAppId)"]
                    Database.database().reference().child("Music Content").child("Videos").child("All Video IDs").setValue(arr)
                    completion(nil,true)
                    return
                }
            })
    }
    
    //MARK: - Youtube
    func youtubeData(completion: @escaping (Error?, Bool) -> Void) {
        videoToUpload.youtube = []
        DispatchQueue.main.async {[weak self] in
            guard let strongSelf = self else {return}
            strongSelf.alertView.message = "Gathering Youtube"
        }
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let strongSelf = self else {return}
            var count = 0
            for obj in strongSelf.youtubeArr {
                if count != 0 {
                    sleep(1)
                }
                count+=1
                DispatchQueue.main.async {[weak self] in
                    guard let strongSelf = self else {return}
                    strongSelf.alertView.message = "Gathering Youtube \(count)"
                }
                strongSelf.handleYoutube(urlString: obj, completion: { err, result in
                    if count == strongSelf.youtubeArr.count {
                        if result == true {
                            completion(nil,true)
                        } else {
                            completion(err,false)
                        }
                    }
                    strongSelf.progressCompleted+=1
                    DispatchQueue.main.async {
                        strongSelf.progressView.progress = (strongSelf.progressCompleted/strongSelf.totalProgress)
                        print("\(strongSelf.progressCompleted) out of \(strongSelf.totalProgress)")
                        
                    }
                    DispatchQueue.global(qos: .userInitiated).async {
                        strongSelf.ytsemaphore.signal()
                    }
                })
                strongSelf.ytsemaphore.wait()
            }
        }
    }
    
    func handleYoutube(urlString: String, completion: @escaping (Error?, Bool) -> Void) {
        DispatchQueue.main.async {[weak self] in
            guard let strongSelf = self else {return}
            var url = urlString
            var videoId = ""
            if !url.contains("playlist") {
                if url.contains("youtu.be/") {
                    videoId = String((url.suffix(11)))
                } else
                if url.contains("watch?v=") {
                    if let range = url.range(of: "=") {
                        url.removeSubrange(url.startIndex..<range.lowerBound)
                    }
                    videoId = String(url.dropFirst())
                    videoId = String(videoId.prefix(11))
                    
                }
                else {
                    mediumImpactGenerator.impactOccurred()
                    Utilities.showError2("Youtube url parsing error", actionText: "OK")
                    completion(VideoUploadErrors.youtubeURLParse, false)
                    return
                }
                YoutubeRequest.shared.getVideos(videoId: videoId, url: url, tdAppId: strongSelf.tDAppId, completion: { result in
                    switch result {
                    case.success(let video):
                        strongSelf.videoToUpload.youtube!.append(video)
                        completion(nil,true)
                    case .failure(let error):
                        completion(error,false)
                    }
                })
            } else {
                if url.contains("playlist?list=") {
                    if let range = url.range(of: "=") {
                        url.removeSubrange(url.startIndex..<range.lowerBound)
                    }
                    videoId = String(url.dropFirst())
                    
                }
                YoutubeRequest.shared.getVideos(playlistId: videoId, url: url, tdAppId: strongSelf.tDAppId, completion: { result in
                    switch result {
                    case.success(let video):
                        strongSelf.videoToUpload.youtube!.append(video)
                        completion(nil,true)
                    case .failure(let error):
                        completion(error,false)
                    }
                })
            }
        }
    }
    
    func youtubeStore(data: [YouTubeData], completion: @escaping (Error?, Bool) -> Void) {
        DispatchQueue.main.async {[weak self] in
            guard let strongSelf = self else {return}
            strongSelf.alertView.message = "Storing Youtube"
        }
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let strongSelf = self else {return}
            var count = 0
            for obj in data {
                if count != 0 {
                    sleep(1)
                }
                count+=1
                DispatchQueue.main.async {[weak self] in
                    guard let strongSelf = self else {return}
                    strongSelf.alertView.message = "Storing Youtube \(count)"
                }
                strongSelf.youtubeCompleteStore(viddata: obj, completion: { err, result in
                    if count == data.count {
                        if result == true {
                            completion(nil,true)
                        } else {
                            completion(err,false)
                        }
                    }
                    strongSelf.progressCompleted+=1
                    DispatchQueue.main.async {
                        strongSelf.progressView.progress = (strongSelf.progressCompleted/strongSelf.totalProgress)
                        print("\(strongSelf.progressCompleted) out of \(strongSelf.totalProgress)")
                        
                    }
                    DispatchQueue.global(qos: .userInitiated).async {
                        strongSelf.ytstoresemaphore.signal()
                    }
                })
                strongSelf.ytstoresemaphore.wait()
            }
        }
    }
    
    func youtubeCompleteStore(viddata: YouTubeData, completion: @escaping (Error?, Bool) -> Void) {
        let data = viddata
        var ytContentKey:String!
        switch chosenType {
        case "Music Video":
            ytContentKey = youtubeVideoContentTyp
        case "Audio Video":
            ytContentKey = youtubeAudioVideoContentType
        case "Playlist":
            ytContentKey = youtubePlaylistContentType
        default:
            ytContentKey = youtubeAltVideoContentType
        }
        
        
        let ytContentRandomKey = ("\(ytContentKey!)--\(data.title.replacingOccurrences(of: ".", with: " ").replacingOccurrences(of: "#", with: " ").replacingOccurrences(of: "$", with: " ").replacingOccurrences(of: "[", with: " ").replacingOccurrences(of: "]", with: " ").replacingOccurrences(of: ":", with: " "))--\(data.url.replacingOccurrences(of: "/", with: "").replacingOccurrences(of: ".", with: "").replacingOccurrences(of: "#", with: "").replacingOccurrences(of: "$", with: "").suffix(10))--\(videoToUpload.toneDeafAppId)")
        
        let VideoRef = Database.database().reference().child("Music Content").child("Videos").child(videoDBID).child("Youtube").child(ytContentRandomKey)
        
        var VideoInfoMap = [String : Any]()
        VideoInfoMap = [
            "Title" : videoToUpload.title,
            "Tone Deaf App Video Id": videoToUpload.toneDeafAppId,
            "Time Uploaded To App" : currtime,
            "Date Uploaded To App" : currdate,
            "Views In App" : data.viewsIA,
            "Number of Favorites" : 0,
            "Type": chosenType!,
            "Verification Level": String(verificationLevel),
            "Industry Certified": industryCertified,
            "Active Status" : false
        ]
        
        let videoRef = Database.database().reference().child("Music Content").child("Videos").child(videoDBID)
        
        videoRef.updateChildValues(VideoInfoMap) { [weak self] (error, videoRef) in
            guard let strongSelf = self else {return}
            if let error = error {
                print("📕 Failed to upload youtube video dictionary to database: \(error)")
                return
            }
        }
        
        var YTInfoMap = [String : Any]()
        YTInfoMap = [
            "Title" : data.title,
            "Tone Deaf App Video Id": data.toneDeafAppId,
            "Date Uploaded To Youtube" : data.dateYT,
            "Time Uploaded To Youtube" : data.timeYT,
            "Time Uploaded To App" : currtime,
            "Date Uploaded To App" : currdate,
            "Channel Title" : data.channelTitle,
            "Description" : data.description,
            "Duration": data.duration,
            "Thumbnail URL" : data.thumbnailURL,
            "Video URL" : data.url,
            "Views In App" : data.viewsIA,
            "Views on Youtube" : data.viewsYT,
            "Number of Favorites" : 0,
            "Youtube Id" : data.youtubeId,
            "Type": ytContentKey,
            "Active Status": false]
        
        VideoRef.updateChildValues(YTInfoMap) { [weak self] (error, albumRef) in
            guard let strongSelf = self else {return}
            if let error = error {
                print("📕 Failed to store Youtube dictionary to database: \(error)")
                Utilities.showError2("Failed to Store Youtube. Please try again.", actionText: "OK")
                completion(error, false)
                return
            } else {
                //print("📗 Youtube data for \(strongSelf.videoToUpload.title) saved to database successfully.")
                completion(nil, true)
                return
            }
        }
    }
    
    //MARK: - IGTV
    func iGTVData(completion: @escaping (Error?, Bool) -> Void) {
        videoToUpload.igtv = []
        DispatchQueue.main.async {[weak self] in
            guard let strongSelf = self else {return}
            strongSelf.alertView.message = "Gathering IGTV"
        }
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let strongSelf = self else {return}
            var count = 0
            for obj in strongSelf.iGTVArr {
                if count != 0 {
                    sleep(1)
                }
                count+=1
                DispatchQueue.main.async {[weak self] in
                    guard let strongSelf = self else {return}
                    strongSelf.alertView.message = "Gathering IGTV \(count)"
                }
                strongSelf.handleIGTV(urlString: obj, completion: { err, result in
                    if count == strongSelf.iGTVArr.count {
                        if result == true {
                            completion(nil,true)
                        } else {
                            completion(err,false)
                        }
                    }
                    strongSelf.progressCompleted+=1
                    DispatchQueue.main.async {
                        strongSelf.progressView.progress = (strongSelf.progressCompleted/strongSelf.totalProgress)
                        print("\(strongSelf.progressCompleted) out of \(strongSelf.totalProgress)")
                        
                    }
                    DispatchQueue.global(qos: .userInitiated).async {
                        strongSelf.igtvsemaphore.signal()
                    }
                })
                strongSelf.igtvsemaphore.wait()
            }
        }
    }
    
    func handleIGTV(urlString: String, completion: @escaping (Error?, Bool) -> Void) {
        DispatchQueue.main.async {[weak self] in
            guard let strongSelf = self else {return}
            let video = IGTVData(url: urlString, dateIA: "", timeIa: "", isActive: false)
            strongSelf.videoToUpload.igtv!.append(video)
            completion(nil,true)
        }
    }
    
    func iGTVStore(data: [IGTVData], completion: @escaping (Error?, Bool) -> Void) {
        DispatchQueue.main.async {[weak self] in
            guard let strongSelf = self else {return}
            strongSelf.alertView.message = "Storing IGTV"
        }
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let strongSelf = self else {return}
            var count = 0
            for obj in data {
                if count != 0 {
                    sleep(1)
                }
                count+=1
                DispatchQueue.main.async {[weak self] in
                    guard let strongSelf = self else {return}
                    strongSelf.alertView.message = "Storing IGTV \(count)"
                }
                strongSelf.iGTVCompleteStore(data: obj, completion: { err, result in
                    if count == data.count {
                        if result == true {
                            completion(nil,true)
                        } else {
                            completion(err,false)
                        }
                    }
                    strongSelf.progressCompleted+=1
                    DispatchQueue.main.async {
                        strongSelf.progressView.progress = (strongSelf.progressCompleted/strongSelf.totalProgress)
                        print("\(strongSelf.progressCompleted) out of \(strongSelf.totalProgress)")
                        
                    }
                    DispatchQueue.global(qos: .userInitiated).async {
                        strongSelf.igtvstoresemaphore.signal()
                    }
                })
                strongSelf.igtvstoresemaphore.wait()
            }
        }
    }
    
    func iGTVCompleteStore(data: IGTVData, completion: @escaping (Error?, Bool) -> Void) {
        
        let contentRandomKey = ("\(iGTVVideoContentTag)--\(videoToUpload.title.replacingOccurrences(of: ".", with: " ").replacingOccurrences(of: "#", with: " ").replacingOccurrences(of: "$", with: " ").replacingOccurrences(of: "[", with: " ").replacingOccurrences(of: "]", with: " ").replacingOccurrences(of: ":", with: " "))--\(data.url.replacingOccurrences(of: "/", with: "").replacingOccurrences(of: ".", with: "").replacingOccurrences(of: "#", with: "").replacingOccurrences(of: "$", with: "").suffix(10))--\(videoToUpload.toneDeafAppId)")
        
        let VideoRef = Database.database().reference().child("Music Content").child("Videos").child(videoDBID).child("IGTV").child(contentRandomKey)
        
        var VideoInfoMap = [String : Any]()
        VideoInfoMap = [
            "Title" : videoToUpload.title,
            "Tone Deaf App Video Id": videoToUpload.toneDeafAppId,
            "Time Uploaded To App" : currtime,
            "Date Uploaded To App" : currdate,
            "Views In App" : 0,
            "Number of Favorites" : 0,
            "Type": chosenType!,
            "Verification Level": String(verificationLevel),
            "Industry Certified": industryCertified,
            "Active Status" : false
        ]
        
        let videoRef = Database.database().reference().child("Music Content").child("Videos").child(videoDBID)
        
        videoRef.updateChildValues(VideoInfoMap) { [weak self] (error, videoRef) in
            guard let strongSelf = self else {return}
            if let error = error {
                completion(error, false)
                print("📕 Failed to upload igtv video dictionary to database: \(error)")
                return
            }
        }
        
        var YTInfoMap = [String : Any]()
        YTInfoMap = [
            "Time Uploaded To App" : currtime,
            "Date Uploaded To App" : currdate,
            "Video URL" : data.url,
            "Active Status": false]
        
        VideoRef.updateChildValues(YTInfoMap) { [weak self] (error, albumRef) in
            guard let strongSelf = self else {return}
            if let error = error {
                print("📕 Failed to store IGTV dictionary to database: \(error)")
                Utilities.showError2("Failed to Store IGTV. Please try again.", actionText: "OK")
                completion(error, false)
                return
            } else {
                completion(nil, true)
                return
            }
        }
    }
    
    //MARK: - Instagram Post
    func instagramPostData(completion: @escaping (Error?, Bool) -> Void) {
        videoToUpload.instagramPost = []
        DispatchQueue.main.async {[weak self] in
            guard let strongSelf = self else {return}
            strongSelf.alertView.message = "Gathering Instagram Post"
        }
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let strongSelf = self else {return}
            var count = 0
            for obj in strongSelf.instagramPostArr {
                if count != 0 {
                    sleep(1)
                }
                count+=1
                DispatchQueue.main.async {[weak self] in
                    guard let strongSelf = self else {return}
                    strongSelf.alertView.message = "Gathering Instagram Post \(count)"
                }
                strongSelf.handleInstagramPost(urlString: obj, completion: { err, result in
                    if count == strongSelf.instagramPostArr.count {
                        if result == true {
                            completion(nil,true)
                        } else {
                            completion(err,false)
                        }
                    }
                    strongSelf.progressCompleted+=1
                    DispatchQueue.main.async {
                        strongSelf.progressView.progress = (strongSelf.progressCompleted/strongSelf.totalProgress)
                        print("\(strongSelf.progressCompleted) out of \(strongSelf.totalProgress)")
                        
                    }
                    DispatchQueue.global(qos: .userInitiated).async {
                        strongSelf.instagramPostsemaphore.signal()
                    }
                })
                strongSelf.instagramPostsemaphore.wait()
            }
        }
    }
    
    func handleInstagramPost(urlString: String, completion: @escaping (Error?, Bool) -> Void) {
        DispatchQueue.main.async {[weak self] in
            guard let strongSelf = self else {return}
            let video = InstagramPostData(url: urlString, dateIA: "", timeIa: "", isActive: false)
            strongSelf.videoToUpload.instagramPost!.append(video)
            completion(nil,true)
        }
    }
    
    func instagramPostStore(data: [InstagramPostData], completion: @escaping (Error?, Bool) -> Void) {
        DispatchQueue.main.async {[weak self] in
            guard let strongSelf = self else {return}
            strongSelf.alertView.message = "Storing Instagram Post"
        }
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let strongSelf = self else {return}
            var count = 0
            for obj in data {
                if count != 0 {
                    sleep(1)
                }
                count+=1
                DispatchQueue.main.async {[weak self] in
                    guard let strongSelf = self else {return}
                    strongSelf.alertView.message = "Storing Instagram Post \(count)"
                }
                strongSelf.instagramPostCompleteStore(data: obj, completion: { err, result in
                    if count == data.count {
                        if result == true {
                            completion(nil,true)
                        } else {
                            completion(err,false)
                        }
                    }
                    strongSelf.progressCompleted+=1
                    DispatchQueue.main.async {
                        strongSelf.progressView.progress = (strongSelf.progressCompleted/strongSelf.totalProgress)
                        print("\(strongSelf.progressCompleted) out of \(strongSelf.totalProgress)")
                        
                    }
                    DispatchQueue.global(qos: .userInitiated).async {
                        strongSelf.instagramPostsemaphore.signal()
                    }
                })
                strongSelf.instagramPostsemaphore.wait()
            }
        }
    }
    
    func instagramPostCompleteStore(data: InstagramPostData, completion: @escaping (Error?, Bool) -> Void) {
        
        let contentRandomKey = ("\(instagramPostVideoContentTag)--\(videoToUpload.title.replacingOccurrences(of: ".", with: " ").replacingOccurrences(of: "#", with: " ").replacingOccurrences(of: "$", with: " ").replacingOccurrences(of: "[", with: " ").replacingOccurrences(of: "]", with: " ").replacingOccurrences(of: ":", with: " "))--\(data.url.replacingOccurrences(of: "/", with: "").replacingOccurrences(of: ".", with: "").replacingOccurrences(of: "#", with: "").replacingOccurrences(of: "$", with: "").suffix(10))--\(videoToUpload.toneDeafAppId)")
        
        let VideoRef = Database.database().reference().child("Music Content").child("Videos").child(videoDBID).child("Instagram").child(contentRandomKey)
        
        var VideoInfoMap = [String : Any]()
        VideoInfoMap = [
            "Title" : videoToUpload.title,
            "Tone Deaf App Video Id": videoToUpload.toneDeafAppId,
            "Time Uploaded To App" : currtime,
            "Date Uploaded To App" : currdate,
            "Views In App" : 0,
            "Number of Favorites" : 0,
            "Type": chosenType!,
            "Verification Level": String(verificationLevel),
            "Industry Certified": industryCertified,
            "Active Status" : false
        ]
        
        let videoRef = Database.database().reference().child("Music Content").child("Videos").child(videoDBID)
        
        videoRef.updateChildValues(VideoInfoMap) { [weak self] (error, videoRef) in
            guard let strongSelf = self else {return}
            if let error = error {
                completion(error, false)
                print("📕 Failed to upload Instagram Post video dictionary to database: \(error)")
                return
            }
        }
        
        var YTInfoMap = [String : Any]()
        YTInfoMap = [
            "Time Uploaded To App" : currtime,
            "Date Uploaded To App" : currdate,
            "Video URL" : data.url,
            "Active Status": false]
        
        VideoRef.updateChildValues(YTInfoMap) { [weak self] (error, albumRef) in
            guard let strongSelf = self else {return}
            if let error = error {
                print("📕 Failed to store Instagram Post dictionary to database: \(error)")
                Utilities.showError2("Failed to Store Instagram Post. Please try again.", actionText: "OK")
                completion(error, false)
                return
            } else {
                completion(nil, true)
                return
            }
        }
    }
    
    //MARK: - Facebook Post
    func facebookPostData(completion: @escaping (Error?, Bool) -> Void) {
        videoToUpload.facebookPost = []
        DispatchQueue.main.async {[weak self] in
            guard let strongSelf = self else {return}
            strongSelf.alertView.message = "Gathering Facebook Post"
        }
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let strongSelf = self else {return}
            var count = 0
            for obj in strongSelf.facebookPostArr {
                if count != 0 {
                    sleep(1)
                }
                count+=1
                DispatchQueue.main.async {[weak self] in
                    guard let strongSelf = self else {return}
                    strongSelf.alertView.message = "Gathering Facebook Post \(count)"
                }
                strongSelf.handleFacebookPost(urlString: obj, completion: { err, result in
                    if count == strongSelf.facebookPostArr.count {
                        if result == true {
                            completion(nil,true)
                        } else {
                            completion(err,false)
                        }
                    }
                    strongSelf.progressCompleted+=1
                    DispatchQueue.main.async {
                        strongSelf.progressView.progress = (strongSelf.progressCompleted/strongSelf.totalProgress)
                        print("\(strongSelf.progressCompleted) out of \(strongSelf.totalProgress)")
                        
                    }
                    DispatchQueue.global(qos: .userInitiated).async {
                        strongSelf.facebooksemaphore.signal()
                    }
                })
                strongSelf.facebooksemaphore.wait()
            }
        }
    }
    
    func handleFacebookPost(urlString: String, completion: @escaping (Error?, Bool) -> Void) {
        DispatchQueue.main.async {[weak self] in
            guard let strongSelf = self else {return}
            let video = FacebookPostData(url: urlString, dateIA: "", timeIa: "", isActive: false)
            strongSelf.videoToUpload.facebookPost!.append(video)
            completion(nil,true)
        }
    }
    
    func facebookPostStore(data: [FacebookPostData], completion: @escaping (Error?, Bool) -> Void) {
        DispatchQueue.main.async {[weak self] in
            guard let strongSelf = self else {return}
            strongSelf.alertView.message = "Storing Facebook Post"
        }
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let strongSelf = self else {return}
            var count = 0
            for obj in data {
                if count != 0 {
                    sleep(1)
                }
                count+=1
                DispatchQueue.main.async {[weak self] in
                    guard let strongSelf = self else {return}
                    strongSelf.alertView.message = "Storing Facebook Post \(count)"
                }
                strongSelf.facebookPostCompleteStore(data: obj, completion: { err, result in
                    if count == data.count {
                        if result == true {
                            completion(nil,true)
                        } else {
                            completion(err,false)
                        }
                    }
                    strongSelf.progressCompleted+=1
                    DispatchQueue.main.async {
                        strongSelf.progressView.progress = (strongSelf.progressCompleted/strongSelf.totalProgress)
                        print("\(strongSelf.progressCompleted) out of \(strongSelf.totalProgress)")
                        
                    }
                    DispatchQueue.global(qos: .userInitiated).async {
                        strongSelf.facebooksemaphore.signal()
                    }
                })
                strongSelf.facebooksemaphore.wait()
            }
        }
    }
    
    func facebookPostCompleteStore(data: FacebookPostData, completion: @escaping (Error?, Bool) -> Void) {
        
        let contentRandomKey = ("\(facebookPostVideoContentTag)--\(videoToUpload.title.replacingOccurrences(of: ".", with: " ").replacingOccurrences(of: "#", with: " ").replacingOccurrences(of: "$", with: " ").replacingOccurrences(of: "[", with: " ").replacingOccurrences(of: "]", with: " ").replacingOccurrences(of: ":", with: " "))--\(data.url.replacingOccurrences(of: "/", with: "").replacingOccurrences(of: ".", with: "").replacingOccurrences(of: "#", with: "").replacingOccurrences(of: "$", with: "").suffix(10))--\(videoToUpload.toneDeafAppId)")
        
        let VideoRef = Database.database().reference().child("Music Content").child("Videos").child(videoDBID).child("Facebook").child(contentRandomKey)
        
        var VideoInfoMap = [String : Any]()
        VideoInfoMap = [
            "Title" : videoToUpload.title,
            "Tone Deaf App Video Id": videoToUpload.toneDeafAppId,
            "Time Uploaded To App" : currtime,
            "Date Uploaded To App" : currdate,
            "Views In App" : 0,
            "Number of Favorites" : 0,
            "Type": chosenType!,
            "Verification Level": String(verificationLevel),
            "Industry Certified": industryCertified,
            "Active Status" : false
        ]
        
        let videoRef = Database.database().reference().child("Music Content").child("Videos").child(videoDBID)
        
        videoRef.updateChildValues(VideoInfoMap) { [weak self] (error, videoRef) in
            guard let strongSelf = self else {return}
            if let error = error {
                completion(error, false)
                print("📕 Failed to upload Facebook Post video dictionary to database: \(error)")
                return
            }
        }
        
        var YTInfoMap = [String : Any]()
        YTInfoMap = [
            "Time Uploaded To App" : currtime,
            "Date Uploaded To App" : currdate,
            "Video URL" : data.url,
            "Active Status": false]
        
        VideoRef.updateChildValues(YTInfoMap) { [weak self] (error, albumRef) in
            guard let strongSelf = self else {return}
            if let error = error {
                print("📕 Failed to store Facebook Post dictionary to database: \(error)")
                Utilities.showError2("Failed to Store Facebook Post. Please try again.", actionText: "OK")
                completion(error, false)
                return
            } else {
                completion(nil, true)
                return
            }
        }
    }
    
    //MARK: - Worldstar
    func worldstarData(completion: @escaping (Error?, Bool) -> Void) {
        videoToUpload.worldstar = []
        DispatchQueue.main.async {[weak self] in
            guard let strongSelf = self else {return}
            strongSelf.alertView.message = "Gathering Worldstar"
        }
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let strongSelf = self else {return}
            var count = 0
            for obj in strongSelf.worldstarArr {
                if count != 0 {
                    sleep(1)
                }
                count+=1
                DispatchQueue.main.async {[weak self] in
                    guard let strongSelf = self else {return}
                    strongSelf.alertView.message = "Gathering Worldstar \(count)"
                }
                strongSelf.handleWorldstar(urlString: obj, completion: { err, result in
                    if count == strongSelf.worldstarArr.count {
                        if result == true {
                            completion(nil,true)
                        } else {
                            completion(err,false)
                        }
                    }
                    strongSelf.progressCompleted+=1
                    DispatchQueue.main.async {
                        strongSelf.progressView.progress = (strongSelf.progressCompleted/strongSelf.totalProgress)
                        print("\(strongSelf.progressCompleted) out of \(strongSelf.totalProgress)")
                        
                    }
                    DispatchQueue.global(qos: .userInitiated).async {
                        strongSelf.worldstarsemaphore.signal()
                    }
                })
                strongSelf.worldstarsemaphore.wait()
            }
        }
    }
    
    func handleWorldstar(urlString: String, completion: @escaping (Error?, Bool) -> Void) {
        DispatchQueue.main.async {[weak self] in
            guard let strongSelf = self else {return}
            let video = WorldstarData(url: urlString, dateIA: "", timeIa: "", isActive: false)
            strongSelf.videoToUpload.worldstar!.append(video)
            completion(nil,true)
        }
    }
    
    func worldstarStore(data: [WorldstarData], completion: @escaping (Error?, Bool) -> Void) {
        DispatchQueue.main.async {[weak self] in
            guard let strongSelf = self else {return}
            strongSelf.alertView.message = "Storing Worldstar"
        }
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let strongSelf = self else {return}
            var count = 0
            for obj in data {
                if count != 0 {
                    sleep(1)
                }
                count+=1
                DispatchQueue.main.async {[weak self] in
                    guard let strongSelf = self else {return}
                    strongSelf.alertView.message = "Storing Worldstar \(count)"
                }
                strongSelf.worldstarCompleteStore(data: obj, completion: { err, result in
                    if count == data.count {
                        if result == true {
                            completion(nil,true)
                        } else {
                            completion(err,false)
                        }
                    }
                    strongSelf.progressCompleted+=1
                    DispatchQueue.main.async {
                        strongSelf.progressView.progress = (strongSelf.progressCompleted/strongSelf.totalProgress)
                        print("\(strongSelf.progressCompleted) out of \(strongSelf.totalProgress)")
                        
                    }
                    DispatchQueue.global(qos: .userInitiated).async {
                        strongSelf.worldstarsemaphore.signal()
                    }
                })
                strongSelf.worldstarsemaphore.wait()
            }
        }
    }
    
    func worldstarCompleteStore(data: WorldstarData, completion: @escaping (Error?, Bool) -> Void) {
        
        let contentRandomKey = ("\(worldstarVideoContentTag)--\(videoToUpload.title.replacingOccurrences(of: ".", with: " ").replacingOccurrences(of: "#", with: " ").replacingOccurrences(of: "$", with: " ").replacingOccurrences(of: "[", with: " ").replacingOccurrences(of: "]", with: " ").replacingOccurrences(of: ":", with: " "))--\(data.url.replacingOccurrences(of: "/", with: "").replacingOccurrences(of: ".", with: "").replacingOccurrences(of: "#", with: "").replacingOccurrences(of: "$", with: "").suffix(10))--\(videoToUpload.toneDeafAppId)")
        
        let VideoRef = Database.database().reference().child("Music Content").child("Videos").child(videoDBID).child("Worldstar").child(contentRandomKey)
        
        var VideoInfoMap = [String : Any]()
        VideoInfoMap = [
            "Title" : videoToUpload.title,
            "Tone Deaf App Video Id": videoToUpload.toneDeafAppId,
            "Time Uploaded To App" : currtime,
            "Date Uploaded To App" : currdate,
            "Views In App" : 0,
            "Number of Favorites" : 0,
            "Type": chosenType!,
            "Verification Level": String(verificationLevel),
            "Industry Certified": industryCertified,
            "Active Status" : false
        ]
        
        let videoRef = Database.database().reference().child("Music Content").child("Videos").child(videoDBID)
        
        videoRef.updateChildValues(VideoInfoMap) { [weak self] (error, videoRef) in
            guard let strongSelf = self else {return}
            if let error = error {
                completion(error, false)
                print("📕 Failed to upload Worldstar video dictionary to database: \(error)")
                return
            }
        }
        
        var YTInfoMap = [String : Any]()
        YTInfoMap = [
            "Time Uploaded To App" : currtime,
            "Date Uploaded To App" : currdate,
            "Video URL" : data.url,
            "Active Status": false]
        
        VideoRef.updateChildValues(YTInfoMap) { [weak self] (error, albumRef) in
            guard let strongSelf = self else {return}
            if let error = error {
                print("📕 Failed to store Worldstar dictionary to database: \(error)")
                Utilities.showError2("Failed to Store Worldstar. Please try again.", actionText: "OK")
                completion(error, false)
                return
            } else {
                completion(nil, true)
                return
            }
        }
    }
    
    //MARK: - Twitter
    func twitterData(completion: @escaping (Error?, Bool) -> Void) {
        videoToUpload.twitter = []
        DispatchQueue.main.async {[weak self] in
            guard let strongSelf = self else {return}
            strongSelf.alertView.message = "Gathering Twitter"
        }
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let strongSelf = self else {return}
            var count = 0
            for obj in strongSelf.twitterArr {
                if count != 0 {
                    sleep(1)
                }
                count+=1
                DispatchQueue.main.async {[weak self] in
                    guard let strongSelf = self else {return}
                    strongSelf.alertView.message = "Gathering Twitter \(count)"
                }
                strongSelf.handleTwitter(urlString: obj, completion: { err, result in
                    if count == strongSelf.twitterArr.count {
                        if result == true {
                            completion(nil,true)
                        } else {
                            completion(err,false)
                        }
                    }
                    strongSelf.progressCompleted+=1
                    DispatchQueue.main.async {
                        strongSelf.progressView.progress = (strongSelf.progressCompleted/strongSelf.totalProgress)
                        print("\(strongSelf.progressCompleted) out of \(strongSelf.totalProgress)")
                        
                    }
                    DispatchQueue.global(qos: .userInitiated).async {
                        strongSelf.twittersemaphore.signal()
                    }
                })
                strongSelf.twittersemaphore.wait()
            }
        }
    }
    
    func handleTwitter(urlString: String, completion: @escaping (Error?, Bool) -> Void) {
        DispatchQueue.main.async {[weak self] in
            guard let strongSelf = self else {return}
            var url = urlString
            var videoId = ""
            
            if !url.contains("status/") {
                mediumImpactGenerator.impactOccurred()
                Utilities.showError2("Twitter url Invalid error", actionText: "OK")
                completion(VideoUploadErrors.twitterURLInvalid, false)
                return
            }
            if let range = url.range(of: "status/") {
                url.removeSubrange(url.startIndex..<range.lowerBound)
            }
            let split = String(url.dropFirst(7))
            videoId = String(split.prefix(19))
            TwitterRequest.shared.getPost(mediaId: videoId, completion: { result in
                switch result {
                case.success(let video):
                    print(video)
                    strongSelf.videoToUpload.twitter!.append(video)
                    completion(nil,true)
                case .failure(let error):
                    completion(error,false)
                }
            })
        }
    }
    
    func twitterStore(data: [TwitterTweetData], completion: @escaping (Error?, Bool) -> Void) {
        DispatchQueue.main.async {[weak self] in
            guard let strongSelf = self else {return}
            strongSelf.alertView.message = "Storing Youtube"
        }
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let strongSelf = self else {return}
            var count = 0
            for obj in data {
                if count != 0 {
                    sleep(1)
                }
                count+=1
                DispatchQueue.main.async {[weak self] in
                    guard let strongSelf = self else {return}
                    strongSelf.alertView.message = "Storing Youtube \(count)"
                }
                strongSelf.twitterCompleteStore(data: obj, completion: { err, result in
                    if count == data.count {
                        if result == true {
                            completion(nil,true)
                        } else {
                            completion(err,false)
                        }
                    }
                    strongSelf.progressCompleted+=1
                    DispatchQueue.main.async {
                        strongSelf.progressView.progress = (strongSelf.progressCompleted/strongSelf.totalProgress)
                        print("\(strongSelf.progressCompleted) out of \(strongSelf.totalProgress)")
                        
                    }
                    DispatchQueue.global(qos: .userInitiated).async {
                        strongSelf.ytstoresemaphore.signal()
                    }
                })
                strongSelf.ytstoresemaphore.wait()
            }
        }
    }
    
    func twitterCompleteStore(data: TwitterTweetData, completion: @escaping (Error?, Bool) -> Void) {
        
        let contentRandomKey = ("\(twitterVideoContentTag)--\(videoToUpload.title.replacingOccurrences(of: ".", with: " ").replacingOccurrences(of: "#", with: " ").replacingOccurrences(of: "$", with: " ").replacingOccurrences(of: "[", with: " ").replacingOccurrences(of: "]", with: " ").replacingOccurrences(of: ":", with: " "))--\(data.url.replacingOccurrences(of: "/", with: "").replacingOccurrences(of: ".", with: "").replacingOccurrences(of: "#", with: "").replacingOccurrences(of: "$", with: "").suffix(10))--\(videoToUpload.toneDeafAppId)")
        
        let VideoRef = Database.database().reference().child("Music Content").child("Videos").child(videoDBID).child("Twitter").child(contentRandomKey)
        
        var VideoInfoMap = [String : Any]()
        VideoInfoMap = [
            "Title" : videoToUpload.title,
            "Tone Deaf App Video Id": videoToUpload.toneDeafAppId,
            "Time Uploaded To App" : currtime,
            "Date Uploaded To App" : currdate,
            "Views In App" : 0,
            "Number of Favorites" : 0,
            "Type": chosenType!,
            "Verification Level": String(verificationLevel),
            "Industry Certified": industryCertified,
            "Active Status" : false
        ]
        
        let videoRef = Database.database().reference().child("Music Content").child("Videos").child(videoDBID)
        
        videoRef.updateChildValues(VideoInfoMap) { [weak self] (error, videoRef) in
            guard let strongSelf = self else {return}
            if let error = error {
                print("📕 Failed to upload youtube video dictionary to database: \(error)")
                return
            }
        }
        
        var mediaArray:[[String:String?]] = []
        for obj in data.media! {
            var dict = [
                "URL": obj.url,
                "Media Key": obj.mediaKey,
                "Preview URL": obj.previewURL,
                "Type": obj.type,
                "Content Type": obj.contentType
            ]
            mediaArray.append(dict)
        }
        
        var YTInfoMap = [String : Any]()
        YTInfoMap = [
            "Media" : mediaArray,
            "Time Uploaded To App" : currtime,
            "Date Uploaded To App" : currdate,
            "Text" : data.text,
            "Video URL" : data.url,
            "Views In App" : 0,
            "Twitter Id" : data.twitterId,
            "Active Status": false]
        
        VideoRef.updateChildValues(YTInfoMap) { [weak self] (error, albumRef) in
            guard let strongSelf = self else {return}
            if let error = error {
                print("📕 Failed to store Youtube dictionary to database: \(error)")
                Utilities.showError2("Failed to Store Youtube. Please try again.", actionText: "OK")
                completion(error, false)
                return
            } else {
                //print("📗 Youtube data for \(strongSelf.videoToUpload.title) saved to database successfully.")
                completion(nil, true)
                return
            }
        }
    }
    
    //MARK: - Apple Music
    func appleMusicData(completion: @escaping (Error?, Bool) -> Void) {
        videoToUpload.appleMusic = []
        DispatchQueue.main.async {[weak self] in
            guard let strongSelf = self else {return}
            strongSelf.alertView.message = "Gathering Apple Music"
        }
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let strongSelf = self else {return}
            var count = 0
            for obj in strongSelf.appleMusicArr {
                if count != 0 {
                    sleep(1)
                }
                count+=1
                DispatchQueue.main.async {[weak self] in
                    guard let strongSelf = self else {return}
                    strongSelf.alertView.message = "Gathering Apple Music \(count)"
                }
                strongSelf.handleAppleMusic(urlString: obj, completion: { err, result in
                    if count == strongSelf.appleMusicArr.count {
                        if result == true {
                            completion(nil,true)
                        } else {
                            completion(err,false)
                        }
                    }
                    strongSelf.progressCompleted+=1
                    DispatchQueue.main.async {
                        strongSelf.progressView.progress = (strongSelf.progressCompleted/strongSelf.totalProgress)
                        print("\(strongSelf.progressCompleted) out of \(strongSelf.totalProgress)")
                        
                    }
                    DispatchQueue.global(qos: .userInitiated).async {
                        strongSelf.appleMusicsemaphore.signal()
                    }
                })
                strongSelf.appleMusicsemaphore.wait()
            }
        }
    }
    
    func handleAppleMusic(urlString: String, completion: @escaping (Error?, Bool) -> Void) {
        DispatchQueue.main.async {[weak self] in
            guard let strongSelf = self else {return}
            let url = urlString
            var videoId = ""
            
            if !url.contains("music-video/") {
                mediumImpactGenerator.impactOccurred()
                Utilities.showError2("Apple Music url Invalid error", actionText: "OK")
                completion(VideoUploadErrors.appleMusicURLInvalid, false)
                return
            }
            videoId = String(url.suffix(10))
            AppleMusicRequest.shared.getAppleMusicVideo(id: videoId, completion: { result in
                switch result {
                case.success(let video):
                    print(video)
                    strongSelf.videoToUpload.appleMusic!.append(video)
                    completion(nil,true)
                case .failure(let error):
                    completion(error,false)
                }
            })
        }
    }
    
    func appleMusicStore(data: [AppleVideoData], completion: @escaping (Error?, Bool) -> Void) {
        DispatchQueue.main.async {[weak self] in
            guard let strongSelf = self else {return}
            strongSelf.alertView.message = "Storing Apple Music"
        }
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let strongSelf = self else {return}
            var count = 0
            for obj in data {
                if count != 0 {
                    sleep(1)
                }
                count+=1
                DispatchQueue.main.async {[weak self] in
                    guard let strongSelf = self else {return}
                    strongSelf.alertView.message = "Storing Apple Music \(count)"
                }
                strongSelf.appleMusicCompleteStore(data: obj, completion: { err, result in
                    if count == data.count {
                        if result == true {
                            completion(nil,true)
                        } else {
                            completion(err,false)
                        }
                    }
                    strongSelf.progressCompleted+=1
                    DispatchQueue.main.async {
                        strongSelf.progressView.progress = (strongSelf.progressCompleted/strongSelf.totalProgress)
                        print("\(strongSelf.progressCompleted) out of \(strongSelf.totalProgress)")
                        
                    }
                    DispatchQueue.global(qos: .userInitiated).async {
                        strongSelf.appleMusicsemaphore.signal()
                    }
                })
                strongSelf.appleMusicsemaphore.wait()
            }
        }
    }
    
    func appleMusicCompleteStore(data: AppleVideoData, completion: @escaping (Error?, Bool) -> Void) {
        
        let contentRandomKey = ("\(appleMusicContentType)--\(videoToUpload.title.replacingOccurrences(of: ".", with: " ").replacingOccurrences(of: "#", with: " ").replacingOccurrences(of: "$", with: " ").replacingOccurrences(of: "[", with: " ").replacingOccurrences(of: "]", with: " ").replacingOccurrences(of: ":", with: " "))--\(data.url.replacingOccurrences(of: "/", with: "").replacingOccurrences(of: ".", with: "").replacingOccurrences(of: "#", with: "").replacingOccurrences(of: "$", with: "").suffix(10))--\(videoToUpload.toneDeafAppId)")
        
        let VideoRef = Database.database().reference().child("Music Content").child("Videos").child(videoDBID).child("Apple Music").child(contentRandomKey)
        
        var VideoInfoMap = [String : Any]()
        VideoInfoMap = [
            "Title" : videoToUpload.title,
            "Tone Deaf App Video Id": videoToUpload.toneDeafAppId,
            "Time Uploaded To App" : currtime,
            "Date Uploaded To App" : currdate,
            "Views In App" : 0,
            "Number of Favorites" : 0,
            "Type": chosenType!,
            "Verification Level": String(verificationLevel),
            "Industry Certified": industryCertified,
            "Active Status" : false
        ]
        
        let videoRef = Database.database().reference().child("Music Content").child("Videos").child(videoDBID)
        
        videoRef.updateChildValues(VideoInfoMap) { [weak self] (error, videoRef) in
            if let error = error {
                print("📕 Failed to upload youtube video dictionary to database: \(error)")
                return
            }
        }
        
            var SongInfoMap = [String : Any]()
            SongInfoMap = [
                "Name" : data.name,
                "Artist" : data.artistName,
                "Explicity" : data.explicity,
                "Preview URL" : data.previewURL,
                "ISRC" : data.isrc,
                "Date Released On Apple" : data.dateApple,
                "Time Uploaded To App" : currtime,
                "Date Uploaded To App" : currdate,
                "Duration" : data.duration,
                "Thumbnail URL" : data.thumbnailURL,
                "URL" : data.url,
                "Album Name" : data.albumName,
                "Genres" : data.genres,
                "Track Number" : data.trackNumber,
                "Apple Music Id" : data.appleId,
                "Active Status": false
            ]
            
        VideoRef.updateChildValues(SongInfoMap) { [weak self] (error, songRef) in
            guard let strongSelf = self else {return}
                if let error = error {
                    print("📕 Failed to upload dictionary to database: \(error)")
                    Utilities.showError2("Failed to Upload. Please try again.", actionText: "OK")
                    completion(error, false)
                    return
                } else {
                    print("kjhgfdgsdgghjkjl")
                    completion(nil, true)
                    print("📗 Apple data for \(strongSelf.videoToUpload.title) saved to database successfully.")
                    return
                }
            }
    }
    
    //MARK: - Tik Tok
    func tikTokData(completion: @escaping (Error?, Bool) -> Void) {
        videoToUpload.tikTok = []
        DispatchQueue.main.async {[weak self] in
            guard let strongSelf = self else {return}
            strongSelf.alertView.message = "Gathering Tik Tok Post"
        }
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let strongSelf = self else {return}
            var count = 0
            for obj in strongSelf.tikTokArr {
                if count != 0 {
                    sleep(1)
                }
                count+=1
                DispatchQueue.main.async {[weak self] in
                    guard let strongSelf = self else {return}
                    strongSelf.alertView.message = "Gathering Tik Tok Post \(count)"
                }
                strongSelf.handleTikTokPost(urlString: obj, completion: { err, result in
                    if count == strongSelf.tikTokArr.count {
                        if result == true {
                            completion(nil,true)
                        } else {
                            completion(err,false)
                        }
                    }
                    strongSelf.progressCompleted+=1
                    DispatchQueue.main.async {
                        strongSelf.progressView.progress = (strongSelf.progressCompleted/strongSelf.totalProgress)
                        print("\(strongSelf.progressCompleted) out of \(strongSelf.totalProgress)")
                        
                    }
                    DispatchQueue.global(qos: .userInitiated).async {
                        strongSelf.tiktoksemaphore.signal()
                    }
                })
                strongSelf.tiktoksemaphore.wait()
            }
        }
    }
    
    func handleTikTokPost(urlString: String, completion: @escaping (Error?, Bool) -> Void) {
        DispatchQueue.main.async {[weak self] in
            guard let strongSelf = self else {return}
            let video = TikTokData(url: urlString, dateIA: "", timeIa: "", isActive: false)
            strongSelf.videoToUpload.tikTok!.append(video)
            completion(nil,true)
        }
    }
    
    func tikTokStore(data: [TikTokData], completion: @escaping (Error?, Bool) -> Void) {
        DispatchQueue.main.async {[weak self] in
            guard let strongSelf = self else {return}
            strongSelf.alertView.message = "Storing Tik Tok"
        }
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let strongSelf = self else {return}
            var count = 0
            for obj in data {
                if count != 0 {
                    sleep(1)
                }
                count+=1
                DispatchQueue.main.async {[weak self] in
                    guard let strongSelf = self else {return}
                    strongSelf.alertView.message = "Storing Tik Tok  \(count)"
                }
                strongSelf.tikTokCompleteStore(data: obj, completion: { err, result in
                    if count == data.count {
                        if result == true {
                            completion(nil,true)
                        } else {
                            completion(err,false)
                        }
                    }
                    strongSelf.progressCompleted+=1
                    DispatchQueue.main.async {
                        strongSelf.progressView.progress = (strongSelf.progressCompleted/strongSelf.totalProgress)
                        print("\(strongSelf.progressCompleted) out of \(strongSelf.totalProgress)")
                        
                    }
                    DispatchQueue.global(qos: .userInitiated).async {
                        strongSelf.tiktoksemaphore.signal()
                    }
                })
                strongSelf.tiktoksemaphore.wait()
            }
        }
    }
    
    func tikTokCompleteStore(data: TikTokData, completion: @escaping (Error?, Bool) -> Void) {
        
        let contentRandomKey = ("\(tikTokVideoContentTag)--\(videoToUpload.title.replacingOccurrences(of: ".", with: " ").replacingOccurrences(of: "#", with: " ").replacingOccurrences(of: "$", with: " ").replacingOccurrences(of: "[", with: " ").replacingOccurrences(of: "]", with: " ").replacingOccurrences(of: ":", with: " "))--\(data.url.replacingOccurrences(of: "/", with: "").replacingOccurrences(of: ".", with: "").replacingOccurrences(of: "#", with: "").replacingOccurrences(of: "$", with: "").suffix(10))--\(videoToUpload.toneDeafAppId)")
        
        let VideoRef = Database.database().reference().child("Music Content").child("Videos").child(videoDBID).child("Tik Tok").child(contentRandomKey)
        
        var VideoInfoMap = [String : Any]()
        VideoInfoMap = [
            "Title" : videoToUpload.title,
            "Tone Deaf App Video Id": videoToUpload.toneDeafAppId,
            "Time Uploaded To App" : currtime,
            "Date Uploaded To App" : currdate,
            "Views In App" : 0,
            "Number of Favorites" : 0,
            "Type": chosenType!,
            "Verification Level": String(verificationLevel),
            "Industry Certified": industryCertified,
            "Active Status" : false
        ]
        
        let videoRef = Database.database().reference().child("Music Content").child("Videos").child(videoDBID)
        
        videoRef.updateChildValues(VideoInfoMap) { [weak self] (error, videoRef) in
            guard let strongSelf = self else {return}
            if let error = error {
                completion(error, false)
                print("📕 Failed to upload Tik Tok video dictionary to database: \(error)")
                return
            }
        }
        
        var YTInfoMap = [String : Any]()
        YTInfoMap = [
            "Time Uploaded To App" : currtime,
            "Date Uploaded To App" : currdate,
            "Video URL" : data.url,
            "Active Status": false]
        
        VideoRef.updateChildValues(YTInfoMap) { [weak self] (error, albumRef) in
            guard let strongSelf = self else {return}
            if let error = error {
                print("📕 Failed to store Tik Tok dictionary to database: \(error)")
                Utilities.showError2("Failed to Store Tik Tok. Please try again.", actionText: "OK")
                completion(error, false)
                return
            } else {
                completion(nil, true)
                return
            }
        }
    }
    
    //MARK: - Videographer Store
    
    func storeVideographers(data: [PersonData], completion: @escaping (Error?, Bool) -> Void) {
        DispatchQueue.main.async {[weak self] in
            guard let strongSelf = self else {return}
            strongSelf.alertView.message = "Storing Videographers"
        }
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let strongSelf = self else {return}
            var count = 0
            for obj in data {
                if count != 0 {
                    sleep(1)
                }
                count+=1
                DispatchQueue.main.async {[weak self] in
                    guard let strongSelf = self else {return}
                    strongSelf.alertView.message = "Storing Videographer  \(count)"
                }
                strongSelf.videographerCompleteStore(data: obj, completion: { err, result in
                    if result == true {
                        strongSelf.progressCompleted+=1
                        DispatchQueue.main.async {
                            strongSelf.progressView.progress = (strongSelf.progressCompleted/strongSelf.totalProgress)
                            print("\(strongSelf.progressCompleted) out of \(strongSelf.totalProgress)")
                            
                        }
                        DispatchQueue.global(qos: .userInitiated).async {
                            strongSelf.videographerstoresemaphore.signal()
                        }
                        if count == data.count {
                            completion(nil,true)
                        }
                    } else {
                        completion(err,false)
                    }
                })
                strongSelf.videographerstoresemaphore.wait()
            }
        }
    }
    
    func videographerCompleteStore(data: PersonData, completion: @escaping (Error?, Bool) -> Void) {
        let VideoRef = Database.database().reference().child("Music Content").child("Videos").child(videoDBID).child("Videographers")
        
        let id = "\(data.toneDeafAppId)"
        
        VideoRef.observeSingleEvent(of: .value, with: {[weak self] snap in
            guard let strongSelf = self else {return}
            var myArr:[String] = []
            if let arr = snap.value as? [String] {
                if !arr.contains(id) {
                    myArr = arr
                    myArr.append(id)
                    VideoRef.setValue(myArr)
                }
                strongSelf.getPersonIDArrar(id: "\(strongSelf.videoToUpload.toneDeafAppId)", cat: "Videos", person: data, completion: { err, result in
                    if err == nil {
                        var setArr = result
                        let key = "\(data.name!)--\(data.dateRegisteredToApp!)--\(data.timeRegisteredToApp!)--\(data.toneDeafAppId)"
                        let ref = Database.database().reference().child("Registered Persons").child(key).child("Videos")
                        setArr.append("\(strongSelf.videoToUpload.toneDeafAppId)")
                        ref.setValue(setArr)
                        completion(nil,true)
                    } else {
                        completion(err,false)
                    }
                })
            } else {
                VideoRef.setValue([id])
                strongSelf.getPersonIDArrar(id: "\(strongSelf.videoToUpload.toneDeafAppId)", cat: "Videos", person: data, completion: { err, result in
                    if err == nil {
                        var setArr = result
                        let key = "\(data.name!)--\(data.dateRegisteredToApp!)--\(data.timeRegisteredToApp!)--\(data.toneDeafAppId)"
                        let ref = Database.database().reference().child("Registered Persons").child(key).child("Videos")
                        setArr.append("\(strongSelf.videoToUpload.toneDeafAppId)")
                        ref.setValue(setArr)
                        completion(nil,true)
                    } else {
                        completion(err,false)
                    }
                })
            }
        })
        
    }
    
    func storeVideographerRoles(data: [PersonData], completion: @escaping (Error?, Bool) -> Void) {
        DispatchQueue.main.async {[weak self] in
            guard let strongSelf = self else {return}
            strongSelf.alertView.message = "Storing Videographer Roles"
        }
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let strongSelf = self else {return}
            var count = 0
            for obj in data {
                if count != 0 {
                    sleep(1)
                }
                count+=1
                DispatchQueue.main.async {[weak self] in
                    guard let strongSelf = self else {return}
                    strongSelf.alertView.message = "Storing Videographer \(count) Roles"
                }
                strongSelf.updateVideographerRoles(data: obj, completion: { err, result in
                    if result == true {
                        strongSelf.progressCompleted+=1
                        DispatchQueue.main.async {
                            strongSelf.progressView.progress = (strongSelf.progressCompleted/strongSelf.totalProgress)
                            print("\(strongSelf.progressCompleted) out of \(strongSelf.totalProgress)")
                            
                        }
                        DispatchQueue.global(qos: .userInitiated).async {
                            strongSelf.videographerrolesemaphore.signal()
                        }
                        if count == data.count {
                            completion(nil,true)
                        }
                    } else {
                        completion(err,false)
                    }
                })
                strongSelf.videographerrolesemaphore.wait()
            }
        }
    }
    
    func updateVideographerRoles(data: PersonData, completion: @escaping (Error?, Bool) -> Void) {
        let key = "\(data.name!)--\(data.dateRegisteredToApp!)--\(data.timeRegisteredToApp!)--\(data.toneDeafAppId)"
        let ref = Database.database().reference().child("Registered Persons").child(key).child("Roles").child("Videographer")
        ref.observeSingleEvent(of: .value, with: {[weak self] snapshot in
            guard let strongSelf = self else {return}
            var mysongsArray:[String] = []
            if let val = snapshot.value {
                let valu = val as? [String]
                guard let value = valu else {
                    mysongsArray = ["\(strongSelf.videoToUpload.toneDeafAppId)"]
                    ref.setValue(mysongsArray)
                    completion(nil, true)
                    return}
                if value[0] != "" {
                    mysongsArray = value
                    mysongsArray.append("\(strongSelf.videoToUpload.toneDeafAppId)")
                    ref.setValue(mysongsArray)
                    completion(nil, true)
                } else {
                    mysongsArray = ["\(strongSelf.videoToUpload.toneDeafAppId)"]
                    ref.setValue(mysongsArray)
                    completion(nil, true)
                }
            } else {
                mysongsArray = ["\(strongSelf.videoToUpload.toneDeafAppId)"]
                ref.setValue(mysongsArray)
                completion(nil, true)
            }
            //print(val)
        })
    }
    
    //MARK: - Person Store
    
    func storePersons(data: [PersonData], completion: @escaping (Error?, Bool) -> Void) {
        DispatchQueue.main.async {[weak self] in
            guard let strongSelf = self else {return}
            strongSelf.alertView.message = "Storing Persons"
        }
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let strongSelf = self else {return}
            var count = 0
            for obj in data {
                if count != 0 {
                    sleep(1)
                }
                count+=1
                DispatchQueue.main.async {[weak self] in
                    guard let strongSelf = self else {return}
                    strongSelf.alertView.message = "Storing Person \(count)"
                }
                strongSelf.personCompleteStore(data: obj, completion: { err, result in
                    if result == true {
                        strongSelf.progressCompleted+=1
                        DispatchQueue.main.async {
                            strongSelf.progressView.progress = (strongSelf.progressCompleted/strongSelf.totalProgress)
                            print("\(strongSelf.progressCompleted) out of \(strongSelf.totalProgress)")
                            
                        }
                        DispatchQueue.global(qos: .userInitiated).async {
                            strongSelf.personstoresemaphore.signal()
                        }
                        if count == data.count {
                            completion(nil,true)
                        }
                    } else {
                        completion(err,false)
                    }
                })
                strongSelf.personstoresemaphore.wait()
            }
        }
    }
    
    func personCompleteStore(data: PersonData, completion: @escaping (Error?, Bool) -> Void) {
        let VideoRef = Database.database().reference().child("Music Content").child("Videos").child(videoDBID).child("Persons")
        
        let id = "\(data.toneDeafAppId)"
        
        VideoRef.observeSingleEvent(of: .value, with: {[weak self] snap in
            guard let strongSelf = self else {return}
            var myArr:[String] = []
            if let arr = snap.value as? [String] {
                if !arr.contains(id) {
                    myArr = arr
                    myArr.append(id)
                    VideoRef.setValue(myArr)
                }
                strongSelf.getPersonIDArrar(id: "\(strongSelf.videoToUpload.toneDeafAppId)", cat: "Videos", person: data, completion: { err, result in
                    if err == nil {
                        var setArr = result
                        let key = "\(data.name!)--\(data.dateRegisteredToApp!)--\(data.timeRegisteredToApp!)--\(data.toneDeafAppId)"
                        let ref = Database.database().reference().child("Registered Persons").child(key).child("Videos")
                        setArr.append("\(strongSelf.videoToUpload.toneDeafAppId)")
                        ref.setValue(setArr)
                        completion(nil,true)
                    } else {
                        completion(err,false)
                    }
                })
            } else {
                VideoRef.setValue([id])
                strongSelf.getPersonIDArrar(id: "\(strongSelf.videoToUpload.toneDeafAppId)", cat: "Videos", person: data, completion: { err, result in
                    if err == nil {
                        var setArr = result
                        let key = "\(data.name!)--\(data.dateRegisteredToApp!)--\(data.timeRegisteredToApp!)--\(data.toneDeafAppId)"
                        let ref = Database.database().reference().child("Registered Persons").child(key).child("Videos")
                        setArr.append("\(strongSelf.videoToUpload.toneDeafAppId)")
                        ref.setValue(setArr)
                        completion(nil,true)
                    } else {
                        completion(err,false)
                    }
                })
            }
        })
        
    }
    
    func getPersonIDArrar(id:String, cat:String, person: PersonData, completion: @escaping (Error?, [String]) -> Void) {
        let key = "\(person.name!)--\(person.dateRegisteredToApp!)--\(person.timeRegisteredToApp!)--\(person.toneDeafAppId)"
        print(key)
        let ref = Database.database().reference().child("Registered Persons").child(key).child(cat)
        ref.observeSingleEvent(of: .value, with: { snapshot in
            var mysongsArray:[String] = []
            if let val = snapshot.value {
                let valu = val as? [String]
                guard let value = valu else {
                    completion(nil, mysongsArray)
                    return}
                if value[0] != "" {
                    mysongsArray = value
                    completion(nil, mysongsArray)
                } else {
                    completion(nil, mysongsArray)
                }
            } else {
                completion(nil, mysongsArray)
            }
            //print(val)
        })
    }
    
    //MARK: - Song Store
    
    func storeSongs(data: [SongData], completion: @escaping (Error?, Bool) -> Void) {
        DispatchQueue.main.async {[weak self] in
            guard let strongSelf = self else {return}
            strongSelf.alertView.message = "Storing Songs"
        }
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let strongSelf = self else {return}
            var count = 0
            for obj in data {
                if count != 0 {
                    sleep(1)
                }
                count+=1
                DispatchQueue.main.async {[weak self] in
                    guard let strongSelf = self else {return}
                    strongSelf.alertView.message = "Storing Song \(count)"
                }
                strongSelf.songCompleteStore(data: obj, completion: { err, result in
                    if result == true {
                        strongSelf.progressCompleted+=1
                        DispatchQueue.main.async {
                            strongSelf.progressView.progress = (strongSelf.progressCompleted/strongSelf.totalProgress)
                            print("\(strongSelf.progressCompleted) out of \(strongSelf.totalProgress)")
                            
                        }
                        DispatchQueue.global(qos: .userInitiated).async {
                            strongSelf.songstoresemaphore.signal()
                        }
                        if count == data.count {
                            completion(nil,true)
                        }
                    } else {
                        completion(err,false)
                    }
                })
                strongSelf.songstoresemaphore.wait()
            }
        }
    }
    
    func songCompleteStore(data: SongData, completion: @escaping (Error?, Bool) -> Void) {
        let VideoRef = Database.database().reference().child("Music Content").child("Videos").child(videoDBID).child("Songs")
        
        let id = "\(data.toneDeafAppId)"
        
        VideoRef.observeSingleEvent(of: .value, with: {[weak self] snap in
            guard let strongSelf = self else {return}
            var myArr:[String] = []
            if let arr = snap.value as? [String] {
                if !arr.contains(id) {
                    myArr = arr
                    myArr.append(id)
                    VideoRef.setValue(myArr)
                }
                strongSelf.finishSongUpdate(id: "\(strongSelf.videoToUpload.toneDeafAppId)", song: data, completion: { err, result in
                    if err == nil {
                        completion(nil,true)
                    } else {
                        completion(err,false)
                    }
                })
            } else {
                VideoRef.setValue([id])
                strongSelf.finishSongUpdate(id: "\(strongSelf.videoToUpload.toneDeafAppId)", song: data, completion: { err, result in
                    if err == nil {
                        completion(nil,true)
                    } else {
                        completion(err,false)
                    }
                })
            }
        })
        
    }
    
    func finishSongUpdate(id:String, song: SongData, completion: @escaping (Error?, Bool) -> Void) {
        let key = "\(songContentTag)--\(song.name)--\(song.toneDeafAppId)"
        let ref = Database.database().reference().child("Music Content").child("Songs").child(key).child("REQUIRED").child("Videos")
        
        ref.observeSingleEvent(of: .value, with: {[weak self] snapshot in
            guard let strongSelf = self else {return}
            var mysongsArray:[String] = []
            if let val = snapshot.value {
                let valu = val as? [String]
                guard let value = valu else {
                    mysongsArray = [id]
                    ref.setValue(mysongsArray)
                    strongSelf.finishSongVideoUpdate(songId: song.toneDeafAppId,id: id, key: key, completion: { err, done in
                        if err == nil {
                            completion(nil,true)
                        } else {
                            completion(err,false)
                        }
                    })
                    return}
                if value[0] != "" {
                    mysongsArray = value
                    mysongsArray.append(id)
                    ref.setValue(mysongsArray)
                    strongSelf.finishSongVideoUpdate(songId: song.toneDeafAppId,id: id, key: key, completion: { err, done in
                        if err == nil {
                            completion(nil,true)
                        } else {
                            completion(err,false)
                        }
                    })
                } else {
                    mysongsArray = [id]
                    ref.setValue(mysongsArray)
                    strongSelf.finishSongVideoUpdate(songId: song.toneDeafAppId,id: id, key: key, completion: { err, done in
                        if err == nil {
                            completion(nil,true)
                        } else {
                            completion(err,false)
                        }
                    })
                }
            } else {
                mysongsArray = [id]
                ref.setValue(mysongsArray)
                strongSelf.finishSongVideoUpdate(songId: song.toneDeafAppId,id: id, key: key, completion: { err, done in
                    if err == nil {
                        completion(nil,true)
                    } else {
                        completion(err,false)
                    }
                })
            }
        })
    }
    
    func finishSongVideoUpdate(songId: String,id:String, key: String, completion: @escaping (Error?, Bool) -> Void) {
        let ref = Database.database().reference().child("Music Content").child("Songs").child(key).child("Videos")
        if officialRelationArr.contains(songId) {
            ref.child("Official").child("id").setValue(id)
            completion(nil,true)
        } else
        if audioRelationArr.contains(songId) {
            ref.child("Audio").child("id").setValue(id)
            completion(nil,true)
        } else
        if lyricRelationArr.contains(songId) {
            ref.child("Lyric").child("id").setValue(id)
            completion(nil,true)
        } else
        {
            completion(nil,true)
        }
    }
    
    //MARK: - Album Store
    
    func storeAlbums(data: [AlbumData], completion: @escaping (Error?, Bool) -> Void) {
        DispatchQueue.main.async {[weak self] in
            guard let strongSelf = self else {return}
            strongSelf.alertView.message = "Storing Albums"
        }
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let strongSelf = self else {return}
            var count = 0
            for obj in data {
                if count != 0 {
                    sleep(1)
                }
                count+=1
                DispatchQueue.main.async {[weak self] in
                    guard let strongSelf = self else {return}
                    strongSelf.alertView.message = "Storing Album \(count)"
                }
                strongSelf.albumCompleteStore(data: obj, completion: { err, result in
                    if result == true {
                        strongSelf.progressCompleted+=1
                        DispatchQueue.main.async {
                            strongSelf.progressView.progress = (strongSelf.progressCompleted/strongSelf.totalProgress)
                            print("\(strongSelf.progressCompleted) out of \(strongSelf.totalProgress)")
                            
                        }
                        DispatchQueue.global(qos: .userInitiated).async {
                            strongSelf.albumstoresemaphore.signal()
                        }
                        if count == data.count {
                            completion(nil,true)
                        }
                    } else {
                        completion(err,false)
                    }
                })
                strongSelf.albumstoresemaphore.wait()
            }
        }
    }
    
    func albumCompleteStore(data: AlbumData, completion: @escaping (Error?, Bool) -> Void) {
        let VideoRef = Database.database().reference().child("Music Content").child("Videos").child(videoDBID).child("Albums")
        
        let id = "\(data.toneDeafAppId)"
        
        VideoRef.observeSingleEvent(of: .value, with: {[weak self] snap in
            guard let strongSelf = self else {return}
            var myArr:[String] = []
            if let arr = snap.value as? [String] {
                if !arr.contains(id) {
                    myArr = arr
                    myArr.append(id)
                    VideoRef.setValue(myArr)
                }
                strongSelf.finishAlbumUpdate(id: "\(strongSelf.videoToUpload.toneDeafAppId)", album: data, completion: { err, result in
                    if err == nil {
                        completion(nil,true)
                    } else {
                        completion(err,false)
                    }
                })
            } else {
                VideoRef.setValue([id])
                strongSelf.finishAlbumUpdate(id: "\(strongSelf.videoToUpload.toneDeafAppId)", album: data, completion: { err, result in
                    if err == nil {
                        completion(nil,true)
                    } else {
                        completion(err,false)
                    }
                })
            }
        })
        
    }
    
    func finishAlbumUpdate(id:String, album: AlbumData, completion: @escaping (Error?, Bool) -> Void) {
        let key = "\(albumContentTag)--\(album.name)--\(album.toneDeafAppId)"
        let ref = Database.database().reference().child("Music Content").child("Albums").child(key).child("REQUIRED").child("Videos")
        
        ref.observeSingleEvent(of: .value, with: {[weak self] snapshot in
            guard let strongSelf = self else {return}
            var mysongsArray:[String] = []
            if let val = snapshot.value {
                let valu = val as? [String]
                guard let value = valu else {
                    mysongsArray = [id]
                    ref.setValue(mysongsArray)
                    strongSelf.finishAlbumVideoUpdate(albumId:album.toneDeafAppId,id: id, key: key, completion: { err, done in
                        if err == nil {
                            completion(nil,true)
                        } else {
                            completion(err,false)
                        }
                    })
                    return}
                if value[0] != "" {
                    mysongsArray = value
                    mysongsArray.append(id)
                    ref.setValue(mysongsArray)
                    strongSelf.finishAlbumVideoUpdate(albumId:album.toneDeafAppId,id: id, key: key, completion: { err, done in
                        if err == nil {
                            completion(nil,true)
                        } else {
                            completion(err,false)
                        }
                    })
                } else {
                    mysongsArray = [id]
                    ref.setValue(mysongsArray)
                    strongSelf.finishAlbumVideoUpdate(albumId:album.toneDeafAppId,id: id, key: key, completion: { err, done in
                        if err == nil {
                            completion(nil,true)
                        } else {
                            completion(err,false)
                        }
                    })
                }
            } else {
                mysongsArray = [id]
                ref.setValue(mysongsArray)
                strongSelf.finishAlbumVideoUpdate(albumId:album.toneDeafAppId,id: id, key: key, completion: { err, done in
                    if err == nil {
                        completion(nil,true)
                    } else {
                        completion(err,false)
                    }
                })
            }
            //print(val)
        })
    }
    
    func finishAlbumVideoUpdate(albumId: String,id:String, key: String, completion: @escaping (Error?, Bool) -> Void) {
        let ref = Database.database().reference().child("Music Content").child("Songs").child(key).child("Videos")
        if officialRelationArr.contains(albumId) {
            ref.child("Official").child("id").setValue(id)
            completion(nil,true)
        } else
        {
            completion(nil,true)
        }
    }
    
    //MARK: - Instrumental Store
    
    func storeInstrumentals(data: [InstrumentalData], completion: @escaping (Error?, Bool) -> Void) {
        DispatchQueue.main.async {[weak self] in
            guard let strongSelf = self else {return}
            strongSelf.alertView.message = "Storing Instrumentals"
        }
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let strongSelf = self else {return}
            var count = 0
            for obj in data {
                if count != 0 {
                    sleep(1)
                }
                count+=1
                DispatchQueue.main.async {[weak self] in
                    guard let strongSelf = self else {return}
                    strongSelf.alertView.message = "Storing Instrumental \(count)"
                }
                strongSelf.instrumentalCompleteStore(data: obj, completion: { err, result in
                    if result == true {
                        strongSelf.progressCompleted+=1
                        DispatchQueue.main.async {
                            strongSelf.progressView.progress = (strongSelf.progressCompleted/strongSelf.totalProgress)
                            print("\(strongSelf.progressCompleted) out of \(strongSelf.totalProgress)")
                            
                        }
                        DispatchQueue.global(qos: .userInitiated).async {
                            strongSelf.instrumentalstoresemaphore.signal()
                        }
                        if count == data.count {
                            completion(nil,true)
                        }
                    } else {
                        completion(err,false)
                    }
                })
                strongSelf.instrumentalstoresemaphore.wait()
            }
        }
    }
    
    func instrumentalCompleteStore(data: InstrumentalData, completion: @escaping (Error?, Bool) -> Void) {
        let VideoRef = Database.database().reference().child("Music Content").child("Videos").child(videoDBID).child("Instrumentals")
        
        let id = "\(data.toneDeafAppId)"
        
        VideoRef.observeSingleEvent(of: .value, with: {[weak self] snap in
            guard let strongSelf = self else {return}
            var myArr:[String] = []
            if let arr = snap.value as? [String] {
                if !arr.contains(id) {
                    myArr = arr
                    myArr.append(id)
                    VideoRef.setValue(myArr)
                }
                strongSelf.finishInstrumentalUpdate(id: "\(strongSelf.videoToUpload.toneDeafAppId)", instrumental: data, completion: { err, result in
                    if err == nil {
                        completion(nil,true)
                    } else {
                        completion(err,false)
                    }
                })
            } else {
                VideoRef.setValue([id])
                strongSelf.finishInstrumentalUpdate(id: "\(strongSelf.videoToUpload.toneDeafAppId)", instrumental: data, completion: { err, result in
                    if err == nil {
                        completion(nil,true)
                    } else {
                        completion(err,false)
                    }
                })
            }
        })
        
    }
    
    func finishInstrumentalUpdate(id:String, instrumental: InstrumentalData, completion: @escaping (Error?, Bool) -> Void) {
        let key = "\(instrumentalContentType)--\(instrumental.songName!)--\(instrumental.toneDeafAppId)"
        let ref = Database.database().reference().child("Music Content").child("Instrumentals").child(key).child("Videos")
        
        ref.observeSingleEvent(of: .value, with: {[weak self] snapshot in
            guard let strongSelf = self else {return}
            var mysongsArray:[String] = []
            if let val = snapshot.value {
                let valu = val as? [String]
                guard let value = valu else {
                    mysongsArray = [id]
                    ref.setValue(mysongsArray)
                    strongSelf.finishInstrumentalVideoUpdate(songId: instrumental.toneDeafAppId,id: id, key: key, completion: { err, done in
                        if err == nil {
                            completion(nil,true)
                        } else {
                            completion(err,false)
                        }
                    })
                    return}
                if value[0] != "" {
                    mysongsArray = value
                    mysongsArray.append(id)
                    ref.setValue(mysongsArray)
                    strongSelf.finishInstrumentalVideoUpdate(songId: instrumental.toneDeafAppId,id: id, key: key, completion: { err, done in
                        if err == nil {
                            completion(nil,true)
                        } else {
                            completion(err,false)
                        }
                    })
                } else {
                    mysongsArray = [id]
                    ref.setValue(mysongsArray)
                    strongSelf.finishInstrumentalVideoUpdate(songId: instrumental.toneDeafAppId,id: id, key: key, completion: { err, done in
                        if err == nil {
                            completion(nil,true)
                        } else {
                            completion(err,false)
                        }
                    })
                }
            } else {
                mysongsArray = [id]
                ref.setValue(mysongsArray)
                strongSelf.finishInstrumentalVideoUpdate(songId: instrumental.toneDeafAppId,id: id, key: key, completion: { err, done in
                    if err == nil {
                        completion(nil,true)
                    } else {
                        completion(err,false)
                    }
                })
            }
        })
    }
    
    func finishInstrumentalVideoUpdate(songId: String,id:String, key: String, completion: @escaping (Error?, Bool) -> Void) {
        let ref = Database.database().reference().child("Music Content").child("Instrumentals").child(key).child("Videos")
        if instrumentalRelationArr.contains(songId) {
            ref.child("Instrumental").child("id").setValue(id)
            completion(nil,true)
        } else
        {
            ref.child("Other").observeSingleEvent(of: .value, with: {[weak self] snapshot in
                guard let strongSelf = self else {return}
                var mysongsArray:[String] = []
                if let val = snapshot.value {
                    let valu = val as? [String]
                    guard let value = valu else {
                        mysongsArray.append(id)
                        ref.child("Other").setValue(mysongsArray)
                        completion(nil,true)
                        return
                    }
                    mysongsArray = value
                    mysongsArray.append(id)
                    ref.child("Other").setValue(mysongsArray)
                    completion(nil,true)
                } else {
                    mysongsArray.append(id)
                    ref.child("Other").setValue(mysongsArray)
                    completion(nil,true)
                }
            })
        }
    }
    
    //MARK: - Beat Store
    
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
        videographernames = []
        guard !videographerArr.contains(chosenVideographer) else {
            mediumImpactGenerator.impactOccurred()
            Utilities.showError2("Videographer already added.", actionText: "OK")
            return}
        videographerArr.append(chosenVideographer)
        videographersTableView.reloadData()
        videographersHeightConstraint.constant = CGFloat(50*(videographerArr.count))
        
        view.endEditing(true)
    }
    
    @objc func dismissKeyboard3() {
        personnames = []
        guard !personArr.contains(chosenPerson) else {
            mediumImpactGenerator.impactOccurred()
            Utilities.showError2("Person already added.", actionText: "OK")
            return}
        personArr.append(chosenPerson)
        personTableView.reloadData()
        personHeightConstraint.constant = CGFloat(50*(personArr.count))
        view.endEditing(true)
    }
    
    @objc func dismissKeyboard4() {
        songnames = []
        guard !songArr.contains(chosenSong) else {
            mediumImpactGenerator.impactOccurred()
            Utilities.showError2("Song already added.", actionText: "OK")
            return
        }
        view.endEditing(true)
        DispatchQueue.main.async {[weak self] in
            guard let strongSelf = self else {return}
            alertController = UIAlertController(title: "Select Relationship",
                                                message: "Select the relation this video has with \(strongSelf.chosenSong.name)",
                                                preferredStyle: .alert)
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc3 = storyboard.instantiateViewController(identifier: "editPersonRolesPopoverTableViewController") as
            EditPersonRolesPopoverTableViewController
            vc3.preferredContentSize = CGSize(width: 350, height: 200) // 4 default cell heights.
            vc3.roleArr = ["Official","Audio","Lyric","Other"]
            vc3.tableView.isScrollEnabled = false
            alertController.setValue(vc3, forKey: "contentViewController")
            
            let addAction = UIAlertAction(title: "Select Relation", style: .default, handler: {[weak self] _ in
                guard let strongSelf = self else {return}
                let cc = alertController.value(forKey: "contentViewController") as! EditPersonRolesPopoverTableViewController
                for i in 1 ... (cc.roleArr.count) {
                    let cell = cc.tableViewPopover.cellForRow(at: IndexPath(row: i-1, section: 0)) as! EditRolePopoverTableCellController
                    if cell.checkbox.on {
                        switch cell.role.text! {
                        case "Official":
                            if !strongSelf.officialRelationArr.contains(strongSelf.chosenSong.toneDeafAppId) {
                                strongSelf.officialRelationArr.append(strongSelf.chosenSong.toneDeafAppId)
                            }
                        case "Audio":
                            if !strongSelf.audioRelationArr.contains(strongSelf.chosenSong.toneDeafAppId) {
                                strongSelf.audioRelationArr.append(strongSelf.chosenSong.toneDeafAppId)
                            }
                        case "Lyric":
                            if !strongSelf.lyricRelationArr.contains(strongSelf.chosenSong.toneDeafAppId) {
                                strongSelf.lyricRelationArr.append(strongSelf.chosenSong.toneDeafAppId)
                            }
                        default:
                            break
                        }
                    }
                }
                
                strongSelf.songArr.append(strongSelf.chosenSong)
                strongSelf.songsTableView.reloadData()
                strongSelf.songsHeightConstraint.constant = CGFloat(50*(strongSelf.songArr.count))
                alertController.dismiss(animated: true, completion: nil)
            })
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
            
            alertController.addAction(cancelAction)
            alertController.addAction(addAction)
            alertController.view.tintColor = Constants.Colors.redApp
            strongSelf.present(alertController, animated: true)
        }
    }
    
    @objc func dismissKeyboard5() {
        albumnames = []
        guard !albumArr.contains(chosenAlbum) else {
            mediumImpactGenerator.impactOccurred()
            Utilities.showError2("Album already added.", actionText: "OK")
            return}
        view.endEditing(true)
        DispatchQueue.main.async {[weak self] in
            guard let strongSelf = self else {return}
            alertController = UIAlertController(title: "Select Relationship",
                                                message: "Select the relation this video has with \(strongSelf.chosenAlbum.name)",
                                                preferredStyle: .alert)
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc3 = storyboard.instantiateViewController(identifier: "editPersonRolesPopoverTableViewController") as
            EditPersonRolesPopoverTableViewController
            vc3.preferredContentSize = CGSize(width: 350, height: 200) // 4 default cell heights.
            vc3.roleArr = ["Official Playlist","Other"]
            vc3.tableView.isScrollEnabled = false
            alertController.setValue(vc3, forKey: "contentViewController")
            
            let addAction = UIAlertAction(title: "Select Relation", style: .default, handler: {[weak self] _ in
                guard let strongSelf = self else {return}
                let cc = alertController.value(forKey: "contentViewController") as! EditPersonRolesPopoverTableViewController
                for i in 1 ... (cc.roleArr.count) {
                    let cell = cc.tableViewPopover.cellForRow(at: IndexPath(row: i-1, section: 0)) as! EditRolePopoverTableCellController
                    if cell.checkbox.on {
                        switch cell.role.text! {
                        case "Official Playlist":
                            if !strongSelf.officialRelationArr.contains(strongSelf.chosenAlbum.toneDeafAppId) {
                                strongSelf.officialRelationArr.append(strongSelf.chosenAlbum.toneDeafAppId)
                            }
                        default:
                            break
                        }
                    }
                }
                
                strongSelf.albumArr.append(strongSelf.chosenAlbum)
                strongSelf.albumsTableView.reloadData()
                strongSelf.albumsHeightConstraint.constant = CGFloat(50*(strongSelf.albumArr.count))
                alertController.dismiss(animated: true, completion: nil)
            })
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
            
            alertController.addAction(cancelAction)
            alertController.addAction(addAction)
            alertController.view.tintColor = Constants.Colors.redApp
            strongSelf.present(alertController, animated: true)
        }
    }
    
    @objc func dismissKeyboard6() {
            instrumentalnames = []
        guard !instrumentalArr.contains(chosenInstrumental) else {
            mediumImpactGenerator.impactOccurred()
            Utilities.showError2("Instrumental already added.", actionText: "OK")
            return}
        view.endEditing(true)
        DispatchQueue.main.async {[weak self] in
            guard let strongSelf = self else {return}
            alertController = UIAlertController(title: "Select Relationship",
                                                message: "Select the relation this video has with \(strongSelf.chosenInstrumental.instrumentalName!)",
                                                preferredStyle: .alert)
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc3 = storyboard.instantiateViewController(identifier: "editPersonRolesPopoverTableViewController") as
            EditPersonRolesPopoverTableViewController
            vc3.preferredContentSize = CGSize(width: 350, height: 200) // 4 default cell heights.
            vc3.roleArr = ["Instrumental","Other"]
            vc3.tableView.isScrollEnabled = false
            alertController.setValue(vc3, forKey: "contentViewController")
            
            let addAction = UIAlertAction(title: "Select Relation", style: .default, handler: {[weak self] _ in
                guard let strongSelf = self else {return}
                let cc = alertController.value(forKey: "contentViewController") as! EditPersonRolesPopoverTableViewController
                for i in 1 ... (cc.roleArr.count) {
                    let cell = cc.tableViewPopover.cellForRow(at: IndexPath(row: i-1, section: 0)) as! EditRolePopoverTableCellController
                    if cell.checkbox.on {
                        switch cell.role.text! {
                        case "Instrumental":
                            if !strongSelf.instrumentalRelationArr.contains(strongSelf.chosenInstrumental.toneDeafAppId) {
                                strongSelf.instrumentalRelationArr.append(strongSelf.chosenInstrumental.toneDeafAppId)
                            }
                        default:
                            break
                        }
                    }
                }
                
                strongSelf.instrumentalArr.append(strongSelf.chosenInstrumental)
                strongSelf.instrumaentalsTableView.reloadData()
                strongSelf.instrumentalsHeightConstraint.constant = CGFloat(50*(strongSelf.instrumentalArr.count))
                alertController.dismiss(animated: true, completion: nil)
            })
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
            
            alertController.addAction(cancelAction)
            alertController.addAction(addAction)
            alertController.view.tintColor = Constants.Colors.redApp
            strongSelf.present(alertController, animated: true)
        }
    }
    
    @objc func dismissKeyboard7() {
            beatnames = []
        guard !beatArr.contains(chosenBeat) else {
            mediumImpactGenerator.impactOccurred()
            Utilities.showError2("Beat already added.", actionText: "OK")
            return}
            beatArr.append(chosenBeat)
        beatsTableView.reloadData()
        beatsHeightConstraint.constant = CGFloat(50*(beatArr.count))
            view.endEditing(true)
    }
    
    @objc func dismissKeyboard8() {
        typeTextField.text = chosenType
            view.endEditing(true)
    }

}

extension VideoUploadViewController: UITextFieldDelegate {
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        switch textField {
        case personTextField:
            personArr = []
            personnames = []
            return true
        case videographersTextField:
            videographerArr = []
            videographernames = []
            return true
        case songsTextField:
            songArr = []
            songnames = []
            return true
        case albumsTextField:
            albumArr = []
            albumnames = []
            return true
        case instrumentalsTextField:
            instrumentalArr = []
            instrumentalnames = []
            return true
        case beatsTextField:
            beatArr = []
            beatnames = []
            return true
        case typeTextField:
            chosenType = nil
            return true
        default:
            return true
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        switch textField {
        case videographersTextField:
            chosenVideographer = AllPersonsInDatabaseArray[0]
        case personTextField:
            chosenPerson = AllPersonsInDatabaseArray[0]
        case songsTextField:
            chosenSong = AllSongsInDatabaseArray[0]
        case albumsTextField:
            chosenAlbum = AllAlbumsInDatabaseArray[0]
        case instrumentalsTextField:
            chosenInstrumental = AllInstrumentalsInDatabaseArray[0]
        case beatsTextField:
            chosenBeat = AllBeatsInDatabaseArray[0]
        case typeTextField:
            chosenType = typeArr[0]
        default:
            break
        }
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        switch textField {
        case youtubeTextField:
            if youtubeTextField.text == "" {
                youtubeAddButton.isHidden = true
            }
            else {
                youtubeAddButton.isHidden = false
            }
        case iGTVTextField:
            if iGTVTextField.text == "" {
                iGTVAddButton.isHidden = true
            }
            else {
                iGTVAddButton.isHidden = false
            }
        case instagramPostTextField:
            if instagramPostTextField.text == "" {
                instagramPostAddButton.isHidden = true
            }
            else {
                instagramPostAddButton.isHidden = false
            }
        case facebookPostTextField:
            if facebookPostTextField.text == "" {
                facebookAddButton.isHidden = true
            }
            else {
                facebookAddButton.isHidden = false
            }
        case worldstarTextField:
            if worldstarTextField.text == "" {
                worldstarAddButton.isHidden = true
            }
            else {
                worldstarAddButton.isHidden = false
            }
        case twitterTextField:
            if twitterTextField.text == "" {
                twitterAddButton.isHidden = true
            }
            else {
                twitterAddButton.isHidden = false
            }
        case appleMusicTextField:
            if appleMusicTextField.text == "" {
                appleMusicAddButton.isHidden = true
            }
            else {
                appleMusicAddButton.isHidden = false
            }
        case tikTokTextField:
            if tikTokTextField.text == "" {
                tikTokAddButton.isHidden = true
            }
            else {
                tikTokAddButton.isHidden = false
            }
        default:
            break
        }
    }
    
}

extension VideoUploadViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        var nor = 0
        if pickerView == personPickerView {
           nor = AllPersonsInDatabaseArray.count
        }
        if pickerView == songsPickerView {
           nor = AllSongsInDatabaseArray.count
        }
        if pickerView == albumsPickerView {
           nor = AllAlbumsInDatabaseArray.count
        }
        if pickerView == instrumentalsPickerView {
           nor = AllInstrumentalsInDatabaseArray.count
        }
        if pickerView == beatsPickerView {
           nor = AllBeatsInDatabaseArray.count
        }
        if pickerView == typePickerView {
           nor = typeArr.count
        }
        if pickerView == verificationLevelPickerView {
            nor = verificationLevelArr.count
        }
        return nor
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        var nor = ""
        if pickerView == personPickerView {
           nor = "\(AllPersonsInDatabaseArray[row].name ?? "person") -- \(AllPersonsInDatabaseArray[row].toneDeafAppId)"
        }
        if pickerView == songsPickerView {
            nor = "\(AllSongsInDatabaseArray[row].name ) -- \(AllSongsInDatabaseArray[row].toneDeafAppId)"
        }
        if pickerView == albumsPickerView {
            nor = "\(AllAlbumsInDatabaseArray[row].name ) -- \(AllAlbumsInDatabaseArray[row].toneDeafAppId)"
        }
        if pickerView == instrumentalsPickerView {
            nor = "\(AllInstrumentalsInDatabaseArray[row].instrumentalName!) -- \(AllInstrumentalsInDatabaseArray[row].toneDeafAppId)"
        }
        if pickerView == beatsPickerView {
            nor = "\(AllBeatsInDatabaseArray[row].name ) -- \(AllBeatsInDatabaseArray[row].toneDeafAppId)"
        }
        if pickerView == typePickerView {
            nor = typeArr[row]
        }
        if pickerView == verificationLevelPickerView {
            nor = String(verificationLevelArr[row])
        }
        return nor
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
            if videographersTextField.isFirstResponder {
                chosenVideographer = AllPersonsInDatabaseArray[row]
            }
            if personTextField.isFirstResponder {
                chosenPerson = AllPersonsInDatabaseArray[row]
            }
            if songsTextField.isFirstResponder {
                chosenSong = AllSongsInDatabaseArray[row]
            }
            if albumsTextField.isFirstResponder {
                chosenAlbum = AllAlbumsInDatabaseArray[row]
            }
            if instrumentalsTextField.isFirstResponder {
                chosenInstrumental = AllInstrumentalsInDatabaseArray[row]
            }
            if beatsTextField.isFirstResponder {
                chosenBeat = AllBeatsInDatabaseArray[row]
            }
            if typeTextField.isEditing {
                chosenType = typeArr[row]
            }
        if pickerView == verificationLevelPickerView {
            verificationLevelTextField.text = String(verificationLevelArr[row])
            verificationLevel = verificationLevelArr[row]
        }
    }
    
    func pickerViewToolbar(textField:UITextField, pickerView:UIPickerView) {
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor.init(red: 182/255, green: 0/255, blue: 3/255, alpha: 1)
        toolBar.sizeToFit()

        var doneButton = UIBarButtonItem()
        switch textField {
        case videographersTextField:
            doneButton = UIBarButtonItem(title: "Select", style: UIBarButtonItem.Style.done, target: self, action: #selector(dismissKeyboard2))
        case personTextField:
            doneButton = UIBarButtonItem(title: "Select", style: UIBarButtonItem.Style.done, target: self, action: #selector(dismissKeyboard3))
        case songsTextField:
            doneButton = UIBarButtonItem(title: "Select", style: UIBarButtonItem.Style.done, target: self, action: #selector(dismissKeyboard4))
        case albumsTextField:
            doneButton = UIBarButtonItem(title: "Select", style: UIBarButtonItem.Style.done, target: self, action: #selector(dismissKeyboard5))
        case instrumentalsTextField:
            doneButton = UIBarButtonItem(title: "Select", style: UIBarButtonItem.Style.done, target: self, action: #selector(dismissKeyboard6))
        case beatsTextField:
            doneButton = UIBarButtonItem(title: "Select", style: UIBarButtonItem.Style.done, target: self, action: #selector(dismissKeyboard7))
        case typeTextField:
            doneButton = UIBarButtonItem(title: "Select", style: UIBarButtonItem.Style.done, target: self, action: #selector(dismissKeyboard8))
        case verificationLevelTextField:
            doneButton = UIBarButtonItem(title: "Select", style: UIBarButtonItem.Style.done, target: self, action: #selector(dismissKeyboard))
        default:
            break
        }
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItem.Style.plain, target: self, action: #selector(dismissKeyboard))

        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true

        textField.inputView = pickerView
        textField.inputAccessoryView = toolBar
    }
}

extension VideoUploadViewController : UITableViewDataSource, UITableViewDelegate { 
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch tableView {
        case videographersTableView:
            return videographerArr.count
        case personTableView:
            return personArr.count
        case songsTableView:
            return songArr.count
        case albumsTableView:
            return albumArr.count
        case instrumaentalsTableView:
            return instrumentalArr.count
        case beatsTableView:
            return beatArr.count
        case youtubeTableView:
            return youtubeArr.count
        case iGTVTableView:
            return iGTVArr.count
        case instagramPostTableView:
            return instagramPostArr.count
        case facebookPostTableView:
            return facebookPostArr.count
        case worldstarTableView:
            return worldstarArr.count
        case twitterTableView:
            return twitterArr.count
        case appleMusicTableView:
            return appleMusicArr.count
        case tikTokTableView:
            return tikTokArr.count
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch tableView {
        case videographersTableView:
            let cell = tableView.dequeueReusableCell(withIdentifier: "roleEditSongCell", for: indexPath) as! RoleEditSongCell
            if !videographerArr.isEmpty {
                cell.setUp(person: videographerArr[indexPath.row])
            }
            return cell
        case personTableView:
            let cell = tableView.dequeueReusableCell(withIdentifier: "roleEditSongCell", for: indexPath) as! RoleEditSongCell
            if !personArr.isEmpty {
                cell.setUp(person: personArr[indexPath.row])
            }
            return cell
        case songsTableView:
            let cell = tableView.dequeueReusableCell(withIdentifier: "roleEditSongCell", for: indexPath) as! RoleEditSongCell
            if !songArr.isEmpty {
                cell.setUp(song: songArr[indexPath.row])
            }
            return cell
        case albumsTableView:
            let cell = tableView.dequeueReusableCell(withIdentifier: "roleEditSongCell", for: indexPath) as! RoleEditSongCell
            if !albumArr.isEmpty {
                cell.setUp(album: albumArr[indexPath.row])
            }
            return cell
        case instrumaentalsTableView:
            let cell = tableView.dequeueReusableCell(withIdentifier: "roleEditSongCell", for: indexPath) as! RoleEditSongCell
            if !instrumentalArr.isEmpty {
                cell.setUp(instrumental: instrumentalArr[indexPath.row])
            }
            return cell
        case beatsTableView:
            let cell = tableView.dequeueReusableCell(withIdentifier: "roleEditSongCell", for: indexPath) as! RoleEditSongCell
            if !beatArr.isEmpty {
                cell.setUp(beat: beatArr[indexPath.row])
            }
            return cell
        case youtubeTableView:
            let cell = tableView.dequeueReusableCell(withIdentifier: "urlLabelCell", for: indexPath) as! URLLabelCell
            if !youtubeArr.isEmpty {
                cell.setUp(urlString: youtubeArr[indexPath.row])
            }
            return cell
        case iGTVTableView:
            let cell = tableView.dequeueReusableCell(withIdentifier: "urlLabelCell", for: indexPath) as! URLLabelCell
            if !iGTVArr.isEmpty {
                cell.setUp(urlString: iGTVArr[indexPath.row])
            }
            return cell
        case instagramPostTableView:
            let cell = tableView.dequeueReusableCell(withIdentifier: "urlLabelCell", for: indexPath) as! URLLabelCell
            if !instagramPostArr.isEmpty {
                cell.setUp(urlString: instagramPostArr[indexPath.row])
            }
            return cell
        case facebookPostTableView:
            let cell = tableView.dequeueReusableCell(withIdentifier: "urlLabelCell", for: indexPath) as! URLLabelCell
            if !facebookPostArr.isEmpty {
                cell.setUp(urlString: facebookPostArr[indexPath.row])
            }
            return cell
        case worldstarTableView:
            let cell = tableView.dequeueReusableCell(withIdentifier: "urlLabelCell", for: indexPath) as! URLLabelCell
            if !worldstarArr.isEmpty {
                cell.setUp(urlString: worldstarArr[indexPath.row])
            }
            return cell
        case twitterTableView:
            let cell = tableView.dequeueReusableCell(withIdentifier: "urlLabelCell", for: indexPath) as! URLLabelCell
            if !twitterArr.isEmpty {
                cell.setUp(urlString: twitterArr[indexPath.row])
            }
            return cell
        case appleMusicTableView:
            let cell = tableView.dequeueReusableCell(withIdentifier: "urlLabelCell", for: indexPath) as! URLLabelCell
            if !appleMusicArr.isEmpty {
                cell.setUp(urlString: appleMusicArr[indexPath.row])
            }
            return cell
        case tikTokTableView:
            let cell = tableView.dequeueReusableCell(withIdentifier: "urlLabelCell", for: indexPath) as! URLLabelCell
            if !tikTokArr.isEmpty {
                cell.setUp(urlString: tikTokArr[indexPath.row])
            }
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
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            switch tableView {
            case videographersTableView:
                videographerArr.remove(at: indexPath.row)
                videographersTableView.reloadData()
                videographersHeightConstraint.constant = CGFloat(50*(videographerArr.count))
            case personTableView:
                personArr.remove(at: indexPath.row)
                personTableView.reloadData()
                personHeightConstraint.constant = CGFloat(50*(personArr.count))
            case songsTableView:
                songArr.remove(at: indexPath.row)
                songsTableView.reloadData()
                songsHeightConstraint.constant = CGFloat(50*(songArr.count))
            case albumsTableView:
                albumArr.remove(at: indexPath.row)
                albumsTableView.reloadData()
                albumsHeightConstraint.constant = CGFloat(50*(albumArr.count))
            case instrumaentalsTableView:
                instrumentalArr.remove(at: indexPath.row)
                instrumaentalsTableView.reloadData()
                instrumentalsHeightConstraint.constant = CGFloat(50*(instrumentalArr.count))
            case beatsTableView:
                beatArr.remove(at: indexPath.row)
                beatsTableView.reloadData()
                beatsHeightConstraint.constant = CGFloat(50*(beatArr.count))
            case youtubeTableView:
                youtubeArr.remove(at: indexPath.row)
                youtubeTableView.reloadData()
                youtubeHeightConstraint.constant = CGFloat(50*(youtubeArr.count))
            case iGTVTableView:
                iGTVArr.remove(at: indexPath.row)
                iGTVTableView.reloadData()
                iGTVHeightConstraint.constant = CGFloat(50*(iGTVArr.count))
            case instagramPostTableView:
                instagramPostArr.remove(at: indexPath.row)
                instagramPostTableView.reloadData()
                instagramPostHeightConstraint.constant = CGFloat(50*(instagramPostArr.count))
            case facebookPostTableView:
                facebookPostArr.remove(at: indexPath.row)
                facebookPostTableView.reloadData()
                facebookHeightConstraint.constant = CGFloat(50*(facebookPostArr.count))
            case worldstarTableView:
                worldstarArr.remove(at: indexPath.row)
                worldstarTableView.reloadData()
                worldstarHeightConstraint.constant = CGFloat(50*(worldstarArr.count))
            case appleMusicTableView:
                appleMusicArr.remove(at: indexPath.row)
                appleMusicTableView.reloadData()
                appleMusicHeightConstraint.constant = CGFloat(50*(appleMusicArr.count))
            case tikTokTableView:
                tikTokArr.remove(at: indexPath.row)
                tikTokTableView.reloadData()
                tikTokHeightConstraint.constant = CGFloat(50*(tikTokArr.count))
            default:
                break
            }
        }
    }
    
    
}

import MarqueeLabel

class URLLabelCell: UITableViewCell {
    
    @IBOutlet weak var url: MarqueeLabel!
    
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
    }
    
    func setUp(urlString: String) {
        url.text = urlString
    }
}

public enum VideoUploadErrors: Error {
    case youtubeURLParse
    case twitterURLInvalid
    case appleMusicURLInvalid
}
