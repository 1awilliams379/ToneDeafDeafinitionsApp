//
//  AppleMusicRequest.swift
//  ToneDeafDeafinitionsApp
//
//  Created by Tone Deaf on 8/21/20.
//  Copyright © 2020 GITEM Solutions. All rights reserved.
//

import Foundation

import Foundation
import Alamofire
import FirebaseDatabase
import StoreKit
import MusicKit
import SwiftJWT

public class AppleMusicRequest {
    
    let accessToken = "eyJhbGciOiJFUzI1NiIsInR5cCI6IkpXVCIsImtpZCI6IjlHSFNXWDdTUkwifQ.eyJpYXQiOjE2NTU4Nzg5MTYsImV4cCI6MTY3MTQzMDkxNiwiaXNzIjoiUlczSkREWjZVRyJ9.pYB1A-eS-bVTwg6y2gkMRGrFQlks7-WNinOmhHUiRDX1au7mz46eC9o3vxobU12RLs_TgkYSyFEjngBTOEECQA"
    
    var toneDeafAppId = ""
    var instrumentals:[String] = []
    var albums:[String] = []
    var beats:[String] = []
    var songName = ""
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
    
    var appleName = ""
    var appleSongURL = ""
    var appleDuration = ""
    var appleDateAPPL = ""
    var appleDateIA = ""
    var appleTimeIA = ""
    var appleArtworkURL = ""
    var appleArtist = ""
    var appleExplicity = false
    var appleISRC = ""
    var appleAlbumName = ""
    var applePreviewURL = ""
    var applecomposers = ""
    var appleGenres:Array<String> = []
    var appleFavorites = 0
    var appleTrackNumber = 0
    var appleMusicId = ""
    
    var dateArtistRegisteredToApp = ""
    var timeArtistRegisteredToApp = ""
    var appleProfileURL = ""
    var linkedToAccount:String?
    var artistFollowers = 0
    var appleAllPersonAlbumIds:Array<String> = []
    var songsByPerson:Array<String> = []
    var videosWithPerson:Array<String> = []
    var albumsByPerson:Array<String> = []
    
    var verificationLevel:Character!
    var industryCertification:Bool!
    var explicit:Bool!
    
    var authToken = ""
    
    static let shared = AppleMusicRequest()
    
//    func generateAppleToken() {
//        let myHeader = Header(kid: "Z75UTTFF46")
//        let claims = JWTClaim(iss: "RW3JDDZ6UG", iat: Date(), exp: Date() + 60 * 60 * 24 * 100)
//        var jwt = SwiftJWT.JWT(header: myHeader, claims: claims)
//
//        guard let tokenData = authToken.data(using: .utf8) else {return}
//
//        do {
//            let token = try jwt.sign(using: .es256(privateKey: tokenData))
//            UserDefaults.standard.set(token, forKey: "appleKey")
//        }
//        catch {
//            print(error?.localizedDescription)
//        }
//    }
    
