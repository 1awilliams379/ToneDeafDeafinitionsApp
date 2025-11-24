//
//  EditSongViewController.swift
//  ToneDeafDeafinitionsApp
//
//  Created by Tone Deaf on 7/17/22.
//  Copyright © 2022 GITEM Solutions. All rights reserved.
//

import UIKit
import CloudKit
import MobileCoreServices

protocol EditSongAllSongsDelegate: class {
    func songSelected(_ song: SongData)
}

protocol EditSongPersonsDelegate: class {
    func personAdded(_ person: PersonData)
}

protocol EditSongAlbumsDelegate: class {
    func albumAdded(_ albumAndData: [String?:AlbumData])
}

protocol EditSongVideosDelegate: class {
    func videoAdded(_ videoAndData: [String:VideoData])
}

protocol EditSongInstrumentalsDelegate: class {
    func instrumentalAdded(_ instrumental: InstrumentalData)
}

protocol EditSongSongsDelegate: class {
    func songAdded(_ song: SongData)
}

class EditSongViewController: UIViewController, EditSongAllSongsDelegate, EditSongPersonsDelegate, EditSongAlbumsDelegate, EditSongVideosDelegate, EditSongInstrumentalsDelegate, EditSongSongsDelegate {
    
    
    static let shared = EditSongViewController()
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
    
