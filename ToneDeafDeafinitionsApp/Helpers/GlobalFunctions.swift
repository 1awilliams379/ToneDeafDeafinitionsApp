//
//  GlobalFunctions.swiftØOOO
//  ToneDeafDeafinitionsApp
//
//  Created by Tone Deaf on 10/8/20.
//  Copyright © 2020 GITEM Solutions. All rights reserved.
//

import Foundation
import AVFoundation
import UIKit

class GlobalFunctions {
    static let shared = GlobalFunctions()
    
    func selectImageURL(artist:ArtistData,completion: @escaping ((String?) -> Void)) {
        var imageurl = ""
            if artist.spotifyProfileImageURL != "" {
                imageurl = artist.spotifyProfileImageURL
            } else if artist.soundcloudProfileImageURL != nil {
                guard let url = artist.soundcloudProfileImageURL else {
                    fatalError()}
                imageurl = url
            } else if artist.amazonProfileImageURL != nil {
                guard let url = artist.amazonProfileImageURL else {
                    fatalError()}
                imageurl = url
            } else if artist.youtubeMusicProfileImageURL != nil {
                guard let url = artist.youtubeMusicProfileImageURL else {
                    fatalError()}
                imageurl = url
            } else if artist.tidalProfileImageURL != nil {
                guard let url = artist.tidalProfileImageURL else {
                    fatalError()}
                imageurl = url
            } else if artist.spinrillaProfileImageURL != nil {
                guard let url = artist.spinrillaProfileImageURL else {
                    fatalError()}
                imageurl = url
            } else if artist.napsterProfileImageURL != nil {
                guard let url = artist.napsterProfileImageURL else {
                    fatalError()}
                imageurl = url
            } else if artist.deezerProfileImageURL != nil {
                guard let url = artist.deezerProfileImageURL else {
                    fatalError()}
                imageurl = url
            } else if artist.instagramProfileImageURL != nil {
                guard let url = artist.instagramProfileImageURL else {
                    fatalError()}
                imageurl = url
            } else if artist.twitterProfileImageURL != nil {
                guard let url = artist.twitterProfileImageURL else {
                    fatalError()}
                imageurl = url
            } else if artist.facebookProfileImageURL != nil {
                guard let url = artist.facebookProfileImageURL else {
                    fatalError()}
                imageurl = url
            } else {
                completion(nil)
                return
            }
            completion(imageurl)
        return
    }
    
    func selectImageURL(producer:ProducerData,completion: @escaping ((String?) -> Void)) {
        var imageurl = ""
            if producer.spotifyProfileImageURL != "" {
                imageurl = producer.spotifyProfileImageURL
            }
//            else if producer.soundcloudProfileImageURL != nil {
//                guard let url = producer.soundcloudProfileImageURL else {
//                    fatalError()}
//                imageurl = url
//            } else if producer.amazonProfileImageURL != nil {
//                guard let url = producer.amazonProfileImageURL else {
//                    fatalError()}
//                imageurl = url
//            } else if producer.youtubeMusicProfileImageURL != nil {
//                guard let url = producer.youtubeMusicProfileImageURL else {
//                    fatalError()}
//                imageurl = url
//            } else if producer.tidalProfileImageURL != nil {
//                guard let url = producer.tidalProfileImageURL else {
//                    fatalError()}
//                imageurl = url
//            } else if producer.spinrillaProfileImageURL != nil {
//                guard let url = producer.spinrillaProfileImageURL else {
//                    fatalError()}
//                imageurl = url
//            } else if producer.napsterProfileImageURL != nil {
//                guard let url = producer.napsterProfileImageURL else {
//                    fatalError()}
//                imageurl = url
//            } else if producer.deezerProfileImageURL != nil {
//                guard let url = producer.deezerProfileImageURL else {
//                    fatalError()}
//                imageurl = url
//            } else if producer.instagramProfileImageURL != nil {
//                guard let url = producer.instagramProfileImageURL else {
//                    fatalError()}
//                imageurl = url
//            } else if producer.twitterProfileImageURL != nil {
//                guard let url = producer.twitterProfileImageURL else {
//                    fatalError()}
//                imageurl = url
//            } else if producer.facebookProfileImageURL != nil {
//                guard let url = producer.facebookProfileImageURL else {
//                    fatalError()}
//                imageurl = url
//            }
            else {
                completion(nil)
                return
            }
            completion(imageurl)
        return
    }
    
