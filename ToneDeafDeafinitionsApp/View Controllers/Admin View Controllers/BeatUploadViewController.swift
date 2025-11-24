//
//  BeatUploadViewController.swift
//  ToneDeafDeafinitionsApp
//
//  Created by Tone Deaf on 7/31/20.
//  Copyright © 2020 GITEM Solutions. All rights reserved.
//

import UIKit
import MobileCoreServices
import FirebaseDatabase
import FirebaseStorage

protocol UploadBeatProducersDelegate: class {
    func producerAdded(_ producer: PersonData)
}

class BeatUploadViewController: UIViewController, UINavigationControllerDelegate, UploadBeatProducersDelegate {
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
    
    var dataAudio:URL!
    var arr:String!
    @IBOutlet weak var producerTableView: UITableView!
    @IBOutlet weak var producerHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var scrollview: UIScrollView!
    @IBOutlet weak var beatImage: UIImageView!
    @IBOutlet weak var uploadButton: UIButton!
    @IBOutlet weak var textFieldBeatName: UITextField! {
        didSet {
            let placeholderText = NSAttributedString(string: "Name",
                                                        attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray.withAlphaComponent(0.4)])
            
            textFieldBeatName.attributedPlaceholder = placeholderText
        }
    }
    @IBOutlet weak var textFieldBeatFile: UITextField! {
        didSet {
            let placeholderText = NSAttributedString(string: "File",
                                                        attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray.withAlphaComponent(0.4)])
            
            textFieldBeatFile.attributedPlaceholder = placeholderText
        }
    }
    @IBOutlet weak var textFieldSoundcloud: UITextField! {
        didSet {
            let placeholderText = NSAttributedString(string: "URL",
                                                        attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray.withAlphaComponent(0.4)])
            
            textFieldSoundcloud.attributedPlaceholder = placeholderText
        }
    }
    @IBOutlet weak var textFieldLeasePrice: CurrencyTextField! {
        didSet {
            let placeholderText = NSAttributedString(string: "Lease",
                                                        attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray.withAlphaComponent(0.4)])
            
            textFieldLeasePrice.attributedPlaceholder = placeholderText
        }
    }
    @IBOutlet weak var textFieldWavPrice: CurrencyTextField! {
        didSet {
            let placeholderText = NSAttributedString(string: "Wav",
                                                        attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray.withAlphaComponent(0.4)])
            
            textFieldWavPrice.attributedPlaceholder = placeholderText
        }
    }
    @IBOutlet weak var textFieldExclusivePrice: CurrencyTextField! {
        didSet {
            let placeholderText = NSAttributedString(string: "Exclusive",
                                                        attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray.withAlphaComponent(0.4)])
            
            textFieldExclusivePrice.attributedPlaceholder = placeholderText
        }
    }
    @IBOutlet weak var textFieldTempo: UITextField! {
        didSet {
            let placeholderText = NSAttributedString(string: "BPM",
                                                        attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray.withAlphaComponent(0.4)])
            
            textFieldTempo.attributedPlaceholder = placeholderText
        }
    }
    @IBOutlet weak var textFieldBeatKey: UITextField! {
        didSet {
            let placeholderText = NSAttributedString(string: "C Min/Eb Maj",
                                                        attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray.withAlphaComponent(0.4)])
            
            textFieldBeatKey.attributedPlaceholder = placeholderText
        }
    }
    @IBOutlet weak var segmentedControlFreePaid: UISegmentedControl!
    @IBOutlet weak var segmentedControlWav: UISegmentedControl!
    @IBOutlet weak var segmentedControlTrackOut: UISegmentedControl!
    @IBOutlet weak var darkTypeSwitch: UISwitch!
    @IBOutlet weak var melodicTypeSwitch: UISwitch!
    @IBOutlet weak var aggressiveTypeSwitch: UISwitch!
    @IBOutlet weak var smoothTypeSwitch: UISwitch!
    @IBOutlet weak var rAndBTypeSwitch: UISwitch!
    @IBOutlet weak var vibeyTypeSwitch: UISwitch!
    @IBOutlet weak var clubTypeSwitch: UISwitch!
    @IBOutlet weak var joyfulTypeSwitch: UISwitch!
    @IBOutlet weak var soulfulTypeSwitch: UISwitch!
    @IBOutlet weak var experimentalTypeSwitch: UISwitch!
    @IBOutlet weak var calmTypeSwitch: UISwitch!
    @IBOutlet weak var epicTypeSwitch: UISwitch!
    @IBOutlet weak var simpleTypeSwitch: UISwitch!
    @IBOutlet weak var trapTypeSwitch: UISwitch!
    @IBOutlet weak var relaxedTypeSwitch: UISwitch!
    @IBOutlet weak var keysSoundSwitch: UISwitch!
    @IBOutlet weak var pianoAcousticSoundSwitch: UISwitch!
    @IBOutlet weak var organSoundSwitch: UISwitch!
    @IBOutlet weak var pianoElectricSoundSwitch: UISwitch!
    @IBOutlet weak var theraminSoundSwitch: UISwitch!
    @IBOutlet weak var pianoVinylSoundSwitch: UISwitch!
    @IBOutlet weak var whistleSoundSwitch: UISwitch!
    @IBOutlet weak var pianoRhodes: UISwitch!
    @IBOutlet weak var hornsSoundSwitch: UISwitch!
    @IBOutlet weak var padAggressiveSoundSwitch: UISwitch!
    @IBOutlet weak var padBellSoundSwitch: UISwitch!
    @IBOutlet weak var padHollowSoundSwitch: UISwitch!
    @IBOutlet weak var saxSoundSwitch: UISwitch!
    @IBOutlet weak var guitarElectricSoundSwitch: UISwitch!
    @IBOutlet weak var choirSoundSwitch: UISwitch!
    @IBOutlet weak var guitarAcousticSoundSwitch: UISwitch!
    @IBOutlet weak var bellsEDMSoundSwitch: UISwitch!
    @IBOutlet weak var guitarSteelSoundSwitch: UISwitch!
    @IBOutlet weak var bellsVinylSoundSwitch: UISwitch!
    @IBOutlet weak var bellsGothicSoundSwitch: UISwitch!
    @IBOutlet weak var bellsHollowSoundSwitch: UISwitch!
    @IBOutlet weak var bellsMusicBoxSoundSwitch: UISwitch!
    @IBOutlet weak var sampleSongSoundSwitch: UISwitch!
    @IBOutlet weak var sampleVocalSoundSwitch: UISwitch!
    @IBOutlet weak var noKickSoundSwitch: UISwitch!
    @IBOutlet weak var kickSoundSwitch: UISwitch!
    @IBOutlet weak var m808LongSoundSwitch: UISwitch!
    @IBOutlet weak var m808ShortSoundSwitch: UISwitch!
    @IBOutlet weak var m898DistrortedSoundSwitch: UISwitch!
    @IBOutlet weak var m808CleanSoundSwitch: UISwitch!
    @IBOutlet weak var moogBassSoundSwitch: UISwitch!
    @IBOutlet weak var subBassSoundSwitch: UISwitch!
    @IBOutlet weak var synthBassDistortedSoundSwitch: UISwitch!
    @IBOutlet weak var fluteSoundsSwitch: UISwitch!
    @IBOutlet weak var snapSoundSwitch: UISwitch!
    @IBOutlet weak var synthBassDeepSoundSwitch: UISwitch!
    @IBOutlet weak var stringsSoundsSwitch: UISwitch!
    @IBOutlet weak var synthAnalogSoundsSwitch: UISwitch!
    @IBOutlet weak var synthPolySoundsSwitch: UISwitch!
    
    
    var producerArr:[PersonData] = []
    var beatProducers:Array<String> = []
    var beatTypesArray:Array<String> = []
    var beatSoundsArray:Array<String> = []
    var beatProducerNames:[String] = []
    var producerref:[String] = []
    var chosenProducer = ""
    var chosenProducerNames = ""
    var videodbid = ""
    var beatName:String = ""
    var priceDetermination:String = "Free"
    var beatRandomKey:String = ""
    var numberOfDownloads = 0
    var numberOfFavorites = 0
    var youtubeURL:String = ""
    var soundcloudURL:String = ""
    var selectedFileURL:URL?
    var leasePrice:Double?
    var wavPrice:Double?
    var exclusivePrice:Double?
    var beatFile:String = ""
    var beattempo:Int = 0
    var key:String = ""
    var coProducers:String = ""
    var currentDate:String = ""
    var currentTime:String = ""
    var tDAppId = ""
    var genid = ""
    var audioURL:String!
    var imageURL:String!
    
    var progressView:UIProgressView!
    var totalProgress:Float = 8
    var progressCompleted:Float = 0
    var alertView:UIAlertController!

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpElements()
        dismissKeyboardOnTap()
        DatabaseManager.shared.fetchAllPersonsFromDatabase(completion: {[weak self] persons in
            guard let strongSelf = self else {return}
            AllPersonsInDatabaseArray = persons
        })
        segmentedControlFreePaid.selectedSegmentIndex = 0
        priceDetermination = "Free"
        // Do any additional setup after loading the view.
    }
    
    func setUpElements() {
        beatImage.layer.masksToBounds = true
        Utilities.styleFilledButton(uploadButton)
        Utilities.styleTextField(textFieldBeatName)
        Utilities.styleTextField(textFieldBeatFile)
        Utilities.styleTextField(textFieldLeasePrice)
        Utilities.styleTextField(textFieldWavPrice)
        Utilities.styleTextField(textFieldExclusivePrice)
        Utilities.styleTextField(textFieldTempo)
        Utilities.styleTextField(textFieldBeatKey)
        addBottomLineToText(textFieldBeatName)
        addBottomLineToText(textFieldBeatFile)
        addGrayBottomLineToText(textFieldLeasePrice)
        addBottomLineToText(textFieldWavPrice)
        addBottomLineToText(textFieldExclusivePrice)
        addBottomLineToText(textFieldTempo)
        addBottomLineToText(textFieldBeatKey)
        textFieldBeatName.delegate = self
        textFieldBeatFile.delegate = self
        textFieldLeasePrice.delegate = self
        textFieldWavPrice.delegate = self
        textFieldExclusivePrice.delegate = self
        textFieldTempo.delegate = self
        textFieldBeatKey.delegate = self
        
        textFieldBeatKey.inputView = beatKeyPickerView
        beatKeyPickerView.delegate = self
        beatKeyPickerView.dataSource = self
        pickerViewToolbar(textField: textFieldBeatKey, pickerView: beatKeyPickerView)
        
        textFieldTempo.inputView = beatTempoPickerView
        beatTempoPickerView.delegate = self
        beatTempoPickerView.dataSource = self
        pickerViewToolbar(textField: textFieldTempo, pickerView: beatTempoPickerView)
        beatTempoPickerView.selectRow(100, inComponent: 0, animated: false)
    
        
        producerTableView.delegate = self
        producerTableView.dataSource = self
        producerHeightConstraint.constant = 0
    }
    
    @IBAction func imageTapped(_ sender: Any) {
        presentPhotoActionSheet()
    }
    @IBAction func fileTapped(_ sender: Any) {
        openFiles()
    }
    
    let keys = Constants.Beats.keys
    let tempo: [Int] = Array(50...200)
    var beatKeyPickerView = UIPickerView()
    var beatTempoPickerView = UIPickerView()
    
    func addToBeatTypeArray(value:String) {
        beatTypesArray.append(value)
        print("\(value) Type indexed at: \(String(describing: beatTypesArray.firstIndex(of: value)))")
    }
    
    func removeFromBeatTypeArray(value:String) {
        let index = beatTypesArray.firstIndex(of: value)
        print("\(value) Type removed from index: \(String(describing: beatTypesArray.firstIndex(of: value)))")
        beatTypesArray.remove(at: index!)
    }
    
    @IBAction func darkSwitchDidChange(_ sender: UISwitch) {
        if sender.isOn {
            addToBeatTypeArray(value: "Dark")
            
        }
        else {
            removeFromBeatTypeArray(value: "Dark")
        }
    }
    
    @IBAction func melodicSwitchDidChange(_ sender: UISwitch) {
        if sender.isOn {
            addToBeatTypeArray(value: "Melodic")
            
        }
        else {
            removeFromBeatTypeArray(value: "Melodic")
        }
    }
    
    @IBAction func aggressiveSwitchDidChange(_ sender: UISwitch) {
        if sender.isOn {
            addToBeatTypeArray(value: "Aggressive")
            
        }
        else {
            removeFromBeatTypeArray(value: "Aggressive")
        }
    }
    
    @IBAction func smoothSwitchDidChange(_ sender: UISwitch) {
        if sender.isOn {
            addToBeatTypeArray(value: "Smooth")
            
        }
        else {
            removeFromBeatTypeArray(value: "Smooth")
        }
    }
    
    @IBAction func rAndBDidChange(_ sender: UISwitch) {
        if sender.isOn {
            addToBeatTypeArray(value: "R&B")
            
        }
        else {
            removeFromBeatTypeArray(value: "R&B")
        }
    }
    
    @IBAction func vibeySwitchDidChange(_ sender: UISwitch) {
        if sender.isOn {
            addToBeatTypeArray(value: "Vibey")
            
        }
        else {
            removeFromBeatTypeArray(value: "Vibey")
        }
    }
    
    @IBAction func clubSwitchDidChange(_ sender: UISwitch) {
        if sender.isOn {
            addToBeatTypeArray(value: "Club")
            
        }
        else {
            removeFromBeatTypeArray(value: "Club")
        }
    }
    
    @IBAction func joyfulSwitchDidChange(_ sender: UISwitch) {
        if sender.isOn {
            addToBeatTypeArray(value: "Joyful")
            
        }
        else {
            removeFromBeatTypeArray(value: "Joyful")
        }
    }
    
    @IBAction func soulfulSwicthDidChange(_ sender: UISwitch) {
        if sender.isOn {
            addToBeatTypeArray(value: "Soulful")
            
        }
        else {
            removeFromBeatTypeArray(value: "Soulful")
        }
    }
    
    @IBAction func experimentalSwitchDidChange(_ sender: UISwitch) {
        if sender.isOn {
            addToBeatTypeArray(value: "Experimental")
            
        }
        else {
            removeFromBeatTypeArray(value: "Experimental")
        }
    }
    
    @IBAction func calmSwitchDidChange(_ sender: UISwitch) {
        if sender.isOn {
            addToBeatTypeArray(value: "Calm")
            
        }
        else {
            removeFromBeatTypeArray(value: "Calm")
        }
    }
    
    @IBAction func epicSwitchDidChange(_ sender: UISwitch) {
        if sender.isOn {
            addToBeatTypeArray(value: "Epic")
            
        }
        else {
            removeFromBeatTypeArray(value: "Epic")
        }
    }
    
    @IBAction func simpleSwitchDidChange(_ sender: UISwitch) {
        if sender.isOn {
            addToBeatTypeArray(value: "Simple")
            
        }
        else {
            removeFromBeatTypeArray(value: "Simple")
        }
    }
    
    @IBAction func trapSwitchDidChange(_ sender: UISwitch) {
        if sender.isOn {
            addToBeatTypeArray(value: "Trap")
            
        }
        else {
            removeFromBeatTypeArray(value: "Trap")
        }
    }
    
    @IBAction func relaxedSwitchDidChange(_ sender: UISwitch) {
        if sender.isOn {
            addToBeatTypeArray(value: "Relaxed")
            
        }
        else {
            removeFromBeatTypeArray(value: "Relaxed")
        }
    }
    
    func addToSoundsArray(value:String) {
        beatSoundsArray.append(value)
        print("\(value) Sound indexed at: \(String(describing: beatSoundsArray.firstIndex(of: value)))")
    }
    
    func removeFromBeatSoundsArray(value:String) {
        let index = beatSoundsArray.firstIndex(of: value)
        print("\(value) Sound removed from index: \(String(describing: beatSoundsArray.firstIndex(of: value)))")
        beatSoundsArray.remove(at: index!)
    }
    
    @IBAction func keysSwitchDidChange(_ sender: UISwitch) {
        if sender.isOn {
            addToSoundsArray(value: "Keys")
            
        }
        else {
            removeFromBeatSoundsArray(value: "Keys")
        }
    }
    
    @IBAction func pianoAcousticSwitchDidChange(_ sender: UISwitch) {
        if sender.isOn {
            addToSoundsArray(value: "Piano Acoustic")
            
        }
        else {
            removeFromBeatSoundsArray(value: "Piano Acoustic")
        }
    }
    @IBAction func organSwitchDidChange(_ sender: UISwitch) {
        if sender.isOn {
            addToSoundsArray(value: "Organ")
            
        }
        else {
            removeFromBeatSoundsArray(value: "Organ")
        }
    }
    
    @IBAction func pianoElectricSwitchDidChange(_ sender: UISwitch) {
        if sender.isOn {
            addToSoundsArray(value: "Piano Electric")
            
        }
        else {
            removeFromBeatSoundsArray(value: "Piano Electric")
        }
    }
    
    @IBAction func theraminSwitchDidChange(_ sender: UISwitch) {
        if sender.isOn {
            addToSoundsArray(value: "Theramin")
            
        }
        else {
            removeFromBeatSoundsArray(value: "Theramin")
        }
    }
    
    @IBAction func pianoVinylSwitchDidChange(_ sender: UISwitch) {
        if sender.isOn {
            addToSoundsArray(value: "Piano Vinyl")
            
        }
        else {
            removeFromBeatSoundsArray(value: "Piano Vinyl")
        }
    }
    
    @IBAction func whistleSwitchDidChange(_ sender: UISwitch) {
        if sender.isOn {
            addToSoundsArray(value: "Whistle")
            
        }
        else {
            removeFromBeatSoundsArray(value: "Whistle")
        }
    }
    
    @IBAction func pianoRhodesSwitchDidChange(_ sender: UISwitch) {
        if sender.isOn {
            addToSoundsArray(value: "Piano Rhodes")
            
        }
        else {
            removeFromBeatSoundsArray(value: "Piano Rhodes")
        }
    }
    
    @IBAction func hornsSwitchDidChange(_ sender: UISwitch) {
        if sender.isOn {
            addToSoundsArray(value: "Horns")
            
        }
        else {
            removeFromBeatSoundsArray(value: "Horns")
        }
    }
    
    @IBAction func padAggressiveSwitchDidChange(_ sender: UISwitch) {
        if sender.isOn {
            addToSoundsArray(value: "Pad Aggressive")
            
        }
        else {
            removeFromBeatSoundsArray(value: "Pad Aggressive")
        }
    }
    
    @IBAction func padBellSwitchDidChange(_ sender: UISwitch) {
        if sender.isOn {
            addToSoundsArray(value: "Pad Bell")
            
        }
        else {
            removeFromBeatSoundsArray(value: "Pad Bell")
        }
    }
    
    @IBAction func padHollowSwitchDidChange(_ sender: UISwitch) {
        if sender.isOn {
            addToSoundsArray(value: "Pad Hollow")
            
        }
        else {
            removeFromBeatSoundsArray(value: "Pad Hollow")
        }
    }
    
    @IBAction func saxSwitchDidChange(_ sender: UISwitch) {
        if sender.isOn {
            addToSoundsArray(value: "Saxophone")
            
        }
        else {
            removeFromBeatSoundsArray(value: "Saxophone")
        }
    }
    
    @IBAction func guitarElectricSwitchDidChange(_ sender: UISwitch) {
        if sender.isOn {
            addToSoundsArray(value: "Guitar Electric")
            
        }
        else {
            removeFromBeatSoundsArray(value: "Guitar Electric")
        }
    }
    
    @IBAction func choirSwitchDidChange(_ sender: UISwitch) {
        if sender.isOn {
            addToSoundsArray(value: "Choir")
            
        }
        else {
            removeFromBeatSoundsArray(value: "Choir")
        }
    }
    
    @IBAction func guitarAcousticSwitchDidChange(_ sender: UISwitch) {
        if sender.isOn {
            addToSoundsArray(value: "Guitar Acoustic")
            
        }
        else {
            removeFromBeatSoundsArray(value: "Guitar Acoustic")
        }
    }
    
    @IBAction func bellsEDMSwitchDidChange(_ sender: UISwitch) {
        if sender.isOn {
            addToSoundsArray(value: "Bells EDM")
            
        }
        else {
            removeFromBeatSoundsArray(value: "Bells EDM")
        }
    }
    
    @IBAction func guitarSteelSwitchDidChange(_ sender: UISwitch) {
        if sender.isOn {
            addToSoundsArray(value: "Guitar Steel")
            
        }
        else {
            removeFromBeatSoundsArray(value: "Guitar Steel")
        }
    }
    
    @IBAction func bellsVinylSwitchDidChange(_ sender: UISwitch) {
        if sender.isOn {
            addToSoundsArray(value: "Bells Vinyl")
            
        }
        else {
            removeFromBeatSoundsArray(value: "Bells Vinyl")
        }
    }
    
    @IBAction func bellsGothicSwitchDidChange(_ sender: UISwitch) {
        if sender.isOn {
            addToSoundsArray(value: "Bells Gothic")
            
        }
        else {
            removeFromBeatSoundsArray(value: "Bells Gothic")
        }
    }
    
    @IBAction func bellsHollowSwitchDidChange(_ sender: UISwitch) {
        if sender.isOn {
            addToSoundsArray(value: "Bells Hollow")
            
        }
        else {
            removeFromBeatSoundsArray(value: "Bells Hollow")
        }
    }
    
    @IBAction func bellsMusicBoxSwitchDidChange(_ sender: UISwitch) {
        if sender.isOn {
            addToSoundsArray(value: "Bells Music Box")
            
        }
        else {
            removeFromBeatSoundsArray(value: "Bells Music Box")
        }
    }
    
    @IBAction func sampleVocalSwitchDidChange(_ sender: UISwitch) {
        if sender.isOn {
            addToSoundsArray(value: "Sample Vocal")
            
        }
        else {
            removeFromBeatSoundsArray(value: "Sample Vocal")
        }
    }
    
    @IBAction func sampleSongSwitchDidChange(_ sender: UISwitch) {
        if sender.isOn {
            addToSoundsArray(value: "Sample Song")
            
        }
        else {
            removeFromBeatSoundsArray(value: "Sample Song")
        }
    }
    
    @IBAction func noKickSwitchDidChange(_ sender: UISwitch) {
        if sender.isOn {
            addToSoundsArray(value: "No Kick")
            
        }
        else {
            removeFromBeatSoundsArray(value: "No Kick")
        }
    }
    
    @IBAction func kickSwitchDidChange(_ sender: UISwitch) {
        if sender.isOn {
            addToSoundsArray(value: "Kick")
            
        }
        else {
            removeFromBeatSoundsArray(value: "Kick")
        }
    }
    
    @IBAction func m808LongSwitchDidChange(_ sender: UISwitch) {
        if sender.isOn {
            addToSoundsArray(value: "808 Long")
            
        }
        else {
            removeFromBeatSoundsArray(value: "808 Long")
        }
    }
    
    @IBAction func m808ShortSwitchDidChange(_ sender: UISwitch) {
        if sender.isOn {
            addToSoundsArray(value: "808 Short")
            
        }
        else {
            removeFromBeatSoundsArray(value: "808 Short")
        }
    }
    
    @IBAction func m808DistortedSwitchDidChange(_ sender: UISwitch) {
        if sender.isOn {
            addToSoundsArray(value: "808 Distorted")
            
        }
        else {
            removeFromBeatSoundsArray(value: "808 Distorted")
        }
    }
    
    @IBAction func m808CleanSwitchDidChange(_ sender: UISwitch) {
        if sender.isOn {
            addToSoundsArray(value: "808 Clean")
            
        }
        else {
            removeFromBeatSoundsArray(value: "808 Clean")
        }
    }
    
    @IBAction func moogBassSwitchDidChange(_ sender: UISwitch) {
        if sender.isOn {
            addToSoundsArray(value: "Moog Bass")
            
        }
        else {
            removeFromBeatSoundsArray(value: "Moog Bass")
        }
    }
    
    @IBAction func subBassSwitchDidChange(_ sender: UISwitch) {
        if sender.isOn {
            addToSoundsArray(value: "Sub Bass")
            
        }
        else {
            removeFromBeatSoundsArray(value: "Sub Bass")
        }
    }
    
    @IBAction func synthBassDistortedSwitchDidChange(_ sender: UISwitch) {
        if sender.isOn {
            addToSoundsArray(value: "Synth Bass Distorted")
            
        }
        else {
            removeFromBeatSoundsArray(value: "Synth Bass Distorted")
        }
    }
    
    @IBAction func SnapSwitchDidChange(_ sender: UISwitch) {
        if sender.isOn {
            addToSoundsArray(value: "Snap")
            
        }
        else {
            removeFromBeatSoundsArray(value: "Snap")
        }
    }
    
    @IBAction func synthBassDeepSwitchDidChange(_ sender: UISwitch) {
        if sender.isOn {
            addToSoundsArray(value: "Synth Bass Deep")
            
        }
        else {
            removeFromBeatSoundsArray(value: "Synth Bass Deep")
        }
    }
    
    @IBAction func fluteSwitchDidChange(_ sender: UISwitch) {
        if sender.isOn {
            addToSoundsArray(value: "Flute")
            
        }
        else {
            removeFromBeatSoundsArray(value: "Flute")
        }
    }
    
    @IBAction func stringsSwitchDidChange(_ sender: UISwitch) {
        if sender.isOn {
            addToSoundsArray(value: "Strings")
            
        }
        else {
            removeFromBeatSoundsArray(value: "Strings")
        }
    }
    
    @IBAction func synthPolySwitchDidChange(_ sender: UISwitch) {
        if sender.isOn {
            addToSoundsArray(value: "Synth Poly")
            
        }
        else {
            removeFromBeatSoundsArray(value: "Synth Poly")
        }
    }
    
    @IBAction func synthAnalogSwitchDidChange(_ sender: UISwitch) {
        if sender.isOn {
            addToSoundsArray(value: "Synth Analog")
        }
        else {
            removeFromBeatSoundsArray(value: "Synth Analog")
        }
    }
    
    @IBAction func addProducerTapped(_ sender: Any) {
        arr = "person"
        performSegue(withIdentifier: "uploadBeatToTonesPick", sender: nil)
    }
    
    func producerAdded(_ producer:PersonData) {
        
        if !producerArr.contains(producer) {
            producerArr.append(producer)
        }
        DispatchQueue.main.async {[weak self]  in
            guard let strongSelf = self else {return}
            strongSelf.producerTableView.reloadData()
            strongSelf.producerHeightConstraint.constant = CGFloat(50*(strongSelf.producerArr.count))
        }
        
        
    }
    
    @IBAction func priceDeterminationChanged(_ sender: UISegmentedControl) {
        if segmentedControlFreePaid.selectedSegmentIndex == 0 {
            priceDetermination = "Free"
            textFieldLeasePrice.isEnabled = false
            addGrayBottomLineToText(textFieldLeasePrice)
        } else {
            priceDetermination = "Paid"
            textFieldLeasePrice.isEnabled = true
            addBottomLineToText(textFieldLeasePrice)
        }
    }
    
    
    //MARK: - Upload
    @IBAction func uploadTapped(_ sender: Any) {
        
        guard textFieldBeatName.text != "" else {
            mediumImpactGenerator.impactOccurred()
            Utilities.showError2("Name required"  ,actionText: "Ok")
            return
        }
        guard !producerArr.isEmpty else {
            mediumImpactGenerator.impactOccurred()
            Utilities.showError2("Producer required"  ,actionText: "Ok")
            return
        }
        guard textFieldTempo.text != "" else {
            mediumImpactGenerator.impactOccurred()
            Utilities.showError2("Tempo required"  ,actionText: "Ok")
            return
        }
        guard textFieldBeatKey.text != "" else {
            mediumImpactGenerator.impactOccurred()
            Utilities.showError2("Key required"  ,actionText: "Ok")
            return
        }
        if textFieldSoundcloud.text != "" {
            guard textFieldSoundcloud.text!.count > 15 else {
                mediumImpactGenerator.impactOccurred()
                Utilities.showError2("Failed to Upload. Soundcloud url invalid.", actionText: "OK")
                return
            }
            guard textFieldSoundcloud.text!.contains("soundcloud") else {
                mediumImpactGenerator.impactOccurred()
                Utilities.showError2("Failed to Upload. Soundcloud url invalid.", actionText: "OK")
                return
            }
        }
        let date = Date()
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone(identifier: "EDT")
        formatter.dateFormat = "MMMM dd, yyyy"
        currentDate = formatter.string(from: date)
        
        let time = Date()
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "HH:mm:ss a"
        timeFormatter.timeZone = TimeZone(identifier: "EDT")
        currentTime = timeFormatter.string(from: time)
        
        checkProducerLegals(completion: {[weak self] done,errString in
            guard let strongSelf = self else {return}
            guard errString == nil else {
                mediumImpactGenerator.impactOccurred()
                Utilities.showError2(errString! ,actionText: "Ok")
                return
            }
            strongSelf.beatName = strongSelf.textFieldBeatName.text!.replacingOccurrences(of: ".mp3", with: "")
            strongSelf.beattempo = Int(strongSelf.textFieldTempo.text!)!
            strongSelf.key = strongSelf.textFieldBeatKey.text!
            if strongSelf.textFieldLeasePrice.text != ""{
                strongSelf.leasePrice = Double(strongSelf.textFieldLeasePrice.text!.replacingOccurrences(of: "$", with: "").replacingOccurrences(of: " ", with: ""))!
            }
            if strongSelf.textFieldWavPrice.text != ""{
                strongSelf.wavPrice = Double(strongSelf.textFieldWavPrice.text!.replacingOccurrences(of: "$", with: "").replacingOccurrences(of: " ", with: ""))!
            }
            if strongSelf.textFieldExclusivePrice.text != ""{
                strongSelf.exclusivePrice = Double(strongSelf.textFieldExclusivePrice.text!.replacingOccurrences(of: "$", with: "").replacingOccurrences(of: " ", with: ""))!
            }
            if strongSelf.textFieldSoundcloud.text != "" {
                strongSelf.soundcloudURL = strongSelf.textFieldSoundcloud.text!
            }
            DispatchQueue.main.async {
                strongSelf.alertView = UIAlertController(title: "Uploading \(strongSelf.beatName)", message: "Preparing...", preferredStyle: .alert)
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
                    strongSelf.getProducerRefs(completion: { [weak self] error in
                        guard let strongSelf = self else {return}
                        if let error = error {
                            Utilities.showError2("retrieving producer refs Failed: \(error)", actionText: "OK")
                            mediumImpactGenerator.impactOccurred()
                            return
                        }
                        else {
                            print("retrieving producer refs done")
                            strongSelf.generateAppId()
                        }
                    })
                })
            }
        })
    }
    
    func generateAppId() {
        genid = StorageManager.shared.generateRandomNumber(digits: 14)
        DatabaseManager.shared.checkIfBeatAppIdExists(appid: genid, completion: { [weak self] result in
            guard let strongSelf = self else {return}
            print(result)
            
            if result == true {
                strongSelf.generateAppId()
                
            } else {
                strongSelf.tDAppId = strongSelf.genid
                strongSelf.progressCompleted+=1
                strongSelf.progressView.progress = (strongSelf.progressCompleted/strongSelf.totalProgress)
                print("\(strongSelf.progressCompleted) out of \(strongSelf.totalProgress)")
                strongSelf.storeBeatInfo()
                
            }
        })
    }
    
    func checkProducerLegals(completion: @escaping ((Bool, String?) -> Void)) {
        var tick = 0
        for pro in producerArr {
            DatabaseManager.shared.fetchPersonData(person: pro.toneDeafAppId, completion: {[weak self] result in
                guard let strongSelf = self else {return}
                switch result {
                case .success(let producer):
                    guard let _ = producer.legalName else {
                        completion(false, "\(producer.name!) does not have a registered legal name.")
                        return
                    }
                    tick+=1
                    if tick == strongSelf.producerArr.count {
                        strongSelf.progressCompleted+=1
                        print("\(strongSelf.progressCompleted) out of \(strongSelf.totalProgress)")
                        completion(true, nil)
                    }
                case .failure(let err):
                    print("youyouerr", err)
                }
            })
        }
    }
    
    func storeBeatInfo() {
        beatRandomKey = "\(beatContentTag)--\(beatName)--\(tDAppId)"
        let beatqueue = DispatchQueue(label: "myhjbeatshjfktyhbvndikhQueue")
        let beatgroup = DispatchGroup()
        let array:[Int] = [1,2]
        for i in array {
            beatgroup.enter()
            beatqueue.async { [weak self] in
                guard let strongSelf = self else {return}
                switch i {
                case 1:
                    strongSelf.uploadCompletionStatus1 = false
                    strongSelf.uploadAudio(completion: { error in
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
                        beatgroup.leave()
                    })
                case 2:
                    strongSelf.uploadCompletionStatus2 = false
                    strongSelf.uploadImage(completion: { error in
                        if let error = error {
                            Utilities.showError2("uploading image Failed: \(error)", actionText: "OK")
                            mediumImpactGenerator.impactOccurred()
                            strongSelf.uploadCompletionStatus2 = false
                            return
                        }
                        else {
                            strongSelf.uploadCompletionStatus2 = true
                            print("uploading image done \(i)")
                        }
                        beatgroup.leave()
                    })
                default:
                    print("beat oopsie")
                }
                
            }
            
        }
        beatgroup.notify(queue: DispatchQueue.main) {[weak self] in
            guard let strongSelf = self else {return}
            if strongSelf.uploadCompletionStatus1 == false || strongSelf.uploadCompletionStatus2 == false {
                
                Utilities.showError2("Upload Failed.", actionText: "OK")
                return
            } else {
                strongSelf.saveBeatInfoToDatabase()
            }
        }
    }
    
    //MARK: - Gathering Data
    func uploadAudio(completion: @escaping ((Error?) -> Void)) {
        let fileNNameAudio = "\(beatContentTag)--\(tDAppId)"
        StorageManager.shared.uploadAudio(with: dataAudio, fileName: fileNNameAudio, type: "beat", completion: {[weak self] result in
            guard let strongSelf = self else {return}
        switch result {
        case.success(let downloadURL):
            print("📗 Audio stored successfully \(downloadURL).")
            strongSelf.audioURL = downloadURL
            strongSelf.progressCompleted+=1
            strongSelf.progressView.progress = (strongSelf.progressCompleted/strongSelf.totalProgress)
            print("\(strongSelf.progressCompleted) out of \(strongSelf.totalProgress)")
            completion(nil)
            return
        case .failure(let error):
            print("Storage manager error: \(error.localizedDescription)")
            return
            }
        })
    }
    
    func uploadImage(completion: @escaping ((Error?) -> Void)) {
        var imageNil:UIImage!
        DispatchQueue.main.async {[weak self]  in
            guard let strongSelf = self else {return}
            imageNil = strongSelf.beatImage.image
        }
        if imageNil == nil {
            let path = "Image Defaults/tonedeaflogoblackback.png"
            StorageManager.shared.getDownloadURL(path, completion: {[weak self] result in
                guard let strongSelf = self else {return}
                switch result {
                case .success(let url):
                    strongSelf.imageURL = url
                    print("📗 Image stored successfully \(StorageManager.imageURL).")
                    strongSelf.progressCompleted+=1
                    strongSelf.progressView.progress = (strongSelf.progressCompleted/strongSelf.totalProgress)
                    print("\(strongSelf.progressCompleted) out of \(strongSelf.totalProgress)")
                    completion(nil)
                case .failure(let error):
                    print("Storage manager error: \(error)")
                }
            })
        } else {
            guard let image = imageNil, let data = image.pngData() else {return}
            let fileName = "\(beatContentTag)--\(tDAppId)"
            StorageManager.shared.uploadImage(with: data, fileName: fileName, completion: {[weak self] result in
                guard let strongSelf = self else {return}
                switch result {
                case.success(let downloadURL):
                    print("📗 Image stored successfully \(StorageManager.imageURL).")
                    strongSelf.imageURL = downloadURL
                    strongSelf.progressCompleted+=1
                    strongSelf.progressView.progress = (strongSelf.progressCompleted/strongSelf.totalProgress)
                    print("\(strongSelf.progressCompleted) out of \(strongSelf.totalProgress)")
                    completion(nil)
                    return
                case .failure(let error):
                    print("Storage manager error: \(error)")
                    return
                }
            })
        }
    }
    
    //MARK: - Storing Data
    func saveBeatInfoToDatabase() {
        let beatqueue2 = DispatchQueue(label: "myhjbeats2hjfktyhdikhQueue")
        let beatgroup2 = DispatchGroup()
        var array:[Int] = [1,2,3,4]
        if textFieldSoundcloud.text != "" {
            totalProgress+=1
            array.append(5)
        }
        for i in array {
            beatgroup2.enter()
            beatqueue2.async { [weak self] in
                guard let strongSelf = self else {return}
                switch i {
                case 1:
                    strongSelf.uploadCompletionStatus3 = false
                    strongSelf.requiredData(completion: { error in
                        if let error = error {
                            Utilities.showError2("required Store Failed: \(error)", actionText: "OK")
                            mediumImpactGenerator.impactOccurred()
                            strongSelf.uploadCompletionStatus3 = false
                            return
                        }
                        else {
                            strongSelf.uploadCompletionStatus3 = true
                            print("required Store done \(i)")
                        }
                        beatgroup2.leave()
                    })
                case 2:
                    strongSelf.uploadCompletionStatus4 = false
                    strongSelf.storeAllContentId(completion: { error in
                        if let error = error {
                            Utilities.showError2("All Content Store Failed: \(error)", actionText: "OK")
                            mediumImpactGenerator.impactOccurred()
                            strongSelf.uploadCompletionStatus4 = false
                            return
                        }
                        else {
                            strongSelf.uploadCompletionStatus4 = true
                            print("All Content Store done \(i)")
                        }
                        beatgroup2.leave()
                    })
                case 3:
                    strongSelf.uploadCompletionStatus5 = false
                    strongSelf.storeBeatId(completion: { error in
                        if let error = error {
                            Utilities.showError2("All Beat Store Failed: \(error)", actionText: "OK")
                            mediumImpactGenerator.impactOccurred()
                            strongSelf.uploadCompletionStatus5 = false
                            return
                        }
                        else {
                            strongSelf.uploadCompletionStatus5 = true
                            print("All Beat Store done \(i)")
                        }
                        beatgroup2.leave()
                    })
                case 4:
                    strongSelf.uploadCompletionStatus6 = false
                    strongSelf.updatePersonBeats(completion: { error in
                        if let error = error {
                            Utilities.showError2("Update producer beats Failed: \(error)", actionText: "OK")
                            mediumImpactGenerator.impactOccurred()
                            strongSelf.uploadCompletionStatus6 = false
                            return
                        }
                        else {
                            strongSelf.uploadCompletionStatus6 = true
                            print("Update producer beats done \(i)")
                        }
                        beatgroup2.leave()
                    })
                case 5:
                    strongSelf.uploadCompletionStatus7 = false
                    strongSelf.storeSoundcloud(completion: { error in
                        if let error = error {
                            Utilities.showError2("soundcloud store Failed: \(error)", actionText: "OK")
                            mediumImpactGenerator.impactOccurred()
                            strongSelf.uploadCompletionStatus7 = false
                            return
                        }
                        else {
                            strongSelf.uploadCompletionStatus7 = true
                            print("soundcloud store done \(i)")
                        }
                        beatgroup2.leave()
                    })
                default:
                    print("beat oopsie")
                }
                
            }
            
        }
        beatgroup2.notify(queue: DispatchQueue.main) {[weak self] in
            guard let strongSelf = self else {return}
            if strongSelf.uploadCompletionStatus13 == false || strongSelf.uploadCompletionStatus4 == false || strongSelf.uploadCompletionStatus5 == false || strongSelf.uploadCompletionStatus6 == false || strongSelf.uploadCompletionStatus7 == false {
                
                Utilities.showError2("Upload Failed.", actionText: "OK")
                return
            } else {
                print("📗 Beat data saved to database successfully.")
                strongSelf.alertView.dismiss(animated: true, completion: {
                    Utilities.successBarBanner("Upload successful.")
                    _ = strongSelf.navigationController?.popViewController(animated: true)
                })
            }
        }
        
    }
    
    func requiredData(completion: @escaping ((Error?) -> Void)) {
        var coProducerArr:[String] = []
        for pro in producerArr {
            if !coProducerArr.contains(pro.toneDeafAppId) {
                coProducerArr.append(pro.toneDeafAppId)
            }
        }
        
        let SongRef = Database.database().reference().child("Beats").child(beatRandomKey)
        
        var beatInfoMap = [String : Any]()
        beatInfoMap = [
            "Tone Deaf App Id" : tDAppId,
            "Date" : currentDate,
            "Time" : currentTime,
            "Image" : imageURL!,
            "Audio" : audioURL!,
            "Category" : "Beats",
            "Name" : beatName,
            "Tempo" : beattempo,
            "Key" : key,
            "Price Type" : priceDetermination,
            "Number of Downloads" : numberOfDownloads,
            "Number of Favorites" : numberOfFavorites,
            "Duration": StorageManager.beatDuration,
            "Types": beatTypesArray,
            "Sounds": beatSoundsArray,
            "Producers": coProducerArr,
            "Videos": [],
            "Exclusive Price": exclusivePrice,
            "Lease Price": leasePrice,
            "Wav Price": wavPrice,
            "Active Status": false
        ]
        
        SongRef.updateChildValues(beatInfoMap) { [weak self] (error, ref) in
            guard let strongSelf = self else {return}
            if let error = error {
                print("📕 Failed to upload dictionary to database: \(error)")
                return
            } else {
                strongSelf.progressCompleted+=1
                strongSelf.progressView.progress = (strongSelf.progressCompleted/strongSelf.totalProgress)
                print("\(strongSelf.progressCompleted) out of \(strongSelf.totalProgress)")
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
                strongSelf.progressCompleted+=1
                strongSelf.progressView.progress = (strongSelf.progressCompleted/strongSelf.totalProgress)
                print("\(strongSelf.progressCompleted) out of \(strongSelf.totalProgress)")
                completion(nil)
            }
            else {
                let arr = ["\(strongSelf.tDAppId)"]
                Database.database().reference().child("All Content IDs").setValue(arr)
                strongSelf.progressCompleted+=1
                strongSelf.progressView.progress = (strongSelf.progressCompleted/strongSelf.totalProgress)
                print("\(strongSelf.progressCompleted) out of \(strongSelf.totalProgress)")
                completion(nil)
                return
            }
        })
    }
    
    func storeBeatId(completion: @escaping (Error?) -> Void) {
        Database.database().reference().child("Beats").child("All Beat IDs").observeSingleEvent(of: .value, with: {[weak self] snap in
            guard let strongSelf = self else {return}
            if !(snap.value is NSNull) {
                var arr = snap.value as! [String]
                arr.append("\(strongSelf.tDAppId)")
                Database.database().reference().child("Beats").child("All Beat IDs").setValue(arr)
                strongSelf.progressCompleted+=1
                strongSelf.progressView.progress = (strongSelf.progressCompleted/strongSelf.totalProgress)
                print("\(strongSelf.progressCompleted) out of \(strongSelf.totalProgress)")
                completion(nil)
            }
            else {
                let arr = ["\(strongSelf.tDAppId)"]
                Database.database().reference().child("Beats").child("All Beat IDs").setValue(arr)
                strongSelf.progressCompleted+=1
                strongSelf.progressView.progress = (strongSelf.progressCompleted/strongSelf.totalProgress)
                print("\(strongSelf.progressCompleted) out of \(strongSelf.totalProgress)")
                completion(nil)
                return
            }
        })
    }
    
    func updatePersonBeats(completion: @escaping ((Error?) -> Void)) {
        var count = 0
        for item in producerref {
            getProducerBeatsInDB(cat: item, completion: {[weak self] beats in
                guard let strongSelf = self else {return}
                var arr = beats
                arr.append(strongSelf.tDAppId)
                let ref = Database.database().reference().child("Registered Persons").child(item).child("Beats")
                ref.setValue(arr, withCompletionBlock: {(error, _) in
                    if let error = error {
                        completion(error)
                    }
                    else {
                        count+=1
                        if count == strongSelf.producerref.count {
                            strongSelf.progressCompleted+=1
                            strongSelf.progressView.progress = (strongSelf.progressCompleted/strongSelf.totalProgress)
                            print("\(strongSelf.progressCompleted) out of \(strongSelf.totalProgress)")
                            completion(nil)
                        }
                    }
                })
            })
        }
    }
    
    func storeSoundcloud(completion: @escaping ((Error?) -> Void)) {
        let url = textFieldSoundcloud.text!
        let soundcloudContentRandomKey = ("\(soundcloudMusicContentType)--\(beatName)--\(currentDate)--\(currentTime)")
        var SongInfoMap = [String : Any]()
        SongInfoMap = [
            "url" : url,
            "Active Status": false]
        
        let SongRef = Database.database().reference().child("Beats").child(beatRandomKey).child(soundcloudContentRandomKey)
        
        SongRef.updateChildValues(SongInfoMap) { [weak self] (error, songRef) in
            guard let strongSelf = self else {return}
            if let error = error {
                print("📕 Failed to upload dictionary to database: \(error)")
                Utilities.showError2("Failed to Upload. Please try again.", actionText: "OK")
                completion(error)
                return
            } else {
                strongSelf.progressCompleted+=1
                strongSelf.progressView.progress = (strongSelf.progressCompleted/strongSelf.totalProgress)
                print("\(strongSelf.progressCompleted) out of \(strongSelf.totalProgress)")
                completion(nil)
                return
            }
        }
    }
    
    //MARK: - Storing Helpers
    
    func getProducerRefs(completion: @escaping ((Error?) -> Void)) {
        var tick = 0
        for producer in producerArr {
            Database.database().reference().child("Registered Persons").observeSingleEvent(of: .value, with: {[weak self] snapshot in
                guard let strongSelf = self else {return}
                for produce in snapshot.children {

                    let data = produce as! DataSnapshot
                    let key = data.key
                    if data.key.contains(producer.toneDeafAppId) == true {
                        strongSelf.producerref.append(key)
                    }
                }
                tick+=1
                if tick == strongSelf.producerArr.count {
                    strongSelf.progressCompleted+=1
                    strongSelf.progressView.progress = (strongSelf.progressCompleted/strongSelf.totalProgress)
                    print("\(strongSelf.progressCompleted) out of \(strongSelf.totalProgress)")
                    completion(nil)
                }
            })
        }
    }
    
    func getProducerBeatsInDB(cat: String, completion: @escaping (Array<String>) -> Void) {
        let ref = Database.database().reference().child("Registered Persons").child(cat).child("Beats")
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
                completion(mysongsArray)
            } else {
                completion(mysongsArray)
            }
        })
    }
    
    //MARK: - Segues
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "uploadBeatToTonesPick" {
            if let viewController: SelectTonesPickItemViewController = segue.destination as? SelectTonesPickItemViewController {
                viewController.array = arr
                viewController.prevPage = "uploadBeat"
                switch arr {
                case "person":
                    viewController.exeptions = producerArr
                    viewController.uploadBeatProducersDelegate = self
                default:
                    break
                }
            }
        }
    }
    
    //MARK: - Utilities
    
    func addGrayBottomLineToText(_ textfield:UITextField) {
        let bottomLine = CALayer()

        bottomLine.frame = CGRect(x: 0,
                                  y: textfield.frame.height - 1,
                                  width: textfield.frame.size.width - 40,//textfield.frame.width,
                                  height: 2)

        bottomLine.backgroundColor = UIColor.darkGray.cgColor 

        textfield.layer.addSublayer(bottomLine)
    }
    
    func dismissKeyboardOnTap() {
        let tap = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        scrollview.keyboardDismissMode = .onDrag
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @objc func dismissKeyboard2() {
        
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

extension BeatUploadViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == textFieldBeatName {
            textFieldBeatFile.becomeFirstResponder()
        }
        else if textField == textFieldBeatFile {
            view.endEditing(true)
            return false
        } else if textField == textFieldLeasePrice {
             textFieldWavPrice.becomeFirstResponder()
        } else if textField == textFieldWavPrice {
            textFieldExclusivePrice.becomeFirstResponder()
        } else if textField == textFieldExclusivePrice {
            view.endEditing(true)
            return false
        }
        
        return true
    }
}