    var errorCountForController:Int = 0
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var songArtistsTableView: UITableView!
    @IBOutlet weak var songArtistsHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var songProducersTableView: UITableView!
    @IBOutlet weak var songProducersHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var songWritersTableView: UITableView!
    @IBOutlet weak var songWritersHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var songMixEngineerTableView: UITableView!
    @IBOutlet weak var songMixEngineerHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var songMasteringEngineerTableView: UITableView!
    @IBOutlet weak var songMasteringEngineerHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var songRecordingEngineerTableView: UITableView!
    @IBOutlet weak var songRecordingEngineerHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var songAlbumsTableView: UITableView!
    @IBOutlet weak var songAlbumsHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var songVideosTableView: UITableView!
    @IBOutlet weak var songVideosHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var songInstrumentalsTableView: UITableView!
    @IBOutlet weak var songInstrumentalsHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var songRemixesTableView: UITableView!
    @IBOutlet weak var songRemixesHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var songOtherVersionsTableView: UITableView!
    @IBOutlet weak var songOtherVersionsHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var changeSongButton: UIButton!
    @IBOutlet weak var songImageURL: CopyableLabel!
    @IBOutlet weak var songImage: UIImageView!
    @IBOutlet weak var songName: CopyableLabel!
    @IBOutlet weak var songPreviewURL: CopyableLabel!
    @IBOutlet weak var appIDLAbel: CopyableLabel!
    @IBOutlet weak var favoritesLabel: CopyableLabel!
    @IBOutlet weak var dateLabel: CopyableLabel!
    @IBOutlet weak var timeLabel: CopyableLabel!
    @IBOutlet weak var songSpotifyURL: UILabel!
    @IBOutlet weak var songRemoveSpotifyURLButton: UIButton!
    @IBOutlet weak var songAppleMusicURL: UILabel!
    @IBOutlet weak var songRemoveAppleMusicURLButton: UIButton!
    @IBOutlet weak var songSoundcloudURL: UILabel!
    @IBOutlet weak var songRemoveSoundcloudURLButton: UIButton!
    @IBOutlet weak var songYoutubeMusicURL: UILabel!
    @IBOutlet weak var songRemoveYoutubeMusicURLButton: UIButton!
    @IBOutlet weak var songAmazonURL: UILabel!
    @IBOutlet weak var songRemoveAmazonURLButton: UIButton!
    @IBOutlet weak var songDeezerURL: UILabel!
    @IBOutlet weak var songRemoveDeezerURLButton: UIButton!
    @IBOutlet weak var songTidalURL: UILabel!
    @IBOutlet weak var songRemoveTidalURLButton: UIButton!
    @IBOutlet weak var songNapsterURL: UILabel!
    @IBOutlet weak var songRemoveNapsterURLButton: UIButton!
    @IBOutlet weak var songSpinrillaURL: UILabel!
    @IBOutlet weak var songRemoveSpinrillaURLButton: UIButton!
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
    @IBOutlet weak var explicityControl: UISegmentedControl!
    @IBOutlet weak var remixControl: UISegmentedControl!
    @IBOutlet weak var remixOfStackView: UIStackView!
    @IBOutlet weak var remixOfTextField: UITextField!{
        didSet {
            let placeholderText = NSAttributedString(string: "If album has standard edition in app",
                                                     attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray.withAlphaComponent(0.4)])
            
            remixOfTextField.attributedPlaceholder = placeholderText
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
    @IBOutlet weak var songStatusControl: UISegmentedControl!
    @IBOutlet weak var songUpdateButton: UIButton!
    
    var newImage:UIImage!
    var newPreview:URL!
    var currentFileType = ""
    var arr = ""
    var prevPage = ""
    var tbsender:String!
    
    var remixAlbum = false
    var remixOf:String!
    var remixHold:[String]!
    var otherVersionsAlbum = false
    var otherVersionsOf:String!
    var otherVersionsHold:[String]!
    
    var allSongs:[SongData]!
    
    var songArtistsArr:[PersonData] = []
    var songProducersArr:[PersonData] = []
    var songWritersArr:[PersonData] = []
    var songMixEngineerArr:[PersonData] = []
    var songMasteringEngineerArr:[PersonData] = []
    var songRecordingEngineerArr:[PersonData] = []
    var songAlbumsArr:[AlbumData] = []
    var songVideosArr:[VideoData] = []
    var songInstrumentalsArr:[InstrumentalData] = []
    var songRemixesArr:[SongData] = []
    var songOtherVersionsArr:[SongData] = []
    
    var albumTrackArr:[String:String] = [:]
    var initAlbumTrackArr:[String:String] = [:]
    
    var songPickerView = UIPickerView()
    var otherVersionOfPickerView = UIPickerView()
    var remixOfPickerView = UIPickerView()
    
    var progressView:UIProgressView!
    var totalProgress:Float = 0
    var progressCompleted:Float = 0
    var alertView:UIAlertController!
    
    let hiddenSongTextField =  UITextField(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    
    var currentSong:SongData!
    let initialSong = SongData(toneDeafAppId: "", instrumentals: [], albums: [], videos: [], merch: nil, name: "", dateRegisteredToApp: "", timeRegisteredToApp: "", songArtist: [], songProducers: [], songWriters: nil, songMixEngineer: nil, songMasteringEngineer: nil, songRecordingEngineer: nil, favoritesOverall: 0, manualImageURL: nil, manualPreviewURL: nil, apple: nil, spotify: nil, soundcloud: nil, youtubeMusic: nil, amazon: nil, deezer: nil, spinrilla: nil, napster: nil, tidal: nil, officialVideo: nil, audioVideo: nil,lyricVideo:nil, remixes: nil, isRemix:nil, isOtherVersion: nil, otherVersions: nil, explicit: nil, industryCerified: nil, verificationLevel: nil, isActive: false)
    
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
        DatabaseManager.shared.fetchAllSongsFromDatabase(completion: {[weak self] songs in
            guard let strongSelf = self else {return}
            AllSongsInDatabaseArray = songs
            strongSelf.allSongs = songs
            strongSelf.setUpElements()
            strongSelf.songSelected(strongSelf.currentSong)
        })
    }
    
    deinit {
        print("📗 Edit Song view controller deinitialized.")
        AllPersonsInDatabaseArray = nil
        AllVideosInDatabaseArray = nil
        AllSongsInDatabaseArray = nil
        AllAlbumsInDatabaseArray = nil
        AllInstrumentalsInDatabaseArray = nil
        AllBeatsInDatabaseArray = nil
        currentSong = nil
        newImage = nil
        newPreview = nil
        NotificationCenter.default.removeObserver(self)
    }
    
    func songSelected(_ song: SongData) {
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
        let a = song
        currentSong = song
        let b = a
        
        initialSong.toneDeafAppId = b.toneDeafAppId
        initialSong.instrumentals = b.instrumentals
        initialSong.albums = b.albums
        initialSong.videos = b.videos
        initialSong.merch = b.merch
        initialSong.name = b.name
        initialSong.songArtist = b.songArtist
        initialSong.songProducers = b.songProducers
        initialSong.songWriters = b.songWriters
        initialSong.songMixEngineer = b.songMixEngineer
        initialSong.songMasteringEngineer = b.songMasteringEngineer
        initialSong.songRecordingEngineer = b.songRecordingEngineer
        initialSong.favoritesOverall = b.favoritesOverall
        initialSong.manualImageURL = b.manualImageURL
        initialSong.manualPreviewURL = b.manualPreviewURL
        initialSong.spotify = b.spotify
        boolDict["spotify"] = b.spotify?.isActive
        urlDict["spotify"] = b.spotify?.spotifySongURL
        initialSong.apple = b.apple
        boolDict["apple"] = b.apple?.isActive
        urlDict["apple"] = b.apple?.appleSongURL
        initialSong.soundcloud = b.soundcloud
        boolDict["soundcloud"] = b.soundcloud?.isActive
        urlDict["soundcloud"] = b.soundcloud?.url
        initialSong.youtubeMusic = b.youtubeMusic
        boolDict["youtubemusic"] = b.youtubeMusic?.isActive
        urlDict["youtubemusic"] = b.youtubeMusic?.url
        initialSong.amazon = b.amazon
        boolDict["amazon"] = b.amazon?.isActive
        urlDict["amazon"] = b.amazon?.url
        initialSong.deezer = b.deezer
        boolDict["deezer"] = b.deezer?.isActive
        urlDict["deezer"] = b.deezer?.url
        initialSong.spinrilla = b.spinrilla
        boolDict["spinrilla"] = b.spinrilla?.isActive
        urlDict["spinrilla"] = b.spinrilla?.url
        initialSong.napster = b.napster
        boolDict["napster"] = b.napster?.isActive
        urlDict["napster"] = b.napster?.url
        initialSong.tidal = b.tidal
        boolDict["tidal"] = b.tidal?.isActive
        urlDict["tidal"] = b.tidal?.url
        initialSong.officialVideo = b.officialVideo
        initialSong.audioVideo = b.audioVideo
        initialSong.industryCerified = b.industryCerified
        initialSong.verificationLevel = b.verificationLevel
        initialSong.dateRegisteredToApp = b.dateRegisteredToApp
        initialSong.timeRegisteredToApp = b.timeRegisteredToApp
        initialSong.explicit = b.explicit
        initialSong.remixes = b.remixes
        initialSong.isRemix = b.isRemix
        initialSong.otherVersions = b.otherVersions
        initialSong.isOtherVersion = b.isOtherVersion
        initialSong.isActive = b.isActive
        
        dismissKeyboard2()
    }
    
    func setUpElements() {
        changeSongButton.setTitleColor(Constants.Colors.redApp, for: .normal)
        view.addSubview(hiddenSongTextField)
        hiddenSongTextField.isHidden = true
        hiddenSongTextField.inputView = songPickerView
        songPickerView.delegate = self
        songPickerView.dataSource = self
        pickerViewToolbar(textField: hiddenSongTextField, pickerView: songPickerView)
        hiddenSongTextField.delegate = self
        
        Utilities.styleTextField(remixOfTextField)
        addBottomLineToText(remixOfTextField)
        remixOfTextField.delegate = self
        
        remixOfTextField.inputView = remixOfPickerView
        remixOfPickerView.delegate = self
        remixOfPickerView.dataSource = self
        pickerViewToolbar(textField: remixOfTextField, pickerView: remixOfPickerView)
        
        Utilities.styleTextField(otherVersionOfTextField)
        addBottomLineToText(otherVersionOfTextField)
        otherVersionOfTextField.delegate = self
        
        otherVersionOfTextField.inputView = otherVersionOfPickerView
        otherVersionOfPickerView.delegate = self
        otherVersionOfPickerView.dataSource = self
        pickerViewToolbar(textField: otherVersionOfTextField, pickerView: otherVersionOfPickerView)
    }
    
    func setUpPage() {
        changeSongButton.setTitleColor(Constants.Colors.redApp, for: .normal)
        pickerViewToolbar(textField: hiddenSongTextField, pickerView: songPickerView)
        songName.text = currentSong.name
        appIDLAbel.text = currentSong.toneDeafAppId
        favoritesLabel.text = String(currentSong.favoritesOverall)
        remixOf = currentSong.isRemix?.standardEdition
        otherVersionsOf = currentSong.isOtherVersion?.standardEdition
        dateLabel.text = currentSong.dateRegisteredToApp
        timeLabel.text = currentSong.timeRegisteredToApp
        verificationLabel.text = String(currentSong.verificationLevel!)
        songArtistsTableView.delegate = self
        songArtistsTableView.dataSource = self
        setArtistsArr(arr: currentSong.songArtist, completion: {[weak self] _ in
            guard let strongSelf = self else {return}
            strongSelf.songArtistsArr.sort(by: {$0.name < $1.name})
            strongSelf.songArtistsTableView.reloadData()
            if strongSelf.songArtistsArr.count < 6 {
                strongSelf.songArtistsHeightConstraint.constant = CGFloat(50*(strongSelf.songArtistsArr.count))
            } else {
                strongSelf.songArtistsHeightConstraint.constant = CGFloat(270)
            }
        })
        songProducersTableView.delegate = self
        songProducersTableView.dataSource = self
        setProducersArr(arr: currentSong.songProducers, completion: {[weak self] _ in
            guard let strongSelf = self else {return}
            strongSelf.songProducersArr.sort(by: {$0.name < $1.name})
            strongSelf.songProducersTableView.reloadData()
            if strongSelf.songProducersArr.count < 6 {
                strongSelf.songProducersHeightConstraint.constant = CGFloat(50*(strongSelf.songProducersArr.count))
            } else {
                strongSelf.songProducersHeightConstraint.constant = CGFloat(270)
            }
        })
        songWritersTableView.delegate = self
        songWritersTableView.dataSource = self
        if let psa = currentSong.songWriters {
            setWritersArr(arr: psa, completion: {[weak self] _ in
                guard let strongSelf = self else {return}
                strongSelf.songWritersArr.sort(by: {$0.name < $1.name})
                strongSelf.songWritersTableView.reloadData()
                if strongSelf.songWritersArr.count < 6 {
                    strongSelf.songWritersHeightConstraint.constant = CGFloat(50*(strongSelf.songWritersArr.count))
                } else {
                    strongSelf.songWritersHeightConstraint.constant = CGFloat(270)
                }
            })
        } else {
            songWritersHeightConstraint.constant = 0
        }
        songMixEngineerTableView.delegate = self
        songMixEngineerTableView.dataSource = self
        if let psa = currentSong.songMixEngineer {
            setMixEngineerArr(arr: psa, completion: {[weak self] _ in
                guard let strongSelf = self else {return}
                strongSelf.songMixEngineerArr.sort(by: {$0.name < $1.name})
                strongSelf.songMixEngineerTableView.reloadData()
                if strongSelf.songMixEngineerArr.count < 6 {
                    strongSelf.songMixEngineerHeightConstraint.constant = CGFloat(50*(strongSelf.songMixEngineerArr.count))
                } else {
                    strongSelf.songMixEngineerHeightConstraint.constant = CGFloat(270)
                }
            })
        } else {
            songMixEngineerHeightConstraint.constant = 0
        }
        songMasteringEngineerTableView.delegate = self
        songMasteringEngineerTableView.dataSource = self
        if let psa = currentSong.songMasteringEngineer {
            setMasteringEngineerArr(arr: psa, completion: {[weak self] _ in
                guard let strongSelf = self else {return}
                strongSelf.songMasteringEngineerArr.sort(by: {$0.name < $1.name})
                strongSelf.songMasteringEngineerTableView.reloadData()
                if strongSelf.songMasteringEngineerArr.count < 6 {
                    strongSelf.songMasteringEngineerHeightConstraint.constant = CGFloat(50*(strongSelf.songMasteringEngineerArr.count))
                } else {
                    strongSelf.songMasteringEngineerHeightConstraint.constant = CGFloat(270)
                }
            })
        } else {
            songMasteringEngineerHeightConstraint.constant = 0
        }
        songRecordingEngineerTableView.delegate = self
        songRecordingEngineerTableView.dataSource = self
        if let psa = currentSong.songRecordingEngineer {
            setRecordingEngineerArr(arr: psa, completion: {[weak self] _ in
                guard let strongSelf = self else {return}
                strongSelf.songRecordingEngineerArr.sort(by: {$0.name < $1.name})
                strongSelf.songRecordingEngineerTableView.reloadData()
                if strongSelf.songRecordingEngineerArr.count < 6 {
                    strongSelf.songRecordingEngineerHeightConstraint.constant = CGFloat(50*(strongSelf.songRecordingEngineerArr.count))
                } else {
                    strongSelf.songRecordingEngineerHeightConstraint.constant = CGFloat(270)
                }
            })
        } else {
            songRecordingEngineerHeightConstraint.constant = 0
        }
        songSpotifyURL.text = currentSong.spotify?.spotifySongURL
        if currentSong.spotify?.spotifySongURL == nil || currentSong.spotify?.spotifySongURL == "" {
            songRemoveSpotifyURLButton.isHidden = true
            spotifyStatusControl.isHidden = true
        } else {
            spotifyStatusControl.isHidden = false
            songRemoveSpotifyURLButton.isHidden = false
        }
        songAppleMusicURL.text = currentSong.apple?.appleSongURL
        if currentSong.apple?.appleSongURL == nil || currentSong.apple?.appleSongURL == "" {
            songRemoveAppleMusicURLButton.isHidden = true
            appleMusicStatusControl.isHidden = true
        } else {
            appleMusicStatusControl.isHidden = false
            songRemoveAppleMusicURLButton.isHidden = false
        }
        songSoundcloudURL.text = currentSong.soundcloud?.url
        if currentSong.soundcloud?.url == nil || currentSong.soundcloud?.url == "" {
            songRemoveSoundcloudURLButton.isHidden = true
            soundcloudStatusControl.isHidden = true
        } else {
            soundcloudStatusControl.isHidden = false
            songRemoveSoundcloudURLButton.isHidden = false
        }
        songYoutubeMusicURL.text = currentSong.youtubeMusic?.url
        if currentSong.youtubeMusic?.url == nil || currentSong.youtubeMusic?.url == "" {
            songRemoveYoutubeMusicURLButton.isHidden = true
            youtubeMusicStatusControl.isHidden = true
        } else {
            youtubeMusicStatusControl.isHidden = false
            songRemoveYoutubeMusicURLButton.isHidden = false
        }
        songAmazonURL.text = currentSong.amazon?.url
        if currentSong.amazon?.url == nil || currentSong.amazon?.url == "" {
            songRemoveAmazonURLButton.isHidden = true
            amazonStatusControl.isHidden = true
        } else {
            amazonStatusControl.isHidden = false
            songRemoveAmazonURLButton.isHidden = false
        }
        songDeezerURL.text = currentSong.deezer?.url
        if currentSong.deezer?.url == nil || currentSong.deezer?.url == "" {
            songRemoveDeezerURLButton.isHidden = true
            deezerStatusControl.isHidden = true
        } else {
            deezerStatusControl.isHidden = false
            songRemoveDeezerURLButton.isHidden = false
        }
        songTidalURL.text = currentSong.tidal?.url
        if currentSong.tidal?.url == nil || currentSong.tidal?.url == "" {
            songRemoveTidalURLButton.isHidden = true
            tidalStatusControl.isHidden = true
        } else {
            tidalStatusControl.isHidden = false
            songRemoveTidalURLButton.isHidden = false
        }
        songNapsterURL.text = currentSong.napster?.url
        if currentSong.napster?.url == nil || currentSong.napster?.url == "" {
            songRemoveNapsterURLButton.isHidden = true
            napsterStatusControl.isHidden = true
        } else {
            napsterStatusControl.isHidden = false
            songRemoveNapsterURLButton.isHidden = false
        }
        songSpinrillaURL.text = currentSong.spinrilla?.url
        if currentSong.spinrilla?.url == nil || currentSong.spinrilla?.url == "" {
            songRemoveSpinrillaURLButton.isHidden = true
            spinrillaStatusControl.isHidden = true
        } else {
            spinrillaStatusControl.isHidden = false
            songRemoveSpinrillaURLButton.isHidden = false
        }
        
        if let seggo = currentSong.spotify?.isActive {
            if seggo {
                spotifyStatusControl.selectedSegmentIndex = 0
                spotifyStatusControl.selectedSegmentTintColor = .systemGreen
            } else {
                spotifyStatusControl.selectedSegmentTintColor = Constants.Colors.redApp
                spotifyStatusControl.selectedSegmentIndex = 1
            }
        }
        if let seggo = currentSong.apple?.isActive {
            if seggo {
                appleMusicStatusControl.selectedSegmentIndex = 0
                appleMusicStatusControl.selectedSegmentTintColor = .systemGreen
            } else {
                appleMusicStatusControl.selectedSegmentTintColor = Constants.Colors.redApp
                appleMusicStatusControl.selectedSegmentIndex = 1
            }
        }
        if let seggo = currentSong.soundcloud?.isActive {
            if seggo {
                soundcloudStatusControl.selectedSegmentIndex = 0
                soundcloudStatusControl.selectedSegmentTintColor = .systemGreen
            } else {
                soundcloudStatusControl.selectedSegmentTintColor = Constants.Colors.redApp
                soundcloudStatusControl.selectedSegmentIndex = 1
            }
        }
        if let seggo = currentSong.youtubeMusic?.isActive {
            if seggo {
                youtubeMusicStatusControl.selectedSegmentIndex = 0
                youtubeMusicStatusControl.selectedSegmentTintColor = .systemGreen
            } else {
                youtubeMusicStatusControl.selectedSegmentTintColor = Constants.Colors.redApp
                youtubeMusicStatusControl.selectedSegmentIndex = 1
            }
        }
        if let seggo = currentSong.amazon?.isActive {
            if seggo {
                amazonStatusControl.selectedSegmentIndex = 0
                amazonStatusControl.selectedSegmentTintColor = .systemGreen
            } else {
                amazonStatusControl.selectedSegmentTintColor = Constants.Colors.redApp
                amazonStatusControl.selectedSegmentIndex = 1
            }
        }
        if let seggo = currentSong.deezer?.isActive {
            if seggo {
                deezerStatusControl.selectedSegmentIndex = 0
                deezerStatusControl.selectedSegmentTintColor = .systemGreen
            } else {
                deezerStatusControl.selectedSegmentTintColor = Constants.Colors.redApp
                deezerStatusControl.selectedSegmentIndex = 1
            }
        }
        if let seggo = currentSong.tidal?.isActive {
            if seggo {
                tidalStatusControl.selectedSegmentIndex = 0
                tidalStatusControl.selectedSegmentTintColor = .systemGreen
            } else {
                tidalStatusControl.selectedSegmentTintColor = Constants.Colors.redApp
                tidalStatusControl.selectedSegmentIndex = 1
            }
        }
        if let seggo = currentSong.napster?.isActive {
            if seggo {
                napsterStatusControl.selectedSegmentIndex = 0
                napsterStatusControl.selectedSegmentTintColor = .systemGreen
            } else {
                napsterStatusControl.selectedSegmentTintColor = Constants.Colors.redApp
                napsterStatusControl.selectedSegmentIndex = 1
            }
        }
        if let seggo = currentSong.spinrilla?.isActive {
            if seggo {
                spinrillaStatusControl.selectedSegmentIndex = 0
                spinrillaStatusControl.selectedSegmentTintColor = .systemGreen
            } else {
                spinrillaStatusControl.selectedSegmentTintColor = Constants.Colors.redApp
                spinrillaStatusControl.selectedSegmentIndex = 1
            }
        }
        songAlbumsTableView.delegate = self
        songAlbumsTableView.dataSource = self
        if let psa = currentSong.albums {
            setAlbumsArr(arr: psa, completion: {[weak self] _ in
                guard let strongSelf = self else {return}
                strongSelf.songAlbumsTableView.reloadData()
                if strongSelf.songAlbumsArr.count < 6 {
                    strongSelf.songAlbumsHeightConstraint.constant = CGFloat(50*(strongSelf.songAlbumsArr.count))
                } else {
                    strongSelf.songAlbumsHeightConstraint.constant = CGFloat(270)
                }
            })
        } else {
            songAlbumsHeightConstraint.constant = 0
        }
        songVideosTableView.delegate = self
        songVideosTableView.dataSource = self
        if let psa = currentSong.videos {
            setVideosArr(arr: psa, completion: {[weak self] _ in
                guard let strongSelf = self else {return}
                strongSelf.songVideosTableView.reloadData()
                if strongSelf.songVideosArr.count < 6 {
                    strongSelf.songVideosHeightConstraint.constant = CGFloat(70*(strongSelf.songVideosArr.count))
                } else {
                    strongSelf.songVideosHeightConstraint.constant = CGFloat(370)
                }
            })
        } else {
            songVideosHeightConstraint.constant = 0
        }
        songInstrumentalsTableView.delegate = self
        songInstrumentalsTableView.dataSource = self
        if let psa = currentSong.instrumentals {
            setInstrumentalsArr(arr: psa, completion: {[weak self] _ in
                guard let strongSelf = self else {return}
                strongSelf.songInstrumentalsTableView.reloadData()
                if strongSelf.songInstrumentalsArr.count < 6 {
                    strongSelf.songInstrumentalsHeightConstraint.constant = CGFloat(50*(strongSelf.songInstrumentalsArr.count))
                } else {
                    strongSelf.songInstrumentalsHeightConstraint.constant = CGFloat(270)
                }
            })
        } else {
            songInstrumentalsHeightConstraint.constant = 0
        }
        songRemixesTableView.delegate = self
        songRemixesTableView.dataSource = self
        if let psa = currentSong.remixes {
            setRemixesArr(arr: psa, completion: {[weak self] _ in
                guard let strongSelf = self else {return}
                strongSelf.songRemixesTableView.reloadData()
                strongSelf.songRemixesArr.sort(by: {$0.name < $1.name})
                if strongSelf.songRemixesArr.count < 6 {
                    strongSelf.songRemixesHeightConstraint.constant = CGFloat(50*(strongSelf.songRemixesArr.count))
                } else {
                    strongSelf.songRemixesHeightConstraint.constant = CGFloat(270)
                }
            })
        } else {
            songRemixesHeightConstraint.constant = 0
        }
        songOtherVersionsTableView.delegate = self
        songOtherVersionsTableView.dataSource = self
        if let psa = currentSong.otherVersions {
            setOtherVersionsArr(arr: psa, completion: {[weak self] _ in
                guard let strongSelf = self else {return}
                strongSelf.songOtherVersionsTableView.reloadData()
                strongSelf.songOtherVersionsArr.sort(by: {$0.name < $1.name})
                if strongSelf.songOtherVersionsArr.count < 6 {
                    strongSelf.songOtherVersionsHeightConstraint.constant = CGFloat(50*(strongSelf.songOtherVersionsArr.count))
                } else {
                    strongSelf.songOtherVersionsHeightConstraint.constant = CGFloat(270)
                }
            })
        } else {
            songOtherVersionsHeightConstraint.constant = 0
        }
        if currentSong.explicit! {
            explicityControl.selectedSegmentIndex = 0
            explicityControl.selectedSegmentTintColor = .systemGreen
        } else {
            explicityControl.selectedSegmentTintColor = Constants.Colors.redApp
            explicityControl.selectedSegmentIndex = 1
        }
        if currentSong.isRemix != nil {
            remixControl.selectedSegmentIndex = 0
            remixControl.selectedSegmentTintColor = .systemGreen
            remixOfStackView.isHidden = false
            for alb in AllSongsInDatabaseArray {
                if alb.toneDeafAppId == currentSong.isRemix!.standardEdition {
                    remixOfTextField.text = "\(alb.name) - \(alb.toneDeafAppId)"
                }
            }
        } else {
            remixControl.selectedSegmentTintColor = Constants.Colors.redApp
            remixControl.selectedSegmentIndex = 1
            remixOfStackView.isHidden = true
        }
        if currentSong.isOtherVersion != nil {
            otherVersionControl.selectedSegmentIndex = 0
            otherVersionControl.selectedSegmentTintColor = .systemGreen
            otherVersionOfStackView.isHidden = false
            for alb in AllSongsInDatabaseArray {
                if alb.toneDeafAppId == currentSong.isOtherVersion!.standardEdition {
                    otherVersionOfTextField.text = "\(alb.name) - \(alb.toneDeafAppId)"
                }
            }
        } else {
            otherVersionControl.selectedSegmentTintColor = Constants.Colors.redApp
            otherVersionControl.selectedSegmentIndex = 1
            otherVersionOfStackView.isHidden = true
        }
        if currentSong.industryCerified! {
            industryCertifiedControl.selectedSegmentIndex = 0
            industryCertifiedControl.selectedSegmentTintColor = .systemGreen
        } else {
            industryCertifiedControl.selectedSegmentTintColor = Constants.Colors.redApp
            industryCertifiedControl.selectedSegmentIndex = 1
        }
        if currentSong.isActive {
            songStatusControl.selectedSegmentIndex = 0
            songStatusControl.selectedSegmentTintColor = .systemGreen
        } else {
            songStatusControl.selectedSegmentTintColor = Constants.Colors.redApp
            songStatusControl.selectedSegmentIndex = 1
        }
        GlobalFunctions.shared.selectPreviewURL(song: currentSong, completion: {[weak self] previewurl in
            guard let strongSelf = self else {return}
            guard let previewurl = previewurl else {
                strongSelf.songPreviewURL.text = "No Preview Available"
                strongSelf.songPreviewURL.alpha = 0.5
                return
            }
            strongSelf.songPreviewURL.alpha = 1
            strongSelf.songPreviewURL.text = previewurl
        })
        GlobalFunctions.shared.selectImageURL(song: currentSong, completion: {[weak self] aimage in
            guard let strongSelf = self else {return}
            guard let imge = aimage else {
                strongSelf.songImage.image = UIImage(named: "tonedeaflogo")
                strongSelf.songImageURL.text = "No Image"
                strongSelf.songImageURL.alpha = 0.5
                return
            }
            strongSelf.songImageURL.alpha = 1
            strongSelf.songImageURL.text = imge
            let imageURL = URL(string: imge)!
            if let cachedImage = imageCache.object(forKey: imageURL.absoluteString as NSString) {
                strongSelf.songImage.image = cachedImage
            } else {
                strongSelf.songImage.setImage(from: imageURL, withPlaceholder: UIImage(named: "tonedeaflogo"))
            }
            
        })
        scrollToTop()
    }
    
    func setArtistsArr(arr: [String], completion: @escaping ((Error?) -> Void)) {
            songArtistsArr = []
            if arr != [] {
                for person in arr {
                    getPerson(personIdFull: person, completion: {[weak self] personData in
                        guard let strongSelf = self else {return}
                        strongSelf.songArtistsArr.append(personData)
                        completion(nil)
                    })
                }
            } else {
                songArtistsHeightConstraint.constant = CGFloat(50*(songArtistsArr.count))
            }
    }
    
    func setProducersArr(arr: [String], completion: @escaping ((Error?) -> Void)) {
            songProducersArr = []
            if arr != [] {
                for person in arr {
                    getPerson(personIdFull: person, completion: {[weak self] personData in
                        guard let strongSelf = self else {return}
                        strongSelf.songProducersArr.append(personData)
                        completion(nil)
                    })
                }
            } else {
                songProducersHeightConstraint.constant = CGFloat(50*(songProducersArr.count))
            }
    }
    
    func setWritersArr(arr: [String], completion: @escaping ((Error?) -> Void)) {
            songWritersArr = []
            if arr != [] {
                for person in arr {
                    getPerson(personIdFull: person, completion: {[weak self] personData in
                        guard let strongSelf = self else {return}
                        strongSelf.songWritersArr.append(personData)
                        completion(nil)
                    })
                }
            } else {
                songWritersHeightConstraint.constant = CGFloat(50*(songWritersArr.count))
            }
    }
    
    func setMixEngineerArr(arr: [String], completion: @escaping ((Error?) -> Void)) {
            songMixEngineerArr = []
            if arr != [] {
                for person in arr {
                    getPerson(personIdFull: person, completion: {[weak self] personData in
                        guard let strongSelf = self else {return}
                        strongSelf.songMixEngineerArr.append(personData)
                        completion(nil)
                    })
                }
            } else {
                songMixEngineerHeightConstraint.constant = CGFloat(50*(songMixEngineerArr.count))
            }
    }
    
    func setMasteringEngineerArr(arr: [String], completion: @escaping ((Error?) -> Void)) {
            songMasteringEngineerArr = []
            if arr != [] {
                for person in arr {
                    getPerson(personIdFull: person, completion: {[weak self] personData in
                        guard let strongSelf = self else {return}
                        strongSelf.songMasteringEngineerArr.append(personData)
                        completion(nil)
                    })
                }
            } else {
                songMasteringEngineerHeightConstraint.constant = CGFloat(50*(songMasteringEngineerArr.count))
            }
    }
    
    func setRecordingEngineerArr(arr: [String], completion: @escaping ((Error?) -> Void)) {
            songRecordingEngineerArr = []
            if arr != [] {
                for person in arr {
                    getPerson(personIdFull: person, completion: {[weak self] personData in
                        guard let strongSelf = self else {return}
                        strongSelf.songRecordingEngineerArr.append(personData)
                        completion(nil)
                    })
                }
            } else {
                songRecordingEngineerHeightConstraint.constant = CGFloat(50*(songRecordingEngineerArr.count))
            }
    }
    
    func setAlbumsArr(arr: [String], completion: @escaping ((Error?) -> Void)) {
            songAlbumsArr = []
            if arr != [] {
                
                for song in arr {
                    getAlbum(albumIdFull: song, completion: {[weak self] songData in
                        
                        guard let strongSelf = self else {return}
                        strongSelf.songAlbumsArr.append(songData)
                        for (key,val) in songData.tracks {
                            if val == strongSelf.currentSong.toneDeafAppId {
                                strongSelf.initAlbumTrackArr[songData.toneDeafAppId] = String(key.dropFirst(6))
                                strongSelf.albumTrackArr[songData.toneDeafAppId] = String(key.dropFirst(6))
                            }
                        }
                        completion(nil)
                    })
                }
            } else {
                songAlbumsHeightConstraint.constant = CGFloat(50*(songAlbumsArr.count))
            }
    }
    
    func setVideosArr(arr: [String], completion: @escaping ((Error?) -> Void)) {
            songVideosArr = []
            if arr != [] {
                
                for video in arr {
                    getVideo(videoIdFull: video, completion: {[weak self] videoData in
                        
                        guard let strongSelf = self else {return}
                        strongSelf.songVideosArr.append(videoData)
                        completion(nil)
                    })
                }
            } else {
                songVideosHeightConstraint.constant = CGFloat(70*(songVideosArr.count))
            }
    }
    
    func setInstrumentalsArr(arr: [String], completion: @escaping ((Error?) -> Void)) {
            songInstrumentalsArr = []
            if arr != [] {
                for instrumental in arr {
                    getInstrumental(instrumentalIdFull: instrumental, completion: {[weak self] instrumentalData in
                        guard let strongSelf = self else {return}
                        strongSelf.songInstrumentalsArr.append(instrumentalData)
                        completion(nil)
                    })
                }
            } else {
                songInstrumentalsHeightConstraint.constant = CGFloat(50*(songInstrumentalsArr.count))
            }
    }
    
    func setRemixesArr(arr: [String], completion: @escaping ((Error?) -> Void)) {
            songRemixesArr = []
            if arr != [] {
                for song in arr {
                    getSong(songIdFull: song, completion: {[weak self] songData in
                        guard let strongSelf = self else {return}
                        strongSelf.songRemixesArr.append(songData)
                        completion(nil)
                    })
                }
            } else {
                songRemixesHeightConstraint.constant = CGFloat(50*(songRemixesArr.count))
            }
    }
    
    func setOtherVersionsArr(arr: [String], completion: @escaping ((Error?) -> Void)) {
            songOtherVersionsArr = []
            if arr != [] {
                for song in arr {
                    getSong(songIdFull: song, completion: {[weak self] songData in
                        guard let strongSelf = self else {return}
                        strongSelf.songOtherVersionsArr.append(songData)
                        completion(nil)
                    })
                }
            } else {
                songOtherVersionsHeightConstraint.constant = CGFloat(50*(songOtherVersionsArr.count))
            }
    }
    
    @IBAction func newSongTapped(_ sender: Any) {
            arr = "song"
            prevPage = "editSongAll"
            performSegue(withIdentifier: "editSongToTonesPick", sender: nil)
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
        actionSheet.addAction(UIAlertAction(title: "Use Song Default",
                                            style: .default,
                                            handler: { [weak self] _ in
            guard let strongSelf = self else {return}
            strongSelf.currentSong.manualImageURL = nil
            strongSelf.newImage = nil
            strongSelf.songImageURL.textColor = .green
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
                strongSelf.songName.text = name
                strongSelf.songName.textColor = .green
                strongSelf.currentSong.name = name
                alertC.dismiss(animated: true, completion: nil)
            } else {
                alertC.dismiss(animated: true, completion: nil)
            }
        })
        alertC.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alertC.addAction(okAction)
        alertC.addTextField()
        alertC.textFields![0].text = currentSong.name
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
            strongSelf.currentSong.manualPreviewURL = nil
            strongSelf.newPreview = nil
            strongSelf.songPreviewURL.textColor = .green
            strongSelf.setUpPage()
            
            actionSheet.dismiss(animated: true)
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        actionSheet.view.tintColor = Constants.Colors.redApp
        present(actionSheet, animated: true)
    }
    
    @IBAction func addArtistTapped(_ sender: Any) {
        arr = "person"
        prevPage = "editSong"
        tbsender = "artist"
        performSegue(withIdentifier: "editSongToTonesPick", sender: nil)
    }
    
    @IBAction func addProducerTapped(_ sender: Any) {
        arr = "person"
        prevPage = "editSong"
        tbsender = "producer"
        performSegue(withIdentifier: "editSongToTonesPick", sender: nil)
    }
    
    @IBAction func addWriterTapped(_ sender: Any) {
        arr = "person"
        prevPage = "editSong"
        tbsender = "writer"
        performSegue(withIdentifier: "editSongToTonesPick", sender: nil)
    }
    
    @IBAction func addMixEngineerTapped(_ sender: Any) {
        arr = "person"
        prevPage = "editSong"
        tbsender = "mixEngineer"
        performSegue(withIdentifier: "editSongToTonesPick", sender: nil)
    }
    
    @IBAction func addMasteringEngineerTapped(_ sender: Any) {
        arr = "person"
        prevPage = "editSong"
        tbsender = "masteringEngineer"
        performSegue(withIdentifier: "editSongToTonesPick", sender: nil)
    }
    
    @IBAction func addRecordingEngineerTapped(_ sender: Any) {
        arr = "person"
        prevPage = "editSong"
        tbsender = "recordingEngineer"
        performSegue(withIdentifier: "editSongToTonesPick", sender: nil)
    }
    
    func personAdded(_ person: PersonData) {
        lightImpactGenerator.impactOccurred(intensity: 0.75)
        switch tbsender {
        case "artist":
            if !songArtistsArr.contains(person) {
                songArtistsArr.append(person)
            } else {
                let dex = songArtistsArr.firstIndex(of: person)
                songArtistsArr[dex!] = person
            }
            
            if currentSong.songArtist == nil {
                currentSong.songArtist = ["\(person.toneDeafAppId)"]
            } else {
                if !currentSong.songArtist.contains(person.toneDeafAppId) {
                    currentSong.songArtist.append("\(person.toneDeafAppId)")
                    currentSong.songArtist.sort()
                }
            }
            DispatchQueue.main.async {[weak self]  in
                guard let strongSelf = self else {return}
                strongSelf.songArtistsArr.sort(by: {$0.name < $1.name})
                strongSelf.songArtistsTableView.reloadData()
                if strongSelf.songArtistsArr.count < 6 {
                    strongSelf.songArtistsHeightConstraint.constant = CGFloat(50*(strongSelf.songArtistsArr.count))
                } else {
                    strongSelf.songArtistsHeightConstraint.constant = CGFloat(270)
                }
            }
        case "producer":
            if !songProducersArr.contains(person) {
                songProducersArr.append(person)
            } else {
                let dex = songProducersArr.firstIndex(of: person)
                songProducersArr[dex!] = person
            }
            
            if currentSong.songProducers == nil {
                currentSong.songProducers = ["\(person.toneDeafAppId)"]
            } else {
                if !currentSong.songProducers.contains(person.toneDeafAppId) {
                    currentSong.songProducers.append("\(person.toneDeafAppId)")
                    currentSong.songProducers.sort()
                }
            }
            DispatchQueue.main.async {[weak self]  in
                guard let strongSelf = self else {return}
                strongSelf.songProducersArr.sort(by: {$0.name < $1.name})
                strongSelf.songProducersTableView.reloadData()
                if strongSelf.songProducersArr.count < 6 {
                    strongSelf.songProducersHeightConstraint.constant = CGFloat(50*(strongSelf.songProducersArr.count))
                } else {
                    strongSelf.songProducersHeightConstraint.constant = CGFloat(270)
                }
            }
        case "writer":
            if !songWritersArr.contains(person) {
                songWritersArr.append(person)
            } else {
                let dex = songWritersArr.firstIndex(of: person)
                songWritersArr[dex!] = person
            }
            
            if currentSong.songWriters == nil {
                currentSong.songWriters = ["\(person.toneDeafAppId)"]
            } else {
                if var arr = currentSong.songWriters {
                    if !arr.contains(person.toneDeafAppId) {
                        arr.append("\(person.toneDeafAppId)")
                        arr.sort()
                        currentSong.songWriters = arr
                    }
                } else {
                    var arr:[String] = []
                    arr.append("\(person.toneDeafAppId)")
                    arr.sort()
                    currentSong.songWriters = arr
                }
            }
            DispatchQueue.main.async {[weak self]  in
                guard let strongSelf = self else {return}
                strongSelf.songWritersArr.sort(by: {$0.name < $1.name})
                strongSelf.songWritersTableView.reloadData()
                if strongSelf.songWritersArr.count < 6 {
                    strongSelf.songWritersHeightConstraint.constant = CGFloat(50*(strongSelf.songWritersArr.count))
                } else {
                    strongSelf.songWritersHeightConstraint.constant = CGFloat(270)
                }
            }
        case "mixEngineer":
            if !songMixEngineerArr.contains(person) {
                songMixEngineerArr.append(person)
            } else {
                let dex = songMixEngineerArr.firstIndex(of: person)
                songMixEngineerArr[dex!] = person
            }
            
            if currentSong.songMixEngineer == nil {
                currentSong.songMixEngineer = ["\(person.toneDeafAppId)"]
            } else {
                if var arr = currentSong.songMixEngineer {
                    if !arr.contains(person.toneDeafAppId) {
                        arr.append("\(person.toneDeafAppId)")
                        arr.sort()
                        currentSong.songMixEngineer = arr
                    }
                } else {
                    var arr:[String] = []
                    arr.append("\(person.toneDeafAppId)")
                    arr.sort()
                    currentSong.songMixEngineer = arr
                }
            }
            DispatchQueue.main.async {[weak self]  in
                guard let strongSelf = self else {return}
                strongSelf.songMixEngineerArr.sort(by: {$0.name < $1.name})
                strongSelf.songMixEngineerTableView.reloadData()
                if strongSelf.songMixEngineerArr.count < 6 {
                    strongSelf.songMixEngineerHeightConstraint.constant = CGFloat(50*(strongSelf.songMixEngineerArr.count))
                } else {
                    strongSelf.songMixEngineerHeightConstraint.constant = CGFloat(270)
                }
            }
        case "masteringEngineer":
            if !songMasteringEngineerArr.contains(person) {
                songMasteringEngineerArr.append(person)
            } else {
                let dex = songMasteringEngineerArr.firstIndex(of: person)
                songMasteringEngineerArr[dex!] = person
            }
            
            if currentSong.songMasteringEngineer == nil {
                currentSong.songMasteringEngineer = ["\(person.toneDeafAppId)"]
            } else {
                if var arr = currentSong.songMasteringEngineer {
                    if !arr.contains(person.toneDeafAppId) {
                        arr.append("\(person.toneDeafAppId)")
                        arr.sort()
                        currentSong.songMasteringEngineer = arr
                    }
                } else {
                    var arr:[String] = []
                    arr.append("\(person.toneDeafAppId)")
                    arr.sort()
                    currentSong.songMasteringEngineer = arr
                }
            }
            DispatchQueue.main.async {[weak self]  in
                guard let strongSelf = self else {return}
                strongSelf.songMasteringEngineerArr.sort(by: {$0.name < $1.name})
                strongSelf.songMasteringEngineerTableView.reloadData()
                if strongSelf.songMasteringEngineerArr.count < 6 {
                    strongSelf.songMasteringEngineerHeightConstraint.constant = CGFloat(50*(strongSelf.songMasteringEngineerArr.count))
                } else {
                    strongSelf.songMasteringEngineerHeightConstraint.constant = CGFloat(270)
                }
            }
        case "recordingEngineer":
            if !songRecordingEngineerArr.contains(person) {
                songRecordingEngineerArr.append(person)
            } else {
                let dex = songRecordingEngineerArr.firstIndex(of: person)
                songRecordingEngineerArr[dex!] = person
            }
            
            if currentSong.songRecordingEngineer == nil {
                currentSong.songRecordingEngineer = ["\(person.toneDeafAppId)"]
            } else {
                if var arr = currentSong.songRecordingEngineer {
                    if !arr.contains(person.toneDeafAppId) {
                        arr.append("\(person.toneDeafAppId)")
                        arr.sort()
                        currentSong.songRecordingEngineer = arr
                    }
                } else {
                    var arr:[String] = []
                    arr.append("\(person.toneDeafAppId)")
                    arr.sort()
                    currentSong.songRecordingEngineer = arr
                }
            }
            DispatchQueue.main.async {[weak self]  in
                guard let strongSelf = self else {return}
                strongSelf.songRecordingEngineerArr.sort(by: {$0.name < $1.name})
                strongSelf.songRecordingEngineerTableView.reloadData()
                if strongSelf.songRecordingEngineerArr.count < 6 {
                    strongSelf.songRecordingEngineerHeightConstraint.constant = CGFloat(50*(strongSelf.songRecordingEngineerArr.count))
                } else {
                    strongSelf.songRecordingEngineerHeightConstraint.constant = CGFloat(270)
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
            if field.text != strongSelf.currentSong.spotify?.spotifySongURL {
                strongSelf.spotifyStatusControl.selectedSegmentIndex = 1
                strongSelf.spotifyStatusControl.selectedSegmentTintColor = Constants.Colors.redApp
                strongSelf.currentSong.spotify?.isActive = false
                strongSelf.songSpotifyURL.textColor = .green
            }
            if field.text != "" {
                guard let name = field.text else {return}
                strongSelf.songSpotifyURL.text = name
                if let obj = strongSelf.currentSong.spotify {
                    obj.spotifySongURL = name
                } else {
                    strongSelf.currentSong.spotify = SpotifySongData(spotifyName: "", spotifySongURL: name, spotifyDuration: "", spotifyDateSPT: "", spotifyDateIA: "", spotifyTimeIA: "", spotifyArtworkURL: "", spotifyArtist1: "", spotifyArtist1URL: "", spotifyArtist2: "", spotifyArtist2URL: "", spotifyArtist3: "", spotifyArtist3URL: "", spotifyArtist4: "", spotifyArtist4URL: "", spotifyArtist5: "", spotifyArtist5URL: "", spotifyArtist6: "", spotifyArtist6URL: "", spotifyExplicity: false, spotifyISRC: "", spotifyAlbumType: "", spotifyTrackNumber: 0, spotifyPreviewURL: "", spotifyFavorites: 0, spotifyId: "", isActive: false)
                }
                strongSelf.songRemoveSpotifyURLButton.isHidden = false
                strongSelf.spotifyStatusControl.isHidden = false
                alertC.dismiss(animated: true, completion: nil)
            } else {
                alertC.dismiss(animated: true, completion: nil)
            }
        })
        alertC.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alertC.addAction(okAction)
        alertC.addTextField()
        alertC.textFields![0].text = currentSong.spotify?.spotifySongURL
        alertC.view.tintColor = Constants.Colors.redApp
        self.present(alertC, animated: true)
    }
    
    @IBAction func removeSpotifyURLTapped(_ sender: Any) {
        let alertC = UIAlertController(title: "Remove Spotify URL",
                                       message: "Are You Sure?",
                                       preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Yes", style: .destructive, handler: {[weak self] _ in
            guard let strongSelf = self else {return}
            strongSelf.songSpotifyURL.text = ""
            strongSelf.songSpotifyURL.textColor = .green
            strongSelf.currentSong.spotify = nil
            strongSelf.songRemoveSpotifyURLButton.isHidden = true
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
            if field.text != strongSelf.currentSong.apple?.appleSongURL {
                strongSelf.appleMusicStatusControl.selectedSegmentIndex = 1
                strongSelf.appleMusicStatusControl.selectedSegmentTintColor = Constants.Colors.redApp
                strongSelf.currentSong.apple?.isActive = false
                strongSelf.songAppleMusicURL.textColor = .green
            }
            if field.text != "" {
                guard let name = field.text else {return}
                strongSelf.songAppleMusicURL.text = name
                if let obj = strongSelf.currentSong.apple {
                    obj.appleSongURL = name
                } else {
                    strongSelf.currentSong.apple = AppleMusicSongData(appleName: "", appleSongURL: name, appleDuration: "", appleDateAPPL: "", appleDateIA: "", appleTimeIA: "", appleArtworkURL: "", appleArtist: "", appleExplicity: false, appleISRC: "", appleAlbumName: "", applePreviewURL: "", applecomposers: "", appleTrackNumber: 0, appleGenres: [], appleFavorites: 0, appleMusicId: "", isActive: false)
                }
                strongSelf.songRemoveAppleMusicURLButton.isHidden = false
                strongSelf.appleMusicStatusControl.isHidden = false
                alertC.dismiss(animated: true, completion: nil)
            } else {
                alertC.dismiss(animated: true, completion: nil)
            }
        })
        alertC.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alertC.addAction(okAction)
        alertC.addTextField()
        alertC.textFields![0].text = currentSong.apple?.appleSongURL
        alertC.view.tintColor = Constants.Colors.redApp
        self.present(alertC, animated: true)
    }
    
    @IBAction func removeAppleMusicURLTapped(_ sender: Any) {
        let alertC = UIAlertController(title: "Remove Apple Music URL",
                                       message: "Are You Sure?",
                                       preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Yes", style: .destructive, handler: {[weak self] _ in
            guard let strongSelf = self else {return}
            strongSelf.songAppleMusicURL.text = ""
            strongSelf.songAppleMusicURL.textColor = .green
            strongSelf.currentSong.apple = nil
            strongSelf.songRemoveAppleMusicURLButton.isHidden = true
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
            if field.text != strongSelf.currentSong.soundcloud?.url {
                strongSelf.soundcloudStatusControl.selectedSegmentIndex = 1
                strongSelf.soundcloudStatusControl.selectedSegmentTintColor = Constants.Colors.redApp
                strongSelf.currentSong.soundcloud?.isActive = false
                strongSelf.songSoundcloudURL.textColor = .green
            }
            if field.text != "" {
                guard let name = field.text else {return}
                strongSelf.songSoundcloudURL.text = name
                if let obj = strongSelf.currentSong.soundcloud {
                    obj.url = name
                } else {
                    strongSelf.currentSong.soundcloud = SoundcloudSongData(url: name, imageurl: nil, releaseDate: nil, isActive: false)
                }
                strongSelf.songRemoveSoundcloudURLButton.isHidden = false
                strongSelf.soundcloudStatusControl.isHidden = false
                alertC.dismiss(animated: true, completion: nil)
            } else {
                alertC.dismiss(animated: true, completion: nil)
            }
        })
        alertC.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alertC.addAction(okAction)
        alertC.addTextField()
        alertC.textFields![0].text = currentSong.soundcloud?.url
        alertC.view.tintColor = Constants.Colors.redApp
        self.present(alertC, animated: true)
    }
    
