//
//  DashboardTabBarViewController.swift
//  ToneDeafDeafinitionsApp
//
//  Created by Tone Deaf on 8/2/20.
//  Copyright © 2020 GITEM Solutions. All rights reserved.
//
import UIKit
import Foundation
import FirebaseAuth
import FirebaseDatabase
import SwiftUI
import SideMenu
import SPStorkController
import SPFakeBar
import WebKit
import CDAlertView

let AccountTypeChangeOrUpdateToNotificationKey = "com.gitemsolutions.AccountTypeChanged"

let AccountChangedNotify = Notification.Name(AccountTypeChangeOrUpdateToNotificationKey)

let profileSideMenu = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "ProfileSideNC") as SideMenuNavigationController

var audioPlayerViewController: AudioPlayerViewController!
var youtubeVideoViewController: YoutubeVideoPlayerViewController!
var playervisualEffectView: UIVisualEffectView!

var TABBARPLAYERHEIGHT:CGFloat = 122.5
protocol AccountStatusUpdateDelegate {
    func accountTypeChanged(acctype: String, user: User, uid: String)
}

var MusicMainInfiniteScrollContentFeaturedArray1:Array<Any> = []
var MusicMainInfiniteScrollContentFeaturedArray2:Array<Any> = []
var MusicMainInfiniteScrollContentFeaturedArray3:Array<Any> = []
var MusicMainInfiniteScrollContentFeaturedArray4:Array<Any> = []
var MusicMainInfiniteScrollContentFeaturedArray5:Array<Any> = []
var MusicMainInfiniteScrollContentFeaturedArray6:Array<Any> = []
var MusicMainInfiniteScrollContentFeaturedArray7:Array<Any> = []




class DashboardTabBarViewController: UITabBarController {
    
    static let shared = DashboardTabBarViewController()
    
    enum CardState {
        case expanded
        case collapsed
    }
    var popupWindow: UIWindow?
    var observercount = 0
    
    var cardHeight: CGFloat = 0
    let cardHandleAreaHeight:CGFloat = 65
    
    var cardVisible = false
    var nextState:CardState {
        return cardVisible ? .collapsed: .expanded
    }
    
    var runningAnimations = [UIViewPropertyAnimator]()
    var animationProgressWhenInterrupted:CGFloat = 0
    
    public var AccountStatusDelegate: AccountStatusUpdateDelegate!
    
    
    let documentInteractionController = UIDocumentInteractionController()
    var destinationUrl:URL!
    var downloadTask: URLSessionDownloadTask?
    var session: URLSession?
    var beatToDownload:BeatData!

    override func viewDidLoad() {
        super.viewDidLoad()
        profileSideMenu.presentingViewControllerUserInteractionEnabled = true
        TABBARPLAYERHEIGHT = view.frame.height - 2.5*(tabBar.frame.height)
        //print(view.frame.height, 1.5*(tabBar.frame.height), TABBARPLAYERHEIGHT)
        self.delegate = self
        delegate()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if observercount == 0 {
            createObservers()
        }
        observercount+=1
        
        //setFeaturedArtistContent()
    }
    
    public func delegate() {
        AccountStatusDelegate = DashboardViewController()
        
    }
    
    func deallocate() {
        NotificationCenter.default.removeObserver(self)
        NotificationCenter.default.removeObserver(self)
        NotificationCenter.default.removeObserver(self)
    }
    
