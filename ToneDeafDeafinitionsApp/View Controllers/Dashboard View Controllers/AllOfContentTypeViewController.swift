//
//  AllOfContentTypeViewController.swift
//  ToneDeafDeafinitionsApp
//
//  Created by Tone Deaf on 10/1/20.
//  Copyright © 2020 GITEM Solutions. All rights reserved.
//

import UIKit
import SkeletonView

class AllOfContentTypeViewController: UIViewController {
    
    var lastContentOffset: CGFloat = 0
    var maxHeaderHeight: CGFloat = 0
    var visualEffectView:UIVisualEffectView!
    
    @IBOutlet weak var scrollview1: UIScrollView!
    @IBOutlet weak var allOfFeaturedTableView: UITableView!
    @IBOutlet weak var allOfDiscoverTableView: UITableView!
    
    @IBOutlet weak var tableViewHeightConstraint: NSLayoutConstraint!

    @IBOutlet weak var tonespickbackground: UIImageView!
    @IBOutlet weak var tonespickimage: UIImageView!
    @IBOutlet weak var tonespickrelease: UILabel!
    @IBOutlet weak var tonespickartistproducers: UILabel!
    @IBOutlet weak var tonespickname: UILabel!
    @IBOutlet weak var tonespickbutton: UIButton!
    @IBOutlet weak var tonespickstack: UIStackView!
    
    var lastSongs:[SongData] = []
    var lastVideos:[AnyObject] = []
    var lastArtist:[ArtistData] = []
    var lastProducer:[ProducerData] = []
    var lastAlbums:[AlbumData] = []
    var lastInstrumentals:[InstrumentalData] = []
    
    var tonesPick:Any!
    
    var recievedData:String!
    var infoDetailContent:Any!
    var artistInfo:ArtistData!
    var producerInfo:ProducerData!
    var beatInfo:BeatData!
    
    var featuredContent:[Any]!
    
