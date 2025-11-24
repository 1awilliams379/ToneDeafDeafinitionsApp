//
//  MainSearchViewController.swift
//  ToneDeafDeafinitionsApp
//
//  Created by Tone Deaf on 8/6/20.
//  Copyright © 2020 GITEM Solutions. All rights reserved.
//

import UIKit
import SkeletonView
import MarqueeLabel
import FirebaseDatabase
var searchController:UISearchController!

var screenWidth:CGFloat = 0
class MainSearchViewController: UIViewController {
    
    
    private let refreshControl = UIRefreshControl()
    @IBOutlet weak var scrollview: UIScrollView!

    @IBOutlet weak var searchBarContainer: UIView!
    
    var lastContentOffset: CGFloat = 0
    var maxHeaderHeight: CGFloat = 0
    @IBOutlet weak var toneHistoryTableView: UITableView!
    @IBOutlet weak var browseTableView: UITableView!
    @IBOutlet weak var discoverTableView: UITableView!
    
    @IBOutlet weak var tableViewHeightConstraint: NSLayoutConstraint!
    
    var tonesPickSong:SongData!
    var tonesPickVideo:AnyObject!
    var tonesPickAlbum:AlbumData!
    var tonesPickBeat:BeatData!
    var tonesPickInstrumental:InstrumentalData!
    
    var infoDetailContent:Any!
    var allOfContent:String!
    var artistInfo:ArtistData!
    var producerInfo:ProducerData!
    var beatInfo:BeatData!
    
    var lastContent:[Any]!
    var knownOldestDiscElement:Any!
    var lastfetchedkey = ""
    var all = false
    
    @IBOutlet weak var tonespicksongbackground: UIImageView!
    @IBOutlet weak var tonespicksongimage: UIImageView!
    @IBOutlet weak var tonespicksongrelease: UILabel!
    @IBOutlet weak var tonespicksongartistproducers: UILabel!
    @IBOutlet weak var tonespicksongname: UILabel!
    
    @IBOutlet weak var tonespickalbumbackground: UIImageView!
    @IBOutlet weak var tonespickalbumimage: UIImageView!
    @IBOutlet weak var tonespickalbumname: UILabel!
    @IBOutlet weak var tonespickalbumartistproducers: UILabel!
    @IBOutlet weak var tonespickalbumrelease: UILabel!
    
    @IBOutlet weak var tonespickbeatbackground: UIImageView!
    @IBOutlet weak var tonespickbeatimage: UIImageView!
    @IBOutlet weak var tonespickbeatname: UILabel!
    @IBOutlet weak var tonespickbeatartistproducers: UILabel!
    @IBOutlet weak var tonespickbeatrelease: UILabel!
    
    @IBOutlet weak var tonespickvideobackground: UIImageView!
    @IBOutlet weak var tonespickvideoimage: UIImageView!
    @IBOutlet weak var tonespickvideoname: UILabel!
    @IBOutlet weak var tonespickvideoartistproducers: UILabel!
    @IBOutlet weak var tonespickvideorelease: UILabel!
    
    @IBOutlet weak var tonespickinstrumentalbackground: UIImageView!
    @IBOutlet weak var tonespickinstrumentalimage: UIImageView!
    @IBOutlet weak var tonespickinstrumentalname: UILabel!
    @IBOutlet weak var tonespickinstrumentalartistproducers: UILabel!
    @IBOutlet weak var tonespickinstrumentalrelease: UILabel!
    
    var skelvar = 0
    var browseload = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createObservers()
        //scrollview.delaysContentTouches = false
        if let navcontroller = navigationController {
            lastContentOffset = navcontroller.navigationBar.frame.height
            maxHeaderHeight = navcontroller.navigationBar.frame.height
        }
        setUpSearchController()
        screenWidth = view.frame.width
        setTonePicks()
        setbrowserandoms(completion: {})
        setInitialPage(completion: {})
        toneHistoryTableView.delegate = self
        toneHistoryTableView.dataSource = self
        browseTableView.delegate = self
        browseTableView.dataSource = self
        discoverTableView.delegate = self
        discoverTableView.dataSource = self
        //searchBar.delegate = self
        scrollview.delegate = self
        scrollview.refreshControl = refreshControl
        refreshControl.attributedTitle = NSAttributedString(string: "Refreshing ...", attributes: nil)
        refreshControl.addTarget(self, action: #selector(refreshViews), for: .valueChanged)
        skelvar = 0
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationItem.largeTitleDisplayMode = .always
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationController?.navigationBar.backgroundColor = .black
        self.navigationController?.navigationBar.isTranslucent = false
            discoverTableView.reloadData()
        view.layoutSubviews()
        if searchController.isActive {
            UIView.animate(withDuration: 0.3) { [weak self] in
                guard let strongSelf = self else {return}
                strongSelf.navigationController?.setNavigationBarHidden(true, animated: true)
                strongSelf.view.layoutSubviews()
            }
        }
    }
    
    @objc func refreshViews() {
        tonesPickSong = nil
        tonesPickVideo = nil
        tonesPickAlbum = nil
        tonesPickBeat = nil
        tonesPickInstrumental = nil
        browseArray = []
        discoverArray = []
        skelvar = 0
        if skelvar == 0 {
            browseTableView.isSkeletonable = true
            browseTableView.showAnimatedGradientSkeleton(usingGradient: .init(baseColor: UIColor.init(red: 22/255, green: 22/255, blue: 22/255, alpha: 1)), animation: nil, transition: .crossDissolve(0.25))
            discoverTableView.isSkeletonable = true
            discoverTableView.showAnimatedGradientSkeleton(usingGradient: .init(baseColor: UIColor.init(red: 22/255, green: 22/255, blue: 22/255, alpha: 1)), animation: nil, transition: .crossDissolve(0.25))
        }
        skelvar+=1
        lastContent = nil
        knownOldestDiscElement = nil
        lastfetchedkey = ""
        all = false
        browseload = false
        let queue = DispatchQueue(label: "myakjdsfdskhBavshjGZHvewjlSDG,NVhzjvb,hds ZKfhcuewsQueue")
        let group = DispatchGroup()
        let arr = [1,2,3]
        for i in arr {
            group.enter()
            queue.async { [weak self] in
                guard let strongSelf = self else {return}
                switch i {
                case 1:
                    strongSelf.setTonePicks()
                    print("refresh done \(i)")
                    group.leave()
                case 2:
                    strongSelf.setbrowserandoms(completion: {
                        print("refresh done \(i)")
                        group.leave()
                    })
                case 3:
                    strongSelf.setInitialPage(completion: {
                        print("refresh done \(i)")
                        group.leave()
                    })
                default:
                    print("refesh error")
                }
            }
        }
        group.notify(queue: DispatchQueue.main) { [weak self] in
            guard let strongSelf = self else {return}
            print("refreshing done!")
            strongSelf.view.layoutSubviews()
            strongSelf.refreshControl.endRefreshing()
        }
    }
    
    func createObservers() {
        NotificationCenter.default.removeObserver(self)
        NotificationCenter.default.addObserver(self, selector: #selector(transitionToArtistInfoFromNotify), name: transitionFromExploreToArtistInfoNotify, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(transitionToProducerInfoFromNotify), name: transitionFromExploreToProducerInfoNotify, object: nil)
         NotificationCenter.default.addObserver(self, selector: #selector(seg(notification:)), name: transitionExploreToDetailInfoNotify, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(segToAll(notification:)), name: transitionExploreToAllOfNotify, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(tabToAllBeat(notification:)), name: transitionExploreToBeatsNotify, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(transitionToProductInfoFromNotify), name: transitionFromExploreToMerchInfoNotify, object: nil)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if skelvar == 0 {
            browseTableView.isSkeletonable = true
            browseTableView.showAnimatedGradientSkeleton(usingGradient: .init(baseColor: UIColor.init(red: 22/255, green: 22/255, blue: 22/255, alpha: 1)), animation: nil, transition: .crossDissolve(0.25))
            discoverTableView.isSkeletonable = true
            discoverTableView.showAnimatedGradientSkeleton(usingGradient: .init(baseColor: UIColor.init(red: 22/255, green: 22/255, blue: 22/255, alpha: 1)), animation: nil, transition: .crossDissolve(0.25))
        }
        
        skelvar+=1
        
    }
    
    func hideskeleton(view: UITableView) {
        skelvar+=1
        DispatchQueue.main.async {
            print("hiding skeleton")
            view.stopSkeletonAnimation()
            view.hideSkeleton(reloadDataAfter: false, transition: .crossDissolve(0.25))
            view.reloadData()
        }
    }
    
    func hideskeleton(discover: UITableView) {
        skelvar+=1
        DispatchQueue.main.async {[weak self] in
            guard let strongSelf = self else {return}
            print("hiding skeleton")
            discover.stopSkeletonAnimation()
            discover.hideSkeleton(reloadDataAfter: false, transition: .crossDissolve(0.25))
            discover.reloadData()
            strongSelf.tableViewHeightConstraint.constant = strongSelf.discoverTableView.contentSize.height
            strongSelf.view.layoutSubviews()
        }
    }
    
    func setUpSearchController() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc3 = storyboard.instantiateViewController(identifier: "mainSearchResultsTableTableViewController") as MainSearchResultsTableTableViewController
        searchController = UISearchController(searchResultsController: vc3)
        searchController.hidesNavigationBarDuringPresentation = true
        searchController.searchBar.searchBarStyle = UISearchBar.Style.minimal
        searchController.searchResultsUpdater = vc3
        searchController.delegate = self
        searchController.searchBar.sizeToFit()
        searchController.extendedLayoutIncludesOpaqueBars = true
        searchController.obscuresBackgroundDuringPresentation = false
        navigationItem.hidesSearchBarWhenScrolling = false
        self.navigationItem.searchController = searchController
        searchController.searchBar.placeholder = "Search Artists, Producers, Songs, Albums, etc."
        //searchBarContainer.addSubview(searchController.searchBar)
        searchController.searchBar.delegate = self
        searchController.searchBar.backgroundColor = .black
        self.extendedLayoutIncludesOpaqueBars = true
        searchController.searchBar.backgroundImage = UIImage()
        searchController.searchBar.tintColor = UIColor.init(red: 182/255, green: 0/255, blue: 3/255, alpha: 1)
        self.navigationController?.navigationItem.largeTitleDisplayMode = .never
        self.definesPresentationContext = true
    }
    
