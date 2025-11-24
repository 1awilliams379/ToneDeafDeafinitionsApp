//
//  EditAlbumViewController.swift
//  ToneDeafDeafinitionsApp
//
//  Created by Tone Deaf on 7/17/22.
//  Copyright © 2022 GITEM Solutions. All rights reserved.
//

import UIKit
import CloudKit
import MobileCoreServices

protocol EditAlbumAllAlbumsDelegate: class {
    func selectedAlbum(_ album: AlbumData)
}

protocol EditAlbumPersonsDelegate: class {
    func personAdded(_ person: PersonData)
}

protocol EditAlbumSongsDelegate: class {
    func songAdded(_ songAndData: [String?:SongData])
}

protocol EditAlbumTracksDelegate: class {
    func trackAdded(_ trackAndData: [String:Any])
}

protocol EditAlbumVideosDelegate: class {
    func videoAdded(_ videoAndData: [String:VideoData])
}

protocol EditAlbumInstrumentalsDelegate: class {
    func instrumentalAdded(_ instrumentalAndData: [String?:InstrumentalData])
}

protocol EditAlbumAlbumsDelegate: class {
    func albumAdded(_ album: AlbumData)
}

class EditAlbumViewController: UIViewController, EditAlbumAllAlbumsDelegate, EditAlbumPersonsDelegate, EditAlbumSongsDelegate, EditAlbumTracksDelegate, EditAlbumVideosDelegate, EditAlbumInstrumentalsDelegate, EditAlbumAlbumsDelegate{
    
    static let shared = EditAlbumViewController()
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
    var uploadCompletionStatus25:Bool!
    var uploadCompletionStatus26:Bool!
    var uploadCompletionStatus27:Bool!
    var uploadCompletionStatus28:Bool!
    var uploadCompletionStatus29:Bool!
    var uploadCompletionStatus30:Bool!
    var uploadCompletionStatus31:Bool!
    
