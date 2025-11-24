//
//  ArtistInfoViewController.swift
//  ToneDeafDeafinitionsApp
//
//  Created by Tone Deaf on 8/20/20.
//  Copyright © 2020 GITEM Solutions. All rights reserved.
//

import UIKit
import SkeletonView
import MarqueeLabel


var aartistInfoViewController: ArtistInfoViewController!
class ArtistInfoViewController: UIViewController {
    
    
    static let shared = ArtistInfoViewController()

    @IBOutlet weak var heightConstraint: NSLayoutConstraint!

    var lastContentOffset: CGFloat = 250.0
    let maxHeaderHeight: CGFloat = 250.0
    
    var infoDetailContent:Any!
    
    @IBOutlet weak var scrollview: UIScrollView!
    @IBOutlet weak var headerImage: UIView!
    @IBOutlet weak var artistImage: UIImageView!
    @IBOutlet weak var artistName: UILabel!
    @IBOutlet weak var numberOfSongsWithToneLabel: UILabel!
    @IBOutlet weak var followButton: UIButton!
    @IBOutlet weak var followBarButton: UIBarButtonItem!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var songsHeaderLabel: UILabel!
    @IBOutlet weak var numberOfSongs: UILabel!
    @IBOutlet weak var numberOfVideos: UILabel!
    @IBOutlet weak var numberOfAlbums: UILabel!
    @IBOutlet weak var numberOfMerch: UILabel!
    
    var following: Bool = false
    
    @IBOutlet weak var songTitleStack: UIStackView!
    @IBOutlet weak var videosTitleStack: UIStackView!
    @IBOutlet weak var albumsTitleStack: UIStackView!
    @IBOutlet weak var merchTitleStack: UIStackView!
    
    @IBOutlet weak var artistVideosWithToneTableView: ArtistVideosWithToneTableViewControlller!
    @IBOutlet weak var artistSongsWithToneTableView: UITableView!
    @IBOutlet weak var artistAlbumsWithToneTableView: UITableView!
    @IBOutlet weak var artistMerchWithToneCollectionView: UICollectionView!
    var musicTableHeight:CGFloat = 400
    var skelvar = 0
    var instance = 0
    var initialLoad = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let moreb = UIBarButtonItem(image: UIImage(named: "dots copy"), style: .plain, target: self, action: #selector(moreButtonTapped))
        navigationItem.rightBarButtonItems = [moreb,followBarButton]
            ArtistSongsWithToneAllArray = []
            ArtistVideosWithToneAllArray = []
            ArtistAlbumsWithToneAllArray = []
        ArtistMerchWithToneAllArray = []
        artistSongsWithToneTableView.delegate = self
        artistSongsWithToneTableView.dataSource = self
        artistVideosWithToneTableView.delegate = self
        artistVideosWithToneTableView.dataSource = self
        artistAlbumsWithToneTableView.delegate = self
        artistAlbumsWithToneTableView.dataSource = self
        artistMerchWithToneCollectionView.delegate = self
        artistMerchWithToneCollectionView.dataSource = self
        scrollview.delegate = self
        searchBar.delegate = self
        skelvar = 0
        dismissKeyboardOnTap()
            
            recieved(notification: nil)
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
        print("📗 Artist Info being deallocated from memory. OS reclaiming")
        NotificationCenter.default.removeObserver(self)
    }
    
