//
//  ProducerInfoViewController.swift
//  ToneDeafDeafinitionsApp
//
//  Created by Tone Deaf on 9/6/20.
//  Copyright © 2020 GITEM Solutions. All rights reserved.
//
import UIKit
import SkeletonView
import MarqueeLabel
import PopOverMenu

var producerInfoViewController: ProducerInfoViewController!
class ProducerInfoViewController: UIViewController {
    
    static let shared = ProducerInfoViewController()
    
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    
    var lastContentOffset: CGFloat = 250.0
    let maxHeaderHeight: CGFloat = 250.0
    @IBOutlet weak var beatTableViewHeight: NSLayoutConstraint!
    @IBOutlet weak var instrumentalTableViewHeight: NSLayoutConstraint!
    
    var infoDetailContent:Any!
    
    @IBOutlet weak var scrollview: UIScrollView!
    @IBOutlet weak var headerImage: UIView!
    @IBOutlet weak var producerImage: UIImageView!
    @IBOutlet weak var producerName: UILabel!
    @IBOutlet weak var numberOfSongsWithToneLabel: UILabel!
    @IBOutlet weak var followButton: UIButton!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var songsHeaderLabel: UILabel!
    @IBOutlet weak var numberOfSongs: UILabel!
    @IBOutlet weak var numberOfVideos: UILabel!
    @IBOutlet weak var numberOfAlbums: UILabel!
    @IBOutlet weak var numberOfBeats: UILabel!
    @IBOutlet weak var numberOfInstrumentals: UILabel!
    
    var intrshuffleArrDashboard:[InstrumentalData] = []
    var beatshuffleArrDashboard:[BeatData] = []
    var intrshuffleArrMusic:[InstrumentalData] = []
    var beatshuffleArrMusic:[BeatData] = []
    var intrshuffleArr:[InstrumentalData] = []
    var beatshuffleArr:[BeatData] = []
    
    @IBOutlet weak var songTitleStack: UIStackView!
    @IBOutlet weak var videosTitleStack: UIStackView!
    @IBOutlet weak var albumsTitleStack: UIStackView!
    //@IBOutlet weak var albumsCountStack: UIStackView!
    @IBOutlet weak var beatsTitleStack: UIStackView!
    @IBOutlet weak var instrumentalsTitleStack: UIStackView!
    @IBOutlet weak var seeAllBeatsStack: UIStackView!
    
