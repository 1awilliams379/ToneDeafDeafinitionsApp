//
//  NapsterSongData.swift
//  ToneDeafDeafinitionsApp
//
//  Created by Tone Deaf on 10/6/20.
//  Copyright © 2020 GITEM Solutions. All rights reserved.
//

import Foundation

class NapsterSongData {
    
    var url:String
    var imageurl:String?
    var isActive:Bool!
    
    init(url:String, imageurl:String?, isActive:Bool!) {
        self.url = url
        self.imageurl = imageurl
        self.isActive = isActive
    }
}

extension NapsterSongData: Equatable {
    static func == (lhs: NapsterSongData, rhs: NapsterSongData) -> Bool {
        let status = lhs.url == rhs.url
        && lhs.imageurl == rhs.imageurl
        && lhs.isActive == rhs.isActive
        return status
    }
}
