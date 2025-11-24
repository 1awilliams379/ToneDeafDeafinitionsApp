//
//  Deezer Request.swift
//  ToneDeafDeafinitionsApp
//
//  Created by Tone Deaf on 6/25/22.
//  Copyright © 2022 GITEM Solutions. All rights reserved.
//

import Foundation
import Alamofire
import FirebaseDatabase

class DeezerRequest {
    
    var accessToken = "frtxaFIaLgjEg3gg06p5Ryleke7rJHfJOxoRYhs8miJhbOh0xX"
    
    static let shared = DeezerRequest()
    
    var toneDeafAppId = ""
    var instrumentals:[String] = []
    var albums:[String] = []
    var beats:[String] = []
    var songArtistsIDs:Array<String> = []
    var songArtistsNames:Array<String> = []
    var songPersonsInvolved:Array<String> = []
    var songProducers:Array<String> = []
    var songWriters:Array<String> = []
    var songMixEngineer:Array<String> = []
    var songMasteringEngineer:Array<String> = []
    var songRecordingEngineer:Array<String> = []
    
    
    var songEngineers:Array<String> = []
    
    var personName = ""
    var personLegal:String?
    var altPersonName:Array<String> = []
    var role:String = ""
    
    var songId:Int!
    var songURL:String!
    var songISRC:String!
    var songPreviewURL:String!
    var songDateDeezer:String!
    var songName:String!
    var songNameDeezer:String!
    var songImageURL:String!
    var songDuration:String!
    var songArtist:[[String:Any]]!
    var dateArtistRegisteredToApp:String!
    var timeArtistRegisteredToApp:String!
    
    var verificationLevel:Character!
    var industryCertification:Bool!
    var explicit:Bool!
    
