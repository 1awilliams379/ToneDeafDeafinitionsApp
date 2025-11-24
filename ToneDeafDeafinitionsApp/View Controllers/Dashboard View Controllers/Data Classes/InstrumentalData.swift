//
//  InstrumentalData.swift
//  ToneDeafDeafinitionsApp
//
//  Created by Tone Deaf on 8/23/20.
//  Copyright © 2020 GITEM Solutions. All rights reserved.
//

import Foundation

class InstrumentalData {
    
    var instrumentalName:String?
    var toneDeafAppId:String
    var artist:Array<String>?
    var producers:Array<String>
    var mixEngineer:[String]?
    var masteringEngineer:[String]?
    var songName:String?
    var songs:[String]?
    var duration:String
    var audioURL:String
    var dateRegisteredToApp:String!
    var timeRegisteredToApp:String!
    var storeInfo:InstrumentalStoreInfo?
    var isActive:Bool!
    
    var manualImageURL:String?
    var manualPreviewURL:String?
    
    var favoritesOverall:Int
    var officialVideo:String?
    
    var apple:AppleMusicSongData?
    var spotify:SpotifySongData?
    var soundcloud:SoundcloudSongData?  
    var youtubeMusic:YoutubeMusicSongData?
    var amazon:AmazonSongData?
    var deezer:DeezerSongData?
    var spinrilla:SpinrillaSongData?
    var napster:NapsterSongData?
    var tidal:TidalSongData?
    
    var videos:[String]?
    var albums:[String]?
    var merch:[String]?
    
    var industryCerified:Bool?
    var verificationLevel:Character?
    
    init(instrumentalName:String?, toneDeafAppId:String, artist:Array<String>?, producers:Array<String>, mixEngineer:[String]?, masteringEngineer:[String]?, songName:String?, songs:[String]?, duration:String, audioURL:String, manualImageURL:String?, manualPreviewURL:String?, favoritesOverall:Int, officialVideo:String?, dateRegisteredToApp:String, timeRegisteredToApp:String!, apple:AppleMusicSongData?, spotify:SpotifySongData?, soundcloud:SoundcloudSongData?, youtubeMusic:YoutubeMusicSongData?, amazon:AmazonSongData?, deezer:DeezerSongData?, spinrilla:SpinrillaSongData?, napster:NapsterSongData?, tidal:TidalSongData?, videos: [String]?, albums:[String]?, merch:[String]?, storeInfo:InstrumentalStoreInfo?, industryCerified:Bool?, verificationLevel:Character?, isActive:Bool!) {
        
        self.instrumentalName = instrumentalName
        self.toneDeafAppId = toneDeafAppId
        self.artist = artist
        self.producers = producers
        self.mixEngineer = mixEngineer
        self.masteringEngineer = masteringEngineer
        self.songName = songName
        self.songs = songs
        self.duration = duration
        self.audioURL = audioURL
        self.dateRegisteredToApp = dateRegisteredToApp
        self.timeRegisteredToApp = timeRegisteredToApp
        self.storeInfo = storeInfo
        
        self.favoritesOverall = favoritesOverall
        
        self.officialVideo = officialVideo
        
        
        self.manualImageURL = manualImageURL
        self.manualPreviewURL = manualPreviewURL
        
        
        self.apple = apple
        self.spotify = spotify
        self.soundcloud = soundcloud
        self.youtubeMusic = youtubeMusic
        self.amazon = amazon
        self.deezer = deezer
        self.spinrilla = spinrilla
        self.napster = napster
        self.tidal = tidal
        
        self.videos = videos
        self.albums = albums
        self.merch = merch
        
        self.industryCerified = industryCerified
        self.verificationLevel = verificationLevel
    }
}

class InstrumentalStoreInfo {
    var retailPrice:Double
    var salePrice:Double?
    var dateUploaded:Date
    var merchType:String
    var numberOfPurchases:Int
    var quantity:Int?
    
    init(retailPrice:Double, salePrice:Double?, dateUploaded:Date, merchType:String, numberOfPurchases:Int, quantity:Int?) {
        self.retailPrice = retailPrice
        self.salePrice = salePrice
        self.dateUploaded = dateUploaded
        self.merchType = merchType
        self.numberOfPurchases = numberOfPurchases
        self.quantity = quantity
    }
}

extension InstrumentalData: Equatable {
    static func == (lhs: InstrumentalData, rhs: InstrumentalData) -> Bool {
        return lhs.toneDeafAppId == rhs.toneDeafAppId
    }
}
