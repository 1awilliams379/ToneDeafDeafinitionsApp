//
//  PaidBeatsViewController.swift
//  ToneDeafDeafinitionsApp
//
//  Created by Tone Deaf on 8/2/20.
//  Copyright © 2020 GITEM Solutions. All rights reserved.
//

import UIKit
import FirebaseDatabase
import SideMenu
import BEMCheckBox
import MultiSlider
import BadgeSwift
import AVFoundation

let paidsortMenu = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "paidSortMenuNavController") as SideMenuNavigationController
let paidfilterMenu = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "paidFilterMenuNavController") as SideMenuNavigationController

//Sort
let PaidBeatSortUpdatedNotificationKey = "com.gitemsolutions.paidsortUpdated"

let PaidSortChangedNotify = Notification.Name(PaidBeatSortUpdatedNotificationKey)

var paidlastTempoChoiceChanged = 0
var paidcurrentTempoChoiceChanged = 0
var paidsortNumberForFilter = 0
var paidnumberOfActiveFilterCells = 0

class PaidBeatsViewController: UIViewController {
    
    static let shared = PaidBeatsViewController()
    
//    var player: AVAudioPlayer?
    //let audioPlayerViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "audioPlayerVC") as AudioPlayerViewController
    
    @IBOutlet weak var paidBeatTableView: UITableView!
    @IBOutlet weak var paidBeatSearchBar: UISearchBar!
    @IBOutlet weak var filteredResultsLabel: UILabel!

    public var initialBeats: [BeatData] = []
    public var filteredBeats: [BeatData] = []
    public var filteredSetUpBeats: [BeatData] = []
    public var searchedBeats:[BeatData] = []
    
    public var tempoSelectedArray: [BeatData] = []
    public var keySelectedArray: [BeatData] = []
    public var typeSelectedArray: [BeatData] = []
        public var typeSubArray: [BeatData] = []
            public var darkTypeArray: [BeatData] = []
            public var melodicTypeArray: [BeatData] = []
            public var aggressiveTypeArray: [BeatData] = []
            public var smoothTypeArray: [BeatData] = []
            public var rAndBTypeArray: [BeatData] = []
            public var vibeyTypeArray: [BeatData] = []
            public var clubTypeArray: [BeatData] = []
            public var joyfulTypeArray: [BeatData] = []
            public var soulfulTypeArray: [BeatData] = []
            public var experimentalTypeArray: [BeatData] = []
            public var relaxedTypeArray: [BeatData] = []
            public var calmTypeArray: [BeatData] = []
            public var epicTypeArray: [BeatData] = []
            public var simpleTypeArray: [BeatData] = []
            public var trapTypeArray: [BeatData] = []
    public var soundsSelectedArray: [BeatData] = []
        public var soundsSubArray: [BeatData] = []
            public var keysSoundArray: [BeatData] = []
            public var pianoAcousticSoundArray: [BeatData] = []
            public var pianoVinylSoundArray: [BeatData] = []
            public var pianoElectricSoundArray: [BeatData] = []
            public var pianoRhodesSoundArray: [BeatData] = []
            public var organSoundArray: [BeatData] = []
            public var theraminSoundArray: [BeatData] = []
            public var whistleSoundArray: [BeatData] = []
            public var hornsSoundArray: [BeatData] = []
            public var stringsSoundArray: [BeatData] = []
            public var fluteSoundArray: [BeatData] = []
            public var padBellSoundArray: [BeatData] = []
            public var padHollowSoundArray: [BeatData] = []
            public var padAggressiveSoundArray: [BeatData] = []
            public var choirSoundArray: [BeatData] = []
            public var saxophoneSoundArray: [BeatData] = []
            public var guitarElectricSoundArray: [BeatData] = []
            public var guitarAcousticSoundArray: [BeatData] = []
            public var guitarSteelSoundArray: [BeatData] = []
            public var bellsEDMSoundArray: [BeatData] = []
            public var bellsVinylSoundArray: [BeatData] = []
            public var bellsGothicSoundArray: [BeatData] = []
            public var bellsHollowSoundArray: [BeatData] = []
            public var bellsMusicBoxSoundArray: [BeatData] = []
            public var sampleVocalSoundArray: [BeatData] = []
            public var sampleSongSoundArray: [BeatData] = []
            public var noKickSoundArray: [BeatData] = []
            public var kickSoundArray: [BeatData] = []
            public var long808SoundArray: [BeatData] = []
            public var short808SoundArray: [BeatData] = []
            public var clean808SoundArray: [BeatData] = []
            public var distorted808SoundArray: [BeatData] = []
            public var moogBassSoundArray: [BeatData] = []
            public var subBassSoundArray: [BeatData] = []
            public var synthBassDistortedSoundArray: [BeatData] = []
            public var snapSoundArray: [BeatData] = []
            public var synthBassDeepSoundArray: [BeatData] = []
    public var producerSelectedArray: [BeatData] = []
    //public var currentFilteredBeats: [BeatData] = []
    @IBOutlet weak var tableViewBottomConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableViewBottomConstraint.constant = 73.5
        
        print("📙 acctype: \(accountType)")
        add()
        paidBeatSearchBar.delegate = self
        paidBeatTableView.delegate = self
        paidBeatTableView.dataSource = self
        
        SideMenuManager.default.rightMenuNavigationController = paidfilterMenu
        SideMenuManager.default.addPanGestureToPresent(toView: self.view)
        paidfilterMenu.setNavigationBarHidden(true, animated: false)
        paidfilterMenu.presentationStyle = .viewSlideOutMenuIn
        
        SideMenuManager.default.leftMenuNavigationController = paidsortMenu
        SideMenuManager.default.addPanGestureToPresent(toView: self.view)
        paidsortMenu.setNavigationBarHidden(true, animated: false)
        paidsortMenu.presentationStyle = .viewSlideOutMenuIn
        
        dismissKeyboardOnTap()
        
        if currentAppUser.accountType != CreatorAccount {
            let blurEffect = UIBlurEffect(style: .dark)
            let blurEffectView = UIVisualEffectView(effect: blurEffect)
            blurEffectView.frame = view.frame
            view.addSubview(blurEffectView)
            return
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        SideMenuManager.default.rightMenuNavigationController = paidfilterMenu
        paidfilterMenu.setNavigationBarHidden(true, animated: false)
        paidfilterMenu.presentationStyle = .viewSlideOutMenuIn
        
        SideMenuManager.default.leftMenuNavigationController = paidsortMenu
        paidsortMenu.setNavigationBarHidden(true, animated: false)
        paidsortMenu.presentationStyle = .viewSlideOutMenuIn
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
        print("📗beats controller Deallocated")
    }

    
    func add(){
        
        Database.database().reference().child("Beats").child("Paid").observeSingleEvent(of: .value, with: { snapshot in
            FilteringManager.shared.paidsetupArrayForBeatsTableView(snapshot: snapshot, completion: {[weak self] tempbeats in
                guard let strongSelf = self else {return}
    
                strongSelf.createObservers()
                strongSelf.initialBeats = tempbeats
                strongSelf.tempoSelectedArray = strongSelf.initialBeats
                strongSelf.keySelectedArray = strongSelf.initialBeats
                strongSelf.typeSelectedArray = strongSelf.initialBeats
                strongSelf.soundsSelectedArray = strongSelf.initialBeats
                strongSelf.producerSelectedArray = strongSelf.initialBeats
                strongSelf.filteredBeats = tempbeats
                strongSelf.filteredBeats.sort(by: { $0.datetime > $1.datetime})
                DispatchQueue.main.async { [weak self] in
                    guard let strongSelf = self else {return}
                    strongSelf.paidBeatTableView.reloadData()
                }
            })
            
        })
    }
    
