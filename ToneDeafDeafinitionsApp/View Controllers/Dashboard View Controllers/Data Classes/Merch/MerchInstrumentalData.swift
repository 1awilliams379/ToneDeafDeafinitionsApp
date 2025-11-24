//
//  MerchInstrumentalData.swift
//  ToneDeafDeafinitionsApp
//
//  Created by Tone Deaf on 10/30/20.
//  Copyright © 2020 GITEM Solutions. All rights reserved.
//

import Foundation

class MerchInstrumentalData {
    var instrumentaldbid:String
    var retailPrice:Double?
    var salePrice:Double?
    var quantity:Int?
    var merchType:String
    var numberOfFavorites:Int
    var numberOfPurchases:Int
    var dateUploaded:Date
    
    init(instrumentaldbid:String, retailPrice:Double?, salePrice:Double?, quantity:Int?, merchType:String, numberOfFavorites:Int, numberOfPurchases:Int, dateUploaded:Date) {
        self.instrumentaldbid = instrumentaldbid
        self.retailPrice = retailPrice
        self.salePrice = salePrice
        self.quantity = quantity
        self.merchType = merchType
        self.numberOfPurchases = numberOfPurchases
        self.numberOfFavorites = numberOfFavorites
        self.dateUploaded = dateUploaded
    }
}
