//
//  BeatsTableViewManager.swift
//  ToneDeafDeafinitionsApp
//
//  Created by Tone Deaf on 8/9/20.
//  Copyright © 2020 GITEM Solutions. All rights reserved.
//

import Foundation
import FirebaseDatabase

final class FilteringManager {
    
    static let shared = FilteringManager()
    
    deinit {
       print("📗beats table view manager being deallocated")
    }
    
    public func filterByTempoFree(slidervalue: Int, thumb: Int, completion: @escaping (([BeatData]) -> Void)) {
        let tempo = slidervalue
        let ref = Database.database().reference().child("Beats").child("Free")
        if thumb == 0 {
            let query = ref.queryOrdered(byChild: "Tempo").queryStarting(atValue: tempo)
            query.observeSingleEvent(of: .value, with: {[weak self] snapshot in
                guard let strongSelf = self else {
                    return
                }
                strongSelf.setupArrayForBeatsTableView(snapshot: snapshot, completion: { tempbeats in
                    completion(tempbeats)
                })
            })
        }
        if thumb == 1 {
            let query = ref.queryOrdered(byChild: "Tempo").queryEnding(atValue: tempo)
            query.observeSingleEvent(of: .value, with: {[weak self] snapshot in
                guard let strongSelf = self else {
                    return
                }
                strongSelf.setupArrayForBeatsTableView(snapshot: snapshot, completion: { tempbeats in
                    completion(tempbeats)
                })
            })
        }
    }
    
    public func filterByTempoFreeSpecified(tempo: Int, completion: @escaping (([BeatData]) -> Void)) {
        let ref = Database.database().reference().child("Beats").child("Free")
        let query = ref.queryOrdered(byChild: "Tempo").queryEqual(toValue: tempo)
        query.observeSingleEvent(of: .value, with: {[weak self] snapshot in
            guard let strongSelf = self else {
                return
            }
            strongSelf.setupArrayForBeatsTableView(snapshot: snapshot, completion: { tempbeats in
                completion(tempbeats)
            })
        })
    }
    
    public func filterByKeyFree(key: String, completion: @escaping (([BeatData]) -> Void)) {
        let ref = Database.database().reference().child("Beats").child("Free")
        let query = ref.queryOrdered(byChild: "Key").queryEqual(toValue: key)
        query.observeSingleEvent(of: .value, with: {[weak self] snapshot in
            guard let strongSelf = self else {
                return
            }
            strongSelf.setupArrayForBeatsTableView(snapshot: snapshot, completion: { tempbeats in
                completion(tempbeats)
            })
        })
    }
    
    public func filterByTypeFree(type: String, completion: @escaping (([BeatData]) -> Void)) {
        let ref = Database.database().reference().child("Beats").child("Free")
        let query = ref.queryOrdered(byChild: "\(type) Type").queryEqual(toValue: true)
        query.observeSingleEvent(of: .value, with: {[weak self] snapshot in
            guard let strongSelf = self else {
                return
            }
            strongSelf.setupArrayForBeatsTableView(snapshot: snapshot, completion: { tempbeats in
                completion(tempbeats)
            })
        })
    }
    
    public func filterBySoundsFree(sound: String, completion: @escaping (([BeatData]) -> Void)) {
        let ref = Database.database().reference().child("Beats").child("Free")
        let query = ref.queryOrdered(byChild: "\(sound) Sound").queryEqual(toValue: true)
        query.observeSingleEvent(of: .value, with: { [weak self] snapshot in
            guard let strongSelf = self else {
                return
            }
            strongSelf.setupArrayForBeatsTableView(snapshot: snapshot, completion: { tempbeats in
                completion(tempbeats)
            })
        })
    }
    
