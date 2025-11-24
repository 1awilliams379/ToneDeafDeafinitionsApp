//
//  MerchAllContentViewController.swift
//  ToneDeafDeafinitionsApp
//
//  Created by Tone Deaf on 11/9/20.
//  Copyright © 2020 GITEM Solutions. All rights reserved.
//

import UIKit
import NVActivityIndicatorView
import SideMenu

class MerchAllContentViewController: UIViewController {

    @IBOutlet weak var headerView:UIView!
    @IBOutlet weak var headerImage:UIImageView!
    @IBOutlet weak var headerMerchLabel:UILabel!
    @IBOutlet weak var headerMerchPrice:UILabel!
    @IBOutlet weak var headerMerchSale:UILabel!
    @IBOutlet weak var headerheight:NSLayoutConstraint!
    let maxHeaderHeight: CGFloat = 250.0
    var lastContentOffset: CGFloat = 250.0
    private var gradient = CAGradientLayer()
    
    @IBOutlet weak var merchContentSearchBar:UISearchBar!
    @IBOutlet weak var merchContentCollectionView:UICollectionView!
    @IBOutlet weak var spinner:NVActivityIndicatorView!
    
    var recievedData:Any!
    
    var merchToGo:Any!
    
    var latestContentArray:[MerchData] = []
    var kitArray:[MerchKitData] = []
    var instrumentalsArray:[MerchInstrumentalData] = []
    var apperalArray:[MerchApperalData] = []
    var servicesArray:[MerchServiceData] = []
    var memorabiliaArray:[MerchMemorabiliaData] = []
    var otherArray:[MerchData] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        spinner.type = .circleStrokeSpin
        spinner.startAnimating()
        merchContentCollectionView.delaysContentTouches = false
        merchContentCollectionView.isHidden = true
        setHeader()
        setUpSearchBar()
    }
    
    func setHeader() {
        gradient.colors = [UIColor.clear.cgColor, UIColor.black.cgColor]
        gradient.locations = [0.0, 1.0]
        gradient.frame = headerView.bounds
        headerView.layer.addSublayer(gradient)
        headerView.sendSubviewToBack(headerImage)
        headerImage.contentMode = .scaleAspectFill
        headerImage.backgroundColor = .black
        headerMerchSale.isHidden = true
        merchContentSearchBar.placeholder = "Search"
        switch recievedData {
        case is String:
            let string = recievedData as! String
            switch string {
            case "latest":
                self.navigationItem.title = "Latest Merch"
                DatabaseManager.shared.fetchLatestMerch(amount: 25, completion: {[weak self] merch in
                    guard let strongSelf = self else {return}
                    strongSelf.latestContentArray = merch
                    strongSelf.merchContentCollectionView.isHidden = false
                    strongSelf.merchContentCollectionView.delegate = self
                    strongSelf.merchContentCollectionView.dataSource = self
                    strongSelf.merchContentCollectionView.reloadData()
                    strongSelf.spinner.stopAnimating()
                    strongSelf.view.layoutSubviews()
                    strongSelf.latestContentArray.shuffle()
                    if let merch = strongSelf.latestContentArray[0].kit {
                        strongSelf.headerMerchLabel.text = "Featured Item • \(merch.name)"
                        strongSelf.headerMerchPrice.text = merch.retailPrice.dollarString
                        if let sp = merch.salePrice {
                            strongSelf.headerMerchSale.isHidden = false
                            strongSelf.headerMerchSale.text = (merch.retailPrice-(merch.retailPrice*sp)).dollarString
                            strongSelf.headerMerchPrice.alpha = 0.7
                            let attributedString = NSMutableAttributedString(string: merch.retailPrice.dollarString)
                            attributedString.addAttribute(NSAttributedString.Key.baselineOffset, value: 0, range: NSMakeRange(0, attributedString.length))
                            attributedString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: NSNumber(value: NSUnderlineStyle.thick.rawValue), range: NSMakeRange(0, attributedString.length))
                            attributedString.addAttribute(NSAttributedString.Key.strikethroughColor, value: UIColor.gray, range: NSMakeRange(0, attributedString.length))
                            strongSelf.headerMerchPrice.attributedText = attributedString
                        }
                        let imageURL = URL(string: merch.imageURLs[0])!
                        if let cachedImage = imageCache.object(forKey: imageURL.absoluteString as NSString) {
                            strongSelf.headerImage.image = cachedImage
                            return
                        } else {
                            strongSelf.headerImage.setImage(from: imageURL, withPlaceholder: UIImage(named: "tonedeaflogo"))
                        }
                    }
                    else if let merch = strongSelf.latestContentArray[0].apperal {
                        strongSelf.headerMerchLabel.text = "Featured Item • \(merch.name)"
                        let lp = GlobalFunctions.shared.getLowestPrice(apperal: merch)
                        strongSelf.headerMerchPrice.text = "From \(lp.dollarString)"
                        let imageURL = URL(string: merch.imageURLs[0])!
                        if let cachedImage = imageCache.object(forKey: imageURL.absoluteString as NSString) {
                            strongSelf.headerImage.image = cachedImage
                            return
                        } else {
                            strongSelf.headerImage.setImage(from: imageURL, withPlaceholder: UIImage(named: "tonedeaflogo"))
                        }
                    }
                    else if let merch = strongSelf.latestContentArray[0].service {
                        strongSelf.headerMerchLabel.text = "Featured Item • \(merch.name)"
                        if let pric = merch.retailPrice {
                            strongSelf.headerMerchPrice.text = pric.dollarString
                        }
                        let image = UIImage(named: "lego")!
                        strongSelf.headerImage.image = image
                        strongSelf.headerImage.backgroundColor = .white
                    }
                    else if let merch = strongSelf.latestContentArray[0].memorabilia {
                        strongSelf.headerMerchLabel.text = "Featured Item • \(merch.name)"
                        let lp = GlobalFunctions.shared.getLowestPrice(memorabilia: merch)
                        strongSelf.headerMerchPrice.text = "From \(lp.dollarString)"
                        let imageURL = URL(string: merch.imageURLs[0])!
                        if let cachedImage = imageCache.object(forKey: imageURL.absoluteString as NSString) {
                            strongSelf.headerImage.image = cachedImage
                            return
                        } else {
                            strongSelf.headerImage.setImage(from: imageURL, withPlaceholder: UIImage(named: "tonedeaflogo"))
                        }
                    }
                    else if let merch = strongSelf.latestContentArray[0].instrumentalSale {
                        let word = merch.instrumentaldbid.split(separator: "Æ")
                        let id = String(word[0])
                        DatabaseManager.shared.findInstrumentalById(instrumentalId: id, completion: {[weak self] result in
                            guard let strongSelf = self else {return}
                            switch result {
                            case.success(let instrumental):
                                strongSelf.headerMerchLabel.text = "Featured Item • \(instrumental.instrumentalName)"
                                if let pric = merch.retailPrice {
                                    strongSelf.headerMerchPrice.text = pric.dollarString
                                }
                                let imageURL = URL(string: "instrumental.imageURL")!
                                if let cachedImage = imageCache.object(forKey: imageURL.absoluteString as NSString) {
                                    strongSelf.headerImage.image = cachedImage
                                    return
                                } else {
                                    strongSelf.headerImage.setImage(from: imageURL, withPlaceholder: UIImage(named: "tonedeaflogo"))
                                }
                            case.failure(let err):
                                print("kjhfdgxfgchjk bi \(err)")
                            }
                        })
                    }
                })
            case "kits":
                self.navigationItem.title = "Sounds"
                headerMerchSale.isHidden = true
                DatabaseManager.shared.fetchAllMerchKits(completion: {[weak self] merch in
                    guard let strongSelf = self else {return}
                    strongSelf.kitArray = merch
                    strongSelf.merchContentCollectionView.isHidden = false
                    strongSelf.merchContentCollectionView.delegate = self
                    strongSelf.merchContentCollectionView.dataSource = self
                    strongSelf.merchContentCollectionView.reloadData()
                    strongSelf.spinner.stopAnimating()
                    strongSelf.view.layoutSubviews()
                    strongSelf.latestContentArray.shuffle()
                    strongSelf.headerMerchLabel.text = "Featured Kit • \(strongSelf.kitArray[0].name)"
                    strongSelf.headerMerchPrice.text = strongSelf.kitArray[0].retailPrice.dollarString
                    let imageURL = URL(string: strongSelf.kitArray[0].imageURLs[0])!
                    if let cachedImage = imageCache.object(forKey: imageURL.absoluteString as NSString) {
                        strongSelf.headerImage.image = cachedImage
                        return
                    } else {
                        strongSelf.headerImage.setImage(from: imageURL, withPlaceholder: UIImage(named: "tonedeaflogo"))
                    }
                })
            case "instrumentals":
                self.navigationItem.title = "Instrumentals"
                headerMerchSale.isHidden = true
                DatabaseManager.shared.fetchAllMerchInstrumentals(completion: {[weak self] merch in
                    guard let strongSelf = self else {return}
                    strongSelf.instrumentalsArray = merch
                    strongSelf.merchContentCollectionView.isHidden = false
                    strongSelf.merchContentCollectionView.delegate = self
                    strongSelf.merchContentCollectionView.dataSource = self
                    strongSelf.merchContentCollectionView.reloadData()
                    strongSelf.spinner.stopAnimating()
                    strongSelf.view.layoutSubviews()
                    strongSelf.instrumentalsArray.shuffle()
                    if let price = strongSelf.instrumentalsArray[0].retailPrice {
                        strongSelf.headerMerchPrice.text = price.dollarString
                    } else {
                        strongSelf.headerMerchPrice.text = "FREE"
                    }
                    let word = strongSelf.instrumentalsArray[0].instrumentaldbid.split(separator: "Æ")
                    let id = String(word[0])
                    DatabaseManager.shared.findInstrumentalById(instrumentalId: id, completion: {[weak self] result in
                        guard let strongSelf = self else {return}
                        switch result {
                        case.success(let instrumental):
                            strongSelf.headerMerchLabel.text = "Featured Instrumental • \(instrumental.instrumentalName)"
                            let imageURL = URL(string: "instrumental.imageURL")!
                            if let cachedImage = imageCache.object(forKey: imageURL.absoluteString as NSString) {
                                strongSelf.headerImage.image = cachedImage
                                return
                            } else {
                                strongSelf.headerImage.setImage(from: imageURL, withPlaceholder: UIImage(named: "tonedeaflogo"))
                            }
                        case.failure(let err):
                            print("kjhfdgxfgchjk bi \(err)")
                        }
                    })
                })
            case "apperal":
                self.navigationItem.title = "Apperal"
                headerMerchSale.isHidden = true
                DatabaseManager.shared.fetchAllMerchApperal(completion: {[weak self] merch in
                    guard let strongSelf = self else {return}
                    strongSelf.apperalArray = merch
                    strongSelf.merchContentCollectionView.isHidden = false
                    strongSelf.merchContentCollectionView.delegate = self
                    strongSelf.merchContentCollectionView.dataSource = self
                    strongSelf.merchContentCollectionView.reloadData()
                    strongSelf.spinner.stopAnimating()
                    strongSelf.view.layoutSubviews()
                    strongSelf.apperalArray.shuffle()
                    strongSelf.headerMerchLabel.text = "Featured Apperal • \(strongSelf.apperalArray[0].name)"
                    strongSelf.headerMerchPrice.text = "From "+GlobalFunctions.shared.getLowestPrice(apperal: strongSelf.apperalArray[0]).dollarString
                    let imageURL = URL(string: strongSelf.apperalArray[0].imageURLs[0])!
                    if let cachedImage = imageCache.object(forKey: imageURL.absoluteString as NSString) {
                        strongSelf.headerImage.image = cachedImage
                        return
                    } else {
                        strongSelf.headerImage.setImage(from: imageURL, withPlaceholder: UIImage(named: "tonedeaflogo"))
                    }
                })
            case "services":
                self.navigationItem.title = "Services"
                headerMerchSale.isHidden = true
                DatabaseManager.shared.fetchAllMerchServices(completion: {[weak self] merch in
                    guard let strongSelf = self else {return}
                    strongSelf.servicesArray = merch
                    strongSelf.merchContentCollectionView.isHidden = false
                    strongSelf.merchContentCollectionView.delegate = self
                    strongSelf.merchContentCollectionView.dataSource = self
                    strongSelf.merchContentCollectionView.reloadData()
                    strongSelf.spinner.stopAnimating()
                    strongSelf.view.layoutSubviews()
                    strongSelf.servicesArray.shuffle()
                    strongSelf.headerMerchLabel.text = "Featured Service • \(strongSelf.servicesArray[0].name)"
                    if let price = strongSelf.servicesArray[0].retailPrice {
                        strongSelf.headerMerchPrice.text = price.dollarString
                    } else {
                        strongSelf.headerMerchPrice.text = "FREE"
                    }
                    let image = UIImage(named: "lego")!
                    strongSelf.headerImage.image = image
                    strongSelf.headerImage.backgroundColor = .white
                })
            case "memorabilia":
                self.navigationItem.title = "Memorabilia"
                headerMerchSale.isHidden = true
                DatabaseManager.shared.fetchAllMerchMemorabilia(completion: {[weak self] merch in
                    guard let strongSelf = self else {return}
                    strongSelf.memorabiliaArray = merch
                    strongSelf.merchContentCollectionView.isHidden = false
                    strongSelf.merchContentCollectionView.delegate = self
                    strongSelf.merchContentCollectionView.dataSource = self
                    strongSelf.merchContentCollectionView.reloadData()
                    strongSelf.spinner.stopAnimating()
                    strongSelf.view.layoutSubviews()
                    strongSelf.memorabiliaArray.shuffle()
                    strongSelf.headerMerchLabel.text = "Featured Memorabilia • \(strongSelf.memorabiliaArray[0].name)"
                    strongSelf.headerMerchPrice.text = "From "+GlobalFunctions.shared.getLowestPrice(memorabilia: strongSelf.memorabiliaArray[0]).dollarString
                    let imageURL = URL(string: strongSelf.memorabiliaArray[0].imageURLs[0])!
                    if let cachedImage = imageCache.object(forKey: imageURL.absoluteString as NSString) {
                        strongSelf.headerImage.image = cachedImage
                        return
                    } else {
                        strongSelf.headerImage.setImage(from: imageURL, withPlaceholder: UIImage(named: "tonedeaflogo"))
                    }
                })
            case "sale":
                self.navigationItem.title = "Sale"
                headerMerchSale.isHidden = true
                DatabaseManager.shared.fetchAllMerchOnSale(completion: {[weak self] merch in
                    guard let strongSelf = self else {return}
                    strongSelf.otherArray = merch
                    strongSelf.merchContentCollectionView.isHidden = false
                    strongSelf.merchContentCollectionView.delegate = self
                    strongSelf.merchContentCollectionView.dataSource = self
                    strongSelf.merchContentCollectionView.reloadData()
                    strongSelf.spinner.stopAnimating()
                    strongSelf.view.layoutSubviews()
                    strongSelf.otherArray.shuffle()
                    if let merch = strongSelf.otherArray[0].kit {
                        strongSelf.headerMerchLabel.text = "Featured Item • \(merch.name)"
                        strongSelf.headerMerchPrice.text = merch.retailPrice.dollarString
                        if let sp = merch.salePrice {
                            strongSelf.headerMerchSale.isHidden = false
                            strongSelf.headerMerchSale.text = (merch.retailPrice-(merch.retailPrice*sp)).dollarString
                            strongSelf.headerMerchPrice.alpha = 0.7
                            let attributedString = NSMutableAttributedString(string: merch.retailPrice.dollarString)
                            attributedString.addAttribute(NSAttributedString.Key.baselineOffset, value: 0, range: NSMakeRange(0, attributedString.length))
                            attributedString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: NSNumber(value: NSUnderlineStyle.thick.rawValue), range: NSMakeRange(0, attributedString.length))
                            attributedString.addAttribute(NSAttributedString.Key.strikethroughColor, value: UIColor.gray, range: NSMakeRange(0, attributedString.length))
                            strongSelf.headerMerchPrice.attributedText = attributedString
                        }
                        let imageURL = URL(string: merch.imageURLs[0])!
                        if let cachedImage = imageCache.object(forKey: imageURL.absoluteString as NSString) {
                            strongSelf.headerImage.image = cachedImage
                            return
                        } else {
                            strongSelf.headerImage.setImage(from: imageURL, withPlaceholder: UIImage(named: "tonedeaflogo"))
                        }
                    }
                    else if let merch = strongSelf.otherArray[0].apperal {
                        strongSelf.headerMerchLabel.text = "Featured Item • \(merch.name)"
                        let lp = GlobalFunctions.shared.getLowestPrice(apperal: merch)
                        strongSelf.headerMerchPrice.text = "From \(lp.dollarString)"
                        let imageURL = URL(string: merch.imageURLs[0])!
                        if let cachedImage = imageCache.object(forKey: imageURL.absoluteString as NSString) {
                            strongSelf.headerImage.image = cachedImage
                            return
                        } else {
                            strongSelf.headerImage.setImage(from: imageURL, withPlaceholder: UIImage(named: "tonedeaflogo"))
                        }
                    }
                    else if let merch = strongSelf.otherArray[0].service {
                        strongSelf.headerMerchLabel.text = "Featured Item • \(merch.name)"
                        if let pric = merch.retailPrice {
                            strongSelf.headerMerchPrice.text = pric.dollarString
                        }
                        let image = UIImage(named: "lego")!
                        strongSelf.headerImage.image = image
                        strongSelf.headerImage.backgroundColor = .white
                    }
                    else if let merch = strongSelf.otherArray[0].memorabilia {
                        strongSelf.headerMerchLabel.text = "Featured Item • \(merch.name)"
                        let lp = GlobalFunctions.shared.getLowestPrice(memorabilia: merch)
                        strongSelf.headerMerchPrice.text = "From \(lp.dollarString)"
                        let imageURL = URL(string: merch.imageURLs[0])!
                        if let cachedImage = imageCache.object(forKey: imageURL.absoluteString as NSString) {
                            strongSelf.headerImage.image = cachedImage
                            return
                        } else {
                            strongSelf.headerImage.setImage(from: imageURL, withPlaceholder: UIImage(named: "tonedeaflogo"))
                        }
                    }
                    else if let merch = strongSelf.otherArray[0].instrumentalSale {
                        let word = merch.instrumentaldbid.split(separator: "Æ")
                        let id = String(word[0])
                        DatabaseManager.shared.findInstrumentalById(instrumentalId: id, completion: {[weak self] result in
                            guard let strongSelf = self else {return}
                            switch result {
                            case.success(let instrumental):
                                strongSelf.headerMerchLabel.text = "Featured Item • \(instrumental.instrumentalName)"
                                if let pric = merch.retailPrice {
                                    strongSelf.headerMerchPrice.text = pric.dollarString
                                }
                                let imageURL = URL(string: "instrumental.imageURL")!
                                if let cachedImage = imageCache.object(forKey: imageURL.absoluteString as NSString) {
                                    strongSelf.headerImage.image = cachedImage
                                    return
                                } else {
                                    strongSelf.headerImage.setImage(from: imageURL, withPlaceholder: UIImage(named: "tonedeaflogo"))
                                }
                            case.failure(let err):
                                print("kjhfdgxfgchjk bi \(err)")
                            }
                        })
                    }
                })
            default:
                print("Other Index")
            }
        case is ArtistData:
            let item = recievedData as! ArtistData
            merchContentSearchBar.placeholder = "Search "+item.name+" Merch"
            var arr:[MerchData] = []
            var tick = 0
            for dbid in item.merch! {
                let word = dbid.split(separator: "Æ")
                let id = String(word[0])
                DatabaseManager.shared.findMerchById(merchId: id, completion: {[weak self] result in
                    guard let strongSelf = self else {return}
                    switch result {
                    case .success(let merch):
                        arr.append(merch)
                        tick+=1
                        if tick == item.merch!.count {
                            strongSelf.otherArray = arr
                            strongSelf.merchContentCollectionView.isHidden = false
                            strongSelf.merchContentCollectionView.delegate = self
                            strongSelf.merchContentCollectionView.dataSource = self
                            strongSelf.merchContentCollectionView.reloadData()
                            strongSelf.spinner.stopAnimating()
                            strongSelf.view.layoutSubviews()
                            strongSelf.otherArray.shuffle()
                            strongSelf.merchHeaderHandler(otherArr: strongSelf.otherArray)
                        }
                    case .failure(let err):
                        print("merrrrr e \(err)")
                    }
                })
            }
        case is ProducerData:
            let item = recievedData as! ProducerData
            merchContentSearchBar.placeholder = "Search "+item.name+" Merch"
            var arr:[MerchData] = []
            var tick = 0
            for dbid in item.merch! {
                let word = dbid.split(separator: "Æ")
                let id = String(word[0])
                DatabaseManager.shared.findMerchById(merchId: id, completion: {[weak self] result in
                    guard let strongSelf = self else {return}
                    switch result {
                    case .success(let merch):
                        arr.append(merch)
                        tick+=1
                        if tick == item.merch!.count {
                            strongSelf.otherArray = arr
                            strongSelf.merchContentCollectionView.isHidden = false
                            strongSelf.merchContentCollectionView.delegate = self
                            strongSelf.merchContentCollectionView.dataSource = self
                            strongSelf.merchContentCollectionView.reloadData()
                            strongSelf.spinner.stopAnimating()
                            strongSelf.view.layoutSubviews()
                            strongSelf.otherArray.shuffle()
                            strongSelf.merchHeaderHandler(otherArr: strongSelf.otherArray)
                        }
                    case .failure(let err):
                        print("merrrrr e \(err)")
                    }
                })
            }
        case is SongData:
            let item = recievedData as! SongData
            merchContentSearchBar.placeholder = "Search "+item.name+" Merch"
            var arr:[MerchData] = []
            var tick = 0
            for dbid in item.merch! {
                let word = dbid.split(separator: "Æ")
                let id = String(word[0])
                DatabaseManager.shared.findMerchById(merchId: id, completion: {[weak self] result in
                    guard let strongSelf = self else {return}
                    switch result {
                    case .success(let merch):
                        arr.append(merch)
                        tick+=1
                        if tick == item.merch!.count {
                            strongSelf.otherArray = arr
                            strongSelf.merchContentCollectionView.isHidden = false
                            strongSelf.merchContentCollectionView.delegate = self
                            strongSelf.merchContentCollectionView.dataSource = self
                            strongSelf.merchContentCollectionView.reloadData()
                            strongSelf.spinner.stopAnimating()
                            strongSelf.view.layoutSubviews()
                            strongSelf.otherArray.shuffle()
                            strongSelf.merchHeaderHandler(otherArr: strongSelf.otherArray)
                        }
                    case .failure(let err):
                        print("merrrrr e \(err)")
                    }
                })
            }
        case is YouTubeData:
            let item = recievedData as! YouTubeData
            merchContentSearchBar.placeholder = "Search "+item.title+" Merch"
            var arr:[MerchData] = []
            var tick = 0
