//
//  SongInfoViewController.swift
//  ToneDeafDeafinitionsApp
//
//  Created by Tone Deaf on 9/27/20.
//  Copyright © 2020 GITEM Solutions. All rights reserved.
//

import UIKit
import MarqueeLabel
import SkeletonView
import QuickLook
import CDAlertView
import FirebaseDatabase

class InfoDetailViewController: UIViewController {
    
    @IBOutlet weak var scrollView1: UIScrollView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var serviceTableView: UITableView!
    
    var lastContentOffset: CGFloat = 0
    var maxHeaderHeight: CGFloat = 0
    
    var content:Any!
    @IBOutlet weak var contentImage: UIImageView!
    @IBOutlet weak var contentName: MarqueeLabel!
    @IBOutlet weak var contentArtist: MarqueeLabel!
    @IBOutlet weak var contentRelease: MarqueeLabel!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var background: UIView!
    @IBOutlet weak var blurGradient: UIView!
    
    var favorited = false
    
    @IBOutlet weak var tableviewheight: NSLayoutConstraint!
    @IBOutlet weak var servicetableviewheight: NSLayoutConstraint!
    var backgroundImageView:UIImageView!
    
    var data:[[Any]]!
    var serviceArray:[String] = []
    
    var infoDetailContent:Any!
    var artistInfo:ArtistData!
    var producerInfo:ProducerData!
    
