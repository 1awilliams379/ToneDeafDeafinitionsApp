//
//  TonesPicksViewController.swift
//  ToneDeafDeafinitionsApp
//
//  Created by Tone Deaf on 9/21/20.
//  Copyright © 2020 GITEM Solutions. All rights reserved.
//

import UIKit
import SkeletonView
import MarqueeLabel
import MobileCoreServices
import FirebaseDatabase

class TonesPicksViewController: UIViewController {
    
    @IBOutlet weak var scrollview: UIScrollView!
    
    @IBOutlet weak var highlightReelstackview: UIStackView!
    @IBOutlet weak var songstackview: UIStackView!
    @IBOutlet weak var videostackview: UIStackView!
    @IBOutlet weak var albumstackview: UIStackView!
    @IBOutlet weak var beatstackview: UIStackView!
    @IBOutlet weak var instrumentalstackview: UIStackView!
    @IBOutlet weak var changeHighlightReelButton: UIButton!
    @IBOutlet weak var changeSongButton: UIButton!
    @IBOutlet weak var changeVideoButton: UIButton!
    @IBOutlet weak var changeAlbumButton: UIButton!
    @IBOutlet weak var changeBeatButton: UIButton!
    @IBOutlet weak var changeInstrumentalButton: UIButton!
    
    
    @IBOutlet weak var highlightReelURL: MarqueeLabel!
    var selectedFileURL:URL?
    
    @IBOutlet weak var songimage: UIImageView!
    @IBOutlet weak var songTitle: MarqueeLabel!
    @IBOutlet weak var songAppId: MarqueeLabel!
    @IBOutlet weak var songFavorites: MarqueeLabel!
    @IBOutlet weak var songDateUploadedToApp: MarqueeLabel!
    @IBOutlet weak var songDateReleased: MarqueeLabel!
    @IBOutlet weak var songArtist: MarqueeLabel!
    @IBOutlet weak var songProducers: MarqueeLabel!
    @IBOutlet weak var songVideos: MarqueeLabel!
    @IBOutlet weak var songAlbums: MarqueeLabel!
    @IBOutlet weak var songInstrumentals: MarqueeLabel!
    @IBOutlet weak var songOfficialVideo: MarqueeLabel!
    @IBOutlet weak var songOfficialAudio: MarqueeLabel!
    @IBOutlet weak var songAltVideos: MarqueeLabel!
    @IBOutlet weak var songSpotifyURL: MarqueeLabel!
    @IBOutlet weak var songAppleMusicURL: MarqueeLabel!
    @IBOutlet weak var songSoundcloudURL: MarqueeLabel!
    @IBOutlet weak var songAmazonURL: MarqueeLabel!
    @IBOutlet weak var songYoutubeMusicURL: MarqueeLabel!
    @IBOutlet weak var songDeezerURL: MarqueeLabel!
    @IBOutlet weak var songTidalURL: MarqueeLabel!
    @IBOutlet weak var songSpinrillaURL: MarqueeLabel!

    var arr = ""
    var skelvar = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        skelvar = 0
        setUpHighlight(completion: {[weak self] _ in
            guard let strongSelf = self else {return}
            strongSelf.hideskeleton(view: strongSelf.highlightReelstackview)
        })
        setUpSong(completion: {[weak self] _ in
            guard let strongSelf = self else {return}
            strongSelf.hideskeleton(view: strongSelf.songstackview)
        })
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if skelvar == 0 {
                   songstackview.isSkeletonable = true
                   songstackview.showAnimatedGradientSkeleton(usingGradient: .init(baseColor: UIColor.init(red: 22/255, green: 22/255, blue: 22/255, alpha: 1)), animation: nil, transition: .crossDissolve(0.25))
               }
               
