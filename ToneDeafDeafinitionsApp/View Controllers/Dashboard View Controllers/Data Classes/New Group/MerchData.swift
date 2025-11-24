//
//  MerchData.swift
//  ToneDeafDeafinitionsApp
//
//  Created by Tone Deaf on 10/30/20.
//  Copyright © 2020 GITEM Solutions. All rights reserved.
//

import Foundation

class MerchData {
    var kit:MerchKitData?
    var apperal: MerchApperalData?
    var instrumentalSale: MerchInstrumentalData?
    var service: MerchServiceData?
    var memorabilia: MerchMemorabiliaData?
    
    init(kit:MerchKitData?, apperal: MerchApperalData?, instrumentalSale: MerchInstrumentalData?, service: MerchServiceData?, memorabilia: MerchMemorabiliaData?) {
        self.kit = kit
        self.apperal = apperal
        self.instrumentalSale = instrumentalSale
        self.service = service
        self.memorabilia = memorabilia
    }
}
