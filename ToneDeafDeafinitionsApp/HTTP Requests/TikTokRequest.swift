//
//  TikTokRequest.swift
//  ToneDeafDeafinitionsApp
//
//  Created by Tone Deaf on 7/4/22.
//  Copyright © 2022 GITEM Solutions. All rights reserved.
//

import Foundation
import Alamofire

class TikTokRequest {
    static let shared = TikTokRequest()
    
    let accessToken = "EAAUNVEeBalUBAGZAV6LVZARcL4ZA8gvH5VCcrZAF98tuYcMExp6YZAOL6DaZC2OfAwJKaIfl9bqHCueW2YdaN8C7Dq5mgZC2cPxR1HZArYSebMnJFG1lJxs256rW7XKeCovOSMBcJdfPra9q6q9XfW2afdf8xiB0HXcM3GIUsDqhDwcHZCZA76UYDMV2bvlw2LfE7UOMmcjimNF47SG81v5dS8gyZBVivayzNcgzBbT9SVkrfiZBIkcc0Ww2"
    
    func getFacebookVideo(id: String, completion: @escaping ((Bool) -> Void)) {
        let resourceURL = "https://open-api.tiktok.com/oauth/access_token/"
        let parameters = ["":""]
        AF.request(resourceURL, method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil).responseJSON { response in
        if let status = response.response?.statusCode {
            switch(status){
            case 200:
                print("example success")
                print(response.result)
                print(response.data)
            default:
                print("error with response status: \(status)")
                print(response.response.value)
            }
            }
            do {
                typealias JSONObject = [[String:AnyObject]]
                if let jsonResult = try JSONSerialization.jsonObject(with: response.data!, options: JSONSerialization.ReadingOptions.allowFragments) as? [String : AnyObject] {
                    print("Response from Facebook: \(jsonResult)")
                }
            } catch {
                print("whoops")
            }
        }
    }
}
