//
//  PersonData.swift
//  ToneDeafDeafinitionsApp
//
//  Created by Tone Deaf on 6/22/22.
//  Copyright © 2022 GITEM Solutions. All rights reserved.
//
import Foundation

class PersonData: NSCopying {
    
    var name:String!
    var legalName:String?
    var alternateNames:Array<String>?
    var toneDeafAppId:String
    var mainRole:String!
    var roles:NSMutableDictionary?
    var songs:Array<String>?
    var videos:[String]?
    var beats:[String]?
    var instrumentals:[String]?
    var albums:Array<String>?
    var merch:[String]?
    var dateRegisteredToApp:String!
    var timeRegisteredToApp:String!
    var linkedToAccount:String?
    var spotify:SpotifyPersonData?
    var apple:AppleMusicPersonData?
    var soundcloud:SoundcloudPersonData?
    var youtubeMusic:YoutubeMusicPersonData?
    var amazon:AmazonPersonData?
    var deezer:DeezerPersonData?
    var spinrilla:SpinrillaPersonData?
    var napster:NapsterPersonData?
    var tidal:TidalPersonData?
    var youtube:YoutubePersonData?
    var instagram:InstagramPersonData?
    var twitter:TwitterPersonData?
    var facebook:FacebookPersonData?
    var tikTok:TikTokPersonData?
    var manualImageURL:String?
    var followers:Int!
    
    var industryCerified:Bool?
    var verificationLevel:Character?
    
    var isActive:Bool!

    
    
    init(name: String!, legalName:String?, toneDeafAppId:String, mainRole:String!, roles:NSMutableDictionary?, songs:Array<String>?, videos:[String]?, beats:[String]?, instrumentals:[String]?, albums:Array<String>?, merch:[String]?, alternateNames:Array<String>?, dateRegisteredToApp:String, timeRegisteredToApp:String, linkedToAccount:String?, spotify:SpotifyPersonData?, apple:AppleMusicPersonData?, soundcloud:SoundcloudPersonData?, youtubeMusic:YoutubeMusicPersonData?, amazon:AmazonPersonData?, deezer:DeezerPersonData?, spinrilla:SpinrillaPersonData?, napster:NapsterPersonData?, tidal:TidalPersonData?, youtube:YoutubePersonData?, instagram:InstagramPersonData?, twitter:TwitterPersonData?, facebook:FacebookPersonData?, tikTok:TikTokPersonData?, manualImageURL:String?, followers:Int,industryCerified:Bool?, verificationLevel:Character?, isActive:Bool!) {
        self.name = name
        self.legalName = legalName
        self.toneDeafAppId = toneDeafAppId
        self.mainRole = mainRole
        self.roles = roles
        self.songs = songs?.sorted()
        self.videos = videos?.sorted()
        self.beats = beats?.sorted()
        self.instrumentals = instrumentals?.sorted()
        self.albums = albums?.sorted()
        self.merch = merch?.sorted()
        self.alternateNames = alternateNames
        self.dateRegisteredToApp = dateRegisteredToApp
        self.timeRegisteredToApp = timeRegisteredToApp
        self.linkedToAccount = linkedToAccount
        self.spotify = spotify
        self.apple = apple
        self.soundcloud = soundcloud
        self.youtubeMusic = youtubeMusic
        self.amazon = amazon
        self.deezer = deezer
        self.spinrilla = spinrilla
        self.napster = napster
        self.tidal = tidal
        self.youtube = youtube
        self.instagram = instagram
        self.facebook = facebook
        self.twitter = twitter
        self.tikTok = tikTok
        self.manualImageURL = manualImageURL
        self.followers = followers
        self.industryCerified = industryCerified
        self.verificationLevel = verificationLevel
        self.isActive = isActive
    }
    
    
    func mutableCopy(with zone: NSZone? = nil) -> Any {
        return PersonData(name: name, legalName: legalName, toneDeafAppId: toneDeafAppId, mainRole: mainRole, roles: roles, songs: songs, videos: videos, beats: beats, instrumentals: instrumentals, albums: albums, merch: merch, alternateNames: alternateNames, dateRegisteredToApp: dateRegisteredToApp, timeRegisteredToApp: timeRegisteredToApp, linkedToAccount: linkedToAccount, spotify: spotify, apple: apple, soundcloud: soundcloud, youtubeMusic: youtubeMusic, amazon: amazon, deezer: deezer, spinrilla: spinrilla, napster: napster, tidal: tidal, youtube: youtube, instagram: instagram, twitter: twitter, facebook: facebook, tikTok: tikTok, manualImageURL: manualImageURL, followers: followers, industryCerified: industryCerified, verificationLevel: verificationLevel, isActive: isActive)
    }
    
