//
//  MerchApperalData.swift
//  ToneDeafDeafinitionsApp
//
//  Created by Tone Deaf on 10/30/20.
//  Copyright © 2020 GITEM Solutions. All rights reserved.
//

import Foundation

class MerchApperalData {
    var date:Date
    var osfaSize:[ApperalSizeData]?
    var xxsmallSize:[ApperalSizeData]?
    var xsmallSize:[ApperalSizeData]?
    var smallSize:[ApperalSizeData]?
    var mediumSize:[ApperalSizeData]?
    var largeSize:[ApperalSizeData]?
    var xlargeSize:[ApperalSizeData]?
    var xxlargeSize:[ApperalSizeData]?
    var xxxlargeSize:[ApperalSizeData]?
    var imageURLs:[String]
    var merchType:String
    var name:String
    var numberOfPurchases:Int
    var numberOfFavorites:Int
    var subcategory:String
    var tDAppId:String
    var artists:[String]?
    var producers:[String]?
    var songs:[String]?
    var albums:[String]?
    var videos:[String]?
    var instrumentals:[String]?
    var beats:[String]?
    
    init (date:Date, osfaSize:[ApperalSizeData]?, xxsmallSize:[ApperalSizeData]?, xsmallSize:[ApperalSizeData]?, smallSize:[ApperalSizeData]?, mediumSize:[ApperalSizeData]?, largeSize:[ApperalSizeData]?, xlargeSize:[ApperalSizeData]?, xxlargeSize:[ApperalSizeData]?, xxxlargeSize:[ApperalSizeData]?, imageURLs:[String], merchType:String, name:String, numberOfPurchases:Int, numberOfFavorites:Int, subcategory:String, tDAppId:String, artists:[String]?, producers:[String]?, songs:[String]?, albums:[String]?, videos:[String]?, instrumentals:[String]?, beats:[String]?) {
        self.date = date
        self.osfaSize = osfaSize
        self.xxsmallSize = xxsmallSize
        self.xsmallSize = xsmallSize
        self.smallSize = smallSize
        self.mediumSize = mediumSize
        self.largeSize = largeSize
        self.xlargeSize = xlargeSize
        self.xxlargeSize = xxlargeSize
        self.xxxlargeSize = xxxlargeSize
        self.imageURLs = imageURLs
        self.merchType = merchType
        self.name = name
        self.numberOfPurchases = numberOfPurchases
        self.numberOfFavorites = numberOfFavorites
        self.subcategory = subcategory
        self.tDAppId = tDAppId
        self.artists = artists
        self.producers = producers
        self.songs = songs
        self.albums = albums
        self.videos = videos
        self.instrumentals = instrumentals
        self.beats = beats
    }
}

class ApperalSizeData {
    var color:String
    var numberOfPurchases:Int
    var retailPrice:Double
    var salePrice:Double?
    var dateLastRestocked:Date
    var description:String
    var quantity:Int
    var size:String
    
    init(color:String, numberOfPurchases:Int, retailPrice:Double, salePrice:Double?, dateLastRestocked:Date, description:String, quantity:Int, size:String) {
        self.color = color
        self.numberOfPurchases = numberOfPurchases
        self.retailPrice = retailPrice
        self.salePrice = salePrice
        self.dateLastRestocked = dateLastRestocked
        self.description = description
        self.quantity = quantity
        self.size = size
    }
}