    func setTonePicks() {
        DatabaseManager.shared.fetchTonesPickSong(completion: {[weak self] song in
            guard let strongSelf = self else {return}
            strongSelf.tonesPickSong = song
            Comparisons.shared.getEarliestReleaseDate(song: song, completion: { date in
                strongSelf.getYoutubeData(song: song, completion: {[weak self] videos,videothumbnails in
                    guard let strongSelf = self else {return}
                    strongSelf.tonespicksongname.text = song.name
                    var songart:[String] = []
                    for art in song.songArtist {
                        let word = art.split(separator: "Æ")
                        let id = word[1]
                        songart.append(String(id))
                    }
                    var songapro:[String] = []
                    for pro in song.songProducers {
                        let word = pro.split(separator: "Æ")
                        let id = word[1]
                        songapro.append(String(id))
                    }
                    strongSelf.tonespicksongartistproducers.text = "\(songart.joined(separator: ",")), \(songapro.joined(separator: ","))"
                    strongSelf.tonespicksongrelease.text = date
                    var imageurl = ""
                    if song.spotify?.spotifyArtworkURL != "" {
                        imageurl = song.spotify!.spotifyArtworkURL
                    } else if song.apple?.appleArtworkURL != "" {
                        imageurl = song.apple!.appleArtworkURL
                    } else if !videothumbnails.isEmpty {
                        imageurl = videothumbnails[0]
                    }
                    let imageURL = URL(string: imageurl)!
                    if let cachedImage = imageCache.object(forKey: imageURL.absoluteString as NSString) {
                        strongSelf.tonespicksongimage.image = cachedImage
                    } else {
                        strongSelf.tonespicksongimage.setImage(from: imageURL, withPlaceholder: UIImage(named: "tonedeaflogo"))
                    }
                    strongSelf.blurredBackground(url: imageURL, videoCellView: strongSelf.tonespicksongbackground)
                })
            })
        })
        DatabaseManager.shared.fetchTonesPickAlbum(completion: {[weak self] album in
            guard let strongSelf = self else {return}
            strongSelf.tonesPickAlbum = album
            strongSelf.tonespickalbumname.text = album.name
            var songart:[String] = []
            for art in album.mainArtist {
                let word = art.split(separator: "Æ")
                let id = word[1]
                songart.append(String(id))
            }
            var songapro:[String] = []
            for pro in album.producers {
                let word = pro.split(separator: "Æ")
                let id = word[1]
                songapro.append(String(id))
            }
            var imageurl:String = ""
//            if album.spotifyData?.imageURL != "" {
//                guard let url = album.spotifyData?.imageURL else {
//                    fatalError()}
//                imageurl = url
//            } else if album.appleData?.imageURL != "" {
//                guard let url = album.appleData?.imageURL else {
//                    fatalError()}
//                imageurl = url
//            }
//            strongSelf.tonespickalbumartistproducers.text = "\(songart.joined(separator: ",")), \(songapro.joined(separator: ","))"
//            if album.spotifyData?.dateReleasedSpotify != "" {
//                guard let date = album.spotifyData?.dateReleasedSpotify else {
//                    fatalError()}
//                strongSelf.tonespickalbumrelease.text = date
//            } else if album.appleData?.dateReleasedApple != "" {
//                guard let date = album.appleData?.dateReleasedApple  else {
//                    fatalError()}
//                strongSelf.tonespickalbumrelease.text = date
//            }
            let imageURL = URL(string: imageurl)!
            if let cachedImage = imageCache.object(forKey: imageURL.absoluteString as NSString) {
                strongSelf.tonespickalbumimage.image = cachedImage
            } else {
                strongSelf.tonespickalbumimage.setImage(from: imageURL, withPlaceholder: UIImage(named: "tonedeaflogo"))
            }
            strongSelf.blurredBackground(url: imageURL, videoCellView: strongSelf.tonespickalbumbackground)
        })
        DatabaseManager.shared.fetchTonesPickVideo(completion: {[weak self] vid in
            guard let strongSelf = self else {return}
            switch vid {
            case is YouTubeData:
                let video = vid as! YouTubeData
                strongSelf.tonesPickVideo = video
                strongSelf.tonespickvideoname.text = video.title
                var songart:[String] = []
//                for art in video.artist {
//                    let word = art.split(separator: "Æ")
//                    let id = word[1]
//                    songart.append(String(id))
//                }
                var songapro:[String] = []
//                for pro in video.producers {
//                    let word = pro.split(separator: "Æ")
//                    let id = word[1]
//                    songapro.append(String(id))
//                }
                strongSelf.tonespickvideoartistproducers.text = "\(songart.joined(separator: ",")), \(songapro.joined(separator: ","))"
                strongSelf.tonespickvideorelease.text = video.dateYT
                var imageurl = ""
                if video.thumbnailURL != "" {
                    imageurl = video.thumbnailURL
                }
                let imageURL = URL(string: imageurl)!
                if let cachedImage = imageCache.object(forKey: imageURL.absoluteString as NSString) {
                    strongSelf.tonespickvideoimage.image = cachedImage
                } else {
                    strongSelf.tonespickvideoimage.setImage(from: imageURL, withPlaceholder: UIImage(named: "tonedeaflogo"))
                }
                strongSelf.blurredBackground(url: imageURL, videoCellView: strongSelf.tonespickvideobackground)
            default:
                print("sumn else")
            }
        })
        DatabaseManager.shared.fetchTonesPickBeat(completion: {[weak self] beat in
            guard let strongSelf = self else {return}
            strongSelf.tonesPickBeat = beat
            strongSelf.tonespickbeatname.text = beat.name
            var songapro:[String] = []
            for pro in beat.producers {
                let word = pro.split(separator: "Æ")
                let id = word[1]
                songapro.append(String(id))
            }
            var imageurl:String = ""
            if beat.imageURL != "" {
                imageurl = beat.imageURL
            }
            strongSelf.tonespickbeatartistproducers.text = "\(songapro.joined(separator: ","))"
            if beat.date != "" {
                strongSelf.tonespickbeatrelease.text = beat.date
            }
            let imageURL = URL(string: imageurl)!
            if let cachedImage = imageCache.object(forKey: imageURL.absoluteString as NSString) {
                strongSelf.tonespickbeatimage.image = cachedImage
            } else {
                strongSelf.tonespickbeatimage.setImage(from: imageURL, withPlaceholder: UIImage(named: "tonedeaflogo"))
            }
            strongSelf.blurredBackground(url: imageURL, videoCellView: strongSelf.tonespickbeatbackground)
        })
        DatabaseManager.shared.fetchTonesPickInstrumental(completion: {[weak self] instrumental in
            guard let strongSelf = self else {return}
            strongSelf.tonesPickInstrumental = instrumental
            strongSelf.tonespickinstrumentalname.text = instrumental.instrumentalName
            var songart:[String] = []
            var songapro:[String] = []
            for pro in instrumental.producers {
                let word = pro.split(separator: "Æ")
                let id = word[1]
                songapro.append(String(id))
            }
            var imageurl:String = ""
//            if instrumental.imageURL != "" {
//                imageurl = instrumental.imageURL
//            }
            strongSelf.tonespickinstrumentalrelease.text = ""
            strongSelf.tonespickinstrumentalartistproducers.text = "\(songapro.joined(separator: ","))"
            let imageURL = URL(string: imageurl)!
            if let cachedImage = imageCache.object(forKey: imageURL.absoluteString as NSString) {
                strongSelf.tonespickinstrumentalimage.image = cachedImage
            } else {
                strongSelf.tonespickinstrumentalimage.setImage(from: imageURL, withPlaceholder: UIImage(named: "tonedeaflogo"))
            }
            strongSelf.blurredBackground(url: imageURL, videoCellView: strongSelf.tonespickinstrumentalbackground)
        })
    }
    
    func setbrowserandoms(completion: @escaping (() -> Void)) {
        let queue = DispatchQueue(label: "myakjdsfhzjvb,hds ZKfhcuewsQueue")
        let group = DispatchGroup()
        let array = [1, 2, 3,4,5,6,7,8]

        for i in array {
            group.enter()
            queue.async {
                switch i {
                case 1:
                    //print("null")
                    DatabaseManager.shared.getRandomArtist(num: 1, completion: { artistids in
                        var tick = 0
                        for id in artistids {
                            DatabaseManager.shared.fetchArtistData(artist: id, completion: { artist in
                                tick+=1
                                if tick == artistids.count {
                                    browseArray.append(artist)
                                    print("browsedone \(i)")
                                    group.leave()
                                }
                            })
                        }
                    })
                case 2:
                    DatabaseManager.shared.getRandomProducer(num: 1, completion: { producerids in
                        var tick = 0
                        for id in producerids {
                            DatabaseManager.shared.fetchPersonData(person: id, completion: { producer in
                                tick+=1
                                if tick == producerids.count {
                                    browseArray.append(producer)
                                    print("browsedone \(i)")
                                    group.leave()
                                }
                            })
                        }
                    })
                case 3:
                    DatabaseManager.shared.getRandomMerch(num: 1, completion: { merchids in
                        var tick = 0
                        for id in merchids {
                            DatabaseManager.shared.findMerchById(merchId: id, completion: { result in
                                switch result {
                                case .success(let merch):
                                    tick+=1
                                    if tick == merchids.count {
                                        browseArray.append(merch)
                                        print("browsedone \(i)")
                                        group.leave()
                                    }
                                case .failure(let err):
                                    tick+=1
                                    print("browse \(err)")
                                }
                            })
                        }
                    })
                case 4:
                    DatabaseManager.shared.getRandomSong(num: 1, completion: { songids in
                        var tick = 0
                        for id in songids {
                            DatabaseManager.shared.findSongById(songId: id, completion: { result in
                                switch result {
                                case .success(let song):
                                    tick+=1
                                    if tick == songids.count {
                                        browseArray.append(song)
                                        print("browsedone \(i)")
                                        group.leave()
                                    }
                                case .failure(let err):
                                    tick+=1
                                    print("browse \(err)")
                                }
                            })
                        }
                    })
                case 5:
                    DatabaseManager.shared.getRandomAlbum(num: 1, completion: { albumids in
                        var tick = 0
                        for id in albumids {
                            DatabaseManager.shared.findAlbumById(albumId: id, completion: { result in
                                switch result {
                                case .success(let album):
                                    tick+=1
                                    if tick == albumids.count {
                                        browseArray.append(album)
                                        print("browsedone \(i)")
                                        group.leave()
                                    }
                                case .failure(let err):
                                    tick+=1
                                    print("browse \(err)")
                                }
                            })
                        }
                    })
                case 6:
                    DatabaseManager.shared.getRandomVideo(num: 1, completion: { videoids in
                        var tick = 0
                        for id in videoids {
                            DatabaseManager.shared.findVideoById(videoid: id, completion: { result in
                                switch result {
                                case .success(let video):
                                    tick+=1
                                    if tick == videoids.count {
                                        browseArray.append(video)
                                        print("browsedone \(i)")
                                        group.leave()
                                    }
                                case .failure(let err):
                                    tick+=1
                                    print("browse \(err)")
                                }
                            })
                        }
                    })
                case 7:
                    DatabaseManager.shared.getRandomBeat(num: 1, price: "Free", completion: { beatids in
                        var tick = 0
                        for id in beatids {
                            DatabaseManager.shared.findBeatById(beatId: id, completion: { result in
                                switch result {
                                case .success(let beat):
                                    tick+=1
                                    if tick == beatids.count {
                                        browseArray.append(beat)
                                        print("browsedone \(i)")
                                        group.leave()
                                    }
                                case .failure(let err):
                                    tick+=1
                                    print("browse \(err)")
                                }
                            })
                        }
                    })
                case 8:
                    DatabaseManager.shared.getRandomInstrumental(num: 1, completion: { instrumentalids in
                        var tick = 0
                        for id in instrumentalids {
                            DatabaseManager.shared.findInstrumentalById(instrumentalId: id, completion: { result in
                                switch result {
                                case .success(let instrumental):
                                    tick+=1
                                    if tick == instrumentalids.count {
                                        browseArray.append(instrumental)
                                        print("browsedone \(i)")
                                        group.leave()
                                    }
                                case .failure(let err):
                                    tick+=1
                                    print("browse \(err)")
                                }
                            })
                        }
                    })
                default:
                    print("error")
                }
            }
        }

        group.notify(queue: DispatchQueue.main) { [weak self] in
            guard let strongSelf = self else {return}
            print("done!")
            strongSelf.browseload = true
            strongSelf.hideskeleton(view: strongSelf.browseTableView)
            strongSelf.browseTableView.reloadData()
            completion()
        }
    }
    
    func setInitialPage(completion: @escaping (() -> Void)) {
        if discoverArray.isEmpty {
            buildDiscoverArray(completion: {[weak self] disc in
                guard let strongSelf = self else {return}
                discoverArray = disc
                strongSelf.lastContent = disc
                strongSelf.knownOldestDiscElement = discoverArray.last
                strongSelf.buildKey(completion: { key in
                    print("discover done")
                    strongSelf.lastfetchedkey = key
                    strongSelf.hideskeleton(discover: strongSelf.discoverTableView)
                    completion()
                })
            })
        } else {
            knownOldestDiscElement = discoverArray.last
            buildKey(completion: {[weak self] key in
                guard let strongSelf = self else {return}
                strongSelf.lastfetchedkey = key
                strongSelf.hideskeleton(discover: strongSelf.discoverTableView)
                completion()
            })
        }
    }