    func copy(with zone: NSZone? = nil) -> Any {
        let copy = PersonData(name: "", legalName: nil, toneDeafAppId: "", mainRole: "", roles: nil, songs: nil, videos: nil, beats: nil, instrumentals: nil, albums: nil, merch: nil, alternateNames: nil, dateRegisteredToApp: "", timeRegisteredToApp: "", linkedToAccount: "", spotify: nil, apple: nil, soundcloud: nil, youtubeMusic: nil, amazon: nil, deezer: nil, spinrilla: nil, napster: nil, tidal: nil, youtube: nil, instagram: nil, twitter: nil, facebook: nil, tikTok: nil, manualImageURL: nil,followers: 0, industryCerified: nil, verificationLevel: nil, isActive: false)
        copy.name = self.name
        copy.legalName = self.legalName
        copy.toneDeafAppId = self.toneDeafAppId
        copy.mainRole = self.mainRole
        copy.roles = self.roles
        copy.songs = self.songs?.sorted()
        copy.videos = self.videos?.sorted()
        copy.beats = self.beats?.sorted()
        copy.instrumentals = self.instrumentals?.sorted()
        copy.albums = self.albums?.sorted()
        copy.merch = self.merch?.sorted()
        copy.alternateNames = self.alternateNames
        copy.dateRegisteredToApp = self.dateRegisteredToApp
        copy.timeRegisteredToApp = self.timeRegisteredToApp
        copy.linkedToAccount = self.linkedToAccount
        copy.spotify = self.spotify
        copy.apple = self.apple
        copy.soundcloud = self.soundcloud
        copy.youtubeMusic = self.youtubeMusic
        copy.amazon = self.amazon
        copy.deezer = self.deezer
        copy.spinrilla = self.spinrilla
        copy.napster = self.napster
        copy.tidal = self.tidal
        copy.youtube = self.youtube
        copy.instagram = self.instagram
        copy.twitter = self.twitter
        copy.facebook = self.facebook
        copy.tikTok = self.tikTok
        copy.manualImageURL = self.manualImageURL
        copy.followers = self.followers
        copy.industryCerified = self.industryCerified
        copy.verificationLevel = self.verificationLevel
        copy.isActive = self.isActive
        return copy
    }
}

class SpotifyPersonData {
    var url:String!
    var isActive:Bool!
    var id:String!
    var profileImageURL:String!
    
    init(url:String!, isActive:Bool!, id:String!, profileImageURL:String!) {
        self.url = url
        self.isActive = isActive
        self.id = id
        self.profileImageURL = profileImageURL
    }
}
extension SpotifyPersonData: Equatable {
    static func == (lhs: SpotifyPersonData, rhs: SpotifyPersonData) -> Bool {
        let status = lhs.url == rhs.url
        && lhs.isActive == rhs.isActive
        && lhs.id == rhs.id
        && lhs.profileImageURL == rhs.profileImageURL
        return status
    }
}

class AppleMusicPersonData {
    var url:String!
    var isActive:Bool!
    var id:String!
    var allAlbumIDs:[String]?
    
    init(url:String!, isActive:Bool!, id:String!, allAlbumIDs:[String]?) {
        self.url = url
        self.isActive = isActive
        self.id = id
        self.allAlbumIDs = allAlbumIDs
    }
}
extension AppleMusicPersonData: Equatable {
    static func == (lhs: AppleMusicPersonData, rhs: AppleMusicPersonData) -> Bool {
        let status = lhs.url == rhs.url
        && lhs.isActive == rhs.isActive
        && lhs.id == rhs.id
        && lhs.allAlbumIDs == rhs.allAlbumIDs
        return status
    }
}

