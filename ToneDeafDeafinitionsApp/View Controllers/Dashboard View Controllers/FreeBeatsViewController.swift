//
//  FreeBeatsViewController.swift
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

let sortMenu = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "sortMenuNavController") as SideMenuNavigationController
let filterMenu = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "filterMenuNavController") as SideMenuNavigationController

//Sort
let FreeBeatSortUpdatedNotificationKey = "com.gitemsolutions.sortUpdated"

let SortChangedNotify = Notification.Name(FreeBeatSortUpdatedNotificationKey)

var lastTempoChoiceChanged = 0
var currentTempoChoiceChanged = 0
var sortNumberForFilter = 0
var numberOfActiveFilterCells = 0

class FreeBeatsViewController: UIViewController {
    
    static let shared = FreeBeatsViewController()
    
//    var player: AVAudioPlayer?
    //let audioPlayerViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "audioPlayerVC") as AudioPlayerViewController
    
    @IBOutlet weak var freeBeatTableView: UITableView!
    @IBOutlet weak var freeBeatSearchBar: UISearchBar!
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
    public var synthPolyArray: [BeatData] = []
    public var synthAnalogArray: [BeatData] = []
    public var producerSelectedArray: [BeatData] = []
    //public var currentFilteredBeats: [BeatData] = []
    @IBOutlet weak var tableViewBottomConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableViewBottomConstraint.constant = 73.5
        
        print("📙 acctype: \(accountType)")
        add()
        freeBeatSearchBar.delegate = self
        freeBeatTableView.delegate = self
        freeBeatTableView.dataSource = self
        
        SideMenuManager.default.rightMenuNavigationController = filterMenu
        SideMenuManager.default.addPanGestureToPresent(toView: self.view)
        filterMenu.setNavigationBarHidden(true, animated: false)
        filterMenu.presentationStyle = .viewSlideOutMenuIn
        
        SideMenuManager.default.leftMenuNavigationController = sortMenu
        SideMenuManager.default.addPanGestureToPresent(toView: self.view)
        sortMenu.setNavigationBarHidden(true, animated: false)
        sortMenu.presentationStyle = .viewSlideOutMenuIn
        
        dismissKeyboardOnTap()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        SideMenuManager.default.rightMenuNavigationController = filterMenu
        filterMenu.setNavigationBarHidden(true, animated: false)
        filterMenu.presentationStyle = .viewSlideOutMenuIn
        