    func createObservers(){
            NotificationCenter.default.addObserver(self, selector: #selector(DashboardTabBarViewController.audioPlayerOn), name: AudioPlayerOnNotify, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(DashboardTabBarViewController.audioPlayerOnSong), name: AudioPlayerOnSongNotify, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(DashboardTabBarViewController.audioPlayerOnInstrumental), name: AudioPlayerOnInstrumentalNotify, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(openAlert(notificantion:)), name: OpenTheAlertNotify, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(openSheet(notificantion:)), name: OpenTheSheetNotify, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(openShare(notificantion:)), name: OpenTheShareNotify, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(openCart(notificantion:)), name: OpenTheCartNotify, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(openDocShare(notificantion:)), name: OpenTheDocShareNotify, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(downloadBeat(notificantion:)), name: DownloadBeatNotify, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(openCheckout(notificantion:)), name: OpenTheCheckOutNotify, object: nil)
        //NotificationCenter.default.addObserver(self, selector: #selector(openWebView(notificantion:)), name: OpenWebViewWithURLNotify, object: nil)
      }
    
    @objc func openCart(notificantion:Notification) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(identifier: "cartViewController") as! CartViewController
        let transitionDelegate = SPStorkTransitioningDelegate()
        controller.transitioningDelegate = transitionDelegate
        transitionDelegate.storkDelegate = self
        transitionDelegate.customHeight = 350
        controller.modalPresentationStyle = .custom
        controller.modalPresentationCapturesStatusBarAppearance = true
        transitionDelegate.showCloseButton = false
        present(controller, animated: true,completion: nil)
    }
    
    @objc func openCheckout(notificantion:Notification) {
        performSegue(withIdentifier: "toCheckout", sender: nil)
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        let myVC = storyboard.instantiateViewController(withIdentifier: "checkoutViewController")
//        let navController = UINavigationController(rootViewController: myVC)
//
//        present(navController, animated: true, completion: nil)
    }
    
    @objc func openWebView(notificantion:Notification) {
        let fileServerWebView = WKWebView(frame: view.frame)
        let url = (notificantion.object as! URL)
        let request = URLRequest(url: url as URL)
        fileServerWebView.load(request)
    }
    
    @objc func openShare(notificantion:Notification) {
        let ac = notificantion.object as! UIActivityViewController
        ac.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(ac, animated: true, completion: nil)
    }
    
    @objc func openAlert(notificantion:Notification) {
        print(notificantion.object)
        
        let ac = notificantion.object as! CDAlertView
        ac.show()
    }
    
    @objc func openDocShare(notificantion:Notification) {
        let dic = notificantion.object as! UIDocumentInteractionController
        dic.presentOptionsMenu(from: view.frame, in: view, animated: true)
    }
    
    @objc func downloadBeat(notificantion:Notification) {
        beatToDownload = (notificantion.object as! BeatData)
        
        //downloadAndSaveAudioFile(beatToDownload.audioURL)
    }
    
    @objc func openSheet(notificantion:Notification) {
    }
    
