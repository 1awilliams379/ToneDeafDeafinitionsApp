//
//  FavoritesProfileViewController.swift
//  ToneDeafDeafinitionsApp
//
//  Created by Tone Deaf on 6/19/22.
//  Copyright © 2022 GITEM Solutions. All rights reserved.
//

import UIKit
import SkeletonView

class FavoritesProfileViewController: UIViewController {
    
    @IBOutlet weak var favoritesTableView: UITableView!
    
    var skelvar = 0
    
    let headerCharacterArray:[Character] = ["A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z","#"]
    //var arrCount:[Int] = [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]
    var userFavoritesArray:[[UserFavorite]]!
    var Aa:[UserFavorite] = []
    var Bb:[UserFavorite] = []
    var Cc:[UserFavorite] = []
    var Dd:[UserFavorite] = []
    var Ee:[UserFavorite] = []
    var Ff:[UserFavorite] = []
    var Gg:[UserFavorite] = []
    var Hh:[UserFavorite] = []
    var Ii:[UserFavorite] = []
    var Jj:[UserFavorite] = []
    var Kk:[UserFavorite] = []
    var Ll:[UserFavorite] = []
    var Mm:[UserFavorite] = []
    var Nn:[UserFavorite] = []
    var Oo:[UserFavorite] = []
    var Pp:[UserFavorite] = []
    var Qq:[UserFavorite] = []
    var Rr:[UserFavorite] = []
    var Ss:[UserFavorite] = []
    var Tt:[UserFavorite] = []
    var Uu:[UserFavorite] = []
    var Vv:[UserFavorite] = []
    var Ww:[UserFavorite] = []
    var Xx:[UserFavorite] = []
    var Yy:[UserFavorite] = []
    var Zz:[UserFavorite] = []
    var num:[UserFavorite] = []
    
    var infoDetailContent:Any!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        let nib = UINib(nibName: "Header Small", bundle: nil)
        favoritesTableView.register(nib, forHeaderFooterViewReuseIdentifier: "TableSectionHeaderSmall")
        favoritesTableView.delegate = self
        favoritesTableView.dataSource = self
        setFavoritesArray()
    }
    
    func setFavoritesArray() {
        userFavoritesArray = [Aa,Bb,Cc,Dd,Ee,Ff,Gg,Hh,Ii,Jj,Kk,Ll,Mm,Nn,Oo,Pp,Qq,Rr,Ss,Tt,Uu,Vv,Ww,Xx,Yy,Zz,num]
        let temp = currentAppUser.favorites.sorted(by: { $0.dbid.split(separator: "Æ")[1] > $1.dbid.split(separator: "Æ")[1] })
        for fav in temp {
            let title = fav.dbid.split(separator: "Æ")[1]
            let first = title[title.startIndex]
            switch first.uppercased() {
            case "A":
                Aa.append(fav)
            case "B":
                Bb.append(fav)
            case "C":
                Cc.append(fav)
            case "D":
                Dd.append(fav)
            case "E":
                Ee.append(fav)
            case "F":
                Ff.append(fav)
            case "G":
                Gg.append(fav)
            case "H":
                Hh.append(fav)
            case "I":
                Ii.append(fav)
            case "J":
                Jj.append(fav)
            case "K":
                Kk.append(fav)
            case "L":
                Ll.append(fav)
            case "M":
                Mm.append(fav)
            case "N":
                Nn.append(fav)
            case "O":
                Oo.append(fav)
            case "P":
                Pp.append(fav)
            case "Q":
                Qq.append(fav)
            case "R":
                Rr.append(fav)
            case "S":
                Ss.append(fav)
            case "T":
                Tt.append(fav)
            case "U":
                Uu.append(fav)
            case "V":
                Vv.append(fav)
            case "W":
                Ww.append(fav)
            case "X":
                Xx.append(fav)
            case "Y":
                Yy.append(fav)
            case "Z":
                Zz.append(fav)
            default:
                num.append(fav)
            }
        }
        userFavoritesArray = [Aa,Bb,Cc,Dd,Ee,Ff,Gg,Hh,Ii,Jj,Kk,Ll,Mm,Nn,Oo,Pp,Qq,Rr,Ss,Tt,Uu,Vv,Ww,Xx,Yy,Zz,num]
        print("tittttt ", userFavoritesArray)
        hideskeleton(tableview: favoritesTableView)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "allFavoritesToInfo" {
            if let viewController: InfoDetailViewController = segue.destination as? InfoDetailViewController {
                viewController.content = infoDetailContent
            }
        } else if segue.identifier == "allFavoritesToBeatInfo" {
            if let viewController: BeatInfoDetailViewController = segue.destination as? BeatInfoDetailViewController {
                viewController.recievedBeat = (infoDetailContent as! BeatData)
            }
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
            strongSelf.view.layoutSubviews()
        }
    }

}