//            for dbid in item.merch! {
//                let word = dbid.split(separator: "Æ")
//                let id = String(word[0])
//                DatabaseManager.shared.findMerchById(merchId: id, completion: {[weak self] result in
//                    guard let strongSelf = self else {return}
//                    switch result {
//                    case .success(let merch):
//                        arr.append(merch)
//                        tick+=1
//                        if tick == item.merch!.count {
//                            strongSelf.otherArray = arr
//                            strongSelf.merchContentCollectionView.isHidden = false
//                            strongSelf.merchContentCollectionView.delegate = self
//                            strongSelf.merchContentCollectionView.dataSource = self
//                            strongSelf.merchContentCollectionView.reloadData()
//                            strongSelf.spinner.stopAnimating()
//                            strongSelf.view.layoutSubviews()
//                            strongSelf.otherArray.shuffle()
//                            strongSelf.merchHeaderHandler(otherArr: strongSelf.otherArray)
//                        }
//                    case .failure(let err):
//                        print("merrrrr e \(err)")
//                    }
//                })
//            }
        case is AlbumData:
            let item = recievedData as! AlbumData
            merchContentSearchBar.placeholder = "Search "+item.name+" Merch"
            var arr:[MerchData] = []
            var tick = 0
            for dbid in item.merch! {
                let word = dbid.split(separator: "Æ")
                let id = String(word[0])
                DatabaseManager.shared.findMerchById(merchId: id, completion: {[weak self] result in
                    guard let strongSelf = self else {return}
                    switch result {
                    case .success(let merch):
                        arr.append(merch)
                        tick+=1
                        if tick == item.merch!.count {
                            strongSelf.otherArray = arr
                            strongSelf.merchContentCollectionView.isHidden = false
                            strongSelf.merchContentCollectionView.delegate = self
                            strongSelf.merchContentCollectionView.dataSource = self
                            strongSelf.merchContentCollectionView.reloadData()
                            strongSelf.spinner.stopAnimating()
                            strongSelf.view.layoutSubviews()
                            strongSelf.otherArray.shuffle()
                            strongSelf.merchHeaderHandler(otherArr: strongSelf.otherArray)
                        }
                    case .failure(let err):
                        print("merrrrr e \(err)")
                    }
                })
            }
        case is InstrumentalData:
            let item = recievedData as! InstrumentalData
            merchContentSearchBar.placeholder = "Search "+item.instrumentalName!+" Merch"
            var arr:[MerchData] = []
            var tick = 0
            var instrMerchArr:[String] = ["\(item.toneDeafAppId)Æ\(item.instrumentalName)"]
            if let more = item.merch {
                instrMerchArr.append(contentsOf: more)
            }
            for dbid in instrMerchArr {
                let word = dbid.split(separator: "Æ")
                let id = String(word[0])
                DatabaseManager.shared.findMerchById(merchId: id, completion: {[weak self] result in
                    guard let strongSelf = self else {return}
                    switch result {
                    case .success(let merch):
                        arr.append(merch)
                        tick+=1
                        if tick == instrMerchArr.count {
                            strongSelf.otherArray = arr
                            strongSelf.merchContentCollectionView.isHidden = false
                            strongSelf.merchContentCollectionView.delegate = self
                            strongSelf.merchContentCollectionView.dataSource = self
                            strongSelf.merchContentCollectionView.reloadData()
                            strongSelf.spinner.stopAnimating()
                            strongSelf.view.layoutSubviews()
                            strongSelf.otherArray.shuffle()
                            strongSelf.merchHeaderHandler(otherArr: strongSelf.otherArray)
                        }
                    case .failure(let err):
                        print("merrrrr e \(err)")
                    }
                })
            }
        case is BeatData:
            let item = recievedData as! BeatData
            merchContentSearchBar.placeholder = "Search "+item.name+" Merch"
            var arr:[MerchData] = []
            var tick = 0
            for dbid in item.merch! {
                let word = dbid.split(separator: "Æ")
                let id = String(word[0])
                DatabaseManager.shared.findMerchById(merchId: id, completion: {[weak self] result in
                    guard let strongSelf = self else {return}
                    switch result {
                    case .success(let merch):
                        arr.append(merch)
                        tick+=1
                        if tick == item.merch!.count {
                            strongSelf.otherArray = arr
                            strongSelf.merchContentCollectionView.isHidden = false
                            strongSelf.merchContentCollectionView.delegate = self
                            strongSelf.merchContentCollectionView.dataSource = self
                            strongSelf.merchContentCollectionView.reloadData()
                            strongSelf.spinner.stopAnimating()
                            strongSelf.view.layoutSubviews()
                            strongSelf.otherArray.shuffle()
                            strongSelf.merchHeaderHandler(otherArr: strongSelf.otherArray)
                        }
                    case .failure(let err):
                        print("merrrrr e \(err)")
                    }
                })
            }
        default:
            print("Other Index")
        }
    }
    
    func merchHeaderHandler(otherArr:[MerchData]) {
        if let merch = otherArr[0].kit {
           headerMerchLabel.text = "Featured Item • \(merch.name)"
            headerMerchPrice.text = merch.retailPrice.dollarString
            if let sp = merch.salePrice {
                headerMerchSale.isHidden = false
                headerMerchSale.text = (merch.retailPrice-(merch.retailPrice*sp)).dollarString
                headerMerchPrice.alpha = 0.7
                let attributedString = NSMutableAttributedString(string: merch.retailPrice.dollarString)
                attributedString.addAttribute(NSAttributedString.Key.baselineOffset, value: 0, range: NSMakeRange(0, attributedString.length))
                attributedString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: NSNumber(value: NSUnderlineStyle.thick.rawValue), range: NSMakeRange(0, attributedString.length))
                attributedString.addAttribute(NSAttributedString.Key.strikethroughColor, value: UIColor.gray, range: NSMakeRange(0, attributedString.length))
                headerMerchPrice.attributedText = attributedString
            }
            let imageURL = URL(string: merch.imageURLs[0])!
            if let cachedImage = imageCache.object(forKey: imageURL.absoluteString as NSString) {
                headerImage.image = cachedImage
                return
            } else {
                headerImage.setImage(from: imageURL, withPlaceholder: UIImage(named: "tonedeaflogo"))
            }
        }
        else if let merch = otherArr[0].apperal {
            headerMerchLabel.text = "Featured Item • \(merch.name)"
            let lp = GlobalFunctions.shared.getLowestPrice(apperal: merch)
            headerMerchPrice.text = "From \(lp.dollarString)"
            let imageURL = URL(string: merch.imageURLs[0])!
            if let cachedImage = imageCache.object(forKey: imageURL.absoluteString as NSString) {
                headerImage.image = cachedImage
                return
            } else {
                headerImage.setImage(from: imageURL, withPlaceholder: UIImage(named: "tonedeaflogo"))
            }
        }
        else if let merch = otherArr[0].service {
            headerMerchLabel.text = "Featured Item • \(merch.name)"
            if let pric = merch.retailPrice {
                headerMerchPrice.text = pric.dollarString
            }
            let image = UIImage(named: "lego")!
            headerImage.image = image
            headerImage.backgroundColor = .white
        }
        else if let merch = otherArr[0].memorabilia {
            headerMerchLabel.text = "Featured Item • \(merch.name)"
            let lp = GlobalFunctions.shared.getLowestPrice(memorabilia: merch)
            headerMerchPrice.text = "From \(lp.dollarString)"
            let imageURL = URL(string: merch.imageURLs[0])!
            if let cachedImage = imageCache.object(forKey: imageURL.absoluteString as NSString) {
                headerImage.image = cachedImage
                return
            } else {
                headerImage.setImage(from: imageURL, withPlaceholder: UIImage(named: "tonedeaflogo"))
            }
        }
        else if let merch = otherArr[0].instrumentalSale {
            let word = merch.instrumentaldbid.split(separator: "Æ")
            let id = String(word[0])
            DatabaseManager.shared.findInstrumentalById(instrumentalId: id, completion: {[weak self] result in
                guard let strongSelf = self else {return}
                switch result {
                case.success(let instrumental):
                    strongSelf.headerMerchLabel.text = "Featured Item • \(instrumental.instrumentalName)"
                    if let pric = merch.retailPrice {
                        strongSelf.headerMerchPrice.text = pric.dollarString
                    }
                    let imageURL = URL(string: "instrumental.imageURL")!
                    if let cachedImage = imageCache.object(forKey: imageURL.absoluteString as NSString) {
                        strongSelf.headerImage.image = cachedImage
                        return
                    } else {
                        strongSelf.headerImage.setImage(from: imageURL, withPlaceholder: UIImage(named: "tonedeaflogo"))
                    }
                case.failure(let err):
                    print("kjhfdgxfgchjk bi \(err)")
                }
            })
        }
    }
    
    func setUpSearchBar() {
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "merchContentToProduct" {
            if let viewController: ProductInfoViewController = segue.destination as? ProductInfoViewController {
                viewController.recievedMerch = merchToGo
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

extension MerchAllContentViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == merchContentCollectionView {
            if (scrollView.contentOffset.y >= (scrollView.contentSize.height - scrollView.frame.size.height)) {
                //Scrolled to bottom
                if !(scrollView.contentOffset.y < self.lastContentOffset || scrollView.contentOffset.y <= 250) {
                    UIView.animate(withDuration: 0.3) { [weak self] in
                        guard let strongSelf = self else {return}
                        strongSelf.headerheight.constant = 0.0
                        //strongSelf.followButton.alpha = 0
                        strongSelf.view.layoutIfNeeded()
                    }
                }
            }
            else if (scrollView.contentOffset.y < self.lastContentOffset || scrollView.contentOffset.y <= 250) && (self.headerheight.constant != self.maxHeaderHeight)  {
                //Scrolling up, scrolled to top
                print(scrollView.contentOffset.y)
                UIView.animate(withDuration: 0.3) { [weak self] in
                    guard let strongSelf = self else {return}
                    if scrollView.contentOffset.y <= 0.0 {
                                       strongSelf.headerheight.constant = strongSelf.maxHeaderHeight
                                       strongSelf.view.layoutIfNeeded()
                    }
                }
            }
            else if (scrollView.contentOffset.y > lastContentOffset) && headerheight.constant != 0 {
                //Scrolling down
                if !(scrollView.contentOffset.y < lastContentOffset || scrollView.contentOffset.y <= 0) {
                    UIView.animate(withDuration: 0.3) { [weak self] in
                        guard let strongSelf = self else {return}
                        strongSelf.headerheight.constant = 0.0
                        strongSelf.view.layoutIfNeeded()
                    }
                }
            }
            self.lastContentOffset = scrollView.contentOffset.y
        }
    }
}

extension MerchAllContentViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
        
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        switch recievedData {
        case is String:
            let string = recievedData as! String
            switch string {
            case "latest":
                return latestContentArray.count
            case "kits":
                return kitArray.count
            case "instrumentals":
                return instrumentalsArray.count
            case "apperal":
                return apperalArray.count
            case "services":
                return servicesArray.count
            case "memorabilia":
                return memorabiliaArray.count
            case "sale":
                return otherArray.count
            default:
                return 0
            }
        case is ArtistData:
            return otherArray.count
        case is ProducerData:
            return otherArray.count
        case is SongData:
            return otherArray.count
        case is YouTubeData:
            return otherArray.count
        case is AlbumData:
            return otherArray.count
        case is InstrumentalData:
            return otherArray.count
        case is BeatData:
            return otherArray.count
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch recievedData {
        case is String:
            let string = recievedData as! String
            switch string {
            case "latest":
                let merch = latestContentArray[indexPath.item]
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "merchContentCollectionCell", for: indexPath) as! MerchContentCollectionCell
                cell.funcSetUp(latestMerch: merch)
                return cell
            case "kits":
                let kit = kitArray[indexPath.item]
                let merch = MerchData(kit: kit, apperal: nil, instrumentalSale: nil, service: nil, memorabilia: nil)
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "merchContentCollectionCell", for: indexPath) as! MerchContentCollectionCell
                cell.funcSetUp(latestMerch: merch)
                return cell
            case "instrumentals":
                let instr = instrumentalsArray[indexPath.item]
                let merch = MerchData(kit: nil, apperal: nil, instrumentalSale: instr, service: nil, memorabilia: nil)
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "merchContentCollectionCell", for: indexPath) as! MerchContentCollectionCell
                cell.funcSetUp(latestMerch: merch)
                return cell
            case "apperal":
                let apperal = apperalArray[indexPath.item]
                let merch = MerchData(kit: nil, apperal: apperal, instrumentalSale: nil, service: nil, memorabilia: nil)
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "merchContentCollectionCell", for: indexPath) as! MerchContentCollectionCell
                cell.funcSetUp(latestMerch: merch)
                return cell
            case "services":
                let service = servicesArray[indexPath.item]
                let merch = MerchData(kit: nil, apperal: nil, instrumentalSale: nil, service: service, memorabilia: nil)
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "merchContentCollectionCell", for: indexPath) as! MerchContentCollectionCell
                cell.funcSetUp(latestMerch: merch)
                return cell
            case "memorabilia":
                let memorabilia = memorabiliaArray[indexPath.item]
                let merch = MerchData(kit: nil, apperal: nil, instrumentalSale: nil, service: nil, memorabilia: memorabilia)
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "merchContentCollectionCell", for: indexPath) as! MerchContentCollectionCell
                cell.funcSetUp(latestMerch: merch)
                return cell
            case "sale":
                let merch = otherArray[indexPath.item]
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "merchContentCollectionCell", for: indexPath) as! MerchContentCollectionCell
                cell.funcSetUp(latestMerch: merch)
                return cell
            default:
                return UICollectionViewCell()
            }
        case is ArtistData:
            let merch = otherArray[indexPath.item]
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "merchContentCollectionCell", for: indexPath) as! MerchContentCollectionCell
            cell.funcSetUp(latestMerch: merch)
            return cell
        case is ProducerData:
            let merch = otherArray[indexPath.item]
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "merchContentCollectionCell", for: indexPath) as! MerchContentCollectionCell
            cell.funcSetUp(latestMerch: merch)
            return cell
        case is SongData:
            let merch = otherArray[indexPath.item]
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "merchContentCollectionCell", for: indexPath) as! MerchContentCollectionCell
            cell.funcSetUp(latestMerch: merch)
            return cell
        case is YouTubeData:
            let merch = otherArray[indexPath.item]
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "merchContentCollectionCell", for: indexPath) as! MerchContentCollectionCell
            cell.funcSetUp(latestMerch: merch)
            return cell
        case is AlbumData:
            let merch = otherArray[indexPath.item]
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "merchContentCollectionCell", for: indexPath) as! MerchContentCollectionCell
            cell.funcSetUp(latestMerch: merch)
            return cell
        case is InstrumentalData:
            let merch = otherArray[indexPath.item]
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "merchContentCollectionCell", for: indexPath) as! MerchContentCollectionCell
            cell.funcSetUp(latestMerch: merch)
            return cell
        case is BeatData:
            let merch = otherArray[indexPath.item]
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "merchContentCollectionCell", for: indexPath) as! MerchContentCollectionCell
            cell.funcSetUp(latestMerch: merch)
            return cell
        default:
            return UICollectionViewCell()
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch recievedData {
        case is String:
            let string = recievedData as! String
            switch string {
            case "latest":
                if let merch = latestContentArray[indexPath.item].kit {
                    merchToGo = merch
                } else if let merch = latestContentArray[indexPath.item].apperal{
                    merchToGo = merch
                } else if let merch = latestContentArray[indexPath.item].service{
                    merchToGo = merch
                } else if let merch = latestContentArray[indexPath.item].memorabilia{
                    merchToGo = merch
                } else if let merch = latestContentArray[indexPath.item].instrumentalSale{
                    merchToGo = merch
                }
            case "kits":
                let kit = kitArray[indexPath.item]
                merchToGo = kit
            case "instrumentals":
                let instr = instrumentalsArray[indexPath.item]
                merchToGo = instr
            case "apperal":
                let apperal = apperalArray[indexPath.item]
                merchToGo = apperal
            case "services":
                let service = servicesArray[indexPath.item]
                merchToGo = service
            case "memorabilia":
                let memorabilia = memorabiliaArray[indexPath.item]
                merchToGo = memorabilia
            case "sale":
                if let merch = otherArray[indexPath.item].kit {
                    merchToGo = merch
                } else if let merch = otherArray[indexPath.item].apperal{
                    merchToGo = merch
                } else if let merch = otherArray[indexPath.item].service{
                    merchToGo = merch
                } else if let merch = otherArray[indexPath.item].memorabilia{
                    merchToGo = merch
                } else if let merch = otherArray[indexPath.item].instrumentalSale{
                    merchToGo = merch
                }
            default:
                print("hbgvf")
            }
        case is ArtistData:
            if let merch = otherArray[indexPath.item].kit {
                merchToGo = merch
            } else if let merch = otherArray[indexPath.item].apperal{
                merchToGo = merch
            } else if let merch = otherArray[indexPath.item].service{
                merchToGo = merch
            } else if let merch = otherArray[indexPath.item].memorabilia{
                merchToGo = merch
            } else if let merch = otherArray[indexPath.item].instrumentalSale{
                merchToGo = merch
            }
        case is ProducerData:
            if let merch = otherArray[indexPath.item].kit {
                merchToGo = merch
            } else if let merch = otherArray[indexPath.item].apperal{
                merchToGo = merch
            } else if let merch = otherArray[indexPath.item].service{
                merchToGo = merch
            } else if let merch = otherArray[indexPath.item].memorabilia{
                merchToGo = merch
            } else if let merch = otherArray[indexPath.item].instrumentalSale{
                merchToGo = merch
            }
        case is SongData:
            if let merch = otherArray[indexPath.item].kit {
                merchToGo = merch
            } else if let merch = otherArray[indexPath.item].apperal{
                merchToGo = merch
            } else if let merch = otherArray[indexPath.item].service{
                merchToGo = merch
            } else if let merch = otherArray[indexPath.item].memorabilia{
                merchToGo = merch
            } else if let merch = otherArray[indexPath.item].instrumentalSale{
                merchToGo = merch
            }
        case is YouTubeData:
            if let merch = otherArray[indexPath.item].kit {
                merchToGo = merch
            } else if let merch = otherArray[indexPath.item].apperal{
                merchToGo = merch
            } else if let merch = otherArray[indexPath.item].service{
                merchToGo = merch
            } else if let merch = otherArray[indexPath.item].memorabilia{
                merchToGo = merch
            } else if let merch = otherArray[indexPath.item].instrumentalSale{
                merchToGo = merch
            }
        case is AlbumData:
            if let merch = otherArray[indexPath.item].kit {
                merchToGo = merch
            } else if let merch = otherArray[indexPath.item].apperal{
                merchToGo = merch
            } else if let merch = otherArray[indexPath.item].service{
                merchToGo = merch
            } else if let merch = otherArray[indexPath.item].memorabilia{
                merchToGo = merch
            } else if let merch = otherArray[indexPath.item].instrumentalSale{
                merchToGo = merch
            }
        case is InstrumentalData:
            if let merch = otherArray[indexPath.item].kit {
                merchToGo = merch
            } else if let merch = otherArray[indexPath.item].apperal{
                merchToGo = merch
            } else if let merch = otherArray[indexPath.item].service{
                merchToGo = merch
            } else if let merch = otherArray[indexPath.item].memorabilia{
                merchToGo = merch
            } else if let merch = otherArray[indexPath.item].instrumentalSale{
                merchToGo = merch
            }
        case is BeatData:
            if let merch = otherArray[indexPath.item].kit {
                merchToGo = merch
            } else if let merch = otherArray[indexPath.item].apperal{
                merchToGo = merch
            } else if let merch = otherArray[indexPath.item].service{
                merchToGo = merch
            } else if let merch = otherArray[indexPath.item].memorabilia{
                merchToGo = merch
            } else if let merch = otherArray[indexPath.item].instrumentalSale{
                merchToGo = merch
            }
        default:
            print("hbgvf")
        }
        performSegue(withIdentifier: "merchContentToProduct", sender: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: merchContentCollectionView.frame.width/2-10, height: 320)
    }
    
}