    public func setupArrayForBeatsTableView(snapshot: DataSnapshot, completion: @escaping (([BeatData]) -> Void)){
        var tempbeats: [BeatData] = []
        let beat = BeatData(duration: "", name: "", toneDeafAppId: "", producers: [""], date: "", downloads: 0, mp3Price: 0.0, wavPrice: 0.0, exclusivePrice: 0.0, time: "", tempo: 0, datetime: "", audioURL: "", imageURL: "", beatID: "", priceType: "", types: [], sounds: [], exclusiveFilesURL: nil, wavURL: nil, officialVideo: nil, videos: [], soundcloud: nil, key: "", merch: nil, isActive: nil)
        for child in snapshot.children {
            var temp:Array<Any> = []
            let data = child as! DataSnapshot
            if data.key != "Free Beat IDs" && data.key != "Paid Beat IDs" {
                let value = data.value! as! [String:Any]
                var typeArray:[String] = []
                var soundArray:[String] = []
                var time:String!
                var date:String!
                if let tval = value["Duration"] as? String {
                    beat.duration = tval
                }
                if let tval = value["Name"] as? String {
                    beat.name = tval
                }
                if let tval = value["Date"] as? String {
                    beat.date = tval
                    date = tval
                }
                if let tval = value["Number of Downloads"] as? Int {
                    beat.downloads = tval
                }
                if let tval = value["Wav Price"] as? Double {
                    beat.wavPrice = tval
                }
                if let tval = value["Lease Price"] as? Double {
                    beat.mp3Price = tval
                }
                if let tval = value["Exclusive Price"] as? Double {
                    beat.exclusivePrice = tval
                }
                if let tval = value["Time"] as? String {
                    beat.time = tval
                    time = tval
                }
                if let tval = value["Types"] as? [String] {
                    beat.types = tval
                }
                if let tval = value["Sounds"] as? [String] {
                    beat.sounds = tval
                }
                if let tval = value["Tempo"] as? Int {
                    beat.tempo = tval
                }
                if let tval = value["Audio"] as? String {
                    beat.audioURL = tval
                }
                if let tval = value["Image"] as? String {
                    beat.imageURL = tval
                }
                if let tval = value["beatId"] as? String {
                    beat.beatID = tval
                }
                if let tval = value["Price Type"] as? String {
                    beat.priceType = tval
                }
                if let tval = value["Producers"] as? [String] {
                    beat.producers = tval
                }
                if let tval = value["Tone Deaf App Id"] as? String {
                    beat.toneDeafAppId = tval
                }
                if let tval = value["Exclusive Files URL"] as? String {
                    beat.exclusiveFilesURL = tval
                }
                if let tval = value["Wav URL"] as? String {
                    beat.wavURL = tval
                }
                if let tval = value["Official Video"] as? String {
                    beat.officialVideo = tval
                }
                if let tval = value["Videos"] as? [String] {
                    beat.videos = tval
                }
                if let tval = value["Key"] as? String {
                    beat.key = tval
                }
                if let tval = value["Active Status"] as? Bool {
                    beat.isActive = tval
                }
                if let merchandise = (value["Merch"] as? [String]) {
                    beat.merch = (merchandise)
                }
                beat.datetime = "\(date)\(time)"
                let soundcloud = SoundcloudSongData(url: "", imageurl: nil, releaseDate: nil, isActive: false)
                for kiddo in data.children {
                    let dada = kiddo as! DataSnapshot
                    if dada.key.contains(soundcloudMusicContentType) == true {
                        var temp:Array<Any> = []
                        let dvalue = dada.value! as! [String:Any]
                        temp.append(dvalue["url"] as! String)
                        soundcloud.url = temp[0] as! String
                        if dvalue["Artwork URL"] != nil {
                            soundcloud.imageurl = (dvalue["Artwork URL"] as! String)
                        }
                        if dvalue["Date Released On Soundcloud"] != nil {
                            soundcloud.releaseDate = (dvalue["Date Released On Soundcloud"] as! String)
                        }
                        beat.soundcloud = soundcloud
                    }
                }
                tempbeats.append(beat)
            }
        }
        completion(tempbeats)
    }
    
