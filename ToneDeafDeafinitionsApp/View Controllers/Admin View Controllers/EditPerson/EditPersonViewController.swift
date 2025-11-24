//
//  EditPersonViewController.swift
//  ToneDeafDeafinitionsApp
//
//  Created by Tone Deaf on 6/23/22.
//  Copyright © 2022 GITEM Solutions. All rights reserved.
//

import UIKit
import CloudKit

protocol EditPersonAllPersonsDelegate: class {
    func personSelected(_ person: PersonData)
}

protocol EditPersonSongsDelegate: class {
    func songAdded(_ songAndRoles: [[String]:SongData])
}

protocol EditPersonAlbumsDelegate: class {
    func albumAdded(_ albumAndRoles: [[String]:AlbumData])
}

protocol EditPersonVideosDelegate: class {
    func videoAdded(_ videoAndRoles: [[String]:VideoData])
}

protocol EditPersonInstrumentalsDelegate: class {
    func instrumentalAdded(_ instrumentalAndRoles: [[String]:InstrumentalData])
}

protocol EditPersonBeatsDelegate: class {
    func beatAdded(_ beat: BeatData)
}

class EditPersonViewController: UIViewController, EditPersonSongsDelegate, EditPersonAlbumsDelegate, EditPersonVideosDelegate, EditPersonInstrumentalsDelegate, EditPersonBeatsDelegate, EditPersonAllPersonsDelegate {
    
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
    
    var errorCountForController:Int = 0
    
    static let shared = EditPersonViewController()
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var personAltNamesTableView: UITableView!
    @IBOutlet weak var personAltNamesHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var personSongsTableView: UITableView!
    @IBOutlet weak var personSongsHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var personAlbumsTableView: UITableView!
    @IBOutlet weak var personAlbumsHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var personVideosTableView: UITableView!
    @IBOutlet weak var personVideosHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var personInstrumentalsTableView: UITableView!
    @IBOutlet weak var personInstrumentalsHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var personBeatsTableView: UITableView!
    @IBOutlet weak var personBeatsHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var changePersonButton: UIButton!
    @IBOutlet weak var personImageURL: UILabel!
    @IBOutlet weak var personImage: UIImageView!
    @IBOutlet weak var personName: UILabel!
    @IBOutlet weak var personLegalName: UILabel!
    @IBOutlet weak var personRemoveLegalNameButton: UIButton!
    @IBOutlet weak var appIDLAbel: UILabel!
    @IBOutlet weak var followersLabel: UILabel!
    @IBOutlet weak var dateLabel: CopyableLabel!
    @IBOutlet weak var timeLabel: CopyableLabel!
    @IBOutlet weak var mainRoleLabel: UILabel!
    @IBOutlet weak var linkedToAccountLabel: UILabel!
    @IBOutlet weak var personSpotifyURL: UILabel!
    @IBOutlet weak var personRemoveSpotifyURLButton: UIButton!
    @IBOutlet weak var personAppleMusicURL: UILabel!
    @IBOutlet weak var personRemoveAppleMusicURLButton: UIButton!
    @IBOutlet weak var personYoutubeChannelURL: UILabel!
    @IBOutlet weak var personRemoveYoutubeChannelURLButton: UIButton!
    @IBOutlet weak var personSoundcloudURL: UILabel!
    @IBOutlet weak var personRemoveSoundcloudURLButton: UIButton!
    @IBOutlet weak var personYoutubeMusicURL: UILabel!
    @IBOutlet weak var personRemoveYoutubeMusicURLButton: UIButton!
    @IBOutlet weak var personAmazonURL: UILabel!
    @IBOutlet weak var personRemoveAmazonURLButton: UIButton!
    @IBOutlet weak var personDeezerURL: UILabel!
    @IBOutlet weak var personRemoveDeezerURLButton: UIButton!
    @IBOutlet weak var personTidalURL: UILabel!
    @IBOutlet weak var personRemoveTidalURLButton: UIButton!
    @IBOutlet weak var personNapsterURL: UILabel!
    @IBOutlet weak var personRemoveNapsterURLButton: UIButton!
    @IBOutlet weak var personSpinrillaURL: UILabel!
    @IBOutlet weak var personRemoveSpinrillaURLButton: UIButton!
    @IBOutlet weak var personInstagramURL: UILabel!
    @IBOutlet weak var personRemoveInstagramURLButton: UIButton!
    @IBOutlet weak var personTwitterURL: UILabel!
    @IBOutlet weak var personRemoveTwitterURLButton: UIButton!
    @IBOutlet weak var personFacebookURL: UILabel!
    @IBOutlet weak var personRemoveFacebookURLButton: UIButton!
    @IBOutlet weak var personTikTokURL: UILabel!
    @IBOutlet weak var personRemoveTikTokURLButton: UIButton!
    @IBOutlet weak var spotifyStatusControl: UISegmentedControl!
    @IBOutlet weak var appleMusicStatusControl: UISegmentedControl!
    @IBOutlet weak var youtubeStatusControl: UISegmentedControl!
    @IBOutlet weak var soundcloudStatusControl: UISegmentedControl!
    @IBOutlet weak var youtubeMusicStatusControl: UISegmentedControl!
    @IBOutlet weak var amazonStatusControl: UISegmentedControl!
    @IBOutlet weak var deezerStatusControl: UISegmentedControl!
    @IBOutlet weak var tidalStatusControl: UISegmentedControl!
    @IBOutlet weak var napsterStatusControl: UISegmentedControl!
    @IBOutlet weak var spinrillaStatusControl: UISegmentedControl!
    @IBOutlet weak var instagramStatusControl: UISegmentedControl!
    @IBOutlet weak var twitterStatusControl: UISegmentedControl!
    @IBOutlet weak var facebookStatusControl: UISegmentedControl!
    @IBOutlet weak var tiktokStatusControl: UISegmentedControl!
    @IBOutlet weak var verificationLabel: UILabel!
    @IBOutlet weak var industryCertifiedControl: UISegmentedControl!
    @IBOutlet weak var personStatusControl: UISegmentedControl!
    @IBOutlet weak var personUpdateButton: UIButton!
    
    var newImage:UIImage!
    var currentFileType = ""
    var arr = ""
    var prevPage = ""
    
    var personSongsArr:[SongData] = []
    var personAlbumsArr:[AlbumData] = []
    var personVideosArr:[VideoData] = []
    var personInstrumentalsArr:[InstrumentalData] = []
    var personBeatsArr:[BeatData] = []
    
    var albumMainArtistArr:[String] = []
    var albumFeaturedArtistArr:[String] = []
    var initalbumMainArtistArr:[String] = []
    var initalbumFeaturedArtistArr:[String] = []
    
    var videoPersonArr:[String] = []
    var initvideoPersonArr:[String] = []
    
    var personPickerView = UIPickerView()
    var mainRolePickerView = UIPickerView()
    var pickerrole = ""
    
    var boolDict:[String:Bool?] = [
        "spotify":nil,
        "apple":nil,
        "youtube":nil,
        "soundcloud":nil,
        "youtubemusic":nil,
        "amazon":nil,
        "deezer":nil,
        "tidal":nil,
        "napster":nil,
        "spinrilla":nil,
        "instagram":nil,
        "twitter":nil,
        "facebook":nil,
        "tiktok":nil
    ]
    var urlDict:[String:String?] = [
        "spotify":nil,
        "apple":nil,
        "youtube":nil,
        "soundcloud":nil,
        "youtubemusic":nil,
        "amazon":nil,
        "deezer":nil,
        "tidal":nil,
        "napster":nil,
        "spinrilla":nil,
        "instagram":nil,
        "twitter":nil,
        "facebook":nil,
        "tiktok":nil
    ]
    
    var rolesDict:[String:Any?]!
    
    let hiddenPersonTextField =  UITextField(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    let hiddenMainRoleTextField =  UITextField(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    
    var currentPerson:PersonData!
    var initialPerson = PersonData(name: "", legalName: nil, toneDeafAppId: "", mainRole: "", roles: nil, songs: nil, videos: nil, beats: nil, instrumentals: nil, albums: nil, merch: nil, alternateNames: nil, dateRegisteredToApp: "", timeRegisteredToApp: "", linkedToAccount: "", spotify: nil, apple: nil, soundcloud: nil, youtubeMusic: nil, amazon: nil, deezer: nil, spinrilla: nil, napster: nil, tidal: nil, youtube: nil, instagram: nil, twitter: nil, facebook: nil, tikTok: nil, manualImageURL: nil,followers: 0, industryCerified: false, verificationLevel: nil, isActive: nil)
    
    var progressView:UIProgressView!
    var totalProgress:Float = 0
    var progressCompleted:Float = 0
    var alertView:UIAlertController!
    
    var initialLoad:Bool = true

    override func viewDidLoad() {
        super.viewDidLoad()
        
//                strongSelf.arr = "person"
//                strongSelf.prevPage = "editPersonAll"
//                strongSelf.performSegue(withIdentifier: "editPersonToTonesPick", sender: nil)
        
        setUpElements()
        personSelected(currentPerson)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
    }
    
    override func viewWillLayoutSubviews() {
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
    }
    
    deinit {
        print("📗 Edit Person view controller deinitialized.")
        AllPersonsInDatabaseArray = nil
        AllVideosInDatabaseArray = nil
        AllSongsInDatabaseArray = nil
        AllAlbumsInDatabaseArray = nil
        AllInstrumentalsInDatabaseArray = nil
        AllBeatsInDatabaseArray = nil
        currentPerson = nil
        newImage = nil
        NotificationCenter.default.removeObserver(self)
    }
    func personSelected(_ person: PersonData) {
        boolDict = [
            "spotify":nil,
            "apple":nil,
            "youtube":nil,
            "soundcloud":nil,
            "youtubemusic":nil,
            "amazon":nil,
            "deezer":nil,
            "tidal":nil,
            "napster":nil,
            "spinrilla":nil,
            "instagram":nil,
            "twitter":nil,
            "facebook":nil,
            "tiktok":nil
        ]
        urlDict = [
            "spotify":nil,
            "apple":nil,
            "youtube":nil,
            "soundcloud":nil,
            "youtubemusic":nil,
            "amazon":nil,
            "deezer":nil,
            "tidal":nil,
            "napster":nil,
            "spinrilla":nil,
            "instagram":nil,
            "twitter":nil,
            "facebook":nil,
            "tiktok":nil
        ]
        rolesDict = [
            "Videographer": nil,
            "Artist": nil,
            "Producer": nil,
            "Writer": nil,
            "Engineer": [
                "Mix Engineer": nil,
                "Mastering Engineer": nil,
                "Recording Engineer": nil
            ]
        ]
            rolesDict = [:]
            let a = person
            currentPerson = person
            let b = a
            let newnew = currentPerson.copy() as! PersonData
            initialPerson = newnew
//            initialPerson.name = b.name
//            initialPerson.legalName = b.legalName
//            initialPerson.alternateNames = b.alternateNames
//            initialPerson.mainRole = b.mainRole
//            initialPerson.toneDeafAppId = b.toneDeafAppId
            initialPerson.roles = b.roles
            
            if let ro = b.roles {
                rolesDict["Videographer"] = (ro["Videographer"] as? [String])?.sorted()
                rolesDict["Artist"] = (ro["Artist"] as? [String])?.sorted()
                rolesDict["Producer"] = (ro["Producer"] as? [String])?.sorted()
                rolesDict["Writer"] = (ro["Writer"] as? [String])?.sorted()
                if let eng = ro["Engineer"] as? NSMutableDictionary {
                    rolesDict["Engineer"] = [:]
                    var dicteng:[String:Any?] = rolesDict["Engineer"] as! [String : Any?]
                    dicteng["Mix Engineer"] = (eng["Mix Engineer"] as? [String])?.sorted()
                    dicteng["Mastering Engineer"] = (eng["Mastering Engineer"] as? [String])?.sorted()
                    dicteng["Recording Engineer"] = (eng["Recording Engineer"] as? [String])?.sorted()
                    rolesDict["Engineer"] = dicteng
                    
                }
            }
        if let currole = currentPerson.roles as? NSDictionary {
                var rolesDic = currole.mutableCopy() as! NSMutableDictionary
                if let arr = rolesDic["Videographer"] as? [String] {
                    rolesDic["Videographer"] = arr.sorted()
                }
                if let arr = rolesDic["Artist"] as? [String] {
                    rolesDic["Artist"] = arr.sorted()
                }
                if let arr = rolesDic["Producer"] as? [String] {
                    rolesDic["Producer"] = arr.sorted()
                }
                if let arr = rolesDic["Writer"] as? [String] {
                    rolesDic["Writer"] = arr.sorted()
                }
                if let eng = rolesDic["Engineer"] as? NSDictionary {
                    var dicteng = eng.mutableCopy() as! NSMutableDictionary
                    if let arr = dicteng["Mix Engineer"] as? [String] {
                        dicteng["Mix Engineer"] = arr.sorted()
                    }
                    if let arr = dicteng["Mastering Engineer"] as? [String] {
                        dicteng["Mastering Engineer"] = arr.sorted()
                    }
                    if let arr = dicteng["Recording Engineer"] as? [String] {
                        dicteng["Recording Engineer"] = arr.sorted()
                    }
                    rolesDic["Engineer"] = dicteng
                    
                }
                currentPerson.roles = rolesDic
            initialPerson.roles = rolesDic
            }
            
//            initialPerson.songs = b.songs
//            initialPerson.albums = b.albums
//            initialPerson.videos = b.videos
//            initialPerson.instrumentals = b.instrumentals
//            initialPerson.beats = b.beats
//            initialPerson.merch = b.merch
//            initialPerson.dateRegisteredToApp = b.dateRegisteredToApp
//            initialPerson.timeRegisteredToApp = b.timeRegisteredToApp
//            initialPerson.linkedToAccount = b.linkedToAccount
            initialPerson.spotify = b.spotify
            boolDict["spotify"] = b.spotify?.isActive
            urlDict["spotify"] = b.spotify?.url
            initialPerson.apple = b.apple
            boolDict["apple"] = b.apple?.isActive
            urlDict["apple"] = b.apple?.url
            initialPerson.soundcloud = b.soundcloud
            boolDict["soundcloud"] = b.soundcloud?.isActive
            urlDict["soundcloud"] = b.soundcloud?.url
            initialPerson.youtube = b.youtube
            boolDict["youtube"] = b.youtube?.isActive
            urlDict["youtube"] = b.youtube?.url
            initialPerson.youtubeMusic = b.youtubeMusic
            boolDict["youtubemusic"] = b.youtubeMusic?.isActive
            urlDict["youtubemusic"] = b.youtubeMusic?.url
            initialPerson.amazon = b.amazon
            boolDict["amazon"] = b.amazon?.isActive
            urlDict["amazon"] = b.amazon?.url
            initialPerson.deezer = b.deezer
            boolDict["deezer"] = b.deezer?.isActive
            urlDict["deezer"] = b.deezer?.url
            initialPerson.spinrilla = b.spinrilla
            boolDict["spinrilla"] = b.spinrilla?.isActive
            urlDict["spinrilla"] = b.spinrilla?.url
            initialPerson.napster = b.napster
            boolDict["napster"] = b.napster?.isActive
            urlDict["napster"] = b.napster?.url
            initialPerson.tidal = b.tidal
            boolDict["tidal"] = b.tidal?.isActive
            urlDict["tidal"] = b.tidal?.url
            initialPerson.instagram = b.instagram
            boolDict["instagram"] = b.instagram?.isActive
            urlDict["instagram"] = b.instagram?.url
            initialPerson.twitter = b.twitter
            boolDict["twitter"] = b.twitter?.isActive
            urlDict["twitter"] = b.twitter?.url
            initialPerson.facebook = b.facebook
            boolDict["facebook"] = b.facebook?.isActive
            urlDict["facebook"] = b.facebook?.url
            initialPerson.tikTok = b.tikTok
            boolDict["tiktok"] = b.tikTok?.isActive
            urlDict["tiktok"] = b.tikTok?.url
//            initialPerson.manualImageURL = banualImageURL
            //            initialPerson.followers = b.followers
            //            initialPerson.isActive = b.isActive
        dismissKeyboard2()
    }
    
    func setUpElements() {
        view.addSubview(hiddenPersonTextField)
        hiddenPersonTextField.isHidden = true
        hiddenPersonTextField.inputView = personPickerView
        personPickerView.delegate = self
        personPickerView.dataSource = self
        pickerViewToolbar(textField: hiddenPersonTextField, pickerView: personPickerView)
        
        hiddenPersonTextField.delegate = self
//
//        changePersonButton.setTitle("Change Person", for: .normal)
//        changePersonButton.tintColor = Constants.Colors.redApp
        
    }
    
    func setUpPage() {
        errorCountForController = 0
        personSongsArr = []
        personAlbumsArr = []
        personVideosArr = []
        personInstrumentalsArr = []
        personBeatsArr = []
        newImage = nil
        view.addSubview(hiddenMainRoleTextField)
        changePersonButton.setTitleColor(Constants.Colors.redApp, for: .normal)
        hiddenMainRoleTextField.isHidden = true
        hiddenMainRoleTextField.inputView = mainRolePickerView
        hiddenMainRoleTextField.delegate = self
        dateLabel.text = currentPerson.dateRegisteredToApp
        timeLabel.text = currentPerson.timeRegisteredToApp
        mainRolePickerView.delegate = self
        mainRolePickerView.dataSource = self
        pickerViewToolbar(textField: hiddenMainRoleTextField, pickerView: mainRolePickerView)
        personAltNamesTableView.delegate = self
        personAltNamesTableView.dataSource = self
        if let pan = currentPerson.alternateNames {
            personAltNamesTableView.reloadData()
            personAltNamesHeightConstraint.constant = CGFloat(50*(pan.count))
        } else {
            personAltNamesHeightConstraint.constant = 0
        }
        personSongsTableView.delegate = self
        personSongsTableView.dataSource = self
        
        if let psa = currentPerson.songs {
            setSongsArr(arr: psa, completion: {[weak self] _ in
                guard let strongSelf = self else {return}
                strongSelf.personSongsArr.sort(by: {$0.name < $1.name})
                strongSelf.personSongsTableView.reloadData()
                if strongSelf.personSongsArr.count < 6 {
                    strongSelf.personSongsHeightConstraint.constant = CGFloat(50*(strongSelf.personSongsArr.count))
                } else {
                    strongSelf.personSongsHeightConstraint.constant = CGFloat(270)
                }
            })
        } else {
            personSongsHeightConstraint.constant = 0
        }
        personAlbumsTableView.delegate = self
        personAlbumsTableView.dataSource = self
        if let psa = currentPerson.albums {
            setAlbumsArr(arr: psa, completion: {[weak self] _ in
                guard let strongSelf = self else {return}
                strongSelf.personAlbumsArr.sort(by: {$0.name < $1.name})
                strongSelf.personAlbumsTableView.reloadData()
                if strongSelf.personAlbumsArr.count < 6 {
                    strongSelf.personAlbumsHeightConstraint.constant = CGFloat(50*(strongSelf.personAlbumsArr.count))
                } else {
                    strongSelf.personAlbumsHeightConstraint.constant = CGFloat(270)
                }
            })
        } else {
            personAlbumsHeightConstraint.constant = 0
        }
        personVideosTableView.delegate = self
        personVideosTableView.dataSource = self
        if let psa = currentPerson.videos {
            setVideosArr(arr: psa, completion: {[weak self] _ in
                guard let strongSelf = self else {return}
                strongSelf.personVideosArr.sort(by: {$0.title < $1.title})
                strongSelf.personVideosTableView.reloadData()
                if strongSelf.personVideosArr.count < 6 {
                    strongSelf.personVideosHeightConstraint.constant = CGFloat(70*(strongSelf.personVideosArr.count))
                } else {
                    strongSelf.personVideosHeightConstraint.constant = CGFloat(370)
                }
            })
        } else {
            personVideosHeightConstraint.constant = 0
        }
        personInstrumentalsTableView.delegate = self
        personInstrumentalsTableView.dataSource = self
        if let psa = currentPerson.instrumentals {
            setInstrumentalsArr(arr: psa, completion: {[weak self] _ in
                guard let strongSelf = self else {return}
                strongSelf.personInstrumentalsArr.sort(by: {$0.songName! < $1.songName!})
                strongSelf.personInstrumentalsTableView.reloadData()
                if strongSelf.personInstrumentalsArr.count < 6 {
                    strongSelf.personInstrumentalsHeightConstraint.constant = CGFloat(50*(strongSelf.personInstrumentalsArr.count))
                } else {
                    strongSelf.personInstrumentalsHeightConstraint.constant = CGFloat(270)
                }
            })
        } else {
            personInstrumentalsHeightConstraint.constant = 0
        }
        personBeatsTableView.delegate = self
        personBeatsTableView.dataSource = self
        if let psa = currentPerson.beats {
            setBeatsArr(arr: psa, completion: {[weak self] _ in
                guard let strongSelf = self else {return}
                strongSelf.personBeatsArr.sort(by: {$0.name < $1.name})
                strongSelf.personBeatsTableView.reloadData()
                if strongSelf.personBeatsArr.count < 6 {
                    strongSelf.personBeatsHeightConstraint.constant = CGFloat(50*(strongSelf.personBeatsArr.count))
                } else {
                    strongSelf.personBeatsHeightConstraint.constant = CGFloat(270)
                }
            })
        } else {
            personBeatsHeightConstraint.constant = 0
        }
        appIDLAbel.text = currentPerson.toneDeafAppId
        followersLabel.text = String(currentPerson.followers!)
        linkedToAccountLabel.text = currentPerson.linkedToAccount
        personLegalName.text = currentPerson.legalName
        mainRoleLabel.text = currentPerson.mainRole
        if currentPerson.legalName == nil {
            personRemoveLegalNameButton.isHidden = true
        } else {
            personRemoveLegalNameButton.isHidden = false
        }
        personSpotifyURL.text = currentPerson.spotify?.url
        if currentPerson.spotify?.url == nil || currentPerson.spotify?.url == "" {
            personRemoveSpotifyURLButton.isHidden = true
            spotifyStatusControl.isHidden = true
        } else {
            spotifyStatusControl.isHidden = false
            personRemoveSpotifyURLButton.isHidden = false
        }
        personAppleMusicURL.text = currentPerson.apple?.url
        if currentPerson.apple?.url == nil || currentPerson.apple?.url == "" {
            personRemoveAppleMusicURLButton.isHidden = true
            appleMusicStatusControl.isHidden = true
        } else {
            appleMusicStatusControl.isHidden = false
            personRemoveAppleMusicURLButton.isHidden = false
        }
        personYoutubeChannelURL.text = currentPerson.youtube?.url
        if currentPerson.youtube?.url == nil || currentPerson.youtube?.url == "" {
            personRemoveYoutubeChannelURLButton.isHidden = true
            youtubeStatusControl.isHidden = true
        } else {
            youtubeStatusControl.isHidden = false
            personRemoveYoutubeChannelURLButton.isHidden = false
        }
        personSoundcloudURL.text = currentPerson.soundcloud?.url
        if currentPerson.soundcloud?.url == nil || currentPerson.soundcloud?.url == "" {
            personRemoveSoundcloudURLButton.isHidden = true
            soundcloudStatusControl.isHidden = true
        } else {
            soundcloudStatusControl.isHidden = false
            personRemoveSoundcloudURLButton.isHidden = false
        }
        personYoutubeMusicURL.text = currentPerson.youtubeMusic?.url
        if currentPerson.youtubeMusic?.url == nil || currentPerson.youtubeMusic?.url == "" {
            personRemoveYoutubeMusicURLButton.isHidden = true
            youtubeMusicStatusControl.isHidden = true
        } else {
            youtubeMusicStatusControl.isHidden = false
            personRemoveYoutubeMusicURLButton.isHidden = false
        }
        personAmazonURL.text = currentPerson.amazon?.url
        if currentPerson.amazon?.url == nil || currentPerson.amazon?.url == "" {
            personRemoveAmazonURLButton.isHidden = true
            amazonStatusControl.isHidden = true
        } else {
            amazonStatusControl.isHidden = false
            personRemoveAmazonURLButton.isHidden = false
        }
        personDeezerURL.text = currentPerson.deezer?.url
        if currentPerson.deezer?.url == nil || currentPerson.deezer?.url == "" {
            personRemoveDeezerURLButton.isHidden = true
            deezerStatusControl.isHidden = true
        } else {
            deezerStatusControl.isHidden = false
            personRemoveDeezerURLButton.isHidden = false
        }
        personTidalURL.text = currentPerson.tidal?.url
        if currentPerson.tidal?.url == nil || currentPerson.tidal?.url == "" {
            personRemoveTidalURLButton.isHidden = true
            tidalStatusControl.isHidden = true
        } else {
            tidalStatusControl.isHidden = false
            personRemoveTidalURLButton.isHidden = false
        }
        personNapsterURL.text = currentPerson.napster?.url
        if currentPerson.napster?.url == nil || currentPerson.napster?.url == "" {
            personRemoveNapsterURLButton.isHidden = true
            napsterStatusControl.isHidden = true
        } else {
            napsterStatusControl.isHidden = false
            personRemoveNapsterURLButton.isHidden = false
        }
        personSpinrillaURL.text = currentPerson.spinrilla?.url
        if currentPerson.spinrilla?.url == nil || currentPerson.spinrilla?.url == "" {
            personRemoveSpinrillaURLButton.isHidden = true
            spinrillaStatusControl.isHidden = true
        } else {
            spinrillaStatusControl.isHidden = false
            personRemoveSpinrillaURLButton.isHidden = false
        }
        personInstagramURL.text = currentPerson.instagram?.url
        if currentPerson.instagram?.url == nil || currentPerson.instagram?.url == "" {
            personRemoveInstagramURLButton.isHidden = true
            instagramStatusControl.isHidden = true
        } else {
            instagramStatusControl.isHidden = false
            personRemoveInstagramURLButton.isHidden = false
        }
        personTwitterURL.text = currentPerson.twitter?.url
        if currentPerson.twitter?.url == nil || currentPerson.twitter?.url == "" {
            personRemoveTwitterURLButton.isHidden = true
            twitterStatusControl.isHidden = true
        } else {
            twitterStatusControl.isHidden = false
            personRemoveTwitterURLButton.isHidden = false
        }
        personFacebookURL.text = currentPerson.facebook?.url
        if currentPerson.facebook?.url == nil || currentPerson.facebook?.url == "" {
            personRemoveFacebookURLButton.isHidden = true
            facebookStatusControl.isHidden = true
        } else {
            facebookStatusControl.isHidden = false
            personRemoveFacebookURLButton.isHidden = false
        }
        personTikTokURL.text = currentPerson.tikTok?.url
        if currentPerson.tikTok?.url == nil || currentPerson.tikTok?.url == "" {
            personRemoveTikTokURLButton.isHidden = true
            tiktokStatusControl.isHidden = true
        } else {
            tiktokStatusControl.isHidden = false
            personRemoveTikTokURLButton.isHidden = false
        }
        
        if let seggo = currentPerson.spotify?.isActive {
            if seggo {
                spotifyStatusControl.selectedSegmentIndex = 0
                spotifyStatusControl.selectedSegmentTintColor = .systemGreen
            } else {
                spotifyStatusControl.selectedSegmentTintColor = Constants.Colors.redApp
                spotifyStatusControl.selectedSegmentIndex = 1
            }
        }
        if let seggo = currentPerson.apple?.isActive {
            if seggo {
                appleMusicStatusControl.selectedSegmentIndex = 0
                appleMusicStatusControl.selectedSegmentTintColor = .systemGreen
            } else {
                appleMusicStatusControl.selectedSegmentTintColor = Constants.Colors.redApp
                appleMusicStatusControl.selectedSegmentIndex = 1
            }
        }
        if let seggo = currentPerson.youtube?.isActive {
            if seggo {
                youtubeStatusControl.selectedSegmentIndex = 0
                youtubeStatusControl.selectedSegmentTintColor = .systemGreen
            } else {
                youtubeStatusControl.selectedSegmentTintColor = Constants.Colors.redApp
                youtubeStatusControl.selectedSegmentIndex = 1
            }
        }
        if let seggo = currentPerson.soundcloud?.isActive {
            if seggo {
                soundcloudStatusControl.selectedSegmentIndex = 0
                soundcloudStatusControl.selectedSegmentTintColor = .systemGreen
            } else {
                soundcloudStatusControl.selectedSegmentTintColor = Constants.Colors.redApp
                soundcloudStatusControl.selectedSegmentIndex = 1
            }
        }
        if let seggo = currentPerson.youtubeMusic?.isActive {
            if seggo {
                youtubeMusicStatusControl.selectedSegmentIndex = 0
                youtubeMusicStatusControl.selectedSegmentTintColor = .systemGreen
            } else {
                youtubeMusicStatusControl.selectedSegmentTintColor = Constants.Colors.redApp
                youtubeMusicStatusControl.selectedSegmentIndex = 1
            }
        }
        if let seggo = currentPerson.amazon?.isActive {
            if seggo {
                amazonStatusControl.selectedSegmentIndex = 0
                amazonStatusControl.selectedSegmentTintColor = .systemGreen
            } else {
                amazonStatusControl.selectedSegmentTintColor = Constants.Colors.redApp
                amazonStatusControl.selectedSegmentIndex = 1
            }
        }
        if let seggo = currentPerson.deezer?.isActive {
            if seggo {
                deezerStatusControl.selectedSegmentIndex = 0
                deezerStatusControl.selectedSegmentTintColor = .systemGreen
            } else {
                deezerStatusControl.selectedSegmentTintColor = Constants.Colors.redApp
                deezerStatusControl.selectedSegmentIndex = 1
            }
        }
        if let seggo = currentPerson.tidal?.isActive {
            if seggo {
                tidalStatusControl.selectedSegmentIndex = 0
                tidalStatusControl.selectedSegmentTintColor = .systemGreen
            } else {
                tidalStatusControl.selectedSegmentTintColor = Constants.Colors.redApp
                tidalStatusControl.selectedSegmentIndex = 1
            }
        }
        if let seggo = currentPerson.napster?.isActive {
            if seggo {
                napsterStatusControl.selectedSegmentIndex = 0
                napsterStatusControl.selectedSegmentTintColor = .systemGreen
            } else {
                napsterStatusControl.selectedSegmentTintColor = Constants.Colors.redApp
                napsterStatusControl.selectedSegmentIndex = 1
            }
        }
        if let seggo = currentPerson.spinrilla?.isActive {
            if seggo {
                spinrillaStatusControl.selectedSegmentIndex = 0
                spinrillaStatusControl.selectedSegmentTintColor = .systemGreen
            } else {
                spinrillaStatusControl.selectedSegmentTintColor = Constants.Colors.redApp
                spinrillaStatusControl.selectedSegmentIndex = 1
            }
        }
        if let seggo = currentPerson.instagram?.isActive {
            if seggo {
                instagramStatusControl.selectedSegmentIndex = 0
                instagramStatusControl.selectedSegmentTintColor = .systemGreen
            } else {
                instagramStatusControl.selectedSegmentTintColor = Constants.Colors.redApp
                instagramStatusControl.selectedSegmentIndex = 1
            }
        }
        if let seggo = currentPerson.twitter?.isActive {
            if seggo {
                twitterStatusControl.selectedSegmentIndex = 0
                twitterStatusControl.selectedSegmentTintColor = .systemGreen
            } else {
                twitterStatusControl.selectedSegmentTintColor = Constants.Colors.redApp
                twitterStatusControl.selectedSegmentIndex = 1
            }
        }
        if let seggo = currentPerson.facebook?.isActive {
            if seggo {
                facebookStatusControl.selectedSegmentIndex = 0
                facebookStatusControl.selectedSegmentTintColor = .systemGreen
            } else {
                facebookStatusControl.selectedSegmentTintColor = Constants.Colors.redApp
                facebookStatusControl.selectedSegmentIndex = 1
            }
        }
        if let seggo = currentPerson.tikTok?.isActive {
            if seggo {
                tiktokStatusControl.selectedSegmentIndex = 0
                tiktokStatusControl.selectedSegmentTintColor = .systemGreen
            } else {
                tiktokStatusControl.selectedSegmentTintColor = Constants.Colors.redApp
                tiktokStatusControl.selectedSegmentIndex = 1
            } 
        }
        
        if currentPerson.industryCerified! {
            industryCertifiedControl.selectedSegmentIndex = 0
            industryCertifiedControl.selectedSegmentTintColor = .systemGreen
        } else {
            industryCertifiedControl.selectedSegmentTintColor = Constants.Colors.redApp
            industryCertifiedControl.selectedSegmentIndex = 1
        }
        if currentPerson.isActive! {
            personStatusControl.selectedSegmentIndex = 0
            personStatusControl.selectedSegmentTintColor = .systemGreen
        } else {
            personStatusControl.selectedSegmentTintColor = Constants.Colors.redApp
            personStatusControl.selectedSegmentIndex = 1
        }
        
        personName.text = currentPerson.name
        verificationLabel.text = String(currentPerson.verificationLevel!)
        pickerViewToolbar(textField: hiddenPersonTextField, pickerView: personPickerView)
        GlobalFunctions.shared.selectImageURL(person: currentPerson, completion: {[weak self] aimage in
            guard let strongSelf = self else {return}
            guard let imge = aimage else {
                strongSelf.personImage.image = UIImage(named: "tonedeaflogo")
                strongSelf.personImageURL.text = "No Image"
                strongSelf.personImageURL.alpha = 0.5
                return
            }
            strongSelf.personImageURL.alpha = 1
            strongSelf.personImageURL.text = imge
            let imageURL = URL(string: imge)!
            if let cachedImage = imageCache.object(forKey: imageURL.absoluteString as NSString) {
                strongSelf.personImage.image = cachedImage
            } else {
                strongSelf.personImage.setImage(from: imageURL, withPlaceholder: UIImage(named: "tonedeaflogo"))
            }
            
        })
        scrollToTop()
    }
    
    func setSongsArr(arr: [String], completion: @escaping ((Error?) -> Void)) {
            personSongsArr = []
            if arr != [""] {
                
                for song in arr {
                    getSong(songIdFull: song, completion: {[weak self] songData in
                        guard let strongSelf = self else {return}
                        strongSelf.personSongsArr.append(songData)
                        
                        completion(nil)
                    })
                }
            } else {
                personSongsHeightConstraint.constant = CGFloat(50*(personSongsArr.count))
            }
    }
    
    func setAlbumsArr(arr: [String], completion: @escaping ((Error?) -> Void)) {
            personAlbumsArr = []
            if arr != [""] {
                var count = 0
                for song in arr {
                    getAlbum(albumIdFull: song, completion: {[weak self] songData in
                        guard let strongSelf = self else {return}
                        if strongSelf.initialLoad == true {
                            if songData.mainArtist.contains(strongSelf.currentPerson.toneDeafAppId) {
                                strongSelf.initalbumMainArtistArr.append(songData.toneDeafAppId)
                                strongSelf.albumMainArtistArr.append(songData.toneDeafAppId)
                            }
                            if let arr2 = songData.allArtists {
                                if arr2.contains(strongSelf.currentPerson.toneDeafAppId) {
                                    strongSelf.initalbumFeaturedArtistArr.append(songData.toneDeafAppId)
                                    strongSelf.albumFeaturedArtistArr.append(songData.toneDeafAppId)
                                }
                            }
                        }
                        strongSelf.personAlbumsArr.append(songData)
                        count+=1
                        if count == arr.count {
                            strongSelf.initialLoad == false
                            completion(nil)
                        }
                    })
                }
            } else {
                personAlbumsHeightConstraint.constant = CGFloat(50*(personAlbumsArr.count))
            }
    }
    
    func setVideosArr(arr: [String], completion: @escaping ((Error?) -> Void)) {
            personVideosArr = []
            if arr != [""] {
                var count = 0
                for video in arr {
                    getVideo(videoIdFull: video, completion: {[weak self] videoData in
                        guard let strongSelf = self else {return}
                        if strongSelf.initialLoad == true {
                            if let persons = videoData.persons as? [String] {
                                if persons.contains(strongSelf.currentPerson.toneDeafAppId) {
                                    strongSelf.initvideoPersonArr.append(videoData.toneDeafAppId)
                                    strongSelf.videoPersonArr.append(videoData.toneDeafAppId)
                                    strongSelf.videoPersonArr.sort()
                                    strongSelf.initvideoPersonArr.sort()
                                }
                            }
                        }
                        strongSelf.personVideosArr.append(videoData)
                        count+=1
                        if count == arr.count {
                            strongSelf.initialLoad == false
                            completion(nil)
                        }
                    })
                }
            } else {
                personVideosHeightConstraint.constant = CGFloat(70*(personVideosArr.count))
            }
    }
    
    func setInstrumentalsArr(arr: [String], completion: @escaping ((Error?) -> Void)) {
            personInstrumentalsArr = []
            if arr != [""] {
                for instrumental in arr {
                    getInstrumental(instrumentalIdFull: instrumental, completion: {[weak self] instrumentalData in
                        guard let strongSelf = self else {return}
                        strongSelf.personInstrumentalsArr.append(instrumentalData)
                        completion(nil)
                    })
                }
            } else {
                personInstrumentalsHeightConstraint.constant = CGFloat(50*(personInstrumentalsArr.count))
            }
    }
    
    func setBeatsArr(arr: [String], completion: @escaping ((Error?) -> Void)) {
            personBeatsArr = []
            if arr != [""] {
                for beat in arr {
                    getBeat(beatIdFull: beat, completion: {[weak self] beatData in
                        guard let strongSelf = self else {return}
                        strongSelf.personBeatsArr.append(beatData)
                        completion(nil)
                    })
                }
            } else {
                personBeatsHeightConstraint.constant = CGFloat(50*(personBeatsArr.count))
            }
    }
    
    @IBAction func newPersonTapped(_ sender: Any) {
        
        if !AllPersonsInDatabaseArray.isEmpty {
            arr = "person"
            prevPage = "editPersonAll"
            performSegue(withIdentifier: "editPersonToTonesPick", sender: nil)
        } else {
            let alertC = UIAlertController(title: "No Persons In Database",
                                           message: "Go to Person Upload to add a person",
                                           preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Ok", style: .default, handler: {_ in
                alertC.dismiss(animated: true, completion: nil)
            })
            alertC.addAction(okAction)
            alertC.view.tintColor = Constants.Colors.redApp
            self.present(alertC, animated: true)
        }
    }
    
    @IBAction func changeImageTapped(_ sender: Any) {
        let actionSheet = UIAlertController(title: "Change Image",
                                            message: "",
                                            preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Select Image Manually",
                                            style: .default,
                                            handler: { [weak self] _ in
            guard let strongSelf = self else {return}
            strongSelf.presentPhotoActionSheet()
        }))
        actionSheet.addAction(UIAlertAction(title: "Use Person Default",
                                            style: .default,
                                            handler: { [weak self] _ in
            guard let strongSelf = self else {return}
            strongSelf.currentPerson.manualImageURL = nil
            strongSelf.newImage = nil
            strongSelf.personImageURL.textColor = .green
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
                strongSelf.personName.text = name
                strongSelf.personName.textColor = .green
                strongSelf.currentPerson.name = name
                alertC.dismiss(animated: true, completion: nil)
            } else {
                alertC.dismiss(animated: true, completion: nil)
            }
        })
        alertC.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alertC.addAction(okAction)
        alertC.addTextField()
        alertC.textFields![0].text = currentPerson.name
        alertC.view.tintColor = Constants.Colors.redApp
        self.present(alertC, animated: true)
    }
    
    @IBAction func changeLegalNameTapped(_ sender: Any) {
        let alertC = UIAlertController(title: "Change Legal Name",
                                                message: "Please type in a name.",
                                                preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Change", style: .default, handler: {[weak self] _ in
            guard let strongSelf = self else {return}
            let field = alertC.textFields![0]
            if field.text != "" {
                guard let name = field.text else {return}
                strongSelf.personLegalName.text = name
                strongSelf.personLegalName.textColor = .green
                strongSelf.currentPerson.legalName = name
                strongSelf.personRemoveLegalNameButton.isHidden = false
                strongSelf.personBeatsArr.sort(by: {$0.name < $1.name})
                strongSelf.personBeatsTableView.reloadData()
                alertC.dismiss(animated: true, completion: nil)
            } else {
                alertC.dismiss(animated: true, completion: nil)
            }
        })
        alertC.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alertC.addAction(okAction)
        alertC.addTextField()
        let field = alertC.textFields![0]
        field.text = currentPerson.legalName
        alertC.view.tintColor = Constants.Colors.redApp
        self.present(alertC, animated: true)
    }
    
    @IBAction func removeLegalNameTapped(_ sender: Any) {
        let alertC = UIAlertController(title: "Remove Legal Name",
                                       message: "Are You Sure?",
                                       preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Yes", style: .destructive, handler: {[weak self] _ in
            guard let strongSelf = self else {return}
            strongSelf.personLegalName.text = ""
            strongSelf.personLegalName.textColor = .green
            strongSelf.currentPerson.legalName = nil
            strongSelf.personRemoveLegalNameButton.isHidden = true
            strongSelf.personBeatsArr.sort(by: {$0.name < $1.name})
            strongSelf.personBeatsTableView.reloadData()
            alertC.dismiss(animated: true, completion: nil)
            
        })
        alertC.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alertC.addAction(okAction)
        alertC.view.tintColor = Constants.Colors.redApp
        self.present(alertC, animated: true)
    }
    
    @IBAction func addAltNameTapped(_ sender: Any) {
        let alertC = UIAlertController(title: "Add Alternate Name",
                                                message: "Please type in a name.",
                                                preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Add", style: .default, handler: {[weak self] _ in
            guard let strongSelf = self else {return}
            let field = alertC.textFields![0]
            if field.text != "" {
                guard let name = field.text else {return}
                var newNames:[String] = []
                if let altn = strongSelf.currentPerson.alternateNames {
                    newNames = altn
                }
                newNames.append(name)
                strongSelf.currentPerson.alternateNames = newNames
                strongSelf.personAltNamesTableView.reloadData()
                strongSelf.personAltNamesHeightConstraint.constant = CGFloat(50*(newNames.count))
                alertC.dismiss(animated: true, completion: nil)
            } else {
                alertC.dismiss(animated: true, completion: nil)
            }
        })
        alertC.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alertC.addAction(okAction)
        alertC.addTextField()
        alertC.view.tintColor = Constants.Colors.redApp
        self.present(alertC, animated: true)
    }
    
    @IBAction func changeMainRoleTapped(_ sender: Any) {
        hiddenMainRoleTextField.becomeFirstResponder()
    }
    
    @IBAction func changeSpotifyURLTapped(_ sender: Any) {
        let alertC = UIAlertController(title: "Change Spotify URL",
                                                message: "Please type in a Spotify URL.",
                                                preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Change", style: .default, handler: {[weak self] _ in
            guard let strongSelf = self else {return}
            let field = alertC.textFields![0]
            if field.text != strongSelf.currentPerson.spotify?.url {
                strongSelf.spotifyStatusControl.selectedSegmentIndex = 1
                strongSelf.spotifyStatusControl.selectedSegmentTintColor = Constants.Colors.redApp
                strongSelf.currentPerson.spotify?.isActive = false
                strongSelf.personSpotifyURL.textColor = .green
            }
            if field.text != "" {
                guard let name = field.text else {return}
                strongSelf.personSpotifyURL.text = name
                if let obj = strongSelf.currentPerson.spotify {
                    obj.url = name
                } else {
                    strongSelf.currentPerson.spotify = SpotifyPersonData(url: name, isActive: false, id: "", profileImageURL: "")
                }
                strongSelf.personRemoveSpotifyURLButton.isHidden = false
                strongSelf.spotifyStatusControl.isHidden = false
                alertC.dismiss(animated: true, completion: nil)
            } else {
                alertC.dismiss(animated: true, completion: nil)
            }
        })
        alertC.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alertC.addAction(okAction)
        alertC.addTextField()
        alertC.textFields![0].text = currentPerson.spotify?.url
        alertC.view.tintColor = Constants.Colors.redApp
        self.present(alertC, animated: true)
    }
    
    @IBAction func removeSpotifyURLTapped(_ sender: Any) {
        let alertC = UIAlertController(title: "Remove Spotify URL",
                                       message: "Are You Sure?",
                                       preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Yes", style: .destructive, handler: {[weak self] _ in
            guard let strongSelf = self else {return}
            strongSelf.personSpotifyURL.text = ""
            strongSelf.personSpotifyURL.textColor = .green
            strongSelf.currentPerson.spotify = nil
            strongSelf.personRemoveSpotifyURLButton.isHidden = true
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
            if field.text != strongSelf.currentPerson.apple?.url {
                strongSelf.appleMusicStatusControl.selectedSegmentIndex = 1
                strongSelf.appleMusicStatusControl.selectedSegmentTintColor = Constants.Colors.redApp
                strongSelf.currentPerson.apple?.isActive = false
                strongSelf.personAppleMusicURL.textColor = .green
            }
            if field.text != "" {
                guard let name = field.text else {return}
                strongSelf.personAppleMusicURL.text = name
                if let obj = strongSelf.currentPerson.apple {
                    obj.url = name
                } else {
                    strongSelf.currentPerson.apple = AppleMusicPersonData(url: name, isActive: false, id: "", allAlbumIDs: nil)
                }
                strongSelf.personRemoveAppleMusicURLButton.isHidden = false
                strongSelf.appleMusicStatusControl.isHidden = false
                alertC.dismiss(animated: true, completion: nil)
            } else {
                alertC.dismiss(animated: true, completion: nil)
            }
        })
        alertC.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alertC.addAction(okAction)
        alertC.addTextField()
        alertC.textFields![0].text = currentPerson.apple?.url
        alertC.view.tintColor = Constants.Colors.redApp
        self.present(alertC, animated: true)
    }
    
    @IBAction func removeAppleMusicURLTapped(_ sender: Any) {
        let alertC = UIAlertController(title: "Remove Apple Music URL",
                                       message: "Are You Sure?",
                                       preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Yes", style: .destructive, handler: {[weak self] _ in
            guard let strongSelf = self else {return}
            strongSelf.personAppleMusicURL.text = ""
            strongSelf.personAppleMusicURL.textColor = .green
            strongSelf.currentPerson.apple = nil
            strongSelf.personRemoveAppleMusicURLButton.isHidden = true
            strongSelf.appleMusicStatusControl.isHidden = true
            alertC.dismiss(animated: true, completion: nil)
            
        })
        alertC.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alertC.addAction(okAction)
        alertC.view.tintColor = Constants.Colors.redApp
        self.present(alertC, animated: true)
    }
    
    @IBAction func changeYoutubeChannelURLTapped(_ sender: Any) {
        let alertC = UIAlertController(title: "Change Youtube Channel URL",
                                                message: "Please type in a Youtube Channel URL.",
                                                preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Change", style: .default, handler: {[weak self] _ in
            guard let strongSelf = self else {return}
            let field = alertC.textFields![0]
            if field.text != strongSelf.currentPerson.youtube?.url {
                strongSelf.youtubeStatusControl.selectedSegmentIndex = 1
                strongSelf.youtubeStatusControl.selectedSegmentTintColor = Constants.Colors.redApp
                strongSelf.currentPerson.youtube?.isActive = false
                strongSelf.personYoutubeChannelURL.textColor = .green
            }
            if field.text != "" {
                guard let name = field.text else {return}
                strongSelf.personYoutubeChannelURL.text = name
                if let obj = strongSelf.currentPerson.youtube {
                    obj.url = name
                } else {
                    strongSelf.currentPerson.youtube = YoutubePersonData(url: name, isActive: false)
                }
                strongSelf.personRemoveYoutubeChannelURLButton.isHidden = false
                strongSelf.youtubeStatusControl.isHidden = false
                alertC.dismiss(animated: true, completion: nil)
            } else {
                alertC.dismiss(animated: true, completion: nil)
            }
        })
        alertC.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alertC.addAction(okAction)
        alertC.addTextField()
        alertC.textFields![0].text = currentPerson.youtube?.url
        alertC.view.tintColor = Constants.Colors.redApp
        self.present(alertC, animated: true)
    }
    
    @IBAction func removeYoutubeChannelURLTapped(_ sender: Any) {
        let alertC = UIAlertController(title: "Remove Youtube Channel URL",
                                       message: "Are You Sure?",
                                       preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Yes", style: .destructive, handler: {[weak self] _ in
            guard let strongSelf = self else {return}
            strongSelf.personYoutubeChannelURL.text = ""
            strongSelf.personYoutubeChannelURL.textColor = .green
            strongSelf.currentPerson.youtube = nil
            strongSelf.personRemoveYoutubeChannelURLButton.isHidden = true
            strongSelf.youtubeStatusControl.isHidden = true
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
            if field.text != strongSelf.currentPerson.soundcloud?.url {
                strongSelf.soundcloudStatusControl.selectedSegmentIndex = 1
                strongSelf.soundcloudStatusControl.selectedSegmentTintColor = Constants.Colors.redApp
                strongSelf.currentPerson.soundcloud?.isActive = false
                strongSelf.personSoundcloudURL.textColor = .green
            }
            if field.text != "" {
                guard let name = field.text else {return}
                strongSelf.personSoundcloudURL.text = name
                if let obj = strongSelf.currentPerson.soundcloud {
                    obj.url = name
                } else {
                    strongSelf.currentPerson.soundcloud = SoundcloudPersonData(url: name, isActive: false)
                }
                strongSelf.personRemoveSoundcloudURLButton.isHidden = false
                strongSelf.soundcloudStatusControl.isHidden = false
                alertC.dismiss(animated: true, completion: nil)
            } else {
                alertC.dismiss(animated: true, completion: nil)
            }
        })
        alertC.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alertC.addAction(okAction)
        alertC.addTextField()
        alertC.textFields![0].text = currentPerson.soundcloud?.url
        alertC.view.tintColor = Constants.Colors.redApp
        self.present(alertC, animated: true)
    }
    
    @IBAction func removeSoundcloudURLTapped(_ sender: Any) {
        let alertC = UIAlertController(title: "Remove Soundcloud URL",
                                       message: "Are You Sure?",
                                       preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Yes", style: .destructive, handler: {[weak self] _ in
            guard let strongSelf = self else {return}
            strongSelf.personSoundcloudURL.text = ""
            strongSelf.personSoundcloudURL.textColor = .green
            strongSelf.currentPerson.soundcloud = nil
            strongSelf.personRemoveSoundcloudURLButton.isHidden = true
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
            if field.text != strongSelf.currentPerson.youtubeMusic?.url {
                strongSelf.youtubeMusicStatusControl.selectedSegmentIndex = 1
                strongSelf.youtubeMusicStatusControl.selectedSegmentTintColor = Constants.Colors.redApp
                strongSelf.currentPerson.youtubeMusic?.isActive = false
                strongSelf.personYoutubeMusicURL.textColor = .green
            }
            if field.text != "" {
                guard let name = field.text else {return}
                strongSelf.personYoutubeMusicURL.text = name
                if let obj = strongSelf.currentPerson.youtubeMusic {
                    obj.url = name
                } else {
                    strongSelf.currentPerson.youtubeMusic = YoutubeMusicPersonData(url: name, isActive: false)
                }
                strongSelf.personRemoveYoutubeMusicURLButton.isHidden = false
                strongSelf.youtubeMusicStatusControl.isHidden = false
                alertC.dismiss(animated: true, completion: nil)
            } else {
                alertC.dismiss(animated: true, completion: nil)
            }
        })
        alertC.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alertC.addAction(okAction)
        alertC.addTextField()
        alertC.textFields![0].text = currentPerson.youtubeMusic?.url
        alertC.view.tintColor = Constants.Colors.redApp
        self.present(alertC, animated: true)
    }
    
    @IBAction func removeYoutubeMusicURLTapped(_ sender: Any) {
        let alertC = UIAlertController(title: "Remove Youtube Music URL",
                                       message: "Are You Sure?",
                                       preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Yes", style: .destructive, handler: {[weak self] _ in
            guard let strongSelf = self else {return}
            strongSelf.personYoutubeMusicURL.text = ""
            strongSelf.personYoutubeMusicURL.textColor = .green
            strongSelf.currentPerson.youtube = nil
            strongSelf.personRemoveYoutubeMusicURLButton.isHidden = true
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
            if field.text != strongSelf.currentPerson.amazon?.url {
                strongSelf.amazonStatusControl.selectedSegmentIndex = 1
                strongSelf.amazonStatusControl.selectedSegmentTintColor = Constants.Colors.redApp
                strongSelf.currentPerson.amazon?.isActive = false
                strongSelf.personAmazonURL.textColor = .green
            }
            if field.text != "" {
                guard let name = field.text else {return}
                strongSelf.personAmazonURL.text = name
                if let obj = strongSelf.currentPerson.amazon {
                    obj.url = name
                } else {
                    strongSelf.currentPerson.amazon = AmazonPersonData(url: name, isActive: false)
                }
                strongSelf.personRemoveAmazonURLButton.isHidden = false
                strongSelf.amazonStatusControl.isHidden = false
                alertC.dismiss(animated: true, completion: nil)
            } else {
                alertC.dismiss(animated: true, completion: nil)
            }
        })
        alertC.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alertC.addAction(okAction)
        alertC.addTextField()
        alertC.textFields![0].text = currentPerson.amazon?.url
        alertC.view.tintColor = Constants.Colors.redApp
        self.present(alertC, animated: true)
    }
    
    @IBAction func removeAmazonMusicURLTapped(_ sender: Any) {
        let alertC = UIAlertController(title: "Remove Amazon Music URL",
                                       message: "Are You Sure?",
                                       preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Yes", style: .destructive, handler: {[weak self] _ in
            guard let strongSelf = self else {return}
            strongSelf.personAmazonURL.text = ""
            strongSelf.personAmazonURL.textColor = .green
            strongSelf.currentPerson.amazon = nil
            strongSelf.personRemoveAmazonURLButton.isHidden = true
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
            if field.text != strongSelf.currentPerson.deezer?.url {
                strongSelf.deezerStatusControl.selectedSegmentIndex = 1
                strongSelf.deezerStatusControl.selectedSegmentTintColor = Constants.Colors.redApp
                strongSelf.currentPerson.deezer?.isActive = false
                strongSelf.personDeezerURL.textColor = .green
            }
            if field.text != "" {
                guard let name = field.text else {return}
                strongSelf.personDeezerURL.text = name
                if let obj = strongSelf.currentPerson.deezer {
                    obj.url = name
                } else {
                    strongSelf.currentPerson.deezer = DeezerPersonData(url: name, profileImageURL: "", id: "", name: "", isActive: false)
                }
                strongSelf.personRemoveDeezerURLButton.isHidden = false
                strongSelf.deezerStatusControl.isHidden = false
                alertC.dismiss(animated: true, completion: nil)
            } else {
                alertC.dismiss(animated: true, completion: nil)
            }
        })
        alertC.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alertC.addAction(okAction)
        alertC.addTextField()
        alertC.textFields![0].text = currentPerson.deezer?.url
        alertC.view.tintColor = Constants.Colors.redApp
        self.present(alertC, animated: true)
    }
    
    @IBAction func removeDeezerURLTapped(_ sender: Any) {
        let alertC = UIAlertController(title: "Remove Deezer URL",
                                       message: "Are You Sure?",
                                       preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Yes", style: .destructive, handler: {[weak self] _ in
            guard let strongSelf = self else {return}
            strongSelf.personDeezerURL.text = ""
            strongSelf.personDeezerURL.textColor = .green
            strongSelf.currentPerson.deezer = nil
            strongSelf.personRemoveDeezerURLButton.isHidden = true
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
            if field.text != strongSelf.currentPerson.tidal?.url {
                strongSelf.tidalStatusControl.selectedSegmentIndex = 1
                strongSelf.tidalStatusControl.selectedSegmentTintColor = Constants.Colors.redApp
                strongSelf.currentPerson.tidal?.isActive = false
                strongSelf.personTidalURL.textColor = .green
            }
            if field.text != "" {
                guard let name = field.text else {return}
                strongSelf.personTidalURL.text = name
                if let obj = strongSelf.currentPerson.tidal {
                    obj.url = name
                } else {
                    strongSelf.currentPerson.tidal = TidalPersonData(url: name, isActive: false)
                }
                strongSelf.personRemoveTidalURLButton.isHidden = false
                strongSelf.tidalStatusControl.isHidden = false
                alertC.dismiss(animated: true, completion: nil)
            } else {
                alertC.dismiss(animated: true, completion: nil)
            }
        })
        alertC.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alertC.addAction(okAction)
        alertC.addTextField()
        alertC.textFields![0].text = currentPerson.tidal?.url
        alertC.view.tintColor = Constants.Colors.redApp
        self.present(alertC, animated: true)
    }
    
    @IBAction func removeTidalURLTapped(_ sender: Any) {
        let alertC = UIAlertController(title: "Remove Tidal URL",
                                       message: "Are You Sure?",
                                       preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Yes", style: .destructive, handler: {[weak self] _ in
            guard let strongSelf = self else {return}
            strongSelf.personTidalURL.text = ""
            strongSelf.personTidalURL.textColor = .green
            strongSelf.currentPerson.tidal = nil
            strongSelf.personRemoveTidalURLButton.isHidden = true
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
            if field.text != strongSelf.currentPerson.napster?.url {
                strongSelf.napsterStatusControl.selectedSegmentIndex = 1
                strongSelf.napsterStatusControl.selectedSegmentTintColor = Constants.Colors.redApp
                strongSelf.currentPerson.napster?.isActive = false
                strongSelf.personNapsterURL.textColor = .green
            }
            if field.text != "" {
                guard let name = field.text else {return}
                strongSelf.personNapsterURL.text = name
                if let obj = strongSelf.currentPerson.napster {
                    obj.url = name
                } else {
                    strongSelf.currentPerson.napster = NapsterPersonData(url: name, isActive: false)
                }
                strongSelf.personRemoveNapsterURLButton.isHidden = false
                strongSelf.napsterStatusControl.isHidden = false
                alertC.dismiss(animated: true, completion: nil)
            } else {
                alertC.dismiss(animated: true, completion: nil)
            }
        })
        alertC.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alertC.addAction(okAction)
        alertC.addTextField()
        alertC.textFields![0].text = currentPerson.napster?.url
        alertC.view.tintColor = Constants.Colors.redApp
        self.present(alertC, animated: true)
    }
    
    @IBAction func removeNapsterURLTapped(_ sender: Any) {
        let alertC = UIAlertController(title: "Remove Napster URL",
                                       message: "Are You Sure?",
                                       preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Yes", style: .destructive, handler: {[weak self] _ in
            guard let strongSelf = self else {return}
            strongSelf.personNapsterURL.text = ""
            strongSelf.personNapsterURL.textColor = .green
            strongSelf.currentPerson.napster = nil
            strongSelf.personRemoveNapsterURLButton.isHidden = true
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
            if field.text != strongSelf.currentPerson.spinrilla?.url {
                strongSelf.spinrillaStatusControl.selectedSegmentIndex = 1
                strongSelf.spinrillaStatusControl.selectedSegmentTintColor = Constants.Colors.redApp
                strongSelf.currentPerson.spinrilla?.isActive = false
                strongSelf.personSpinrillaURL.textColor = .green
            }
            if field.text != "" {
                guard let name = field.text else {return}
                strongSelf.personSpinrillaURL.text = name
                if let obj = strongSelf.currentPerson.spinrilla {
                    obj.url = name
                } else {
                    strongSelf.currentPerson.spinrilla = SpinrillaPersonData(url: name, isActive: false)
                }
                strongSelf.personRemoveSpinrillaURLButton.isHidden = false
                strongSelf.spinrillaStatusControl.isHidden = false
                alertC.dismiss(animated: true, completion: nil)
            } else {
                alertC.dismiss(animated: true, completion: nil)
            }
        })
        alertC.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alertC.addAction(okAction)
        alertC.addTextField()
        alertC.textFields![0].text = currentPerson.spinrilla?.url
        alertC.view.tintColor = Constants.Colors.redApp
        self.present(alertC, animated: true)
    }
    
    @IBAction func removeSpinrillaURLTapped(_ sender: Any) {
        let alertC = UIAlertController(title: "Remove Spinrilla URL",
                                       message: "Are You Sure?",
                                       preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Yes", style: .destructive, handler: {[weak self] _ in
            guard let strongSelf = self else {return}
            strongSelf.personSpinrillaURL.text = ""
            strongSelf.personSpinrillaURL.textColor = .green
            strongSelf.currentPerson.spinrilla = nil
            strongSelf.personRemoveSpinrillaURLButton.isHidden = true
            strongSelf.spinrillaStatusControl.isHidden = true
            alertC.dismiss(animated: true, completion: nil)
            
        })
        alertC.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alertC.addAction(okAction)
        alertC.view.tintColor = Constants.Colors.redApp
        self.present(alertC, animated: true)
    }
    
    @IBAction func changeTwitterURLTapped(_ sender: Any) {
        let alertC = UIAlertController(title: "Change Twitter URL",
                                                message: "Please type in a Twitter URL.",
                                                preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Change", style: .default, handler: {[weak self] _ in
            guard let strongSelf = self else {return}
            let field = alertC.textFields![0]
            if field.text != strongSelf.currentPerson.twitter?.url {
                strongSelf.twitterStatusControl.selectedSegmentIndex = 1
                strongSelf.twitterStatusControl.selectedSegmentTintColor = Constants.Colors.redApp
                strongSelf.currentPerson.twitter?.isActive = false
                strongSelf.personTwitterURL.textColor = .green
            }
            if field.text != "" {
                guard let name = field.text else {return}
                strongSelf.personTwitterURL.text = name
                if let obj = strongSelf.currentPerson.twitter {
                    obj.url = name
                } else {
                    strongSelf.currentPerson.twitter = TwitterPersonData(url: name, isActive: false, dateCreated: "", name: "", userName: "", id: "", profileImageURL: "")
                }
                strongSelf.personRemoveTwitterURLButton.isHidden = false
                strongSelf.twitterStatusControl.isHidden = false
                alertC.dismiss(animated: true, completion: nil)
            } else {
                alertC.dismiss(animated: true, completion: nil)
            }
        })
        alertC.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alertC.addAction(okAction)
        alertC.addTextField()
        alertC.textFields![0].text = currentPerson.twitter?.url
        alertC.view.tintColor = Constants.Colors.redApp
        self.present(alertC, animated: true)
    }
    
    @IBAction func removeTwitterURLTapped(_ sender: Any) {
        let alertC = UIAlertController(title: "Remove Twitter URL",
                                       message: "Are You Sure?",
                                       preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Yes", style: .destructive, handler: {[weak self] _ in
            guard let strongSelf = self else {return}
            strongSelf.personTwitterURL.text = ""
            strongSelf.personTwitterURL.textColor = .green
            strongSelf.currentPerson.twitter = nil
            strongSelf.personRemoveTwitterURLButton.isHidden = true
            strongSelf.twitterStatusControl.isHidden = true
            alertC.dismiss(animated: true, completion: nil)
            
        })
        alertC.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alertC.addAction(okAction)
        alertC.view.tintColor = Constants.Colors.redApp
        self.present(alertC, animated: true)
    }
    
    @IBAction func changeInstagramURLTapped(_ sender: Any) {
        let alertC = UIAlertController(title: "Change Instagram URL",
                                                message: "Please type in a Instagram URL.",
                                                preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Change", style: .default, handler: {[weak self] _ in
            guard let strongSelf = self else {return}
            let field = alertC.textFields![0]
            if field.text != strongSelf.currentPerson.instagram?.url {
                strongSelf.instagramStatusControl.selectedSegmentIndex = 1
                strongSelf.instagramStatusControl.selectedSegmentTintColor = Constants.Colors.redApp
                strongSelf.currentPerson.instagram?.isActive = false
                strongSelf.personInstagramURL.textColor = .green
            }
            if field.text != "" {
                guard let name = field.text else {return}
                strongSelf.personInstagramURL.text = name
                if let obj = strongSelf.currentPerson.instagram {
                    obj.url = name
                } else {
                    strongSelf.currentPerson.instagram = InstagramPersonData(url: name, isActive: false)
                }
                strongSelf.personRemoveInstagramURLButton.isHidden = false
                strongSelf.instagramStatusControl.isHidden = false
                alertC.dismiss(animated: true, completion: nil)
            } else {
                alertC.dismiss(animated: true, completion: nil)
            }
        })
        alertC.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alertC.addAction(okAction)
        alertC.addTextField()
        alertC.textFields![0].text = currentPerson.instagram?.url
        alertC.view.tintColor = Constants.Colors.redApp
        self.present(alertC, animated: true)
    }
    
    @IBAction func removeInstagramURLTapped(_ sender: Any) {
        let alertC = UIAlertController(title: "Remove Instagram URL",
                                       message: "Are You Sure?",
                                       preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Yes", style: .destructive, handler: {[weak self] _ in
            guard let strongSelf = self else {return}
            strongSelf.personInstagramURL.text = ""
            strongSelf.personInstagramURL.textColor = .green
            strongSelf.currentPerson.instagram = nil
            strongSelf.personRemoveInstagramURLButton.isHidden = true
            strongSelf.instagramStatusControl.isHidden = true
            alertC.dismiss(animated: true, completion: nil)
            
        })
        alertC.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alertC.addAction(okAction)
        alertC.view.tintColor = Constants.Colors.redApp
        self.present(alertC, animated: true)
    }
    
    @IBAction func changeFacebookURLTapped(_ sender: Any) {
        let alertC = UIAlertController(title: "Change Facebook URL",
                                                message: "Please type in a Facebook URL.",
                                                preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Change", style: .default, handler: {[weak self] _ in
            guard let strongSelf = self else {return}
            let field = alertC.textFields![0]
            if field.text != strongSelf.currentPerson.facebook?.url {
                strongSelf.facebookStatusControl.selectedSegmentIndex = 1
                strongSelf.facebookStatusControl.selectedSegmentTintColor = Constants.Colors.redApp
                strongSelf.currentPerson.facebook?.isActive = false
                strongSelf.personFacebookURL.textColor = .green
            }
            if field.text != "" {
                guard let name = field.text else {return}
                strongSelf.personFacebookURL.text = name
                if let obj = strongSelf.currentPerson.facebook {
                    obj.url = name
                } else {
                    strongSelf.currentPerson.facebook = FacebookPersonData(url: name, isActive: false)
                }
                strongSelf.personRemoveFacebookURLButton.isHidden = false
                strongSelf.facebookStatusControl.isHidden = false
                alertC.dismiss(animated: true, completion: nil)
            } else {
                alertC.dismiss(animated: true, completion: nil)
            }
        })
        alertC.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alertC.addAction(okAction)
        alertC.addTextField()
        alertC.textFields![0].text = currentPerson.facebook?.url
        alertC.view.tintColor = Constants.Colors.redApp
        self.present(alertC, animated: true)
    }
    
    @IBAction func removeFacebookURLTapped(_ sender: Any) {
        let alertC = UIAlertController(title: "Remove Facebook URL",
                                       message: "Are You Sure?",
                                       preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Yes", style: .destructive, handler: {[weak self] _ in
            guard let strongSelf = self else {return}
            strongSelf.personFacebookURL.text = ""
            strongSelf.personFacebookURL.textColor = .green
            strongSelf.currentPerson.facebook = nil
            strongSelf.personRemoveFacebookURLButton.isHidden = true
            strongSelf.facebookStatusControl.isHidden = true
            alertC.dismiss(animated: true, completion: nil)
            
        })
        alertC.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alertC.addAction(okAction)
        alertC.view.tintColor = Constants.Colors.redApp
        self.present(alertC, animated: true)
    }
    
    @IBAction func changeTikTokURLTapped(_ sender: Any) {
        let alertC = UIAlertController(title: "Change Tik Tok URL",
                                                message: "Please type in a Tik Tok URL.",
                                                preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Change", style: .default, handler: {[weak self] _ in
            guard let strongSelf = self else {return}
            let field = alertC.textFields![0]
            if field.text != strongSelf.currentPerson.tikTok?.url {
                strongSelf.tiktokStatusControl.selectedSegmentIndex = 1
                strongSelf.tiktokStatusControl.selectedSegmentTintColor = Constants.Colors.redApp
                strongSelf.currentPerson.tikTok?.isActive = false
                strongSelf.personTikTokURL.textColor = .green
            }
            if field.text != "" {
                guard let name = field.text else {return}
                strongSelf.personTikTokURL.text = name
                if let obj = strongSelf.currentPerson.tikTok {
                    obj.url = name
                } else {
                    strongSelf.currentPerson.tikTok = TikTokPersonData(url: name, isActive: false)
                }
                strongSelf.personRemoveTikTokURLButton.isHidden = false
                strongSelf.tiktokStatusControl.isHidden = false
                alertC.dismiss(animated: true, completion: nil)
            } else {
                alertC.dismiss(animated: true, completion: nil)
            }
        })
        alertC.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alertC.addAction(okAction)
        alertC.addTextField()
        alertC.textFields![0].text = currentPerson.tikTok?.url
        alertC.view.tintColor = Constants.Colors.redApp
        self.present(alertC, animated: true)
    }
    
    @IBAction func removeTikTokURLTapped(_ sender: Any) {
        let alertC = UIAlertController(title: "Remove Tik Tok URL",
                                       message: "Are You Sure?",
                                       preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Yes", style: .destructive, handler: {[weak self] _ in
            guard let strongSelf = self else {return}
            strongSelf.personTikTokURL.text = ""
            strongSelf.personTikTokURL.textColor = .green
            strongSelf.currentPerson.tikTok = nil
            strongSelf.personRemoveTikTokURLButton.isHidden = true
            strongSelf.tiktokStatusControl.isHidden = true
            alertC.dismiss(animated: true, completion: nil)
            
        })
        alertC.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alertC.addAction(okAction)
        alertC.view.tintColor = Constants.Colors.redApp
        self.present(alertC, animated: true)
    }
    
    @IBAction func addSongTapped(_ sender: Any) {
        arr = "song"
        prevPage = "editPerson"
        performSegue(withIdentifier: "editPersonToTonesPick", sender: nil)
    }
    
    func songAdded(_ songAndRoles: [[String]:SongData]) {
        let selectsongrole = songAndRoles[Array(songAndRoles.keys)[0]]!
        var albumsAttatched:[String] = []
        
        if let songAlbums = selectsongrole.albums as? [String] {
            albumsAttatched = songAlbums
        }
        
        var roles:NSDictionary?
        roles = currentPerson.roles?.mutableCopy() as? NSMutableDictionary
        if roles == nil {
            
            roles = [:]
        }
        var newRoles:NSMutableDictionary = (roles!.mutableCopy() as! NSMutableDictionary)
        var engineerDict:NSMutableDictionary = [:]
        if let curRol = roles as? NSDictionary {
            let curRole = curRol.mutableCopy() as! NSMutableDictionary
            if let subCa = curRole["Engineer"] as? NSDictionary
            {
                let subCat = subCa.mutableCopy() as! NSMutableDictionary
                engineerDict = subCat
            }
        }
        
        for i in 0 ... Array(songAndRoles.keys).count-1 {
            if Array(songAndRoles.keys)[i].contains("Artist") {
                selectsongrole.songArtist.append("\(currentPerson.toneDeafAppId)")
                if let curRole = roles as? NSMutableDictionary {
                    if var subrole = curRole["Artist"] as? [String]{
                        subrole.append("\(selectsongrole.toneDeafAppId)")
                        subrole = Array(GlobalFunctions.shared.combine(subrole,albumsAttatched))
                        newRoles["Artist"] = subrole.sorted()
                    } else {
                        var subrole = ["\(selectsongrole.toneDeafAppId)"]
                        subrole = Array(GlobalFunctions.shared.combine(subrole,albumsAttatched))
                        newRoles["Artist"] = subrole.sorted()
                    }
                }
                else {
                    var subrole = ["\(selectsongrole.toneDeafAppId)"]
                    subrole = Array(GlobalFunctions.shared.combine(subrole,albumsAttatched))
                    newRoles["Artist"] = subrole.sorted()
                }
            } else {
                if let dex = selectsongrole.songArtist.firstIndex(of: "\(currentPerson.toneDeafAppId)")
                {selectsongrole.songArtist.remove(at: Int(dex))}
                if var arrrr = newRoles["Artist"] as? [String] {
                    if let dex = arrrr.firstIndex(of: "\(selectsongrole.toneDeafAppId)")
                    {
                        arrrr.remove(at: dex)
                        if !arrrr.isEmpty {
                            newRoles["Artist"] = arrrr.sorted()
                        } else {
                            newRoles["Artist"] = nil
                        }
                    }
                }
            }
            if Array(songAndRoles.keys)[i].contains("Producer") {
                selectsongrole.songProducers.append("\(currentPerson.toneDeafAppId)")
                if let curRole = roles as? NSMutableDictionary {
                    if var subrole = curRole["Producer"] as? [String]{
                        subrole.append("\(selectsongrole.toneDeafAppId)")
                        subrole = Array(GlobalFunctions.shared.combine(subrole,albumsAttatched))
                        newRoles["Producer"] = subrole.sorted()
                    } else {
                        var subrole = ["\(selectsongrole.toneDeafAppId)"]
                        subrole = Array(GlobalFunctions.shared.combine(subrole,albumsAttatched))
                        newRoles["Producer"] = subrole.sorted()
                    }
                }
                else {
                    var subrole = ["\(selectsongrole.toneDeafAppId)"]
                    subrole = Array(GlobalFunctions.shared.combine(subrole,albumsAttatched))
                    newRoles["Producer"] = subrole.sorted()
                }
            } else {
                if let dex = selectsongrole.songProducers.firstIndex(of: "\(currentPerson.toneDeafAppId)")
                {selectsongrole.songProducers.remove(at: Int(dex))}
                if var arrrr = newRoles["Producer"] as? [String] {
                    if let dex = arrrr.firstIndex(of: "\(selectsongrole.toneDeafAppId)")
                    {
                        arrrr.remove(at: dex)
                        if !arrrr.isEmpty {
                            newRoles["Producer"] = arrrr.sorted()
                        } else {
                            newRoles["Producer"] = nil
                        }
                    }
                }
            }
            if Array(songAndRoles.keys)[i].contains("Writer") {
                selectsongrole.songWriters!.append("\(currentPerson.toneDeafAppId)")
                if let curRole = roles as? NSMutableDictionary {
                    if var subrole = curRole["Writer"] as? [String]{
                        subrole.append("\(selectsongrole.toneDeafAppId)")
                        subrole = Array(GlobalFunctions.shared.combine(subrole,albumsAttatched))
                        newRoles["Writer"] = subrole.sorted()
                    } else {
                        var subrole = ["\(selectsongrole.toneDeafAppId)"]
                        subrole = Array(GlobalFunctions.shared.combine(subrole,albumsAttatched))
                        newRoles["Writer"] = subrole.sorted()
                    }
                }
                else {
                    var subrole = ["\(selectsongrole.toneDeafAppId)"]
                    subrole = Array(GlobalFunctions.shared.combine(subrole,albumsAttatched))
                    newRoles["Writer"] = subrole.sorted()
                }
            } else {
                if let dex = selectsongrole.songWriters!.firstIndex(of: "\(currentPerson.toneDeafAppId)")
                {
                    selectsongrole.songWriters!.remove(at: Int(dex))
                }
                if var arrrr = newRoles["Writer"] as? [String] {
                    if let dex = arrrr.firstIndex(of: "\(selectsongrole.toneDeafAppId)")
                    {
                        arrrr.remove(at: dex)
                        if !arrrr.isEmpty {
                            newRoles["Writer"] = arrrr.sorted()
                        } else {
                            newRoles["Writer"] = nil
                        }
                    }
                }
            }
            if Array(songAndRoles.keys)[i].contains("Mix Engineer") {
                selectsongrole.songMixEngineer!.append("\(currentPerson.toneDeafAppId)")
                if let curRole = roles as? NSMutableDictionary {
                    if let subCa = curRole["Engineer"] as? NSDictionary {
                        let subCat = subCa.mutableCopy() as! NSMutableDictionary
                        if var subrole = subCat["Mix Engineer"] as? [String]{
                            subrole.append("\(selectsongrole.toneDeafAppId)")
                            subrole = Array(GlobalFunctions.shared.combine(subrole,albumsAttatched))
                            subCat["Mix Engineer"] = subrole
                            engineerDict["Mix Engineer"] = subrole.sorted()
                        } else {
                            var subrole = ["\(selectsongrole.toneDeafAppId)"]
                            subrole = Array(GlobalFunctions.shared.combine(subrole,albumsAttatched))
                            subCat["Mix Engineer"] = subrole
                            engineerDict["Mix Engineer"] = subrole.sorted()
                        }
                    } else {
                        var subrole = ["\(selectsongrole.toneDeafAppId)"]
                        subrole = Array(GlobalFunctions.shared.combine(subrole,albumsAttatched))
                        engineerDict["Mix Engineer"] = subrole.sorted()
                    }
                } else {
                    var subrole = ["\(selectsongrole.toneDeafAppId)"]
                    subrole = Array(GlobalFunctions.shared.combine(subrole,albumsAttatched))
                    engineerDict["Mix Engineer"] = subrole.sorted()
                }
            } else {
                if let dex = selectsongrole.songMixEngineer?.firstIndex(of: "\(currentPerson.toneDeafAppId)")
                {
                    selectsongrole.songMixEngineer!.remove(at: Int(dex))
                }
                if var arrrr = engineerDict["Mix Engineer"] as? [String] {
                    if let dex = arrrr.firstIndex(of: "\(selectsongrole.toneDeafAppId)")
                    {
                        arrrr.remove(at: dex)
                        if !arrrr.isEmpty {
                            engineerDict["Mix Engineer"] = arrrr.sorted()
                        } else {
                            engineerDict["Mix Engingeer"] = nil
                        }
                    }
                }
            }
            if Array(songAndRoles.keys)[i].contains("Mastering Engineer") {
                selectsongrole.songMasteringEngineer!.append("\(currentPerson.toneDeafAppId)")
                if let curRole = roles as? NSMutableDictionary {
                    if let subCa = curRole["Engineer"] as? NSDictionary {
                        let subCat = subCa.mutableCopy() as! NSMutableDictionary
                        if var subrole = subCat["Mastering Engineer"] as? [String]{
                            subrole.append("\(selectsongrole.toneDeafAppId)")
                            subrole = Array(GlobalFunctions.shared.combine(subrole,albumsAttatched))
                            subCat["Mastering Engineer"] = subrole
                            engineerDict["Mastering Engineer"] = subrole.sorted()
                        } else {
                            var subrole = ["\(selectsongrole.toneDeafAppId)"]
                            subrole = Array(GlobalFunctions.shared.combine(subrole,albumsAttatched))
                            subCat["Mastering Engineer"] = subrole
                            engineerDict["Mastering Engineer"] = subrole.sorted()
                        }
                    } else {
                        var subrole = ["\(selectsongrole.toneDeafAppId)"]
                        subrole = Array(GlobalFunctions.shared.combine(subrole,albumsAttatched))
                        engineerDict["Mastering Engineer"] = subrole.sorted()
                    }
                } else {
                    var subrole = ["\(selectsongrole.toneDeafAppId)"]
                    subrole = Array(GlobalFunctions.shared.combine(subrole,albumsAttatched))
                    engineerDict["Mastering Engineer"] = subrole.sorted()
                }
            } else {
                if let dex = selectsongrole.songMasteringEngineer?.firstIndex(of: "\(currentPerson.toneDeafAppId)")
                {selectsongrole.songMasteringEngineer!.remove(at: Int(dex))}
                if var arrrr = engineerDict["Mastering Engineer"] as? [String] {
                    if let dex = arrrr.firstIndex(of: "\(selectsongrole.toneDeafAppId)")
                    {
                        arrrr.remove(at: dex)
                        if !arrrr.isEmpty {
                            engineerDict["Mastering Engineer"] = arrrr.sorted()
                        } else {
                            engineerDict["Mastering Engineer"] = nil
                        }
                    }
                }
            }
            if Array(songAndRoles.keys)[i].contains("Recording Engineer") {
                selectsongrole.songRecordingEngineer!.append("\(currentPerson.toneDeafAppId)")
                if let curRole = roles as? NSMutableDictionary {
                    if let subCa = curRole["Engineer"] as? NSDictionary {
                        let subCat = subCa.mutableCopy() as! NSMutableDictionary
                        if var subrole = subCat["Recording Engineer"] as? [String]{
                            subrole.append("\(selectsongrole.toneDeafAppId)")
                            subrole = Array(GlobalFunctions.shared.combine(subrole,albumsAttatched))
                            subCat["Recording Engineer"] = subrole
                            engineerDict["Recording Engineer"] = subrole.sorted()
                        } else {
                            var subrole = ["\(selectsongrole.toneDeafAppId)"]
                            subrole = Array(GlobalFunctions.shared.combine(subrole,albumsAttatched))
                            subCat["Recording Engineer"] = subrole
                            engineerDict["Recording Engineer"] = subrole.sorted()
                        }
                    } else {
                        var subrole = ["\(selectsongrole.toneDeafAppId)"]
                        subrole = Array(GlobalFunctions.shared.combine(subrole,albumsAttatched))
                        engineerDict["Recording Engineer"] = subrole.sorted()
                    }
                } else {
                    var subrole = ["\(selectsongrole.toneDeafAppId)"]
                    subrole = Array(GlobalFunctions.shared.combine(subrole,albumsAttatched))
                    engineerDict["Recording Engineer"] = subrole.sorted()
                }
            } else {
                if let dex = selectsongrole.songRecordingEngineer?.firstIndex(of: "\(currentPerson.toneDeafAppId)")
                {
                    selectsongrole.songRecordingEngineer!.remove(at: Int(dex))
                    
                }
                if var arrrr = engineerDict["Recording Engineer"] as? [String] {
                    if let dex = arrrr.firstIndex(of: "\(selectsongrole.toneDeafAppId)")
                    {
                        arrrr.remove(at: dex)
                        if !arrrr.isEmpty {
                            engineerDict["Recording Engineer"] = arrrr.sorted()
                        } else {
                            engineerDict["Recording Engineer"] = nil
                        }
                    }
                }
            }
        }
        newRoles["Engineer"] = engineerDict
        currentPerson.roles = newRoles
        initialPerson.roles = newRoles
        
        if !personSongsArr.contains(selectsongrole) {
            personSongsArr.append(selectsongrole)
        } else {
            let dex = personSongsArr.firstIndex(of: selectsongrole)
            personSongsArr[dex!] = selectsongrole
        }
        
        if currentPerson.songs == nil {
            currentPerson.songs = ["\(selectsongrole.toneDeafAppId)"]
        } else {
            if !currentPerson.songs!.contains(selectsongrole.toneDeafAppId) {
                currentPerson.songs!.append("\(selectsongrole.toneDeafAppId)")
            }
        }
        DispatchQueue.main.async {[weak self]  in
            guard let strongSelf = self else {return}
            strongSelf.personSongsTableView.reloadData()
            if strongSelf.personSongsArr.count < 6 {
                strongSelf.personSongsHeightConstraint.constant = CGFloat(50*(strongSelf.personSongsArr.count))
            } else {
                strongSelf.personSongsHeightConstraint.constant = CGFloat(270)
            }
        }
        
        if let songAlbums = selectsongrole.albums as? [String] {
            var count = 0
            for alb in songAlbums {
                getAlbum(albumIdFull: alb, completion: {[weak self] album in
                    guard let strongSelf = self else {return}
                    let arr = Array(songAndRoles.keys)[0]
                    
                    if arr.contains("Artist") {
                        if var albarr = album.allArtists as? [String] {
                            if !albarr.contains(strongSelf.currentPerson.toneDeafAppId) {
                                albarr.append("\(strongSelf.currentPerson.toneDeafAppId)")
                                album.allArtists = albarr
                            }
                        } else {
                            album.allArtists = ["\(strongSelf.currentPerson.toneDeafAppId)"]
                        }
                        if !strongSelf.albumFeaturedArtistArr.contains(album.toneDeafAppId) {
                            strongSelf.albumFeaturedArtistArr.append(album.toneDeafAppId)
                        }
                    } else {
                        if let dex = album.allArtists?.firstIndex(of: "\(strongSelf.currentPerson.toneDeafAppId)")
                        {
                            album.allArtists!.remove(at: Int(dex))
                        }
                        if let dex = album.mainArtist.firstIndex(of: "\(strongSelf.currentPerson.toneDeafAppId)")
                        {
                            album.mainArtist.remove(at: Int(dex))
                        }
                    }
                    if arr.contains("Producer") {
                        if !album.producers.contains(strongSelf.currentPerson.toneDeafAppId) {
                            album.producers.append("\(strongSelf.currentPerson.toneDeafAppId)")
                        }
                    } else {
                        if let dex = album.producers.firstIndex(of: "\(strongSelf.currentPerson.toneDeafAppId)")
                        {
                            album.producers.remove(at: Int(dex))
                        }
                    }
                    if arr.contains("Writer") {
                        if var albarr = album.writers as? [String] {
                            if !albarr.contains(strongSelf.currentPerson.toneDeafAppId) {
                                albarr.append("\(strongSelf.currentPerson.toneDeafAppId)")
                                album.writers = albarr
                            }
                        } else {
                            album.writers = ["\(strongSelf.currentPerson.toneDeafAppId)"]
                        }
                    } else {
                        if let dex = album.writers?.firstIndex(of: "\(strongSelf.currentPerson.toneDeafAppId)")
                        {
                            album.writers!.remove(at: Int(dex))
                        }
                    }
                    if arr.contains("Mix Engineer") {
                        if var albarr = album.mixEngineers as? [String] {
                            if !albarr.contains(strongSelf.currentPerson.toneDeafAppId) {
                                albarr.append("\(strongSelf.currentPerson.toneDeafAppId)")
                                album.mixEngineers = albarr
                            }
                        } else {
                            album.mixEngineers = ["\(strongSelf.currentPerson.toneDeafAppId)"]
                        }
                    } else {
                        if let dex = album.mixEngineers?.firstIndex(of: "\(strongSelf.currentPerson.toneDeafAppId)")
                        {
                            album.mixEngineers!.remove(at: Int(dex))
                        }
                    }
                    if arr.contains("Mastering Engineer") {
                        if var albarr = album.masteringEngineers as? [String] {
                            if !albarr.contains(strongSelf.currentPerson.toneDeafAppId) {
                                albarr.append("\(strongSelf.currentPerson.toneDeafAppId)")
                                album.masteringEngineers = albarr
                            }
                        } else {
                            album.masteringEngineers = ["\(strongSelf.currentPerson.toneDeafAppId)"]
                        }
                    } else {
                        if let dex = album.masteringEngineers?.firstIndex(of: "\(strongSelf.currentPerson.toneDeafAppId)")
                        {
                            album.masteringEngineers!.remove(at: Int(dex))
                        }
                    }
                    if arr.contains("Recording Engineer") {
                        if var albarr = album.recordingEngineers as? [String] {
                            if !albarr.contains(strongSelf.currentPerson.toneDeafAppId) {
                                albarr.append("\(strongSelf.currentPerson.toneDeafAppId)")
                                album.recordingEngineers = albarr
                            }
                        } else {
                            album.recordingEngineers = ["\(strongSelf.currentPerson.toneDeafAppId)"]
                        }
                    } else {
                        if let dex = album.recordingEngineers?.firstIndex(of: "\(strongSelf.currentPerson.toneDeafAppId)")
                        {
                            album.recordingEngineers!.remove(at: Int(dex))
                        }
                    }
                    
                    if !strongSelf.personAlbumsArr.contains(album) {
                        strongSelf.personAlbumsArr.append(album)
                    } else {
                        let dex = strongSelf.personAlbumsArr.firstIndex(of: album)
                        let firstalb = strongSelf.personAlbumsArr[dex!]
                        firstalb.mainArtist = Array(GlobalFunctions.shared.combine( album.mainArtist, firstalb.mainArtist))
                        firstalb.allArtists = Array(GlobalFunctions.shared.combine( album.allArtists, firstalb.allArtists))
                        firstalb.producers = Array(GlobalFunctions.shared.combine( album.producers, firstalb.producers))
                        firstalb.writers = Array(GlobalFunctions.shared.combine( album.writers, firstalb.writers))
                        firstalb.mixEngineers = Array(GlobalFunctions.shared.combine( album.mixEngineers, firstalb.mixEngineers))
                        firstalb.masteringEngineers = Array(GlobalFunctions.shared.combine( album.masteringEngineers, firstalb.masteringEngineers))
                        firstalb.recordingEngineers = Array(GlobalFunctions.shared.combine( album.recordingEngineers, firstalb.recordingEngineers))
                    }
                    count+=1
                    if count == songAlbums.count {
                        if strongSelf.currentPerson.albums == nil {
                            strongSelf.currentPerson.albums = ["\(album.toneDeafAppId)"]
                        } else {
                            if !strongSelf.currentPerson.albums!.contains(album.toneDeafAppId) {
                                strongSelf.currentPerson.albums!.append("\(album.toneDeafAppId)")
                            }
                        }
                        
                        DispatchQueue.main.async {[weak self]  in
                            guard let strongSelf = self else {return}
                            strongSelf.personAlbumsArr.sort(by: {$0.name < $1.name})
                            strongSelf.personAlbumsTableView.reloadData()
                            strongSelf.personAlbumsHeightConstraint.constant = CGFloat(50*(strongSelf.personAlbumsArr.count))
                        }
                    }
                })
            }
        }
        
    }
    
    @IBAction func addAlbumTapped(_ sender: Any) {
        arr = "album"
        prevPage = "editPerson"
        performSegue(withIdentifier: "editPersonToTonesPick", sender: nil)
    }
    
    func albumAdded(_ albumAndRoles: [[String]:AlbumData]) {
        let selectalbumrole = albumAndRoles[Array(albumAndRoles.keys)[0]]!
        let rolesArr = Array(albumAndRoles.keys)[0]
        let tracksAndRoles:NSMutableDictionary = [:]
        DispatchQueue.global(qos: .userInitiated).async {[weak self] in
            guard let strongSelf = self else {return}
            let semaphore = DispatchSemaphore(value: 0)
            let semap = DispatchSemaphore(value: 0)
            var counter = 0
            for i in 0 ... rolesArr.count-1 {
                if rolesArr.contains("Main Artist") && rolesArr[i] == "Featured Artist" {
                    counter+=1
                    if rolesArr.count != 1 {
                        semap.signal()
                    }
                    if counter == rolesArr.count {
                        semaphore.signal()
                    }
                } else {
                    DispatchQueue.main.async {
                        guard let strongSelf = self else {return}
                        let alertC = UIAlertController(title: "\(rolesArr[i]) Role",
                                                       message: "Please select the tracks that \(strongSelf.currentPerson.name!) appears as a \(rolesArr[i])",
                                                       preferredStyle: .alert)
                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                        let vc3 = storyboard.instantiateViewController(identifier: "editPersonRolesSongsForAlbumPopoverTableViewController") as
                        EditPersonRolesSongsForAlbumPopoverTableViewController
                        vc3.preferredContentSize = CGSize(width: 350, height: 350) // 4 default cell heights.
                        vc3.trackArr = selectalbumrole.tracks
                        if rolesArr[i] == "Writer" || rolesArr[i] == "Recording Engineer" {
                            for track in vc3.trackArr {
                                if track.value.count == 12 {
                                    vc3.trackArr.removeValue(forKey: track.key)
                                }
                            }
                        }
                        alertC.setValue(vc3, forKey: "contentViewController")
                        
                        let okAction = UIAlertAction(title: "Select", style: .default, handler: {[weak self] _ in
                            guard let strongSelf = self else {return}
                            var tracksForCurrentRole:[String] = []
                            let cc = alertC.value(forKey: "contentViewController") as! EditPersonRolesSongsForAlbumPopoverTableViewController
                            for i in 1 ... (cc.trackArr.count) {
                                let cell = cc.tableViewPopover.cellForRow(at: IndexPath(row: i-1, section: 0)) as! EditRolesSongsForAlbumPopoverTableCellController
                                if cell.checkbox.on {
                                    tracksForCurrentRole.append(cell.appId.text!)
                                }
                            }
                            
                            guard !tracksForCurrentRole.isEmpty || rolesArr[i] == "Main Artist" else {
                                mediumImpactGenerator.impactOccurred()
                                DispatchQueue.main.async {
                                    Utilities.showError2("Role required.", actionText: "OK")
                                }
                                return
                            }
                            if rolesArr[i] == "Main Artist" && tracksForCurrentRole.isEmpty {
//                                tracksAndRoles[rolesArr[i]] = [selectalbumrole.toneDeafAppId]
                            } else {
                                tracksAndRoles[rolesArr[i]] = tracksForCurrentRole
                            }
                            counter+=1
                            alertC.dismiss(animated: true, completion: nil)
                            if rolesArr.count != 1 {
                                semap.signal()
                            }
                            if counter == rolesArr.count {
                                semaphore.signal()
                            }
                        })
                        alertC.addAction(okAction)
                        alertC.view.tintColor = Constants.Colors.redApp
                        strongSelf.present(alertC, animated: true)
                    }
                }
                if rolesArr.count != 1 {
                    semap.wait()
                }
            }
            
            semaphore.wait()
            
//            print(String(data: try! JSONSerialization.data(withJSONObject: tracksAndRoles, options: .prettyPrinted), encoding: .utf8)!)
            var songsAsArtistRole:[String] = []
            var songsAsProducerRole:[String] = []
            var songsAsWriterRole:[String] = []
            var songsAsMixEngRole:[String] = []
            var songsAsMasteringEngRole:[String] = []
            var songsAsRecordingEngRole:[String] = []
            if let arrrrr = tracksAndRoles["Main Artist"] as? [String] {
                songsAsArtistRole = Array(GlobalFunctions.shared.combine(arrrrr,songsAsArtistRole))
                
            }
            if let arrrrr = tracksAndRoles["Featured Artist"] as? [String] {
                songsAsArtistRole = Array(GlobalFunctions.shared.combine(arrrrr,songsAsArtistRole))
            }
            if let arrrrr = tracksAndRoles["Producer"] as? [String] {
                songsAsProducerRole = Array(GlobalFunctions.shared.combine(arrrrr,songsAsProducerRole))
            }
            if let arrrrr = tracksAndRoles["Writer"] as? [String] {
                songsAsWriterRole = Array(GlobalFunctions.shared.combine(arrrrr,songsAsWriterRole))
            }
            if let arrrrr = tracksAndRoles["Mix Engineer"] as? [String] {
                songsAsMixEngRole = Array(GlobalFunctions.shared.combine(arrrrr,songsAsMixEngRole))
            }
            if let arrrrr = tracksAndRoles["Mastering Engineer"] as? [String] {
                songsAsMasteringEngRole = Array(GlobalFunctions.shared.combine(arrrrr,songsAsMasteringEngRole))
            }
            if let arrrrr = tracksAndRoles["Recording Engineer"] as? [String] {
                songsAsRecordingEngRole = Array(GlobalFunctions.shared.combine(arrrrr,songsAsRecordingEngRole))
            }
            let allSongsWithRoleAttached:[String] = Array(GlobalFunctions.shared.combine(songsAsArtistRole,songsAsProducerRole,songsAsWriterRole,songsAsMixEngRole,songsAsMasteringEngRole,songsAsRecordingEngRole))
            
            var innercount = 0
            for track in allSongsWithRoleAttached {
                switch track.value.count {
                case 10:
                    DispatchQueue.main.async {
                    DatabaseManager.shared.findSongById(songId: track.value, completion: { result in
                        DispatchQueue.global(qos: .userInitiated).async {
                        switch result {
                        case.success(let song):
                            let person = strongSelf.currentPerson.toneDeafAppId
                            if songsAsArtistRole.contains(song.toneDeafAppId) {
                                if !song.songArtist.contains(person) {
                                    song.songArtist.append(person)
                                }
                            } else {
                                if let dex = song.songArtist.firstIndex(of: "\(person)")
                                {
                                    song.songArtist.remove(at: Int(dex))
                                }
                            }
                            if songsAsProducerRole.contains(song.toneDeafAppId) {
                                if !song.songProducers.contains(person) {
                                    song.songProducers.append(person)
                                }
                            } else {
                                if let dex = song.songProducers.firstIndex(of: "\(person)")
                                {
                                    song.songProducers.remove(at: Int(dex))
                                }
                            }
                            if songsAsWriterRole.contains(song.toneDeafAppId) {
                                if var arr3 = song.songWriters as? [String] {
                                    if !arr3.contains(person) {
                                        arr3.append(person)
                                    }
                                    song.songWriters = arr3
                                } else {
                                    var arr3:[String] = []
                                    arr3.append(person)
                                    song.songWriters = arr3
                                }
                            } else {
                                if let dex = song.songWriters?.firstIndex(of: "\(person)")
                                {
                                    song.songWriters!.remove(at: Int(dex))
                                }
                            }
                            if songsAsMixEngRole.contains(song.toneDeafAppId) {
                                if var arr3 = song.songMixEngineer as? [String] {
                                    if !arr3.contains(person) {
                                        arr3.append(person)
                                    }
                                    song.songMixEngineer = arr3
                                } else {
                                    var arr3:[String] = []
                                    arr3.append(person)
                                    song.songMixEngineer = arr3
                                }
                            } else {
                                if let dex = song.songMixEngineer?.firstIndex(of: "\(person)")
                                {
                                    song.songMixEngineer!.remove(at: Int(dex))
                                }
                            }
                            if songsAsMasteringEngRole.contains(song.toneDeafAppId) {
                                if var arr3 = song.songMasteringEngineer as? [String] {
                                    if !arr3.contains(person) {
                                        arr3.append(person)
                                    }
                                    song.songMasteringEngineer = arr3
                                } else {
                                    var arr3:[String] = []
                                    arr3.append(person)
                                    song.songMasteringEngineer = arr3
                                }
                            } else {
                                if let dex = song.songMasteringEngineer?.firstIndex(of: "\(person)")
                                {
                                    song.songMasteringEngineer!.remove(at: Int(dex))
                                }
                            }
                            if songsAsRecordingEngRole.contains(song.toneDeafAppId) {
                                if var arr3 = song.songRecordingEngineer as? [String] {
                                    if !arr3.contains(person) {
                                        arr3.append(person)
                                    }
                                    song.songRecordingEngineer = arr3
                                } else {
                                    var arr3:[String] = []
                                    arr3.append(person)
                                    song.songRecordingEngineer = arr3
                                }
                            } else {
                                if let dex = song.songRecordingEngineer?.firstIndex(of: "\(person)")
                                {
                                    song.songRecordingEngineer!.remove(at: Int(dex))
                                }
                            }
                            if !strongSelf.personSongsArr.contains(song) {
                                strongSelf.personSongsArr.append(song)
                            } else {
                                let dex = strongSelf.personSongsArr.firstIndex(of: song)
                                strongSelf.personSongsArr[dex!] = song
                            }
                            if strongSelf.currentPerson.songs == nil {
                                strongSelf.currentPerson.songs = ["\(song.toneDeafAppId)"]
                            } else {
                                if !strongSelf.currentPerson.songs!.contains(song.toneDeafAppId) {
                                    strongSelf.currentPerson.songs!.append("\(song.toneDeafAppId)")
                                }
                            }
                            DispatchQueue.main.async {[weak self]  in
                                guard let strongSelf = self else {return}
                                strongSelf.personSongsTableView.reloadData()
                                if strongSelf.personSongsArr.count < 6 {
                                    strongSelf.personSongsHeightConstraint.constant = CGFloat(50*(strongSelf.personSongsArr.count))
                                } else {
                                    strongSelf.personSongsHeightConstraint.constant = CGFloat(270)
                                }
                            }
                        case.failure(let err):
                            innercount+=1
                            print("A Bad Error ", err)
                        }
                        }
                    })
                    }
                case 12:
                    DispatchQueue.main.async {
                    DatabaseManager.shared.findInstrumentalById(instrumentalId: track.value, completion: { result in
                        DispatchQueue.global(qos: .userInitiated).async {
                        switch result {
                        case.success(let song):
                            let person = strongSelf.currentPerson.toneDeafAppId
                            if songsAsArtistRole.contains(song.toneDeafAppId) {
                                if var arr3 = song.artist as? [String] {
                                    if !arr3.contains(person) {
                                        arr3.append(person)
                                    }
                                    song.artist = arr3
                                } else {
                                    var arr3:[String] = []
                                    arr3.append(person)
                                    song.artist = arr3
                                }
                            } else {
                                if let dex = song.artist?.firstIndex(of: "\(person)")
                                {
                                    song.artist!.remove(at: Int(dex))
                                }
                            }
                            if songsAsProducerRole.contains(song.toneDeafAppId) {
                                if !song.producers.contains(person) {
                                    song.producers.append(person)
                                }
                            } else {
                                if let dex = song.producers.firstIndex(of: "\(person)")
                                {
                                    song.producers.remove(at: Int(dex))
                                }
                            }
                            if songsAsMixEngRole.contains(song.toneDeafAppId) {
                                if var arr3 = song.mixEngineer as? [String] {
                                    if !arr3.contains(person) {
                                        arr3.append(person)
                                    }
                                    song.mixEngineer = arr3
                                } else {
                                    var arr3:[String] = []
                                    arr3.append(person)
                                    song.mixEngineer = arr3
                                }
                            } else {
                                if let dex = song.mixEngineer?.firstIndex(of: "\(person)")
                                {
                                    song.mixEngineer!.remove(at: Int(dex))
                                }
                            }
                            if songsAsMasteringEngRole.contains(song.toneDeafAppId) {
                                if var arr3 = song.masteringEngineer as? [String] {
                                    if !arr3.contains(person) {
                                        arr3.append(person)
                                    }
                                    song.masteringEngineer = arr3
                                } else {
                                    var arr3:[String] = []
                                    arr3.append(person)
                                    song.masteringEngineer = arr3
                                }
                            } else {
                                if let dex = song.masteringEngineer?.firstIndex(of: "\(person)")
                                {
                                    song.masteringEngineer!.remove(at: Int(dex))
                                }
                            }
                            if !strongSelf.personInstrumentalsArr.contains(song) {
                                strongSelf.personInstrumentalsArr.append(song)
                            } else {
                                let dex = strongSelf.personInstrumentalsArr.firstIndex(of: song)
                                strongSelf.personInstrumentalsArr[dex!] = song
                            }
                            if strongSelf.currentPerson.instrumentals == nil {
                                strongSelf.currentPerson.instrumentals = ["\(song.toneDeafAppId)"]
                            } else {
                                if !strongSelf.currentPerson.instrumentals!.contains(song.toneDeafAppId) {
                                    strongSelf.currentPerson.instrumentals!.append("\(song.toneDeafAppId)")
                                }
                            }
                            DispatchQueue.main.async {[weak self]  in
                                guard let strongSelf = self else {return}
                                strongSelf.personInstrumentalsArr.sort(by: {$0.songName! < $1.songName!})
                                strongSelf.personInstrumentalsTableView.reloadData()
                                strongSelf.personInstrumentalsHeightConstraint.constant = CGFloat(50*(strongSelf.personInstrumentalsArr.count))
                            }
                        case.failure(let err):
                            innercount+=1
                            print("A Bad Error ", err)
                        }
                        }
                    })
                    }
                default:
                    break
                }
            }
            
            
            
            
            var roles:NSDictionary?
            roles = strongSelf.currentPerson.roles?.mutableCopy() as? NSMutableDictionary
            if roles == nil {
                roles = [:]
            }
            var newRoles:NSMutableDictionary = (roles!.mutableCopy() as! NSMutableDictionary)
            var engineerDict:NSMutableDictionary = [:]
            if let curRol = roles as? NSDictionary {
                let curRole = curRol.mutableCopy() as! NSMutableDictionary
                if let subCa = curRole["Engineer"] as? NSDictionary
                {
                    let subCat = subCa.mutableCopy() as! NSMutableDictionary
                    engineerDict = subCat
                }
            }
            var ArrayalbumAndRoleskeys = Array(albumAndRoles.keys)
            for i in 0 ... Array(albumAndRoles.keys).count-1 {
                
                if Array(albumAndRoles.keys)[i].contains("Main Artist") {
                    if !selectalbumrole.mainArtist.contains(strongSelf.currentPerson.toneDeafAppId) {
                        selectalbumrole.mainArtist.append("\(strongSelf.currentPerson.toneDeafAppId)")
                    }
                    var hasArtistsSongs:Bool = false
                    for ele in songsAsArtistRole {
                        if ele.count == 10 {
                            hasArtistsSongs = true
                        }
                    }
                    
                    if hasArtistsSongs == true {
                        if let curRole = roles as? NSMutableDictionary {
                            if var subrole = curRole["Artist"] as? [String]{
                                if !subrole.contains(selectalbumrole.toneDeafAppId) {
                                    subrole.append("\(selectalbumrole.toneDeafAppId)")
                                }
                                for track in songsAsArtistRole {
                                    if !subrole.contains(track) {
                                        subrole.append(track)
                                    }
                                }
                                newRoles["Artist"] = subrole.sorted()
                            } else {
                                var subrole = ["\(selectalbumrole.toneDeafAppId)"]
                                subrole = Array(GlobalFunctions.shared.combine(songsAsArtistRole,subrole))
                                newRoles["Artist"] = subrole.sorted()
                            }
                        }
                        else {
                            var subrole = ["\(selectalbumrole.toneDeafAppId)"]
                            subrole.append(contentsOf: songsAsArtistRole)
                            newRoles["Artist"] = subrole.sorted()
                        }
                        
                        if var art = selectalbumrole.allArtists {
                            if !art.contains(strongSelf.currentPerson.toneDeafAppId) {
                                art.append("\(strongSelf.currentPerson.toneDeafAppId)")
                            }
                            selectalbumrole.allArtists = art
                        } else {
                            selectalbumrole.allArtists = ["\(strongSelf.currentPerson.toneDeafAppId)"]
                        }
                        if !strongSelf.albumFeaturedArtistArr.contains(selectalbumrole.toneDeafAppId) {
                            strongSelf.albumFeaturedArtistArr.append(selectalbumrole.toneDeafAppId)
                        }
                    } else {
                        var arrrr = Array(albumAndRoles.keys)[i]
                        if arrrr.contains("Featured Artist") {
                            if let dex = arrrr.firstIndex(of: "Featured Artist") {
                                arrrr.remove(at: dex)
                            }
                            ArrayalbumAndRoleskeys[i] = arrrr
                        }
                    }
                    
                    if !strongSelf.albumMainArtistArr.contains(selectalbumrole.toneDeafAppId) {
                        strongSelf.albumMainArtistArr.append(selectalbumrole.toneDeafAppId)
                    }
                } else {
                    if let dex = selectalbumrole.mainArtist.firstIndex(of: "\(strongSelf.currentPerson.toneDeafAppId)")
                    {selectalbumrole.mainArtist.remove(at: Int(dex))}
                    if var arrrr = newRoles["Artist"] as? [String] {
                        if let dex = arrrr.firstIndex(of: "\(selectalbumrole.toneDeafAppId)")
                        {
                            arrrr.remove(at: dex)
                            if !arrrr.isEmpty {
                                newRoles["Artist"] = arrrr.sorted()
                            } else {
                                newRoles["Artist"] = nil
                            }
                        }
                        for track in songsAsArtistRole {
                            if let dex = arrrr.firstIndex(of: "\(track)")
                            {
                                arrrr.remove(at: dex)
                                if !arrrr.isEmpty {
                                    newRoles["Artist"] = arrrr.sorted()
                                } else {
                                    newRoles["Artist"] = nil
                                }
                            }
                        }
                    }
                    if strongSelf.albumMainArtistArr.contains(selectalbumrole.toneDeafAppId) {
                        if let dex = strongSelf.albumMainArtistArr.firstIndex(of: "\(selectalbumrole.toneDeafAppId)")
                        {
                            strongSelf.albumMainArtistArr.remove(at: dex)
                        }
                    }
                }
                if ArrayalbumAndRoleskeys[i].contains("Featured Artist") {
                    if var art = selectalbumrole.allArtists {
                        if !art.contains(strongSelf.currentPerson.toneDeafAppId) {
                            art.append("\(strongSelf.currentPerson.toneDeafAppId)")
                        }
                        selectalbumrole.allArtists = art
                    } else {
                        selectalbumrole.allArtists = ["\(strongSelf.currentPerson.toneDeafAppId)"]
                    }
                    
                    var hasArtistsSongs:Bool = false
                    for ele in songsAsArtistRole {
                        if ele.count == 10 {
                            hasArtistsSongs = true
                        }
                    }
                    if hasArtistsSongs == true {
                        if let curRole = roles as? NSMutableDictionary {
                            if var subrole = curRole["Artist"] as? [String]{
                                if !subrole.contains(selectalbumrole.toneDeafAppId) {
                                    subrole.append("\(selectalbumrole.toneDeafAppId)")
                                }
                                for track in songsAsArtistRole {
                                    if !subrole.contains(track) {
                                        subrole.append(track)
                                    }
                                }
                                newRoles["Artist"] = subrole.sorted()
                            } else {
                                var subrole = ["\(selectalbumrole.toneDeafAppId)"]
                                subrole.append(contentsOf: songsAsArtistRole)
                                newRoles["Artist"] = subrole.sorted()
                            }
                        }
                        else {
                            var subrole = ["\(selectalbumrole.toneDeafAppId)"]
                            subrole.append(contentsOf: songsAsArtistRole)
                            newRoles["Artist"] = subrole.sorted()
                        }
                    }
                        
                    if !strongSelf.albumFeaturedArtistArr.contains(selectalbumrole.toneDeafAppId) {
                        strongSelf.albumFeaturedArtistArr.append(selectalbumrole.toneDeafAppId)
                    }
                    
                } else {
                    if let dex = selectalbumrole.allArtists?.firstIndex(of: "\(strongSelf.currentPerson.toneDeafAppId)")
                    {
                        selectalbumrole.allArtists!.remove(at: Int(dex))
                        
                    }
                    if var arrrr = newRoles["Artist"] as? [String] {
                        if let dex = arrrr.firstIndex(of: "\(selectalbumrole.toneDeafAppId)")
                        {
                            arrrr.remove(at: dex)
                            if !arrrr.isEmpty {
                                newRoles["Artist"] = arrrr.sorted()
                            } else {
                                newRoles["Artist"] = nil
                            }
                        }
                        for track in songsAsArtistRole {
                            if let dex = arrrr.firstIndex(of: "\(track)")
                            {
                                arrrr.remove(at: dex)
                                if !arrrr.isEmpty {
                                    newRoles["Artist"] = arrrr.sorted()
                                } else {
                                    newRoles["Artist"] = nil
                                }
                            }
                        }
                    }
                    if strongSelf.albumFeaturedArtistArr.contains(selectalbumrole.toneDeafAppId) {
                        if let dex = strongSelf.albumFeaturedArtistArr.firstIndex(of: "\(selectalbumrole.toneDeafAppId)")
                        {
                            strongSelf.albumFeaturedArtistArr.remove(at: dex)
                        }
                    }
                }
                if Array(albumAndRoles.keys)[i].contains("Producer") {
                    if !selectalbumrole.producers.contains(strongSelf.currentPerson.toneDeafAppId) {
                        selectalbumrole.producers.append("\(strongSelf.currentPerson.toneDeafAppId)")
                    }
                    if let curRole = roles as? NSMutableDictionary {
                        if var subrole = curRole["Producer"] as? [String]{
                            if !subrole.contains(selectalbumrole.toneDeafAppId) {
                                subrole.append("\(selectalbumrole.toneDeafAppId)")
                            }
                            for track in songsAsProducerRole {
                                if !subrole.contains(track) {
                                    subrole.append(track)
                                }
                            }
                            newRoles["Producer"] = subrole.sorted()
                        } else {
                            var subrole = ["\(selectalbumrole.toneDeafAppId)"]
                            subrole.append(contentsOf: songsAsProducerRole)
                            newRoles["Producer"] = subrole.sorted()
                        }
                    }
                    else {
                        var subrole = ["\(selectalbumrole.toneDeafAppId)"]
                        subrole.append(contentsOf: songsAsProducerRole)
                        newRoles["Producer"] = subrole.sorted()
                    }
                } else {
                    if let dex = selectalbumrole.producers.firstIndex(of: "\(strongSelf.currentPerson.toneDeafAppId)")
                    {selectalbumrole.producers.remove(at: Int(dex))}
                    if var arrrr = newRoles["Producer"] as? [String] {
                        if let dex = arrrr.firstIndex(of: "\(selectalbumrole.toneDeafAppId)")
                        {
                            arrrr.remove(at: dex)
                            if !arrrr.isEmpty {
                                newRoles["Producer"] = arrrr.sorted()
                            } else {
                                newRoles["Producer"] = nil
                            }
                        }
                        for track in songsAsProducerRole {
                            if let dex = arrrr.firstIndex(of: "\(track)")
                            {
                                arrrr.remove(at: dex)
                                if !arrrr.isEmpty {
                                    newRoles["Producer"] = arrrr.sorted()
                                } else {
                                    newRoles["Producer"] = nil
                                }
                            }
                        }
                    }
                }
                if Array(albumAndRoles.keys)[i].contains("Writer") {
                    if var art = selectalbumrole.writers {
                        if !art.contains(strongSelf.currentPerson.toneDeafAppId) {
                            art.append("\(strongSelf.currentPerson.toneDeafAppId)")
                        }
                        selectalbumrole.writers = art
                    } else {
                        selectalbumrole.writers = ["\(strongSelf.currentPerson.toneDeafAppId)"]
                    }
                    if let curRole = roles as? NSMutableDictionary {
                        if var subrole = curRole["Writer"] as? [String]{
                            if !subrole.contains(selectalbumrole.toneDeafAppId) {
                                subrole.append("\(selectalbumrole.toneDeafAppId)")
                            }
                            for track in songsAsWriterRole {
                                if !subrole.contains(track) {
                                    subrole.append(track)
                                }
                            }
                            newRoles["Writer"] = subrole.sorted()
                        } else {
                            var subrole = ["\(selectalbumrole.toneDeafAppId)"]
                            subrole.append(contentsOf: songsAsWriterRole)
                            newRoles["Writer"] = subrole.sorted()
                        }
                    }
                    else {
                        var subrole = ["\(selectalbumrole.toneDeafAppId)"]
                        subrole.append(contentsOf: songsAsWriterRole)
                        newRoles["Writer"] = subrole.sorted()
                    }
                } else {
                    if let dex = selectalbumrole.writers?.firstIndex(of: "\(strongSelf.currentPerson.toneDeafAppId)")
                    {
                        selectalbumrole.writers!.remove(at: Int(dex))
                    }
                    if var arrrr = newRoles["Writer"] as? [String] {
                        if let dex = arrrr.firstIndex(of: "\(selectalbumrole.toneDeafAppId)")
                        {
                            arrrr.remove(at: dex)
                            if !arrrr.isEmpty {
                                newRoles["Writer"] = arrrr.sorted()
                            } else {
                                newRoles["Writer"] = nil
                            }
                        }
                        for track in songsAsWriterRole {
                            if let dex = arrrr.firstIndex(of: "\(track)")
                            {
                                arrrr.remove(at: dex)
                                if !arrrr.isEmpty {
                                    newRoles["Writer"] = arrrr.sorted()
                                } else {
                                    newRoles["Writer"] = nil
                                }
                            }
                        }
                    }
                }
                if Array(albumAndRoles.keys)[i].contains("Mix Engineer") {
                    if var art = selectalbumrole.mixEngineers {
                        if !art.contains(strongSelf.currentPerson.toneDeafAppId) {
                            art.append("\(strongSelf.currentPerson.toneDeafAppId)")
                        }
                    selectalbumrole.mixEngineers = art
                } else {
                    selectalbumrole.mixEngineers = ["\(strongSelf.currentPerson.toneDeafAppId)"]
                }
                    if let curRole = roles as? NSMutableDictionary {
                        if let subCa = curRole["Engineer"] as? NSDictionary {
                            let subCat = subCa.mutableCopy() as! NSMutableDictionary
                            if var subrole = subCat["Mix Engineer"] as? [String]{
                                if !subrole.contains(selectalbumrole.toneDeafAppId) {
                                    subrole.append("\(selectalbumrole.toneDeafAppId)")
                                }
                                for track in songsAsMixEngRole {
                                    if !subrole.contains(track) {
                                        subrole.append(track)
                                    }
                                }
                                subCat["Mix Engineer"] = subrole
                                engineerDict["Mix Engineer"] = subrole.sorted()
                            } else {
                                var subrole = ["\(selectalbumrole.toneDeafAppId)"]
                                subrole.append(contentsOf: songsAsMixEngRole)
                                subCat["Mix Engineer"] = subrole
                                engineerDict["Mix Engineer"] = subrole.sorted()
                            }
                        } else {
                            var subrole = ["\(selectalbumrole.toneDeafAppId)"]
                            subrole.append(contentsOf: songsAsMixEngRole)
                            engineerDict["Mix Engineer"] = subrole.sorted()
                        }
                    } else {
                        var subrole = ["\(selectalbumrole.toneDeafAppId)"]
                        subrole.append(contentsOf: songsAsMixEngRole)
                        engineerDict["Mix Engineer"] = subrole.sorted()
                    }
                } else {
                    if let dex = selectalbumrole.mixEngineers?.firstIndex(of: "\(strongSelf.currentPerson.toneDeafAppId)")
                    {
                        selectalbumrole.mixEngineers!.remove(at: Int(dex))
                    }
                    if var arrrr = engineerDict["Mix Engineer"] as? [String] {
                        if let dex = arrrr.firstIndex(of: "\(selectalbumrole.toneDeafAppId)")
                        {
                            arrrr.remove(at: dex)
                            if !arrrr.isEmpty {
                                engineerDict["Mix Engineer"] = arrrr.sorted()
                            } else {
                                engineerDict["Mix Engineer"] = nil
                            }
                        }
                        for track in songsAsMixEngRole {
                            if let dex = arrrr.firstIndex(of: "\(track)")
                            {
                                arrrr.remove(at: dex)
                                if !arrrr.isEmpty {
                                    engineerDict["Mix Engineer"] = arrrr.sorted()
                                } else {
                                    engineerDict["Mix Engineer"] = nil
                                }
                            }
                        }
                    }
                }
                if Array(albumAndRoles.keys)[i].contains("Mastering Engineer") {
                    if var art = selectalbumrole.masteringEngineers {
                        if !art.contains(strongSelf.currentPerson.toneDeafAppId) {
                            art.append("\(strongSelf.currentPerson.toneDeafAppId)")
                        }
                        selectalbumrole.masteringEngineers = art
                    } else {
                        selectalbumrole.masteringEngineers = ["\(strongSelf.currentPerson.toneDeafAppId)"]
                    }
                    if let curRole = roles as? NSMutableDictionary {
                        if let subCa = curRole["Engineer"] as? NSDictionary {
                            let subCat = subCa.mutableCopy() as! NSMutableDictionary
                            if var subrole = subCat["Mastering Engineer"] as? [String]{
                                if !subrole.contains(selectalbumrole.toneDeafAppId) {
                                    subrole.append("\(selectalbumrole.toneDeafAppId)")
                                }
                                for track in songsAsMasteringEngRole {
                                    if !subrole.contains(track) {
                                        subrole.append(track)
                                    }
                                }
                                subCat["Mastering Engineer"] = subrole
                                engineerDict["Mastering Engineer"] = subrole.sorted()
                            } else {
                                var subrole = ["\(selectalbumrole.toneDeafAppId)"]
                                subrole.append(contentsOf: songsAsMasteringEngRole)
                                subCat["Mastering Engineer"] = subrole
                                engineerDict["Mastering Engineer"] = subrole.sorted()
                            }
                        } else {
                            var subrole = ["\(selectalbumrole.toneDeafAppId)"]
                            subrole.append(contentsOf: songsAsMasteringEngRole)
                            engineerDict["Mastering Engineer"] = subrole.sorted()
                        }
                    } else {
                        var subrole = ["\(selectalbumrole.toneDeafAppId)"]
                        subrole.append(contentsOf: songsAsMasteringEngRole)
                        engineerDict["Mastering Engineer"] = subrole.sorted()
                    }
                } else {
                    if let dex = selectalbumrole.masteringEngineers?.firstIndex(of: "\(strongSelf.currentPerson.toneDeafAppId)")
                    {selectalbumrole.masteringEngineers!.remove(at: Int(dex))}
                    if var arrrr = engineerDict["Mastering Engineer"] as? [String] {
                        if let dex = arrrr.firstIndex(of: "\(selectalbumrole.toneDeafAppId)")
                        {
                            arrrr.remove(at: dex)
                            if !arrrr.isEmpty {
                                engineerDict["Mastering Engineer"] = arrrr.sorted()
                            } else {
                                engineerDict["Mastering Engineer"] = nil
                            }
                        }
                        for track in songsAsMasteringEngRole {
                            if let dex = arrrr.firstIndex(of: "\(track)")
                            {
                                arrrr.remove(at: dex)
                                if !arrrr.isEmpty {
                                    engineerDict["Mastering Engineer"] = arrrr.sorted()
                                } else {
                                    engineerDict["Mastering Engineer"] = nil
                                }
                            }
                        }
                    }
                }
                if Array(albumAndRoles.keys)[i].contains("Recording Engineer") {
                    if var art = selectalbumrole.recordingEngineers {
                        if !art.contains(strongSelf.currentPerson.toneDeafAppId) {
                            art.append("\(strongSelf.currentPerson.toneDeafAppId)")
                        }
                        selectalbumrole.recordingEngineers = art
                    } else {
                        selectalbumrole.recordingEngineers = ["\(strongSelf.currentPerson.toneDeafAppId)"]
                    }
                    if let curRole = roles as? NSMutableDictionary {
                        if let subCa = curRole["Engineer"] as? NSDictionary {
                            let subCat = subCa.mutableCopy() as! NSMutableDictionary
                            if var subrole = subCat["Recording Engineer"] as? [String]{
                                if !subrole.contains(selectalbumrole.toneDeafAppId) {
                                    subrole.append("\(selectalbumrole.toneDeafAppId)")
                                }
                                for track in songsAsRecordingEngRole {
                                    if !subrole.contains(track) {
                                        subrole.append(track)
                                    }
                                }
                                subCat["Recording Engineer"] = subrole
                                engineerDict["Recording Engineer"] = subrole.sorted()
                            } else {
                                var subrole = ["\(selectalbumrole.toneDeafAppId)"]
                                subrole.append(contentsOf: songsAsRecordingEngRole)
                                engineerDict["Recording Engineer"] = subrole.sorted()
                                subCat["Recording Engineer"] = subrole
                            }
                        } else {
                            var subrole = ["\(selectalbumrole.toneDeafAppId)"]
                            subrole.append(contentsOf: songsAsRecordingEngRole)
                            engineerDict["Recording Engineer"] = subrole.sorted()
                        }
                    } else {
                        var subrole = ["\(selectalbumrole.toneDeafAppId)"]
                        subrole.append(contentsOf: songsAsRecordingEngRole)
                        engineerDict["Recording Engineer"] = subrole.sorted()
                    }
                } else {
                    if let dex = selectalbumrole.recordingEngineers?.firstIndex(of: "\(strongSelf.currentPerson.toneDeafAppId)")
                    {
                        selectalbumrole.recordingEngineers!.remove(at: Int(dex))
                        
                    }
                    if var arrrr = engineerDict["Recording Engineer"] as? [String] {
                        if let dex = arrrr.firstIndex(of: "\(selectalbumrole.toneDeafAppId)")
                        {
                            arrrr.remove(at: dex)
                            if !arrrr.isEmpty {
                                engineerDict["Recording Engineer"] = arrrr.sorted()
                            } else {
                                engineerDict["Recording Engineer"] = nil
                            }
                        }
                        for track in songsAsRecordingEngRole {
                            if let dex = arrrr.firstIndex(of: "\(track)")
                            {
                                arrrr.remove(at: dex)
                                if !arrrr.isEmpty {
                                    engineerDict["Recording Engineer"] = arrrr.sorted()
                                } else {
                                    engineerDict["Recording Engineer"] = nil
                                }
                            }
                        }
                    }
                }
            }
            newRoles["Engineer"] = engineerDict
            strongSelf.currentPerson.roles = newRoles
            strongSelf.initialPerson.roles = newRoles
            
            strongSelf.personAlbumsArr.append(selectalbumrole)
            if strongSelf.currentPerson.albums == nil {
                strongSelf.currentPerson.albums = ["\(selectalbumrole.toneDeafAppId)"]
            } else {
                strongSelf.currentPerson.albums!.append("\(selectalbumrole.toneDeafAppId)")
            }
            DispatchQueue.main.async {[weak self]  in
                guard let strongSelf = self else {return}
                strongSelf.personAlbumsArr.sort(by: {$0.name < $1.name})
                strongSelf.personAlbumsTableView.reloadData()
                strongSelf.personAlbumsHeightConstraint.constant = CGFloat(50*(strongSelf.personAlbumsArr.count))
            }
        }
        
        
        
    }
    
    @IBAction func addVideoTapped(_ sender: Any) {
        arr = "video"
        prevPage = "editPerson"
        performSegue(withIdentifier: "editPersonToTonesPick", sender: nil)
    }
    
    func videoAdded(_ videoAndRoles: [[String]:VideoData]) {
        let selectvideorole = videoAndRoles[Array(videoAndRoles.keys)[0]]!
        var roles:NSDictionary?
        roles = currentPerson.roles?.mutableCopy() as? NSMutableDictionary
        if roles == nil {
            
            roles = [:]
        }
        var newRoles:NSMutableDictionary = (roles!.mutableCopy() as! NSMutableDictionary)
        
        for i in 0 ... Array(videoAndRoles.keys).count-1 {
            if Array(videoAndRoles.keys)[i].contains("Videographer") {
                if var arr = selectvideorole.videographers as? [String] {
                    if !arr.contains(currentPerson.toneDeafAppId) {
                        arr.append("\(currentPerson.toneDeafAppId)")
                    }
                    selectvideorole.videographers = arr.sorted()
                } else {
                    selectvideorole.videographers = ["\(currentPerson.toneDeafAppId)"]
                }
                if let curRole = roles as? NSMutableDictionary {
                    if var subrole = curRole["Videographer"] as? [String]{
                        if !subrole.contains(selectvideorole.toneDeafAppId) {
                            subrole.append("\(selectvideorole.toneDeafAppId)")
                        }
                        newRoles["Videographer"] = subrole.sorted()
                    } else {
                        let subrole = ["\(selectvideorole.toneDeafAppId)"]
                        newRoles["Videographer"] = subrole.sorted()
                    }
                }
                else {
                    let subrole = ["\(selectvideorole.toneDeafAppId)"]
                    newRoles["Videographer"] = subrole.sorted()
                }
            } else {
                if let dex = selectvideorole.videographers?.firstIndex(of: "\(currentPerson.toneDeafAppId)")
                {
                    selectvideorole.videographers!.remove(at: Int(dex))
                }
                if var arrrr = newRoles["Videographer"] as? [String] {
                    if let dex = arrrr.firstIndex(of: "\(selectvideorole.toneDeafAppId)")
                    {
                        arrrr.remove(at: dex)
                        if !arrrr.isEmpty {
                            newRoles["Videographer"] = arrrr.sorted()
                        } else {
                            newRoles["Videographer"] = nil
                        }
                    }
                }
            }
            if Array(videoAndRoles.keys)[i].contains("Other Person") {
                if var arr = selectvideorole.persons as? [String] {
                    if !arr.contains(currentPerson.toneDeafAppId) {
                        arr.append("\(currentPerson.toneDeafAppId)")
                    }
                    selectvideorole.persons = arr.sorted()
                } else {
                    selectvideorole.persons = ["\(currentPerson.toneDeafAppId)"]
                }
                
                if !videoPersonArr.contains(selectvideorole.toneDeafAppId) {
                    videoPersonArr.append(selectvideorole.toneDeafAppId)
                    videoPersonArr.sort()
                }

            } else {
                if let dex = selectvideorole.persons?.firstIndex(of: "\(currentPerson.toneDeafAppId)")
                {
                    selectvideorole.persons!.remove(at: Int(dex))
                }
                if videoPersonArr.contains(selectvideorole.toneDeafAppId) {
                    if let dex = videoPersonArr.firstIndex(of: "\(selectvideorole.toneDeafAppId)")
                    {
                        videoPersonArr.remove(at: dex)
                    }
                }
            }
        }
        currentPerson.roles = newRoles
        initialPerson.roles = newRoles
        
        
        if !personVideosArr.contains(selectvideorole) {
            personVideosArr.append(selectvideorole)
        } else {
            let dex = personVideosArr.firstIndex(of: selectvideorole)
            personVideosArr[dex!] = selectvideorole
        }
        
        if currentPerson.videos == nil {
            currentPerson.videos = ["\(selectvideorole.toneDeafAppId)"]
        } else {
            if !currentPerson.videos!.contains(selectvideorole.toneDeafAppId) {
                currentPerson.videos!.append("\(selectvideorole.toneDeafAppId)")
            }
        }
        DispatchQueue.main.async {[weak self]  in
            guard let strongSelf = self else {return}
            strongSelf.personVideosArr.sort(by: {$0.title < $1.title})
            strongSelf.personVideosTableView.reloadData()
            strongSelf.personVideosHeightConstraint.constant = CGFloat(70*(strongSelf.personVideosArr.count))
        }
    }
    
    @IBAction func addInstrumentalTapped(_ sender: Any) {
        arr = "instrumental"
        prevPage = "editPerson"
        performSegue(withIdentifier: "editPersonToTonesPick", sender: nil)
    }
    
    func instrumentalAdded(_ instrumentalAndRoles: [[String]:InstrumentalData]) {
        let selectinstrumentalrole = instrumentalAndRoles[Array(instrumentalAndRoles.keys)[0]]!
        var albumsAttatched:[String] = []
        
        if let instrumentalAlbums = selectinstrumentalrole.albums as? [String] {
            albumsAttatched = instrumentalAlbums
        }
        
        var roles:NSDictionary?
        roles = currentPerson.roles?.mutableCopy() as? NSMutableDictionary
        if roles == nil {
            
            roles = [:]
        }
        var newRoles:NSMutableDictionary = (roles!.mutableCopy() as! NSMutableDictionary)
        var engineerDict:NSMutableDictionary = [:]
        if let curRol = roles as? NSDictionary {
            let curRole = curRol.mutableCopy() as! NSMutableDictionary
            if let subCa = curRole["Engineer"] as? NSDictionary
            {
                let subCat = subCa.mutableCopy() as! NSMutableDictionary
                engineerDict = subCat
            }
        }
        
        for i in 0 ... Array(instrumentalAndRoles.keys).count-1 {
            if Array(instrumentalAndRoles.keys)[i].contains("Artist") {
                if var arrrrrrr = selectinstrumentalrole.artist {
                    arrrrrrr.append("\(currentPerson.toneDeafAppId)")
                } else {
                    selectinstrumentalrole.artist = []
                    selectinstrumentalrole.artist!.append("\(currentPerson.toneDeafAppId)")
                }
                
                if let curRole = roles as? NSMutableDictionary {
                    if var subrole = curRole["Artist"] as? [String]{
                        subrole.append("\(selectinstrumentalrole.toneDeafAppId)")
                        subrole = Array(GlobalFunctions.shared.combine(subrole,albumsAttatched))
                        newRoles["Artist"] = subrole.sorted()
                    } else {
                        var subrole = ["\(selectinstrumentalrole.toneDeafAppId)"]
                        subrole = Array(GlobalFunctions.shared.combine(subrole,albumsAttatched))
                        newRoles["Artist"] = subrole.sorted()
                    }
                }
                else {
                    var subrole = ["\(selectinstrumentalrole.toneDeafAppId)"]
                    subrole = Array(GlobalFunctions.shared.combine(subrole,albumsAttatched))
                    newRoles["Artist"] = subrole.sorted()
                }
            } else {
                if let dex = selectinstrumentalrole.artist?.firstIndex(of: "\(currentPerson.toneDeafAppId)")
                {selectinstrumentalrole.artist!.remove(at: Int(dex))}
                if var arrrr = newRoles["Artist"] as? [String] {
                    if let dex = arrrr.firstIndex(of: "\(selectinstrumentalrole.toneDeafAppId)")
                    {
                        arrrr.remove(at: dex)
                        if !arrrr.isEmpty {
                            newRoles["Artist"] = arrrr.sorted()
                        } else {
                            newRoles["Artist"] = nil
                        }
                    }
                }
            }
            if Array(instrumentalAndRoles.keys)[i].contains("Producer") {
                selectinstrumentalrole.producers.append("\(currentPerson.toneDeafAppId)")
                if let curRole = roles as? NSMutableDictionary {
                    if var subrole = curRole["Producer"] as? [String]{
                        subrole.append("\(selectinstrumentalrole.toneDeafAppId)")
                        subrole = Array(GlobalFunctions.shared.combine(subrole,albumsAttatched))
                        newRoles["Producer"] = subrole.sorted()
                    } else {
                        var subrole = ["\(selectinstrumentalrole.toneDeafAppId)"]
                        subrole = Array(GlobalFunctions.shared.combine(subrole,albumsAttatched))
                        newRoles["Producer"] = subrole.sorted()
                    }
                }
                else {
                    var subrole = ["\(selectinstrumentalrole.toneDeafAppId)"]
                    subrole = Array(GlobalFunctions.shared.combine(subrole,albumsAttatched))
                    newRoles["Producer"] = subrole.sorted()
                }
            } else {
                if let dex = selectinstrumentalrole.producers.firstIndex(of: "\(currentPerson.toneDeafAppId)")
                {selectinstrumentalrole.producers.remove(at: Int(dex))}
                if var arrrr = newRoles["Producer"] as? [String] {
                    if let dex = arrrr.firstIndex(of: "\(selectinstrumentalrole.toneDeafAppId)")
                    {
                        arrrr.remove(at: dex)
                        if !arrrr.isEmpty {
                            newRoles["Producer"] = arrrr.sorted()
                        } else {
                            newRoles["Producer"] = nil
                        }
                    }
                }
            }
            if Array(instrumentalAndRoles.keys)[i].contains("Mix Engineer") {
                if var arrrrrrr = selectinstrumentalrole.mixEngineer {
                    arrrrrrr.append("\(currentPerson.toneDeafAppId)")
                } else {
                    selectinstrumentalrole.mixEngineer = []
                    selectinstrumentalrole.mixEngineer!.append("\(currentPerson.toneDeafAppId)")
                }
                if let curRole = roles as? NSMutableDictionary {
                    if let subCa = curRole["Engineer"] as? NSDictionary {
                        let subCat = subCa.mutableCopy() as! NSMutableDictionary
                        if var subrole = subCat["Mix Engineer"] as? [String]{
                            subrole.append("\(selectinstrumentalrole.toneDeafAppId)")
                            subrole = Array(GlobalFunctions.shared.combine(subrole,albumsAttatched))
                            subCat["Mix Engineer"] = subrole
                            engineerDict["Mix Engineer"] = subrole.sorted()
                        } else {
                            var subrole = ["\(selectinstrumentalrole.toneDeafAppId)"]
                            subrole = Array(GlobalFunctions.shared.combine(subrole,albumsAttatched))
                            subCat["Mix Engineer"] = subrole
                            engineerDict["Mix Engineer"] = subrole.sorted()
                        }
                    } else {
                        var subrole = ["\(selectinstrumentalrole.toneDeafAppId)"]
                        subrole = Array(GlobalFunctions.shared.combine(subrole,albumsAttatched))
                        engineerDict["Mix Engineer"] = subrole.sorted()
                    }
                } else {
                    var subrole = ["\(selectinstrumentalrole.toneDeafAppId)"]
                    subrole = Array(GlobalFunctions.shared.combine(subrole,albumsAttatched))
                    engineerDict["Mix Engineer"] = subrole.sorted()
                }
            } else {
                if let dex = selectinstrumentalrole.mixEngineer?.firstIndex(of: "\(currentPerson.toneDeafAppId)")
                {
                    selectinstrumentalrole.mixEngineer!.remove(at: Int(dex))
                }
                if var arrrr = engineerDict["Mix Engineer"] as? [String] {
                    if let dex = arrrr.firstIndex(of: "\(selectinstrumentalrole.toneDeafAppId)")
                    {
                        arrrr.remove(at: dex)
                        if !arrrr.isEmpty {
                            engineerDict["Mix Engineer"] = arrrr.sorted()
                        } else {
                            engineerDict["Mix Engingeer"] = nil
                        }
                    }
                }
            }
            if Array(instrumentalAndRoles.keys)[i].contains("Mastering Engineer") {
                if var arrrrrrr = selectinstrumentalrole.masteringEngineer {
                    arrrrrrr.append("\(currentPerson.toneDeafAppId)")
                } else {
                    selectinstrumentalrole.masteringEngineer = []
                    selectinstrumentalrole.masteringEngineer!.append("\(currentPerson.toneDeafAppId)")
                }
                if let curRole = roles as? NSMutableDictionary {
                    if let subCa = curRole["Engineer"] as? NSDictionary {
                        let subCat = subCa.mutableCopy() as! NSMutableDictionary
                        if var subrole = subCat["Mastering Engineer"] as? [String]{
                            subrole.append("\(selectinstrumentalrole.toneDeafAppId)")
                            subrole = Array(GlobalFunctions.shared.combine(subrole,albumsAttatched))
                            subCat["Mastering Engineer"] = subrole
                            engineerDict["Mastering Engineer"] = subrole.sorted()
                        } else {
                            var subrole = ["\(selectinstrumentalrole.toneDeafAppId)"]
                            subrole = Array(GlobalFunctions.shared.combine(subrole,albumsAttatched))
                            subCat["Mastering Engineer"] = subrole
                            engineerDict["Mastering Engineer"] = subrole.sorted()
                        }
                    } else {
                        var subrole = ["\(selectinstrumentalrole.toneDeafAppId)"]
                        subrole = Array(GlobalFunctions.shared.combine(subrole,albumsAttatched))
                        engineerDict["Mastering Engineer"] = subrole.sorted()
                    }
                } else {
                    var subrole = ["\(selectinstrumentalrole.toneDeafAppId)"]
                    subrole = Array(GlobalFunctions.shared.combine(subrole,albumsAttatched))
                    engineerDict["Mastering Engineer"] = subrole.sorted()
                }
            } else {
                if let dex = selectinstrumentalrole.masteringEngineer?.firstIndex(of: "\(currentPerson.toneDeafAppId)")
                {selectinstrumentalrole.masteringEngineer!.remove(at: Int(dex))}
                if var arrrr = engineerDict["Mastering Engineer"] as? [String] {
                    if let dex = arrrr.firstIndex(of: "\(selectinstrumentalrole.toneDeafAppId)")
                    {
                        arrrr.remove(at: dex)
                        if !arrrr.isEmpty {
                            engineerDict["Mastering Engineer"] = arrrr.sorted()
                        } else {
                            engineerDict["Mastering Engineer"] = nil
                        }
                    }
                }
            }
        }
        newRoles["Engineer"] = engineerDict
        currentPerson.roles = newRoles
        initialPerson.roles = newRoles
        
        if !personInstrumentalsArr.contains(selectinstrumentalrole) {
            personInstrumentalsArr.append(selectinstrumentalrole)
        } else {
            let dex = personInstrumentalsArr.firstIndex(of: selectinstrumentalrole)
            personInstrumentalsArr[dex!] = selectinstrumentalrole
        }
        
        if currentPerson.instrumentals == nil {
            currentPerson.instrumentals = ["\(selectinstrumentalrole.toneDeafAppId)"]
        } else {
            if !currentPerson.instrumentals!.contains(selectinstrumentalrole.toneDeafAppId) {
                currentPerson.instrumentals!.append("\(selectinstrumentalrole.toneDeafAppId)")
            }
        }
        DispatchQueue.main.async {[weak self]  in
            guard let strongSelf = self else {return}
            strongSelf.personInstrumentalsArr.sort(by: {$0.songName! < $1.songName!})
            strongSelf.personInstrumentalsTableView.reloadData()
            strongSelf.personInstrumentalsHeightConstraint.constant = CGFloat(50*(strongSelf.personInstrumentalsArr.count))
        }
        
        if let songAlbums = selectinstrumentalrole.albums as? [String] {
            var count = 0
            for alb in songAlbums {
                getAlbum(albumIdFull: alb, completion: {[weak self] album in
                    guard let strongSelf = self else {return}
                    let arr = Array(instrumentalAndRoles.keys)[0]
                    
                    if arr.contains("Artist") {
                        if var albarr = album.allArtists as? [String] {
                            if !albarr.contains(strongSelf.currentPerson.toneDeafAppId) {
                                albarr.append("\(strongSelf.currentPerson.toneDeafAppId)")
                                album.allArtists = albarr
                            }
                        } else {
                            album.allArtists = ["\(strongSelf.currentPerson.toneDeafAppId)"]
                        }
                        if !strongSelf.albumFeaturedArtistArr.contains(album.toneDeafAppId) {
                            strongSelf.albumFeaturedArtistArr.append(album.toneDeafAppId)
                        }
                    } else {
                        if let dex = album.allArtists?.firstIndex(of: "\(strongSelf.currentPerson.toneDeafAppId)")
                        {
                            album.allArtists!.remove(at: Int(dex))
                        }
                        if let dex = album.mainArtist.firstIndex(of: "\(strongSelf.currentPerson.toneDeafAppId)")
                        {
                            album.mainArtist.remove(at: Int(dex))
                        }
                    }
                    if arr.contains("Producer") {
                        if !album.producers.contains(strongSelf.currentPerson.toneDeafAppId) {
                            album.producers.append("\(strongSelf.currentPerson.toneDeafAppId)")
                        }
                    } else {
                        if let dex = album.producers.firstIndex(of: "\(strongSelf.currentPerson.toneDeafAppId)")
                        {
                            album.producers.remove(at: Int(dex))
                        }
                    }
                    if arr.contains("Writer") {
                        if var albarr = album.writers as? [String] {
                            if !albarr.contains(strongSelf.currentPerson.toneDeafAppId) {
                                albarr.append("\(strongSelf.currentPerson.toneDeafAppId)")
                                album.writers = albarr
                            }
                        } else {
                            album.writers = ["\(strongSelf.currentPerson.toneDeafAppId)"]
                        }
                    } else {
                        if let dex = album.writers?.firstIndex(of: "\(strongSelf.currentPerson.toneDeafAppId)")
                        {
                            album.writers!.remove(at: Int(dex))
                        }
                    }
                    if arr.contains("Mix Engineer") {
                        if var albarr = album.mixEngineers as? [String] {
                            if !albarr.contains(strongSelf.currentPerson.toneDeafAppId) {
                                albarr.append("\(strongSelf.currentPerson.toneDeafAppId)")
                                album.mixEngineers = albarr
                            }
                        } else {
                            album.mixEngineers = ["\(strongSelf.currentPerson.toneDeafAppId)"]
                        }
                    } else {
                        if let dex = album.mixEngineers?.firstIndex(of: "\(strongSelf.currentPerson.toneDeafAppId)")
                        {
                            album.mixEngineers!.remove(at: Int(dex))
                        }
                    }
                    if arr.contains("Mastering Engineer") {
                        if var albarr = album.masteringEngineers as? [String] {
                            if !albarr.contains(strongSelf.currentPerson.toneDeafAppId) {
                                albarr.append("\(strongSelf.currentPerson.toneDeafAppId)")
                                album.masteringEngineers = albarr
                            }
                        } else {
                            album.masteringEngineers = ["\(strongSelf.currentPerson.toneDeafAppId)"]
                        }
                    } else {
                        if let dex = album.masteringEngineers?.firstIndex(of: "\(strongSelf.currentPerson.toneDeafAppId)")
                        {
                            album.masteringEngineers!.remove(at: Int(dex))
                        }
                    }
                    if arr.contains("Recording Engineer") {
                        if var albarr = album.recordingEngineers as? [String] {
                            if !albarr.contains(strongSelf.currentPerson.toneDeafAppId) {
                                albarr.append("\(strongSelf.currentPerson.toneDeafAppId)")
                                album.recordingEngineers = albarr
                            }
                        } else {
                            album.recordingEngineers = ["\(strongSelf.currentPerson.toneDeafAppId)"]
                        }
                    } else {
                        if let dex = album.recordingEngineers?.firstIndex(of: "\(strongSelf.currentPerson.toneDeafAppId)")
                        {
                            album.recordingEngineers!.remove(at: Int(dex))
                        }
                    }
                    
                    if !strongSelf.personAlbumsArr.contains(album) {
                        strongSelf.personAlbumsArr.append(album)
                    } else {
                        let dex = strongSelf.personAlbumsArr.firstIndex(of: album)
                        let firstalb = strongSelf.personAlbumsArr[dex!]
                        firstalb.mainArtist = Array(GlobalFunctions.shared.combine( album.mainArtist, firstalb.mainArtist))
                        firstalb.allArtists = Array(GlobalFunctions.shared.combine( album.allArtists, firstalb.allArtists))
                        firstalb.producers = Array(GlobalFunctions.shared.combine( album.producers, firstalb.producers))
                        firstalb.writers = Array(GlobalFunctions.shared.combine( album.writers, firstalb.writers))
                        firstalb.mixEngineers = Array(GlobalFunctions.shared.combine( album.mixEngineers, firstalb.mixEngineers))
                        firstalb.masteringEngineers = Array(GlobalFunctions.shared.combine( album.masteringEngineers, firstalb.masteringEngineers))
                        firstalb.recordingEngineers = Array(GlobalFunctions.shared.combine( album.recordingEngineers, firstalb.recordingEngineers))
                    }
                    count+=1
                    if count == songAlbums.count {
                        if strongSelf.currentPerson.albums == nil {
                            strongSelf.currentPerson.albums = ["\(album.toneDeafAppId)"]
                        } else {
                            if !strongSelf.currentPerson.albums!.contains(album.toneDeafAppId) {
                                strongSelf.currentPerson.albums!.append("\(album.toneDeafAppId)")
                            }
                        }
                        
                        DispatchQueue.main.async {[weak self]  in
                            guard let strongSelf = self else {return}
                            strongSelf.personAlbumsArr.sort(by: {$0.name < $1.name})
                            strongSelf.personAlbumsTableView.reloadData()
                            strongSelf.personAlbumsHeightConstraint.constant = CGFloat(50*(strongSelf.personAlbumsArr.count))
                        }
                    }
                })
            }
        }
        
    }
    
    func beatAdded(_ beat: BeatData) {
        let selectbeatrole = beat
        
        
        if !personBeatsArr.contains(selectbeatrole) {
            personBeatsArr.append(selectbeatrole)
        } else {
            let dex = personBeatsArr.firstIndex(of: selectbeatrole)
            personBeatsArr[dex!] = selectbeatrole
        }
        
        if currentPerson.beats == nil {
            currentPerson.beats = ["\(selectbeatrole.toneDeafAppId)"]
        } else {
            if !currentPerson.beats!.contains(selectbeatrole.toneDeafAppId) {
                currentPerson.beats!.append("\(selectbeatrole.toneDeafAppId)")
            }
        }
        DispatchQueue.main.async {[weak self]  in
            guard let strongSelf = self else {return}
            strongSelf.personBeatsArr.sort(by: {$0.name < $1.name})
            strongSelf.personBeatsTableView.reloadData()
            strongSelf.personBeatsHeightConstraint.constant = CGFloat(50*(strongSelf.personBeatsArr.count))
        }
    }
    
    @IBAction func addBeatTapped(_ sender: Any) {
        arr = "beat"
        prevPage = "editPerson"
        performSegue(withIdentifier: "editPersonToTonesPick", sender: nil)
    }
    
    //MARK: - Status Control
    @IBAction func spotifyStatusChanged(_ sender: Any) {
        if spotifyStatusControl.selectedSegmentIndex == 0 {
            NotificationCenter.default.post(name: adminDashboardStartSpinnerNotify, object: nil)
            spotifyStatusControl.selectedSegmentTintColor = .systemGreen
            currentPerson.spotify?.isActive = true
            GlobalFunctions.shared.verifyUrl(urlString: currentPerson.spotify!.url, completion: {[weak self] validity in
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
                    strongSelf.currentPerson.spotify?.isActive = false
                }
            })
        } else {
            spotifyStatusControl.selectedSegmentTintColor = Constants.Colors.redApp
            currentPerson.spotify?.isActive = false
        }
    }
    
    @IBAction func appleMusicStatusChanged(_ sender: Any) {
        if appleMusicStatusControl.selectedSegmentIndex == 0 {
            NotificationCenter.default.post(name: adminDashboardStartSpinnerNotify, object: nil)
            appleMusicStatusControl.selectedSegmentTintColor = .systemGreen
            currentPerson.apple?.isActive = true
            GlobalFunctions.shared.verifyUrl(urlString: currentPerson.apple!.url, completion: {[weak self] validity in
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
                    strongSelf.currentPerson.apple?.isActive = false
                }
            })
        } else {
            appleMusicStatusControl.selectedSegmentTintColor = Constants.Colors.redApp
            currentPerson.apple?.isActive = false
        }
    }
    
    @IBAction func youtubeStatusChanged(_ sender: Any) {
        if youtubeStatusControl.selectedSegmentIndex == 0 {
                NotificationCenter.default.post(name: adminDashboardStartSpinnerNotify, object: nil)
                youtubeStatusControl.selectedSegmentTintColor = .systemGreen
                currentPerson.youtube?.isActive = true
                GlobalFunctions.shared.verifyUrl(urlString: currentPerson.youtube!.url, completion: {[weak self] validity in
                    guard let strongSelf = self else {return}
                    DispatchQueue.main.async {
                        NotificationCenter.default.post(name: adminDashboardStopSpinnerNotify, object: nil)
                    }
                    if !validity {
                        mediumImpactGenerator.impactOccurred()
                        DispatchQueue.main.async {
                            Utilities.showError2("Url invalid.", actionText: "OK")
                            strongSelf.youtubeStatusControl.selectedSegmentIndex = 1
                            strongSelf.youtubeStatusControl.selectedSegmentTintColor = Constants.Colors.redApp
                        }
                        strongSelf.currentPerson.youtube?.isActive = false
                    }
                })
        } else {
            youtubeStatusControl.selectedSegmentTintColor = Constants.Colors.redApp
            currentPerson.youtube?.isActive = false
        }
    }
    
    @IBAction func soundcloudStatusChanged(_ sender: Any) {
        if soundcloudStatusControl.selectedSegmentIndex == 0 {
            NotificationCenter.default.post(name: adminDashboardStartSpinnerNotify, object: nil)
            soundcloudStatusControl.selectedSegmentTintColor = .systemGreen
            currentPerson.soundcloud?.isActive = true
            GlobalFunctions.shared.verifyUrl(urlString: currentPerson.soundcloud!.url, completion: {[weak self] validity in
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
                    strongSelf.currentPerson.soundcloud?.isActive = false
                }
            })
        } else {
            soundcloudStatusControl.selectedSegmentTintColor = Constants.Colors.redApp
            currentPerson.soundcloud?.isActive = false
        }
    }
    
    @IBAction func youtubeMusicStatusChanged(_ sender: Any) {
        if youtubeMusicStatusControl.selectedSegmentIndex == 0 {
            NotificationCenter.default.post(name: adminDashboardStartSpinnerNotify, object: nil)
            youtubeMusicStatusControl.selectedSegmentTintColor = .systemGreen
            currentPerson.youtubeMusic?.isActive = true
            GlobalFunctions.shared.verifyUrl(urlString: currentPerson.youtubeMusic!.url, completion: {[weak self] validity in
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
                    strongSelf.currentPerson.youtubeMusic?.isActive = false
                }
            })
        } else {
            youtubeMusicStatusControl.selectedSegmentTintColor = Constants.Colors.redApp
            currentPerson.youtubeMusic?.isActive = false
        }
    }
    
    @IBAction func amazonStatusChanged(_ sender: Any) {
        if amazonStatusControl.selectedSegmentIndex == 0 {
            NotificationCenter.default.post(name: adminDashboardStartSpinnerNotify, object: nil)
            amazonStatusControl.selectedSegmentTintColor = .systemGreen
            currentPerson.amazon?.isActive = true
//            boolDict["amazon"] = true
            GlobalFunctions.shared.verifyUrl(urlString: currentPerson.amazon!.url, completion: {[weak self] validity in
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
                    strongSelf.currentPerson.amazon?.isActive = false
//                    strongSelf.boolDict["amazon"] = false
                }
            })
        } else {
            amazonStatusControl.selectedSegmentTintColor = Constants.Colors.redApp
            currentPerson.amazon?.isActive = false
//            boolDict["amazon"] = false
        }
    }
    
    @IBAction func tidalStatusChanged(_ sender: Any) {
        if tidalStatusControl.selectedSegmentIndex == 0 {
            NotificationCenter.default.post(name: adminDashboardStartSpinnerNotify, object: nil)
            tidalStatusControl.selectedSegmentTintColor = .systemGreen
            currentPerson.tidal?.isActive = true
            GlobalFunctions.shared.verifyUrl(urlString: currentPerson.tidal!.url, completion: {[weak self] validity in
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
                    strongSelf.currentPerson.tidal?.isActive = false
                }
            })
        } else {
            tidalStatusControl.selectedSegmentTintColor = Constants.Colors.redApp
            currentPerson.tidal?.isActive = false
        }
    }
    
    @IBAction func napsterStatusChanged(_ sender: Any) {
        if napsterStatusControl.selectedSegmentIndex == 0 {
            NotificationCenter.default.post(name: adminDashboardStartSpinnerNotify, object: nil)
            napsterStatusControl.selectedSegmentTintColor = .systemGreen
            currentPerson.napster?.isActive = true
            GlobalFunctions.shared.verifyUrl(urlString: currentPerson.napster!.url, completion: {[weak self] validity in
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
                    strongSelf.currentPerson.napster?.isActive = false
                }
            })
        } else {
            napsterStatusControl.selectedSegmentTintColor = Constants.Colors.redApp
            currentPerson.napster?.isActive = false
        }
    }
    
    @IBAction func spinrillaStatusChanged(_ sender: Any) {
        if spinrillaStatusControl.selectedSegmentIndex == 0 {
            NotificationCenter.default.post(name: adminDashboardStartSpinnerNotify, object: nil)
            spinrillaStatusControl.selectedSegmentTintColor = .systemGreen
            currentPerson.spinrilla?.isActive = true
            GlobalFunctions.shared.verifyUrl(urlString: currentPerson.spinrilla!.url, completion: {[weak self] validity in
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
                    strongSelf.currentPerson.spinrilla?.isActive = false
                }
            })
        } else {
            spinrillaStatusControl.selectedSegmentTintColor = Constants.Colors.redApp
            currentPerson.spinrilla?.isActive = false
        }
    }
    
    @IBAction func instagramStatusChanged(_ sender: Any) {
        if instagramStatusControl.selectedSegmentIndex == 0 {
            NotificationCenter.default.post(name: adminDashboardStartSpinnerNotify, object: nil)
            instagramStatusControl.selectedSegmentTintColor = .systemGreen
            currentPerson.instagram?.isActive = true
            GlobalFunctions.shared.verifyUrl(urlString: currentPerson.instagram!.url, completion: {[weak self] validity in
                guard let strongSelf = self else {return}
                DispatchQueue.main.async {
                    NotificationCenter.default.post(name: adminDashboardStopSpinnerNotify, object: nil)
                }
                if !validity {
                    mediumImpactGenerator.impactOccurred()
                    DispatchQueue.main.async {
                        Utilities.showError2("Url invalid.", actionText: "OK")
                        strongSelf.instagramStatusControl.selectedSegmentIndex = 1
                        strongSelf.instagramStatusControl.selectedSegmentTintColor = Constants.Colors.redApp
                    }
                    strongSelf.currentPerson.instagram?.isActive = false
                }
            })
        } else {
            instagramStatusControl.selectedSegmentTintColor = Constants.Colors.redApp
            currentPerson.instagram?.isActive = false
        }
    }
    
    @IBAction func twitterStatusChanged(_ sender: Any) {
        if twitterStatusControl.selectedSegmentIndex == 0 {
            NotificationCenter.default.post(name: adminDashboardStartSpinnerNotify, object: nil)
            twitterStatusControl.selectedSegmentTintColor = .systemGreen
            currentPerson.twitter?.isActive = true
            GlobalFunctions.shared.verifyUrl(urlString: currentPerson.apple!.url, completion: {[weak self] validity in
                guard let strongSelf = self else {return}
                DispatchQueue.main.async {
                    NotificationCenter.default.post(name: adminDashboardStopSpinnerNotify, object: nil)
                }
                if !validity {
                    mediumImpactGenerator.impactOccurred()
                    DispatchQueue.main.async {
                        Utilities.showError2("Url invalid.", actionText: "OK")
                        strongSelf.twitterStatusControl.selectedSegmentIndex = 1
                        strongSelf.twitterStatusControl.selectedSegmentTintColor = Constants.Colors.redApp
                    }
                    strongSelf.currentPerson.twitter?.isActive = false
                }
            })
        } else {
            twitterStatusControl.selectedSegmentTintColor = Constants.Colors.redApp
            currentPerson.twitter?.isActive = false
        }
    }
    
    @IBAction func deezerStatusChanged(_ sender: Any) {
        if deezerStatusControl.selectedSegmentIndex == 0 {
            NotificationCenter.default.post(name: adminDashboardStartSpinnerNotify, object: nil)
            deezerStatusControl.selectedSegmentTintColor = .systemGreen
            currentPerson.deezer?.isActive = true
            GlobalFunctions.shared.verifyUrl(urlString: currentPerson.deezer!.url, completion: {[weak self] validity in
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
                    strongSelf.currentPerson.deezer?.isActive = false
                }
            })
        } else {
            deezerStatusControl.selectedSegmentTintColor = Constants.Colors.redApp
            currentPerson.deezer?.isActive = false
        }
    }
    
    @IBAction func facebookStatusChanged(_ sender: Any) {
        if facebookStatusControl.selectedSegmentIndex == 0 {
                NotificationCenter.default.post(name: adminDashboardStartSpinnerNotify, object: nil)
                facebookStatusControl.selectedSegmentTintColor = .systemGreen
                currentPerson.facebook?.isActive = true
                GlobalFunctions.shared.verifyUrl(urlString: currentPerson.facebook!.url, completion: {[weak self] validity in
                    guard let strongSelf = self else {return}
                    DispatchQueue.main.async {
                        NotificationCenter.default.post(name: adminDashboardStopSpinnerNotify, object: nil)
                    }
                    if !validity {
                        mediumImpactGenerator.impactOccurred()
                        DispatchQueue.main.async {
                            Utilities.showError2("Url invalid.", actionText: "OK")
                            strongSelf.facebookStatusControl.selectedSegmentIndex = 1
                            strongSelf.facebookStatusControl.selectedSegmentTintColor = Constants.Colors.redApp
                        }
                        strongSelf.currentPerson.facebook?.isActive = false
                    }
                })
        } else {
            facebookStatusControl.selectedSegmentTintColor = Constants.Colors.redApp
            currentPerson.facebook?.isActive = false
        }
    }
    
    @IBAction func tikTokStatusChanged(_ sender: Any) {
        if tiktokStatusControl.selectedSegmentIndex == 0 {
                NotificationCenter.default.post(name: adminDashboardStartSpinnerNotify, object: nil)
                tiktokStatusControl.selectedSegmentTintColor = .systemGreen
                currentPerson.tikTok?.isActive = true
                GlobalFunctions.shared.verifyUrl(urlString: currentPerson.tikTok!.url, completion: {[weak self] validity in
                    guard let strongSelf = self else {return}
                    DispatchQueue.main.async {
                        NotificationCenter.default.post(name: adminDashboardStopSpinnerNotify, object: nil)
                    }
                    if !validity {
                        mediumImpactGenerator.impactOccurred()
                        DispatchQueue.main.async {
                            Utilities.showError2("Url invalid.", actionText: "OK")
                            strongSelf.tiktokStatusControl.selectedSegmentIndex = 1
                            strongSelf.tiktokStatusControl.selectedSegmentTintColor = Constants.Colors.redApp
                        }
                        strongSelf.currentPerson.tikTok?.isActive = false
                    }
                })
        } else {
            tiktokStatusControl.selectedSegmentTintColor = Constants.Colors.redApp
            currentPerson.tikTok?.isActive = false
        }
    }
    
    @IBAction func changeVerificationLevelTapped(_ sender: Any) {
        let alertC = UIAlertController(title: "Change Verification Level",
                                                message: "Select a Level.",
                                                preferredStyle: .alert)
        let aAction = UIAlertAction(title: "A Level", style: .default, handler: {[weak self] _ in
            guard let strongSelf = self else {return}
            strongSelf.currentPerson.verificationLevel = "A"
            strongSelf.verificationLabel.text = String(strongSelf.currentPerson.verificationLevel!)
            strongSelf.verificationLabel.textColor = .green
                alertC.dismiss(animated: true, completion: nil)
        })
        let bAction = UIAlertAction(title: "B Level", style: .default, handler: {[weak self] _ in
            guard let strongSelf = self else {return}
            strongSelf.currentPerson.verificationLevel = "B"
            strongSelf.verificationLabel.text = String(strongSelf.currentPerson.verificationLevel!)
            strongSelf.verificationLabel.textColor = .green
                alertC.dismiss(animated: true, completion: nil)
        })
        let cAction = UIAlertAction(title: "C Level", style: .default, handler: {[weak self] _ in
            guard let strongSelf = self else {return}
            strongSelf.currentPerson.verificationLevel = "C"
            strongSelf.verificationLabel.text = String(strongSelf.currentPerson.verificationLevel!)
            strongSelf.verificationLabel.textColor = .green
                alertC.dismiss(animated: true, completion: nil)
        })
        let uAction = UIAlertAction(title: "U Level", style: .default, handler: {[weak self] _ in
            guard let strongSelf = self else {return}
            strongSelf.currentPerson.verificationLevel = "U"
            strongSelf.verificationLabel.text = String(strongSelf.currentPerson.verificationLevel!)
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
    
    @IBAction func industryCertifiedChanged(_ sender: Any) {
        if industryCertifiedControl.selectedSegmentIndex == 0 {
            industryCertifiedControl.selectedSegmentTintColor = .systemGreen
            currentPerson.industryCerified = true
        } else {
            industryCertifiedControl.selectedSegmentTintColor = Constants.Colors.redApp
            currentPerson.industryCerified = false
        }
    }
    
    @IBAction func personStatusChanged(_ sender: Any) {
        if personStatusControl.selectedSegmentIndex == 0 {
            personStatusControl.selectedSegmentTintColor = .systemGreen
            currentPerson.isActive = true
        } else {
            personStatusControl.selectedSegmentTintColor = Constants.Colors.redApp
            currentPerson.isActive = false
        }
    }
    
    //MARK: - Update Tapped
    @IBAction func updatePersonTapped(_ sender: Any) {
        let newDict = [
            "spotify":currentPerson.spotify?.isActive,
            "apple":currentPerson.apple?.isActive,
            "youtube":currentPerson.youtube?.isActive,
            "soundcloud":currentPerson.soundcloud?.isActive,
            "youtubemusic":currentPerson.youtubeMusic?.isActive,
            "amazon":currentPerson.amazon?.isActive,
            "deezer":currentPerson.deezer?.isActive,
            "tidal":currentPerson.tidal?.isActive,
            "napster":currentPerson.napster?.isActive,
            "spinrilla":currentPerson.spinrilla?.isActive,
            "instagram":currentPerson.instagram?.isActive,
            "twitter":currentPerson.twitter?.isActive,
            "facebook":currentPerson.facebook?.isActive,
            "tiktok":currentPerson.tikTok?.isActive
        ]
        let newURLDict = [
            "spotify":currentPerson.spotify?.url,
            "apple":currentPerson.apple?.url,
            "youtube":currentPerson.youtube?.url,
            "soundcloud":currentPerson.soundcloud?.url,
            "youtubemusic":currentPerson.youtubeMusic?.url,
            "amazon":currentPerson.amazon?.url,
            "deezer":currentPerson.deezer?.url,
            "tidal":currentPerson.tidal?.url,
            "napster":currentPerson.napster?.url,
            "spinrilla":currentPerson.spinrilla?.url,
            "instagram":currentPerson.instagram?.url,
            "twitter":currentPerson.twitter?.url,
            "facebook":currentPerson.facebook?.url,
            "tiktok":currentPerson.tikTok?.url
        ]
        
        if rolesDict.isEmpty {
            rolesDict = nil
        }
        
        if let currole = currentPerson.roles as? NSDictionary {
            var rolesDic = currole.mutableCopy() as! NSMutableDictionary
            if let arr = rolesDic["Videographer"] as? [String] {
                rolesDic["Videographer"] = arr.sorted()
            }
            if let arr = rolesDic["Artist"] as? [String] {
                rolesDic["Artist"] = arr.sorted()
            }
            if let arr = rolesDic["Producer"] as? [String] {
                rolesDic["Producer"] = arr.sorted()
            }
            if let arr = rolesDic["Writer"] as? [String] {
                rolesDic["Writer"] = arr.sorted()
            }
            if let eng = rolesDic["Engineer"] as? NSDictionary {
                var dicteng = eng.mutableCopy() as! NSMutableDictionary
                if let arr = dicteng["Mix Engineer"] as? [String] {
                    dicteng["Mix Engineer"] = arr.sorted()
                }
                if let arr = dicteng["Mastering Engineer"] as? [String] {
                    dicteng["Mastering Engineer"] = arr.sorted()
                }
                if let arr = dicteng["Recording Engineer"] as? [String] {
                    dicteng["Recording Engineer"] = arr.sorted()
                }
                rolesDic["Engineer"] = dicteng
                
            }
            currentPerson.roles = rolesDic
        }
//        print(String(data: try! JSONSerialization.data(withJSONObject: newDict, options: .prettyPrinted), encoding: .utf8)!)
//        print(String(data: try! JSONSerialization.data(withJSONObject: boolDict, options: .prettyPrinted), encoding: .utf8)!)
//        print(String(data: try! JSONSerialization.data(withJSONObject: currentPerson.roles!, options: .prettyPrinted), encoding: .utf8)!)
//        print(String(data: try! JSONSerialization.data(withJSONObject: rolesDict!, options: .prettyPrinted), encoding: .utf8)!)
        print(currentPerson == initialPerson, newDict == boolDict, newURLDict == urlDict, currentPerson.roles == ((rolesDict! as NSDictionary).mutableCopy() as! NSMutableDictionary), initalbumMainArtistArr == albumMainArtistArr, initalbumFeaturedArtistArr == albumFeaturedArtistArr, initvideoPersonArr == videoPersonArr)
//        print(currentPerson == initialPerson && newDict == boolDict && newURLDict == urlDict)
        
        //MARK: - Error Count
        errorCountForController = 0
        if !personSongsArr.isEmpty {
            for item in personSongsArr {
                if item.songArtist.isEmpty {
                    errorCountForController+=1
                }
                if item.songProducers.isEmpty {
                    errorCountForController+=1
                }
            }
        }
        if !personAlbumsArr.isEmpty {
            for item in personAlbumsArr {
                if item.mainArtist.isEmpty {
                    errorCountForController+=1
                }
                if item.producers.isEmpty {
                    errorCountForController+=1
                }
            }
        }
        if !personInstrumentalsArr.isEmpty {
            for item in personInstrumentalsArr {
                if item.producers.isEmpty {
                    errorCountForController+=1
                }
            }
        }
        if !personBeatsArr.isEmpty {
            if currentPerson.legalName == nil {
                errorCountForController+=1
            }
        }
        
        guard errorCountForController == 0 else {
            mediumImpactGenerator.impactOccurred()
            Utilities.showError2("Please correct all errors before proceeding.", actionText: "OK")
            return
        }
        
        if currentPerson.legalName == nil && !personBeatsArr.isEmpty {
            mediumImpactGenerator.impactOccurred()
            Utilities.showError2("Legal name required to add beats.", actionText: "OK")
            return
        }
        
        if currentPerson == initialPerson && newDict == boolDict && newURLDict == urlDict && currentPerson.roles == ((rolesDict! as NSDictionary).mutableCopy() as! NSMutableDictionary) && initalbumMainArtistArr == albumMainArtistArr && initalbumFeaturedArtistArr == albumFeaturedArtistArr && initvideoPersonArr == videoPersonArr {
            mediumImpactGenerator.impactOccurred()
            Utilities.showError2("Person already up to date.", actionText: "OK")
            return
        }
        
        //MARK: - Continue To Upload
        alertView = UIAlertController(title: "Updating \(personName.text!)", message: "Preparing...", preferredStyle: .alert)
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
        
        let queue = DispatchQueue(label: "myhjvkheditingQpersonsssseue")
        let group = DispatchGroup()
        let array = [2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27]
        totalProgress+=Float(array.count)
        for i in array {
            group.enter()
            queue.async { [weak self] in
                guard let strongSelf = self else {return}
                switch i {
                case 2:
                    strongSelf.processImages(dict: dict, completion: {err in
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
                    strongSelf.processLegalName(completion: {err in
                        if let error = err {
                            mediumImpactGenerator.impactOccurred()
                            DispatchQueue.main.async {
                                Utilities.showError2("Legal Name Proccessing Failed: \(error)", actionText: "OK")
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
                    strongSelf.processAlternateNames(completion: {err in
                        if let error = err {
                            mediumImpactGenerator.impactOccurred()
                            DispatchQueue.main.async {
                                Utilities.showError2("Alt Name Proccessing Failed: \(error)", actionText: "OK")
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
                    strongSelf.processMainRole(completion: {err in
                        if let error = err {
                            mediumImpactGenerator.impactOccurred()
                            DispatchQueue.main.async {
                                Utilities.showError2("Main Role Proccessing Failed: \(error)", actionText: "OK")
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
                    strongSelf.processYoutubeURL(dict: dict, urldict: urldict, completion: {err in
                        if let errors = err {
                            mediumImpactGenerator.impactOccurred()
                            for error in errors {
                                DispatchQueue.main.async {
                                    Utilities.showError2("Youtube Proccessing Failed: \(error)", actionText: "OK")
                                }
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
                    strongSelf.processInstagramURL(dict: dict, urldict: urldict, completion: {err in
                        if let errors = err {
                            mediumImpactGenerator.impactOccurred()
                            for error in errors {
                                DispatchQueue.main.async {
                                    Utilities.showError2("Instagram Proccessing Failed: \(error)", actionText: "OK")
                                }
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
                    strongSelf.processTwitterURL(dict: dict, urldict: urldict, completion: {err in
                        if let errors = err {
                            mediumImpactGenerator.impactOccurred()
                            for error in errors {
                                DispatchQueue.main.async {
                                    Utilities.showError2("Twitter Proccessing Failed: \(error)", actionText: "OK")
                                }
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
                    strongSelf.processFacebookURL(dict: dict, urldict: urldict, completion: {err in
                        if let errors = err {
                            mediumImpactGenerator.impactOccurred()
                            for error in errors {
                                DispatchQueue.main.async {
                                    Utilities.showError2("Facebook Proccessing Failed: \(error)", actionText: "OK")
                                }
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
                    strongSelf.processTikTokURL(dict: dict, urldict: urldict, completion: {err in
                        if let errors = err {
                            mediumImpactGenerator.impactOccurred()
                            for error in errors {
                                DispatchQueue.main.async {
                                    Utilities.showError2("Tik Tok Proccessing Failed: \(error)", actionText: "OK")
                                }
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
                    strongSelf.processSongs(completion: {err in
                        if let errors = err {
                            mediumImpactGenerator.impactOccurred()
                            for error in errors {
                                DispatchQueue.main.async {
                                    Utilities.showError2("Songs Proccessing Failed: \(error)", actionText: "OK")
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
                    strongSelf.processBeats(completion: {err in
                        if let errors = err {
                            mediumImpactGenerator.impactOccurred()
                            for error in errors {
                                DispatchQueue.main.async {
                                    Utilities.showError2("Beats Proccessing Failed: \(error)", actionText: "OK")
                                }
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
                                Utilities.showError2("Status Proccessing Failed: \(error)", actionText: "OK")
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
                                Utilities.showError2("Status Proccessing Failed: \(error)", actionText: "OK")
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
                default:
                    print("Edit Person error")
                }
            }
        }
        
        group.notify(queue: DispatchQueue.main) { [weak self] in
            guard let strongSelf = self else {return}
            if strongSelf.uploadCompletionStatus1 == false || strongSelf.uploadCompletionStatus2 == false || strongSelf.uploadCompletionStatus3 == false || strongSelf.uploadCompletionStatus4 == false || strongSelf.uploadCompletionStatus5 == false || strongSelf.uploadCompletionStatus6 == false || strongSelf.uploadCompletionStatus7 == false || strongSelf.uploadCompletionStatus8 == false || strongSelf.uploadCompletionStatus9 == false || strongSelf.uploadCompletionStatus10 == false || strongSelf.uploadCompletionStatus11 == false || strongSelf.uploadCompletionStatus12 == false || strongSelf.uploadCompletionStatus13 == false || strongSelf.uploadCompletionStatus14 == false || strongSelf.uploadCompletionStatus15 == false || strongSelf.uploadCompletionStatus16 == false || strongSelf.uploadCompletionStatus17 == false || strongSelf.uploadCompletionStatus18 == false || strongSelf.uploadCompletionStatus19 == false || strongSelf.uploadCompletionStatus20 == false || strongSelf.uploadCompletionStatus21 == false || strongSelf.uploadCompletionStatus22 == false || strongSelf.uploadCompletionStatus23 == false || strongSelf.uploadCompletionStatus24 == false || strongSelf.uploadCompletionStatus25 == false || strongSelf.uploadCompletionStatus26 == false || strongSelf.uploadCompletionStatus27 == false {
                strongSelf.alertView.dismiss(animated: true, completion: nil)
                
                EditPersonHelper.shared.cancelUpdate(initialPerson: strongSelf.initialPerson,currentPerson: strongSelf.currentPerson, initialStatus: strongSelf.boolDict as NSDictionary, currentStatus: dict, initialURL: strongSelf.urlDict as NSDictionary, currentURL: urldict , completion: { err in
                    strongSelf.alertView.dismiss(animated: true, completion: nil)
                    if let error = err {
                        DispatchQueue.main.async {
                            Utilities.showError2("Cancellation of Person Edit Failed, check database now: \(error)", actionText: "OK")
                        }
                        _ = strongSelf.navigationController?.popViewController(animated: true)
                    }
                    return
                })
            } else {
                print("📗 Person data updated to database successfully.")
                strongSelf.alertView.dismiss(animated: true, completion: {
                    Utilities.successBarBanner("Update successful.")
                    _ = strongSelf.navigationController?.popViewController(animated: true)
                })
            }
        }
    }
    
    func processImages(dict:NSDictionary, completion: @escaping ((Error?) -> Void)) {
        guard currentPerson.manualImageURL != initialPerson.manualImageURL else {
            
            completion(nil)
            return
        }
        if currentPerson.manualImageURL != nil && currentPerson.manualImageURL != "" {
            guard newImage != nil else {
                completion(PersonEditorError.imageUpdateError("Image must not be empty"))
                return
            }
        }
        EditPersonHelper.shared.processImage(initialPerson: initialPerson, currentPerson: currentPerson, image: newImage, completion: {[weak self] err in
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
        guard currentPerson.name != initialPerson.name else {
            completion(nil)
            return
        }
        EditPersonHelper.shared.processName(initialPerson: initialPerson,currentPerson: currentPerson, completion: {[weak self] err in
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
    
    func processAlternateNames(completion: @escaping ((Error?) -> Void)) {
        guard currentPerson.alternateNames != initialPerson.alternateNames else {
            completion(nil)
            return
        }
        EditPersonHelper.shared.processAlternateNames(initialPerson: initialPerson,currentPerson: currentPerson, completion: {[weak self] err in
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
    
    func processLegalName(completion: @escaping ((Error?) -> Void)) {
        guard currentPerson.legalName != initialPerson.legalName else {
            completion(nil)
            return
        }
        EditPersonHelper.shared.processLegalName(initialPerson: initialPerson,currentPerson: currentPerson, completion: {[weak self] err in
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
    
    func processMainRole(completion: @escaping ((Error?) -> Void)) {
        guard currentPerson.mainRole != initialPerson.mainRole else {
            completion(nil)
            return
        }
        EditPersonHelper.shared.processMainRole(initialPerson: initialPerson,currentPerson: currentPerson, completion: {[weak self] err in
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
        
        guard currentPerson.spotify?.url != initialPerson.spotify?.url || (dict["spotify"] as? Bool) != boolDict["spotify"] || urlDict["spotify"] != (urldict["spotify"] as? String) else {
            completion(nil)
            return
        }
        
        EditPersonHelper.shared.processSpotify(initialPerson: initialPerson,currentPerson: currentPerson, initialStatus: boolDict["spotify"] as? Bool, currentStatus: (dict["spotify"] as? Bool), initialURL: urlDict["spotify"] as? String, currentURL: (urldict["spotify"] as? String), completion: {[weak self] err in
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
        
        guard currentPerson.apple?.url != initialPerson.apple?.url || (dict["apple"] as? Bool) != boolDict["apple"] || urlDict["apple"] != (urldict["apple"] as? String) else {
            completion(nil)
            return
        }
        
        EditPersonHelper.shared.processAppleMusic(initialPerson: initialPerson,currentPerson: currentPerson, initialStatus: boolDict["apple"] as? Bool, currentStatus: (dict["apple"] as? Bool), initialURL: urlDict["apple"] as? String, currentURL: (urldict["apple"] as? String), completion: {[weak self] err in
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
    
    func processYoutubeURL(dict:NSDictionary, urldict:NSDictionary, completion: @escaping (([Error]?) -> Void)) {
        
        guard currentPerson.youtube?.url != initialPerson.youtube?.url || (dict["youtube"] as? Bool) != boolDict["youtube"] || urlDict["youtube"] != (urldict["youtube"] as? String) else {
            completion(nil)
            return
        }
        
        EditPersonHelper.shared.processYoutube(initialPerson: initialPerson,currentPerson: currentPerson, initialStatus: boolDict["youtube"] as? Bool, currentStatus: (dict["youtube"] as? Bool), initialURL: urlDict["youtube"] as? String, currentURL: (urldict["youtube"] as? String), completion: {[weak self] err in
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
        
        guard currentPerson.soundcloud?.url != initialPerson.soundcloud?.url || (dict["soundcloud"] as? Bool) != boolDict["soundcloud"] || urlDict["soundcloud"] != (urldict["soundcloud"] as? String) else {
            completion(nil)
            return
        }
        
        EditPersonHelper.shared.processSoundcloud(initialPerson: initialPerson,currentPerson: currentPerson, initialStatus: boolDict["soundcloud"] as? Bool, currentStatus: (dict["soundcloud"] as? Bool), initialURL: urlDict["soundcloud"] as? String, currentURL: (urldict["soundcloud"] as? String), completion: {[weak self] err in
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
        
        guard currentPerson.youtubeMusic?.url != initialPerson.youtubeMusic?.url || (dict["youtubemusic"] as? Bool) != boolDict["youtubemusic"] || urlDict["youtubemusic"] != (urldict["youtubemusic"] as? String) else {
            completion(nil)
            return
        }
        
        EditPersonHelper.shared.processYoutubeMusic(initialPerson: initialPerson,currentPerson: currentPerson, initialStatus: boolDict["youtubemusic"] as? Bool, currentStatus: (dict["youtubemusic"] as? Bool), initialURL: urlDict["youtubemusic"] as? String, currentURL: (urldict["youtubemusic"] as? String), completion: {[weak self] err in
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
        
        guard currentPerson.amazon?.url != initialPerson.amazon?.url || (dict["amazon"] as? Bool) != boolDict["amazon"] || urlDict["amazon"] != (urldict["amazon"] as? String) else {
            completion(nil)
            return
        }
        
        EditPersonHelper.shared.processAmazon(initialPerson: initialPerson,currentPerson: currentPerson, initialStatus: boolDict["amazon"] as? Bool, currentStatus: (dict["amazon"] as? Bool), initialURL: urlDict["amazon"] as? String, currentURL: (urldict["amazon"] as? String), completion: {[weak self] err in
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
        
        guard currentPerson.deezer?.url != initialPerson.deezer?.url || (dict["deezer"] as? Bool) != boolDict["deezer"] || urlDict["deezer"] != (urldict["deezer"] as? String) else {
            completion(nil)
            return
        }
        
        EditPersonHelper.shared.processDeezer(initialPerson: initialPerson,currentPerson: currentPerson, initialStatus: boolDict["deezer"] as? Bool, currentStatus: (dict["deezer"] as? Bool), initialURL: urlDict["deezer"] as? String, currentURL: (urldict["deezer"] as? String), completion: {[weak self] err in
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
        
        guard currentPerson.tidal?.url != initialPerson.tidal?.url || (dict["tidal"] as? Bool) != boolDict["tidal"] || urlDict["tidal"] != (urldict["tidal"] as? String) else {
            completion(nil)
            return
        }
        
        EditPersonHelper.shared.processTidal(initialPerson: initialPerson,currentPerson: currentPerson, initialStatus: boolDict["tidal"] as? Bool, currentStatus: (dict["tidal"] as? Bool), initialURL: urlDict["tidal"] as? String, currentURL: (urldict["tidal"] as? String), completion: {[weak self] err in
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
        
        guard currentPerson.napster?.url != initialPerson.napster?.url || (dict["napster"] as? Bool) != boolDict["napster"] || urlDict["napster"] != (urldict["napster"] as? String) else {
            completion(nil)
            return
        }
        
        EditPersonHelper.shared.processNapster(initialPerson: initialPerson,currentPerson: currentPerson, initialStatus: boolDict["napster"] as? Bool, currentStatus: (dict["napster"] as? Bool), initialURL: urlDict["napster"] as? String, currentURL: (urldict["napster"] as? String), completion: {[weak self] err in
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
        
        guard currentPerson.spinrilla?.url != initialPerson.spinrilla?.url || (dict["spinrilla"] as? Bool) != boolDict["spinrilla"] || urlDict["spinrilla"] != (urldict["spinrilla"] as? String) else {
            completion(nil)
            return
        }
        
        EditPersonHelper.shared.processSpinrilla(initialPerson: initialPerson,currentPerson: currentPerson, initialStatus: boolDict["spinrilla"] as? Bool, currentStatus: (dict["spinrilla"] as? Bool), initialURL: urlDict["spinrilla"] as? String, currentURL: (urldict["spinrilla"] as? String), completion: {[weak self] err in
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
    
    func processInstagramURL(dict:NSDictionary, urldict:NSDictionary, completion: @escaping (([Error]?) -> Void)) {
        
        guard currentPerson.instagram?.url != initialPerson.instagram?.url || (dict["instagram"] as? Bool) != boolDict["instagram"] || urlDict["instagram"] != (urldict["instagram"] as? String) else {
            completion(nil)
            return
        }
        
        EditPersonHelper.shared.processInstagram(initialPerson: initialPerson,currentPerson: currentPerson, initialStatus: boolDict["instagram"] as? Bool, currentStatus: (dict["instagram"] as? Bool), initialURL: urlDict["instagram"] as? String, currentURL: (urldict["instagram"] as? String), completion: {[weak self] err in
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
    
    func processTwitterURL(dict:NSDictionary, urldict:NSDictionary, completion: @escaping (([Error]?) -> Void)) {
        
        guard currentPerson.twitter?.url != initialPerson.twitter?.url || (dict["twitter"] as? Bool) != boolDict["twitter"] || urlDict["twitter"] != (urldict["twitter"] as? String) else {
            completion(nil)
            return
        }
        
        EditPersonHelper.shared.processTwitter(initialPerson: initialPerson,currentPerson: currentPerson, initialStatus: boolDict["twitter"] as? Bool, currentStatus: (dict["twitter"] as? Bool), initialURL: urlDict["twitter"] as? String, currentURL: (urldict["twitter"] as? String), completion: {[weak self] err in
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
    
    func processFacebookURL(dict:NSDictionary, urldict:NSDictionary, completion: @escaping (([Error]?) -> Void)) {
        
        guard currentPerson.facebook?.url != initialPerson.facebook?.url || (dict["facebook"] as? Bool) != boolDict["facebook"] || urlDict["facebook"] != (urldict["facebook"] as? String) else {
            completion(nil)
            return
        }
        
        EditPersonHelper.shared.processFacebook(initialPerson: initialPerson,currentPerson: currentPerson, initialStatus: boolDict["facebook"] as? Bool, currentStatus: (dict["facebook"] as? Bool), initialURL: urlDict["facebook"] as? String, currentURL: (urldict["facebook"] as? String), completion: {[weak self] err in
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
    
    func processTikTokURL(dict:NSDictionary, urldict:NSDictionary, completion: @escaping (([Error]?) -> Void)) {
        
        guard currentPerson.tikTok?.url != initialPerson.tikTok?.url || (dict["tiktok"] as? Bool) != boolDict["tiktok"] || urlDict["tiktok"] != (urldict["tiktok"] as? String) else {
            completion(nil)
            return
        }
        
        EditPersonHelper.shared.processTikTok(initialPerson: initialPerson,currentPerson: currentPerson, initialStatus: boolDict["tiktok"] as? Bool, currentStatus: (dict["tiktok"] as? Bool), initialURL: urlDict["tiktok"] as? String, currentURL: (urldict["tiktok"] as? String), completion: {[weak self] err in
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
        if currentPerson.songs == nil && initialPerson.songs == nil {
            completion(nil)
            return
        }
        if rolesDict == nil && currentPerson.roles == nil {
            completion(nil)
            return
        }
        var initRoles:NSMutableDictionary!
        if rolesDict == nil {
            initRoles = [:]
        } else {
            initRoles = (rolesDict as! NSDictionary).mutableCopy() as! NSMutableDictionary
        }
        if currentPerson.songs == initialPerson.songs && currentPerson.roles == initRoles {
            completion(nil)
            return
        }
    
        
        EditPersonHelper.shared.processSongs(initialPerson: initialPerson,currentPerson: currentPerson, initialRoles: initRoles, completion: {[weak self] err in
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
        if currentPerson.albums == nil && initialPerson.albums == nil {
            completion(nil)
            return
        }
        if rolesDict == nil && currentPerson.roles == nil {
            completion(nil)
            return
        }
        var initRoles:NSMutableDictionary!
        if rolesDict == nil {
            initRoles = [:]
        } else {
            initRoles = (rolesDict as! NSDictionary).mutableCopy() as! NSMutableDictionary
        }
        
        if currentPerson.albums == initialPerson.albums && currentPerson.roles == initRoles && initalbumMainArtistArr == albumMainArtistArr && initalbumFeaturedArtistArr == albumFeaturedArtistArr {
            completion(nil)
            return
        }
        
        EditPersonHelper.shared.processAlbums(initialPerson: initialPerson,currentPerson: currentPerson, initialRoles: initRoles, mainArtistArr: albumMainArtistArr, featArtistArr: albumFeaturedArtistArr, initmainArtistArr: initalbumMainArtistArr, initfeatArtistArr: initalbumFeaturedArtistArr, completion: {[weak self] err in
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
        if currentPerson.videos == nil && initialPerson.videos == nil {
            completion(nil)
            return
        }
        if rolesDict == nil && currentPerson.roles == nil {
            completion(nil)
            return
        }
        var initRoles:NSMutableDictionary!
        if rolesDict == nil {
            initRoles = [:]
        } else {
            initRoles = (rolesDict as! NSDictionary).mutableCopy() as! NSMutableDictionary
        }
        
        if currentPerson.videos == initialPerson.videos && currentPerson.roles == initRoles && videoPersonArr == initvideoPersonArr  {
            completion(nil)
            return
        }
        
        EditPersonHelper.shared.processVideos(initialPerson: initialPerson,currentPerson: currentPerson, initialRoles: initRoles, videoPersonsArr: videoPersonArr, initvideoPersonArr: initvideoPersonArr, completion: {[weak self] err in
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
        if currentPerson.instrumentals == nil && initialPerson.instrumentals == nil {
            completion(nil)
            return
        }
        if rolesDict == nil && currentPerson.roles == nil {
            completion(nil)
            return
        }
        var initRoles:NSMutableDictionary!
        if rolesDict == nil {
            initRoles = [:]
        } else {
            initRoles = (rolesDict as! NSDictionary).mutableCopy() as! NSMutableDictionary
        }
        if currentPerson.instrumentals == initialPerson.instrumentals && currentPerson.roles == initRoles {
            completion(nil)
            return
        }
    
        
        EditPersonHelper.shared.processInstrumentals(initialPerson: initialPerson,currentPerson: currentPerson, initialRoles: initRoles, completion: {[weak self] err in
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
    
    func processBeats(completion: @escaping (([Error]?) -> Void)) {
        if currentPerson.beats == nil && initialPerson.beats == nil {
            completion(nil)
            return
        }
        
        if currentPerson.beats == initialPerson.beats {
            completion(nil)
            return
        }
        
        EditPersonHelper.shared.processBeats(initialPerson: initialPerson, currentPerson: currentPerson, completion: {[weak self] err in
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
        guard currentPerson.verificationLevel != initialPerson.verificationLevel else {
            completion(nil)
            return
        }
        EditPersonHelper.shared.processVerificationLevel(initialPerson: initialPerson,currentPerson: currentPerson, completion: {[weak self] err in
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
        guard currentPerson.industryCerified != initialPerson.industryCerified else {
            completion(nil)
            return
        }
        EditPersonHelper.shared.processIndustryCertification(initialPerson: initialPerson,currentPerson: currentPerson, completion: {[weak self] err in
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
        guard currentPerson.isActive != initialPerson.isActive else {
            completion(nil)
            return
        }
        EditPersonHelper.shared.processStatus(initialPerson: initialPerson,currentPerson: currentPerson, completion: {[weak self] err in
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
        if segue.identifier == "editPersonToTonesPick" {
            if let viewController: SelectTonesPickItemViewController = segue.destination as? SelectTonesPickItemViewController {
                viewController.array = arr
                viewController.prevPage = prevPage
                if prevPage == "editPerson" {
                    switch arr {
                    case "video":
                        viewController.exeptions = personVideosArr
                        viewController.videosDelegate = self
                    case "album":
                        viewController.exeptions = personAlbumsArr
                        viewController.albumsDelegate = self
                    case "song":
                        viewController.exeptions = personSongsArr
                        viewController.songsDelegate = self
                    case "instrumental":
                        viewController.exeptions = personInstrumentalsArr
                        viewController.instrumentalsDelegate = self
                    case "beat":
                        viewController.exeptions = personBeatsArr
                        viewController.editPersonBeatsDelegate = self
                    default:
                        break
                    }
                }
                if prevPage == "editPersonAll" {
                    viewController.editPersonAllPersonsDelegate = self
                }
            }
        }
    }
    
    //MARK: - Keyboard Dismissals

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @objc func dismissKeyboard2() {
//        NotificationCenter.default.post(name: adminDashboardStopSpinnerNotify, object: nil)
        mainRoleLabel.textColor = .white
        personTikTokURL.textColor = .white
        personTwitterURL.textColor = .white
        personInstagramURL.textColor = .white
        personSpinrillaURL.textColor = .white
        personNapsterURL.textColor = .white
        personTidalURL.textColor = .white
        personDeezerURL.textColor = .white
        personAmazonURL.textColor = .white
        personYoutubeMusicURL.textColor = .white
        personSoundcloudURL.textColor = .white
        personYoutubeChannelURL.textColor = .white
        personAppleMusicURL.textColor = .white
        personSpotifyURL.textColor = .white
        personLegalName.textColor = .white
        personName.textColor = .white
        personImageURL.textColor = .white
        verificationLabel.textColor = .white
        setUpPage()
        view.endEditing(true)
    }
    
    @objc func dismissKeyboard3() {
        view.endEditing(true)
        mainRoleLabel.text = pickerrole
        mainRoleLabel.textColor = .green
        currentPerson.mainRole = pickerrole
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

extension EditPersonViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
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
        
        personImage.image = selectedImage
        personImageURL.text = "New Image Selected"
        personImageURL.textColor = .green
        personImageURL.alpha = 1
        newImage = selectedImage
        currentPerson.manualImageURL = "NEW"
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
}

extension EditPersonViewController : UITableViewDataSource, UITableViewDelegate {
    func getSong(songIdFull: String, completion: @escaping (SongData) -> Void) {
        let word = songIdFull.split(separator: "Æ")
        let id = String(word[0])
        DatabaseManager.shared.findSongById(songId: id, completion: { result in
            switch result {
            case .success(let song):
                completion(song)
            case .failure(let err):
                print("dsvgredfxbdfzx"+err.localizedDescription)
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
                print("dsvgredfxbdfzx"+err.localizedDescription)
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
    
    func getBeat(beatIdFull: String, completion: @escaping (BeatData) -> Void) {
        let word = beatIdFull.split(separator: "Æ")
        let id = String(word[0])
        DatabaseManager.shared.findBeatById(beatId: id, completion: { result in
            switch result {
            case .success(let beat):
                completion(beat)
            case .failure(let err):
                print("dsvgredfxbdfzx"+err.localizedDescription)
            }
        })
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch tableView {
        case personAltNamesTableView:
            if currentPerson.alternateNames != nil {
                return currentPerson.alternateNames!.count
            } else {
                return 0
            }
        case personSongsTableView:
            return personSongsArr.count
        case personAlbumsTableView:
            return personAlbumsArr.count
        case personVideosTableView:
            return personVideosArr.count
        case personInstrumentalsTableView:
            return personInstrumentalsArr.count
        case personBeatsTableView:
            return personBeatsArr.count
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch tableView {
        case personAltNamesTableView:
            let cell = tableView.dequeueReusableCell(withIdentifier: "editPersonAltNameCell", for: indexPath) as! EditPersonAltNameTableCell
            cell.name.text = currentPerson.alternateNames![indexPath.row]
            return cell
        case personSongsTableView:
            let cell = tableView.dequeueReusableCell(withIdentifier: "roleEditSongCell", for: indexPath) as! RoleEditSongCell
            if !personSongsArr.isEmpty {
                cell.setUp(song: personSongsArr[indexPath.row], artistId: currentPerson.toneDeafAppId)
            }
            return cell
        case personAlbumsTableView:
            let cell = tableView.dequeueReusableCell(withIdentifier: "editPersonAlbumCell", for: indexPath) as! EditPersonAlbumCell
            if !personAlbumsArr.isEmpty {
                cell.setUp(album: personAlbumsArr[indexPath.row], artistId: currentPerson.toneDeafAppId)
            }
            return cell
        case personVideosTableView:
            let cell = tableView.dequeueReusableCell(withIdentifier: "editPersonVideoCell", for: indexPath) as! EditPersonVideoCell
            if !personVideosArr.isEmpty {
                cell.setUp(video: personVideosArr[indexPath.row], artistId: currentPerson.toneDeafAppId)
            }
            return cell
        case personInstrumentalsTableView:
            let cell = tableView.dequeueReusableCell(withIdentifier: "editPersonInstrumentalCell", for: indexPath) as! EditPersonInstrumentalCell
            if !personInstrumentalsArr.isEmpty {
                //print(personSongsArr[indexPath.row].songArtist, personSongsArr[indexPath.row].songProducers)
                cell.setUp(instrumental: personInstrumentalsArr[indexPath.row], artistId: currentPerson.toneDeafAppId)
            }
            return cell
        case personBeatsTableView:
            let cell = tableView.dequeueReusableCell(withIdentifier: "editPersonInstrumentalCell", for: indexPath) as! EditPersonInstrumentalCell
            if !personBeatsArr.isEmpty {
                //print(personSongsArr[indexPath.row].songArtist, personSongsArr[indexPath.row].songProducers)
                cell.setUp(beat: personBeatsArr[indexPath.row], artistId: currentPerson.toneDeafAppId, legal: currentPerson.legalName)
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
        case personAltNamesTableView:
            let alertC = UIAlertController(title: "Edit Alternate Name",
                                                    message: "",
                                                    preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Modify", style: .default, handler: {[weak self] _ in
                guard let strongSelf = self else {return}
                let field = alertC.textFields![0]
                if field.text != "" {
                    guard let name = field.text else {return}
                    var newNames:[String] = []
                    if let altn = strongSelf.currentPerson.alternateNames {
                        newNames = altn
                    }
                    newNames[indexPath.row] = name
                    strongSelf.currentPerson.alternateNames = newNames
                    strongSelf.personAltNamesTableView.reloadData()
                    strongSelf.personAltNamesHeightConstraint.constant = CGFloat(50*(newNames.count))
                    alertC.dismiss(animated: true, completion: nil)
                } else {
                    alertC.dismiss(animated: true, completion: nil)
                }
            })
            alertC.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            alertC.addAction(okAction)
            alertC.addTextField()
            let field = alertC.textFields![0]
            field.text = currentPerson.alternateNames![indexPath.row]
            alertC.view.tintColor = Constants.Colors.redApp
            self.present(alertC, animated: true)
        case personSongsTableView:
            //MARK: - didSelect Songs
            alertController = UIAlertController(title: "Change roles for \(personSongsArr[indexPath.row].name)",
                                                    message: "Select Roles",
                                                    preferredStyle: .alert)
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc3 = storyboard.instantiateViewController(identifier: "editPersonRolesPopoverTableViewController") as
            EditPersonRolesPopoverTableViewController
            vc3.preferredContentSize = CGSize(width: 350, height: 360) // 4 default cell heights.
            vc3.tableView.isScrollEnabled = false
            alertController.setValue(vc3, forKey: "contentViewController")
            
            let editAction = UIAlertAction(title: "Edit \(personSongsArr[indexPath.row].name)", style: .default, handler: { _ in
                
            })
            
            let addAction = UIAlertAction(title: "Update Roles", style: .default, handler: {[weak self] _ in
                guard let strongSelf = self else {return}
                var newRoleArr:[String] = []
                let cc = alertController.value(forKey: "contentViewController") as! EditPersonRolesPopoverTableViewController
                for i in 1 ... (cc.roleArr.count) {
                    let cell = cc.tableViewPopover.cellForRow(at: IndexPath(row: i-1, section: 0)) as! EditRolePopoverTableCellController
                    if cell.checkbox.on {
                        newRoleArr.append(cell.role.text!)
                    }
                }
                
                let songChosen = strongSelf.personSongsArr[indexPath.row]
                
                var albumsToUpdate:[AlbumData] = []
                var albumsToUpdateIds:[String] = []
                if let arr = songChosen.albums as? [String] {
                    for alb in strongSelf.personAlbumsArr {
                        if arr.contains(alb.toneDeafAppId) {
                            albumsToUpdate.append(alb)
                            albumsToUpdateIds.append(alb.toneDeafAppId)
                        }
                    }
                }
                
                var roles:NSMutableDictionary?
                roles = strongSelf.currentPerson.roles
                if roles == nil {
                    roles = [:]
                }
                var newRoles:NSMutableDictionary = roles!
                var engineerDict:[String:Any?] = [:]
                if let engies = newRoles["Engineer"] as? [String:Any?] {
                    engineerDict = engies
                }
                let selectsongrole = strongSelf.personSongsArr[indexPath.row]
                if newRoleArr.contains("Artist") {
                    if !selectsongrole.songArtist.contains("\(strongSelf.currentPerson.toneDeafAppId)"){
                        selectsongrole.songArtist.append("\(strongSelf.currentPerson.toneDeafAppId)")
                    }
                    for album in albumsToUpdate {
                        if var arr = album.allArtists as? [String] {
                            if !arr.contains("\(strongSelf.currentPerson.toneDeafAppId)"){
                                arr.append("\(strongSelf.currentPerson.toneDeafAppId)")
                                album.allArtists = arr
                            }
                        } else {
                            var arr:[String] = []
                            if !arr.contains("\(strongSelf.currentPerson.toneDeafAppId)") {
                                arr.append("\(strongSelf.currentPerson.toneDeafAppId)")
                            }
                            album.allArtists = arr
                        }
                        if !strongSelf.albumFeaturedArtistArr.contains(album.toneDeafAppId) {
                            strongSelf.albumFeaturedArtistArr.append(album.toneDeafAppId)
                        }
                    }
                    if let curRole = roles {
                        if var subrole = curRole["Artist"] as? [String]{
                            if !subrole.contains("\(selectsongrole.toneDeafAppId)") {
                                subrole.append("\(selectsongrole.toneDeafAppId)")
                                subrole = Array(GlobalFunctions.shared.combine(subrole,albumsToUpdateIds))
                                newRoles["Artist"] = subrole.sorted()
                            }
                        }
                        else {
                            var subrole:[String] = ["\(selectsongrole.toneDeafAppId)"]
                            subrole = Array(GlobalFunctions.shared.combine(subrole,albumsToUpdateIds))
                            newRoles["Artist"] = subrole.sorted()
                        }
                    }
                    else {
                        var subrole:[String] = ["\(selectsongrole.toneDeafAppId)"]
                        subrole = Array(GlobalFunctions.shared.combine(subrole,albumsToUpdateIds))
                        newRoles["Artist"] = subrole.sorted()
                    }
                } else {
                    if let dex = selectsongrole.songArtist.firstIndex(of: "\(strongSelf.currentPerson.toneDeafAppId)")
                    {
                        selectsongrole.songArtist.remove(at: Int(dex))
                    }
                    if var arrrr = newRoles["Artist"] as? [String] {
                        if let dex = arrrr.firstIndex(of: "\(selectsongrole.toneDeafAppId)")
                        {
                            arrrr.remove(at: dex)
                            if !arrrr.isEmpty {
                                newRoles["Artist"] = arrrr.sorted()
                            } else {
                                newRoles["Artist"] = nil
                            }
                        }
                    }
                    
                    if let alb = songChosen.albums as? [String] {
                        var songChosenAlbumsDataArray:[AlbumData] = []
                        for album in strongSelf.personAlbumsArr {
                            if alb.contains(album.toneDeafAppId) {
                                songChosenAlbumsDataArray.append(album)
                            }
                        }
                        for album in songChosenAlbumsDataArray {
                            var roleMArkedOnAnotherSong:Bool = false
                            for song in strongSelf.personSongsArr {
                                if song.songArtist.contains(strongSelf.currentPerson.toneDeafAppId) {
                                    if let songarr2 = song.albums as? [String] {
                                        if songarr2.contains(album.toneDeafAppId) {
                                            roleMArkedOnAnotherSong = true
                                        }
                                    }
                                }
                            }
                            for song in strongSelf.personInstrumentalsArr {
                                if let arr2 = song.artist {
                                    if arr2.contains(strongSelf.currentPerson.toneDeafAppId) {
                                        if let songarr2 = song.albums as? [String] {
                                            if songarr2.contains(album.toneDeafAppId) {
                                                roleMArkedOnAnotherSong = true
                                            }
                                        }
                                    }
                                }
                            }
                            if roleMArkedOnAnotherSong == false {
//                                if let dex = album.mainArtist.firstIndex(of: "\(strongSelf.currentPerson.toneDeafAppId)")
//                                {
//                                    album.mainArtist.remove(at: Int(dex))
//                                }
                                if let dex = album.allArtists?.firstIndex(of: "\(strongSelf.currentPerson.toneDeafAppId)")
                                {
                                    album.allArtists!.remove(at: Int(dex))
                                }
                                if var arrrr = newRoles["Artist"] as? [String] {
                                    if let dex = arrrr.firstIndex(of: "\(album.toneDeafAppId)")
                                    {
                                        arrrr.remove(at: dex)
                                        if !arrrr.isEmpty {
                                            newRoles["Artist"] = arrrr.sorted()
                                        } else {
                                            newRoles["Artist"] = nil
                                        }
                                    }
                                }
//                                if strongSelf.albumMainArtistArr.contains(album.toneDeafAppId) {
//                                    if let dex = strongSelf.albumMainArtistArr.firstIndex(of: "\(album.toneDeafAppId)")
//                                    {
//                                        strongSelf.albumMainArtistArr.remove(at: dex)
//                                    }
//                                }
                                if strongSelf.albumFeaturedArtistArr.contains(album.toneDeafAppId) {
                                    if let dex = strongSelf.albumFeaturedArtistArr.firstIndex(of: "\(album.toneDeafAppId)")
                                    {
                                        strongSelf.albumFeaturedArtistArr.remove(at: dex)
                                    }
                                }
                            }
                        }
                    }
                    
                }
                if newRoleArr.contains("Producer") {
                    if !selectsongrole.songProducers.contains("\(strongSelf.currentPerson.toneDeafAppId)"){
                        selectsongrole.songProducers.append("\(strongSelf.currentPerson.toneDeafAppId)")
                    }
                    for album in albumsToUpdate {
                        if !album.producers.contains("\(strongSelf.currentPerson.toneDeafAppId)"){
                            album.producers.append("\(strongSelf.currentPerson.toneDeafAppId)")
                        }
                    }
                    if let curRole = roles {
                        if var subrole = curRole["Producer"] as? [String]{
                            if !subrole.contains("\(selectsongrole.toneDeafAppId)") {
                                subrole.append("\(selectsongrole.toneDeafAppId)")
                                subrole = Array(GlobalFunctions.shared.combine(subrole,albumsToUpdateIds))
                                newRoles["Producer"] = subrole.sorted()
                            }
                        }
                        else {
                            var subrole:[String] = ["\(selectsongrole.toneDeafAppId)"]
                            subrole = Array(GlobalFunctions.shared.combine(subrole,albumsToUpdateIds))
                            newRoles["Producer"] = subrole.sorted()
                        }
                    }
                    else {
                        var subrole:[String] = ["\(selectsongrole.toneDeafAppId)"]
                        subrole = Array(GlobalFunctions.shared.combine(subrole,albumsToUpdateIds))
                        newRoles["Producer"] = subrole.sorted()
                    }
                } else {
                    if let dex = selectsongrole.songProducers.firstIndex(of: "\(strongSelf.currentPerson.toneDeafAppId)")
                    {
                        selectsongrole.songProducers.remove(at: Int(dex))
                    }
                    if var arrrr = newRoles["Producer"] as? [String] {
                        if let dex = arrrr.firstIndex(of: "\(selectsongrole.toneDeafAppId)")
                        {
                            arrrr.remove(at: dex)
                            if !arrrr.isEmpty {
                                newRoles["Producer"] = arrrr.sorted()
                            } else {
                                newRoles["Producer"] = nil
                            }
                        }
                    }
                    if let alb = songChosen.albums as? [String] {
                        var songChosenAlbumsDataArray:[AlbumData] = []
                        for album in strongSelf.personAlbumsArr {
                            if alb.contains(album.toneDeafAppId) {
                                songChosenAlbumsDataArray.append(album)
                            }
                        }
                        for album in songChosenAlbumsDataArray {
                            var roleMArkedOnAnotherSong:Bool = false
                            for song in strongSelf.personSongsArr {
                                if song.songProducers.contains(strongSelf.currentPerson.toneDeafAppId) {
                                    if let songarr2 = song.albums as? [String] {
                                        if songarr2.contains(album.toneDeafAppId) {
                                            roleMArkedOnAnotherSong = true
                                        }
                                    }
                                }
                            }
                            for song in strongSelf.personInstrumentalsArr {
                                if song.producers.contains(strongSelf.currentPerson.toneDeafAppId) {
                                    if let songarr2 = song.albums as? [String] {
                                        if songarr2.contains(album.toneDeafAppId) {
                                            roleMArkedOnAnotherSong = true
                                        }
                                    }
                                }
                            }
                            if roleMArkedOnAnotherSong == false {
                                if let dex = album.producers.firstIndex(of: "\(strongSelf.currentPerson.toneDeafAppId)")
                                {
                                    album.producers.remove(at: Int(dex))
                                }
                                if var arrrr = newRoles["Producer"] as? [String] {
                                    if let dex = arrrr.firstIndex(of: "\(album.toneDeafAppId)")
                                    {
                                        arrrr.remove(at: dex)
                                        if !arrrr.isEmpty {
                                            newRoles["Producer"] = arrrr.sorted()
                                        } else {
                                            newRoles["Producer"] = nil
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
                if newRoleArr.contains("Writer") {
                    if let _ = selectsongrole.songWriters {
                        if !selectsongrole.songWriters!.contains("\(strongSelf.currentPerson.toneDeafAppId)"){
                            selectsongrole.songWriters!.append("\(strongSelf.currentPerson.toneDeafAppId)")
                        }
                    } else {
                        selectsongrole.songWriters = [strongSelf.currentPerson.toneDeafAppId]
                    }
                    for album in albumsToUpdate {
                        if var arr = album.writers as? [String] {
                            if !arr.contains("\(strongSelf.currentPerson.toneDeafAppId)"){
                                arr.append("\(strongSelf.currentPerson.toneDeafAppId)")
                                album.writers = arr
                            }
                        } else {
                            var arr:[String] = []
                            arr.append("\(strongSelf.currentPerson.toneDeafAppId)")
                            album.writers = arr
                        }
                    }
                    if let curRole = roles {
                        if var subrole = curRole["Writer"] as? [String]{
                            if !subrole.contains("\(selectsongrole.toneDeafAppId)") {
                                subrole.append("\(selectsongrole.toneDeafAppId)")
                                subrole = Array(GlobalFunctions.shared.combine(subrole,albumsToUpdateIds))
                                newRoles["Writer"] = subrole.sorted()
                            }
                        }
                        else {
                            var subrole:[String] = ["\(selectsongrole.toneDeafAppId)"]
                            subrole = Array(GlobalFunctions.shared.combine(subrole,albumsToUpdateIds))
                            newRoles["Writer"] = subrole.sorted()
                        }
                    }
                    else {
                        var subrole:[String] = ["\(selectsongrole.toneDeafAppId)"]
                        subrole = Array(GlobalFunctions.shared.combine(subrole,albumsToUpdateIds))
                        newRoles["Writer"] = subrole.sorted()
                    }
                    if !selectsongrole.songWriters!.contains("\(strongSelf.currentPerson.toneDeafAppId)"){
                        selectsongrole.songWriters!.append("\(strongSelf.currentPerson.toneDeafAppId)")
                    }
                } else {
                    if let dex = selectsongrole.songWriters?.firstIndex(of: "\(strongSelf.currentPerson.toneDeafAppId)")
                    {
                        selectsongrole.songWriters!.remove(at: Int(dex))
                    }
                    if var arrrr = newRoles["Writer"] as? [String] {
                        if let dex = arrrr.firstIndex(of: "\(selectsongrole.toneDeafAppId)")
                        {
                            arrrr.remove(at: dex)
                            if !arrrr.isEmpty {
                                newRoles["Writer"] = arrrr.sorted()
                            } else {
                                newRoles["Writer"] = nil
                            }
                        }
                    }
                    if let alb = songChosen.albums as? [String] {
                        var songChosenAlbumsDataArray:[AlbumData] = []
                        for album in strongSelf.personAlbumsArr {
                            if alb.contains(album.toneDeafAppId) {
                                songChosenAlbumsDataArray.append(album)
                            }
                        }
                        for album in songChosenAlbumsDataArray {
                            var roleMArkedOnAnotherSong:Bool = false
                            for song in strongSelf.personSongsArr {
                                if let arrr = song.songWriters as? [String] {
                                    if arrr.contains(strongSelf.currentPerson.toneDeafAppId) {
                                        if let songarr2 = song.albums as? [String] {
                                            if songarr2.contains(album.toneDeafAppId) {
                                                roleMArkedOnAnotherSong = true
                                            }
                                        }
                                    }
                                }
                            }
                            if roleMArkedOnAnotherSong == false {
                                if let dex = album.writers?.firstIndex(of: "\(strongSelf.currentPerson.toneDeafAppId)")
                                {
                                    album.writers!.remove(at: Int(dex))
                                }
                                if var arrrr = newRoles["Writer"] as? [String] {
                                    if let dex = arrrr.firstIndex(of: "\(album.toneDeafAppId)")
                                    {
                                        arrrr.remove(at: dex)
                                        if !arrrr.isEmpty {
                                            newRoles["Writer"] = arrrr.sorted()
                                        } else {
                                            newRoles["Writer"] = nil
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
                if newRoleArr.contains("Mix Engineer") {
                    if let _ = selectsongrole.songMixEngineer {
                        if !selectsongrole.songMixEngineer!.contains("\(strongSelf.currentPerson.toneDeafAppId)"){
                            selectsongrole.songMixEngineer!.append("\(strongSelf.currentPerson.toneDeafAppId)")
                        }
                    } else {
                        selectsongrole.songMixEngineer = [strongSelf.currentPerson.toneDeafAppId]
                    }
                    for album in albumsToUpdate {
                        if var arr = album.mixEngineers as? [String] {
                            if !arr.contains("\(strongSelf.currentPerson.toneDeafAppId)"){
                                arr.append("\(strongSelf.currentPerson.toneDeafAppId)")
                                album.mixEngineers = arr
                            }
                        } else {
                            var arr:[String] = []
                            arr.append("\(strongSelf.currentPerson.toneDeafAppId)")
                            album.mixEngineers = arr
                        }
                    }
                    if let curRole = roles {
                        if let subCat = curRole["Engineer"] as? [String:Any?]
                        {
                            if var subrole = subCat["Mix Engineer"] as? [String]{
                                if !subrole.contains("\(selectsongrole.toneDeafAppId)") {
                                    subrole.append("\(selectsongrole.toneDeafAppId)")
                                    subrole = Array(GlobalFunctions.shared.combine(subrole,albumsToUpdateIds))
                                    engineerDict["Mix Engineer"] = subrole.sorted()
                                }
                            } else {
                                var subrole:[String] = ["\(selectsongrole.toneDeafAppId)"]
                                subrole = Array(GlobalFunctions.shared.combine(subrole,albumsToUpdateIds))
                                engineerDict["Mix Engineer"] = subrole.sorted()
                            }
                        } else {
                            var subrole:[String] = ["\(selectsongrole.toneDeafAppId)"]
                            subrole = Array(GlobalFunctions.shared.combine(subrole,albumsToUpdateIds))
                            engineerDict["Mix Engineer"] = subrole.sorted()
                        }
                    } else {
                        var subrole:[String] = ["\(selectsongrole.toneDeafAppId)"]
                        subrole = Array(GlobalFunctions.shared.combine(subrole,albumsToUpdateIds))
                        engineerDict["Mix Engineer"] = subrole.sorted()
                    }
                } else {
                    
                    if let dex = selectsongrole.songMixEngineer?.firstIndex(of: "\(strongSelf.currentPerson.toneDeafAppId)")
                    {
                        selectsongrole.songMixEngineer!.remove(at: Int(dex))
                    }
                    if var arrrr = engineerDict["Mix Engineer"] as? [String] {
                        
                        if let dex = arrrr.firstIndex(of: "\(selectsongrole.toneDeafAppId)")
                        {
                            
                            arrrr.remove(at: dex)
                            
                            if !arrrr.isEmpty {
                                engineerDict["Mix Engineer"] = arrrr.sorted()
                            } else {
                                
                                engineerDict["Mix Engineer"] = nil
                            }
                        }
                    }
                    if let alb = songChosen.albums as? [String] {
                        var songChosenAlbumsDataArray:[AlbumData] = []
                        for album in strongSelf.personAlbumsArr {
                            if alb.contains(album.toneDeafAppId) {
                                songChosenAlbumsDataArray.append(album)
                            }
                        }
                        for album in songChosenAlbumsDataArray {
                            var roleMArkedOnAnotherSong:Bool = false
                            for song in strongSelf.personSongsArr {
                                if let arrr = song.songMixEngineer as? [String] {
                                    if arrr.contains(strongSelf.currentPerson.toneDeafAppId) {
                                        if let songarr2 = song.albums as? [String] {
                                            if songarr2.contains(album.toneDeafAppId) {
                                                roleMArkedOnAnotherSong = true
                                            }
                                        }
                                    }
                                }
                            }
                            for song in strongSelf.personInstrumentalsArr {
                                if let arrr = song.mixEngineer as? [String] {
                                    if arrr.contains(strongSelf.currentPerson.toneDeafAppId) {
                                        if let songarr2 = song.albums as? [String] {
                                            if songarr2.contains(album.toneDeafAppId) {
                                                roleMArkedOnAnotherSong = true
                                            }
                                        }
                                    }
                                }
                            }
                            if roleMArkedOnAnotherSong == false {
                                if let dex = album.mixEngineers?.firstIndex(of: "\(strongSelf.currentPerson.toneDeafAppId)")
                                {
                                    album.mixEngineers!.remove(at: Int(dex))
                                }
                                if var arrrr = engineerDict["Mix Engineer"] as? [String] {
                                    if let dex = arrrr.firstIndex(of: "\(album.toneDeafAppId)")
                                    {
                                        arrrr.remove(at: dex)
                                        if !arrrr.isEmpty {
                                            engineerDict["Mix Engineer"] = arrrr.sorted()
                                        } else {
                                            engineerDict["Mix Engineer"] = nil
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
                if newRoleArr.contains("Mastering Engineer") {
                    if !selectsongrole.songMasteringEngineer!.contains("\(strongSelf.currentPerson.toneDeafAppId)"){
                        selectsongrole.songMasteringEngineer!.append("\(strongSelf.currentPerson.toneDeafAppId)")
                    }
                    for album in albumsToUpdate {
                        if var arr = album.masteringEngineers as? [String] {
                            if !arr.contains("\(strongSelf.currentPerson.toneDeafAppId)"){
                                arr.append("\(strongSelf.currentPerson.toneDeafAppId)")
                                album.masteringEngineers = arr
                            }
                        } else {
                            var arr:[String] = []
                            arr.append("\(strongSelf.currentPerson.toneDeafAppId)")
                            album.masteringEngineers = arr
                        }
                    }
                    if let curRole = roles {
                        if let subCat = curRole["Engineer"] as? [String:Any?] {
                            if var subrole = subCat["Mastering Engineer"] as? [String]{
                                if !subrole.contains("\(selectsongrole.toneDeafAppId)") {
                                    subrole.append("\(selectsongrole.toneDeafAppId)")
                                    subrole = Array(GlobalFunctions.shared.combine(subrole,albumsToUpdateIds))
                                    engineerDict["Mastering Engineer"] = subrole.sorted()
                                }
                            } else {
                                var subrole:[String] = ["\(selectsongrole.toneDeafAppId)"]
                                subrole = Array(GlobalFunctions.shared.combine(subrole,albumsToUpdateIds))
                                engineerDict["Mastering Engineer"] = subrole.sorted()
                            }
                        } else {
                            var subrole:[String] = ["\(selectsongrole.toneDeafAppId)"]
                            subrole = Array(GlobalFunctions.shared.combine(subrole,albumsToUpdateIds))
                            engineerDict["Mastering Engineer"] = subrole.sorted()
                        }
                    } else {
                        var subrole:[String] = ["\(selectsongrole.toneDeafAppId)"]
                        subrole = Array(GlobalFunctions.shared.combine(subrole,albumsToUpdateIds))
                        engineerDict["Mastering Engineer"] = subrole.sorted()
                    }
                } else {
                    if let dex = selectsongrole.songMasteringEngineer?.firstIndex(of: "\(strongSelf.currentPerson.toneDeafAppId)")
                    {selectsongrole.songMasteringEngineer!.remove(at: Int(dex))}
                    if var arrrr = engineerDict["Mastering Engineer"] as? [String] {
                        if let dex = arrrr.firstIndex(of: "\(selectsongrole.toneDeafAppId)")
                        {
                            arrrr.remove(at: dex)
                            if !arrrr.isEmpty {
                                engineerDict["Mastering Engineer"] = arrrr.sorted()
                            } else {
                                engineerDict["Mastering Engineer"] = nil
                            }
                        }
                    }
                    if let alb = songChosen.albums as? [String] {
                        var songChosenAlbumsDataArray:[AlbumData] = []
                        for album in strongSelf.personAlbumsArr {
                            if alb.contains(album.toneDeafAppId) {
                                songChosenAlbumsDataArray.append(album)
                            }
                        }
                        for album in songChosenAlbumsDataArray {
                            var roleMArkedOnAnotherSong:Bool = false
                            for song in strongSelf.personSongsArr {
                                if let arrr = song.songMasteringEngineer as? [String] {
                                    if arrr.contains(strongSelf.currentPerson.toneDeafAppId) {
                                        if let songarr2 = song.albums as? [String] {
                                            if songarr2.contains(album.toneDeafAppId) {
                                                roleMArkedOnAnotherSong = true
                                            }
                                        }
                                    }
                                }
                            }
                            for song in strongSelf.personInstrumentalsArr {
                                if let arrr = song.masteringEngineer as? [String] {
                                    if arrr.contains(strongSelf.currentPerson.toneDeafAppId) {
                                        if let songarr2 = song.albums as? [String] {
                                            if songarr2.contains(album.toneDeafAppId) {
                                                roleMArkedOnAnotherSong = true
                                            }
                                        }
                                    }
                                }
                            }
                            if roleMArkedOnAnotherSong == false {
                                if let dex = album.masteringEngineers?.firstIndex(of: "\(strongSelf.currentPerson.toneDeafAppId)")
                                {
                                    album.masteringEngineers!.remove(at: Int(dex))
                                }
                                if var arrrr = engineerDict["Mastering Engineer"] as? [String] {
                                    if let dex = arrrr.firstIndex(of: "\(album.toneDeafAppId)")
                                    {
                                        arrrr.remove(at: dex)
                                        if !arrrr.isEmpty {
                                            engineerDict["Mastering Engineer"] = arrrr.sorted()
                                        } else {
                                            engineerDict["Mastering Engineer"] = nil
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
                if newRoleArr.contains("Recording Engineer") {
                    if !selectsongrole.songRecordingEngineer!.contains("\(strongSelf.currentPerson.toneDeafAppId)"){
                        selectsongrole.songRecordingEngineer!.append("\(strongSelf.currentPerson.toneDeafAppId)")
                    }
                    for album in albumsToUpdate {
                        if var arr = album.recordingEngineers as? [String] {
                            if !arr.contains("\(strongSelf.currentPerson.toneDeafAppId)"){
                                arr.append("\(strongSelf.currentPerson.toneDeafAppId)")
                                album.recordingEngineers = arr
                            }
                        } else {
                            var arr:[String] = []
                            arr.append("\(strongSelf.currentPerson.toneDeafAppId)")
                            album.recordingEngineers = arr
                        }
                    }
                    if let curRole = roles {
                        if let subCat = curRole["Engineer"] as? [String:Any?]{
                            if var subrole = subCat["Recording Engineer"] as? [String]{
                                if !subrole.contains("\(selectsongrole.toneDeafAppId)") {
                                    subrole.append("\(selectsongrole.toneDeafAppId)")
                                    subrole = Array(GlobalFunctions.shared.combine(subrole,albumsToUpdateIds))
                                    engineerDict["Recording Engineer"] = subrole.sorted()
                                }
                            } else {
                                var subrole:[String] = ["\(selectsongrole.toneDeafAppId)"]
                                subrole = Array(GlobalFunctions.shared.combine(subrole,albumsToUpdateIds))
                                engineerDict["Recording Engineer"] = subrole.sorted()
                            }
                        } else {
                            var subrole:[String] = ["\(selectsongrole.toneDeafAppId)"]
                            subrole = Array(GlobalFunctions.shared.combine(subrole,albumsToUpdateIds))
                            engineerDict["Recording Engineer"] = subrole.sorted()
                        }
                    } else {
                        var subrole:[String] = ["\(selectsongrole.toneDeafAppId)"]
                        subrole = Array(GlobalFunctions.shared.combine(subrole,albumsToUpdateIds))
                        engineerDict["Recording Engineer"] = subrole.sorted()
                    }
                } else {
                    if let dex = selectsongrole.songRecordingEngineer?.firstIndex(of: "\(strongSelf.currentPerson.toneDeafAppId)")
                    {
                        selectsongrole.songRecordingEngineer!.remove(at: Int(dex))
                    }
                    if var arrrr = engineerDict["Recording Engineer"] as? [String] {
                        if let dex = arrrr.firstIndex(of: "\(selectsongrole.toneDeafAppId)")
                        {
                            arrrr.remove(at: dex)
                            if !arrrr.isEmpty {
                                engineerDict["Recording Engineer"] = arrrr.sorted()
                            } else {
                                engineerDict["Recording Engineer"] = nil
                            }
                        }
                    }
                    if let alb = songChosen.albums as? [String] {
                        var songChosenAlbumsDataArray:[AlbumData] = []
                        for album in strongSelf.personAlbumsArr {
                            if alb.contains(album.toneDeafAppId) {
                                songChosenAlbumsDataArray.append(album)
                            }
                        }
                        for album in songChosenAlbumsDataArray {
                            var roleMArkedOnAnotherSong:Bool = false
                            for song in strongSelf.personSongsArr {
                                if let arrr = song.songRecordingEngineer as? [String] {
                                    if arrr.contains(strongSelf.currentPerson.toneDeafAppId) {
                                        if let songarr2 = song.albums as? [String] {
                                            if songarr2.contains(album.toneDeafAppId) {
                                                roleMArkedOnAnotherSong = true
                                            }
                                        }
                                    }
                                }
                            }
                            if roleMArkedOnAnotherSong == false {
                                if let dex = album.recordingEngineers?.firstIndex(of: "\(strongSelf.currentPerson.toneDeafAppId)")
                                {
                                    album.recordingEngineers!.remove(at: Int(dex))
                                }
                                if var arrrr = engineerDict["Recording Engineer"] as? [String] {
                                    if let dex = arrrr.firstIndex(of: "\(album.toneDeafAppId)")
                                    {
                                        arrrr.remove(at: dex)
                                        if !arrrr.isEmpty {
                                            engineerDict["Recording Engineer"] = arrrr.sorted()
                                        } else {
                                            engineerDict["Recording Engineer"] = nil
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
                if engineerDict.isEmpty {
                    newRoles["Engineer"] = nil
                } else {
                    newRoles["Engineer"] = engineerDict
                }
                if newRoleArr.isEmpty {
                    let songToGo = strongSelf.personSongsArr[indexPath.row]
                    let songID = "\(songToGo.toneDeafAppId)"
                    strongSelf.personSongsArr.remove(at: indexPath.row)
                    strongSelf.currentPerson.songs = []
                    for song in strongSelf.personSongsArr {
                        strongSelf.currentPerson.songs!.append("\(song.toneDeafAppId)")
                    }
                    if strongSelf.personSongsArr.isEmpty {
                        strongSelf.currentPerson.songs = nil
                    }
                    tableView.deleteRows(at: [indexPath], with: .fade)
                    if strongSelf.personSongsArr.count < 6 {
                        strongSelf.personSongsHeightConstraint.constant = CGFloat(50*(strongSelf.personSongsArr.count))
                    } else {
                        strongSelf.personSongsHeightConstraint.constant = CGFloat(270)
                    }
                    
                    if let arr = songToGo.albums as? [String] {
                        for alb in strongSelf.personAlbumsArr {
                            if arr.contains(alb.toneDeafAppId) {
                                var count = 0
                                var albumOnAnotherSong = false
                                for song in strongSelf.personSongsArr {
                                    if let arrr = song.albums as? [String] {
                                        if arrr.contains(alb.toneDeafAppId) && song.toneDeafAppId != songID {
                                            albumOnAnotherSong = true
                                        }
                                    }
                                }
                                for song in strongSelf.personInstrumentalsArr {
                                    if let arrr = song.albums as? [String] {
                                        if arrr.contains(alb.toneDeafAppId) && song.toneDeafAppId != songID {
                                            albumOnAnotherSong = true
                                        }
                                    }
                                }
                                if albumOnAnotherSong == false {
                                    if var curRole = roles {
                                        if var artsubrole = (curRole["Artist"] as? [String]) {
                                            for songTitles in artsubrole {
                                                if songTitles == alb.toneDeafAppId {
                                                    let elementIndex = artsubrole.firstIndex(of: songTitles)
                                                    artsubrole.remove(at: elementIndex!)
                                                }
                                            }
                                            curRole["Artist"] = artsubrole.sorted()
                                            if artsubrole.isEmpty {
                                                curRole["Artist"] = nil
                                            }
                                        } else {
                                            for albbb in strongSelf.albumMainArtistArr {
                                                if albbb == alb.toneDeafAppId {
                                                    if let elementIndex2 = strongSelf.albumMainArtistArr.firstIndex(of: albbb) {
                                                        strongSelf.albumMainArtistArr.remove(at: elementIndex2)
                                                    }
                                                }
                                            }
                                            for albbb in strongSelf.albumFeaturedArtistArr {
                                                if albbb == alb.toneDeafAppId {
                                                    if let elementIndex2 = strongSelf.albumFeaturedArtistArr.firstIndex(of: albbb) {
                                                        strongSelf.albumFeaturedArtistArr.remove(at: elementIndex2)
                                                    }
                                                }
                                            }
                                        }
                                        if var prosubrole = (curRole["Producer"] as? [String]){
                                            for songTitles in prosubrole {
                                                if songTitles == alb.toneDeafAppId {
                                                    let elementIndex = prosubrole.firstIndex(of: songTitles)
                                                    prosubrole.remove(at: elementIndex!)
                                                }
                                            }
                                            curRole["Producer"] = prosubrole.sorted()
                                            if prosubrole.isEmpty {
                                                curRole["Producer"] = nil
                                            }
                                        }
                                        if var wrisubrole = (curRole["Writer"] as? [String]){
                                            for songTitles in wrisubrole {
                                                if songTitles == alb.toneDeafAppId {
                                                    let elementIndex =  wrisubrole.firstIndex(of: songTitles)
                                                    wrisubrole.remove(at: elementIndex!)
                                                }
                                            }
                                            curRole["Writer"] = wrisubrole.sorted()
                                            if wrisubrole.isEmpty {
                                                curRole["Writer"] = nil
                                            }
                                        }
                                        if let engsubCat = curRole["Engineer"] as? NSMutableDictionary{
                                            if var engsubrole = engsubCat["Mix Engineer"] as? [String]{
                                                
                                                for songTitles in engsubrole {
                                                    
                                                    if songTitles == alb.toneDeafAppId {
                                                        
                                                        let elementIndex = engsubrole.firstIndex(of: songTitles)
                                                        engsubrole.remove(at: elementIndex!)
                                                    }
                                                }
                                                engsubCat["Mix Engineer"] = engsubrole.sorted()
                                                if engsubrole.isEmpty {
                                                    engsubCat["Mix Engineer"] = nil
                                                }
                                            }
                                            if var mengsubrole = engsubCat["Mastering Engineer"] as? [String] {
                                                for songTitles in mengsubrole {
                                                    if songTitles == alb.toneDeafAppId {
                                                        let elementIndex = mengsubrole.firstIndex(of: songTitles)
                                                        mengsubrole.remove(at: elementIndex!)
                                                    }
                                                }
                                                engsubCat["Mastering Engineer"] = mengsubrole.sorted()
                                                if mengsubrole.isEmpty {
                                                    engsubCat["Mastering Engineer"] = nil
                                                }
                                            }
                                            if var rengsubrole = engsubCat["Recording Engineer"] as? [String]{
                                                for songTitles in rengsubrole {
                                                    if songTitles == alb.toneDeafAppId {
                                                        let elementIndex = rengsubrole.firstIndex(of: songTitles)
                                                        rengsubrole.remove(at: elementIndex!)
                                                    }
                                                }
                                                engsubCat["Recording Engineer"] = rengsubrole.sorted()
                                                if rengsubrole.isEmpty {
                                                    engsubCat["Recording Engineer"] = nil
                                                }
                                            }
                                            curRole["Engineer"] = engsubCat
                                            if engsubCat.count == 0 {
                                                curRole["Engineer"] = nil
                                            }
                                        }
                                        strongSelf.currentPerson.roles = curRole
                                        strongSelf.initialPerson.roles = curRole
                                        
                                    }
                                    let dex = strongSelf.personAlbumsArr.firstIndex(of: alb)
                                    strongSelf.personAlbumsArr.remove(at: dex!)
                                    strongSelf.personAlbumsTableView.deleteRows(at: [IndexPath(row: dex!, section: 0)], with: .fade)
                                    strongSelf.currentPerson.albums = []
                                    for album in strongSelf.personAlbumsArr {
                                        strongSelf.currentPerson.albums!.append("\(album.toneDeafAppId)")
                                    }
                                    if strongSelf.personAlbumsArr.isEmpty {
                                        strongSelf.currentPerson.albums = nil
                                    }
                                    if strongSelf.personAlbumsArr.count < 6 {
                                        strongSelf.personAlbumsHeightConstraint.constant = CGFloat(50*(strongSelf.personAlbumsArr.count))
                                    } else {
                                        strongSelf.personAlbumsHeightConstraint.constant = CGFloat(270)
                                    }
                                }
                                else {
                                    var rolesOnTheAlbumArr:[String] = []
                                    var rolesInOtherSongsOnTheAlbumArr:[String] = []
                                    if var curRole = roles {
                                        if var artsubrole = (curRole["Artist"] as? [String]) {
                                            for songTitles in artsubrole {
                                                if songTitles == alb.toneDeafAppId {
                                                    rolesOnTheAlbumArr.append("Artist")
                                                }
                                            }
                                        }
                                        if var prosubrole = (curRole["Producer"] as? [String]){
                                            for songTitles in prosubrole {
                                                if songTitles == alb.toneDeafAppId {
                                                    rolesOnTheAlbumArr.append("Producer")
                                                }
                                            }
                                        }
                                        if var wrisubrole = (curRole["Writer"] as? [String]){
                                            for songTitles in wrisubrole {
                                                if songTitles == alb.toneDeafAppId {
                                                    rolesOnTheAlbumArr.append("Writer")
                                                }
                                            }
                                        }
                                        if let engsubCatt = curRole["Engineer"] as? NSDictionary{
                                            let engsubCat = engsubCatt.mutableCopy() as! NSMutableDictionary
                                            if var engsubrole = engsubCat["Mix Engineer"] as? [String]{
                                                
                                                for songTitles in engsubrole {
                                                    if songTitles == alb.toneDeafAppId {
                                                        rolesOnTheAlbumArr.append("Mix Engineer")
                                                    }
                                                }
                                            }
                                            if var mengsubrole = engsubCat["Mastering Engineer"] as? [String] {
                                                for songTitles in mengsubrole {
                                                    if songTitles == alb.toneDeafAppId {
                                                        rolesOnTheAlbumArr.append("Mastering Engineer")
                                                    }
                                                }
                                            }
                                            if var rengsubrole = engsubCat["Recording Engineer"] as? [String]{
                                                for songTitles in rengsubrole {
                                                    if songTitles == alb.toneDeafAppId {
                                                        rolesOnTheAlbumArr.append("Recording Engineer")
                                                    }
                                                }
                                            }
                                        }
                                        
                                    }
                                    for song in strongSelf.personSongsArr {
                                        if let arrr = song.albums as? [String] {
                                            if arrr.contains(alb.toneDeafAppId) && song.toneDeafAppId != songID {
                                                if var curRole = roles {
                                                    if var artsubrole = (curRole["Artist"] as? [String]) {
                                                        for songTitles in artsubrole {
                                                            if songTitles == song.toneDeafAppId {
                                                                rolesInOtherSongsOnTheAlbumArr.append("Artist")
                                                            }
                                                        }
                                                    }
                                                    if var prosubrole = (curRole["Producer"] as? [String]){
                                                        for songTitles in prosubrole {
                                                            if songTitles == song.toneDeafAppId {
                                                                rolesInOtherSongsOnTheAlbumArr.append("Producer")
                                                            }
                                                        }
                                                    }
                                                    if var wrisubrole = (curRole["Writer"] as? [String]){
                                                        for songTitles in wrisubrole {
                                                            if songTitles == song.toneDeafAppId {
                                                                rolesInOtherSongsOnTheAlbumArr.append("Writer")
                                                            }
                                                        }
                                                    }
                                                    if let engsubCat = curRole["Engineer"] as? NSMutableDictionary{
                                                        if var engsubrole = engsubCat["Mix Engineer"] as? [String]{
                                                            
                                                            for songTitles in engsubrole {
                                                                if songTitles == song.toneDeafAppId {
                                                                    rolesInOtherSongsOnTheAlbumArr.append("Mix Engineer")
                                                                }
                                                            }
                                                        }
                                                        if var mengsubrole = engsubCat["Mastering Engineer"] as? [String] {
                                                            for songTitles in mengsubrole {
                                                                if songTitles == song.toneDeafAppId {
                                                                    rolesInOtherSongsOnTheAlbumArr.append("Mastering Engineer")
                                                                }
                                                            }
                                                        }
                                                        if var rengsubrole = engsubCat["Recording Engineer"] as? [String]{
                                                            for songTitles in rengsubrole {
                                                                if songTitles == song.toneDeafAppId {
                                                                    rolesInOtherSongsOnTheAlbumArr.append("Recording Engineer")
                                                                }
                                                            }
                                                        }
                                                    }
                                                    
                                                }
                                            }
                                        }
                                    }
                                    for song in strongSelf.personInstrumentalsArr {
                                        if let arrr = song.albums as? [String] {
                                            if arrr.contains(alb.toneDeafAppId) && song.toneDeafAppId != songID {
                                                if var curRole = roles {
                                                    if var artsubrole = (curRole["Artist"] as? [String]) {
                                                        for songTitles in artsubrole {
                                                            if songTitles == song.toneDeafAppId {
                                                                rolesInOtherSongsOnTheAlbumArr.append("Artist")
                                                            }
                                                        }
                                                    }
                                                    if var prosubrole = (curRole["Producer"] as? [String]){
                                                        for songTitles in prosubrole {
                                                            if songTitles == song.toneDeafAppId {
                                                                rolesInOtherSongsOnTheAlbumArr.append("Producer")
                                                            }
                                                        }
                                                    }
                                                    if let engsubCat = curRole["Engineer"] as? NSMutableDictionary{
                                                        if var engsubrole = engsubCat["Mix Engineer"] as? [String]{
                                                            
                                                            for songTitles in engsubrole {
                                                                if songTitles == song.toneDeafAppId {
                                                                    rolesInOtherSongsOnTheAlbumArr.append("Mix Engineer")
                                                                }
                                                            }
                                                        }
                                                        if var mengsubrole = engsubCat["Mastering Engineer"] as? [String] {
                                                            for songTitles in mengsubrole {
                                                                if songTitles == song.toneDeafAppId {
                                                                    rolesInOtherSongsOnTheAlbumArr.append("Mastering Engineer")
                                                                }
                                                            }
                                                        }
                                                    }
                                                    
                                                }
                                            }
                                        }
                                    }
                                    for value in rolesOnTheAlbumArr {
                                        if !rolesInOtherSongsOnTheAlbumArr.contains(value) {
                                            if var curRole = roles {
                                                switch value {
                                                case "Artist":
                                                    if var prosubrole = (curRole["Artist"] as? [String]){
                                                        for songTitles in prosubrole {
                                                            if songTitles == alb.toneDeafAppId {
                                                                let elementIndex = prosubrole.firstIndex(of: songTitles)
                                                                prosubrole.remove(at: elementIndex!)
                                                            }
                                                        }
                                                        curRole["Artist"] = prosubrole.sorted()
                                                        if prosubrole.isEmpty {
                                                            curRole["Artist"] = nil
                                                        }
                                                    }
                                                    if let dex = alb.mainArtist.firstIndex(of: "\(strongSelf.currentPerson.toneDeafAppId)")
                                                    {
                                                        alb.mainArtist.remove(at: Int(dex))
                                                    }
                                                    if let dex = alb.allArtists?.firstIndex(of: "\(strongSelf.currentPerson.toneDeafAppId)")
                                                    {
                                                        alb.allArtists!.remove(at: Int(dex))
                                                    }
                                                    if let elementIndex2 = strongSelf.albumFeaturedArtistArr.firstIndex(of: alb.toneDeafAppId) {
                                                        strongSelf.albumFeaturedArtistArr.remove(at: elementIndex2)
                                                    }
                                                    if let elementIndex2 = strongSelf.albumMainArtistArr.firstIndex(of: alb.toneDeafAppId) {
                                                        strongSelf.albumMainArtistArr.remove(at: elementIndex2)
                                                    }
                                                case "Producer":
                                                    if var prosubrole = (curRole["Producer"] as? [String]){
                                                        for songTitles in prosubrole {
                                                            if songTitles == alb.toneDeafAppId {
                                                                let elementIndex = prosubrole.firstIndex(of: songTitles)
                                                                prosubrole.remove(at: elementIndex!)
                                                            }
                                                        }
                                                        curRole["Producer"] = prosubrole.sorted()
                                                        if prosubrole.isEmpty {
                                                            curRole["Producer"] = nil
                                                        }
                                                    }
                                                    if let dex = alb.producers.firstIndex(of: "\(strongSelf.currentPerson.toneDeafAppId)")
                                                    {
                                                        alb.producers.remove(at: Int(dex))
                                                    }
                                                case "Writer":
                                                    if var prosubrole = (curRole["Writer"] as? [String]){
                                                        for songTitles in prosubrole {
                                                            if songTitles == alb.toneDeafAppId {
                                                                let elementIndex = prosubrole.firstIndex(of: songTitles)
                                                                prosubrole.remove(at: elementIndex!)
                                                            }
                                                        }
                                                        curRole["Writer"] = prosubrole.sorted()
                                                        if prosubrole.isEmpty {
                                                            curRole["Writer"] = nil
                                                        }
                                                    }
                                                    if let dex = alb.writers?.firstIndex(of: "\(strongSelf.currentPerson.toneDeafAppId)")
                                                    {
                                                        alb.writers!.remove(at: Int(dex))
                                                    }
                                                case "Mix Engineer":
                                                    if let engsubCatt = curRole["Engineer"] as? NSDictionary{
                                                        let engsubCat = engsubCatt.mutableCopy() as! NSMutableDictionary
                                                        if var engsubrole = engsubCat["Mix Engineer"] as? [String]{
                                                            for songTitles in engsubrole {
                                                                if songTitles == alb.toneDeafAppId {
                                                                    let elementIndex = engsubrole.firstIndex(of: songTitles)
                                                                    engsubrole.remove(at: elementIndex!)
                                                                }
                                                            }
                                                            engsubCat["Mix Engineer"] = engsubrole.sorted()
                                                            if engsubrole.isEmpty {
                                                                engsubCat["Mix Engineer"] = nil
                                                            }
                                                        }
                                                        curRole["Engineer"] = engsubCat
                                                        if engsubCat.count == 0 {
                                                            curRole["Engineer"] = nil
                                                        }
                                                    }
                                                    if let dex = alb.mixEngineers?.firstIndex(of: "\(strongSelf.currentPerson.toneDeafAppId)")
                                                    {
                                                        alb.mixEngineers!.remove(at: Int(dex))
                                                    }
                                                case "Mastering Engineer":
                                                    if let engsubCatt = curRole["Engineer"] as? NSDictionary{
                                                        let engsubCat = engsubCatt.mutableCopy() as! NSMutableDictionary
                                                        if var engsubrole = engsubCat["Mastering Engineer"] as? [String]{
                                                            for songTitles in engsubrole {
                                                                if songTitles == alb.toneDeafAppId {
                                                                    let elementIndex = engsubrole.firstIndex(of: songTitles)
                                                                    engsubrole.remove(at: elementIndex!)
                                                                }
                                                            }
                                                            engsubCat["Mastering Engineer"] = engsubrole.sorted()
                                                            if engsubrole.isEmpty {
                                                                engsubCat["Mastering Engineer"] = nil
                                                            }
                                                        }
                                                        curRole["Engineer"] = engsubCat
                                                        if engsubCat.count == 0 {
                                                            curRole["Engineer"] = nil
                                                        }
                                                    }
                                                    if let dex = alb.masteringEngineers?.firstIndex(of: "\(strongSelf.currentPerson.toneDeafAppId)")
                                                    {
                                                        alb.masteringEngineers!.remove(at: Int(dex))
                                                    }
                                                case "Recording Engineer":
                                                    if let engsubCatt = curRole["Engineer"] as? NSDictionary{
                                                        let engsubCat = engsubCatt.mutableCopy() as! NSMutableDictionary
                                                        if var engsubrole = engsubCat["Recording Engineer"] as? [String]{
                                                            for songTitles in engsubrole {
                                                                if songTitles == alb.toneDeafAppId {
                                                                    let elementIndex = engsubrole.firstIndex(of: songTitles)
                                                                    engsubrole.remove(at: elementIndex!)
                                                                }
                                                            }
                                                            engsubCat["Recording Engineer"] = engsubrole.sorted()
                                                            if engsubrole.isEmpty {
                                                                engsubCat["Recording Engineer"] = nil
                                                            }
                                                        }
                                                        curRole["Engineer"] = engsubCat
                                                        if engsubCat.count == 0 {
                                                            curRole["Engineer"] = nil
                                                        }
                                                    }
                                                    if let dex = alb.recordingEngineers?.firstIndex(of: "\(strongSelf.currentPerson.toneDeafAppId)")
                                                    {
                                                        alb.recordingEngineers!.remove(at: Int(dex))
                                                    }
                                                default:
                                                    break
                                                    
                                                }
                                                
                                                strongSelf.currentPerson.roles = curRole
                                                strongSelf.initialPerson.roles = curRole
                                                
                                            }
                                            strongSelf.personAlbumsArr.sort(by: {$0.name < $1.name})
                                            strongSelf.personAlbumsTableView.reloadData()
                                        }
                                    }
                                }
                            }
                            count+=1
                        }
                    }
                }
                
                strongSelf.currentPerson.roles = ((newRoles as NSDictionary).mutableCopy() as! NSMutableDictionary)
                strongSelf.initialPerson.roles = ((newRoles as NSDictionary).mutableCopy() as! NSMutableDictionary)
                tableView.reloadData()
                strongSelf.personAlbumsArr.sort(by: {$0.name < $1.name})
                strongSelf.personAlbumsTableView.reloadData()
            })
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
            { (action) in
                // ...
            }
            alertController.addAction(cancelAction)
            alertController.addAction(addAction)
            alertController.addAction(editAction)
            var rolearrr:[String] = []
            let art = personSongsArr[indexPath.row].songArtist
            for artist in art {
                if artist.contains(currentPerson.toneDeafAppId) {
                    if !rolearrr.contains("Artist") {
                        rolearrr.append("Artist")
                    }
                }
            }
            let pro = personSongsArr[indexPath.row].songProducers
            for producer in pro {
                if producer.contains(currentPerson.toneDeafAppId) {
                    if !rolearrr.contains("Producer") {
                        rolearrr.append("Producer")
                    }
                }
            }
            if let wri = personSongsArr[indexPath.row].songWriters {
                for writer in wri {
                    if writer.contains(currentPerson.toneDeafAppId) {
                        if !rolearrr.contains("Writer") {
                            rolearrr.append("Writer")
                        }
                    }
                }
            }
            if let mixeng = personSongsArr[indexPath.row].songMixEngineer {
                for engie in mixeng {
                    if engie.contains(currentPerson.toneDeafAppId) {
                        if !rolearrr.contains("Mix Engineer") {
                            rolearrr.append("Mix Engineer")
                        }
                    }
                }
            }
            if let masteng = personSongsArr[indexPath.row].songMasteringEngineer {
                for engie in masteng {
                    if engie.contains(currentPerson.toneDeafAppId) {
                        if !rolearrr.contains("Mastering Engineer") {
                            rolearrr.append("Mastering Engineer")
                        }
                    }
                }
            }
            if let receng = personSongsArr[indexPath.row].songRecordingEngineer {
                for engie in receng {
                    if engie.contains(currentPerson.toneDeafAppId) {
                        if !rolearrr.contains("Recording Engineer") {
                            rolearrr.append("Recording Engineer")
                        }
                    }
                }
            }
            alertController.view.tintColor = Constants.Colors.redApp

            
            alertController.view.tintColor = UIColor.init(red: 182/255, green: 0/255, blue: 3/255, alpha: 1)
            self.present(alertController, animated: true)
            {
                let cc = alertController.value(forKey: "contentViewController") as! EditPersonRolesPopoverTableViewController
                for i in 1 ... (cc.roleArr.count) {
                    let cell = cc.tableViewPopover.cellForRow(at: IndexPath(row: i-1, section: 0)) as! EditRolePopoverTableCellController
                    if rolearrr.contains(cell.role.text!) {
                        cell.checkbox.setOn(true, animated: false)
                    }
                }
            }
        case personAlbumsTableView:
            //MARK: - didSelect Albums
            let songToGo = personAlbumsArr[indexPath.row]
            let songID = "\(songToGo.toneDeafAppId)"
            alertController = UIAlertController(title: "Change roles for \(personAlbumsArr[indexPath.row].name)",
                                                    message: "Select Roles",
                                                    preferredStyle: .alert)
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc3 = storyboard.instantiateViewController(identifier: "editPersonRolesPopoverTableViewController") as
            EditPersonRolesPopoverTableViewController
            vc3.preferredContentSize = CGSize(width: 350, height: 420)
            vc3.roleArr.remove(at: 0)
            vc3.roleArr.insert("Featured Artist", at: 0)
            vc3.roleArr.insert("Main Artist", at: 0)
            if personAlbumsArr[indexPath.row].songs == nil {
                vc3.roleArr.remove(at: 6)
                vc3.roleArr.remove(at: 3)
                vc3.preferredContentSize = CGSize(width: 350, height: 300)
            }
            vc3.tableView.isScrollEnabled = false
            vc3.tableView.reloadData()
            alertController.setValue(vc3, forKey: "contentViewController")
            
            let selectalbumrole = personAlbumsArr[indexPath.row]
            
            let editAction = UIAlertAction(title: "Edit \(personAlbumsArr[indexPath.row].name)", style: .default, handler: { _ in
                
            })
            
            
            var initsongsAsArtistRole:[String] = []
            var initsongsAsProducerRole:[String] = []
            var initsongsAsWriterRole:[String] = []
            var initsongsAsMixEngRole:[String] = []
            var initsongsAsMasteringEngRole:[String] = []
            var initsongsAsRecordingEngRole:[String] = []
            var initAllSongsWithRoleAttached:[String] = Array(GlobalFunctions.shared.combine(initsongsAsArtistRole,initsongsAsProducerRole,initsongsAsWriterRole,initsongsAsMixEngRole,initsongsAsMasteringEngRole,initsongsAsRecordingEngRole))
            
            let addAction = UIAlertAction(title: "Update Roles", style: .default, handler: {[weak self] _ in
                guard let strongSelf = self else {return}
                var newRoleArr:[String] = []
                let cc = alertController.value(forKey: "contentViewController") as! EditPersonRolesPopoverTableViewController
                for i in 1 ... (cc.roleArr.count) {
                    if let cell = cc.tableView.cellForRow(at: IndexPath(row: i-1, section: 0)) as? EditRolePopoverTableCellController {
                        if cell.checkbox.on {
                            newRoleArr.append(cell.role.text!)
                        }
                    }
                }
                let tracksAndRoles:NSMutableDictionary = [:]
                DispatchQueue.global(qos: .userInitiated).async {[weak self] in
                    guard let strongSelf = self else {return}
                    
                    
                    if !newRoleArr.isEmpty {
                        let semaphore = DispatchSemaphore(value: 0)
                        let semap = DispatchSemaphore(value: 0)
                        var counter = 0
                        for i in 0 ... newRoleArr.count-1 {
                            if newRoleArr.contains("Main Artist") && newRoleArr[i] == "Featured Artist" {
                                counter+=1
                                if newRoleArr.count != 1 {
                                    semap.signal()
                                }
                                if counter == newRoleArr.count {
                                    semaphore.signal()
                                }
                            } else {
                                DispatchQueue.main.async {
                                    guard let strongSelf = self else {return}
                                    let alertC = UIAlertController(title: "\(newRoleArr[i]) Role",
                                                                   message: "Please select the tracks that \(strongSelf.currentPerson.name!) appears as a \(newRoleArr[i])",
                                                                   preferredStyle: .alert)
                                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                                    let vc3 = storyboard.instantiateViewController(identifier: "editPersonRolesSongsForAlbumPopoverTableViewController") as
                                    EditPersonRolesSongsForAlbumPopoverTableViewController
                                    vc3.preferredContentSize = CGSize(width: 350, height: 350) // 4 default cell heights.
                                    vc3.trackArr = selectalbumrole.tracks
                                    if newRoleArr[i] == "Writer" || newRoleArr[i] == "Recording Engineer" {
                                        for track in vc3.trackArr {
                                            if track.value.count == 12 {
                                                vc3.trackArr.removeValue(forKey: track.key)
                                            }
                                        }
                                    }
                                    alertC.setValue(vc3, forKey: "contentViewController")
                                    
                                    let okAction = UIAlertAction(title: "Select", style: .default, handler: {[weak self] _ in
                                        guard let strongSelf = self else {return}
                                        var tracksForCurrentRole:[String] = []
                                        let cc = alertC.value(forKey: "contentViewController") as! EditPersonRolesSongsForAlbumPopoverTableViewController
                                        for i in 0 ... (cc.trackArr.count) {
                                            if let cell = cc.tableViewPopover.cellForRow(at: IndexPath(row: i, section: 0)) as? EditRolesSongsForAlbumPopoverTableCellController {
                                                if cell.checkbox.on {
                                                    tracksForCurrentRole.append(cell.appId.text!)
                                                }
                                            }
                                        }
                                        tracksAndRoles[newRoleArr[i]] = tracksForCurrentRole
                                        counter+=1
                                        alertC.dismiss(animated: true, completion: nil)
                                        if newRoleArr.count != 1 {
                                            semap.signal()
                                        }
                                        if counter == newRoleArr.count {
                                            semaphore.signal()
                                        }
                                    })
                                    alertC.addAction(okAction)
                                    alertC.view.tintColor = Constants.Colors.redApp
                                    strongSelf.present(alertC, animated: true) {
                                        let cc = alertC.value(forKey: "contentViewController") as! EditPersonRolesSongsForAlbumPopoverTableViewController
                                        for a in 0 ... (cc.trackArr.count) {
                                            if let cell = cc.tableViewPopover.cellForRow(at: IndexPath(row: a-1, section: 0)) as? EditRolesSongsForAlbumPopoverTableCellController {
                                                if let curRoles = strongSelf.currentPerson.roles as? NSDictionary {
                                                    switch newRoleArr[i] {
                                                    case "Main Artist", "Featured Artist":
                                                        if let arrrrole = curRoles["Artist"] as? [String] {
                                                            if arrrrole.contains(cell.appId.text!) {
                                                                cell.checkbox.setOn(true, animated: false)
                                                            }
                                                        }
                                                    case "Producer":
                                                        if let arrrrole = curRoles["Producer"] as? [String] {
                                                            if arrrrole.contains(cell.appId.text!) {
                                                                cell.checkbox.setOn(true, animated: false)
                                                            }
                                                        }
                                                    case "Writer":
                                                        if let arrrrole = curRoles["Writer"] as? [String] {
                                                            if arrrrole.contains(cell.appId.text!) {
                                                                cell.checkbox.setOn(true, animated: false)
                                                            }
                                                        }
                                                    case "Mix Engineer":
                                                        if let engie = curRoles["Engineer"] as? NSDictionary {
                                                            let engiedict = engie.mutableCopy() as! NSMutableDictionary
                                                            if let arrrrole = engiedict["Mix Engineer"] as? [String] {
                                                                if arrrrole.contains(cell.appId.text!) {
                                                                    cell.checkbox.setOn(true, animated: false)
                                                                }
                                                            }
                                                        }
                                                    case "Mastering Engineer":
                                                        if let engie = curRoles["Engineer"] as? NSDictionary {
                                                            let engiedict = engie.mutableCopy() as! NSMutableDictionary
                                                            if let arrrrole = engiedict["Mastering Engineer"] as? [String] {
                                                                if arrrrole.contains(cell.appId.text!) {
                                                                    cell.checkbox.setOn(true, animated: false)
                                                                }
                                                            }
                                                        }
                                                    case "Recording Engineer":
                                                        if let engie = curRoles["Engineer"] as? NSDictionary {
                                                            let engiedict = engie.mutableCopy() as! NSMutableDictionary
                                                            if let arrrrole = engiedict["Recording Engineer"] as? [String] {
                                                                if arrrrole.contains(cell.appId.text!) {
                                                                    cell.checkbox.setOn(true, animated: false)
                                                                }
                                                            }
                                                        }
                                                    default:
                                                        break
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                            if newRoleArr.count != 1 {
                                semap.wait()
                            }
                        }
                        
                        semaphore.wait()
                    }
//                    print(String(data: try! JSONSerialization.data(withJSONObject: tracksAndRoles, options: .prettyPrinted), encoding: .utf8)!)
                    var songsAsArtistRole:[String] = []
                    var songsAsProducerRole:[String] = []
                    var songsAsWriterRole:[String] = []
                    var songsAsMixEngRole:[String] = []
                    var songsAsMasteringEngRole:[String] = []
                    var songsAsRecordingEngRole:[String] = []
                    if let arrrrr = tracksAndRoles["Main Artist"] as? [String] {
                        songsAsArtistRole = Array(GlobalFunctions.shared.combine(arrrrr,songsAsArtistRole))
                    }
                    if let arrrrr = tracksAndRoles["Featured Artist"] as? [String] {
                        songsAsArtistRole = Array(GlobalFunctions.shared.combine(arrrrr,songsAsArtistRole))
                    }
                    if let arrrrr = tracksAndRoles["Producer"] as? [String] {
                        songsAsProducerRole = Array(GlobalFunctions.shared.combine(arrrrr,songsAsProducerRole))
                    }
                    if let arrrrr = tracksAndRoles["Writer"] as? [String] {
                        songsAsWriterRole = Array(GlobalFunctions.shared.combine(arrrrr,songsAsWriterRole))
                    }
                    if let arrrrr = tracksAndRoles["Mix Engineer"] as? [String] {
                        songsAsMixEngRole = Array(GlobalFunctions.shared.combine(arrrrr,songsAsMixEngRole))
                    }
                    if let arrrrr = tracksAndRoles["Mastering Engineer"] as? [String] {
                        songsAsMasteringEngRole = Array(GlobalFunctions.shared.combine(arrrrr,songsAsMasteringEngRole))
                    }
                    if let arrrrr = tracksAndRoles["Recording Engineer"] as? [String] {
                        songsAsRecordingEngRole = Array(GlobalFunctions.shared.combine(arrrrr,songsAsRecordingEngRole))
                    }
                    let allSongsWithRoleAttached:[String] = Array(GlobalFunctions.shared.combine(songsAsArtistRole,songsAsProducerRole,songsAsWriterRole,songsAsMixEngRole,songsAsMasteringEngRole,songsAsRecordingEngRole))
                    
                    var innercount = 0
                    for track in allSongsWithRoleAttached {
                        switch track.value.count {
                        case 10:
                            DispatchQueue.main.async {
                            DatabaseManager.shared.findSongById(songId: track.value, completion: { result in
                                DispatchQueue.global(qos: .userInitiated).async {
                                switch result {
                                case.success(let song):
                                    let person = strongSelf.currentPerson.toneDeafAppId
                                    if songsAsArtistRole.contains(song.toneDeafAppId) {
                                        if !song.songArtist.contains(person) {
                                            song.songArtist.append(person)
                                        }
                                    } else {
                                        if let dex = song.songArtist.firstIndex(of: "\(person)")
                                        {
                                            song.songArtist.remove(at: Int(dex))
                                        }
                                    }
                                    if songsAsProducerRole.contains(song.toneDeafAppId) {
                                        if !song.songProducers.contains(person) {
                                            song.songProducers.append(person)
                                        }
                                    } else {
                                        if let dex = song.songProducers.firstIndex(of: "\(person)")
                                        {
                                            song.songProducers.remove(at: Int(dex))
                                        }
                                    }
                                    if songsAsWriterRole.contains(song.toneDeafAppId) {
                                        if var arr3 = song.songWriters as? [String] {
                                            if !arr3.contains(person) {
                                                arr3.append(person)
                                            }
                                            song.songWriters = arr3
                                        } else {
                                            var arr3:[String] = []
                                            arr3.append(person)
                                            song.songWriters = arr3
                                        }
                                    } else {
                                        if let dex = song.songWriters?.firstIndex(of: "\(person)")
                                        {
                                            song.songWriters!.remove(at: Int(dex))
                                        }
                                    }
                                    if songsAsMixEngRole.contains(song.toneDeafAppId) {
                                        if var arr3 = song.songMixEngineer as? [String] {
                                            if !arr3.contains(person) {
                                                arr3.append(person)
                                            }
                                            song.songMixEngineer = arr3
                                        } else {
                                            var arr3:[String] = []
                                            arr3.append(person)
                                            song.songMixEngineer = arr3
                                        }
                                    } else {
                                        if let dex = song.songMixEngineer?.firstIndex(of: "\(person)")
                                        {
                                            song.songMixEngineer!.remove(at: Int(dex))
                                        }
                                    }
                                    if songsAsMasteringEngRole.contains(song.toneDeafAppId) {
                                        if var arr3 = song.songMasteringEngineer as? [String] {
                                            if !arr3.contains(person) {
                                                arr3.append(person)
                                            }
                                            song.songMasteringEngineer = arr3
                                        } else {
                                            var arr3:[String] = []
                                            arr3.append(person)
                                            song.songMasteringEngineer = arr3
                                        }
                                    } else {
                                        if let dex = song.songMasteringEngineer?.firstIndex(of: "\(person)")
                                        {
                                            song.songMasteringEngineer!.remove(at: Int(dex))
                                        }
                                    }
                                    if songsAsRecordingEngRole.contains(song.toneDeafAppId) {
                                        if var arr3 = song.songRecordingEngineer as? [String] {
                                            if !arr3.contains(person) {
                                                arr3.append(person)
                                            }
                                            song.songRecordingEngineer = arr3
                                        } else {
                                            var arr3:[String] = []
                                            arr3.append(person)
                                            song.songRecordingEngineer = arr3
                                        }
                                    } else {
                                        if let dex = song.songRecordingEngineer?.firstIndex(of: "\(person)")
                                        {
                                            song.songRecordingEngineer!.remove(at: Int(dex))
                                        }
                                    }
                                    var containedIn:Bool = false
                                    var pson:SongData!
                                    for psong in strongSelf.personSongsArr {
                                        if psong.toneDeafAppId == song.toneDeafAppId {
                                            containedIn = true
                                            pson = psong
                                        }
                                    }
                                    if !containedIn {
                                        strongSelf.personSongsArr.append(song)
                                    } else {
                                        let dex = strongSelf.personSongsArr.firstIndex(of: pson)
                                        strongSelf.personSongsArr[dex!] = song
                                    }
                                    if strongSelf.currentPerson.songs == nil {
                                        strongSelf.currentPerson.songs = ["\(song.toneDeafAppId)"]
                                    } else {
                                        if !strongSelf.currentPerson.songs!.contains(song.toneDeafAppId) {
                                            strongSelf.currentPerson.songs!.append("\(song.toneDeafAppId)")
                                        }
                                    }
                                        DispatchQueue.main.async {[weak self]  in
                                            guard let strongSelf = self else {return}
                                            strongSelf.personSongsTableView.reloadData()
                                            if strongSelf.personSongsArr.count < 6 {
                                                strongSelf.personSongsHeightConstraint.constant = CGFloat(50*(strongSelf.personSongsArr.count))
                                            } else {
                                                strongSelf.personSongsHeightConstraint.constant = CGFloat(270)
                                            }
                                        }
                                case.failure(let err):
                                    innercount+=1
                                    print("A Bad Error ", err)
                                }
                                }
                            })
                            }
                        case 12:
                            DispatchQueue.main.async {
                            DatabaseManager.shared.findInstrumentalById(instrumentalId: track.value, completion: { result in
                                DispatchQueue.global(qos: .userInitiated).async {
                                switch result {
                                case.success(let song):
                                    let person = strongSelf.currentPerson.toneDeafAppId
                                    if songsAsArtistRole.contains(song.toneDeafAppId) {
                                        if var arr3 = song.artist as? [String] {
                                            if !arr3.contains(person) {
                                                arr3.append(person)
                                            }
                                            song.artist = arr3
                                        } else {
                                            var arr3:[String] = []
                                            arr3.append(person)
                                            song.artist = arr3
                                        }
                                    } else {
                                        if let dex = song.artist?.firstIndex(of: "\(person)")
                                        {
                                            song.artist!.remove(at: Int(dex))
                                        }
                                    }
                                    if songsAsProducerRole.contains(song.toneDeafAppId) {
                                        if !song.producers.contains(person) {
                                            song.producers.append(person)
                                        }
                                    } else {
                                        if let dex = song.producers.firstIndex(of: "\(person)")
                                        {
                                            song.producers.remove(at: Int(dex))
                                        }
                                    }
                                    if songsAsMixEngRole.contains(song.toneDeafAppId) {
                                        if var arr3 = song.mixEngineer as? [String] {
                                            if !arr3.contains(person) {
                                                arr3.append(person)
                                            }
                                            song.mixEngineer = arr3
                                        } else {
                                            var arr3:[String] = []
                                            arr3.append(person)
                                            song.mixEngineer = arr3
                                        }
                                    } else {
                                        if let dex = song.mixEngineer?.firstIndex(of: "\(person)")
                                        {
                                            song.mixEngineer!.remove(at: Int(dex))
                                        }
                                    }
                                    if songsAsMasteringEngRole.contains(song.toneDeafAppId) {
                                        if var arr3 = song.masteringEngineer as? [String] {
                                            if !arr3.contains(person) {
                                                arr3.append(person)
                                            }
                                            song.masteringEngineer = arr3
                                        } else {
                                            var arr3:[String] = []
                                            arr3.append(person)
                                            song.masteringEngineer = arr3
                                        }
                                    } else {
                                        if let dex = song.masteringEngineer?.firstIndex(of: "\(person)")
                                        {
                                            song.masteringEngineer!.remove(at: Int(dex))
                                        }
                                    }
                                    var containedIn:Bool = false
                                    var pson:InstrumentalData!
                                    for psong in strongSelf.personInstrumentalsArr {
                                        if psong.toneDeafAppId == song.toneDeafAppId {
                                            containedIn = true
                                            pson = psong
                                        }
                                    }
                                    if !containedIn {
                                        strongSelf.personInstrumentalsArr.append(song)
                                    } else {
                                        let dex = strongSelf.personInstrumentalsArr.firstIndex(of: pson)
                                        strongSelf.personInstrumentalsArr[dex!] = song
                                    }
                                    if strongSelf.currentPerson.instrumentals == nil {
                                        strongSelf.currentPerson.instrumentals = ["\(song.toneDeafAppId)"]
                                    } else {
                                        if !strongSelf.currentPerson.instrumentals!.contains(song.toneDeafAppId) {
                                            strongSelf.currentPerson.instrumentals!.append("\(song.toneDeafAppId)")
                                        }
                                    }
                                    DispatchQueue.main.async {[weak self]  in
                                        guard let strongSelf = self else {return}
                                        strongSelf.personInstrumentalsArr.sort(by: {$0.songName! < $1.songName!})
                                        strongSelf.personInstrumentalsTableView.reloadData()
                                        strongSelf.personInstrumentalsHeightConstraint.constant = CGFloat(50*(strongSelf.personInstrumentalsArr.count))
                                    }
                                case.failure(let err):
                                    innercount+=1
                                    print("A Bad Error ", err)
                                }
                                }
                            })
                            }
                        default:
                            break
                        }
                        
                    }
                    for track in initAllSongsWithRoleAttached {
                        if !allSongsWithRoleAttached.contains(track) {
                            switch track.value.count {
                            case 10:
                                for song in strongSelf.personSongsArr {
                                    if song.toneDeafAppId == track.value {
                                        if let dex = strongSelf.personSongsArr.firstIndex(of: song)
                                        {
                                            strongSelf.personSongsArr.remove(at: dex)
                                        }
                                        if let dex = strongSelf.currentPerson.songs?.firstIndex(of: song.toneDeafAppId)
                                        {
                                            strongSelf.currentPerson.songs!.remove(at: dex)
                                        }
                                    }
                                }
                                
                                DispatchQueue.main.async {[weak self]  in
                                    guard let strongSelf = self else {return}
                                    strongSelf.personSongsTableView.reloadData()
                                    if strongSelf.personSongsArr.count < 6 {
                                        strongSelf.personSongsHeightConstraint.constant = CGFloat(50*(strongSelf.personSongsArr.count))
                                    } else {
                                        strongSelf.personSongsHeightConstraint.constant = CGFloat(270)
                                    }
                                }
                            case 12:
                                for instrumental in strongSelf.personInstrumentalsArr {
                                    if instrumental.toneDeafAppId == track.value {
                                        if let dex = strongSelf.personInstrumentalsArr.firstIndex(of: instrumental)
                                        {
                                            strongSelf.personInstrumentalsArr.remove(at: dex)
                                        }
                                        if let dex = strongSelf.currentPerson.instrumentals?.firstIndex(of: instrumental.toneDeafAppId)
                                        {
                                            strongSelf.currentPerson.instrumentals!.remove(at: dex)
                                        }
                                    }
                                }
                                DispatchQueue.main.async {[weak self]  in
                                    guard let strongSelf = self else {return}
                                    strongSelf.personInstrumentalsArr.sort(by: {$0.songName! < $1.songName!})
                                    strongSelf.personInstrumentalsTableView.reloadData()
                                    strongSelf.personInstrumentalsHeightConstraint.constant = CGFloat(50*(strongSelf.personInstrumentalsArr.count))
                                }
                            default:
                                break
                            }
                        }
                    }
                    
                    var roles:NSMutableDictionary?
                    roles = strongSelf.currentPerson.roles
                    if roles == nil {
                        roles = [:]
                    }
                    var newRoles:NSMutableDictionary = roles!
                    var engineerDict:[String:Any?] = [:]
                    if let engies = newRoles["Engineer"] as? [String:Any?] {
                        engineerDict = engies
                    }
                    if newRoleArr.contains("Main Artist") {
                        if !selectalbumrole.mainArtist.contains(strongSelf.currentPerson.toneDeafAppId) {
                            selectalbumrole.mainArtist.append("\(strongSelf.currentPerson.toneDeafAppId)")
                        }
                        var hasArtistsSongs:Bool = false
                        for ele in songsAsArtistRole {
                            if ele.count == 10 {
                                hasArtistsSongs = true
                            }
                        }
                        
                        if hasArtistsSongs == true {
                            if let curRole = roles as? NSMutableDictionary {
                                if var subrole = curRole["Artist"] as? [String]{
                                    if !subrole.contains(selectalbumrole.toneDeafAppId) {
                                        subrole.append("\(selectalbumrole.toneDeafAppId)")
                                    }
                                    for track in songsAsArtistRole {
                                        if !subrole.contains(track) {
                                            subrole.append(track)
                                        }
                                    }
                                    newRoles["Artist"] = subrole.sorted()
                                    
                                } else {
                                    var subrole = ["\(selectalbumrole.toneDeafAppId)"]
                                    subrole.append(contentsOf: songsAsArtistRole)
                                    newRoles["Artist"] = subrole.sorted()
                                }
                            }
                            else {
                                var subrole = ["\(selectalbumrole.toneDeafAppId)"]
                                subrole.append(contentsOf: songsAsArtistRole)
                                newRoles["Artist"] = subrole.sorted()
                            }
                            
                            if var art = selectalbumrole.allArtists {
                                if !art.contains(strongSelf.currentPerson.toneDeafAppId) {
                                    art.append("\(strongSelf.currentPerson.toneDeafAppId)")
                                }
                                selectalbumrole.allArtists = art
                            } else {
                                selectalbumrole.allArtists = ["\(strongSelf.currentPerson.toneDeafAppId)"]
                            }
                            if !strongSelf.albumFeaturedArtistArr.contains(selectalbumrole.toneDeafAppId) {
                                strongSelf.albumFeaturedArtistArr.append(selectalbumrole.toneDeafAppId)
                            }
                        } else {
                            var arrrr = newRoleArr
                            if arrrr.contains("Featured Artist") {
                                if let dex = arrrr.firstIndex(of: "Featured Artist") {
                                    arrrr.remove(at: dex)
                                }
                                newRoleArr = arrrr
                            }
                        }
                        
                        if !strongSelf.albumMainArtistArr.contains(selectalbumrole.toneDeafAppId) {
                            strongSelf.albumMainArtistArr.append(selectalbumrole.toneDeafAppId)
                        }
                    } else {
                        if let dex = selectalbumrole.mainArtist.firstIndex(of: "\(strongSelf.currentPerson.toneDeafAppId)")
                        {selectalbumrole.mainArtist.remove(at: Int(dex))}
                        if var arrrr = newRoles["Artist"] as? [String] {
                            if let dex = arrrr.firstIndex(of: "\(selectalbumrole.toneDeafAppId)")
                            {
                                arrrr.remove(at: dex)
                                if !arrrr.isEmpty {
                                    newRoles["Artist"] = arrrr.sorted()
                                } else {
                                    newRoles["Artist"] = nil
                                }
                            }
                            for track in initsongsAsArtistRole {
                                if let dex = arrrr.firstIndex(of: track)
                                {
                                    arrrr.remove(at: dex)
                                    if !arrrr.isEmpty {
                                        newRoles["Artist"] = arrrr.sorted()
                                    } else {
                                        newRoles["Artist"] = nil
                                    }
                                }
                            }
                        }
                        if strongSelf.albumMainArtistArr.contains(selectalbumrole.toneDeafAppId) {
                            if let dex = strongSelf.albumMainArtistArr.firstIndex(of: "\(selectalbumrole.toneDeafAppId)")
                            {
                                strongSelf.albumMainArtistArr.remove(at: dex)
                            }
                        }
                    }
                    if newRoleArr.contains("Featured Artist") {
                        if var art = selectalbumrole.allArtists {
                            if !art.contains(strongSelf.currentPerson.toneDeafAppId) {
                                art.append("\(strongSelf.currentPerson.toneDeafAppId)")
                            }
                            selectalbumrole.allArtists = art
                        } else {
                            selectalbumrole.allArtists = ["\(strongSelf.currentPerson.toneDeafAppId)"]
                        }
                        var hasArtistsSongs:Bool = false
                        for ele in songsAsArtistRole {
                            if ele.count == 10 {
                                hasArtistsSongs = true
                            }
                        }
                        
                        if hasArtistsSongs == true {
                            if let curRole = roles as? NSMutableDictionary {
                                if var subrole = curRole["Artist"] as? [String]{
                                    if !subrole.contains(selectalbumrole.toneDeafAppId) {
                                        subrole.append("\(selectalbumrole.toneDeafAppId)")
                                    }
                                    for track in songsAsArtistRole {
                                        if !subrole.contains(track) {
                                            subrole.append(track)
                                        }
                                    }
                                    newRoles["Artist"] = subrole.sorted()
                                    
                                } else {
                                    var subrole = ["\(selectalbumrole.toneDeafAppId)"]
                                    subrole.append(contentsOf: songsAsArtistRole)
                                    newRoles["Artist"] = subrole.sorted()
                                }
                            }
                            else {
                                var subrole = ["\(selectalbumrole.toneDeafAppId)"]
                                subrole.append(contentsOf: songsAsArtistRole)
                                newRoles["Artist"] = subrole.sorted()
                            }
                        }
                        if !strongSelf.albumFeaturedArtistArr.contains(selectalbumrole.toneDeafAppId) {
                            strongSelf.albumFeaturedArtistArr.append(selectalbumrole.toneDeafAppId)
                        }
                        
                    } else {
                        if let dex = selectalbumrole.allArtists?.firstIndex(of: "\(strongSelf.currentPerson.toneDeafAppId)")
                        {
                            selectalbumrole.allArtists!.remove(at: Int(dex))
                            
                        }
                        if var arrrr = newRoles["Artist"] as? [String] {
                            if let dex = arrrr.firstIndex(of: "\(selectalbumrole.toneDeafAppId)")
                            {
                                arrrr.remove(at: dex)
                                if !arrrr.isEmpty {
                                    newRoles["Artist"] = arrrr.sorted()
                                } else {
                                    newRoles["Artist"] = nil
                                }
                            }
                            for track in initsongsAsArtistRole {
                                if let dex = arrrr.firstIndex(of: track)
                                {
                                    arrrr.remove(at: dex)
                                    if !arrrr.isEmpty {
                                        newRoles["Artist"] = arrrr.sorted()
                                    } else {
                                        newRoles["Artist"] = nil
                                    }
                                }
                            }
                        }
                        if strongSelf.albumFeaturedArtistArr.contains(selectalbumrole.toneDeafAppId) {
                            if let dex = strongSelf.albumFeaturedArtistArr.firstIndex(of: "\(selectalbumrole.toneDeafAppId)")
                            {
                                strongSelf.albumFeaturedArtistArr.remove(at: dex)
                            }
                        }
                    }
                    if newRoleArr.contains("Producer") {
                        if !selectalbumrole.producers.contains(strongSelf.currentPerson.toneDeafAppId) {
                            selectalbumrole.producers.append("\(strongSelf.currentPerson.toneDeafAppId)")
                        }
                        if let curRole = roles as? NSMutableDictionary {
                            if var subrole = curRole["Producer"] as? [String]{
                                if !subrole.contains(selectalbumrole.toneDeafAppId) {
                                    subrole.append("\(selectalbumrole.toneDeafAppId)")
                                }
                                for track in songsAsProducerRole {
                                    if !subrole.contains(track) {
                                        subrole.append(track)
                                    }
                                }
                                newRoles["Producer"] = subrole.sorted()
                            } else {
                                var subrole = ["\(selectalbumrole.toneDeafAppId)"]
                                subrole.append(contentsOf: songsAsProducerRole)
                                newRoles["Producer"] = subrole.sorted()
                            }
                        }
                        else {
                            var subrole = ["\(selectalbumrole.toneDeafAppId)"]
                            subrole.append(contentsOf: songsAsProducerRole)
                            newRoles["Producer"] = subrole.sorted()
                        }
                    } else {
                        if let dex = selectalbumrole.producers.firstIndex(of: "\(strongSelf.currentPerson.toneDeafAppId)")
                        {selectalbumrole.producers.remove(at: Int(dex))}
                        if var arrrr = newRoles["Producer"] as? [String] {
                            if let dex = arrrr.firstIndex(of: "\(selectalbumrole.toneDeafAppId)")
                            {
                                arrrr.remove(at: dex)
                                if !arrrr.isEmpty {
                                    newRoles["Producer"] = arrrr.sorted()
                                } else {
                                    newRoles["Producer"] = nil
                                }
                            }
                            for track in initsongsAsProducerRole {
                                if let dex = arrrr.firstIndex(of: track)
                                {
                                    arrrr.remove(at: dex)
                                    if !arrrr.isEmpty {
                                        newRoles["Producer"] = arrrr.sorted()
                                    } else {
                                        newRoles["Producer"] = nil
                                    }
                                }
                            }
                        }
                    }
                    if newRoleArr.contains("Writer") {
                        if var art = selectalbumrole.writers {
                            if !art.contains(strongSelf.currentPerson.toneDeafAppId) {
                                art.append("\(strongSelf.currentPerson.toneDeafAppId)")
                            }
                            selectalbumrole.writers = art.sorted()
                        } else {
                            selectalbumrole.writers = ["\(strongSelf.currentPerson.toneDeafAppId)"]
                        }
                        if let curRole = roles as? NSMutableDictionary {
                            if var subrole = curRole["Writer"] as? [String]{
                                if !subrole.contains(selectalbumrole.toneDeafAppId) {
                                    subrole.append("\(selectalbumrole.toneDeafAppId)")
                                }
                                for track in songsAsWriterRole {
                                    if !subrole.contains(track) {
                                        subrole.append(track)
                                    }
                                }
                                newRoles["Writer"] = subrole.sorted()
                            } else {
                                var subrole = ["\(selectalbumrole.toneDeafAppId)"]
                                subrole.append(contentsOf: songsAsWriterRole)
                                newRoles["Writer"] = subrole.sorted()
                            }
                        }
                        else {
                            var subrole = ["\(selectalbumrole.toneDeafAppId)"]
                            subrole.append(contentsOf: songsAsWriterRole)
                            newRoles["Writer"] = subrole.sorted()
                        }
                    } else {
                        if let dex = selectalbumrole.writers?.firstIndex(of: "\(strongSelf.currentPerson.toneDeafAppId)")
                        {
                            selectalbumrole.writers!.remove(at: Int(dex))
                        }
                        if var arrrr = newRoles["Writer"] as? [String] {
                            if let dex = arrrr.firstIndex(of: "\(selectalbumrole.toneDeafAppId)")
                            {
                                arrrr.remove(at: dex)
                                if !arrrr.isEmpty {
                                    newRoles["Writer"] = arrrr.sorted()
                                } else {
                                    newRoles["Writer"] = nil
                                }
                            }
                            for track in initsongsAsWriterRole {
                                if let dex = arrrr.firstIndex(of: track)
                                {
                                    arrrr.remove(at: dex)
                                    if !arrrr.isEmpty {
                                        newRoles["Writer"] = arrrr.sorted()
                                    } else {
                                        newRoles["Writer"] = nil
                                    }
                                }
                            }
                        }
                    }
                    if newRoleArr.contains("Mix Engineer") {
                        if var art = selectalbumrole.mixEngineers {
                            if !art.contains(strongSelf.currentPerson.toneDeafAppId) {
                                art.append("\(strongSelf.currentPerson.toneDeafAppId)")
                            }
                            selectalbumrole.mixEngineers = art.sorted()
                    } else {
                        selectalbumrole.mixEngineers = ["\(strongSelf.currentPerson.toneDeafAppId)"]
                    }
                        if let curRole = roles as? NSMutableDictionary {
                            if let subCa = curRole["Engineer"] as? NSDictionary {
                                let subCat = subCa.mutableCopy() as! NSMutableDictionary
                                if var subrole = subCat["Mix Engineer"] as? [String]{
                                    if !subrole.contains(selectalbumrole.toneDeafAppId) {
                                        subrole.append("\(selectalbumrole.toneDeafAppId)")
                                    }
                                    for track in songsAsMixEngRole {
                                        if !subrole.contains(track) {
                                            subrole.append(track)
                                        }
                                    }
                                    subCat["Mix Engineer"] = subrole
                                    engineerDict["Mix Engineer"] = subrole.sorted()
                                } else {
                                    var subrole = ["\(selectalbumrole.toneDeafAppId)"]
                                    subrole.append(contentsOf: songsAsMixEngRole)
                                    subCat["Mix Engineer"] = subrole
                                    engineerDict["Mix Engineer"] = subrole.sorted()
                                }
                            } else {
                                var subrole = ["\(selectalbumrole.toneDeafAppId)"]
                                subrole.append(contentsOf: songsAsMixEngRole)
                                engineerDict["Mix Engineer"] = subrole.sorted()
                            }
                        } else {
                            var subrole = ["\(selectalbumrole.toneDeafAppId)"]
                            subrole.append(contentsOf: songsAsMixEngRole)
                            engineerDict["Mix Engineer"] = subrole.sorted()
                        }
                    } else {
                        if let dex = selectalbumrole.mixEngineers?.firstIndex(of: "\(strongSelf.currentPerson.toneDeafAppId)")
                        {
                            selectalbumrole.mixEngineers!.remove(at: Int(dex))
                        }
                        if var arrrr = engineerDict["Mix Engineer"] as? [String] {
                            if let dex = arrrr.firstIndex(of: "\(selectalbumrole.toneDeafAppId)")
                            {
                                arrrr.remove(at: dex)
                                if !arrrr.isEmpty {
                                    engineerDict["Mix Engineer"] = arrrr.sorted()
                                } else {
                                    engineerDict["Mix Engineer"] = nil
                                }
                            }
                            for track in initsongsAsMixEngRole {
                                if let dex = arrrr.firstIndex(of: track)
                                {
                                    arrrr.remove(at: dex)
                                    if !arrrr.isEmpty {
                                        engineerDict["Mix Engineer"] = arrrr.sorted()
                                    } else {
                                        engineerDict["Mix Engineer"] = nil
                                    }
                                }
                            }
                        }
                    }
                    if newRoleArr.contains("Mastering Engineer") {
                        if var art = selectalbumrole.masteringEngineers {
                            if !art.contains(strongSelf.currentPerson.toneDeafAppId) {
                                art.append("\(strongSelf.currentPerson.toneDeafAppId)")
                            }
                            selectalbumrole.masteringEngineers = art.sorted()
                        } else {
                            selectalbumrole.masteringEngineers = ["\(strongSelf.currentPerson.toneDeafAppId)"]
                        }
                        if let curRole = roles as? NSMutableDictionary {
                            if let subCa = curRole["Engineer"] as? NSDictionary {
                                let subCat = subCa.mutableCopy() as! NSMutableDictionary
                                if var subrole = subCat["Mastering Engineer"] as? [String]{
                                    if !subrole.contains(selectalbumrole.toneDeafAppId) {
                                        subrole.append("\(selectalbumrole.toneDeafAppId)")
                                    }
                                    for track in songsAsMasteringEngRole {
                                        if !subrole.contains(track) {
                                            subrole.append(track)
                                        }
                                    }
                                    subCat["Mastering Engineer"] = subrole
                                    engineerDict["Mastering Engineer"] = subrole.sorted()
                                } else {
                                    var subrole = ["\(selectalbumrole.toneDeafAppId)"]
                                    subrole.append(contentsOf: songsAsMasteringEngRole)
                                    subCat["Mastering Engineer"] = subrole
                                    engineerDict["Mastering Engineer"] = subrole.sorted()
                                }
                            } else {
                                var subrole = ["\(selectalbumrole.toneDeafAppId)"]
                                subrole.append(contentsOf: songsAsMasteringEngRole)
                                engineerDict["Mastering Engineer"] = subrole.sorted()
                            }
                        } else {
                            var subrole = ["\(selectalbumrole.toneDeafAppId)"]
                            subrole.append(contentsOf: songsAsMasteringEngRole)
                            engineerDict["Mastering Engineer"] = subrole.sorted()
                        }
                    } else {
                        if let dex = selectalbumrole.masteringEngineers?.firstIndex(of: "\(strongSelf.currentPerson.toneDeafAppId)")
                        {selectalbumrole.masteringEngineers!.remove(at: Int(dex))}
                        if var arrrr = engineerDict["Mastering Engineer"] as? [String] {
                            if let dex = arrrr.firstIndex(of: "\(selectalbumrole.toneDeafAppId)")
                            {
                                arrrr.remove(at: dex)
                                if !arrrr.isEmpty {
                                    engineerDict["Mastering Engineer"] = arrrr.sorted()
                                } else {
                                    engineerDict["Mastering Engineer"] = nil
                                }
                            }
                            for track in initsongsAsMasteringEngRole {
                                if let dex = arrrr.firstIndex(of: track)
                                {
                                    arrrr.remove(at: dex)
                                    if !arrrr.isEmpty {
                                        engineerDict["Mastering Engineer"] = arrrr.sorted()
                                    } else {
                                        engineerDict["Mastering Engineer"] = nil
                                    }
                                }
                            }
                        }
                    }
                    if newRoleArr.contains("Recording Engineer") {
                        if var art = selectalbumrole.recordingEngineers {
                            if !art.contains(strongSelf.currentPerson.toneDeafAppId) {
                                art.append("\(strongSelf.currentPerson.toneDeafAppId)")
                            }
                            selectalbumrole.recordingEngineers = art.sorted()
                        } else {
                            selectalbumrole.recordingEngineers = ["\(strongSelf.currentPerson.toneDeafAppId)"]
                        }
                        if let curRole = roles as? NSMutableDictionary {
                            if let subCa = curRole["Engineer"] as? NSDictionary {
                                let subCat = subCa.mutableCopy() as! NSMutableDictionary
                                if var subrole = subCat["Recording Engineer"] as? [String]{
                                    if !subrole.contains(selectalbumrole.toneDeafAppId) {
                                        subrole.append("\(selectalbumrole.toneDeafAppId)")
                                    }
                                    for track in songsAsRecordingEngRole {
                                        if !subrole.contains(track) {
                                            subrole.append(track)
                                        }
                                    }
                                    subCat["Recording Engineer"] = subrole
                                    engineerDict["Recording Engineer"] = subrole.sorted()
                                } else {
                                    var subrole = ["\(selectalbumrole.toneDeafAppId)"]
                                    subrole.append(contentsOf: songsAsRecordingEngRole)
                                    engineerDict["Recording Engineer"] = subrole.sorted()
                                    subCat["Recording Engineer"] = subrole
                                }
                            } else {
                                var subrole = ["\(selectalbumrole.toneDeafAppId)"]
                                subrole.append(contentsOf: songsAsRecordingEngRole)
                                engineerDict["Recording Engineer"] = subrole.sorted()
                            }
                        } else {
                            var subrole = ["\(selectalbumrole.toneDeafAppId)"]
                            subrole.append(contentsOf: songsAsRecordingEngRole)
                            engineerDict["Recording Engineer"] = subrole.sorted()
                        }
                    } else {
                        if let dex = selectalbumrole.recordingEngineers?.firstIndex(of: "\(strongSelf.currentPerson.toneDeafAppId)")
                        {
                            selectalbumrole.recordingEngineers!.remove(at: Int(dex))
                            
                        }
                        if var arrrr = engineerDict["Recording Engineer"] as? [String] {
                            if let dex = arrrr.firstIndex(of: "\(selectalbumrole.toneDeafAppId)")
                            {
                                arrrr.remove(at: dex)
                                if !arrrr.isEmpty {
                                    engineerDict["Recording Engineer"] = arrrr.sorted()
                                } else {
                                    engineerDict["Recording Engineer"] = nil
                                }
                            }
                            for track in initsongsAsRecordingEngRole {
                                if let dex = arrrr.firstIndex(of: track)
                                {
                                    arrrr.remove(at: dex)
                                    if !arrrr.isEmpty {
                                        engineerDict["Recording Engineer"] = arrrr.sorted()
                                    } else {
                                        engineerDict["Recording Engineer"] = nil
                                    }
                                }
                            }
                        }
                    }
                    if engineerDict.isEmpty {
                        newRoles["Engineer"] = nil
                    } else {
                        newRoles["Engineer"] = engineerDict
                    }
                    
                strongSelf.currentPerson.roles = ((newRoles as NSDictionary).mutableCopy() as! NSMutableDictionary)
                strongSelf.initialPerson.roles = ((newRoles as NSDictionary).mutableCopy() as! NSMutableDictionary)
                    
                    if newRoleArr.isEmpty {
                        if let albumSongs = songToGo.songs {
                            var presentOnAnotherAlbum:Bool = false
                            for song in strongSelf.personSongsArr {
                                if albumSongs.contains(song.toneDeafAppId) {
                                    for album in strongSelf.personAlbumsArr {
                                        if let eachAlbumSongs = album.songs {
                                            if eachAlbumSongs.contains(song.toneDeafAppId) && album.toneDeafAppId != songToGo.toneDeafAppId {
                                                presentOnAnotherAlbum = true
                                            }
                                        }
                                    }
                                    if presentOnAnotherAlbum == false {
                                        
                                        if var curRole = roles {
                                            if var artsubrole = (curRole["Artist"] as? [String]) {
                                                for songTitles in artsubrole {
                                                    if songTitles == song.toneDeafAppId {
                                                        let elementIndex = artsubrole.firstIndex(of: songTitles)
                                                        artsubrole.remove(at: elementIndex!)
                                                    }
                                                }
                                                curRole["Artist"] = artsubrole.sorted()
                                                if artsubrole.isEmpty {
                                                    curRole["Artist"] = nil
                                                }
                                            }
                                            if var prosubrole = (curRole["Producer"] as? [String]){
                                                for songTitles in prosubrole {
                                                    if songTitles == song.toneDeafAppId {
                                                        let elementIndex = prosubrole.firstIndex(of: songTitles)
                                                        prosubrole.remove(at: elementIndex!)
                                                    }
                                                }
                                                curRole["Producer"] = prosubrole.sorted()
                                                if prosubrole.isEmpty {
                                                    curRole["Producer"] = nil
                                                }
                                            }
                                            if var wrisubrole = (curRole["Writer"] as? [String]){
                                                for songTitles in wrisubrole {
                                                    if songTitles == song.toneDeafAppId {
                                                        let elementIndex =  wrisubrole.firstIndex(of: songTitles)
                                                        wrisubrole.remove(at: elementIndex!)
                                                        
                                                    }
                                                }
                                                curRole["Writer"] = wrisubrole.sorted()
                                                if wrisubrole.isEmpty {
                                                    curRole["Writer"] = nil
                                                }
                                            }
                                            if let engsubCat = curRole["Engineer"] as? NSMutableDictionary{
                                                if var engsubrole = engsubCat["Mix Engineer"] as? [String]{
                                                    
                                                    for songTitles in engsubrole {
                                                        
                                                        if songTitles == song.toneDeafAppId {
                                                            
                                                            let elementIndex = engsubrole.firstIndex(of: songTitles)
                                                            engsubrole.remove(at: elementIndex!)
                                                        }
                                                    }
                                                    engsubCat["Mix Engineer"] = engsubrole.sorted()
                                                    if engsubrole.isEmpty {
                                                        engsubCat["Mix Engineer"] = nil
                                                    }
                                                }
                                                if var mengsubrole = engsubCat["Mastering Engineer"] as? [String] {
                                                    for songTitles in mengsubrole {
                                                        if songTitles == song.toneDeafAppId {
                                                            let elementIndex = mengsubrole.firstIndex(of: songTitles)
                                                            mengsubrole.remove(at: elementIndex!)
                                                        }
                                                    }
                                                    engsubCat["Mastering Engineer"] = mengsubrole.sorted()
                                                    if mengsubrole.isEmpty {
                                                        engsubCat["Mastering Engineer"] = nil
                                                    }
                                                }
                                                if var rengsubrole = engsubCat["Recording Engineer"] as? [String]{
                                                    for songTitles in rengsubrole {
                                                        if songTitles == song.toneDeafAppId {
                                                            let elementIndex = rengsubrole.firstIndex(of: songTitles)
                                                            rengsubrole.remove(at: elementIndex!)
                                                        }
                                                    }
                                                    engsubCat["Recording Engineer"] = rengsubrole.sorted()
                                                    if rengsubrole.isEmpty {
                                                        engsubCat["Recording Engineer"] = nil
                                                    }
                                                }
                                                curRole["Engineer"] = engsubCat
                                                if engsubCat.count == 0 {
                                                    curRole["Engineer"] = nil
                                                }
                                            }
                                            strongSelf.currentPerson.roles = curRole
                                            strongSelf.initialPerson.roles = curRole
                                            
                                        }
                                        if let elementIndex = strongSelf.personSongsArr.firstIndex(of: song) {
                                            strongSelf.personSongsArr.remove(at: elementIndex)
                                            strongSelf.personSongsTableView.deleteRows(at: [IndexPath(row: elementIndex, section: 0)], with: .fade)
                                        }
                                        strongSelf.currentPerson.songs = []
                                        for songe in strongSelf.personSongsArr {
                                            strongSelf.currentPerson.songs!.append("\(songe.toneDeafAppId)")
                                        }
                                        if strongSelf.personSongsArr.isEmpty {
                                            strongSelf.currentPerson.songs = nil
                                        }
                                        strongSelf.personSongsTableView.reloadData()
                                        if strongSelf.personSongsArr.count < 6 {
                                            strongSelf.personSongsHeightConstraint.constant = CGFloat(50*(strongSelf.personSongsArr.count))
                                        } else {
                                            strongSelf.personSongsHeightConstraint.constant = CGFloat(270)
                                        }
                                    }
                                }
                            }
                        }
                        
                        if let albumInstrumentals = songToGo.instrumentals {
                            var presentOnAnotherAlbum:Bool = false
                            for song in strongSelf.personInstrumentalsArr {
                                if albumInstrumentals.contains(song.toneDeafAppId) {
                                    for album in strongSelf.personAlbumsArr {
                                        if let eachAlbumSongs = album.instrumentals {
                                            if eachAlbumSongs.contains(song.toneDeafAppId) && album.toneDeafAppId != songToGo.toneDeafAppId {
                                                presentOnAnotherAlbum = true
                                            }
                                        }
                                    }
                                    if presentOnAnotherAlbum == false {
                                        
                                        if var curRole = roles {
                                            if var artsubrole = (curRole["Artist"] as? [String]) {
                                                for songTitles in artsubrole {
                                                    if songTitles == song.toneDeafAppId {
                                                        let elementIndex = artsubrole.firstIndex(of: songTitles)
                                                        artsubrole.remove(at: elementIndex!)
                                                    }
                                                }
                                                curRole["Artist"] = artsubrole.sorted()
                                                if artsubrole.isEmpty {
                                                    curRole["Artist"] = nil
                                                }
                                            }
                                            if var prosubrole = (curRole["Producer"] as? [String]){
                                                for songTitles in prosubrole {
                                                    if songTitles == song.toneDeafAppId {
                                                        let elementIndex = prosubrole.firstIndex(of: songTitles)
                                                        prosubrole.remove(at: elementIndex!)
                                                    }
                                                }
                                                curRole["Producer"] = prosubrole.sorted()
                                                if prosubrole.isEmpty {
                                                    curRole["Producer"] = nil
                                                }
                                            }
                                            if var wrisubrole = (curRole["Writer"] as? [String]){
                                                for songTitles in wrisubrole {
                                                    if songTitles == song.toneDeafAppId {
                                                        let elementIndex =  wrisubrole.firstIndex(of: songTitles)
                                                        wrisubrole.remove(at: elementIndex!)
                                                        
                                                    }
                                                }
                                                curRole["Writer"] = wrisubrole.sorted()
                                                if wrisubrole.isEmpty {
                                                    curRole["Writer"] = nil
                                                }
                                            }
                                            if let engsubCat = curRole["Engineer"] as? NSMutableDictionary{
                                                if var engsubrole = engsubCat["Mix Engineer"] as? [String]{
                                                    
                                                    for songTitles in engsubrole {
                                                        
                                                        if songTitles == song.toneDeafAppId {
                                                            
                                                            let elementIndex = engsubrole.firstIndex(of: songTitles)
                                                            engsubrole.remove(at: elementIndex!)
                                                        }
                                                    }
                                                    engsubCat["Mix Engineer"] = engsubrole.sorted()
                                                    if engsubrole.isEmpty {
                                                        engsubCat["Mix Engineer"] = nil
                                                    }
                                                }
                                                if var mengsubrole = engsubCat["Mastering Engineer"] as? [String] {
                                                    for songTitles in mengsubrole {
                                                        if songTitles == song.toneDeafAppId {
                                                            let elementIndex = mengsubrole.firstIndex(of: songTitles)
                                                            mengsubrole.remove(at: elementIndex!)
                                                        }
                                                    }
                                                    engsubCat["Mastering Engineer"] = mengsubrole.sorted()
                                                    if mengsubrole.isEmpty {
                                                        engsubCat["Mastering Engineer"] = nil
                                                    }
                                                }
                                                if var rengsubrole = engsubCat["Recording Engineer"] as? [String]{
                                                    for songTitles in rengsubrole {
                                                        if songTitles == song.toneDeafAppId {
                                                            let elementIndex = rengsubrole.firstIndex(of: songTitles)
                                                            rengsubrole.remove(at: elementIndex!)
                                                        }
                                                    }
                                                    engsubCat["Recording Engineer"] = rengsubrole.sorted()
                                                    if rengsubrole.isEmpty {
                                                        engsubCat["Recording Engineer"] = nil
                                                    }
                                                }
                                                curRole["Engineer"] = engsubCat
                                                if engsubCat.count == 0 {
                                                    curRole["Engineer"] = nil
                                                }
                                            }
                                            strongSelf.currentPerson.roles = curRole
                                            strongSelf.initialPerson.roles = curRole
                                            
                                        }
                                        if let elementIndex = strongSelf.personInstrumentalsArr.firstIndex(of: song) {
                                            strongSelf.personInstrumentalsArr.remove(at: elementIndex)
                                            strongSelf.personInstrumentalsTableView.deleteRows(at: [IndexPath(row: elementIndex, section: 0)], with: .fade)
                                        }
                                        strongSelf.currentPerson.instrumentals = []
                                        for songe in strongSelf.personInstrumentalsArr {
                                            strongSelf.currentPerson.instrumentals!.append("\(songe.toneDeafAppId)")
                                        }
                                        if strongSelf.personInstrumentalsArr.isEmpty {
                                            strongSelf.currentPerson.instrumentals = nil
                                        }
                                        strongSelf.personInstrumentalsArr.sort(by: {$0.songName! < $1.songName!})
                                        strongSelf.personInstrumentalsTableView.reloadData()
                                        strongSelf.personInstrumentalsHeightConstraint.constant = CGFloat(50*(strongSelf.personInstrumentalsArr.count))
                                    }
                                }
                            }
                        }
                        
                        strongSelf.personAlbumsArr.remove(at: indexPath.row)
                        
                        strongSelf.currentPerson.albums = []
                        for song in strongSelf.personAlbumsArr {
                            strongSelf.currentPerson.albums!.append("\(song.toneDeafAppId)")
                        }
                        if strongSelf.personAlbumsArr.isEmpty {
                            strongSelf.currentPerson.albums = nil
                        }
                        
                        DispatchQueue.main.async {
                            tableView.deleteRows(at: [indexPath], with: .fade)
                            if strongSelf.personAlbumsArr.count < 6 {
                                strongSelf.personAlbumsHeightConstraint.constant = CGFloat(50*(strongSelf.personAlbumsArr.count))
                            } else {
                                strongSelf.personAlbumsHeightConstraint.constant = CGFloat(270)
                            }
                        }
                    }
                    
                    DispatchQueue.main.async {[weak self]  in
                        guard let strongSelf = self else {return}
                        strongSelf.personAlbumsTableView.reloadData()
                    }
                }
            })
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
            { (action) in
                // ...
            }
            alertController.addAction(cancelAction)
            alertController.addAction(addAction)
            alertController.addAction(editAction)
            var rolearrr:[String] = []
            let art = personAlbumsArr[indexPath.row].mainArtist
            for artist in art {
                if artist.contains(currentPerson.toneDeafAppId) {
                    if !rolearrr.contains("Main Artist") {
                        rolearrr.append("Main Artist")
                    }
                }
            }
            if let art = personAlbumsArr[indexPath.row].allArtists {
                for artist in art {
                    if artist.contains(currentPerson.toneDeafAppId) {
                        if !rolearrr.contains("Featured Artist") {
                            rolearrr.append("Featured Artist")
                        }
                    }
                }
            }
            let pro = personAlbumsArr[indexPath.row].producers
            for producer in pro {
                if producer.contains(currentPerson.toneDeafAppId) {
                    if !rolearrr.contains("Producer") {
                        rolearrr.append("Producer")
                    }
                }
            }
            if let wri = personAlbumsArr[indexPath.row].writers {
                for writer in wri {
                    if writer.contains(currentPerson.toneDeafAppId) {
                        if !rolearrr.contains("Writer") {
                            rolearrr.append("Writer")
                        }
                    }
                }
            }
            if let mixeng = personAlbumsArr[indexPath.row].mixEngineers {
                for engie in mixeng {
                    if engie.contains(currentPerson.toneDeafAppId) {
                        if !rolearrr.contains("Mix Engineer") {
                            rolearrr.append("Mix Engineer")
                        }
                    }
                }
            }
            if let masteng = personAlbumsArr[indexPath.row].masteringEngineers {
                for engie in masteng {
                    if engie.contains(currentPerson.toneDeafAppId) {
                        if !rolearrr.contains("Mastering Engineer") {
                            rolearrr.append("Mastering Engineer")
                        }
                    }
                }
            }
            if let receng = personAlbumsArr[indexPath.row].recordingEngineers {
                for engie in receng {
                    if engie.contains(currentPerson.toneDeafAppId) {
                        if !rolearrr.contains("Recording Engineer") {
                            rolearrr.append("Recording Engineer")
                        }
                    }
                }
            }
            alertController.view.tintColor = Constants.Colors.redApp

            
            alertController.view.tintColor = UIColor.init(red: 182/255, green: 0/255, blue: 3/255, alpha: 1)
            self.present(alertController, animated: true) { [weak self] in
                guard let strongSelf = self else {return}
                let cc = alertController.value(forKey: "contentViewController") as! EditPersonRolesPopoverTableViewController
                for i in 0 ... (cc.roleArr.count) {
                    print(cc.tableView.numberOfRows(inSection: 0))
                    if let cell = cc.tableView.cellForRow(at: IndexPath(row: i, section: 0)) as? EditRolePopoverTableCellController {
                        print(cell.role.text)
                        
                        if rolearrr.contains(cell.role.text!) {
                            cell.checkbox.setOn(true, animated: false)
                        }
                    }
                }
                let featCell = cc.tableViewPopover.cellForRow(at: IndexPath(row: 1, section: 0)) as! EditRolePopoverTableCellController
                if rolearrr.contains("Main Artist") {
                    featCell.isUserInteractionEnabled = false
                    featCell.checkbox.alpha = 0.5
                    featCell.role.alpha = 0.5
                    featCell.checkbox.setOn(true, animated: true)
                } else {
                    featCell.isUserInteractionEnabled = true
                    featCell.checkbox.alpha = 1
                    featCell.role.alpha = 1
                    if !rolearrr.contains("Featured Artist") {
                        featCell.checkbox.setOn(false, animated: true)
                    }
                }
                
                if let currole = strongSelf.currentPerson.roles {
                    if let arrr = currole["Artist"] as? [String] {
                        for song in strongSelf.personSongsArr {
                            if let arr2 = song.albums as? [String] {
                                if arr2.contains(selectalbumrole.toneDeafAppId) {
                                    if arrr.contains(song.toneDeafAppId) {
                                        initsongsAsArtistRole.append(song.toneDeafAppId)
                                    }
                                }
                            }
                        }
                        for song in strongSelf.personInstrumentalsArr {
                            if let arr2 = song.albums as? [String] {
                                if arr2.contains(selectalbumrole.toneDeafAppId) {
                                    if arrr.contains(song.toneDeafAppId) {
                                        initsongsAsArtistRole.append(song.toneDeafAppId)
                                    }
                                }
                            }
                        }
                    }
                    if let arrr = currole["Producer"] as? [String] {
                        for song in strongSelf.personSongsArr {
                            if let arr2 = song.albums as? [String] {
                                if arr2.contains(selectalbumrole.toneDeafAppId) {
                                    if arrr.contains(song.toneDeafAppId) {
                                        initsongsAsProducerRole.append(song.toneDeafAppId)
                                    }
                                }
                            }
                        }
                        for song in strongSelf.personInstrumentalsArr {
                            if let arr2 = song.albums as? [String] {
                                if arr2.contains(selectalbumrole.toneDeafAppId) {
                                    if arrr.contains(song.toneDeafAppId) {
                                        initsongsAsProducerRole.append(song.toneDeafAppId)
                                    }
                                }
                            }
                        }
                    }
                    if let arrr = currole["Writer"] as? [String] {
                        for song in strongSelf.personSongsArr {
                            if let arr2 = song.albums as? [String] {
                                if arr2.contains(selectalbumrole.toneDeafAppId) {
                                    if arrr.contains(song.toneDeafAppId) {
                                        initsongsAsWriterRole.append(song.toneDeafAppId)
                                    }
                                }
                            }
                        }
                    }
                    if let engie = currole["Engineer"] as? NSDictionary {
                        let eng = engie.mutableCopy() as! NSMutableDictionary
                        if let arrr = eng["Mix Engineer"] as? [String] {
                            for song in strongSelf.personSongsArr {
                                if let arr2 = song.albums as? [String] {
                                    if arr2.contains(selectalbumrole.toneDeafAppId) {
                                        if arrr.contains(song.toneDeafAppId) {
                                            initsongsAsMixEngRole.append(song.toneDeafAppId)
                                        }
                                    }
                                }
                            }
                            for song in strongSelf.personInstrumentalsArr {
                                if let arr2 = song.albums as? [String] {
                                    if arr2.contains(selectalbumrole.toneDeafAppId) {
                                        if arrr.contains(song.toneDeafAppId) {
                                            initsongsAsMixEngRole.append(song.toneDeafAppId)
                                        }
                                    }
                                }
                            }
                        }
                        if let arrr = eng["Mastering Engineer"] as? [String] {
                            for song in strongSelf.personSongsArr {
                                if let arr2 = song.albums as? [String] {
                                    if arr2.contains(selectalbumrole.toneDeafAppId) {
                                        if arrr.contains(song.toneDeafAppId) {
                                            initsongsAsMasteringEngRole.append(song.toneDeafAppId)
                                        }
                                    }
                                }
                            }
                            for song in strongSelf.personInstrumentalsArr {
                                if let arr2 = song.albums as? [String] {
                                    if arr2.contains(selectalbumrole.toneDeafAppId) {
                                        if arrr.contains(song.toneDeafAppId) {
                                            initsongsAsMasteringEngRole.append(song.toneDeafAppId)
                                        }
                                    }
                                }
                            }
                        }
                        if let arrr = eng["Recording Engineer"] as? [String] {
                            for song in strongSelf.personSongsArr {
                                if let arr2 = song.albums as? [String] {
                                    if arr2.contains(selectalbumrole.toneDeafAppId) {
                                        if arrr.contains(song.toneDeafAppId) {
                                            initsongsAsRecordingEngRole.append(song.toneDeafAppId)
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            initAllSongsWithRoleAttached = Array(GlobalFunctions.shared.combine(initsongsAsArtistRole,initsongsAsProducerRole,initsongsAsWriterRole,initsongsAsMixEngRole,initsongsAsMasteringEngRole,initsongsAsRecordingEngRole))
            }
        case personVideosTableView:
            //MARK: - didSelect Videos
            alertController = UIAlertController(title: "Change roles for \(personVideosArr[indexPath.row].title)",
                                                    message: "Select Roles",
                                                    preferredStyle: .alert)
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc3 = storyboard.instantiateViewController(identifier: "editPersonRolesPopoverTableViewController") as
            EditPersonRolesPopoverTableViewController
            vc3.preferredContentSize = CGSize(width: 350, height: 120) // 4 default cell heights.
            vc3.roleArr = ["Videographer", "Other Person"]
            vc3.tableView.isScrollEnabled = false
            alertController.setValue(vc3, forKey: "contentViewController")
            
            let editAction = UIAlertAction(title: "Edit \(personVideosArr[indexPath.row].title)", style: .default, handler: { _ in
                
            })
            
            let addAction = UIAlertAction(title: "Update Roles", style: .default, handler: {[weak self] _ in
                guard let strongSelf = self else {return}
                var newRoleArr:[String] = []
                let cc = alertController.value(forKey: "contentViewController") as! EditPersonRolesPopoverTableViewController
                for i in 1 ... (cc.roleArr.count) {
                    let cell = cc.tableViewPopover.cellForRow(at: IndexPath(row: i-1, section: 0)) as! EditRolePopoverTableCellController
                    if cell.checkbox.on {
                        newRoleArr.append(cell.role.text!)
                    }
                }
                
                var roles:NSMutableDictionary?
                roles = strongSelf.currentPerson.roles
                if roles == nil {
                    roles = [:]
                }
                var newRoles:NSMutableDictionary = roles!
                let selectvideorole = strongSelf.personVideosArr[indexPath.row]
                if newRoleArr.contains("Videographer") {
                    if var arr = selectvideorole.videographers {
                        if !arr.contains("\(strongSelf.currentPerson.toneDeafAppId)"){
                            arr.append("\(strongSelf.currentPerson.toneDeafAppId)")
                            selectvideorole.videographers = arr.sorted()
                        }
                    } else {
                        var arr:[String] = []
                        arr.append("\(strongSelf.currentPerson.toneDeafAppId)")
                        selectvideorole.videographers = arr.sorted()
                    }
                    if let curRole = roles {
                        if var subrole = curRole["Videographer"] as? [String]{
                            if !subrole.contains("\(selectvideorole.toneDeafAppId)") {
                                subrole.append("\(selectvideorole.toneDeafAppId)")
                                newRoles["Videographer"] = subrole.sorted()
                            }
                        }
                        else {
                            let subrole:[String] = ["\(selectvideorole.toneDeafAppId)"]
                            newRoles["Videographer"] = subrole.sorted()
                        }
                    }
                    else {
                        let subrole:[String] = ["\(selectvideorole.toneDeafAppId)"]
                        newRoles["Videographer"] = subrole.sorted()
                    }
                } else {
                    if let dex = selectvideorole.videographers?.firstIndex(of: "\(strongSelf.currentPerson.toneDeafAppId)")
                    {
                        selectvideorole.videographers!.remove(at: Int(dex))
                    }
                    if var arrrr = newRoles["Videographer"] as? [String] {
                        if let dex = arrrr.firstIndex(of: "\(selectvideorole.toneDeafAppId)")
                        {
                            arrrr.remove(at: dex)
                            if !arrrr.isEmpty {
                                newRoles["Videographer"] = arrrr.sorted()
                            } else {
                                newRoles["Videographer"] = nil
                            }
                        }
                    }
                    
                }
                if newRoleArr.contains("Other Person") {
                    if var arr = selectvideorole.persons {
                        if !arr.contains("\(strongSelf.currentPerson.toneDeafAppId)"){
                            arr.append("\(strongSelf.currentPerson.toneDeafAppId)")
                            selectvideorole.persons = arr.sorted()
                        }
                    } else {
                        var arr:[String] = []
                        arr.append("\(strongSelf.currentPerson.toneDeafAppId)")
                        selectvideorole.persons = arr.sorted()
                    }
                    if !strongSelf.videoPersonArr.contains(selectvideorole.toneDeafAppId) {
                        strongSelf.videoPersonArr.append(selectvideorole.toneDeafAppId)
                        strongSelf.videoPersonArr.sort()
                    }
                } else {
                    if let dex = selectvideorole.persons?.firstIndex(of: "\(strongSelf.currentPerson.toneDeafAppId)")
                    {
                        selectvideorole.persons!.remove(at: Int(dex))
                    }
                    if let dex = strongSelf.videoPersonArr.firstIndex(of: selectvideorole.toneDeafAppId)
                    {
                        strongSelf.videoPersonArr.remove(at: Int(dex))
                    }
                }
                strongSelf.personVideosArr[indexPath.row] = selectvideorole
                
                if newRoleArr.isEmpty {
                    let songToGo =  strongSelf.personVideosArr[indexPath.row]
                    let songID = "\(songToGo.toneDeafAppId)"
                    
                    if let arr = songToGo.persons {
                        if arr.contains(strongSelf.currentPerson.toneDeafAppId) {
                            if let elementIndex2 = strongSelf.videoPersonArr.firstIndex(of: songToGo.toneDeafAppId) {
                                strongSelf.videoPersonArr.remove(at: elementIndex2)
                            }
                        }
                    }
                    
                    strongSelf.personVideosArr.remove(at: indexPath.row)
                    strongSelf.currentPerson.videos = []
                    for song in  strongSelf.personVideosArr {
                        strongSelf.currentPerson.videos!.append("\(song.toneDeafAppId)")
                    }
                    if  strongSelf.personVideosArr.isEmpty {
                        strongSelf.currentPerson.videos = nil
                    }
                    tableView.deleteRows(at: [indexPath], with: .fade)
                    if strongSelf.personVideosArr.count < 6 {
                        strongSelf.personVideosHeightConstraint.constant = CGFloat(50*(strongSelf.personVideosArr.count))
                    } else {
                        strongSelf.personVideosHeightConstraint.constant = CGFloat(270)
                    }
                }
                
                strongSelf.currentPerson.roles = ((newRoles as NSDictionary).mutableCopy() as! NSMutableDictionary)
                strongSelf.initialPerson.roles = ((newRoles as NSDictionary).mutableCopy() as! NSMutableDictionary)
                tableView.reloadData()
                strongSelf.personVideosArr.sort(by: {$0.title < $1.title})
                strongSelf.personVideosTableView.reloadData()
            })
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
            { (action) in
                // ...
            }
            alertController.addAction(cancelAction)
            alertController.addAction(addAction)
            alertController.addAction(editAction)
            var rolearrr:[String] = []
            if let wri = personVideosArr[indexPath.row].videographers {
                for writer in wri {
                    if writer.contains(currentPerson.toneDeafAppId) {
                        if !rolearrr.contains("Videographer") {
                            rolearrr.append("Videographer")
                        }
                    }
                }
            }
            if let mixeng = personVideosArr[indexPath.row].persons {
                for engie in mixeng {
                    if engie.contains(currentPerson.toneDeafAppId) {
                        if !rolearrr.contains("Other Person") {
                            rolearrr.append("Other Person")
                        }
                    }
                }
            }
            alertController.view.tintColor = Constants.Colors.redApp

            
            alertController.view.tintColor = UIColor.init(red: 182/255, green: 0/255, blue: 3/255, alpha: 1)
            self.present(alertController, animated: true)
            {
                let cc = alertController.value(forKey: "contentViewController") as! EditPersonRolesPopoverTableViewController
                for i in 1 ... (cc.roleArr.count) {
                    let cell = cc.tableViewPopover.cellForRow(at: IndexPath(row: i-1, section: 0)) as! EditRolePopoverTableCellController
                    if rolearrr.contains(cell.role.text!) {
                        cell.checkbox.setOn(true, animated: false)
                    }
                }
            }
        case personInstrumentalsTableView:
            //MARK: - didSelect Instrumentals
            alertController = UIAlertController(title: "Change roles for \(personInstrumentalsArr[indexPath.row].instrumentalName!)",
                                                    message: "Select Roles",
                                                    preferredStyle: .alert)
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc3 = storyboard.instantiateViewController(identifier: "editPersonRolesPopoverTableViewController") as
            EditPersonRolesPopoverTableViewController
            vc3.preferredContentSize = CGSize(width: 350, height: 240) // 4 default cell heights.
            vc3.roleArr.remove(at: 5)
            vc3.roleArr.remove(at: 2)
            vc3.tableView.isScrollEnabled = false
            alertController.setValue(vc3, forKey: "contentViewController")
            
            let editAction = UIAlertAction(title: "Edit \(personInstrumentalsArr[indexPath.row].instrumentalName!)", style: .default, handler: { _ in
                
            })
            
            let addAction = UIAlertAction(title: "Update Roles", style: .default, handler: {[weak self] _ in
                guard let strongSelf = self else {return}
                var newRoleArr:[String] = []
                let cc = alertController.value(forKey: "contentViewController") as! EditPersonRolesPopoverTableViewController
                for i in 1 ... (cc.roleArr.count) {
                    let cell = cc.tableViewPopover.cellForRow(at: IndexPath(row: i-1, section: 0)) as! EditRolePopoverTableCellController
                    if cell.checkbox.on {
                        newRoleArr.append(cell.role.text!)
                    }
                }
                
                let instrumentalChosen = strongSelf.personInstrumentalsArr[indexPath.row]
                
                var albumsToUpdate:[AlbumData] = []
                var albumsToUpdateIds:[String] = []
                if let arr = instrumentalChosen.albums as? [String] {
                    for alb in strongSelf.personAlbumsArr {
                        if arr.contains(alb.toneDeafAppId) {
                            albumsToUpdate.append(alb)
                            albumsToUpdateIds.append(alb.toneDeafAppId)
                        }
                    }
                }
                
                var roles:NSMutableDictionary?
                roles = strongSelf.currentPerson.roles
                if roles == nil {
                    roles = [:]
                }
                var newRoles:NSMutableDictionary = roles!
                var engineerDict:[String:Any?] = [:]
                if let engies = newRoles["Engineer"] as? [String:Any?] {
                    engineerDict = engies
                }
                let selectinstrumentalrole = strongSelf.personInstrumentalsArr[indexPath.row]
                if newRoleArr.contains("Artist") {
                    if let arry = selectinstrumentalrole.artist {
                        if !arry.contains("\(strongSelf.currentPerson.toneDeafAppId)"){
                            selectinstrumentalrole.artist!.append("\(strongSelf.currentPerson.toneDeafAppId)")
                        }
                    } else {
                        selectinstrumentalrole.artist = []
                        selectinstrumentalrole.artist!.append("\(strongSelf.currentPerson.toneDeafAppId)")
                    }
                    for album in albumsToUpdate {
                        if var arr = album.allArtists as? [String] {
                            if !arr.contains("\(strongSelf.currentPerson.toneDeafAppId)"){
                                arr.append("\(strongSelf.currentPerson.toneDeafAppId)")
                                album.allArtists = arr
                            }
                        } else {
                            var arr:[String] = []
                            if !arr.contains("\(strongSelf.currentPerson.toneDeafAppId)") {
                                arr.append("\(strongSelf.currentPerson.toneDeafAppId)")
                            }
                            album.allArtists = arr
                        }
                        if !strongSelf.albumFeaturedArtistArr.contains(album.toneDeafAppId) {
                            strongSelf.albumFeaturedArtistArr.append(album.toneDeafAppId)
                        }
                    }
                    if let curRole = roles {
                        if var subrole = curRole["Artist"] as? [String]{
                            if !subrole.contains("\(selectinstrumentalrole.toneDeafAppId)") {
                                subrole.append("\(selectinstrumentalrole.toneDeafAppId)")
                                subrole = Array(GlobalFunctions.shared.combine(subrole,albumsToUpdateIds))
                                newRoles["Artist"] = subrole.sorted()
                            }
                        }
                        else {
                            var subrole:[String] = ["\(selectinstrumentalrole.toneDeafAppId)"]
                            subrole = Array(GlobalFunctions.shared.combine(subrole,albumsToUpdateIds))
                            newRoles["Artist"] = subrole.sorted()
                        }
                    }
                    else {
                        var subrole:[String] = ["\(selectinstrumentalrole.toneDeafAppId)"]
                        subrole = Array(GlobalFunctions.shared.combine(subrole,albumsToUpdateIds))
                        newRoles["Artist"] = subrole.sorted()
                    }
                } else {
                    if let dex = selectinstrumentalrole.artist?.firstIndex(of: "\(strongSelf.currentPerson.toneDeafAppId)")
                    {
                        selectinstrumentalrole.artist!.remove(at: Int(dex))
                    }
                    if var arrrr = newRoles["Artist"] as? [String] {
                        if let dex = arrrr.firstIndex(of: "\(selectinstrumentalrole.toneDeafAppId)")
                        {
                            arrrr.remove(at: dex)
                            if !arrrr.isEmpty {
                                newRoles["Artist"] = arrrr.sorted()
                            } else {
                                newRoles["Artist"] = nil
                            }
                        }
                    }
                    
                    if let alb = instrumentalChosen.albums as? [String] {
                        var instrumentalChosenAlbumsDataArray:[AlbumData] = []
                        for album in strongSelf.personAlbumsArr {
                            if alb.contains(album.toneDeafAppId) {
                                instrumentalChosenAlbumsDataArray.append(album)
                            }
                        }
                        for album in instrumentalChosenAlbumsDataArray {
                            var roleMArkedOnAnotherInstrumental:Bool = false
                            for song in strongSelf.personInstrumentalsArr {
                                if let twoo = song.artist {
                                    if twoo.contains(strongSelf.currentPerson.toneDeafAppId) {
                                        if let songarr2 = song.albums as? [String] {
                                            if songarr2.contains(album.toneDeafAppId) {
                                                roleMArkedOnAnotherInstrumental = true
                                            }
                                        }
                                    }
                                }
                            }
                            for song in strongSelf.personSongsArr {
                                if song.songArtist.contains(strongSelf.currentPerson.toneDeafAppId) {
                                        if let songarr2 = song.albums as? [String] {
                                            if songarr2.contains(album.toneDeafAppId) {
                                                roleMArkedOnAnotherInstrumental = true
                                            }
                                        }
                                    }
                            }
                            if roleMArkedOnAnotherInstrumental == false {
//                                if let dex = album.mainArtist.firstIndex(of: "\(strongSelf.currentPerson.toneDeafAppId)")
//                                {
//                                    album.mainArtist.remove(at: Int(dex))
//                                }
                                if let dex = album.allArtists?.firstIndex(of: "\(strongSelf.currentPerson.toneDeafAppId)")
                                {
                                    album.allArtists!.remove(at: Int(dex))
                                }
                                if var arrrr = newRoles["Artist"] as? [String] {
                                    if let dex = arrrr.firstIndex(of: "\(album.toneDeafAppId)")
                                    {
                                        arrrr.remove(at: dex)
                                        if !arrrr.isEmpty {
                                            newRoles["Artist"] = arrrr.sorted()
                                        } else {
                                            newRoles["Artist"] = nil
                                        }
                                    }
                                }
//                                if strongSelf.albumMainArtistArr.contains(album.toneDeafAppId) {
//                                    if let dex = strongSelf.albumMainArtistArr.firstIndex(of: "\(album.toneDeafAppId)")
//                                    {
//                                        strongSelf.albumMainArtistArr.remove(at: dex)
//                                    }
//                                }
                                if strongSelf.albumFeaturedArtistArr.contains(album.toneDeafAppId) {
                                    if let dex = strongSelf.albumFeaturedArtistArr.firstIndex(of: "\(album.toneDeafAppId)")
                                    {
                                        strongSelf.albumFeaturedArtistArr.remove(at: dex)
                                    }
                                }
                            }
                        }
                    }
                    
                }
                if newRoleArr.contains("Producer") {
                    if !selectinstrumentalrole.producers.contains("\(strongSelf.currentPerson.toneDeafAppId)"){
                        selectinstrumentalrole.producers.append("\(strongSelf.currentPerson.toneDeafAppId)")
                    }
                    for album in albumsToUpdate {
                        if !album.producers.contains("\(strongSelf.currentPerson.toneDeafAppId)"){
                            album.producers.append("\(strongSelf.currentPerson.toneDeafAppId)")
                        }
                    }
                    if let curRole = roles {
                        if var subrole = curRole["Producer"] as? [String]{
                            if !subrole.contains("\(selectinstrumentalrole.toneDeafAppId)") {
                                subrole.append("\(selectinstrumentalrole.toneDeafAppId)")
                                subrole = Array(GlobalFunctions.shared.combine(subrole,albumsToUpdateIds))
                                newRoles["Producer"] = subrole.sorted()
                            }
                        }
                        else {
                            var subrole:[String] = ["\(selectinstrumentalrole.toneDeafAppId)"]
                            subrole = Array(GlobalFunctions.shared.combine(subrole,albumsToUpdateIds))
                            newRoles["Producer"] = subrole.sorted()
                        }
                    }
                    else {
                        var subrole:[String] = ["\(selectinstrumentalrole.toneDeafAppId)"]
                        subrole = Array(GlobalFunctions.shared.combine(subrole,albumsToUpdateIds))
                        newRoles["Producer"] = subrole.sorted()
                    }
                } else {
                    if let dex = selectinstrumentalrole.producers.firstIndex(of: "\(strongSelf.currentPerson.toneDeafAppId)")
                    {
                        selectinstrumentalrole.producers.remove(at: Int(dex))
                    }
                    if var arrrr = newRoles["Producer"] as? [String] {
                        if let dex = arrrr.firstIndex(of: "\(selectinstrumentalrole.toneDeafAppId)")
                        {
                            arrrr.remove(at: dex)
                            if !arrrr.isEmpty {
                                newRoles["Producer"] = arrrr.sorted()
                            } else {
                                newRoles["Producer"] = nil
                            }
                        }
                    }
                    if let alb = instrumentalChosen.albums as? [String] {
                        var instrumentalChosenAlbumsDataArray:[AlbumData] = []
                        for album in strongSelf.personAlbumsArr {
                            if alb.contains(album.toneDeafAppId) {
                                instrumentalChosenAlbumsDataArray.append(album)
                            }
                        }
                        for album in instrumentalChosenAlbumsDataArray {
                            var roleMArkedOnAnotherInstrumental:Bool = false
                            for song in strongSelf.personInstrumentalsArr {
                                if song.producers.contains(strongSelf.currentPerson.toneDeafAppId) {
                                    if let songarr2 = song.albums as? [String] {
                                        if songarr2.contains(album.toneDeafAppId) {
                                            roleMArkedOnAnotherInstrumental = true
                                        }
                                    }
                                }
                            }
                            for song in strongSelf.personSongsArr {
                                if song.songProducers.contains(strongSelf.currentPerson.toneDeafAppId) {
                                    if let songarr2 = song.albums as? [String] {
                                        if songarr2.contains(album.toneDeafAppId) {
                                            roleMArkedOnAnotherInstrumental = true
                                        }
                                    }
                                }
                            }
                            if roleMArkedOnAnotherInstrumental == false {
                                if let dex = album.producers.firstIndex(of: "\(strongSelf.currentPerson.toneDeafAppId)")
                                {
                                    album.producers.remove(at: Int(dex))
                                }
                                if var arrrr = newRoles["Producer"] as? [String] {
                                    if let dex = arrrr.firstIndex(of: "\(album.toneDeafAppId)")
                                    {
                                        arrrr.remove(at: dex)
                                        if !arrrr.isEmpty {
                                            newRoles["Producer"] = arrrr.sorted()
                                        } else {
                                            newRoles["Producer"] = nil
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
                if newRoleArr.contains("Mix Engineer") {
                    if let arry = selectinstrumentalrole.mixEngineer {
                        if !arry.contains("\(strongSelf.currentPerson.toneDeafAppId)"){
                            selectinstrumentalrole.mixEngineer!.append("\(strongSelf.currentPerson.toneDeafAppId)")
                        }
                    } else {
                        selectinstrumentalrole.mixEngineer = []
                        selectinstrumentalrole.mixEngineer!.append("\(strongSelf.currentPerson.toneDeafAppId)")
                    }
                    for album in albumsToUpdate {
                        if var arr = album.mixEngineers as? [String] {
                            if !arr.contains("\(strongSelf.currentPerson.toneDeafAppId)"){
                                arr.append("\(strongSelf.currentPerson.toneDeafAppId)")
                                album.mixEngineers = arr
                            }
                        } else {
                            var arr:[String] = []
                            arr.append("\(strongSelf.currentPerson.toneDeafAppId)")
                            album.mixEngineers = arr
                        }
                    }
                    if let curRole = roles {
                        if let subCat = curRole["Engineer"] as? [String:Any?]
                        {
                            if var subrole = subCat["Mix Engineer"] as? [String]{
                                if !subrole.contains("\(selectinstrumentalrole.toneDeafAppId)") {
                                    subrole.append("\(selectinstrumentalrole.toneDeafAppId)")
                                    subrole = Array(GlobalFunctions.shared.combine(subrole,albumsToUpdateIds))
                                    engineerDict["Mix Engineer"] = subrole.sorted()
                                }
                            } else {
                                var subrole:[String] = ["\(selectinstrumentalrole.toneDeafAppId)"]
                                subrole = Array(GlobalFunctions.shared.combine(subrole,albumsToUpdateIds))
                                engineerDict["Mix Engineer"] = subrole.sorted()
                            }
                        } else {
                            var subrole:[String] = ["\(selectinstrumentalrole.toneDeafAppId)"]
                            subrole = Array(GlobalFunctions.shared.combine(subrole,albumsToUpdateIds))
                            engineerDict["Mix Engineer"] = subrole.sorted()
                        }
                    } else {
                        var subrole:[String] = ["\(selectinstrumentalrole.toneDeafAppId)"]
                        subrole = Array(GlobalFunctions.shared.combine(subrole,albumsToUpdateIds))
                        engineerDict["Mix Engineer"] = subrole.sorted()
                    }
                } else {
                    
                    if let dex = selectinstrumentalrole.mixEngineer?.firstIndex(of: "\(strongSelf.currentPerson.toneDeafAppId)")
                    {
                        selectinstrumentalrole.mixEngineer!.remove(at: Int(dex))
                    }
                    if var arrrr = engineerDict["Mix Engineer"] as? [String] {
                        
                        if let dex = arrrr.firstIndex(of: "\(selectinstrumentalrole.toneDeafAppId)")
                        {
                            
                            arrrr.remove(at: dex)
                            
                            if !arrrr.isEmpty {
                                engineerDict["Mix Engineer"] = arrrr.sorted()
                            } else {
                                
                                engineerDict["Mix Engineer"] = nil
                            }
                        }
                    }
                    if let alb = instrumentalChosen.albums as? [String] {
                        var instrumentalChosenAlbumsDataArray:[AlbumData] = []
                        for album in strongSelf.personAlbumsArr {
                            if alb.contains(album.toneDeafAppId) {
                                instrumentalChosenAlbumsDataArray.append(album)
                            }
                        }
                        for album in instrumentalChosenAlbumsDataArray {
                            var roleMArkedOnAnotherInstrumental:Bool = false
                            for song in strongSelf.personInstrumentalsArr {
                                if let arrr = song.mixEngineer as? [String] {
                                    if arrr.contains(strongSelf.currentPerson.toneDeafAppId) {
                                        if let songarr2 = song.albums as? [String] {
                                            if songarr2.contains(album.toneDeafAppId) {
                                                roleMArkedOnAnotherInstrumental = true
                                            }
                                        }
                                    }
                                }
                            }
                            for song in strongSelf.personSongsArr {
                                if let arrr = song.songMixEngineer as? [String] {
                                    if arrr.contains(strongSelf.currentPerson.toneDeafAppId) {
                                        if let songarr2 = song.albums as? [String] {
                                            if songarr2.contains(album.toneDeafAppId) {
                                                roleMArkedOnAnotherInstrumental = true
                                            }
                                        }
                                    }
                                }
                            }
                            if roleMArkedOnAnotherInstrumental == false {
                                if let dex = album.mixEngineers?.firstIndex(of: "\(strongSelf.currentPerson.toneDeafAppId)")
                                {
                                    album.mixEngineers!.remove(at: Int(dex))
                                }
                                if var arrrr = engineerDict["Mix Engineer"] as? [String] {
                                    if let dex = arrrr.firstIndex(of: "\(album.toneDeafAppId)")
                                    {
                                        arrrr.remove(at: dex)
                                        if !arrrr.isEmpty {
                                            engineerDict["Mix Engineer"] = arrrr.sorted()
                                        } else {
                                            engineerDict["Mix Engineer"] = nil
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
                if newRoleArr.contains("Mastering Engineer") {
                    if let arry = selectinstrumentalrole.masteringEngineer {
                        if !arry.contains("\(strongSelf.currentPerson.toneDeafAppId)"){
                            selectinstrumentalrole.masteringEngineer!.append("\(strongSelf.currentPerson.toneDeafAppId)")
                        }
                    } else {
                        selectinstrumentalrole.masteringEngineer = []
                        selectinstrumentalrole.masteringEngineer!.append("\(strongSelf.currentPerson.toneDeafAppId)")
                    }
                    for album in albumsToUpdate {
                        if var arr = album.masteringEngineers as? [String] {
                            if !arr.contains("\(strongSelf.currentPerson.toneDeafAppId)"){
                                arr.append("\(strongSelf.currentPerson.toneDeafAppId)")
                                album.masteringEngineers = arr
                            }
                        } else {
                            var arr:[String] = []
                            arr.append("\(strongSelf.currentPerson.toneDeafAppId)")
                            album.masteringEngineers = arr
                        }
                    }
                    if let curRole = roles {
                        if let subCat = curRole["Engineer"] as? [String:Any?] {
                            if var subrole = subCat["Mastering Engineer"] as? [String]{
                                if !subrole.contains("\(selectinstrumentalrole.toneDeafAppId)") {
                                    subrole.append("\(selectinstrumentalrole.toneDeafAppId)")
                                    subrole = Array(GlobalFunctions.shared.combine(subrole,albumsToUpdateIds))
                                    engineerDict["Mastering Engineer"] = subrole.sorted()
                                }
                            } else {
                                var subrole:[String] = ["\(selectinstrumentalrole.toneDeafAppId)"]
                                subrole = Array(GlobalFunctions.shared.combine(subrole,albumsToUpdateIds))
                                engineerDict["Mastering Engineer"] = subrole.sorted()
                            }
                        } else {
                            var subrole:[String] = ["\(selectinstrumentalrole.toneDeafAppId)"]
                            subrole = Array(GlobalFunctions.shared.combine(subrole,albumsToUpdateIds))
                            engineerDict["Mastering Engineer"] = subrole.sorted()
                        }
                    } else {
                        var subrole:[String] = ["\(selectinstrumentalrole.toneDeafAppId)"]
                        subrole = Array(GlobalFunctions.shared.combine(subrole,albumsToUpdateIds))
                        engineerDict["Mastering Engineer"] = subrole.sorted()
                    }
                } else {
                    if let dex = selectinstrumentalrole.masteringEngineer?.firstIndex(of: "\(strongSelf.currentPerson.toneDeafAppId)")
                    {selectinstrumentalrole.masteringEngineer!.remove(at: Int(dex))}
                    if var arrrr = engineerDict["Mastering Engineer"] as? [String] {
                        if let dex = arrrr.firstIndex(of: "\(selectinstrumentalrole.toneDeafAppId)")
                        {
                            arrrr.remove(at: dex)
                            if !arrrr.isEmpty {
                                engineerDict["Mastering Engineer"] = arrrr.sorted()
                            } else {
                                engineerDict["Mastering Engineer"] = nil
                            }
                        }
                    }
                    if let alb = instrumentalChosen.albums as? [String] {
                        var instrumentalChosenAlbumsDataArray:[AlbumData] = []
                        for album in strongSelf.personAlbumsArr {
                            if alb.contains(album.toneDeafAppId) {
                                instrumentalChosenAlbumsDataArray.append(album)
                            }
                        }
                        for album in instrumentalChosenAlbumsDataArray {
                            var roleMArkedOnAnotherInstrumental:Bool = false
                            for song in strongSelf.personInstrumentalsArr {
                                if let arrr = song.masteringEngineer as? [String] {
                                    if arrr.contains(strongSelf.currentPerson.toneDeafAppId) {
                                        if let songarr2 = song.albums as? [String] {
                                            if songarr2.contains(album.toneDeafAppId) {
                                                roleMArkedOnAnotherInstrumental = true
                                            }
                                        }
                                    }
                                }
                            }
                            for song in strongSelf.personSongsArr {
                                if let arrr = song.songMasteringEngineer as? [String] {
                                    if arrr.contains(strongSelf.currentPerson.toneDeafAppId) {
                                        if let songarr2 = song.albums as? [String] {
                                            if songarr2.contains(album.toneDeafAppId) {
                                                roleMArkedOnAnotherInstrumental = true
                                            }
                                        }
                                    }
                                }
                            }
                            if roleMArkedOnAnotherInstrumental == false {
                                if let dex = album.masteringEngineers?.firstIndex(of: "\(strongSelf.currentPerson.toneDeafAppId)")
                                {
                                    album.masteringEngineers!.remove(at: Int(dex))
                                }
                                if var arrrr = engineerDict["Mastering Engineer"] as? [String] {
                                    if let dex = arrrr.firstIndex(of: "\(album.toneDeafAppId)")
                                    {
                                        arrrr.remove(at: dex)
                                        if !arrrr.isEmpty {
                                            engineerDict["Mastering Engineer"] = arrrr.sorted()
                                        } else {
                                            engineerDict["Mastering Engineer"] = nil
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
                if engineerDict.isEmpty {
                    newRoles["Engineer"] = nil
                } else {
                    newRoles["Engineer"] = engineerDict
                }
                
                if newRoleArr.isEmpty {
                    let songToGo = strongSelf.personInstrumentalsArr[indexPath.row]
                    let songID = "\(songToGo.toneDeafAppId)"
                    strongSelf.personInstrumentalsArr.remove(at: indexPath.row)
                    strongSelf.currentPerson.instrumentals = []
                    for song in strongSelf.personInstrumentalsArr {
                        strongSelf.currentPerson.instrumentals!.append("\(song.toneDeafAppId)")
                    }
                    if strongSelf.personInstrumentalsArr.isEmpty {
                        strongSelf.currentPerson.instrumentals = nil
                    }
                    tableView.deleteRows(at: [indexPath], with: .fade)
                    if strongSelf.personInstrumentalsArr.count < 6 {
                        strongSelf.personInstrumentalsHeightConstraint.constant = CGFloat(50*(strongSelf.personInstrumentalsArr.count))
                    } else {
                        strongSelf.personInstrumentalsHeightConstraint.constant = CGFloat(270)
                    }
                    
                    if let arr = songToGo.albums as? [String] {
                        for alb in strongSelf.personAlbumsArr {
                            if arr.contains(alb.toneDeafAppId) {
                                var count = 0
                                var albumOnAnotherSong = false
                                for song in strongSelf.personSongsArr {
                                    if let arrr = song.albums as? [String] {
                                        if arrr.contains(alb.toneDeafAppId) && song.toneDeafAppId != songID {
                                            albumOnAnotherSong = true
                                        }
                                    }
                                }
                                for song in strongSelf.personInstrumentalsArr {
                                    if let arrr = song.albums as? [String] {
                                        if arrr.contains(alb.toneDeafAppId) && song.toneDeafAppId != songID {
                                            albumOnAnotherSong = true
                                        }
                                    }
                                }
                                if albumOnAnotherSong == false {
                                    if var curRole = roles {
                                        if var artsubrole = (curRole["Artist"] as? [String]) {
                                            for songTitles in artsubrole {
                                                if songTitles == alb.toneDeafAppId {
                                                    let elementIndex = artsubrole.firstIndex(of: songTitles)
                                                    artsubrole.remove(at: elementIndex!)
                                                }
                                            }
                                            curRole["Artist"] = artsubrole.sorted()
                                            if artsubrole.isEmpty {
                                                curRole["Artist"] = nil
                                            }
                                        } else {
                                            for albbb in strongSelf.albumMainArtistArr {
                                                if albbb == alb.toneDeafAppId {
                                                    if let elementIndex2 = strongSelf.albumMainArtistArr.firstIndex(of: albbb) {
                                                        strongSelf.albumMainArtistArr.remove(at: elementIndex2)
                                                    }
                                                }
                                            }
                                            for albbb in strongSelf.albumFeaturedArtistArr {
                                                if albbb == alb.toneDeafAppId {
                                                    if let elementIndex2 = strongSelf.albumFeaturedArtistArr.firstIndex(of: albbb) {
                                                        strongSelf.albumFeaturedArtistArr.remove(at: elementIndex2)
                                                    }
                                                }
                                            }
                                        }
                                        if var prosubrole = (curRole["Producer"] as? [String]){
                                            for songTitles in prosubrole {
                                                if songTitles == alb.toneDeafAppId {
                                                    let elementIndex = prosubrole.firstIndex(of: songTitles)
                                                    prosubrole.remove(at: elementIndex!)
                                                }
                                            }
                                            curRole["Producer"] = prosubrole.sorted()
                                            if prosubrole.isEmpty {
                                                curRole["Producer"] = nil
                                            }
                                        }
                                        if var wrisubrole = (curRole["Writer"] as? [String]){
                                            for songTitles in wrisubrole {
                                                if songTitles == alb.toneDeafAppId {
                                                    let elementIndex =  wrisubrole.firstIndex(of: songTitles)
                                                    wrisubrole.remove(at: elementIndex!)
                                                }
                                            }
                                            curRole["Writer"] = wrisubrole.sorted()
                                            if wrisubrole.isEmpty {
                                                curRole["Writer"] = nil
                                            }
                                        }
                                        if let engsubCat = curRole["Engineer"] as? NSMutableDictionary{
                                            if var engsubrole = engsubCat["Mix Engineer"] as? [String]{
                                                
                                                for songTitles in engsubrole {
                                                    
                                                    if songTitles == alb.toneDeafAppId {
                                                        
                                                        let elementIndex = engsubrole.firstIndex(of: songTitles)
                                                        engsubrole.remove(at: elementIndex!)
                                                    }
                                                }
                                                engsubCat["Mix Engineer"] = engsubrole.sorted()
                                                if engsubrole.isEmpty {
                                                    engsubCat["Mix Engineer"] = nil
                                                }
                                            }
                                            if var mengsubrole = engsubCat["Mastering Engineer"] as? [String] {
                                                for songTitles in mengsubrole {
                                                    if songTitles == alb.toneDeafAppId {
                                                        let elementIndex = mengsubrole.firstIndex(of: songTitles)
                                                        mengsubrole.remove(at: elementIndex!)
                                                    }
                                                }
                                                engsubCat["Mastering Engineer"] = mengsubrole.sorted()
                                                if mengsubrole.isEmpty {
                                                    engsubCat["Mastering Engineer"] = nil
                                                }
                                            }
                                            if var rengsubrole = engsubCat["Recording Engineer"] as? [String]{
                                                for songTitles in rengsubrole {
                                                    if songTitles == alb.toneDeafAppId {
                                                        let elementIndex = rengsubrole.firstIndex(of: songTitles)
                                                        rengsubrole.remove(at: elementIndex!)
                                                    }
                                                }
                                                engsubCat["Recording Engineer"] = rengsubrole.sorted()
                                                if rengsubrole.isEmpty {
                                                    engsubCat["Recording Engineer"] = nil
                                                }
                                            }
                                            curRole["Engineer"] = engsubCat
                                            if engsubCat.count == 0 {
                                                curRole["Engineer"] = nil
                                            }
                                        }
                                        strongSelf.currentPerson.roles = curRole
                                        strongSelf.initialPerson.roles = curRole
                                        
                                    }
                                    let dex = strongSelf.personAlbumsArr.firstIndex(of: alb)
                                    strongSelf.personAlbumsArr.remove(at: dex!)
                                    strongSelf.personAlbumsTableView.deleteRows(at: [IndexPath(row: dex!, section: 0)], with: .fade)
                                    strongSelf.currentPerson.albums = []
                                    for album in strongSelf.personAlbumsArr {
                                        strongSelf.currentPerson.albums!.append("\(album.toneDeafAppId)")
                                    }
                                    if strongSelf.personAlbumsArr.isEmpty {
                                        strongSelf.currentPerson.albums = nil
                                    }
                                    if strongSelf.personAlbumsArr.count < 6 {
                                        strongSelf.personAlbumsHeightConstraint.constant = CGFloat(50*(strongSelf.personAlbumsArr.count))
                                    } else {
                                        strongSelf.personAlbumsHeightConstraint.constant = CGFloat(270)
                                    }
                                }
                                else {
                                    var rolesOnTheAlbumArr:[String] = []
                                    var rolesInOtherSongsOnTheAlbumArr:[String] = []
                                    if var curRole = roles {
                                        if var artsubrole = (curRole["Artist"] as? [String]) {
                                            for songTitles in artsubrole {
                                                if songTitles == alb.toneDeafAppId {
                                                    rolesOnTheAlbumArr.append("Artist")
                                                }
                                            }
                                        }
                                        if var prosubrole = (curRole["Producer"] as? [String]){
                                            for songTitles in prosubrole {
                                                if songTitles == alb.toneDeafAppId {
                                                    rolesOnTheAlbumArr.append("Producer")
                                                }
                                            }
                                        }
                                        if var wrisubrole = (curRole["Writer"] as? [String]){
                                            for songTitles in wrisubrole {
                                                if songTitles == alb.toneDeafAppId {
                                                    rolesOnTheAlbumArr.append("Writer")
                                                }
                                            }
                                        }
                                        if let engsubCatt = curRole["Engineer"] as? NSDictionary{
                                            let engsubCat = engsubCatt.mutableCopy() as! NSMutableDictionary
                                            if var engsubrole = engsubCat["Mix Engineer"] as? [String]{
                                                
                                                for songTitles in engsubrole {
                                                    if songTitles == alb.toneDeafAppId {
                                                        rolesOnTheAlbumArr.append("Mix Engineer")
                                                    }
                                                }
                                            }
                                            if var mengsubrole = engsubCat["Mastering Engineer"] as? [String] {
                                                for songTitles in mengsubrole {
                                                    if songTitles == alb.toneDeafAppId {
                                                        rolesOnTheAlbumArr.append("Mastering Engineer")
                                                    }
                                                }
                                            }
                                            if var rengsubrole = engsubCat["Recording Engineer"] as? [String]{
                                                for songTitles in rengsubrole {
                                                    if songTitles == alb.toneDeafAppId {
                                                        rolesOnTheAlbumArr.append("Recording Engineer")
                                                    }
                                                }
                                            }
                                        }
                                        
                                    }
                                    for song in strongSelf.personSongsArr {
                                        if let arrr = song.albums as? [String] {
                                            if arrr.contains(alb.toneDeafAppId) && song.toneDeafAppId != songID {
                                                if var curRole = roles {
                                                    if var artsubrole = (curRole["Artist"] as? [String]) {
                                                        for songTitles in artsubrole {
                                                            if songTitles == song.toneDeafAppId {
                                                                rolesInOtherSongsOnTheAlbumArr.append("Artist")
                                                            }
                                                        }
                                                    }
                                                    if var prosubrole = (curRole["Producer"] as? [String]){
                                                        for songTitles in prosubrole {
                                                            if songTitles == song.toneDeafAppId {
                                                                rolesInOtherSongsOnTheAlbumArr.append("Producer")
                                                            }
                                                        }
                                                    }
                                                    if var wrisubrole = (curRole["Writer"] as? [String]){
                                                        for songTitles in wrisubrole {
                                                            if songTitles == song.toneDeafAppId {
                                                                rolesInOtherSongsOnTheAlbumArr.append("Writer")
                                                            }
                                                        }
                                                    }
                                                    if let engsubCat = curRole["Engineer"] as? NSMutableDictionary{
                                                        if var engsubrole = engsubCat["Mix Engineer"] as? [String]{
                                                            
                                                            for songTitles in engsubrole {
                                                                if songTitles == song.toneDeafAppId {
                                                                    rolesInOtherSongsOnTheAlbumArr.append("Mix Engineer")
                                                                }
                                                            }
                                                        }
                                                        if var mengsubrole = engsubCat["Mastering Engineer"] as? [String] {
                                                            for songTitles in mengsubrole {
                                                                if songTitles == song.toneDeafAppId {
                                                                    rolesInOtherSongsOnTheAlbumArr.append("Mastering Engineer")
                                                                }
                                                            }
                                                        }
                                                        if var rengsubrole = engsubCat["Recording Engineer"] as? [String]{
                                                            for songTitles in rengsubrole {
                                                                if songTitles == song.toneDeafAppId {
                                                                    rolesInOtherSongsOnTheAlbumArr.append("Recording Engineer")
                                                                }
                                                            }
                                                        }
                                                    }
                                                    
                                                }
                                            }
                                        }
                                    }
                                    for song in strongSelf.personInstrumentalsArr {
                                        if let arrr = song.albums as? [String] {
                                            if arrr.contains(alb.toneDeafAppId) && song.toneDeafAppId != songID {
                                                if var curRole = roles {
                                                    if var artsubrole = (curRole["Artist"] as? [String]) {
                                                        for songTitles in artsubrole {
                                                            if songTitles == song.toneDeafAppId {
                                                                rolesInOtherSongsOnTheAlbumArr.append("Artist")
                                                            }
                                                        }
                                                    }
                                                    if var prosubrole = (curRole["Producer"] as? [String]){
                                                        for songTitles in prosubrole {
                                                            if songTitles == song.toneDeafAppId {
                                                                rolesInOtherSongsOnTheAlbumArr.append("Producer")
                                                            }
                                                        }
                                                    }
                                                    if let engsubCat = curRole["Engineer"] as? NSMutableDictionary{
                                                        if var engsubrole = engsubCat["Mix Engineer"] as? [String]{
                                                            
                                                            for songTitles in engsubrole {
                                                                if songTitles == song.toneDeafAppId {
                                                                    rolesInOtherSongsOnTheAlbumArr.append("Mix Engineer")
                                                                }
                                                            }
                                                        }
                                                        if var mengsubrole = engsubCat["Mastering Engineer"] as? [String] {
                                                            for songTitles in mengsubrole {
                                                                if songTitles == song.toneDeafAppId {
                                                                    rolesInOtherSongsOnTheAlbumArr.append("Mastering Engineer")
                                                                }
                                                            }
                                                        }
                                                    }
                                                    
                                                }
                                            }
                                        }
                                    }
                                    for value in rolesOnTheAlbumArr {
                                        if !rolesInOtherSongsOnTheAlbumArr.contains(value) {
                                            if var curRole = roles {
                                                switch value {
                                                case "Artist":
                                                    if var prosubrole = (curRole["Artist"] as? [String]){
                                                        for songTitles in prosubrole {
                                                            if songTitles == alb.toneDeafAppId {
                                                                let elementIndex = prosubrole.firstIndex(of: songTitles)
                                                                prosubrole.remove(at: elementIndex!)
                                                            }
                                                        }
                                                        curRole["Artist"] = prosubrole.sorted()
                                                        if prosubrole.isEmpty {
                                                            curRole["Artist"] = nil
                                                        }
                                                    }
                                                    if let dex = alb.mainArtist.firstIndex(of: "\(strongSelf.currentPerson.toneDeafAppId)")
                                                    {
                                                        alb.mainArtist.remove(at: Int(dex))
                                                    }
                                                    if let dex = alb.allArtists?.firstIndex(of: "\(strongSelf.currentPerson.toneDeafAppId)")
                                                    {
                                                        alb.allArtists!.remove(at: Int(dex))
                                                    }
                                                    if let elementIndex2 = strongSelf.albumFeaturedArtistArr.firstIndex(of: alb.toneDeafAppId) {
                                                        strongSelf.albumFeaturedArtistArr.remove(at: elementIndex2)
                                                    }
                                                    if let elementIndex2 = strongSelf.albumMainArtistArr.firstIndex(of: alb.toneDeafAppId) {
                                                        strongSelf.albumMainArtistArr.remove(at: elementIndex2)
                                                    }
                                                case "Producer":
                                                    if var prosubrole = (curRole["Producer"] as? [String]){
                                                        for songTitles in prosubrole {
                                                            if songTitles == alb.toneDeafAppId {
                                                                let elementIndex = prosubrole.firstIndex(of: songTitles)
                                                                prosubrole.remove(at: elementIndex!)
                                                            }
                                                        }
                                                        curRole["Producer"] = prosubrole.sorted()
                                                        if prosubrole.isEmpty {
                                                            curRole["Producer"] = nil
                                                        }
                                                    }
                                                    if let dex = alb.producers.firstIndex(of: "\(strongSelf.currentPerson.toneDeafAppId)")
                                                    {
                                                        alb.producers.remove(at: Int(dex))
                                                    }
                                                case "Writer":
                                                    if var prosubrole = (curRole["Writer"] as? [String]){
                                                        for songTitles in prosubrole {
                                                            if songTitles == alb.toneDeafAppId {
                                                                let elementIndex = prosubrole.firstIndex(of: songTitles)
                                                                prosubrole.remove(at: elementIndex!)
                                                            }
                                                        }
                                                        curRole["Writer"] = prosubrole.sorted()
                                                        if prosubrole.isEmpty {
                                                            curRole["Writer"] = nil
                                                        }
                                                    }
                                                    if let dex = alb.writers?.firstIndex(of: "\(strongSelf.currentPerson.toneDeafAppId)")
                                                    {
                                                        alb.writers!.remove(at: Int(dex))
                                                    }
                                                case "Mix Engineer":
                                                    if let engsubCatt = curRole["Engineer"] as? NSDictionary{
                                                        let engsubCat = engsubCatt.mutableCopy() as! NSMutableDictionary
                                                        if var engsubrole = engsubCat["Mix Engineer"] as? [String]{
                                                            for songTitles in engsubrole {
                                                                if songTitles == alb.toneDeafAppId {
                                                                    let elementIndex = engsubrole.firstIndex(of: songTitles)
                                                                    engsubrole.remove(at: elementIndex!)
                                                                }
                                                            }
                                                            engsubCat["Mix Engineer"] = engsubrole.sorted()
                                                            if engsubrole.isEmpty {
                                                                engsubCat["Mix Engineer"] = nil
                                                            }
                                                        }
                                                        curRole["Engineer"] = engsubCat
                                                        if engsubCat.count == 0 {
                                                            curRole["Engineer"] = nil
                                                        }
                                                    }
                                                    if let dex = alb.mixEngineers?.firstIndex(of: "\(strongSelf.currentPerson.toneDeafAppId)")
                                                    {
                                                        alb.mixEngineers!.remove(at: Int(dex))
                                                    }
                                                case "Mastering Engineer":
                                                    if let engsubCatt = curRole["Engineer"] as? NSDictionary{
                                                        let engsubCat = engsubCatt.mutableCopy() as! NSMutableDictionary
                                                        if var engsubrole = engsubCat["Mastering Engineer"] as? [String]{
                                                            for songTitles in engsubrole {
                                                                if songTitles == alb.toneDeafAppId {
                                                                    let elementIndex = engsubrole.firstIndex(of: songTitles)
                                                                    engsubrole.remove(at: elementIndex!)
                                                                }
                                                            }
                                                            engsubCat["Mastering Engineer"] = engsubrole.sorted()
                                                            if engsubrole.isEmpty {
                                                                engsubCat["Mastering Engineer"] = nil
                                                            }
                                                        }
                                                        curRole["Engineer"] = engsubCat
                                                        if engsubCat.count == 0 {
                                                            curRole["Engineer"] = nil
                                                        }
                                                    }
                                                    if let dex = alb.masteringEngineers?.firstIndex(of: "\(strongSelf.currentPerson.toneDeafAppId)")
                                                    {
                                                        alb.masteringEngineers!.remove(at: Int(dex))
                                                    }
                                                case "Recording Engineer":
                                                    if let engsubCatt = curRole["Engineer"] as? NSDictionary{
                                                        let engsubCat = engsubCatt.mutableCopy() as! NSMutableDictionary
                                                        if var engsubrole = engsubCat["Recording Engineer"] as? [String]{
                                                            for songTitles in engsubrole {
                                                                if songTitles == alb.toneDeafAppId {
                                                                    let elementIndex = engsubrole.firstIndex(of: songTitles)
                                                                    engsubrole.remove(at: elementIndex!)
                                                                }
                                                            }
                                                            engsubCat["Recording Engineer"] = engsubrole.sorted()
                                                            if engsubrole.isEmpty {
                                                                engsubCat["Recording Engineer"] = nil
                                                            }
                                                        }
                                                        curRole["Engineer"] = engsubCat
                                                        if engsubCat.count == 0 {
                                                            curRole["Engineer"] = nil
                                                        }
                                                    }
                                                    if let dex = alb.recordingEngineers?.firstIndex(of: "\(strongSelf.currentPerson.toneDeafAppId)")
                                                    {
                                                        alb.recordingEngineers!.remove(at: Int(dex))
                                                    }
                                                default:
                                                    break
                                                    
                                                }
                                                
                                                strongSelf.currentPerson.roles = curRole
                                                strongSelf.initialPerson.roles = curRole
                                                
                                            }
                                            strongSelf.personAlbumsTableView.reloadData()
                                        }
                                    }
                                }
                            }
                            count+=1
                        }
                    }
                }
                
                strongSelf.currentPerson.roles = ((newRoles as NSDictionary).mutableCopy() as! NSMutableDictionary)
                strongSelf.initialPerson.roles = ((newRoles as NSDictionary).mutableCopy() as! NSMutableDictionary)
                tableView.reloadData()
                strongSelf.personAlbumsTableView.reloadData()
            })
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
            { (action) in
                // ...
            }
            alertController.addAction(cancelAction)
            alertController.addAction(addAction)
            alertController.addAction(editAction)
            var rolearrr:[String] = []
            let art = personInstrumentalsArr[indexPath.row].artist
            
            if let art = personInstrumentalsArr[indexPath.row].artist {
                for artist in art {
                    if artist.contains(currentPerson.toneDeafAppId) {
                        if !rolearrr.contains("Artist") {
                            rolearrr.append("Artist")
                        }
                    }
                }
            }
            let pro = personInstrumentalsArr[indexPath.row].producers
            for producer in pro {
                if producer.contains(currentPerson.toneDeafAppId) {
                    if !rolearrr.contains("Producer") {
                        rolearrr.append("Producer")
                    }
                }
            }
            if let mixeng = personInstrumentalsArr[indexPath.row].mixEngineer {
                for engie in mixeng {
                    if engie.contains(currentPerson.toneDeafAppId) {
                        if !rolearrr.contains("Mix Engineer") {
                            rolearrr.append("Mix Engineer")
                        }
                    }
                }
            }
            if let masteng = personInstrumentalsArr[indexPath.row].masteringEngineer {
                for engie in masteng {
                    if engie.contains(currentPerson.toneDeafAppId) {
                        if !rolearrr.contains("Mastering Engineer") {
                            rolearrr.append("Mastering Engineer")
                        }
                    }
                }
            }
            alertController.view.tintColor = Constants.Colors.redApp

            
            alertController.view.tintColor = UIColor.init(red: 182/255, green: 0/255, blue: 3/255, alpha: 1)
            self.present(alertController, animated: true)
            {
                let cc = alertController.value(forKey: "contentViewController") as! EditPersonRolesPopoverTableViewController
                for i in 1 ... (cc.roleArr.count) {
                    let cell = cc.tableViewPopover.cellForRow(at: IndexPath(row: i-1, section: 0)) as! EditRolePopoverTableCellController
                    if rolearrr.contains(cell.role.text!) {
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
            case personAltNamesTableView:
                currentPerson.alternateNames!.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
                personAltNamesHeightConstraint.constant = CGFloat(50*(currentPerson.alternateNames!.count))
            case personSongsTableView:
                //MARK: - didCommit Songs
                let songToGo = personSongsArr[indexPath.row]
                let songID = "\(songToGo.toneDeafAppId)"
                //let personID = "\(currentPerson.toneDeafAppId)Æ\(currentPerson.name)"
                var roles:NSMutableDictionary?
                roles = currentPerson.roles?.mutableCopy() as? NSMutableDictionary
                
                if var curRole = roles {
                    if var artsubrole = (curRole["Artist"] as? [String]) {
                        for songTitles in artsubrole {
                            if songTitles == songID {
                                let elementIndex = artsubrole.firstIndex(of: songTitles)
                                artsubrole.remove(at: elementIndex!)
                            }
                        }
                        curRole["Artist"] = artsubrole.sorted()
                        if artsubrole.isEmpty {
                            curRole["Artist"] = nil
                        }
                    }
                    if var prosubrole = (curRole["Producer"] as? [String]){
                        for songTitles in prosubrole {
                            if songTitles == songID {
                                let elementIndex = prosubrole.firstIndex(of: songTitles)
                                prosubrole.remove(at: elementIndex!)
                                print(prosubrole)
                            }
                        }
                        curRole["Producer"] = prosubrole.sorted()
                        if prosubrole.isEmpty {
                            curRole["Producer"] = nil
                        }
                    }
                    if var wrisubrole = (curRole["Writer"] as? [String]){
                        for songTitles in wrisubrole {
                            if songTitles == songID {
                                let elementIndex =  wrisubrole.firstIndex(of: songTitles)
                                wrisubrole.remove(at: elementIndex!)
                            }
                        }
                        curRole["Writer"] = wrisubrole.sorted()
                        if wrisubrole.isEmpty {
                            curRole["Writer"] = nil
                        }
                    }
                    if let engsubCat = curRole["Engineer"] as? NSMutableDictionary{
                        if var engsubrole = engsubCat["Mix Engineer"] as? [String]{
                            
                            for songTitles in engsubrole {
                                
                                if songTitles == songID {
                                    
                                    let elementIndex = engsubrole.firstIndex(of: songTitles)
                                    engsubrole.remove(at: elementIndex!)
                                }
                            }
                            engsubCat["Mix Engineer"] = engsubrole.sorted()
                            if engsubrole.isEmpty {
                                engsubCat["Mix Engineer"] = nil
                            }
                        }
                        if var mengsubrole = engsubCat["Mastering Engineer"] as? [String] {
                            for songTitles in mengsubrole {
                                if songTitles == songID {
                                    let elementIndex = mengsubrole.firstIndex(of: songTitles)
                                    mengsubrole.remove(at: elementIndex!)
                                }
                            }
                            engsubCat["Mastering Engineer"] = mengsubrole.sorted()
                            if mengsubrole.isEmpty {
                                engsubCat["Mastering Engineer"] = nil
                            }
                        }
                        if var rengsubrole = engsubCat["Recording Engineer"] as? [String]{
                            for songTitles in rengsubrole {
                                if songTitles == songID {
                                    let elementIndex = rengsubrole.firstIndex(of: songTitles)
                                    rengsubrole.remove(at: elementIndex!)
                                }
                            }
                            engsubCat["Recording Engineer"] = rengsubrole.sorted()
                            if rengsubrole.isEmpty {
                                engsubCat["Recording Engineer"] = nil
                            }
                        }
                        curRole["Engineer"] = engsubCat
                        if engsubCat.count == 0 {
                            curRole["Engineer"] = nil
                        }
                    }
                    currentPerson.roles = curRole
                    initialPerson.roles = curRole
                    
                }
                
                personSongsArr.remove(at: indexPath.row)
                currentPerson.songs = []
                for song in personSongsArr {
                    currentPerson.songs!.append("\(song.toneDeafAppId)")
                }
                if personSongsArr.isEmpty {
                    currentPerson.songs = nil
                }
                tableView.deleteRows(at: [indexPath], with: .fade)
                if personSongsArr.count < 6 {
                    personSongsHeightConstraint.constant = CGFloat(50*(personSongsArr.count))
                } else {
                    personSongsHeightConstraint.constant = CGFloat(270)
                }
                
                if let arr = songToGo.albums as? [String] {
                    for alb in personAlbumsArr {
                        if arr.contains(alb.toneDeafAppId) {
                            var count = 0
                            var albumOnAnotherSong = false
                            for song in personSongsArr {
                                if let arrr = song.albums as? [String] {
                                    if arrr.contains(alb.toneDeafAppId) && song.toneDeafAppId != songID {
                                        albumOnAnotherSong = true
                                    }
                                }
                            }
                            for song in personInstrumentalsArr {
                                if let arrr = song.albums as? [String] {
                                    if arrr.contains(alb.toneDeafAppId) && song.toneDeafAppId != songID {
                                        albumOnAnotherSong = true
                                    }
                                }
                            }
                            if albumOnAnotherSong == false {
                                if var curRole = roles {
                                    if var artsubrole = (curRole["Artist"] as? [String]) {
                                        for songTitles in artsubrole {
                                            if songTitles == alb.toneDeafAppId {
                                                let elementIndex = artsubrole.firstIndex(of: songTitles)
                                                artsubrole.remove(at: elementIndex!)
                                            }
                                        }
                                        curRole["Artist"] = artsubrole.sorted()
                                        if artsubrole.isEmpty {
                                            curRole["Artist"] = nil
                                        }
                                    } else {
                                        for albbb in albumMainArtistArr {
                                            if albbb == alb.toneDeafAppId {
                                                if let elementIndex2 = albumMainArtistArr.firstIndex(of: albbb) {
                                                    albumMainArtistArr.remove(at: elementIndex2)
                                                }
                                            }
                                        }
                                        for albbb in albumFeaturedArtistArr {
                                            if albbb == alb.toneDeafAppId {
                                                if let elementIndex2 = albumFeaturedArtistArr.firstIndex(of: albbb) {
                                                    albumFeaturedArtistArr.remove(at: elementIndex2)
                                                }
                                            }
                                        }
                                    }
                                    if var prosubrole = (curRole["Producer"] as? [String]){
                                        for songTitles in prosubrole {
                                            if songTitles == alb.toneDeafAppId {
                                                let elementIndex = prosubrole.firstIndex(of: songTitles)
                                                prosubrole.remove(at: elementIndex!)
                                            }
                                        }
                                        curRole["Producer"] = prosubrole.sorted()
                                        if prosubrole.isEmpty {
                                            curRole["Producer"] = nil
                                        }
                                    }
                                    if var wrisubrole = (curRole["Writer"] as? [String]){
                                        for songTitles in wrisubrole {
                                            if songTitles == alb.toneDeafAppId {
                                                let elementIndex =  wrisubrole.firstIndex(of: songTitles)
                                                wrisubrole.remove(at: elementIndex!)
                                            }
                                        }
                                        curRole["Writer"] = wrisubrole.sorted()
                                        if wrisubrole.isEmpty {
                                            curRole["Writer"] = nil
                                        }
                                    }
                                    if let engsubCat = curRole["Engineer"] as? NSMutableDictionary{
                                        if var engsubrole = engsubCat["Mix Engineer"] as? [String]{
                                            
                                            for songTitles in engsubrole {
                                                
                                                if songTitles == alb.toneDeafAppId {
                                                    
                                                    let elementIndex = engsubrole.firstIndex(of: songTitles)
                                                    engsubrole.remove(at: elementIndex!)
                                                }
                                            }
                                            engsubCat["Mix Engineer"] = engsubrole.sorted()
                                            if engsubrole.isEmpty {
                                                engsubCat["Mix Engineer"] = nil
                                            }
                                        }
                                        if var mengsubrole = engsubCat["Mastering Engineer"] as? [String] {
                                            for songTitles in mengsubrole {
                                                if songTitles == alb.toneDeafAppId {
                                                    let elementIndex = mengsubrole.firstIndex(of: songTitles)
                                                    mengsubrole.remove(at: elementIndex!)
                                                }
                                            }
                                            engsubCat["Mastering Engineer"] = mengsubrole.sorted()
                                            if mengsubrole.isEmpty {
                                                engsubCat["Mastering Engineer"] = nil
                                            }
                                        }
                                        if var rengsubrole = engsubCat["Recording Engineer"] as? [String]{
                                            for songTitles in rengsubrole {
                                                if songTitles == alb.toneDeafAppId {
                                                    let elementIndex = rengsubrole.firstIndex(of: songTitles)
                                                    rengsubrole.remove(at: elementIndex!)
                                                }
                                            }
                                            engsubCat["Recording Engineer"] = rengsubrole.sorted()
                                            if rengsubrole.isEmpty {
                                                engsubCat["Recording Engineer"] = nil
                                            }
                                        }
                                        curRole["Engineer"] = engsubCat
                                        if engsubCat.count == 0 {
                                            curRole["Engineer"] = nil
                                        }
                                    }
                                    currentPerson.roles = curRole
                                    initialPerson.roles = curRole
                                    
                                }
                                let dex = personAlbumsArr.firstIndex(of: alb)
                                personAlbumsArr.remove(at: dex!)
                                personAlbumsTableView.deleteRows(at: [IndexPath(row: dex!, section: 0)], with: .fade)
                                currentPerson.albums = []
                                for album in personAlbumsArr {
                                    currentPerson.albums!.append("\(album.toneDeafAppId)")
                                }
                                if personAlbumsArr.isEmpty {
                                    currentPerson.albums = nil
                                }
                                personAlbumsHeightConstraint.constant = CGFloat(50*(personAlbumsArr.count))
                            }
                            else {
                                var rolesOnTheAlbumArr:[String] = []
                                var rolesInOtherSongsOnTheAlbumArr:[String] = []
                                if var curRole = roles {
                                    if var artsubrole = (curRole["Artist"] as? [String]) {
                                        for songTitles in artsubrole {
                                            if songTitles == alb.toneDeafAppId {
                                                rolesOnTheAlbumArr.append("Artist")
                                            }
                                        }
                                    }
                                    if var prosubrole = (curRole["Producer"] as? [String]){
                                        for songTitles in prosubrole {
                                            if songTitles == alb.toneDeafAppId {
                                                rolesOnTheAlbumArr.append("Producer")
                                            }
                                        }
                                    }
                                    if var wrisubrole = (curRole["Writer"] as? [String]){
                                        for songTitles in wrisubrole {
                                            if songTitles == alb.toneDeafAppId {
                                                rolesOnTheAlbumArr.append("Writer")
                                            }
                                        }
                                    }
                                    if let engsubCatt = curRole["Engineer"] as? NSDictionary{
                                        let engsubCat = engsubCatt.mutableCopy() as! NSMutableDictionary
                                        if var engsubrole = engsubCat["Mix Engineer"] as? [String]{
                                            
                                            for songTitles in engsubrole {
                                                if songTitles == alb.toneDeafAppId {
                                                    rolesOnTheAlbumArr.append("Mix Engineer")
                                                }
                                            }
                                        }
                                        if var mengsubrole = engsubCat["Mastering Engineer"] as? [String] {
                                            for songTitles in mengsubrole {
                                                if songTitles == alb.toneDeafAppId {
                                                    rolesOnTheAlbumArr.append("Mastering Engineer")
                                                }
                                            }
                                        }
                                        if var rengsubrole = engsubCat["Recording Engineer"] as? [String]{
                                            for songTitles in rengsubrole {
                                                if songTitles == alb.toneDeafAppId {
                                                    rolesOnTheAlbumArr.append("Recording Engineer")
                                                }
                                            }
                                        }
                                    }
                                    
                                }
                                for song in personSongsArr {
                                    if let arrr = song.albums as? [String] {
                                        if arrr.contains(alb.toneDeafAppId) && song.toneDeafAppId != songID {
                                            if var curRole = roles {
                                                if var artsubrole = (curRole["Artist"] as? [String]) {
                                                    for songTitles in artsubrole {
                                                        if songTitles == song.toneDeafAppId {
                                                            rolesInOtherSongsOnTheAlbumArr.append("Artist")
                                                        }
                                                    }
                                                }
                                                if var prosubrole = (curRole["Producer"] as? [String]){
                                                    for songTitles in prosubrole {
                                                        if songTitles == song.toneDeafAppId {
                                                            rolesInOtherSongsOnTheAlbumArr.append("Producer")
                                                        }
                                                    }
                                                }
                                                if var wrisubrole = (curRole["Writer"] as? [String]){
                                                    for songTitles in wrisubrole {
                                                        if songTitles == song.toneDeafAppId {
                                                            rolesInOtherSongsOnTheAlbumArr.append("Writer")
                                                        }
                                                    }
                                                }
                                                if let engsubCat = curRole["Engineer"] as? NSMutableDictionary{
                                                    if var engsubrole = engsubCat["Mix Engineer"] as? [String]{
                                                        
                                                        for songTitles in engsubrole {
                                                            if songTitles == song.toneDeafAppId {
                                                                rolesInOtherSongsOnTheAlbumArr.append("Mix Engineer")
                                                            }
                                                        }
                                                    }
                                                    if var mengsubrole = engsubCat["Mastering Engineer"] as? [String] {
                                                        for songTitles in mengsubrole {
                                                            if songTitles == song.toneDeafAppId {
                                                                rolesInOtherSongsOnTheAlbumArr.append("Mastering Engineer")
                                                            }
                                                        }
                                                    }
                                                    if var rengsubrole = engsubCat["Recording Engineer"] as? [String]{
                                                        for songTitles in rengsubrole {
                                                            if songTitles == song.toneDeafAppId {
                                                                rolesInOtherSongsOnTheAlbumArr.append("Recording Engineer")
                                                            }
                                                        }
                                                    }
                                                }
                                                
                                            }
                                        }
                                    }
                                }
                                for song in personInstrumentalsArr {
                                    if let arrr = song.albums as? [String] {
                                        if arrr.contains(alb.toneDeafAppId) && song.toneDeafAppId != songID {
                                            if var curRole = roles {
                                                if var artsubrole = (curRole["Artist"] as? [String]) {
                                                    for songTitles in artsubrole {
                                                        if songTitles == song.toneDeafAppId {
                                                            rolesInOtherSongsOnTheAlbumArr.append("Artist")
                                                        }
                                                    }
                                                }
                                                if var prosubrole = (curRole["Producer"] as? [String]){
                                                    for songTitles in prosubrole {
                                                        if songTitles == song.toneDeafAppId {
                                                            rolesInOtherSongsOnTheAlbumArr.append("Producer")
                                                        }
                                                    }
                                                }
                                                if let engsubCat = curRole["Engineer"] as? NSMutableDictionary{
                                                    if var engsubrole = engsubCat["Mix Engineer"] as? [String]{
                                                        
                                                        for songTitles in engsubrole {
                                                            if songTitles == song.toneDeafAppId {
                                                                rolesInOtherSongsOnTheAlbumArr.append("Mix Engineer")
                                                            }
                                                        }
                                                    }
                                                    if var mengsubrole = engsubCat["Mastering Engineer"] as? [String] {
                                                        for songTitles in mengsubrole {
                                                            if songTitles == song.toneDeafAppId {
                                                                rolesInOtherSongsOnTheAlbumArr.append("Mastering Engineer")
                                                            }
                                                        }
                                                    }
                                                }
                                                
                                            }
                                        }
                                    }
                                }
                                for value in rolesOnTheAlbumArr {
                                    if !rolesInOtherSongsOnTheAlbumArr.contains(value) {
                                        if var curRole = roles {
                                            switch value {
                                            case "Artist":
                                                if var prosubrole = (curRole["Artist"] as? [String]){
                                                    for songTitles in prosubrole {
                                                        if songTitles == alb.toneDeafAppId {
                                                            let elementIndex = prosubrole.firstIndex(of: songTitles)
                                                            prosubrole.remove(at: elementIndex!)
                                                        }
                                                    }
                                                    curRole["Artist"] = prosubrole.sorted()
                                                    if prosubrole.isEmpty {
                                                        curRole["Artist"] = nil
                                                    }
                                                }
                                                if let dex = alb.mainArtist.firstIndex(of: "\(currentPerson.toneDeafAppId)")
                                                {
                                                    alb.mainArtist.remove(at: Int(dex))
                                                }
                                                if let dex = alb.allArtists?.firstIndex(of: "\(currentPerson.toneDeafAppId)")
                                                {
                                                    alb.allArtists!.remove(at: Int(dex))
                                                }
                                                if let elementIndex2 = albumFeaturedArtistArr.firstIndex(of: alb.toneDeafAppId) {
                                                    albumFeaturedArtistArr.remove(at: elementIndex2)
                                                }
                                                if let elementIndex2 = albumMainArtistArr.firstIndex(of: alb.toneDeafAppId) {
                                                    albumMainArtistArr.remove(at: elementIndex2)
                                                }
                                            case "Producer":
                                                if var prosubrole = (curRole["Producer"] as? [String]){
                                                    for songTitles in prosubrole {
                                                        if songTitles == alb.toneDeafAppId {
                                                            let elementIndex = prosubrole.firstIndex(of: songTitles)
                                                            prosubrole.remove(at: elementIndex!)
                                                        }
                                                    }
                                                    curRole["Producer"] = prosubrole.sorted()
                                                    if prosubrole.isEmpty {
                                                        curRole["Producer"] = nil
                                                    }
                                                }
                                                if let dex = alb.producers.firstIndex(of: "\(currentPerson.toneDeafAppId)")
                                                {
                                                    alb.producers.remove(at: Int(dex))
                                                }
                                            case "Writer":
                                                if var prosubrole = (curRole["Writer"] as? [String]){
                                                    for songTitles in prosubrole {
                                                        if songTitles == alb.toneDeafAppId {
                                                            let elementIndex = prosubrole.firstIndex(of: songTitles)
                                                            prosubrole.remove(at: elementIndex!)
                                                        }
                                                    }
                                                    curRole["Writer"] = prosubrole.sorted()
                                                    if prosubrole.isEmpty {
                                                        curRole["Writer"] = nil
                                                    }
                                                }
                                                if let dex = alb.writers?.firstIndex(of: "\(currentPerson.toneDeafAppId)")
                                                {
                                                    alb.writers!.remove(at: Int(dex))
                                                }
                                            case "Mix Engineer":
                                                if let engsubCatt = curRole["Engineer"] as? NSDictionary{
                                                    let engsubCat = engsubCatt.mutableCopy() as! NSMutableDictionary
                                                    if var engsubrole = engsubCat["Mix Engineer"] as? [String]{
                                                        for songTitles in engsubrole {
                                                            if songTitles == alb.toneDeafAppId {
                                                                let elementIndex = engsubrole.firstIndex(of: songTitles)
                                                                engsubrole.remove(at: elementIndex!)
                                                            }
                                                        }
                                                        engsubCat["Mix Engineer"] = engsubrole.sorted()
                                                        if engsubrole.isEmpty {
                                                            engsubCat["Mix Engineer"] = nil
                                                        }
                                                    }
                                                    curRole["Engineer"] = engsubCat
                                                    if engsubCat.count == 0 {
                                                        curRole["Engineer"] = nil
                                                    }
                                                }
                                                if let dex = alb.mixEngineers?.firstIndex(of: "\(currentPerson.toneDeafAppId)")
                                                {
                                                    alb.mixEngineers!.remove(at: Int(dex))
                                                }
                                            case "Mastering Engineer":
                                                if let engsubCatt = curRole["Engineer"] as? NSDictionary{
                                                    let engsubCat = engsubCatt.mutableCopy() as! NSMutableDictionary
                                                    if var engsubrole = engsubCat["Mastering Engineer"] as? [String]{
                                                        for songTitles in engsubrole {
                                                            if songTitles == alb.toneDeafAppId {
                                                                let elementIndex = engsubrole.firstIndex(of: songTitles)
                                                                engsubrole.remove(at: elementIndex!)
                                                            }
                                                        }
                                                        engsubCat["Mastering Engineer"] = engsubrole.sorted()
                                                        if engsubrole.isEmpty {
                                                            engsubCat["Mastering Engineer"] = nil
                                                        }
                                                    }
                                                    curRole["Engineer"] = engsubCat
                                                    if engsubCat.count == 0 {
                                                        curRole["Engineer"] = nil
                                                    }
                                                }
                                                if let dex = alb.masteringEngineers?.firstIndex(of: "\(currentPerson.toneDeafAppId)")
                                                {
                                                    alb.masteringEngineers!.remove(at: Int(dex))
                                                }
                                            case "Recording Engineer":
                                                if let engsubCatt = curRole["Engineer"] as? NSDictionary{
                                                    let engsubCat = engsubCatt.mutableCopy() as! NSMutableDictionary
                                                    if var engsubrole = engsubCat["Recording Engineer"] as? [String]{
                                                        for songTitles in engsubrole {
                                                            if songTitles == alb.toneDeafAppId {
                                                                let elementIndex = engsubrole.firstIndex(of: songTitles)
                                                                engsubrole.remove(at: elementIndex!)
                                                            }
                                                        }
                                                        engsubCat["Recording Engineer"] = engsubrole.sorted()
                                                        if engsubrole.isEmpty {
                                                            engsubCat["Recording Engineer"] = nil
                                                        }
                                                    }
                                                    curRole["Engineer"] = engsubCat
                                                    if engsubCat.count == 0 {
                                                        curRole["Engineer"] = nil
                                                    }
                                                }
                                                if let dex = alb.recordingEngineers?.firstIndex(of: "\(currentPerson.toneDeafAppId)")
                                                {
                                                    alb.recordingEngineers!.remove(at: Int(dex))
                                                }
                                            default:
                                                break
                                                
                                            }
                                            
                                            currentPerson.roles = curRole
                                            initialPerson.roles = curRole
                                            
                                        }
                                        personAlbumsTableView.reloadData()
                                    }
                                }
                            }
                        }
                        count+=1
                    }
                }
            case personAlbumsTableView:
                //MARK: - didComit Albums
                let songToGo = personAlbumsArr[indexPath.row]
                let songID = "\(songToGo.toneDeafAppId)"
                //let personID = "\(currentPerson.toneDeafAppId)Æ\(currentPerson.name)"
                var roles:NSMutableDictionary?
                roles = currentPerson.roles?.mutableCopy() as? NSMutableDictionary
                
                if var curRole = roles {
                    if var artsubrole = (curRole["Artist"] as? [String]) {
                        for songTitles in artsubrole {
                            if songTitles == songID {
                                let elementIndex = artsubrole.firstIndex(of: songTitles)
                                artsubrole.remove(at: elementIndex!)
                                if let elementIndex2 = albumFeaturedArtistArr.firstIndex(of: songTitles) {
                                    albumFeaturedArtistArr.remove(at: elementIndex2)
                                }
                                if let elementIndex2 = albumMainArtistArr.firstIndex(of: songTitles) {
                                    albumMainArtistArr.remove(at: elementIndex2)
                                }
                            }
                        }
                        curRole["Artist"] = artsubrole.sorted()
                        if artsubrole.isEmpty {
                            curRole["Artist"] = nil
                        }
                    } else {
                        for alb in albumMainArtistArr {
                            if alb == songID {
                                if let elementIndex2 = albumMainArtistArr.firstIndex(of: alb) {
                                    albumMainArtistArr.remove(at: elementIndex2)
                                }
                            }
                        }
                        for alb in albumFeaturedArtistArr {
                            if alb == songID {
                                if let elementIndex2 = albumFeaturedArtistArr.firstIndex(of: alb) {
                                    albumFeaturedArtistArr.remove(at: elementIndex2)
                                }
                            }
                        }
                    }
                    if var prosubrole = (curRole["Producer"] as? [String]){
                        for songTitles in prosubrole {
                            if songTitles == songID {
                                let elementIndex = prosubrole.firstIndex(of: songTitles)
                                prosubrole.remove(at: elementIndex!)
                            }
                        }
                        curRole["Producer"] = prosubrole.sorted()
                        if prosubrole.isEmpty {
                            curRole["Producer"] = nil
                        }
                    }
                    if var wrisubrole = (curRole["Writer"] as? [String]){
                        for songTitles in wrisubrole {
                            if songTitles == songID {
                                let elementIndex =  wrisubrole.firstIndex(of: songTitles)
                                wrisubrole.remove(at: elementIndex!)
                            }
                        }
                        curRole["Writer"] = wrisubrole.sorted()
                        if wrisubrole.isEmpty {
                            curRole["Writer"] = nil
                        }
                    }
                    if let engsubCatt = curRole["Engineer"] as? NSDictionary {
                        let engsubCat = engsubCatt.mutableCopy() as! NSMutableDictionary
                        if var engsubrole = engsubCat["Mix Engineer"] as? [String]{
                            
                            for songTitles in engsubrole {
                                
                                if songTitles == songID {
                                    
                                    let elementIndex = engsubrole.firstIndex(of: songTitles)
                                    engsubrole.remove(at: elementIndex!)
                                }
                            }
                            engsubCat["Mix Engineer"] = engsubrole.sorted()
                            if engsubrole.isEmpty {
                                engsubCat["Mix Engineer"] = nil
                            }
                        }
                        if var mengsubrole = engsubCat["Mastering Engineer"] as? [String] {
                            for songTitles in mengsubrole {
                                if songTitles == songID {
                                    let elementIndex = mengsubrole.firstIndex(of: songTitles)
                                    mengsubrole.remove(at: elementIndex!)
                                }
                            }
                            engsubCat["Mastering Engineer"] = mengsubrole.sorted()
                            if mengsubrole.isEmpty {
                                engsubCat["Mastering Engineer"] = nil
                            }
                        }
                        if var rengsubrole = engsubCat["Recording Engineer"] as? [String]{
                            for songTitles in rengsubrole {
                                if songTitles == songID {
                                    let elementIndex = rengsubrole.firstIndex(of: songTitles)
                                    rengsubrole.remove(at: elementIndex!)
                                }
                            }
                            engsubCat["Recording Engineer"] = rengsubrole.sorted()
                            if rengsubrole.isEmpty {
                                engsubCat["Recording Engineer"] = nil
                            }
                        }
                        curRole["Engineer"] = engsubCat
                        if engsubCat.count == 0 {
                            curRole["Engineer"] = nil
                        }
                    }
                    currentPerson.roles = curRole
                    initialPerson.roles = curRole
                    
                }
                
                if let albumSongs = songToGo.songs {
                    var presentOnAnotherAlbum:Bool = false
                    for song in personSongsArr {
                        if albumSongs.contains(song.toneDeafAppId) {
                            for album in personAlbumsArr {
                                if let eachAlbumSongs = album.songs {
                                    if eachAlbumSongs.contains(song.toneDeafAppId) && album.toneDeafAppId != songToGo.toneDeafAppId {
                                        presentOnAnotherAlbum = true
                                    }
                                }
                            }
                            if presentOnAnotherAlbum == false {
                                
                                if var curRole = roles {
                                    if var artsubrole = (curRole["Artist"] as? [String]) {
                                        for songTitles in artsubrole {
                                            if songTitles == song.toneDeafAppId {
                                                let elementIndex = artsubrole.firstIndex(of: songTitles)
                                                artsubrole.remove(at: elementIndex!)
                                            }
                                        }
                                        curRole["Artist"] = artsubrole.sorted()
                                        if artsubrole.isEmpty {
                                            curRole["Artist"] = nil
                                        }
                                    }
                                    if var prosubrole = (curRole["Producer"] as? [String]){
                                        for songTitles in prosubrole {
                                            if songTitles == song.toneDeafAppId {
                                                let elementIndex = prosubrole.firstIndex(of: songTitles)
                                                prosubrole.remove(at: elementIndex!)
                                            }
                                        }
                                        curRole["Producer"] = prosubrole.sorted()
                                        if prosubrole.isEmpty {
                                            curRole["Producer"] = nil
                                        }
                                    }
                                    if var wrisubrole = (curRole["Writer"] as? [String]){
                                        for songTitles in wrisubrole {
                                            if songTitles == song.toneDeafAppId {
                                                let elementIndex =  wrisubrole.firstIndex(of: songTitles)
                                                wrisubrole.remove(at: elementIndex!)
                                                
                                            }
                                        }
                                        curRole["Writer"] = wrisubrole.sorted()
                                        if wrisubrole.isEmpty {
                                            curRole["Writer"] = nil
                                        }
                                    }
                                    if let engsubCat = curRole["Engineer"] as? NSMutableDictionary{
                                        if var engsubrole = engsubCat["Mix Engineer"] as? [String]{
                                            
                                            for songTitles in engsubrole {
                                                
                                                if songTitles == song.toneDeafAppId {
                                                    
                                                    let elementIndex = engsubrole.firstIndex(of: songTitles)
                                                    engsubrole.remove(at: elementIndex!)
                                                }
                                            }
                                            engsubCat["Mix Engineer"] = engsubrole.sorted()
                                            if engsubrole.isEmpty {
                                                engsubCat["Mix Engineer"] = nil
                                            }
                                        }
                                        if var mengsubrole = engsubCat["Mastering Engineer"] as? [String] {
                                            for songTitles in mengsubrole {
                                                if songTitles == song.toneDeafAppId {
                                                    let elementIndex = mengsubrole.firstIndex(of: songTitles)
                                                    mengsubrole.remove(at: elementIndex!)
                                                }
                                            }
                                            engsubCat["Mastering Engineer"] = mengsubrole.sorted()
                                            if mengsubrole.isEmpty {
                                                engsubCat["Mastering Engineer"] = nil
                                            }
                                        }
                                        if var rengsubrole = engsubCat["Recording Engineer"] as? [String]{
                                            for songTitles in rengsubrole {
                                                if songTitles == song.toneDeafAppId {
                                                    let elementIndex = rengsubrole.firstIndex(of: songTitles)
                                                    rengsubrole.remove(at: elementIndex!)
                                                }
                                            }
                                            engsubCat["Recording Engineer"] = rengsubrole.sorted()
                                            if rengsubrole.isEmpty {
                                                engsubCat["Recording Engineer"] = nil
                                            }
                                        }
                                        curRole["Engineer"] = engsubCat
                                        if engsubCat.count == 0 {
                                            curRole["Engineer"] = nil
                                        }
                                    }
                                    currentPerson.roles = curRole
                                    initialPerson.roles = curRole
                                    
                                }
                                if let elementIndex = personSongsArr.firstIndex(of: song) {
                                    personSongsArr.remove(at: elementIndex)
                                    personSongsTableView.deleteRows(at: [IndexPath(row: elementIndex, section: 0)], with: .fade)
                                }
                                currentPerson.songs = []
                                for songe in personSongsArr {
                                    currentPerson.songs!.append("\(songe.toneDeafAppId)")
                                }
                                if personSongsArr.isEmpty {
                                    currentPerson.songs = nil
                                }
                                personSongsTableView.reloadData()
                                if personSongsArr.count < 6 {
                                    personSongsHeightConstraint.constant = CGFloat(50*(personSongsArr.count))
                                } else {
                                    personSongsHeightConstraint.constant = CGFloat(270)
                                }
                            }
                        }
                    }
                }
                
                if let albumInstrumentals = songToGo.instrumentals {
                    var presentOnAnotherAlbum:Bool = false
                    for song in personInstrumentalsArr {
                        if albumInstrumentals.contains(song.toneDeafAppId) {
                            for album in personAlbumsArr {
                                if let eachAlbumSongs = album.instrumentals {
                                    if eachAlbumSongs.contains(song.toneDeafAppId) && album.toneDeafAppId != songToGo.toneDeafAppId {
                                        presentOnAnotherAlbum = true
                                    }
                                }
                            }
                            if presentOnAnotherAlbum == false {
                                
                                if var curRole = roles {
                                    if var artsubrole = (curRole["Artist"] as? [String]) {
                                        for songTitles in artsubrole {
                                            if songTitles == song.toneDeafAppId {
                                                let elementIndex = artsubrole.firstIndex(of: songTitles)
                                                artsubrole.remove(at: elementIndex!)
                                            }
                                        }
                                        curRole["Artist"] = artsubrole.sorted()
                                        if artsubrole.isEmpty {
                                            curRole["Artist"] = nil
                                        }
                                    }
                                    if var prosubrole = (curRole["Producer"] as? [String]){
                                        for songTitles in prosubrole {
                                            if songTitles == song.toneDeafAppId {
                                                let elementIndex = prosubrole.firstIndex(of: songTitles)
                                                prosubrole.remove(at: elementIndex!)
                                            }
                                        }
                                        curRole["Producer"] = prosubrole.sorted()
                                        if prosubrole.isEmpty {
                                            curRole["Producer"] = nil
                                        }
                                    }
                                    if var wrisubrole = (curRole["Writer"] as? [String]){
                                        for songTitles in wrisubrole {
                                            if songTitles == song.toneDeafAppId {
                                                let elementIndex =  wrisubrole.firstIndex(of: songTitles)
                                                wrisubrole.remove(at: elementIndex!)
                                                
                                            }
                                        }
                                        curRole["Writer"] = wrisubrole.sorted()
                                        if wrisubrole.isEmpty {
                                            curRole["Writer"] = nil
                                        }
                                    }
                                    if let engsubCat = curRole["Engineer"] as? NSMutableDictionary{
                                        if var engsubrole = engsubCat["Mix Engineer"] as? [String]{
                                            
                                            for songTitles in engsubrole {
                                                
                                                if songTitles == song.toneDeafAppId {
                                                    
                                                    let elementIndex = engsubrole.firstIndex(of: songTitles)
                                                    engsubrole.remove(at: elementIndex!)
                                                }
                                            }
                                            engsubCat["Mix Engineer"] = engsubrole.sorted()
                                            if engsubrole.isEmpty {
                                                engsubCat["Mix Engineer"] = nil
                                            }
                                        }
                                        if var mengsubrole = engsubCat["Mastering Engineer"] as? [String] {
                                            for songTitles in mengsubrole {
                                                if songTitles == song.toneDeafAppId {
                                                    let elementIndex = mengsubrole.firstIndex(of: songTitles)
                                                    mengsubrole.remove(at: elementIndex!)
                                                }
                                            }
                                            engsubCat["Mastering Engineer"] = mengsubrole.sorted()
                                            if mengsubrole.isEmpty {
                                                engsubCat["Mastering Engineer"] = nil
                                            }
                                        }
                                        if var rengsubrole = engsubCat["Recording Engineer"] as? [String]{
                                            for songTitles in rengsubrole {
                                                if songTitles == song.toneDeafAppId {
                                                    let elementIndex = rengsubrole.firstIndex(of: songTitles)
                                                    rengsubrole.remove(at: elementIndex!)
                                                }
                                            }
                                            engsubCat["Recording Engineer"] = rengsubrole.sorted()
                                            if rengsubrole.isEmpty {
                                                engsubCat["Recording Engineer"] = nil
                                            }
                                        }
                                        curRole["Engineer"] = engsubCat
                                        if engsubCat.count == 0 {
                                            curRole["Engineer"] = nil
                                        }
                                    }
                                    currentPerson.roles = curRole
                                    initialPerson.roles = curRole
                                    
                                }
                                if let elementIndex = personInstrumentalsArr.firstIndex(of: song) {
                                    personInstrumentalsArr.remove(at: elementIndex)
                                    personInstrumentalsTableView.deleteRows(at: [IndexPath(row: elementIndex, section: 0)], with: .fade)
                                }
                                currentPerson.instrumentals = []
                                for songe in personInstrumentalsArr {
                                    currentPerson.instrumentals!.append("\(songe.toneDeafAppId)")
                                }
                                if personInstrumentalsArr.isEmpty {
                                    currentPerson.instrumentals = nil
                                }
                                personInstrumentalsArr.sort(by: {$0.songName! < $1.songName!})
                                personInstrumentalsTableView.reloadData()
                                personInstrumentalsHeightConstraint.constant = CGFloat(50*(personInstrumentalsArr.count))
                            }
                        }
                    }
                }
                
                personAlbumsArr.remove(at: indexPath.row)
                
                currentPerson.albums = []
                for song in personAlbumsArr {
                    currentPerson.albums!.append("\(song.toneDeafAppId)")
                }
                if personAlbumsArr.isEmpty {
                    currentPerson.albums = nil
                }
                tableView.deleteRows(at: [indexPath], with: .fade)
                personAlbumsHeightConstraint.constant = CGFloat(50*(personAlbumsArr.count))
            case personVideosTableView:
                //MARK: - didCommit Videos
                let songToGo = personVideosArr[indexPath.row]
                let songID = "\(songToGo.toneDeafAppId)"
                var roles:NSMutableDictionary?
                roles = currentPerson.roles?.mutableCopy() as? NSMutableDictionary
                
                if let curRole = roles {
                    if var prosubrole = (curRole["Videographer"] as? [String]){
                        for songTitles in prosubrole {
                            if songTitles == songID {
                                let elementIndex = prosubrole.firstIndex(of: songTitles)
                                prosubrole.remove(at: elementIndex!)
                            }
                        }
                        curRole["Videographer"] = prosubrole.sorted()
                        if prosubrole.isEmpty {
                            curRole["Videographer"] = nil
                        }
                    }
                    currentPerson.roles = curRole
                    initialPerson.roles = curRole
                }
                
                if let arr = songToGo.persons {
                    if arr.contains(currentPerson.toneDeafAppId) {
                        if let elementIndex2 = videoPersonArr.firstIndex(of: songToGo.toneDeafAppId) {
                            videoPersonArr.remove(at: elementIndex2)
                        }
                    }
                }
                
                personVideosArr.remove(at: indexPath.row)
                currentPerson.videos = []
                for song in personVideosArr {
                    currentPerson.videos!.append("\(song.toneDeafAppId)")
                }
                if personVideosArr.isEmpty {
                    currentPerson.videos = nil
                }
                tableView.deleteRows(at: [indexPath], with: .fade)
                personVideosHeightConstraint.constant = CGFloat(70*(personVideosArr.count))
            case personInstrumentalsTableView:
                //MARK: - didCommit Instrumentals
                let songToGo = personInstrumentalsArr[indexPath.row]
                let songID = "\(songToGo.toneDeafAppId)"
                //let personID = "\(currentPerson.toneDeafAppId)Æ\(currentPerson.name)"
                var roles:NSMutableDictionary?
                roles = currentPerson.roles?.mutableCopy() as? NSMutableDictionary
                
                if var curRole = roles {
                    if var artsubrole = (curRole["Artist"] as? [String]) {
                        for songTitles in artsubrole {
                            if songTitles == songID {
                                let elementIndex = artsubrole.firstIndex(of: songTitles)
                                artsubrole.remove(at: elementIndex!)
                            }
                        }
                        curRole["Artist"] = artsubrole.sorted()
                        if artsubrole.isEmpty {
                            curRole["Artist"] = nil
                        }
                    }
                    if var prosubrole = (curRole["Producer"] as? [String]){
                        for songTitles in prosubrole {
                            if songTitles == songID {
                                let elementIndex = prosubrole.firstIndex(of: songTitles)
                                prosubrole.remove(at: elementIndex!)
                            }
                        }
                        curRole["Producer"] = prosubrole.sorted()
                        if prosubrole.isEmpty {
                            curRole["Producer"] = nil
                        }
                    }
                    if var wrisubrole = (curRole["Writer"] as? [String]){
                        for songTitles in wrisubrole {
                            if songTitles == songID {
                                let elementIndex =  wrisubrole.firstIndex(of: songTitles)
                                wrisubrole.remove(at: elementIndex!)
                            }
                        }
                        curRole["Writer"] = wrisubrole.sorted()
                        if wrisubrole.isEmpty {
                            curRole["Writer"] = nil
                        }
                    }
                    if let engsubCat = curRole["Engineer"] as? NSMutableDictionary{
                        if var engsubrole = engsubCat["Mix Engineer"] as? [String]{
                            
                            for songTitles in engsubrole {
                                
                                if songTitles == songID {
                                    
                                    let elementIndex = engsubrole.firstIndex(of: songTitles)
                                    engsubrole.remove(at: elementIndex!)
                                }
                            }
                            engsubCat["Mix Engineer"] = engsubrole.sorted()
                            if engsubrole.isEmpty {
                                engsubCat["Mix Engineer"] = nil
                            }
                        }
                        if var mengsubrole = engsubCat["Mastering Engineer"] as? [String] {
                            for songTitles in mengsubrole {
                                if songTitles == songID {
                                    let elementIndex = mengsubrole.firstIndex(of: songTitles)
                                    mengsubrole.remove(at: elementIndex!)
                                }
                            }
                            engsubCat["Mastering Engineer"] = mengsubrole.sorted()
                            if mengsubrole.isEmpty {
                                engsubCat["Mastering Engineer"] = nil
                            }
                        }
                        if var rengsubrole = engsubCat["Recording Engineer"] as? [String]{
                            for songTitles in rengsubrole {
                                if songTitles == songID {
                                    let elementIndex = rengsubrole.firstIndex(of: songTitles)
                                    rengsubrole.remove(at: elementIndex!)
                                }
                            }
                            engsubCat["Recording Engineer"] = rengsubrole.sorted()
                            if rengsubrole.isEmpty {
                                engsubCat["Recording Engineer"] = nil
                            }
                        }
                        curRole["Engineer"] = engsubCat
                        if engsubCat.count == 0 {
                            curRole["Engineer"] = nil
                        }
                    }
                    currentPerson.roles = curRole
                    initialPerson.roles = curRole
                    
                }
                
                personInstrumentalsArr.remove(at: indexPath.row)
                currentPerson.instrumentals = []
                for song in personInstrumentalsArr {
                    currentPerson.instrumentals!.append("\(song.toneDeafAppId)")
                }
                if personInstrumentalsArr.isEmpty {
                    currentPerson.instrumentals = nil
                }
                tableView.deleteRows(at: [indexPath], with: .fade)
                personInstrumentalsHeightConstraint.constant = CGFloat(50*(personInstrumentalsArr.count))
                
                if let arr = songToGo.albums as? [String] {
                    for alb in personAlbumsArr {
                        if arr.contains(alb.toneDeafAppId) {
                            var count = 0
                            var albumOnAnotherSong = false
                            for song in personSongsArr {
                                if let arrr = song.albums as? [String] {
                                    if arrr.contains(alb.toneDeafAppId) && song.toneDeafAppId != songID {
                                        albumOnAnotherSong = true
                                    }
                                }
                            }
                            for song in personInstrumentalsArr {
                                if let arrr = song.albums as? [String] {
                                    if arrr.contains(alb.toneDeafAppId) && song.toneDeafAppId != songID {
                                        albumOnAnotherSong = true
                                    }
                                }
                            }
                            if albumOnAnotherSong == false {
                                if var curRole = roles {
                                    if var artsubrole = (curRole["Artist"] as? [String]) {
                                        for songTitles in artsubrole {
                                            if songTitles == alb.toneDeafAppId {
                                                let elementIndex = artsubrole.firstIndex(of: songTitles)
                                                artsubrole.remove(at: elementIndex!)
                                            }
                                        }
                                        curRole["Artist"] = artsubrole.sorted()
                                        if artsubrole.isEmpty {
                                            curRole["Artist"] = nil
                                        }
                                    } else {
                                        for albbb in albumMainArtistArr {
                                            if albbb == alb.toneDeafAppId {
                                                if let elementIndex2 = albumMainArtistArr.firstIndex(of: albbb) {
                                                    albumMainArtistArr.remove(at: elementIndex2)
                                                }
                                            }
                                        }
                                        for albbb in albumFeaturedArtistArr {
                                            if albbb == alb.toneDeafAppId {
                                                if let elementIndex2 = albumFeaturedArtistArr.firstIndex(of: albbb) {
                                                    albumFeaturedArtistArr.remove(at: elementIndex2)
                                                }
                                            }
                                        }
                                    }
                                    if var prosubrole = (curRole["Producer"] as? [String]){
                                        for songTitles in prosubrole {
                                            if songTitles == alb.toneDeafAppId {
                                                let elementIndex = prosubrole.firstIndex(of: songTitles)
                                                prosubrole.remove(at: elementIndex!)
                                            }
                                        }
                                        curRole["Producer"] = prosubrole.sorted()
                                        if prosubrole.isEmpty {
                                            curRole["Producer"] = nil
                                        }
                                    }
                                    if var wrisubrole = (curRole["Writer"] as? [String]){
                                        for songTitles in wrisubrole {
                                            if songTitles == alb.toneDeafAppId {
                                                let elementIndex =  wrisubrole.firstIndex(of: songTitles)
                                                wrisubrole.remove(at: elementIndex!)
                                            }
                                        }
                                        curRole["Writer"] = wrisubrole.sorted()
                                        if wrisubrole.isEmpty {
                                            curRole["Writer"] = nil
                                        }
                                    }
                                    if let engsubCat = curRole["Engineer"] as? NSMutableDictionary{
                                        if var engsubrole = engsubCat["Mix Engineer"] as? [String]{
                                            
                                            for songTitles in engsubrole {
                                                
                                                if songTitles == alb.toneDeafAppId {
                                                    
                                                    let elementIndex = engsubrole.firstIndex(of: songTitles)
                                                    engsubrole.remove(at: elementIndex!)
                                                }
                                            }
                                            engsubCat["Mix Engineer"] = engsubrole.sorted()
                                            if engsubrole.isEmpty {
                                                engsubCat["Mix Engineer"] = nil
                                            }
                                        }
                                        if var mengsubrole = engsubCat["Mastering Engineer"] as? [String] {
                                            for songTitles in mengsubrole {
                                                if songTitles == alb.toneDeafAppId {
                                                    let elementIndex = mengsubrole.firstIndex(of: songTitles)
                                                    mengsubrole.remove(at: elementIndex!)
                                                }
                                            }
                                            engsubCat["Mastering Engineer"] = mengsubrole.sorted()
                                            if mengsubrole.isEmpty {
                                                engsubCat["Mastering Engineer"] = nil
                                            }
                                        }
                                        if var rengsubrole = engsubCat["Recording Engineer"] as? [String]{
                                            for songTitles in rengsubrole {
                                                if songTitles == alb.toneDeafAppId {
                                                    let elementIndex = rengsubrole.firstIndex(of: songTitles)
                                                    rengsubrole.remove(at: elementIndex!)
                                                }
                                            }
                                            engsubCat["Recording Engineer"] = rengsubrole.sorted()
                                            if rengsubrole.isEmpty {
                                                engsubCat["Recording Engineer"] = nil
                                            }
                                        }
                                        curRole["Engineer"] = engsubCat
                                        if engsubCat.count == 0 {
                                            curRole["Engineer"] = nil
                                        }
                                    }
                                    currentPerson.roles = curRole
                                    initialPerson.roles = curRole
                                    
                                }
                                let dex = personAlbumsArr.firstIndex(of: alb)
                                personAlbumsArr.remove(at: dex!)
                                personAlbumsTableView.deleteRows(at: [IndexPath(row: dex!, section: 0)], with: .fade)
                                currentPerson.albums = []
                                for album in personAlbumsArr {
                                    currentPerson.albums!.append("\(album.toneDeafAppId)")
                                }
                                if personAlbumsArr.isEmpty {
                                    currentPerson.albums = nil
                                }
                                personAlbumsHeightConstraint.constant = CGFloat(50*(personAlbumsArr.count))
                            }
                            else {
                                var rolesOnTheAlbumArr:[String] = []
                                var rolesInOtherSongsOnTheAlbumArr:[String] = []
                                if var curRole = roles {
                                    if var artsubrole = (curRole["Artist"] as? [String]) {
                                        for songTitles in artsubrole {
                                            if songTitles == alb.toneDeafAppId {
                                                rolesOnTheAlbumArr.append("Artist")
                                            }
                                        }
                                    }
                                    if var prosubrole = (curRole["Producer"] as? [String]){
                                        for songTitles in prosubrole {
                                            if songTitles == alb.toneDeafAppId {
                                                rolesOnTheAlbumArr.append("Producer")
                                            }
                                        }
                                    }
                                    if var wrisubrole = (curRole["Writer"] as? [String]){
                                        for songTitles in wrisubrole {
                                            if songTitles == alb.toneDeafAppId {
                                                rolesOnTheAlbumArr.append("Writer")
                                            }
                                        }
                                    }
                                    if let engsubCatt = curRole["Engineer"] as? NSDictionary{
                                        let engsubCat = engsubCatt.mutableCopy() as! NSMutableDictionary
                                        if var engsubrole = engsubCat["Mix Engineer"] as? [String]{
                                            
                                            for songTitles in engsubrole {
                                                if songTitles == alb.toneDeafAppId {
                                                    rolesOnTheAlbumArr.append("Mix Engineer")
                                                }
                                            }
                                        }
                                        if var mengsubrole = engsubCat["Mastering Engineer"] as? [String] {
                                            for songTitles in mengsubrole {
                                                if songTitles == alb.toneDeafAppId {
                                                    rolesOnTheAlbumArr.append("Mastering Engineer")
                                                }
                                            }
                                        }
                                        if var rengsubrole = engsubCat["Recording Engineer"] as? [String]{
                                            for songTitles in rengsubrole {
                                                if songTitles == alb.toneDeafAppId {
                                                    rolesOnTheAlbumArr.append("Recording Engineer")
                                                }
                                            }
                                        }
                                    }
                                    
                                }
                                for song in personSongsArr {
                                    if let arrr = song.albums as? [String] {
                                        if arrr.contains(alb.toneDeafAppId) && song.toneDeafAppId != songID {
                                            if var curRole = roles {
                                                if var artsubrole = (curRole["Artist"] as? [String]) {
                                                    for songTitles in artsubrole {
                                                        if songTitles == song.toneDeafAppId {
                                                            rolesInOtherSongsOnTheAlbumArr.append("Artist")
                                                        }
                                                    }
                                                }
                                                if var prosubrole = (curRole["Producer"] as? [String]){
                                                    for songTitles in prosubrole {
                                                        if songTitles == song.toneDeafAppId {
                                                            rolesInOtherSongsOnTheAlbumArr.append("Producer")
                                                        }
                                                    }
                                                }
                                                if var wrisubrole = (curRole["Writer"] as? [String]){
                                                    for songTitles in wrisubrole {
                                                        if songTitles == song.toneDeafAppId {
                                                            rolesInOtherSongsOnTheAlbumArr.append("Writer")
                                                        }
                                                    }
                                                }
                                                if let engsubCat = curRole["Engineer"] as? NSMutableDictionary{
                                                    if var engsubrole = engsubCat["Mix Engineer"] as? [String]{
                                                        
                                                        for songTitles in engsubrole {
                                                            if songTitles == song.toneDeafAppId {
                                                                rolesInOtherSongsOnTheAlbumArr.append("Mix Engineer")
                                                            }
                                                        }
                                                    }
                                                    if var mengsubrole = engsubCat["Mastering Engineer"] as? [String] {
                                                        for songTitles in mengsubrole {
                                                            if songTitles == song.toneDeafAppId {
                                                                rolesInOtherSongsOnTheAlbumArr.append("Mastering Engineer")
                                                            }
                                                        }
                                                    }
                                                    if var rengsubrole = engsubCat["Recording Engineer"] as? [String]{
                                                        for songTitles in rengsubrole {
                                                            if songTitles == song.toneDeafAppId {
                                                                rolesInOtherSongsOnTheAlbumArr.append("Recording Engineer")
                                                            }
                                                        }
                                                    }
                                                }
                                                
                                            }
                                        }
                                    }
                                }
                                for song in personInstrumentalsArr {
                                    if let arrr = song.albums as? [String] {
                                        if arrr.contains(alb.toneDeafAppId) && song.toneDeafAppId != songID {
                                            if var curRole = roles {
                                                if var artsubrole = (curRole["Artist"] as? [String]) {
                                                    for songTitles in artsubrole {
                                                        if songTitles == song.toneDeafAppId {
                                                            rolesInOtherSongsOnTheAlbumArr.append("Artist")
                                                        }
                                                    }
                                                }
                                                if var prosubrole = (curRole["Producer"] as? [String]){
                                                    for songTitles in prosubrole {
                                                        if songTitles == song.toneDeafAppId {
                                                            rolesInOtherSongsOnTheAlbumArr.append("Producer")
                                                        }
                                                    }
                                                }
                                                if let engsubCat = curRole["Engineer"] as? NSMutableDictionary{
                                                    if var engsubrole = engsubCat["Mix Engineer"] as? [String]{
                                                        
                                                        for songTitles in engsubrole {
                                                            if songTitles == song.toneDeafAppId {
                                                                rolesInOtherSongsOnTheAlbumArr.append("Mix Engineer")
                                                            }
                                                        }
                                                    }
                                                    if var mengsubrole = engsubCat["Mastering Engineer"] as? [String] {
                                                        for songTitles in mengsubrole {
                                                            if songTitles == song.toneDeafAppId {
                                                                rolesInOtherSongsOnTheAlbumArr.append("Mastering Engineer")
                                                            }
                                                        }
                                                    }
                                                }
                                                
                                            }
                                        }
                                    }
                                }
                                for value in rolesOnTheAlbumArr {
                                    if !rolesInOtherSongsOnTheAlbumArr.contains(value) {
                                        if var curRole = roles {
                                            switch value {
                                            case "Artist":
                                                if var prosubrole = (curRole["Artist"] as? [String]){
                                                    for songTitles in prosubrole {
                                                        if songTitles == alb.toneDeafAppId {
                                                            let elementIndex = prosubrole.firstIndex(of: songTitles)
                                                            prosubrole.remove(at: elementIndex!)
                                                        }
                                                    }
                                                    curRole["Artist"] = prosubrole.sorted()
                                                    if prosubrole.isEmpty {
                                                        curRole["Artist"] = nil
                                                    }
                                                }
                                                if let dex = alb.mainArtist.firstIndex(of: "\(currentPerson.toneDeafAppId)")
                                                {
                                                    alb.mainArtist.remove(at: Int(dex))
                                                }
                                                if let dex = alb.allArtists?.firstIndex(of: "\(currentPerson.toneDeafAppId)")
                                                {
                                                    alb.allArtists!.remove(at: Int(dex))
                                                }
                                                if let elementIndex2 = albumFeaturedArtistArr.firstIndex(of: alb.toneDeafAppId) {
                                                    albumFeaturedArtistArr.remove(at: elementIndex2)
                                                }
                                                if let elementIndex2 = albumMainArtistArr.firstIndex(of: alb.toneDeafAppId) {
                                                    albumMainArtistArr.remove(at: elementIndex2)
                                                }
                                            case "Producer":
                                                if var prosubrole = (curRole["Producer"] as? [String]){
                                                    for songTitles in prosubrole {
                                                        if songTitles == alb.toneDeafAppId {
                                                            let elementIndex = prosubrole.firstIndex(of: songTitles)
                                                            prosubrole.remove(at: elementIndex!)
                                                        }
                                                    }
                                                    curRole["Producer"] = prosubrole.sorted()
                                                    if prosubrole.isEmpty {
                                                        curRole["Producer"] = nil
                                                    }
                                                }
                                                if let dex = alb.producers.firstIndex(of: "\(currentPerson.toneDeafAppId)")
                                                {
                                                    alb.producers.remove(at: Int(dex))
                                                }
                                            case "Writer":
                                                if var prosubrole = (curRole["Writer"] as? [String]){
                                                    for songTitles in prosubrole {
                                                        if songTitles == alb.toneDeafAppId {
                                                            let elementIndex = prosubrole.firstIndex(of: songTitles)
                                                            prosubrole.remove(at: elementIndex!)
                                                        }
                                                    }
                                                    curRole["Writer"] = prosubrole.sorted()
                                                    if prosubrole.isEmpty {
                                                        curRole["Writer"] = nil
                                                    }
                                                }
                                                if let dex = alb.writers?.firstIndex(of: "\(currentPerson.toneDeafAppId)")
                                                {
                                                    alb.writers!.remove(at: Int(dex))
                                                }
                                            case "Mix Engineer":
                                                if let engsubCatt = curRole["Engineer"] as? NSDictionary{
                                                    let engsubCat = engsubCatt.mutableCopy() as! NSMutableDictionary
                                                    if var engsubrole = engsubCat["Mix Engineer"] as? [String]{
                                                        for songTitles in engsubrole {
                                                            if songTitles == alb.toneDeafAppId {
                                                                let elementIndex = engsubrole.firstIndex(of: songTitles)
                                                                engsubrole.remove(at: elementIndex!)
                                                            }
                                                        }
                                                        engsubCat["Mix Engineer"] = engsubrole.sorted()
                                                        if engsubrole.isEmpty {
                                                            engsubCat["Mix Engineer"] = nil
                                                        }
                                                    }
                                                    curRole["Engineer"] = engsubCat
                                                    if engsubCat.count == 0 {
                                                        curRole["Engineer"] = nil
                                                    }
                                                }
                                                if let dex = alb.mixEngineers?.firstIndex(of: "\(currentPerson.toneDeafAppId)")
                                                {
                                                    alb.mixEngineers!.remove(at: Int(dex))
                                                }
                                            case "Mastering Engineer":
                                                if let engsubCatt = curRole["Engineer"] as? NSDictionary{
                                                    let engsubCat = engsubCatt.mutableCopy() as! NSMutableDictionary
                                                    if var engsubrole = engsubCat["Mastering Engineer"] as? [String]{
                                                        for songTitles in engsubrole {
                                                            if songTitles == alb.toneDeafAppId {
                                                                let elementIndex = engsubrole.firstIndex(of: songTitles)
                                                                engsubrole.remove(at: elementIndex!)
                                                            }
                                                        }
                                                        engsubCat["Mastering Engineer"] = engsubrole.sorted()
                                                        if engsubrole.isEmpty {
                                                            engsubCat["Mastering Engineer"] = nil
                                                        }
                                                    }
                                                    curRole["Engineer"] = engsubCat
                                                    if engsubCat.count == 0 {
                                                        curRole["Engineer"] = nil
                                                    }
                                                }
                                                if let dex = alb.masteringEngineers?.firstIndex(of: "\(currentPerson.toneDeafAppId)")
                                                {
                                                    alb.masteringEngineers!.remove(at: Int(dex))
                                                }
                                            case "Recording Engineer":
                                                if let engsubCatt = curRole["Engineer"] as? NSDictionary{
                                                    let engsubCat = engsubCatt.mutableCopy() as! NSMutableDictionary
                                                    if var engsubrole = engsubCat["Recording Engineer"] as? [String]{
                                                        for songTitles in engsubrole {
                                                            if songTitles == alb.toneDeafAppId {
                                                                let elementIndex = engsubrole.firstIndex(of: songTitles)
                                                                engsubrole.remove(at: elementIndex!)
                                                            }
                                                        }
                                                        engsubCat["Recording Engineer"] = engsubrole.sorted()
                                                        if engsubrole.isEmpty {
                                                            engsubCat["Recording Engineer"] = nil
                                                        }
                                                    }
                                                    curRole["Engineer"] = engsubCat
                                                    if engsubCat.count == 0 {
                                                        curRole["Engineer"] = nil
                                                    }
                                                }
                                                if let dex = alb.recordingEngineers?.firstIndex(of: "\(currentPerson.toneDeafAppId)")
                                                {
                                                    alb.recordingEngineers!.remove(at: Int(dex))
                                                }
                                            default:
                                                break
                                                
                                            }
                                            
                                            currentPerson.roles = curRole
                                            initialPerson.roles = curRole
                                            
                                        }
                                        personAlbumsTableView.reloadData()
                                    }
                                }
                            }
                        }
                        count+=1
                    }
                }
            default:
                break
            }
        }
    }
    
    
}

extension EditPersonViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        var nor = 0
        if pickerView == personPickerView {
           nor = AllPersonsInDatabaseArray.count
        }
        return nor
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        var nor = ""
        if pickerView == personPickerView {
           nor = "\(AllPersonsInDatabaseArray[row].name ?? "artist") -- \(AllPersonsInDatabaseArray[row].toneDeafAppId)"
        }
        return nor
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
//        if pickerView == personPickerView {
//        pickerSelected(row: row, pickerView: pickerView)
//        }
    }
    
    func pickerViewToolbar(textField:UITextField, pickerView:UIPickerView) {
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor.init(red: 182/255, green: 0/255, blue: 3/255, alpha: 1)
        toolBar.sizeToFit()

        var doneButton = UIBarButtonItem()
        if pickerView == personPickerView {
           doneButton = UIBarButtonItem(title: "Select", style: UIBarButtonItem.Style.done, target: self, action: #selector(dismissKeyboard2))
        }
        if pickerView == mainRolePickerView {
           doneButton = UIBarButtonItem(title: "Select", style: UIBarButtonItem.Style.done, target: self, action: #selector(dismissKeyboard3))
        }
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItem.Style.plain, target: self, action: #selector(dismissKeyboard))

        if currentPerson == nil {
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

import MarqueeLabel

class EditPersonAltNameTableCell: UITableViewCell {
    
    @IBOutlet weak var name: UILabel!
    
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        
    }
}

class RoleEditSongCell: UITableViewCell {
    @IBOutlet weak var view: UIView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var roles: MarqueeLabel!
    @IBOutlet weak var appid: UILabel!
    @IBOutlet weak var artwork: UIImageView!
    @IBOutlet weak var error: MarqueeLabel!
    
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
    
    func setUp(song: SongData, artistId: String) {
        error.text = ""
        name.text = song.name
        if song.isRemix != nil {
            name.text = "\(song.name) [Remix]"
        }
        appid.text = "App ID: \(song.toneDeafAppId)"
        var rolearr:[String] = []
        let art = song.songArtist
        for artist in art {
            if artist.contains(artistId) {
                if !rolearr.contains("Artist") {
                    rolearr.append("Artist")
                }
            }
        }
        let pro = song.songProducers
        for producer in pro {
            if producer.contains(artistId) {
                if !rolearr.contains("Producer") {
                    rolearr.append("Producer")
                }
            }
        }
        if let wri = song.songWriters {
            for writer in wri {
                if writer.contains(artistId) {
                    if !rolearr.contains("Writer") {
                        rolearr.append("Writer")
                    }
                }
            }
        }
        if let mixeng = song.songMixEngineer {
            for engie in mixeng {
                if engie.contains(artistId) {
                    if !rolearr.contains("MixEng") {
                        rolearr.append("MixEng")
                    }
                }
            }
        }
        if let masteng = song.songMasteringEngineer {
            for engie in masteng {
                if engie.contains(artistId) {
                    if !rolearr.contains("MasEng") {
                        rolearr.append("MasEng")
                    }
                }
            }
        }
        if let receng = song.songRecordingEngineer {
            for engie in receng {
                if engie.contains(artistId) {
                    if !rolearr.contains("RecEng") {
                        rolearr.append("RecEng")
                    }
                }
            }
        }
        roles.text = rolearr.joined(separator: " • ")
        GlobalFunctions.shared.selectImageURL(song: song, completion: {[weak self] aimage in
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
        if song.songArtist.isEmpty {
            error.text = "Song must have at least 1 artist"
            errorView = UIView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height))
            errorView.backgroundColor = Constants.Colors.redApp
            errorView.alpha = 0.2
            view.addSubview(errorView)
            view.sendSubviewToBack(errorView)
        }
        if song.songProducers.isEmpty {
            error.text = "Song must have at least 1 producer"
            errorView = UIView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height))
            errorView.backgroundColor = Constants.Colors.redApp
            errorView.alpha = 0.2
            view.addSubview(errorView)
            view.sendSubviewToBack(errorView)
        }
    }
    
    func setUp(song: SongData, videoId: String) {
        error.text = ""
        roles.text = ""
        name.text = song.name
        if song.isRemix != nil {
            name.text = "\(song.name) [Remix]"
        }
        appid.text = "App ID: \(song.toneDeafAppId)"
        if song.officialVideo == videoId {
            roles.text = "Official"
        }
        if song.audioVideo == videoId {
            roles.text = "Audio"
        }
        if song.lyricVideo == videoId {
            roles.text = "Lyric"
        }
        GlobalFunctions.shared.selectImageURL(song: song, completion: {[weak self] aimage in
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
    
    func setUp(song: SongData) {
        name.text = song.name
        appid.text = "App ID: \(song.toneDeafAppId)"
        roles.text = ""
        GlobalFunctions.shared.selectImageURL(song: song, completion: {[weak self] aimage in
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
    
    func setUp(person: PersonData) {
        name.text = person.name
        appid.text = "App ID: \(person.toneDeafAppId)"
        roles.text = ""
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
    
    func setUp(album: AlbumData) {
        
        name.text = album.name
        appid.text = "App ID: \(album.toneDeafAppId)"
        roles.text = ""
        error.text = ""
        GlobalFunctions.shared.selectImageURL(album: album, completion: {[weak self] aimage in
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
    
    func setUp(beat: BeatData) {
        name.text = beat.name
        appid.text = "App ID: \(beat.toneDeafAppId)"
        roles.text = ""
        let imageURL = URL(string: beat.imageURL)!
        if let cachedImage = imageCache.object(forKey: imageURL.absoluteString as NSString) {
            artwork.image = cachedImage
            return
        } else {
            artwork.setImage(from: imageURL, withPlaceholder: UIImage(named: "tonedeaflogo"))
            return
        }
    }
    
    func setUp(instrumental: InstrumentalData) {
        name.text = instrumental.instrumentalName
        appid.text = "App ID: \(instrumental.toneDeafAppId)"
        roles.text = ""
        GlobalFunctions.shared.selectImageURL(instrumental: instrumental, completion: {[weak self] aimage in
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

class EditPersonAlbumCell: UITableViewCell {
    @IBOutlet weak var view: UIView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var artist: MarqueeLabel!
    @IBOutlet weak var appId: UILabel!
    @IBOutlet weak var artwork: UIImageView!
    @IBOutlet weak var error: MarqueeLabel!
    
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
    
    func setUp(album: AlbumData, artistId: String) {
        error.text = ""
        name.text = album.name
        var rolearr:[String] = []
        let mart = album.mainArtist
        for artist in mart {
            if artist.contains(artistId) {
                if !rolearr.contains("Main Artist") {
                    rolearr.append("Main Artist")
                }
            }
        }
        if let art = album.allArtists {
            for artist in art {
                if artist.contains(artistId) {
                    if !rolearr.contains("Featured Artist") {
                        if !rolearr.contains("Main Artist") {
                            rolearr.append("Featured Artist")
                        }
                    }
                }
            }
        }
        let pro = album.producers
        for producer in pro {
            if producer.contains(artistId) {
                if !rolearr.contains("Producer") {
                    rolearr.append("Producer")
                }
            }
        }
        if let wri = album.writers {
            for writer in wri {
                if writer.contains(artistId) {
                    if !rolearr.contains("Writer") {
                        rolearr.append("Writer")
                    }
                }
            }
        }
        if let mixeng = album.mixEngineers {
            for engie in mixeng {
                if engie.contains(artistId) {
                    if !rolearr.contains("MixEng") {
                        rolearr.append("MixEng")
                    }
                }
            }
        }
        if let masteng = album.masteringEngineers {
            for engie in masteng {
                if engie.contains(artistId) {
                    if !rolearr.contains("MasEng") {
                        rolearr.append("MasEng")
                    }
                }
            }
        }
        if let receng = album.recordingEngineers {
            for engie in receng {
                if engie.contains(artistId) {
                    if !rolearr.contains("RecEng") {
                        rolearr.append("RecEng")
                    }
                }
            }
        }
        artist.text = rolearr.joined(separator: " • ")
        appId.text = "App ID: \(album.toneDeafAppId)"
        GlobalFunctions.shared.selectImageURL(album: album, completion: {[weak self] aimage in
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
        if album.mainArtist.isEmpty {
            error.text = "Album must have at least 1 main artist"
            errorView = UIView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height))
            errorView.backgroundColor = Constants.Colors.redApp
            errorView.alpha = 0.2
            view.addSubview(errorView)
            view.sendSubviewToBack(errorView)
        }
        if album.producers.isEmpty {
            error.text = "Album must have at least 1 producer"
            errorView = UIView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height))
            errorView.backgroundColor = Constants.Colors.redApp
            errorView.alpha = 0.2
            view.addSubview(errorView)
            view.sendSubviewToBack(errorView)
        }
    }
    
    func setUp(album: AlbumData, trackNum: String?) {
        error.text = ""
        name.text = album.name
        if trackNum != nil {
            artist.text = "Track \(trackNum!)"
        } else {
            artist.text = ""
        }
        appId.text = "App ID: \(album.toneDeafAppId)"
        GlobalFunctions.shared.selectImageURL(album: album, completion: {[weak self] aimage in
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
        if album.mainArtist.isEmpty {
            error.text = "Album must have at least 1 main artist"
            errorView = UIView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height))
            errorView.backgroundColor = Constants.Colors.redApp
            errorView.alpha = 0.2
            view.addSubview(errorView)
            view.sendSubviewToBack(errorView)
        }
        if album.producers.isEmpty {
            error.text = "Album must have at least 1 producer"
            errorView = UIView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height))
            errorView.backgroundColor = Constants.Colors.redApp
            errorView.alpha = 0.2
            view.addSubview(errorView)
            view.sendSubviewToBack(errorView)
        }
    }
}

class EditPersonVideoCell: UITableViewCell {
    
    @IBOutlet weak var name: MarqueeLabel!
    @IBOutlet weak var roles: MarqueeLabel!
    @IBOutlet weak var appId: UILabel!
    @IBOutlet weak var artwork: UIImageView!
    
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        artwork.image = nil
        name.text = ""
    }
    
    func setUp(video: VideoData, artistId: String) {
        name.text = video.title
        var rolearr:[String] = []
        if let art = video.videographers {
            for artist in art {
                if artist.contains(artistId) {
                    if !rolearr.contains("Videographer") {
                        rolearr.append("Videographer")
                    }
                }
            }
        }
        if let art = video.persons {
            for artist in art {
                if artist.contains(artistId) {
                    if !rolearr.contains("Person Involved") {
                        rolearr.append("Person Involved")
                    }
                }
            }
        }
        roles.text = rolearr.joined(separator: " • ")
        appId.text = "App ID: \(video.toneDeafAppId)"
        GlobalFunctions.shared.selectImageURL(video: video, completion: {[weak self] aimage in
            guard let strongSelf = self else {return}
            guard let img = aimage else {
                let defaultimg = UIImage(named: "tonedeaflogo")!
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
    
    func setUp(video: VideoData, song:SongData) {
        name.text = video.title
        roles.text = ""
        if song.officialVideo == video.toneDeafAppId {
            roles.text = "Official"
        }
        if song.audioVideo == video.toneDeafAppId {
            roles.text = "Audio"
        }
        if song.lyricVideo == video.toneDeafAppId {
            roles.text = "Lyric"
        }
        appId.text = "App ID: \(video.toneDeafAppId)"
        GlobalFunctions.shared.selectImageURL(video: video, completion: {[weak self] aimage in
            guard let strongSelf = self else {return}
            guard let img = aimage else {
                let defaultimg = UIImage(named: "tonedeaflogo")!
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
    
    func setUp(video: VideoData, album:AlbumData) {
        name.text = video.title
        roles.text = ""
        if album.officialAlbumVideo == video.toneDeafAppId {
            roles.text = "Official"
        }
        appId.text = "App ID: \(video.toneDeafAppId)"
        GlobalFunctions.shared.selectImageURL(video: video, completion: {[weak self] aimage in
            guard let strongSelf = self else {return}
            guard let img = aimage else {
                let defaultimg = UIImage(named: "tonedeaflogo")!
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
    
    func setUp(video: VideoData) {
        name.text = video.title
        roles.text = ""
        appId.text = "App ID: \(video.toneDeafAppId)"
        GlobalFunctions.shared.selectImageURL(video: video, completion: {[weak self] aimage in
            guard let strongSelf = self else {return}
            guard let img = aimage else {
                let defaultimg = UIImage(named: "tonedeaflogo")!
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

class EditPersonInstrumentalCell: UITableViewCell {
    
    @IBOutlet weak var view: UIView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var roles: MarqueeLabel!
    @IBOutlet weak var appId: UILabel!
    @IBOutlet weak var artwork: UIImageView!
    @IBOutlet weak var error: MarqueeLabel!
    
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
    
    func setUp(instrumental: InstrumentalData, artistId: String) {
        error.text = ""
        name.text = instrumental.instrumentalName
        var arr:[String] = []
        if let art = instrumental.artist {
            for artist in art {
                if artist.contains(artistId) {
                    if !arr.contains("Artist") {
                        arr.append("Artist")
                    }
                }
            }
        }
        let pro = instrumental.producers
        for producer in pro {
            if producer.contains(artistId) {
                if !arr.contains("Producer") {
                    arr.append("Producer")
                }
            }
        }
        if let mixeng = instrumental.mixEngineer {
            for engie in mixeng {
                if engie.contains(artistId) {
                    if !arr.contains("MixEng") {
                        arr.append("MixEng")
                    }
                }
            }
        }
        if let masteng = instrumental.masteringEngineer {
            for engie in masteng {
                if engie.contains(artistId) {
                    if !arr.contains("MasEng") {
                        arr.append("MasEng")
                    }
                }
            }
        }
        roles.text = arr.joined(separator: " • ")
        appId.text = "App ID: \(instrumental.toneDeafAppId)"
        GlobalFunctions.shared.selectImageURL(instrumental: instrumental, completion: {[weak self] aimage in
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
        if instrumental.producers.isEmpty {
            error.text = "Instrumental must have at least 1 producer"
            errorView = UIView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height))
            errorView.backgroundColor = Constants.Colors.redApp
            errorView.alpha = 0.2
            view.addSubview(errorView)
            view.sendSubviewToBack(errorView)
        }
    }
    
    func setUp(beat: BeatData, artistId: String, legal: Any) {
        name.text = beat.name
        if let _ = legal as? String {
            error.text = ""
        } else {
            error.text = "Legal Name needed"
            errorView = UIView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height))
            errorView.backgroundColor = Constants.Colors.redApp
            errorView.alpha = 0.2
            view.addSubview(errorView)
            view.sendSubviewToBack(errorView)
        }
        appId.text = "App ID: \(beat.toneDeafAppId)"
        let imageURL = URL(string: beat.imageURL)!
        if let cachedImage = imageCache.object(forKey: imageURL.absoluteString as NSString) {
            artwork.image = cachedImage
            return
        } else {
            artwork.setImage(from: imageURL, withPlaceholder: UIImage(named: "tonedeaflogo"))
            return
        }
    }
    
    func setUp(beat: BeatData, artistId: String) {
        name.text = beat.name
        appId.text = "App ID: \(beat.toneDeafAppId)"
        let imageURL = URL(string: beat.imageURL)!
        if let cachedImage = imageCache.object(forKey: imageURL.absoluteString as NSString) {
            artwork.image = cachedImage
            return
        } else {
            artwork.setImage(from: imageURL, withPlaceholder: UIImage(named: "tonedeaflogo"))
            return
        }
    }
}

extension EditPersonViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        switch textField {
        case hiddenPersonTextField:
            if currentPerson == nil {
//                pickerSelected(row: 0, pickerView: personPickerView)
            }
            else {
                var count = 0
                for per in AllPersonsInDatabaseArray {
                    if per.toneDeafAppId == currentPerson.toneDeafAppId {
//                        pickerSelected(row: count, pickerView: personPickerView)
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

enum EditPersonUpdateError: Error {
    case imageUpdateError(String)
    case nameUpdateError(String)
    case spotifyUpdateError(String)
    case appleUpdateError(String)
    case youtubeUpdateError(String)
    case soundcloudUpdateError(String)
    case youtubeMusicUpdateError(String)
    case amazonUpdateError(String)
    case deezerUpdateError(String)
    case tidalUpdateError(String)
    case napsterUpdateError(String)
    case spinrillaUpdateError(String)
    case twitterUpdateError(String)
    case instagramUpdateError(String)
    case facebookUpdateError(String)
    case tiktokUpdateError(String)
    case songsUpdateError(String)
    case albumsUpdateError(String)
    case videosUpdateError(String)
    case instrumentalsUpdateError(String)
    case beatsUpdateError(String)
}
