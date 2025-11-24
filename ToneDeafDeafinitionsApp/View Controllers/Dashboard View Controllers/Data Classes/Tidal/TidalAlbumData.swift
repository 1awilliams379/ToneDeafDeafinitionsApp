//
//  TidalAlbumData.swift
//  ToneDeafDeafinitionsApp
//
//  Created by Tone Deaf on 10/6/20.
//  Copyright © 2020 GITEM Solutions. All rights reserved.
//

import Foundation

class TidalAlbumData {
    
    var url:String
    var imageurl:String?
    var isActive:Bool!
    
    init(url:String, imageurl:String?, isActive:Bool!) {
        self.url = url
        self.imageurl = imageurl
        self.isActive = isActive
    }
}

extension TidalAlbumData: Equatable {
    static func == (lhs: TidalAlbumData, rhs: TidalAlbumData) -> Bool {
        return lhs.imageurl == rhs.imageurl
        && lhs.url == rhs.url
        && lhs.isActive == rhs.isActive
    }
}
