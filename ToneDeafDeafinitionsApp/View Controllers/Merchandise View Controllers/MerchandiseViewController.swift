//
//  MerchandiseViewController.swift
//  ToneDeafDeafinitionsApp
//
//  Created by Tone Deaf on 10/25/20.
//  Copyright © 2020 GITEM Solutions. All rights reserved.
//

import UIKit
import CollectionViewSlantedLayout
import NVActivityIndicatorView
import SideMenu

class MerchandiseViewController: UIViewController {
    
    let categories = ["Latest Merch","Sounds","Instrumentals","Apparel","Services","Memorabilia","On Sale","Shop By Artist", "Shop By Producer","Shop By Release"]
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var collectionViewLayout: CollectionViewSlantedLayout!
    @IBOutlet weak var activityspinner: NVActivityIndicatorView!
    
    var merchArray:[Any] = ["blank" as Any, "blank" as Any, "blank" as Any, "blank" as Any, UIView(), "blank" as Any, "blank" as Any, "ArtistData" as Any, "ProducerData" as String, "Any" as String]
    
    var toneServices:[String] = ["Mixing","Mastering","Engineering","Custom Beats","Custom Loops"]
    
    var initialLoad = false
    var dataToGo:String!

    override func viewDidLoad() {
        super.viewDidLoad()
        activityspinner.type = .circleStrokeSpin
        activityspinner.startAnimating()
        collectionView.isHidden = true
        setArray()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if initialLoad {
            collectionView.reloadData()
            view.layoutSubviews()
        } else {
            activityspinner.startAnimating()
            collectionView.isHidden = true
        }
        collectionView.collectionViewLayout.invalidateLayout()
    }
    
    func setArray() {
        let queue = DispatchQueue(label: "myhjvkmerchArraySethQkitssssseue")
        let group = DispatchGroup()
        let array = [1,2,3,4,5,6,7,8,9,10]

        for i in array {
            print(i)
            group.enter()
            queue.async { [weak self] in
                guard let strongSelf = self else {return}
                switch i {
                case 1:
                    //print("null")
                    strongSelf.getLatestMerch(completion: {[weak self] done in
                        guard let strongSelf = self else {return}
                        if done == false {
                            
                        }
                        else {
//                            strongSelf.collectionView.reloadData()
//                            strongSelf.view.layoutSubviews()
                            print("done \(i)")
                        }
                        group.leave()
                    })
                case 2:
                    //print("null")
                    strongSelf.getKit(completion: {[weak self] done in
                        guard let strongSelf = self else {return}
                        if done == false {
                            
                        }
                        else {
//                            strongSelf.collectionView.reloadData()
//                            strongSelf.view.layoutSubviews()
                            print("done \(i)")
                        }
                        group.leave()
                    })
                case 3:
                    //print("null")
                    strongSelf.getInstrumental(completion: {[weak self] done in
                        guard let strongSelf = self else {return}
                        if done == false {
                            
                        }
                        else {
//                            strongSelf.collectionView.reloadData()
//                            strongSelf.view.layoutSubviews()
                            print("done \(i)")
                        }
                        group.leave()
                    })
                case 4:
                    //print("null")
                    strongSelf.getApperal(completion: {[weak self] done in
                        guard let strongSelf = self else {return}
                        if done == false {
                            
                        }
                        else {
//                            strongSelf.collectionView.reloadData()
//                            strongSelf.view.layoutSubviews()
                            print("done \(i)")
                        }
                        group.leave()
                    })
                case 5:
                    //print("null")
                    strongSelf.getMemorabilia(completion: {[weak self] done in
                        guard let strongSelf = self else {return}
                        if done == false {
                            
                        }
                        else {
//                            strongSelf.collectionView.reloadData()
//                            strongSelf.view.layoutSubviews()
                            print("done \(i)")
                        }
                        group.leave()
                    })
                case 6:
                    //print("null")
                    strongSelf.getServices(completion: {[weak self] done in
                        guard let strongSelf = self else {return}
                        if done == false {
                            
                        }
                        else {
//                            strongSelf.collectionView.reloadData()
//                            strongSelf.view.layoutSubviews()
                            print("done \(i)")
                        }
                        group.leave()
                    })
                case 7:
                    //print("null")
                    strongSelf.getSaleMerch(completion: {[weak self] done in
                        guard let strongSelf = self else {return}
                        if done == false {
                            
                        }
                        else {
//                            strongSelf.collectionView.reloadData()
//                            strongSelf.view.layoutSubviews()
                            print("done \(i)")
                        }
                        group.leave()
                    })
                case 8:
                    //print("null")
                    strongSelf.getArtistWithMerch(completion: {[weak self] done in
                        guard let strongSelf = self else {return}
                        if done == false {
                            
                        }
                        else {
//                            strongSelf.collectionView.reloadData()
//                            strongSelf.view.layoutSubviews()
                            print("done \(i)")
                        }
                        group.leave()
                    })
                case 9:
                    //print("null")
                    strongSelf.getProducerWithMerch(completion: {[weak self] done in
                        guard let strongSelf = self else {return}
                        if done == false {
                            
                        }
                        else {
//                            strongSelf.collectionView.reloadData()
//                            strongSelf.view.layoutSubviews()
                            print("done \(i)")
                        }
                        group.leave()
                    })
                case 10:
                    //print("null")
                    strongSelf.getReleaseWithMerch(completion: {[weak self] done in
                        guard let strongSelf = self else {return}
                        if done == false {
                            
                        }
                        else {
//                            strongSelf.collectionView.reloadData()
//                            strongSelf.view.layoutSubviews()
                            print("done \(i)")
                        }
                        group.leave()
                    })
                default:
                    print("Kit error")
                }
            }
        }
        
        group.notify(queue: DispatchQueue.main) { [weak self] in
            guard let strongSelf = self else {return}
            strongSelf.initialLoad = true
            strongSelf.collectionViewLayout.isFirstCellExcluded = true
            strongSelf.collectionViewLayout.isLastCellExcluded = true
            strongSelf.collectionView.delaysContentTouches = false
            strongSelf.activityspinner.stopAnimating()
            strongSelf.collectionView.isHidden = false
            strongSelf.collectionView.delegate = self
            strongSelf.collectionView.dataSource = self
            strongSelf.collectionView.reloadData()
            //strongSelf.collectionView.setContentOffset(CGPoint(x: 0, y: -100), animated: true)
            strongSelf.view.layoutSubviews()
        }
    }
    