    func selectImageURL(person:PersonData,completion: @escaping ((String?) -> Void)) {
        var imageurl = ""
        if person.manualImageURL != nil {
            guard let url = person.manualImageURL else {
                fatalError()}
            imageurl = url
        } else if let dr = person.spotify?.profileImageURL{
            imageurl = dr
        } else if let dr = person.deezer?.profileImageURL{
            imageurl = dr
        } else if let dr = person.twitter?.profileImageURL{
            imageurl = dr
        }
//            else if producer.soundcloudProfileImageURL != nil {
//                guard let url = producer.soundcloudProfileImageURL else {
//                    fatalError()}
//                imageurl = url
//            } else if producer.amazonProfileImageURL != nil {
//                guard let url = producer.amazonProfileImageURL else {
//                    fatalError()}
//                imageurl = url
//            } else if producer.youtubeMusicProfileImageURL != nil {
//                guard let url = producer.youtubeMusicProfileImageURL else {
//                    fatalError()}
//                imageurl = url
//            } else if producer.tidalProfileImageURL != nil {
//                guard let url = producer.tidalProfileImageURL else {
//                    fatalError()}
//                imageurl = url
//            } else if producer.spinrillaProfileImageURL != nil {
//                guard let url = producer.spinrillaProfileImageURL else {
//                    fatalError()}
//                imageurl = url
//            } else if producer.napsterProfileImageURL != nil {
//                guard let url = producer.napsterProfileImageURL else {
//                    fatalError()}
//                imageurl = url
//            } else if producer.deezerProfileImageURL != nil {
//                guard let url = producer.deezerProfileImageURL else {
//                    fatalError()}
//                imageurl = url
//            } else if producer.instagramProfileImageURL != nil {
//                guard let url = producer.instagramProfileImageURL else {
//                    fatalError()}
//                imageurl = url
//            } else if producer.twitterProfileImageURL != nil {
//                guard let url = producer.twitterProfileImageURL else {
//                    fatalError()}
//                imageurl = url
//            } else if producer.facebookProfileImageURL != nil {
//                guard let url = producer.facebookProfileImageURL else {
//                    fatalError()}
//                imageurl = url
//            }
            else {
                completion(nil)
                return
            }
            completion(imageurl)
        return
    }
    
    func selectImageURL(song:SongData,completion: @escaping ((String?) -> Void)) {
        var imageurl = ""
        if song.manualImageURL != nil {
            guard let url = song.manualImageURL else {
                fatalError()}
            imageurl = url
        } else if song.spotify?.spotifyArtworkURL != nil {
            imageurl = song.spotify!.spotifyArtworkURL
        } else if song.soundcloud?.imageurl != nil {
            guard let url = song.soundcloud?.imageurl else {
                fatalError()}
            imageurl = url
        } else if song.soundcloud?.imageurl != nil {
            guard let url = song.soundcloud?.imageurl else {
                fatalError()}
            imageurl = url
        } else if song.amazon?.imageurl != nil {
            guard let url = song.amazon?.imageurl else {
                fatalError()}
            imageurl = url
        } else if song.youtubeMusic?.imageurl != nil {
            guard let url = song.youtubeMusic?.imageurl else {
                fatalError()}
            imageurl = url
        } else if song.tidal?.imageurl != nil {
            guard let url = song.tidal?.imageurl else {
                fatalError()}
            imageurl = url
        } else if song.spinrilla?.imageurl != nil {
            guard let url = song.spinrilla?.imageurl else {
                fatalError()}
            imageurl = url
        } else if song.napster?.imageurl != nil {
            guard let url = song.napster?.imageurl else {
                fatalError()}
            imageurl = url
        } else if song.deezer?.imageurl != nil {
            guard let url = song.deezer?.imageurl else {
                fatalError()}
            imageurl = url
        } else if song.apple?.appleArtworkURL != nil {
            imageurl = song.apple!.appleArtworkURL
        } else {
            imageurl = ""
        }
        if imageurl == "" {
            completion(nil)
        } else {
            completion(imageurl)
        }
    }
    
    func selectImageURL(video:VideoData,completion: @escaping ((String?) -> Void)) {
        var imageurl = ""
        
        if video.manualThumbnailURL != nil {
            guard let url = video.manualThumbnailURL else {
                fatalError()}
            imageurl = url
        } else
        if video.youtube != nil {
            for vid in video.youtube! {
                imageurl = vid.thumbnailURL
                break
            }
        } else
        if video.twitter != nil {
            for vid in video.twitter! {
                if let _ = vid.media {
                    for med in vid.media! {
                        if let _ = med.previewURL {
                            imageurl = med.previewURL!
                            break
                        }
                    }
                }
            }
        } else {
            imageurl = ""
        }
        if imageurl == "" {
            completion(nil)
        } else {
            completion(imageurl)
        }
    }
    
