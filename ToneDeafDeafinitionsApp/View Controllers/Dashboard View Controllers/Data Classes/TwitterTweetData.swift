//
//  TwitterTweetData.swift
//  ToneDeafDeafinitionsApp
//
//  Created by Tone Deaf on 7/3/22.
//  Copyright © 2022 GITEM Solutions. All rights reserved.
//

import Foundation

class TwitterTweetData {
    var url:String
    var media:[MediaDataForTwitter]?
    var twitterId: String
    var text:String?
    var dateIA: String!
    var dateTwitter:String!
    var timeIA: String!
    var viewsIA: Int!
    var isActive:Bool
    
    init(url:String, media:[MediaDataForTwitter]?, twitterId: String, text:String?, dateTwitter:String!, dateIA: String!, timeIA: String!, viewsIA: Int!, isActive:Bool){
        self.url = url
        self.media = media
        self.twitterId = twitterId
        self.text = text
        self.dateIA = dateIA
        self.dateTwitter = dateTwitter
        self.timeIA = timeIA
        self.viewsIA = viewsIA
        self.isActive = isActive
    }
    
    func copy(with zone: NSZone? = nil) -> Any {
        let copy = TwitterTweetData(url: "", media: nil, twitterId: "", text: nil, dateTwitter: "", dateIA: "", timeIA: "", viewsIA: 0, isActive: false)
        copy.url = self.url
        copy.media = self.media
        copy.twitterId = self.twitterId
        copy.text = self.text
        copy.dateIA = self.dateIA
        copy.dateTwitter = self.dateTwitter
        copy.timeIA = self.timeIA
        copy.viewsIA = self.viewsIA
        copy.isActive = self.isActive
        return copy
    }
}

extension TwitterTweetData: Equatable {
    static func == (lhs: TwitterTweetData, rhs: TwitterTweetData) -> Bool {
        return lhs.url == rhs.url
        && lhs.media == rhs.media
        && lhs.twitterId == rhs.twitterId
        && lhs.text == rhs.text
        && lhs.dateIA == rhs.dateIA
        && lhs.dateTwitter == rhs.dateTwitter
        && lhs.timeIA == rhs.timeIA
        && lhs.viewsIA == rhs.viewsIA
        && lhs.isActive == rhs.isActive
    }
}

class MediaDataForTwitter: NSCopying {
    var url:String?
    var mediaKey:String?
    var previewURL:String?
    var type:String?
    var contentType:String?
    
    init(url:String?,mediaKey:String?, previewURL:String?, type:String?, contentType:String?){
        self.url = url
        self.mediaKey = mediaKey
        self.previewURL = previewURL
        self.type = type
        self.contentType = contentType
    }
    
    func copy(with zone: NSZone? = nil) -> Any {
        let copy = MediaDataForTwitter(url: nil, mediaKey: nil, previewURL: nil, type: nil, contentType: nil)
        copy.url = self.url
        copy.mediaKey = self.mediaKey
        copy.previewURL = self.previewURL
        copy.type = self.type
        copy.contentType = self.contentType
        return copy
    }
}

extension MediaDataForTwitter: Equatable {
    static func == (lhs: MediaDataForTwitter, rhs: MediaDataForTwitter) -> Bool {
        return lhs.url == rhs.url
        && lhs.mediaKey == rhs.mediaKey
        && lhs.previewURL == rhs.previewURL
        && lhs.type == rhs.type
        && lhs.contentType == rhs.contentType
    }
}
