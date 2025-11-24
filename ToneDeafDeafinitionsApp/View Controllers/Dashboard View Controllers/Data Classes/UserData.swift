//
//  UserData.swift
//  ToneDeafDeafinitionsApp
//
//  Created by Tone Deaf on 10/2/20.
//  Copyright © 2020 GITEM Solutions. All rights reserved.
//

import Foundation

class UserData {
    
    var accountType:String
    var email:String
    var uid:String
    var name:String
    var phone:String
    var appleConnected:Bool
    var googleConnected:Bool
    var facebookConnected:Bool
    var twitterConnected:Bool
    var paypalConnected:Bool
    var squareConnected:Bool
    var spotifyConnected:Bool
    var currentDevice:String
    var favorites:[UserFavorite]
    var downloads:[UserDownload]
    var brainTreeID:String?
    var brainTreeCT:String?
    
    init(accountType:String, email:String, uid:String, name:String, phone:String, appleConnected:Bool, googleConnected:Bool, facebookConnected:Bool, twitterConnected:Bool, paypalConnected:Bool, squareConnected:Bool, spotifyConnected:Bool, currentDevice:String, favorites:[UserFavorite], downloads:[UserDownload],brainTreeID:String?,brainTreeCT:String?) {
        self.accountType = accountType
        self.email = email
        self.uid = uid
        self.name = name
        self.appleConnected = appleConnected
        self.googleConnected = googleConnected
        self.facebookConnected = facebookConnected
        self.twitterConnected = twitterConnected
        self.paypalConnected = paypalConnected
        self.squareConnected = squareConnected
        self.spotifyConnected = spotifyConnected
        self.currentDevice = currentDevice
        self.phone = phone
        self.favorites = favorites
        self.downloads = downloads
        self.brainTreeID = brainTreeID
        self.brainTreeCT = brainTreeCT
    }
}

class UserFavorite {
    var dbid:String
    var timestamp:Date
    
    init(dbid:String, timestamp:Date) {
        self.dbid = dbid
        self.timestamp = timestamp
    }
}

class UserDownload {
    var name:String
    var dbid:String
    var timestamp:Date
    var downloadURL:String
    var destinationPath:String?
    
    init(name:String, dbid:String, timestamp:Date, downloadURL:String, destinationPath:String?) {
        self.name = name
        self.dbid = dbid
        self.timestamp = timestamp
        self.downloadURL = downloadURL
        self.destinationPath = destinationPath
    }
}
