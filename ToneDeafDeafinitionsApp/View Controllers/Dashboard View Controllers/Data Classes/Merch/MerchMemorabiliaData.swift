//
//  MerchMemorabiliaData.swift
//  ToneDeafDeafinitionsApp
//
//  Created by Tone Deaf on 10/31/20.
//  Copyright © 2020 GITEM Solutions. All rights reserved.
//

import Foundation

class MerchMemorabiliaData {
    var date:Date
    var colors:[MemorabiliaColorData]?
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
    
    init (date:Date, colors:[MemorabiliaColorData]?, imageURLs:[String], merchType:String, name:String, numberOfPurchases:Int, numberOfFavorites:Int, subcategory:String, tDAppId:String, artists:[String]?, producers:[String]?, songs:[String]?, albums:[String]?, videos:[String]?, instrumentals:[String]?, beats:[String]?) {
        self.date = date
        self.imageURLs = imageURLs
        self.merchType = merchType
        self.name = name
        self.colors = colors
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

class MemorabiliaColorData {
    var color:String
    var numberOfPurchases:Int
    var retailPrice:Double
    var salePrice:Double?
    var dateLastRestocked:Date
    var description:String
    var quantity:Int
    
    init(color:String, numberOfPurchases:Int, retailPrice:Double, salePrice:Double?, dateLastRestocked:Date, description:String, quantity:Int) {
        self.color = color
        self.numberOfPurchases = numberOfPurchases
        self.retailPrice = retailPrice
        self.salePrice = salePrice
        self.dateLastRestocked = dateLastRestocked
        self.description = description
        self.quantity = quantity
    }
}
