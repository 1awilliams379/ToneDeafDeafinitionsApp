//
//  YoutubeMusicAlbumData.swift
//  ToneDeafDeafinitionsApp
//
//  Created by Tone Deaf on 10/6/20.
//  Copyright © 2020 GITEM Solutions. All rights reserved.
//

import Foundation

class YoutubeMusicAlbumData {
    
    var url:String
    var imageurl:String?
    var isActive:Bool!
    
    init(url:String, imageurl:String?, isActive:Bool!) {
        self.url = url
        self.imageurl = imageurl
        self.isActive = isActive
    }
}

extension YoutubeMusicAlbumData: Equatable {
    static func == (lhs: YoutubeMusicAlbumData, rhs: YoutubeMusicAlbumData) -> Bool {
        return lhs.imageurl == rhs.imageurl
        && lhs.url == rhs.url
        && lhs.isActive == rhs.isActive
    }
}
