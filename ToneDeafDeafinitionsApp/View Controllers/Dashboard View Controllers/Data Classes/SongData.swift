//
//  SongData.swift
//  ToneDeafDeafinitionsApp
//
//  Created by Tone Deaf on 8/16/20.
//  Copyright © 2020 GITEM Solutions. All rights reserved.
//

import Foundation

class SongData: NSCopying {
    var toneDeafAppId:String
    var instrumentals:[String]?
    var videos: [String]?
    var albums:[String]?
    var merch:[String]?
    var name: String
    var dateRegisteredToApp:String!
    var timeRegisteredToApp:String!
    var songArtist:Array<String>
    var songProducers:Array<String>
    var songWriters:Array<String>?
    var songMixEngineer:Array<String>?
    var songMasteringEngineer:Array<String>?
    var songRecordingEngineer:Array<String>?
    
    var favoritesOverall:Int
    var manualImageURL:String?
    var manualPreviewURL:String?
    
    var apple:AppleMusicSongData?
    var spotify:SpotifySongData?
    var soundcloud:SoundcloudSongData?
    var youtubeMusic:YoutubeMusicSongData?
    var amazon:AmazonSongData?
    var deezer:DeezerSongData?
    var spinrilla:SpinrillaSongData?
    var napster:NapsterSongData?
    var tidal:TidalSongData?
    
    
    var officialVideo:String?
    var audioVideo:String?
    var lyricVideo:String?
    
    var remixes:[String]?
    var isRemix:SongRemixData?
    var isOtherVersion:SongOtherVersionData?
    var otherVersions:[String]?
    
    var explicit:Bool!
    var industryCerified:Bool?
    var verificationLevel:Character?
    
    var isActive:Bool!
    
    
    
    init(toneDeafAppId:String, instrumentals:[String]?, albums:[String]?, videos: [String]?, merch:[String]?, name: String, dateRegisteredToApp:String!, timeRegisteredToApp:String!, songArtist:Array<String>, songProducers:Array<String>, songWriters:Array<String>?, songMixEngineer:Array<String>?, songMasteringEngineer:Array<String>?, songRecordingEngineer:Array<String>?, favoritesOverall:Int, manualImageURL:String?, manualPreviewURL:String?, apple:AppleMusicSongData?, spotify:SpotifySongData?, soundcloud:SoundcloudSongData?, youtubeMusic:YoutubeMusicSongData?, amazon:AmazonSongData?, deezer:DeezerSongData?, spinrilla:SpinrillaSongData?, napster:NapsterSongData?, tidal:TidalSongData?, officialVideo:String?, audioVideo:String?, lyricVideo:String?, remixes:[String]?, isRemix:SongRemixData?, isOtherVersion:SongOtherVersionData?, otherVersions:[String]?, explicit:Bool!, industryCerified:Bool?, verificationLevel:Character?, isActive:Bool!) {
        
        self.toneDeafAppId = toneDeafAppId
        self.videos = videos?.sorted()
        self.name = name
        self.instrumentals = instrumentals?.sorted()
        self.albums = albums?.sorted()
        self.merch = merch?.sorted()
        self.dateRegisteredToApp = dateRegisteredToApp
        self.timeRegisteredToApp = timeRegisteredToApp
        self.songArtist = songArtist.sorted()
        self.songProducers = songProducers.sorted()
        self.songWriters = songWriters?.sorted()
        self.songMixEngineer = songMixEngineer?.sorted()
        self.songMasteringEngineer = songMasteringEngineer?.sorted()
        self.songRecordingEngineer = songRecordingEngineer?.sorted()
        
        self.favoritesOverall = favoritesOverall
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
        
        self.officialVideo = officialVideo
        self.audioVideo = audioVideo
        self.lyricVideo = lyricVideo
        
        self.isRemix = isRemix
        self.remixes = remixes
        self.otherVersions = otherVersions
        self.isOtherVersion = isOtherVersion
        
        self.explicit = explicit
        self.industryCerified = industryCerified
        self.verificationLevel = verificationLevel
        
        self.isActive = isActive
    }
    
