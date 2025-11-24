//
//  DeezerSongData.swift
//  ToneDeafDeafinitionsApp
//
//  Created by Tone Deaf on 10/6/20.
//  Copyright © 2020 GITEM Solutions. All rights reserved.
//

import Foundation

class DeezerSongData {
    
    var url:String!
    var imageurl:String!
    var deezerDate:String!
    var artist:[[String : Any]]!
    var duration:String!
    var isrc:String!
    var name:String!
    var previewURL:String!
    var timeIA:String!
    var dateIA:String!
    var deezerID:Int!
    var isActive:Bool!
    
    init(url:String, imageurl:String?, deezerDate:String!, artist:[[String : Any]]!, duration:String!, isrc:String!, name:String!, previewURL:String!, timeIA:String!, dateIA:String!, deezerID:Int!, isActive:Bool!) {
        self.url = url
        self.imageurl = imageurl
        self.deezerDate = deezerDate
        self.artist = artist
        self.duration = duration
        self.isrc = isrc
        self.name = name
        self.previewURL = previewURL
        self.timeIA = timeIA
        self.dateIA = dateIA
        self.deezerID = deezerID
        self.isActive = isActive
    }
}

extension DeezerSongData: Equatable {
    static func == (lhs: DeezerSongData, rhs: DeezerSongData) -> Bool {
        let status = lhs.url == rhs.url
        && lhs.imageurl == rhs.imageurl
        && lhs.deezerDate == rhs.deezerDate
        && lhs.duration == rhs.duration
        && lhs.isrc == rhs.isrc
        && lhs.name == rhs.name
        && lhs.previewURL == rhs.previewURL
        && lhs.timeIA == rhs.timeIA
        && lhs.dateIA == rhs.dateIA
        && lhs.deezerID == rhs.deezerID
        && lhs.isActive == rhs.isActive
        return status
    }
}
