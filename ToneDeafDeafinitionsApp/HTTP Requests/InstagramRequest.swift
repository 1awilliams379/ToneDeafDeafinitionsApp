//
//  InstagramRequest.swift
//  ToneDeafDeafinitionsApp
//
//  Created by Tone Deaf on 8/20/20.
//  Copyright © 2020 GITEM Solutions. All rights reserved.
//

import Foundation
import Alamofire
import FirebaseDatabase


public class InstagramRequest {
    
    var accessToken = "IGQVJXVWtMUVQ0WXpuUFNaVXBxLVNVZAFdDZAmxFTDAydXp0Q1AyUG0tUnhOMzhrQkRYM0R2SDhXeGZAvWk1jQVJrQngyd3VmYnM4S1FTLVJ5MnFyWUV4WUh0SVRpU2FBVjkxdUc2QlJZATkJQam5kVnZAuU2lpWFMtNHBRSmRj"
    var code = "AQCRRSwblHJYJE-EdezIQcq0SJuH4133kXseE8kV2xTTUWLclE0Xp8fcdR3aBBaHYhEAcZ0G02WndZDMKCNm5q5NCnNTluDNjG-6xPMaCEV_NRlRF9yfv59lM5cXH3R7NkZrbGFqj2dix_xa0T9TkwGhrb8HES7h2fG0qOW79Tea895QS-VN4RWuWOZOuYnRlUuRGk5Sg9Yl0ZwyRosbIx7O7vbx2Zm16qHGICk0taa25g"
    
    static let shared = InstagramRequest()
    
    func authenticateInstagramTestUser() {
        let resourceURL = "https://api.instagram.com/oauth/access_token"
        let parameters = ["client_id":"427820439210127", "client_secret":"a81e180303c3cbd7111516dcf01c6ad5", "grant_type":"authorization_code","redirect_uri":"https://tonedeafbookings.wixsite.com/prodbytonedeaf", "code":code]
        AF.request(resourceURL, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseJSON { response in
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
                    print("Response from Instagram: \(jsonResult)")
                }
            } catch {
                print("whoops")
            }
        }
    }
    
    func nextStep() {
        let resourceURL = "https://graph.instagram.com/me"
        let parameters = ["access_token":accessToken,"fields": "id,username"]
        AF.request(resourceURL, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseJSON { response in
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
                    print("Response from Instagram: \(jsonResult)")
                }
            } catch {
                print("whoops")
            }
        }
    }
    
    func getlonglivedtoken() {
        let resourceURL = "https://graph.instagram.com/access_token"
        let parameters = ["grant_type":"ig_exchange_token", "client_secret":"7ef19cb9d0e05b6b8f9801ef9c11d20d", "access_token":accessToken]
        AF.request(resourceURL, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseJSON { response in
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
                    print("Response from Instagram: \(jsonResult)")
                }
            } catch {
                print("whoops")
            }
        }
    }
    
    func getIGUserData(id: String) {
        let resourceURL = "https://api.instagram.com/v1/users/\(id)/media/recent/?client_id=2391447301157814"
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
                    print("Response from Instagram: \(jsonResult)")
                }
            } catch {
                print("whoops")
            }
        }
    }
    
    func getIGPostData(id: String) {
        let resourceURL = "https://api.instagram.com/v1/users/\(id)/media/recent/?client_id=2391447301157814"
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
                    print("Response from Instagram: \(jsonResult)")
                }
            } catch {
                print("whoops")
            }
        }
    }
}