    @IBOutlet weak var seeAllInstrumentalsStack: UIStackView!
    
    
    @IBOutlet weak var producerVideosWithToneTableView: UITableView!
    @IBOutlet weak var producerSongsWithToneTableView: UITableView!
    @IBOutlet weak var producerAlbumsWithToneTableView: UITableView!
    @IBOutlet weak var producerBeatsWithToneTableView: UITableView!
    @IBOutlet weak var producerInstrumentalsWithToneTableView: UITableView!
    var musicTableHeight:CGFloat = 400
    var skelvar = 0
    var initialLoad = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "dots copy"), style: .plain, target: self, action: #selector(moreButtonTapped))
            ProducerSongsWithToneAllArray = []
            ProducerVideosWithToneAllArray = []
            ProducerAlbumsWithToneAllArray = []
            ProducerBeatsWithToneAllArray = []
            ProducerInstrumentalsWithToneFiveArray = []
            beatshuffleArr = []
            intrshuffleArr = []
        scrollview.delegate = self
        searchBar.delegate = self
        producerSongsWithToneTableView.delegate = self
        producerSongsWithToneTableView.dataSource = self
        producerVideosWithToneTableView.delegate = self
        producerVideosWithToneTableView.dataSource = self
        producerAlbumsWithToneTableView.delegate = self
        producerAlbumsWithToneTableView.dataSource = self
        producerBeatsWithToneTableView.delegate = self
        producerBeatsWithToneTableView.dataSource = self
        producerInstrumentalsWithToneTableView.delegate = self
        producerInstrumentalsWithToneTableView.dataSource = self
        skelvar = 0
        dismissKeyboardOnTap()
            recieved(notification: nil)
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
            self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationController?.navigationItem.largeTitleDisplayMode = .never
        self.navigationController?.navigationBar.prefersLargeTitles = false
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        createObserbvers()
    }
    
    deinit {
        print("📗 Producer Info being deallocated from memory. OS reclaiming")
        NotificationCenter.default.removeObserver(self)
    }
    
    func createObserbvers() {
        NotificationCenter.default.removeObserver(self)
        NotificationCenter.default.addObserver(self, selector: #selector(seg), name: ProToInfoSegNotify, object: nil)
    }
    
    @objc func recieved(notification: Notification?) {
        setUpPageDisplays()
        let queue = DispatchQueue(label: "myproinfoQueue")
        let group = DispatchGroup()
        let array = [1, 2,3,4,5]
        for i in array {
            //print("i = \(i)")
            group.enter()
            queue.async { [weak self] in
                guard let strongSelf = self else {return}
                switch i {
                case 1:
                    //print("null")
                    strongSelf.setProducerSongsInfo(completion: {
                        DispatchQueue.main.async {
                            strongSelf.producerSongsWithToneTableView.reloadData()
                        }
                        print("done \(i)")
                        group.leave()
                    })
                case 2:
                    print("null")
                    strongSelf.setProducerVideosInfo(completion: {
                        DispatchQueue.main.async {
                            strongSelf.producerVideosWithToneTableView.reloadData()
                        }
                        print("done \(i)")
                        group.leave()
                    })
                case 3:
                    print("null")
                    strongSelf.setProducerAlbumsInfo(completion: {
                        DispatchQueue.main.async {
                            strongSelf.producerAlbumsWithToneTableView.reloadData()
                        }
                        print("done \(i)")
                        group.leave()
                    })
                case 4:
                    print("null")
                    strongSelf.setProducerBeatsInfo(completion: {
                        DispatchQueue.main.async {
                            strongSelf.producerBeatsWithToneTableView.reloadData()
                        }
                        print("done \(i)")
                        group.leave()
                    })
                case 5:
                    print("null")
                    strongSelf.setProducerInstrumentalsInfo(completion: {
                        DispatchQueue.main.async {
                            strongSelf.producerInstrumentalsWithToneTableView.reloadData()
                            
                        }
                        print("done \(i)")
                        group.leave()
                    })
                default:
                    print("error")
                }
            }
        }
        group.notify(queue: DispatchQueue.main) {[weak self] in
            guard let strongSelf = self else {return}
            strongSelf.producerSongsWithToneTableView.reloadData()
            strongSelf.producerVideosWithToneTableView.reloadData()
            strongSelf.producerAlbumsWithToneTableView.reloadData()
            strongSelf.producerBeatsWithToneTableView.reloadData()
            strongSelf.producerInstrumentalsWithToneTableView.reloadData()
            strongSelf.initialLoad = true
        }
    }
    
    func setUpPageDisplays() {
        headerImage.layer.cornerRadius = 7
        followButton.layer.cornerRadius = 7
        producerImage.layer.cornerRadius = 45
        producerImage.contentMode = .scaleAspectFill
        ProducerSongsWithToneAllArray = []
        ProducerVideosWithToneAllArray = []
        ProducerAlbumsWithToneAllArray = []
        if let url = URL.init(string: recievedProducerData.spotifyProfileImageURL) {
            if let cachedImage = imageCache.object(forKey: url.absoluteString as NSString) {
                producerImage.image = cachedImage
            } else {
                producerImage.setImage(from: url, withPlaceholder: UIImage(named: "tonedeaflogo"))
            }
            blurredBackground(url: url)
            
        }
        //self.navigationItem.title = recievedProducerData.name
        producerName.text = recievedProducerData.name
        numberOfSongsWithToneLabel.text = String(recievedProducerData.songs.count)
        if recievedProducerData.songs.count == 1 {
            songsHeaderLabel.text = "Song"
        }
    }
    
    func setProducerSongsInfo(completion: @escaping () -> Void) {
            var dab = 0
            ProducerSongsWithToneAllArrayDashboard = []
            if recievedProducerData.videos.isEmpty || recievedProducerData.videos[0] == "" {
                DispatchQueue.main.async { [weak self] in
                    guard let strongSelf = self else {return}
                    strongSelf.songTitleStack.isHidden = true
                    strongSelf.producerSongsWithToneTableView.isHidden = true
                }
                completion()
                return
            }
            for idss in recievedProducerData.songs {
                let word = idss.split(separator: "Æ")
                let id = word[0]
                DatabaseManager.shared.findSongById(songId: String(id), completion: { [weak self] result in
                    guard let strongSelf = self else {return}
                    switch result {
                    case .success(let song):
                        ProducerSongsWithToneAllArray.append(song)
                        dab+=1
                        print("dab = \(dab)")
                        print("soung count = \(recievedProducerData.songs.count)")
                        
                        if dab == recievedProducerData.songs.count {
                            
                            searchedProducerSongsWithToneAllArray = ProducerSongsWithToneAllArray
                            strongSelf.numberOfSongs.text = String(ProducerSongsWithToneAllArray.count)
                            strongSelf.hideskeleton(tableview: strongSelf.producerSongsWithToneTableView)
                            completion()
                        }
                    case .failure(let error):
                        
                        print("Song ID proccessing error \(error)")
                    }
                })
            }
    }
    
    func setProducerVideosInfo(completion: @escaping () -> Void) {
            var dab = 0
            ProducerVideosWithToneAllArray = []
            
            if recievedProducerData.videos.isEmpty || recievedProducerData.videos[0] == "" {
                DispatchQueue.main.async { [weak self] in
                    guard let strongSelf = self else {return}
                    strongSelf.videosTitleStack.isHidden = true
                    strongSelf.producerVideosWithToneTableView.isHidden = true
                }
                completion()
                return
            }
            
            for idss in recievedProducerData.videos {
                let word = idss.split(separator: "Æ")
                let id = word[0]
                DatabaseManager.shared.findVideoById(videoid: String(id), completion: { [weak self] result in
                    guard let strongSelf = self else {return}
                    //print(dab, result)
                    switch result {
                    case .success(let vid):
                        switch vid {
                        case is YouTubeData:
                            let video = vid as! YouTubeData
                            ProducerVideosWithToneAllArray.append(video)
                            dab+=1
                            //print(dab, video.title)
                            if dab == recievedProducerData.videos.count {
                                searchedProducerVideosWithToneAllArray = ProducerVideosWithToneAllArray
                                strongSelf.numberOfVideos.text = String(ProducerVideosWithToneAllArray.count)
                                strongSelf.hideskeleton(tableview: strongSelf.producerVideosWithToneTableView)
                                completion()
                            }
                        default:
                            fatalError("Not Youtube")
                        }
                    case .failure(let error):
                        dab+=1
                        print("Video ID proccessing error \(error)")
                    }
                })
            }
        
    }
    
    func setProducerAlbumsInfo(completion: @escaping () -> Void) {
            var dab = 0
            ProducerAlbumsWithToneAllArray = []
            if recievedProducerData.albums.isEmpty || recievedProducerData.albums[0] == "" {
                DispatchQueue.main.async { [weak self] in
                    guard let strongSelf = self else {return}
                    strongSelf.albumsTitleStack.isHidden = true
                    strongSelf.producerAlbumsWithToneTableView.isHidden = true
                }
                completion()
                return
            }
            for idss in recievedProducerData.albums {
                let word = idss.split(separator: "Æ")
                let id = word[0]
                DatabaseManager.shared.findAlbumById(albumId: String(id), completion: { [weak self] result in
                    guard let strongSelf = self else {return}
                    switch result {
                    case .success(let song):
                        ProducerAlbumsWithToneAllArray.append(song)
                        dab+=1
                        //print("dab = \(dab)")
                        //print("album count = \(ProducerAlbumsWithToneAllArrayDashboard.count)")
                        if dab == recievedProducerData.albums.count {
                            searchedProducerAlbumsWithToneAllArray = ProducerAlbumsWithToneAllArray
                            strongSelf.numberOfAlbums.text = String(ProducerAlbumsWithToneAllArray.count)
                            strongSelf.hideskeleton(tableview: strongSelf.producerAlbumsWithToneTableView)
                            completion()
                        }
                    case .failure(let error):
                        print("Song ID proccessing error \(error)")
                    }
                })
            }
        
    }
    
    func setProducerBeatsInfo(completion: @escaping () -> Void) {
            if recievedProducerData.beats.isEmpty || recievedProducerData.beats[0] == "" {
                DispatchQueue.main.async { [weak self] in
                    guard let strongSelf = self else {return}
                    strongSelf.beatsTitleStack.isHidden = true
                    strongSelf.producerBeatsWithToneTableView.isHidden = true
                }
                completion()
                return
            }
            var dab = 0
            var shuffleArr = recievedProducerData.beats
            shuffleArr.shuffle()
            var shuffMax = shuffleArr.count-1
            if shuffleArr.count-1 >= 5 {
                shuffMax = 5
            }
            for idss in recievedProducerData.beats {
                let word = idss.split(separator: "Æ")
                let id = word[0]
                DatabaseManager.shared.findBeatById(beatId: String(id), completion: { [weak self] result in
                    guard let strongSelf = self else {return}
                    switch result {
                    case .success(let song):
                        if !strongSelf.beatshuffleArr.contains(song) {
                            strongSelf.beatshuffleArr.append(song)
                        }
                    case .failure(let error):
                        dab+=1
                        print("Album ID proccessing error \(error)")
                    }
                })
            }
            ProducerBeatsWithToneAllArray = []
            for idss in shuffleArr[0..<shuffMax] {
                let word = idss.split(separator: "Æ")
                let id = word[0]
                DatabaseManager.shared.findBeatById(beatId: String(id), completion: { [weak self] result in
                    guard let strongSelf = self else {return}
                    switch result {
                    case .success(let song):
                        if !ProducerBeatsWithToneAllArray.contains(song) {
                            ProducerBeatsWithToneAllArray.append(song)
                        }
                        dab+=1
                        var stopper = 5
                        if shuffMax < 5 {
                            stopper = shuffMax+1
                        }
                        if dab == stopper {
                            var newArray:[BeatData] = []
                            for beat in ProducerBeatsWithToneAllArray {
                                if accountType != "Creator" {
                                    if beat.priceType == "Free" {
                                        newArray.append(beat)
                                    }
                                }
                                else {
                                    newArray = ProducerBeatsWithToneAllArray
                                }
                            }
                            ProducerBeatsWithToneAllArray = newArray
                            ProducerBeatsWithToneAllArray.shuffle()
                            if ProducerBeatsWithToneAllArray.count < 5 {
                                if accountType == "Creator" {
                                    strongSelf.beatTableViewHeight.constant = CGFloat(ProducerBeatsWithToneAllArray.count)*130
                                    strongSelf.view.layoutSubviews()
                                    strongSelf.view.layoutIfNeeded()
                                } else if accountType == "Listener" {
                                    strongSelf.beatTableViewHeight.constant = CGFloat(ProducerBeatsWithToneAllArray.count)*120
                                    strongSelf.view.layoutSubviews()
                                    strongSelf.view.layoutIfNeeded()
                                } else {
                                    strongSelf.beatTableViewHeight.constant = CGFloat(ProducerBeatsWithToneAllArray.count)*80
                                    strongSelf.view.layoutSubviews()
                                    strongSelf.view.layoutIfNeeded()
                                }
                            } else {
                                if accountType == "Creator" {
                                    strongSelf.beatTableViewHeight.constant = 650
                                    strongSelf.view.layoutSubviews()
                                    strongSelf.view.layoutIfNeeded()
                                } else if accountType == "Listener" {
                                    strongSelf.beatTableViewHeight.constant = 600
                                    strongSelf.view.layoutSubviews()
                                    strongSelf.view.layoutIfNeeded()
                                } else {
                                    strongSelf.beatTableViewHeight.constant = 400
                                    strongSelf.view.layoutSubviews()
                                    strongSelf.view.layoutIfNeeded()
                                }
                            }
                            searchedProducerBeatsWithToneAllArray = ProducerBeatsWithToneAllArray
                            strongSelf.numberOfBeats.text = String(shuffleArr.count)
                            strongSelf.hideskeleton(tableview: strongSelf.producerBeatsWithToneTableView)
                            completion()
                        }
                    case .failure(let error):
                        dab+=1
                        print("Song ID proccessing error \(error)")
                    }
                })
            }
        
    }
    
    func setProducerInstrumentalsInfo(completion: @escaping () -> Void) {
            if recievedProducerData.instrumentals.isEmpty || recievedProducerData.instrumentals[0] == "" {
                DispatchQueue.main.async { [weak self] in
                    guard let strongSelf = self else {return}
                    strongSelf.instrumentalsTitleStack.isHidden = true
                    strongSelf.producerInstrumentalsWithToneTableView.isHidden = true
                }
                completion()
                return
            }
            var dab = 0
            var shuffleArr = recievedProducerData.instrumentals
            shuffleArr.shuffle()
            var shuffMax = shuffleArr.count-1
            if shuffleArr.count-1 >= 5 {
                shuffMax = 5
            }
            intrshuffleArr = []
            for idss in recievedProducerData.instrumentals {
                let word = idss.split(separator: "Æ")
                let id = word[0]
                DatabaseManager.shared.findInstrumentalById(instrumentalId: String(id), completion: { [weak self] result in
                    guard let strongSelf = self else {return}
                    switch result {
                    case .success(let song):
                        if !strongSelf.intrshuffleArr.contains(song) {
                            strongSelf.intrshuffleArr.append(song)
                        }
                    case .failure(let error):
                        dab+=1
                        print("Album ID proccessing error \(error)")
                    }
                })
            }
            
            ProducerInstrumentalsWithToneFiveArray = []
            for idss in shuffleArr[0..<shuffMax+1] {
                let word = idss.split(separator: "Æ")
                let id = word[0]
                DatabaseManager.shared.findInstrumentalById(instrumentalId: String(id), completion: { [weak self] result in
                    guard let strongSelf = self else {return}
                    switch result {
                    case .success(let song):
                        ProducerInstrumentalsWithToneFiveArray.append(song)
                        dab+=1

                        var stopper = 5
                        if shuffMax < 5 {
                            stopper = shuffMax+1
                        }
                        print("dab instrumental = \(dab) \(stopper) \(song.instrumentalName)")
                        if dab == stopper {
                            if ProducerInstrumentalsWithToneFiveArray.count < 5 {
                                strongSelf.instrumentalTableViewHeight.constant = CGFloat(ProducerInstrumentalsWithToneFiveArray.count)*80
                                strongSelf.view.layoutSubviews()
                                strongSelf.view.layoutIfNeeded()
                            } else {
                                strongSelf.instrumentalTableViewHeight.constant = 400
                                strongSelf.view.layoutSubviews()
                                strongSelf.view.layoutIfNeeded()
                            }
                            searchedProducerInstrumentalsWithToneAllArray = ProducerInstrumentalsWithToneFiveArray
                            strongSelf.numberOfInstrumentals.text = String(shuffleArr.count)
                            strongSelf.hideskeleton(tableview: strongSelf.producerInstrumentalsWithToneTableView)
                            completion()
                        }
                    case .failure(let error):
                        dab+=1
                        print("Song ID proccessing error \(error)")
                    }
                })
            }
        
    }
    
    func blurredBackground(url: URL) {
        let backgroundImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: headerImage.bounds.width, height: headerImage.bounds.height))
        headerImage.addSubview(backgroundImageView)
        backgroundImageView.contentMode = .scaleAspectFill
        backgroundImageView.layer.masksToBounds = true
        if let cachedImage = imageCache.object(forKey: url.absoluteString as NSString) {
            backgroundImageView.image = cachedImage
        } else {
            backgroundImageView.setImage(from: url, withPlaceholder: UIImage(named: "tonedeaflogo"))
        }
        
        headerImage.roundCorners(corners: [.topLeft,.topRight], radius: 10)
        backgroundImageView.roundCorners(corners: [.topLeft,.topRight], radius: 10)
        
        headerImage.sendSubviewToBack(backgroundImageView)
        
        let blur = UIBlurEffect(style: .dark)
        let blurView = UIVisualEffectView(effect: blur)
        blurView.frame = headerImage.bounds
        headerImage.addSubview(blurView)
        headerImage.sendSubviewToBack(blurView)
        headerImage.sendSubviewToBack(backgroundImageView)
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
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if skelvar == 0 {
            print("setting skeleton")
            producerSongsWithToneTableView.isSkeletonable = true
            producerSongsWithToneTableView.showAnimatedGradientSkeleton(usingGradient: .init(baseColor: UIColor.init(red: 22/255, green: 22/255, blue: 22/255, alpha: 1)), animation: nil, transition: .crossDissolve(0.25))
            producerVideosWithToneTableView.isSkeletonable = true
            producerVideosWithToneTableView.showAnimatedGradientSkeleton(usingGradient: .init(baseColor: UIColor.init(red: 22/255, green: 22/255, blue: 22/255, alpha: 1)), animation: nil, transition: .crossDissolve(0.25))
            producerAlbumsWithToneTableView.isSkeletonable = true
            producerAlbumsWithToneTableView.showAnimatedGradientSkeleton(usingGradient: .init(baseColor: UIColor.init(red: 22/255, green: 22/255, blue: 22/255, alpha: 1)), animation: nil, transition: .crossDissolve(0.25))
            producerBeatsWithToneTableView.isSkeletonable = true
            producerBeatsWithToneTableView.showAnimatedGradientSkeleton(usingGradient: .init(baseColor: UIColor.init(red: 22/255, green: 22/255, blue: 22/255, alpha: 1)), animation: nil, transition: .crossDissolve(0.25))
            producerInstrumentalsWithToneTableView.isSkeletonable = true
            producerInstrumentalsWithToneTableView.showAnimatedGradientSkeleton(usingGradient: .init(baseColor: UIColor.init(red: 22/255, green: 22/255, blue: 22/255, alpha: 1)), animation: nil, transition: .crossDissolve(0.25))
            
        }
        
        skelvar+=1
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    @IBAction func allInstrumentalsTapped(_ sender: Any) {
        performSegue(withIdentifier: "proToAllOf", sender: nil)
    }
    
    @IBAction func allBeatsTapped(_ sender: Any) {
        _ = tabBarController(self.tabBarController!, shouldSelect: (tabBarController?.viewControllers![2])!)
        tabBarController?.selectedIndex = 2
    }
    
    @objc func moreButtonTapped() {
        var height = 1
        if recievedProducerData.spotifyProfileURL != "" {
            height+=1
        }
        if recievedProducerData.appleProfileURL != "" {
            height+=1
        }
        if let _ = recievedProducerData.soundcloudProfileURL {
            height+=1
        }
        if let _ = recievedProducerData.youtubeMusicProfileURL {
            height+=1
        }
        if let _ = recievedProducerData.amazonProfileURL {
            height+=1
        }
        if recievedProducerData.deezerProfileURL != nil {
            height+=1
        }
        if recievedProducerData.spinrillaProfileURL != nil {
            height+=1
        }
        if recievedProducerData.napsterProfileURL != nil {
            height+=1
        }
        if recievedProducerData.tidalProfileURL != nil {
            height+=1
        }
        if recievedProducerData.instagramProfileURL != nil {
            height+=1
        }
        if recievedProducerData.facebookProfileURL != nil {
            height+=1
        }
        if recievedProducerData.twitterProfileURL != nil {
            height+=1
        }
        let high = height*50
        popOverIndicator = "pro"
        let vc: MorePopoverTableViewController = self.storyboard?.instantiateViewController(withIdentifier: "morePopoverTableViewController") as! MorePopoverTableViewController
                // Preferred Size
                vc.preferredContentSize = CGSize(width: 250, height: high)
                vc.modalPresentationStyle = .popover
                let popover: UIPopoverPresentationController = vc.popoverPresentationController!
                popover.delegate = self
                popover.sourceView = self.view
                // RightBarItem
        popover.barButtonItem = navigationItem.rightBarButtonItem
                present(vc, animated: true, completion:nil)
    }
    
    
    
    func transitionToYoutube() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc3 = storyboard.instantiateViewController(identifier: "youtubePlayerVC") as YoutubeVideoPlayerViewController
        self.present(vc3, animated: true, completion: nil)
        //self.navigationController?.pushViewController(vc3, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "proToInfo" {
            if let viewController: InfoDetailViewController = segue.destination as? InfoDetailViewController {
                NotificationCenter.default.removeObserver(self)
                viewController.content = infoDetailContent
            }
        }
        if segue.identifier == "proToAllOf" {
            if let viewController: AllOfContentTypeViewController = segue.destination as? AllOfContentTypeViewController {
                NotificationCenter.default.removeObserver(self)
                viewController.recievedData = "instrumental"
            }
        }
    }
    
    @objc func seg(notification: Notification) {
        infoDetailContent = notification.object
        performSegue(withIdentifier: "proToInfo", sender: nil)
    }
    
    func dismissKeyboardOnTap() {
        let tap = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        scrollview.keyboardDismissMode = .onDrag
    }
    
}

