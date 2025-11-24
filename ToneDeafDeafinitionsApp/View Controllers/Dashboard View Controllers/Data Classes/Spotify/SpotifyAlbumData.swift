//
//  SpotifyAlbumData.swift
//  ToneDeafDeafinitionsApp
//
//  Created by Tone Deaf on 9/8/20.
//  Copyright © 2020 GITEM Solutions. All rights reserved.
//

import Foundation

class SpotifyAlbumData {
    
    var toneDeafAppId:String
    var name:String
    var artist:[[String:String]]
    var spotifyId:String
    var url:String
    var uri:String
    var imageURL:String
    var upc:String
    var trackNumberTotal:Int
    var dateReleasedSpotify:String
    var dateIA:String
    var timeIA:String
    var isActive:Bool!
    
    init(toneDeafAppId:String, name:String, artist:[[String:String]], spotifyId:String, url:String, uri:String, imageURL:String, upc:String, trackNumberTotal:Int, dateReleasedSpotify:String, dateIA:String, timeIA:String, isActive:Bool!) {
        self.toneDeafAppId = toneDeafAppId
        self.name = name
        self.artist = artist
        self.spotifyId = spotifyId
        self.url = url
        self.uri = uri
        self.imageURL = imageURL
        self.upc = upc
        self.trackNumberTotal = trackNumberTotal
        self.dateReleasedSpotify = dateReleasedSpotify
        self.dateIA = dateIA
        self.timeIA = timeIA
        self.isActive = isActive
    }
}

extension SpotifyAlbumData: Equatable {
    static func == (lhs: SpotifyAlbumData, rhs: SpotifyAlbumData) -> Bool {
        return lhs.toneDeafAppId == rhs.toneDeafAppId
        && lhs.name == rhs.name
        && lhs.artist == rhs.artist
        && lhs.spotifyId == rhs.spotifyId
        && lhs.url == rhs.url
        && lhs.uri == rhs.uri
        && lhs.imageURL == rhs.imageURL
        && lhs.upc == rhs.upc
        && lhs.trackNumberTotal == rhs.trackNumberTotal
        && lhs.dateReleasedSpotify == rhs.dateReleasedSpotify
        && lhs.timeIA == rhs.timeIA
        && lhs.dateIA == rhs.dateIA
        && lhs.isActive == rhs.isActive
    }
}
