//
//  FreeBeatArtistTableViewCell.swift
//  ToneDeafDeafinitionsApp
//
//  Created by Tone Deaf on 8/3/20.
//  Copyright © 2020 GITEM Solutions. All rights reserved.
//

import UIKit
import FirebaseDatabase
import MarqueeLabel
import NVActivityIndicatorView
import CDAlertView

class FreeBeatArtistTableViewCell: UITableViewCell {

    @IBOutlet weak var audioWave: NVActivityIndicatorView!
    @IBOutlet weak var beatCellImage: UIImageView!
    @IBOutlet weak var textFieldCellBeatName: MarqueeLabel!
    @IBOutlet weak var textLabelBeatDuration: UILabel!
    @IBOutlet weak var textLabelDate: UILabel!
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var textFieldProducers: MarqueeLabel!
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var moreButton: UIButton!
    @IBOutlet weak var redownloadButton: UIButton!
    @IBOutlet weak var downloadStack: UIStackView!
    @IBOutlet weak var numberOfDownloads: UILabel!
    @IBOutlet weak var DownloadsArrow: UIImageView!
    @IBOutlet weak var downloadSpinner: NVActivityIndicatorView!
    @IBOutlet weak var exclusiveStack: UIStackView!
    @IBOutlet weak var exclusivePrice: UILabel!
    @IBOutlet weak var exclusiveLabel: UILabel!
    @IBOutlet weak var wavStack: UIStackView!
    @IBOutlet weak var wavPrice: UILabel!
    @IBOutlet weak var wavLabel: UILabel!
    @IBOutlet weak var wavCart: UIImageView!
    @IBOutlet weak var exclusiveCart: UIImageView!
    
    var currentBeat:BeatData!
    var favorited = false
    var exclusiveInCart = false
    var wavInCart = false
    