    func createObserbvers() {
        NotificationCenter.default.removeObserver(self)
        NotificationCenter.default.addObserver(self, selector: #selector(seg), name: ArtToInfoSegNotify, object: nil)
    }
    
    @objc func recieved(notification: Notification?) {
        setUpPageDisplays()
        let queue = DispatchQueue(label: "myartinfoQueue")
        let group = DispatchGroup()
        let array = [1,2,3,4]
        for i in array {
            //print("i = \(i)")
            group.enter()
            queue.async {[weak self] in
                guard let strongSelf = self else {return}
                switch i {
                case 1:
                    //print("null")
                    strongSelf.setArtistSongsInfo(completion: {
                        DispatchQueue.main.async {
                            strongSelf.artistSongsWithToneTableView.reloadData()
                        }
                        print("done \(i)")
                        group.leave()
                    })
                case 2:
                    //print("null")
                    strongSelf.setArtistVideosInfo(completion: {
                        DispatchQueue.main.async {
                            strongSelf.artistVideosWithToneTableView.reloadData()
                        }
                        
                        print("done \(i)")
                        group.leave()
                    })
                case 3:
                    //print("null")
                    strongSelf.setArtistAlbumsInfo(completion: {
                        DispatchQueue.main.async {
                            strongSelf.artistAlbumsWithToneTableView.reloadData()
                        }
                        print("done \(i)")
                        group.leave()
                    })
                case 4:
                    //print("null")
                    strongSelf.setArtistMerchInfo(completion: {
                        DispatchQueue.main.async {
                            strongSelf.artistMerchWithToneCollectionView.reloadData()
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
            strongSelf.initialLoad = true
            
            strongSelf.artistSongsWithToneTableView.reloadData()
            strongSelf.artistVideosWithToneTableView.reloadData()
            strongSelf.artistAlbumsWithToneTableView.reloadData()
        }
    }
    
    func setUpPageDisplays() {
        followButton.layer.cornerRadius = 17
        artistImage.layer.cornerRadius = 45
        artistImage.contentMode = .scaleAspectFill
            ArtistSongsWithToneAllArray = []
            ArtistVideosWithToneAllArray = []
            ArtistAlbumsWithToneAllArray = []
        ArtistMerchWithToneAllArray = []
            if let url = URL.init(string: recievedArtistData.spotifyProfileImageURL) {
                artistImage.setImage(from: url, withPlaceholder: UIImage(named: "tonedeaflogo"))
                blurredBackground(url: url)
                
            }
            //self.navigationItem.title = currentDashboardArtistInfo.name
            artistName.text = recievedArtistData.name
            numberOfSongsWithToneLabel.text = String(recievedArtistData.songs.count)
            if recievedArtistData.songs.count == 1 {
                songsHeaderLabel.text = "Song"
            }
        
    }
    
    func setArtistSongsInfo(completion: @escaping () -> Void) {
            var dab = 0
            ArtistSongsWithToneAllArray = []
            if recievedArtistData.songs.isEmpty || recievedArtistData.songs[0] == "" {
                DispatchQueue.main.async { [weak self] in
                    guard let strongSelf = self else {return}
                    strongSelf.songTitleStack.isHidden = true
                    strongSelf.artistSongsWithToneTableView.isHidden = true
                }
                completion()
                return
            }
            for idss in recievedArtistData.songs {
                if idss != "" {
                    let word = idss.split(separator: "Æ")
                    let id = word[0]
                    DatabaseManager.shared.findSongById(songId: String(id), completion: { [weak self] result in
                        guard let strongSelf = self else {return}
                        switch result {
                        case .success(let song):
                            ArtistSongsWithToneAllArray.append(song)
                            dab+=1
                            //print("dab = \(dab)")
                            //print("soung count = \(ArtistSongsWithToneAllArrayDashboard.count)")
                            if dab == recievedArtistData.songs.count {
                                searchedArtistSongsWithToneAllArray = ArtistSongsWithToneAllArray
                                strongSelf.numberOfSongs.text = String(ArtistSongsWithToneAllArray.count)
                                strongSelf.hideskeleton(tableview: strongSelf.artistSongsWithToneTableView)
                                completion()
                            }
                        case .failure(let error):
                            print("Song ID proccessing error \(error)")
                        }
                    })
                } else {
                    completion()
                }
            }
        
    }
    
    func setArtistVideosInfo(completion: @escaping () -> Void) {
            var dab = 0
            ArtistVideosWithToneAllArray = []
            if recievedArtistData.videos.isEmpty || recievedArtistData.videos == [""] || recievedArtistData.videos[0] == "" {
                DispatchQueue.main.async { [weak self] in
                    guard let strongSelf = self else {return}
                    strongSelf.videosTitleStack.isHidden = true
                    strongSelf.artistVideosWithToneTableView.isHidden = true
                }
                completion()
                return
            }
            for idss in recievedArtistData.videos {
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
                            ArtistVideosWithToneAllArray.append(video)
                            dab+=1
                            //print(dab, video.title)
                            if dab == recievedArtistData.videos.count {
                                searchedArtistVideosWithToneAllArray = ArtistVideosWithToneAllArray
                                strongSelf.numberOfVideos.text = String(ArtistVideosWithToneAllArray.count)
                                strongSelf.hideskeleton(tableview: strongSelf.artistVideosWithToneTableView)
                                completion()
                            }
                        default:
                            fatalError("Not Youtube")
                        }
                    case .failure(let error):
                        print("Song ID proccessing error \(error)")
                    }
                })
            }
        
    }
    
    func setArtistAlbumsInfo(completion: @escaping () -> Void) {
            var dab = 0
            ArtistAlbumsWithToneAllArray = []
            for idss in recievedArtistData.albums {
                if idss != "" {
                    let word = idss.split(separator: "Æ")
                    let id = word[0]
                    DatabaseManager.shared.findAlbumById(albumId: String(id), completion: { [weak self] result in
                        guard let strongSelf = self else {return}
                        switch result {
                        case .success(let song):
                            ArtistAlbumsWithToneAllArray.append(song)
                            dab+=1
                            //print("dab = \(dab)")
                            //print("album count = \(ArtistAlbumsWithToneAllArrayDashboard.count)")
                            if dab == recievedArtistData.albums.count {
                                searchedArtistAlbumsWithToneAllArray = ArtistAlbumsWithToneAllArray
                                strongSelf.numberOfAlbums.text = String(ArtistAlbumsWithToneAllArray.count)
                                strongSelf.hideskeleton(tableview: strongSelf.artistAlbumsWithToneTableView)
                                completion()
                            }
                        case .failure(let error):
                            print("Song ID proccessing error \(error)")
                        }
                    })
                } else {
                    DispatchQueue.main.async { [weak self] in
                        guard let strongSelf = self else {return}
                        strongSelf.artistAlbumsWithToneTableView.isHidden = true
                        strongSelf.albumsTitleStack.isHidden = true
                    }
                    completion()
                }
            }
        
    }
    
    func setArtistMerchInfo(completion: @escaping () -> Void) {
            var dab = 0
            ArtistMerchWithToneAllArray = []
        if let merch = recievedArtistData.merch {
            for idss in merch {
                    let word = idss.split(separator: "Æ")
                    let id = word[0]
                DatabaseManager.shared.findMerchById(merchId: String(id), completion: { [weak self] result in
                        guard let strongSelf = self else {return}
                        switch result {
                        case .success(let song):
                            ArtistMerchWithToneAllArray.append(song)
                            dab+=1
                            //print("dab = \(dab)")
                            //print("album count = \(ArtistAlbumsWithToneAllArrayDashboard.count)")
                            if dab == merch.count {
                                searchedArtistMerchWithToneAllArray = ArtistMerchWithToneAllArray
                                strongSelf.numberOfMerch.text = String(ArtistMerchWithToneAllArray.count)
                                strongSelf.hideskeleton(collectionview: strongSelf.artistMerchWithToneCollectionView)
                                completion()
                            }
                        case .failure(let error):
                            print("Merch ID proccessing error \(error)")
                        }
                    })
            }
        } else {
            DispatchQueue.main.async { [weak self] in
                guard let strongSelf = self else {return}
                strongSelf.artistMerchWithToneCollectionView.isHidden = true
                strongSelf.merchTitleStack.isHidden = true
            }
            completion()
        }
        
    }
    
    func blurredBackground(url: URL) {
        let backgroundImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: headerImage.bounds.width, height: headerImage.bounds.height))
        headerImage.addSubview(backgroundImageView)
        backgroundImageView.contentMode = .scaleAspectFill
        backgroundImageView.layer.masksToBounds = true
        backgroundImageView.setImage(from: url, withPlaceholder: UIImage(named: "tonedeaflogo"))
        headerImage.sendSubviewToBack(backgroundImageView)
        
        headerImage.roundCorners(corners: [.topLeft,.topRight], radius: 10)
        backgroundImageView.roundCorners(corners: [.topLeft,.topRight], radius: 10)
        
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
        tableview.hideSkeleton(reloadDataAfter: false, transition: .crossDissolve(0.25))
        tableview.reloadData()
        }
    }
    
    func hideskeleton(collectionview: UICollectionView) {
        skelvar+=1
        DispatchQueue.main.async {
            print("Hiding skeleton")
            collectionview.stopSkeletonAnimation()
            collectionview.hideSkeleton(reloadDataAfter: false, transition: .crossDissolve(0.25))
            collectionview.reloadData()
        }
    }
    
    func hideskeleton(view: UIView) {
        skelvar+=1
        DispatchQueue.main.async {
            print("Hiding skeleton")
        view.stopSkeletonAnimation()
            view.hideSkeleton()
            view.layoutSubviews()
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if skelvar == 0 {
            print("setting skeleton")
            artistSongsWithToneTableView.isSkeletonable = true
            artistSongsWithToneTableView.showAnimatedGradientSkeleton(usingGradient: .init(baseColor: UIColor.init(red: 22/255, green: 22/255, blue: 22/255, alpha: 1)), animation: nil, transition: .crossDissolve(0.25))
            artistVideosWithToneTableView.isSkeletonable = true
            artistVideosWithToneTableView.showAnimatedGradientSkeleton(usingGradient: .init(baseColor: UIColor.init(red: 22/255, green: 22/255, blue: 22/255, alpha: 1)), animation: nil, transition: .crossDissolve(0.25))
            artistAlbumsWithToneTableView.isSkeletonable = true
            artistAlbumsWithToneTableView.showAnimatedGradientSkeleton(usingGradient: .init(baseColor: UIColor.init(red: 22/255, green: 22/255, blue: 22/255, alpha: 1)), animation: nil, transition: .crossDissolve(0.25))
            
        }

        
        skelvar+=1
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "artToInfo" {
            if let viewController: InfoDetailViewController = segue.destination as? InfoDetailViewController {
                NotificationCenter.default.removeObserver(self)
                viewController.content = infoDetailContent
            }
        }
    }
    
    @objc func seg(notification: Notification) {
        infoDetailContent = notification.object
        performSegue(withIdentifier: "artToInfo", sender: nil)
    }
    
    @objc func moreButtonTapped() {
        var height = 1
        if recievedArtistData.spotifyProfileURL != "" {
            height+=1
        }
        if recievedArtistData.appleProfileURL != "" {
            height+=1
        }
        if let _ = recievedArtistData.soundcloudProfileURL {
            height+=1
        }
        if let _ = recievedArtistData.youtubeMusicProfileURL {
            height+=1
        }
        if let _ = recievedArtistData.amazonProfileURL {
            height+=1
        }
        if recievedArtistData.deezerProfileURL != nil {
            height+=1
        }
        if recievedArtistData.spinrillaProfileURL != nil {
            height+=1
        }
        if recievedArtistData.napsterProfileURL != nil {
            height+=1
        }
        if recievedArtistData.tidalProfileURL != nil {
            height+=1
        }
        if recievedArtistData.instagramProfileURL != nil {
            height+=1
        }
        if recievedArtistData.facebookProfileURL != nil {
            height+=1
        }
        if recievedArtistData.twitterProfileURL != nil {
            height+=1
        }
        let high = height*50
        popOverIndicator = "art"
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
    
    
    @IBAction func followButtonTapped() {
        followingTapScale(button: followBarButton)
    }
    
    func dismissKeyboardOnTap() {
        let tap = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        scrollview.keyboardDismissMode = .onDrag
    }
    
    func followingTapScale(button: UIBarButtonItem) {
        lightImpactGenerator.impactOccurred()
        followButton.setTitle("", for: .normal)
        UIView.animate(withDuration: 0.025,
                       animations: {
            button.customView!.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        },
                       completion: {[weak self] _ in
            guard let strongSelf = self else {return}
            UIView.animate(withDuration: 0.025) {
                button.customView!.transform = CGAffineTransform.identity
            }
            if strongSelf.following {
                strongSelf.followButton.backgroundColor = .clear
                strongSelf.followButton.setTitle("Follow", for: .normal)
                strongSelf.followButton.setTitleColor(Constants.Colors.redApp, for: .normal)
                strongSelf.following = false
            } else {
                strongSelf.followButton.backgroundColor = Constants.Colors.redApp
                strongSelf.followButton.setTitle("Following", for: .normal)
                strongSelf.followButton.setTitleColor(.white, for: .normal)
                strongSelf.following = true
            }
        })
    }
    
}

extension ArtistInfoViewController: UIPopoverPresentationControllerDelegate {
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
            return UIModalPresentationStyle.none
        }

        
        func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
            return UIModalPresentationStyle.none
        }
}