    var lastContent:[Any]!
    var knownOldestSongElement:SongData!
    var knownOldestArtistElement:ArtistData!
    var knownOldestProducerElement:ProducerData!
    var knownOldestAlbumElement:AlbumData!
    var knownOldestInstrumentalElement:InstrumentalData!
    var knownOldestVideoElement:AnyObject!
    var lastfetchedkey = ""
    var all = false
    var skelvar = 0
    var browseload = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if visualEffectView != nil {
            visualEffectView.removeFromSuperview()
        }
        visualEffectView = nil
        createObservers()
        setNav()
        setTonePick()
        setUpSearchController()
        scrollview1.delegate = self
        setInitialPage(completion: {})
        setFeatured(completion: {})
        let nib = UINib(nibName: "Header", bundle: nil)
        allOfFeaturedTableView.register(nib, forHeaderFooterViewReuseIdentifier: "TableSectionHeader")
        allOfDiscoverTableView.register(nib, forHeaderFooterViewReuseIdentifier: "TableSectionHeader")
        allOfFeaturedTableView.delegate = self
        allOfFeaturedTableView.dataSource = self
        allOfDiscoverTableView.delegate = self
        allOfDiscoverTableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
          self.navigationController?.navigationBar.shadowImage = UIImage()
          self.navigationController?.navigationBar.isTranslucent = true
        if scrollview1.contentOffset.y <= 0 {
            if visualEffectView != nil {
                visualEffectView.removeFromSuperview()
            }
            visualEffectView = nil
        } else {
            if visualEffectView != nil {
                visualEffectView.removeFromSuperview()
                visualEffectView = nil
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
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
          self.navigationController?.navigationBar.shadowImage = UIImage()
          self.navigationController?.navigationBar.isTranslucent = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        if visualEffectView != nil {
            visualEffectView.removeFromSuperview()
        }
        visualEffectView = nil
        if skelvar == 0 {
            allOfFeaturedTableView.isSkeletonable = true
            allOfFeaturedTableView.showAnimatedGradientSkeleton(usingGradient: .init(baseColor: UIColor.init(red: 22/255, green: 22/255, blue: 22/255, alpha: 1)), animation: nil, transition: .crossDissolve(0.25))
            allOfDiscoverTableView.isSkeletonable = true
            allOfDiscoverTableView.showAnimatedGradientSkeleton(usingGradient: .init(baseColor: UIColor.init(red: 22/255, green: 22/255, blue: 22/255, alpha: 1)), animation: nil, transition: .crossDissolve(0.25))
        }
        
        
        
        skelvar+=1
    }
    
    func hideskeleton(discover: UITableView) {
        skelvar+=1
        DispatchQueue.main.async {[weak self] in
            guard let strongSelf = self else {return}
            print("hiding skeleton")
            discover.stopSkeletonAnimation()
            discover.hideSkeleton(reloadDataAfter: false, transition: .crossDissolve(0.25))
            discover.reloadData()
            strongSelf.tableViewHeightConstraint.constant = strongSelf.allOfDiscoverTableView.contentSize.height
            strongSelf.view.layoutSubviews()
        }
    }
    
    func createObservers() {
        NotificationCenter.default.removeObserver(self)
        NotificationCenter.default.addObserver(self, selector: #selector(transitionToArtistInfoFromNotify), name: transitionAllOfToArtNotify, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(transitionToProducerInfoFromNotify(notification:)), name: transitionAllOfToProNotify, object: nil)
         NotificationCenter.default.addObserver(self, selector: #selector(seg(notification:)), name: transitionAllOfToInfoNotify, object: nil)
    }
    
    func setUpSearchController() {
        self.extendedLayoutIncludesOpaqueBars = true
        self.navigationController?.navigationItem.largeTitleDisplayMode = .never
        self.definesPresentationContext = true
    }
    
    func setNav() {
        guard let navBar = self.navigationController?.navigationBar else {return}
        navBar.prefersLargeTitles = false
        switch recievedData {
        case "artist":
            self.navigationItem.title = "Artists"
        case "producer":
            self.navigationItem.title = "Producers"
        case "song":
            self.navigationItem.title = "Songs"
        case "video":
            self.navigationItem.title = "Videos"
        case "album":
            self.navigationItem.title = "Albums"
        default:
            self.navigationItem.title = "Instrumentals"
        }
    }
    
    func setTonePick() {
        switch recievedData {
        case "artist":
            tonespickbackground.isHidden = true
            tonespickname.isHidden = true
            tonespickimage.isHidden = true
            tonespickrelease.isHidden = true
            tonespickartistproducers.isHidden = true
            tonespickbutton.isHidden = true
            tonespickstack.isHidden = true
        case "producer":
            tonespickbackground.isHidden = true
            tonespickname.isHidden = true
            tonespickimage.isHidden = true
            tonespickrelease.isHidden = true
            tonespickartistproducers.isHidden = true
            tonespickbutton.isHidden = true
            tonespickstack.isHidden = true
        case "song":
            DatabaseManager.shared.fetchTonesPickSong(completion: {[weak self] song in
                guard let strongSelf = self else {return}
                strongSelf.tonesPick = song
                Comparisons.shared.getEarliestReleaseDate(song: song, completion: { date in
                    strongSelf.getYoutubeData(song: song, completion: {[weak self] videos,videothumbnails in
                        guard let strongSelf = self else {return}
                        strongSelf.tonespickname.text = song.name
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
                        strongSelf.tonespickartistproducers.text = "\(songart.joined(separator: ",")), \(songapro.joined(separator: ","))"
                        strongSelf.tonespickrelease.text = date
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
                            strongSelf.tonespickimage.image = cachedImage
                        } else {
                            strongSelf.tonespickimage.setImage(from: imageURL, withPlaceholder: UIImage(named: "tonedeaflogo"))
                        }
                        strongSelf.blurredBackground(url: imageURL, videoCellView: strongSelf.tonespickbackground)
                    })
                })
            })
        case "video":
            DatabaseManager.shared.fetchTonesPickVideo(completion: {[weak self] vid in
                guard let strongSelf = self else {return}
                switch vid {
                case is YouTubeData:
                    let video = vid as! YouTubeData
                    strongSelf.tonesPick = video
                    strongSelf.tonespickname.text = video.title
                    var songart:[String] = []
//                    for art in video.artist {
//                        let word = art.split(separator: "Æ")
//                        let id = word[1]
//                        songart.append(String(id))
//                    }
                    var songapro:[String] = []
//                    for pro in video.producers {
//                        let word = pro.split(separator: "Æ")
//                        let id = word[1]
//                        songapro.append(String(id))
//                    }
                    strongSelf.tonespickartistproducers.text = "\(songart.joined(separator: ",")), \(songapro.joined(separator: ","))"
                    strongSelf.tonespickrelease.text = video.dateYT
                    var imageurl = ""
                    if video.thumbnailURL != "" {
                        imageurl = video.thumbnailURL
                    }
                    let imageURL = URL(string: imageurl)!
                    if let cachedImage = imageCache.object(forKey: imageURL.absoluteString as NSString) {
                        strongSelf.tonespickimage.image = cachedImage
                    } else {
                        strongSelf.tonespickimage.setImage(from: imageURL, withPlaceholder: UIImage(named: "tonedeaflogo"))
                    }
                    strongSelf.blurredBackground(url: imageURL, videoCellView: strongSelf.tonespickbackground)
                default:
                    print("sumn else")
                }
            })
        case "album":
            DatabaseManager.shared.fetchTonesPickAlbum(completion: {[weak self] album in
                guard let strongSelf = self else {return}
                strongSelf.tonesPick = album
                strongSelf.tonespickname.text = album.name
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
//                if album.spotifyData?.imageURL != "" {
//                    guard let url = album.spotifyData?.imageURL else {
//                        fatalError()}
//                    imageurl = url
//                } else if album.appleData?.imageURL != "" {
//                    guard let url = album.appleData?.imageURL else {
//                        fatalError()}
//                    imageurl = url
//                }
//                strongSelf.tonespickartistproducers.text = "\(songart.joined(separator: ",")), \(songapro.joined(separator: ","))"
//                if album.spotifyData?.dateReleasedSpotify != "" {
//                    guard let date = album.spotifyData?.dateReleasedSpotify else {
//                        fatalError()}
//                    strongSelf.tonespickrelease.text = date
//                } else if album.appleData?.dateReleasedApple != "" {
//                    guard let date = album.appleData?.dateReleasedApple  else {
//                        fatalError()}
//                    strongSelf.tonespickrelease.text = date
//                }
                let imageURL = URL(string: imageurl)!
                if let cachedImage = imageCache.object(forKey: imageURL.absoluteString as NSString) {
                    strongSelf.tonespickimage.image = cachedImage
                } else {
                    strongSelf.tonespickimage.setImage(from: imageURL, withPlaceholder: UIImage(named: "tonedeaflogo"))
                }
                strongSelf.blurredBackground(url: imageURL, videoCellView: strongSelf.tonespickbackground)
            })
        case "beat":
            DatabaseManager.shared.fetchTonesPickBeat(completion: {[weak self] beat in
                guard let strongSelf = self else {return}
                strongSelf.tonesPick = beat
                strongSelf.tonespickname.text = beat.name
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
                strongSelf.tonespickartistproducers.text = "\(songapro.joined(separator: ","))"
                if beat.date != "" {
                    strongSelf.tonespickrelease.text = beat.date
                }
                let imageURL = URL(string: imageurl)!
                if let cachedImage = imageCache.object(forKey: imageURL.absoluteString as NSString) {
                    strongSelf.tonespickimage.image = cachedImage
                } else {
                    strongSelf.tonespickimage.setImage(from: imageURL, withPlaceholder: UIImage(named: "tonedeaflogo"))
                }
                strongSelf.blurredBackground(url: imageURL, videoCellView: strongSelf.tonespickbackground)
            })
        default:
            DatabaseManager.shared.fetchTonesPickInstrumental(completion: {[weak self] instrumental in
                guard let strongSelf = self else {return}
                strongSelf.tonesPick = instrumental
                strongSelf.tonespickname.text = instrumental.instrumentalName
                var songapro:[String] = []
                for pro in instrumental.producers {
                    let word = pro.split(separator: "Æ")
                    let id = word[1]
                    songapro.append(String(id))
                }
                var imageurl:String = ""
//                if instrumental.imageURL != "" {
//                    imageurl = instrumental.imageURL
//                }
                strongSelf.tonespickrelease.text = ""
                strongSelf.tonespickartistproducers.text = "\(songapro.joined(separator: ","))"
                let imageURL = URL(string: imageurl)!
                if let cachedImage = imageCache.object(forKey: imageURL.absoluteString as NSString) {
                    strongSelf.tonespickimage.image = cachedImage
                } else {
                    strongSelf.tonespickimage.setImage(from: imageURL, withPlaceholder: UIImage(named: "tonedeaflogo"))
                }
                strongSelf.blurredBackground(url: imageURL, videoCellView: strongSelf.tonespickbackground)
            })
        }
        
    }
    
    func setFeatured(completion: @escaping (() -> Void)) {
        featuredContent = []
        switch recievedData {
        case "artist":
            var tick = 0
            DatabaseManager.shared.getRandomArtist(num: 15, completion: {[weak self] ids in
                guard let strongSelf = self else {return}
                for id in ids {
                    DatabaseManager.shared.fetchArtistData(artist: id, completion: { artist in
                        strongSelf.featuredContent.append(artist)
                        tick+=1
                        print("discover \(tick)")
                        if tick == ids.count {
                            strongSelf.hideskeleton(discover: strongSelf.allOfFeaturedTableView)
                            completion()
                        }
                    })
                }
            })
        case "producer":
            var tick = 0
            DatabaseManager.shared.getRandomProducer(num: 15, completion: {[weak self] ids in
                guard let strongSelf = self else {return}
                for id in ids {
                    DatabaseManager.shared.fetchPersonData(person: id, completion: { producer in
                        strongSelf.featuredContent.append(producer)
                        tick+=1
                        print("discover \(tick)")
                        if tick == ids.count {
                            strongSelf.hideskeleton(discover: strongSelf.allOfFeaturedTableView)
                            completion()
                        }
                    })
                }
            })
        case "song":
            var tick = 0
            DatabaseManager.shared.getRandomSong(num: 15, completion: {[weak self] ids in
                guard let strongSelf = self else {return}
                for id in ids {
                    DatabaseManager.shared.findSongById(songId: id, completion: { result in
                        switch result {
                        case .success(let song):
                            strongSelf.featuredContent.append(song)
                            tick+=1
                            print("discover \(tick)")
                            if tick == ids.count {
                                strongSelf.hideskeleton(discover: strongSelf.allOfFeaturedTableView)
                                completion()
                            }
                        case .failure(let error):
                            tick+=1
                            print("discover \(tick)")
                            if tick == ids.count {
                                strongSelf.hideskeleton(discover: strongSelf.allOfFeaturedTableView)
                                completion()
                            }
                            print("discover \(error)")
                        }
                    })
                }
            })
        case "video":
            var tick = 0
            DatabaseManager.shared.getRandomVideo(num: 15, completion: {[weak self] ids in
                guard let strongSelf = self else {return}
                for id in ids {
                    DatabaseManager.shared.findVideoById(videoid: id, completion: { result in
                        switch result {
                        case .success(let video):
                            switch video {
                            case is YouTubeData:
                                let youtube = video as! YouTubeData
                                strongSelf.featuredContent.append(youtube)
                                tick+=1
                                print("discover \(tick)")
                                if tick == ids.count {
                                    strongSelf.hideskeleton(discover: strongSelf.allOfFeaturedTableView)
                                    completion()
                                }
                            default:
                                tick+=1
                                print("discover \(tick)")
                                print("guess b")
                            }
                        case .failure(let error):
                            tick+=1
                            print("discover \(tick)")
                            if tick == ids.count {
                                strongSelf.hideskeleton(discover: strongSelf.allOfFeaturedTableView)
                                completion()
                            }
                            print("discover \(error)")
                        }
                    })
                }
            })
        case "album":
            var tick = 0
            DatabaseManager.shared.getRandomAlbum(num: 15, completion: {[weak self] ids in
                guard let strongSelf = self else {return}
                for id in ids {
                    DatabaseManager.shared.findAlbumById(albumId: id, completion: { result in
                        switch result {
                        case .success(let album):
                            strongSelf.featuredContent.append(album)
                            tick+=1
                            print("discover \(tick)")
                            if tick == ids.count {
                                strongSelf.hideskeleton(discover: strongSelf.allOfFeaturedTableView)
                                completion()
                            }
                        case .failure(let error):
                            tick+=1
                            print("discover \(tick)")
                            if tick == ids.count {
                                strongSelf.hideskeleton(discover: strongSelf.allOfFeaturedTableView)
                                completion()
                            }
                            print("discover \(error)")
                        }
                    })
                }
            })
        default:
            var tick = 0
            DatabaseManager.shared.getRandomInstrumental(num: 15, completion: {[weak self] ids in
                guard let strongSelf = self else {return}
                for id in ids {
                    DatabaseManager.shared.findInstrumentalById(instrumentalId: id, completion: { result in
                        switch result {
                        case .success(let instrumental):
                            strongSelf.featuredContent.append(instrumental)
                            tick+=1
                            print("discover \(tick)")
                            if tick == ids.count {
                                strongSelf.hideskeleton(discover: strongSelf.allOfFeaturedTableView)
                                completion()
                            }
                        case .failure(let error):
                            tick+=1
                            print("discover \(tick)")
                            if tick == ids.count {
                                strongSelf.hideskeleton(discover: strongSelf.allOfFeaturedTableView)
                                completion()
                            }
                            print("discover \(error)")
                        }
                    })
                }
            })
        }
    }
    
    func setInitialPage(completion: @escaping (() -> Void)) {
        switch recievedData {
        case "artist":
            if artistdiscoverArray.isEmpty {
                buildArtistDiscoverArray(completion: {[weak self] disc in
                    guard let strongSelf = self else {return}
                    artistdiscoverArray = disc
                    strongSelf.lastArtist = disc
                    strongSelf.knownOldestArtistElement = artistdiscoverArray.last
                    strongSelf.buildKey(completion: { key in
                        print("discover done")
                        strongSelf.lastfetchedkey = key
                        strongSelf.hideskeleton(discover: strongSelf.allOfDiscoverTableView)
                        completion()
                    })
                })
            } else {
                knownOldestArtistElement = artistdiscoverArray.last
                buildKey(completion: {[weak self] key in
                    guard let strongSelf = self else {return}
                    strongSelf.lastfetchedkey = key
                    strongSelf.hideskeleton(discover: strongSelf.allOfDiscoverTableView)
                    completion()
                })
            }
        case "producer":
            if producerdiscoverArray.isEmpty {
                buildProducerDiscoverArray(completion: {[weak self] disc in
                    guard let strongSelf = self else {return}
                    producerdiscoverArray = disc
                    strongSelf.lastProducer = disc
                    strongSelf.knownOldestProducerElement = producerdiscoverArray.last
                    strongSelf.buildKey(completion: { key in
                        print("discover done")
                        strongSelf.lastfetchedkey = key
                        strongSelf.hideskeleton(discover: strongSelf.allOfDiscoverTableView)
                        completion()
                    })
                })
            } else {
                knownOldestProducerElement = producerdiscoverArray.last
                buildKey(completion: {[weak self] key in
                    guard let strongSelf = self else {return}
                    strongSelf.lastfetchedkey = key
                    strongSelf.hideskeleton(discover: strongSelf.allOfDiscoverTableView)
                    completion()
                })
            }
        case "song":
            if songdiscoverArray.isEmpty {
                buildSongDiscoverArray(completion: {[weak self] disc in
                    guard let strongSelf = self else {return}
                    songdiscoverArray = disc
                    strongSelf.lastSongs = disc
                    strongSelf.knownOldestSongElement = songdiscoverArray.last
                    strongSelf.buildKey(completion: { key in
                        print("discover done")
                        strongSelf.lastfetchedkey = key
                        strongSelf.hideskeleton(discover: strongSelf.allOfDiscoverTableView)
                        completion()
                    })
                })
            } else {
                knownOldestSongElement = songdiscoverArray.last
                buildKey(completion: {[weak self] key in
                    guard let strongSelf = self else {return}
                    strongSelf.lastfetchedkey = key
                    strongSelf.hideskeleton(discover: strongSelf.allOfDiscoverTableView)
                    completion()
                })
            }
        case "video":
            if videodiscoverArray.isEmpty {
                buildVideoDiscoverArray(completion: {[weak self] disc in
                    guard let strongSelf = self else {return}
                    videodiscoverArray = disc
                    strongSelf.lastVideos = disc
                    strongSelf.knownOldestVideoElement = videodiscoverArray.last
                    strongSelf.buildKey(completion: { key in
                        print("discover done")
                        strongSelf.lastfetchedkey = key
                        strongSelf.hideskeleton(discover: strongSelf.allOfDiscoverTableView)
                        completion()
                    })
                })
            } else {
                knownOldestVideoElement = videodiscoverArray.last
                buildKey(completion: {[weak self] key in
                    guard let strongSelf = self else {return}
                    strongSelf.lastfetchedkey = key
                    strongSelf.hideskeleton(discover: strongSelf.allOfDiscoverTableView)
                    completion()
                })
            }
        case "album":
            if albumdiscoverArray.isEmpty {
                buildAlbumDiscoverArray(completion: {[weak self] disc in
                    guard let strongSelf = self else {return}
                    albumdiscoverArray = disc
                    strongSelf.lastAlbums = disc
                    strongSelf.knownOldestAlbumElement = albumdiscoverArray.last
                    strongSelf.buildKey(completion: { key in
                        print("discover done")
                        strongSelf.lastfetchedkey = key
                        strongSelf.hideskeleton(discover: strongSelf.allOfDiscoverTableView)
                        completion()
                    })
                })
            } else {
                knownOldestAlbumElement = albumdiscoverArray.last
                buildKey(completion: {[weak self] key in
                    guard let strongSelf = self else {return}
                    strongSelf.lastfetchedkey = key
                    strongSelf.hideskeleton(discover: strongSelf.allOfDiscoverTableView)
                    completion()
                })
            }
        default:
            if instrumentaldiscoverArray.isEmpty {
                
                buildInstrumentalDiscoverArray(completion: {[weak self] disc in
                    guard let strongSelf = self else {return}
                    
                    instrumentaldiscoverArray = disc
                    strongSelf.lastInstrumentals = disc
                    strongSelf.knownOldestInstrumentalElement = instrumentaldiscoverArray.last
                    strongSelf.buildKey(completion: { key in
                        print("discover done")
                        strongSelf.lastfetchedkey = key
                        strongSelf.hideskeleton(discover: strongSelf.allOfDiscoverTableView)
                        completion()
                    })
                })
            } else {
                knownOldestInstrumentalElement = instrumentaldiscoverArray.last
                buildKey(completion: {[weak self] key in
                    guard let strongSelf = self else {return}
                    strongSelf.lastfetchedkey = key
                    strongSelf.hideskeleton(discover: strongSelf.allOfDiscoverTableView)
                    completion()
                })
            }
        }
    }
    
    func buildSongDiscoverArray(completion: @escaping (([SongData]) -> Void)) {
        var tick = 0
        var array:[SongData] = []
            DatabaseManager.shared.getRandomSong(num: 15, completion: {[weak self] ids in
                guard let strongSelf = self else {return}
                for id in ids {
                    DatabaseManager.shared.findSongById(songId: id, completion: { result in
                        switch result {
                        case .success(let song):
                            array.append(song)
                            tick+=1
                            print("discover \(tick)")
                            if tick == ids.count {
                                completion(array)
                            }
                        case .failure(let error):
                            tick+=1
                            print("discover \(tick)")
                            if tick == ids.count {
                                completion(array)
                            }
                            print("discover \(error)")
                        }
                    })
                }
            })
    }
    
    func buildVideoDiscoverArray(completion: @escaping (([AnyObject]) -> Void)) {
        var tick = 0
        var array:[AnyObject] = []
        DatabaseManager.shared.getRandomVideo(num: 15, completion: {[weak self] ids in
            guard let strongSelf = self else {return}
            for id in ids {
                DatabaseManager.shared.findVideoById(videoid: id, completion: { result in
                    switch result {
                    case .success(let video):
                        switch video {
                        case is YouTubeData:
                            let youtube = video as! YouTubeData
                            array.append(youtube)
                            tick+=1
                            print("discover \(tick)")
                            if tick == ids.count {
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
                        if tick == ids.count {
                            completion(array)
                        }
                        print("discover \(error)")
                    }
                })
            }
        })
    }
    
    func buildAlbumDiscoverArray(completion: @escaping (([AlbumData]) -> Void)) {
        var tick = 0
        var array:[AlbumData] = []
        DatabaseManager.shared.getRandomAlbum(num: 15, completion: {[weak self] ids in
            guard let strongSelf = self else {return}
            for id in ids {
                DatabaseManager.shared.findAlbumById(albumId: id, completion: { result in
                    switch result {
                    case .success(let album):
                        array.append(album)
                        tick+=1
                        print("discover \(tick)")
                        if tick == ids.count {
                            completion(array)
                        }
                    case .failure(let error):
                        tick+=1
                        print("discover \(tick)")
                        if tick == ids.count {
                            completion(array)
                        }
                        print("discover \(error)")
                    }
                })
            }
        })
    }
    
    func buildInstrumentalDiscoverArray(completion: @escaping (([InstrumentalData]) -> Void)) {
        var tick = 0
        var array:[InstrumentalData] = []
        DatabaseManager.shared.getRandomInstrumental(num: 15, completion: {[weak self] ids in
            guard let strongSelf = self else {return}
            for id in ids {
                DatabaseManager.shared.findInstrumentalById(instrumentalId: id, completion: { result in
                    switch result {
                    case .success(let instrumental):
                        array.append(instrumental)
                        tick+=1
                        print("discover \(tick)")
                        if tick == ids.count {
                            completion(array)
                        }
                    case .failure(let error):
                        tick+=1
                        print("discover \(tick)")
                        if tick == ids.count {
                            completion(array)
                        }
                        print("discover \(error)")
                    }
                })
            }
        })
    }

    func buildArtistDiscoverArray(completion: @escaping (([ArtistData]) -> Void)) {
        var tick = 0
        var array:[ArtistData] = []
        DatabaseManager.shared.getRandomArtist(num: 15, completion: {[weak self] ids in
            guard let strongSelf = self else {return}
            for id in ids {
                DatabaseManager.shared.fetchArtistData(artist: id, completion: { artist in
                    array.append(artist)
                    tick+=1
                    print("discover \(tick)")
                    if tick == ids.count {
                        completion(array)
                    }
                })
            }
        })
    }
    
    func buildProducerDiscoverArray(completion: @escaping (([ProducerData]) -> Void)) {
        var tick = 0
        var array:[ProducerData] = []
        DatabaseManager.shared.getRandomProducer(num: 15, completion: {[weak self] ids in
            guard let strongSelf = self else {return}
            for id in ids {
                DatabaseManager.shared.fetchPersonData(person: id, completion: { producer in
//                    array.append(producer)
                    tick+=1
                    print("discover \(tick)")
                    if tick == ids.count {
                        completion(array)
                    }
                })
            }
        })
    }
    
    func buildKey(completion: @escaping ((String) -> Void)) {
        let item:Any!
        if knownOldestSongElement != nil {
            item = knownOldestSongElement
        } else
        if knownOldestAlbumElement != nil {
            item = knownOldestAlbumElement
        } else
        if knownOldestInstrumentalElement != nil {
            item = knownOldestInstrumentalElement
        } else
        if knownOldestArtistElement != nil {
            item = knownOldestArtistElement
        } else
        if knownOldestProducerElement != nil {
            item = knownOldestProducerElement
        } else{
            item = knownOldestVideoElement
        }
        switch item {
        case is YouTubeData:
            let video = item as! YouTubeData
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
        default:
            let song = item as! SongData
            var songart:[String] = []
            for art in song.songArtist {
                let word = art.split(separator: "Æ")
                let id = word[1]
                songart.append(String(id))
            }
            lastfetchedkey = "\(songContentTag)--\(song.name)--\(songart.joined(separator: ", "))--\(song.toneDeafAppId)"
            completion(lastfetchedkey)
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
        if segue.identifier == "allOfToInfo" {
            if let viewController: InfoDetailViewController = segue.destination as? InfoDetailViewController {
                viewController.content = infoDetailContent
            }
        } else if segue.identifier == "allOfToArt" {
            if let viewController: ArtistInfoViewController = segue.destination as? ArtistInfoViewController {
                recievedArtistData = artistInfo
            }
        } else if segue.identifier == "allOfToPro" {
            if let viewController: ProducerInfoViewController = segue.destination as? ProducerInfoViewController {
                recievedProducerData = producerInfo
            }
        }
    }
    
    @objc func seg(notification: Notification) {
        //print("seging")
        infoDetailContent = notification.object
        performSegue(withIdentifier: "allOfToInfo", sender: nil)
    }
    
    @objc func transitionToArtistInfoFromNotify(notification: Notification) {
        artistInfo = notification.object as! ArtistData
        performSegue(withIdentifier: "allOfToArt", sender: nil)
    }
    
    @objc func transitionToProducerInfoFromNotify(notification: Notification) {
        producerInfo = notification.object as! ProducerData
        performSegue(withIdentifier: "allOfToPro", sender: nil)
    }
    
    @IBAction func tonesPickTapped(_ sender: Any) {
        infoDetailContent = tonesPick
        performSegue(withIdentifier: "allOfToInfo", sender: nil)
    }

}

extension AllOfContentTypeViewController: UISearchControllerDelegate {
    
    func willDismissSearchController(_ searchController: UISearchController) {
        UIView.animate(withDuration: 0.3) { [weak self] in
            guard let strongSelf = self else {return}
            searchController.hidesNavigationBarDuringPresentation = false
            strongSelf.view.layoutSubviews()
        }
    }
}

extension AllOfContentTypeViewController: UISearchBarDelegate {
}

extension AllOfContentTypeViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollview1.isBouncingBottom {
            switch recievedData {
            case "artist":
                guard !artistdiscoverArray.isEmpty else { return }
                guard all != true else {return}
                buildArtistDiscoverArray(completion: {[weak self] disc in
                    guard let strongSelf = self else {return}
                    if disc == strongSelf.lastArtist {
                        strongSelf.all = true
                        return
                    }
                    strongSelf.lastArtist = disc
                    for song in disc {
                        if !artistdiscoverArray.contains(song) {
                            artistdiscoverArray.append(song)
                        }
                    }
                    strongSelf.knownOldestArtistElement = artistdiscoverArray.last
                    strongSelf.buildKey(completion: { key in
                        strongSelf.lastfetchedkey = key
                        strongSelf.allOfDiscoverTableView.reloadData()
                        DispatchQueue.main.async {
                            strongSelf.tableViewHeightConstraint.constant = strongSelf.allOfDiscoverTableView.contentSize.height
                            strongSelf.view.layoutSubviews()
                        }
                    })
                })
            case "producer":
                guard !producerdiscoverArray.isEmpty else { return }
                guard all != true else {return}
                buildProducerDiscoverArray(completion: {[weak self] disc in
                    guard let strongSelf = self else {return}
                    if disc == strongSelf.lastProducer {
                        strongSelf.all = true
                        return
                    }
                    strongSelf.lastProducer = disc
                    for song in disc {
                        if !producerdiscoverArray.contains(song) {
                            producerdiscoverArray.append(song)
                        }
                    }
                    strongSelf.knownOldestProducerElement = producerdiscoverArray.last
                    strongSelf.buildKey(completion: { key in
                        strongSelf.lastfetchedkey = key
                        strongSelf.allOfDiscoverTableView.reloadData()
                        DispatchQueue.main.async {
                            strongSelf.tableViewHeightConstraint.constant = strongSelf.allOfDiscoverTableView.contentSize.height
                            strongSelf.view.layoutSubviews()
                        }
                    })
                })
            case "song":
                guard !songdiscoverArray.isEmpty else { return }
                guard all != true else {return}
                buildSongDiscoverArray(completion: {[weak self] disc in
                    guard let strongSelf = self else {return}
                    if disc == strongSelf.lastSongs {
                        strongSelf.all = true
                        return
                    }
                    strongSelf.lastSongs = disc
                    for song in disc {
                        if !songdiscoverArray.contains(song) {
                            songdiscoverArray.append(song)
                        }
                    }
                    strongSelf.knownOldestSongElement = songdiscoverArray.last
                    strongSelf.buildKey(completion: { key in
                        strongSelf.lastfetchedkey = key
                        strongSelf.allOfDiscoverTableView.reloadData()
                        DispatchQueue.main.async {
                            strongSelf.tableViewHeightConstraint.constant = strongSelf.allOfDiscoverTableView.contentSize.height
                            strongSelf.view.layoutSubviews()
                        }
                    })
                })
            case "video":
                guard !videodiscoverArray.isEmpty else { return }
                guard all != true else {return}
                buildVideoDiscoverArray(completion: {[weak self] disc in
                    guard let strongSelf = self else {return}
                    var match = true
                    var i:Int = 0
                    for vid in disc {
                        switch vid {
                        case is YouTubeData:
                            let test = DatabaseManager.shared.isEqual(type: YouTubeData.self, a: vid, b: strongSelf.lastVideos[i])
                            if test == false {
                                match = false
                                break
                            } else {
                                i+=1
                            }
                        default:
                            print("jdsbnk")
                        }
                    }
                    if match == true {
                        strongSelf.all = true
                        return
                    }
                    if match == false && strongSelf.all == false {
                        videodiscoverArray.append(contentsOf: disc)
                    }
                    strongSelf.lastVideos = disc
                    strongSelf.knownOldestVideoElement = videodiscoverArray.last
                    strongSelf.buildKey(completion: { key in
                        strongSelf.lastfetchedkey = key
                        strongSelf.allOfDiscoverTableView.reloadData()
                        DispatchQueue.main.async {
                            strongSelf.tableViewHeightConstraint.constant = strongSelf.allOfDiscoverTableView.contentSize.height
                            strongSelf.view.layoutSubviews()
                        }
                    })
                })
            case "album":
                guard !albumdiscoverArray.isEmpty else { return }
                guard all != true else {return}
                buildAlbumDiscoverArray(completion: {[weak self] disc in
                    guard let strongSelf = self else {return}
                    if disc == strongSelf.lastAlbums{
                        strongSelf.all = true
                        return
                    }
                    strongSelf.lastAlbums = disc
                    for song in disc {
                        if !albumdiscoverArray.contains(song) {
                            albumdiscoverArray.append(song)
                        }
                    }
                    strongSelf.knownOldestAlbumElement = albumdiscoverArray.last
                    strongSelf.buildKey(completion: { key in
                        strongSelf.lastfetchedkey = key
                        strongSelf.allOfDiscoverTableView.reloadData()
                        DispatchQueue.main.async {
                            strongSelf.tableViewHeightConstraint.constant = strongSelf.allOfDiscoverTableView.contentSize.height
                            strongSelf.view.layoutSubviews()
                        }
                    })
                })
            default:
                guard !instrumentaldiscoverArray.isEmpty else { return }
                guard all != true else {return}
                buildInstrumentalDiscoverArray(completion: {[weak self] disc in
                    guard let strongSelf = self else {return}
                    if disc == strongSelf.lastInstrumentals {
                        strongSelf.all = true
                        return
                    }
                    strongSelf.lastInstrumentals = disc
                    for song in disc {
                        if !instrumentaldiscoverArray.contains(song) {
                            instrumentaldiscoverArray.append(song)
                        }
                    }
                    strongSelf.knownOldestInstrumentalElement = instrumentaldiscoverArray.last
                    strongSelf.buildKey(completion: { key in
                        strongSelf.lastfetchedkey = key
                        strongSelf.allOfDiscoverTableView.reloadData()
                        DispatchQueue.main.async {
                            strongSelf.tableViewHeightConstraint.constant = strongSelf.allOfDiscoverTableView.contentSize.height
                            strongSelf.view.layoutSubviews()
                        }
                    })
                })
            }
        }
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

extension AllOfContentTypeViewController : UITableViewDelegate, UITableViewDataSource, SkeletonTableViewDataSource {
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if tableView == allOfDiscoverTableView {
            
        }

    }
    
    func collectionSkeletonView(_ skeletonView: UITableView, cellIdentifierForRowAt indexPath: IndexPath) -> ReusableCellIdentifier {
        switch skeletonView {
        case allOfFeaturedTableView:
            return "artistSongsWithToneTableCellController"
        default:
            return "pagingCell"
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if self.tableView(tableView, numberOfRowsInSection: section) > 0 {
            return 70
        } else {
            return 0
        }
   }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableHeaderFooterView(withIdentifier: "TableSectionHeader") as! TableSectionHeader
        var sectitle = ""
        switch tableView {
        case allOfFeaturedTableView:
            sectitle = "Featured"
        default:
            switch recievedData {
            case "artist":
                sectitle = "All Artists"
            case "producer":
                sectitle = "All Producers"
            case "song":
                sectitle = "All Songs"
            case "video":
                sectitle = "All Videos"
            case "album":
                sectitle = "All Albums"
            default:
                sectitle = "All Instrumentals"
            }
        }
        let header = cell
        header.titleLabel.text = sectitle
        
        return cell
        
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        let numberOfSections = 1
        return numberOfSections
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var rheight:CGFloat = 0
        switch tableView {
        case allOfFeaturedTableView:
            rheight = 230
        default:
            rheight = 80
        }
        return rheight
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var nor = 15
        switch tableView {
        case allOfDiscoverTableView:
            switch recievedData {
            case "artist":
                nor = artistdiscoverArray.count
            case "producer":
                nor = producerdiscoverArray.count
            case "song":
                nor = songdiscoverArray.count
            case "video":
                nor = videodiscoverArray.count
            case "album":
                nor = albumdiscoverArray.count
            default:
                nor = instrumentaldiscoverArray.count
            }
        default:
            nor = 1
        }
        return nor
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch tableView {
        case allOfFeaturedTableView:
            let cell = tableView.dequeueReusableCell(withIdentifier: "allOfTableCellController", for: indexPath) as! AllOfFeaturedTableCellController
            if !featuredContent.isEmpty {
                cell.funcSetTemp(array: featuredContent)
            }
            return cell
        default:
            switch recievedData {
            case "artist":
                if !artistdiscoverArray.isEmpty {
                    let item = artistdiscoverArray[indexPath.row]
                    let cell = tableView.dequeueReusableCell(withIdentifier: "pagingCell", for: indexPath) as! PagingTableCell
                    cell.funcSetTemp(artis: item, hide: true)
                    return cell
                } else {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "pagingCell", for: indexPath) as! PagingTableCell
                    return cell
                }
            case "producer":
                if !producerdiscoverArray.isEmpty {
                    let item = producerdiscoverArray[indexPath.row]
                    let cell = tableView.dequeueReusableCell(withIdentifier: "pagingCell", for: indexPath) as! PagingTableCell
                    cell.funcSetTemp(producer: item, hide: true)
                    return cell
                } else {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "pagingCell", for: indexPath) as! PagingTableCell
                    return cell
                }
            case "song":
                if !songdiscoverArray.isEmpty {
                    let item = songdiscoverArray[indexPath.row]
                    let cell = tableView.dequeueReusableCell(withIdentifier: "pagingCell", for: indexPath) as! PagingTableCell
                    cell.funcSetTemp(song: item, hide: true)
                    return cell
                } else {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "pagingCell", for: indexPath) as! PagingTableCell
                    return cell
                }
            case "video":
                if !videodiscoverArray.isEmpty {
                    let item = videodiscoverArray[indexPath.row]
                    let cell = tableView.dequeueReusableCell(withIdentifier: "pagingVideoCell", for: indexPath) as! PagingVideoTableCell
                    switch item {
                    case is YouTubeData:
                        cell.funcSetTemp(youtube: item as! YouTubeData, hide: true)
                        return cell
                    default:
                        return cell
                    }
                } else {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "pagingVideoCell", for: indexPath) as! PagingVideoTableCell
                    return cell
                }
            case "album":
                if !albumdiscoverArray.isEmpty {
                    let item = albumdiscoverArray[indexPath.row]
                    let cell = tableView.dequeueReusableCell(withIdentifier: "pagingCell", for: indexPath) as! PagingTableCell
                    cell.funcSetTemp(album: item, hide: true)
                    return cell
                } else {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "pagingCell", for: indexPath) as! PagingTableCell
                    return cell
                }
            default:
                if !instrumentaldiscoverArray.isEmpty {
                    let item = instrumentaldiscoverArray[indexPath.row]
                    let cell = tableView.dequeueReusableCell(withIdentifier: "pagingCell", for: indexPath) as! PagingTableCell
                    cell.funcSetTemp(instrumental: item, hide: true)
                    return cell
                } else {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "pagingCell", for: indexPath) as! PagingTableCell
                    return cell
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        if tableView == allOfDiscoverTableView {
            switch recievedData {
            case "artist":
                let item = artistdiscoverArray[indexPath.row]
                artistInfo = item
                performSegue(withIdentifier: "allOfToArt", sender: nil)
            case "producer":
                let item = producerdiscoverArray[indexPath.row]
                producerInfo = item
                performSegue(withIdentifier: "allOfToPro", sender: nil)
            case "song":
                let item = songdiscoverArray[indexPath.row]
                infoDetailContent = item
                performSegue(withIdentifier: "allOfToInfo", sender: nil)
            case "video":
                let item = videodiscoverArray[indexPath.row]
                infoDetailContent = item
                performSegue(withIdentifier: "allOfToInfo", sender: nil)
            case "album":
                let item = albumdiscoverArray[indexPath.row]
                infoDetailContent = item
                performSegue(withIdentifier: "allOfToInfo", sender: nil)
            default:
                let item = instrumentaldiscoverArray[indexPath.row]
                infoDetailContent = item
                performSegue(withIdentifier: "allOfToInfo", sender: nil)
            }
        }
    }
    
    
}

class AllOfFeaturedTableView: UITableView {
    override var intrinsicContentSize: CGSize {
        layoutIfNeeded()
        return CGSize(width: UIView.noIntrinsicMetric, height: contentSize.height)
    }
}

class AllOfFeaturedTableCellController: UITableViewCell {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    var cont:[Any]!
    