extension FavoritesProfileViewController : UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if self.tableView(tableView, numberOfRowsInSection: section) > 0 {
            return 20
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = favoritesTableView.dequeueReusableHeaderFooterView(withIdentifier: "TableSectionHeaderSmall") as! TableSectionHeaderSmall
        var sectitle = ""
        if self.tableView(tableView, numberOfRowsInSection: section) > 0{
            sectitle = String(headerCharacterArray[section])
        } else {
            return nil
        }
        let header = cell
        header.titleLabel.text = sectitle
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var numberOfRows = 0
        if userFavoritesArray != nil, !userFavoritesArray.isEmpty {
            numberOfRows = userFavoritesArray[section].count
        }
        return numberOfRows
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        var numberOfSections = 1
        if userFavoritesArray != nil, !userFavoritesArray.isEmpty {
            numberOfSections = userFavoritesArray.count
        }
        return numberOfSections
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let dbid = userFavoritesArray[indexPath.section][indexPath.row].dbid
        let word = dbid.split(separator: "Æ")
        let id = word[0]
        switch id.count {
        case 9:
            let cell = favoritesTableView.dequeueReusableCell(withIdentifier: "allUserFavoritesVideoTableViewCellController", for: indexPath) as! allUserFavoritesVideoTableViewCellController
            if !userFavoritesArray[indexPath.section].isEmpty {
                cell.setTemp(tableView: favoritesTableView, favorite: userFavoritesArray[indexPath.section][indexPath.row])
            }
            return cell
        default:
            let cell = favoritesTableView.dequeueReusableCell(withIdentifier: "allUserFavoritesTableViewCellController", for: indexPath) as! allUserFavoritesTableViewCellController
            if !userFavoritesArray[indexPath.section].isEmpty {
                cell.setTemp(tableView: favoritesTableView,favorite: userFavoritesArray[indexPath.section][indexPath.row])
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        let dbid = userFavoritesArray[indexPath.section][indexPath.row].dbid
        let word = dbid.split(separator: "Æ")
        let id = word[0]
        switch id.count {
        case 8:
            DatabaseManager.shared.findAlbumById(albumId: String(id), completion: { [weak self] result in
                guard let strongSelf = self else {return}
                switch result {
                case .success(let album):
                    strongSelf.infoDetailContent = album as AlbumData
                    strongSelf.performSegue(withIdentifier: "allFavoritesToInfo", sender: nil)
                case .failure(let error):
                    print("Album ID proccessing error \(error)")
                }
            })
        case 9:
            DatabaseManager.shared.findVideoById(videoid: String(id), completion: { [weak self] result in
                guard let strongSelf = self else {return}
                switch result {
                case .success(let video):
                    strongSelf.infoDetailContent = video
                    strongSelf.performSegue(withIdentifier: "allFavoritesToInfo", sender: nil)
                case .failure(let error):
                    print("Video ID proccessing error \(error)")
                }
            })
        case 10:
            DatabaseManager.shared.findSongById(songId: String(id), completion: { [weak self] result in
                guard let strongSelf = self else {return}
                switch result {
                case .success(let song):
                    strongSelf.infoDetailContent = song as SongData
                    strongSelf.performSegue(withIdentifier: "allFavoritesToInfo", sender: nil)
                case .failure(let error):
                    print("Song ID proccessing error \(error)")
                }
            })
        case 12:
            DatabaseManager.shared.findInstrumentalById(instrumentalId: String(id), completion: { [weak self] result in
                guard let strongSelf = self else {return}
                switch result {
                case .success(let instrumental):
                    strongSelf.infoDetailContent = instrumental as InstrumentalData
                    strongSelf.performSegue(withIdentifier: "allFavoritesToInfo", sender: nil)
                case .failure(let error):
                    print("Song ID proccessing error \(error)")
                }
            })
        case 13, 14:
            DatabaseManager.shared.findBeatById(beatId: String(id), completion: { [weak self] result in
                guard let strongSelf = self else {return}
                switch result {
                case .success(let beat):
                    strongSelf.infoDetailContent = beat as BeatData
                    strongSelf.performSegue(withIdentifier: "allFavoritesToBeatInfo", sender: nil)
                case .failure(let error):
                    print("Beat ID proccessing error \(error)")
                }
            })
        default:
            print("ERRRRRRR")
        }
        
    }
    
    
}

class FavoritesTableView: UITableView {
    override var intrinsicContentSize: CGSize {
        layoutIfNeeded()
        return CGSize(width: UIView.noIntrinsicMetric, height: contentSize.height)
    }
}

import MarqueeLabel

class allUserFavoritesTableViewCellController: UITableViewCell {
    