    var merchArray:[MerchData] = []
    var videosArray:[Any] = []
    var songsArray:[SongData] = []
    var albumsArray:[AlbumData] = []
    var instrumentalsArray:[InstrumentalData] = []
    var artistsArray:[PersonData] = []
    var producersArray:[PersonData] = []
    var writersArray:[PersonData] = []
    var mixEngineersArray:[PersonData] = []
    var masteringEngineersArray:[PersonData] = []
    var recordingEngineersArray:[PersonData] = []
    var skelvar = 0
    var visualEffectView:UIVisualEffectView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        let nib = UINib(nibName: "Header", bundle: nil)
        tableView.register(nib, forHeaderFooterViewReuseIdentifier: "TableSectionHeader")
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "dots copy"), style: .plain, target: self, action: #selector(moreButtonTapped))
        skelvar = 0
        setBack()
        scrollView1.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        serviceTableView.delegate = self
        serviceTableView.dataSource = self
        let queue = DispatchQueue(label: "myakjdsfhjhgfdxzvczjvb,hds ZKfhcuewsQueue")
        let group = DispatchGroup()
        let array = [0,1, 2, 3,4,5,6,7,8,10]

        for i in array {
            group.enter()
            queue.async { [weak self] in
                guard let strongSelf = self else {return}
                switch i {
                case 0:
                    strongSelf.setUpHeader(completion: {
                        print("done \(i)")
                        group.leave()
                    })
                case 1:
                    strongSelf.setUpServiceArray(completion: {
                        strongSelf.hideskeleton2(tableview: strongSelf.serviceTableView)
                        print("done \(i)")
                        group.leave()
                    })
                case 2:
                    strongSelf.setUpProducers(completion: {
                        print("done \(i)")
                        group.leave()
                    })
                case 3:
                    strongSelf.setUpArtists(completion: {
                        print("done \(i)")
                        group.leave()
                    })
                case 4:
                    strongSelf.setUpWriters(completion: {
                        print("done \(i)")
                        group.leave()
                    })
                case 5:
                    strongSelf.setUpMixEngineers(completion: {
                        print("done \(i)")
                        group.leave()
                    })
                case 6:
                    strongSelf.setUpMasteringEngineers(completion: {
                        print("done \(i)")
                        group.leave()
                    })
                case 7:
                    strongSelf.setUpRecordingEngineers(completion: {
                        print("done \(i)")
                        group.leave()
                    })
                case 8:
                    if !(strongSelf.content is VideoData) {
                        strongSelf.setUpVideos(completion: {
                            print("done \(i)")
                            group.leave()
                        })
                    } else {
                        print("done \(i)")
                        group.leave()
                    }
                case 9:
                    if !(strongSelf.content is InstrumentalData) {
                        strongSelf.setUpInstrumentals(completion: {
                            print("done \(i)")
                            group.leave()
                        })
                    } else {
                        print("done \(i)")
                        group.leave()
                    }
                case 10:
                    if !(strongSelf.content is AlbumData) {
                        strongSelf.setUpAlbums(completion: {
                            print("done \(i)")
                            group.leave()
                        })
                    } else {
                        print("done \(i)")
                        group.leave()
                    }
                case 11:
                    if !(strongSelf.content is SongData) {
                        strongSelf.setUpSongs(completion: {
                            print("done \(i)")
                            group.leave()
                        })
                    } else {
                        print("done \(i)")
                        group.leave()
                    }
                case 12:
                    if !(strongSelf.content is MerchData) {
                        strongSelf.setUpMerch(completion: {
                            print("done \(i)")
                            group.leave()
                        })
                    } else {
                        print("done \(i)")
                        group.leave()
                    }
                default:
                    print("err")
                }
            }
        }

        group.notify(queue: DispatchQueue.main) { [weak self] in
            guard let strongSelf = self else {return}
            print("done!")
            strongSelf.data = [strongSelf.artistsArray,strongSelf.producersArray,strongSelf.writersArray,strongSelf.mixEngineersArray,strongSelf.masteringEngineersArray,strongSelf.recordingEngineersArray,strongSelf.merchArray,strongSelf.songsArray,strongSelf.videosArray,strongSelf.albumsArray,strongSelf.instrumentalsArray]
            strongSelf.hideskeleton(tableview: strongSelf.tableView)
        }
    }

    override func viewWillAppear(_ animated: Bool) {
            self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
          self.navigationController?.navigationBar.shadowImage = UIImage()
          self.navigationController?.navigationBar.isTranslucent = true
        if scrollView1.contentOffset.y <= 0 {
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
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
          self.navigationController?.navigationBar.shadowImage = UIImage()
          self.navigationController?.navigationBar.isTranslucent = true
        if skelvar == 0 {
            tableView.isSkeletonable = true
            tableView.showAnimatedGradientSkeleton(usingGradient: .init(baseColor: UIColor.init(red: 22/255, green: 22/255, blue: 22/255, alpha: 1)), animation: nil, transition: .crossDissolve(0.25))
            serviceTableView.isSkeletonable = true
            serviceTableView.showAnimatedGradientSkeleton(usingGradient: .init(baseColor: UIColor.init(red: 22/255, green: 22/255, blue: 22/255, alpha: 1)), animation: nil, transition: .crossDissolve(0.25))
        }
        skelvar+=1
    }

    func hideskeleton(tableview: UITableView) {
        skelvar+=1
        DispatchQueue.main.async { [weak self] in
            guard let strongSelf = self else {return}
            print("Hiding skeleton")
            tableview.stopSkeletonAnimation()
            tableview.hideSkeleton(reloadDataAfter: true, transition: .crossDissolve(0.25))
            tableview.reloadData()
            strongSelf.tableviewheight.constant = strongSelf.tableView.contentSize.height
            strongSelf.view.layoutSubviews()
        }
    }

    func hideskeleton2(tableview: UITableView) {
        skelvar+=1
        DispatchQueue.main.async { [weak self] in
            guard let strongSelf = self else {return}
            print("Hiding skeleton")
            tableview.stopSkeletonAnimation()
            tableview.hideSkeleton(reloadDataAfter: true, transition: .crossDissolve(0.25))
            tableview.reloadData()
            strongSelf.servicetableviewheight.constant = strongSelf.serviceTableView.contentSize.height
            strongSelf.view.layoutSubviews()
        }
    }

    deinit {
        if visualEffectView != nil {
            visualEffectView.removeFromSuperview()
            visualEffectView = nil
        }
        print("📗 Info page being deallocated from memory. OS reclaiming")
        NotificationCenter.default.removeObserver(self)
    }

    func setBack() {
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
          self.navigationController?.navigationBar.shadowImage = UIImage()
          self.navigationController?.navigationBar.isTranslucent = true
        contentImage.layer.cornerRadius = 7
        blurGradient.backgroundColor = .clear
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

        playButton.layer.cornerRadius = 7
        shareButton.layer.cornerRadius = 7
        favoriteButton.layer.cornerRadius = 7
    }

    func setUpHeader(completion: @escaping (() -> Void)) {
        switch content {
        case is SongData:
            let song = content as! SongData
            var songart:[String] = []
            for art in song.songArtist {
                DatabaseManager.shared.fetchPersonData(person: art, completion: {[weak self] result in
                    guard let strongSelf = self else {return}
                    switch result {
                    case .success(let selectedProducer):
                        songart.append(selectedProducer.name)
                        strongSelf.contentArtist.text = songart.joined(separator: ", ")
                    case .failure(let err):
                        print("youyoudsafaerr", err)
                    }
                })
            }
            for favorite in currentAppUser.favorites {
                if favorite.dbid.contains(song.toneDeafAppId) {
                    favorited = true
                    favoriteButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
                    favoriteButton.tintColor = Constants.Colors.redApp
                }
            }
            GlobalFunctions.shared.selectImageURL(song: song, completion: {[weak self] ur in
                guard let strongSelf = self else {return}
                let imageurl = ur!
                if let url = URL.init(string: imageurl) {
                    strongSelf.blurredBackground(url: url, videoCellView: strongSelf.background)
                    if let cachedImage = imageCache.object(forKey: url.absoluteString as NSString) {
                        DispatchQueue.main.async { [weak self] in
                            guard let strongSelf = self else {return}
                            strongSelf.contentImage.image = cachedImage
                        }
                    } else {
                        strongSelf.contentImage.setImage(from: url, withPlaceholder: UIImage(named: "tonedeaflogo"))
                    }
                }
                Comparisons.shared.getEarliestReleaseDate(song: song, completion: { date in
                    DispatchQueue.main.async { [weak self] in
                        guard let strongSelf = self else {return}
                        strongSelf.contentName.text = song.name
                        strongSelf.contentRelease.text = date
                    }
                    completion()
                })
            })
        case is VideoData:
            let video = content as! VideoData
            var songart:[String] = []
            if let arrr = video.videographers {
                for art in arrr {
                    DatabaseManager.shared.fetchPersonData(person: art, completion: {[weak self] result in
                        guard let strongSelf = self else {return}
                        switch result {
                        case .success(let selectedProducer):
                            songart.append(selectedProducer.name)
                            strongSelf.contentArtist.text = songart.joined(separator: ", ")
                        case .failure(let err):
                            print("youyoudsafaerr", err)
                        }
                    })
                }
            }
            if let arrr = video.persons {
                for art in arrr {
                    DatabaseManager.shared.fetchPersonData(person: art, completion: {[weak self] result in
                        guard let strongSelf = self else {return}
                        switch result {
                        case .success(let selectedProducer):
                            songart.append(selectedProducer.name)
                            strongSelf.contentArtist.text = songart.joined(separator: ", ")
                        case .failure(let err):
                            print("youyoudsafaerr", err)
                        }
                    })
                }
            }
            for favorite in currentAppUser.favorites {
                if favorite.dbid.contains(video.toneDeafAppId) {
                    favorited = true
                    favoriteButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
                    favoriteButton.tintColor = Constants.Colors.redApp
                }
            }
            GlobalFunctions.shared.selectImageURL(video: video, completion: {[weak self] ur in
                guard let strongSelf = self else {return}
                let imageurl = ur!
                if let url = URL.init(string: imageurl) {
                    strongSelf.blurredBackground(url: url, videoCellView: strongSelf.background)
                    if let cachedImage = imageCache.object(forKey: url.absoluteString as NSString) {
                        DispatchQueue.main.async { [weak self] in
                            guard let strongSelf = self else {return}
                            strongSelf.contentImage.image = cachedImage
                        }
                    } else {
                        strongSelf.contentImage.setImage(from: url, withPlaceholder: UIImage(named: "tonedeaflogo"))
                    }
                }
                Comparisons.shared.getEarliestReleaseDate(video: video, completion: { date in
                    DispatchQueue.main.async { [weak self] in
                        guard let strongSelf = self else {return}
                        strongSelf.contentName.text = video.title
                        strongSelf.contentRelease.text = date
                    }
                    completion()
                })
            })
        case is AlbumData:
            let album = content as! AlbumData
            var songart:[String] = []
            for art in album.mainArtist {
                DatabaseManager.shared.fetchPersonData(person: art, completion: {[weak self] result in
                    guard let strongSelf = self else {return}
                    switch result {
                    case .success(let selectedProducer):
                        songart.append(selectedProducer.name)
                        strongSelf.contentArtist.text = songart.joined(separator: ", ")
                    case .failure(let err):
                        print("youyoudsafaerr", err)
                    }
                })
            }
            for favorite in currentAppUser.favorites {
                if favorite.dbid.contains(album.toneDeafAppId) {
                    favorited = true
                    favoriteButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
                    favoriteButton.tintColor = Constants.Colors.redApp
                }
            }
            GlobalFunctions.shared.selectImageURL(album: album, completion: {[weak self] ur in
                guard let strongSelf = self else {return}
                let imageurl = ur!
                if let url = URL.init(string: imageurl) {
                    strongSelf.blurredBackground(url: url, videoCellView: strongSelf.background)
                    if let cachedImage = imageCache.object(forKey: url.absoluteString as NSString) {
                        DispatchQueue.main.async { [weak self] in
                            guard let strongSelf = self else {return}
                            strongSelf.contentImage.image = cachedImage
                        }
                    } else {
                        strongSelf.contentImage.setImage(from: url, withPlaceholder: UIImage(named: "tonedeaflogo"))
                    }
                }
                Comparisons.shared.getEarliestReleaseDate(album: album, completion: { date in
                    DispatchQueue.main.async { [weak self] in
                        guard let strongSelf = self else {return}
                        strongSelf.contentName.text = album.name
                        strongSelf.contentRelease.text = date
                    }
                    completion()
                })
            })
        default:
            let instrumental = content as! InstrumentalData
//            let imageurl = instrumental.imageURL
//            var songart:[String] = []
////            for art in instrumental.songArtist {
////                let word = art.split(separator: "Æ")
////                let id = word[1]
////                songart.append(String(id))
////            }
//            for favorite in currentAppUser.favorites {
//                if favorite.dbid.contains(instrumental.toneDeafAppId) {
//                    favorited = true
//                    favoriteButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
//                    favoriteButton.tintColor = Constants.Colors.redApp
//                }
//            }
//            if let url = URL.init(string: imageurl) {
//                blurredBackground(url: url, videoCellView: background)
//                if let cachedImage = imageCache.object(forKey: url.absoluteString as NSString) {
//                    DispatchQueue.main.async { [weak self] in
//                        guard let strongSelf = self else {return}
//                        strongSelf.contentImage.image = cachedImage
//                    }
//                } else {
//                    contentImage.setImage(from: url, withPlaceholder: UIImage(named: "tonedeaflogo"))
//                }
//            }
//            Comparisons.shared.getEarliestReleaseDate(instrumental: instrumental, completion: { date in
//                DispatchQueue.main.async { [weak self] in
//                    guard let strongSelf = self else {return}
//                    strongSelf.contentName.text = instrumental.instrumentalName
//                    strongSelf.contentArtist.text = songart.joined(separator: ", ")
//                    strongSelf.contentRelease.text = date
//                }
//                completion()
//            })
        }


    }

    func setUpServiceArray(completion: @escaping (() -> Void)) {
        serviceArray = []
        switch content {
        case is VideoData:
            serviceArray.append("youtube")
            completion()
        case is InstrumentalData:
            let instrumental = content as! InstrumentalData
            if instrumental.apple != nil {
                serviceArray.append("apple")
            }
            if instrumental.spotify != nil {
                serviceArray.append("spotify")
            }
            if instrumental.soundcloud?.url != nil {
                serviceArray.append("soundcloud")
            }
            if instrumental.youtubeMusic?.url != nil {
                serviceArray.append("youtubemusic")
            }
            if instrumental.amazon?.url != nil {
                serviceArray.append("amazon")
            }
            if instrumental.deezer?.url != nil {
                serviceArray.append("deezer")
            }
            if instrumental.spinrilla?.url != nil {
                serviceArray.append("spinrilla")
            }
            if instrumental.napster?.url != nil {
                serviceArray.append("napster")
            }
            if instrumental.tidal?.url != nil {
                serviceArray.append("tidal")
            }
            if instrumental.officialVideo != nil {
                serviceArray.append("ytim")
            }
            completion()
        case is AlbumData:
            let album = content as! AlbumData
            if album.apple?.url != "" {
                serviceArray.append("apple")
            }
            if album.spotify?.url != "" {
                serviceArray.append("spotify")
            }
            if album.soundcloud?.url != nil {
                serviceArray.append("soundcloud")
            }
            if album.youtubeMusic?.url != nil {
                serviceArray.append("youtubemusic")
            }
            if album.amazon?.url != nil {
                serviceArray.append("amazon")
            }
            if album.deezer?.url != nil {
                serviceArray.append("deezer")
            }
            if album.spinrilla?.url != nil {
                serviceArray.append("spinrilla")
            }
            if album.napster?.url != nil {
                serviceArray.append("napster")
            }
            if album.tidal?.url != nil {
                serviceArray.append("tidal")
            }
            if album.officialAlbumVideo != nil {
                serviceArray.append("ytad")
            }
            completion()
        default:
            let song = content as! SongData
            if song.apple?.appleSongURL != "" {
                serviceArray.append("apple")
            }
            if song.spotify?.spotifySongURL != "" {
                serviceArray.append("spotify")
            }
            if song.soundcloud?.url != nil {
                serviceArray.append("soundcloud")
            }
            if song.youtubeMusic?.url != nil {
                serviceArray.append("youtubemusic")
            }
            if song.amazon?.url != nil {
                serviceArray.append("amazon")
            }
            if song.deezer?.url != nil {
                serviceArray.append("deezer")
            }
            if song.spinrilla?.url != nil {
                serviceArray.append("spinrilla")
            }
            if song.napster?.url != nil {
                serviceArray.append("napster")
            }
            if song.tidal?.url != nil {
                serviceArray.append("tidal")
            }
            if song.audioVideo != nil {
                serviceArray.append("ytad")
            }
            completion()
        }
    }

    func blurredBackground(url: URL, videoCellView: UIView) {
        DispatchQueue.main.async { [weak self] in
            guard let strongSelf = self else {return}
            strongSelf.backgroundImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: videoCellView.bounds.width, height: videoCellView.bounds.height))
            videoCellView.addSubview(strongSelf.backgroundImageView)
            if let cachedImage = imageCache.object(forKey: url.absoluteString as NSString) {
                strongSelf.backgroundImageView.image = cachedImage
            } else {
                strongSelf.backgroundImageView.setImage(from: url, withPlaceholder: UIImage(named: "tonedeaflogo"))
            }
            strongSelf.backgroundImageView.roundCorners(corners: [.topLeft,.topRight], radius: 10)
            videoCellView.roundCorners(corners: [.topLeft,.topRight], radius: 10)
            videoCellView.addSubview(strongSelf.backgroundImageView)
            videoCellView.sendSubviewToBack(strongSelf.backgroundImageView)
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

    func setUpProducers(completion: @escaping (() -> Void)) {
        var tick = 0
        switch content {
        case is VideoData:
            let video = content as! VideoData
            if video.persons != nil {
                for pro in video.persons! {
                    DatabaseManager.shared.fetchPersonData(person: pro, completion: {[weak self] result in
                        guard let strongSelf = self else {return}
                        switch result {
                        case .success(let person):
                            strongSelf.producersArray.append(person)
                            tick+=1
                            if tick == video.persons!.count {
                                completion()
                            }
                        case .failure(let err):
                            print("youyouerr", err)
                        }
                    })
                }
            }
        case is InstrumentalData:
            let instrumental = content as! InstrumentalData
            for pro in instrumental.producers {
                DatabaseManager.shared.fetchPersonData(person: pro, completion: {[weak self] result in
                    guard let strongSelf = self else {return}
                    switch result {
                    case .success(let person):
                        strongSelf.producersArray.append(person)
                        tick+=1
                        if tick == instrumental.producers.count {
                            completion()
                        }
                    case .failure(let err):
                        print("youyouerr", err)
                    }
                })
            }
        case is AlbumData:
            let album = content as! AlbumData
            for pro in album.producers {
                DatabaseManager.shared.fetchPersonData(person: pro, completion: {[weak self] result in
                    guard let strongSelf = self else {return}
                    switch result {
                    case .success(let person):
                        strongSelf.producersArray.append(person)
                        tick+=1
                        if tick == album.producers.count {
                            completion()
                        }
                    case .failure(let err):
                        print("youyouerr", err)
                    }
                })
            }
        default:
            let song = content as! SongData
            for pro in song.songProducers {
                DatabaseManager.shared.fetchPersonData(person: pro, completion: {[weak self] result in
                    guard let strongSelf = self else {return}
                    switch result {
                    case .success(let person):
                        strongSelf.producersArray.append(person)
                        tick+=1
                        if tick == song.songProducers.count {
                            completion()
                        }
                    case .failure(let err):
                        print("youyouerr", err)
                    }
                })
            }
        }
    }

    func setUpArtists(completion: @escaping (() -> Void)) {
        var tick = 0
        switch content {
        case is VideoData:
            let video = content as! VideoData
            if video.videographers != nil {
                for pro in video.videographers! {
                    DatabaseManager.shared.fetchPersonData(person: pro, completion: {[weak self] result in
                        guard let strongSelf = self else {return}
                        switch result {
                        case .success(let person):
                            strongSelf.artistsArray.append(person)
                            tick+=1
                            if tick == video.videographers!.count {
                                completion()
                            }
                        case .failure(let err):
                            print("youyouerr", err)
                        }
                    })
                }

            } else {
                completion()
            }
        case is InstrumentalData:
            let instrumental = content as! InstrumentalData
            if instrumental.artist != nil {
                for pro in instrumental.artist! {
                    DatabaseManager.shared.fetchPersonData(person: pro, completion: {[weak self] result in
                        guard let strongSelf = self else {return}
                        switch result {
                        case .success(let person):
                            strongSelf.artistsArray.append(person)
                            tick+=1
                            if tick == instrumental.artist!.count {
                                completion()
                            }
                        case .failure(let err):
                            print("youyouerr", err)
                        }
                    })
                }

            } else {
                completion()
            }
        case is AlbumData:
            let album = content as! AlbumData
            if album.allArtists != nil {
                for pro in album.allArtists! {
                    DatabaseManager.shared.fetchPersonData(person: pro, completion: {[weak self] result in
                        guard let strongSelf = self else {return}
                        switch result {
                        case .success(let person):
                            strongSelf.artistsArray.append(person)
                            tick+=1
                            if tick == album.allArtists!.count {
                                completion()
                            }
                        case .failure(let err):
                            print("youyouerr", err)
                        }
                    })
                }
            } else {
                completion()
            }
        default:
            let song = content as! SongData
            if song.songArtist != [""] {
                for pro in song.songArtist {
                    DatabaseManager.shared.fetchPersonData(person: pro, completion: {[weak self] result in
                        guard let strongSelf = self else {return}
                        switch result {
                        case .success(let person):
                            strongSelf.artistsArray.append(person)
                            tick+=1
                            if tick == song.songArtist.count {
                                completion()
                            }
                        case .failure(let err):
                            print("youyouerr", err)
                        }
                    })
                }

            } else {
                completion()
            }
        }
    }
    
    func setUpWriters(completion: @escaping (() -> Void)) {
        var tick = 0
        switch content {
        case is AlbumData:
            let album = content as! AlbumData
            if album.writers == nil {
                completion()
                return
            }
            for pro in album.writers! {
                DatabaseManager.shared.fetchPersonData(person: pro, completion: {[weak self] result in
                    guard let strongSelf = self else {return}
                    switch result {
                    case .success(let person):
                        strongSelf.writersArray.append(person)
                        tick+=1
                        if tick == album.writers!.count {
                            completion()
                        }
                    case .failure(let err):
                        print("youyouerr", err)
                    }
                })
            }
        case is SongData:
            let song = content as! SongData
            if song.songWriters == nil {
                completion()
                return
            }
            for pro in song.songWriters! {
                DatabaseManager.shared.fetchPersonData(person: pro, completion: {[weak self] result in
                    guard let strongSelf = self else {return}
                    switch result {
                    case .success(let person):
                        strongSelf.writersArray.append(person)
                        tick+=1
                        if tick == song.songWriters!.count {
                            completion()
                        }
                    case .failure(let err):
                        print("youyouerr", err)
                    }
                })
            }
        default:
            completion()
            return
        }
    }
    
    func setUpMixEngineers(completion: @escaping (() -> Void)) {
        var tick = 0
        switch content {
        case is AlbumData:
            let album = content as! AlbumData
            if album.mixEngineers == nil {
                completion()
                return
            }
            for pro in album.mixEngineers! {
                DatabaseManager.shared.fetchPersonData(person: pro, completion: {[weak self] result in
                    guard let strongSelf = self else {return}
                    switch result {
                    case .success(let person):
                        strongSelf.mixEngineersArray.append(person)
                        tick+=1
                        if tick == album.mixEngineers!.count {
                            completion()
                        }
                    case .failure(let err):
                        print("youyouerr", err)
                    }
                })
            }
        case is InstrumentalData:
            let album = content as! InstrumentalData
            if album.mixEngineer == nil {
                completion()
                return
            }
            for pro in album.mixEngineer! {
                DatabaseManager.shared.fetchPersonData(person: pro, completion: {[weak self] result in
                    guard let strongSelf = self else {return}
                    switch result {
                    case .success(let person):
                        strongSelf.mixEngineersArray.append(person)
                        tick+=1
                        if tick == album.mixEngineer!.count {
                            completion()
                        }
                    case .failure(let err):
                        print("youyouerr", err)
                    }
                })
            }
        case is SongData:
            let song = content as! SongData
            if song.songMixEngineer == nil {
                completion()
                return
            }
            for pro in song.songMixEngineer! {
                DatabaseManager.shared.fetchPersonData(person: pro, completion: {[weak self] result in
                    guard let strongSelf = self else {return}
                    switch result {
                    case .success(let person):
                        strongSelf.mixEngineersArray.append(person)
                        tick+=1
                        if tick == song.songMixEngineer!.count {
                            completion()
                        }
                    case .failure(let err):
                        print("youyouerr", err)
                    }
                })
            }
        default:
            completion()
            return
        }
    }
    
    func setUpMasteringEngineers(completion: @escaping (() -> Void)) {
        var tick = 0
        switch content {
        case is AlbumData:
            let album = content as! AlbumData
            if album.masteringEngineers == nil {
                completion()
                return
            }
            for pro in album.masteringEngineers! {
                DatabaseManager.shared.fetchPersonData(person: pro, completion: {[weak self] result in
                    guard let strongSelf = self else {return}
                    switch result {
                    case .success(let person):
                        strongSelf.masteringEngineersArray.append(person)
                        tick+=1
                        if tick == album.masteringEngineers!.count {
                            completion()
                        }
                    case .failure(let err):
                        print("youyouerr", err)
                    }
                })
            }
        case is InstrumentalData:
            let album = content as! InstrumentalData
            if album.masteringEngineer == nil {
                completion()
                return
            }
            for pro in album.masteringEngineer! {
                DatabaseManager.shared.fetchPersonData(person: pro, completion: {[weak self] result in
                    guard let strongSelf = self else {return}
                    switch result {
                    case .success(let person):
                        strongSelf.masteringEngineersArray.append(person)
                        tick+=1
                        if tick == album.masteringEngineer!.count {
                            completion()
                        }
                    case .failure(let err):
                        print("youyouerr", err)
                    }
                })
            }
        case is SongData:
            let song = content as! SongData
            if song.songMasteringEngineer == nil {
                completion()
                return
            }
            for pro in song.songMasteringEngineer! {
                DatabaseManager.shared.fetchPersonData(person: pro, completion: {[weak self] result in
                    guard let strongSelf = self else {return}
                    switch result {
                    case .success(let person):
                        strongSelf.masteringEngineersArray.append(person)
                        tick+=1
                        if tick == song.songMasteringEngineer!.count {
                            completion()
                        }
                    case .failure(let err):
                        print("youyouerr", err)
                    }
                })
            }
        default:
            completion()
            return
        }
    }
    
    func setUpRecordingEngineers(completion: @escaping (() -> Void)) {
        var tick = 0
        switch content {
        case is AlbumData:
            let album = content as! AlbumData
            if album.recordingEngineers == nil {
                completion()
                return
            }
            for pro in album.recordingEngineers! {
                DatabaseManager.shared.fetchPersonData(person: pro, completion: {[weak self] result in
                    guard let strongSelf = self else {return}
                    switch result {
                    case .success(let person):
                        strongSelf.recordingEngineersArray.append(person)
                        tick+=1
                        if tick == album.recordingEngineers!.count {
                            completion()
                        }
                    case .failure(let err):
                        print("youyouerr", err)
                    }
                })
            }
        case is SongData:
            let song = content as! SongData
            if song.songRecordingEngineer == nil {
                completion()
                return
            }
            for pro in song.songRecordingEngineer! {
                DatabaseManager.shared.fetchPersonData(person: pro, completion: {[weak self] result in
                    guard let strongSelf = self else {return}
                    switch result {
                    case .success(let person):
                        strongSelf.recordingEngineersArray.append(person)
                        tick+=1
                        if tick == song.songRecordingEngineer!.count {
                            completion()
                        }
                    case .failure(let err):
                        print("youyouerr", err)
                    }
                })
            }
        default:
            completion()
            return
        }
    }

    func setUpVideos(completion: @escaping (() -> Void)) {
        var tick = 0
        switch content {
        case is InstrumentalData:
            let instrumental = content as! InstrumentalData
            if instrumental.videos != nil, !instrumental.videos!.isEmpty {
                for pro in instrumental.videos! {
                    DatabaseManager.shared.findVideoById(videoid: pro, completion: {[weak self] result in
                        guard let strongSelf = self else {return}
                        switch result {
                        case .success(let video):
                            strongSelf.videosArray.append(video)
                            tick+=1
                            if tick == instrumental.videos!.count {
                                completion()
                            }
                        case .failure(let error):
                            print("videoo hg\(error)")
                        }
                    })
                }

            } else {
                completion()
            }
        case is AlbumData:
            let album = content as! AlbumData
            if album.videos != nil, !album.videos!.isEmpty {
                for pro in album.videos! {
                    DatabaseManager.shared.findVideoById(videoid: pro, completion: {[weak self] result in
                        guard let strongSelf = self else {return}
                        switch result {
                        case .success(let video):
                            strongSelf.videosArray.append(video)
                            tick+=1
                            if tick == album.videos!.count {
                                completion()
                            }
                        case .failure(let error):
                            print("videoo hg\(error)")
                        }
                    })
                }

            } else {
                completion()
            }
        default:
            let song = content as! SongData
            if song.videos != nil, !song.videos!.isEmpty {
                for pro in song.videos! {
                    DatabaseManager.shared.findVideoById(videoid: pro, completion: {[weak self] result in
                        guard let strongSelf = self else {return}
                        switch result {
                        case .success(let video):
                            strongSelf.videosArray.append(video)
                            tick+=1
                            if tick == song.videos!.count {
                                completion()
                            }
                        case .failure(let error):
                            print("videoo hg\(error)")
                        }
                    })
                }

            } else {
                completion()
            }
        }
    }

    func setUpInstrumentals(completion: @escaping (() -> Void)) {
        var tick = 0
        switch content {
        case is VideoData:
            let video = content as! VideoData
            if video.instrumentals != nil {
                for pro in video.instrumentals! {
                    let word = pro.split(separator: "Æ")
                    let id = word[0]
                    DatabaseManager.shared.findInstrumentalById(instrumentalId: String(id), completion: {[weak self] result in
                        guard let strongSelf = self else {return}
                        switch result {
                        case .success(let instrumental):
                            strongSelf.instrumentalsArray.append(instrumental)
                            tick+=1
                            if tick == video.instrumentals!.count {
                                completion()
                            }
                        case .failure(let error):
                            print("videoo hg\(error)")
                        }
                    })
                }

            } else {
                completion()
            }
        case is AlbumData:
            let album = content as! AlbumData
            if album.instrumentals != [""] {
//                for pro in album.instrumentals {
//                    let word = pro.split(separator: "Æ")
//                    let id = word[0]
//                    DatabaseManager.shared.findInstrumentalById(instrumentalId: String(id), completion: {[weak self] result in
//                        guard let strongSelf = self else {return}
//                        switch result {
//                        case .success(let instrumental):
//                            strongSelf.instrumentalsArray.append(instrumental)
//                            tick+=1
//                            if tick == album.instrumentals.count {
//                                completion()
//                            }
//                        case .failure(let error):
//                            print("videoo hg\(error)")
//                        }
//                    })
//                }

            } else {
                completion()
            }
        default:
            let song = content as! SongData
            if song.instrumentals != [""] {
                for pro in song.instrumentals! {
                    let word = pro.split(separator: "Æ")
                    let id = word[0]
                    DatabaseManager.shared.findInstrumentalById(instrumentalId: String(id), completion: {[weak self] result in
                        guard let strongSelf = self else {return}
                        switch result {
                        case .success(let instrumental):
                            strongSelf.instrumentalsArray.append(instrumental)
                            tick+=1
                            if tick == song.instrumentals!.count {
                                completion()
                            }
                        case .failure(let error):
                            print("videoo hg\(error)")
                        }
                    })
                }

            } else {
                completion()
            }
        }
    }

    func setUpAlbums(completion: @escaping (() -> Void)) {
        var tick = 0
        switch content {
        case is VideoData:
            let video = content as! VideoData
            if video.albums != nil, !video.albums!.isEmpty {
                for pro in video.albums! {
                    DatabaseManager.shared.findAlbumById(albumId: pro, completion: {[weak self] result in
                        guard let strongSelf = self else {return}
                        switch result {
                        case .success(let album):
                            strongSelf.albumsArray.append(album)
                            tick+=1
                            if tick == video.albums!.count {
                                completion()
                            }
                        case .failure(let error):
                            print("videoo hg\(error)")
                        }
                    })
                }

            } else {
                completion()
            }
        case is InstrumentalData:
            let instrumental = content as! InstrumentalData
            if instrumental.albums != nil, !instrumental.albums!.isEmpty {
                for pro in instrumental.albums! {
                    DatabaseManager.shared.findAlbumById(albumId: pro, completion: {[weak self] result in
                        guard let strongSelf = self else {return}
                        switch result {
                        case .success(let album):
                            strongSelf.albumsArray.append(album)
                            tick+=1
                            if tick == instrumental.albums!.count {
                                completion()
                            }
                        case .failure(let error):
                            print("videoo hg\(error)")
                        }
                    })
                }

            } else {
                completion()
            }
        default:
            let song = content as! SongData
            if song.albums != nil, !song.albums!.isEmpty {
                for pro in song.albums! {
                    DatabaseManager.shared.findAlbumById(albumId: pro, completion: {[weak self] result in
                        guard let strongSelf = self else {return}
                        switch result {
                        case .success(let album):
                            strongSelf.albumsArray.append(album)
                            tick+=1
                            if tick == song.albums!.count {
                                completion()
                            }
                        case .failure(let error):
                            print("videoo hg\(error)")
                        }
                    })
                }

            } else {
                completion()
            }
        }
    }

    func setUpSongs(completion: @escaping (() -> Void)) {
        var tick = 0
//        switch content {
//        case is VideoData:
//            let video = content as! VideoData
//            if video.songs != [""] {
//                for pro in video.songs! {
//                    let word = pro.split(separator: "Æ")
//                    let id = word[0]
//                    DatabaseManager.shared.findSongById(songId: String(id), completion: {[weak self] result in
//                        guard let strongSelf = self else {return}
//                        switch result {
//                        case .success(let song):
//                            strongSelf.songsArray.append(song)
//                            tick+=1
//                            if tick == video.songs!.count {
//                                completion()
//                            }
//                        case .failure(let error):
//                            print("videoo hg\(error)")
//                        }
//                    })
//                }
//
//            } else {
//                completion()
//            }
//        case is InstrumentalData:
//            let instrumental = content as! InstrumentalData
//            if instrumental.songs != [""] {
//                for pro in instrumental.songs {
//                    let word = pro.split(separator: "Æ")
//                    let id = word[0]
//                    DatabaseManager.shared.findSongById(songId: String(id), completion: {[weak self] result in
//                        guard let strongSelf = self else {return}
//                        switch result {
//                        case .success(let song):
//                            strongSelf.songsArray.append(song)
//                            tick+=1
//                            if tick == instrumental.songs.count {
//                                completion()
//                            }
//                        case .failure(let error):
//                            print("videoo hg\(error)")
//                        }
//                    })
//                }
//
//            } else {
//                completion()
//            }
//        default:
//            let album = content as! AlbumData
////                for (_,pro) in album.songs {
////                    let word = pro.split(separator: "Æ")
////                    let id = word[0]
////                    DatabaseManager.shared.findSongById(songId: String(id), completion: {[weak self] result in
////                        guard let strongSelf = self else {return}
////                        switch result {
////                        case .success(let song):
////                            strongSelf.songsArray.append(song)
////                            tick+=1
////                            if tick == album.songs.count {
////                                completion()
////                            }
////                        case .failure(let error):
////                            print("videoo hg\(error)")
////                        }
////                    })
////                }
//        }
    }

    func setUpMerch(completion: @escaping (() -> Void)) {
        var tick = 0
        switch content {
        case is VideoData:
            let video = content as! VideoData
            if let merch = video.merch {
                for pro in merch {
                    let word = pro.split(separator: "Æ")
                    let id = word[0]
                    DatabaseManager.shared.findMerchById(merchId: String(id), completion: {[weak self] result in
                        guard let strongSelf = self else {return}
                        switch result {
                        case .success(let mer):
                            strongSelf.merchArray.append(mer)
                            tick+=1
                            if tick == merch.count {
                                completion()
                            }
                        case .failure(let error):
                            print("videoo hg\(error)")
                        }
                    })
                }

            } else {
                completion()
            }
        case is InstrumentalData:
            let instrumental = content as! InstrumentalData
            if let _ = instrumental.storeInfo {
                let id = instrumental.toneDeafAppId
                    DatabaseManager.shared.findMerchById(merchId: id, completion: {[weak self] result in
                        guard let strongSelf = self else {return}
                        switch result {
                        case .success(let mer):
                            strongSelf.merchArray.append(mer)
                            if let inst = instrumental.merch {
                                if tick == inst.count {
                                    completion()
                                }
                            }
                        case .failure(let error):
                            print("instrumental hg\(error)")
                        }
                    })

            }
            if let merch = instrumental.merch {
                for pro in merch {
                    let word = pro.split(separator: "Æ")
                    let id = word[0]
                    DatabaseManager.shared.findMerchById(merchId: String(id), completion: {[weak self] result in
                        guard let strongSelf = self else {return}
                        switch result {
                        case .success(let mer):
                            strongSelf.merchArray.append(mer)
                            tick+=1
                            if tick == merch.count {
                                completion()
                            }
                        case .failure(let error):
                            print("instrumental hg\(error)")
                        }
                    })
                }

            } else {
                completion()
            }
        case is AlbumData:
            let album = content as! AlbumData
            if let merch = album.merch {
                for pro in merch {
                    let word = pro.split(separator: "Æ")
                    let id = word[0]
                    DatabaseManager.shared.findMerchById(merchId: String(id), completion: {[weak self] result in
                        guard let strongSelf = self else {return}
                        switch result {
                        case .success(let mer):
                            strongSelf.merchArray.append(mer)
                            tick+=1
                            if tick == merch.count {
                                completion()
                            }
                        case .failure(let error):
                            print("album hg\(error)")
                        }
                    })
                }

            } else {
                completion()
            }
        default:
            let song = content as! SongData
            if let merch = song.merch {
                for pro in merch {
                    let word = pro.split(separator: "Æ")
                    let id = word[0]
                    DatabaseManager.shared.findMerchById(merchId: String(id), completion: {[weak self] result in
                        guard let strongSelf = self else {return}
                        switch result {
                        case .success(let mer):
                            strongSelf.merchArray.append(mer)
                            tick+=1
                            if tick == merch.count {
                                completion()
                            }
                        case .failure(let error):
                            print("song hg\(error)")
                        }
                    })
                }
            } else {
                completion()
            }
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "infoToInfo" {
            if let viewController: InfoDetailViewController = segue.destination as? InfoDetailViewController {
                if visualEffectView != nil {
                    visualEffectView.removeFromSuperview()
                    visualEffectView = nil
                }
                viewController.content = infoDetailContent
            }
        } else if segue.identifier == "infoToArt" {
            if let viewController: ArtistInfoViewController = segue.destination as? ArtistInfoViewController {
                if visualEffectView != nil {
                    visualEffectView.removeFromSuperview()
                    visualEffectView = nil
                }
                recievedArtistData = artistInfo
            }
        } else if segue.identifier == "infoToPro" {
            if let viewController: ProducerInfoViewController = segue.destination as? ProducerInfoViewController {
                if visualEffectView != nil {
                    visualEffectView.removeFromSuperview()
                    visualEffectView = nil
                }
                recievedProducerData = producerInfo
            }
        }
    }

    @IBAction func playButtionTapped(_ sender: Any) {
        switch content {
        case is SongData:
            let song = content as! SongData
            if audiofreeze != true {
                player = nil
                playerTimer = Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(playertimerset), userInfo: nil, repeats: false)
                if audioPlayerViewController != nil {
                    audioPlayerViewController.view.removeFromSuperview()
                    audioPlayerViewController.removeFromParent()
                    playervisualEffectView.removeFromSuperview()
                }
                let urlPlayable:URL!
                let prevurl = prevURL(array: song)
                if let url  = URL.init(string: prevurl){
                    urlPlayable = url
                    guard  let urlPlayable = urlPlayable else {return}
                    let myDict = [ "url": urlPlayable, "song":song] as [String : Any]
                    NotificationCenter.default.post(name: AudioPlayerOnSongNotify, object: myDict)
                }
            }
        case is InstrumentalData:
            let beat = content as! InstrumentalData
            if audiofreeze != true {
                player = nil
                playerTimer = Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(playertimerset), userInfo: nil, repeats: false)
                if audioPlayerViewController != nil {
                    audioPlayerViewController.view.removeFromSuperview()
                    audioPlayerViewController.removeFromParent()
                    playervisualEffectView.removeFromSuperview()
                }
                let urlPlayable:URL!
                let prevurl = prevURL(array: beat)
                if let url  = URL.init(string: prevurl){
                    urlPlayable = url
                    guard  let urlPlayable = urlPlayable else {return}
                    let myDict = [ "url": urlPlayable, "beat":beat] as [String : Any]
                    NotificationCenter.default.post(name: AudioPlayerOnInstrumentalNotify, object: myDict)
                }
            }
        default:
            print("\"\"dsjvnkwrebnvds")
        }
    }
    @IBAction func favoriteTapped(_ sender: Any) {
//        switch content {
//        case is SongData:
//            let currentSong = content as! SongData
//            var artNames:[String]!
//            var songart:[String] = []
//            for art in currentSong.songArtist {
//                let word = art.split(separator: "Æ")
//                let id = word[1]
//                songart.append(String(id))
//            }
//            artNames = songart
//            switch favorited {
//            case true:
//                favorited = false
//                favoriteButton.setImage(UIImage(systemName: "heart"), for: .normal)
//                favoriteButton.tintColor = .white
//                let id = "\(currentSong.toneDeafAppId)Æ\(currentSong.name)"
//                var newfav:[UserFavorite] = []
//                for fav in currentAppUser.favorites {
//                    if fav.dbid != id {
//                        newfav.append(fav)
//                    }
//                }
//                if currentSong.albums != [""] {
//                    for album in currentSong.albums! {
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
//                currentAppUser.favorites = newfav
//                Database.database().reference().child("Users").child(currentAppUser.uid).child("Favorites").child(id).removeValue()
//                let categorty = "\(songContentTag)--\(currentSong.name)--\(artNames.joined(separator: ", "))--\(currentSong.toneDeafAppId)"
//                DatabaseManager.shared.getSongFavorites(currentSong: currentSong, completion: { favs in
//                    var num = favs
//                    num-=1
//                    Database.database().reference().child("Music Content").child("Songs").child(categorty).child("REQUIRED").child("Number of Favorites Overall").setValue(num)
//                })
//            default:
//                favorited = true
//                lightImpactGenerator.impactOccurred()
//                tapScale(button: favoriteButton)
//                favoriteButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
//                favoriteButton.tintColor = Constants.Colors.redApp
//                let id = "\(currentSong.toneDeafAppId)Æ\(currentSong.name)"
//                let datee = getCurrentLocalDate()
//                let dateFormatter = DateFormatter()
//                dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
//                dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
//                let date = dateFormatter.date(from:datee)!
//                if currentSong.albums != [""] {
//                    for album in currentSong.albums! {
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
//                currentAppUser.favorites.append(UserFavorite(dbid: id, timestamp: date))
//                Database.database().reference().child("Users").child(currentAppUser.uid).child("Favorites").child(id).child("Timestamp").setValue(datee)
//                let categorty = "\(songContentTag)--\(currentSong.name)--\(artNames.joined(separator: ", "))--\(currentSong.toneDeafAppId)"
//                DatabaseManager.shared.getSongFavorites(currentSong: currentSong, completion: { favs in
//                    var num = favs
//                    num+=1
//                    print(num)
//                    Database.database().reference().child("Music Content").child("Songs").child(categorty).child("REQUIRED").child("Number of Favorites Overall").setValue(num)
//                })
//            }
//        case is InstrumentalData:
//            let currentImstrumental = content as! InstrumentalData
//            switch favorited {
//            case true:
//                favorited = false
//                favoriteButton.setImage(UIImage(systemName: "heart"), for: .normal)
//                favoriteButton.tintColor = .white
//                let id = "\(currentImstrumental.toneDeafAppId)Æ\(currentImstrumental.instrumentalName)"
//                var newfav:[UserFavorite] = []
//                for fav in currentAppUser.favorites {
//                    if fav.dbid != id {
//                        newfav.append(fav)
//                    }
//                }
//                if currentImstrumental.albums != [""] {
//                    for album in currentImstrumental.albums {
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
//                if currentImstrumental.songs != [""] {
//                    for song in currentImstrumental.songs {
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
//                currentAppUser.favorites = newfav
//                Database.database().reference().child("Users").child(currentAppUser.uid).child("Favorites").child(id).removeValue()
//                let songname = currentImstrumental.instrumentalName.replacingOccurrences(of: " (Instrumental)", with: "")
//                let categorty = ("\(instrumentalContentType )--\(songname)--\(currentImstrumental.dateRegisteredToApp ?? "")--\(currentImstrumental.timeRegisteredToApp ?? "")--\(currentImstrumental.toneDeafAppId)")
//                DatabaseManager.shared.getInstrumentalFavorites(currentInstrumental: currentImstrumental, completion: { favs in
//                    var num = favs
//                    num-=1
//                    Database.database().reference().child("Music Content").child("Instrumentals").child(categorty).child("Number of Favorites").setValue(num)
//                })
//            default:
//                favorited = true
//                lightImpactGenerator.impactOccurred()
//                tapScale(button: favoriteButton)
//                favoriteButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
//                favoriteButton.tintColor = Constants.Colors.redApp
//                let id = "\(currentImstrumental.toneDeafAppId)Æ\(currentImstrumental.instrumentalName)"
//                let datee = getCurrentLocalDate()
//                let dateFormatter = DateFormatter()
//                dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
//                dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
//                let date = dateFormatter.date(from:datee)!
//                if currentImstrumental.albums != [""] {
//                    for album in currentImstrumental.albums {
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
//                if currentImstrumental.songs != [""] {
//                    for song in currentImstrumental.songs {
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
//                currentAppUser.favorites.append(UserFavorite(dbid: id, timestamp: date))
//                Database.database().reference().child("Users").child(currentAppUser.uid).child("Favorites").child(id).child("Timestamp").setValue(datee)
//                let songname = currentImstrumental.instrumentalName.replacingOccurrences(of: " (Instrumental)", with: "")
//                let categorty = ("\(instrumentalContentType )--\(songname)--\(currentImstrumental.dateRegisteredToApp ?? "")--\(currentImstrumental.timeRegisteredToApp ?? "")--\(currentImstrumental.toneDeafAppId)")
//                DatabaseManager.shared.getInstrumentalFavorites(currentInstrumental: currentImstrumental, completion: { favs in
//                    var num = favs
//                    num+=1
//                    Database.database().reference().child("Music Content").child("Instrumentals").child(categorty).child("Number of Favorites").setValue(num)
//                })
//            }
//        case is AlbumData:
//            let currentAlbum = content as! AlbumData
//            switch favorited {
//            case true:
//                favorited = false
//                favoriteButton.setImage(UIImage(systemName: "heart"), for: .normal)
//                favoriteButton.tintColor = .white
//                let id = "\(currentAlbum.toneDeafAppId)Æ\(currentAlbum.name)"
//                var newfav:[UserFavorite] = []
//                for fav in currentAppUser.favorites {
//                    if fav.dbid != id {
//                        newfav.append(fav)
//                    }
//                }
//                currentAppUser.favorites = newfav
//                Database.database().reference().child("Users").child(currentAppUser.uid).child("Favorites").child(id).removeValue()
//                var mainArtistsNames:Array<String> = []
//                for artist in currentAlbum.mainArtist {
//                    let word = artist.split(separator: "Æ")
//                    let id = word[1]
//                    mainArtistsNames.append(String(id))
//                }
//                let categorty = "\(albumContentTag)--\(currentAlbum.name)--\(mainArtistsNames.joined(separator: ", "))--\(currentAlbum.toneDeafAppId)"
//                DatabaseManager.shared.getAlbumFavorites(currentAlbum: currentAlbum, completion: { favs in
//                    var num = favs
//                    num-=1
//                    Database.database().reference().child("Music Content").child("Albums").child(categorty).child("REQUIRED").child("Number of Favorites Overall").setValue(num)
//                })
//            default:
//                favorited = true
//                lightImpactGenerator.impactOccurred()
//                tapScale(button: favoriteButton)
//                favoriteButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
//                favoriteButton.tintColor = Constants.Colors.redApp
//                let id = "\(currentAlbum.toneDeafAppId)Æ\(currentAlbum.name)"
//                let datee = getCurrentLocalDate()
//                let dateFormatter = DateFormatter()
//                dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
//                dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
//                let date = dateFormatter.date(from:datee)!
//                currentAppUser.favorites.append(UserFavorite(dbid: id, timestamp: date))
//                Database.database().reference().child("Users").child(currentAppUser.uid).child("Favorites").child(id).child("Timestamp").setValue(datee)
//                var mainArtistsNames:Array<String> = []
//                for artist in currentAlbum.mainArtist {
//                    let word = artist.split(separator: "Æ")
//                    let id = word[1]
//                    mainArtistsNames.append(String(id))
//                }
//                let categorty = "\(albumContentTag)--\(currentAlbum.name)--\(mainArtistsNames.joined(separator: ", "))--\(currentAlbum.toneDeafAppId)"
//                DatabaseManager.shared.getAlbumFavorites(currentAlbum: currentAlbum, completion: { favs in
//                    var num = favs
//                    num+=1
//                    Database.database().reference().child("Music Content").child("Albums").child(categorty).child("REQUIRED").child("Number of Favorites Overall").setValue(num)
//                })
//            }
//        case is VideoData:
//            let currentVideo = content as! VideoData
//            switch favorited {
//            case true:
//                favorited = false
//                favoriteButton.setImage(UIImage(systemName: "heart"), for: .normal)
//                favoriteButton.tintColor = .white
//                var id = ""
//                var categorty = ""
//                switch currentVideo {
//                case is YouTubeData:
//                    let youtube = currentVideo as! YouTubeData
//                    id = "\(youtube.toneDeafAppId)Æ\(youtube.title.replacingOccurrences(of: ".", with: " ").replacingOccurrences(of: "#", with: " ").replacingOccurrences(of: "$", with: " ").replacingOccurrences(of: "[", with: " ").replacingOccurrences(of: "]", with: " ").replacingOccurrences(of: ":", with: " "))"
//                    categorty = ("\(youtube.type)--\(youtube.title.replacingOccurrences(of: ".", with: " ").replacingOccurrences(of: "#", with: " ").replacingOccurrences(of: "$", with: " ").replacingOccurrences(of: "[", with: " ").replacingOccurrences(of: "]", with: " ").replacingOccurrences(of: ":", with: " "))--\(youtube.dateIA)--\(youtube.timeIA)--\(youtube.toneDeafAppId)")
//                    if currentVideo.songs != [""] {
//                        for song in currentVideo.songs! {
//                            let word = song.split(separator: "Æ")
//                            let id = word[0]
//                            DatabaseManager.shared.findSongById(songId: String(id), completion: { result in
//                                switch result {
//                                case .success(let songdata):
//                                    var artistNameData:Array<String> = []
//                                    for artist in songdata.songArtist {
//                                        let word = artist.split(separator: "Æ")
//                                        let id = word[1]
//                                        artistNameData.append(String(id))
//                                    }
//                                    let songcategorty = "\(songContentTag)--\(songdata.name)--\(artistNameData.joined(separator: ", "))--\(songdata.toneDeafAppId)"
//                                    DatabaseManager.shared.getSongFavorites(currentSong: songdata, completion: { favs in
//                                        var num = favs
//                                        num-=1
//                                        Database.database().reference().child("Music Content").child("Songs").child(songcategorty).child("REQUIRED").child("Number of Favorites Overall").setValue(num)
//                                    })
//                                case .failure(let err):
//                                    print("err \(err)")
//                                }
//                            })
//                        }
//                    }
//                    if currentVideo.albums != [""] {
//                        for album in currentVideo.albums! {
//                            let word = album.split(separator: "Æ")
//                            let id = word[0]
//                            DatabaseManager.shared.findAlbumById(albumId: String(id), completion: { result in
//                                switch result {
//                                case .success(let albumdata):
//                                    var mainArtistsNames:Array<String> = []
//                                    for artist in albumdata.mainArtist {
//                                        let word = artist.split(separator: "Æ")
//                                        let id = word[1]
//                                        mainArtistsNames.append(String(id))
//                                    }
//                                    let albumcategorty = "\(albumContentTag)--\(albumdata.name)--\(mainArtistsNames.joined(separator: ", "))--\(albumdata.toneDeafAppId)"
//                                    DatabaseManager.shared.getAlbumFavorites(currentAlbum: albumdata, completion: { favs in
//                                        var num = favs
//                                        num-=1
//                                        Database.database().reference().child("Music Content").child("Albums").child(albumcategorty).child("REQUIRED").child("Number of Favorites Overall").setValue(num)
//                                    })
//                                case .failure(let err):
//                                    print("err \(err)")
//                                }
//                            })
//                        }
//                    }
//                    if currentVideo.instrumentals != [""] {
//                        for instrumental in currentVideo.instrumentals! {
//                            let word = instrumental.split(separator: "Æ")
//                            let id = word[0]
//                            DatabaseManager.shared.findInstrumentalById(instrumentalId: String(id), completion: { result in
//                                switch result {
//                                case .success(let instrumentaldata):
//                                    print("INSSSSS", instrumentaldata)
//                                    let instrumentalcategorty = ("\(instrumentalContentType )--\(instrumentaldata.songName)--\(instrumentaldata.dateRegisteredToApp ?? "")--\(instrumentaldata.timeRegisteredToApp ?? "")--\(instrumentaldata.toneDeafAppId)")
//                                    DatabaseManager.shared.getInstrumentalFavorites(currentInstrumental: instrumentaldata, completion: { favs in
//                                        var num = favs
//                                        num-=1
//                                        Database.database().reference().child("Music Content").child("Instrumentals").child(instrumentalcategorty).child("Number of Favorites").setValue(num)
//                                    })
//                                case .failure(let err):
//                                    print("err \(err)")
//                                }
//                            })
//                        }
//                    }
//                default:
//                    print("kjvhg")
//                }
//                var newfav:[UserFavorite] = []
//                for fav in currentAppUser.favorites {
//                    if fav.dbid != id {
//                        newfav.append(fav)
//                    }
//                }
//                currentAppUser.favorites = newfav
//                Database.database().reference().child("Users").child(currentAppUser.uid).child("Favorites").child(id).removeValue()
//                DatabaseManager.shared.getVideoFavorites(currentVideo: currentVideo, completion: { favs in
//                    var num = favs
//                    num-=1
//                    Database.database().reference().child("Music Content").child("Videos").child(categorty).child("Number of Favorites").setValue(num)
//                })
//            default:
//                favorited = true
//                lightImpactGenerator.impactOccurred()
//                tapScale(button: favoriteButton)
//                favoriteButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
//                favoriteButton.tintColor = Constants.Colors.redApp
//                var id = ""
//                var categorty = ""
//                switch currentVideo {
//                case is YouTubeData:
//                    let youtube = currentVideo as! YouTubeData
//                    id = "\(youtube.toneDeafAppId)Æ\(youtube.title.replacingOccurrences(of: ".", with: " ").replacingOccurrences(of: "#", with: " ").replacingOccurrences(of: "$", with: " ").replacingOccurrences(of: "[", with: " ").replacingOccurrences(of: "]", with: " ").replacingOccurrences(of: ":", with: " "))"
//                    categorty = ("\(youtube.type)--\(youtube.title.replacingOccurrences(of: ".", with: " ").replacingOccurrences(of: "#", with: " ").replacingOccurrences(of: "$", with: " ").replacingOccurrences(of: "[", with: " ").replacingOccurrences(of: "]", with: " ").replacingOccurrences(of: ":", with: " "))--\(youtube.dateIA)--\(youtube.timeIA)--\(youtube.toneDeafAppId)")
//
//                    if currentVideo.songs != [""] {
//                        for song in currentVideo.songs! {
//                            let word = song.split(separator: "Æ")
//                            let id = word[0]
//                            DatabaseManager.shared.findSongById(songId: String(id), completion: { result in
//                                switch result {
//                                case .success(let songdata):
//                                    var artistNameData:Array<String> = []
//                                    for artist in songdata.songArtist {
//                                        let word = artist.split(separator: "Æ")
//                                        let id = word[1]
//                                        artistNameData.append(String(id))
//                                    }
//                                    let songcategorty = "\(songContentTag)--\(songdata.name)--\(artistNameData.joined(separator: ", "))--\(songdata.toneDeafAppId)"
//                                    DatabaseManager.shared.getSongFavorites(currentSong: songdata, completion: { favs in
//                                        var num = favs
//                                        num+=1
//                                        Database.database().reference().child("Music Content").child("Songs").child(songcategorty).child("REQUIRED").child("Number of Favorites Overall").setValue(num)
//                                    })
//                                case .failure(let err):
//                                    print("err \(err)")
//                                }
//                            })
//                        }
//                    }
//                    if currentVideo.albums != [""] {
//                        for album in currentVideo.albums! {
//                            let word = album.split(separator: "Æ")
//                            let id = word[0]
//                            DatabaseManager.shared.findAlbumById(albumId: String(id), completion: { result in
//                                switch result {
//                                case .success(let albumdata):
//                                    var mainArtistsNames:Array<String> = []
//                                    for artist in albumdata.mainArtist {
//                                        let word = artist.split(separator: "Æ")
//                                        let id = word[1]
//                                        mainArtistsNames.append(String(id))
//                                    }
//                                    let albumcategorty = "\(albumContentTag)--\(albumdata.name)--\(mainArtistsNames.joined(separator: ", "))--\(albumdata.toneDeafAppId)"
//                                    DatabaseManager.shared.getAlbumFavorites(currentAlbum: albumdata, completion: { favs in
//                                        var num = favs
//                                        num+=1
//                                        Database.database().reference().child("Music Content").child("Albums").child(albumcategorty).child("REQUIRED").child("Number of Favorites Overall").setValue(num)
//                                    })
//                                case .failure(let err):
//                                    print("err \(err)")
//                                }
//                            })
//                        }
//                    }
//                    if currentVideo.instrumentals != [""] {
//                        for instrumental in currentVideo.instrumentals! {
//                            let word = instrumental.split(separator: "Æ")
//                            let id = word[0]
//                            DatabaseManager.shared.findInstrumentalById(instrumentalId: String(id), completion: { result in
//                                switch result {
//                                case .success(let instrumentaldata):
//                                    let instrumentalcategorty = ("\(instrumentalContentType )--\(instrumentaldata.songName)--\(instrumentaldata.dateRegisteredToApp ?? "")--\(instrumentaldata.timeRegisteredToApp ?? "")--\(instrumentaldata.toneDeafAppId)")
//                                    DatabaseManager.shared.getInstrumentalFavorites(currentInstrumental: instrumentaldata, completion: { favs in
//                                        var num = favs
//                                        num+=1
//                                        Database.database().reference().child("Music Content").child("Instrumentals").child(instrumentalcategorty).child("Number of Favorites").setValue(num)
//                                    })
//                                case .failure(let err):
//                                    print("err \(err)")
//                                }
//                            })
//                        }
//                    }
//                default:
//                    print("kjvhg")
//                }
//                let datee = getCurrentLocalDate()
//                let dateFormatter = DateFormatter()
//                dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
//                dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
//                let date = dateFormatter.date(from:datee)!
//                currentAppUser.favorites.append(UserFavorite(dbid: id, timestamp: date))
//                print(currentAppUser.uid)
//                print(id)
//                print(categorty)
//                Database.database().reference().child("Users").child(currentAppUser.uid).child("Favorites").child(id).child("Timestamp").setValue(datee)
//                DatabaseManager.shared.getVideoFavorites(currentVideo: currentVideo, completion: { favs in
//                    var num = favs
//                    num+=1
//                    Database.database().reference().child("Music Content").child("Videos").child(categorty).child("Number of Favorites").setValue(num)
//                })
//            }
//        default:
//            let currentBeat = content as! BeatData
//            switch favorited {
//            case true:
//                favorited = false
//                favoriteButton.setImage(UIImage(systemName: "heart"), for: .normal)
//                favoriteButton.tintColor = .white
//                let id = "\(currentBeat.toneDeafAppId)Æ\(currentBeat.name)"
//                var newfav:[UserFavorite] = []
//                for fav in currentAppUser.favorites {
//                    if fav.dbid != id {
//                        newfav.append(fav)
//                    }
//                }
//                currentAppUser.favorites = newfav
//                Database.database().reference().child("Users").child(currentAppUser.uid).child("Favorites").child(id).removeValue()
//                DatabaseManager.shared.getBeatFavorites(currentBeat: currentBeat, completion: { favs in
//                    var num = favs
//                    num-=1
//                    Database.database().reference().child("Beats").child(currentBeat.priceType).child(currentBeat.beatID).child("Number of Favorites").setValue(num)
//                })
//            default:
//                favorited = true
//                lightImpactGenerator.impactOccurred()
//                tapScale(button: favoriteButton)
//                favoriteButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
//                favoriteButton.tintColor = Constants.Colors.redApp
//                let id = "\(currentBeat.toneDeafAppId)Æ\(currentBeat.name)"
//                let datee = getCurrentLocalDate()
//                let dateFormatter = DateFormatter()
//                dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
//                dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
//                let date = dateFormatter.date(from:datee)!
//                currentAppUser.favorites.append(UserFavorite(dbid: id, timestamp: date))
//                Database.database().reference().child("Users").child(currentAppUser.uid).child("Favorites").child(id).child("Timestamp").setValue(datee)
//                DatabaseManager.shared.getBeatFavorites(currentBeat: currentBeat, completion: { favs in
//                    var num = favs
//                    num+=1
//                    print(num)
//                    Database.database().reference().child("Beats").child(currentBeat.priceType).child(currentBeat.beatID).child("Number of Favorites").setValue(num)
//                })
//            }
//        }
    }
    @objc func moreButtonTapped() {
        let vc = UIActivityViewController(activityItems: ["https://www.instagram.com/p/CFDTWydAHfe/?igshid=1t9t6pubzu1u0"], applicationActivities: [GoToInstagramProfileActivity()])
        vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(vc, animated: true, completion: nil)
    }


    @objc func playertimerset() {
        audiofreeze = false
        print("Audio Freeze Off")
        playerTimer.invalidate()
    }

    func prevURL(array: SongData) -> String {
        var prevurl:String = ""
        if array.apple?.applePreviewURL != "" {
            prevurl = array.apple!.applePreviewURL
        } else if array.spotify?.spotifyPreviewURL != "" {
            prevurl = array.spotify!.spotifyPreviewURL
        }
        return prevurl
    }

    func prevURL(array: InstrumentalData) -> String {
        var prevurl:String!
//        if array.applePreviewURL != "" {
//            prevurl = array.applePreviewURL
//        } else if array.spotifyPreviewURL != "" {
//            prevurl = array.spotifyPreviewURL
//        }
        return prevurl
    }



}