    func funcSetTemp(array: [Any]) {
        cont = array
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
}

extension AllOfFeaturedTableCellController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
        
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return cont.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let selected = cont[indexPath.item]
        switch selected {
        case is ArtistData:
            let art = selected as! ArtistData
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "allOfCollectionViewCellController", for: indexPath) as! AllOfFeaturedCollectionViewCellController
            cell.funcSetTemp(artis: art)
            return cell
        case is ProducerData:
            let pro = selected as! ProducerData
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "allOfCollectionViewCellController", for: indexPath) as! AllOfFeaturedCollectionViewCellController
            cell.funcSetTemp(producer: pro)
            return cell
        case is SongData:
            let song = selected as! SongData
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "allOfCollectionViewCellController", for: indexPath) as! AllOfFeaturedCollectionViewCellController
            cell.funcSetTemp(song: song)
            return cell
        case is AlbumData:
            let album = selected as! AlbumData
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "allOfCollectionViewCellController", for: indexPath) as! AllOfFeaturedCollectionViewCellController
            cell.funcSetTemp(album: album)
            return cell
        case is InstrumentalData:
            let instrumental = selected as! InstrumentalData
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "allOfCollectionViewCellController", for: indexPath) as! AllOfFeaturedCollectionViewCellController
            cell.funcSetTemp(instrumental: instrumental)
            return cell
        default:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "allOfVideoCollectionViewCellController", for: indexPath) as! AllOfFeaturedVideoCollectionViewCellController
            switch selected {
            case is YouTubeData:
                let video = selected as! YouTubeData
                cell.funcSetTemp(video: video)
            default:
                print("dhjvs xc")
            }
            return cell
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let son = cont[indexPath.item]
        switch son {
        case is ArtistData:
            let item = son as! ArtistData
            NotificationCenter.default.post(name: transitionAllOfToArtNotify, object: item)
        case is ProducerData:
            let item = son as! ProducerData
            NotificationCenter.default.post(name: transitionAllOfToProNotify, object: item)
        case is SongData:
            let item = son as! SongData
            NotificationCenter.default.post(name: transitionAllOfToInfoNotify, object: item)
        case is YouTubeData:
            let item = son as! YouTubeData
            NotificationCenter.default.post(name: transitionAllOfToInfoNotify, object: item)
        case is AlbumData:
            let item = son as! AlbumData
            NotificationCenter.default.post(name: transitionAllOfToInfoNotify, object: item)
        default:
            let item = son as! InstrumentalData
            NotificationCenter.default.post(name: transitionAllOfToInfoNotify, object: item)
        }
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        if cont[indexPath.item] is YouTubeData {
            return CGSize(width: 320, height: 230)
        } else {
            return CGSize(width: 160, height: 230)
        }
    }
    
    
    
}

