//
//  PopoverYoutubeTableViewController.swift
//  ToneDeafDeafinitionsApp
//
//  Created by Tone Deaf on 9/20/20.
//  Copyright © 2020 GITEM Solutions. All rights reserved.
//

import UIKit
import MarqueeLabel
import SkeletonView

class PopoverYoutubeTableViewController: UITableViewController, SkeletonTableViewDataSource {
    
    var skelvar = 0
    var initialLoad = false
    var videos:Any!
    var officialVideosArray:[YouTubeData]!
    var officialAudioArray:[YouTubeData]!
    var officialAltArray:[YouTubeData]!
    var InstrumentalVideosArray:[YouTubeData]!
    var allVideosArray:[YouTubeData]!
    var ytdata:[[YouTubeData]]!
    var allTwitVideosArray:[TwitterTweetData]!
    var twitdata:[[TwitterTweetData]]!
    var allIGTVVideosArray:[IGTVData]!
    var igtvdata:[[IGTVData]]!
    var allInstagramVideosArray:[InstagramPostData]!
    var instagramdata:[[InstagramPostData]]!
    var allFacebookVideosArray:[FacebookPostData]!
    var facebookdata:[[FacebookPostData]]!
    var allWorldstarVideosArray:[WorldstarData]!
    var worldstardata:[[WorldstarData]]!
    var allAppleVideosArray:[AppleVideoData]!
    var appledata:[[AppleVideoData]]!
    var allTikTokVideosArray:[TikTokData]!
    var tiktokdata:[[TikTokData]]!
    @IBOutlet var tableViewPopover: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        officialVideosArray = []
        officialAudioArray = []
        officialAltArray = []
        InstrumentalVideosArray = []
        ytdata = []
        initialLoad = false
        currentPlayingYoutubeVideo = nil
        let queue = DispatchQueue(label: "daskfhajbd,xjvc.km ueue")
        let group = DispatchGroup()
        let array = [1]

        for i in array {
            //print(i)
            group.enter()
            queue.async { [weak self] in
                guard let strongSelf = self else {return}
                switch i {
                case 1:
                    //print("null")
                    strongSelf.setUpTable(completion: {
                        DispatchQueue.main.async {
                            strongSelf.hideskeleton(tableview: strongSelf.tableViewPopover)
                            strongSelf.initialLoad = true
                            strongSelf.tableViewPopover.reloadData()
                        }
                        print("done \(i)")
                        group.leave()
                    })
                default:
                    print("error")
                }
            }
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if skelvar == 0 {
            tableViewPopover.isSkeletonable = true
            tableViewPopover.showAnimatedGradientSkeleton(usingGradient: .init(baseColor: UIColor.init(red: 22/255, green: 22/255, blue: 22/255, alpha: 1)), animation: nil, transition: .crossDissolve(0.25))
        }
        skelvar+=1
        //tableview.showAnimatedSkeleton(usingColor: .wetAsphalt, transition: .crossDissolve(0.25))
    }
    