    func copy(with zone: NSZone? = nil) -> Any {
        let copy = SongData(toneDeafAppId: "", instrumentals: [], albums: [], videos: [], merch: nil, name: "", dateRegisteredToApp: "", timeRegisteredToApp: "", songArtist: [], songProducers: [], songWriters: nil, songMixEngineer: nil, songMasteringEngineer: nil, songRecordingEngineer: nil, favoritesOverall: 0, manualImageURL: nil, manualPreviewURL: nil, apple: nil, spotify: nil, soundcloud: nil, youtubeMusic: nil, amazon: nil, deezer: nil, spinrilla: nil, napster: nil, tidal: nil, officialVideo: nil, audioVideo: nil,lyricVideo:nil, remixes: nil, isRemix:nil, isOtherVersion: nil, otherVersions: nil, explicit: nil, industryCerified: nil, verificationLevel: nil, isActive: false)
        copy.toneDeafAppId = self.toneDeafAppId
        copy.instrumentals = self.instrumentals?.sorted()
        copy.albums = self.albums?.sorted()
        copy.videos = self.videos?.sorted()
        copy.merch = self.merch?.sorted()
        copy.name = self.name
        copy.dateRegisteredToApp = self.dateRegisteredToApp
        copy.timeRegisteredToApp = self.timeRegisteredToApp
        copy.songArtist = self.songArtist.sorted()
        copy.songProducers = self.songProducers.sorted()
        copy.songWriters = self.songWriters?.sorted()
        copy.songMixEngineer = self.songMixEngineer?.sorted()
        copy.songMasteringEngineer = self.songMasteringEngineer?.sorted()
        copy.songRecordingEngineer = self.songRecordingEngineer?.sorted()
        copy.favoritesOverall = self.favoritesOverall
        copy.manualImageURL = self.manualImageURL
        copy.manualPreviewURL = self.manualPreviewURL
        copy.spotify = self.spotify
        copy.apple = self.apple
        copy.soundcloud = self.soundcloud
        copy.youtubeMusic = self.youtubeMusic
        copy.amazon = self.amazon
        copy.deezer = self.deezer
        copy.spinrilla = self.spinrilla
        copy.napster = self.napster
        copy.tidal = self.tidal
        copy.officialVideo = self.officialVideo
        copy.audioVideo = self.audioVideo
        copy.lyricVideo = self.lyricVideo
        copy.remixes = self.remixes
        copy.isRemix = self.isRemix
        copy.isOtherVersion = self.isOtherVersion
        copy.otherVersions = self.otherVersions
        copy.explicit = self.explicit
        copy.industryCerified = self.industryCerified
        copy.verificationLevel = self.verificationLevel
        copy.isActive = self.isActive
        return copy
    }
}

extension SongData: Equatable {
    static func == (lhs: SongData, rhs: SongData) -> Bool {
        let status = lhs.toneDeafAppId == rhs.toneDeafAppId
        && lhs.name == rhs.name
        && lhs.videos == rhs.videos
        && lhs.albums == rhs.albums
        && lhs.instrumentals == rhs.instrumentals
        && lhs.merch == rhs.merch
        && lhs.dateRegisteredToApp == rhs.dateRegisteredToApp
        && lhs.timeRegisteredToApp == rhs.timeRegisteredToApp
        && lhs.songArtist == rhs.songArtist
        && lhs.songProducers == rhs.songProducers
        && lhs.songWriters == rhs.songWriters
        && lhs.songMixEngineer == rhs.songMixEngineer
        && lhs.songMasteringEngineer?.sorted() == rhs.songMasteringEngineer?.sorted()
        && lhs.songRecordingEngineer?.sorted() == rhs.songRecordingEngineer?.sorted()
        && lhs.favoritesOverall == rhs.favoritesOverall
        && lhs.manualImageURL == rhs.manualImageURL
        && lhs.manualPreviewURL == rhs.manualPreviewURL
        && lhs.apple == rhs.apple
        && lhs.spotify == rhs.spotify
        && lhs.soundcloud == rhs.soundcloud
        && lhs.youtubeMusic == rhs.youtubeMusic
        && lhs.amazon == rhs.amazon
        && lhs.deezer == rhs.deezer
        && lhs.spinrilla == rhs.spinrilla
        && lhs.napster == rhs.napster
        && lhs.tidal == rhs.tidal
        && lhs.officialVideo == rhs.officialVideo
        && lhs.audioVideo == rhs.audioVideo
        && lhs.lyricVideo == rhs.lyricVideo
        && lhs.remixes == rhs.remixes
        && lhs.isRemix == rhs.isRemix
        && lhs.isOtherVersion == rhs.isOtherVersion
        && lhs.otherVersions == rhs.otherVersions
        && lhs.explicit == rhs.explicit
        && lhs.industryCerified == rhs.industryCerified
        && lhs.verificationLevel == rhs.verificationLevel
        && lhs.isActive == rhs.isActive
        return status
    }
}

class SongRemixData {
    var standardEdition:String?
    var status:Bool!
    
    init(standardEdition:String?, status: Bool!) {
        self.standardEdition = standardEdition
        self.status = status
    }
}
extension SongRemixData: Equatable {
    static func == (lhs: SongRemixData, rhs: SongRemixData) -> Bool {
        let status = lhs.standardEdition == rhs.standardEdition
        && lhs.status == rhs.status
        return status
    }
}

class SongOtherVersionData {
    var standardEdition:String?
    var status:Bool!
    
    init(standardEdition:String?, status: Bool!) {
        self.standardEdition = standardEdition
        self.status = status
    }
}
extension SongOtherVersionData: Equatable {
    static func == (lhs: SongOtherVersionData, rhs: SongOtherVersionData) -> Bool {
        let status = lhs.standardEdition == rhs.standardEdition
        && lhs.status == rhs.status
        return status
    }
}