extension ProducerInfoViewController: UIPopoverPresentationControllerDelegate {
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
            return UIModalPresentationStyle.none
        }

        
        func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
            return UIModalPresentationStyle.none
        }
}

extension ProducerInfoViewController: UITabBarControllerDelegate {
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

extension ProducerInfoViewController: UIScrollViewDelegate {
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        if scrollView == producerAlbumsWithToneTableView {
            scrollView.isScrollEnabled = false
            scrollView.isPagingEnabled = true
            scrollView.showsVerticalScrollIndicator = false
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if (scrollView.contentOffset.y >= (scrollView.contentSize.height - scrollView.frame.size.height)) {
            //Scrolled to bottom
            if !(scrollView.contentOffset.y < self.lastContentOffset || scrollView.contentOffset.y <= 250) {
                
                followButton.alpha = 0
                UIView.animate(withDuration: 0.3) { [weak self] in
                    guard let strongSelf = self else {return}
                    strongSelf.heightConstraint.constant = 0.0
                    //strongSelf.followButton.alpha = 0
                    strongSelf.view.layoutIfNeeded()
                }
            }
        }
        else if (scrollView.contentOffset.y < self.lastContentOffset || scrollView.contentOffset.y <= 250) && (self.heightConstraint.constant != self.maxHeaderHeight)  {
            //Scrolling up, scrolled to top
            UIView.animate(withDuration: 0.3) { [weak self] in
                guard let strongSelf = self else {return}
                if scrollView.contentOffset.y <= 0.0 {
                    strongSelf.followButton.alpha = 1
                    strongSelf.heightConstraint.constant = strongSelf.maxHeaderHeight
                    strongSelf.view.layoutIfNeeded()
                }
            }
        }
        else if (scrollView.contentOffset.y > lastContentOffset) && heightConstraint.constant != 0 {
            //Scrolling down
            if !(scrollView.contentOffset.y < lastContentOffset || scrollView.contentOffset.y <= 0) {
                followButton.alpha = 0
                UIView.animate(withDuration: 0.3) { [weak self] in
                    guard let strongSelf = self else {return}
                    strongSelf.heightConstraint.constant = 0.0
                    strongSelf.view.layoutIfNeeded()
                }
            }
        }
        self.lastContentOffset = scrollView.contentOffset.y
    }
}

extension ProducerInfoViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
        searchBar.resignFirstResponder()
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
            followButton.alpha = 0
            UIView.animate(withDuration: 0.3) { [weak self] in
                guard let strongSelf = self else {return}
                strongSelf.heightConstraint.constant = 0.0
                strongSelf.view.layoutIfNeeded()
            }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchText == "" {
                searchedProducerSongsWithToneAllArray = ProducerSongsWithToneAllArray
                searchedProducerVideosWithToneAllArray = ProducerVideosWithToneAllArray
                searchedProducerAlbumsWithToneAllArray = ProducerAlbumsWithToneAllArray
                searchedProducerBeatsWithToneAllArray = ProducerBeatsWithToneAllArray
                searchedProducerInstrumentalsWithToneAllArray = ProducerInstrumentalsWithToneFiveArray
                producerSongsWithToneTableView.reloadData()
                producerVideosWithToneTableView.reloadData()
                producerAlbumsWithToneTableView.reloadData()
                producerBeatsWithToneTableView.reloadData()
                beatTableViewHeight.constant = producerBeatsWithToneTableView.contentSize.height
                producerInstrumentalsWithToneTableView.reloadData()
                instrumentalTableViewHeight.constant = producerInstrumentalsWithToneTableView.contentSize.height
                if searchedProducerSongsWithToneAllArray.count != 0 {
                    producerSongsWithToneTableView.isHidden = false
                    songTitleStack.isHidden = false
                    numberOfSongs.text = String(searchedProducerSongsWithToneAllArray.count)
                } else {
                    producerSongsWithToneTableView.isHidden = true
                    songTitleStack.isHidden = true
                }
                if searchedProducerVideosWithToneAllArray.count != 0 {
                    producerVideosWithToneTableView.isHidden = false
                    videosTitleStack.isHidden = false
                    numberOfVideos.text = String(searchedProducerVideosWithToneAllArray.count)
                } else {
                    producerVideosWithToneTableView.isHidden = true
                    videosTitleStack.isHidden = true
                }
                if searchedProducerAlbumsWithToneAllArray.count != 0 {
                    producerAlbumsWithToneTableView.isHidden = false
                    albumsTitleStack.isHidden = false
                    //albumsCountStack.isHidden = false
                    numberOfAlbums.text = String(searchedProducerAlbumsWithToneAllArray.count)
                } else {
                    producerAlbumsWithToneTableView.isHidden = true
                    albumsTitleStack.isHidden = true
                    //albumsCountStack.isHidden = true
                }
                if searchedProducerBeatsWithToneAllArray.count != 0 {
                    beatsTitleStack.isHidden = false
                    seeAllBeatsStack.isHidden = false
                    producerBeatsWithToneTableView.isHidden = false
                    numberOfBeats.text = String(recievedProducerData.beats.count)
                } else {
                    producerBeatsWithToneTableView.isHidden = true
                    beatsTitleStack.isHidden = true
                    seeAllBeatsStack.isHidden = true
                }
                if searchedProducerInstrumentalsWithToneAllArray.count != 0 {
                    instrumentalsTitleStack.isHidden = false
                    seeAllInstrumentalsStack.isHidden = false
                    producerInstrumentalsWithToneTableView.isHidden = false
                    numberOfInstrumentals.text = String(recievedProducerData.instrumentals.count)
                } else {
                    producerInstrumentalsWithToneTableView.isHidden = true
                    instrumentalsTitleStack.isHidden = true
                    seeAllInstrumentalsStack.isHidden = true
                }
                view.layoutSubviews()
            
            //filteredResultsLabel.isHidden = true
            //freeBeatTableView.reloadData()
        }
        else {
                searchedProducerSongsWithToneAllArray = []
                searchedProducerVideosWithToneAllArray = []
                searchedProducerAlbumsWithToneAllArray = []
                searchedProducerBeatsWithToneAllArray = []
                searchedProducerInstrumentalsWithToneAllArray = []
                
                for searchSongs in ProducerSongsWithToneAllArray {
                    if searchSongs.name.lowercased().trimmingCharacters(in: .whitespacesAndNewlines).contains(searchText.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)) {
                        searchedProducerSongsWithToneAllArray.append(searchSongs)
                    }
                    for art in searchSongs.songArtist {
                        let word = art.split(separator: "Æ")
                        let artist = word[1]
                        if String(artist).lowercased().trimmingCharacters(in: .whitespacesAndNewlines).contains(searchText.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)) {
                            if !searchedProducerSongsWithToneAllArray.contains(searchSongs) {
                            searchedProducerSongsWithToneAllArray.append(searchSongs)
                            }
                        }
                    }
                    if searchSongs.albums != [""] {
                        for alb in searchSongs.albums! {
                            let word = alb.split(separator: "Æ")
                            let album = word[1]
                            if String(album).lowercased().trimmingCharacters(in: .whitespacesAndNewlines).contains(searchText.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)) {
                                if !searchedProducerSongsWithToneAllArray.contains(searchSongs) {
                                searchedProducerSongsWithToneAllArray.append(searchSongs)
                                }
                            }
                        }
                    }
                    for pro in searchSongs.songProducers {
                        let word = pro.split(separator: "Æ")
                        let producer = word[1]
                        if String(producer).lowercased().trimmingCharacters(in: .whitespacesAndNewlines).contains(searchText.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)) {
                            if !searchedProducerSongsWithToneAllArray.contains(searchSongs) {
                            searchedProducerSongsWithToneAllArray.append(searchSongs)
                            }
                        }
                    }
                }
                for searchVideos in ProducerVideosWithToneAllArray {
                    var can = false
                    switch searchVideos {
                    case is YouTubeData:
                        let video = searchVideos as! YouTubeData
                        if video.title.lowercased().trimmingCharacters(in: .whitespacesAndNewlines).contains(searchText.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)) {
                            for vid in searchedProducerVideosWithToneAllArray {
                                switch vid {
                                case is YouTubeData:
                                    let vide = vid as! YouTubeData
                                    if vide.title == searchVideos.title {
                                        can = true
                                    }
                                default:
                                    print("blanca")
                                }
                            }
                            if can == false {
                                searchedProducerVideosWithToneAllArray.append(video)
                            }
                        }
//                        if video.albums != [""] {
//                            for alb in video.albums {
//                                let word = alb.split(separator: "Æ")
//                                let album = word[1]
//                                if String(album).lowercased().trimmingCharacters(in: .whitespacesAndNewlines).contains(searchText.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)) {
//                                    for vid in searchedProducerVideosWithToneAllArray {
//                                        switch vid {
//                                        case is YouTubeData:
//                                            let vide = vid as! YouTubeData
//                                            if vide.title == searchVideos.title {
//                                                can = true
//                                            }
//                                        default:
//                                            print("blanca")
//                                        }
//                                    }
//                                    if can == false {
//                                        searchedProducerVideosWithToneAllArray.append(video)
//                                    }
//                                }
//                            }
//                        }
//                        for art in video.artist {
//                            let word = art.split(separator: "Æ")
//                            let artist = word[1]
//                            if String(artist).lowercased().trimmingCharacters(in: .whitespacesAndNewlines).contains(searchText.lowercased().trimmingCharacters(in: .whitespacesAndNewlines))  {
//                                for vid in searchedProducerVideosWithToneAllArray {
//                                    switch vid {
//                                    case is YouTubeData:
//                                        let vide = vid as! YouTubeData
//                                        if vide.title == searchVideos.title {
//                                            can = true
//                                        }
//                                    default:
//                                        print("blanca")
//                                    }
//                                }
//                                if can == false {
//                                    searchedProducerVideosWithToneAllArray.append(video)
//                                }
//                            }
//                        }
//                        for pro in video.producers {
//                            let word = pro.split(separator: "Æ")
//                            let producer = word[1]
//                            if String(producer).lowercased().trimmingCharacters(in: .whitespacesAndNewlines).contains(searchText.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)) {
//                                for vid in searchedProducerVideosWithToneAllArray {
//                                    switch vid {
//                                    case is YouTubeData:
//                                        let vide = vid as! YouTubeData
//                                        if vide.title == searchVideos.title {
//                                            can = true
//                                        }
//                                    default:
//                                        print("blanca")
//                                    }
//                                }
//                                if can == false {
//                                    searchedProducerVideosWithToneAllArray.append(video)
//                                }
//                            }
//                        }
                        
                    default:
                        print("jhgcf")
                    }
                    
                }
