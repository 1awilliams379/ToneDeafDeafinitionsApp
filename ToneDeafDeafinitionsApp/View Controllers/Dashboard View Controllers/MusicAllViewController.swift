//
//  MusicAllViewController.swift
//  ToneDeafDeafinitionsApp
//
//  Created by Tone Deaf on 8/15/20.
//  Copyright © 2020 GITEM Solutions. All rights reserved.
//

import UIKit
import SkeletonView
import SwiftUI
import SideMenu
import FirebaseDatabase

class MusicAllViewController: UIViewController, SkeletonTableViewDataSource {
    
    var musicTableHeight:CGFloat = 400
    
    static let shared = MusicAllViewController()
    
    var lastContentOffset: CGFloat = 0
    var maxHeaderHeight: CGFloat = 0
    var visualEffectView:UIVisualEffectView!
    
    @IBOutlet weak var scrollview1: UIScrollView!
    @IBOutlet weak var featuredContentView: UIView!
    @IBOutlet weak var musicLatestSongsTableView: UITableView!
    @IBOutlet weak var featuredArtistTableView: UITableView!
    @IBOutlet weak var latestVideosTableView: UITableView!
    @IBOutlet weak var instrumentalTableView: UITableView!
    @IBOutlet weak var featuredViewForSkeleton: UIView!
    //let host = UIHostingController(rootView: CView())
    var skelvar = 0
    var items = ["Featured"]
    
    var allOfContent:String!
    var infoDetailContent:Any!
    var artistInfo:ArtistData!
    var producerInfo:ProducerData!
    
    @IBOutlet weak var musicPageBottomConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollview1.delegate =  self
        musicPageBottomConstraint.constant = 73.5
        musicLatestSongsTableView.delegate = self
        musicLatestSongsTableView.dataSource = self
        featuredArtistTableView.delegate = self
        featuredArtistTableView.dataSource = self
        latestVideosTableView.delegate = self
        latestVideosTableView.dataSource = self
        instrumentalTableView.delegate = self
        instrumentalTableView.dataSource = self
        skelvar = 0
        let queue = DispatchQueue(label: "myQueue")
        let group = DispatchGroup()
        let array = [/*1, */2/*, 3, 4, 5*/]

        for i in array {
            print(i)
            group.enter()
            queue.async { [weak self] in
                guard let strongSelf = self else {return}
                switch i {
                case 1:
                    //print("null")
//                    strongSelf.fetchMainInfiniteScrollContent(completion: {
                        print("done \(i)")
                        group.leave()
//                    })
                    case 2:
                    //print("null")
                    strongSelf.fetchLatestSongsContent(completion: {
                        print("done \(i)")
                        group.leave()
                    })
                    case 3:
                    strongSelf.fetchFeaturedArtistContent(completion: {
                        print("done \(i)")
                        group.leave()
                    })
                    case 4:
                    //print("null")
                    strongSelf.fetchLatestVideosContent(completion: {
                        print("done \(i)")
                        group.leave()
                    })
                    case 5:
                        strongSelf.setFeaturedInstrumentals(completion: {
                        print("done \(i)")
                        group.leave()
                    })
                default:
                    print("error")
                }
            }
        }

