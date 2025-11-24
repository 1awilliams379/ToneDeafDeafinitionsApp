//
//  BeatCell.swift
//  ToneDeafDeafinitionsApp
//
//  Created by Tone Deaf on 8/2/20.
//  Copyright © 2020 GITEM Solutions. All rights reserved.
//

import UIKit
import FirebaseDatabase
import MarqueeLabel
import NVActivityIndicatorView

class FreeBeatListenerCell: UITableViewCell {

    @IBOutlet weak var audioWave: NVActivityIndicatorView!
    @IBOutlet weak var beatCellImage: UIImageView!
    @IBOutlet weak var textFieldCellBeatName: MarqueeLabel!
    @IBOutlet weak var textFieldProducers: MarqueeLabel!
    @IBOutlet weak var textLabelBeatDuration: UILabel!
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var moreButton: UIButton!
    @IBOutlet weak var downloadStack: UIStackView!
    @IBOutlet weak var redownloadButton: UIButton!
    @IBOutlet weak var DownloadsArrow: UIImageView!
    @IBOutlet weak var downloadSpinner: NVActivityIndicatorView!
    @IBOutlet weak var numberOfDownloads: UILabel!
    @IBOutlet weak var exclusiveStack: UIStackView!
    @IBOutlet weak var exclusivePrice: UILabel!
    @IBOutlet weak var exclusiveLabel: UILabel!
    @IBOutlet weak var wavStack: UIStackView!
    @IBOutlet weak var wavPrice: UILabel!
    @IBOutlet weak var wavLabel: UILabel!

    var currentBeat:BeatData!
    var favorited = false
    
    override func prepareForReuse() {
        currentBeat = nil
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
            let word = pro.split(separator: "Æ")
            let name = word[1]
            proarray.append(String(name))
        }
        checkFileDownload()
        textFieldProducers.text = proarray.joined(separator: ", ")
        numberOfDownloads.text = String(beat.downloads)
        textLabelBeatDuration.text = beat.duration
        textFieldCellBeatName.text = beat.name
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