    @IBAction func removeSoundcloudURLTapped(_ sender: Any) {
        let alertC = UIAlertController(title: "Remove Soundcloud URL",
                                       message: "Are You Sure?",
                                       preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Yes", style: .destructive, handler: {[weak self] _ in
            guard let strongSelf = self else {return}
            strongSelf.songSoundcloudURL.text = ""
            strongSelf.songSoundcloudURL.textColor = .green
            strongSelf.currentSong.soundcloud = nil
            strongSelf.songRemoveSoundcloudURLButton.isHidden = true
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
            if field.text != strongSelf.currentSong.youtubeMusic?.url {
                strongSelf.youtubeMusicStatusControl.selectedSegmentIndex = 1
                strongSelf.youtubeMusicStatusControl.selectedSegmentTintColor = Constants.Colors.redApp
                strongSelf.currentSong.youtubeMusic?.isActive = false
                strongSelf.songYoutubeMusicURL.textColor = .green
            }
            if field.text != "" {
                guard let name = field.text else {return}
                strongSelf.songYoutubeMusicURL.text = name
                if let obj = strongSelf.currentSong.youtubeMusic {
                    obj.url = name
                } else {
                    strongSelf.currentSong.youtubeMusic = YoutubeMusicSongData(url: name, imageurl: nil, isActive: false)
                }
                strongSelf.songRemoveSoundcloudURLButton.isHidden = false
                strongSelf.youtubeMusicStatusControl.isHidden = false
                alertC.dismiss(animated: true, completion: nil)
            } else {
                alertC.dismiss(animated: true, completion: nil)
            }
        })
        alertC.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alertC.addAction(okAction)
        alertC.addTextField()
        alertC.textFields![0].text = currentSong.youtubeMusic?.url
        alertC.view.tintColor = Constants.Colors.redApp
        self.present(alertC, animated: true)
    }
    
    @IBAction func removeYoutubeMusicURLTapped(_ sender: Any) {
        let alertC = UIAlertController(title: "Remove Youtube Music URL",
                                       message: "Are You Sure?",
                                       preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Yes", style: .destructive, handler: {[weak self] _ in
            guard let strongSelf = self else {return}
            strongSelf.songYoutubeMusicURL.text = ""
            strongSelf.songYoutubeMusicURL.textColor = .green
            strongSelf.currentSong.youtubeMusic = nil
            strongSelf.songRemoveSoundcloudURLButton.isHidden = true
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
            if field.text != strongSelf.currentSong.amazon?.url {
                strongSelf.amazonStatusControl.selectedSegmentIndex = 1
                strongSelf.amazonStatusControl.selectedSegmentTintColor = Constants.Colors.redApp
                strongSelf.currentSong.amazon?.isActive = false
                strongSelf.songAmazonURL.textColor = .green
            }
            if field.text != "" {
                guard let name = field.text else {return}
                strongSelf.songAmazonURL.text = name
                if let obj = strongSelf.currentSong.amazon {
                    obj.url = name
                } else {
                    strongSelf.currentSong.amazon = AmazonSongData(url: name, imageurl: nil, isActive: false)
                }
                strongSelf.songRemoveAmazonURLButton.isHidden = false
                strongSelf.amazonStatusControl.isHidden = false
                alertC.dismiss(animated: true, completion: nil)
            } else {
                alertC.dismiss(animated: true, completion: nil)
            }
        })
        alertC.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alertC.addAction(okAction)
        alertC.addTextField()
        alertC.textFields![0].text = currentSong.amazon?.url
        alertC.view.tintColor = Constants.Colors.redApp
        self.present(alertC, animated: true)
    }
    
    @IBAction func removeAmazonMusicURLTapped(_ sender: Any) {
        let alertC = UIAlertController(title: "Remove Amazon Music URL",
                                       message: "Are You Sure?",
                                       preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Yes", style: .destructive, handler: {[weak self] _ in
            guard let strongSelf = self else {return}
            strongSelf.songAmazonURL.text = ""
            strongSelf.songAmazonURL.textColor = .green
            strongSelf.currentSong.amazon = nil
            strongSelf.songRemoveAmazonURLButton.isHidden = true
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
            if field.text != strongSelf.currentSong.deezer?.url {
                strongSelf.deezerStatusControl.selectedSegmentIndex = 1
                strongSelf.deezerStatusControl.selectedSegmentTintColor = Constants.Colors.redApp
                strongSelf.currentSong.deezer?.isActive = false
                strongSelf.songDeezerURL.textColor = .green
            }
            if field.text != "" {
                guard let name = field.text else {return}
                strongSelf.songDeezerURL.text = name
                if let obj = strongSelf.currentSong.deezer {
                    obj.url = name
                } else {
                    strongSelf.currentSong.deezer = DeezerSongData(url: name, imageurl: nil, deezerDate: "", artist: [], duration: "", isrc: "", name: "", previewURL: "", timeIA: "", dateIA: "", deezerID: 0, isActive: false)
                }
                strongSelf.songRemoveDeezerURLButton.isHidden = false
                strongSelf.deezerStatusControl.isHidden = false
                alertC.dismiss(animated: true, completion: nil)
            } else {
                alertC.dismiss(animated: true, completion: nil)
            }
        })
        alertC.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alertC.addAction(okAction)
        alertC.addTextField()
        alertC.textFields![0].text = currentSong.deezer?.url
        alertC.view.tintColor = Constants.Colors.redApp
        self.present(alertC, animated: true)
    }
    
    @IBAction func removeDeezerURLTapped(_ sender: Any) {
        let alertC = UIAlertController(title: "Remove Deezer URL",
                                       message: "Are You Sure?",
                                       preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Yes", style: .destructive, handler: {[weak self] _ in
            guard let strongSelf = self else {return}
            strongSelf.songDeezerURL.text = ""
            strongSelf.songDeezerURL.textColor = .green
            strongSelf.currentSong.deezer = nil
            strongSelf.songRemoveDeezerURLButton.isHidden = true
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
            if field.text != strongSelf.currentSong.tidal?.url {
                strongSelf.tidalStatusControl.selectedSegmentIndex = 1
                strongSelf.tidalStatusControl.selectedSegmentTintColor = Constants.Colors.redApp
                strongSelf.currentSong.tidal?.isActive = false
                strongSelf.songTidalURL.textColor = .green
            }
            if field.text != "" {
                guard let name = field.text else {return}
                strongSelf.songTidalURL.text = name
                if let obj = strongSelf.currentSong.tidal {
                    obj.url = name
                } else {
                    strongSelf.currentSong.tidal = TidalSongData(url: name, imageurl: nil, isActive: false)
                }
                strongSelf.songRemoveTidalURLButton.isHidden = false
                strongSelf.tidalStatusControl.isHidden = false
                alertC.dismiss(animated: true, completion: nil)
            } else {
                alertC.dismiss(animated: true, completion: nil)
            }
        })
        alertC.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alertC.addAction(okAction)
        alertC.addTextField()
        alertC.textFields![0].text = currentSong.tidal?.url
        alertC.view.tintColor = Constants.Colors.redApp
        self.present(alertC, animated: true)
    }
    
    @IBAction func removeTidalURLTapped(_ sender: Any) {
        let alertC = UIAlertController(title: "Remove Tidal URL",
                                       message: "Are You Sure?",
                                       preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Yes", style: .destructive, handler: {[weak self] _ in
            guard let strongSelf = self else {return}
            strongSelf.songTidalURL.text = ""
            strongSelf.songTidalURL.textColor = .green
            strongSelf.currentSong.tidal = nil
            strongSelf.songRemoveTidalURLButton.isHidden = true
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
            if field.text != strongSelf.currentSong.napster?.url {
                strongSelf.napsterStatusControl.selectedSegmentIndex = 1
                strongSelf.napsterStatusControl.selectedSegmentTintColor = Constants.Colors.redApp
                strongSelf.currentSong.napster?.isActive = false
                strongSelf.songNapsterURL.textColor = .green
            }
            if field.text != "" {
                guard let name = field.text else {return}
                strongSelf.songNapsterURL.text = name
                if let obj = strongSelf.currentSong.napster {
                    obj.url = name
                } else {
                    strongSelf.currentSong.napster = NapsterSongData(url: name, imageurl: nil, isActive: false)
                }
                strongSelf.songRemoveNapsterURLButton.isHidden = false
                strongSelf.napsterStatusControl.isHidden = false
                alertC.dismiss(animated: true, completion: nil)
            } else {
                alertC.dismiss(animated: true, completion: nil)
            }
        })
        alertC.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alertC.addAction(okAction)
        alertC.addTextField()
        alertC.textFields![0].text = currentSong.napster?.url
        alertC.view.tintColor = Constants.Colors.redApp
        self.present(alertC, animated: true)
    }
    
    @IBAction func removeNapsterURLTapped(_ sender: Any) {
        let alertC = UIAlertController(title: "Remove Napster URL",
                                       message: "Are You Sure?",
                                       preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Yes", style: .destructive, handler: {[weak self] _ in
            guard let strongSelf = self else {return}
            strongSelf.songNapsterURL.text = ""
            strongSelf.songNapsterURL.textColor = .green
            strongSelf.currentSong.napster = nil
            strongSelf.songRemoveNapsterURLButton.isHidden = true
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
            if field.text != strongSelf.currentSong.spinrilla?.url {
                strongSelf.spinrillaStatusControl.selectedSegmentIndex = 1
                strongSelf.spinrillaStatusControl.selectedSegmentTintColor = Constants.Colors.redApp
                strongSelf.currentSong.spinrilla?.isActive = false
                strongSelf.songSpinrillaURL.textColor = .green
            }
            if field.text != "" {
                guard let name = field.text else {return}
                strongSelf.songSpinrillaURL.text = name
                if let obj = strongSelf.currentSong.spinrilla {
                    obj.url = name
                } else {
                    strongSelf.currentSong.spinrilla = SpinrillaSongData(url: name, imageurl: nil, releaseDate: nil, isActive: false)
                }
                strongSelf.songRemoveSpinrillaURLButton.isHidden = false
                strongSelf.spinrillaStatusControl.isHidden = false
                alertC.dismiss(animated: true, completion: nil)
            } else {
                alertC.dismiss(animated: true, completion: nil)
            }
        })
        alertC.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alertC.addAction(okAction)
        alertC.addTextField()
        alertC.textFields![0].text = currentSong.spinrilla?.url
        alertC.view.tintColor = Constants.Colors.redApp
        self.present(alertC, animated: true)
    }
    
    @IBAction func removeSpinrillaURLTapped(_ sender: Any) {
        let alertC = UIAlertController(title: "Remove Spinrilla URL",
                                       message: "Are You Sure?",
                                       preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Yes", style: .destructive, handler: {[weak self] _ in
            guard let strongSelf = self else {return}
            strongSelf.songSpinrillaURL.text = ""
            strongSelf.songSpinrillaURL.textColor = .green
            strongSelf.currentSong.spinrilla = nil
            strongSelf.songRemoveSpinrillaURLButton.isHidden = true
            strongSelf.spinrillaStatusControl.isHidden = true
            alertC.dismiss(animated: true, completion: nil)
            
        })
        alertC.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alertC.addAction(okAction)
        alertC.view.tintColor = Constants.Colors.redApp
        self.present(alertC, animated: true)
    }
    
    @IBAction func addAlbumTapped(_ sender: Any) {
        arr = "album"
        prevPage = "editSong"
        performSegue(withIdentifier: "editSongToTonesPick", sender: nil)
    }
    
    func albumAdded(_ albumAndData: [String?:AlbumData]) {
        lightImpactGenerator.impactOccurred(intensity: 0.75)
        let select = albumAndData[Array(albumAndData.keys)[0]]!
        let data = Array(albumAndData.keys)[0]
        
        if select.tracks["Track \(data)"] != nil && select.tracks["Track \(data)"] != currentSong.toneDeafAppId {
            mediumImpactGenerator.impactOccurred()
            Utilities.showError2("Album already has a track in that position.", actionText: "OK")
            return
        }
        albumTrackArr[select.toneDeafAppId] = data
        if !songAlbumsArr.contains(select) {
            songAlbumsArr.append(select)
        } else {
            let dex = songAlbumsArr.firstIndex(of: select)
            songAlbumsArr[dex!] = select
        }
        
        if currentSong.albums == nil {
            currentSong.albums = ["\(select.toneDeafAppId)"]
        } else {
            if var arr = currentSong.albums {
                if !arr.contains(select.toneDeafAppId) {
                    arr.append("\(select.toneDeafAppId)")
                    arr.sort()
                    currentSong.albums = arr
                }
            } else {
                var arr:[String] = []
                arr.append("\(select.toneDeafAppId)")
                arr.sort()
                currentSong.albums = arr
            }
        }
        DispatchQueue.main.async {[weak self]  in
            guard let strongSelf = self else {return}
            strongSelf.songAlbumsArr.sort(by: {$0.name < $1.name})
            strongSelf.songAlbumsTableView.reloadData()
            if strongSelf.songAlbumsArr.count < 6 {
                strongSelf.songAlbumsHeightConstraint.constant = CGFloat(50*(strongSelf.songAlbumsArr.count))
            } else {
                strongSelf.songAlbumsHeightConstraint.constant = CGFloat(270)
            }
        }
        
        
        
    }
    
    @IBAction func addVideoTapped(_ sender: Any) {
        arr = "video"
        prevPage = "editSong"
        performSegue(withIdentifier: "editSongToTonesPick", sender: nil)
    }
    
    func videoAdded(_ videoAndData: [String:VideoData]) {
        lightImpactGenerator.impactOccurred(intensity: 0.75)
        let select = videoAndData[Array(videoAndData.keys)[0]]!
        let data = Array(videoAndData.keys)[0]
        
        switch data {
        case "Official Video":
            currentSong.officialVideo = select.toneDeafAppId
        case "Audio Video":
            currentSong.audioVideo = select.toneDeafAppId
        case "Lyric Video":
            currentSong.lyricVideo = select.toneDeafAppId
        default:
            break
        }
        if !songVideosArr.contains(select) {
            songVideosArr.append(select)
        } else {
            let dex = songVideosArr.firstIndex(of: select)
            songVideosArr[dex!] = select
        }
        
        if currentSong.videos == nil {
            currentSong.videos = ["\(select.toneDeafAppId)"]
        } else {
            if var arr = currentSong.videos {
                if !arr.contains(select.toneDeafAppId) {
                    arr.append("\(select.toneDeafAppId)")
                    arr.sort()
                    currentSong.videos = arr
                }
            } else {
                var arr:[String] = []
                arr.append("\(select.toneDeafAppId)")
                arr.sort()
                currentSong.videos = arr
            }
        }
        DispatchQueue.main.async {[weak self]  in
            guard let strongSelf = self else {return}
            strongSelf.songVideosArr.sort(by: {$0.title < $1.title})
            strongSelf.songVideosTableView.reloadData()
            if strongSelf.songVideosArr.count < 6 {
                strongSelf.songVideosHeightConstraint.constant = CGFloat(70*(strongSelf.songVideosArr.count))
            } else {
                strongSelf.songVideosHeightConstraint.constant = CGFloat(370)
            }
        }
        
        
        
    }
    
    @IBAction func addInstrumentalTapped(_ sender: Any) {
        arr = "instrumental"
        prevPage = "editSong"
        performSegue(withIdentifier: "editSongToTonesPick", sender: nil)
    }
    
    func instrumentalAdded(_ instrumental: InstrumentalData) {
        lightImpactGenerator.impactOccurred(intensity: 0.75)
        let select = instrumental
        if !songInstrumentalsArr.contains(select) {
            songInstrumentalsArr.append(select)
        } else {
            let dex = songInstrumentalsArr.firstIndex(of: select)
            songInstrumentalsArr[dex!] = select
        }
        
        if currentSong.instrumentals == nil {
            currentSong.instrumentals = ["\(select.toneDeafAppId)"]
        } else {
            if var arr = currentSong.instrumentals {
                if !arr.contains(select.toneDeafAppId) {
                    arr.append("\(select.toneDeafAppId)")
                    arr.sort()
                    currentSong.instrumentals = arr
                }
            } else {
                var arr:[String] = []
                arr.append("\(select.toneDeafAppId)")
                arr.sort()
                currentSong.instrumentals = arr
            }
        }
        DispatchQueue.main.async {[weak self]  in
            guard let strongSelf = self else {return}
            strongSelf.songInstrumentalsArr.sort(by: {$0.songName! < $1.songName!})
            strongSelf.songInstrumentalsTableView.reloadData()
            if strongSelf.songInstrumentalsArr.count < 6 {
                strongSelf.songInstrumentalsHeightConstraint.constant = CGFloat(50*(strongSelf.songInstrumentalsArr.count))
            } else {
                strongSelf.songInstrumentalsHeightConstraint.constant = CGFloat(270)
            }
        }
        
        
        
    }
    
    @IBAction func addRemixTapped(_ sender: Any) {
        arr = "song"
        tbsender = "remix"
        prevPage = "editSong"
        performSegue(withIdentifier: "editSongToTonesPick", sender: nil)
    }
    
    @IBAction func addOtherVersionTapped(_ sender: Any) {
        arr = "song"
        tbsender = "otherVersion"
        prevPage = "editSong"
        performSegue(withIdentifier: "editSongToTonesPick", sender: nil)
    }
    
    func songAdded(_ song: SongData) {
        lightImpactGenerator.impactOccurred(intensity: 0.75)
        let select = song
        switch tbsender {
        case "remix":
            if song.isRemix != nil {
                mediumImpactGenerator.impactOccurred()
                Utilities.showError2("Song already has a remix.", actionText: "OK")
                return
            }
            if !songRemixesArr.contains(song) {
                songRemixesArr.append(song)
            } else {
                let dex = songRemixesArr.firstIndex(of: song)
                songRemixesArr[dex!] = song
            }
            
            if currentSong.remixes == nil {
                currentSong.remixes = ["\(song.toneDeafAppId)"]
            } else {
                if var arr = currentSong.remixes {
                    if !arr.contains(song.toneDeafAppId) {
                        arr.append("\(song.toneDeafAppId)")
                        arr.sort()
                        currentSong.remixes = arr
                    }
                } else {
                    var arr:[String] = []
                    arr.append("\(song.toneDeafAppId)")
                    arr.sort()
                    currentSong.remixes = arr
                }
            }
            DispatchQueue.main.async {[weak self]  in
                guard let strongSelf = self else {return}
                strongSelf.songRemixesArr.sort(by: {$0.name < $1.name})
                strongSelf.songRemixesTableView.reloadData()
                if strongSelf.songRemixesArr.count < 6 {
                    strongSelf.songRemixesHeightConstraint.constant = CGFloat(50*(strongSelf.songRemixesArr.count))
                } else {
                    strongSelf.songRemixesHeightConstraint.constant = CGFloat(270)
                }
            }
        case "otherVersion":
            if !songOtherVersionsArr.contains(song) {
                songOtherVersionsArr.append(song)
            } else {
                let dex = songOtherVersionsArr.firstIndex(of: song)
                songOtherVersionsArr[dex!] = song
            }
            
            if currentSong.otherVersions == nil {
                currentSong.otherVersions = ["\(song.toneDeafAppId)"]
            } else {
                if var arr = currentSong.otherVersions {
                    if !arr.contains(song.toneDeafAppId) {
                        arr.append("\(song.toneDeafAppId)")
                        arr.sort()
                        currentSong.otherVersions = arr
                    }
                } else {
                    var arr:[String] = []
                    arr.append("\(song.toneDeafAppId)")
                    arr.sort()
                    currentSong.otherVersions = arr
                }
            }
            DispatchQueue.main.async {[weak self]  in
                guard let strongSelf = self else {return}
                strongSelf.songOtherVersionsArr.sort(by: {$0.name < $1.name})
                strongSelf.songOtherVersionsTableView.reloadData()
                if strongSelf.songOtherVersionsArr.count < 6 {
                    strongSelf.songOtherVersionsHeightConstraint.constant = CGFloat(50*(strongSelf.songOtherVersionsArr.count))
                } else {
                    strongSelf.songOtherVersionsHeightConstraint.constant = CGFloat(270)
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
            currentSong.spotify?.isActive = true
            GlobalFunctions.shared.verifyUrl(urlString: currentSong.spotify!.spotifySongURL, completion: {[weak self] validity in
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
                    strongSelf.currentSong.spotify?.isActive = false
                }
            })
        } else {
            spotifyStatusControl.selectedSegmentTintColor = Constants.Colors.redApp
            currentSong.spotify?.isActive = false
        }
    }
    
    @IBAction func appleMusicStatusChanged(_ sender: Any) {
        lightImpactGenerator.impactOccurred(intensity: 0.75)
        if appleMusicStatusControl.selectedSegmentIndex == 0 {
            NotificationCenter.default.post(name: adminDashboardStartSpinnerNotify, object: nil)
            appleMusicStatusControl.selectedSegmentTintColor = .systemGreen
            currentSong.apple?.isActive = true
            GlobalFunctions.shared.verifyUrl(urlString: currentSong.apple!.appleSongURL, completion: {[weak self] validity in
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
                    strongSelf.currentSong.apple?.isActive = false
                }
            })
        } else {
            appleMusicStatusControl.selectedSegmentTintColor = Constants.Colors.redApp
            currentSong.apple?.isActive = false
        }
    }
    
    @IBAction func soundcloudStatusChanged(_ sender: Any) {
        lightImpactGenerator.impactOccurred(intensity: 0.75)
        if soundcloudStatusControl.selectedSegmentIndex == 0 {
            NotificationCenter.default.post(name: adminDashboardStartSpinnerNotify, object: nil)
            soundcloudStatusControl.selectedSegmentTintColor = .systemGreen
            currentSong.soundcloud?.isActive = true
            GlobalFunctions.shared.verifyUrl(urlString: currentSong.soundcloud!.url, completion: {[weak self] validity in
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
                    strongSelf.currentSong.soundcloud?.isActive = false
                }
            })
        } else {
            soundcloudStatusControl.selectedSegmentTintColor = Constants.Colors.redApp
            currentSong.soundcloud?.isActive = false
        }
    }
    
    @IBAction func youtubeMusicStatusChanged(_ sender: Any) {
        lightImpactGenerator.impactOccurred(intensity: 0.75)
        if youtubeMusicStatusControl.selectedSegmentIndex == 0 {
            NotificationCenter.default.post(name: adminDashboardStartSpinnerNotify, object: nil)
            youtubeMusicStatusControl.selectedSegmentTintColor = .systemGreen
            currentSong.youtubeMusic?.isActive = true
            GlobalFunctions.shared.verifyUrl(urlString: currentSong.youtubeMusic!.url, completion: {[weak self] validity in
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
                    strongSelf.currentSong.youtubeMusic?.isActive = false
                }
            })
        } else {
            youtubeMusicStatusControl.selectedSegmentTintColor = Constants.Colors.redApp
            currentSong.youtubeMusic?.isActive = false
        }
    }
    
    @IBAction func amazonStatusChanged(_ sender: Any) {
        lightImpactGenerator.impactOccurred(intensity: 0.75)
        if amazonStatusControl.selectedSegmentIndex == 0 {
            NotificationCenter.default.post(name: adminDashboardStartSpinnerNotify, object: nil)
            amazonStatusControl.selectedSegmentTintColor = .systemGreen
            currentSong.amazon?.isActive = true
//            boolDict["amazon"] = true
            GlobalFunctions.shared.verifyUrl(urlString: currentSong.amazon!.url, completion: {[weak self] validity in
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
                    strongSelf.currentSong.amazon?.isActive = false
//                    strongSelf.boolDict["amazon"] = false
                }
            })
        } else {
            amazonStatusControl.selectedSegmentTintColor = Constants.Colors.redApp
            currentSong.amazon?.isActive = false
//            boolDict["amazon"] = false
        }
    }
    
    @IBAction func tidalStatusChanged(_ sender: Any) {
        lightImpactGenerator.impactOccurred(intensity: 0.75)
        if tidalStatusControl.selectedSegmentIndex == 0 {
            NotificationCenter.default.post(name: adminDashboardStartSpinnerNotify, object: nil)
            tidalStatusControl.selectedSegmentTintColor = .systemGreen
            currentSong.tidal?.isActive = true
            GlobalFunctions.shared.verifyUrl(urlString: currentSong.tidal!.url, completion: {[weak self] validity in
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
                    strongSelf.currentSong.tidal?.isActive = false
                }
            })
        } else {
            tidalStatusControl.selectedSegmentTintColor = Constants.Colors.redApp
            currentSong.tidal?.isActive = false
        }
    }
    
    @IBAction func napsterStatusChanged(_ sender: Any) {
        lightImpactGenerator.impactOccurred(intensity: 0.75)
        if napsterStatusControl.selectedSegmentIndex == 0 {
            NotificationCenter.default.post(name: adminDashboardStartSpinnerNotify, object: nil)
            napsterStatusControl.selectedSegmentTintColor = .systemGreen
            currentSong.napster?.isActive = true
            GlobalFunctions.shared.verifyUrl(urlString: currentSong.napster!.url, completion: {[weak self] validity in
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
                    strongSelf.currentSong.napster?.isActive = false
                }
            })
        } else {
            napsterStatusControl.selectedSegmentTintColor = Constants.Colors.redApp
            currentSong.napster?.isActive = false
        }
    }
    
    @IBAction func spinrillaStatusChanged(_ sender: Any) {
        lightImpactGenerator.impactOccurred(intensity: 0.75)
        if spinrillaStatusControl.selectedSegmentIndex == 0 {
            NotificationCenter.default.post(name: adminDashboardStartSpinnerNotify, object: nil)
            spinrillaStatusControl.selectedSegmentTintColor = .systemGreen
            currentSong.spinrilla?.isActive = true
            GlobalFunctions.shared.verifyUrl(urlString: currentSong.spinrilla!.url, completion: {[weak self] validity in
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
                    strongSelf.currentSong.spinrilla?.isActive = false
                }
            })
        } else {
            spinrillaStatusControl.selectedSegmentTintColor = Constants.Colors.redApp
            currentSong.spinrilla?.isActive = false
        }
    }
    
    @IBAction func deezerStatusChanged(_ sender: Any) {
        lightImpactGenerator.impactOccurred(intensity: 0.75)
        if deezerStatusControl.selectedSegmentIndex == 0 {
            NotificationCenter.default.post(name: adminDashboardStartSpinnerNotify, object: nil)
            deezerStatusControl.selectedSegmentTintColor = .systemGreen
            currentSong.deezer?.isActive = true
            GlobalFunctions.shared.verifyUrl(urlString: currentSong.deezer!.url, completion: {[weak self] validity in
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
                    strongSelf.currentSong.deezer?.isActive = false
                }
            })
        } else {
            deezerStatusControl.selectedSegmentTintColor = Constants.Colors.redApp
            currentSong.deezer?.isActive = false
        }
    }
    
    @IBAction func changeVerificationLevelTapped(_ sender: Any) {
        let alertC = UIAlertController(title: "Change Verification Level",
                                                message: "Select a Level.",
                                                preferredStyle: .alert)
        let aAction = UIAlertAction(title: "A Level", style: .default, handler: {[weak self] _ in
            guard let strongSelf = self else {return}
            strongSelf.currentSong.verificationLevel = "A"
            strongSelf.verificationLabel.text = String(strongSelf.currentSong.verificationLevel!)
            strongSelf.verificationLabel.textColor = .green
                alertC.dismiss(animated: true, completion: nil)
        })
        let bAction = UIAlertAction(title: "B Level", style: .default, handler: {[weak self] _ in
            guard let strongSelf = self else {return}
            strongSelf.currentSong.verificationLevel = "B"
            strongSelf.verificationLabel.text = String(strongSelf.currentSong.verificationLevel!)
            strongSelf.verificationLabel.textColor = .green
                alertC.dismiss(animated: true, completion: nil)
        })
        let cAction = UIAlertAction(title: "C Level", style: .default, handler: {[weak self] _ in
            guard let strongSelf = self else {return}
            strongSelf.currentSong.verificationLevel = "C"
            strongSelf.verificationLabel.text = String(strongSelf.currentSong.verificationLevel!)
            strongSelf.verificationLabel.textColor = .green
                alertC.dismiss(animated: true, completion: nil)
        })
        let uAction = UIAlertAction(title: "U Level", style: .default, handler: {[weak self] _ in
            guard let strongSelf = self else {return}
            strongSelf.currentSong.verificationLevel = "U"
            strongSelf.verificationLabel.text = String(strongSelf.currentSong.verificationLevel!)
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
    
    @IBAction func explicityChanged(_ sender: Any) {
        lightImpactGenerator.impactOccurred(intensity: 0.75)
        if explicityControl.selectedSegmentIndex == 0 {
            explicityControl.selectedSegmentTintColor = .systemGreen
            currentSong.explicit = true
        } else {
            explicityControl.selectedSegmentTintColor = Constants.Colors.redApp
            currentSong.explicit = false
        }
    }
    
    @IBAction func remixChanged(_ sender: Any) {
        lightImpactGenerator.impactOccurred(intensity: 0.75)
        if remixControl.selectedSegmentIndex == 0 {
            remixControl.selectedSegmentTintColor = .systemGreen
            currentSong.isRemix = SongRemixData(standardEdition: nil, status: true)
            remixOfStackView.isHidden = false
            //true
        } else {
            remixControl.selectedSegmentTintColor = Constants.Colors.redApp
            currentSong.isRemix = nil
            remixOfTextField.text = ""
            //false
            remixOfStackView.isHidden = true
        }
    }
    
    @IBAction func otherVersionChanged(_ sender: Any) {
        lightImpactGenerator.impactOccurred(intensity: 0.75)
        if otherVersionControl.selectedSegmentIndex == 0 {
            otherVersionControl.selectedSegmentTintColor = .systemGreen
            currentSong.isOtherVersion = SongOtherVersionData(standardEdition: nil, status: true)
            otherVersionOfStackView.isHidden = false
            //true
        } else {
            otherVersionControl.selectedSegmentTintColor = Constants.Colors.redApp
            currentSong.isOtherVersion = nil
            otherVersionOfTextField.text = ""
            //false
            otherVersionOfStackView.isHidden = true
        }
    }
    
    @IBAction func industryCertifiedChanged(_ sender: Any) {
        lightImpactGenerator.impactOccurred(intensity: 0.75)
        if industryCertifiedControl.selectedSegmentIndex == 0 {
            industryCertifiedControl.selectedSegmentTintColor = .systemGreen
            currentSong.industryCerified = true
        } else {
            industryCertifiedControl.selectedSegmentTintColor = Constants.Colors.redApp
            currentSong.industryCerified = false
        }
    }
    
    @IBAction func songStatusChanged(_ sender: Any) {
        lightImpactGenerator.impactOccurred(intensity: 0.75)
        if songStatusControl.selectedSegmentIndex == 0 {
            songStatusControl.selectedSegmentTintColor = .systemGreen
            currentSong.isActive = true
        } else {
            songStatusControl.selectedSegmentTintColor = Constants.Colors.redApp
            currentSong.isActive = false
        }
    }
    
    //MARK: - Update Tapped
    @IBAction func updateSongTapped(_ sender: Any) {
        let newDict = [
            "spotify":currentSong.spotify?.isActive,
            "apple":currentSong.apple?.isActive,
            "soundcloud":currentSong.soundcloud?.isActive,
            "youtubemusic":currentSong.youtubeMusic?.isActive,
            "amazon":currentSong.amazon?.isActive,
            "deezer":currentSong.deezer?.isActive,
            "tidal":currentSong.tidal?.isActive,
            "napster":currentSong.napster?.isActive,
            "spinrilla":currentSong.spinrilla?.isActive
        ]
        var newURLDict = [
            "spotify":currentSong.spotify?.spotifySongURL,
            "apple":currentSong.apple?.appleSongURL,
            "soundcloud":currentSong.soundcloud?.url,
            "youtubemusic":currentSong.youtubeMusic?.url,
            "amazon":currentSong.amazon?.url,
            "deezer":currentSong.deezer?.url,
            "tidal":currentSong.tidal?.url,
            "napster":currentSong.napster?.url,
            "spinrilla":currentSong.spinrilla?.url
        ].compactMapValues { $0 }
        if currentSong.deezer?.url == nil {
            urlDict["deezer"] = nil
        }
        urlDict = urlDict.compactMapValues { $0 }
        urlDict = urlDict.removeNullsFromDictionary()
        
//        print(String(data: try! JSONSerialization.data(withJSONObject: urlDict, options: .prettyPrinted), encoding: .utf8)!)
//        print(String(data: try! JSONSerialization.data(withJSONObject: newURLDict, options: .prettyPrinted), encoding: .utf8)!)
        print(currentSong == initialSong, newDict == boolDict, newURLDict == urlDict, initAlbumTrackArr == albumTrackArr, remixOf == currentSong.isRemix?.standardEdition, otherVersionsOf == currentSong.isOtherVersion?.standardEdition)
//        print(currentSong == initialSong)
        
        //MARK: - Error Count
        errorCountForController = 0
        if songArtistsArr.isEmpty {
            errorCountForController+=1
        }
        if songProducersArr.isEmpty {
            errorCountForController+=1
        }
        
        guard errorCountForController == 0 else {
            mediumImpactGenerator.impactOccurred()
            Utilities.showError2("Please correct all errors before proceeding.", actionText: "OK")
            return
        }
        
        if currentSong == initialSong && newDict == boolDict && newURLDict == urlDict && initAlbumTrackArr == albumTrackArr && remixOf == currentSong.isRemix?.standardEdition && otherVersionsOf == currentSong.isOtherVersion?.standardEdition {
            mediumImpactGenerator.impactOccurred()
            Utilities.showError2("Song already up to date.", actionText: "OK")
            return
        }
        
        //MARK: - Continue To Upload
        alertView = UIAlertController(title: "Updating \(songName.text!)", message: "Preparing...", preferredStyle: .alert)
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
        
        let queue = DispatchQueue(label: "myhjvkheditingQsongsssseue")
        let group = DispatchGroup()
        let array = [2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29]
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
                    strongSelf.processArtists(completion: {err in
                        if let error = err {
                            mediumImpactGenerator.impactOccurred()
                            DispatchQueue.main.async {
                                Utilities.showError2("Artist Proccessing Failed: \(error)", actionText: "OK")
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
                    strongSelf.processRemixes(completion: {err in
                        if let error = err {
                            mediumImpactGenerator.impactOccurred()
                            DispatchQueue.main.async {
                                Utilities.showError2("Remix Proccessing Failed: \(error)", actionText: "OK")
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
                    strongSelf.processOtherVersions(completion: {err in
                        if let error = err {
                            mediumImpactGenerator.impactOccurred()
                            DispatchQueue.main.async {
                                Utilities.showError2("Other Versions Proccessing Failed: \(error)", actionText: "OK")
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
                    strongSelf.processAlbums(completion: {err in
                        if let errors = err {
                            mediumImpactGenerator.impactOccurred()
                            for error in errors {
                                DispatchQueue.main.async {
                                    Utilities.showError2("Albums Proccessing Failed: \(error)", actionText: "OK")
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
                case 24:
                    strongSelf.uploadCompletionStatus24 = false
                    strongSelf.processExplicity(completion: {err in
                        if let error = err {
                            mediumImpactGenerator.impactOccurred()
                            DispatchQueue.main.async {
                                Utilities.showError2("Explicity Proccessing Failed: \(error)", actionText: "OK")
                            }
                            strongSelf.uploadCompletionStatus24 = false
                        } else {
                            strongSelf.progressCompleted+=1
                            DispatchQueue.main.async {
                                strongSelf.progressView.progress = (strongSelf.progressCompleted/strongSelf.totalProgress)
                                print("\(strongSelf.progressCompleted) out of \(strongSelf.totalProgress)")
                            }
                            strongSelf.uploadCompletionStatus24 = true
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
                                Utilities.showError2("Verification Proccessing Failed: \(error)", actionText: "OK")
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
                    strongSelf.processIsRemixes(completion: {err in
                        if let error = err {
                            mediumImpactGenerator.impactOccurred()
                            DispatchQueue.main.async {
                                Utilities.showError2("Is Remix Proccessing Failed: \(error)", actionText: "OK")
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
                default:
                    print("Edit Song error")
                }
            }
        }
        
        group.notify(queue: DispatchQueue.main) { [weak self] in
            guard let strongSelf = self else {return}
            if strongSelf.uploadCompletionStatus1 == false || strongSelf.uploadCompletionStatus2 == false || strongSelf.uploadCompletionStatus3 == false || strongSelf.uploadCompletionStatus4 == false || strongSelf.uploadCompletionStatus5 == false || strongSelf.uploadCompletionStatus6 == false || strongSelf.uploadCompletionStatus7 == false || strongSelf.uploadCompletionStatus8 == false || strongSelf.uploadCompletionStatus9 == false || strongSelf.uploadCompletionStatus10 == false || strongSelf.uploadCompletionStatus11 == false || strongSelf.uploadCompletionStatus12 == false || strongSelf.uploadCompletionStatus13 == false || strongSelf.uploadCompletionStatus14 == false || strongSelf.uploadCompletionStatus15 == false || strongSelf.uploadCompletionStatus16 == false || strongSelf.uploadCompletionStatus17 == false || strongSelf.uploadCompletionStatus18 == false || strongSelf.uploadCompletionStatus19 == false || strongSelf.uploadCompletionStatus20 == false || strongSelf.uploadCompletionStatus21 == false || strongSelf.uploadCompletionStatus22 == false || strongSelf.uploadCompletionStatus23 == false || strongSelf.uploadCompletionStatus24 == false || strongSelf.uploadCompletionStatus25 == false || strongSelf.uploadCompletionStatus26 == false || strongSelf.uploadCompletionStatus27 == false {
                strongSelf.alertView.dismiss(animated: true, completion: nil)
                
//                EditSongHelper.shared.cancelUpdate(initialSong: strongSelf.initialSong,currentSong: strongSelf.currentSong, initialStatus: strongSelf.boolDict as NSDictionary, currentStatus: dict, initialURL: strongSelf.urlDict as NSDictionary, currentURL: urldict , completion: { err in
//                    strongSelf.alertView.dismiss(animated: true, completion: nil)
//                    if let error = err {
//                        DispatchQueue.main.async {
                            Utilities.showError2("Cancellation of Song Edit Failed, check database now: \("error")", actionText: "OK")
//                        }
//                        _ = strongSelf.navigationController?.popViewController(animated: true)
//                    }
//                    return
//                })
            } else {
                print("📗 Song data updated to database successfully.")
                strongSelf.alertView.dismiss(animated: true, completion: {
                    Utilities.successBarBanner("Update successful.")
                    _ = strongSelf.navigationController?.popViewController(animated: true)
                })
            }
        }
    }
    
    func processImages(completion: @escaping ((Error?) -> Void)) {
        guard currentSong.manualImageURL != initialSong.manualImageURL else {
            completion(nil)
            return
        }
        if currentSong.manualImageURL != nil && currentSong.manualImageURL != "" {
            guard newImage != nil else {
                completion(SongEditorError.imageUpdateError("Image must not be empty"))
                return
            }
        }
        EditSongHelper.shared.processImage(initialSong: initialSong, currentSong: currentSong, image: newImage, completion: {[weak self] err in
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
        guard currentSong.manualPreviewURL != initialSong.manualPreviewURL else {
            completion(nil)
            return
        }
//        if currentSong.manualPreviewURL == nil {
//            completion(nil)
//            return
//        }
        EditSongHelper.shared.processPreview(initialSong: initialSong, currentSong: currentSong, audio: newPreview, completion: {[weak self] err in
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
        guard currentSong.name != initialSong.name else {
            completion(nil)
            return
        }
        EditSongHelper.shared.processName(initialSong: initialSong,currentSong: currentSong, completion: {[weak self] err in
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
    
    func processArtists(completion: @escaping (([Error]?) -> Void)) {
        guard currentSong.songArtist.sorted() != initialSong.songArtist.sorted() else {
            completion(nil)
            return
        }
        EditSongHelper.shared.processArtists(initialSong: initialSong,currentSong: currentSong, completion: {[weak self] err in
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
        guard currentSong.songProducers.sorted() != initialSong.songProducers.sorted() else {
            completion(nil)
            return
        }
        EditSongHelper.shared.processProducers(initialSong: initialSong,currentSong: currentSong, completion: {[weak self] err in
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
        guard let _ = currentSong.songWriters else {
            completion(nil)
            return
        }
        guard currentSong.songWriters!.sorted() != initialSong.songWriters?.sorted() else {
            completion(nil)
            return
        }
        EditSongHelper.shared.processWriters(initialSong: initialSong,currentSong: currentSong, completion: {[weak self] err in
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
        guard let _ = currentSong.songMixEngineer else {
            completion(nil)
            return
        }
        guard currentSong.songMixEngineer!.sorted() != initialSong.songMixEngineer?.sorted() else {
            completion(nil)
            return
        }
        EditSongHelper.shared.processMixEngineers(initialSong: initialSong,currentSong: currentSong, completion: {[weak self] err in
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
        guard let _ = currentSong.songMasteringEngineer else {
            completion(nil)
            return
        }
        guard currentSong.songMasteringEngineer!.sorted() != initialSong.songMasteringEngineer?.sorted() else {
            completion(nil)
            return
        }
        EditSongHelper.shared.processMasteringEngineers(initialSong: initialSong,currentSong: currentSong, completion: {[weak self] err in
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
        guard let _ = currentSong.songRecordingEngineer else {
            completion(nil)
            return
        }
        guard currentSong.songRecordingEngineer!.sorted() != initialSong.songRecordingEngineer?.sorted() else {
            completion(nil)
            return
        }
        EditSongHelper.shared.processRecordingEngineers(initialSong: initialSong,currentSong: currentSong, completion: {[weak self] err in
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
        
        guard currentSong.spotify?.spotifySongURL != initialSong.spotify?.spotifySongURL || (dict["spotify"] as? Bool) != boolDict["spotify"] || urlDict["spotify"] != (urldict["spotify"] as? String) else {
            completion(nil)
            return
        }
        
        EditSongHelper.shared.processSpotify(initialSong: initialSong,currentSong: currentSong, initialStatus: boolDict["spotify"] as? Bool, currentStatus: (dict["spotify"] as? Bool), initialURL: urlDict["spotify"] as? String, currentURL: (urldict["spotify"] as? String), completion: {[weak self] err in
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
        
        guard currentSong.apple?.appleSongURL != initialSong.apple?.appleSongURL || (dict["apple"] as? Bool) != boolDict["apple"] || urlDict["apple"] != (urldict["apple"] as? String) else {
            completion(nil)
            return
        }
        
        EditSongHelper.shared.processAppleMusic(initialSong: initialSong,currentSong: currentSong, initialStatus: boolDict["apple"] as? Bool, currentStatus: (dict["apple"] as? Bool), initialURL: urlDict["apple"] as? String, currentURL: (urldict["apple"] as? String), completion: {[weak self] err in
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
        
        guard currentSong.soundcloud?.url != initialSong.soundcloud?.url || (dict["soundcloud"] as? Bool) != boolDict["soundcloud"] || urlDict["soundcloud"] != (urldict["soundcloud"] as? String) else {
            completion(nil)
            return
        }
        
        EditSongHelper.shared.processSoundcloud(initialSong: initialSong,currentSong: currentSong, initialStatus: boolDict["soundcloud"] as? Bool, currentStatus: (dict["soundcloud"] as? Bool), initialURL: urlDict["soundcloud"] as? String, currentURL: (urldict["soundcloud"] as? String), completion: {[weak self] err in
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
        
        guard currentSong.youtubeMusic?.url != initialSong.youtubeMusic?.url || (dict["youtubemusic"] as? Bool) != boolDict["youtubemusic"] || urlDict["youtubemusic"] != (urldict["youtubemusic"] as? String) else {
            completion(nil)
            return
        }
        
        EditSongHelper.shared.processYoutubeMusic(initialSong: initialSong,currentSong: currentSong, initialStatus: boolDict["youtubemusic"] as? Bool, currentStatus: (dict["youtubemusic"] as? Bool), initialURL: urlDict["youtubemusic"] as? String, currentURL: (urldict["youtubemusic"] as? String), completion: {[weak self] err in
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
        
        guard currentSong.amazon?.url != initialSong.amazon?.url || (dict["amazon"] as? Bool) != boolDict["amazon"] || urlDict["amazon"] != (urldict["amazon"] as? String) else {
            completion(nil)
            return
        }
        
        EditSongHelper.shared.processAmazon(initialSong: initialSong,currentSong: currentSong, initialStatus: boolDict["amazon"] as? Bool, currentStatus: (dict["amazon"] as? Bool), initialURL: urlDict["amazon"] as? String, currentURL: (urldict["amazon"] as? String), completion: {[weak self] err in
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
        
        guard currentSong.deezer?.url != initialSong.deezer?.url || (dict["deezer"] as? Bool) != boolDict["deezer"] || urlDict["deezer"] != (urldict["deezer"] as? String) else {
            completion(nil)
            return
        }
        
        EditSongHelper.shared.processDeezer(initialSong: initialSong,currentSong: currentSong, initialStatus: boolDict["deezer"] as? Bool, currentStatus: (dict["deezer"] as? Bool), initialURL: urlDict["deezer"] as? String, currentURL: (urldict["deezer"] as? String), completion: {[weak self] err in
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
        
        guard currentSong.tidal?.url != initialSong.tidal?.url || (dict["tidal"] as? Bool) != boolDict["tidal"] || urlDict["tidal"] != (urldict["tidal"] as? String) else {
            completion(nil)
            return
        }
        
        EditSongHelper.shared.processTidal(initialSong: initialSong,currentSong: currentSong, initialStatus: boolDict["tidal"] as? Bool, currentStatus: (dict["tidal"] as? Bool), initialURL: urlDict["tidal"] as? String, currentURL: (urldict["tidal"] as? String), completion: {[weak self] err in
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
        
        guard currentSong.napster?.url != initialSong.napster?.url || (dict["napster"] as? Bool) != boolDict["napster"] || urlDict["napster"] != (urldict["napster"] as? String) else {
            completion(nil)
            return
        }
        
        EditSongHelper.shared.processNapster(initialSong: initialSong,currentSong: currentSong, initialStatus: boolDict["napster"] as? Bool, currentStatus: (dict["napster"] as? Bool), initialURL: urlDict["napster"] as? String, currentURL: (urldict["napster"] as? String), completion: {[weak self] err in
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
        
        guard currentSong.spinrilla?.url != initialSong.spinrilla?.url || (dict["spinrilla"] as? Bool) != boolDict["spinrilla"] || urlDict["spinrilla"] != (urldict["spinrilla"] as? String) else {
            completion(nil)
            return
        }
        
        EditSongHelper.shared.processSpinrilla(initialSong: initialSong,currentSong: currentSong, initialStatus: boolDict["spinrilla"] as? Bool, currentStatus: (dict["spinrilla"] as? Bool), initialURL: urlDict["spinrilla"] as? String, currentURL: (urldict["spinrilla"] as? String), completion: {[weak self] err in
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
    
    func processAlbums(completion: @escaping (([Error]?) -> Void)) {
        if currentSong.albums == nil && initialSong.albums == nil {
            completion(nil)
            return
        }
        
        if currentSong.albums == initialSong.albums && initAlbumTrackArr == albumTrackArr {
            completion(nil)
            return
        }
        
//        if initAlbumTrackArr == albumTrackArr {
//            completion(nil)
//            return
//        }
        
        EditSongHelper.shared.processAlbums(initialSong: initialSong,currentSong: currentSong, initAlbumTrackArr: initAlbumTrackArr as NSDictionary, albumTrackArr: albumTrackArr as NSDictionary, completion: {[weak self] err in
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
        if currentSong.videos == nil && initialSong.videos == nil {
            completion(nil)
            return
        }
        if currentSong.videos == initialSong.videos && currentSong.officialVideo == initialSong.officialVideo && currentSong.audioVideo == initialSong.audioVideo && currentSong.lyricVideo == initialSong.lyricVideo {
            completion(nil)
            return
        }
        
        EditSongHelper.shared.processVideos(initialSong: initialSong,currentSong: currentSong, completion: {[weak self] err in
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
        if currentSong.instrumentals == nil && initialSong.instrumentals == nil {
            completion(nil)
            return
        }
        if currentSong.instrumentals == initialSong.instrumentals {
            completion(nil)
            return
        }
    
        
        EditSongHelper.shared.processInstrumentals(initialSong: initialSong,currentSong: currentSong, completion: {[weak self] err in
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
    
    func processRemixes(completion: @escaping (([Error]?) -> Void)) {
        if currentSong.remixes == nil && initialSong.remixes == nil {
            completion(nil)
            return
        }
        if currentSong.remixes == initialSong.remixes {
            completion(nil)
            return
        }
    
        
        EditSongHelper.shared.processRemixes(initialSong: initialSong,currentSong: currentSong, completion: {[weak self] err in
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
        if currentSong.otherVersions == nil && initialSong.otherVersions == nil {
            completion(nil)
            return
        }
        if currentSong.otherVersions == initialSong.otherVersions {
            completion(nil)
            return
        }
    
        
        EditSongHelper.shared.processOtherVersions(initialSong: initialSong,currentSong: currentSong, completion: {[weak self] err in
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
    
    func processIsRemixes(completion: @escaping (([Error]?) -> Void)) {
        if currentSong.isRemix == nil && initialSong.isRemix == nil {
            completion(nil)
            return
        }
        if currentSong.isRemix == initialSong.isRemix && remixOf == currentSong.isRemix?.standardEdition {
            completion(nil)
            return
        }
    
        
        EditSongHelper.shared.processIsRemixes(initialSong: initialSong,currentSong: currentSong, initSE: remixOf, completion: {[weak self] err in
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
        if currentSong.isOtherVersion == nil && initialSong.isOtherVersion == nil {
            completion(nil)
            return
        }
        if currentSong.isOtherVersion == initialSong.isOtherVersion && otherVersionsOf == currentSong.isOtherVersion?.standardEdition {
            completion(nil)
            return
        }
    
        
        EditSongHelper.shared.processIsOtherVersions(initialSong: initialSong,currentSong: currentSong, initSE: otherVersionsOf, completion: {[weak self] err in
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
        guard currentSong.verificationLevel != initialSong.verificationLevel else {
            completion(nil)
            return
        }
        EditSongHelper.shared.processVerificationLevel(initialSong: initialSong,currentSong: currentSong, completion: {[weak self] err in
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
    
    func processExplicity(completion: @escaping ((Error?) -> Void)) {
        guard currentSong.explicit != initialSong.explicit else {
            completion(nil)
            return
        }
        EditSongHelper.shared.processExplicity(initialSong: initialSong,currentSong: currentSong, completion: {[weak self] err in
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
        guard currentSong.industryCerified != initialSong.industryCerified else {
            completion(nil)
            return
        }
        EditSongHelper.shared.processIndustryCertification(initialSong: initialSong,currentSong: currentSong, completion: {[weak self] err in
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
        guard currentSong.isActive != initialSong.isActive else {
            completion(nil)
            return
        }
        EditSongHelper.shared.processStatus(initialSong: initialSong,currentSong: currentSong, completion: {[weak self] err in
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
        if segue.identifier == "editSongToTonesPick" {
            if let viewController: SelectTonesPickItemViewController = segue.destination as? SelectTonesPickItemViewController {
                viewController.array = arr
                viewController.prevPage = prevPage
                if prevPage == "editSong" {
                    switch arr {
                    case "video":
                        viewController.exeptions = songVideosArr
                        viewController.editSongVideosDelegate = self
                    case "album":
                        viewController.exeptions = songAlbumsArr
                        viewController.editSongAlbumsDelegate = self
                    case "person":
                        switch tbsender {
                        case "artist":
                            viewController.exeptions = songArtistsArr
                            viewController.editSongPersonsDelegate = self
                        case "producer":
                            viewController.exeptions = songProducersArr
                            viewController.editSongPersonsDelegate = self
                        case "writer":
                            viewController.exeptions = songWritersArr
                            viewController.editSongPersonsDelegate = self
                        case "mixEngineer":
                            viewController.exeptions = songMixEngineerArr
                            viewController.editSongPersonsDelegate = self
                        case "masteringEngineer":
                            viewController.exeptions = songMasteringEngineerArr
                            viewController.editSongPersonsDelegate = self
                        case "recordingEngineer":
                            viewController.exeptions = songRecordingEngineerArr
                            viewController.editSongPersonsDelegate = self
                        default:
                            break
                        }
                    case "instrumental":
                        viewController.exeptions = songInstrumentalsArr
                        viewController.editSongInstrumentalsDelegate = self
                    case "song":
                        switch tbsender {
                        case "remix":
                            viewController.exeptions = songRemixesArr
                            viewController.editSongSongsDelegate = self
                        case "otherVersion":
                            viewController.exeptions = songOtherVersionsArr
                            viewController.editSongSongsDelegate = self
                        default:
                            break
                        }
                    default:
                        break
                    }
                }
                if prevPage == "editSongAll" {
                    viewController.editSongAllSongsDelegate = self
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
        songName.textColor = .white
        songImageURL.textColor = .white
        songPreviewURL.textColor = .white
        setUpPage()
        view.endEditing(true)
    }
    
    @objc func dismissKeyboard3() {
        currentSong.isRemix!.standardEdition = remixHold[0]
        remixOfTextField.text = "\(remixHold[1]) - \(remixHold[0])"
        view.endEditing(true)
    }
    
    @objc func dismissKeyboard4() {
        currentSong.isOtherVersion!.standardEdition = otherVersionsHold[0]
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

extension EditSongViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func presentPhotoActionSheet() {
        let actionSheet = UIAlertController(title: "Open photo library?", message: nil, preferredStyle: .alert)
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
        
        songImage.image = selectedImage
        songImageURL.text = "New Image Selected"
        songImageURL.textColor = .green
        newImage = selectedImage
        currentSong.manualImageURL = "NEW"
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
}

extension EditSongViewController: UIDocumentPickerDelegate {
    
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
            songPreviewURL.text = newPreview!.lastPathComponent as String
            songPreviewURL.textColor = .green
            currentSong.manualPreviewURL = "NEW"
        }
        else {
            do {
                try FileManager.default.copyItem(at: newPreview!, to: sandboxFileURL)
                songPreviewURL.text = newPreview!.lastPathComponent as String
                songPreviewURL.textColor = .green
                currentSong.manualPreviewURL = "NEW"
            }
            catch {
                print("Error: \(error)")
            }
        }
    }
    
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        
    }
}

extension EditSongViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        var nor = 0
        if pickerView == songPickerView {
            nor = allSongs.count
        }
        switch pickerView {
        case remixOfPickerView:
            nor = allSongs.count
        case otherVersionOfPickerView:
            nor = allSongs.count
        default:
            break
        }
        return nor
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        var nor = ""
        if pickerView == songPickerView {
            nor = "\(allSongs[row].name) -- \(allSongs[row].toneDeafAppId)"
        }
        switch pickerView {
        case remixOfPickerView:
            nor = "\(allSongs[row].name) -- \(allSongs[row].toneDeafAppId)"
        case otherVersionOfPickerView:
            nor = "\(allSongs[row].name) -- \(allSongs[row].toneDeafAppId)"
        default:
            break
        }
        return nor
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == songPickerView {
//        pickerSelected(row: row, pickerView: pickerView)
        }
        switch pickerView {
        case remixOfPickerView:
            remixHold = [allSongs[row].toneDeafAppId, allSongs[row].name]
        case otherVersionOfPickerView:
            otherVersionsHold = [allSongs[row].toneDeafAppId, allSongs[row].name]
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
        if pickerView == songPickerView {
           doneButton = UIBarButtonItem(title: "Select", style: UIBarButtonItem.Style.done, target: self, action: #selector(dismissKeyboard2))
        }
        if pickerView == remixOfPickerView {
           doneButton = UIBarButtonItem(title: "Select", style: UIBarButtonItem.Style.done, target: self, action: #selector(dismissKeyboard3))
        }
        if pickerView == otherVersionOfPickerView {
           doneButton = UIBarButtonItem(title: "Select", style: UIBarButtonItem.Style.done, target: self, action: #selector(dismissKeyboard4))
        }
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItem.Style.plain, target: self, action: #selector(dismissKeyboard))

        if currentSong == nil {
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

extension EditSongViewController : UITableViewDataSource, UITableViewDelegate {
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
        DatabaseManager.shared.findInstrumentalById(instrumentalId: instrumentalIdFull, completion: { result in
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
        case songArtistsTableView:
            return songArtistsArr.count
        case songProducersTableView:
            return songProducersArr.count
        case songWritersTableView:
            return songWritersArr.count
        case songMixEngineerTableView:
            return songMixEngineerArr.count
        case songMasteringEngineerTableView:
            return songMasteringEngineerArr.count
        case songRecordingEngineerTableView:
            return songRecordingEngineerArr.count
        case songAlbumsTableView:
            return songAlbumsArr.count
        case songVideosTableView:
            return songVideosArr.count
        case songInstrumentalsTableView:
            return songInstrumentalsArr.count
        case songRemixesTableView:
            return songRemixesArr.count
        case songOtherVersionsTableView:
            return songOtherVersionsArr.count
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch tableView {
        case songArtistsTableView:
            let cell = tableView.dequeueReusableCell(withIdentifier: "roleEditSongCell", for: indexPath) as! RoleEditSongCell
            if !songArtistsArr.isEmpty {

                cell.setUp(person: songArtistsArr[indexPath.row])
            }
            return cell
        case songProducersTableView:
            let cell = tableView.dequeueReusableCell(withIdentifier: "roleEditSongCell", for: indexPath) as! RoleEditSongCell
            if !songProducersArr.isEmpty {

                cell.setUp(person: songProducersArr[indexPath.row])
            }
            return cell
        case songWritersTableView:
            let cell = tableView.dequeueReusableCell(withIdentifier: "roleEditSongCell", for: indexPath) as! RoleEditSongCell
            if !songWritersArr.isEmpty {

                cell.setUp(person: songWritersArr[indexPath.row])
            }
            return cell
        case songMixEngineerTableView:
            let cell = tableView.dequeueReusableCell(withIdentifier: "roleEditSongCell", for: indexPath) as! RoleEditSongCell
            if !songMixEngineerArr.isEmpty {

                cell.setUp(person: songMixEngineerArr[indexPath.row])
            }
            return cell
        case songMasteringEngineerTableView:
            let cell = tableView.dequeueReusableCell(withIdentifier: "roleEditSongCell", for: indexPath) as! RoleEditSongCell
            if !songMasteringEngineerArr.isEmpty {

                cell.setUp(person: songMasteringEngineerArr[indexPath.row])
            }
            return cell
        case songRecordingEngineerTableView:
            let cell = tableView.dequeueReusableCell(withIdentifier: "roleEditSongCell", for: indexPath) as! RoleEditSongCell
            if !songRecordingEngineerArr.isEmpty {
                cell.setUp(person: songRecordingEngineerArr[indexPath.row])
            }
            return cell
        case songAlbumsTableView:
            let cell = tableView.dequeueReusableCell(withIdentifier: "editPersonAlbumCell", for: indexPath) as! EditPersonAlbumCell
            if !songAlbumsArr.isEmpty {
//                let num =
                cell.setUp(album: songAlbumsArr[indexPath.row], trackNum: albumTrackArr[songAlbumsArr[indexPath.row].toneDeafAppId])
            }
            return cell
        case songVideosTableView:
            let cell = tableView.dequeueReusableCell(withIdentifier: "editPersonVideoCell", for: indexPath) as! EditPersonVideoCell
            if !songVideosArr.isEmpty {
                cell.setUp(video: songVideosArr[indexPath.row], song: currentSong)
            }
            return cell
        case songInstrumentalsTableView:
            let cell = tableView.dequeueReusableCell(withIdentifier: "editPersonInstrumentalCell", for: indexPath) as! EditPersonInstrumentalCell
            if !songInstrumentalsArr.isEmpty {
                //print(personSongsArr[indexPath.row].songArtist, personSongsArr[indexPath.row].songProducers)
                cell.setUp(instrumental: songInstrumentalsArr[indexPath.row], artistId: currentSong.toneDeafAppId)
            }
            return cell
        case songRemixesTableView:
            let cell = tableView.dequeueReusableCell(withIdentifier: "roleEditSongCell", for: indexPath) as! RoleEditSongCell
            if !songRemixesArr.isEmpty {
                cell.setUp(song: songRemixesArr[indexPath.row], artistId: currentSong.toneDeafAppId)
            }
            return cell
        case songOtherVersionsTableView:
            let cell = tableView.dequeueReusableCell(withIdentifier: "roleEditSongCell", for: indexPath) as! RoleEditSongCell
            if !songOtherVersionsArr.isEmpty {
                cell.setUp(song: songOtherVersionsArr[indexPath.row], artistId: currentSong.toneDeafAppId)
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
        case songAlbumsTableView:
            alertController = UIAlertController(title: "Change Track Number",
                                                message: "Enter track number for \(currentSong.name) (Leave blank if song is not in tracklist)",
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
                            if strongSelf.songAlbumsArr[indexPath.row].tracks["Track \(track)"] != nil {
                                mediumImpactGenerator.impactOccurred()
                                Utilities.showError2("Album already has a track in that position.", actionText: "OK")
                            } else {
                                strongSelf.albumTrackArr[strongSelf.songAlbumsArr[indexPath.row].toneDeafAppId] = String(track)
                                strongSelf.songAlbumsTableView.reloadData()
                            }
                            alertController.dismiss(animated: true, completion: nil)
                        }
                    } else {
                        strongSelf.albumTrackArr[strongSelf.songAlbumsArr[indexPath.row].toneDeafAppId] = nil
                        strongSelf.songAlbumsTableView.reloadData()
                        alertController.dismiss(animated: true, completion: nil)
                    }
                } else {
                    strongSelf.albumTrackArr[strongSelf.songAlbumsArr[indexPath.row].toneDeafAppId] = nil
                    strongSelf.songAlbumsTableView.reloadData()
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
            alertController.view.tintColor = Constants.Colors.redApp

            
            alertController.view.tintColor = UIColor.init(red: 182/255, green: 0/255, blue: 3/255, alpha: 1)
            self.present(alertController, animated: true)
            {
                // ...
            }
        case songVideosTableView:
            alertController = UIAlertController(title: "Change \(songVideosArr[indexPath.row].title) Relationship",
                                                    message: "Select the videos relationship to the song",
                                                    preferredStyle: .alert)
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc3 = storyboard.instantiateViewController(identifier: "editPersonRolesPopoverTableViewController") as
            EditPersonRolesPopoverTableViewController
            vc3.preferredContentSize = CGSize(width: 350, height: 240)
            vc3.tableView.isScrollEnabled = false
            alertController.setValue(vc3, forKey: "contentViewController")
            vc3.roleArr = ["Official Video","Audio Video","Lyric Video", "Other Video"]
            vc3.tableView.reloadData()
            
            let addAction = UIAlertAction(title: "Change", style: .default, handler: {[weak self] _ in
                guard let strongSelf = self else {return}
                let cc = alertController.value(forKey: "contentViewController") as! EditPersonRolesPopoverTableViewController
                for i in 1 ... (cc.roleArr.count) {
                    let cell = cc.tableViewPopover.cellForRow(at: IndexPath(row: i-1, section: 0)) as! EditRolePopoverTableCellController
                    if cell.checkbox.on {
                        switch cell.role.text {
                        case "Official Video":
                            strongSelf.currentSong.officialVideo = strongSelf.songVideosArr[indexPath.row].toneDeafAppId
                            if strongSelf.currentSong.lyricVideo == strongSelf.songVideosArr[indexPath.row].toneDeafAppId {
                                strongSelf.currentSong.lyricVideo = nil
                            }
                            if strongSelf.currentSong.audioVideo == strongSelf.songVideosArr[indexPath.row].toneDeafAppId {
                                strongSelf.currentSong.audioVideo = nil
                            }
                        case "Audio Video":
                            strongSelf.currentSong.audioVideo = strongSelf.songVideosArr[indexPath.row].toneDeafAppId
                            if strongSelf.currentSong.lyricVideo == strongSelf.songVideosArr[indexPath.row].toneDeafAppId {
                                strongSelf.currentSong.lyricVideo = nil
                            }
                            if strongSelf.currentSong.officialVideo == strongSelf.songVideosArr[indexPath.row].toneDeafAppId {
                                strongSelf.currentSong.officialVideo = nil
                            }
                        case "Lyric Video":
                            strongSelf.currentSong.lyricVideo = strongSelf.songVideosArr[indexPath.row].toneDeafAppId
                            if strongSelf.currentSong.officialVideo == strongSelf.songVideosArr[indexPath.row].toneDeafAppId {
                                strongSelf.currentSong.officialVideo = nil
                            }
                            if strongSelf.currentSong.audioVideo == strongSelf.songVideosArr[indexPath.row].toneDeafAppId {
                                strongSelf.currentSong.audioVideo = nil
                            }
                        default:
                            if strongSelf.currentSong.officialVideo == strongSelf.songVideosArr[indexPath.row].toneDeafAppId {
                                strongSelf.currentSong.officialVideo = nil
                            }
                            if strongSelf.currentSong.lyricVideo == strongSelf.songVideosArr[indexPath.row].toneDeafAppId {
                                strongSelf.currentSong.lyricVideo = nil
                            }
                            if strongSelf.currentSong.audioVideo == strongSelf.songVideosArr[indexPath.row].toneDeafAppId {
                                strongSelf.currentSong.audioVideo = nil
                            }
                        }
                    }
                }
                DispatchQueue.main.async {[weak self]  in
                    guard let strongSelf = self else {return}
                    strongSelf.songVideosArr.sort(by: {$0.title < $1.title})
                    strongSelf.songVideosTableView.reloadData()
                    if strongSelf.songVideosArr.count < 6 {
                        strongSelf.songVideosHeightConstraint.constant = CGFloat(70*(strongSelf.songVideosArr.count))
                    } else {
                        strongSelf.songVideosHeightConstraint.constant = CGFloat(370)
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
                let video = strongSelf.songVideosArr[indexPath.row].toneDeafAppId
                if strongSelf.currentSong.officialVideo == video {
                    rolesel = "Official Video"
                } else
                if strongSelf.currentSong.audioVideo == video {
                    rolesel = "Audio Video"
                } else
                if strongSelf.currentSong.lyricVideo == video {
                    rolesel = "Lyric Video"
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
            case songArtistsTableView:
                if songArtistsArr.count == 1 {
                    mediumImpactGenerator.impactOccurred()
                    Utilities.showError2("At least 1 artist required.", actionText: "OK")
                }
                else {
                    songArtistsArr.remove(at: indexPath.row)
                    currentSong.songArtist = []
                    for song in songArtistsArr {
                        currentSong.songArtist.append("\(song.toneDeafAppId)")
                        currentSong.songArtist.sort()
                    }
                    tableView.deleteRows(at: [indexPath], with: .fade)
                    if songArtistsArr.count < 6 {
                        songArtistsHeightConstraint.constant = CGFloat(50*(songArtistsArr.count))
                    } else {
                        songArtistsHeightConstraint.constant = CGFloat(270)
                    }
                }
            case songProducersTableView:
                if songProducersArr.count == 1 {
                    mediumImpactGenerator.impactOccurred()
                    Utilities.showError2("At least 1 producer required.", actionText: "OK")
                }
                else {
                    songProducersArr.remove(at: indexPath.row)
                    currentSong.songProducers = []
                    for song in songProducersArr {
                        currentSong.songProducers.append("\(song.toneDeafAppId)")
                        currentSong.songProducers.sort()
                    }
                    tableView.deleteRows(at: [indexPath], with: .fade)
                    if songProducersArr.count < 6 {
                        songProducersHeightConstraint.constant = CGFloat(50*(songProducersArr.count))
                    } else {
                        songProducersHeightConstraint.constant = CGFloat(270)
                    }
                }
            case songWritersTableView:
                    songWritersArr.remove(at: indexPath.row)
                    currentSong.songWriters = []
                    for song in songWritersArr {
                        currentSong.songWriters!.append("\(song.toneDeafAppId)")
                        currentSong.songWriters!.sort()
                    }
                    tableView.deleteRows(at: [indexPath], with: .fade)
                    if songWritersArr.count < 6 {
                        songWritersHeightConstraint.constant = CGFloat(50*(songWritersArr.count))
                    } else {
                        songWritersHeightConstraint.constant = CGFloat(270)
                    }
            case songMixEngineerTableView:
                songMixEngineerArr.remove(at: indexPath.row)
                currentSong.songMixEngineer = []
                for song in songMixEngineerArr {
                    currentSong.songMixEngineer!.append("\(song.toneDeafAppId)")
                    currentSong.songMixEngineer!.sort()
                }
                tableView.deleteRows(at: [indexPath], with: .fade)
                if songMixEngineerArr.count < 6 {
                    songMixEngineerHeightConstraint.constant = CGFloat(50*(songMixEngineerArr.count))
                } else {
                    songMixEngineerHeightConstraint.constant = CGFloat(270)
                }
            case songMasteringEngineerTableView:
                songMasteringEngineerArr.remove(at: indexPath.row)
                currentSong.songMasteringEngineer = []
                for song in songMasteringEngineerArr {
                    currentSong.songMasteringEngineer!.append("\(song.toneDeafAppId)")
                    currentSong.songMasteringEngineer!.sort()
                }
                tableView.deleteRows(at: [indexPath], with: .fade)
                if songMasteringEngineerArr.count < 6 {
                    songMasteringEngineerHeightConstraint.constant = CGFloat(50*(songMasteringEngineerArr.count))
                } else {
                    songMasteringEngineerHeightConstraint.constant = CGFloat(270)
                }
            case songRecordingEngineerTableView:
                songRecordingEngineerArr.remove(at: indexPath.row)
                currentSong.songRecordingEngineer = []
                for song in songRecordingEngineerArr {
                    currentSong.songRecordingEngineer!.append("\(song.toneDeafAppId)")
                    currentSong.songRecordingEngineer!.sort()
                }
                tableView.deleteRows(at: [indexPath], with: .fade)
                if songRecordingEngineerArr.count < 6 {
                    songRecordingEngineerHeightConstraint.constant = CGFloat(50*(songRecordingEngineerArr.count))
                } else {
                    songRecordingEngineerHeightConstraint.constant = CGFloat(270)
                }
            case songAlbumsTableView:
                songAlbumsArr[indexPath.row].tracks.removeValue(forKey: "Track \(albumTrackArr[songAlbumsArr[indexPath.row].toneDeafAppId]!)")
                albumTrackArr.removeValue(forKey: songAlbumsArr[indexPath.row].toneDeafAppId)
                songAlbumsArr.remove(at: indexPath.row)
                currentSong.albums = []
                for song in songAlbumsArr {
                    currentSong.albums!.append("\(song.toneDeafAppId)")
                    currentSong.albums!.sort()
                }
                tableView.deleteRows(at: [indexPath], with: .fade)
                if songAlbumsArr.count < 6 {
                    songAlbumsHeightConstraint.constant = CGFloat(50*(songAlbumsArr.count))
                } else {
                    songAlbumsHeightConstraint.constant = CGFloat(270)
                }
            case songVideosTableView:
                if currentSong.officialVideo == songVideosArr[indexPath.row].toneDeafAppId {
                    currentSong.officialVideo = nil
                }
                if currentSong.audioVideo == songVideosArr[indexPath.row].toneDeafAppId {
                    currentSong.audioVideo = nil
                }
                if currentSong.lyricVideo == songVideosArr[indexPath.row].toneDeafAppId {
                    currentSong.lyricVideo = nil
                }
                songVideosArr.remove(at: indexPath.row)
                currentSong.videos = []
                for song in songVideosArr {
                    currentSong.videos!.append("\(song.toneDeafAppId)")
                    currentSong.videos!.sort()
                }
                tableView.deleteRows(at: [indexPath], with: .fade)
                if songVideosArr.count < 6 {
                    songVideosHeightConstraint.constant = CGFloat(70*(songVideosArr.count))
                } else {
                    songVideosHeightConstraint.constant = CGFloat(370)
                }
            case songInstrumentalsTableView:
                songInstrumentalsArr.remove(at: indexPath.row)
                currentSong.instrumentals = []
                for song in songInstrumentalsArr {
                    currentSong.instrumentals!.append("\(song.toneDeafAppId)")
                    currentSong.instrumentals!.sort()
                }
                tableView.deleteRows(at: [indexPath], with: .fade)
                if songInstrumentalsArr.count < 6 {
                    songInstrumentalsHeightConstraint.constant = CGFloat(50*(songInstrumentalsArr.count))
                } else {
                    songInstrumentalsHeightConstraint.constant = CGFloat(270)
                }
            case songRemixesTableView:
                songRemixesArr.remove(at: indexPath.row)
                currentSong.remixes = []
                for song in songRemixesArr {
                    currentSong.remixes!.append("\(song.toneDeafAppId)")
                    currentSong.remixes!.sort()
                }
                tableView.deleteRows(at: [indexPath], with: .fade)
                if songRemixesArr.count < 6 {
                    songRemixesHeightConstraint.constant = CGFloat(50*(songRemixesArr.count))
                } else {
                    songRemixesHeightConstraint.constant = CGFloat(270)
                }
            case songOtherVersionsTableView:
                songOtherVersionsArr.remove(at: indexPath.row)
                currentSong.otherVersions = []
                for song in songOtherVersionsArr {
                    currentSong.otherVersions!.append("\(song.toneDeafAppId)")
                    currentSong.otherVersions!.sort()
                }
                tableView.deleteRows(at: [indexPath], with: .fade)
                if songOtherVersionsArr.count < 6 {
                    songOtherVersionsHeightConstraint.constant = CGFloat(50*(songOtherVersionsArr.count))
                } else {
                    songOtherVersionsHeightConstraint.constant = CGFloat(270)
                }
            default:
                break
            }
        }
    }
    
    
}

extension EditSongViewController: UITextFieldDelegate {
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        switch textField {
        case remixOfTextField:
            currentSong.isRemix?.standardEdition = nil
            remixOfTextField.endEditing(true)
            return true
        case otherVersionOfTextField:
            currentSong.isOtherVersion?.standardEdition = nil
            otherVersionOfTextField.endEditing(true)
            return true
        default:
            return true
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        switch textField {
        case hiddenSongTextField:
            if currentSong == nil {
//                pickerSelected(row: 0, pickerView: songPickerView)
            }
            else {
                var count = 0
                for per in AllSongsInDatabaseArray {
                    if per.toneDeafAppId == currentSong.toneDeafAppId {
//                        pickerSelected(row: count, pickerView: songPickerView)
                    } else {
                        count+=1
                    }
                }
            }
        default:
            break
        }
    }
}

enum EditSongUpdateError: Error {
    case imageUpdateError(String)
    case nameUpdateError(String)
    case spotifyUpdateError(String)
    case appleUpdateError(String)
    case soundcloudUpdateError(String)
    case youtubeMusicUpdateError(String)
    case amazonUpdateError(String)
    case deezerUpdateError(String)
    case tidalUpdateError(String)
    case napsterUpdateError(String)
    case spinrillaUpdateError(String)
    case albumsUpdateError(String)
    case videosUpdateError(String)
    case instrumentalsUpdateError(String)
}