    func createObservers(){
        //sort
        NotificationCenter.default.addObserver(self, selector: #selector(PaidBeatsViewController.paidBeatSort), name: PaidSortChangedNotify, object: nil)
        //tempo
        NotificationCenter.default.addObserver(self, selector: #selector(PaidBeatsViewController.tempoFilterMin), name: PaidFilterTempoMinNotify, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(PaidBeatsViewController.tempoFilterMax), name: PaidFilterTempoMaxNotify, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(PaidBeatsViewController.tempoFilterSpecified), name: PaidFilterTempoSpecifiedNotify, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(PaidBeatsViewController.tempoFilterStatus), name: PaidFilterTempoStatusNotify, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(PaidBeatsViewController.tempoFilterReset), name: PaidFilterTempoResetNotify, object: nil)
        //key
        NotificationCenter.default.addObserver(self, selector: #selector(PaidBeatsViewController.keyFilterUpdate), name: PaidFilterKeyChangedNotify, object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(FreeBeatsViewController.keyFilterAddUpdate), name: FilterKeyAddChangedNotify, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(PaidBeatsViewController.keyFilterReset), name: PaidFilterKeyPickerResetNotify, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector (PaidBeatsViewController.keyFilterStatus), name: PaidFilterKeyStatusNotify, object: nil)
        //type
        NotificationCenter.default.addObserver(self, selector: #selector(PaidBeatsViewController.typeFilterStatus), name: PaidFilterTypeStatusNotify, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(PaidBeatsViewController.typeFilterUpdate), name: PaidFilterTypeChangedNotify, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(PaidBeatsViewController.typeFilterReset), name: PaidFilterTypeResetNotify, object: nil)
        //type
        NotificationCenter.default.addObserver(self, selector: #selector(PaidBeatsViewController.soundsFilterStatus), name: PaidFilterSoundsStatusNotify, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(PaidBeatsViewController.soundsFilterUpdate), name: PaidFilterSoundsChangedNotify, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(PaidBeatsViewController.soundsFilterReset), name: PaidFilterSoundsResetNotify, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(refresh), name: ExpandCartHeightNotify, object: nil)
        
    }
    
    @objc func refresh() {
        paidBeatTableView.reloadData()
        view.layoutSubviews()
    }
    
    //MARK: - Tempo Updates
    @objc func tempoFilterMin(notification: NSNotification) {
        paidlastTempoChoiceChanged = 0
        print("Last tempo choiced used is slider: = \(paidlastTempoChoiceChanged)")
        let slidervalue = notification.object as! Int
        FilteringManager.shared.filterByTempoPaid(slidervalue: slidervalue, thumb: 0, completion: {[weak self] filteredtempbeats in
            guard let strongSelf = self else {
                return
            }
            strongSelf.tempoSelectedArray = filteredtempbeats
            if paidnumberOfActiveFilterCells == 1{
                strongSelf.filteredBeats = strongSelf.tempoSelectedArray
            } else if paidnumberOfActiveFilterCells > 1 {
                strongSelf.filteredBeats = filteredtempbeats
                for beat in strongSelf.filteredBeats
                {
                    if !strongSelf.keySelectedArray.contains(beat)&&paidkeyfliteringCode==1 || !strongSelf.typeSelectedArray.contains(beat)&&paidtypefilteringCode==1 || !strongSelf.soundsSelectedArray.contains(beat)&&paidsoundsfilteringCode==1 || !strongSelf.producerSelectedArray.contains(beat)&&paidproducersfilteringCode==1
                    {
                       let index = strongSelf.filteredBeats.firstIndex{$0 === beat}
                       if index != nil {
                           strongSelf.filteredBeats.remove(at: index!)
                       }
                    }
                    
                }
            }
            strongSelf.reSortFilteredBeats()
            strongSelf.paidBeatTableView.reloadData()
        })
    }
    
    @objc func tempoFilterMax(notification: NSNotification) {
        paidlastTempoChoiceChanged = 0
        print("Last tempo choiced used is slider: = \(paidlastTempoChoiceChanged)")
        let slidervalue = (notification.object) as! Int
        FilteringManager.shared.filterByTempoPaid(slidervalue: slidervalue, thumb: 1, completion: {[weak self] filteredtempbeats in
            guard let strongSelf = self else {
                return
            }
            strongSelf.tempoSelectedArray = filteredtempbeats
            if paidnumberOfActiveFilterCells == 1{
                strongSelf.filteredBeats = strongSelf.tempoSelectedArray
            } else if paidnumberOfActiveFilterCells > 1 {
                strongSelf.filteredBeats = filteredtempbeats
                for beat in strongSelf.filteredBeats
                {
                    if !strongSelf.keySelectedArray.contains(beat)&&paidkeyfliteringCode==1 || !strongSelf.typeSelectedArray.contains(beat)&&paidtypefilteringCode==1 || !strongSelf.soundsSelectedArray.contains(beat)&&paidsoundsfilteringCode==1 || !strongSelf.producerSelectedArray.contains(beat)&&paidproducersfilteringCode==1
                    {
                       let index = strongSelf.filteredBeats.firstIndex{$0 === beat}
                       if index != nil {
                           strongSelf.filteredBeats.remove(at: index!)
                       }
                    }
                    
                }
            }
            strongSelf.reSortFilteredBeats()
            strongSelf.paidBeatTableView.reloadData()
        })
    }
    
    @objc func tempoFilterSpecified(notification: NSNotification) {
        paidlastTempoChoiceChanged = 1
        print("Last tempo choiced used is exact: = \(paidlastTempoChoiceChanged)")
        let selectedTempo = (notification.object) as! Int
        FilteringManager.shared.filterByTempoPaidSpecified(tempo: selectedTempo, completion: {[weak self] filteredtempbeats in
            guard let strongSelf = self else {
                return
            }
            strongSelf.tempoSelectedArray = filteredtempbeats
            if paidnumberOfActiveFilterCells == 1{
                strongSelf.filteredBeats = strongSelf.tempoSelectedArray
            } else if paidnumberOfActiveFilterCells > 1 {
                strongSelf.filteredBeats = filteredtempbeats
                for beat in strongSelf.filteredBeats
                {
                    if !strongSelf.keySelectedArray.contains(beat)&&paidkeyfliteringCode==1 || !strongSelf.typeSelectedArray.contains(beat)&&paidtypefilteringCode==1 || !strongSelf.soundsSelectedArray.contains(beat)&&paidsoundsfilteringCode==1 || !strongSelf.producerSelectedArray.contains(beat)&&paidproducersfilteringCode==1
                    {
                       let index = strongSelf.filteredBeats.firstIndex{$0 === beat}
                       if index != nil {
                           strongSelf.filteredBeats.remove(at: index!)
                       }
                    }
                    
                }
            }
            strongSelf.reSortFilteredBeats()
            strongSelf.paidBeatTableView.reloadData()
        })
    }
    
    
    
    
    
    //MARK: - Key Updates
    
    
    @objc func keyFilterUpdate(notification: NSNotification) {
        let selectedkey = notification.object as! String
        FilteringManager.shared.filterByKeyPaid(key: selectedkey, completion: {[weak self] filteredkeybeats in
            guard let strongSelf = self else {
                return
            }
            strongSelf.keySelectedArray = filteredkeybeats
            if paidnumberOfActiveFilterCells == 1{
                strongSelf.filteredBeats = strongSelf.keySelectedArray
            }
            else if paidnumberOfActiveFilterCells > 1 {
                strongSelf.filteredBeats = filteredkeybeats
                for beat in strongSelf.filteredBeats
                {
                    if !strongSelf.tempoSelectedArray.contains(beat)&&paidtempofilteringCode==1 || !strongSelf.typeSelectedArray.contains(beat)&&paidtypefilteringCode==1 || !strongSelf.soundsSelectedArray.contains(beat)&&paidsoundsfilteringCode==1 || !strongSelf.producerSelectedArray.contains(beat)&&paidproducersfilteringCode==1
                    {
                       let index = strongSelf.filteredBeats.firstIndex{$0 === beat}
                       if index != nil {
                           strongSelf.filteredBeats.remove(at: index!)
                       }
                    }
                    
                }
            }
            strongSelf.reSortFilteredBeats()
            strongSelf.paidBeatTableView.reloadData()
        })
    }
    
    //MARK: - Type Updates
    
    @objc func typeFilterUpdate(notification: NSNotification) {
        var pickedCode = 1000
        var pickedArray:[BeatData] = []
        let selectedtype = notification.object as! String
        FilteringManager.shared.filterByTypePaid(type: selectedtype, completion: { [weak self] filteredtypebeats in
            guard let strongSelf = self else {
                return
            }
            switch selectedtype {
            case "Dark":
                strongSelf.darkTypeArray = filteredtypebeats
                pickedCode = paiddarkTypeFilteringCode
            case "Melodic":
                strongSelf.melodicTypeArray = filteredtypebeats
                pickedCode = paidmelodicTypeFilteringCode
            case "Aggressive":
                strongSelf.aggressiveTypeArray = filteredtypebeats
                pickedCode = paidaggressiveTypeFilteringCode
            case "Smooth":
                strongSelf.smoothTypeArray = filteredtypebeats
                pickedCode = paidsmoothTypeFilteringCode
            case "R&B":
                strongSelf.rAndBTypeArray = filteredtypebeats
                pickedCode = paidrAndBTypeFilteringCode
            case "Vibey":
                strongSelf.vibeyTypeArray = filteredtypebeats
                pickedCode = paidvibeyTypeFilteringCode
            case "Club":
                strongSelf.clubTypeArray = filteredtypebeats
                pickedCode = paidclubTypeFilteringCode
            case "Joyful":
                strongSelf.joyfulTypeArray = filteredtypebeats
                pickedCode = paidjoyfulTypeFilteringCode
            case "Soulful":
                strongSelf.soulfulTypeArray = filteredtypebeats
                pickedCode = paidsoulfulTypeFilteringCode
            case "Experimental":
                strongSelf.experimentalTypeArray = filteredtypebeats
                pickedCode = paidexperimentalTypeFilteringCode
            case "Relaxed":
                strongSelf.relaxedTypeArray = filteredtypebeats
                pickedCode = paidrelaxedTypeFilteringCode
            case "Calm":
                strongSelf.calmTypeArray = filteredtypebeats
                pickedCode = paidcalmTypeFilteringCode
            case "Epic":
                strongSelf.epicTypeArray = filteredtypebeats
                pickedCode = paidepicTypeFilteringCode
            case "Simple":
                strongSelf.simpleTypeArray = filteredtypebeats
                pickedCode = paidsimpleTypeFilteringCode
            case "Trap":
                strongSelf.trapTypeArray = filteredtypebeats
                pickedCode = paidtrapTypeFilteringCode
            default:
                print("Error finding array type to pace in subtype array.")
            }
            if paidnumberOfActiveFilterCells == 0 {
                strongSelf.filteredBeats = strongSelf.initialBeats
            }
            if paidnumberOfActiveFilterCells == 1 {
                if pickedCode == 1 {
                    if paidallTypeFilteringCode == 1 {
                        strongSelf.typeSelectedArray = filteredtypebeats
                    }
                    if paidallTypeFilteringCode > 1 {
                        for beattt in strongSelf.typeSelectedArray {
                            if paiddarkTypeFilteringCode == 1 && !strongSelf.darkTypeArray.contains(beattt) || paidmelodicTypeFilteringCode == 1 && !strongSelf.melodicTypeArray.contains(beattt) || paidaggressiveTypeFilteringCode == 1 && !strongSelf.aggressiveTypeArray.contains(beattt) || paidsmoothTypeFilteringCode == 1 && !strongSelf.smoothTypeArray.contains(beattt) || paidrAndBTypeFilteringCode == 1 && !strongSelf.rAndBTypeArray.contains(beattt) || paidvibeyTypeFilteringCode == 1 && !strongSelf.vibeyTypeArray.contains(beattt) || paidclubTypeFilteringCode == 1 && !strongSelf.clubTypeArray.contains(beattt) || paidjoyfulTypeFilteringCode == 1 && !strongSelf.joyfulTypeArray.contains(beattt) || paidsoulfulTypeFilteringCode == 1 && !strongSelf.soulfulTypeArray.contains(beattt) || paidexperimentalTypeFilteringCode == 1 && !strongSelf.experimentalTypeArray.contains(beattt) || paidrelaxedTypeFilteringCode == 1 && !strongSelf.relaxedTypeArray.contains(beattt) || paidcalmTypeFilteringCode == 1 && !strongSelf.calmTypeArray.contains(beattt) || paidepicTypeFilteringCode == 1 && !strongSelf.epicTypeArray.contains(beattt) || paidsimpleTypeFilteringCode == 1 && !strongSelf.simpleTypeArray.contains(beattt) || paidtrapTypeFilteringCode == 1 && !strongSelf.trapTypeArray.contains(beattt) {
                                let index = strongSelf.typeSelectedArray.firstIndex{$0 === beattt}
                                if index != nil {
                                    strongSelf.typeSelectedArray.remove(at: index!)
                                }
                            }
                        }
                    }
                    strongSelf.filteredBeats = strongSelf.typeSelectedArray
                } else if pickedCode == 0 {
                    if paidallTypeFilteringCode == 0 {
                        strongSelf.filteredBeats = []
                        if paidkeyfliteringCode == 1 {
                            for beat in strongSelf.keySelectedArray {
                                if paidsoundsfilteringCode==1&&strongSelf.soundsSelectedArray.contains(beat) || paidtempofilteringCode==1&&strongSelf.tempoSelectedArray.contains(beat) || paidproducersfilteringCode==1&&strongSelf.producerSelectedArray.contains(beat) {
                                    if !strongSelf.filteredBeats.contains(beat) {
                                        strongSelf.filteredBeats.append(beat)
                                    }
                                } else if !strongSelf.filteredBeats.contains(beat) {
                                    strongSelf.filteredBeats.append(beat)
                                }
                            }
                        }
                        if paidsoundsfilteringCode == 1 {
                            for beat in strongSelf.soundsSelectedArray {
                                if paidkeyfliteringCode==1&&strongSelf.keySelectedArray.contains(beat) || paidtempofilteringCode==1&&strongSelf.tempoSelectedArray.contains(beat) || paidproducersfilteringCode==1&&strongSelf.producerSelectedArray.contains(beat) {
                                    if !strongSelf.filteredBeats.contains(beat) {
                                        strongSelf.filteredBeats.append(beat)
                                    }
                                } else if !strongSelf.filteredBeats.contains(beat) {
                                    strongSelf.filteredBeats.append(beat)
                                }
                            }
                        }
                        if paidtempofilteringCode == 1 {
                            for beat in strongSelf.tempoSelectedArray {
                                if paidsoundsfilteringCode==1&&strongSelf.soundsSelectedArray.contains(beat) || paidkeyfliteringCode==1&&strongSelf.keySelectedArray.contains(beat) || paidproducersfilteringCode==1&&strongSelf.producerSelectedArray.contains(beat) {
                                    if !strongSelf.filteredBeats.contains(beat) {
                                        strongSelf.filteredBeats.append(beat)
                                    }
                                } else if !strongSelf.filteredBeats.contains(beat) {
                                    strongSelf.filteredBeats.append(beat)
                                }
                            }
                        }
                        if paidproducersfilteringCode == 1 {
                            for beat in strongSelf.producerSelectedArray {
                                if paidsoundsfilteringCode==1&&strongSelf.soundsSelectedArray.contains(beat) || paidtempofilteringCode==1&&strongSelf.tempoSelectedArray.contains(beat) || paidkeyfliteringCode==1&&strongSelf.keySelectedArray.contains(beat) {
                                    if !strongSelf.filteredBeats.contains(beat) {
                                        strongSelf.filteredBeats.append(beat)
                                    }
                                } else if !strongSelf.filteredBeats.contains(beat) {
                                    strongSelf.filteredBeats.append(beat)
                                }
                            }
                        }
                    } else if paidallTypeFilteringCode > 0{
                        strongSelf.typeSelectedArray = []
                        if paiddarkTypeFilteringCode == 1 {
                            pickedArray = strongSelf.darkTypeArray
                        } else if paidmelodicTypeFilteringCode == 1 {
                            pickedArray = strongSelf.melodicTypeArray
                        } else if paidaggressiveTypeFilteringCode == 1 {
                            pickedArray = strongSelf.aggressiveTypeArray
                        } else if paidsmoothTypeFilteringCode == 1 {
                            pickedArray = strongSelf.smoothTypeArray
                        } else if paidrAndBTypeFilteringCode == 1 {
                            pickedArray = strongSelf.rAndBTypeArray
                        } else if paidvibeyTypeFilteringCode == 1 {
                            pickedArray = strongSelf.vibeyTypeArray
                        } else if paidclubTypeFilteringCode == 1 {
                            pickedArray = strongSelf.clubTypeArray
                        } else if paidjoyfulTypeFilteringCode == 1 {
                            pickedArray = strongSelf.joyfulTypeArray
                        } else if paidsoulfulTypeFilteringCode == 1 {
                            pickedArray = strongSelf.soulfulTypeArray
                        } else if paidexperimentalTypeFilteringCode == 1 {
                            pickedArray = strongSelf.experimentalTypeArray
                        } else if paidrelaxedTypeFilteringCode == 1 {
                            pickedArray = strongSelf.relaxedTypeArray
                        } else if paidcalmTypeFilteringCode == 1 {
                            pickedArray = strongSelf.calmTypeArray
                        } else if paidepicTypeFilteringCode == 1 {
                            pickedArray = strongSelf.epicTypeArray
                        } else if paidsimpleTypeFilteringCode == 1 {
                            pickedArray = strongSelf.simpleTypeArray
                        } else if paidtrapTypeFilteringCode == 1 {
                            pickedArray = strongSelf.trapTypeArray
                        }
                        strongSelf.typeSelectedArray.append(contentsOf: pickedArray)
                        if paidallTypeFilteringCode == 1 {
                            strongSelf.filteredBeats = strongSelf.typeSelectedArray
                        }
                        if paidallTypeFilteringCode > 1 {
                            for beattt in strongSelf.typeSelectedArray {
                                if paiddarkTypeFilteringCode == 1 && !strongSelf.darkTypeArray.contains(beattt) || paidmelodicTypeFilteringCode == 1 && !strongSelf.melodicTypeArray.contains(beattt) || paidaggressiveTypeFilteringCode == 1 && !strongSelf.aggressiveTypeArray.contains(beattt) || paidsmoothTypeFilteringCode == 1 && !strongSelf.smoothTypeArray.contains(beattt) || paidrAndBTypeFilteringCode == 1 && !strongSelf.rAndBTypeArray.contains(beattt) || paidvibeyTypeFilteringCode == 1 && !strongSelf.vibeyTypeArray.contains(beattt) || paidclubTypeFilteringCode == 1 && !strongSelf.clubTypeArray.contains(beattt) || paidjoyfulTypeFilteringCode == 1 && !strongSelf.joyfulTypeArray.contains(beattt) || paidsoulfulTypeFilteringCode == 1 && !strongSelf.soulfulTypeArray.contains(beattt) || paidexperimentalTypeFilteringCode == 1 && !strongSelf.experimentalTypeArray.contains(beattt) || paidrelaxedTypeFilteringCode == 1 && !strongSelf.relaxedTypeArray.contains(beattt) || paidcalmTypeFilteringCode == 1 && !strongSelf.calmTypeArray.contains(beattt) || paidepicTypeFilteringCode == 1 && !strongSelf.epicTypeArray.contains(beattt) || paidsimpleTypeFilteringCode == 1 && !strongSelf.simpleTypeArray.contains(beattt) || paidtrapTypeFilteringCode == 1 && !strongSelf.trapTypeArray.contains(beattt) {
                                    let index = strongSelf.typeSelectedArray.firstIndex{$0 === beattt}
                                    if index != nil {
                                        strongSelf.typeSelectedArray.remove(at: index!)
                                    }
                                }
                            }
                            strongSelf.filteredBeats = strongSelf.typeSelectedArray
                        }
                    }
                }
                
            }
            if paidnumberOfActiveFilterCells > 1 {
                if pickedCode == 1 {
                    if paidallTypeFilteringCode == 1 {
                        strongSelf.typeSelectedArray = filteredtypebeats
                        for beattt in strongSelf.filteredBeats {
                            if !strongSelf.typeSelectedArray.contains(beattt) {
                                let index = strongSelf.filteredBeats.firstIndex{$0 === beattt}
                                if index != nil {
                                    strongSelf.filteredBeats.remove(at: index!)
                                }
                            }
                        }
                    }
                    if paidallTypeFilteringCode > 1 {
                        for beattt in strongSelf.typeSelectedArray {
                            if paiddarkTypeFilteringCode == 1 && !strongSelf.darkTypeArray.contains(beattt) || paidmelodicTypeFilteringCode == 1 && !strongSelf.melodicTypeArray.contains(beattt) || paidaggressiveTypeFilteringCode == 1 && !strongSelf.aggressiveTypeArray.contains(beattt) || paidsmoothTypeFilteringCode == 1 && !strongSelf.smoothTypeArray.contains(beattt) || paidrAndBTypeFilteringCode == 1 && !strongSelf.rAndBTypeArray.contains(beattt) || paidvibeyTypeFilteringCode == 1 && !strongSelf.vibeyTypeArray.contains(beattt) || paidclubTypeFilteringCode == 1 && !strongSelf.clubTypeArray.contains(beattt) || paidjoyfulTypeFilteringCode == 1 && !strongSelf.joyfulTypeArray.contains(beattt) || paidsoulfulTypeFilteringCode == 1 && !strongSelf.soulfulTypeArray.contains(beattt) || paidexperimentalTypeFilteringCode == 1 && !strongSelf.experimentalTypeArray.contains(beattt) || paidrelaxedTypeFilteringCode == 1 && !strongSelf.relaxedTypeArray.contains(beattt) || paidcalmTypeFilteringCode == 1 && !strongSelf.calmTypeArray.contains(beattt) || paidepicTypeFilteringCode == 1 && !strongSelf.epicTypeArray.contains(beattt) || paidsimpleTypeFilteringCode == 1 && !strongSelf.simpleTypeArray.contains(beattt) || paidtrapTypeFilteringCode == 1 && !strongSelf.trapTypeArray.contains(beattt) {
                                let index = strongSelf.typeSelectedArray.firstIndex{$0 === beattt}
                                if index != nil {
                                    strongSelf.typeSelectedArray.remove(at: index!)
                                }
                            }
                        }
                        for beattt in strongSelf.filteredBeats {
                            if !strongSelf.typeSelectedArray.contains(beattt) {
                                let index = strongSelf.filteredBeats.firstIndex{$0 === beattt}
                                if index != nil {
                                    strongSelf.filteredBeats.remove(at: index!)
                                }
                            }
                        }
                    }
                } else if pickedCode == 0 {
                    if paidallTypeFilteringCode == 0 {
                        strongSelf.filteredBeats = []
                        if paidkeyfliteringCode == 1 {
                            for beat in strongSelf.keySelectedArray {
                                if paidsoundsfilteringCode==1&&strongSelf.soundsSelectedArray.contains(beat) || paidtempofilteringCode==1&&strongSelf.tempoSelectedArray.contains(beat) || paidproducersfilteringCode==1&&strongSelf.producerSelectedArray.contains(beat) {
                                    if !strongSelf.filteredBeats.contains(beat) {
                                        strongSelf.filteredBeats.append(beat)
                                    }
                                } else if !strongSelf.filteredBeats.contains(beat) {
                                    strongSelf.filteredBeats.append(beat)
                                }
                            }
                        }
                        if paidsoundsfilteringCode == 1 {
                            for beat in strongSelf.soundsSelectedArray {
                                if paidkeyfliteringCode==1&&strongSelf.keySelectedArray.contains(beat) || paidtempofilteringCode==1&&strongSelf.tempoSelectedArray.contains(beat) || paidproducersfilteringCode==1&&strongSelf.producerSelectedArray.contains(beat) {
                                    if !strongSelf.filteredBeats.contains(beat) {
                                        strongSelf.filteredBeats.append(beat)
                                    }
                                } else if !strongSelf.filteredBeats.contains(beat) {
                                    strongSelf.filteredBeats.append(beat)
                                }
                            }
                        }
                        if paidtempofilteringCode == 1 {
                            for beat in strongSelf.tempoSelectedArray {
                                if paidsoundsfilteringCode==1&&strongSelf.soundsSelectedArray.contains(beat) || paidkeyfliteringCode==1&&strongSelf.keySelectedArray.contains(beat) || paidproducersfilteringCode==1&&strongSelf.producerSelectedArray.contains(beat) {
                                    if !strongSelf.filteredBeats.contains(beat) {
                                        strongSelf.filteredBeats.append(beat)
                                    }
                                } else if !strongSelf.filteredBeats.contains(beat) {
                                    strongSelf.filteredBeats.append(beat)
                                }
                            }
                        }
                        if paidproducersfilteringCode == 1 {
                            for beat in strongSelf.producerSelectedArray {
                                if paidsoundsfilteringCode==1&&strongSelf.soundsSelectedArray.contains(beat) || paidtempofilteringCode==1&&strongSelf.tempoSelectedArray.contains(beat) || paidkeyfliteringCode==1&&strongSelf.keySelectedArray.contains(beat) {
                                    if !strongSelf.filteredBeats.contains(beat) {
                                        strongSelf.filteredBeats.append(beat)
                                    }
                                } else if !strongSelf.filteredBeats.contains(beat) {
                                    strongSelf.filteredBeats.append(beat)
                                }
                            }
                        }
                        for beat in strongSelf.filteredBeats
                        {
                            if !strongSelf.keySelectedArray.contains(beat) && paidkeyfliteringCode == 1 || !strongSelf.soundsSelectedArray.contains(beat) && paidsoundsfilteringCode == 1 || !strongSelf.tempoSelectedArray.contains(beat) && paidtempofilteringCode == 1 || !strongSelf.producerSelectedArray.contains(beat) && paidproducersfilteringCode == 1 {
                                let index = strongSelf.filteredBeats.firstIndex{$0 === beat}
                                if index != nil {
                                    strongSelf.filteredBeats.remove(at: index!)
                                }
                            }
                        }
                    } else if paidallTypeFilteringCode > 0{
                        strongSelf.typeSelectedArray = []
                        if paiddarkTypeFilteringCode == 1 {
                            pickedArray = strongSelf.darkTypeArray
                        } else if paidmelodicTypeFilteringCode == 1 {
                            pickedArray = strongSelf.melodicTypeArray
                        } else if paidaggressiveTypeFilteringCode == 1 {
                            pickedArray = strongSelf.aggressiveTypeArray
                        } else if paidsmoothTypeFilteringCode == 1 {
                            pickedArray = strongSelf.smoothTypeArray
                        } else if paidrAndBTypeFilteringCode == 1 {
                            pickedArray = strongSelf.rAndBTypeArray
                        } else if paidvibeyTypeFilteringCode == 1 {
                            pickedArray = strongSelf.vibeyTypeArray
                        } else if paidclubTypeFilteringCode == 1 {
                            pickedArray = strongSelf.clubTypeArray
                        } else if paidjoyfulTypeFilteringCode == 1 {
                            pickedArray = strongSelf.joyfulTypeArray
                        } else if paidsoulfulTypeFilteringCode == 1 {
                            pickedArray = strongSelf.soulfulTypeArray
                        } else if paidexperimentalTypeFilteringCode == 1 {
                            pickedArray = strongSelf.experimentalTypeArray
                        } else if paidrelaxedTypeFilteringCode == 1 {
                            pickedArray = strongSelf.relaxedTypeArray
                        } else if paidcalmTypeFilteringCode == 1 {
                            pickedArray = strongSelf.calmTypeArray
                        } else if paidepicTypeFilteringCode == 1 {
                            pickedArray = strongSelf.epicTypeArray
                        } else if paidsimpleTypeFilteringCode == 1 {
                            pickedArray = strongSelf.simpleTypeArray
                        } else if paidtrapTypeFilteringCode == 1 {
                            pickedArray = strongSelf.trapTypeArray
                        }
                        strongSelf.typeSelectedArray.append(contentsOf: pickedArray)
                        for beattt in strongSelf.typeSelectedArray {
                            if paiddarkTypeFilteringCode == 1 && !strongSelf.darkTypeArray.contains(beattt) || paidmelodicTypeFilteringCode == 1 && !strongSelf.melodicTypeArray.contains(beattt) || paidaggressiveTypeFilteringCode == 1 && !strongSelf.aggressiveTypeArray.contains(beattt) || paidsmoothTypeFilteringCode == 1 && !strongSelf.smoothTypeArray.contains(beattt) || paidrAndBTypeFilteringCode == 1 && !strongSelf.rAndBTypeArray.contains(beattt) || paidvibeyTypeFilteringCode == 1 && !strongSelf.vibeyTypeArray.contains(beattt) || paidclubTypeFilteringCode == 1 && !strongSelf.clubTypeArray.contains(beattt) || paidjoyfulTypeFilteringCode == 1 && !strongSelf.joyfulTypeArray.contains(beattt) || paidsoulfulTypeFilteringCode == 1 && !strongSelf.soulfulTypeArray.contains(beattt) || paidexperimentalTypeFilteringCode == 1 && !strongSelf.experimentalTypeArray.contains(beattt) || paidrelaxedTypeFilteringCode == 1 && !strongSelf.relaxedTypeArray.contains(beattt) || paidcalmTypeFilteringCode == 1 && !strongSelf.calmTypeArray.contains(beattt) || paidepicTypeFilteringCode == 1 && !strongSelf.epicTypeArray.contains(beattt) || paidsimpleTypeFilteringCode == 1 && !strongSelf.simpleTypeArray.contains(beattt) || paidtrapTypeFilteringCode == 1 && !strongSelf.trapTypeArray.contains(beattt) {
                                let index = strongSelf.typeSelectedArray.firstIndex{$0 === beattt}
                                if index != nil {
                                    strongSelf.typeSelectedArray.remove(at: index!)
                                }
                            }
                        }
                        strongSelf.filteredBeats = []
                        strongSelf.filteredBeats.append(contentsOf: strongSelf.typeSelectedArray)
                        for beat in strongSelf.filteredBeats {
                            if paidsoundsfilteringCode==1 && !strongSelf.soundsSelectedArray.contains(beat) || paidtempofilteringCode==1 && !strongSelf.tempoSelectedArray.contains(beat) || paidproducersfilteringCode==1 && !strongSelf.producerSelectedArray.contains(beat) || paidkeyfliteringCode==1 && !strongSelf.keySelectedArray.contains(beat) {
                                let index = strongSelf.filteredBeats.firstIndex{$0 === beat}
                                if index != nil {
                                    strongSelf.filteredBeats.remove(at: index!)
                                }
                                
                            }
                        }
                    }
                }
            }
            strongSelf.reSortFilteredBeats()
            strongSelf.paidBeatTableView.reloadData()
        })
    }
    
    //MARK: - Sounds Updates
    
    @objc func soundsFilterUpdate(notification: NSNotification) {
        var spickedCode = 1000
        var spickedArray:[BeatData] = []
        let selectedsound = notification.object as! String
        FilteringManager.shared.filterBySoundsPaid(sound: selectedsound, completion: {[weak self] filteredsoundbeats in
            guard let strongSelf = self else {
                return
            }
            switch selectedsound {
            case "Keys":
                strongSelf.keysSoundArray = filteredsoundbeats
                spickedCode = paidkeysSoundFilteringCode
            case "Piano Acoustic":
                strongSelf.pianoAcousticSoundArray = filteredsoundbeats
                spickedCode = paidpianoAcousticSoundFilteringCode
            case "Piano Vinyl":
                strongSelf.pianoVinylSoundArray = filteredsoundbeats
                spickedCode = paidpianoVinylSoundFilteringCode
            case "Piano Electric":
                strongSelf.pianoElectricSoundArray = filteredsoundbeats
                spickedCode = paidpianoElectricSoundFilteringCode
            case "Piano Rhodes":
                strongSelf.pianoRhodesSoundArray = filteredsoundbeats
                spickedCode = paidpianoRhodesSoundFilteringCode
            case "Organ":
                strongSelf.organSoundArray = filteredsoundbeats
                spickedCode = paidorganSoundFilteringCode
            case "Theramin":
                strongSelf.theraminSoundArray = filteredsoundbeats
                spickedCode = paidtheraminSoundFilteringCode
            case "Whistle":
                strongSelf.whistleSoundArray = filteredsoundbeats
                spickedCode = paidwhistleSoundFilteringCode
            case "Horns":
                strongSelf.hornsSoundArray = filteredsoundbeats
                spickedCode = paidhornsSoundFilteringCode
            case "Strings":
                strongSelf.stringsSoundArray = filteredsoundbeats
                spickedCode = paidstringsSoundFilteringCode
            case "Flute":
                strongSelf.fluteSoundArray = filteredsoundbeats
                spickedCode = paidfluteSoundFilteringCode
            case "Pad Bell":
                strongSelf.padBellSoundArray = filteredsoundbeats
                spickedCode = paidpadBellSoundFilteringCode
            case "Pad Hollow":
                strongSelf.padHollowSoundArray = filteredsoundbeats
                spickedCode = paidpadHollowSoundFilteringCode
            case "Pad Aggressive":
                strongSelf.padAggressiveSoundArray = filteredsoundbeats
                spickedCode = paidpadAggressiveSoundFilteringCode
            case "Choir":
                strongSelf.choirSoundArray = filteredsoundbeats
                spickedCode = paidchoirSoundFilteringCode
            case "Saxophone":
                strongSelf.saxophoneSoundArray = filteredsoundbeats
                spickedCode = paidsaxophoneSoundFilteringCode
            case "Guitar Electric":
                strongSelf.guitarElectricSoundArray = filteredsoundbeats
                spickedCode = paidguitarElectricSoundFilteringCode
            case "Guitar Acoustic":
                strongSelf.guitarAcousticSoundArray = filteredsoundbeats
                spickedCode = paidguitarAcousticSoundFilteringCode
            case "Guitar Steel":
                strongSelf.guitarSteelSoundArray = filteredsoundbeats
                spickedCode = paidguitarSteelSoundFilteringCode
            case "Bells EDM":
                strongSelf.bellsEDMSoundArray = filteredsoundbeats
                spickedCode = paidbellsEDMSoundFilteringCode
            case "Bells Vinyl":
                strongSelf.bellsVinylSoundArray = filteredsoundbeats
                spickedCode = paidbellsVinylSoundFilteringCode
            case "Bells Gothic":
                strongSelf.bellsGothicSoundArray = filteredsoundbeats
                spickedCode = paidbellsGothicSoundFilteringCode
            case "Bells Hollow":
                strongSelf.bellsHollowSoundArray = filteredsoundbeats
                spickedCode = paidbellsHollowSoundFilteringCode
            case "Bells Music Box":
                strongSelf.bellsMusicBoxSoundArray = filteredsoundbeats
                spickedCode = paidbellsMusicBoxSoundFilteringCode
            case "Sample Vocal":
                strongSelf.sampleVocalSoundArray = filteredsoundbeats
                spickedCode = paidsampleVocalSoundFilteringCode
            case "Sample Song":
                strongSelf.sampleSongSoundArray = filteredsoundbeats
                spickedCode = paidsampleSongSoundFilteringCode
            case "No Kick":
                strongSelf.noKickSoundArray = filteredsoundbeats
                spickedCode = paidnoKickSoundFilteringCode
            case "Kick":
                strongSelf.kickSoundArray = filteredsoundbeats
                spickedCode = paidkickSoundFilteringCode
            case "808 Long":
                strongSelf.long808SoundArray = filteredsoundbeats
                spickedCode = paidlong808SoundFilteringCode
            case "808 Short":
                strongSelf.short808SoundArray = filteredsoundbeats
                spickedCode = paidshort808SoundFilteringCode
            case "808 Clean":
                strongSelf.clean808SoundArray = filteredsoundbeats
                spickedCode = paidclean808SoundFilteringCode
            case "808 Distorted":
                strongSelf.distorted808SoundArray = filteredsoundbeats
                spickedCode = paiddistorted808SoundFilteringCode
            case "Moog Bass":
                strongSelf.moogBassSoundArray = filteredsoundbeats
                spickedCode = paidmoogBassSoundFilteringCode
            case "Sub Bass":
                strongSelf.subBassSoundArray = filteredsoundbeats
                spickedCode = paidsubBassSoundFilteringCode
            case "Synth Bass Distorted":
                strongSelf.synthBassDistortedSoundArray = filteredsoundbeats
                spickedCode = paidsynthBassDistortedSoundFilteringCode
            case "Snap":
                strongSelf.snapSoundArray = filteredsoundbeats
                spickedCode = paidsnapSoundFilteringCode
            case "Synth Bass Deep":
                strongSelf.synthBassDeepSoundArray = filteredsoundbeats
                spickedCode = paidsynthBassDeepSoundFilteringCode
            default:
                print("Error finding array sound to pace in sound array.")
            }
            
            if paidnumberOfActiveFilterCells == 0 {
                strongSelf.filteredBeats = strongSelf.initialBeats
            }
            if paidnumberOfActiveFilterCells == 1 {
                if spickedCode == 1 {
                    if paidallSoundsFilteringCode == 1 {
                        strongSelf.soundsSelectedArray = filteredsoundbeats
                    }
                    if paidallSoundsFilteringCode > 1 {
                        for beattt in strongSelf.soundsSelectedArray {
                            if paidkeysSoundFilteringCode == 1 && !strongSelf.keysSoundArray.contains(beattt) || paidpianoAcousticSoundFilteringCode == 1 && !strongSelf.pianoAcousticSoundArray.contains(beattt) || paidpianoElectricSoundFilteringCode == 1 && !strongSelf.pianoElectricSoundArray.contains(beattt) || paidpianoRhodesSoundFilteringCode == 1 && !strongSelf.pianoRhodesSoundArray.contains(beattt) || paidpianoVinylSoundFilteringCode == 1 && !strongSelf.pianoVinylSoundArray.contains(beattt) || paidorganSoundFilteringCode == 1 && !strongSelf.organSoundArray.contains(beattt) || paidtheraminSoundFilteringCode == 1 && !strongSelf.theraminSoundArray.contains(beattt) || paidwhistleSoundFilteringCode == 1 && !strongSelf.whistleSoundArray.contains(beattt) || paidhornsSoundFilteringCode == 1 && !strongSelf.hornsSoundArray.contains(beattt) || paidstringsSoundFilteringCode == 1 && !strongSelf.stringsSoundArray.contains(beattt) || paidfluteSoundFilteringCode == 1 && !strongSelf.fluteSoundArray.contains(beattt) || paidpadBellSoundFilteringCode == 1 && !strongSelf.padBellSoundArray.contains(beattt) || paidpadHollowSoundFilteringCode == 1 && !strongSelf.padHollowSoundArray.contains(beattt) || paidpadAggressiveSoundFilteringCode == 1 && !strongSelf.padAggressiveSoundArray.contains(beattt) || paidchoirSoundFilteringCode == 1 && !strongSelf.choirSoundArray.contains(beattt) || paidsaxophoneSoundFilteringCode == 1 && !strongSelf.saxophoneSoundArray.contains(beattt) || paidguitarElectricSoundFilteringCode == 1 && !strongSelf.guitarElectricSoundArray.contains(beattt) || paidguitarAcousticSoundFilteringCode == 1 && !strongSelf.guitarAcousticSoundArray.contains(beattt) || paidguitarSteelSoundFilteringCode == 1 && !strongSelf.guitarSteelSoundArray.contains(beattt) || paidbellsEDMSoundFilteringCode == 1 && !strongSelf.bellsEDMSoundArray.contains(beattt) || paidbellsVinylSoundFilteringCode == 1 && !strongSelf.bellsVinylSoundArray.contains(beattt) || paidbellsGothicSoundFilteringCode == 1 && !strongSelf.bellsGothicSoundArray.contains(beattt) || paidbellsHollowSoundFilteringCode == 1 && !strongSelf.bellsHollowSoundArray.contains(beattt) || paidbellsMusicBoxSoundFilteringCode == 1 && !strongSelf.bellsMusicBoxSoundArray.contains(beattt) || paidsampleVocalSoundFilteringCode == 1 && !strongSelf.sampleVocalSoundArray.contains(beattt) || paidsampleSongSoundFilteringCode == 1 && !strongSelf.sampleSongSoundArray.contains(beattt) || paidnoKickSoundFilteringCode == 1 && !strongSelf.noKickSoundArray.contains(beattt) || paidkickSoundFilteringCode == 1 && !strongSelf.kickSoundArray.contains(beattt) || paidlong808SoundFilteringCode == 1 && !strongSelf.long808SoundArray.contains(beattt) || paidshort808SoundFilteringCode == 1 && !strongSelf.short808SoundArray.contains(beattt) || paidclean808SoundFilteringCode == 1 && !strongSelf.clean808SoundArray.contains(beattt) || paiddistorted808SoundFilteringCode == 1 && !strongSelf.distorted808SoundArray.contains(beattt) || paidmoogBassSoundFilteringCode == 1 && !strongSelf.moogBassSoundArray.contains(beattt) || paidsubBassSoundFilteringCode == 1 && !strongSelf.subBassSoundArray.contains(beattt) || paidsynthBassDistortedSoundFilteringCode == 1 && !strongSelf.synthBassDistortedSoundArray.contains(beattt) || paidsynthBassDeepSoundFilteringCode == 1 && !strongSelf.synthBassDeepSoundArray.contains(beattt) || paidsnapSoundFilteringCode == 1 && !strongSelf.snapSoundArray.contains(beattt)
                            {
                                let index = strongSelf.soundsSelectedArray.firstIndex{$0 === beattt}
                                if index != nil {
                                    strongSelf.soundsSelectedArray.remove(at: index!)
                                }
                            }
                        }
                    }
                    strongSelf.filteredBeats = strongSelf.soundsSelectedArray
                } else if spickedCode == 0 {
                    if paidallSoundsFilteringCode == 0 {
                        strongSelf.filteredBeats = []
                        if paidkeyfliteringCode == 1 {
                            for beat in strongSelf.keySelectedArray {
                                if paidtypefilteringCode==1&&strongSelf.typeSelectedArray.contains(beat) || paidtempofilteringCode==1&&strongSelf.tempoSelectedArray.contains(beat) || paidproducersfilteringCode==1&&strongSelf.producerSelectedArray.contains(beat) {
                                    if !strongSelf.filteredBeats.contains(beat) {
                                        strongSelf.filteredBeats.append(beat)
                                    }
                                } else if !strongSelf.filteredBeats.contains(beat) {
                                    strongSelf.filteredBeats.append(beat)
                                }
                            }
                        }
                        if paidtypefilteringCode == 1 {
                            for beat in strongSelf.typeSelectedArray {
                                if paidkeyfliteringCode==1&&strongSelf.keySelectedArray.contains(beat) || paidtempofilteringCode==1&&strongSelf.tempoSelectedArray.contains(beat) || paidproducersfilteringCode==1&&strongSelf.producerSelectedArray.contains(beat) {
                                    if !strongSelf.filteredBeats.contains(beat) {
                                        strongSelf.filteredBeats.append(beat)
                                    }
                                } else if !strongSelf.filteredBeats.contains(beat) {
                                    strongSelf.filteredBeats.append(beat)
                                }
                            }
                        }
                        if paidtempofilteringCode == 1 {
                            for beat in strongSelf.tempoSelectedArray {
                                if paidtypefilteringCode==1&&strongSelf.typeSelectedArray.contains(beat) || paidkeyfliteringCode==1&&strongSelf.keySelectedArray.contains(beat) || paidproducersfilteringCode==1&&strongSelf.producerSelectedArray.contains(beat) {
                                    if !strongSelf.filteredBeats.contains(beat) {
                                        strongSelf.filteredBeats.append(beat)
                                    }
                                } else if !strongSelf.filteredBeats.contains(beat) {
                                    strongSelf.filteredBeats.append(beat)
                                }
                            }
                        }
                        if paidproducersfilteringCode == 1 {
                            for beat in strongSelf.producerSelectedArray {
                                if paidtypefilteringCode==1&&strongSelf.typeSelectedArray.contains(beat) || paidtempofilteringCode==1&&strongSelf.tempoSelectedArray.contains(beat) || paidkeyfliteringCode==1&&strongSelf.keySelectedArray.contains(beat) {
                                    if !strongSelf.filteredBeats.contains(beat) {
                                        strongSelf.filteredBeats.append(beat)
                                    }
                                } else if !strongSelf.filteredBeats.contains(beat) {
                                    strongSelf.filteredBeats.append(beat)
                                }
                            }
                        }
                    } else if paidallSoundsFilteringCode > 0{
                        strongSelf.soundsSelectedArray = []
                        if paidkeysSoundFilteringCode == 1 {
                            spickedArray = strongSelf.keysSoundArray
                        } else if paidpianoAcousticSoundFilteringCode == 1 {
                            spickedArray = strongSelf.pianoAcousticSoundArray
                        } else if paidpianoVinylSoundFilteringCode == 1 {
                            spickedArray = strongSelf.pianoVinylSoundArray
                        } else if paidpianoElectricSoundFilteringCode == 1 {
                            spickedArray = strongSelf.pianoElectricSoundArray
                        } else if paidpianoRhodesSoundFilteringCode == 1 {
                            spickedArray = strongSelf.pianoRhodesSoundArray
                        } else if paidorganSoundFilteringCode == 1 {
                            spickedArray = strongSelf.organSoundArray
                        } else if paidtheraminSoundFilteringCode == 1 {
                            spickedArray = strongSelf.theraminSoundArray
                        } else if paidwhistleSoundFilteringCode == 1 {
                            spickedArray = strongSelf.whistleSoundArray
                        } else if paidhornsSoundFilteringCode == 1 {
                            spickedArray = strongSelf.hornsSoundArray
                        } else if paidstringsSoundFilteringCode == 1 {
                            spickedArray = strongSelf.stringsSoundArray
                        } else if paidfluteSoundFilteringCode == 1 {
                            spickedArray = strongSelf.fluteSoundArray
                        } else if paidpadBellSoundFilteringCode == 1 {
                            spickedArray = strongSelf.padBellSoundArray
                        } else if paidpadHollowSoundFilteringCode == 1 {
                            spickedArray = strongSelf.padHollowSoundArray
                        } else if paidpadAggressiveSoundFilteringCode == 1 {
                            spickedArray = strongSelf.padAggressiveSoundArray
                        } else if paidchoirSoundFilteringCode == 1 {
                            spickedArray = strongSelf.choirSoundArray
                        } else if paidsaxophoneSoundFilteringCode == 1 {
                            spickedArray = strongSelf.saxophoneSoundArray
                        } else if paidguitarElectricSoundFilteringCode == 1 {
                            spickedArray = strongSelf.guitarElectricSoundArray
                        } else if paidguitarAcousticSoundFilteringCode == 1 {
                            spickedArray = strongSelf.guitarAcousticSoundArray
                        } else if paidguitarSteelSoundFilteringCode == 1 {
                            spickedArray = strongSelf.guitarSteelSoundArray
                        } else if paidbellsEDMSoundFilteringCode == 1 {
                            spickedArray = strongSelf.bellsEDMSoundArray
                        } else if paidbellsVinylSoundFilteringCode == 1 {
                            spickedArray = strongSelf.bellsVinylSoundArray
                        } else if paidbellsGothicSoundFilteringCode == 1 {
                            spickedArray = strongSelf.bellsGothicSoundArray
                        } else if paidbellsHollowSoundFilteringCode == 1 {
                            spickedArray = strongSelf.bellsHollowSoundArray
                        } else if paidbellsMusicBoxSoundFilteringCode == 1 {
                            spickedArray = strongSelf.bellsMusicBoxSoundArray
                        } else if paidsampleVocalSoundFilteringCode == 1 {
                            spickedArray = strongSelf.sampleVocalSoundArray
                        } else if paidsampleSongSoundFilteringCode == 1 {
                            spickedArray = strongSelf.sampleSongSoundArray
                        } else if paidnoKickSoundFilteringCode == 1 {
                            spickedArray = strongSelf.noKickSoundArray
                        } else if paidkickSoundFilteringCode == 1 {
                            spickedArray = strongSelf.kickSoundArray
                        } else if paidlong808SoundFilteringCode == 1 {
                            spickedArray = strongSelf.long808SoundArray
                        } else if paidshort808SoundFilteringCode == 1 {
                            spickedArray = strongSelf.short808SoundArray
                        } else if paidclean808SoundFilteringCode == 1 {
                            spickedArray = strongSelf.clean808SoundArray
                        } else if paiddistorted808SoundFilteringCode == 1 {
                            spickedArray = strongSelf.distorted808SoundArray
                        } else if paidmoogBassSoundFilteringCode == 1 {
                            spickedArray = strongSelf.moogBassSoundArray
                        } else if paidsubBassSoundFilteringCode == 1 {
                            spickedArray = strongSelf.subBassSoundArray
                        } else if paidsynthBassDistortedSoundFilteringCode == 1 {
                            spickedArray = strongSelf.synthBassDistortedSoundArray
                        } else if paidsynthBassDeepSoundFilteringCode == 1 {
                            spickedArray = strongSelf.synthBassDeepSoundArray
                        } else if paidsnapSoundFilteringCode == 1 {
                            spickedArray = strongSelf.snapSoundArray
                        }
                        strongSelf.soundsSelectedArray.append(contentsOf: spickedArray)
                        if paidallSoundsFilteringCode == 1 {
                            strongSelf.filteredBeats = strongSelf.soundsSelectedArray
                        }
                        if paidallSoundsFilteringCode > 1 {
                            for beattt in strongSelf.soundsSelectedArray {
                                if paidkeysSoundFilteringCode == 1 && !strongSelf.keysSoundArray.contains(beattt) || paidpianoAcousticSoundFilteringCode == 1 && !strongSelf.pianoAcousticSoundArray.contains(beattt) || paidpianoElectricSoundFilteringCode == 1 && !strongSelf.pianoElectricSoundArray.contains(beattt) || paidpianoRhodesSoundFilteringCode == 1 && !strongSelf.pianoRhodesSoundArray.contains(beattt) || paidpianoVinylSoundFilteringCode == 1 && !strongSelf.pianoVinylSoundArray.contains(beattt) || paidorganSoundFilteringCode == 1 && !strongSelf.organSoundArray.contains(beattt) || paidtheraminSoundFilteringCode == 1 && !strongSelf.theraminSoundArray.contains(beattt) || paidwhistleSoundFilteringCode == 1 && !strongSelf.whistleSoundArray.contains(beattt) || paidhornsSoundFilteringCode == 1 && !strongSelf.hornsSoundArray.contains(beattt) || paidstringsSoundFilteringCode == 1 && !strongSelf.stringsSoundArray.contains(beattt) || paidfluteSoundFilteringCode == 1 && !strongSelf.fluteSoundArray.contains(beattt) || padBellSoundFilteringCode == 1 && !strongSelf.padBellSoundArray.contains(beattt) || paidpadHollowSoundFilteringCode == 1 && !strongSelf.padHollowSoundArray.contains(beattt) || paidpadAggressiveSoundFilteringCode == 1 && !strongSelf.padAggressiveSoundArray.contains(beattt) || paidchoirSoundFilteringCode == 1 && !strongSelf.choirSoundArray.contains(beattt) || paidsaxophoneSoundFilteringCode == 1 && !strongSelf.saxophoneSoundArray.contains(beattt) || paidguitarElectricSoundFilteringCode == 1 && !strongSelf.guitarElectricSoundArray.contains(beattt) || paidguitarAcousticSoundFilteringCode == 1 && !strongSelf.guitarAcousticSoundArray.contains(beattt) || paidguitarSteelSoundFilteringCode == 1 && !strongSelf.guitarSteelSoundArray.contains(beattt) || paidbellsEDMSoundFilteringCode == 1 && !strongSelf.bellsEDMSoundArray.contains(beattt) || paidbellsVinylSoundFilteringCode == 1 && !strongSelf.bellsVinylSoundArray.contains(beattt) || paidbellsGothicSoundFilteringCode == 1 && !strongSelf.bellsGothicSoundArray.contains(beattt) || paidbellsHollowSoundFilteringCode == 1 && !strongSelf.bellsHollowSoundArray.contains(beattt) || paidbellsMusicBoxSoundFilteringCode == 1 && !strongSelf.bellsMusicBoxSoundArray.contains(beattt) || paidsampleVocalSoundFilteringCode == 1 && !strongSelf.sampleVocalSoundArray.contains(beattt) || paidsampleSongSoundFilteringCode == 1 && !strongSelf.sampleSongSoundArray.contains(beattt) || paidnoKickSoundFilteringCode == 1 && !strongSelf.noKickSoundArray.contains(beattt) || paidkickSoundFilteringCode == 1 && !strongSelf.kickSoundArray.contains(beattt) || paidlong808SoundFilteringCode == 1 && !strongSelf.long808SoundArray.contains(beattt) || paidshort808SoundFilteringCode == 1 && !strongSelf.short808SoundArray.contains(beattt) || paidclean808SoundFilteringCode == 1 && !strongSelf.clean808SoundArray.contains(beattt) || paiddistorted808SoundFilteringCode == 1 && !strongSelf.distorted808SoundArray.contains(beattt) || paidmoogBassSoundFilteringCode == 1 && !strongSelf.moogBassSoundArray.contains(beattt) || paidsubBassSoundFilteringCode == 1 && !strongSelf.subBassSoundArray.contains(beattt) || paidsynthBassDistortedSoundFilteringCode == 1 && !strongSelf.synthBassDistortedSoundArray.contains(beattt) || paidsynthBassDeepSoundFilteringCode == 1 && !strongSelf.synthBassDeepSoundArray.contains(beattt) || paidsnapSoundFilteringCode == 1 && !strongSelf.snapSoundArray.contains(beattt)
                                {
                                    let index = strongSelf.soundsSelectedArray.firstIndex{$0 === beattt}
                                    if index != nil {
                                        strongSelf.soundsSelectedArray.remove(at: index!)
                                    }
                                }
                            }
                            strongSelf.filteredBeats = strongSelf.soundsSelectedArray
                        }
                    }
                }
                
            }
            if paidnumberOfActiveFilterCells > 1 {
                if spickedCode == 1 {
                    if paidallSoundsFilteringCode == 1 {
                        strongSelf.soundsSelectedArray = filteredsoundbeats
                        for beattt in strongSelf.filteredBeats {
                            if !strongSelf.soundsSelectedArray.contains(beattt) {
                                let index = strongSelf.filteredBeats.firstIndex{$0 === beattt}
                                if index != nil {
                                    strongSelf.filteredBeats.remove(at: index!)
                                }
                            }
                        }
                    }
                    if paidallSoundsFilteringCode > 1 {
                        for beattt in strongSelf.soundsSelectedArray {
                            if paidkeysSoundFilteringCode == 1 && !strongSelf.keysSoundArray.contains(beattt) || paidpianoAcousticSoundFilteringCode == 1 && !strongSelf.pianoAcousticSoundArray.contains(beattt) || paidpianoElectricSoundFilteringCode == 1 && !strongSelf.pianoElectricSoundArray.contains(beattt) || paidpianoRhodesSoundFilteringCode == 1 && !strongSelf.pianoRhodesSoundArray.contains(beattt) || paidpianoVinylSoundFilteringCode == 1 && !strongSelf.pianoVinylSoundArray.contains(beattt) || paidorganSoundFilteringCode == 1 && !strongSelf.organSoundArray.contains(beattt) || paidtheraminSoundFilteringCode == 1 && !strongSelf.theraminSoundArray.contains(beattt) || paidwhistleSoundFilteringCode == 1 && !strongSelf.whistleSoundArray.contains(beattt) || paidhornsSoundFilteringCode == 1 && !strongSelf.hornsSoundArray.contains(beattt) || paidstringsSoundFilteringCode == 1 && !strongSelf.stringsSoundArray.contains(beattt) || paidfluteSoundFilteringCode == 1 && !strongSelf.fluteSoundArray.contains(beattt) || paidpadBellSoundFilteringCode == 1 && !strongSelf.padBellSoundArray.contains(beattt) || paidpadHollowSoundFilteringCode == 1 && !strongSelf.padHollowSoundArray.contains(beattt) || paidpadAggressiveSoundFilteringCode == 1 && !strongSelf.padAggressiveSoundArray.contains(beattt) || paidchoirSoundFilteringCode == 1 && !strongSelf.choirSoundArray.contains(beattt) || paidsaxophoneSoundFilteringCode == 1 && !strongSelf.saxophoneSoundArray.contains(beattt) || paidguitarElectricSoundFilteringCode == 1 && !strongSelf.guitarElectricSoundArray.contains(beattt) || paidguitarAcousticSoundFilteringCode == 1 && !strongSelf.guitarAcousticSoundArray.contains(beattt) || paidguitarSteelSoundFilteringCode == 1 && !strongSelf.guitarSteelSoundArray.contains(beattt) || paidbellsEDMSoundFilteringCode == 1 && !strongSelf.bellsEDMSoundArray.contains(beattt) || paidbellsVinylSoundFilteringCode == 1 && !strongSelf.bellsVinylSoundArray.contains(beattt) || paidbellsGothicSoundFilteringCode == 1 && !strongSelf.bellsGothicSoundArray.contains(beattt) || paidbellsHollowSoundFilteringCode == 1 && !strongSelf.bellsHollowSoundArray.contains(beattt) || paidbellsMusicBoxSoundFilteringCode == 1 && !strongSelf.bellsMusicBoxSoundArray.contains(beattt) || paidsampleVocalSoundFilteringCode == 1 && !strongSelf.sampleVocalSoundArray.contains(beattt) || paidsampleSongSoundFilteringCode == 1 && !strongSelf.sampleSongSoundArray.contains(beattt) || paidnoKickSoundFilteringCode == 1 && !strongSelf.noKickSoundArray.contains(beattt) || paidkickSoundFilteringCode == 1 && !strongSelf.kickSoundArray.contains(beattt) || paidlong808SoundFilteringCode == 1 && !strongSelf.long808SoundArray.contains(beattt) || paidshort808SoundFilteringCode == 1 && !strongSelf.short808SoundArray.contains(beattt) || paidclean808SoundFilteringCode == 1 && !strongSelf.clean808SoundArray.contains(beattt) || paiddistorted808SoundFilteringCode == 1 && !strongSelf.distorted808SoundArray.contains(beattt) || paidmoogBassSoundFilteringCode == 1 && !strongSelf.moogBassSoundArray.contains(beattt) || paidsubBassSoundFilteringCode == 1 && !strongSelf.subBassSoundArray.contains(beattt) || paidsynthBassDistortedSoundFilteringCode == 1 && !strongSelf.synthBassDistortedSoundArray.contains(beattt) || paidsynthBassDeepSoundFilteringCode == 1 && !strongSelf.synthBassDeepSoundArray.contains(beattt) || paidsnapSoundFilteringCode == 1 && !strongSelf.snapSoundArray.contains(beattt)
                            {
                                let index = strongSelf.soundsSelectedArray.firstIndex{$0 === beattt}
                                if index != nil {
                                    strongSelf.soundsSelectedArray.remove(at: index!)
                                }
                            }
                        }
                        for beattt in strongSelf.filteredBeats {
                            if !strongSelf.soundsSelectedArray.contains(beattt) {
                                let index = strongSelf.filteredBeats.firstIndex{$0 === beattt}
                                if index != nil {
                                    strongSelf.filteredBeats.remove(at: index!)
                                }
                            }
                        }
                    }
                } else if spickedCode == 0 {
                    if paidallSoundsFilteringCode == 0 {
                        strongSelf.filteredBeats = []
                        if paidkeyfliteringCode == 1 {
                            for beat in strongSelf.keySelectedArray {
                                if paidtypefilteringCode==1&&strongSelf.typeSelectedArray.contains(beat) || paidtempofilteringCode==1&&strongSelf.tempoSelectedArray.contains(beat) || paidproducersfilteringCode==1&&strongSelf.producerSelectedArray.contains(beat) {
                                    if !strongSelf.filteredBeats.contains(beat) {
                                        strongSelf.filteredBeats.append(beat)
                                    }
                                }
                                else if !strongSelf.filteredBeats.contains(beat) {
                                    strongSelf.filteredBeats.append(beat)
                                }
                            }
                        }
                        if paidtypefilteringCode == 1 {
                            for beat in strongSelf.typeSelectedArray {
                                if paidkeyfliteringCode==1&&strongSelf.keySelectedArray.contains(beat) || paidtempofilteringCode==1&&strongSelf.tempoSelectedArray.contains(beat) || paidproducersfilteringCode==1&&strongSelf.producerSelectedArray.contains(beat) {
                                    if !strongSelf.filteredBeats.contains(beat) {
                                        strongSelf.filteredBeats.append(beat)
                                    }
                                }
                                else if !strongSelf.filteredBeats.contains(beat) {
                                    strongSelf.filteredBeats.append(beat)
                                }
                            }
                        }
                        if paidtempofilteringCode == 1 {
                            for beat in strongSelf.tempoSelectedArray {
                                if paidtypefilteringCode==1&&strongSelf.typeSelectedArray.contains(beat) || paidkeyfliteringCode==1&&strongSelf.keySelectedArray.contains(beat) || paidproducersfilteringCode==1&&strongSelf.producerSelectedArray.contains(beat) {
                                    if !strongSelf.filteredBeats.contains(beat) {
                                        strongSelf.filteredBeats.append(beat)
                                    }
                                }
                                else if !strongSelf.filteredBeats.contains(beat) {
                                    strongSelf.filteredBeats.append(beat)
                                }
                            }
                        }
                        if producersfilteringCode == 1 {
                            for beat in strongSelf.producerSelectedArray {
                                if paidtypefilteringCode==1&&strongSelf.typeSelectedArray.contains(beat) || paidtempofilteringCode==1&&strongSelf.tempoSelectedArray.contains(beat) || paidkeyfliteringCode==1&&strongSelf.keySelectedArray.contains(beat) {
                                    if !strongSelf.filteredBeats.contains(beat) {
                                        strongSelf.filteredBeats.append(beat)
                                    }
                                }
                                else if !strongSelf.filteredBeats.contains(beat) {
                                    strongSelf.filteredBeats.append(beat)
                                }
                            }
                        }
                        for beat in strongSelf.filteredBeats
                        {
                            if !strongSelf.keySelectedArray.contains(beat) && paidkeyfliteringCode == 1 || !strongSelf.typeSelectedArray.contains(beat) && paidtypefilteringCode == 1 || !strongSelf.tempoSelectedArray.contains(beat) && paidtempofilteringCode == 1 || !strongSelf.producerSelectedArray.contains(beat) && paidproducersfilteringCode == 1 {
                                let index = strongSelf.filteredBeats.firstIndex{$0 === beat}
                                if index != nil {
                                    strongSelf.filteredBeats.remove(at: index!)
                                }
                            }
                        }
                    } else if paidallSoundsFilteringCode > 0{
                        strongSelf.soundsSelectedArray = []
                        if paidkeysSoundFilteringCode == 1 {
                            spickedArray = strongSelf.keysSoundArray
                        } else if paidpianoAcousticSoundFilteringCode == 1 {
                            spickedArray = strongSelf.pianoAcousticSoundArray
                        } else if paidpianoVinylSoundFilteringCode == 1 {
                            spickedArray = strongSelf.pianoVinylSoundArray
                        } else if paidpianoElectricSoundFilteringCode == 1 {
                            spickedArray = strongSelf.pianoElectricSoundArray
                        } else if paidpianoRhodesSoundFilteringCode == 1 {
                            spickedArray = strongSelf.pianoRhodesSoundArray
                        } else if paidorganSoundFilteringCode == 1 {
                            spickedArray = strongSelf.organSoundArray
                        } else if paidtheraminSoundFilteringCode == 1 {
                            spickedArray = strongSelf.theraminSoundArray
                        } else if paidwhistleSoundFilteringCode == 1 {
                            spickedArray = strongSelf.whistleSoundArray
                        } else if paidhornsSoundFilteringCode == 1 {
                            spickedArray = strongSelf.hornsSoundArray
                        } else if paidstringsSoundFilteringCode == 1 {
                            spickedArray = strongSelf.stringsSoundArray
                        } else if paidfluteSoundFilteringCode == 1 {
                            spickedArray = strongSelf.fluteSoundArray
                        } else if paidpadBellSoundFilteringCode == 1 {
                            spickedArray = strongSelf.padBellSoundArray
                        } else if paidpadHollowSoundFilteringCode == 1 {
                            spickedArray = strongSelf.padHollowSoundArray
                        } else if paidpadAggressiveSoundFilteringCode == 1 {
                            spickedArray = strongSelf.padAggressiveSoundArray
                        } else if paidchoirSoundFilteringCode == 1 {
                            spickedArray = strongSelf.choirSoundArray
                        } else if paidsaxophoneSoundFilteringCode == 1 {
                            spickedArray = strongSelf.saxophoneSoundArray
                        } else if paidguitarElectricSoundFilteringCode == 1 {
                            spickedArray = strongSelf.guitarElectricSoundArray
                        } else if paidguitarAcousticSoundFilteringCode == 1 {
                            spickedArray = strongSelf.guitarAcousticSoundArray
                        } else if paidguitarSteelSoundFilteringCode == 1 {
                            spickedArray = strongSelf.guitarSteelSoundArray
                        } else if paidbellsEDMSoundFilteringCode == 1 {
                            spickedArray = strongSelf.bellsEDMSoundArray
                        } else if paidbellsVinylSoundFilteringCode == 1 {
                            spickedArray = strongSelf.bellsVinylSoundArray
                        } else if paidbellsGothicSoundFilteringCode == 1 {
                            spickedArray = strongSelf.bellsGothicSoundArray
                        } else if paidbellsHollowSoundFilteringCode == 1 {
                            spickedArray = strongSelf.bellsHollowSoundArray
                        } else if paidbellsMusicBoxSoundFilteringCode == 1 {
                            spickedArray = strongSelf.bellsMusicBoxSoundArray
                        } else if paidsampleVocalSoundFilteringCode == 1 {
                            spickedArray = strongSelf.sampleVocalSoundArray
                        } else if paidsampleSongSoundFilteringCode == 1 {
                            spickedArray = strongSelf.sampleSongSoundArray
                        } else if paidnoKickSoundFilteringCode == 1 {
                            spickedArray = strongSelf.noKickSoundArray
                        } else if paidkickSoundFilteringCode == 1 {
                            spickedArray = strongSelf.kickSoundArray
                        } else if paidlong808SoundFilteringCode == 1 {
                            spickedArray = strongSelf.long808SoundArray
                        } else if paidshort808SoundFilteringCode == 1 {
                            spickedArray = strongSelf.short808SoundArray
                        } else if paidclean808SoundFilteringCode == 1 {
                            spickedArray = strongSelf.clean808SoundArray
                        } else if paiddistorted808SoundFilteringCode == 1 {
                            spickedArray = strongSelf.distorted808SoundArray
                        } else if paidmoogBassSoundFilteringCode == 1 {
                            spickedArray = strongSelf.moogBassSoundArray
                        } else if paidsubBassSoundFilteringCode == 1 {
                            spickedArray = strongSelf.subBassSoundArray
                        } else if paidsynthBassDistortedSoundFilteringCode == 1 {
                            spickedArray = strongSelf.synthBassDistortedSoundArray
                        } else if paidsynthBassDeepSoundFilteringCode == 1 {
                            spickedArray = strongSelf.synthBassDeepSoundArray
                        } else if paidsnapSoundFilteringCode == 1 {
                            spickedArray = strongSelf.snapSoundArray
                        }
                        strongSelf.soundsSelectedArray.append(contentsOf: spickedArray)
                        for beattt in strongSelf.soundsSelectedArray {
                            if paidkeysSoundFilteringCode == 1 && !strongSelf.keysSoundArray.contains(beattt) || paidpianoAcousticSoundFilteringCode == 1 && !strongSelf.pianoAcousticSoundArray.contains(beattt) || paidpianoElectricSoundFilteringCode == 1 && !strongSelf.pianoElectricSoundArray.contains(beattt) || paidpianoRhodesSoundFilteringCode == 1 && !strongSelf.pianoRhodesSoundArray.contains(beattt) || paidpianoVinylSoundFilteringCode == 1 && !strongSelf.pianoVinylSoundArray.contains(beattt) || paidorganSoundFilteringCode == 1 && !strongSelf.organSoundArray.contains(beattt) || paidtheraminSoundFilteringCode == 1 && !strongSelf.theraminSoundArray.contains(beattt) || paidwhistleSoundFilteringCode == 1 && !strongSelf.whistleSoundArray.contains(beattt) || paidhornsSoundFilteringCode == 1 && !strongSelf.hornsSoundArray.contains(beattt) || paidstringsSoundFilteringCode == 1 && !strongSelf.stringsSoundArray.contains(beattt) || paidfluteSoundFilteringCode == 1 && !strongSelf.fluteSoundArray.contains(beattt) || paidpadBellSoundFilteringCode == 1 && !strongSelf.padBellSoundArray.contains(beattt) || paidpadHollowSoundFilteringCode == 1 && !strongSelf.padHollowSoundArray.contains(beattt) || paidpadAggressiveSoundFilteringCode == 1 && !strongSelf.padAggressiveSoundArray.contains(beattt) || paidchoirSoundFilteringCode == 1 && !strongSelf.choirSoundArray.contains(beattt) || paidsaxophoneSoundFilteringCode == 1 && !strongSelf.saxophoneSoundArray.contains(beattt) || paidguitarElectricSoundFilteringCode == 1 && !strongSelf.guitarElectricSoundArray.contains(beattt) || paidguitarAcousticSoundFilteringCode == 1 && !strongSelf.guitarAcousticSoundArray.contains(beattt) || paidguitarSteelSoundFilteringCode == 1 && !strongSelf.guitarSteelSoundArray.contains(beattt) || paidbellsEDMSoundFilteringCode == 1 && !strongSelf.bellsEDMSoundArray.contains(beattt) || paidbellsVinylSoundFilteringCode == 1 && !strongSelf.bellsVinylSoundArray.contains(beattt) || paidbellsGothicSoundFilteringCode == 1 && !strongSelf.bellsGothicSoundArray.contains(beattt) || paidbellsHollowSoundFilteringCode == 1 && !strongSelf.bellsHollowSoundArray.contains(beattt) || paidbellsMusicBoxSoundFilteringCode == 1 && !strongSelf.bellsMusicBoxSoundArray.contains(beattt) || paidsampleVocalSoundFilteringCode == 1 && !strongSelf.sampleVocalSoundArray.contains(beattt) || paidsampleSongSoundFilteringCode == 1 && !strongSelf.sampleSongSoundArray.contains(beattt) || paidnoKickSoundFilteringCode == 1 && !strongSelf.noKickSoundArray.contains(beattt) || paidkickSoundFilteringCode == 1 && !strongSelf.kickSoundArray.contains(beattt) || paidlong808SoundFilteringCode == 1 && !strongSelf.long808SoundArray.contains(beattt) || paidshort808SoundFilteringCode == 1 && !strongSelf.short808SoundArray.contains(beattt) || paidclean808SoundFilteringCode == 1 && !strongSelf.clean808SoundArray.contains(beattt) || paiddistorted808SoundFilteringCode == 1 && !strongSelf.distorted808SoundArray.contains(beattt) || paidmoogBassSoundFilteringCode == 1 && !strongSelf.moogBassSoundArray.contains(beattt) || paidsubBassSoundFilteringCode == 1 && !strongSelf.subBassSoundArray.contains(beattt) || paidsynthBassDistortedSoundFilteringCode == 1 && !strongSelf.synthBassDistortedSoundArray.contains(beattt) || paidsynthBassDeepSoundFilteringCode == 1 && !strongSelf.synthBassDeepSoundArray.contains(beattt) || paidsnapSoundFilteringCode == 1 && !strongSelf.snapSoundArray.contains(beattt)
                            {
                                let index = strongSelf.soundsSelectedArray.firstIndex{$0 === beattt}
                                if index != nil {
                                    strongSelf.soundsSelectedArray.remove(at: index!)
                                }
                            }
                        }
                        strongSelf.filteredBeats = []
                        strongSelf.filteredBeats.append(contentsOf: strongSelf.soundsSelectedArray)
                        for beat in strongSelf.filteredBeats {
                            if paidtypefilteringCode==1 && !strongSelf.typeSelectedArray.contains(beat) || paidtempofilteringCode==1 && !strongSelf.tempoSelectedArray.contains(beat) || paidproducersfilteringCode==1 && !strongSelf.producerSelectedArray.contains(beat) || paidkeyfliteringCode==1 && !strongSelf.keySelectedArray.contains(beat) {
                                let index = strongSelf.filteredBeats.firstIndex{$0 === beat}
                                if index != nil {
                                    strongSelf.filteredBeats.remove(at: index!)
                                }
                                
                            }
                        }
                    }
                }
            }
            strongSelf.reSortFilteredBeats()
            strongSelf.paidBeatTableView.reloadData()
        })
    }
    
    
    
    
    
    
    
    
    
    
    
   //MARK: - ALL STATUSES
    
    @objc func tempoFilterStatus(notification: NSNotification) {
        if tempoSelectedArray != [] {
            if paidtempofilteringCode == 0 {
                print("Remove selected from final if it is not in any other selected arrays that have a filtering code of 1")
                if paidnumberOfActiveFilterCells == 0{
                    print("number of active filter cells = \(paidnumberOfActiveFilterCells)")
                    filteredBeats = initialBeats
                    reSortFilteredBeats()
                    paidBeatTableView.reloadData()
                } else {
                    filteredBeats = []
                    if paidkeyfliteringCode == 1 {
                        filteredBeats = keySelectedArray
                    } else
                    if paidtypefilteringCode == 1 {
                        filteredBeats = typeSelectedArray
                    } else
                    if paidsoundsfilteringCode == 1 {
                        filteredBeats = soundsSelectedArray
                    } else
                    if paidproducersfilteringCode == 1 {
                        filteredBeats = producerSelectedArray
                    }
                    for beat in filteredBeats {
                        if paidsoundsfilteringCode==1 && !soundsSelectedArray.contains(beat) || paidtypefilteringCode==1 && !typeSelectedArray.contains(beat) || paidproducersfilteringCode==1 && !producerSelectedArray.contains(beat) || paidkeyfliteringCode==1 && !keySelectedArray.contains(beat) {
                            let index = filteredBeats.firstIndex{$0 === beat}
                            if index != nil {
                                filteredBeats.remove(at: index!)
                            }
                            
                        }
                    }
                    DispatchQueue.main.async { [weak self] in
                        guard let strongSelf = self else {return}
                        strongSelf.paidBeatTableView.reloadData()
                        strongSelf.reSortFilteredBeats()
                    }
//                    for beat in tempoSelectedArray
//                    {
//                        if !keySelectedArray.contains(beat) && !typeSelectedArray.contains(beat) && !soundsSelectedArray.contains(beat) && !producerSelectedArray.contains(beat){
//                            //let index = filteredBeats.firstIndex(of: beat)
//                            let index = filteredBeats.firstIndex{$0 === beat}
//                            if index != nil {
//                                filteredBeats.remove(at: index!)
//                            }
//                        }
//                    }
//                    print("key code on/off = \(keyfliteringCode)")
//                    if paidkeyfliteringCode == 1 {
//                        for beat in keySelectedArray {
//                            if paidtypefilteringCode==1&&typeSelectedArray.contains(beat) || paidsoundsfilteringCode==1&&soundsSelectedArray.contains(beat) || paidproducersfilteringCode==1&&producerSelectedArray.contains(beat) {
//                                if !filteredBeats.contains(beat) {
//                                    filteredBeats.append(beat)
//                                }
//                            }
////                            else if !filteredBeats.contains(beat) {
////                                filteredBeats.append(beat)
////                            }
//                        }
//                    }
//                    if paidtypefilteringCode == 1 {
//                        for beat in typeSelectedArray {
//                            if paidkeyfliteringCode==1&&keySelectedArray.contains(beat) || paidsoundsfilteringCode==1&&soundsSelectedArray.contains(beat) || paidproducersfilteringCode==1&&producerSelectedArray.contains(beat) {
//                                if !filteredBeats.contains(beat) {
//                                    filteredBeats.append(beat)
//                                }
//                            }
////                            else if !filteredBeats.contains(beat) {
////                                filteredBeats.append(beat)
////                            }
//                        }
//                    }
//                    if paidsoundsfilteringCode == 1 {
//                        for beat in soundsSelectedArray {
//                            if paidtypefilteringCode==1&&typeSelectedArray.contains(beat) || paidkeyfliteringCode==1&&keySelectedArray.contains(beat) || paidproducersfilteringCode==1&&producerSelectedArray.contains(beat) {
//                                if !filteredBeats.contains(beat) {
//                                    filteredBeats.append(beat)
//                                }
//                            }
////                            else if !filteredBeats.contains(beat) {
////                                filteredBeats.append(beat)
////                            }
//                        }
//                    }
//                    if paidproducersfilteringCode == 1 {
//                        for beat in producerSelectedArray {
//                            if paidtypefilteringCode==1&&typeSelectedArray.contains(beat) || paidsoundsfilteringCode==1&&soundsSelectedArray.contains(beat) || paidkeyfliteringCode==1&&keySelectedArray.contains(beat) {
//                                if !filteredBeats.contains(beat) {
//                                    filteredBeats.append(beat)
//                                }
//                            }
////                            else if !filteredBeats.contains(beat) {
////                                filteredBeats.append(beat)
////                            }
//                        }
//                    }
//                    reSortFilteredBeats()
//                    paidBeatTableView.reloadData()
                }
            }
            else if paidtempofilteringCode == 1 {
                print("Add selected to final if it is not already in final.")
                if paidnumberOfActiveFilterCells == 1{
                    filteredBeats = tempoSelectedArray
                } else if paidnumberOfActiveFilterCells > 1 {
                    filteredBeats = tempoSelectedArray
                    for beat in filteredBeats
                    {
                        if !keySelectedArray.contains(beat)&&paidkeyfliteringCode==1 || !typeSelectedArray.contains(beat)&&paidtypefilteringCode==1 || !soundsSelectedArray.contains(beat)&&paidsoundsfilteringCode==1 || !producerSelectedArray.contains(beat)&&paidproducersfilteringCode==1
                        {
                           let index = filteredBeats.firstIndex{$0 === beat}
                           if index != nil {
                               filteredBeats.remove(at: index!)
                           }
                        }
                        
                    }
                }
                reSortFilteredBeats()
                paidBeatTableView.reloadData()
            }
        } else {
            if paidnumberOfActiveFilterCells == 0 {
                filteredBeats = initialBeats
                DispatchQueue.main.async { [weak self] in
                    guard let strongSelf = self else {return}
                    strongSelf.paidBeatTableView.reloadData()
                    strongSelf.reSortFilteredBeats()
                }
            } else if paidnumberOfActiveFilterCells == 1 {
                filteredBeats = []
                DispatchQueue.main.async { [weak self] in
                    guard let strongSelf = self else {return}
                    strongSelf.paidBeatTableView.reloadData()
                    strongSelf.reSortFilteredBeats()
                }
            } else {
                if paidkeyfliteringCode == 0 {
                    filteredBeats = []
                    if paidkeyfliteringCode == 1 {
                        filteredBeats = keySelectedArray
                    } else
                    if paidtypefilteringCode == 1 {
                        filteredBeats = typeSelectedArray
                    } else
                    if paidsoundsfilteringCode == 1 {
                        filteredBeats = soundsSelectedArray
                    } else
                    if paidproducersfilteringCode == 1 {
                        filteredBeats = producerSelectedArray
                    }
                    for beat in filteredBeats {
                        if paidsoundsfilteringCode==1 && !soundsSelectedArray.contains(beat) || paidkeyfliteringCode==1 && !keySelectedArray.contains(beat) || paidproducersfilteringCode==1 && !producerSelectedArray.contains(beat) || paidtypefilteringCode==1 && !typeSelectedArray.contains(beat) {
                            let index = filteredBeats.firstIndex{$0 === beat}
                            if index != nil {
                                filteredBeats.remove(at: index!)
                            }
                            
                        }
                    }
                    DispatchQueue.main.async { [weak self] in
                        guard let strongSelf = self else {return}
                        strongSelf.paidBeatTableView.reloadData()
                        strongSelf.reSortFilteredBeats()
                    }
                } else {
                    filteredBeats = []
                    DispatchQueue.main.async { [weak self] in
                        guard let strongSelf = self else {return}
                        strongSelf.paidBeatTableView.reloadData()
                        strongSelf.reSortFilteredBeats()
                    }
                }
            }
        }
    }
    
    @objc func keyFilterStatus(notification: NSNotification) {
        if keySelectedArray != [] {
            if paidkeyfliteringCode == 0 {
                print("Remove selected from final if it is not in any other selected arrays that have a filtering code of 1")
                if paidnumberOfActiveFilterCells == 0{
                    print("number of active filter cells = \(paidnumberOfActiveFilterCells)")
                    filteredBeats = initialBeats
                    reSortFilteredBeats()
                    paidBeatTableView.reloadData()
                } else {
                    filteredBeats = []
                    if paidtempofilteringCode == 1 {
                        filteredBeats = tempoSelectedArray
                    } else
                    if paidtypefilteringCode == 1 {
                        filteredBeats = typeSelectedArray
                    } else
                    if paidsoundsfilteringCode == 1 {
                        filteredBeats = soundsSelectedArray
                    } else
                    if paidproducersfilteringCode == 1 {
                        filteredBeats = producerSelectedArray
                    }
                    for beat in filteredBeats {
                        if paidsoundsfilteringCode==1 && !soundsSelectedArray.contains(beat) || paidtypefilteringCode==1 && !typeSelectedArray.contains(beat) || paidproducersfilteringCode==1 && !producerSelectedArray.contains(beat) || paidtempofilteringCode==1 && !tempoSelectedArray.contains(beat) {
                            let index = filteredBeats.firstIndex{$0 === beat}
                            if index != nil {
                                filteredBeats.remove(at: index!)
                            }
                            
                        }
                    }
                    DispatchQueue.main.async { [weak self] in
                        guard let strongSelf = self else {return}
                        strongSelf.paidBeatTableView.reloadData()
                        strongSelf.reSortFilteredBeats()
                    }
//                    for beat in keySelectedArray
//                    {
//                        if !tempoSelectedArray.contains(beat) && !typeSelectedArray.contains(beat) && !soundsSelectedArray.contains(beat) && !producerSelectedArray.contains(beat){
//                            //let index = filteredBeats.firstIndex(of: beat)
//                            let index = filteredBeats.firstIndex{$0 === beat}
//                            if index != nil {
//                                filteredBeats.remove(at: index!)
//                            }
//                        }
//                    }
//                    print("tempo code on/off = \(paidtempofilteringCode)")
//                    if paidtempofilteringCode == 1 {
//                        for beat in tempoSelectedArray {
//                            if paidtypefilteringCode==1&&typeSelectedArray.contains(beat) || paidsoundsfilteringCode==1&&soundsSelectedArray.contains(beat) || paidproducersfilteringCode==1&&producerSelectedArray.contains(beat) {
//                                print("\(beat) is")
//                                if !filteredBeats.contains(beat) {
//                                    filteredBeats.append(beat)
//                                }
//                            }
////                            else if !filteredBeats.contains(beat) {
////                                filteredBeats.append(beat)
////                            }
//
//                        }
//                    }
//                    //print("type code on/off = \(tempofilteringCode)")
//                    if paidtypefilteringCode == 1 {
//                        for beat in typeSelectedArray {
//                            if paidtempofilteringCode==1&&tempoSelectedArray.contains(beat) || paidsoundsfilteringCode==1&&soundsSelectedArray.contains(beat) || paidproducersfilteringCode==1&&producerSelectedArray.contains(beat) {
//                                if !filteredBeats.contains(beat) {
//                                    filteredBeats.append(beat)
//                                }
//                            }
////                            else if !filteredBeats.contains(beat) {
////                                filteredBeats.append(beat)
////                            }
//                        }
//                    }
//                    if paidsoundsfilteringCode == 1 {
//                        for beat in soundsSelectedArray {
//                            if paidtypefilteringCode==1&&typeSelectedArray.contains(beat) || paidtempofilteringCode==1&&tempoSelectedArray.contains(beat) || paidproducersfilteringCode==1&&producerSelectedArray.contains(beat) {
//                                if !filteredBeats.contains(beat) {
//                                    filteredBeats.append(beat)
//                                }
//                            }
////                            else if !filteredBeats.contains(beat) {
////                                filteredBeats.append(beat)
////                            }
//                        }
//                    }
//                    if paidproducersfilteringCode == 1 {
//                        for beat in producerSelectedArray {
//                            if paidtypefilteringCode==1&&typeSelectedArray.contains(beat) || paidsoundsfilteringCode==1&&soundsSelectedArray.contains(beat) || paidtempofilteringCode==1&&tempoSelectedArray.contains(beat) {
//                                if !filteredBeats.contains(beat) {
//                                    filteredBeats.append(beat)
//                                }
//                            }
////                            else if !filteredBeats.contains(beat) {
////                                filteredBeats.append(beat)
////                            }
//                        }
//                    }
//                    if tempoSelectedArray == [] && keySelectedArray == [] && typeSelectedArray == [] && soundsSelectedArray == [] && producerSelectedArray == [] {
//                        filteredBeats = initialBeats
//                    }
//                    reSortFilteredBeats()
//                    paidBeatTableView.reloadData()
                }
            }
            else if paidkeyfliteringCode == 1 {
                print("Add selected to final if it is not already in final.")
                if paidnumberOfActiveFilterCells == 1{
                    filteredBeats = keySelectedArray
                } else if paidnumberOfActiveFilterCells > 1 {
                    filteredBeats = keySelectedArray
                    for beat in filteredBeats
                    {
                        if !tempoSelectedArray.contains(beat)&&paidtempofilteringCode==1 || !typeSelectedArray.contains(beat)&&paidtypefilteringCode==1 || !soundsSelectedArray.contains(beat)&&paidsoundsfilteringCode==1 || !producerSelectedArray.contains(beat)&&paidproducersfilteringCode==1
                        {
                           let index = filteredBeats.firstIndex{$0 === beat}
                           if index != nil {
                               filteredBeats.remove(at: index!)
                           }
                        }
                        
                    }
                }
            
            reSortFilteredBeats()
            paidBeatTableView.reloadData()
            }
        } else {
            if paidnumberOfActiveFilterCells == 0 {
                filteredBeats = initialBeats
                DispatchQueue.main.async { [weak self] in
                    guard let strongSelf = self else {return}
                    strongSelf.paidBeatTableView.reloadData()
                    strongSelf.reSortFilteredBeats()
                }
            } else if paidnumberOfActiveFilterCells == 1 {
                filteredBeats = []
                DispatchQueue.main.async { [weak self] in
                    guard let strongSelf = self else {return}
                    strongSelf.paidBeatTableView.reloadData()
                    strongSelf.reSortFilteredBeats()
                }
            } else {
                if paidtempofilteringCode == 0 {
                    filteredBeats = []
                    if paidtempofilteringCode == 1 {
                        filteredBeats = tempoSelectedArray
                    } else
                    if paidtypefilteringCode == 1 {
                        filteredBeats = typeSelectedArray
                    } else
                    if paidsoundsfilteringCode == 1 {
                        filteredBeats = soundsSelectedArray
                    } else
                    if paidproducersfilteringCode == 1 {
                        filteredBeats = producerSelectedArray
                    }
                    for beat in filteredBeats {
                        if paidsoundsfilteringCode==1 && !soundsSelectedArray.contains(beat) || paidtypefilteringCode==1 && !typeSelectedArray.contains(beat) || paidproducersfilteringCode==1 && !producerSelectedArray.contains(beat) || paidtempofilteringCode==1 && !tempoSelectedArray.contains(beat) {
                            let index = filteredBeats.firstIndex{$0 === beat}
                            if index != nil {
                                filteredBeats.remove(at: index!)
                            }
                            
                        }
                    }
                    DispatchQueue.main.async { [weak self] in
                        guard let strongSelf = self else {return}
                        strongSelf.paidBeatTableView.reloadData()
                        strongSelf.reSortFilteredBeats()
                    }
                } else {
                    filteredBeats = []
                    DispatchQueue.main.async { [weak self] in
                        guard let strongSelf = self else {return}
                        strongSelf.paidBeatTableView.reloadData()
                        strongSelf.reSortFilteredBeats()
                    }
                }
            }
        }
    }
    
    @objc func typeFilterStatus(notification: NSNotification) {
        if typeSelectedArray != [] && paidallTypeFilteringCode != 0{
            if paidtypefilteringCode == 0 {
                //print("Remove selected from final if it is not in any other selected arrays that have a filtering code of 1")
                if paidnumberOfActiveFilterCells == 0{
                    print("number of active filter cells = \(paidnumberOfActiveFilterCells)")
                    filteredBeats = initialBeats
                    reSortFilteredBeats()
                    paidBeatTableView.reloadData()
                } else {
                    filteredBeats = []
                    if paidtempofilteringCode == 1 {
                        filteredBeats = tempoSelectedArray
                    } else
                    if paidkeyfliteringCode == 1 {
                        filteredBeats = keySelectedArray
                    } else
                    if paidsoundsfilteringCode == 1 {
                        filteredBeats = soundsSelectedArray
                    } else
                    if paidproducersfilteringCode == 1 {
                        filteredBeats = producerSelectedArray
                    }
                    for beat in filteredBeats {
                        if paidsoundsfilteringCode==1 && !soundsSelectedArray.contains(beat) || paidtempofilteringCode==1 && !tempoSelectedArray.contains(beat) || paidproducersfilteringCode==1 && !producerSelectedArray.contains(beat) || paidkeyfliteringCode==1 && !keySelectedArray.contains(beat) {
                            let index = filteredBeats.firstIndex{$0 === beat}
                            if index != nil {
                                filteredBeats.remove(at: index!)
                            }
                            
                        }
                    }
                    DispatchQueue.main.async { [weak self] in
                        guard let strongSelf = self else {return}
                        strongSelf.paidBeatTableView.reloadData()
                        strongSelf.reSortFilteredBeats()
                    }
//                    for beat in typeSelectedArray
//                    {
//                        if !tempoSelectedArray.contains(beat) && !keySelectedArray.contains(beat) && !soundsSelectedArray.contains(beat) && !producerSelectedArray.contains(beat){
//                            //let index = filteredBeats.firstIndex(of: beat)
//                            let index = filteredBeats.firstIndex{$0 === beat}
//                            if index != nil {
//                                filteredBeats.remove(at: index!)
//                            }
//                        }
//                    }
//                    print("tempo code on/off = \(paidtypefilteringCode)")
//                    if paidtempofilteringCode == 1 {
//                        for beat in tempoSelectedArray {
//                            if paidkeyfliteringCode==1&&keySelectedArray.contains(beat) || paidsoundsfilteringCode==1&&soundsSelectedArray.contains(beat) || paidproducersfilteringCode==1&&producerSelectedArray.contains(beat) {
//                                print("\(beat) is")
//                                if !filteredBeats.contains(beat) {
//                                    filteredBeats.append(beat)
//                                }
//                            }
////                            else if !filteredBeats.contains(beat) {
////                                filteredBeats.append(beat)
////                            }
//
//                        }
//                    }
//                    //print("type code on/off = \(tempofilteringCode)")
//                    if paidkeyfliteringCode == 1 {
//                        for beat in keySelectedArray {
//                            if paidtempofilteringCode==1&&tempoSelectedArray.contains(beat) || paidsoundsfilteringCode==1&&soundsSelectedArray.contains(beat) || paidproducersfilteringCode==1&&producerSelectedArray.contains(beat) {
//                                if !filteredBeats.contains(beat) {
//                                    filteredBeats.append(beat)
//                                }
//                            }
////                            else if !filteredBeats.contains(beat) {
////                                filteredBeats.append(beat)
////                            }
//                        }
//                    }
//                    if paidsoundsfilteringCode == 1 {
//                        for beat in soundsSelectedArray {
//                            if paidkeyfliteringCode==1&&keySelectedArray.contains(beat) || paidtempofilteringCode==1&&tempoSelectedArray.contains(beat) || paidproducersfilteringCode==1&&producerSelectedArray.contains(beat) {
//                                if !filteredBeats.contains(beat) {
//                                    filteredBeats.append(beat)
//                                }
//                            }
////                            else if !filteredBeats.contains(beat) {
////                                filteredBeats.append(beat)
////                            }
//                        }
//                    }
//                    if paidproducersfilteringCode == 1 {
//                        for beat in producerSelectedArray {
//                            if paidkeyfliteringCode==1&&keySelectedArray.contains(beat) || paidsoundsfilteringCode==1&&soundsSelectedArray.contains(beat) || paidtempofilteringCode==1&&tempoSelectedArray.contains(beat) {
//                                if !filteredBeats.contains(beat) {
//                                    filteredBeats.append(beat)
//                                }
//                            }
////                            else if !filteredBeats.contains(beat) {
////                                filteredBeats.append(beat)
////                            }
//                        }
//                    }
//                    reSortFilteredBeats()
//                    paidBeatTableView.reloadData()
                }
            }
            else if paidtypefilteringCode == 1 {
                print("Add selected to final if it is not already in final.")
                if paidnumberOfActiveFilterCells == 1{
                    filteredBeats = typeSelectedArray
                } else if paidnumberOfActiveFilterCells > 1 {
                    filteredBeats = typeSelectedArray
                    for beat in filteredBeats
                    {
                        if !tempoSelectedArray.contains(beat)&&paidtempofilteringCode==1 || !keySelectedArray.contains(beat)&&paidkeyfliteringCode==1 || !soundsSelectedArray.contains(beat)&&paidsoundsfilteringCode==1 || !producerSelectedArray.contains(beat)&&paidproducersfilteringCode==1
                        {
                           let index = filteredBeats.firstIndex{$0 === beat}
                           if index != nil {
                               filteredBeats.remove(at: index!)
                           }
                        }
                        
                    }
                }
                
                reSortFilteredBeats()
                paidBeatTableView.reloadData()
            }
            
        }
    }
    
    @objc func soundsFilterStatus(notification: NSNotification) {
        if paidallSoundsFilteringCode != 0{
            if paidsoundsfilteringCode == 0 {
                //print("Remove selected from final if it is not in any other selected arrays that have a filtering code of 1")
                if paidnumberOfActiveFilterCells == 0{
                    
                    print("number of active filter cells = \(paidnumberOfActiveFilterCells)")
                    filteredBeats = initialBeats
                    reSortFilteredBeats()
                    paidBeatTableView.reloadData()
                } else {
                    filteredBeats = []
                    if paidtempofilteringCode == 1 {
                        filteredBeats = tempoSelectedArray
                    } else
                    if paidkeyfliteringCode == 1 {
                        filteredBeats = keySelectedArray
                    } else
                    if paidtypefilteringCode == 1 {
                        filteredBeats = typeSelectedArray
                    } else
                    if paidproducersfilteringCode == 1 {
                        filteredBeats = producerSelectedArray
                    }
                    for beat in filteredBeats {
                        if paidtypefilteringCode==1 && !typeSelectedArray.contains(beat) || paidtempofilteringCode==1 && !tempoSelectedArray.contains(beat) || paidproducersfilteringCode==1 && !producerSelectedArray.contains(beat) || paidkeyfliteringCode==1 && !keySelectedArray.contains(beat) {
                            let index = filteredBeats.firstIndex{$0 === beat}
                            if index != nil {
                                filteredBeats.remove(at: index!)
                            }
                            
                        }
                    }
                    DispatchQueue.main.async { [weak self] in
                        guard let strongSelf = self else {return}
                        strongSelf.reSortFilteredBeats()
                        strongSelf.paidBeatTableView.reloadData()
                    }
//                    for beat in soundsSelectedArray
//                    {
//                        if !tempoSelectedArray.contains(beat) && !keySelectedArray.contains(beat) && !typeSelectedArray.contains(beat) && !producerSelectedArray.contains(beat){
//                            //let index = filteredBeats.firstIndex(of: beat)
//                            let index = filteredBeats.firstIndex{$0 === beat}
//                            if index != nil {
//                                filteredBeats.remove(at: index!)
//                            }
//                        }
//                    }
//                    print("tempo code on/off = \(paidsoundsfilteringCode)")
//                    if paidtempofilteringCode == 1 {
//                        for beat in tempoSelectedArray {
//                            if paidkeyfliteringCode==1&&keySelectedArray.contains(beat) || paidtypefilteringCode==1&&typeSelectedArray.contains(beat) || paidproducersfilteringCode==1&&producerSelectedArray.contains(beat) {
//                                if !filteredBeats.contains(beat) {
//                                    filteredBeats.append(beat)
//                                }
//                            } else if !filteredBeats.contains(beat) {
//                                filteredBeats.append(beat)
//                            }
//
//                        }
//
//                    }
//                    //print("type code on/off = \(tempofilteringCode)")
//                    if paidkeyfliteringCode == 1 {
//                        for beat in keySelectedArray {
//                            if paidtempofilteringCode==1&&tempoSelectedArray.contains(beat) || paidtypefilteringCode==1&&typeSelectedArray.contains(beat) || paidproducersfilteringCode==1&&producerSelectedArray.contains(beat) {
//                                if !filteredBeats.contains(beat) {
//                                    filteredBeats.append(beat)
//                                }
//                            }
////                            else if !filteredBeats.contains(beat) {
////                                filteredBeats.append(beat)
////                            }
//                        }
//
//                    }
//                    if paidtypefilteringCode == 1 {
//                        for beat in typeSelectedArray {
//                            //print(beat.name)
//                            if paidkeyfliteringCode==1&&keySelectedArray.contains(beat) || paidtempofilteringCode==1&&tempoSelectedArray.contains(beat) || paidproducersfilteringCode==1&&producerSelectedArray.contains(beat) {
//                                if !filteredBeats.contains(beat) {
//                                    filteredBeats.append(beat)
//                                }
//                            }
////                            else if !filteredBeats.contains(beat) {
////                                filteredBeats.append(beat)
////                            }
//                        }
//
//                    }
//                    if paidproducersfilteringCode == 1 {
//                        for beat in producerSelectedArray {
//                            if paidkeyfliteringCode==1&&keySelectedArray.contains(beat) || paidtypefilteringCode==1&&typeSelectedArray.contains(beat) || paidtempofilteringCode==1&&tempoSelectedArray.contains(beat) {
//                                if !filteredBeats.contains(beat) {
//                                    filteredBeats.append(beat)
//                                }
//                            }
////                            else if !filteredBeats.contains(beat) {
////                                filteredBeats.append(beat)
////                            }
//                        }
//                    }
//                    DispatchQueue.main.async { [weak self] in
//                        guard let strongSelf = self else {return}
//                        strongSelf.paidBeatTableView.reloadData()
//                        strongSelf.reSortFilteredBeats()
//                    }
                }
            }
            else if paidsoundsfilteringCode == 1 {
                print("Add selected to final if it is not already in final.")
                if paidnumberOfActiveFilterCells == 1{
                    filteredBeats = soundsSelectedArray
                } else if paidnumberOfActiveFilterCells > 1 {
                    filteredBeats = soundsSelectedArray
                    for beat in filteredBeats
                    {
                        if !tempoSelectedArray.contains(beat)&&paidtempofilteringCode==1 || !typeSelectedArray.contains(beat)&&paidtypefilteringCode==1 || !keySelectedArray.contains(beat)&&paidkeyfliteringCode==1 || !producerSelectedArray.contains(beat)&&paidproducersfilteringCode==1
                        {
                           let index = filteredBeats.firstIndex{$0 === beat}
                           if index != nil {
                               filteredBeats.remove(at: index!)
                           }
                        }
                        
                    }
                }
                DispatchQueue.main.async { [weak self] in
                    guard let strongSelf = self else {return}
                    strongSelf.paidBeatTableView.reloadData()
                    strongSelf.reSortFilteredBeats()
                }
            }
        }
    }
    
    
    
    
    
    
    
    //MARK: - ALL RESETS
    
    @objc func tempoFilterReset(notification: NSNotification) {
        tempoSelectedArray = []
                print("Remove selected from final if it is not in any other selected arrays that have a filtering code of 1")
                if paidnumberOfActiveFilterCells == 0{
                    print("number of active filter cells = \(paidnumberOfActiveFilterCells)")
                    filteredBeats = initialBeats
                    reSortFilteredBeats()
                    paidBeatTableView.reloadData()
                } else {
                    filteredBeats = []
                    if paidkeyfliteringCode == 1 {
                        filteredBeats = keySelectedArray
                    } else
                    if paidtypefilteringCode == 1 {
                        filteredBeats = typeSelectedArray
                    } else
                    if paidsoundsfilteringCode == 1 {
                        filteredBeats = soundsSelectedArray
                    } else
                    if paidproducersfilteringCode == 1 {
                        filteredBeats = producerSelectedArray
                    }
                    for beat in filteredBeats {
                        if paidsoundsfilteringCode==1 && !soundsSelectedArray.contains(beat) || paidtempofilteringCode==1 && !tempoSelectedArray.contains(beat) || paidproducersfilteringCode==1 && !producerSelectedArray.contains(beat) || paidkeyfliteringCode==1 && !keySelectedArray.contains(beat) {
                            let index = filteredBeats.firstIndex{$0 === beat}
                            if index != nil {
                                filteredBeats.remove(at: index!)
                            }
                            
                        }
                    }
                    DispatchQueue.main.async { [weak self] in
                        guard let strongSelf = self else {return}
                        strongSelf.paidBeatTableView.reloadData()
                        strongSelf.reSortFilteredBeats()
                    }
                }
            
    }
    
    @objc func keyFilterReset(notification: NSNotification) {
        keySelectedArray = []
        print("Remove selected from final if it is not in any other selected arrays that have a filtering code of 1")
        if paidnumberOfActiveFilterCells == 0{
            print("number of active filter cells = \(paidnumberOfActiveFilterCells)")
            filteredBeats = initialBeats
            reSortFilteredBeats()
            paidBeatTableView.reloadData()
        } else {
            filteredBeats = []
            if paidtempofilteringCode == 1 {
                filteredBeats = tempoSelectedArray
            } else
            if paidtypefilteringCode == 1 {
                filteredBeats = typeSelectedArray
            } else
            if paidsoundsfilteringCode == 1 {
                filteredBeats = soundsSelectedArray
            } else
            if paidproducersfilteringCode == 1 {
                filteredBeats = producerSelectedArray
            }
            for beat in filteredBeats {
                if paidsoundsfilteringCode==1 && !soundsSelectedArray.contains(beat) || paidtypefilteringCode==1 && !typeSelectedArray.contains(beat) || paidproducersfilteringCode==1 && !producerSelectedArray.contains(beat) || paidtempofilteringCode==1 && !tempoSelectedArray.contains(beat) {
                    let index = filteredBeats.firstIndex{$0 === beat}
                    if index != nil {
                        filteredBeats.remove(at: index!)
                    }
                    
                }
            }
            DispatchQueue.main.async { [weak self] in
                guard let strongSelf = self else {return}
                strongSelf.paidBeatTableView.reloadData()
                strongSelf.reSortFilteredBeats()
            }
        }
    }
    
    @objc func typeFilterReset(notification: NSNotification) {
        typeSelectedArray = []
        print("Remove selected from final if it is not in any other selected arrays that have a filtering code of 1")
        if paidnumberOfActiveFilterCells == 0{
            print("number of active filter cells = \(paidnumberOfActiveFilterCells)")
            filteredBeats = initialBeats
            reSortFilteredBeats()
            paidBeatTableView.reloadData()
        } else {
            filteredBeats = []
            if paidtempofilteringCode == 1 {
                filteredBeats = tempoSelectedArray
            } else
            if paidkeyfliteringCode == 1 {
                filteredBeats = keySelectedArray
            } else
            if paidsoundsfilteringCode == 1 {
                filteredBeats = soundsSelectedArray
            } else
            if paidproducersfilteringCode == 1 {
                filteredBeats = producerSelectedArray
            }
            for beat in filteredBeats {
                if paidsoundsfilteringCode==1 && !soundsSelectedArray.contains(beat) || paidtempofilteringCode==1 && !tempoSelectedArray.contains(beat) || paidproducersfilteringCode==1 && !producerSelectedArray.contains(beat) || paidkeyfliteringCode==1 && !keySelectedArray.contains(beat) {
                    let index = filteredBeats.firstIndex{$0 === beat}
                    if index != nil {
                        filteredBeats.remove(at: index!)
                    }
                    
                }
            }
            DispatchQueue.main.async { [weak self] in
                guard let strongSelf = self else {return}
                strongSelf.paidBeatTableView.reloadData()
                strongSelf.reSortFilteredBeats()
            }
        }
    }
    
    @objc func soundsFilterReset(notification: NSNotification) {
        soundsSelectedArray = []
        print("Remove selected from final if it is not in any other selected arrays that have a filtering code of 1")
        if paidnumberOfActiveFilterCells == 0{
            print("number of active filter cells = \(paidnumberOfActiveFilterCells)")
            filteredBeats = initialBeats
            reSortFilteredBeats()
            paidBeatTableView.reloadData()
        } else {
            filteredBeats = []
            if paidtempofilteringCode == 1 {
                filteredBeats = tempoSelectedArray
            } else
            if paidkeyfliteringCode == 1 {
                filteredBeats = keySelectedArray
            } else
            if paidtypefilteringCode == 1 {
                filteredBeats = typeSelectedArray
            } else
            if paidproducersfilteringCode == 1 {
                filteredBeats = producerSelectedArray
            }
            for beat in filteredBeats {
                if paidtypefilteringCode==1 && !typeSelectedArray.contains(beat) || paidtempofilteringCode==1 && !tempoSelectedArray.contains(beat) || paidproducersfilteringCode==1 && !producerSelectedArray.contains(beat) || paidkeyfliteringCode==1 && !keySelectedArray.contains(beat) {
                    let index = filteredBeats.firstIndex{$0 === beat}
                    if index != nil {
                        filteredBeats.remove(at: index!)
                    }
                    
                }
            }
            DispatchQueue.main.async { [weak self] in
                guard let strongSelf = self else {return}
                strongSelf.reSortFilteredBeats()
                strongSelf.paidBeatTableView.reloadData()
            }
        }
    }
    
    
    
    
    
    
    
    func reSortFilteredBeats() {
        switch paidsortNumberForFilter {
        case 1:
            filteredBeats.sort(by: { $0.name < $1.name })
        case 2:
            filteredBeats.sort(by: { $0.name > $1.name })
        case 3:
            filteredBeats.sort(by: { $0.duration > $1.duration })
        case 4:
            filteredBeats.sort(by: { $0.duration < $1.duration })
        case 5:
            filteredBeats.sort(by: { $0.datetime > $1.datetime})
        case 6:
            filteredBeats.sort(by: { $0.datetime < $1.datetime})
        case 7:
            filteredBeats.sort(by: { $0.downloads > $1.downloads })
        case 8:
            filteredBeats.sort(by: { $0.downloads < $1.downloads })
        case 9:
            filteredBeats.sort(by: { $0.mp3Price ?? 0.00 > $1.mp3Price ?? 0.00 })
        case 10:
            filteredBeats.sort(by: { $0.mp3Price ?? 0.00 < $1.mp3Price ?? 0.00 })
        case 11:
            filteredBeats.sort(by: { $0.wavPrice ?? 0.00 > $1.wavPrice ?? 0.00 })
        case 12:
            filteredBeats.sort(by: { $0.wavPrice ?? 0.00 < $1.wavPrice ?? 0.00 })
        case 13:
            filteredBeats.sort(by: { $0.exclusivePrice ?? 0.00 > $1.exclusivePrice ?? 0.00 })
        case 14:
            filteredBeats.sort(by: { $0.exclusivePrice ?? 0.00 < $1.exclusivePrice ?? 0.00 })
        default:
            filteredBeats.sort(by: { $0.datetime > $1.datetime})
        }
    }
    
    @objc func paidBeatSort(notification: NSNotification) {
        //1
        if notification.object as? String == "A-Z" {
            print("A-Z sorting complete")
            filteredBeats.sort(by: { $0.name < $1.name })//A-Z
            paidsortNumberForFilter = 1
        }
        //2
        if notification.object as? String == "Z-A" {
            print("Z-A sorting complete")
            filteredBeats.sort(by: { $0.name > $1.name })//Z-A
            paidsortNumberForFilter = 2
        }
        //3
        if notification.object as? String == "Longest First" {
            print("Longest to shortest duration sorting complete")
            filteredBeats.sort(by: { $0.duration > $1.duration })
            paidsortNumberForFilter = 3
        }
        //4
        if notification.object as? String == "Shortest First" {
            print("Shortest to Longest duration sorting complete")
            filteredBeats.sort(by: { $0.duration < $1.duration })
            paidsortNumberForFilter = 4
        }
        //5
        if notification.object as? String == "Latest First" {
            print("Latest to Oldest date sorting complete")
            filteredBeats.sort(by: { $0.datetime > $1.datetime})
            paidsortNumberForFilter = 5
        }
        //6
        if notification.object as? String == "Oldest First" {
            print("Oldest to Latest date sorting complete")
            filteredBeats.sort(by: { $0.datetime < $1.datetime})
            paidsortNumberForFilter = 6
        }
        //7
        if notification.object as? String == "Most First" {
            print("Most to Least downloads sorting complete")
            filteredBeats.sort(by: { $0.downloads > $1.downloads })
            paidsortNumberForFilter = 7
        }
        //8
        if notification.object as? String == "Least First" {
            print("Least to Most downloads sorting complete")
            filteredBeats.sort(by: { $0.downloads < $1.downloads })
            sortNumberForFilter = 8
        }
        //9
        if notification.object as? String == "m$$$ - $" {
            print("$$$ - $ mp3 price sorting complete")
            filteredBeats.sort(by: { $0.mp3Price ?? 0.00 > $1.mp3Price ?? 0.00 })
            paidsortNumberForFilter = 9
        }
        //10
        if notification.object as? String == "m$ - $$$" {
            print("$ - $$$ mp3 price  sorting complete")
            filteredBeats.sort(by: { $0.mp3Price ?? 0.00 < $1.mp3Price ?? 0.00 })
            paidsortNumberForFilter = 10
        }
        //11
        if notification.object as? String == "w$$$ - $" {
            print("$$$ - $ wav price sorting complete")
            filteredBeats.sort(by: { $0.wavPrice ?? 0.00 > $1.wavPrice ?? 0.00 })
            paidsortNumberForFilter = 11
        }
        //12
        if notification.object as? String == "w$ - $$$" {
            print("$ - $$$ wav price  sorting complete")
            filteredBeats.sort(by: { $0.wavPrice ?? 0.00 < $1.wavPrice ?? 0.00 })
            paidsortNumberForFilter = 12
        }
        //13
        if notification.object as? String == "e$$$ - $" {
            print("$$$ - $ exclusive price sorting complete")
            filteredBeats.sort(by: { $0.exclusivePrice ?? 0.00 > $1.exclusivePrice ?? 0.00 })
            paidsortNumberForFilter = 13
        }
        //14
        if notification.object as? String == "e$ - $$$" {
            print("$ - $$$ exclusive price  sorting complete")
            filteredBeats.sort(by: { $0.exclusivePrice ?? 0.00 < $1.exclusivePrice ?? 0.00 })
            paidsortNumberForFilter = 14
        }
        DispatchQueue.main.async { [weak self] in
            guard let strongSelf = self else {return}
            strongSelf.paidBeatTableView.reloadData()
        }
        
    }
    
    @IBAction func filterButtonTapped(_ sender: Any) {
//        present(filterMenu!, animated: true)
    }
    
    @IBAction func sortButtonTapped(_ sender: Any) {
//        present(sortMenu!, animated: true)
    }
    
    func dismissKeyboardOnTap() {
        let tap = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        paidBeatTableView.keyboardDismissMode = .onDrag
    }

}


// MARK: - Table View Extension
extension PaidBeatsViewController: UITableViewDelegate, UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredBeats.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let beat = filteredBeats[indexPath.row]
            let cell = tableView.dequeueReusableCell(withIdentifier: "paidArtistBeatCell") as! PaidBeatArtistTableViewCell
            cell.setBeat(beat: beat)
            
            return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        if audiofreeze != true {
            player = nil
            playerTimer = Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(playertimerset), userInfo: nil, repeats: false)
            let myDict = [ "beats": filteredBeats, "position":indexPath.row] as [String : Any]
            NotificationCenter.default.post(name: AudioPlayerOnNotify, object: myDict)
        }
    }
    
    @objc func playertimerset() {
        audiofreeze = false
        print("Audio Freeze Off")
        playerTimer.invalidate()
    }
    
}


//MARK: - Search Bar

extension PaidBeatsViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchText == "" {
            filteredBeats = initialBeats
            filteredResultsLabel.isHidden = true
            reSortFilteredBeats()
            paidBeatTableView.reloadData()
        }
        else {
            searchedBeats = []
            for searchBeats in filteredBeats {
                if searchBeats.name.lowercased().contains(searchText.lowercased()) {
                    searchedBeats.append(searchBeats)
                }
                if searchBeats.name.lowercased().trimmingCharacters(in: .whitespacesAndNewlines).contains(searchText.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)) {
                    if !searchedBeats.contains(searchBeats) {
                        searchedBeats.append(searchBeats)
                    }
                }
                if searchBeats.producers != [""] {
                    for producer in searchBeats.producers {
                        let word = producer.split(separator: "Æ")
                        let contentName = word[1]
                        if contentName.lowercased().trimmingCharacters(in: .whitespacesAndNewlines).contains(searchText.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)) {
                            if !searchedBeats.contains(searchBeats) {
                                searchedBeats.append(searchBeats)
                            }
                        }
                    }
                    
                }
                if !searchBeats.types.isEmpty {
                    for type in searchBeats.types {
                        if type.lowercased().trimmingCharacters(in: .whitespacesAndNewlines).contains(searchText.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)) {
                            if !searchedBeats.contains(searchBeats) {
                                searchedBeats.append(searchBeats)
                            }
                        }
                    }
                }
                if !searchBeats.sounds.isEmpty {
                    for sound in searchBeats.sounds {
                        if sound.lowercased().trimmingCharacters(in: .whitespacesAndNewlines).contains(searchText.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)) {
                            if !searchedBeats.contains(searchBeats) {
                                searchedBeats.append(searchBeats)
                            }
                        }
                    }
                }
                
            }
            
            filteredBeats = searchedBeats
        }
        filteredResultsLabel.isHidden = false
        filteredResultsLabel.text = "\(String(filteredBeats.count)) results"
        reSortFilteredBeats()
        paidBeatTableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        filteredBeats = initialBeats
        filteredResultsLabel.isHidden = true
        reSortFilteredBeats()
        paidBeatTableView.reloadData()
    }
}

