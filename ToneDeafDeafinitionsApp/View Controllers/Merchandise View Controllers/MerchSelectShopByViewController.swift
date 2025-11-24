//
//  MerchSelectShopByViewController.swift
//  ToneDeafDeafinitionsApp
//
//  Created by Tone Deaf on 11/15/20.
//  Copyright © 2020 GITEM Solutions. All rights reserved.
//

import UIKit
import SideMenu

class MerchSelectShopByViewController: UIViewController {
    
    @IBOutlet weak var shopBySearchBar:UISearchBar!
    @IBOutlet weak var shopByCollectionView:UICollectionView!
    
    var recievedShopType:String!
    var dataToGo:Any!
    
    var soundsArr:[String] = ["Sound Kits", "Loops"]
    var artistArr:[ArtistData]!
    var producerArr:[ProducerData]!
    var songArr:[SongData]!
    var videoArr:[AnyObject]!
    var albumArr:[AlbumData]!
    var instrumentalArr:[InstrumentalData]!
    var beatArr:[BeatData]!
    var releaseArr:[[Any]] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        setCollection()
        
    }

    func setCollection() {
        shopByCollectionView.delaysContentTouches = false
        switch recievedShopType {
        case "sounds":
            self.navigationItem.title = "Sound Select"
            DatabaseManager.shared.fetchAllArtistFromDatabase(completion: {[weak self] allart in
                guard let strongSelf = self else {return}
                strongSelf.artistArr = []
                for item in allart {
                    if let _ = item.merch {
                        strongSelf.artistArr.append(item)
                    }
                }
                strongSelf.shopByCollectionView.delegate = self
                strongSelf.shopByCollectionView.dataSource = self
                strongSelf.shopByCollectionView.reloadData()
                strongSelf.view.layoutSubviews()
            })
        case "artists":
            self.navigationItem.title = "Artist Select"
            DatabaseManager.shared.fetchAllArtistFromDatabase(completion: {[weak self] allart in
                guard let strongSelf = self else {return}
                strongSelf.artistArr = []
                for item in allart {
                    if let _ = item.merch {
                        strongSelf.artistArr.append(item)
                    }
                }
                strongSelf.shopByCollectionView.delegate = self
                strongSelf.shopByCollectionView.dataSource = self
                strongSelf.shopByCollectionView.reloadData()
                strongSelf.view.layoutSubviews()
            })
        case "producers":
            self.navigationItem.title = "Producer Select"
            DatabaseManager.shared.fetchAllProducersFromDatabase(completion: {[weak self] allpro in
                guard let strongSelf = self else {return}
                strongSelf.producerArr = []
                for item in allpro {
                    if let _ = item.merch {
                        strongSelf.producerArr.append(item)
                    }
                }
                strongSelf.shopByCollectionView.delegate = self
                strongSelf.shopByCollectionView.dataSource = self
                strongSelf.shopByCollectionView.reloadData()
                strongSelf.view.layoutSubviews()
            })
        case "songs":
            self.navigationItem.title = "Song Select"
            DatabaseManager.shared.fetchAllSongsFromDatabase(completion: {[weak self] allsong in
                guard let strongSelf = self else {return}
                strongSelf.songArr = []
                for item in allsong {
                    if let _ = item.merch {
                        strongSelf.songArr.append(item)
                    }
                }
                strongSelf.shopByCollectionView.delegate = self
                strongSelf.shopByCollectionView.dataSource = self
                strongSelf.shopByCollectionView.reloadData()
                strongSelf.view.layoutSubviews()
            })
        case "videos":
            self.navigationItem.title = "Video Select"
            DatabaseManager.shared.fetchAllVideosFromDatabase(completion: {[weak self] allvid in
                guard let strongSelf = self else {return}
                strongSelf.videoArr = []
                for item in allvid {
                    switch item {
                    case is YouTubeData:
                        let youtube = item as! YouTubeData
//                        if let _ = youtube.merch {
//                            strongSelf.videoArr.append(youtube)
//                        }
                    default:
                        print("shgh")
                    }
                }
                strongSelf.shopByCollectionView.delegate = self
                strongSelf.shopByCollectionView.dataSource = self
                strongSelf.shopByCollectionView.reloadData()
                strongSelf.view.layoutSubviews()
            })
        case "albums":
            self.navigationItem.title = "Album Select"
            DatabaseManager.shared.fetchAllAlbumsFromDatabase(completion: {[weak self] allalbum in
                guard let strongSelf = self else {return}
                strongSelf.albumArr = []
                for item in allalbum {
                    if let _ = item.merch {
                        strongSelf.albumArr.append(item)
                    }
                }
                strongSelf.shopByCollectionView.delegate = self
                strongSelf.shopByCollectionView.dataSource = self
                strongSelf.shopByCollectionView.reloadData()
                strongSelf.view.layoutSubviews()
            })
        case "instrumentals":
            self.navigationItem.title = "Instrumental Select"
            DatabaseManager.shared.fetchAllInstrumentalsFromDatabase(completion: {[weak self] allinstr in
                guard let strongSelf = self else {return}
                strongSelf.instrumentalArr = []
                for item in allinstr {
                    if let _ = item.storeInfo {
                        strongSelf.instrumentalArr.append(item)
                    }
                }
                
                strongSelf.shopByCollectionView.delegate = self
                strongSelf.shopByCollectionView.dataSource = self
                strongSelf.shopByCollectionView.reloadData()
                strongSelf.view.layoutSubviews()
            })
        case "beats":
            self.navigationItem.title = "Beat Select"
            DatabaseManager.shared.fetchAllBeatsFromDatabase(completion: {[weak self] allbeat in
                guard let strongSelf = self else {return}
                strongSelf.beatArr = []
                for item in allbeat {
                    if let _ = item.merch {
                        strongSelf.beatArr.append(item)
                    }
                }
                strongSelf.shopByCollectionView.delegate = self
                strongSelf.shopByCollectionView.dataSource = self
                strongSelf.shopByCollectionView.reloadData()
                strongSelf.view.layoutSubviews()
            })
        case "release":
            self.navigationItem.title = "Release Select"
            releaseArr = []
            DatabaseManager.shared.fetchAllMerch(completion: {[weak self] merc in
                guard let strongSelf = self else {return}
                var dbidarr:[String] = []
                for item in merc {
                    if let merch = item.kit {
                        if let ids = merch.songs {
                            dbidarr.append(contentsOf: ids)
                        }
                        if let ids = merch.videos {
                            dbidarr.append(contentsOf: ids)
                        }
                        if let ids = merch.albums {
                            dbidarr.append(contentsOf: ids)
                        }
                        if let ids = merch.instrumentals {
                            dbidarr.append(contentsOf: ids)
                        }
                        if let ids = merch.beats {
                            dbidarr.append(contentsOf: ids)
                        }
                    } else if let merch = item.apperal{
                        if let ids = merch.songs {
                            dbidarr.append(contentsOf: ids)
                        }
                        if let ids = merch.videos {
                            dbidarr.append(contentsOf: ids)
                        }
                        if let ids = merch.albums {
                            dbidarr.append(contentsOf: ids)
                        }
                        if let ids = merch.instrumentals {
                            dbidarr.append(contentsOf: ids)
                        }
                        if let ids = merch.beats {
                            dbidarr.append(contentsOf: ids)
                        }
                    } else if let merch = item.memorabilia{
                        if let ids = merch.songs {
                            dbidarr.append(contentsOf: ids)
                        }
                        if let ids = merch.videos {
                            dbidarr.append(contentsOf: ids)
                        }
                        if let ids = merch.albums {
                            dbidarr.append(contentsOf: ids)
                        }
                        if let ids = merch.instrumentals {
                            dbidarr.append(contentsOf: ids)
                        }
                        if let ids = merch.beats {
                            dbidarr.append(contentsOf: ids)
                        }
                    } else if let merch = item.instrumentalSale{
                        dbidarr.append(merch.instrumentaldbid)
                    }
                }
                var tick = 0
                var songarr:[SongData] = []
                var albumarr:[AlbumData] = []
                var videoarr:[AnyObject] = []
                var instrarr:[InstrumentalData] = []
                var beatarr:[BeatData] = []
                for item in dbidarr {
                    let word = item.split(separator: "Æ")
                    let id = String(word[0])
                    switch id.count {
                    case 13...14:
                        DatabaseManager.shared.findBeatById(beatId: id, completion: { result in
                            switch result {
                            case .success(let add):
                                beatarr.append(add)
                                tick+=1
                                if tick == dbidarr.count {
                                    if !songarr.isEmpty {
                                        strongSelf.releaseArr.append(songarr)
                                    }
                                    if !albumarr.isEmpty {
                                        strongSelf.releaseArr.append(albumarr)
                                    }
                                    if !videoarr.isEmpty {
                                        strongSelf.releaseArr.append(videoarr)
                                    }
                                    if !instrarr.isEmpty {
                                        strongSelf.releaseArr.append(instrarr)
                                    }
                                    if !beatarr.isEmpty {
                                        strongSelf.releaseArr.append(beatarr)
                                    }
                                    strongSelf.shopByCollectionView.delegate = self
                                    strongSelf.shopByCollectionView.dataSource = self
                                    strongSelf.shopByCollectionView.reloadData()
                                    strongSelf.view.layoutSubviews()
                                    return
                                }
                            case .failure(let err):
                                print("dsvgredfxbdfzx"+err.localizedDescription)
                            }
                        })
                    case 12:
                        DatabaseManager.shared.findInstrumentalById(instrumentalId: id, completion: { result in
                            switch result {
                            case .success(let add):
                                instrarr.append(add)
                                tick+=1
                                if tick == dbidarr.count {
                                    if !songarr.isEmpty {
                                        strongSelf.releaseArr.append(songarr)
                                    }
                                    if !albumarr.isEmpty {
                                        strongSelf.releaseArr.append(albumarr)
                                    }
                                    if !videoarr.isEmpty {
                                        strongSelf.releaseArr.append(videoarr)
                                    }
                                    if !instrarr.isEmpty {
                                        strongSelf.releaseArr.append(instrarr)
                                    }
                                    if !beatarr.isEmpty {
                                        strongSelf.releaseArr.append(beatarr)
                                    }
                                    strongSelf.shopByCollectionView.delegate = self
                                    strongSelf.shopByCollectionView.dataSource = self
                                    strongSelf.shopByCollectionView.reloadData()
                                    strongSelf.view.layoutSubviews()
                                    return
                                }
                            case .failure(let err):
                                print("dsvgredfxbdfzx"+err.localizedDescription)
                            }
                        })
                    case 10:
                        DatabaseManager.shared.findSongById(songId: id, completion: { result in
                            switch result {
                            case .success(let add):
                                songarr.append(add)
                                tick+=1
                                if tick == dbidarr.count {
                                    if !songarr.isEmpty {
                                        strongSelf.releaseArr.append(songarr)
                                    }
                                    if !albumarr.isEmpty {
                                        strongSelf.releaseArr.append(albumarr)
                                    }
                                    if !videoarr.isEmpty {
                                        strongSelf.releaseArr.append(videoarr)
                                    }
                                    if !instrarr.isEmpty {
                                        strongSelf.releaseArr.append(instrarr)
                                    }
                                    if !beatarr.isEmpty {
                                        strongSelf.releaseArr.append(beatarr)
                                    }
                                    strongSelf.shopByCollectionView.delegate = self
                                    strongSelf.shopByCollectionView.dataSource = self
                                    strongSelf.shopByCollectionView.reloadData()
                                    strongSelf.view.layoutSubviews()
                                    return
                                }
                            case .failure(let err):
                                print("dsvgredfxbdfzx"+err.localizedDescription)
                            }
                        })
                    case 9:
                        DatabaseManager.shared.findVideoById(videoid: id, completion: { result in
                            switch result {
                            case .success(let add):
                                videoarr.append(add)
                                tick+=1
                                if tick == dbidarr.count {
                                    if !songarr.isEmpty {
                                        strongSelf.releaseArr.append(songarr)
                                    }
                                    if !albumarr.isEmpty {
                                        strongSelf.releaseArr.append(albumarr)
                                    }
                                    if !videoarr.isEmpty {
                                        strongSelf.releaseArr.append(videoarr)
                                    }
                                    if !instrarr.isEmpty {
                                        strongSelf.releaseArr.append(instrarr)
                                    }
                                    if !beatarr.isEmpty {
                                        strongSelf.releaseArr.append(beatarr)
                                    }
                                    strongSelf.shopByCollectionView.delegate = self
                                    strongSelf.shopByCollectionView.dataSource = self
                                    strongSelf.shopByCollectionView.reloadData()
                                    strongSelf.view.layoutSubviews()
                                    return
                                }
                            case .failure(let err):
                                print("dsvgredfxbdfzx"+err.localizedDescription)
                            }
                        })
                    case 8:
                        DatabaseManager.shared.findAlbumById(albumId: id, completion: { result in
                            switch result {
                            case .success(let add):
                                albumarr.append(add)
                                tick+=1
                                if tick == dbidarr.count {
                                    if !songarr.isEmpty {
                                        strongSelf.releaseArr.append(songarr)
                                    }
                                    if !albumarr.isEmpty {
                                        strongSelf.releaseArr.append(albumarr)
                                    }
                                    if !videoarr.isEmpty {
                                        strongSelf.releaseArr.append(videoarr)
                                    }
                                    if !instrarr.isEmpty {
                                        strongSelf.releaseArr.append(instrarr)
                                    }
                                    if !beatarr.isEmpty {
                                        strongSelf.releaseArr.append(beatarr)
                                    }
                                    strongSelf.shopByCollectionView.delegate = self
                                    strongSelf.shopByCollectionView.dataSource = self
                                    strongSelf.shopByCollectionView.reloadData()
                                    strongSelf.view.layoutSubviews()
                                    return
                                }
                            case .failure(let err):
                                print("dsvgredfxbdfzx"+err.localizedDescription)
                            }
                        })
                    default:
                        print("")
                    }
                }
            })
            print("")
        default:
            print("jdnsbvzhjx")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "shopByToMerchAll" {
            if let viewController: MerchAllContentViewController = segue.destination as? MerchAllContentViewController {
                viewController.recievedData = dataToGo
            }
        }
        if segue.identifier == "shopByToShopBy" {
            if let viewController: MerchSelectShopByViewController = segue.destination as? MerchSelectShopByViewController {
                viewController.recievedShopType = dataToGo as! String
            }
        }
    }
    
    @IBAction func profileTapped(_ sender: Any) {
        SideMenuManager.default.rightMenuNavigationController = profileSideMenu
        profileSideMenu.presentationStyle = .viewSlideOutMenuIn
        //profileSideMenu.setNavigationBarHidden(true, animated: false)
        present(profileSideMenu, animated: true, completion: nil)
    }
    
    @IBAction func cartTapped(_ sender: Any) {
        NotificationCenter.default.post(name: OpenTheCartNotify, object: nil)
    }
}