    func selectImageURL(album:AlbumData,completion: @escaping ((String?) -> Void)) {
        var imageurl = ""
        if let plat = album.manualImageURL {
            imageurl = plat
        } else if let plat = album.spotify {
            let img = plat.imageURL
            imageurl = img
        } else if let plat = album.soundcloud {
            if let img = plat.imageurl {
                imageurl = img
            }
        } else if let plat = album.amazon {
            if let img = plat.imageurl {
                imageurl = img
            }
        } else if let plat = album.youtubeMusic {
            if let img = plat.imageurl {
                imageurl = img
            }
        } else if let plat = album.tidal {
            if let img = plat.imageurl {
                imageurl = img
            }
        } else if let plat = album.spinrilla {
            if let img = plat.imageurl {
                imageurl = img
            }
        } else if let plat = album.napster {
            if let img = plat.imageurl {
                imageurl = img
            }
        } else if let plat = album.deezer {
            if let img = plat.imageurl {
                imageurl = img
            }
        } else if let plat = album.apple {
            imageurl = plat.imageURL
        }
        else {
            imageurl = ""
        }
        if imageurl == "" {
            completion(nil)
        } else {
            completion(imageurl)
        }
    }
    
    func selectImageURL(instrumental:InstrumentalData,completion: @escaping ((String?) -> Void)) {
        var imageurl = ""
        if let spotify = instrumental.spotify?.spotifyArtworkURL {
            imageurl = spotify
            completion(imageurl)
        }
        else if let deezer = instrumental.deezer?.imageurl {
            imageurl = deezer
            completion(imageurl)
        }
        else if let songs = instrumental.songs {
            for song in songs {
                DatabaseManager.shared.findSongById(songId: song, completion: {[weak self] result in
                    guard let strongSelf = self else {return}
                    switch result {
                    case.success(let songData):
                        strongSelf.selectImageURL(song: songData, completion: { url in
                            if let url = url {
                                imageurl = url
                            }
                            completion(imageurl)
                        })
                    case.failure(let err):
                        completion(nil)
                    }
                })
            }
        } else {
            completion(nil)
        }
    }
    
    func selectPreviewURL(song:SongData,completion: @escaping ((String?) -> Void)) {
        var prevurl = ""
        if song.manualPreviewURL != nil && isAudioPlayable(urlString: song.manualPreviewURL) {
            prevurl = song.manualPreviewURL!
        } else if song.spotify?.spotifyPreviewURL != nil && isAudioPlayable(urlString: song.spotify?.spotifyPreviewURL)  {
            prevurl = song.spotify!.spotifyPreviewURL
        } else if song.deezer?.previewURL != nil && isAudioPlayable(urlString: song.deezer?.previewURL) {
            guard let url = song.deezer?.previewURL else {fatalError()}
            prevurl = url
        } else if song.apple?.applePreviewURL != nil && isAudioPlayable(urlString: song.apple?.applePreviewURL) {
            guard let url = song.apple?.applePreviewURL else {fatalError()}
            prevurl = url
        } else {
            prevurl = ""
        }
        if prevurl == "" {
            completion(nil)
        } else {
            completion(prevurl)
        }
    }
    
    func selectPreviewURL(instrumental:InstrumentalData,completion: @escaping ((String?) -> Void)) {
        var prevurl = ""
        if instrumental.audioURL != nil && isAudioPlayable(urlString: instrumental.audioURL) {
            prevurl = instrumental.audioURL
        } else {
            prevurl = ""
        }
        if prevurl == "" {
            completion(nil)
        } else {
            completion(prevurl)
        }
    }
    
    func selectPreviewURL(album:AlbumData,completion: @escaping ((String?) -> Void)) {
        var prevurl = ""
        if album.manualPreviewURL != nil && isAudioPlayable(urlString: album.manualPreviewURL) {
            prevurl = album.manualPreviewURL!
        } else {
            prevurl = ""
        }
        if prevurl == "" {
            completion(nil)
        } else {
            completion(prevurl)
        }
    }
    
    func isAudioPlayable(urlString: String?) -> Bool {
        guard let url = URL(string: urlString!) else {
            return false
        }
        print(AVAsset(url: url).isPlayable,url)
        return AVAsset(url: url).isPlayable
    }
    