    func buildDiscoverArray(completion: @escaping (([Any]) -> Void)) {
        var tick = 0
        var array:[Any] = []
        DatabaseManager.shared.getRandomContent(num: 15, completion: {[weak self] ids in
            guard let strongSelf = self else {return}
            for id in ids {
                switch id.count {
                case 9:
                    DatabaseManager.shared.findVideoById(videoid: id, completion: { result in
                        switch result {
                        case .success(let video):
                            switch video {
                            case is YouTubeData:
                                let youtube = video as! YouTubeData
                                array.append(youtube)
                                tick+=1
                                print("discover \(tick)")
                                if tick == 15 {
                                    completion(array)
                                }
                            default:
                                tick+=1
                                print("discover \(tick)")
                                print("guess b")
                            }
                        case .failure(let error):
                            tick+=1
                            print("discover \(tick)")
                            if tick == 15 {
                                completion(array)
                            }
                            print("discover \(error)")
                        }
                    })
                case 13:
                    DatabaseManager.shared.findBeatById(beatId: id, completion: { result in
                        switch result {
                        case .success(let beat):
                            array.append(beat)
                            tick+=1
                            print("discover \(tick)")
                            if tick == 15 {
                                completion(array)
                            }
                        case .failure(let error):
                            tick+=1
                            print("discover \(tick)")
                            if tick == 15 {
                                completion(array)
                            }
                            print("discover \(error)")
                        }
                    })
                case 14:
                    DatabaseManager.shared.findBeatById(beatId: id, completion: { result in
                        switch result {
                        case .success(let beat):
                            array.append(beat)
                            tick+=1
                            print("discover \(tick)")
                            if tick == 15 {
                                completion(array)
                            }
                        case .failure(let error):
                            tick+=1
                            print("discover \(tick)")
                            if tick == 15 {
                                completion(array)
                            }
                            print("discover \(error)")
                        }
                    })
                case 12:
                    DatabaseManager.shared.findInstrumentalById(instrumentalId: id, completion: { result in
                        switch result {
                        case .success(let instrumental):
                            array.append(instrumental)
                            tick+=1
                            print("discover \(tick)")
                            if tick == 15 {
                                completion(array)
                            }
                        case .failure(let error):
                            tick+=1
                            print("discover \(tick)")
                            if tick == 15 {
                                completion(array)
                            }
                            print("discover \(error)")
                        }
                    })
                case 8:
                    DatabaseManager.shared.findAlbumById(albumId: id, completion: { result in
                        switch result {
                        case .success(let album):
                            array.append(album)
                            tick+=1
                            print("discover \(tick)")
                            if tick == 15 {
                                completion(array)
                            }
                        case .failure(let error):
                            tick+=1
                            print("discover \(tick)")
                            if tick == 15 {
                                completion(array)
                            }
                            print("discover \(error)")
                        }
                    })
                case 6:
                    DatabaseManager.shared.fetchArtistData(artist: id, completion: { artist in
                        array.append(artist)
                        tick+=1
                        print("discover \(tick)")
                        if tick == 15 {
                            completion(array)
                        }
                    })
                case 5:
                    DatabaseManager.shared.fetchPersonData(person: id, completion: { producer in
                        array.append(producer)
                        tick+=1
                        print("discover \(tick)")
                        if tick == 15 {
                            completion(array)
                        }
                    })
                case 20...24:
                    DatabaseManager.shared.findMerchById(merchId: id, completion: { result in
                        switch result {
                        case .success(let merch):
                            array.append(merch)
                            tick+=1
                            print("discover \(tick)")
                            if tick == 15 {
                                completion(array)
                            }
                        case .failure(let error):
                            tick+=1
                            print("discover \(tick)")
                            if tick == 15 {
                                completion(array)
                            }
                            print("discover \(error)")
                        }
                    })
                default:
                    DatabaseManager.shared.findSongById(songId: id, completion: { result in
                        switch result {
                        case .success(let song):
                            array.append(song)
                            tick+=1
                            print("discover \(tick)")
                            if tick == 15 {
                                completion(array)
                            }
                        case .failure(let error):
                            tick+=1
                            print("discover \(tick)")
                            if tick == 15 {
                                completion(array)
                            }
                            print("discover \(error)")
                        }
                    })
                }
            }
        })
    }
    