class SoundcloudPersonData {
    var url:String!
    var isActive:Bool!
    
    init(url:String!, isActive:Bool!) {
        self.url = url
        self.isActive = isActive
    }
}
extension SoundcloudPersonData: Equatable {
    static func == (lhs: SoundcloudPersonData, rhs: SoundcloudPersonData) -> Bool {
        let status = lhs.url == rhs.url
        && lhs.isActive == rhs.isActive
        return status
    }
}

class YoutubeMusicPersonData {
    var url:String!
    var isActive:Bool!
    
    init(url:String!, isActive:Bool!) {
        self.url = url
        self.isActive = isActive
    }
}
extension YoutubeMusicPersonData: Equatable {
    static func == (lhs: YoutubeMusicPersonData, rhs: YoutubeMusicPersonData) -> Bool {
        let status = lhs.url == rhs.url
        && lhs.isActive == rhs.isActive
        return status
    }
}

class AmazonPersonData {
    var url:String!
    var isActive:Bool!
    
    init(url:String!, isActive:Bool!) {
        self.url = url
        self.isActive = isActive
    }
}
extension AmazonPersonData: Equatable {
    static func == (lhs: AmazonPersonData, rhs: AmazonPersonData) -> Bool {
        let status = lhs.url == rhs.url
        && lhs.isActive == rhs.isActive
        return status
    }
}

class DeezerPersonData {
    var url:String!
    var profileImageURL:String!
    var id:String!
    var name:String!
    var isActive:Bool!
    
    init(url:String!,profileImageURL:String!, id:String!, name:String!, isActive:Bool!) {
        self.url = url
        self.profileImageURL = profileImageURL
        self.id = id
        self.name = name
        self.isActive = isActive
    }
}
extension DeezerPersonData: Equatable {
    static func == (lhs: DeezerPersonData, rhs: DeezerPersonData) -> Bool {
        let status = lhs.url == rhs.url
        && lhs.profileImageURL == rhs.profileImageURL
        && lhs.id == rhs.id
        && lhs.name == rhs.name
        && lhs.isActive == rhs.isActive
        return status
    }
}

class SpinrillaPersonData {
    var url:String!
    var isActive:Bool!
    
    init(url:String!, isActive:Bool!) {
        self.url = url
        self.isActive = isActive
    }
}
extension SpinrillaPersonData: Equatable {
    static func == (lhs: SpinrillaPersonData, rhs: SpinrillaPersonData) -> Bool {
        let status = lhs.url == rhs.url
        && lhs.isActive == rhs.isActive
        return status
    }
}

class NapsterPersonData {
    var url:String!
    var isActive:Bool!
    
    init(url:String!, isActive:Bool!) {
        self.url = url
        self.isActive = isActive
    }
}
extension NapsterPersonData: Equatable {
    static func == (lhs: NapsterPersonData, rhs: NapsterPersonData) -> Bool {
        let status = lhs.url == rhs.url
        && lhs.isActive == rhs.isActive
        return status
    }
}

class TidalPersonData {
    var url:String!
    var isActive:Bool!
    
    init(url:String!, isActive:Bool!) {
        self.url = url
        self.isActive = isActive
    }
}
extension TidalPersonData: Equatable {
    static func == (lhs: TidalPersonData, rhs: TidalPersonData) -> Bool {
        let status = lhs.url == rhs.url
        && lhs.isActive == rhs.isActive
        return status
    }
}

class YoutubePersonData {
    var url:String!
    var isActive:Bool!
    
    init(url:String!, isActive:Bool!) {
        self.url = url
        self.isActive = isActive
    }
}
extension YoutubePersonData: Equatable {
    static func == (lhs: YoutubePersonData, rhs: YoutubePersonData) -> Bool {
        let status = lhs.url == rhs.url
        && lhs.isActive == rhs.isActive
        return status
    }
}

class InstagramPersonData {
    var url:String!
    var isActive:Bool!
    