    func getPersonNames(person:String, completion: @escaping ((String?, Error?) -> Void)) {
        DatabaseManager.shared.fetchPersonData(person: person, completion: { result in
            switch result {
            case.success(let perso):
                completion(perso.name,nil)
            case.failure(let err):
                print("Error getting names for song: ", err)
                completion(nil,err)
            }
        })
    }
    
    func getPersonNames(arr:[String], completion: @escaping (([String]?, Error?) -> Void)) {
        var names:[String] = []
        var count = 0
        for art in arr {
            DatabaseManager.shared.fetchPersonData(person: art, completion: { result in
                switch result {
                case.success(let person):
                    count+=1
                    
                    names.append(person.name)
                    if count == arr.count {
                        completion(names,nil)
                    }
                case.failure(let err):
                    
                    print("Error getting names for song: ", err)
                    completion(nil,err)
                }
            })
        }
    }
    
//    func getSongYoutubeData(song:SongData, completion: @escaping (Array<YouTubeData>, Array<String>) -> Void) {
//        var videosData:Array<YouTubeData> = []
//        var youtubeimageURLs:Array<String> = []
//        var val = 1
//        if song.videos! == [""] || song.videos!.isEmpty {
//            completion(videosData, youtubeimageURLs)
//            return
//        }
//        for video in song.videos! {
//            let word = video.split(separator: "Æ")
//            let id = word[0]
//            print(id)
//            DatabaseManager.shared.findVideoById(videoid: String(id), completion: { selectedVideo in
//                switch selectedVideo {
//                case .success(let vid):
//
//                    if vid.youtube != nil {
//                        let video = vid.youtube![0]
//                        videosData.append(video)
//                        if video.thumbnailURL != "" {
//                            youtubeimageURLs.append(video.thumbnailURL)
//                        }
//                        if val == song.videos!.count {
//
//                            completion(videosData, youtubeimageURLs)
//                        }
//                        val+=1
//                    }
//                    else {
//                        if val == song.videos!.count {
//                            completion(videosData, youtubeimageURLs)
//                        }
//                        val+=1
//                    }
//
//                case .failure(let error):
//                    print("Video ID proccessing error \(error)")
//                    val+=1
//                }
//            })
//        }
//
//    }
    
    func getLowestPrice(apperal: MerchApperalData) -> (Double) {
        var lp:Double!
        var sizearr:[ApperalSizeData] = []
        if let s = apperal.xsmallSize {
            for sz in s {
                sizearr.append(sz)
            }
        }
        if let s = apperal.smallSize {
            for sz in s {
                sizearr.append(sz)
            }
        }
        if let s = apperal.mediumSize {
            for sz in s {
                sizearr.append(sz)
            }
        }
        if let s = apperal.largeSize {
            for sz in s {
                sizearr.append(sz)
            }
        }
        if let s = apperal.xlargeSize {
            for sz in s {
                sizearr.append(sz)
            }
        }
        if let s = apperal.xxlargeSize {
            for sz in s {
                sizearr.append(sz)
            }
        }
        if let s = apperal.xxxlargeSize {
            for sz in s {
                sizearr.append(sz)
            }
        }
        for sz in sizearr {
            if let low = lp {
                if let sale = sz.salePrice {
                    if sale < low {
                        lp = sale
                    }
                } else {
                    if sz.retailPrice < low {
                        lp = sz.retailPrice
                    }
                }
            }
            else {
                if let sale = sz.salePrice {
                    lp = sale
                } else {
                    lp = sz.retailPrice
                }
            }
        }
        return lp
    }
    
    func getLowestPrice(memorabilia: MerchMemorabiliaData) -> (Double) {
        var lp:Double!
        var colarr:[MemorabiliaColorData] = []
        if let c = memorabilia.colors {
            for col in c {
                colarr.append(col)
            }
        }
        for col in colarr {
            if let low = lp {
                if let sale = col.salePrice {
                    if sale < low {
                        lp = sale
                    }
                } else {
                    if col.retailPrice < low {
                        lp = col.retailPrice
                    }
                }
            }
            else {
                if let sale = col.salePrice {
                    lp = sale
                } else {
                    lp = col.retailPrice
                }
            }
        }
        return lp
    }
    