    func setUpTable(completion: @escaping () -> Void) {
        switch contentViewVideos {
        case is YouTubeData:
            videos = contentViewVideos as! YouTubeData
            currentPlayingYoutubeVideo = (videos as! YouTubeData)
            completion()
        case is [YouTubeData]:
            videos = contentViewVideos as! [YouTubeData]
            var tick = 0
            allVideosArray = []
            for video in videos as! [YouTubeData] {
                allVideosArray.append(video)
                tick+=1
                if tick == (videos as! [YouTubeData]).count {
                    ytdata = [officialVideosArray,officialAudioArray,officialAltArray,InstrumentalVideosArray,allVideosArray]
                    completion()
                }
            }
        case is [IGTVData]:
            videos = contentViewVideos as! [IGTVData]
            var tick = 0
            allIGTVVideosArray = []
            for video in videos as! [IGTVData] {
                allIGTVVideosArray.append(video)
                tick+=1
                if tick == (videos as! [IGTVData]).count {
                    igtvdata = [allIGTVVideosArray]
                    completion()
                }
            }
        case is [InstagramPostData]:
            videos = contentViewVideos as! [InstagramPostData]
            var tick = 0
            allInstagramVideosArray = []
            for video in videos as! [InstagramPostData] {
                allInstagramVideosArray.append(video)
                tick+=1
                if tick == (videos as! [InstagramPostData]).count {
                    instagramdata = [allInstagramVideosArray]
                    completion()
                }
            }
        case is [FacebookPostData]:
            videos = contentViewVideos as! [FacebookPostData]
            var tick = 0
            allFacebookVideosArray = []
            for video in videos as! [FacebookPostData] {
                allFacebookVideosArray.append(video)
                tick+=1
                if tick == (videos as! [FacebookPostData]).count {
                    facebookdata = [allFacebookVideosArray]
                    completion()
                }
            }
        case is [WorldstarData]:
            videos = contentViewVideos as! [WorldstarData]
            var tick = 0
            allWorldstarVideosArray = []
            for video in videos as! [WorldstarData] {
                allWorldstarVideosArray.append(video)
                tick+=1
                if tick == (videos as! [WorldstarData]).count {
                    worldstardata = [allWorldstarVideosArray]
                    completion()
                }
            }
        case is [AppleVideoData]:
            videos = contentViewVideos as! [AppleVideoData]
            var tick = 0
            allAppleVideosArray = []
            for video in videos as! [AppleVideoData] {
                allAppleVideosArray.append(video)
                tick+=1
                if tick == (videos as! [AppleVideoData]).count {
                    appledata = [allAppleVideosArray]
                    completion()
                }
            }
        case is [TikTokData]:
            videos = contentViewVideos as! [TikTokData]
            var tick = 0
            allTikTokVideosArray = []
            for video in videos as! [TikTokData] {
                allTikTokVideosArray.append(video)
                tick+=1
                if tick == (videos as! [TikTokData]).count {
                    tiktokdata = [allTikTokVideosArray]
                    completion()
                }
            }
        case is [TwitterTweetData]:
            videos = contentViewVideos as! [TwitterTweetData]
            var tick = 0
            allTwitVideosArray = []
            for video in videos as! [TwitterTweetData] {
                allTwitVideosArray.append(video)
                tick+=1
                if tick == (videos as! [TwitterTweetData]).count {
                    twitdata = [allTwitVideosArray]
                    completion()
                }
            }
        default:
            var tick = 0
            videos = contentViewVideos as! [String]
            for video in videos as! [String] {
                let word = video.split(separator: "Æ")
                let id = word[0]
                DatabaseManager.shared.findVideoById(videoid: String(id), completion: { [weak self] result in
                    guard let strongSelf = self else {return}
                    switch result {
                    case .success(let vid):
                        if vid is YouTubeData {
                            let YT = vid as! YouTubeData
                            switch YT.type {
                            case "YTVD":
                                strongSelf.officialVideosArray.append(YT)
                            case "YTAD":
                                strongSelf.officialAudioArray.append(YT)
                            case "YTAL":
                                strongSelf.officialAltArray.append(YT)
                            default:
                                strongSelf.InstrumentalVideosArray.append(YT)
                            }
                        }
                    case .failure(let error):
                        print("failed to retreive videos \(error)")
                    }
                    tick+=1
                    if tick == (strongSelf.videos as! [String]).count {
                        strongSelf.ytdata = [strongSelf.officialVideosArray,strongSelf.officialAudioArray,strongSelf.officialAltArray,strongSelf.InstrumentalVideosArray]
                        completion()
                    }
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
    // MARK: - Table view data source
    
    func collectionSkeletonView(_ skeletonView: UITableView, cellIdentifierForRowAt indexPath: IndexPath) -> ReusableCellIdentifier {
    //        if skeletonView == latestBeatsTableView {
                return "youtubePopoverTableCell"
    //        }
        }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        var sectitle = "Videos"
        switch videos {
        case is YouTubeData:
            if section == 0 {
                sectitle = "Official Video"
            } else if section == 1 {
                sectitle = "Official Audio"
            }else if section == 2 {
                sectitle = "Alternate Videos"
            }else if section == 3 {
                sectitle = "Instrumental"
            }
            else {
                sectitle = "Videos"
            }
        case is [TwitterTweetData]:
            sectitle = "Videos"
        default:
            break
        }
        return sectitle
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        var numberOfSections = 0
        switch videos {
        case is YouTubeData:
            numberOfSections = 1
        case is [TwitterTweetData]:
            numberOfSections = 1
        case is [IGTVData]:
            numberOfSections = 1
        case is [InstagramPostData]:
            numberOfSections = 1
        case is [FacebookPostData]:
            numberOfSections = 1
        case is [WorldstarData]:
            numberOfSections = 1
        case is [AppleVideoData]:
            numberOfSections = 1
        case is [TikTokData]:
            numberOfSections = 1
        default:
            numberOfSections = ytdata.count
//            if !officialVideosArray.isEmpty {
//                numberOfSections+=1
//            }
//            if !officialAltArray.isEmpty {
//                numberOfSections+=1
//            }
//            if !officialAudioArray.isEmpty {
//                numberOfSections+=1
//            }
//            if !InstrumentalVideosArray.isEmpty {
//                numberOfSections+=1
//            }
        }
        return numberOfSections
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var numberOfRows = 0
        switch videos {
        case is YouTubeData:
            let video = videos as! YouTubeData
            if section == 0 && video.type == "YTVD" {
                numberOfRows = 1
            } else {
                numberOfRows = 0
            }
        case is [TwitterTweetData]:
            if section == 0 {
                numberOfRows = allTwitVideosArray.count
            } else {
                numberOfRows = 0
            }
        case is [IGTVData]:
            if section == 0 {
                numberOfRows = allIGTVVideosArray.count
            } else {
                numberOfRows = 0
            }
        case is [InstagramPostData]:
            if section == 0 {
                numberOfRows = allInstagramVideosArray.count
            } else {
                numberOfRows = 0
            }
        case is [FacebookPostData]:
            if section == 0 {
                numberOfRows = allFacebookVideosArray.count
            } else {
                numberOfRows = 0
            }
        case is [WorldstarData]:
            if section == 0 {
                numberOfRows = allWorldstarVideosArray.count
            } else {
                numberOfRows = 0
            }
        case is [AppleVideoData]:
            if section == 0 {
                numberOfRows = allAppleVideosArray.count
            } else {
                numberOfRows = 0
            }
        case is [TikTokData]:
            if section == 0 {
                numberOfRows = allTikTokVideosArray.count
            } else {
                numberOfRows = 0
            }
        default:
//            switch (section) {
//            case 0:
//                numberOfRows = officialVideosArray.count
//            case 1:
//                numberOfRows = officialAudioArray.count
//            case 2:
//                numberOfRows = officialAltArray.count
//            default:
//                numberOfRows = InstrumentalVideosArray.count
//            }
            numberOfRows = ytdata[section].count
        }
        return numberOfRows
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch videos {
        case is YouTubeData:
            let cell = tableView.dequeueReusableCell(withIdentifier: "youtubePopoverTableCell", for: indexPath) as! PopoverTableCellController
            if currentPlayingYoutubeVideo != nil {
                cell.funcSetTemp(video: currentPlayingYoutubeVideo)
            }
            return cell
        case is [YouTubeData]:
            let cell = tableView.dequeueReusableCell(withIdentifier: "youtubePopoverTableCell", for: indexPath) as! PopoverTableCellController
            let video = ytdata[indexPath.section][indexPath.row]
            cell.funcSetTemp(video: video)
            return cell
        case is [TwitterTweetData]:
            let cell = tableView.dequeueReusableCell(withIdentifier: "youtubePopoverTableCell", for: indexPath) as! PopoverTableCellController
            let video = twitdata[indexPath.section][indexPath.row]
            cell.funcSetTemp(video: video)
            return cell
        case is [IGTVData]:
            let cell = tableView.dequeueReusableCell(withIdentifier: "youtubePopoverTableCell", for: indexPath) as! PopoverTableCellController
            let video = igtvdata[indexPath.section][indexPath.row]
            cell.funcSetTemp(video: video)
            return cell
        case is [InstagramPostData]:
            let cell = tableView.dequeueReusableCell(withIdentifier: "youtubePopoverTableCell", for: indexPath) as! PopoverTableCellController
            let video = instagramdata[indexPath.section][indexPath.row]
            cell.funcSetTemp(video: video)
            return cell
        case is [FacebookPostData]:
            let cell = tableView.dequeueReusableCell(withIdentifier: "youtubePopoverTableCell", for: indexPath) as! PopoverTableCellController
            let video = facebookdata[indexPath.section][indexPath.row]
            cell.funcSetTemp(video: video)
            return cell
        case is [WorldstarData]:
            let cell = tableView.dequeueReusableCell(withIdentifier: "youtubePopoverTableCell", for: indexPath) as! PopoverTableCellController
            let video = worldstardata[indexPath.section][indexPath.row]
            cell.funcSetTemp(video: video)
            return cell
        case is [AppleVideoData]:
            let cell = tableView.dequeueReusableCell(withIdentifier: "youtubePopoverTableCell", for: indexPath) as! PopoverTableCellController
            let video = appledata[indexPath.section][indexPath.row]
            cell.funcSetTemp(video: video)
            return cell
        case is [TikTokData]:
            let cell = tableView.dequeueReusableCell(withIdentifier: "youtubePopoverTableCell", for: indexPath) as! PopoverTableCellController
            let video = tiktokdata[indexPath.section][indexPath.row]
            cell.funcSetTemp(video: video)
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "youtubePopoverTableCell", for: indexPath) as! PopoverTableCellController
            if !officialVideosArray.isEmpty {
                let video = ytdata[indexPath.section][indexPath.row]
                cell.funcSetTemp(video: video)
            }
            if !officialAudioArray.isEmpty {
                let video = ytdata[indexPath.section][indexPath.row]
                cell.funcSetTemp(video: video)
            }
            if !officialAltArray.isEmpty {
                let video = ytdata[indexPath.section][indexPath.row]
                cell.funcSetTemp(video: video)
            }
            if !InstrumentalVideosArray.isEmpty {
                let video = ytdata[indexPath.section][indexPath.row]
                cell.funcSetTemp(video: video)
            }
            return cell
        }
    }
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        var height:CGFloat = 28
        if initialLoad == true {
            if ytdata.count != 0 {
                switch section {
                case 0:
                    if officialVideosArray.isEmpty && currentPlayingYoutubeVideo == nil {
                        height = 0
                    }
                case 1:
                    if officialAudioArray.isEmpty && currentPlayingYoutubeVideo == nil {
                        height = 0
                    }
                case 2:
                    if officialAltArray.isEmpty && currentPlayingYoutubeVideo == nil {
                        height = 0
                    }
                case 3:
                    if InstrumentalVideosArray.isEmpty && currentPlayingYoutubeVideo == nil {
                        height = 0
                    }
                default:
                    if allVideosArray.isEmpty && currentPlayingYoutubeVideo == nil {
                        height = 0
                    }
                }
            }
        }
        return height
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        switch videos {
        case is YouTubeData:
                alertController.dismiss(animated: true, completion: {
                    DispatchQueue.main.async {
                        NotificationCenter.default.post(name: YoutubePlayNotify, object: nil)
                    }
                })
        case is TwitterTweetData:
            print("")
//                alertController.dismiss(animated: true, completion: {
//                    DispatchQueue.main.async {
//                        NotificationCenter.default.post(name: YoutubePlayNotify, object: nil)
//                    }
//                })
        default:
            currentPlayingYoutubeVideo = ytdata[indexPath.section][indexPath.row]
                alertController.dismiss(animated: true, completion: {
                    DispatchQueue.main.async {
                        NotificationCenter.default.post(name: YoutubePlayNotify, object: nil)
                    }
                })
        }
    }

}

class PopoverTableCellController: UITableViewCell {
    
    @IBOutlet weak var videoTitle: UILabel!
    @IBOutlet weak var channelTitle: MarqueeLabel!
    @IBOutlet weak var moreButton: UIImageView!
    @IBOutlet weak var favoriteButton: UIImageView!
    
    func funcSetTemp(video: YouTubeData) {
        videoTitle.text = video.title
        channelTitle.text = video.url
    }
    
    func funcSetTemp(video: TwitterTweetData) {
        videoTitle.text = contentViewAppVideo.title
        channelTitle.text = video.url
    }
    
    func funcSetTemp(video: IGTVData) {
        videoTitle.text = contentViewAppVideo.title
        channelTitle.text = video.url
    }
    
    func funcSetTemp(video: InstagramPostData) {
        videoTitle.text = contentViewAppVideo.title
        channelTitle.text = video.url
    }
    
    func funcSetTemp(video: FacebookPostData) {
        videoTitle.text = contentViewAppVideo.title
        channelTitle.text = video.url
    }
    
    func funcSetTemp(video: WorldstarData) {
        videoTitle.text = contentViewAppVideo.title
        channelTitle.text = video.url
    }
    
    func funcSetTemp(video: AppleVideoData) {
        videoTitle.text = video.name
        channelTitle.text = video.url
    }
    
    func funcSetTemp(video: TikTokData) {
        videoTitle.text = contentViewAppVideo.title
        channelTitle.text = video.url
    }
    
}

class PopoverTableViewController: UITableView {
    override var intrinsicContentSize: CGSize {
        layoutIfNeeded()
        return CGSize(width: UIView.noIntrinsicMetric, height: contentSize.height)
    }
}