//                for searchAlbums in ProducerAlbumsWithToneAllArray {
//                    let album = AlbumData(toneDeafAppId: searchAlbums.toneDeafAppId, instrumentals: searchAlbums.instrumentals, dateRegisteredToApp: searchAlbums.dateRegisteredToApp, timeRegisteredToApp: searchAlbums.timeRegisteredToApp, songs: searchAlbums.songs, videos: searchAlbums.videos, merch: searchAlbums.merch, name: searchAlbums.name, mainArtist: searchAlbums.mainArtist, allArtists: searchAlbums.allArtists, producers: searchAlbums.producers, isActive: searchAlbums.isActive, favoritesOverall: searchAlbums.favoritesOverall, numberofTracks: searchAlbums.numberofTracks, youtubeOfficialAlbumVideo: searchAlbums.youtubeOfficialAlbumVideo, youTubeAudioAlbumVideo: searchAlbums.youTubeAudioAlbumVideo, youtubeAltAlbumVideos: searchAlbums.youtubeAltAlbumVideos, spotifyData: searchAlbums.spotifyData, appleData: searchAlbums.appleData, soundcloudData: searchAlbums.soundcloudData, youtubeMusicData: searchAlbums.youtubeMusicData, amazonData: searchAlbums.amazonData, tidalData: searchAlbums.tidalData, deezerData: searchAlbums.deezerData, spinrillaData: searchAlbums.spinrillaData,napsterData: searchAlbums.napsterData)
//                    var newSongsDict:[String:String] = [:]
//                    if searchAlbums.name.lowercased().trimmingCharacters(in: .whitespacesAndNewlines).contains(searchText.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)) {
//                        searchedProducerAlbumsWithToneAllArray.append(searchAlbums)
//                    }
////                    for (num, track) in album.songs {
////                        let word = track.split(separator: "Æ")
////                        let name = word[1]
////                        if name.lowercased().trimmingCharacters(in: .whitespacesAndNewlines).contains(searchText.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)) {
////                            let mysongDict = [num:track]
////                            if newSongsDict == [:] {
////                                newSongsDict = mysongDict
////                            } else {
////                                newSongsDict.merge(mysongDict, uniquingKeysWith: +)
////                            }
////                            if newSongsDict != [:] {
////                                album.songs = newSongsDict
////                                if !searchedProducerAlbumsWithToneAllArray.contains(album) {
////                                    searchedProducerAlbumsWithToneAllArray.append(album)
////                                }
////                            }
////                        }
////                        //                        switch id.count {
////                        //                        case 12:
////                        //                            for instrumental in ProducerInstrumentalsWithToneFiveArrayDashboard {
////                        //                                if instrumental.toneDeafAppId == track {
////                        //                                    if instrumental.instrumentalName.lowercased().trimmingCharacters(in: .whitespacesAndNewlines).contains(searchText.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)) {
////                        //                                        let mysongDict = [num:track]
////                        //                                        if newSongsDict == [:] {
////                        //                                            newSongsDict = mysongDict
////                        //                                        } else {
////                        //                                            newSongsDict.merge(mysongDict, uniquingKeysWith: +)
////                        //                                        }
////                        //                                        if newSongsDict != [:] {
////                        //                                            album.songs = newSongsDict
////                        //                                            if !searchedProducerAlbumsWithToneAllArrayDashboard.contains(album) {
////                        //                                                searchedProducerAlbumsWithToneAllArrayDashboard.append(album)
////                        //                                            }
////                        //                                        }
////                        //                                    }
////                        //
////                        //                                    for pro in instrumental.songProducers {
////                        //                                        let word = pro.split(separator: "Æ")
////                        //                                        let producer = word[1]
////                        //                                        if String(producer).lowercased().trimmingCharacters(in: .whitespacesAndNewlines).contains(searchText.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)) {
////                        //                                            let mysongDict = [num:track]
////                        //                                            if newSongsDict == [:] {
////                        //                                                newSongsDict = mysongDict
////                        //                                            } else {
////                        //                                                newSongsDict.merge(mysongDict, uniquingKeysWith: +)
////                        //                                            }
////                        //                                            if newSongsDict != [:] {
////                        //                                                album.songs = newSongsDict
////                        //                                                if !searchedProducerAlbumsWithToneAllArrayDashboard.contains(album) {
////                        //                                                    searchedProducerAlbumsWithToneAllArrayDashboard.append(album)
////                        //                                                }
////                        //                                            }
////                        //                                        }
////                        //                                    }
////                        //                                    if !AllProducersInDatabaseArray.isEmpty {
////                        //                                        for pro in instrumental.songProducers {
////                        //                                            for producer in AllProducersInDatabaseArray {
////                        //                                                if pro == producer.toneDeafAppId {
////                        //                                                    if producer.name.lowercased().contains(searchText.lowercased()) {
////                        //                                                        let mysongDict = [num:track]
////                        //                                                        if newSongsDict == [:] {
////                        //                                                            newSongsDict = mysongDict
////                        //                                                        } else {
////                        //                                                            newSongsDict.merge(mysongDict, uniquingKeysWith: +)
////                        //                                                        }
////                        //                                                        if newSongsDict != [:] {
////                        //                                                            album.songs = newSongsDict
////                        //                                                            if !searchedProducerAlbumsWithToneAllArrayDashboard.contains(album) {
////                        //                                                                searchedProducerAlbumsWithToneAllArrayDashboard.append(album)
////                        //                                                            }
////                        //                                                        }
////                        //                                                    }
////                        //                                                }
////                        //                                            }
////                        //                                        }
////                        //                                    }
////                        //                                }
////                        //                            }
////                        //                        default:
////                        //                            for song in ProducerSongsWithToneAllArrayDashboard {
////                        //                                if song.toneDeafAppId == track {
////                        //                                    if song.name.lowercased().trimmingCharacters(in: .whitespacesAndNewlines).contains(searchText.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)) {
////                        //                                        let mysongDict = [num:track]
////                        //                                        if newSongsDict == [:] {
////                        //                                            newSongsDict = mysongDict
////                        //                                        } else {
////                        //                                            newSongsDict.merge(mysongDict, uniquingKeysWith: +)
////                        //                                        }
////                        //                                        if newSongsDict != [:] {
////                        //                                            album.songs = newSongsDict
////                        //                                            if !searchedProducerAlbumsWithToneAllArrayDashboard.contains(album) {
////                        //                                                searchedProducerAlbumsWithToneAllArrayDashboard.append(album)
////                        //                                            }
////                        //                                        }
////                        //                                    }
////                        //                                    if !AllArtistInDatabaseArray.isEmpty{
////                        //                                        for art in song.songArtist {
////                        //                                            for artist in AllArtistInDatabaseArray {
////                        //                                                if art == artist.toneDeafAppId {
////                        //                                                    if artist.name.lowercased().contains(searchText.lowercased()) {
////                        //
////                        //                                                        let mysongDict = [num:track]
////                        //                                                        if newSongsDict == [:] {
////                        //                                                            newSongsDict = mysongDict
////                        //                                                        } else {
////                        //                                                            newSongsDict.merge(mysongDict, uniquingKeysWith: +)
////                        //                                                        }
////                        //                                                        if newSongsDict != [:] {
////                        //                                                            album.songs = newSongsDict
////                        //                                                            if !searchedProducerAlbumsWithToneAllArrayDashboard.contains(album) {
////                        //                                                                searchedProducerAlbumsWithToneAllArrayDashboard.append(album)
////                        //                                                            }
////                        //
////                        //                                                        }
////                        //                                                    }
////                        //                                                }
////                        //                                            }
////                        //                                        }
////                        //                                    }
////                        //                                    if !AllProducersInDatabaseArray.isEmpty {
////                        //                                        for pro in song.songProducers {
////                        //                                            for producer in AllProducersInDatabaseArray {
////                        //                                                if pro == producer.toneDeafAppId {
////                        //                                                    if producer.name.lowercased().contains(searchText.lowercased()) {
////                        //                                                        let mysongDict = [num:track]
////                        //                                                        if newSongsDict == [:] {
////                        //                                                            newSongsDict = mysongDict
////                        //                                                        } else {
////                        //                                                            newSongsDict.merge(mysongDict, uniquingKeysWith: +)
////                        //                                                        }
////                        //                                                        if newSongsDict != [:] {
////                        //                                                            album.songs = newSongsDict
////                        //                                                            if !searchedProducerAlbumsWithToneAllArrayDashboard.contains(album) {
////                        //                                                                searchedProducerAlbumsWithToneAllArrayDashboard.append(album)
////                        //                                                            }
////                        //                                                        }
////                        //                                                    }
////                        //                                                }
////                        //                                            }
////                        //                                        }
////                        //                                    }
////                        //                                }
////                        //                            }
////                        //                        }
////                    }
//                    
//                    
//                }
                var beatcount = 0
                for searchBeats in beatshuffleArr {
                    if searchBeats.name.lowercased().trimmingCharacters(in: .whitespacesAndNewlines).contains(searchText.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)) {
                        searchedProducerBeatsWithToneAllArray.append(searchBeats)
                        beatcount+=1
                        if beatcount == 5 {
                            break
                        }
                    }
                    for pro in searchBeats.producers {
                        let word = pro.split(separator: "Æ")
                        let producer = word[1]
                        if String(producer).lowercased().trimmingCharacters(in: .whitespacesAndNewlines).contains(searchText.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)) {
                            if !searchedProducerBeatsWithToneAllArray.contains(searchBeats) {
                                searchedProducerBeatsWithToneAllArray.append(searchBeats)
                                beatcount+=1
                                if beatcount == 5 {
                                    break
                                }
                            }
                        }
                    }
                    if !searchBeats.types.isEmpty {
                        for type in searchBeats.types {
                            if type.lowercased().trimmingCharacters(in: .whitespacesAndNewlines).contains(searchText.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)) {
                                if !searchedProducerBeatsWithToneAllArray.contains(searchBeats) {
                                    searchedProducerBeatsWithToneAllArray.append(searchBeats)
                                    beatcount+=1
                                    if beatcount == 5 {
                                        break
                                    }
                                }
                            }
                        }
                    }
                    
                    if !searchBeats.sounds.isEmpty {
                        
                        for sound in searchBeats.sounds {
                            
                            if sound.lowercased().trimmingCharacters(in: .whitespacesAndNewlines).contains(searchText.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)) {
                                
                                if !searchedProducerBeatsWithToneAllArray.contains(searchBeats) {
                                    searchedProducerBeatsWithToneAllArray.append(searchBeats)
                                    beatcount+=1
                                    if beatcount == 5 {
                                        break
                                    }
                                }
                            }
                        }
                    }
                }
                var instrcount = 0
