//
//  MorePopoverTableViewController.swift
//  ToneDeafDeafinitionsApp
//
//  Created by Tone Deaf on 10/5/20.
//  Copyright © 2020 GITEM Solutions. All rights reserved.
//

import UIKit

class MorePopoverTableViewController: UITableViewController {
    
    var data:[String]!
    var array:[String] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.backgroundColor = .clear
        self.tableView.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0)
        let blurEffect = UIBlurEffect(style: .dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = self.view.frame
        self.tableView.separatorEffect = UIVibrancyEffect(blurEffect: blurEffect)
        self.tableView.backgroundView = blurEffectView
        array = ["share"]
        if popOverIndicator == "pro" {
            if recievedProducerData.spotifyProfileURL != "" {
                array.append(recievedProducerData.spotifyProfileURL)
            }
            if recievedProducerData.appleProfileURL != "" {
                array.append(recievedProducerData.appleProfileURL)
            }
            if let url = recievedProducerData.soundcloudProfileURL {
                array.append(url)
            }
            if let url = recievedProducerData.youtubeMusicProfileURL {
                array.append(url)
            }
            if let url = recievedProducerData.amazonProfileURL {
                array.append(url)
            }
            if let url = recievedProducerData.deezerProfileURL {
                array.append(url)
            }
            if let url = recievedProducerData.spinrillaProfileURL {
                array.append(url)
            }
            if let url = recievedProducerData.napsterProfileURL {
                array.append(url)
            }
            if let url = recievedProducerData.tidalProfileURL {
                array.append(url)
            }
            if let url = recievedProducerData.instagramProfileURL {
                array.append(url)
            }
            if let url = recievedProducerData.facebookProfileURL {
                array.append(url)
            }
            if let url = recievedProducerData.twitterProfileURL {
                array.append(url)
            }
        } else {
            if recievedArtistData.spotifyProfileURL != "" {
                array.append(recievedArtistData.spotifyProfileURL)
            }
            if recievedArtistData.appleProfileURL != "" {
                array.append(recievedArtistData.appleProfileURL)
            }
            if let url = recievedArtistData.soundcloudProfileURL {
                array.append(url)
            }
            if let url = recievedArtistData.youtubeMusicProfileURL {
                array.append(url)
            }
            if let url = recievedArtistData.amazonProfileURL {
                array.append(url)
            }
            if let url = recievedArtistData.deezerProfileURL {
                array.append(url)
            }
            if let url = recievedArtistData.spinrillaProfileURL {
                array.append(url)
            }
            if let url = recievedArtistData.napsterProfileURL {
                array.append(url)
            }
            if let url = recievedArtistData.tidalProfileURL {
                array.append(url)
            }
            if let url = recievedArtistData.instagramProfileURL {
                array.append(url)
            }
            if let url = recievedArtistData.facebookProfileURL {
                array.append(url)
            }
            if let url = recievedArtistData.twitterProfileURL {
                array.append(url)
            }
        }
        data = array
    }
    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(true)