extension ArtistInfoViewController: UIScrollViewDelegate {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        if scrollView == artistAlbumsWithToneTableView {
            scrollView.isScrollEnabled = false
            scrollView.isPagingEnabled = true
            scrollView.showsVerticalScrollIndicator = false
        }
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == scrollview {
            if (scrollView.contentOffset.y >= (scrollView.contentSize.height - scrollView.frame.size.height)) {
                //Scrolled to bottom
                if !(scrollView.contentOffset.y < self.lastContentOffset || scrollView.contentOffset.y <= 250) {
                    
                    //followButton.alpha = 0
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
                print(scrollView.contentOffset.y)
                UIView.animate(withDuration: 0.3) { [weak self] in
                    guard let strongSelf = self else {return}
                    if scrollView.contentOffset.y <= 0.0 {
                        //strongSelf.followButton.alpha = 1
                                       strongSelf.heightConstraint.constant = strongSelf.maxHeaderHeight
                                       strongSelf.view.layoutIfNeeded()
                    }
                }
            }
            else if (scrollView.contentOffset.y > lastContentOffset) && heightConstraint.constant != 0 {
                //Scrolling down
                if !(scrollView.contentOffset.y < lastContentOffset || scrollView.contentOffset.y <= 0) {
                    //followButton.alpha = 0
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
}

extension ArtistInfoViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
        searchBar.resignFirstResponder()
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
            //followButton.alpha = 0
            UIView.animate(withDuration: 0.3) { [weak self] in
                guard let strongSelf = self else {return}
                strongSelf.heightConstraint.constant = 0.0
                strongSelf.view.layoutIfNeeded()
            }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchText == "" {
            searchedArtistSongsWithToneAllArray = ArtistSongsWithToneAllArray
            searchedArtistVideosWithToneAllArray = ArtistVideosWithToneAllArray
            searchedArtistAlbumsWithToneAllArray = ArtistAlbumsWithToneAllArray
            searchedArtistMerchWithToneAllArray = ArtistMerchWithToneAllArray
            artistSongsWithToneTableView.reloadData()
            artistVideosWithToneTableView.reloadData()
            artistAlbumsWithToneTableView.reloadData()
            artistMerchWithToneCollectionView.reloadData()
            if searchedArtistSongsWithToneAllArray.count != 0 {
                artistSongsWithToneTableView.isHidden = false
                songTitleStack.isHidden = false
                numberOfSongs.text = String(searchedArtistSongsWithToneAllArray.count)
            } else {
                artistSongsWithToneTableView.isHidden = true
                songTitleStack.isHidden = true
            }
            if searchedArtistVideosWithToneAllArray.count != 0 {
                artistVideosWithToneTableView.isHidden = false
                videosTitleStack.isHidden = false
                numberOfVideos.text = String(searchedArtistVideosWithToneAllArray.count)
            } else {
                artistVideosWithToneTableView.isHidden = true
                videosTitleStack.isHidden = true
            }
            if searchedArtistAlbumsWithToneAllArray.count != 0 {
                artistAlbumsWithToneTableView.isHidden = false
                albumsTitleStack.isHidden = false
                //albumsCountStack.isHidden = false
                numberOfAlbums.text = String(searchedArtistAlbumsWithToneAllArray.count)
            } else {
                artistAlbumsWithToneTableView.isHidden = true
                albumsTitleStack.isHidden = true
                //albumsCountStack.isHidden = true
            }
            if searchedArtistMerchWithToneAllArray.count != 0 {
                artistMerchWithToneCollectionView.isHidden = false
                merchTitleStack.isHidden = false
                //albumsCountStack.isHidden = false
                numberOfMerch.text = String(searchedArtistMerchWithToneAllArray.count)
            } else {
                artistMerchWithToneCollectionView.isHidden = true
                merchTitleStack.isHidden = true
                //albumsCountStack.isHidden = true
            }
            view.layoutSubviews()
            
            //filteredResultsLabel.isHidden = true
            //freeBeatTableView.reloadData()
        }
        else {
            searchedArtistSongsWithToneAllArray = []
            searchedArtistVideosWithToneAllArray = []
            searchedArtistAlbumsWithToneAllArray = []
            searchedArtistMerchWithToneAllArray = []
            
            for searchSongs in ArtistSongsWithToneAllArray {
                if searchSongs.name.lowercased().trimmingCharacters(in: .whitespacesAndNewlines).contains(searchText.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)) {
                    searchedArtistSongsWithToneAllArray.append(searchSongs)
                }
                for art in searchSongs.songArtist {
                    let word = art.split(separator: "Æ")
                    let artist = word[1]
                    if String(artist).lowercased().trimmingCharacters(in: .whitespacesAndNewlines).contains(searchText.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)) {
                        if !searchedArtistSongsWithToneAllArray.contains(searchSongs) {
                            searchedArtistSongsWithToneAllArray.append(searchSongs)
                        }
                    }
                }
                if searchSongs.albums! != [""] {
                    for alb in searchSongs.albums! {
                        let word = alb.split(separator: "Æ")
                        let album = word[1]
                        if String(album).lowercased().trimmingCharacters(in: .whitespacesAndNewlines).contains(searchText.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)) {
                            if !searchedArtistSongsWithToneAllArray.contains(searchSongs) {
                                searchedArtistSongsWithToneAllArray.append(searchSongs)
                            }
                        }
                    }
                }
                for pro in searchSongs.songProducers {
                    let word = pro.split(separator: "Æ")
                    let producer = word[1]
                    if String(producer).lowercased().trimmingCharacters(in: .whitespacesAndNewlines).contains(searchText.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)) {
                        if !searchedArtistSongsWithToneAllArray.contains(searchSongs) {
                            searchedArtistSongsWithToneAllArray.append(searchSongs)
                        }
                    }
                }
            }
            for searchMerch in ArtistMerchWithToneAllArray {
                if let merch = searchMerch.kit {
                    if merch.name.lowercased().trimmingCharacters(in: .whitespacesAndNewlines).contains(searchText.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)) {
                        searchedArtistMerchWithToneAllArray.append(searchMerch)
                    }
                    if let artist = merch.artists {
                        for art in artist {
                            let word = art.split(separator: "Æ")
                            let artist = word[1]
                            if String(artist).lowercased().trimmingCharacters(in: .whitespacesAndNewlines).contains(searchText.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)) {
                                if !searchedArtistMerchWithToneAllArray.contains(searchMerch) {
                                    searchedArtistMerchWithToneAllArray.append(searchMerch)
                                }
                            }
                        }
                    }
                    if let songs = merch.songs {
                        for art in songs {
                            let word = art.split(separator: "Æ")
                            let artist = word[1]
                            if String(artist).lowercased().trimmingCharacters(in: .whitespacesAndNewlines).contains(searchText.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)) {
                                if !searchedArtistMerchWithToneAllArray.contains(searchMerch) {
                                    searchedArtistMerchWithToneAllArray.append(searchMerch)
                                }
                            }
                        }
                    }
                    if let songs = merch.albums {
                        for art in songs {
                            let word = art.split(separator: "Æ")
                            let artist = word[1]
                            if String(artist).lowercased().trimmingCharacters(in: .whitespacesAndNewlines).contains(searchText.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)) {
                                if !searchedArtistMerchWithToneAllArray.contains(searchMerch) {
                                    searchedArtistMerchWithToneAllArray.append(searchMerch)
                                }
                            }
                        }
                    }
                    if let songs = merch.producers {
                        for art in songs {
                            let word = art.split(separator: "Æ")
                            let artist = word[1]
                            if String(artist).lowercased().trimmingCharacters(in: .whitespacesAndNewlines).contains(searchText.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)) {
                                if !searchedArtistMerchWithToneAllArray.contains(searchMerch) {
                                    searchedArtistMerchWithToneAllArray.append(searchMerch)
                                }
                            }
                        }
                    }
                } else if let merch = searchMerch.apperal {
                    if merch.name.lowercased().trimmingCharacters(in: .whitespacesAndNewlines).contains(searchText.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)) {
                        searchedArtistMerchWithToneAllArray.append(searchMerch)
                    }
                    if let artist = merch.artists {
                        for art in artist {
                            let word = art.split(separator: "Æ")
                            let artist = word[1]
                            if String(artist).lowercased().trimmingCharacters(in: .whitespacesAndNewlines).contains(searchText.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)) {
                                if !searchedArtistMerchWithToneAllArray.contains(searchMerch) {
                                    searchedArtistMerchWithToneAllArray.append(searchMerch)
                                }
                            }
                        }
                    }
                    if let songs = merch.songs {
                        for art in songs {
                            let word = art.split(separator: "Æ")
                            let artist = word[1]
                            if String(artist).lowercased().trimmingCharacters(in: .whitespacesAndNewlines).contains(searchText.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)) {
                                if !searchedArtistMerchWithToneAllArray.contains(searchMerch) {
                                    searchedArtistMerchWithToneAllArray.append(searchMerch)
                                }
                            }
                        }
                    }
                    if let songs = merch.albums {
                        for art in songs {
                            let word = art.split(separator: "Æ")
                            let artist = word[1]
                            if String(artist).lowercased().trimmingCharacters(in: .whitespacesAndNewlines).contains(searchText.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)) {
                                if !searchedArtistMerchWithToneAllArray.contains(searchMerch) {
                                    searchedArtistMerchWithToneAllArray.append(searchMerch)
                                }
                            }
                        }
                    }
                    if let songs = merch.producers {
                        for art in songs {
                            let word = art.split(separator: "Æ")
                            let artist = word[1]
                            if String(artist).lowercased().trimmingCharacters(in: .whitespacesAndNewlines).contains(searchText.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)) {
                                if !searchedArtistMerchWithToneAllArray.contains(searchMerch) {
                                    searchedArtistMerchWithToneAllArray.append(searchMerch)
                                }
                            }
                        }
                    }
                } else if let merch = searchMerch.service {
                    if merch.name.lowercased().trimmingCharacters(in: .whitespacesAndNewlines).contains(searchText.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)) {
                        searchedArtistMerchWithToneAllArray.append(searchMerch)
                    }
                    if let songs = merch.producers {
                        for art in songs {
                            let word = art.split(separator: "Æ")
                            let artist = word[1]
                            if String(artist).lowercased().trimmingCharacters(in: .whitespacesAndNewlines).contains(searchText.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)) {
                                if !searchedArtistMerchWithToneAllArray.contains(searchMerch) {
                                    searchedArtistMerchWithToneAllArray.append(searchMerch)
                                }
                            }
                        }
                    }
                } else if let merch = searchMerch.memorabilia {
                    if merch.name.lowercased().trimmingCharacters(in: .whitespacesAndNewlines).contains(searchText.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)) {
                        searchedArtistMerchWithToneAllArray.append(searchMerch)
                    }
                    if let artist = merch.artists {
                        for art in artist {
                            let word = art.split(separator: "Æ")
                            let artist = word[1]
                            if String(artist).lowercased().trimmingCharacters(in: .whitespacesAndNewlines).contains(searchText.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)) {
                                if !searchedArtistMerchWithToneAllArray.contains(searchMerch) {
                                    searchedArtistMerchWithToneAllArray.append(searchMerch)
                                }
                            }
                        }
                    }
                    if let songs = merch.songs {
                        for art in songs {
                            let word = art.split(separator: "Æ")
                            let artist = word[1]
                            if String(artist).lowercased().trimmingCharacters(in: .whitespacesAndNewlines).contains(searchText.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)) {
                                if !searchedArtistMerchWithToneAllArray.contains(searchMerch) {
                                    searchedArtistMerchWithToneAllArray.append(searchMerch)
                                }
                            }
                        }
                    }
                    if let songs = merch.albums {
                        for art in songs {
                            let word = art.split(separator: "Æ")
                            let artist = word[1]
                            if String(artist).lowercased().trimmingCharacters(in: .whitespacesAndNewlines).contains(searchText.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)) {
                                if !searchedArtistMerchWithToneAllArray.contains(searchMerch) {
                                    searchedArtistMerchWithToneAllArray.append(searchMerch)
                                }
                            }
                        }
                    }
                    if let songs = merch.producers {
                        for art in songs {
                            let word = art.split(separator: "Æ")
                            let artist = word[1]
                            if String(artist).lowercased().trimmingCharacters(in: .whitespacesAndNewlines).contains(searchText.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)) {
                                if !searchedArtistMerchWithToneAllArray.contains(searchMerch) {
                                    searchedArtistMerchWithToneAllArray.append(searchMerch)
                                }
                            }
                        }
                    }
                } else if let merch = searchMerch.instrumentalSale {
                    let word = merch.instrumentaldbid.split(separator: "Æ")
                    let artist = word[1]
                    if artist.lowercased().trimmingCharacters(in: .whitespacesAndNewlines).contains(searchText.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)) {
                        searchedArtistMerchWithToneAllArray.append(searchMerch)
                    }
                    
                }
            }
            for searchVideos in ArtistVideosWithToneAllArray {
                var can = false
                switch searchVideos {
                case is YouTubeData:
                    let video = searchVideos as! YouTubeData
                    if video.title.lowercased().trimmingCharacters(in: .whitespacesAndNewlines).contains(searchText.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)) {
                        for vid in searchedArtistVideosWithToneAllArray {
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
                            searchedArtistVideosWithToneAllArray.append(video)
                        }
                    }
//                    if let merch = video.merch {
//                        for alb in merch {
//                            let word = alb.split(separator: "Æ")
//                            let album = word[1]
//                            if String(album).lowercased().trimmingCharacters(in: .whitespacesAndNewlines).contains(searchText.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)) {
//                                for vid in searchedArtistVideosWithToneAllArray {
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
//                                    searchedArtistVideosWithToneAllArray.append(video)
//                                }
//                            }
//                        }
//                    }
//                    if video.albums != [""] {
//                        for alb in video.albums {
//                            let word = alb.split(separator: "Æ")
//                            let album = word[1]
//                            if String(album).lowercased().trimmingCharacters(in: .whitespacesAndNewlines).contains(searchText.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)) {
//                                for vid in searchedArtistVideosWithToneAllArray {
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
//                                    searchedArtistVideosWithToneAllArray.append(video)
//                                }
//                            }
//                        }
//                    }
//                    for art in video.artist {
//                        let word = art.split(separator: "Æ")
//                        let artist = word[1]
//                        if String(artist).lowercased().trimmingCharacters(in: .whitespacesAndNewlines).contains(searchText.lowercased().trimmingCharacters(in: .whitespacesAndNewlines))  {
//                            for vid in searchedArtistVideosWithToneAllArray {
//                                switch vid {
//                                case is YouTubeData:
//                                    let vide = vid as! YouTubeData
//                                    if vide.title == searchVideos.title {
//                                        can = true
//                                    }
//                                default:
//                                    print("blanca")
//                                }
//                            }
//                            if can == false {
//                                searchedArtistVideosWithToneAllArray.append(video)
//                            }
//                        }
//                    }
//                    for pro in video.producers {
//                        let word = pro.split(separator: "Æ")
//                        let producer = word[1]
//                        if String(producer).lowercased().trimmingCharacters(in: .whitespacesAndNewlines).contains(searchText.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)) {
//                            for vid in searchedArtistVideosWithToneAllArray {
//                                switch vid {
//                                case is YouTubeData:
//                                    let vide = vid as! YouTubeData
//                                    if vide.title == searchVideos.title {
//                                        can = true
//                                    }
//                                default:
//                                    print("blanca")
//                                }
//                            }
//                            if can == false {
//                                searchedArtistVideosWithToneAllArray.append(video)
//                            }
//                        }
//                    }
                    
                default:
                    print("jhgcf")
                }
                
            }