        group.notify(queue: DispatchQueue.main) {
            print("done!")
        }
        
    }
    
    func createObservers() {
        NotificationCenter.default.removeObserver(self)
        NotificationCenter.default.addObserver(self, selector: #selector(transitionToArtistInfoFromNotify), name: transitionFromMusicToArtistInfoNotify, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(transitionToProducerInfoFromNotify), name: transitionFromMusicToProducerInfoNotify, object: nil)
         NotificationCenter.default.addObserver(self, selector: #selector(seg(notification:)), name: transitionMusicToDetailInfoNotify, object: nil)
    }
    
    deinit {
        print("Music page being deallocated from memory. OS reclaiming")
        NotificationCenter.default.removeObserver(self)
    }
    
    func hideskeleton(tableview: UITableView) {
        DispatchQueue.main.async {
        tableview.stopSkeletonAnimation()
        tableview.hideSkeleton(reloadDataAfter: false, transition: .crossDissolve(0.25))
        tableview.reloadData()
        }
    }
    
    func hidevisualbluinheader() {
        visualEffectView.removeFromSuperview()
        visualEffectView = nil
        if visualEffectView != nil {
            hidevisualbluinheader()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        createObservers()
            self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
          self.navigationController?.navigationBar.shadowImage = UIImage()
          self.navigationController?.navigationBar.isTranslucent = true
        if scrollview1.contentOffset.y <= 0 {
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
            latestVideosTableView.reloadData()
            musicLatestSongsTableView.reloadData()
            instrumentalTableView.reloadData()
        view.layoutSubviews()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if skelvar == 0 {
            musicLatestSongsTableView.isSkeletonable = true
            musicLatestSongsTableView.showAnimatedGradientSkeleton(usingGradient: .init(baseColor: UIColor.init(red: 22/255, green: 22/255, blue: 22/255, alpha: 1)), animation: nil, transition: .crossDissolve(0.25))
            
            featuredArtistTableView.isSkeletonable = true
            featuredArtistTableView.showAnimatedGradientSkeleton(usingGradient: .init(baseColor: UIColor.init(red: 22/255, green: 22/255, blue: 22/255, alpha: 1)), animation: nil, transition: .crossDissolve(0.25))
            
            latestVideosTableView.isSkeletonable = true
            latestVideosTableView.showAnimatedGradientSkeleton(usingGradient: .init(baseColor: UIColor.init(red: 22/255, green: 22/255, blue: 22/255, alpha: 1)), animation: nil, transition: .crossDissolve(0.25))
            
            instrumentalTableView.isSkeletonable = true
            instrumentalTableView.showAnimatedGradientSkeleton(usingGradient: .init(baseColor: UIColor.init(red: 22/255, green: 22/255, blue: 22/255, alpha: 1)), animation: nil, transition: .crossDissolve(0.25))
            
            featuredViewForSkeleton.isSkeletonable = true
            featuredViewForSkeleton.showAnimatedGradientSkeleton(usingGradient: .init(baseColor: UIColor.init(red: 22/255, green: 22/255, blue: 22/255, alpha: 1)), animation: nil, transition: .crossDissolve(0.25))
        }
        
    skelvar+=1
        //tableview.showAnimatedSkeleton(usingColor: .wetAsphalt, transition: .crossDissolve(0.25))
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        if visualEffectView != nil {
            hidevisualbluinheader()
        }
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
    
    func setupHC() {
        let host = UIHostingController(rootView: CView())
        host.view.frame = .init(x: 0, y: 60 , width: self.view.bounds.width, height: 375)
        host.view.backgroundColor = .clear
        addChild(host)
        featuredContentView.addSubview(host.view)
        host.didMove(toParent: self)
        featuredViewForSkeleton.stopSkeletonAnimation()
        featuredViewForSkeleton.hideSkeleton(reloadDataAfter: false, transition: .crossDissolve(0.25))
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "musicToInfo" {
            if let viewController: InfoDetailViewController = segue.destination as? InfoDetailViewController {
                viewController.content = infoDetailContent
            }
        }
        if segue.identifier == "musicToArt" {
            if let viewController: ArtistInfoViewController = segue.destination as? ArtistInfoViewController {
                recievedArtistData = artistInfo
            }
        }
        if segue.identifier == "musicToPro" {
            if let viewController: ProducerInfoViewController = segue.destination as? ProducerInfoViewController {
                recievedProducerData = producerInfo
            }
        }
        if segue.identifier == "musicToAllOf" {
            if let viewController: AllOfContentTypeViewController = segue.destination as? AllOfContentTypeViewController {
                viewController.recievedData = allOfContent
            }
        }
    }
    
    func getArtistData(song:SongData, completion: @escaping (Array<String>, Array<String>) -> Void) {
        var artistNameData:Array<String> = []
        var artistimageURLs:Array<String> = []
        var val = 1
        for artist in song.songArtist {
            let word = artist.split(separator: "Æ")
            let id = word[0]
            DatabaseManager.shared.fetchArtistData(artist: String(id), completion: { selectedArtist in
                //print(song.songArtist.count)
                artistNameData.append(selectedArtist.name)
                artistimageURLs.append(selectedArtist.spotifyProfileImageURL)
                if val == song.songArtist.count {
                    completion(artistNameData, artistimageURLs)
                }
                val+=1
            })
        }
        
    }
    
    func getProducerData(song:SongData, completion: @escaping (Array<String>, Array<String>) -> Void) {
        var producerNameData:Array<String> = []
        var producerimageURLs:Array<String> = []
        var val = 1
        for producer in song.songProducers {
            let word = producer.split(separator: "Æ")
            let id = word[0]
//            DatabaseManager.shared.fetchPersonData(person: String(id), completion: { selectedProducer in
//                //print(song.songArtist.count)
//                producerNameData.append(selectedProducer.name)
//                producerimageURLs.append(selectedProducer.spotifyProfileImageURL)
//                if val == song.songProducers.count {
//                    completion(producerNameData, producerimageURLs)
//                }
//                val+=1
//            })
        }
        
    }
    
    func getArtistData(album:AlbumData, completion: @escaping (Array<String>, Array<String>) -> Void) {
        var artistNameData:Array<String> = []
        var artistimageURLs:Array<String> = []
        var val = 1
//        for artist in album.allArtists {
//            let word = artist.split(separator: "Æ")
//            let id = word[0]
//            DatabaseManager.shared.fetchArtistData(artist: String(id), completion: { selectedArtist in
//                //print(song.songArtist.count)
//                artistNameData.append(selectedArtist.name)
//                artistimageURLs.append(selectedArtist.spotifyProfileImageURL)
//                if val == album.allArtists.count {
//                    completion(artistNameData, artistimageURLs)
//                }
//                val+=1
//            })
//        }
        
    }
    
    func getProducerData(album:AlbumData, completion: @escaping (Array<String>, Array<String>) -> Void) {
        var producerNameData:Array<String> = []
        var producerimageURLs:Array<String> = []
        var val = 1
        for producer in album.producers {
            let word = producer.split(separator: "Æ")
            let id = word[0]
//            DatabaseManager.shared.fetchPersonData(person: String(id), completion: { selectedProducer in
//                //print(song.songArtist.count)
//                producerNameData.append(selectedProducer.name)
//                producerimageURLs.append(selectedProducer.spotifyProfileImageURL)
//                if val == album.producers.count {
//                    completion(producerNameData, producerimageURLs)
//                }
//                val+=1
//            })
        }
        
    }
    
    func getArtistData(instrumental:InstrumentalData, completion: @escaping (Array<String>, Array<String>) -> Void) {
        var artistNameData:Array<String> = []
        var artistimageURLs:Array<String> = []
        var val = 1
        for artist in instrumental.artist! {
            let word = artist.split(separator: "Æ")
            let id = word[0]
            DatabaseManager.shared.fetchArtistData(artist: String(id), completion: { selectedArtist in
                //print(song.songArtist.count)
                artistNameData.append(selectedArtist.name)
                artistimageURLs.append(selectedArtist.spotifyProfileImageURL)
                if val == instrumental.artist!.count {
                    completion(artistNameData, artistimageURLs)
                }
                val+=1
            })
        }
        
    }
    
    func getProducerData(instrumental:InstrumentalData, completion: @escaping (Array<String>, Array<String>) -> Void) {
        var producerNameData:Array<String> = []
        var producerimageURLs:Array<String> = []
        var val = 1
        for producer in instrumental.producers {
            let word = producer.split(separator: "Æ")
            let id = word[0]
//            DatabaseManager.shared.fetchPersonData(person: String(id), completion: { selectedProducer in
//                //print(song.songArtist.count)
//                producerNameData.append(selectedProducer.name)
//                producerimageURLs.append(selectedProducer.spotifyProfileImageURL)
//                if val == instrumental.songProducers.count {
//                    completion(producerNameData, producerimageURLs)
//                }
//                val+=1
//            })
        }
        
    }
    
    func getArtistDataVideo(video:YouTubeData, completion: @escaping (Array<String>, Array<String>) -> Void) {
        var artistNameData:Array<String> = []
        var artistimageURLs:Array<String> = []
        var val = 1
//        for artist in video.artist {
//            let word = artist.split(separator: "Æ")
//            let id = word[0]
//            DatabaseManager.shared.fetchArtistData(artist: String(id), completion: { selectedArtist in
//                //print(song.songArtist.count)
//                artistNameData.append(selectedArtist.name)
//                artistimageURLs.append(selectedArtist.spotifyProfileImageURL)
//                if val == video.artist.count {
//                    completion(artistNameData, artistimageURLs)
//                }
//                val+=1
//            })
//        }
        
    }
    
    func getProducerDataVideo(video:YouTubeData, completion: @escaping (Array<String>, Array<String>) -> Void) {
        var producerNameData:Array<String> = []
        var producerimageURLs:Array<String> = []
        var val = 1
//        for producer in video.producers {
//            let word = producer.split(separator: "Æ")
//            let id = word[0]
//            DatabaseManager.shared.fetchProducerData(person: String(id), completion: { selectedProducer in
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
    
    func getSongYoutubeData(song:SongData, completion: @escaping (Array<YouTubeData>, Array<String>) -> Void) {
        var videosData:Array<YouTubeData> = []
        var youtubeimageURLs:Array<String> = []
        var val = 1
        if song.videos! != [""] && !song.videos!.isEmpty {
            for video in song.videos! {
                let word = video.split(separator: "Æ")
                let id = word[0]
                DatabaseManager.shared.findVideoById(videoid: String(id), completion: { selectedVideo in
                    //print(song.songArtist.count)
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
                        return
                    }
                })
            }
        } else {
            completion(videosData, youtubeimageURLs)
        }
        
    }
    
    func getInstrumentalYoutubeData(instrumental:InstrumentalData, completion: @escaping (Array<YouTubeData>, Array<String>) -> Void) {
        var videosData:Array<YouTubeData> = []
        var youtubeimageURLs:Array<String> = []
        var val = 1
        if instrumental.videos![0] != "" {
            for video in instrumental.videos! {
                let word = video.split(separator: "Æ")
                let id = word[0]
                DatabaseManager.shared.findVideoById(videoid: String(id), completion: { selectedVideo in
                    //print(song.songArtist.count)
                    switch selectedVideo {
                    case .success(let vid):
                        let video = vid as! YouTubeData
                        videosData.append(video)
                        if video.thumbnailURL != "" {
                            youtubeimageURLs.append(video.thumbnailURL)
                        }
                        if val == instrumental.videos!.count {
                            completion(videosData, youtubeimageURLs)
                        }
                        val+=1
                    case .failure(let error):
                        print("Video ID proccessing error \(error)")
                        return
                    }
                })
            }
        } else {
            completion(videosData,youtubeimageURLs)
        }
        
    }
    
    func setArraysForInfiniteScroll(_ content: [AnyObject], _ strongSelf: MusicAllViewController, completion: @escaping () -> Void) {
        var curr = 0
        var counter = 0
        //print(content)
        for array in content {
            curr += 1
            let icurr = curr
            if curr == content.count+1 {
                break
            }
            var name = ""
            var imageurl = ""
            var releaseDate = ""
            var previewURL = ""
            var artists:[String] = []
            var producers:[String] = []
            var artistData:[ArtistData] = []
            var songvideos:[String]!
            switch array {
            case is SongData:
                let song = array as! SongData
                print("main infinite \(icurr), \(song.name)")
                name = song.name
                //print(name)
                Comparisons.shared.getEarliestReleaseDate(song: song, completion: { [weak self] edate in
                    
                    guard let strongSelf = self else {return}
                    releaseDate = edate
                    artists = song.songArtist
                    producers = song.songProducers
                    GlobalFunctions.shared.selectImageURL(song: song, completion: { ur in
                        imageurl = ur!
                        
                        if song.apple?.applePreviewURL != nil {
                            previewURL = song.apple!.applePreviewURL
                        } else if song.spotify?.spotifyPreviewURL != nil {
                            previewURL = song.spotify!.spotifyPreviewURL
                        }
                        songvideos = song.videos
                        guard let songvideos = songvideos else {return}
                        //print(name)
                        strongSelf.getArtistData(song: song, completion: { artistNames,artistImageURLs  in
                            strongSelf.getProducerData(song: song, completion: { producerNames,producerImageURLs  in
                                do {
                                    if let url = URL.init(string: imageurl) {
                                        print("main infinite icurr \(icurr)")
                                        switch icurr {
                                        case 1:
                                            MusicMainInfiniteScrollContentFeaturedArray1.append(name)
                                            MusicMainInfiniteScrollContentFeaturedArray1.append(imageurl)
                                            MusicMainInfiniteScrollContentFeaturedArray1.append(releaseDate)
                                            MusicMainInfiniteScrollContentFeaturedArray1.append(previewURL)
                                            MusicMainInfiniteScrollContentFeaturedArray1.append(artistNames)
                                            MusicMainInfiniteScrollContentFeaturedArray1.append(imageurl)
                                            MusicMainInfiniteScrollContentFeaturedArray1.append(artistImageURLs)
                                            MusicMainInfiniteScrollContentFeaturedArray1.append(artists)
                                            MusicMainInfiniteScrollContentFeaturedArray1.append(producerNames)
                                            MusicMainInfiniteScrollContentFeaturedArray1.append(producerImageURLs)
                                            MusicMainInfiniteScrollContentFeaturedArray1.append(producers)
                                            MusicMainInfiniteScrollContentFeaturedArray1.append(songvideos)
                                            MusicMainInfiniteScrollContentFeaturedArray1.append(song)
                                            counter+=1
                                            if counter == content.count {
                                                strongSelf.setupHC()
                                                completion()
                                            }
                                        case 2:
                                            MusicMainInfiniteScrollContentFeaturedArray2.append(name)
                                            MusicMainInfiniteScrollContentFeaturedArray2.append(imageurl)
                                            MusicMainInfiniteScrollContentFeaturedArray2.append(releaseDate)
                                            MusicMainInfiniteScrollContentFeaturedArray2.append(previewURL)
                                            MusicMainInfiniteScrollContentFeaturedArray2.append(artistNames)
                                            MusicMainInfiniteScrollContentFeaturedArray2.append(imageurl)
                                            MusicMainInfiniteScrollContentFeaturedArray2.append(artistImageURLs)
                                            MusicMainInfiniteScrollContentFeaturedArray2.append(artists)
                                            MusicMainInfiniteScrollContentFeaturedArray2.append(producerNames)
                                            MusicMainInfiniteScrollContentFeaturedArray2.append(producerImageURLs)
                                            MusicMainInfiniteScrollContentFeaturedArray2.append(producers)
                                            MusicMainInfiniteScrollContentFeaturedArray2.append(songvideos)
                                            MusicMainInfiniteScrollContentFeaturedArray2.append(song)
                                            counter+=1
                                            
                                            if counter == content.count {
                                                strongSelf.setupHC()
                                                completion()
                                            }
                                        case 3:
                                            MusicMainInfiniteScrollContentFeaturedArray3.append(name )
                                            MusicMainInfiniteScrollContentFeaturedArray3.append(imageurl)
                                            MusicMainInfiniteScrollContentFeaturedArray3.append(releaseDate)
                                            MusicMainInfiniteScrollContentFeaturedArray3.append(previewURL)
                                            MusicMainInfiniteScrollContentFeaturedArray3.append(artistNames)
                                            MusicMainInfiniteScrollContentFeaturedArray3.append(imageurl)
                                            MusicMainInfiniteScrollContentFeaturedArray3.append(artistImageURLs)
                                            MusicMainInfiniteScrollContentFeaturedArray3.append(artists)
                                            MusicMainInfiniteScrollContentFeaturedArray3.append(producerNames)
                                            MusicMainInfiniteScrollContentFeaturedArray3.append(producerImageURLs)
                                            MusicMainInfiniteScrollContentFeaturedArray3.append(producers)
                                            MusicMainInfiniteScrollContentFeaturedArray3.append(songvideos)
                                            MusicMainInfiniteScrollContentFeaturedArray3.append(song)
                                            counter+=1
                                            if counter == content.count {
                                                strongSelf.setupHC()
                                                completion()
                                            }
                                        case 4:
                                            MusicMainInfiniteScrollContentFeaturedArray4.append(name )
                                            MusicMainInfiniteScrollContentFeaturedArray4.append(imageurl)
                                            MusicMainInfiniteScrollContentFeaturedArray4.append(releaseDate)
                                            MusicMainInfiniteScrollContentFeaturedArray4.append(previewURL)
                                            MusicMainInfiniteScrollContentFeaturedArray4.append(artistNames)
                                            MusicMainInfiniteScrollContentFeaturedArray4.append(imageurl)
                                            MusicMainInfiniteScrollContentFeaturedArray4.append(artistImageURLs)
                                            MusicMainInfiniteScrollContentFeaturedArray4.append(artists)
                                            MusicMainInfiniteScrollContentFeaturedArray4.append(producerNames)
                                            MusicMainInfiniteScrollContentFeaturedArray4.append(producerImageURLs)
                                            MusicMainInfiniteScrollContentFeaturedArray4.append(producers)
                                            MusicMainInfiniteScrollContentFeaturedArray4.append(songvideos)
                                            MusicMainInfiniteScrollContentFeaturedArray4.append(song)
                                            counter+=1
                                            if counter == content.count {
                                                strongSelf.setupHC()
                                                completion()
                                            }
                                        case 5:
                                            MusicMainInfiniteScrollContentFeaturedArray5.append(name )
                                            MusicMainInfiniteScrollContentFeaturedArray5.append(imageurl)
                                            MusicMainInfiniteScrollContentFeaturedArray5.append(releaseDate)
                                            MusicMainInfiniteScrollContentFeaturedArray5.append(previewURL)
                                            MusicMainInfiniteScrollContentFeaturedArray5.append(artistNames)
                                            MusicMainInfiniteScrollContentFeaturedArray5.append(imageurl)
                                            MusicMainInfiniteScrollContentFeaturedArray5.append(artistImageURLs)
                                            MusicMainInfiniteScrollContentFeaturedArray5.append(artists)
                                            MusicMainInfiniteScrollContentFeaturedArray5.append(producerNames)
                                            MusicMainInfiniteScrollContentFeaturedArray5.append(producerImageURLs)
                                            MusicMainInfiniteScrollContentFeaturedArray5.append(producers)
                                            MusicMainInfiniteScrollContentFeaturedArray5.append(songvideos)
                                            MusicMainInfiniteScrollContentFeaturedArray5.append(song)
                                            counter+=1
                                            if counter == content.count {
                                                strongSelf.setupHC()
                                                completion()
                                            }
                                        case 6:
                                            MusicMainInfiniteScrollContentFeaturedArray6.append(name )
                                            MusicMainInfiniteScrollContentFeaturedArray6.append(imageurl)
                                            MusicMainInfiniteScrollContentFeaturedArray6.append(releaseDate)
                                            MusicMainInfiniteScrollContentFeaturedArray6.append(previewURL)
                                            MusicMainInfiniteScrollContentFeaturedArray6.append(artistNames)
                                            MusicMainInfiniteScrollContentFeaturedArray6.append(imageurl)
                                            MusicMainInfiniteScrollContentFeaturedArray6.append(artistImageURLs)
                                            MusicMainInfiniteScrollContentFeaturedArray6.append(artists)
                                            MusicMainInfiniteScrollContentFeaturedArray6.append(producerNames)
                                            MusicMainInfiniteScrollContentFeaturedArray6.append(producerImageURLs)
                                            MusicMainInfiniteScrollContentFeaturedArray6.append(producers)
                                            MusicMainInfiniteScrollContentFeaturedArray6.append(songvideos)
                                            MusicMainInfiniteScrollContentFeaturedArray6.append(song)
                                            counter+=1
                                            if counter == content.count {
                                                strongSelf.setupHC()
                                                completion()
                                            }
                                        case 7:
                                            MusicMainInfiniteScrollContentFeaturedArray7.append(name )
                                            MusicMainInfiniteScrollContentFeaturedArray7.append(imageurl)
                                            MusicMainInfiniteScrollContentFeaturedArray7.append(releaseDate)
                                            MusicMainInfiniteScrollContentFeaturedArray7.append(previewURL)
                                            MusicMainInfiniteScrollContentFeaturedArray7.append(artistNames)
                                            MusicMainInfiniteScrollContentFeaturedArray7.append(imageurl)
                                            MusicMainInfiniteScrollContentFeaturedArray7.append(artistImageURLs)
                                            MusicMainInfiniteScrollContentFeaturedArray7.append(artists)
                                            MusicMainInfiniteScrollContentFeaturedArray7.append(producerNames)
                                            MusicMainInfiniteScrollContentFeaturedArray7.append(producerImageURLs)
                                            MusicMainInfiniteScrollContentFeaturedArray7.append(producers)
                                            MusicMainInfiniteScrollContentFeaturedArray7.append(songvideos)
                                            MusicMainInfiniteScrollContentFeaturedArray7.append(song)
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
                                    
                                } catch {
                                    print("catch erroe \(error)")
                                }
                            })
                            
                        })
                    })
                })
            case is YouTubeData:
                let video = array as! YouTubeData
                var songart:[String] = []
//                for art in video.artist {
//                    let word = art.split(separator: "Æ")
//                    let id = word[0]
//                    songart.append(String(id))
//                }
                var songapro:[String] = []
//                for pro in video.producers {
//                    let word = pro.split(separator: "Æ")
//                    let id = word[0]
//                    songapro.append(String(id))
//                }
                name = video.title
                previewURL = ""
                releaseDate = video.dateYT
//                artists = video.artist
//                producers = video.producers
                imageurl = video.thumbnailURL
                strongSelf.getArtistDataVideo(video: video, completion: { artistNames,artistImageURLs  in
                    strongSelf.getProducerDataVideo(video: video, completion: { producerNames,producerImageURLs  in
                        print(producerNames, video.title)
                        if let url = URL.init(string: imageurl) {
                            print("main infinite icurr \(icurr)")
                            switch icurr {
                            case 1:
                                
                                MusicMainInfiniteScrollContentFeaturedArray1.append(name)
                                MusicMainInfiniteScrollContentFeaturedArray1.append(imageurl)
                                MusicMainInfiniteScrollContentFeaturedArray1.append(releaseDate)
                                MusicMainInfiniteScrollContentFeaturedArray1.append(previewURL)
                                MusicMainInfiniteScrollContentFeaturedArray1.append(artistNames)
                                MusicMainInfiniteScrollContentFeaturedArray1.append(imageurl)
                                MusicMainInfiniteScrollContentFeaturedArray1.append(artistImageURLs)
                                MusicMainInfiniteScrollContentFeaturedArray1.append(artists)
                                MusicMainInfiniteScrollContentFeaturedArray1.append(producerNames)
                                MusicMainInfiniteScrollContentFeaturedArray1.append(producerImageURLs)
                                MusicMainInfiniteScrollContentFeaturedArray1.append(producers)
                                MusicMainInfiniteScrollContentFeaturedArray1.append(video)
                                MusicMainInfiniteScrollContentFeaturedArray1.append(video)
                                counter+=1
                                if counter == content.count {
                                    strongSelf.setupHC()
                                    completion()
                                }
                            case 2:
                                MusicMainInfiniteScrollContentFeaturedArray2.append(name)
                                MusicMainInfiniteScrollContentFeaturedArray2.append(imageurl)
                                MusicMainInfiniteScrollContentFeaturedArray2.append(releaseDate)
                                MusicMainInfiniteScrollContentFeaturedArray2.append(previewURL)
                                MusicMainInfiniteScrollContentFeaturedArray2.append(artistNames)
                                MusicMainInfiniteScrollContentFeaturedArray2.append(imageurl)
                                MusicMainInfiniteScrollContentFeaturedArray2.append(artistImageURLs)
                                MusicMainInfiniteScrollContentFeaturedArray2.append(artists)
                                MusicMainInfiniteScrollContentFeaturedArray2.append(producerNames)
                                MusicMainInfiniteScrollContentFeaturedArray2.append(producerImageURLs)
                                MusicMainInfiniteScrollContentFeaturedArray2.append(producers)
                                MusicMainInfiniteScrollContentFeaturedArray2.append(video)
                                MusicMainInfiniteScrollContentFeaturedArray2.append(video)
                                counter+=1
                                
                                if counter == content.count {
                                    strongSelf.setupHC()
                                    completion()
                                }
                            case 3:
                                MusicMainInfiniteScrollContentFeaturedArray3.append(name )
                                MusicMainInfiniteScrollContentFeaturedArray3.append(imageurl)
                                MusicMainInfiniteScrollContentFeaturedArray3.append(releaseDate)
                                MusicMainInfiniteScrollContentFeaturedArray3.append(previewURL)
                                MusicMainInfiniteScrollContentFeaturedArray3.append(artistNames)
                                MusicMainInfiniteScrollContentFeaturedArray3.append(imageurl)
                                MusicMainInfiniteScrollContentFeaturedArray3.append(artistImageURLs)
                                MusicMainInfiniteScrollContentFeaturedArray3.append(artists)
                                MusicMainInfiniteScrollContentFeaturedArray3.append(producerNames)
                                MusicMainInfiniteScrollContentFeaturedArray3.append(producerImageURLs)
                                MusicMainInfiniteScrollContentFeaturedArray3.append(producers)
                                MusicMainInfiniteScrollContentFeaturedArray3.append(video)
                                MusicMainInfiniteScrollContentFeaturedArray3.append(video)
                                counter+=1
                                if counter == content.count {
                                    strongSelf.setupHC()
                                    completion()
                                }
                            case 4:
                                MusicMainInfiniteScrollContentFeaturedArray4.append(name )
                                MusicMainInfiniteScrollContentFeaturedArray4.append(imageurl)
                                MusicMainInfiniteScrollContentFeaturedArray4.append(releaseDate)
                                MusicMainInfiniteScrollContentFeaturedArray4.append(previewURL)
                                MusicMainInfiniteScrollContentFeaturedArray4.append(artistNames)
                                MusicMainInfiniteScrollContentFeaturedArray4.append(imageurl)
                                MusicMainInfiniteScrollContentFeaturedArray4.append(artistImageURLs)
                                MusicMainInfiniteScrollContentFeaturedArray4.append(artists)
                                MusicMainInfiniteScrollContentFeaturedArray4.append(producerNames)
                                MusicMainInfiniteScrollContentFeaturedArray4.append(producerImageURLs)
                                MusicMainInfiniteScrollContentFeaturedArray4.append(producers)
                                MusicMainInfiniteScrollContentFeaturedArray4.append(video)
                                MusicMainInfiniteScrollContentFeaturedArray4.append(video)
                                counter+=1
                                if counter == content.count {
                                    strongSelf.setupHC()
                                    completion()
                                }
                            case 5:
                                MusicMainInfiniteScrollContentFeaturedArray5.append(name )
                                MusicMainInfiniteScrollContentFeaturedArray5.append(imageurl)
                                MusicMainInfiniteScrollContentFeaturedArray5.append(releaseDate)
                                MusicMainInfiniteScrollContentFeaturedArray5.append(previewURL)
                                MusicMainInfiniteScrollContentFeaturedArray5.append(artistNames)
                                MusicMainInfiniteScrollContentFeaturedArray5.append(imageurl)
                                MusicMainInfiniteScrollContentFeaturedArray5.append(artistImageURLs)
                                MusicMainInfiniteScrollContentFeaturedArray5.append(artists)
                                MusicMainInfiniteScrollContentFeaturedArray5.append(producerNames)
                                MusicMainInfiniteScrollContentFeaturedArray5.append(producerImageURLs)
                                MusicMainInfiniteScrollContentFeaturedArray5.append(producers)
                                MusicMainInfiniteScrollContentFeaturedArray5.append(video)
                                MusicMainInfiniteScrollContentFeaturedArray5.append(video)
                                counter+=1
                                if counter == content.count {
                                    strongSelf.setupHC()
                                    completion()
                                }
                            case 6:
                                MusicMainInfiniteScrollContentFeaturedArray6.append(name )
                                MusicMainInfiniteScrollContentFeaturedArray6.append(imageurl)
                                MusicMainInfiniteScrollContentFeaturedArray6.append(releaseDate)
                                MusicMainInfiniteScrollContentFeaturedArray6.append(previewURL)
                                MusicMainInfiniteScrollContentFeaturedArray6.append(artistNames)
                                MusicMainInfiniteScrollContentFeaturedArray6.append(imageurl)
                                MusicMainInfiniteScrollContentFeaturedArray6.append(artistImageURLs)
                                MusicMainInfiniteScrollContentFeaturedArray6.append(artists)
                                MusicMainInfiniteScrollContentFeaturedArray6.append(producerNames)
                                MusicMainInfiniteScrollContentFeaturedArray6.append(producerImageURLs)
                                MusicMainInfiniteScrollContentFeaturedArray6.append(producers)
                                MusicMainInfiniteScrollContentFeaturedArray6.append(video)
                                MusicMainInfiniteScrollContentFeaturedArray6.append(video)
                                counter+=1
                                if counter == content.count {
                                    strongSelf.setupHC()
                                    completion()
                                }
                            case 7:
                                MusicMainInfiniteScrollContentFeaturedArray7.append(name )
                                MusicMainInfiniteScrollContentFeaturedArray7.append(imageurl)
                                MusicMainInfiniteScrollContentFeaturedArray7.append(releaseDate)
                                MusicMainInfiniteScrollContentFeaturedArray7.append(previewURL)
                                MusicMainInfiniteScrollContentFeaturedArray7.append(artistNames)
                                MusicMainInfiniteScrollContentFeaturedArray7.append(imageurl)
                                MusicMainInfiniteScrollContentFeaturedArray7.append(artistImageURLs)
                                MusicMainInfiniteScrollContentFeaturedArray7.append(artists)
                                MusicMainInfiniteScrollContentFeaturedArray7.append(producerNames)
                                MusicMainInfiniteScrollContentFeaturedArray7.append(producerImageURLs)
                                MusicMainInfiniteScrollContentFeaturedArray7.append(producers)
                                MusicMainInfiniteScrollContentFeaturedArray7.append(video)
                                MusicMainInfiniteScrollContentFeaturedArray7.append(video)
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
            //print("Youtube")
            case is InstrumentalData:
                let instrumental = array as! InstrumentalData
                name = instrumental.instrumentalName!
                artists = [""]
                producers = instrumental.producers
//                strongSelf.getInstrumentalYoutubeData(instrumental: instrumental, completion: { videos,videothumbnails in
//                    if instrumental.imageURL != "" {
//                        imageurl = instrumental.imageURL
//                    } else if instrumental.spotifyArtworkURL != "" {
//                        imageurl = instrumental.spotifyArtworkURL
//                    } else if instrumental.appleArtworkURL != "" {
//                        imageurl = instrumental.appleArtworkURL
//                    } else if !videothumbnails.isEmpty {
//                        imageurl = videothumbnails[0]
//                    }
//                    
//                    if instrumental.audioURL != "" {
//                        previewURL = instrumental.audioURL
//                    } else if instrumental.applePreviewURL != "" {
//                        previewURL = instrumental.applePreviewURL
//                    } else if instrumental.spotifyPreviewURL != "" {
//                        previewURL = instrumental.spotifyPreviewURL
//                    }
//                    
//                    strongSelf.getProducerData(instrumental: instrumental, completion: {producerNames,producerImageURLs  in
//                        print("main infinite comeback \(producerNames), \(instrumental.instrumentalName)")
//                        do {
//                            if let url = URL.init(string: imageurl) {
//                                print("main infinite icurr \(icurr)")
//                                switch icurr {
//                                case 1:
//                                    MusicMainInfiniteScrollContentFeaturedArray1.append(name)
//                                    MusicMainInfiniteScrollContentFeaturedArray1.append(imageurl)
//                                    MusicMainInfiniteScrollContentFeaturedArray1.append(releaseDate)
//                                    MusicMainInfiniteScrollContentFeaturedArray1.append(previewURL)
//                                    MusicMainInfiniteScrollContentFeaturedArray1.append([""])
//                                    MusicMainInfiniteScrollContentFeaturedArray1.append(imageurl)
//                                    MusicMainInfiniteScrollContentFeaturedArray1.append([""])
//                                    MusicMainInfiniteScrollContentFeaturedArray1.append(producers)
//                                    MusicMainInfiniteScrollContentFeaturedArray1.append(producerNames)
//                                    MusicMainInfiniteScrollContentFeaturedArray1.append(producerImageURLs)
//                                    MusicMainInfiniteScrollContentFeaturedArray1.append(producers)
//                                    MusicMainInfiniteScrollContentFeaturedArray1.append(instrumental.videos)
//                                    MusicMainInfiniteScrollContentFeaturedArray1.append(instrumental)
//                                    counter+=1
//                                    if counter == content.count {
//                                        strongSelf.setupHC()
//                                        completion()
//                                    }
//                                case 2:
//                                    MusicMainInfiniteScrollContentFeaturedArray2.append(name)
//                                    MusicMainInfiniteScrollContentFeaturedArray2.append(imageurl)
//                                    MusicMainInfiniteScrollContentFeaturedArray2.append(releaseDate)
//                                    MusicMainInfiniteScrollContentFeaturedArray2.append(previewURL)
//                                    MusicMainInfiniteScrollContentFeaturedArray2.append([""])
//                                    MusicMainInfiniteScrollContentFeaturedArray2.append(imageurl)
//                                    MusicMainInfiniteScrollContentFeaturedArray2.append([""])
//                                    MusicMainInfiniteScrollContentFeaturedArray2.append(producers)
//                                    MusicMainInfiniteScrollContentFeaturedArray2.append(producerNames)
//                                    MusicMainInfiniteScrollContentFeaturedArray2.append(producerImageURLs)
//                                    MusicMainInfiniteScrollContentFeaturedArray2.append(producers)
//                                    MusicMainInfiniteScrollContentFeaturedArray2.append(instrumental.videos)
//                                    MusicMainInfiniteScrollContentFeaturedArray2.append(instrumental)
//                                    counter+=1
//                                    
//                                    if counter == content.count {
//                                        strongSelf.setupHC()
//                                        completion()
//                                    }
//                                case 3:
//                                    MusicMainInfiniteScrollContentFeaturedArray3.append(name )
//                                    MusicMainInfiniteScrollContentFeaturedArray3.append(imageurl)
//                                    MusicMainInfiniteScrollContentFeaturedArray3.append(releaseDate)
//                                    MusicMainInfiniteScrollContentFeaturedArray3.append(previewURL)
//                                    MusicMainInfiniteScrollContentFeaturedArray3.append([""])
//                                    MusicMainInfiniteScrollContentFeaturedArray3.append(imageurl)
//                                    MusicMainInfiniteScrollContentFeaturedArray3.append([""])
//                                    MusicMainInfiniteScrollContentFeaturedArray3.append(producers)
//                                    MusicMainInfiniteScrollContentFeaturedArray3.append(producerNames)
//                                    MusicMainInfiniteScrollContentFeaturedArray3.append(producerImageURLs)
//                                    MusicMainInfiniteScrollContentFeaturedArray3.append(producers)
//                                    MusicMainInfiniteScrollContentFeaturedArray3.append(instrumental.videos)
//                                    MusicMainInfiniteScrollContentFeaturedArray3.append(instrumental)
//                                    counter+=1
//                                    if counter == content.count {
//                                        strongSelf.setupHC()
//                                        completion()
//                                    }
//                                case 4:
//                                    MusicMainInfiniteScrollContentFeaturedArray4.append(name )
//                                    MusicMainInfiniteScrollContentFeaturedArray4.append(imageurl)
//                                    MusicMainInfiniteScrollContentFeaturedArray4.append(releaseDate)
//                                    MusicMainInfiniteScrollContentFeaturedArray4.append(previewURL)
//                                    MusicMainInfiniteScrollContentFeaturedArray4.append([""])
//                                    MusicMainInfiniteScrollContentFeaturedArray4.append(imageurl)
//                                    MusicMainInfiniteScrollContentFeaturedArray4.append([""])
//                                    MusicMainInfiniteScrollContentFeaturedArray4.append(producers)
//                                    MusicMainInfiniteScrollContentFeaturedArray4.append(producerNames)
//                                    MusicMainInfiniteScrollContentFeaturedArray4.append(producerImageURLs)
//                                    MusicMainInfiniteScrollContentFeaturedArray4.append(producers)
//                                    MusicMainInfiniteScrollContentFeaturedArray4.append(instrumental.videos)
//                                    MusicMainInfiniteScrollContentFeaturedArray4.append(instrumental)
//                                    counter+=1
//                                    if counter == content.count {
//                                        strongSelf.setupHC()
//                                        completion()
//                                    }
//                                case 5:
//                                    MusicMainInfiniteScrollContentFeaturedArray5.append(name )
//                                    MusicMainInfiniteScrollContentFeaturedArray5.append(imageurl)
//                                    MusicMainInfiniteScrollContentFeaturedArray5.append(releaseDate)
//                                    MusicMainInfiniteScrollContentFeaturedArray5.append(previewURL)
//                                    MusicMainInfiniteScrollContentFeaturedArray5.append([""])
//                                    MusicMainInfiniteScrollContentFeaturedArray5.append(imageurl)
//                                    MusicMainInfiniteScrollContentFeaturedArray5.append([""])
//                                    MusicMainInfiniteScrollContentFeaturedArray5.append(producers)
//                                    MusicMainInfiniteScrollContentFeaturedArray5.append(producerNames)
//                                    MusicMainInfiniteScrollContentFeaturedArray5.append(producerImageURLs)
//                                    MusicMainInfiniteScrollContentFeaturedArray5.append(producers)
//                                    MusicMainInfiniteScrollContentFeaturedArray5.append(instrumental.videos)
//                                    MusicMainInfiniteScrollContentFeaturedArray5.append(instrumental)
//                                    counter+=1
//                                    if counter == content.count {
//                                        strongSelf.setupHC()
//                                        completion()
//                                    }
//                                case 6:
//                                    MusicMainInfiniteScrollContentFeaturedArray6.append(name )
//                                    MusicMainInfiniteScrollContentFeaturedArray6.append(imageurl)
//                                    MusicMainInfiniteScrollContentFeaturedArray6.append(releaseDate)
//                                    MusicMainInfiniteScrollContentFeaturedArray6.append(previewURL)
//                                    MusicMainInfiniteScrollContentFeaturedArray6.append([""])
//                                    MusicMainInfiniteScrollContentFeaturedArray6.append(imageurl)
//                                    MusicMainInfiniteScrollContentFeaturedArray6.append([""])
//                                    MusicMainInfiniteScrollContentFeaturedArray6.append(producers)
//                                    MusicMainInfiniteScrollContentFeaturedArray6.append(producerNames)
//                                    MusicMainInfiniteScrollContentFeaturedArray6.append(producerImageURLs)
//                                    MusicMainInfiniteScrollContentFeaturedArray6.append(producers)
//                                    MusicMainInfiniteScrollContentFeaturedArray6.append(instrumental.videos)
//                                    MusicMainInfiniteScrollContentFeaturedArray6.append(instrumental)
//                                    counter+=1
//                                    if counter == content.count {
//                                        strongSelf.setupHC()
//                                        completion()
//                                    }
//                                case 7:
//                                    MusicMainInfiniteScrollContentFeaturedArray7.append(name )
//                                    MusicMainInfiniteScrollContentFeaturedArray7.append(imageurl)
//                                    MusicMainInfiniteScrollContentFeaturedArray7.append(releaseDate)
//                                    MusicMainInfiniteScrollContentFeaturedArray7.append(previewURL)
//                                    MusicMainInfiniteScrollContentFeaturedArray7.append([""])
//                                    MusicMainInfiniteScrollContentFeaturedArray7.append(imageurl)
//                                    MusicMainInfiniteScrollContentFeaturedArray7.append([""])
//                                    MusicMainInfiniteScrollContentFeaturedArray7.append(producers)
//                                    MusicMainInfiniteScrollContentFeaturedArray7.append(producerNames)
//                                    MusicMainInfiniteScrollContentFeaturedArray7.append(producerImageURLs)
//                                    MusicMainInfiniteScrollContentFeaturedArray7.append(producers)
//                                    MusicMainInfiniteScrollContentFeaturedArray7.append(instrumental.videos)
//                                    MusicMainInfiniteScrollContentFeaturedArray7.append(instrumental)
//                                    counter+=1
//                                    if counter == content.count {
//                                        strongSelf.setupHC()
//                                        completion()
//                                    }
//                                default:
//                                    print("Error")
//                                    //fatalError()
//                                }
//                            }
//                            
//                        } catch {
//                            print("catch erroe \(error)")
//                        }
//                    })
//                    
//                })
            case is AlbumData:
                let album = array as! AlbumData
                print("main infinite \(icurr), \(album.name)")
                name = album.name
                previewURL = ""
                songvideos = []
                if album.officialAlbumVideo != nil {
                    songvideos.append(album.officialAlbumVideo!)
                }
//                if !album.youtubeAltAlbumVideos.isEmpty {
//                    songvideos.append(contentsOf: album.youtubeAltAlbumVideos)
//                }
                if songvideos.isEmpty {
                    songvideos = [""]
                }
                guard let songvideos = songvideos else {return}
//                if album.spotifyData?.dateReleasedSpotify != "" {
//                    guard let date = album.spotifyData?.dateReleasedSpotify else {
//                        fatalError()}
//                    releaseDate = date
//                } else if album.appleData?.dateReleasedApple != "" {
//                    guard let date = album.appleData?.dateReleasedApple  else {
//                        fatalError()}
//                    releaseDate = date
//                }
                var songart:[String] = []
                for art in album.mainArtist {
                    let word = art.split(separator: "Æ")
                    let id = word[0]
                    songart.append(String(id))
                }
                var songapro:[String] = []
                for pro in album.producers {
                    let word = pro.split(separator: "Æ")
                    let id = word[0]
                    songapro.append(String(id))
                }
                artists = songart
                producers = songapro
//                if album.spotifyData?.imageURL != "" {
//                    guard let url = album.spotifyData?.imageURL else {
//                        fatalError()}
//                    imageurl = url
//                } else if album.appleData?.imageURL != "" {
//                    guard let url = album.appleData?.imageURL else {
//                        fatalError()}
//                    imageurl = url
//                }
                getArtistData(album: album, completion: { [weak self] artistNames,artistImageURLs  in
                    guard let strongSelf = self else {return}
                    strongSelf.getProducerData(album: album, completion: { producerNames,producerImageURLs  in
                        do {
                            if let url = URL.init(string: imageurl) {
                                print("main infinite icurr \(icurr)")
                                switch icurr {
                                case 1:
                                    MusicMainInfiniteScrollContentFeaturedArray1.append(name)
                                    MusicMainInfiniteScrollContentFeaturedArray1.append(imageurl)
                                    MusicMainInfiniteScrollContentFeaturedArray1.append(releaseDate)
                                    MusicMainInfiniteScrollContentFeaturedArray1.append(previewURL)
                                    MusicMainInfiniteScrollContentFeaturedArray1.append(artistNames)
                                    MusicMainInfiniteScrollContentFeaturedArray1.append(imageurl)
                                    MusicMainInfiniteScrollContentFeaturedArray1.append(artistImageURLs)
                                    MusicMainInfiniteScrollContentFeaturedArray1.append(artists)
                                    MusicMainInfiniteScrollContentFeaturedArray1.append(producerNames)
                                    MusicMainInfiniteScrollContentFeaturedArray1.append(producerImageURLs)
                                    MusicMainInfiniteScrollContentFeaturedArray1.append(producers)
                                    MusicMainInfiniteScrollContentFeaturedArray1.append(songvideos)
                                    MusicMainInfiniteScrollContentFeaturedArray1.append(album)
                                    counter+=1
                                    if counter == content.count {
                                        strongSelf.setupHC()
                                        completion()
                                    }
                                case 2:
                                    MusicMainInfiniteScrollContentFeaturedArray2.append(name)
                                    MusicMainInfiniteScrollContentFeaturedArray2.append(imageurl)
                                    MusicMainInfiniteScrollContentFeaturedArray2.append(releaseDate)
                                    MusicMainInfiniteScrollContentFeaturedArray2.append(previewURL)
                                    MusicMainInfiniteScrollContentFeaturedArray2.append(artistNames)
                                    MusicMainInfiniteScrollContentFeaturedArray2.append(imageurl)
                                    MusicMainInfiniteScrollContentFeaturedArray2.append(artistImageURLs)
                                    MusicMainInfiniteScrollContentFeaturedArray2.append(artists)
                                    MusicMainInfiniteScrollContentFeaturedArray2.append(producerNames)
                                    MusicMainInfiniteScrollContentFeaturedArray2.append(producerImageURLs)
                                    MusicMainInfiniteScrollContentFeaturedArray2.append(producers)
                                    MusicMainInfiniteScrollContentFeaturedArray2.append(songvideos)
                                    MusicMainInfiniteScrollContentFeaturedArray2.append(album)
                                    counter+=1
                                    
                                    if counter == content.count {
                                        strongSelf.setupHC()
                                        completion()
                                    }
                                case 3:
                                    MusicMainInfiniteScrollContentFeaturedArray3.append(name )
                                    MusicMainInfiniteScrollContentFeaturedArray3.append(imageurl)
                                    MusicMainInfiniteScrollContentFeaturedArray3.append(releaseDate)
                                    MusicMainInfiniteScrollContentFeaturedArray3.append(previewURL)
                                    MusicMainInfiniteScrollContentFeaturedArray3.append(artistNames)
                                    MusicMainInfiniteScrollContentFeaturedArray3.append(imageurl)
                                    MusicMainInfiniteScrollContentFeaturedArray3.append(artistImageURLs)
                                    MusicMainInfiniteScrollContentFeaturedArray3.append(artists)
                                    MusicMainInfiniteScrollContentFeaturedArray3.append(producerNames)
                                    MusicMainInfiniteScrollContentFeaturedArray3.append(producerImageURLs)
                                    MusicMainInfiniteScrollContentFeaturedArray3.append(producers)
                                    MusicMainInfiniteScrollContentFeaturedArray3.append(songvideos)
                                    MusicMainInfiniteScrollContentFeaturedArray3.append(album)
                                    counter+=1
                                    if counter == content.count {
                                        strongSelf.setupHC()
                                        completion()
                                    }
                                case 4:
                                    MusicMainInfiniteScrollContentFeaturedArray4.append(name )
                                    MusicMainInfiniteScrollContentFeaturedArray4.append(imageurl)
                                    MusicMainInfiniteScrollContentFeaturedArray4.append(releaseDate)
                                    MusicMainInfiniteScrollContentFeaturedArray4.append(previewURL)
                                    MusicMainInfiniteScrollContentFeaturedArray4.append(artistNames)
                                    MusicMainInfiniteScrollContentFeaturedArray4.append(imageurl)
                                    MusicMainInfiniteScrollContentFeaturedArray4.append(artistImageURLs)
                                    MusicMainInfiniteScrollContentFeaturedArray4.append(artists)
                                    MusicMainInfiniteScrollContentFeaturedArray4.append(producerNames)
                                    MusicMainInfiniteScrollContentFeaturedArray4.append(producerImageURLs)
                                    MusicMainInfiniteScrollContentFeaturedArray4.append(producers)
                                    MusicMainInfiniteScrollContentFeaturedArray4.append(songvideos)
                                    MusicMainInfiniteScrollContentFeaturedArray4.append(album)
                                    counter+=1
                                    if counter == content.count {
                                        strongSelf.setupHC()
                                        completion()
                                    }
                                case 5:
                                    MusicMainInfiniteScrollContentFeaturedArray5.append(name )
                                    MusicMainInfiniteScrollContentFeaturedArray5.append(imageurl)
                                    MusicMainInfiniteScrollContentFeaturedArray5.append(releaseDate)
                                    MusicMainInfiniteScrollContentFeaturedArray5.append(previewURL)
                                    MusicMainInfiniteScrollContentFeaturedArray5.append(artistNames)
                                    MusicMainInfiniteScrollContentFeaturedArray5.append(imageurl)
                                    MusicMainInfiniteScrollContentFeaturedArray5.append(artistImageURLs)
                                    MusicMainInfiniteScrollContentFeaturedArray5.append(artists)
                                    MusicMainInfiniteScrollContentFeaturedArray5.append(producerNames)
                                    MusicMainInfiniteScrollContentFeaturedArray5.append(producerImageURLs)
                                    MusicMainInfiniteScrollContentFeaturedArray5.append(producers)
                                    MusicMainInfiniteScrollContentFeaturedArray5.append(songvideos)
                                    MusicMainInfiniteScrollContentFeaturedArray5.append(album)
                                    counter+=1
                                    if counter == content.count {
                                        strongSelf.setupHC()
                                        completion()
                                    }
                                case 6:
                                    MusicMainInfiniteScrollContentFeaturedArray6.append(name )
                                    MusicMainInfiniteScrollContentFeaturedArray6.append(imageurl)
                                    MusicMainInfiniteScrollContentFeaturedArray6.append(releaseDate)
                                    MusicMainInfiniteScrollContentFeaturedArray6.append(previewURL)
                                    MusicMainInfiniteScrollContentFeaturedArray6.append(artistNames)
                                    MusicMainInfiniteScrollContentFeaturedArray6.append(imageurl)
                                    MusicMainInfiniteScrollContentFeaturedArray6.append(artistImageURLs)
                                    MusicMainInfiniteScrollContentFeaturedArray6.append(artists)
                                    MusicMainInfiniteScrollContentFeaturedArray6.append(producerNames)
                                    MusicMainInfiniteScrollContentFeaturedArray6.append(producerImageURLs)
                                    MusicMainInfiniteScrollContentFeaturedArray6.append(producers)
                                    MusicMainInfiniteScrollContentFeaturedArray6.append(songvideos)
                                    MusicMainInfiniteScrollContentFeaturedArray6.append(album)
                                    counter+=1
                                    if counter == content.count {
                                        strongSelf.setupHC()
                                        completion()
                                    }
                                case 7:
                                    MusicMainInfiniteScrollContentFeaturedArray7.append(name )
                                    MusicMainInfiniteScrollContentFeaturedArray7.append(imageurl)
                                    MusicMainInfiniteScrollContentFeaturedArray7.append(releaseDate)
                                    MusicMainInfiniteScrollContentFeaturedArray7.append(previewURL)
                                    MusicMainInfiniteScrollContentFeaturedArray7.append(artistNames)
                                    MusicMainInfiniteScrollContentFeaturedArray7.append(imageurl)
                                    MusicMainInfiniteScrollContentFeaturedArray7.append(artistImageURLs)
                                    MusicMainInfiniteScrollContentFeaturedArray7.append(artists)
                                    MusicMainInfiniteScrollContentFeaturedArray7.append(producerNames)
                                    MusicMainInfiniteScrollContentFeaturedArray7.append(producerImageURLs)
                                    MusicMainInfiniteScrollContentFeaturedArray7.append(producers)
                                    MusicMainInfiniteScrollContentFeaturedArray7.append(songvideos)
                                    MusicMainInfiniteScrollContentFeaturedArray7.append(album)
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
                            
                        } catch {
                            print("catch erroe \(error)")
                        }
                    })
                    
                })
            default:
                print("erroe")
            }
        }
    }
    
    func fetchMainInfiniteScrollContent(completion: @escaping () -> Void) {
        DispatchQueue.global(qos: .userInitiated).async {
            DatabaseManager.shared.getMusicMainInfiniteScrollContent(completion: {[weak self] content in
                guard let strongSelf = self else {return}
                print(content)
                
                strongSelf.setArraysForInfiniteScroll(content, strongSelf, completion: {
                    completion()
                })
                //print(MusicMainInfiniteScrollContentFeaturedArray)
            })
        }
        
        
    }
    
    func latestSongsDateArryForLoop(_ content: [SongData], completion: @escaping (Array<MusicLatestSongPrepData>) -> Void) {
        var earliestDate:Date!
        var dateArray:Array<MusicLatestSongPrepData> = []
        var loopcount = 0
        for song in content {
            //print(song.name)
            Comparisons.shared.getLatestReleaseDate(song: song, completion: { date in
                earliestDate = date
                let prep = MusicLatestSongPrepData(date: earliestDate, name: song.name)
                dateArray.append(prep)
                MusicLatestSongsContentArray.append(song)
                loopcount+=1
                //print(loopcount, content.count)
                if loopcount == content.count {
                    
                    completion(dateArray)
                }
            })
        }
    }
    
    func fetchLatestSongsContent(completion: @escaping () -> Void) {
        DispatchQueue.global(qos: .userInitiated).async {
            var earliestDate:Date!
            var prep:[MusicLatestSongPrepData] = []
            DatabaseManager.shared.getMusicLatestSongsContent(completion: {[weak self] content in
                guard let strongSelf = self else {return}
                for soooo in content {
                    print(soooo.name)
                }
                
                strongSelf.latestSongsDateArryForLoop(content, completion: { das in
                    prep = das
                    
                    prep.sort(by: {$0.date > $1.date})
                    print(prep)
                    var forcount = 0
                    for song in content {
                        Comparisons.shared.getLatestReleaseDate(song: song, completion: { date in
                            
                            earliestDate = date
                            if earliestDate == prep[0].date && song.name == prep[0].name {
                                MusicLatestSongsContentArray.remove(at: 0)
                                MusicLatestSongsContentArray.insert(song, at: 0)
                                //print(forcount, song.name)
                                forcount+=1
                                if forcount == content.count {
                                    strongSelf.hideskeleton(tableview: strongSelf.musicLatestSongsTableView)
                                    completion()
                                }
                            }
                            else if earliestDate == prep[1].date && song.name == prep[1].name {
                                MusicLatestSongsContentArray.remove(at:1)
                                MusicLatestSongsContentArray.insert(song, at: 1)
                                //print(forcount, song.name)
                                forcount+=1
                                if forcount == content.count {
                                    strongSelf.hideskeleton(tableview: strongSelf.musicLatestSongsTableView)
                                    completion()
                                }
                            }
                            else if earliestDate == prep[2].date && song.name == prep[2].name {
                                MusicLatestSongsContentArray.remove(at: 2)
                                MusicLatestSongsContentArray.insert(song, at: 2)
                                //print(forcount, song.name)
                                forcount+=1
                                if forcount == content.count {
                                    strongSelf.hideskeleton(tableview: strongSelf.musicLatestSongsTableView)
                                    completion()
                                }
                            }
                            else if earliestDate == prep[3].date && song.name == prep[3].name {
                                MusicLatestSongsContentArray.remove(at: 3)
                                MusicLatestSongsContentArray.insert(song, at: 3)
                                //print(forcount, song.name)
                                forcount+=1
                                if forcount == content.count {
                                    strongSelf.hideskeleton(tableview: strongSelf.musicLatestSongsTableView)
                                    completion()
                                }
                            }
                            else if earliestDate == prep[4].date && song.name == prep[4].name {
                                    MusicLatestSongsContentArray.remove(at: 4)
                                    MusicLatestSongsContentArray.insert(song, at: 4)
                                    //print(forcount, song.name)
                                    forcount+=1
                                    if forcount == content.count {
                                        strongSelf.hideskeleton(tableview: strongSelf.musicLatestSongsTableView)
                                        completion()
                                    }
                            }
                            else if earliestDate == prep[5].date && song.name == prep[5].name {
                                MusicLatestSongsContentArray.remove(at: 5)
                                MusicLatestSongsContentArray.insert(song, at: 5)
                                //print(forcount, song.name)
                                forcount+=1
                                if forcount == content.count {
                                    strongSelf.hideskeleton(tableview: strongSelf.musicLatestSongsTableView)
                                    completion()
                                }
                            }
                            else if earliestDate == prep[6].date && song.name == prep[6].name {
                                MusicLatestSongsContentArray.remove(at:6)
                                MusicLatestSongsContentArray.insert(song, at: 6)
                                //print(forcount, song.name)
                                forcount+=1
                                if forcount == content.count {
                                    strongSelf.hideskeleton(tableview: strongSelf.musicLatestSongsTableView)
                                    completion()
                                }
                            }
                            else if earliestDate == prep[7].date && song.name == prep[7].name {
                                MusicLatestSongsContentArray.remove(at: 7)
                                MusicLatestSongsContentArray.insert(song, at: 7)
                                //print(forcount, song.name)
                                forcount+=1
                                if forcount == content.count {
                                    strongSelf.hideskeleton(tableview: strongSelf.musicLatestSongsTableView)
                                    completion()
                                }
                            }
                            else if earliestDate == prep[8].date && song.name == prep[8].name {
                                MusicLatestSongsContentArray.remove(at: 8)
                                MusicLatestSongsContentArray.insert(song, at: 8)
                                //print(forcount, song.name)
                                forcount+=1
                                if forcount == content.count {
                                    strongSelf.hideskeleton(tableview: strongSelf.musicLatestSongsTableView)
                                    completion()
                                }
                            }
                            else if earliestDate == prep[9].date && song.name == prep[9].name {
                                    MusicLatestSongsContentArray.remove(at: 9)
                                    MusicLatestSongsContentArray.insert(song, at: 9)
                                    //print(forcount, song.name)
                                    forcount+=1
                                    if forcount == content.count {
                                        strongSelf.hideskeleton(tableview: strongSelf.musicLatestSongsTableView)
                                        completion()
                                    }
                            }
                            else if earliestDate == prep[10].date && song.name == prep[10].name {
                                MusicLatestSongsContentArray.remove(at: 10)
                                MusicLatestSongsContentArray.insert(song, at: 10)
                                //print(forcount, song.name)
                                forcount+=1
                                if forcount == content.count {
                                    strongSelf.hideskeleton(tableview: strongSelf.musicLatestSongsTableView)
                                    completion()
                                }
                            }
                            else if earliestDate == prep[11].date && song.name == prep[11].name {
                                MusicLatestSongsContentArray.remove(at:11)
                                MusicLatestSongsContentArray.insert(song, at: 11)
                                //print(forcount, song.name)
                                forcount+=1
                                if forcount == content.count {
                                    strongSelf.hideskeleton(tableview: strongSelf.musicLatestSongsTableView)
                                    completion()
                                }
                            }
                            else if earliestDate == prep[12].date && song.name == prep[12].name {
                                MusicLatestSongsContentArray.remove(at: 12)
                                MusicLatestSongsContentArray.insert(song, at: 12)
                                //print(forcount, song.name)
                                forcount+=1
                                if forcount == content.count {
                                    strongSelf.hideskeleton(tableview: strongSelf.musicLatestSongsTableView)
                                    completion()
                                }
                            }
                            else if earliestDate == prep[13].date && song.name == prep[13].name {
                                MusicLatestSongsContentArray.remove(at: 13)
                                MusicLatestSongsContentArray.insert(song, at: 13)
                                //print(forcount, song.name)
                                forcount+=1
                                if forcount == content.count {
                                    strongSelf.hideskeleton(tableview: strongSelf.musicLatestSongsTableView)
                                    completion()
                                }
                            }
                            else if earliestDate == prep[14].date && song.name == prep[14].name {
                                    MusicLatestSongsContentArray.remove(at: 14)
                                    MusicLatestSongsContentArray.insert(song, at: 14)
                                    //print(forcount, song.name)
                                    forcount+=1
                                    if forcount == content.count {
                                        strongSelf.hideskeleton(tableview: strongSelf.musicLatestSongsTableView)
                                        completion()
                                    }
                            }
                        })
                    }
                })
            })
        }
    }
    
    func fetchLatestVideosContent(completion: @escaping () -> Void) {
        DispatchQueue.global(qos: .userInitiated).async {
            var earliestDate:Date!
            var dateArray:Array<Date> = []
            DatabaseManager.shared.getMusicLatestVideosContent(completion: {[weak self] content in
                guard let strongSelf = self else {return}
                var loopcount = 0
                for video in content {
                    switch video {
                    case is YouTubeData:
                        let video = video as! YouTubeData
                        let date = video.dateYT
                        let vdate = date.date(format: "MM dd, yyyy")
                        guard let ytdate = vdate else {return}
                        dateArray.append(ytdate)
                        MusicLatestVideosContentArray.append(video)
                        loopcount+=1
                        if loopcount == content.count {
                            
                        }
                    default:
                        print("Data Error fetching latest video content.")
                    }
                }
                dateArray.sort(by: { $0.compare($1) == .orderedDescending })
                //print(dateArray)
                for video in content {
                    if video is YouTubeData {
                        let video = video as! YouTubeData
                        let date = video.dateYT
                        let vdate = date.date(format: "MM dd, yyyy")
                        earliestDate = vdate
                    }
                    if earliestDate == dateArray[0] {
                        MusicLatestVideosContentArray.remove(at: 0)
                        MusicLatestVideosContentArray.insert(video, at: 0)
                    }
                    else if earliestDate == dateArray[1] {
                        MusicLatestVideosContentArray.remove(at:1)
                        MusicLatestVideosContentArray.insert(video, at: 1)
                    } else if earliestDate == dateArray[2] {
                        MusicLatestVideosContentArray.remove(at: 2)
                        MusicLatestVideosContentArray.insert(video, at: 2)
                    }
                }
                strongSelf.hideskeleton(tableview: strongSelf.latestVideosTableView)
                completion()
            })
        }
    }
    
    func fetchFeaturedArtistContent(completion: @escaping () -> Void) {
        DispatchQueue.global().async {
            DatabaseManager.shared.getRandomArtist(num: 14, completion: {[weak self] content in
                guard let strongSelf = self else {return}
                var allart:[ArtistData] = []
                var tick = 0
                for art in content {
                    let word = art.split(separator: "Æ")
                    let id = word[0]
                    DatabaseManager.shared.fetchArtistData(artist: String(id), completion: { artist in
                        allart.append(artist)
                        tick+=1
                        if tick == content.count {
                            MusicFeaturedArtistContentArray = allart
                            strongSelf.hideskeleton(tableview: strongSelf.featuredArtistTableView)
                            completion()
                        }
                    })
                }
            })
        }
    }
    
    func setFeaturedInstrumentals(completion: @escaping () -> Void) {
        DispatchQueue.global().async {
            DatabaseManager.shared.getMusicInstrumentalContent(completion: {[weak self] content in
                guard let strongSelf = self else {return}
                
                MusicInstrumentalContentArray = content
                strongSelf.hideskeleton(tableview: strongSelf.instrumentalTableView)
                completion()
            })
        }
    }
    
    @objc func seg(notification: Notification) {
        //print("seging")
        infoDetailContent = notification.object
        performSegue(withIdentifier: "musicToInfo", sender: nil)
    }
    
    @objc func transitionToArtistInfoFromNotify(notification: Notification) {
        artistInfo = notification.object as! ArtistData
        performSegue(withIdentifier: "musicToArt", sender: nil)
    }
    
    @objc func transitionToProducerInfoFromNotify(notification: Notification) {
        producerInfo = notification.object as! ProducerData
        performSegue(withIdentifier: "musicToPro", sender: nil)
    }
    
    @objc func transitionToYoutubeInfoFromNotify(notification: Notification) {
        transitionToYoutube()
    }
    
    func transitionToArtistInfo() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc2 = storyboard.instantiateViewController(identifier: "ArtistInfoViewController") as! ArtistInfoViewController
        self.navigationController?.pushViewController(vc2, animated: true)
    }
    
    func transitionToProducerInfo() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc2 = storyboard.instantiateViewController(identifier: "ProducerInfoViewController") as! ProducerInfoViewController
        self.navigationController?.pushViewController(vc2, animated: true)
    }
    
    func transitionToYoutube() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc3 = storyboard.instantiateViewController(identifier: "youtubePlayerVC") as YoutubeVideoPlayerViewController
        self.present(vc3, animated: true, completion: nil)
        //self.navigationController?.pushViewController(vc3, animated: true)
    }
    
    @IBAction func allSongsTapp(_ sender: Any) {
        allOfContent = "song"
        performSegue(withIdentifier: "musicToAllOf", sender: nil)
    }
    
    @IBAction func allArtistsTapped(_ sender: Any) {
        allOfContent = "artist"
        performSegue(withIdentifier: "musicToAllOf", sender: nil)
    }
    
    @IBAction func allVideosTapped(_ sender: Any) {
        allOfContent = "video"
        performSegue(withIdentifier: "musicToAllOf", sender: nil)
    }
    
    @IBAction func allInstrumentalsTapped(_ sender: Any) {
        allOfContent = "instrumental"
        performSegue(withIdentifier: "musicToAllOf", sender: nil)
    }
    
}

extension MusicAllViewController: UIScrollViewDelegate {
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
                //print(strongSelf.lastContentOffset)
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
                    //print(strongSelf.lastContentOffset)
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

extension MusicAllViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == musicLatestSongsTableView {
            musicTableHeight = 427.5
        } else if tableView == latestVideosTableView {
            musicTableHeight = 200
        } else if tableView == instrumentalTableView {
            musicTableHeight = 80
        }else {
            musicTableHeight = 240
        }
        return musicTableHeight//Your custom row height
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var numberOfRow = 1
        switch tableView {
        case musicLatestSongsTableView:
            numberOfRow = 1
        case featuredArtistTableView:
            numberOfRow = 1
        case latestVideosTableView:
            numberOfRow = 3
        case instrumentalTableView:
            numberOfRow = 5
        default:
            print("Some things Wrong!!")
        }
        return numberOfRow
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == musicLatestSongsTableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: "latestSongsMusicCell", for: indexPath) as! LatestSongsTableCellController
            if MusicLatestSongsContentArray.count == 15 {
                //cell.lscollectionView.reloadData()
                cell.funcSetTemp()
            }
            return cell
        } else if tableView == latestVideosTableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: "latestVideosMusicCell", for: indexPath) as! LatestVideosTableCellController
            if !MusicLatestVideosContentArray.isEmpty {
                let array = MusicLatestVideosContentArray[indexPath.row]
                cell.funcSetTemp(array: array)
            }
            return cell
        } else if tableView == instrumentalTableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: "instrumentalsMusicCell", for: indexPath) as! InstrumentalsTableCellController
            if !MusicInstrumentalContentArray.isEmpty {
                let array = MusicInstrumentalContentArray[indexPath.row]
                cell.funcSetTemp(array: array)
            }
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "featuredArtistCollectionMusicCell", for: indexPath) as! FeaturedArtistsTableCellController
            if !MusicFeaturedArtistContentArray.isEmpty {
                cell.funcSetTemp()
            }
            return cell
        }
    }
    
    func collectionSkeletonView(_ skeletonView: UITableView, cellIdentifierForRowAt indexPath: IndexPath) -> ReusableCellIdentifier {
        if skeletonView == musicLatestSongsTableView {
            return "latestSongsMusicCell"
        } else if skeletonView == latestVideosTableView {
            return "latestVideosMusicCell"
        } else if skeletonView == instrumentalTableView {
            return "instrumentalsMusicCell"
        } else {
            return "featuredArtistCollectionMusicCell"
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
            tableView.deselectRow(at: indexPath, animated: false)
            if tableView == musicLatestSongsTableView {
                let song = MusicLatestSongsContentArray[indexPath.row]
                infoDetailContent = song
                performSegue(withIdentifier: "musicToInfo", sender: nil)
                
            } else if tableView == instrumentalTableView {
                let beat = MusicInstrumentalContentArray[indexPath.row]
                infoDetailContent = beat
                performSegue(withIdentifier: "musicToInfo", sender: nil)
                
        } else if tableView == latestVideosTableView {
            let vid = MusicLatestVideosContentArray[indexPath.row]
            switch vid {
            case is YouTubeData:
                let video = vid as! YouTubeData
                infoDetailContent = video
                performSegue(withIdentifier: "musicToInfo", sender: nil)
            default:
                print("sumn else dawg")
            }
        }
        
    }
}

class LatestSongsTableViewControlller: UITableView {
    override var intrinsicContentSize: CGSize {
        layoutIfNeeded()
        return CGSize(width: UIView.noIntrinsicMetric, height: 427.5)
    }
}

class LatestSongsTableCellController: UITableViewCell {
    @IBOutlet weak var page: UIPageControl!
    @IBOutlet weak var lscollectionView: UICollectionView!
    
    func funcSetTemp() {
        page.numberOfPages = 3
        lscollectionView.delegate = self
        lscollectionView.dataSource = self
    }
}

extension LatestSongsTableCellController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
        
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //selectedArtist = MusicFeaturedArtistContentArray[indexPath.item]
        //print(indexPath.item)
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "latestSongsCollectionCellController", for: indexPath) as! LatestSongsCollectionCellController
        if MusicLatestSongsContentArray.count == 15 {
            var array:[SongData] = []
            print("secccc \(indexPath.row)")
            switch indexPath.row {
            case 0:
                array.append(MusicLatestSongsContentArray[0])
                array.append(MusicLatestSongsContentArray[1])
                array.append(MusicLatestSongsContentArray[2])
                array.append(MusicLatestSongsContentArray[3])
                array.append(MusicLatestSongsContentArray[4])
            case 1:
                array.append(MusicLatestSongsContentArray[5])
                array.append(MusicLatestSongsContentArray[6])
                array.append(MusicLatestSongsContentArray[7])
                array.append(MusicLatestSongsContentArray[8])
                array.append(MusicLatestSongsContentArray[9])
            default:
                array.append(MusicLatestSongsContentArray[10])
                array.append(MusicLatestSongsContentArray[11])
                array.append(MusicLatestSongsContentArray[12])
                array.append(MusicLatestSongsContentArray[13])
                array.append(MusicLatestSongsContentArray[14])
            }
            
            cell.funcSetTemp(array: array)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: lscollectionView.frame.width, height: 400)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        page?.currentPage = Int(scrollView.contentOffset.x) / Int(scrollView.frame.width)
        lightImpactGenerator.impactOccurred()
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        lightImpactGenerator.impactOccurred()
        page?.currentPage = Int(scrollView.contentOffset.x) / Int(scrollView.frame.width)
    }
    

    
}

class LatestSongsCollectionCellController: UICollectionViewCell {
    
    @IBOutlet weak var latestSongsListTableView: UITableView!
    var songArray:[SongData]!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
    }
    
    override var isHighlighted: Bool {
        didSet{
            tapScale(cell: self, down: isHighlighted)
        }
    }
    
    func funcSetTemp(array: [SongData]) {
        songArray = array
        latestSongsListTableView.delegate = self
        latestSongsListTableView.dataSource = self
    }
}

