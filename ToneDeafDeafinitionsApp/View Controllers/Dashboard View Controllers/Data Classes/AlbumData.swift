//
//  AlbumData.swift
//  ToneDeafDeafinitionsApp
//
//  Created by Tone Deaf on 9/6/20.
//  Copyright © 2020 GITEM Solutions. All rights reserved.
//

import Foundation

class AlbumData {
    var toneDeafAppId:String
    var instrumentals:[String]?
    var dateRegisteredToApp:String
    var timeRegisteredToApp:String
    var videos: [String]?
    var songs:[String]?
    var tracks:[String:String]
    var merch:[String]?
    var name: String
    var mainArtist:Array<String>
    var allArtists:Array<String>?
    var producers:Array<String>
    var writers:Array<String>?
    var mixEngineers:Array<String>?
    var masteringEngineers:Array<String>?
    var recordingEngineers:Array<String>?
    var numberofTracks:Int
    var isActive:Bool!
    var favoritesOverall:Int
    
    var manualImageURL:String?
    var manualPreviewURL:String?
    
    var officialAlbumVideo:String?
    
    var spotify:SpotifyAlbumData?
    var apple:AppleAlbumData?
    var soundcloud:SoundcloudAlbumData?
    var youtubeMusic:YoutubeMusicAlbumData?
    var amazon:AmazonAlbumData?
    var tidal:TidalAlbumData?
    var deezer:DeezerAlbumData?
    var spinrilla:SpinrillaAlbumData?
    var napster:NapsterAlbumData?
    
    var industryCerified:Bool?
    var verificationLevel:Character?
    
    var deluxes:[String]?
    var isDeluxe:AlbumDeluxeData?
    var isOtherVersion:AlbumOtherVersionData?
    var otherVersions:[String]?
    
    
    
    init(toneDeafAppId:String, instrumentals:[String]?, dateRegisteredToApp:String, timeRegisteredToApp:String, songs:[String]?, tracks:[String:String], videos: [String]?, merch:[String]?, name: String, mainArtist:Array<String>, allArtists:Array<String>?, producers:Array<String>, writers:Array<String>?, mixEngineers:Array<String>?, masteringEngineers:Array<String>?, recordingEngineers:Array<String>?, isActive:Bool!, favoritesOverall:Int, manualImageURL:String?, manualPreviewURL:String?, numberofTracks:Int, officialAlbumVideo:String?, spotify:SpotifyAlbumData?, apple:AppleAlbumData?, soundcloud:SoundcloudAlbumData?, youtubeMusic:YoutubeMusicAlbumData?, amazon:AmazonAlbumData?, tidal:TidalAlbumData?, deezer:DeezerAlbumData?, spinrilla:SpinrillaAlbumData?, napster:NapsterAlbumData?, industryCerified:Bool?, verificationLevel:Character?, deluxes:[String]?, isDeluxe:AlbumDeluxeData?, isOtherVersion:AlbumOtherVersionData?, otherVersions:[String]?) {
        
        self.toneDeafAppId = toneDeafAppId
        self.dateRegisteredToApp = dateRegisteredToApp
        self.timeRegisteredToApp = timeRegisteredToApp
        self.videos = videos
        self.merch = merch
        self.name = name
        self.instrumentals = instrumentals
        self.songs = songs
        self.tracks = tracks
        self.mainArtist = mainArtist
        self.allArtists = allArtists
        self.producers = producers
        self.writers = writers
        self.mixEngineers = mixEngineers
        self.masteringEngineers = masteringEngineers
        self.recordingEngineers = recordingEngineers
        self.isActive = isActive
        self.favoritesOverall = favoritesOverall
        
        self.manualImageURL = manualImageURL
        self.manualPreviewURL = manualPreviewURL
        
        self.numberofTracks = numberofTracks
        
        self.officialAlbumVideo = officialAlbumVideo
        self.spotify = spotify
        self.apple = apple
        self.soundcloud = soundcloud
        self.youtubeMusic = youtubeMusic
        self.amazon = amazon
        self.tidal = tidal
        self.deezer = deezer
        self.spinrilla = spinrilla
        self.napster = napster
        self.industryCerified = industryCerified
        self.verificationLevel = verificationLevel
        self.deluxes = deluxes
        self.isDeluxe = isDeluxe
        self.otherVersions = otherVersions
        self.isOtherVersion = isOtherVersion
    }
}

extension AlbumData: Equatable {
    static func == (lhs: AlbumData, rhs: AlbumData) -> Bool {
        return lhs.toneDeafAppId == rhs.toneDeafAppId
        && lhs.dateRegisteredToApp == rhs.dateRegisteredToApp
        && lhs.timeRegisteredToApp == rhs.timeRegisteredToApp
        && lhs.videos == rhs.videos
        && lhs.merch == rhs.merch
        && lhs.name == rhs.name
        && lhs.instrumentals == rhs.instrumentals
        && lhs.songs == rhs.songs
        && lhs.tracks == rhs.tracks
        && lhs.mainArtist == rhs.mainArtist
        && lhs.allArtists == rhs.allArtists
        && lhs.producers == rhs.producers
        && lhs.writers == rhs.writers
        && lhs.mixEngineers == rhs.mixEngineers
        && lhs.masteringEngineers == rhs.masteringEngineers
        && lhs.recordingEngineers == rhs.recordingEngineers
        && lhs.isActive == rhs.isActive
        && lhs.manualImageURL == rhs.manualImageURL
        && lhs.manualPreviewURL == rhs.manualPreviewURL
        && lhs.numberofTracks == rhs.numberofTracks
        && lhs.officialAlbumVideo == rhs.officialAlbumVideo
        && lhs.spotify == rhs.spotify
        && lhs.apple == rhs.apple
        && lhs.soundcloud == rhs.soundcloud
        && lhs.youtubeMusic == rhs.youtubeMusic
        && lhs.amazon == rhs.amazon
        && lhs.tidal == rhs.tidal
        && lhs.deezer == rhs.deezer
        && lhs.spinrilla == rhs.spinrilla
        && lhs.napster == rhs.napster
        && lhs.industryCerified == rhs.industryCerified
        && lhs.verificationLevel == rhs.verificationLevel
        && lhs.deluxes == rhs.deluxes
        && lhs.isDeluxe == rhs.isDeluxe
        && lhs.otherVersions == rhs.otherVersions
        && lhs.isOtherVersion == rhs.isOtherVersion
        && lhs.isActive == rhs.isActive
    }
}

class AlbumDeluxeData {
    var standardEdition:String?
    var status:Bool!
    
    init(standardEdition:String?, status: Bool!) {
        self.standardEdition = standardEdition
        self.status = status
    }
}
extension AlbumDeluxeData: Equatable {
    static func == (lhs: AlbumDeluxeData, rhs: AlbumDeluxeData) -> Bool {
        let status = lhs.standardEdition == rhs.standardEdition
        && lhs.status == rhs.status
        return status
    }
}

class AlbumOtherVersionData {
    var standardEdition:String?
    var status:Bool!
    
    init(standardEdition:String?, status: Bool!) {
        self.standardEdition = standardEdition
        self.status = status
    }
}
extension AlbumOtherVersionData: Equatable {
    static func == (lhs: AlbumOtherVersionData, rhs: AlbumOtherVersionData) -> Bool {
        let status = lhs.standardEdition == rhs.standardEdition
        && lhs.status == rhs.status
        return status
    }
}