class AllOfFeaturedCollectionViewCellController: UICollectionViewCell {
    
    @IBOutlet weak var artwork: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var artist: UILabel!
    @IBOutlet weak var producers: UILabel!
    
    override var isHighlighted: Bool {
        didSet{
            tapScale(cell: self, down: isHighlighted)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        artwork.image = nil
        name.text = ""
        artist.text = ""
        producers.text = ""
    }
    
    func getSongVideoData(song:SongData, completion: @escaping (Array<YouTubeData>, Array<String>) -> Void) {
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
                    }
                })
            }
        } else {
            completion(videosData, youtubeimageURLs)
        }
        
    }
    
    func funcSetTemp(song: SongData) {
        artwork.layer.cornerRadius = 4
        artwork.contentMode = .scaleAspectFill
        name.text = song.name
        setupartist(arts: song.songArtist, completion: { [weak self] artist in
            guard let strongSelf = self else {return}
            switch artist.count {
            case 2:
                strongSelf.artist.text = "Lyrics by \(artist[0]) & \(artist[1])"
            case 3:
                strongSelf.artist.text = "Lyrics by \(artist[0]), \(artist[1]) & \(artist[2])"
            case 4:
                strongSelf.artist.text = "Lyrics by \(artist[0]), \(artist[1]), \(artist[2]) artist \(artist[3])"
            case 5:
                strongSelf.artist.text = "Lyrics by \(artist[0]), \(artist[1]), \(artist[2]), \(artist[3]) & \(artist[4])"
            case 6:
                strongSelf.artist.text = "Lyrics by \(artist[0]), \(artist[1]), \(artist[2]), \(artist[3]), \(artist[4]) & \(artist[5])"
            default:
                strongSelf.artist.text = "Lyrics by \(artist[0])"
            }
        })
        setupproducers(pros: song.songProducers, completion: { [weak self] producer in
            guard let strongSelf = self else {return}
            switch producer.count {
            case 2:
                strongSelf.producers.text = "Produced by \(producer[0]) & \(producer[1])"
            case 3:
                strongSelf.producers.text = "Produced by \(producer[0]), \(producer[1]) & \(producer[2])"
            case 4:
                strongSelf.producers.text = "Produced by \(producer[0]), \(producer[1]), \(producer[2]) & \(producer[3])"
            case 5:
                strongSelf.producers.text = "Produced by \(producer[0]), \(producer[1]), \(producer[2]), \(producer[3]) & \(producer[4])"
            case 6:
                strongSelf.producers.text = "Produced by \(producer[0]), \(producer[1]), \(producer[2]), \(producer[3]), \(producer[4]) & \(producer[5])"
            default:
                strongSelf.producers.text = "Produced by \(producer[0])"
            }
        })
        var imageurl = ""
        GlobalFunctions.shared.selectImageURL(song: song, completion: {[weak self] ur in
            guard let strongSelf = self else {return}
            imageurl = ur!
            let imageURL = URL(string: imageurl)!
            strongSelf.artwork.setImage(from: imageURL, withPlaceholder: UIImage(named: "tonedeaflogo"))
        })
    }
    func funcSetTemp(album: AlbumData) {
        artwork.layer.cornerRadius = 4
        artwork.contentMode = .scaleAspectFill
        name.text = album.name
        setupartist(arts: album.mainArtist, completion: { [weak self] artist in
            guard let strongSelf = self else {return}
            switch artist.count {
            case 2:
                strongSelf.artist.text = "Lyrics by \(artist[0]) & \(artist[1])"
            case 3:
                strongSelf.artist.text = "Lyrics by \(artist[0]), \(artist[1]) & \(artist[2])"
            case 4:
                strongSelf.artist.text = "Lyrics by \(artist[0]), \(artist[1]), \(artist[2]) artist \(artist[3])"
            case 5:
                strongSelf.artist.text = "Lyrics by \(artist[0]), \(artist[1]), \(artist[2]), \(artist[3]) & \(artist[4])"
            case 6:
                strongSelf.artist.text = "Lyrics by \(artist[0]), \(artist[1]), \(artist[2]), \(artist[3]), \(artist[4]) & \(artist[5])"
            default:
                strongSelf.artist.text = "Lyrics by \(artist[0])"
            }
        })
        setupproducers(pros: album.producers, completion: { [weak self] producer in
            guard let strongSelf = self else {return}
            switch producer.count {
            case 2:
                strongSelf.producers.text = "Produced by \(producer[0]) & \(producer[1])"
            case 3:
                strongSelf.producers.text = "Produced by \(producer[0]), \(producer[1]) & \(producer[2])"
            case 4:
                strongSelf.producers.text = "Produced by \(producer[0]), \(producer[1]), \(producer[2]) & \(producer[3])"
            case 5:
                strongSelf.producers.text = "Produced by \(producer[0]), \(producer[1]), \(producer[2]), \(producer[3]) & \(producer[4])"
            case 6:
                strongSelf.producers.text = "Produced by \(producer[0]), \(producer[1]), \(producer[2]), \(producer[3]), \(producer[4]) & \(producer[5])"
            default:
                strongSelf.producers.text = "Produced by \(producer[0])"
            }
        })
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
    }
    func funcSetTemp(instrumental: InstrumentalData) {
        artwork.layer.cornerRadius = 4
        artwork.contentMode = .scaleAspectFill
        name.text = instrumental.instrumentalName
        artist.text = ""
        setupproducers(pros: instrumental.producers, completion: { [weak self] producer in
            guard let strongSelf = self else {return}
            switch producer.count {
            case 2:
                strongSelf.producers.text = "Produced by \(producer[0]) & \(producer[1])"
            case 3:
                strongSelf.producers.text = "Produced by \(producer[0]), \(producer[1]) & \(producer[2])"
            case 4:
                strongSelf.producers.text = "Produced by \(producer[0]), \(producer[1]), \(producer[2]) & \(producer[3])"
            case 5:
                strongSelf.producers.text = "Produced by \(producer[0]), \(producer[1]), \(producer[2]), \(producer[3]) & \(producer[4])"
            case 6:
                strongSelf.producers.text = "Produced by \(producer[0]), \(producer[1]), \(producer[2]), \(producer[3]), \(producer[4]) & \(producer[5])"
            default:
                strongSelf.producers.text = "Produced by \(producer[0])"
            }
        })
        let imageurl = "instrumental.imageURL"
        if let url = URL.init(string: imageurl) {
            if let cachedImage = imageCache.object(forKey: url.absoluteString as NSString) {
                artwork.image = cachedImage
            } else {
                artwork.setImage(from: url, withPlaceholder: UIImage(named: "tonedeaflogo"))
            }
        }
    }
    func funcSetTemp(artis: ArtistData) {
        artwork.layer.cornerRadius = 72.5
        artwork.contentMode = .scaleAspectFill
        name.text = artis.name
        artist.text = ""
        producers.text = ""
        var imageurl = ""
        if artis.spotifyProfileImageURL != "" {
            imageurl = artis.spotifyProfileImageURL
        }
        if let url = URL.init(string: imageurl) {
            if let cachedImage = imageCache.object(forKey: url.absoluteString as NSString) {
                artwork.image = cachedImage
            } else {
                
                artwork.setImage(from: url, withPlaceholder: UIImage(named: "tonedeaflogo"))
            }
        }
    }
    func funcSetTemp(producer: ProducerData) {
        artwork.layer.cornerRadius = 72.5
        artwork.contentMode = .scaleAspectFill
        name.text = producer.name
        artist.text = ""
        producers.text = ""
        var imageurl = ""
        if producer.spotifyProfileImageURL != "" {
            imageurl = producer.spotifyProfileImageURL
        }
        if let url = URL.init(string: imageurl) {
            if let cachedImage = imageCache.object(forKey: url.absoluteString as NSString) {
                artwork.image = cachedImage
            } else {
                artwork.setImage(from: url, withPlaceholder: UIImage(named: "tonedeaflogo"))
            }
        }
    }
    
    func setupartist(arts: [String], completion: @escaping (Array<String>) -> Void) {
        var artistNameData:Array<String> = []
        var val = 0
        for artist in arts {
            let word = artist.split(separator: "Æ")
            let id = word[1]
            val+=1
            artistNameData.append(String(id))
            if val == arts.count {
                
                completion(artistNameData)
            }
        }
    }
    
    func setupproducers(pros: [String], completion: @escaping (Array<String>) -> Void) {
        var producerNameData:Array<String> = []
        var val = 0
        for artist in pros {
            let word = artist.split(separator: "Æ")
            let id = word[1]
            val+=1
            producerNameData.append(String(id))
            if val == pros.count {
                completion(producerNameData)
            }
        }
    }

}