    public func paidsetupArrayForBeatsTableView(snapshot: DataSnapshot, completion: @escaping (([BeatData]) -> Void)){
        var tempbeats: [BeatData] = []
        let beat = BeatData(duration: "", name: "", toneDeafAppId: "", producers: [""], date: "", downloads: 0, mp3Price: 0.0, wavPrice: 0.0, exclusivePrice: 0.0, time: "", tempo: 0, datetime: "", audioURL: "", imageURL: "", beatID: "", priceType: "", types: [], sounds: [], exclusiveFilesURL: nil, wavURL: nil, officialVideo: nil, videos: [], soundcloud: nil, key: "", merch: nil, isActive: nil)
        
        for child in snapshot.children {
            var temp:Array<Any> = []
            let data = child as! DataSnapshot
            if data.key != "Free Beat IDs" && data.key != "Paid Beat IDs" {
                let value = data.value! as! [String:Any]
                var typeArray:[String] = []
                var soundArray:[String] = []
                var time:String!
                var date:String!
                if let tval = value["Duration"] as? String {
                    beat.duration = tval
                }
                if let tval = value["Name"] as? String {
                    beat.name = tval
                }
                if let tval = value["Date"] as? String {
                    beat.date = tval
                    date = tval
                }
                if let tval = value["Number of Downloads"] as? Int {
                    beat.downloads = tval
                }
                if let tval = value["Wav Price"] as? Double {
                    beat.wavPrice = tval
                }
                if let tval = value["Lease Price"] as? Double {
                    beat.mp3Price = tval
                }
                if let tval = value["Exclusive Price"] as? Double {
                    beat.exclusivePrice = tval
                }
                if let tval = value["Time"] as? String {
                    beat.time = tval
                    time = tval
                }
                if let tval = value["Types"] as? [String] {
                    beat.types = tval
                }
                if let tval = value["Sounds"] as? [String] {
                    beat.sounds = tval
                }
                if let tval = value["Tempo"] as? Int {
                    beat.tempo = tval
                }
                if let tval = value["Audio"] as? String {
                    beat.audioURL = tval
                }
                if let tval = value["Image"] as? String {
                    beat.imageURL = tval
                }
                if let tval = value["beatId"] as? String {
                    beat.beatID = tval
                }
                if let tval = value["Price Type"] as? String {
                    beat.priceType = tval
                }
                if let tval = value["Producers"] as? [String] {
                    beat.producers = tval
                }
                if let tval = value["Tone Deaf App Id"] as? String {
                    beat.toneDeafAppId = tval
                }
                if let tval = value["Exclusive Files URL"] as? String {
                    beat.exclusiveFilesURL = tval
                }
                if let tval = value["Wav URL"] as? String {
                    beat.wavURL = tval
                }
                if let tval = value["Official Video"] as? String {
                    beat.officialVideo = tval
                }
                if let tval = value["Videos"] as? [String] {
                    beat.videos = tval
                }
                if let tval = value["Key"] as? String {
                    beat.key = tval
                }
                if let tval = value["Active Status"] as? Bool {
                    beat.isActive = tval
                }
                if let merchandise = (value["Merch"] as? [String]) {
                    beat.merch = (merchandise)
                }
                beat.datetime = "\(date)\(time)"
                let soundcloud = SoundcloudSongData(url: "", imageurl: nil, releaseDate: nil, isActive: false)
                for kiddo in data.children {
                    let dada = kiddo as! DataSnapshot
                    if dada.key.contains(soundcloudMusicContentType) == true {
                        var temp:Array<Any> = []
                        let dvalue = dada.value! as! [String:Any]
                        temp.append(dvalue["url"] as! String)
                        soundcloud.url = temp[0] as! String
                        if dvalue["Artwork URL"] != nil {
                            soundcloud.imageurl = (dvalue["Artwork URL"] as! String)
                        }
                        if dvalue["Date Released On Soundcloud"] != nil {
                            soundcloud.releaseDate = (dvalue["Date Released On Soundcloud"] as! String)
                        }
                        beat.soundcloud = soundcloud
                    }
                }
                //print("📙 beat \(beat)")
                tempbeats.append(beat)
            }
            
            //print("📙 tempbeats count \(tempbeats.count)")
        }
        completion(tempbeats)
    }
    
