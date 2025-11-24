//
//  MultiSliderSubstrings.swift
//  ToneDeafDeafinitionsApp
//
//  Created by Tone Deaf on 8/8/20.
//  Copyright © 2020 GITEM Solutions. All rights reserved.
//

import Foundation
import UIKit

final class MultiSliderSubStrings {
    
    static let shared = MultiSliderSubStrings()
    
    let tempo50Substring = "50"
    let tempo60Substring = "60"
    let tempo70Substring = "70"
    let tempo80Substring = "80"
    let tempo90Substring = "90"
    let tempo100Substring = "100"
    let tempo110Substring = "110"
    let tempo120Substring = "120"
    let tempo130Substring = "130"
    let tempo140Substring = "140"
    let tempo150Substring = "150"
    let tempo160Substring = "160"
    let tempo170Substring = "170"
    let tempo180Substring = "180"
    let tempo190Substring = "190"
    let tempo200Substring = "200"
    
    public func getTempoIndexes(thumb: Int, valueLabelJibberish: [UITextField], completion: @escaping ((Int, Int) -> Void)) {
        
        guard let valueLabelthumbMin = valueLabelJibberish[0].text else {return}
        guard let valueLabelthumbMax = valueLabelJibberish[1].text else {return}
        
        
        if thumb == 0 {
            if (valueLabelthumbMin == tempo50Substring) {
                completion(thumb, 50)
            } else if (valueLabelthumbMin == tempo60Substring) {
                completion(thumb, 60)
            } else if (valueLabelthumbMin == tempo70Substring) {
                completion(thumb, 70)
            } else if (valueLabelthumbMin == tempo80Substring) {
                completion(thumb, 80)
            } else if (valueLabelthumbMin == tempo90Substring) {
                completion(thumb, 90)
            } else if (valueLabelthumbMin == tempo100Substring) {
                completion(thumb, 100)
            } else if ((valueLabelthumbMin == tempo110Substring)) {
                completion(thumb, 110)
            } else if ((valueLabelthumbMin == tempo120Substring)) {
                completion(thumb, 120)
            } else if ((valueLabelthumbMin == tempo130Substring)) {
                completion(thumb, 130)
            } else if ((valueLabelthumbMin == tempo140Substring)) {
                completion(thumb, 140)
            } else if ((valueLabelthumbMin == tempo150Substring)) {
                completion(thumb, 150)
            } else if ((valueLabelthumbMin == tempo160Substring)) {
                completion(thumb, 160)
            } else if ((valueLabelthumbMin == tempo170Substring)) {
                completion(thumb, 170)
            } else if ((valueLabelthumbMin == tempo180Substring)) {
                completion(thumb, 180)
            } else if ((valueLabelthumbMin == tempo190Substring)) {
                completion(thumb, 190)
            } else if ((valueLabelthumbMin == tempo200Substring)) {
                completion(thumb, 200)
            } else {
                print("nada foo")
            }
        }
        if thumb == 1 {
            if (valueLabelthumbMax == tempo50Substring) {
                completion(thumb, 50)
            } else if (valueLabelthumbMax == tempo60Substring) {
                completion(thumb, 60)
            } else if (valueLabelthumbMax == tempo70Substring) {
                completion(thumb, 70)
            } else if (valueLabelthumbMax == tempo80Substring) {
                completion(thumb, 80)
            } else if (valueLabelthumbMax == tempo90Substring) {
                completion(thumb, 90)
            } else if (valueLabelthumbMax == tempo100Substring) {
                completion(thumb, 100)
            } else if ((valueLabelthumbMax == tempo110Substring)) {
                completion(thumb, 110)
            } else if ((valueLabelthumbMax == tempo120Substring)) {
                completion(thumb, 120)
            } else if ((valueLabelthumbMax == tempo130Substring)) {
                completion(thumb, 130)
            } else if ((valueLabelthumbMax == tempo140Substring)) {
                completion(thumb, 140)
            } else if ((valueLabelthumbMax == tempo150Substring)) {
                completion(thumb, 150)
            } else if ((valueLabelthumbMax == tempo160Substring)) {
                completion(thumb, 160)
            } else if ((valueLabelthumbMax == tempo170Substring)) {
                completion(thumb, 170)
            } else if ((valueLabelthumbMax == tempo180Substring)) {
                completion(thumb, 180)
            } else if ((valueLabelthumbMax == tempo190Substring)) {
                completion(thumb, 190)
            } else if ((valueLabelthumbMax == tempo200Substring)) {
                completion(thumb, 200)
            } else {
                print("nada foo")
            }
        }
    
        //print(valu)
        
        
    }
    
    func getCurrentThumbLabelValues(thumb: String) {
        
    }
        
}