extension LatestSongsCollectionCellController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "latestSongsListTableCellController", for: indexPath) as! LatestSongsListTableCellController
        let song = songArray[indexPath.row]
        cell.funcSetTemp(array: song)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        let song = songArray[indexPath.row]
        NotificationCenter.default.post(name: transitionMusicToDetailInfoNotify, object: song)
    }
    
    
}

class LatestSongsListTableViewController: UITableView {
    override var intrinsicContentSize: CGSize {
        layoutIfNeeded()
        return CGSize(width: UIView.noIntrinsicMetric, height: 400)
    }
}

class LatestSongsListTableCellController: UITableViewCell {
    
    @IBOutlet weak var songName: UILabel!
    @IBOutlet weak var artistNameLabel: UILabel!
    @IBOutlet weak var artworkImageView: UIImageView!
    @IBOutlet weak var releaseDateLabel: UILabel!
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var favoriteHeart: UIButton!
    override func prepareForReuse() {
        artworkImageView.image = nil
        songName.text = ""
        artistNameLabel.text = ""
        releaseDateLabel.text = ""
        favoriteHeart.setImage(UIImage(systemName: "heart"), for: .normal)
        favoriteHeart.tintColor = .white
        favorited = false
    }
    
    var favorited = false
    var prevurl:String!
    var urlPlayable:URL!
    var currentSong:SongData!
    var artimage:UIImage!
    var artNames:[String]!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    fileprivate func getArtistData(song:SongData, completion: @escaping (Array<String>) -> Void) {
        var artistNameData:Array<String> = []
        var val = 0
        for artist in song.songArtist {
            let id = artist
            val+=1
            artistNameData.append(String(id))
            if val == song.songArtist.count {
                completion(artistNameData)
            }
        }
        
    }
    