    func getLatestMerch(completion: @escaping ((Bool) -> Void)) {
        DatabaseManager.shared.fetchLatestMerch(amount: 1, completion: {[weak self] merch in
            guard let strongSelf = self else {return}
            strongSelf.merchArray[0] = merch[0]
            completion(true)
        })
    }
    
    func getKit(completion: @escaping ((Bool) -> Void)) {
        DatabaseManager.shared.fetchAllMerchKits(completion: {[weak self] merch in
            guard let strongSelf = self else {return}
            var shuff = merch
            shuff.shuffle()
            strongSelf.merchArray[1] = shuff[0]
            completion(true)
        })
    }
    
    func getInstrumental(completion: @escaping ((Bool) -> Void)) {
        DatabaseManager.shared.fetchAllMerchInstrumentals(completion: {[weak self] merch in
            guard let strongSelf = self else {return}
            var shuff = merch
            shuff.shuffle()
            strongSelf.merchArray[2] = shuff[0]
            completion(true)
        })
    }
    
    func getApperal(completion: @escaping ((Bool) -> Void)) {
        DatabaseManager.shared.fetchAllMerchApperal(completion: {[weak self] merch in
            guard let strongSelf = self else {return}
            var shuff = merch
            shuff.shuffle()
            strongSelf.merchArray[3] = shuff[0]
            
            completion(true)
        })
    }
    
    func getServices(completion: @escaping ((Bool) -> Void)) {
        DatabaseManager.shared.fetchAllMerchServices(completion: {[weak self] merch in
            guard let strongSelf = self else {return}
            var shuff = merch
            shuff.shuffle()
            strongSelf.merchArray[4] = shuff[0]
            
            completion(true)
        })
    }
    
    func getMemorabilia(completion: @escaping ((Bool) -> Void)) {
        DatabaseManager.shared.fetchAllMerchMemorabilia(completion: {[weak self] merch in
            guard let strongSelf = self else {return}
            var shuff = merch
            shuff.shuffle()
            strongSelf.merchArray[5] = shuff[0]
            completion(true)
        })
    }
    
    func getSaleMerch(completion: @escaping ((Bool) -> Void)) {
        DatabaseManager.shared.fetchAllMerchOnSale(completion: {[weak self] merch in
            guard let strongSelf = self else {return}
            var shuff = merch
            shuff.shuffle()
            strongSelf.merchArray[6] = shuff[0]
            completion(true)
        })
    }
    
