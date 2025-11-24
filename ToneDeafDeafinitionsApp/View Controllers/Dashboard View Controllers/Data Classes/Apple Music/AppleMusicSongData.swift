//
//  AppleMusicSongData.swift
//  ToneDeafDeafinitionsApp
//
//  Created by Tone Deaf on 9/7/20.
//  Copyright © 2020 GITEM Solutions. All rights reserved.
//

import Foundation

class AppleMusicSongData {
    
    var appleName:String
    var appleSongURL:String
    var appleDuration:String
    var appleDateAPPL:String
    var appleDateIA:String
    var appleTimeIA:String
    var appleArtworkURL:String
    var appleArtist:String
    var appleExplicity:Bool
    var appleISRC:String
    var appleAlbumName:String
    var applePreviewURL:String
    var applecomposers:String
    var appleTrackNumber:Int
    var appleGenres:Array<String>
    var appleFavorites:Int
    var appleMusicId:String
    var isActive:Bool!
    
    init(appleName:String, appleSongURL:String, appleDuration:String, appleDateAPPL:String ,appleDateIA:String, appleTimeIA:String, appleArtworkURL:String, appleArtist:String, appleExplicity:Bool, appleISRC:String, appleAlbumName:String, applePreviewURL:String, applecomposers:String, appleTrackNumber:Int, appleGenres:Array<String>, appleFavorites:Int, appleMusicId:String, isActive:Bool!) {
        
        self.appleName = appleName
        self.appleSongURL = appleSongURL
        self.appleDuration = appleDuration
        self.appleDateAPPL = appleDateAPPL
        self.appleDateIA = appleDateIA
        self.appleTimeIA = appleTimeIA
        self.appleArtworkURL = appleArtworkURL
        self.appleArtist = appleArtist
        self.appleExplicity = appleExplicity
        self.appleISRC = appleISRC
        self.appleAlbumName = appleAlbumName
        self.applePreviewURL = applePreviewURL
        self.applecomposers = applecomposers
        self.appleTrackNumber = appleTrackNumber
        self.appleGenres = appleGenres
        self.appleFavorites = appleFavorites
        self.appleMusicId = appleMusicId
        self.isActive = isActive
    }
}

extension AppleMusicSongData: Equatable {
    static func == (lhs: AppleMusicSongData, rhs: AppleMusicSongData) -> Bool {
        let status = lhs.appleName == rhs.appleName
        && lhs.appleSongURL == rhs.appleSongURL
        && lhs.appleDuration == rhs.appleDuration
        && lhs.appleDateAPPL == rhs.appleDateAPPL
        && lhs.appleDateIA == rhs.appleDateIA
        && lhs.appleTimeIA == rhs.appleTimeIA
        && lhs.appleArtworkURL == rhs.appleArtworkURL
        && lhs.appleArtist == rhs.appleArtist
        && lhs.appleExplicity == rhs.appleExplicity
        && lhs.appleISRC == rhs.appleISRC
        && lhs.appleAlbumName == rhs.appleAlbumName
        && lhs.applePreviewURL == rhs.applePreviewURL
        && lhs.applecomposers == rhs.applecomposers
        && lhs.appleTrackNumber == rhs.appleTrackNumber
        && lhs.appleGenres == rhs.appleGenres
        && lhs.appleFavorites == rhs.appleFavorites
        && lhs.appleMusicId == rhs.appleMusicId
        && lhs.isActive == rhs.isActive
        return status
    }
}