//            for searchAlbums in ArtistAlbumsWithToneAllArray {
//                let album = AlbumData(toneDeafAppId: searchAlbums.toneDeafAppId, instrumentals: searchAlbums.instrumentals, dateRegisteredToApp: searchAlbums.dateRegisteredToApp, timeRegisteredToApp: searchAlbums.timeRegisteredToApp, songs: searchAlbums.songs, videos: searchAlbums.videos, merch: searchAlbums.merch, name: searchAlbums.name, mainArtist: searchAlbums.mainArtist, allArtists: searchAlbums.allArtists, producers: searchAlbums.producers, isActive: searchAlbums.isActive, favoritesOverall: searchAlbums.favoritesOverall, numberofTracks: searchAlbums.numberofTracks, youtubeOfficialAlbumVideo: searchAlbums.youtubeOfficialAlbumVideo, youTubeAudioAlbumVideo: searchAlbums.youTubeAudioAlbumVideo, youtubeAltAlbumVideos: searchAlbums.youtubeAltAlbumVideos, spotifyData: searchAlbums.spotifyData, appleData: searchAlbums.appleData, soundcloudData: searchAlbums.soundcloudData, youtubeMusicData: searchAlbums.youtubeMusicData, amazonData: searchAlbums.amazonData, tidalData: searchAlbums.tidalData, deezerData: searchAlbums.deezerData, spinrillaData: searchAlbums.spinrillaData,napsterData: searchAlbums.napsterData)
//                var newSongsDict:[String:String] = [:]
//                if searchAlbums.name.lowercased().trimmingCharacters(in: .whitespacesAndNewlines).contains(searchText.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)) {
//                    searchedArtistAlbumsWithToneAllArray.append(searchAlbums)
//                }
////                for (num, track) in album.songs {
////                    let word = track.split(separator: "Æ")
////                    let name = word[1]
////                    if name.lowercased().trimmingCharacters(in: .whitespacesAndNewlines).contains(searchText.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)) {
////                        let mysongDict = [num:track]
////                        if newSongsDict == [:] {
////                            newSongsDict = mysongDict
////                        } else {
////                            newSongsDict.merge(mysongDict, uniquingKeysWith: +)
////                        }
////                        if newSongsDict != [:] {
////                            album.songs = newSongsDict
////                            if !searchedArtistAlbumsWithToneAllArray.contains(album) {
////                                searchedArtistAlbumsWithToneAllArray.append(album)
////                            }
////                        }
////                    }
////
////                }
//
//
//            }
            
            DispatchQueue.main.async {[weak self] in
                guard let strongSelf = self else {return}
                strongSelf.artistSongsWithToneTableView.reloadData()
                strongSelf.artistVideosWithToneTableView.reloadData()
                strongSelf.artistAlbumsWithToneTableView.reloadData()
                if searchedArtistSongsWithToneAllArray.count != 0 {
                    strongSelf.artistSongsWithToneTableView.isHidden = false
                    strongSelf.songTitleStack.isHidden = false
                    strongSelf.numberOfSongs.text = String(searchedArtistSongsWithToneAllArray.count)
                } else {
                    strongSelf.artistSongsWithToneTableView.isHidden = true
                    strongSelf.songTitleStack.isHidden = true
                }
                if searchedArtistVideosWithToneAllArray.count != 0 {
                    strongSelf.artistVideosWithToneTableView.isHidden = false
                    strongSelf.videosTitleStack.isHidden = false
                    strongSelf.numberOfVideos.text = String(searchedArtistVideosWithToneAllArray.count)
                } else {
                    strongSelf.artistVideosWithToneTableView.isHidden = true
                    strongSelf.videosTitleStack.isHidden = true
                }
                if searchedArtistAlbumsWithToneAllArray.count != 0 {
                    strongSelf.artistAlbumsWithToneTableView.isHidden = false
                    strongSelf.albumsTitleStack.isHidden = false
                    //strongSelf.albumsCountStack.isHidden = false
                    strongSelf.numberOfAlbums.text = String(searchedArtistAlbumsWithToneAllArray.count)
                } else {
                    strongSelf.artistAlbumsWithToneTableView.isHidden = true
                    strongSelf.albumsTitleStack.isHidden = true
                    //strongSelf.albumsCountStack.isHidden = true
                }
                if searchedArtistMerchWithToneAllArray.count != 0 {
                    strongSelf.artistMerchWithToneCollectionView.isHidden = false
                    strongSelf.merchTitleStack.isHidden = false
                    //albumsCountStack.isHidden = false
                    strongSelf.numberOfMerch.text = String(searchedArtistMerchWithToneAllArray.count)
                } else {
                    strongSelf.artistMerchWithToneCollectionView.isHidden = true
                    strongSelf.merchTitleStack.isHidden = true
                    //albumsCountStack.isHidden = true
                }
                strongSelf.view.layoutSubviews()
                
            }
            
        }
        
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
            searchBar.text = ""
            searchedArtistSongsWithToneAllArray = ArtistSongsWithToneAllArray
            searchedArtistVideosWithToneAllArray = ArtistVideosWithToneAllArray
            searchedArtistAlbumsWithToneAllArray = ArtistAlbumsWithToneAllArray
            artistSongsWithToneTableView.reloadData()
            artistVideosWithToneTableView.reloadData()
            artistAlbumsWithToneTableView.reloadData()
            if searchedArtistSongsWithToneAllArray.count != 0 {
                artistSongsWithToneTableView.isHidden = false
                songTitleStack.isHidden = false
                numberOfSongs.text = String(searchedArtistSongsWithToneAllArray.count)
            } else {
                artistSongsWithToneTableView.isHidden = true
                songTitleStack.isHidden = true
            }
            if searchedArtistVideosWithToneAllArray.count != 0 {
                artistVideosWithToneTableView.isHidden = false
                videosTitleStack.isHidden = false
                numberOfVideos.text = String(searchedArtistVideosWithToneAllArray.count)
            } else {
                artistVideosWithToneTableView.isHidden = true
                videosTitleStack.isHidden = true
            }
        if searchedArtistAlbumsWithToneAllArray.count != 0 {
            artistAlbumsWithToneTableView.isHidden = false
            albumsTitleStack.isHidden = false
            //albumsCountStack.isHidden = false
            numberOfAlbums.text = String(searchedArtistAlbumsWithToneAllArray.count)
        } else {
            artistAlbumsWithToneTableView.isHidden = true
            albumsTitleStack.isHidden = true
            //albumsCountStack.isHidden = true
        }
        if searchedArtistMerchWithToneAllArray.count != 0 {
            artistMerchWithToneCollectionView.isHidden = false
            merchTitleStack.isHidden = false
            //albumsCountStack.isHidden = false
            numberOfMerch.text = String(searchedArtistMerchWithToneAllArray.count)
        } else {
            artistMerchWithToneCollectionView.isHidden = true
            merchTitleStack.isHidden = true
            //albumsCountStack.isHidden = true
        }
            view.layoutSubviews()
            if (scrollview.contentOffset.y < self.lastContentOffset || scrollview.contentOffset.y <= 250) && (self.heightConstraint.constant != self.maxHeaderHeight)  {
                //Scrolling up, scrolled to top
                UIView.animate(withDuration: 0.3) { [weak self] in
                    guard let strongSelf = self else {return}
                    if strongSelf.scrollview.contentOffset.y <= 0.0 {
                        //strongSelf.followButton.alpha = 1
                        strongSelf.heightConstraint.constant = strongSelf.maxHeaderHeight
                        strongSelf.view.layoutIfNeeded()
                    }
                }
            }
            view.endEditing(true)
        
        
    }
    
}

