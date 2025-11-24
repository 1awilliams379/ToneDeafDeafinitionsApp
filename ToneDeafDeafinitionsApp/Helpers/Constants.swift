//
//  Constants.swift
//  ToneDeafDeafinitionsApp
//
//  Created by Tone Deaf on 7/27/20.
//  Copyright © 2020 GITEM Solutions. All rights reserved.
//

import Foundation
import UIKit

struct Constants {
    
    struct StorageURLs {
        static let appLogo = "https://firebasestorage.googleapis.com/v0/b/tonedeafdeafinitions.appspot.com/o/Image%20Defaults%2Ftonedeaflogoblackback.png?alt=media&token=39fedf20-f461-452e-8ee7-0e1149ab9503"
    }
    
    struct Colors {
        static let redApp = UIColor.init(red: 182/255, green: 0/255, blue: 3/255, alpha: 1)
        static let mediumApp = UIColor.init(red: 15/255, green: 15/255, blue: 15/255, alpha: 1)
        static let darkApp = UIColor.init(red: 8/255, green: 8/255, blue: 8/255, alpha: 1)
        static let lightApp = UIColor.init(red: 22/255, green: 22/255, blue: 22/255, alpha: 1)
        static let extralightApp = UIColor.init(red: 30/255, green: 30/255, blue: 30/255, alpha: 1)
    }
    
    struct Storyboard {
        static let dashboardViewController = "dashboardVC"
        static let loginViewController = "loginVC"
        static let registrationViewController = "registrationVC"
        static let dashboardTabBarController = "dashboardTabBarController"
        
    }
    
    struct Videos {
        static let typeArr:[String] = ["Music Video", "Audio Video", "Instrumental", "Beat", "Snippet", "Interview", "Vlog", "Lyric Video", "Release Trailer", "Behind The Scenes","Promotional", "Playlist", "Other"]
    }
    
    struct Verification {
        static let verificationLevels:[Character] = ["A","B","C","U"]
    }
    
    struct Beats {
        static let keys = ["C Minor/Eb Major", "Db Minor/ E Major", "D Minor/ F Major", "Eb Minor/ Gb Major", "E Minor/ G Major", "F Minor/ Ab Major", "Gb Minor/ A Major", "G Minor/ Bb Major", "Ab Minor/ B Major", "A Minor/ C Major", "Bb Minor/ Db Major", "B Minor/ D Major"]
        static var types = ["Dark","Melodic","Aggressive","Smooth","R&B", "Vibey","Club","Joyful","Soulful","Experimental","Calm","Epic", "Simple","Trap", "Relaxed"]
        static var sounds = ["Keys","Piano Acoustic", "Organ", "Piano Electric", "Theramin", "Piano Vinyl", "Whistle", "Piano Rhodes", "Horns", "Pad Aggressive", "Pad Bell", "Pad Hollow", "Flute", "Strings", "Synth Poly", "Synth Analog", "Sax", "Guitar Electric", "Choir", "Guitar Acoustic", "Bells EDM", "Guitar Steel", "Bells Vinyl", "Bells Gothic", "Bells Hollow", "No Kick", "Kick", "Sample Vocal", "808 Long", "Sample Song", "808 Short", "808 Distorted", "808 Clean", "Moog Bass", "Sub Bass", "Synth Bass Distorted", "Snap", "Synth Bass Deep"]
    }
}
