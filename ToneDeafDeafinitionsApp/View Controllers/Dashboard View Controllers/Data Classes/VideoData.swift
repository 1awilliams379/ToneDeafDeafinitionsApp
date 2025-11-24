//
//  VideoData.swift
//  ToneDeafDeafinitionsApp
//
//  Created by Tone Deaf on 6/22/22.
//  Copyright © 2022 GITEM Solutions. All rights reserved.
//

import Foundation

class VideoData {
    
    var title:String
    var toneDeafAppId:String
    var persons:[String]?
    var videographers:[String]?
    var albums:[String]?
    var instrumentals:[String]?
    var merch:[String]?
    var songs:[String]?
    var beats:[String]?
    var favorites:Int
    var type: String!
    var timeIA:String
    var dateIA:String
    var viewsIA:Int
    var manualThumbnailURL:String?
    var isActive:Bool
    var youtube:[YouTubeData]?
    var igtv:[IGTVData]?
    var instagramPost:[InstagramPostData]?
    var facebookPost:[FacebookPostData]?
    var worldstar:[WorldstarData]?
    var twitter:[TwitterTweetData]?
    var appleMusic:[AppleVideoData]?
    var tikTok: [TikTokData]?
    var industryCerified:Bool?
    var verificationLevel:Character?
    
    init(title:String, toneDeafAppId:String, persons:[String]?, videographers:[String]?, albums:[String]?, instrumentals:[String]?, merch:[String]?, songs:[String]?, beats:[String]?, favorites:Int, type: String!, timeIA:String, dateIA:String, viewsIA:Int, manualThumbnailURL:String?, isActive:Bool, youtube:[YouTubeData]?, igtv:[IGTVData]?, instagramPost:[InstagramPostData]?, facebookPost:[FacebookPostData]?, worldstar:[WorldstarData]?, twitter:[TwitterTweetData]?, appleMusic:[AppleVideoData]?, tikTok:[TikTokData]?, industryCerified:Bool?, verificationLevel:Character?){
        self.title = title
        self.toneDeafAppId = toneDeafAppId
        self.persons = persons
        self.albums = albums
        self.instrumentals = instrumentals
        self.merch = merch
        self.songs = songs
        self.beats = beats
        self.favorites = favorites
        self.type = type
        self.timeIA = timeIA
        self.dateIA = dateIA
        self.viewsIA = viewsIA
        self.manualThumbnailURL = manualThumbnailURL
        self.isActive = isActive
        self.youtube = youtube
        self.igtv = igtv
        self.instagramPost = instagramPost
        self.facebookPost = facebookPost
        self.worldstar = worldstar
        self.twitter = twitter
        self.appleMusic = appleMusic
        self.tikTok = tikTok
        self.industryCerified = industryCerified
        self.verificationLevel = verificationLevel
    }
}

extension VideoData: Equatable {
    static func == (lhs: VideoData, rhs: VideoData) -> Bool {
        return lhs.toneDeafAppId == rhs.toneDeafAppId
        && lhs.title == rhs.title
        && lhs.persons == rhs.persons
        && lhs.videographers == rhs.videographers
        && lhs.albums == rhs.albums
        && lhs.instrumentals == rhs.instrumentals
        && lhs.merch == rhs.merch
        && lhs.songs == rhs.songs
        && lhs.beats == rhs.beats
        && lhs.favorites == rhs.favorites
        && lhs.type == rhs.type
        && lhs.timeIA == rhs.timeIA
        && lhs.dateIA == rhs.dateIA
        && lhs.viewsIA == rhs.viewsIA
        && lhs.manualThumbnailURL == rhs.manualThumbnailURL
        && lhs.isActive == rhs.isActive
        && lhs.youtube == rhs.youtube
        && lhs.igtv == rhs.igtv
        && lhs.instagramPost == rhs.instagramPost
        && lhs.facebookPost == rhs.facebookPost
        && lhs.worldstar == rhs.worldstar
        && lhs.twitter == rhs.twitter
        && lhs.appleMusic == rhs.appleMusic
        && lhs.tikTok == rhs.tikTok
        && lhs.industryCerified == rhs.industryCerified
        && lhs.verificationLevel == rhs.verificationLevel
    }
}

