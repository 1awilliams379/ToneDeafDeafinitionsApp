//
//  AlbumUploadSongData.swift
//  ToneDeafDeafinitionsApp
//
//  Created by Tone Deaf on 9/7/20.
//  Copyright © 2020 GITEM Solutions. All rights reserved.
//

import Foundation

class AlbumUploadSongData {
    
    var name:String
    var trackNumber:String
    var toneDeafAppId:String
    var artists:[String]
    var producers:[String]
    var writers:[String]?
    var mixEngineers:[String]?
    var masteringEngineers:[String]?
    var recordingEngineers:[String]?
    var youtubeOfficialVideoURL:String
    var youTubeAudioVideoURL:String
    var youtubeAltVideoURLs:[String]
    var spotifyURL:String
    var appleMusicURL:String
    var soundcloudURL:String?
    var youtubeMusicURL:String?
    var amazonMusicURL:String?
    var deezerURL:String?
    var tidalURL:String?
    var spinrillaURL:String?
    var napsterURL:String?
    var instrumental:String
    var songsForinstrumental:[String]
    
    var explicit:Bool!
    var isRemix:SongRemixData?
    var isOtherVersion:SongOtherVersionData?
    var industryCerified:Bool?
    var verificationLevel:Character?
    var isActive:Bool! 
    
    init(name:String, trackNumber:String, toneDeafAppId:String, artists:[String], producers:[String], writers:[String]?, mixEngineers:[String]?, masteringEngineers:[String]?, recordingEngineers:[String]?, youtubeOfficialVideoURL:String, youTubeAudioVideoURL:String, youtubeAltVideoURLs:[String], spotifyURL:String, appleMusicURL:String, soundcloudURL:String?, youtubeMusicURL:String?, amazonMusicURL:String?, deezerURL:String?, tidalURL:String?, spinrillaURL:String?, napsterURL:String?, instrumental:String, songsForinstrumental:[String],industryCerified:Bool? ,verificationLevel:Character?, isActive:Bool!, explicit:Bool!, isRemix:SongRemixData?, isOtherVersion:SongOtherVersionData?) {
        self.name = name
        self.trackNumber = trackNumber
        self.toneDeafAppId = toneDeafAppId
        self.artists = artists
        self.producers = producers
        self.writers = writers
        self.mixEngineers = mixEngineers
        self.masteringEngineers = masteringEngineers
        self.recordingEngineers = recordingEngineers
        self.youtubeOfficialVideoURL = youtubeOfficialVideoURL
        self.youTubeAudioVideoURL = youTubeAudioVideoURL
        self.youtubeAltVideoURLs = youtubeAltVideoURLs
        self.spotifyURL = spotifyURL
        self.appleMusicURL = appleMusicURL
        self.soundcloudURL = soundcloudURL
        self.youtubeMusicURL = youtubeMusicURL
        self.amazonMusicURL = amazonMusicURL
        self.deezerURL = deezerURL
        self.tidalURL = tidalURL
        self.spinrillaURL = spinrillaURL
        self.napsterURL = napsterURL
        self.instrumental = instrumental
        self.songsForinstrumental = songsForinstrumental
        self.explicit = explicit
        self.verificationLevel = verificationLevel
        self.industryCerified = industryCerified
        self.isRemix = isRemix
        self.isOtherVersion = isOtherVersion
        self.isActive = isActive
    }
}
