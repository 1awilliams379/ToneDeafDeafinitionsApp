//
//  DashboardViewController.swift
//  ToneDeafDeafinitionsApp
//
//  Created by Tone Deaf on 7/26/20.
//  Copyright © 2020 GITEM Solutions. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage
import SwiftUI
import MarqueeLabel
import SkeletonView
import SideMenu
import SPStorkController
import CollectionViewPagingLayout
import AVFoundation
import AVKit

var currentUser = Auth.auth().currentUser
var currentUID = Auth.auth().currentUser?.uid

var accountType = ""
let ListenerAccount = "Listener"
let CreatorAccount = "Creator"
let AnonymousAccount = "Anonymous"
let AdminAccount = "Admins"

var alertController:UIAlertController!

class DashboardViewController: UIViewController {
    
    
    static let shared = DashboardViewController()
    
    @IBOutlet weak var mainSearchButton: UIBarButtonItem!
    @IBOutlet weak var scrollView1: UIScrollView!
    
    var lastContentOffset: CGFloat = 0
    var maxHeaderHeight: CGFloat = 0
    
    @IBOutlet weak var songOfTheDayCard: UIView!
    @IBOutlet weak var songMainCardView: UIView!
    @IBOutlet weak var songOfTheDayImage: UIImageView!
    @IBOutlet weak var songOfTheDayMonth: MarqueeLabel!
    @IBOutlet weak var songOfTheDayDay: MarqueeLabel!
    @IBOutlet weak var songOfTheDaySongTitile: MarqueeLabel!
    @IBOutlet weak var songOfTheDayArtist: MarqueeLabel!
    @IBOutlet weak var songOfTheDayReleaseDate: MarqueeLabel!
    
    @IBOutlet weak var songOfYesterdayCard: UIView!
    @IBOutlet weak var songYesterdayMAinCardView: UIView!
    @IBOutlet weak var songOfYesterdayImage: UIImageView!
    @IBOutlet weak var songOfYesterdayMonth: MarqueeLabel!
    @IBOutlet weak var songOfYesterdayDay: MarqueeLabel!
    @IBOutlet weak var songOfYesterdaySongTitile: MarqueeLabel!
    @IBOutlet weak var songOfYesterdayArtist: MarqueeLabel!
    @IBOutlet weak var songOfYesterdayReleaseDate:MarqueeLabel!
    
    @IBOutlet weak var beatOfTheDayCard: UIView!
    @IBOutlet weak var beatMainCardView: UIView!
    @IBOutlet weak var beatOfTheDayImage: UIImageView!
    @IBOutlet weak var beatOfTheDayMonth: MarqueeLabel!
    @IBOutlet weak var beatOfTheDayDay: MarqueeLabel!
    @IBOutlet weak var beatOfTheDayBeatTitile: MarqueeLabel!
    @IBOutlet weak var beatOfTheDayProducers: MarqueeLabel!
    @IBOutlet weak var beatOfTheDayReleaseDate: MarqueeLabel!
    
    @IBOutlet weak var beatOfYesterdayCard: UIView!
    @IBOutlet weak var beatYesterdayMainCard: UIView!
    @IBOutlet weak var beatYesterdayImage: UIImageView!
    @IBOutlet weak var beatOfYesterdayMonth: MarqueeLabel!
    @IBOutlet weak var beatOfYesterdayDay: MarqueeLabel!
    @IBOutlet weak var beatOfYesterdayBeatTitile: MarqueeLabel!
    @IBOutlet weak var beatOfYesterdayProducers: MarqueeLabel!
    @IBOutlet weak var beatOfYesterdayReleaseDate:MarqueeLabel!
    
    @IBOutlet weak var latestContentView: UIView!
    @IBOutlet weak var latestContentSkeleton: UIView!
    
    @IBOutlet weak var highlightedVideoView: UIView!
    var player: AVPlayer!
    var avpController = AVPlayerViewController()
    
    @IBOutlet weak var latestBeatsTableView: DashboardLatestBeatsTableView!
    @IBOutlet weak var latestBeatsTableHeight: NSLayoutConstraint!
    @IBOutlet weak var allBeatsStackView: UIStackView!
    
    @IBOutlet weak var userFavoritesStackView: UIStackView!
    var favoritesCollectionView: UICollectionView!
    @IBOutlet weak var favoritesView: UIView!
    @IBOutlet weak var allFavoritesStackView: UIStackView!
    var dashFavoritesArray:[Any] = []
    
    @IBOutlet weak var checkItOutCollectionView: UICollectionView!
    var merchToGo:Any!
    var checkItOutArr:[MerchData] = []
    
    var infoDetailContent:Any!
    var artistInfo:ArtistData!
    var producerInfo:ProducerData!
    var beatInfo:BeatData!
    
    
    let host = UIHostingController(rootView: LatestView())
    
    var skelvar = 0
    var musicTableHeight:CGFloat = 0
    var parsedMonth:String!
    var parsedDay:String.SubSequence!
    var yparsedMonth:String!
    var yparsedDay:String.SubSequence!
    var dashvisualEffectView: UIVisualEffectView!
    
    var songOfTheDayContentArray:Array<SongData> = []
    var beatOfTheDayContentArray:Array<BeatData> = []
    
    var latestBeatsArray:Array<BeatData> = []
    
    var visualEffectView:UIVisualEffectView!
    