extension ArtistInfoViewController : UITableViewDelegate, UITableViewDataSource, SkeletonTableViewDataSource {
    func collectionSkeletonView(_ skeletonView: UITableView, cellIdentifierForRowAt indexPath: IndexPath) -> ReusableCellIdentifier {
        if skeletonView == artistSongsWithToneTableView {
            return "artistSongsWithToneTableCellController"
        } else if skeletonView == artistVideosWithToneTableView {
            return "artistVideosWithToneTableCellController"
        } else  {
            return "artistAlbumsWithToneTableCellController"
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == artistSongsWithToneTableView {
            musicTableHeight = 220
        } else if tableView == artistVideosWithToneTableView {
            musicTableHeight = 230
        } else if tableView == artistAlbumsWithToneTableView {
            musicTableHeight = 307.5
        }
        return musicTableHeight//Your custom row height
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var numberOfRow = 1
        switch tableView {
        case artistSongsWithToneTableView:
            numberOfRow = 1
        case artistVideosWithToneTableView:
            numberOfRow = 1
        case artistAlbumsWithToneTableView:
            numberOfRow = 1
        default:
            print("Some things Wrong!!")
        }
        return numberOfRow
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == artistVideosWithToneTableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: "artistVideosWithToneTableCellController", for: indexPath) as! ArtistVideosWithToneTableCellController
            if initialLoad == true {
                cell.vcollectionView.reloadData()
                if !searchedArtistVideosWithToneAllArray.isEmpty {
                    cell.funcSetTemp()
                }
            } else {
                if searchedArtistVideosWithToneAllArray.count == ArtistVideosWithToneAllArray.count {
                    cell.funcSetTemp()
                }
            }
            return cell
        } else if tableView == artistAlbumsWithToneTableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: "artistAlbumsWithToneTableCellController", for: indexPath) as! ArtistAlbumsWithToneTableCellController
            if initialLoad == true {
                cell.acollectionView.reloadData()
                if !searchedArtistAlbumsWithToneAllArray.isEmpty {
                    cell.funcSetTemp(info: infoDetailContent)
                }
            } else {
                if searchedArtistAlbumsWithToneAllArray == ArtistAlbumsWithToneAllArray {
                    cell.funcSetTemp(info: infoDetailContent)
                }
            }
            return cell
        }
        else {
            //print(ArtistSongsWithToneAllArrayDashboard)
            let cell = tableView.dequeueReusableCell(withIdentifier: "artistSongsWithToneTableCellController", for: indexPath) as! ArtistSongsWithToneTableCellController
            if initialLoad == true {
                    if !searchedArtistSongsWithToneAllArray.isEmpty {
                        cell.funcSetTemp()
                    }
                    cell.collectionView.reloadData()
            } else {
                if searchedArtistSongsWithToneAllArray == ArtistSongsWithToneAllArray {
                    cell.funcSetTemp()
                }
            }
            return cell
        }
       
        //
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        
        
    }
}

