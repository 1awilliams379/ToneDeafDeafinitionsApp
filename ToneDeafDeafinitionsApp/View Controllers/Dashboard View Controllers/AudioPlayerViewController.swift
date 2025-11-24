//
//  AudioPlayerViewController.swift
//  ToneDeafDeafinitionsApp
//
//  Created by Tone Deaf on 8/12/20.
//  Copyright © 2020 GITEM Solutions. All rights reserved.
//

let AudioPlayerOnNotificationKey = "com.gitemsolutions.AudioPalyerOn"
let AudioPlayerOnSongNotificationKey = "com.gitemsolutions.AudioPalyerOnSong"
let AudioPlayerOnInstrumentalNotificationKey = "com.gitemsolutions.AudioPalyerOnInstrumental"
let AudioPlayerInfoNotificationKey = "com.gitemsolutions.AudioPalyerInfo"
let AudioPlayerInfoSongNotificationKey = "com.gitemsolutions.AudioPalyerInfoSong"
let AudioPlayerInfoInstrumentalNotificationKey = "com.gitemsolutions.AudioPalyerInfoInstremental"
let AudioPlayerViewUpdateNotificationKey = "com.gitemsolutions.AudioPalyerViewUpdate"

let AudioPlayerOnNotify = Notification.Name(AudioPlayerOnNotificationKey)
let AudioPlayerOnSongNotify = Notification.Name(AudioPlayerOnSongNotificationKey)
let AudioPlayerOnInstrumentalNotify = Notification.Name(AudioPlayerOnInstrumentalNotificationKey)
let AudioPlayerInfoNotify = Notification.Name(AudioPlayerInfoNotificationKey)
let AudioPlayerInfoSongNotify = Notification.Name(AudioPlayerInfoSongNotificationKey)
let AudioPlayerInfoInstrumentalNotify = Notification.Name(AudioPlayerInfoInstrumentalNotificationKey)
let AudioPlayerViewUpdateNotify = Notification.Name(AudioPlayerViewUpdateNotificationKey)

var player: AVAudioPlayer?

import UIKit
import AVFoundation
import MediaPlayer

class AudioPlayerViewController: UIViewController, AVAudioPlayerDelegate {
    
    static let shared = AudioPlayerViewController()
    
    public var position: Int = 0
    public var beats: [BeatData] = []
    
    var playbackfreeze = false
    var playbackTimer:Timer!
    
    var observercount = 0
    var outputVolumeObserve: NSKeyValueObservation?
    var volume = AVAudioSession.sharedInstance().outputVolume
    
    weak var beatNameLabelLeadingConstraint:NSLayoutConstraint!
    weak var beatNameLabeltopConstraint:NSLayoutConstraint!
    weak var beatNameLabeltralingConstraint:NSLayoutConstraint!
    
    weak var audioPlayerImageCenterleadingConstraint:NSLayoutConstraint!
    weak var audioPlayerImageCentertopConstraint:NSLayoutConstraint!
    weak var audioPlayerImageCenterwidthConstraint:NSLayoutConstraint!
    weak var audioPlayerImageCenterheightConstraint:NSLayoutConstraint!
     weak var audioPlayerImageCenterXConstraint:NSLayoutConstraint!
    
    weak var beatProducerLabelTopConstraint:NSLayoutConstraint!
    weak var beatProducerLabelLeadingConstraint:NSLayoutConstraint!
    weak var beatProducerLabelTrailingConstraint:NSLayoutConstraint!
    
    
    weak var pauseButtonWidthConstraint:NSLayoutConstraint!
    weak var pauseButtonTrailingConstraint:NSLayoutConstraint!
    weak var pauseButtonHeightConstraint:NSLayoutConstraint!
    weak var pauseButtonVerticalCenterConstraint:NSLayoutConstraint!
    weak var pauseButtonHorizontalCenterConstraint:NSLayoutConstraint!
    weak var pauseButtonTopConstraint:NSLayoutConstraint!
    
    
    weak var forwardButtonWidthConstraint:NSLayoutConstraint!
    weak var forwardButtonHeightConstraints:NSLayoutConstraint!
    weak var forwardButtonTrailingConstraint:NSLayoutConstraint!
    weak var forwardVerticalCenterConstraint:NSLayoutConstraint!
    weak var forwardButtonLeadingConstraint:NSLayoutConstraint!
    weak var forwardButtonTopConstraint:NSLayoutConstraint!
    
    weak var backwardButtonTrailingConstraint:NSLayoutConstraint!
    weak var backwardButtonTopConstraint:NSLayoutConstraint!
    weak var backwardButtonWidthConstraint:NSLayoutConstraint!
    weak var backwardButtonHeightConstraints:NSLayoutConstraint!
    
    weak var beatDurationSliderLabelTopConstraint:NSLayoutConstraint!
    weak var beatDurationSliderlLeadingConstraint:NSLayoutConstraint!
    weak var beatDurationSliderTrailingConstraint:NSLayoutConstraint!
    
    weak var moreContentTopConstraint:NSLayoutConstraint!
    weak var moreContentConstraint:NSLayoutConstraint!
    
    
    @IBOutlet weak var holder: UIView!
    @IBOutlet weak var handleArea: UIView!
    @IBOutlet weak var handleSlit: UIView!
    @IBOutlet weak var grayBar: UIView!
    
    @IBOutlet weak var beatNameLabel: UILabel!
    @IBOutlet weak var audioPlayerImage: UIImageView!
    