    func share(url: URL) {
        documentInteractionController.url = url
        documentInteractionController.uti = url.typeIdentifier ?? "public.data, public.content"
        documentInteractionController.name = url.localizedName ?? url.lastPathComponent
        NotificationCenter.default.post(name: OpenTheDocShareNotify, object: documentInteractionController)
    }
    
    
    func downloadAndSaveAudioFile(_ audioFile: String) {
        //Create directory if not present
        let paths = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.libraryDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
        let documentDirectory = paths.first! as NSString
        let soundDirPathString = documentDirectory.appendingPathComponent("Sounds")
        do {
            try FileManager.default.createDirectory(atPath: soundDirPathString, withIntermediateDirectories: true, attributes:nil)
            print("directory created at \(soundDirPathString)")
        } catch let error as NSError {
            print("error while creating dir : \(error.localizedDescription)");
        }
        if let audioUrl = URL(string: audioFile) {     //http://freetone.org/ring/stan/iPhone_5-Alarm.mp3
            // create your document folder url
            let documentsUrl =  FileManager.default.urls(for: .libraryDirectory, in: .userDomainMask).first! as URL
            let documentsFolderUrl = documentsUrl.appendingPathComponent("Sounds")
            // your destination file url
            destinationUrl = documentsFolderUrl.appendingPathComponent(audioUrl.lastPathComponent)
            print(destinationUrl)
            // check if it exists before downloading it
            if FileManager().fileExists(atPath: destinationUrl.path) {
                print("The file already exists at path")
                let configuration = URLSessionConfiguration.default
                let operationQueue = OperationQueue()
                let session = URLSession(configuration: configuration, delegate: self, delegateQueue: operationQueue)
                session.dataTask(with: destinationUrl.absoluteURL) {[weak self] data, response, error in
                    guard let strongSelf = self else {return}
                    guard let data = data, error == nil else { return }
                    var proarray:[String] = []
                    for pro in strongSelf.beatToDownload.producers {
                        let word = pro.split(separator: "Æ")
                        let name = word[1]
                        proarray.append(String(name))
                    }
                    let tmpURL = FileManager.default.temporaryDirectory
                        .appendingPathComponent("\(strongSelf.beatToDownload.name) Produced by [\(proarray.joined(separator: ", "))] \(strongSelf.beatToDownload.tempo)BPM \(strongSelf.beatToDownload.key.replacingOccurrences(of: "/ ", with: "-")) .mp3")
                    do {
                        try data.write(to: tmpURL)
                        DispatchQueue.main.async {[weak self] in
                            guard let strongSelf = self else {return}
                            strongSelf.share(url: tmpURL)
                        }
                    } catch {
                        print(error)
                    }
                    
                }.resume()
            } else {
                //  if the file doesn't exist
                //  just download the data from your url
                DispatchQueue.global(qos: DispatchQoS.QoSClass.background).async(execute: {
                    let configuration = URLSessionConfiguration.background(withIdentifier: "backgroundSession")
                    self.session = URLSession(configuration: configuration, delegate: self, delegateQueue: OperationQueue.main)
                    self.downloadTask = self.session?.downloadTask(with: audioUrl)
                    self.downloadTask!.resume()

                    })
                }
            }
        }
    
