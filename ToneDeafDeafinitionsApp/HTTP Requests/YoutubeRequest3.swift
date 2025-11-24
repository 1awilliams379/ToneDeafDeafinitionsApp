//
//  YoutubeRequest3.swift
//  ToneDeafDeafinitionsApp
//
//  Created by Tone Deaf on 8/31/20.
//  Copyright © 2020 GITEM Solutions. All rights reserved.
//

import Foundation
import Alamofire
import FirebaseDatabase


public class YoutubeRequest3 {
    static let shared = YoutubeRequest3()
    
    let apiKey = "AIzaSyAG7HylHsbrK83y0hwRBgkSbvUMraKoMGU"
    
    var toneDeafAppId = ""
    var instrumentalAppId:Array<String> = []
    var albums:Array<String> = []
    var songName = ""
    var songPersonsInvolved:Array<String> = []
    var songProducers:Array<String> = []
    var songWriters:Array<String> = []
    var songMixEngineer:Array<String> = []
    var songMasteringEngineer:Array<String> = []
    var songRecordingEngineer:Array<String> = []
    
    
    var songEngineers:Array<String> = []
    var songArtistsNames:Array<String> = []
    var songArtistsIDs:Array<String> = []
    var songs:Array<String> = []
    var beats:[String] = []
    
    var title = ""
    var description = ""
    var channelTitle = ""
    var thumbnailURL = ""
    var currentDate = ""
    var currentTime = ""
    var duration = ""
    var dateYT = ""
    var timeYT = ""
    var viewsYT = 0
    var viewsIA = 0
    var favorites = 0
    