//MARK: - PaidSortCell

class PaidBeatSortCellTableViewCell: UITableViewCell {
    
    static let shared = PaidBeatSortCellTableViewCell()

    @IBOutlet weak var sortSubTypeLabel: UILabel!
    @IBOutlet weak var sortWayLabel: UILabel!
    @IBOutlet weak var sortWayBadge: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func update(counter: Int, label: String, countLeftOn: Int) {
        NotificationCenter.default.post(name: PaidSortChangedNotify, object: label)
        sortWayLabel.alpha = 1
        if counter == 1 {
            sortSubTypeLabel.isHidden = false
            sortWayBadge.isHidden = false
            sortSubTypeLabel.text = label
            if countLeftOn == 2 {
                paidcount += 1
            }
        } else {
            sortSubTypeLabel.text = label
            sortSubTypeLabel.isHidden = false
            sortWayBadge.isHidden = false
        }
    }
    
    func remove() {
        sortSubTypeLabel.isHidden = true
        sortWayBadge.isHidden = true
        sortWayLabel.alpha = 0.40
    }
    
    func setSort(sort: SortData) {
        sortWayLabel.text = sort.name
        sortSubTypeLabel.text = sort.sub
        sortWayLabel.alpha = 0.40
    }

}


public var paidselectedIndex:IndexPath!
public var paidselectedPath = 0
public var paidsortSubTypeText = ""
public var paidcount = 0
public var paidnameCountLeftOn = 1
public var paiddateCountLeftOn = 1
public var paiddurationCountLeftOn = 1
public var paiddownloadsCountLeftOn = 1
public var paidmp3CountLeftOn = 1
public var paidwavCountLeftOn = 1
public var paidexclusiveCountLeftOn = 1