    @IBOutlet weak var loginStatus: UILabel!{
        didSet {
            if currentUser != nil {
                loginStatus.text = ("User: \(currentUser!.email) - \(accountType)")
            }
           
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
          self.navigationController?.navigationBar.shadowImage = UIImage()
          self.navigationController?.navigationBar.isTranslucent = true
        createObservers()
        parseDate()
        parseYesterdayDate()
        setHighlightedVideo()
        latestBeatsTableView.delegate = self
        latestBeatsTableView.dataSource = self
        scrollView1.delaysContentTouches = false
        let beatGes = UITapGestureRecognizer(target: self, action: #selector(allBeatsTapped))
        allBeatsStackView.addGestureRecognizer(beatGes)
        let favGes = UITapGestureRecognizer(target: self, action: #selector(allFavoritesTapped))
        allFavoritesStackView.addGestureRecognizer(favGes)
        userFavoritesStackView.isHidden = true
        setCheckItOut()
        let userDefaults = UserDefaults.standard
        if userDefaults.value(forKey: "appFirstTimeOpend") == nil {
            print("📘 first time opening app")
            //if app is first time opened then it will be nil
            userDefaults.setValue(true, forKey: "appFirstTimeOpend")
            //TODO signOut from FIRAuth from profile
            print("📘 launch acctype: \(accountType)")
                if accountType != "" {
                    ViewController.shared.logout()
                }
                else {
                    ViewController.shared.signInAnnonymously(completion: {
                        DatabaseManager.shared.getUserData(with: currentUser!.uid, completion: { usr in
                            currentAppUser = usr
                            accountType = currentAppUser.accountType
                            let queue = DispatchQueue(label: "daQueue")
                            let group = DispatchGroup()
                            let array = [1, 2, 3, 4, 5]

                            for i in array {
                                //print(i)
                                group.enter()
                                queue.async { [weak self] in
                                    guard let strongSelf = self else {return}
                                    switch i {
                                    case 1:
                                        //print("null")
                                        strongSelf.fetchSongOfTheDay(completion: {
                                            strongSelf.view.layoutSubviews()
                                            print("done \(i)")
                                            group.leave()
                                        })
                                    case 2:
                                        //print("null")
                                        strongSelf.fetchBeatOfTheDay(completion: {
                                            print("done \(i)")
                                            group.leave()
                                        })
                                    case 3:
                                        //print("null")
                                        strongSelf.fetchLatestContent(completion: {
                                            print("done \(i)")
                                            group.leave()
                                        })
                                    case 4:
                                        strongSelf.fetchLatestBeats(completion: {
                                            print("done \(i)")
                                            group.leave()
                                        })
                                    case 5:
                                        strongSelf.setupFavoritesCollectionView(completion: {
                                            print("done \(i)")
                                            group.leave()
                                        })
                                    default:
                                        print("error")
                                    }
                                }
                            }
                        })
                    })
            }
        }
        else {
            if currentUser == nil {
                ViewController.shared.signInAnnonymously(completion: {
                    DatabaseManager.shared.getUserData(with: currentUser!.uid, completion: { usr in
                        currentAppUser = usr
                        accountType = currentAppUser.accountType
                        let queue = DispatchQueue(label: "daQueue")
                        let group = DispatchGroup()
                        let array = [1, 2, 3, 4, 5]

                        for i in array {
                            //print(i)
                            group.enter()
                            queue.async { [weak self] in
                                guard let strongSelf = self else {return}
                                switch i {
                                case 1:
                                    //print("null")
                                    strongSelf.fetchSongOfTheDay(completion: {
                                        strongSelf.view.layoutSubviews()
                                        print("done \(i)")
                                        group.leave()
                                    })
                                case 2:
                                    //print("null")
                                    strongSelf.fetchBeatOfTheDay(completion: {
                                        print("done \(i)")
                                        group.leave()
                                    })
                                case 3:
                                    //print("null")
                                    strongSelf.fetchLatestContent(completion: {
                                        print("done \(i)")
                                        group.leave()
                                    })
                                case 4:
                                    strongSelf.fetchLatestBeats(completion: {
                                        print("done \(i)")
                                        group.leave()
                                    })
                                case 5:
                                    strongSelf.setFavsArray(completion: {
                                        print("done \(i)")
                                        print(strongSelf.dashFavoritesArray)
                                        group.leave()
                                    })
                                default:
                                    print("error")
                                }
                            }
                        }
                    })
                })
            } else {
                DatabaseManager.shared.getUserData(with: currentUser!.uid, completion: { usr in
                    currentAppUser = usr
                    accountType = currentAppUser.accountType
                    let queue = DispatchQueue(label: "daQueue")
                    let group = DispatchGroup()
                    let array = [1, 2, 3, 4, 5]

                    for i in array {
                        //print(i)
                        group.enter()
                        queue.async { [weak self] in
                            guard let strongSelf = self else {return}
                            switch i {
                            case 1:
                                //print("null")
                                strongSelf.fetchSongOfTheDay(completion: {
                                    strongSelf.view.layoutSubviews()
                                    print("done \(i)")
                                    group.leave()
                                })
                            case 2:
                                //print("null")
                                strongSelf.fetchBeatOfTheDay(completion: {
                                    print("done \(i)")
                                    group.leave()
                                })
                            case 3:
                                //print("null")
                                strongSelf.fetchLatestContent(completion: {
                                    print("done \(i)")
                                    group.leave()
                                })
                            case 4:
                                strongSelf.fetchLatestBeats(completion: {
                                    print("done \(i)")
                                    group.leave()
                                })
                            case 5:
                                strongSelf.setFavsArray(completion: {
                                    print("done \(i)")
                                    print(strongSelf.dashFavoritesArray)
                                    group.leave()
                                })
                            default:
                                print("error")
                            }
                        }
                    }
                })
            }
        }
        
        if skelvar == 0 {
            
            songOfTheDayCard.isSkeletonable = true
            songOfTheDayCard.showAnimatedGradientSkeleton(usingGradient: .init(baseColor: UIColor.init(red: 22/255, green: 22/255, blue: 22/255, alpha: 1)), animation: nil, transition: .crossDissolve(0.25))
            
            songOfYesterdayCard.isSkeletonable = true
            songOfYesterdayCard.showAnimatedGradientSkeleton(usingGradient: .init(baseColor: UIColor.init(red: 22/255, green: 22/255, blue: 22/255, alpha: 1)), animation: nil, transition: .crossDissolve(0.25))
            
            beatOfTheDayCard.isSkeletonable = true
            beatOfTheDayCard.showAnimatedGradientSkeleton(usingGradient: .init(baseColor: UIColor.init(red: 22/255, green: 22/255, blue: 22/255, alpha: 1)), animation: nil, transition: .crossDissolve(0.25))
            
            beatOfYesterdayCard.isSkeletonable = true
            beatOfYesterdayCard.showAnimatedGradientSkeleton(usingGradient: .init(baseColor: UIColor.init(red: 22/255, green: 22/255, blue: 22/255, alpha: 1)), animation: nil, transition: .crossDissolve(0.25))
            
            latestContentSkeleton.isSkeletonable = true
            latestContentSkeleton.showAnimatedGradientSkeleton(usingGradient: .init(baseColor: UIColor.init(red: 22/255, green: 22/255, blue: 22/255, alpha: 1)), animation: nil, transition: .crossDissolve(0.25))
            
            latestBeatsTableView.isSkeletonable = true
            latestBeatsTableView.showAnimatedGradientSkeleton(usingGradient: .init(baseColor: UIColor.init(red: 22/255, green: 22/255, blue: 22/255, alpha: 1)), animation: nil, transition: .crossDissolve(0.25))
        }
        
        skelvar+=1
        
        //songOfTheDayImage.dropShadow()
//        strongSelf.songOfTheDayImage.layer.cornerRadius = 5
        songOfTheDayCard.roundCorners(corners: [.topLeft,.topRight], radius: 7)
        songMainCardView.roundCorners(corners: [.topLeft,.topRight], radius: 7)
//
        //songOfYesterdayImage.dropShadowOfTheDay()
//        strongSelf.songOfYesterdayImage.layer.cornerRadius = 5
        songOfYesterdayCard.roundCorners(corners: [.topLeft,.topRight], radius: 7)
        songYesterdayMAinCardView.roundCorners(corners: [.topLeft,.topRight], radius: 7)
//
        //beatOfTheDayImage.dropShadow()
//        beatOfTheDayImage.layer.cornerRadius = 5
        beatOfTheDayCard.roundCorners(corners: [.topLeft,.topRight], radius: 7)
        beatMainCardView.roundCorners(corners: [.topLeft,.topRight], radius: 7)
//
        //beatYesterdayImage.dropShadow()
//        beatYesterdayImage.layer.cornerRadius = 5
        beatOfYesterdayCard.roundCorners(corners: [.topLeft,.topRight], radius: 7)
        beatYesterdayMainCard.roundCorners(corners: [.topLeft,.topRight], radius: 7)
    }
    
    @objc func allFavoritesTapped() {
        performSegue(withIdentifier: "dashToAllFavorites", sender: nil)
    }
    
    @objc func allBeatsTapped() {
        performSegue(withIdentifier: "dashToBeats", sender: nil)
    }
    
    @objc func allArtistTapped() {
        
    }
    
    func hidevisualbluinheader() {
        visualEffectView.removeFromSuperview()
        visualEffectView = nil
        if visualEffectView != nil {
            hidevisualbluinheader()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
            self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
          self.navigationController?.navigationBar.shadowImage = UIImage()
          self.navigationController?.navigationBar.isTranslucent = true
        if scrollView1.contentOffset.y <= 0 {
            if visualEffectView != nil {
                hidevisualbluinheader()
            }
        } else {
            if visualEffectView != nil {
                hidevisualbluinheader()
            }
            if visualEffectView == nil {
                visualEffectView   = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
                visualEffectView.frame =  (navigationController?.navigationBar.bounds.insetBy(dx: 0, dy: -10).offsetBy(dx: 0, dy: -10))!
                navigationController?.navigationBar.addSubview(visualEffectView)
                navigationController?.navigationBar.sendSubviewToBack(visualEffectView)
                visualEffectView.layer.zPosition = -1;
                visualEffectView.isUserInteractionEnabled = false
            }
        }
        view.layoutSubviews()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        if visualEffectView != nil {
            hidevisualbluinheader()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
          self.navigationController?.navigationBar.shadowImage = UIImage()
          self.navigationController?.navigationBar.isTranslucent = true
        if skelvar == 0 {
            
            songOfTheDayCard.isSkeletonable = true
            songOfTheDayCard.showAnimatedGradientSkeleton(usingGradient: .init(baseColor: UIColor.init(red: 22/255, green: 22/255, blue: 22/255, alpha: 1)), animation: nil, transition: .crossDissolve(0.25))
            
            songOfYesterdayCard.isSkeletonable = true
            songOfYesterdayCard.showAnimatedGradientSkeleton(usingGradient: .init(baseColor: UIColor.init(red: 22/255, green: 22/255, blue: 22/255, alpha: 1)), animation: nil, transition: .crossDissolve(0.25))
            
            beatOfTheDayCard.isSkeletonable = true
            beatOfTheDayCard.showAnimatedGradientSkeleton(usingGradient: .init(baseColor: UIColor.init(red: 22/255, green: 22/255, blue: 22/255, alpha: 1)), animation: nil, transition: .crossDissolve(0.25))
            
            beatOfYesterdayCard.isSkeletonable = true
            beatOfYesterdayCard.showAnimatedGradientSkeleton(usingGradient: .init(baseColor: UIColor.init(red: 22/255, green: 22/255, blue: 22/255, alpha: 1)), animation: nil, transition: .crossDissolve(0.25))
            
        }
        
        skelvar+=1
        //tableview.showAnimatedSkeleton(usingColor: .wetAsphalt, transition: .crossDissolve(0.25))
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        favoritesCollectionView?.performBatchUpdates({
            self.favoritesCollectionView.collectionViewLayout.invalidateLayout()
        })
    }
    
    func hideskeleton(view: Any) {
        DispatchQueue.main.async {
            switch view {
            case is UIView:
              let uview = view as! UIView
              uview.stopSkeletonAnimation()
              uview.hideSkeleton(reloadDataAfter: true, transition: .crossDissolve(0.25))
            case is UITableView:
                let tableview = view as! UITableView
                tableview.stopSkeletonAnimation()
                tableview.hideSkeleton(reloadDataAfter: true, transition: .crossDissolve(0.25))
                tableview.reloadData()
            default:
                print("error with removing skeleton from dashboard.")
            }
        }
    }
    
    func fetchSongOfTheDay(completion: @escaping () -> Void) {
        DispatchQueue.global(qos: .userInitiated).async {
            DatabaseManager.shared.getSongOfTheDayContent(completion: {[weak self] songToday, songYesterday in
                var stoday:SongData!
                var syest:SongData!
                var done = false
                guard let strongSelf = self else {return}
                strongSelf.songOfTheDayContentArray = []
                DatabaseManager.shared.findSongById(songId: songToday, completion: { result in
                    switch result {
                    case .success(let st):
                        strongSelf.songOfTheDayContentArray.insert(st, at: 0)
                        stoday = st
                        if stoday != nil && syest != nil && done == false {
                            done = true
                            strongSelf.loadSongsData(songToday: stoday, songYesterday: syest, completion: {
                                strongSelf.hideskeleton(view: strongSelf.songOfTheDayCard!)
                                strongSelf.hideskeleton(view: strongSelf.songOfYesterdayCard!)
                            })
                        }
                    case .failure(let err):
                        print("sotd err: " + err.localizedDescription)
                    }
                    
                })
                DatabaseManager.shared.findSongById(songId: songYesterday, completion: { result in
                    switch result {
                    case .success(let st):
                        strongSelf.songOfTheDayContentArray.insert(st, at: 1)
                        syest = st
                        if stoday != nil && syest != nil && done == false {
                            done = true
                            strongSelf.loadSongsData(songToday: stoday, songYesterday: syest, completion: {
                                strongSelf.hideskeleton(view: strongSelf.songOfTheDayCard!)
                                strongSelf.hideskeleton(view: strongSelf.songOfYesterdayCard!)
                            })
                        }
                    case .failure(let err):
                        print("sotd err 2: " + err.localizedDescription)
                    }
                })
                
                
            })
        }
    }
    
    func fetchBeatOfTheDay(completion: @escaping () -> Void) {
        DispatchQueue.global(qos: .userInitiated).async {
            DatabaseManager.shared.getBeatOfTheDayContent(completion: {[weak self] beatToday, beatYesterday in
                guard let strongSelf = self else {return}
                var stoday:BeatData!
                var syest:BeatData!
                var done = false
                guard let strongSelf = self else {return}
                strongSelf.beatOfTheDayContentArray = []
                DatabaseManager.shared.findBeatById(beatId: beatToday, completion: { result in
                    switch result {
                    case .success(let st):
                        strongSelf.beatOfTheDayContentArray.insert(st, at: 0)
                        stoday = st
                        if stoday != nil && syest != nil && done == false {
                            done = true
                            strongSelf.loadBeatsData(beatToday: stoday, beatYesterday: syest, completion: {
                                strongSelf.hideskeleton(view: strongSelf.beatOfTheDayCard!)
                                strongSelf.hideskeleton(view: strongSelf.beatOfYesterdayCard!)
                            })
                        }
                    case .failure(let err):
                        print("sotd err: " + err.localizedDescription)
                    }
                    
                })
                DatabaseManager.shared.findBeatById(beatId: beatYesterday, completion: { result in
                    switch result {
                    case .success(let st):
                        strongSelf.beatOfTheDayContentArray.insert(st, at: 1)
                        syest = st
                        if stoday != nil && syest != nil && done == false {
                            done = true
                            strongSelf.loadBeatsData(beatToday: stoday, beatYesterday: syest, completion: {
                                strongSelf.hideskeleton(view: strongSelf.beatOfTheDayCard!)
                                strongSelf.hideskeleton(view: strongSelf.beatOfYesterdayCard!)
                            })
                        }
                    case .failure(let err):
                        print("sotd err 2: " + err.localizedDescription)
                    }
                })
                
                
            })
        }
    }
    
    func parseDate() {
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM dd yyyy"
        let layedDate = formatter.string(from: date)
        
        let words = layedDate.split(separator: " ")
        //let parsedYear = words[2]
        parsedMonth = words[0].replacingOccurrences(of: "August", with: "Aug").replacingOccurrences(of: "January", with: "Jan").replacingOccurrences(of: "February", with: "Feb").replacingOccurrences(of: "March", with: "Mar").replacingOccurrences(of: "April", with: "Apr").replacingOccurrences(of: "May", with: "May").replacingOccurrences(of: "June", with: "June").replacingOccurrences(of: "July", with: "July").replacingOccurrences(of: "September", with: "Sep").replacingOccurrences(of: "October", with: "Oct").replacingOccurrences(of: "November", with: "Nov").replacingOccurrences(of: "December", with: "Dec")
        parsedDay = words[1]
    }
    
    func parseYesterdayDate() {
        let date = Date.yesterday
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM dd yyyy"
        let layedDate = formatter.string(from: date)
        
        let words = layedDate.split(separator: " ")
        //let parsedYear = words[2]
        yparsedMonth = words[0].replacingOccurrences(of: "August", with: "Aug").replacingOccurrences(of: "January", with: "Jan").replacingOccurrences(of: "February", with: "Feb").replacingOccurrences(of: "March", with: "Mar").replacingOccurrences(of: "April", with: "Apr").replacingOccurrences(of: "May", with: "May").replacingOccurrences(of: "June", with: "June").replacingOccurrences(of: "July", with: "July").replacingOccurrences(of: "September", with: "Sep").replacingOccurrences(of: "October", with: "Oct").replacingOccurrences(of: "November", with: "Nov").replacingOccurrences(of: "December", with: "Dec")
        yparsedDay = words[1]
    }
    
    fileprivate func getArtistData(song:SongData, completion: @escaping (Array<String>) -> Void) {
        var artistNameData:Array<String> = []
        var val = 0
        for artist in song.songArtist {
            
            DatabaseManager.shared.fetchPersonData(person: artist, completion: {[weak self] result in
                guard let strongSelf = self else {return}
                switch result {
                case .success(let person):
                    val+=1
                    artistNameData.append(person.name)
                    if val == song.songArtist.count {
                        completion(artistNameData)
                    }
                case .failure(let err):
                    print("dsvgredfxbdfzx"+err.localizedDescription)
                }
            })
        }
        
    }
    
    func getSongYoutubeData(song:SongData, completion: @escaping (Array<YouTubeData>, Array<String>) -> Void) {
        var videosData:Array<YouTubeData> = []
        var youtubeimageURLs:Array<String> = []
        var val = 1
        if song.videos! == [""] || song.videos!.isEmpty {
            completion(videosData, youtubeimageURLs)
            return
        }
        for video in song.videos! {
            let word = video.split(separator: "Æ")
            let id = word[0]
            print(id)
            DatabaseManager.shared.findVideoById(videoid: String(id), completion: { selectedVideo in
                switch selectedVideo {
                case .success(let vid):
                    let video = vid as! YouTubeData
                    videosData.append(video)
                    if video.thumbnailURL != "" {
                        youtubeimageURLs.append(video.thumbnailURL)
                    }
                    if val == song.videos!.count {
                        completion(videosData, youtubeimageURLs)
                    }
                    val+=1
                case .failure(let error):
                    print("Video ID proccessing error \(error)")
                    val+=1
                }
            })
        }
        
    }
    
    func loadSongsData(songToday:SongData, songYesterday:SongData, completion: @escaping () -> Void) {
        DispatchQueue.main.async { [weak self] in
            guard let strongSelf = self else {return}
            strongSelf.getArtistData(song: songToday, completion: { artistNames in
                //print(artistNames)
                var imageurl = ""
                GlobalFunctions.shared.selectImageURL(song: songToday, completion: { ur in
                    guard let uri = ur else {fatalError()}
                    imageurl = uri
                    let imageURL = URL(string: imageurl)!
                    strongSelf.songOfTheDayDay.text = String(strongSelf.parsedDay)
                    strongSelf.songOfTheDayMonth.text = strongSelf.parsedMonth
                    strongSelf.songOfTheDaySongTitile.text = songToday.name
                    strongSelf.songOfTheDayArtist.text = artistNames.joined(separator: ", ")
                    Comparisons.shared.getEarliestReleaseDate(song: songToday, completion: { edate in
                        strongSelf.songOfTheDayReleaseDate.text = "Released: \(edate)"
                    })
                    if let cachedImage = imageCache.object(forKey: imageURL.absoluteString as NSString) {
                        strongSelf.songOfTheDayImage.image = cachedImage
                    } else {
                        strongSelf.songOfTheDayImage.setImage(from: imageURL, withPlaceholder: UIImage(named: "tonedeaflogo"))
                    }
                    strongSelf.blurredBackground(url: imageURL, videoCellView: strongSelf.songMainCardView)
                })
            })
            
            
            strongSelf.getArtistData(song: songYesterday, completion: { artistNames in
                var yimageurl = ""
                GlobalFunctions.shared.selectImageURL(song: songYesterday, completion: { ur in
                    guard let uri = ur else {fatalError()}
                    yimageurl = uri
                    let yimageURL = URL(string: yimageurl)!
                    strongSelf.songOfYesterdayDay.text = String(strongSelf.yparsedDay)
                    strongSelf.songOfYesterdayMonth.text = strongSelf.yparsedMonth
                    strongSelf.songOfYesterdaySongTitile.text = songYesterday.name
                    strongSelf.songOfYesterdayArtist.text = artistNames.joined(separator: ", ")
                    Comparisons.shared.getEarliestReleaseDate(song: songYesterday, completion: { edate in
                        
                        strongSelf.songOfYesterdayReleaseDate.text = "Released: \(edate)"
                    })
                    if let cachedImage = imageCache.object(forKey: yimageURL.absoluteString as NSString) {
                        strongSelf.songOfYesterdayImage.image = cachedImage
                    } else {
                        strongSelf.songOfYesterdayImage.setImage(from: yimageURL, withPlaceholder: UIImage(named: "tonedeaflogo"))
                    }
                    strongSelf.blurredBackground(url: yimageURL, videoCellView: strongSelf.songYesterdayMAinCardView)
                    completion()
                })
            })
            
        }
    }
    
    func loadBeatsData(beatToday:BeatData, beatYesterday:BeatData, completion: @escaping () -> Void) {
        DispatchQueue.main.async { [weak self] in
            guard let strongSelf = self else {return}
            var imageurl = beatToday.imageURL
            let imageURL = URL(string: imageurl)!
            strongSelf.beatOfTheDayDay.text = String(strongSelf.parsedDay)
            strongSelf.beatOfTheDayMonth.text = strongSelf.parsedMonth
            strongSelf.beatOfTheDayBeatTitile.text = beatToday.name
            strongSelf.beatOfTheDayProducers.text = "Tone Deaf"//songToday.prod.joined(separator: ", ")
            strongSelf.beatOfTheDayReleaseDate.text = "Uploaded: \(beatToday.date)"
            if let cachedImage = imageCache.object(forKey: imageURL.absoluteString as NSString) {
                strongSelf.beatOfTheDayImage.image = cachedImage
            } else {
                strongSelf.beatOfTheDayImage.setImage(from: imageURL, withPlaceholder: UIImage(named: "tonedeaflogo"))
            }
            strongSelf.blurredBackground(url: imageURL, videoCellView: strongSelf.beatMainCardView)
            
            var yimageurl = beatYesterday.imageURL
            let yimageURL = URL(string: yimageurl)!
            strongSelf.beatOfYesterdayDay.text = String(strongSelf.yparsedDay)
            strongSelf.beatOfYesterdayMonth.text = strongSelf.yparsedMonth
            strongSelf.beatOfYesterdayBeatTitile.text = beatYesterday.name
            strongSelf.beatOfYesterdayProducers.text = "Tone Deaf"//songToday.prod.joined(separator: ", ")
            strongSelf.beatOfYesterdayReleaseDate.text = "Uploaded: \(beatYesterday.date)"
            if let cachedImage = imageCache.object(forKey: yimageURL.absoluteString as NSString) {
                strongSelf.beatYesterdayImage.image = cachedImage
            } else {
                strongSelf.beatYesterdayImage.setImage(from: yimageURL, withPlaceholder: UIImage(named: "tonedeaflogo"))
            }
            strongSelf.blurredBackground(url: yimageURL, videoCellView: strongSelf.beatYesterdayMainCard)
            
            completion()
        }
    }
    
    func blurredBackground(url: URL, videoCellView: UIView) {
        let backgroundImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: videoCellView.bounds.width, height: videoCellView.bounds.height))
        videoCellView.addSubview(backgroundImageView)
        if let cachedImage = imageCache.object(forKey: url.absoluteString as NSString) {
            backgroundImageView.image = cachedImage
        } else {
            backgroundImageView.setImage(from: url, withPlaceholder: UIImage(named: "tonedeaflogo"))
        }
        videoCellView.sendSubviewToBack(backgroundImageView)
        
        let blur = UIBlurEffect(style: .dark)
        let blurView = UIVisualEffectView(effect: blur)
        videoCellView.layer.cornerRadius = 7
        blurView.layer.cornerRadius = 7
        backgroundImageView.layer.cornerRadius = 7
        blurView.frame = videoCellView.bounds
        videoCellView.addSubview(blurView)
        videoCellView.sendSubviewToBack(blurView)
        videoCellView.sendSubviewToBack(backgroundImageView)
    }
    
    func setBeatDateLabels() {
        DispatchQueue.main.async { [weak self] in
            guard let strongSelf = self else {return}
            strongSelf.beatOfTheDayDay.text = String(strongSelf.parsedDay)
            strongSelf.beatOfTheDayMonth.text = strongSelf.parsedMonth
        }
    }
    
    func getArtistData(song:SongData, completion: @escaping (Array<String>, Array<String>) -> Void) {
        var artistNameData:Array<String> = []
        var artistimageURLs:Array<String> = []
        var val = 1
        for artist in song.songArtist {
            DatabaseManager.shared.fetchPersonData(person: artist, completion: { result in
                switch result {
                case .success(let per):
                    artistNameData.append(per.name)
                    GlobalFunctions.shared.selectImageURL(person: per, completion: { url in
                        if url == nil {
                            artistimageURLs.append(Constants.StorageURLs.appLogo)
                        } else {
                            artistimageURLs.append(url!)
                        }
                        if val == song.songArtist.count {
                            completion(artistNameData, artistimageURLs)
                        }
                        val+=1
                    })
                case .failure(let err):
                    print("lateconterr : " + err.localizedDescription)
                }
            })
        }
        
    }
    
    func getProducerData(song:SongData, completion: @escaping (Array<String>, Array<String>) -> Void) {
        var producerNameData:Array<String> = []
        var producerimageURLs:Array<String> = []
        var val = 1
        for producer in song.songProducers {
            DatabaseManager.shared.fetchPersonData(person: producer, completion: { result in
                switch result {
                case .success(let per):
                    producerNameData.append(per.name)
                    GlobalFunctions.shared.selectImageURL(person: per, completion: { url in
                        if url == nil {
                            producerimageURLs.append(Constants.StorageURLs.appLogo)
                        } else {
                            producerimageURLs.append(url!)
                        }
                        if val == song.songProducers.count {
                            completion(producerNameData, producerimageURLs)
                        }
                        val+=1
                    })
                case .failure(let err):
                    print("lateconterr : " + err.localizedDescription)
                }
            })
        }
        
    }
    
    func getArtistData(album:AlbumData, completion: @escaping (Array<String>, Array<String>) -> Void) {
        var artistNameData:Array<String> = []
        var artistimageURLs:Array<String> = []
        var val = 1
        for artist in album.mainArtist {
            DatabaseManager.shared.fetchPersonData(person: artist, completion: { result in
                switch result {
                case .success(let per):
                    artistNameData.append(per.name)
                    GlobalFunctions.shared.selectImageURL(person: per, completion: { url in
                        if url == nil {
                            artistimageURLs.append(Constants.StorageURLs.appLogo)
                        } else {
                            artistimageURLs.append(url!)
                        }
                        if val == album.mainArtist.count {
                            completion(artistNameData, artistimageURLs)
                        }
                        val+=1
                    })
                case .failure(let err):
                    print("lateconterr : " + err.localizedDescription)
                }
            })
        }
        
    }
    
    func getProducerData(album:AlbumData, completion: @escaping (Array<String>, Array<String>) -> Void) {
        var producerNameData:Array<String> = []
        var producerimageURLs:Array<String> = []
        var val = 1
        for producer in album.producers {
            DatabaseManager.shared.fetchPersonData(person: producer, completion: { result in
                switch result {
                case .success(let per):
                    producerNameData.append(per.name)
                    GlobalFunctions.shared.selectImageURL(person: per, completion: { url in
                        if url == nil {
                            producerimageURLs.append(Constants.StorageURLs.appLogo)
                        } else {
                            producerimageURLs.append(url!)
                        }
                        if val == album.producers.count {
                            completion(producerNameData, producerimageURLs)
                        }
                        val+=1
                    })
                case .failure(let err):
                    print("lateconterr : " + err.localizedDescription)
                }
            })
        }
        
    }
    
    func getArtistDataVideo(video:VideoData, completion: @escaping (Array<String>, Array<String>) -> Void) {
        var artistNameData:Array<String> = []
        var artistimageURLs:Array<String> = []
        if video.persons == nil {
            completion(artistNameData, artistimageURLs)
            return
        }
        var val = 1
        for artist in video.persons! {
            DatabaseManager.shared.fetchPersonData(person: artist, completion: { result in
                switch result {
                case .success(let per):
                    artistNameData.append(per.name)
                    GlobalFunctions.shared.selectImageURL(person: per, completion: { url in
                        artistimageURLs.append(url!)
                        if val == video.persons!.count {
                            completion(artistNameData, artistimageURLs)
                        }
                        val+=1
                    })
                case .failure(let err):
                    print("lateconterr : " + err.localizedDescription)
                }
            })
        }
        
    }
    
    func getProducerDataVideo(video:YouTubeData, completion: @escaping (Array<String>, Array<String>) -> Void) {
        var producerNameData:Array<String> = []
        var producerimageURLs:Array<String> = []
        var val = 1
//        for producer in video.producers {
//            let word = producer.split(separator: "Æ")
//            let id = word[0]
//            DatabaseManager.shared.fetchProducerData(producer: String(id), completion: { selectedProducer in
//                //print(song.songArtist.count)
//                producerNameData.append(selectedProducer.name)
//                producerimageURLs.append(selectedProducer.spotifyProfileImageURL)
//                if val == video.producers.count {
//                    completion(producerNameData, producerimageURLs)
//                }
//                val+=1
//            })
//        }
        
    }
    
    private func setLatestDateArrays(_ content: [AnyObject], _ earliestDate: Date?, _ dateArray: [Date], _ temp: [Any], completion: @escaping (Array<Date>, [Any]) -> Void) {
        var dateArray:Array<Date> = []
        var temp:Array<Any> = []
        var earliestDate = Date()
        var tick = 0
        
        for item in content {
            switch item {
            case is SongData:
                let song = item  as! SongData
                //print(song.name)
                Comparisons.shared.getLatestReleaseDate(song: song, completion: { date in
                    //print(tick, song.name)
                    earliestDate = date
                    dateArray.append(earliestDate)
                    temp.append(song)
                    
                    tick+=1
                    
                    if tick == content.count {
                        //print(dateArray)
                        
                        completion(dateArray, temp)
                    }
                })
            case is VideoData:
                let video = item  as! VideoData
                //print(tick, song.name)
                Comparisons.shared.getLatestReleaseDate(video: video, completion: { date in
                    //print(tick, song.name)
                    earliestDate = date
                    dateArray.append(earliestDate)
                    temp.append(video)
                    
                    tick+=1
                    
                    if tick == content.count {
                        //print(dateArray)
                        
                        completion(dateArray, temp)
                    }
                })
            case is AlbumData:
                let album = item  as! AlbumData
                //print(song.name)
                Comparisons.shared.getLatestReleaseDate(album: album, completion: { date in
                    //print(tick, song.name)
                    earliestDate = date
                    dateArray.append(earliestDate)
                    temp.append(album)
                    
                    tick+=1
                    
                    if tick == content.count {
                        //print(dateArray)
                        
                        completion(dateArray, temp)
                    }
                })
            default:
                print("nun")
            }
        }
    }
    
    fileprivate func sortTempArray(_ content: [AnyObject], _ temparr: [Any],_ datearr:[Date], completion: @escaping (Array<Any>) -> Void) {
        var temp:[Any] = []
        var dateArray:[Date] = []
        var earliestDate:Date!
        var plugArr:[Int] = []
        temp = temparr
        dateArray = datearr
        var tick = 1
        for item in content {
            switch item {
            case is SongData:
                let song = item  as! SongData
                Comparisons.shared.getLatestReleaseDate(song: song, completion: { date in
                    earliestDate = date
                    if earliestDate == datearr[0] && !plugArr.contains(0) {
                        temp.remove(at: 0)
                        temp.insert(song, at: 0)
                        plugArr.append(0)
                        if tick == content.count {
                            completion(temp)
                        }
                        tick+=1
                    }
                    else if earliestDate == datearr[1] && !plugArr.contains(1)  {
                        temp.remove(at:1)
                        temp.insert(song, at: 1)
                        plugArr.append(1)
                        if tick == content.count {
                            completion(temp)
                        }
                        tick+=1
                    }
                    else if earliestDate == datearr[2] && !plugArr.contains(2)  {
                        temp.remove(at: 2)
                        temp.insert(song, at: 2)
                        plugArr.append(2)
                        if tick == content.count {
                            completion(temp)
                        }
                        tick+=1
                    }
                    else if earliestDate == datearr[3] && !plugArr.contains(3) {
                        temp.remove(at: 3)
                        temp.insert(song, at: 3)
                        plugArr.append(3)
                        if tick == content.count {
                            completion(temp)
                        }
                        tick+=1
                    }
                    else if earliestDate == datearr[4] && !plugArr.contains(4) {
                        temp.remove(at: 4)
                        temp.insert(song, at: 4)
                        plugArr.append(4)
                        if tick == content.count {
                            completion(temp)
                        }
                        tick+=1
                    }
                    else if earliestDate == datearr[5] && !plugArr.contains(5) {
                        temp.remove(at: 5)
                        temp.insert(song, at: 5)
                        plugArr.append(5)
                        if tick == content.count {
                            completion(temp)
                        }
                        tick+=1
                    }
                    else
                    if earliestDate == datearr[6] && !plugArr.contains(6) {
                        temp.remove(at: 6)
                        temp.insert(song, at: 6)
                        plugArr.append(6)
                        if tick == content.count {
                            completion(temp)
                        }
                        tick+=1
                    }
                })
                
            case is VideoData:
            let video = item  as! VideoData
                Comparisons.shared.getLatestReleaseDate(video: video, completion: { date in
                    earliestDate = date
                    if earliestDate == datearr[0] && !plugArr.contains(0) {
                        temp.remove(at: 0)
                        temp.insert(video, at: 0)
                        plugArr.append(0)
                        if tick == content.count {
                            completion(temp)
                        }
                        tick+=1
                    }
                    else if earliestDate == datearr[1] && !plugArr.contains(1)  {
                        temp.remove(at:1)
                        temp.insert(video, at: 1)
                        plugArr.append(1)
                        if tick == content.count {
                            completion(temp)
                        }
                        tick+=1
                    }
                    else if earliestDate == datearr[2] && !plugArr.contains(2)  {
                        temp.remove(at: 2)
                        temp.insert(video, at: 2)
                        plugArr.append(2)
                        if tick == content.count {
                            completion(temp)
                        }
                        tick+=1
                    }
                    else if earliestDate == datearr[3] && !plugArr.contains(3) {
                        temp.remove(at: 3)
                        temp.insert(video, at: 3)
                        plugArr.append(3)
                        if tick == content.count {
                            completion(temp)
                        }
                        tick+=1
                    }
                    else if earliestDate == datearr[4] && !plugArr.contains(4) {
                        temp.remove(at: 4)
                        temp.insert(video, at: 4)
                        plugArr.append(4)
                        if tick == content.count {
                            completion(temp)
                        }
                        tick+=1
                    }
                    else if earliestDate == datearr[5] && !plugArr.contains(5) {
                        temp.remove(at: 5)
                        temp.insert(video, at: 5)
                        plugArr.append(5)
                        if tick == content.count {
                            completion(temp)
                        }
                        tick+=1
                    }
                    else
                    if earliestDate == datearr[6] && !plugArr.contains(6) {
                        temp.remove(at: 6)
                        temp.insert(video, at: 6)
                        plugArr.append(6)
                        if tick == content.count {
                            completion(temp)
                        }
                        tick+=1
                    }
                })
            case is AlbumData:
                let album = item  as! AlbumData
                Comparisons.shared.getLatestReleaseDate(album: album, completion: { date in
                    earliestDate = date
                    if earliestDate == datearr[0] && !plugArr.contains(0) {
                        temp.remove(at: 0)
                        temp.insert(album, at: 0)
                        plugArr.append(0)
                        if tick == content.count {
                            completion(temp)
                        }
                        tick+=1
                    }
                    else if earliestDate == datearr[1] && !plugArr.contains(1)  {
                        temp.remove(at:1)
                        temp.insert(album, at: 1)
                        plugArr.append(1)
                        if tick == content.count {
                            completion(temp)
                        }
                        tick+=1
                    }
                    else if earliestDate == datearr[2] && !plugArr.contains(2)  {
                        temp.remove(at: 2)
                        temp.insert(album, at: 2)
                        plugArr.append(2)
                        if tick == content.count {
                            completion(temp)
                        }
                        tick+=1
                    }
                    else if earliestDate == datearr[3] && !plugArr.contains(3) {
                        temp.remove(at: 3)
                        temp.insert(album, at: 3)
                        plugArr.append(3)
                        if tick == content.count {
                            completion(temp)
                        }
                        tick+=1
                    }
                    else if earliestDate == datearr[4] && !plugArr.contains(4) {
                        temp.remove(at: 4)
                        temp.insert(album, at: 4)
                        plugArr.append(4)
                        if tick == content.count {
                            completion(temp)
                        }
                        tick+=1
                    }
                    else if earliestDate == datearr[5] && !plugArr.contains(5) {
                        temp.remove(at: 5)
                        temp.insert(album, at: 5)
                        plugArr.append(5)
                        if tick == content.count {
                            completion(temp)
                        }
                        tick+=1
                    }
                    else
                    if earliestDate == datearr[6] && !plugArr.contains(6) {
                        temp.remove(at: 6)
                        temp.insert(album, at: 6)
                        plugArr.append(6)
                        if tick == content.count {
                            completion(temp)
                        }
                        tick+=1
                    }
                })
            default:
                print("nun")
            }
            
        }
    }
    
    fileprivate func setArraysForLatestContent(_ content: [AnyObject], _ strongSelf: DashboardViewController, completion: @escaping () -> Void) {
        var temp:Array<Any> = []
        var earliestDate:Date!
        var dateArray:Array<Date> = []
        
        setLatestDateArrays(content, earliestDate, dateArray, temp, completion: {[weak self] dates,tempr in
            
            guard let strongSelf = self else {return}
            dateArray = dates
            temp = tempr
            
            dateArray.sort(by: { $0.compare($1) == .orderedDescending })
            //print(dateArray, separator: "\n")
            
            strongSelf.sortTempArray(content, temp, dateArray, completion: { tempo in
                
                temp = tempo
                var curr = 0
                var counter = 0
                for array in temp {
                    curr += 1
                    let icurr = curr
                    if curr == content.count+1 {
                        break
                    }
                    var name:String!
                    var imageurl:String!
                    var releaseDate:String!
                    var previewURL:String = ""
                    var persons:Array<String>!
                    var artists:Array<String>!
                    var producers:Array<String>!
                    var songvideos:[String]!
                    switch array {
                    case is SongData:
                        let song = array as! SongData
                        name = song.name
                        Comparisons.shared.getEarliestReleaseDate(song: song, completion: { edate in
                            //print(edate)
                            //print(curr)
                            releaseDate = edate
                            artists = song.songArtist
                            producers = song.songProducers
                            GlobalFunctions.shared.selectImageURL(song: song, completion: { imgurl in
                                imageurl = imgurl
                                GlobalFunctions.shared.selectPreviewURL(song: song, completion: { prevurl in
                                    previewURL = prevurl ?? ""
                                    songvideos = song.videos
                                    guard let producers = producers else {return}
                                    guard let artists = artists else {return}
                                    guard let name = name else {return}
                                    guard let imageurl = imageurl else {return}
                                    guard let releaseDate = releaseDate else {return}
                                    guard let songvideos = songvideos else {return}
                                    strongSelf.getArtistData(song: song, completion: { artistNames,artistImageURLs  in
                                        
                                        //print(artistNames)
                                        strongSelf.getProducerData(song: song, completion: { producerNames,producerImageURLs  in
                                            print(producerNames, song.name)
                                            do {
                                                if let url = URL.init(string: imageurl) {
                                                    switch icurr {
                                                    case 1:
                                                        dashboardLatestContentArray1.append(name)
                                                        dashboardLatestContentArray1.append(imageurl)
                                                        dashboardLatestContentArray1.append(releaseDate)
                                                        dashboardLatestContentArray1.append(previewURL)
                                                        dashboardLatestContentArray1.append(artistNames)
                                                        dashboardLatestContentArray1.append(imageurl)
                                                        dashboardLatestContentArray1.append(artistImageURLs)
                                                        dashboardLatestContentArray1.append(artists)
                                                        dashboardLatestContentArray1.append(producerNames)
                                                        dashboardLatestContentArray1.append(producerImageURLs)
                                                        dashboardLatestContentArray1.append(producers)
                                                        dashboardLatestContentArray1.append(songvideos)
                                                        dashboardLatestContentArray1.append(song)
                                                        dashboardLatestContentArrayViews.insert(AnyView(FeaturedMusicViewContent(array: dashboardLatestContentArray1, view: "LATEST")), at: 0)
                                                        counter+=1
                                                        if counter == content.count {
                                                            strongSelf.setupHC()
                                                            completion()
                                                        }
                                                    case 2:
                                                        dashboardLatestContentArray2.append(name)
                                                        dashboardLatestContentArray2.append(imageurl)
                                                        dashboardLatestContentArray2.append(releaseDate)
                                                        dashboardLatestContentArray2.append(previewURL)
                                                        dashboardLatestContentArray2.append(artistNames)
                                                        dashboardLatestContentArray2.append(imageurl)
                                                        dashboardLatestContentArray2.append(artistImageURLs)
                                                        dashboardLatestContentArray2.append(artists)
                                                        dashboardLatestContentArray2.append(producerNames)
                                                        dashboardLatestContentArray2.append(producerImageURLs)
                                                        dashboardLatestContentArray2.append(producers)
                                                        dashboardLatestContentArray2.append(songvideos)
                                                        dashboardLatestContentArray2.append(song)
                                                        dashboardLatestContentArrayViews.insert(AnyView(FeaturedMusicViewContent(array: dashboardLatestContentArray2, view: "LATEST")), at: 1)
                                                        counter+=1
                                                        if counter == content.count {
                                                            strongSelf.setupHC()
                                                            completion()
                                                        }
                                                    case 3:
                                                        dashboardLatestContentArray3.append(name )
                                                        dashboardLatestContentArray3.append(imageurl)
                                                        dashboardLatestContentArray3.append(releaseDate)
                                                        dashboardLatestContentArray3.append(previewURL)
                                                        dashboardLatestContentArray3.append(artistNames)
                                                        dashboardLatestContentArray3.append(imageurl)
                                                        dashboardLatestContentArray3.append(artistImageURLs)
                                                        dashboardLatestContentArray3.append(artists)
                                                        dashboardLatestContentArray3.append(producerNames)
                                                        dashboardLatestContentArray3.append(producerImageURLs)
                                                        dashboardLatestContentArray3.append(producers)
                                                        dashboardLatestContentArray3.append(songvideos)
                                                        dashboardLatestContentArray3.append(song)
                                                        dashboardLatestContentArrayViews.insert(AnyView(FeaturedMusicViewContent(array: dashboardLatestContentArray3, view: "LATEST")), at: 2)
                                                        counter+=1
                                                        if counter == content.count {
                                                            strongSelf.setupHC()
                                                            completion()
                                                        }
                                                    case 4:
                                                        dashboardLatestContentArray4.append(name )
                                                        dashboardLatestContentArray4.append(imageurl)
                                                        dashboardLatestContentArray4.append(releaseDate)
                                                        dashboardLatestContentArray4.append(previewURL)
                                                        dashboardLatestContentArray4.append(artistNames)
                                                        dashboardLatestContentArray4.append(imageurl)
                                                        dashboardLatestContentArray4.append(artistImageURLs)
                                                        dashboardLatestContentArray4.append(artists)
                                                        dashboardLatestContentArray4.append(producerNames)
                                                        dashboardLatestContentArray4.append(producerImageURLs)
                                                        dashboardLatestContentArray4.append(producers)
                                                        dashboardLatestContentArray4.append(songvideos)
                                                        dashboardLatestContentArray4.append(song)
                                                        dashboardLatestContentArrayViews.insert(AnyView(FeaturedMusicViewContent(array: dashboardLatestContentArray4, view: "LATEST")), at: 3)
                                                        counter+=1
                                                        if counter == content.count {
                                                            strongSelf.setupHC()
                                                            completion()
                                                        }
                                                    case 5:
                                                        dashboardLatestContentArray5.append(name )
                                                        dashboardLatestContentArray5.append(imageurl)
                                                        dashboardLatestContentArray5.append(releaseDate)
                                                        dashboardLatestContentArray5.append(previewURL)
                                                        dashboardLatestContentArray5.append(artistNames)
                                                        dashboardLatestContentArray5.append(imageurl)
                                                        dashboardLatestContentArray5.append(artistImageURLs)
                                                        dashboardLatestContentArray5.append(artists)
                                                        dashboardLatestContentArray5.append(producerNames)
                                                        dashboardLatestContentArray5.append(producerImageURLs)
                                                        dashboardLatestContentArray5.append(producers)
                                                        dashboardLatestContentArray5.append(songvideos)
                                                        dashboardLatestContentArray5.append(song)
                                                        dashboardLatestContentArrayViews.insert(AnyView(FeaturedMusicViewContent(array: dashboardLatestContentArray5, view: "LATEST")), at: 4)
                                                        counter+=1
                                                        if counter == content.count {
                                                            strongSelf.setupHC()
                                                            completion()
                                                        }
                                                    case 6:
                                                        dashboardLatestContentArray6.append(name )
                                                        dashboardLatestContentArray6.append(imageurl)
                                                        dashboardLatestContentArray6.append(releaseDate)
                                                        dashboardLatestContentArray6.append(previewURL)
                                                        dashboardLatestContentArray6.append(artistNames)
                                                        dashboardLatestContentArray6.append(imageurl)
                                                        dashboardLatestContentArray6.append(artistImageURLs)
                                                        dashboardLatestContentArray6.append(artists)
                                                        dashboardLatestContentArray6.append(producerNames)
                                                        dashboardLatestContentArray6.append(producerImageURLs)
                                                        dashboardLatestContentArray6.append(producers)
                                                        dashboardLatestContentArray6.append(songvideos)
                                                        dashboardLatestContentArray6.append(song)
                                                        dashboardLatestContentArrayViews.insert(AnyView(FeaturedMusicViewContent(array: dashboardLatestContentArray6, view: "LATEST")), at: 5)
                                                        counter+=1
                                                        if counter == content.count {
                                                            strongSelf.setupHC()
                                                            completion()
                                                        }
                                                    case 7:
                                                        
                                                        dashboardLatestContentArray7.append(name )
                                                        dashboardLatestContentArray7.append(imageurl)
                                                        dashboardLatestContentArray7.append(releaseDate)
                                                        dashboardLatestContentArray7.append(previewURL)
                                                        dashboardLatestContentArray7.append(artistNames)
                                                        dashboardLatestContentArray7.append(imageurl)
                                                        dashboardLatestContentArray7.append(artistImageURLs)
                                                        dashboardLatestContentArray7.append(artists)
                                                        dashboardLatestContentArray7.append(producerNames)
                                                        dashboardLatestContentArray7.append(producerImageURLs)
                                                        dashboardLatestContentArray7.append(producers)
                                                        dashboardLatestContentArray7.append(songvideos)
                                                        dashboardLatestContentArray7.append(song)
                                                        dashboardLatestContentArrayViews.insert(AnyView(FeaturedMusicViewContent(array: dashboardLatestContentArray7, view: "LATEST")), at: 6)
                                                        counter+=1
                                                        if counter == content.count {
                                                            strongSelf.setupHC()
                                                            completion()
                                                        }
                                                    default:
                                                        print("Error")
                                                    }
                                                    curr+=1
                                                }
                                                
                                            } catch {
                                                print("catch erroe \(error)")
                                            }
                                        })
                                        
                                    })
                                })
                                
                            })
                        })
                    case is VideoData:
                        let video = array as! VideoData
                        Comparisons.shared.getEarliestReleaseDate(video: video, completion: { edate in
                            //print(edate)
                            //print(curr)
                            releaseDate = edate
                            var songart:[String] = []
                            if video.persons != nil {
                                for art in video.persons! {
                                    let word = art.split(separator: "Æ")
                                    let id = word[0]
                                    songart.append(String(id))
                                }
                            }
                            name = video.title
                            previewURL = ""
                            persons = songart
                            GlobalFunctions.shared.selectImageURL(video: video, completion: { vidthumb in
                                imageurl = vidthumb
                                guard let persons = persons else {return}
                                guard let name = name else {return}
                                guard let imageurl = imageurl else {return}
                                guard let releaseDate = releaseDate else {return}
                                strongSelf.getArtistDataVideo(video: video, completion: { artistNames,artistImageURLs  in
                                        if let url = URL.init(string: imageurl) {
                                            switch icurr {
                                            case 1:
                                                dashboardLatestContentArray1.append(name)
                                                dashboardLatestContentArray1.append(imageurl)
                                                dashboardLatestContentArray1.append(releaseDate)
                                                dashboardLatestContentArray1.append(previewURL)
                                                dashboardLatestContentArray1.append(artistNames)
                                                dashboardLatestContentArray1.append(imageurl)
                                                dashboardLatestContentArray1.append(artistImageURLs)
                                                dashboardLatestContentArray1.append(persons)
                                                dashboardLatestContentArray1.append([])
                                                dashboardLatestContentArray1.append([])
                                                dashboardLatestContentArray1.append([])
                                                dashboardLatestContentArray1.append(video)
                                                dashboardLatestContentArray1.append(video)
                                                dashboardLatestContentArrayViews.insert(AnyView(FeaturedMusicViewContent(array: dashboardLatestContentArray1, view: "LATEST")), at: 0)
                                                counter+=1
                                                if counter == content.count {
                                                    strongSelf.setupHC()
                                                    completion()
                                                }
                                            case 2:
                                                dashboardLatestContentArray2.append(name)
                                                dashboardLatestContentArray2.append(imageurl)
                                                dashboardLatestContentArray2.append(releaseDate)
                                                dashboardLatestContentArray2.append(previewURL)
                                                dashboardLatestContentArray2.append(artistNames)
                                                dashboardLatestContentArray2.append(imageurl)
                                                dashboardLatestContentArray2.append(artistImageURLs)
                                                dashboardLatestContentArray2.append(persons)
                                                dashboardLatestContentArray2.append([])
                                                dashboardLatestContentArray2.append([])
                                                dashboardLatestContentArray2.append([])
                                                dashboardLatestContentArray2.append(video)
                                                dashboardLatestContentArray2.append(video)
                                                dashboardLatestContentArrayViews.insert(AnyView(FeaturedMusicViewContent(array: dashboardLatestContentArray2, view: "LATEST")), at: 1)
                                                counter+=1
                                                if counter == content.count {
                                                    strongSelf.setupHC()
                                                    completion()
                                                }
                                            case 3:
                                                dashboardLatestContentArray3.append(name )
                                                dashboardLatestContentArray3.append(imageurl)
                                                dashboardLatestContentArray3.append(releaseDate)
                                                dashboardLatestContentArray3.append(previewURL)
                                                dashboardLatestContentArray3.append(artistNames)
                                                dashboardLatestContentArray3.append(imageurl)
                                                dashboardLatestContentArray3.append(artistImageURLs)
                                                dashboardLatestContentArray3.append(persons)
                                                dashboardLatestContentArray3.append([])
                                                dashboardLatestContentArray3.append([])
                                                dashboardLatestContentArray3.append([])
                                                dashboardLatestContentArray3.append(video)
                                                dashboardLatestContentArray3.append(video)
                                                dashboardLatestContentArrayViews.insert(AnyView(FeaturedMusicViewContent(array: dashboardLatestContentArray3, view: "LATEST")), at: 2)
                                                counter+=1
                                                if counter == content.count {
                                                    strongSelf.setupHC()
                                                    completion()
                                                }
                                            case 4:
                                                dashboardLatestContentArray4.append(name)
                                                dashboardLatestContentArray4.append(imageurl)
                                                dashboardLatestContentArray4.append(releaseDate)
                                                dashboardLatestContentArray4.append(previewURL)
                                                dashboardLatestContentArray4.append(artistNames)
                                                dashboardLatestContentArray4.append(imageurl)
                                                dashboardLatestContentArray4.append(artistImageURLs)
                                                dashboardLatestContentArray4.append(persons)
                                                dashboardLatestContentArray4.append([])
                                                dashboardLatestContentArray4.append([])
                                                dashboardLatestContentArray4.append([])
                                                dashboardLatestContentArray4.append(video)
                                                dashboardLatestContentArray4.append(video)
                                                dashboardLatestContentArrayViews.insert(AnyView(FeaturedMusicViewContent(array: dashboardLatestContentArray4, view: "LATEST")), at: 3)
                                                counter+=1
                                                if counter == content.count {
                                                    strongSelf.setupHC()
                                                    completion()
                                                }
                                            case 5:
                                                dashboardLatestContentArray5.append(name )
                                                dashboardLatestContentArray5.append(imageurl)
                                                dashboardLatestContentArray5.append(releaseDate)
                                                dashboardLatestContentArray5.append(previewURL)
                                                dashboardLatestContentArray5.append(artistNames)
                                                dashboardLatestContentArray5.append(imageurl)
                                                dashboardLatestContentArray5.append(artistImageURLs)
                                                dashboardLatestContentArray5.append(persons)
                                                dashboardLatestContentArray5.append([])
                                                dashboardLatestContentArray5.append([])
                                                dashboardLatestContentArray5.append([])
                                                dashboardLatestContentArray5.append(video)
                                                dashboardLatestContentArray5.append(video)
                                                dashboardLatestContentArrayViews.insert(AnyView(FeaturedMusicViewContent(array: dashboardLatestContentArray5, view: "LATEST")), at: 4)
                                                counter+=1
                                                if counter == content.count {
                                                    strongSelf.setupHC()
                                                    completion()
                                                }
                                            case 6:
                                                dashboardLatestContentArray6.append(name )
                                                dashboardLatestContentArray6.append(imageurl)
                                                dashboardLatestContentArray6.append(releaseDate)
                                                dashboardLatestContentArray6.append(previewURL)
                                                dashboardLatestContentArray6.append(artistNames)
                                                dashboardLatestContentArray6.append(imageurl)
                                                dashboardLatestContentArray6.append(artistImageURLs)
                                                dashboardLatestContentArray6.append(persons)
                                                dashboardLatestContentArray6.append([])
                                                dashboardLatestContentArray6.append([])
                                                dashboardLatestContentArray6.append([])
                                                dashboardLatestContentArray6.append(video)
                                                dashboardLatestContentArray6.append(video)
                                                dashboardLatestContentArrayViews.insert(AnyView(FeaturedMusicViewContent(array: dashboardLatestContentArray6, view: "LATEST")), at: 5)
                                                counter+=1
                                                if counter == content.count {
                                                    strongSelf.setupHC()
                                                    completion()
                                                }
                                            case 7:
                                                dashboardLatestContentArray7.append(name )
                                                dashboardLatestContentArray7.append(imageurl)
                                                dashboardLatestContentArray7.append(releaseDate)
                                                dashboardLatestContentArray7.append(previewURL)
                                                dashboardLatestContentArray7.append(artistNames)
                                                dashboardLatestContentArray7.append(imageurl)
                                                dashboardLatestContentArray7.append(artistImageURLs)
                                                dashboardLatestContentArray7.append(persons)
                                                dashboardLatestContentArray7.append([])
                                                dashboardLatestContentArray7.append([])
                                                dashboardLatestContentArray7.append([])
                                                dashboardLatestContentArray7.append(video)
                                                dashboardLatestContentArray7.append(video)
                                                dashboardLatestContentArrayViews.insert(AnyView(FeaturedMusicViewContent(array: dashboardLatestContentArray7, view: "LATEST")), at: 6)
                                                counter+=1
                                                if counter == content.count {
                                                    strongSelf.setupHC()
                                                    completion()
                                                }
                                            default:
                                                print("Error")
                                                //fatalError()
                                            }
                                        }
                                })
                            })
                        })
                    case is AlbumData:
                        let album = array as! AlbumData
                        name = album.name
                        Comparisons.shared.getEarliestReleaseDate(album: album, completion: { edate in
                            //print(edate)
                            //print(curr)
                            releaseDate = edate
                            artists = album.mainArtist
                            producers = album.producers
                            GlobalFunctions.shared.selectImageURL(album: album, completion: { imgurl in
                                imageurl = imgurl
                                GlobalFunctions.shared.selectPreviewURL(album: album, completion: { prevurl in
                                    previewURL = prevurl ?? ""
                                    songvideos = album.videos
                                    guard let producers = producers else {return}
                                    guard let artists = artists else {return}
                                    guard let name = name else {return}
                                    guard let imageurl = imageurl else {return}
                                    guard let releaseDate = releaseDate else {return}
                                    if songvideos == nil {
                                        songvideos = []
                                    }
                                    strongSelf.getArtistData(album: album, completion: { artistNames,artistImageURLs  in
                                        strongSelf.getProducerData(album: album, completion: { producerNames,producerImageURLs  in
                                            do {
                                                if let url = URL.init(string: imageurl) {
                                                    switch icurr {
                                                    case 1:
                                                        dashboardLatestContentArray1.append(name)
                                                        dashboardLatestContentArray1.append(imageurl)
                                                        dashboardLatestContentArray1.append(releaseDate)
                                                        dashboardLatestContentArray1.append(previewURL)
                                                        dashboardLatestContentArray1.append(artistNames)
                                                        dashboardLatestContentArray1.append(imageurl)
                                                        dashboardLatestContentArray1.append(artistImageURLs)
                                                        dashboardLatestContentArray1.append(artists)
                                                        dashboardLatestContentArray1.append(producerNames)
                                                        dashboardLatestContentArray1.append(producerImageURLs)
                                                        dashboardLatestContentArray1.append(producers)
                                                        dashboardLatestContentArray1.append(songvideos)
                                                        dashboardLatestContentArray1.append(album)
                                                        dashboardLatestContentArrayViews.insert(AnyView(FeaturedMusicViewContent(array: dashboardLatestContentArray1, view: "LATEST")), at: 0)
                                                        counter+=1
                                                        if counter == content.count {
                                                            strongSelf.setupHC()
                                                            completion()
                                                        }
                                                    case 2:
                                                        dashboardLatestContentArray2.append(name)
                                                        dashboardLatestContentArray2.append(imageurl)
                                                        dashboardLatestContentArray2.append(releaseDate)
                                                        dashboardLatestContentArray2.append(previewURL)
                                                        dashboardLatestContentArray2.append(artistNames)
                                                        dashboardLatestContentArray2.append(imageurl)
                                                        dashboardLatestContentArray2.append(artistImageURLs)
                                                        dashboardLatestContentArray2.append(artists)
                                                        dashboardLatestContentArray2.append(producerNames)
                                                        dashboardLatestContentArray2.append(producerImageURLs)
                                                        dashboardLatestContentArray2.append(producers)
                                                        dashboardLatestContentArray2.append(songvideos)
                                                        dashboardLatestContentArray2.append(album)
                                                        dashboardLatestContentArrayViews.insert(AnyView(FeaturedMusicViewContent(array: dashboardLatestContentArray2, view: "LATEST")), at: 1)
                                                        counter+=1
                                                        if counter == content.count {
                                                            strongSelf.setupHC()
                                                            completion()
                                                        }
                                                    case 3:
                                                        dashboardLatestContentArray3.append(name )
                                                        dashboardLatestContentArray3.append(imageurl)
                                                        dashboardLatestContentArray3.append(releaseDate)
                                                        dashboardLatestContentArray3.append(previewURL)
                                                        dashboardLatestContentArray3.append(artistNames)
                                                        dashboardLatestContentArray3.append(imageurl)
                                                        dashboardLatestContentArray3.append(artistImageURLs)
                                                        dashboardLatestContentArray3.append(artists)
                                                        dashboardLatestContentArray3.append(producerNames)
                                                        dashboardLatestContentArray3.append(producerImageURLs)
                                                        dashboardLatestContentArray3.append(producers)
                                                        dashboardLatestContentArray3.append(songvideos)
                                                        dashboardLatestContentArray3.append(album)
                                                        dashboardLatestContentArrayViews.insert(AnyView(FeaturedMusicViewContent(array: dashboardLatestContentArray3, view: "LATEST")), at: 2)
                                                        counter+=1
                                                        if counter == content.count {
                                                            strongSelf.setupHC()
                                                            completion()
                                                        }
                                                    case 4:
                                                        dashboardLatestContentArray4.append(name )
                                                        dashboardLatestContentArray4.append(imageurl)
                                                        dashboardLatestContentArray4.append(releaseDate)
                                                        dashboardLatestContentArray4.append(previewURL)
                                                        dashboardLatestContentArray4.append(artistNames)
                                                        dashboardLatestContentArray4.append(imageurl)
                                                        dashboardLatestContentArray4.append(artistImageURLs)
                                                        dashboardLatestContentArray4.append(artists)
                                                        dashboardLatestContentArray4.append(producerNames)
                                                        dashboardLatestContentArray4.append(producerImageURLs)
                                                        dashboardLatestContentArray4.append(producers)
                                                        dashboardLatestContentArray4.append(songvideos)
                                                        dashboardLatestContentArray4.append(album)
                                                        dashboardLatestContentArrayViews.insert(AnyView(FeaturedMusicViewContent(array: dashboardLatestContentArray4, view: "LATEST")), at: 3)
                                                        counter+=1
                                                        if counter == content.count {
                                                            strongSelf.setupHC()
                                                            completion()
                                                        }
                                                    case 5:
                                                        dashboardLatestContentArray5.append(name )
                                                        dashboardLatestContentArray5.append(imageurl)
                                                        dashboardLatestContentArray5.append(releaseDate)
                                                        dashboardLatestContentArray5.append(previewURL)
                                                        dashboardLatestContentArray5.append(artistNames)
                                                        dashboardLatestContentArray5.append(imageurl)
                                                        dashboardLatestContentArray5.append(artistImageURLs)
                                                        dashboardLatestContentArray5.append(artists)
                                                        dashboardLatestContentArray5.append(producerNames)
                                                        dashboardLatestContentArray5.append(producerImageURLs)
                                                        dashboardLatestContentArray5.append(producers)
                                                        dashboardLatestContentArray5.append(songvideos)
                                                        dashboardLatestContentArray5.append(album)
                                                        dashboardLatestContentArrayViews.insert(AnyView(FeaturedMusicViewContent(array: dashboardLatestContentArray5, view: "LATEST")), at: 4)
                                                        counter+=1
                                                        if counter == content.count {
                                                            strongSelf.setupHC()
                                                            completion()
                                                        }
                                                    case 6:
                                                        dashboardLatestContentArray6.append(name )
                                                        dashboardLatestContentArray6.append(imageurl)
                                                        dashboardLatestContentArray6.append(releaseDate)
                                                        dashboardLatestContentArray6.append(previewURL)
                                                        dashboardLatestContentArray6.append(artistNames)
                                                        dashboardLatestContentArray6.append(imageurl)
                                                        dashboardLatestContentArray6.append(artistImageURLs)
                                                        dashboardLatestContentArray6.append(artists)
                                                        dashboardLatestContentArray6.append(producerNames)
                                                        dashboardLatestContentArray6.append(producerImageURLs)
                                                        dashboardLatestContentArray6.append(producers)
                                                        dashboardLatestContentArray6.append(songvideos)
                                                        dashboardLatestContentArray6.append(album)
                                                        dashboardLatestContentArrayViews.insert(AnyView(FeaturedMusicViewContent(array: dashboardLatestContentArray6, view: "LATEST")), at: 5)
                                                        counter+=1
                                                        if counter == content.count {
                                                            strongSelf.setupHC()
                                                            completion()
                                                        }
                                                    case 7:
                                                        
                                                        dashboardLatestContentArray7.append(name )
                                                        dashboardLatestContentArray7.append(imageurl)
                                                        dashboardLatestContentArray7.append(releaseDate)
                                                        dashboardLatestContentArray7.append(previewURL)
                                                        dashboardLatestContentArray7.append(artistNames)
                                                        dashboardLatestContentArray7.append(imageurl)
                                                        dashboardLatestContentArray7.append(artistImageURLs)
                                                        dashboardLatestContentArray7.append(artists)
                                                        dashboardLatestContentArray7.append(producerNames)
                                                        dashboardLatestContentArray7.append(producerImageURLs)
                                                        dashboardLatestContentArray7.append(producers)
                                                        dashboardLatestContentArray7.append(songvideos)
                                                        dashboardLatestContentArray7.append(album)
                                                        dashboardLatestContentArrayViews.insert(AnyView(FeaturedMusicViewContent(array: dashboardLatestContentArray7, view: "LATEST")), at: 6)
                                                        counter+=1
                                                        if counter == content.count {
                                                            strongSelf.setupHC()
                                                            completion()
                                                        }
                                                    default:
                                                        print("Error")
                                                    }
                                                    curr+=1
                                                }
                                                
                                            } catch {
                                                print("catch erroe \(error)")
                                            }
                                        })
                                        
                                    })
                                })
                                
                            })
                        })
                    default:
                        print("erroe")
                    }
                }
            })
        })
    }
    
    func fetchLatestContent(completion: @escaping () -> Void) {
        DispatchQueue.global(qos: .userInitiated).async {
            DatabaseManager.shared.getDashboardLatestContent(completion: { [weak self] content in
                guard let strongSelf = self else {return}
                
                strongSelf.setArraysForLatestContent(content, strongSelf, completion: {
                    
                    completion()
                })
                //print(dashboardLatestContentArray1)
            })
        }
    }
    
    func fetchLatestBeats(completion: @escaping () -> Void) {
        latestBeatsArray = []
        DispatchQueue.global(qos: .userInitiated).async {
            if currentAppUser != nil, currentAppUser.accountType == CreatorAccount {
                DatabaseManager.shared.getLatestBeats(completion: { [weak self] content in
                    guard let strongSelf = self else {return}
                    
                    var dateArray:[LatestBeatData] = []
                    for beat in content {
                        let predate = beat.date
                        guard predate != "" else {return}
                        let pretime = beat.time
                        guard pretime != "" else {return}
                        let predatetime = "\(predate) \(pretime)".replacingOccurrences(of: " AM", with: "").replacingOccurrences(of: " PM", with: "")
                        let datetime = predatetime.date(format: "MM dd, yyyy HH:mm:ss")!
                        let curr = LatestBeatData(date: datetime, beat: beat)
                        dateArray.append(curr)
                    }
                    dateArray.sort(by: {$0.date > $1.date})
                    for beat in dateArray {
                        strongSelf.latestBeatsArray.append(beat.beat)
                    }
                    var paidnum = 0
                    var freenum = 0
                    for beat in strongSelf.latestBeatsArray {
                        print("sdvbf\(beat.name)")
                        if beat.priceType == "Free" {
                            freenum+=1
                        } else {
                            paidnum+=1
                        }
                    }
                    let theight = CGFloat((paidnum*150)+(freenum*130))
                    if strongSelf.latestBeatsArray.count < 5 {
                            strongSelf.latestBeatsTableHeight.constant = theight
                            strongSelf.view.layoutSubviews()
                            strongSelf.view.layoutIfNeeded()
                    } else {
                            strongSelf.latestBeatsTableHeight.constant = theight
                            strongSelf.view.layoutSubviews()
                            strongSelf.view.layoutIfNeeded()
                    }
                    
                    strongSelf.hideskeleton(tableview: strongSelf.latestBeatsTableView)
                    completion()
                })
            } else {
                DatabaseManager.shared.getLatestFreeBeats(completion: { [weak self] content in
                    guard let strongSelf = self else {return}
                    
                    var dateArray:[LatestBeatData] = []
                    for beat in content {
                        let predate = beat.date
                        guard predate != "" else {return}
                        let pretime = beat.time
                        guard pretime != "" else {return}
                        let predatetime = "\(predate) \(pretime)".replacingOccurrences(of: " AM", with: "").replacingOccurrences(of: " PM", with: "")
                        let datetime = predatetime.date(format: "MM dd, yyyy HH:mm:ss")!
                        let curr = LatestBeatData(date: datetime, beat: beat)
                        dateArray.append(curr)
                    }
                    dateArray.sort(by: {$0.date > $1.date})
                    for beat in dateArray {
                        strongSelf.latestBeatsArray.append(beat.beat)
                    }
                    if strongSelf.latestBeatsArray.count < 5 {
                        if accountType == "Listener" {
                            strongSelf.latestBeatsTableHeight.constant = CGFloat(strongSelf.latestBeatsArray.count)*120
                            strongSelf.view.layoutSubviews()
                            strongSelf.view.layoutIfNeeded()
                        } else {
                            strongSelf.latestBeatsTableHeight.constant = CGFloat(strongSelf.latestBeatsArray.count)*80
                            strongSelf.view.layoutSubviews()
                            strongSelf.view.layoutIfNeeded()
                        }
                    } else {
                        if accountType == "Listener" {
                            strongSelf.latestBeatsTableHeight.constant = 600
                            strongSelf.view.layoutSubviews()
                            strongSelf.view.layoutIfNeeded()
                        } else {
                            strongSelf.latestBeatsTableHeight.constant = 400
                            strongSelf.view.layoutSubviews()
                            strongSelf.view.layoutIfNeeded()
                        }
                    }
                    
                    strongSelf.hideskeleton(tableview: strongSelf.latestBeatsTableView)
                    completion()
                })
            }
        }
    }
    
    func hideskeleton(tableview: UITableView) {
        skelvar+=1
        DispatchQueue.main.async {
            print("Hiding skeleton")
            tableview.stopSkeletonAnimation()
            tableview.hideSkeleton(reloadDataAfter: true, transition: .crossDissolve(0.25))
            tableview.reloadData()
        }
    }
    
    func setupHC() {
        let host = UIHostingController(rootView: LatestView())
        host.view.frame = .init(x: 0, y: 60 , width: self.view.bounds.width, height: 375)
        host.view.backgroundColor = .clear
        addChild(host)
        latestContentView.addSubview(host.view)
        host.didMove(toParent: self)
        latestContentSkeleton.stopSkeletonAnimation()
        latestContentSkeleton.hideSkeleton(reloadDataAfter: false, transition: .crossDissolve(0.25))
    }
    
    
    func setHighlightedVideo() {
        let hcons = highlightedVideoView.heightAnchor.constraint(equalToConstant: view.frame.size.width*0.5625)
        hcons.isActive = true
        print("Sizeof ", highlightedVideoView.frame.size.height)
        view.layoutSubviews()
        
        DatabaseManager.shared.getHighlightVideoURL(completion: { [weak self] url in
            guard let strongSelf = self else {return}
            strongSelf.player = AVPlayer(url: url)
            strongSelf.avpController.player = strongSelf.player
            strongSelf.avpController.view.frame.size.height = strongSelf.highlightedVideoView.frame.size.height
            strongSelf.avpController.view.frame.size.width = strongSelf.highlightedVideoView.frame.size.width
            strongSelf.highlightedVideoView.addSubview(strongSelf.avpController.view)
            do {
                try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: [])
            }
            catch {
                print("Setting category to AVAudioSessionCategoryPlayback failed.")
            }
            strongSelf.player.isMuted = true
            strongSelf.player.play()
        })
        
    }
    
    @objc func playerItemDidReachEnd(notification: Notification) {
        if let playerItem = notification.object as? AVPlayerItem {
            playerItem.seek(to: CMTime.zero, completionHandler: nil)
            player.play()
        }
    }
    
    func setFavsArray(completion: @escaping () -> Void) {
        dashFavoritesArray = []
        var tick = 0
        if currentAppUser.favorites.count == 0 || currentAppUser.favorites == nil || currentAppUser.favorites.isEmpty {
            
        } else {
            for fav in currentAppUser.favorites {
                let word = fav.dbid.split(separator: "Æ")
                let id = word[0]
                switch String(id).count {
                case 14:
                    getBeat(id: String(id), completion: {[weak self] beat in
                        guard let strongSelf = self  else {return}
                        strongSelf.dashFavoritesArray.append(beat)
                        tick+=1
                        if tick == currentAppUser.favorites.count || tick == 15 {
                            strongSelf.setupFavoritesCollectionView(completion: {
                                strongSelf.view.layoutSubviews()
                                completion()
                                return
                            })
                        }
                    })
                case 12:
                    getInstrumental(id: String(id), completion: {[weak self] instrumental in
                        guard let strongSelf = self  else {return}
                        strongSelf.dashFavoritesArray.append(instrumental)
                        tick+=1
                        if tick == currentAppUser.favorites.count || tick == 15 {
                            strongSelf.setupFavoritesCollectionView(completion: {
                                strongSelf.view.layoutSubviews()
                                completion()
                                return
                            })
                        }
                    })
                case 10:
                    getSong(id: String(id), completion: {[weak self] song in
                        guard let strongSelf = self  else {return}
                        strongSelf.dashFavoritesArray.append(song)
                        tick+=1
                        if tick == currentAppUser.favorites.count || tick == 15 {
                            strongSelf.setupFavoritesCollectionView(completion: {
                                strongSelf.view.layoutSubviews()
                                completion()
                                return
                            })
                        }
                    })
                case 9:
                    getVideo(id: String(id), completion: {[weak self] video in
                        guard let strongSelf = self  else {return}
                        strongSelf.dashFavoritesArray.append(video)
                        tick+=1
                        if tick == currentAppUser.favorites.count || tick == 15 {
                            strongSelf.setupFavoritesCollectionView(completion: {
                                strongSelf.view.layoutSubviews()
                                completion()
                                return
                            })
                        }
                    })
                case 8:
                    getAlbum(id: String(id), completion: {[weak self] album in
                        guard let strongSelf = self  else {return}
                        strongSelf.dashFavoritesArray.append(album)
                        tick+=1
                        if tick == currentAppUser.favorites.count || tick == 15 {
                            strongSelf.setupFavoritesCollectionView(completion: {
                                strongSelf.view.layoutSubviews()
                                completion()
                                return
                            })
                        }
                    })
                default:
                    print("jhgfc")
                }
            }
        }
    }
    
    private func setupFavoritesCollectionView(completion: @escaping () -> Void) {
        DispatchQueue.main.async {[weak self] in
            guard let strongSelf = self else {return}
            strongSelf.favoritesCollectionView = UICollectionView(
                frame: strongSelf.favoritesView.frame,
                collectionViewLayout: CollectionViewPagingLayout()
            )
            let layout = CollectionViewPagingLayout()
            strongSelf.favoritesCollectionView.collectionViewLayout = layout
            layout.delegate = self
            strongSelf.favoritesCollectionView.showsHorizontalScrollIndicator = false
            strongSelf.favoritesCollectionView.isPagingEnabled = true
            strongSelf.favoritesCollectionView.backgroundColor = .clear
            strongSelf.favoritesCollectionView.register(UserFavoritesCollectionViewCell.self, forCellWithReuseIdentifier: "userFavoritesCollectionViewCell")
            strongSelf.favoritesCollectionView.dataSource = self
            strongSelf.favoritesView.addSubview(strongSelf.favoritesCollectionView)
            strongSelf.favoritesCollectionView.delaysContentTouches = false
            let dou = Double(strongSelf.dashFavoritesArray.count/2)
            let intt = Int(dou.rounded(.toNearestOrAwayFromZero))
            layout.setCurrentPage(intt)
            layout.configureTapOnCollectionView(goToSelectedPage: true)
            strongSelf.favoritesCollectionView.reloadSections(IndexSet(integer: 0))
            strongSelf.view.layoutSubviews()
            completion()
        }
    }
    
    func getBeat(id: String, completion: @escaping (BeatData) -> Void) {
        DatabaseManager.shared.findBeatById(beatId: id, completion: {[weak self] result in
            guard let strongSelf = self else {return}
            switch result {
            case .success(let beat):
                completion(beat)
                return
            case .failure(let err):
                print("setSong \(err)")
            }
        })
    }
    
    func getInstrumental(id: String, completion: @escaping (InstrumentalData) -> Void) {
        DatabaseManager.shared.findInstrumentalById(instrumentalId: id, completion: {[weak self] result in
            guard let strongSelf = self else {return}
            switch result {
            case .success(let instrumental):
                completion(instrumental)
                return
            case .failure(let err):
                print("setSong \(err)")
            }
        })
    }
    
    func getSong(id: String, completion: @escaping (SongData) -> Void) {
        DatabaseManager.shared.findSongById(songId: id, completion: {[weak self] result in
            guard let strongSelf = self else {return}
            switch result {
            case .success(let song):
                completion(song)
                return
            case .failure(let err):
                print("setSong \(err)")
            }
        })
    }
    
    func getVideo(id: String, completion: @escaping (VideoData) -> Void) {
        DatabaseManager.shared.findVideoById(videoid: id, completion: {[weak self] result in
            guard let strongSelf = self else {return}
            switch result {
            case .success(let video):
                completion(video)
                return
            case .failure(let err):
                print("setSong \(err)")
            }
        })
    }
    
    func getAlbum(id: String, completion: @escaping (AlbumData) -> Void) {
        DatabaseManager.shared.findAlbumById(albumId: id, completion: {[weak self] result in
            guard let strongSelf = self else {return}
            switch result {
            case .success(let album):
                completion(album)
                return
            case .failure(let err):
                print("setAlbum \(err)")
            }
        })
    }
    
    func createObservers(){
        NotificationCenter.default.addObserver(self, selector: #selector(DashboardViewController.updatedAccType), name: AccountChangedNotify, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(seg(notification:)), name: transitionDashToDetailInfoNotify, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(transitionToArtistInfoFromNotify), name: transitionFromDashboardToArtistInfoNotify, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(transitionToProducerInfoFromNotify), name: transitionFromDashboardToProducerInfoNotify, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(transitionToYoutubeInfoFromNotify), name: YoutubePlayNotify, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(showPopoverButtonAction), name: YoutubeDashboardPopoverNotify, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(refresh), name: ExpandCartHeightNotify, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(updateBeatsTableView), name: DownloadEndedNotify, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(playerItemDidReachEnd(notification:)), name: .AVPlayerItemDidPlayToEndTime, object: player?.currentItem)
    }
    
    @objc func refresh() {
        latestBeatsTableView.reloadData()
        view.layoutSubviews()
    }
    
    @objc func updatedAccType(notification: NSNotification) {
        print("📘 change dashboard text \(accountType)")
        
        loginStatus.textColor = .white
        
        loginStatus.text = ("User: \(currentUser!.email) - \(notification.object)")
    }
    
    deinit {
        print("📗 Dashboard being deallocated from memory. OS reclaiming")
        NotificationCenter.default.removeObserver(self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "dashToInfo" {
            if let viewController: InfoDetailViewController = segue.destination as? InfoDetailViewController {
                viewController.content = infoDetailContent
            }
        }
        if segue.identifier == "dashToArt" {
            if let viewController: ArtistInfoViewController = segue.destination as? ArtistInfoViewController {
                recievedArtistData = artistInfo
            }
        }
        if segue.identifier == "dashToPro" {
            if let viewController: ProducerInfoViewController = segue.destination as? ProducerInfoViewController {
                recievedProducerData = producerInfo
            }
        }
        if segue.identifier == "dashToBeatInfo" {
            if let viewController: BeatInfoDetailViewController = segue.destination as? BeatInfoDetailViewController {
                viewController.recievedBeat = beatInfo
            }
        }
        if segue.identifier == "dashToProductInfo" {
            if let viewController: ProductInfoViewController = segue.destination as? ProductInfoViewController {
                viewController.recievedMerch = merchToGo
            }
        }
    }
    
    func changeLoginText(){
        if accountType == AnonymousAccount {
            loginStatus.text = ("No Email - \(accountType)")
        } else {
            loginStatus.text = ("\(currentUser?.email) - \(accountType)")
        }
    }
    
    @IBAction func mainSearchTapped(_ sender: Any) {
        transitionToMainSearch()
    }
    
    @IBAction func profileTapped(_ sender: Any) {
        SideMenuManager.default.rightMenuNavigationController = profileSideMenu
        profileSideMenu.presentationStyle = .viewSlideOutMenuIn
        //profileSideMenu.setNavigationBarHidden(true, animated: false)
        present(profileSideMenu, animated: true, completion: nil)
    }
    
    @IBAction func cartTapped(_ sender: Any) {
        NotificationCenter.default.post(name: OpenTheCartNotify, object: nil)
    }
    
    
    @IBAction func songOfYesterdayTapped(_ sender: Any) {
        tapScale(xview: songOfYesterdayCard)
        infoDetailContent = songOfTheDayContentArray[1]
        performSegue(withIdentifier: "dashToInfo", sender: nil)
//        if audiofreeze != true {
//            player = nil
//            playerTimer = Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(playertimerset), userInfo: nil, repeats: false)
//            if audioPlayerViewController != nil {
//                audioPlayerViewController.view.removeFromSuperview()
//                audioPlayerViewController.removeFromParent()
//                playervisualEffectView.removeFromSuperview()
//            }
//            let song = songOfTheDayContentArray[1]
//            let urlPlayable:URL!
//            let prevurl = LatestSongsTableCellController().setPreviewButton(array: song)
//            if let url  = URL.init(string: prevurl){
//                urlPlayable = url
//                guard  let urlPlayable = urlPlayable else {return}
//                let myDict = [ "url": urlPlayable, "song":song] as [String : Any]
//                NotificationCenter.default.post(name: AudioPlayerOnSongNotify, object: myDict)
//            }
//        }
    }
    
    @IBAction func songOfTodayTapped(_ sender: Any) {
        tapScale(xview: songOfTheDayCard)
        infoDetailContent = songOfTheDayContentArray[0]
        performSegue(withIdentifier: "dashToInfo", sender: nil)
//        if audiofreeze != true {
//            player = nil
//            playerTimer = Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(playertimerset), userInfo: nil, repeats: false)
//            if audioPlayerViewController != nil {
//                audioPlayerViewController.view.removeFromSuperview()
//                audioPlayerViewController.removeFromParent()
//                playervisualEffectView.removeFromSuperview()
//            }
//            let song = songOfTheDayContentArray[0]
//            let urlPlayable:URL!
//            let prevurl = LatestSongsTableCellController().setPreviewButton(array: song)
//            if let url  = URL.init(string: prevurl){
//                urlPlayable = url
//               let artimage = LatestSongsTableCellController().getArtwork(song: song)
//                guard  let urlPlayable = urlPlayable else {return}
//                let myDict = [ "url": urlPlayable, "song":song] as [String : Any]
//                NotificationCenter.default.post(name: AudioPlayerOnSongNotify, object: myDict)
//            }
//        }
    }
    
    @IBAction func beatOfTodayTapped(_ sender: Any) {
        beatInfo = beatOfTheDayContentArray[0]
        performSegue(withIdentifier: "dashToBeatInfo", sender: nil)
//        if audiofreeze != true {
//            player = nil
//            playerTimer = Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(playertimerset), userInfo: nil, repeats: false)
//            if audioPlayerViewController != nil {
//                audioPlayerViewController.view.removeFromSuperview()
//                audioPlayerViewController.removeFromParent()
//                playervisualEffectView.removeFromSuperview()
//            }
//            let myDict = [ "beats": beatOfTheDayContentArray, "position": 0] as [String : Any]
//            NotificationCenter.default.post(name: AudioPlayerOnNotify, object: myDict)
//        }
        
    }
    
    @IBAction func beatOfYesterdayTapped(_ sender: Any) {
        beatInfo = beatOfTheDayContentArray[1]
        performSegue(withIdentifier: "dashToBeatInfo", sender: nil)
//        if audiofreeze != true {
//            player = nil
//            playerTimer = Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(playertimerset), userInfo: nil, repeats: false)
//            if audioPlayerViewController != nil {
//                audioPlayerViewController.view.removeFromSuperview()
//                audioPlayerViewController.removeFromParent()
//                playervisualEffectView.removeFromSuperview()
//            }
//            let myDict = [ "beats": beatOfTheDayContentArray, "position": 1] as [String : Any]
//            NotificationCenter.default.post(name: AudioPlayerOnNotify, object: myDict)
//        }
    }
    
    @objc func updateBeatsTableView() {
        latestBeatsTableView.reloadSections(IndexSet(integer: 0), with: .none)
        view.layoutSubviews()

    }
    
    func setCheckItOut() {
        DatabaseManager.shared.fetchAllMerch(completion: {[weak self] merch in
            guard let strongSelf = self else {return}
            var shuff = merch
            shuff.shuffle()
            strongSelf.checkItOutArr = shuff
            strongSelf.checkItOutCollectionView.delaysContentTouches = false
            strongSelf.checkItOutCollectionView.delegate = self
            strongSelf.checkItOutCollectionView.dataSource = self
            strongSelf.checkItOutCollectionView.reloadData()
            strongSelf.view.layoutSubviews()
        })
    }
    
    func transitionToMainSearch() {
        NotificationCenter.default.post(name: GoToSearchTabNotify, object: nil)
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        let mainNavBarController = storyboard.instantiateViewController(identifier: "mainSearchNavController")
//        (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(mainNavBarController)
    }
    
    
    @objc func playertimerset() {
        audiofreeze = false
        print("Audio Freeze Off")
        playerTimer.invalidate()
    }
    
    @objc func showPopoverButtonAction(notification: Notification) {
        alertController = UIAlertController(title: "Select Video",
                                                message: "Don't forget to favorite.",
                                                preferredStyle: .alert)

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        { (action) in
            // ...
        }
        alertController.addAction(cancelAction)

        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc3 = storyboard.instantiateViewController(identifier: "popoverYoutubeTableView") as PopoverYoutubeTableViewController
        vc3.preferredContentSize = CGSize(width: 300, height: 300) // 4 default cell heights.
        alertController.setValue(vc3, forKey: "contentViewController")
        alertController.view.tintColor = UIColor.init(red: 182/255, green: 0/255, blue: 3/255, alpha: 1)
        self.present(alertController, animated: true)
        {
            // ...
        }
    }
    
    @objc func seg(notification: Notification) {
        infoDetailContent = notification.object
        performSegue(withIdentifier: "dashToInfo", sender: nil)
    }
    
    @objc func dashToBeatInfo(beat:BeatData) {
        beatInfo = beat
        performSegue(withIdentifier: "dashToBeatInfo", sender: nil)
    }
    
    @objc func transitionToArtistInfoFromNotify(notification: Notification) {
        
        artistInfo = notification.object as! ArtistData
        performSegue(withIdentifier: "dashToArt", sender: nil)
        //transitionToArtistInfo()
    }
    
    @objc func transitionToProducerInfoFromNotify(notification: Notification) {
        producerInfo = notification.object as! ProducerData
        performSegue(withIdentifier: "dashToPro", sender: nil)
        //currentViewFoArtInfo = notification.object as! String
        //print(currentViewFoArtInfo)
            //transitionToProducerInfo()
    }
    
    @objc func transitionToYoutubeInfoFromNotify(notification: Notification) {
        transitionToYoutube()
    }
    
    func transitionToYoutube() {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc3 = storyboard.instantiateViewController(identifier: "youtubePlayerVC") as YoutubeVideoPlayerViewController
            self.present(vc3, animated: true, completion: nil)
        //self.navigationController?.pushViewController(vc3, animated: true)
    }
    
    func transitionToArtistInfo() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(identifier: "ArtistInfoViewController") as! ArtistInfoViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func transitionToProducerInfo() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(identifier: "ProducerInfoViewController") as! ProducerInfoViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func waiton() {
        while currentAppUser == nil {
            waiton()
        }
    }

}

extension DashboardViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
            if (scrollView.contentOffset.y >= (scrollView.contentSize.height - scrollView.frame.size.height)) {
                //Scrolled to bottom
                if !(scrollView.contentOffset.y < self.lastContentOffset || scrollView.contentOffset.y <= -50) {
                    
                    UIView.animate(withDuration: 0.2) { [weak self] in
                        guard let strongSelf = self else {return}
                        if strongSelf.visualEffectView == nil {
                            strongSelf.visualEffectView   = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
                            strongSelf.visualEffectView.frame =  (strongSelf.navigationController?.navigationBar.bounds.insetBy(dx: 0, dy: -10).offsetBy(dx: 0, dy: -10))!
                            strongSelf.navigationController?.navigationBar.addSubview(strongSelf.visualEffectView)
                            strongSelf.navigationController?.navigationBar.sendSubviewToBack(strongSelf.visualEffectView)
                            strongSelf.visualEffectView.layer.zPosition = -1;
                            strongSelf.visualEffectView.isUserInteractionEnabled = false
                        }
                        strongSelf.view.layoutIfNeeded()
                    }
                }
            }
            else if (scrollView.contentOffset.y < self.lastContentOffset || scrollView.contentOffset.y <= -50)// && (self.heightConstraint.constant != self.maxHeaderHeight)
            {
                //Scrolling up, scrolled to top
                //print(scrollView.contentOffset.y)
                
                UIView.animate(withDuration: 0.2) { [weak self] in
                    guard let strongSelf = self else {return}
                    print(strongSelf.lastContentOffset)
                    if scrollView.contentOffset.y <= -50 {
                        if strongSelf.visualEffectView != nil {
                            strongSelf.visualEffectView.removeFromSuperview()
                            strongSelf.visualEffectView = nil
                            strongSelf.view.layoutIfNeeded()
                        }
                    }
                }
            }
            else if (scrollView.contentOffset.y > lastContentOffset)// && heightConstraint.constant != 0
            {
                //Scrolling down
                if !(scrollView.contentOffset.y < lastContentOffset || scrollView.contentOffset.y <= -50) {
                    UIView.animate(withDuration: 0.2) { [weak self] in
                        guard let strongSelf = self else {return}
                        print(strongSelf.lastContentOffset)
                        if strongSelf.visualEffectView == nil {
                            strongSelf.visualEffectView   = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
                            strongSelf.visualEffectView.frame =  (strongSelf.navigationController?.navigationBar.bounds.insetBy(dx: 0, dy: -10).offsetBy(dx: 0, dy: -10))!
                            strongSelf.navigationController?.navigationBar.addSubview(strongSelf.visualEffectView)
                            strongSelf.navigationController?.navigationBar.sendSubviewToBack(strongSelf.visualEffectView)
                            strongSelf.visualEffectView.layer.zPosition = -1;
                            strongSelf.visualEffectView.isUserInteractionEnabled = false
                        }
                        strongSelf.view.layoutIfNeeded()
                    }
                }
            }
            self.lastContentOffset = scrollView.contentOffset.y
        
    }
}

extension Date {
    static var yesterday: Date { return Date().dayBefore }
    static var tomorrow:  Date { return Date().dayAfter }
    var dayBefore: Date {
        return Calendar.current.date(byAdding: .day, value: -1, to: noon)!
    }
    var dayAfter: Date {
        return Calendar.current.date(byAdding: .day, value: 1, to: noon)!
    }
    var noon: Date {
        return Calendar.current.date(bySettingHour: 12, minute: 0, second: 0, of: self)!
    }
    var month: Int {
        return Calendar.current.component(.month,  from: self)
    }
    var isLastDayOfMonth: Bool {
        return dayAfter.month != month
    }
}

extension DashboardViewController : UITableViewDelegate, UITableViewDataSource, SkeletonTableViewDataSource {
    func collectionSkeletonView(_ skeletonView: UITableView, cellIdentifierForRowAt indexPath: IndexPath) -> ReusableCellIdentifier {
//        if skeletonView == latestBeatsTableView {
            if accountType == "Creator" {
                return "ArtistBeatCell"
            } else if accountType == "Listener" {
                return "BeatCell"
            } else {
                return "GuestBeatCell"
            }
//        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == latestBeatsTableView {
            if accountType == "Creator" {
                switch latestBeatsArray[indexPath.row].priceType {
                case "Free":
                    musicTableHeight = 130
                default:
                    musicTableHeight = 150
                }
            } else if accountType == "Listener" {
                musicTableHeight = 120
            } else {
                musicTableHeight = 80
            }
        }
        return musicTableHeight
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        if tableView == latestBeatsTableView {
            return latestBeatsArray.count
//        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if currentAppUser != nil, currentAppUser.accountType == "Creator" {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ArtistBeatCell") as! FreeBeatArtistTableViewCell
            if !latestBeatsArray.isEmpty {
                let beat = latestBeatsArray[indexPath.row]
                if beat.priceType == "Paid" {
                    let pcell = tableView.dequeueReusableCell(withIdentifier: "paidArtistBeatCell") as! PaidBeatArtistTableViewCell
                    pcell.setBeat(beat: beat)
                    return pcell
                }
                cell.setBeat(beat: beat)
            }
            return cell
        } else if currentAppUser != nil, currentAppUser.accountType == "Listener" {
            let cell = tableView.dequeueReusableCell(withIdentifier: "BeatCell") as! FreeBeatListenerCell
            if !latestBeatsArray.isEmpty {
                let beat = latestBeatsArray[indexPath.row]
                cell.setBeat(beat: beat)
            }
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "GuestBeatCell") as! FreeBeatGuestTableViewCell
            if !latestBeatsArray.isEmpty {
                
                let beat = latestBeatsArray[indexPath.row]
                cell.setBeat(beat: beat)
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
            if audiofreeze != true {
                player = nil
                playerTimer = Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(playertimerset), userInfo: nil, repeats: false)
                tableView.deselectRow(at: indexPath, animated: false)
                if tableView == latestBeatsTableView {
                    if audioPlayerViewController != nil {
                        audioPlayerViewController.view.removeFromSuperview()
                        audioPlayerViewController.removeFromParent()
                        playervisualEffectView.removeFromSuperview()
                    }
                    let myDict = [ "beats": latestBeatsArray, "position": indexPath.row] as [String : Any]
                    NotificationCenter.default.post(name: AudioPlayerOnNotify, object: myDict)
                }
            } else {
                print("FREEZE")
            }
            
        }
    
}

extension DashboardViewController: UICollectionViewDelegate, UICollectionViewDataSource, CollectionViewPagingLayoutDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
        case checkItOutCollectionView:
            if checkItOutArr.count>14 {
                return 15
            } else {
                return checkItOutArr.count
            }
        default:
            if dashFavoritesArray.count > 14 {
                return 15
            } else {
                return dashFavoritesArray.count
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch collectionView {
        case checkItOutCollectionView :
           let merch = checkItOutArr[indexPath.item]
           let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "merchContentCollectionCell", for: indexPath) as! MerchContentCollectionCell
           cell.funcSetUp(latestMerch: merch)
           return cell
        default:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "userFavoritesCollectionViewCell", for: indexPath) as! UserFavoritesCollectionViewCell
            