    var errorCountForController:Int = 0
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var mainArtistsTableView: UITableView!
    @IBOutlet weak var mainArtistsHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var allArtistsTableView: UITableView!
    @IBOutlet weak var allartistsHeightConstraint: NSLayoutConstraint!
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
    @IBOutlet weak var tracksTableView: UITableView!
    @IBOutlet weak var tracksHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var songsTableView: UITableView!
    @IBOutlet weak var songsHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var videosTableView: UITableView!
    @IBOutlet weak var videosHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var instrumentalsTableView: UITableView!
    @IBOutlet weak var instrumentalsHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var deluxesTableView: UITableView!
    @IBOutlet weak var deluxesHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var otherVersionsTableView: UITableView!
    @IBOutlet weak var otherVersionsHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var changeAlbumButton: UIButton!
    @IBOutlet weak var imageURL: CopyableLabel!
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var name: CopyableLabel!
    @IBOutlet weak var previewURL: CopyableLabel!
    @IBOutlet weak var appIDLAbel: CopyableLabel!
    @IBOutlet weak var favoritesLabel: CopyableLabel!
    @IBOutlet weak var dateLabel: CopyableLabel!
    @IBOutlet weak var timeLabel: CopyableLabel!
    @IBOutlet weak var spotifyURL: UILabel!
    @IBOutlet weak var removeSpotifyURLButton: UIButton!
    @IBOutlet weak var appleMusicURL: UILabel!
    @IBOutlet weak var removeAppleMusicURLButton: UIButton!
    @IBOutlet weak var soundcloudURL: UILabel!
    @IBOutlet weak var removeSoundcloudURLButton: UIButton!
    @IBOutlet weak var youtubeMusicURL: UILabel!
    @IBOutlet weak var removeYoutubeMusicURLButton: UIButton!
    @IBOutlet weak var amazonURL: UILabel!
    @IBOutlet weak var removeAmazonURLButton: UIButton!
    @IBOutlet weak var deezerURL: UILabel!
    @IBOutlet weak var removeDeezerURLButton: UIButton!
    @IBOutlet weak var tidalURL: UILabel!
    @IBOutlet weak var removeTidalURLButton: UIButton!
    @IBOutlet weak var napsterURL: UILabel!
    @IBOutlet weak var removeNapsterURLButton: UIButton!
    @IBOutlet weak var spinrillaURL: UILabel!
    @IBOutlet weak var removeSpinrillaURLButton: UIButton!
    @IBOutlet weak var spotifyStatusControl: UISegmentedControl!
    @IBOutlet weak var appleMusicStatusControl: UISegmentedControl!
    @IBOutlet weak var soundcloudStatusControl: UISegmentedControl!
    @IBOutlet weak var youtubeMusicStatusControl: UISegmentedControl!
    @IBOutlet weak var amazonStatusControl: UISegmentedControl!
    @IBOutlet weak var deezerStatusControl: UISegmentedControl!
    @IBOutlet weak var tidalStatusControl: UISegmentedControl!
    @IBOutlet weak var napsterStatusControl: UISegmentedControl!
    @IBOutlet weak var spinrillaStatusControl: UISegmentedControl!
    @IBOutlet weak var verificationLabel: UILabel!
    @IBOutlet weak var deluxeControl: UISegmentedControl!
    @IBOutlet weak var deluxeOfStackView: UIStackView!
    @IBOutlet weak var deluxeOfTextField: UITextField!{
        didSet {
            let placeholderText = NSAttributedString(string: "If album has standard edition in app",
                                                     attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray.withAlphaComponent(0.4)])
            
            deluxeOfTextField.attributedPlaceholder = placeholderText
        }
    }
    @IBOutlet weak var otherVersionControl: UISegmentedControl!
    @IBOutlet weak var otherVersionOfStackView: UIStackView!
    @IBOutlet weak var otherVersionOfTextField: UITextField!{
        didSet {
            let placeholderText = NSAttributedString(string: "If album has standard edition in app",
                                                     attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray.withAlphaComponent(0.4)])
            
            otherVersionOfTextField.attributedPlaceholder = placeholderText
        }
    }
    @IBOutlet weak var industryCertifiedControl: UISegmentedControl!
    @IBOutlet weak var statusControl: UISegmentedControl!
    @IBOutlet weak var updateButton: UIButton!
    
    var newImage:UIImage!
    var newPreview:URL!
    var currentFileType = ""
    var arr = ""
    var prevPage = ""
    var tbsender:String!
    
    var deluxeAlbum = false
    var deluxeOf:String!
    var deluxeHold:[String]!
    var otherVersionsAlbum = false
    var otherVersionsOf:String!
    var otherVersionsHold:[String]!
    
    var allAlbums:[AlbumData]!
    
    var mainArtistsArr:[PersonData] = []
    var allArtistsArr:[PersonData] = []
    var producersArr:[PersonData] = []
    var writersArr:[PersonData] = []
    var mixEngineerArr:[PersonData] = []
    var masteringEngineerArr:[PersonData] = []
    var recordingEngineerArr:[PersonData] = []
    var tracksArr:[String:Any] = [:]
    var songsArr:[SongData] = []
    var videosArr:[VideoData] = []
    var instrumentalsArr:[InstrumentalData] = []
    var trackExceptionsArr:[Any] = []
    var deluxesArr:[AlbumData] = []
    var songOtherVersionsArr:[AlbumData] = []
    
    var albumPickerView = UIPickerView()
    var otherVersionOfPickerView = UIPickerView()
    var deluxeOfPickerView = UIPickerView()
    
    var progressView:UIProgressView!
    var totalProgress:Float = 0
    var progressCompleted:Float = 0
    var alertView:UIAlertController!
    
    let hiddenAlbumTextField =  UITextField(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    
    var currentAlbum:AlbumData!
    let initialAlbum = AlbumData(toneDeafAppId: "", instrumentals: nil, dateRegisteredToApp: "", timeRegisteredToApp: "", songs: nil, tracks: [:], videos: nil, merch: nil, name: "", mainArtist: [], allArtists: nil, producers: [], writers: nil, mixEngineers: nil, masteringEngineers: nil, recordingEngineers: nil, isActive: false, favoritesOverall: 0, manualImageURL: nil, manualPreviewURL: nil, numberofTracks: 0, officialAlbumVideo: nil, spotify: nil, apple: nil, soundcloud: nil, youtubeMusic: nil, amazon: nil, tidal: nil, deezer: nil, spinrilla: nil, napster: nil, industryCerified: nil, verificationLevel:nil, deluxes: nil, isDeluxe: nil, isOtherVersion: nil, otherVersions: nil)
    
    var boolDict:[String:Bool?] = [
        "spotify":nil,
        "apple":nil,
        "soundcloud":nil,
        "youtubemusic":nil,
        "amazon":nil,
        "deezer":nil,
        "tidal":nil,
        "napster":nil,
        "spinrilla":nil
    ]
    var urlDict:[String:String?] = [
        "spotify":nil,
        "apple":nil,
        "soundcloud":nil,
        "youtubemusic":nil,
        "amazon":nil,
        "deezer":nil,
        "tidal":nil,
        "napster":nil,
        "spinrilla":nil
    ]

    override func viewDidLoad() {
        super.viewDidLoad()

        
        DatabaseManager.shared.fetchAllAlbumsFromDatabase(completion: {[weak self] albums in
            guard let strongSelf = self else {return}
            AllAlbumsInDatabaseArray = albums
            strongSelf.allAlbums = albums
            strongSelf.setUpElements()
            strongSelf.selectedAlbum(strongSelf.currentAlbum)
        })
    }
    
    deinit {
        print("📗 Edit Album view controller deinitialized.")
        AllPersonsInDatabaseArray = nil
        AllVideosInDatabaseArray = nil
        AllSongsInDatabaseArray = nil
        AllAlbumsInDatabaseArray = nil
        AllInstrumentalsInDatabaseArray = nil
        AllBeatsInDatabaseArray = nil
        currentAlbum = nil
        newImage = nil
        newPreview = nil
        NotificationCenter.default.removeObserver(self)
    }
    
    func selectedAlbum(_ album: AlbumData) {
        boolDict = [
            "spotify":nil,
            "apple":nil,
            "soundcloud":nil,
            "youtubemusic":nil,
            "amazon":nil,
            "deezer":nil,
            "tidal":nil,
            "napster":nil,
            "spinrilla":nil
        ]
        urlDict = [
            "spotify":nil,
            "apple":nil,
            "soundcloud":nil,
            "youtubemusic":nil,
            "amazon":nil,
            "deezer":nil,
            "tidal":nil,
            "napster":nil,
            "spinrilla":nil
        ]
        let a = album
        currentAlbum = album
        let b = a
        
        initialAlbum.toneDeafAppId = b.toneDeafAppId
        initialAlbum.instrumentals = b.instrumentals
        initialAlbum.dateRegisteredToApp = b.dateRegisteredToApp
        initialAlbum.timeRegisteredToApp = b.timeRegisteredToApp
        initialAlbum.tracks = b.tracks
        initialAlbum.songs = b.songs
        initialAlbum.videos = b.videos
        initialAlbum.merch = b.merch
        initialAlbum.name = b.name
        initialAlbum.mainArtist = b.mainArtist
        initialAlbum.allArtists = b.allArtists
        initialAlbum.producers = b.producers
        initialAlbum.writers = b.writers
        initialAlbum.mixEngineers = b.mixEngineers
        initialAlbum.masteringEngineers = b.masteringEngineers
        initialAlbum.recordingEngineers = b.recordingEngineers
        initialAlbum.favoritesOverall = b.favoritesOverall
        initialAlbum.manualImageURL = b.manualImageURL
        initialAlbum.manualPreviewURL = b.manualPreviewURL
        initialAlbum.numberofTracks = b.numberofTracks
        initialAlbum.spotify = b.spotify
        boolDict["spotify"] = b.spotify?.isActive
        urlDict["spotify"] = b.spotify?.url
        initialAlbum.apple = b.apple
        boolDict["apple"] = b.apple?.isActive
        urlDict["apple"] = b.apple?.url
        initialAlbum.soundcloud = b.soundcloud
        boolDict["soundcloud"] = b.soundcloud?.isActive
        urlDict["soundcloud"] = b.soundcloud?.url
        initialAlbum.youtubeMusic = b.youtubeMusic
        boolDict["youtubemusic"] = b.youtubeMusic?.isActive
        urlDict["youtubemusic"] = b.youtubeMusic?.url
        initialAlbum.amazon = b.amazon
        boolDict["amazon"] = b.amazon?.isActive
        urlDict["amazon"] = b.amazon?.url
        initialAlbum.deezer = b.deezer
        boolDict["deezer"] = b.deezer?.isActive
        urlDict["deezer"] = b.deezer?.url
        initialAlbum.spinrilla = b.spinrilla
        boolDict["spinrilla"] = b.spinrilla?.isActive
        urlDict["spinrilla"] = b.spinrilla?.url
        initialAlbum.napster = b.napster
        boolDict["napster"] = b.napster?.isActive
        urlDict["napster"] = b.napster?.url
        initialAlbum.tidal = b.tidal
        boolDict["tidal"] = b.tidal?.isActive
        urlDict["tidal"] = b.tidal?.url
        initialAlbum.officialAlbumVideo = b.officialAlbumVideo
        initialAlbum.verificationLevel = b.verificationLevel
        initialAlbum.industryCerified = b.industryCerified
        initialAlbum.deluxes = b.deluxes
        initialAlbum.isDeluxe = b.isDeluxe
        initialAlbum.isOtherVersion = b.isOtherVersion
        initialAlbum.otherVersions = b.otherVersions
        initialAlbum.isActive = b.isActive
        
        dismissKeyboard2()
    }
    
    func setUpElements() {
        changeAlbumButton.setTitleColor(Constants.Colors.redApp, for: .normal)
        view.addSubview(hiddenAlbumTextField)
        hiddenAlbumTextField.isHidden = true
        hiddenAlbumTextField.inputView = albumPickerView
        albumPickerView.delegate = self
        albumPickerView.dataSource = self
        pickerViewToolbar(textField: hiddenAlbumTextField, pickerView: albumPickerView)
        hiddenAlbumTextField.delegate = self
        
        Utilities.styleTextField(deluxeOfTextField)
        addBottomLineToText(deluxeOfTextField)
        deluxeOfTextField.delegate = self
        
        deluxeOfTextField.inputView = deluxeOfPickerView
        deluxeOfPickerView.delegate = self
        deluxeOfPickerView.dataSource = self
        pickerViewToolbar(textField: deluxeOfTextField, pickerView: deluxeOfPickerView)
        
        Utilities.styleTextField(otherVersionOfTextField)
        addBottomLineToText(otherVersionOfTextField)
        otherVersionOfTextField.delegate = self
        
        otherVersionOfTextField.inputView = otherVersionOfPickerView
        otherVersionOfPickerView.delegate = self
        otherVersionOfPickerView.dataSource = self
        pickerViewToolbar(textField: otherVersionOfTextField, pickerView: otherVersionOfPickerView)
    }
    
    func setUpPage() {
        changeAlbumButton.setTitleColor(Constants.Colors.redApp, for: .normal)
        pickerViewToolbar(textField: hiddenAlbumTextField, pickerView: albumPickerView)
        name.text = currentAlbum.name
        appIDLAbel.text = currentAlbum.toneDeafAppId
        deluxeOf = currentAlbum.isDeluxe?.standardEdition
        otherVersionsOf = currentAlbum.isOtherVersion?.standardEdition
        verificationLabel.text = String(currentAlbum.verificationLevel!)
        favoritesLabel.text = String(currentAlbum.favoritesOverall)
        dateLabel.text = currentAlbum.dateRegisteredToApp
        timeLabel.text = currentAlbum.timeRegisteredToApp
        mainArtistsTableView.delegate = self
        mainArtistsTableView.dataSource = self
        setMainArtistsArr(arr: currentAlbum.mainArtist, completion: {[weak self] _ in
            guard let strongSelf = self else {return}
            strongSelf.mainArtistsArr.sort(by: {$0.name < $1.name})
            strongSelf.mainArtistsTableView.reloadData()
            if strongSelf.mainArtistsArr.count < 6 {
                strongSelf.mainArtistsHeightConstraint.constant = CGFloat(50*(strongSelf.mainArtistsArr.count))
            } else {
                strongSelf.mainArtistsHeightConstraint.constant = CGFloat(270)
            }
        })
        allArtistsTableView.delegate = self
        allArtistsTableView.dataSource = self
        if let psa = currentAlbum.allArtists {
        setAllArtistsArr(arr: psa, completion: {[weak self] _ in
            guard let strongSelf = self else {return}
            strongSelf.allArtistsArr.sort(by: {$0.name < $1.name})
            strongSelf.allArtistsTableView.reloadData()
            if strongSelf.allArtistsArr.count < 6 {
                strongSelf.allartistsHeightConstraint.constant = CGFloat(50*(strongSelf.allArtistsArr.count))
            } else {
                strongSelf.allartistsHeightConstraint.constant = CGFloat(270)
            }
        })
        } else {
            allartistsHeightConstraint.constant = 0
        }
        producersTableView.delegate = self
        producersTableView.dataSource = self
        setProducersArr(arr: currentAlbum.producers, completion: {[weak self] _ in
            guard let strongSelf = self else {return}
            strongSelf.producersArr.sort(by: {$0.name < $1.name})
            strongSelf.producersTableView.reloadData()
            if strongSelf.producersArr.count < 6 {
                strongSelf.producersHeightConstraint.constant = CGFloat(50*(strongSelf.producersArr.count))
            } else {
                strongSelf.producersHeightConstraint.constant = CGFloat(270)
            }
        })
        writersTableView.delegate = self
        writersTableView.dataSource = self
        if let psa = currentAlbum.writers {
            setWritersArr(arr: psa, completion: {[weak self] _ in
                guard let strongSelf = self else {return}
                strongSelf.writersArr.sort(by: {$0.name < $1.name})
                strongSelf.writersTableView.reloadData()
                if strongSelf.writersArr.count < 6 {
                    strongSelf.writersHeightConstraint.constant = CGFloat(50*(strongSelf.writersArr.count))
                } else {
                    strongSelf.writersHeightConstraint.constant = CGFloat(270)
                }
            })
        } else {
            writersHeightConstraint.constant = 0
        }
        mixEngineerTableView.delegate = self
        mixEngineerTableView.dataSource = self
        
        if let psa = currentAlbum.mixEngineers {
            setMixEngineerArr(arr: psa, completion: {[weak self] _ in
                guard let strongSelf = self else {return}
                strongSelf.mixEngineerArr.sort(by: {$0.name < $1.name})
                strongSelf.mixEngineerTableView.reloadData()
                if strongSelf.mixEngineerArr.count < 6 {
                    strongSelf.mixEngineerHeightConstraint.constant = CGFloat(50*(strongSelf.mixEngineerArr.count))
                } else {
                    strongSelf.mixEngineerHeightConstraint.constant = CGFloat(270)
                }
            })
        } else {
            mixEngineerHeightConstraint.constant = 0
        }
        masteringEngineerTableView.delegate = self
        masteringEngineerTableView.dataSource = self
        if let psa = currentAlbum.masteringEngineers {
            setMasteringEngineerArr(arr: psa, completion: {[weak self] _ in
                guard let strongSelf = self else {return}
                strongSelf.masteringEngineerArr.sort(by: {$0.name < $1.name})
                strongSelf.masteringEngineerTableView.reloadData()
                if strongSelf.masteringEngineerArr.count < 6 {
                    strongSelf.masteringEngineerHeightConstraint.constant = CGFloat(50*(strongSelf.masteringEngineerArr.count))
                } else {
                    strongSelf.masteringEngineerHeightConstraint.constant = CGFloat(270)
                }
            })
        } else {
            masteringEngineerHeightConstraint.constant = 0
        }
        recordingEngineerTableView.delegate = self
        recordingEngineerTableView.dataSource = self
        if let psa = currentAlbum.recordingEngineers {
            setRecordingEngineerArr(arr: psa, completion: {[weak self] _ in
                guard let strongSelf = self else {return}
                strongSelf.recordingEngineerArr.sort(by: {$0.name < $1.name})
                strongSelf.recordingEngineerTableView.reloadData()
                if strongSelf.recordingEngineerArr.count < 6 {
                    strongSelf.recordingEngineerHeightConstraint.constant = CGFloat(50*(strongSelf.recordingEngineerArr.count))
                } else {
                    strongSelf.recordingEngineerHeightConstraint.constant = CGFloat(270)
                }
            })
        } else {
            recordingEngineerHeightConstraint.constant = 0
        }
        spotifyURL.text = currentAlbum.spotify?.url
        if currentAlbum.spotify?.url == nil || currentAlbum.spotify?.url == "" {
            removeSpotifyURLButton.isHidden = true
            spotifyStatusControl.isHidden = true
        } else {
            spotifyStatusControl.isHidden = false
            removeSpotifyURLButton.isHidden = false
        }
        appleMusicURL.text = currentAlbum.apple?.url
        if currentAlbum.apple?.url == nil || currentAlbum.apple?.url == "" {
            removeAppleMusicURLButton.isHidden = true
            appleMusicStatusControl.isHidden = true
        } else {
            appleMusicStatusControl.isHidden = false
            removeAppleMusicURLButton.isHidden = false
        }
        soundcloudURL.text = currentAlbum.soundcloud?.url
        if currentAlbum.soundcloud?.url == nil || currentAlbum.soundcloud?.url == "" {
            removeSoundcloudURLButton.isHidden = true
            soundcloudStatusControl.isHidden = true
        } else {
            soundcloudStatusControl.isHidden = false
            removeSoundcloudURLButton.isHidden = false
        }
        youtubeMusicURL.text = currentAlbum.youtubeMusic?.url
        if currentAlbum.youtubeMusic?.url == nil || currentAlbum.youtubeMusic?.url == "" {
            removeYoutubeMusicURLButton.isHidden = true
            youtubeMusicStatusControl.isHidden = true
        } else {
            youtubeMusicStatusControl.isHidden = false
            removeYoutubeMusicURLButton.isHidden = false
        }
        amazonURL.text = currentAlbum.amazon?.url
        if currentAlbum.amazon?.url == nil || currentAlbum.amazon?.url == "" {
            removeAmazonURLButton.isHidden = true
            amazonStatusControl.isHidden = true
        } else {
            amazonStatusControl.isHidden = false
            removeAmazonURLButton.isHidden = false
        }
        deezerURL.text = currentAlbum.deezer?.url
        if currentAlbum.deezer?.url == nil || currentAlbum.deezer?.url == "" {
            removeDeezerURLButton.isHidden = true
            deezerStatusControl.isHidden = true
        } else {
            deezerStatusControl.isHidden = false
            removeDeezerURLButton.isHidden = false
        }
        tidalURL.text = currentAlbum.tidal?.url
        if currentAlbum.tidal?.url == nil || currentAlbum.tidal?.url == "" {
            removeTidalURLButton.isHidden = true
            tidalStatusControl.isHidden = true
        } else {
            tidalStatusControl.isHidden = false
            removeTidalURLButton.isHidden = false
        }
        napsterURL.text = currentAlbum.napster?.url
        if currentAlbum.napster?.url == nil || currentAlbum.napster?.url == "" {
            removeNapsterURLButton.isHidden = true
            napsterStatusControl.isHidden = true
        } else {
            napsterStatusControl.isHidden = false
            removeNapsterURLButton.isHidden = false
        }
        spinrillaURL.text = currentAlbum.spinrilla?.url
        if currentAlbum.spinrilla?.url == nil || currentAlbum.spinrilla?.url == "" {
            removeSpinrillaURLButton.isHidden = true
            spinrillaStatusControl.isHidden = true
        } else {
            spinrillaStatusControl.isHidden = false
            removeSpinrillaURLButton.isHidden = false
        }
        
        if let seggo = currentAlbum.spotify?.isActive {
            if seggo {
                spotifyStatusControl.selectedSegmentIndex = 0
                spotifyStatusControl.selectedSegmentTintColor = .systemGreen
            } else {
                spotifyStatusControl.selectedSegmentTintColor = Constants.Colors.redApp
                spotifyStatusControl.selectedSegmentIndex = 1
            }
        }
        if let seggo = currentAlbum.apple?.isActive {
            if seggo {
                appleMusicStatusControl.selectedSegmentIndex = 0
                appleMusicStatusControl.selectedSegmentTintColor = .systemGreen
            } else {
                appleMusicStatusControl.selectedSegmentTintColor = Constants.Colors.redApp
                appleMusicStatusControl.selectedSegmentIndex = 1
            }
        }
        if let seggo = currentAlbum.soundcloud?.isActive {
            if seggo {
                soundcloudStatusControl.selectedSegmentIndex = 0
                soundcloudStatusControl.selectedSegmentTintColor = .systemGreen
            } else {
                soundcloudStatusControl.selectedSegmentTintColor = Constants.Colors.redApp
                soundcloudStatusControl.selectedSegmentIndex = 1
            }
        }
        if let seggo = currentAlbum.youtubeMusic?.isActive {
            if seggo {
                youtubeMusicStatusControl.selectedSegmentIndex = 0
                youtubeMusicStatusControl.selectedSegmentTintColor = .systemGreen
            } else {
                youtubeMusicStatusControl.selectedSegmentTintColor = Constants.Colors.redApp
                youtubeMusicStatusControl.selectedSegmentIndex = 1
            }
        }
        if let seggo = currentAlbum.amazon?.isActive {
            if seggo {
                amazonStatusControl.selectedSegmentIndex = 0
                amazonStatusControl.selectedSegmentTintColor = .systemGreen
            } else {
                amazonStatusControl.selectedSegmentTintColor = Constants.Colors.redApp
                amazonStatusControl.selectedSegmentIndex = 1
            }
        }
        if let seggo = currentAlbum.deezer?.isActive {
            if seggo {
                deezerStatusControl.selectedSegmentIndex = 0
                deezerStatusControl.selectedSegmentTintColor = .systemGreen
            } else {
                deezerStatusControl.selectedSegmentTintColor = Constants.Colors.redApp
                deezerStatusControl.selectedSegmentIndex = 1
            }
        }
        if let seggo = currentAlbum.tidal?.isActive {
            if seggo {
                tidalStatusControl.selectedSegmentIndex = 0
                tidalStatusControl.selectedSegmentTintColor = .systemGreen
            } else {
                tidalStatusControl.selectedSegmentTintColor = Constants.Colors.redApp
                tidalStatusControl.selectedSegmentIndex = 1
            }
        }
        if let seggo = currentAlbum.napster?.isActive {
            if seggo {
                napsterStatusControl.selectedSegmentIndex = 0
                napsterStatusControl.selectedSegmentTintColor = .systemGreen
            } else {
                napsterStatusControl.selectedSegmentTintColor = Constants.Colors.redApp
                napsterStatusControl.selectedSegmentIndex = 1
            }
        }
        if let seggo = currentAlbum.spinrilla?.isActive {
            if seggo {
                spinrillaStatusControl.selectedSegmentIndex = 0
                spinrillaStatusControl.selectedSegmentTintColor = .systemGreen
            } else {
                spinrillaStatusControl.selectedSegmentTintColor = Constants.Colors.redApp
                spinrillaStatusControl.selectedSegmentIndex = 1
            }
        }
        tracksTableView.delegate = self
        tracksTableView.dataSource = self
        let psa = currentAlbum.tracks
        setTracksArr(arr: psa, completion: {[weak self] _ in
            guard let strongSelf = self else {return}
            strongSelf.tracksTableView.reloadData()
            if strongSelf.tracksArr.count < 6 {
                strongSelf.tracksHeightConstraint.constant = CGFloat(70*(strongSelf.tracksArr.count))
            } else {
                strongSelf.tracksHeightConstraint.constant = CGFloat(370)
            }
        })
        songsTableView.delegate = self
        songsTableView.dataSource = self
        if let psa = currentAlbum.songs {
            setSongsArr(arr: psa, completion: {[weak self] _ in
                guard let strongSelf = self else {return}
                strongSelf.songsArr.sort(by: {$0.name < $1.name})
                strongSelf.songsTableView.reloadData()
                if strongSelf.songsArr.count < 6 {
                    strongSelf.songsHeightConstraint.constant = CGFloat(50*(strongSelf.songsArr.count))
                } else {
                    strongSelf.songsHeightConstraint.constant = CGFloat(270)
                }
            })
        } else {
            songsHeightConstraint.constant = 0
        }
        videosTableView.delegate = self
        videosTableView.dataSource = self
        if let psa = currentAlbum.videos {
            setVideosArr(arr: psa, completion: {[weak self] _ in
                guard let strongSelf = self else {return}
                strongSelf.videosTableView.reloadData()
                if strongSelf.videosArr.count < 6 {
                    strongSelf.videosHeightConstraint.constant = CGFloat(70*(strongSelf.videosArr.count))
                } else {
                    strongSelf.videosHeightConstraint.constant = CGFloat(370)
                }
            })
        } else {
            videosHeightConstraint.constant = 0
        }
        instrumentalsTableView.delegate = self
        instrumentalsTableView.dataSource = self
        if let psa = currentAlbum.instrumentals {
            setInstrumentalsArr(arr: psa, completion: {[weak self] _ in
                guard let strongSelf = self else {return}
                strongSelf.instrumentalsTableView.reloadData()
                if strongSelf.instrumentalsArr.count < 6 {
                    strongSelf.instrumentalsHeightConstraint.constant = CGFloat(50*(strongSelf.instrumentalsArr.count))
                } else {
                    strongSelf.instrumentalsHeightConstraint.constant = CGFloat(270)
                }
            })
        } else {
            instrumentalsHeightConstraint.constant = 0
        }
        deluxesTableView.delegate = self
        deluxesTableView.dataSource = self
        if let psa = currentAlbum.deluxes {
            setDeluxesArr(arr: psa, completion: {[weak self] _ in
                guard let strongSelf = self else {return}
                strongSelf.deluxesTableView.reloadData()
                strongSelf.deluxesArr.sort(by: {$0.name < $1.name})
                if strongSelf.deluxesArr.count < 6 {
                    strongSelf.deluxesHeightConstraint.constant = CGFloat(50*(strongSelf.deluxesArr.count))
                } else {
                    strongSelf.deluxesHeightConstraint.constant = CGFloat(270)
                }
            })
        } else {
            deluxesHeightConstraint.constant = 0
        }
        otherVersionsTableView.delegate = self
        otherVersionsTableView.dataSource = self
        if let psa = currentAlbum.otherVersions {
            setOtherVersionsArr(arr: psa, completion: {[weak self] _ in
                guard let strongSelf = self else {return}
                strongSelf.otherVersionsTableView.reloadData()
                strongSelf.songOtherVersionsArr.sort(by: {$0.name < $1.name})
                if strongSelf.songOtherVersionsArr.count < 6 {
                    strongSelf.otherVersionsHeightConstraint.constant = CGFloat(50*(strongSelf.songOtherVersionsArr.count))
                } else {
                    strongSelf.otherVersionsHeightConstraint.constant = CGFloat(270)
                }
            })
        } else {
            otherVersionsHeightConstraint.constant = 0
        }
        if currentAlbum.isDeluxe != nil {
            deluxeControl.selectedSegmentIndex = 0
            deluxeControl.selectedSegmentTintColor = .systemGreen
            deluxeOfStackView.isHidden = false
            for alb in AllAlbumsInDatabaseArray {
                if alb.toneDeafAppId == currentAlbum.isDeluxe!.standardEdition {
                    deluxeOfTextField.text = "\(alb.name) - \(alb.toneDeafAppId)"
                }
            }
        } else {
            deluxeControl.selectedSegmentTintColor = Constants.Colors.redApp
            deluxeControl.selectedSegmentIndex = 1
            deluxeOfStackView.isHidden = true
        }
        if currentAlbum.isOtherVersion != nil {
            otherVersionControl.selectedSegmentIndex = 0
            otherVersionControl.selectedSegmentTintColor = .systemGreen
            otherVersionOfStackView.isHidden = false
            for alb in AllAlbumsInDatabaseArray {
                if alb.toneDeafAppId == currentAlbum.isOtherVersion!.standardEdition {
                    otherVersionOfTextField.text = "\(alb.name) - \(alb.toneDeafAppId)"
                }
            }
        } else {
            otherVersionControl.selectedSegmentTintColor = Constants.Colors.redApp
            otherVersionControl.selectedSegmentIndex = 1
            otherVersionOfStackView.isHidden = true
        }
        if currentAlbum.industryCerified! {
            industryCertifiedControl.selectedSegmentIndex = 0
            industryCertifiedControl.selectedSegmentTintColor = .systemGreen
        } else {
            industryCertifiedControl.selectedSegmentTintColor = Constants.Colors.redApp
            industryCertifiedControl.selectedSegmentIndex = 1
        }
        if currentAlbum.isActive {
            statusControl.selectedSegmentIndex = 0
            statusControl.selectedSegmentTintColor = .systemGreen
        } else {
            statusControl.selectedSegmentTintColor = Constants.Colors.redApp
            statusControl.selectedSegmentIndex = 1
        }
        GlobalFunctions.shared.selectPreviewURL(album: currentAlbum, completion: {[weak self] previewurl in
            guard let strongSelf = self else {return}
            guard let previewurl = previewurl else {
                strongSelf.previewURL.text = "No Preview Available"
                strongSelf.previewURL.alpha = 0.5
                return
            }
            strongSelf.previewURL.alpha = 1
            strongSelf.previewURL.text = previewurl
        })
        GlobalFunctions.shared.selectImageURL(album: currentAlbum, completion: {[weak self] aimage in
            guard let strongSelf = self else {return}
            guard let imge = aimage else {
                strongSelf.image.image = UIImage(named: "tonedeaflogo")
                strongSelf.imageURL.text = "No Image"
                strongSelf.imageURL.alpha = 0.5
                return
            }
            strongSelf.imageURL.alpha = 1
            strongSelf.imageURL.text = imge
            let imageURL = URL(string: imge)!
            if let cachedImage = imageCache.object(forKey: imageURL.absoluteString as NSString) {
                strongSelf.image.image = cachedImage
            } else {
                strongSelf.image.setImage(from: imageURL, withPlaceholder: UIImage(named: "tonedeaflogo"))
            }
            
        })
        scrollToTop()
    }
    
    func setMainArtistsArr(arr: [String], completion: @escaping ((Error?) -> Void)) {
            mainArtistsArr = []
            if arr != [] {
                for person in arr {
                    getPerson(personIdFull: person, completion: {[weak self] personData in
                        guard let strongSelf = self else {return}
                        strongSelf.mainArtistsArr.append(personData)
                        completion(nil)
                    })
                }
            } else {
                mainArtistsHeightConstraint.constant = CGFloat(50*(mainArtistsArr.count))
            }
    }
    
    func setAllArtistsArr(arr: [String], completion: @escaping ((Error?) -> Void)) {
            allArtistsArr = []
            if arr != [] {
                for person in arr {
                    getPerson(personIdFull: person, completion: {[weak self] personData in
                        guard let strongSelf = self else {return}
                        strongSelf.allArtistsArr.append(personData)
                        completion(nil)
                    })
                }
            } else {
                allartistsHeightConstraint.constant = CGFloat(50*(allArtistsArr.count))
            }
    }
    
    func setProducersArr(arr: [String], completion: @escaping ((Error?) -> Void)) {
            producersArr = []
            if arr != [] {
                for person in arr {
                    getPerson(personIdFull: person, completion: {[weak self] personData in
                        guard let strongSelf = self else {return}
                        strongSelf.producersArr.append(personData)
                        completion(nil)
                    })
                }
            } else {
                producersHeightConstraint.constant = CGFloat(50*(producersArr.count))
            }
    }
    
    func setWritersArr(arr: [String], completion: @escaping ((Error?) -> Void)) {
            writersArr = []
            if arr != [] {
                for person in arr {
                    getPerson(personIdFull: person, completion: {[weak self] personData in
                        guard let strongSelf = self else {return}
                        strongSelf.writersArr.append(personData)
                        completion(nil)
                    })
                }
            } else {
                writersHeightConstraint.constant = CGFloat(50*(writersArr.count))
            }
    }
    
    func setMixEngineerArr(arr: [String], completion: @escaping ((Error?) -> Void)) {
            mixEngineerArr = []
            if arr != [] {
                for person in arr {
                    getPerson(personIdFull: person, completion: {[weak self] personData in
                        guard let strongSelf = self else {return}
                        strongSelf.mixEngineerArr.append(personData)
                        completion(nil)
                    })
                }
            } else {
                mixEngineerHeightConstraint.constant = CGFloat(50*(mixEngineerArr.count))
            }
    }
    
    func setMasteringEngineerArr(arr: [String], completion: @escaping ((Error?) -> Void)) {
            masteringEngineerArr = []
            if arr != [] {
                for person in arr {
                    getPerson(personIdFull: person, completion: {[weak self] personData in
                        guard let strongSelf = self else {return}
                        strongSelf.masteringEngineerArr.append(personData)
                        completion(nil)
                    })
                }
            } else {
                masteringEngineerHeightConstraint.constant = CGFloat(50*(masteringEngineerArr.count))
            }
    }
    
    func setRecordingEngineerArr(arr: [String], completion: @escaping ((Error?) -> Void)) {
            recordingEngineerArr = []
            if arr != [] {
                for person in arr {
                    getPerson(personIdFull: person, completion: {[weak self] personData in
                        guard let strongSelf = self else {return}
                        strongSelf.recordingEngineerArr.append(personData)
                        completion(nil)
                    })
                }
            } else {
                recordingEngineerHeightConstraint.constant = CGFloat(50*(recordingEngineerArr.count))
            }
    }
    
    func setTracksArr(arr: [String:String], completion: @escaping ((Error?) -> Void)) {
        tracksArr = [:]
        if arr.count != 0 {
                for track in arr {
                    let fullId = track.value
                    let word = fullId.split(separator: "Æ")
                    let id = word[0]
                    switch id.count {
                    case 10:
                        getSong(songIdFull: track.value, completion: {[weak self] songData in
                            guard let strongSelf = self else {return}
                            strongSelf.tracksArr[track.key] = songData
                            completion(nil)
                        })
                    case 12:
                        getInstrumental(instrumentalIdFull: track.value, completion: {[weak self] instrumentalData in
                            guard let strongSelf = self else {return}
                            strongSelf.tracksArr[track.key] = instrumentalData
                            completion(nil)
                        })
                    default:
                        break
                    }
                }
            } else {
                tracksHeightConstraint.constant = CGFloat(70*(tracksArr.count))
            }
    }
    
    func setSongsArr(arr: [String], completion: @escaping ((Error?) -> Void)) {
            songsArr = []
            if arr != [] {
                
                for song in arr {
                    getSong(songIdFull: song, completion: {[weak self] songData in
                        
                        guard let strongSelf = self else {return}
                        strongSelf.songsArr.append(songData)
                        completion(nil)
                    })
                }
            } else {
                songsHeightConstraint.constant = CGFloat(50*(songsArr.count))
            }
    }
    
    func setVideosArr(arr: [String], completion: @escaping ((Error?) -> Void)) {
            videosArr = []
            if arr != [] {
                
                for video in arr {
                    getVideo(videoIdFull: video, completion: {[weak self] videoData in
                        
                        guard let strongSelf = self else {return}
                        strongSelf.videosArr.append(videoData)
                        completion(nil)
                    })
                }
            } else {
                videosHeightConstraint.constant = CGFloat(50*(videosArr.count))
            }
    }
    
    func setInstrumentalsArr(arr: [String], completion: @escaping ((Error?) -> Void)) {
            instrumentalsArr = []
            if arr != [] {
                for instrumental in arr {
                    getInstrumental(instrumentalIdFull: instrumental, completion: {[weak self] instrumentalData in
                        guard let strongSelf = self else {return}
                        strongSelf.instrumentalsArr.append(instrumentalData)
                        completion(nil)
                    })
                }
            } else {
                instrumentalsHeightConstraint.constant = CGFloat(50*(instrumentalsArr.count))
            }
    }
    
    func setDeluxesArr(arr: [String], completion: @escaping ((Error?) -> Void)) {
            deluxesArr = []
            if arr != [] {
                for song in arr {
                    getAlbum(albumIdFull: song, completion: {[weak self] songData in
                        guard let strongSelf = self else {return}
                        strongSelf.deluxesArr.append(songData)
                        completion(nil)
                    })
                }
            } else {
                deluxesHeightConstraint.constant = CGFloat(50*(deluxesArr.count))
            }
    }
    
    func setOtherVersionsArr(arr: [String], completion: @escaping ((Error?) -> Void)) {
            songOtherVersionsArr = []
            if arr != [] {
                for song in arr {
                    getAlbum(albumIdFull: song, completion: {[weak self] songData in
                        guard let strongSelf = self else {return}
                        strongSelf.songOtherVersionsArr.append(songData)
                        completion(nil)
                    })
                }
            } else {
                otherVersionsHeightConstraint.constant = CGFloat(50*(songOtherVersionsArr.count))
            }
    }
    
    @IBAction func newAlbumTapped(_ sender: Any) {
        arr = "album"
        prevPage = "editAlbumAll"
        performSegue(withIdentifier: "editAlbumToTonesPick", sender: nil)
    }
    
    @IBAction func changeImageTapped(_ sender: Any) {
        let actionSheet = UIAlertController(title: "Change Image",
                                            message: "",
                                            preferredStyle: .alert)
        actionSheet.addAction(UIAlertAction(title: "Select Image Manually",
                                            style: .default,
                                            handler: { [weak self] _ in
            guard let strongSelf = self else {return}
            strongSelf.presentPhotoActionSheet()
        }))
        actionSheet.addAction(UIAlertAction(title: "Use Album Default",
                                            style: .default,
                                            handler: { [weak self] _ in
            guard let strongSelf = self else {return}
            strongSelf.currentAlbum.manualImageURL = nil
            strongSelf.newImage = nil
            strongSelf.imageURL.textColor = .green
            strongSelf.setUpPage()
            
            actionSheet.dismiss(animated: true)
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        actionSheet.view.tintColor = Constants.Colors.redApp
        present(actionSheet, animated: true)
    }
    
    @IBAction func changeNameTapped(_ sender: Any) {
        let alertC = UIAlertController(title: "Change Name",
                                                message: "Please type in a name.",
                                                preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Change", style: .default, handler: {[weak self] _ in
            guard let strongSelf = self else {return}
            let field = alertC.textFields![0]
            if field.text != "" {
                guard let name = field.text else {return}
                strongSelf.name.text = name
                strongSelf.name.textColor = .green
                strongSelf.currentAlbum.name = name
                alertC.dismiss(animated: true, completion: nil)
            } else {
                alertC.dismiss(animated: true, completion: nil)
            }
        })
        alertC.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alertC.addAction(okAction)
        alertC.addTextField()
        alertC.textFields![0].text = currentAlbum.name
        alertC.view.tintColor = Constants.Colors.redApp
        self.present(alertC, animated: true)
    }
    
    @IBAction func changePreviewTapped(_ sender: Any) {
        let actionSheet = UIAlertController(title: "Change Preview Audio",
                                            message: "",
                                            preferredStyle: .alert)
        actionSheet.addAction(UIAlertAction(title: "Select Audio Manually",
                                            style: .default,
                                            handler: { [weak self] _ in
            guard let strongSelf = self else {return}
            strongSelf.openFiles()
        }))
        actionSheet.addAction(UIAlertAction(title: "Use Song Default",
                                            style: .default,
                                            handler: { [weak self] _ in
            guard let strongSelf = self else {return}
            strongSelf.currentAlbum.manualPreviewURL = nil
            strongSelf.newPreview = nil
            strongSelf.previewURL.textColor = .green
            strongSelf.setUpPage()
            
            actionSheet.dismiss(animated: true)
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        actionSheet.view.tintColor = Constants.Colors.redApp
        present(actionSheet, animated: true)
    }
    
    @IBAction func addMainArtistTapped(_ sender: Any) {
        arr = "person"
        prevPage = "editAlbum"
        tbsender = "mainartist"
        performSegue(withIdentifier: "editAlbumToTonesPick", sender: nil)
    }
    
    @IBAction func addAllArtistTapped(_ sender: Any) {
        arr = "person"
        prevPage = "editAlbum"
        tbsender = "allartist"
        performSegue(withIdentifier: "editAlbumToTonesPick", sender: nil)
    }
    
    @IBAction func addProducerTapped(_ sender: Any) {
        arr = "person"
        prevPage = "editAlbum"
        tbsender = "producer"
        performSegue(withIdentifier: "editAlbumToTonesPick", sender: nil)
    }
    
    @IBAction func addWriterTapped(_ sender: Any) {
        arr = "person"
        prevPage = "editAlbum"
        tbsender = "writer"
        performSegue(withIdentifier: "editAlbumToTonesPick", sender: nil)
    }
    
    @IBAction func addMixEngineerTapped(_ sender: Any) {
        arr = "person"
        prevPage = "editAlbum"
        tbsender = "mixEngineer"
        performSegue(withIdentifier: "editAlbumToTonesPick", sender: nil)
    }
    
    @IBAction func addMasteringEngineerTapped(_ sender: Any) {
        arr = "person"
        prevPage = "editAlbum"
        tbsender = "masteringEngineer"
        performSegue(withIdentifier: "editAlbumToTonesPick", sender: nil)
    }
    
    @IBAction func addRecordingEngineerTapped(_ sender: Any) {
        arr = "person"
        prevPage = "editAlbum"
        tbsender = "recordingEngineer"
        performSegue(withIdentifier: "editAlbumToTonesPick", sender: nil)
    }
    
    func personAdded(_ person: PersonData) {
        lightImpactGenerator.impactOccurred(intensity: 0.75)
        switch tbsender {
        case "mainartist":
            if !mainArtistsArr.contains(person) {
                mainArtistsArr.append(person)
            } else {
                let dex = mainArtistsArr.firstIndex(of: person)
                mainArtistsArr[dex!] = person
            }
            
            if currentAlbum.mainArtist == nil {
                currentAlbum.mainArtist = ["\(person.toneDeafAppId)"]
            } else {
                if !currentAlbum.mainArtist.contains(person.toneDeafAppId) {
                    currentAlbum.mainArtist.append("\(person.toneDeafAppId)")
                    currentAlbum.mainArtist.sort()
                }
            }
            DispatchQueue.main.async {[weak self]  in
                guard let strongSelf = self else {return}
                strongSelf.mainArtistsArr.sort(by: {$0.name < $1.name})
                strongSelf.mainArtistsTableView.reloadData()
                if strongSelf.mainArtistsArr.count < 6 {
                    strongSelf.mainArtistsHeightConstraint.constant = CGFloat(50*(strongSelf.mainArtistsArr.count))
                } else {
                    strongSelf.mainArtistsHeightConstraint.constant = CGFloat(270)
                }
            }
        case "allartist":
            if !allArtistsArr.contains(person) {
                allArtistsArr.append(person)
            } else {
                let dex = allArtistsArr.firstIndex(of: person)
                allArtistsArr[dex!] = person
            }
            
            if currentAlbum.allArtists == nil {
                currentAlbum.allArtists = ["\(person.toneDeafAppId)"]
            } else {
                if var arr = currentAlbum.allArtists {
                    if !arr.contains(person.toneDeafAppId) {
                        arr.append("\(person.toneDeafAppId)")
                        arr.sort()
                        currentAlbum.allArtists = arr
                    }
                } else {
                    var arr:[String] = []
                    arr.append("\(person.toneDeafAppId)")
                    arr.sort()
                    currentAlbum.allArtists = arr
                }
            }
            DispatchQueue.main.async {[weak self]  in
                guard let strongSelf = self else {return}
                strongSelf.allArtistsArr.sort(by: {$0.name < $1.name})
                strongSelf.allArtistsTableView.reloadData()
                if strongSelf.allArtistsArr.count < 6 {
                    strongSelf.allartistsHeightConstraint.constant = CGFloat(50*(strongSelf.allArtistsArr.count))
                } else {
                    strongSelf.allartistsHeightConstraint.constant = CGFloat(270)
                }
            }
        case "producer":
            if !producersArr.contains(person) {
                producersArr.append(person)
            } else {
                let dex = producersArr.firstIndex(of: person)
                producersArr[dex!] = person
            }
            
            if currentAlbum.producers == nil {
                currentAlbum.producers = ["\(person.toneDeafAppId)"]
            } else {
                if !currentAlbum.producers.contains(person.toneDeafAppId) {
                    currentAlbum.producers.append("\(person.toneDeafAppId)")
                    currentAlbum.producers.sort()
                }
            }
            DispatchQueue.main.async {[weak self]  in
                guard let strongSelf = self else {return}
                strongSelf.producersArr.sort(by: {$0.name < $1.name})
                strongSelf.producersTableView.reloadData()
                if strongSelf.producersArr.count < 6 {
                    strongSelf.producersHeightConstraint.constant = CGFloat(50*(strongSelf.producersArr.count))
                } else {
                    strongSelf.producersHeightConstraint.constant = CGFloat(270)
                }
            }
        case "writer":
            if !writersArr.contains(person) {
                writersArr.append(person)
            } else {
                let dex = writersArr.firstIndex(of: person)
                writersArr[dex!] = person
            }
            
            if currentAlbum.writers == nil {
                currentAlbum.writers = ["\(person.toneDeafAppId)"]
            } else {
                if var arr = currentAlbum.writers {
                    if !arr.contains(person.toneDeafAppId) {
                        arr.append("\(person.toneDeafAppId)")
                        arr.sort()
                        currentAlbum.writers = arr
                    }
                } else {
                    var arr:[String] = []
                    arr.append("\(person.toneDeafAppId)")
                    arr.sort()
                    currentAlbum.writers = arr
                }
            }
            DispatchQueue.main.async {[weak self]  in
                guard let strongSelf = self else {return}
                strongSelf.writersArr.sort(by: {$0.name < $1.name})
                strongSelf.writersTableView.reloadData()
                if strongSelf.writersArr.count < 6 {
                    strongSelf.writersHeightConstraint.constant = CGFloat(50*(strongSelf.writersArr.count))
                } else {
                    strongSelf.writersHeightConstraint.constant = CGFloat(270)
                }
            }
        case "mixEngineer":
            if !mixEngineerArr.contains(person) {
                mixEngineerArr.append(person)
            } else {
                let dex = mixEngineerArr.firstIndex(of: person)
                mixEngineerArr[dex!] = person
            }
            
            if currentAlbum.mixEngineers == nil {
                currentAlbum.mixEngineers = ["\(person.toneDeafAppId)"]
            } else {
                if var arr = currentAlbum.mixEngineers {
                    if !arr.contains(person.toneDeafAppId) {
                        arr.append("\(person.toneDeafAppId)")
                        arr.sort()
                        currentAlbum.mixEngineers = arr
                    }
                } else {
                    var arr:[String] = []
                    arr.append("\(person.toneDeafAppId)")
                    arr.sort()
                    currentAlbum.mixEngineers = arr
                }
            }
            DispatchQueue.main.async {[weak self]  in
                guard let strongSelf = self else {return}
                strongSelf.mixEngineerArr.sort(by: {$0.name < $1.name})
                strongSelf.mixEngineerTableView.reloadData()
                if strongSelf.mixEngineerArr.count < 6 {
                    strongSelf.mixEngineerHeightConstraint.constant = CGFloat(50*(strongSelf.mixEngineerArr.count))
                } else {
                    strongSelf.mixEngineerHeightConstraint.constant = CGFloat(270)
                }
            }
        case "masteringEngineer":
            if !masteringEngineerArr.contains(person) {
                masteringEngineerArr.append(person)
            } else {
                let dex = masteringEngineerArr.firstIndex(of: person)
                masteringEngineerArr[dex!] = person
            }
            
            if currentAlbum.masteringEngineers == nil {
                currentAlbum.masteringEngineers = ["\(person.toneDeafAppId)"]
            } else {
                if var arr = currentAlbum.masteringEngineers {
                    if !arr.contains(person.toneDeafAppId) {
                        arr.append("\(person.toneDeafAppId)")
                        arr.sort()
                        currentAlbum.masteringEngineers = arr
                    }
                } else {
                    var arr:[String] = []
                    arr.append("\(person.toneDeafAppId)")
                    arr.sort()
                    currentAlbum.masteringEngineers = arr
                }
            }
            DispatchQueue.main.async {[weak self]  in
                guard let strongSelf = self else {return}
                strongSelf.masteringEngineerArr.sort(by: {$0.name < $1.name})
                strongSelf.masteringEngineerTableView.reloadData()
                if strongSelf.masteringEngineerArr.count < 6 {
                    strongSelf.masteringEngineerHeightConstraint.constant = CGFloat(50*(strongSelf.masteringEngineerArr.count))
                } else {
                    strongSelf.masteringEngineerHeightConstraint.constant = CGFloat(270)
                }
            }
        case "recordingEngineer":
            if !recordingEngineerArr.contains(person) {
                recordingEngineerArr.append(person)
            } else {
                let dex = recordingEngineerArr.firstIndex(of: person)
                recordingEngineerArr[dex!] = person
            }
            
            if currentAlbum.recordingEngineers == nil {
                currentAlbum.recordingEngineers = ["\(person.toneDeafAppId)"]
            } else {
                if var arr = currentAlbum.recordingEngineers {
                    if !arr.contains(person.toneDeafAppId) {
                        arr.append("\(person.toneDeafAppId)")
                        arr.sort()
                        currentAlbum.recordingEngineers = arr
                    }
                } else {
                    var arr:[String] = []
                    arr.append("\(person.toneDeafAppId)")
                    arr.sort()
                    currentAlbum.recordingEngineers = arr
                }
            }
            DispatchQueue.main.async {[weak self]  in
                guard let strongSelf = self else {return}
                strongSelf.recordingEngineerArr.sort(by: {$0.name < $1.name})
                strongSelf.recordingEngineerTableView.reloadData()
                if strongSelf.recordingEngineerArr.count < 6 {
                    strongSelf.recordingEngineerHeightConstraint.constant = CGFloat(50*(strongSelf.recordingEngineerArr.count))
                } else {
                    strongSelf.recordingEngineerHeightConstraint.constant = CGFloat(270)
                }
            }
        default:
            break
        }
    }
    
    @IBAction func changeSpotifyURLTapped(_ sender: Any) {
        let alertC = UIAlertController(title: "Change Spotify URL",
                                                message: "Please type in a Spotify URL.",
                                                preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Change", style: .default, handler: {[weak self] _ in
            guard let strongSelf = self else {return}
            let field = alertC.textFields![0]
            if field.text != strongSelf.currentAlbum.spotify?.url {
                strongSelf.spotifyStatusControl.selectedSegmentIndex = 1
                strongSelf.spotifyStatusControl.selectedSegmentTintColor = Constants.Colors.redApp
                strongSelf.currentAlbum.spotify?.isActive = false
                strongSelf.spotifyURL.textColor = .green
            }
            if field.text != "" {
                guard let name = field.text else {return}
                strongSelf.spotifyURL.text = name
                if let obj = strongSelf.currentAlbum.spotify {
                    obj.url = name
                } else {
                    strongSelf.currentAlbum.spotify = SpotifyAlbumData(toneDeafAppId: "", name: "", artist: [], spotifyId: "", url: name, uri: "", imageURL: "", upc: "", trackNumberTotal: 0, dateReleasedSpotify: "", dateIA: "", timeIA: "", isActive: false)
                }
                strongSelf.removeSpotifyURLButton.isHidden = false
                strongSelf.spotifyStatusControl.isHidden = false
                alertC.dismiss(animated: true, completion: nil)
            } else {
                alertC.dismiss(animated: true, completion: nil)
            }
        })
        alertC.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alertC.addAction(okAction)
        alertC.addTextField()
        alertC.textFields![0].text = currentAlbum.spotify?.url
        alertC.view.tintColor = Constants.Colors.redApp
        self.present(alertC, animated: true)
    }
    
    @IBAction func removeSpotifyURLTapped(_ sender: Any) {
        let alertC = UIAlertController(title: "Remove Spotify URL",
                                       message: "Are You Sure?",
                                       preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Yes", style: .destructive, handler: {[weak self] _ in
            guard let strongSelf = self else {return}
            strongSelf.spotifyURL.text = ""
            strongSelf.spotifyURL.textColor = .green
            strongSelf.currentAlbum.spotify = nil
            strongSelf.removeSpotifyURLButton.isHidden = true
            strongSelf.spotifyStatusControl.isHidden = true
            alertC.dismiss(animated: true, completion: nil)
            
        })
        alertC.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alertC.addAction(okAction)
        alertC.view.tintColor = Constants.Colors.redApp
        self.present(alertC, animated: true)
    }
    
    @IBAction func changeAppleMusicURLTapped(_ sender: Any) {
        let alertC = UIAlertController(title: "Change Apple Music URL",
                                                message: "Please type in a Apple Music URL.",
                                                preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Change", style: .default, handler: {[weak self] _ in
            guard let strongSelf = self else {return}
            let field = alertC.textFields![0]
            if field.text != strongSelf.currentAlbum.apple?.url {
                strongSelf.appleMusicStatusControl.selectedSegmentIndex = 1
                strongSelf.appleMusicStatusControl.selectedSegmentTintColor = Constants.Colors.redApp
                strongSelf.currentAlbum.apple?.isActive = false
                strongSelf.appleMusicURL.textColor = .green
            }
            if field.text != "" {
                guard let name = field.text else {return}
                strongSelf.appleMusicURL.text = name
                if let obj = strongSelf.currentAlbum.apple {
                    obj.url = name
                } else {
                    strongSelf.currentAlbum.apple = AppleAlbumData(name: "", toneDeafAppId: "", dateReleasedApple: "", dateIA: "", timeIA: "", imageURL: "", trackCount: 0, artist: "", url: name, appleId: "", isActive: false)
                }
                strongSelf.removeAppleMusicURLButton.isHidden = false
                strongSelf.appleMusicStatusControl.isHidden = false
                alertC.dismiss(animated: true, completion: nil)
            } else {
                alertC.dismiss(animated: true, completion: nil)
            }
        })
        alertC.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alertC.addAction(okAction)
        alertC.addTextField()
        alertC.textFields![0].text = currentAlbum.apple?.url
        alertC.view.tintColor = Constants.Colors.redApp
        self.present(alertC, animated: true)
    }
    
    @IBAction func removeAppleMusicURLTapped(_ sender: Any) {
        let alertC = UIAlertController(title: "Remove Apple Music URL",
                                       message: "Are You Sure?",
                                       preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Yes", style: .destructive, handler: {[weak self] _ in
            guard let strongSelf = self else {return}
            strongSelf.appleMusicURL.text = ""
            strongSelf.appleMusicURL.textColor = .green
            strongSelf.currentAlbum.apple = nil
            strongSelf.removeAppleMusicURLButton.isHidden = true
            strongSelf.appleMusicStatusControl.isHidden = true
            alertC.dismiss(animated: true, completion: nil)
            
        })
        alertC.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alertC.addAction(okAction)
        alertC.view.tintColor = Constants.Colors.redApp
        self.present(alertC, animated: true)
    }
    
    @IBAction func changeSoundcloudURLTapped(_ sender: Any) {
        let alertC = UIAlertController(title: "Change Soundcloud URL",
                                                message: "Please type in a Soundcloud URL.",
                                                preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Change", style: .default, handler: {[weak self] _ in
            guard let strongSelf = self else {return}
            let field = alertC.textFields![0]
            if field.text != strongSelf.currentAlbum.soundcloud?.url {
                strongSelf.soundcloudStatusControl.selectedSegmentIndex = 1
                strongSelf.soundcloudStatusControl.selectedSegmentTintColor = Constants.Colors.redApp
                strongSelf.currentAlbum.soundcloud?.isActive = false
                strongSelf.soundcloudURL.textColor = .green
            }
            if field.text != "" {
                guard let name = field.text else {return}
                strongSelf.soundcloudURL.text = name
                if let obj = strongSelf.currentAlbum.soundcloud {
                    obj.url = name
                } else {
                    strongSelf.currentAlbum.soundcloud = SoundcloudAlbumData(url: name, imageurl: nil, releaseDate: nil, isActive: false)
                }
                strongSelf.removeSoundcloudURLButton.isHidden = false
                strongSelf.soundcloudStatusControl.isHidden = false
                alertC.dismiss(animated: true, completion: nil)
            } else {
                alertC.dismiss(animated: true, completion: nil)
            }
        })
        alertC.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alertC.addAction(okAction)
        alertC.addTextField()
        alertC.textFields![0].text = currentAlbum.soundcloud?.url
        alertC.view.tintColor = Constants.Colors.redApp
        self.present(alertC, animated: true)
    }
    
    @IBAction func removeSoundcloudURLTapped(_ sender: Any) {
        let alertC = UIAlertController(title: "Remove Soundcloud URL",
                                       message: "Are You Sure?",
                                       preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Yes", style: .destructive, handler: {[weak self] _ in
            guard let strongSelf = self else {return}
            strongSelf.soundcloudURL.text = ""
            strongSelf.soundcloudURL.textColor = .green
            strongSelf.currentAlbum.soundcloud = nil
            strongSelf.removeSoundcloudURLButton.isHidden = true
            strongSelf.soundcloudStatusControl.isHidden = true
            alertC.dismiss(animated: true, completion: nil)
            
        })
        alertC.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alertC.addAction(okAction)
        alertC.view.tintColor = Constants.Colors.redApp
        self.present(alertC, animated: true)
    }
    
    @IBAction func changeYoutubeMusicURLTapped(_ sender: Any) {
        let alertC = UIAlertController(title: "Change Youtube Music URL",
                                                message: "Please type in a Youtube Music URL.",
                                                preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Change", style: .default, handler: {[weak self] _ in
            guard let strongSelf = self else {return}
            let field = alertC.textFields![0]
            if field.text != strongSelf.currentAlbum.youtubeMusic?.url {
                strongSelf.youtubeMusicStatusControl.selectedSegmentIndex = 1
                strongSelf.youtubeMusicStatusControl.selectedSegmentTintColor = Constants.Colors.redApp
                strongSelf.currentAlbum.youtubeMusic?.isActive = false
                strongSelf.youtubeMusicURL.textColor = .green
            }
            if field.text != "" {
                guard let name = field.text else {return}
                strongSelf.youtubeMusicURL.text = name
                if let obj = strongSelf.currentAlbum.youtubeMusic {
                    obj.url = name
                } else {
                    strongSelf.currentAlbum.youtubeMusic = YoutubeMusicAlbumData(url: name, imageurl: nil, isActive: false)
                }
                strongSelf.removeYoutubeMusicURLButton.isHidden = false
                strongSelf.youtubeMusicStatusControl.isHidden = false
                alertC.dismiss(animated: true, completion: nil)
            } else {
                alertC.dismiss(animated: true, completion: nil)
            }
        })
        alertC.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alertC.addAction(okAction)
        alertC.addTextField()
        alertC.textFields![0].text = currentAlbum.youtubeMusic?.url
        alertC.view.tintColor = Constants.Colors.redApp
        self.present(alertC, animated: true)
    }
    
    @IBAction func removeYoutubeMusicURLTapped(_ sender: Any) {
        let alertC = UIAlertController(title: "Remove Youtube Music URL",
                                       message: "Are You Sure?",
                                       preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Yes", style: .destructive, handler: {[weak self] _ in
            guard let strongSelf = self else {return}
            strongSelf.youtubeMusicURL.text = ""
            strongSelf.youtubeMusicURL.textColor = .green
            strongSelf.currentAlbum.youtubeMusic = nil
            strongSelf.removeYoutubeMusicURLButton.isHidden = true
            strongSelf.youtubeMusicStatusControl.isHidden = true
            alertC.dismiss(animated: true, completion: nil)
            
        })
        alertC.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alertC.addAction(okAction)
        alertC.view.tintColor = Constants.Colors.redApp
        self.present(alertC, animated: true)
    }
    
    @IBAction func changeAmazonURLTapped(_ sender: Any) {
        let alertC = UIAlertController(title: "Change Amazon Music URL",
                                                message: "Please type in a Amazon Music URL.",
                                                preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Change", style: .default, handler: {[weak self] _ in
            guard let strongSelf = self else {return}
            let field = alertC.textFields![0]
            if field.text != strongSelf.currentAlbum.amazon?.url {
                strongSelf.amazonStatusControl.selectedSegmentIndex = 1
                strongSelf.amazonStatusControl.selectedSegmentTintColor = Constants.Colors.redApp
                strongSelf.currentAlbum.amazon?.isActive = false
                strongSelf.amazonURL.textColor = .green
            }
            if field.text != "" {
                guard let name = field.text else {return}
                strongSelf.amazonURL.text = name
                if let obj = strongSelf.currentAlbum.amazon {
                    obj.url = name
                } else {
                    strongSelf.currentAlbum.amazon = AmazonAlbumData(url: name, imageurl: nil, isActive: false)
                }
                strongSelf.removeAmazonURLButton.isHidden = false
                strongSelf.amazonStatusControl.isHidden = false
                alertC.dismiss(animated: true, completion: nil)
            } else {
                alertC.dismiss(animated: true, completion: nil)
            }
        })
        alertC.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alertC.addAction(okAction)
        alertC.addTextField()
        alertC.textFields![0].text = currentAlbum.amazon?.url
        alertC.view.tintColor = Constants.Colors.redApp
        self.present(alertC, animated: true)
    }
    
    @IBAction func removeAmazonMusicURLTapped(_ sender: Any) {
        let alertC = UIAlertController(title: "Remove Amazon Music URL",
                                       message: "Are You Sure?",
                                       preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Yes", style: .destructive, handler: {[weak self] _ in
            guard let strongSelf = self else {return}
            strongSelf.amazonURL.text = ""
            strongSelf.amazonURL.textColor = .green
            strongSelf.currentAlbum.amazon = nil
            strongSelf.removeAmazonURLButton.isHidden = true
            strongSelf.amazonStatusControl.isHidden = true
            alertC.dismiss(animated: true, completion: nil)
            
        })
        alertC.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alertC.addAction(okAction)
        alertC.view.tintColor = Constants.Colors.redApp
        self.present(alertC, animated: true)
    }
    
    @IBAction func changeDeezerURLTapped(_ sender: Any) {
        let alertC = UIAlertController(title: "Change Deezer URL",
                                                message: "Please type in a Deezer URL.",
                                                preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Change", style: .default, handler: {[weak self] _ in
            guard let strongSelf = self else {return}
            let field = alertC.textFields![0]
            if field.text != strongSelf.currentAlbum.deezer?.url {
                strongSelf.deezerStatusControl.selectedSegmentIndex = 1
                strongSelf.deezerStatusControl.selectedSegmentTintColor = Constants.Colors.redApp
                strongSelf.currentAlbum.deezer?.isActive = false
                strongSelf.deezerURL.textColor = .green
            }
            if field.text != "" {
                guard let name = field.text else {return}
                strongSelf.deezerURL.text = name
                if let obj = strongSelf.currentAlbum.deezer {
                    obj.url = name
                } else {
                    strongSelf.currentAlbum.deezer = DeezerAlbumData(url: name, imageurl: nil, deezerDate: "", artist: [], duration: "", upc: "", name: "", timeIA: "", dateIA: "", deezerID: 0, isActive: false)
                }
                strongSelf.removeDeezerURLButton.isHidden = false
                strongSelf.deezerStatusControl.isHidden = false
                alertC.dismiss(animated: true, completion: nil)
            } else {
                alertC.dismiss(animated: true, completion: nil)
            }
        })
        alertC.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alertC.addAction(okAction)
        alertC.addTextField()
        alertC.textFields![0].text = currentAlbum.deezer?.url
        alertC.view.tintColor = Constants.Colors.redApp
        self.present(alertC, animated: true)
    }
    
    @IBAction func removeDeezerURLTapped(_ sender: Any) {
        let alertC = UIAlertController(title: "Remove Deezer URL",
                                       message: "Are You Sure?",
                                       preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Yes", style: .destructive, handler: {[weak self] _ in
            guard let strongSelf = self else {return}
            strongSelf.deezerURL.text = ""
            strongSelf.deezerURL.textColor = .green
            strongSelf.currentAlbum.deezer = nil
            strongSelf.removeDeezerURLButton.isHidden = true
            strongSelf.deezerStatusControl.isHidden = true
            alertC.dismiss(animated: true, completion: nil)
            
        })
        alertC.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alertC.addAction(okAction)
        alertC.view.tintColor = Constants.Colors.redApp
        self.present(alertC, animated: true)
    }
    
    @IBAction func changeTidalURLTapped(_ sender: Any) {
        let alertC = UIAlertController(title: "Change Tidal URL",
                                                message: "Please type in a Tidal URL.",
                                                preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Change", style: .default, handler: {[weak self] _ in
            guard let strongSelf = self else {return}
            let field = alertC.textFields![0]
            if field.text != strongSelf.currentAlbum.tidal?.url {
                strongSelf.tidalStatusControl.selectedSegmentIndex = 1
                strongSelf.tidalStatusControl.selectedSegmentTintColor = Constants.Colors.redApp
                strongSelf.currentAlbum.tidal?.isActive = false
                strongSelf.tidalURL.textColor = .green
            }
            if field.text != "" {
                guard let name = field.text else {return}
                strongSelf.tidalURL.text = name
                if let obj = strongSelf.currentAlbum.tidal {
                    obj.url = name
                } else {
                    strongSelf.currentAlbum.tidal = TidalAlbumData(url: name, imageurl: nil, isActive: false)
                }
                strongSelf.removeTidalURLButton.isHidden = false
                strongSelf.tidalStatusControl.isHidden = false
                alertC.dismiss(animated: true, completion: nil)
            } else {
                alertC.dismiss(animated: true, completion: nil)
            }
        })
        alertC.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alertC.addAction(okAction)
        alertC.addTextField()
        alertC.textFields![0].text = currentAlbum.tidal?.url
        alertC.view.tintColor = Constants.Colors.redApp
        self.present(alertC, animated: true)
    }
    
    @IBAction func removeTidalURLTapped(_ sender: Any) {
        let alertC = UIAlertController(title: "Remove Tidal URL",
                                       message: "Are You Sure?",
                                       preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Yes", style: .destructive, handler: {[weak self] _ in
            guard let strongSelf = self else {return}
            strongSelf.tidalURL.text = ""
            strongSelf.tidalURL.textColor = .green
            strongSelf.currentAlbum.tidal = nil
            strongSelf.removeTidalURLButton.isHidden = true
            strongSelf.tidalStatusControl.isHidden = true
            alertC.dismiss(animated: true, completion: nil)
            
        })
        alertC.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alertC.addAction(okAction)
        alertC.view.tintColor = Constants.Colors.redApp
        self.present(alertC, animated: true)
    }
    
    @IBAction func changeNapsterURLTapped(_ sender: Any) {
        let alertC = UIAlertController(title: "Change Napster URL",
                                                message: "Please type in a Napster URL.",
                                                preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Change", style: .default, handler: {[weak self] _ in
            guard let strongSelf = self else {return}
            let field = alertC.textFields![0]
            if field.text != strongSelf.currentAlbum.napster?.url {
                strongSelf.napsterStatusControl.selectedSegmentIndex = 1
                strongSelf.napsterStatusControl.selectedSegmentTintColor = Constants.Colors.redApp
                strongSelf.currentAlbum.napster?.isActive = false
                strongSelf.napsterURL.textColor = .green
            }
            if field.text != "" {
                guard let name = field.text else {return}
                strongSelf.napsterURL.text = name
                if let obj = strongSelf.currentAlbum.napster {
                    obj.url = name
                } else {
                    strongSelf.currentAlbum.napster = NapsterAlbumData(url: "", imageurl: nil, isActive: false)
                }
                strongSelf.removeNapsterURLButton.isHidden = false
                strongSelf.napsterStatusControl.isHidden = false
                alertC.dismiss(animated: true, completion: nil)
            } else {
                alertC.dismiss(animated: true, completion: nil)
            }
        })
        alertC.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alertC.addAction(okAction)
        alertC.addTextField()
        alertC.textFields![0].text = currentAlbum.napster?.url
        alertC.view.tintColor = Constants.Colors.redApp
        self.present(alertC, animated: true)
    }
    
    @IBAction func removeNapsterURLTapped(_ sender: Any) {
        let alertC = UIAlertController(title: "Remove Napster URL",
                                       message: "Are You Sure?",
                                       preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Yes", style: .destructive, handler: {[weak self] _ in
            guard let strongSelf = self else {return}
            strongSelf.napsterURL.text = ""
            strongSelf.napsterURL.textColor = .green
            strongSelf.currentAlbum.napster = nil
            strongSelf.removeNapsterURLButton.isHidden = true
            strongSelf.napsterStatusControl.isHidden = true
            alertC.dismiss(animated: true, completion: nil)
            
        })
        alertC.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alertC.addAction(okAction)
        alertC.view.tintColor = Constants.Colors.redApp
        self.present(alertC, animated: true)
    }

    @IBAction func changeSpinrillaURLTapped(_ sender: Any) {
        let alertC = UIAlertController(title: "Change Spinrilla URL",
                                                message: "Please type in a Spinrilla URL.",
                                                preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Change", style: .default, handler: {[weak self] _ in
            guard let strongSelf = self else {return}
            let field = alertC.textFields![0]
            if field.text != strongSelf.currentAlbum.spinrilla?.url {
                strongSelf.spinrillaStatusControl.selectedSegmentIndex = 1
                strongSelf.spinrillaStatusControl.selectedSegmentTintColor = Constants.Colors.redApp
                strongSelf.currentAlbum.spinrilla?.isActive = false
                strongSelf.spinrillaURL.textColor = .green
            }
            if field.text != "" {
                guard let name = field.text else {return}
                strongSelf.spinrillaURL.text = name
                if let obj = strongSelf.currentAlbum.spinrilla {
                    obj.url = name
                } else {
                    strongSelf.currentAlbum.spinrilla = SpinrillaAlbumData(url: name, imageurl: nil, releaseDate: nil, isActive: false)
                }
                strongSelf.removeSpinrillaURLButton.isHidden = false
                strongSelf.spinrillaStatusControl.isHidden = false
                alertC.dismiss(animated: true, completion: nil)
            } else {
                alertC.dismiss(animated: true, completion: nil)
            }
        })
        alertC.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alertC.addAction(okAction)
        alertC.addTextField()
        alertC.textFields![0].text = currentAlbum.spinrilla?.url
        alertC.view.tintColor = Constants.Colors.redApp
        self.present(alertC, animated: true)
    }
    
    @IBAction func removeSpinrillaURLTapped(_ sender: Any) {
        let alertC = UIAlertController(title: "Remove Spinrilla URL",
                                       message: "Are You Sure?",
                                       preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Yes", style: .destructive, handler: {[weak self] _ in
            guard let strongSelf = self else {return}
            strongSelf.spinrillaURL.text = ""
            strongSelf.spinrillaURL.textColor = .green
            strongSelf.currentAlbum.spinrilla = nil
            strongSelf.removeSpinrillaURLButton.isHidden = true
            strongSelf.spinrillaStatusControl.isHidden = true
            alertC.dismiss(animated: true, completion: nil)
            
        })
        alertC.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alertC.addAction(okAction)
        alertC.view.tintColor = Constants.Colors.redApp
        self.present(alertC, animated: true)
    }
    
    @IBAction func addTrackTapped(_ sender: Any) {
        makeExceptionsArr(completion: {[weak self] err in
            guard let strongSelf = self else {return}
            strongSelf.arr = "track"
            strongSelf.prevPage = "editAlbum"
            strongSelf.performSegue(withIdentifier: "editAlbumToTonesPick", sender: nil)
        })
    }
    
    func trackAdded(_ trackAndData: [String:Any]) {
        lightImpactGenerator.impactOccurred(intensity: 0.75)
        let select = trackAndData[Array(trackAndData.keys)[0]]!
        let data = Array(trackAndData.keys)[0]
        if currentAlbum.tracks["Track \(data)"] != nil {
            mediumImpactGenerator.impactOccurred()
            Utilities.showError2("Album already has a track in that position.", actionText: "OK")
            return
        }
        
        tracksArr["Track \(data)"] = select
        
        switch select {
        case is SongData:
            let sel = select as! SongData
            currentAlbum.tracks["Track \(data)"] = sel.toneDeafAppId
        case is InstrumentalData:
            let sel = select as! InstrumentalData
            currentAlbum.tracks["Track \(data)"] = sel.toneDeafAppId
        default:
            break
        }
        
        DispatchQueue.main.async {[weak self]  in
            guard let strongSelf = self else {return}
            strongSelf.tracksTableView.reloadData()
            if strongSelf.tracksArr.count < 6 {
                strongSelf.tracksHeightConstraint.constant = CGFloat(70*(strongSelf.tracksArr.count))
            } else {
                strongSelf.tracksHeightConstraint.constant = CGFloat(370)
            }
        }
        
        
        
    }
    
    @IBAction func addSongTapped(_ sender: Any) {
        arr = "song"
        prevPage = "editAlbum"
        performSegue(withIdentifier: "editAlbumToTonesPick", sender: nil)
    }
    
    func songAdded(_ songAndData: [String?:SongData]) {
        lightImpactGenerator.impactOccurred(intensity: 0.75)
        let select = songAndData[Array(songAndData.keys)[0]]!
        if let data = Array(songAndData.keys)[0] {
            if currentAlbum.tracks["Track \(data)"] != nil {
                mediumImpactGenerator.impactOccurred()
                Utilities.showError2("Album already has a track in that position.", actionText: "OK")
                return
            }
            currentAlbum.tracks["Track \(data)"] = select.toneDeafAppId
            tracksArr["Track \(data)"] = select
            DispatchQueue.main.async {[weak self]  in
                guard let strongSelf = self else {return}
                strongSelf.tracksTableView.reloadData()
                if strongSelf.tracksArr.count < 6 {
                    strongSelf.tracksHeightConstraint.constant = CGFloat(70*(strongSelf.tracksArr.count))
                } else {
                    strongSelf.tracksHeightConstraint.constant = CGFloat(370)
                }
            }
        }
        
        if !songsArr.contains(select) {
            songsArr.append(select)
        } else {
            let dex = songsArr.firstIndex(of: select)
            songsArr[dex!] = select
        }
        
        if currentAlbum.songs == nil {
            currentAlbum.songs = ["\(select.toneDeafAppId)"]
        } else {
            if var arr = currentAlbum.songs {
                if !arr.contains(select.toneDeafAppId) {
                    arr.append("\(select.toneDeafAppId)")
                    arr.sort()
                    currentAlbum.songs = arr
                }
            } else {
                var arr:[String] = []
                arr.append("\(select.toneDeafAppId)")
                arr.sort()
                currentAlbum.songs = arr
            }
        }
        DispatchQueue.main.async {[weak self]  in
            guard let strongSelf = self else {return}
            strongSelf.songsArr.sort(by: {$0.name < $1.name})
            strongSelf.songsTableView.reloadData()
            if strongSelf.songsArr.count < 6 {
                strongSelf.songsHeightConstraint.constant = CGFloat(50*(strongSelf.songsArr.count))
            } else {
                strongSelf.songsHeightConstraint.constant = CGFloat(270)
            }
        }
    }
    
    @IBAction func addVideoTapped(_ sender: Any) {
        arr = "video"
        prevPage = "editAlbum"
        performSegue(withIdentifier: "editAlbumToTonesPick", sender: nil)
    }
    
    func videoAdded(_ videoAndData: [String:VideoData]) {
        lightImpactGenerator.impactOccurred(intensity: 0.75)
        let select = videoAndData[Array(videoAndData.keys)[0]]!
        let data = Array(videoAndData.keys)[0]
        
        switch data {
        case "Official Video":
            currentAlbum.officialAlbumVideo = select.toneDeafAppId
        default:
            break
        }
        if !videosArr.contains(select) {
            videosArr.append(select)
        } else {
            let dex = videosArr.firstIndex(of: select)
            videosArr[dex!] = select
        }
        
        if currentAlbum.videos == nil {
            currentAlbum.videos = ["\(select.toneDeafAppId)"]
        } else {
            if var arr = currentAlbum.videos {
                if !arr.contains(select.toneDeafAppId) {
                    arr.append("\(select.toneDeafAppId)")
                    arr.sort()
                    currentAlbum.videos = arr
                }
            } else {
                var arr:[String] = []
                arr.append("\(select.toneDeafAppId)")
                arr.sort()
                currentAlbum.videos = arr
            }
        }
        DispatchQueue.main.async {[weak self]  in
            guard let strongSelf = self else {return}
            strongSelf.videosArr.sort(by: {$0.title < $1.title})
            strongSelf.videosTableView.reloadData()
            if strongSelf.videosArr.count < 6 {
                strongSelf.videosHeightConstraint.constant = CGFloat(70*(strongSelf.videosArr.count))
            } else {
                strongSelf.videosHeightConstraint.constant = CGFloat(370)
            }
        }
        
        
        
    }
    
    @IBAction func addInstrumentalTapped(_ sender: Any) {
        arr = "instrumental"
        prevPage = "editAlbum"
        performSegue(withIdentifier: "editAlbumToTonesPick", sender: nil)
    }
    
    func instrumentalAdded(_ instrumentalAndData: [String?:InstrumentalData]) {
        lightImpactGenerator.impactOccurred(intensity: 0.75)
        let select = instrumentalAndData[Array(instrumentalAndData.keys)[0]]!
        if let data = Array(instrumentalAndData.keys)[0] {
            if currentAlbum.tracks["Track \(data)"] != nil {
                mediumImpactGenerator.impactOccurred()
                Utilities.showError2("Album already has a track in that position.", actionText: "OK")
                return
            }
            currentAlbum.tracks["Track \(data)"] = select.toneDeafAppId
            tracksArr["Track \(data)"] = select
            DispatchQueue.main.async {[weak self]  in
                guard let strongSelf = self else {return}
                strongSelf.tracksTableView.reloadData()
                if strongSelf.tracksArr.count < 6 {
                    strongSelf.tracksHeightConstraint.constant = CGFloat(70*(strongSelf.tracksArr.count))
                } else {
                    strongSelf.tracksHeightConstraint.constant = CGFloat(370)
                }
            }
        }
        
        if !instrumentalsArr.contains(select) {
            instrumentalsArr.append(select)
        } else {
            let dex = instrumentalsArr.firstIndex(of: select)
            instrumentalsArr[dex!] = select
        }
        
        if currentAlbum.instrumentals == nil {
            currentAlbum.instrumentals = ["\(select.toneDeafAppId)"]
        } else {
            if var arr = currentAlbum.instrumentals {
                if !arr.contains(select.toneDeafAppId) {
                    arr.append("\(select.toneDeafAppId)")
                    arr.sort()
                    currentAlbum.instrumentals = arr
                }
            } else {
                var arr:[String] = []
                arr.append("\(select.toneDeafAppId)")
                arr.sort()
                currentAlbum.instrumentals = arr
            }
        }
        DispatchQueue.main.async {[weak self]  in
            guard let strongSelf = self else {return}
            strongSelf.instrumentalsArr.sort(by: {$0.instrumentalName! < $1.instrumentalName!})
            strongSelf.instrumentalsTableView.reloadData()
            if strongSelf.instrumentalsArr.count < 6 {
                strongSelf.instrumentalsHeightConstraint.constant = CGFloat(50*(strongSelf.instrumentalsArr.count))
            } else {
                strongSelf.instrumentalsHeightConstraint.constant = CGFloat(270)
            }
        }
    }
    
    @IBAction func addDeluxeTapped(_ sender: Any) {
        arr = "album"
        tbsender = "deluxe"
        prevPage = "editAlbum"
        performSegue(withIdentifier: "editAlbumToTonesPick", sender: nil)
    }
    
    @IBAction func addOtherVersionTapped(_ sender: Any) {
        arr = "song"
        tbsender = "otherVersion"
        prevPage = "editAlbum"
        performSegue(withIdentifier: "editAlbumToTonesPick", sender: nil)
    }
    
    func albumAdded(_ album: AlbumData) {
        lightImpactGenerator.impactOccurred(intensity: 0.75)
        let select = album
        switch tbsender {
        case "deluxe":
            if album.isDeluxe != nil {
                mediumImpactGenerator.impactOccurred()
                Utilities.showError2("Album already has a deluxe.", actionText: "OK")
                return
            }
            if !deluxesArr.contains(album) {
                deluxesArr.append(album)
            } else {
                let dex = deluxesArr.firstIndex(of: album)
                deluxesArr[dex!] = album
            }
            
            if currentAlbum.deluxes == nil {
                currentAlbum.deluxes = ["\(album.toneDeafAppId)"]
            } else {
                if var arr = currentAlbum.deluxes {
                    if !arr.contains(album.toneDeafAppId) {
                        arr.append("\(album.toneDeafAppId)")
                        arr.sort()
                        currentAlbum.deluxes = arr
                    }
                } else {
                    var arr:[String] = []
                    arr.append("\(album.toneDeafAppId)")
                    arr.sort()
                    currentAlbum.deluxes = arr
                }
            }
            DispatchQueue.main.async {[weak self]  in
                guard let strongSelf = self else {return}
                strongSelf.deluxesArr.sort(by: {$0.name < $1.name})
                strongSelf.deluxesTableView.reloadData()
                if strongSelf.deluxesArr.count < 6 {
                    strongSelf.deluxesHeightConstraint.constant = CGFloat(50*(strongSelf.deluxesArr.count))
                } else {
                    strongSelf.deluxesHeightConstraint.constant = CGFloat(270)
                }
            }
        case "otherVersion":
            if !songOtherVersionsArr.contains(album) {
                songOtherVersionsArr.append(album)
            } else {
                let dex = songOtherVersionsArr.firstIndex(of: album)
                songOtherVersionsArr[dex!] = album
            }
            
            if currentAlbum.otherVersions == nil {
                currentAlbum.otherVersions = ["\(album.toneDeafAppId)"]
            } else {
                if var arr = currentAlbum.otherVersions {
                    if !arr.contains(album.toneDeafAppId) {
                        arr.append("\(album.toneDeafAppId)")
                        arr.sort()
                        currentAlbum.otherVersions = arr
                    }
                } else {
                    var arr:[String] = []
                    arr.append("\(album.toneDeafAppId)")
                    arr.sort()
                    currentAlbum.otherVersions = arr
                }
            }
            DispatchQueue.main.async {[weak self]  in
                guard let strongSelf = self else {return}
                strongSelf.songOtherVersionsArr.sort(by: {$0.name < $1.name})
                strongSelf.otherVersionsTableView.reloadData()
                if strongSelf.songOtherVersionsArr.count < 6 {
                    strongSelf.otherVersionsHeightConstraint.constant = CGFloat(50*(strongSelf.songOtherVersionsArr.count))
                } else {
                    strongSelf.otherVersionsHeightConstraint.constant = CGFloat(270)
                }
            }
        default:
            break
        }
        
    }
    
    //MARK: - Status Control
    @IBAction func spotifyStatusChanged(_ sender: Any) {
        lightImpactGenerator.impactOccurred(intensity: 0.75)
        if spotifyStatusControl.selectedSegmentIndex == 0 {
            NotificationCenter.default.post(name: adminDashboardStartSpinnerNotify, object: nil)
            spotifyStatusControl.selectedSegmentTintColor = .systemGreen
            currentAlbum.spotify?.isActive = true
            GlobalFunctions.shared.verifyUrl(urlString: currentAlbum.spotify!.url, completion: {[weak self] validity in
                guard let strongSelf = self else {return}
                DispatchQueue.main.async {
                    NotificationCenter.default.post(name: adminDashboardStopSpinnerNotify, object: nil)
                }
                if !validity {
                    mediumImpactGenerator.impactOccurred()
                    DispatchQueue.main.async {
                        Utilities.showError2("Url invalid.", actionText: "OK")
                        strongSelf.spotifyStatusControl.selectedSegmentIndex = 1
                        strongSelf.spotifyStatusControl.selectedSegmentTintColor = Constants.Colors.redApp
                    }
                    strongSelf.currentAlbum.spotify?.isActive = false
                }
            })
        } else {
            spotifyStatusControl.selectedSegmentTintColor = Constants.Colors.redApp
            currentAlbum.spotify?.isActive = false
        }
    }
    
    @IBAction func appleMusicStatusChanged(_ sender: Any) {
        lightImpactGenerator.impactOccurred(intensity: 0.75)
        if appleMusicStatusControl.selectedSegmentIndex == 0 {
            NotificationCenter.default.post(name: adminDashboardStartSpinnerNotify, object: nil)
            appleMusicStatusControl.selectedSegmentTintColor = .systemGreen
            currentAlbum.apple?.isActive = true
            GlobalFunctions.shared.verifyUrl(urlString: currentAlbum.apple!.url, completion: {[weak self] validity in
                guard let strongSelf = self else {return}
                DispatchQueue.main.async {
                    NotificationCenter.default.post(name: adminDashboardStopSpinnerNotify, object: nil)
                }
                if !validity {
                    mediumImpactGenerator.impactOccurred()
                    DispatchQueue.main.async {
                        Utilities.showError2("Url invalid.", actionText: "OK")
                        strongSelf.appleMusicStatusControl.selectedSegmentIndex = 1
                        strongSelf.appleMusicStatusControl.selectedSegmentTintColor = Constants.Colors.redApp
                    }
                    strongSelf.currentAlbum.apple?.isActive = false
                }
            })
        } else {
            appleMusicStatusControl.selectedSegmentTintColor = Constants.Colors.redApp
            currentAlbum.apple?.isActive = false
        }
    }
    
    @IBAction func soundcloudStatusChanged(_ sender: Any) {
        lightImpactGenerator.impactOccurred(intensity: 0.75)
        if soundcloudStatusControl.selectedSegmentIndex == 0 {
            NotificationCenter.default.post(name: adminDashboardStartSpinnerNotify, object: nil)
            soundcloudStatusControl.selectedSegmentTintColor = .systemGreen
            currentAlbum.soundcloud?.isActive = true
            GlobalFunctions.shared.verifyUrl(urlString: currentAlbum.soundcloud!.url, completion: {[weak self] validity in
                guard let strongSelf = self else {return}
                DispatchQueue.main.async {
                    NotificationCenter.default.post(name: adminDashboardStopSpinnerNotify, object: nil)
                }
                if !validity {
                    mediumImpactGenerator.impactOccurred()
                    DispatchQueue.main.async {
                        Utilities.showError2("Url invalid.", actionText: "OK")
                        strongSelf.soundcloudStatusControl.selectedSegmentIndex = 1
                        strongSelf.soundcloudStatusControl.selectedSegmentTintColor = Constants.Colors.redApp
                    }
                    strongSelf.currentAlbum.soundcloud?.isActive = false
                }
            })
        } else {
            soundcloudStatusControl.selectedSegmentTintColor = Constants.Colors.redApp
            currentAlbum.soundcloud?.isActive = false
        }
    }
    
    @IBAction func youtubeMusicStatusChanged(_ sender: Any) {
        lightImpactGenerator.impactOccurred(intensity: 0.75)
        if youtubeMusicStatusControl.selectedSegmentIndex == 0 {
            NotificationCenter.default.post(name: adminDashboardStartSpinnerNotify, object: nil)
            youtubeMusicStatusControl.selectedSegmentTintColor = .systemGreen
            currentAlbum.youtubeMusic?.isActive = true
            GlobalFunctions.shared.verifyUrl(urlString: currentAlbum.youtubeMusic!.url, completion: {[weak self] validity in
                guard let strongSelf = self else {return}
                DispatchQueue.main.async {
                    NotificationCenter.default.post(name: adminDashboardStopSpinnerNotify, object: nil)
                }
                if !validity {
                    mediumImpactGenerator.impactOccurred()
                    DispatchQueue.main.async {
                        Utilities.showError2("Url invalid.", actionText: "OK")
                        strongSelf.youtubeMusicStatusControl.selectedSegmentIndex = 1
                        strongSelf.youtubeMusicStatusControl.selectedSegmentTintColor = Constants.Colors.redApp
                    }
                    strongSelf.currentAlbum.youtubeMusic?.isActive = false
                }
            })
        } else {
            youtubeMusicStatusControl.selectedSegmentTintColor = Constants.Colors.redApp
            currentAlbum.youtubeMusic?.isActive = false
        }
    }
    
    @IBAction func amazonStatusChanged(_ sender: Any) {
        lightImpactGenerator.impactOccurred(intensity: 0.75)
        if amazonStatusControl.selectedSegmentIndex == 0 {
            NotificationCenter.default.post(name: adminDashboardStartSpinnerNotify, object: nil)
            amazonStatusControl.selectedSegmentTintColor = .systemGreen
            currentAlbum.amazon?.isActive = true
//            boolDict["amazon"] = true
            GlobalFunctions.shared.verifyUrl(urlString: currentAlbum.amazon!.url, completion: {[weak self] validity in
                guard let strongSelf = self else {return}
                DispatchQueue.main.async {
                    NotificationCenter.default.post(name: adminDashboardStopSpinnerNotify, object: nil)
                }
                if !validity {
                    mediumImpactGenerator.impactOccurred()
                    DispatchQueue.main.async {
                        Utilities.showError2("Url invalid.", actionText: "OK")
                        strongSelf.amazonStatusControl.selectedSegmentIndex = 1
                        strongSelf.amazonStatusControl.selectedSegmentTintColor = Constants.Colors.redApp
                    }
                    strongSelf.currentAlbum.amazon?.isActive = false
//                    strongSelf.boolDict["amazon"] = false
                }
            })
        } else {
            amazonStatusControl.selectedSegmentTintColor = Constants.Colors.redApp
            currentAlbum.amazon?.isActive = false
//            boolDict["amazon"] = false
        }
    }
    
    @IBAction func tidalStatusChanged(_ sender: Any) {
        lightImpactGenerator.impactOccurred(intensity: 0.75)
        if tidalStatusControl.selectedSegmentIndex == 0 {
            NotificationCenter.default.post(name: adminDashboardStartSpinnerNotify, object: nil)
            tidalStatusControl.selectedSegmentTintColor = .systemGreen
            currentAlbum.tidal?.isActive = true
            GlobalFunctions.shared.verifyUrl(urlString: currentAlbum.tidal!.url, completion: {[weak self] validity in
                guard let strongSelf = self else {return}
                DispatchQueue.main.async {
                    NotificationCenter.default.post(name: adminDashboardStopSpinnerNotify, object: nil)
                }
                if !validity {
                    mediumImpactGenerator.impactOccurred()
                    DispatchQueue.main.async {
                        Utilities.showError2("Url invalid.", actionText: "OK")
                        strongSelf.tidalStatusControl.selectedSegmentIndex = 1
                        strongSelf.tidalStatusControl.selectedSegmentTintColor = Constants.Colors.redApp
                    }
                    strongSelf.currentAlbum.tidal?.isActive = false
                }
            })
        } else {
            tidalStatusControl.selectedSegmentTintColor = Constants.Colors.redApp
            currentAlbum.tidal?.isActive = false
        }
    }
    
    @IBAction func napsterStatusChanged(_ sender: Any) {
        lightImpactGenerator.impactOccurred(intensity: 0.75)
        if napsterStatusControl.selectedSegmentIndex == 0 {
            NotificationCenter.default.post(name: adminDashboardStartSpinnerNotify, object: nil)
            napsterStatusControl.selectedSegmentTintColor = .systemGreen
            currentAlbum.napster?.isActive = true
            GlobalFunctions.shared.verifyUrl(urlString: currentAlbum.napster!.url, completion: {[weak self] validity in
                guard let strongSelf = self else {return}
                DispatchQueue.main.async {
                    NotificationCenter.default.post(name: adminDashboardStopSpinnerNotify, object: nil)
                }
                if !validity {
                    mediumImpactGenerator.impactOccurred()
                    DispatchQueue.main.async {
                        Utilities.showError2("Url invalid.", actionText: "OK")
                        strongSelf.napsterStatusControl.selectedSegmentIndex = 1
                        strongSelf.napsterStatusControl.selectedSegmentTintColor = Constants.Colors.redApp
                    }
                    strongSelf.currentAlbum.napster?.isActive = false
                }
            })
        } else {
            napsterStatusControl.selectedSegmentTintColor = Constants.Colors.redApp
            currentAlbum.napster?.isActive = false
        }
    }
    
    @IBAction func spinrillaStatusChanged(_ sender: Any) {
        lightImpactGenerator.impactOccurred(intensity: 0.75)
        if spinrillaStatusControl.selectedSegmentIndex == 0 {
            NotificationCenter.default.post(name: adminDashboardStartSpinnerNotify, object: nil)
            spinrillaStatusControl.selectedSegmentTintColor = .systemGreen
            currentAlbum.spinrilla?.isActive = true
            GlobalFunctions.shared.verifyUrl(urlString: currentAlbum.spinrilla!.url, completion: {[weak self] validity in
                guard let strongSelf = self else {return}
                DispatchQueue.main.async {
                    NotificationCenter.default.post(name: adminDashboardStopSpinnerNotify, object: nil)
                }
                if !validity {
                    mediumImpactGenerator.impactOccurred()
                    DispatchQueue.main.async {
                        Utilities.showError2("Url invalid.", actionText: "OK")
                        strongSelf.spinrillaStatusControl.selectedSegmentIndex = 1
                        strongSelf.spinrillaStatusControl.selectedSegmentTintColor = Constants.Colors.redApp
                    }
                    strongSelf.currentAlbum.spinrilla?.isActive = false
                }
            })
        } else {
            spinrillaStatusControl.selectedSegmentTintColor = Constants.Colors.redApp
            currentAlbum.spinrilla?.isActive = false
        }
    }
    
    @IBAction func deezerStatusChanged(_ sender: Any) {
        lightImpactGenerator.impactOccurred(intensity: 0.75)
        if deezerStatusControl.selectedSegmentIndex == 0 {
            NotificationCenter.default.post(name: adminDashboardStartSpinnerNotify, object: nil)
            deezerStatusControl.selectedSegmentTintColor = .systemGreen
            currentAlbum.deezer?.isActive = true
            GlobalFunctions.shared.verifyUrl(urlString: currentAlbum.deezer!.url, completion: {[weak self] validity in
                guard let strongSelf = self else {return}
                DispatchQueue.main.async {
                    NotificationCenter.default.post(name: adminDashboardStopSpinnerNotify, object: nil)
                }
                if !validity {
                    mediumImpactGenerator.impactOccurred()
                    DispatchQueue.main.async {
                        Utilities.showError2("Url invalid.", actionText: "OK")
                        strongSelf.deezerStatusControl.selectedSegmentIndex = 1
                        strongSelf.deezerStatusControl.selectedSegmentTintColor = Constants.Colors.redApp
                    }
                    strongSelf.currentAlbum.deezer?.isActive = false
                }
            })
        } else {
            deezerStatusControl.selectedSegmentTintColor = Constants.Colors.redApp
            currentAlbum.deezer?.isActive = false
        }
    }
    
    @IBAction func changeVerificationLevelTapped(_ sender: Any) {
        let alertC = UIAlertController(title: "Change Verification Level",
                                                message: "Select a Level.",
                                                preferredStyle: .alert)
        let aAction = UIAlertAction(title: "A Level", style: .default, handler: {[weak self] _ in
            guard let strongSelf = self else {return}
            strongSelf.currentAlbum.verificationLevel = "A"
            strongSelf.verificationLabel.text = String(strongSelf.currentAlbum.verificationLevel!)
            strongSelf.verificationLabel.textColor = .green
                alertC.dismiss(animated: true, completion: nil)
        })
        let bAction = UIAlertAction(title: "B Level", style: .default, handler: {[weak self] _ in
            guard let strongSelf = self else {return}
            strongSelf.currentAlbum.verificationLevel = "B"
            strongSelf.verificationLabel.text = String(strongSelf.currentAlbum.verificationLevel!)
            strongSelf.verificationLabel.textColor = .green
                alertC.dismiss(animated: true, completion: nil)
        })
        let cAction = UIAlertAction(title: "C Level", style: .default, handler: {[weak self] _ in
            guard let strongSelf = self else {return}
            strongSelf.currentAlbum.verificationLevel = "C"
            strongSelf.verificationLabel.text = String(strongSelf.currentAlbum.verificationLevel!)
            strongSelf.verificationLabel.textColor = .green
                alertC.dismiss(animated: true, completion: nil)
        })
        let uAction = UIAlertAction(title: "U Level", style: .default, handler: {[weak self] _ in
            guard let strongSelf = self else {return}
            strongSelf.currentAlbum.verificationLevel = "U"
            strongSelf.verificationLabel.text = String(strongSelf.currentAlbum.verificationLevel!)
            strongSelf.verificationLabel.textColor = .green
                alertC.dismiss(animated: true, completion: nil)
        })
        alertC.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alertC.addAction(aAction)
        alertC.addAction(bAction)
        alertC.addAction(cAction)
        alertC.addAction(uAction)
        alertC.view.tintColor = Constants.Colors.redApp
        self.present(alertC, animated: true)
    }
    
    @IBAction func deluxeChanged(_ sender: Any) {
        lightImpactGenerator.impactOccurred(intensity: 0.75)
        if deluxeControl.selectedSegmentIndex == 0 {
            deluxeControl.selectedSegmentTintColor = .systemGreen
            currentAlbum.isDeluxe = AlbumDeluxeData(standardEdition: nil, status: true)
            deluxeOfStackView.isHidden = false
            //true
        } else {
            deluxeControl.selectedSegmentTintColor = Constants.Colors.redApp
            currentAlbum.isDeluxe = nil
            deluxeOfTextField.text = ""
            //false
            deluxeOfStackView.isHidden = true
        }
    }
    
    @IBAction func otherVersionChanged(_ sender: Any) {
        lightImpactGenerator.impactOccurred(intensity: 0.75)
        if otherVersionControl.selectedSegmentIndex == 0 {
            otherVersionControl.selectedSegmentTintColor = .systemGreen
            currentAlbum.isOtherVersion = AlbumOtherVersionData(standardEdition: nil, status: true)
            otherVersionOfStackView.isHidden = false
            //true
        } else {
            otherVersionControl.selectedSegmentTintColor = Constants.Colors.redApp
            currentAlbum.isOtherVersion = nil
            otherVersionOfTextField.text = ""
            //false
            otherVersionOfStackView.isHidden = true
        }
    }
    
    @IBAction func industryCertifiedChanged(_ sender: Any) {
        lightImpactGenerator.impactOccurred(intensity: 0.75)
        if industryCertifiedControl.selectedSegmentIndex == 0 {
            industryCertifiedControl.selectedSegmentTintColor = .systemGreen
            currentAlbum.industryCerified = true
        } else {
            industryCertifiedControl.selectedSegmentTintColor = Constants.Colors.redApp
            currentAlbum.industryCerified = false
        }
    }
    
    @IBAction func statusChanged(_ sender: Any) {
        lightImpactGenerator.impactOccurred(intensity: 0.75)
        if statusControl.selectedSegmentIndex == 0 {
            statusControl.selectedSegmentTintColor = .systemGreen
            currentAlbum.isActive = true
        } else {
            statusControl.selectedSegmentTintColor = Constants.Colors.redApp
            currentAlbum.isActive = false
        }
    }
    
    func makeExceptionsArr(completion: @escaping ((Error?) -> Void)) {
        trackExceptionsArr = []
        for item in songsArr {
            var contained = false
            for (_,val) in currentAlbum.tracks {
                if val == item.toneDeafAppId {
                    contained = true
                }
            }
            if contained == false {
                trackExceptionsArr.append(item)
            }
        }
        for item in instrumentalsArr {
            var contained = false
            for (_,val) in currentAlbum.tracks {
                if val == item.toneDeafAppId {
                    contained = true
                }
            }
            if contained == false {
                trackExceptionsArr.append(item)
            }
        }
        completion(nil)
    }
    
    //MARK: - Update Tapped
    @IBAction func updateAlbumTapped(_ sender: Any) {
        let newDict = [
            "spotify":currentAlbum.spotify?.isActive,
            "apple":currentAlbum.apple?.isActive,
            "soundcloud":currentAlbum.soundcloud?.isActive,
            "youtubemusic":currentAlbum.youtubeMusic?.isActive,
            "amazon":currentAlbum.amazon?.isActive,
            "deezer":currentAlbum.deezer?.isActive,
            "tidal":currentAlbum.tidal?.isActive,
            "napster":currentAlbum.napster?.isActive,
            "spinrilla":currentAlbum.spinrilla?.isActive
        ]
        var newURLDict = [
            "spotify":currentAlbum.spotify?.url,
            "apple":currentAlbum.apple?.url,
            "soundcloud":currentAlbum.soundcloud?.url,
            "youtubemusic":currentAlbum.youtubeMusic?.url,
            "amazon":currentAlbum.amazon?.url,
            "deezer":currentAlbum.deezer?.url,
            "tidal":currentAlbum.tidal?.url,
            "napster":currentAlbum.napster?.url,
            "spinrilla":currentAlbum.spinrilla?.url
        ].compactMapValues { $0 }
        if currentAlbum.deezer?.url == nil {
            urlDict["deezer"] = nil
        }
        urlDict = urlDict.compactMapValues { $0 }
        urlDict = urlDict.removeNullsFromDictionary()
        
//        print(String(data: try! JSONSerialization.data(withJSONObject: urlDict, options: .prettyPrinted), encoding: .utf8)!)
//        print(String(data: try! JSONSerialization.data(withJSONObject: newURLDict, options: .prettyPrinted), encoding: .utf8)!)
        print(currentAlbum == initialAlbum, newDict == boolDict, newURLDict == urlDict, deluxeOf == currentAlbum.isDeluxe?.standardEdition, otherVersionsOf == currentAlbum.isOtherVersion?.standardEdition)
//        print(currentAlbum == initialAlbum)
        
        //MARK: - Error Count
        errorCountForController = 0
        if mainArtistsArr.isEmpty {
            errorCountForController+=1
        }
        if producersArr.isEmpty {
            errorCountForController+=1
        }
        
        guard errorCountForController == 0 else {
            mediumImpactGenerator.impactOccurred()
            Utilities.showError2("Please correct all errors before proceeding.", actionText: "OK")
            return
        }
        
        if currentAlbum == initialAlbum && newDict == boolDict && newURLDict == urlDict && deluxeOf == currentAlbum.isDeluxe?.standardEdition && otherVersionsOf == currentAlbum.isOtherVersion?.standardEdition {
            mediumImpactGenerator.impactOccurred()
            Utilities.showError2("Album already up to date.", actionText: "OK")
            return
        }
        
        //MARK: - Continue To Upload
        alertView = UIAlertController(title: "Updating \(name.text!)", message: "Preparing...", preferredStyle: .alert)
        alertView.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
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
            strongSelf.startUpdate(dict: newDict as NSDictionary, urldict: newURLDict as NSDictionary)
        })
    }
    
    func startUpdate(dict: NSDictionary, urldict: NSDictionary) {
        processName(completion: {[weak self] err in
            guard let strongSelf = self else {return}
            if let errors = err {
                mediumImpactGenerator.impactOccurred()
                for error in errors {
                    DispatchQueue.main.async {
                        Utilities.showError2("Name Proccessing Failed: \(error)", actionText: "OK")
                    }
                }
                strongSelf.uploadCompletionStatus1 = false
            } else {
                strongSelf.progressCompleted+=1
                DispatchQueue.main.async {
                    strongSelf.progressView.progress = (strongSelf.progressCompleted/strongSelf.totalProgress)
                    print("\(strongSelf.progressCompleted) out of \(strongSelf.totalProgress)")
                }
                strongSelf.uploadCompletionStatus1 = true
                print("done \(1)")
                strongSelf.proceedUpdate(dict: dict, urldict: urldict)
            }
        })
    }
    
    func proceedUpdate(dict: NSDictionary, urldict: NSDictionary) {
        
        let queue = DispatchQueue(label: "myhjvkheditingQalbumsssseue")
        let group = DispatchGroup()
        let array = [2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,25,26,27,28,29,30,31]
        totalProgress+=Float(array.count)
        for i in array {
            group.enter()
            queue.async { [weak self] in
                guard let strongSelf = self else {return}
                switch i {
                case 2:
                    strongSelf.processImages(completion: {err in
                        if let error = err {
                            mediumImpactGenerator.impactOccurred()
                            DispatchQueue.main.async {
                                Utilities.showError2("Image Proccessing Failed: \(error)", actionText: "OK")
                            }
                            strongSelf.uploadCompletionStatus2 = false
                        } else {
                            strongSelf.progressCompleted+=1
                            DispatchQueue.main.async {
                                strongSelf.progressView.progress = (strongSelf.progressCompleted/strongSelf.totalProgress)
                                print("\(strongSelf.progressCompleted) out of \(strongSelf.totalProgress)")
                            }
                            strongSelf.uploadCompletionStatus2 = true
                            print("done \(i)")
                        }
                        group.leave()
                    })
                case 3:
                    strongSelf.processPreview(completion: {err in
                        if let error = err {
                            mediumImpactGenerator.impactOccurred()
                            DispatchQueue.main.async {
                                Utilities.showError2("Preview Proccessing Failed: \(error)", actionText: "OK")
                            }
                            strongSelf.uploadCompletionStatus3 = false
                        } else {
                            strongSelf.progressCompleted+=1
                            DispatchQueue.main.async {
                                strongSelf.progressView.progress = (strongSelf.progressCompleted/strongSelf.totalProgress)
                                print("\(strongSelf.progressCompleted) out of \(strongSelf.totalProgress)")
                            }
                            strongSelf.uploadCompletionStatus3 = true
                            print("done \(i)")
                        }
                        group.leave()
                    })
                case 4:
                    strongSelf.processMainArtists(completion: {err in
                        if let error = err {
                            mediumImpactGenerator.impactOccurred()
                            DispatchQueue.main.async {
                                Utilities.showError2("Main Artist Proccessing Failed: \(error)", actionText: "OK")
                            }
                            strongSelf.uploadCompletionStatus4 = false
                        } else {
                            strongSelf.progressCompleted+=1
                            DispatchQueue.main.async {
                                strongSelf.progressView.progress = (strongSelf.progressCompleted/strongSelf.totalProgress)
                                print("\(strongSelf.progressCompleted) out of \(strongSelf.totalProgress)")
                            }
                            strongSelf.uploadCompletionStatus4 = true
                            print("done \(i)")
                        }
                        group.leave()
                    })
                case 5:
                    strongSelf.processProducers(completion: {err in
                        if let error = err {
                            mediumImpactGenerator.impactOccurred()
                            DispatchQueue.main.async {
                                Utilities.showError2("Producer Proccessing Failed: \(error)", actionText: "OK")
                            }
                            strongSelf.uploadCompletionStatus5 = false
                        } else {
                            strongSelf.progressCompleted+=1
                            DispatchQueue.main.async {
                                strongSelf.progressView.progress = (strongSelf.progressCompleted/strongSelf.totalProgress)
                                print("\(strongSelf.progressCompleted) out of \(strongSelf.totalProgress)")
                            }
                            strongSelf.uploadCompletionStatus5 = true
                            print("done \(i)")
                        }
                        group.leave()
                    })
                case 6:
                    strongSelf.processSpotifyURL(dict: dict, urldict: urldict, completion: {err in
                        if let errors = err {
                            mediumImpactGenerator.impactOccurred()
                            for error in errors {
                                DispatchQueue.main.async {
                                    Utilities.showError2("Spotify Proccessing Failed: \(error)", actionText: "OK")
                                }
                            }
                            strongSelf.uploadCompletionStatus6 = false
                        } else {
                            strongSelf.progressCompleted+=1
                            DispatchQueue.main.async {
                                strongSelf.progressView.progress = (strongSelf.progressCompleted/strongSelf.totalProgress)
                                print("\(strongSelf.progressCompleted) out of \(strongSelf.totalProgress)")
                            }
                            strongSelf.uploadCompletionStatus6 = true
                            print("done \(i)")
                        }
                        group.leave()
                    })
                case 7:
                    strongSelf.processAppleURL(dict: dict, urldict: urldict, completion: {err in
                        if let errors = err {
                            mediumImpactGenerator.impactOccurred()
                            for error in errors {
                                DispatchQueue.main.async {
                                    Utilities.showError2("Apple Proccessing Failed: \(error)", actionText: "OK")
                                }
                            }
                            strongSelf.uploadCompletionStatus7 = false
                        } else {
                            strongSelf.progressCompleted+=1
                            DispatchQueue.main.async {
                                strongSelf.progressView.progress = (strongSelf.progressCompleted/strongSelf.totalProgress)
                                print("\(strongSelf.progressCompleted) out of \(strongSelf.totalProgress)")
                            }
                            strongSelf.uploadCompletionStatus7 = true
                            print("done \(i)")
                        }
                        group.leave()
                    })
                case 8:
                    strongSelf.processWriters(completion: {err in
                        if let error = err {
                            mediumImpactGenerator.impactOccurred()
                            DispatchQueue.main.async {
                                Utilities.showError2("Writer Proccessing Failed: \(error)", actionText: "OK")
                            }
                            strongSelf.uploadCompletionStatus8 = false
                        } else {
                            strongSelf.progressCompleted+=1
                            DispatchQueue.main.async {
                                strongSelf.progressView.progress = (strongSelf.progressCompleted/strongSelf.totalProgress)
                                print("\(strongSelf.progressCompleted) out of \(strongSelf.totalProgress)")
                            }
                            strongSelf.uploadCompletionStatus8 = true
                            print("done \(i)")
                        }
                        group.leave()
                    })
                case 9:
                    strongSelf.processSoundcloudURL(dict: dict, urldict: urldict, completion: {err in
                        if let errors = err {
                            mediumImpactGenerator.impactOccurred()
                            for error in errors {
                                DispatchQueue.main.async {
                                    Utilities.showError2("Soundcloud Proccessing Failed: \(error)", actionText: "OK")
                                }
                            }
                            strongSelf.uploadCompletionStatus9 = false
                        } else {
                            strongSelf.progressCompleted+=1
                            DispatchQueue.main.async {
                                strongSelf.progressView.progress = (strongSelf.progressCompleted/strongSelf.totalProgress)
                                print("\(strongSelf.progressCompleted) out of \(strongSelf.totalProgress)")
                            }
                            strongSelf.uploadCompletionStatus9 = true
                            print("done \(i)")
                        }
                        group.leave()
                    })
                case 10:
                    strongSelf.processYoutubeMusicURL(dict: dict, urldict: urldict, completion: {err in
                        if let errors = err {
                            mediumImpactGenerator.impactOccurred()
                            for error in errors {
                                DispatchQueue.main.async {
                                    Utilities.showError2("Youtube Music Proccessing Failed: \(error)", actionText: "OK")
                                }
                            }
                            strongSelf.uploadCompletionStatus10 = false
                        } else {
                            strongSelf.progressCompleted+=1
                            DispatchQueue.main.async {
                                strongSelf.progressView.progress = (strongSelf.progressCompleted/strongSelf.totalProgress)
                                print("\(strongSelf.progressCompleted) out of \(strongSelf.totalProgress)")
                            }
                            strongSelf.uploadCompletionStatus10 = true
                            print("done \(i)")
                        }
                        group.leave()
                    })
                case 11:
                    strongSelf.processAmazonURL(dict: dict, urldict: urldict, completion: {err in
                        if let errors = err {
                            mediumImpactGenerator.impactOccurred()
                            for error in errors {
                                DispatchQueue.main.async {
                                    Utilities.showError2("Amazon Proccessing Failed: \(error)", actionText: "OK")
                                }
                            }
                            strongSelf.uploadCompletionStatus11 = false
                        } else {
                            strongSelf.progressCompleted+=1
                            DispatchQueue.main.async {
                                strongSelf.progressView.progress = (strongSelf.progressCompleted/strongSelf.totalProgress)
                                print("\(strongSelf.progressCompleted) out of \(strongSelf.totalProgress)")
                            }
                            strongSelf.uploadCompletionStatus11 = true
                            print("done \(i)")
                        }
                        group.leave()
                    })
                case 12:
                    strongSelf.processDeezerURL(dict: dict, urldict: urldict, completion: {err in
                        if let errors = err {
                            mediumImpactGenerator.impactOccurred()
                            for error in errors {
                                DispatchQueue.main.async {
                                    Utilities.showError2("Deezer Proccessing Failed: \(error)", actionText: "OK")
                                }
                            }
                            strongSelf.uploadCompletionStatus12 = false
                        } else {
                            strongSelf.progressCompleted+=1
                            DispatchQueue.main.async {
                                strongSelf.progressView.progress = (strongSelf.progressCompleted/strongSelf.totalProgress)
                                print("\(strongSelf.progressCompleted) out of \(strongSelf.totalProgress)")
                            }
                            strongSelf.uploadCompletionStatus12 = true
                            print("done \(i)")
                        }
                        group.leave()
                    })
                case 13:
                    strongSelf.processTidalURL(dict: dict, urldict: urldict, completion: {err in
                        if let errors = err {
                            mediumImpactGenerator.impactOccurred()
                            for error in errors {
                                DispatchQueue.main.async {
                                    Utilities.showError2("Tidal Proccessing Failed: \(error)", actionText: "OK")
                                }
                            }
                            strongSelf.uploadCompletionStatus13 = false
                        } else {
                            strongSelf.progressCompleted+=1
                            DispatchQueue.main.async {
                                strongSelf.progressView.progress = (strongSelf.progressCompleted/strongSelf.totalProgress)
                                print("\(strongSelf.progressCompleted) out of \(strongSelf.totalProgress)")
                            }
                            strongSelf.uploadCompletionStatus13 = true
                            print("done \(i)")
                        }
                        group.leave()
                    })
                case 14:
                    strongSelf.processNapsterURL(dict: dict, urldict: urldict, completion: {err in
                        if let errors = err {
                            mediumImpactGenerator.impactOccurred()
                            for error in errors {
                                DispatchQueue.main.async {
                                    Utilities.showError2("Napster Proccessing Failed: \(error)", actionText: "OK")
                                }
                            }
                            strongSelf.uploadCompletionStatus14 = false
                        } else {
                            strongSelf.progressCompleted+=1
                            DispatchQueue.main.async {
                                strongSelf.progressView.progress = (strongSelf.progressCompleted/strongSelf.totalProgress)
                                print("\(strongSelf.progressCompleted) out of \(strongSelf.totalProgress)")
                            }
                            strongSelf.uploadCompletionStatus14 = true
                            print("done \(i)")
                        }
                        group.leave()
                    })
                case 15:
                    strongSelf.processSpinrillaURL(dict: dict, urldict: urldict, completion: {err in
                        if let errors = err {
                            mediumImpactGenerator.impactOccurred()
                            for error in errors {
                                DispatchQueue.main.async {
                                    Utilities.showError2("Spinrilla Proccessing Failed: \(error)", actionText: "OK")
                                }
                            }
                            strongSelf.uploadCompletionStatus15 = false
                        } else {
                            strongSelf.progressCompleted+=1
                            DispatchQueue.main.async {
                                strongSelf.progressView.progress = (strongSelf.progressCompleted/strongSelf.totalProgress)
                                print("\(strongSelf.progressCompleted) out of \(strongSelf.totalProgress)")
                            }
                            strongSelf.uploadCompletionStatus15 = true
                            print("done \(i)")
                        }
                        group.leave()
                    })
                case 16:
                    strongSelf.processMixEngineers(completion: {err in
                        if let error = err {
                            mediumImpactGenerator.impactOccurred()
                            DispatchQueue.main.async {
                                Utilities.showError2("Mix Engineer Proccessing Failed: \(error)", actionText: "OK")
                            }
                            strongSelf.uploadCompletionStatus16 = false
                        } else {
                            strongSelf.progressCompleted+=1
                            DispatchQueue.main.async {
                                strongSelf.progressView.progress = (strongSelf.progressCompleted/strongSelf.totalProgress)
                                print("\(strongSelf.progressCompleted) out of \(strongSelf.totalProgress)")
                            }
                            strongSelf.uploadCompletionStatus16 = true
                            print("done \(i)")
                        }
                        group.leave()
                    })
                case 17:
                    strongSelf.processMasteringEngineers(completion: {err in
                        if let error = err {
                            mediumImpactGenerator.impactOccurred()
                            DispatchQueue.main.async {
                                Utilities.showError2("Mastering Engineer Proccessing Failed: \(error)", actionText: "OK")
                            }
                            strongSelf.uploadCompletionStatus17 = false
                        } else {
                            strongSelf.progressCompleted+=1
                            DispatchQueue.main.async {
                                strongSelf.progressView.progress = (strongSelf.progressCompleted/strongSelf.totalProgress)
                                print("\(strongSelf.progressCompleted) out of \(strongSelf.totalProgress)")
                            }
                            strongSelf.uploadCompletionStatus17 = true
                            print("done \(i)")
                        }
                        group.leave()
                    })
                case 18:
                    strongSelf.processRecordingEngineers(completion: {err in
                        if let error = err {
                            mediumImpactGenerator.impactOccurred()
                            DispatchQueue.main.async {
                                Utilities.showError2("Recording Engineer Proccessing Failed: \(error)", actionText: "OK")
                            }
                            strongSelf.uploadCompletionStatus18 = false
                        } else {
                            strongSelf.progressCompleted+=1
                            DispatchQueue.main.async {
                                strongSelf.progressView.progress = (strongSelf.progressCompleted/strongSelf.totalProgress)
                                print("\(strongSelf.progressCompleted) out of \(strongSelf.totalProgress)")
                            }
                            strongSelf.uploadCompletionStatus18 = true
                            print("done \(i)")
                        }
                        group.leave()
                    })
                case 19:
                    strongSelf.processAllArtists(completion: {err in
                        if let error = err {
                            mediumImpactGenerator.impactOccurred()
                            DispatchQueue.main.async {
                                Utilities.showError2("All Artist Proccessing Failed: \(error)", actionText: "OK")
                            }
                            strongSelf.uploadCompletionStatus19 = false
                        } else {
                            strongSelf.progressCompleted+=1
                            DispatchQueue.main.async {
                                strongSelf.progressView.progress = (strongSelf.progressCompleted/strongSelf.totalProgress)
                                print("\(strongSelf.progressCompleted) out of \(strongSelf.totalProgress)")
                            }
                            strongSelf.uploadCompletionStatus19 = true
                            print("done \(i)")
                        }
                        group.leave()
                    })
                case 20:
                    strongSelf.uploadCompletionStatus20 = false
                    strongSelf.processTracks(completion: {err in
                        if let errors = err {
                            mediumImpactGenerator.impactOccurred()
                            for error in errors {
                                DispatchQueue.main.async {
                                    Utilities.showError2("Tracks Proccessing Failed: \(error)", actionText: "OK")
                                }
                            }
                            strongSelf.uploadCompletionStatus20 = false
                        } else {
                            strongSelf.progressCompleted+=1
                            DispatchQueue.main.async {
                                strongSelf.progressView.progress = (strongSelf.progressCompleted/strongSelf.totalProgress)
                                print("\(strongSelf.progressCompleted) out of \(strongSelf.totalProgress)")
                            }
                            strongSelf.uploadCompletionStatus20 = true
                            print("done \(i)")
                        }
                        group.leave()
                    })
                case 21:
                    strongSelf.uploadCompletionStatus21 = false
                    strongSelf.processSongs(completion: {err in
                        if let errors = err {
                            mediumImpactGenerator.impactOccurred()
                            for error in errors {
                                DispatchQueue.main.async {
                                    Utilities.showError2("Songs Proccessing Failed: \(error)", actionText: "OK")
                                }
                            }
                            strongSelf.uploadCompletionStatus21 = false
                        } else {
                            strongSelf.progressCompleted+=1
                            DispatchQueue.main.async {
                                strongSelf.progressView.progress = (strongSelf.progressCompleted/strongSelf.totalProgress)
                                print("\(strongSelf.progressCompleted) out of \(strongSelf.totalProgress)")
                            }
                            strongSelf.uploadCompletionStatus21 = true
                            print("done \(i)")
                        }
                        group.leave()
                    })
                case 22:
                    strongSelf.uploadCompletionStatus22 = false
                    strongSelf.processVideos(completion: {err in
                        if let errors = err {
                            mediumImpactGenerator.impactOccurred()
                            for error in errors {
                                DispatchQueue.main.async {
                                    Utilities.showError2("Videos Proccessing Failed: \(error)", actionText: "OK")
                                }
                            }
                            strongSelf.uploadCompletionStatus22 = false
                        } else {
                            strongSelf.progressCompleted+=1
                            DispatchQueue.main.async {
                                strongSelf.progressView.progress = (strongSelf.progressCompleted/strongSelf.totalProgress)
                                print("\(strongSelf.progressCompleted) out of \(strongSelf.totalProgress)")
                            }
                            strongSelf.uploadCompletionStatus22 = true
                            print("done \(i)")
                        }
                        group.leave()
                    })
                case 23:
                    strongSelf.uploadCompletionStatus23 = false
                    strongSelf.processInstrumentals(completion: {err in
                        if let errors = err {
                            mediumImpactGenerator.impactOccurred()
                            for error in errors {
                                DispatchQueue.main.async {
                                    Utilities.showError2("Instrumentals Proccessing Failed: \(error)", actionText: "OK")
                                }
                            }
                            strongSelf.uploadCompletionStatus23 = false
                        } else {
                            strongSelf.progressCompleted+=1
                            DispatchQueue.main.async {
                                strongSelf.progressView.progress = (strongSelf.progressCompleted/strongSelf.totalProgress)
                                print("\(strongSelf.progressCompleted) out of \(strongSelf.totalProgress)")
                            }
                            strongSelf.uploadCompletionStatus23 = true
                            print("done \(i)")
                        }
                        group.leave()
                    })
                case 25:
                    strongSelf.uploadCompletionStatus25 = false
                    strongSelf.processVerificationLevel(completion: {err in
                        if let error = err {
                            mediumImpactGenerator.impactOccurred()
                            DispatchQueue.main.async {
                                Utilities.showError2("Verification Level Proccessing Failed: \(error)", actionText: "OK")
                            }
                            strongSelf.uploadCompletionStatus25 = false
                        } else {
                            strongSelf.progressCompleted+=1
                            DispatchQueue.main.async {
                                strongSelf.progressView.progress = (strongSelf.progressCompleted/strongSelf.totalProgress)
                                print("\(strongSelf.progressCompleted) out of \(strongSelf.totalProgress)")
                            }
                            strongSelf.uploadCompletionStatus25 = true
                            print("done \(i)")
                        }
                        group.leave()
                    })
                case 26:
                    strongSelf.uploadCompletionStatus26 = false
                    strongSelf.processIndustryCertification(completion: {err in
                        if let error = err {
                            mediumImpactGenerator.impactOccurred()
                            DispatchQueue.main.async {
                                Utilities.showError2("Industry Certification Proccessing Failed: \(error)", actionText: "OK")
                            }
                            strongSelf.uploadCompletionStatus26 = false
                        } else {
                            strongSelf.progressCompleted+=1
                            DispatchQueue.main.async {
                                strongSelf.progressView.progress = (strongSelf.progressCompleted/strongSelf.totalProgress)
                                print("\(strongSelf.progressCompleted) out of \(strongSelf.totalProgress)")
                            }
                            strongSelf.uploadCompletionStatus26 = true
                            print("done \(i)")
                        }
                        group.leave()
                    })
                case 27:
                    strongSelf.uploadCompletionStatus27 = false
                    strongSelf.processStatus(completion: {err in
                        if let error = err {
                            mediumImpactGenerator.impactOccurred()
                            DispatchQueue.main.async {
                                Utilities.showError2("Status Proccessing Failed: \(error)", actionText: "OK")
                            }
                            strongSelf.uploadCompletionStatus27 = false
                        } else {
                            strongSelf.progressCompleted+=1
                            DispatchQueue.main.async {
                                strongSelf.progressView.progress = (strongSelf.progressCompleted/strongSelf.totalProgress)
                                print("\(strongSelf.progressCompleted) out of \(strongSelf.totalProgress)")
                            }
                            strongSelf.uploadCompletionStatus27 = true
                            print("done \(i)")
                        }
                        group.leave()
                    })
                case 28:
                    strongSelf.processIsDeluxes(completion: {err in
                        if let error = err {
                            mediumImpactGenerator.impactOccurred()
                            DispatchQueue.main.async {
                                Utilities.showError2("Is Deluxe Proccessing Failed: \(error)", actionText: "OK")
                            }
                            strongSelf.uploadCompletionStatus28 = false
                        } else {
                            strongSelf.progressCompleted+=1
                            DispatchQueue.main.async {
                                strongSelf.progressView.progress = (strongSelf.progressCompleted/strongSelf.totalProgress)
                                print("\(strongSelf.progressCompleted) out of \(strongSelf.totalProgress)")
                            }
                            strongSelf.uploadCompletionStatus28 = true
                            print("done \(i)")
                        }
                        group.leave()
                    })
                case 29:
                    strongSelf.processIsOtherVersions(completion: {err in
                        if let error = err {
                            mediumImpactGenerator.impactOccurred()
                            DispatchQueue.main.async {
                                Utilities.showError2("Is Other Versions Proccessing Failed: \(error)", actionText: "OK")
                            }
                            strongSelf.uploadCompletionStatus29 = false
                        } else {
                            strongSelf.progressCompleted+=1
                            DispatchQueue.main.async {
                                strongSelf.progressView.progress = (strongSelf.progressCompleted/strongSelf.totalProgress)
                                print("\(strongSelf.progressCompleted) out of \(strongSelf.totalProgress)")
                            }
                            strongSelf.uploadCompletionStatus29 = true
                            print("done \(i)")
                        }
                        group.leave()
                    })
                case 30:
                    strongSelf.processDeluxe(completion: {err in
                        if let error = err {
                            mediumImpactGenerator.impactOccurred()
                            DispatchQueue.main.async {
                                Utilities.showError2("Deluxe Proccessing Failed: \(error)", actionText: "OK")
                            }
                            strongSelf.uploadCompletionStatus30 = false
                        } else {
                            strongSelf.progressCompleted+=1
                            DispatchQueue.main.async {
                                strongSelf.progressView.progress = (strongSelf.progressCompleted/strongSelf.totalProgress)
                                print("\(strongSelf.progressCompleted) out of \(strongSelf.totalProgress)")
                            }
                            strongSelf.uploadCompletionStatus30 = true
                            print("done \(i)")
                        }
                        group.leave()
                    })
                case 31:
                    strongSelf.processOtherVersions(completion: {err in
                        if let error = err {
                            mediumImpactGenerator.impactOccurred()
                            DispatchQueue.main.async {
                                Utilities.showError2("Other Versions Proccessing Failed: \(error)", actionText: "OK")
                            }
                            strongSelf.uploadCompletionStatus31 = false
                        } else {
                            strongSelf.progressCompleted+=1
                            DispatchQueue.main.async {
                                strongSelf.progressView.progress = (strongSelf.progressCompleted/strongSelf.totalProgress)
                                print("\(strongSelf.progressCompleted) out of \(strongSelf.totalProgress)")
                            }
                            strongSelf.uploadCompletionStatus31 = true
                            print("done \(i)")
                        }
                        group.leave()
                    })
                default:
                    print("Edit Song error")
                }
            }
        }
        
        group.notify(queue: DispatchQueue.main) { [weak self] in
            guard let strongSelf = self else {return}
            if strongSelf.uploadCompletionStatus1 == false || strongSelf.uploadCompletionStatus2 == false || strongSelf.uploadCompletionStatus3 == false || strongSelf.uploadCompletionStatus4 == false || strongSelf.uploadCompletionStatus5 == false || strongSelf.uploadCompletionStatus6 == false || strongSelf.uploadCompletionStatus7 == false || strongSelf.uploadCompletionStatus8 == false || strongSelf.uploadCompletionStatus9 == false || strongSelf.uploadCompletionStatus10 == false || strongSelf.uploadCompletionStatus11 == false || strongSelf.uploadCompletionStatus12 == false || strongSelf.uploadCompletionStatus13 == false || strongSelf.uploadCompletionStatus14 == false || strongSelf.uploadCompletionStatus15 == false || strongSelf.uploadCompletionStatus16 == false || strongSelf.uploadCompletionStatus17 == false || strongSelf.uploadCompletionStatus18 == false || strongSelf.uploadCompletionStatus19 == false || strongSelf.uploadCompletionStatus20 == false || strongSelf.uploadCompletionStatus21 == false || strongSelf.uploadCompletionStatus22 == false || strongSelf.uploadCompletionStatus23 == false || strongSelf.uploadCompletionStatus24 == false || strongSelf.uploadCompletionStatus25 == false || strongSelf.uploadCompletionStatus26 == false || strongSelf.uploadCompletionStatus27 == false || strongSelf.uploadCompletionStatus28 == false || strongSelf.uploadCompletionStatus29 == false {
                strongSelf.alertView.dismiss(animated: true, completion: nil)
                
//                EditAlbumHelper.shared.cancelUpdate(initialAlbum: strongSelf.initialAlbum,currentAlbum: strongSelf.currentAlbum, initialStatus: strongSelf.boolDict as NSDictionary, currentStatus: dict, initialURL: strongSelf.urlDict as NSDictionary, currentURL: urldict , completion: { err in
//                    strongSelf.alertView.dismiss(animated: true, completion: nil)
//                    if let error = err {
//                        DispatchQueue.main.async {
                            Utilities.showError2("Cancellation of Album Edit Failed, check database now: \("error")", actionText: "OK")
//                        }
//                        _ = strongSelf.navigationController?.popViewController(animated: true)
//                    }
//                    return
//                })
            } else {
                print("📗 Album data updated to database successfully.")
                strongSelf.alertView.dismiss(animated: true, completion: {
                    Utilities.successBarBanner("Update successful.")
                    _ = strongSelf.navigationController?.popViewController(animated: true)
                })
            }
        }
    }
    
    func processImages(completion: @escaping ((Error?) -> Void)) {
        guard currentAlbum.manualImageURL != initialAlbum.manualImageURL else {
            completion(nil)
            return
        }
        if currentAlbum.manualImageURL != nil && currentAlbum.manualImageURL != "" {
            guard newImage != nil else {
                completion(SongEditorError.imageUpdateError("Image must not be empty"))
                return
            }
        }
        EditAlbumHelper.shared.processImage(initialAlbum: initialAlbum, currentAlbum: currentAlbum, image: newImage, completion: {[weak self] err in
            guard let strongSelf = self else {return}
            if let error = err {
                completion(error)
                return
            } else {
                completion(nil)
                return
            }
        })
    }
    
    func processPreview(completion: @escaping ((Error?) -> Void)) {
        guard currentAlbum.manualPreviewURL != initialAlbum.manualPreviewURL else {
            completion(nil)
            return
        }
//        if currentAlbum.manualPreviewURL == nil {
//            completion(nil)
//            return
//        }
        EditAlbumHelper.shared.processPreview(initialAlbum: initialAlbum, currentAlbum: currentAlbum, audio: newPreview, completion: {[weak self] err in
            guard let strongSelf = self else {return}
            if let error = err {
                completion(error)
                return
            } else {
                completion(nil)
                return
            }
        })
    }
    
    func processName(completion: @escaping (([Error]?) -> Void)) {
        guard currentAlbum.name != initialAlbum.name else {
            completion(nil)
            return
        }
        EditAlbumHelper.shared.processName(initialAlbum: initialAlbum,currentAlbum: currentAlbum, completion: {[weak self] err in
            guard let strongSelf = self else {return}
            if let error = err {
                completion(error)
                return
            } else {
                completion(nil)
                return
            }
        })
    }
    
    func processMainArtists(completion: @escaping (([Error]?) -> Void)) {
        guard currentAlbum.mainArtist.sorted() != initialAlbum.mainArtist.sorted() else {
            completion(nil)
            return
        }
        EditAlbumHelper.shared.processMainArtists(initialAlbum: initialAlbum,currentAlbum: currentAlbum, completion: {[weak self] err in
            guard let strongSelf = self else {return}
            if let error = err {
                completion(error)
                return
            } else {
                completion(nil)
                return
            }
        })
    }
    
    func processAllArtists(completion: @escaping (([Error]?) -> Void)) {
        guard let _ = currentAlbum.allArtists else {
            completion(nil)
            return
        }
        guard currentAlbum.allArtists!.sorted() != initialAlbum.allArtists?.sorted() else {
            completion(nil)
            return
        }
        EditAlbumHelper.shared.processAllArtists(initialAlbum: initialAlbum,currentAlbum: currentAlbum, completion: {[weak self] err in
            guard let strongSelf = self else {return}
            if let error = err {
                completion(error)
                return
            } else {
                completion(nil)
                return
            }
        })
    }
    
    func processProducers(completion: @escaping (([Error]?) -> Void)) {
        guard currentAlbum.producers.sorted() != initialAlbum.producers.sorted() else {
            completion(nil)
            return
        }
        EditAlbumHelper.shared.processProducers(initialAlbum: initialAlbum,currentAlbum: currentAlbum, completion: {[weak self] err in
            guard let strongSelf = self else {return}
            if let error = err {
                completion(error)
                return
            } else {
                completion(nil)
                return
            }
        })
    }
    
    func processWriters(completion: @escaping (([Error]?) -> Void)) {
        guard let _ = currentAlbum.writers else {
            completion(nil)
            return
        }
        guard currentAlbum.writers!.sorted() != initialAlbum.writers?.sorted() else {
            completion(nil)
            return
        }
        EditAlbumHelper.shared.processWriters(initialAlbum: initialAlbum,currentAlbum: currentAlbum, completion: {[weak self] err in
            guard let strongSelf = self else {return}
            if let error = err {
                completion(error)
                return
            } else {
                completion(nil)
                return
            }
        })
    }
    
    func processMixEngineers(completion: @escaping (([Error]?) -> Void)) {
        guard let _ = currentAlbum.mixEngineers else {
            completion(nil)
            return
        }
        guard currentAlbum.mixEngineers!.sorted() != initialAlbum.mixEngineers?.sorted() else {
            completion(nil)
            return
        }
        EditAlbumHelper.shared.processMixEngineers(initialAlbum: initialAlbum,currentAlbum: currentAlbum, completion: {[weak self] err in
            guard let strongSelf = self else {return}
            if let error = err {
                completion(error)
                return
            } else {
                completion(nil)
                return
            }
        })
    }
    
    func processMasteringEngineers(completion: @escaping (([Error]?) -> Void)) {
        guard let _ = currentAlbum.masteringEngineers else {
            completion(nil)
            return
        }
        guard currentAlbum.masteringEngineers!.sorted() != initialAlbum.masteringEngineers?.sorted() else {
            completion(nil)
            return
        }
        EditAlbumHelper.shared.processMasteringEngineers(initialAlbum: initialAlbum,currentAlbum: currentAlbum, completion: {[weak self] err in
            guard let strongSelf = self else {return}
            if let error = err {
                completion(error)
                return
            } else {
                completion(nil)
                return
            }
        })
    }
    
    func processRecordingEngineers(completion: @escaping (([Error]?) -> Void)) {
        guard let _ = currentAlbum.recordingEngineers else {
            completion(nil)
            return
        }
        guard currentAlbum.recordingEngineers!.sorted() != initialAlbum.recordingEngineers?.sorted() else {
            completion(nil)
            return
        }
        EditAlbumHelper.shared.processRecordingEngineers(initialAlbum: initialAlbum,currentAlbum: currentAlbum, completion: {[weak self] err in
            guard let strongSelf = self else {return}
            if let error = err {
                completion(error)
                return
            } else {
                completion(nil)
                return
            }
        })
    }
    
    func processSpotifyURL(dict:NSDictionary, urldict:NSDictionary, completion: @escaping (([Error]?) -> Void)) {
        
        guard currentAlbum.spotify?.url != initialAlbum.spotify?.url || (dict["spotify"] as? Bool) != boolDict["spotify"] || urlDict["spotify"] != (urldict["spotify"] as? String) else {
            completion(nil)
            return
        }
        
        EditAlbumHelper.shared.processSpotify(initialAlbum: initialAlbum,currentAlbum: currentAlbum, initialStatus: boolDict["spotify"] as? Bool, currentStatus: (dict["spotify"] as? Bool), initialURL: urlDict["spotify"] as? String, currentURL: (urldict["spotify"] as? String), completion: {[weak self] err in
            guard let strongSelf = self else {return}
            if let error = err {
                completion(error)
                return
            } else {
                completion(nil)
                return
            }
        })
    }
    
    func processAppleURL(dict:NSDictionary, urldict:NSDictionary, completion: @escaping (([Error]?) -> Void)) {
        
        guard currentAlbum.apple?.url != initialAlbum.apple?.url || (dict["apple"] as? Bool) != boolDict["apple"] || urlDict["apple"] != (urldict["apple"] as? String) else {
            completion(nil)
            return
        }
        
        EditAlbumHelper.shared.processAppleMusic(initialAlbum: initialAlbum,currentAlbum: currentAlbum, initialStatus: boolDict["apple"] as? Bool, currentStatus: (dict["apple"] as? Bool), initialURL: urlDict["apple"] as? String, currentURL: (urldict["apple"] as? String), completion: {[weak self] err in
            guard let strongSelf = self else {return}
            if let error = err {
                completion(error)
                return
            } else {
                completion(nil)
                return
            }
        })
    }
    
    func processSoundcloudURL(dict:NSDictionary, urldict:NSDictionary, completion: @escaping (([Error]?) -> Void)) {
        
        guard currentAlbum.soundcloud?.url != initialAlbum.soundcloud?.url || (dict["soundcloud"] as? Bool) != boolDict["soundcloud"] || urlDict["soundcloud"] != (urldict["soundcloud"] as? String) else {
            completion(nil)
            return
        }
        
        EditAlbumHelper.shared.processSoundcloud(initialAlbum: initialAlbum,currentAlbum: currentAlbum, initialStatus: boolDict["soundcloud"] as? Bool, currentStatus: (dict["soundcloud"] as? Bool), initialURL: urlDict["soundcloud"] as? String, currentURL: (urldict["soundcloud"] as? String), completion: {[weak self] err in
            guard let strongSelf = self else {return}
            if let error = err {
                completion(error)
                return
            } else {
                completion(nil)
                return
            }
        })
    }
    
    func processYoutubeMusicURL(dict:NSDictionary, urldict:NSDictionary, completion: @escaping (([Error]?) -> Void)) {
        
        guard currentAlbum.youtubeMusic?.url != initialAlbum.youtubeMusic?.url || (dict["youtubemusic"] as? Bool) != boolDict["youtubemusic"] || urlDict["youtubemusic"] != (urldict["youtubemusic"] as? String) else {
            completion(nil)
            return
        }
        
        EditAlbumHelper.shared.processYoutubeMusic(initialAlbum: initialAlbum,currentAlbum: currentAlbum, initialStatus: boolDict["youtubemusic"] as? Bool, currentStatus: (dict["youtubemusic"] as? Bool), initialURL: urlDict["youtubemusic"] as? String, currentURL: (urldict["youtubemusic"] as? String), completion: {[weak self] err in
            guard let strongSelf = self else {return}
            if let error = err {
                completion(error)
                return
            } else {
                completion(nil)
                return
            }
        })
    }
    
    func processAmazonURL(dict:NSDictionary, urldict:NSDictionary, completion: @escaping (([Error]?) -> Void)) {
        
        guard currentAlbum.amazon?.url != initialAlbum.amazon?.url || (dict["amazon"] as? Bool) != boolDict["amazon"] || urlDict["amazon"] != (urldict["amazon"] as? String) else {
            completion(nil)
            return
        }
        
        EditAlbumHelper.shared.processAmazon(initialAlbum: initialAlbum,currentAlbum: currentAlbum, initialStatus: boolDict["amazon"] as? Bool, currentStatus: (dict["amazon"] as? Bool), initialURL: urlDict["amazon"] as? String, currentURL: (urldict["amazon"] as? String), completion: {[weak self] err in
            guard let strongSelf = self else {return}
            if let error = err {
                completion(error)
                return
            } else {
                completion(nil)
                return
            }
        })
    }
    
    func processDeezerURL(dict:NSDictionary, urldict:NSDictionary, completion: @escaping (([Error]?) -> Void)) {
        
        guard currentAlbum.deezer?.url != initialAlbum.deezer?.url || (dict["deezer"] as? Bool) != boolDict["deezer"] || urlDict["deezer"] != (urldict["deezer"] as? String) else {
            completion(nil)
            return
        }
        
        EditAlbumHelper.shared.processDeezer(initialAlbum: initialAlbum,currentAlbum: currentAlbum, initialStatus: boolDict["deezer"] as? Bool, currentStatus: (dict["deezer"] as? Bool), initialURL: urlDict["deezer"] as? String, currentURL: (urldict["deezer"] as? String), completion: {[weak self] err in
            guard let strongSelf = self else {return}
            if let error = err {
                completion(error)
                return
            } else {
                completion(nil)
                return
            }
        })
    }
    
    func processTidalURL(dict:NSDictionary, urldict:NSDictionary, completion: @escaping (([Error]?) -> Void)) {
        
        guard currentAlbum.tidal?.url != initialAlbum.tidal?.url || (dict["tidal"] as? Bool) != boolDict["tidal"] || urlDict["tidal"] != (urldict["tidal"] as? String) else {
            completion(nil)
            return
        }
        
        EditAlbumHelper.shared.processTidal(initialAlbum: initialAlbum,currentAlbum: currentAlbum, initialStatus: boolDict["tidal"] as? Bool, currentStatus: (dict["tidal"] as? Bool), initialURL: urlDict["tidal"] as? String, currentURL: (urldict["tidal"] as? String), completion: {[weak self] err in
            guard let strongSelf = self else {return}
            if let error = err {
                completion(error)
                return
            } else {
                completion(nil)
                return
            }
        })
    }
    
    func processNapsterURL(dict:NSDictionary, urldict:NSDictionary, completion: @escaping (([Error]?) -> Void)) {
        
        guard currentAlbum.napster?.url != initialAlbum.napster?.url || (dict["napster"] as? Bool) != boolDict["napster"] || urlDict["napster"] != (urldict["napster"] as? String) else {
            completion(nil)
            return
        }
        
        EditAlbumHelper.shared.processNapster(initialAlbum: initialAlbum,currentAlbum: currentAlbum, initialStatus: boolDict["napster"] as? Bool, currentStatus: (dict["napster"] as? Bool), initialURL: urlDict["napster"] as? String, currentURL: (urldict["napster"] as? String), completion: {[weak self] err in
            guard let strongSelf = self else {return}
            if let error = err {
                completion(error)
                return
            } else {
                completion(nil)
                return
            }
        })
    }
    
    func processSpinrillaURL(dict:NSDictionary, urldict:NSDictionary, completion: @escaping (([Error]?) -> Void)) {
        
        guard currentAlbum.spinrilla?.url != initialAlbum.spinrilla?.url || (dict["spinrilla"] as? Bool) != boolDict["spinrilla"] || urlDict["spinrilla"] != (urldict["spinrilla"] as? String) else {
            completion(nil)
            return
        }
        
        EditAlbumHelper.shared.processSpinrilla(initialAlbum: initialAlbum,currentAlbum: currentAlbum, initialStatus: boolDict["spinrilla"] as? Bool, currentStatus: (dict["spinrilla"] as? Bool), initialURL: urlDict["spinrilla"] as? String, currentURL: (urldict["spinrilla"] as? String), completion: {[weak self] err in
            guard let strongSelf = self else {return}
            if let error = err {
                completion(error)
                return
            } else {
                completion(nil)
                return
            }
        })
    }
    
    func processTracks(completion: @escaping (([Error]?) -> Void)) {
        if currentAlbum.tracks == nil && initialAlbum.tracks == nil {
            completion(nil)
            return
        }
        
        if currentAlbum.tracks == initialAlbum.tracks {
            completion(nil)
            return
        }
        
        EditAlbumHelper.shared.processTracks(initialAlbum: initialAlbum,currentAlbum: currentAlbum, completion: {[weak self] err in
            guard let strongSelf = self else {return}

            if let error = err {
                completion(error)
                return
            } else {
                completion(nil)
                return
            }
        })
    }
    
    func processSongs(completion: @escaping (([Error]?) -> Void)) {
        if currentAlbum.songs == nil && initialAlbum.songs == nil {
            completion(nil)
            return
        }
        
        if currentAlbum.songs == initialAlbum.songs {
            completion(nil)
            return
        }
        
        EditAlbumHelper.shared.processSongs(initialAlbum: initialAlbum,currentAlbum: currentAlbum, completion: {[weak self] err in
            guard let strongSelf = self else {return}

            if let error = err {
                completion(error)
                return
            } else {
                completion(nil)
                return
            }
        })
    }
    
    func processVideos(completion: @escaping (([Error]?) -> Void)) {
        if currentAlbum.videos == nil && initialAlbum.videos == nil {
            completion(nil)
            return
        }
        if currentAlbum.videos == initialAlbum.videos && currentAlbum.officialAlbumVideo == initialAlbum.officialAlbumVideo {
            completion(nil)
            return
        }
        
        EditAlbumHelper.shared.processVideos(initialAlbum: initialAlbum,currentAlbum: currentAlbum, completion: {[weak self] err in
            guard let strongSelf = self else {return}
            if let error = err {
                completion(error)
                return
            } else {
                completion(nil)
                return
            }
        })
    }
    
    func processInstrumentals(completion: @escaping (([Error]?) -> Void)) {
        if currentAlbum.instrumentals == nil && initialAlbum.instrumentals == nil {
            completion(nil)
            return
        }
        
        if currentAlbum.instrumentals == initialAlbum.instrumentals {
            completion(nil)
            return
        }
        
        EditAlbumHelper.shared.processInstrumentals(initialAlbum: initialAlbum,currentAlbum: currentAlbum, completion: {[weak self] err in
            guard let strongSelf = self else {return}

            if let error = err {
                completion(error)
                return
            } else {
                completion(nil)
                return
            }
        })
    }
    
    func processDeluxe(completion: @escaping (([Error]?) -> Void)) {
        if currentAlbum.deluxes == nil && initialAlbum.deluxes == nil {
            completion(nil)
            return
        }
        if currentAlbum.deluxes == initialAlbum.deluxes {
            completion(nil)
            return
        }
    
        
        EditAlbumHelper.shared.processDeluxe(initialAlbum: initialAlbum,currentAlbum: currentAlbum, completion: {[weak self] err in
            guard let strongSelf = self else {return}
            if let error = err {
                completion(error)
                return
            } else {
                completion(nil)
                return
            }
        })
    }
    
    func processOtherVersions(completion: @escaping (([Error]?) -> Void)) {
        if currentAlbum.otherVersions == nil && initialAlbum.otherVersions == nil {
            completion(nil)
            return
        }
        if currentAlbum.otherVersions == initialAlbum.otherVersions {
            completion(nil)
            return
        }
    
        
        EditAlbumHelper.shared.processOtherVersions(initialAlbum: initialAlbum,currentAlbum: currentAlbum, completion: {[weak self] err in
            guard let strongSelf = self else {return}
            if let error = err {
                completion(error)
                return
            } else {
                completion(nil)
                return
            }
        })
    }
    
    func processIsDeluxes(completion: @escaping (([Error]?) -> Void)) {
        if currentAlbum.isDeluxe == nil && initialAlbum.isDeluxe == nil {
            completion(nil)
            return
        }
        if currentAlbum.isDeluxe == initialAlbum.isDeluxe && deluxeOf == currentAlbum.isDeluxe?.standardEdition {
            completion(nil)
            return
        }
    
        
        EditAlbumHelper.shared.processisDeluxees(initialAlbum: initialAlbum,currentAlbum: currentAlbum, initSE: deluxeOf, completion: {[weak self] err in
            guard let strongSelf = self else {return}
            if let error = err {
                completion(error)
                return
            } else {
                completion(nil)
                return
            }
        })
    }
    
    func processIsOtherVersions(completion: @escaping (([Error]?) -> Void)) {
        if currentAlbum.isOtherVersion == nil && initialAlbum.isOtherVersion == nil {
            completion(nil)
            return
        }
        if currentAlbum.isOtherVersion == initialAlbum.isOtherVersion && otherVersionsOf == currentAlbum.isOtherVersion?.standardEdition {
            completion(nil)
            return
        }
    
        
        EditAlbumHelper.shared.processIsOtherVersions(initialAlbum: initialAlbum,currentAlbum: currentAlbum, initSE: otherVersionsOf, completion: {[weak self] err in
            guard let strongSelf = self else {return}
            if let error = err {
                completion(error)
                return
            } else {
                completion(nil)
                return
            }
        })
    }
    
    func processVerificationLevel(completion: @escaping ((Error?) -> Void)) {
        guard currentAlbum.verificationLevel != initialAlbum.verificationLevel else {
            completion(nil)
            return
        }
        EditAlbumHelper.shared.processVerificationLevel(initialAlbum: initialAlbum,currentAlbum: currentAlbum, completion: {[weak self] err in
            guard let strongSelf = self else {return}
            if let error = err {
                completion(error)
                return
            } else {
                completion(nil)
                return
            }
        })
    }
    
    func processIndustryCertification(completion: @escaping ((Error?) -> Void)) {
        guard currentAlbum.industryCerified != initialAlbum.industryCerified else {
            completion(nil)
            return
        }
        EditAlbumHelper.shared.processIndustryCertification(initialAlbum: initialAlbum,currentAlbum: currentAlbum, completion: {[weak self] err in
            guard let strongSelf = self else {return}
            if let error = err {
                completion(error)
                return
            } else {
                completion(nil)
                return
            }
        })
    }
    
    func processStatus(completion: @escaping ((Error?) -> Void)) {
        guard currentAlbum.isActive != initialAlbum.isActive else {
            completion(nil)
            return
        }
        EditAlbumHelper.shared.processStatus(initialAlbum: initialAlbum,currentAlbum: currentAlbum, completion: {[weak self] err in
            guard let strongSelf = self else {return}
            if let error = err {
                completion(error)
                return
            } else {
                completion(nil)
                return
            }
        })
    }
    
    //MARK: - Segues
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "editAlbumToTonesPick" {
            if let viewController: SelectTonesPickItemViewController = segue.destination as? SelectTonesPickItemViewController {
                viewController.array = arr
                viewController.prevPage = prevPage
                if prevPage == "editAlbum" {
                    switch arr {
                    case "video":
                        viewController.exeptions = videosArr
                        viewController.editAlbumVideosDelegate = self
                    case "song":
                        viewController.exeptions = songsArr
                        viewController.editAlbumSongsDelegate = self
                    case "person":
                        switch tbsender {
                        case "mainartist":
                            viewController.exeptions = mainArtistsArr
                            viewController.editAlbumPersonsDelegate = self
                        case "allartist":
                            viewController.exeptions = allArtistsArr
                            viewController.editAlbumPersonsDelegate = self
                        case "producer":
                            viewController.exeptions = producersArr
                            viewController.editAlbumPersonsDelegate = self
                        case "writer":
                            viewController.exeptions = writersArr
                            viewController.editAlbumPersonsDelegate = self
                        case "mixEngineer":
                            viewController.exeptions = mixEngineerArr
                            viewController.editAlbumPersonsDelegate = self
                        case "masteringEngineer":
                            viewController.exeptions = masteringEngineerArr
                            viewController.editAlbumPersonsDelegate = self
                        case "recordingEngineer":
                            viewController.exeptions = recordingEngineerArr
                            viewController.editAlbumPersonsDelegate = self
                        default:
                            break
                        }
                    case "track":
                        viewController.exeptions = trackExceptionsArr
                        viewController.editAlbumTracksDelegate = self
                    case "instrumental":
                        viewController.exeptions = instrumentalsArr
                        viewController.editAlbumInstrumentalsDelegate = self
                    case "song":
                        switch tbsender {
                        case "deluxe":
                            viewController.exeptions = deluxesArr
                            viewController.editAlbumAlbumsDelegate = self
                        case "otherVersion":
                            viewController.exeptions = songOtherVersionsArr
                            viewController.editAlbumAlbumsDelegate = self
                        default:
                            break
                        }
                    default:
                        break
                    }
                }
                if prevPage == "editAlbumAll" {
                    viewController.editAlbumAllAlbumsDelegate = self
                }
            }
        }
    }

    //MARK: - Keyboard Dismissals

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @objc func dismissKeyboard2() {
        NotificationCenter.default.post(name: adminDashboardStopSpinnerNotify, object: nil)
//        personTikTokURL.textColor = .white
//        personTwitterURL.textColor = .white
//        personInstagramURL.textColor = .white
//        personSpinrillaURL.textColor = .white
//        personNapsterURL.textColor = .white
//        personTidalURL.textColor = .white
//        personDeezerURL.textColor = .white
//        personAmazonURL.textColor = .white
//        personYoutubeMusicURL.textColor = .white
//        personSoundcloudURL.textColor = .white
//        personYoutubeChannelURL.textColor = .white
//        personAppleMusicURL.textColor = .white
//        personSpotifyURL.textColor = .white
//        personLegalName.textColor = .white
        name.textColor = .white
        imageURL.textColor = .white
        previewURL.textColor = .white
        setUpPage()
        view.endEditing(true)
    }
    
    @objc func dismissKeyboard3() {
        currentAlbum.isDeluxe!.standardEdition = deluxeHold[0]
        deluxeOfTextField.text = "\(deluxeHold[1]) - \(deluxeHold[0])"
        view.endEditing(true)
    }
    
    @objc func dismissKeyboard4() {
        currentAlbum.isOtherVersion!.standardEdition = otherVersionsHold[0]
        otherVersionOfTextField.text = "\(otherVersionsHold[1]) - \(otherVersionsHold[0])"
        view.endEditing(true)
    }
    
    //MARK: - Utilities
    func scrollToTop() {
        var offset = CGPoint(
            x: -scrollView.contentInset.left,
            y: -scrollView.contentInset.top)

        if #available(iOS 11.0, *) {
            offset = CGPoint(
                x: -scrollView.adjustedContentInset.left,
                y: -scrollView.adjustedContentInset.top)
        }
        scrollView.setContentOffset(offset, animated: true)
    }

}