    deinit {
        print("Dashboard tab being deallocated from memory. OS reclaiming")
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func goToBeats(notification:NSNotification) {
        
        tabBarController?.selectedIndex = 2
    }
    
    @objc func audioPlayerOn(notification:NSNotification) {
        if audiofreeze != true {
            audiofreeze = true
            print("heard")
            setUpCard(notification: notification)
            playervisualEffectView.isUserInteractionEnabled = false
            let dict = notification.object as! NSDictionary
            var beats:[BeatData]!
            var position:Int!
            beats = dict["beats"] as? [BeatData]
            position = dict["position"] as? Int
            let myDict = [ "beats": beats!, "position":position!] as [String : Any]
            NotificationCenter.default.post(name: AudioPlayerInfoNotify, object: myDict)
            print("subviews \(view.subviews.count)")
        }
    }
    
    @objc func audioPlayerOnSong(notification:NSNotification) {
        if audiofreeze != true {
            audiofreeze = true
            print("heard")
               setUpCard(notification: notification)
               playervisualEffectView.isUserInteractionEnabled = false
               let dict = notification.object as! NSDictionary
               var url:URL!
//               var pic:UIImage!
               var song:SongData!
               url = dict["url"] as? URL
               print(url)
               song = dict["song"] as? SongData
//               pic = dict["artwork"] as? UIImage
               let myDict = [ "url": url!, "song":song!] as [String : Any]
               NotificationCenter.default.post(name: AudioPlayerInfoSongNotify, object: myDict)
               print("subviews \(view.subviews.count)")
        }
    }
    
    @objc func audioPlayerOnInstrumental(notification:NSNotification) {
        if audiofreeze != true {
            audiofreeze = true
            print("heard")
            setUpCard(notification: notification)
            playervisualEffectView.isUserInteractionEnabled = false
            let dict = notification.object as! NSDictionary
            var url:URL!
//            var pic:UIImage!
            var beat:InstrumentalData!
            url = dict["url"] as? URL
            print(url)
            beat = dict["beat"] as? InstrumentalData
//            pic = dict["artwork"] as? UIImage
            let myDict = [ "url": url!, "beat":beat!] as [String : Any]
            NotificationCenter.default.post(name: AudioPlayerInfoInstrumentalNotify, object: myDict)
            print("subviews \(view.subviews.count)")
        }
        
    }

    func setUpCard(notification: NSNotification) {
        cardHeight = view.frame.height - (tabBar.frame.height)
        playervisualEffectView = UIVisualEffectView()
        playervisualEffectView.frame = view.frame
        view.addSubview(playervisualEffectView)
        
        audioPlayerViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "audioPlayerVC") as AudioPlayerViewController
        audioPlayerViewController.view.removeFromSuperview()
        audioPlayerViewController.removeFromParent()
        
        addChild(audioPlayerViewController)
        view.addSubview(audioPlayerViewController.view)
        view.bringSubviewToFront(tabBar)
        
        audioPlayerViewController.view.frame = CGRect(x: 0, y: view.frame.height - tabBar.frame.height, width: view.bounds.width, height: cardHeight)
        
        audioPlayerViewController.view.clipsToBounds = true
        
        let tapGestureRecongnizer = UITapGestureRecognizer(target: self, action: #selector(handleCardTap(recongnizer:)))
        let panGestureRecongnizer = UIPanGestureRecognizer(target: self, action: #selector(handleCardPan(recongnizer:)))
        
        audioPlayerViewController.handleArea.addGestureRecognizer(tapGestureRecongnizer)
        audioPlayerViewController.handleArea.addGestureRecognizer(panGestureRecongnizer)
        animateTransitionIfNeeded(state: .expanded, duration: 0.5)
        
    }
    
    @objc func handleCardTap(recongnizer:UITapGestureRecognizer) {
        switch recongnizer.state {
        case .ended:
            animateTransitionIfNeeded(state: nextState, duration: 0.9)
        default:
            break
        }
    }
    
    @objc func handleCardPan(recongnizer:UIPanGestureRecognizer) {
        switch recongnizer.state {
        case .began:
            startInteractiveTransition(state: nextState, duration: 0.9)
        case .changed:
            let translation = recongnizer.translation(in: audioPlayerViewController.handleArea)
            var fractionComplete = translation.y / cardHeight
            fractionComplete = cardVisible ? fractionComplete : -fractionComplete
            updateInteractiveTransition(fractionCompleted: fractionComplete)
        case .ended:
            contimueInteractiveTransition()
        default:
            break
        }
    }
    
    func animateTransitionIfNeeded(state:CardState, duration:TimeInterval) {
        if runningAnimations.isEmpty {
            
            let frameAnimator = UIViewPropertyAnimator(duration: duration, dampingRatio: 1) { [weak self] in
                guard let strongSelf = self else {
                    return
                }
                switch state {
                case .expanded:
                    audioPlayerViewController.view.frame.origin.y = strongSelf.view.frame.height - strongSelf.cardHeight
                case .collapsed:
                    playervisualEffectView.isUserInteractionEnabled = false
                    audioPlayerViewController.view.frame.origin.y = TABBARPLAYERHEIGHT
                }
            }
            frameAnimator.addCompletion{[weak self]_ in
                guard let strongSelf = self else {
                    return
                }
                switch strongSelf.nextState {
                case .expanded:
                    print(strongSelf.nextState)
                    NotificationCenter.default.post(name: AudioPlayerViewUpdateNotify, object: "expanded")
                case .collapsed:
                    print(strongSelf.nextState)
                    NotificationCenter.default.post(name: AudioPlayerViewUpdateNotify, object: "collapsed")
                }
                strongSelf.cardVisible = !strongSelf.cardVisible
                strongSelf.runningAnimations.removeAll()
            }
            
            frameAnimator.startAnimation()
            runningAnimations.append(frameAnimator)
            
            let cornerRadiusAnimator = UIViewPropertyAnimator(duration: duration, curve: .linear) { [weak self] in
            guard let strongSelf = self else {
                return
            }
                switch state {
                case .expanded:
                    audioPlayerViewController.view.layer.cornerRadius = 12
                case .collapsed:
                    playervisualEffectView.isUserInteractionEnabled = false
                    audioPlayerViewController.view.layer.cornerRadius = 0
                }
            }
            cornerRadiusAnimator.startAnimation()
            runningAnimations.append(cornerRadiusAnimator)
            
            let blurAnimator = UIViewPropertyAnimator(duration: duration, dampingRatio: 1) { [weak self] in
            guard let strongSelf = self else {
                return
            }
                switch state {
                case .expanded:
                    playervisualEffectView.effect = UIBlurEffect(style: .dark)
                case .collapsed:
                    playervisualEffectView.isUserInteractionEnabled = false
                    playervisualEffectView.effect = nil
                }
            }
            blurAnimator.startAnimation()
            runningAnimations.append(blurAnimator)
            
        }
    }
    
    func startInteractiveTransition(state:CardState, duration:TimeInterval) {
        if runningAnimations.isEmpty {
            animateTransitionIfNeeded(state: state, duration: duration)
        }
        for animator in runningAnimations {
            animator.pauseAnimation()
            animationProgressWhenInterrupted = animator.fractionComplete
        }
    }
    
    func updateInteractiveTransition(fractionCompleted: CGFloat) {
        for animator in runningAnimations {
            animator.fractionComplete = fractionCompleted + animationProgressWhenInterrupted
        }
    }
    
    func contimueInteractiveTransition() {
        for animator in runningAnimations {
            
            animator.continueAnimation(withTimingParameters: nil, durationFactor: 0)
            
        }
    }
    
    func getSongYoutubeData(song:SongData, completion: @escaping (Array<YouTubeData>, Array<String>) -> Void) {
        var videosData:Array<YouTubeData> = []
        var youtubeimageURLs:Array<String> = []
        var val = 1
        for video in song.videos! {
            DatabaseManager.shared.findVideoById(videoid: video, completion: { selectedVideo in
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
        
    }
    
    func fetchMainInfiniteScrollContent() {
        DispatchQueue.global().async {
            var name:String!
            var imageurl:String!
            var releaseDate:String!
            var previewURL:String!
            var artists:Array<String>!
            var curr = 1
            DatabaseManager.shared.getMusicMainInfiniteScrollContent(completion: {[weak self] content in
                guard let strongSelf = self else {return}
                for array in content {
                    switch array {
                    case is SongData:
                        let song = array as! SongData
                        //print(song)
                        name = song.name
                        Comparisons.shared.getEarliestReleaseDate(song: song, completion: { edate in
                            releaseDate = edate
                            artists = song.songArtist
                            strongSelf.getSongYoutubeData(song: song, completion: { videos,videothumbnails in
                                if song.spotify?.spotifyArtworkURL != "" {
                                    imageurl = song.spotify!.spotifyArtworkURL
                                } else if song.apple?.appleArtworkURL != "" {
                                    imageurl = song.apple!.appleArtworkURL
                                } else if !videothumbnails.isEmpty {
                                    imageurl = videothumbnails[0]
                                }
                                if song.apple?.applePreviewURL != "" {
                                    previewURL = song.apple!.applePreviewURL
                                } else if song.spotify?.spotifyPreviewURL != "" {
                                    previewURL = song.spotify!.spotifyPreviewURL
                                }
                                guard let previewURL = previewURL else {return}
                                guard let artists = artists else {return}
                                guard let name = name else {return}
                                guard let imageurl = imageurl else {return}
                                guard let releaseDate = releaseDate else {return}
                                //print(name)
                                //print(imageurl)
                                
                                do {
                                    if let url = URL.init(string: imageurl) {
                                        let data = try Data.init(contentsOf: url)
                                        let image1: UIImage = UIImage(data: data) ?? UIImage(named: "tonedeaflogo")!
                                        let image = Image(uiImage: image1)
                                        switch curr {
                                        case 1:
                                            MusicMainInfiniteScrollContentFeaturedArray1.append(name)
                                            MusicMainInfiniteScrollContentFeaturedArray1.append(image)
                                            MusicMainInfiniteScrollContentFeaturedArray1.append(releaseDate)
                                            MusicMainInfiniteScrollContentFeaturedArray1.append(previewURL)
                                            MusicMainInfiniteScrollContentFeaturedArray1.append(artists)
                                            MusicMainInfiniteScrollContentFeaturedArray1.append(imageurl)
                                        case 2:
                                            MusicMainInfiniteScrollContentFeaturedArray2.append(name)
                                            MusicMainInfiniteScrollContentFeaturedArray2.append(image)
                                            MusicMainInfiniteScrollContentFeaturedArray2.append(releaseDate)
                                            MusicMainInfiniteScrollContentFeaturedArray2.append(previewURL)
                                            MusicMainInfiniteScrollContentFeaturedArray2.append(artists)
                                            MusicMainInfiniteScrollContentFeaturedArray2.append(imageurl)
                                        case 3:
                                            MusicMainInfiniteScrollContentFeaturedArray3.append(name )
                                            MusicMainInfiniteScrollContentFeaturedArray3.append(image)
                                            MusicMainInfiniteScrollContentFeaturedArray3.append(releaseDate)
                                            MusicMainInfiniteScrollContentFeaturedArray3.append(previewURL)
                                            MusicMainInfiniteScrollContentFeaturedArray3.append(artists)
                                            MusicMainInfiniteScrollContentFeaturedArray3.append(imageurl)
                                        case 4:
                                            MusicMainInfiniteScrollContentFeaturedArray4.append(name )
                                            MusicMainInfiniteScrollContentFeaturedArray4.append(image)
                                            MusicMainInfiniteScrollContentFeaturedArray4.append(releaseDate)
                                            MusicMainInfiniteScrollContentFeaturedArray4.append(previewURL)
                                            MusicMainInfiniteScrollContentFeaturedArray4.append(artists)
                                            MusicMainInfiniteScrollContentFeaturedArray4.append(imageurl)
                                        case 5:
                                            MusicMainInfiniteScrollContentFeaturedArray5.append(name )
                                            MusicMainInfiniteScrollContentFeaturedArray5.append(image)
                                            MusicMainInfiniteScrollContentFeaturedArray5.append(releaseDate)
                                            MusicMainInfiniteScrollContentFeaturedArray5.append(previewURL)
                                            MusicMainInfiniteScrollContentFeaturedArray5.append(artists)
                                            MusicMainInfiniteScrollContentFeaturedArray5.append(imageurl)
                                        case 6:
                                            MusicMainInfiniteScrollContentFeaturedArray6.append(name )
                                            MusicMainInfiniteScrollContentFeaturedArray6.append(image)
                                            MusicMainInfiniteScrollContentFeaturedArray6.append(releaseDate)
                                            MusicMainInfiniteScrollContentFeaturedArray6.append(previewURL)
                                            MusicMainInfiniteScrollContentFeaturedArray6.append(artists)
                                            MusicMainInfiniteScrollContentFeaturedArray6.append(imageurl)
                                        case 7:
                                            MusicMainInfiniteScrollContentFeaturedArray7.append(name )
                                            MusicMainInfiniteScrollContentFeaturedArray7.append(image)
                                            MusicMainInfiniteScrollContentFeaturedArray7.append(releaseDate)
                                            MusicMainInfiniteScrollContentFeaturedArray7.append(previewURL)
                                            MusicMainInfiniteScrollContentFeaturedArray7.append(artists)
                                            MusicMainInfiniteScrollContentFeaturedArray7.append(imageurl)
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
                    default:
                        print("erroe")
                    }
                }
                //print(MusicMainInfiniteScrollContentFeaturedArray)
            })
        }
        
        
    }    
    
    
    func setFeaturedArtistContent() {
        DatabaseManager.shared.setMusicFeaturedArtistContent(completion: { content in
            for artist in content {
                //print(artist.name)
                
            }
            MusicFeaturedArtistContentArray = content
        })
    }
    
    func fetchFeaturedArtistContent() {
        DatabaseManager.shared.getMusicFeaturedArtistContent(completion: { content in
            for artist in content {
                //print(artist.name)
                
            }
            MusicFeaturedArtistContentArray = content
        })
    }
    
    func setFeaturedInstrumentals() {
        DatabaseManager.shared.getMusicInstrumentalContent(completion: { content in
//                   for artist in content {
//                    print(artist.instrumentalName)
//                       
//                   }
                   MusicInstrumentalContentArray = content
               })
    }

}

extension DashboardViewController: AccountStatusUpdateDelegate {
    func accountTypeChanged(acctype: String, user: User, uid: String) {
        accountType = acctype
        currentUser = user
        currentUID = uid
        UserDefaults.standard.set(accountType, forKey: "accType")
        print("📙 updated acctype: \(accountType)")
        print("📙 updated user: \(currentUser)")
        print("📙 updated uid: \(currentUID)")
        NotificationCenter.default.post(name: AccountChangedNotify, object: accountType)
        
    }
}
var currentTab = 0

extension DashboardTabBarViewController: UITabBarControllerDelegate {
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        if item == (self.tabBar.items!)[0]{
            currentTab = 0
        }
        else if item == (self.tabBar.items!)[1]{
            currentTab = 1
        }
        else if item == (self.tabBar.items!)[2]{
            currentTab = 2
        }
        else if item == (self.tabBar.items!)[3]{
            currentTab = 3
        }
        else if item == (self.tabBar.items!)[4]{
            currentTab = 4
        }
    }
    
}

public extension UIAlertController {
    func show() {
        let win = UIWindow(frame: UIScreen.main.bounds)
        let vc = UIViewController()
        vc.view.backgroundColor = .clear
        win.rootViewController = vc
        win.windowLevel = UIWindow.Level.alert + 1  // Swift 3-4: UIWindowLevelAlert + 1
        win.makeKeyAndVisible()
        vc.present(self, animated: true, completion: nil)
    }
}

extension DashboardTabBarViewController: SPStorkControllerDelegate {
    func didDismissStorkBySwipe() {
        //NotificationCenter.default.post(name: ExpandCartHeightNotify, object: nil)
    }
    
    func didDismissStorkByTap() {
        //NotificationCenter.default.post(name: ExpandCartHeightNotify, object: nil)
    }
}

extension DashboardTabBarViewController: URLSessionDelegate, URLSessionTaskDelegate, URLSessionDataDelegate, URLSessionDownloadDelegate{
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        do {
            // after downloading your file you need to move it to your destination url
            try FileManager.default.moveItem(at: location, to: destinationUrl)
            let configuration = URLSessionConfiguration.default
            let operationQueue = OperationQueue()
            let session = URLSession(configuration: configuration, delegate: self, delegateQueue: operationQueue)
            session.dataTask(with: destinationUrl.absoluteURL) {[weak self] data, response, error in
                guard let strongSelf = self else {return}
                guard let data = data, error == nil else { return }
                var proarray:[String] = []
                for pro in strongSelf.beatToDownload.producers {
                    let word = pro.split(separator: "Æ")
                    let name = word[1]
                    proarray.append(String(name))
                }
                let tmpURL = FileManager.default.temporaryDirectory
                    .appendingPathComponent("\(strongSelf.beatToDownload.name) Produced by [\(proarray.joined(separator: ", "))] \(strongSelf.beatToDownload.tempo)BPM \(strongSelf.beatToDownload.key.replacingOccurrences(of: "/ ", with: "-")) .mp3")
                do {
                    try data.write(to: tmpURL)
                    DispatchQueue.main.async {[weak self] in
                        guard let strongSelf = self else {return}
                        strongSelf.share(url: tmpURL)
                    }
                } catch {
                    print(error)
                }
                
            }.resume()
        } catch {
            print(error)
        }
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        let percentageDownloaded = Float(totalBytesWritten) / Float(totalBytesExpectedToWrite)
        let percent = percentageDownloaded*100.0
        print(percent)
    }
    

}