class MerchContentCollectionCell: UICollectionViewCell {
    
    @IBOutlet weak var merchArt: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var sale: UILabel!
    @IBOutlet weak var available: UILabel!
    @IBOutlet weak var colorsCollectionView: UICollectionView!
    var colors:[UIColor]!
    private var gradient = CAGradientLayer()
    var merchType:String!
    
    var colorCount:Int!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        sale.isHidden = true
        price.alpha = 1
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        colorsCollectionView.backgroundColor = .clear
    }
    
    override var isHighlighted: Bool {
        didSet{
            tapScale(cell: self, down: isHighlighted)
        }
    }
    
    func funcSetUp(latestMerch: MerchData) {
        sale.isHidden = true
        price.alpha = 1
        contentView.backgroundColor = Constants.Colors.lightApp
        contentView.layer.cornerRadius = 7
        merchArt.layer.cornerRadius = 7
        merchArt.contentMode = .scaleAspectFit
        if let merch = latestMerch.kit {
            merchType = "kit"
            available.text = "Available Files"
            colorsCollectionView.delegate = self
            colorsCollectionView.dataSource = self
            name.text = merch.name
            
            price.text = merch.retailPrice.dollarString
            
            if let sp = merch.salePrice {
                sale.isHidden = false
                sale.text = (merch.retailPrice-(merch.retailPrice*sp)).dollarString
                price.alpha = 0.7
                let attributedString = NSMutableAttributedString(string: merch.retailPrice.dollarString)
                attributedString.addAttribute(NSAttributedString.Key.baselineOffset, value: 0, range: NSMakeRange(0, attributedString.length))
                attributedString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: NSNumber(value: NSUnderlineStyle.thick.rawValue), range: NSMakeRange(0, attributedString.length))
                attributedString.addAttribute(NSAttributedString.Key.strikethroughColor, value: UIColor.gray, range: NSMakeRange(0, attributedString.length))
                 price.attributedText = attributedString
            }
            let imageURL = URL(string: merch.imageURLs[0])!
            if let cachedImage = imageCache.object(forKey: imageURL.absoluteString as NSString) {
                merchArt.image = cachedImage
                return
            } else {
                merchArt.setImage(from: imageURL, withPlaceholder: UIImage(named: "tonedeaflogo"))
            }
        } else if let merch = latestMerch.apperal{
            merchType = "apperal"
            name.text = merch.name
            available.text = "Available Colors"
            colors = GlobalFunctions.shared.getAvailableColors(apperal: merch)
            colorsCollectionView.delegate = self
            colorsCollectionView.dataSource = self
            let lp = GlobalFunctions.shared.getLowestPrice(apperal: merch)
            price.text = "From \(lp.dollarString)"
            let imageURL = URL(string: merch.imageURLs[0])!
            if let cachedImage = imageCache.object(forKey: imageURL.absoluteString as NSString) {
                merchArt.image = cachedImage
                return
            } else {
                merchArt.setImage(from: imageURL, withPlaceholder: UIImage(named: "tonedeaflogo"))
            }
        } else if let merch = latestMerch.service{
            merchType = "service"
            let image = UIImage(named: "lego")!
            available.text = "Next Available Date"
            colorsCollectionView.delegate = self
            colorsCollectionView.dataSource = self
            merchArt.image = image
            merchArt.backgroundColor = .white
            name.text = merch.name
            price.text = merch.retailPrice?.dollarString
        } else if let merch = latestMerch.memorabilia{
            merchType = "memorabilia"
            name.text = merch.name
            available.text = "Available Colors"
            colors = GlobalFunctions.shared.getAvailableColors(memorabilia: merch)
            colorsCollectionView.delegate = self
            colorsCollectionView.dataSource = self
            let lp = GlobalFunctions.shared.getLowestPrice(memorabilia: merch)
            price.text = "From \(lp.dollarString)"
            let imageURL = URL(string: merch.imageURLs[0])!
            if let cachedImage = imageCache.object(forKey: imageURL.absoluteString as NSString) {
                merchArt.image = cachedImage
                return
            } else {
                merchArt.setImage(from: imageURL, withPlaceholder: UIImage(named: "tonedeaflogo"))
            }
        } else if let merch = latestMerch.instrumentalSale{
            merchType = "instrumental"
            available.text = "Available Files"
            colorsCollectionView.delegate = self
            colorsCollectionView.dataSource = self
            price.text = merch.retailPrice?.dollarString
            let word = merch.instrumentaldbid.split(separator: "Æ")
            let id = String(word[0])
            DatabaseManager.shared.findInstrumentalById(instrumentalId: id, completion: {[weak self] result in
                guard let strongSelf = self else {return}
                switch result {
                case.success(let instrumental):
                    strongSelf.name.text = instrumental.instrumentalName
                    let imageURL = URL(string: "instrumental.imageURL")!
                    if let cachedImage = imageCache.object(forKey: imageURL.absoluteString as NSString) {
                        strongSelf.merchArt.image = cachedImage
                        return
                    } else {
                        strongSelf.merchArt.setImage(from: imageURL, withPlaceholder: UIImage(named: "tonedeaflogo"))
                    }
                case.failure(let err):
                    print("kjhfdgxfgchjk bi \(err)")
                }
            })
        }
    }
    
    
}