extension ArtistInfoViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return searchedArtistMerchWithToneAllArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let merch = searchedArtistMerchWithToneAllArray[indexPath.item]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "merchContentCollectionCell", for: indexPath) as! MerchContentCollectionCell
        cell.funcSetUp(latestMerch: merch)
        cell.contentView.backgroundColor = Constants.Colors.lightApp
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: artistMerchWithToneCollectionView.frame.width/2-10, height: 320)
    }
    
}



class ArtistSongsWithToneTableViewControlller: UITableView {
    override var intrinsicContentSize: CGSize {
        layoutIfNeeded()
        return CGSize(width: UIView.noIntrinsicMetric, height: contentSize.height)
    }
}

class ArtistSongsWithToneTableCellController: UITableViewCell {
    
    @IBOutlet weak var collectionView: UICollectionView!
    var selectedSong:SongData!
    
    func funcSetTemp() {
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
}

extension ArtistSongsWithToneTableCellController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
        
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return searchedArtistSongsWithToneAllArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            selectedSong = searchedArtistSongsWithToneAllArray[indexPath.item]
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "artistSongsWithToneCollectionViewCellController", for: indexPath) as! ArtistSongsWithToneCollectionViewCellController
            cell.funcSetTemp(song: selectedSong)
            return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        var son:SongData!
            son = searchedArtistSongsWithToneAllArray[indexPath.item]
        NotificationCenter.default.post(name: ArtToInfoSegNotify, object: son)
        
        
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
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 160, height: 220)
    }
    
    
    
}