    func getAppleMusicSong(id: String, name: String, artists: Array<String>, producers: Array<String>, writers: Array<String>, mixEngineer: Array<String>, masteringEngineer: Array<String>, recordingEngineer: Array<String>, dateobj:Date, appid: String, instsongid: String, instrContentRandomKey: String, certifi:Bool?, verifi:Character, explicit:Bool?, completion: @escaping ((Bool) -> Void)) {
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
            strongSelf.appleMusicId = id
            strongSelf.appleName = ""
            strongSelf.appleSongURL = ""
            strongSelf.appleDuration = ""
            strongSelf.appleDateAPPL = ""
            strongSelf.appleDateIA = ""
            strongSelf.appleTimeIA = ""
            strongSelf.appleArtworkURL = ""
            strongSelf.appleArtist = ""
            strongSelf.appleExplicity = false
            strongSelf.appleISRC = ""
            strongSelf.appleAlbumName = ""
            strongSelf.applePreviewURL = ""
            strongSelf.applecomposers = ""
            strongSelf.appleGenres = []
            strongSelf.appleFavorites = 0
            strongSelf.albums = []
            strongSelf.industryCertification = certifi
            strongSelf.verificationLevel = verifi
            strongSelf.explicit = explicit
            
            strongSelf.songEngineers = GlobalFunctions.shared.mergeArrays(strongSelf.songMixEngineer,strongSelf.songMasteringEngineer,strongSelf.songRecordingEngineer)
            strongSelf.songPersonsInvolved = GlobalFunctions.shared.mergeArrays(artists,producers,writers,mixEngineer,masteringEngineer,recordingEngineer)
            
            let resourceURL = "https://api.music.apple.com/v1/catalog/us/songs/\(id)"
            
            AF.request(resourceURL, method: .get, parameters: nil, encoding: URLEncoding.default, headers: ["Authorization":"Bearer \(strongSelf.accessToken)"]).responseJSON { [weak self] response in
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
                        completion(false)
                        return
                    case 401:
                        print("error with response status: \(status)")
                        print(response.response.value)
                        completion(false)
                        return
                    case 404:
                        print("error with response status: \(status)")
                        print(response.response.value)
                        completion(false)
                        return
                    case 405:
                        print("error with response status: \(status)")
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
                    //print("Response from Apple: \(jsonResult)")
                    let data  = jsonResult["data"] as! Array<JSONObject>
                    for i in 0 ..< data.count {
                        let attributes = data[i]["attributes"] as! JSONObject
                        //print(attributes)
                        
                        strongSelf.appleName = attributes["name"] as! String
                        strongSelf.appleAlbumName = attributes["albumName"] as! String
                        strongSelf.appleArtist = attributes["artistName"] as! String
                        strongSelf.appleSongURL = attributes["url"] as! String
                        strongSelf.appleTrackNumber = attributes["trackNumber"] as! Int
                        if attributes["composerName"] != nil {
                            strongSelf.applecomposers = attributes["composerName"] as! String
                        }
                        
                        if attributes["contentRating"] != nil {
                            let explicity = attributes["contentRating"] as! String
                            if explicity == "explicit" {
                                strongSelf.appleExplicity = true
                            }
                        }
                        strongSelf.appleISRC = attributes["isrc"] as! String
                        
                        let unpardate = attributes["releaseDate"] as! String
                        let words = unpardate.split(separator: "-")
                        let parsedYear = words[0]
                        let parsedMonth = words[1].replacingOccurrences(of: "08", with: "August").replacingOccurrences(of: "01", with: "January").replacingOccurrences(of: "02", with: "February").replacingOccurrences(of: "03", with: "March").replacingOccurrences(of: "04", with: "April").replacingOccurrences(of: "05", with: "May").replacingOccurrences(of: "06", with: "June").replacingOccurrences(of: "07", with: "July").replacingOccurrences(of: "09", with: "September").replacingOccurrences(of: "10", with: "October").replacingOccurrences(of: "11", with: "November").replacingOccurrences(of: "12", with: "December")
                        let parsedDay = words[2]
                        strongSelf.appleDateAPPL = "\(parsedMonth) \(parsedDay), \(parsedYear)"
                        
                        let unparduration = attributes["durationInMillis"] as! Int
                        let durationInSeconds = (unparduration/1000)
                        let durationInSecondsRound = Int(roundf(Float(durationInSeconds))/1)
                        let durationInMinues = strongSelf.timeFormatted(totalSeconds: durationInSecondsRound)
                        strongSelf.appleDuration = durationInMinues
                        
                        strongSelf.appleGenres = attributes["genreNames"] as! Array<String>
                        
                        let pre = attributes["previews"] as! Array<JSONObject>
                        strongSelf.applePreviewURL = pre[0]["url"] as! String
                        
                        let art = attributes["artwork"] as! JSONObject
                        strongSelf.appleArtworkURL = art["url"] as! String
                        //print(strongSelf.appleArtworkURL)
                        
                        let date = dateobj
                        let formatter = DateFormatter()
                        formatter.timeZone = TimeZone(identifier: "EDT")
                        formatter.dateFormat = "MMMM dd, yyyy"
                        strongSelf.appleDateIA = formatter.string(from: date)
                        //print("📙 current date: \(currentDate)")
                        
                        let time = dateobj
                        let timeFormatter = DateFormatter()
                        timeFormatter.dateFormat = "HH:mm:ss a"
                        timeFormatter.timeZone = TimeZone(identifier: "EDT")
                        strongSelf.appleTimeIA = timeFormatter.string(from: time)
                        //print("📙 current time: \(currentTime)")
                        
                    }
                    ////
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
                    completion(false)
                    return
                }
            }
        }
        //print("Im not supposed to be here")
    }
    
    typealias AppleTrackCompletion = (Result<AppleMusicSongData, Error>) -> Void
    func getAppleMusicSong(id: String, completion: @escaping AppleTrackCompletion) {
        DispatchQueue.global().async { [weak self] in
            guard let strongSelf = self else {return}
            let resourceURL = "https://api.music.apple.com/v1/catalog/us/songs/\(id)"
            //print(resourceURL)
            AF.request(resourceURL, method: .get, parameters: nil, encoding: URLEncoding.default, headers: ["Authorization":"Bearer \(strongSelf.accessToken)"]).responseJSON { [weak self] response in
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
                        completion(.failure(AppleMultipleTrackErrors.status400))
                        return
                    case 401:
                        print("error with response status: \(status)")
                        print(response.response.value)
                        completion(.failure(AppleMultipleTrackErrors.status400))
                        return
                    case 404:
                        print("error with response status: \(status)")
                        print(response.response.value)
                        completion(.failure(AppleMultipleTrackErrors.status400))
                        return
                    case 405:
                        print("error with response status: \(status)")
                        print(response.response.value)
                        completion(.failure(AppleMultipleTrackErrors.status400))
                        return
                    default:
                        print("error with response status: \(status)")
                        print(response.response.value)
                        completion(.failure(AppleMultipleTrackErrors.status400))
                        return
                    }
                }
                do {
                typealias JSONObject = [String:AnyObject]
                if let jsonResult = try JSONSerialization.jsonObject(with: response.data!, options: JSONSerialization.ReadingOptions.allowFragments) as? [String : AnyObject] {
                    //print("Response from Apple: \(jsonResult)")
                    let data  = jsonResult["data"] as! Array<JSONObject>
                    for i in 0 ..< data.count {
                        let song = AppleMusicSongData(appleName: "", appleSongURL: "", appleDuration: "", appleDateAPPL: "", appleDateIA: "", appleTimeIA: "", appleArtworkURL: "", appleArtist: "", appleExplicity: false, appleISRC: "", appleAlbumName: "", applePreviewURL: "", applecomposers: "", appleTrackNumber: 0, appleGenres: [], appleFavorites: 0, appleMusicId: "", isActive: false)
                        let attributes = data[i]["attributes"] as! JSONObject
                        //print(attributes)
                        
                        song.appleName = attributes["name"] as! String
                        
                        song.appleAlbumName = attributes["albumName"] as! String
                        song.appleArtist = attributes["artistName"] as! String
                        song.appleSongURL = attributes["url"] as! String
                        song.appleTrackNumber = attributes["trackNumber"] as! Int
                        if attributes["composerName"] != nil {
                            song.applecomposers = attributes["composerName"] as! String
                        }
                        
                        if attributes["contentRating"] != nil {
                            let explicity = attributes["contentRating"] as! String
                            if explicity == "explicit" {
                                song.appleExplicity = true
                            }
                        }
                        song.appleISRC = attributes["isrc"] as! String
                        
                        let unpardate = attributes["releaseDate"] as! String
                        let words = unpardate.split(separator: "-")
                        let parsedYear = words[0]
                        let parsedMonth = words[1].replacingOccurrences(of: "08", with: "August").replacingOccurrences(of: "01", with: "January").replacingOccurrences(of: "02", with: "February").replacingOccurrences(of: "03", with: "March").replacingOccurrences(of: "04", with: "April").replacingOccurrences(of: "05", with: "May").replacingOccurrences(of: "06", with: "June").replacingOccurrences(of: "07", with: "July").replacingOccurrences(of: "09", with: "September").replacingOccurrences(of: "10", with: "October").replacingOccurrences(of: "11", with: "November").replacingOccurrences(of: "12", with: "December")
                        let parsedDay = words[2]
                        song.appleDateAPPL = "\(parsedMonth) \(parsedDay), \(parsedYear)"
                        
                        let unparduration = attributes["durationInMillis"] as! Int
                        let durationInSeconds = (unparduration/1000)
                        let durationInSecondsRound = Int(roundf(Float(durationInSeconds))/1)
                        let durationInMinues = strongSelf.timeFormatted(totalSeconds: durationInSecondsRound)
                        song.appleDuration = durationInMinues
                        
                        song.appleGenres = attributes["genreNames"] as! Array<String>
                        
                        let pre = attributes["previews"] as! Array<JSONObject>
                        song.applePreviewURL = pre[0]["url"] as! String
                        
                        let art = attributes["artwork"] as! JSONObject
                        song.appleArtworkURL = art["url"] as! String
                        
                        let date = Date()
                        let formatter = DateFormatter()
                        formatter.timeZone = TimeZone(identifier: "EDT")
                        formatter.dateFormat = "MMMM dd, yyyy"
                        song.appleDateIA = formatter.string(from: date)
                        //print("📙 current date: \(currentDate)")
                        
                        let time = Date()
                        let timeFormatter = DateFormatter()
                        timeFormatter.dateFormat = "HH:mm:ss a"
                        timeFormatter.timeZone = TimeZone(identifier: "EDT")
                        song.appleTimeIA = timeFormatter.string(from: time)
                        completion(.success(song))
                    }
                    }
                } catch {
                    completion(.failure(error))
                    return
                }
            }
        }
        //print("Im not supposed to be here")
    }
    
    typealias AppleAlbumCompletion = (Result<AppleAlbumData, Error>) -> Void
    func getAppleMusicAlbum(id: String, completion: @escaping AppleAlbumCompletion) {
        DispatchQueue.global().async { [weak self] in
            guard let strongSelf = self else {return}
            let resourceURL = "https://api.music.apple.com/v1/catalog/us/albums/\(id)"
            //print(resourceURL)
            AF.request(resourceURL, method: .get, parameters: nil, encoding: URLEncoding.default, headers: ["Authorization":"Bearer \(strongSelf.accessToken)"]).responseJSON { [weak self] response in
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
                        completion(.failure(AppleMultipleTrackErrors.status400))
                        return
                    case 401:
                        print("error with response status: \(status)")
                        print(response.response.value)
                        completion(.failure(AppleMultipleTrackErrors.status400))
                        return
                    case 404:
                        print("error with response status: \(status)")
                        print(response.response.value)
                        completion(.failure(AppleMultipleTrackErrors.status400))
                        return
                    case 405:
                        print("error with response status: \(status)")
                        print(response.response.value)
                        completion(.failure(AppleMultipleTrackErrors.status400))
                        return
                    default:
                        print("error with response status: \(status)")
                        print(response.response.value)
                        completion(.failure(AppleMultipleTrackErrors.status400))
                        return
                    }
                }
                do {
                typealias JSONObject = [String:AnyObject]
                if let jsonResult = try JSONSerialization.jsonObject(with: response.data!, options: JSONSerialization.ReadingOptions.allowFragments) as? [String : AnyObject] {
                    //print("Response from Apple: \(jsonResult)")
                    let data  = jsonResult["data"] as! Array<JSONObject>
                    for i in 0 ..< data.count {
                        let album = AppleAlbumData(name: "", toneDeafAppId: "", dateReleasedApple: "", dateIA: "", timeIA: "", imageURL: "", trackCount: 0, artist: "", url: "", appleId: "", isActive: false)
                        let attributes = data[i]["attributes"] as! JSONObject
                        //print(attributes)
                        
                        album.name = attributes["name"] as! String
                        
                        album.trackCount = attributes["trackCount"] as! Int
                        album.artist = attributes["artistName"] as! String
                        album.url = attributes["url"] as! String
                        album.appleId = data[i]["id"] as! String
                        let unpardate = attributes["releaseDate"] as! String
                        let words = unpardate.split(separator: "-")
                        let parsedYear = words[0]
                        let parsedMonth = words[1].replacingOccurrences(of: "08", with: "August").replacingOccurrences(of: "01", with: "January").replacingOccurrences(of: "02", with: "February").replacingOccurrences(of: "03", with: "March").replacingOccurrences(of: "04", with: "April").replacingOccurrences(of: "05", with: "May").replacingOccurrences(of: "06", with: "June").replacingOccurrences(of: "07", with: "July").replacingOccurrences(of: "09", with: "September").replacingOccurrences(of: "10", with: "October").replacingOccurrences(of: "11", with: "November").replacingOccurrences(of: "12", with: "December")
                        let parsedDay = words[2]
                        album.dateReleasedApple = "\(parsedMonth) \(parsedDay), \(parsedYear)"
                        let art = attributes["artwork"] as! JSONObject
                        album.imageURL = art["url"] as! String
                        completion(.success(album))
                    }
                    }
                } catch {
                    completion(.failure(error))
                    return
                }
            }
        }
        //print("Im not supposed to be here")
    }
    
    typealias AppleMultipleTrackCompletion = (Result<[AppleMusicSongData], Error>) -> Void
    func getAppleMusicMultipleSongs(songids: [String], completion: @escaping AppleMultipleTrackCompletion) {
        DispatchQueue.global().async { [weak self] in
            guard let strongSelf = self else {return}
            var appleDataArray:[AppleMusicSongData] = []
            let resourceURL = "https://api.music.apple.com/v1/catalog/us/songs?ids=\(songids.joined(separator: ","))"
            //print(resourceURL)
            AF.request(resourceURL, method: .get, parameters: nil, encoding: URLEncoding.default, headers: ["Authorization":"Bearer \(strongSelf.accessToken)"]).responseJSON { [weak self] response in
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
                        completion(.failure(AppleMultipleTrackErrors.status400))
                        return
                    case 401:
                        print("error with response status: \(status)")
                        print(response.response.value)
                        completion(.failure(AppleMultipleTrackErrors.status400))
                        return
                    case 404:
                        print("error with response status: \(status)")
                        print(response.response.value)
                        completion(.failure(AppleMultipleTrackErrors.status400))
                        return
                    case 405:
                        print("error with response status: \(status)")
                        print(response.response.value)
                        completion(.failure(AppleMultipleTrackErrors.status400))
                        return
                    default:
                        print("error with response status: \(status)")
                        print(response.response.value)
                        completion(.failure(AppleMultipleTrackErrors.status400))
                        return
                    }
                }
                do {
                typealias JSONObject = [String:AnyObject]
                if let jsonResult = try JSONSerialization.jsonObject(with: response.data!, options: JSONSerialization.ReadingOptions.allowFragments) as? [String : AnyObject] {
                    //print("Response from Apple: \(jsonResult)")
                    let data  = jsonResult["data"] as! Array<JSONObject>
                    for i in 0 ..< data.count {
                        let song = AppleMusicSongData(appleName: "", appleSongURL: "", appleDuration: "", appleDateAPPL: "", appleDateIA: "", appleTimeIA: "", appleArtworkURL: "", appleArtist: "", appleExplicity: false, appleISRC: "", appleAlbumName: "", applePreviewURL: "", applecomposers: "", appleTrackNumber: 0, appleGenres: [], appleFavorites: 0, appleMusicId: "", isActive: false)
                        let attributes = data[i]["attributes"] as! JSONObject
                        //print(attributes)
                        
                        song.appleName = attributes["name"] as! String
                        
                        song.appleAlbumName = attributes["albumName"] as! String
                        song.appleArtist = attributes["artistName"] as! String
                        song.appleSongURL = attributes["url"] as! String
                        song.appleTrackNumber = attributes["trackNumber"] as! Int
                        if attributes["composerName"] != nil {
                            song.applecomposers = attributes["composerName"] as! String
                        }
                        
                        if attributes["contentRating"] != nil {
                            let explicity = attributes["contentRating"] as! String
                            if explicity == "explicit" {
                                song.appleExplicity = true
                            }
                        }
                        song.appleISRC = attributes["isrc"] as! String
                        
                        let unpardate = attributes["releaseDate"] as! String
                        let words = unpardate.split(separator: "-")
                        let parsedYear = words[0]
                        let parsedMonth = words[1].replacingOccurrences(of: "08", with: "August").replacingOccurrences(of: "01", with: "January").replacingOccurrences(of: "02", with: "February").replacingOccurrences(of: "03", with: "March").replacingOccurrences(of: "04", with: "April").replacingOccurrences(of: "05", with: "May").replacingOccurrences(of: "06", with: "June").replacingOccurrences(of: "07", with: "July").replacingOccurrences(of: "09", with: "September").replacingOccurrences(of: "10", with: "October").replacingOccurrences(of: "11", with: "November").replacingOccurrences(of: "12", with: "December")
                        let parsedDay = words[2]
                        song.appleDateAPPL = "\(parsedMonth) \(parsedDay), \(parsedYear)"
                        
                        let unparduration = attributes["durationInMillis"] as! Int
                        let durationInSeconds = (unparduration/1000)
                        let durationInSecondsRound = Int(roundf(Float(durationInSeconds))/1)
                        let durationInMinues = strongSelf.timeFormatted(totalSeconds: durationInSecondsRound)
                        song.appleDuration = durationInMinues
                        
                        song.appleGenres = attributes["genreNames"] as! Array<String>
                        
                        let pre = attributes["previews"] as! Array<JSONObject>
                        song.applePreviewURL = pre[0]["url"] as! String
                        
                        let art = attributes["artwork"] as! JSONObject
                        song.appleArtworkURL = art["url"] as! String
                        
                        appleDataArray.append(song)
                    }
                    completion(.success(appleDataArray))
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
            let categorty = "\(songContentTag)--\(strongSelf.songName)--\(strongSelf.toneDeafAppId)"
                        let appleContentRandomKey = ("\(appleMusicContentType)--\(strongSelf.songName)--\(strongSelf.appleDateIA)--\(strongSelf.appleTimeIA)")
                    

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
                        "Date Registered To App": strongSelf.appleDateIA,
                        "Time Registered To App": strongSelf.appleTimeIA,
                        "Verification Level": String(strongSelf.verificationLevel),
                        "Industry Certified": strongSelf.industryCertification,
                        "Explicit": strongSelf.explicit,
                        "Active Status" : false
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
                        "Name" : strongSelf.appleName,
                        "Artist" : strongSelf.appleArtist,
                        "Explicity" : strongSelf.appleExplicity,
                        "Preview URL" : strongSelf.applePreviewURL,
                        "ISRC" : strongSelf.appleISRC,
                        "Date Released On Apple" : strongSelf.appleDateAPPL,
                        "Time Uploaded To App" : strongSelf.appleTimeIA,
                        "Date Uploaded To App" : strongSelf.appleDateIA,
                        "Duration" : strongSelf.appleDuration,
                        "Artwork URL" : strongSelf.appleArtworkURL,
                        "Song URL" : strongSelf.appleSongURL,
                        "Album Name" : strongSelf.appleAlbumName,
                        "Composers" : strongSelf.applecomposers,
                        "Genres" : strongSelf.appleGenres,
                        "Number of Favorites" : strongSelf.appleFavorites,
                        "Track Number" : strongSelf.appleTrackNumber,
                        "Apple Music Id" : strongSelf.appleMusicId,
                        "Active Status": false
                    ]

                        let SongRef = Database.database().reference().child("Music Content").child("Songs").child(categorty).child(appleContentRandomKey)

                        SongRef.updateChildValues(SongInfoMap) { [weak self] (error, songRef) in
                            guard let strongSelf = self else {return}
                            if let error = error {
                                print("📕 Failed to upload dictionary to database: \(error)")
                                completion(false)
                                return
                            } else {
                                completion(true)
                                print("📗 Apple data for \(strongSelf.songName) saved to database successfully.")
                                return
                            }
                        }
        })
    }
    
    func saveInstrumentalInfoToDatabase(instrContentRandomKey: String, completion: @escaping ((Bool) -> Void)) {
        getPersonData(personids: songArtistsIDs, completion: {[weak self] artistNames in
        guard let strongSelf = self else {return}
            strongSelf.songArtistsNames = artistNames
                        let appleContentRandomKey = ("\(appleMusicContentType)--\(strongSelf.songName)--\(strongSelf.appleDateIA)--\(strongSelf.appleTimeIA)")
                    

                    
                    
                    

                    var SongInfoMap = [String : Any]()
                    SongInfoMap = [
                        "Name" : strongSelf.appleName,
                        "Artist" : strongSelf.appleArtist,
                        "Explicity" : strongSelf.appleExplicity,
                        "Preview URL" : strongSelf.applePreviewURL,
                        "ISRC" : strongSelf.appleISRC,
                        "Date Released On Apple" : strongSelf.appleDateAPPL,
                        "Time Uploaded To App" : strongSelf.appleTimeIA,
                        "Date Uploaded To App" : strongSelf.appleDateIA,
                        "Duration" : strongSelf.appleDuration,
                        "Artwork URL" : strongSelf.appleArtworkURL,
                        "Song URL" : strongSelf.appleSongURL,
                        "Album Name" : strongSelf.appleAlbumName,
                        "Composers" : strongSelf.applecomposers,
                        "Genres" : strongSelf.appleGenres,
                        "Number of Favorites" : strongSelf.appleFavorites,
                        "Track Number" : strongSelf.appleTrackNumber,
                        "Apple Music Id" : strongSelf.appleMusicId,
                        "Active Status": false
                    ]

                        let SongRef = Database.database().reference().child("Music Content").child("Instrumentals").child(instrContentRandomKey).child(appleContentRandomKey)

                        SongRef.updateChildValues(SongInfoMap) { [weak self] (error, songRef) in
                            guard let strongSelf = self else {return}
                            if let error = error {
                                print("📕 Failed to upload dictionary to database: \(error)")
                                completion(false)
                                return
                            } else {
                                completion(true)
                                print("📗 Apple data for \(strongSelf.songName) saved to database successfully.")
                                return
                            }
                        }
        })
    }
    
    typealias AppleArtistCompletion = (Result<Bool, Error>) -> Void
    func getAppleMusicArtist(id: String, name: String, altName: Array<String>, mainRole: String, dateobj:Date, appid:String, legal: String?, tag:String, certifi:Bool?, verifi:Character, completion: @escaping AppleArtistCompletion){
        personName = name
        personLegal = legal
        altPersonName = altName
        appleMusicId = id
        songsByPerson = []
        albumsByPerson = []
        toneDeafAppId = appid
        appleAllPersonAlbumIds = []
        videosWithPerson = []
        beats = []
        role = mainRole
        industryCertification = certifi
        verificationLevel = verifi
        
        let accessToken = "eyJhbGciOiJFUzI1NiIsInR5cCI6IkpXVCIsImtpZCI6IjlHSFNXWDdTUkwifQ.eyJpYXQiOjE2NTU4Nzg5MTYsImV4cCI6MTY3MTQzMDkxNiwiaXNzIjoiUlczSkREWjZVRyJ9.pYB1A-eS-bVTwg6y2gkMRGrFQlks7-WNinOmhHUiRDX1au7mz46eC9o3vxobU12RLs_TgkYSyFEjngBTOEECQA"
        let resourceURL = "https://api.music.apple.com/v1/catalog/us/artists/\(id)"
        
        AF.request(resourceURL, method: .get, parameters: nil, encoding: URLEncoding.default, headers: ["Authorization":"Bearer \(accessToken)"]).responseJSON { [weak self] response in
            guard let strongSelf = self else {return}
            if let status = response.response?.statusCode {
                switch(status){
                case 200:
                    print("example success")
                                        //print(response.result)
                                    //print(response.data)
                case 400:
                    print("error with response status: \(status)")
                    print(response.response.value)
                    completion(.failure(AppleArtistErrors.status400(response.response.debugDescription)))
                    return
                case 401:
                    print("error with response status: \(status)")
                    print(response.response.value)
                    completion(.failure(AppleArtistErrors.status401(response.response.debugDescription)))
                    return
                case 404:
                    print("error with response status: \(status)")
                    print(response.response.value)
                    completion(.failure(AppleArtistErrors.status404(response.response.debugDescription)))
                    return
                case 405:
                    print("error with response status: \(status)")
                    print(response.response.value)
                    completion(.failure(AppleArtistErrors.status405(response.response.debugDescription)))
                    return
                default:
                    print("error with response status: \(status)")
                    print(response.response.value)
                    completion(.failure(AppleArtistErrors.status401(response.response.debugDescription)))
                    return
                }
                do {
                    typealias JSONObject = [String:AnyObject]
                    if let jsonResult = try JSONSerialization.jsonObject(with: response.data!, options: JSONSerialization.ReadingOptions.allowFragments) as? [String : AnyObject] {
                        print("Response from Apple: \(jsonResult)")
                        
                        let data  = jsonResult["data"] as! Array<JSONObject>
                        for i in 0 ..< data.count {
                            let attributes = data[i]["attributes"] as! JSONObject
                            strongSelf.appleProfileURL = attributes["url"] as! String
                            let relationships = data[i]["relationships"] as! JSONObject
                            let albums = relationships["albums"] as! JSONObject
                            let albumdata = albums["data"] as! Array<JSONObject>
                            for i in 0 ..< albumdata.count {
                                strongSelf.appleAllPersonAlbumIds.append(albumdata[i]["id"] as! String)
                            }
                        }
                        
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
                                completion(.failure(AppleArtistErrors.status400("Apple Person Upload Err")))
                                return
                            }
                        })
                    }
                } catch (let error){
                    completion(.failure(AppleArtistErrors.jSONParse(error.localizedDescription)))
                }
            }
        }
    }
    
    typealias AppleArtistEditCompletion = (Result<AppleMusicPersonData, Error>) -> Void
    func getAppleMusicArtist(id: String, person:PersonData, completion: @escaping AppleArtistEditCompletion){
        let resourceURL = "https://api.music.apple.com/v1/catalog/us/artists/\(id)"
        let apple = AppleMusicPersonData(url: "", isActive: false, id: "", allAlbumIDs: nil)
        AF.request(resourceURL, method: .get, parameters: nil, encoding: URLEncoding.default, headers: ["Authorization":"Bearer \(accessToken)"]).responseJSON { [weak self] response in
            guard let strongSelf = self else {return}
            if let status = response.response?.statusCode {
                switch(status){
                case 200:
                    print("example success")
                                        //print(response.result)
                                    //print(response.data)
                case 400:
                    print("error with response status: \(status)")
                    print(response.response.value)
                    completion(.failure(AppleArtistErrors.status400(response.response.debugDescription)))
                    return
                case 401:
                    print("error with response status: \(status)")
                    print(response.response.value)
                    completion(.failure(AppleArtistErrors.status401(response.response.debugDescription)))
                    return
                case 404:
                    print("error with response status: \(status)")
                    print(response.response.value)
                    completion(.failure(AppleArtistErrors.status404(response.response.debugDescription)))
                    return
                case 405:
                    print("error with response status: \(status)")
                    print(response.response.value)
                    completion(.failure(AppleArtistErrors.status405(response.response.debugDescription)))
                    return
                default:
                    print("error with response status: \(status)")
                    print(response.response.value)
                    completion(.failure(AppleArtistErrors.status400(response.response.debugDescription)))
                    return
                }
                do {
                    typealias JSONObject = [String:AnyObject]
                    if let jsonResult = try JSONSerialization.jsonObject(with: response.data!, options: JSONSerialization.ReadingOptions.allowFragments) as? [String : AnyObject] {
                        print("Response from Apple: \(jsonResult)")
                        
                        let data  = jsonResult["data"] as! Array<JSONObject>
                        for i in 0 ..< data.count {
                            let attributes = data[i]["attributes"] as! JSONObject
                            apple.url = attributes["url"] as! String
                            let relationships = data[i]["relationships"] as! JSONObject
                            let albums = relationships["albums"] as! JSONObject
                            if let albumdata = albums["data"] as? Array<JSONObject> {
                                apple.allAlbumIDs = []
                                for i in 0 ..< albumdata.count {
                                    apple.allAlbumIDs!.append(albumdata[i]["id"] as! String)
                                }
                            }
                        }
                        apple.id = id
                        completion(.success(apple))
                    }
                } catch (let error){
                    completion(.failure(AppleArtistErrors.jSONParse(error.localizedDescription)))
                }
            }
        }
    }
    
    typealias AppleVideoCompletion = (Result<AppleVideoData, Error>) -> Void
    func getAppleMusicVideo(id: String, completion: @escaping AppleVideoCompletion) {
            DispatchQueue.global().async { [weak self] in
                guard let strongSelf = self else {return}
                let resourceURL = "https://api.music.apple.com/v1/catalog/us/music-videos/\(id)"
                //print(resourceURL)
                AF.request(resourceURL, method: .get, parameters: nil, encoding: URLEncoding.default, headers: ["Authorization":"Bearer \(strongSelf.accessToken)"]).responseJSON { [weak self] response in
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
                            completion(.failure(AppleMultipleTrackErrors.status400))
                            return
                        case 401:
                            print("error with response status: \(status)")
                            print(response.response.value)
                            completion(.failure(AppleMultipleTrackErrors.status400))
                            return
                        case 404:
                            print("error with response status: \(status)")
                            print(response.response.value)
                            completion(.failure(AppleMultipleTrackErrors.status400))
                            return
                        case 405:
                            print("error with response status: \(status)")
                            print(response.response.value)
                            completion(.failure(AppleMultipleTrackErrors.status400))
                            return
                        default:
                            print("error with response status: \(status)")
                            print(response.response.value)
                            completion(.failure(AppleMultipleTrackErrors.status400))
                            return
                        }
                    }
                    do {
                    typealias JSONObject = [String:AnyObject]
                    if let jsonResult = try JSONSerialization.jsonObject(with: response.data!, options: JSONSerialization.ReadingOptions.allowFragments) as? [String : AnyObject] {
                        print("Response from Apple: \(jsonResult)")
                        let data  = jsonResult["data"] as! Array<JSONObject>
                        for i in 0 ..< data.count {
                            let video = AppleVideoData(url: "", name: "", albumName: nil, artistName: "", isrc: "", duration: "", genres: [], explicity: false, previewURL: "", thumbnailURL: "", dateApple: "", trackNumber: nil, appleId: "", isActive: false)
                            let attributes = data[i]["attributes"] as! JSONObject
                            //print(attributes)

                            video.name = attributes["name"] as! String
                            if let alb = attributes["albumName"] as? String {
                                video.albumName = alb
                            }
                            video.artistName = attributes["artistName"] as! String
                            video.url = attributes["url"] as! String
                            if let tn = attributes["trackNumber"] as? Int {
                                video.trackNumber = tn
                            }

                            if attributes["contentRating"] != nil {
                                let explicity = attributes["contentRating"] as! String
                                if explicity == "explicit" {
                                    video.explicity = true
                                }
                            }
                            video.isrc = attributes["isrc"] as! String

                            let unpardate = attributes["releaseDate"] as! String
                            let words = unpardate.split(separator: "-")
                            let parsedYear = words[0]
                            let parsedMonth = words[1].replacingOccurrences(of: "08", with: "August").replacingOccurrences(of: "01", with: "January").replacingOccurrences(of: "02", with: "February").replacingOccurrences(of: "03", with: "March").replacingOccurrences(of: "04", with: "April").replacingOccurrences(of: "05", with: "May").replacingOccurrences(of: "06", with: "June").replacingOccurrences(of: "07", with: "July").replacingOccurrences(of: "09", with: "September").replacingOccurrences(of: "10", with: "October").replacingOccurrences(of: "11", with: "November").replacingOccurrences(of: "12", with: "December")
                            let parsedDay = words[2]
                            video.dateApple = "\(parsedMonth) \(parsedDay), \(parsedYear)"

                            let unparduration = attributes["durationInMillis"] as! Int
                            let durationInSeconds = (unparduration/1000)
                            let durationInSecondsRound = Int(roundf(Float(durationInSeconds))/1)
                            let durationInMinues = strongSelf.timeFormatted(totalSeconds: durationInSecondsRound)
                            video.duration = durationInMinues

                            video.genres = attributes["genreNames"] as! Array<String>

                            let pre = attributes["previews"] as! Array<JSONObject>
                            video.previewURL = pre[0]["url"] as! String

                            let art = attributes["artwork"] as! JSONObject
                            video.thumbnailURL = art["url"] as! String
                            completion(.success(video))
                        }
                        }
                    } catch {
                        completion(.failure(error))
                        return
                    }
                }
            }
    }

    
    func saveArtistInfoToDatabase(completion: @escaping ((Bool) -> Void)) {
            let artistRandomKey = ("\(personName)--\(dateArtistRegisteredToApp)--\(timeArtistRegisteredToApp)--\(toneDeafAppId)")
        
        var RequiredInfoMap = [String : Any]()
        RequiredInfoMap = [
            "Name" : personName,
            "Tone Deaf App Id" : toneDeafAppId,
            "Alternate Names" : altPersonName,
            "Followers" : artistFollowers,
            "Time Registered To App" : timeArtistRegisteredToApp,
            "Date Registered To App" : dateArtistRegisteredToApp,
            "Apple Profile URL" : appleProfileURL,
            "All Apple Album IDs" : appleAllPersonAlbumIds,
            "Linked To Account" : linkedToAccount,
            "Apple Music Id" : appleMusicId,
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
                Utilities.showError2("Failed to Upload. Please try again.", actionText: "OK")
                return
            } else {
                Database.database().reference().child("All Content IDs").observeSingleEvent(of: .value, with: {[weak self] snap in
                    guard let strongSelf = self else {return}
                    var arr = snap.value as! [String]
                    if !arr.contains("\(strongSelf.toneDeafAppId)") {
                        arr.append("\(strongSelf.toneDeafAppId)")
                    }
                    Database.database().reference().child("All Content IDs").setValue(arr)
                    completion(true)
                })
                Database.database().reference().child("Registered Artists").child("All Artist IDs").observeSingleEvent(of: .value, with: {[weak self] snap in
                    guard let strongSelf = self else {return}
                    var arr = snap.value as! [String]
                    if !arr.contains("\(strongSelf.toneDeafAppId)") {
                        arr.append("\(strongSelf.toneDeafAppId)")
                    }
                    Database.database().reference().child("Registered Artists").child("All Artist IDs").setValue(arr)
                    completion(true)
                    return
                })
            }
        }
    }
    
    func savePersonInfoToDatabase(completion: @escaping ((Bool) -> Void)) {
            let personRandomKey = ("\(personName)--\(dateArtistRegisteredToApp)--\(timeArtistRegisteredToApp)--\(toneDeafAppId)")
                
        var RequiredInfoMap = [String : Any]()
        RequiredInfoMap = [
            "Name" : personName,
            "Tone Deaf App Id" : toneDeafAppId,
            "Alternate Names" : altPersonName,
            "Main Role": role,
            "Followers" : artistFollowers,
            "Time Registered To App" : timeArtistRegisteredToApp,
            "Date Registered To App" : dateArtistRegisteredToApp,
            "Apple Music": [
                "URL": appleProfileURL,
                "All Album IDs" : appleAllPersonAlbumIds,
                "id" : appleMusicId,
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
                completion(false)
                return
            } else {
                Database.database().reference().child("All Content IDs").observeSingleEvent(of: .value, with: {snap in
                    var arr = snap.value as! [String]
                    if !arr.contains("\(strongSelf.toneDeafAppId)") {
                        arr.append("\(strongSelf.toneDeafAppId)")
                    }
                    Database.database().reference().child("All Content IDs").setValue(arr)
                })
            
                Database.database().reference().child("Registered Persons").child("All Person IDs").observeSingleEvent(of: .value, with: {snap in
                    
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
                completion(true)
            }
        }
       
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

public enum AppleMultipleTrackErrors: Error {
    case status400
}

public enum AppleArtistErrors: Error {
    case status400(String)
    case status401(String)
    case status404(String)
    case status405(String)
    case jSONParse(String)
}
