//
//  UserFavoritesCollectionViewCell.swift
//  ToneDeafDeafinitionsApp
//
//  Created by Tone Deaf on 10/22/20.
//  Copyright © 2020 GITEM Solutions. All rights reserved.
//

import UIKit
import CollectionViewPagingLayout
import MarqueeLabel

class UserFavoritesCollectionViewCell: UICollectionViewCell, ScaleTransformView {
    var scaleOptions = ScaleTransformViewOptions(
        minScale: 0.70,
        maxScale: 0.70,
        scaleRatio: 0.00,
        translationRatio: .zero,
        minTranslationRatio: .zero,
        maxTranslationRatio: .zero,
        keepVerticalSpacingEqual: true,
        keepHorizontalSpacingEqual: true,
        scaleCurve: .linear,
        translationCurve: .linear,
        shadowEnabled: true,
        shadowColor: .black,
        shadowOpacity: 0.60,
        shadowRadiusMin: 2.00,
        shadowRadiusMax: 13.00,
        shadowOffsetMin: .init(width: 0.00, height: 2.00),
        shadowOffsetMax: .init(width: 0.00, height: 6.00),
        shadowOpacityMin: 0.10,
        shadowOpacityMax: 0.10,
        blurEffectEnabled: false,
        blurEffectRadiusRatio: 0.40,
        blurEffectStyle: .light,
        rotation3d: .init(
            angle: 1.90,
            minAngle: -1.05,
            maxAngle: 1.05,
            x: 0.00,
            y: -1.00,
            z: 0.00,
            m34: -0.000500
        ),
        translation3d: .init(
            translateRatios: (0.10, 0.00, -0.70),
            minTranslateRatios: (-0.10, 0.00, -3.00),
            maxTranslateRatios: (0.10, 0.00, 0.00)
        )
    )
    