class ArtistSongsWithToneCollectionViewCellController: UICollectionViewCell {
    
    @IBOutlet weak var songImage: UIImageView!
    @IBOutlet weak var songName: UILabel!
    @IBOutlet weak var songArtist: UILabel!
    @IBOutlet weak var songProducers: UILabel!
    
    override var isHighlighted: Bool {
        didSet{
            tapScale(cell: self, down: isHighlighted)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
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
                        print("Video ID proccessing error \(error)")
                    }
                })
            }
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
            strongSelf.songImage.setImage(from: imageURL, withPlaceholder: UIImage(named: "tonedeaflogo"))
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

class ArtistVideosWithToneTableViewControlller: UITableView {
    override var intrinsicContentSize: CGSize {
        layoutIfNeeded()
        return CGSize(width: UIView.noIntrinsicMetric, height: contentSize.height)
    }
}

class ArtistVideosWithToneTableCellController: UITableViewCell {
    
    @IBOutlet weak var vcollectionView: UICollectionView!
    var selectedVideo:AnyObject!
    
    func funcSetTemp() {
        vcollectionView.delegate = self
        vcollectionView.dataSource = self
    }
    
}

extension ArtistVideosWithToneTableCellController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
        
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return searchedArtistVideosWithToneAllArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            //print(ArtistVideosWithToneAllArrayDashboard, indexPath.item)
            selectedVideo = searchedArtistVideosWithToneAllArray[indexPath.item]
            //print(indexPath.item, selectedVideo.name)
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "artistVideosWithToneCollectionViewCellController", for: indexPath) as! ArtistVideosWithToneCollectionViewCellController
            cell.funcSetTemp(video: selectedVideo)
            return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
            let vid = searchedArtistVideosWithToneAllArray[indexPath.item]
            switch vid {
            case is YouTubeData:
                let video = vid as! YouTubeData
                NotificationCenter.default.post(name: ArtToInfoSegNotify, object: video)
            default:
                print("sumn else dawg")
            }
        