//MARK: - PaidSortTableViewSetup, PaidSortMenuListController

class PaidSortMenuListController: UITableViewController {
    deinit {
        print("📗paid sort controller Deallocated")
    }
    
    static let shared = PaidSortMenuListController()
    
    @IBOutlet weak var clearButton: UIButton!
    var sorts: [SortData] = []
    
    override func viewDidLoad() {
    super.viewDidLoad()
        sorts = addSort()
        tableView.allowsMultipleSelection = true
        tableView.allowsSelectionDuringEditing = true
        tableView.allowsMultipleSelectionDuringEditing = true
        tableView.remembersLastFocusedIndexPath = true
        clearButton.isEnabled = false
        clearButton.setTitleColor(UIColor.init(red: 15/255, green: 15/255, blue: 15/255, alpha: 1), for: .disabled)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        tableView.reloadData()
    }
    
    func addSort() -> [SortData] {
        
        var tempsort: [SortData] = []
        
        let sortBy1 = SortData(name: "Name", sub: "A-Z")
        let sortBy2 = SortData(name: "Date", sub: "Latest First")
        let sortBy3 = SortData(name: "Duration", sub: "Longest First")
        let sortBy4 = SortData(name: "Downloads", sub: "Most First")
        let sortBy5 = SortData(name: "MP3 Price", sub: "m$$$ - $")
        let sortBy6 = SortData(name: "Wav Price", sub: "w$$$ - $")
        let sortBy7 = SortData(name: "Exclusive Price", sub: "e$$$ - $")
        
        tempsort.append(sortBy1)
        tempsort.append(sortBy2)
        tempsort.append(sortBy3)
        tempsort.append(sortBy4)
        tempsort.append(sortBy5)
        tempsort.append(sortBy6)
        tempsort.append(sortBy7)
        
        return tempsort
        
    }
    