extension BeatUploadViewController: UIImagePickerControllerDelegate {
    
    func presentPhotoActionSheet() {
        let actionSheet = UIAlertController(title: "Open photo library?", message: nil, preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
        actionSheet.addAction(UIAlertAction(title: "Yes", style: .default, handler: { [weak self] _ in
            self?.openGallery()
        
        }))
        present(actionSheet, animated: true)
    }
    
    func openGallery() {
        let vc = UIImagePickerController()
        vc.sourceType = .photoLibrary
        vc.delegate = self
        vc.allowsEditing = true
        present(vc, animated: true)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        print("📙 \(info)")
        guard let selectedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else {
            return
        }
        
       beatImage.image = selectedImage
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
}

extension BeatUploadViewController: UIDocumentPickerDelegate {
    
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
        print(newUrls)
        print(newUrls.first)
        
        
        selectedFileURL = newUrls.first
        guard selectedFileURL == newUrls.first else { 
            return
        }
        
        dataAudio = selectedFileURL
        
        let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let sandboxFileURL = dir.appendingPathComponent(selectedFileURL!.lastPathComponent)
        
        if FileManager.default.fileExists(atPath: sandboxFileURL.path) {
            //print("\(sandboxFileURL.lastPathComponent) already already Exists")
            textFieldBeatFile.text = selectedFileURL!.lastPathComponent as String
            textFieldBeatName.text = selectedFileURL!.lastPathComponent as String
        }
        else {
            do {
                try FileManager.default.copyItem(at: selectedFileURL!, to: sandboxFileURL)
                textFieldBeatFile.text = selectedFileURL!.lastPathComponent as String
                textFieldBeatName.text = selectedFileURL!.lastPathComponent as String
                //print("📗 \(textFieldBeatFile.text!)")
            }
            catch {
                
                print("Error: \(error)")
            }
        }
    }
    
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        
    }
}