    func buildKey(completion: @escaping ((String) -> Void)) {
        let item = knownOldestDiscElement
        switch item {
        case is YouTubeData:
            let video = item as! YouTubeData
            var songart:[String] = []
//            for art in video.artist {
//                let word = art.split(separator: "Æ")
//                let id = word[1]
//                songart.append(String(id))
//            }
            lastfetchedkey = ("\(video.type)--\(video.title.replacingOccurrences(of: ".", with: " ").replacingOccurrences(of: "#", with: " ").replacingOccurrences(of: "$", with: " ").replacingOccurrences(of: "[", with: " ").replacingOccurrences(of: "]", with: " ").replacingOccurrences(of: ":", with: " "))--\(video.dateIA)--\(video.timeIA)--\(video.toneDeafAppId)")
            completion(lastfetchedkey)
        case is BeatData:
            let beat = item as! BeatData
            lastfetchedkey = beat.beatID
            completion(lastfetchedkey)
        case is InstrumentalData:
            let instrumental = item as! InstrumentalData
            lastfetchedkey = ("\(instrumentalContentType )--\(instrumental.songName)--\(instrumental.dateRegisteredToApp ?? "")--\(instrumental.timeRegisteredToApp ?? "")--\(instrumental.toneDeafAppId)")
            completion(lastfetchedkey)
        case is AlbumData:
            let album = item as! AlbumData
            var songart:[String] = []
            for art in album.mainArtist {
                let word = art.split(separator: "Æ")
                let id = word[1]
                songart.append(String(id))
            }
            lastfetchedkey = "\(albumContentTag)--\(album.name)--\(songart.joined(separator: ", "))--\(album.toneDeafAppId)"
            completion(lastfetchedkey)
        case is ArtistData:
            let artist = item as! ArtistData
            lastfetchedkey = ("\(artist.name ?? "")--\(artist.dateRegisteredToApp ?? "")--\(artist.timeRegisteredToApp ?? "")--\(artist.toneDeafAppId)")
            completion(lastfetchedkey)
        case is ProducerData:
            let producer = item as! ProducerData
            lastfetchedkey = ("\(producer.name ?? "")--\(producer.dateRegisteredToApp ?? "")--\(producer.timeRegisteredToApp ?? "")--\(producer.toneDeafAppId)")
            completion(lastfetchedkey)
        case is SongData:
            let song = item as! SongData
            var songart:[String] = []
            for art in song.songArtist {
                let word = art.split(separator: "Æ")
                let id = word[1]
                songart.append(String(id))
            }
            lastfetchedkey = "\(songContentTag)--\(song.name)--\(songart.joined(separator: ", "))--\(song.toneDeafAppId)"
            completion(lastfetchedkey)
        default:
            print("")
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
    
    func getYoutubeData(song:SongData, completion: @escaping (Array<YouTubeData>, Array<String>) -> Void) {
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
                            if val == song.videos!.count {
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
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "exploreToInfo" {
            if let viewController: InfoDetailViewController = segue.destination as? InfoDetailViewController {
                viewController.content = infoDetailContent
            }
        } else if segue.identifier == "exploreToArt" {
            if let viewController: ArtistInfoViewController = segue.destination as? ArtistInfoViewController {
                recievedArtistData = artistInfo
            }
        } else if segue.identifier == "exploreToPro" {
            if let viewController: ProducerInfoViewController = segue.destination as? ProducerInfoViewController {
                recievedProducerData = producerInfo
            }
        } else if segue.identifier == "exploreToAllOf" {
            if let viewController: AllOfContentTypeViewController = segue.destination as? AllOfContentTypeViewController {
                viewController.recievedData = allOfContent
            }
        }
        if segue.identifier == "exploreToProductInfo" {
            if let viewController: ProductInfoViewController = segue.destination as? ProductInfoViewController {
                viewController.recievedMerch = infoDetailContent
            }
        }
    }
    
    @IBAction func tonesPickSongTapped(_ sender: Any) {
        infoDetailContent = tonesPickSong
        performSegue(withIdentifier: "exploreToInfo", sender: nil)
    }
    @IBAction func tonesPickVideoTapped(_ sender: Any) {
        infoDetailContent = tonesPickVideo
        performSegue(withIdentifier: "exploreToInfo", sender: nil)
    }
    @IBAction func tonesPickAlbumTapped(_ sender: Any) {
        infoDetailContent = tonesPickAlbum
        performSegue(withIdentifier: "exploreToInfo", sender: nil)
    }
    @IBAction func tonesPickBeatTapped(_ sender: Any) {
        
    }
    @IBAction func tonesPickInstrumentalTapped(_ sender: Any) {
        infoDetailContent = tonesPickInstrumental
        performSegue(withIdentifier: "exploreToInfo", sender: nil)
    }
    
    @objc func playertimerset() {
        audiofreeze = false
        print("Audio Freeze Off")
        playerTimer.invalidate()
    }
    
    func prevURL(array: SongData) -> String {
        var prevurl:String!
        if array.apple?.applePreviewURL != "" {
            prevurl = array.apple?.applePreviewURL
        } else if array.spotify?.spotifyPreviewURL != "" {
            prevurl = array.spotify?.spotifyPreviewURL
        }
        return prevurl
    }
    
    func prevURL(array: InstrumentalData) -> String {
        var prevurl:String!
//        if array.applePreviewURL != "" {
//            prevurl = array.applePreviewURL
//        } else if array.spotifyPreviewURL != "" {
//            prevurl = array.spotifyPreviewURL
//        } else {
//            prevurl = array.audioURL
//        }
        return prevurl
    }
    
    @objc func seg(notification: Notification) {
        infoDetailContent = notification.object
        performSegue(withIdentifier: "exploreToInfo", sender: nil)
    }
    
    @objc func segToAll(notification: Notification) {
        allOfContent = notification.object as! String
        performSegue(withIdentifier: "exploreToAllOf", sender: nil)
    }
    
    @objc func tabToAllBeat(notification: Notification) {
        _ = tabBarController(self.tabBarController!, shouldSelect: (tabBarController?.viewControllers![2])!)
        tabBarController?.selectedIndex = 2
    }
    
    @objc func transitionToArtistInfoFromNotify(notification: Notification) {
        artistInfo = notification.object as! ArtistData
        performSegue(withIdentifier: "exploreToArt", sender: nil)
    }
    
    @objc func transitionToProducerInfoFromNotify(notification: Notification) {
        producerInfo = notification.object as! ProducerData
        performSegue(withIdentifier: "exploreToPro", sender: nil)
    }
    
    @objc func transitionToProductInfoFromNotify(notification: Notification) {
        let merch = notification.object as! MerchData
        if let mer = merch.kit {
            infoDetailContent = mer
        } else if let mer = merch.apperal {
            infoDetailContent = mer
        } else if let mer = merch.service {
            infoDetailContent = mer
        } else if let mer = merch.memorabilia {
            infoDetailContent = mer
        } else if let mer = merch.instrumentalSale {
            infoDetailContent = mer
        }
        performSegue(withIdentifier: "exploreToProductInfo", sender: nil)
    }
}

extension MainSearchViewController: UITabBarControllerDelegate {
    public func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {

           let fromView: UIView = tabBarController.selectedViewController!.view
           let toView  : UIView = viewController.view
           if fromView == toView {
                 return false
           }

        UIView.transition(from: fromView, to: toView, duration: 0.2, options: UIView.AnimationOptions.transitionCrossDissolve) { (finished:Bool) in

        }
        return true
   }
}



extension MainSearchViewController: UISearchBarDelegate {
}

extension MainSearchViewController: UISearchControllerDelegate {
    
    func willDismissSearchController(_ searchController: UISearchController) {
        UIView.animate(withDuration: 0.3) { [weak self] in
            guard let strongSelf = self else {return}
            searchController.hidesNavigationBarDuringPresentation = false
            strongSelf.view.layoutSubviews()
        }
    }
}

extension MainSearchViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollview.isBouncingBottom {
            guard !discoverArray.isEmpty else { return }
            guard all != true else {return}
            all = true
            //print("khjhgfdszfgcvbjlkjnkh")
            buildDiscoverArray(completion: {[weak self] disc in
                guard let strongSelf = self else {return}
                discoverArray.append(contentsOf: disc)
                print(discoverArray.count)
                strongSelf.knownOldestDiscElement = discoverArray.last
                strongSelf.buildKey(completion: { key in
                    
                    strongSelf.lastfetchedkey = key
                    strongSelf.discoverTableView.reloadData()
                    DispatchQueue.main.async {
                        strongSelf.tableViewHeightConstraint.constant = strongSelf.discoverTableView.contentSize.height
                        strongSelf.view.layoutSubviews()
                        DispatchQueue.global().asyncAfter(deadline: .now()+1, execute: {
                            strongSelf.all = false
                        })
                    }
                })
            })
        }
        
    }
}

extension MainSearchViewController : UITableViewDelegate, UITableViewDataSource, SkeletonTableViewDataSource {
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if tableView == discoverTableView {
            
        }

    }
    
    func collectionSkeletonView(_ skeletonView: UITableView, cellIdentifierForRowAt indexPath: IndexPath) -> ReusableCellIdentifier {
        switch skeletonView {
        case toneHistoryTableView:
            return "tonesHistoryTableCell"
        case browseTableView:
            return "toneBrowseTableCell"
        default:
            return "pagingCell"
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var rheight:CGFloat = 0
        switch tableView {
        case toneHistoryTableView:
            rheight = 220
        case browseTableView:
            rheight = 450
        default:
            rheight = 80
        }
        return rheight
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var nor = 15
        switch tableView {
        case discoverTableView:
            nor = discoverArray.count
        default:
            nor = 1
        }
        return nor
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch tableView {
        case toneHistoryTableView:
            let cell = tableView.dequeueReusableCell(withIdentifier: "tonesHistoryTableCell", for: indexPath) as! TonesHistoryTableCell
            cell.funcSetTemp()
            return cell
        case browseTableView:
            let cell = tableView.dequeueReusableCell(withIdentifier: "toneBrowseTableCell", for: indexPath) as! BrowseExploreTableCell
            if browseload == true {
                cell.funcSetTemp()
                cell.becollect.reloadData()
            }
            return cell
        default:
            if !discoverArray.isEmpty {
                let item = discoverArray[indexPath.row]
                switch item {
                case is YouTubeData:
                    let video = item as! YouTubeData
                    let cell = tableView.dequeueReusableCell(withIdentifier: "pagingVideoCell", for: indexPath) as! PagingVideoTableCell
                    cell.funcSetTemp(youtube: video)
                    return cell
                case is BeatData:
                    let beat = item as! BeatData
                    let cell = tableView.dequeueReusableCell(withIdentifier: "pagingCell", for: indexPath) as! PagingTableCell
                    cell.funcSetTemp(beat: beat)
                    return cell
                case is InstrumentalData:
                    let instrumental = item as! InstrumentalData
                    let cell = tableView.dequeueReusableCell(withIdentifier: "pagingCell", for: indexPath) as! PagingTableCell
                    cell.funcSetTemp(instrumental: instrumental)
                    return cell
                case is ArtistData:
                    let artist = item as! ArtistData
                    let cell = tableView.dequeueReusableCell(withIdentifier: "pagingCell", for: indexPath) as! PagingTableCell
                    cell.funcSetTemp(artis: artist)
                    return cell
                case is ProducerData:
                    let producer = item as! ProducerData
                    let cell = tableView.dequeueReusableCell(withIdentifier: "pagingCell", for: indexPath) as! PagingTableCell
                    cell.funcSetTemp(producer: producer)
                    return cell
                case is AlbumData:
                    let album = item as! AlbumData
                    let cell = tableView.dequeueReusableCell(withIdentifier: "pagingCell", for: indexPath) as! PagingTableCell
                    cell.funcSetTemp(album: album)
                    return cell
                case is MerchData:
                    let merch = item as! MerchData
                    let cell = tableView.dequeueReusableCell(withIdentifier: "pagingCell", for: indexPath) as! PagingTableCell
                    cell.funcSetTemp(merch: merch)
                    return cell
                default:
                    let song = item as! SongData
                    let cell = tableView.dequeueReusableCell(withIdentifier: "pagingCell", for: indexPath) as! PagingTableCell
                    cell.funcSetTemp(song: song)
                    return cell
                }
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "pagingCell", for: indexPath) as! PagingTableCell
                return cell
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        if tableView == discoverTableView {
            let item = discoverArray[indexPath.row]
            switch item {
            case is YouTubeData:
                let video = item as! YouTubeData
                infoDetailContent = video
                performSegue(withIdentifier: "exploreToInfo", sender: nil)
            case is BeatData:
                let beat = item as! BeatData
                beatInfo = beat
            case is InstrumentalData:
                let instrumental = item as! InstrumentalData
                infoDetailContent = instrumental
                performSegue(withIdentifier: "exploreToInfo", sender: nil)
            case is AlbumData:
                let album = item as! AlbumData
                infoDetailContent = album
                performSegue(withIdentifier: "exploreToInfo", sender: nil)
            case is ArtistData:
                let artist = item as! ArtistData
                artistInfo = artist
                performSegue(withIdentifier: "exploreToArt", sender: nil)
                
            case is ProducerData:
                let producer = item as! ProducerData
                producerInfo = producer
                performSegue(withIdentifier: "exploreToPro", sender: nil)
            case is MerchData:
                let merch = item as! MerchData
                if let con = merch.kit {
                    infoDetailContent = con
                } else if let con = merch.apperal {
                    infoDetailContent = con
                } else if let con = merch.service {
                    infoDetailContent = con
                } else if let con = merch.memorabilia {
                    infoDetailContent = con
                } else if let con = merch.instrumentalSale {
                    infoDetailContent = con
                }
                
                performSegue(withIdentifier: "exploreToProductInfo", sender: nil)
            default:
                let song = item as! SongData
                infoDetailContent = song
                performSegue(withIdentifier: "exploreToInfo", sender: nil)
            }
        }
    }
}

class TonesHistoryTableView: UITableView {
    override var intrinsicContentSize: CGSize {
        layoutIfNeeded()
        return CGSize(width: UIView.noIntrinsicMetric, height: contentSize.height)
    }
}

class TonesHistoryTableCell: UITableViewCell {
    @IBOutlet weak var dcollect: UICollectionView!
    var toneHistoryArray:[String] = ["firstsong","firstbeat","",""]
    
    var itemCellSize: CGSize = CGSize(width: 0, height: 0)
    var itemCellsGap: CGFloat = 20
    var currentItem = 0
    
    func funcSetTemp() {
        itemCellSize = CGSize(width: dcollect.frame.width-30, height: 200)
        dcollect.delegate = self
        dcollect.dataSource = self
    }
}

extension TonesHistoryTableCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return toneHistoryArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "toneHistoryCollectionViewCellController", for: indexPath) as! TonesHistoryCollectionCell
        cell.funcSetTemp(which: toneHistoryArray[indexPath.row])
        //cell.albumListTableView.reloadData()
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: false)
        switch toneHistoryArray[indexPath.row] {
        case "firstsong":
//            let song = SongData(toneDeafAppId: "", instrumentals: [""], albums: [""], videos: [""], albumAppId: "", name: "Gets Cold", songArtist: ["726792ÆGSM Bubba"], songProducers: ["93325ÆTone Deaf"], favoritesOverall: 0, appleName: "", appleSongURL: "", appleDuration: "", appleDateAPPL: "", appleDateIA: "", appleTimeIA: "", appleArtworkURL: "", appleArtist: "", appleExplicity: true, appleISRC: "", appleAlbumName: "", applePreviewURL: "", applecomposers: "", appleTrackNumber: 0, appleGenres: [""], appleFavorites: 0, appleMusicId: "", spotifyName: "", spotifySongURL: "", spotifyDuration: "3:49", spotifyDateSPT: "", spotifyDateIA: "", spotifyTimeIA: "", spotifyArtworkURL: "https://i1.sndcdn.com/artworks-000161925469-tri5fg-t500x500.jpg", spotifyArtist1: "", spotifyArtist1URL: "", spotifyArtist2: "", spotifyArtist2URL: "", spotifyArtist3: "", spotifyArtist3URL: "", spotifyArtist4: "", spotifyArtist4URL: "", spotifyArtist5: "", spotifyArtist5URL: "", spotifyArtist6: "", spotifyArtist6URL: "", spotifyExplicity: true, spotifyISRC: "", spotifyAlbumType: "", spotifyTrackNumber: 12, spotifyPreviewURL: "", spotifyFavorites: 0, spotifyId: "", youtubeOfficialVideo: "", youTubeAudioVideo: "", youtubeAltVideo: [""])
//            if audiofreeze != true {
//                player = nil
//                playerTimer = Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(playertimerset), userInfo: nil, repeats: false)
//                if audioPlayerViewController != nil {
//                    audioPlayerViewController.view.removeFromSuperview()
//                    audioPlayerViewController.removeFromParent()
//                    playervisualEffectView.removeFromSuperview()
//                }
//                let urlPlayable:URL!
//                let prevurl = ""
//                if let url  = URL.init(string: prevurl){
//                    urlPlayable = url
//                    guard  let urlPlayable = urlPlayable else {return}
//                    let myDict = [ "url": urlPlayable, "song":song] as [String : Any]
//                    NotificationCenter.default.post(name: AudioPlayerOnSongNotify, object: myDict)
//                }
//            }
            print("todo")
        default:
            print("fre")
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        print("FRAMEEEEEe",dcollect.frame.width)
        return CGSize(width: 350, height: 200)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollView == self.dcollect {
            var currentCellOffset = self.dcollect.contentOffset
            currentCellOffset.x += self.dcollect.frame.width / 2
            if let indexPath = self.dcollect.indexPathForItem(at: currentCellOffset) {
              self.dcollect.scrollToItem(at: indexPath, at: .left, animated: true)
            }
        }
    }
    
}

class TonesHistoryCollectionCell: UICollectionViewCell {
    
    @IBOutlet weak var content: UIView!
    @IBOutlet weak var background: UIView!
    @IBOutlet weak var foreground: UIView!
    @IBOutlet weak var artwork: UIImageView!
    @IBOutlet weak var typrOfHistory: UILabel!
    @IBOutlet weak var name: MarqueeLabel!
    @IBOutlet weak var artist: UILabel!
    @IBOutlet weak var producer: UILabel!
    @IBOutlet weak var released: MarqueeLabel!
    
    override var isHighlighted: Bool {
        didSet{
            tapScale(cell: self, down: isHighlighted)
        }
    }
    
    func funcSetTemp(which:String) {
        content.layer.cornerRadius = 20
        background.layer.cornerRadius = 20
        foreground.layer.masksToBounds = false
        foreground.layer.shadowColor = UIColor.black.cgColor
        foreground.layer.shadowOpacity = 0.5
        foreground.layer.shadowOffset = CGSize(width: -7, height: 0)
        foreground.layer.shadowRadius = 7
        foreground.layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        foreground.layer.shouldRasterize = true
        foreground.layer.rasterizationScale = UIScreen.main.scale
        switch which {
        case "firstsong":
            name.text = "Gets Cold"
            producer.text = "Produced by Tone Deaf"
            artist.text = "GSM Bubba, SGM Jet, J'Shon & T Royal"
            released.text = "May 7, 2016"
            artwork.image = UIImage(named: "getscoldartwork")
            blurredBackground(videoCellView: background)
        default:
            print("fre")
        }
    }
    
