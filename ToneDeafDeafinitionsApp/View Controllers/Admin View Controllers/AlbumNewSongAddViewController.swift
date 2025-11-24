//
//  AlbumNewSongAddViewController.swift
//  ToneDeafDeafinitionsApp
//
//  Created by Tone Deaf on 9/6/20.
//  Copyright © 2020 GITEM Solutions. All rights reserved.
//

import UIKit
import BEMCheckBox

var updateIndex = 100000

class AlbumNewSongAddViewController: UIViewController {

    var songArtists:Array<String> = []
    var songArtistsNames:[String] = []
    var songProducers:Array<String> = []
    var songProducerNames:[String] = []
    var songWriters:Array<String> = []
    var songWriterNames:[String] = []
    var songMixEngineers:Array<String> = []
    var songMixEngineerNames:[String] = []
    var songMasteringEngineers:Array<String> = []
    var songMasterEngineerNames:[String] = []
    var songRecordingEngineers:Array<String> = []
    var songRecordingEngineerNames:[String] = []
    var youtubeAltURLs:[String] = []
    var chosenArtist = ""
    var chosenArtistNames = ""
    var chosenProducer = ""
    var chosenProducerNames = ""
    var chosenWriter = ""
    var chosenWriterNames = ""
    var chosenMixEng = ""
    var chosenMixEngNames = ""
    var chosenMasterEng = ""
    var chosenMasterEngNames = ""
    var chosenRecEng = ""
    var chosenRecEngNames = ""
    var chosenInstrumentalSong = ""
    var chosenInstrumentalSongNames = ""
    var songForInstrumental:Array<String> = []
    var songForInstrumentalNames:[String] = []
    var unselectedTrackNumbers:[Int] = []
    
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
    
    var personPickerView = UIPickerView()
    var trackNumberPickerView = UIPickerView()
    var albumSongsPickerView = UIPickerView()
    var allsongsPickerView = UIPickerView()
    var remixOfPickerView = UIPickerView()
    var otherVersionsOfPickerView = UIPickerView()
    var loadcount = 0
    var artistEditing = false
    
    var verificationLevelPickerView = UIPickerView()
    var verificationLevelArr:[Character] = Constants.Verification.verificationLevels
    var verificationLevel:Character!
    
    var industryCertified:Bool = false
    var explicit:Bool = false
    
    var remixAlbum = false
    var remixOf:String!
    var remixHold:[String]!
    var otherVersionsAlbum = false
    var otherVersionsOf:String!
    var otherVersionsHold:[String]!
    