extension MerchSelectShopByViewController: UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch recievedShopType {
        case "sounds":
            return 2
        case "artists":
            return artistArr.count
        case "producers":
            return producerArr.count
        case "songs":
            return songArr.count
        case "videos":
            return videoArr.count
        case "albums":
            return albumArr.count
        case "instrumentals":
            return instrumentalArr.count
        case "beats":
            return beatArr.count
        case "release":
            return releaseArr.count
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "selectShopByCollectionViewCell", for: indexPath) as! SelectShopByCollectionViewCell
        switch recievedShopType {
        case "sounds":
            let item = soundsArr[indexPath.item]
            cell.setUp(sound: item)
        case "artists":
            let item = artistArr[indexPath.item]
            cell.setUp(artist: item)
        case "producers":
            let item = producerArr[indexPath.item]
            cell.setUp(producer: item)
        case "songs":
            let item = songArr[indexPath.item]
            cell.setUp(song: item)
        case "videos":
            let item = videoArr[indexPath.item]
            switch item {
            case is YouTubeData:
                let youtube = item as! YouTubeData
                cell.setUp(youtube: youtube)
            default:
                print("sdvhghbn")
            }
        case "albums":
            let item = albumArr[indexPath.item]
            cell.setUp(album: item)
        case "instrumentals":
            let item = instrumentalArr[indexPath.item]
            cell.setUp(instrumental: item)
        case "beats":
            let item = beatArr[indexPath.item]
            cell.setUp(beat: item)
        case "release":
            let item = releaseArr[indexPath.item]
            cell.artwork.tintColor = .white
            cell.artwork.contentMode = .scaleAspectFit
            switch item[0] {
            case is SongData:
                cell.artwork.image = UIImage(systemName: "music.quarternote.3")
                cell.shopByInvolved.isHidden = true
                cell.shopByTitle.text = "Songs"
            case is YouTubeData:
                cell.artwork.image = UIImage(systemName: "video.fill")
                cell.shopByInvolved.isHidden = true
                cell.shopByTitle.text = "Videos"
            case is AlbumData:
                cell.artwork.image = UIImage(systemName: "square.stack.3d.up.fill")
                cell.shopByInvolved.isHidden = true
                cell.shopByTitle.text = "Albums"
            case is InstrumentalData:
                cell.artwork.image = UIImage(systemName: "pianokeys.inverse")
                cell.shopByInvolved.isHidden = true
                cell.shopByTitle.text = "Instrumentals"
            case is BeatData:
                cell.artwork.image = UIImage(systemName: "hifispeaker.fill")
                cell.shopByInvolved.isHidden = true
                cell.shopByTitle.text = "Beats"
            default:
                print("big flop")
            }
        default:
            print("jdnsbvzhjx")
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch recievedShopType {
        case "sounds":
            dataToGo = soundsArr[indexPath.item]
            switch soundsArr[indexPath.item] {
            case "Loops":
                print("loops")
            default:
                dataToGo = "kits"
                performSegue(withIdentifier: "shopByToMerchAll", sender: nil)
            }
        case "artists":
            dataToGo = artistArr[indexPath.item]
            performSegue(withIdentifier: "shopByToMerchAll", sender: nil)
        case "producers":
            dataToGo = producerArr[indexPath.item]
            performSegue(withIdentifier: "shopByToMerchAll", sender: nil)
        case "songs":
            dataToGo = songArr[indexPath.item]
            performSegue(withIdentifier: "shopByToMerchAll", sender: nil)
        case "videos":
            dataToGo = videoArr[indexPath.item]
            performSegue(withIdentifier: "shopByToMerchAll", sender: nil)
        case "albums":
            dataToGo = albumArr[indexPath.item]
            performSegue(withIdentifier: "shopByToMerchAll", sender: nil)
        case "instrumentals":
            dataToGo = instrumentalArr[indexPath.item]
            performSegue(withIdentifier: "shopByToMerchAll", sender: nil)
        case "beats":
            dataToGo = beatArr[indexPath.item]
            performSegue(withIdentifier: "shopByToMerchAll", sender: nil)
        case "release":
            let item = releaseArr[indexPath.item]
            switch item[0] {
            case is SongData:
                dataToGo = "songs"
            case is YouTubeData:
                dataToGo = "videos"
            case is AlbumData:
                dataToGo = "albums"
            case is InstrumentalData:
                dataToGo = "instrumentals"
            case is BeatData:
                dataToGo = "beats"
            default:
                print("big flop")
            }
            performSegue(withIdentifier: "shopByToShopBy", sender: nil)
        default:
            print("jdnsbvzhjx")
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch recievedShopType {
        case "sounds":
            return CGSize(width: (view.frame.width/4) - 50, height: ((view.frame.width/4) - 50)+32.5)
        case "artists":
            return CGSize(width: (view.frame.width/4) - 50, height: ((view.frame.width/4) - 50)+32.5)
        case "producers":
            return CGSize(width: (view.frame.width/4) - 50, height: ((view.frame.width/4) - 50)+32.5)
        case "release":
            return CGSize(width: (view.frame.width/4) - 50, height: ((view.frame.width/4) - 50)+32.5)
        default:
            return CGSize(width: (view.frame.width/4) - 50, height: ((view.frame.width/4) - 50)+60)
        }
    }
}

