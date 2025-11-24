//
//  PlayAudio.swift
//  ToneDeafDeafinitionsApp
//
//  Created by Tone Deaf on 8/13/20.
//  Copyright © 2020 GITEM Solutions. All rights reserved.
//

import Foundation
import AVFoundation

public class PlayAudio {
    
    static let shared = PlayAudio()
    
    var player: AVAudioPlayer?
    
    func playAudio(audioUrlStr: String) {
        DispatchQueue.main.async { [weak self] in
            guard let strongSelf = self else {return}
            if let url = URL(string: audioUrlStr) {
                do {
                    try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback)
                    strongSelf.player = try AVAudioPlayer(data: Data(contentsOf: url))
                    strongSelf.player?.prepareToPlay()
                    strongSelf.player?.volume = 1
                    print("Audio ready to play")
                    strongSelf.player?.play()
                } catch let error {
                    print("error occured while audio downloading")
                    print(error.localizedDescription)
                }
            }
        }
    }
}
