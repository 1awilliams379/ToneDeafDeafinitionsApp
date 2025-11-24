//
//  EditVideoViewController.swift
//  ToneDeafDeafinitionsApp
//
//  Created by Tone Deaf on 7/18/22.
//  Copyright © 2022 GITEM Solutions. All rights reserved.
//

import UIKit

protocol EditVideoAllVideosDelegate: class {
    func selectedVideo(_ video: VideoData)
}

protocol EditVideoPersonsDelegate: class {
    func personAdded(_ person: PersonData)
}

protocol EditVideoSongsDelegate: class {
    func songAdded(_ songAndData: [String?:SongData])
}

class EditVideoViewController: UIViewController, EditVideoAllVideosDelegate, EditVideoPersonsDelegate,EditVideoSongsDelegate {
    
    static let shared = EditVideoViewController()
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
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var personsTableView: UITableView!
    @IBOutlet weak var personsHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var videographersTableView: UITableView!
    @IBOutlet weak var videographersHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var youtubeTableView: UITableView!
    @IBOutlet weak var youtubeHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var iGTVTableView: UITableView!
    @IBOutlet weak var iGTVHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var instagramTableView: UITableView!
    @IBOutlet weak var instagramHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var facebookTableView: UITableView!
    @IBOutlet weak var facebookHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var worldstarTableView: UITableView!
    @IBOutlet weak var worldstarHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var twitterTableView: UITableView!
    @IBOutlet weak var twitterHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var appleMusicTableView: UITableView!
    @IBOutlet weak var appleMusicHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var tikTokTableView: UITableView!
    @IBOutlet weak var tikTokHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var songsTableView: UITableView!
    @IBOutlet weak var songsHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var albumsTableView: UITableView!
    @IBOutlet weak var albumsHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var instrumentalsTableView: UITableView!
    @IBOutlet weak var instrumentalsHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var beatsTableView: UITableView!
    @IBOutlet weak var beatsHeightConstraint: NSLayoutConstraint!
    
    var errorCountForController:Int = 0
    
    @IBOutlet weak var changeVideoButton: UIButton!
    @IBOutlet weak var imageURL: CopyableLabel!
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var name: CopyableLabel!
    @IBOutlet weak var type: CopyableLabel!
    @IBOutlet weak var appIDLAbel: CopyableLabel!
    @IBOutlet weak var favoritesLabel: CopyableLabel!
    @IBOutlet weak var viewsLabel: CopyableLabel!
    @IBOutlet weak var dateLabel: CopyableLabel!
    @IBOutlet weak var timeLabel: CopyableLabel!
    @IBOutlet weak var verificationLabel: UILabel!
    @IBOutlet weak var industryCertifiedControl: UISegmentedControl!
    @IBOutlet weak var statusControl: UISegmentedControl!
    @IBOutlet weak var updateButton: UIButton!
    
    var newImage:UIImage!
    var arr = ""
    var prevPage = ""
    var currentFileType = ""
    var tbsender:String!
    
    var personsArr:[PersonData] = []
    var videographersArr:[PersonData] = []
    var songsArr:[SongData] = []
    var albumsArr:[AlbumData] = []
    var instrumentalsArr:[InstrumentalData] = []
    var beatsArr:[BeatData] = []
    
    var typeHold:String!
    
    var videoPickerView = UIPickerView()
    
    let hiddenVideoTextField =  UITextField(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    
    var progressView:UIProgressView!
    var totalProgress:Float = 0
    var progressCompleted:Float = 0
    var alertView:UIAlertController!
    
    var currentVideo:VideoData!
    let initialVideo = VideoData(title: "", toneDeafAppId: "", persons: nil, videographers: nil, albums: nil, instrumentals: nil, merch: nil, songs: nil, beats: nil, favorites: 0, type: "", timeIA: "", dateIA: "", viewsIA: 0, manualThumbnailURL: nil, isActive: false, youtube: nil, igtv: nil, instagramPost: nil, facebookPost: nil, worldstar: nil, twitter: nil, appleMusic: nil, tikTok: nil, industryCerified: nil, verificationLevel: nil)
    
    var itemDictYoutube:[YouTubeData]? = nil
    var newDictYoutube:[YouTubeData]? = nil
    var itemDictIGTV:[IGTVData]? = nil
    var newDictIGTV:[IGTVData]? = nil
    var itemDictInstagram:[InstagramPostData]? = nil
    var newDictInstagram:[InstagramPostData]? = nil
    var itemDictFacebook:[FacebookPostData]? = nil
    var newDictFacebook:[FacebookPostData]? = nil
    var itemDictWorldstar:[WorldstarData]? = nil
    var newDictWorldstar:[WorldstarData]? = nil
    var itemDictTwitter:[TwitterTweetData]? = nil
    var newDictTwitter:[TwitterTweetData]? = nil
    var itemDictApple:[AppleVideoData]? = nil
    var newDictApple:[AppleVideoData]? = nil
    var itemDictTikTok:[TikTokData]? = nil
    var newDictTikTok:[TikTokData]? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        selectedVideo(currentVideo)
        setUpElements()
        createObservers()
    }
    
    deinit {
        print("📗 Edit Video view controller deinitialized.")
        AllPersonsInDatabaseArray = nil
        AllVideosInDatabaseArray = nil
        AllSongsInDatabaseArray = nil
        AllAlbumsInDatabaseArray = nil
        AllInstrumentalsInDatabaseArray = nil
        AllBeatsInDatabaseArray = nil
        currentVideo = nil
        newImage = nil
        NotificationCenter.default.removeObserver(self)
    }
    