    func getVideos(url: String, videoId:String, name: String, artists: Array<String>, producers: Array<String>, writers: Array<String>, mixEngineer: Array<String>, masteringEngineer: Array<String>, recordingEngineer: Array<String>, tag: String, dateobj:Date, appid: String, vidAppId:String, completion: @escaping ((Bool, String?) -> Void)) {
        DispatchQueue.global().async { [weak self] in
            guard let strongSelf = self else {return}
            strongSelf.toneDeafAppId = appid
            let url = url
            strongSelf.songName = name
            strongSelf.songArtistsIDs = artists
            strongSelf.songProducers = producers
            let youtubeId = videoId
            strongSelf.songs = []
            
            let tdVideoAppId = vidAppId
            strongSelf.songs.append(appid)
            strongSelf.title = ""
            strongSelf.description = ""
            strongSelf.channelTitle = ""
            strongSelf.thumbnailURL = ""
            strongSelf.currentDate = ""
            strongSelf.currentTime = ""
            strongSelf.duration = ""
            strongSelf.dateYT = ""
            strongSelf.timeYT = ""
            strongSelf.viewsYT = 0
            strongSelf.viewsIA = 0
            strongSelf.favorites = 0
            strongSelf.albums = []
            strongSelf.instrumentalAppId = []
            
            let date = dateobj
            let formatter = DateFormatter()
            formatter.timeZone = TimeZone(identifier: "EDT")
            formatter.dateFormat = "MMMM dd, yyyy"
            strongSelf.currentDate = formatter.string(from: date)
            //print("📙 current date: \(currentDate)")
            
            let time = dateobj
            let timeFormatter = DateFormatter()
            timeFormatter.dateFormat = "HH:mm:ss a"
            timeFormatter.timeZone = TimeZone(identifier: "EDT")
            strongSelf.currentTime = timeFormatter.string(from: time)
            //print("📙 current time: \(currentTime)")
            
            let resourseString = "https://www.googleapis.com/youtube/v3/videos?part=snippet&part=statistics&part=contentDetails&part=status&id=\(videoId)&key=\(strongSelf.apiKey)"
            guard let resourceURL = URL(string: resourseString) else {fatalError()}
            AF.request(resourceURL, method: .get, parameters: ["part":"snippet", "key":strongSelf.apiKey], encoding: URLEncoding.default, headers: nil).responseJSON { response in
                if let status = response.response?.statusCode {
                    switch(status){
                    case 200:
                        print("example success")
                    default:
                        print("error with response status: \(status)")
                        return
                    }
                }
                do {
                    typealias JSONObject = [String:AnyObject]
                    if let jsonResult = try JSONSerialization.jsonObject(with: response.data!, options: JSONSerialization.ReadingOptions.allowFragments) as? [String : AnyObject] {
                        //print("Response from YouTube: \(jsonResult)")
                         let items  = jsonResult["items"] as! Array<JSONObject>
                        for i in 0 ..< items.count {

                             let snippetDictionary = items[i]["snippet"] as! JSONObject
                            let statisticsDictionary = items[i]["statistics"] as! JSONObject
                            let contentDetailsDictionary = items[i]["contentDetails"] as! JSONObject
                             //print(snippetDictionary)
                            let unflilteredTitle = (snippetDictionary["title"] as! String)
                            strongSelf.title = unflilteredTitle
                            strongSelf.channelTitle = snippetDictionary["channelTitle"] as! String
                            if (snippetDictionary["thumbnails"] as! JSONObject)["maxres"] != nil {
                                strongSelf.thumbnailURL = ((snippetDictionary["thumbnails"] as! JSONObject)["maxres"] as! JSONObject)["url"] as! String
                            } else if (snippetDictionary["thumbnails"] as! JSONObject)["high"] != nil {
                                strongSelf.thumbnailURL = ((snippetDictionary["thumbnails"] as! JSONObject)["high"] as! JSONObject)["url"] as! String
                            } else {
                                strongSelf.thumbnailURL = ((snippetDictionary["thumbnails"] as! JSONObject)["default"] as! JSONObject)["url"] as! String
                            }
                            strongSelf.description = snippetDictionary["description"] as! String
                            
                            let unparsedDuration = contentDetailsDictionary["duration"] as! String
                            var parsedDuration = String(unparsedDuration.filter("0123456789".contains))
                            if parsedDuration.count == 1 {
                                parsedDuration.insert(contentsOf: "00", at: parsedDuration.startIndex)
                            }
                            parsedDuration.insert(":", at: parsedDuration.index(parsedDuration.endIndex, offsetBy: -2))
                            if parsedDuration.count == 4 {
                                parsedDuration.insert("0", at: parsedDuration.startIndex)
                            }
                            if parsedDuration.count > 5 {
                                parsedDuration.insert(":", at: parsedDuration.index(parsedDuration.endIndex, offsetBy: -5))
                            }
                            strongSelf.duration = parsedDuration
                            
                            let ytDateTime = snippetDictionary["publishedAt"] as! String
                            let parsedDate = ytDateTime.prefix(10)
                            let words = parsedDate.split(separator: "-")
                            let parsedYear = words[0]
                            let parsedMonth = words[1].replacingOccurrences(of: "08", with: "August").replacingOccurrences(of: "01", with: "January").replacingOccurrences(of: "02", with: "February").replacingOccurrences(of: "03", with: "March").replacingOccurrences(of: "04", with: "April").replacingOccurrences(of: "05", with: "May").replacingOccurrences(of: "06", with: "June").replacingOccurrences(of: "07", with: "July").replacingOccurrences(of: "09", with: "September").replacingOccurrences(of: "10", with: "October").replacingOccurrences(of: "11", with: "November").replacingOccurrences(of: "12", with: "December")
                            let parsedDay = words[2]
                            strongSelf.dateYT = "\(parsedMonth) \(parsedDay), \(parsedYear)"
                            
                            strongSelf.timeYT = String(ytDateTime.suffix(9).dropLast())
                            
                            let stringViewsYT = statisticsDictionary["viewCount"] as! String
                            strongSelf.viewsYT = Int(stringViewsYT) ?? 0
                            
                            
                            //let video = YouTubeData(duration: strongSelf.duration,url: url, title: strongSelf.title, dateYT: strongSelf.dateYT, dateIA: strongSelf.currentDate, timeYT: strongSelf.timeYT, timeIA: strongSelf.currentTime, description: strongSelf.description, thumbnailURL: strongSelf.thumbnailURL, channelTitle: strongSelf.channelTitle, viewsYT: Int(strongSelf.viewsYT), viewsIA: strongSelf.viewsIA, favorites: strongSelf.favorites)

                            //print(video.title, video.channelTitle, video.dateYT, video.description, video.duration, video.thumbnailURL, video.url, video.viewsYT)
                            
                            strongSelf.saveVideoSongInfoToDatabase(url: url, youtubeID: youtubeId, tdVideoAppId: tdVideoAppId, tag: tag, completion: { done in
                                guard done == true else {
                                    completion(false, nil)
                                    return
                                }
                                completion(true, strongSelf.title)
                                return
                            })
                        }

                    }
                }
                catch {
                    print("json error: \(error)")
                    completion(false, nil)
                    return
                }
            }
        }
        
    }
    