        SideMenuManager.default.leftMenuNavigationController = sortMenu
        sortMenu.setNavigationBarHidden(true, animated: false)
        sortMenu.presentationStyle = .viewSlideOutMenuIn

    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
        print("📗beats controller Deallocated")
    }

    
    func add(){
        
        Database.database().reference().child("Beats").child("Free").observeSingleEvent(of: .value, with: { snapshot in
            FilteringManager.shared.setupArrayForBeatsTableView(snapshot: snapshot, completion: {[weak self] tempbeats in
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
                    strongSelf.freeBeatTableView.reloadData()
                }
            })
            
        })
    }
    
    func createObservers(){
        //sort
        NotificationCenter.default.addObserver(self, selector: #selector(FreeBeatsViewController.freeBeatSort), name: SortChangedNotify, object: nil)
        //tempo
        NotificationCenter.default.addObserver(self, selector: #selector(FreeBeatsViewController.tempoFilterMin), name: FilterTempoMinNotify, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(FreeBeatsViewController.tempoFilterMax), name: FilterTempoMaxNotify, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(FreeBeatsViewController.tempoFilterSpecified), name: FilterTempoSpecifiedNotify, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(FreeBeatsViewController.tempoFilterStatus), name: FilterTempoStatusNotify, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(FreeBeatsViewController.tempoFilterReset), name: FilterTempoResetNotify, object: nil)
        //key
        NotificationCenter.default.addObserver(self, selector: #selector(FreeBeatsViewController.keyFilterUpdate), name: FilterKeyChangedNotify, object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(FreeBeatsViewController.keyFilterAddUpdate), name: FilterKeyAddChangedNotify, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(FreeBeatsViewController.keyFilterReset), name: FilterKeyPickerResetNotify, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector (FreeBeatsViewController.keyFilterStatus), name: FilterKeyStatusNotify, object: nil)
        //type
        NotificationCenter.default.addObserver(self, selector: #selector(FreeBeatsViewController.typeFilterStatus), name: FilterTypeStatusNotify, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(FreeBeatsViewController.typeFilterUpdate), name: FilterTypeChangedNotify, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(FreeBeatsViewController.typeFilterReset), name: FilterTypeResetNotify, object: nil)
        //type
        NotificationCenter.default.addObserver(self, selector: #selector(FreeBeatsViewController.soundsFilterStatus), name: FilterSoundsStatusNotify, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(FreeBeatsViewController.soundsFilterUpdate), name: FilterSoundsChangedNotify, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(FreeBeatsViewController.soundsFilterReset), name: FilterSoundsResetNotify, object: nil)
    }
    
    
    //MARK: - Tempo Updates
    @objc func tempoFilterMin(notification: NSNotification) {
        lastTempoChoiceChanged = 0
        print("Last tempo choiced used is slider: = \(lastTempoChoiceChanged)")
        let slidervalue = notification.object as! Int
        FilteringManager.shared.filterByTempoFree(slidervalue: slidervalue, thumb: 0, completion: {[weak self] filteredtempbeats in
            guard let strongSelf = self else {
                return
            }
            strongSelf.tempoSelectedArray = filteredtempbeats
            if numberOfActiveFilterCells == 1{
                strongSelf.filteredBeats = strongSelf.tempoSelectedArray
            } else if numberOfActiveFilterCells > 1 {
                strongSelf.filteredBeats = filteredtempbeats
                for beat in strongSelf.filteredBeats
                {
                    if !strongSelf.keySelectedArray.contains(beat)&&keyfliteringCode==1 || !strongSelf.typeSelectedArray.contains(beat)&&typefilteringCode==1 || !strongSelf.soundsSelectedArray.contains(beat)&&soundsfilteringCode==1 || !strongSelf.producerSelectedArray.contains(beat)&&producersfilteringCode==1
                    {
                       let index = strongSelf.filteredBeats.firstIndex{$0 === beat}
                       if index != nil {
                           strongSelf.filteredBeats.remove(at: index!)
                       }
                    }
                    
                }
            }
            strongSelf.reSortFilteredBeats()
            strongSelf.freeBeatTableView.reloadData()
        })
    }
    
    @objc func tempoFilterMax(notification: NSNotification) {
        lastTempoChoiceChanged = 0
        print("Last tempo choiced used is slider: = \(lastTempoChoiceChanged)")
        let slidervalue = (notification.object) as! Int
        FilteringManager.shared.filterByTempoFree(slidervalue: slidervalue, thumb: 1, completion: {[weak self] filteredtempbeats in
            guard let strongSelf = self else {
                return
            }
            strongSelf.tempoSelectedArray = filteredtempbeats
            if numberOfActiveFilterCells == 1{
                strongSelf.filteredBeats = strongSelf.tempoSelectedArray
            } else if numberOfActiveFilterCells > 1 {
                strongSelf.filteredBeats = filteredtempbeats
                for beat in strongSelf.filteredBeats
                {
                    if !strongSelf.keySelectedArray.contains(beat)&&keyfliteringCode==1 || !strongSelf.typeSelectedArray.contains(beat)&&typefilteringCode==1 || !strongSelf.soundsSelectedArray.contains(beat)&&soundsfilteringCode==1 || !strongSelf.producerSelectedArray.contains(beat)&&producersfilteringCode==1
                    {
                       let index = strongSelf.filteredBeats.firstIndex{$0 === beat}
                       if index != nil {
                           strongSelf.filteredBeats.remove(at: index!)
                       }
                    }
                    
                }
            }
            strongSelf.reSortFilteredBeats()
            strongSelf.freeBeatTableView.reloadData()
        })
    }
    
    @objc func tempoFilterSpecified(notification: NSNotification) {
        lastTempoChoiceChanged = 1
        print("Last tempo choiced used is exact: = \(lastTempoChoiceChanged)")
        let selectedTempo = (notification.object) as! Int
        FilteringManager.shared.filterByTempoFreeSpecified(tempo: selectedTempo, completion: {[weak self] filteredtempbeats in
            guard let strongSelf = self else {
                return
            }
            strongSelf.tempoSelectedArray = filteredtempbeats
            if numberOfActiveFilterCells == 1{
                strongSelf.filteredBeats = strongSelf.tempoSelectedArray
            } else if numberOfActiveFilterCells > 1 {
                strongSelf.filteredBeats = filteredtempbeats
                for beat in strongSelf.filteredBeats
                {
                    if !strongSelf.keySelectedArray.contains(beat)&&keyfliteringCode==1 || !strongSelf.typeSelectedArray.contains(beat)&&typefilteringCode==1 || !strongSelf.soundsSelectedArray.contains(beat)&&soundsfilteringCode==1 || !strongSelf.producerSelectedArray.contains(beat)&&producersfilteringCode==1
                    {
                       let index = strongSelf.filteredBeats.firstIndex{$0 === beat}
                       if index != nil {
                           strongSelf.filteredBeats.remove(at: index!)
                       }
                    }
                    
                }
            }
            strongSelf.reSortFilteredBeats()
            strongSelf.freeBeatTableView.reloadData()
        })
    }
    
    
    
    
    
    //MARK: - Key Updates
    
    
    @objc func keyFilterUpdate(notification: NSNotification) {
        let selectedkey = notification.object as! String
        FilteringManager.shared.filterByKeyFree(key: selectedkey, completion: {[weak self] filteredkeybeats in
            guard let strongSelf = self else {
                return
            }
            strongSelf.keySelectedArray = filteredkeybeats
            if numberOfActiveFilterCells == 1{
                strongSelf.filteredBeats = strongSelf.keySelectedArray
            }
            else if numberOfActiveFilterCells > 1 {
                strongSelf.filteredBeats = filteredkeybeats
                for beat in strongSelf.filteredBeats
                {
                    if !strongSelf.tempoSelectedArray.contains(beat)&&tempofilteringCode==1 || !strongSelf.typeSelectedArray.contains(beat)&&typefilteringCode==1 || !strongSelf.soundsSelectedArray.contains(beat)&&soundsfilteringCode==1 || !strongSelf.producerSelectedArray.contains(beat)&&producersfilteringCode==1
                    {
                       let index = strongSelf.filteredBeats.firstIndex{$0 === beat}
                       if index != nil {
                           strongSelf.filteredBeats.remove(at: index!)
                       }
                    }
                    
                }
            }
            strongSelf.reSortFilteredBeats()
            strongSelf.freeBeatTableView.reloadData()
        })
    }
    
    //MARK: - Type Updates
    
    @objc func typeFilterUpdate(notification: NSNotification) {
        var pickedCode = 1000
        var pickedArray:[BeatData] = []
        let selectedtype = notification.object as! String
        FilteringManager.shared.filterByTypeFree(type: selectedtype, completion: { [weak self] filteredtypebeats in
            guard let strongSelf = self else {
                return
            }
            switch selectedtype {
            case "Dark":
                strongSelf.darkTypeArray = filteredtypebeats
                pickedCode = darkTypeFilteringCode
            case "Melodic":
                strongSelf.melodicTypeArray = filteredtypebeats
                pickedCode = melodicTypeFilteringCode
            case "Aggressive":
                strongSelf.aggressiveTypeArray = filteredtypebeats
                pickedCode = aggressiveTypeFilteringCode
            case "Smooth":
                strongSelf.smoothTypeArray = filteredtypebeats
                pickedCode = smoothTypeFilteringCode
            case "R&B":
                strongSelf.rAndBTypeArray = filteredtypebeats
                pickedCode = rAndBTypeFilteringCode
            case "Vibey":
                strongSelf.vibeyTypeArray = filteredtypebeats
                pickedCode = vibeyTypeFilteringCode
            case "Club":
                strongSelf.clubTypeArray = filteredtypebeats
                pickedCode = clubTypeFilteringCode
            case "Joyful":
                strongSelf.joyfulTypeArray = filteredtypebeats
                pickedCode = joyfulTypeFilteringCode
            case "Soulful":
                strongSelf.soulfulTypeArray = filteredtypebeats
                pickedCode = soulfulTypeFilteringCode
            case "Experimental":
                strongSelf.experimentalTypeArray = filteredtypebeats
                pickedCode = experimentalTypeFilteringCode
            case "Relaxed":
                strongSelf.relaxedTypeArray = filteredtypebeats
                pickedCode = relaxedTypeFilteringCode
            case "Calm":
                strongSelf.calmTypeArray = filteredtypebeats
                pickedCode = calmTypeFilteringCode
            case "Epic":
                strongSelf.epicTypeArray = filteredtypebeats
                pickedCode = epicTypeFilteringCode
            case "Simple":
                strongSelf.simpleTypeArray = filteredtypebeats
                pickedCode = simpleTypeFilteringCode
            case "Trap":
                strongSelf.trapTypeArray = filteredtypebeats
                pickedCode = trapTypeFilteringCode
            default:
                print("Error finding array type to pace in subtype array.")
            }
            if numberOfActiveFilterCells == 0 {
                strongSelf.filteredBeats = strongSelf.initialBeats
            }
            if numberOfActiveFilterCells == 1 {
                if pickedCode == 1 {
                    if allTypeFilteringCode == 1 {
                        strongSelf.typeSelectedArray = filteredtypebeats
                    }
                    if allTypeFilteringCode > 1 {
                        for beattt in strongSelf.typeSelectedArray {
                            if darkTypeFilteringCode == 1 && !strongSelf.darkTypeArray.contains(beattt) || melodicTypeFilteringCode == 1 && !strongSelf.melodicTypeArray.contains(beattt) || aggressiveTypeFilteringCode == 1 && !strongSelf.aggressiveTypeArray.contains(beattt) || smoothTypeFilteringCode == 1 && !strongSelf.smoothTypeArray.contains(beattt) || rAndBTypeFilteringCode == 1 && !strongSelf.rAndBTypeArray.contains(beattt) || vibeyTypeFilteringCode == 1 && !strongSelf.vibeyTypeArray.contains(beattt) || clubTypeFilteringCode == 1 && !strongSelf.clubTypeArray.contains(beattt) || joyfulTypeFilteringCode == 1 && !strongSelf.joyfulTypeArray.contains(beattt) || soulfulTypeFilteringCode == 1 && !strongSelf.soulfulTypeArray.contains(beattt) || experimentalTypeFilteringCode == 1 && !strongSelf.experimentalTypeArray.contains(beattt) || relaxedTypeFilteringCode == 1 && !strongSelf.relaxedTypeArray.contains(beattt) || calmTypeFilteringCode == 1 && !strongSelf.calmTypeArray.contains(beattt) || epicTypeFilteringCode == 1 && !strongSelf.epicTypeArray.contains(beattt) || simpleTypeFilteringCode == 1 && !strongSelf.simpleTypeArray.contains(beattt) || trapTypeFilteringCode == 1 && !strongSelf.trapTypeArray.contains(beattt) {
                                let index = strongSelf.typeSelectedArray.firstIndex{$0 === beattt}
                                if index != nil {
                                    strongSelf.typeSelectedArray.remove(at: index!)
                                }
                            }
                        }
                    }
                    strongSelf.filteredBeats = strongSelf.typeSelectedArray
                } else if pickedCode == 0 {
                    if allTypeFilteringCode == 0 {
                        strongSelf.filteredBeats = []
                        if keyfliteringCode == 1 {
                            for beat in strongSelf.keySelectedArray {
                                if soundsfilteringCode==1&&strongSelf.soundsSelectedArray.contains(beat) || tempofilteringCode==1&&strongSelf.tempoSelectedArray.contains(beat) || producersfilteringCode==1&&strongSelf.producerSelectedArray.contains(beat) {
                                    if !strongSelf.filteredBeats.contains(beat) {
                                        strongSelf.filteredBeats.append(beat)
                                    }
                                } else if !strongSelf.filteredBeats.contains(beat) {
                                    strongSelf.filteredBeats.append(beat)
                                }
                            }
                        }
                        if soundsfilteringCode == 1 {
                            for beat in strongSelf.soundsSelectedArray {
                                if keyfliteringCode==1&&strongSelf.keySelectedArray.contains(beat) || tempofilteringCode==1&&strongSelf.tempoSelectedArray.contains(beat) || producersfilteringCode==1&&strongSelf.producerSelectedArray.contains(beat) {
                                    if !strongSelf.filteredBeats.contains(beat) {
                                        strongSelf.filteredBeats.append(beat)
                                    }
                                } else if !strongSelf.filteredBeats.contains(beat) {
                                    strongSelf.filteredBeats.append(beat)
                                }
                            }
                        }
                        if tempofilteringCode == 1 {
                            for beat in strongSelf.tempoSelectedArray {
                                if soundsfilteringCode==1&&strongSelf.soundsSelectedArray.contains(beat) || keyfliteringCode==1&&strongSelf.keySelectedArray.contains(beat) || producersfilteringCode==1&&strongSelf.producerSelectedArray.contains(beat) {
                                    if !strongSelf.filteredBeats.contains(beat) {
                                        strongSelf.filteredBeats.append(beat)
                                    }
                                } else if !strongSelf.filteredBeats.contains(beat) {
                                    strongSelf.filteredBeats.append(beat)
                                }
                            }
                        }
                        if producersfilteringCode == 1 {
                            for beat in strongSelf.producerSelectedArray {
                                if soundsfilteringCode==1&&strongSelf.soundsSelectedArray.contains(beat) || tempofilteringCode==1&&strongSelf.tempoSelectedArray.contains(beat) || keyfliteringCode==1&&strongSelf.keySelectedArray.contains(beat) {
                                    if !strongSelf.filteredBeats.contains(beat) {
                                        strongSelf.filteredBeats.append(beat)
                                    }
                                } else if !strongSelf.filteredBeats.contains(beat) {
                                    strongSelf.filteredBeats.append(beat)
                                }
                            }
                        }
                    } else if allTypeFilteringCode > 0{
                        strongSelf.typeSelectedArray = []
                        if darkTypeFilteringCode == 1 {
                            pickedArray = strongSelf.darkTypeArray
                        } else if melodicTypeFilteringCode == 1 {
                            pickedArray = strongSelf.melodicTypeArray
                        } else if aggressiveTypeFilteringCode == 1 {
                            pickedArray = strongSelf.aggressiveTypeArray
                        } else if smoothTypeFilteringCode == 1 {
                            pickedArray = strongSelf.smoothTypeArray
                        } else if rAndBTypeFilteringCode == 1 {
                            pickedArray = strongSelf.rAndBTypeArray
                        } else if vibeyTypeFilteringCode == 1 {
                            pickedArray = strongSelf.vibeyTypeArray
                        } else if clubTypeFilteringCode == 1 {
                            pickedArray = strongSelf.clubTypeArray
                        } else if joyfulTypeFilteringCode == 1 {
                            pickedArray = strongSelf.joyfulTypeArray
                        } else if soulfulTypeFilteringCode == 1 {
                            pickedArray = strongSelf.soulfulTypeArray
                        } else if experimentalTypeFilteringCode == 1 {
                            pickedArray = strongSelf.experimentalTypeArray
                        } else if relaxedTypeFilteringCode == 1 {
                            pickedArray = strongSelf.relaxedTypeArray
                        } else if calmTypeFilteringCode == 1 {
                            pickedArray = strongSelf.calmTypeArray
                        } else if epicTypeFilteringCode == 1 {
                            pickedArray = strongSelf.epicTypeArray
                        } else if simpleTypeFilteringCode == 1 {
                            pickedArray = strongSelf.simpleTypeArray
                        } else if trapTypeFilteringCode == 1 {
                            pickedArray = strongSelf.trapTypeArray
                        }
                        strongSelf.typeSelectedArray.append(contentsOf: pickedArray)
                        if allTypeFilteringCode == 1 {
                            strongSelf.filteredBeats = strongSelf.typeSelectedArray
                        }
                        if allTypeFilteringCode > 1 {
                            for beattt in strongSelf.typeSelectedArray {
                                if darkTypeFilteringCode == 1 && !strongSelf.darkTypeArray.contains(beattt) || melodicTypeFilteringCode == 1 && !strongSelf.melodicTypeArray.contains(beattt) || aggressiveTypeFilteringCode == 1 && !strongSelf.aggressiveTypeArray.contains(beattt) || smoothTypeFilteringCode == 1 && !strongSelf.smoothTypeArray.contains(beattt) || rAndBTypeFilteringCode == 1 && !strongSelf.rAndBTypeArray.contains(beattt) || vibeyTypeFilteringCode == 1 && !strongSelf.vibeyTypeArray.contains(beattt) || clubTypeFilteringCode == 1 && !strongSelf.clubTypeArray.contains(beattt) || joyfulTypeFilteringCode == 1 && !strongSelf.joyfulTypeArray.contains(beattt) || soulfulTypeFilteringCode == 1 && !strongSelf.soulfulTypeArray.contains(beattt) || experimentalTypeFilteringCode == 1 && !strongSelf.experimentalTypeArray.contains(beattt) || relaxedTypeFilteringCode == 1 && !strongSelf.relaxedTypeArray.contains(beattt) || calmTypeFilteringCode == 1 && !strongSelf.calmTypeArray.contains(beattt) || epicTypeFilteringCode == 1 && !strongSelf.epicTypeArray.contains(beattt) || simpleTypeFilteringCode == 1 && !strongSelf.simpleTypeArray.contains(beattt) || trapTypeFilteringCode == 1 && !strongSelf.trapTypeArray.contains(beattt) {
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
            if numberOfActiveFilterCells > 1 {
                if pickedCode == 1 {
                    if allTypeFilteringCode == 1 {
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
                    if allTypeFilteringCode > 1 {
                        for beattt in strongSelf.typeSelectedArray {
                            if darkTypeFilteringCode == 1 && !strongSelf.darkTypeArray.contains(beattt) || melodicTypeFilteringCode == 1 && !strongSelf.melodicTypeArray.contains(beattt) || aggressiveTypeFilteringCode == 1 && !strongSelf.aggressiveTypeArray.contains(beattt) || smoothTypeFilteringCode == 1 && !strongSelf.smoothTypeArray.contains(beattt) || rAndBTypeFilteringCode == 1 && !strongSelf.rAndBTypeArray.contains(beattt) || vibeyTypeFilteringCode == 1 && !strongSelf.vibeyTypeArray.contains(beattt) || clubTypeFilteringCode == 1 && !strongSelf.clubTypeArray.contains(beattt) || joyfulTypeFilteringCode == 1 && !strongSelf.joyfulTypeArray.contains(beattt) || soulfulTypeFilteringCode == 1 && !strongSelf.soulfulTypeArray.contains(beattt) || experimentalTypeFilteringCode == 1 && !strongSelf.experimentalTypeArray.contains(beattt) || relaxedTypeFilteringCode == 1 && !strongSelf.relaxedTypeArray.contains(beattt) || calmTypeFilteringCode == 1 && !strongSelf.calmTypeArray.contains(beattt) || epicTypeFilteringCode == 1 && !strongSelf.epicTypeArray.contains(beattt) || simpleTypeFilteringCode == 1 && !strongSelf.simpleTypeArray.contains(beattt) || trapTypeFilteringCode == 1 && !strongSelf.trapTypeArray.contains(beattt) {
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
                    if allTypeFilteringCode == 0 {
                        strongSelf.filteredBeats = []
                        if keyfliteringCode == 1 {
                            for beat in strongSelf.keySelectedArray {
                                if soundsfilteringCode==1&&strongSelf.soundsSelectedArray.contains(beat) || tempofilteringCode==1&&strongSelf.tempoSelectedArray.contains(beat) || producersfilteringCode==1&&strongSelf.producerSelectedArray.contains(beat) {
                                    if !strongSelf.filteredBeats.contains(beat) {
                                        strongSelf.filteredBeats.append(beat)
                                    }
                                } else if !strongSelf.filteredBeats.contains(beat) {
                                    strongSelf.filteredBeats.append(beat)
                                }
                            }
                        }
                        if soundsfilteringCode == 1 {
                            for beat in strongSelf.soundsSelectedArray {
                                if keyfliteringCode==1&&strongSelf.keySelectedArray.contains(beat) || tempofilteringCode==1&&strongSelf.tempoSelectedArray.contains(beat) || producersfilteringCode==1&&strongSelf.producerSelectedArray.contains(beat) {
                                    if !strongSelf.filteredBeats.contains(beat) {
                                        strongSelf.filteredBeats.append(beat)
                                    }
                                } else if !strongSelf.filteredBeats.contains(beat) {
                                    strongSelf.filteredBeats.append(beat)
                                }
                            }
                        }
                        if tempofilteringCode == 1 {
                            for beat in strongSelf.tempoSelectedArray {
                                if soundsfilteringCode==1&&strongSelf.soundsSelectedArray.contains(beat) || keyfliteringCode==1&&strongSelf.keySelectedArray.contains(beat) || producersfilteringCode==1&&strongSelf.producerSelectedArray.contains(beat) {
                                    if !strongSelf.filteredBeats.contains(beat) {
                                        strongSelf.filteredBeats.append(beat)
                                    }
                                } else if !strongSelf.filteredBeats.contains(beat) {
                                    strongSelf.filteredBeats.append(beat)
                                }
                            }
                        }
                        if producersfilteringCode == 1 {
                            for beat in strongSelf.producerSelectedArray {
                                if soundsfilteringCode==1&&strongSelf.soundsSelectedArray.contains(beat) || tempofilteringCode==1&&strongSelf.tempoSelectedArray.contains(beat) || keyfliteringCode==1&&strongSelf.keySelectedArray.contains(beat) {
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
                            if !strongSelf.keySelectedArray.contains(beat) && keyfliteringCode == 1 || !strongSelf.soundsSelectedArray.contains(beat) && soundsfilteringCode == 1 || !strongSelf.tempoSelectedArray.contains(beat) && tempofilteringCode == 1 || !strongSelf.producerSelectedArray.contains(beat) && producersfilteringCode == 1 {
                                let index = strongSelf.filteredBeats.firstIndex{$0 === beat}
                                if index != nil {
                                    strongSelf.filteredBeats.remove(at: index!)
                                }
                            }
                        }
                    } else if allTypeFilteringCode > 0{
                        strongSelf.typeSelectedArray = []
                        if darkTypeFilteringCode == 1 {
                            pickedArray = strongSelf.darkTypeArray
                        } else if melodicTypeFilteringCode == 1 {
                            pickedArray = strongSelf.melodicTypeArray
                        } else if aggressiveTypeFilteringCode == 1 {
                            pickedArray = strongSelf.aggressiveTypeArray
                        } else if smoothTypeFilteringCode == 1 {
                            pickedArray = strongSelf.smoothTypeArray
                        } else if rAndBTypeFilteringCode == 1 {
                            pickedArray = strongSelf.rAndBTypeArray
                        } else if vibeyTypeFilteringCode == 1 {
                            pickedArray = strongSelf.vibeyTypeArray
                        } else if clubTypeFilteringCode == 1 {
                            pickedArray = strongSelf.clubTypeArray
                        } else if joyfulTypeFilteringCode == 1 {
                            pickedArray = strongSelf.joyfulTypeArray
                        } else if soulfulTypeFilteringCode == 1 {
                            pickedArray = strongSelf.soulfulTypeArray
                        } else if experimentalTypeFilteringCode == 1 {
                            pickedArray = strongSelf.experimentalTypeArray
                        } else if relaxedTypeFilteringCode == 1 {
                            pickedArray = strongSelf.relaxedTypeArray
                        } else if calmTypeFilteringCode == 1 {
                            pickedArray = strongSelf.calmTypeArray
                        } else if epicTypeFilteringCode == 1 {
                            pickedArray = strongSelf.epicTypeArray
                        } else if simpleTypeFilteringCode == 1 {
                            pickedArray = strongSelf.simpleTypeArray
                        } else if trapTypeFilteringCode == 1 {
                            pickedArray = strongSelf.trapTypeArray
                        }
                        strongSelf.typeSelectedArray.append(contentsOf: pickedArray)
                        for beattt in strongSelf.typeSelectedArray {
                            if darkTypeFilteringCode == 1 && !strongSelf.darkTypeArray.contains(beattt) || melodicTypeFilteringCode == 1 && !strongSelf.melodicTypeArray.contains(beattt) || aggressiveTypeFilteringCode == 1 && !strongSelf.aggressiveTypeArray.contains(beattt) || smoothTypeFilteringCode == 1 && !strongSelf.smoothTypeArray.contains(beattt) || rAndBTypeFilteringCode == 1 && !strongSelf.rAndBTypeArray.contains(beattt) || vibeyTypeFilteringCode == 1 && !strongSelf.vibeyTypeArray.contains(beattt) || clubTypeFilteringCode == 1 && !strongSelf.clubTypeArray.contains(beattt) || joyfulTypeFilteringCode == 1 && !strongSelf.joyfulTypeArray.contains(beattt) || soulfulTypeFilteringCode == 1 && !strongSelf.soulfulTypeArray.contains(beattt) || experimentalTypeFilteringCode == 1 && !strongSelf.experimentalTypeArray.contains(beattt) || relaxedTypeFilteringCode == 1 && !strongSelf.relaxedTypeArray.contains(beattt) || calmTypeFilteringCode == 1 && !strongSelf.calmTypeArray.contains(beattt) || epicTypeFilteringCode == 1 && !strongSelf.epicTypeArray.contains(beattt) || simpleTypeFilteringCode == 1 && !strongSelf.simpleTypeArray.contains(beattt) || trapTypeFilteringCode == 1 && !strongSelf.trapTypeArray.contains(beattt) {
                                let index = strongSelf.typeSelectedArray.firstIndex{$0 === beattt}
                                if index != nil {
                                    strongSelf.typeSelectedArray.remove(at: index!)
                                }
                            }
                        }
                        strongSelf.filteredBeats = []
                        strongSelf.filteredBeats.append(contentsOf: strongSelf.typeSelectedArray)
                        for beat in strongSelf.filteredBeats {
                            if soundsfilteringCode==1 && !strongSelf.soundsSelectedArray.contains(beat) || tempofilteringCode==1 && !strongSelf.tempoSelectedArray.contains(beat) || producersfilteringCode==1 && !strongSelf.producerSelectedArray.contains(beat) || keyfliteringCode==1 && !strongSelf.keySelectedArray.contains(beat) {
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
            strongSelf.freeBeatTableView.reloadData()
        })
    }
    
    //MARK: - Sounds Updates
    
    @objc func soundsFilterUpdate(notification: NSNotification) {
        var spickedCode = 1000
        var spickedArray:[BeatData] = []
        let selectedsound = notification.object as! String
        FilteringManager.shared.filterBySoundsFree(sound: selectedsound, completion: {[weak self] filteredsoundbeats in
            guard let strongSelf = self else {
                return
            }
            switch selectedsound {
            case "Keys":
                strongSelf.keysSoundArray = filteredsoundbeats
                spickedCode = keysSoundFilteringCode
            case "Piano Acoustic":
                strongSelf.pianoAcousticSoundArray = filteredsoundbeats
                spickedCode = pianoAcousticSoundFilteringCode
            case "Piano Vinyl":
                strongSelf.pianoVinylSoundArray = filteredsoundbeats
                spickedCode = pianoVinylSoundFilteringCode
            case "Piano Electric":
                strongSelf.pianoElectricSoundArray = filteredsoundbeats
                spickedCode = pianoElectricSoundFilteringCode
            case "Piano Rhodes":
                strongSelf.pianoRhodesSoundArray = filteredsoundbeats
                spickedCode = pianoRhodesSoundFilteringCode
            case "Organ":
                strongSelf.organSoundArray = filteredsoundbeats
                spickedCode = organSoundFilteringCode
            case "Theramin":
                strongSelf.theraminSoundArray = filteredsoundbeats
                spickedCode = theraminSoundFilteringCode
            case "Whistle":
                strongSelf.whistleSoundArray = filteredsoundbeats
                spickedCode = whistleSoundFilteringCode
            case "Horns":
                strongSelf.hornsSoundArray = filteredsoundbeats
                spickedCode = hornsSoundFilteringCode
            case "Strings":
                strongSelf.stringsSoundArray = filteredsoundbeats
                spickedCode = stringsSoundFilteringCode
            case "Flute":
                strongSelf.fluteSoundArray = filteredsoundbeats
                spickedCode = fluteSoundFilteringCode
            case "Pad Bell":
                strongSelf.padBellSoundArray = filteredsoundbeats
                spickedCode = padBellSoundFilteringCode
            case "Pad Hollow":
                strongSelf.padHollowSoundArray = filteredsoundbeats
                spickedCode = padHollowSoundFilteringCode
            case "Pad Aggressive":
                strongSelf.padAggressiveSoundArray = filteredsoundbeats
                spickedCode = padAggressiveSoundFilteringCode
            case "Choir":
                strongSelf.choirSoundArray = filteredsoundbeats
                spickedCode = choirSoundFilteringCode
            case "Saxophone":
                strongSelf.saxophoneSoundArray = filteredsoundbeats
                spickedCode = saxophoneSoundFilteringCode
            case "Guitar Electric":
                strongSelf.guitarElectricSoundArray = filteredsoundbeats
                spickedCode = guitarElectricSoundFilteringCode
            case "Guitar Acoustic":
                strongSelf.guitarAcousticSoundArray = filteredsoundbeats
                spickedCode = guitarAcousticSoundFilteringCode
            case "Guitar Steel":
                strongSelf.guitarSteelSoundArray = filteredsoundbeats
                spickedCode = guitarSteelSoundFilteringCode
            case "Bells EDM":
                strongSelf.bellsEDMSoundArray = filteredsoundbeats
                spickedCode = bellsEDMSoundFilteringCode
            case "Bells Vinyl":
                strongSelf.bellsVinylSoundArray = filteredsoundbeats
                spickedCode = bellsVinylSoundFilteringCode
            case "Bells Gothic":
                strongSelf.bellsGothicSoundArray = filteredsoundbeats
                spickedCode = bellsGothicSoundFilteringCode
            case "Bells Hollow":
                strongSelf.bellsHollowSoundArray = filteredsoundbeats
                spickedCode = bellsHollowSoundFilteringCode
            case "Bells Music Box":
                strongSelf.bellsMusicBoxSoundArray = filteredsoundbeats
                spickedCode = bellsMusicBoxSoundFilteringCode
            case "Sample Vocal":
                strongSelf.sampleVocalSoundArray = filteredsoundbeats
                spickedCode = sampleVocalSoundFilteringCode
            case "Sample Song":
                strongSelf.sampleSongSoundArray = filteredsoundbeats
                spickedCode = sampleSongSoundFilteringCode
            case "No Kick":
                strongSelf.noKickSoundArray = filteredsoundbeats
                spickedCode = noKickSoundFilteringCode
            case "Kick":
                strongSelf.kickSoundArray = filteredsoundbeats
                spickedCode = kickSoundFilteringCode
            case "808 Long":
                strongSelf.long808SoundArray = filteredsoundbeats
                spickedCode = long808SoundFilteringCode
            case "808 Short":
                strongSelf.short808SoundArray = filteredsoundbeats
                spickedCode = short808SoundFilteringCode
            case "808 Clean":
                strongSelf.clean808SoundArray = filteredsoundbeats
                spickedCode = clean808SoundFilteringCode
            case "808 Distorted":
                strongSelf.distorted808SoundArray = filteredsoundbeats
                spickedCode = distorted808SoundFilteringCode
            case "Moog Bass":
                strongSelf.moogBassSoundArray = filteredsoundbeats
                spickedCode = moogBassSoundFilteringCode
            case "Sub Bass":
                strongSelf.subBassSoundArray = filteredsoundbeats
                spickedCode = subBassSoundFilteringCode
            case "Synth Bass Distorted":
                strongSelf.synthBassDistortedSoundArray = filteredsoundbeats
                spickedCode = synthBassDistortedSoundFilteringCode
            case "Snap":
                strongSelf.snapSoundArray = filteredsoundbeats
                spickedCode = snapSoundFilteringCode
            case "Synth Bass Deep":
                strongSelf.synthBassDeepSoundArray = filteredsoundbeats
                spickedCode = synthBassDeepSoundFilteringCode
            default:
                print("Error finding array sound to pace in sound array.")
            }
            
            if numberOfActiveFilterCells == 0 {
                strongSelf.filteredBeats = strongSelf.initialBeats
            }
            if numberOfActiveFilterCells == 1 {
                if spickedCode == 1 {
                    if allSoundsFilteringCode == 1 {
                        strongSelf.soundsSelectedArray = filteredsoundbeats
                    }
                    if allSoundsFilteringCode > 1 {
                        for beattt in strongSelf.soundsSelectedArray {
                            if keysSoundFilteringCode == 1 && !strongSelf.keysSoundArray.contains(beattt) || pianoAcousticSoundFilteringCode == 1 && !strongSelf.pianoAcousticSoundArray.contains(beattt) || pianoElectricSoundFilteringCode == 1 && !strongSelf.pianoElectricSoundArray.contains(beattt) || pianoRhodesSoundFilteringCode == 1 && !strongSelf.pianoRhodesSoundArray.contains(beattt) || pianoVinylSoundFilteringCode == 1 && !strongSelf.pianoVinylSoundArray.contains(beattt) || organSoundFilteringCode == 1 && !strongSelf.organSoundArray.contains(beattt) || theraminSoundFilteringCode == 1 && !strongSelf.theraminSoundArray.contains(beattt) || whistleSoundFilteringCode == 1 && !strongSelf.whistleSoundArray.contains(beattt) || hornsSoundFilteringCode == 1 && !strongSelf.hornsSoundArray.contains(beattt) || stringsSoundFilteringCode == 1 && !strongSelf.stringsSoundArray.contains(beattt) || fluteSoundFilteringCode == 1 && !strongSelf.fluteSoundArray.contains(beattt) || padBellSoundFilteringCode == 1 && !strongSelf.padBellSoundArray.contains(beattt) || padHollowSoundFilteringCode == 1 && !strongSelf.padHollowSoundArray.contains(beattt) || padAggressiveSoundFilteringCode == 1 && !strongSelf.padAggressiveSoundArray.contains(beattt) || choirSoundFilteringCode == 1 && !strongSelf.choirSoundArray.contains(beattt) || saxophoneSoundFilteringCode == 1 && !strongSelf.saxophoneSoundArray.contains(beattt) || guitarElectricSoundFilteringCode == 1 && !strongSelf.guitarElectricSoundArray.contains(beattt) || guitarAcousticSoundFilteringCode == 1 && !strongSelf.guitarAcousticSoundArray.contains(beattt) || guitarSteelSoundFilteringCode == 1 && !strongSelf.guitarSteelSoundArray.contains(beattt) || bellsEDMSoundFilteringCode == 1 && !strongSelf.bellsEDMSoundArray.contains(beattt) || bellsVinylSoundFilteringCode == 1 && !strongSelf.bellsVinylSoundArray.contains(beattt) || bellsGothicSoundFilteringCode == 1 && !strongSelf.bellsGothicSoundArray.contains(beattt) || bellsHollowSoundFilteringCode == 1 && !strongSelf.bellsHollowSoundArray.contains(beattt) || bellsMusicBoxSoundFilteringCode == 1 && !strongSelf.bellsMusicBoxSoundArray.contains(beattt) || sampleVocalSoundFilteringCode == 1 && !strongSelf.sampleVocalSoundArray.contains(beattt) || sampleSongSoundFilteringCode == 1 && !strongSelf.sampleSongSoundArray.contains(beattt) || noKickSoundFilteringCode == 1 && !strongSelf.noKickSoundArray.contains(beattt) || kickSoundFilteringCode == 1 && !strongSelf.kickSoundArray.contains(beattt) || long808SoundFilteringCode == 1 && !strongSelf.long808SoundArray.contains(beattt) || short808SoundFilteringCode == 1 && !strongSelf.short808SoundArray.contains(beattt) || clean808SoundFilteringCode == 1 && !strongSelf.clean808SoundArray.contains(beattt) || distorted808SoundFilteringCode == 1 && !strongSelf.distorted808SoundArray.contains(beattt) || moogBassSoundFilteringCode == 1 && !strongSelf.moogBassSoundArray.contains(beattt) || subBassSoundFilteringCode == 1 && !strongSelf.subBassSoundArray.contains(beattt) || synthBassDistortedSoundFilteringCode == 1 && !strongSelf.synthBassDistortedSoundArray.contains(beattt) || synthBassDeepSoundFilteringCode == 1 && !strongSelf.synthBassDeepSoundArray.contains(beattt) || snapSoundFilteringCode == 1 && !strongSelf.snapSoundArray.contains(beattt)
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
                    if allSoundsFilteringCode == 0 {
                        strongSelf.filteredBeats = []
                        if keyfliteringCode == 1 {
                            for beat in strongSelf.keySelectedArray {
                                if typefilteringCode==1&&strongSelf.typeSelectedArray.contains(beat) || tempofilteringCode==1&&strongSelf.tempoSelectedArray.contains(beat) || producersfilteringCode==1&&strongSelf.producerSelectedArray.contains(beat) {
                                    if !strongSelf.filteredBeats.contains(beat) {
                                        strongSelf.filteredBeats.append(beat)
                                    }
                                } else if !strongSelf.filteredBeats.contains(beat) {
                                    strongSelf.filteredBeats.append(beat)
                                }
                            }
                        }
                        if typefilteringCode == 1 {
                            for beat in strongSelf.typeSelectedArray {
                                if keyfliteringCode==1&&strongSelf.keySelectedArray.contains(beat) || tempofilteringCode==1&&strongSelf.tempoSelectedArray.contains(beat) || producersfilteringCode==1&&strongSelf.producerSelectedArray.contains(beat) {
                                    if !strongSelf.filteredBeats.contains(beat) {
                                        strongSelf.filteredBeats.append(beat)
                                    }
                                } else if !strongSelf.filteredBeats.contains(beat) {
                                    strongSelf.filteredBeats.append(beat)
                                }
                            }
                        }
                        if tempofilteringCode == 1 {
                            for beat in strongSelf.tempoSelectedArray {
                                if typefilteringCode==1&&strongSelf.typeSelectedArray.contains(beat) || keyfliteringCode==1&&strongSelf.keySelectedArray.contains(beat) || producersfilteringCode==1&&strongSelf.producerSelectedArray.contains(beat) {
                                    if !strongSelf.filteredBeats.contains(beat) {
                                        strongSelf.filteredBeats.append(beat)
                                    }
                                } else if !strongSelf.filteredBeats.contains(beat) {
                                    strongSelf.filteredBeats.append(beat)
                                }
                            }
                        }
                        if producersfilteringCode == 1 {
                            for beat in strongSelf.producerSelectedArray {
                                if typefilteringCode==1&&strongSelf.typeSelectedArray.contains(beat) || tempofilteringCode==1&&strongSelf.tempoSelectedArray.contains(beat) || keyfliteringCode==1&&strongSelf.keySelectedArray.contains(beat) {
                                    if !strongSelf.filteredBeats.contains(beat) {
                                        strongSelf.filteredBeats.append(beat)
                                    }
                                } else if !strongSelf.filteredBeats.contains(beat) {
                                    strongSelf.filteredBeats.append(beat)
                                }
                            }
                        }
                    } else if allSoundsFilteringCode > 0{
                        strongSelf.soundsSelectedArray = []
                        if keysSoundFilteringCode == 1 {
                            spickedArray = strongSelf.keysSoundArray
                        } else if pianoAcousticSoundFilteringCode == 1 {
                            spickedArray = strongSelf.pianoAcousticSoundArray
                        } else if pianoVinylSoundFilteringCode == 1 {
                            spickedArray = strongSelf.pianoVinylSoundArray
                        } else if pianoElectricSoundFilteringCode == 1 {
                            spickedArray = strongSelf.pianoElectricSoundArray
                        } else if pianoRhodesSoundFilteringCode == 1 {
                            spickedArray = strongSelf.pianoRhodesSoundArray
                        } else if organSoundFilteringCode == 1 {
                            spickedArray = strongSelf.organSoundArray
                        } else if theraminSoundFilteringCode == 1 {
                            spickedArray = strongSelf.theraminSoundArray
                        } else if whistleSoundFilteringCode == 1 {
                            spickedArray = strongSelf.whistleSoundArray
                        } else if hornsSoundFilteringCode == 1 {
                            spickedArray = strongSelf.hornsSoundArray
                        } else if stringsSoundFilteringCode == 1 {
                            spickedArray = strongSelf.stringsSoundArray
                        } else if fluteSoundFilteringCode == 1 {
                            spickedArray = strongSelf.fluteSoundArray
                        } else if padBellSoundFilteringCode == 1 {
                            spickedArray = strongSelf.padBellSoundArray
                        } else if padHollowSoundFilteringCode == 1 {
                            spickedArray = strongSelf.padHollowSoundArray
                        } else if padAggressiveSoundFilteringCode == 1 {
                            spickedArray = strongSelf.padAggressiveSoundArray
                        } else if choirSoundFilteringCode == 1 {
                            spickedArray = strongSelf.choirSoundArray
                        } else if saxophoneSoundFilteringCode == 1 {
                            spickedArray = strongSelf.saxophoneSoundArray
                        } else if guitarElectricSoundFilteringCode == 1 {
                            spickedArray = strongSelf.guitarElectricSoundArray
                        } else if guitarAcousticSoundFilteringCode == 1 {
                            spickedArray = strongSelf.guitarAcousticSoundArray
                        } else if guitarSteelSoundFilteringCode == 1 {
                            spickedArray = strongSelf.guitarSteelSoundArray
                        } else if bellsEDMSoundFilteringCode == 1 {
                            spickedArray = strongSelf.bellsEDMSoundArray
                        } else if bellsVinylSoundFilteringCode == 1 {
                            spickedArray = strongSelf.bellsVinylSoundArray
                        } else if bellsGothicSoundFilteringCode == 1 {
                            spickedArray = strongSelf.bellsGothicSoundArray
                        } else if bellsHollowSoundFilteringCode == 1 {
                            spickedArray = strongSelf.bellsHollowSoundArray
                        } else if bellsMusicBoxSoundFilteringCode == 1 {
                            spickedArray = strongSelf.bellsMusicBoxSoundArray
                        } else if sampleVocalSoundFilteringCode == 1 {
                            spickedArray = strongSelf.sampleVocalSoundArray
                        } else if sampleSongSoundFilteringCode == 1 {
                            spickedArray = strongSelf.sampleSongSoundArray
                        } else if noKickSoundFilteringCode == 1 {
                            spickedArray = strongSelf.noKickSoundArray
                        } else if kickSoundFilteringCode == 1 {
                            spickedArray = strongSelf.kickSoundArray
                        } else if long808SoundFilteringCode == 1 {
                            spickedArray = strongSelf.long808SoundArray
                        } else if short808SoundFilteringCode == 1 {
                            spickedArray = strongSelf.short808SoundArray
                        } else if clean808SoundFilteringCode == 1 {
                            spickedArray = strongSelf.clean808SoundArray
                        } else if distorted808SoundFilteringCode == 1 {
                            spickedArray = strongSelf.distorted808SoundArray
                        } else if moogBassSoundFilteringCode == 1 {
                            spickedArray = strongSelf.moogBassSoundArray
                        } else if subBassSoundFilteringCode == 1 {
                            spickedArray = strongSelf.subBassSoundArray
                        } else if synthBassDistortedSoundFilteringCode == 1 {
                            spickedArray = strongSelf.synthBassDistortedSoundArray
                        } else if synthBassDeepSoundFilteringCode == 1 {
                            spickedArray = strongSelf.synthBassDeepSoundArray
                        } else if snapSoundFilteringCode == 1 {
                            spickedArray = strongSelf.snapSoundArray
                        }
                        strongSelf.soundsSelectedArray.append(contentsOf: spickedArray)
                        if allSoundsFilteringCode == 1 {
                            strongSelf.filteredBeats = strongSelf.soundsSelectedArray
                        }
                        if allSoundsFilteringCode > 1 {
                            for beattt in strongSelf.soundsSelectedArray {
                                if keysSoundFilteringCode == 1 && !strongSelf.keysSoundArray.contains(beattt) || pianoAcousticSoundFilteringCode == 1 && !strongSelf.pianoAcousticSoundArray.contains(beattt) || pianoElectricSoundFilteringCode == 1 && !strongSelf.pianoElectricSoundArray.contains(beattt) || pianoRhodesSoundFilteringCode == 1 && !strongSelf.pianoRhodesSoundArray.contains(beattt) || pianoVinylSoundFilteringCode == 1 && !strongSelf.pianoVinylSoundArray.contains(beattt) || organSoundFilteringCode == 1 && !strongSelf.organSoundArray.contains(beattt) || theraminSoundFilteringCode == 1 && !strongSelf.theraminSoundArray.contains(beattt) || whistleSoundFilteringCode == 1 && !strongSelf.whistleSoundArray.contains(beattt) || hornsSoundFilteringCode == 1 && !strongSelf.hornsSoundArray.contains(beattt) || stringsSoundFilteringCode == 1 && !strongSelf.stringsSoundArray.contains(beattt) || fluteSoundFilteringCode == 1 && !strongSelf.fluteSoundArray.contains(beattt) || padBellSoundFilteringCode == 1 && !strongSelf.padBellSoundArray.contains(beattt) || padHollowSoundFilteringCode == 1 && !strongSelf.padHollowSoundArray.contains(beattt) || padAggressiveSoundFilteringCode == 1 && !strongSelf.padAggressiveSoundArray.contains(beattt) || choirSoundFilteringCode == 1 && !strongSelf.choirSoundArray.contains(beattt) || saxophoneSoundFilteringCode == 1 && !strongSelf.saxophoneSoundArray.contains(beattt) || guitarElectricSoundFilteringCode == 1 && !strongSelf.guitarElectricSoundArray.contains(beattt) || guitarAcousticSoundFilteringCode == 1 && !strongSelf.guitarAcousticSoundArray.contains(beattt) || guitarSteelSoundFilteringCode == 1 && !strongSelf.guitarSteelSoundArray.contains(beattt) || bellsEDMSoundFilteringCode == 1 && !strongSelf.bellsEDMSoundArray.contains(beattt) || bellsVinylSoundFilteringCode == 1 && !strongSelf.bellsVinylSoundArray.contains(beattt) || bellsGothicSoundFilteringCode == 1 && !strongSelf.bellsGothicSoundArray.contains(beattt) || bellsHollowSoundFilteringCode == 1 && !strongSelf.bellsHollowSoundArray.contains(beattt) || bellsMusicBoxSoundFilteringCode == 1 && !strongSelf.bellsMusicBoxSoundArray.contains(beattt) || sampleVocalSoundFilteringCode == 1 && !strongSelf.sampleVocalSoundArray.contains(beattt) || sampleSongSoundFilteringCode == 1 && !strongSelf.sampleSongSoundArray.contains(beattt) || noKickSoundFilteringCode == 1 && !strongSelf.noKickSoundArray.contains(beattt) || kickSoundFilteringCode == 1 && !strongSelf.kickSoundArray.contains(beattt) || long808SoundFilteringCode == 1 && !strongSelf.long808SoundArray.contains(beattt) || short808SoundFilteringCode == 1 && !strongSelf.short808SoundArray.contains(beattt) || clean808SoundFilteringCode == 1 && !strongSelf.clean808SoundArray.contains(beattt) || distorted808SoundFilteringCode == 1 && !strongSelf.distorted808SoundArray.contains(beattt) || moogBassSoundFilteringCode == 1 && !strongSelf.moogBassSoundArray.contains(beattt) || subBassSoundFilteringCode == 1 && !strongSelf.subBassSoundArray.contains(beattt) || synthBassDistortedSoundFilteringCode == 1 && !strongSelf.synthBassDistortedSoundArray.contains(beattt) || synthBassDeepSoundFilteringCode == 1 && !strongSelf.synthBassDeepSoundArray.contains(beattt) || snapSoundFilteringCode == 1 && !strongSelf.snapSoundArray.contains(beattt)
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
            if numberOfActiveFilterCells > 1 {
                if spickedCode == 1 {
                    if allSoundsFilteringCode == 1 {
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
                    if allSoundsFilteringCode > 1 {
                        for beattt in strongSelf.soundsSelectedArray {
                            if keysSoundFilteringCode == 1 && !strongSelf.keysSoundArray.contains(beattt) || pianoAcousticSoundFilteringCode == 1 && !strongSelf.pianoAcousticSoundArray.contains(beattt) || pianoElectricSoundFilteringCode == 1 && !strongSelf.pianoElectricSoundArray.contains(beattt) || pianoRhodesSoundFilteringCode == 1 && !strongSelf.pianoRhodesSoundArray.contains(beattt) || pianoVinylSoundFilteringCode == 1 && !strongSelf.pianoVinylSoundArray.contains(beattt) || organSoundFilteringCode == 1 && !strongSelf.organSoundArray.contains(beattt) || theraminSoundFilteringCode == 1 && !strongSelf.theraminSoundArray.contains(beattt) || whistleSoundFilteringCode == 1 && !strongSelf.whistleSoundArray.contains(beattt) || hornsSoundFilteringCode == 1 && !strongSelf.hornsSoundArray.contains(beattt) || stringsSoundFilteringCode == 1 && !strongSelf.stringsSoundArray.contains(beattt) || fluteSoundFilteringCode == 1 && !strongSelf.fluteSoundArray.contains(beattt) || padBellSoundFilteringCode == 1 && !strongSelf.padBellSoundArray.contains(beattt) || padHollowSoundFilteringCode == 1 && !strongSelf.padHollowSoundArray.contains(beattt) || padAggressiveSoundFilteringCode == 1 && !strongSelf.padAggressiveSoundArray.contains(beattt) || choirSoundFilteringCode == 1 && !strongSelf.choirSoundArray.contains(beattt) || saxophoneSoundFilteringCode == 1 && !strongSelf.saxophoneSoundArray.contains(beattt) || guitarElectricSoundFilteringCode == 1 && !strongSelf.guitarElectricSoundArray.contains(beattt) || guitarAcousticSoundFilteringCode == 1 && !strongSelf.guitarAcousticSoundArray.contains(beattt) || guitarSteelSoundFilteringCode == 1 && !strongSelf.guitarSteelSoundArray.contains(beattt) || bellsEDMSoundFilteringCode == 1 && !strongSelf.bellsEDMSoundArray.contains(beattt) || bellsVinylSoundFilteringCode == 1 && !strongSelf.bellsVinylSoundArray.contains(beattt) || bellsGothicSoundFilteringCode == 1 && !strongSelf.bellsGothicSoundArray.contains(beattt) || bellsHollowSoundFilteringCode == 1 && !strongSelf.bellsHollowSoundArray.contains(beattt) || bellsMusicBoxSoundFilteringCode == 1 && !strongSelf.bellsMusicBoxSoundArray.contains(beattt) || sampleVocalSoundFilteringCode == 1 && !strongSelf.sampleVocalSoundArray.contains(beattt) || sampleSongSoundFilteringCode == 1 && !strongSelf.sampleSongSoundArray.contains(beattt) || noKickSoundFilteringCode == 1 && !strongSelf.noKickSoundArray.contains(beattt) || kickSoundFilteringCode == 1 && !strongSelf.kickSoundArray.contains(beattt) || long808SoundFilteringCode == 1 && !strongSelf.long808SoundArray.contains(beattt) || short808SoundFilteringCode == 1 && !strongSelf.short808SoundArray.contains(beattt) || clean808SoundFilteringCode == 1 && !strongSelf.clean808SoundArray.contains(beattt) || distorted808SoundFilteringCode == 1 && !strongSelf.distorted808SoundArray.contains(beattt) || moogBassSoundFilteringCode == 1 && !strongSelf.moogBassSoundArray.contains(beattt) || subBassSoundFilteringCode == 1 && !strongSelf.subBassSoundArray.contains(beattt) || synthBassDistortedSoundFilteringCode == 1 && !strongSelf.synthBassDistortedSoundArray.contains(beattt) || synthBassDeepSoundFilteringCode == 1 && !strongSelf.synthBassDeepSoundArray.contains(beattt) || snapSoundFilteringCode == 1 && !strongSelf.snapSoundArray.contains(beattt)
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
                    if allSoundsFilteringCode == 0 {
                        strongSelf.filteredBeats = []
                        if keyfliteringCode == 1 {
                            for beat in strongSelf.keySelectedArray {
                                if typefilteringCode==1&&strongSelf.typeSelectedArray.contains(beat) || tempofilteringCode==1&&strongSelf.tempoSelectedArray.contains(beat) || producersfilteringCode==1&&strongSelf.producerSelectedArray.contains(beat) {
                                    if !strongSelf.filteredBeats.contains(beat) {
                                        strongSelf.filteredBeats.append(beat)
                                    }
                                } else if !strongSelf.filteredBeats.contains(beat) {
                                    strongSelf.filteredBeats.append(beat)
                                }
                            }
                        }
                        if typefilteringCode == 1 {
                            for beat in strongSelf.typeSelectedArray {
                                if keyfliteringCode==1&&strongSelf.keySelectedArray.contains(beat) || tempofilteringCode==1&&strongSelf.tempoSelectedArray.contains(beat) || producersfilteringCode==1&&strongSelf.producerSelectedArray.contains(beat) {
                                    if !strongSelf.filteredBeats.contains(beat) {
                                        strongSelf.filteredBeats.append(beat)
                                    }
                                } else if !strongSelf.filteredBeats.contains(beat) {
                                    strongSelf.filteredBeats.append(beat)
                                }
                            }
                        }
                        if tempofilteringCode == 1 {
                            for beat in strongSelf.tempoSelectedArray {
                                if typefilteringCode==1&&strongSelf.typeSelectedArray.contains(beat) || keyfliteringCode==1&&strongSelf.keySelectedArray.contains(beat) || producersfilteringCode==1&&strongSelf.producerSelectedArray.contains(beat) {
                                    if !strongSelf.filteredBeats.contains(beat) {
                                        strongSelf.filteredBeats.append(beat)
                                    }
                                } else if !strongSelf.filteredBeats.contains(beat) {
                                    strongSelf.filteredBeats.append(beat)
                                }
                            }
                        }
                        if producersfilteringCode == 1 {
                            for beat in strongSelf.producerSelectedArray {
                                if typefilteringCode==1&&strongSelf.typeSelectedArray.contains(beat) || tempofilteringCode==1&&strongSelf.tempoSelectedArray.contains(beat) || keyfliteringCode==1&&strongSelf.keySelectedArray.contains(beat) {
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
                            if !strongSelf.keySelectedArray.contains(beat) && keyfliteringCode == 1 || !strongSelf.typeSelectedArray.contains(beat) && typefilteringCode == 1 || !strongSelf.tempoSelectedArray.contains(beat) && tempofilteringCode == 1 || !strongSelf.producerSelectedArray.contains(beat) && producersfilteringCode == 1 {
                                let index = strongSelf.filteredBeats.firstIndex{$0 === beat}
                                if index != nil {
                                    strongSelf.filteredBeats.remove(at: index!)
                                }
                            }
                        }
                    } else if allSoundsFilteringCode > 0{
                        strongSelf.soundsSelectedArray = []
                        if keysSoundFilteringCode == 1 {
                            spickedArray = strongSelf.keysSoundArray
                        } else if pianoAcousticSoundFilteringCode == 1 {
                            spickedArray = strongSelf.pianoAcousticSoundArray
                        } else if pianoVinylSoundFilteringCode == 1 {
                            spickedArray = strongSelf.pianoVinylSoundArray
                        } else if pianoElectricSoundFilteringCode == 1 {
                            spickedArray = strongSelf.pianoElectricSoundArray
                        } else if pianoRhodesSoundFilteringCode == 1 {
                            spickedArray = strongSelf.pianoRhodesSoundArray
                        } else if organSoundFilteringCode == 1 {
                            spickedArray = strongSelf.organSoundArray
                        } else if theraminSoundFilteringCode == 1 {
                            spickedArray = strongSelf.theraminSoundArray
                        } else if whistleSoundFilteringCode == 1 {
                            spickedArray = strongSelf.whistleSoundArray
                        } else if hornsSoundFilteringCode == 1 {
                            spickedArray = strongSelf.hornsSoundArray
                        } else if stringsSoundFilteringCode == 1 {
                            spickedArray = strongSelf.stringsSoundArray
                        } else if fluteSoundFilteringCode == 1 {
                            spickedArray = strongSelf.fluteSoundArray
                        } else if padBellSoundFilteringCode == 1 {
                            spickedArray = strongSelf.padBellSoundArray
                        } else if padHollowSoundFilteringCode == 1 {
                            spickedArray = strongSelf.padHollowSoundArray
                        } else if padAggressiveSoundFilteringCode == 1 {
                            spickedArray = strongSelf.padAggressiveSoundArray
                        } else if choirSoundFilteringCode == 1 {
                            spickedArray = strongSelf.choirSoundArray
                        } else if saxophoneSoundFilteringCode == 1 {
                            spickedArray = strongSelf.saxophoneSoundArray
                        } else if guitarElectricSoundFilteringCode == 1 {
                            spickedArray = strongSelf.guitarElectricSoundArray
                        } else if guitarAcousticSoundFilteringCode == 1 {
                            spickedArray = strongSelf.guitarAcousticSoundArray
                        } else if guitarSteelSoundFilteringCode == 1 {
                            spickedArray = strongSelf.guitarSteelSoundArray
                        } else if bellsEDMSoundFilteringCode == 1 {
                            spickedArray = strongSelf.bellsEDMSoundArray
                        } else if bellsVinylSoundFilteringCode == 1 {
                            spickedArray = strongSelf.bellsVinylSoundArray
                        } else if bellsGothicSoundFilteringCode == 1 {
                            spickedArray = strongSelf.bellsGothicSoundArray
                        } else if bellsHollowSoundFilteringCode == 1 {
                            spickedArray = strongSelf.bellsHollowSoundArray
                        } else if bellsMusicBoxSoundFilteringCode == 1 {
                            spickedArray = strongSelf.bellsMusicBoxSoundArray
                        } else if sampleVocalSoundFilteringCode == 1 {
                            spickedArray = strongSelf.sampleVocalSoundArray
                        } else if sampleSongSoundFilteringCode == 1 {
                            spickedArray = strongSelf.sampleSongSoundArray
                        } else if noKickSoundFilteringCode == 1 {
                            spickedArray = strongSelf.noKickSoundArray
                        } else if kickSoundFilteringCode == 1 {
                            spickedArray = strongSelf.kickSoundArray
                        } else if long808SoundFilteringCode == 1 {
                            spickedArray = strongSelf.long808SoundArray
                        } else if short808SoundFilteringCode == 1 {
                            spickedArray = strongSelf.short808SoundArray
                        } else if clean808SoundFilteringCode == 1 {
                            spickedArray = strongSelf.clean808SoundArray
                        } else if distorted808SoundFilteringCode == 1 {
                            spickedArray = strongSelf.distorted808SoundArray
                        } else if moogBassSoundFilteringCode == 1 {
                            spickedArray = strongSelf.moogBassSoundArray
                        } else if subBassSoundFilteringCode == 1 {
                            spickedArray = strongSelf.subBassSoundArray
                        } else if synthBassDistortedSoundFilteringCode == 1 {
                            spickedArray = strongSelf.synthBassDistortedSoundArray
                        } else if synthBassDeepSoundFilteringCode == 1 {
                            spickedArray = strongSelf.synthBassDeepSoundArray
                        } else if snapSoundFilteringCode == 1 {
                            spickedArray = strongSelf.snapSoundArray
                        }
                        strongSelf.soundsSelectedArray.append(contentsOf: spickedArray)
                        for beattt in strongSelf.soundsSelectedArray {
                            if keysSoundFilteringCode == 1 && !strongSelf.keysSoundArray.contains(beattt) || pianoAcousticSoundFilteringCode == 1 && !strongSelf.pianoAcousticSoundArray.contains(beattt) || pianoElectricSoundFilteringCode == 1 && !strongSelf.pianoElectricSoundArray.contains(beattt) || pianoRhodesSoundFilteringCode == 1 && !strongSelf.pianoRhodesSoundArray.contains(beattt) || pianoVinylSoundFilteringCode == 1 && !strongSelf.pianoVinylSoundArray.contains(beattt) || organSoundFilteringCode == 1 && !strongSelf.organSoundArray.contains(beattt) || theraminSoundFilteringCode == 1 && !strongSelf.theraminSoundArray.contains(beattt) || whistleSoundFilteringCode == 1 && !strongSelf.whistleSoundArray.contains(beattt) || hornsSoundFilteringCode == 1 && !strongSelf.hornsSoundArray.contains(beattt) || stringsSoundFilteringCode == 1 && !strongSelf.stringsSoundArray.contains(beattt) || fluteSoundFilteringCode == 1 && !strongSelf.fluteSoundArray.contains(beattt) || padBellSoundFilteringCode == 1 && !strongSelf.padBellSoundArray.contains(beattt) || padHollowSoundFilteringCode == 1 && !strongSelf.padHollowSoundArray.contains(beattt) || padAggressiveSoundFilteringCode == 1 && !strongSelf.padAggressiveSoundArray.contains(beattt) || choirSoundFilteringCode == 1 && !strongSelf.choirSoundArray.contains(beattt) || saxophoneSoundFilteringCode == 1 && !strongSelf.saxophoneSoundArray.contains(beattt) || guitarElectricSoundFilteringCode == 1 && !strongSelf.guitarElectricSoundArray.contains(beattt) || guitarAcousticSoundFilteringCode == 1 && !strongSelf.guitarAcousticSoundArray.contains(beattt) || guitarSteelSoundFilteringCode == 1 && !strongSelf.guitarSteelSoundArray.contains(beattt) || bellsEDMSoundFilteringCode == 1 && !strongSelf.bellsEDMSoundArray.contains(beattt) || bellsVinylSoundFilteringCode == 1 && !strongSelf.bellsVinylSoundArray.contains(beattt) || bellsGothicSoundFilteringCode == 1 && !strongSelf.bellsGothicSoundArray.contains(beattt) || bellsHollowSoundFilteringCode == 1 && !strongSelf.bellsHollowSoundArray.contains(beattt) || bellsMusicBoxSoundFilteringCode == 1 && !strongSelf.bellsMusicBoxSoundArray.contains(beattt) || sampleVocalSoundFilteringCode == 1 && !strongSelf.sampleVocalSoundArray.contains(beattt) || sampleSongSoundFilteringCode == 1 && !strongSelf.sampleSongSoundArray.contains(beattt) || noKickSoundFilteringCode == 1 && !strongSelf.noKickSoundArray.contains(beattt) || kickSoundFilteringCode == 1 && !strongSelf.kickSoundArray.contains(beattt) || long808SoundFilteringCode == 1 && !strongSelf.long808SoundArray.contains(beattt) || short808SoundFilteringCode == 1 && !strongSelf.short808SoundArray.contains(beattt) || clean808SoundFilteringCode == 1 && !strongSelf.clean808SoundArray.contains(beattt) || distorted808SoundFilteringCode == 1 && !strongSelf.distorted808SoundArray.contains(beattt) || moogBassSoundFilteringCode == 1 && !strongSelf.moogBassSoundArray.contains(beattt) || subBassSoundFilteringCode == 1 && !strongSelf.subBassSoundArray.contains(beattt) || synthBassDistortedSoundFilteringCode == 1 && !strongSelf.synthBassDistortedSoundArray.contains(beattt) || synthBassDeepSoundFilteringCode == 1 && !strongSelf.synthBassDeepSoundArray.contains(beattt) || snapSoundFilteringCode == 1 && !strongSelf.snapSoundArray.contains(beattt)
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
                            if typefilteringCode==1 && !strongSelf.typeSelectedArray.contains(beat) || tempofilteringCode==1 && !strongSelf.tempoSelectedArray.contains(beat) || producersfilteringCode==1 && !strongSelf.producerSelectedArray.contains(beat) || keyfliteringCode==1 && !strongSelf.keySelectedArray.contains(beat) {
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
            strongSelf.freeBeatTableView.reloadData()
        })
    }
    
    
    
    
    
    
    
    
    
    
    
   //MARK: - ALL STATUSES
    
    @objc func tempoFilterStatus(notification: NSNotification) {
        if tempoSelectedArray != [] {
            if tempofilteringCode == 0 {
                print(numberOfActiveFilterCells)
                
                print("Remove selected from final if it is not in any other selected arrays that have a filtering code of 1")
                if numberOfActiveFilterCells == 0 {
                    
                    print("number of active filter cells = \(numberOfActiveFilterCells)")
                    filteredBeats = initialBeats
                    DispatchQueue.main.async { [weak self] in
                        guard let strongSelf = self else {return}
                        strongSelf.freeBeatTableView.reloadData()
                        strongSelf.reSortFilteredBeats()
                    }
                } else {
                    filteredBeats = []
                    if keyfliteringCode == 1 {
                        filteredBeats = keySelectedArray
                    } else
                    if typefilteringCode == 1 {
                        filteredBeats = typeSelectedArray
                    } else
                    if soundsfilteringCode == 1 {
                        filteredBeats = soundsSelectedArray
                    } else
                    if producersfilteringCode == 1 {
                        filteredBeats = producerSelectedArray
                    }
                    for beat in filteredBeats {
                        if soundsfilteringCode==1 && !soundsSelectedArray.contains(beat) || tempofilteringCode==1 && !tempoSelectedArray.contains(beat) || producersfilteringCode==1 && !producerSelectedArray.contains(beat) || keyfliteringCode==1 && !keySelectedArray.contains(beat) {
                            let index = filteredBeats.firstIndex{$0 === beat}
                            if index != nil {
                                filteredBeats.remove(at: index!)
                            }
                            
                        }
                    }
                    DispatchQueue.main.async { [weak self] in
                        guard let strongSelf = self else {return}
                        strongSelf.freeBeatTableView.reloadData()
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
//                    if keyfliteringCode == 1 {
//                        for beat in keySelectedArray {
//                            if typefilteringCode==1&&typeSelectedArray.contains(beat) || soundsfilteringCode==1&&soundsSelectedArray.contains(beat) || producersfilteringCode==1&&producerSelectedArray.contains(beat) {
//                                if !filteredBeats.contains(beat) {
//                                    filteredBeats.append(beat)
//                                }
//                            }
////                            else if !filteredBeats.contains(beat) {
////                                filteredBeats.append(beat)
////                            }
//                        }
//                    }
//                    if typefilteringCode == 1 {
//                        for beat in typeSelectedArray {
//                            if keyfliteringCode==1&&keySelectedArray.contains(beat) || soundsfilteringCode==1&&soundsSelectedArray.contains(beat) || producersfilteringCode==1&&producerSelectedArray.contains(beat) {
//                                if !filteredBeats.contains(beat) {
//                                    filteredBeats.append(beat)
//                                }
//                            }
////                            else if !filteredBeats.contains(beat) {
////                                filteredBeats.append(beat)
////                            }
//                        }
//                    }
//                    if soundsfilteringCode == 1 {
//                        for beat in soundsSelectedArray {
//                            if typefilteringCode==1&&typeSelectedArray.contains(beat) || keyfliteringCode==1&&keySelectedArray.contains(beat) || producersfilteringCode==1&&producerSelectedArray.contains(beat) {
//                                if !filteredBeats.contains(beat) {
//                                    filteredBeats.append(beat)
//                                }
//                            }
////                            else if !filteredBeats.contains(beat) {
////                                filteredBeats.append(beat)
////                            }
//                        }
//                    }
//                    if producersfilteringCode == 1 {
//                        for beat in producerSelectedArray {
//                            if typefilteringCode==1&&typeSelectedArray.contains(beat) || soundsfilteringCode==1&&soundsSelectedArray.contains(beat) || keyfliteringCode==1&&keySelectedArray.contains(beat) {
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
//                    freeBeatTableView.reloadData()
                }
            }
            else if tempofilteringCode == 1 {
                print("Add selected to final if it is not already in final.")
                if numberOfActiveFilterCells == 1{
                    filteredBeats = tempoSelectedArray
                } else if numberOfActiveFilterCells > 1 {
                    filteredBeats = tempoSelectedArray
                    for beat in filteredBeats
                    {
                        if !keySelectedArray.contains(beat)&&keyfliteringCode==1 || !typeSelectedArray.contains(beat)&&typefilteringCode==1 || !soundsSelectedArray.contains(beat)&&soundsfilteringCode==1 || !producerSelectedArray.contains(beat)&&producersfilteringCode==1
                        {
                           let index = filteredBeats.firstIndex{$0 === beat}
                           if index != nil {
                               filteredBeats.remove(at: index!)
                           }
                        }
                        
                    }
                }
                reSortFilteredBeats()
                freeBeatTableView.reloadData()
            }
        } else {
            if numberOfActiveFilterCells == 0 {
                filteredBeats = initialBeats
                DispatchQueue.main.async { [weak self] in
                    guard let strongSelf = self else {return}
                    strongSelf.freeBeatTableView.reloadData()
                    strongSelf.reSortFilteredBeats()
                }
            } else if numberOfActiveFilterCells == 1 {
                filteredBeats = []
                DispatchQueue.main.async { [weak self] in
                    guard let strongSelf = self else {return}
                    strongSelf.freeBeatTableView.reloadData()
                    strongSelf.reSortFilteredBeats()
                }
            } else {
                if tempofilteringCode == 0 {
                    filteredBeats = []
                    if keyfliteringCode == 1 {
                        filteredBeats = keySelectedArray
                    } else
                    if typefilteringCode == 1 {
                        filteredBeats = typeSelectedArray
                    } else
                    if soundsfilteringCode == 1 {
                        filteredBeats = soundsSelectedArray
                    } else
                    if producersfilteringCode == 1 {
                        filteredBeats = producerSelectedArray
                    }
                    for beat in filteredBeats {
                        if soundsfilteringCode==1 && !soundsSelectedArray.contains(beat) || typefilteringCode==1 && !typeSelectedArray.contains(beat) || producersfilteringCode==1 && !producerSelectedArray.contains(beat) || keyfliteringCode==1 && !keySelectedArray.contains(beat) {
                            let index = filteredBeats.firstIndex{$0 === beat}
                            if index != nil {
                                filteredBeats.remove(at: index!)
                            }
                            
                        }
                    }
                    DispatchQueue.main.async { [weak self] in
                        guard let strongSelf = self else {return}
                        strongSelf.freeBeatTableView.reloadData()
                        strongSelf.reSortFilteredBeats()
                    }
                } else {
                    filteredBeats = []
                    DispatchQueue.main.async { [weak self] in
                        guard let strongSelf = self else {return}
                        strongSelf.freeBeatTableView.reloadData()
                        strongSelf.reSortFilteredBeats()
                    }
                }
            }
        }
    }
    
    @objc func keyFilterStatus(notification: NSNotification) {
        if keySelectedArray != [] {
            if keyfliteringCode == 0 {
                print("Remove selected from final if it is not in any other selected arrays that have a filtering code of 1")
                if numberOfActiveFilterCells == 0{
                    print("number of active filter cells = \(numberOfActiveFilterCells)")
                    filteredBeats = initialBeats
                    reSortFilteredBeats()
                    freeBeatTableView.reloadData()
                } else {
                    filteredBeats = []
                    if tempofilteringCode == 1 {
                        filteredBeats = tempoSelectedArray
                    } else
                    if typefilteringCode == 1 {
                        filteredBeats = typeSelectedArray
                    } else
                    if soundsfilteringCode == 1 {
                        filteredBeats = soundsSelectedArray
                    } else
                    if producersfilteringCode == 1 {
                        filteredBeats = producerSelectedArray
                    }
                    for beat in filteredBeats {
                        if soundsfilteringCode==1 && !soundsSelectedArray.contains(beat) || typefilteringCode==1 && !typeSelectedArray.contains(beat) || producersfilteringCode==1 && !producerSelectedArray.contains(beat) || tempofilteringCode==1 && !tempoSelectedArray.contains(beat) {
                            let index = filteredBeats.firstIndex{$0 === beat}
                            if index != nil {
                                filteredBeats.remove(at: index!)
                            }
                            
                        }
                    }
                    DispatchQueue.main.async { [weak self] in
                        guard let strongSelf = self else {return}
                        strongSelf.freeBeatTableView.reloadData()
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
//                    print("tempo code on/off = \(tempofilteringCode)")
//                    if tempofilteringCode == 1 {
//                        for beat in tempoSelectedArray {
//                            if typefilteringCode==1&&typeSelectedArray.contains(beat) || soundsfilteringCode==1&&soundsSelectedArray.contains(beat) || producersfilteringCode==1&&producerSelectedArray.contains(beat) {
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
//                    if typefilteringCode == 1 {
//                        for beat in typeSelectedArray {
//                            if tempofilteringCode==1&&tempoSelectedArray.contains(beat) || soundsfilteringCode==1&&soundsSelectedArray.contains(beat) || producersfilteringCode==1&&producerSelectedArray.contains(beat) {
//                                if !filteredBeats.contains(beat) {
//                                    filteredBeats.append(beat)
//                                }
//                            }
////                            else if !filteredBeats.contains(beat) {
////                                filteredBeats.append(beat)
////                            }
//                        }
//                    }
//                    if soundsfilteringCode == 1 {
//                        for beat in soundsSelectedArray {
//                            if typefilteringCode==1&&typeSelectedArray.contains(beat) || tempofilteringCode==1&&tempoSelectedArray.contains(beat) || producersfilteringCode==1&&producerSelectedArray.contains(beat) {
//                                if !filteredBeats.contains(beat) {
//                                    filteredBeats.append(beat)
//                                }
//                            }
////                            else if !filteredBeats.contains(beat) {
////                                filteredBeats.append(beat)
////                            }
//                        }
//                    }
//                    if producersfilteringCode == 1 {
//                        for beat in producerSelectedArray {
//                            if typefilteringCode==1&&typeSelectedArray.contains(beat) || soundsfilteringCode==1&&soundsSelectedArray.contains(beat) || tempofilteringCode==1&&tempoSelectedArray.contains(beat) {
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
//                    freeBeatTableView.reloadData()
                }
            }
            else if keyfliteringCode == 1 {
                print("Add selected to final if it is not already in final.")
                if numberOfActiveFilterCells == 1{
                    filteredBeats = keySelectedArray
                } else if numberOfActiveFilterCells > 1 {
                    filteredBeats = keySelectedArray
                    for beat in filteredBeats
                    {
                        if !tempoSelectedArray.contains(beat)&&tempofilteringCode==1 || !typeSelectedArray.contains(beat)&&typefilteringCode==1 || !soundsSelectedArray.contains(beat)&&soundsfilteringCode==1 || !producerSelectedArray.contains(beat)&&producersfilteringCode==1
                        {
                           let index = filteredBeats.firstIndex{$0 === beat}
                           if index != nil {
                               filteredBeats.remove(at: index!)
                           }
                        }
                        
                    }
                }
            
            reSortFilteredBeats()
            freeBeatTableView.reloadData()
            }
        } else {
            if numberOfActiveFilterCells == 0 {
                filteredBeats = initialBeats
                DispatchQueue.main.async { [weak self] in
                    guard let strongSelf = self else {return}
                    strongSelf.freeBeatTableView.reloadData()
                    strongSelf.reSortFilteredBeats()
                }
            } else if numberOfActiveFilterCells == 1 {
                filteredBeats = []
                DispatchQueue.main.async { [weak self] in
                    guard let strongSelf = self else {return}
                    strongSelf.freeBeatTableView.reloadData()
                    strongSelf.reSortFilteredBeats()
                }
            } else {
                if keyfliteringCode == 0 {
                    filteredBeats = []
                    if tempofilteringCode == 1 {
                        filteredBeats = tempoSelectedArray
                    } else
                    if typefilteringCode == 1 {
                        filteredBeats = typeSelectedArray
                    } else
                    if soundsfilteringCode == 1 {
                        filteredBeats = soundsSelectedArray
                    } else
                    if producersfilteringCode == 1 {
                        filteredBeats = producerSelectedArray
                    }
                    for beat in filteredBeats {
                        if soundsfilteringCode==1 && !soundsSelectedArray.contains(beat) || typefilteringCode==1 && !typeSelectedArray.contains(beat) || producersfilteringCode==1 && !producerSelectedArray.contains(beat) || tempofilteringCode==1 && !tempoSelectedArray.contains(beat) {
                            let index = filteredBeats.firstIndex{$0 === beat}
                            if index != nil {
                                filteredBeats.remove(at: index!)
                            }
                            
                        }
                    }
                    DispatchQueue.main.async { [weak self] in
                        guard let strongSelf = self else {return}
                        strongSelf.freeBeatTableView.reloadData()
                        strongSelf.reSortFilteredBeats()
                    }
                } else {
                    filteredBeats = []
                    DispatchQueue.main.async { [weak self] in
                        guard let strongSelf = self else {return}
                        strongSelf.freeBeatTableView.reloadData()
                        strongSelf.reSortFilteredBeats()
                    }
                }
            }
        }
    }
    
    @objc func typeFilterStatus(notification: NSNotification) {
        if typeSelectedArray != [] && allTypeFilteringCode != 0{
            if typefilteringCode == 0 {
                //print("Remove selected from final if it is not in any other selected arrays that have a filtering code of 1")
                if numberOfActiveFilterCells == 0{
                    print("number of active filter cells = \(numberOfActiveFilterCells)")
                    filteredBeats = initialBeats
                    reSortFilteredBeats()
                    freeBeatTableView.reloadData()
                } else {
                    filteredBeats = []
                    if tempofilteringCode == 1 {
                        filteredBeats = tempoSelectedArray
                    } else
                    if keyfliteringCode == 1 {
                        filteredBeats = keySelectedArray
                    } else
                    if soundsfilteringCode == 1 {
                        filteredBeats = soundsSelectedArray
                    } else
                    if producersfilteringCode == 1 {
                        filteredBeats = producerSelectedArray
                    }
                    for beat in filteredBeats {
                        if soundsfilteringCode==1 && !soundsSelectedArray.contains(beat) || tempofilteringCode==1 && !tempoSelectedArray.contains(beat) || producersfilteringCode==1 && !producerSelectedArray.contains(beat) || keyfliteringCode==1 && !keySelectedArray.contains(beat) {
                            let index = filteredBeats.firstIndex{$0 === beat}
                            if index != nil {
                                filteredBeats.remove(at: index!)
                            }
                            
                        }
                    }
                    DispatchQueue.main.async { [weak self] in
                        guard let strongSelf = self else {return}
                        strongSelf.freeBeatTableView.reloadData()
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
//                    print("tempo code on/off = \(typefilteringCode)")
//                    if tempofilteringCode == 1 {
//                        for beat in tempoSelectedArray {
//                            if keyfliteringCode==1&&keySelectedArray.contains(beat) || soundsfilteringCode==1&&soundsSelectedArray.contains(beat) || producersfilteringCode==1&&producerSelectedArray.contains(beat) {
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
//                    if keyfliteringCode == 1 {
//                        for beat in keySelectedArray {
//                            if tempofilteringCode==1&&tempoSelectedArray.contains(beat) || soundsfilteringCode==1&&soundsSelectedArray.contains(beat) || producersfilteringCode==1&&producerSelectedArray.contains(beat) {
//                                if !filteredBeats.contains(beat) {
//                                    filteredBeats.append(beat)
//                                }
//                            }
////                            else if !filteredBeats.contains(beat) {
////                                filteredBeats.append(beat)
////                            }
//                        }
//                    }
//                    if soundsfilteringCode == 1 {
//                        for beat in soundsSelectedArray {
//                            if keyfliteringCode==1&&keySelectedArray.contains(beat) || tempofilteringCode==1&&tempoSelectedArray.contains(beat) || producersfilteringCode==1&&producerSelectedArray.contains(beat) {
//                                if !filteredBeats.contains(beat) {
//                                    filteredBeats.append(beat)
//                                }
//                            }
////                            else if !filteredBeats.contains(beat) {
////                                filteredBeats.append(beat)
////                            }
//                        }
//                    }
//                    if producersfilteringCode == 1 {
//                        for beat in producerSelectedArray {
//                            if keyfliteringCode==1&&keySelectedArray.contains(beat) || soundsfilteringCode==1&&soundsSelectedArray.contains(beat) || tempofilteringCode==1&&tempoSelectedArray.contains(beat) {
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
//                    freeBeatTableView.reloadData()
                }
            }
            else if typefilteringCode == 1 {
                print("Add selected to final if it is not already in final.")
                if numberOfActiveFilterCells == 1{
                    filteredBeats = typeSelectedArray
                } else if numberOfActiveFilterCells > 1 {
                    filteredBeats = typeSelectedArray
                    for beat in filteredBeats
                    {
                        if !tempoSelectedArray.contains(beat)&&tempofilteringCode==1 || !keySelectedArray.contains(beat)&&keyfliteringCode==1 || !soundsSelectedArray.contains(beat)&&soundsfilteringCode==1 || !producerSelectedArray.contains(beat)&&producersfilteringCode==1
                        {
                           let index = filteredBeats.firstIndex{$0 === beat}
                           if index != nil {
                               filteredBeats.remove(at: index!)
                           }
                        }
                        
                    }
                }
                
                reSortFilteredBeats()
                freeBeatTableView.reloadData()
            }
            
        }
    }
    
    @objc func soundsFilterStatus(notification: NSNotification) {
        if allSoundsFilteringCode != 0{
            if soundsfilteringCode == 0 {
                //print("Remove selected from final if it is not in any other selected arrays that have a filtering code of 1")
                if numberOfActiveFilterCells == 0{
                    
                    print("number of active filter cells = \(numberOfActiveFilterCells)")
                    filteredBeats = initialBeats
                    reSortFilteredBeats()
                    freeBeatTableView.reloadData()
                } else {
                    filteredBeats = []
                    if tempofilteringCode == 1 {
                        filteredBeats = tempoSelectedArray
                    } else
                    if keyfliteringCode == 1 {
                        filteredBeats = keySelectedArray
                    } else
                    if typefilteringCode == 1 {
                        filteredBeats = typeSelectedArray
                    } else
                    if producersfilteringCode == 1 {
                        filteredBeats = producerSelectedArray
                    }
                    for beat in filteredBeats {
                        if typefilteringCode==1 && !typeSelectedArray.contains(beat) || tempofilteringCode==1 && !tempoSelectedArray.contains(beat) || producersfilteringCode==1 && !producerSelectedArray.contains(beat) || keyfliteringCode==1 && !keySelectedArray.contains(beat) {
                            let index = filteredBeats.firstIndex{$0 === beat}
                            if index != nil {
                                filteredBeats.remove(at: index!)
                            }
                            
                        }
                    }
                    DispatchQueue.main.async { [weak self] in
                        guard let strongSelf = self else {return}
                        strongSelf.reSortFilteredBeats()
                        strongSelf.freeBeatTableView.reloadData()
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
//                    print("tempo code on/off = \(soundsfilteringCode)")
//                    if tempofilteringCode == 1 {
//                        for beat in tempoSelectedArray {
//                            if keyfliteringCode==1&&keySelectedArray.contains(beat) || typefilteringCode==1&&typeSelectedArray.contains(beat) || producersfilteringCode==1&&producerSelectedArray.contains(beat) {
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
//                    if keyfliteringCode == 1 {
//                        for beat in keySelectedArray {
//                            if tempofilteringCode==1&&tempoSelectedArray.contains(beat) || typefilteringCode==1&&typeSelectedArray.contains(beat) || producersfilteringCode==1&&producerSelectedArray.contains(beat) {
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
//                    if typefilteringCode == 1 {
//                        for beat in typeSelectedArray {
//                            print(beat.name)
//                            if keyfliteringCode==1&&keySelectedArray.contains(beat) || tempofilteringCode==1&&tempoSelectedArray.contains(beat) || producersfilteringCode==1&&producerSelectedArray.contains(beat) {
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
//                    if producersfilteringCode == 1 {
//                        for beat in producerSelectedArray {
//                            if keyfliteringCode==1&&keySelectedArray.contains(beat) || typefilteringCode==1&&typeSelectedArray.contains(beat) || tempofilteringCode==1&&tempoSelectedArray.contains(beat) {
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
//                        strongSelf.freeBeatTableView.reloadData()
//                        strongSelf.reSortFilteredBeats()
//                    }
                }
            }
            else if soundsfilteringCode == 1 {
                print("Add selected to final if it is not already in final.")
                if numberOfActiveFilterCells == 1{
                    filteredBeats = soundsSelectedArray
                } else if numberOfActiveFilterCells > 1 {
                    filteredBeats = soundsSelectedArray
                    for beat in filteredBeats
                    {
                        if !tempoSelectedArray.contains(beat)&&tempofilteringCode==1 || !typeSelectedArray.contains(beat)&&typefilteringCode==1 || !keySelectedArray.contains(beat)&&keyfliteringCode==1 || !producerSelectedArray.contains(beat)&&producersfilteringCode==1
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
                    strongSelf.freeBeatTableView.reloadData()
                    strongSelf.reSortFilteredBeats()
                }
            }
        }
    }
    
    
    
    
    
    
    
    //MARK: - ALL RESETS
    
    @objc func tempoFilterReset(notification: NSNotification) {
        tempoSelectedArray = []
                print("Remove selected from final if it is not in any other selected arrays that have a filtering code of 1")
                if numberOfActiveFilterCells == 0{
                    print("number of active filter cells = \(numberOfActiveFilterCells)")
                    filteredBeats = initialBeats
                    reSortFilteredBeats()
                    freeBeatTableView.reloadData()
                } else {
                    filteredBeats = []
                    if keyfliteringCode == 1 {
                        filteredBeats = keySelectedArray
                    } else
                    if typefilteringCode == 1 {
                        filteredBeats = typeSelectedArray
                    } else
                    if soundsfilteringCode == 1 {
                        filteredBeats = soundsSelectedArray
                    } else
                    if producersfilteringCode == 1 {
                        filteredBeats = producerSelectedArray
                    }
                    for beat in filteredBeats {
                        if soundsfilteringCode==1 && !soundsSelectedArray.contains(beat) || tempofilteringCode==1 && !tempoSelectedArray.contains(beat) || producersfilteringCode==1 && !producerSelectedArray.contains(beat) || keyfliteringCode==1 && !keySelectedArray.contains(beat) {
                            let index = filteredBeats.firstIndex{$0 === beat}
                            if index != nil {
                                filteredBeats.remove(at: index!)
                            }
                            
                        }
                    }
                    DispatchQueue.main.async { [weak self] in
                        guard let strongSelf = self else {return}
                        strongSelf.freeBeatTableView.reloadData()
                        strongSelf.reSortFilteredBeats()
                    }
                }
            
    }
    
    @objc func keyFilterReset(notification: NSNotification) {
        keySelectedArray = []
        print("Remove selected from final if it is not in any other selected arrays that have a filtering code of 1")
        if numberOfActiveFilterCells == 0{
            print("number of active filter cells = \(numberOfActiveFilterCells)")
            filteredBeats = initialBeats
            reSortFilteredBeats()
            freeBeatTableView.reloadData()
        } else {
            filteredBeats = []
            if tempofilteringCode == 1 {
                filteredBeats = tempoSelectedArray
            } else
            if typefilteringCode == 1 {
                filteredBeats = typeSelectedArray
            } else
            if soundsfilteringCode == 1 {
                filteredBeats = soundsSelectedArray
            } else
            if producersfilteringCode == 1 {
                filteredBeats = producerSelectedArray
            }
            for beat in filteredBeats {
                if soundsfilteringCode==1 && !soundsSelectedArray.contains(beat) || typefilteringCode==1 && !typeSelectedArray.contains(beat) || producersfilteringCode==1 && !producerSelectedArray.contains(beat) || tempofilteringCode==1 && !tempoSelectedArray.contains(beat) {
                    let index = filteredBeats.firstIndex{$0 === beat}
                    if index != nil {
                        filteredBeats.remove(at: index!)
                    }
                    
                }
            }
            DispatchQueue.main.async { [weak self] in
                guard let strongSelf = self else {return}
                strongSelf.freeBeatTableView.reloadData()
                strongSelf.reSortFilteredBeats()
            }
        }
    }
    
    @objc func typeFilterReset(notification: NSNotification) {
        typeSelectedArray = []
        print("Remove selected from final if it is not in any other selected arrays that have a filtering code of 1")
        if numberOfActiveFilterCells == 0{
            print("number of active filter cells = \(numberOfActiveFilterCells)")
            filteredBeats = initialBeats
            reSortFilteredBeats()
            freeBeatTableView.reloadData()
        } else {
            filteredBeats = []
            if tempofilteringCode == 1 {
                filteredBeats = tempoSelectedArray
            } else
            if keyfliteringCode == 1 {
                filteredBeats = keySelectedArray
            } else
            if soundsfilteringCode == 1 {
                filteredBeats = soundsSelectedArray
            } else
            if producersfilteringCode == 1 {
                filteredBeats = producerSelectedArray
            }
            for beat in filteredBeats {
                if soundsfilteringCode==1 && !soundsSelectedArray.contains(beat) || tempofilteringCode==1 && !tempoSelectedArray.contains(beat) || producersfilteringCode==1 && !producerSelectedArray.contains(beat) || keyfliteringCode==1 && !keySelectedArray.contains(beat) {
                    let index = filteredBeats.firstIndex{$0 === beat}
                    if index != nil {
                        filteredBeats.remove(at: index!)
                    }
                    
                }
            }
            DispatchQueue.main.async { [weak self] in
                guard let strongSelf = self else {return}
                strongSelf.freeBeatTableView.reloadData()
                strongSelf.reSortFilteredBeats()
            }
        }
    }
    
    @objc func soundsFilterReset(notification: NSNotification) {
        soundsSelectedArray = []
        print("Remove selected from final if it is not in any other selected arrays that have a filtering code of 1")
        if numberOfActiveFilterCells == 0{
            print("number of active filter cells = \(numberOfActiveFilterCells)")
            filteredBeats = initialBeats
            reSortFilteredBeats()
            freeBeatTableView.reloadData()
        } else {
            filteredBeats = []
            if tempofilteringCode == 1 {
                filteredBeats = tempoSelectedArray
            } else
            if keyfliteringCode == 1 {
                filteredBeats = keySelectedArray
            } else
            if typefilteringCode == 1 {
                filteredBeats = typeSelectedArray
            } else
            if producersfilteringCode == 1 {
                filteredBeats = producerSelectedArray
            }
            for beat in filteredBeats {
                if typefilteringCode==1 && !typeSelectedArray.contains(beat) || tempofilteringCode==1 && !tempoSelectedArray.contains(beat) || producersfilteringCode==1 && !producerSelectedArray.contains(beat) || keyfliteringCode==1 && !keySelectedArray.contains(beat) {
                    let index = filteredBeats.firstIndex{$0 === beat}
                    if index != nil {
                        filteredBeats.remove(at: index!)
                    }
                    
                }
            }
            DispatchQueue.main.async { [weak self] in
                guard let strongSelf = self else {return}
                strongSelf.reSortFilteredBeats()
                strongSelf.freeBeatTableView.reloadData()
            }
        }
    }
    
    
    
    
    
    
    
    func reSortFilteredBeats() {
        switch sortNumberForFilter {
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
    
    @objc func freeBeatSort(notification: NSNotification) {
        //1
        if notification.object as? String == "A-Z" {
            print("A-Z sorting complete")
            filteredBeats.sort(by: { $0.name < $1.name })//A-Z
            sortNumberForFilter = 1
        }
        //2
        if notification.object as? String == "Z-A" {
            print("Z-A sorting complete")
            filteredBeats.sort(by: { $0.name > $1.name })//Z-A
            sortNumberForFilter = 2
        }
        //3
        if notification.object as? String == "Longest First" {
            print("Longest to shortest duration sorting complete")
            filteredBeats.sort(by: { $0.duration > $1.duration })
            sortNumberForFilter = 3
        }
        //4
        if notification.object as? String == "Shortest First" {
            print("Shortest to Longest duration sorting complete")
            filteredBeats.sort(by: { $0.duration < $1.duration })
            sortNumberForFilter = 4
        }
        //5
        if notification.object as? String == "Latest First" {
            print("Latest to Oldest date sorting complete")
            filteredBeats.sort(by: { $0.datetime > $1.datetime})
            sortNumberForFilter = 5
        }
        //6
        if notification.object as? String == "Oldest First" {
            print("Oldest to Latest date sorting complete")
            filteredBeats.sort(by: { $0.datetime < $1.datetime})
            sortNumberForFilter = 6
        }
        //7
        if notification.object as? String == "Most First" {
            print("Most to Least downloads sorting complete")
            filteredBeats.sort(by: { $0.downloads > $1.downloads })
            sortNumberForFilter = 7
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
            sortNumberForFilter = 9
        }
        //10
        if notification.object as? String == "m$ - $$$" {
            print("$ - $$$ mp3 price  sorting complete")
            filteredBeats.sort(by: { $0.mp3Price ?? 0.00 < $1.mp3Price ?? 0.00 })
            sortNumberForFilter = 10
        }
        //11
        if notification.object as? String == "w$$$ - $" {
            print("$$$ - $ wav price sorting complete")
            filteredBeats.sort(by: { $0.wavPrice ?? 0.00 > $1.wavPrice ?? 0.00 })
            sortNumberForFilter = 11
        }
        //12
        if notification.object as? String == "w$ - $$$" {
            print("$ - $$$ wav price  sorting complete")
            filteredBeats.sort(by: { $0.wavPrice ?? 0.00 < $1.wavPrice ?? 0.00 })
            sortNumberForFilter = 12
        }
        //13
        if notification.object as? String == "e$$$ - $" {
            print("$$$ - $ exclusive price sorting complete")
            filteredBeats.sort(by: { $0.exclusivePrice ?? 0.00 > $1.exclusivePrice ?? 0.00 })
            sortNumberForFilter = 13
        }
        //14
        if notification.object as? String == "e$ - $$$" {
            print("$ - $$$ exclusive price  sorting complete")
            filteredBeats.sort(by: { $0.exclusivePrice ?? 0.00 < $1.exclusivePrice ?? 0.00 })
            sortNumberForFilter = 14
        }
        DispatchQueue.main.async { [weak self] in
            guard let strongSelf = self else {return}
            strongSelf.freeBeatTableView.reloadData()
        }
        
    }
    
    @IBAction func filterButtonTapped(_ sender: Any) {
//        present(filterMenu!, animated: true)
    }
    
    @IBAction func sortButtonTapped(_ sender: Any) {
//        present(sortMenu!, animated: true)
    }
    
//    func configure(position: Int) {
//        player?.prepareToPlay()
//        let beat = filteredBeats[position]
//        let url = beat.audioURL
//
//        let audioUrlStr = url
//        if let url = URL(string: audioUrlStr) {
//           do {
//            try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback)
//              player = try AVAudioPlayer(data: Data(contentsOf: url))
//           player?.prepareToPlay()
//
//            player?.volume = 1
//              print("Audio ready to play")
//            DispatchQueue.global().async {
//                self.player?.play()
//            }
//           } catch let error {
//                print("error occured while audio downloading")
//                print(error.localizedDescription)
//           }
//        }
//    }
    
    func dismissKeyboardOnTap() {
        let tap = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        freeBeatTableView.keyboardDismissMode = .onDrag
    }

}


// MARK: - Table View Extension
extension FreeBeatsViewController: UITableViewDelegate, UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredBeats.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let beat = filteredBeats[indexPath.row]
        
        if accountType == "Creator" {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ArtistBeatCell") as! FreeBeatArtistTableViewCell
            cell.setBeat(beat: beat)
            
            return cell
        } else if accountType == "Listener" {
            let cell = tableView.dequeueReusableCell(withIdentifier: "BeatCell") as! FreeBeatListenerCell
            cell.setBeat(beat: beat)
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "GuestBeatCell") as! FreeBeatGuestTableViewCell
            cell.setBeat(beat: beat)
            
            return cell
        }
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

extension FreeBeatsViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchText == "" {
            filteredBeats = initialBeats
            filteredResultsLabel.isHidden = true
            reSortFilteredBeats()
            freeBeatTableView.reloadData()
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
        freeBeatTableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        filteredBeats = initialBeats
        filteredResultsLabel.isHidden = true
        reSortFilteredBeats()
        freeBeatTableView.reloadData()
    }
}

//MARK: - SortCell

class FreeBeatSortCellTableViewCell: UITableViewCell {
    
    static let shared = FreeBeatSortCellTableViewCell()

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
        NotificationCenter.default.post(name: SortChangedNotify, object: label)
        sortWayLabel.alpha = 1
        if counter == 1 {
            sortSubTypeLabel.isHidden = false
            sortWayBadge.isHidden = false
            sortSubTypeLabel.text = label
            if countLeftOn == 2 {
                count += 1
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


public var selectedIndex:IndexPath!
public var selectedPath = 0
public var sortSubTypeText = ""
public var count = 0
public var nameCountLeftOn = 1
public var dateCountLeftOn = 1
public var durationCountLeftOn = 1
public var downloadsCountLeftOn = 1
public var mp3CountLeftOn = 1
public var wavCountLeftOn = 1
public var exclusiveCountLeftOn = 1


//MARK: - SortTableViewSetup, SortMenuListController

class SortMenuListController: UITableViewController {
    deinit {
        print("📗sort controller Deallocated")
    }
    
    static let shared = SortMenuListController()
    
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
        let cell = tableView.cellForRow(at: selectedIndex) as! FreeBeatSortCellTableViewCell
        cell.remove()
        selectedIndex = nil
        selectedPath = 0
        sortSubTypeText = ""
        count = 0
        nameCountLeftOn = 1
        dateCountLeftOn = 1
        durationCountLeftOn = 1
        downloadsCountLeftOn = 1
        mp3CountLeftOn = 1
        wavCountLeftOn = 1
        exclusiveCountLeftOn = 1
        tableView.reloadData()
        NotificationCenter.default.post(name: SortChangedNotify, object: "Latest First")
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sorts.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let sort = sorts[indexPath.row]
        
            let cell = tableView.dequeueReusableCell(withIdentifier: "freeBeatSortCell") as! FreeBeatSortCellTableViewCell
            cell.setSort(sort: sort)
            return cell
        
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        clearButton.isEnabled = true
        clearButton.setTitleColor(UIColor.init(red: 182/255, green: 0/255, blue: 3/255, alpha: 1), for: .normal)
        if selectedPath != indexPath.row {
            if selectedIndex != nil {
                let lastcell = tableView.cellForRow(at: selectedIndex) as! FreeBeatSortCellTableViewCell
                lastcell.remove()
            }
        }
        let animate: Void = tableView.reloadRows(at: [indexPath], with: .automatic)
        let cell = tableView.cellForRow(at: indexPath) as! FreeBeatSortCellTableViewCell
        print("indexPAth \(indexPath.row)")
        if indexPath.row == 0 {
            if selectedPath == 0 {
                count += 1
                print(count)
                if count == 1 {
                    cell.update(counter: 1, label: "A-Z", countLeftOn: 1)
                    nameCountLeftOn = 1
                } else if count == 2 {
                    cell.update(counter: 2, label: "Z-A", countLeftOn: 2)
                    nameCountLeftOn = 2
                } else if count == 3 {
                    cell.update(counter: 3, label: "A-Z", countLeftOn: 1)
                    nameCountLeftOn = 1
                    count -= 2
                }
            } else {
                animate
                count = 1
                print(nameCountLeftOn, nameCountLeftOn)
                var textleft = ""
                if nameCountLeftOn == 1 {
                    textleft = "A-Z"
                } else if nameCountLeftOn == 2 {
                    textleft = "Z-A"
                }
                cell.update(counter: 1, label: textleft, countLeftOn: nameCountLeftOn)
                print(count)
            }
        }
        if indexPath.row == 1 {
            if selectedPath == 1 {
                count += 1
                print(count)
                if count == 1 {
                    cell.update(counter: 1, label: "Latest First", countLeftOn: 1)
                    dateCountLeftOn = 1
                } else if count == 2 {
                    cell.update(counter: 2, label: "Oldest First", countLeftOn: 2)
                    dateCountLeftOn = 2
                } else if count == 3 {
                    cell.update(counter: 3, label: "Latest First", countLeftOn: 1)
                    dateCountLeftOn = 1
                    count -= 2
                }
            } else {
                animate
                count = 1
                print(dateCountLeftOn,dateCountLeftOn)
                var textleft = ""
                if dateCountLeftOn == 1 {
                    textleft = "Latest First"
                } else if dateCountLeftOn == 2 {
                    textleft = "Oldest First"
                }
                cell.update(counter: 1, label: textleft, countLeftOn: dateCountLeftOn)
                print(count)
            }
        }
        if indexPath.row == 2 {
            var textleft = ""
            if selectedPath == 2 {
                count += 1
                print(count)
                if count == 1 {
                    cell.update(counter: 1, label: "Longest First", countLeftOn: 1)
                    durationCountLeftOn = 1
                } else if count == 2 {
                    cell.update(counter: 2, label: "Shortest First", countLeftOn: 2)
                    durationCountLeftOn = 2
                } else if count == 3 {
                    cell.update(counter: 3, label: "Longest First", countLeftOn: 1)
                    durationCountLeftOn = 1
                    count -= 2
                }
            } else {
                animate
                count = 1
                if durationCountLeftOn == 1 {
                    textleft = "Longest First"
                } else if durationCountLeftOn == 2 {
                    textleft = "Shortest First"
                }
                cell.update(counter: 1, label: textleft, countLeftOn: durationCountLeftOn)
                print(count)
            }
        }
        if indexPath.row == 3 {
            if selectedPath == 3 {
                count += 1
                print(count)
                if count == 1 {
                    cell.update(counter: 1, label: "Most First", countLeftOn: 1)
                    downloadsCountLeftOn = 1
                } else if count == 2 {
                    cell.update(counter: 2, label: "Least First", countLeftOn: 2)
                    downloadsCountLeftOn = 2
                } else if count == 3 {
                    cell.update(counter: 3, label: "Most First", countLeftOn: 1)
                    downloadsCountLeftOn = 1
                    count -= 2
                }
            } else {
                animate
                count = 1
                var textleft = ""
                if downloadsCountLeftOn == 1 {
                    textleft = "Most First"
                } else if downloadsCountLeftOn == 2 {
                    textleft = "Least First"
                }
                cell.update(counter: 1, label: textleft, countLeftOn: downloadsCountLeftOn)
                print(count)
            }
        }
        if indexPath.row == 4 {
            if selectedPath == 4 {
                count += 1
                print(count)
                if count == 1 {
                    cell.update(counter: 1, label: "m$$$ - $", countLeftOn: 1)
                    mp3CountLeftOn = 1
                } else if count == 2 {
                    cell.update(counter: 2, label: "m$ - $$$", countLeftOn: 2)
                    mp3CountLeftOn = 2
                } else if count == 3 {
                    cell.update(counter: 3, label: "m$$$ - $", countLeftOn: 1)
                    mp3CountLeftOn = 1
                    count -= 2
                }
            } else {
                animate
                count = 1
                var textleft = ""
                if mp3CountLeftOn == 1 {
                    textleft = "m$$$ - $"
                } else if mp3CountLeftOn == 2 {
                    textleft = "m$ - $$$"
                }
                cell.update(counter: 1, label: textleft, countLeftOn: mp3CountLeftOn)
                print(count)
            }
        }
        if indexPath.row == 5 {
            if selectedPath == 5 {
                count += 1
                print(count)
                if count == 1 {
                    cell.update(counter: 1, label: "w$$$ - $", countLeftOn: 1)
                    wavCountLeftOn = 1
                } else if count == 2 {
                    cell.update(counter: 2, label: "w$ - $$$", countLeftOn: 2)
                    wavCountLeftOn = 2
                } else if count == 3 {
                    cell.update(counter: 3, label: "w$$$ - $", countLeftOn: 1)
                    wavCountLeftOn = 1
                    count -= 2
                }
            } else {
                animate
                count = 1
                var textleft = ""
                if wavCountLeftOn == 1 {
                    textleft = "w$$$ - $"
                } else if wavCountLeftOn == 2 {
                    textleft = "w$ - $$$"
                }
                cell.update(counter: 1, label: textleft, countLeftOn: wavCountLeftOn)
                print(count)
            }
        }
        if indexPath.row == 6 {
            if selectedPath == 6 {
                count += 1
                print(count)
                if count == 1 {
                    cell.update(counter: 1, label: "e$$$ - $", countLeftOn: 1)
                    exclusiveCountLeftOn = 1
                } else if count == 2 {
                    cell.update(counter: 2, label: "e$ - $$$", countLeftOn: 2)
                    exclusiveCountLeftOn = 2
                } else if count == 3 {
                    cell.update(counter: 3, label: "e$$$ - $", countLeftOn: 1)
                    exclusiveCountLeftOn = 1
                    count -= 2
                }
            } else {
                animate
                count = 1
                var textleft = ""
                if exclusiveCountLeftOn == 1 {
                    textleft = "e$$$ - $"
                } else if exclusiveCountLeftOn == 2 {
                    textleft = "e$ - $$$"
                }
                cell.update(counter: 1, label: textleft, countLeftOn: exclusiveCountLeftOn)
                print(count)
            }
        }
        selectedIndex = indexPath
        selectedPath = indexPath.row
        
        
    }
}

extension FreeBeatsViewController: SideMenuNavigationControllerDelegate {

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
        SideMenuManager.default.rightMenuNavigationController = filterMenu
        filterMenu.setNavigationBarHidden(true, animated: false)
        filterMenu.presentationStyle = .viewSlideOutMenuIn
    }
}