    func blurredBackground(videoCellView: UIView) {
        let backgroundImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: videoCellView.bounds.width, height: videoCellView.bounds.height))
        videoCellView.addSubview(backgroundImageView)
        backgroundImageView.image = UIImage(named: "getscoldartwork")
        videoCellView.sendSubviewToBack(backgroundImageView)
        
        let blur = UIBlurEffect(style: .light)
        let blurView = UIVisualEffectView(effect: blur)
        videoCellView.layer.cornerRadius = 7
        blurView.layer.cornerRadius = 7
        backgroundImageView.layer.cornerRadius = 7
        blurView.frame = videoCellView.bounds
        videoCellView.addSubview(blurView)
        videoCellView.sendSubviewToBack(blurView)
        videoCellView.sendSubviewToBack(backgroundImageView)
    }
}


class BrowseExploreTableView: UITableView {
    override var intrinsicContentSize: CGSize {
        layoutIfNeeded()
        return CGSize(width: UIView.noIntrinsicMetric, height: contentSize.height)
    }
}

class BrowseExploreTableCell: UITableViewCell {
    @IBOutlet weak var page: UIPageControl!
    @IBOutlet weak var becollect: UICollectionView!
    
    func funcSetTemp() {
        becollect.delaysContentTouches = false
        becollect.delegate = self
        becollect.dataSource = self
        page.numberOfPages = 8
    }
}

extension BrowseExploreTableCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return browseArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = browseArray[indexPath.row]
        switch item {
        case is SongData:
            let song = item as! SongData
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "browseCollectionViewCellController", for: indexPath) as! BrowseExploreCollectionCell
            cell.funcSetTemp(collect: becollect, song: song)
            return cell
        case is ArtistData:
            let artist = item as! ArtistData
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "browseCollectionViewCellController", for: indexPath) as! BrowseExploreCollectionCell
            cell.funcSetTemp(collect: becollect, artist: artist)
            return cell
        case is ProducerData:
            let producer = item as! ProducerData
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "browseCollectionViewCellController", for: indexPath) as! BrowseExploreCollectionCell
            cell.funcSetTemp(collect: becollect, producer: producer)
            
            return cell
        case is AlbumData:
            let album = item as! AlbumData
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "browseCollectionViewCellController", for: indexPath) as! BrowseExploreCollectionCell
            cell.funcSetTemp(collect: becollect, album: album)
            return cell
        case is BeatData:
            let beat = item as! BeatData
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "browseCollectionViewCellController", for: indexPath) as! BrowseExploreCollectionCell
            cell.funcSetTemp(collect: becollect, beat: beat)
            return cell
        case is InstrumentalData:
            let instrumental = item as! InstrumentalData
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "browseCollectionViewCellController", for: indexPath) as! BrowseExploreCollectionCell
            cell.funcSetTemp(collect: becollect, instrumental: instrumental)
            return cell
        case is MerchData:
            let merch = item as! MerchData
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "browseCollectionViewCellController", for: indexPath) as! BrowseExploreCollectionCell
            cell.funcSetTemp(collect: becollect, merch: merch)
            return cell
        default:
            let video = item as! YouTubeData
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "browseCollectionViewCellController", for: indexPath) as! BrowseExploreCollectionCell
            cell.funcSetTemp(collect: becollect, youtube: video)
            return cell
        }
    
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: false)
        let item = browseArray[indexPath.row]
        switch item {
        case is SongData:
            NotificationCenter.default.post(name: transitionExploreToAllOfNotify, object: "song")
        case is ArtistData:
            NotificationCenter.default.post(name: transitionExploreToAllOfNotify, object: "artist")
        case is ProducerData:
            NotificationCenter.default.post(name: transitionExploreToAllOfNotify, object: "producer")
        case is AlbumData:
            NotificationCenter.default.post(name: transitionExploreToAllOfNotify, object: "album")
        case is BeatData:
            NotificationCenter.default.post(name: transitionExploreToBeatsNotify, object: nil)
        case is MerchData:
            print("")
            //NotificationCenter.default.post(name: transitionExploreToMerchNotify, object: nil)
        case is InstrumentalData:
            NotificationCenter.default.post(name: transitionExploreToAllOfNotify, object: "instrumental")
        default:
            NotificationCenter.default.post(name: transitionExploreToAllOfNotify, object: "video")
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: becollect.frame.width, height: 413)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollView == self.becollect {
            var currentCellOffset = self.becollect.contentOffset
            currentCellOffset.x += self.becollect.frame.width / 2
            if let indexPath = self.becollect.indexPathForItem(at: currentCellOffset) {
              self.becollect.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
            }
            page?.currentPage = Int(scrollView.contentOffset.x) / Int(scrollView.frame.width)
        }
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        page?.currentPage = Int(scrollView.contentOffset.x) / Int(scrollView.frame.width)
    }
    
}

class BrowseExploreCollectionCell: UICollectionViewCell {
    
    @IBOutlet weak var background: UIView!
    @IBOutlet weak var blurGradient: UIView!
    @IBOutlet weak var catIcon: UIImageView!
    @IBOutlet weak var catLabel: UILabel!
    @IBOutlet weak var featuredLAbel: UILabel!
    @IBOutlet weak var artwork: UIImageView!
    
    var backgroundImageView:UIImageView!
    var favorited = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        artwork.layer.masksToBounds = true
        blurGradient.backgroundColor = .clear
        artwork.layer.cornerRadius = 5
        background.layer.masksToBounds = true
        background.skeletonCornerRadius = 5
        blurGradient.layer.cornerRadius = 5
        let gradient = CAGradientLayer()
        gradient.frame = blurGradient.frame
        gradient.colors = [UIColor.clear.cgColor, UIColor.black.cgColor]
        gradient.locations = [0.0, 1.0]
        blurGradient.layer.insertSublayer(gradient, at: 0)
        background.addSubview(blurGradient)
        background.sendSubviewToBack(blurGradient)
        