    @IBOutlet weak var background: UIView!
    @IBOutlet weak var artwork: UIImageView!
    @IBOutlet weak var typeLabel: MarqueeLabel!
    @IBOutlet weak var name: MarqueeLabel!
    @IBOutlet weak var artist: MarqueeLabel!
    var currentObject:AnyObject!
    var artNames:[String]!
    var backgroundImageView:UIImageView!
    var bcollect:UITableView!
    var blurView:UIVisualEffectView!
    
    override func prepareForReuse() {
        artwork.backgroundColor = .clear
        artwork.image = nil
        if backgroundImageView != nil, backgroundImageView.image != nil {
            backgroundImageView.image = nil
        }
        backgroundImageView = nil
        blurView = nil
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        artwork.layer.cornerRadius = 5
    }
    
    func setTemp(tableView: UITableView, favorite: UserFavorite) {
        bcollect = tableView
        let dbid = favorite.dbid
        let word = dbid.split(separator: "Æ")
        let id = word[0]
        switch id.count {
        case 8:
            DatabaseManager.shared.findAlbumById(albumId: String(id), completion: { [weak self] result in
                guard let strongSelf = self else {return}
                switch result {
                case .success(let album):
                    strongSelf.funcSetTemp(album: album)
                case .failure(let error):
                    print("Album ID proccessing error \(error)")
                }
            })
        case 10:
            DatabaseManager.shared.findSongById(songId: String(id), completion: { [weak self] result in
                guard let strongSelf = self else {return}
                switch result {
                case .success(let song):
                    strongSelf.funcSetTemp(song: song)
                case .failure(let error):
                    print("Album ID proccessing error \(error)")
                }
            })
        case 12:
            DatabaseManager.shared.findInstrumentalById(instrumentalId: String(id), completion: { [weak self] result in
                guard let strongSelf = self else {return}
                switch result {
                case .success(let instrumental):
                    strongSelf.funcSetTemp(instrumental: instrumental)
                case .failure(let error):
                    print("Album ID proccessing error \(error)")
                }
            })
        case 13, 14:
            DatabaseManager.shared.findBeatById(beatId: String(id), completion: { [weak self] result in
                guard let strongSelf = self else {return}
                switch result {
                case .success(let beat):
                    strongSelf.funcSetTemp(beat: beat)
                case .failure(let error):
                    print("Album ID proccessing error \(error)")
                }
            })
        default:
            print("ERRRRRRR")
        }
    }
    
    func funcSetTemp(song: SongData) {
        currentObject = song
        name.text = song.name
        typeLabel.text = "--SONG--"
        var songart:[String] = []
        for art in song.songArtist {
            let word = art.split(separator: "Æ")
            let id = word[1]
            songart.append(String(id))
        }
        artNames = songart
        artist.text = songart.joined(separator: ", ")
        GlobalFunctions.shared.selectImageURL(song: song, completion: {[weak self] ur in
            guard let strongSelf = self else {return}
            let imageurl = ur!
            if let url = URL.init(string: imageurl) {
                strongSelf.blurredBackground(collect: strongSelf.bcollect, url: url, videoCellView: strongSelf.background)
                if let cachedImage = imageCache.object(forKey: url.absoluteString as NSString) {
                    strongSelf.artwork.image = cachedImage
                } else {
                    strongSelf.artwork.setImage(from: url, withPlaceholder: UIImage(named: "tonedeaflogo"))
                }
            }
        })
    }
    func funcSetTemp(beat: BeatData) {
        currentObject = beat
        name.text = beat.name
        typeLabel.text = "--BEAT--"
        var songart:[String] = []
        for art in beat.producers {
            let word = art.split(separator: "Æ")
            let id = word[1]
            songart.append(String(id))
        }
        artist.text = songart.joined(separator: ", ")
        let imageurl = beat.imageURL
        if let url = URL.init(string: imageurl) {
            blurredBackground(collect: bcollect, url: url, videoCellView: background)
            if let cachedImage = imageCache.object(forKey: url.absoluteString as NSString) {
                artwork.image = cachedImage
            } else {
                artwork.setImage(from: url, withPlaceholder: UIImage(named: "tonedeaflogo"))
            }
        }
    }
    func funcSetTemp(instrumental: InstrumentalData) {
        currentObject = instrumental
        name.text = instrumental.instrumentalName
        typeLabel.text = "--INSTRUMENTAL--"
        var songart:[String] = []
        for art in instrumental.artist! {
            let word = art.split(separator: "Æ")
            let id = word[1]
            songart.append(String(id))
        }
        artist.text = songart.joined(separator: ", ")
        let imageurl = "instrumental.imageURL"
        if let url = URL.init(string: imageurl) {
            blurredBackground(collect: bcollect, url: url, videoCellView: background)
            if let cachedImage = imageCache.object(forKey: url.absoluteString as NSString) {
                artwork.image = cachedImage
            } else {
                artwork.setImage(from: url, withPlaceholder: UIImage(named: "tonedeaflogo"))
            }
        }
    }
    func funcSetTemp(album: AlbumData) {
        currentObject = album
        name.text = album.name
        typeLabel.text = "--ALBUM--"
        var songart:[String] = []
        for art in album.mainArtist {
            let word = art.split(separator: "Æ")
            let id = word[1]
            songart.append(String(id))
        }
        artist.text = songart.joined(separator: ", ")
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
            blurredBackground(collect: bcollect, url: url, videoCellView: background)
            if let cachedImage = imageCache.object(forKey: url.absoluteString as NSString) {
                artwork.image = cachedImage
            } else {
                artwork.setImage(from: url, withPlaceholder: UIImage(named: "tonedeaflogo"))
            }
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
    
    func blurredBackground(collect: UITableView, url: URL, videoCellView: UIView) {
        backgroundImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: videoCellView.bounds.width, height: videoCellView.bounds.height))
        backgroundImageView.contentMode = .scaleAspectFill
        videoCellView.addSubview(backgroundImageView)
        if let cachedImage = imageCache.object(forKey: url.absoluteString as NSString) {
            backgroundImageView.image = cachedImage
        } else {
            backgroundImageView.setImage(from: url, withPlaceholder: UIImage(named: "tonedeaflogo"))
        }
        let blur = UIBlurEffect(style: .dark)
        blurView = UIVisualEffectView(effect: blur)
        blurView.frame = videoCellView.bounds
        videoCellView.addSubview(blurView)
        videoCellView.sendSubviewToBack(blurView)
        videoCellView.addSubview(backgroundImageView)
        videoCellView.sendSubviewToBack(backgroundImageView)
    }
}

