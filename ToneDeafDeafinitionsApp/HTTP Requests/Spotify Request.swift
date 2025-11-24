//
//  Spotify Request.swift
//  ToneDeafDeafinitionsApp
//
//  Created by Tone Deaf on 8/18/20.
//  Copyright © 2020 GITEM Solutions. All rights reserved.
//

import Foundation
import Alamofire
import FirebaseDatabase


public class SpotifyRequest {
    
    static let shared = SpotifyRequest()
    
    var toneDeafAppId = ""
    var instrumentals:[String] = []
    var albums:[String] = []
    var songName = ""
    var songArtistsNames:Array<String> = []
    var songArtistsIDs:Array<String> = []
    var songPersonsInvolved:Array<String> = []
    var songProducers:Array<String> = []
    var songWriters:Array<String> = []
    var songMixEngineer:Array<String> = []
    var songMasteringEngineer:Array<String> = []
    var songRecordingEngineer:Array<String> = []
    
    
    var songEngineers:Array<String> = []
    
    var personName = ""
    var personLegal:String?
    var altpersonName:Array<String> = []
    var role: String = ""
    
    var beats:[String] = []
    
    var spotifyName = ""
    var spotifySongURL = ""
    var spotifyDuration = ""
    var spotifyDateSPT = ""
    var spotifyDateIA = ""
    var spotifyTimeIA = ""
    var spotifyArtworkURL = ""
    var spotifyArtist1 = ""
    var spotifyArtist1URL = ""
    var spotifyArtist2 = ""
    var spotifyArtist2URL = ""
    var spotifyArtist3 = ""
    var spotifyArtist3URL = ""
    var spotifyArtist4 = ""
    var spotifyArtist4URL = ""
    var spotifyArtist5 = ""
    var spotifyArtist5URL = ""
    var spotifyArtist6 = ""
    var spotifyArtis6URL = ""
    var spotifyExplicity = true
    var spotifyISRC = ""
    var spotifyPreviewURL = ""
    var spotifyAlbumType = ""
    var spotifyTrackNumber = 0
    var spotifyFavorites = 0
    var spotifyId = ""
    var multipleSpotifyIds:[String] = []
    
    var dateArtistRegisteredToApp = ""
    var timeArtistRegisteredToApp = ""
    var spotifyProfileURL = ""
    var spotifyProfileImageURL = ""
    var linkedToAccount:String?
    var personFollowers = 0
    var songsByPerson:Array<String> = []
    var albumsByPerson:Array<String> = []
    var videosWithPerson:Array<String> = []
    
    var verificationLevel:Character!
    var industryCertification:Bool!
    var explicit:Bool!
    
    func setAccessToken(){
        let parameters = ["client_id" : "a4fae7208fd5486e8230d9a3c10baa32",
        "client_secret" : "9875b8cd296b4f13bfca13f8f4d5d9e1",
        "grant_type" : "client_credentials"]
        
        AF.request("https://accounts.spotify.com/api/token", method: .post, parameters: parameters, encoding: URLEncoding.default).responseJSON { [weak self] response in
        guard let strongSelf = self else {return}
            if let status = response.response?.statusCode {
                switch(status){
                case 200:
                    print("example success")
                    //print(response.result)
                    //print(response.data)
                default:
                    print("error with response status: \(status)")
                    print(response.response.value)
                }
            }
            do {
            typealias JSONObject = [String:AnyObject]
            if let jsonResult = try JSONSerialization.jsonObject(with: response.data!, options: JSONSerialization.ReadingOptions.allowFragments) as? [String : AnyObject] {
                //print("Response from Spotify: \(jsonResult)")
                    let items  = jsonResult["access_token"] as! String
                //print(items)
                UserDefaults.standard.set(items, forKey: "SPTaccesstoken")
                }
            } catch {
                
            }
        }
    }
    
