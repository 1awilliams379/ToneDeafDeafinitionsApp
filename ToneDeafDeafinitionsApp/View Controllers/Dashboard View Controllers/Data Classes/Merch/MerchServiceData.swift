//
//  MerchServiceData.swift
//  ToneDeafDeafinitionsApp
//
//  Created by Tone Deaf on 10/31/20.
//  Copyright © 2020 GITEM Solutions. All rights reserved.
//

import Foundation

class MerchServiceData {
    var retailPrice:Double?
    var salePrice:Double?
    var merchType:String
    var numberOfFavorites:Int
    var numberOfPurchases:Int
    var dateUploaded:Date
    var description:String
    var name:String
    var serviceType:String
    var tDAppId:String
    var producers:[String]?
    
    init(name:String, serviceType:String, tDAppId:String, retailPrice:Double?, salePrice:Double?, merchType:String, numberOfFavorites:Int, numberOfPurchases:Int, dateUploaded:Date, description:String, producers:[String]?) {
        self.description = description
        self.retailPrice = retailPrice
        self.salePrice = salePrice
        self.merchType = merchType
        self.numberOfPurchases = numberOfPurchases
        self.numberOfFavorites = numberOfFavorites
        self.dateUploaded = dateUploaded
        self.producers = producers
        self.name = name
        self.serviceType = serviceType
        self.tDAppId = tDAppId
    }
}