//        currentMusicArtistInfo = MusicFeaturedArtistContentArray[indexPath.item]
//        currentViewFoArtInfo = "CVIEW"
//        NotificationCenter.default.post(name: transitionFromMusicToArtistInfoNotify, object: "CVIEW")
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
            return CGSize(width: 320, height: 230)
    }
    
    
    
}

class ArtistVideosWithToneCollectionViewCellController: UICollectionViewCell {
    
    @IBOutlet weak var videoThumbnail: UIImageView!
    @IBOutlet weak var videoTitle: UILabel!
    @IBOutlet weak var channelTitle: UILabel!
    
    override var isHighlighted: Bool {
        didSet{
            tapScale(cell: self, down: isHighlighted)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
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

class ArtistAlbumsWithToneTableViewControlller: UITableView {
    override var intrinsicContentSize: CGSize {
        layoutIfNeeded()
        return CGSize(width: UIView.noIntrinsicMetric, height: 307.5)
    }
}

class ArtistAlbumsWithToneTableCellController: UITableViewCell {
    
    @IBOutlet weak var acollectionView: UICollectionView!
    var selectedAlbum:AlbumData!
    var index:Int!
    var infoDetailContent:Any!
    var currentIndex = IndexPath(index: 0)
    @IBOutlet weak var page: UIPageControl!
    
    func funcSetTemp(info: Any) {
        infoDetailContent = info
        acollectionView.delegate = self
        acollectionView.dataSource = self
        acollectionView.isPagingEnabled = true
        page.numberOfPages = searchedArtistAlbumsWithToneAllArray.count
    }
    
    override func prepareForReuse() {
        //selectedAlbum = nil
        acollectionView.isPagingEnabled = true
    }
    
}

extension ArtistAlbumsWithToneTableCellController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
        
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return searchedArtistAlbumsWithToneAllArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            selectedAlbum = searchedArtistAlbumsWithToneAllArray[indexPath.item]
            //print(indexPath.item, selectedVideo.name)
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "artistAlbumsWithToneCollectionViewCellController", for: indexPath) as! ArtistAlbumsWithToneCollectionViewCellController
            cell.funcSetTemp(album: selectedAlbum, infoDetailContent: infoDetailContent)
            return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let Album = searchedArtistAlbumsWithToneAllArray[indexPath.item]
        NotificationCenter.default.post(name: ArtToInfoSegNotify, object: Album)
//        currentMusicArtistInfo = MusicFeaturedArtistContentArray[indexPath.item]
//        currentViewFoArtInfo = "CVIEW"
//        NotificationCenter.default.post(name: transitionFromMusicToArtistInfoNotify, object: "CVIEW")
        
        
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

class ArtistAlbumsWithToneCollectionViewCellController: UICollectionViewCell {
    
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
    var infoDetailContent:Any!
    var albummain:AlbumData!
    var albumSongArray:[AlbumSong] = []
    
    override var isHighlighted: Bool {
        didSet{
            tapScale(cell: self, down: isHighlighted)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
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
    
    func funcSetTemp(album: AlbumData, infoDetailContent:Any) {
        self.infoDetailContent = infoDetailContent
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
            albumArtwork.setImage(from: url, withPlaceholder: UIImage(named: "tonedeaflogo"))
            blurredBackground(url: url)
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
        var artist:ArtistData!
            artist = recievedArtistData
        //let semaphore = DispatchSemaphore(value: albummain.songs.count)
//        for (key, song) in albummain.songs {
//            let track = key.replacingOccurrences(of: "Track ", with: "")
//            guard let trackNum = Int(track) else {return}
//            let word = song.split(separator: "Æ")
//            let id = word[0]
//            switch id.count {
//            case 10:
//                if artist.songs.contains(song) {
//                    DatabaseManager.shared.findSongById(songId:  String(id), completion: {[weak self] result in
//                        guard let strongSelf = self else {return}
//                        switch result {
//                        case .success(let foundSong):
//                            let son = AlbumSong(trackNumber: trackNum, song: foundSong)
//                            strongSelf.albumSongArray.append(son)
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
//                tick+=1
//                print("artist dont have instrumentals")
////                DatabaseManager.shared.findInstrumentalById(instrumentalId: song, completion: {[weak self] result in
////                    guard let strongSelf = self else {return}
////                    switch result {
////                    case .success(let foundSong):
////                        let son = AlbumSong(trackNumber: trackNum, song: foundSong)
////                        strongSelf.albumSongArray.append(son)
////                        tick+=1
////                        if tick == strongSelf.albummain.songs.count {
////                            strongSelf.numOfTracks.text = "\(strongSelf.albumSongArray.count) Tracks"
////                            strongSelf.hideskeleton(tableview: strongSelf.albumListTableView)
////                        }
////                    case .failure(let error):
////                        tick+=1
////                        print("Fail \(error)")
////                    }
////
////                })
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

extension ArtistAlbumsWithToneCollectionViewCellController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return albumSongArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        albumSongArray.sort(by: {$0.trackNumber < $1.trackNumber})
        let cell = tableView.dequeueReusableCell(withIdentifier: "albumSongListCell", for: indexPath) as! AlbumsSongsListWithToneTableCellController
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
            infoDetailContent = song
            
            NotificationCenter.default.post(name: ArtToInfoSegNotify, object: infoDetailContent)
        default:
            let song = albumSongArray[indexPath.row].song as! InstrumentalData
            infoDetailContent = song
            NotificationCenter.default.post(name: ArtToInfoSegNotify, object: infoDetailContent)
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
        if array.apple?.applePreviewURL != "" {
            prevurl = array.apple!.applePreviewURL
        } else if array.spotify?.spotifyPreviewURL != "" {
            prevurl = array.spotify!.spotifyPreviewURL
        }
        return prevurl
    }
    
    
}

class AlbumsSongsListWithToneTableViewControlller: UITableView {
    override var intrinsicContentSize: CGSize {
        layoutIfNeeded()
        return CGSize(width: UIView.noIntrinsicMetric, height: 280)
    }
}

class AlbumsSongsListWithToneTableCellController: UITableViewCell {
    
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