    func getArtistWithMerch(completion: @escaping ((Bool) -> Void)) {
        DatabaseManager.shared.fetchAllArtistFromDatabase(completion: { [weak self] artist in
            guard let strongSelf = self else {return}
            var artmerch:[ArtistData] = []
            for art in artist {
                if art.merch != nil {
                    artmerch.append(art)
                }
            }
            artmerch.shuffle()
            strongSelf.merchArray[7] = artmerch[0]
            completion(true)
        })
    }
    
    func getProducerWithMerch(completion: @escaping ((Bool) -> Void)) {
        DatabaseManager.shared.fetchAllProducersFromDatabase(completion: { [weak self] producer in
            guard let strongSelf = self else {return}
            var promerch:[ProducerData] = []
            for pro in producer {
                if pro.merch != nil {
                    promerch.append(pro)
                }
            }
            promerch.shuffle()
            strongSelf.merchArray[8] = promerch[0]
            completion(true)
        })
    }
    
    func getReleaseWithMerch(completion: @escaping ((Bool) -> Void)) {
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
            dbidarr.shuffle()
                let word = dbidarr[0].split(separator: "Æ")
                let id = String(word[0])
                switch id.count {
                case 13...14:
                    DatabaseManager.shared.findBeatById(beatId: id, completion: { result in
                        switch result {
                        case .success(let add):
                            strongSelf.merchArray[9] = add
                            completion(true)
                            return
                        case .failure(let err):
                            print("dsvgredfxbdfzx"+err.localizedDescription)
                        }
                    })
                case 12:
                    DatabaseManager.shared.findInstrumentalById(instrumentalId: id, completion: { result in
                        switch result {
                        case .success(let add):
                            strongSelf.merchArray[9] = add
                            completion(true)
                            return
                        case .failure(let err):
                            print("dsvgredfxbdfzx"+err.localizedDescription)
                        }
                    })
                case 10:
                    DatabaseManager.shared.findSongById(songId: id, completion: { result in
                        switch result {
                        case .success(let add):
                            strongSelf.merchArray[9] = add
                            completion(true)
                            return
                        case .failure(let err):
                            print("dsvgredfxbdfzx"+err.localizedDescription)
                        }
                    })
                case 9:
                    DatabaseManager.shared.findVideoById(videoid: id, completion: { result in
                        switch result {
                        case .success(let add):
                            strongSelf.merchArray[9] = add
                            completion(true)
                            return
                        case .failure(let err):
                            print("dsvgredfxbdfzx"+err.localizedDescription)
                        }
                    })
                case 8:
                    DatabaseManager.shared.findAlbumById(albumId: id, completion: { result in
                        switch result {
                        case .success(let add):
                            strongSelf.merchArray[9] = add
                            completion(true)
                            return
                        case .failure(let err):
                            print("dsvgredfxbdfzx"+err.localizedDescription)
                        }
                    })
                default:
                    print("")
                }
                //14 didgits is a beat
                //13 didgits is a paid beat
                //12 digits is an instrumental
                //10 digits is a song
                //9 digits is a video
                //8 digits is an Album
        })
    }
    
    func setUp(latestMerch: MerchData, completion: @escaping ((UIImage, String, String) -> Void)) {
        if let merch = latestMerch.kit {
            let imageURL = URL(string: merch.imageURLs[0])!
            if let cachedImage = imageCache.object(forKey: imageURL.absoluteString as NSString) {
                completion(cachedImage, "Latest Item", "Featured Item: \(merch.name)")
                return
            } else {
                imageURL.getImage(completion: { image in
                    completion(image, "Latest Item", "Featured Item: \(merch.name)")
                    return
                })
            }
        } else if let merch = latestMerch.apperal{
            let imageURL = URL(string: merch.imageURLs[0])!
            if let cachedImage = imageCache.object(forKey: imageURL.absoluteString as NSString) {
                completion(cachedImage, "Latest Item", "Featured Item: \(merch.name)")
                return
            } else {
                imageURL.getImage(completion: { image in
                    completion(image, "Latest Item", "Featured Item: \(merch.name)")
                    return
                })
            }
        } else if let merch = latestMerch.service{
            let image = UIImage(named: "toneservices-1")!
            completion(image, "Latest Item", "Featured Item: \(merch.name)")
        } else if let merch = latestMerch.memorabilia{
            let imageURL = URL(string: merch.imageURLs[0])!
            if let cachedImage = imageCache.object(forKey: imageURL.absoluteString as NSString) {
                completion(cachedImage, "Latest Item", "Featured Item: \(merch.name)")
                return
            } else {
                imageURL.getImage(completion: { image in
                    completion(image, "Latest Item", "Featured Item: \(merch.name)")
                    return
                })
            }
        } else if let merch = latestMerch.instrumentalSale{
            let word = merch.instrumentaldbid.split(separator: "Æ")
            let id = String(word[0])
            DatabaseManager.shared.findInstrumentalById(instrumentalId: id, completion: {[weak self] result in
                guard let strongSelf = self else {return}
                switch result {
                case.success(let instrumental):
                    let imageURL = URL(string: "instrumental.imageURL")!
                    if let cachedImage = imageCache.object(forKey: imageURL.absoluteString as NSString) {
                        completion(cachedImage, "Latest Items", "Featured Item: \(instrumental.instrumentalName)")
                        return
                    } else {
                        imageURL.getImage(completion: { image in
                            completion(image, "Latest Items", "Featured Item: \(instrumental.instrumentalName)")
                            return
                        })
                    }
                case.failure(let err):
                    print("kjhfdgxfgchjk bi \(err)")
                }
            })
        }
    }
    
    func setUp(soundKits: MerchKitData, completion: @escaping ((UIImage, String, String) -> Void)) {
        let imageURL = URL(string: soundKits.imageURLs[0])!
        if let cachedImage = imageCache.object(forKey: imageURL.absoluteString as NSString) {
            completion(cachedImage, "Sounds", "Featured Item: \(soundKits.name)")
            return
        } else {
            imageURL.getImage(completion: { image in
                completion(image, "Sounds", "Featured Item: \(soundKits.name)")
                return
            })
        }
    }
    
    func setUp(instrumental: MerchInstrumentalData, completion: @escaping ((UIImage, String, String) -> Void)) {
        let word = instrumental.instrumentaldbid.split(separator: "Æ")
        let id = String(word[0])
        DatabaseManager.shared.findInstrumentalById(instrumentalId: id, completion: { result in
            switch result {
            case .success(let instr):
                let imageURL = URL(string:"")!
                if let cachedImage = imageCache.object(forKey: imageURL.absoluteString as NSString) {
                    completion(cachedImage, "Instrumentals", "Featured Item: \(instr.instrumentalName)")
                    return
                } else {
                    imageURL.getImage(completion: { image in
                        completion(image, "Instrumentals", "Featured Item: \(instr.instrumentalName)")
                        return
                    })
                }
            case .failure(let err):
                print(err)
            }
        })
    }
    
    func setUp(apperal: MerchApperalData, completion: @escaping ((UIImage, String, String) -> Void)) {
        let imageURL = URL(string: apperal.imageURLs[0])!
        if let cachedImage = imageCache.object(forKey: imageURL.absoluteString as NSString) {
            completion(cachedImage, "Apperal", "Featured Item: \(apperal.name)")
            return
        } else {
            imageURL.getImage(completion: { image in
                completion(image, "Apperal", "Featured Item: \(apperal.name)")
                return
            })
        }
    }
    
    func setUp(memorabilia: MerchMemorabiliaData, completion: @escaping ((UIImage, String, String) -> Void)) {
        let imageURL = URL(string: memorabilia.imageURLs[0])!
        if let cachedImage = imageCache.object(forKey: imageURL.absoluteString as NSString) {
            completion(cachedImage, "Memorabilia", "Featured Item: \(memorabilia.name)")
            return
        } else {
            imageURL.getImage(completion: { image in
                completion(image, "Memorabilia", "Featured Item: \(memorabilia.name)")
                return
            })
        }
    }
    
    func setUp(sale: MerchData, completion: @escaping ((UIImage, String, String) -> Void)) {
        if let merch = sale.kit {
            let imageURL = URL(string: merch.imageURLs[0])!
            if let cachedImage = imageCache.object(forKey: imageURL.absoluteString as NSString) {
                completion(cachedImage, "Shop On Sale", "Featured Item: \(merch.name)")
                return
            } else {
                imageURL.getImage(completion: { image in
                    completion(image, "Shop On Sale", "Featured Item: \(merch.name)")
                    return
                })
            }
        } else if let merch = sale.apperal{
            let imageURL = URL(string: merch.imageURLs[0])!
            if let cachedImage = imageCache.object(forKey: imageURL.absoluteString as NSString) {
                completion(cachedImage, "Shop On Sale", "Featured Item: \(merch.name)")
                return
            } else {
                imageURL.getImage(completion: { image in
                    completion(image, "Shop On Sale", "Featured Item: \(merch.name)")
                    return
                })
            }
        } else if let merch = sale.service{
            let image = UIImage(named: "toneservices-1")!
            completion(image, "Shop On Sale", "Featured Item: \(merch.name)")
        } else if let merch = sale.memorabilia{
            let imageURL = URL(string: merch.imageURLs[0])!
            if let cachedImage = imageCache.object(forKey: imageURL.absoluteString as NSString) {
                completion(cachedImage, "Shop On Sale", "Featured Item: \(merch.name)")
                return
            } else {
                imageURL.getImage(completion: { image in
                    completion(image, "Shop On Sale", "Featured Item: \(merch.name)")
                    return
                })
            }
        } else if let merch = sale.instrumentalSale{
            let word = merch.instrumentaldbid.split(separator: "Æ")
            let id = String(word[0])
            DatabaseManager.shared.findInstrumentalById(instrumentalId: id, completion: {[weak self] result in
                guard let strongSelf = self else {return}
                switch result {
                case.success(let instrumental):
                    let imageURL = URL(string: "instrumental.imageURL")!
                    if let cachedImage = imageCache.object(forKey: imageURL.absoluteString as NSString) {
                        completion(cachedImage, "Shop On Sale", "Featured Item: \(instrumental.instrumentalName)")
                        return
                    } else {
                        imageURL.getImage(completion: { image in
                            completion(image, "Shop On Sale", "Featured Item: \(instrumental.instrumentalName)")
                            return
                        })
                    }
                case.failure(let err):
                    print("kjhfdgxfgchjk bi \(err)")
                }
            })
        }
    }
    
    func setUp(artist: ArtistData, completion: @escaping ((UIImage, String, String) -> Void)) {
        GlobalFunctions.shared.selectImageURL(artist: artist, completion: {aimage in
            guard let img = aimage else {
                let defaultimg = UIImage(named: "defaultuser")!
                completion(defaultimg, "Shop By Artist", "Featured Artist: \(artist.name!)")
                return
            }
            let imageURL = URL(string: img)!
            if let cachedImage = imageCache.object(forKey: imageURL.absoluteString as NSString) {
                completion(cachedImage, "Shop By Artist", "Featured Artist: \(artist.name!)")
                return
            } else {
                imageURL.getImage(completion: { image in
                    completion(image, "Shop By Artist", "Featured Artist: \(artist.name!)")
                    return
                })
            }
        })
    }
    
    func setUp(producer: ProducerData, completion: @escaping ((UIImage, String, String) -> Void)) {
        GlobalFunctions.shared.selectImageURL(producer: producer, completion: {aimage in
            guard let img = aimage else {
                let defaultimg = UIImage(named: "defaultuser")!
                completion(defaultimg, "Shop By Producer", "Featured Producer: \(producer.name!)")
                return
            }
            let imageURL = URL(string: img)!
            if let cachedImage = imageCache.object(forKey: imageURL.absoluteString as NSString) {
                completion(cachedImage, "Shop By Producer", "Featured Producer: \(producer.name!)")
                return
            } else {
                imageURL.getImage(completion: { image in
                    completion(image, "Shop By Producer", "Featured Producer: \(producer.name!)")
                    return
                })
            }
        })
    }
    
    func setUp(release: Any, completion: @escaping ((UIImage, String, String) -> Void)) {
        switch release {
        case is SongData:
            let rel = release as! SongData
            GlobalFunctions.shared.selectImageURL(song: rel, completion: {aimage in
                guard let img = aimage else {
                    let defaultimg = UIImage(named: "defaultuser")!
                    completion(defaultimg, "Shop By Release", "Featured Release: \(rel.name)")
                    return
                }
                let imageURL = URL(string: img)!
                if let cachedImage = imageCache.object(forKey: imageURL.absoluteString as NSString) {
                    completion(cachedImage, "Shop By Release", "Featured Release: \(rel.name)")
                    return
                } else {
                    imageURL.getImage(completion: { image in
                        completion(image, "Shop By Release", "Featured Release: \(rel.name)")
                        return
                    })
                }
            })
        case is YouTubeData:
            let rel = release as! YouTubeData
            let imageURL = URL(string: rel.thumbnailURL)!
            if let cachedImage = imageCache.object(forKey: imageURL.absoluteString as NSString) {
                completion(cachedImage, "Shop By Release", "Featured Release: \(rel.title)")
                return
            } else {
                imageURL.getImage(completion: { image in
                    completion(image, "Shop By Release", "Featured Release: \(rel.title)")
                    return
                })
            }
        case is AlbumData:
            let rel = release as! AlbumData
            GlobalFunctions.shared.selectImageURL(album: rel, completion: {aimage in
                guard let img = aimage else {
                    let defaultimg = UIImage(named: "defaultuser")!
                    completion(defaultimg, "Shop By Release", "Featured Release: \(rel.name)")
                    return
                }
                let imageURL = URL(string: img)!
                if let cachedImage = imageCache.object(forKey: imageURL.absoluteString as NSString) {
                    completion(cachedImage, "Shop By Release", "Featured Release: \(rel.name)")
                    return
                } else {
                    imageURL.getImage(completion: { image in
                        completion(image, "Shop By Release", "Featured Release: \(rel.name)")
                        return
                    })
                }
            })
        case is InstrumentalData:
            let rel = release as! InstrumentalData
            let imageURL = URL(string: "rel.imageURL")!
            if let cachedImage = imageCache.object(forKey: imageURL.absoluteString as NSString) {
                completion(cachedImage, "Shop By Release", "Featured Release: \(rel.instrumentalName)")
                return
            } else {
                imageURL.getImage(completion: { image in
                    completion(image, "Shop By Release", "Featured Release: \(rel.instrumentalName)")
                    return
                })
            }
        case is BeatData:
            let rel = release as! BeatData
            let imageURL = URL(string: rel.imageURL)!
            if let cachedImage = imageCache.object(forKey: imageURL.absoluteString as NSString) {
                completion(cachedImage, "Shop By Release", "Featured Release: \(rel.name)")
                return
            } else {
                imageURL.getImage(completion: { image in
                    completion(image, "Shop By Release", "Featured Release: \(rel.name)")
                    return
                })
            }
        default:
            print("")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "merchToMerchAll" {
            if let viewController: MerchAllContentViewController = segue.destination as? MerchAllContentViewController {
                viewController.recievedData = dataToGo
            }
        }
        if segue.identifier == "merchToShopBy" {
            if let viewController: MerchSelectShopByViewController = segue.destination as? MerchSelectShopByViewController {
                viewController.recievedShopType = dataToGo
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

extension MerchandiseViewController: UIScrollViewDelegate {
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        guard let collectionView = collectionView else {return}
//        guard let visibleCells = collectionView.visibleCells as? [MerchSlantedCollectionCell] else {return}
//        for parallaxCell in visibleCells {
//            let yOffset = (collectionView.contentOffset.y - parallaxCell.frame.origin.y) / parallaxCell.imageHeight
//            let xOffset = (collectionView.contentOffset.x - parallaxCell.frame.origin.x) / parallaxCell.imageWidth
//            parallaxCell.offset(CGPoint(x: xOffset * xOffsetSpeed, y: yOffset * yOffsetSpeed))
//        }
//    }
}

extension MerchandiseViewController: CollectionViewDelegateSlantedLayout, UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return merchArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "merchSlantedCollectionCell", for: indexPath)
                as! MerchSlantedCollectionCell
        if !(merchArray[indexPath.row] is String) {
            
            switch indexPath.row {
            case 0:
                let mdata = merchArray[indexPath.row] as! MerchData
                setUp(latestMerch: mdata, completion: {[weak self] image, title, feature in
                    guard let strongSelf = self else {return}
                    DispatchQueue.main.async {
                        cell.imageView.contentMode = .scaleAspectFill
                        cell.image = resizeImage(image: image, newWidth: strongSelf.view.frame.width)
                        cell.merchTitle.text = title
                        cell.featuredMerch.text = feature
                        cell.backgroundView?.layoutSubviews()
                        if let layout = collectionView.collectionViewLayout as? CollectionViewSlantedLayout {
                            cell.contentView.transform = CGAffineTransform(rotationAngle: layout.slantingAngle)
                        }
                    }
                })
            case 1:
                let mdata = merchArray[indexPath.row] as! MerchKitData
                setUp(soundKits: mdata, completion: {[weak self] image, title, feature in
                    guard let strongSelf = self else {return}
                    DispatchQueue.main.async {
                        cell.imageView.contentMode = .scaleAspectFill
                        cell.image = resizeImage(image: image, newWidth: strongSelf.view.frame.width)
                        cell.merchTitle.text = title
                        cell.featuredMerch.text = feature
                        cell.backgroundView?.layoutSubviews()
                        if let layout = collectionView.collectionViewLayout as? CollectionViewSlantedLayout {
                            cell.contentView.transform = CGAffineTransform(rotationAngle: layout.slantingAngle)
                        }
                    }
                })
            case 2:
                let mdata = merchArray[indexPath.row] as! MerchInstrumentalData
                setUp(instrumental: mdata, completion: {[weak self] image, title, feature in
                    guard let strongSelf = self else {return}
                    DispatchQueue.main.async {
                        cell.imageView.contentMode = .scaleAspectFill
                        cell.image = resizeImage(image: image, newWidth: strongSelf.view.frame.width)
                        cell.merchTitle.text = title
                        cell.featuredMerch.text = feature
                        cell.backgroundView?.layoutSubviews()
                        if let layout = collectionView.collectionViewLayout as? CollectionViewSlantedLayout {
                            cell.contentView.transform = CGAffineTransform(rotationAngle: layout.slantingAngle)
                        }
                    }
                })
            case 3:
                let mdata = merchArray[indexPath.row] as! MerchApperalData
                setUp(apperal: mdata, completion: {[weak self] image, title, feature in
                    guard let strongSelf = self else {return}
                    DispatchQueue.main.async {
                        cell.imageView.contentMode = .scaleAspectFill
                        cell.image = resizeImage(image: image, newWidth: strongSelf.view.frame.width)
                        cell.merchTitle.text = title
                        cell.featuredMerch.text = feature
                        cell.backgroundView?.layoutSubviews()
                        if let layout = collectionView.collectionViewLayout as? CollectionViewSlantedLayout {
                            cell.contentView.transform = CGAffineTransform(rotationAngle: layout.slantingAngle)
                        }
                    }
                })
            case 4:
                cell.imageView.contentMode = .scaleAspectFill
                cell.image = resizeImage(image: UIImage(named: "toneservices-1")!, newWidth: view.frame.width)
                cell.merchTitle.text = "Services"
                cell.featuredMerch.text = toneServices.joined(separator: ", ")
                cell.backgroundView?.layoutSubviews()
                if let layout = collectionView.collectionViewLayout as? CollectionViewSlantedLayout {
                    cell.contentView.transform = CGAffineTransform(rotationAngle: layout.slantingAngle)
                }
            case 5:
                let mdata = merchArray[indexPath.row] as! MerchMemorabiliaData
                setUp(memorabilia: mdata, completion: {[weak self] image, title, feature in
                    guard let strongSelf = self else {return}
                    DispatchQueue.main.async {
                        cell.imageView.contentMode = .scaleAspectFill
                        cell.image = resizeImage(image: image, newWidth: strongSelf.view.frame.width)
                        cell.merchTitle.text = title
                        cell.featuredMerch.text = feature
                        cell.backgroundView?.layoutSubviews()
                        if let layout = collectionView.collectionViewLayout as? CollectionViewSlantedLayout {
                            cell.contentView.transform = CGAffineTransform(rotationAngle: layout.slantingAngle)
                        }
                    }
                })
            case 6:
                let mdata = merchArray[indexPath.row] as! MerchData
                setUp(sale: mdata, completion: {[weak self] image, title, feature in
                    guard let strongSelf = self else {return}
                    DispatchQueue.main.async {
                        cell.imageView.contentMode = .scaleAspectFill
                        cell.image = resizeImage(image: image, newWidth: strongSelf.view.frame.width)
                        cell.merchTitle.text = title
                        cell.featuredMerch.text = feature
                        cell.backgroundView?.layoutSubviews()
                        if let layout = collectionView.collectionViewLayout as? CollectionViewSlantedLayout {
                            cell.contentView.transform = CGAffineTransform(rotationAngle: layout.slantingAngle)
                        }
                    }
                })
            case 7:
                let mdata = merchArray[indexPath.row] as! ArtistData
                setUp(artist: mdata, completion: {[weak self] image, title, feature in
                    guard let strongSelf = self else {return}
                    DispatchQueue.main.async {
                        cell.imageView.contentMode = .scaleAspectFill
                        cell.image = resizeImage(image: image, newWidth: strongSelf.view.frame.width)
                        cell.merchTitle.text = title
                        cell.featuredMerch.text = feature
                        cell.backgroundView?.layoutSubviews()
                        if let layout = collectionView.collectionViewLayout as? CollectionViewSlantedLayout {
                            cell.contentView.transform = CGAffineTransform(rotationAngle: layout.slantingAngle)
                        }
                    }
                })
            case 8:
                let mdata = merchArray[indexPath.row] as! ProducerData
                setUp(producer: mdata, completion: {[weak self] image, title, feature in
                    guard let strongSelf = self else {return}
                    DispatchQueue.main.async {
                        cell.imageView.contentMode = .scaleAspectFill
                        cell.image = resizeImage(image: image, newWidth: strongSelf.view.frame.width)
                        cell.merchTitle.text = title
                        cell.featuredMerch.text = feature
                        cell.backgroundView?.layoutSubviews()
                        if let layout = collectionView.collectionViewLayout as? CollectionViewSlantedLayout {
                            cell.contentView.transform = CGAffineTransform(rotationAngle: layout.slantingAngle)
                        }
                    }
                })
            case 9:
                let mdata = merchArray[indexPath.row]
                setUp(release: mdata, completion: {[weak self] image, title, feature in
                    guard let strongSelf = self else {return}
                    DispatchQueue.main.async {
                        cell.imageView.contentMode = .scaleAspectFill
                        cell.image = resizeImage(image: image, newWidth: strongSelf.view.frame.width)
                        cell.merchTitle.text = title
                        cell.featuredMerch.text = feature
                        cell.backgroundView?.layoutSubviews()
                        if let layout = collectionView.collectionViewLayout as? CollectionViewSlantedLayout {
                            cell.contentView.transform = CGAffineTransform(rotationAngle: layout.slantingAngle)
                        }
                    }
                })
            default:
                print("Other Index")
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            dataToGo = "latest"
            performSegue(withIdentifier: "merchToMerchAll", sender: nil)
        case 1:
            dataToGo = "sounds"
            performSegue(withIdentifier: "merchToShopBy", sender: nil)
        case 2:
            dataToGo = "instrumentals"
            performSegue(withIdentifier: "merchToMerchAll", sender: nil)
        case 3:
            dataToGo = "apperal"
            performSegue(withIdentifier: "merchToMerchAll", sender: nil)
        case 4:
            dataToGo = "services"
            performSegue(withIdentifier: "merchToMerchAll", sender: nil)
        case 5:
            dataToGo = "memorabilia"
            performSegue(withIdentifier: "merchToMerchAll", sender: nil)
        case 6:
            dataToGo = "sale"
            performSegue(withIdentifier: "merchToMerchAll", sender: nil)
        case 7:
            dataToGo = "artists"
            performSegue(withIdentifier: "merchToShopBy", sender: nil)
        case 8:
            dataToGo = "producers"
            performSegue(withIdentifier: "merchToShopBy", sender: nil)
        case 9:
            dataToGo = "release"
            performSegue(withIdentifier: "merchToShopBy", sender: nil)
        default:
            print("Other Index")
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                            layout collectionViewLayout: CollectionViewSlantedLayout,
                            sizeForItemAt indexPath: IndexPath) -> CGFloat {
            return collectionViewLayout.scrollDirection == .vertical ? 275 : 325
        }
}

let yOffsetSpeed: CGFloat = 150.0
let xOffsetSpeed: CGFloat = 100.0

import MarqueeLabel

class MerchSlantedCollectionCell: CollectionViewSlantedCell {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var merchTitle: MarqueeLabel!
    @IBOutlet weak var featuredMerch: MarqueeLabel!
    @IBOutlet weak var gView: UIView!
    private var gradient = CAGradientLayer()
    
    override var isHighlighted: Bool {
        didSet{
            tapScale(cell: self, down: isHighlighted)
        }
    }
    
    override func prepareForReuse() {
        imageView.contentMode = .scaleAspectFill
        imageView.image = nil
        merchTitle.text = ""
        featuredMerch.text = ""
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        imageView.contentMode = .scaleAspectFill
        if let backgroundView = backgroundView {
            gradient.colors = [UIColor.clear.cgColor, UIColor.black.cgColor]
            gradient.locations = [0.0, 1.0]
            gradient.frame = backgroundView.bounds
            backgroundView.layer.addSublayer(gradient)
            backgroundView.sendSubviewToBack(imageView)
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.contentMode = .scaleAspectFill
        if let backgroundView = backgroundView {
            gradient.frame = backgroundView.bounds
        }
    }

    var image: UIImage = UIImage() {
        didSet {
            imageView.contentMode = .scaleAspectFill
            imageView.image = image
        }
    }

    var imageHeight: CGFloat {
        return (imageView?.image?.size.height) ?? 0.0
    }

    var imageWidth: CGFloat {
        return (imageView?.image?.size.width) ?? 0.0
    }

    func offset(_ offset: CGPoint) {
        imageView.frame = imageView.bounds.offsetBy(dx: offset.x, dy: offset.y)
    }
}