class AllOfFeaturedVideoCollectionViewCellController: UICollectionViewCell {
    
    @IBOutlet weak var videoThumbnail: UIImageView!
    @IBOutlet weak var videoTitle: UILabel!
    @IBOutlet weak var channelTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override var isHighlighted: Bool {
        didSet{
            tapScale(cell: self, down: isHighlighted)
        }
    }
    
    override func prepareForReuse() {
        videoThumbnail.image = nil
    }
    
    func funcSetTemp(video: AnyObject) {
        videoThumbnail.layer.cornerRadius = 4
        videoThumbnail.contentMode = .scaleAspectFill
        switch video {
        case is YouTubeData:
            let video = video as! YouTubeData
            if let imageURL = URL(string: video.thumbnailURL){
                videoThumbnail.setImage(from: imageURL)
            }
            videoTitle.text = video.title
            channelTitle.text = video.channelTitle
        default:
            fatalError("exhaust")
        }
    }
    
    func setupartist(song: SongData, completion: @escaping (Array<String>) -> Void) {
        var artistNameData:Array<String> = []
        var val = 0
        for artist in song.songArtist {
            let word = artist.split(separator: "Æ")
            let id = word[1]
            val+=1
            artistNameData.append(String(id))
            if val == song.songArtist.count {
                completion(artistNameData)
            }
        }
    }
}

class AllOfDiscoverTableView: UITableView {
    override var intrinsicContentSize: CGSize {
        layoutIfNeeded()
        return CGSize(width: UIView.noIntrinsicMetric, height: contentSize.height)
    }
}