//        if visualEffectView != nil {
//            visualEffectView.removeFromSuperview()
//            visualEffectView = nil
//        }
//        if visualEffectView == nil {
//            visualEffectView   = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
//            visualEffectView.frame = view.frame
//            view.addSubview(visualEffectView)
//            view.sendSubviewToBack(visualEffectView)
//            visualEffectView.layer.zPosition = -1;
//            visualEffectView.isUserInteractionEnabled = false
//        }
//    }
//
//    override func viewWillDisappear(_ animated: Bool) {
//        super.viewWillDisappear(true)
//        if visualEffectView != nil {
//            visualEffectView.removeFromSuperview()
//            visualEffectView = nil
//        }
//    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return data.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "morePopoverCell", for: indexPath) as! MorePopoverTableViewCellController
        let stringinc = data[indexPath.row]
        cell.funcSetUpTemp(stringurl: stringinc)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let stringurl = data[indexPath.row]
        if stringurl == "share" {
            let vc = UIActivityViewController(activityItems: [URL(string: "ToneDeafDeafinitionsApp://")!], applicationActivities: [])
            //self.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
            present(vc, animated: true, completion: nil)
        } else {
            let url = URL(string: stringurl)
            if UIApplication.shared.canOpenURL(url!)
            {
                UIApplication.shared.open(url!, options: [:], completionHandler: nil)
            } else {
                //redirect to safari because the user doesn't have Instagram
                if stringurl.contains("spotify") {
                    UIApplication.shared.open(URL(string: "http://spotify.com/")!, options: [:], completionHandler: nil)
                }
                if stringurl.contains("apple") {
                    UIApplication.shared.open(URL(string: "http://apple.com/")!, options: [:], completionHandler: nil)
                }
                if stringurl.contains("soundcloud") {
                    UIApplication.shared.open(URL(string: "http://soundcloud.com/")!, options: [:], completionHandler: nil)
                }
                if stringurl.contains("music.youtube") {
                    UIApplication.shared.open(URL(string: "https://music.youtube.com")!, options: [:], completionHandler: nil)
                }
                if stringurl.contains("amazon") {
                    UIApplication.shared.open(URL(string: "https://music.amazon.com/home")!, options: [:], completionHandler: nil)
                }
                if stringurl.contains("deezer") {
                    UIApplication.shared.open(URL(string: "https://www.deezer.com/us/")!, options: [:], completionHandler: nil)
                }
                if stringurl.contains("spinrilla") {
                    UIApplication.shared.open(URL(string: "https://spinrilla.com")!, options: [:], completionHandler: nil)
                }
                if stringurl.contains("napster") {
                    UIApplication.shared.open(URL(string: "https://us.napster.com")!, options: [:], completionHandler: nil)
                }
                if stringurl.contains("tidal") {
                    UIApplication.shared.open(URL(string: "https://tidal.com")!, options: [:], completionHandler: nil)
                }
                if stringurl.contains("instagram") {
                    UIApplication.shared.open(URL(string: "https://instagram.com")!, options: [:], completionHandler: nil)
                }
                if stringurl.contains("facebook") {
                    UIApplication.shared.open(URL(string: "https://facebook.com")!, options: [:], completionHandler: nil)
                }
                if stringurl.contains("twitter") {
                    UIApplication.shared.open(URL(string: "https://twitter.com")!, options: [:], completionHandler: nil)
                }
            }
        }
    }


}
import MarqueeLabel

class MorePopoverTableViewCellController: UITableViewCell {
    
    @IBOutlet weak var view:UIView!
    @IBOutlet weak var label:MarqueeLabel!
    @IBOutlet weak var imagee: UIImageView!
    
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        imagee.image = nil
        label.text = ""
        imagee.tintColor = nil
        imagee.layer.cornerRadius = 0
//        if visualEffectView != nil {
//            visualEffectView.removeFromSuperview()
//            visualEffectView = nil
//        }
    }
    
    func funcSetUpTemp(stringurl:String) {
        var name = ""
        if popOverIndicator == "pro" {
           name = recievedProducerData.name
        } else {
            name = recievedArtistData.name
        }
        if stringurl.contains("share") {
            label.text = "Share"
            imagee.image = UIImage(systemName: "square.and.arrow.up")
        }
        if stringurl.contains("spotify") {
            label.text = "\(name) on Spotify"
            imagee.image = UIImage(named: "SpotifyIcon")
        }
        if stringurl.contains("apple") {
            label.text = "\(name) on Apple Music"
            imagee.image = UIImage(named: "appleMusicIcon")
        }
        if stringurl.contains("soundcloud") {
            label.text = "\(name) on Soundcloud"
            imagee.image = UIImage(named: "soundcloudIcon")
        }
        if stringurl.contains("music.youtube") {
            label.text = "\(name) on Youtube Music"
            imagee.image = UIImage(named: "youtubemusicappicon")
            imagee.layer.cornerRadius = 5
        }
        if stringurl.contains("amazon") {
            label.text = "\(name) on Amazon Music"
            imagee.image = UIImage(named: "amazonicon")
        }
        if stringurl.contains("deezer") {
            label.text = "\(name) on Deezer"
            imagee.image = UIImage(named: "deezerlogo")
        }
        if stringurl.contains("spinrilla") {
            label.text = "\(name) on Spinrilla"
            imagee.image = UIImage(named: "spinrillalogo")
        }
        if stringurl.contains("napster") {
            label.text = "\(name) on Napster"
            imagee.image = UIImage(named: "napsterlogo")
            imagee.tintColor = .white
        }
        if stringurl.contains("tidal") {
            label.text = "\(name) on Tidal"
            imagee.image = UIImage(named: "tidal-logo-png-transparent")
            imagee.tintColor = .white
        }
        if stringurl.contains("instagram") {
            label.text = "\(name) on Instagram"
            imagee.image = UIImage(named: "instagramIcon")
        }
        if stringurl.contains("twitter") {
            label.text = "\(name) on Twitter"
            imagee.image = UIImage(named: "twitterIcon")
        }
        if stringurl.contains("facebook") {
            label.text = "\(name) on Facebook"
            imagee.image = UIImage(named: "facebookIcon")
        }
        
    }
}