extension InfoDetailViewController: UIScrollViewDelegate {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
//        if scrollView == discoverTableView {
//            scrollView.isScrollEnabled = false
//            scrollView.isPagingEnabled = true
//            scrollView.showsVerticalScrollIndicator = false
//        }
    }
    
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

extension InfoDetailViewController: UITableViewDataSource, UITableViewDelegate, SkeletonTableViewDataSource {
    func collectionSkeletonView(_ skeletonView: UITableView, cellIdentifierForRowAt indexPath: IndexPath) -> ReusableCellIdentifier {
        switch tableView {
        case serviceTableView:
            return "infoViewNowCell"
        default:
            return "infoDetailCell"
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
        let cell = self.tableView.dequeueReusableHeaderFooterView(withIdentifier: "TableSectionHeader") as! TableSectionHeader
        var sectitle = ""
        switch tableView {
        case serviceTableView:
            switch content {
            case is YouTubeData:
                sectitle = "Watch"
            case is SongData:
                sectitle = "Stream"
            case is InstrumentalData:
                sectitle = "Stream"
            default:
                sectitle = "Stream"
            }
        default:
            if section == 0 {
                if self.tableView(tableView, numberOfRowsInSection: section) > 0 {
                    sectitle = "Artists"
                } else {
                    return nil
                }
            } else if section == 1 {
                if self.tableView(tableView, numberOfRowsInSection: section) > 0 {
                    sectitle = "Producers"
                } else {
                    return nil
                }
            } else if section == 2 {
                if self.tableView(tableView, numberOfRowsInSection: section) > 0 {
                    sectitle = "Writers"
                } else {
                    return nil
                }
            } else if section == 3 {
                if self.tableView(tableView, numberOfRowsInSection: section) > 0 {
                    sectitle = "Mix Engineers"
                } else {
                    return nil
                }
            } else if section == 4 {
                if self.tableView(tableView, numberOfRowsInSection: section) > 0 {
                    sectitle = "Mastering Engineers"
                } else {
                    return nil
                }
            } else if section == 5 {
                if self.tableView(tableView, numberOfRowsInSection: section) > 0 {
                    sectitle = "Recording Engineers"
                } else {
                    return nil
                }
            } else if section == 6 {
                if self.tableView(tableView, numberOfRowsInSection: section) > 0 {
                    sectitle = "Merchandise"
                } else {
                    return nil
                }
            } else if section == 7 {
                if self.tableView(tableView, numberOfRowsInSection: section) > 0 {
                    sectitle = "Songs"
                } else {
                    return nil
                }
            } else if section == 8 {
                if self.tableView(tableView, numberOfRowsInSection: section) > 0 {
                    sectitle = "Videos"
                } else {
                    return nil
                }
            } else if section == 9 {
                if self.tableView(tableView, numberOfRowsInSection: section) > 0 {
                    sectitle = "Albums"
                } else {
                    return nil
                }
            }
            else {
                if self.tableView(tableView, numberOfRowsInSection: section) > 0 {
                    sectitle = "Instrumentals"
                } else {
                    return nil
                }
            }
        }
        let header = cell
        header.titleLabel.text = sectitle
        
        return cell
        
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        var numberOfSections = 1
        if tableView != serviceTableView {
            if data != nil, !data.isEmpty {
                numberOfSections = data.count
            }
        }
        return numberOfSections
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var numberOfRows = 0
        switch tableView {
        case serviceTableView:
            numberOfRows = serviceArray.count
        default:
            if data != nil, !data.isEmpty {
                numberOfRows = data[section].count
            }
        }
        return numberOfRows
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch tableView {
        case serviceTableView:
            return 60
        default:
            return 80
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch tableView {
        case serviceTableView:
            let cell = tableView.dequeueReusableCell(withIdentifier: "infoViewNowCell", for: indexPath) as! InfoViewNowTableCell
            if !serviceArray.isEmpty {
                switch serviceArray[indexPath.row] {
                case "youtube":
                    let string = serviceArray[indexPath.row]
                    cell.funcSetTemp(youtube: string)
                case "ytim":
                    let string = serviceArray[indexPath.row]
                    cell.funcSetTemp(ytim: string)
                case "ytad":
                    let string = serviceArray[indexPath.row]
                    cell.funcSetTemp(ytad: string)
                case "spotify":
                    let string = serviceArray[indexPath.row]
                    cell.funcSetTemp(spotify: string)
                case "soundcloud":
                    let string = serviceArray[indexPath.row]
                    cell.funcSetTemp(soundcloud: string)
                case "youtubemusic":
                    let string = serviceArray[indexPath.row]
                    cell.funcSetTemp(youtubemusic: string)
                case "amazon":
                    let string = serviceArray[indexPath.row]
                    cell.funcSetTemp(amazon: string)
                case "spinrilla":
                    let string = serviceArray[indexPath.row]
                    cell.funcSetTemp(spinrilla: string)
                case "deezer":
                    let string = serviceArray[indexPath.row]
                    cell.funcSetTemp(deezer: string)
                case "napster":
                    let string = serviceArray[indexPath.row]
                    cell.funcSetTemp(napster: string)
                case "tidal":
                    let string = serviceArray[indexPath.row]
                    cell.funcSetTemp(tidal: string)
                default:
                    let string = serviceArray[indexPath.row]
                    cell.funcSetTemp(apple: string)
                }
            }
            return cell
        default:
            switch indexPath.section {
            case 0:
                let cell = tableView.dequeueReusableCell(withIdentifier: "infoDetailCell", for: indexPath) as! InfoDetailTableCell
                if !artistsArray.isEmpty {
                    let video = data[indexPath.section][indexPath.row] as! PersonData
                    cell.funcSetTemp(person: video)
                }
                return cell
            case 1:
                let cell = tableView.dequeueReusableCell(withIdentifier: "infoDetailCell", for: indexPath) as! InfoDetailTableCell
                if !producersArray.isEmpty {
                    let video = data[indexPath.section][indexPath.row] as! PersonData
                    cell.funcSetTemp(person: video)
                }
                return cell
            case 2:
                let cell = tableView.dequeueReusableCell(withIdentifier: "infoDetailCell", for: indexPath) as! InfoDetailTableCell
                if !writersArray.isEmpty {
                    let video = data[indexPath.section][indexPath.row] as! PersonData
                    cell.funcSetTemp(person: video)
                }
                return cell
            case 3:
                let cell = tableView.dequeueReusableCell(withIdentifier: "infoDetailCell", for: indexPath) as! InfoDetailTableCell
                if !mixEngineersArray.isEmpty {
                    let video = data[indexPath.section][indexPath.row] as! PersonData
                    cell.funcSetTemp(person: video)
                }
                return cell
            case 4:
                let cell = tableView.dequeueReusableCell(withIdentifier: "infoDetailCell", for: indexPath) as! InfoDetailTableCell
                if !masteringEngineersArray.isEmpty {
                    let video = data[indexPath.section][indexPath.row] as! PersonData
                    cell.funcSetTemp(person: video)
                }
                return cell
            case 5:
                let cell = tableView.dequeueReusableCell(withIdentifier: "infoDetailCell", for: indexPath) as! InfoDetailTableCell
                if !recordingEngineersArray.isEmpty {
                    let video = data[indexPath.section][indexPath.row] as! PersonData
                    cell.funcSetTemp(person: video)
                }
                return cell
            case 6:
                let cell = tableView.dequeueReusableCell(withIdentifier: "infoDetailCell", for: indexPath) as! InfoDetailTableCell
                if !merchArray.isEmpty {
                    let video = data[indexPath.section][indexPath.row] as! MerchData
                    cell.funcSetTemp(merch: video)
                }
                return cell
            case 7:
                let cell = tableView.dequeueReusableCell(withIdentifier: "infoDetailCell", for: indexPath) as! InfoDetailTableCell
                if !songsArray.isEmpty {
                    let video = data[indexPath.section][indexPath.row] as! SongData
                    cell.funcSetTemp(song: video)
                }
                return cell
            case 8:
                let cell = tableView.dequeueReusableCell(withIdentifier: "infoVideoDetailCell", for: indexPath) as! InfoVideoDetailTableCell
                if !videosArray.isEmpty {
                    let video = data[indexPath.section][indexPath.row] as! VideoData
                    cell.funcSetTemp(video: video)
                }
                return cell
            case 9:
                let cell = tableView.dequeueReusableCell(withIdentifier: "infoDetailCell", for: indexPath) as! InfoDetailTableCell
                if !albumsArray.isEmpty {
                    let video = data[indexPath.section][indexPath.row] as! AlbumData
                    cell.funcSetTemp(album: video)
                }
                return cell
            default:
                let cell = tableView.dequeueReusableCell(withIdentifier: "infoDetailCell", for: indexPath) as! InfoDetailTableCell
                if !instrumentalsArray.isEmpty {
                    let video = data[indexPath.section][indexPath.row] as! InstrumentalData
                    cell.funcSetTemp(instrumental: video)
                }
                return cell
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        switch tableView {
        case serviceTableView:
            switch serviceArray[indexPath.row] {
            case "youtube":
                let progressHUD = ProgressHUD(text: "Preparing...")
                  self.view.addSubview(progressHUD)
                let video = content as! YouTubeData
                currentPlayingYoutubeVideo = video
                progressHUD.stopAnimation()
                progressHUD.removeFromSuperview()
                NotificationCenter.default.post(name: YoutubePlayNotify, object: nil)
            case "ytim":
                print("jahfdgjs")
            case "ytad":
                switch content {
                case is SongData:
                    let progressHUD = ProgressHUD(text: "Preparing...")
                      self.view.addSubview(progressHUD)
//                    let song = content as! SongData
//                    let word = song.audioVideo!
//                    let id = word[0]
//                    DatabaseManager.shared.findVideoById(videoid: String(id), completion: { result in
//                        switch result {
//                        case.success(let video):
//                            let yt = video as! YouTubeData
//                            currentPlayingYoutubeVideo = yt
//                            progressHUD.stopAnimation()
//                            progressHUD.removeFromSuperview()
//                            NotificationCenter.default.post(name: YoutubePlayNotify, object: nil)
//                        case.failure(let errr):
//                            print("handg \(errr)")
//                        }
//                    })
                default:
                    print("jahfdgjs")
                }
            case "spotify":
                switch content {
                case is SongData:
                    let song = content as! SongData
                    let alerticon = UIImage(named: "spotifyalert")!.withTintColor(.white)
                    let actionSheet = CDAlertView(title: "Open \(song.name) in Spotify?", message: "If you don't have Spotify, \(song.name) will open in Safari.", type: .custom(image: alerticon))
                    actionSheet.alertBackgroundColor = Constants.Colors.mediumApp
                    actionSheet.circleFillColor = .black
                    actionSheet.titleTextColor = .white
                    actionSheet.messageTextColor = .white
                    let cancel = CDAlertViewAction(title: "Cancel", font: UIFont.systemFont(ofSize: 16), textColor: Constants.Colors.redApp, backgroundColor: Constants.Colors.mediumApp, handler: nil)
                    actionSheet.add(action: cancel)
                    actionSheet.add(action: CDAlertViewAction(title: "Open", font: UIFont.boldSystemFont(ofSize: 16), textColor: Constants.Colors.redApp, backgroundColor: Constants.Colors.mediumApp, handler: {_ in
                        let url = URL(string: song.spotify!.spotifySongURL)
                        if UIApplication.shared.canOpenURL(url!)
                        {
                            UIApplication.shared.open(url!, options: [:], completionHandler: nil)
                        } else {
                            //redirect to safari because the user doesn't have Instagram
                                UIApplication.shared.open(URL(string: "http://spotify.com/")!, options: [:], completionHandler: nil)
                        }
                        return true
                    }))
                    NotificationCenter.default.post(name: OpenTheAlertNotify, object: actionSheet)
                case is AlbumData:
                    let album = content as! AlbumData
                    let alerticon = UIImage(named: "spotifyalert")!.withTintColor(.white)
                    let actionSheet = CDAlertView(title: "Open \(album.name) in Spotify?", message: "If you don't have Spotify, \(album.name) will open in Safari.", type: .custom(image: alerticon))
                    actionSheet.alertBackgroundColor = Constants.Colors.mediumApp
                    actionSheet.circleFillColor = .black
                    actionSheet.titleTextColor = .white
                    actionSheet.messageTextColor = .white
                    let cancel = CDAlertViewAction(title: "Cancel", font: UIFont.systemFont(ofSize: 16), textColor: Constants.Colors.redApp, backgroundColor: Constants.Colors.mediumApp, handler: nil)
                    actionSheet.add(action: cancel)
                    actionSheet.add(action: CDAlertViewAction(title: "Open", font: UIFont.boldSystemFont(ofSize: 16), textColor: Constants.Colors.redApp, backgroundColor: Constants.Colors.mediumApp, handler: {_ in
                        let url = URL(string: album.spotify!.url)
                        if UIApplication.shared.canOpenURL(url!)
                        {
                            UIApplication.shared.open(url!, options: [:], completionHandler: nil)
                        } else {
                            //redirect to safari because the user doesn't have Instagram
                                UIApplication.shared.open(URL(string: "http://spotify.com/")!, options: [:], completionHandler: nil)
                        }
                        return true
                    }))
                    NotificationCenter.default.post(name: OpenTheAlertNotify, object: actionSheet)
                case is InstrumentalData:
                    let instrumental = content as! InstrumentalData
                    let alerticon = UIImage(named: "spotifyalert")!.withTintColor(.white)
                    let actionSheet = CDAlertView(title: "Open \(instrumental.instrumentalName) in Spotify?", message: "If you don't have Spotify, \(instrumental.instrumentalName) will open in Safari.", type: .custom(image: alerticon))
                    actionSheet.alertBackgroundColor = Constants.Colors.mediumApp
                    actionSheet.circleFillColor = .black
                    actionSheet.titleTextColor = .white
                    actionSheet.messageTextColor = .white
                    let cancel = CDAlertViewAction(title: "Cancel", font: UIFont.systemFont(ofSize: 16), textColor: Constants.Colors.redApp, backgroundColor: Constants.Colors.mediumApp, handler: nil)
                    actionSheet.add(action: cancel)
                    actionSheet.add(action: CDAlertViewAction(title: "Open", font: UIFont.boldSystemFont(ofSize: 16), textColor: Constants.Colors.redApp, backgroundColor: Constants.Colors.mediumApp, handler: {_ in
                        let url = URL(string: instrumental.spotify!.spotifySongURL)
                        if UIApplication.shared.canOpenURL(url!)
                        {
                            UIApplication.shared.open(url!, options: [:], completionHandler: nil)
                        } else {
                            //redirect to safari because the user doesn't have Instagram
                                UIApplication.shared.open(URL(string: "http://spotify.com/")!, options: [:], completionHandler: nil)
                        }
                        return true
                    }))
                    NotificationCenter.default.post(name: OpenTheAlertNotify, object: actionSheet)
                default:
                    print("nil")
                }
            case "apple":
                switch content {
                case is SongData:
                    let song = content as! SongData
                    let alerticon = UIImage(named: "applealert")!.withTintColor(.white)
                    let actionSheet = CDAlertView(title: "Open \(song.name) in Apple Music?", message: "If you don't have Apple Music, \(song.name) will open in Safari.", type: .custom(image: alerticon))
                    actionSheet.alertBackgroundColor = Constants.Colors.mediumApp
                    actionSheet.circleFillColor = .black
                    actionSheet.titleTextColor = .white
                    actionSheet.messageTextColor = .white
                    let cancel = CDAlertViewAction(title: "Cancel", font: UIFont.systemFont(ofSize: 16), textColor: Constants.Colors.redApp, backgroundColor: Constants.Colors.mediumApp, handler: nil)
                    actionSheet.add(action: cancel)
                    actionSheet.add(action: CDAlertViewAction(title: "Open", font: UIFont.boldSystemFont(ofSize: 16), textColor: Constants.Colors.redApp, backgroundColor: Constants.Colors.mediumApp, handler: {_ in
                        let url = URL(string: song.apple!.appleSongURL)
                        if UIApplication.shared.canOpenURL(url!)
                        {
                            UIApplication.shared.open(url!, options: [:], completionHandler: nil)
                        } else {
                            //redirect to safari because the user doesn't have Instagram
                                UIApplication.shared.open(URL(string: "http://music.apple.com/")!, options: [:], completionHandler: nil)
                        }
                        return true
                    }))
                    NotificationCenter.default.post(name: OpenTheAlertNotify, object: actionSheet)
                case is AlbumData:
                    let album = content as! AlbumData
                    let alerticon = UIImage(named: "applealert")!.withTintColor(.white)
                    let actionSheet = CDAlertView(title: "Open \(album.name) in Apple Music?", message: "If you don't have Apple Music, \(album.name) will open in Safari.", type: .custom(image: alerticon))
                    actionSheet.alertBackgroundColor = Constants.Colors.mediumApp
                    actionSheet.circleFillColor = .black
                    actionSheet.titleTextColor = .white
                    actionSheet.messageTextColor = .white
                    let cancel = CDAlertViewAction(title: "Cancel", font: UIFont.systemFont(ofSize: 16), textColor: Constants.Colors.redApp, backgroundColor: Constants.Colors.mediumApp, handler: nil)
                    actionSheet.add(action: cancel)
                    actionSheet.add(action: CDAlertViewAction(title: "Open", font: UIFont.boldSystemFont(ofSize: 16), textColor: Constants.Colors.redApp, backgroundColor: Constants.Colors.mediumApp, handler: {_ in
                        let url = URL(string: album.apple!.url)
                        if UIApplication.shared.canOpenURL(url!)
                        {
                            UIApplication.shared.open(url!, options: [:], completionHandler: nil)
                        } else {
                            //redirect to safari because the user doesn't have Instagram
                                UIApplication.shared.open(URL(string: "http://music.apple.com/")!, options: [:], completionHandler: nil)
                        }
                        return true
                    }))
                    NotificationCenter.default.post(name: OpenTheAlertNotify, object: actionSheet)
                case is InstrumentalData:
                    let instrumental = content as! InstrumentalData
                    let alerticon = UIImage(named: "applealert")!.withTintColor(.white)
                    let actionSheet = CDAlertView(title: "Open \(instrumental.instrumentalName) in Apple Music?", message: "If you don't have Apple Music, \(instrumental.instrumentalName) will open in Safari.", type: .custom(image: alerticon))
                    actionSheet.alertBackgroundColor = Constants.Colors.mediumApp
                    actionSheet.circleFillColor = .black
                    actionSheet.titleTextColor = .white
                    actionSheet.messageTextColor = .white
                    let cancel = CDAlertViewAction(title: "Cancel", font: UIFont.systemFont(ofSize: 16), textColor: Constants.Colors.redApp, backgroundColor: Constants.Colors.mediumApp, handler: nil)
                    actionSheet.add(action: cancel)
                    actionSheet.add(action: CDAlertViewAction(title: "Open", font: UIFont.boldSystemFont(ofSize: 16), textColor: Constants.Colors.redApp, backgroundColor: Constants.Colors.mediumApp, handler: {_ in
                        let url = URL(string: instrumental.apple!.appleSongURL)
                        if UIApplication.shared.canOpenURL(url!)
                        {
                            UIApplication.shared.open(url!, options: [:], completionHandler: nil)
                        } else {
                            //redirect to safari because the user doesn't have Instagram
                                UIApplication.shared.open(URL(string: "http://music.apple.com/")!, options: [:], completionHandler: nil)
                        }
                        return true
                    }))
                    NotificationCenter.default.post(name: OpenTheAlertNotify, object: actionSheet)
                default:
                    print("nil")
                }
            case "youtubemusic":
                switch content {
                case is SongData:
                    let song = content as! SongData
                    let alerticon = UIImage(named: "youtubemusicalert")!.withTintColor(.white)
                    let actionSheet = CDAlertView(title: "Open \(song.name) in Youtube Music?", message: "If you don't have Youtube Music, \(song.name) will open in Safari.", type: .custom(image: alerticon))
                    actionSheet.alertBackgroundColor = Constants.Colors.mediumApp
                    actionSheet.circleFillColor = .black
                    actionSheet.titleTextColor = .white
                    actionSheet.messageTextColor = .white
                    let cancel = CDAlertViewAction(title: "Cancel", font: UIFont.systemFont(ofSize: 16), textColor: Constants.Colors.redApp, backgroundColor: Constants.Colors.mediumApp, handler: nil)
                    actionSheet.add(action: cancel)
                    actionSheet.add(action: CDAlertViewAction(title: "Open", font: UIFont.boldSystemFont(ofSize: 16), textColor: Constants.Colors.redApp, backgroundColor: Constants.Colors.mediumApp, handler: {_ in
                        let url = URL(string: song.youtubeMusic!.url)
                        if UIApplication.shared.canOpenURL(url!)
                        {
                            UIApplication.shared.open(url!, options: [:], completionHandler: nil)
                        } else {
                            //redirect to safari because the user doesn't have Instagram
                                UIApplication.shared.open(URL(string: "http://music.youtube.com/")!, options: [:], completionHandler: nil)
                        }
                        return true
                    }))
                    NotificationCenter.default.post(name: OpenTheAlertNotify, object: actionSheet)
                case is AlbumData:
                    let album = content as! AlbumData
                    let alerticon = UIImage(named: "youtubemusicalert")!.withTintColor(.white)
                    let actionSheet = CDAlertView(title: "Open \(album.name) in Youtube Music?", message: "If you don't have Youtube Music, \(album.name) will open in Safari.", type: .custom(image: alerticon))
                    actionSheet.alertBackgroundColor = Constants.Colors.mediumApp
                    actionSheet.circleFillColor = .black
                    actionSheet.titleTextColor = .white
                    actionSheet.messageTextColor = .white
                    let cancel = CDAlertViewAction(title: "Cancel", font: UIFont.systemFont(ofSize: 16), textColor: Constants.Colors.redApp, backgroundColor: Constants.Colors.mediumApp, handler: nil)
                    actionSheet.add(action: cancel)
                    actionSheet.add(action: CDAlertViewAction(title: "Open", font: UIFont.boldSystemFont(ofSize: 16), textColor: Constants.Colors.redApp, backgroundColor: Constants.Colors.mediumApp, handler: {_ in
                        let url = URL(string: album.youtubeMusic!.url)
                        if UIApplication.shared.canOpenURL(url!)
                        {
                            UIApplication.shared.open(url!, options: [:], completionHandler: nil)
                        } else {
                            //redirect to safari because the user doesn't have Instagram
                                UIApplication.shared.open(URL(string: "http://music.youtube.com/")!, options: [:], completionHandler: nil)
                        }
                        return true
                    }))
                    NotificationCenter.default.post(name: OpenTheAlertNotify, object: actionSheet)
                case is InstrumentalData:
                    let instrumental = content as! InstrumentalData
                    let alerticon = UIImage(named: "youtubemusicalert")!.withTintColor(.white)
                    let actionSheet = CDAlertView(title: "Open \(instrumental.instrumentalName) in Youtube Music?", message: "If you don't have Youtube Music, \(instrumental.instrumentalName) will open in Safari.", type: .custom(image: alerticon))
                    actionSheet.alertBackgroundColor = Constants.Colors.mediumApp
                    actionSheet.circleFillColor = .black
                    actionSheet.titleTextColor = .white
                    actionSheet.messageTextColor = .white
                    let cancel = CDAlertViewAction(title: "Cancel", font: UIFont.systemFont(ofSize: 16), textColor: Constants.Colors.redApp, backgroundColor: Constants.Colors.mediumApp, handler: nil)
                    actionSheet.add(action: cancel)
                    actionSheet.add(action: CDAlertViewAction(title: "Open", font: UIFont.boldSystemFont(ofSize: 16), textColor: Constants.Colors.redApp, backgroundColor: Constants.Colors.mediumApp, handler: {_ in
                        let url = URL(string: instrumental.youtubeMusic!.url)
                        if UIApplication.shared.canOpenURL(url!)
                        {
                            UIApplication.shared.open(url!, options: [:], completionHandler: nil)
                        } else {
                            //redirect to safari because the user doesn't have Instagram
                                UIApplication.shared.open(URL(string: "http://music.youtube.com/")!, options: [:], completionHandler: nil)
                        }
                        return true
                    }))
                    NotificationCenter.default.post(name: OpenTheAlertNotify, object: actionSheet)
                default:
                    print("nil")
                }
            case "amazon":
                switch content {
                case is SongData:
                    let song = content as! SongData
                    let alerticon = UIImage(named: "amazonalert")!.withTintColor(.white)
                    let actionSheet = CDAlertView(title: "Open \(song.name) in Amazon Music?", message: "If you don't have Amazon Music, \(song.name) will open in Safari.", type: .custom(image: alerticon))
                    actionSheet.alertBackgroundColor = Constants.Colors.mediumApp
                    actionSheet.circleFillColor = .black
                    actionSheet.titleTextColor = .white
                    actionSheet.messageTextColor = .white
                    let cancel = CDAlertViewAction(title: "Cancel", font: UIFont.systemFont(ofSize: 16), textColor: Constants.Colors.redApp, backgroundColor: Constants.Colors.mediumApp, handler: nil)
                    actionSheet.add(action: cancel)
                    actionSheet.add(action: CDAlertViewAction(title: "Open", font: UIFont.boldSystemFont(ofSize: 16), textColor: Constants.Colors.redApp, backgroundColor: Constants.Colors.mediumApp, handler: {_ in
                        let url = URL(string: song.amazon!.url)
                        if UIApplication.shared.canOpenURL(url!)
                        {
                            UIApplication.shared.open(url!, options: [:], completionHandler: nil)
                        } else {
                            //redirect to safari because the user doesn't have Instagram
                                UIApplication.shared.open(URL(string: "http://music.amazon.com/")!, options: [:], completionHandler: nil)
                        }
                        return true
                    }))
                    NotificationCenter.default.post(name: OpenTheAlertNotify, object: actionSheet)
                case is AlbumData:
                    let album = content as! AlbumData
                    let alerticon = UIImage(named: "amazonalert")!.withTintColor(.white)
                    let actionSheet = CDAlertView(title: "Open \(album.name) in Amazon Music?", message: "If you don't have Amazon Music, \(album.name) will open in Safari.", type: .custom(image: alerticon))
                    actionSheet.alertBackgroundColor = Constants.Colors.mediumApp
                    actionSheet.circleFillColor = .black
                    actionSheet.titleTextColor = .white
                    actionSheet.messageTextColor = .white
                    let cancel = CDAlertViewAction(title: "Cancel", font: UIFont.systemFont(ofSize: 16), textColor: Constants.Colors.redApp, backgroundColor: Constants.Colors.mediumApp, handler: nil)
                    actionSheet.add(action: cancel)
                    actionSheet.add(action: CDAlertViewAction(title: "Open", font: UIFont.boldSystemFont(ofSize: 16), textColor: Constants.Colors.redApp, backgroundColor: Constants.Colors.mediumApp, handler: {_ in
                        let url = URL(string: album.amazon!.url)
                        if UIApplication.shared.canOpenURL(url!)
                        {
                            UIApplication.shared.open(url!, options: [:], completionHandler: nil)
                        } else {
                            //redirect to safari because the user doesn't have Instagram
                                UIApplication.shared.open(URL(string: "http://music.amazon.com/")!, options: [:], completionHandler: nil)
                        }
                        return true
                    }))
                    NotificationCenter.default.post(name: OpenTheAlertNotify, object: actionSheet)
                case is InstrumentalData:
                    let instrumental = content as! InstrumentalData
                    let alerticon = UIImage(named: "amazonalert")!.withTintColor(.white)
                    let actionSheet = CDAlertView(title: "Open \(instrumental.instrumentalName) in Amazon Music?", message: "If you don't have Amazon Music, \(instrumental.instrumentalName) will open in Safari.", type: .custom(image: alerticon))
                    actionSheet.alertBackgroundColor = Constants.Colors.mediumApp
                    actionSheet.circleFillColor = .black
                    actionSheet.titleTextColor = .white
                    actionSheet.messageTextColor = .white
                    let cancel = CDAlertViewAction(title: "Cancel", font: UIFont.systemFont(ofSize: 16), textColor: Constants.Colors.redApp, backgroundColor: Constants.Colors.mediumApp, handler: nil)
                    actionSheet.add(action: cancel)
                    actionSheet.add(action: CDAlertViewAction(title: "Open", font: UIFont.boldSystemFont(ofSize: 16), textColor: Constants.Colors.redApp, backgroundColor: Constants.Colors.mediumApp, handler: {_ in
                        let url = URL(string: instrumental.amazon!.url)
                        if UIApplication.shared.canOpenURL(url!)
                        {
                            UIApplication.shared.open(url!, options: [:], completionHandler: nil)
                        } else {
                            //redirect to safari because the user doesn't have Instagram
                                UIApplication.shared.open(URL(string: "http://music.amazon.com/")!, options: [:], completionHandler: nil)
                        }
                        return true
                    }))
                    NotificationCenter.default.post(name: OpenTheAlertNotify, object: actionSheet)
                default:
                    print("nil")
                }
            case "deezer":
                switch content {
                case is SongData:
                    let song = content as! SongData
                    let alerticon = UIImage(named: "deezerlogo")!.withTintColor(.white)
                    let actionSheet = CDAlertView(title: "Open \(song.name) in Deezer?", message: "If you don't have Deezer, \(song.name) will open in Safari.", type: .custom(image: alerticon))
                    actionSheet.alertBackgroundColor = Constants.Colors.mediumApp
                    actionSheet.circleFillColor = .black
                    actionSheet.titleTextColor = .white
                    actionSheet.messageTextColor = .white
                    let cancel = CDAlertViewAction(title: "Cancel", font: UIFont.systemFont(ofSize: 16), textColor: Constants.Colors.redApp, backgroundColor: Constants.Colors.mediumApp, handler: nil)
                    actionSheet.add(action: cancel)
                    actionSheet.add(action: CDAlertViewAction(title: "Open", font: UIFont.boldSystemFont(ofSize: 16), textColor: Constants.Colors.redApp, backgroundColor: Constants.Colors.mediumApp, handler: {_ in
                        let url = URL(string: song.deezer!.url)
                        if UIApplication.shared.canOpenURL(url!)
                        {
                            UIApplication.shared.open(url!, options: [:], completionHandler: nil)
                        } else {
                            //redirect to safari because the user doesn't have Instagram
                                UIApplication.shared.open(URL(string: "http://deezer.com/")!, options: [:], completionHandler: nil)
                        }
                        return true
                    }))
                    NotificationCenter.default.post(name: OpenTheAlertNotify, object: actionSheet)
                case is AlbumData:
                    let album = content as! AlbumData
                    let alerticon = UIImage(named: "deezerlogo")!.withTintColor(.white)
                    let actionSheet = CDAlertView(title: "Open \(album.name) in Deezer?", message: "If you don't have Deezer, \(album.name) will open in Safari.", type: .custom(image: alerticon))
                    actionSheet.alertBackgroundColor = Constants.Colors.mediumApp
                    actionSheet.circleFillColor = .black
                    actionSheet.titleTextColor = .white
                    actionSheet.messageTextColor = .white
                    let cancel = CDAlertViewAction(title: "Cancel", font: UIFont.systemFont(ofSize: 16), textColor: Constants.Colors.redApp, backgroundColor: Constants.Colors.mediumApp, handler: nil)
                    actionSheet.add(action: cancel)
                    actionSheet.add(action: CDAlertViewAction(title: "Open", font: UIFont.boldSystemFont(ofSize: 16), textColor: Constants.Colors.redApp, backgroundColor: Constants.Colors.mediumApp, handler: {_ in
                        let url = URL(string: album.deezer!.url)
                        if UIApplication.shared.canOpenURL(url!)
                        {
                            UIApplication.shared.open(url!, options: [:], completionHandler: nil)
                        } else {
                            //redirect to safari because the user doesn't have Instagram
                                UIApplication.shared.open(URL(string: "http://deezer.com/")!, options: [:], completionHandler: nil)
                        }
                        return true
                    }))
                    NotificationCenter.default.post(name: OpenTheAlertNotify, object: actionSheet)
                case is InstrumentalData:
                    let instrumental = content as! InstrumentalData
                    let alerticon = UIImage(named: "deezerlogo")!.withTintColor(.white)
                    let actionSheet = CDAlertView(title: "Open \(instrumental.instrumentalName) in Deezer?", message: "If you don't have Deezer, \(instrumental.instrumentalName) will open in Safari.", type: .custom(image: alerticon))
                    actionSheet.alertBackgroundColor = Constants.Colors.mediumApp
                    actionSheet.circleFillColor = .black
                    actionSheet.titleTextColor = .white
                    actionSheet.messageTextColor = .white
                    let cancel = CDAlertViewAction(title: "Cancel", font: UIFont.systemFont(ofSize: 16), textColor: Constants.Colors.redApp, backgroundColor: Constants.Colors.mediumApp, handler: nil)
                    actionSheet.add(action: cancel)
                    actionSheet.add(action: CDAlertViewAction(title: "Open", font: UIFont.boldSystemFont(ofSize: 16), textColor: Constants.Colors.redApp, backgroundColor: Constants.Colors.mediumApp, handler: {_ in
                        let url = URL(string: instrumental.deezer!.url)
                        if UIApplication.shared.canOpenURL(url!)
                        {
                            UIApplication.shared.open(url!, options: [:], completionHandler: nil)
                        } else {
                            //redirect to safari because the user doesn't have Instagram
                                UIApplication.shared.open(URL(string: "http://deezer.com/")!, options: [:], completionHandler: nil)
                        }
                        return true
                    }))
                    NotificationCenter.default.post(name: OpenTheAlertNotify, object: actionSheet)
                default:
                    print("nil")
                }
            case "soundcloud":
                switch content {
                case is SongData:
                    let song = content as! SongData
                    let alerticon = UIImage(named: "soundcloudalert")!.withTintColor(.white)
                    let actionSheet = CDAlertView(title: "Open \(song.name) in Soundcloud?", message: "If you don't have Soundcloud, \(song.name) will open in Safari.", type: .custom(image: alerticon))
                    actionSheet.alertBackgroundColor = Constants.Colors.mediumApp
                    actionSheet.circleFillColor = .black
                    actionSheet.titleTextColor = .white
                    actionSheet.messageTextColor = .white
                    let cancel = CDAlertViewAction(title: "Cancel", font: UIFont.systemFont(ofSize: 16), textColor: Constants.Colors.redApp, backgroundColor: Constants.Colors.mediumApp, handler: nil)
                    actionSheet.add(action: cancel)
                    actionSheet.add(action: CDAlertViewAction(title: "Open", font: UIFont.boldSystemFont(ofSize: 16), textColor: Constants.Colors.redApp, backgroundColor: Constants.Colors.mediumApp, handler: {_ in
                        let url = URL(string: song.soundcloud!.url)
                        if UIApplication.shared.canOpenURL(url!)
                        {
                            UIApplication.shared.open(url!, options: [:], completionHandler: nil)
                        } else {
                            //redirect to safari because the user doesn't have Instagram
                                UIApplication.shared.open(URL(string: "http://soundcloud.com/")!, options: [:], completionHandler: nil)
                        }
                        return true
                    }))
                    NotificationCenter.default.post(name: OpenTheAlertNotify, object: actionSheet)
                case is AlbumData:
                    let album = content as! AlbumData
                    let alerticon = UIImage(named: "soundcloudalert")!.withTintColor(.white)
                    let actionSheet = CDAlertView(title: "Open \(album.name) in Soundcloud?", message: "If you don't have Soundcloud, \(album.name) will open in Safari.", type: .custom(image: alerticon))
                    actionSheet.alertBackgroundColor = Constants.Colors.mediumApp
                    actionSheet.circleFillColor = .black
                    actionSheet.titleTextColor = .white
                    actionSheet.messageTextColor = .white
                    let cancel = CDAlertViewAction(title: "Cancel", font: UIFont.systemFont(ofSize: 16), textColor: Constants.Colors.redApp, backgroundColor: Constants.Colors.mediumApp, handler: nil)
                    actionSheet.add(action: cancel)
                    actionSheet.add(action: CDAlertViewAction(title: "Open", font: UIFont.boldSystemFont(ofSize: 16), textColor: Constants.Colors.redApp, backgroundColor: Constants.Colors.mediumApp, handler: {_ in
                        let url = URL(string: album.soundcloud!.url)
                        if UIApplication.shared.canOpenURL(url!)
                        {
                            UIApplication.shared.open(url!, options: [:], completionHandler: nil)
                        } else {
                            //redirect to safari because the user doesn't have Instagram
                                UIApplication.shared.open(URL(string: "http://soundcloud.com/")!, options: [:], completionHandler: nil)
                        }
                        return true
                    }))
                    NotificationCenter.default.post(name: OpenTheAlertNotify, object: actionSheet)
                case is InstrumentalData:
                    let instrumental = content as! InstrumentalData
                    let alerticon = UIImage(named: "soundcloudalert")!.withTintColor(.white)
                    let actionSheet = CDAlertView(title: "Open \(instrumental.instrumentalName) in Soundcloud?", message: "If you don't have Soundcloud, \(instrumental.instrumentalName) will open in Safari.", type: .custom(image: alerticon))
                    actionSheet.alertBackgroundColor = Constants.Colors.mediumApp
                    actionSheet.circleFillColor = .black
                    actionSheet.titleTextColor = .white
                    actionSheet.messageTextColor = .white
                    let cancel = CDAlertViewAction(title: "Cancel", font: UIFont.systemFont(ofSize: 16), textColor: Constants.Colors.redApp, backgroundColor: Constants.Colors.mediumApp, handler: nil)
                    actionSheet.add(action: cancel)
                    actionSheet.add(action: CDAlertViewAction(title: "Open", font: UIFont.boldSystemFont(ofSize: 16), textColor: Constants.Colors.redApp, backgroundColor: Constants.Colors.mediumApp, handler: {_ in
                        let url = URL(string: instrumental.soundcloud!.url)
                        if UIApplication.shared.canOpenURL(url!)
                        {
                            UIApplication.shared.open(url!, options: [:], completionHandler: nil)
                        } else {
                            //redirect to safari because the user doesn't have Instagram
                                UIApplication.shared.open(URL(string: "http://soundcloud.com/")!, options: [:], completionHandler: nil)
                        }
                        return true
                    }))
                    NotificationCenter.default.post(name: OpenTheAlertNotify, object: actionSheet)
                default:
                    print("nil")
                }
            case "napster":
                switch content {
                case is SongData:
                    let song = content as! SongData
                    let alerticon = UIImage(named: "napsterlogo")!.withTintColor(.white)
                    let actionSheet = CDAlertView(title: "Open \(song.name) in Napster?", message: "If you don't have Napster, \(song.name) will open in Safari.", type: .custom(image: alerticon))
                    actionSheet.alertBackgroundColor = Constants.Colors.mediumApp
                    actionSheet.circleFillColor = .black
                    actionSheet.titleTextColor = .white
                    actionSheet.messageTextColor = .white
                    let cancel = CDAlertViewAction(title: "Cancel", font: UIFont.systemFont(ofSize: 16), textColor: Constants.Colors.redApp, backgroundColor: Constants.Colors.mediumApp, handler: nil)
                    actionSheet.add(action: cancel)
                    actionSheet.add(action: CDAlertViewAction(title: "Open", font: UIFont.boldSystemFont(ofSize: 16), textColor: Constants.Colors.redApp, backgroundColor: Constants.Colors.mediumApp, handler: {_ in
                        let url = URL(string: song.napster!.url)
                        if UIApplication.shared.canOpenURL(url!)
                        {
                            UIApplication.shared.open(url!, options: [:], completionHandler: nil)
                        } else {
                            //redirect to safari because the user doesn't have Instagram
                                UIApplication.shared.open(URL(string: "http://napster.com/")!, options: [:], completionHandler: nil)
                        }
                        return true
                    }))
                    NotificationCenter.default.post(name: OpenTheAlertNotify, object: actionSheet)
                case is AlbumData:
                    let album = content as! AlbumData
                    let alerticon = UIImage(named: "napsterlogo")!.withTintColor(.white)
                    let actionSheet = CDAlertView(title: "Open \(album.name) in Napster?", message: "If you don't have Napster, \(album.name) will open in Safari.", type: .custom(image: alerticon))
                    actionSheet.alertBackgroundColor = Constants.Colors.mediumApp
                    actionSheet.circleFillColor = .black
                    actionSheet.titleTextColor = .white
                    actionSheet.messageTextColor = .white
                    let cancel = CDAlertViewAction(title: "Cancel", font: UIFont.systemFont(ofSize: 16), textColor: Constants.Colors.redApp, backgroundColor: Constants.Colors.mediumApp, handler: nil)
                    actionSheet.add(action: cancel)
                    actionSheet.add(action: CDAlertViewAction(title: "Open", font: UIFont.boldSystemFont(ofSize: 16), textColor: Constants.Colors.redApp, backgroundColor: Constants.Colors.mediumApp, handler: {_ in
                        let url = URL(string: album.napster!.url)
                        if UIApplication.shared.canOpenURL(url!)
                        {
                            UIApplication.shared.open(url!, options: [:], completionHandler: nil)
                        } else {
                            //redirect to safari because the user doesn't have Instagram
                                UIApplication.shared.open(URL(string: "http://napster.com/")!, options: [:], completionHandler: nil)
                        }
                        return true
                    }))
                    NotificationCenter.default.post(name: OpenTheAlertNotify, object: actionSheet)
                case is InstrumentalData:
                    let instrumental = content as! InstrumentalData
                    let alerticon = UIImage(named: "napsterlogo")!.withTintColor(.white)
                    let actionSheet = CDAlertView(title: "Open \(instrumental.instrumentalName) in Napster?", message: "If you don't have Napster, \(instrumental.instrumentalName) will open in Safari.", type: .custom(image: alerticon))
                    actionSheet.alertBackgroundColor = Constants.Colors.mediumApp
                    actionSheet.circleFillColor = .black
                    actionSheet.titleTextColor = .white
                    actionSheet.messageTextColor = .white
                    let cancel = CDAlertViewAction(title: "Cancel", font: UIFont.systemFont(ofSize: 16), textColor: Constants.Colors.redApp, backgroundColor: Constants.Colors.mediumApp, handler: nil)
                    actionSheet.add(action: cancel)
                    actionSheet.add(action: CDAlertViewAction(title: "Open", font: UIFont.boldSystemFont(ofSize: 16), textColor: Constants.Colors.redApp, backgroundColor: Constants.Colors.mediumApp, handler: {_ in
                        let url = URL(string: instrumental.napster!.url)
                        if UIApplication.shared.canOpenURL(url!)
                        {
                            UIApplication.shared.open(url!, options: [:], completionHandler: nil)
                        } else {
                            //redirect to safari because the user doesn't have Instagram
                                UIApplication.shared.open(URL(string: "http://napster.com/")!, options: [:], completionHandler: nil)
                        }
                        return true
                    }))
                    NotificationCenter.default.post(name: OpenTheAlertNotify, object: actionSheet)
                default:
                    print("nil")
                }
            case "spinrilla":
                switch content {
                case is SongData:
                    let song = content as! SongData
                    let alerticon = UIImage(named: "spinrillalogo")!.withTintColor(.white)
                    let actionSheet = CDAlertView(title: "Open \(song.name) in Spinrilla?", message: "If you don't have Spinrilla, \(song.name) will open in Safari.", type: .custom(image: alerticon))
                    actionSheet.alertBackgroundColor = Constants.Colors.mediumApp
                    actionSheet.circleFillColor = .black
                    actionSheet.titleTextColor = .white
                    actionSheet.messageTextColor = .white
                    let cancel = CDAlertViewAction(title: "Cancel", font: UIFont.systemFont(ofSize: 16), textColor: Constants.Colors.redApp, backgroundColor: Constants.Colors.mediumApp, handler: nil)
                    actionSheet.add(action: cancel)
                    actionSheet.add(action: CDAlertViewAction(title: "Open", font: UIFont.boldSystemFont(ofSize: 16), textColor: Constants.Colors.redApp, backgroundColor: Constants.Colors.mediumApp, handler: {_ in
                        let url = URL(string: song.spinrilla!.url)
                        if UIApplication.shared.canOpenURL(url!)
                        {
                            UIApplication.shared.open(url!, options: [:], completionHandler: nil)
                        } else {
                            //redirect to safari because the user doesn't have Instagram
                                UIApplication.shared.open(URL(string: "http://spinrilla.com/")!, options: [:], completionHandler: nil)
                        }
                        return true
                    }))
                    NotificationCenter.default.post(name: OpenTheAlertNotify, object: actionSheet)
                case is AlbumData:
                    let album = content as! AlbumData
                    let alerticon = UIImage(named: "spinrillalogo")!.withTintColor(.white)
                    let actionSheet = CDAlertView(title: "Open \(album.name) in Spinrilla?", message: "If you don't have Spinrilla, \(album.name) will open in Safari.", type: .custom(image: alerticon))
                    actionSheet.alertBackgroundColor = Constants.Colors.mediumApp
                    actionSheet.circleFillColor = .black
                    actionSheet.titleTextColor = .white
                    actionSheet.messageTextColor = .white
                    let cancel = CDAlertViewAction(title: "Cancel", font: UIFont.systemFont(ofSize: 16), textColor: Constants.Colors.redApp, backgroundColor: Constants.Colors.mediumApp, handler: nil)
                    actionSheet.add(action: cancel)
                    actionSheet.add(action: CDAlertViewAction(title: "Open", font: UIFont.boldSystemFont(ofSize: 16), textColor: Constants.Colors.redApp, backgroundColor: Constants.Colors.mediumApp, handler: {_ in
                        let url = URL(string: album.spinrilla!.url)
                        if UIApplication.shared.canOpenURL(url!)
                        {
                            UIApplication.shared.open(url!, options: [:], completionHandler: nil)
                        } else {
                            //redirect to safari because the user doesn't have Instagram
                                UIApplication.shared.open(URL(string: "http://spinrilla.com/")!, options: [:], completionHandler: nil)
                        }
                        return true
                    }))
                    NotificationCenter.default.post(name: OpenTheAlertNotify, object: actionSheet)
                case is InstrumentalData:
                    let instrumental = content as! InstrumentalData
                    let alerticon = UIImage(named: "spinrillalogo")!.withTintColor(.white)
                    let actionSheet = CDAlertView(title: "Open \(instrumental.instrumentalName) in Spinrilla?", message: "If you don't have Spinrilla, \(instrumental.instrumentalName) will open in Safari.", type: .custom(image: alerticon))
                    actionSheet.alertBackgroundColor = Constants.Colors.mediumApp
                    actionSheet.circleFillColor = .black
                    actionSheet.titleTextColor = .white
                    actionSheet.messageTextColor = .white
                    let cancel = CDAlertViewAction(title: "Cancel", font: UIFont.systemFont(ofSize: 16), textColor: Constants.Colors.redApp, backgroundColor: Constants.Colors.mediumApp, handler: nil)
                    actionSheet.add(action: cancel)
                    actionSheet.add(action: CDAlertViewAction(title: "Open", font: UIFont.boldSystemFont(ofSize: 16), textColor: Constants.Colors.redApp, backgroundColor: Constants.Colors.mediumApp, handler: {_ in
                        let url = URL(string: instrumental.spinrilla!.url)
                        if UIApplication.shared.canOpenURL(url!)
                        {
                            UIApplication.shared.open(url!, options: [:], completionHandler: nil)
                        } else {
                            //redirect to safari because the user doesn't have Instagram
                                UIApplication.shared.open(URL(string: "http://spinrilla.com/")!, options: [:], completionHandler: nil)
                        }
                        return true
                    }))
                    NotificationCenter.default.post(name: OpenTheAlertNotify, object: actionSheet)
                default:
                    print("nil")
                }
            case "tidal":
                switch content {
                case is SongData:
                    let song = content as! SongData
                    let alerticon = UIImage(named: "tidalalert")!.withTintColor(.white)
                    let actionSheet = CDAlertView(title: "Open \(song.name) in Tidal?", message: "If you don't have Tidal, \(song.name) will open in Safari.", type: .custom(image: alerticon))
                    actionSheet.alertBackgroundColor = Constants.Colors.mediumApp
                    actionSheet.circleFillColor = .black
                    actionSheet.titleTextColor = .white
                    actionSheet.messageTextColor = .white
                    let cancel = CDAlertViewAction(title: "Cancel", font: UIFont.systemFont(ofSize: 16), textColor: Constants.Colors.redApp, backgroundColor: Constants.Colors.mediumApp, handler: nil)
                    actionSheet.add(action: cancel)
                    actionSheet.add(action: CDAlertViewAction(title: "Open", font: UIFont.boldSystemFont(ofSize: 16), textColor: Constants.Colors.redApp, backgroundColor: Constants.Colors.mediumApp, handler: {_ in
                        let url = URL(string: song.tidal!.url)
                        if UIApplication.shared.canOpenURL(url!)
                        {
                            UIApplication.shared.open(url!, options: [:], completionHandler: nil)
                        } else {
                            //redirect to safari because the user doesn't have Instagram
                                UIApplication.shared.open(URL(string: "http://tidal.com/")!, options: [:], completionHandler: nil)
                        }
                        return true
                    }))
                    NotificationCenter.default.post(name: OpenTheAlertNotify, object: actionSheet)
                case is AlbumData:
                    let album = content as! AlbumData
                    let alerticon = UIImage(named: "tidalalert")!.withTintColor(.white)
                    let actionSheet = CDAlertView(title: "Open \(album.name) in Tidal?", message: "If you don't have Tidal, \(album.name) will open in Safari.", type: .custom(image: alerticon))
                    actionSheet.alertBackgroundColor = Constants.Colors.mediumApp
                    actionSheet.circleFillColor = .black
                    actionSheet.titleTextColor = .white
                    actionSheet.messageTextColor = .white
                    let cancel = CDAlertViewAction(title: "Cancel", font: UIFont.systemFont(ofSize: 16), textColor: Constants.Colors.redApp, backgroundColor: Constants.Colors.mediumApp, handler: nil)
                    actionSheet.add(action: cancel)
                    actionSheet.add(action: CDAlertViewAction(title: "Open", font: UIFont.boldSystemFont(ofSize: 16), textColor: Constants.Colors.redApp, backgroundColor: Constants.Colors.mediumApp, handler: {_ in
                        let url = URL(string: album.tidal!.url)
                        if UIApplication.shared.canOpenURL(url!)
                        {
                            UIApplication.shared.open(url!, options: [:], completionHandler: nil)
                        } else {
                            //redirect to safari because the user doesn't have Instagram
                                UIApplication.shared.open(URL(string: "http://tidal.com/")!, options: [:], completionHandler: nil)
                        }
                        return true
                    }))
                    NotificationCenter.default.post(name: OpenTheAlertNotify, object: actionSheet)
                case is InstrumentalData:
                    let instrumental = content as! InstrumentalData
                    let alerticon = UIImage(named: "tidalalert")!.withTintColor(.white)
                    let actionSheet = CDAlertView(title: "Open \(instrumental.instrumentalName) in Tidal?", message: "If you don't have Tidal, \(instrumental.instrumentalName) will open in Safari.", type: .custom(image: alerticon))
                    actionSheet.alertBackgroundColor = Constants.Colors.mediumApp
                    actionSheet.circleFillColor = .black
                    actionSheet.titleTextColor = .white
                    actionSheet.messageTextColor = .white
                    let cancel = CDAlertViewAction(title: "Cancel", font: UIFont.systemFont(ofSize: 16), textColor: Constants.Colors.redApp, backgroundColor: Constants.Colors.mediumApp, handler: nil)
                    actionSheet.add(action: cancel)
                    actionSheet.add(action: CDAlertViewAction(title: "Open", font: UIFont.boldSystemFont(ofSize: 16), textColor: Constants.Colors.redApp, backgroundColor: Constants.Colors.mediumApp, handler: {_ in
                        let url = URL(string: instrumental.tidal!.url)
                        if UIApplication.shared.canOpenURL(url!)
                        {
                            UIApplication.shared.open(url!, options: [:], completionHandler: nil)
                        } else {
                            //redirect to safari because the user doesn't have Instagram
                                UIApplication.shared.open(URL(string: "http://tidal.com/")!, options: [:], completionHandler: nil)
                        }
                        return true
                    }))
                    NotificationCenter.default.post(name: OpenTheAlertNotify, object: actionSheet)
                default:
                    print("nil")
                }
            default:
                print("jahfdgjs")
            }
        default:
            switch indexPath.section {
            case 0:
                let artist = data[indexPath.section][indexPath.row] as! ArtistData
                artistInfo = artist
                performSegue(withIdentifier: "infoToArt", sender: nil)
            case 1:
                let producer = data[indexPath.section][indexPath.row] as! ProducerData
                producerInfo = producer
                performSegue(withIdentifier: "infoToPro", sender: nil)
            case 6:
                let merch = data[indexPath.section][indexPath.row] as! MerchData
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
                performSegue(withIdentifier: "infoToProductInfo", sender: nil)
            case 7:
                let song = data[indexPath.section][indexPath.row] as! SongData
                infoDetailContent = song
                performSegue(withIdentifier: "infoToInfo", sender: nil)
            case 8:
                let video = data[indexPath.section][indexPath.row] as! VideoData
                infoDetailContent = video
                performSegue(withIdentifier: "infoToInfo", sender: nil)
            case 9:
                let album = data[indexPath.section][indexPath.row] as! AlbumData
                infoDetailContent = album
                performSegue(withIdentifier: "infoToInfo", sender: nil)
            default:
                let instrumental = data[indexPath.section][indexPath.row] as! InstrumentalData
                infoDetailContent = instrumental
                performSegue(withIdentifier: "infoToInfo", sender: nil)
            }
        }
    }
}

class InfoDetailTableView: UITableView {
    override var intrinsicContentSize: CGSize {
        layoutIfNeeded()
        return CGSize(width: UIView.noIntrinsicMetric, height: contentSize.height)
    }
}

class InfoDetailTableCell: UITableViewCell {
    
    @IBOutlet weak var name: MarqueeLabel!
    @IBOutlet weak var artwork: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        artwork.layer.cornerRadius = 5
    }
    
    override func prepareForReuse() {
        name.text = ""
        artwork.image = nil
        artwork.layer.cornerRadius = 5
        artwork.backgroundColor = .clear
    }
    
    func funcSetTemp(song: SongData) {
        name.text = song.name
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
    }
    func funcSetTemp(person: PersonData) {
        name.text = person.name
        artwork.layer.cornerRadius = 30
        GlobalFunctions.shared.selectImageURL(person: person, completion: {[weak self] aimage in
            guard let strongSelf = self else {return}
            guard let imge = aimage else {
                strongSelf.artwork.image = UIImage(named: "tonedeaflogo")
                return
            }
            if let url = URL.init(string: imge) {
                if let cachedImage = imageCache.object(forKey: url.absoluteString as NSString) {
                    strongSelf.artwork.image = cachedImage
                } else {
                    strongSelf.artwork.setImage(from: url, withPlaceholder: UIImage(named: "tonedeaflogo"))
                }
            }
            
        })
    }
    func funcSetTemp(artist: ArtistData) {
        name.text = artist.name
        artwork.layer.cornerRadius = 30
        var imageurl = ""
        if artist.spotifyProfileImageURL != "" {
            imageurl = artist.spotifyProfileImageURL
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
        name.text = producer.name
        artwork.layer.cornerRadius = 30
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
    func funcSetTemp(album: AlbumData) {
        name.text = album.name
        GlobalFunctions.shared.selectImageURL(album: album, completion: {[weak self] aimage in
            guard let strongSelf = self else {return}
            guard let imge = aimage else {
                strongSelf.artwork.image = UIImage(named: "tonedeaflogo")
                return
            }
            if let url = URL.init(string: imge) {
                if let cachedImage = imageCache.object(forKey: url.absoluteString as NSString) {
                    strongSelf.artwork.image = cachedImage
                } else {
                    strongSelf.artwork.setImage(from: url, withPlaceholder: UIImage(named: "tonedeaflogo"))
                }
            }
        })
    }
    func funcSetTemp(beat: BeatData) {
        name.text = beat.name
        let imageurl = beat.imageURL
        if let url = URL.init(string: imageurl) {
            if let cachedImage = imageCache.object(forKey: url.absoluteString as NSString) {
                artwork.image = cachedImage
            } else {
                artwork.setImage(from: url, withPlaceholder: UIImage(named: "tonedeaflogo"))
            }
        }
    }
    func funcSetTemp(instrumental: InstrumentalData) {
        name.text = instrumental.instrumentalName
        let imageurl = "instrumental.imageURL"
        if let url = URL.init(string: imageurl) {
            if let cachedImage = imageCache.object(forKey: url.absoluteString as NSString) {
                artwork.image = cachedImage
            } else {
                artwork.setImage(from: url, withPlaceholder: UIImage(named: "tonedeaflogo"))
            }
        }
    }
    func funcSetTemp(merch: MerchData) {
        artwork.layer.cornerRadius = 5
        if let mer = merch.kit {
            name.text = mer.name
            let imageurl = mer.imageURLs[0]
            if let url = URL.init(string: imageurl) {
                if let cachedImage = imageCache.object(forKey: url.absoluteString as NSString) {
                    artwork.image = cachedImage
                } else {
                    artwork.setImage(from: url, withPlaceholder: UIImage(named: "tonedeaflogo"))
                }
            }
        } else if let mer = merch.apperal {
            name.text = mer.name
            let imageurl = mer.imageURLs[0]
            if let url = URL.init(string: imageurl) {
                if let cachedImage = imageCache.object(forKey: url.absoluteString as NSString) {
                    artwork.image = cachedImage
                } else {
                    artwork.setImage(from: url, withPlaceholder: UIImage(named: "tonedeaflogo"))
                }
            }
        } else if let mer = merch.service {
            artwork.backgroundColor = .white
            name.text = mer.name
            let image = UIImage(named: "lego")
            artwork.image = image
        } else if let mer = merch.memorabilia {
            name.text = mer.name
            let imageurl = mer.imageURLs[0]
            if let url = URL.init(string: imageurl) {
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
                    strongSelf.name.text = instrumental.instrumentalName
                    let imageurl = "instrumental.imageURL"
                    if let url = URL.init(string: imageurl) {
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
    
}

class InfoVideoDetailTableCell: UITableViewCell {
    
    @IBOutlet weak var videoTitle: UILabel!
    @IBOutlet weak var thumbnail: UIImageView!
    
    override func prepareForReuse() {
        videoTitle.text = ""
        thumbnail.image = nil
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        thumbnail.layer.cornerRadius = 5
    }
    
    func funcSetTemp(video: VideoData) {
        videoTitle.text = video.title
        GlobalFunctions.shared.selectImageURL(video: video, completion: {[weak self] aimage in
            guard let strongSelf = self else {return}
            guard let imge = aimage else {
                strongSelf.thumbnail.image = UIImage(named: "tonedeaflogo")
                return
            }
            if let url = URL.init(string: imge) {
                if let cachedImage = imageCache.object(forKey: url.absoluteString as NSString) {
                    strongSelf.thumbnail.image = cachedImage
                } else {
                    strongSelf.thumbnail.setImage(from: url, withPlaceholder: UIImage(named: "tonedeaflogo"))
                }
            }
        })
        
    }
    
}

class InfoViewNowTableView: UITableView {
    override var intrinsicContentSize: CGSize {
        layoutIfNeeded()
        return CGSize(width: UIView.noIntrinsicMetric, height: contentSize.height)
    }
}

class InfoViewNowTableCell: UITableViewCell {
    
    @IBOutlet weak var serviceLogo: UIImageView!
    @IBOutlet weak var viewOnService: MarqueeLabel!
    @IBOutlet weak var sellPrice: MarqueeLabel!
    
    override func prepareForReuse() {
        viewOnService.text = ""
        sellPrice.text = ""
        serviceLogo.image = nil
        serviceLogo.layer.cornerRadius = 0
    }
    
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func funcSetTemp(apple: String) {
        sellPrice.isHidden = true
        viewOnService.text = "Stream on Apple Music"
        serviceLogo.image = UIImage(named: "appleMusicIcon")
    }
    func funcSetTemp(spotify: String) {
        sellPrice.isHidden = true
        viewOnService.text = "Stream on Spotify"
        serviceLogo.image = UIImage(named: "SpotifyIcon")
    }
    func funcSetTemp(ytad: String) {
        sellPrice.isHidden = true
        viewOnService.text = "Listen on YouTube"
        serviceLogo.image = UIImage(named: "youtubeLogo")
    }
    func funcSetTemp(youtube: String) {
        sellPrice.isHidden = true
        viewOnService.text = "Watch on YouTube"
        serviceLogo.image = UIImage(named: "youtubeLogo")
    }
    func funcSetTemp(ytim: String) {
        sellPrice.isHidden = true
        viewOnService.text = "Listen on YouTube"
        serviceLogo.image = UIImage(named: "youtubeLogo")
    }
    func funcSetTemp(ytbt: String) {
        sellPrice.isHidden = true
        viewOnService.text = "Listen on YouTube"
        serviceLogo.image = UIImage(named: "youtubeLogo")
    }
    func funcSetTemp(soundcloud: String) {
        sellPrice.isHidden = true
        viewOnService.text = "Stream on Soundcloud"
        serviceLogo.image = UIImage(named: "soundcloudIcon")
    }
    func funcSetTemp(youtubemusic: String) {
        sellPrice.isHidden = true
        viewOnService.text = "Stream on Youtube Music"
        serviceLogo.image = UIImage(named: "youtubemusicappicon")
        serviceLogo.layer.cornerRadius = 5
    }
    func funcSetTemp(amazon: String) {
        sellPrice.isHidden = true
        viewOnService.text = "Stream on Amazon Music"
        serviceLogo.image = UIImage(named: "amazonmusicappicon")
        serviceLogo.layer.cornerRadius = 5
    }
    func funcSetTemp(deezer: String) {
        sellPrice.isHidden = true
        viewOnService.text = "Stream on Deezer"
        serviceLogo.image = UIImage(named: "deezerappicon")
        serviceLogo.layer.cornerRadius = 5
    }
    func funcSetTemp(spinrilla: String) {
        sellPrice.isHidden = true
        viewOnService.text = "Stream on Spinrilla"
        serviceLogo.image = UIImage(named: "spinrillaappicon")
        serviceLogo.layer.cornerRadius = 5
    }
    func funcSetTemp(napster: String) {
        sellPrice.isHidden = true
        viewOnService.text = "Stream on Napster"
        serviceLogo.image = UIImage(named: "napsterappicon")
        serviceLogo.layer.cornerRadius = 5
    }
    func funcSetTemp(tidal: String) {
        sellPrice.isHidden = true
        viewOnService.text = "Stream on Tidal"
        serviceLogo.image = UIImage(named: "tidalappicon")
        serviceLogo.layer.cornerRadius = 5
    }
}