            if dashFavoritesArray != nil, !dashFavoritesArray.isEmpty {
                userFavoritesStackView.isHidden = false
                let fav = dashFavoritesArray[indexPath.row]
                cell.setUpFunc(fav: fav, coll: favoritesCollectionView)
                
            }
            return cell
        }
    }
    
    func collectionViewPagingLayout(_ layout: CollectionViewPagingLayout, didSelectItemAt indexPath: IndexPath) {
        layout.collectionView!.deselectItem(at: indexPath, animated: true)
        let item = dashFavoritesArray[indexPath.row]
        switch item {
        case is BeatData:
            let beat = item as! BeatData
            beatInfo = beat
            performSegue(withIdentifier: "dashToBeatInfo", sender: nil)
        case is SongData:
            let song = item as! SongData
            infoDetailContent = song
            performSegue(withIdentifier: "dashToInfo", sender: nil)
        case is AlbumData:
            let album = item as! AlbumData
            infoDetailContent = album
            performSegue(withIdentifier: "dashToInfo", sender: nil)
        case is YouTubeData:
            let youtube = item as! YouTubeData
            infoDetailContent = youtube
            performSegue(withIdentifier: "dashToInfo", sender: nil)
        case is InstrumentalData:
            let instrumental = item as! InstrumentalData
            infoDetailContent = instrumental
            performSegue(withIdentifier: "dashToInfo", sender: nil)
        default:
            print("cjdsbhvjh")
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch collectionView {
        case checkItOutCollectionView:
            if let merch = checkItOutArr[indexPath.item].kit {
                merchToGo = merch
            } else if let merch = checkItOutArr[indexPath.item].apperal{
                merchToGo = merch
            } else if let merch = checkItOutArr[indexPath.item].service{
                merchToGo = merch
            } else if let merch = checkItOutArr[indexPath.item].memorabilia{
                merchToGo = merch
            } else if let merch = checkItOutArr[indexPath.item].instrumentalSale{
                merchToGo = merch
            }
            performSegue(withIdentifier: "dashToProductInfo", sender: nil)
        default:
            print("")
        }
    }
    
    
}

class DashboardLatestBeatsTableView : UITableView {
    override var intrinsicContentSize: CGSize {
        layoutIfNeeded()
        return CGSize(width: UIView.noIntrinsicMetric, height: contentSize.height)
    }
}