extension EditAlbumViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func presentPhotoActionSheet() {
        let actionSheet = UIAlertController(title: "Open photo library?", message: nil, preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
        actionSheet.addAction(UIAlertAction(title: "Yes", style: .default, handler: { [weak self] _ in
            self?.openGallery()
        
        }))
        actionSheet.view.tintColor = Constants.Colors.redApp
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
        
        image.image = selectedImage
        imageURL.text = "New Image Selected"
        imageURL.textColor = .green
        newImage = selectedImage
        currentAlbum.manualImageURL = "NEW"
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
}

extension EditAlbumViewController: UIDocumentPickerDelegate {
    
    func openFiles() {
        let documentPicker:UIDocumentPickerViewController!
        documentPicker = UIDocumentPickerViewController(documentTypes: [kUTTypeMP3 as String, kUTTypeWaveformAudio as String], in: .import)
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
//        print(newUrls.first!)
        newPreview = newUrls.first
        guard newPreview == newUrls.first else {
            return
        }
        
        let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        var sandboxFileURL:URL!
        sandboxFileURL = dir.appendingPathComponent(newPreview!.lastPathComponent)
        
        if FileManager.default.fileExists(atPath: sandboxFileURL.path) {
            previewURL.text = newPreview!.lastPathComponent as String
            previewURL.textColor = .green
            currentAlbum.manualPreviewURL = "NEW"
        }
        else {
            do {
                try FileManager.default.copyItem(at: newPreview!, to: sandboxFileURL)
                previewURL.text = newPreview!.lastPathComponent as String
                previewURL.textColor = .green
                currentAlbum.manualPreviewURL = "NEW"
            }
            catch {
                print("Error: \(error)")
            }
        }
    }
    
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        
    }
}