    func getSongYoutubeData(song:SongData, completion: @escaping (Array<YouTubeData>, Array<String>) -> Void) {
        var videosData:Array<YouTubeData> = []
        var youtubeimageURLs:Array<String> = []
        var val = 1
        if !song.videos!.isEmpty {
            if song.videos![0] != "" {
                for video in song.videos! {
                    let word = video.split(separator: "Æ")
                    let id = word[0]
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
                            if val == song.songArtist.count {
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
    
    func funcSetTemp(array: SongData) {
        currentSong = array
        songName.text = array.name
        getArtistData(song: array, completion: { [weak self] artistNames in
            guard let strongSelf = self else {return}
            strongSelf.artNames = artistNames
            strongSelf.artistNameLabel.text = artistNames.joined(separator: ", ")
            strongSelf.artworkImageView.layer.cornerRadius = 4
            var imageurl = ""
            GlobalFunctions.shared.selectImageURL(song: array, completion: {ur in
                imageurl = ur!
                if let url = URL.init(string: imageurl) {
                    if let cachedImage = imageCache.object(forKey: url.absoluteString as NSString) {
                        strongSelf.artworkImageView.image = cachedImage
                    } else {
                        strongSelf.artworkImageView.setImage(from: url, withPlaceholder: UIImage(named: "tonedeaflogo"))
                    }
                }
                Comparisons.shared.getEarliestReleaseDate(song: array, completion: { edate in
                    strongSelf.releaseDateLabel.text = "Released On: \(edate)"
                })
            })
        })
        for favorite in currentAppUser.favorites {
            if favorite.dbid.contains(currentSong.toneDeafAppId) {
                favorited = true
                favoriteHeart.setImage(UIImage(systemName: "heart.fill"), for: .normal)
                favoriteHeart.tintColor = Constants.Colors.redApp
            }
        }
    }
    
    func setPreviewButton(array: SongData) -> String {
        currentSong = array
        if let prevurl = array.apple?.applePreviewURL {
            if let url  = URL.init(string: prevurl){
                urlPlayable = url
            }
        } else
        if let prevurl = array.spotify?.spotifyPreviewURL {
            if let url  = URL.init(string: prevurl){
                urlPlayable = url
            }
        }
        return prevurl
    }
    
    func getArtwork(song: SongData) -> UIImage{
        var imageurl = ""
        getSongYoutubeData(song: song, completion: { videos,videothumbnails in
            if song.spotify?.spotifyArtworkURL != "" {
                imageurl = song.spotify!.spotifyArtworkURL
            } else if song.apple?.appleArtworkURL != "" {
                imageurl = song.apple!.appleArtworkURL
            } else if !videothumbnails.isEmpty {
                imageurl = videothumbnails[0]
            }
        })
        
        do {
            if let url = URL.init(string: imageurl) {
                let data = try Data.init(contentsOf: url)
                artimage = UIImage(data: data) ?? UIImage(named: "tonedeaflogo")!
            }
            
            
        } catch{
            
        }
        return artimage
        
        
    }

    @IBAction func favoriteTapped(_ sender: Any) {
        switch favorited {
        case true:
            favorited = false
            favoriteHeart.setImage(UIImage(systemName: "heart"), for: .normal)
            favoriteHeart.tintColor = .white
            let id = "\(currentSong.toneDeafAppId)Æ\(currentSong.name)"
            var newfav:[UserFavorite] = []
            for fav in currentAppUser.favorites {
                if fav.dbid != id {
                    newfav.append(fav)
                }
            }
            if currentSong.albums != [""] {
                for album in currentSong.albums! {
                    let word = album.split(separator: "Æ")
                    let id = word[0]
                    DatabaseManager.shared.findAlbumById(albumId: String(id), completion: { result in
                        switch result {
                        case .success(let albumdata):
                            var mainArtistsNames:Array<String> = []
                            for artist in albumdata.mainArtist {
                                let word = artist.split(separator: "Æ")
                                let id = word[1]
                                mainArtistsNames.append(String(id))
                            }
                            let albumcategorty = "\(albumContentTag)--\(albumdata.name)--\(mainArtistsNames.joined(separator: ", "))--\(albumdata.toneDeafAppId)"
                            DatabaseManager.shared.getAlbumFavorites(currentAlbum: albumdata, completion: { favs in
                                var num = favs
                                num-=1
                                Database.database().reference().child("Music Content").child("Albums").child(albumcategorty).child("REQUIRED").child("Number of Favorites Overall").setValue(num)
                            })
                        case .failure(let err):
                            print("err \(err)")
                        }
                    })
                }
            }
            currentAppUser.favorites = newfav
            Database.database().reference().child("Users").child(currentAppUser.uid).child("Favorites").child(id).removeValue()
            let categorty = "\(songContentTag)--\(currentSong.name)--\(artNames.joined(separator: ", "))--\(currentSong.toneDeafAppId)"
            DatabaseManager.shared.getSongFavorites(currentSong: currentSong, completion: { favs in
                var num = favs
                num-=1
                Database.database().reference().child("Music Content").child("Songs").child(categorty).child("REQUIRED").child("Number of Favorites Overall").setValue(num)
            })
        default:
            favorited = true
            lightImpactGenerator.impactOccurred()
            tapScale(button: favoriteHeart)
            favoriteHeart.setImage(UIImage(systemName: "heart.fill"), for: .normal)
            favoriteHeart.tintColor = Constants.Colors.redApp
            let id = "\(currentSong.toneDeafAppId)Æ\(currentSong.name)"
            let datee = getCurrentLocalDate()
            let dateFormatter = DateFormatter()
            dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
            let date = dateFormatter.date(from:datee)!
            if currentSong.albums != [""] {
                for album in currentSong.albums! {
                    let word = album.split(separator: "Æ")
                    let id = word[0]
                    DatabaseManager.shared.findAlbumById(albumId: String(id), completion: { result in
                        switch result {
                        case .success(let albumdata):
                            var mainArtistsNames:Array<String> = []
                            for artist in albumdata.mainArtist {
                                let word = artist.split(separator: "Æ")
                                let id = word[1]
                                mainArtistsNames.append(String(id))
                            }
                            let albumcategorty = "\(albumContentTag)--\(albumdata.name)--\(mainArtistsNames.joined(separator: ", "))--\(albumdata.toneDeafAppId)"
                            DatabaseManager.shared.getAlbumFavorites(currentAlbum: albumdata, completion: { favs in
                                var num = favs
                                num+=1
                                Database.database().reference().child("Music Content").child("Albums").child(albumcategorty).child("REQUIRED").child("Number of Favorites Overall").setValue(num)
                            })
                        case .failure(let err):
                            print("err \(err)")
                        }
                    })
                }
            }
            currentAppUser.favorites.append(UserFavorite(dbid: id, timestamp: date))
            Database.database().reference().child("Users").child(currentAppUser.uid).child("Favorites").child(id).child("Timestamp").setValue(datee)
            let categorty = "\(songContentTag)--\(currentSong.name)--\(artNames.joined(separator: ", "))--\(currentSong.toneDeafAppId)"
            DatabaseManager.shared.getSongFavorites(currentSong: currentSong, completion: { favs in
                var num = favs
                num+=1
                print(num)
                Database.database().reference().child("Music Content").child("Songs").child(categorty).child("REQUIRED").child("Number of Favorites Overall").setValue(num)
            })
        }
    }
    @IBAction func shareButtonTapped(_ sender: Any) {
        
    }
}

class FeaturedArtistsTableViewControlller: UITableView {
    override var intrinsicContentSize: CGSize {
        layoutIfNeeded()
        return CGSize(width: UIView.noIntrinsicMetric, height: contentSize.height)
    }
}

class FeaturedArtistsTableCellController: UITableViewCell {
    
    @IBOutlet weak var collectionView: UICollectionView!
    var selectedArtist:ArtistData!
    
    func funcSetTemp() {
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
}

extension FeaturedArtistsTableCellController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
        
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return MusicFeaturedArtistContentArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        selectedArtist = MusicFeaturedArtistContentArray[indexPath.item]
        //print(indexPath.item)
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "musicFeaturedArtistCollectionCell", for: indexPath) as! ArtistsCollectionViewCellController
        cell.funcSetTemp(artist: selectedArtist)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let art = MusicFeaturedArtistContentArray[indexPath.item]
        collectionView.deselectItem(at: indexPath, animated: true)
        NotificationCenter.default.post(name: transitionFromMusicToArtistInfoNotify, object: art)
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100, height: 100)
    }
    

    
}

class ArtistsCollectionViewCellController: UICollectionViewCell {
    
    @IBOutlet weak var artistImage: UIImageView!
    @IBOutlet weak var artistName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        artistImage.image = nil
    }
    
    override var isHighlighted: Bool {
        didSet{
            tapScale(cell: self, down: isHighlighted)
        }
    }
    
    func funcSetTemp(artist: ArtistData) {
        artistImage.layer.cornerRadius = 37.5
        artistImage.contentMode = .scaleAspectFill
        artistName.text = artist.name
        GlobalFunctions.shared.selectImageURL(artist: artist, completion: {[weak self] ur in
            guard let strongSelf = self else {return}
            guard let url = ur else {
                strongSelf.artistImage.image = UIImage(named: "defaultimage")
                return
            }
            let imageURL = URL(string: url)!
            if let cachedImage = imageCache.object(forKey: imageURL.absoluteString as NSString) {
                strongSelf.artistImage.image = cachedImage
            } else {
                strongSelf.artistImage.setImage(from: imageURL, withPlaceholder: UIImage(named: "tonedeaflogo"))
            }
        })
    }
}

class LatestVideosTableViewControlller: UITableView {
    override var intrinsicContentSize: CGSize {
        layoutIfNeeded()
        return CGSize(width: UIView.noIntrinsicMetric, height: contentSize.height)
    }
}

class LatestVideosTableCellController: UITableViewCell {
    
