//
//  WorldstarData.swift
//  ToneDeafDeafinitionsApp
//
//  Created by Tone Deaf on 7/4/22.
//  Copyright © 2022 GITEM Solutions. All rights reserved.
//

import Foundation

class WorldstarData: NSCopying {
    var url:String
    var dateIA:String
    var timeIa:String
    var isActive:Bool
    
    init(url:String, dateIA:String, timeIa:String, isActive:Bool){
        self.url = url
        self.dateIA = dateIA
        self.timeIa = timeIa
        self.isActive = isActive
    }
    
    func copy(with zone: NSZone? = nil) -> Any {
        let copy = WorldstarData(url: "", dateIA: "", timeIa: "", isActive: false)
        copy.url = self.url
        copy.dateIA = self.dateIA
        copy.timeIa = self.timeIa
        copy.isActive = self.isActive
        return copy
    }
}

extension WorldstarData: Equatable {
    static func == (lhs: WorldstarData, rhs: WorldstarData) -> Bool {
        return lhs.url == rhs.url
        && lhs.timeIa == rhs.timeIa
        && lhs.dateIA == rhs.dateIA
        && lhs.isActive == rhs.isActive
    }
}