import MarqueeLabel

class SelectShopByCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var artwork:UIImageView!
    @IBOutlet weak var shopByTitle:MarqueeLabel!
    @IBOutlet weak var shopByInvolved:MarqueeLabel!
    
    override var isHighlighted: Bool {
        didSet{
            tapScale(cell: self, down: isHighlighted)
        }
    }
    
    func setUp(sound: String) {
        artwork.layer.cornerRadius = artwork.frame.width/2
        shopByInvolved.isHidden = true
        shopByTitle.text = sound
        var defaultimg:UIImage
        switch sound {
        case "Loops":
            defaultimg = UIImage(named: "defaultuser")!
        default :
            defaultimg = UIImage(named: "defaultuser")!
        }
        artwork.image = defaultimg
    }
    
    func setUp(artist: ArtistData) {
        artwork.layer.cornerRadius = artwork.frame.width/2
        shopByInvolved.isHidden = true
        shopByTitle.text = artist.name
        GlobalFunctions.shared.selectImageURL(artist: artist, completion: {[weak self] aimage in
            guard let strongSelf = self else {return}
            guard let img = aimage else {
                let defaultimg = UIImage(named: "defaultuser")!
                strongSelf.artwork.image = defaultimg
                return
            }
            let imageURL = URL(string: img)!
            if let cachedImage = imageCache.object(forKey: imageURL.absoluteString as NSString) {
                strongSelf.artwork.image = cachedImage
                return
            } else {
                strongSelf.artwork.setImage(from: imageURL, withPlaceholder: UIImage(named: "tonedeaflogo"))
                return
            }
        })
    }
    
    func setUp(producer: ProducerData) {
        artwork.layer.cornerRadius = artwork.frame.width/2
        shopByInvolved.isHidden = true
        shopByTitle.text = producer.name
        GlobalFunctions.shared.selectImageURL(producer: producer, completion: {[weak self] aimage in
            guard let strongSelf = self else {return}
            guard let img = aimage else {
                let defaultimg = UIImage(named: "defaultuser")!
                strongSelf.artwork.image = defaultimg
                return
            }
            let imageURL = URL(string: img)!
            if let cachedImage = imageCache.object(forKey: imageURL.absoluteString as NSString) {
                strongSelf.artwork.image = cachedImage
                return
            } else {
                strongSelf.artwork.setImage(from: imageURL, withPlaceholder: UIImage(named: "tonedeaflogo"))
                return
            }
        })
    }
    
    func setUp(song: SongData) {
        artwork.layer.cornerRadius = 7
        var songart:[String] = []
        for art in song.songArtist {
            let word = art.split(separator: "Æ")
            let id = word[1]
            songart.append(String(id))
        }
        var songapro:[String] = []
        for pro in song.songProducers {
            let word = pro.split(separator: "Æ")
            let id = word[1]
            songapro.append(String(id))
        }
        shopByInvolved.text = "\(songart.joined(separator: ", ")), \(songapro.joined(separator: ", "))"
        shopByTitle.text = song.name
        GlobalFunctions.shared.selectImageURL(song: song, completion: {[weak self] aimage in
            guard let strongSelf = self else {return}
            guard let img = aimage else {
                let defaultimg = UIImage(named: "defaultuser")!
                strongSelf.artwork.image = defaultimg
                return
            }
            let imageURL = URL(string: img)!
            if let cachedImage = imageCache.object(forKey: imageURL.absoluteString as NSString) {
                strongSelf.artwork.image = cachedImage
                return
            } else {
                strongSelf.artwork.setImage(from: imageURL, withPlaceholder: UIImage(named: "tonedeaflogo"))
                return
            }
        })
    }
    
    func setUp(youtube: YouTubeData) {
        artwork.layer.cornerRadius = 7
        var songart:[String] = []
//        for art in youtube.artist {
//            let word = art.split(separator: "Æ")
//            let id = word[1]
//            songart.append(String(id))
//        }
        var songapro:[String] = []
//        for pro in youtube.producers {
//            let word = pro.split(separator: "Æ")
//            let id = word[1]
//            songapro.append(String(id))
//        }
        shopByInvolved.text = "\(songart.joined(separator: ", ")), \(songapro.joined(separator: ", "))"
        shopByTitle.text = youtube.title
        let imageURL = URL(string: youtube.thumbnailURL)!
        if let cachedImage = imageCache.object(forKey: imageURL.absoluteString as NSString) {
            artwork.image = cachedImage
            return
        } else {
            artwork.setImage(from: imageURL, withPlaceholder: UIImage(named: "tonedeaflogo"))
            return
        }
    }
    
    func setUp(album: AlbumData) {
        artwork.layer.cornerRadius = 7
        artwork.contentMode = .scaleAspectFit
        var songart:[String] = []
//        for art in album.allArtists {
//            let word = art.split(separator: "Æ")
//            let id = word[1]
//            songart.append(String(id))
//        }
        var songapro:[String] = []
        for pro in album.producers {
            let word = pro.split(separator: "Æ")
            let id = word[1]
            songapro.append(String(id))
        }
        shopByInvolved.text = "\(songart.joined(separator: ", ")), \(songapro.joined(separator: ", "))"
        shopByTitle.text = album.name
        GlobalFunctions.shared.selectImageURL(album: album, completion: {[weak self] aimage in
            guard let strongSelf = self else {return}
            guard let img = aimage else {
                let defaultimg = UIImage(named: "defaultuser")!
                strongSelf.artwork.image = defaultimg
                return
            }
            let imageURL = URL(string: img)!
            if let cachedImage = imageCache.object(forKey: imageURL.absoluteString as NSString) {
                strongSelf.artwork.image = cachedImage
                return
            } else {
                strongSelf.artwork.setImage(from: imageURL, withPlaceholder: UIImage(named: "tonedeaflogo"))
                return
            }
        })
    }
    
    func setUp(instrumental: InstrumentalData) {
        artwork.layer.cornerRadius = 7
        var songart:[String] = []
        for art in instrumental.artist! {
            let word = art.split(separator: "Æ")
            let id = word[1]
            songart.append(String(id))
        }
        var songapro:[String] = []
        for pro in instrumental.producers {
            let word = pro.split(separator: "Æ")
            let id = word[1]
            songapro.append(String(id))
        }
        shopByInvolved.text = "\(songapro.joined(separator: ", ")), \(songart.joined(separator: ", "))"
        shopByTitle.text = instrumental.instrumentalName
        let imageURL = URL(string: "instrumental.imageURL")!
        if let cachedImage = imageCache.object(forKey: imageURL.absoluteString as NSString) {
            artwork.image = cachedImage
            return
        } else {
            artwork.setImage(from: imageURL, withPlaceholder: UIImage(named: "tonedeaflogo"))
            return
        }
    }
    
    func setUp(beat: BeatData) {
        artwork.layer.cornerRadius = 7
        var songapro:[String] = []
        for pro in beat.producers {
            let word = pro.split(separator: "Æ")
            let id = word[1]
            songapro.append(String(id))
        }
        shopByInvolved.text = "\(songapro.joined(separator: ", "))"
        shopByTitle.text = beat.name
        let imageURL = URL(string: beat.imageURL)!
        if let cachedImage = imageCache.object(forKey: imageURL.absoluteString as NSString) {
            artwork.image = cachedImage
            return
        } else {
            artwork.setImage(from: imageURL, withPlaceholder: UIImage(named: "tonedeaflogo"))
            return
        }
    }
}