    @IBOutlet weak var videoCellView: UIView!
    @IBOutlet weak var channelTitle: UILabel!
    @IBOutlet weak var artistInvolvedLabel: UILabel!
    @IBOutlet weak var videoTitle: UILabel!
    @IBOutlet weak var releaseDateLabel: UILabel!
    @IBOutlet weak var videoThumbnail: UIImageView!
    @IBOutlet weak var videoDescriptionTextView: UITextView!
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var moreButton: UIButton!
    
    var favorited = false
    var currentVideo:AnyObject!
    
    override func prepareForReuse() {
        favoriteButton.setImage(UIImage(systemName: "heart"), for: .normal)
        favoriteButton.tintColor = .white
        favorited = false
    }
    
    fileprivate func getArtistData(video:AnyObject, completion: @escaping (Array<String>) -> Void) {
        var artistNameData:Array<String> = []
        var val = 0
        switch video {
        case is YouTubeData:
            let video = video as! YouTubeData
//            for artist in video.artist {
//
//                let word = artist.split(separator: "Æ")
//                let id = word[1]
//                val+=1
//                artistNameData.append(String(id))
//                if val == video.artist.count {
//                    completion(artistNameData)
//                }
//            }
        default:
            print("bs")
        }
        
    }
    
    func getSongYoutubeData(song:SongData, completion: @escaping (Array<YouTubeData>, Array<String>) -> Void) {
        var videosData:Array<YouTubeData> = []
        var youtubeimageURLs:Array<String> = []
        var val = 1
        for video in song.videos! {
            let word = video.split(separator: "Æ")
            let id = word[1]
            DatabaseManager.shared.findVideoById(videoid: String(id), completion: { selectedVideo in
                //print(song.songArtist.count)
                switch selectedVideo {
                case .success(let vid):
                    let video = vid as! YouTubeData
                    videosData.append(video)
                    if video.thumbnailURL != "" {
                        youtubeimageURLs.append(video.thumbnailURL)
                    }
                    if val == song.songArtist.count {
                        completion(videosData, youtubeimageURLs)
                    }
                    val+=1
                case .failure(let error):
                    print("Video ID proccessing error \(error)")
                    return
                }
            })
        }
        
    }
    
