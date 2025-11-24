//
//  AlbumUploadViewController.swift
//  ToneDeafDeafinitionsApp
//
//  Created by Tone Deaf on 9/4/20.
//  Copyright © 2020 GITEM Solutions. All rights reserved.
//

import UIKit
import FirebaseDatabase

class AlbumUploadViewController: UIViewController {

    var albumName = ""
    var mainArtist:[String] = []
    var mainArtistsNames:[String] = []
    var allArtists:[String] = []
    var allArtistsNames:[String] = []
    var albumProducers:Array<String> = []
    var albumProducerNames:[String] = []
    var albumWriters:Array<String> = []
    var albumWriterNames:[String] = []
    var albumMixEngineers:Array<String> = []
    var albumMixEngineerNames:[String] = []
    var albumMasteringEngineers:Array<String> = []
    var albumMasteringEngineerNames:[String] = []
    var albumRecordingEngineers:Array<String> = []
    var albumRecordingEngineerNames:[String] = []
    var instrumentals:[String] = []
    var songIds:[String] = []
    //var songs = [String : String]()
    var videos:[String] = []
    var date:Date!
    var tDAppId = ""
    var chosenArtist = ""
    var chosenArtistNames = ""
    var artistref:[String] = []
    var chosenSong = ""
    var chosenSongName = ""
    var producerref:[String] = []
    var chosenTrackNumber = ""
    
    let semaphore = DispatchSemaphore(value: 0)
    let asemaphore = DispatchSemaphore(value: 1)
    
    var currtime = ""
    var currdate = ""
    var albumCategory = ""
    
    var albumUploadVideos:[String] = []
    
    var albumuploadCompletionStatus1:Bool!
    var albumuploadCompletionStatus2:Bool!
    var albumuploadCompletionStatus3:Bool!
    var albumuploadCompletionStatus4:Bool!
    var albumuploadCompletionStatus5:Bool!
    var albumuploadCompletionStatus6:Bool!
    var albumuploadCompletionStatus7:Bool!
    
    var personPickerView = UIPickerView()
    var songsPickerView = UIPickerView()
    var instrumentalsPickerView = UIPickerView()
    var deluxeOfPickerView = UIPickerView()
    var otherVersionsOfPickerView = UIPickerView()
    var loadcount = 0
    var height:CGFloat = 110
    let numbers = Array(0...35)
    var artistEditing = false
    
    var verificationLevelPickerView = UIPickerView()
    var verificationLevelArr:[Character] = Constants.Verification.verificationLevels
    var verificationLevel:Character!
    
    var industryCertified:Bool = false
    
    var progressView:UIProgressView!
    var totalProgress:Float = 7
    var basealbumProgress:Float = 0
    var progressCompleted:Float = 0
    var alertView:UIAlertController!
    
    var songcount = 0
    var songsdone = 0
    
    var deluxeAlbum = false
    var deluxeOf:String!
    var deluxeHold:[String]!
    var otherVersionsAlbum = false
    var otherVersionsOf:String!
    var otherVersionsHold:[String]!
    