extension MerchContentCollectionCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch merchType {
        case "kit":
            return 1
        case "apperal":
            return colors.count
        case "service":
            return 1
        case "memorabilia":
            return colors.count
        case "instrumental":
            return 1
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "merchContentAccessoryCollectionCell", for: indexPath) as! MerchContentAccessoryCollectionCell
        cell.img.layer.cornerRadius = 12.5
        cell.img.layer.borderWidth = 1
        cell.img.tintColor = .white
        cell.img.contentMode = .scaleAspectFit
        cell.img.layer.borderColor = UIColor.white.cgColor
        switch merchType {
        case "kit":
            cell.img.layer.cornerRadius = 0
            cell.img.layer.borderWidth = 0
            cell.img.backgroundColor = .clear
            cell.img.image = UIImage(named: "zip-file")!.withTintColor(.white)
        case "apperal":
            cell.img.backgroundColor = colors[indexPath.item]
        case "service":
            cell.img.layer.cornerRadius = 0
            cell.img.layer.borderWidth = 0
            cell.img.backgroundColor = .clear
            cell.img.image = UIImage(systemName: "31.circle.fill")!
        case "memorabilia":
            cell.img.backgroundColor = colors[indexPath.item]
        case "instrumental":
            cell.img.layer.cornerRadius = 0
            cell.img.layer.borderWidth = 0
            cell.img.backgroundColor = .clear
            cell.img.image = UIImage(named: "mp3-file")!.withTintColor(.white)
        default:
            print("njbnj")
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 25, height: 25)
    }
}

class MerchContentAccessoryCollectionCell: UICollectionViewCell {
    
    @IBOutlet weak var img: UIImageView!
    
    override func prepareForReuse() {
        img.image = nil
        img.backgroundColor = Constants.Colors.mediumApp
    }
}