extension BeatUploadViewController:  UIPickerViewDataSource, UIPickerViewDelegate {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        var number = 0
        if pickerView == beatKeyPickerView {
            number = keys.count
        } else if pickerView == beatTempoPickerView {
            number = tempo.count
        }
        return number
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        var number = ""
        if pickerView == beatKeyPickerView {
            number = keys[row]
        } else if pickerView == beatTempoPickerView {
            number = String (tempo[row])
        }
        return number
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == beatKeyPickerView {
            textFieldBeatKey.text = keys[row]
        } else if pickerView == beatTempoPickerView {
            textFieldTempo.text = String (tempo[row])
        }
    }
    
    func pickerViewToolbar(textField:UITextField, pickerView:UIPickerView) {
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor.init(red: 182/255, green: 0/255, blue: 3/255, alpha: 1)
        toolBar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.done, target: self, action: #selector(dismissKeyboard))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItem.Style.plain, target: self, action: #selector(dismissKeyboard))

        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true

        textField.inputView = pickerView
        textField.inputAccessoryView = toolBar
    }
}

extension BeatUploadViewController : UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch tableView {
        case producerTableView:
            return producerArr.count
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch tableView {
        case producerTableView:
            let cell = tableView.dequeueReusableCell(withIdentifier: "beatUploadProducerCell", for: indexPath) as! BeatUploadProducerCell
            if !producerArr.isEmpty {
                cell.setUp(person: producerArr[indexPath.row])
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
            case producerTableView:
                producerArr.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
                producerHeightConstraint.constant = CGFloat(50*(producerArr.count))
            default:
                break
            }
        }
    }
    
    
}
import MarqueeLabel

