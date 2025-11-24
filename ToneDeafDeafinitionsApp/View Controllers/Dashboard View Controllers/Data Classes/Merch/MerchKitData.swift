//
//  MerchKitData.swift
//  ToneDeafDeafinitionsApp
//
//  Created by Tone Deaf on 10/30/20.
//  Copyright © 2020 GITEM Solutions. All rights reserved.
//

import Foundation

class MerchKitData {
    var date:Date
    var description:String
    var fileURL:String
    var imageURLs:[String]
    var merchType:String
    var name:String
    var quantity:Int?
    var numberOfPurchases:Int
    var numberOfFavorites:Int
    var previewURL:String
    var retailPrice:Double
    var salePrice:Double?
    var subcategory:String
    var tDAppId:String
    var artists:[String]?
    var producers:[String]?
    var songs:[String]?
    var albums:[String]?
    var videos:[String]?
    var instrumentals:[String]?
    var beats:[String]?
    
    init (date:Date, description:String, fileURL:String, imageURLs:[String], merchType:String, name:String, quantity:Int?, numberOfPurchases:Int, numberOfFavorites:Int, previewURL:String, retailPrice:Double, salePrice:Double?, subcategory:String, tDAppId:String, artists:[String]?, producers:[String]?, songs:[String]?, albums:[String]?, videos:[String]?, instrumentals:[String]?, beats:[String]?) {
        self.date = date
        self.description = description
        self.fileURL = fileURL
        self.imageURLs = imageURLs
        self.merchType = merchType
        self.name = name
        self.quantity = quantity
        self.numberOfPurchases = numberOfPurchases
        self.numberOfFavorites = numberOfFavorites
        self.previewURL = previewURL
        self.retailPrice = retailPrice
        self.salePrice = salePrice
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