        let blur = UIBlurEffect(style: .dark)
        let blurView = UIVisualEffectView(effect: blur)
        blurView.frame = blurGradient.frame
        let gradient2 = CAGradientLayer()
        gradient2.frame = blurGradient.frame
        gradient2.colors = [UIColor.clear.cgColor, UIColor.black.cgColor]
        gradient2.locations = [0, 1]
        blurView.layer.insertSublayer(gradient2, at: 1)
        background.addSubview(blurView)
        background.sendSubviewToBack(blurView)
    }
    
    override func prepareForReuse() {
        if backgroundImageView != nil, backgroundImageView.image != nil {
            backgroundImageView.image = nil
        }
        backgroundImageView = nil
        artwork.image = nil
//        blurView.removeFromSuperview()
//        gradient.removeFromSuperlayer()
//        gradient2.removeFromSuperlayer()
        catIcon.image = nil
//        blurView = nil
//        gradient2 = nil
//        gradient = nil
    }
    
    override var isHighlighted: Bool {
        didSet{
            tapScale(cell: self, down: isHighlighted)
        }
    }
    
    func funcSetTemp(collect: UICollectionView, song: SongData) {
        catLabel.text = "Songs"
        catIcon.image = UIImage(systemName: "music.quarternote.3")
        featuredLAbel.text = "Featured Song: \(song.name)"
        GlobalFunctions.shared.selectImageURL(song: song, completion: {[weak self] ur in
            guard let strongSelf = self else {return}
            let imageurl = ur!
            if let url = URL.init(string: imageurl) {
                strongSelf.blurredBackground(collect: collect, url: url, videoCellView: strongSelf.background)
                if let cachedImage = imageCache.object(forKey: url.absoluteString as NSString) {
                    strongSelf.artwork.image = cachedImage
                } else {
                    strongSelf.artwork.setImage(from: url, withPlaceholder: UIImage(named: "tonedeaflogo"))
                }
            }
        })
    }
    
    func funcSetTemp(collect: UICollectionView, artist: ArtistData) {
        catIcon.image = UIImage(systemName: "music.mic")
        catLabel.text = "Artists"
        guard let artistname = artist.name else {return}
        featuredLAbel.text = "Featured Artist: \(artistname)"
        GlobalFunctions.shared.selectImageURL(artist: artist, completion: {[weak self] aimage in
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
    
    func funcSetTemp(collect: UICollectionView, producer: ProducerData) {
        catIcon.image = UIImage(systemName: "record.circle.fill")
        catLabel.text = "Producers"
        guard let producername = producer.name else {return}
        featuredLAbel.text = "Featured Producer: \(producername)"
        GlobalFunctions.shared.selectImageURL(producer: producer, completion: {[weak self]
            aimage in
            guard let strongSelf = self else {return}
            guard let img = aimage else {
                let defaultimg = UIImage(named: "defaultuser")!
                strongSelf.artwork.image = defaultimg
                return
            }
            if let url = URL.init(string: img) {
                strongSelf.blurredBackground(collect: collect, url: url, videoCellView: strongSelf.background)
                if let cachedImage = imageCache.object(forKey: url.absoluteString as NSString) {
                    strongSelf.artwork.image = cachedImage
                } else {
                    strongSelf.artwork.setImage(from: url, withPlaceholder: UIImage(named: "tonedeaflogo"))
                }
            }
        })
        
    }
    
    func funcSetTemp(collect: UICollectionView, album: AlbumData) {
        catLabel.text = "Albums"
        featuredLAbel.text = "Featured Album: \(album.name)"
        catIcon.image = UIImage(systemName: "square.stack.3d.up.fill")
        var imageurl = ""
//        if album.spotifyData?.imageURL != "" {
//            guard let url = album.spotifyData?.imageURL else {
//                fatalError()}
//            imageurl = url
//        } else if album.appleData?.imageURL != "" {
//            guard let url = album.appleData?.imageURL else {
//                fatalError()}
//            imageurl = url
//        }
        if let url = URL.init(string: imageurl) {
            blurredBackground(collect: collect, url: url, videoCellView: background)
            if let cachedImage = imageCache.object(forKey: url.absoluteString as NSString) {
                artwork.image = cachedImage
            } else {
                artwork.setImage(from: url, withPlaceholder: UIImage(named: "tonedeaflogo"))
            }
        }
    }
    
    func funcSetTemp(collect: UICollectionView, beat: BeatData) {
        catLabel.text = "Beats"
        featuredLAbel.text = "Featured Beat: \(beat.name)"
        catIcon.image = UIImage(systemName: "hifispeaker.fill")
        let imageurl = beat.imageURL
        if let url = URL.init(string: imageurl) {
            blurredBackground(collect: collect, url: url, videoCellView: background)
            if let cachedImage = imageCache.object(forKey: url.absoluteString as NSString) {
                artwork.image = cachedImage
            } else {
                artwork.setImage(from: url, withPlaceholder: UIImage(named: "tonedeaflogo"))
            }
        }
    }
    
    func funcSetTemp(collect: UICollectionView, instrumental: InstrumentalData) {
        catLabel.text = "Instrumentals"
        featuredLAbel.text = "Featured Instrumental: \(instrumental.instrumentalName)"
        catIcon.image = UIImage(systemName: "pianokeys.inverse")
        let imageurl = "instrumental.imageURL"
        if let url = URL.init(string: imageurl) {
            blurredBackground(collect: collect, url: url, videoCellView: background)
            if let cachedImage = imageCache.object(forKey: url.absoluteString as NSString) {
                artwork.image = cachedImage
            } else {
                artwork.setImage(from: url, withPlaceholder: UIImage(named: "tonedeaflogo"))
            }
        }
    }
    
    func funcSetTemp(collect: UICollectionView, merch: MerchData) {
        catLabel.text = "Merchandise"
        catIcon.image = UIImage(systemName: "bag.fill")
        if let mer = merch.kit {
            featuredLAbel.text = "Featured Merchandise: \(mer.name)"
            let imageurl = mer.imageURLs[0]
            if let url = URL.init(string: imageurl) {
                blurredBackground(collect: collect, url: url, videoCellView: background)
                if let cachedImage = imageCache.object(forKey: url.absoluteString as NSString) {
                    artwork.image = cachedImage
                } else {
                    artwork.setImage(from: url, withPlaceholder: UIImage(named: "tonedeaflogo"))
                }
            }
        } else if let mer = merch.apperal {
            featuredLAbel.text = "Featured Merchandise: \(mer.name)"
            let imageurl = mer.imageURLs[0]
            if let url = URL.init(string: imageurl) {
                blurredBackground(collect: collect, url: url, videoCellView: background)
                if let cachedImage = imageCache.object(forKey: url.absoluteString as NSString) {
                    artwork.image = cachedImage
                } else {
                    artwork.setImage(from: url, withPlaceholder: UIImage(named: "tonedeaflogo"))
                }
            }
        } else if let mer = merch.service {
            featuredLAbel.text = "Featured Merchandise: \(mer.name)"
            let image = UIImage(named: "lego")
            artwork.image = image
        } else if let mer = merch.memorabilia {
            featuredLAbel.text = "Featured Merchandise: \(mer.name)"
            let imageurl = mer.imageURLs[0]
            if let url = URL.init(string: imageurl) {
                blurredBackground(collect: collect, url: url, videoCellView: background)
                if let cachedImage = imageCache.object(forKey: url.absoluteString as NSString) {
                    artwork.image = cachedImage
                } else {
                    artwork.setImage(from: url, withPlaceholder: UIImage(named: "tonedeaflogo"))
                }
            }
        } else if let mer = merch.instrumentalSale {
            let word = mer.instrumentaldbid.split(separator: "Æ")
            let id = String(word[0])
            DatabaseManager.shared.findInstrumentalById(instrumentalId: id, completion: {[weak self] result in
                guard let strongSelf = self else {return}
                switch result {
                case.success(let instrumental):
                    strongSelf.featuredLAbel.text = "Featured Merchandise: \(instrumental.instrumentalName)"
                    let imageurl = "instrumental.imageURL"
                    if let url = URL.init(string: imageurl) {
                        strongSelf.blurredBackground(collect: collect, url: url, videoCellView: strongSelf.background)
                        if let cachedImage = imageCache.object(forKey: url.absoluteString as NSString) {
                            strongSelf.artwork.image = cachedImage
                        } else {
                            strongSelf.artwork.setImage(from: url, withPlaceholder: UIImage(named: "tonedeaflogo"))
                        }
                    }
                case.failure(let err):
                    print("kjhfdgxfgchjk bi \(err)")
                }
            })
        }
    }
    
    func funcSetTemp(collect: UICollectionView, youtube: YouTubeData) {
        catLabel.text = "Videos"
        featuredLAbel.text = "Featured Video: \(youtube.title)"
        catIcon.image = UIImage(systemName: "video.fill")
        let imageurl = youtube.thumbnailURL
        if let url = URL.init(string: imageurl) {
            blurredBackground(collect: collect, url: url, videoCellView: background)
            if let cachedImage = imageCache.object(forKey: url.absoluteString as NSString) {
                artwork.image = cachedImage
            } else {
                artwork.setImage(from: url, withPlaceholder: UIImage(named: "tonedeaflogo"))
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
    
    func blurredBackground(collect: UICollectionView, url: URL, videoCellView: UIView) {
        backgroundImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: videoCellView.bounds.width, height: videoCellView.bounds.height))
        videoCellView.addSubview(backgroundImageView)
        if let cachedImage = imageCache.object(forKey: url.absoluteString as NSString) {
            backgroundImageView.image = cachedImage
        } else {
            backgroundImageView.setImage(from: url, withPlaceholder: UIImage(named: "tonedeaflogo"))
        }
        backgroundImageView.layer.cornerRadius = 5
        videoCellView.layer.cornerRadius = 5
        videoCellView.addSubview(backgroundImageView)
        videoCellView.sendSubviewToBack(backgroundImageView)
    }
    
}

class DiscoverExploreTableView: UITableView {
    override var intrinsicContentSize: CGSize {
        layoutIfNeeded()
        return CGSize(width: UIView.noIntrinsicMetric, height: contentSize.height)
    }
}

class PagingTableCell: UITableViewCell {
    
    @IBOutlet weak var artwork: UIImageView!
    @IBOutlet weak var typeLabel: MarqueeLabel!
    @IBOutlet weak var name: MarqueeLabel!
    @IBOutlet weak var artist: MarqueeLabel!
    @IBOutlet weak var favoriteButton: UIButton!
    var currentObject:AnyObject!
    var favorited = false
    var artNames:[String]!
    override func prepareForReuse() {
        favoriteButton.setImage(UIImage(systemName: "heart"), for: .normal)
        favoriteButton.tintColor = .white
        favorited = false
        artwork.backgroundColor = .clear
        artwork.image = nil
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        artwork.layer.cornerRadius = 5
    }
    
    func funcSetTemp(song: SongData) {
        favoriteButton.isHidden = false
        currentObject = song
        name.text = song.name
        typeLabel.text = "--SONG--"
        var songart:[String] = []
        for art in song.songArtist {
            let word = art.split(separator: "Æ")
            let id = word[1]
            songart.append(String(id))
        }
        artNames = songart
        artist.text = songart.joined(separator: ", ")
        GlobalFunctions.shared.selectImageURL(song: song, completion: {[weak self] ur in
            guard let strongSelf = self else {return}
            let imageurl = ur!
            if let url = URL.init(string: imageurl) {
                if let cachedImage = imageCache.object(forKey: url.absoluteString as NSString) {
                    strongSelf.artwork.image = cachedImage
                } else {
                    strongSelf.artwork.setImage(from: url, withPlaceholder: UIImage(named: "tonedeaflogo"))
                }
            }
        })
        for favorite in currentAppUser.favorites {
            if favorite.dbid.contains(song.toneDeafAppId) {
                favorited = true
                favoriteButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
                favoriteButton.tintColor = Constants.Colors.redApp
            }
        }
    }
    func funcSetTemp(beat: BeatData) {
        favoriteButton.isHidden = false
        currentObject = beat
        name.text = beat.name
        typeLabel.text = "--BEAT--"
        var songart:[String] = []
        for art in beat.producers {
            let word = art.split(separator: "Æ")
            let id = word[1]
            songart.append(String(id))
        }
        artist.text = songart.joined(separator: ", ")
        let imageurl = beat.imageURL
        if let url = URL.init(string: imageurl) {
            if let cachedImage = imageCache.object(forKey: url.absoluteString as NSString) {
                artwork.image = cachedImage
            } else {
                artwork.setImage(from: url, withPlaceholder: UIImage(named: "tonedeaflogo"))
            }
        }
        for favorite in currentAppUser.favorites {
            if favorite.dbid.contains(beat.toneDeafAppId) {
                favorited = true
                favoriteButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
                favoriteButton.tintColor = Constants.Colors.redApp
            }
        }
    }
    func funcSetTemp(instrumental: InstrumentalData) {
        favoriteButton.isHidden = false
        currentObject = instrumental
        name.text = instrumental.instrumentalName
        typeLabel.text = "--INSTRUMENTAL--"
        var songart:[String] = []
//        for art in instrumental.songArtist {
//            let word = art.split(separator: "Æ")
//            let id = word[1]
//            songart.append(String(id))
//        }
        artist.text = songart.joined(separator: ", ")
        let imageurl = "instrumental.imageURL"
        if let url = URL.init(string: imageurl) {
            if let cachedImage = imageCache.object(forKey: url.absoluteString as NSString) {
                artwork.image = cachedImage
            } else {
                artwork.setImage(from: url, withPlaceholder: UIImage(named: "tonedeaflogo"))
            }
        }
        for favorite in currentAppUser.favorites {
            if favorite.dbid.contains(instrumental.toneDeafAppId) {
                favorited = true
                favoriteButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
                favoriteButton.tintColor = Constants.Colors.redApp
            }
        }
    }
    func funcSetTemp(album: AlbumData) {
        favoriteButton.isHidden = false
        currentObject = album
        name.text = album.name
        typeLabel.text = "--ALBUM--"
        var songart:[String] = []
        for art in album.mainArtist {
            let word = art.split(separator: "Æ")
            let id = word[1]
            songart.append(String(id))
        }
        artist.text = songart.joined(separator: ", ")
        var imageurl = ""
//        if album.spotifyData?.imageURL != "" {
//            guard let url = album.spotifyData?.imageURL else {
//                fatalError()}
//            imageurl = url
//        } else if album.appleData?.imageURL != "" {
//            guard let url = album.appleData?.imageURL else {
//                fatalError()}
//            imageurl = url
//        }
        if let url = URL.init(string: imageurl) {
            if let cachedImage = imageCache.object(forKey: url.absoluteString as NSString) {
                artwork.image = cachedImage
            } else {
                artwork.setImage(from: url, withPlaceholder: UIImage(named: "tonedeaflogo"))
            }
        }
        for favorite in currentAppUser.favorites {
            if favorite.dbid.contains(album.toneDeafAppId) {
                favorited = true
                favoriteButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
                favoriteButton.tintColor = Constants.Colors.redApp
            }
        }
    }
    func funcSetTemp(artis: ArtistData) {
        favoriteButton.isHidden = true
        name.text = artis.name
        artwork.layer.cornerRadius = 30
        typeLabel.text = "--ARTIST--"
        artist.text = artis.alternateNames.joined(separator: ", ")
        GlobalFunctions.shared.selectImageURL(artist: artis, completion: {[weak self] aimage in
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
    func funcSetTemp(producer: ProducerData) {
        favoriteButton.isHidden = true
        name.text = producer.name
        artwork.layer.cornerRadius = 30
        typeLabel.text = "--Producer--"
        artist.text = producer.alternateNames.joined(separator: ", ")
        GlobalFunctions.shared.selectImageURL(producer: producer, completion: {[weak self] aimage in
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
    func funcSetTemp(merch: MerchData) {
        favoriteButton.isHidden = false
        if let mer = merch.kit {
            currentObject = mer
            typeLabel.text = "--MERCH--"
            name.text = mer.name
            var songart:[String] = []
            var songpro:[String] = []
            if let person = mer.producers {
                for pro in person {
                    let word = pro.split(separator: "Æ")
                    let id = word[1]
                    songpro.append(String(id))
                }
            }
            if let person = mer.artists {
                for art in person {
                    let word = art.split(separator: "Æ")
                    let id = word[1]
                    songart.append(String(id))
                }
            }
            artNames = songart
            if songart.isEmpty {
                artist.text = songpro.joined(separator: ", ")
            } else {
                artist.text = "\(songart.joined(separator: ", ")), \(songpro.joined(separator: ", "))"
            }
            let imageurl = mer.imageURLs[0]
            if let url = URL.init(string: imageurl) {
                if let cachedImage = imageCache.object(forKey: url.absoluteString as NSString) {
                    artwork.image = cachedImage
                } else {
                    artwork.setImage(from: url, withPlaceholder: UIImage(named: "tonedeaflogo"))
                }
            }
            for favorite in currentAppUser.favorites {
                if favorite.dbid.contains(mer.tDAppId) {
                    favorited = true
                    favoriteButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
                    favoriteButton.tintColor = Constants.Colors.redApp
                }
            }
        } else if let mer = merch.apperal {
            currentObject = mer
            typeLabel.text = "--MERCH--"
            name.text = mer.name
            var songart:[String] = []
            var songpro:[String] = []
            if let person = mer.producers {
                for pro in person {
                    let word = pro.split(separator: "Æ")
                    let id = word[1]
                    songpro.append(String(id))
                }
            }
            if let person = mer.artists {
                for art in person {
                    let word = art.split(separator: "Æ")
                    let id = word[1]
                    songart.append(String(id))
                }
            }
            artNames = songart
            if songart.isEmpty {
                artist.text = songpro.joined(separator: ", ")
            } else {
                artist.text = "\(songart.joined(separator: ", ")), \(songpro.joined(separator: ", "))"
            }
            let imageurl = mer.imageURLs[0]
            if let url = URL.init(string: imageurl) {
                if let cachedImage = imageCache.object(forKey: url.absoluteString as NSString) {
                    artwork.image = cachedImage
                } else {
                    artwork.setImage(from: url, withPlaceholder: UIImage(named: "tonedeaflogo"))
                }
            }
            for favorite in currentAppUser.favorites {
                if favorite.dbid.contains(mer.tDAppId) {
                    favorited = true
                    favoriteButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
                    favoriteButton.tintColor = Constants.Colors.redApp
                }
            }
        } else if let mer = merch.service {
            currentObject = mer
            typeLabel.text = "--MERCH--"
            name.text = mer.name
            var songpro:[String] = []
            if let person = mer.producers {
                for pro in person {
                    let word = pro.split(separator: "Æ")
                    let id = word[1]
                    songpro.append(String(id))
                }
            }
            artNames = songpro
            artist.text = songpro.joined(separator: ", ")
            artwork.backgroundColor = .white
            artwork.image = UIImage(named: "lego")!
            for favorite in currentAppUser.favorites {
                if favorite.dbid.contains(mer.tDAppId) {
                    favorited = true
                    favoriteButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
                    favoriteButton.tintColor = Constants.Colors.redApp
                }
            }
        } else if let mer = merch.memorabilia {
            currentObject = mer
            typeLabel.text = "--MERCH--"
            name.text = mer.name
            var songart:[String] = []
            var songpro:[String] = []
            if let person = mer.producers {
                for pro in person {
                    let word = pro.split(separator: "Æ")
                    let id = word[1]
                    songpro.append(String(id))
                }
            }
            if let person = mer.artists {
                for art in person {
                    let word = art.split(separator: "Æ")
                    let id = word[1]
                    songart.append(String(id))
                }
            }
            artNames = songart
            if songart.isEmpty {
                artist.text = songpro.joined(separator: ", ")
            } else {
                artist.text = "\(songart.joined(separator: ", ")), \(songpro.joined(separator: ", "))"
            }
            let imageurl = mer.imageURLs[0]
            if let url = URL.init(string: imageurl) {
                if let cachedImage = imageCache.object(forKey: url.absoluteString as NSString) {
                    artwork.image = cachedImage
                } else {
                    artwork.setImage(from: url, withPlaceholder: UIImage(named: "tonedeaflogo"))
                }
            }
            for favorite in currentAppUser.favorites {
                if favorite.dbid.contains(mer.tDAppId) {
                    favorited = true
                    favoriteButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
                    favoriteButton.tintColor = Constants.Colors.redApp
                }
            }
        } else if let mer = merch.instrumentalSale {
            currentObject = mer
            typeLabel.text = "--MERCH--"
            let word = mer.instrumentaldbid.split(separator: "Æ")
            let id = String(word[0])
            DatabaseManager.shared.findInstrumentalById(instrumentalId: id, completion: {[weak self] result in
                guard let strongSelf = self else {return}
                switch result {
                case.success(let instrumental):
                    strongSelf.name.text = instrumental.instrumentalName
                    var songart:[String] = []
                    var songpro:[String] = []
//                    for pro in instrumental.songArtist {
//                        let word = pro.split(separator: "Æ")
//                        let id = word[1]
//                        songpro.append(String(id))
//                    }
//                    for art in instrumental.songArtist {
//                        let word = art.split(separator: "Æ")
//                        let id = word[1]
//                        songart.append(String(id))
//                    }
                    strongSelf.artNames = songart
                    if songart.isEmpty {
                        strongSelf.artist.text = songpro.joined(separator: ", ")
                    } else {
                        strongSelf.artist.text = "\(songart.joined(separator: ", ")), \(songpro.joined(separator: ", "))"
                    }
                    let imageurl = "instrumental.imageURL"
                    if let url = URL.init(string: imageurl) {
                        if let cachedImage = imageCache.object(forKey: url.absoluteString as NSString) {
                            strongSelf.artwork.image = cachedImage
                        } else {
                            strongSelf.artwork.setImage(from: url, withPlaceholder: UIImage(named: "tonedeaflogo"))
                        }
                    }
                    for favorite in currentAppUser.favorites {
                        if favorite.dbid.contains(instrumental.toneDeafAppId) {
                            strongSelf.favorited = true
                            strongSelf.favoriteButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
                            strongSelf.favoriteButton.tintColor = Constants.Colors.redApp
                        }
                    }
                case.failure(let err):
                    print("kjhfdgxfgchjk bi \(err)")
                }
            })
        }
    }
    
    func funcSetTemp(song: SongData, hide:Bool) {
        favoriteButton.isHidden = false
        currentObject = song
        name.text = song.name
        typeLabel.text = ""
        var songart:[String] = []
        for art in song.songArtist {
            let word = art.split(separator: "Æ")
            let id = word[1]
            songart.append(String(id))
        }
        artNames = songart
        artist.text = songart.joined(separator: ", ")
        GlobalFunctions.shared.selectImageURL(song: song, completion: {[weak self] ur in
            guard let strongSelf = self else {return}
            let imageurl = ur!
            if let url = URL.init(string: imageurl) {
                if let cachedImage = imageCache.object(forKey: url.absoluteString as NSString) {
                    strongSelf.artwork.image = cachedImage
                } else {
                    strongSelf.artwork.setImage(from: url, withPlaceholder: UIImage(named: "tonedeaflogo"))
                }
            }
        })
        for favorite in currentAppUser.favorites {
            if favorite.dbid.contains(song.toneDeafAppId) {
                favorited = true
                favoriteButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
                favoriteButton.tintColor = Constants.Colors.redApp
            }
        }
    }
    func funcSetTemp(beat: BeatData, hide: Bool) {
        favoriteButton.isHidden = false
        currentObject = beat
        name.text = beat.name
        typeLabel.text = ""
        var songart:[String] = []
        for art in beat.producers {
            let word = art.split(separator: "Æ")
            let id = word[1]
            songart.append(String(id))
        }
        artist.text = songart.joined(separator: ", ")
        let imageurl = beat.imageURL
        if let url = URL.init(string: imageurl) {
            if let cachedImage = imageCache.object(forKey: url.absoluteString as NSString) {
                artwork.image = cachedImage
            } else {
                artwork.setImage(from: url, withPlaceholder: UIImage(named: "tonedeaflogo"))
            }
        }
        for favorite in currentAppUser.favorites {
            if favorite.dbid.contains(beat.toneDeafAppId) {
                favorited = true
                favoriteButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
                favoriteButton.tintColor = Constants.Colors.redApp
            }
        }
    }
    func funcSetTemp(instrumental: InstrumentalData, hide: Bool) {
        favoriteButton.isHidden = false
        currentObject = instrumental
        name.text = instrumental.instrumentalName
        typeLabel.text = ""
        var songart:[String] = []
        for art in instrumental.artist! {
            let word = art.split(separator: "Æ")
            let id = word[1]
            songart.append(String(id))
        }
        artist.text = songart.joined(separator: ", ")
        let imageurl = "instrumental.imageURL"
        if let url = URL.init(string: imageurl) {
            if let cachedImage = imageCache.object(forKey: url.absoluteString as NSString) {
                artwork.image = cachedImage
            } else {
                artwork.setImage(from: url, withPlaceholder: UIImage(named: "tonedeaflogo"))
            }
        }
        for favorite in currentAppUser.favorites {
            if favorite.dbid.contains(instrumental.toneDeafAppId) {
                favorited = true
                favoriteButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
                favoriteButton.tintColor = Constants.Colors.redApp
            }
        }
    }
    func funcSetTemp(album: AlbumData, hide: Bool) {
        favoriteButton.isHidden = false
        currentObject = album
        name.text = album.name
        typeLabel.text = ""
        var songart:[String] = []
        for art in album.mainArtist {
            let word = art.split(separator: "Æ")
            let id = word[1]
            songart.append(String(id))
        }
        artist.text = songart.joined(separator: ", ")
        var imageurl = ""
//        if album.spotifyData?.imageURL != "" {
//            guard let url = album.spotifyData?.imageURL else {
//                fatalError()}
//            imageurl = url
//        } else if album.appleData?.imageURL != "" {
//            guard let url = album.appleData?.imageURL else {
//                fatalError()}
//            imageurl = url
//        }
        if let url = URL.init(string: imageurl) {
            if let cachedImage = imageCache.object(forKey: url.absoluteString as NSString) {
                artwork.image = cachedImage
            } else {
                artwork.setImage(from: url, withPlaceholder: UIImage(named: "tonedeaflogo"))
            }
        }
        for favorite in currentAppUser.favorites {
            if favorite.dbid.contains(album.toneDeafAppId) {
                favorited = true
                favoriteButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
                favoriteButton.tintColor = Constants.Colors.redApp
            }
        }
    }
    func funcSetTemp(artis: ArtistData, hide: Bool) {
        name.text = artis.name
        artwork.layer.cornerRadius = 30
        typeLabel.text = ""
        favoriteButton.isHidden = true
        artist.text = artis.alternateNames.joined(separator: ", ")
        GlobalFunctions.shared.selectImageURL(artist: artis, completion: {[weak self] aimage in
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
    func funcSetTemp(producer: ProducerData, hide: Bool) {
        name.text = producer.name
        artwork.layer.cornerRadius = 30
        typeLabel.text = ""
        favoriteButton.isHidden = true
        artist.text = producer.alternateNames.joined(separator: ", ")
        GlobalFunctions.shared.selectImageURL(producer: producer, completion: {[weak self] aimage in
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
    func funcSetTemp(merch: MerchData, hide: Bool) {
        favoriteButton.isHidden = false
        if let mer = merch.kit {
            currentObject = mer
            typeLabel.text = ""
            name.text = mer.name
            var songart:[String] = []
            var songpro:[String] = []
            if let person = mer.producers {
                for pro in person {
                    let word = pro.split(separator: "Æ")
                    let id = word[1]
                    songpro.append(String(id))
                }
            }
            if let person = mer.artists {
                for art in person {
                    let word = art.split(separator: "Æ")
                    let id = word[1]
                    songart.append(String(id))
                }
            }
            artNames = songart
            if songart.isEmpty {
                artist.text = songpro.joined(separator: ", ")
            } else {
                artist.text = "\(songart.joined(separator: ", ")), \(songpro.joined(separator: ", "))"
            }
            let imageurl = mer.imageURLs[0]
            if let url = URL.init(string: imageurl) {
                if let cachedImage = imageCache.object(forKey: url.absoluteString as NSString) {
                    artwork.image = cachedImage
                } else {
                    artwork.setImage(from: url, withPlaceholder: UIImage(named: "tonedeaflogo"))
                }
            }
            for favorite in currentAppUser.favorites {
                if favorite.dbid.contains(mer.tDAppId) {
                    favorited = true
                    favoriteButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
                    favoriteButton.tintColor = Constants.Colors.redApp
                }
            }
        } else if let mer = merch.apperal {
            currentObject = mer
            typeLabel.text = ""
            name.text = mer.name
            var songart:[String] = []
            var songpro:[String] = []
            if let person = mer.producers {
                for pro in person {
                    let word = pro.split(separator: "Æ")
                    let id = word[1]
                    songpro.append(String(id))
                }
            }
            if let person = mer.artists {
                for art in person {
                    let word = art.split(separator: "Æ")
                    let id = word[1]
                    songart.append(String(id))
                }
            }
            artNames = songart
            if songart.isEmpty {
                artist.text = songpro.joined(separator: ", ")
            } else {
                artist.text = "\(songart.joined(separator: ", ")), \(songpro.joined(separator: ", "))"
            }
            let imageurl = mer.imageURLs[0]
            if let url = URL.init(string: imageurl) {
                if let cachedImage = imageCache.object(forKey: url.absoluteString as NSString) {
                    artwork.image = cachedImage
                } else {
                    artwork.setImage(from: url, withPlaceholder: UIImage(named: "tonedeaflogo"))
                }
            }
            for favorite in currentAppUser.favorites {
                if favorite.dbid.contains(mer.tDAppId) {
                    favorited = true
                    favoriteButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
                    favoriteButton.tintColor = Constants.Colors.redApp
                }
            }
        } else if let mer = merch.service {
            currentObject = mer
            typeLabel.text = ""
            name.text = mer.name
            var songpro:[String] = []
            if let person = mer.producers {
                for pro in person {
                    let word = pro.split(separator: "Æ")
                    let id = word[1]
                    songpro.append(String(id))
                }
            }
            artNames = songpro
            artist.text = songpro.joined(separator: ", ")
            artwork.backgroundColor = .white
            artwork.image = UIImage(named: "lego")!
            for favorite in currentAppUser.favorites {
                if favorite.dbid.contains(mer.tDAppId) {
                    favorited = true
                    favoriteButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
                    favoriteButton.tintColor = Constants.Colors.redApp
                }
            }
        } else if let mer = merch.memorabilia {
            currentObject = mer
            typeLabel.text = ""
            name.text = mer.name
            var songart:[String] = []
            var songpro:[String] = []
            if let person = mer.producers {
                for pro in person {
                    let word = pro.split(separator: "Æ")
                    let id = word[1]
                    songpro.append(String(id))
                }
            }
            if let person = mer.artists {
                for art in person {
                    let word = art.split(separator: "Æ")
                    let id = word[1]
                    songart.append(String(id))
                }
            }
            artNames = songart
            if songart.isEmpty {
                artist.text = songpro.joined(separator: ", ")
            } else {
                artist.text = "\(songart.joined(separator: ", ")), \(songpro.joined(separator: ", "))"
            }
            let imageurl = mer.imageURLs[0]
            if let url = URL.init(string: imageurl) {
                if let cachedImage = imageCache.object(forKey: url.absoluteString as NSString) {
                    artwork.image = cachedImage
                } else {
                    artwork.setImage(from: url, withPlaceholder: UIImage(named: "tonedeaflogo"))
                }
            }
            for favorite in currentAppUser.favorites {
                if favorite.dbid.contains(mer.tDAppId) {
                    favorited = true
                    favoriteButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
                    favoriteButton.tintColor = Constants.Colors.redApp
                }
            }
        } else if let mer = merch.instrumentalSale {
            currentObject = mer
            typeLabel.text = ""
            let word = mer.instrumentaldbid.split(separator: "Æ")
            let id = String(word[0])
            DatabaseManager.shared.findInstrumentalById(instrumentalId: id, completion: {[weak self] result in
                guard let strongSelf = self else {return}
                switch result {
                case.success(let instrumental):
                    strongSelf.name.text = instrumental.instrumentalName
                    var songart:[String] = []
                    var songpro:[String] = []
//                    for pro in instrumental.songArtist {
//                        let word = pro.split(separator: "Æ")
//                        let id = word[1]
//                        songpro.append(String(id))
//                    }
//                    for art in instrumental.songArtist {
//                        let word = art.split(separator: "Æ")
//                        let id = word[1]
//                        songart.append(String(id))
//                    }
                    strongSelf.artNames = songart
                    if songart.isEmpty {
                        strongSelf.artist.text = songpro.joined(separator: ", ")
                    } else {
                        strongSelf.artist.text = "\(songart.joined(separator: ", ")), \(songpro.joined(separator: ", "))"
                    }
                    let imageurl = "instrumental.imageURL"
                    if let url = URL.init(string: imageurl) {
                        if let cachedImage = imageCache.object(forKey: url.absoluteString as NSString) {
                            strongSelf.artwork.image = cachedImage
                        } else {
                            strongSelf.artwork.setImage(from: url, withPlaceholder: UIImage(named: "tonedeaflogo"))
                        }
                    }
                    for favorite in currentAppUser.favorites {
                        if favorite.dbid.contains(instrumental.toneDeafAppId) {
                            strongSelf.favorited = true
                            strongSelf.favoriteButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
                            strongSelf.favoriteButton.tintColor = Constants.Colors.redApp
                        }
                    }
                case.failure(let err):
                    print("kjhfdgxfgchjk bi \(err)")
                }
            })
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
    
    @IBAction func favoriteTapped(_ sender: Any) {
        switch currentObject {
        case is SongData:
            let currentSong = currentObject as! SongData
            switch favorited {
            case true:
                favorited = false
                favoriteButton.setImage(UIImage(systemName: "heart"), for: .normal)
                favoriteButton.tintColor = .white
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
                tapScale(button: favoriteButton)
                favoriteButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
                favoriteButton.tintColor = Constants.Colors.redApp
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
        case is InstrumentalData:
            let currentImstrumental = currentObject as! InstrumentalData
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
        case is AlbumData:
            let currentAlbum = currentObject as! AlbumData
            switch favorited {
            case true:
                favorited = false
                favoriteButton.setImage(UIImage(systemName: "heart"), for: .normal)
                favoriteButton.tintColor = .white
                let id = "\(currentAlbum.toneDeafAppId)Æ\(currentAlbum.name)"
                var newfav:[UserFavorite] = []
                for fav in currentAppUser.favorites {
                    if fav.dbid != id {
                        newfav.append(fav)
                    }
                }
                currentAppUser.favorites = newfav
                Database.database().reference().child("Users").child(currentAppUser.uid).child("Favorites").child(id).removeValue()
                var mainArtistsNames:Array<String> = []
                for artist in currentAlbum.mainArtist {
                    let word = artist.split(separator: "Æ")
                    let id = word[1]
                    mainArtistsNames.append(String(id))
                }
                let categorty = "\(albumContentTag)--\(currentAlbum.name)--\(mainArtistsNames.joined(separator: ", "))--\(currentAlbum.toneDeafAppId)"
                DatabaseManager.shared.getAlbumFavorites(currentAlbum: currentAlbum, completion: { favs in
                    var num = favs
                    num-=1
                    Database.database().reference().child("Music Content").child("Albums").child(categorty).child("REQUIRED").child("Number of Favorites Overall").setValue(num)
                })
            default:
                favorited = true
                lightImpactGenerator.impactOccurred()
                tapScale(button: favoriteButton)
                favoriteButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
                favoriteButton.tintColor = Constants.Colors.redApp
                let id = "\(currentAlbum.toneDeafAppId)Æ\(currentAlbum.name)"
                let datee = getCurrentLocalDate()
                let dateFormatter = DateFormatter()
                dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
                dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
                let date = dateFormatter.date(from:datee)!
                currentAppUser.favorites.append(UserFavorite(dbid: id, timestamp: date))
                Database.database().reference().child("Users").child(currentAppUser.uid).child("Favorites").child(id).child("Timestamp").setValue(datee)
                var mainArtistsNames:Array<String> = []
                for artist in currentAlbum.mainArtist {
                    let word = artist.split(separator: "Æ")
                    let id = word[1]
                    mainArtistsNames.append(String(id))
                }
                let categorty = "\(albumContentTag)--\(currentAlbum.name)--\(mainArtistsNames.joined(separator: ", "))--\(currentAlbum.toneDeafAppId)"
                DatabaseManager.shared.getAlbumFavorites(currentAlbum: currentAlbum, completion: { favs in
                    var num = favs
                    num+=1
                    Database.database().reference().child("Music Content").child("Albums").child(categorty).child("REQUIRED").child("Number of Favorites Overall").setValue(num)
                })
            }
        default:
            let currentBeat = currentObject as! BeatData
            switch favorited {
            case true:
                favorited = false
                favoriteButton.setImage(UIImage(systemName: "heart"), for: .normal)
                favoriteButton.tintColor = .white
                let id = "\(currentBeat.toneDeafAppId)Æ\(currentBeat.name)"
                var newfav:[UserFavorite] = []
                for fav in currentAppUser.favorites {
                    if fav.dbid != id {
                        newfav.append(fav)
                    }
                }
                currentAppUser.favorites = newfav
                Database.database().reference().child("Users").child(currentAppUser.uid).child("Favorites").child(id).removeValue()
                DatabaseManager.shared.getBeatFavorites(currentBeat: currentBeat, completion: { favs in
                    var num = favs
                    num-=1
                    Database.database().reference().child("Beats").child(currentBeat.priceType).child(currentBeat.beatID).child("Number of Favorites").setValue(num)
                })
            default:
                favorited = true
                lightImpactGenerator.impactOccurred()
                tapScale(button: favoriteButton)
                favoriteButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
                favoriteButton.tintColor = Constants.Colors.redApp
                let id = "\(currentBeat.toneDeafAppId)Æ\(currentBeat.name)"
                let datee = getCurrentLocalDate()
                let dateFormatter = DateFormatter()
                dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
                dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
                let date = dateFormatter.date(from:datee)!
                currentAppUser.favorites.append(UserFavorite(dbid: id, timestamp: date))
                Database.database().reference().child("Users").child(currentAppUser.uid).child("Favorites").child(id).child("Timestamp").setValue(datee)
                DatabaseManager.shared.getBeatFavorites(currentBeat: currentBeat, completion: { favs in
                    var num = favs
                    num+=1
                    print(num)
                    Database.database().reference().child("Beats").child(currentBeat.priceType).child(currentBeat.beatID).child("Number of Favorites").setValue(num)
                })
            }
        }
        
    }
}

class PagingVideoTableCell: UITableViewCell {
    
    @IBOutlet weak var thumbnail: UIImageView!
    @IBOutlet weak var typeLabel: MarqueeLabel!
    @IBOutlet weak var name: MarqueeLabel!
    @IBOutlet weak var artist: MarqueeLabel!
    @IBOutlet weak var favoriteButton: UIButton!
    var favorited = false
    var currentVideo:AnyObject!
    
    override func prepareForReuse() {
        favoriteButton.setImage(UIImage(systemName: "heart"), for: .normal)
        favoriteButton.tintColor = .white
        favorited = false
    }
    
    
    func funcSetTemp(youtube: YouTubeData) {
        currentVideo = youtube
        name.text = youtube.title
        typeLabel.text = "--YOUTUBE--"
        var songart:[String] = []
//        for art in youtube.artist {
//            let word = art.split(separator: "Æ")
//            let id = word[1]
//            songart.append(String(id))
//        }
        artist.text = songart.joined(separator: ", ")
        let imageurl = youtube.thumbnailURL
        if let url = URL.init(string: imageurl) {
            if let cachedImage = imageCache.object(forKey: url.absoluteString as NSString) {
                thumbnail.image = cachedImage
            } else {
                thumbnail.setImage(from: url, withPlaceholder: UIImage(named: "tonedeaflogo"))
            }
        }
        for favorite in currentAppUser.favorites {
            if favorite.dbid.contains(youtube.toneDeafAppId) {
                favorited = true
                favoriteButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
                favoriteButton.tintColor = Constants.Colors.redApp
            }
        }
    }
    
    func funcSetTemp(youtube: YouTubeData, hide: Bool) {
        currentVideo = youtube
        name.text = youtube.title
        typeLabel.text = ""
//        if youtube.artist != [""] && !youtube.artist.isEmpty {
//            var songart:[String] = []
//            for art in youtube.artist {
//                let word = art.split(separator: "Æ")
//                let id = word[1]
//                songart.append(String(id))
//            }
//            artist.text = songart.joined(separator: ", ")
//        } else if youtube.producers != [""] && !youtube.producers.isEmpty {
//            var songpro:[String] = []
//            for pro in youtube.producers {
//                let word = pro.split(separator: "Æ")
//                let id = word[1]
//                songpro.append(String(id))
//            }
//            artist.text = songpro.joined(separator: ", ")
//        } else {
//            artist.text = ""
//        }
        let imageurl = youtube.thumbnailURL
        if let url = URL.init(string: imageurl) {
            if let cachedImage = imageCache.object(forKey: url.absoluteString as NSString) {
                thumbnail.image = cachedImage
            } else {
                thumbnail.setImage(from: url, withPlaceholder: UIImage(named: "tonedeaflogo"))
            }
        }
        for favorite in currentAppUser.favorites {
            if favorite.dbid.contains(youtube.toneDeafAppId) {
                favorited = true
                favoriteButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
                favoriteButton.tintColor = Constants.Colors.redApp
            }
        }
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