    @IBAction func clearButtonTapped(_ sender: Any) {
        clearButton.isEnabled = false
        clearButton.setTitleColor(UIColor.init(red: 15/255, green: 15/255, blue: 15/255, alpha: 1), for: .disabled)
        let cell = tableView.cellForRow(at: paidselectedIndex) as! PaidBeatSortCellTableViewCell
        cell.remove()
        paidselectedIndex = nil
        paidselectedPath = 0
        paidsortSubTypeText = ""
        paidcount = 0
        paidnameCountLeftOn = 1
        paiddateCountLeftOn = 1
        paiddurationCountLeftOn = 1
        paiddownloadsCountLeftOn = 1
        paidmp3CountLeftOn = 1
        paidwavCountLeftOn = 1
        paidexclusiveCountLeftOn = 1
        tableView.reloadData()
        NotificationCenter.default.post(name: PaidSortChangedNotify, object: "Latest First")
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sorts.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let sort = sorts[indexPath.row]
        
            let cell = tableView.dequeueReusableCell(withIdentifier: "paidBeatSortCell") as! PaidBeatSortCellTableViewCell
            cell.setSort(sort: sort)
            return cell
        
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        clearButton.isEnabled = true
        clearButton.setTitleColor(UIColor.init(red: 182/255, green: 0/255, blue: 3/255, alpha: 1), for: .normal)
        if paidselectedPath != indexPath.row {
            if paidselectedIndex != nil {
                let lastcell = tableView.cellForRow(at: paidselectedIndex) as! PaidBeatSortCellTableViewCell
                lastcell.remove()
            }
        }
        let animate: Void = tableView.reloadRows(at: [indexPath], with: .automatic)
        let cell = tableView.cellForRow(at: indexPath) as! PaidBeatSortCellTableViewCell
        //print("indexPAth \(indexPath.row)")
        if indexPath.row == 0 {
            if paidselectedPath == 0 {
                paidcount += 1
                //print(count)
                if paidcount == 1 {
                    cell.update(counter: 1, label: "A-Z", countLeftOn: 1)
                    paidnameCountLeftOn = 1
                } else if count == 2 {
                    cell.update(counter: 2, label: "Z-A", countLeftOn: 2)
                    paidnameCountLeftOn = 2
                } else if paidcount == 3 {
                    cell.update(counter: 3, label: "A-Z", countLeftOn: 1)
                    paidnameCountLeftOn = 1
                    count -= 2
                }
            } else {
                animate
                paidcount = 1
                //print(nameCountLeftOn, nameCountLeftOn)
                var textleft = ""
                if paidnameCountLeftOn == 1 {
                    textleft = "A-Z"
                } else if paidnameCountLeftOn == 2 {
                    textleft = "Z-A"
                }
                cell.update(counter: 1, label: textleft, countLeftOn: paidnameCountLeftOn)
                //print(count)
            }
        }
        if indexPath.row == 1 {
            if paidselectedPath == 1 {
                paidcount += 1
                //print(count)
                if paidcount == 1 {
                    cell.update(counter: 1, label: "Latest First", countLeftOn: 1)
                    paiddateCountLeftOn = 1
                } else if paidcount == 2 {
                    cell.update(counter: 2, label: "Oldest First", countLeftOn: 2)
                    paiddateCountLeftOn = 2
                } else if paidcount == 3 {
                    cell.update(counter: 3, label: "Latest First", countLeftOn: 1)
                    paiddateCountLeftOn = 1
                    paidcount -= 2
                }
            } else {
                animate
                paidcount = 1
                //print(dateCountLeftOn,dateCountLeftOn)
                var textleft = ""
                if paiddateCountLeftOn == 1 {
                    textleft = "Latest First"
                } else if paiddateCountLeftOn == 2 {
                    textleft = "Oldest First"
                }
                cell.update(counter: 1, label: textleft, countLeftOn: paiddateCountLeftOn)
                //print(count)
            }
        }
        if indexPath.row == 2 {
            var textleft = ""
            if paidselectedPath == 2 {
                paidcount += 1
                //print(count)
                if paidcount == 1 {
                    cell.update(counter: 1, label: "Longest First", countLeftOn: 1)
                    paiddurationCountLeftOn = 1
                } else if paidcount == 2 {
                    cell.update(counter: 2, label: "Shortest First", countLeftOn: 2)
                    paiddurationCountLeftOn = 2
                } else if paidcount == 3 {
                    cell.update(counter: 3, label: "Longest First", countLeftOn: 1)
                    paiddurationCountLeftOn = 1
                    paidcount -= 2
                }
            } else {
                animate
                paidcount = 1
                if paiddurationCountLeftOn == 1 {
                    textleft = "Longest First"
                } else if paiddurationCountLeftOn == 2 {
                    textleft = "Shortest First"
                }
                cell.update(counter: 1, label: textleft, countLeftOn: paiddurationCountLeftOn)
                //print(count)
            }
        }
        if indexPath.row == 3 {
            if paidselectedPath == 3 {
                paidcount += 1
                //print(count)
                if paidcount == 1 {
                    cell.update(counter: 1, label: "Most First", countLeftOn: 1)
                    paiddownloadsCountLeftOn = 1
                } else if paidcount == 2 {
                    cell.update(counter: 2, label: "Least First", countLeftOn: 2)
                    paiddownloadsCountLeftOn = 2
                } else if paidcount == 3 {
                    cell.update(counter: 3, label: "Most First", countLeftOn: 1)
                    paiddownloadsCountLeftOn = 1
                    paidcount -= 2
                }
            } else {
                animate
                paidcount = 1
                var textleft = ""
                if paiddownloadsCountLeftOn == 1 {
                    textleft = "Most First"
                } else if paiddownloadsCountLeftOn == 2 {
                    textleft = "Least First"
                }
                cell.update(counter: 1, label: textleft, countLeftOn: paiddownloadsCountLeftOn)
                //print(count)
            }
        }
        if indexPath.row == 4 {
            if paidselectedPath == 4 {
                paidcount += 1
                //print(count)
                if paidcount == 1 {
                    cell.update(counter: 1, label: "m$$$ - $", countLeftOn: 1)
                    paidmp3CountLeftOn = 1
                } else if paidcount == 2 {
                    cell.update(counter: 2, label: "m$ - $$$", countLeftOn: 2)
                    paidmp3CountLeftOn = 2
                } else if paidcount == 3 {
                    cell.update(counter: 3, label: "m$$$ - $", countLeftOn: 1)
                    paidmp3CountLeftOn = 1
                    paidcount -= 2
                }
            } else {
                animate
                paidcount = 1
                var textleft = ""
                if paidmp3CountLeftOn == 1 {
                    textleft = "m$$$ - $"
                } else if paidmp3CountLeftOn == 2 {
                    textleft = "m$ - $$$"
                }
                cell.update(counter: 1, label: textleft, countLeftOn: paidmp3CountLeftOn)
                //print(count)
            }
        }
        if indexPath.row == 5 {
            if paidselectedPath == 5 {
                paidcount += 1
                //print(count)
                if paidcount == 1 {
                    cell.update(counter: 1, label: "w$$$ - $", countLeftOn: 1)
                    paidwavCountLeftOn = 1
                } else if paidcount == 2 {
                    cell.update(counter: 2, label: "w$ - $$$", countLeftOn: 2)
                    paidwavCountLeftOn = 2
                } else if paidcount == 3 {
                    cell.update(counter: 3, label: "w$$$ - $", countLeftOn: 1)
                    paidwavCountLeftOn = 1
                    paidcount -= 2
                }
            } else {
                animate
                paidcount = 1
                var textleft = ""
                if paidwavCountLeftOn == 1 {
                    textleft = "w$$$ - $"
                } else if paidwavCountLeftOn == 2 {
                    textleft = "w$ - $$$"
                }
                cell.update(counter: 1, label: textleft, countLeftOn: paidwavCountLeftOn)
                //print(count)
            }
        }
        if indexPath.row == 6 {
            if paidselectedPath == 6 {
                paidcount += 1
                //print(count)
                if paidcount == 1 {
                    cell.update(counter: 1, label: "e$$$ - $", countLeftOn: 1)
                    paidexclusiveCountLeftOn = 1
                } else if paidcount == 2 {
                    cell.update(counter: 2, label: "e$ - $$$", countLeftOn: 2)
                    paidexclusiveCountLeftOn = 2
                } else if paidcount == 3 {
                    cell.update(counter: 3, label: "e$$$ - $", countLeftOn: 1)
                    paidexclusiveCountLeftOn = 1
                    paidcount -= 2
                }
            } else {
                animate
                paidcount = 1
                var textleft = ""
                if paidexclusiveCountLeftOn == 1 {
                    textleft = "e$$$ - $"
                } else if paidexclusiveCountLeftOn == 2 {
                    textleft = "e$ - $$$"
                }
                cell.update(counter: 1, label: textleft, countLeftOn: paidexclusiveCountLeftOn)
                //print(count)
            }
        }
        paidselectedIndex = indexPath
        paidselectedPath = indexPath.row
        
        
    }
}

extension PaidBeatsViewController: SideMenuNavigationControllerDelegate {

    func sideMenuWillAppear(menu: SideMenuNavigationController, animated: Bool) {
        print("SideMenu Appearing! (animated: \(animated))")
    }

    func sideMenuDidAppear(menu: SideMenuNavigationController, animated: Bool) {
        print("SideMenu Appeared! (animated: \(animated))")
    }

    func sideMenuWillDisappear(menu: SideMenuNavigationController, animated: Bool) {
        print("SideMenu Disappearing! (animated: \(animated))")
    }

    func sideMenuDidDisappear(menu: SideMenuNavigationController, animated: Bool) {
        print("SideMenu Disappeared! (animated: \(animated))")
        SideMenuManager.default.rightMenuNavigationController = paidfilterMenu
        paidfilterMenu.setNavigationBarHidden(true, animated: false)
        paidfilterMenu.presentationStyle = .viewSlideOutMenuIn
    }
}
