//
//  YoutubeVideoPlayerViewController.swift
//  ToneDeafDeafinitionsApp
//
//  Created by Tone Deaf on 9/20/20.
//  Copyright © 2020 GITEM Solutions. All rights reserved.
//

import UIKit
import youtube_ios_player_helper
import AVFoundation
import MediaPlayer

class YoutubeVideoPlayerViewController: UIViewController, YTPlayerViewDelegate {
    
    @IBOutlet weak var loadingSpinner: UIActivityIndicatorView!
    @IBOutlet weak var playerView: YTPlayerView!

    override func viewDidLoad() {
        super.viewDidLoad()
        //createObservers()
        playerView.delegate = self
        playerView.load(withVideoId: currentPlayingYoutubeVideo.youtubeId)
        //setupNowPlayingPreview(video: currentPlayingYoutubeVideo)
        //UIApplication.shared.beginReceivingRemoteControlEvents()
        //setupRemoteTransportControls()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        loadingSpinner.startAnimating()
    }
    
    deinit {
        print("📗 Youtube Video Player being deallocated from memory. OS reclaiming")
        NotificationCenter.default.removeObserver(self)
    }
    
    func createObservers(){
        NotificationCenter.default.addObserver(self, selector: #selector(loadPlayer(notification:)), name: YoutubePlayNotify, object: nil)
    }
    
    func playerViewDidBecomeReady(_ playerView: YTPlayerView) {
        loadingSpinner.isHidden = true
        loadingSpinner.stopAnimating()
        playerView.playVideo()
    }
    
    
    func setupRemoteTransportControls() {
        // Get the shared MPRemoteCommandCenter
        let commandCenter = MPRemoteCommandCenter.shared()

        commandCenter.changePlaybackPositionCommand.isEnabled = true
        // Add handler for Play Command
        commandCenter.playCommand.addTarget { [unowned self] event in
            if self.playerView != nil {
                self.playerView.playVideo()
                return .success
            }
            return .commandFailed
        }

        // Add handler for Pause Command
        commandCenter.pauseCommand.addTarget { [unowned self] event in
            if self.playerView != nil {
                self.playerView.pauseVideo()
                return .success
            
            }
            return .commandFailed
        }
        
        commandCenter.changePlaybackPositionCommand.addTarget { [unowned self] event in
            let event = event as! MPChangePlaybackPositionCommandEvent
            return .success
        }
    }
    
    @objc func loadPlayer(notification: Notification) {
        let video = notification.object as! YouTubeData
        playerView.load(withVideoId: video.youtubeId)
    }
    
    func setupNowPlayingPreview(video: YouTubeData) {
        // Define Now Playing Info
        var nowPlayingInfo = [String : Any]()
        nowPlayingInfo[MPMediaItemPropertyTitle] = video.title
        
        let yimageurl = video.thumbnailURL
        let yimageURL = URL(string: yimageurl)!
        if let cachedImage = imageCache.object(forKey: yimageURL.absoluteString as NSString) {nowPlayingInfo[MPMediaItemPropertyArtwork] =
                MPMediaItemArtwork(boundsSize: cachedImage.size) { size in
                    return cachedImage
            }
        } else {
            do {
                let imageData = try Data(contentsOf: yimageURL as URL)
                if let image = UIImage(data: imageData) {
                    nowPlayingInfo[MPMediaItemPropertyArtwork] =
                        MPMediaItemArtwork(boundsSize: image.size) { size in
                            return image
                    }
                }
            } catch {
                print("Unable to load data: \(error)")
            }
        }
        nowPlayingInfo[MPNowPlayingInfoPropertyElapsedPlaybackTime] = playerView.currentTime()
        nowPlayingInfo[MPMediaItemPropertyPlaybackDuration] = playerView.duration()
        nowPlayingInfo[MPNowPlayingInfoPropertyPlaybackRate] = playerView.playbackRate()
        
        getArtistData(video: video, completion: { artistNames in
            
            nowPlayingInfo[MPMediaItemPropertyArtist] = artistNames.joined(separator: ", ")
            MPNowPlayingInfoCenter.default().nowPlayingInfo = nowPlayingInfo
        })
        
        // Set the metadata
    }
    
    func getArtistData(video:YouTubeData, completion: @escaping (Array<String>) -> Void) {
        var artistNameData:Array<String> = []
        var val = 0
//        for artist in video.artist {
//            DatabaseManager.shared.fetchArtistData(artist: artist, completion: { selectedArtist in
//                artistNameData.append(selectedArtist.name)
//                val+=1
//                if val == video.artist.count {
//                    completion(artistNameData)
//                }
//            })
//        }
        
    }
}