extension EditAlbumViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func pickerSelected(row: Int, pickerView: UIPickerView) {
        if pickerView == albumPickerView {
            var arr:[AlbumData] = []
            arr.append(contentsOf: AllAlbumsInDatabaseArray)
            let a = AllAlbumsInDatabaseArray[row]
            currentAlbum = arr[row]
            let b = a
            
            initialAlbum.toneDeafAppId = b.toneDeafAppId
            initialAlbum.instrumentals = b.instrumentals
            initialAlbum.dateRegisteredToApp = b.dateRegisteredToApp
            initialAlbum.timeRegisteredToApp = b.timeRegisteredToApp
            initialAlbum.tracks = b.tracks
            initialAlbum.songs = b.songs
            initialAlbum.videos = b.videos
            initialAlbum.merch = b.merch
            initialAlbum.name = b.name
            initialAlbum.mainArtist = b.mainArtist
            initialAlbum.allArtists = b.allArtists
            initialAlbum.producers = b.producers
            initialAlbum.writers = b.writers
            initialAlbum.mixEngineers = b.mixEngineers
            initialAlbum.masteringEngineers = b.masteringEngineers
            initialAlbum.recordingEngineers = b.recordingEngineers
            initialAlbum.favoritesOverall = b.favoritesOverall
            initialAlbum.manualImageURL = b.manualImageURL
            initialAlbum.manualPreviewURL = b.manualPreviewURL
            initialAlbum.numberofTracks = b.numberofTracks
            initialAlbum.apple = b.apple
            initialAlbum.spotify = b.spotify
            initialAlbum.soundcloud = b.soundcloud
            initialAlbum.youtubeMusic = b.youtubeMusic
            initialAlbum.amazon = b.amazon
            initialAlbum.deezer = b.deezer
            initialAlbum.spinrilla = b.spinrilla
            initialAlbum.napster = b.napster
            initialAlbum.tidal = b.tidal
            initialAlbum.officialAlbumVideo = b.officialAlbumVideo
            initialAlbum.isActive = b.isActive
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        var nor = 0
        if pickerView == albumPickerView {
           nor = AllAlbumsInDatabaseArray.count
        }
        
        switch pickerView {
        case deluxeOfPickerView:
            nor = allAlbums.count
        case otherVersionOfPickerView:
            nor = allAlbums.count
        default:
            break
        }
        return nor
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        var nor = ""
        if pickerView == albumPickerView {
            nor = "\(AllAlbumsInDatabaseArray[row].name) -- \(AllAlbumsInDatabaseArray[row].toneDeafAppId)"
        }
        switch pickerView {
        case deluxeOfPickerView:
            nor = "\(allAlbums[row].name) -- \(allAlbums[row].toneDeafAppId)"
        case otherVersionOfPickerView:
            nor = "\(allAlbums[row].name) -- \(allAlbums[row].toneDeafAppId)"
        default:
            break
        }
        return nor
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == albumPickerView {
        pickerSelected(row: row, pickerView: pickerView)
        }
        switch pickerView {
        case deluxeOfPickerView:
            deluxeHold = [allAlbums[row].toneDeafAppId, allAlbums[row].name]
        case otherVersionOfPickerView:
            otherVersionsHold = [allAlbums[row].toneDeafAppId, allAlbums[row].name]
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
        if pickerView == albumPickerView {
           doneButton = UIBarButtonItem(title: "Select", style: UIBarButtonItem.Style.done, target: self, action: #selector(dismissKeyboard2))
        }
        if pickerView == deluxeOfPickerView {
           doneButton = UIBarButtonItem(title: "Select", style: UIBarButtonItem.Style.done, target: self, action: #selector(dismissKeyboard3))
        }
        if pickerView == otherVersionOfPickerView {
           doneButton = UIBarButtonItem(title: "Select", style: UIBarButtonItem.Style.done, target: self, action: #selector(dismissKeyboard4))
        }
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItem.Style.plain, target: self, action: #selector(dismissKeyboard))

        if currentAlbum == nil {
            toolBar.setItems([spaceButton, doneButton], animated: false)
        }
        else
        {
            toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        }
        toolBar.isUserInteractionEnabled = true

        textField.inputView = pickerView
        textField.inputAccessoryView = toolBar
    }
}

extension EditAlbumViewController : UITableViewDataSource, UITableViewDelegate {
    func getPerson(personIdFull: String, completion: @escaping (PersonData) -> Void) {
        let word = personIdFull.split(separator: "Æ")
        let id = String(word[0])
        DatabaseManager.shared.fetchPersonData(person: id, completion: { result in
            switch result {
            case .success(let person):
                completion(person)
            case .failure(let err):
                print("b  bk"+err.localizedDescription)
            }
        })
    }
    
    func getSong(songIdFull: String, completion: @escaping (SongData) -> Void) {
        let word = songIdFull.split(separator: "Æ")
        let id = String(word[0])
        DatabaseManager.shared.findSongById(songId: id, completion: { result in
            switch result {
            case .success(let song):
                completion(song)
            case .failure(let err):
                print("dsvgredfjbhxbdfzx"+err.localizedDescription)
            }
        })
    }
    
    func getAlbum(albumIdFull: String, completion: @escaping (AlbumData) -> Void) {
        let word = albumIdFull.split(separator: "Æ")
        let id = String(word[0])
        DatabaseManager.shared.findAlbumById(albumId: id, completion: { result in
            switch result {
            case .success(let album):
                completion(album)
            case .failure(let err):
                print("dsvgredfjbhxbdfzx"+err.localizedDescription)
            }
        })
    }
    
    func getVideo(videoIdFull: String, completion: @escaping (VideoData) -> Void) {
        let word = videoIdFull.split(separator: "Æ")
        let id = String(word[0])
        DatabaseManager.shared.findVideoById(videoid: id, completion: { result in
            switch result {
            case .success(let video):
                completion(video)
            case .failure(let err):
                print("dsvgredfxbdfzx"+err.localizedDescription)
            }
        })
    }
    
    func getInstrumental(instrumentalIdFull: String, completion: @escaping (InstrumentalData) -> Void) {
        let word = instrumentalIdFull.split(separator: "Æ")
        let id = String(word[0])
        DatabaseManager.shared.findInstrumentalById(instrumentalId: id, completion: { result in
            switch result {
            case .success(let instrumental):
                completion(instrumental)
            case .failure(let err):
                print("dsvgredfxbdfzx"+err.localizedDescription)
            }
        })
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch tableView {
        case mainArtistsTableView:
            return mainArtistsArr.count
        case allArtistsTableView:
            return allArtistsArr.count
        case producersTableView:
            return producersArr.count
        case writersTableView:
            return writersArr.count
        case mixEngineerTableView:
            return mixEngineerArr.count
        case masteringEngineerTableView:
            return masteringEngineerArr.count
        case recordingEngineerTableView:
            return recordingEngineerArr.count
        case tracksTableView:
            return tracksArr.count
        case songsTableView:
            return songsArr.count
        case videosTableView:
            return videosArr.count
        case instrumentalsTableView:
            return instrumentalsArr.count
        case deluxesTableView:
            return deluxesArr.count
        case otherVersionsTableView:
            return songOtherVersionsArr.count
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch tableView {
        case mainArtistsTableView:
            let cell = tableView.dequeueReusableCell(withIdentifier: "roleEditSongCell", for: indexPath) as! RoleEditSongCell
            if !mainArtistsArr.isEmpty {

                cell.setUp(person: mainArtistsArr[indexPath.row])
            }
            return cell
        case allArtistsTableView:
            let cell = tableView.dequeueReusableCell(withIdentifier: "roleEditSongCell", for: indexPath) as! RoleEditSongCell
            if !allArtistsArr.isEmpty {

                cell.setUp(person: allArtistsArr[indexPath.row])
            }
            return cell
        case producersTableView:
            let cell = tableView.dequeueReusableCell(withIdentifier: "roleEditSongCell", for: indexPath) as! RoleEditSongCell
            if !producersArr.isEmpty {

                cell.setUp(person: producersArr[indexPath.row])
            }
            return cell
        case writersTableView:
            let cell = tableView.dequeueReusableCell(withIdentifier: "roleEditSongCell", for: indexPath) as! RoleEditSongCell
            if !writersArr.isEmpty {

                cell.setUp(person: writersArr[indexPath.row])
            }
            return cell
        case mixEngineerTableView:
            let cell = tableView.dequeueReusableCell(withIdentifier: "roleEditSongCell", for: indexPath) as! RoleEditSongCell
            if !mixEngineerArr.isEmpty {

                cell.setUp(person: mixEngineerArr[indexPath.row])
            }
            return cell
        case masteringEngineerTableView:
            let cell = tableView.dequeueReusableCell(withIdentifier: "roleEditSongCell", for: indexPath) as! RoleEditSongCell
            if !masteringEngineerArr.isEmpty {

                cell.setUp(person: masteringEngineerArr[indexPath.row])
            }
            return cell
        case recordingEngineerTableView:
            let cell = tableView.dequeueReusableCell(withIdentifier: "roleEditSongCell", for: indexPath) as! RoleEditSongCell
            if !recordingEngineerArr.isEmpty {

                cell.setUp(person: recordingEngineerArr[indexPath.row])
            }
            return cell
        case tracksTableView:
            let cell = tableView.dequeueReusableCell(withIdentifier: "editAlbumTrackCell", for: indexPath) as! EditAlbumTrackCell
            if !tracksArr.isEmpty {
                let trackNums = Array(tracksArr.keys)
                var tNum:[Int] = []
                for val in trackNums {
                    let num = val.dropFirst(6)
                    tNum.append(Int(num)!)
                    tNum.sort()
                }
                let track = ["Track \(tNum[indexPath.row])":tracksArr["Track \(tNum[indexPath.row])"]!]
                cell.setUp(track: track, artistId: currentAlbum.toneDeafAppId)
            }
            return cell
        case songsTableView:
            let cell = tableView.dequeueReusableCell(withIdentifier: "roleEditSongCell", for: indexPath) as! RoleEditSongCell
            if !songsArr.isEmpty {
                cell.setUp(song: songsArr[indexPath.row], artistId: currentAlbum.toneDeafAppId)
            }
            return cell
        case videosTableView:
            let cell = tableView.dequeueReusableCell(withIdentifier: "editPersonVideoCell", for: indexPath) as! EditPersonVideoCell
            if !videosArr.isEmpty {
                cell.setUp(video: videosArr[indexPath.row], album: currentAlbum)
            }
            return cell
        case instrumentalsTableView:
            let cell = tableView.dequeueReusableCell(withIdentifier: "editPersonInstrumentalCell", for: indexPath) as! EditPersonInstrumentalCell
            if !instrumentalsArr.isEmpty {
                //print(personSongsArr[indexPath.row].songArtist, personSongsArr[indexPath.row].songProducers)
                cell.setUp(instrumental: instrumentalsArr[indexPath.row], artistId: currentAlbum.toneDeafAppId)
            }
            return cell
        case deluxesTableView:
            let cell = tableView.dequeueReusableCell(withIdentifier: "roleEditSongCell", for: indexPath) as! RoleEditSongCell
            if !deluxesArr.isEmpty {
                cell.setUp(album: deluxesArr[indexPath.row])
            }
            return cell
        case otherVersionsTableView:
            let cell = tableView.dequeueReusableCell(withIdentifier: "roleEditSongCell", for: indexPath) as! RoleEditSongCell
            if !songOtherVersionsArr.isEmpty {
                cell.setUp(album: songOtherVersionsArr[indexPath.row])
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
        switch tableView {
        case tracksTableView:
            let cell = tableView.cellForRow(at: indexPath) as! EditAlbumTrackCell
            alertController = UIAlertController(title: "Change Track Number",
                                                message: "Enter track number for \(cell.name.text!)",
                                                    preferredStyle: .alert)
            
            let addAction = UIAlertAction(title: "Change", style: .default, handler: {[weak self] _ in
                guard let strongSelf = self else {return}
                let field = alertController.textFields![0]
                if let tack = field.text {
                    if let track = Int(tack) {
                        if track > 40 {
                            mediumImpactGenerator.impactOccurred()
                            Utilities.showError2("Track number can't be over 40", actionText: "OK")
                            alertController.dismiss(animated: true, completion: nil)
                        } else {
                            if strongSelf.currentAlbum.tracks["Track \(track)"] != nil {
                                mediumImpactGenerator.impactOccurred()
                                Utilities.showError2("Album already has a track in that position.", actionText: "OK")
                            } else {
                                let initialtrack = cell.tackNumber.text!
                                strongSelf.tracksArr["Track \(track)"] = strongSelf.tracksArr["Track \(initialtrack)"]
                                strongSelf.tracksArr.removeValue(forKey: "Track \(initialtrack)")
                                strongSelf.currentAlbum.tracks["Track \(track)"] = strongSelf.currentAlbum.tracks["Track \(initialtrack)"]
                                strongSelf.currentAlbum.tracks.removeValue(forKey: "Track \(initialtrack)")
                                strongSelf.tracksTableView.reloadData()
                            }
                            alertController.dismiss(animated: true, completion: nil)
                        }
                    } else {
                        mediumImpactGenerator.impactOccurred()
                        Utilities.showError2("Track number invalid", actionText: "OK")
                        alertController.dismiss(animated: true, completion: nil)
                    }
                } else {
                    mediumImpactGenerator.impactOccurred()
                    Utilities.showError2("Track number required", actionText: "OK")
                    alertController.dismiss(animated: true, completion: nil)
                }
            })

            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
            { (action) in
                
            }
            alertController.addAction(cancelAction)
            alertController.addAction(addAction)
            alertController.addTextField()
            let field = alertController.textFields![0]
            field.keyboardType = .numberPad
            field.text = cell.tackNumber.text
            
            alertController.view.tintColor = Constants.Colors.redApp

            
            alertController.view.tintColor = UIColor.init(red: 182/255, green: 0/255, blue: 3/255, alpha: 1)
            self.present(alertController, animated: true)
            {
                // ...
            }
        case videosTableView:
            alertController = UIAlertController(title: "Change \(videosArr[indexPath.row].title) Relationship",
                                                    message: "Select the videos relationship to the album",
                                                    preferredStyle: .alert)
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc3 = storyboard.instantiateViewController(identifier: "editPersonRolesPopoverTableViewController") as
            EditPersonRolesPopoverTableViewController
            vc3.preferredContentSize = CGSize(width: 350, height: 240)
            vc3.tableView.isScrollEnabled = false
            alertController.setValue(vc3, forKey: "contentViewController")
            vc3.roleArr = ["Official Video", "Other Video"]
            vc3.tableView.reloadData()
            
            let addAction = UIAlertAction(title: "Change", style: .default, handler: {[weak self] _ in
                guard let strongSelf = self else {return}
                let cc = alertController.value(forKey: "contentViewController") as! EditPersonRolesPopoverTableViewController
                for i in 1 ... (cc.roleArr.count) {
                    let cell = cc.tableViewPopover.cellForRow(at: IndexPath(row: i-1, section: 0)) as! EditRolePopoverTableCellController
                    if cell.checkbox.on {
                        switch cell.role.text {
                        case "Official Video":
                            break
                        default:
                            if strongSelf.currentAlbum.officialAlbumVideo == strongSelf.videosArr[indexPath.row].toneDeafAppId {
                                strongSelf.currentAlbum.officialAlbumVideo = nil
                            }
                        }
                    }
                }
                DispatchQueue.main.async {[weak self]  in
                    guard let strongSelf = self else {return}
                    strongSelf.videosArr.sort(by: {$0.title < $1.title})
                    strongSelf.videosTableView.reloadData()
                    if strongSelf.videosArr.count < 6 {
                        strongSelf.videosHeightConstraint.constant = CGFloat(70*(strongSelf.videosArr.count))
                    } else {
                        strongSelf.videosHeightConstraint.constant = CGFloat(370)
                    }
                }
                
            })

            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
            { (action) in
                
            }
            alertController.addAction(cancelAction)
            alertController.addAction(addAction)
            alertController.view.tintColor = Constants.Colors.redApp
            self.present(alertController, animated: true) {[weak self] in
                guard let strongSelf = self else {return}
                var rolesel = ""
                let video = strongSelf.videosArr[indexPath.row].toneDeafAppId
                if strongSelf.currentAlbum.officialAlbumVideo == video {
                    rolesel = "Official Video"
                } else {
                    rolesel = "Other Video"
                }
                let cc = alertController.value(forKey: "contentViewController") as! EditPersonRolesPopoverTableViewController
                for i in 1 ... (cc.roleArr.count) {
                    let cell = cc.tableViewPopover.cellForRow(at: IndexPath(row: i-1, section: 0)) as! EditRolePopoverTableCellController
                    if rolesel == cell.role.text! {
                        cell.checkbox.setOn(true, animated: false)
                    }
                }
            }
        default:
            break
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            switch tableView {
            case mainArtistsTableView:
                if mainArtistsArr.count == 1 {
                    mediumImpactGenerator.impactOccurred()
                    Utilities.showError2("At least 1 main artist required.", actionText: "OK")
                }
                else {
                    mainArtistsArr.remove(at: indexPath.row)
                    currentAlbum.mainArtist = []
                    for song in mainArtistsArr {
                        currentAlbum.mainArtist.append("\(song.toneDeafAppId)")
                        currentAlbum.mainArtist.sort()
                    }
                    tableView.deleteRows(at: [indexPath], with: .fade)
                    if mainArtistsArr.count < 6 {
                        mainArtistsHeightConstraint.constant = CGFloat(50*(mainArtistsArr.count))
                    } else {
                        mainArtistsHeightConstraint.constant = CGFloat(270)
                    }
                }
            case allArtistsTableView:
                    allArtistsArr.remove(at: indexPath.row)
                    currentAlbum.allArtists = []
                    for song in allArtistsArr {
                        currentAlbum.allArtists!.append("\(song.toneDeafAppId)")
                        currentAlbum.allArtists!.sort()
                    }
                    tableView.deleteRows(at: [indexPath], with: .fade)
                    if allArtistsArr.count < 6 {
                        allartistsHeightConstraint.constant = CGFloat(50*(allArtistsArr.count))
                    } else {
                        allartistsHeightConstraint.constant = CGFloat(270)
                    }
            case producersTableView:
                if producersArr.count == 1 {
                    mediumImpactGenerator.impactOccurred()
                    Utilities.showError2("At least 1 producer required.", actionText: "OK")
                }
                else {
                    producersArr.remove(at: indexPath.row)
                    currentAlbum.producers = []
                    for song in producersArr {
                        currentAlbum.producers.append("\(song.toneDeafAppId)")
                        currentAlbum.producers.sort()
                    }
                    tableView.deleteRows(at: [indexPath], with: .fade)
                    if producersArr.count < 6 {
                        producersHeightConstraint.constant = CGFloat(50*(producersArr.count))
                    } else {
                        producersHeightConstraint.constant = CGFloat(270)
                    }
                }
            case writersTableView:
                    writersArr.remove(at: indexPath.row)
                    currentAlbum.writers = []
                    for song in writersArr {
                        currentAlbum.writers!.append("\(song.toneDeafAppId)")
                        currentAlbum.writers!.sort()
                    }
                    tableView.deleteRows(at: [indexPath], with: .fade)
                    if writersArr.count < 6 {
                        writersHeightConstraint.constant = CGFloat(50*(writersArr.count))
                    } else {
                        writersHeightConstraint.constant = CGFloat(270)
                    }
            case mixEngineerTableView:
                mixEngineerArr.remove(at: indexPath.row)
                currentAlbum.mixEngineers = []
                for song in mixEngineerArr {
                    currentAlbum.mixEngineers!.append("\(song.toneDeafAppId)")
                    currentAlbum.mixEngineers!.sort()
                }
                tableView.deleteRows(at: [indexPath], with: .fade)
                if mixEngineerArr.count < 6 {
                    mixEngineerHeightConstraint.constant = CGFloat(50*(mixEngineerArr.count))
                } else {
                    mixEngineerHeightConstraint.constant = CGFloat(270)
                }
            case masteringEngineerTableView:
                masteringEngineerArr.remove(at: indexPath.row)
                currentAlbum.masteringEngineers = []
                for song in masteringEngineerArr {
                    currentAlbum.masteringEngineers!.append("\(song.toneDeafAppId)")
                    currentAlbum.masteringEngineers!.sort()
                }
                tableView.deleteRows(at: [indexPath], with: .fade)
                if masteringEngineerArr.count < 6 {
                    masteringEngineerHeightConstraint.constant = CGFloat(50*(masteringEngineerArr.count))
                } else {
                    masteringEngineerHeightConstraint.constant = CGFloat(270)
                }
            case recordingEngineerTableView:
                recordingEngineerArr.remove(at: indexPath.row)
                currentAlbum.recordingEngineers = []
                for song in recordingEngineerArr {
                    currentAlbum.recordingEngineers!.append("\(song.toneDeafAppId)")
                    currentAlbum.recordingEngineers!.sort()
                }
                tableView.deleteRows(at: [indexPath], with: .fade)
                if recordingEngineerArr.count < 6 {
                    recordingEngineerHeightConstraint.constant = CGFloat(50*(recordingEngineerArr.count))
                } else {
                    recordingEngineerHeightConstraint.constant = CGFloat(270)
                }
            case songsTableView:
                let song = songsArr[indexPath.row]
                if currentAlbum.tracks.values.contains(song.toneDeafAppId) {
                    for (key,val) in currentAlbum.tracks {
                        if val == song.toneDeafAppId {
                            currentAlbum.tracks.removeValue(forKey: key)
                            tracksArr.removeValue(forKey: key)
                            tracksTableView.reloadData()
                            if tracksArr.count < 6 {
                                tracksHeightConstraint.constant = CGFloat(70*(tracksArr.count))
                            } else {
                                tracksHeightConstraint.constant = CGFloat(370)
                            }
                            break
                        }
                    }
                }
                songsArr.remove(at: indexPath.row)
                currentAlbum.songs = []
                for song in songsArr {
                    currentAlbum.songs!.append("\(song.toneDeafAppId)")
                    currentAlbum.songs!.sort()
                }
                tableView.deleteRows(at: [indexPath], with: .fade)
                songsArr.sort(by: {$0.name < $1.name})
                if songsArr.count < 6 {
                    songsHeightConstraint.constant = CGFloat(50*(songsArr.count))
                } else {
                    songsHeightConstraint.constant = CGFloat(270)
                }
            case videosTableView:
                if currentAlbum.officialAlbumVideo == videosArr[indexPath.row].toneDeafAppId {
                    currentAlbum.officialAlbumVideo = nil
                }
                videosArr.remove(at: indexPath.row)
                currentAlbum.videos = []
                for song in videosArr {
                    currentAlbum.videos!.append("\(song.toneDeafAppId)")
                    currentAlbum.videos!.sort()
                }
                tableView.deleteRows(at: [indexPath], with: .fade)
                if videosArr.count < 6 {
                    videosHeightConstraint.constant = CGFloat(70*(videosArr.count))
                } else {
                    videosHeightConstraint.constant = CGFloat(370)
                }
            case instrumentalsTableView:
                let song = instrumentalsArr[indexPath.row]
                if currentAlbum.tracks.values.contains(song.toneDeafAppId) {
                    for (key,val) in currentAlbum.tracks {
                        if val == song.toneDeafAppId {
                            currentAlbum.tracks.removeValue(forKey: key)
                            tracksArr.removeValue(forKey: key)
                            tracksTableView.reloadData()
                            if tracksArr.count < 6 {
                                tracksHeightConstraint.constant = CGFloat(70*(tracksArr.count))
                            } else {
                                tracksHeightConstraint.constant = CGFloat(370)
                            }
                            break
                        }
                    }
                }
                instrumentalsArr.remove(at: indexPath.row)
                currentAlbum.instrumentals = []
                for song in instrumentalsArr {
                    currentAlbum.instrumentals!.append("\(song.toneDeafAppId)")
                    currentAlbum.instrumentals!.sort()
                }
                tableView.deleteRows(at: [indexPath], with: .fade)
                instrumentalsArr.sort(by: {$0.instrumentalName! < $1.instrumentalName!})
                if instrumentalsArr.count < 6 {
                    instrumentalsHeightConstraint.constant = CGFloat(50*(instrumentalsArr.count))
                } else {
                    instrumentalsHeightConstraint.constant = CGFloat(270)
                }
            case deluxesTableView:
                deluxesArr.remove(at: indexPath.row)
                currentAlbum.deluxes = []
                for song in deluxesArr {
                    currentAlbum.deluxes!.append("\(song.toneDeafAppId)")
                    currentAlbum.deluxes!.sort()
                }
                tableView.deleteRows(at: [indexPath], with: .fade)
                if deluxesArr.count < 6 {
                    deluxesHeightConstraint.constant = CGFloat(50*(deluxesArr.count))
                } else {
                    deluxesHeightConstraint.constant = CGFloat(270)
                }
            case otherVersionsTableView:
                songOtherVersionsArr.remove(at: indexPath.row)
                currentAlbum.otherVersions = []
                for song in songOtherVersionsArr {
                    currentAlbum.otherVersions!.append("\(song.toneDeafAppId)")
                    currentAlbum.otherVersions!.sort()
                }
                tableView.deleteRows(at: [indexPath], with: .fade)
                if songOtherVersionsArr.count < 6 {
                    otherVersionsHeightConstraint.constant = CGFloat(50*(songOtherVersionsArr.count))
                } else {
                    otherVersionsHeightConstraint.constant = CGFloat(270)
                }
            default:
                break
            }
        }
    }
    
    
}

extension EditAlbumViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        switch textField {
        case hiddenAlbumTextField:
            if currentAlbum == nil {
                pickerSelected(row: 0, pickerView: albumPickerView)
            }
            else {
                var count = 0
                for per in AllAlbumsInDatabaseArray {
                    if per.toneDeafAppId == currentAlbum.toneDeafAppId {
                        pickerSelected(row: count, pickerView: albumPickerView)
                    } else {
                        count+=1
                    }
                }
            }
        default:
            break
        }
    }
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        switch textField {
        case deluxeOfTextField:
            currentAlbum.isDeluxe?.standardEdition = nil
            deluxeOfTextField.endEditing(true)
            return true
        case otherVersionOfTextField:
            currentAlbum.isOtherVersion?.standardEdition = nil
            otherVersionOfTextField.endEditing(true)
            return true
        default:
            return true
        }
    }
}

class EditAlbumTrackCell: UITableViewCell {
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var artist: UILabel!
    @IBOutlet weak var appId: UILabel!
    @IBOutlet weak var tackType: UILabel!
    @IBOutlet weak var tackNumber: UILabel!
    @IBOutlet weak var artwork: UIImageView!
    
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        artwork.image = nil
        name.text = ""
    }
    
    func setUp(track: [String:Any], artistId: String) {
        switch track[Array(track.keys)[0]] {
        case is SongData:
            let item = track[Array(track.keys)[0]] as! SongData
            name.text = item.name
            var songart:[String] = []
            GlobalFunctions.shared.getPersonNames(arr: item.songArtist, completion: {[weak self] per, err in
                guard let strongSelf = self else {return}
                if let err = err {
                    print("Error setting names: ", err)
                } else if let per = per {
                    songart = per
                    strongSelf.artist.text = songart.joined(separator: ", ")
                } else {
                    print("Error setting names: Reason Unknown")
                }
            })
            appId.text = "App ID: \(item.toneDeafAppId)"
            tackType.text = "Song"
            tackNumber.text = String((Array(track.keys)[0]).dropFirst(6))
            GlobalFunctions.shared.selectImageURL(song: item, completion: {[weak self] aimage in
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
        case is InstrumentalData:
            let item = track[Array(track.keys)[0]] as! InstrumentalData
            name.text = item.songName
            let per:[String] = Array(GlobalFunctions.shared.combine(item.artist,item.producers))
            GlobalFunctions.shared.getPersonNames(arr: per, completion: {[weak self] newper, err in
                guard let strongSelf = self else {return}
                if let err = err {
                    print("Error setting names: ", err)
                } else if let newper = newper {
                    strongSelf.artist.text = newper.joined(separator: ", ")
                } else {
                    print("Error setting names: Reason Unknown")
                }
            })
            appId.text = "App ID: \(item.toneDeafAppId)"
            tackType.text = "Instrumental"
            let tn:String = Array(track.keys)[0]
            tackNumber.text = String(tn.dropFirst(6))
            GlobalFunctions.shared.selectImageURL(instrumental: item, completion: {[weak self] aimage in
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
        default:
            break
        }
    }
}
