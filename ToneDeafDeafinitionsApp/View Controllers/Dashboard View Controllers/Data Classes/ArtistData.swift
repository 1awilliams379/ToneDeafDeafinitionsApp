//
//  ArtistData.swift
//  ToneDeafDeafinitionsApp
//
//  Created by Tone Deaf on 8/20/20.
//  Copyright © 2020 GITEM Solutions. All rights reserved.
//

import Foundation

class ArtistData {
    
    var name:String!
    var legalName:String?
    var toneDeafAppId:String
    var songs:Array<String>
    var videos:[String]
    var albums:Array<String>
    var merch:Array<String>?
    var alternateNames:Array<String>!
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
    var soundcloudProfileImageURL:String?
    var youtubeMusicProfileImageURL:String?
    var amazonProfileImageURL:String?
    var deezerProfileImageURL:String?
    var spinrillaProfileImageURL:String?
    var napsterProfileImageURL:String?
    var tidalProfileImageURL:String?
    var youtubeChannelImageURL:String?
    var instagramProfileImageURL:String?
    var twitterProfileImageURL:String?
    var facebookProfileImageURL:String?
    var appleAllArtistAlbumIds:Array<String>!
    var followers:Int!
    
    
    init(name: String, legalName:String?, toneDeafAppId:String, songs:Array<String>, videos:[String], albums:Array<String>, merch:Array<String>?, alternateNames:Array<String>, dateRegisteredToApp:String, timeRegisteredToApp:String, linkedToAccount:String, spotifyProfileURL:String, appleProfileURL:String, soundcloudProfileURL:String?, youtubeMusicProfileURL:String?, amazonProfileURL:String?, deezerProfileURL:String?, spinrillaProfileURL:String?, napsterProfileURL:String?, tidalProfileURL:String?, youtubeChannelURL:String?, instagramProfileURL:String?, twitterProfileURL:String?, facebookProfileURL:String?, spotifyProfileImageURL: String, soundcloudProfileImageURL:String?, youtubeMusicProfileImageURL:String?, amazonProfileImageURL:String?, deezerProfileImageURL:String?, spinrillaProfileImageURL:String?, napsterProfileImageURL:String?, tidalProfileImageURL:String?, youtubeChannelImageURL:String?, instagramProfileImageURL:String?, twitterProfileImageURL:String?, facebookProfileImageURL:String?, appleAllArtistAlbumIds:Array<String>, followers:Int) {
        self.name = name
        self.legalName = legalName
        self.toneDeafAppId = toneDeafAppId
        self.songs = songs
        self.videos = videos
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
        self.soundcloudProfileImageURL = soundcloudProfileImageURL
        self.youtubeMusicProfileImageURL = youtubeMusicProfileImageURL
        self.amazonProfileImageURL = amazonProfileImageURL
        self.deezerProfileImageURL = deezerProfileImageURL
        self.spinrillaProfileImageURL = spinrillaProfileImageURL
        self.napsterProfileImageURL = napsterProfileImageURL
        self.tidalProfileImageURL = tidalProfileImageURL
        self.youtubeChannelImageURL = youtubeChannelImageURL
        self.instagramProfileImageURL = instagramProfileImageURL
        self.facebookProfileImageURL = facebookProfileImageURL
        self.twitterProfileImageURL = twitterProfileImageURL
        self.appleAllArtistAlbumIds = appleAllArtistAlbumIds
        self.followers = followers
    }
}
