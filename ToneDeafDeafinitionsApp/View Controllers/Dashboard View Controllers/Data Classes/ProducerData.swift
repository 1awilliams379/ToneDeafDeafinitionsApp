//
//  ProducerData.swift
//  ToneDeafDeafinitionsApp
//
//  Created by Tone Deaf on 9/5/20.
//  Copyright © 2020 GITEM Solutions. All rights reserved.
//

import Foundation

class ProducerData {
    
    var name:String!
    var legalName:String?
    var alternateNames:Array<String>!
    var toneDeafAppId:String
    var songs:Array<String>
    var videos:[String]
    var beats:[String]
    var instrumentals:[String]
    var albums:Array<String>
    var merch:[String]?
    var dateRegisteredToApp:String!
    var timeRegisteredToApp:String!
    var linkedToAccount:String!
    var spotifyProfileURL:String!
    var appleProfileURL:String!
    var soundcloudProfileURL:String?
    var youtubeMusicProfileURL:String?
    var amazonProfileURL:String?
    var deezerProfileURL:String?
    var spinrillaProfileURL:String?
    var napsterProfileURL:String?
    var tidalProfileURL:String?
    var youtubeChannelURL:String?
    var instagramProfileURL:String?
    var twitterProfileURL:String?
    var facebookProfileURL:String?
    var spotifyProfileImageURL:String!
    var appleAllArtistAlbumIds:Array<String>!
    var followers:Int!
    
    
    init(name: String, legalName:String?, toneDeafAppId:String, songs:Array<String>, videos:[String], beats:[String], instrumentals:[String], albums:Array<String>, merch:[String]?, alternateNames:Array<String>, dateRegisteredToApp:String, timeRegisteredToApp:String, linkedToAccount:String, spotifyProfileURL:String, appleProfileURL:String, soundcloudProfileURL:String?, youtubeMusicProfileURL:String?, amazonProfileURL:String?, deezerProfileURL:String?, spinrillaProfileURL:String?, napsterProfileURL:String?, tidalProfileURL:String?, youtubeChannelURL:String?, instagramProfileURL:String?, twitterProfileURL:String?, facebookProfileURL:String?, spotifyProfileImageURL: String, appleAllArtistAlbumIds:Array<String>, followers:Int) {
        self.name = name
        self.legalName = legalName
        self.toneDeafAppId = toneDeafAppId
        self.songs = songs
        self.videos = videos
        self.beats = beats
        self.instrumentals = instrumentals
        self.albums = albums
        self.merch = merch
        self.alternateNames = alternateNames
        self.dateRegisteredToApp = dateRegisteredToApp
        self.timeRegisteredToApp = timeRegisteredToApp
        self.linkedToAccount = linkedToAccount
        self.spotifyProfileURL = spotifyProfileURL
        self.appleProfileURL = appleProfileURL
        self.soundcloudProfileURL = soundcloudProfileURL
        self.youtubeMusicProfileURL = youtubeMusicProfileURL
        self.amazonProfileURL = amazonProfileURL
        self.deezerProfileURL = deezerProfileURL
        self.spinrillaProfileURL = spinrillaProfileURL
        self.napsterProfileURL = napsterProfileURL
        self.tidalProfileURL = tidalProfileURL
        self.youtubeChannelURL = youtubeChannelURL
        self.instagramProfileURL = instagramProfileURL
        self.facebookProfileURL = facebookProfileURL
        self.twitterProfileURL = twitterProfileURL
        self.spotifyProfileImageURL = spotifyProfileImageURL
        self.appleAllArtistAlbumIds = appleAllArtistAlbumIds
        self.followers = followers
    }
}
