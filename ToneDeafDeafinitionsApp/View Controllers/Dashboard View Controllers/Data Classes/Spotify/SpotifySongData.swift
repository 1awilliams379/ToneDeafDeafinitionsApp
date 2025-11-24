//
//  SpotifySongData.swift
//  ToneDeafDeafinitionsApp
//
//  Created by Tone Deaf on 9/7/20.
//  Copyright © 2020 GITEM Solutions. All rights reserved.
//

import Foundation

class SpotifySongData {
    var spotifyName:String
    var spotifySongURL:String
    var spotifyDuration:String
    var spotifyDateSPT:String
    var spotifyDateIA:String
    var spotifyTimeIA:String
    var spotifyArtworkURL:String
    var spotifyArtist1:String
    var spotifyArtist1URL:String
    var spotifyArtist2:String
    var spotifyArtist2URL:String
    var spotifyArtist3:String
    var spotifyArtist3URL:String
    var spotifyArtist4:String
    var spotifyArtist4URL:String
    var spotifyArtist5:String
    var spotifyArtist5URL:String
    var spotifyArtist6:String
    var spotifyArtis6URL:String
    var spotifyExplicity:Bool
    var spotifyISRC: String
    var spotifyAlbumType: String
    var spotifyTrackNumber: Int
    var spotifyPreviewURL:String
    var spotifyFavorites:Int
    var spotifyId:String
    var isActive:Bool!
    
    init(spotifyName: String, spotifySongURL:String, spotifyDuration: String, spotifyDateSPT: String, spotifyDateIA: String, spotifyTimeIA: String, spotifyArtworkURL: String, spotifyArtist1: String, spotifyArtist1URL: String, spotifyArtist2: String, spotifyArtist2URL: String, spotifyArtist3: String, spotifyArtist3URL: String, spotifyArtist4: String, spotifyArtist4URL: String, spotifyArtist5: String, spotifyArtist5URL: String, spotifyArtist6: String, spotifyArtist6URL: String, spotifyExplicity: Bool, spotifyISRC: String, spotifyAlbumType: String, spotifyTrackNumber: Int, spotifyPreviewURL: String, spotifyFavorites:Int, spotifyId:String, isActive:Bool!) {
        
        self.spotifyName = spotifyName
        self.spotifySongURL = spotifySongURL
        self.spotifyDuration = spotifyDuration
        self.spotifyDateSPT = spotifyDateSPT
        self.spotifyDateIA = spotifyDateIA
        self.spotifyTimeIA = spotifyTimeIA
        self.spotifyArtworkURL = spotifyArtworkURL
        self.spotifyArtist1 = spotifyArtist1
        self.spotifyArtist1URL = spotifyArtist1URL
        self.spotifyArtist2 = spotifyArtist2
        self.spotifyArtist2URL = spotifyArtist2URL
        self.spotifyArtist3URL = spotifyArtist3URL
        self.spotifyArtist3 = spotifyArtist3
        self.spotifyArtist4URL = spotifyArtist4URL
        self.spotifyArtist4 = spotifyArtist4
        self.spotifyArtist5URL = spotifyArtist5URL
        self.spotifyArtist5 = spotifyArtist5
        self.spotifyArtis6URL = spotifyArtist6URL
        self.spotifyArtist6 = spotifyArtist6
        self.spotifyExplicity = spotifyExplicity
        self.spotifyISRC = spotifyISRC
        self.spotifyAlbumType = spotifyAlbumType
        self.spotifyTrackNumber = spotifyTrackNumber
        self.spotifyPreviewURL = spotifyPreviewURL
        self.spotifyFavorites = spotifyFavorites
        self.spotifyId = spotifyId
        self.isActive = isActive
        
    }
}

extension SpotifySongData: Equatable {
    static func == (lhs: SpotifySongData, rhs: SpotifySongData) -> Bool {
        let status = lhs.spotifyName == rhs.spotifyName
        && lhs.spotifySongURL == rhs.spotifySongURL
        && lhs.spotifyDuration == rhs.spotifyDuration
        && lhs.spotifyDateSPT == rhs.spotifyDateSPT
        && lhs.spotifyDateIA == rhs.spotifyDateIA
        && lhs.spotifyTimeIA == rhs.spotifyTimeIA
        && lhs.spotifyArtworkURL == rhs.spotifyArtworkURL
        && lhs.spotifyArtist1 == rhs.spotifyArtist1
        && lhs.spotifyArtist1URL == rhs.spotifyArtist1URL
        && lhs.spotifyArtist2 == rhs.spotifyArtist2
        && lhs.spotifyArtist2URL == rhs.spotifyArtist2URL
        && lhs.spotifyArtist3 == rhs.spotifyArtist3
        && lhs.spotifyArtist3URL == rhs.spotifyArtist3URL
        && lhs.spotifyArtist4 == rhs.spotifyArtist4
        && lhs.spotifyArtist4URL == rhs.spotifyArtist4URL
        && lhs.spotifyArtist5 == rhs.spotifyArtist5
        && lhs.spotifyArtist5URL == rhs.spotifyArtist5URL
        && lhs.spotifyArtist6 == rhs.spotifyArtist6
        && lhs.spotifyArtis6URL == rhs.spotifyArtis6URL
        && lhs.spotifyExplicity == rhs.spotifyExplicity
        && lhs.spotifyISRC == rhs.spotifyISRC
        && lhs.spotifyAlbumType == rhs.spotifyAlbumType
        && lhs.spotifyTrackNumber == rhs.spotifyTrackNumber
        && lhs.spotifyPreviewURL == rhs.spotifyPreviewURL
        && lhs.spotifyFavorites == rhs.spotifyFavorites
        && lhs.spotifyId == rhs.spotifyId
        && lhs.isActive == rhs.isActive
        return status
    }
}