    typealias YoutubeHTTPCompletion = (Result<YouTubeData, Error>) -> Void
    func getVideos(videoId: String, url: String, tdAppId:String, completion: @escaping YoutubeHTTPCompletion) {
        DispatchQueue.global().async { [weak self] in
            guard let strongSelf = self else {return}
            let video = YouTubeData(duration: "", url: "", title: "", dateYT: "", dateIA: "", timeYT: "", timeIA: "", description: "", thumbnailURL: "", channelTitle: "", viewsYT: 0, viewsIA: 0, toneDeafAppId: "", youtubeId: "", type: "", isActive: false)
            let resourseString = "https://www.googleapis.com/youtube/v3/videos?part=snippet&part=statistics&part=contentDetails&part=status&id=\(videoId)&key=\(strongSelf.apiKey)"
            guard let resourceURL = URL(string: resourseString) else {fatalError()}
            AF.request(resourceURL, method: .get, parameters: ["part":"snippet", "key":strongSelf.apiKey], encoding: URLEncoding.default, headers: nil).responseJSON { response in
                if let status = response.response?.statusCode {
                    switch(status){
                    case 200:
                        print("example success")
                    default:
                        print("error with response status: \(status)")
                        return
                    }
                }
                do {
                    typealias JSONObject = [String:AnyObject]
                    if let jsonResult = try JSONSerialization.jsonObject(with: response.data!, options: JSONSerialization.ReadingOptions.allowFragments) as? [String : AnyObject] {
                        
                        print("Response from YouTube: \(jsonResult)")
                        guard let items  = jsonResult["items"] as? Array<JSONObject> else {
                            completion(.failure(YoutubeRequestErrors.status400))
                            return
                        }
                        for i in 0 ..< items.count {

                             let snippetDictionary = items[i]["snippet"] as! JSONObject
                            let statisticsDictionary = items[i]["statistics"] as! JSONObject
                            let contentDetailsDictionary = items[i]["contentDetails"] as! JSONObject
                             //print(snippetDictionary)
                            let unflilteredTitle = (snippetDictionary["title"] as! String)
                            video.title = unflilteredTitle
                            video.channelTitle = snippetDictionary["channelTitle"] as! String
                            if (snippetDictionary["thumbnails"] as! JSONObject)["maxres"] != nil {
                                video.thumbnailURL = ((snippetDictionary["thumbnails"] as! JSONObject)["maxres"] as! JSONObject)["url"] as! String
                            } else if (snippetDictionary["thumbnails"] as! JSONObject)["high"] != nil {
                                video.thumbnailURL = ((snippetDictionary["thumbnails"] as! JSONObject)["high"] as! JSONObject)["url"] as! String
                            } else {
                                video.thumbnailURL = ((snippetDictionary["thumbnails"] as! JSONObject)["default"] as! JSONObject)["url"] as! String
                            }
                            video.description = snippetDictionary["description"] as! String
                            
                            let unparsedDuration = contentDetailsDictionary["duration"] as! String
                            var parsedDuration = String(unparsedDuration.filter("0123456789".contains))
                            if parsedDuration.count == 1 {
                                parsedDuration.insert(contentsOf: "00", at: parsedDuration.startIndex)
                            }
                            parsedDuration.insert(":", at: parsedDuration.index(parsedDuration.endIndex, offsetBy: -2))
                            if parsedDuration.count == 4 {
                                parsedDuration.insert("0", at: parsedDuration.startIndex)
                            }
                            if parsedDuration.count > 5 {
                                parsedDuration.insert(":", at: parsedDuration.index(parsedDuration.endIndex, offsetBy: -5))
                            }
                            video.duration = parsedDuration
                            
                            let ytDateTime = snippetDictionary["publishedAt"] as! String
                            let parsedDate = ytDateTime.prefix(10)
                            let words = parsedDate.split(separator: "-")
                            let parsedYear = words[0]
                            let parsedMonth = words[1].replacingOccurrences(of: "08", with: "August").replacingOccurrences(of: "01", with: "January").replacingOccurrences(of: "02", with: "February").replacingOccurrences(of: "03", with: "March").replacingOccurrences(of: "04", with: "April").replacingOccurrences(of: "05", with: "May").replacingOccurrences(of: "06", with: "June").replacingOccurrences(of: "07", with: "July").replacingOccurrences(of: "09", with: "September").replacingOccurrences(of: "10", with: "October").replacingOccurrences(of: "11", with: "November").replacingOccurrences(of: "12", with: "December")
                            let parsedDay = words[2]
                            video.dateYT = "\(parsedMonth) \(parsedDay), \(parsedYear)"
                            
                            video.timeYT = String(ytDateTime.suffix(9).dropLast())
                            
                            let stringViewsYT = statisticsDictionary["viewCount"] as! String
                            video.viewsYT = Int(stringViewsYT) ?? 0
                            video.toneDeafAppId = tdAppId
                            video.url = url
                            video.youtubeId = videoId
                            //let video = YouTubeData(duration: strongSelf.duration,url: url, title: strongSelf.title, dateYT: strongSelf.dateYT, dateIA: strongSelf.currentDate, timeYT: strongSelf.timeYT, timeIA: strongSelf.currentTime, description: strongSelf.description, thumbnailURL: strongSelf.thumbnailURL, channelTitle: strongSelf.channelTitle, viewsYT: Int(strongSelf.viewsYT), viewsIA: strongSelf.viewsIA, favorites: strongSelf.favorites)

                            //print(video.title, video.channelTitle, video.dateYT, video.description, video.duration, video.thumbnailURL, video.url, video.viewsYT)
                            completion(.success(video))
                            
                        }

                    }
                }
                catch {
                    print("json error: \(error)")
                    completion(.failure(error))
                    return
                }
            }
        }
        
    }
    