//                for searchInstrumentals in intrshuffleArr {
//                    if searchInstrumentals.instrumentalName.lowercased().trimmingCharacters(in: .whitespacesAndNewlines).contains(searchText.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)) {
//                        searchedProducerInstrumentalsWithToneAllArray.append(searchInstrumentals)
//                        instrcount+=1
//                        if instrcount == 5 {
//                            break
//                        }
//                    }
//                    if searchInstrumentals.albums != [""] {
//                        for alb in searchInstrumentals.albums {
//                            let word = alb.split(separator: "Æ")
//                            let album = word[1]
//                            if String(album).lowercased().trimmingCharacters(in: .whitespacesAndNewlines).contains(searchText.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)) {
//                                if !searchedProducerInstrumentalsWithToneAllArray.contains(searchInstrumentals) {
//                                    searchedProducerInstrumentalsWithToneAllArray.append(searchInstrumentals)
//                                    instrcount+=1
//                                    if instrcount == 5 {
//                                        break
//                                    }
//                                }
//                            }
//                        }
//                    }
//                    for pro in searchInstrumentals.songProducers {
//                        let word = pro.split(separator: "Æ")
//                        let producer = word[1]
//                        if String(producer).lowercased().trimmingCharacters(in: .whitespacesAndNewlines).contains(searchText.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)) {
//                            if !searchedProducerInstrumentalsWithToneAllArray.contains(searchInstrumentals) {
//                                searchedProducerInstrumentalsWithToneAllArray.append(searchInstrumentals)
//                                instrcount+=1
//                                if instrcount == 5 {
//                                    break
//                                }
//                            }
//                        }
//                    }
//                }
                DispatchQueue.main.async {[weak self] in
                    guard let strongSelf = self else {return}
                    strongSelf.producerSongsWithToneTableView.reloadData()
                    strongSelf.producerVideosWithToneTableView.reloadData()
                    strongSelf.producerAlbumsWithToneTableView.reloadData()
                    strongSelf.producerBeatsWithToneTableView.reloadData()
                    strongSelf.producerBeatsWithToneTableView.estimatedRowHeight = 0
                    strongSelf.producerBeatsWithToneTableView.estimatedSectionHeaderHeight = 0
                    strongSelf.producerBeatsWithToneTableView.estimatedSectionFooterHeight = 0
                    strongSelf.beatTableViewHeight.constant = strongSelf.producerBeatsWithToneTableView.contentSize.height
                    strongSelf.producerInstrumentalsWithToneTableView.reloadData()
                    strongSelf.producerInstrumentalsWithToneTableView.estimatedRowHeight = 0
                    strongSelf.producerInstrumentalsWithToneTableView.estimatedSectionHeaderHeight = 0
                    strongSelf.producerInstrumentalsWithToneTableView.estimatedSectionFooterHeight = 0
                    strongSelf.instrumentalTableViewHeight.constant = strongSelf.producerInstrumentalsWithToneTableView.contentSize.height
                    if searchedProducerSongsWithToneAllArray.count != 0 {
                        strongSelf.producerSongsWithToneTableView.isHidden = false
                        strongSelf.songTitleStack.isHidden = false
                        strongSelf.numberOfSongs.text = String(searchedProducerSongsWithToneAllArray.count)
                    } else {
                        strongSelf.producerSongsWithToneTableView.isHidden = true
                        strongSelf.songTitleStack.isHidden = true
                    }
                    if searchedProducerVideosWithToneAllArray.count != 0 {
                        strongSelf.producerVideosWithToneTableView.isHidden = false
                        strongSelf.videosTitleStack.isHidden = false
                        strongSelf.numberOfVideos.text = String(searchedProducerVideosWithToneAllArray.count)
                    } else {
                        strongSelf.producerVideosWithToneTableView.isHidden = true
                        strongSelf.videosTitleStack.isHidden = true
                    }
                    if searchedProducerAlbumsWithToneAllArray.count != 0 {
                        strongSelf.producerAlbumsWithToneTableView.isHidden = false
                        strongSelf.albumsTitleStack.isHidden = false
                        //strongSelf.albumsCountStack.isHidden = false
                        strongSelf.numberOfAlbums.text = String(searchedProducerAlbumsWithToneAllArray.count)
                    } else {
                        strongSelf.producerAlbumsWithToneTableView.isHidden = true
                        strongSelf.albumsTitleStack.isHidden = true
                        //strongSelf.albumsCountStack.isHidden = true
                    }
                    if searchedProducerBeatsWithToneAllArray.count != 0 {
                        strongSelf.beatsTitleStack.isHidden = false
                        strongSelf.seeAllBeatsStack.isHidden = false
                        strongSelf.producerBeatsWithToneTableView.isHidden = false
                        strongSelf.numberOfBeats.text = String(searchedProducerBeatsWithToneAllArray.count)
                    } else {
                        strongSelf.producerBeatsWithToneTableView.isHidden = true
                        strongSelf.beatsTitleStack.isHidden = true
                        strongSelf.seeAllBeatsStack.isHidden = true
                    }
                    if searchedProducerInstrumentalsWithToneAllArray.count != 0 {
                        strongSelf.instrumentalsTitleStack.isHidden = false
                        strongSelf.seeAllInstrumentalsStack.isHidden = false
                        strongSelf.producerInstrumentalsWithToneTableView.isHidden = false
                        strongSelf.numberOfInstrumentals.text = String(searchedProducerInstrumentalsWithToneAllArray.count)
                    } else {
                        strongSelf.producerInstrumentalsWithToneTableView.isHidden = true
                        strongSelf.instrumentalsTitleStack.isHidden = true
                        strongSelf.seeAllInstrumentalsStack.isHidden = true
                    }
                    strongSelf.view.layoutSubviews()
                    
                }
            
        }
        
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
            searchBar.text = ""
            searchedProducerSongsWithToneAllArray = ProducerSongsWithToneAllArray
            searchedProducerVideosWithToneAllArray = ProducerVideosWithToneAllArray
            searchedProducerAlbumsWithToneAllArray = ProducerAlbumsWithToneAllArray
            searchedProducerBeatsWithToneAllArray = ProducerBeatsWithToneAllArray
            searchedProducerInstrumentalsWithToneAllArray = ProducerInstrumentalsWithToneFiveArray
            producerSongsWithToneTableView.reloadData()
            producerVideosWithToneTableView.reloadData()
            producerAlbumsWithToneTableView.reloadData()
            producerBeatsWithToneTableView.reloadData()
            beatTableViewHeight.constant = producerBeatsWithToneTableView.contentSize.height
            producerInstrumentalsWithToneTableView.reloadData()
            instrumentalTableViewHeight.constant = producerInstrumentalsWithToneTableView.contentSize.height
            if searchedProducerSongsWithToneAllArray.count != 0 {
                producerSongsWithToneTableView.isHidden = false
                songTitleStack.isHidden = false
                numberOfSongs.text = String(searchedProducerSongsWithToneAllArray.count)
            } else {
                producerSongsWithToneTableView.isHidden = true
                songTitleStack.isHidden = true
            }
            if searchedProducerVideosWithToneAllArray.count != 0 {
                producerVideosWithToneTableView.isHidden = false
                videosTitleStack.isHidden = false
                numberOfVideos.text = String(searchedProducerVideosWithToneAllArray.count)
            } else {
                producerVideosWithToneTableView.isHidden = true
                videosTitleStack.isHidden = true
            }
            if searchedProducerAlbumsWithToneAllArray.count != 0 {
                producerAlbumsWithToneTableView.isHidden = false
                albumsTitleStack.isHidden = false
                //albumsCountStack.isHidden = false
                numberOfAlbums.text = String(searchedProducerAlbumsWithToneAllArray.count)
            } else {
                producerAlbumsWithToneTableView.isHidden = true
                albumsTitleStack.isHidden = true
                //albumsCountStack.isHidden = true
            }
            if searchedProducerBeatsWithToneAllArray.count != 0 {
                beatsTitleStack.isHidden = false
                seeAllBeatsStack.isHidden = false
                producerBeatsWithToneTableView.isHidden = false
                numberOfBeats.text = String(recievedProducerData.beats.count)
            } else {
                producerBeatsWithToneTableView.isHidden = true
                beatsTitleStack.isHidden = true
                seeAllBeatsStack.isHidden = true
            }
            if searchedProducerInstrumentalsWithToneAllArrayMusic.count != 0 {
                instrumentalsTitleStack.isHidden = false
                seeAllInstrumentalsStack.isHidden = false
                producerInstrumentalsWithToneTableView.isHidden = false
                numberOfInstrumentals.text = String(recievedProducerData.instrumentals.count)
            } else {
                producerInstrumentalsWithToneTableView.isHidden = true
                instrumentalsTitleStack.isHidden = true
                seeAllInstrumentalsStack.isHidden = true
            }
            view.layoutSubviews()
            if (scrollview.contentOffset.y < self.lastContentOffset || scrollview.contentOffset.y <= 250) && (self.heightConstraint.constant != self.maxHeaderHeight)  {
                //Scrolling up, scrolled to top
                UIView.animate(withDuration: 0.3) { [weak self] in
                    guard let strongSelf = self else {return}
                    if strongSelf.scrollview.contentOffset.y <= 0.0 {
                        strongSelf.followButton.alpha = 1
                        strongSelf.heightConstraint.constant = strongSelf.maxHeaderHeight
                        strongSelf.view.layoutIfNeeded()
                    }
                }
            }
            view.endEditing(true)
            
        
    }
    
}

