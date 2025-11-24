//
//  AppleAlbumData.swift
//  ToneDeafDeafinitionsApp
//
//  Created by Tone Deaf on 9/8/20.
//  Copyright © 2020 GITEM Solutions. All rights reserved.
//

import Foundation

class AppleAlbumData {
    var name:String
    var toneDeafAppId:String
    var dateReleasedApple:String
    var dateIA:String
    var timeIA:String
    var imageURL:String
    var trackCount:Int
    var artist:String
    var url:String
    var appleId:String
    var isActive:Bool!
    
    init(name:String, toneDeafAppId:String, dateReleasedApple:String, dateIA:String, timeIA:String, imageURL:String, trackCount:Int, artist:String, url:String, appleId:String, isActive:Bool!) {
        self.name = name
        self.toneDeafAppId = toneDeafAppId
        self.dateReleasedApple = dateReleasedApple
        self.dateIA = dateIA
        self.timeIA = timeIA
        self.imageURL = imageURL
        self.trackCount = trackCount
        self.artist = artist
        self.url = url
        self.appleId = appleId
        self.isActive = isActive
    }
}

extension AppleAlbumData: Equatable {
    static func == (lhs: AppleAlbumData, rhs: AppleAlbumData) -> Bool {
        return lhs.name == rhs.name
        && lhs.toneDeafAppId == rhs.toneDeafAppId
        && lhs.dateReleasedApple == rhs.dateReleasedApple
        && lhs.dateIA == rhs.dateIA
        && lhs.timeIA == rhs.timeIA
        && lhs.imageURL == rhs.imageURL
        && lhs.trackCount == rhs.trackCount
        && lhs.artist == rhs.artist
        && lhs.url == rhs.url
        && lhs.appleId == rhs.appleId
        && lhs.isActive == rhs.isActive
    }
}