           skelvar+=1
    }
    
    func hideskeleton(view: UIView) {
        skelvar+=1
        DispatchQueue.main.async {
        view.stopSkeletonAnimation()
        view.hideSkeleton(reloadDataAfter: false, transition: .crossDissolve(0.25))
            view.layoutSubviews()
            view.layoutIfNeeded()
        }
    }
    
    func setUpHighlight(completion: @escaping (Error?) -> Void) {
        DatabaseManager.shared.getHighlightVideoURL(completion: {[weak self] hrUrl in
                guard let strongSelf = self else {return}
            strongSelf.highlightReelURL.text = "URL: \(hrUrl)"
            completion(nil)
        })
    }
    
    func updateHighlight(url:URL) {
        StorageManager.shared.uploadHighlightReel(with: url, completion: {[weak self] result in
            guard let strongSelf = self else {return}
            switch result {
            case.success(let downloadURL):
                strongSelf.highlightReelURL.text = "URL: \(downloadURL)"
                Database.database().reference().child("Current Featured Content").child("Highlight Video").setValue(downloadURL)
                return
            case .failure(let error):
                print("Storage manager error: \(error)")
                return
            }
        })
    }

    func setUpSong(completion: @escaping (Error?) -> Void) {
        DatabaseManager.shared.fetchTonesPickSong(completion: {[weak self] song in
            guard let strongSelf = self else {return}
            strongSelf.songTitle.text = "Name: \(song.name)"
            strongSelf.songAppId.text = "App ID: \(song.toneDeafAppId)"
            strongSelf.songFavorites.text = "Favorites: \(song.favoritesOverall)"
            strongSelf.songDateUploadedToApp.text = "Date Registered: \(song.apple!.appleDateIA)"
            Comparisons.shared.getEarliestReleaseDate(song: song, completion: { date in
                strongSelf.songDateReleased.text = "Date Released: \(date)"
            })
            var songart:[String] = []
            for art in song.songArtist {
                let word = art.split(separator: "Æ")
                let id = word[0]
                songart.append(String(id))
            }
            var songapro:[String] = []
            for pro in song.songProducers {
                let word = pro.split(separator: "Æ")
                let id = word[0]
                songapro.append(String(id))
            }
            strongSelf.songArtist.text = "Artist(s): \(songart.joined(separator: ", "))"
            strongSelf.songProducers.text = "Producer(s): \(songapro.joined(separator: ", "))"
            strongSelf.songVideos.text = "Videos: \(song.videos)"
            strongSelf.songAlbums.text = "Albums: \(song.albums)"
            strongSelf.songInstrumentals.text = "Instrumentals: \(song.instrumentals)"
            strongSelf.songOfficialVideo.text = "Official Vid: \(song.officialVideo)"
            strongSelf.songOfficialAudio.text = "Audio Vid: \(song.audioVideo)"
            strongSelf.songSpotifyURL.text = "Spotify: \(song.spotify?.spotifySongURL)"
            strongSelf.songAppleMusicURL.text = "Apple: \(song.apple?.appleSongURL)"
            strongSelf.songSoundcloudURL.text = "Soundcloud:"
            strongSelf.songAmazonURL.text = "Amazon:"
            strongSelf.songYoutubeMusicURL.text = "Google:"
            strongSelf.songDeezerURL.text = "Deeze:"
            strongSelf.songTidalURL.text = "Tidal:"
            strongSelf.songSpinrillaURL.text = "Spinrilla:"
            strongSelf.getYoutubeData(song: song, completion: {[weak self] videos,videothumbnails in
                guard let strongSelf = self else {return}
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
                    strongSelf.songimage.image = cachedImage
                } else {
                    strongSelf.songimage.setImage(from: imageURL, withPlaceholder: UIImage(named: "tonedeaflogo"))
                }
                
            })
            completion(nil)
        })
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
        if segue.identifier == "tonespicksegue" {
            if let viewController: SelectTonesPickItemViewController = segue.destination as? SelectTonesPickItemViewController {
                viewController.array = arr
            }
        }
    }
    
    @IBAction func changeHighlightReelButtonTapped(_ sender: Any) {
        openFiles(type: "video")
    }
    
    @IBAction func changeSongButtonTapped(_ sender: Any) {
        arr = "song"
        performSegue(withIdentifier: "tonespicksegue", sender: sender)
    }
    
    @IBAction func changeVideoButtonTapped(_ sender: Any) {
        arr = "video"
        performSegue(withIdentifier: "tonespicksegue", sender: sender)
    }
    
    @IBAction func changeAlbumButtonTapped(_ sender: Any) {
        arr = "album"
        performSegue(withIdentifier: "tonespicksegue", sender: sender)
    }
    
    @IBAction func changeBeatButtonTapped(_ sender: Any) {
        arr = "beat"
        performSegue(withIdentifier: "tonespicksegue", sender: sender)
    }
    
    @IBAction func changeInstrumentalButtonTapped(_ sender: Any) {
        arr = "instrumental"
        performSegue(withIdentifier: "tonespicksegue", sender: sender)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension TonesPicksViewController: UIDocumentPickerDelegate {
    
    func openFiles(type: String) {
        let documentPicker:UIDocumentPickerViewController!
        switch type {
        case "video":
            documentPicker = UIDocumentPickerViewController(documentTypes: [kUTTypeMovie as String], in: .import)
        case "wav":
            documentPicker = UIDocumentPickerViewController(documentTypes: [kUTTypeWaveformAudio as String], in: .import)
        default:
            documentPicker = UIDocumentPickerViewController(documentTypes: [kUTTypeZipArchive as String], in: .import)
        }
        documentPicker.delegate = self
        documentPicker.allowsMultipleSelection = false
        present(documentPicker, animated: true, completion: nil)
    }
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        let alertC = UIAlertController(title: "Update Highlight",
                                                message: "Are you sure?.",
                                                preferredStyle: .alert)
        let yesAction = UIAlertAction(title: "Yes", style: .default, handler: {[weak self] _ in
            guard let strongSelf = self else {return}
            let newUrls = urls.compactMap { (url: URL) -> URL? in
                // Create file URL to temporary folder
                var tempURL = URL(fileURLWithPath: NSTemporaryDirectory())
                // Apend filename (name+extension) to URL
                tempURL.appendPathComponent(url.lastPathComponent)
                do {
                    // If file with same name exists remove it (replace file with new one)
                    if FileManager.default.fileExists(atPath: tempURL.path) {
                        try FileManager.default.removeItem(atPath: tempURL.path)
                    }
                    // Move file from app_id-Inbox to tmp/filename
                    try FileManager.default.moveItem(atPath: url.path, toPath: tempURL.path)
                    return tempURL
                } catch {
                    print(error.localizedDescription)
                    return nil
                }
            }
            print(newUrls.first!)
            strongSelf.updateHighlight(url: newUrls.first!)
            alertC.dismiss(animated: true, completion: nil)
        })
        alertC.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alertC.addAction(yesAction)
        alertC.view.tintColor = Constants.Colors.redApp
        self.present(alertC, animated: true)
    }
    
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        
    }
}
