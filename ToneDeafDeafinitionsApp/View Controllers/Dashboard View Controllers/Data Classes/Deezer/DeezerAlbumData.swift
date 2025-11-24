//
//  DeezerAlbumData.swift
//  ToneDeafDeafinitionsApp
//
//  Created by Tone Deaf on 10/6/20.
//  Copyright © 2020 GITEM Solutions. All rights reserved.
//

import Foundation

class DeezerAlbumData {
    
    var url:String!
    var imageurl:String!
    var deezerDate:String!
    var artist:[[String:Any]]!
    var duration:String!
    var upc:String!
    var name:String!
    var timeIA:String!
    var dateIA:String!
    var deezerID:Int!
    var isActive:Bool!
    
    init(url:String, imageurl:String?, deezerDate:String!, artist:[[String:Any]]!, duration:String!, upc:String!, name:String!, timeIA:String!, dateIA:String!, deezerID:Int!, isActive:Bool!) {
        self.url = url
        self.imageurl = imageurl
        self.deezerDate = deezerDate
        self.artist = artist
        self.duration = duration
        self.upc = upc
        self.name = name
        self.timeIA = timeIA
        self.dateIA = dateIA
        self.deezerID = deezerID
        self.isActive = isActive
    }
}

extension DeezerAlbumData: Equatable {
    static func == (lhs: DeezerAlbumData, rhs: DeezerAlbumData) -> Bool {
        return lhs.imageurl == rhs.imageurl
        && lhs.url == rhs.url
        && lhs.deezerDate == rhs.deezerDate
//        && lhs.artist == rhs.artist
        && lhs.duration == rhs.duration
        && lhs.upc == rhs.upc
        && lhs.name == rhs.name
        && lhs.timeIA == rhs.timeIA
        && lhs.dateIA == rhs.dateIA
        && lhs.deezerID == rhs.deezerID
        && lhs.isActive == rhs.isActive
    }
}
