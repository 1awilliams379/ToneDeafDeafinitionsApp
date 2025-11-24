//
//  BeatData.swift
//  ToneDeafDeafinitionsApp
//
//  Created by Tone Deaf on 8/2/20.
//  Copyright © 2020 GITEM Solutions. All rights reserved.
//

import Foundation
import UIKit

class BeatData: NSObject {
    
    var name: String
    var producers:[String]
    var videos:[String]
    var merch:[String]?
    var soundcloud:SoundcloudSongData?
    var toneDeafAppId:String
    var duration: String
    var date:String
    var downloads:Int
    var mp3Price:Double?
    var wavPrice:Double?
    var wavURL:String?
    var exclusivePrice:Double?
    var exclusiveFilesURL:String?
    var time:String
    var tempo:Int
    var datetime:String
    var audioURL:String
    var imageURL:String
    var beatID:String
    var priceType:String
    var types:[String]
    var sounds:[String]
    var officialVideo:String?
    var key:String
    var isActive:Bool!
    
    
    init(duration: String, name: String, toneDeafAppId:String, producers:[String], date:String, downloads:Int, mp3Price:Double?, wavPrice:Double?, exclusivePrice:Double?, time:String, tempo:Int, datetime:String, audioURL:String, imageURL:String, beatID:String, priceType:String, types:[String], sounds:[String], exclusiveFilesURL:String?, wavURL:String?, officialVideo:String?,videos:[String],soundcloud:SoundcloudSongData?,key:String, merch:[String]?,isActive:Bool!) {
        self.duration = duration
        self.key = key
        self.name = name
        self.producers = producers
        self.videos = videos
        self.merch = merch
        self.soundcloud = soundcloud
        self.toneDeafAppId = toneDeafAppId
        self.date = date
        self.downloads = downloads
        self.mp3Price = mp3Price
        self.wavPrice = wavPrice
        self.exclusivePrice = exclusivePrice
        self.exclusiveFilesURL = exclusiveFilesURL
        self.wavURL = wavURL
        self.time = time
        self.tempo = tempo
        self.datetime = datetime
        self.audioURL = audioURL
        self.imageURL = imageURL
        self.beatID = beatID
        self.priceType = priceType
        self.types = types
        self.sounds = sounds
        self.isActive = isActive
        self.officialVideo = officialVideo
    }
}

//extension BeatData: Equatable {
//    static func == (lhs: BeatData, rhs: BeatData) -> Bool {
//        return lhs.toneDeafAppId == rhs.toneDeafAppId
//        && lhs.duration == rhs.duration
//        && lhs.key == rhs.key
//        && lhs.name == rhs.name
//        && lhs.producers == rhs.producers
//        && lhs.videos == rhs.videos
//        && lhs.merch == rhs.merch
//        && lhs.soundcloud == rhs.soundcloud
//        && lhs.date == rhs.date
//        && lhs.downloads == rhs.downloads
//        && lhs.mp3Price == rhs.mp3Price
//        && lhs.wavPrice == rhs.wavPrice
//        && lhs.exclusivePrice == rhs.exclusivePrice
//        && lhs.exclusiveFilesURL == rhs.exclusiveFilesURL
//        && lhs.wavURL == rhs.wavURL
//        && lhs.time == rhs.time
//        && lhs.tempo == rhs.tempo
//        && lhs.datetime == rhs.datetime
//        && lhs.audioURL == rhs.audioURL
//        && lhs.imageURL == rhs.imageURL
//        && lhs.beatID == rhs.beatID
//        && lhs.priceType == rhs.priceType
//        && lhs.types == rhs.types
//        && lhs.sounds == rhs.sounds
//        && lhs.officialVideo == rhs.officialVideo
//        && lhs.isActive == rhs.isActive
//    }
//}