extension ProducerInfoViewController : UITableViewDelegate, UITableViewDataSource, SkeletonTableViewDataSource {
    func collectionSkeletonView(_ skeletonView: UITableView, cellIdentifierForRowAt indexPath: IndexPath) -> ReusableCellIdentifier {
        if skeletonView == producerSongsWithToneTableView {
            return "producerSongsWithToneTableCellController"
        } else if skeletonView == producerVideosWithToneTableView {
            return "producerVideosWithToneTableCellController"
        } else if skeletonView == producerAlbumsWithToneTableView {
            return "producerAlbumsWithToneTableCellController"
        } else if skeletonView == producerBeatsWithToneTableView {
            if accountType == "Creator" {
                return "ArtistBeatCell"
            } else if accountType == "Listener" {
                return "BeatCell"
            } else {
                return "GuestBeatCell"
            }
        } else {
            return "instrumentalsMusicCell"
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == producerSongsWithToneTableView {
            musicTableHeight = 220
        } else if tableView == producerVideosWithToneTableView {
            musicTableHeight = 230
        } else if tableView == producerAlbumsWithToneTableView {
            musicTableHeight = 307.5
        } else if tableView == producerBeatsWithToneTableView {
            if accountType == "Creator" {
                musicTableHeight = 130
            } else if accountType == "Listener" {
                musicTableHeight = 120
            } else {
                musicTableHeight = 80
            }
        } else if tableView == producerInstrumentalsWithToneTableView {
            musicTableHeight = 80
        }
        return musicTableHeight//Your custom row height
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var numberOfRow = 1
        switch tableView {
        case producerSongsWithToneTableView:
            numberOfRow = 1
        case producerVideosWithToneTableView:
            numberOfRow = 1
        case producerAlbumsWithToneTableView:
            numberOfRow = 1
        case producerBeatsWithToneTableView:
            if searchedProducerBeatsWithToneAllArray.count < 5 {
                numberOfRow = searchedProducerBeatsWithToneAllArray.count
            } else {
                numberOfRow = 5
            }
            
        case producerInstrumentalsWithToneTableView:
            if searchedProducerInstrumentalsWithToneAllArray.count < 5 {
                numberOfRow = searchedProducerInstrumentalsWithToneAllArray.count
            } else {
                numberOfRow = 5
            }
        default:
            print("Some things Wrong!!")
        }
        return numberOfRow
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            if tableView == producerVideosWithToneTableView {
                let cell = tableView.dequeueReusableCell(withIdentifier: "producerVideosWithToneTableCellController", for: indexPath) as! ProducerVideosWithToneTableCellController
                if initialLoad == true {
                    cell.vcollectionView.reloadData()
                    if !searchedProducerVideosWithToneAllArray.isEmpty {
                        cell.funcSetTemp()
                    }
                } else {
                    if searchedProducerVideosWithToneAllArray.count == ProducerVideosWithToneAllArray.count {
                        cell.funcSetTemp()
                    }
                }
                return cell
            } else if tableView == producerAlbumsWithToneTableView {
                let cell = tableView.dequeueReusableCell(withIdentifier: "producerAlbumsWithToneTableCellController", for: indexPath) as! ProducerAlbumsWithToneTableCellController
                if initialLoad == true {
                    cell.acollectionView.reloadData()
                    if !searchedProducerAlbumsWithToneAllArray.isEmpty {
                        cell.funcSetTemp()
                    }
                } else {
                    if searchedProducerAlbumsWithToneAllArray == ProducerAlbumsWithToneAllArray {
                        cell.funcSetTemp()
                    }
                }
                return cell
            } else if tableView == producerInstrumentalsWithToneTableView {
                let cell = tableView.dequeueReusableCell(withIdentifier: "instrumentalsMusicCell", for: indexPath) as! InstrumentalsTableCellController
                if !searchedProducerInstrumentalsWithToneAllArray.isEmpty {
                    let array = searchedProducerInstrumentalsWithToneAllArray[indexPath.row]
                    cell.funcSetTemp(array: array)
                }
                return cell
            } else if tableView == producerBeatsWithToneTableView {
                if accountType == "Creator" {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "ArtistBeatCell") as! FreeBeatArtistTableViewCell
                    if !searchedProducerBeatsWithToneAllArray.isEmpty {
                        let beat = searchedProducerBeatsWithToneAllArray[indexPath.row]
                        cell.setBeat(beat: beat)
                    }
                    return cell
                } else if accountType == "Listener" {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "BeatCell") as! FreeBeatListenerCell
                    if !searchedProducerBeatsWithToneAllArray.isEmpty {
                        let beat = searchedProducerBeatsWithToneAllArray[indexPath.row]
                        cell.setBeat(beat: beat)
                    }
                    return cell
                } else {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "GuestBeatCell") as! FreeBeatGuestTableViewCell
                    if !searchedProducerBeatsWithToneAllArray.isEmpty {
                        let beat = searchedProducerBeatsWithToneAllArray[indexPath.row]
                        cell.setBeat(beat: beat)
                    }
                    return cell
                }
            }
            else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "producerSongsWithToneTableCellController", for: indexPath) as! ProducerSongsWithToneTableCellController
                if initialLoad == true {
                        if !searchedProducerSongsWithToneAllArray.isEmpty {
                            cell.funcSetTemp()
                        }
                        cell.collectionView.reloadData()
                } else {
                    if searchedProducerSongsWithToneAllArray == ProducerSongsWithToneAllArray {
                        cell.funcSetTemp()
                    }
                }
                return cell
            }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: false)
        
        if tableView == producerBeatsWithToneTableView {
            if audiofreeze != true {
                player = nil
                playerTimer = Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(playertimerset), userInfo: nil, repeats: false)
                if audioPlayerViewController != nil {
                    audioPlayerViewController.view.removeFromSuperview()
                    audioPlayerViewController.removeFromParent()
                    playervisualEffectView.removeFromSuperview()
                }
                    let myDict = [ "beats": searchedProducerBeatsWithToneAllArray, "position": indexPath.row] as [String : Any]
                    NotificationCenter.default.post(name: AudioPlayerOnNotify, object: myDict)
            }
        }
        if tableView == producerInstrumentalsWithToneTableView {
            var bea:InstrumentalData!
                bea = searchedProducerInstrumentalsWithToneAllArray[indexPath.row]
            NotificationCenter.default.post(name: ProToInfoSegNotify, object: bea)
            
            
        }
        
    }
    @objc func playertimerset() {
        audiofreeze = false
        print("Audio Freeze Off")
        playerTimer.invalidate()
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
}