    @IBOutlet weak var tableViewHeightConstraint: NSLayoutConstraint!
    
    
    @IBOutlet weak var songsTableView: UITableView!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var hiddenTextField: UITextField!
    let hiddenTextFieldI =  UITextField(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    @IBOutlet weak var albumNameTextField: UITextField! {
        didSet {
            let placeholderText = NSAttributedString(string: "Name",
                                                     attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray.withAlphaComponent(0.4)])
            
            albumNameTextField.attributedPlaceholder = placeholderText
        }
    }
    @IBOutlet weak var mainArtistTextField: UITextField! {
        didSet {
            let placeholderText = NSAttributedString(string: "Artist",
                                                     attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray.withAlphaComponent(0.4)])
            
            mainArtistTextField.attributedPlaceholder = placeholderText
        }
    }
    @IBOutlet weak var youtubeTextField: UITextField!{
        didSet {
            let placeholderText = NSAttributedString(string: "URL",
                                                     attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray.withAlphaComponent(0.4)])
            
            youtubeTextField.attributedPlaceholder = placeholderText
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
            let placeholderText = NSAttributedString(string: "album/",
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
    @IBOutlet weak var deluxeControl: UISegmentedControl!
    @IBOutlet weak var deluxeOfStackView: UIStackView!
    @IBOutlet weak var deluxeOfTextField: UITextField!{
        didSet {
            let placeholderText = NSAttributedString(string: "If album has standard edition in app",
                                                     attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray.withAlphaComponent(0.4)])
            
            deluxeOfTextField.attributedPlaceholder = placeholderText
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        creatObservers()
        songsTableView.delegate = self
        songsTableView.dataSource = self
        dismissKeyboardOnTap()
        setUpElements()
        if loadcount == 0 {
            DatabaseManager.shared.fetchAllPersonsFromDatabase(completion: { person in
                AllPersonsInDatabaseArray = person
            })
        }
        if loadcount == 0 {
            DatabaseManager.shared.fetchAllSongsFromDatabase(completion: {songs in
                AllSongsInDatabaseArray = songs
            })
        }
        if loadcount == 0 {
            DatabaseManager.shared.fetchAllAlbumsFromDatabase(completion: {songs in
                AllAlbumsInDatabaseArray = songs
            })
        }
        if loadcount == 0 {
            DatabaseManager.shared.fetchAllInstrumentalsFromDatabase(completion: {songs in
                AllInstrumentalsInDatabaseArray = songs
            })
        }
        // call the 'keyboardWillShow' function when the view controller receive the notification that a keyboard is going to be shown
            NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
          
              // call the 'keyboardWillHide' function when the view controlelr receive notification that keyboard is going to be hidden
            NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func deleteDurks() {
        Database.database().reference().child("Music Content").child("Songs").observeSingleEvent(of: .value, with: { snapshot in
            for child in snapshot.children {
                let data = child as! DataSnapshot
                let key = data.key
                if key.contains("Lil Durk") {
                    Database.database().reference().child("Music Content").child("Songs").child(key).removeValue()
                }
                
            }
        })
        //Database.database().reference().child("Music Content").child("Albums").removeValue()
        
        Database.database().reference().child("Registered Artists").child("Lil Durk--August 28, 2020--16:19:43 PM--561668").child("Albums").setValue([])
        //Database.database().reference().child("Registered Artists").child("Lil Durk--August 28, 2020--16:19:43 PM--561668").child("Songs").removeValue()
        Database.database().reference().child("Registered Artists").child("Lil Durk--August 28, 2020--16:19:43 PM--561668").child("Songs").setValue([])
        //Database.database().reference().child("Registered Artists").child("Lil Durk--August 28, 2020--16:19:43 PM--561668").child("Videos").removeValue()
        Database.database().reference().child("Registered Artists").child("Lil Durk--August 28, 2020--16:19:43 PM--561668").child("Videos").setValue([])
        
        
        Database.database().reference().child("Registered Producers").child("HighXlass Kash--September 05, 2020--17:40:53 PM--53687").child("Albums").setValue([])
        //Database.database().reference().child("Registered Producers").child("HighXlass Kash--September 05, 2020--17:40:53 PM--53687").child("Songs").removeValue()
        Database.database().reference().child("Registered Producers").child("HighXlass Kash--September 05, 2020--17:40:53 PM--53687").child("Songs").setValue([])
        //Database.database().reference().child("Registered Producers").child("HighXlass Kash--September 05, 2020--17:40:53 PM--53687").child("Videos").removeValue()
        Database.database().reference().child("Registered Producers").child("HighXlass Kash--September 05, 2020--17:40:53 PM--53687").child("Videos").setValue([])
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
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        tableViewHeightConstraint.constant = songsTableView.contentSize.height
    }
    
    func setUpElements() {
        Utilities.styleTextField(youtubeTextField)
        Utilities.styleTextField(spotifyTextField)
        Utilities.styleTextField(albumNameTextField)
        Utilities.styleTextField(mainArtistTextField)
        Utilities.styleTextField(appleMusicTextField)
        Utilities.styleTextField(souncloudTextField)
        Utilities.styleTextField(youtubeMusicTextField)
        Utilities.styleTextField(amazonTextField)
        Utilities.styleTextField(deezerTextField)
        Utilities.styleTextField(tidalTextField)
        Utilities.styleTextField(napsterTextField)
        Utilities.styleTextField(spinrillaTextField)
        addBottomLineToText(youtubeTextField)
        addBottomLineToText(spotifyTextField)
        addBottomLineToText(mainArtistTextField)
        addBottomLineToText(albumNameTextField)
        addBottomLineToText(appleMusicTextField)
        addBottomLineToText(souncloudTextField)
        addBottomLineToText(youtubeMusicTextField)
        addBottomLineToText(amazonTextField)
        addBottomLineToText(deezerTextField)
        addBottomLineToText(tidalTextField)
        addBottomLineToText(napsterTextField)
        addBottomLineToText(spinrillaTextField)
        youtubeTextField.delegate = self
        spotifyTextField.delegate = self
        mainArtistTextField.delegate = self
        appleMusicTextField.delegate = self
        albumNameTextField.delegate = self
        souncloudTextField.delegate = self
        youtubeMusicTextField.delegate = self
        amazonTextField.delegate = self
        deezerTextField.delegate = self
        tidalTextField.delegate = self
        napsterTextField.delegate = self
        spinrillaTextField.delegate = self
        
        Utilities.styleTextField(verificationLevelTextField)
        addBottomLineToText(verificationLevelTextField)
        verificationLevelTextField.delegate = self
        
        Utilities.styleTextField(deluxeOfTextField)
        addBottomLineToText(deluxeOfTextField)
        deluxeOfTextField.delegate = self
        
        Utilities.styleTextField(otherVersionsOfTextField)
        addBottomLineToText(otherVersionsOfTextField)
        otherVersionsOfTextField.delegate = self
        
        hiddenTextField.inputView = songsPickerView
        songsPickerView.delegate = self
        songsPickerView.dataSource = self
        pickerViewToolbar(textField: hiddenTextField, pickerView: songsPickerView)
        
        hiddenTextFieldI.inputView = instrumentalsPickerView
        instrumentalsPickerView.delegate = self
        instrumentalsPickerView.dataSource = self
        pickerViewToolbar(textField: hiddenTextFieldI, pickerView: instrumentalsPickerView)
        view.addSubview(hiddenTextFieldI)
        
        mainArtistTextField.inputView = personPickerView
        personPickerView.delegate = self
        personPickerView.dataSource = self
        pickerViewToolbar(textField: mainArtistTextField, pickerView: personPickerView)
        
        verificationLevelTextField.inputView = verificationLevelPickerView
        verificationLevelPickerView.delegate = self
        verificationLevelPickerView.dataSource = self
        pickerViewToolbar(textField: verificationLevelTextField, pickerView: verificationLevelPickerView)
        textFieldShouldClear(verificationLevelTextField)
        
        deluxeOfTextField.inputView = deluxeOfPickerView
        deluxeOfPickerView.delegate = self
        deluxeOfPickerView.dataSource = self
        pickerViewToolbar(textField: deluxeOfTextField, pickerView: deluxeOfPickerView)
        textFieldShouldClear(deluxeOfTextField)
        
        otherVersionsOfTextField.inputView = otherVersionsOfPickerView
        otherVersionsOfPickerView.delegate = self
        otherVersionsOfPickerView.dataSource = self
        pickerViewToolbar(textField: otherVersionsOfTextField, pickerView: otherVersionsOfPickerView)
        textFieldShouldClear(otherVersionsOfTextField)
        
        mainArtistTextField.delegate = self
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
        print("📗 Album Upload being deallocated from memory. OS reclaiming")
    }
    
    func creatObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(songAdded(notification:)), name: AlbumNewSongAddedNotify, object: nil)
    }
    
    @objc func songAdded(notification: Notification) {
        let song = notification.object as! AlbumUploadSongData
        guard let tracknum = Int(song.trackNumber) else {
            Utilities.showError2("Error converting track number for \(song.name) to int. at 1.", actionText: "OK")
            return
        }
        let fullsong = AlbumSong(trackNumber: tracknum, song: song)
        if updateIndex == 100000 {
            albumUploadSongsArray.append(fullsong)
        } else {
            albumUploadSongsArray[updateIndex] = fullsong
            updateIndex = 100000
        }
        songsTableView.reloadData()
        tableViewHeightConstraint.constant = songsTableView.contentSize.height
        view.layoutSubviews()
    }
    @IBAction func mainArtistTextField(_ sender: Any) {
       
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
    
    @IBAction func deluxeChanged(_ sender: Any) {
        lightImpactGenerator.impactOccurred(intensity: 0.75)
        if deluxeControl.selectedSegmentIndex == 1 {
            deluxeControl.selectedSegmentTintColor = .systemGreen
            deluxeAlbum = true
            deluxeOfStackView.isHidden = false
            //true
        } else {
            deluxeControl.selectedSegmentTintColor = Constants.Colors.redApp
            deluxeAlbum = false
            deluxeOf = nil
            deluxeOfTextField.text = ""
            //false
            deluxeOfStackView.isHidden = true
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
        mediumImpactGenerator.impactOccurred()
        guard albumNameTextField.text != "" else {
            Utilities.showError2("Album name required"  ,actionText: "Ok")
            return
        }
        guard mainArtistTextField.text != "" else {
            mediumImpactGenerator.impactOccurred()
            Utilities.showError2("Album main artist required"  ,actionText: "Ok")
            return
        }
        guard !albumUploadSongsArray.isEmpty else {
            mediumImpactGenerator.impactOccurred()
            Utilities.showError2("Album songs required"  ,actionText: "Ok")
            return
        }
        guard verificationLevelTextField.text != "" else {
            mediumImpactGenerator.impactOccurred()
            Utilities.showError2("Verification Level required"  ,actionText: "Ok")
            return
        }
        albumName = albumNameTextField.text!.trimTrailingWhiteSpace()
        generateAppId()
        
    }
    
    func generateAppId() {
        let genid = StorageManager.shared.generateRandomNumber(digits: 8)
        DatabaseManager.shared.checkIfAppIdExists(appid: genid, completion: { [weak self] result in
            guard let strongSelf = self else {return}
            //print(result)
            
            if result == true {
                strongSelf.generateAppId()
                
            } else {
                strongSelf.tDAppId = genid
                strongSelf.gatherUploadData()
                //print(strongSelf.tDAppId)
                
            }
        })
    }
    
    func gatherUploadData() {
        for song in albumUploadSongsArray {
            switch song.song {
            case is AlbumUploadSongData:
                let track = song.song as! AlbumUploadSongData
                if track.instrumental != "" {
                    instrumentals.append(track.instrumental)
                } else {
                    
                }
            case is String:
                let track = song.song as! String
                if track.count == 12 {
                    instrumentals.append(track)
                }
            default:
                print("jfhgdfg")
            }
        }
        for song in albumUploadSongsArray {
            songcount+=1
            switch song.song {
            case is AlbumUploadSongData:
                let track = song.song as! AlbumUploadSongData
                if track.toneDeafAppId != "" {
                    if !songIds.contains("\(track.toneDeafAppId)") {
                        songIds.append("\(track.toneDeafAppId)")
                    }
                }
            case is String:
                let track = song.song as! String
                if track.count == 10 {
                    songIds.append(track)
                }
                
            default:
                print("jfhgdfg")
            }
        }
        
        for song in albumUploadSongsArray {
            switch song.song {
            case is AlbumUploadSongData:
                let track = song.song as! AlbumUploadSongData
                for artist in track.artists {
                    if !allArtists.contains(artist) {
                        if artist.count > 5 {
                            allArtists.append(artist)
                        }
                    }
                }
            case is String:
                let track = song.song as! String
                switch track.count {
                case 10:
                    DatabaseManager.shared.findSongById(songId: track, completion: {[weak self] result in
                        guard let strongSelf = self else {return}
                        switch result {
                        case .success(let song):
                            for artist in song.songArtist {
                                if !strongSelf.allArtists.contains(artist) {
                                    if artist.count > 5 {
                                        strongSelf.allArtists.append(artist)
                                    }
                                }
                            }
                        case .failure(let err):
                            print(err, "otayyyyyyyyyyy")
                        }
                    })
                case 12:
                    DatabaseManager.shared.findInstrumentalById(instrumentalId: track, completion: {[weak self] result in
                        guard let strongSelf = self else {return}
                        switch result {
                        case .success(let song):
                            if song.artist != nil {
                                for artist in song.artist! {
                                    if !strongSelf.allArtists.contains(artist) {
                                        if artist.count > 5 {
                                            strongSelf.allArtists.append(artist)
                                        }
                                    }
                                }
                            }
                        case .failure(let err):
                            print(err, "otayyyyyyyyyyy")
                        }
                    })
                default:
                    break
                }
                
            default:
                print("jfhgdfg")
            }
        }
        for song in albumUploadSongsArray {
            switch song.song {
            case is AlbumUploadSongData:
                let track = song.song as! AlbumUploadSongData
                for producer in track.producers {
                    if !albumProducers.contains(producer) {
                        albumProducers.append(producer)
                    }
                }
            case is String:
                let track = song.song as! String
                switch track.count {
                case 10:
                    DatabaseManager.shared.findSongById(songId: track, completion: {[weak self] result in
                        guard let strongSelf = self else {return}
                        switch result {
                        case .success(let song):
                            for artist in song.songProducers {
                                if !strongSelf.albumProducers.contains(artist) {
                                        strongSelf.albumProducers.append(artist)
                                }
                            }
                        case .failure(let err):
                            print(err, "otayyyyyyyyyyy")
                        }
                    })
                case 12:
                    DatabaseManager.shared.findInstrumentalById(instrumentalId: track, completion: {[weak self] result in
                        guard let strongSelf = self else {return}
                        switch result {
                        case .success(let song):
                            for artist in song.producers {
                                if !strongSelf.albumProducers.contains(artist) {
                                        strongSelf.albumProducers.append(artist)
                                }
                            }
                        case .failure(let err):
                            print(err, "otayyyyyyyyyyy")
                        }
                    })
                default:
                    break
                }
                
            default:
                print("jfhgdfg")
            }
        }
        for song in albumUploadSongsArray {
            switch song.song {
            case is AlbumUploadSongData:
                let track = song.song as! AlbumUploadSongData
                if let songWriters = track.writers {
                    for writers in songWriters {
                        if !albumWriters.contains(writers) {
                            albumWriters.append(writers)
                        }
                    }
                }
            case is String:
                let track = song.song as! String
                switch track.count {
                case 10:
                    DatabaseManager.shared.findSongById(songId: track, completion: {[weak self] result in
                        guard let strongSelf = self else {return}
                        switch result {
                        case .success(let song):
                            if song.songWriters != nil {
                                for artist in song.songWriters! {
                                    if !strongSelf.albumWriters.contains(artist) {
                                            strongSelf.albumWriters.append(artist)
                                    }
                                }
                            }
                        case .failure(let err):
                            print(err, "otayyyyyyyyyyy")
                        }
                    })
                default:
                    break
                }
            default:
                print("jfhgdfg")
            }
        }
        for song in albumUploadSongsArray {
            switch song.song {
            case is AlbumUploadSongData:
                let track = song.song as! AlbumUploadSongData
                if let songEngie = track.mixEngineers {
                    for engie in songEngie {
                        if !albumMixEngineers.contains(engie) {
                            albumMixEngineers.append(engie)
                        }
                    }
                }
            case is String:
                let track = song.song as! String
                switch track.count {
                case 10:
                    DatabaseManager.shared.findSongById(songId: track, completion: {[weak self] result in
                        guard let strongSelf = self else {return}
                        switch result {
                        case .success(let song):
                            if song.songMixEngineer != nil {
                                for artist in song.songMixEngineer! {
                                    if !strongSelf.albumMixEngineers.contains(artist) {
                                            strongSelf.albumMixEngineers.append(artist)
                                    }
                                }
                            }
                        case .failure(let err):
                            print(err, "otayyyyyyyyyyy")
                        }
                    })
                case 12:
                    DatabaseManager.shared.findInstrumentalById(instrumentalId: track, completion: {[weak self] result in
                        guard let strongSelf = self else {return}
                        switch result {
                        case .success(let song):
                            if song.mixEngineer != nil {
                                for artist in song.mixEngineer! {
                                    if !strongSelf.albumMixEngineers.contains(artist) {
                                            strongSelf.albumMixEngineers.append(artist)
                                    }
                                }
                            }
                        case .failure(let err):
                            print(err, "otayyyyyyyyyyy")
                        }
                    })
                default:
                    break
                }
            default:
                print("jfhgdfg")
            }
        }
        for song in albumUploadSongsArray {
            switch song.song {
            case is AlbumUploadSongData:
                let track = song.song as! AlbumUploadSongData
                if let songEngie = track.masteringEngineers {
                    for engie in songEngie {
                        if !albumMasteringEngineers.contains(engie) {
                            albumMasteringEngineers.append(engie)
                        }
                    }
                }
            case is String:
                let track = song.song as! String
                switch track.count {
                case 10:
                    DatabaseManager.shared.findSongById(songId: track, completion: {[weak self] result in
                        guard let strongSelf = self else {return}
                        switch result {
                        case .success(let song):
                            if song.songMasteringEngineer != nil {
                                for artist in song.songMasteringEngineer! {
                                    if !strongSelf.albumMasteringEngineers.contains(artist) {
                                            strongSelf.albumMasteringEngineers.append(artist)
                                    }
                                }
                            }
                        case .failure(let err):
                            print(err, "otayyyyyyyyyyy")
                        }
                    })
                case 12:
                    DatabaseManager.shared.findInstrumentalById(instrumentalId: track, completion: {[weak self] result in
                        guard let strongSelf = self else {return}
                        switch result {
                        case .success(let song):
                            if song.masteringEngineer != nil {
                                for artist in song.masteringEngineer! {
                                    if !strongSelf.albumMasteringEngineers.contains(artist) {
                                            strongSelf.albumMasteringEngineers.append(artist)
                                    }
                                }
                            }
                        case .failure(let err):
                            print(err, "otayyyyyyyyyyy")
                        }
                    })
                default:
                    break
                }
            default:
                print("jfhgdfg")
            }
        }
        for song in albumUploadSongsArray {
            switch song.song {
            case is AlbumUploadSongData:
                let track = song.song as! AlbumUploadSongData
                if let songEngie = track.recordingEngineers {
                    for engie in songEngie {
                        if !albumRecordingEngineers.contains(engie) {
                            albumRecordingEngineers.append(engie)
                        }
                    }
                }
            case is String:
                let track = song.song as! String
                switch track.count {
                case 10:
                    DatabaseManager.shared.findSongById(songId: track, completion: {[weak self] result in
                        guard let strongSelf = self else {return}
                        switch result {
                        case .success(let song):
                            if song.songRecordingEngineer != nil {
                                for artist in song.songRecordingEngineer! {
                                    if !strongSelf.albumRecordingEngineers.contains(artist) {
                                            strongSelf.albumRecordingEngineers.append(artist)
                                    }
                                }
                            }
                        case .failure(let err):
                            print(err, "otayyyyyyyyyyy")
                        }
                    })
                default:
                    break
                }
            default:
                print("jfhgdfg")
            }
        }
        getAlbumData()
    }
    
    func getAlbumData() {
        var uploadDataArray:[String:Any?] = [:]
        let zqueue = DispatchQueue(label: "myhjalbumsongshikhQueue")
        let zgroup = DispatchGroup()
        let array = [1,4,5,6,7]
        for i in array {
            //print(i)
            zgroup.enter()
            zqueue.async { [weak self] in
                guard let strongSelf = self else {return}
                switch i {
                case 1:
                    strongSelf.youtubeOfficialAlbum(completion: { data,error,done in
                        if done == false {
                            guard let error = error else {return}
                            Utilities.showError2("Youtube Official Album upload Failed: \(error)", actionText: "OK")
                            strongSelf.albumuploadCompletionStatus1 = false
                        }
                        else {
                            if data == nil {
                                uploadDataArray[youtubePlaylistContentType] = nil
                                strongSelf.albumuploadCompletionStatus1 = true
                                print("album Youtube Official graphing done \(i)")
                            } else {
                                uploadDataArray[youtubePlaylistContentType] = data
                                strongSelf.albumuploadCompletionStatus1 = true
                                print("album Youtube Official graphing done \(i)")
                            }
                        }
                        zgroup.leave()
                    })
                case 4:
                    strongSelf.spotifyAlbum(completion: { data,error,done in
                        if done == false {
                            guard let error = error else {return}
                            Utilities.showError2("Spotify Album upload Failed: \(error)", actionText: "OK")
                            strongSelf.albumuploadCompletionStatus4 = false
                        }
                        else {
                            if data == nil {
                                uploadDataArray["Spotify"] = nil
                                strongSelf.albumuploadCompletionStatus4 = true
                                print("album Spotify graphing done \(i)")
                            } else {
                                uploadDataArray["Spotify"] = data
                                strongSelf.albumuploadCompletionStatus4 = true
                                print("album Spotify graphing done \(i)")
                            }
                        }
                        zgroup.leave()
                    })
                case 5:
                strongSelf.appleAlbum(completion: { data,error,done in
                    if done == false {
                        guard let error = error else {return}
                        Utilities.showError2("Apple Album upload Failed: \(error)", actionText: "OK")
                        strongSelf.albumuploadCompletionStatus5 = false
                    }
                    else {
                        if data == nil {
                            uploadDataArray["Apple"] = nil
                            strongSelf.albumuploadCompletionStatus5 = true
                            print("album Apple graphing done \(i)")
                        } else {
                            uploadDataArray["Apple"] = data
                            strongSelf.albumuploadCompletionStatus5 = true
                            print("album Apple graphing done \(i)")
                        }
                    }
                    zgroup.leave()
                })
                case 6:
                strongSelf.deezerAlbum(completion: { data,error,done in
                    if done == false {
                        guard let error = error else {return}
                        Utilities.showError2("Deezer Album upload Failed: \(error)", actionText: "OK")
                        strongSelf.albumuploadCompletionStatus6 = false
                    }
                    else {
                        if data == nil {
                            uploadDataArray["Deezer"] = nil
                            strongSelf.albumuploadCompletionStatus6 = true
                            print("album deezer graphing done \(i)")
                        } else {
                            uploadDataArray["Deezer"] = data
                            strongSelf.albumuploadCompletionStatus6 = true
                            print("album deezer graphing done \(i)")
                        }
                    }
                    zgroup.leave()
                })
                case 7:
                    strongSelf.albumuploadCompletionStatus7 = false
                    DispatchQueue.main.async {
                        if strongSelf.souncloudTextField.text == "", strongSelf.souncloudTextField.text!.count < 15 {
                            uploadDataArray[soundcloudMusicContentType] = nil
                        } else {
                            let url = strongSelf.souncloudTextField.text
                            let data = SoundcloudAlbumData(url: url!, imageurl: nil, releaseDate: nil, isActive: false)
                            uploadDataArray[soundcloudMusicContentType] = data
                        }
                        if strongSelf.youtubeMusicTextField.text == "", strongSelf.youtubeMusicTextField.text!.count < 15 {
                            uploadDataArray[youtubeMusicContentType] = nil
                        } else {
                            let url = strongSelf.youtubeMusicTextField.text
                            let data = YoutubeMusicAlbumData(url: url!,imageurl: nil, isActive: false)
                            uploadDataArray[youtubeMusicContentType] = data
                        }
                        if strongSelf.amazonTextField.text == "", strongSelf.amazonTextField.text!.count < 15 {
                            uploadDataArray[amazonMusicContentType] = nil
                        } else {
                            let url = strongSelf.amazonTextField.text
                            let data = AmazonAlbumData(url: url!, imageurl: nil, isActive: false)
                            uploadDataArray[amazonMusicContentType] = data
                        }
                        if strongSelf.spinrillaTextField.text == "", strongSelf.spinrillaTextField.text!.count < 15 {
                            uploadDataArray[spinrillaMusicContentType] = nil
                        } else {
                            let url = strongSelf.spinrillaTextField.text
                            let data = SpinrillaAlbumData(url: url!, imageurl: nil, releaseDate: nil, isActive: false)
                            uploadDataArray[spinrillaMusicContentType] = data
                        }
                        if strongSelf.napsterTextField.text == "", strongSelf.napsterTextField.text!.count < 15 {
                            uploadDataArray[napsterMusicContentType] = nil
                        } else {
                            let url = strongSelf.napsterTextField.text
                            let data = NapsterAlbumData(url: url!, imageurl: nil, isActive: false)
                            uploadDataArray[napsterMusicContentType] = data
                        }
                        if strongSelf.tidalTextField.text == "", strongSelf.tidalTextField.text!.count < 15 {
                            uploadDataArray[tidalMusicContentType] = nil
                        } else {
                            let url = strongSelf.tidalTextField.text
                            let data = TidalAlbumData(url: url!, imageurl: nil, isActive: false)
                            uploadDataArray[tidalMusicContentType] = data
                        }
                    }
                    strongSelf.albumuploadCompletionStatus7 = true
                    print("\(strongSelf.albumName) other graphing done \(i)")
                    zgroup.leave()
                default:
                    print("album oopsie")
                }
                
            }
            
        }
        zgroup.notify(queue: DispatchQueue.main) {[weak self] in
            guard let strongSelf = self else {return}
            if strongSelf.albumuploadCompletionStatus1 == false || strongSelf.albumuploadCompletionStatus4 == false || strongSelf.albumuploadCompletionStatus5 == false || strongSelf.albumuploadCompletionStatus6 == false || strongSelf.albumuploadCompletionStatus7 == false {
                Utilities.showError2("Upload Failed.", actionText: "OK")
                return
            } else {
                strongSelf.uploadAlbumToDatabase(uploadArray: uploadDataArray)
            }
        }
    }
    
    func youtubeOfficialAlbum(completion: @escaping (YouTubeData?, Error?, Bool) -> Void) {
        DispatchQueue.main.async {[weak self] in
            guard let strongSelf = self else {return}
            guard strongSelf.youtubeTextField.text != "" else {
                completion(nil, nil, true)
                return}
            guard strongSelf.youtubeTextField.text!.count > 15 else {
                let error = AlbumUploadTextFieldErrors.invalidURL
                completion(nil, error, false)
                return}
            guard let url = strongSelf.youtubeTextField.text else {return}
            var videoId = url
            if let range = videoId.range(of: "=") {
                videoId.removeSubrange(videoId.startIndex..<range.lowerBound)
            }
            let albumId = String(videoId.dropFirst())
            //print(videoId)
            
            strongSelf.generateVideoAppId(completion: { vidAppId in
                //strongSelf.videos.append(vidAppId)
                YoutubeRequest.shared.getVideos(playlistId: albumId, url: url, tdAppId: vidAppId, completion: { result in
                    switch result {
                    case.success(let video):
                        
                        strongSelf.videos.append("\(vidAppId)")
                        Database.database().reference().child("All Content IDs").observeSingleEvent(of: .value, with: { snap in
                            var arr = snap.value as! [String]
                            if !arr.contains("\(vidAppId)") {
                                arr.append("\(vidAppId)")
                            }
                            Database.database().reference().child("All Content IDs").setValue(arr)
                        })
                    
                        Database.database().reference().child("Music Content").child("Videos").child("All Video IDs").observeSingleEvent(of: .value, with: { snap in
                            var arr = snap.value as! [String]
                            if !arr.contains("\(vidAppId)") {
                                arr.append("\(vidAppId)")
                            }
                            Database.database().reference().child("Music Content").child("Videos").child("All Video IDs").setValue(arr)
                        })
                        completion(video, nil, true)
                    case .failure(let error):
                        print(error)
                        completion(nil, error, false)
                    }
                })
            })
        }
    }
    
    func spotifyAlbum(completion: @escaping (SpotifyAlbumData?, Error?, Bool) -> Void) {
        DispatchQueue.main.async {[weak self] in
            guard let strongSelf = self else {return}
            guard strongSelf.spotifyTextField.text != "" else {
                completion(nil, nil, true)
                return}
            guard strongSelf.spotifyTextField.text!.count > 15 else {
                let error = AlbumUploadTextFieldErrors.invalidURL
                completion(nil, error, false)
                return}
            var spotUrl = strongSelf.spotifyTextField.text!
            if let dotRange = spotUrl.range(of: "?") {
                spotUrl.removeSubrange(dotRange.lowerBound..<spotUrl.endIndex)
            }
            let albumId = String(spotUrl.suffix(22))
            let token = (UserDefaults.standard.object(forKey: "SPTaccesstoken") as? String)!
            SpotifyRequest.shared.getAlbumInfo(accessToken: token, id: albumId, completion: { result in
                switch result {
                case.success(let spotify):
                    completion(spotify, nil, true)
                case .failure(let error):
                    print(error)
                    completion(nil, error, false)
                }
            })
        }
    }
    
    func appleAlbum(completion: @escaping (AppleAlbumData?, Error?, Bool) -> Void) {
        DispatchQueue.main.async {[weak self] in
            guard let strongSelf = self else {return}
            guard strongSelf.appleMusicTextField.text != "" else {
                completion(nil, nil, true)
                return}
            guard strongSelf.appleMusicTextField.text!.count > 15 else {
                let error = AlbumUploadTextFieldErrors.invalidURL
                completion(nil, error, false)
                return}
            let albumId = String((strongSelf.appleMusicTextField.text?.suffix(10))!)
            AppleMusicRequest.shared.getAppleMusicAlbum(id: albumId, completion: { result in
                switch result {
                case.success(let apple):
                    completion(apple, nil, true)
                case .failure(let error):
                    print(error)
                    completion(nil, error, false)
                }
            })
        }
    }
    
    func deezerAlbum(completion: @escaping (DeezerAlbumData?, Error?, Bool) -> Void) {
        DispatchQueue.main.async {[weak self] in
            guard let strongSelf = self else {return}
            guard strongSelf.deezerTextField.text != "" else {
                completion(nil, nil, true)
                return}
            guard strongSelf.deezerTextField.text!.count > 15 else {
                let error = AlbumUploadTextFieldErrors.invalidURL
                completion(nil, error, false)
                return}
            guard strongSelf.deezerTextField.text!.contains("album/") && strongSelf.deezerTextField.text!.contains("deezer.com") else {
                let error = AlbumUploadTextFieldErrors.invalidURL
                Utilities.showError2("Please enter a valid Deezer url..", actionText: "OK")
                completion(nil, error, false)
                return
            }
            var deezUrl = strongSelf.deezerTextField.text!
            if let dotRange = deezUrl.range(of: "?") {
                deezUrl.removeSubrange(dotRange.lowerBound..<deezUrl.endIndex)
            }
            if let range = deezUrl.range(of: "album/") {
                deezUrl.removeSubrange(deezUrl.startIndex..<range.lowerBound)
            }
            let albumId = String(deezUrl.dropFirst(6))
            DeezerRequest.shared.getDeezerAlbum(id: albumId, completion: { result in
                switch result {
                case.success(let apple):
                    completion(apple, nil, true)
                case .failure(let error):
                    print(error)
                    completion(nil, error, false)
                }
            })
        }
    }
    
    func uploadAlbumToDatabase(uploadArray: [String:Any?]) {
        date = Date()
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "HH:mm:ss a"
        timeFormatter.timeZone = TimeZone(identifier: "EDT")
        currtime = timeFormatter.string(from: date)
        
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone(identifier: "EDT")
        formatter.dateFormat = "MMMM dd, yyyy"
        currdate = formatter.string(from: date)
        
        albumCategory = "\(albumContentTag)--\(albumName)--\(tDAppId)"
        var albumdatabaseuploadCompletionStatus1:Bool!
        var albumdatabaseuploadCompletionStatus2:Bool!
        var albumdatabaseuploadCompletionStatus3:Bool!
        var albumdatabaseuploadCompletionStatus4:Bool!
        var albumdatabaseuploadCompletionStatus5:Bool!
        var albumdatabaseuploadCompletionStatus6:Bool!
        var albumdatabaseuploadCompletionStatus7:Bool!
        var albumdatabaseuploadCompletionStatus8:Bool!
        var albumdatabaseuploadCompletionStatus9:Bool!
        var albumdatabaseuploadCompletionStatus10:Bool!
        var albumdatabaseuploadCompletionStatus11:Bool!
        var albumdatabaseuploadCompletionStatus12:Bool!
        var albumdatabaseuploadCompletionStatus13:Bool!
        var albumdatabaseuploadCompletionStatus14:Bool!
        var albumdatabaseuploadCompletionStatus15:Bool!
        var grouparray:[Int] = [1]
        var ytvdData:YouTubeData!
        var spotifyData:SpotifyAlbumData!
        var appleData:AppleAlbumData!
        var soundcloudData:SoundcloudAlbumData!
        var youtubeMusicData:YoutubeMusicAlbumData!
        var amazonData:AmazonAlbumData!
        var deezerData:DeezerAlbumData!
        var spinrillaData:SpinrillaAlbumData!
        var napsterData:NapsterAlbumData!
        var tidalData:TidalAlbumData!
        if uploadArray[youtubePlaylistContentType] != nil {
            grouparray.append(2)
            ytvdData = (uploadArray[youtubePlaylistContentType] as! YouTubeData)
            totalProgress+=1
        }
        if uploadArray["Spotify"] != nil {
            grouparray.append(5)
            spotifyData = (uploadArray["Spotify"] as! SpotifyAlbumData)
            totalProgress+=1
        }
        if uploadArray["Apple"] != nil {
            grouparray.append(6)
            appleData = (uploadArray["Apple"] as! AppleAlbumData)
            totalProgress+=1
        }
        if uploadArray[soundcloudMusicContentType] != nil {
            grouparray.append(7)
            soundcloudData = (uploadArray[soundcloudMusicContentType] as! SoundcloudAlbumData)
            totalProgress+=1
        }
        if uploadArray[youtubeMusicContentType] != nil {
            grouparray.append(8)
            youtubeMusicData = (uploadArray[youtubeMusicContentType] as! YoutubeMusicAlbumData)
            totalProgress+=1
        }
        if uploadArray[amazonMusicContentType] != nil {
            grouparray.append(9)
            amazonData = (uploadArray[amazonMusicContentType] as! AmazonAlbumData)
            totalProgress+=1
        }
        if uploadArray["Deezer"] != nil {
            grouparray.append(10)
            deezerData = (uploadArray["Deezer"] as! DeezerAlbumData)
            totalProgress+=1
        }
        if uploadArray[spinrillaMusicContentType] != nil {
            grouparray.append(11)
            spinrillaData = (uploadArray[spinrillaMusicContentType] as! SpinrillaAlbumData)
            totalProgress+=1
        }
        if uploadArray[tidalMusicContentType] != nil {
            grouparray.append(12)
            tidalData = (uploadArray[tidalMusicContentType] as! TidalAlbumData)
            totalProgress+=1
        }
        if uploadArray[napsterMusicContentType] != nil {
            grouparray.append(13)
            napsterData = (uploadArray[napsterMusicContentType] as! NapsterAlbumData)
            totalProgress+=1
        }
        if deluxeOf != nil {
            grouparray.append(14)
            totalProgress+=1
        }
        if otherVersionsOf != nil  {
            grouparray.append(15)
            totalProgress+=1
        }
        basealbumProgress = totalProgress
        //print(grouparray)
        let yqueue = DispatchQueue(label: "myhjalbumsongsjyfhhikhQueue")
        let ygroup = DispatchGroup()
        for i in grouparray {
            ygroup.enter()
            yqueue.async { [weak self] in
                guard let strongSelf = self else {return}
                switch i {
                case 1:
                    albumdatabaseuploadCompletionStatus1 = false
                    strongSelf.storeRequiredAlbumData(completion: { error, done in
                        if error == nil {
                            albumdatabaseuploadCompletionStatus1 = true
                        } else {
                            albumdatabaseuploadCompletionStatus1 = false
                            guard let error = error else {return}
                            print(error)
                        }
                        print("album database Required done")
                        ygroup.leave()
                    })
                case 2:
                    albumdatabaseuploadCompletionStatus2 = false
                strongSelf.storeYoutubeOfficialAlbumData(data: ytvdData, completion: { error, done in
                    if error == nil {
                        albumdatabaseuploadCompletionStatus2 = true
                    } else {
                        albumdatabaseuploadCompletionStatus2 = false
                        guard let error = error else {return}
                        print(error)
                        
                    }
                    print("album database Youtube Official done")
                    ygroup.leave()
                })
                case 5:
                    albumdatabaseuploadCompletionStatus5 = false
                    strongSelf.storeSpotifyAlbumData(data: spotifyData, completion: { error, done in
                        if error == nil {
                            albumdatabaseuploadCompletionStatus5 = true
                        } else {
                            albumdatabaseuploadCompletionStatus5 = false
                            guard let error = error else {return}
                            print(error)
                            
                        }
                        
                        print("album database Spotify done")
                        ygroup.leave()
                    })
                case 6:
                    albumdatabaseuploadCompletionStatus6 = false
                    strongSelf.storeAppleAlbumData(data: appleData, completion: { error, done in
                        if error == nil {
                            albumdatabaseuploadCompletionStatus6 = true
                        } else {
                            albumdatabaseuploadCompletionStatus6 = false
                            guard let error = error else {return}
                            print(error)
                            
                        }
                        print("album database Apple done")
                        ygroup.leave()
                    })
                case 7:
                    albumdatabaseuploadCompletionStatus7 = false
                    strongSelf.storeSoundCloudAlbumData(data: soundcloudData, completion: { error, done in
                        if error == nil {
                            albumdatabaseuploadCompletionStatus7 = true
                        } else {
                            albumdatabaseuploadCompletionStatus7 = false
                            guard let error = error else {return}
                            print(error)
                            
                        }
                        print("album database Soundcloud done")
                        ygroup.leave()
                    })
                case 8:
                    albumdatabaseuploadCompletionStatus8 = false
                    strongSelf.storeYoutubeMusicAlbumData(data: youtubeMusicData, completion: { error, done in
                        if error == nil {
                            albumdatabaseuploadCompletionStatus8 = true
                        } else {
                            albumdatabaseuploadCompletionStatus8 = false
                            guard let error = error else {return}
                            print(error)
                            
                        }
                        print("album database Youtube Music done")
                        ygroup.leave()
                    })
                case 9:
                    albumdatabaseuploadCompletionStatus9 = false
                    strongSelf.storeAmazonAlbumData(data: amazonData, completion: { error, done in
                        if error == nil {
                            albumdatabaseuploadCompletionStatus9 = true
                        } else {
                            albumdatabaseuploadCompletionStatus9 = false
                            guard let error = error else {return}
                            print(error)
                            
                        }
                        print("album database Amazon done")
                        ygroup.leave()
                    })
                case 10:
                    albumdatabaseuploadCompletionStatus10 = false
                    strongSelf.storeDeezerAlbumData(data: deezerData, completion: { error, done in
                        if error == nil {
                            albumdatabaseuploadCompletionStatus10 = true
                        } else {
                            albumdatabaseuploadCompletionStatus10 = false
                            guard let error = error else {return}
                            print(error)
                            
                        }
                        print("album database Deezer done")
                        ygroup.leave()
                    })
                case 11:
                    albumdatabaseuploadCompletionStatus11 = false
                    strongSelf.storeSpinrillaAlbumData(data: spinrillaData, completion: { error, done in
                        if error == nil {
                            albumdatabaseuploadCompletionStatus11 = true
                        } else {
                            albumdatabaseuploadCompletionStatus11 = false
                            guard let error = error else {return}
                            print(error)
                            
                        }
                        print("album database Spinrilla done")
                        ygroup.leave()
                    })
                case 12:
                    albumdatabaseuploadCompletionStatus12 = false
                    strongSelf.storeTidalAlbumData(data: tidalData, completion: { error, done in
                        if error == nil {
                            albumdatabaseuploadCompletionStatus12 = true
                        } else {
                            albumdatabaseuploadCompletionStatus12 = false
                            guard let error = error else {return}
                            print(error)
                            
                        }
                        print("album database Tidal done")
                        ygroup.leave()
                    })
                case 13:
                    albumdatabaseuploadCompletionStatus13 = false
                    strongSelf.storeNapsterAlbumData(data: napsterData, completion: { error, done in
                        if error == nil {
                            albumdatabaseuploadCompletionStatus13 = true
                        } else {
                            albumdatabaseuploadCompletionStatus13 = false
                            guard let error = error else {return}
                            print(error)
                            
                        }
                        print("album database Napster done")
                        ygroup.leave()
                    })
                case 14:
                    albumdatabaseuploadCompletionStatus14 = false
                    strongSelf.storeDeluxeToStandardEdition(completion: { error in
                        if error == nil {
                            albumdatabaseuploadCompletionStatus14 = true
                        } else {
                            albumdatabaseuploadCompletionStatus14 = false
                            guard let error = error else {return}
                            print(error)
                            
                        }
                        print("album deluxe store done")
                        ygroup.leave()
                    })
                case 15:
                    albumdatabaseuploadCompletionStatus15 = false
                    strongSelf.storeOtherVersionToStandardEdition(completion: { error in
                        if error == nil {
                            albumdatabaseuploadCompletionStatus15 = true
                        } else {
                            albumdatabaseuploadCompletionStatus15 = false
                            guard let error = error else {return}
                            print(error)
                            
                        }
                        print("album other version store done")
                        ygroup.leave()
                    })
                default:
                    print("albumdb OOPs")
                }
            }
        }
        ygroup.notify(queue: DispatchQueue.main) { [weak self] in
            guard let strongSelf = self else {return}
            if albumdatabaseuploadCompletionStatus1 == false || albumdatabaseuploadCompletionStatus2 == false || albumdatabaseuploadCompletionStatus3 == false || albumdatabaseuploadCompletionStatus4 == false || albumdatabaseuploadCompletionStatus5 == false || albumdatabaseuploadCompletionStatus6 == false || albumdatabaseuploadCompletionStatus7 == false || albumdatabaseuploadCompletionStatus8 == false || albumdatabaseuploadCompletionStatus9 == false || albumdatabaseuploadCompletionStatus10 == false || albumdatabaseuploadCompletionStatus11 == false || albumdatabaseuploadCompletionStatus12 == false || albumdatabaseuploadCompletionStatus13 == false || albumdatabaseuploadCompletionStatus14 == false || albumdatabaseuploadCompletionStatus15 == false {
                Utilities.showError2("Upload Failed.", actionText: "OK")
                return
            } else {
                albumdatabaseuploadCompletionStatus1 = false
                albumdatabaseuploadCompletionStatus2 = false
                albumdatabaseuploadCompletionStatus3 = false
                albumdatabaseuploadCompletionStatus4 = false
                albumdatabaseuploadCompletionStatus5 = false
                albumdatabaseuploadCompletionStatus6 = false
                albumdatabaseuploadCompletionStatus7 = false
                albumdatabaseuploadCompletionStatus8 = false
                albumdatabaseuploadCompletionStatus9 = false
                albumdatabaseuploadCompletionStatus10 = false
                albumdatabaseuploadCompletionStatus11 = false
                albumdatabaseuploadCompletionStatus12 = false
                albumdatabaseuploadCompletionStatus13 = false
                albumdatabaseuploadCompletionStatus14 = false
                albumdatabaseuploadCompletionStatus15 = false
                strongSelf.proccessSongs()
            }
        }
    }
    
    func storeRequiredAlbumData(completion: @escaping (Error?, Bool) -> Void) {
        var RequiredInfoMa = [String : Any]()
        let songcount = albumUploadSongsArray.count
        print("song count \(songcount)")
        if videos.isEmpty {
            videos = []
        }
        if allArtists.isEmpty {
            allArtists = []
        }
        if albumProducers.isEmpty {
            albumProducers = []
        }
        if instrumentals.isEmpty {
            instrumentals = []
        }
        var del:Bool!
        var ov:Bool!
        
        if deluxeAlbum == true {
            del = deluxeAlbum
        }
        if otherVersionsAlbum == true {
            del = otherVersionsAlbum
        }
        
        RequiredInfoMa = [
            "Tone Deaf App Id" : tDAppId,
            "Name" : albumName,
            "Main Artist" : mainArtist,
            "All Artist" : allArtists,
            "Number of Favorites Overall" : 0,
            "Instrumentals": instrumentals,
            "Songs" : songIds,
            "Videos": videos,
            "Number Of Tracks": songcount,
            "Time Registered To App": currtime,
            "Date Registered To App": currdate,
            "Verification Level": String(verificationLevel),
            "Industry Certified": industryCertified,
            "Deluxe": [
                "Status": del,
                "Standard Edition": deluxeOf
            ],
            "Other Versions": [
                "Status": ov,
                "Standard Edition": otherVersionsOf
            ],
            "Active Status": false
        ]
        
        Database.database().reference().child("All Content IDs").observeSingleEvent(of: .value, with: {[weak self] snap in
            guard let strongSelf = self else {return}
            var arr = snap.value as! [String]
            if !arr.contains("\(strongSelf.tDAppId)") {
                arr.append("\(strongSelf.tDAppId)")
            }
            Database.database().reference().child("All Content IDs").setValue(arr)
        })

        Database.database().reference().child("Music Content").child("Albums").child("All Album IDs").observeSingleEvent(of: .value, with: {[weak self] snap in
            guard let strongSelf = self else {return}
            if var arr = snap.value as? [String] {
                if !arr.contains("\(strongSelf.tDAppId)") {
                    arr.append("\(strongSelf.tDAppId)")
                }
                Database.database().reference().child("Music Content").child("Albums").child("All Album IDs").setValue(arr)
            }
            else {
                var arr:[String] = ["\(strongSelf.tDAppId)"]
                Database.database().reference().child("Music Content").child("Albums").child("All Album IDs").setValue(arr)
            }
        })
        
        let RequiredRef = Database.database().reference().child("Music Content").child("Albums").child(albumCategory).child("REQUIRED")
        RequiredRef.updateChildValues(RequiredInfoMa) {(error, songRef) in
            if let error = error {
                print("📕 Failed to upload dictionary to database: \(error)")
                completion(error ,false)
                return
            } else {
                completion(nil, true)
            }
        }
    }
    
    func storeYoutubeOfficialAlbumData(data: YouTubeData, completion: @escaping (Error?, Bool) -> Void) {
        let videorRef = Database.database().reference().child("Music Content").child("Albums").child(albumCategory).child("Videos").child("Official").child("id")
        videorRef.setValue("\(data.toneDeafAppId)")
        
        let videoDBKey = ("\(videoContentTag)--\(data.title.replacingOccurrences(of: ".", with: " ").replacingOccurrences(of: "#", with: " ").replacingOccurrences(of: "$", with: " ").replacingOccurrences(of: "[", with: " ").replacingOccurrences(of: "]", with: " ").replacingOccurrences(of: ":", with: " "))--\(data.toneDeafAppId)")
        
        let ytContentRandomKey = ("\(youtubePlaylistContentType)--\(data.title.replacingOccurrences(of: ".", with: " ").replacingOccurrences(of: "#", with: " ").replacingOccurrences(of: "$", with: " ").replacingOccurrences(of: "[", with: " ").replacingOccurrences(of: "]", with: " ").replacingOccurrences(of: ":", with: " "))--\(data.toneDeafAppId)")
        
        let VideoRef = Database.database().reference().child("Music Content").child("Videos").child(videoDBKey).child("Youtube").child(ytContentRandomKey)
        
        if instrumentals.isEmpty {
            instrumentals = []
        }
        if songIds.isEmpty {
            songIds = []
        }
        
        let albumEngineers = GlobalFunctions.shared.mergeArrays(albumMixEngineers,albumMasteringEngineers,albumRecordingEngineers)
        let albumPersons:[String] = Array(GlobalFunctions.shared.combine(allArtists,albumProducers,albumWriters,albumEngineers))
        
        var VideoInfoMap = NSDictionary()
        VideoInfoMap = [
        "Title" : data.title,
        "Tone Deaf App Video Id": data.toneDeafAppId,
        "Time Uploaded To App" : currtime,
        "Date Uploaded To App" : currdate,
        "Views In App" : data.viewsIA,
        "Number of Favorites" : 0,
        "Albums" : ["\(tDAppId)"],
        "Instrumentals": instrumentals,
        "Songs": songIds,
        "Type": "Playlist",
        "Persons" : albumPersons,
        "Verification Level": String(verificationLevel),
        "Industry Certified": industryCertified,
        "Active Status" : false
        ]
        
        Database.database().reference().child("Music Content").child("Videos").child(videoDBKey).updateChildValues(VideoInfoMap as! [AnyHashable : Any]) { [weak self] (error, videoRef) in
            guard let strongSelf = self else {return}
            if let error = error {
                print("📕 Failed to upload youtube video dictionary to database: \(error)")
                return
            }
        }
        
        var YTInfoMap = NSDictionary()
        YTInfoMap = [
            "Title" : data.title,
            "Tone Deaf App Video Id": data.toneDeafAppId,
            "Date Uploaded To Youtube" : data.dateYT,
            "Time Uploaded To Youtube" : data.timeYT,
            "Time Uploaded To App" : currtime,
            "Date Uploaded To App" : currdate,
            "Channel Title" : data.channelTitle,
            "Description" : data.description,
            "Thumbnail URL" : data.thumbnailURL,
            "Video URL" : data.url,
            "Views In App" : data.viewsIA,
            "Number of Favorites" : 0,
            "Youtube Id" : data.youtubeId,
            "Type": youtubePlaylistContentType,
            "Active Status": false]
        
        
        
        let videoRef = Database.database().reference().child("Music Content").child("Videos").child(videoDBKey).child("Youtube")
        let insert:[String:NSDictionary] = [ytContentRandomKey:YTInfoMap]
        VideoRef.setValue(YTInfoMap)
        completion(nil, true)
        
//        VideoRef.observeSingleEvent(of: .value, with: {[weak self] snapshot in
//            guard let strongSelf = self else {return}
//            var mysongsArray:[[String:NSDictionary]] = [[:]]
//            if let val = snapshot.value {
//                let valu = val as? [[String:NSDictionary]]
//                guard let value = valu else {
//                    mysongsArray = [insert]
//                    videoRef.setValue(mysongsArray)
//                    completion(nil, true)
//                    return
//                }
//                mysongsArray = value
//                mysongsArray.append(insert)
//                videoRef.setValue(mysongsArray)
//                completion(nil, true)
//            } else {
//                mysongsArray = [insert]
//                videoRef.setValue(mysongsArray)
//                completion(nil, true)
//            }
//        })
        
    }
    
    func storeSpotifyAlbumData(data: SpotifyAlbumData, completion: @escaping (Error?, Bool) -> Void) {
        let spotifyContentRandomKey = ("\(spotifyMusicContentType)--\(albumName)--\(currdate)--\(currtime)")
        
        var SpotifyInfoMap = [String : Any]()
        SpotifyInfoMap = [
            "Name" : data.name,
            "Artists" : data.artist,
            "UPC" : data.upc,
            "Date Released On Spotify" : data.dateReleasedSpotify,
            "Time Uploaded To App" : currtime,
            "Date Uploaded To App" : currdate,
            "Artwork URL" : data.imageURL,
            "Album URL" : data.url,
            "Album URI" : data.uri,
            "Number of Favorites" : 0,
            "Number of Tracks" : data.trackNumberTotal,
            "Spotify Id" : data.spotifyId,
            "Active Status" : false
        ]
        
        let AlbumRef = Database.database().reference().child("Music Content").child("Albums").child(albumCategory).child(spotifyContentRandomKey)
        
        AlbumRef.updateChildValues(SpotifyInfoMap) { [weak self] (error, albumRef) in
            guard let strongSelf = self else {return}
            if let error = error {
                print("📕 Failed to upload dictionary to database: \(error)")
                Utilities.showError2("Failed to Upload. Please try again.", actionText: "OK")
                completion(error, false)
                return
            } else {
                print("📗 Spotify data for \(strongSelf.albumName) saved to database successfully.")
                completion(nil, true)
                return
            }
        }
    }
    
    func storeAppleAlbumData(data: AppleAlbumData, completion: @escaping (Error?, Bool) -> Void) {
        let appleContentRandomKey = ("\(appleMusicContentType)--\(albumName)--\(currdate)--\(currtime)")
        
        var appleInfoMap = [String : Any]()
        appleInfoMap = [
            "Name" : data.name,
            "Artists" : data.artist,
            "Date Released On Apple" : data.dateReleasedApple,
            "Time Uploaded To App" : currtime,
            "Date Uploaded To App" : currdate,
            "Artwork URL" : data.imageURL,
            "Album URL" : data.url,
            "Number of Favorites" : 0,
            "Number of Tracks" : data.trackCount,
            "Apple Music Id" : data.appleId,
            "Active Status" : false
        ]
        
        let AlbumRef = Database.database().reference().child("Music Content").child("Albums").child(albumCategory).child(appleContentRandomKey)
        
        AlbumRef.updateChildValues(appleInfoMap) { [weak self] (error, albumRef) in
            guard let strongSelf = self else {return}
            if let error = error {
                print("📕 Failed to upload dictionary to database: \(error)")
                Utilities.showError2("Failed to Upload. Please try again.", actionText: "OK")
                completion(error, false)
                return
            } else {
                print("📗 Apple data for \(strongSelf.albumName) saved to database successfully.")
                completion(nil, true)
                return
            }
        }
    }
    
    func storeSoundCloudAlbumData(data: SoundcloudAlbumData, completion: @escaping (Error?, Bool) -> Void) {
        let soundcloudContentRandomKey = ("\(soundcloudMusicContentType)--\(albumName)--\(currdate)--\(currtime)")
        
        var AlbumInfoMap = [String : Any]()
        AlbumInfoMap = [
            "url" : data.url,
            "Active Status": false]
        
        let AlbumRef = Database.database().reference().child("Music Content").child("Albums").child(albumCategory).child(soundcloudContentRandomKey)
        
        AlbumRef.updateChildValues(AlbumInfoMap) { [weak self] (error, albumRef) in
            guard let strongSelf = self else {return}
            if let error = error {
                print("📕 Failed to upload dictionary to database: \(error)")
                Utilities.showError2("Failed to Upload. Please try again.", actionText: "OK")
                completion(error, false)
                return
            } else {
                print("📗 Soundcloud data for \(strongSelf.albumName) saved to database successfully.")
                completion(nil, true)
                return
            }
        }
    }
    
    func storeYoutubeMusicAlbumData(data: YoutubeMusicAlbumData, completion: @escaping (Error?, Bool) -> Void) {
        let youtubeMusicContentRandomKey = ("\(youtubeMusicContentType)--\(albumName)--\(currdate)--\(currtime)")
        
        var AlbumInfoMap = [String : Any]()
        AlbumInfoMap = [
            "url" : data.url,
            "Active Status": false]
        
        let AlbumRef = Database.database().reference().child("Music Content").child("Albums").child(albumCategory).child(youtubeMusicContentRandomKey)
        
        AlbumRef.updateChildValues(AlbumInfoMap) { [weak self] (error, albumRef) in
            guard let strongSelf = self else {return}
            if let error = error {
                print("📕 Failed to upload dictionary to database: \(error)")
                Utilities.showError2("Failed to Upload. Please try again.", actionText: "OK")
                completion(error, false)
                return
            } else {
                print("📗 Youtube Music data for \(strongSelf.albumName) saved to database successfully.")
                completion(nil, true)
                return
            }
        }
    }
    
    func storeAmazonAlbumData(data: AmazonAlbumData, completion: @escaping (Error?, Bool) -> Void) {
        let amazonContentRandomKey = ("\(amazonMusicContentType)--\(albumName)--\(currdate)--\(currtime)")
        
        var AlbumInfoMap = [String : Any]()
        AlbumInfoMap = [
            "url" : data.url,
            "Active Status": false]
        
        let AlbumRef = Database.database().reference().child("Music Content").child("Albums").child(albumCategory).child(amazonContentRandomKey)
        
        AlbumRef.updateChildValues(AlbumInfoMap) { [weak self] (error, albumRef) in
            guard let strongSelf = self else {return}
            if let error = error {
                print("📕 Failed to upload dictionary to database: \(error)")
                Utilities.showError2("Failed to Upload. Please try again.", actionText: "OK")
                completion(error, false)
                return
            } else {
                print("📗 Amazon data for \(strongSelf.albumName) saved to database successfully.")
                completion(nil, true)
                return
            }
        }
    }
    
    func storeDeezerAlbumData(data: DeezerAlbumData, completion: @escaping (Error?, Bool) -> Void) {
        let deezerContentRandomKey = ("\(deezerMusicContentType)--\(albumName)--\(currdate)--\(currtime)")
        
        var AlbumInfoMap = [String : Any]()
        AlbumInfoMap = [
            "Name" : data.name!,
            "Artist" : data.artist!,
            "UPC" : data.upc!,
            "Date Released On Deezer" : data.deezerDate!,
            "Time Uploaded To App" : currtime,
            "Date Uploaded To App" : currdate,
            "Duration" : data.duration!,
            "Artwork URL" : data.imageurl!,
            "Album URL" : data.url!,
            "Deezer Music Id" : data.deezerID!,
            "Active Status" : false
        ]
        
        let AlbumRef = Database.database().reference().child("Music Content").child("Albums").child(albumCategory).child(deezerContentRandomKey)
        
        AlbumRef.updateChildValues(AlbumInfoMap) { [weak self] (error, albumRef) in
            guard let strongSelf = self else {return}
            if let error = error {
                print("📕 Failed to upload dictionary to database: \(error)")
                Utilities.showError2("Failed to Upload. Please try again.", actionText: "OK")
                completion(error, false)
                return
            } else {
                print("📗 Deezer data for \(strongSelf.albumName) saved to database successfully.")
                completion(nil, true)
                return
            }
        }
    }
    
    func storeSpinrillaAlbumData(data: SpinrillaAlbumData, completion: @escaping (Error?, Bool) -> Void) {
        let spinrillaContentRandomKey = ("\(spinrillaMusicContentType)--\(albumName)--\(currdate)--\(currtime)")
        
        var AlbumInfoMap = [String : Any]()
        AlbumInfoMap = [
            "url" : data.url,
            "Active Status": false]
        
        let AlbumRef = Database.database().reference().child("Music Content").child("Albums").child(albumCategory).child(spinrillaContentRandomKey)
        
        AlbumRef.updateChildValues(AlbumInfoMap) { [weak self] (error, albumRef) in
            guard let strongSelf = self else {return}
            if let error = error {
                print("📕 Failed to upload dictionary to database: \(error)")
                Utilities.showError2("Failed to Upload. Please try again.", actionText: "OK")
                completion(error, false)
                return
            } else {
                print("📗 Spinrilla data for \(strongSelf.albumName) saved to database successfully.")
                completion(nil, true)
                return
            }
        }
    }
    
    func storeNapsterAlbumData(data: NapsterAlbumData, completion: @escaping (Error?, Bool) -> Void) {
        let napsterContentRandomKey = ("\(napsterMusicContentType)--\(albumName)--\(currdate)--\(currtime)")
        
        var AlbumInfoMap = [String : Any]()
        AlbumInfoMap = [
            "url" : data.url,
            "Active Status": false]
        
        let AlbumRef = Database.database().reference().child("Music Content").child("Albums").child(albumCategory).child(napsterContentRandomKey)
        
        AlbumRef.updateChildValues(AlbumInfoMap) { [weak self] (error, albumRef) in
            guard let strongSelf = self else {return}
            if let error = error {
                print("📕 Failed to upload dictionary to database: \(error)")
                Utilities.showError2("Failed to Upload. Please try again.", actionText: "OK")
                completion(error, false)
                return
            } else {
                print("📗 Napster data for \(strongSelf.albumName) saved to database successfully.")
                completion(nil, true)
                return
            }
        }
    }
    
    func storeTidalAlbumData(data: TidalAlbumData, completion: @escaping (Error?, Bool) -> Void) {
        let tidalContentRandomKey = ("\(tidalMusicContentType)--\(albumName)--\(currdate)--\(currtime)")
        
        var AlbumInfoMap = [String : Any]()
        AlbumInfoMap = [
            "url" : data.url,
            "Active Status": false]
        
        let AlbumRef = Database.database().reference().child("Music Content").child("Albums").child(albumCategory).child(tidalContentRandomKey)
        
        AlbumRef.updateChildValues(AlbumInfoMap) { [weak self] (error, albumRef) in
            guard let strongSelf = self else {return}
            if let error = error {
                print("📕 Failed to upload dictionary to database: \(error)")
                Utilities.showError2("Failed to Upload. Please try again.", actionText: "OK")
                completion(error, false)
                return
            } else {
                print("📗 Tidal data for \(strongSelf.albumName) saved to database successfully.")
                completion(nil, true)
                return
            }
        }
    }
    
    func storeDeluxeToStandardEdition(completion: @escaping ((Error?) -> Void)) {
        DatabaseManager.shared.findAlbumById(albumId: deluxeOf!, completion: {[weak self] result in
            guard let strongSelf = self else {return}
            switch result {
            case .success(let alb):
                if var arr = alb.deluxes {
                    if !arr.contains(strongSelf.tDAppId) {
                        arr.append(strongSelf.tDAppId)
                    }
                    Database.database().reference().child("Music Content").child("Albums").child("\(albumContentTag)--\(alb.name)--\(alb.toneDeafAppId)").child("REQUIRED").child("Deluxes").setValue(arr.sorted(), withCompletionBlock: { error, reference in
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
                    Database.database().reference().child("Music Content").child("Albums").child("\(albumContentTag)--\(alb.name)--\(alb.toneDeafAppId)").child("REQUIRED").child("Deluxes").setValue(arr.sorted(), withCompletionBlock: { error, reference in
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
    
    func storeOtherVersionToStandardEdition(completion: @escaping ((Error?) -> Void)) {
        DatabaseManager.shared.findAlbumById(albumId: otherVersionsOf!, completion: {[weak self] result in
            guard let strongSelf = self else {return}
            switch result {
            case .success(let alb):
                if var arr = alb.otherVersions {
                    if !arr.contains(strongSelf.tDAppId) {
                        arr.append(strongSelf.tDAppId)
                    }
                    Database.database().reference().child("Music Content").child("Albums").child("\(albumContentTag)--\(alb.name)--\(alb.toneDeafAppId)").child("REQUIRED").child("Other Versions").setValue(arr.sorted(), withCompletionBlock: { error, reference in
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
                    Database.database().reference().child("Music Content").child("Albums").child("\(albumContentTag)--\(alb.name)--\(alb.toneDeafAppId)").child("REQUIRED").child("Other Versions").setValue(arr.sorted(), withCompletionBlock: { error, reference in
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
    
    func proccessSongs() {
        //print("processing")
        albumUploadSongsArray.sort(by: {$0.trackNumber < $1.trackNumber})
        let group = DispatchGroup()
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let strongSelf = self else {return}
            var count = 0
            for obj in albumUploadSongsArray {
                if count != 0 {
                    usleep(100000)
                }
                count+=1
                switch obj.song {
                case is AlbumUploadSongData:
                    let newsong = obj.song as! AlbumUploadSongData
                    let tracknum = String(obj.trackNumber)
                    strongSelf.handleNewSong(song: newsong, songAppId: newsong.toneDeafAppId, tracknum: tracknum)
                default:
                    let oldsong = obj.song as! String
                    let tracknum = String(obj.trackNumber)
                    strongSelf.copySongFromDatabase(songid: oldsong, tracknum: tracknum)
                }
                strongSelf.semaphore.wait()
            }
        }
    }
    
    func generateSongAppId(song: AlbumUploadSongData, tracknum: String) {
        let genid = StorageManager.shared.generateRandomNumber(digits: 10)
        DatabaseManager.shared.checkIfAppIdExists(appid: genid, completion: { [weak self] result in
            guard let strongSelf = self else {return}
            //print(result)
            
            if result == true {
                strongSelf.generateSongAppId(song: song, tracknum: tracknum)
                
            } else {
                let songappid = genid
//                if strongSelf.songs == ["1000":""] {
//                    //strongSelf.songs = [:]
//                }
                //strongSelf.songs[tracknum] = songappid
                //song
                strongSelf.handleNewSong(song: song, songAppId: songappid, tracknum: tracknum)
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
                print(genid)
                completion(genid)
                
            }
        })
    }
    
    func handleNewSong(song: AlbumUploadSongData, songAppId:String, tracknum: String) {
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
        var songUploadVideos:[String] = []
        if !videos.isEmpty {
            songUploadVideos = videos
        }
        var songartistrefs:[String] = []
        var songproducerrefs:[String] = []
        var songwriterrefs:[String] = []
        var songmixengineerrefs:[String] = []
        var songmasteringengineerrefs:[String] = []
        var songrecorgingengineerrefs:[String] = []
        var uploadDataArray:[String:Any?] = [:]
        let aqueue = DispatchQueue(label: "myhjalbumsongshikjftdgxfhQueue")
        let agroup = DispatchGroup()
        let array = [4, 5, 6, 7, 8, 9, 10, 11, 12, 13]
        for i in array {
            agroup.enter()
            aqueue.async { [weak self] in
                guard let strongSelf = self else {return}
                switch i {
                case 4:
                    uploadCompletionStatus4 = false
                    strongSelf.spotifySong(song: song, completion: {[weak self] spotify,error,done in
                        guard let strongSelf = self else {return}
                        //print(done)
                        if done == false {
                            guard let error = error else {return}
                            Utilities.showError2("Spotify upload Failed: \(error)", actionText: "OK")
                            
                        }
                        else {
                            if spotify == nil {
                                uploadDataArray["SPTY"] = nil
                                uploadCompletionStatus4 = true
                                print("\(song.name) Spotify graphing done \(i)")
                            } else {
                                uploadDataArray["SPTY"] = spotify
                                uploadCompletionStatus4 = true
                                print("\(song.name) Spotify graphing done \(i)")
                            }
                        }
                        agroup.leave()
                    })
                case 5:
                    uploadCompletionStatus5 = false
                    strongSelf.appleMusicSong(song: song, completion: {[weak self] apple,error,done in
                        guard let strongSelf = self else {return}
                        if done == false {
                            guard let error = error else {return}
                            Utilities.showError2("Apple upload Failed: \(error)", actionText: "OK")
                            uploadCompletionStatus5 = false
                        }
                        else {
                            if apple == nil {
                                uploadDataArray["APPL"] = nil
                                uploadCompletionStatus5 = true
                                print("\(song.name) Apple graphing done \(i)")
                            } else {
                                uploadDataArray["APPL"] = apple
                                uploadCompletionStatus5 = true
                                print("\(song.name) Apple graphing done \(i)")
                            }
                        }
                        agroup.leave()
                    })
                case 6:
                    uploadCompletionStatus6 = false
                    strongSelf.deezerSong(song: song, completion: {[weak self] deezer,error,done in
                        guard let strongSelf = self else {return}
                        if done == false {
                            guard let error = error else {return}
                            Utilities.showError2("Deezer upload Failed: \(error)", actionText: "OK")
                            uploadCompletionStatus6 = false
                        }
                        else {
                            if deezer == nil {
                                uploadDataArray["DEEZ"] = nil
                                uploadCompletionStatus6 = true
                                print("\(song.name) Deezer graphing done \(i)")
                            } else {
                                uploadDataArray["DEEZ"] = deezer
                                uploadCompletionStatus6 = true
                                print("\(song.name) Deezer graphing done \(i)")
                            }
                        }
                        agroup.leave()
                    })
                case 7:
                    uploadCompletionStatus7 = false
                    strongSelf.getArtistRefs(song: song, completion: {[weak self] artref,done  in
                        
                        guard let strongSelf = self else {return}
                        if done == false {
                            Utilities.showError2("artist reference fetch Failed.", actionText: "OK")
                            uploadCompletionStatus7 = false
                        }
                        else {
                            if let artref = artref {
                                songartistrefs = artref
                            }
                            uploadCompletionStatus7 = true
                            print("\(song.name) artist refs done \(i)")
                        }
                        agroup.leave()
                    })
                case 8:
                    uploadCompletionStatus8 = false
                    strongSelf.getProducerRefs(song: song, completion: {[weak self] proref,done in
                        guard let strongSelf = self else {return}
                        if done == false {
                            Utilities.showError2("producer reference fetch Failed.", actionText: "OK")
                            uploadCompletionStatus8 = false
                        }
                        else {
                            songproducerrefs = proref
                            uploadCompletionStatus8 = true
                            print("\(song.name) producer refs done \(i)")
                        }
                        agroup.leave()
                    })
                case 9:
                    uploadCompletionStatus9 = false
                    strongSelf.getWriterRefs(song: song, completion: {[weak self] wriref,done in
                        guard let strongSelf = self else {return}
                        if done == false {
                            Utilities.showError2("writer reference fetch Failed.", actionText: "OK")
                            uploadCompletionStatus9 = false
                        }
                        else {
                            songwriterrefs = wriref
                            uploadCompletionStatus9 = true
                            print("\(song.name) writer refs done \(i)")
                        }
                        agroup.leave()
                    })
                case 10:
                    uploadCompletionStatus10 = false
                    strongSelf.getMixEngineerRefs(song: song, completion: {[weak self] mixengref,done in
                        guard let strongSelf = self else {return}
                        if done == false {
                            Utilities.showError2("mix engineer reference fetch Failed.", actionText: "OK")
                            uploadCompletionStatus10 = false
                        }
                        else {
                            songmixengineerrefs = mixengref
                            uploadCompletionStatus10 = true
                            print("\(song.name) mix engineer refs done \(i)")
                        }
                        agroup.leave()
                    })
                case 11:
                    uploadCompletionStatus11 = false
                    strongSelf.getMasteringEngineerRefs(song: song, completion: {[weak self] masengref,done in
                        guard let strongSelf = self else {return}
                        if done == false {
                            Utilities.showError2("mastering Engineer reference fetch Failed.", actionText: "OK")
                            uploadCompletionStatus11 = false
                        }
                        else {
                            songmasteringengineerrefs = masengref
                            uploadCompletionStatus11 = true
                            print("\(song.name) mastering engineer refs done \(i)")
                        }
                        agroup.leave()
                    })
                case 12:
                    uploadCompletionStatus12 = false
                    strongSelf.getRecordingEngineerRefs(song: song, completion: {[weak self] recengref,done in
                        guard let strongSelf = self else {return}
                        if done == false {
                            Utilities.showError2("recording engineer reference fetch Failed.", actionText: "OK")
                            uploadCompletionStatus12 = false
                        }
                        else {
                            songrecorgingengineerrefs = recengref
                            uploadCompletionStatus12 = true
                            print("\(song.name) recording engineer refs done \(i)")
                        }
                        agroup.leave()
                    })
                case 13:
                    uploadCompletionStatus13 = false
                    if song.soundcloudURL == nil {
                        uploadDataArray[soundcloudMusicContentType] = nil
                    } else {
                        let data = SoundcloudSongData(url: song.soundcloudURL!, imageurl: nil, releaseDate: nil, isActive: false)
                        uploadDataArray[soundcloudMusicContentType] = data
                    }
                    if song.youtubeMusicURL == nil {
                        uploadDataArray[youtubeMusicContentType] = nil
                    } else {
                        let data = YoutubeMusicSongData(url: song.youtubeMusicURL!, imageurl: nil, isActive: false)
                        uploadDataArray[youtubeMusicContentType] = data
                    }
                    if song.amazonMusicURL == nil {
                        uploadDataArray[amazonMusicContentType] = nil
                    } else {
                        let data = AmazonSongData(url: song.amazonMusicURL!, imageurl: nil, isActive: false)
                        uploadDataArray[amazonMusicContentType] = data
                    }
                    if song.spinrillaURL == nil {
                        uploadDataArray[spinrillaMusicContentType] = nil
                    } else {
                        let data = SpinrillaSongData(url: song.spinrillaURL!, imageurl: nil, releaseDate: nil, isActive: false)
                        uploadDataArray[spinrillaMusicContentType] = data
                    }
                    if song.napsterURL == nil {
                        uploadDataArray[napsterMusicContentType] = nil
                    } else {
                        let data = NapsterSongData(url: song.napsterURL!, imageurl: nil, isActive: false)
                        uploadDataArray[napsterMusicContentType] = data
                    }
                    if song.tidalURL == nil {
                        uploadDataArray[tidalMusicContentType] = nil
                    } else {
                        let data = TidalSongData(url: song.tidalURL!, imageurl: nil, isActive: false)
                        uploadDataArray[tidalMusicContentType] = data
                    }
                    agroup.leave()
                    uploadCompletionStatus13 = true
                    print("\(song.name) other done \(i)")
                default:
                    print("error")
                }
            }
        }
        
        agroup.notify(queue: DispatchQueue.main) {[weak self] in
            guard let strongSelf = self else {return}
            
            if uploadCompletionStatus4 == false || uploadCompletionStatus5 == false || uploadCompletionStatus6 == false || uploadCompletionStatus7 == false || uploadCompletionStatus8 == false || uploadCompletionStatus9 == false || uploadCompletionStatus10 == false || uploadCompletionStatus11 == false || uploadCompletionStatus12 == false {
                Utilities.showError2("Upload Failed.", actionText: "OK")
                return
            } else {
                
                uploadCompletionStatus4 = false
                uploadCompletionStatus5 = false
                uploadCompletionStatus6 = false
                uploadCompletionStatus7 = false
                uploadCompletionStatus8 = false
                uploadCompletionStatus9 = false
                uploadCompletionStatus10 = false
                uploadCompletionStatus11 = false
                uploadCompletionStatus12 = false
                
                strongSelf.uploadNewSongToDatabase(song: song, songAppId: songAppId, uploadArray: uploadDataArray, tracknum: tracknum, songUploadVideos: songUploadVideos, songartistref: songartistrefs, songproducerref: songproducerrefs, songwriterref: songwriterrefs, songmixengineerref: songmixengineerrefs, songmasteringengineerref: songmasteringengineerrefs, songrecorgingengineerref: songrecorgingengineerrefs)
            }
        }
    }
    
    func spotifySong(song: AlbumUploadSongData, completion: @escaping ((SpotifySongData?, Error?, Bool) -> Void)) {
        DispatchQueue.main.async {[weak self] in
            guard let strongSelf = self else {return}
            guard song.spotifyURL != "" else {
                completion(nil, nil, true)
                return
            }
            var spotUrl = song.spotifyURL
            if let dotRange = spotUrl.range(of: "?") {
                spotUrl.removeSubrange(dotRange.lowerBound..<spotUrl.endIndex)
            }
            let songId = String(spotUrl.suffix(22))
            let token = (UserDefaults.standard.object(forKey: "SPTaccesstoken") as? String)!
            SpotifyRequest.shared.getTrackInfo(accessToken: token, id: songId, completion: { result in
                switch result {
                case.success(let spotify):
                    completion(spotify, nil, true)
                case .failure(let error):
                    print(error)
                    completion(nil, error, false)
                }
            })
        }
        
    }
    
    func appleMusicSong(song: AlbumUploadSongData, completion: @escaping ((AppleMusicSongData?, Error?, Bool) -> Void)) {
        DispatchQueue.main.async {[weak self] in
            guard let strongSelf = self else {return}
            guard song.appleMusicURL != "" else {
                completion(nil, nil, true)
                return
            }
            let url = song.appleMusicURL
            let songId = String((url.suffix(10)))
            AppleMusicRequest.shared.getAppleMusicSong(id: songId, completion: { result in
                switch result {
                case.success(let apple):
                    completion(apple, nil, true)
                case .failure(let error):
                    print(error)
                    completion(nil, error, false)
                }
            })
        }
    }
    
    func deezerSong(song: AlbumUploadSongData, completion: @escaping ((DeezerSongData?, Error?, Bool) -> Void)) {
        DispatchQueue.main.async {[weak self] in
            guard let strongSelf = self else {return}
            guard song.deezerURL != "" else {
                completion(nil, nil, true)
                return
            }
            guard song.deezerURL != nil else {
                completion(nil, nil, true)
                return
            }
            var deezUrl = song.deezerURL!
            if let dotRange = deezUrl.range(of: "?") {
                deezUrl.removeSubrange(dotRange.lowerBound..<deezUrl.endIndex)
            }
            if let range = deezUrl.range(of: "track/") {
                deezUrl.removeSubrange(deezUrl.startIndex..<range.lowerBound)
            }
            
            let albumId = String(deezUrl.dropFirst(6))
            print(albumId)
            
            DeezerRequest.shared.getDeezerSong(id: albumId, completion: { result in
                switch result {
                case.success(let deezer):
                    completion(deezer, nil, true)
                case .failure(let error):
                    print(error)
                    completion(nil, error, false)
                }
            })
        }
    }
    
    func uploadNewSongToDatabase(song: AlbumUploadSongData, songAppId:String, uploadArray: [String:Any?], tracknum: String, songUploadVideos:[String], songartistref: [String], songproducerref: [String], songwriterref: [String], songmixengineerref: [String], songmasteringengineerref: [String], songrecorgingengineerref: [String]) {
        getArtistData(song: song, completion: {[weak self] artistsNames in
            guard let strongSelf = self else {return}
            var songdatabaseuploadCompletionStatus1:Bool!
            var songdatabaseuploadCompletionStatus2:Bool!
            var songdatabaseuploadCompletionStatus3:Bool!
            var songdatabaseuploadCompletionStatus4:Bool!
            var songdatabaseuploadCompletionStatus5:Bool!
            var songdatabaseuploadCompletionStatus6:Bool!
            var songdatabaseuploadCompletionStatus7:Bool!
            var songdatabaseuploadCompletionStatus8:Bool!
            var songdatabaseuploadCompletionStatus9:Bool!
            var songdatabaseuploadCompletionStatus10:Bool!
            var songdatabaseuploadCompletionStatus11:Bool!
            var songdatabaseuploadCompletionStatus12:Bool!
            var songdatabaseuploadCompletionStatus13:Bool!
            var songdatabaseuploadCompletionStatus14:Bool!
            var songdatabaseuploadCompletionStatus15:Bool!
            var songdatabaseuploadCompletionStatus16:Bool!
            var songcategorty = ""
            
            if song.instrumental != "" {
                songcategorty = ("\(instrumentalContentType)--\(song.name)--\(song.instrumental)")
            } else {
                songcategorty = "\(songContentTag)--\(song.name)--\(song.toneDeafAppId)"
            }
            var grouparray:[Int] = []
            if song.instrumental != "" {
                grouparray.append(14)
            } else {
                grouparray.append(1)
            }
            var ytvdData:YouTubeData!
            var ytadData:YouTubeData!
            var ytalData:YouTubeData!
            var spotifyData:SpotifySongData!
            var appleData:AppleMusicSongData!
            var soundcloudData:SoundcloudSongData!
            var youtubeMusicData:YoutubeMusicSongData!
            var amazonData:AmazonSongData!
            var spinrillaData:SpinrillaSongData!
            var tidalData:TidalSongData!
            var napsterData:NapsterSongData!
            var deezerData:DeezerSongData!
            if uploadArray["SPTY"] != nil {
                grouparray.append(5)
                spotifyData = (uploadArray["SPTY"] as! SpotifySongData)
            }
            if uploadArray["APPL"] != nil {
                grouparray.append(6)
                appleData = (uploadArray["APPL"] as! AppleMusicSongData)
            }
            if uploadArray[soundcloudMusicContentType] != nil {
                grouparray.append(7)
                soundcloudData = (uploadArray[soundcloudMusicContentType] as! SoundcloudSongData)
            }
            if uploadArray[youtubeMusicContentType] != nil {
                grouparray.append(8)
                youtubeMusicData = (uploadArray[youtubeMusicContentType] as! YoutubeMusicSongData)
            }
            if uploadArray[amazonMusicContentType] != nil {
                grouparray.append(9)
                amazonData = (uploadArray[amazonMusicContentType] as! AmazonSongData)
            }
            if uploadArray[deezerMusicContentType] != nil {
                grouparray.append(10)
                deezerData = (uploadArray[deezerMusicContentType] as! DeezerSongData)
            }
            if uploadArray[spinrillaMusicContentType] != nil {
                grouparray.append(11)
                spinrillaData = (uploadArray[spinrillaMusicContentType] as! SpinrillaSongData)
            }
            if uploadArray[tidalMusicContentType] != nil {
                grouparray.append(12)
                tidalData = (uploadArray[tidalMusicContentType] as! TidalSongData)
            }
            if uploadArray[napsterMusicContentType] != nil {
                grouparray.append(13)
                napsterData = (uploadArray[napsterMusicContentType] as! NapsterSongData)
            }
            if song.isRemix != nil {
                grouparray.append(15)
                strongSelf.totalProgress+=1
            }
            if song.isOtherVersion != nil  {
                grouparray.append(16)
                strongSelf.totalProgress+=1
            }
            
            let bqueue = DispatchQueue(label: "myhjvsdfhjhggjnfbdsbxkhQueue")
            let bgroup = DispatchGroup()
            let array:[Int] = []
            
            for i in grouparray {
                //print(i)
                bgroup.enter()
                bqueue.async { [weak self] in
                    guard let strongSelf = self else {return}
                    switch i {
                    case 1:
                        songdatabaseuploadCompletionStatus1 = false
                        strongSelf.storeRequiredSongData(song: song, tracknum: tracknum, songcategorty: songcategorty, songUploadVideos: songUploadVideos, completion: { error,done in
                            if error == nil {
                                songdatabaseuploadCompletionStatus1 = true
                                print("\(song.name) database Required done")
                            } else {
                                songdatabaseuploadCompletionStatus1 = false
                                guard let error = error else {return}
                                print(error)
                                
                            }
                            bgroup.leave()
                        })
                    case 5:
                        songdatabaseuploadCompletionStatus5 = false
                        strongSelf.storeSpotifySongData(son: song, songcategorty: songcategorty, song: spotifyData, completion: { error,done in
                            if error == nil {
                                songdatabaseuploadCompletionStatus5 = true
                             print("\(song.name) database Spotify done")
                        } else {
                            songdatabaseuploadCompletionStatus5 = false
                            guard let error = error else {return}
                            print(error)
                            
                        }
                        bgroup.leave()
                    })
                    case 6:
                        songdatabaseuploadCompletionStatus6 = false
                        strongSelf.storeAppleSongData(son: song, songcategorty: songcategorty, song: appleData, completion: { error,done in
                        if error == nil {
                            songdatabaseuploadCompletionStatus6 = true
                             print("\(song.name) database Apple done")
                        } else {
                            songdatabaseuploadCompletionStatus6 = false
                            guard let error = error else {return}
                            print(error)
                            
                        }
                        bgroup.leave()
                    })
                    case 7:
                        songdatabaseuploadCompletionStatus7 = false
                        strongSelf.storeSoundcloudSongData(son: song, songcategorty: songcategorty, song: soundcloudData, completion: { error,done in
                        if error == nil {
                            songdatabaseuploadCompletionStatus7 = true
                             print("\(song.name) database Soundcloud done")
                        } else {
                            songdatabaseuploadCompletionStatus7 = false
                            guard let error = error else {return}
                            print(error)
                            
                        }
                        bgroup.leave()
                    })
                    case 8:
                        songdatabaseuploadCompletionStatus8 = false
                        strongSelf.storeYoutubeMusicSongData(son: song, songcategorty: songcategorty, song: youtubeMusicData, completion: { error,done in
                        if error == nil {
                            songdatabaseuploadCompletionStatus8 = true
                             print("\(song.name) database Youtube Music done")
                        } else {
                            songdatabaseuploadCompletionStatus8 = false
                            guard let error = error else {return}
                            print(error)
                            
                        }
                        bgroup.leave()
                    })
                    case 9:
                        songdatabaseuploadCompletionStatus9 = false
                        strongSelf.storeAmazonSongData(son: song, songcategorty: songcategorty, song: amazonData, completion: { error,done in
                        if error == nil {
                            songdatabaseuploadCompletionStatus9 = true
                             print("\(song.name) database Amazon done")
                        } else {
                            songdatabaseuploadCompletionStatus9 = false
                            guard let error = error else {return}
                            print(error)
                            
                        }
                        bgroup.leave()
                    })
                    case 10:
                        songdatabaseuploadCompletionStatus10 = false
                        strongSelf.storeDeezerSongData(son: song, songcategorty: songcategorty, song: deezerData, completion: { error,done in
                        if error == nil {
                            songdatabaseuploadCompletionStatus10 = true
                             print("\(song.name) database Deezer done")
                        } else {
                            songdatabaseuploadCompletionStatus10 = false
                            guard let error = error else {return}
                            print(error)
                            
                        }
                        bgroup.leave()
                    })
                    case 11:
                        songdatabaseuploadCompletionStatus11 = false
                        strongSelf.storeSpinrillaSongData(son: song, songcategorty: songcategorty, song: spinrillaData, completion: { error,done in
                        if error == nil {
                            songdatabaseuploadCompletionStatus11 = true
                             print("\(song.name) database Spinrilla done")
                        } else {
                            songdatabaseuploadCompletionStatus11 = false
                            guard let error = error else {return}
                            print(error)
                            
                        }
                        bgroup.leave()
                    })
                    case 12:
                        songdatabaseuploadCompletionStatus12 = false
                        strongSelf.storeTidalSongData(son: song, songcategorty: songcategorty, song: tidalData, completion: { error,done in
                        if error == nil {
                            songdatabaseuploadCompletionStatus12 = true
                             print("\(song.name) database Tidal done")
                        } else {
                            songdatabaseuploadCompletionStatus12 = false
                            guard let error = error else {return}
                            print(error)
                            
                        }
                        bgroup.leave()
                    })
                    case 13:
                        songdatabaseuploadCompletionStatus13 = false
                        strongSelf.storeNapsterSongData(son: song, songcategorty: songcategorty, song: napsterData, completion: { error,done in
                        if error == nil {
                            songdatabaseuploadCompletionStatus13 = true
                             print("\(song.name) database Napster done")
                        } else {
                            songdatabaseuploadCompletionStatus13 = false
                            guard let error = error else {return}
                            print(error)
                            
                        }
                        bgroup.leave()
                    })
                    case 14:
                    songdatabaseuploadCompletionStatus7 = false
                        strongSelf.storeRequiredInstrumentalData(song: song, tracknum: tracknum, songcategorty: songcategorty, songUploadVideos: songUploadVideos, spotify: spotifyData ?? nil, deezer: deezerData, completion: { error,done in
                        if error == nil {
                            songdatabaseuploadCompletionStatus7 = true
                            print("\(song.name) database Required done")
                        } else {
                            songdatabaseuploadCompletionStatus7 = false
                            guard let error = error else {return}
                            print(error)
                            
                        }
                            bgroup.leave()
                        })
                    case 15:
                        songdatabaseuploadCompletionStatus15 = false
                        strongSelf.storeRemixToStandardEdition(song: song, completion: { error in
                            if error == nil {
                                songdatabaseuploadCompletionStatus15 = true
                            } else {
                                songdatabaseuploadCompletionStatus15 = false
                                guard let error = error else {return}
                                print(error)
                                
                            }
                            print("song remix store done")
                            bgroup.leave()
                        })
                    case 16:
                        songdatabaseuploadCompletionStatus16 = false
                        strongSelf.storeOtherVersionToStandardEditionSong(song: song, completion: { error in
                            if error == nil {
                                songdatabaseuploadCompletionStatus16 = true
                            } else {
                                songdatabaseuploadCompletionStatus16 = false
                                guard let error = error else {return}
                                print(error)
                                
                            }
                            print("song other version store done")
                            bgroup.leave()
                        })
                    default:
                        print("error")
                    }
                }
            }
            bgroup.notify(queue: DispatchQueue.main) { [weak self] in
                guard let strongSelf = self else {return}
                if songdatabaseuploadCompletionStatus1 == false || songdatabaseuploadCompletionStatus5 == false || songdatabaseuploadCompletionStatus6 == false || songdatabaseuploadCompletionStatus7 == false || songdatabaseuploadCompletionStatus8 == false || songdatabaseuploadCompletionStatus9 == false || songdatabaseuploadCompletionStatus10 == false || songdatabaseuploadCompletionStatus11 == false || songdatabaseuploadCompletionStatus12 == false || songdatabaseuploadCompletionStatus13 == false || songdatabaseuploadCompletionStatus14 == false || songdatabaseuploadCompletionStatus15 == false || songdatabaseuploadCompletionStatus16 == false {
                    Utilities.showError2("Upload Failed.", actionText: "OK")
                    return
                } else {
                    print("3 \(songartistref)")
                    strongSelf.updateSongRelations(song: song, songcategorty: songcategorty, songAppId: songAppId, tracknum: tracknum, songUploadVideos: songUploadVideos, songartistref: songartistref, songproducerref: songproducerref, songwriterref: songwriterref, songmixengref: songmixengineerref, songmasterengref: songmasteringengineerref, songrecengref: songrecorgingengineerref)
                }
            }
        })
        
    }
    
    func storeRequiredSongData(song: AlbumUploadSongData,tracknum: String, songcategorty:String, songUploadVideos: [String], completion: @escaping (Error?, Bool) -> Void) {
        var songUploadVids = songUploadVideos
        var instr = ""
        if instrumentals.isEmpty {
            instrumentals = []
        }
        if songUploadVids.count == 0 {
            songUploadVids = []
        }
        if song.instrumental != "" {
            instr = ""
        }
        var del:Bool!
        var ov:Bool!
        
        if song.isRemix != nil {
            del = true
        }
        if song.isOtherVersion != nil{
            del = true
        }
            var RequiredInfoMa = [String : Any]()
            RequiredInfoMa = [
                "Tone Deaf App Id" : song.toneDeafAppId,
                "Name" : song.name,
                "Artist" : song.artists,
                "Producers" : song.producers,
                "Writers" : song.writers,
                "Engineers": [
                    "Mix Engineer":song.mixEngineers,
                    "Mastering Engineer": song.masteringEngineers,
                    "Recording Engineer": song.recordingEngineers
                ],
                "Number of Favorites Overall" : 0,
                "Instrumentals": instrumentals,
                "Albums" : ["\(tDAppId)"],
                "Videos": songUploadVideos,
                "Time Registered To App": currtime,
                "Date Registered To App": currdate,
                "Verification Level": String(song.verificationLevel!),
                "Industry Certified": song.industryCerified,
                "Explicit": song.explicit,
                "Remix": [
                    "Status": del,
                    "Standard Edition": song.isRemix?.standardEdition
                ],
                "Other Versions": [
                    "Status": ov,
                    "Standard Edition": song.isOtherVersion?.standardEdition
                ],
                "Active Status": false
            ]
        
        Database.database().reference().child("All Content IDs").observeSingleEvent(of: .value, with: {[weak self] snap in
            guard let strongSelf = self else {return}
            var arr = snap.value as! [String]
            if !arr.contains("\(song.toneDeafAppId)") {
                arr.append("\(song.toneDeafAppId)")
            }
            Database.database().reference().child("All Content IDs").setValue(arr)
        })

        Database.database().reference().child("Music Content").child("Songs").child("All Song IDs").observeSingleEvent(of: .value, with: {[weak self] snap in
            guard let strongSelf = self else {return}
            var arr = snap.value as! [String]
            if !arr.contains("\(song.toneDeafAppId)") {
                arr.append("\(song.toneDeafAppId)")
            }
            Database.database().reference().child("Music Content").child("Songs").child("All Song IDs").setValue(arr)
        })
            
            let RequiredRef = Database.database().reference().child("Music Content").child("Songs").child(songcategorty).child("REQUIRED")
            RequiredRef.updateChildValues(RequiredInfoMa) { (error, songRef) in
                if let error = error {
                    print("📕 Failed to upload dictionary to database: \(error)")
                    completion(error, false)
                    return
                } else {
                    completion(nil, true)
                }
            }
    }
    
    func storeRequiredInstrumentalData(song: AlbumUploadSongData,tracknum: String, songcategorty:String, songUploadVideos: [String], spotify: SpotifySongData?, deezer: DeezerSongData?, completion: @escaping (Error?, Bool) -> Void) {
        var songUploadVids = songUploadVideos
        if songUploadVids.count == 0 {
            songUploadVids = []
        }
        var previewURL = ""
        if spotify != nil && spotify?.spotifyPreviewURL != "" {
            previewURL = spotify!.spotifyPreviewURL
        } else
        if deezer != nil && deezer?.previewURL != "" {
            previewURL = deezer!.previewURL
        }
        
        var SongInfoMap = [String : Any]()
        SongInfoMap = [
            "Tone Deaf App Id" : song.instrumental,
            "Name" : "\(song.name) (Instrumental)",
            "Artist" : song.artists,
            "Producers" : song.producers,
            "Engineers": [
                "Mix Engineer":song.mixEngineers,
                "Mastering Engineer": song.masteringEngineers
            ],
            "Time Uploaded To App" : currtime,
            "Date Uploaded To App" : currdate,
            "Duration" : "",
            "Number of Favorites" : 0,
            "Songs": song.songsForinstrumental,
            "Albums" : ["\(tDAppId)"],
            "Videos": songUploadVideos,
            "Audio URL" : previewURL,
            "Verification Level": String(verificationLevel),
            "Industry Certified": industryCertified,
            "Active Status": false
        ]
        
        Database.database().reference().child("All Content IDs").observeSingleEvent(of: .value, with: {[weak self] snap in
            guard let strongSelf = self else {return}
            var arr = snap.value as! [String]
            if !arr.contains("\(song.instrumental)") {
                arr.append("\(song.instrumental)")
            }
            Database.database().reference().child("All Content IDs").setValue(arr)
        })

        Database.database().reference().child("Music Content").child("Instrumentals").child("All Instrumental IDs").observeSingleEvent(of: .value, with: {[weak self] snap in
            guard let strongSelf = self else {return}
            if var arr = snap.value as? [String] {
                if !arr.contains("\(song.instrumental)") {
                    arr.append("\(song.instrumental)")
                }
                Database.database().reference().child("Music Content").child("Instrumentals").child("All Instrumental IDs").setValue(arr)
            } else {
                var arr:[String] = []
                if !arr.contains("\(song.instrumental)") {
                    arr.append("\(song.instrumental)")
                }
                Database.database().reference().child("Music Content").child("Instrumentals").child("All Instrumental IDs").setValue(arr)
            }
        })
        
        let SongRef = Database.database().reference().child("Music Content").child("Instrumentals").child(songcategorty)
        
        SongRef.updateChildValues(SongInfoMap) { (error, songRef) in
            if let error = error {
                print("📕 Failed to upload dictionary to database: \(error)")
                completion(error, false)
                return
            } else {
                completion(nil, true)
            }
        }
    }
    
    func storeSpotifySongData(son: AlbumUploadSongData, songcategorty: String, song: SpotifySongData, completion: @escaping (Error?, Bool) -> Void) {
        let spotifyContentRandomKey = ("\(spotifyMusicContentType)--\(son.name)--\(currdate)--\(currtime)")
        
            var SongInfoMap = [String : Any]()
            SongInfoMap = [
                "Name" : song.spotifyName,
                "Artist 1" : song.spotifyArtist1,
                "Artist 1 URL" : song.spotifyArtist1URL,
                "Artist 2" : song.spotifyArtist2,
                "Artist 2 URL" : song.spotifyArtist2URL,
                "Artist 3" : song.spotifyArtist3,
                "Artist 3 URL" : song.spotifyArtist3URL,
                "Artist 4" : song.spotifyArtist4,
                "Artist 4 URL" : song.spotifyArtist4URL,
                "Artist 5" : song.spotifyArtist5,
                "Artist 5 URL" : song.spotifyArtist5URL,
                "Artist 6" : song.spotifyArtist6,
                "Artist 6 URL" : song.spotifyArtis6URL,
                "Explicity" : song.spotifyExplicity,
                "Preview URL" : song.spotifyPreviewURL,
                "ISRC" : song.spotifyISRC,
                "Date Released On Spotify" : song.spotifyDateSPT,
                "Time Uploaded To App" : song.spotifyTimeIA,
                "Date Uploaded To App" : song.spotifyDateIA,
                "Duration" : song.spotifyDuration,
                "Artwork URL" : song.spotifyArtworkURL,
                "Song URL" : song.spotifySongURL,
                "Number of Favorites" : song.spotifyFavorites,
                "Track Number" : song.spotifyTrackNumber,
                "Album Type" : song.spotifyAlbumType,
                "Spotify Id" : song.spotifyId,
                "Active Status": false
            ]
        var SongRef:DatabaseReference
        if son.instrumental != "" {
            SongRef = Database.database().reference().child("Music Content").child("Instrumentals").child(songcategorty).child(spotifyContentRandomKey)
        } else {
            SongRef = Database.database().reference().child("Music Content").child("Songs").child(songcategorty).child(spotifyContentRandomKey)
        }
        
        SongRef.updateChildValues(SongInfoMap) { [weak self] (error, songRef) in
            if let error = error {
                print("📕 Failed to upload dictionary to database: \(error)")
                Utilities.showError2("Failed to Upload. Please try again.", actionText: "OK")
                completion(error, false)
                return
            } else {
//                print("kjhgfdgsdgghjkjl")
                completion(nil, true)
                print("📗 Spotify data for \(son.name) saved to database successfully.")
                return
            }
        }
    }
    
    func storeAppleSongData(son: AlbumUploadSongData, songcategorty: String, song: AppleMusicSongData, completion: @escaping (Error?, Bool) -> Void) {
        let appleContentRandomKey = ("\(appleMusicContentType)--\(son.name)--\(currdate)--\(currtime)")
        
            var SongInfoMap = [String : Any]()
            SongInfoMap = [
                "Name" : song.appleName,
                "Artist" : song.appleArtist,
                "Explicity" : song.appleExplicity,
                "Preview URL" : song.applePreviewURL,
                "ISRC" : song.appleISRC,
                "Date Released On Apple" : song.appleDateAPPL,
                "Time Uploaded To App" : song.appleTimeIA,
                "Date Uploaded To App" : song.appleDateIA,
                "Duration" : song.appleDuration,
                "Artwork URL" : song.appleArtworkURL,
                "Song URL" : song.appleSongURL,
                "Album Name" : song.appleAlbumName,
                "Composers" : song.applecomposers,
                "Genres" : song.appleGenres,
                "Number of Favorites" : song.appleFavorites,
                "Track Number" : song.appleTrackNumber,
                "Apple Music Id" : song.appleMusicId,
                "Active Status": false
            ]
            
            var SongRef:DatabaseReference
            if son.instrumental != "" {
                SongRef = Database.database().reference().child("Music Content").child("Instrumentals").child(songcategorty).child(appleContentRandomKey)
            } else {
                SongRef = Database.database().reference().child("Music Content").child("Songs").child(songcategorty).child(appleContentRandomKey)
            }
            
            SongRef.updateChildValues(SongInfoMap) { [weak self] (error, songRef) in
                if let error = error {
                    print("📕 Failed to upload dictionary to database: \(error)")
                    Utilities.showError2("Failed to Upload. Please try again.", actionText: "OK")
                    completion(error, false)
                    return
                } else {
                    print("kjhgfdgsdgghjkjl")
                    completion(nil, true)
                    print("📗 Apple data for \(son.name) saved to database successfully.")
                    return
                }
            }
    }
    
    func storeSoundcloudSongData(son: AlbumUploadSongData, songcategorty: String, song: SoundcloudSongData, completion: @escaping (Error?, Bool) -> Void) {
        let soundcloudContentRandomKey = ("\(soundcloudMusicContentType)--\(son.name)--\(currdate)--\(currtime)")
        
        var SongInfoMap = [String : Any]()
        SongInfoMap = [
            "url" : song.url,
            "Active Status": false]
        
        var SongRef:DatabaseReference
        if son.instrumental != "" {
            SongRef = Database.database().reference().child("Music Content").child("Instrumentals").child(songcategorty).child(soundcloudContentRandomKey)
        } else {
            SongRef = Database.database().reference().child("Music Content").child("Songs").child(songcategorty).child(soundcloudContentRandomKey)
        }
        
        SongRef.updateChildValues(SongInfoMap) { [weak self] (error, songRef) in
            guard let strongSelf = self else {return}
            if let error = error {
                print("📕 Failed to upload dictionary to database: \(error)")
                Utilities.showError2("Failed to Upload. Please try again.", actionText: "OK")
                completion(error, false)
                return
            } else {
                completion(nil, true)
                print("📗 Soundcloud data for \(son.name) saved to database successfully.")
                return
            }
        }
    }
    
    func storeYoutubeMusicSongData(son: AlbumUploadSongData, songcategorty: String, song: YoutubeMusicSongData, completion: @escaping (Error?, Bool) -> Void) {
        let youtubeMusicContentRandomKey = ("\(youtubeMusicContentType)--\(son.name)--\(currdate)--\(currtime)")
        
        var SongInfoMap = [String : Any]()
        SongInfoMap = [
            "url" : song.url,
            "Active Status": false]
        
        var SongRef:DatabaseReference
        if son.instrumental != "" {
            SongRef = Database.database().reference().child("Music Content").child("Instrumentals").child(songcategorty).child(youtubeMusicContentRandomKey)
        } else {
            SongRef = Database.database().reference().child("Music Content").child("Songs").child(songcategorty).child(youtubeMusicContentRandomKey)
        }
        
        SongRef.updateChildValues(SongInfoMap) { [weak self] (error, songRef) in
            guard let strongSelf = self else {return}
            if let error = error {
                print("📕 Failed to upload dictionary to database: \(error)")
                Utilities.showError2("Failed to Upload. Please try again.", actionText: "OK")
                completion(error, false)
                return
            } else {
                completion(nil, true)
                print("📗 Youtube Music data for \(son.name) saved to database successfully.")
                return
            }
        }
    }
    
    func storeAmazonSongData(son: AlbumUploadSongData, songcategorty: String, song: AmazonSongData, completion: @escaping (Error?, Bool) -> Void) {
        let amazonContentRandomKey = ("\(amazonMusicContentType)--\(son.name)--\(currdate)--\(currtime)")
        var SongInfoMap = [String : Any]()
        SongInfoMap = [
            "url" : song.url,
            "Active Status": false]
        
        var SongRef:DatabaseReference
        if son.instrumental != "" {
            SongRef = Database.database().reference().child("Music Content").child("Instrumentals").child(songcategorty).child(amazonContentRandomKey)
        } else {
            SongRef = Database.database().reference().child("Music Content").child("Songs").child(songcategorty).child(amazonContentRandomKey)
        }
        
        SongRef.updateChildValues(SongInfoMap) { [weak self] (error, songRef) in
            guard let strongSelf = self else {return}
            if let error = error {
                print("📕 Failed to upload dictionary to database: \(error)")
                Utilities.showError2("Failed to Upload. Please try again.", actionText: "OK")
                completion(error, false)
                return
            } else {
                completion(nil, true)
                print("📗 Amazon data for \(son.name) saved to database successfully.")
                return
            }
        }
    }
    
    func storeTidalSongData(son: AlbumUploadSongData, songcategorty: String, song: TidalSongData, completion: @escaping (Error?, Bool) -> Void) {
        let tidalContentRandomKey = ("\(tidalMusicContentType)--\(son.name)--\(currdate)--\(currtime)")
        
        var SongInfoMap = [String : Any]()
        SongInfoMap = [
            "url" : song.url,
            "Active Status": false]
        
        var SongRef:DatabaseReference
        if son.instrumental != "" {
            SongRef = Database.database().reference().child("Music Content").child("Instrumentals").child(songcategorty).child(tidalContentRandomKey)
        } else {
            SongRef = Database.database().reference().child("Music Content").child("Songs").child(songcategorty).child(tidalContentRandomKey)
        }
        
        SongRef.updateChildValues(SongInfoMap) { [weak self] (error, songRef) in
            guard let strongSelf = self else {return}
            if let error = error {
                print("📕 Failed to upload dictionary to database: \(error)")
                Utilities.showError2("Failed to Upload. Please try again.", actionText: "OK")
                completion(error, false)
                return
            } else {
                completion(nil, true)
                print("📗 Tidal data for \(son.name) saved to database successfully.")
                return
            }
        }
    }
    
    func storeSpinrillaSongData(son: AlbumUploadSongData, songcategorty: String, song: SpinrillaSongData, completion: @escaping (Error?, Bool) -> Void) {
        let spinrillaContentRandomKey = ("\(spinrillaMusicContentType)--\(son.name)--\(currdate)--\(currtime)")
        
        var SongInfoMap = [String : Any]()
        SongInfoMap = [
            "url" : song.url,
            "Active Status": false]
        
        var SongRef:DatabaseReference
        if son.instrumental != "" {
            SongRef = Database.database().reference().child("Music Content").child("Instrumentals").child(songcategorty).child(spinrillaContentRandomKey)
        } else {
            SongRef = Database.database().reference().child("Music Content").child("Songs").child(songcategorty).child(spinrillaContentRandomKey)
        }
        
        SongRef.updateChildValues(SongInfoMap) { [weak self] (error, songRef) in
            guard let strongSelf = self else {return}
            if let error = error {
                print("📕 Failed to upload dictionary to database: \(error)")
                Utilities.showError2("Failed to Upload. Please try again.", actionText: "OK")
                completion(error, false)
                return
            } else {
                completion(nil, true)
                print("📗 Spinrilla data for \(son.name) saved to database successfully.")
                return
            }
        }
    }
    
    func storeNapsterSongData(son: AlbumUploadSongData, songcategorty: String, song: NapsterSongData, completion: @escaping (Error?, Bool) -> Void) {
        let napsterContentRandomKey = ("\(napsterMusicContentType)--\(son.name)--\(currdate)--\(currtime)")
        
        var SongInfoMap = [String : Any]()
        SongInfoMap = [
            "url" : song.url,
            "Active Status": false]
        
        var SongRef:DatabaseReference
        if son.instrumental != "" {
            SongRef = Database.database().reference().child("Music Content").child("Instrumentals").child(songcategorty).child(napsterContentRandomKey)
        } else {
            SongRef = Database.database().reference().child("Music Content").child("Songs").child(songcategorty).child(napsterContentRandomKey)
        }
        
        SongRef.updateChildValues(SongInfoMap) { [weak self] (error, songRef) in
            guard let strongSelf = self else {return}
            if let error = error {
                print("📕 Failed to upload dictionary to database: \(error)")
                Utilities.showError2("Failed to Upload. Please try again.", actionText: "OK")
                completion(error, false)
                return
            } else {
                completion(nil, true)
                print("📗 Spinrilla data for \(son.name) saved to database successfully.")
                return
            }
        }
    }
    
    func storeDeezerSongData(son: AlbumUploadSongData, songcategorty: String, song: DeezerSongData, completion: @escaping (Error?, Bool) -> Void) {
        let deezerContentRandomKey = ("\(deezerMusicContentType)--\(son.name)--\(currdate)--\(currtime)")
        
        var SongInfoMap = [String : Any]()
        SongInfoMap = [
            "Name" : song.name,
            "Artist" : song.artist,
            "Preview URL" : song.previewURL,
            "ISRC" : song.isrc,
            "Date Released On Deezer" : song.deezerDate,
            "Time Registered To App" : currtime,
            "Date Registered To App" : currdate,
            "Duration" : song.duration,
            "Artwork URL" : song.imageurl,
            "Song URL" : song.url,
            "Deezer Music Id" : song.deezerID,
            "Active Status" : false
        ]
        
        var SongRef:DatabaseReference
        if son.instrumental != "" {
            SongRef = Database.database().reference().child("Music Content").child("Instrumentals").child(songcategorty).child(deezerContentRandomKey)
        } else {
            SongRef = Database.database().reference().child("Music Content").child("Songs").child(songcategorty).child(deezerContentRandomKey)
        }
        
        SongRef.updateChildValues(SongInfoMap) { [weak self] (error, songRef) in
            guard let strongSelf = self else {return}
            if let error = error {
                print("📕 Failed to upload dictionary to database: \(error)")
                Utilities.showError2("Failed to Upload. Please try again.", actionText: "OK")
                completion(error, false)
                return
            } else {
                completion(nil, true)
                print("📗 Deezer data for \(son.name) saved to database successfully.")
                return
            }
        }
    }
    
    func storeRemixToStandardEdition(song: AlbumUploadSongData, completion: @escaping ((Error?) -> Void)) {
        DatabaseManager.shared.findSongById(songId: song.isRemix!.standardEdition!, completion: {[weak self] result in
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
    
    func storeOtherVersionToStandardEditionSong(song: AlbumUploadSongData, completion: @escaping ((Error?) -> Void)) {
        DatabaseManager.shared.findSongById(songId: song.isOtherVersion!.standardEdition!, completion: {[weak self] result in
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
    
    func updateSongRelations(song: AlbumUploadSongData, songcategorty: String, songAppId:String, tracknum: String, songUploadVideos:[String], songartistref: [String], songproducerref: [String], songwriterref:[String], songmixengref:[String], songmasterengref:[String], songrecengref:[String]) {
        var relationalCompletion1:Bool!
        var relationalCompletion2:Bool!
        var relationalCompletion3:Bool!
        var relationalCompletion4:Bool!
        var relationalCompletion5:Bool!
        var relationalCompletion6:Bool!
        var relationalCompletion7:Bool!
        var relationalCompletion8:Bool!
        var relationalCompletion9:Bool!
        var relationalCompletion10:Bool!
        var relationalCompletion11:Bool!
        var relationalCompletion12:Bool!
        var relationalCompletion13:Bool!
        var relationalCompletion14:Bool!
        var relationalCompletion15:Bool!
        var relationalCompletion16:Bool!
        var relationalCompletion17:Bool!
        var relationalCompletion18:Bool!
        var relationalCompletion19:Bool!
        var relationalCompletion20:Bool!
        var relationalCompletion21:Bool!
        var relationalCompletion22:Bool!
        var relationalCompletion23:Bool!
        var relationalCompletion24:Bool!
        var relationalCompletion25:Bool!
        var relationalCompletion26:Bool!
        var relationalCompletion27:Bool!
        var relationalCompletion28:Bool!
        var relationalCompletion29:Bool!
        var relationalCompletion30:Bool!
        var relationalCompletion31:Bool!
        var relationalCompletion32:Bool!
        var relationalCompletion33:Bool!
        var relationalCompletion34:Bool!
        var relationalCompletion35:Bool!
        var relationalCompletion36:Bool!
        var relationalCompletion37:Bool!
        var relationalCompletion38:Bool!
        let cqueue = DispatchQueue(label: "myhjvsdfhjghjhggjnfbdsbxkhQueue")
        let cgroup = DispatchGroup()
        var newarray = [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36]
        //print("songsforinstr \(song.songsForinstrumental.isEmpty), \(song.songsForinstrumental)")
        if song.songsForinstrumental.isEmpty == false {
            newarray.append(37)
        }
        //print("artist refs \(songartistref)")
        //print("producer refs \(songproducerref)")
        for i in newarray {
            //print(i)
            cgroup.enter()
            cqueue.async { [weak self] in
                guard let strongSelf = self else {return}
                switch i {
                case 1:
                    relationalCompletion1 = false
                    strongSelf.updateSongVideos(song: song, songcategorty: songcategorty, songUploadVideos: songUploadVideos ,completion: { done in
                        if done == false {
                            Utilities.showError2("\(song.name) videos failed to update.", actionText: "OK")
                            relationalCompletion1 = false
                        }
                        else {
                            relationalCompletion1 = true
                            print("c done \(i)")
                            cgroup.leave()
                            
                        }
                    })
                case 2://
//                    print("4a \(songartistref)")
                    relationalCompletion2 = false
                    strongSelf.updateArtistSongs(song: song, songartistref: songartistref, completion: { done in
                        if done == false {
                            Utilities.showError2("Artist songs failed to update.", actionText: "OK")
                            relationalCompletion2 = false
                        }
                        else {
                            relationalCompletion2 = true
                            print("c done \(i)")
                            cgroup.leave()
                        }
                    })
                case 3://
//                    print("4b \(songartistref)")
                    relationalCompletion3 = false
                    strongSelf.updateArtistVideos(song: song, songUploadVideos: songUploadVideos, songartistref: songartistref, completion: { done in
                        if done == false {
                            Utilities.showError2("Artist videos failed to update.", actionText: "OK")
                            relationalCompletion3 = false
                        }
                        else {
                            relationalCompletion3 = true
                            print("c done \(i)")
                            cgroup.leave()
                        }
                    })
                case 4:
                    relationalCompletion4 = false
                    strongSelf.updateProducerSongs(song: song, songproducerref: songproducerref, completion: { done in
                        if done == false {
                            Utilities.showError2("Producer songs failed to update.", actionText: "OK")
                            relationalCompletion4 = false
                        }
                        else {
                            relationalCompletion4 = true
                            print("c done \(i)")
                            cgroup.leave()
                        }
                    })
                case 5:
                    relationalCompletion5 = false
                    strongSelf.updateProducerVideos(song: song, songUploadVideos: songUploadVideos,songproducerref: songproducerref, completion: { done in
                        if done == false {
                            Utilities.showError2("Producer Videos failed to update.", actionText: "OK")
                            relationalCompletion5 = false
                        }
                        else {
                            relationalCompletion5 = true
                            print("c done \(i)")
                            cgroup.leave()
                        }
                    })
                case 6:
                    relationalCompletion6 = false
                    strongSelf.updateWriterSongs(song: song, songwriterref: songwriterref, completion: { done in
                        if done == false {
                            Utilities.showError2("Writer songs failed to update.", actionText: "OK")
                            relationalCompletion6 = false
                        }
                        else {
                            relationalCompletion6 = true
                            print("c done \(i)")
                            cgroup.leave()
                        }
                    })
                case 7:
                    relationalCompletion7 = false
                    strongSelf.updateWriterVideos(song: song, songUploadVideos: songUploadVideos,songproducerref: songwriterref, completion: { done in
                        if done == false {
                            Utilities.showError2("Writer Videos failed to update.", actionText: "OK")
                            relationalCompletion7 = false
                        }
                        else {
                            relationalCompletion7 = true
                            print("c done \(i)")
                            cgroup.leave()
                        }
                    })
                case 8:
                    relationalCompletion8 = false
                    strongSelf.updateMixEngineerSongs(song: song, songmixengineerref: songmixengref, completion: { done in
                        if done == false {
                            Utilities.showError2("Mix Engineer songs failed to update.", actionText: "OK")
                            relationalCompletion8 = false
                        }
                        else {
                            relationalCompletion8 = true
                            print("c done \(i)")
                            cgroup.leave()
                        }
                    })
                case 9:
                    relationalCompletion9 = false
                    strongSelf.updateMixEngineerVideos(song: song, songUploadVideos: songUploadVideos,songproducerref: songmixengref, completion: { done in
                        if done == false {
                            Utilities.showError2("Mix Engineer Videos failed to update.", actionText: "OK")
                            relationalCompletion9 = false
                        }
                        else {
                            relationalCompletion9 = true
                            print("c done \(i)")
                            cgroup.leave()
                        }
                    })
                case 10:
                    relationalCompletion10 = false
                    strongSelf.updateMasteringEngineerSongs(song: song, songmasteringengineerref: songmasterengref, completion: { done in
                        if done == false {
                            Utilities.showError2("MasteringEngineer songs failed to update.", actionText: "OK")
                            relationalCompletion10 = false
                        }
                        else {
                            relationalCompletion10 = true
                            print("c done \(i)")
                            cgroup.leave()
                        }
                    })
                case 11:
                    relationalCompletion11 = false
                    strongSelf.updateMasteringEngineerVideos(song: song, songUploadVideos: songUploadVideos,songproducerref: songmasterengref, completion: { done in
                        if done == false {
                            Utilities.showError2("MasteringEngineer Videos failed to update.", actionText: "OK")
                            relationalCompletion11 = false
                        }
                        else {
                            relationalCompletion11 = true
                            print("c done \(i)")
                            cgroup.leave()
                        }
                    })
                case 12:
                    relationalCompletion12 = false
                    strongSelf.updateRecordingEngineerSongs(song: song, songrecordingengineerref: songrecengref, completion: { done in
                        if done == false {
                            Utilities.showError2("RecordingEngineer songs failed to update.", actionText: "OK")
                            relationalCompletion12 = false
                        }
                        else {
                            relationalCompletion12 = true
                            print("c done \(i)")
                            cgroup.leave()
                        }
                    })
                case 13:
                    relationalCompletion13 = false
                    strongSelf.updateRecordingEngineerVideos(song: song, songUploadVideos: songUploadVideos,songproducerref: songrecengref, completion: { done in
                        if done == false {
                            Utilities.showError2("RecordingEngineer Videos failed to update.", actionText: "OK")
                            relationalCompletion13 = false
                        }
                        else {
                            relationalCompletion13 = true
                            print("c done \(i)")
                            cgroup.leave()
                        }
                    })
                case 14://
                    relationalCompletion14 = false
//                    print("4c \(songartistref)")
                    strongSelf.updateArtistAlbums(song: song, songartistref: songartistref, completion: { done in
                        if done == false {
                            Utilities.showError2("Artist albums failed to update.", actionText: "OK")
                            relationalCompletion14 = false
                        }
                        else {
                            relationalCompletion14 = true
                            print("c done \(i)")
                            cgroup.leave()
                        }
                    })
                case 15:
                    relationalCompletion15 = false
                    strongSelf.updateProducerAlbums(song: song, songproducerref: songproducerref, completion: { done in
                        if done == false {
                            Utilities.showError2("Producer albums failed to update.", actionText: "OK")
                            relationalCompletion15 = false
                        }
                        else {
                            relationalCompletion15 = true
                            print("c done \(i)")
                            cgroup.leave()
                        }
                    })
                case 16:
                    relationalCompletion16 = false
                    strongSelf.updateWriterAlbums(song: song, songwriterref: songwriterref, completion: { done in
                        if done == false {
                            Utilities.showError2("Writer albums failed to update.", actionText: "OK")
                            relationalCompletion16 = false
                        }
                        else {
                            relationalCompletion16 = true
                            print("c done \(i)")
                            cgroup.leave()
                        }
                    })
                case 17:
                    relationalCompletion17 = false
                    strongSelf.updateMixEngineerAlbums(song: song, songmixengineerref: songmixengref, completion: { done in
                        if done == false {
                            Utilities.showError2("Mix Engineer albums failed to update.", actionText: "OK")
                            relationalCompletion17 = false
                        }
                        else {
                            relationalCompletion17 = true
                            print("c done \(i)")
                            cgroup.leave()
                        }
                    })
                case 18:
                    relationalCompletion18 = false
                    strongSelf.updateMasteringEngineerAlbums(song: song, songmasteringengineerref: songmasterengref, completion: { done in
                        if done == false {
                            Utilities.showError2("Mastering Engineer albums failed to update.", actionText: "OK")
                            relationalCompletion18 = false
                        }
                        else {
                            relationalCompletion18 = true
                            print("c done \(i)")
                            cgroup.leave()
                        }
                    })
                case 19:
                    relationalCompletion19 = false
                    strongSelf.updateRecordingEngineerAlbums(song: song, songrecordingengineerref: songrecengref, completion: { done in
                        if done == false {
                            Utilities.showError2("Recording Engineer albums failed to update.", actionText: "OK")
                            relationalCompletion19 = false
                        }
                        else {
                            relationalCompletion19 = true
                            print("c done \(i)")
                            cgroup.leave()
                        }
                    })
                case 20:
                    relationalCompletion20 = false
                    strongSelf.updateAlbumTracks(song: song, tracknum: tracknum, completion: { done in
                        
                        if done == false {
                            Utilities.showError2("Album songs failed to update.", actionText: "OK")
                            relationalCompletion20 = false
                        }
                        else {
                            
                            relationalCompletion20 = true
                            print("c done \(i)")
                            cgroup.leave()
                        }
                    })
                case 21:
                    relationalCompletion21 = false
                    strongSelf.updateAlbumVideos(song: song, songUploadVideos: songUploadVideos, completion: { done in
                        
                        if done == false {
                            Utilities.showError2("Artist videos failed to update.", actionText: "OK")
                            relationalCompletion21 = false
                        } else {
                            
                            relationalCompletion21 = true
                            print("c done \(i)")
                            cgroup.leave()
                        }
                    })
                case 22:
                    relationalCompletion22 = false
                    strongSelf.updateAlbumArtists(song: song, completion: { done in
                        if done == false {
                            Utilities.showError2("Album Artist failed to update.", actionText: "OK")
                            relationalCompletion22 = false
                        }
                        else {
                            relationalCompletion22 = true
                            print("c done \(i)")
                            cgroup.leave()
                        }
                    })
                case 23:
                    relationalCompletion23 = false
                    strongSelf.updateAlbumProducers(song: song, completion: { done in
                        if done == false {
                            Utilities.showError2("Album Artist failed to update.", actionText: "OK")
                            relationalCompletion23 = false
                        }
                        else {
                            relationalCompletion23 = true
                            print("c done \(i)")
                            cgroup.leave()
                        }
                    })
                case 24:
                    relationalCompletion24 = false
                    strongSelf.updateAlbumWriters(song: song, completion: { done in
                        if done == false {
                            Utilities.showError2("Album writers failed to update.", actionText: "OK")
                            relationalCompletion24 = false
                        }
                        else {
                            relationalCompletion24 = true
                            print("c done \(i)")
                            cgroup.leave()
                        }
                    })
                case 25:
                    relationalCompletion25 = false
                    strongSelf.updateAlbumMixEngineers(song: song, completion: { done in
                        if done == false {
                            Utilities.showError2("Album mix engineers failed to update.", actionText: "OK")
                            relationalCompletion25 = false
                        }
                        else {
                            relationalCompletion25 = true
                            print("c done \(i)")
                            cgroup.leave()
                        }
                    })
                case 26:
                    relationalCompletion26 = false
                    strongSelf.updateAlbumMasteringEngineers(song: song, completion: { done in
                        if done == false {
                            Utilities.showError2("Album mastering engineers failed to update.", actionText: "OK")
                            relationalCompletion26 = false
                        }
                        else {
                            relationalCompletion26 = true
                            print("c done \(i)")
                            cgroup.leave()
                        }
                    })
                case 27:
                    relationalCompletion27 = false
                    strongSelf.updateAlbumRecordingEngineers(song: song, completion: { done in
                        if done == false {
                            Utilities.showError2("Album recording engineers failed to update.", actionText: "OK")
                            relationalCompletion27 = false
                        }
                        else {
                            relationalCompletion27 = true
                            print("c done \(i)")
                            cgroup.leave()
                        }
                    })
                case 28:
                    relationalCompletion28 = false
                    strongSelf.updateProducerInstrumentals(song: song, songproducerref: songproducerref, completion: { done in
                        if done == false {
                            Utilities.showError2("Producer instrumentals failed to update.", actionText: "OK")
                            relationalCompletion28 = false
                        }
                        else {
                            relationalCompletion28 = true
                            print("c done \(i)")
                            cgroup.leave()
                        }
                    })
                case 29:
                    relationalCompletion29 = false
                    strongSelf.updateArtistRoles(song: song, songartistref: songartistref, completion: { done in
                        if done == false {
                            Utilities.showError2("Artist roles failed to update.", actionText: "OK")
                            relationalCompletion29 = false
                        }
                        else {
                            relationalCompletion29 = true
                            print("c done \(i)")
                            cgroup.leave()
                        }
                    })
                case 30:
                    relationalCompletion30 = false
                    strongSelf.updateProducerRoles(song: song, songartistref: songproducerref, completion: { done in
                        if done == false {
                            Utilities.showError2("Producer roles failed to update.", actionText: "OK")
                            relationalCompletion30 = false
                        }
                        else {
                            relationalCompletion30 = true
                            print("c done \(i)")
                            cgroup.leave()
                        }
                    })
                case 31:
                    relationalCompletion31 = false
                    strongSelf.updateWriterRoles(song: song, songartistref: songwriterref, completion: { done in
                        if done == false {
                            Utilities.showError2("Writer roles failed to update.", actionText: "OK")
                            relationalCompletion31 = false
                        }
                        else {
                            relationalCompletion31 = true
                            print("c done \(i)")
                            cgroup.leave()
                        }
                    })
                case 32:
                    relationalCompletion32 = false
                    strongSelf.updateMixEngineerRoles(song: song, songmixengineerref: songmixengref, completion: { done in
                        if done == false {
                            Utilities.showError2("Mix Engineer roles failed to update.", actionText: "OK")
                            relationalCompletion32 = false
                        }
                        else {
                            relationalCompletion32 = true
                            print("c done \(i)")
                            cgroup.leave()
                        }
                    })
                case 33:
                    relationalCompletion33 = false
                    strongSelf.updateMasteringEngineerRoles(song: song, songmasteringengineerref: songmasterengref, completion: { done in
                        if done == false {
                            Utilities.showError2("Mastering Engineer roles failed to update.", actionText: "OK")
                            relationalCompletion33 = false
                        }
                        else {
                            relationalCompletion33 = true
                            print("c done \(i)")
                            cgroup.leave()
                        }
                    })
                case 34:
                    relationalCompletion34 = false
                    strongSelf.updateRecordingEngineerRoles(song: song, songrecordingengineerref: songrecengref, completion: { done in
                        if done == false {
                            Utilities.showError2("Recording Engineer roles failed to update.", actionText: "OK")
                            relationalCompletion34 = false
                        }
                        else {
                            relationalCompletion34 = true
                            print("c done \(i)")
                            cgroup.leave()
                        }
                    })
                case 35:
                    relationalCompletion35 = false
                    strongSelf.updateAlbumArtistRoles(song: song, songartistref: songartistref, completion: { done in
                        if done == false {
                            Utilities.showError2("Album Artist roles failed to update.", actionText: "OK")
                            relationalCompletion35 = false
                        }
                        else {
                            relationalCompletion35 = true
                            print("c done \(i)")
                            cgroup.leave()
                        }
                    })
                case 36:
                    relationalCompletion36 = false
                    strongSelf.updateArtistInstrumentals(song: song, songartistref: songartistref, completion: { done in
                        if done == false {
                            Utilities.showError2("Artist instrumentals failed to update.", actionText: "OK")
                            relationalCompletion36 = false
                        }
                        else {
                            relationalCompletion36 = true
                            print("c done \(i)")
                            cgroup.leave()
                        }
                    })
                case 37:
                    relationalCompletion37 = false
                    strongSelf.updateSongInstrumentals(song: song, completion: { done in
                        if done == false {
                            Utilities.showError2("Update Song instrumentals failed to update.", actionText: "OK")
                            relationalCompletion37 = false
                        }
                        else {
                            relationalCompletion37 = true
                            print("c done \(i)")
                            cgroup.leave()
                        }
                    })
                default:
                    print("error")
                }
            }
        }
        cgroup.notify(queue: DispatchQueue.main) { [weak self] in
            guard let strongSelf = self else {return}
            if relationalCompletion1 == false || relationalCompletion2 == false || relationalCompletion3 == false || relationalCompletion4 == false || relationalCompletion5 == false || relationalCompletion6 == false || relationalCompletion7 == false || relationalCompletion8 == false || relationalCompletion9 == false || relationalCompletion10 == false || relationalCompletion11 == false || relationalCompletion12 == false || relationalCompletion13 == false || relationalCompletion14 == false || relationalCompletion15 == false || relationalCompletion16 == false || relationalCompletion17 == false || relationalCompletion18 == false || relationalCompletion19 == false || relationalCompletion20 == false || relationalCompletion21 == false || relationalCompletion22 == false || relationalCompletion23 == false || relationalCompletion24 == false || relationalCompletion25 == false || relationalCompletion26 == false || relationalCompletion27 == false || relationalCompletion28 == false || relationalCompletion29 == false || relationalCompletion30 == false || relationalCompletion31 == false || relationalCompletion32 == false || relationalCompletion33 == false || relationalCompletion34 == false || relationalCompletion35 == false || relationalCompletion36 == false || relationalCompletion37 == false || relationalCompletion38 == false {
                Utilities.showError2("Upload Failed.", actionText: "OK")
                return
            } else {
                relationalCompletion1 = false
                relationalCompletion2 = false
                relationalCompletion3 = false
                relationalCompletion4 = false
                relationalCompletion5 = false
                relationalCompletion6 = false
                relationalCompletion7 = false
                relationalCompletion8 = false
                relationalCompletion9 = false
                relationalCompletion10 = false
                relationalCompletion11 = false
                relationalCompletion12 = false
                relationalCompletion13 = false
                relationalCompletion14 = false
                relationalCompletion15 = false
                relationalCompletion16 = false
                relationalCompletion17 = false
                relationalCompletion18 = false
                relationalCompletion19 = false
                relationalCompletion20 = false
                relationalCompletion21 = false
                relationalCompletion22 = false
                relationalCompletion23 = false
                relationalCompletion24 = false
                relationalCompletion25 = false
                relationalCompletion26 = false
                relationalCompletion27 = false
                relationalCompletion28 = false
                relationalCompletion29 = false
                relationalCompletion30 = false
                relationalCompletion31 = false
                relationalCompletion32 = false
                relationalCompletion33 = false
                relationalCompletion34 = false
                relationalCompletion35 = false
                relationalCompletion36 = false
                relationalCompletion37 = false
                relationalCompletion38 = false
                strongSelf.songsdone+=1
                if strongSelf.songsdone == strongSelf.songcount {
                    print("📗 \(strongSelf.albumName) data saved to database successfully.")
                    Utilities.successBarBanner("\(strongSelf.albumName) upload successful.")
                    DispatchQueue.global(qos: .userInitiated).async {
                        strongSelf.semaphore.signal()
                    }
                    albumUploadSongsArray = []
                    _ = strongSelf.navigationController?.popViewController(animated: true)
                } else {
                    strongSelf.semaphore.signal()
                }
            }
        }
    }
    
    func updateSongRelationsV2(song: AlbumUploadSongData, songcategorty: String, tracknum: String, songUploadVideos:[String], songartistref: [String], songproducerref: [String], songwriterref:[String], songmixengref:[String], songmasterengref:[String], songrecengref:[String]) {
        var relationalCompletion1:Bool!
        var relationalCompletion2:Bool!
        var relationalCompletion3:Bool!
        var relationalCompletion4:Bool!
        var relationalCompletion5:Bool!
        var relationalCompletion6:Bool!
        var relationalCompletion7:Bool!
        var relationalCompletion8:Bool!
        var relationalCompletion9:Bool!
        var relationalCompletion10:Bool!
        var relationalCompletion11:Bool!
        var relationalCompletion12:Bool!
        var relationalCompletion13:Bool!
        var relationalCompletion14:Bool!
        var relationalCompletion15:Bool!
        var relationalCompletion16:Bool!
        var relationalCompletion17:Bool!
        var relationalCompletion18:Bool!
        var relationalCompletion19:Bool!
        var relationalCompletion20:Bool!
        var relationalCompletion21:Bool!
        var relationalCompletion22:Bool!
        var relationalCompletion23:Bool!
        var relationalCompletion24:Bool!
        var relationalCompletion25:Bool!
        var relationalCompletion26:Bool!
        var relationalCompletion27:Bool!
        var relationalCompletion28:Bool!
        var relationalCompletion29:Bool!
        var relationalCompletion30:Bool!
        var relationalCompletion31:Bool!
        var relationalCompletion32:Bool!
        var relationalCompletion33:Bool!
        var relationalCompletion34:Bool!
        var relationalCompletion35:Bool!
        var relationalCompletion36:Bool!
        var relationalCompletion37:Bool!
        var relationalCompletion38:Bool!
        let cqueue = DispatchQueue(label: "myhjvsdfhjghjhggjV2nfbdsbxkhQueue")
        let cgroup = DispatchGroup()
        var newarray = [14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36]
        //print("songsforinstr \(song.songsForinstrumental.isEmpty), \(song.songsForinstrumental)")
        if song.songsForinstrumental.isEmpty == false {
            newarray.append(37)
        }
        //print("artist refs \(songartistref)")
        //print("producer refs \(songproducerref)")
        for i in newarray {
            //print(i)
            cgroup.enter()
            cqueue.async { [weak self] in
                guard let strongSelf = self else {return}
                switch i {
                case 14://
                    relationalCompletion14 = false
//                    print("4c \(songartistref)")
                    strongSelf.updateArtistAlbums(song: song, songartistref: songartistref, completion: { done in
                        if done == false {
                            Utilities.showError2("Artist albums failed to update.", actionText: "OK")
                            relationalCompletion14 = false
                        }
                        else {
                            relationalCompletion14 = true
                            print("c done \(i)")
                            cgroup.leave()
                        }
                    })
                case 15:
                    relationalCompletion15 = false
                    strongSelf.updateProducerAlbums(song: song, songproducerref: songproducerref, completion: { done in
                        if done == false {
                            Utilities.showError2("Producer albums failed to update.", actionText: "OK")
                            relationalCompletion15 = false
                        }
                        else {
                            relationalCompletion15 = true
                            print("c done \(i)")
                            cgroup.leave()
                        }
                    })
                case 16:
                    relationalCompletion16 = false
                    strongSelf.updateWriterAlbums(song: song, songwriterref: songwriterref, completion: { done in
                        if done == false {
                            Utilities.showError2("Writer albums failed to update.", actionText: "OK")
                            relationalCompletion16 = false
                        }
                        else {
                            relationalCompletion16 = true
                            print("c done \(i)")
                            cgroup.leave()
                        }
                    })
                case 17:
                    relationalCompletion17 = false
                    strongSelf.updateMixEngineerAlbums(song: song, songmixengineerref: songmixengref, completion: { done in
                        if done == false {
                            Utilities.showError2("Mix Engineer albums failed to update.", actionText: "OK")
                            relationalCompletion17 = false
                        }
                        else {
                            relationalCompletion17 = true
                            print("c done \(i)")
                            cgroup.leave()
                        }
                    })
                case 18:
                    relationalCompletion18 = false
                    strongSelf.updateMasteringEngineerAlbums(song: song, songmasteringengineerref: songmasterengref, completion: { done in
                        if done == false {
                            Utilities.showError2("Mastering Engineer albums failed to update.", actionText: "OK")
                            relationalCompletion18 = false
                        }
                        else {
                            relationalCompletion18 = true
                            print("c done \(i)")
                            cgroup.leave()
                        }
                    })
                case 19:
                    relationalCompletion19 = false
                    strongSelf.updateRecordingEngineerAlbums(song: song, songrecordingengineerref: songrecengref, completion: { done in
                        if done == false {
                            Utilities.showError2("Recording Engineer albums failed to update.", actionText: "OK")
                            relationalCompletion19 = false
                        }
                        else {
                            relationalCompletion19 = true
                            print("c done \(i)")
                            cgroup.leave()
                        }
                    })
                case 20:
                    relationalCompletion20 = false
                    strongSelf.updateAlbumTracks(song: song, tracknum: tracknum, completion: { done in
                        
                        if done == false {
                            Utilities.showError2("Album songs failed to update.", actionText: "OK")
                            relationalCompletion20 = false
                        }
                        else {
                            
                            relationalCompletion20 = true
                            print("c done \(i)")
                            cgroup.leave()
                        }
                    })
                case 21:
                    relationalCompletion21 = false
                    strongSelf.updateAlbumVideos(song: song, songUploadVideos: songUploadVideos, completion: { done in
                        
                        if done == false {
                            Utilities.showError2("Artist videos failed to update.", actionText: "OK")
                            relationalCompletion21 = false
                        } else {
                            
                            relationalCompletion21 = true
                            print("c done \(i)")
                            cgroup.leave()
                        }
                    })
                case 22:
                    relationalCompletion22 = false
                    strongSelf.updateAlbumArtists(song: song, completion: { done in
                        if done == false {
                            Utilities.showError2("Album Artist failed to update.", actionText: "OK")
                            relationalCompletion22 = false
                        }
                        else {
                            relationalCompletion22 = true
                            print("c done \(i)")
                            cgroup.leave()
                        }
                    })
                case 23:
                    relationalCompletion23 = false
                    strongSelf.updateAlbumProducers(song: song, completion: { done in
                        if done == false {
                            Utilities.showError2("Album Artist failed to update.", actionText: "OK")
                            relationalCompletion23 = false
                        }
                        else {
                            relationalCompletion23 = true
                            print("c done \(i)")
                            cgroup.leave()
                        }
                    })
                case 24:
                    relationalCompletion24 = false
                    strongSelf.updateAlbumWriters(song: song, completion: { done in
                        if done == false {
                            Utilities.showError2("Album writers failed to update.", actionText: "OK")
                            relationalCompletion24 = false
                        }
                        else {
                            relationalCompletion24 = true
                            print("c done \(i)")
                            cgroup.leave()
                        }
                    })
                case 25:
                    relationalCompletion25 = false
                    strongSelf.updateAlbumMixEngineers(song: song, completion: { done in
                        if done == false {
                            Utilities.showError2("Album mix engineers failed to update.", actionText: "OK")
                            relationalCompletion25 = false
                        }
                        else {
                            relationalCompletion25 = true
                            print("c done \(i)")
                            cgroup.leave()
                        }
                    })
                case 26:
                    relationalCompletion26 = false
                    strongSelf.updateAlbumMasteringEngineers(song: song, completion: { done in
                        if done == false {
                            Utilities.showError2("Album mastering engineers failed to update.", actionText: "OK")
                            relationalCompletion26 = false
                        }
                        else {
                            relationalCompletion26 = true
                            print("c done \(i)")
                            cgroup.leave()
                        }
                    })
                case 27:
                    relationalCompletion27 = false
                    strongSelf.updateAlbumRecordingEngineers(song: song, completion: { done in
                        if done == false {
                            Utilities.showError2("Album recording engineers failed to update.", actionText: "OK")
                            relationalCompletion27 = false
                        }
                        else {
                            relationalCompletion27 = true
                            print("c done \(i)")
                            cgroup.leave()
                        }
                    })
                case 28:
                    relationalCompletion28 = false
                    strongSelf.updateProducerInstrumentals(song: song, songproducerref: songproducerref, completion: { done in
                        if done == false {
                            Utilities.showError2("Producer instrumentals failed to update.", actionText: "OK")
                            relationalCompletion28 = false
                        }
                        else {
                            relationalCompletion28 = true
                            print("c done \(i)")
                            cgroup.leave()
                        }
                    })
                case 29:
                    relationalCompletion29 = false
                    strongSelf.updateArtistRoles(song: song, songartistref: songartistref, completion: { done in
                        if done == false {
                            Utilities.showError2("Artist roles failed to update.", actionText: "OK")
                            relationalCompletion29 = false
                        }
                        else {
                            relationalCompletion29 = true
                            print("c done \(i)")
                            cgroup.leave()
                        }
                    })
                case 30:
                    relationalCompletion30 = false
                    strongSelf.updateProducerRoles(song: song, songartistref: songproducerref, completion: { done in
                        if done == false {
                            Utilities.showError2("Producer roles failed to update.", actionText: "OK")
                            relationalCompletion30 = false
                        }
                        else {
                            relationalCompletion30 = true
                            print("c done \(i)")
                            cgroup.leave()
                        }
                    })
                case 31:
                    relationalCompletion31 = false
                    strongSelf.updateWriterRoles(song: song, songartistref: songwriterref, completion: { done in
                        if done == false {
                            Utilities.showError2("Writer roles failed to update.", actionText: "OK")
                            relationalCompletion31 = false
                        }
                        else {
                            relationalCompletion31 = true
                            print("c done \(i)")
                            cgroup.leave()
                        }
                    })
                case 32:
                    relationalCompletion32 = false
                    strongSelf.updateMixEngineerRoles(song: song, songmixengineerref: songmixengref, completion: { done in
                        if done == false {
                            Utilities.showError2("Mix Engineer roles failed to update.", actionText: "OK")
                            relationalCompletion32 = false
                        }
                        else {
                            relationalCompletion32 = true
                            print("c done \(i)")
                            cgroup.leave()
                        }
                    })
                case 33:
                    relationalCompletion33 = false
                    strongSelf.updateMasteringEngineerRoles(song: song, songmasteringengineerref: songmasterengref, completion: { done in
                        if done == false {
                            Utilities.showError2("Mastering Engineer roles failed to update.", actionText: "OK")
                            relationalCompletion33 = false
                        }
                        else {
                            relationalCompletion33 = true
                            print("c done \(i)")
                            cgroup.leave()
                        }
                    })
                case 34:
                    relationalCompletion34 = false
                    strongSelf.updateRecordingEngineerRoles(song: song, songrecordingengineerref: songrecengref, completion: { done in
                        if done == false {
                            Utilities.showError2("Recording Engineer roles failed to update.", actionText: "OK")
                            relationalCompletion34 = false
                        }
                        else {
                            relationalCompletion34 = true
                            print("c done \(i)")
                            cgroup.leave()
                        }
                    })
                case 35:
                    relationalCompletion35 = false
                    strongSelf.updateAlbumArtistRoles(song: song, songartistref: songartistref, completion: { done in
                        if done == false {
                            Utilities.showError2("Album Artist roles failed to update.", actionText: "OK")
                            relationalCompletion35 = false
                        }
                        else {
                            relationalCompletion35 = true
                            print("c done \(i)")
                            cgroup.leave()
                        }
                    })
                case 36:
                    relationalCompletion36 = false
                    strongSelf.updateArtistInstrumentals(song: song, songartistref: songartistref, completion: { done in
                        if done == false {
                            Utilities.showError2("Artist instrumentals failed to update.", actionText: "OK")
                            relationalCompletion36 = false
                        }
                        else {
                            relationalCompletion36 = true
                            print("c done \(i)")
                            cgroup.leave()
                        }
                    })
                case 37:
                    relationalCompletion37 = false
                    strongSelf.updateSongInstrumentals(song: song, completion: { done in
                        if done == false {
                            Utilities.showError2("Update Song instrumentals failed to update.", actionText: "OK")
                            relationalCompletion37 = false
                        }
                        else {
                            relationalCompletion37 = true
                            print("c done \(i)")
                            cgroup.leave()
                        }
                    })
                default:
                    print("error")
                }
            }
        }
        cgroup.notify(queue: DispatchQueue.main) { [weak self] in
            guard let strongSelf = self else {return}
            if relationalCompletion1 == false || relationalCompletion2 == false || relationalCompletion3 == false || relationalCompletion4 == false || relationalCompletion5 == false || relationalCompletion6 == false || relationalCompletion7 == false || relationalCompletion8 == false || relationalCompletion9 == false || relationalCompletion10 == false || relationalCompletion11 == false || relationalCompletion12 == false || relationalCompletion13 == false || relationalCompletion14 == false || relationalCompletion15 == false || relationalCompletion16 == false || relationalCompletion17 == false || relationalCompletion18 == false || relationalCompletion19 == false || relationalCompletion20 == false || relationalCompletion21 == false || relationalCompletion22 == false || relationalCompletion23 == false || relationalCompletion24 == false || relationalCompletion25 == false || relationalCompletion26 == false || relationalCompletion27 == false || relationalCompletion28 == false || relationalCompletion29 == false || relationalCompletion30 == false || relationalCompletion31 == false || relationalCompletion32 == false || relationalCompletion33 == false || relationalCompletion34 == false || relationalCompletion35 == false || relationalCompletion36 == false || relationalCompletion37 == false || relationalCompletion38 == false {
                Utilities.showError2("Upload Failed.", actionText: "OK")
                return
            } else {
                relationalCompletion1 = false
                relationalCompletion2 = false
                relationalCompletion3 = false
                relationalCompletion4 = false
                relationalCompletion5 = false
                relationalCompletion6 = false
                relationalCompletion7 = false
                relationalCompletion8 = false
                relationalCompletion9 = false
                relationalCompletion10 = false
                relationalCompletion11 = false
                relationalCompletion12 = false
                relationalCompletion13 = false
                relationalCompletion14 = false
                relationalCompletion15 = false
                relationalCompletion16 = false
                relationalCompletion17 = false
                relationalCompletion18 = false
                relationalCompletion19 = false
                relationalCompletion20 = false
                relationalCompletion21 = false
                relationalCompletion22 = false
                relationalCompletion23 = false
                relationalCompletion24 = false
                relationalCompletion25 = false
                relationalCompletion26 = false
                relationalCompletion27 = false
                relationalCompletion28 = false
                relationalCompletion29 = false
                relationalCompletion30 = false
                relationalCompletion31 = false
                relationalCompletion32 = false
                relationalCompletion33 = false
                relationalCompletion34 = false
                relationalCompletion35 = false
                relationalCompletion36 = false
                relationalCompletion37 = false
                relationalCompletion38 = false
                strongSelf.songsdone+=1
                if strongSelf.songsdone == strongSelf.songcount {
                    print("📗 \(strongSelf.albumName) data saved to database successfully.")
                    Utilities.successBarBanner("\(strongSelf.albumName) upload successful.")
                    DispatchQueue.global(qos: .userInitiated).async {
                        strongSelf.semaphore.signal()
                    }
                    albumUploadSongsArray = []
                    _ = strongSelf.navigationController?.popViewController(animated: true)
                } else {
                    strongSelf.semaphore.signal()
                }
            }
        }
    }
    
    func copySongFromDatabase(songid: String, tracknum: String) {
        let song = AlbumUploadSongData(name: "", trackNumber: "", toneDeafAppId: "", artists: [], producers: [], writers: nil, mixEngineers: nil, masteringEngineers: nil, recordingEngineers: nil, youtubeOfficialVideoURL: "", youTubeAudioVideoURL: "", youtubeAltVideoURLs: [], spotifyURL: "", appleMusicURL: "", soundcloudURL: nil, youtubeMusicURL: nil, amazonMusicURL: nil, deezerURL: nil, tidalURL: nil, spinrillaURL: nil, napsterURL: nil, instrumental: "", songsForinstrumental: [], industryCerified: nil, verificationLevel: nil, isActive: false, explicit: false, isRemix: nil, isOtherVersion: nil)
        switch songid.count {
        case 10:
            DatabaseManager.shared.findSongById(songId: songid, completion: {[weak self] result in
                guard let strongSelf = self else {return}
                switch result {
                case .success(let son):
                    song.name = son.name
                    song.trackNumber = tracknum
                    song.toneDeafAppId = son.toneDeafAppId
                    song.artists = son.songArtist
                    song.producers = son.songProducers
                    song.writers = son.songWriters
                    song.mixEngineers = son.songMixEngineer
                    song.masteringEngineers = son.songMasteringEngineer
                    song.recordingEngineers = son.songRecordingEngineer
                    strongSelf.copySongFromDatabaseP2(song: song)
                    
                case.failure(let err):
                    print("newuperr ",err)
                }
                
            })
        case 12:
            DatabaseManager.shared.findInstrumentalById(instrumentalId: songid, completion: {[weak self] result in
                guard let strongSelf = self else {return}
                switch result {
                case .success(let son):
                    song.name = son.songName!
                    song.trackNumber = tracknum
                    song.instrumental = son.toneDeafAppId
                    if son.artist != nil {
                        song.artists = son.artist!
                    }
                    song.producers = son.producers
                    song.mixEngineers = son.mixEngineer
                    song.masteringEngineers = son.masteringEngineer
                    if son.songs != nil {
                        song.songsForinstrumental = son.songs!
                    }
                    strongSelf.copySongFromDatabaseP2(song: song)
                case.failure(let err):
                    print("newuperr ",err)
                }
                
            })
        default:
            break
        }
    }
    
    func copySongFromDatabaseP2(song: AlbumUploadSongData) {
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
        var songUploadVideos:[String] = []
        if !videos.isEmpty {
            songUploadVideos = videos
        }
        var cat = ""
        if song.instrumental == "" {
            cat = "\(songContentTag)--\(song.name)--\(song.toneDeafAppId)"
        } else {
            cat = "\(instrumentalContentType)--\(song.name)--\(song.instrumental)"
        }
        var songartistrefs:[String] = []
        var songproducerrefs:[String] = []
        var songwriterrefs:[String] = []
        var songmixengineerrefs:[String] = []
        var songmasteringengineerrefs:[String] = []
        var songrecorgingengineerrefs:[String] = []
        var uploadDataArray:[String:Any?] = [:]
        let aqueue = DispatchQueue(label: "myhjalbumsongstringp2shikjftdgxfhQueue")
        let agroup = DispatchGroup()
        let array = [ 7, 8, 9, 10, 11, 12, 13]
        for i in array {
            agroup.enter()
            aqueue.async { [weak self] in
                guard let strongSelf = self else {return}
                switch i {
                case 7:
                    uploadCompletionStatus7 = false
                    strongSelf.getArtistRefs(song: song, completion: {[weak self] artref,done  in
                        
                        guard let strongSelf = self else {return}
                        if done == false {
                            Utilities.showError2("artist reference fetch Failed.", actionText: "OK")
                            uploadCompletionStatus7 = false
                        }
                        else {
                            if let artref = artref {
                                songartistrefs = artref
                            }
                            uploadCompletionStatus7 = true
                            print("\(song.name) artist refs done \(i)")
                        }
                        agroup.leave()
                    })
                case 8:
                    uploadCompletionStatus8 = false
                    strongSelf.getProducerRefs(song: song, completion: {[weak self] proref,done in
                        guard let strongSelf = self else {return}
                        if done == false {
                            Utilities.showError2("producer reference fetch Failed.", actionText: "OK")
                            uploadCompletionStatus8 = false
                        }
                        else {
                            songproducerrefs = proref
                            uploadCompletionStatus8 = true
                            print("\(song.name) producer refs done \(i)")
                        }
                        agroup.leave()
                    })
                case 9:
                    uploadCompletionStatus9 = false
                    strongSelf.getWriterRefs(song: song, completion: {[weak self] wriref,done in
                        guard let strongSelf = self else {return}
                        if done == false {
                            Utilities.showError2("writer reference fetch Failed.", actionText: "OK")
                            uploadCompletionStatus9 = false
                        }
                        else {
                            songwriterrefs = wriref
                            uploadCompletionStatus9 = true
                            print("\(song.name) writer refs done \(i)")
                        }
                        agroup.leave()
                    })
                case 10:
                    uploadCompletionStatus10 = false
                    strongSelf.getMixEngineerRefs(song: song, completion: {[weak self] mixengref,done in
                        guard let strongSelf = self else {return}
                        if done == false {
                            Utilities.showError2("mix engineer reference fetch Failed.", actionText: "OK")
                            uploadCompletionStatus10 = false
                        }
                        else {
                            songmixengineerrefs = mixengref
                            uploadCompletionStatus10 = true
                            print("\(song.name) mix engineer refs done \(i)")
                        }
                        agroup.leave()
                    })
                case 11:
                    uploadCompletionStatus11 = false
                    strongSelf.getMasteringEngineerRefs(song: song, completion: {[weak self] masengref,done in
                        guard let strongSelf = self else {return}
                        if done == false {
                            Utilities.showError2("mastering Engineer reference fetch Failed.", actionText: "OK")
                            uploadCompletionStatus11 = false
                        }
                        else {
                            songmasteringengineerrefs = masengref
                            uploadCompletionStatus11 = true
                            print("\(song.name) mastering engineer refs done \(i)")
                        }
                        agroup.leave()
                    })
                case 12:
                    uploadCompletionStatus12 = false
                    strongSelf.getRecordingEngineerRefs(song: song, completion: {[weak self] recengref,done in
                        guard let strongSelf = self else {return}
                        if done == false {
                            Utilities.showError2("recording engineer reference fetch Failed.", actionText: "OK")
                            uploadCompletionStatus12 = false
                        }
                        else {
                            songrecorgingengineerrefs = recengref
                            uploadCompletionStatus12 = true
                            print("\(song.name) recording engineer refs done \(i)")
                        }
                        agroup.leave()
                    })
                case 13:
                    uploadCompletionStatus13 = false
                    strongSelf.updateSongAlbums(song: song, cat: cat, completion: {[weak self] err in
                        guard let strongSelf = self else {return}
                        if let err = err {
                            Utilities.showError2("song Albums update Failed.", actionText: "OK")
                            uploadCompletionStatus13 = false
                        }
                        else {
                            uploadCompletionStatus13 = true
                            print("\(song.name) song Albums update done \(i)")
                        }
                        agroup.leave()
                    })
                default:
                    print("error")
                }
            }
        }
        
        agroup.notify(queue: DispatchQueue.main) {[weak self] in
            guard let strongSelf = self else {return}
            
            if uploadCompletionStatus4 == false || uploadCompletionStatus5 == false || uploadCompletionStatus6 == false || uploadCompletionStatus7 == false || uploadCompletionStatus8 == false || uploadCompletionStatus9 == false || uploadCompletionStatus10 == false || uploadCompletionStatus11 == false || uploadCompletionStatus12 == false || uploadCompletionStatus13 == false {
                Utilities.showError2("Upload Failed.", actionText: "OK")
                return
            } else {
                
                uploadCompletionStatus4 = false
                uploadCompletionStatus5 = false
                uploadCompletionStatus6 = false
                uploadCompletionStatus7 = false
                uploadCompletionStatus8 = false
                uploadCompletionStatus9 = false
                uploadCompletionStatus10 = false
                uploadCompletionStatus11 = false
                uploadCompletionStatus12 = false
                uploadCompletionStatus13 = false
                strongSelf.updateSongRelationsV2(song: song, songcategorty: cat, tracknum: song.trackNumber, songUploadVideos: [], songartistref: songartistrefs, songproducerref: songproducerrefs, songwriterref: songwriterrefs, songmixengref: songmixengineerrefs, songmasterengref: songmasteringengineerrefs, songrecengref: songrecorgingengineerrefs)
            }
        }
    }
    
    func updateSongAlbums(song: AlbumUploadSongData, cat: String, completion: @escaping ((Error?) -> Void)) {
        if song.instrumental == "" {
            let ref = Database.database().reference().child("Music Content").child("Songs").child(cat)
            var albs:[String] = []
            getSongAlbumsInDB(ref: ref, completion: {[weak self] albums in
                guard let strongSelf = self else {return}
                albs = albums
                if !albs.contains(strongSelf.tDAppId) {
                    albs.append(strongSelf.tDAppId)
                }
                
                ref.child("REQUIRED").child("Albums").setValue(albs.sorted(), withCompletionBlock: { error, reference in
                    if let error = error {
                        completion(error)
                        return
                    }
                    else {
                        completion(nil)
                        return
                    }
                })
            })
        } else {
            let ref = Database.database().reference().child("Music Content").child("Instrumentals").child(cat)
            var albs:[String] = []
            getInstrumentalAlbumsInDB(ref: ref, completion: {[weak self] albums in
                guard let strongSelf = self else {return}
                albs = albums
                if !albs.contains(strongSelf.tDAppId) {
                    albs.append(strongSelf.tDAppId)
                }
                
                ref.child("Albums").setValue(albs.sorted(), withCompletionBlock: { error, reference in
                    if let error = error {
                        completion(error)
                        return
                    }
                    else {
                        completion(nil)
                        return
                    }
                })
            })
        }
    }
    
    func getSongAlbumsInDB(ref: DatabaseReference, completion: @escaping (([String]) -> Void)) {
        ref.child("REQUIRED").child("Albums").observeSingleEvent(of: .value, with: { snapshot in
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
    
    func getInstrumentalAlbumsInDB(ref: DatabaseReference, completion: @escaping (([String]) -> Void)) {
        ref.child("Albums").observeSingleEvent(of: .value, with: { snapshot in
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
    
    func getArtistData(song:AlbumUploadSongData, completion: @escaping (Array<String>) -> Void) {
        var artistNameData:Array<String> = []
        var val = 0
        
        if song.artists.isEmpty {
            completion([])
        } else {
            for artist in song.artists {
                let word = artist.split(separator: "Æ")
                let id = word[0]
                DatabaseManager.shared.fetchPersonData(person: String(id), completion: { result in
                    switch result {
                    case .success(let selectedArtist):
                        artistNameData.append(selectedArtist.name!)
                        val+=1
                        if val == song.artists.count {
                            
                            completion(artistNameData)
                        }
                    case .failure(let err):
                        print("youyouerr", err)
                    }
                })
                
            }
        }
        
    }
    
    func updateSongVideos(song: AlbumUploadSongData, songcategorty: String, songUploadVideos:[String], completion: @escaping ((Bool) -> Void)) {
            
        
            var RequiredVidsInfoMap = [String : Any]()
            RequiredVidsInfoMap = [
                "Videos" : songUploadVideos]
            
        if song.instrumental != "" {
            Database.database().reference().child("Music Content").child("Instrumentals").child(songcategorty).updateChildValues(RequiredVidsInfoMap) {(error, songRef) in
                if let error = error {
                    Utilities.showError2("Failed to update videos in song required dictionary.", actionText: "OK")
                    print("📕 Failed to update videos in song reqquired dictionary: \(error)")
                    completion(false)
                    return
                } else {
                    
                    completion(true)
                }
            }
        } else {
            Database.database().reference().child("Music Content").child("Songs").child(songcategorty).child("REQUIRED").updateChildValues(RequiredVidsInfoMap) {(error, songRef) in
                if let error = error {
                    Utilities.showError2("Failed to update videos in song required dictionary.", actionText: "OK")
                    print("📕 Failed to update videos in song reqquired dictionary: \(error)")
                    completion(false)
                    return
                } else {
                    
                    completion(true)
                }
            }
        }
    }
    
    func updateSongInstrumentals(song: AlbumUploadSongData, completion: @escaping ((Bool) -> Void)) {
        var count = 0
        var instr = ""
        if song.instrumental != "" {
            getSongRefs(song: song, completion: { [weak self] refs,done in
                guard let strongSelf = self else {return}
                for ref in refs {
                    strongSelf.getSongInstrumentalsInDB(cat: ref, completion: { songs in
                        var mysongsArray:[String] = []
                        mysongsArray = songs
                        if song.instrumental != "" {
                            instr = "\(song.instrumental)"
                        }
                        mysongsArray.append(instr)
                        Database.database().reference().child("Music Content").child("Songs").child(ref).child("REQUIRED").child("Instrumentals").setValue(mysongsArray)
                        count+=1
                        if count == song.songsForinstrumental.count {
                            completion(true)
                        }
                    })
                }
            })
        } else {
            completion(true)
        }
    }
    
    func updateSongVideosWithInstrumentals(song: AlbumUploadSongData, completion: @escaping ((Bool) -> Void)) {
        var count = 0
        var ocount = 0
        var instr = ""
        if song.instrumental != "" {
            getSongRefs(song: song, completion: { [weak self] refs,done in
                guard let strongSelf = self else {return}
                for ref in refs {
                    strongSelf.getSongVideosInDB(cat: ref, completion: { videos in
                        strongSelf.getVideoRefs(vid: videos, completion: { videorefs,done in
                            for vid in videorefs {
                                strongSelf.getVideoInstrumentalsInDB(cat: vid, completion: { videoinstr in
                                    var myvideosArray:Array<String> = []
                                    myvideosArray = videoinstr
                                    if song.instrumental != "" {
                                        instr = "\(song.instrumental)"
                                    }
                                    if !myvideosArray.contains(instr) {
                                        myvideosArray.append(instr)
                                    }
                                    if myvideosArray != [] {
                                        Database.database().reference().child("Music Content").child("Videos").child(vid).child("Instrumentals").setValue(myvideosArray)
                                    }
                                    count+=1
                                    if count == videorefs.count {
                                        ocount+=1
                                        if ocount == refs.count {
                                            completion(true)
                                        }
                                    }
                                })
                            }
                        })
                    })
                }
            })
        } else {
            completion(true)
        }
    }
    
    func updateArtistVideos(song: AlbumUploadSongData, songUploadVideos:[String], songartistref: [String], completion: @escaping ((Bool) -> Void)) {
        var count = 0
        //print("5a \(songartistref)")
        if songartistref.isEmpty {
            completion(true)
        }
        else {
            for artist in songartistref {
                if songUploadVideos != [] && songUploadVideos != [] {
                    getPersonVideosInDB(cat: artist, completion: {[weak self] videos in
                        guard let strongSelf = self else {return}
                        var myvideosArray:Array<String> = []
                        myvideosArray = videos
                        for vid in songUploadVideos {
                            if !myvideosArray.contains(vid) {
                                myvideosArray.append(vid)
                            }
                        }
                        if myvideosArray != [] {
                            Database.database().reference().child("Registered Persons").child(artist).child("Videos").setValue(myvideosArray)
                        }
                        count+=1
                        if count == songartistref.count {
                            completion(true)
                        }
                    })
                } else {
                    completion(true)
                }
            }
        }
    }
    
    func updateArtistSongs(song: AlbumUploadSongData, songartistref: [String], completion: @escaping ((Bool) -> Void)) {
        var count = 0
        //print("5b \(songartistref)")
        if song.toneDeafAppId != "" {
            if songartistref.isEmpty {
                completion(true)
            }
            else {
                for artist in songartistref {
                    getPersonSongsInDB(cat: artist, completion: {songs in
                        var mysongsArray:[String] = []
                        mysongsArray = songs
                        if !mysongsArray.contains("\(song.toneDeafAppId)"){
                            mysongsArray.append("\(song.toneDeafAppId)")
                        }
                        Database.database().reference().child("Registered Persons").child(artist).child("Songs").setValue(mysongsArray)
                        count+=1
                        if count == songartistref.count {
                            completion(true)
                        }
                    })
                }
            }
        } else {
            completion(true)
        }
    }
    
    func updateArtistInstrumentals(song: AlbumUploadSongData, songartistref: [String], completion: @escaping ((Bool) -> Void)) {
        var count = 0
        var instr = ""
        if song.instrumental != "" {
            if songartistref.isEmpty {
                completion(true)
            }
            else {
                if songartistref.isEmpty {
                    completion(true)
                } else {
                    for artist in songartistref {
                            getArtistInstrumentalsInDB(cat: artist, completion: {songs in
                                var mysongsArray:[String] = []
                                mysongsArray = songs
                                if song.instrumental != "" {
                                    instr = "\(song.instrumental)"
                                }
                                mysongsArray.append(instr)
                                Database.database().reference().child("Registered Persons").child(artist).child("Instrumentals").setValue(mysongsArray)
                                count+=1
                                if count == songartistref.count {
                                    completion(true)
                                }
                            })
                        }
                    }
                }
        } else {
            completion(true)
        }
    }
    
    func updateArtistAlbums(song: AlbumUploadSongData, songartistref: [String], completion: @escaping ((Bool) -> Void)) {
        var count = 0
        if songartistref.isEmpty {
            completion(true)
        }
        else {
            for artist in songartistref {
                getPersonAlbumsInDB(cat: artist, completion: {[weak self] songs in
                    guard let strongSelf = self else {return}
                    var mysongsArray:[String] = []
                    mysongsArray = songs
                    if !mysongsArray.contains("\(strongSelf.tDAppId)") {
                        mysongsArray.append("\(strongSelf.tDAppId)")
                    }
                    Database.database().reference().child("Registered Persons").child(artist).child("Albums").setValue(mysongsArray)
                    count+=1
                    if count == songartistref.count {
                        
                        completion(true)
                    }
                })
            }
        }
    }
    
    func updateArtistRoles(song: AlbumUploadSongData, songartistref: [String], completion: @escaping ((Bool) -> Void)) {
        var count = 0
        if song.toneDeafAppId != "" {
            if songartistref.isEmpty {
                completion(true)
            }
            else {
                for artist in songartistref {
                    getPersonRolesInDB(cat: artist, completion: {[weak self] personroles in
                        guard let strongSelf = self else {return}
                        if let proles = personroles {
                            var mysongsArray:[String] = []
                            if let role = proles["Artist"] as? [String] {
                                mysongsArray = role
                                if !mysongsArray.contains("\(strongSelf.tDAppId)"){
                                    mysongsArray.append("\(strongSelf.tDAppId)")
                                }
                                if !mysongsArray.contains("\(song.toneDeafAppId)"){
                                    mysongsArray.append("\(song.toneDeafAppId)")
                                }
                                
                                if song.instrumental != "" {
                                    if !mysongsArray.contains("\(song.instrumental)"){
                                        mysongsArray.append("\(song.instrumental)")
                                    }
                                }
                                Database.database().reference().child("Registered Persons").child(artist).child("Roles").child("Artist").setValue(mysongsArray)
                                count+=1
                                if count == songartistref.count {
                                    completion(true)
                                }
                            } else {
                                var mysongsArray:[String] = []
                                mysongsArray = ["\(strongSelf.tDAppId)","\(song.toneDeafAppId)"]
                                if song.instrumental != "" {
                                    mysongsArray.append(song.instrumental)
                                }
                                Database.database().reference().child("Registered Persons").child(artist).child("Roles").child("Artist").setValue(mysongsArray)
                                count+=1
                                if count == songartistref.count {
                                    completion(true)
                                }
                            }
                        }
                        else {
                            var mysongsArray:[String] = []
                            mysongsArray = ["\(strongSelf.tDAppId)","\(song.toneDeafAppId)"]
                            if song.instrumental != "" {
                                mysongsArray.append(song.instrumental)
                            }
                            Database.database().reference().child("Registered Persons").child(artist).child("Roles").child("Artist").setValue(mysongsArray)
                            count+=1
                            if count == songartistref.count {
                                completion(true)
                            }
                        }
                    })
                }
            }
        } else {
            completion(true)
        }
    }
    
    func updateProducerVideos(song: AlbumUploadSongData, songUploadVideos:[String], songproducerref: [String], completion: @escaping ((Bool) -> Void)) {
        var count = 0
        for producer in songproducerref {
            if songUploadVideos != [] {
                getPersonVideosInDB(cat: producer, completion: {[weak self] videos in
                guard let strongSelf = self else {return}
                    
                    var myvideosArray:Array<String> = []
                    myvideosArray = videos
                    for vid in songUploadVideos {
                        if !myvideosArray.contains(vid) {
                            myvideosArray.append(vid)
                        }
                    }
                    if myvideosArray != [] {
                        Database.database().reference().child("Registered Persons").child(producer).child("Videos").setValue(myvideosArray)
                    }
                    count+=1
                    if count == songproducerref.count {
                        
                        completion(true)
                    }
                })
            } else {
                completion(true)
            }
        }
    }
    
    func updateProducerSongs(song: AlbumUploadSongData, songproducerref: [String],  completion: @escaping ((Bool) -> Void)) {
        var count = 0
        if song.toneDeafAppId != "" {
            for producer in songproducerref {
                getPersonSongsInDB(cat: producer, completion: {[weak self] songs in
                    guard let strongSelf = self else {return}
                    
                    var mysongsArray:[String] = []
                    mysongsArray = songs
                    if !mysongsArray.contains("\(song.toneDeafAppId)"){
                        mysongsArray.append("\(song.toneDeafAppId)")
                    }
                    Database.database().reference().child("Registered Persons").child(producer).child("Songs").setValue(mysongsArray)
                    count+=1
                    if count == songproducerref.count {
                        
                        completion(true)
                    }
                })
            }
        } else {
            completion(true)
        }
    }
    
    func updateProducerInstrumentals(song: AlbumUploadSongData, songproducerref: [String],  completion: @escaping ((Bool) -> Void)) {
        var count = 0
        var instr = ""
        if song.instrumental != "" {
            for producer in songproducerref {
                getProducerInstrumentalsInDB(cat: producer, completion: {[weak self] songs in
                    guard let strongSelf = self else {return}
                    if song.instrumental != "" {
                        instr = "\(song.instrumental)"
                    }
                    var mysongsArray:[String] = []
                    mysongsArray = songs
                    mysongsArray.append(instr)
                    Database.database().reference().child("Registered Persons").child(producer).child("Instrumentals").setValue(mysongsArray)
                    count+=1
                    if count == songproducerref.count {
                        
                        completion(true)
                    }
                })
            }
        } else {
            completion(true)
        }
    }
    
    func updateProducerAlbums(song: AlbumUploadSongData, songproducerref: [String],  completion: @escaping ((Bool) -> Void)) {
        var count = 0
        for producer in songproducerref {
            getPersonAlbumsInDB(cat: producer, completion: {[weak self] songs in
            guard let strongSelf = self else {return}
                var mysongsArray:[String] = []
                mysongsArray = songs
                if !mysongsArray.contains("\(strongSelf.tDAppId)") {
                    mysongsArray.append("\(strongSelf.tDAppId)")
                }
                Database.database().reference().child("Registered Persons").child(producer).child("Albums").setValue(mysongsArray)
                count+=1
                if count == songproducerref.count {
                    completion(true)
                }
            })
        }
    }
    
    func updateProducerRoles(song: AlbumUploadSongData, songartistref: [String], completion: @escaping ((Bool) -> Void)) {
        var count = 0
        if song.toneDeafAppId != "" {
            for artist in songartistref {
                    getPersonRolesInDB(cat: artist, completion: {[weak self] personroles in
                        guard let strongSelf = self else {return}
                        if let proles = personroles {
                            var mysongsArray:[String] = []
                            if let role = proles["Producer"] as? [String] {
                                mysongsArray = role
                                
                                if !mysongsArray.contains("\(strongSelf.tDAppId)"){
                                    mysongsArray.append("\(strongSelf.tDAppId)")
                                }
                                if !mysongsArray.contains("\(song.toneDeafAppId)"){
                                    mysongsArray.append("\(song.toneDeafAppId)")
                                }
                                
                                if song.instrumental != "" {
                                    if !mysongsArray.contains("\(song.instrumental)"){
                                        mysongsArray.append("\(song.instrumental)")
                                    }
                                }
                                Database.database().reference().child("Registered Persons").child(artist).child("Roles").child("Producer").setValue(mysongsArray)
                                count+=1
                                if count == songartistref.count {
                                    completion(true)
                                }
                            } else {
                                var mysongsArray:[String] = []
                                mysongsArray = ["\(strongSelf.tDAppId)","\(song.toneDeafAppId)"]
                                if song.instrumental != "" {
                                    mysongsArray.append(song.instrumental)
                                }
                                Database.database().reference().child("Registered Persons").child(artist).child("Roles").child("Producer").setValue(mysongsArray)
                                count+=1
                                if count == songartistref.count {
                                    completion(true)
                                }
                            }
                        }
                        else {
                            var mysongsArray:[String] = []
                            mysongsArray = ["\(strongSelf.tDAppId)","\(song.toneDeafAppId)"]
                            if song.instrumental != "" {
                                mysongsArray.append(song.instrumental)
                            }
                            Database.database().reference().child("Registered Persons").child(artist).child("Roles").child("Producer").setValue(mysongsArray)
                            count+=1
                            if count == songartistref.count {
                                completion(true)
                            }
                        }
                    })
            }
        } else {
            completion(true)
        }
    }
    
    func updateWriterSongs(song: AlbumUploadSongData, songwriterref: [String],  completion: @escaping ((Bool) -> Void)) {
        var count = 0
        if song.toneDeafAppId != "" {
            if songwriterref.isEmpty {
                completion(true)
            }
            else {
                for producer in songwriterref {
                    getPersonSongsInDB(cat: producer, completion: {[weak self] songs in
                        guard let strongSelf = self else {return}
                        var mysongsArray:[String] = []
                        mysongsArray = songs
                        if !mysongsArray.contains("\(song.toneDeafAppId)"){
                            mysongsArray.append("\(song.toneDeafAppId)")
                        }
                        Database.database().reference().child("Registered Persons").child(producer).child("Songs").setValue(mysongsArray)
                        count+=1
                        if count == songwriterref.count {
                            
                            completion(true)
                        }
                    })
                }
            }
        } else {
            completion(true)
        }
    }
    
    func updateWriterVideos(song: AlbumUploadSongData, songUploadVideos:[String], songproducerref: [String], completion: @escaping ((Bool) -> Void)) {
        var count = 0
        if !songproducerref.isEmpty {
        for producer in songproducerref {
            if songUploadVideos != [] {
                getPersonVideosInDB(cat: producer, completion: {[weak self] videos in
                guard let strongSelf = self else {return}
                    
                    var myvideosArray:Array<String> = []
                    myvideosArray = videos
                    for vid in songUploadVideos {
                        if !myvideosArray.contains(vid) {
                            myvideosArray.append(vid)
                        }
                    }
                    if myvideosArray != [] {
                        Database.database().reference().child("Registered Persons").child(producer).child("Videos").setValue(myvideosArray)
                    }
                    count+=1
                    if count == songproducerref.count {
                        
                        completion(true)
                    }
                })
            } else {
                completion(true)
            }
        }
    } else {
        completion(true)
    }
    }
    
    func updateWriterAlbums(song: AlbumUploadSongData, songwriterref: [String],  completion: @escaping ((Bool) -> Void)) {
        var count = 0
        if !songwriterref.isEmpty {
        for person in songwriterref {
            getPersonAlbumsInDB(cat: person, completion: {[weak self] songs in
            guard let strongSelf = self else {return}
                var mysongsArray:[String] = []
                mysongsArray = songs
                if !mysongsArray.contains("\(strongSelf.tDAppId)") {
                    mysongsArray.append("\(strongSelf.tDAppId)")
                }
                Database.database().reference().child("Registered Persons").child(person).child("Albums").setValue(mysongsArray)
                count+=1
                if count == songwriterref.count {
                    completion(true)
                }
            })
        }
    } else {
        completion(true)
    }
    }
    
    func updateWriterRoles(song: AlbumUploadSongData, songartistref: [String], completion: @escaping ((Bool) -> Void)) {
        var count = 0
        if song.toneDeafAppId != "" {
            if !songartistref.isEmpty {
            for artist in songartistref {
                    getPersonRolesInDB(cat: artist, completion: {[weak self] personroles in
                        guard let strongSelf = self else {return}
                        if let proles = personroles {
                            var mysongsArray:[String] = []
                            if let role = proles["Writer"] as? [String] {
                                mysongsArray = role
                                
                                if !mysongsArray.contains("\(strongSelf.tDAppId)"){
                                    mysongsArray.append("\(strongSelf.tDAppId)")
                                }
                                if !mysongsArray.contains("\(song.toneDeafAppId)"){
                                    mysongsArray.append("\(song.toneDeafAppId)")
                                }
                                
                                if !mysongsArray.contains("\(song.toneDeafAppId)"){
                                    mysongsArray.append("\(song.toneDeafAppId)")
                                }
                                Database.database().reference().child("Registered Persons").child(artist).child("Roles").child("Writer").setValue(mysongsArray)
                                count+=1
                                if count == songartistref.count {
                                    completion(true)
                                }
                            } else {
                                var mysongsArray:[String] = []
                                mysongsArray = ["\(strongSelf.tDAppId)","\(song.toneDeafAppId)"]
                                Database.database().reference().child("Registered Persons").child(artist).child("Roles").child("Writer").setValue(mysongsArray)
                                count+=1
                                if count == songartistref.count {
                                    completion(true)
                                }
                            }
                        }
                        else {
                            var mysongsArray:[String] = []
                            mysongsArray = ["\(strongSelf.tDAppId)","\(song.toneDeafAppId)"]
                            Database.database().reference().child("Registered Persons").child(artist).child("Roles").child("Writer").setValue(mysongsArray)
                            count+=1
                            if count == songartistref.count {
                                completion(true)
                            }
                        }
                    })
            }
        } else {
            completion(true)
        }
        } else {
            completion(true)
        }
    }
    
    func updateMixEngineerSongs(song: AlbumUploadSongData, songmixengineerref: [String],  completion: @escaping ((Bool) -> Void)) {
        var count = 0
        if song.toneDeafAppId != "" {
            if songmixengineerref.isEmpty {
                completion(true)
            }
            else {
                for producer in songmixengineerref {
                    getPersonSongsInDB(cat: producer, completion: {[weak self] songs in
                        guard let strongSelf = self else {return}
                        var mysongsArray:[String] = []
                        mysongsArray = songs
                        if !mysongsArray.contains("\(song.toneDeafAppId)"){
                            mysongsArray.append("\(song.toneDeafAppId)")
                        }
                        Database.database().reference().child("Registered Persons").child(producer).child("Songs").setValue(mysongsArray)
                        count+=1
                        if count == songmixengineerref.count {
                            
                            completion(true)
                        }
                    })
                }
            }
        } else {
            completion(true)
        }
    }
    
    //MARK: - ToDo
    func updateMixEngineerVideos(song: AlbumUploadSongData, songUploadVideos:[String], songproducerref: [String], completion: @escaping ((Bool) -> Void)) {
        var count = 0
        if !songproducerref.isEmpty {
        for producer in songproducerref {
            if songUploadVideos != [] {
                getPersonVideosInDB(cat: producer, completion: {[weak self] videos in
                guard let strongSelf = self else {return}
                    
                    var myvideosArray:Array<String> = []
                    myvideosArray = videos
                    for vid in songUploadVideos {
                        if !myvideosArray.contains(vid) {
                            myvideosArray.append(vid)
                        }
                    }
                    if myvideosArray != [] {
                        Database.database().reference().child("Registered Persons").child(producer).child("Videos").setValue(myvideosArray)
                    }
                    count+=1
                    if count == songproducerref.count {
                        
                        completion(true)
                    }
                })
            } else {
                completion(true)
            }
        }
    } else {
        completion(true)
    }
    }
    
    func updateMixEngineerAlbums(song: AlbumUploadSongData, songmixengineerref: [String],  completion: @escaping ((Bool) -> Void)) {
        var count = 0
        if !songmixengineerref.isEmpty {
        for person in songmixengineerref {
            getPersonAlbumsInDB(cat: person, completion: {[weak self] songs in
            guard let strongSelf = self else {return}
                var mysongsArray:[String] = []
                mysongsArray = songs
                if !mysongsArray.contains("\(strongSelf.tDAppId)") {
                    mysongsArray.append("\(strongSelf.tDAppId)")
                }
                Database.database().reference().child("Registered Persons").child(person).child("Albums").setValue(mysongsArray)
                count+=1
                if count == songmixengineerref.count {
                    completion(true)
                }
            })
        }
    } else {
        completion(true)
    }
    }
    
    func updateMixEngineerRoles(song: AlbumUploadSongData, songmixengineerref: [String], completion: @escaping ((Bool) -> Void)) {
        var count = 0
        if song.toneDeafAppId != "" {
            if !songmixengineerref.isEmpty {
            for artist in songmixengineerref {
                    getPersonRolesInDB(cat: artist, completion: {[weak self] personroles in
                        guard let strongSelf = self else {return}
                        if let proles = personroles {
                            var mysongsArray:[String] = []
                            if let role = proles["Engineer"] as? NSDictionary {
                                if let erole = role["Mix Engineer"] as? [String] {
                                mysongsArray = erole
                                    
                                    if !mysongsArray.contains("\(strongSelf.tDAppId)"){
                                        mysongsArray.append("\(strongSelf.tDAppId)")
                                    }
                                    if !mysongsArray.contains("\(song.toneDeafAppId)"){
                                        mysongsArray.append("\(song.toneDeafAppId)")
                                    }
                                    
                                    if song.instrumental != "" {
                                        if !mysongsArray.contains("\(song.instrumental)"){
                                            mysongsArray.append("\(song.instrumental)")
                                        }
                                    }
                                    Database.database().reference().child("Registered Persons").child(artist).child("Roles").child("Engineer").child("Mix Engineer").setValue(mysongsArray)
                                    count+=1
                                    if count == songmixengineerref.count {
                                        completion(true)
                                    }
                                }
                                else {
                                    var mysongsArray:[String] = []
                                    mysongsArray = ["\(strongSelf.tDAppId)","\(song.toneDeafAppId)"]
                                    if song.instrumental != "" {
                                        mysongsArray.append(song.instrumental)
                                    }
                                    Database.database().reference().child("Registered Persons").child(artist).child("Roles").child("Engineer").child("Mix Engineer").setValue(mysongsArray)
                                    count+=1
                                    if count == songmixengineerref.count {
                                        completion(true)
                                    }
                                }
                            } else {
                                var mysongsArray:[String] = []
                                mysongsArray = ["\(strongSelf.tDAppId)","\(song.toneDeafAppId)"]
                                if song.instrumental != "" {
                                    mysongsArray.append(song.instrumental)
                                }
                                Database.database().reference().child("Registered Persons").child(artist).child("Roles").child("Engineer").child("Mix Engineer").setValue(mysongsArray)
                                count+=1
                                if count == songmixengineerref.count {
                                    completion(true)
                                }
                            }
                        }
                        else {
                            var mysongsArray:[String] = []
                            mysongsArray = ["\(strongSelf.tDAppId)","\(song.toneDeafAppId)"]
                            if song.instrumental != "" {
                                mysongsArray.append(song.instrumental)
                            }
                            Database.database().reference().child("Registered Persons").child(artist).child("Roles").child("Engineer").child("Mix Engineer").setValue(mysongsArray)
                            count+=1
                            if count == songmixengineerref.count {
                                completion(true)
                            }
                        }
                    })
            }
        } else {
            completion(true)
        }
        } else {
            completion(true)
        }
    }
    
    func updateMasteringEngineerSongs(song: AlbumUploadSongData, songmasteringengineerref: [String],  completion: @escaping ((Bool) -> Void)) {
        var count = 0
        if song.toneDeafAppId != "" {
            if songmasteringengineerref.isEmpty {
                completion(true)
            }
            else {
                for producer in songmasteringengineerref {
                    getPersonSongsInDB(cat: producer, completion: {[weak self] songs in
                        guard let strongSelf = self else {return}
                        var mysongsArray:[String] = []
                        mysongsArray = songs
                        if !mysongsArray.contains("\(song.toneDeafAppId)"){
                            mysongsArray.append("\(song.toneDeafAppId)")
                        }
                        Database.database().reference().child("Registered Persons").child(producer).child("Songs").setValue(mysongsArray)
                        count+=1
                        if count == songmasteringengineerref.count {
                            
                            completion(true)
                        }
                    })
                }
            }
        } else {
            completion(true)
        }
    }
    
    //MARK: - ToDo
    func updateMasteringEngineerVideos(song: AlbumUploadSongData, songUploadVideos:[String], songproducerref: [String], completion: @escaping ((Bool) -> Void)) {
        var count = 0
        if !songproducerref.isEmpty {
        for producer in songproducerref {
            if songUploadVideos != [] {
                getPersonVideosInDB(cat: producer, completion: {[weak self] videos in
                guard let strongSelf = self else {return}
                    
                    var myvideosArray:Array<String> = []
                    myvideosArray = videos
                    for vid in songUploadVideos {
                        if !myvideosArray.contains(vid) {
                            myvideosArray.append(vid)
                        }
                    }
                    if myvideosArray != [] {
                        Database.database().reference().child("Registered Persons").child(producer).child("Videos").setValue(myvideosArray)
                    }
                    count+=1
                    if count == songproducerref.count {
                        
                        completion(true)
                    }
                })
            } else {
                completion(true)
            }
        }
    } else {
        completion(true)
    }
    }
    
    func updateMasteringEngineerAlbums(song: AlbumUploadSongData, songmasteringengineerref: [String],  completion: @escaping ((Bool) -> Void)) {
        var count = 0
        if !songmasteringengineerref.isEmpty {
        for person in songmasteringengineerref {
            getPersonAlbumsInDB(cat: person, completion: {[weak self] songs in
            guard let strongSelf = self else {return}
                var mysongsArray:[String] = []
                mysongsArray = songs
                if !mysongsArray.contains("\(strongSelf.tDAppId)") {
                    mysongsArray.append("\(strongSelf.tDAppId)")
                }
                Database.database().reference().child("Registered Persons").child(person).child("Albums").setValue(mysongsArray)
                count+=1
                if count == songmasteringengineerref.count {
                    completion(true)
                }
            })
        }
    } else {
        completion(true)
    }
    }
    
    func updateMasteringEngineerRoles(song: AlbumUploadSongData, songmasteringengineerref: [String], completion: @escaping ((Bool) -> Void)) {
        var count = 0
        if song.toneDeafAppId != "" {
            if !songmasteringengineerref.isEmpty {
            for artist in songmasteringengineerref {
                    getPersonRolesInDB(cat: artist, completion: {[weak self] personroles in
                        guard let strongSelf = self else {return}
                        if let proles = personroles {
                            var mysongsArray:[String] = []
                            if let role = proles["Engineer"] as? NSDictionary {
                                if let erole = role["Mastering Engineer"] as? [String] {
                                mysongsArray = erole
                                    if !mysongsArray.contains("\(strongSelf.tDAppId)"){
                                        mysongsArray.append("\(strongSelf.tDAppId)")
                                    }
                                    if !mysongsArray.contains("\(song.toneDeafAppId)"){
                                        mysongsArray.append("\(song.toneDeafAppId)")
                                    }
                                    
                                    if song.instrumental != "" {
                                        if !mysongsArray.contains("\(song.instrumental)"){
                                            mysongsArray.append("\(song.instrumental)")
                                        }
                                    }
                                    Database.database().reference().child("Registered Persons").child(artist).child("Roles").child("Engineer").child("Mastering Engineer").setValue(mysongsArray)
                                    count+=1
                                    if count == songmasteringengineerref.count {
                                        completion(true)
                                    }
                                }
                                else {
                                    var mysongsArray:[String] = []
                                    mysongsArray = ["\(strongSelf.tDAppId)","\(song.toneDeafAppId)"]
                                    if song.instrumental != "" {
                                        mysongsArray.append(song.instrumental)
                                    }
                                    Database.database().reference().child("Registered Persons").child(artist).child("Roles").child("Engineer").child("Mastering Engineer").setValue(mysongsArray)
                                    count+=1
                                    if count == songmasteringengineerref.count {
                                        completion(true)
                                    }
                                }
                            } else {
                                var mysongsArray:[String] = []
                                mysongsArray = ["\(strongSelf.tDAppId)","\(song.toneDeafAppId)"]
                                if song.instrumental != "" {
                                    mysongsArray.append(song.instrumental)
                                }
                                Database.database().reference().child("Registered Persons").child(artist).child("Roles").child("Engineer").child("Mastering Engineer").setValue(mysongsArray)
                                count+=1
                                if count == songmasteringengineerref.count {
                                    completion(true)
                                }
                            }
                        }
                        else {
                            var mysongsArray:[String] = []
                            mysongsArray = ["\(strongSelf.tDAppId)","\(song.toneDeafAppId)"]
                            if song.instrumental != "" {
                                mysongsArray.append(song.instrumental)
                            }
                            Database.database().reference().child("Registered Persons").child(artist).child("Roles").child("Engineer").child("Mastering Engineer").setValue(mysongsArray)
                            count+=1
                            if count == songmasteringengineerref.count {
                                completion(true)
                            }
                        }
                    })
            }
            
            } else {
                completion(true)
            }
        } else {
            completion(true)
        }
    }
    
    func updateRecordingEngineerSongs(song: AlbumUploadSongData, songrecordingengineerref: [String],  completion: @escaping ((Bool) -> Void)) {
        var count = 0
        if song.toneDeafAppId != "" {
            if songrecordingengineerref.isEmpty {
                completion(true)
            }
            else {
                for producer in songrecordingengineerref {
                    getPersonSongsInDB(cat: producer, completion: {[weak self] songs in
                        guard let strongSelf = self else {return}
                        var mysongsArray:[String] = []
                        mysongsArray = songs
                        if !mysongsArray.contains("\(song.toneDeafAppId)"){
                            mysongsArray.append("\(song.toneDeafAppId)")
                        }
                        Database.database().reference().child("Registered Persons").child(producer).child("Songs").setValue(mysongsArray)
                        count+=1
                        if count == songrecordingengineerref.count {
                            
                            completion(true)
                        }
                    })
                }
            }
        } else {
            completion(true)
        }
    }
    
    //MARK: - ToDo
    func updateRecordingEngineerVideos(song: AlbumUploadSongData, songUploadVideos:[String], songproducerref: [String], completion: @escaping ((Bool) -> Void)) {
        var count = 0
        if !songproducerref.isEmpty {
        for producer in songproducerref {
            if songUploadVideos != [] {
                getPersonVideosInDB(cat: producer, completion: {[weak self] videos in
                guard let strongSelf = self else {return}
                    
                    var myvideosArray:Array<String> = []
                    myvideosArray = videos
                    for vid in songUploadVideos {
                        if !myvideosArray.contains(vid) {
                            myvideosArray.append(vid)
                        }
                    }
                    if myvideosArray != [] {
                        Database.database().reference().child("Registered Persons").child(producer).child("Videos").setValue(myvideosArray)
                    }
                    count+=1
                    if count == songproducerref.count {
                        
                        completion(true)
                    }
                })
            } else {
                completion(true)
            }
        }
    } else {
        completion(true)
    }
        
    }
    
    func updateRecordingEngineerAlbums(song: AlbumUploadSongData, songrecordingengineerref: [String],  completion: @escaping ((Bool) -> Void)) {
        var count = 0
        if !songrecordingengineerref.isEmpty {
            for person in songrecordingengineerref {
                getPersonAlbumsInDB(cat: person, completion: {[weak self] songs in
                    guard let strongSelf = self else {return}
                    var mysongsArray:[String] = []
                    mysongsArray = songs
                    if !mysongsArray.contains("\(strongSelf.tDAppId)") {
                        mysongsArray.append("\(strongSelf.tDAppId)")
                    }
                    Database.database().reference().child("Registered Persons").child(person).child("Albums").setValue(mysongsArray)
                    count+=1
                    if count == songrecordingengineerref.count {
                        completion(true)
                    }
                })
            }
        } else {
            completion(true)
        }
    }
    
    func updateRecordingEngineerRoles(song: AlbumUploadSongData, songrecordingengineerref: [String], completion: @escaping ((Bool) -> Void)) {
        var count = 0
        if song.toneDeafAppId != "" {
            if !songrecordingengineerref.isEmpty {
                for artist in songrecordingengineerref {
                    getPersonRolesInDB(cat: artist, completion: {[weak self] personroles in
                        guard let strongSelf = self else {return}
                        if let proles = personroles {
                            var mysongsArray:[String] = []
                            if let role = proles["Engineer"] as? NSDictionary {
                                if let erole = role["Mastering Engineer"] as? [String] {
                                    mysongsArray = erole
                                    if !mysongsArray.contains("\(strongSelf.tDAppId)"){
                                        mysongsArray.append("\(strongSelf.tDAppId)")
                                    }
                                    if !mysongsArray.contains("\(song.toneDeafAppId)"){
                                        mysongsArray.append("\(song.toneDeafAppId)")
                                    }
                                    
                                    if song.instrumental != "" {
                                        if !mysongsArray.contains("\(song.instrumental)"){
                                            mysongsArray.append("\(song.instrumental)")
                                        }
                                    }
                                    Database.database().reference().child("Registered Persons").child(artist).child("Roles").child("Engineer").child("Recording Engineer").setValue(mysongsArray)
                                    count+=1
                                    if count == songrecordingengineerref.count {
                                        completion(true)
                                    }
                                }
                                else {
                                    var mysongsArray:[String] = []
                                    mysongsArray = ["\(strongSelf.tDAppId)","\(song.toneDeafAppId)"]
                                    if song.instrumental != "" {
                                        mysongsArray.append(song.instrumental)
                                    }
                                    Database.database().reference().child("Registered Persons").child(artist).child("Roles").child("Engineer").child("Recording Engineer").setValue(mysongsArray)
                                    count+=1
                                    if count == songrecordingengineerref.count {
                                        completion(true)
                                    }
                                }
                            } else {
                                var mysongsArray:[String] = []
                                mysongsArray = ["\(strongSelf.tDAppId)","\(song.toneDeafAppId)"]
                                if song.instrumental != "" {
                                    mysongsArray.append(song.instrumental)
                                }
                                Database.database().reference().child("Registered Persons").child(artist).child("Roles").child("Engineer").child("Recording Engineer").setValue(mysongsArray)
                                count+=1
                                if count == songrecordingengineerref.count {
                                    completion(true)
                                }
                            }
                        }
                        else {
                            var mysongsArray:[String] = []
                            mysongsArray = ["\(strongSelf.tDAppId)","\(song.toneDeafAppId)"]
                            if song.instrumental != "" {
                                mysongsArray.append(song.instrumental)
                            }
                            Database.database().reference().child("Registered Persons").child(artist).child("Roles").child("Engineer").child("Recording Engineer").setValue(mysongsArray)
                            count+=1
                            if count == songrecordingengineerref.count {
                                completion(true)
                            }
                        }
                    })
                }
            } else {
                completion(true)
            }
        } else {
            completion(true)
        }
    }
    
    func updateAlbumTracks(song: AlbumUploadSongData, tracknum: String, completion: @escaping ((Bool) -> Void)) {
        getAlbumTracksInDB(cat: albumCategory, completion: {[weak self] songsarray in
            guard let strongSelf = self else {return}
            var mainsongsDict = songsarray
            var mysongsDict:[String:String] = [:]
            if song.toneDeafAppId != "" {
                mysongsDict["Track \(tracknum)"] = "\(song.toneDeafAppId)"
            } else {
                mysongsDict["Track \(tracknum)"] = "\(song.instrumental)"
            }
            if mainsongsDict == [:] {
                mainsongsDict = mysongsDict
            } else {
                mainsongsDict.merge(mysongsDict, uniquingKeysWith: +)
            }
            if mainsongsDict == [:] {
                
            }
//            print("mainsongsDict = \(mainsongsDict)")
            Database.database().reference().child("Music Content").child("Albums").child(strongSelf.albumCategory).child("REQUIRED").child("Tracks").setValue(mainsongsDict)
            strongSelf.asemaphore.signal()
            completion(true)
        })
    }
    
    func updateAlbumVideos(song: AlbumUploadSongData, songUploadVideos:[String], completion: @escaping ((Bool) -> Void)) {
        
        if songUploadVideos != [] {
            
            getAlbumVideosInDB(cat: albumCategory, completion: {[weak self] videos in
                
                guard let strongSelf = self else {return}
                var myvideosArray:Array<String> = []
                myvideosArray = videos
                for vid in songUploadVideos {
                    if !myvideosArray.contains(vid) {
                        myvideosArray.append(vid)
                    }
                }
                if myvideosArray != [] {
                    Database.database().reference().child("Music Content").child("Albums").child(strongSelf.albumCategory).child("REQUIRED").child("Videos").setValue(myvideosArray)
                }
                
                completion(true)
            })
        } else {
            
            completion(true)
        }
    }
    
    func updateAlbumArtists(song: AlbumUploadSongData, completion: @escaping ((Bool) -> Void)) {
        
        getAlbumArtistInDB(cat: albumCategory, completion: { [weak self] artist in
            guard let strongSelf = self else {return}
            var myvideosArray:Array<String> = []
            myvideosArray = artist
            if !song.artists.isEmpty {
                for arti in song.artists {
                    if !myvideosArray.contains(arti) {
                        myvideosArray.append(arti)
                    }
                }
                if myvideosArray != [] {
                    Database.database().reference().child("Music Content").child("Albums").child(strongSelf.albumCategory).child("REQUIRED").child("All Artist").setValue(myvideosArray)
                }
                completion(true)
            } else {
                completion(true)
            }
        })
    }
    
    func updateAlbumArtistRoles(song: AlbumUploadSongData, songartistref: [String], completion: @escaping ((Bool) -> Void)) {
        var count = 0
        
        if song.toneDeafAppId != "" {
            if song.artists.isEmpty {
                completion(true)
            } else {
                if songartistref.isEmpty {
                    completion(true)
                } else {
                    for artist in songartistref {
                        if mainArtist.contains(artist) {
                            getPersonRolesInDB(cat: artist, completion: {[weak self] personroles in
                                guard let strongSelf = self else {return}
                                if let proles = personroles {
                                    var mysongsArray:[String] = []
                                    if let role = proles["Artist"] as? [String] {
                                        mysongsArray = role
                                        if !mysongsArray.contains("\(strongSelf.tDAppId)"){
                                            mysongsArray.append("\(strongSelf.tDAppId)")
                                        }
                                        Database.database().reference().child("Registered Persons").child(artist).child("Roles").child("Artist").setValue(mysongsArray)
                                        count+=1
                                        if count == strongSelf.mainArtist.count {
                                            completion(true)
                                        }
                                    } else {
                                        var mysongsArray:[String] = []
                                        mysongsArray = ["\(strongSelf.tDAppId)"]
                                        Database.database().reference().child("Registered Persons").child(artist).child("Roles").child("Artist").setValue(mysongsArray)
                                        count+=1
                                        if count == strongSelf.mainArtist.count {
                                            completion(true)
                                        }
                                    }
                                }
                                else {
                                    var mysongsArray:[String] = []
                                    mysongsArray = ["\(strongSelf.tDAppId)"]
                                    Database.database().reference().child("Registered Persons").child(artist).child("Roles").child("Artist").setValue(mysongsArray)
                                    count+=1
                                    if count == strongSelf.mainArtist.count {
                                        completion(true)
                                    }
                                }
                            })
                        } else {
                            count+=1
                            if count == mainArtist.count {
                                completion(true)
                            }
                        }
                    }
                }
            }
        } else {
            completion(true)
        }
    }
    
    func updateAlbumProducers(song: AlbumUploadSongData, completion: @escaping ((Bool) -> Void)) {
        getAlbumProducersInDB(cat: albumCategory, completion: { [weak self] artist in
            guard let strongSelf = self else {return}
            var myvideosArray:Array<String> = []
            myvideosArray = artist
            for arti in song.producers {
                if !myvideosArray.contains(arti) {
                    myvideosArray.append(arti)
                }
            }
            if myvideosArray != [] {
                Database.database().reference().child("Music Content").child("Albums").child(strongSelf.albumCategory).child("REQUIRED").child("All Producers").setValue(myvideosArray)
            }
            completion(true)
        })
    }
    
    func updateAlbumWriters(song: AlbumUploadSongData, completion: @escaping ((Bool) -> Void)) {
        getAlbumWritersInDB(cat: albumCategory, completion: { [weak self] writer in
            guard let strongSelf = self else {return}
            var myvideosArray:Array<String> = []
            myvideosArray = writer
            
            if let wri = song.writers {
                for arti in wri {
                    if !myvideosArray.contains(arti) {
                        myvideosArray.append(arti)
                    }
                }
                if myvideosArray != [] {
                    Database.database().reference().child("Music Content").child("Albums").child(strongSelf.albumCategory).child("REQUIRED").child("All Writers").setValue(myvideosArray)
                }
                completion(true)
            } else {
                completion(true)
            }
        })
    }
    
    func updateAlbumMixEngineers(song: AlbumUploadSongData, completion: @escaping ((Bool) -> Void)) {
        getAlbumMixEngineersInDB(cat: albumCategory, completion: { [weak self] writer in
            guard let strongSelf = self else {return}
            var myvideosArray:Array<String> = []
            myvideosArray = writer
            
            if let engie = song.mixEngineers {
                for arti in engie {
                    if !myvideosArray.contains(arti) {
                        myvideosArray.append(arti)
                    }
                }
                if myvideosArray != [] {
                    Database.database().reference().child("Music Content").child("Albums").child(strongSelf.albumCategory).child("REQUIRED").child("Engineers").child("Mix Engineer").setValue(myvideosArray)
                }
                completion(true)
            } else {
                completion(true)
            }
        })
    }
    
    func updateAlbumMasteringEngineers(song: AlbumUploadSongData, completion: @escaping ((Bool) -> Void)) {
        getAlbumMasteringEngineersInDB(cat: albumCategory, completion: { [weak self] writer in
            guard let strongSelf = self else {return}
            var myvideosArray:Array<String> = []
            myvideosArray = writer
            
            if let engie = song.masteringEngineers {
                for arti in engie {
                    if !myvideosArray.contains(arti) {
                        myvideosArray.append(arti)
                    }
                }
                if myvideosArray != [] {
                    Database.database().reference().child("Music Content").child("Albums").child(strongSelf.albumCategory).child("REQUIRED").child("Engineers").child("Mastering Engineer").setValue(myvideosArray)
                }
                completion(true)
            } else {
                completion(true)
            }
        })
    }
    
    func updateAlbumRecordingEngineers(song: AlbumUploadSongData, completion: @escaping ((Bool) -> Void)) {
        getAlbumRecordingEngineersInDB(cat: albumCategory, completion: { [weak self] writer in
            
            guard let strongSelf = self else {return}
            var myvideosArray:Array<String> = []
            myvideosArray = writer
            
            if let engie = song.recordingEngineers {
                for arti in engie {
                    if !myvideosArray.contains(arti) {
                        myvideosArray.append(arti)
                    }
                }
                if myvideosArray != [] {
                    Database.database().reference().child("Music Content").child("Albums").child(strongSelf.albumCategory).child("REQUIRED").child("Engineers").child("Recording Engineer").setValue(myvideosArray)
                }
                
                completion(true)
            } else {
                
                completion(true)
            }
        })
    }
    
    func getArtistRefs(song: AlbumUploadSongData, completion: @escaping (([String]?, Bool) -> Void)) {
        var songartistref:[String] = []
        var tick = 0
        if !song.artists.isEmpty {
            for artist in song.artists {
                let word = artist.split(separator: "Æ")
                let id = word[0]
                Database.database().reference().child("Registered Persons").observeSingleEvent(of: .value, with: {[weak self] snapshot in
                    guard let strongSelf = self else {return}
                    for artis in snapshot.children {
                        if tick == song.artists.count {
                            break
                        }
                        let data = artis as! DataSnapshot
                        let key = data.key
                        //print(data.key, artist)
                        if data.key.contains(id) == true {
                            songartistref.append(key)
                            tick+=1
                        }
                        if tick == song.artists.count {
                            print("1 \(songartistref)")
                            completion(songartistref, true)
                            break
                        }
                    }
                    
                })
            }
        } else {
            completion(nil,true)
        }
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
//                    print("person songs from db \(mysongsArray)")
                    completion(mysongsArray)
                } else {
                    completion(mysongsArray)
                }
            } else {
                completion(mysongsArray)
            }
        })
    }
    
    func getPersonRolesInDB(cat: String, completion: @escaping (NSDictionary?) -> Void) {
        let ref = Database.database().reference().child("Registered Persons").child(cat).child("Roles")
        ref.observeSingleEvent(of: .value, with: { snapshot in
            
            if let val = snapshot.value {
                let valu = val as? NSDictionary
                guard let value = valu else {
                    completion(nil)
                    return}
                    completion(value)
            } else {
                completion(nil)
            }
        })
    }
    
    func getArtistInstrumentalsInDB(cat: String, completion: @escaping (Array<String>) -> Void) {
        let ref = Database.database().reference().child("Registered Persons").child(cat).child("Instrumentals")
        ref.observeSingleEvent(of: .value, with: { snapshot in
            
            var mysongsArray:[String] = []
            if let val = snapshot.value {
                let valu = val as? [String]
                guard let value = valu else {return}
                if value[0] != "" {
                    mysongsArray = value
                    print("artist instrumentals from db \(mysongsArray)")
                    completion(mysongsArray)
                } else {
                    completion(mysongsArray)
                }
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
                    print("artist videos from db \(mysongsArray)")
                    completion(mysongsArray)
                } else {
                    completion(mysongsArray)
                }
            } else {
                completion(mysongsArray)
            }
            //print(val)
        })
    }
    
    func getPersonAlbumsInDB(cat: String, completion: @escaping (Array<String>) -> Void) {
        let ref = Database.database().reference().child("Registered Persons").child(cat).child("Albums")
        ref.observeSingleEvent(of: .value, with: { snapshot in
            var mysongsArray:[String] = []
            if let val = snapshot.value {
                let valu = val as? [String]
                guard let value = valu else {
                    completion(mysongsArray)
                    return}
                if value[0] != "" {
                    mysongsArray = value
//                    print("person albums from db \(mysongsArray)")
                    completion(mysongsArray)
                } else {
                    completion(mysongsArray)
                }
            } else {
                completion(mysongsArray)
            }
        })
    }
    
    func getProducerRefs(song: AlbumUploadSongData, completion: @escaping (([String], Bool) -> Void)) {
        var songproducerref:[String] = []
        var tick = 0
        for producer in song.producers {
            let word = producer.split(separator: "Æ")
            let id = word[0]
            Database.database().reference().child("Registered Persons").observeSingleEvent(of: .value, with: {[weak self] snapshot in
                guard let strongSelf = self else {return}
                for produce in snapshot.children {
                    if song.producers.count == tick{
                        break
                    }

                    let data = produce as! DataSnapshot
                    let key = data.key
                    if data.key.contains(id) == true {
                        songproducerref.append(key)
                        tick+=1
                    }
                    if song.producers.count == tick {
                        completion(songproducerref, true)
                        break
                    }
                }
            })
        }
    }
    
    func getProducerInstrumentalsInDB(cat: String, completion: @escaping (Array<String>) -> Void) {
        let ref = Database.database().reference().child("Registered Persons").child(cat).child("Instrumentals")
        ref.observeSingleEvent(of: .value, with: { snapshot in
            var mysongsArray:[String] = []
            if let val = snapshot.value {
                let valu = val as? [String]
                guard let value = valu else {return}
                if value[0] != "" {
                    mysongsArray = value
                    print("producer instrumentals from db \(mysongsArray)")
                    completion(mysongsArray)
                } else {
                    completion(mysongsArray)
                }
            } else {
                completion(mysongsArray)
            }
        })
    }
    
    func getProducersVideosInDB(cat: String, completion: @escaping (Array<String>) -> Void) {
        let ref = Database.database().reference().child("Registered Producers").child(cat).child("Videos")
        ref.observeSingleEvent(of: .value, with: { snapshot in
            var mysongsArray:[String] = []
            if let val = snapshot.value {
                let valu = val as? [String]
                guard let value = valu else {return}
                if value[0] != "" {
                    mysongsArray = value
                    print("producer videos from db \(mysongsArray)")
                    completion(mysongsArray)
                } else {
                    completion(mysongsArray)
                }
            } else {
                completion(mysongsArray)
            }
        })
    }
    
    func getProducerAlbumsInDB(cat: String, completion: @escaping (Array<String>) -> Void) {
        let ref = Database.database().reference().child("Registered Producers").child(cat).child("Albums")
        ref.observeSingleEvent(of: .value, with: { snapshot in
            var mysongsArray:[String] = []
            if let val = snapshot.value {
                let valu = val as? [String]
                guard let value = valu else {return}
                if value[0] != "" {
                    mysongsArray = value
                    print("producer albums from db \(mysongsArray)")
                    completion(mysongsArray)
                } else {
                    completion(mysongsArray)
                }
            } else {
                completion(mysongsArray)
            }
        })
    }
    
    func getWriterRefs(song: AlbumUploadSongData, completion: @escaping (([String], Bool) -> Void)) {
        var songwriterref:[String] = []
        var tick = 0
        if let wri = song.writers {
            if !wri.isEmpty {
                for writer in wri {
                    let word = writer.split(separator: "Æ")
                    let id = word[0]
                    Database.database().reference().child("Registered Persons").observeSingleEvent(of: .value, with: {[weak self] snapshot in
                        guard let strongSelf = self else {return}
                        for produce in snapshot.children {
                            if wri.count == tick{
                                break
                            }
                            
                            let data = produce as! DataSnapshot
                            let key = data.key
                            if data.key.contains(id) == true {
                                songwriterref.append(key)
                                tick+=1
                            }
                            if wri.count == tick {
                                completion(songwriterref, true)
                                break
                            }
                        }
                    })
                }
            } else {
                completion(songwriterref, true)
        }
        }
        else {
            completion(songwriterref, true)
        }
    }
    
    func getMixEngineerRefs(song: AlbumUploadSongData, completion: @escaping (([String], Bool) -> Void)) {
        var songengref:[String] = []
        var tick = 0
        if let eng = song.mixEngineers {
            if !eng.isEmpty {
            for engie in eng {
                let word = engie.split(separator: "Æ")
                let id = word[0]
                Database.database().reference().child("Registered Persons").observeSingleEvent(of: .value, with: {[weak self] snapshot in
                    guard let strongSelf = self else {return}
                    for produce in snapshot.children {
                        if eng.count == tick{
                            break
                        }
                        
                        let data = produce as! DataSnapshot
                        let key = data.key
                        if data.key.contains(id) == true {
                            songengref.append(key)
                            tick+=1
                        }
                        if eng.count == tick {
                            completion(songengref, true)
                            break
                        }
                    }
                })
            }
            } else {
                completion(songengref, true)
            }
        }
        else {
            completion(songengref, true)
        }
    }
    
    func getMasteringEngineerRefs(song: AlbumUploadSongData, completion: @escaping (([String], Bool) -> Void)) {
        var songengref:[String] = []
        var tick = 0
        if let eng = song.masteringEngineers {
            if !eng.isEmpty {
            for engie in eng {
                let word = engie.split(separator: "Æ")
                let id = word[0]
                Database.database().reference().child("Registered Persons").observeSingleEvent(of: .value, with: {[weak self] snapshot in
                    guard let strongSelf = self else {return}
                    for produce in snapshot.children {
                        if eng.count == tick{
                            break
                        }
                        
                        let data = produce as! DataSnapshot
                        let key = data.key
                        if data.key.contains(id) == true {
                            songengref.append(key)
                            tick+=1
                        }
                        if eng.count == tick {
                            completion(songengref, true)
                            break
                        }
                    }
                })
            }
        } else {
            completion(songengref, true)
        }
        }
        else {
            completion(songengref, true)
        }
    }
    
    func getRecordingEngineerRefs(song: AlbumUploadSongData, completion: @escaping (([String], Bool) -> Void)) {
        var songengref:[String] = []
        var tick = 0
        if let eng = song.recordingEngineers {
            if !eng.isEmpty {
            for engie in eng {
                let word = engie.split(separator: "Æ")
                let id = word[0]
                Database.database().reference().child("Registered Persons").observeSingleEvent(of: .value, with: {[weak self] snapshot in
                    guard let strongSelf = self else {return}
                    for produce in snapshot.children {
                        if eng.count == tick{
                            break
                        }
                        
                        let data = produce as! DataSnapshot
                        let key = data.key
                        if data.key.contains(id) == true {
                            songengref.append(key)
                            tick+=1
                        }
                        if eng.count == tick {
                            completion(songengref, true)
                            break
                        }
                    }
                })
            }
            
            } else {
                completion(songengref, true)
            }
        }
        else {
            completion(songengref, true)
        }
    }
    
    func getAlbumSongsInDB(cat: String, completion: @escaping ([String]) -> Void) {
        asemaphore.wait()
        let ref = Database.database().reference().child("Music Content").child("Albums").child(cat).child("REQUIRED").child("Songs")
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
    
    func getAlbumTracksInDB(cat: String, completion: @escaping ([String:String]) -> Void) {
        asemaphore.wait()
        let ref = Database.database().reference().child("Music Content").child("Albums").child(cat).child("REQUIRED").child("Tracks")
        ref.observeSingleEvent(of: .value, with: { snapshot in
            
            if let val = snapshot.value {
                var mysongsArray:[String:String] = [:]
                if let value = val as? [String:String] {
                    if value != ["1000":""] {
                        for i in 0..<32 {
                            if let song = value["Track \(i)"] {
                                mysongsArray.merge(["Track \(i)":song], uniquingKeysWith: +)
//                                print("doofen \(mysongsArray)")
                            }
                        }
                    } else {
                    }
                } else if let array = val as? Array<[String:String]> {
                    let value = array[0]
                    for i in 0..<32 {
                        if let song = value["Track \(i)"] {
                            mysongsArray.merge(["Track \(i)":song], uniquingKeysWith: +)
                        }
                    }
                }
                else  {
                    let dict:[String:String] = [:]
                    mysongsArray = dict
                }
//                print("album songs from db \(mysongsArray)")
                completion(mysongsArray)
            } else {
                fatalError()
                print("dumb shit \(snapshot)")
                let mysongsArray:[String:String] = [:]
                completion(mysongsArray)
            }
        })
        
    }
    
    func getAlbumVideosInDB(cat: String, completion: @escaping (Array<String>) -> Void) {
        let ref = Database.database().reference().child("Music Content").child("Albums").child(cat).child("REQUIRED").child("Videos")
        ref.observeSingleEvent(of: .value, with: { snapshot in
            
            var mysongsArray:[String] = []
            
            if let val = snapshot.value {
                let valu = val as? [String]
                guard let value = valu else {return}
                if value[0] != "" {
                    mysongsArray = value
                    print("album videos from db \(mysongsArray)")
                    completion(mysongsArray)
                } else {
                    completion(mysongsArray)
                }
            } else {
                
                completion(mysongsArray)
            }
            //print(val)
        })
    }
    
    func getAlbumArtistInDB(cat: String, completion: @escaping (Array<String>) -> Void) {
        let ref = Database.database().reference().child("Music Content").child("Albums").child(cat).child("REQUIRED").child("All Artist")
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
                    //print("album artist from db \(mysongsArray)")
                    completion(mysongsArray)
                } else {
                    completion(mysongsArray)
                }
            } else {
                completion(mysongsArray)
            }
            //print(val)
        })
    }
    
    func getAlbumProducersInDB(cat: String, completion: @escaping (Array<String>) -> Void) {
        let ref = Database.database().reference().child("Music Content").child("Albums").child(cat).child("REQUIRED").child("All Producers")
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
                //print("videos from db \(mysongsArray)")
                completion(mysongsArray)
            } else {
                completion(mysongsArray)
            }
            //print(val)
        })
    }
    
    func getAlbumWritersInDB(cat: String, completion: @escaping (Array<String>) -> Void) {
        let ref = Database.database().reference().child("Music Content").child("Albums").child(cat).child("REQUIRED").child("All Writers")
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
                    //print("album writers from db \(mysongsArray)")
                    completion(mysongsArray)
                } else {
                    completion(mysongsArray)
                }
            } else {
                completion(mysongsArray)
            }
            //print(val)
        })
    }
    
    func getAlbumMixEngineersInDB(cat: String, completion: @escaping (Array<String>) -> Void) {
        let ref = Database.database().reference().child("Music Content").child("Albums").child(cat).child("REQUIRED").child("Engineers").child("Mix Engineer")
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
                    //print("album writers from db \(mysongsArray)")
                    completion(mysongsArray)
                } else {
                    completion(mysongsArray)
                }
            } else {
                completion(mysongsArray)
            }
            //print(val)
        })
    }
    
    func getAlbumMasteringEngineersInDB(cat: String, completion: @escaping (Array<String>) -> Void) {
        let ref = Database.database().reference().child("Music Content").child("Albums").child(cat).child("REQUIRED").child("Engineers").child("Mastering Engineer")
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
                    //print("album writers from db \(mysongsArray)")
                    completion(mysongsArray)
                } else {
                    completion(mysongsArray)
                }
            } else {
                completion(mysongsArray)
            }
            //print(val)
        })
    }
    
    func getAlbumRecordingEngineersInDB(cat: String, completion: @escaping (Array<String>) -> Void) {
        let ref = Database.database().reference().child("Music Content").child("Albums").child(cat).child("REQUIRED").child("Engineers").child("Recording Engineer")
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
                    //print("album artist from db \(mysongsArray)")
                    completion(mysongsArray)
                } else {
                    completion(mysongsArray)
                }
            } else {
                completion(mysongsArray)
            }
            //print(val)
        })
    }
    
    func getSongRefs(song: AlbumUploadSongData, completion: @escaping (([String], Bool) -> Void)) {
        var songproducerref:[String] = []
        var tick = 0
        for intstrumental in song.songsForinstrumental {
            let word = intstrumental.split(separator: "Æ")
            let id = word[0]
            Database.database().reference().child("Music Content").child("Songs").observeSingleEvent(of: .value, with: {[weak self] snapshot in
                print("allsongsfromsnap \(snapshot)")
                guard let strongSelf = self else {return}
                for produce in snapshot.children {
                    print("songgoing \(produce)")
                    if song.songsForinstrumental.count == tick{
                        break
                    }

                    let data = produce as! DataSnapshot
                    let key = data.key
                    print("keyInstr \(key), \(id)")
                    if data.key.contains(id) == true {
                        songproducerref.append(key)
                        tick+=1
                    }
                    print("tickis \(tick), countis\(song.songsForinstrumental.count)")
                    if song.songsForinstrumental.count == tick {
                        completion(songproducerref, true)
                        break
                    }
                }
            })
        }
    }
    
    func getVideoRefs(vid: [String], completion: @escaping (([String], Bool) -> Void)) {
        var videoref:[String] = []
        var tick = 0
        for video in vid {
            let word = video.split(separator: "Æ")
            let id = word[0]
            Database.database().reference().child("Music Content").child("Videos").observeSingleEvent(of: .value, with: {[weak self] snapshot in
                guard let strongSelf = self else {return}
                for produce in snapshot.children {
                    if vid.count == tick{
                        break
                    }

                    let data = produce as! DataSnapshot
                    let key = data.key
                    if data.key.contains(id) == true {
                        videoref.append(key)
                        tick+=1
                    }
                    if vid.count == tick {
                        completion(videoref, true)
                        break
                    }
                }
            })
        }
    }
    
    func getSongInstrumentalsInDB(cat: String, completion: @escaping (Array<String>) -> Void) {
        print("dacat \(cat)")
        let ref = Database.database().reference().child("Music Content").child("Songs").child(cat).child("REQUIRED").child("Instrumentals")
        ref.observeSingleEvent(of: .value, with: { snapshot in
            print("datsnapmf \(snapshot)" )
            var mysongsArray:[String] = []
            if let val = snapshot.value {
                let valu = val as? [String]
                guard let value = valu else {return}
                print("datvaluemf \(value)")
                if value[0] != "" {
                    mysongsArray = value
                    print("song instrumentals from db \(mysongsArray)")
                    completion(mysongsArray)
                } else {
                    completion(mysongsArray)
                }
            } else {
                completion(mysongsArray)
            }
        })
    }
    
    func getVideoInstrumentalsInDB(cat: String, completion: @escaping (Array<String>) -> Void) {
        let ref = Database.database().reference().child("Music Content").child("Videos").child(cat).child("Instrumentals")
        ref.observeSingleEvent(of: .value, with: { snapshot in
            var mysongsArray:[String] = []
            if let val = snapshot.value {
                let valu = val as? [String]
                guard let value = valu else {return}
                if value[0] != "" {
                    mysongsArray = value
                    //print("song instrumentals from db \(mysongsArray)")
                    completion(mysongsArray)
                } else {
                    completion(mysongsArray)
                }
            } else {
                completion(mysongsArray)
            }
        })
    }
    
    func getSongVideosInDB(cat: String, completion: @escaping (Array<String>) -> Void) {
        let ref = Database.database().reference().child("Music Content").child("Songs").child(cat).child("REQUIRED").child("Videos")
        ref.observeSingleEvent(of: .value, with: { snapshot in
            var mysongsArray:[String] = []
            if let val = snapshot.value {
                let valu = val as? [String]
                guard let value = valu else {
                    completion(mysongsArray)
                    return}
                if value[0] != "" {
                    mysongsArray = value
                    print("song videos from db \(mysongsArray)")
                    completion(mysongsArray)
                } else {
                    completion(mysongsArray)
                }
            } else {
                completion(mysongsArray)
            }
        })
    }
    
    func uploadFailed() {
        Database.database().reference().child("Music Content").child("Albums").child(albumCategory).removeValue()
    }
    
    func uploadFailed(songartistref: [String], songproducerref: [String]) {
        Database.database().reference().child("Music Content").child("Albums").child(albumCategory).removeValue()
        
        for song in albumUploadSongsArray {
            
        }
    }
    
    func getAlbumYoutubeData(album:AlbumData, completion: @escaping (Array<YouTubeData>, Array<String>) -> Void) {
        var videosData:Array<YouTubeData> = []
        var youtubeimageURLs:Array<String> = []
        var val = 1
        if album.videos != nil {
            if album.videos![0] != "" {
                for video in album.videos! {
                    DatabaseManager.shared.findVideoById(videoid: video, completion: { selectedVideo in
                        switch selectedVideo {
                        case .success(let vid):
                            let video = vid as! YouTubeData
                            videosData.append(video)
                            if video.thumbnailURL != "" {
                                youtubeimageURLs.append(video.thumbnailURL)
                            }
                            if val == album.videos!.count {
                                completion(videosData, youtubeimageURLs)
                            }
                            val+=1
                        case .failure(let error):
                            print("Video ID proccessing error \(error)")
                            if val == album.videos!.count {
                                completion(videosData, youtubeimageURLs)
                            }
                            val+=1
                        }
                    })
                }
            } else {
                completion(videosData, youtubeimageURLs)
            }
        } else {
            completion(videosData, youtubeimageURLs)
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
    
    func dismissKeyboardOnTap() {
        let tap = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        scrollView.keyboardDismissMode = .onDrag
        artistEditing = false
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @objc func dismissKeyboard2() {
        if mainArtist.indices.contains(0) == true {
            if mainArtist[0] == "" {
                mainArtist = []
                mainArtistsNames = []
            }
        }
        if chosenArtist != "" {
            mainArtist.append("\(chosenArtist.trimmingCharacters(in: .whitespacesAndNewlines))")
            mainArtistsNames.append(chosenArtistNames.trimmingCharacters(in: .whitespacesAndNewlines))
            mainArtistTextField.text = mainArtistsNames.joined(separator: ", ")
        }
        artistEditing = false
        view.endEditing(true)
    }
    
    @objc func dismissKeyboard3() {
        guard let tracknum = Int(chosenTrackNumber) else {
            Utilities.showError2("Error converting track number for \(chosenSong) to int. at 2.", actionText: "OK")
            return
        }
        let fullsong = AlbumSong(trackNumber: tracknum, song: chosenSong)
        albumUploadSongsArray.append(fullsong)
        songsTableView.reloadData()
        tableViewHeightConstraint.constant = songsTableView.contentSize.height
        view.layoutSubviews()
        view.endEditing(true)
    }
    
    @objc func dismissKeyboard4() {
        deluxeOf = deluxeHold[0]
        deluxeOfTextField.text = deluxeHold[1]
        view.endEditing(true)
    }
    
    @objc func dismissKeyboard5() {
        otherVersionsOf = otherVersionsHold[0]
        otherVersionsOfTextField.text = otherVersionsHold[1]
        view.endEditing(true)
    }
    
}

extension AlbumUploadViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == albumUploadSongsArray.count {
            height = 50
        } else {
            height = 130
        }
        return height
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return albumUploadSongsArray.count+1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //print(albumUploadSongsArray.count, indexPath.row)
        albumUploadSongsArray.sort(by: {$0.trackNumber < $1.trackNumber})
        if albumUploadSongsArray.count != 0 && indexPath.row != albumUploadSongsArray.count {
            //print(albumUploadSongsArray.count, indexPath.row)
            let cell = tableView.dequeueReusableCell(withIdentifier: "albumUploadSongAddedCell", for: indexPath) as! AlbumUploadSongsTableCellController
            let song = albumUploadSongsArray[indexPath.row]
            cell.funcSetTemp(array: song)
            return cell
        } else if indexPath.row == albumUploadSongsArray.count {
            let cell = tableView.dequeueReusableCell(withIdentifier: "albumUploadAddNewSongCell", for: indexPath) as! AlbumUploadAddNewSongTableCellController
            cell.funcSetTemp()
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "albumUploadAddNewSongCell", for: indexPath) as! AlbumUploadAddNewSongTableCellController
            cell.funcSetTemp()
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        if indexPath.row == albumUploadSongsArray.count {
            let actionSheet = UIAlertController(title: "Add method",
                                                message: "",
                                                preferredStyle: .alert)
            actionSheet.addAction(UIAlertAction(title: "New song",
                                                style: .default,
                                                handler: { [weak self] _ in
                guard let strongSelf = self else {return}
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let vc = storyboard.instantiateViewController(identifier: "AlbumNewSongAddViewController") as! AlbumNewSongAddViewController
                strongSelf.present(vc, animated: true, completion: nil)
            }))
            
            actionSheet.addAction(UIAlertAction(title: "Previously released song",
                                                style: .default,
                                                handler: { [weak self] _ in
                guard let strongSelf = self else {return}
                strongSelf.hiddenTextField.becomeFirstResponder()
                
            }))
            
            actionSheet.addAction(UIAlertAction(title: "Previously released instrumental",
                                                style: .default,
                                                handler: { [weak self] _ in
                guard let strongSelf = self else {return}
                strongSelf.hiddenTextFieldI.becomeFirstResponder()
                
            }))
            
            actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            actionSheet.view.tintColor = Constants.Colors.redApp
            
            present(actionSheet, animated: true)
        } else {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(identifier: "AlbumNewSongAddViewController") as! AlbumNewSongAddViewController
            let index = indexPath.row
            let song = albumUploadSongsArray[index]
            let updateArray:[Any] = [index, song]
            present(vc, animated: true, completion: {
                NotificationCenter.default.post(name: EditAlbumSongUploadNotify, object: updateArray)
            })
        }
    }
}

class AlbumUploadTableViewController: UITableView {
    override var intrinsicContentSize: CGSize {
        layoutIfNeeded()
        return CGSize(width: UIView.noIntrinsicMetric, height: contentSize.height)
    }
}

class AlbumUploadSongsTableCellController: UITableViewCell {
    
    @IBOutlet weak var trackNumber: UILabel!
    @IBOutlet weak var typeImage: UIImageView!
    @IBOutlet weak var songTitle: UILabel!
    @IBOutlet weak var songArtist: UILabel!
    @IBOutlet weak var songProducers: UILabel!
    @IBOutlet weak var songWriters: UILabel!
    @IBOutlet weak var songMixEngineers: UILabel!
    @IBOutlet weak var songMasteringEngineers: UILabel!
    @IBOutlet weak var songRecordingEngineers: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func prepareForReuse() {
            typeImage.isHidden = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func funcSetTemp(array: AlbumSong) {
        switch array.song {
        case is AlbumUploadSongData:
            let song = array.song as! AlbumUploadSongData
            trackNumber.text = "\(array.trackNumber))"
            songTitle.text = song.name
            if song.explicit == true {
                typeImage.isHidden = false
                typeImage.image = UIImage(named: "explicit")
            }
            if song.instrumental != "" {
                typeImage.isHidden = false
                typeImage.image = UIImage(named: "instrumental")
            }
            getArtistData(song: song, completion: {[weak self] artistNames in
                guard let strongSelf = self else {return}
                if !artistNames.isEmpty {
                    strongSelf.songArtist.text = "Artists: \(artistNames.joined(separator: ", "))"
                    strongSelf.songArtist.alpha = 1
                } else {
                    strongSelf.songArtist.text = "Artists: --"
                    strongSelf.songArtist.alpha = 0.5
                }
            })
            getProducerData(song: song, completion: {[weak self] producerNames in
                guard let strongSelf = self else {return}
                strongSelf.songProducers.text = "Producers: \(producerNames.joined(separator: ", "))"
            })
            getWriterData(song: song, completion: {[weak self] writerNames in
                guard let strongSelf = self else {return}
                if let names = writerNames {
                    strongSelf.songWriters.text = "Writers: \(names.joined(separator: ", "))"
                    strongSelf.songWriters.alpha = 1
                }
                else {
                    strongSelf.songWriters.text = "Writers: --"
                    strongSelf.songWriters.alpha = 0.5
                }
            })
            getMixEngineerData(song: song, completion: {[weak self] mixEngineerNames in
                guard let strongSelf = self else {return}
                if let names = mixEngineerNames {
                    strongSelf.songMixEngineers.text = "Mix Engineers: \(names.joined(separator: ", "))"
                    strongSelf.songMixEngineers.alpha = 1
                }
                else {
                    strongSelf.songMixEngineers.text = "Mix Engineers: --"
                    strongSelf.songMixEngineers.alpha = 0.5
                }
            })
            getMasteringEngineerData(song: song, completion: {[weak self] masteringEngineerNames in
                guard let strongSelf = self else {return}
                if let names = masteringEngineerNames {
                    strongSelf.songMasteringEngineers.text = "Mastering Engineers: \(names.joined(separator: ", "))"
                    strongSelf.songMasteringEngineers.alpha = 1
                }
                else {
                    strongSelf.songMasteringEngineers.text = "Mastering Engineers: --"
                    strongSelf.songMasteringEngineers.alpha = 0.5
                }
            })
            getRecordingEngineerData(song: song, completion: {[weak self] recordingEngineerNames in
                guard let strongSelf = self else {return}
                if let names = recordingEngineerNames {
                    strongSelf.songRecordingEngineers.text = "Recording Engineers: \(names.joined(separator: ", "))"
                    strongSelf.songRecordingEngineers.alpha = 1
                }
                else {
                    strongSelf.songRecordingEngineers.text = "Recording Engineers: --"
                    strongSelf.songRecordingEngineers.alpha = 0.5
                }
            })
            if song.instrumental != "" {
                songRecordingEngineers.isHidden = true
                songWriters.isHidden = true
            } else {
                songRecordingEngineers.isHidden = false
                songWriters.isHidden = false
            }
        case is String:
            let songs = array.song as! String
            let songid = songs
            let tracknum = array.trackNumber
            switch songid.count {
            case 10:
                DatabaseManager.shared.findSongById(songId: songid, completion: {[weak self] result in
                    guard let strongSelf = self else {return}
                    switch result {
                    case .success(let song):
                        strongSelf.trackNumber.text = "\(tracknum))"
                        strongSelf.songTitle.text = song.name
                        if song.explicit == true {
                            strongSelf.typeImage.isHidden = false
                            strongSelf.typeImage.image = UIImage(named: "explicit")
                        }
                        strongSelf.getArtistData(song: song, completion: {[weak self] artistNames in
                            guard let strongSelf = self else {return}
                            if !artistNames.isEmpty {
                                strongSelf.songArtist.text = "Artists: \(artistNames.joined(separator: ", "))"
                                strongSelf.songArtist.alpha = 1
                            } else {
                                strongSelf.songArtist.text = "Artists: --"
                                strongSelf.songArtist.alpha = 0.5
                            }
                        })
                        strongSelf.getProducerData(song: song, completion: {[weak self] producerNames in
                            guard let strongSelf = self else {return}
                            strongSelf.songProducers.text = "Producers: \(producerNames.joined(separator: ", "))"
                        })
                        strongSelf.getWriterData(song: song, completion: {[weak self] writerNames in
                            guard let strongSelf = self else {return}
                            if !writerNames.isEmpty {
                                strongSelf.songWriters.text = "Writers: \(writerNames.joined(separator: ", "))"
                                strongSelf.songWriters.alpha = 1
                            }
                            else {
                                strongSelf.songWriters.text = "Writers: --"
                                strongSelf.songWriters.alpha = 0.5
                            }
                        })
                        strongSelf.getMixEngineerData(song: song, completion: {[weak self] mixEngineerNames in
                            guard let strongSelf = self else {return}
                            if !mixEngineerNames.isEmpty {
                                strongSelf.songMixEngineers.text = "Mix Engineers: \(mixEngineerNames.joined(separator: ", "))"
                                strongSelf.songMixEngineers.alpha = 1
                            }
                            else {
                                strongSelf.songMixEngineers.text = "Mix Engineers: --"
                                strongSelf.songMixEngineers.alpha = 0.5
                            }
                        })
                        strongSelf.getMasteringEngineerData(song: song, completion: {[weak self] masteringEngineerNames in
                            guard let strongSelf = self else {return}
                            if !masteringEngineerNames.isEmpty {
                                strongSelf.songMasteringEngineers.text = "Mastering Engineers: \(masteringEngineerNames.joined(separator: ", "))"
                                strongSelf.songMasteringEngineers.alpha = 1
                            }
                            else {
                                strongSelf.songMasteringEngineers.text = "Mastering Engineers: --"
                                strongSelf.songMasteringEngineers.alpha = 0.5
                            }
                        })
                        strongSelf.getRecordingEngineerData(song: song, completion: {[weak self] recordingEngineerNames in
                            guard let strongSelf = self else {return}
                            if !recordingEngineerNames.isEmpty {
                                strongSelf.songRecordingEngineers.text = "Recording Engineers: \(recordingEngineerNames.joined(separator: ", "))"
                                strongSelf.songRecordingEngineers.alpha = 1
                            }
                            else {
                                strongSelf.songRecordingEngineers.text = "Recording Engineers: --"
                                strongSelf.songRecordingEngineers.alpha = 0.5
                            }
                        })
                    case .failure(let error):
                        print("Song Id Processing error: \(error)")
                    }
                })
            case 12:
                DatabaseManager.shared.findInstrumentalById(instrumentalId: songid, completion: {[weak self] result in
                    guard let strongSelf = self else {return}
                    switch result {
                    case .success(let song):
                        strongSelf.trackNumber.text = "\(tracknum))"
                        strongSelf.songTitle.text = song.songName!
                        strongSelf.typeImage.isHidden = false
                        strongSelf.typeImage.image = UIImage(named: "instrumental")
                        strongSelf.getArtistData(instrumental: song, completion: {[weak self] artistNames in
                            guard let strongSelf = self else {return}
                            if !artistNames.isEmpty {
                                strongSelf.songArtist.text = "Artists: \(artistNames.joined(separator: ", "))"
                                strongSelf.songArtist.alpha = 1
                            } else {
                                strongSelf.songArtist.text = "Artists: --"
                                strongSelf.songArtist.alpha = 0.5
                            }
                        })
                        strongSelf.getProducerData(instrumental: song, completion: {[weak self] producerNames in
                            guard let strongSelf = self else {return}
                            strongSelf.songProducers.text = "Producers: \(producerNames.joined(separator: ", "))"
                        })
                        strongSelf.getMixEngineerData(instrumental: song, completion: {[weak self] mixEngineerNames in
                            guard let strongSelf = self else {return}
                            if !mixEngineerNames.isEmpty {
                                strongSelf.songMixEngineers.text = "Mix Engineers: \(mixEngineerNames.joined(separator: ", "))"
                                strongSelf.songMixEngineers.alpha = 1
                            }
                            else {
                                strongSelf.songMixEngineers.text = "Mix Engineers: --"
                                strongSelf.songMixEngineers.alpha = 0.5
                            }
                        })
                        strongSelf.getMasteringEngineerData(instrumental: song, completion: {[weak self] masteringEngineerNames in
                            guard let strongSelf = self else {return}
                            if !masteringEngineerNames.isEmpty {
                                strongSelf.songMasteringEngineers.text = "Mastering Engineers: \(masteringEngineerNames.joined(separator: ", "))"
                                strongSelf.songMasteringEngineers.alpha = 1
                            }
                            else {
                                strongSelf.songMasteringEngineers.text = "Mastering Engineers: --"
                                strongSelf.songMasteringEngineers.alpha = 0.5
                            }
                        })
                        strongSelf.songRecordingEngineers.isHidden = true
                        strongSelf.songWriters.isHidden = true
                    case .failure(let error):
                        print("Song Id Processing error: \(error)")
                    }
                })
            default:
                break
            }
        default:
            print("lang nil")
        }
    }
    
    func getArtistData(song:SongData, completion: @escaping (Array<String>) -> Void) {
        var artistNameData:Array<String> = []
        var val = 0
        for artist in song.songArtist {
            let word = artist.split(separator: "Æ")
            let id = word[0]
            DatabaseManager.shared.fetchPersonData(person: String(id), completion: { result in
                switch result {
                case .success(let selectedArtist):
                    artistNameData.append(selectedArtist.name!)
                    val+=1
                    
                    if val == song.songArtist.count {
                        completion(artistNameData)
                    }
                case .failure(let err):
                    print("youyouerr", err)
                }
            })
        }
        
    }
    
    func getProducerData(song:SongData, completion: @escaping (Array<String>) -> Void) {
        var producerNameData:Array<String> = []
        var producerimageURLs:Array<String> = []
        var val = 1
        
        for producer in song.songProducers {
            let word = producer.split(separator: "Æ")
            let id = word[0]
            DatabaseManager.shared.fetchPersonData(person: String(id), completion: { result in
                switch result {
                case .success(let selectedProducer):
                    producerNameData.append(selectedProducer.name!)
                    producerimageURLs.append((selectedProducer.spotify?.profileImageURL)!)
                    if val == song.songProducers.count {
                        completion(producerNameData)
                    }
                    val+=1
                case .failure(let err):
                    print("youyouerr", err)
                }
            })
        }
        
    }
    
    func getWriterData(song:SongData, completion: @escaping (Array<String>) -> Void) {
        var writerNameData:Array<String> = []
        var writerimageURLs:Array<String> = []
        var val = 1
        
        if song.songWriters != nil {
            for writer in song.songWriters! {
                let word = writer.split(separator: "Æ")
                let id = word[0]
                DatabaseManager.shared.fetchPersonData(person: String(id), completion: { result in
                    switch result {
                    case .success(let selectedWriter):
                        writerNameData.append(selectedWriter.name!)
                        //                writerimageURLs.append(selectedWriter.spotify)
                        if val == song.songWriters!.count {
                            completion(writerNameData)
                        }
                        val+=1
                    case .failure(let err):
                        print("youyouerr", err)
                    }
                })
            }
        }
        else {
            completion(writerNameData)
        }
        
    }
    
    func getMixEngineerData(song:SongData, completion: @escaping (Array<String>) -> Void) {
        var writerNameData:Array<String> = []
        var writerimageURLs:Array<String> = []
        var val = 1
        
        if song.songMixEngineer != nil {
            for writer in song.songMixEngineer! {
                let word = writer.split(separator: "Æ")
                let id = word[0]
                DatabaseManager.shared.fetchPersonData(person: String(id), completion: { result in
                    switch result {
                    case .success(let selectedWriter):
                        writerNameData.append(selectedWriter.name!)
                        //                writerimageURLs.append(selectedWriter.spotifyProfileImageURL)
                        if val == song.songWriters!.count {
                            completion(writerNameData)
                        }
                        val+=1
                    case .failure(let err):
                        print("youyouerr", err)
                    }
                })
            }
        }
        else {
            completion(writerNameData)
        }
        
    }
    
    func getMasteringEngineerData(song:SongData, completion: @escaping (Array<String>) -> Void) {
        var writerNameData:Array<String> = []
        var writerimageURLs:Array<String> = []
        var val = 1
        
        if song.songMasteringEngineer != nil {
            for writer in song.songMasteringEngineer! {
                let word = writer.split(separator: "Æ")
                let id = word[0]
                DatabaseManager.shared.fetchPersonData(person: String(id), completion: { result in
                    switch result {
                    case .success(let selectedWriter):
                        writerNameData.append(selectedWriter.name!)
                        //                writerimageURLs.append(selectedWriter.spotifyProfileImageURL)
                        if val == song.songWriters!.count {
                            completion(writerNameData)
                        }
                        val+=1
                    case .failure(let err):
                        print("youyouerr", err)
                    }
                })
            }
        }
        else {
            completion(writerNameData)
        }
        
    }
    
    func getRecordingEngineerData(song:SongData, completion: @escaping (Array<String>) -> Void) {
        var writerNameData:Array<String> = []
        var writerimageURLs:Array<String> = []
        var val = 1
        
        if song.songRecordingEngineer != nil {
            for writer in song.songRecordingEngineer! {
                let word = writer.split(separator: "Æ")
                let id = word[0]
                DatabaseManager.shared.fetchPersonData(person: String(id), completion: { result in
                    switch result {
                    case .success(let selectedWriter):
                        writerNameData.append(selectedWriter.name!)
                        //                writerimageURLs.append(selectedWriter.spotifyProfileImageURL)
                        if val == song.songWriters!.count {
                            completion(writerNameData)
                        }
                        val+=1
                    case .failure(let err):
                        print("youyouerr", err)
                    }
                })
            }
        }
        else {
            completion(writerNameData)
        }
        
    }
    
    func getArtistData(instrumental:InstrumentalData, completion: @escaping (Array<String>) -> Void) {
        var artistNameData:Array<String> = []
        var val = 0
        if instrumental.artist != nil {
            for artist in instrumental.artist! {
                let word = artist.split(separator: "Æ")
                let id = word[0]
                DatabaseManager.shared.fetchPersonData(person: String(id), completion: { result in
                    switch result {
                    case .success(let selectedArtist):
                        artistNameData.append(selectedArtist.name!)
                        val+=1
                        
                        if val == instrumental.artist!.count {
                            completion(artistNameData)
                        }
                    case .failure(let err):
                        print("youyouerr", err)
                    }
                })
            }
        }
        else {
            completion(artistNameData)
        }
        
    }
    
    func getProducerData(instrumental:InstrumentalData, completion: @escaping (Array<String>) -> Void) {
        var producerNameData:Array<String> = []
        var producerimageURLs:Array<String> = []
        var val = 0
        
        for producer in instrumental.producers {
            DatabaseManager.shared.fetchPersonData(person: producer, completion: { result in
                switch result {
                case .success(let selectedProducer):
                    producerNameData.append(selectedProducer.name!)
                    producerimageURLs.append((selectedProducer.spotify?.profileImageURL)!)
                    val+=1
                    if val == instrumental.producers.count {
                        completion(producerNameData)
                    }
                case .failure(let err):
                    print("youyouerr", err)
                }
            })
        }
        
    }
    
    func getMixEngineerData(instrumental:InstrumentalData, completion: @escaping (Array<String>) -> Void) {
        var writerNameData:Array<String> = []
        var writerimageURLs:Array<String> = []
        var val = 1
        
        if instrumental.mixEngineer != nil {
            for writer in instrumental.mixEngineer! {
                let word = writer.split(separator: "Æ")
                let id = word[0]
                DatabaseManager.shared.fetchPersonData(person: String(id), completion: { result in
                    switch result {
                    case .success(let selectedWriter):
                        writerNameData.append(selectedWriter.name!)
                        //                writerimageURLs.append(selectedWriter.spotifyProfileImageURL)
                        if val == instrumental.mixEngineer!.count {
                            completion(writerNameData)
                        }
                        val+=1
                    case .failure(let err):
                        print("youyouerr", err)
                    }
                })
            }
        }
        else {
            completion(writerNameData)
        }
        
    }
    
    func getMasteringEngineerData(instrumental:InstrumentalData, completion: @escaping (Array<String>) -> Void) {
        var writerNameData:Array<String> = []
        var writerimageURLs:Array<String> = []
        var val = 1
        
        if instrumental.masteringEngineer != nil {
            for writer in instrumental.masteringEngineer! {
                let word = writer.split(separator: "Æ")
                let id = word[0]
                DatabaseManager.shared.fetchPersonData(person: String(id), completion: { result in
                    switch result {
                    case .success(let selectedWriter):
                        writerNameData.append(selectedWriter.name!)
                        //                writerimageURLs.append(selectedWriter.spotifyProfileImageURL)
                        if val == instrumental.masteringEngineer!.count {
                            completion(writerNameData)
                        }
                        val+=1
                    case .failure(let err):
                        print("youyouerr", err)
                    }
                })
            }
        }
        else {
            completion(writerNameData)
        }
        
    }
    
    func getArtistData(song:AlbumUploadSongData, completion: @escaping (Array<String>) -> Void) {
        var artistNameData:Array<String> = []
        var val = 0
        if song.artists.isEmpty {
            completion([])
        } else {
            for artist in song.artists {
                DatabaseManager.shared.fetchPersonData(person: artist, completion: { result in
                    switch result {
                    case .success(let selectedArtist):
                        artistNameData.append(selectedArtist.name!)
                        val+=1
                        if val == song.artists.count {
                            completion(artistNameData)
                        }
                    case .failure(let err):
                        print("youyouerr", err)
                    }
                })
            }
        }
        
    }
    
    func getProducerData(song:AlbumUploadSongData, completion: @escaping (Array<String>) -> Void) {
        var producerNameData:Array<String> = []
        var val = 0
        for producer in song.producers {
            let word = producer.split(separator: "Æ")
            let id = word[0]
            DatabaseManager.shared.fetchPersonData(person: String(id), completion: { result in
                switch result {
                case .success(let selectedProducer):
                    producerNameData.append(selectedProducer.name!)
                    val+=1
                    if val == song.producers.count {
                        completion(producerNameData)
                    }
                case .failure(let err):
                    print("youyouerr", err)
                }
            })
        }
        
    }
    
    func getWriterData(song:AlbumUploadSongData, completion: @escaping (Array<String>?) -> Void) {
        var producerNameData:Array<String> = []
        var producerimageURLs:Array<String> = []
        var val = 0
        if let engie = song.writers {
            if !engie.isEmpty {
                for producer in engie {
                    let word = producer.split(separator: "Æ")
                    let id = word[0]
                    DatabaseManager.shared.fetchPersonData(person: String(id), completion: { result in
                        switch result {
                        case .success(let selectedProducer):
                            producerNameData.append(selectedProducer.name!)
                            val+=1
                            if val == engie.count {
                                completion(producerNameData)
                            }
                        case .failure(let err):
                            print("youyouerr", err)
                        }
                    })
                }
            } else {
                completion(nil)
            }
        } else {
            completion(nil)
        }
        
    }
    
    func getMixEngineerData(song:AlbumUploadSongData, completion: @escaping (Array<String>?) -> Void) {
        var producerNameData:Array<String> = []
        var producerimageURLs:Array<String> = []
        var val = 0
        if let engie = song.mixEngineers {
            if !engie.isEmpty {
                for producer in engie {
                    let word = producer.split(separator: "Æ")
                    let id = word[0]
                    DatabaseManager.shared.fetchPersonData(person: String(id), completion: { result in
                        switch result {
                        case .success(let selectedProducer):
                            producerNameData.append(selectedProducer.name!)
                            val+=1
                            if val == engie.count {
                                completion(producerNameData)
                            }
                        case .failure(let err):
                            print("youyouerr", err)
                        }
                    })
                }
            } else {
                completion(nil)
            }
        } else {
            completion(nil)
        }
        
    }
    
    func getMasteringEngineerData(song:AlbumUploadSongData, completion: @escaping (Array<String>?) -> Void) {
        var producerNameData:Array<String> = []
        var producerimageURLs:Array<String> = []
        var val = 0
        if let engie = song.masteringEngineers {
            if !engie.isEmpty {
                for producer in engie {
                    let word = producer.split(separator: "Æ")
                    let id = word[0]
                    DatabaseManager.shared.fetchPersonData(person: String(id), completion: { result in
                        switch result {
                        case .success(let selectedProducer):
                            producerNameData.append(selectedProducer.name!)
                            val+=1
                            if val == engie.count {
                                completion(producerNameData)
                            }
                        case .failure(let err):
                            print("youyouerr", err)
                        }
                    })
                }
            } else {
                completion(nil)
            }
        } else {
            completion(nil)
        }
        
    }
    
    func getRecordingEngineerData(song:AlbumUploadSongData, completion: @escaping (Array<String>?) -> Void) {
        var producerNameData:Array<String> = []
        var producerimageURLs:Array<String> = []
        var val = 0
        if let engie = song.recordingEngineers {
            if !engie.isEmpty {
                for producer in engie {
                    let word = producer.split(separator: "Æ")
                    let id = word[0]
                    DatabaseManager.shared.fetchPersonData(person: String(id), completion: { result in
                        switch result {
                        case .success(let selectedProducer):
                            producerNameData.append(selectedProducer.name!)
                            val+=1
                            if val == engie.count {
                                completion(producerNameData)
                            }
                        case .failure(let err):
                            print("youyouerr", err)
                        }
                    })
                }
            } else {
                completion(nil)
            }
        } else {
            completion(nil)
        }
        
    }
}

class AlbumUploadAddNewSongTableCellController: UITableViewCell {
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func funcSetTemp() {
        
    }
}

extension AlbumUploadViewController: UITextFieldDelegate {
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        switch textField {
        case mainArtistTextField:
            mainArtist = []
            mainArtistsNames = []
            return true
        case deluxeOfTextField:
            deluxeOf = nil
            deluxeHold = nil
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
        case mainArtistTextField:
            personPickerView.selectRow(0, inComponent: 0, animated: false)
            chosenArtist = AllPersonsInDatabaseArray[0].toneDeafAppId.trimmingCharacters(in: .whitespacesAndNewlines)
            chosenArtistNames = AllPersonsInDatabaseArray[0].name!.trimmingCharacters(in: .whitespacesAndNewlines)
        default:
            break
        }
    }
}

extension AlbumUploadViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        var noc = 0
        if pickerView == personPickerView || pickerView == verificationLevelPickerView || pickerView == deluxeOfPickerView || pickerView == otherVersionsOfPickerView {
            noc = 1
        } else {
            noc = 2
        }
        return noc
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        var nor = 0
        if pickerView == personPickerView {
            nor = AllPersonsInDatabaseArray.count
        }
        if pickerView == songsPickerView {
            if component == 0 {
                nor = AllSongsInDatabaseArray.count
            }
            else {
                nor = numbers.count
            }
        }
        if pickerView == instrumentalsPickerView {
            if component == 0 {
                nor = AllInstrumentalsInDatabaseArray.count
            }
            else {
                nor = numbers.count
            }
        }
        if pickerView == verificationLevelPickerView {
            nor = verificationLevelArr.count
        }
        if pickerView == deluxeOfPickerView {
            nor = AllAlbumsInDatabaseArray.count
        }
        if pickerView == otherVersionsOfPickerView {
            nor = AllAlbumsInDatabaseArray.count
        }
        return nor
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        var nor:String!
        if pickerView == personPickerView {
           nor = "\(AllPersonsInDatabaseArray[row].name ?? "person") -- \(AllPersonsInDatabaseArray[row].toneDeafAppId)"
        }
        if pickerView == songsPickerView {
            if component == 0 {
                nor = "\(AllSongsInDatabaseArray[row].name) -- \(AllSongsInDatabaseArray[row].toneDeafAppId)"
            } else {
                nor = String(numbers[row])
            }
        }
        if pickerView == instrumentalsPickerView {
            if component == 0 {
                nor = "\(AllInstrumentalsInDatabaseArray[row].songName!) -- \(AllInstrumentalsInDatabaseArray[row].toneDeafAppId)"
            } else {
                nor = String(numbers[row])
            }
        }
        if pickerView == verificationLevelPickerView {
            nor = String(verificationLevelArr[row])
        }
        if pickerView == deluxeOfPickerView {
            if component == 0 {
                nor = "\(AllAlbumsInDatabaseArray[row].name) -- \(AllAlbumsInDatabaseArray[row].toneDeafAppId)"
            }
        }
        if pickerView == otherVersionsOfPickerView {
            if component == 0 {
                nor = "\(AllAlbumsInDatabaseArray[row].name) -- \(AllAlbumsInDatabaseArray[row].toneDeafAppId)"
            }
        }
        return nor
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == personPickerView {
            chosenArtist = AllPersonsInDatabaseArray[row].toneDeafAppId.trimmingCharacters(in: .whitespacesAndNewlines)
            chosenArtistNames = AllPersonsInDatabaseArray[row].name!.trimmingCharacters(in: .whitespacesAndNewlines)
        }
        if pickerView == songsPickerView {
            if component == 0 {
                chosenSong = AllSongsInDatabaseArray[row].toneDeafAppId.trimmingCharacters(in: .whitespacesAndNewlines)
                chosenSongName = AllSongsInDatabaseArray[row].name.trimmingCharacters(in: .whitespacesAndNewlines)
            } else {
                chosenTrackNumber = String(numbers[row])
            }
        }
        if pickerView == instrumentalsPickerView {
            if component == 0 {
                chosenSong = AllInstrumentalsInDatabaseArray[row].toneDeafAppId.trimmingCharacters(in: .whitespacesAndNewlines)
                chosenSongName = AllInstrumentalsInDatabaseArray[row].songName!.trimmingCharacters(in: .whitespacesAndNewlines)
            } else {
                chosenTrackNumber = String(numbers[row])
            }
        }
        if pickerView == verificationLevelPickerView {
            verificationLevelTextField.text = String(verificationLevelArr[row])
            verificationLevel = verificationLevelArr[row]
        }
        if pickerView == deluxeOfPickerView {
            deluxeHold = [AllAlbumsInDatabaseArray[row].toneDeafAppId, AllAlbumsInDatabaseArray[row].name]
        }
        if pickerView == otherVersionsOfPickerView {
            otherVersionsHold = [AllAlbumsInDatabaseArray[row].toneDeafAppId, AllAlbumsInDatabaseArray[row].name]
        }
    }
    
    func pickerViewToolbar(textField:UITextField, pickerView:UIPickerView) {
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor.init(red: 182/255, green: 0/255, blue: 3/255, alpha: 1)
        toolBar.sizeToFit()

        var doneButton = UIBarButtonItem()
        if pickerView == personPickerView {
           doneButton = UIBarButtonItem(title: "Add", style: UIBarButtonItem.Style.done, target: self, action: #selector(dismissKeyboard2))
        }
        if pickerView == songsPickerView {
           doneButton = UIBarButtonItem(title: "Add", style: UIBarButtonItem.Style.done, target: self, action: #selector(dismissKeyboard3))
        }
        if pickerView == instrumentalsPickerView {
           doneButton = UIBarButtonItem(title: "Add", style: UIBarButtonItem.Style.done, target: self, action: #selector(dismissKeyboard3))
        }
        if pickerView == verificationLevelPickerView {
            doneButton = UIBarButtonItem(title: "Select", style: UIBarButtonItem.Style.done, target: self, action: #selector(dismissKeyboard))
        }
        if pickerView == deluxeOfPickerView {
            doneButton = UIBarButtonItem(title: "Select", style: UIBarButtonItem.Style.done, target: self, action: #selector(dismissKeyboard4))
        }
        if pickerView == otherVersionsOfPickerView {
            doneButton = UIBarButtonItem(title: "Select", style: UIBarButtonItem.Style.done, target: self, action: #selector(dismissKeyboard5))
        }
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItem.Style.plain, target: self, action: #selector(dismissKeyboard))

        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true

        textField.inputView = pickerView
        textField.inputAccessoryView = toolBar
    }
}

extension Dictionary {
    mutating func update(other:Dictionary) {
        for (key,value) in other {
            self.updateValue(value, forKey:key)
        }
    }
}


public enum AlbumUploadTextFieldErrors: Error {
    case invalidURL
}