    func createObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(updateVideo(notification:)), name: EditVideoYoutubeURLStatusNotify, object: nil)
    }
    
    @objc func updateVideo(notification: Notification) {
        let vid = (notification.object as! VideoData)
        currentVideo = vid
    }
    
    func selectedVideo(_ video: VideoData) {
        let a = video
        currentVideo = video
        let b = a
        
        initialVideo.toneDeafAppId = b.toneDeafAppId
        initialVideo.instrumentals = b.instrumentals
        initialVideo.dateIA = b.dateIA
        initialVideo.timeIA = b.timeIA
        initialVideo.viewsIA = b.viewsIA
        initialVideo.songs = b.songs
        initialVideo.albums = b.albums
        initialVideo.beats = b.beats
        initialVideo.merch = b.merch
        initialVideo.title = b.title
        initialVideo.persons = b.persons
        initialVideo.videographers = b.videographers
        initialVideo.favorites = b.favorites
        initialVideo.type = b.type
        initialVideo.manualThumbnailURL = b.manualThumbnailURL
        initialVideo.appleMusic = b.appleMusic
        if b.appleMusic != nil {
            itemDictApple = []
            for item in b.appleMusic! {
                itemDictApple!.append(item.copy() as! AppleVideoData)
            }
        }
        initialVideo.youtube = b.youtube
        if b.youtube != nil {
            itemDictYoutube = []
            for item in b.youtube! {
                itemDictYoutube!.append(item.copy() as! YouTubeData)
            }
        }
        initialVideo.igtv = b.igtv
        if b.igtv != nil {
            itemDictIGTV = []
            for item in b.igtv! {
                itemDictIGTV!.append(item.copy() as! IGTVData)
            }
        }
        initialVideo.instagramPost = b.instagramPost
        if b.instagramPost != nil {
            itemDictInstagram = []
            for item in b.instagramPost! {
                itemDictInstagram!.append(item.copy() as! InstagramPostData)
            }
        }
        initialVideo.facebookPost = b.facebookPost
        if b.facebookPost != nil {
            itemDictFacebook = []
            for item in b.facebookPost! {
                itemDictFacebook!.append(item.copy() as! FacebookPostData)
            }
        }
        initialVideo.worldstar = b.worldstar
        if b.worldstar != nil {
            itemDictWorldstar = []
            for item in b.worldstar! {
                itemDictWorldstar!.append(item.copy() as! WorldstarData)
            }
        }
        initialVideo.twitter = b.twitter
        if b.twitter != nil {
            itemDictTwitter = []
            for item in b.twitter! {
                itemDictTwitter!.append(item.copy() as! TwitterTweetData)
            }
        }
        initialVideo.tikTok = b.tikTok
        if b.tikTok != nil {
            itemDictTikTok = []
            for item in b.tikTok! {
                itemDictTikTok!.append(item.copy() as! TikTokData)
            }
        }
        initialVideo.industryCerified = b.industryCerified
        initialVideo.verificationLevel = b.verificationLevel
        initialVideo.isActive = b.isActive
        
        dismissKeyboard2()
    }
    
    func setUpElements() {
        changeVideoButton.setTitleColor(Constants.Colors.redApp, for: .normal)
        view.addSubview(hiddenVideoTextField)
        hiddenVideoTextField.isHidden = true
        hiddenVideoTextField.inputView = videoPickerView
        videoPickerView.delegate = self
        videoPickerView.dataSource = self
        pickerViewToolbar(textField: hiddenVideoTextField, pickerView: videoPickerView)
        hiddenVideoTextField.delegate = self
    }
    
    func setUpPage() {
        changeVideoButton.setTitleColor(Constants.Colors.redApp, for: .normal)
        pickerViewToolbar(textField: hiddenVideoTextField, pickerView: videoPickerView)
        name.text = currentVideo.title
        appIDLAbel.text = currentVideo.toneDeafAppId
        verificationLabel.text = String(currentVideo.verificationLevel!)
        type.text = currentVideo.type
        favoritesLabel.text = String(currentVideo.favorites)
        viewsLabel.text = String(currentVideo.viewsIA)
        dateLabel.text = currentVideo.dateIA
        timeLabel.text = currentVideo.timeIA
        personsTableView.delegate = self
        personsTableView.dataSource = self
        if let psa = currentVideo.persons {
            setPersonsArr(arr: psa, completion: {[weak self] _ in
                guard let strongSelf = self else {return}
                strongSelf.personsTableView.reloadData()
                strongSelf.personsHeightConstraint.constant = CGFloat(50*(strongSelf.personsArr.count))
            })
        } else {
            personsHeightConstraint.constant = 0
        }
        videographersTableView.delegate = self
        videographersTableView.dataSource = self
        if let psa = currentVideo.videographers {
        setVideographersArr(arr: psa, completion: {[weak self] _ in
            guard let strongSelf = self else {return}
            strongSelf.videographersTableView.reloadData()
            strongSelf.videographersHeightConstraint.constant = CGFloat(50*(strongSelf.videographersArr.count))
        })
        } else {
            videographersHeightConstraint.constant = 0
        }
        youtubeTableView.delegate = self
        youtubeTableView.dataSource = self
        if let psa = currentVideo.youtube {
            youtubeTableView.reloadData()
            youtubeHeightConstraint.constant = CGFloat(70*(psa.count))
        } else {
            youtubeHeightConstraint.constant = 0
        }
        iGTVTableView.delegate = self
        iGTVTableView.dataSource = self
        if let psa = currentVideo.igtv {
            iGTVTableView.reloadData()
            iGTVHeightConstraint.constant = CGFloat(70*(psa.count))
        } else {
            iGTVHeightConstraint.constant = 0
        }
        instagramTableView.delegate = self
        instagramTableView.dataSource = self
        if let psa = currentVideo.instagramPost {
            instagramTableView.reloadData()
            instagramHeightConstraint.constant = CGFloat(70*(psa.count))
        } else {
            instagramHeightConstraint.constant = 0
        }
        facebookTableView.delegate = self
        facebookTableView.dataSource = self
        if let psa = currentVideo.facebookPost {
            facebookTableView.reloadData()
            facebookHeightConstraint.constant = CGFloat(70*(psa.count))
        } else {
            facebookHeightConstraint.constant = 0
        }
        worldstarTableView.delegate = self
        worldstarTableView.dataSource = self
        if let psa = currentVideo.worldstar {
            worldstarTableView.reloadData()
            worldstarHeightConstraint.constant = CGFloat(70*(psa.count))
        } else {
            worldstarHeightConstraint.constant = 0
        }
        twitterTableView.delegate = self
        twitterTableView.dataSource = self
        if let psa = currentVideo.twitter {
            twitterTableView.reloadData()
            twitterHeightConstraint.constant = CGFloat(70*(psa.count))
        } else {
            twitterHeightConstraint.constant = 0
        }
        appleMusicTableView.delegate = self
        appleMusicTableView.dataSource = self
        if let psa = currentVideo.appleMusic {
            appleMusicTableView.reloadData()
            appleMusicHeightConstraint.constant = CGFloat(70*(psa.count))
        } else {
            appleMusicHeightConstraint.constant = 0
        }
        tikTokTableView.delegate = self
        tikTokTableView.dataSource = self
        if let psa = currentVideo.tikTok {
            tikTokTableView.reloadData()
            tikTokHeightConstraint.constant = CGFloat(70*(psa.count))
        } else {
            tikTokHeightConstraint.constant = 0
        }
        songsTableView.delegate = self
        songsTableView.dataSource = self
        if let psa = currentVideo.songs {
            setSongsArr(arr: psa, completion: {[weak self] _ in
                guard let strongSelf = self else {return}
                strongSelf.songsTableView.reloadData()
                strongSelf.songsHeightConstraint.constant = CGFloat(50*(strongSelf.songsArr.count))
            })
        } else {
            songsHeightConstraint.constant = 0
        }
        albumsTableView.delegate = self
        albumsTableView.dataSource = self
        if let psa = currentVideo.albums {
            setAlbumsArr(arr: psa, completion: {[weak self] _ in
                guard let strongSelf = self else {return}
                strongSelf.albumsTableView.reloadData()
                strongSelf.albumsHeightConstraint.constant = CGFloat(50*(strongSelf.albumsArr.count))
            })
        } else {
            albumsHeightConstraint.constant = 0
        }
        instrumentalsTableView.delegate = self
        instrumentalsTableView.dataSource = self
        if let psa = currentVideo.instrumentals {
            setInstrumentalsArr(arr: psa, completion: {[weak self] _ in
                guard let strongSelf = self else {return}
                strongSelf.instrumentalsTableView.reloadData()
                strongSelf.instrumentalsHeightConstraint.constant = CGFloat(50*(strongSelf.instrumentalsArr.count))
            })
        } else {
            instrumentalsHeightConstraint.constant = 0
        }
        beatsTableView.delegate = self
        beatsTableView.dataSource = self
        if let psa = currentVideo.beats {
            setBeatsArr(arr: psa, completion: {[weak self] _ in
                guard let strongSelf = self else {return}
                strongSelf.beatsTableView.reloadData()
                strongSelf.beatsHeightConstraint.constant = CGFloat(50*(strongSelf.beatsArr.count))
            })
        } else {
            beatsHeightConstraint.constant = 0
        }
        if currentVideo.industryCerified! {
            industryCertifiedControl.selectedSegmentIndex = 0
            industryCertifiedControl.selectedSegmentTintColor = .systemGreen
        } else {
            industryCertifiedControl.selectedSegmentTintColor = Constants.Colors.redApp
            industryCertifiedControl.selectedSegmentIndex = 1
        }
        if currentVideo.isActive {
            statusControl.selectedSegmentIndex = 0
            statusControl.selectedSegmentTintColor = .systemGreen
        } else {
            statusControl.selectedSegmentTintColor = Constants.Colors.redApp
            statusControl.selectedSegmentIndex = 1
        }
        GlobalFunctions.shared.selectImageURL(video: currentVideo, completion: {[weak self] aimage in
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
    
    func setPersonsArr(arr: [String], completion: @escaping ((Error?) -> Void)) {
            personsArr = []
            if arr != [] {
                for person in arr {
                    getPerson(personIdFull: person, completion: {[weak self] personData in
                        guard let strongSelf = self else {return}
                        strongSelf.personsArr.append(personData)
                        completion(nil)
                    })
                }
            } else {
                personsHeightConstraint.constant = CGFloat(50*(personsArr.count))
            }
    }
    
    func setVideographersArr(arr: [String], completion: @escaping ((Error?) -> Void)) {
            videographersArr = []
            if arr != [] {
                for person in arr {
                    getPerson(personIdFull: person, completion: {[weak self] personData in
                        guard let strongSelf = self else {return}
                        strongSelf.videographersArr.append(personData)
                        completion(nil)
                    })
                }
            } else {
                videographersHeightConstraint.constant = CGFloat(50*(videographersArr.count))
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
    
    func setAlbumsArr(arr: [String], completion: @escaping ((Error?) -> Void)) {
            albumsArr = []
            if arr != [] {
                
                for video in arr {
                    getAlbum(albumIdFull: video, completion: {[weak self] albumData in
                        
                        guard let strongSelf = self else {return}
                        strongSelf.albumsArr.append(albumData)
                        completion(nil)
                    })
                }
            } else {
                albumsHeightConstraint.constant = CGFloat(50*(albumsArr.count))
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
    
    func setBeatsArr(arr: [String], completion: @escaping ((Error?) -> Void)) {
            beatsArr = []
            if arr != [] {
                for beat in arr {
                    getBeat(beatIdFull: beat, completion: {[weak self] beatData in
                        guard let strongSelf = self else {return}
                        strongSelf.beatsArr.append(beatData)
                        completion(nil)
                    })
                }
            } else {
                beatsHeightConstraint.constant = CGFloat(50*(beatsArr.count))
            }
    }
    
    @IBAction func newVideoTapped(_ sender: Any) {
        arr = "video"
        prevPage = "editVideoAll"
        performSegue(withIdentifier: "editVideoToTonesPick", sender: nil)
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
        actionSheet.addAction(UIAlertAction(title: "Use Video Default",
                                            style: .default,
                                            handler: { [weak self] _ in
            guard let strongSelf = self else {return}
            strongSelf.currentVideo.manualThumbnailURL = nil
            strongSelf.newImage = nil
            strongSelf.imageURL.textColor = .green
            strongSelf.setUpPage()
            
            actionSheet.dismiss(animated: true)
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        actionSheet.view.tintColor = Constants.Colors.redApp
        present(actionSheet, animated: true)
    }
    
    @IBAction func changeTitleTapped(_ sender: Any) {
        let alertC = UIAlertController(title: "Change Title",
                                                message: "Please type in a title.",
                                                preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Change", style: .default, handler: {[weak self] _ in
            guard let strongSelf = self else {return}
            let field = alertC.textFields![0]
            if field.text != "" {
                guard let name = field.text else {return}
                strongSelf.name.text = name
                strongSelf.name.textColor = .green
                strongSelf.currentVideo.title = name
                alertC.dismiss(animated: true, completion: nil)
            } else {
                alertC.dismiss(animated: true, completion: nil)
            }
        })
        alertC.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alertC.addAction(okAction)
        alertC.addTextField()
        alertC.textFields![0].text = currentVideo.title
        alertC.view.tintColor = Constants.Colors.redApp
        self.present(alertC, animated: true)
    }
    
    @IBAction func changeTypeTapped(_ sender: Any) {
        hiddenVideoTextField.becomeFirstResponder()
    }
    
    @IBAction func addVideographerTapped(_ sender: Any) {
        arr = "person"
        prevPage = "editVideo"
        tbsender = "videographer"
        performSegue(withIdentifier: "editVideoToTonesPick", sender: nil)
    }
    
    @IBAction func addPersonTapped(_ sender: Any) {
        arr = "person"
        prevPage = "editVideo"
        tbsender = "person"
        performSegue(withIdentifier: "editVideoToTonesPick", sender: nil)
    }
    
    func personAdded(_ person: PersonData) {
        lightImpactGenerator.impactOccurred(intensity: 0.75)
        switch tbsender {
        case "videographer":
            if !videographersArr.contains(person) {
                videographersArr.append(person)
            } else {
                let dex = videographersArr.firstIndex(of: person)
                videographersArr[dex!] = person
            }
            
            if currentVideo.videographers == nil {
                currentVideo.videographers = ["\(person.toneDeafAppId)"]
            } else {
                if var arr = currentVideo.videographers {
                    if !arr.contains(person.toneDeafAppId) {
                        arr.append("\(person.toneDeafAppId)")
                        arr.sort()
                        currentVideo.videographers = arr
                    }
                } else {
                    var arr:[String] = []
                    arr.append("\(person.toneDeafAppId)")
                    arr.sort()
                    currentVideo.videographers = arr
                }
            }
            DispatchQueue.main.async {[weak self]  in
                guard let strongSelf = self else {return}
                strongSelf.videographersArr.sort(by: {$0.name < $1.name})
                strongSelf.videographersTableView.reloadData()
                if strongSelf.videographersArr.count < 6 {
                    strongSelf.videographersHeightConstraint.constant = CGFloat(50*(strongSelf.videographersArr.count))
                } else {
                    strongSelf.videographersHeightConstraint.constant = CGFloat(270)
                }
            }
        case "person":
            if !personsArr.contains(person) {
                personsArr.append(person)
            } else {
                let dex = personsArr.firstIndex(of: person)
                personsArr[dex!] = person
            }
            
            if currentVideo.persons == nil {
                currentVideo.persons = ["\(person.toneDeafAppId)"]
            } else {
                if var arr = currentVideo.persons {
                    if !arr.contains(person.toneDeafAppId) {
                        arr.append("\(person.toneDeafAppId)")
                        arr.sort()
                        currentVideo.persons = arr
                    }
                } else {
                    var arr:[String] = []
                    arr.append("\(person.toneDeafAppId)")
                    arr.sort()
                    currentVideo.persons = arr
                }
            }
            DispatchQueue.main.async {[weak self]  in
                guard let strongSelf = self else {return}
                strongSelf.personsArr.sort(by: {$0.name < $1.name})
                strongSelf.personsTableView.reloadData()
                if strongSelf.personsArr.count < 6 {
                    strongSelf.personsHeightConstraint.constant = CGFloat(50*(strongSelf.personsArr.count))
                } else {
                    strongSelf.personsHeightConstraint.constant = CGFloat(270)
                }
            }
        default:
            break
        }
    }
    
    @IBAction func addYoutubeURLTapped(_ sender: Any) {
        let alertC = UIAlertController(title: "Add Youtube URL",
                                                message: "Please type in a Youtube URL.",
                                                preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Add", style: .default, handler: {[weak self] _ in
            guard let strongSelf = self else {return}
            let field = alertC.textFields![0]
            if field.text != nil, field.text != "" {
                var url = field.text!
                    DispatchQueue.main.async {
                        NotificationCenter.default.post(name: adminDashboardStartSpinnerNotify, object: nil)
                    }
                GlobalFunctions.shared.verifyUrl(urlString: url, completion: {validity in
                    if !validity {
                        DispatchQueue.main.async {
                            NotificationCenter.default.post(name: adminDashboardStopSpinnerNotify, object: nil)
                        }
                        mediumImpactGenerator.impactOccurred()
                        DispatchQueue.main.async {
                            Utilities.showError2("Youube url invalid.", actionText: "OK")
                            alertC.dismiss(animated: true, completion: nil)
                        }
                    } else {
                        let formatter = DateFormatter()
                        formatter.timeZone = TimeZone(identifier: "EDT")
                        formatter.dateFormat = "MMMM dd, yyyy"
                        let currdate = formatter.string(from: Date())
                        
                        let timeFormatter = DateFormatter()
                        timeFormatter.timeZone = TimeZone(identifier: "EDT")
                        timeFormatter.dateFormat = "HH:mm:ss a"
                        let currtime = timeFormatter.string(from: Date())
                        
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
                                DispatchQueue.main.async {
                                    NotificationCenter.default.post(name: adminDashboardStopSpinnerNotify, object: nil)
                                }
                                DispatchQueue.main.async {
                                    Utilities.showError2("Youtube url parsing error", actionText: "OK")
                                    alertC.dismiss(animated: true, completion: nil)
                                }
                            }
                            YoutubeRequest.shared.getVideos(videoId: videoId, url: url, tdAppId: strongSelf.currentVideo.toneDeafAppId, completion: { result in
                                switch result {
                                case.success(let video):
                                    video.dateIA = currdate
                                    video.timeIA = currtime
                                    var ytContentKey:String!
                                    switch strongSelf.currentVideo.type {
                                    case "Music Video":
                                        ytContentKey = youtubeVideoContentTyp
                                    case "Audio Video":
                                        ytContentKey = youtubeAudioVideoContentType
                                    case "Playlist":
                                        ytContentKey = youtubePlaylistContentType
                                    default:
                                        ytContentKey = youtubeAltVideoContentType
                                    }
                                    video.type = ytContentKey
                                    
                                    if strongSelf.currentVideo.youtube == nil {
                                        strongSelf.currentVideo.youtube = []
                                    }
                                    if !strongSelf.currentVideo.youtube!.contains(video) {
                                        strongSelf.currentVideo.youtube!.append(video)
                                    }
                                    DispatchQueue.main.async {
                                        NotificationCenter.default.post(name: adminDashboardStopSpinnerNotify, object: nil)
                                    }
                                    DispatchQueue.main.async {
                                        strongSelf.youtubeTableView.reloadData()
                                        if strongSelf.currentVideo.youtube!.count < 6 {
                                            strongSelf.youtubeHeightConstraint.constant = CGFloat(70*(strongSelf.currentVideo.youtube!.count))
                                        } else {
                                            strongSelf.youtubeHeightConstraint.constant = CGFloat(370)
                                        }
                                        alertC.dismiss(animated: true, completion: nil)
                                    }
                                case .failure(let error):
                                    DispatchQueue.main.async {
                                        NotificationCenter.default.post(name: adminDashboardStopSpinnerNotify, object: nil)
                                    }
                                    DispatchQueue.main.async {
                                        Utilities.showError2("Youtube url parsing error \(error)", actionText: "OK")
                                        alertC.dismiss(animated: true, completion: nil)
                                    }
                                }
                            })
                        } else {
                            if url.contains("playlist?list=") {
                                if let range = url.range(of: "=") {
                                    url.removeSubrange(url.startIndex..<range.lowerBound)
                                }
                                videoId = String(url.dropFirst())
                                
                            } else {
                                DispatchQueue.main.async {
                                    NotificationCenter.default.post(name: adminDashboardStopSpinnerNotify, object: nil)
                                }
                                mediumImpactGenerator.impactOccurred()
                                DispatchQueue.main.async {
                                    Utilities.showError2("Youtube url parsing error", actionText: "OK")
                                    alertC.dismiss(animated: true, completion: nil)
                                }
                            }
                            YoutubeRequest.shared.getVideos(playlistId: videoId, url: url, tdAppId: strongSelf.currentVideo.toneDeafAppId, completion: { result in
                                switch result {
                                case.success(let video):
                                    video.dateIA = currdate
                                    video.timeIA = currtime
                                    var ytContentKey:String!
                                    switch strongSelf.currentVideo.type {
                                    case "Music Video":
                                        ytContentKey = youtubeVideoContentTyp
                                    case "Audio Video":
                                        ytContentKey = youtubeAudioVideoContentType
                                    case "Playlist":
                                        ytContentKey = youtubePlaylistContentType
                                    default:
                                        ytContentKey = youtubeAltVideoContentType
                                    }
                                    video.type = ytContentKey
                                    
                                    if strongSelf.currentVideo.youtube == nil {
                                        strongSelf.currentVideo.youtube = []
                                    }
                                    if !strongSelf.currentVideo.youtube!.contains(video) {
                                        strongSelf.currentVideo.youtube!.append(video)
                                    }
                                    DispatchQueue.main.async {
                                        NotificationCenter.default.post(name: adminDashboardStopSpinnerNotify, object: nil)
                                    }
                                    DispatchQueue.main.async {
                                        strongSelf.youtubeTableView.reloadData()
                                        if strongSelf.currentVideo.youtube!.count < 6 {
                                            strongSelf.youtubeHeightConstraint.constant = CGFloat(70*(strongSelf.currentVideo.youtube!.count))
                                        } else {
                                            strongSelf.youtubeHeightConstraint.constant = CGFloat(370)
                                        }
                                        alertC.dismiss(animated: true, completion: nil)
                                    }
                                case .failure(let error):
                                    DispatchQueue.main.async {
                                        NotificationCenter.default.post(name: adminDashboardStopSpinnerNotify, object: nil)
                                    }
                                    DispatchQueue.main.async {
                                        Utilities.showError2("Youtube url parsing error 2 \(error)", actionText: "OK")
                                        alertC.dismiss(animated: true, completion: nil)
                                    }
                                }
                            })
                        }
                    }
                    DispatchQueue.main.async {
                        alertC.dismiss(animated: true, completion: nil)
                    }
                })
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
    
    @IBAction func addIGTVURLTapped(_ sender: Any) {
        let alertC = UIAlertController(title: "Add IGTV URL",
                                                message: "Please type in a IGTV URL.",
                                                preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Add", style: .default, handler: {[weak self] _ in
            guard let strongSelf = self else {return}
            let field = alertC.textFields![0]
            if field.text != nil, field.text != "" {
                var url = field.text!
                    DispatchQueue.main.async {
                        NotificationCenter.default.post(name: adminDashboardStartSpinnerNotify, object: nil)
                    }
                GlobalFunctions.shared.verifyUrl(urlString: url, completion: {validity in
                    if !validity {
                        DispatchQueue.main.async {
                            NotificationCenter.default.post(name: adminDashboardStopSpinnerNotify, object: nil)
                        }
                        mediumImpactGenerator.impactOccurred()
                        DispatchQueue.main.async {
                            Utilities.showError2("IGTV url invalid.", actionText: "OK")
                            alertC.dismiss(animated: true, completion: nil)
                        }
                    } else {
                        let video = IGTVData(url: url, dateIA: "", timeIa: "", isActive: false)
                        if strongSelf.currentVideo.igtv == nil {
                            strongSelf.currentVideo.igtv = []
                        }
                        if !strongSelf.currentVideo.igtv!.contains(video) {
                            strongSelf.currentVideo.igtv!.append(video)
                        }
                        DispatchQueue.main.async {
                            NotificationCenter.default.post(name: adminDashboardStopSpinnerNotify, object: nil)
                        }
                        DispatchQueue.main.async {
                            strongSelf.iGTVTableView.reloadData()
                            if strongSelf.currentVideo.igtv!.count < 6 {
                                strongSelf.iGTVHeightConstraint.constant = CGFloat(70*(strongSelf.currentVideo.igtv!.count))
                            } else {
                                strongSelf.iGTVHeightConstraint.constant = CGFloat(370)
                            }
                            alertC.dismiss(animated: true, completion: nil)
                        }
                    }
                    DispatchQueue.main.async {
                        alertC.dismiss(animated: true, completion: nil)
                    }
                })
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
    
    @IBAction func addInstagramURLTapped(_ sender: Any) {
        let alertC = UIAlertController(title: "Add Instagram URL",
                                                message: "Please type in a Instagram URL.",
                                                preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Add", style: .default, handler: {[weak self] _ in
            guard let strongSelf = self else {return}
            let field = alertC.textFields![0]
            if field.text != nil, field.text != "" {
                var url = field.text!
                    DispatchQueue.main.async {
                        NotificationCenter.default.post(name: adminDashboardStartSpinnerNotify, object: nil)
                    }
                GlobalFunctions.shared.verifyUrl(urlString: url, completion: {validity in
                    if !validity {
                        DispatchQueue.main.async {
                            NotificationCenter.default.post(name: adminDashboardStopSpinnerNotify, object: nil)
                        }
                        mediumImpactGenerator.impactOccurred()
                        DispatchQueue.main.async {
                            Utilities.showError2("Instagram url invalid.", actionText: "OK")
                            alertC.dismiss(animated: true, completion: nil)
                        }
                    } else {
                        let video = InstagramPostData(url: url, dateIA: "", timeIa: "", isActive: false)
                        if strongSelf.currentVideo.instagramPost == nil {
                            strongSelf.currentVideo.instagramPost = []
                        }
                        if !strongSelf.currentVideo.instagramPost!.contains(video) {
                            strongSelf.currentVideo.instagramPost!.append(video)
                        }
                        DispatchQueue.main.async {
                            NotificationCenter.default.post(name: adminDashboardStopSpinnerNotify, object: nil)
                        }
                        DispatchQueue.main.async {
                            strongSelf.instagramTableView.reloadData()
                            if strongSelf.currentVideo.instagramPost!.count < 6 {
                                strongSelf.instagramHeightConstraint.constant = CGFloat(70*(strongSelf.currentVideo.instagramPost!.count))
                            } else {
                                strongSelf.instagramHeightConstraint.constant = CGFloat(370)
                            }
                            alertC.dismiss(animated: true, completion: nil)
                        }
                    }
                    DispatchQueue.main.async {
                        alertC.dismiss(animated: true, completion: nil)
                    }
                })
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
    
    @IBAction func addFacebookURLTapped(_ sender: Any) {
        let alertC = UIAlertController(title: "Add Facebook URL",
                                                message: "Please type in a Facebook URL.",
                                                preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Add", style: .default, handler: {[weak self] _ in
            guard let strongSelf = self else {return}
            let field = alertC.textFields![0]
            if field.text != nil, field.text != "" {
                var url = field.text!
                    DispatchQueue.main.async {
                        NotificationCenter.default.post(name: adminDashboardStartSpinnerNotify, object: nil)
                    }
                GlobalFunctions.shared.verifyUrl(urlString: url, completion: {validity in
                    if !validity {
                        DispatchQueue.main.async {
                            NotificationCenter.default.post(name: adminDashboardStopSpinnerNotify, object: nil)
                        }
                        mediumImpactGenerator.impactOccurred()
                        DispatchQueue.main.async {
                            Utilities.showError2("Facebook url invalid.", actionText: "OK")
                            alertC.dismiss(animated: true, completion: nil)
                        }
                    } else {
                        let video = FacebookPostData(url: url, dateIA: "", timeIa: "", isActive: false)
                        if strongSelf.currentVideo.facebookPost == nil {
                            strongSelf.currentVideo.facebookPost = []
                        }
                        if !strongSelf.currentVideo.facebookPost!.contains(video) {
                            strongSelf.currentVideo.facebookPost!.append(video)
                        }
                        DispatchQueue.main.async {
                            NotificationCenter.default.post(name: adminDashboardStopSpinnerNotify, object: nil)
                        }
                        DispatchQueue.main.async {
                            strongSelf.facebookTableView.reloadData()
                            if strongSelf.currentVideo.facebookPost!.count < 6 {
                                strongSelf.facebookHeightConstraint.constant = CGFloat(70*(strongSelf.currentVideo.facebookPost!.count))
                            } else {
                                strongSelf.facebookHeightConstraint.constant = CGFloat(370)
                            }
                            alertC.dismiss(animated: true, completion: nil)
                        }
                    }
                    DispatchQueue.main.async {
                        alertC.dismiss(animated: true, completion: nil)
                    }
                })
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
    
    @IBAction func addWorldstarURLTapped(_ sender: Any) {
        let alertC = UIAlertController(title: "Add Worldstar URL",
                                                message: "Please type in a Worldstar URL.",
                                                preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Add", style: .default, handler: {[weak self] _ in
            guard let strongSelf = self else {return}
            let field = alertC.textFields![0]
            if field.text != nil, field.text != "" {
                var url = field.text!
                    DispatchQueue.main.async {
                        NotificationCenter.default.post(name: adminDashboardStartSpinnerNotify, object: nil)
                    }
                GlobalFunctions.shared.verifyUrl(urlString: url, completion: {validity in
                    if !validity {
                        DispatchQueue.main.async {
                            NotificationCenter.default.post(name: adminDashboardStopSpinnerNotify, object: nil)
                        }
                        mediumImpactGenerator.impactOccurred()
                        DispatchQueue.main.async {
                            Utilities.showError2("Worldstar url invalid.", actionText: "OK")
                            alertC.dismiss(animated: true, completion: nil)
                        }
                    } else {
                        let video = WorldstarData(url: url, dateIA: "", timeIa: "", isActive: false)
                        if strongSelf.currentVideo.worldstar == nil {
                            strongSelf.currentVideo.worldstar = []
                        }
                        if !strongSelf.currentVideo.worldstar!.contains(video) {
                            strongSelf.currentVideo.worldstar!.append(video)
                        }
                        DispatchQueue.main.async {
                            NotificationCenter.default.post(name: adminDashboardStopSpinnerNotify, object: nil)
                        }
                        DispatchQueue.main.async {
                            strongSelf.worldstarTableView.reloadData()
                            if strongSelf.currentVideo.worldstar!.count < 6 {
                                strongSelf.worldstarHeightConstraint.constant = CGFloat(70*(strongSelf.currentVideo.worldstar!.count))
                            } else {
                                strongSelf.worldstarHeightConstraint.constant = CGFloat(370)
                            }
                            alertC.dismiss(animated: true, completion: nil)
                        }
                    }
                    DispatchQueue.main.async {
                        alertC.dismiss(animated: true, completion: nil)
                    }
                })
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
    
    @IBAction func addTwitterURLTapped(_ sender: Any) {
        let alertC = UIAlertController(title: "Add Twitter URL",
                                                message: "Please type in a Twitter URL.",
                                                preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Add", style: .default, handler: {[weak self] _ in
            guard let strongSelf = self else {return}
            let field = alertC.textFields![0]
            if field.text != nil, field.text != "" {
                var url = field.text!
                    DispatchQueue.main.async {
                        NotificationCenter.default.post(name: adminDashboardStartSpinnerNotify, object: nil)
                    }
                GlobalFunctions.shared.verifyUrl(urlString: url, completion: {validity in
                    if !validity {
                        DispatchQueue.main.async {
                            NotificationCenter.default.post(name: adminDashboardStopSpinnerNotify, object: nil)
                        }
                        mediumImpactGenerator.impactOccurred()
                        DispatchQueue.main.async {
                            Utilities.showError2("Twitter url invalid.", actionText: "OK")
                            alertC.dismiss(animated: true, completion: nil)
                        }
                    } else {
                        var videoId = ""
                        if !url.contains("status/") {
                            DispatchQueue.main.async {
                                NotificationCenter.default.post(name: adminDashboardStopSpinnerNotify, object: nil)
                            }
                            DispatchQueue.main.async {
                                Utilities.showError2("Twitter url parsing error", actionText: "OK")
                                alertC.dismiss(animated: true, completion: nil)
                            }
                        }
                        if let range = url.range(of: "status/") {
                            url.removeSubrange(url.startIndex..<range.lowerBound)
                        }
                        let split = String(url.dropFirst(7))
                        videoId = String(split.prefix(19))
                        TwitterRequest.shared.getPost(mediaId: videoId, completion: { result in
                            switch result {
                            case.success(let vide):
                                var video = vide
                                video.url = field.text!
                                if strongSelf.currentVideo.twitter == nil {
                                    strongSelf.currentVideo.twitter = []
                                }
                                if !strongSelf.currentVideo.twitter!.contains(video) {
                                    strongSelf.currentVideo.twitter!.append(video)
                                }
                                DispatchQueue.main.async {
                                    NotificationCenter.default.post(name: adminDashboardStopSpinnerNotify, object: nil)
                                }
                                DispatchQueue.main.async {
                                    strongSelf.twitterTableView.reloadData()
                                    if strongSelf.currentVideo.twitter!.count < 6 {
                                        strongSelf.twitterHeightConstraint.constant = CGFloat(70*(strongSelf.currentVideo.twitter!.count))
                                    } else {
                                        strongSelf.twitterHeightConstraint.constant = CGFloat(370)
                                    }
                                    alertC.dismiss(animated: true, completion: nil)
                                }
                            case .failure(let error):
                                DispatchQueue.main.async {
                                    NotificationCenter.default.post(name: adminDashboardStopSpinnerNotify, object: nil)
                                }
                                DispatchQueue.main.async {
                                    Utilities.showError2("Twitter url parsing error 2 \(error)", actionText: "OK")
                                    alertC.dismiss(animated: true, completion: nil)
                                }
                            }
                        })
                    }
                    DispatchQueue.main.async {
                        alertC.dismiss(animated: true, completion: nil)
                    }
                })
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
    
    @IBAction func addAppleURLTapped(_ sender: Any) {
        let alertC = UIAlertController(title: "Add Apple Music URL",
                                                message: "Please type in a Apple Music URL.",
                                                preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Add", style: .default, handler: {[weak self] _ in
            guard let strongSelf = self else {return}
            let field = alertC.textFields![0]
            if field.text != nil, field.text != "" {
                var url = field.text!
                    DispatchQueue.main.async {
                        NotificationCenter.default.post(name: adminDashboardStartSpinnerNotify, object: nil)
                    }
                GlobalFunctions.shared.verifyUrl(urlString: url, completion: {validity in
                    if !validity {
                        DispatchQueue.main.async {
                            NotificationCenter.default.post(name: adminDashboardStopSpinnerNotify, object: nil)
                        }
                        mediumImpactGenerator.impactOccurred()
                        DispatchQueue.main.async {
                            Utilities.showError2("Apple url invalid.", actionText: "OK")
                            alertC.dismiss(animated: true, completion: nil)
                        }
                    } else {
                        var videoId = ""
                        if !url.contains("music-video/") {
                            DispatchQueue.main.async {
                                NotificationCenter.default.post(name: adminDashboardStopSpinnerNotify, object: nil)
                            }
                            DispatchQueue.main.async {
                                Utilities.showError2("Apple url parsing error", actionText: "OK")
                                alertC.dismiss(animated: true, completion: nil)
                            }
                        }
                        videoId = String(url.suffix(10))
                        AppleMusicRequest.shared.getAppleMusicVideo(id: videoId, completion: { result in
                            switch result {
                            case.success(let video):
                                if strongSelf.currentVideo.appleMusic == nil {
                                    strongSelf.currentVideo.appleMusic = []
                                }
                                if !strongSelf.currentVideo.appleMusic!.contains(video) {
                                    strongSelf.currentVideo.appleMusic!.append(video)
                                }
                                DispatchQueue.main.async {
                                    NotificationCenter.default.post(name: adminDashboardStopSpinnerNotify, object: nil)
                                }
                                DispatchQueue.main.async {
                                    strongSelf.appleMusicTableView.reloadData()
                                    if strongSelf.currentVideo.appleMusic!.count < 6 {
                                        strongSelf.appleMusicHeightConstraint.constant = CGFloat(70*(strongSelf.currentVideo.appleMusic!.count))
                                    } else {
                                        strongSelf.appleMusicHeightConstraint.constant = CGFloat(370)
                                    }
                                    alertC.dismiss(animated: true, completion: nil)
                                }
                            case .failure(let error):
                                DispatchQueue.main.async {
                                    NotificationCenter.default.post(name: adminDashboardStopSpinnerNotify, object: nil)
                                }
                                DispatchQueue.main.async {
                                    Utilities.showError2("Apple url parsing error 2 \(error)", actionText: "OK")
                                    alertC.dismiss(animated: true, completion: nil)
                                }
                            }
                        })
                    }
                    DispatchQueue.main.async {
                        alertC.dismiss(animated: true, completion: nil)
                    }
                })
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
    
    @IBAction func addTikTokURLTapped(_ sender: Any) {
        let alertC = UIAlertController(title: "Add Tik Tok URL",
                                                message: "Please type in a Tik Tok URL.",
                                                preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Add", style: .default, handler: {[weak self] _ in
            guard let strongSelf = self else {return}
            let field = alertC.textFields![0]
            if field.text != nil, field.text != "" {
                var url = field.text!
                    DispatchQueue.main.async {
                        NotificationCenter.default.post(name: adminDashboardStartSpinnerNotify, object: nil)
                    }
                GlobalFunctions.shared.verifyUrl(urlString: url, completion: {validity in
                    if !validity {
                        DispatchQueue.main.async {
                            NotificationCenter.default.post(name: adminDashboardStopSpinnerNotify, object: nil)
                        }
                        mediumImpactGenerator.impactOccurred()
                        DispatchQueue.main.async {
                            Utilities.showError2("Tik Tok url invalid.", actionText: "OK")
                            alertC.dismiss(animated: true, completion: nil)
                        }
                    } else {
                        let video = TikTokData(url: url, dateIA: "", timeIa: "", isActive: false)
                        if strongSelf.currentVideo.tikTok == nil {
                            strongSelf.currentVideo.tikTok = []
                        }
                        if !strongSelf.currentVideo.tikTok!.contains(video) {
                            strongSelf.currentVideo.tikTok!.append(video)
                        }
                        DispatchQueue.main.async {
                            NotificationCenter.default.post(name: adminDashboardStopSpinnerNotify, object: nil)
                        }
                        DispatchQueue.main.async {
                            strongSelf.tikTokTableView.reloadData()
                            if strongSelf.currentVideo.tikTok!.count < 6 {
                                strongSelf.tikTokHeightConstraint.constant = CGFloat(70*(strongSelf.currentVideo.tikTok!.count))
                            } else {
                                strongSelf.tikTokHeightConstraint.constant = CGFloat(370)
                            }
                            alertC.dismiss(animated: true, completion: nil)
                        }
                    }
                    DispatchQueue.main.async {
                        alertC.dismiss(animated: true, completion: nil)
                    }
                })
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
    
    @IBAction func addSongTapped(_ sender: Any) {
        arr = "song"
        prevPage = "editVideo"
        performSegue(withIdentifier: "editVideoToTonesPick", sender: nil)
    }
    
    func songAdded(_ songAndData: [String?:SongData]) {
        lightImpactGenerator.impactOccurred(intensity: 0.75)
        let select = songAndData[Array(songAndData.keys)[0]]!
        let data = Array(songAndData.keys)[0]
        
        switch data {
        case "Official Video":
            select.officialVideo = currentVideo.toneDeafAppId
        case "Audio Video":
            select.audioVideo = currentVideo.toneDeafAppId
        case "Lyric Video":
            select.lyricVideo = currentVideo.toneDeafAppId
        default:
            break
        }
        
        if !songsArr.contains(select) {
            songsArr.append(select)
        } else {
            let dex = songsArr.firstIndex(of: select)
            songsArr[dex!] = select
        }
        
        if currentVideo.songs == nil {
            currentVideo.songs = ["\(select.toneDeafAppId)"]
        } else {
            if var arr = currentVideo.songs {
                if !arr.contains(select.toneDeafAppId) {
                    arr.append("\(select.toneDeafAppId)")
                    arr.sort()
                    currentVideo.songs = arr
                }
            } else {
                var arr:[String] = []
                arr.append("\(select.toneDeafAppId)")
                arr.sort()
                currentVideo.songs = arr
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
    
    //MARK: - Status Control
    
    @IBAction func changeVerificationLevelTapped(_ sender: Any) {
        let alertC = UIAlertController(title: "Change Verification Level",
                                                message: "Select a Level.",
                                                preferredStyle: .alert)
        let aAction = UIAlertAction(title: "A Level", style: .default, handler: {[weak self] _ in
            guard let strongSelf = self else {return}
            strongSelf.currentVideo.verificationLevel = "A"
            strongSelf.verificationLabel.text = String(strongSelf.currentVideo.verificationLevel!)
            strongSelf.verificationLabel.textColor = .green
                alertC.dismiss(animated: true, completion: nil)
        })
        let bAction = UIAlertAction(title: "B Level", style: .default, handler: {[weak self] _ in
            guard let strongSelf = self else {return}
            strongSelf.currentVideo.verificationLevel = "B"
            strongSelf.verificationLabel.text = String(strongSelf.currentVideo.verificationLevel!)
            strongSelf.verificationLabel.textColor = .green
                alertC.dismiss(animated: true, completion: nil)
        })
        let cAction = UIAlertAction(title: "C Level", style: .default, handler: {[weak self] _ in
            guard let strongSelf = self else {return}
            strongSelf.currentVideo.verificationLevel = "C"
            strongSelf.verificationLabel.text = String(strongSelf.currentVideo.verificationLevel!)
            strongSelf.verificationLabel.textColor = .green
                alertC.dismiss(animated: true, completion: nil)
        })
        let uAction = UIAlertAction(title: "U Level", style: .default, handler: {[weak self] _ in
            guard let strongSelf = self else {return}
            strongSelf.currentVideo.verificationLevel = "U"
            strongSelf.verificationLabel.text = String(strongSelf.currentVideo.verificationLevel!)
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
        lightImpactGenerator.impactOccurred(intensity: 0.75)
        if industryCertifiedControl.selectedSegmentIndex == 0 {
            industryCertifiedControl.selectedSegmentTintColor = .systemGreen
            currentVideo.industryCerified = true
        } else {
            industryCertifiedControl.selectedSegmentTintColor = Constants.Colors.redApp
            currentVideo.industryCerified = false
        }
    }
    
    @IBAction func statusChanged(_ sender: Any) {
        lightImpactGenerator.impactOccurred(intensity: 0.75)
        if statusControl.selectedSegmentIndex == 0 {
            statusControl.selectedSegmentTintColor = .systemGreen
            currentVideo.isActive = true
        } else {
            statusControl.selectedSegmentTintColor = Constants.Colors.redApp
            currentVideo.isActive = false
        }
    }
    
    //MARK: - Update Tapped
    @IBAction func updateVideoTapped(_ sender: Any) {
        newDictYoutube = nil
        if currentVideo.youtube != nil {
            newDictYoutube = []
            for item in currentVideo.youtube! {
                newDictYoutube!.append(item.copy() as! YouTubeData)
            }
        }
        newDictIGTV = nil
        if currentVideo.igtv != nil {
            newDictIGTV = []
            for item in currentVideo.igtv! {
                newDictIGTV!.append(item.copy() as! IGTVData)
            }
        }
        newDictInstagram = nil
        if currentVideo.instagramPost != nil {
            newDictInstagram = []
            for item in currentVideo.instagramPost! {
                newDictInstagram!.append(item.copy() as! InstagramPostData)
            }
        }
        newDictFacebook = nil
        if currentVideo.facebookPost != nil {
            newDictFacebook = []
            for item in currentVideo.facebookPost! {
                newDictFacebook!.append(item.copy() as! FacebookPostData)
            }
        }
        newDictWorldstar = nil
        if currentVideo.worldstar != nil {
            newDictWorldstar = []
            for item in currentVideo.worldstar! {
                newDictWorldstar!.append(item.copy() as! WorldstarData)
            }
        }
        newDictTwitter = nil
        if currentVideo.twitter != nil {
            newDictTwitter = []
            for item in currentVideo.twitter! {
                newDictTwitter!.append(item.copy() as! TwitterTweetData)
            }
        }
        newDictApple = nil
        if currentVideo.appleMusic != nil {
            newDictApple = []
            for item in currentVideo.appleMusic! {
                newDictApple!.append(item.copy() as! AppleVideoData)
            }
        }
        newDictTikTok = nil
        if currentVideo.tikTok != nil {
            newDictTikTok = []
            for item in currentVideo.tikTok! {
                newDictTikTok!.append(item.copy() as! TikTokData)
            }
        }
        
        
//        print(String(data: try! JSONSerialization.data(withJSONObject: urlDict, options: .prettyPrinted), encoding: .utf8)!)
//        print(String(data: try! JSONSerialization.data(withJSONObject: newURLDict, options: .prettyPrinted), encoding: .utf8)!)
        print(currentVideo == initialVideo, itemDictYoutube == newDictYoutube, itemDictIGTV == newDictIGTV, itemDictInstagram == newDictInstagram, itemDictFacebook == newDictFacebook, itemDictWorldstar == newDictWorldstar, itemDictTwitter == newDictTwitter, itemDictApple == newDictApple, itemDictTikTok == newDictTikTok)
//        print(currentVideo == initialVideo)
        
        //MARK: - Error Count
        errorCountForController = 0
//        if mainArtistsArr.isEmpty {
//            errorCountForController+=1
//        }
        
        guard errorCountForController == 0 else {
            mediumImpactGenerator.impactOccurred()
            Utilities.showError2("Please correct all errors before proceeding.", actionText: "OK")
            return
        }
        
        if currentVideo == initialVideo && newDictYoutube == itemDictYoutube && itemDictIGTV == newDictIGTV && itemDictInstagram == newDictInstagram && itemDictFacebook == newDictFacebook && itemDictWorldstar == newDictWorldstar && itemDictTwitter == newDictTwitter && itemDictApple == newDictApple && itemDictTikTok == newDictTikTok {
            mediumImpactGenerator.impactOccurred()
            Utilities.showError2("Video already up to date.", actionText: "OK")
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
            strongSelf.startUpdate()
        })
    }
    
    func startUpdate() {
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
                strongSelf.proceedUpdate()
            }
        })
    }
    
    func proceedUpdate() {
        
        let queue = DispatchQueue(label: "myhjvkheditingQvideosssseue")
        let group = DispatchGroup()
        let array = [2,3,4,5,10,11,12,13,14,15,16,17,25,26,27]
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
                    strongSelf.processType(completion: {err in
                        if let error = err {
                            mediumImpactGenerator.impactOccurred()
                            DispatchQueue.main.async {
                                Utilities.showError2("Type Proccessing Failed: \(error)", actionText: "OK")
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
                    strongSelf.processPersons(completion: {err in
                        if let error = err {
                            mediumImpactGenerator.impactOccurred()
                            DispatchQueue.main.async {
                                Utilities.showError2("Person Proccessing Failed: \(error)", actionText: "OK")
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
                    strongSelf.processVideographers(completion: {err in
                        if let error = err {
                            mediumImpactGenerator.impactOccurred()
                            DispatchQueue.main.async {
                                Utilities.showError2("Videographer Proccessing Failed: \(error)", actionText: "OK")
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
                case 10:
                    strongSelf.processYoutube(completion: {err in
                        if let errors = err {
                            mediumImpactGenerator.impactOccurred()
                            for error in errors {
                                DispatchQueue.main.async {
                                    Utilities.showError2("Youtube Proccessing Failed: \(error)", actionText: "OK")
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
                    strongSelf.processIGTV(completion: {err in
                        if let errors = err {
                            mediumImpactGenerator.impactOccurred()
                            for error in errors {
                                DispatchQueue.main.async {
                                    Utilities.showError2("IGTV Proccessing Failed: \(error)", actionText: "OK")
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
                    strongSelf.processInstagram(completion: {err in
                        if let errors = err {
                            mediumImpactGenerator.impactOccurred()
                            for error in errors {
                                DispatchQueue.main.async {
                                    Utilities.showError2("Instagram Proccessing Failed: \(error)", actionText: "OK")
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
                    strongSelf.processFacebook(completion: {err in
                        if let errors = err {
                            mediumImpactGenerator.impactOccurred()
                            for error in errors {
                                DispatchQueue.main.async {
                                    Utilities.showError2("Facebook Proccessing Failed: \(error)", actionText: "OK")
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
                    strongSelf.processWorldstar(completion: {err in
                        if let errors = err {
                            mediumImpactGenerator.impactOccurred()
                            for error in errors {
                                DispatchQueue.main.async {
                                    Utilities.showError2("Worldstar Proccessing Failed: \(error)", actionText: "OK")
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
                    strongSelf.processTwitter(completion: {err in
                        if let errors = err {
                            mediumImpactGenerator.impactOccurred()
                            for error in errors {
                                DispatchQueue.main.async {
                                    Utilities.showError2("Twitter Proccessing Failed: \(error)", actionText: "OK")
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
                    strongSelf.processApple(completion: {err in
                        if let errors = err {
                            mediumImpactGenerator.impactOccurred()
                            for error in errors {
                                DispatchQueue.main.async {
                                    Utilities.showError2("Apple Proccessing Failed: \(error)", actionText: "OK")
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
                    strongSelf.processTikTok(completion: {err in
                        if let errors = err {
                            mediumImpactGenerator.impactOccurred()
                            for error in errors {
                                DispatchQueue.main.async {
                                    Utilities.showError2("Tik Tok Proccessing Failed: \(error)", actionText: "OK")
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
//                case 11:
//                    strongSelf.processAmazonURL(dict: dict, urldict: urldict, completion: {err in
//                        if let errors = err {
//                            mediumImpactGenerator.impactOccurred()
//                            for error in errors {
//                                DispatchQueue.main.async {
//                                    Utilities.showError2("Amazon Proccessing Failed: \(error)", actionText: "OK")
//                                }
//                            }
//                            strongSelf.uploadCompletionStatus11 = false
//                        } else {
//                            strongSelf.progressCompleted+=1
//                            DispatchQueue.main.async {
//                                strongSelf.progressView.progress = (strongSelf.progressCompleted/strongSelf.totalProgress)
//                                print("\(strongSelf.progressCompleted) out of \(strongSelf.totalProgress)")
//                            }
//                            strongSelf.uploadCompletionStatus11 = true
//                            print("done \(i)")
//                        }
//                        group.leave()
//                    })
//                case 12:
//                    strongSelf.processDeezerURL(dict: dict, urldict: urldict, completion: {err in
//                        if let errors = err {
//                            mediumImpactGenerator.impactOccurred()
//                            for error in errors {
//                                DispatchQueue.main.async {
//                                    Utilities.showError2("Deezer Proccessing Failed: \(error)", actionText: "OK")
//                                }
//                            }
//                            strongSelf.uploadCompletionStatus12 = false
//                        } else {
//                            strongSelf.progressCompleted+=1
//                            DispatchQueue.main.async {
//                                strongSelf.progressView.progress = (strongSelf.progressCompleted/strongSelf.totalProgress)
//                                print("\(strongSelf.progressCompleted) out of \(strongSelf.totalProgress)")
//                            }
//                            strongSelf.uploadCompletionStatus12 = true
//                            print("done \(i)")
//                        }
//                        group.leave()
//                    })
//                case 13:
//                    strongSelf.processTidalURL(dict: dict, urldict: urldict, completion: {err in
//                        if let errors = err {
//                            mediumImpactGenerator.impactOccurred()
//                            for error in errors {
//                                DispatchQueue.main.async {
//                                    Utilities.showError2("Tidal Proccessing Failed: \(error)", actionText: "OK")
//                                }
//                            }
//                            strongSelf.uploadCompletionStatus13 = false
//                        } else {
//                            strongSelf.progressCompleted+=1
//                            DispatchQueue.main.async {
//                                strongSelf.progressView.progress = (strongSelf.progressCompleted/strongSelf.totalProgress)
//                                print("\(strongSelf.progressCompleted) out of \(strongSelf.totalProgress)")
//                            }
//                            strongSelf.uploadCompletionStatus13 = true
//                            print("done \(i)")
//                        }
//                        group.leave()
//                    })
//                case 14:
//                    strongSelf.processNapsterURL(dict: dict, urldict: urldict, completion: {err in
//                        if let errors = err {
//                            mediumImpactGenerator.impactOccurred()
//                            for error in errors {
//                                DispatchQueue.main.async {
//                                    Utilities.showError2("Napster Proccessing Failed: \(error)", actionText: "OK")
//                                }
//                            }
//                            strongSelf.uploadCompletionStatus14 = false
//                        } else {
//                            strongSelf.progressCompleted+=1
//                            DispatchQueue.main.async {
//                                strongSelf.progressView.progress = (strongSelf.progressCompleted/strongSelf.totalProgress)
//                                print("\(strongSelf.progressCompleted) out of \(strongSelf.totalProgress)")
//                            }
//                            strongSelf.uploadCompletionStatus14 = true
//                            print("done \(i)")
//                        }
//                        group.leave()
//                    })
//                case 15:
//                    strongSelf.processSpinrillaURL(dict: dict, urldict: urldict, completion: {err in
//                        if let errors = err {
//                            mediumImpactGenerator.impactOccurred()
//                            for error in errors {
//                                DispatchQueue.main.async {
//                                    Utilities.showError2("Spinrilla Proccessing Failed: \(error)", actionText: "OK")
//                                }
//                            }
//                            strongSelf.uploadCompletionStatus15 = false
//                        } else {
//                            strongSelf.progressCompleted+=1
//                            DispatchQueue.main.async {
//                                strongSelf.progressView.progress = (strongSelf.progressCompleted/strongSelf.totalProgress)
//                                print("\(strongSelf.progressCompleted) out of \(strongSelf.totalProgress)")
//                            }
//                            strongSelf.uploadCompletionStatus15 = true
//                            print("done \(i)")
//                        }
//                        group.leave()
//                    })
//                case 16:
//                    strongSelf.processMixEngineers(completion: {err in
//                        if let error = err {
//                            mediumImpactGenerator.impactOccurred()
//                            DispatchQueue.main.async {
//                                Utilities.showError2("Mix Engineer Proccessing Failed: \(error)", actionText: "OK")
//                            }
//                            strongSelf.uploadCompletionStatus16 = false
//                        } else {
//                            strongSelf.progressCompleted+=1
//                            DispatchQueue.main.async {
//                                strongSelf.progressView.progress = (strongSelf.progressCompleted/strongSelf.totalProgress)
//                                print("\(strongSelf.progressCompleted) out of \(strongSelf.totalProgress)")
//                            }
//                            strongSelf.uploadCompletionStatus16 = true
//                            print("done \(i)")
//                        }
//                        group.leave()
//                    })
//                case 17:
//                    strongSelf.processMasteringEngineers(completion: {err in
//                        if let error = err {
//                            mediumImpactGenerator.impactOccurred()
//                            DispatchQueue.main.async {
//                                Utilities.showError2("Mastering Engineer Proccessing Failed: \(error)", actionText: "OK")
//                            }
//                            strongSelf.uploadCompletionStatus17 = false
//                        } else {
//                            strongSelf.progressCompleted+=1
//                            DispatchQueue.main.async {
//                                strongSelf.progressView.progress = (strongSelf.progressCompleted/strongSelf.totalProgress)
//                                print("\(strongSelf.progressCompleted) out of \(strongSelf.totalProgress)")
//                            }
//                            strongSelf.uploadCompletionStatus17 = true
//                            print("done \(i)")
//                        }
//                        group.leave()
//                    })
//                case 18:
//                    strongSelf.processRecordingEngineers(completion: {err in
//                        if let error = err {
//                            mediumImpactGenerator.impactOccurred()
//                            DispatchQueue.main.async {
//                                Utilities.showError2("Recording Engineer Proccessing Failed: \(error)", actionText: "OK")
//                            }
//                            strongSelf.uploadCompletionStatus18 = false
//                        } else {
//                            strongSelf.progressCompleted+=1
//                            DispatchQueue.main.async {
//                                strongSelf.progressView.progress = (strongSelf.progressCompleted/strongSelf.totalProgress)
//                                print("\(strongSelf.progressCompleted) out of \(strongSelf.totalProgress)")
//                            }
//                            strongSelf.uploadCompletionStatus18 = true
//                            print("done \(i)")
//                        }
//                        group.leave()
//                    })
//                case 19:
//                    strongSelf.processAllArtists(completion: {err in
//                        if let error = err {
//                            mediumImpactGenerator.impactOccurred()
//                            DispatchQueue.main.async {
//                                Utilities.showError2("All Artist Proccessing Failed: \(error)", actionText: "OK")
//                            }
//                            strongSelf.uploadCompletionStatus19 = false
//                        } else {
//                            strongSelf.progressCompleted+=1
//                            DispatchQueue.main.async {
//                                strongSelf.progressView.progress = (strongSelf.progressCompleted/strongSelf.totalProgress)
//                                print("\(strongSelf.progressCompleted) out of \(strongSelf.totalProgress)")
//                            }
//                            strongSelf.uploadCompletionStatus19 = true
//                            print("done \(i)")
//                        }
//                        group.leave()
//                    })
//                case 20:
//                    strongSelf.uploadCompletionStatus20 = false
//                    strongSelf.processTracks(completion: {err in
//                        if let errors = err {
//                            mediumImpactGenerator.impactOccurred()
//                            for error in errors {
//                                DispatchQueue.main.async {
//                                    Utilities.showError2("Tracks Proccessing Failed: \(error)", actionText: "OK")
//                                }
//                            }
//                            strongSelf.uploadCompletionStatus20 = false
//                        } else {
//                            strongSelf.progressCompleted+=1
//                            DispatchQueue.main.async {
//                                strongSelf.progressView.progress = (strongSelf.progressCompleted/strongSelf.totalProgress)
//                                print("\(strongSelf.progressCompleted) out of \(strongSelf.totalProgress)")
//                            }
//                            strongSelf.uploadCompletionStatus20 = true
//                            print("done \(i)")
//                        }
//                        group.leave()
//                    })
//                case 21:
//                    strongSelf.uploadCompletionStatus21 = false
//                    strongSelf.processSongs(completion: {err in
//                        if let errors = err {
//                            mediumImpactGenerator.impactOccurred()
//                            for error in errors {
//                                DispatchQueue.main.async {
//                                    Utilities.showError2("Songs Proccessing Failed: \(error)", actionText: "OK")
//                                }
//                            }
//                            strongSelf.uploadCompletionStatus21 = false
//                        } else {
//                            strongSelf.progressCompleted+=1
//                            DispatchQueue.main.async {
//                                strongSelf.progressView.progress = (strongSelf.progressCompleted/strongSelf.totalProgress)
//                                print("\(strongSelf.progressCompleted) out of \(strongSelf.totalProgress)")
//                            }
//                            strongSelf.uploadCompletionStatus21 = true
//                            print("done \(i)")
//                        }
//                        group.leave()
//                    })
//                case 22:
//                    strongSelf.uploadCompletionStatus22 = false
//                    strongSelf.processVideos(completion: {err in
//                        if let errors = err {
//                            mediumImpactGenerator.impactOccurred()
//                            for error in errors {
//                                DispatchQueue.main.async {
//                                    Utilities.showError2("Videos Proccessing Failed: \(error)", actionText: "OK")
//                                }
//                            }
//                            strongSelf.uploadCompletionStatus22 = false
//                        } else {
//                            strongSelf.progressCompleted+=1
//                            DispatchQueue.main.async {
//                                strongSelf.progressView.progress = (strongSelf.progressCompleted/strongSelf.totalProgress)
//                                print("\(strongSelf.progressCompleted) out of \(strongSelf.totalProgress)")
//                            }
//                            strongSelf.uploadCompletionStatus22 = true
//                            print("done \(i)")
//                        }
//                        group.leave()
//                    })
//                case 23:
//                    strongSelf.uploadCompletionStatus23 = false
//                    strongSelf.processInstrumentals(completion: {err in
//                        if let errors = err {
//                            mediumImpactGenerator.impactOccurred()
//                            for error in errors {
//                                DispatchQueue.main.async {
//                                    Utilities.showError2("Instrumentals Proccessing Failed: \(error)", actionText: "OK")
//                                }
//                            }
//                            strongSelf.uploadCompletionStatus23 = false
//                        } else {
//                            strongSelf.progressCompleted+=1
//                            DispatchQueue.main.async {
//                                strongSelf.progressView.progress = (strongSelf.progressCompleted/strongSelf.totalProgress)
//                                print("\(strongSelf.progressCompleted) out of \(strongSelf.totalProgress)")
//                            }
//                            strongSelf.uploadCompletionStatus23 = true
//                            print("done \(i)")
//                        }
//                        group.leave()
//                    })
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
//                case 28:
//                    strongSelf.processIsDeluxes(completion: {err in
//                        if let error = err {
//                            mediumImpactGenerator.impactOccurred()
//                            DispatchQueue.main.async {
//                                Utilities.showError2("Is Deluxe Proccessing Failed: \(error)", actionText: "OK")
//                            }
//                            strongSelf.uploadCompletionStatus28 = false
//                        } else {
//                            strongSelf.progressCompleted+=1
//                            DispatchQueue.main.async {
//                                strongSelf.progressView.progress = (strongSelf.progressCompleted/strongSelf.totalProgress)
//                                print("\(strongSelf.progressCompleted) out of \(strongSelf.totalProgress)")
//                            }
//                            strongSelf.uploadCompletionStatus28 = true
//                            print("done \(i)")
//                        }
//                        group.leave()
//                    })
//                case 29:
//                    strongSelf.processIsOtherVersions(completion: {err in
//                        if let error = err {
//                            mediumImpactGenerator.impactOccurred()
//                            DispatchQueue.main.async {
//                                Utilities.showError2("Is Other Versions Proccessing Failed: \(error)", actionText: "OK")
//                            }
//                            strongSelf.uploadCompletionStatus29 = false
//                        } else {
//                            strongSelf.progressCompleted+=1
//                            DispatchQueue.main.async {
//                                strongSelf.progressView.progress = (strongSelf.progressCompleted/strongSelf.totalProgress)
//                                print("\(strongSelf.progressCompleted) out of \(strongSelf.totalProgress)")
//                            }
//                            strongSelf.uploadCompletionStatus29 = true
//                            print("done \(i)")
//                        }
//                        group.leave()
//                    })
//                case 30:
//                    strongSelf.processDeluxe(completion: {err in
//                        if let error = err {
//                            mediumImpactGenerator.impactOccurred()
//                            DispatchQueue.main.async {
//                                Utilities.showError2("Deluxe Proccessing Failed: \(error)", actionText: "OK")
//                            }
//                            strongSelf.uploadCompletionStatus30 = false
//                        } else {
//                            strongSelf.progressCompleted+=1
//                            DispatchQueue.main.async {
//                                strongSelf.progressView.progress = (strongSelf.progressCompleted/strongSelf.totalProgress)
//                                print("\(strongSelf.progressCompleted) out of \(strongSelf.totalProgress)")
//                            }
//                            strongSelf.uploadCompletionStatus30 = true
//                            print("done \(i)")
//                        }
//                        group.leave()
//                    })
//                case 31:
//                    strongSelf.processOtherVersions(completion: {err in
//                        if let error = err {
//                            mediumImpactGenerator.impactOccurred()
//                            DispatchQueue.main.async {
//                                Utilities.showError2("Other Versions Proccessing Failed: \(error)", actionText: "OK")
//                            }
//                            strongSelf.uploadCompletionStatus31 = false
//                        } else {
//                            strongSelf.progressCompleted+=1
//                            DispatchQueue.main.async {
//                                strongSelf.progressView.progress = (strongSelf.progressCompleted/strongSelf.totalProgress)
//                                print("\(strongSelf.progressCompleted) out of \(strongSelf.totalProgress)")
//                            }
//                            strongSelf.uploadCompletionStatus31 = true
//                            print("done \(i)")
//                        }
//                        group.leave()
//                    })
                default:
                    print("Edit Song error")
                }
            }
        }
        
        group.notify(queue: DispatchQueue.main) { [weak self] in
            guard let strongSelf = self else {return}
            if strongSelf.uploadCompletionStatus1 == false || strongSelf.uploadCompletionStatus2 == false || strongSelf.uploadCompletionStatus3 == false || strongSelf.uploadCompletionStatus4 == false || strongSelf.uploadCompletionStatus5 == false || strongSelf.uploadCompletionStatus6 == false || strongSelf.uploadCompletionStatus7 == false || strongSelf.uploadCompletionStatus8 == false || strongSelf.uploadCompletionStatus9 == false || strongSelf.uploadCompletionStatus10 == false || strongSelf.uploadCompletionStatus11 == false || strongSelf.uploadCompletionStatus12 == false || strongSelf.uploadCompletionStatus13 == false || strongSelf.uploadCompletionStatus14 == false || strongSelf.uploadCompletionStatus15 == false || strongSelf.uploadCompletionStatus16 == false || strongSelf.uploadCompletionStatus17 == false || strongSelf.uploadCompletionStatus18 == false || strongSelf.uploadCompletionStatus19 == false || strongSelf.uploadCompletionStatus20 == false || strongSelf.uploadCompletionStatus21 == false || strongSelf.uploadCompletionStatus22 == false || strongSelf.uploadCompletionStatus23 == false || strongSelf.uploadCompletionStatus24 == false || strongSelf.uploadCompletionStatus25 == false || strongSelf.uploadCompletionStatus26 == false || strongSelf.uploadCompletionStatus27 == false || strongSelf.uploadCompletionStatus28 == false || strongSelf.uploadCompletionStatus29 == false {
                strongSelf.alertView.dismiss(animated: true, completion: nil)
                
//                EditVideoHelper.shared.cancelUpdate(initialVideo: strongSelf.initialVideo,currentVideo: strongSelf.currentVideo, initialStatus: strongSelf.boolDict as NSDictionary, currentStatus: dict, initialURL: strongSelf.urlDict as NSDictionary, currentURL: urldict , completion: { err in
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
        guard currentVideo.manualThumbnailURL != initialVideo.manualThumbnailURL else {
            completion(nil)
            return
        }
        if currentVideo.manualThumbnailURL != nil && currentVideo.manualThumbnailURL != "" {
            guard newImage != nil else {
                completion(SongEditorError.imageUpdateError("Image must not be empty"))
                return
            }
        }
        EditVideoHelper.shared.processImage(initialVideo: initialVideo, currentVideo: currentVideo, image: newImage, completion: {[weak self] err in
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
        guard currentVideo.title != initialVideo.title else {
            completion(nil)
            return
        }
        EditVideoHelper.shared.processName(initialVideo: initialVideo,currentVideo: currentVideo, completion: {[weak self] err in
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
    
    func processType(completion: @escaping ((Error?) -> Void)) {
        guard currentVideo.type != initialVideo.type else {
            completion(nil)
            return
        }
        EditVideoHelper.shared.processType(initialVideo: initialVideo,currentVideo: currentVideo, completion: {[weak self] err in
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
    
    func processPersons(completion: @escaping (([Error]?) -> Void)) {
        guard let _ = currentVideo.persons else {
            completion(nil)
            return
        }
        guard currentVideo.persons!.sorted() != initialVideo.persons?.sorted() else {
            completion(nil)
            return
        }
        EditVideoHelper.shared.processPersons(initialVideo: initialVideo, currentVideo: currentVideo, completion: {[weak self] err in
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
    
    func processVideographers(completion: @escaping (([Error]?) -> Void)) {
        guard let _ = currentVideo.videographers else {
            completion(nil)
            return
        }
        guard currentVideo.videographers!.sorted() != initialVideo.videographers?.sorted() else {
            completion(nil)
            return
        }
        EditVideoHelper.shared.processVideographers(initialVideo: initialVideo, currentVideo: currentVideo, completion: {[weak self] err in
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
    
    func processYoutube(completion: @escaping (([Error]?) -> Void)) {
        guard newDictYoutube != itemDictYoutube else {
            completion(nil)
            return
        }
        EditVideoHelper.shared.processYoutube(initialArr: itemDictYoutube, newArr: newDictYoutube,currentVideo: currentVideo, completion: {[weak self] err in
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
    
    func processIGTV(completion: @escaping (([Error]?) -> Void)) {
        guard newDictIGTV != itemDictIGTV else {
            completion(nil)
            return
        }
        EditVideoHelper.shared.processIGTV(initialArr: itemDictIGTV, newArr: newDictIGTV,currentVideo: currentVideo, completion: {[weak self] err in
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
    
    func processInstagram(completion: @escaping (([Error]?) -> Void)) {
        guard newDictInstagram != itemDictInstagram else {
            completion(nil)
            return
        }
        EditVideoHelper.shared.processInstagram(initialArr: itemDictInstagram, newArr: newDictInstagram,currentVideo: currentVideo, completion: {[weak self] err in
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
    
    func processFacebook(completion: @escaping (([Error]?) -> Void)) {
        guard newDictFacebook != itemDictFacebook else {
            completion(nil)
            return
        }
        EditVideoHelper.shared.processFacebook(initialArr: itemDictFacebook, newArr: newDictFacebook,currentVideo: currentVideo, completion: {[weak self] err in
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
    
    func processWorldstar(completion: @escaping (([Error]?) -> Void)) {
        guard newDictWorldstar != itemDictWorldstar else {
            completion(nil)
            return
        }
        EditVideoHelper.shared.processWorldstar(initialArr: itemDictWorldstar, newArr: newDictWorldstar,currentVideo: currentVideo, completion: {[weak self] err in
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
    
    func processTwitter(completion: @escaping (([Error]?) -> Void)) {
        guard newDictTwitter != itemDictTwitter else {
            completion(nil)
            return
        }
        EditVideoHelper.shared.processTwitter(initialArr: itemDictTwitter, newArr: newDictTwitter,currentVideo: currentVideo, completion: {[weak self] err in
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
    
    func processApple(completion: @escaping (([Error]?) -> Void)) {
        guard newDictApple != itemDictApple else {
            completion(nil)
            return
        }
        EditVideoHelper.shared.processApple(initialArr: itemDictApple, newArr: newDictApple,currentVideo: currentVideo, completion: {[weak self] err in
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
    
    func processTikTok(completion: @escaping (([Error]?) -> Void)) {
        guard newDictTikTok != itemDictTikTok else {
            completion(nil)
            return
        }
        EditVideoHelper.shared.processTikTok(initialArr: itemDictTikTok, newArr: newDictTikTok,currentVideo: currentVideo, completion: {[weak self] err in
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
        guard currentVideo.verificationLevel != initialVideo.verificationLevel else {
            completion(nil)
            return
        }
        EditVideoHelper.shared.processVerificationLevel(initialVideo: initialVideo,currentVideo: currentVideo, completion: {[weak self] err in
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
        guard currentVideo.industryCerified != initialVideo.industryCerified else {
            completion(nil)
            return
        }
        EditVideoHelper.shared.processIndustryCertification(initialVideo: initialVideo,currentVideo: currentVideo, completion: {[weak self] err in
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
        guard currentVideo.isActive != initialVideo.isActive else {
            completion(nil)
            return
        }
        EditVideoHelper.shared.processStatus(initialVideo: initialVideo,currentVideo: currentVideo, completion: {[weak self] err in
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
        if segue.identifier == "editVideoToTonesPick" {
            if let viewController: SelectTonesPickItemViewController = segue.destination as? SelectTonesPickItemViewController {
                viewController.array = arr
                viewController.prevPage = prevPage
                if prevPage == "editVideo" {
                    switch arr {
//                    case "video":
//                        viewController.exeptions = videosArr
//                        viewController.editAlbumVideosDelegate = self
                    case "song":
                        viewController.exeptions = songsArr
                        viewController.editVideoSongsDelegate = self
                    case "person":
                        switch tbsender {
                        case "videographer":
                            viewController.exeptions = videographersArr
                            viewController.editVideoPersonsDelegate = self
                        case "person":
                            viewController.exeptions = personsArr
                            viewController.editVideoPersonsDelegate = self
                        default:
                            break
                        }
//                    case "instrumental":
//                        viewController.exeptions = instrumentalsArr
//                        viewController.editAlbumInstrumentalsDelegate = self
//                    case "song":
//                        switch tbsender {
//                        case "deluxe":
//                            viewController.exeptions = deluxesArr
//                            viewController.editAlbumAlbumsDelegate = self
//                        case "otherVersion":
//                            viewController.exeptions = songOtherVersionsArr
//                            viewController.editAlbumAlbumsDelegate = self
//                        default:
//                            break
//                        }
                    default:
                        break
                    }
                }
                if prevPage == "editVideoAll" {
                    viewController.editVideoAllVideosDelegate = self
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
        setUpPage()
        view.endEditing(true)
    }
    
    @objc func dismissKeyboard3() {
        currentVideo.type = typeHold
        type.text = typeHold
        if currentVideo.type == initialVideo.type {
            type.textColor = .white
        } else {
            type.textColor = .systemGreen
        }
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

extension EditVideoViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
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
        
        image.image = selectedImage
        imageURL.text = "New Image Selected"
        imageURL.textColor = .green
        newImage = selectedImage
        currentVideo.manualThumbnailURL = "NEW"
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
}

extension EditVideoViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func pickerSelected(row: Int, pickerView: UIPickerView) {
        if pickerView == videoPickerView {
            var arr:[VideoData] = []
            arr.append(contentsOf: AllVideosInDatabaseArray)
            let a = AllVideosInDatabaseArray[row]
            currentVideo = arr[row]
            let b = a

            initialVideo.toneDeafAppId = b.toneDeafAppId
            initialVideo.instrumentals = b.instrumentals
            initialVideo.dateIA = b.dateIA
            initialVideo.timeIA = b.timeIA
            initialVideo.songs = b.songs
            initialVideo.albums = b.albums
            initialVideo.beats = b.beats
            initialVideo.merch = b.merch
            initialVideo.title = b.title
            initialVideo.persons = b.persons
            initialVideo.videographers = b.videographers
            initialVideo.favorites = b.favorites
            initialVideo.manualThumbnailURL = b.manualThumbnailURL
            initialVideo.appleMusic = b.appleMusic
            initialVideo.youtube = b.youtube
            initialVideo.igtv = b.igtv
            initialVideo.instagramPost = b.instagramPost
            initialVideo.facebookPost = b.facebookPost
            initialVideo.worldstar = b.worldstar
            initialVideo.twitter = b.twitter
            initialVideo.tikTok = b.tikTok
            initialVideo.isActive = b.isActive
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        var nor = 0
        if pickerView == videoPickerView {
           nor = Constants.Videos.typeArr.count
        }
        return nor
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        var nor = ""
        if pickerView == videoPickerView {
            nor = Constants.Videos.typeArr[row]
        }
        return nor
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == videoPickerView {
            typeHold = Constants.Videos.typeArr[row]
        }
    }
    
    func pickerViewToolbar(textField:UITextField, pickerView:UIPickerView) {
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor.init(red: 182/255, green: 0/255, blue: 3/255, alpha: 1)
        toolBar.sizeToFit()

        var doneButton = UIBarButtonItem()
        if pickerView == videoPickerView {
           doneButton = UIBarButtonItem(title: "Select", style: UIBarButtonItem.Style.done, target: self, action: #selector(dismissKeyboard3))
        }
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItem.Style.plain, target: self, action: #selector(dismissKeyboard))

        if currentVideo == nil {
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

extension EditVideoViewController : UITableViewDataSource, UITableViewDelegate {
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
        case personsTableView:
            return personsArr.count
        case videographersTableView:
            return videographersArr.count
        case youtubeTableView:
            if let count = currentVideo.youtube {
                return count.count
            } else {
                return 0
            }
        case iGTVTableView:
            if let count = currentVideo.igtv {
                return count.count
            } else {
                return 0
            }
        case instagramTableView:
            if let count = currentVideo.instagramPost {
                return count.count
            } else {
                return 0
            }
        case facebookTableView:
            if let count = currentVideo.facebookPost {
                return count.count
            } else {
                return 0
            }
        case worldstarTableView:
            if let count = currentVideo.worldstar {
                return count.count
            } else {
                return 0
            }
        case twitterTableView:
            if let count = currentVideo.twitter {
                return count.count
            } else {
                return 0
            }
        case appleMusicTableView:
            if let count = currentVideo.appleMusic {
                return count.count
            } else {
                return 0
            }
        case tikTokTableView:
            if let count = currentVideo.tikTok {
                return count.count
            } else {
                return 0
            }
        case beatsTableView:
            return beatsArr.count
        case songsTableView:
            return songsArr.count
        case albumsTableView:
            return albumsArr.count
        case instrumentalsTableView:
            return instrumentalsArr.count
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch tableView {
        case personsTableView:
            let cell = tableView.dequeueReusableCell(withIdentifier: "roleEditSongCell", for: indexPath) as! RoleEditSongCell
            if !personsArr.isEmpty {

                cell.setUp(person: personsArr[indexPath.row])
            }
            return cell
        case videographersTableView:
            let cell = tableView.dequeueReusableCell(withIdentifier: "roleEditSongCell", for: indexPath) as! RoleEditSongCell
            if !videographersArr.isEmpty {

                cell.setUp(person: videographersArr[indexPath.row])
            }
            return cell
        case youtubeTableView:
            let cell = tableView.dequeueReusableCell(withIdentifier: "editVideoURLStatusCell", for: indexPath) as! EditVideoURLStatusCell
            if currentVideo.youtube != nil {
                cell.setUp(youtube: currentVideo.youtube![indexPath.row], video: currentVideo,index: indexPath.row)
            }
            return cell
        case iGTVTableView:
            let cell = tableView.dequeueReusableCell(withIdentifier: "editVideoURLStatusCell", for: indexPath) as! EditVideoURLStatusCell
            if currentVideo.igtv != nil {
                cell.setUp(igtv: currentVideo.igtv![indexPath.row], video: currentVideo,index: indexPath.row)
            }
            return cell
        case instagramTableView:
            let cell = tableView.dequeueReusableCell(withIdentifier: "editVideoURLStatusCell", for: indexPath) as! EditVideoURLStatusCell
            if currentVideo.instagramPost != nil {
                cell.setUp(instagram: currentVideo.instagramPost![indexPath.row], video: currentVideo,index: indexPath.row)
            }
            return cell
        case facebookTableView:
            let cell = tableView.dequeueReusableCell(withIdentifier: "editVideoURLStatusCell", for: indexPath) as! EditVideoURLStatusCell
            if currentVideo.facebookPost != nil {
                cell.setUp(facebook: currentVideo.facebookPost![indexPath.row], video: currentVideo,index: indexPath.row)
            }
            return cell
        case worldstarTableView:
            let cell = tableView.dequeueReusableCell(withIdentifier: "editVideoURLStatusCell", for: indexPath) as! EditVideoURLStatusCell
            if currentVideo.worldstar != nil {
                cell.setUp(worldstar: currentVideo.worldstar![indexPath.row], video: currentVideo,index: indexPath.row)
            }
            return cell
        case twitterTableView:
            let cell = tableView.dequeueReusableCell(withIdentifier: "editVideoURLStatusCell", for: indexPath) as! EditVideoURLStatusCell
            if currentVideo.twitter != nil {
                cell.setUp(twitter: currentVideo.twitter![indexPath.row], video: currentVideo,index: indexPath.row)
            }
            return cell
        case appleMusicTableView:
            let cell = tableView.dequeueReusableCell(withIdentifier: "editVideoURLStatusCell", for: indexPath) as! EditVideoURLStatusCell
            if currentVideo.appleMusic != nil {
                cell.setUp(appleMusic: currentVideo.appleMusic![indexPath.row], video: currentVideo,index: indexPath.row)
            }
            return cell
        case tikTokTableView:
            let cell = tableView.dequeueReusableCell(withIdentifier: "editVideoURLStatusCell", for: indexPath) as! EditVideoURLStatusCell
            if currentVideo.tikTok != nil {
                cell.setUp(tikTok: currentVideo.tikTok![indexPath.row], video: currentVideo,index: indexPath.row)
            }
            return cell
        case songsTableView:
            let cell = tableView.dequeueReusableCell(withIdentifier: "roleEditSongCell", for: indexPath) as! RoleEditSongCell
            if !songsArr.isEmpty {
                cell.setUp(song: songsArr[indexPath.row], videoId: currentVideo.toneDeafAppId)
            }
            return cell
        case albumsTableView:
            let cell = tableView.dequeueReusableCell(withIdentifier: "editPersonAlbumCell", for: indexPath) as! EditPersonAlbumCell
            if !albumsArr.isEmpty {
                cell.setUp(album: albumsArr[indexPath.row], artistId: currentVideo.toneDeafAppId)
            }
            return cell
        case instrumentalsTableView:
            let cell = tableView.dequeueReusableCell(withIdentifier: "editPersonInstrumentalCell", for: indexPath) as! EditPersonInstrumentalCell
            if !instrumentalsArr.isEmpty {
                //print(personSongsArr[indexPath.row].songArtist, personSongsArr[indexPath.row].songProducers)
                cell.setUp(instrumental: instrumentalsArr[indexPath.row], artistId: currentVideo.toneDeafAppId)
            }
            return cell
        case beatsTableView:
            let cell = tableView.dequeueReusableCell(withIdentifier: "editPersonInstrumentalCell", for: indexPath) as! EditPersonInstrumentalCell
            if !beatsArr.isEmpty {
                //print(personSongsArr[indexPath.row].songArtist, personSongsArr[indexPath.row].songProducers)
                cell.setUp(beat: beatsArr[indexPath.row], artistId: currentVideo.toneDeafAppId)
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
            case personsTableView:
                personsArr.remove(at: indexPath.row)
                currentVideo.persons = []
                for song in personsArr {
                    currentVideo.persons!.append("\(song.toneDeafAppId)")
                    currentVideo.persons!.sort()
                }
                tableView.deleteRows(at: [indexPath], with: .fade)
                if personsArr.count < 6 {
                    personsHeightConstraint.constant = CGFloat(50*(personsArr.count))
                } else {
                    personsHeightConstraint.constant = CGFloat(270)
                }
            case videographersTableView:
                videographersArr.remove(at: indexPath.row)
                currentVideo.videographers = []
                for song in videographersArr {
                    currentVideo.videographers!.append("\(song.toneDeafAppId)")
                    currentVideo.videographers!.sort()
                }
                tableView.deleteRows(at: [indexPath], with: .fade)
                if videographersArr.count < 6 {
                    videographersHeightConstraint.constant = CGFloat(50*(videographersArr.count))
                } else {
                    videographersHeightConstraint.constant = CGFloat(270)
                }
            case youtubeTableView:
                currentVideo.youtube!.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
                if currentVideo.youtube!.count < 6 {
                    youtubeHeightConstraint.constant = CGFloat(70*(currentVideo.youtube!.count))
                } else {
                    youtubeHeightConstraint.constant = CGFloat(370)
                }
            case iGTVTableView:
                currentVideo.igtv!.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
                if currentVideo.igtv!.count < 6 {
                    iGTVHeightConstraint.constant = CGFloat(70*(currentVideo.igtv!.count))
                } else {
                    iGTVHeightConstraint.constant = CGFloat(370)
                }
            case instagramTableView:
                currentVideo.instagramPost!.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
                if currentVideo.instagramPost!.count < 6 {
                    instagramHeightConstraint.constant = CGFloat(70*(currentVideo.instagramPost!.count))
                } else {
                    instagramHeightConstraint.constant = CGFloat(370)
                }
            case facebookTableView:
                currentVideo.facebookPost!.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
                if currentVideo.facebookPost!.count < 6 {
                    facebookHeightConstraint.constant = CGFloat(70*(currentVideo.facebookPost!.count))
                } else {
                    facebookHeightConstraint.constant = CGFloat(370)
                }
            case worldstarTableView:
                currentVideo.worldstar!.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
                if currentVideo.worldstar!.count < 6 {
                    worldstarHeightConstraint.constant = CGFloat(70*(currentVideo.worldstar!.count))
                } else {
                    worldstarHeightConstraint.constant = CGFloat(370)
                }
            case twitterTableView:
                currentVideo.twitter!.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
                if currentVideo.twitter!.count < 6 {
                    twitterHeightConstraint.constant = CGFloat(70*(currentVideo.twitter!.count))
                } else {
                    twitterHeightConstraint.constant = CGFloat(370)
                }
            case appleMusicTableView:
                currentVideo.appleMusic!.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
                if currentVideo.appleMusic!.count < 6 {
                    appleMusicHeightConstraint.constant = CGFloat(70*(currentVideo.appleMusic!.count))
                } else {
                    appleMusicHeightConstraint.constant = CGFloat(370)
                }
            case tikTokTableView:
                currentVideo.tikTok!.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
                if currentVideo.tikTok!.count < 6 {
                    tikTokHeightConstraint.constant = CGFloat(70*(currentVideo.tikTok!.count))
                } else {
                    tikTokHeightConstraint.constant = CGFloat(370)
                }
            case songsTableView:
                let song = songsArr[indexPath.row]
                if song.officialVideo == currentVideo.toneDeafAppId {
                    song.officialVideo = nil
                }
                if song.audioVideo == currentVideo.toneDeafAppId {
                    song.audioVideo = nil
                }
                if song.lyricVideo == currentVideo.toneDeafAppId {
                    song.lyricVideo = nil
                }
                songsArr.remove(at: indexPath.row)
                currentVideo.songs = []
                for song in songsArr {
                    currentVideo.songs!.append("\(song.toneDeafAppId)")
                    currentVideo.songs!.sort()
                }
                tableView.deleteRows(at: [indexPath], with: .fade)
                if songsArr.count < 6 {
                    songsHeightConstraint.constant = CGFloat(50*(songsArr.count))
                } else {
                    songsHeightConstraint.constant = CGFloat(270)
                }
            default:
                break
            }
        }
    }
    
}

extension EditVideoViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        switch textField {
        case hiddenVideoTextField:
            if currentVideo == nil {
                pickerSelected(row: 0, pickerView: videoPickerView)
            }
            else {
                var count = 0
                for per in AllVideosInDatabaseArray {
                    if per.toneDeafAppId == currentVideo.toneDeafAppId {
                        pickerSelected(row: count, pickerView: videoPickerView)
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

let EditVideoYoutubeURLStatusNotificationKey = "com.gitemsolutions.EditVideoYoutubeURLStatusjkshdfgjkerhdfbn"
let EditVideoYoutubeURLStatusNotify = Notification.Name(EditVideoYoutubeURLStatusNotificationKey)

class EditVideoURLStatusCell: UITableViewCell {
    
    @IBOutlet weak var url: CopyableLabel!
    @IBOutlet weak var artwork: UIImageView!
    @IBOutlet weak var statusControl: UISegmentedControl!
    
    var current:String!
    var currentVideo: VideoData!
    var currentIndex: Int!
    
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        artwork.image = nil
        url.text = ""
    }
    
    func setUp(youtube: YouTubeData, video: VideoData, index:Int) {
        currentIndex = index
        currentVideo = video
        current = "youtube"
        url.text = youtube.url
        if let seggo = video.youtube?[index].isActive {
            if seggo {
                statusControl.selectedSegmentIndex = 0
                statusControl.selectedSegmentTintColor = .systemGreen
            } else {
                statusControl.selectedSegmentTintColor = Constants.Colors.redApp
                statusControl.selectedSegmentIndex = 1
            }
        }
        let imageURL = URL(string: youtube.thumbnailURL)!
        if let cachedImage = imageCache.object(forKey: imageURL.absoluteString as NSString) {
            artwork.image = cachedImage
            return
        } else {
            artwork.setImage(from: imageURL, withPlaceholder: UIImage(named: "tonedeaflogo"))
            return
        }
    }
    
    func setUp(igtv: IGTVData, video: VideoData, index:Int) {
        currentIndex = index
        currentVideo = video
        current = "igtv"
        url.text = igtv.url
        if let seggo = video.igtv?[index].isActive {
            if seggo {
                statusControl.selectedSegmentIndex = 0
                statusControl.selectedSegmentTintColor = .systemGreen
            } else {
                statusControl.selectedSegmentTintColor = Constants.Colors.redApp
                statusControl.selectedSegmentIndex = 1
            }
        }
//        let imageURL = URL(string: igtv.thumbnailURL)!
//        if let cachedImage = imageCache.object(forKey: imageURL.absoluteString as NSString) {
//            artwork.image = cachedImage
//            return
//        } else {
//            artwork.setImage(from: imageURL, withPlaceholder: UIImage(named: "tonedeaflogo"))
//            return
//        }
        let defaultimg = UIImage(named: "tonedeaflogo")!
        artwork.image = defaultimg
    }
    
    func setUp(instagram: InstagramPostData, video: VideoData, index:Int) {
        currentIndex = index
        currentVideo = video
        current = "instagram"
        url.text = instagram.url
        if let seggo = video.instagramPost?[index].isActive {
            if seggo {
                statusControl.selectedSegmentIndex = 0
                statusControl.selectedSegmentTintColor = .systemGreen
            } else {
                statusControl.selectedSegmentTintColor = Constants.Colors.redApp
                statusControl.selectedSegmentIndex = 1
            }
        }
//        let imageURL = URL(string: igtv.thumbnailURL)!
//        if let cachedImage = imageCache.object(forKey: imageURL.absoluteString as NSString) {
//            artwork.image = cachedImage
//            return
//        } else {
//            artwork.setImage(from: imageURL, withPlaceholder: UIImage(named: "tonedeaflogo"))
//            return
//        }
        let defaultimg = UIImage(named: "tonedeaflogo")!
        artwork.image = defaultimg
    }
    
    func setUp(facebook: FacebookPostData, video: VideoData, index:Int) {
        currentIndex = index
        currentVideo = video
        current = "facebook"
        url.text = facebook.url
        if let seggo = video.facebookPost?[index].isActive {
            if seggo {
                statusControl.selectedSegmentIndex = 0
                statusControl.selectedSegmentTintColor = .systemGreen
            } else {
                statusControl.selectedSegmentTintColor = Constants.Colors.redApp
                statusControl.selectedSegmentIndex = 1
            }
        }
//        let imageURL = URL(string: igtv.thumbnailURL)!
//        if let cachedImage = imageCache.object(forKey: imageURL.absoluteString as NSString) {
//            artwork.image = cachedImage
//            return
//        } else {
//            artwork.setImage(from: imageURL, withPlaceholder: UIImage(named: "tonedeaflogo"))
//            return
//        }
        let defaultimg = UIImage(named: "tonedeaflogo")!
        artwork.image = defaultimg
    }
    
    func setUp(worldstar: WorldstarData, video: VideoData, index:Int) {
        currentIndex = index
        currentVideo = video
        current = "worldstar"
        url.text = worldstar.url
        if let seggo = video.worldstar?[index].isActive {
            if seggo {
                statusControl.selectedSegmentIndex = 0
                statusControl.selectedSegmentTintColor = .systemGreen
            } else {
                statusControl.selectedSegmentTintColor = Constants.Colors.redApp
                statusControl.selectedSegmentIndex = 1
            }
        }
//        let imageURL = URL(string: igtv.thumbnailURL)!
//        if let cachedImage = imageCache.object(forKey: imageURL.absoluteString as NSString) {
//            artwork.image = cachedImage
//            return
//        } else {
//            artwork.setImage(from: imageURL, withPlaceholder: UIImage(named: "tonedeaflogo"))
//            return
//        }
        let defaultimg = UIImage(named: "tonedeaflogo")!
        artwork.image = defaultimg
    }
    
    func setUp(twitter: TwitterTweetData, video: VideoData, index:Int) {
        currentIndex = index
        currentVideo = video
        current = "twitter"
        url.text = twitter.url
        if let seggo = video.twitter?[index].isActive {
            if seggo {
                statusControl.selectedSegmentIndex = 0
                statusControl.selectedSegmentTintColor = .systemGreen
            } else {
                statusControl.selectedSegmentTintColor = Constants.Colors.redApp
                statusControl.selectedSegmentIndex = 1
            }
        }
        let imageURL = URL(string: twitter.media![0].previewURL!)!
        if let cachedImage = imageCache.object(forKey: imageURL.absoluteString as NSString) {
            artwork.image = cachedImage
            return
        } else {
            artwork.setImage(from: imageURL, withPlaceholder: UIImage(named: "tonedeaflogo"))
            return
        }
        let defaultimg = UIImage(named: "tonedeaflogo")!
        artwork.image = defaultimg
    }
    
    func setUp(appleMusic: AppleVideoData, video: VideoData, index:Int) {
        currentIndex = index
        currentVideo = video
        current = "apple"
        url.text = appleMusic.url
        if let seggo = video.appleMusic?[index].isActive {
            if seggo {
                statusControl.selectedSegmentIndex = 0
                statusControl.selectedSegmentTintColor = .systemGreen
            } else {
                statusControl.selectedSegmentTintColor = Constants.Colors.redApp
                statusControl.selectedSegmentIndex = 1
            }
        }
//        let imageURL = URL(string: appleMusic.previewURL)!
//        if let cachedImage = imageCache.object(forKey: imageURL.absoluteString as NSString) {
//            artwork.image = cachedImage
//            return
//        } else {
//            artwork.setImage(from: imageURL, withPlaceholder: UIImage(named: "tonedeaflogo"))
//            return
//        }
        let defaultimg = UIImage(named: "tonedeaflogo")!
        artwork.image = defaultimg
    }
    
    func setUp(tikTok: TikTokData, video: VideoData, index:Int) {
        currentIndex = index
        currentVideo = video
        current = "tiktok"
        url.text = tikTok.url
        if let seggo = video.tikTok?[index].isActive {
            if seggo {
                statusControl.selectedSegmentIndex = 0
                statusControl.selectedSegmentTintColor = .systemGreen
            } else {
                statusControl.selectedSegmentTintColor = Constants.Colors.redApp
                statusControl.selectedSegmentIndex = 1
            }
        }
//        let imageURL = URL(string: igtv.thumbnailURL)!
//        if let cachedImage = imageCache.object(forKey: imageURL.absoluteString as NSString) {
//            artwork.image = cachedImage
//            return
//        } else {
//            artwork.setImage(from: imageURL, withPlaceholder: UIImage(named: "tonedeaflogo"))
//            return
//        }
        let defaultimg = UIImage(named: "tonedeaflogo")!
        artwork.image = defaultimg
    }
    
    @IBAction func statusChanged(_ sender: Any) {
        lightImpactGenerator.impactOccurred(intensity: 0.75)
        if statusControl.selectedSegmentIndex == 0 {
            NotificationCenter.default.post(name: adminDashboardStartSpinnerNotify, object: nil)
            statusControl.selectedSegmentTintColor = .systemGreen
            GlobalFunctions.shared.verifyUrl(urlString: url.text!, completion: {[weak self] validity in
                guard let strongSelf = self else {return}
                DispatchQueue.main.async {
                    NotificationCenter.default.post(name: adminDashboardStopSpinnerNotify, object: nil)
                }
                if !validity {
                    mediumImpactGenerator.impactOccurred()
                    DispatchQueue.main.async {
                        Utilities.showError2("Url invalid.", actionText: "OK")
                        strongSelf.statusControl.selectedSegmentIndex = 1
                        strongSelf.statusControl.selectedSegmentTintColor = Constants.Colors.redApp
                    }
                    switch strongSelf.current {
                    case "youtube":
                        strongSelf.currentVideo.youtube![strongSelf.currentIndex].isActive = false
                        NotificationCenter.default.post(name: EditVideoYoutubeURLStatusNotify, object: strongSelf.currentVideo)
                    case "igtv":
                        strongSelf.currentVideo.igtv![strongSelf.currentIndex].isActive = false
                        NotificationCenter.default.post(name: EditVideoYoutubeURLStatusNotify, object: strongSelf.currentVideo)
                    case "instagram":
                        strongSelf.currentVideo.instagramPost![strongSelf.currentIndex].isActive = false
                        NotificationCenter.default.post(name: EditVideoYoutubeURLStatusNotify, object: strongSelf.currentVideo)
                    case "facebook":
                        strongSelf.currentVideo.facebookPost![strongSelf.currentIndex].isActive = false
                        NotificationCenter.default.post(name: EditVideoYoutubeURLStatusNotify, object: strongSelf.currentVideo)
                    case "worldstar":
                        strongSelf.currentVideo.worldstar![strongSelf.currentIndex].isActive = false
                        NotificationCenter.default.post(name: EditVideoYoutubeURLStatusNotify, object: strongSelf.currentVideo)
                    case "twitter":
                        strongSelf.currentVideo.twitter![strongSelf.currentIndex].isActive = false
                        NotificationCenter.default.post(name: EditVideoYoutubeURLStatusNotify, object: strongSelf.currentVideo)
                    case "apple":
                        strongSelf.currentVideo.appleMusic![strongSelf.currentIndex].isActive = false
                        NotificationCenter.default.post(name: EditVideoYoutubeURLStatusNotify, object: strongSelf.currentVideo)
                    case "tiktok":
                        strongSelf.currentVideo.tikTok![strongSelf.currentIndex].isActive = false
                        NotificationCenter.default.post(name: EditVideoYoutubeURLStatusNotify, object: strongSelf.currentVideo)
                    default:
                        break
                    }
                }
                switch strongSelf.current {
                case "youtube":
                    strongSelf.currentVideo.youtube![strongSelf.currentIndex].isActive = true
                    NotificationCenter.default.post(name: EditVideoYoutubeURLStatusNotify, object: strongSelf.currentVideo)
                case "igtv":
                    strongSelf.currentVideo.igtv![strongSelf.currentIndex].isActive = true
                    NotificationCenter.default.post(name: EditVideoYoutubeURLStatusNotify, object: strongSelf.currentVideo)
                case "instagram":
                    strongSelf.currentVideo.instagramPost![strongSelf.currentIndex].isActive = true
                    NotificationCenter.default.post(name: EditVideoYoutubeURLStatusNotify, object: strongSelf.currentVideo)
                case "facebook":
                    strongSelf.currentVideo.facebookPost![strongSelf.currentIndex].isActive = true
                    NotificationCenter.default.post(name: EditVideoYoutubeURLStatusNotify, object: strongSelf.currentVideo)
                case "worldstar":
                    strongSelf.currentVideo.worldstar![strongSelf.currentIndex].isActive = true
                    NotificationCenter.default.post(name: EditVideoYoutubeURLStatusNotify, object: strongSelf.currentVideo)
                case "twitter":
                    strongSelf.currentVideo.twitter![strongSelf.currentIndex].isActive = true
                    NotificationCenter.default.post(name: EditVideoYoutubeURLStatusNotify, object: strongSelf.currentVideo)
                case "apple":
                    strongSelf.currentVideo.appleMusic![strongSelf.currentIndex].isActive = true
                    NotificationCenter.default.post(name: EditVideoYoutubeURLStatusNotify, object: strongSelf.currentVideo)
                case "tiktok":
                    strongSelf.currentVideo.tikTok![strongSelf.currentIndex].isActive = true
                    NotificationCenter.default.post(name: EditVideoYoutubeURLStatusNotify, object: strongSelf.currentVideo)
                default:
                    break
                }
            })
        } else {
            statusControl.selectedSegmentTintColor = Constants.Colors.redApp
            switch current {
            case "youtube":
                currentVideo.youtube![currentIndex].isActive = false
                NotificationCenter.default.post(name: EditVideoYoutubeURLStatusNotify, object: currentVideo)
            case "igtv":
                currentVideo.igtv![currentIndex].isActive = false
                NotificationCenter.default.post(name: EditVideoYoutubeURLStatusNotify, object: currentVideo)
            case "instagram":
                currentVideo.instagramPost![currentIndex].isActive = false
                NotificationCenter.default.post(name: EditVideoYoutubeURLStatusNotify, object: currentVideo)
            case "facebook":
                currentVideo.facebookPost![currentIndex].isActive = false
                NotificationCenter.default.post(name: EditVideoYoutubeURLStatusNotify, object: currentVideo)
            case "worldstar":
                currentVideo.worldstar![currentIndex].isActive = false
                NotificationCenter.default.post(name: EditVideoYoutubeURLStatusNotify, object: currentVideo)
            case "twitter":
                currentVideo.twitter![currentIndex].isActive = false
                NotificationCenter.default.post(name: EditVideoYoutubeURLStatusNotify, object: currentVideo)
            case "apple":
                currentVideo.appleMusic![currentIndex].isActive = false
                NotificationCenter.default.post(name: EditVideoYoutubeURLStatusNotify, object: currentVideo)
            case "tiktok":
                currentVideo.tikTok![currentIndex].isActive = false
                NotificationCenter.default.post(name: EditVideoYoutubeURLStatusNotify, object: currentVideo)
            default:
                break
            }
        }
    }
}