    override func prepareForReuse() {
        shareButton.addTarget(self, action: #selector(shareTapped), for: .touchUpInside)
        currentBeat = nil
        redownloadButton.isHidden = false
        downloadSpinner.stopAnimating()
        audioWave.stopAnimating()
        favorited = false
        favoriteButton.setImage(UIImage(systemName: "heart"), for: .normal)
        favoriteButton.tintColor = .white
        exclusivePrice.text = "N/A"
        exclusivePrice.textColor = .white
        exclusivePrice.alpha = 0.6
        exclusiveLabel.alpha = 0.6
        wavPrice.text = "N/A"
        wavPrice.textColor = .white
        wavPrice.alpha = 0.6
        wavLabel.alpha = 0.6
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setBeat(beat: BeatData) {
        currentBeat = beat
        beatCellImage.alpha = 0.5
        setGestures()
        for favorite in currentAppUser.favorites {
            if favorite.dbid.contains(beat.toneDeafAppId) {
                favorited = true
                favoriteButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
                favoriteButton.tintColor = Constants.Colors.redApp
            }
        }
        if let price = beat.exclusivePrice {
            if let _ = beat.exclusiveFilesURL {
                exclusivePrice.text = price.dollarString
                exclusivePrice.textColor = .white
                exclusivePrice.alpha = 1
                exclusiveLabel.alpha = 1
            }
        }
        if let price = beat.wavPrice {
            if let _ = beat.wavURL {
                wavPrice.text = price.dollarString
                wavPrice.textColor = .white
                wavPrice.alpha = 1
                wavLabel.alpha = 1
            }
        }
        var proarray:[String] = []
        for pro in beat.producers {
            DatabaseManager.shared.fetchPersonData(person: pro, completion: {[weak self] result in
                guard let strongSelf = self else {return}
                switch result {
                case .success(let person):
                    proarray.append(person.name)
                    strongSelf.textFieldProducers.text = proarray.joined(separator: ", ")
                case .failure(let err):
                    print("dsvgredfxbdfzx"+err.localizedDescription)
                }
            })
            let word = pro.split(separator: "Æ")
            let name = word[1]
            proarray.append(String(name))
        }
        checkFileDownload()
        numberOfDownloads.text = String(beat.downloads)
        textLabelBeatDuration.text = beat.duration
        textFieldCellBeatName.text = beat.name
        textLabelDate.text = beat.date.replacingOccurrences(of: "August ", with: "08/").replacingOccurrences(of: "January ", with: "01/").replacingOccurrences(of: "February ", with: "02/").replacingOccurrences(of: "March ", with: "03/").replacingOccurrences(of: "April ", with: "04/").replacingOccurrences(of: "May ", with: "05/").replacingOccurrences(of: "June ", with: "06/").replacingOccurrences(of: "July ", with: "07/").replacingOccurrences(of: "September ", with: "09/").replacingOccurrences(of: "October ", with: "10/").replacingOccurrences(of: "November ", with: "11/").replacingOccurrences(of: "December ", with: "12/").replacingOccurrences(of: ", ", with: "/")
    }
    
    func setGestures() {
        let downloadgesture = UITapGestureRecognizer(target: self, action: #selector(downloadTapped(_:)))
        let wavgesture = UITapGestureRecognizer(target: self, action: #selector(wavTapped(_:)))
        let exclusivegesture = UITapGestureRecognizer(target: self, action: #selector(exclusiveTapped(_:)))
        downloadgesture.numberOfTapsRequired = 1
        downloadStack.addGestureRecognizer(downloadgesture)
        if let price = currentBeat.exclusivePrice {
            if let _ = currentBeat.exclusiveFilesURL {
                exclusivegesture.numberOfTapsRequired = 1
                exclusiveStack.addGestureRecognizer(exclusivegesture)
            }
        }
        if let price = currentBeat.wavPrice {
            if let _ = currentBeat.wavURL {
                wavgesture.numberOfTapsRequired = 1
                wavStack.addGestureRecognizer(wavgesture)
            }
        }
        
        redownloadButton.addTarget(self, action: #selector(reDownloadTapped), for: .touchUpInside)
    }
    
    @objc func shareTapped() {
        let vc = UIActivityViewController(activityItems: ["https://www.instagram.com/p/CFDTWydAHfe/?igshid=1t9t6pubzu1u0"], applicationActivities: [])
        //vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        NotificationCenter.default.post(name: OpenTheShareNotify, object: vc)
    }
    
    @IBAction func favoriteTapped(_ sender: Any) {
            switch favorited {
            case true:
                favorited = false
                favoriteButton.setImage(UIImage(systemName: "heart"), for: .normal)
                favoriteButton.tintColor = .white
                let id = "\(currentBeat.toneDeafAppId)Æ\(currentBeat.name)"
                var newfav:[UserFavorite] = []
                for fav in currentAppUser.favorites {
                    if fav.dbid != id {
                        newfav.append(fav)
                    }
                }
                currentAppUser.favorites = newfav
                Database.database().reference().child("Users").child(currentAppUser.uid).child("Favorites").child(id).removeValue()
                DatabaseManager.shared.getBeatFavorites(currentBeat: currentBeat, completion: {[weak self] favs in
                    guard let strongSelf = self else {return}
                    var num = favs
                    num-=1
                    Database.database().reference().child("Beats").child(strongSelf.currentBeat.priceType).child(strongSelf.currentBeat.beatID).child("Number of Favorites").setValue(num)
                })
            default:
                favorited = true
                lightImpactGenerator.impactOccurred()
                tapScale(button: favoriteButton)
                favoriteButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
                favoriteButton.tintColor = Constants.Colors.redApp
                let id = "\(currentBeat.toneDeafAppId)Æ\(currentBeat.name)"
                let datee = getCurrentLocalDate()
                let dateFormatter = DateFormatter()
                dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
                dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
                let date = dateFormatter.date(from:datee)!
                currentAppUser.favorites.append(UserFavorite(dbid: id, timestamp: date))
                Database.database().reference().child("Users").child(currentAppUser.uid).child("Favorites").child(id).child("Timestamp").setValue(datee)
                DatabaseManager.shared.getBeatFavorites(currentBeat: currentBeat, completion: {[weak self] favs in
                    guard let strongSelf = self else {return}
                    var num = favs
                    num+=1
                    print(num)
                    Database.database().reference().child("Beats").child(strongSelf.currentBeat.priceType).child(strongSelf.currentBeat.beatID).child("Number of Favorites").setValue(num)
                })
            }
        
    }
    
    @IBAction func moreTapped(_ sender: Any) {
        switch currentTab {
        case 0:
            NotificationCenter.default.post(name: DashToBeatInfoSegNotify, object: currentBeat)
        case 1:
            NotificationCenter.default.post(name: MusicToBeatInfoSegNotify, object: currentBeat)
        case 2:
            NotificationCenter.default.post(name: FreePaidToBeatInfoSegNotify, object: currentBeat)
        case 3:
            NotificationCenter.default.post(name: MerchToBeatInfoSegNotify, object: currentBeat)
        case 4:
            NotificationCenter.default.post(name: ExploreToBeatInfoSegNotify, object: currentBeat)
        default:
            print("sdjvkbh ")
        }
    }
    
    @objc func downloadTapped(_ sender: UITapGestureRecognizer? = nil) {
        let alerticon = UIImage(named: "mp3-file")!.withTintColor(.white)
        let actionSheet = CDAlertView(title: "Download \"\(currentBeat.name)\"?", message: "Mp3 Lease License", type: .custom(image: alerticon))
        actionSheet.alertBackgroundColor = Constants.Colors.mediumApp
        actionSheet.circleFillColor = .black
        actionSheet.titleTextColor = .white
        actionSheet.messageTextColor = .white
        let cancel = CDAlertViewAction(title: "Cancel", font: UIFont.systemFont(ofSize: 16), textColor: Constants.Colors.redApp, backgroundColor: Constants.Colors.mediumApp, handler: nil)
        actionSheet.add(action: cancel)
        actionSheet.add(action: CDAlertViewAction(title: "Download", font: UIFont.boldSystemFont(ofSize: 16), textColor: Constants.Colors.redApp, backgroundColor: Constants.Colors.mediumApp, handler: {[weak self]_ in
            guard let strongSelf = self else {return false}
            DownloadManager.shared.startDownload(beat: strongSelf.currentBeat, exten: ".mp3")
            return true
        }))
        NotificationCenter.default.post(name: OpenTheAlertNotify, object: actionSheet)
    }
    
    @objc func wavTapped(_ sender: UITapGestureRecognizer? = nil) {
        guard let wavpice = currentBeat.wavPrice else {return}
        switch wavInCart {
        case true:
            for index in 0..<userCart.count {
                let item = userCart[index].product
                if item.id == "\(currentBeat.toneDeafAppId)Æ\(currentBeat.name)Æwav" {
                    let alerticon = UIImage(named: "wav-file")!.withTintColor(.white)
                    let actionSheet = CDAlertView(title: "Remove \"\(currentBeat.name)\" Wav Lease License from Cart?", message: "Wav Lease License", type: .custom(image: alerticon))
                    actionSheet.alertBackgroundColor = Constants.Colors.mediumApp
                    actionSheet.circleFillColor = .black
                    actionSheet.titleTextColor = .white
                    actionSheet.messageTextColor = .white
                    let cancel = CDAlertViewAction(title: "Cancel", font: UIFont.systemFont(ofSize: 16), textColor: Constants.Colors.redApp, backgroundColor: Constants.Colors.mediumApp, handler: nil)
                    actionSheet.add(action: cancel)
                    actionSheet.add(action: CDAlertViewAction(title: "Remove", font: UIFont.boldSystemFont(ofSize: 16), textColor: Constants.Colors.redApp, backgroundColor: Constants.Colors.mediumApp, handler: {[weak self]_ in
                        guard let strongSelf = self else {return false}
                        userCart.remove(at: index)
                        strongSelf.wavInCart = false
                        strongSelf.wavCart.image = UIImage(systemName: "cart.badge.plus")
                        strongSelf.wavCart.tintColor = Constants.Colors.redApp
                        if let price = strongSelf.currentBeat.wavPrice {
                            
                            strongSelf.wavPrice.text = price.dollarString
                        }
                        strongSelf.wavPrice.textColor = .white
                        strongSelf.wavPrice.alpha = 1
                        strongSelf.wavLabel.alpha = 1
                        return true
                    }))
                    NotificationCenter.default.post(name: OpenTheAlertNotify, object: actionSheet)
                    return
                }
            }
        default:
            let product = Product(id: "\(currentBeat.toneDeafAppId)Æ\(currentBeat.name)Æwav", dbid: "\(currentBeat.toneDeafAppId)Æ\(currentBeat.name)", name: currentBeat.name, price: 0.0, thumbnailURL: currentBeat.imageURL, type: "Wav", involved: currentBeat.producers)
            let alerticon = UIImage(named: "wav-file")!.withTintColor(.white)
            let actionSheet = CDAlertView(title: "Add \"\(currentBeat.name)\" Wav Lease License to Cart?", message: "Wav Lease License", type: .custom(image: alerticon))
            actionSheet.alertBackgroundColor = Constants.Colors.mediumApp
            actionSheet.circleFillColor = .black
            actionSheet.titleTextColor = .white
            actionSheet.messageTextColor = .white
            let cancel = CDAlertViewAction(title: "Cancel", font: UIFont.systemFont(ofSize: 16), textColor: Constants.Colors.redApp, backgroundColor: Constants.Colors.mediumApp, handler: nil)
            actionSheet.add(action: cancel)
            actionSheet.add(action: CDAlertViewAction(title: "Add", font: UIFont.boldSystemFont(ofSize: 16), textColor: Constants.Colors.redApp, backgroundColor: Constants.Colors.mediumApp, handler: {[weak self]_ in
                guard let strongSelf = self else {return false}
                product.price = wavpice
                userCart.add(product)
                strongSelf.wavCart.image = UIImage(systemName: "cart.fill")
                strongSelf.wavCart.tintColor = .green
                strongSelf.wavPrice.text = "In Cart"
                strongSelf.wavInCart = true
                return true
            }))
            NotificationCenter.default.post(name: OpenTheAlertNotify, object: actionSheet)
            return
        }
    }
    
    @objc func exclusiveTapped(_ sender: UITapGestureRecognizer? = nil) {
        guard let exclusiveprice = currentBeat.exclusivePrice else {return}
        switch exclusiveInCart {
        case true:
            for index in 0..<userCart.count {
                let item = userCart[index].product
                if item.id == "\(currentBeat.toneDeafAppId)Æ\(currentBeat.name)Æexclusive" {
                    let alerticon = UIImage(named: "zip-file")!.withTintColor(.white)
                    let actionSheet = CDAlertView(title: "Remove \"\(currentBeat.name)\" Exclusive License & Stems from Cart?", message: "Exclusive License & Stems", type: .custom(image: alerticon))
                    actionSheet.alertBackgroundColor = Constants.Colors.mediumApp
                    actionSheet.circleFillColor = .black
                    actionSheet.titleTextColor = .white
                    actionSheet.messageTextColor = .white
                    let cancel = CDAlertViewAction(title: "Cancel", font: UIFont.systemFont(ofSize: 16), textColor: Constants.Colors.redApp, backgroundColor: Constants.Colors.mediumApp, handler: nil)
                    actionSheet.add(action: cancel)
                    actionSheet.add(action: CDAlertViewAction(title: "Remove", font: UIFont.boldSystemFont(ofSize: 16), textColor: Constants.Colors.redApp, backgroundColor: Constants.Colors.mediumApp, handler: {[weak self]_ in
                        guard let strongSelf = self else {return false}
                        userCart.remove(at: index)
                        strongSelf.exclusiveInCart = false
                        strongSelf.exclusiveCart.image = UIImage(systemName: "cart.badge.plus")
                        strongSelf.exclusiveCart.tintColor = Constants.Colors.redApp
                        if let price = strongSelf.currentBeat.exclusivePrice {
                            
                            strongSelf.exclusivePrice.text = price.dollarString
                        }
                        strongSelf.exclusivePrice.textColor = .white
                        strongSelf.exclusivePrice.alpha = 1
                        strongSelf.exclusiveLabel.alpha = 1
                        return true
                    }))
                    NotificationCenter.default.post(name: OpenTheAlertNotify, object: actionSheet)
                    return
                }
            }
        default:
            let product = Product(id: "\(currentBeat.toneDeafAppId)Æ\(currentBeat.name)Æexclusive", dbid: "\(currentBeat.toneDeafAppId)Æ\(currentBeat.name)", name: currentBeat.name, price: 0.0, thumbnailURL: currentBeat.imageURL, type: "Exclusive", involved: currentBeat.producers)
            let alerticon = UIImage(named: "zip-file")!.withTintColor(.white)
            let actionSheet = CDAlertView(title: "Add \"\(currentBeat.name)\" Exclusive License & Stems to Cart?", message: "Exclusive License & Stems", type: .custom(image: alerticon))
            actionSheet.alertBackgroundColor = Constants.Colors.mediumApp
            actionSheet.circleFillColor = .black
            actionSheet.titleTextColor = .white
            actionSheet.messageTextColor = .white
            let cancel = CDAlertViewAction(title: "Cancel", font: UIFont.systemFont(ofSize: 16), textColor: Constants.Colors.redApp, backgroundColor: Constants.Colors.mediumApp, handler: nil)
            actionSheet.add(action: cancel)
            actionSheet.add(action: CDAlertViewAction(title: "Add", font: UIFont.boldSystemFont(ofSize: 16), textColor: Constants.Colors.redApp, backgroundColor: Constants.Colors.mediumApp, handler: {[weak self]_ in
                guard let strongSelf = self else {return false}
                product.price = exclusiveprice
                userCart.add(product)
                strongSelf.exclusiveCart.image = UIImage(systemName: "cart.fill")
                strongSelf.exclusiveCart.tintColor = .green
                strongSelf.exclusivePrice.text = "In Cart"
                strongSelf.exclusiveInCart = true
                return true
            }))
            NotificationCenter.default.post(name: OpenTheAlertNotify, object: actionSheet)
            return
        }
    }
    
    @objc func reDownloadTapped() {
        redownloadButton.isHidden = true
        downloadSpinner.startAnimating()
        for item in currentAppUser.downloads {
            if item.dbid.contains(currentBeat.toneDeafAppId) {
                
                let ex = item.name.suffix(4)
                DownloadManager.shared.startDownload(beat: currentBeat, exten: String(ex))
            }
        }
    }
    
    func checkFileDownload() {
        if currentAppUser.downloads.count == 0 {
            redownloadButton.isHidden = true
            return
        }
        for item in currentAppUser.downloads {
            if item.dbid.contains(currentBeat.toneDeafAppId) {
                if !FileManager().fileExists(atPath: item.destinationPath!) {
                    print("File is no longer on device.")
                    redownloadButton.isHidden = false
                    return
                }
            }
        }
        redownloadButton.isHidden = true
        print("File is currently downloaded on device.")
    }
    
}