    func getAvailableColors(memorabilia: MerchMemorabiliaData) -> ([UIColor]) {
        var colorarr:[String] = []
        var colarr:[UIColor] = []
        if let s = memorabilia.colors {
            for sz in s {
                let co = sz.color
                colorarr.append(co)
            }
        }
        for color in colorarr {
            switch color {
            case "Multi-Color":
                let pc:UIColor = .alizarin
                if !colarr.contains(pc) {
                    colarr.append(pc)
                }
            case "Black":
                let pc:UIColor = .black
                if !colarr.contains(pc) {
                    colarr.append(pc)
                }
            case "White":
                let pc:UIColor = .white
                if !colarr.contains(pc) {
                    colarr.append(pc)
                }
            case "Charcoal":
                let pc:UIColor = Constants.Colors.mediumApp
                if !colarr.contains(pc) {
                    colarr.append(pc)
                }
            case "Dark Gray":
                let pc:UIColor = .darkGray
                if !colarr.contains(pc) {
                    colarr.append(pc)
                }
            case "Light Gray":
                let pc:UIColor = .lightGray
                if !colarr.contains(pc) {
                    colarr.append(pc)
                }
            case "Blue":
                let pc:UIColor = .blue
                if !colarr.contains(pc) {
                    colarr.append(pc)
                }
            case "Navy":
                let pc:UIColor = .midnightBlue
                if !colarr.contains(pc) {
                    colarr.append(pc)
                }
            case "Light Blue":
                let pc:UIColor = .cyan
                if !colarr.contains(pc) {
                    colarr.append(pc)
                }
            case "Red":
                let pc:UIColor = .red
                if !colarr.contains(pc) {
                    colarr.append(pc)
                }
            case "Maroon":
                let pc:UIColor = UIColor(red: 191/255, green: 0/255, blue: 0/255, alpha: 1.0)
                if !colarr.contains(pc) {
                    colarr.append(pc)
                }
            case "Yellow":
                let pc:UIColor = .yellow
                if !colarr.contains(pc) {
                    colarr.append(pc)
                }
            case "Orange":
                let pc:UIColor = .orange
                if !colarr.contains(pc) {
                    colarr.append(pc)
                }
            case "Green":
                let pc:UIColor = .green
                if !colarr.contains(pc) {
                    colarr.append(pc)
                }
            case "Olive":
                let pc:UIColor = UIColor(red: 71/255, green: 104/255, blue: 0/255, alpha: 1.0)
                if !colarr.contains(pc) {
                    colarr.append(pc)
                }
            case "Pink":
                let pc:UIColor = .systemPink
                if !colarr.contains(pc) {
                    colarr.append(pc)
                }
            case "Brown":
                let pc:UIColor = .brown
                if !colarr.contains(pc) {
                    colarr.append(pc)
                }
            case "Tan":
                let pc:UIColor = UIColor(red: 175/255, green: 139/255, blue: 61/255, alpha: 1.0)
                if !colarr.contains(pc) {
                    colarr.append(pc)
                }
            case "Cream":
                let pc:UIColor = UIColor(red: 201/255, green: 184/255, blue: 145/255, alpha: 1.0)
                if !colarr.contains(pc) {
                    colarr.append(pc)
                }
            default:
                print("err")
            }
        }
        return colarr
    }
    