    // The card view that we apply effects on
    var card: UIView!
    var subcard:UIView!
    var artwork: UIImageView!
    var coll: UICollectionView!
    var title:MarqueeLabel!
    var subtitle:MarqueeLabel!
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            setup()
        }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    var backgroundImageView:UIImageView!
    
    override func prepareForReuse() {
        if backgroundImageView != nil, backgroundImageView.image != nil {
            backgroundImageView.image = nil
        }
        backgroundImageView = nil
        artwork.image = nil
    }
    
    override var isHighlighted: Bool {
        didSet{
            tapScale(cell: self, down: isHighlighted)
        }
    }
    
    func setup() {
        // Adjust the card view frame you can use Autolayout too
        contentView.layer.cornerRadius = 15
        let cardFrame = CGRect(x: frame.width/4,
                               y: 25,
                               width: frame.width/2,
                               height: frame.height - 10)
        card = UIView(frame: cardFrame)
        subcard = UIView(frame: CGRect(x: 0, y: 0, width: card.frame.width, height: card.frame.height))
        subcard.layer.cornerRadius = 15
        card.backgroundColor = Constants.Colors.lightApp
        card.layer.cornerRadius = 15
        card.layer.masksToBounds = true
        contentView.addSubview(card)
        card.addSubview(subcard)
        let imageviewframe = CGRect(x: card.frame.width/4, y: card.frame.height/2 - (card.frame.width/2)/2, width: card.frame.width/2, height: card.frame.width/2)
        let artcontainer = UIView(frame: imageviewframe)
        artwork = UIImageView(frame: CGRect(x: 0, y: 0, width: card.frame.width/2, height: card.frame.width/2))
        artwork.layer.cornerRadius = 7
        artwork.contentMode = .scaleAspectFill
        artcontainer.addSubview(artwork)
        artcontainer.layer.cornerRadius = 7
        artcontainer.layer.masksToBounds = true
        let titleframe = CGRect(x: 10, y: 20, width: card.frame.width - 20, height: 25)
        title = MarqueeLabel(frame: titleframe, rate: 25, fadeLength: 3)
        title.animationDelay = 3
        title.trailingBuffer = 10
        title.font = UIFont(name: "AvenirNextCondensed-Bold", size: 17)
        let subtitleframe = CGRect(x: 10, y: card.frame.height - 45, width: card.frame.width - 20, height: 25)
        subtitle = MarqueeLabel(frame: subtitleframe, rate: 25, fadeLength: 3)
        subtitle.animationDelay = 3
        subtitle.trailingBuffer = 10
        subtitle.textColor = Constants.Colors.redApp
        subtitle.font = UIFont(name: "AvenirNextCondensed-Regular", size: 14)
        //subcard.addSubview(title)
        //subcard.addSubview(subtitle)
        subcard.addSubview(artcontainer)
    }
    
    func setUpFunc(fav: Any, coll: UICollectionView) {
        self.coll = coll
        switch fav {
        case is BeatData:
            let beat = fav as! BeatData
            setBeat(beat: beat)
        case is InstrumentalData:
            let instrumental = fav as! InstrumentalData
            setInstrumental(instrumental: instrumental)
        case is SongData:
            let song = fav as! SongData
            setSong(song: song)
        case is VideoData:
            let video = fav as! VideoData
            setVideo(video: video)
        case is AlbumData:
            let album = fav as! AlbumData
            setAlbum(album: album)
        default:
            print("jhgfc")
        }
    }
    
    func setBeat(beat: BeatData) {
        title.text = beat.name
        var songapro:[String] = []
        for pro in beat.producers {
            DatabaseManager.shared.fetchPersonData(person: pro, completion: {[weak self] result in
                guard let strongSelf = self else {return}
                switch result {
                case .success(let selectedProducer):
                    songapro.append(selectedProducer.name)
                    strongSelf.subtitle.text = songapro.joined(separator: ", ")
                case .failure(let err):
                    print("youyoudsafaerr", err)
                }
            })
        }
        let imageurl = beat.imageURL
        if let url = URL.init(string: imageurl) {
            blurredBackground(url: url, videoCellView: subcard)
            if let cachedImage = imageCache.object(forKey: url.absoluteString as NSString) {
                artwork.image = cachedImage
            } else {
                artwork.setImage(from: url, withPlaceholder: UIImage(named: "tonedeaflogo"))
            }
        }
    }
    
    func setInstrumental(instrumental: InstrumentalData) {
        title.text = instrumental.instrumentalName
        var songapro:[String] = []
        for pro in instrumental.producers {
            let word = pro.split(separator: "Æ")
            let id = word[1]
            songapro.append(String(id))
        }
        subtitle.text = songapro.joined(separator: ", ")
        let imageurl = "instrumental.imageURL"
        if let url = URL.init(string: imageurl) {
            blurredBackground(url: url, videoCellView: subcard)
            if let cachedImage = imageCache.object(forKey: url.absoluteString as NSString) {
                artwork.image = cachedImage
            } else {
                artwork.setImage(from: url, withPlaceholder: UIImage(named: "tonedeaflogo"))
            }
        }
    }
    
    func setSong(song: SongData) {
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
        var imageurl = ""
        GlobalFunctions.shared.selectImageURL(song: song, completion: {[weak self] ur in
            guard let strongSelf = self else {return}
            strongSelf.title.text = song.name
            strongSelf.subtitle.text = "\(songart.joined(separator: ",")), \(songapro.joined(separator: ","))"
            if ur != nil {
                imageurl = ur!
                print(imageurl)
                guard let imageURL = URL(string: imageurl) else {
                    strongSelf.artwork.image = UIImage(named: "defaultuser")
                    return
                }
                strongSelf.blurredBackground(url: imageURL, videoCellView: strongSelf.subcard)
                if let cachedImage = imageCache.object(forKey: imageURL.absoluteString as NSString) {
                    strongSelf.artwork.image = cachedImage
                } else {
                    strongSelf.artwork.setImage(from: imageURL, withPlaceholder: UIImage(named: "tonedeaflogo"))
                }
            } else {
                strongSelf.artwork.image = UIImage(named: "defaultuser")
            }
            
        })
    }
    
    func setVideo(video: VideoData) {
        title.text = video.title
        var songart:[String] = []
//        for art in video.videographers {
//            let word = art.split(separator: "Æ")
//            let id = word[1]
//            songart.append(String(id))
//        }
        var songapro:[String] = []
//        for pro in video.persons {
//            let word = pro.split(separator: "Æ")
//            let id = word[1]
//            songapro.append(String(id))
//        }
        subtitle.text = "\(songart.joined(separator: ",")), \(songapro.joined(separator: ","))"
        GlobalFunctions.shared.selectImageURL(video: video, completion: {[weak self] aimage in
            guard let strongSelf = self else {return}
            guard let imge = aimage else {
                strongSelf.artwork.image = UIImage(named: "tonedeaflogo")
                return
            }
            let imageURL = URL(string: imge)!
            strongSelf.blurredBackground(url: imageURL, videoCellView: strongSelf.subcard)
            if let cachedImage = imageCache.object(forKey: imageURL.absoluteString as NSString) {
                strongSelf.artwork.image = cachedImage
            } else {
                strongSelf.artwork.setImage(from: imageURL, withPlaceholder: UIImage(named: "tonedeaflogo"))
            }
            
        })
    }
    
    func setAlbum(album: AlbumData) {
        title.text = album.name
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
        var songart:[String] = []
        for art in album.mainArtist {
            let word = art.split(separator: "Æ")
            let id = word[1]
            songart.append(String(id))
        }
        var songapro:[String] = []
        for pro in album.producers {
            let word = pro.split(separator: "Æ")
            let id = word[1]
            songapro.append(String(id))
        }
        subtitle.text = "\(songart.joined(separator: ",")), \(songapro.joined(separator: ","))"
        if let url = URL.init(string: imageurl) {
            blurredBackground(url: url, videoCellView: subcard)
            if let cachedImage = imageCache.object(forKey: url.absoluteString as NSString) {
                artwork.image = cachedImage
            } else {
                artwork.setImage(from: url, withPlaceholder: UIImage(named: "tonedeaflogo"))
            }
        }
    }
    
    func blurredBackground(url: URL, videoCellView: UIView) {
        let backgroundImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: videoCellView.bounds.width, height: videoCellView.bounds.height))
        videoCellView.addSubview(backgroundImageView)
        if let cachedImage = imageCache.object(forKey: url.absoluteString as NSString) {
            backgroundImageView.image = cachedImage
        } else {
            backgroundImageView.setImage(from: url, withPlaceholder: UIImage(named: "tonedeaflogo"))
        }
        videoCellView.sendSubviewToBack(backgroundImageView)
        
        let blur = UIBlurEffect(style: .dark)
        let blurView = UIVisualEffectView(effect: blur)
        videoCellView.layer.cornerRadius = 15
        blurView.layer.cornerRadius = 15
        backgroundImageView.layer.cornerRadius = 15
        contentView.layer.cornerRadius = 15
        blurView.frame = videoCellView.bounds
        videoCellView.addSubview(blurView)
        videoCellView.sendSubviewToBack(blurView)
        videoCellView.sendSubviewToBack(backgroundImageView)
    }
}