class ProducerSongsWithToneTableViewControlller: UITableView {
    override var intrinsicContentSize: CGSize {
        layoutIfNeeded()
        return CGSize(width: UIView.noIntrinsicMetric, height: contentSize.height)
    }
}

class ProducerSongsWithToneTableCellController: UITableViewCell {
    
    @IBOutlet weak var collectionView: UICollectionView!
    var selectedSong:SongData!
    
    func funcSetTemp() {
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
}

extension ProducerSongsWithToneTableCellController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
        
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            //print("collecxtion song count \(ProducerSongsWithToneAllArrayDashboard.count)")
            return searchedProducerSongsWithToneAllArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            selectedSong = searchedProducerSongsWithToneAllArray[indexPath.item]
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "producerSongsWithToneCollectionViewCellController", for: indexPath) as! ProducerSongsWithToneCollectionViewCellController
            cell.funcSetTemp(song: selectedSong)
            return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        var son:SongData!
            son = searchedProducerSongsWithToneAllArray[indexPath.item]
        guard let song = son else {return}
        NotificationCenter.default.post(name: ProToInfoSegNotify, object: song)
    }
    
    @objc func playertimerset() {
        audiofreeze = false
        print("Audio Freeze Off")
        playerTimer.invalidate()
    }
    
    func prevURL(array: SongData) -> String {
        var prevurl:String!
        if let prevur = array.apple?.applePreviewURL {
                prevurl = prevur
        } else
        if let prevur = array.spotify?.spotifyPreviewURL {
            prevurl = prevur
        }
        return prevurl
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 160, height: 220)
    }
    
    
    
}

class ProducerSongsWithToneCollectionViewCellController: UICollectionViewCell {
    
    @IBOutlet weak var songImage: UIImageView!
    @IBOutlet weak var songName: UILabel!
    @IBOutlet weak var songArtist: UILabel!
    @IBOutlet weak var songProducers: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override var isHighlighted: Bool {
        didSet{
            tapScale(cell: self, down: isHighlighted)
        }
    }
    
    override func prepareForReuse() {
        songImage.image = nil
        songName.text = ""
        songArtist.text = ""
        songProducers.text = ""
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
                        val+=1
                        print("Video ID proccessing error \(error)")
                    }
                })
            }
        } else {
            completion(videosData, youtubeimageURLs)
        }
        
    }
    
    func funcSetTemp(song: SongData) {
        songImage.layer.cornerRadius = 4
        songImage.contentMode = .scaleAspectFill
        songName.text = song.name
        setupartist(song: song, completion: { [weak self] artist in
            guard let strongSelf = self else {return}
            switch artist.count {
            case 2:
                strongSelf.songArtist.text = "Lyrics by \(artist[0]) & \(artist[1])"
            case 3:
                strongSelf.songArtist.text = "Lyrics by \(artist[0]), \(artist[1]) & \(artist[2])"
            case 4:
                strongSelf.songArtist.text = "Lyrics by \(artist[0]), \(artist[1]), \(artist[2]) & \(artist[3])"
            case 5:
                strongSelf.songArtist.text = "Lyrics by \(artist[0]), \(artist[1]), \(artist[2]), \(artist[3]) & \(artist[4])"
            case 6:
                strongSelf.songArtist.text = "Lyrics by \(artist[0]), \(artist[1]), \(artist[2]), \(artist[3]), \(artist[4]) & \(artist[5])"
            default:
                strongSelf.songArtist.text = "Lyrics by \(artist[0])"
            }
        })
        setupproducers(song: song, completion: { [weak self] producer in
            guard let strongSelf = self else {return}
            switch producer.count {
            case 2:
                strongSelf.songProducers.text = "Produced by \(producer[0]) & \(producer[1])"
            case 3:
                strongSelf.songProducers.text = "Produced by \(producer[0]), \(producer[1]) & \(producer[2])"
            case 4:
                strongSelf.songProducers.text = "Produced by \(producer[0]), \(producer[1]), \(producer[2]) & \(producer[3])"
            case 5:
                strongSelf.songProducers.text = "Produced by \(producer[0]), \(producer[1]), \(producer[2]), \(producer[3]) & \(producer[4])"
            case 6:
                strongSelf.songProducers.text = "Produced by \(producer[0]), \(producer[1]), \(producer[2]), \(producer[3]), \(producer[4]) & \(producer[5])"
            default:
                strongSelf.songProducers.text = "Produced by \(producer[0])"
            }
        })
        var imageurl = ""
        GlobalFunctions.shared.selectImageURL(song: song, completion: {[weak self] ur in
            guard let strongSelf = self else {return}
            imageurl = ur!
            let imageURL = URL(string: imageurl)!
            if let cachedImage = imageCache.object(forKey: imageURL.absoluteString as NSString) {
                strongSelf.songImage.image = cachedImage
            } else {
                strongSelf.songImage.setImage(from: imageURL, withPlaceholder: UIImage(named: "tonedeaflogo"))
            }
        })
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
    
    func setupproducers(song: SongData, completion: @escaping (Array<String>) -> Void) {
        var producerNameData:Array<String> = []
        var val = 0
        for artist in song.songProducers {
            let word = artist.split(separator: "Æ")
            let id = word[1]
            val+=1
            producerNameData.append(String(id))
            if val == song.songProducers.count {
                completion(producerNameData)
            }
        }
    }
}

class ProducerVideosWithToneTableViewControlller: UITableView {
    override var intrinsicContentSize: CGSize {
        layoutIfNeeded()
        return CGSize(width: UIView.noIntrinsicMetric, height: contentSize.height)
    }
}

class ProducerVideosWithToneTableCellController: UITableViewCell {
    
    @IBOutlet weak var vcollectionView: UICollectionView!
    var selectedVideo:AnyObject!
    
    
    
    func funcSetTemp() {
        vcollectionView.delegate = self
        vcollectionView.dataSource = self
    }
    
}

extension ProducerVideosWithToneTableCellController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
        
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            //print("collecxtion song count \(ProducerSongsWithToneAllArrayDashboard.count)")
            return searchedProducerVideosWithToneAllArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            selectedVideo = searchedProducerVideosWithToneAllArray[indexPath.item]
            //print(indexPath.item, selectedVideo.name)
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "producerVideosWithToneCollectionViewCellController", for: indexPath) as! ProducerVideosWithToneCollectionViewCellController
            cell.funcSetTemp(video: selectedVideo)
            return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
            let vid = searchedProducerVideosWithToneAllArray[indexPath.item]
            switch vid {
            case is YouTubeData:
                let video = vid as! YouTubeData
                NotificationCenter.default.post(name: ProToInfoSegNotify, object: video)
            default:
                print("sumn else dawg")
            }
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: 320, height: 230)
    }
    
    
    
}

class ProducerVideosWithToneCollectionViewCellController: UICollectionViewCell {
    