    func getAvailableColors(apperal: MerchApperalData) -> ([UIColor]) {
        var colorarr:[String] = []
        var colarr:[UIColor] = []
        if let s = apperal.xsmallSize {
            for sz in s {
                let co = sz.color
                colorarr.append(co)
            }
        }
        if let s = apperal.smallSize {
            for sz in s {
                let co = sz.color
                colorarr.append(co)
            }
        }
        if let s = apperal.mediumSize {
            for sz in s {
                let co = sz.color
                colorarr.append(co)
            }
        }
        if let s = apperal.largeSize {
            for sz in s {
                let co = sz.color
                colorarr.append(co)
            }
        }
        if let s = apperal.xlargeSize {
            for sz in s {
                let co = sz.color
                colorarr.append(co)
            }
        }
        if let s = apperal.xxlargeSize {
            for sz in s {
                let co = sz.color
                colorarr.append(co)
            }
        }
        if let s = apperal.xxxlargeSize {
            for sz in s {
                let co = sz.color
                colorarr.append(co)
            }
        }
        for color in colorarr {
            switch color {
            case "Multi-Color":
                let pc:UIColor = .alizarin
                if !colarr.contains(pc) {
                    colarr.append(pc)
                }
            case "Black":
                let pc:UIColor = .black
                if !colarr.contains(pc) {
                    colarr.append(pc)
                }
            case "White":
                let pc:UIColor = .white
                if !colarr.contains(pc) {
                    colarr.append(pc)
                }
            case "Charcoal":
                let pc:UIColor = Constants.Colors.mediumApp
                if !colarr.contains(pc) {
                    colarr.append(pc)
                }
            case "Dark Gray":
                let pc:UIColor = .darkGray
                if !colarr.contains(pc) {
                    colarr.append(pc)
                }
            case "Light Gray":
                let pc:UIColor = .lightGray
                if !colarr.contains(pc) {
                    colarr.append(pc)
                }
            case "Blue":
                let pc:UIColor = .blue
                if !colarr.contains(pc) {
                    colarr.append(pc)
                }
            case "Navy":
                let pc:UIColor = .midnightBlue
                if !colarr.contains(pc) {
                    colarr.append(pc)
                }
            case "Light Blue":
                let pc:UIColor = .cyan
                if !colarr.contains(pc) {
                    colarr.append(pc)
                }
            case "Red":
                let pc:UIColor = .red
                if !colarr.contains(pc) {
                    colarr.append(pc)
                }
            case "Maroon":
                let pc:UIColor = UIColor(red: 191/255, green: 0/255, blue: 0/255, alpha: 1.0)
                if !colarr.contains(pc) {
                    colarr.append(pc)
                }
            case "Yellow":
                let pc:UIColor = .yellow
                if !colarr.contains(pc) {
                    colarr.append(pc)
                }
            case "Orange":
                let pc:UIColor = .orange
                if !colarr.contains(pc) {
                    colarr.append(pc)
                }
            case "Green":
                let pc:UIColor = .green
                if !colarr.contains(pc) {
                    colarr.append(pc)
                }
            case "Olive":
                let pc:UIColor = UIColor(red: 71/255, green: 104/255, blue: 0/255, alpha: 1.0)
                if !colarr.contains(pc) {
                    colarr.append(pc)
                }
            case "Pink":
                let pc:UIColor = .systemPink
                if !colarr.contains(pc) {
                    colarr.append(pc)
                }
            case "Brown":
                let pc:UIColor = .brown
                if !colarr.contains(pc) {
                    colarr.append(pc)
                }
            case "Tan":
                let pc:UIColor = UIColor(red: 175/255, green: 139/255, blue: 61/255, alpha: 1.0)
                if !colarr.contains(pc) {
                    colarr.append(pc)
                }
            case "Cream":
                let pc:UIColor = UIColor(red: 201/255, green: 184/255, blue: 145/255, alpha: 1.0)
                if !colarr.contains(pc) {
                    colarr.append(pc)
                }
            default:
                print("err")
            }
        }
        return colarr
    }
    
    func mergeArrays<T>(_ arrays:[T] ...) -> [T] {
      return (0..<arrays.map{$0.count}.max()!).flatMap{i in arrays.filter{i<$0.count}.map{$0[i]} }
    }
    
    func combine<T>(_ arrays: Array<T>?...) -> Set<T> {
        return arrays.compactMap{$0}.compactMap{Set($0)}.reduce(Set<T>()){$0.union($1)}
    }
    
    func verifyUrl (urlString: String?,completion: @escaping ((Bool) -> Void)) {
        if let urlString = urlString {
            if let url = NSURL(string: urlString) {
                if UIApplication.shared.canOpenURL(url as URL) == true {
                    vfyUrl(urlString: urlString, completion: { validity in
                        if validity {
                            completion(true)
                        } else {
                            completion(false)
                        }
                    })
                } else {
                    completion(false)
                }
            } else {
                completion(false)
            }
        } else {
            completion(false)
        }
    }
    
    func vfyUrl (urlString: String?,completion: @escaping ((Bool) -> Void)) {
        if let urlString = urlString {
            let url = URL(string: urlString)
            let task = URLSession.shared.dataTask(with: url!) { _, response, _ in
                if let httpResponse = response as? HTTPURLResponse {
                    if httpResponse.statusCode == 200 {
                        completion(true)
                    }
                    else {
                        completion(false)
                    }
                } else {
                    completion(false)
                }
            }
            task.resume()
        } else {
            completion(false)
        }
        
    }
    
}

extension Set {
    var array: [Element] {
        return Array(self)
    }
}

extension Dictionary {
    var jsonData: Data? {
        return try? JSONSerialization.data(withJSONObject: self, options: .prettyPrinted)
    }
    
    func toJSONObjectString() -> String? {
        if let jsonData = jsonData {
            return String(data: jsonData, encoding: .utf8)!
        }
        
        return nil
    }
}


