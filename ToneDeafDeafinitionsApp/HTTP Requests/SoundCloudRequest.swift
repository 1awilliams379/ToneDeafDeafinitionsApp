//
//  SoundCloudRequest.swift
//  ToneDeafDeafinitionsApp
//
//  Created by Tone Deaf on 8/19/20.
//  Copyright © 2020 GITEM Solutions. All rights reserved.
//

import Foundation
import Alamofire
import FirebaseDatabase


public class SoundCloudRequest {
    
    static let shared = SoundCloudRequest()
    
    func getSoundcloudTrack(name: String, Artist:String, url: String) {
        let urlString = "https://api.soundcloud.com/resolve?url=https://soundcloud.com/1sgmusic/sgm-gets-cold"
        let id = "775733293"
        let parameters = ["client_id":"1mJh51hV11v1prDWhy9hLmGaqvfrauWc"]
        
        AF.request(urlString, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: ["Authorization":"OAuth 2-290059-869835598-KsKToBiiGlwkcB"]).responseJSON { [weak self] response in
        guard let strongSelf = self else {return}
            
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
        }
    }
    
    
}