    func saveVideoSongInfoToDatabase(url: String, youtubeID:String, tdVideoAppId: String, tag: String, completion: @escaping ((Bool) -> Void)) {
        getArtistData(artistids: songArtistsIDs, completion: {[weak self] artistNames in
            guard let strongSelf = self else {return}
            strongSelf.songArtistsNames = artistNames
            let videoDBKey = ("\(videoContentTag)--\(strongSelf.title.replacingOccurrences(of: ".", with: " ").replacingOccurrences(of: "#", with: " ").replacingOccurrences(of: "$", with: " ").replacingOccurrences(of: "[", with: " ").replacingOccurrences(of: "]", with: " ").replacingOccurrences(of: ":", with: " "))--\(tdVideoAppId)")
            var youtubeContentRandomKey = ""
            var vidType = ""
            switch tag {
            case youtubeVideoContentTyp:
                vidType = youtubeVideoContentTyp
                youtubeContentRandomKey = ("\(youtubeVideoContentTyp)--\(strongSelf.title.replacingOccurrences(of: ".", with: " ").replacingOccurrences(of: "#", with: " ").replacingOccurrences(of: "$", with: " ").replacingOccurrences(of: "[", with: " ").replacingOccurrences(of: "]", with: " ").replacingOccurrences(of: ":", with: " "))--\(tdVideoAppId)")
            case youtubeAudioVideoContentType:
                vidType = youtubeAudioVideoContentType
                youtubeContentRandomKey = ("\(youtubeAudioVideoContentType)--\(strongSelf.title.replacingOccurrences(of: ".", with: " ").replacingOccurrences(of: "#", with: " ").replacingOccurrences(of: "$", with: " ").replacingOccurrences(of: "[", with: " ").replacingOccurrences(of: "]", with: " ").replacingOccurrences(of: ":", with: " "))--\(tdVideoAppId)")
            case youtubeAltVideoContentType:
                vidType = youtubeAltVideoContentType
                youtubeContentRandomKey = ("\(youtubeAltVideoContentType)--\(strongSelf.title.replacingOccurrences(of: ".", with: " ").replacingOccurrences(of: "#", with: " ").replacingOccurrences(of: "$", with: " ").replacingOccurrences(of: "[", with: " ").replacingOccurrences(of: "]", with: " ").replacingOccurrences(of: ":", with: " "))--\(tdVideoAppId)")
            default:
                print("Error identifying content type")
                completion(false)
                return
            }
            let categorty = "\(songContentTag)--\(strongSelf.songName)--\(strongSelf.toneDeafAppId)"
            
            
            
            let videorRef = Database.database().reference().child("Music Content").child("Songs").child(categorty).child("Videos").child(vidType).child("id")
            switch vidType {
            case youtubeVideoContentTyp:
                videorRef.setValue("\(tdVideoAppId)")
            case youtubeAudioVideoContentType:
                videorRef.setValue("\(tdVideoAppId)")
            default:
                strongSelf.getAltVideosFromSongInDB(cat: categorty, vidType: vidType, completion: { vids in
                    var myVidsArray:[String] = vids
                    //print(myVidsArray)
                    myVidsArray.append("\(tdVideoAppId)")
                    videorRef.setValue(myVidsArray)
                    
                })
            }
            
            var RequiredInfoMap = [String : Any]()
            RequiredInfoMap = [
                "Tone Deaf App Id" : strongSelf.toneDeafAppId,
                "Name" : strongSelf.songName,
                "Artist" : strongSelf.songArtistsIDs,
                "Producers" : strongSelf.songProducers,
                "Writers": strongSelf.songWriters,
                "Engineers": [
                    "Mix Engineer": strongSelf.songMixEngineer,
                    "Mastering Engineer": strongSelf.songMasteringEngineer,
                    "Recording Engineer": strongSelf.songRecordingEngineer
                ],
                "Number of Favorites Overall" : 0,
                "Instrumentals": strongSelf.instrumentalAppId,
                "Albums" : strongSelf.albums,
                "Active Status": false]
            
            let RequiredRef = Database.database().reference().child("Music Content").child("Songs").child(categorty).child("REQUIRED")
            RequiredRef.updateChildValues(RequiredInfoMap) { [weak self] (error, songRef) in
                guard let strongSelf = self else {return}
                if let error = error {
                    print("📕 Failed to required video upload dictionary to database: \(error)")
                    completion(false)
                    return
                }
            }
            
            let persons:[String] = Array(GlobalFunctions.shared.combine(strongSelf.songArtistsIDs,strongSelf.songProducers,strongSelf.songWriters,strongSelf.songEngineers))
            
            var VideoInfoMap = [String : Any]()
            VideoInfoMap = [
            "Title" : strongSelf.title,
            "Tone Deaf App Video Id": tdVideoAppId,
            "Time Uploaded To App" : strongSelf.currentTime,
            "Date Uploaded To App" : strongSelf.currentDate,
            "Views In App" : strongSelf.viewsIA,
            "Number of Favorites" : strongSelf.favorites,
            "Albums" : strongSelf.albums,
            "Persons" : persons,
            "Beats" : strongSelf.beats,
            "Instrumentals": strongSelf.instrumentalAppId,
            "Songs": ["\(strongSelf.toneDeafAppId)"],
            "Active Status": false
            ]
            
            let videoRef = Database.database().reference().child("Music Content").child("Videos").child(videoDBKey)
            videoRef.child("Songs").setValue(strongSelf.songs)
            
            videoRef.updateChildValues(VideoInfoMap) { [weak self] (error, videoRef) in
                guard let strongSelf = self else {return}
                if let error = error {
                    print("📕 Failed to upload youtube video dictionary to database: \(error)")
                    completion(false)
                    return
                }
            }
            
            var yTVideoInfoMap = [String : Any]()
            yTVideoInfoMap = [
            "Title" : strongSelf.title,
            "Tone Deaf App Video Id": tdVideoAppId,
            "Date Uploaded To Youtube" : strongSelf.dateYT,
            "Time Uploaded To Youtube" : strongSelf.timeYT,
            "Time Uploaded To App" : strongSelf.currentTime,
            "Date Uploaded To App" : strongSelf.currentDate,
            "Channel Title" : strongSelf.channelTitle,
            "Description" : strongSelf.description,
            "Duration" : strongSelf.duration,
            "Thumbnail URL" : strongSelf.thumbnailURL,
            "Video URL" : url,
            "Views on Youtube" : strongSelf.viewsYT,
            "Views In App" : strongSelf.viewsIA,
            "Youtube Id" : youtubeID,
            "Type": "YTVD",
            "Active Status": false]
            
            let yTvideoRef = Database.database().reference().child("Music Content").child("Videos").child(videoDBKey).child("Youtube").child(youtubeContentRandomKey)
            yTvideoRef.child("Songs").setValue(strongSelf.songs)
            
            yTvideoRef.updateChildValues(yTVideoInfoMap) { [weak self] (error, videoRef) in
                guard let strongSelf = self else {return}
                if let error = error {
                    print("📕 Failed to upload youtube video dictionary to database: \(error)")
                    completion(false)
                    return
                } else {
                    completion(true)
                    print("📗 Youtube \(tag) data for \(strongSelf.songName) saved to database successfully.")
                    return
                }
            }
        })
        
}
    func getArtistData(artistids:[String], completion: @escaping (Array<String>) -> Void) {
        var artistNameData:Array<String> = []
        var val = 1
        for artist in artistids {
            DatabaseManager.shared.fetchPersonData(person: artist.trimmingCharacters(in: .whitespacesAndNewlines), completion: { result in
                switch result {
                case .success(let selectedArtist):
                    artistNameData.append(selectedArtist.name!)
                    if val == artistids.count {
                        completion(artistNameData)
                    }
                    val+=1
                case .failure(let err):
                    print("youyouerr", err)
                }
            })
        }
        
    }
    
//    func getVideosFromSongInDB(cat: String, completion: @escaping (Array<String>) -> Void) {
//        let vids = Database.database().reference().child("Music Content").child("Songs").child(cat)
//        vids.observeSingleEvent(of: .value, with: { snapshot in
//            var myVidsArray:[String] = []
//            var tick = 0
//            if snapshot.childrenCount == 0 {
//                completion(myVidsArray)
//            }
//            for child in snapshot.children {
//                tick+=1
//                let cat = child as! DataSnapshot
//                let key = cat.key
//                print(cat)
//                
//                if key.contains(youtubeVideoContentTyp) || key.contains(youtubeAudioVideoContentType) {
//                    let value = cat.value as! [String:Any]
//                    myVidsArray.append(value["id"] as! String)
//                }
//                if key.contains(youtubeAltVideoContentType) {
//                    let value = cat.value as! [String:Any]
//                    //print(value)
//                    myVidsArray.append(contentsOf: value["id"] as! [String])
//                }
//                if tick == snapshot.childrenCount {
//                    
//                    completion(myVidsArray)
//                }
//            }
//        })
//    }
    
    func getAltVideosFromSongInDB(cat: String, vidType:String, completion: @escaping (Array<String>) -> Void) {
        let vids = Database.database().reference().child("Music Content").child("Songs").child(cat).child(vidType).child("id")
        vids.observeSingleEvent(of: .value, with: { snapshot in
            var myVidsArray:[String] = []
            var tick = 0
            //print(tick)
            if snapshot.childrenCount == 0 {
                completion(myVidsArray)
            }
            for child in snapshot.children {
                tick+=1
                let snap = child as! DataSnapshot
                let vid = snap.value as! String
                if vid != "" {
                    myVidsArray.append(vid)
                }
                if tick == snapshot.childrenCount {
                    completion(myVidsArray)
                }
            }
        })
    }
}