    @IBOutlet var backwardTap: UITapGestureRecognizer!
    @IBOutlet weak var forwardButton: UIButton!
    @IBOutlet weak var pauseButton: UIButton!
    @IBOutlet weak var beatProducersLabel: UILabel!
    @IBOutlet weak var backwardButton: UIButton!
    @IBOutlet weak var durationSlider: UISlider!
    @IBOutlet weak var moreContentButton: UIImageView!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var durationCurrent: UILabel!
    @IBOutlet weak var speakerDown: UIImageView!
    @IBOutlet weak var speakerUp: UIImageView!
    @IBOutlet weak var volumeHolder: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        blurredBackground()
        handleSlit.layer.cornerRadius = 1.5
        if holder.subviews.count == 0 {
            createObservers()
            observercount+=1
        }
        UIApplication.shared.beginReceivingRemoteControlEvents()
        setupRemoteTransportControls()
        
        let mpVolume = MPVolumeView(frame: CGRect(x: 0, y: volumeHolder.frame.height/2 - 10, width: volumeHolder.frame.width - 40, height: volumeHolder.frame.height))
        mpVolume.showsRouteButton = false
        volumeHolder.addSubview(mpVolume)
        
        durationSlider.value = 0

    }
    
    func setupRemoteTransportControls() {
        // Get the shared MPRemoteCommandCenter
        let commandCenter = MPRemoteCommandCenter.shared()

        commandCenter.changePlaybackPositionCommand.isEnabled = true
        // Add handler for Play Command
        commandCenter.playCommand.addTarget { [unowned self] event in
            if player?.isPlaying == false {
                player?.play()
                self.pauseButton.setBackgroundImage(UIImage(systemName: "pause.fill"), for: .normal)
                return .success
            }
            return .commandFailed
        }

        // Add handler for Pause Command
        commandCenter.pauseCommand.addTarget { [unowned self] event in
            if player?.isPlaying == true {
                player?.pause()
                self.pauseButton.setBackgroundImage(UIImage(systemName: "play.fill"), for: .normal)
                return .success
            
            }
            return .commandFailed
        }
        
        commandCenter.nextTrackCommand.addTarget { [unowned self] event in
            if self.position < (self.beats.count-1) {
                self.position = self.position + 1
                player?.stop()
                self.configure()
            } else {
                self.position = 0
                player?.stop()
                self.configure()
            }
            return .commandFailed
        }
        
        commandCenter.previousTrackCommand.addTarget { [unowned self] event in
            if self.position > 0 {
                self.position = self.position - 1
                player?.stop()
                self.configure()
            }
            return .commandFailed
        }
        
        commandCenter.changePlaybackPositionCommand.addTarget { [unowned self] event in
            let event = event as! MPChangePlaybackPositionCommandEvent
            print("change playback",event.positionTime)
            player?.currentTime = event.positionTime
            self.setupNowPlaying()
            return .success
        }
    }
    
    
    @IBAction func playpauseTapped(_ sender: Any) {
        print("tapped")
        if player?.isPlaying == true {
            player?.pause()
            pauseButton.setBackgroundImage(UIImage(systemName: "play.fill"), for: .normal)
            
        
        } else {
            player?.play()
            pauseButton.setBackgroundImage(UIImage(systemName: "pause.fill"), for: .normal)
        }
    }
    @IBAction func forwardTapped(_ sender: Any) {
        print("fowraed")
        if position < (beats.count-1) {
            position = position + 1
            player?.stop()
        } else {
            position = 0
            player?.stop()
        }
        configure()
    }
    @IBAction func backwardTapped(_ sender: Any) {
        print("Back")
        if position > 0 {
            position = position - 1
            player?.stop()
            configure()
        }
    }
    
    @IBAction func durationSliderChanged(_ sender: Any) {
        player?.currentTime = TimeInterval(durationSlider.value)
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        //volumeSlider.value = volume
        DispatchQueue.global().async { [weak self] in
        guard let strongSelf = self else {return}
        strongSelf.outputVolumeObserve = AVAudioSession.sharedInstance().observe(\.outputVolume, options: [.new]) { (audioSession, changes) in
            print(changes.newValue!)
            //strongSelf.volumeSlider.value = changes.newValue!
            //strongSelf.player?.volume = changes.newValue!
            }
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        print("deinit")
        //NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    func blurredBackground() {
        let backgroundImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height))
        view.addSubview(backgroundImageView)
        backgroundImageView.image = UIImage(named: "IMG_4686")
        view.sendSubviewToBack(backgroundImageView)
        
        let blur = UIBlurEffect(style: .dark)
        let blurView = UIVisualEffectView(effect: blur)
        blurView.frame = view.bounds
        view.addSubview(blurView)
        view.sendSubviewToBack(blurView)
        view.sendSubviewToBack(backgroundImageView)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func expandedAnimations(notification: NSNotification) {
        let cardState = notification.object as! String
        //setUPUIAnimation()
        if cardState == "expanded" {
            print("received")
            DispatchQueue.main.async { [weak self] in
                           guard let strongSelf = self else {return}
                strongSelf.expandUIAnimation()
                strongSelf.audioPlayerImage.dropShadowplayer()
                strongSelf.audioPlayerImage.layer.cornerRadius = 5
            }
        } else if cardState == "collapsed" {
            DispatchQueue.main.async { [weak self] in
                           guard let strongSelf = self else {return}
                strongSelf.collapseUIAnimation()
                strongSelf.audioPlayerImage.dropShadowplayer()
                strongSelf.audioPlayerImage.layer.cornerRadius = 2.5
            }
        }
    }
    
    func collapseUIAnimation() {
        if backwardButtonTrailingConstraint != nil {
            backwardButtonTrailingConstraint.isActive = false
        }
        if moreContentTopConstraint != nil {
            moreContentTopConstraint.isActive = false
            moreContentTopConstraint = moreContentButton.topAnchor.constraint(equalTo: view.bottomAnchor, constant: 30)
            moreContentTopConstraint.isActive = true
        }
        collapseImageConstraints()
       collapseNameLabelConstraints()
        collapseProducerLabelConstraints()
        collapsePAuseButtonConstraints()
       collapseFowardButtonConstraints()
        pauseButton.isUserInteractionEnabled = true
        forwardButton.isUserInteractionEnabled = true
        backwardButton.isUserInteractionEnabled = true
        moreContentButton.isUserInteractionEnabled = true
    }
    
    func collapseImageConstraints() {
        audioPlayerImage.translatesAutoresizingMaskIntoConstraints = false
        if audioPlayerImageCenterleadingConstraint != nil {
            audioPlayerImage.removeConstraint(audioPlayerImageCenterleadingConstraint)
        }
        if  audioPlayerImageCenterXConstraint != nil {
            audioPlayerImage.removeConstraint(audioPlayerImageCenterXConstraint)
        }
        audioPlayerImageCenterleadingConstraint = audioPlayerImage.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10)
        audioPlayerImageCenterXConstraint.isActive = false
        audioPlayerImageCentertopConstraint.constant = 10
        audioPlayerImageCenterleadingConstraint.isActive = true
        audioPlayerImageCenterheightConstraint.constant = 50
        audioPlayerImageCenterwidthConstraint.constant = 50
        
        audioPlayerImage.layer.cornerRadius = 2.5
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.9, initialSpringVelocity: 2, options: .curveEaseInOut, animations: { [weak self] in
            guard let strongSelf = self else {return}
            strongSelf.view.layoutIfNeeded()
            }, completion: nil)
    }
    
    func collapseNameLabelConstraints() {
        beatNameLabel.translatesAutoresizingMaskIntoConstraints = false
        beatNameLabelLeadingConstraint.isActive = false
        beatNameLabeltopConstraint.isActive = false
        beatNameLabeltralingConstraint.isActive = false
        beatNameLabelLeadingConstraint = beatNameLabel.leadingAnchor.constraint(equalTo: audioPlayerImage.trailingAnchor, constant: 10)
        beatNameLabeltopConstraint = beatNameLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 10)
        beatNameLabeltralingConstraint = beatNameLabel.trailingAnchor.constraint(equalTo: pauseButton.leadingAnchor, constant: 10)
        beatNameLabelLeadingConstraint.isActive = true
        beatNameLabeltopConstraint.isActive = true
        beatNameLabeltralingConstraint.isActive = true
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.9, initialSpringVelocity: 2, options: .curveEaseInOut, animations: { [weak self] in
            guard let strongSelf = self else {return}
            strongSelf.view.layoutIfNeeded()
            }, completion: nil)
    }
    
    func collapseProducerLabelConstraints() {
        beatProducersLabel.translatesAutoresizingMaskIntoConstraints = false
        beatProducerLabelLeadingConstraint.isActive = false
        beatProducerLabelTopConstraint.isActive = false
        beatProducerLabelTrailingConstraint.isActive = false
        beatProducerLabelLeadingConstraint = beatProducersLabel.leadingAnchor.constraint(equalTo: audioPlayerImage.trailingAnchor, constant: 10)
        beatProducerLabelTopConstraint = beatProducersLabel.topAnchor.constraint(equalTo: beatNameLabel.bottomAnchor, constant: 0)
        beatProducerLabelTrailingConstraint = beatProducersLabel.trailingAnchor.constraint(equalTo: pauseButton.leadingAnchor, constant: 10)
        beatProducerLabelLeadingConstraint.isActive = true
        beatProducerLabelTopConstraint.isActive = true
        beatProducerLabelTrailingConstraint.isActive = true
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.9, initialSpringVelocity: 2, options: .curveEaseInOut, animations: { [weak self] in
            guard let strongSelf = self else {return}
            strongSelf.view.layoutIfNeeded()
            }, completion: nil)
    }
    
    func collapsePAuseButtonConstraints() {
        pauseButton.translatesAutoresizingMaskIntoConstraints = false
        
        pauseButtonTopConstraint.isActive = false
        pauseButtonWidthConstraint.isActive = false
        pauseButtonHeightConstraint.isActive = false
        pauseButtonHorizontalCenterConstraint.isActive = false
        
        pauseButtonWidthConstraint = pauseButton.widthAnchor.constraint(equalToConstant: 25)
        pauseButtonHeightConstraint = pauseButton.heightAnchor.constraint(equalToConstant: 31)
        pauseButtonTrailingConstraint = pauseButton.trailingAnchor.constraint(equalTo: forwardButton.leadingAnchor, constant: -20)
        pauseButtonVerticalCenterConstraint = pauseButton.centerYAnchor.constraint(equalTo: audioPlayerImage.centerYAnchor)
        
        pauseButtonHeightConstraint.isActive = true
        pauseButtonWidthConstraint.isActive = true
        pauseButtonTrailingConstraint.isActive = true
        pauseButtonVerticalCenterConstraint.isActive = true
        
        DispatchQueue.main.async { [weak self] in
            guard let strongSelf = self else {return}
            strongSelf.pauseButton.updateConstraints()
            strongSelf.view.layoutIfNeeded()
        }
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.9, initialSpringVelocity: 2, options: .curveEaseInOut, animations: { [weak self] in
        guard let strongSelf = self else {return}
        strongSelf.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    func collapseFowardButtonConstraints() {
        forwardButton.translatesAutoresizingMaskIntoConstraints = false
        forwardButtonLeadingConstraint.isActive = false
        forwardButtonTopConstraint.isActive = false
        forwardButtonHeightConstraints.isActive = false
        forwardButtonWidthConstraint.isActive = false
        forwardButtonWidthConstraint = forwardButton.widthAnchor.constraint(equalToConstant: 37)
        forwardButtonHeightConstraints = forwardButton.heightAnchor.constraint(equalToConstant: 31.5)
        forwardButtonTrailingConstraint = forwardButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        forwardVerticalCenterConstraint = forwardButton.centerYAnchor.constraint(equalTo: audioPlayerImage.centerYAnchor, constant: 0)
        forwardButtonTrailingConstraint.isActive = true
        forwardVerticalCenterConstraint.isActive = true
        forwardButtonHeightConstraints.isActive = true
        forwardButtonWidthConstraint.isActive = true
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.9, initialSpringVelocity: 2, options: .curveEaseInOut, animations: { [weak self] in
        guard let strongSelf = self else {return}
        strongSelf.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    func expandUIAnimation() {
        animateExpandedAudioPlayerImage()
        animateExpandedAudioPlayerName()
       animateExpandedAudioPlayerPause()
     animateExpandedAudioPlayerProducers()
       animateExpandedAudioPlayerFoward()
        animateExpandedAudioPlayerDurSlider()
       animateExpandedAudioPlayerBackward()
        animateExpandedAudioPlayerMoreContent()
        pauseButton.isUserInteractionEnabled = true
        forwardButton.isUserInteractionEnabled = true
        backwardButton.isUserInteractionEnabled = true
        moreContentButton.isUserInteractionEnabled = true
    }
    
    func animateExpandedAudioPlayerImage() {
        audioPlayerImage.translatesAutoresizingMaskIntoConstraints = false
        if audioPlayerImageCenterleadingConstraint != nil {
            audioPlayerImageCenterleadingConstraint.isActive = false
        }
        if audioPlayerImageCentertopConstraint != nil {
            audioPlayerImageCentertopConstraint.isActive = false
        }
        if audioPlayerImageCenterheightConstraint != nil {
            audioPlayerImage.removeConstraint(audioPlayerImageCenterheightConstraint)
        }
        if audioPlayerImageCenterwidthConstraint != nil {
            audioPlayerImage.removeConstraint(audioPlayerImageCenterwidthConstraint)
        }
        if audioPlayerImageCenterXConstraint != nil {
            audioPlayerImage.removeConstraint(audioPlayerImageCenterXConstraint)
        }
        audioPlayerImageCentertopConstraint = audioPlayerImage.topAnchor.constraint(equalTo: view.topAnchor, constant: 30)
        audioPlayerImageCenterwidthConstraint = audioPlayerImage.widthAnchor.constraint(equalToConstant: 250)
        audioPlayerImageCenterheightConstraint = audioPlayerImage.heightAnchor.constraint(equalToConstant: 250)
        audioPlayerImageCenterXConstraint = audioPlayerImage.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        
        audioPlayerImageCentertopConstraint.isActive = true
        audioPlayerImageCenterwidthConstraint.isActive = true
        audioPlayerImageCenterheightConstraint.isActive = true
        audioPlayerImageCenterXConstraint.isActive = true
        audioPlayerImage.layer.cornerRadius = 5
            audioPlayerImage.updateConstraints()
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.9, initialSpringVelocity: 2, options: .curveEaseInOut, animations: { [weak self] in
                guard let strongSelf = self else {return}
                strongSelf.view.layoutIfNeeded()
            }, completion: nil)
    }
    
    func animateExpandedAudioPlayerName() {
        beatNameLabel.translatesAutoresizingMaskIntoConstraints = false
        if beatNameLabelLeadingConstraint != nil {
            beatNameLabelLeadingConstraint.isActive = false
        }
        if beatNameLabeltopConstraint != nil {
            beatNameLabeltopConstraint.isActive = false
        }
        if beatNameLabeltralingConstraint != nil {
            beatNameLabeltralingConstraint.isActive = false
        }
        beatNameLabelLeadingConstraint = beatNameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30)
        beatNameLabeltopConstraint = beatNameLabel.topAnchor.constraint(equalTo: audioPlayerImage.bottomAnchor, constant: 15)
        beatNameLabeltralingConstraint = beatNameLabel.trailingAnchor.constraint(equalTo: moreContentButton.leadingAnchor, constant: 10)
        beatNameLabelLeadingConstraint.isActive = true
        beatNameLabeltopConstraint.isActive = true
        beatNameLabeltralingConstraint.isActive = true
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.9, initialSpringVelocity: 2, options: .curveEaseInOut, animations: { [weak self] in
            guard let strongSelf = self else {return}
            strongSelf.view.layoutIfNeeded()
            }, completion: nil)
    }
    
    func animateExpandedAudioPlayerProducers() {
        beatProducersLabel.translatesAutoresizingMaskIntoConstraints = false
        if beatProducerLabelLeadingConstraint != nil {
            beatProducerLabelLeadingConstraint.isActive = false
        }
        if beatProducerLabelTopConstraint != nil {
            beatProducerLabelTopConstraint.isActive = false
        }
        if beatProducerLabelTrailingConstraint != nil {
            beatProducerLabelTrailingConstraint.isActive = false
        }
        beatProducerLabelLeadingConstraint = beatProducersLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30)
        beatProducerLabelTopConstraint = beatProducersLabel.topAnchor.constraint(equalTo: beatNameLabel.bottomAnchor, constant: 0)
        beatProducerLabelTrailingConstraint = beatProducersLabel.trailingAnchor.constraint(equalTo: moreContentButton.leadingAnchor, constant: 10)
        beatProducerLabelLeadingConstraint.isActive = true
        beatProducerLabelTopConstraint.isActive = true
        beatProducerLabelTrailingConstraint.isActive = true
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.9, initialSpringVelocity: 2, options: .curveEaseInOut, animations: { [weak self] in
            guard let strongSelf = self else {return}
            strongSelf.view.layoutIfNeeded()
            }, completion: nil)
    }
    
    func animateExpandedAudioPlayerPause() {
        pauseButton.translatesAutoresizingMaskIntoConstraints = false
        if pauseButtonTopConstraint != nil {
            pauseButtonTopConstraint.isActive = false
        }
        if pauseButtonTrailingConstraint != nil {
            pauseButtonTrailingConstraint.isActive = false
        }
        if pauseButtonVerticalCenterConstraint != nil {
            pauseButtonVerticalCenterConstraint.isActive = false
        }
        if pauseButtonWidthConstraint != nil {
             pauseButtonWidthConstraint.isActive = false
        }
        if pauseButtonHeightConstraint != nil {
            pauseButtonHeightConstraint.isActive = false
        }
        if pauseButtonHorizontalCenterConstraint != nil {
            pauseButtonHorizontalCenterConstraint.isActive = false
        }
        pauseButtonWidthConstraint = pauseButton.widthAnchor.constraint(equalToConstant: 50*0.6)
        pauseButtonHeightConstraint = pauseButton.heightAnchor.constraint(equalToConstant: 59*0.6)
        pauseButtonHorizontalCenterConstraint = pauseButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        pauseButtonTopConstraint = pauseButton.topAnchor.constraint(equalTo: durationSlider.bottomAnchor, constant: 30)
        pauseButtonWidthConstraint.isActive = true
        pauseButtonHeightConstraint.isActive = true
        pauseButtonHorizontalCenterConstraint.isActive = true
        pauseButtonTopConstraint.isActive = true
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.9, initialSpringVelocity: 2, options: .curveEaseInOut, animations: { [weak self] in
        guard let strongSelf = self else {return}
        strongSelf.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    func animateExpandedAudioPlayerFoward() {
        forwardButton.translatesAutoresizingMaskIntoConstraints = false
        if forwardButtonTrailingConstraint != nil {
            forwardButtonTrailingConstraint.isActive = false
        }
        if forwardVerticalCenterConstraint != nil {
            forwardVerticalCenterConstraint.isActive = false
        }
        if forwardButtonHeightConstraints != nil {
            forwardButtonHeightConstraints.isActive = false
        }
        if forwardButtonWidthConstraint != nil {
             forwardButtonWidthConstraint.isActive = false
        }
        if forwardButtonTopConstraint != nil {
            forwardButtonTopConstraint.isActive = false
        }
        if forwardButtonTrailingConstraint != nil {
            forwardButtonTrailingConstraint.isActive = false
        }
        forwardButtonWidthConstraint = forwardButton.widthAnchor.constraint(equalToConstant: 74*0.6)
        forwardButtonHeightConstraints = forwardButton.heightAnchor.constraint(equalToConstant: 54*0.6)
        forwardButtonTopConstraint = forwardButton.topAnchor.constraint(equalTo: durationSlider.bottomAnchor, constant: 30)
        forwardButtonLeadingConstraint = forwardButton.leadingAnchor.constraint(equalTo: pauseButton.trailingAnchor, constant: 50)
        forwardButtonWidthConstraint.isActive = true
        forwardButtonHeightConstraints.isActive = true
        forwardButtonLeadingConstraint.isActive = true
        forwardButtonTopConstraint.isActive = true
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.9, initialSpringVelocity: 2, options: .curveEaseInOut, animations: { [weak self] in
        guard let strongSelf = self else {return}
        strongSelf.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    func animateExpandedAudioPlayerDurSlider() {
        durationSlider.translatesAutoresizingMaskIntoConstraints = false
        if beatDurationSliderLabelTopConstraint != nil {
            beatDurationSliderLabelTopConstraint.isActive = false
        }
        beatDurationSliderLabelTopConstraint = durationSlider.topAnchor.constraint(equalTo: beatProducersLabel.bottomAnchor, constant: 20)
        beatDurationSliderLabelTopConstraint.isActive = true
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.9, initialSpringVelocity: 2, options: .curveEaseInOut, animations: { [weak self] in
                       guard let strongSelf = self else {return}
                       strongSelf.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    func animateExpandedAudioPlayerMoreContent() {
        moreContentButton.translatesAutoresizingMaskIntoConstraints = false
        if moreContentConstraint != nil {
            moreContentConstraint.isActive = false
        }
        if moreContentTopConstraint != nil {
            moreContentTopConstraint.isActive = false
        }
        moreContentTopConstraint = moreContentButton.topAnchor.constraint(equalTo: audioPlayerImage.bottomAnchor, constant: 30)
        moreContentConstraint = moreContentButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30)
        moreContentTopConstraint.isActive = true
        moreContentConstraint.isActive = true
    }
    
    func animateExpandedAudioPlayerBackward() {
    backwardButton.translatesAutoresizingMaskIntoConstraints = false
        
    if backwardButtonWidthConstraint != nil {
        backwardButtonWidthConstraint.isActive = false
    }
    if backwardButtonHeightConstraints != nil {
        backwardButtonHeightConstraints.isActive = false
    }
    if backwardButtonTrailingConstraint != nil {
        backwardButtonTrailingConstraint.isActive = false
    }
        
    backwardButtonWidthConstraint = backwardButton.widthAnchor.constraint(equalToConstant: 74*0.6)
        backwardButtonHeightConstraints = backwardButton.heightAnchor.constraint(equalToConstant: 54*0.6)
    backwardButtonTrailingConstraint = backwardButton.trailingAnchor.constraint(equalTo: pauseButton.leadingAnchor, constant: -50)
        
    backwardButtonWidthConstraint.isActive = true
    backwardButtonHeightConstraints.isActive = true
    backwardButtonTrailingConstraint.isActive = true
    UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.9, initialSpringVelocity: 2, options: .curveEaseInOut, animations: { [weak self] in
                   guard let strongSelf = self else {return}
                   strongSelf.view.layoutIfNeeded()
    }, completion: nil)
    }
    
    func createObservers(){
        NotificationCenter.default.addObserver(self, selector: #selector(AudioPlayerViewController.expandedAnimations(notification:)), name: AudioPlayerViewUpdateNotify, object: nil)
          NotificationCenter.default.addObserver(self, selector: #selector(AudioPlayerViewController.setVariables), name: AudioPlayerInfoNotify, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(AudioPlayerViewController.setSongVariables), name: AudioPlayerInfoSongNotify, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(AudioPlayerViewController.setInstrumentalVariables), name: AudioPlayerInfoInstrumentalNotify, object: nil)
    }
    
    @objc func setVariables(notification: NSNotification) {
        print("up dea")
        let dict = notification.object as! NSDictionary
        beats = dict["beats"] as! [BeatData]
        position = dict["position"] as! Int
        if holder.subviews.count == 0 {
            configure()
        }
        NotificationCenter.default.removeObserver(self, name: AudioPlayerInfoNotify, object: nil)
        //animateAudioPlayerImage()
    }
    
    @objc func setSongVariables(notification: NSNotification) {
        print("up dea")
        let dict = notification.object as! NSDictionary
        var url:URL!
//        var pic:UIImage!
        var song:SongData!
        url = dict["url"] as? URL
        song = (dict["song"] as! SongData)
//        pic = dict["artwork"] as? UIImage
//        audioPlayerImage.image = pic
        if holder.subviews.count == 0 {
            play(url: url, song: song)
        }
        NotificationCenter.default.removeObserver(self, name: AudioPlayerInfoSongNotify, object: nil)
        //animateAudioPlayerImage()
    }
    
    @objc func setInstrumentalVariables(notification: NSNotification) {
        print("up dea")
        let dict = notification.object as! NSDictionary
        var url:URL!
//        var pic:UIImage!
        var beat:InstrumentalData!
        url = dict["url"] as? URL
        beat = dict["beat"] as? InstrumentalData
//        pic = dict["artwork"] as? UIImage
//        audioPlayerImage.image = pic
        if holder.subviews.count == 0 {
            playInstrumental(url: url, beat: beat)
        }
        NotificationCenter.default.removeObserver(self, name: AudioPlayerInfoInstrumentalNotify, object: nil)
        //animateAudioPlayerImage()
    }
    
    func configure() {
        player?.stop()
        let beat = beats[position]
        let url = beat.audioURL
        
        beatNameLabel.text = beat.name
        durationLabel.text = beat.duration
        beatProducersLabel.text = "Tone Deaf"
        
        let audioUrlStr = url
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let strongSelf = self else {return}
            if let url = URL(string: audioUrlStr) {
                do {
                    if strongSelf.playbackfreeze != true {
                        strongSelf.playbackfreeze = true
                        strongSelf.playbackTimer = Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(strongSelf.playbackTimerset), userInfo: nil, repeats: false)
                        print("Playback try")
                        try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: [])
                        print("Playback OK")
                        try AVAudioSession.sharedInstance().setActive(true)
                        print("Session is Active")
                        player = try AVAudioPlayer(data: Data(contentsOf: url))
                        DispatchQueue.main.async {
                            strongSelf.durationSlider.maximumValue = Float(player!.duration)
                            strongSelf.durationSlider.value = 0
                            //strongSelf.volumeSlider.value = strongSelf.volume
                            player?.prepareToPlay()
                            player?.volume = strongSelf.volume
                            print("Audio ready to play")
                            player?.play()
                            strongSelf.setupNowPlaying()
                            Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self?.updateTime(_:)), userInfo: nil, repeats: true)
                        }
                    }
                } catch let error {
                    print("error occured while audio downloading \(error.localizedDescription)")
                    print(error.localizedDescription)
                }
            }
        }
        
        
        
    }
    
    @objc func playbackTimerset() {
        playbackfreeze = false
        print("Playback Freeze Off")
        playbackTimer.invalidate()
    }
    
    @objc func updateTime(_ timer: Timer) {
        durationSlider.value = Float(player?.currentTime ?? 0.0)
        durationCurrent.text = String(durationSlider.value)
    }
    
    func setupNowPlaying() {
        let beat = beats[position]
        // Define Now Playing Info
        var nowPlayingInfo = [String : Any]()
        nowPlayingInfo[MPMediaItemPropertyTitle] = beat.name
        
        if let image = UIImage(named: "tonedeaflogo") {
            nowPlayingInfo[MPMediaItemPropertyArtwork] =
              MPMediaItemArtwork(boundsSize: image.size) { size in
                  return image
          }
      }
    nowPlayingInfo[MPNowPlayingInfoPropertyElapsedPlaybackTime] = player?.currentTime
    nowPlayingInfo[MPMediaItemPropertyPlaybackDuration] = player?.duration
    nowPlayingInfo[MPNowPlayingInfoPropertyPlaybackRate] = player?.rate
    nowPlayingInfo[MPMediaItemPropertyArtist] = "Tone Deaf"

      // Set the metadata
        MPNowPlayingInfoCenter.default().nowPlayingInfo = nowPlayingInfo
    }
    
    func setupNowPlayingPreview(song: SongData) {
        // Define Now Playing Info
        var nowPlayingInfo = [String : Any]()
        nowPlayingInfo[MPMediaItemPropertyTitle] = song.name
        
        if let image = audioPlayerImage.image ?? UIImage(named: "tonedeaflogo") {
            nowPlayingInfo[MPMediaItemPropertyArtwork] =
                MPMediaItemArtwork(boundsSize: image.size) { size in
                    return image
            }
        }
        nowPlayingInfo[MPNowPlayingInfoPropertyElapsedPlaybackTime] = player?.currentTime
        nowPlayingInfo[MPMediaItemPropertyPlaybackDuration] = player?.duration
        nowPlayingInfo[MPNowPlayingInfoPropertyPlaybackRate] = player?.rate
        
        getArtistData(song: song, completion: { artistNames in
            
            nowPlayingInfo[MPMediaItemPropertyArtist] = artistNames.joined(separator: ", ")
            MPNowPlayingInfoCenter.default().nowPlayingInfo = nowPlayingInfo
        })
        
        // Set the metadata
    }
    
    func setupNowPlayingInstrumental(beat: InstrumentalData) {
        // Define Now Playing Info
        var nowPlayingInfo = [String : Any]()
      nowPlayingInfo[MPMediaItemPropertyTitle] = beat.instrumentalName

      if let image = audioPlayerImage.image ?? UIImage(named: "tonedeaflogo") {
            nowPlayingInfo[MPMediaItemPropertyArtwork] =
                MPMediaItemArtwork(boundsSize: image.size) { size in
                    return image
            }
        }
      nowPlayingInfo[MPNowPlayingInfoPropertyElapsedPlaybackTime] = player?.currentTime
      nowPlayingInfo[MPMediaItemPropertyPlaybackDuration] = player?.duration
      nowPlayingInfo[MPNowPlayingInfoPropertyPlaybackRate] = player?.rate
        nowPlayingInfo[MPMediaItemPropertyArtist] = beat.producers.joined(separator: ", ")

        // Set the metadata
        MPNowPlayingInfoCenter.default().nowPlayingInfo = nowPlayingInfo
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if let player = player {
            print("disappear")
            player.stop()
        }
    }
    
    fileprivate func getArtistData(song:SongData, completion: @escaping (Array<String>) -> Void) {
        var artistNameData:Array<String> = []
        var val = 0
        for artist in song.songArtist {
            let word = artist.split(separator: "Æ")
            let id = word[1]
            val+=1
            artistNameData.append(String(id))
            if val == song.songArtist.count {
                completion(artistNameData)
            }
        }
        
    }
    
    func getProducerData(instrumental:InstrumentalData, completion: @escaping (Array<String>) -> Void) {
        var producerNameData:Array<String> = []
        var val = 0
        for producer in instrumental.producers {
            
            let word = producer.split(separator: "Æ")
            let id = word[1]
            val+=1
            producerNameData.append(String(id))
            if val == instrumental.producers.count {
                completion(producerNameData)
            }
        }
    }
    
    func getSongYoutubeData(song:SongData, completion: @escaping (Array<YouTubeData>, Array<String>) -> Void) {
        var videosData:Array<YouTubeData> = []
        var youtubeimageURLs:Array<String> = []
        var val = 1
        if song.videos![0] != "" && !song.videos![0].isEmpty {
            for video in song.videos! {
                let word = video.split(separator: "Æ")
                let id = word[1]
                DatabaseManager.shared.findVideoById(videoid: String(id), completion: { selectedVideo in
                    //print(song.songArtist.count)
                    switch selectedVideo {
                    case .success(let vid):
                        let video = vid as! YouTubeData
                        videosData.append(video)
                        if video.thumbnailURL != "" {
                            youtubeimageURLs.append(video.thumbnailURL)
                        }
                        if val == song.videos!.count {
                            completion(videosData, youtubeimageURLs)
                        }
                        val+=1
                    case .failure(let error):
                        print("Video ID proccessing error \(error)")
                    }
                })
            }
        } else {
            completion(videosData, youtubeimageURLs)
        }
        
    }
    
    func play(url: URL,  song: SongData) {
        
        player?.stop()
        print("playing \(url)")
        
        var imageurl = ""
        getSongYoutubeData(song: song, completion: {[weak self] videos,videothumbnails in
            guard let strongSelf = self else {return}
            
            if song.spotify?.spotifyArtworkURL != "" {
                imageurl = song.spotify!.spotifyArtworkURL
            } else if song.apple?.appleArtworkURL != "" {
                imageurl = song.apple!.appleArtworkURL
            } else if !videothumbnails.isEmpty {
                imageurl = videothumbnails[0]
            }
            
            if let url = URL.init(string: imageurl) {
                
                if let cachedImage = imageCache.object(forKey: url.absoluteString as NSString) {
                    strongSelf.audioPlayerImage.image = cachedImage
                } else {
                    strongSelf.audioPlayerImage.setImage(from: url, withPlaceholder: UIImage(named: "tonedeaflogo"))
                }
            }
            
            strongSelf.beatNameLabel.text = song.name
            strongSelf.durationLabel.text = "00:30"
            strongSelf.getArtistData(song: song, completion: { [weak self] artistNames in
                guard let strongSelf = self else {return}
                strongSelf.beatProducersLabel.text = artistNames.joined(separator: ", ")
                do {
                    DispatchQueue.global(qos: .userInitiated).async { [weak self] in
                        guard let strongSelf = self else {return}
                        
                        do {
                            if strongSelf.playbackfreeze != true {
                                strongSelf.playbackfreeze = true
                                strongSelf.playbackTimer = Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(strongSelf.playbackTimerset), userInfo: nil, repeats: false)
                                print("Playback try")
                                try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: [])
                                print("Playback OK")
                                try AVAudioSession.sharedInstance().setActive(true)
                                print("Session is Active")
                                player = try AVAudioPlayer(data: Data(contentsOf: url))
                                DispatchQueue.main.async {
                                    strongSelf.durationSlider.maximumValue = Float(player!.duration)
                                    strongSelf.durationSlider.value = 0
                                    //strongSelf.volumeSlider.value = strongSelf.volume
                                    player?.prepareToPlay()
                                    player?.volume = strongSelf.volume
                                    print("Audio ready to play")
                                    player?.play()
                                    strongSelf.setupNowPlayingPreview(song: song)
                                    Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self?.updateTime(_:)), userInfo: nil, repeats: true)
                                }
                            }
                        } catch let error {
                            print("error occured while audio downloading \(error.localizedDescription)")
                            print(error.localizedDescription)
                        }
                    }
                    
                } catch let error {
                    print(error.localizedDescription)
                    player = nil
                }
            })
        })
        
        
    }
    
    func playInstrumental(url: URL,  beat: InstrumentalData) {
        
        player?.stop()
        print("playing \(url)")
        var imageurl = ""
        imageurl = "beat.imageURL"
        if let url = URL.init(string: imageurl) {
            if let cachedImage = imageCache.object(forKey: url.absoluteString as NSString) {
                audioPlayerImage.image = cachedImage
            } else {
                audioPlayerImage.setImage(from: url, withPlaceholder: UIImage(named: "tonedeaflogo"))
            }
        }
        beatNameLabel.text = beat.instrumentalName
        durationLabel.text = beat.duration
        getProducerData(instrumental: beat, completion: { [weak self] names in
            guard let strongSelf = self else {return}
            strongSelf.beatProducersLabel.text = names.joined(separator: ", ")
            do {
                DispatchQueue.global(qos: .userInitiated).async {
                    
                    do {
                        if strongSelf.playbackfreeze != true {
                            strongSelf.playbackfreeze = true
                            strongSelf.playbackTimer = Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(strongSelf.playbackTimerset), userInfo: nil, repeats: false)
                            print("Playback try")
                            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: [])
                            print("Playback OK")
                            try AVAudioSession.sharedInstance().setActive(true)
                            print("Session is Active")
                            player = try AVAudioPlayer(data: Data(contentsOf: url))
                            DispatchQueue.main.async {
                                strongSelf.durationSlider.maximumValue = Float(player!.duration)
                                strongSelf.durationSlider.value = 0
                                //strongSelf.volumeSlider.value = strongSelf.volume
                                player?.prepareToPlay()
                                player?.volume = strongSelf.volume
                                print("Audio ready to play")
                                player?.play()
                                strongSelf.setupNowPlayingInstrumental(beat: beat)
                                Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self?.updateTime(_:)), userInfo: nil, repeats: true)
                            }
                        }
                    } catch let error {
                        print("error occured while audio downloading \(error.localizedDescription)")
                            print(error.localizedDescription)
                        }
                }

            } catch let error {
                print(error.localizedDescription)
                player = nil
            }
        })

    }
}



//let audioUrlStr = urlString
//if let url = URL(string: audioUrlStr) {
//   do {
//    try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback)
//      self.player = try AVAudioPlayer(data: Data(contentsOf: url))
//    self.player!.prepareToPlay()
//    player?.volume = 1
//      print("Audio ready to play")
//      self.player!.play()
//   } catch let error {
//        print("error occured while audio downloading")
//        print(error.localizedDescription)
//   }
//}