class BeatUploadProducerCell: UITableViewCell {
    
    @IBOutlet weak var view: UIView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var error: MarqueeLabel!
    @IBOutlet weak var appid: UILabel!
    @IBOutlet weak var artwork: UIImageView!
    
    var errorView:UIView!
    
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        artwork.image = nil
        name.text = ""
        if errorView != nil {
            errorView.removeFromSuperview()
            errorView = nil
        }
    }
    
    func setUp(person: PersonData) {
        name.text = person.name
        appid.text = "App ID: \(person.toneDeafAppId)"
        if let _ = person.legalName {
            error.text = ""
        } else {
            error.text = "Legal Name needed"
            errorView = UIView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height))
            errorView.backgroundColor = Constants.Colors.redApp
            errorView.alpha = 0.2
            view.addSubview(errorView)
            view.sendSubviewToBack(errorView)
        }
        GlobalFunctions.shared.selectImageURL(person: person, completion: {[weak self] aimage in
            guard let strongSelf = self else {return}
            guard let img = aimage else {
                let defaultimg = UIImage(named: "defaultuser")!
                strongSelf.artwork.image = defaultimg
                return
            }
            let imageURL = URL(string: img)!
            if let cachedImage = imageCache.object(forKey: imageURL.absoluteString as NSString) {
                strongSelf.artwork.image = cachedImage
                return
            } else {
                strongSelf.artwork.setImage(from: imageURL, withPlaceholder: UIImage(named: "tonedeaflogo"))
                return
            }
        })
    }
}