    func funcSetTemp(array: AnyObject) {
        currentVideo = array
        videoThumbnail.image = UIImage(named: "tonedeaflogo")
        videoThumbnail.backgroundColor = .black
        videoThumbnail.dropShadow()
        switch array {
        case is YouTubeData:
            //print("SongData")
            let video = array as! YouTubeData
            getArtistData(video: array, completion: { [weak self] artistNames in
                guard let strongSelf = self else {return}
                strongSelf.artistInvolvedLabel.text = artistNames.joined(separator: ", ")
                let imageURL = URL(string: video.thumbnailURL)!
                if let cachedImage = imageCache.object(forKey: imageURL.absoluteString as NSString) {
                    strongSelf.videoThumbnail.image = cachedImage
                } else {
                    strongSelf.videoThumbnail.setImage(from: imageURL, withPlaceholder: UIImage(named: "tonedeaflogo"))
                }
                strongSelf.channelTitle.text = video.channelTitle
                strongSelf.videoTitle.text = video.title
                strongSelf.videoDescriptionTextView.text = video.description
                        strongSelf.blurredBackground(url: imageURL)
                strongSelf.releaseDateLabel.text = "Released on \(video.dateYT)"
            })
            for favorite in currentAppUser.favorites {
                if favorite.dbid.contains(video.toneDeafAppId) {
                    favorited = true
                    favoriteButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
                    favoriteButton.tintColor = Constants.Colors.redApp
                }
            }
        default:
            print("Error loading video cell")
            return
        }
        
    }
    