class allUserFavoritesVideoTableViewCellController: UITableViewCell {
    
    @IBOutlet weak var background: UIView!
    @IBOutlet weak var thumbnail: UIImageView!
    @IBOutlet weak var typeLabel: MarqueeLabel!
    @IBOutlet weak var name: MarqueeLabel!
    @IBOutlet weak var artist: MarqueeLabel!
    var currentVideo:AnyObject!
    var backgroundImageView:UIImageView!
    var bcollect:UITableView!
    var blurView:UIVisualEffectView!
    
    override func prepareForReuse() {
        thumbnail.backgroundColor = .clear
        thumbnail.image = nil
        if backgroundImageView != nil, backgroundImageView.image != nil {
            backgroundImageView.image = nil
        }
        backgroundImageView = nil
        blurView = nil
    }
    
    func setTemp(tableView: UITableView,favorite: UserFavorite) {
        bcollect = tableView
        let dbid = favorite.dbid
        let word = dbid.split(separator: "Æ")
        let id = word[0]
        DatabaseManager.shared.findVideoById(videoid: String(id), completion: { [weak self] result in
            guard let strongSelf = self else {return}
            switch result {
            case .success(let video):
                strongSelf.funcSetTemp(youtube: video as! YouTubeData)
            case .failure(let error):
                print("Album ID proccessing error \(error)")
            }
        })
    }
    
    func funcSetTemp(youtube: YouTubeData) {
        currentVideo = youtube
        name.text = youtube.title
        typeLabel.text = "--YOUTUBE--"
        var songart:[String] = []
//        for art in youtube.artist {
//            let word = art.split(separator: "Æ")
//            let id = word[1]
//            songart.append(String(id))
//        }
        artist.text = songart.joined(separator: ", ")
        let imageurl = youtube.thumbnailURL
        if let url = URL.init(string: imageurl) {
            blurredBackground(collect: bcollect, url: url, videoCellView: background)
            if let cachedImage = imageCache.object(forKey: url.absoluteString as NSString) {
                thumbnail.image = cachedImage
            } else {
                thumbnail.setImage(from: url, withPlaceholder: UIImage(named: "tonedeaflogo"))
            }
        }
    }
    
    func blurredBackground(collect: UITableView, url: URL, videoCellView: UIView) {
        backgroundImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: videoCellView.bounds.width, height: videoCellView.bounds.height))
        backgroundImageView.contentMode = .scaleAspectFill
        videoCellView.addSubview(backgroundImageView)
        if let cachedImage = imageCache.object(forKey: url.absoluteString as NSString) {
            backgroundImageView.image = cachedImage
        } else {
            backgroundImageView.setImage(from: url, withPlaceholder: UIImage(named: "tonedeaflogo"))
        }
        let blur = UIBlurEffect(style: .dark)
        blurView = UIVisualEffectView(effect: blur)
        blurView.frame = videoCellView.bounds
        videoCellView.addSubview(blurView)
        videoCellView.sendSubviewToBack(blurView)
        videoCellView.addSubview(backgroundImageView)
        videoCellView.sendSubviewToBack(backgroundImageView)
    }
}