class CurrencyTextField: UITextField {

    /// The numbers that have been entered in the text field
    private var enteredNumbers = ""

    private var didBackspace = false

    var locale: Locale = .current

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    private func commonInit() {
        addTarget(self, action: #selector(editingChanged), for: .editingChanged)
    }

    override func deleteBackward() {
        enteredNumbers = String(enteredNumbers.dropLast())
        text = enteredNumbers.asCurrency(locale: locale)
        // Call super so that the .editingChanged event gets fired, but we need to handle it differently, so we set the `didBackspace` flag first
        didBackspace = true
        super.deleteBackward()
    }

    @objc func editingChanged() {
        defer {
            didBackspace = false
            text = enteredNumbers.asCurrency(locale: locale)
        }

        guard didBackspace == false else { return }

        if let lastEnteredCharacter = text?.last, lastEnteredCharacter.isNumber {
            enteredNumbers.append(lastEnteredCharacter)
        }
    }
}

extension Formatter {
    static let currency: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        return formatter
    }()
}

extension String {
    func asCurrency(locale: Locale) -> String? {
        Formatter.currency.locale = locale
        if self.isEmpty {
            return Formatter.currency.string(from: NSNumber(value: 0))
        } else {
            return Formatter.currency.string(from: NSNumber(value: (Double(self) ?? 0) / 100))
        }
    }
}