    @IBOutlet weak var videoThumbnail: UIImageView!
    @IBOutlet weak var videoTitle: UILabel!
    @IBOutlet weak var channelTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        videoThumbnail.image = nil
    }
    
    override var isHighlighted: Bool {
        didSet{
            tapScale(cell: self, down: isHighlighted)
        }
    }
    
    func funcSetTemp(video: AnyObject) {
        videoThumbnail.layer.cornerRadius = 4
        videoThumbnail.contentMode = .scaleAspectFill
        switch video {
        case is YouTubeData:
            let video = video as! YouTubeData
            if let imageURL = URL(string: video.thumbnailURL){
                if let cachedImage = imageCache.object(forKey: imageURL.absoluteString as NSString) {
                    videoThumbnail.image = cachedImage
                } else {
                    videoThumbnail.setImage(from: imageURL)
                }
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

class ProducerAlbumsWithToneTableViewControlller: UITableView {
    override var intrinsicContentSize: CGSize {
        layoutIfNeeded()
        return CGSize(width: UIView.noIntrinsicMetric, height: 307.5)
    }
}

class ProducerAlbumsWithToneTableCellController: UITableViewCell {
    
    @IBOutlet weak var acollectionView: UICollectionView!
    var selectedAlbum:AlbumData!
    var index:Int!
    var currentIndex = IndexPath(index: 0)
    @IBOutlet weak var page: UIPageControl!
    
    override func awakeFromNib() {
    }
    func funcSetTemp() {
        acollectionView.delegate = self
        acollectionView.dataSource = self
        acollectionView.isPagingEnabled = true
        page.numberOfPages = searchedProducerAlbumsWithToneAllArray.count
    }
    
    override func prepareForReuse() {
        //selectedAlbum = nil
        acollectionView.isPagingEnabled = true
    }
    
}

extension ProducerAlbumsWithToneTableCellController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
        
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            //print("collecxtion song count \(searchedProducerAlbumsWithToneAllArrayDashboard.count)")
            return searchedProducerAlbumsWithToneAllArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        collectionView.isPagingEnabled = true
            //print(searchedProducerAlbumsWithToneAllArrayDashboard, indexPath.item)
            selectedAlbum = searchedProducerAlbumsWithToneAllArray[indexPath.item]
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "producerAlbumsWithToneCollectionViewCellController", for: indexPath) as! ProducerAlbumsWithToneCollectionViewCellController
            cell.funcSetTemp(album: selectedAlbum)
            //cell.albumListTableView.reloadData()
            return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
            let album = searchedProducerAlbumsWithToneAllArray[indexPath.item]
            NotificationCenter.default.post(name: ProToInfoSegNotify, object: album)
        
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: acollectionView.frame.width, height: 280)
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

class ProducerAlbumsWithToneCollectionViewCellController: UICollectionViewCell {
    
    @IBOutlet weak var albumListTableView: UITableView!
    @IBOutlet weak var albumView: UIView!
    @IBOutlet weak var albumArtwork: UIImageView!
    @IBOutlet weak var albumName: MarqueeLabel!
    @IBOutlet weak var albumArtist: MarqueeLabel!
    @IBOutlet weak var albumProducers: MarqueeLabel!
    @IBOutlet weak var numOfTracks: MarqueeLabel!
    var backgroundImageView:UIImageView!
    var blurView:UIVisualEffectView!
    
    var skelvar = 0
    
    var albummain:AlbumData!
    var albumSongArray:[AlbumSong] = []
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override var isHighlighted: Bool {
        didSet{
            tapScale(cell: self, down: isHighlighted)
        }
    }
    
    override func prepareForReuse() {
        albummain = nil
        albumArtwork.image = nil
        albumSongArray = []
        backgroundImageView = nil
        blurView = nil
        //blurView = nil
//        albumName.text = ""
//        albumArtist.text = ""
//        albumProducers.text = ""
//        numOfTracks.text = ""
    }
    
    func funcSetTemp(album: AlbumData) {
        if skelvar == 0 {
            albumListTableView.isSkeletonable = true
            albumListTableView.showAnimatedGradientSkeleton(usingGradient: .init(baseColor: UIColor.init(red: 22/255, green: 22/255, blue: 22/255, alpha: 1)), animation: nil, transition: .crossDissolve(0.25))
        }
        albummain = album
        setUpAlbumSongArray(album: album)
        albumListTableView.delegate = self
        albumListTableView.dataSource = self
        albumArtwork.layer.cornerRadius = 5
        albumName.text = album.name
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
                albumArtwork.image = cachedImage
                blurredBackground(url: url)
            } else {
                albumArtwork.setImage(from: url, withPlaceholder: UIImage(named: "tonedeaflogo"))
                blurredBackground(url: url)
            }
        }
        setupartist(album: album, completion: {[weak self] artistNames in
            guard let strongSelf = self else {return}
            strongSelf.albumArtist.text = artistNames.joined(separator: ", ")
        })
        setupproducer(album: album, completion: {[weak self] producerNames in
            guard let strongSelf = self else {return}
            strongSelf.albumProducers.text = producerNames.joined(separator: ", ")
        })
    }
    
    func setUpAlbumSongArray(album: AlbumData) {
        var tick = 0
        var producer:ProducerData!
            producer = recievedProducerData
        //let semaphore = DispatchSemaphore(value: albummain.songs.count)
//        for (key, song) in albummain.songs {
//            let track = key.replacingOccurrences(of: "Track ", with: "")
//            guard let trackNum = Int(track) else {return}
//            let word = song.split(separator: "Æ")
//            let id = word[0]
//            switch id.count {
//            case 10:
//                if producer.songs.contains(song) {
//                    DatabaseManager.shared.findSongById(songId: String(id), completion: {[weak self] result in
//                        guard let strongSelf = self else {return}
//                        switch result {
//                        case .success(let foundSong):
//                            let son = AlbumSong(trackNumber: trackNum, song: foundSong)
//                            if !strongSelf.albumSongArray.contains(son) {
//                                strongSelf.albumSongArray.append(son)
//                            }
//                            tick+=1
//                            if tick == strongSelf.albummain.songs.count {
//                                if strongSelf.albumSongArray.count > 1 {
//                                    strongSelf.numOfTracks.text = "\(strongSelf.albumSongArray.count) Tracks"
//                                } else if strongSelf.albumSongArray.count == 1 {
//                                    strongSelf.numOfTracks.text = "\(strongSelf.albumSongArray.count) Track"
//                                }
//                                strongSelf.hideskeleton(tableview: strongSelf.albumListTableView)
//                            }
//                        case .failure(let error):
//                            print("Fail \(error)")
//                        }
//                        
//                    })
//                } else {
//                    tick+=1
//                }
//            default:
//                DatabaseManager.shared.findInstrumentalById(instrumentalId: String(id), completion: {[weak self] result in
//                    guard let strongSelf = self else {return}
//                    switch result {
//                    case .success(let foundSong):
//                        let son = AlbumSong(trackNumber: trackNum, song: foundSong)
//                        if !strongSelf.albumSongArray.contains(son) {
//                            strongSelf.albumSongArray.append(son)
//                        }
//                        tick+=1
//                        if tick == strongSelf.albummain.songs.count {
//                            if strongSelf.albumSongArray.count > 1 {
//                                strongSelf.numOfTracks.text = "\(strongSelf.albumSongArray.count) Tracks"
//                            } else if strongSelf.albumSongArray.count == 1 {
//                                strongSelf.numOfTracks.text = "\(strongSelf.albumSongArray.count) Track"
//                            }
//                            strongSelf.hideskeleton(tableview: strongSelf.albumListTableView)
//                        }
//                    case .failure(let error):
//                        tick+=1
//                        print("Fail \(error)")
//                    }
//
//                })
//            }
//        }
        
    }
    
    func blurredBackground(url: URL) {
        backgroundImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: albumView.bounds.width, height: albumView.bounds.height))
        albumView.addSubview(backgroundImageView)
        backgroundImageView.contentMode = .scaleAspectFill
        backgroundImageView.layer.masksToBounds = true
        if let cachedImage = imageCache.object(forKey: url.absoluteString as NSString) {
            backgroundImageView.image = cachedImage
        } else {
            backgroundImageView.setImage(from: url, withPlaceholder: UIImage(named: "tonedeaflogo"))
        }
        //albumView.sendSubviewToBack(backgroundImageView)
        
        let blur = UIBlurEffect(style: .dark)
        blurView = UIVisualEffectView(effect: blur)
        blurView.frame = albumView.bounds
        albumView.addSubview(blurView)
        albumView.sendSubviewToBack(blurView)
        albumView.sendSubviewToBack(backgroundImageView)
    }
    
    func setupartist(album: AlbumData, completion: @escaping (Array<String>) -> Void) {
        var artistNameData:Array<String> = []
        var val = 1
        for artist in album.mainArtist {
            let word = artist.split(separator: "Æ")
            let id = word[1]
            val+=1
            artistNameData.append(String(id))
            if val == album.mainArtist.count {
                completion(artistNameData)
            }
        }
    }

    func setupproducer(album: AlbumData, completion: @escaping (Array<String>) -> Void) {
        var producerNameData:Array<String> = []
        var val = 0
        for artist in album.producers {
            let word = artist.split(separator: "Æ")
            let id = word[1]
            val+=1
            producerNameData.append(String(id))
            if val == album.producers.count {
                completion(producerNameData)
            }
        }
    }
    
    func hideskeleton(tableview: UITableView) {
        skelvar+=1
        DispatchQueue.main.async {
            print("Hiding skeleton")
        tableview.stopSkeletonAnimation()
        tableview.hideSkeleton(reloadDataAfter: false, transition: .crossDissolve(0.25))
        tableview.reloadData()
        }
    }
}

extension ProducerAlbumsWithToneCollectionViewCellController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return albumSongArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        albumSongArray.sort(by: {$0.trackNumber < $1.trackNumber})
        let cell = tableView.dequeueReusableCell(withIdentifier: "producerAlbumSongListCell", for: indexPath) as! ProducerAlbumsSongsListWithToneTableCellController
        let song = albumSongArray[indexPath.row]
        if !albumSongArray.isEmpty {
            cell.funcSetTemp(songs: song)
        } else {
            setUpAlbumSongArray(album: albummain)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        var son:Any!
        son = albumSongArray[indexPath.row].song
        switch son {
        case is SongData:
            let song = albumSongArray[indexPath.row].song as! SongData
            NotificationCenter.default.post(name: ProToInfoSegNotify, object: song)
        default:
            let beat = albumSongArray[indexPath.row].song as! BeatData
            NotificationCenter.default.post(name: ProToInfoSegNotify, object: beat)
        }
        
    }
    
    @objc func playertimerset() {
        audiofreeze = false
        print("Audio Freeze Off")
        playerTimer.invalidate()
    }
    
    func prevURL(array: SongData) -> String {
        var prevurl:String!
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

class ProducerAlbumsSongsListWithToneTableViewControlller: UITableView {
    override var intrinsicContentSize: CGSize {
        layoutIfNeeded()
        return CGSize(width: UIView.noIntrinsicMetric, height: 280)
    }
}

class ProducerAlbumsSongsListWithToneTableCellController: UITableViewCell {
    
    @IBOutlet weak var tracknum: MarqueeLabel!
    @IBOutlet weak var duration: MarqueeLabel!
    @IBOutlet weak var artistAndProducers: MarqueeLabel!
    @IBOutlet weak var songname: MarqueeLabel!
    
    override func prepareForReuse() {
        tracknum.text = " "
        duration.text = "   "
        artistAndProducers.text = "   "
        songname.text = "   "
    }
    
    func funcSetTemp(songs: AlbumSong) {
        tracknum.text = String(songs.trackNumber)
        switch songs.song {
        case is SongData:
            let song = songs.song as! SongData
            songname.text = song.name
            duration.alpha = 0
            setupartist(song: song, completion: {[weak self] artistNames in
                guard let strongSelf = self else {return}
                strongSelf.setupproducer(song: song, completion: { producerNames in
                    strongSelf.artistAndProducers.text = "\(artistNames.joined(separator: ", ")), \(producerNames.joined(separator: ", "))"
                })
                
            })
        default:
            let instrumental = songs.song as! InstrumentalData
            songname.text = instrumental.instrumentalName
            duration.alpha = 0
            setupproducer(instrumental: instrumental, completion: {[weak self] producerNames in
                guard let strongSelf = self else {return}
                strongSelf.artistAndProducers.text = "\(producerNames.joined(separator: ", "))"
            })
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

    func setupproducer(song: SongData, completion: @escaping (Array<String>) -> Void) {
        var producerNameData:Array<String> = []
        var val = 0
        for artist in song.songProducers {
            let word = artist.split(separator: "Æ")
            let id = word[1]
            val+=1
            producerNameData.append(String(id))
            if val == song.songProducers.count {
                completion(producerNameData)
            }
        }
    }
    func setupproducer(instrumental: InstrumentalData, completion: @escaping (Array<String>) -> Void) {
        var producerNameData:Array<String> = []
        var val = 0
//        for artist in instrumental.songProducers {
//            let word = artist.split(separator: "Æ")
//            let id = word[1]
//            val+=1
//            producerNameData.append(String(id))
//            if val == instrumental.songProducers.count {
//                completion(producerNameData)
//            }
//        }
    }
    
}


class ProducerBeatsWithToneTableViewControlller: UITableView {
    override var intrinsicContentSize: CGSize {
        layoutIfNeeded()
        return CGSize(width: UIView.noIntrinsicMetric, height: contentSize.height)
    }
}

class ProducerInstrumentalsWithToneTableViewControlller: UITableView {
    override var intrinsicContentSize: CGSize {
        layoutIfNeeded()
        return CGSize(width: UIView.noIntrinsicMetric, height: contentSize.height)
    }
}






