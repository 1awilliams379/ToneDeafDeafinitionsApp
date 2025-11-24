//
//  BeatInfoDetailViewController.swift
//  ToneDeafDeafinitionsApp
//
//  Created by Tone Deaf on 10/11/20.
//  Copyright © 2020 GITEM Solutions. All rights reserved.
//

import UIKit
import SkeletonView
import MarqueeLabel
import FirebaseDatabase
import TagListView
import SPAlert
import CDAlertView

class BeatInfoDetailViewController: UIViewController {
    
    @IBOutlet weak var scrollView1: UIScrollView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var serviceTableView: UITableView!
    @IBOutlet weak var priceTableView: UITableView!
    @IBOutlet weak var tagTableView: UITableView!
    
    var lastContentOffset: CGFloat = 0
    var maxHeaderHeight: CGFloat = 0
    
    @IBOutlet weak var beatImage: UIImageView!
    @IBOutlet weak var beatName: MarqueeLabel!
    @IBOutlet weak var beatProducers: MarqueeLabel!
    @IBOutlet weak var beatRelease: MarqueeLabel!
    @IBOutlet weak var beatTempo: MarqueeLabel!
    @IBOutlet weak var beatKey: MarqueeLabel!
    @IBOutlet weak var beatDownloads: MarqueeLabel!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var background: UIView!
    @IBOutlet weak var blurGradient: UIView!
    
    @IBOutlet weak var tableviewheight: NSLayoutConstraint!
    @IBOutlet weak var servicetableviewheight: NSLayoutConstraint!
    @IBOutlet weak var pricetableviewheight: NSLayoutConstraint!
    @IBOutlet weak var tagtableviewheight: NSLayoutConstraint!
    var backgroundImageView:UIImageView!
    
    var data:[[Any]]!
    var serviceArray:[String] = []
    var priceArray:[String] = []
    var tagdata:[[String]]!
    
    var recievedBeat:BeatData!
    var infoDetailContent:Any!
    var artistInfo:ArtistData!
    var producerInfo:ProducerData!
    
    var typeArray:[String] = []
    var soundsArray:[String] = []
    var videosArray:[Any] = []
    var songsArray:[SongData] = []
    var albumsArray:[AlbumData] = []
    var instrumentalsArray:[InstrumentalData] = []
    var artistsArray:[ArtistData] = []
    var producersArray:[ProducerData] = []
    var skelvar = 0
    var visualEffectView:UIVisualEffectView!
    var favorited = false

