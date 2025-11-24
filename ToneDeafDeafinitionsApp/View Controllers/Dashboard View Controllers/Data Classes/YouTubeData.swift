//
//  YouTubeData.swift
//  ToneDeafDeafinitionsApp
//
//  Created by Tone Deaf on 8/16/20.
//  Copyright © 2020 GITEM Solutions. All rights reserved.
//

import Foundation

class YouTubeData: NSCopying {
    var title: String
    var url: String
    var duration: String?
    var dateYT:String
    var timeYT:String
    var timeIA:String
    var dateIA:String
    var description:String
    var thumbnailURL:String
    var channelTitle:String
    var viewsYT:Int?
    var viewsIA:Int
var toneDeafAppId:String
    var youtubeId:String
    var type:String
    var isActive: Bool
    
    init(duration: String?,url:String, title: String,dateYT:String, dateIA:String, timeYT:String, timeIA:String, description:String, thumbnailURL:String, channelTitle:String, viewsYT:Int?, viewsIA:Int, toneDeafAppId:String, youtubeId:String, type:String,isActive: Bool){
        self.duration = duration
        self.url = url
        self.title = title
        self.dateYT = dateYT
        self.timeYT = timeYT
        self.dateIA = dateIA
        self.timeIA = timeIA
        self.description = description
        self.thumbnailURL = thumbnailURL
        self.channelTitle = channelTitle
        self.viewsYT = viewsYT
        self.viewsIA = viewsIA
        self.toneDeafAppId = toneDeafAppId
        self.youtubeId = youtubeId
        self.type = type
        self.isActive = isActive
    }
    
    func copy(with zone: NSZone? = nil) -> Any {
        let copy = YouTubeData(duration: nil, url: "", title: "", dateYT: "", dateIA: "", timeYT: "", timeIA: "", description: "", thumbnailURL: "", channelTitle: "", viewsYT: nil, viewsIA: 0, toneDeafAppId: "", youtubeId: "", type: "", isActive: false)
        copy.title = self.title
        copy.duration = self.duration
        copy.url = self.url
        copy.dateYT = self.dateYT
        copy.dateIA = self.dateIA
        copy.timeYT = self.timeYT
        copy.timeIA = self.timeIA
        copy.description = self.description
        copy.thumbnailURL = self.thumbnailURL
        copy.channelTitle = self.channelTitle
        copy.viewsIA = self.viewsIA
        copy.viewsYT = self.viewsYT
        copy.toneDeafAppId = self.toneDeafAppId
        copy.youtubeId = self.youtubeId
        copy.type = self.type
        copy.isActive = self.isActive
        return copy
    }
}

extension YouTubeData: Equatable {
    static func == (lhs: YouTubeData, rhs: YouTubeData) -> Bool {
        return lhs.toneDeafAppId == rhs.toneDeafAppId
        && lhs.duration == rhs.duration
        && lhs.url == rhs.url
        && lhs.title == rhs.title
        && lhs.dateYT == rhs.dateYT
        && lhs.timeYT == rhs.timeYT
        && lhs.dateIA == rhs.dateIA
        && lhs.timeIA == rhs.timeIA
        && lhs.description == rhs.description
        && lhs.thumbnailURL == rhs.thumbnailURL
        && lhs.channelTitle == rhs.channelTitle
        && lhs.viewsYT == rhs.viewsYT
        && lhs.viewsIA == rhs.viewsIA
        && lhs.youtubeId == rhs.youtubeId
        && lhs.type == rhs.type
        && lhs.isActive == rhs.isActive
    }
}