    public func filterByTempoPaid(slidervalue: Int, thumb: Int, completion: @escaping (([BeatData]) -> Void)) {
        let tempo = slidervalue
        let ref = Database.database().reference().child("Beats").child("Paid")
        if thumb == 0 {
            let query = ref.queryOrdered(byChild: "Tempo").queryStarting(atValue: tempo)
            query.observeSingleEvent(of: .value, with: {[weak self] snapshot in
                guard let strongSelf = self else {
                    return
                }
                strongSelf.setupArrayForBeatsTableView(snapshot: snapshot, completion: { tempbeats in
                    completion(tempbeats)
                })
            })
        }
        if thumb == 1 {
            let query = ref.queryOrdered(byChild: "Tempo").queryEnding(atValue: tempo)
            query.observeSingleEvent(of: .value, with: {[weak self] snapshot in
                guard let strongSelf = self else {
                    return
                }
                strongSelf.setupArrayForBeatsTableView(snapshot: snapshot, completion: { tempbeats in
                    completion(tempbeats)
                })
            })
        }
    }
    
    public func filterByTempoPaidSpecified(tempo: Int, completion: @escaping (([BeatData]) -> Void)) {
        let ref = Database.database().reference().child("Beats").child("Paid")
        let query = ref.queryOrdered(byChild: "Tempo").queryEqual(toValue: tempo)
        query.observeSingleEvent(of: .value, with: {[weak self] snapshot in
            guard let strongSelf = self else {
                return
            }
            strongSelf.setupArrayForBeatsTableView(snapshot: snapshot, completion: { tempbeats in
                completion(tempbeats)
            })
        })
    }
    
    public func filterByKeyPaid(key: String, completion: @escaping (([BeatData]) -> Void)) {
        let ref = Database.database().reference().child("Beats").child("Paid")
        let query = ref.queryOrdered(byChild: "Key").queryEqual(toValue: key)
        query.observeSingleEvent(of: .value, with: {[weak self] snapshot in
            guard let strongSelf = self else {
                return
            }
            strongSelf.setupArrayForBeatsTableView(snapshot: snapshot, completion: { tempbeats in
                completion(tempbeats)
            })
        })
    }
    
    public func filterByTypePaid(type: String, completion: @escaping (([BeatData]) -> Void)) {
        let ref = Database.database().reference().child("Beats").child("Paid")
        let query = ref.queryOrdered(byChild: "\(type) Type").queryEqual(toValue: true)
        query.observeSingleEvent(of: .value, with: {[weak self] snapshot in
            guard let strongSelf = self else {
                return
            }
            strongSelf.setupArrayForBeatsTableView(snapshot: snapshot, completion: { tempbeats in
                completion(tempbeats)
            })
        })
    }
    
    public func filterBySoundsPaid(sound: String, completion: @escaping (([BeatData]) -> Void)) {
        let ref = Database.database().reference().child("Beats").child("Paid")
        let query = ref.queryOrdered(byChild: "\(sound) Sound").queryEqual(toValue: true)
        query.observeSingleEvent(of: .value, with: { [weak self] snapshot in
            guard let strongSelf = self else {
                return
            }
            strongSelf.setupArrayForBeatsTableView(snapshot: snapshot, completion: { tempbeats in
                completion(tempbeats)
            })
        })
    }
    
}

final class SortingManager {
    
    static let shared = SortingManager()
    
}
