//
//  AppleVideoData.swift
//  ToneDeafDeafinitionsApp
//
//  Created by Tone Deaf on 7/4/22.
//  Copyright © 2022 GITEM Solutions. All rights reserved.
//

import Foundation

class AppleVideoData: NSCopying {
    var url:String
    var name:String
    var albumName:String?
    var artistName:String
    var isrc:String
    var duration:String
    var genres:[String]
    var explicity:Bool
    var previewURL:String
    var thumbnailURL:String
    var dateApple:String
    var trackNumber:Int?
    var appleId:String
    var isActive:Bool
    
    init(url:String, name:String, albumName:String?, artistName:String, isrc:String, duration:String, genres:[String], explicity:Bool, previewURL:String, thumbnailURL:String, dateApple:String, trackNumber:Int?, appleId:String, isActive:Bool){
        self.url = url
        self.name = name
        self.albumName = albumName
        self.artistName = artistName
        self.isrc = isrc
        self.duration = duration
        self.genres = genres
        self.explicity = explicity
        self.previewURL = previewURL
        self.thumbnailURL = thumbnailURL
        self.dateApple = dateApple
        self.trackNumber = trackNumber
        self.appleId = appleId
        self.isActive = isActive
    }
    
    func copy(with zone: NSZone? = nil) -> Any {
        let copy = AppleVideoData(url: "", name: "", albumName: nil, artistName: "", isrc: "", duration: "", genres: [], explicity: false, previewURL: "", thumbnailURL: "", dateApple: "", trackNumber: nil, appleId: "", isActive: false)
        copy.url = self.url
        copy.name = self.name
        copy.albumName = self.albumName
        copy.artistName = self.artistName
        copy.isrc = self.isrc
        copy.duration = self.duration
        copy.genres = self.genres
        copy.explicity = self.explicity
        copy.previewURL = self.previewURL
        copy.thumbnailURL = self.thumbnailURL
        copy.dateApple = self.dateApple
        copy.trackNumber = self.trackNumber
        copy.appleId = self.appleId
        copy.isActive = self.isActive
        return copy
    }
}

extension AppleVideoData: Equatable {
    static func == (lhs: AppleVideoData, rhs: AppleVideoData) -> Bool {
        return lhs.url == rhs.url
        && lhs.name == rhs.name
        && lhs.albumName == rhs.albumName
        && lhs.artistName == rhs.artistName
        && lhs.isrc == rhs.isrc
        && lhs.duration == rhs.duration
        && lhs.genres == rhs.genres
        && lhs.explicity == rhs.explicity
        && lhs.previewURL == rhs.previewURL
        && lhs.thumbnailURL == rhs.thumbnailURL
        && lhs.dateApple == rhs.dateApple
        && lhs.trackNumber == rhs.trackNumber
        && lhs.appleId == rhs.appleId
        && lhs.isActive == rhs.isActive
    }
}