    init(url:String!, isActive:Bool!) {
        self.url = url
        self.isActive = isActive
    }
}
extension InstagramPersonData: Equatable {
    static func == (lhs: InstagramPersonData, rhs: InstagramPersonData) -> Bool {
        let status = lhs.url == rhs.url
        && lhs.isActive == rhs.isActive
        return status
    }
}

class FacebookPersonData {
    var url:String!
    var isActive:Bool!
    
    init(url:String!, isActive:Bool!) {
        self.url = url
        self.isActive = isActive
    }
}
extension FacebookPersonData: Equatable {
    static func == (lhs: FacebookPersonData, rhs: FacebookPersonData) -> Bool {
        let status = lhs.url == rhs.url
        && lhs.isActive == rhs.isActive
        return status
    }
}

class TwitterPersonData {
    var url:String!
    var isActive:Bool!
    var dateCreated:String!
    var name:String!
    var userName:String!
    var id:String!
    var profileImageURL:String!
    
    init(url:String!, isActive:Bool!, dateCreated:String!, name:String!, userName:String!, id:String!, profileImageURL:String!) {
        self.url = url
        self.isActive = isActive
        self.dateCreated = dateCreated
        self.name = name
        self.userName = userName
        self.id = id
        self.profileImageURL = profileImageURL
    }
}
extension TwitterPersonData: Equatable {
    static func == (lhs: TwitterPersonData, rhs: TwitterPersonData) -> Bool {
        let status = lhs.url == rhs.url
        && lhs.isActive == rhs.isActive
        && lhs.dateCreated == rhs.dateCreated
        && lhs.name == rhs.name
        && lhs.userName == rhs.userName
        && lhs.id == rhs.id
        && lhs.profileImageURL == rhs.profileImageURL
        return status
    }
}

class TikTokPersonData {
    var url:String!
    var isActive:Bool!
    
    init(url:String!, isActive:Bool!) {
        self.url = url
        self.isActive = isActive
    }
}
extension TikTokPersonData: Equatable {
    static func == (lhs: TikTokPersonData, rhs: TikTokPersonData) -> Bool {
        let status = lhs.url == rhs.url
        && lhs.isActive == rhs.isActive
        return status
    }
}

extension PersonData: Equatable {
    static func == (lhs: PersonData, rhs: PersonData) -> Bool {
        let status = lhs.toneDeafAppId == rhs.toneDeafAppId
        && lhs.name == rhs.name
        && lhs.legalName == rhs.legalName
        && lhs.alternateNames == rhs.alternateNames
        && lhs.mainRole == rhs.mainRole
        && lhs.roles == rhs.roles
        && lhs.songs?.sorted() == rhs.songs?.sorted()
        && lhs.albums?.sorted() == rhs.albums?.sorted()
        && lhs.videos?.sorted() == rhs.videos?.sorted()
        && lhs.instrumentals?.sorted() == rhs.instrumentals?.sorted()
        && lhs.beats?.sorted() == rhs.beats?.sorted()
        && lhs.merch?.sorted() == rhs.merch?.sorted()
        && lhs.dateRegisteredToApp == rhs.dateRegisteredToApp
        && lhs.timeRegisteredToApp == rhs.timeRegisteredToApp
        && lhs.linkedToAccount == rhs.linkedToAccount
        && lhs.spotify == rhs.spotify
        && lhs.apple == rhs.apple
        && lhs.soundcloud == rhs.soundcloud
        && lhs.youtubeMusic == rhs.youtubeMusic
        && lhs.amazon == rhs.amazon
        && lhs.deezer == rhs.deezer
        && lhs.spinrilla == rhs.spinrilla
        && lhs.napster == rhs.napster
        && lhs.tidal == rhs.tidal
        && lhs.youtube == rhs.youtube
        && lhs.instagram == rhs.instagram
        && lhs.twitter == rhs.twitter
        && lhs.facebook == rhs.facebook
        && lhs.tikTok == rhs.tikTok
        && lhs.manualImageURL == rhs.manualImageURL
        && lhs.followers == rhs.followers
        && lhs.industryCerified == rhs.industryCerified
        && lhs.verificationLevel == rhs.verificationLevel
        && lhs.isActive == rhs.isActive
        return status
    }
}



