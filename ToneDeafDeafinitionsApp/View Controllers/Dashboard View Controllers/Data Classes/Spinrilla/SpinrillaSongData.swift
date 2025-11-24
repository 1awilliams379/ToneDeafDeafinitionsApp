//
//  SpinrillaSongData.swift
//  ToneDeafDeafinitionsApp
//
//  Created by Tone Deaf on 10/6/20.
//  Copyright © 2020 GITEM Solutions. All rights reserved.
//

import Foundation

class SpinrillaSongData {
    
    var url:String
    var imageurl:String?
    var releaseDate:String?
    var isActive:Bool!
    
    init(url:String, imageurl:String?, releaseDate:String?,isActive:Bool!) {
        self.url = url
        self.imageurl = imageurl
        self.releaseDate = releaseDate
        self.isActive = isActive
    }
}

extension SpinrillaSongData: Equatable {
    static func == (lhs: SpinrillaSongData, rhs: SpinrillaSongData) -> Bool {
        let status = lhs.url == rhs.url
        && lhs.imageurl == rhs.imageurl
        && lhs.releaseDate == rhs.releaseDate
        && lhs.isActive == rhs.isActive
        return status
    }
}