    func getTrackInfo(accessToken: String, id: String, name: String, artists: Array<String>, producers: Array<String>, writers: Array<String>, mixEngineer: Array<String>, masteringEngineer: Array<String>, recordingEngineer: Array<String>, dateobj:Date, appid: String, instsongid: String, instrContentRandomKey: String, certifi:Bool?, verifi:Character, explicit:Bool, completion: @escaping ((Bool) -> Void)) {
        DispatchQueue.global().async { [weak self] in
            guard let strongSelf = self else {return}
            //print(artists)
            strongSelf.toneDeafAppId = appid
            strongSelf.songName = ""
            strongSelf.songArtistsIDs = []
            strongSelf.spotifyId = id
            strongSelf.personName = ""
            strongSelf.altpersonName = []
            strongSelf.dateArtistRegisteredToApp = ""
            strongSelf.timeArtistRegisteredToApp = ""
            strongSelf.spotifyProfileURL = ""
            strongSelf.spotifyProfileImageURL = ""
            strongSelf.linkedToAccount = ""
            strongSelf.personFollowers = 0
            strongSelf.spotifyAlbumType = ""
            strongSelf.spotifyTrackNumber = 0
            strongSelf.songName = name
            strongSelf.songArtistsIDs = artists
            strongSelf.albums = []
            strongSelf.instrumentals = []
            strongSelf.songProducers = producers
            strongSelf.songWriters = writers
            strongSelf.songMixEngineer = mixEngineer
            strongSelf.songMasteringEngineer = masteringEngineer
            strongSelf.songRecordingEngineer = recordingEngineer
            strongSelf.videosWithPerson = []
            strongSelf.industryCertification = certifi
            strongSelf.verificationLevel = verifi
            strongSelf.explicit = explicit
            
            strongSelf.songEngineers = GlobalFunctions.shared.mergeArrays(strongSelf.songMixEngineer,strongSelf.songMasteringEngineer,strongSelf.songRecordingEngineer)
            strongSelf.songPersonsInvolved = GlobalFunctions.shared.mergeArrays(artists,producers,writers,mixEngineer,masteringEngineer,recordingEngineer)
            
            let parameters = ["Authorization":"Bearer \(accessToken)"]
            let spotifyGetURL = "https://api.spotify.com/v1/tracks/\(id)"
            AF.request(spotifyGetURL, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: ["Authorization":"Bearer \(accessToken)"]).responseJSON(completionHandler: { [weak self] response in
                guard let strongSelf = self else {return}
                if let status = response.response?.statusCode {
                    
                    switch(status){
                    case 200:
                        print("example success")
                        //print(response.result)
                        //print(response.data)
                    case 400:
                        print("error with response status: \(status)")
                        Utilities.showError2("The request could not be understood by the server due to malformed syntax. Code error.", actionText: "OK")
                        print(response.response.value)
                        completion(false)
                        return
                    case 401:
                        print("error with response status: \(status)")
                        Utilities.showError2("The request requires user authentication or, if the request included authorization credentials, authorization has been refused for those credentials.", actionText: "OK")
                        print(response.response.value)
                        completion(false)
                        return
                    case 404:
                        print("error with response status: \(status)")
                        print(response.response.value)
                        
                        Utilities.showError2("Not Found - The requested resource could not be found. This error can be due to a temporary or permanent condition. Check the song id.", actionText: "OK")
                        completion(false)
                        return
                    case 429:
                        print("error with response status: \(status)")
                        Utilities.showError2("Too Many Requests - Rate limiting has been applied.", actionText: "OK")
                        print(response.response.value)
                        completion(false)
                        return
                    default:
                        print("error with response status: \(status)")
                        print(response.response.value)
                        completion(false)
                        return
                    }
                }
                do {
                    typealias JSONObject = [String:AnyObject]
                    if let jsonResult = try JSONSerialization.jsonObject(with: response.data!, options: JSONSerialization.ReadingOptions.allowFragments) as? [String : AnyObject] {
                        //print("Response from Spotify: \(jsonResult)")
                        strongSelf.spotifyTrackNumber = jsonResult["track_number"] as! Int
                        //Set Explicity
                        strongSelf.spotifyExplicity = jsonResult["explicit"] as! Bool
                        //Set Artist
                        let artists  = jsonResult["artists"] as! Array<JSONObject>
                        for artist in 0 ..< artists.count {
                            switch artist {
                            case 0:
                                strongSelf.spotifyArtist1 = artists[artist]["name"] as! String
                                let urlDict = artists[artist]["external_urls"] as! JSONObject
                                strongSelf.spotifyArtist1URL = urlDict["spotify"] as! String
                            case 1:
                                strongSelf.spotifyArtist2 = artists[artist]["name"] as! String
                                let urlDict = artists[artist]["external_urls"] as! JSONObject
                                strongSelf.spotifyArtist2URL = urlDict["spotify"] as! String
                            case 2:
                                strongSelf.spotifyArtist3 = artists[artist]["name"] as! String
                                let urlDict = artists[artist]["external_urls"] as! JSONObject
                                strongSelf.spotifyArtist3URL = urlDict["spotify"] as! String
                            case 3:
                                strongSelf.spotifyArtist4 = artists[artist]["name"] as! String
                                let urlDict = artists[artist]["external_urls"] as! JSONObject
                                strongSelf.spotifyArtist4URL = urlDict["spotify"] as! String
                            case 4:
                                strongSelf.spotifyArtist5 = artists[artist]["name"] as! String
                                let urlDict = artists[artist]["external_urls"] as! JSONObject
                                strongSelf.spotifyArtist5URL = urlDict["spotify"] as! String
                            case 5:
                                strongSelf.spotifyArtist6 = artists[artist]["name"] as! String
                                let urlDict = artists[artist]["external_urls"] as! JSONObject
                                strongSelf.spotifyArtis6URL = urlDict["spotify"] as! String
                            default:
                                print("too many artist")
                            }
                        }
                        //Set URL
                        let exurl  = jsonResult["external_urls"] as! JSONObject
                        strongSelf.spotifySongURL = exurl["spotify"] as! String
                        //Set Name
                        strongSelf.spotifyName = jsonResult["name"] as! String
                        //Set Duration
                        let durationunparsed = jsonResult["duration_ms"] as! Int
                        let durationInSeconds = (durationunparsed/1000)
                        let durationInSecondsRound = Int(roundf(Float(durationInSeconds))/1)
                        let durationInMinues = strongSelf.timeFormatted(totalSeconds: durationInSecondsRound)
                        strongSelf.spotifyDuration = durationInMinues
                        //Spotify Preview URL
                        strongSelf.spotifyPreviewURL = jsonResult["preview_url"] as? String ?? ""
                        //Spotify ISRC
                        let exid  = jsonResult["external_ids"] as! JSONObject
                        strongSelf.spotifyISRC = exid["isrc"] as! String
                        //Spotify Artwork URL
                        let album = jsonResult["album"] as! JSONObject
                        let imageunp = album["images"] as! Array<JSONObject>
                        strongSelf.spotifyAlbumType = album["album_type"] as! String
                        strongSelf.spotifyArtworkURL = imageunp[0]["url"] as! String
                        //Set Spotify Date
                        let ytDateTime = album["release_date"] as! String
                        let parsedDate = ytDateTime.prefix(10)
                        let words = parsedDate.split(separator: "-")
                        let parsedYear = words[0]
                        let parsedMonth = words[1].replacingOccurrences(of: "08", with: "August").replacingOccurrences(of: "01", with: "January").replacingOccurrences(of: "02", with: "February").replacingOccurrences(of: "03", with: "March").replacingOccurrences(of: "04", with: "April").replacingOccurrences(of: "05", with: "May").replacingOccurrences(of: "06", with: "June").replacingOccurrences(of: "07", with: "July").replacingOccurrences(of: "09", with: "September").replacingOccurrences(of: "10", with: "October").replacingOccurrences(of: "11", with: "November").replacingOccurrences(of: "12", with: "December")
                        let parsedDay = words[2]
                        strongSelf.spotifyDateSPT = "\(parsedMonth) \(parsedDay), \(parsedYear)"
                        
                        let date = dateobj
                        let formatter = DateFormatter()
                        formatter.timeZone = TimeZone(identifier: "EDT")
                        formatter.dateFormat = "MMMM dd, yyyy"
                        strongSelf.spotifyDateIA = formatter.string(from: date)
                        //print("📙 current date: \(currentDate)")
                        
                        let time = dateobj
                        let timeFormatter = DateFormatter()
                        timeFormatter.dateFormat = "HH:mm:ss a"
                        timeFormatter.timeZone = TimeZone(identifier: "EDT")
                        strongSelf.spotifyTimeIA = timeFormatter.string(from: time)
                        //print("📙 current time: \(currentTime)")
                        
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
                }
                catch {
                    print("json error: \(error)")
                    completion(false)
                    return
                }
            })
        }
    }
    
    typealias SpotifyTrackCompletion = (Result<SpotifySongData, Error>) -> Void
    func getTrackInfo(accessToken: String, id: String, completion: @escaping SpotifyTrackCompletion) {
        DispatchQueue.global().async { [weak self] in
            guard let strongSelf = self else {return}
            
            let parameters = ["Authorization":"Bearer \(accessToken)"]
            let spotifyGetURL = "https://api.spotify.com/v1/tracks/\(id)"
            AF.request(spotifyGetURL, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: ["Authorization":"Bearer \(accessToken)"]).responseJSON(completionHandler: { [weak self] response in
                guard let strongSelf = self else {return}
                if let status = response.response?.statusCode {
                    switch(status){
                    case 200:
                        print("example success")
                        //print(response.result)
                        //print(response.data)
                    case 400:
                        print("error with response status: \(status)")
                        Utilities.showError2("The request could not be understood by the server due to malformed syntax. Code error.", actionText: "OK")
                        print(response.response.value)
                        completion(.failure(SpotifyMultipleTrackErrors.status400))
                        return
                    case 401:
                        print("error with response status: \(status)")
                        Utilities.showError2("The request requires user authentication or, if the request included authorization credentials, authorization has been refused for those credentials.", actionText: "OK")
                        print(response.response.value)
                        completion(.failure(SpotifyMultipleTrackErrors.status400))
                        return
                    case 404:
                        print("error with response status: \(status)")
                        print(response.response.value)
                        Utilities.showError2("Not Found - The requested resource could not be found. This error can be due to a temporary or permanent condition. Check the song id.", actionText: "OK")
                        completion(.failure(SpotifyMultipleTrackErrors.status400))
                        return
                    case 429:
                        print("error with response status: \(status)")
                        Utilities.showError2("Too Many Requests - Rate limiting has been applied.", actionText: "OK")
                        print(response.response.value)
                        completion(.failure(SpotifyMultipleTrackErrors.status400))
                        return
                    default:
                        print("error with response status: \(status)")
                        print(response.response.value)
                        completion(.failure(SpotifyMultipleTrackErrors.status400))
                        return
                    }
                }
                do {
                    typealias JSONObject = [String:AnyObject]
                    if let jsonResult = try JSONSerialization.jsonObject(with: response.data!, options: JSONSerialization.ReadingOptions.allowFragments) as? [String : AnyObject] {
                        //print("Response from Spotify: \(jsonResult)")
                        
                        let song = SpotifySongData(spotifyName: "", spotifySongURL: "", spotifyDuration: "", spotifyDateSPT: "", spotifyDateIA: "", spotifyTimeIA: "", spotifyArtworkURL: "", spotifyArtist1: "", spotifyArtist1URL: "", spotifyArtist2: "", spotifyArtist2URL: "", spotifyArtist3: "", spotifyArtist3URL: "", spotifyArtist4: "", spotifyArtist4URL: "", spotifyArtist5: "", spotifyArtist5URL: "", spotifyArtist6: "", spotifyArtist6URL: "", spotifyExplicity: false, spotifyISRC: "", spotifyAlbumType: "", spotifyTrackNumber: 0, spotifyPreviewURL: "", spotifyFavorites: 0, spotifyId: "", isActive: false)
                        song.spotifyTrackNumber = jsonResult["track_number"] as! Int
                        song.spotifyExplicity = jsonResult["explicit"] as! Bool
                        song.spotifyId = jsonResult["id"] as! String
                        let artists  = jsonResult["artists"] as! Array<JSONObject>
                        for artist in 0 ..< artists.count {
                            switch artist {
                            case 0:
                                song.spotifyArtist1 = artists[artist]["name"] as! String
                                let urlDict = artists[artist]["external_urls"] as! JSONObject
                                song.spotifyArtist1URL = urlDict["spotify"] as! String
                            case 1:
                                song.spotifyArtist2 = artists[artist]["name"] as! String
                                let urlDict = artists[artist]["external_urls"] as! JSONObject
                                song.spotifyArtist2URL = urlDict["spotify"] as! String
                            case 2:
                                song.spotifyArtist3 = artists[artist]["name"] as! String
                                let urlDict = artists[artist]["external_urls"] as! JSONObject
                                song.spotifyArtist3URL = urlDict["spotify"] as! String
                            case 3:
                                song.spotifyArtist4 = artists[artist]["name"] as! String
                                let urlDict = artists[artist]["external_urls"] as! JSONObject
                                song.spotifyArtist4URL = urlDict["spotify"] as! String
                            case 4:
                                song.spotifyArtist5 = artists[artist]["name"] as! String
                                let urlDict = artists[artist]["external_urls"] as! JSONObject
                                song.spotifyArtist5URL = urlDict["spotify"] as! String
                            case 5:
                                song.spotifyArtist6 = artists[artist]["name"] as! String
                                let urlDict = artists[artist]["external_urls"] as! JSONObject
                                song.spotifyArtis6URL = urlDict["spotify"] as! String
                            default:
                                print("too many artist")
                            }
                        }
                        //Set URL
                        let exurl  = jsonResult["external_urls"] as! JSONObject
                        song.spotifySongURL = exurl["spotify"] as! String
                        //Set Name
                        song.spotifyName = jsonResult["name"] as! String
                        //Set Duration
                        let durationunparsed = jsonResult["duration_ms"] as! Int
                        let durationInSeconds = (durationunparsed/1000)
                        let durationInSecondsRound = Int(roundf(Float(durationInSeconds))/1)
                        let durationInMinues = strongSelf.timeFormatted(totalSeconds: durationInSecondsRound)
                        song.spotifyDuration = durationInMinues
                        //Spotify Preview URL
                        song.spotifyPreviewURL = jsonResult["preview_url"] as? String ?? ""
                        //Spotify ISRC
                        let exid  = jsonResult["external_ids"] as! JSONObject
                        song.spotifyISRC = exid["isrc"] as! String
                        //Spotify Artwork URL
                        let album = jsonResult["album"] as! JSONObject
                        let imageunp = album["images"] as! Array<JSONObject>
                        song.spotifyAlbumType = album["album_type"] as! String
                        song.spotifyArtworkURL = imageunp[0]["url"] as! String
                        //Set Spotify Date
                        let ytDateTime = album["release_date"] as! String
                        let parsedDate = ytDateTime.prefix(10)
                        let words = parsedDate.split(separator: "-")
                        let parsedYear = words[0]
                        let parsedMonth = words[1].replacingOccurrences(of: "08", with: "August").replacingOccurrences(of: "01", with: "January").replacingOccurrences(of: "02", with: "February").replacingOccurrences(of: "03", with: "March").replacingOccurrences(of: "04", with: "April").replacingOccurrences(of: "05", with: "May").replacingOccurrences(of: "06", with: "June").replacingOccurrences(of: "07", with: "July").replacingOccurrences(of: "09", with: "September").replacingOccurrences(of: "10", with: "October").replacingOccurrences(of: "11", with: "November").replacingOccurrences(of: "12", with: "December")
                        let parsedDay = words[2]
                        song.spotifyDateSPT = "\(parsedMonth) \(parsedDay), \(parsedYear)"
                        
                        let date = Date()
                        let formatter = DateFormatter()
                        formatter.timeZone = TimeZone(identifier: "EDT")
                        formatter.dateFormat = "MMMM dd, yyyy"
                        song.spotifyDateIA = formatter.string(from: date)
                        //print("📙 current date: \(currentDate)")
                        
                        let time = Date()
                        let timeFormatter = DateFormatter()
                        timeFormatter.dateFormat = "HH:mm:ss a"
                        timeFormatter.timeZone = TimeZone(identifier: "EDT")
                        song.spotifyTimeIA = timeFormatter.string(from: time)
                        completion(.success(song))
                    }
                }
                catch {
                    print("json error: \(error)")
                    completion(.failure(SpotifyMultipleTrackErrors.status400))
                    return
                }
            })
        }
    }
    
    typealias SpotifyAlbumCompletion = (Result<SpotifyAlbumData, Error>) -> Void
    func getAlbumInfo(accessToken: String, id: String, completion: @escaping SpotifyAlbumCompletion) {
        DispatchQueue.global().async { [weak self] in
            guard let strongSelf = self else {return}
            
            let parameters = ["Authorization":"Bearer \(accessToken)"]
            let spotifyGetURL = "https://api.spotify.com/v1/albums/\(id)"
            AF.request(spotifyGetURL, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: ["Authorization":"Bearer \(accessToken)"]).responseJSON(completionHandler: { [weak self] response in
                guard let strongSelf = self else {return}
                if let status = response.response?.statusCode {
                    switch(status){
                    case 200:
                        print("example success")
                        //print(response.result)
                        //print(response.data)
                    case 400:
                        print("error with response status: \(status)")
                        Utilities.showError2("The request could not be understood by the server due to malformed syntax. Code error.", actionText: "OK")
                        print(response.response.value)
                        completion(.failure(SpotifyMultipleTrackErrors.status400))
                        return
                    case 401:
                        print("error with response status: \(status)")
                        Utilities.showError2("The request requires user authentication or, if the request included authorization credentials, authorization has been refused for those credentials.", actionText: "OK")
                        print(response.response.value)
                        completion(.failure(SpotifyMultipleTrackErrors.status400))
                        return
                    case 404:
                        print("error with response status: \(status)")
                        print(response.response.value)
                        Utilities.showError2("Not Found - The requested resource could not be found. This error can be due to a temporary or permanent condition. Check the song id.", actionText: "OK")
                        completion(.failure(SpotifyMultipleTrackErrors.status400))
                        return
                    case 429:
                        print("error with response status: \(status)")
                        Utilities.showError2("Too Many Requests - Rate limiting has been applied.", actionText: "OK")
                        print(response.response.value)
                        completion(.failure(SpotifyMultipleTrackErrors.status400))
                        return
                    default:
                        print("error with response status: \(status)")
                        print(response.response.value)
                        completion(.failure(SpotifyMultipleTrackErrors.status400))
                        return
                    }
                }
                do {
                    typealias JSONObject = [String:AnyObject]
                    if let jsonResult = try JSONSerialization.jsonObject(with: response.data!, options: JSONSerialization.ReadingOptions.allowFragments) as? [String : AnyObject] {
                        //print("Response from Spotify: \(jsonResult)")
                        
                        let album = SpotifyAlbumData(toneDeafAppId: "", name: "", artist: [["":""]], spotifyId: "", url: "", uri: "", imageURL: "", upc: "", trackNumberTotal: 0, dateReleasedSpotify: "", dateIA: "", timeIA: "", isActive: false)
                        album.name = jsonResult["name"] as! String
                        album.trackNumberTotal = jsonResult["total_tracks"] as! Int
                        album.spotifyId = jsonResult["id"] as! String
                        album.uri = jsonResult["uri"] as! String
                        let exurl  = jsonResult["external_urls"] as! JSONObject
                        album.url = exurl["spotify"] as! String
                        let imageunp = jsonResult["images"] as! Array<JSONObject>
                        album.imageURL = imageunp[0]["url"] as! String
                        let exid  = jsonResult["external_ids"] as! JSONObject
                        album.upc = exid["upc"] as! String
                        let spotart = jsonResult["artists"] as! Array<JSONObject>
                        var allArtiAlb:[[String:String]] = []
                        for art in spotart {
                            var artistNames:[String:String] = [:]
                            artistNames["uri"] = art["uri"] as? String
                            artistNames["id"] = art["id"] as! String
                            let tist = art["external_urls"] as? JSONObject
                            artistNames["url"] = tist?["spotify"] as? String
                            artistNames["name"] = art["name"] as? String
                            allArtiAlb.append(artistNames)
                        }
                        album.artist = allArtiAlb
                        let ytDateTime = jsonResult["release_date"] as! String
                        let words = ytDateTime.split(separator: "-")
                        let parsedYear = words[0]
                        let parsedMonth = words[1].replacingOccurrences(of: "08", with: "August").replacingOccurrences(of: "01", with: "January").replacingOccurrences(of: "02", with: "February").replacingOccurrences(of: "03", with: "March").replacingOccurrences(of: "04", with: "April").replacingOccurrences(of: "05", with: "May").replacingOccurrences(of: "06", with: "June").replacingOccurrences(of: "07", with: "July").replacingOccurrences(of: "09", with: "September").replacingOccurrences(of: "10", with: "October").replacingOccurrences(of: "11", with: "November").replacingOccurrences(of: "12", with: "December")
                        let parsedDay = words[2]
                        album.dateReleasedSpotify = "\(parsedMonth) \(parsedDay), \(parsedYear)"
//
                        completion(.success(album))
                    }
                }
                catch {
                    print("json error: \(error)")
                    completion(.failure(SpotifyMultipleTrackErrors.status400))
                    return
                }
            })
        }
    }
    
    typealias SpotifyMultipleTrackCompletion = (Result<[SpotifySongData], Error>) -> Void
    func getMultipleTracksInfo(accessToken: String, ids: [String], completion: @escaping SpotifyMultipleTrackCompletion) {
        DispatchQueue.global().async { [weak self] in
            guard let strongSelf = self else {return}
            //print(artists)
            var spotifyDataArray:[SpotifySongData] = []
            
            let parameters = ["Authorization":"Bearer \(accessToken)"]
            let spotifyGetURL = "https://api.spotify.com/v1/tracks/?ids=\(ids.joined(separator: ","))"
            AF.request(spotifyGetURL, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: ["Authorization":"Bearer \(accessToken)"]).responseJSON(completionHandler: { [weak self] response in
                guard let strongSelf = self else {return}
                if let status = response.response?.statusCode {
                    switch(status){
                    case 200:
                        print("example success")
                        //print(response.result)
                        //print(response.data)
                    case 400:
                        print("error with response status: \(status)")
                        Utilities.showError2("The request could not be understood by the server due to malformed syntax. Code error.", actionText: "OK")
                        print(response.response.value)
                        completion(.failure(SpotifyMultipleTrackErrors.status400))
                        return
                    case 401:
                        print("error with response status: \(status)")
                        Utilities.showError2("The request requires user authentication or, if the request included authorization credentials, authorization has been refused for those credentials.", actionText: "OK")
                        print(response.response.value)
                        completion(.failure(SpotifyMultipleTrackErrors.status400))
                        return
                    case 404:
                        print("error with response status: \(status)")
                        print(response.response.value)
                        Utilities.showError2("Not Found - The requested resource could not be found. This error can be due to a temporary or permanent condition. Check the song id.", actionText: "OK")
                        completion(.failure(SpotifyMultipleTrackErrors.status400))
                        return
                    case 429:
                        print("error with response status: \(status)")
                        Utilities.showError2("Too Many Requests - Rate limiting has been applied.", actionText: "OK")
                        print(response.response.value)
                        completion(.failure(SpotifyMultipleTrackErrors.status400))
                        return
                    default:
                        print("error with response status: \(status)")
                        print(response.response.value)
                        completion(.failure(SpotifyMultipleTrackErrors.status400))
                        return
                    }
                }
                do {
                    typealias JSONObject = [String:AnyObject]
                    if let jsonResult = try JSONSerialization.jsonObject(with: response.data!, options: JSONSerialization.ReadingOptions.allowFragments) as? [String : AnyObject] {
                        //print("Response from Spotify: \(jsonResult)")
                        for (_, jsonData) in jsonResult {
                            let json = jsonData as! [JSONObject]
                            for key in json {
                                let song = SpotifySongData(spotifyName: "", spotifySongURL: "", spotifyDuration: "", spotifyDateSPT: "", spotifyDateIA: "", spotifyTimeIA: "", spotifyArtworkURL: "", spotifyArtist1: "", spotifyArtist1URL: "", spotifyArtist2: "", spotifyArtist2URL: "", spotifyArtist3: "", spotifyArtist3URL: "", spotifyArtist4: "", spotifyArtist4URL: "", spotifyArtist5: "", spotifyArtist5URL: "", spotifyArtist6: "", spotifyArtist6URL: "", spotifyExplicity: false, spotifyISRC: "", spotifyAlbumType: "", spotifyTrackNumber: 0, spotifyPreviewURL: "", spotifyFavorites: 0, spotifyId: "", isActive: false)
                                song.spotifyTrackNumber = key["track_number"] as! Int
                                song.spotifyExplicity = key["explicit"] as! Bool
                                song.spotifyId = key["id"] as! String
                                let artists  = key["artists"] as! Array<JSONObject>
                                for artist in 0 ..< artists.count {
                                    switch artist {
                                    case 0:
                                        song.spotifyArtist1 = artists[artist]["name"] as! String
                                        let urlDict = artists[artist]["external_urls"] as! JSONObject
                                        song.spotifyArtist1URL = urlDict["spotify"] as! String
                                    case 1:
                                        song.spotifyArtist2 = artists[artist]["name"] as! String
                                        let urlDict = artists[artist]["external_urls"] as! JSONObject
                                        song.spotifyArtist2URL = urlDict["spotify"] as! String
                                    case 2:
                                        song.spotifyArtist3 = artists[artist]["name"] as! String
                                        let urlDict = artists[artist]["external_urls"] as! JSONObject
                                        song.spotifyArtist3URL = urlDict["spotify"] as! String
                                    case 3:
                                        song.spotifyArtist4 = artists[artist]["name"] as! String
                                        let urlDict = artists[artist]["external_urls"] as! JSONObject
                                        song.spotifyArtist4URL = urlDict["spotify"] as! String
                                    case 4:
                                        song.spotifyArtist5 = artists[artist]["name"] as! String
                                        let urlDict = artists[artist]["external_urls"] as! JSONObject
                                        song.spotifyArtist5URL = urlDict["spotify"] as! String
                                    case 5:
                                        song.spotifyArtist6 = artists[artist]["name"] as! String
                                        let urlDict = artists[artist]["external_urls"] as! JSONObject
                                        song.spotifyArtis6URL = urlDict["spotify"] as! String
                                    default:
                                        print("too many artist")
                                    }
                                }
                                //Set URL
                                let exurl  = key["external_urls"] as! JSONObject
                                song.spotifySongURL = exurl["spotify"] as! String
                                //Set Name
                                song.spotifyName = key["name"] as! String
                                //Set Duration
                                let durationunparsed = key["duration_ms"] as! Int
                                let durationInSeconds = (durationunparsed/1000)
                                let durationInSecondsRound = Int(roundf(Float(durationInSeconds))/1)
                                let durationInMinues = strongSelf.timeFormatted(totalSeconds: durationInSecondsRound)
                                song.spotifyDuration = durationInMinues
                                //Spotify Preview URL
                                song.spotifyPreviewURL = key["preview_url"] as? String ?? ""
                                //Spotify ISRC
                                let exid  = key["external_ids"] as! JSONObject
                                song.spotifyISRC = exid["isrc"] as! String
                                //Spotify Artwork URL
                                let album = key["album"] as! JSONObject
                                let imageunp = album["images"] as! Array<JSONObject>
                                song.spotifyAlbumType = album["album_type"] as! String
                                song.spotifyArtworkURL = imageunp[0]["url"] as! String
                                //Set Spotify Date
                                let ytDateTime = album["release_date"] as! String
                                let parsedDate = ytDateTime.prefix(10)
                                let words = parsedDate.split(separator: "-")
                                let parsedYear = words[0]
                                let parsedMonth = words[1].replacingOccurrences(of: "08", with: "August").replacingOccurrences(of: "01", with: "January").replacingOccurrences(of: "02", with: "February").replacingOccurrences(of: "03", with: "March").replacingOccurrences(of: "04", with: "April").replacingOccurrences(of: "05", with: "May").replacingOccurrences(of: "06", with: "June").replacingOccurrences(of: "07", with: "July").replacingOccurrences(of: "09", with: "September").replacingOccurrences(of: "10", with: "October").replacingOccurrences(of: "11", with: "November").replacingOccurrences(of: "12", with: "December")
                                let parsedDay = words[2]
                                song.spotifyDateSPT = "\(parsedMonth) \(parsedDay), \(parsedYear)"
                                
                                spotifyDataArray.append(song)
                                
                            }
                        }
                        completion(.success(spotifyDataArray))
                    }
                }
                catch {
                    print("json error: \(error)")
                    completion(.failure(SpotifyMultipleTrackErrors.status400))
                    return
                }
            })
        }
    }
    typealias SpotifyArtistCompletion = (Result<Bool, Error>) -> Void
    func getArtistInfo(accessToken: String, id: String, name: String, altName: Array<String>, mainRole: String, dateobj:Date, appid:String, legal: String?, tag: String, certifi:Bool?, verifi:Character, completion: @escaping SpotifyArtistCompletion) {
        songName = ""
        personLegal = legal
        songArtistsNames = []
        personName = ""
        altpersonName = []
        dateArtistRegisteredToApp = ""
        timeArtistRegisteredToApp = ""
        spotifyProfileURL = ""
        spotifyProfileImageURL = ""
        linkedToAccount = ""
        personFollowers = 0
        personName = name
        spotifyId = id
        altpersonName = altName
        songsByPerson = []
        albumsByPerson = []
        toneDeafAppId = appid
        beats = []
        role = mainRole
        industryCertification = certifi
        verificationLevel = verifi
        
        let parameters = ["Authorization":"Bearer \(accessToken)"]
        let spotifyGetURL = "https://api.spotify.com/v1/artists/\(id)"
        AF.request(spotifyGetURL, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: ["Authorization":"Bearer \(accessToken)"]).responseJSON(completionHandler: { [weak self] response in
            guard let strongSelf = self else {return}
            if let status = response.response?.statusCode {
                switch(status){
                case 200:
                    print("example success")
                    do {
                        typealias JSONObject = [String:AnyObject]
                        if let jsonResult = try JSONSerialization.jsonObject(with: response.data!, options: JSONSerialization.ReadingOptions.allowFragments) as? [String : AnyObject] {
                            //print("Response from Spotify: \(jsonResult)")
                            //Set URL
                            let exurl  = jsonResult["external_urls"] as! JSONObject
                            strongSelf.spotifyProfileURL = exurl["spotify"] as! String
                            let imageunp = jsonResult["images"] as! Array<JSONObject>
                            strongSelf.spotifyProfileImageURL = imageunp[0]["url"] as! String
                            
                            let date = dateobj
                            let formatter = DateFormatter()
                            formatter.dateFormat = "MMMM dd, yyyy"
                            strongSelf.dateArtistRegisteredToApp = formatter.string(from: date)
                            
                            let time = dateobj
                            let timeFormatter = DateFormatter()
                            timeFormatter.dateFormat = "HH:mm:ss a"
                            strongSelf.timeArtistRegisteredToApp = timeFormatter.string(from: time)
                            strongSelf.savePersonInfoToDatabase(completion: { done in
                                if done == true {
                                    completion(.success(true))
                                } else {
                                    completion(.failure(SpotifyArtistErrors.status400))
                                    return
                                }
                            })
                        }
                    } catch {
                        completion(.failure(SpotifyArtistErrors.status400))
                    }
                default:
                    print("error with response status: \(status)")
                    print(response.response.value)
                    completion(.failure(SpotifyArtistErrors.status400))
                }
            }
        })
    }
    
    typealias SpotifyPersonCompletion = (Result<SpotifyPersonData, Error>) -> Void
    func getArtistInfo(accessToken: String, id: String, person: PersonData, completion: @escaping SpotifyPersonCompletion) {
        let personInfo = SpotifyPersonData(url: "", isActive: false, id: "", profileImageURL: "")
        let parameters = ["Authorization":"Bearer \(accessToken)"]
        let spotifyGetURL = "https://api.spotify.com/v1/artists/\(id)"
        AF.request(spotifyGetURL, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: ["Authorization":"Bearer \(accessToken)"]).responseJSON(completionHandler: { [weak self] response in
            guard let strongSelf = self else {return}
            if let status = response.response?.statusCode {
                switch(status){
                case 200:
                    print("example success")
                    do {
                        typealias JSONObject = [String:AnyObject]
                        if let jsonResult = try JSONSerialization.jsonObject(with: response.data!, options: JSONSerialization.ReadingOptions.allowFragments) as? [String : AnyObject] {
                            //print("Response from Spotify: \(jsonResult)")
                            //Set URL
                            let exurl  = jsonResult["external_urls"] as! JSONObject
                            personInfo.url = exurl["spotify"] as! String
                            let imageunp = jsonResult["images"] as! Array<JSONObject>
                            personInfo.profileImageURL = imageunp[0]["url"] as! String
                            
//                            let date = dateobj
//                            let formatter = DateFormatter()
//                            formatter.dateFormat = "MMMM dd, yyyy"
//                            strongSelf.dateArtistRegisteredToApp = formatter.string(from: date)
//
//                            let time = dateobj
//                            let timeFormatter = DateFormatter()
//                            timeFormatter.dateFormat = "HH:mm:ss a"
//                            strongSelf.timeArtistRegisteredToApp = timeFormatter.string(from: time)
                                    completion(.success(personInfo))
                        }
                    } catch {
                        completion(.failure(SpotifyArtistErrors.status400))
                    }
                default:
                    print("error with response status: \(status)")
                    print(response.response.value)
                    completion(.failure(SpotifyArtistErrors.status400))
                }
            }
        })
    }
    
    func saveSongInfoToDatabase(completion: @escaping ((Bool) -> Void)) {
        getArtistData(personids: songArtistsIDs, completion: {[weak self] artistNames in
            guard let strongSelf = self else {return}
            strongSelf.songArtistsNames = artistNames
            let categorty = "\(songContentTag)--\(strongSelf.songName)--\(strongSelf.toneDeafAppId)"
            let spotifyContentRandomKey = ("\(spotifyMusicContentType)--\(strongSelf.songName)--\(strongSelf.spotifyDateIA)--\(strongSelf.spotifyTimeIA)")
            
            var RequiredInfoMa = [String : Any]()
            RequiredInfoMa = [
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
                "Instrumentals": strongSelf.instrumentals,
                "Albums" : strongSelf.albums,
                "Date Registered To App": strongSelf.spotifyDateIA,
                "Time Registered To App": strongSelf.spotifyTimeIA,
                "Verification Level": String(strongSelf.verificationLevel),
                "Industry Certified": strongSelf.industryCertification,
                "Explicit": strongSelf.explicit,
                "Active Status": false
            ]
            
            let RequiredRef = Database.database().reference().child("Music Content").child("Songs").child(categorty).child("REQUIRED")
            RequiredRef.updateChildValues(RequiredInfoMa) { [weak self] (error, songRef) in
                guard let strongSelf = self else {return}
                if let error = error {
                    print("📕 Failed to upload dictionary to database: \(error)")
                    completion(false)
                    return
                } else {
                    
                }
            }
            
            strongSelf.getVideosFromSongInDB(cat: categorty, completion: { vids in
                var myVidsArray:[String] = vids
                //print(myVidsArray)
                
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
            //            var counterpin = 0
            //            for art in strongSelf.songArtistsIDs {
            //                var RequiredArtMap = [String : String]()
            //                RequiredArtMap = ["id" : art]
//                DatabaseManager.shared.fetchArtistData(artist: art, completion: { artist in
//
//                    let dbref = Database.database().reference().child("Music Content").child("Songs").child(categorty).child("REQUIRED").child("Artist").child(String(counterpin)).child(artist.name)
//                    dbref.updateChildValues(RequiredArtMap) { [weak self] (error, songRef) in
//                        guard let strongSelf = self else {return}
//                        if let error = error {
//                            print("📕 Failed to upload dictionary to database: \(error)")
//                            completion(false)
//                            return
//                        } else {
//
//                        }
//                    }
//
//                })
//                counterpin+=1
//            }
            
            var SongInfoMap = [String : Any]()
            SongInfoMap = [
                "Name" : strongSelf.spotifyName,
                "Artist 1" : strongSelf.spotifyArtist1,
                "Artist 1 URL" : strongSelf.spotifyArtist1URL,
                "Artist 2" : strongSelf.spotifyArtist2,
                "Artist 2 URL" : strongSelf.spotifyArtist2URL,
                "Artist 3" : strongSelf.spotifyArtist3,
                "Artist 3 URL" : strongSelf.spotifyArtist3URL,
                "Artist 4" : strongSelf.spotifyArtist4,
                "Artist 4 URL" : strongSelf.spotifyArtist4URL,
                "Artist 5" : strongSelf.spotifyArtist5,
                "Artist 5 URL" : strongSelf.spotifyArtist5URL,
                "Artist 6" : strongSelf.spotifyArtist6,
                "Artist 6 URL" : strongSelf.spotifyArtis6URL,
                "Explicity" : strongSelf.spotifyExplicity,
                "Preview URL" : strongSelf.spotifyPreviewURL,
                "ISRC" : strongSelf.spotifyISRC,
                "Date Released On Spotify" : strongSelf.spotifyDateSPT,
                "Time Uploaded To App" : strongSelf.spotifyTimeIA,
                "Date Uploaded To App" : strongSelf.spotifyDateIA,
                "Duration" : strongSelf.spotifyDuration,
                "Artwork URL" : strongSelf.spotifyArtworkURL,
                "Song URL" : strongSelf.spotifySongURL,
                "Number of Favorites" : strongSelf.spotifyFavorites,
                "Track Number" : strongSelf.spotifyTrackNumber,
                "Album Type" : strongSelf.spotifyAlbumType,
                "Spotify Id" : strongSelf.spotifyId,
                "Active Status": false]
            
            let SongRef = Database.database().reference().child("Music Content").child("Songs").child(categorty).child(spotifyContentRandomKey)
            
            SongRef.updateChildValues(SongInfoMap) { [weak self] (error, songRef) in
                guard let strongSelf = self else {return}
                if let error = error {
                    print("📕 Failed to upload dictionary to database: \(error)")
                    Utilities.showError2("Failed to Upload. Please try again.", actionText: "OK")
                    completion(false)
                    return
                } else {
                    print("kjhgfdgsdgghjkjl")
                    completion(true)
                    print("📗 Spotify data for \(strongSelf.songName) saved to database successfully.")
                    return
                }
            }
        })
    }
    
    func saveInstrumentalInfoToDatabase(instrContentRandomKey: String, completion: @escaping ((Bool) -> Void)) {
            getArtistData(personids: songArtistsIDs, completion: {[weak self] artistNames in
                guard let strongSelf = self else {return}
                let spotifyContentRandomKey = ("\(spotifyMusicContentType)--\(strongSelf.songName)--\(strongSelf.spotifyDateIA)--\(strongSelf.spotifyTimeIA)")
                
                //print(strongSelf.songArtistsIDs)
                
                var SongInfoMap = [String : Any]()
                SongInfoMap = [
                    "Name" : strongSelf.spotifyName,
                    "Artist 1" : strongSelf.spotifyArtist1,
                    "Artist 1 URL" : strongSelf.spotifyArtist1URL,
                    "Artist 2" : strongSelf.spotifyArtist2,
                    "Artist 2 URL" : strongSelf.spotifyArtist2URL,
                    "Artist 3" : strongSelf.spotifyArtist3,
                    "Artist 3 URL" : strongSelf.spotifyArtist3URL,
                    "Artist 4" : strongSelf.spotifyArtist4,
                    "Artist 4 URL" : strongSelf.spotifyArtist4URL,
                    "Artist 5" : strongSelf.spotifyArtist5,
                    "Artist 5 URL" : strongSelf.spotifyArtist5URL,
                    "Artist 6" : strongSelf.spotifyArtist6,
                    "Artist 6 URL" : strongSelf.spotifyArtis6URL,
                    "Explicity" : strongSelf.spotifyExplicity,
                    "Preview URL" : strongSelf.spotifyPreviewURL,
                    "ISRC" : strongSelf.spotifyISRC,
                    "Date Released On Spotify" : strongSelf.spotifyDateSPT,
                    "Time Uploaded To App" : strongSelf.spotifyTimeIA,
                    "Date Uploaded To App" : strongSelf.spotifyDateIA,
                    "Duration" : strongSelf.spotifyDuration,
                    "Artwork URL" : strongSelf.spotifyArtworkURL,
                    "Song URL" : strongSelf.spotifySongURL,
                    "Number of Favorites" : strongSelf.spotifyFavorites,
                    "Track Number" : strongSelf.spotifyTrackNumber,
                    "Album Type" : strongSelf.spotifyAlbumType,
                    "Spotify Id" : strongSelf.spotifyId]
                
                let SongRef = Database.database().reference().child("Music Content").child("Instrumentals").child(instrContentRandomKey).child(spotifyContentRandomKey)
                
                SongRef.updateChildValues(SongInfoMap) { [weak self] (error, songRef) in
                    guard let strongSelf = self else {return}
                    if let error = error {
                        print("📕 Failed to upload dictionary to database: \(error)")
                        Utilities.showError2("Failed to Upload. Please try again.", actionText: "OK")
                        completion(false)
                        return
                    } else {
                        print("kjhgfdgsdgghjkjl")
                        completion(true)
                        print("📗 Spotify data for \(strongSelf.songName) saved to database successfully.")
                        return
                    }
                }
            })
        }
    
    func saveArtistInfoToDatabase(completion: @escaping ((Bool) -> Void)) {
            let artistRandomKey = ("\(personName)--\(dateArtistRegisteredToApp)--\(timeArtistRegisteredToApp)--\(toneDeafAppId)")
                
        var RequiredInfoMap = [String : Any]()
        RequiredInfoMap = [
            "Name" : personName,
            "Tone Deaf App Id" : toneDeafAppId,
            "Alternate Names" : altpersonName,
            "Followers" : personFollowers,
            "Time Registered To App" : timeArtistRegisteredToApp,
            "Date Registered To App" : dateArtistRegisteredToApp,
            "Spotify Profile URL" : spotifyProfileURL,
            "Spotify Profile Image URL" : spotifyProfileImageURL,
            "Linked To Account" : linkedToAccount,
            "Spotify Id" : spotifyId,
            "Songs": [],
            "Albums": [],
            "Videos": [],
            "Beats": [],
            "Instrumentals": [],
            "Active Status": false
        ]
        
        let RequiredRef = Database.database().reference().child("Registered Artists").child(artistRandomKey)
        if let legal = personLegal {
            RequiredRef.child("Legal Name").setValue(legal)
        }
        RequiredRef.updateChildValues(RequiredInfoMap) { [weak self] (error, songRef) in
            guard let strongSelf = self else {return}
            if let error = error {
                print("📕 Failed to upload dictionary to database: \(error)")
                completion(false)
                return
            } else {
                Database.database().reference().child("All Content IDs").observeSingleEvent(of: .value, with: {[weak self] snap in
                    guard let strongSelf = self else {return}
                    var arr = snap.value as! [String]
                    if !arr.contains("\(strongSelf.toneDeafAppId)") {
                        arr.append("\(strongSelf.toneDeafAppId)")
                    }
                    Database.database().reference().child("All Content IDs").setValue(arr)
                })
            
                Database.database().reference().child("Registered Artists").child("All Artist IDs").observeSingleEvent(of: .value, with: {[weak self] snap in
                    guard let strongSelf = self else {return}
                    var arr = snap.value as! [String]
                    if !arr.contains("\(strongSelf.toneDeafAppId)") {
                        arr.append("\(strongSelf.toneDeafAppId)")
                    }
                    Database.database().reference().child("Registered Artists").child("All Artist IDs").setValue(arr)
                })
                completion(true)
                return
            }
        }
        
       
    }
    
    func savePersonInfoToDatabase(completion: @escaping ((Bool) -> Void)) {
        let personRandomKey = ("\(personName)--\(dateArtistRegisteredToApp)--\(timeArtistRegisteredToApp)--\(toneDeafAppId)")
        
        var RequiredInfoMap = [String : Any]()
        RequiredInfoMap = [
            "Name" : personName,
            "Tone Deaf App Id" : toneDeafAppId,
            "Alternate Names" : altpersonName,
            "Main Role" : role,
            "Followers" : personFollowers,
            "Time Registered To App" : timeArtistRegisteredToApp,
            "Date Registered To App" : dateArtistRegisteredToApp,
            "Spotify": [
                "URL": spotifyProfileURL,
                "Profile Image URL" : spotifyProfileImageURL,
                "id" : spotifyId,
                "Active Status": false
            ],
            "Linked To Account" : linkedToAccount,
            "Songs": [],
            "Albums": [],
            "Videos": [],
            "Beats": [],
            "Instrumentals": [],
            "Active Status": false,
            "Verification Level": String(verificationLevel),
            "Industry Certified": industryCertification
        ]
        
        let RequiredRef = Database.database().reference().child("Registered Persons").child(personRandomKey)
        if let legal = personLegal {
            RequiredRef.child("Legal Name").setValue(legal)
        }
        RequiredRef.updateChildValues(RequiredInfoMap) { [weak self] (error, songRef) in
            guard let strongSelf = self else {return}
            if let error = error {
                print("📕 Failed to upload dictionary to database: \(error)")
                Utilities.showError2("Failed to Upload. Please try again.", actionText: "OK")
                return
            } else {
                completion(true)
            }
        }
        
            Database.database().reference().child("All Content IDs").observeSingleEvent(of: .value, with: {[weak self] snap in
                guard let strongSelf = self else {return}
                var arr = snap.value as! [String]
                if !arr.contains("\(strongSelf.toneDeafAppId)") {
                    arr.append("\(strongSelf.toneDeafAppId)")
                }
                Database.database().reference().child("All Content IDs").setValue(arr)
            })
        
        Database.database().reference().child("Registered Persons").child("All Person IDs").observeSingleEvent(of: .value, with: {[weak self] snap in
            guard let strongSelf = self else {return}
            if !(snap.value is NSNull) {
                var arr = snap.value as! [String]
                if !arr.contains("\(strongSelf.toneDeafAppId)") {
                    arr.append("\(strongSelf.toneDeafAppId)")
                }
                Database.database().reference().child("Registered Persons").child("All Person IDs").setValue(arr)
            }
            else {
                let arr = ["\(strongSelf.toneDeafAppId)"]
                Database.database().reference().child("Registered Persons").child("All Person IDs").setValue(arr)
            }
        })
        
        
    }
    
    
    
    func getArtistData(personids:[String], completion: @escaping (Array<String>) -> Void) {
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
    
    func timeFormatted(totalSeconds: Int) -> String {
        let seconds: Int = totalSeconds % 60
        let minutes: Int = (totalSeconds / 60) % 60
        //let hours: Int = totalSeconds / 3600
        return String(format: "%02d:%02d", minutes, seconds)
    }
}

public enum SpotifyMultipleTrackErrors: Error {
    case status400
}

public enum SpotifyArtistErrors: Error {
    case status400
    case status401
    case status404
}