    func blurredBackground(url: URL) {
        let backgroundImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: videoCellView.bounds.width, height: videoCellView.bounds.height))
        videoCellView.addSubview(backgroundImageView)
        if let cachedImage = imageCache.object(forKey: url.absoluteString as NSString) {
            backgroundImageView.image = cachedImage
        } else {
            backgroundImageView.setImage(from: url, withPlaceholder: UIImage(named: "tonedeaflogo"))
        }
        videoCellView.sendSubviewToBack(backgroundImageView)
        
        let blur = UIBlurEffect(style: .light)
        let blurView = UIVisualEffectView(effect: blur)
        blurView.frame = videoCellView.bounds
        videoCellView.addSubview(blurView)
        videoCellView.sendSubviewToBack(blurView)
        videoCellView.sendSubviewToBack(backgroundImageView)
    }
    
    @IBAction func favoriteTapped(_ sender: Any) {
        switch favorited {
        case true:
            favorited = false
            favoriteButton.setImage(UIImage(systemName: "heart"), for: .normal)
            favoriteButton.tintColor = .white
            var id = ""
            var categorty = ""
            switch currentVideo {
            case is YouTubeData:
                let youtube = currentVideo as! YouTubeData
                id = "\(youtube.toneDeafAppId)Æ\(youtube.title.replacingOccurrences(of: ".", with: " ").replacingOccurrences(of: "#", with: " ").replacingOccurrences(of: "$", with: " ").replacingOccurrences(of: "[", with: " ").replacingOccurrences(of: "]", with: " ").replacingOccurrences(of: ":", with: " "))"
                categorty = ("\(youtube.type)--\(youtube.title.replacingOccurrences(of: ".", with: " ").replacingOccurrences(of: "#", with: " ").replacingOccurrences(of: "$", with: " ").replacingOccurrences(of: "[", with: " ").replacingOccurrences(of: "]", with: " ").replacingOccurrences(of: ":", with: " "))--\(youtube.dateIA)--\(youtube.timeIA)--\(youtube.toneDeafAppId)")
//                if youtube.songs != [""] {
//                    for song in youtube.songs {
//                        let word = song.split(separator: "Æ")
//                        let id = word[0]
//                        DatabaseManager.shared.findSongById(songId: String(id), completion: { result in
//                            switch result {
//                            case .success(let songdata):
//                                var artistNameData:Array<String> = []
//                                for artist in songdata.songArtist {
//                                    let word = artist.split(separator: "Æ")
//                                    let id = word[1]
//                                    artistNameData.append(String(id))
//                                }
//                                let songcategorty = "\(songContentTag)--\(songdata.name)--\(artistNameData.joined(separator: ", "))--\(songdata.toneDeafAppId)"
//                                DatabaseManager.shared.getSongFavorites(currentSong: songdata, completion: { favs in
//                                    var num = favs
//                                    num-=1
//                                    Database.database().reference().child("Music Content").child("Songs").child(songcategorty).child("REQUIRED").child("Number of Favorites Overall").setValue(num)
//                                })
//                            case .failure(let err):
//                                print("err \(err)")
//                            }
//                        })
//                    }
//                }
//                if youtube.albums != [""] {
//                    for album in youtube.albums {
//                        let word = album.split(separator: "Æ")
//                        let id = word[0]
//                        DatabaseManager.shared.findAlbumById(albumId: String(id), completion: { result in
//                            switch result {
//                            case .success(let albumdata):
//                                var mainArtistsNames:Array<String> = []
//                                for artist in albumdata.mainArtist {
//                                    let word = artist.split(separator: "Æ")
//                                    let id = word[1]
//                                    mainArtistsNames.append(String(id))
//                                }
//                                let albumcategorty = "\(albumContentTag)--\(albumdata.name)--\(mainArtistsNames.joined(separator: ", "))--\(albumdata.toneDeafAppId)"
//                                DatabaseManager.shared.getAlbumFavorites(currentAlbum: albumdata, completion: { favs in
//                                    var num = favs
//                                    num-=1
//                                    Database.database().reference().child("Music Content").child("Albums").child(albumcategorty).child("REQUIRED").child("Number of Favorites Overall").setValue(num)
//                                })
//                            case .failure(let err):
//                                print("err \(err)")
//                            }
//                        })
//                    }
//                }
//                if youtube.instrumentals != [""] {
//                    for instrumental in youtube.instrumentals {
//                        let word = instrumental.split(separator: "Æ")
//                        let id = word[0]
//                        DatabaseManager.shared.findInstrumentalById(instrumentalId: String(id), completion: { result in
//                            switch result {
//                            case .success(let instrumentaldata):
//                                let instrumentalcategorty = ("\(instrumentalContentType )--\(instrumentaldata.songName)--\(instrumentaldata.dateRegisteredToApp ?? "")--\(instrumentaldata.timeRegisteredToApp ?? "")--\(instrumentaldata.toneDeafAppId)")
//                                DatabaseManager.shared.getInstrumentalFavorites(currentInstrumental: instrumentaldata, completion: { favs in
//                                    var num = favs
//                                    num-=1
//                                    Database.database().reference().child("Music Content").child("Instrumentals").child(instrumentalcategorty).child("Number of Favorites").setValue(num)
//                                })
//                            case .failure(let err):
//                                print("err \(err)")
//                            }
//                        })
//                    }
//                }
            default:
                print("kjvhg")
            }
            var newfav:[UserFavorite] = []
            for fav in currentAppUser.favorites {
                if fav.dbid != id {
                    newfav.append(fav)
                }
            }
            currentAppUser.favorites = newfav
            Database.database().reference().child("Users").child(currentAppUser.uid).child("Favorites").child(id).removeValue()
            DatabaseManager.shared.getVideoFavorites(currentVideo: currentVideo, completion: { favs in
                var num = favs
                num-=1
                Database.database().reference().child("Music Content").child("Videos").child(categorty).child("Number of Favorites").setValue(num)
            })
        default:
            favorited = true
            lightImpactGenerator.impactOccurred()
            tapScale(button: favoriteButton)
            favoriteButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
            favoriteButton.tintColor = Constants.Colors.redApp
            var id = ""
            var categorty = ""
            switch currentVideo {
            case is YouTubeData:
                let youtube = currentVideo as! YouTubeData
                id = "\(youtube.toneDeafAppId)Æ\(youtube.title.replacingOccurrences(of: ".", with: " ").replacingOccurrences(of: "#", with: " ").replacingOccurrences(of: "$", with: " ").replacingOccurrences(of: "[", with: " ").replacingOccurrences(of: "]", with: " ").replacingOccurrences(of: ":", with: " "))"
                categorty = ("\(youtube.type)--\(youtube.title.replacingOccurrences(of: ".", with: " ").replacingOccurrences(of: "#", with: " ").replacingOccurrences(of: "$", with: " ").replacingOccurrences(of: "[", with: " ").replacingOccurrences(of: "]", with: " ").replacingOccurrences(of: ":", with: " "))--\(youtube.dateIA)--\(youtube.timeIA)--\(youtube.toneDeafAppId)")
                
//                if youtube.songs != [""] {
//                    for song in youtube.songs {
//                        let word = song.split(separator: "Æ")
//                        let id = word[0]
//                        DatabaseManager.shared.findSongById(songId: String(id), completion: { result in
//                            switch result {
//                            case .success(let songdata):
//                                var artistNameData:Array<String> = []
//                                for artist in songdata.songArtist {
//                                    let word = artist.split(separator: "Æ")
//                                    let id = word[1]
//                                    artistNameData.append(String(id))
//                                }
//                                let songcategorty = "\(songContentTag)--\(songdata.name)--\(artistNameData.joined(separator: ", "))--\(songdata.toneDeafAppId)"
//                                DatabaseManager.shared.getSongFavorites(currentSong: songdata, completion: { favs in
//                                    var num = favs
//                                    num+=1
//                                    Database.database().reference().child("Music Content").child("Songs").child(songcategorty).child("REQUIRED").child("Number of Favorites Overall").setValue(num)
//                                })
//                            case .failure(let err):
//                                print("err \(err)")
//                            }
//                        })
//                    }
//                }
//                if youtube.albums != [""] {
//                    for album in youtube.albums {
//                        let word = album.split(separator: "Æ")
//                        let id = word[0]
//                        DatabaseManager.shared.findAlbumById(albumId: String(id), completion: { result in
//                            switch result {
//                            case .success(let albumdata):
//                                var mainArtistsNames:Array<String> = []
//                                for artist in albumdata.mainArtist {
//                                    let word = artist.split(separator: "Æ")
//                                    let id = word[1]
//                                    mainArtistsNames.append(String(id))
//                                }
//                                let albumcategorty = "\(albumContentTag)--\(albumdata.name)--\(mainArtistsNames.joined(separator: ", "))--\(albumdata.toneDeafAppId)"
//                                DatabaseManager.shared.getAlbumFavorites(currentAlbum: albumdata, completion: { favs in
//                                    var num = favs
//                                    num+=1
//                                    Database.database().reference().child("Music Content").child("Albums").child(albumcategorty).child("REQUIRED").child("Number of Favorites Overall").setValue(num)
//                                })
//                            case .failure(let err):
//                                print("err \(err)")
//                            }
//                        })
//                    }
//                }
//                if youtube.instrumentals != [""] {
//                    for instrumental in youtube.instrumentals {
//                        let word = instrumental.split(separator: "Æ")
//                        let id = word[0]
//                        DatabaseManager.shared.findInstrumentalById(instrumentalId: String(id), completion: { result in
//                            switch result {
//                            case .success(let instrumentaldata):
//                                let instrumentalcategorty = ("\(instrumentalContentType )--\(instrumentaldata.songName)--\(instrumentaldata.dateRegisteredToApp ?? "")--\(instrumentaldata.timeRegisteredToApp ?? "")--\(instrumentaldata.toneDeafAppId)")
//                                DatabaseManager.shared.getInstrumentalFavorites(currentInstrumental: instrumentaldata, completion: { favs in
//                                    var num = favs
//                                    num+=1
//                                    Database.database().reference().child("Music Content").child("Instrumentals").child(instrumentalcategorty).child("Number of Favorites").setValue(num)
//                                })
//                            case .failure(let err):
//                                print("err \(err)")
//                            }
//                        })
//                    }
//                }
            default:
                print("kjvhg")
            }
            let datee = getCurrentLocalDate()
            let dateFormatter = DateFormatter()
            dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
            let date = dateFormatter.date(from:datee)!
            currentAppUser.favorites.append(UserFavorite(dbid: id, timestamp: date))
            print(currentAppUser.uid)
            print(id)
            print(categorty)
            Database.database().reference().child("Users").child(currentAppUser.uid).child("Favorites").child(id).child("Timestamp").setValue(datee)
            DatabaseManager.shared.getVideoFavorites(currentVideo: currentVideo, completion: { favs in
                var num = favs
                num+=1
                Database.database().reference().child("Music Content").child("Videos").child(categorty).child("Number of Favorites").setValue(num)
            })
        }
    }
    
}

class InstrumentalsTableViewControlller: UITableView {
    override var intrinsicContentSize: CGSize {
        layoutIfNeeded()
        return CGSize(width: UIView.noIntrinsicMetric, height: contentSize.height)
    }
}

class InstrumentalsTableCellController: UITableViewCell {
    
    var artimage:UIImage!
    var currentImstrumental:InstrumentalData!
    
    @IBOutlet weak var instrumentalsImage: UIImageView!
    @IBOutlet weak var instrumentalTitle: UILabel!
    @IBOutlet weak var producersLabel: UILabel!
    @IBOutlet weak var instrumentalPrice: UILabel!
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var moreButton: UIButton!
    
    var favorited = false
    
    override func prepareForReuse() {
        favoriteButton.setImage(UIImage(systemName: "heart"), for: .normal)
        favoriteButton.tintColor = .white
        favorited = false
    }
    
    func funcSetTemp(array: InstrumentalData) {
        currentImstrumental = array
        instrumentalTitle.text = array.instrumentalName
        getProducerData(instrumental: array, completion: {[weak self] producerNames in
            guard let strongSelf = self else {return}
            strongSelf.producersLabel.text = producerNames.joined(separator: ", ")
            let imageURL = URL(string:"")!
            if let cachedImage = imageCache.object(forKey: imageURL.absoluteString as NSString) {
                strongSelf.instrumentalsImage.image = cachedImage
            } else {
                strongSelf.instrumentalsImage.setImage(from: imageURL, withPlaceholder: UIImage(named: "tonedeaflogo"))
            }
        })
        for favorite in currentAppUser.favorites {
            if favorite.dbid.contains(currentImstrumental.toneDeafAppId) {
                favorited = true
                favoriteButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
                favoriteButton.tintColor = Constants.Colors.redApp
            }
        }
    }
    
    func getProducerData(instrumental:InstrumentalData, completion: @escaping (Array<String>) -> Void) {
        var producerNameData:Array<String> = []
        var val = 0
        for producer in instrumental.producers {
            
            let word = producer.split(separator: "Æ")
            let id = word[1]
            val+=1
            producerNameData.append(String(id))
            if val == instrumental.producers.count {
                completion(producerNameData)
            }
        }
        
    }
    
    func setPreviewButton(array: InstrumentalData) -> String {
        
            let prevurl = array.audioURL
        return prevurl
    }
    
    func getArtwork(song: InstrumentalData) -> UIImage {
        var imageurl = ""
        imageurl = "song.imageURL"
        
        do {
            if let url = URL.init(string: imageurl) {
                let data = try Data.init(contentsOf: url)
                artimage = UIImage(data: data) ?? UIImage(named: "tonedeaflogo")!
            }
            
            
        } catch{
            
        }
        return artimage
    }
    
    @IBAction func favoriteTapped(_ sender: Any) {
        switch favorited {
        case true:
            favorited = false
            favoriteButton.setImage(UIImage(systemName: "heart"), for: .normal)
            favoriteButton.tintColor = .white
            let id = "\(currentImstrumental.toneDeafAppId)Æ\(currentImstrumental.instrumentalName)"
            var newfav:[UserFavorite] = []
            for fav in currentAppUser.favorites {
                if fav.dbid != id {
                    newfav.append(fav)
                }
            }
            if currentImstrumental.albums != [""] {
                for album in currentImstrumental.albums! {
                    let word = album.split(separator: "Æ")
                    let id = word[0]
                    DatabaseManager.shared.findAlbumById(albumId: String(id), completion: { result in
                        switch result {
                        case .success(let albumdata):
                            var mainArtistsNames:Array<String> = []
                            for artist in albumdata.mainArtist {
                                let word = artist.split(separator: "Æ")
                                let id = word[1]
                                mainArtistsNames.append(String(id))
                            }
                            let albumcategorty = "\(albumContentTag)--\(albumdata.name)--\(mainArtistsNames.joined(separator: ", "))--\(albumdata.toneDeafAppId)"
                            DatabaseManager.shared.getAlbumFavorites(currentAlbum: albumdata, completion: { favs in
                                var num = favs
                                num-=1
                                Database.database().reference().child("Music Content").child("Albums").child(albumcategorty).child("REQUIRED").child("Number of Favorites Overall").setValue(num)
                            })
                        case .failure(let err):
                            print("err \(err)")
                        }
                    })
                }
            }
            if currentImstrumental.songs != [""] {
                for song in currentImstrumental.songs! {
                    let word = song.split(separator: "Æ")
                    let id = word[0]
                    DatabaseManager.shared.findSongById(songId: String(id), completion: { result in
                        switch result {
                        case .success(let songdata):
                            var artistNameData:Array<String> = []
                            for artist in songdata.songArtist {
                                let word = artist.split(separator: "Æ")
                                let id = word[1]
                                artistNameData.append(String(id))
                            }
                            let songcategorty = "\(songContentTag)--\(songdata.name)--\(artistNameData.joined(separator: ", "))--\(songdata.toneDeafAppId)"
                            DatabaseManager.shared.getSongFavorites(currentSong: songdata, completion: { favs in
                                var num = favs
                                num-=1
                                Database.database().reference().child("Music Content").child("Songs").child(songcategorty).child("REQUIRED").child("Number of Favorites Overall").setValue(num)
                            })
                        case .failure(let err):
                            print("err \(err)")
                        }
                    })
                }
            }
            currentAppUser.favorites = newfav
            Database.database().reference().child("Users").child(currentAppUser.uid).child("Favorites").child(id).removeValue()
            let songname = currentImstrumental.instrumentalName!.replacingOccurrences(of: " (Instrumental)", with: "")
            let categorty = ("\(instrumentalContentType )--\(songname)--\(currentImstrumental.dateRegisteredToApp ?? "")--\(currentImstrumental.timeRegisteredToApp ?? "")--\(currentImstrumental.toneDeafAppId)")
            DatabaseManager.shared.getInstrumentalFavorites(currentInstrumental: currentImstrumental, completion: { favs in
                var num = favs
                num-=1
                Database.database().reference().child("Music Content").child("Instrumentals").child(categorty).child("Number of Favorites").setValue(num)
            })
        default:
            favorited = true
            lightImpactGenerator.impactOccurred()
            tapScale(button: favoriteButton)
            favoriteButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
            favoriteButton.tintColor = Constants.Colors.redApp
            let id = "\(currentImstrumental.toneDeafAppId)Æ\(currentImstrumental.instrumentalName)"
            let datee = getCurrentLocalDate()
            let dateFormatter = DateFormatter()
            dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
            let date = dateFormatter.date(from:datee)!
            if currentImstrumental.albums != [""] {
                for album in currentImstrumental.albums! {
                    let word = album.split(separator: "Æ")
                    let id = word[0]
                    DatabaseManager.shared.findAlbumById(albumId: String(id), completion: { result in
                        switch result {
                        case .success(let albumdata):
                            var mainArtistsNames:Array<String> = []
                            for artist in albumdata.mainArtist {
                                let word = artist.split(separator: "Æ")
                                let id = word[1]
                                mainArtistsNames.append(String(id))
                            }
                            let albumcategorty = "\(albumContentTag)--\(albumdata.name)--\(mainArtistsNames.joined(separator: ", "))--\(albumdata.toneDeafAppId)"
                            DatabaseManager.shared.getAlbumFavorites(currentAlbum: albumdata, completion: { favs in
                                var num = favs
                                num+=1
                                Database.database().reference().child("Music Content").child("Albums").child(albumcategorty).child("REQUIRED").child("Number of Favorites Overall").setValue(num)
                            })
                        case .failure(let err):
                            print("err \(err)")
                        }
                    })
                }
            }
            if currentImstrumental.songs != [""] {
                for song in currentImstrumental.songs! {
                    let word = song.split(separator: "Æ")
                    let id = word[0]
                    DatabaseManager.shared.findSongById(songId: String(id), completion: { result in
                        switch result {
                        case .success(let songdata):
                            var artistNameData:Array<String> = []
                            for artist in songdata.songArtist {
                                let word = artist.split(separator: "Æ")
                                let id = word[1]
                                artistNameData.append(String(id))
                            }
                            let songcategorty = "\(songContentTag)--\(songdata.name)--\(artistNameData.joined(separator: ", "))--\(songdata.toneDeafAppId)"
                            DatabaseManager.shared.getSongFavorites(currentSong: songdata, completion: { favs in
                                var num = favs
                                num+=1
                                Database.database().reference().child("Music Content").child("Songs").child(songcategorty).child("REQUIRED").child("Number of Favorites Overall").setValue(num)
                            })
                        case .failure(let err):
                            print("err \(err)")
                        }
                    })
                }
            }
            currentAppUser.favorites.append(UserFavorite(dbid: id, timestamp: date))
            Database.database().reference().child("Users").child(currentAppUser.uid).child("Favorites").child(id).child("Timestamp").setValue(datee)
            let songname = currentImstrumental.instrumentalName!.replacingOccurrences(of: " (Instrumental)", with: "")
            let categorty = ("\(instrumentalContentType )--\(songname)--\(currentImstrumental.dateRegisteredToApp ?? "")--\(currentImstrumental.timeRegisteredToApp ?? "")--\(currentImstrumental.toneDeafAppId)")
            DatabaseManager.shared.getInstrumentalFavorites(currentInstrumental: currentImstrumental, completion: { favs in
                var num = favs
                num+=1
                Database.database().reference().child("Music Content").child("Instrumentals").child(categorty).child("Number of Favorites").setValue(num)
            })
        }
    }
}

extension UIImageView {
    func dropShadow() {
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.5
        self.layer.shadowOffset = CGSize(width: 7, height: 7)
        self.layer.shadowRadius = 7
        self.layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        self.layer.shouldRasterize = true
        self.layer.rasterizationScale = UIScreen.main.scale
    }
    
    func dropShadowOfTheDay() {
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.5
        self.layer.shadowOffset = CGSize(width: 7, height: 7)
        self.layer.shadowRadius = 7
        self.layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        self.layer.shouldRasterize = true
        self.layer.rasterizationScale = UIScreen.main.scale
        self.layer.cornerRadius = 7
    }
    
    func dropShadowplayer() {
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.5
        self.layer.shadowOffset = CGSize(width: 7, height: 7)
        self.layer.shadowRadius = 7
        self.layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        self.layer.shouldRasterize = true
        self.layer.rasterizationScale = UIScreen.main.scale
    }
}

func getCurrentLocalDate()-> String {
    var now = Date()
    var nowComponents = DateComponents()
    let calendar = Calendar.current
    nowComponents.year = Calendar.current.component(.year, from: now)
    nowComponents.month = Calendar.current.component(.month, from: now)
    nowComponents.day = Calendar.current.component(.day, from: now)
    nowComponents.hour = Calendar.current.component(.hour, from: now)
    nowComponents.minute = Calendar.current.component(.minute, from: now)
    nowComponents.second = Calendar.current.component(.second, from: now)
    nowComponents.timeZone = TimeZone(abbreviation: "EST")!
    now = calendar.date(from: nowComponents)!
    let timeFormatter = DateFormatter()
    timeFormatter.timeZone = TimeZone(identifier: "EDT")
    timeFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
    let currdate = timeFormatter.string(from: now)
//    let dateFormatter = DateFormatter()
//    dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
//    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
//    let date = dateFormatter.date(from:currdate)!
    return currdate
}
