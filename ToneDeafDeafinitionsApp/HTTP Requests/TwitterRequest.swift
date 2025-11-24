//
//  TwitterRequest.swift
//  ToneDeafDeafinitionsApp
//
//  Created by Tone Deaf on 7/3/22.
//  Copyright © 2022 GITEM Solutions. All rights reserved.
//

import Foundation
import Alamofire

class TwitterRequest {
    static let shared = TwitterRequest()
    
    let apiKey = "OC9AQWTvxeyDLQ9xtp8xoQ2Ps"
    let apiKeySecret = "PqwhehPZKhp6G4ZH0RkiVQNtBxr1O8zASdeiGC95QgH353S5NT"
    let bearerToken = "AAAAAAAAAAAAAAAAAAAAAJm9eQEAAAAAHvof72lRqY1R2QlpHq9CfYLa7RE%3Dg633nVF0MWZxXeh7GOIBRfXkcrI4l7slRK9XIt195cxSqxWNCQ"
    
    typealias TwitterHTTPCompletion = (Result<TwitterTweetData, Error>) -> Void
    func getPost(mediaId: String, completion: @escaping TwitterHTTPCompletion) {
        
        let tweet = TwitterTweetData(url: "", media: nil, twitterId: "", text: nil, dateTwitter: "", dateIA: "", timeIA: "", viewsIA: 0, isActive: false)
        
        let headers:HTTPHeaders = ["Authorization":"Bearer \(bearerToken)"]
        let parameters = ["media.fields":"duration_ms,height,media_key,preview_image_url,type,url,width,public_metrics,alt_text,variants","user.fields":"created_at,description,entities,id,location,name,pinned_tweet_id,profile_image_url,protected,public_metrics,url,username,verified,withheld","tweet.fields":"created_at"]
        let getURL = "https://api.twitter.com/2/tweets/\(mediaId)?expansions=attachments.media_keys"
        AF.request(getURL, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: headers).responseJSON { [weak self] response in
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
                do {
                    typealias JSONObject = [[String:AnyObject]]
                    if let jsonResult = try JSONSerialization.jsonObject(with: response.data!, options: JSONSerialization.ReadingOptions.allowFragments) as? [String : AnyObject] {
                        print("Response from Twitter: \(jsonResult)") 
                        let includes = jsonResult["includes"] as! NSDictionary
                        let media = includes["media"] as! [[String:Any]]
                        var mediaArr:[MediaDataForTwitter] = []
                        for i in 0 ... media.count-1 {
                            let medata = MediaDataForTwitter(url: nil, mediaKey: nil, previewURL: nil, type: nil, contentType: nil)
                            if  let choice = media[i]["url"] as? String {
                                medata.url = choice
                            }
                            if  let choice = media[i]["media_key"] as? String  {
                                medata.mediaKey = choice
                            }
                            if  let choice = media[i]["preview_image_url"] as? String  {
                                medata.previewURL = choice
                            }
                            if  let choice = media[i]["type"] as? String  {
                                medata.type = choice
                            }
                            if  let choice = media[i]["variants"] as? NSDictionary  {
                                if let boice = choice["content_type"] as? String {
                                    medata.contentType = boice
                                }
                                if let boice = choice["url"] as? String {
                                    medata.url = boice
                                }
                            }
                            mediaArr.append(medata)
                        }
                        tweet.media = mediaArr
                        let data = jsonResult["data"] as! NSDictionary
                        var tweetTextURL = data["text"] as! String
                        if let range = tweetTextURL.range(of: "https://") {
                            tweetTextURL.removeSubrange(tweetTextURL.startIndex..<range.lowerBound)
                        }
                        tweet.url = tweetTextURL
                        var tweetText = data["text"] as! String
                        if let dotRange = tweetText.range(of: " https://") {
                            tweetText.removeSubrange(dotRange.lowerBound..<tweetText.endIndex)
                        }
                        tweet.text = tweetText
                        tweet.twitterId = data["id"] as! String
                        
                        var tdate = data["created_at"] as! String
                        let dateFormatter = DateFormatter()
                        dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
                        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
                        let date = dateFormatter.date(from: tdate)!
                        
                        let formatter = DateFormatter()
                        formatter.timeZone = TimeZone(identifier: "EDT")
                        formatter.dateFormat = "MMMM dd, yyyy"
                        tweet.dateTwitter = formatter.string(from: date)
                        
                        completion(.success(tweet))
                        
                    }
                } catch {
                    print("whoops")
                }
            }
        }
    
    typealias TwitterUserHTTPCompletion = (Result<TwitterUserData, Error>) -> Void
    func getPerson(username: String, completion: @escaping TwitterUserHTTPCompletion) {
        
        let user = TwitterUserData(url: "", dateCreated: "", name: "", userName: "", profileImageURL: "", twitterId: "", isActive: false)
        
        let headers:HTTPHeaders = ["Authorization":"Bearer \(bearerToken)"]
        let parameters = ["user.fields":"created_at,description,entities,id,location,name,pinned_tweet_id,profile_image_url,protected,public_metrics,url,username,verified,withheld"]
        let getURL = "https://api.twitter.com/2/users/by/username/\(username)?expansions=pinned_tweet_id"
        AF.request(getURL, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: headers).responseJSON { [weak self] response in
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
                do {
                    typealias JSONObject = [[String:AnyObject]]
                    if let jsonResult = try JSONSerialization.jsonObject(with: response.data!, options: JSONSerialization.ReadingOptions.allowFragments) as? [String : AnyObject] {
                        print("Response from Twitter: \(jsonResult)")
                        
                        let data = jsonResult["data"] as! NSDictionary
                        user.userName = data["username"] as! String
                        user.name = data["name"] as! String
                        user.profileImageURL = data["profile_image_url"] as! String
                        user.twitterId = data["id"] as! String
                        user.dateCreated = data["created_at"] as! String
                        user.url = "https://twitter.com/\(user.userName)"
                        completion(.success(user))
                        
                    }
                } catch {
                    print("whoops")
                }
            }
        }
    
}
