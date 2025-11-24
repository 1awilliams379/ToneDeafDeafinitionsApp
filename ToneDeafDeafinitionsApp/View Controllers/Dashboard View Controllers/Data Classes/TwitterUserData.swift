//
//  TwitterUserData.swift
//  ToneDeafDeafinitionsApp
//
//  Created by Tone Deaf on 7/10/22.
//  Copyright © 2022 GITEM Solutions. All rights reserved.
//

import Foundation

class TwitterUserData {
    var url:String
    var dateCreated:String
    var name:String
    var userName:String
    var profileImageURL:String
    var twitterId: String
    var isActive:Bool
    
    init(url:String, dateCreated:String, name:String, userName:String, profileImageURL:String, twitterId: String, isActive:Bool){
        self.url = url
        self.dateCreated = dateCreated
        self.name = name
        self.userName = userName
        self.profileImageURL = profileImageURL
        self.twitterId = twitterId
        self.isActive = isActive
    }
}