    override func viewDidLoad() {
        super.viewDidLoad()
        let nib = UINib(nibName: "Header", bundle: nil)
        tableView.register(nib, forHeaderFooterViewReuseIdentifier: "TableSectionHeader")
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "dots copy"), style: .plain, target: self, action: #selector(moreButtonTapped))
        skelvar = 0
        setBack()
        NotificationCenter.default.addObserver(self, selector: #selector(refresh), name: ExpandCartHeightNotify, object: nil)
        scrollView1.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        serviceTableView.delegate = self
        serviceTableView.dataSource = self
        priceTableView.delegate = self
        priceTableView.dataSource = self
        tagTableView.delegate = self
        tagTableView.dataSource = self
        let queue = DispatchQueue(label: "myakjbjhbhjbjbjunndsfhjhgfdxzvczjvb,hds ZKfhcuewsQueue")
        let group = DispatchGroup()
        let array = [0,1, 2, 3, 4,5]
        
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
                    strongSelf.setUpPriceArray(completion: {
                        strongSelf.hideskeleton3(tableview: strongSelf.priceTableView)
                        print("done \(i)")
                        group.leave()
                    })
                case 2:
                    strongSelf.setUpServiceArray(completion: {
                        strongSelf.hideskeleton2(tableview: strongSelf.serviceTableView)
                        print("done \(i)")
                        group.leave()
                    })
                case 3:
                    strongSelf.setUpProducers(completion: {
                        print("done \(i)")
                        group.leave()
                    })
                case 4:
                        strongSelf.setUpVideos(completion: {
                            print("done \(i)")
                            group.leave()
                        })
                case 5:
                    strongSelf.setUpTagArray(completion: {
                        strongSelf.hideskeleton4(tableview: strongSelf.serviceTableView)
                        print("done \(i)")
                        group.leave()
                    })
                default:
                    print("err")
                }
            }
        }
        
        group.notify(queue: DispatchQueue.main) { [weak self] in
            guard let strongSelf = self else {return}
            print("done!")
            strongSelf.data = [strongSelf.artistsArray,strongSelf.producersArray,strongSelf.songsArray,strongSelf.videosArray,strongSelf.albumsArray,strongSelf.instrumentalsArray]
            strongSelf.hideskeleton(tableview: strongSelf.tableView)
        }
    }
    
    @objc func refresh() {
        priceTableView.reloadData()
        view.layoutSubviews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
            self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
          self.navigationController?.navigationBar.shadowImage = UIImage()
          self.navigationController?.navigationBar.isTranslucent = true
        favorited = false
        favoriteButton.setImage(UIImage(systemName: "heart"), for: .normal)
        favoriteButton.tintColor = .white
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
        for favorite in currentAppUser.favorites {
            if favorite.dbid.contains(recievedBeat.toneDeafAppId) {
                favorited = true
                favoriteButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
                favoriteButton.tintColor = Constants.Colors.redApp
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
    func hidevisualbluinheader() {
        visualEffectView.removeFromSuperview()
        visualEffectView = nil
        if visualEffectView != nil {
            hidevisualbluinheader()
        }
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
    
    func hideskeleton3(tableview: UITableView) {
        skelvar+=1
        DispatchQueue.main.async { [weak self] in
            guard let strongSelf = self else {return}
            print("Hiding skeleton")
            tableview.stopSkeletonAnimation()
            tableview.hideSkeleton(reloadDataAfter: true, transition: .crossDissolve(0.25))
            tableview.reloadData()
            strongSelf.pricetableviewheight.constant = strongSelf.priceTableView.contentSize.height
            strongSelf.view.layoutSubviews()
        }
    }
    
    func hideskeleton4(tableview: UITableView) {
        skelvar+=1
        DispatchQueue.main.async { [weak self] in
            guard let strongSelf = self else {return}
            print("Hiding skeleton")
            tableview.stopSkeletonAnimation()
            tableview.hideSkeleton(reloadDataAfter: true, transition: .crossDissolve(0.25))
            tableview.reloadData()
            strongSelf.tagtableviewheight.constant = strongSelf.tagTableView.contentSize.height
            strongSelf.view.layoutSubviews()
        }
    }
    
    deinit {
        if visualEffectView != nil {
            visualEffectView.removeFromSuperview()
            visualEffectView = nil
        }
        print("📗 Beat Info page being deallocated from memory. OS reclaiming")
        NotificationCenter.default.removeObserver(self)
    }

    func setBack() {
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
          self.navigationController?.navigationBar.shadowImage = UIImage()
          self.navigationController?.navigationBar.isTranslucent = true
        beatImage.layer.cornerRadius = 7
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
        //shareButton.layer.cornerRadius = 7
        favoriteButton.layer.cornerRadius = 7
    }
    
    func setUpHeader(completion: @escaping (() -> Void)) {
        var beatpro:[String] = []
        for pro in recievedBeat.producers {
            DatabaseManager.shared.fetchPersonData(person: pro, completion: {[weak self] result in
                guard let strongSelf = self else {return}
                switch result {
                case .success(let person):
                    beatpro.append(String(person.name))
                    strongSelf.beatProducers.text = beatpro.joined(separator: ", ")
                case .failure(let err):
                    print("dsvgredfxbdfzx"+err.localizedDescription)
                }
            })
        }
        let imageurl = recievedBeat.imageURL
        if let url = URL.init(string: imageurl) {
            blurredBackground(url: url, videoCellView: background)
            if let cachedImage = imageCache.object(forKey: url.absoluteString as NSString) {
                DispatchQueue.main.async { [weak self] in
                    guard let strongSelf = self else {return}
                    strongSelf.beatImage.image = cachedImage
                }
            } else {
                beatImage.setImage(from: url, withPlaceholder: UIImage(named: "tonedeaflogo"))
            }
        }
        DispatchQueue.main.async { [weak self] in
            guard let strongSelf = self else {return}
            strongSelf.beatTempo.text = String(strongSelf.recievedBeat.tempo)
            strongSelf.beatDownloads.text = String(strongSelf.recievedBeat.downloads)
            strongSelf.beatName.text = strongSelf.recievedBeat.name
            strongSelf.beatRelease.text = strongSelf.recievedBeat.date.replacingOccurrences(of: "August", with: "Aug").replacingOccurrences(of: "January", with: "Jan").replacingOccurrences(of: "February", with: "Feb").replacingOccurrences(of: "March", with: "Mar").replacingOccurrences(of: "April", with: "Apr").replacingOccurrences(of: "May", with: "May").replacingOccurrences(of: "June", with: "June").replacingOccurrences(of: "July", with: "July").replacingOccurrences(of: "September", with: "Sep").replacingOccurrences(of: "October", with: "Oct").replacingOccurrences(of: "November", with: "Nov").replacingOccurrences(of: "December", with: "Dec")
            strongSelf.beatKey.text = strongSelf.recievedBeat.key.replacingOccurrences(of: "Minor", with: "Min").replacingOccurrences(of: "Major", with: "Maj")
        }
        completion()
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
    
    func setUpServiceArray(completion: @escaping (() -> Void)) {
        serviceArray = []
        if recievedBeat.soundcloud?.url != nil {
            serviceArray.append("soundcloud")
        }
        if recievedBeat.officialVideo != nil, recievedBeat.officialVideo != "" {
            serviceArray.append("ytbt")
        }
        completion()
    }
    
    func setUpPriceArray(completion: @escaping (() -> Void)) {
        serviceArray = []
        if recievedBeat.exclusivePrice != nil && recievedBeat.exclusiveFilesURL != nil {
            priceArray.append("exclusive")
        }
        if recievedBeat.wavPrice != nil && recievedBeat.wavURL != nil {
            priceArray.append("wav")
        }
        if recievedBeat.mp3Price != nil {
            priceArray.append("mp3")
        } else {
            priceArray.append("free")
        }
        completion()
    }
    
    func setUpTagArray(completion: @escaping (() -> Void)) {
        typeArray = recievedBeat.types
        soundsArray = recievedBeat.sounds
        tagdata = [typeArray,soundsArray]
        completion()
    }
    
    func setUpProducers(completion: @escaping (() -> Void)) {
        var tick = 0
        for pro in recievedBeat.producers {
                let word = pro.split(separator: "Æ")
                let id = word[0]
                DatabaseManager.shared.fetchPersonData(person: String(id), completion: {[weak self] producer in
                    guard let strongSelf = self else {return}
//                    strongSelf.producersArray.append(producer)
                    tick+=1
                    if tick == strongSelf.recievedBeat.producers.count {
                        completion()
                    }
                })
            }
    }
    
    func setUpVideos(completion: @escaping (() -> Void)) {
        var tick = 0
        if recievedBeat.videos != [""] {
            for pro in recievedBeat.videos {
                let word = pro.split(separator: "Æ")
                let id = word[0]
                DatabaseManager.shared.findVideoById(videoid: String(id), completion: {[weak self] result in
                    guard let strongSelf = self else {return}
                    switch result {
                    case .success(let video):
                        strongSelf.videosArray.append(video)
                        tick+=1
                        if tick == strongSelf.recievedBeat.videos.count {
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "beatToInfo" {
            if let viewController: InfoDetailViewController = segue.destination as? InfoDetailViewController {
                if visualEffectView != nil {
                    visualEffectView.removeFromSuperview()
                    visualEffectView = nil
                }
                viewController.content = infoDetailContent
            }
        } else if segue.identifier == "beatToArt" {
            if let viewController: ArtistInfoViewController = segue.destination as? ArtistInfoViewController {
                if visualEffectView != nil {
                    visualEffectView.removeFromSuperview()
                    visualEffectView = nil
                }
                recievedArtistData = artistInfo
            }
        } else if segue.identifier == "beatToPro" {
            if let viewController: ProducerInfoViewController = segue.destination as? ProducerInfoViewController {
                if visualEffectView != nil {
                    visualEffectView.removeFromSuperview()
                    visualEffectView = nil
                }
                recievedProducerData = producerInfo
            }
        }
    }
    
    @IBAction func favoriteTapped(_ sender: Any) {
            switch favorited {
            case true:
                favorited = false
                favoriteButton.setImage(UIImage(systemName: "heart"), for: .normal)
                favoriteButton.tintColor = .white
                let id = "\(recievedBeat.toneDeafAppId)Æ\(recievedBeat.name)"
                var newfav:[UserFavorite] = []
                for fav in currentAppUser.favorites {
                    if fav.dbid != id {
                        newfav.append(fav)
                    }
                }
                currentAppUser.favorites = newfav
                Database.database().reference().child("Users").child(currentAppUser.uid).child("Favorites").child(id).removeValue()
                DatabaseManager.shared.getBeatFavorites(currentBeat: recievedBeat, completion: {[weak self] favs in
                    guard let strongSelf = self else {return}
                    var num = favs
                    num-=1
                    Database.database().reference().child("Beats").child(strongSelf.recievedBeat.priceType).child(strongSelf.recievedBeat.beatID).child("Number of Favorites").setValue(num)
                })
            default:
                favorited = true
                lightImpactGenerator.impactOccurred()
                tapScale(button: favoriteButton)
                favoriteButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
                favoriteButton.tintColor = Constants.Colors.redApp
                let id = "\(recievedBeat.toneDeafAppId)Æ\(recievedBeat.name)"
                let datee = getCurrentLocalDate()
                let dateFormatter = DateFormatter()
                dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
                dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
                let date = dateFormatter.date(from:datee)!
                currentAppUser.favorites.append(UserFavorite(dbid: id, timestamp: date))
                Database.database().reference().child("Users").child(currentAppUser.uid).child("Favorites").child(id).child("Timestamp").setValue(datee)
                DatabaseManager.shared.getBeatFavorites(currentBeat: recievedBeat, completion: {[weak self] favs in
                    guard let strongSelf = self else {return}
                    var num = favs
                    num+=1
                    print(num)
                    Database.database().reference().child("Beats").child(strongSelf.recievedBeat.priceType).child(strongSelf.recievedBeat.beatID).child("Number of Favorites").setValue(num)
                })
            }
        
    }
    
    @objc func moreButtonTapped() {
        let vc = UIActivityViewController(activityItems: ["https://www.instagram.com/p/CFDTWydAHfe/?igshid=1t9t6pubzu1u0"], applicationActivities: [GoToInstagramProfileActivity()])
        vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(vc, animated: true, completion: nil)
    }
}

extension BeatInfoDetailViewController: UIScrollViewDelegate {
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
                if !(scrollView.contentOffset.y < self.lastContentOffset || scrollView.contentOffset.y <= 0) {
                    
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
            else if (scrollView.contentOffset.y < self.lastContentOffset || scrollView.contentOffset.y <= 0)// && (self.heightConstraint.constant != self.maxHeaderHeight)
            {
                //Scrolling up, scrolled to top
                //print(scrollView.contentOffset.y)
                if scrollView.contentOffset.y <= 0 {
                    UIView.animate(withDuration: 0.2) { [weak self] in
                        guard let strongSelf = self else {return}
                        //print(strongSelf.lastContentOffset)
                        
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
                if !(scrollView.contentOffset.y < lastContentOffset || scrollView.contentOffset.y <= 0) {
                    UIView.animate(withDuration: 0.2) { [weak self] in
                        guard let strongSelf = self else {return}
                        //print(strongSelf.lastContentOffset)
                        if strongSelf.visualEffectView == nil {
                            strongSelf.visualEffectView   = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
                            guard let nframe = (strongSelf.navigationController?.navigationBar.bounds.insetBy(dx: 0, dy: -10).offsetBy(dx: 0, dy: -10)) else {return}
                            strongSelf.visualEffectView.frame = nframe
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

extension BeatInfoDetailViewController: UITableViewDataSource, UITableViewDelegate, SkeletonTableViewDataSource {
    func collectionSkeletonView(_ skeletonView: UITableView, cellIdentifierForRowAt indexPath: IndexPath) -> ReusableCellIdentifier {
        switch tableView {
        case tagTableView:
            return "beatTypeCell"
        case priceTableView:
            return "beatPriceCell"
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
        case tagTableView:
            if section == 0 {
                if self.tableView(tableView, numberOfRowsInSection: section) > 0 {
                    sectitle = "Type"
                } else {
                    return nil
                }
            } else {
                if self.tableView(tableView, numberOfRowsInSection: section) > 0 {
                    sectitle = "Sounds"
                } else {
                    return nil
                }
            }
        case priceTableView:
            sectitle = "Download"
        case serviceTableView:
            sectitle = "Listen"
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
                    sectitle = "Songs"
                } else {
                    return nil
                }
            } else if section == 3 {
                if self.tableView(tableView, numberOfRowsInSection: section) > 0 {
                    sectitle = "Videos"
                } else {
                    return nil
                }
            } else if section == 4 {
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
        switch tableView {
        case tagTableView:
            numberOfSections = 2
        case priceTableView:
            numberOfSections = 1
        case serviceTableView:
            numberOfSections = 1
        default:
            if data != nil, !data.isEmpty {
                numberOfSections = data.count
            }
        }
        return numberOfSections
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var numberOfRows = 0
        switch tableView {
        case tagTableView:
            if tagdata != nil, !tagdata.isEmpty {
                numberOfRows = 1
            }
        case priceTableView:
            numberOfRows = priceArray.count
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
        case tagTableView:
            tableView.rowHeight = UITableView.automaticDimension
            tableView.estimatedRowHeight = 50
            return tableView.rowHeight
        case priceTableView:
            return 50
        case serviceTableView:
            return 60
        default:
            return 80
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch tableView {
        case tagTableView:
            switch indexPath.section {
            case 0:
                let cell = tableView.dequeueReusableCell(withIdentifier: "beatTypeCell", for: indexPath) as! BeatTagTableCell
                if !typeArray.isEmpty {
                    let array = tagdata[indexPath.section]
                    cell.funcSetTemp(array: array)
                }
                return cell
            default:
                let cell = tableView.dequeueReusableCell(withIdentifier: "beatSoundCell", for: indexPath) as! BeatTagTableCell
                if !soundsArray.isEmpty {
                    let array = tagdata[indexPath.section]
                    cell.funcSetTemp(array: array)
                }
                return cell
            }
        case priceTableView:
            let cell = tableView.dequeueReusableCell(withIdentifier: "beatPriceCell", for: indexPath) as! BeatPriceTableCell
            if !priceArray.isEmpty {
                switch priceArray[indexPath.row] {
                case "exclusive":
                    let string = priceArray[indexPath.row]
                    guard let ex = recievedBeat.exclusivePrice else {
                        fatalError()
                    }
                    cell.funcSetTemp(exclusive: string, price: ex, beat: recievedBeat)
                case "wav":
                    let string = priceArray[indexPath.row]
                    guard let wav = recievedBeat.wavPrice else {
                        fatalError()
                    }
                    cell.funcSetTemp(wav: string, price: wav, beat: recievedBeat)
                case "mp3":
                    guard let mp3 = recievedBeat.mp3Price else {
                        fatalError()
                    }
                    let string = priceArray[indexPath.row]
                    cell.funcSetTemp(mp3: string, price: mp3, beat: recievedBeat)
                default:
                    let string = priceArray[indexPath.row]
                    cell.funcSetTemp(free: string)
                }
            }
            return cell
        case serviceTableView:
            let cell = tableView.dequeueReusableCell(withIdentifier: "infoViewNowCell", for: indexPath) as! InfoViewNowTableCell
            if !serviceArray.isEmpty {
                switch serviceArray[indexPath.row] {
                case "ytbt":
                    let string = serviceArray[indexPath.row]
                    cell.funcSetTemp(ytbt: string)
                case "soundcloud":
                    let string = serviceArray[indexPath.row]
                    cell.funcSetTemp(soundcloud: string)
                default:
                    print("errrr")
                }
            }
            return cell
        default:
            switch indexPath.section {
            case 0:
                let cell = tableView.dequeueReusableCell(withIdentifier: "infoDetailCell", for: indexPath) as! InfoDetailTableCell
                if !artistsArray.isEmpty {
                    let video = data[indexPath.section][indexPath.row] as! ArtistData
                    cell.funcSetTemp(artist: video)
                }
                return cell
            case 1:
                let cell = tableView.dequeueReusableCell(withIdentifier: "infoDetailCell", for: indexPath) as! InfoDetailTableCell
                if !producersArray.isEmpty {
                    let video = data[indexPath.section][indexPath.row] as! ProducerData
                    cell.funcSetTemp(producer: video)
                }
                return cell
            case 2:
                let cell = tableView.dequeueReusableCell(withIdentifier: "infoDetailCell", for: indexPath) as! InfoDetailTableCell
                if !songsArray.isEmpty {
                    let video = data[indexPath.section][indexPath.row] as! SongData
                    cell.funcSetTemp(song: video)
                }
                return cell
            case 3:
                let cell = tableView.dequeueReusableCell(withIdentifier: "infoVideoDetailCell", for: indexPath) as! InfoVideoDetailTableCell
                if !videosArray.isEmpty {
                    let video = data[indexPath.section][indexPath.row] as! VideoData
                    cell.funcSetTemp(video: video)
                }
                return cell
            case 4:
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
        case priceTableView:
            if priceArray[indexPath.row] != "free" {
                var icon:UIImage!
                switch priceArray[indexPath.row] {
                case "mp3":
                    icon = UIImage(named: "mp3-file")!.withTintColor(.white)
                case "wav":
                    icon = UIImage(named: "wav-file")!.withTintColor(.white)
                default:
                    icon = UIImage(named: "zip-file")!.withTintColor(.white)
                }
                let product = Product(id: "\(recievedBeat.toneDeafAppId)Æ\(recievedBeat.name)Æ\(priceArray[indexPath.row])", dbid: "\(recievedBeat.toneDeafAppId)Æ\(recievedBeat.name)", name: recievedBeat.name, price: 0.0, thumbnailURL: recievedBeat.imageURL, type: priceArray[indexPath.row].capitalizingFirstLetter(), involved: recievedBeat.producers)
                var inCart = false
                for index in 0..<userCart.count {
                    let item = userCart[index].product
                    if item.id == product.id {
                        inCart = true
                        let actionSheet = CDAlertView(title: "Remove \"\(recievedBeat.name)\" \(priceArray[indexPath.row].capitalizingFirstLetter()) Liscense from Cart?", message: "\(priceArray[indexPath.row].capitalizingFirstLetter()) License", type: .custom(image: icon))
                        actionSheet.alertBackgroundColor = Constants.Colors.extralightApp
                        actionSheet.circleFillColor = .black
                        actionSheet.titleTextColor = .white
                        actionSheet.messageTextColor = .white
                        let cancel = CDAlertViewAction(title: "Cancel", font: UIFont.systemFont(ofSize: 16), textColor: Constants.Colors.redApp, backgroundColor: Constants.Colors.extralightApp, handler: nil)
                        actionSheet.add(action: cancel)
                        actionSheet.add(action: CDAlertViewAction(title: "Remove", font: UIFont.boldSystemFont(ofSize: 16), textColor: Constants.Colors.redApp, backgroundColor: Constants.Colors.extralightApp, handler: {_ in
                            userCart.remove(at: index)
                            tableView.reloadData()
                            return true
                        }))
                        actionSheet.show()
                        //NotificationCenter.default.post(name: OpenTheAlertNotify, object: actionSheet)
                        return
                    }
                }
                if !priceArray.isEmpty && inCart == false {
                    let actionSheet = CDAlertView(title: "Add \"\(recievedBeat.name)\" \(priceArray[indexPath.row].capitalizingFirstLetter()) License to Cart?", message: "\(priceArray[indexPath.row].capitalizingFirstLetter()) License", type: .custom(image: icon))
                    actionSheet.alertBackgroundColor = Constants.Colors.extralightApp
                    actionSheet.circleFillColor = .black
                    actionSheet.titleTextColor = .white
                    actionSheet.messageTextColor = .white
                    let cancel = CDAlertViewAction(title: "Cancel", font: UIFont.systemFont(ofSize: 16), textColor: Constants.Colors.redApp, backgroundColor: Constants.Colors.extralightApp, handler: nil)
                    actionSheet.add(action: cancel)
                    actionSheet.add(action: CDAlertViewAction(title: "Add", font: UIFont.boldSystemFont(ofSize: 16), textColor: Constants.Colors.redApp, backgroundColor: Constants.Colors.extralightApp, handler: {[weak self]_ in
                        guard let strongSelf = self else {return false}
                        switch strongSelf.priceArray[indexPath.row] {
                        case "exclusive":
                            product.price = strongSelf.recievedBeat.exclusivePrice!
                        case "wav":
                            product.price = strongSelf.recievedBeat.wavPrice!
                        case "mp3":
                            product.price = strongSelf.recievedBeat.mp3Price!
                        default:
                            fatalError()
                        }
                        userCart.add(product)
                        tableView.reloadData()
                        return true
                    }))
                    actionSheet.show()
                    //NotificationCenter.default.post(name: OpenTheAlertNotify, object: actionSheet)
                }
            } else {
                let actionSheet = CDAlertView(title: "Download \"\(recievedBeat.name)\"?", message: "Mp3 Lease License", type: .custom(image: UIImage(named: "mp3-file")!.withTintColor(.white)))
                actionSheet.alertBackgroundColor = Constants.Colors.extralightApp
                actionSheet.circleFillColor = .black
                actionSheet.titleTextColor = .white
                actionSheet.messageTextColor = .white
                let cancel = CDAlertViewAction(title: "Cancel", font: UIFont.systemFont(ofSize: 16), textColor: Constants.Colors.redApp, backgroundColor: Constants.Colors.extralightApp, handler: nil)
                actionSheet.add(action: cancel)
                actionSheet.add(action: CDAlertViewAction(title: "Download", font: UIFont.boldSystemFont(ofSize: 16), textColor: Constants.Colors.redApp, backgroundColor: Constants.Colors.extralightApp, handler: {[weak self]_ in
                    guard let strongSelf = self else {return false}
                    DownloadManager.shared.startDownload(beat: strongSelf.recievedBeat, exten: ".mp3")
                    return true
                }))
                actionSheet.show()
                //NotificationCenter.default.post(name: OpenTheAlertNotify, object: actionSheet)
            }
        case serviceTableView:
            switch serviceArray[indexPath.row] {
            case "ytbt":
                    let progressHUD = ProgressHUD(text: "Preparing...")
                      self.view.addSubview(progressHUD)
                    let word = recievedBeat.officialVideo!.split(separator: "Æ")
                    let id = word[0]
                    DatabaseManager.shared.findVideoById(videoid: String(id), completion: { result in
                        switch result {
                        case.success(let video):
                            let yt = video as! YouTubeData
                            currentPlayingYoutubeVideo = yt
                            progressHUD.stopAnimation()
                            progressHUD.removeFromSuperview()
                            NotificationCenter.default.post(name: YoutubePlayNotify, object: nil)
                        case.failure(let errr):
                            print("handg \(errr)")
                        }
                    })
            
            case "soundcloud":
                    let actionSheet = UIAlertController(title: "Open \(recievedBeat.name) in Soundcloud?",
                                                        message: "If you don't have Soundcloud, \(recievedBeat.name) will open in Safari.",
                                                        preferredStyle: .alert)
                    actionSheet.addAction(UIAlertAction(title: "Open",
                                                  style: .default,
                                                  handler: {[weak self] _ in
                                                    guard let strongSelf = self else {return}
                                                    let url = URL(string: strongSelf.recievedBeat.soundcloud!.url)
                                                    if UIApplication.shared.canOpenURL(url!)
                                                    {
                                                        UIApplication.shared.open(url!, options: [:], completionHandler: nil)
                                                    } else {
                                                        //redirect to safari because the user doesn't have Instagram
                                                            UIApplication.shared.open(URL(string: "http://soundcloud.com/")!, options: [:], completionHandler: nil)
                                                    }
                    }))
                    actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                    NotificationCenter.default.post(name: OpenTheAlertNotify, object: actionSheet)
            default:
                print("jahfdgjs")
            }
        case tagTableView:
            print("TODO")
        case priceTableView:
            print("TODO")
        default:
            switch indexPath.section {
            case 0:
                let artist = data[indexPath.section][indexPath.row] as! ArtistData
                artistInfo = artist
                performSegue(withIdentifier: "beatToArt", sender: nil)
            case 1:
                let producer = data[indexPath.section][indexPath.row] as! ProducerData
                producerInfo = producer
                performSegue(withIdentifier: "beatToPro", sender: nil)
            case 2:
                let song = data[indexPath.section][indexPath.row] as! SongData
                infoDetailContent = song
                performSegue(withIdentifier: "beatToInfo", sender: nil)
            case 3:
                let video = data[indexPath.section][indexPath.row] as AnyObject
                infoDetailContent = video
                performSegue(withIdentifier: "beatToInfo", sender: nil)
            case 4:
                let album = data[indexPath.section][indexPath.row] as! AlbumData
                infoDetailContent = album
                performSegue(withIdentifier: "beatToInfo", sender: nil)
            default:
                let instrumental = data[indexPath.section][indexPath.row] as! InstrumentalData
                infoDetailContent = instrumental
                performSegue(withIdentifier: "beatToInfo", sender: nil)
            }
        }
    }
}

class BeatPriceTableCell: UITableViewCell {
    
    @IBOutlet weak var cartImage: UIImageView!
    @IBOutlet weak var priceType: MarqueeLabel!
    @IBOutlet weak var sellPrice: MarqueeLabel!
    
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        sellPrice.text = ""
        priceType.text = ""
        cartImage.image = UIImage(systemName: "cart.badge.plus")
        cartImage.tintColor = Constants.Colors.redApp
    }
    
    func funcSetTemp(exclusive: String, price: Double, beat: BeatData) {
        sellPrice.text = price.dollarString
        priceType.text = "Exclusive License & Stems"
        for index in 0..<userCart.count {
            let item = userCart[index].product
            if item.id.contains(beat.toneDeafAppId) && item.id.contains("exclusive") {
                cartImage.image = UIImage(systemName: "cart.fill")
                cartImage.tintColor = .green
                sellPrice.text = "In Cart"
            }
        }
    }
    func funcSetTemp(wav: String, price: Double, beat: BeatData) {
        sellPrice.text = price.dollarString
        priceType.text = "Wav Lease"
        for index in 0..<userCart.count {
            let item = userCart[index].product
            if item.id.contains(beat.toneDeafAppId) && item.id.contains("wav") {
                cartImage.image = UIImage(systemName: "cart.fill")
                cartImage.tintColor = .green
                sellPrice.text = "In Cart"
            }
        }
    }
    func funcSetTemp(mp3: String, price: Double, beat: BeatData) {
        sellPrice.text = price.dollarString
        priceType.text = "Mp3 Lease"
        for index in 0..<userCart.count {
            let item = userCart[index].product
            if item.id.contains(beat.toneDeafAppId) && item.id.contains("mp3") {
                cartImage.image = UIImage(systemName: "cart.fill")
                cartImage.tintColor = .green
                sellPrice.text = "In Cart"
            }
        }
    }
    func funcSetTemp(free: String) {
        sellPrice.text = "Download"
        priceType.text = "Free"
        cartImage.image = UIImage(named: "tablerdownload")
        cartImage.tintColor = .white
    }
}

class BeatTagTableCell: UITableViewCell {
    
    @IBOutlet weak var tagList: TagListView!
    
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        
    }
    
    func funcSetTemp(array: [String]) {
        tagList.textFont = UIFont(name: "AvenirNextCondensed-DemiBold", size: 14)!
        tagList.alignment = .left
        tagList.addTags(array)
    }
}

extension BeatInfoDetailViewController: CartDelegate {
    func cart<T>(_ cart: Cart<T>, itemsDidChangeWithType type: CartItemChangeType) where T : ProductProtocol {

        switch type {
        case .add(at: let index):
            
            priceTableView.reloadData()

        case .increment(at: let index), .decrement(at: let index):
            priceTableView.reloadData()
//            let indexPath = IndexPath(row: index, section: 0)
//            let cell = tableView.cellForRow(at: indexPath) as! MyTableViewCell
//            cell.quantityLabel.text = String(items[index].quantity)

        case .delete(at: let index):
            
            priceTableView.reloadData()
//            let indexPath = IndexPath(row: index, section: 0)
//            tableView.deleteRows(at: [indexPath], with: .automatic)

        case .clean:
            priceTableView.reloadData()
//            if let all = tableView.indexPathsForVisibleRows {
//                tableView.deleteRows(at: all, with: .automatic)
//            }
        }
    }
}