    let song = AlbumUploadSongData(name: "", trackNumber: "", toneDeafAppId: "", artists: [], producers: [], writers: nil, mixEngineers: nil, masteringEngineers: nil, recordingEngineers: nil, youtubeOfficialVideoURL: "", youTubeAudioVideoURL: "", youtubeAltVideoURLs: [""], spotifyURL: "", appleMusicURL: "", soundcloudURL: nil, youtubeMusicURL: nil, amazonMusicURL: nil, deezerURL: nil, tidalURL: nil, spinrillaURL: nil, napsterURL: nil, instrumental: "", songsForinstrumental: [], industryCerified: nil, verificationLevel: nil, isActive: false, explicit: nil, isRemix: nil, isOtherVersion: nil)
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var instrumentalCheckBox: BEMCheckBox!
    @IBOutlet weak var forSongInstrumentalCheckBox: BEMCheckBox!
    @IBOutlet weak var onAlbumInstrumentalCheckBox: BEMCheckBox!
    @IBOutlet weak var forSongInstrumentalStack: UIStackView!
    @IBOutlet weak var onAlbumStack: UIStackView!
    @IBOutlet weak var forSongTextField: UITextField!
    @IBOutlet weak var onAlbumTextField: UITextField!
    @IBOutlet weak var songNameTextField: UITextField! {
        didSet {
            let placeholderText = NSAttributedString(string: "Name",
                                                     attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray.withAlphaComponent(0.4)])
            
            songNameTextField.attributedPlaceholder = placeholderText
        }
    }
    @IBOutlet weak var artistTextField: UITextField! {
        didSet {
            let placeholderText = NSAttributedString(string: "Artist(s)",
                                                     attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray.withAlphaComponent(0.4)])
            
            artistTextField.attributedPlaceholder = placeholderText
        }
    }
    @IBOutlet weak var trackNumberTexfield: UITextField! {
        didSet {
            let placeholderText = NSAttributedString(string: "Track Number",
                                                     attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray.withAlphaComponent(0.4)])
            
            trackNumberTexfield.attributedPlaceholder = placeholderText
        }
    }
    @IBOutlet weak var producerTextField: UITextField! {
        didSet {
            let placeholderText = NSAttributedString(string: "Producer(s)",
                                                     attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray.withAlphaComponent(0.4)])
            
            producerTextField.attributedPlaceholder = placeholderText
        }
    }
    @IBOutlet weak var writerTextField: UITextField! {
        didSet {
            let placeholderText = NSAttributedString(string: "Writer(s)",
                                                     attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray.withAlphaComponent(0.4)])
            
            writerTextField.attributedPlaceholder = placeholderText
        }
    }
    @IBOutlet weak var writerStack: UIStackView!
    @IBOutlet weak var mixEngineerTextField: UITextField! {
        didSet {
            let placeholderText = NSAttributedString(string: "Mix Engineers(s)",
                                                     attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray.withAlphaComponent(0.4)])
            
            mixEngineerTextField.attributedPlaceholder = placeholderText
        }
    }
    @IBOutlet weak var masteringEngineerTextField: UITextField! {
        didSet {
            let placeholderText = NSAttributedString(string: "Mastering Engineer(s)",
                                                     attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray.withAlphaComponent(0.4)])
            
            masteringEngineerTextField.attributedPlaceholder = placeholderText
        }
    }
    @IBOutlet weak var recordingEngineerTextField: UITextField! {
        didSet {
            let placeholderText = NSAttributedString(string: "Recording Engineer(s)",
                                                     attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray.withAlphaComponent(0.4)])
            
            recordingEngineerTextField.attributedPlaceholder = placeholderText
        }
    }
    @IBOutlet weak var recordingEngineerStack: UIStackView!
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
    @IBOutlet weak var napsterTextField: UITextField! {
        didSet {
            let placeholderText = NSAttributedString(string: "URL",
                                                     attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray.withAlphaComponent(0.4)])
            
            napsterTextField.attributedPlaceholder = placeholderText
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
    @IBOutlet weak var explicitControl: UISegmentedControl!
    @IBOutlet weak var explicitStack: UIStackView!
    @IBOutlet weak var addSongButton: UIButton!
    @IBOutlet weak var updateSongButton: UIButton!
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUnselectedTrackNumbers()
        dismissKeyboardOnTap()
        setUpElements()
//       // call the 'keyboardWillShow' function when the view controller receive the notification that a keyboard is going to be shown
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
      
          // call the 'keyboardWillHide' function when the view controlelr receive notification that keyboard is going to be hidden
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        loadcount+=1
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
    
    func setUnselectedTrackNumbers() {
        if albumUploadSongsArray.isEmpty {
            unselectedTrackNumbers = Array(1...35)
            return
        }
        for num in 1...35 {
            for songr in albumUploadSongsArray {
                if songr.trackNumber != num && Int(song.trackNumber) != num {
                    unselectedTrackNumbers.append(num)
                }
            }
        }
    }

    func setUpElements() {
        creatObservers()
        Utilities.styleTextField(spotifyTextField)
        Utilities.styleTextField(songNameTextField)
        Utilities.styleTextField(artistTextField)
        Utilities.styleTextField(producerTextField)
        Utilities.styleTextField(writerTextField)
        Utilities.styleTextField(mixEngineerTextField)
        Utilities.styleTextField(masteringEngineerTextField)
        Utilities.styleTextField(recordingEngineerTextField)
        Utilities.styleTextField(appleMusicTextField)
        Utilities.styleTextField(souncloudTextField)
        Utilities.styleTextField(youtubeMusicTextField)
        Utilities.styleTextField(amazonTextField)
        Utilities.styleTextField(deezerTextField)
        Utilities.styleTextField(tidalTextField)
        Utilities.styleTextField(spinrillaTextField)
        Utilities.styleTextField(trackNumberTexfield)
        Utilities.styleTextField(forSongTextField)
        Utilities.styleTextField(onAlbumTextField)
        Utilities.styleTextField(napsterTextField)
        addBottomLineToText(trackNumberTexfield)
        addBottomLineToText(spotifyTextField)
        addBottomLineToText(artistTextField)
        addBottomLineToText(producerTextField)
        addBottomLineToText(writerTextField)
        addBottomLineToText(mixEngineerTextField)
        addBottomLineToText(masteringEngineerTextField)
        addBottomLineToText(recordingEngineerTextField)
        addBottomLineToText(songNameTextField)
        addBottomLineToText(appleMusicTextField)
        addBottomLineToText(souncloudTextField)
        addBottomLineToText(youtubeMusicTextField)
        addBottomLineToText(amazonTextField)
        addBottomLineToText(deezerTextField)
        addBottomLineToText(tidalTextField)
        addBottomLineToText(spinrillaTextField)
        addBottomLineToText(forSongTextField)
        addBottomLineToText(onAlbumTextField)
        addBottomLineToText(napsterTextField)
        spotifyTextField.delegate = self
        artistTextField.delegate = self
        appleMusicTextField.delegate = self
        songNameTextField.delegate = self
        souncloudTextField.delegate = self
        youtubeMusicTextField.delegate = self
        amazonTextField.delegate = self
        deezerTextField.delegate = self
        tidalTextField.delegate = self
        napsterTextField.delegate = self
        spinrillaTextField.delegate = self
        producerTextField.delegate = self
        writerTextField.delegate = self
        mixEngineerTextField.delegate = self
        masteringEngineerTextField.delegate = self
        recordingEngineerTextField.delegate = self
        trackNumberTexfield.delegate = self
        onAlbumTextField.delegate = self
        forSongTextField.delegate = self
        napsterTextField.delegate = self
        
        Utilities.styleTextField(verificationLevelTextField)
        addBottomLineToText(verificationLevelTextField)
        verificationLevelTextField.delegate = self
        
        Utilities.styleTextField(remixOfTextField)
        addBottomLineToText(remixOfTextField)
        remixOfTextField.delegate = self
        
        Utilities.styleTextField(otherVersionsOfTextField)
        addBottomLineToText(otherVersionsOfTextField)
        otherVersionsOfTextField.delegate = self
        
        artistTextField.inputView = personPickerView
        personPickerView.delegate = self
        personPickerView.dataSource = self
        pickerViewToolbar(textField: artistTextField, pickerView: personPickerView)
        artistTextField.delegate = self
        
        producerTextField.inputView = personPickerView
        personPickerView.delegate = self
        personPickerView.dataSource = self
        pickerViewToolbar(textField: producerTextField, pickerView: personPickerView)
        producerTextField.delegate = self
        
        writerTextField.inputView = personPickerView
        personPickerView.delegate = self
        personPickerView.dataSource = self
        pickerViewToolbar(textField: writerTextField, pickerView: personPickerView)
        writerTextField.delegate = self
        
        mixEngineerTextField.inputView = personPickerView
        personPickerView.delegate = self
        personPickerView.dataSource = self
        pickerViewToolbar(textField: mixEngineerTextField, pickerView: personPickerView)
        mixEngineerTextField.delegate = self
        
        masteringEngineerTextField.inputView = personPickerView
        personPickerView.delegate = self
        personPickerView.dataSource = self
        pickerViewToolbar(textField: masteringEngineerTextField, pickerView: personPickerView)
        masteringEngineerTextField.delegate = self
        
        recordingEngineerTextField.inputView = personPickerView
        personPickerView.delegate = self
        personPickerView.dataSource = self
        pickerViewToolbar(textField: recordingEngineerTextField, pickerView: personPickerView)
        recordingEngineerTextField.delegate = self
        
        verificationLevelTextField.inputView = verificationLevelPickerView
        verificationLevelPickerView.delegate = self
        verificationLevelPickerView.dataSource = self
        pickerViewToolbar(textField: verificationLevelTextField, pickerView: verificationLevelPickerView)
        textFieldShouldClear(verificationLevelTextField)
        
        remixOfTextField.inputView = remixOfPickerView
        remixOfPickerView.delegate = self
        remixOfPickerView.dataSource = self
        pickerViewToolbar(textField: remixOfTextField, pickerView: remixOfPickerView)
        remixOfTextField.delegate = self
        
        otherVersionsOfTextField.inputView = otherVersionsOfPickerView
        otherVersionsOfPickerView.delegate = self
        otherVersionsOfPickerView.dataSource = self
        pickerViewToolbar(textField: otherVersionsOfTextField, pickerView: otherVersionsOfPickerView)
        otherVersionsOfTextField.delegate = self
        
        trackNumberTexfield.inputView = trackNumberPickerView
        trackNumberPickerView.delegate = self
        trackNumberPickerView.dataSource = self
        pickerViewToolbar(textField: trackNumberTexfield, pickerView: trackNumberPickerView)
        trackNumberTexfield.delegate = self
        forSongTextField.delegate = self
        onAlbumTextField.delegate = self
        artistTextField.delegate = self
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
        print("📗 Album song Upload being deallocated from memory. OS reclaiming")
    }
    
    func creatObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(songEdit(notification:)), name: EditAlbumSongUploadNotify, object: nil)
    }
    
    @objc func songEdit(notification: Notification) {
        let array = notification.object as! [Any]
        updateIndex = array[0] as! Int
        let son = array[1] as! AlbumSong
        let song = son.song as! AlbumUploadSongData
        updateSongButton.isHidden = false
        addSongButton.isHidden = true
        songNameTextField.text = song.name
        getArtistData(song: song, completion: {[weak self] artistnames in
            guard let strongSelf = self else {return}
            strongSelf.artistTextField.text = artistnames.joined(separator: ", ")
        })
        getProducerData(song: song, completion: {[weak self] producerNames in
            guard let strongSelf = self else {return}
            strongSelf.producerTextField.text = "\(producerNames.joined(separator: ", "))"
        })
        getWriterData(song: song, completion: {[weak self] writerNames in
            guard let strongSelf = self else {return}
            if let names = writerNames {
                strongSelf.writerTextField.text = "\(names.joined(separator: ", "))"
            }
        })
        getMixEngineerData(song: song, completion: {[weak self] mixEngineerNames in
            guard let strongSelf = self else {return}
            if let names = mixEngineerNames {
                strongSelf.mixEngineerTextField.text = "\(names.joined(separator: ", "))"
            }
        })
        getMasteringEngineerData(song: song, completion: {[weak self] masteringEngineerNames in
            guard let strongSelf = self else {return}
            if let names = masteringEngineerNames {
                strongSelf.masteringEngineerTextField.text = "\(names.joined(separator: ", "))"
            }
        })
        getRecordingEngineerData(song: song, completion: {[weak self] recordingEngineerNames in
            guard let strongSelf = self else {return}
            if let names = recordingEngineerNames {
                strongSelf.recordingEngineerTextField.text = "\(names.joined(separator: ", "))"
            }
        })
        spotifyTextField.text = song.spotifyURL
        appleMusicTextField.text = song.appleMusicURL
        souncloudTextField.text = song.soundcloudURL
        deezerTextField.text = song.deezerURL
        tidalTextField.text = song.tidalURL
        youtubeMusicTextField.text = song.youtubeMusicURL
        amazonTextField.text = song.amazonMusicURL
        spinrillaTextField.text = song.spinrillaURL
        trackNumberTexfield.text = String(son.trackNumber)
        verificationLevelTextField.text = String(song.verificationLevel!)
        industryCertificationControl.selectedSegmentIndex = song.industryCerified!.intValue
        songArtists = song.artists
        songProducers = song.producers
        if let arr = song.writers {
            songWriters = arr
        }
        if let arr = song.mixEngineers {
            songMixEngineers = arr
        }
        if let arr = song.masteringEngineers {
            songMasteringEngineers = arr
        }
        if let arr = song.recordingEngineers {
            songRecordingEngineers = arr
        }
    }
    
    func getArtistData(song:AlbumUploadSongData, completion: @escaping (Array<String>) -> Void) {
        var artistNameData:Array<String> = []
        var val = 0
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
    
    func getProducerData(song:AlbumUploadSongData, completion: @escaping (Array<String>) -> Void) {
        var producerNameData:Array<String> = []
        var producerimageURLs:Array<String> = []
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
        for producer in engie {
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
        } else {
            completion(nil)
        }
        
    }
    
    func getMixEngineerData(song:AlbumUploadSongData, completion: @escaping (Array<String>?) -> Void) {
        var producerNameData:Array<String> = []
        var producerimageURLs:Array<String> = []
        var val = 0
        if let engie = song.mixEngineers {
            for producer in engie {
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
        } else {
            completion(nil)
        }
        
    }
    
    func getMasteringEngineerData(song:AlbumUploadSongData, completion: @escaping (Array<String>?) -> Void) {
        var producerNameData:Array<String> = []
        var producerimageURLs:Array<String> = []
        var val = 0
        if let engie = song.masteringEngineers {
        for producer in engie {
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
        } else {
            completion(nil)
        }
        
    }
    
    func getRecordingEngineerData(song:AlbumUploadSongData, completion: @escaping (Array<String>?) -> Void) {
        var producerNameData:Array<String> = []
        var producerimageURLs:Array<String> = []
        var val = 0
        if let engie = song.recordingEngineers {
            for producer in engie {
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
        } else {
            completion(nil)
        }
        
    }
    
    @IBAction func mainArtistTapped(_ sender: Any) {
        
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
            song.isRemix = SongRemixData(standardEdition: nil, status: true)
            remixOfStackView.isHidden = false
            //true
        } else {
            remixControl.selectedSegmentTintColor = Constants.Colors.redApp
            song.isRemix = nil
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
            song.isOtherVersion = SongOtherVersionData(standardEdition: nil, status: true)
            otherVersionsOfStackView.isHidden = false
            //true
        } else {
            otherVersionsControl.selectedSegmentTintColor = Constants.Colors.redApp
            song.isOtherVersion = nil
            otherVersionsOf = nil
            otherVersionsOfTextField.text = ""
            //false
            otherVersionsOfStackView.isHidden = true
        }
    }
    
    @IBAction func instrumentalCheckBoxTapped(_ sender: BEMCheckBox) {
        if sender.on {
            forSongInstrumentalStack.isHidden = false
            forSongTextField.isHidden = false
            forSongTextField.alpha = 0
            explicit = false
            explicitControl.selectedSegmentIndex = 0
            explicitControl.selectedSegmentTintColor = Constants.Colors.redApp
            explicitStack.isHidden = true
            
            writerStack.isHidden = true
            recordingEngineerStack.isHidden = true
        }
        if !sender.on {
            forSongInstrumentalStack.isHidden = true
            explicitStack.isHidden = false
            writerStack.isHidden = false
            recordingEngineerStack.isHidden = false
        }
    }
    @IBAction func forSongInstrumentalCheckBox(_ sender: BEMCheckBox) {
        if sender.on {
            if !albumUploadSongsArray.isEmpty {
                onAlbumStack.isHidden = false
                onAlbumTextField.alpha = 0
            }
        }
        if !sender.on {
            onAlbumStack.isHidden = true
        }
    }
    @IBAction func onAlbumCheckbox(_ sender: BEMCheckBox) {
    }
    
    @IBAction func updateSongButtonTapped(_ sender: Any) {
        updateSong()
    }
    
    @IBAction func addSongButtonTapped(_ sender: Any) {
        addSong()
            
//        else {
//            generateAppId()
//        }
    }
    
    func updateSong() {
        
        if forSongInstrumentalCheckBox.on && !onAlbumInstrumentalCheckBox.on && songForInstrumental == [] {
            if songForInstrumental.isEmpty {
                forSongTextField.inputView = allsongsPickerView
                allsongsPickerView.delegate = self
                allsongsPickerView.dataSource = self
                pickerViewToolbar(textField: forSongTextField, pickerView: allsongsPickerView)
                forSongTextField.becomeFirstResponder()
            } else {
                addInstrumentalSongActionSheet()
            }
        } else if forSongInstrumentalCheckBox.on && onAlbumInstrumentalCheckBox.on && songForInstrumental == [] {
            
            if songForInstrumental.isEmpty {
                onAlbumTextField.inputView = albumSongsPickerView
                albumSongsPickerView.delegate = self
                albumSongsPickerView.dataSource = self
                pickerViewToolbar(textField: onAlbumTextField, pickerView: albumSongsPickerView)
                onAlbumTextField.becomeFirstResponder()
            } else {
                addInstrumentalSongActionSheet()
            }
        }
        if instrumentalCheckBox.on && !forSongInstrumentalCheckBox.on && song.instrumental == ""{
            generateInstrumentalAppId()
        }
    }
    
    func addSong() {
        
        if forSongInstrumentalCheckBox.on && !onAlbumInstrumentalCheckBox.on {
            if songForInstrumental.isEmpty {
                forSongTextField.inputView = allsongsPickerView
                allsongsPickerView.delegate = self
                allsongsPickerView.dataSource = self
                pickerViewToolbar(textField: forSongTextField, pickerView: allsongsPickerView)
                forSongTextField.becomeFirstResponder()
            } else {
                addInstrumentalSongActionSheet()
            }
        } else if onAlbumInstrumentalCheckBox.on {
            
            if songForInstrumental.isEmpty {
                print(albumUploadSongsArray.count)
                onAlbumTextField.inputView = albumSongsPickerView
                albumSongsPickerView.delegate = self
                albumSongsPickerView.dataSource = self
                pickerViewToolbar(textField: onAlbumTextField, pickerView: albumSongsPickerView)
                onAlbumTextField.becomeFirstResponder()
            } else {
                addInstrumentalSongActionSheet()
            }
        } else if instrumentalCheckBox.on && !forSongInstrumentalCheckBox.on {
            generateInstrumentalAppId()
        } else {
            generateAppId()
        }
    }
    
    func generateAppId() {
        let genid = StorageManager.shared.generateRandomNumber(digits: 10)
        DatabaseManager.shared.checkIfAppIdExists(appid: genid, completion: { [weak self] result in
            guard let strongSelf = self else {return}
            if result == true {
                strongSelf.generateAppId()
            } else {
                strongSelf.song.toneDeafAppId = genid
                strongSelf.gatherUploadData()
            }
        })
    }
    
    func generateInstrumentalAppId() {
        let genid = StorageManager.shared.generateRandomNumber(digits: 12)
        DatabaseManager.shared.checkIfAppIdExists(appid: genid, completion: { [weak self] result in
            guard let strongSelf = self else {return}
            if result == true {
                strongSelf.generateAppId()
            } else {
                strongSelf.song.instrumental = genid
                strongSelf.gatherUploadData()
            }
        })
    }
    
    func gatherUploadData() {
        
        guard songNameTextField.text != "" else {
            Utilities.showError2("Song name required"  ,actionText: "Ok")
            return
        }
//        guard artistTextField.text != "" else {
//            Utilities.showError2("Song artists required"  ,actionText: "Ok")
//            return
//        }
        guard producerTextField.text != "" else {
            Utilities.showError2("Song producer required."  ,actionText: "Ok")
            return
        }
        guard trackNumberTexfield.text != "" else {
            Utilities.showError2("Track number required."  ,actionText: "Ok")
            return
        }
        guard verificationLevelTextField.text != "" else {
            Utilities.showError2("Verification Level required"  ,actionText: "Ok")
            return
        }
        guard let name = songNameTextField.text else {return}
        guard let tracknumber = trackNumberTexfield.text else {return}
        song.name = name
        song.trackNumber = tracknumber
        song.artists = songArtists
        song.producers = songProducers
        song.writers = songWriters
        song.recordingEngineers = songRecordingEngineers
        if song.instrumental != "" {
            songWriters = []
            songWriterNames = []
            song.writers = nil
            songRecordingEngineers = []
            songRecordingEngineerNames = []
            song.recordingEngineers = nil
            song.isRemix = nil
        }
        song.explicit = explicit
        song.verificationLevel = verificationLevel
        song.industryCerified = industryCertified
        song.mixEngineers = songMixEngineers
        song.masteringEngineers = songMasteringEngineers
        let queue = DispatchQueue(label: "myhjlukjhgkjkvkhQueue")
        let group = DispatchGroup()
        let array = [4, 5,6,7,8,9,10,11,12]

        for i in array {
            //print(i)
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
            if strongSelf.uploadCompletionStatus4 != false && strongSelf.uploadCompletionStatus5 != false && strongSelf.uploadCompletionStatus6 != false && strongSelf.uploadCompletionStatus7 != false && strongSelf.uploadCompletionStatus8 != false && strongSelf.uploadCompletionStatus9 != false && strongSelf.uploadCompletionStatus10 != false && strongSelf.uploadCompletionStatus11 != false && strongSelf.uploadCompletionStatus12 != false {
                NotificationCenter.default.post(name: AlbumNewSongAddedNotify, object: strongSelf.song)
                strongSelf.dismiss(animated: true, completion: nil)
            } else {
                
            }
        }
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
    
    func spotifySong(completion: @escaping ((Bool) -> Void)) {
        DispatchQueue.main.async {[weak self] in
            guard let strongSelf = self else {return}
            guard strongSelf.spotifyTextField.text != "" else {
                completion(true)
                return}
            guard strongSelf.spotifyTextField.text!.count > 15 else {
                Utilities.showError2("Please enter a valid Spotify url..", actionText: "OK")
                completion(false)
                return}
            guard let url = strongSelf.spotifyTextField.text else {
                Utilities.showError2("Spotify url Error.", actionText: "OK")
                completion(false)
                return
            }
            strongSelf.song.spotifyURL = url
            completion(true)
        }
        
    }
    
    func appleMusicSong(completion: @escaping ((Bool) -> Void)) {
        DispatchQueue.main.async {[weak self] in
            guard let strongSelf = self else {return}
            guard strongSelf.appleMusicTextField.text != "" else {
                completion(true)
                return}
            guard strongSelf.appleMusicTextField.text!.count > 15 else {
                Utilities.showError2("Please enter a valid Apple Music url..", actionText: "OK")
                completion(false)
                return}
            guard strongSelf.appleMusicTextField.text!.contains("i=") && strongSelf.appleMusicTextField.text!.contains("music.apple.com") else {
                Utilities.showError2("Please enter a valid Apple Music url..", actionText: "OK")
                completion(false)
                return
            }
            guard let url = strongSelf.appleMusicTextField.text else {
                Utilities.showError2("Apple music url Error.", actionText: "OK")
                completion(false)
                return
            }
            strongSelf.song.appleMusicURL = url
            completion(true)
        }
    }
    
    func soundcloudSong(completion: @escaping ((Bool) -> Void)) {
        DispatchQueue.main.async {[weak self] in
            guard let strongSelf = self else {return}
            guard strongSelf.souncloudTextField.text != "" else {
                completion(true)
                return}
            guard strongSelf.souncloudTextField.text!.count > 15 else {
                Utilities.showError2("Please enter a valid Soundcloud url..", actionText: "OK")
                completion(false)
                return}
            //        guard strongSelf.souncloudTextField.text!.contains("i=") && strongSelf.souncloudTextField.text!.contains("music.apple.com") else {
            //            Utilities.showError2("Please enter a valid Apple Music url..", actionText: "OK")
            //            completion(false)
            //            return
            //        }
            guard let url = strongSelf.souncloudTextField.text else {
                Utilities.showError2("Soundcloud url Error.", actionText: "OK")
                completion(false)
                return
            }
            strongSelf.song.soundcloudURL = url
            completion(true)
        }
    }
    
    func youtubeMusicSong(completion: @escaping ((Bool) -> Void)) {
        DispatchQueue.main.async {[weak self] in
            guard let strongSelf = self else {return}
            guard strongSelf.youtubeMusicTextField.text != "" else {
                completion(true)
                return}
            guard strongSelf.youtubeMusicTextField.text!.count > 15 else {
                Utilities.showError2("Please enter a valid Youtube Music url..", actionText: "OK")
                completion(false)
                return}
            //        guard strongSelf.souncloudTextField.text!.contains("i=") && strongSelf.souncloudTextField.text!.contains("music.apple.com") else {
            //            Utilities.showError2("Please enter a valid Apple Music url..", actionText: "OK")
            //            completion(false)
            //            return
            //        }
            guard let url = strongSelf.youtubeMusicTextField.text else {
                Utilities.showError2("Youtube Music url Error.", actionText: "OK")
                completion(false)
                return
            }
            strongSelf.song.youtubeMusicURL = url
            completion(true)
        }
    }
    
    func amazonSong(completion: @escaping ((Bool) -> Void)) {
        DispatchQueue.main.async {[weak self] in
            guard let strongSelf = self else {return}
            guard strongSelf.amazonTextField.text != "" else {
                completion(true)
                return}
            guard strongSelf.amazonTextField.text!.count > 15 else {
                Utilities.showError2("Please enter a valid Amazon url..", actionText: "OK")
                completion(false)
                return}
            //        guard strongSelf.souncloudTextField.text!.contains("i=") && strongSelf.souncloudTextField.text!.contains("music.apple.com") else {
            //            Utilities.showError2("Please enter a valid Apple Music url..", actionText: "OK")
            //            completion(false)
            //            return
            //        }
            guard let url = strongSelf.amazonTextField.text else {
                Utilities.showError2("Amazon url Error.", actionText: "OK")
                completion(false)
                return
            }
            strongSelf.song.amazonMusicURL = url
            completion(true)
        }
    }
    
    func tidalSong(completion: @escaping ((Bool) -> Void)) {
        DispatchQueue.main.async {[weak self] in
            guard let strongSelf = self else {return}
            guard strongSelf.tidalTextField.text != "" else {
                completion(true)
                return}
            guard strongSelf.tidalTextField.text!.count > 15 else {
                Utilities.showError2("Please enter a valid Tidal url..", actionText: "OK")
                completion(false)
                return}
            //        guard strongSelf.souncloudTextField.text!.contains("i=") && strongSelf.souncloudTextField.text!.contains("music.apple.com") else {
            //            Utilities.showError2("Please enter a valid Apple Music url..", actionText: "OK")
            //            completion(false)
            //            return
            //        }
            guard let url = strongSelf.tidalTextField.text else {
                Utilities.showError2("Tidal url Error.", actionText: "OK")
                completion(false)
                return
            }
            strongSelf.song.tidalURL = url
            completion(true)
        }
    }
    
    func spinrillaSong(completion: @escaping ((Bool) -> Void)) {
        DispatchQueue.main.async {[weak self] in
            guard let strongSelf = self else {return}
            guard strongSelf.spinrillaTextField.text != "" else {
                completion(true)
                return}
            guard strongSelf.spinrillaTextField.text!.count > 15 else {
                Utilities.showError2("Please enter a valid Spinrilla url..", actionText: "OK")
                completion(false)
                return}
            //        guard strongSelf.souncloudTextField.text!.contains("i=") && strongSelf.souncloudTextField.text!.contains("music.apple.com") else {
            //            Utilities.showError2("Please enter a valid Apple Music url..", actionText: "OK")
            //            completion(false)
            //            return
            //        }
            guard let url = strongSelf.spinrillaTextField.text else {
                Utilities.showError2("Spinrilla url Error.", actionText: "OK")
                completion(false)
                return
            }
            strongSelf.song.spinrillaURL = url
            completion(true)
        }
    }
    
    func napsterSong(completion: @escaping ((Bool) -> Void)) {
        DispatchQueue.main.async {[weak self] in
            guard let strongSelf = self else {return}
            guard strongSelf.napsterTextField.text != "" else {
                completion(true)
                return}
            guard strongSelf.napsterTextField.text!.count > 15 else {
                Utilities.showError2("Please enter a valid Napster url..", actionText: "OK")
                completion(false)
                return}
            //        guard strongSelf.souncloudTextField.text!.contains("i=") && strongSelf.souncloudTextField.text!.contains("music.apple.com") else {
            //            Utilities.showError2("Please enter a valid Apple Music url..", actionText: "OK")
            //            completion(false)
            //            return
            //        }
            guard let url = strongSelf.napsterTextField.text else {
                Utilities.showError2("Napster url Error.", actionText: "OK")
                completion(false)
                return
            }
            strongSelf.song.napsterURL = url
            completion(true)
        }
    }
    
    func deezerSong(completion: @escaping ((Bool) -> Void)) {
        DispatchQueue.main.async {[weak self] in
            guard let strongSelf = self else {return}
            guard strongSelf.deezerTextField.text != "" else {
                completion(true)
                return}
            guard strongSelf.deezerTextField.text!.count > 15 else {
                Utilities.showError2("Please enter a valid Deezer url..", actionText: "OK")
                completion(false)
                return}
            guard strongSelf.deezerTextField.text!.contains("track/") && strongSelf.deezerTextField.text!.contains("deezer.com") else {
                    Utilities.showError2("Please enter a valid Deezer url..", actionText: "OK")
                    completion(false)
                    return
                }
            guard let url = strongSelf.deezerTextField.text else {
                Utilities.showError2("Deezer url Error.", actionText: "OK")
                completion(false)
                return
            }
            strongSelf.song.deezerURL = url
            completion(true)
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
        chosenArtist = ""
        chosenArtistNames = ""
        chosenProducer = ""
        chosenProducerNames = ""
        chosenWriter = ""
        chosenWriterNames = ""
        chosenMixEng = ""
        chosenMixEngNames = ""
        chosenMasterEng = ""
        chosenMasterEngNames = ""
        chosenRecEng = ""
        chosenRecEngNames = ""
        chosenInstrumentalSong = ""
        chosenInstrumentalSongNames = ""
        artistEditing = false
        view.endEditing(true)
    }
    
    @objc func dismissKeyboard2() {
        if songArtists.indices.contains(0) == true {
            if songArtists[0] == "" {
                songArtists = []
                songArtistsNames = []
            }
        }
        if chosenArtist != "" {
            songArtists.append("\(chosenArtist.trimmingCharacters(in: .whitespacesAndNewlines))")
            songArtistsNames.append(chosenArtistNames.trimmingCharacters(in: .whitespacesAndNewlines))
            artistTextField.text = songArtistsNames.joined(separator: ", ")
        }
        artistEditing = false
        view.endEditing(true)
    }
    
    @objc func dismissKeyboard3() {
        if songProducers.indices.contains(0) == true {
            if songProducers[0] == "" {
                songProducers = []
                songProducerNames = []
            }
        }
        if chosenProducer != "" {
            songProducers.append("\(chosenProducer.trimmingCharacters(in: .whitespacesAndNewlines))")
            songProducerNames.append(chosenProducerNames.trimmingCharacters(in: .whitespacesAndNewlines))
            producerTextField.text = songProducerNames.joined(separator: ", ")
        }
        view.endEditing(true)
    }
    
    @objc func dismissKeyboard4() {
        if chosenInstrumentalSong != "" {
            songForInstrumental.append("\(chosenInstrumentalSong.trimmingCharacters(in: .whitespacesAndNewlines))")
            songForInstrumentalNames.append(chosenInstrumentalSongNames.trimmingCharacters(in: .whitespacesAndNewlines))
            song.songsForinstrumental = songForInstrumental
            if forSongInstrumentalCheckBox.on && !onAlbumInstrumentalCheckBox.on {
                forSongTextField.alpha = 1
                forSongTextField.text = songForInstrumentalNames.joined(separator: ", ")
            } else
            if forSongInstrumentalCheckBox.on && onAlbumInstrumentalCheckBox.on {
                onAlbumTextField.alpha = 1
                onAlbumTextField.text = songForInstrumentalNames.joined(separator: ", ")
            }
            addInstrumentalSongActionSheet()
        }
        view.endEditing(true)
    }
    
    @objc func dismissKeyboard5() {
        setUnselectedTrackNumbers()
        view.endEditing(true)
    }
    
    @objc func dismissKeyboard6() {
        if songWriters.indices.contains(0) == true {
            if songWriters[0] == "" {
                songWriters = []
                songWriterNames = []
            }
        }
        if chosenWriter != "" {
            songWriters.append("\(chosenWriter.trimmingCharacters(in: .whitespacesAndNewlines))")
            songWriterNames.append(chosenWriterNames.trimmingCharacters(in: .whitespacesAndNewlines))
            writerTextField.text = songWriterNames.joined(separator: ", ")
        }
        view.endEditing(true)
    }
    
    @objc func dismissKeyboard7() {
        if songMixEngineers.indices.contains(0) == true {
            if songMixEngineers[0] == "" {
                songMixEngineers = []
                songMixEngineerNames = []
            }
        }
        if chosenMixEng != "" {
            songMixEngineers.append("\(chosenMixEng.trimmingCharacters(in: .whitespacesAndNewlines))")
            songMixEngineerNames.append(chosenMixEngNames.trimmingCharacters(in: .whitespacesAndNewlines))
            mixEngineerTextField.text = songMixEngineerNames.joined(separator: ", ")
        }
        view.endEditing(true)
    }
    
    @objc func dismissKeyboard8() {
        if songMasteringEngineers.indices.contains(0) == true {
            if songMasteringEngineers[0] == "" {
                songMasteringEngineers = []
                songMasterEngineerNames = []
            }
        }
        if chosenMasterEng != "" {
            songMasteringEngineers.append("\(chosenMasterEng.trimmingCharacters(in: .whitespacesAndNewlines))")
            songMasterEngineerNames.append(chosenMasterEngNames.trimmingCharacters(in: .whitespacesAndNewlines))
            masteringEngineerTextField.text = songMasterEngineerNames.joined(separator: ", ")
        }
        view.endEditing(true)
    }
    
    @objc func dismissKeyboard9() {
        if songRecordingEngineers.indices.contains(0) == true {
            if songRecordingEngineers[0] == "" {
                songRecordingEngineers = []
                songRecordingEngineers = []
            }
        }
        if chosenRecEng != "" {
            songRecordingEngineers.append("\(chosenRecEng.trimmingCharacters(in: .whitespacesAndNewlines))")
            songRecordingEngineerNames.append(chosenRecEngNames.trimmingCharacters(in: .whitespacesAndNewlines))
            recordingEngineerTextField.text = songRecordingEngineerNames.joined(separator: ", ")
        }
        view.endEditing(true)
    }
    
    @objc func dismissKeyboard10() {
        song.isRemix!.standardEdition = remixHold[0]
        remixOfTextField.text = remixHold[1]
        view.endEditing(true)
    }
    
    @objc func dismissKeyboard11() {
        song.isOtherVersion!.standardEdition = otherVersionsHold[0]
        otherVersionsOfTextField.text = otherVersionsHold[1]
        view.endEditing(true)
    }
    
    func addInstrumentalSongActionSheet() {
        let actionSheet = UIAlertController(title: "Add Another Song?",
                                            message: "",
                                            preferredStyle: .alert)
        actionSheet.addAction(UIAlertAction(title: "Yes",
                                            style: .default,
                                            handler: { [weak self] _ in
                                                guard let strongSelf = self else {return}
                                                if strongSelf.forSongInstrumentalCheckBox.on && !strongSelf.onAlbumInstrumentalCheckBox.on {
                                                    strongSelf.forSongTextField.becomeFirstResponder()
                                                } else
                                                    if strongSelf.forSongInstrumentalCheckBox.on && strongSelf.onAlbumInstrumentalCheckBox.on {
                                                        strongSelf.onAlbumTextField.becomeFirstResponder()
                                                }
                                                
        }))
        actionSheet.addAction(UIAlertAction(title: "No, add to album.",
                                            style: .default,
                                            handler: { [weak self] _ in
                                                guard let strongSelf = self else {return}
                                                strongSelf.generateInstrumentalAppId()
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        present(actionSheet, animated: true)
    }
}

extension AlbumNewSongAddViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        var nor = 0
        if pickerView == trackNumberPickerView {
            nor = unselectedTrackNumbers.count
        }
        if pickerView == personPickerView {
           nor = AllPersonsInDatabaseArray.count
        }
        if pickerView == allsongsPickerView {
            nor = AllSongsInDatabaseArray.count
        }
        if pickerView == albumSongsPickerView {
            nor = albumUploadSongsArray.count
        }
        if pickerView == verificationLevelPickerView {
            nor = verificationLevelArr.count
        }
        if pickerView == remixOfPickerView {
            nor = AllSongsInDatabaseArray.count
        }
        if pickerView == otherVersionsOfPickerView {
            nor = AllSongsInDatabaseArray.count
        }
        return nor
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        var nor = ""
        if pickerView == trackNumberPickerView {
            nor = "\(unselectedTrackNumbers[row])"
        }
        if pickerView == personPickerView {
           nor = "\(AllPersonsInDatabaseArray[row].name ?? "person") -- \(AllPersonsInDatabaseArray[row].toneDeafAppId)"
        }
        if pickerView == allsongsPickerView {
            nor = "\(AllSongsInDatabaseArray[row].name) -- \(AllSongsInDatabaseArray[row].toneDeafAppId)"
        }
        if pickerView == albumSongsPickerView {
            let item = albumUploadSongsArray[row]
            switch item.song {
            case is AlbumUploadSongData:
                let song = item.song as! AlbumUploadSongData
                nor = "\(song.name) -- \(song.toneDeafAppId)"
            default:
                print("")
            }
        }
        if pickerView == verificationLevelPickerView {
            nor = String(verificationLevelArr[row])
        }
        if pickerView == remixOfPickerView {
            if component == 0 {
                nor = "\(AllSongsInDatabaseArray[row].name) -- \(AllSongsInDatabaseArray[row].toneDeafAppId)"
            }
        }
        if pickerView == otherVersionsOfPickerView {
            if component == 0 {
                nor = "\(AllSongsInDatabaseArray[row].name) -- \(AllSongsInDatabaseArray[row].toneDeafAppId)"
            }
        }
        return nor
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == trackNumberPickerView {
            trackNumberTexfield.text = String(unselectedTrackNumbers[row])
            song.trackNumber = String(unselectedTrackNumbers[row])
        }
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
            if mixEngineerTextField.isEditing {
                chosenMixEng = AllPersonsInDatabaseArray[row].toneDeafAppId.trimmingCharacters(in: .whitespacesAndNewlines)
                chosenMixEngNames = AllPersonsInDatabaseArray[row].name!.trimmingCharacters(in: .whitespacesAndNewlines)
            }
            if masteringEngineerTextField.isEditing {
                chosenMasterEng = AllPersonsInDatabaseArray[row].toneDeafAppId.trimmingCharacters(in: .whitespacesAndNewlines)
                chosenMasterEngNames = AllPersonsInDatabaseArray[row].name!.trimmingCharacters(in: .whitespacesAndNewlines)
            }
            if recordingEngineerTextField.isEditing {
                chosenRecEng = AllPersonsInDatabaseArray[row].toneDeafAppId.trimmingCharacters(in: .whitespacesAndNewlines)
                chosenRecEngNames = AllPersonsInDatabaseArray[row].name!.trimmingCharacters(in: .whitespacesAndNewlines)
            }
        }
        if pickerView == allsongsPickerView {
            chosenInstrumentalSong = AllSongsInDatabaseArray[row].toneDeafAppId.trimmingCharacters(in: .whitespacesAndNewlines)
            chosenInstrumentalSongNames = AllSongsInDatabaseArray[row].name.trimmingCharacters(in: .whitespacesAndNewlines)
        }
        if pickerView == albumSongsPickerView {
            let item = albumUploadSongsArray[row]
            switch item.song {
            case is AlbumUploadSongData:
                let song = item.song as! AlbumUploadSongData
                chosenInstrumentalSong = song.toneDeafAppId.trimmingCharacters(in: .whitespacesAndNewlines)
                chosenInstrumentalSongNames = song.name.trimmingCharacters(in: .whitespacesAndNewlines)
            default:
                print("")
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
        if pickerView == personPickerView {
            switch textField {
            case artistTextField:
                doneButton = UIBarButtonItem(title: "Add", style: UIBarButtonItem.Style.done, target: self, action: #selector(dismissKeyboard2))
            case producerTextField:
                doneButton = UIBarButtonItem(title: "Add", style: UIBarButtonItem.Style.done, target: self, action: #selector(dismissKeyboard3))
            case writerTextField:
                doneButton = UIBarButtonItem(title: "Add", style: UIBarButtonItem.Style.done, target: self, action: #selector(dismissKeyboard6))
            case mixEngineerTextField:
                doneButton = UIBarButtonItem(title: "Add", style: UIBarButtonItem.Style.done, target: self, action: #selector(dismissKeyboard7))
            case masteringEngineerTextField:
                doneButton = UIBarButtonItem(title: "Add", style: UIBarButtonItem.Style.done, target: self, action: #selector(dismissKeyboard8))
            case recordingEngineerTextField:
                doneButton = UIBarButtonItem(title: "Add", style: UIBarButtonItem.Style.done, target: self, action: #selector(dismissKeyboard9))
            default:
                break
            }
        }
        if pickerView == allsongsPickerView || pickerView == albumSongsPickerView {
            doneButton = UIBarButtonItem(title: "Link", style: UIBarButtonItem.Style.done, target: self, action: #selector(dismissKeyboard4))
        }
        if pickerView == trackNumberPickerView {
            doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.done, target: self, action: #selector(dismissKeyboard5))
        }
        if pickerView == verificationLevelPickerView {
            doneButton = UIBarButtonItem(title: "Select", style: UIBarButtonItem.Style.done, target: self, action: #selector(dismissKeyboard))
        }
        if pickerView == remixOfPickerView {
            doneButton = UIBarButtonItem(title: "Select", style: UIBarButtonItem.Style.done, target: self, action: #selector(dismissKeyboard10))
        }
        if pickerView == otherVersionsOfPickerView {
            doneButton = UIBarButtonItem(title: "Select", style: UIBarButtonItem.Style.done, target: self, action: #selector(dismissKeyboard11))
        }
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItem.Style.plain, target: self, action: #selector(dismissKeyboard))

        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true

        textField.inputView = pickerView
        textField.inputAccessoryView = toolBar
    }
}

extension AlbumNewSongAddViewController: UITextFieldDelegate {
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
        case mixEngineerTextField:
            songMixEngineers = []
            songMixEngineerNames = []
            return true
        case masteringEngineerTextField:
            songMasteringEngineers = []
            songMasterEngineerNames = []
            return true
        case recordingEngineerTextField:
            songRecordingEngineers = []
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
        case mixEngineerTextField:
            personPickerView.selectRow(0, inComponent: 0, animated: false)
            chosenMixEng = AllPersonsInDatabaseArray[0].toneDeafAppId.trimmingCharacters(in: .whitespacesAndNewlines)
            chosenMixEngNames = AllPersonsInDatabaseArray[0].name!.trimmingCharacters(in: .whitespacesAndNewlines)
        case masteringEngineerTextField:
            personPickerView.selectRow(0, inComponent: 0, animated: false)
            chosenMasterEng = AllPersonsInDatabaseArray[0].toneDeafAppId.trimmingCharacters(in: .whitespacesAndNewlines)
            chosenMasterEngNames = AllPersonsInDatabaseArray[0].name!.trimmingCharacters(in: .whitespacesAndNewlines)
        case recordingEngineerTextField:
            personPickerView.selectRow(0, inComponent: 0, animated: false)
            chosenRecEng = AllPersonsInDatabaseArray[0].toneDeafAppId.trimmingCharacters(in: .whitespacesAndNewlines)
            chosenRecEngNames = AllPersonsInDatabaseArray[0].name!.trimmingCharacters(in: .whitespacesAndNewlines)
        default:
            break
        }
    }
    
}