    func getSongInfo(id: String, name: String, artists: Array<String>, producers: Array<String>, writers: Array<String>, mixEngineer: Array<String>, masteringEngineer: Array<String>, recordingEngineer: Array<String>, dateobj:Date, appid: String, instsongid: String, instrContentRandomKey: String, certifi:Bool?, verifi:Character, explicit:Bool, completion: @escaping ((Bool) -> Void)) {
        
        DispatchQueue.global().async { [weak self] in
            guard let strongSelf = self else {return}
            strongSelf.toneDeafAppId = appid
            strongSelf.songName = name
            strongSelf.songArtistsIDs = artists
            strongSelf.songProducers = producers
            strongSelf.songWriters = writers
            strongSelf.songMixEngineer = mixEngineer
            strongSelf.songMasteringEngineer = masteringEngineer
            strongSelf.songRecordingEngineer = recordingEngineer
            strongSelf.songURL = nil
            strongSelf.songName = name
            strongSelf.songISRC = nil
            strongSelf.songArtist = nil
            strongSelf.songImageURL = nil
            strongSelf.songDateDeezer = nil
            strongSelf.songPreviewURL = nil
            strongSelf.songArtistsNames = []
            strongSelf.songId = nil
            strongSelf.dateArtistRegisteredToApp = nil
            strongSelf.timeArtistRegisteredToApp = nil
            strongSelf.role = ""
            strongSelf.songDuration = nil
            strongSelf.songArtist = []
            strongSelf.albums = []
            strongSelf.beats = []
            strongSelf.industryCertification = certifi
            strongSelf.verificationLevel = verifi
            strongSelf.explicit = explicit
            
            strongSelf.songEngineers = GlobalFunctions.shared.mergeArrays(strongSelf.songMixEngineer,strongSelf.songMasteringEngineer,strongSelf.songRecordingEngineer)
            strongSelf.songPersonsInvolved = GlobalFunctions.shared.mergeArrays(artists,producers,writers,mixEngineer,masteringEngineer,recordingEngineer)
            
            let resourceURL = "https://api.deezer.com/track/\(id)"
            let parameters = ["access_token": strongSelf.accessToken]
            AF.request(resourceURL, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseJSON {[weak self] response in
                guard let strongSelf = self else {return}
                if let status = response.response?.statusCode {
                    switch(status){
                    case 200:
                        print("example success")
                        print(response.result)
                        print(response.data)
                    default:
                        print("error with response status: \(status)")
                        print(response.response.value)
                    }
                }
                do {
                    typealias JSONObject = [[String:AnyObject]]
                    if let jsonResult = try JSONSerialization.jsonObject(with: response.data!, options: JSONSerialization.ReadingOptions.allowFragments) as? [String : AnyObject] {
                        print("Response from Deezer: \(jsonResult)")
                        strongSelf.songId = (jsonResult["id"] as! Int)
                        strongSelf.songURL = (jsonResult["link"] as! String)
                        strongSelf.songISRC = (jsonResult["isrc"] as! String)
                        strongSelf.songPreviewURL = (jsonResult["preview"] as! String)
                        strongSelf.songNameDeezer = (jsonResult["title"] as! String)
                        
                        let pic = jsonResult["album"] as! NSDictionary
                        strongSelf.songImageURL = (pic["cover"] as! String)
                        
                        let unpardate = pic["release_date"] as! String
                        let words = unpardate.split(separator: "-")
                        let parsedYear = words[0]
                        let parsedMonth = words[1].replacingOccurrences(of: "08", with: "August").replacingOccurrences(of: "01", with: "January").replacingOccurrences(of: "02", with: "February").replacingOccurrences(of: "03", with: "March").replacingOccurrences(of: "04", with: "April").replacingOccurrences(of: "05", with: "May").replacingOccurrences(of: "06", with: "June").replacingOccurrences(of: "07", with: "July").replacingOccurrences(of: "09", with: "September").replacingOccurrences(of: "10", with: "October").replacingOccurrences(of: "11", with: "November").replacingOccurrences(of: "12", with: "December")
                        let parsedDay = words[2]
                        strongSelf.songDateDeezer = "\(parsedMonth) \(parsedDay), \(parsedYear)"
                        
                        let cont = jsonResult["contributors"] as! [NSDictionary]
                        for art in cont {
                            var artist:[String:Any] = [:]
                            artist = [
                                "id": art["id"]!,
                                "name": art["name"]!,
                                "url": art["link"]!,
                                "imageURL": art["picture"]!,
                                "role": art["role"]!
                            ]
                            strongSelf.songArtist.append(artist as [String : Any])
                        }
                        let durationInSeconds = jsonResult["duration"] as! Int
                        let durationInSecondsRound = Int(roundf(Float(durationInSeconds))/1)
                        let durationInMinues = strongSelf.timeFormatted(totalSeconds: durationInSecondsRound)
                        strongSelf.songDuration = durationInMinues
                        
                        let date = dateobj
                        let formatter = DateFormatter()
                        formatter.timeZone = TimeZone(identifier: "EDT")
                        formatter.dateFormat = "MMMM dd, yyyy"
                        strongSelf.dateArtistRegisteredToApp = formatter.string(from: date)
                        //print("📙 current date: \(currentDate)")
                        
                        let time = dateobj
                        let timeFormatter = DateFormatter()
                        timeFormatter.dateFormat = "HH:mm:ss a"
                        timeFormatter.timeZone = TimeZone(identifier: "EDT")
                        strongSelf.timeArtistRegisteredToApp = timeFormatter.string(from: time)
                        
                        if instsongid != "" {
                            strongSelf.saveInstrumentalInfoToDatabase(instrContentRandomKey: instrContentRandomKey, completion: { done in
                                guard done == true else {
                                    completion(false)
                                    return
                                }
                                completion(true)
                                return
                            })
                        } else {
                            strongSelf.saveSongInfoToDatabase(completion: { done in
                                guard done == true else {
                                    completion(false)
                                    return
                                }
                                completion(true)
                                return
                            })
                        }
                        
                    }
                } catch {
                    print("whoops")
                }
            }
        }
    }
    
    typealias DeezerTrackCompletion = (Result<DeezerSongData, Error>) -> Void
    func getDeezerSong(id: String, completion: @escaping DeezerTrackCompletion) {
        DispatchQueue.global().async { [weak self] in
            guard let strongSelf = self else {return}
            let resourceURL = "https://api.deezer.com/track/\(id)"
            let parameters = ["access_token": strongSelf.accessToken]
            AF.request(resourceURL, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseJSON {[weak self] response in
                guard let strongSelf = self else {return}
                if let status = response.response?.statusCode {
                    switch(status){
                    case 200:
                        print("example success")
                        //                    print(response.result)
                    //                    print(response.data)
                    case 400:
                        print("error with response status: \(status)")
                        print(response.response.value)
                        completion(.failure(DeezerMultipleTrackErrors.status400))
                        return
                    case 401:
                        print("error with response status: \(status)")
                        print(response.response.value)
                        completion(.failure(DeezerMultipleTrackErrors.status400))
                        return
                    case 404:
                        print("error with response status: \(status)")
                        print(response.response.value)
                        completion(.failure(DeezerMultipleTrackErrors.status400))
                        return
                    case 405:
                        print("error with response status: \(status)")
                        print(response.response.value)
                        completion(.failure(DeezerMultipleTrackErrors.status400))
                        return
                    default:
                        print("error with response status: \(status)")
                        print(response.response.value)
                        completion(.failure(DeezerMultipleTrackErrors.status400))
                        return
                    }
                }
                do {
                    typealias JSONObject = [String:AnyObject]
                    if let jsonResult = try JSONSerialization.jsonObject(with: response.data!, options: JSONSerialization.ReadingOptions.allowFragments) as? [String : AnyObject] {
                            let song = DeezerSongData(url: "", imageurl: nil, deezerDate: nil, artist: [], duration: nil, isrc: nil, name: nil, previewURL: nil, timeIA: nil, dateIA: nil, deezerID: nil, isActive: false)
                            song.deezerID = (jsonResult["id"] as! Int)
                            song.url = (jsonResult["link"] as! String)
                            song.isrc = (jsonResult["isrc"] as! String)
                            song.previewURL = (jsonResult["preview"] as! String)
                            song.name = (jsonResult["title"] as! String)
                            let pic = jsonResult["album"] as! NSDictionary
                            song.imageurl = (pic["cover"] as! String)
                            
                            let unpardate = pic["release_date"] as! String
                            let words = unpardate.split(separator: "-")
                            let parsedYear = words[0]
                            let parsedMonth = words[1].replacingOccurrences(of: "08", with: "August").replacingOccurrences(of: "01", with: "January").replacingOccurrences(of: "02", with: "February").replacingOccurrences(of: "03", with: "March").replacingOccurrences(of: "04", with: "April").replacingOccurrences(of: "05", with: "May").replacingOccurrences(of: "06", with: "June").replacingOccurrences(of: "07", with: "July").replacingOccurrences(of: "09", with: "September").replacingOccurrences(of: "10", with: "October").replacingOccurrences(of: "11", with: "November").replacingOccurrences(of: "12", with: "December")
                            let parsedDay = words[2]
                            song.deezerDate = "\(parsedMonth) \(parsedDay), \(parsedYear)"
                        
                        let cont = jsonResult["contributors"] as! [NSDictionary]
                        for art in cont {
                            var artist:[String:Any] = [:]
                            artist = [
                                "id": art["id"]!,
                                "name": art["name"]!,
                                "url": art["link"]!,
                                "imageURL": art["picture"]!,
                                "role": art["role"]!
                            ]
                            song.artist.append(artist as [String : Any])
                        }
                        let durationInSeconds = jsonResult["duration"] as! Int
                        let durationInSecondsRound = Int(roundf(Float(durationInSeconds))/1)
                        let durationInMinues = strongSelf.timeFormatted(totalSeconds: durationInSecondsRound)
                        song.duration = durationInMinues
                        
                        let date = Date()
                        let formatter = DateFormatter()
                        formatter.timeZone = TimeZone(identifier: "EDT")
                        formatter.dateFormat = "MMMM dd, yyyy"
                        song.dateIA = formatter.string(from: date)
                        //print("📙 current date: \(currentDate)")
                        
                        let time = Date()
                        let timeFormatter = DateFormatter()
                        timeFormatter.dateFormat = "HH:mm:ss a"
                        timeFormatter.timeZone = TimeZone(identifier: "EDT")
                        song.timeIA = timeFormatter.string(from: time)
                        completion(.success(song))
                }
                } catch {
                    completion(.failure(error))
                    return
                }
            }
        }
        //print("Im not supposed to be here")
    }
    
    typealias DeezerAlbumCompletion = (Result<DeezerAlbumData, Error>) -> Void
    func getDeezerAlbum(id: String, completion: @escaping DeezerAlbumCompletion) {
        DispatchQueue.global().async { [weak self] in
            guard let strongSelf = self else {return}
            let resourceURL = "https://api.deezer.com/album/\(id)"
            let parameters = ["access_token": strongSelf.accessToken]
            AF.request(resourceURL, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseJSON {[weak self] response in
                guard let strongSelf = self else {return}
                if let status = response.response?.statusCode {
                    switch(status){
                    case 200:
                        print("example success")
                        //                    print(response.result)
                    //                    print(response.data)
                    case 400:
                        print("error with response status: \(status)")
                        print(response.response.value)
                        completion(.failure(DeezerMultipleTrackErrors.status400))
                        return
                    case 401:
                        print("error with response status: \(status)")
                        print(response.response.value)
                        completion(.failure(DeezerMultipleTrackErrors.status400))
                        return
                    case 404:
                        print("error with response status: \(status)")
                        print(response.response.value)
                        completion(.failure(DeezerMultipleTrackErrors.status400))
                        return
                    case 405:
                        print("error with response status: \(status)")
                        print(response.response.value)
                        completion(.failure(DeezerMultipleTrackErrors.status400))
                        return
                    default:
                        print("error with response status: \(status)")
                        print(response.response.value)
                        completion(.failure(DeezerMultipleTrackErrors.status400))
                        return
                    }
                }
                do {
                typealias JSONObject = [String:AnyObject]
                if let jsonResult = try JSONSerialization.jsonObject(with: response.data!, options: JSONSerialization.ReadingOptions.allowFragments) as? [String : AnyObject] {
                    //print("Response from Apple: \(jsonResult)")
                    
                    print("Response from Deezer: \(jsonResult)")
                    
                    let album = DeezerAlbumData(url: "", imageurl: nil, deezerDate: "", artist: [], duration: "", upc: "", name: "", timeIA: "", dateIA: "", deezerID: 0, isActive: false)
                    album.deezerID = (jsonResult["id"] as! Int)
                    album.url = (jsonResult["link"] as! String)
                    album.upc = (jsonResult["upc"] as! String)
                    album.name = (jsonResult["title"] as! String)
                    album.imageurl = (jsonResult["cover"] as! String)
                    
                    let unpardate = jsonResult["release_date"] as! String
                    let words = unpardate.split(separator: "-")
                    let parsedYear = words[0]
                    let parsedMonth = words[1].replacingOccurrences(of: "08", with: "August").replacingOccurrences(of: "01", with: "January").replacingOccurrences(of: "02", with: "February").replacingOccurrences(of: "03", with: "March").replacingOccurrences(of: "04", with: "April").replacingOccurrences(of: "05", with: "May").replacingOccurrences(of: "06", with: "June").replacingOccurrences(of: "07", with: "July").replacingOccurrences(of: "09", with: "September").replacingOccurrences(of: "10", with: "October").replacingOccurrences(of: "11", with: "November").replacingOccurrences(of: "12", with: "December")
                    let parsedDay = words[2]
                    album.deezerDate = "\(parsedMonth) \(parsedDay), \(parsedYear)"
                    
                    let cont = jsonResult["contributors"] as! [NSDictionary]
                    for art in cont {
                        var artist:[String:Any] = [:]
                        artist = [
                            "id": art["id"]!,
                            "name": art["name"]!,
                            "url": art["link"]!,
                            "imageURL": art["picture"]!,
                            "role": art["role"]!
                        ]
                        album.artist.append(artist as [String : Any])
                    }
                    let durationInSeconds = jsonResult["duration"] as! Int
                    let durationInSecondsRound = Int(roundf(Float(durationInSeconds))/1)
                    let durationInMinues = strongSelf.timeFormatted(totalSeconds: durationInSecondsRound)
                    album.duration = durationInMinues
                    completion(.success(album))
                    }
                } catch {
                    completion(.failure(error))
                    return
                }
            }
        }
        //print("Im not supposed to be here")
    }
    
    typealias DeezerPersonCompletion = (Result<DeezerPersonData, Error>) -> Void
    func getDeezerPerson(id: String, completion: @escaping DeezerPersonCompletion) {
        DispatchQueue.global().async { [weak self] in
            guard let strongSelf = self else {return}
            let resourceURL = "https://api.deezer.com/artist/\(id)"
            let parameters = ["access_token": strongSelf.accessToken]
            AF.request(resourceURL, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseJSON {[weak self] response in
                guard let strongSelf = self else {return}
                if let status = response.response?.statusCode {
                    switch(status){
                    case 200:
                        print("example success")
                        //                    print(response.result)
                    //                    print(response.data)
                    case 400:
                        print("error with response status: \(status)")
                        print(response.response.value)
                        completion(.failure(DeezerMultipleTrackErrors.status400))
                        return
                    case 401:
                        print("error with response status: \(status)")
                        print(response.response.value)
                        completion(.failure(DeezerMultipleTrackErrors.status400))
                        return
                    case 404:
                        print("error with response status: \(status)")
                        print(response.response.value)
                        completion(.failure(DeezerMultipleTrackErrors.status400))
                        return
                    case 405:
                        print("error with response status: \(status)")
                        print(response.response.value)
                        completion(.failure(DeezerMultipleTrackErrors.status400))
                        return
                    default:
                        print("error with response status: \(status)")
                        print(response.response.value)
                        completion(.failure(DeezerMultipleTrackErrors.status400))
                        return
                    }
                }
                do {
                    typealias JSONObject = [String:AnyObject]
                    if let jsonResult = try JSONSerialization.jsonObject(with: response.data!, options: JSONSerialization.ReadingOptions.allowFragments) as? [String : AnyObject] {
                        print(String(data: try! JSONSerialization.data(withJSONObject: jsonResult, options: .prettyPrinted), encoding: .utf8)!)
                        
                        let person = DeezerPersonData(url: "", profileImageURL: "", id: "", name: "", isActive: false)
                        person.id = String(jsonResult["id"] as! Int)
                        person.url = (jsonResult["link"] as! String)
                        person.name = (jsonResult["name"] as! String)
                        person.profileImageURL = (jsonResult["picture"] as! String)
                        completion(.success(person))
                }
                } catch {
                    completion(.failure(error))
                    return
                }
            }
        }
        //print("Im not supposed to be here")
    }
    
    func saveSongInfoToDatabase(completion: @escaping ((Bool) -> Void)) {
        getPersonData(personids: songArtistsIDs, completion: {[weak self] artistNames in
        guard let strongSelf = self else {return}
            strongSelf.songArtistsNames = artistNames
            let categorty = "\(songContentTag)--\(strongSelf.songName!)--\(strongSelf.toneDeafAppId)"
            let deezerContentRandomKey = ("\(deezerMusicContentType)--\(strongSelf.songName!)--\(strongSelf.dateArtistRegisteredToApp!)--\(strongSelf.timeArtistRegisteredToApp!)")
            
            
            var RequiredInfoMa = [String : Any]()
            RequiredInfoMa = [
                "Tone Deaf App Id" : strongSelf.toneDeafAppId,
                "Name" : strongSelf.songName!,
                "Artist" : strongSelf.songArtistsIDs,
                "Producers" : strongSelf.songProducers,
                "Writers": strongSelf.songWriters,
                "Engineers": [
                    "Mix Engineer": strongSelf.songMixEngineer,
                    "Mastering Engineer": strongSelf.songMasteringEngineer,
                    "Recording Engineer": strongSelf.songRecordingEngineer
                ],
                "Number of Favorites Overall" : 0,
                "Instrumentals": strongSelf.instrumentals,
                "Albums" : strongSelf.albums,
                "Date Registered To App": strongSelf.dateArtistRegisteredToApp,
                "Time Registered To App": strongSelf.timeArtistRegisteredToApp,
                "Verification Level": String(strongSelf.verificationLevel),
                "Industry Certified": strongSelf.industryCertification,
                "Explicit": strongSelf.explicit,
                "Active Status": false
            ]
            
            let RequiredRef = Database.database().reference().child("Music Content").child("Songs").child(categorty).child("REQUIRED")
            RequiredRef.updateChildValues(RequiredInfoMa) {(error, songRef) in
                if let error = error {
                    print("📕 Failed to upload dictionary to database: \(error)")
                    completion(false)
                    return
                }
            }
            
            strongSelf.getVideosFromSongInDB(cat: categorty, completion: { vids in
                var myVidsArray:[String] = vids
                print(myVidsArray)
                
                if myVidsArray == [] {
                    myVidsArray = []
                }
                var RequiredVidsInfoMap = [String : Any]()
                RequiredVidsInfoMap = [
                    "Videos" : myVidsArray]
                
                Database.database().reference().child("Music Content").child("Songs").child(categorty).child("REQUIRED").updateChildValues(RequiredVidsInfoMap) {(error, songRef) in
                    if let error = error {
                        print("📕 Failed to required video upload dictionary to database: \(error)")
                        completion(false)
                        return
                    }
                }
            })
            
            var SongInfoMap = [String : Any]()
            SongInfoMap = [
                "Name" : strongSelf.songNameDeezer!,
                "Artist" : strongSelf.songArtist!,
                "Preview URL" : strongSelf.songPreviewURL!,
                "ISRC" : strongSelf.songISRC!,
                "Date Released On Deezer" : strongSelf.songDateDeezer!,
                "Time Registered To App" : strongSelf.timeArtistRegisteredToApp!,
                "Date Registered To App" : strongSelf.dateArtistRegisteredToApp!,
                "Duration" : strongSelf.songDuration!,
                "Artwork URL" : strongSelf.songImageURL!,
                "Song URL" : strongSelf.songURL!,
                "Deezer Music Id" : strongSelf.songId!,
                "Active Status" : false
            ]
            
            let SongRef = Database.database().reference().child("Music Content").child("Songs").child(categorty).child(deezerContentRandomKey)
            
            SongRef.updateChildValues(SongInfoMap) { [weak self] (error, songRef) in
                guard let strongSelf = self else {return}
                if let error = error {
                    print("📕 Failed to upload dictionary to database: \(error)")
                    completion(false)
                    return
                } else {
                    completion(true)
                    print("📗 Deezer data for \(strongSelf.songName!) saved to database successfully.")
                    return
                }
            }
        })
    }
    
    func saveInstrumentalInfoToDatabase(instrContentRandomKey: String, completion: @escaping ((Bool) -> Void)) {
        getPersonData(personids: songArtistsIDs, completion: {[weak self] artistNames in
            guard let strongSelf = self else {return}
            strongSelf.songArtistsNames = artistNames
            let deezerContentRandomKey = ("\(deezerMusicContentType)--\(strongSelf.songName!)--\(strongSelf.dateArtistRegisteredToApp!)--\(strongSelf.timeArtistRegisteredToApp!)")
            
            
            
            
            
            
            var SongInfoMap = [String : Any]()
            SongInfoMap = [:
                            //                        "Name" : strongSelf.appleName,
                           //                        "Artist" : strongSelf.appleArtist,
                           //                        "Explicity" : strongSelf.appleExplicity,
                           //                        "Preview URL" : strongSelf.applePreviewURL,
                           //                        "ISRC" : strongSelf.appleISRC,
                           //                        "Date Released On Apple" : strongSelf.appleDateAPPL,
                           //                        "Time Uploaded To App" : strongSelf.appleTimeIA,
                           //                        "Date Uploaded To App" : strongSelf.appleDateIA,
                           //                        "Duration" : strongSelf.appleDuration,
                           //                        "Artwork URL" : strongSelf.appleArtworkURL,
                           //                        "Song URL" : strongSelf.appleSongURL,
                           //                        "Album Name" : strongSelf.appleAlbumName,
                           //                        "Composers" : strongSelf.applecomposers,
                           //                        "Genres" : strongSelf.appleGenres,
                           //                        "Number of Favorites" : strongSelf.appleFavorites,
                           //                        "Track Number" : strongSelf.appleTrackNumber,
                           //                        "Apple Music Id" : strongSelf.appleMusicId
            ]

                        let SongRef = Database.database().reference().child("Music Content").child("Instrumentals").child(instrContentRandomKey).child(deezerContentRandomKey)

                        SongRef.updateChildValues(SongInfoMap) { [weak self] (error, songRef) in
                            guard let strongSelf = self else {return}
                            if let error = error {
                                print("📕 Failed to upload dictionary to database: \(error)")
                                completion(false)
                                return
                            } else {
                                completion(true)
                                print("📗 Deezer data for \(strongSelf.songName!) saved to database successfully.")
                                return
                            }
                        }
        })
    }
    
    func getVideosFromSongInDB(cat: String, completion: @escaping (Array<String>) -> Void) {
        let vids = Database.database().reference().child("Music Content").child("Songs").child(cat).child("REQUIRED").child("Videos")
        vids.observeSingleEvent(of: .value, with: { snapshot in
            var myVidsArray:[String] = []
            var tick = 0
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
    
    func getPersonData(personids:[String], completion: @escaping (Array<String>) -> Void) {
        var artistNameData:Array<String> = []
        var val = 1
        for artist in personids {
            DatabaseManager.shared.fetchPersonData(person: artist.trimmingCharacters(in: .whitespacesAndNewlines), completion: { result in
                switch result {
                case .success(let selectedArtist):
                    artistNameData.append(selectedArtist.name!)
                    if val == personids.count {
                        completion(artistNameData)
                    }
                    val+=1
                case .failure(let err):
                    print("youyouerr", err)
                }
            })
        }
        
    }
    
    func timeFormatted(totalSeconds: Int) -> String {
       let seconds: Int = totalSeconds % 60
       let minutes: Int = (totalSeconds / 60) % 60
       //let hours: Int = totalSeconds / 3600
       return String(format: "%02d:%02d", minutes, seconds)
    }
    
}

public enum DeezerMultipleTrackErrors: Error {
    case status400
}

public enum DeezerArtistErrors: Error {
    case status400
}
