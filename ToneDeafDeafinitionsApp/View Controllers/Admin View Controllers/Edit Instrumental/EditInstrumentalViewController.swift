//
//  EditInstrumentalViewController.swift
//  ToneDeafDeafinitionsApp
//
//  Created by Tone Deaf on 7/18/22.
//  Copyright © 2022 GITEM Solutions. All rights reserved.
//

import UIKit

class EditInstrumentalViewController: UIViewController {

    static let shared = EditInstrumentalViewController()
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var artistsTableView: UITableView!
    @IBOutlet weak var artistsHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var producersTableView: UITableView!
    @IBOutlet weak var producersHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var albumsTableView: UITableView!
    @IBOutlet weak var albumsHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var videosTableView: UITableView!
    @IBOutlet weak var videosHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var songsTableView: UITableView!
    @IBOutlet weak var songsHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var changeInstrumentalButton: UIButton!
    @IBOutlet weak var imageURL: CopyableLabel!
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var name: CopyableLabel!
    @IBOutlet weak var audioURL: CopyableLabel!
    @IBOutlet weak var appIDLAbel: CopyableLabel!
    @IBOutlet weak var favoritesLabel: CopyableLabel!
    @IBOutlet weak var durationLabel: CopyableLabel!
    @IBOutlet weak var dateLabel: CopyableLabel!
    @IBOutlet weak var timeLabel: CopyableLabel!
    @IBOutlet weak var spotifyURL: UILabel!
    @IBOutlet weak var removeSpotifyURLButton: UIButton!
    @IBOutlet weak var appleMusicURL: UILabel!
    @IBOutlet weak var removeAppleMusicURLButton: UIButton!
    @IBOutlet weak var soundcloudURL: UILabel!
    @IBOutlet weak var removeSoundcloudURLButton: UIButton!
    @IBOutlet weak var youtubeMusicURL: UILabel!
    @IBOutlet weak var removeYoutubeMusicURLButton: UIButton!
    @IBOutlet weak var amazonURL: UILabel!
    @IBOutlet weak var removeAmazonURLButton: UIButton!
    @IBOutlet weak var deezerURL: UILabel!
    @IBOutlet weak var removeDeezerURLButton: UIButton!
    @IBOutlet weak var tidalURL: UILabel!
    @IBOutlet weak var removeTidalURLButton: UIButton!
    @IBOutlet weak var napsterURL: UILabel!
    @IBOutlet weak var removeNapsterURLButton: UIButton!
    @IBOutlet weak var spinrillaURL: UILabel!
    @IBOutlet weak var removeSpinrillaURLButton: UIButton!
    @IBOutlet weak var spotifyStatusControl: UISegmentedControl!
    @IBOutlet weak var appleMusicStatusControl: UISegmentedControl!
    @IBOutlet weak var soundcloudStatusControl: UISegmentedControl!
    @IBOutlet weak var youtubeMusicStatusControl: UISegmentedControl!
    @IBOutlet weak var amazonStatusControl: UISegmentedControl!
    @IBOutlet weak var deezerStatusControl: UISegmentedControl!
    @IBOutlet weak var tidalStatusControl: UISegmentedControl!
    @IBOutlet weak var napsterStatusControl: UISegmentedControl!
    @IBOutlet weak var spinrillaStatusControl: UISegmentedControl!
    @IBOutlet weak var statusControl: UISegmentedControl!
    @IBOutlet weak var updateButton: UIButton!
    
    var newImage:UIImage!
    var currentFileType = ""
    
    var artistsArr:[PersonData] = []
    var producersArr:[PersonData] = []
    var albumsArr:[AlbumData] = []
    var videosArr:[VideoData] = []
    var songsArr:[SongData] = []
    
    var instrumentalPickerView = UIPickerView()
    
    let hiddenInstrumentalTextField =  UITextField(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    
    var currentInstrumental:InstrumentalData!
    let initialInstrumental = InstrumentalData(instrumentalName: nil, toneDeafAppId: "", artist: nil, producers: [], mixEngineer: nil, masteringEngineer: nil, songName: nil, songs: nil, duration: "", audioURL: "", manualImageURL: nil, manualPreviewURL: nil, favoritesOverall: 0, officialVideo: nil, dateRegisteredToApp: "", timeRegisteredToApp: "", apple: nil, spotify: nil, soundcloud: nil, youtubeMusic: nil, amazon: nil, deezer: nil, spinrilla: nil, napster: nil, tidal: nil, videos: nil, albums: nil, merch: nil, storeInfo: nil, industryCerified: nil, verificationLevel: nil, isActive: false)

    override func viewDidLoad() {
        super.viewDidLoad()

        DatabaseManager.shared.fetchAllInstrumentalsFromDatabase(completion: {[weak self] allinstrumentals in
            guard let strongSelf = self else {return}
            AllInstrumentalsInDatabaseArray = allinstrumentals
            strongSelf.hiddenInstrumentalTextField.becomeFirstResponder()
        })
        
        setUpElements()
    }
    
    deinit {
        print("📗 Edit Instrumental view controller deinitialized.")
        AllInstrumentalsInDatabaseArray = nil
        currentInstrumental = nil
        newImage = nil
        NotificationCenter.default.removeObserver(self)
    }
    
    func setUpElements() {
        changeInstrumentalButton.setTitleColor(Constants.Colors.redApp, for: .normal)
        view.addSubview(hiddenInstrumentalTextField)
        hiddenInstrumentalTextField.isHidden = true
        hiddenInstrumentalTextField.inputView = instrumentalPickerView
        instrumentalPickerView.delegate = self
        instrumentalPickerView.dataSource = self
        pickerViewToolbar(textField: hiddenInstrumentalTextField, pickerView: instrumentalPickerView)
        hiddenInstrumentalTextField.delegate = self
    }
    
    func setUpPage() {
        changeInstrumentalButton.setTitleColor(Constants.Colors.redApp, for: .normal)
        pickerViewToolbar(textField: hiddenInstrumentalTextField, pickerView: instrumentalPickerView)
        name.text = currentInstrumental.instrumentalName
        appIDLAbel.text = currentInstrumental.toneDeafAppId
        favoritesLabel.text = String(currentInstrumental.favoritesOverall)
        dateLabel.text = currentInstrumental.dateRegisteredToApp
        timeLabel.text = currentInstrumental.timeRegisteredToApp
        durationLabel.text = String(currentInstrumental.duration)
        artistsTableView.delegate = self
        artistsTableView.dataSource = self
        if let psa = currentInstrumental.artist {
        setArtistsArr(arr: psa, completion: {[weak self] _ in
            guard let strongSelf = self else {return}
            strongSelf.artistsTableView.reloadData()
            strongSelf.artistsHeightConstraint.constant = CGFloat(50*(strongSelf.artistsArr.count))
        })
        } else {
            artistsHeightConstraint.constant = 0
        }
        producersTableView.delegate = self
        producersTableView.dataSource = self
        setProducersArr(arr: currentInstrumental.producers, completion: {[weak self] _ in
            guard let strongSelf = self else {return}
            strongSelf.producersTableView.reloadData()
            strongSelf.producersHeightConstraint.constant = CGFloat(50*(strongSelf.producersArr.count))
        })
        spotifyURL.text = currentInstrumental.spotify?.spotifySongURL
        if currentInstrumental.spotify?.spotifySongURL == nil || currentInstrumental.spotify?.spotifySongURL == "" {
            removeSpotifyURLButton.isHidden = true
            spotifyStatusControl.isHidden = true
        } else {
            spotifyStatusControl.isHidden = false
            removeSpotifyURLButton.isHidden = false
        }
        appleMusicURL.text = currentInstrumental.apple?.appleSongURL
        if currentInstrumental.apple?.appleSongURL == nil || currentInstrumental.apple?.appleSongURL == "" {
            removeAppleMusicURLButton.isHidden = true
            appleMusicStatusControl.isHidden = true
        } else {
            appleMusicStatusControl.isHidden = false
            removeAppleMusicURLButton.isHidden = false
        }
        soundcloudURL.text = currentInstrumental.soundcloud?.url
        if currentInstrumental.soundcloud?.url == nil || currentInstrumental.soundcloud?.url == "" {
            removeSoundcloudURLButton.isHidden = true
            soundcloudStatusControl.isHidden = true
        } else {
            soundcloudStatusControl.isHidden = false
            removeSoundcloudURLButton.isHidden = false
        }
        youtubeMusicURL.text = currentInstrumental.youtubeMusic?.url
        if currentInstrumental.youtubeMusic?.url == nil || currentInstrumental.youtubeMusic?.url == "" {
            removeYoutubeMusicURLButton.isHidden = true
            youtubeMusicStatusControl.isHidden = true
        } else {
            youtubeMusicStatusControl.isHidden = false
            removeYoutubeMusicURLButton.isHidden = false
        }
        amazonURL.text = currentInstrumental.amazon?.url
        if currentInstrumental.amazon?.url == nil || currentInstrumental.amazon?.url == "" {
            removeAmazonURLButton.isHidden = true
            amazonStatusControl.isHidden = true
        } else {
            amazonStatusControl.isHidden = false
            removeAmazonURLButton.isHidden = false
        }
        deezerURL.text = currentInstrumental.deezer?.url
        if currentInstrumental.deezer?.url == nil || currentInstrumental.deezer?.url == "" {
            removeDeezerURLButton.isHidden = true
            deezerStatusControl.isHidden = true
        } else {
            deezerStatusControl.isHidden = false
            removeDeezerURLButton.isHidden = false
        }
        tidalURL.text = currentInstrumental.tidal?.url
        if currentInstrumental.tidal?.url == nil || currentInstrumental.tidal?.url == "" {
            removeTidalURLButton.isHidden = true
            tidalStatusControl.isHidden = true
        } else {
            tidalStatusControl.isHidden = false
            removeTidalURLButton.isHidden = false
        }
        napsterURL.text = currentInstrumental.napster?.url
        if currentInstrumental.napster?.url == nil || currentInstrumental.napster?.url == "" {
            removeNapsterURLButton.isHidden = true
            napsterStatusControl.isHidden = true
        } else {
            napsterStatusControl.isHidden = false
            removeNapsterURLButton.isHidden = false
        }
        spinrillaURL.text = currentInstrumental.spinrilla?.url
        if currentInstrumental.spinrilla?.url == nil || currentInstrumental.spinrilla?.url == "" {
            removeSpinrillaURLButton.isHidden = true
            spinrillaStatusControl.isHidden = true
        } else {
            spinrillaStatusControl.isHidden = false
            removeSpinrillaURLButton.isHidden = false
        }
        
        if let seggo = currentInstrumental.spotify?.isActive {
            if seggo {
                spotifyStatusControl.selectedSegmentIndex = 0
                spotifyStatusControl.selectedSegmentTintColor = .systemGreen
            } else {
                spotifyStatusControl.selectedSegmentTintColor = Constants.Colors.redApp
                spotifyStatusControl.selectedSegmentIndex = 1
            }
        }
        if let seggo = currentInstrumental.apple?.isActive {
            if seggo {
                appleMusicStatusControl.selectedSegmentIndex = 0
                appleMusicStatusControl.selectedSegmentTintColor = .systemGreen
            } else {
                appleMusicStatusControl.selectedSegmentTintColor = Constants.Colors.redApp
                appleMusicStatusControl.selectedSegmentIndex = 1
            }
        }
        if let seggo = currentInstrumental.soundcloud?.isActive {
            if seggo {
                soundcloudStatusControl.selectedSegmentIndex = 0
                soundcloudStatusControl.selectedSegmentTintColor = .systemGreen
            } else {
                soundcloudStatusControl.selectedSegmentTintColor = Constants.Colors.redApp
                soundcloudStatusControl.selectedSegmentIndex = 1
            }
        }
        if let seggo = currentInstrumental.youtubeMusic?.isActive {
            if seggo {
                youtubeMusicStatusControl.selectedSegmentIndex = 0
                youtubeMusicStatusControl.selectedSegmentTintColor = .systemGreen
            } else {
                youtubeMusicStatusControl.selectedSegmentTintColor = Constants.Colors.redApp
                youtubeMusicStatusControl.selectedSegmentIndex = 1
            }
        }
        if let seggo = currentInstrumental.amazon?.isActive {
            if seggo {
                amazonStatusControl.selectedSegmentIndex = 0
                amazonStatusControl.selectedSegmentTintColor = .systemGreen
            } else {
                amazonStatusControl.selectedSegmentTintColor = Constants.Colors.redApp
                amazonStatusControl.selectedSegmentIndex = 1
            }
        }
        if let seggo = currentInstrumental.deezer?.isActive {
            if seggo {
                deezerStatusControl.selectedSegmentIndex = 0
                deezerStatusControl.selectedSegmentTintColor = .systemGreen
            } else {
                deezerStatusControl.selectedSegmentTintColor = Constants.Colors.redApp
                deezerStatusControl.selectedSegmentIndex = 1
            }
        }
        if let seggo = currentInstrumental.tidal?.isActive {
            if seggo {
                tidalStatusControl.selectedSegmentIndex = 0
                tidalStatusControl.selectedSegmentTintColor = .systemGreen
            } else {
                tidalStatusControl.selectedSegmentTintColor = Constants.Colors.redApp
                tidalStatusControl.selectedSegmentIndex = 1
            }
        }
        if let seggo = currentInstrumental.napster?.isActive {
            if seggo {
                napsterStatusControl.selectedSegmentIndex = 0
                napsterStatusControl.selectedSegmentTintColor = .systemGreen
            } else {
                napsterStatusControl.selectedSegmentTintColor = Constants.Colors.redApp
                napsterStatusControl.selectedSegmentIndex = 1
            }
        }
        if let seggo = currentInstrumental.spinrilla?.isActive {
            if seggo {
                spinrillaStatusControl.selectedSegmentIndex = 0
                spinrillaStatusControl.selectedSegmentTintColor = .systemGreen
            } else {
                spinrillaStatusControl.selectedSegmentTintColor = Constants.Colors.redApp
                spinrillaStatusControl.selectedSegmentIndex = 1
            }
        }
        albumsTableView.delegate = self
        albumsTableView.dataSource = self
        if let psa = currentInstrumental.albums {
            setAlbumsArr(arr: psa, completion: {[weak self] _ in
                guard let strongSelf = self else {return}
                strongSelf.albumsTableView.reloadData()
                strongSelf.albumsHeightConstraint.constant = CGFloat(50*(strongSelf.albumsArr.count))
            })
        } else {
            albumsHeightConstraint.constant = 0
        }
        videosTableView.delegate = self
        videosTableView.dataSource = self
        if let psa = currentInstrumental.videos {
            setVideosArr(arr: psa, completion: {[weak self] _ in
                guard let strongSelf = self else {return}
                strongSelf.videosTableView.reloadData()
                strongSelf.videosHeightConstraint.constant = CGFloat(50*(strongSelf.videosArr.count))
            })
        } else {
            videosHeightConstraint.constant = 0
        }
        songsTableView.delegate = self
        songsTableView.dataSource = self
        if let psa = currentInstrumental.songs {
            setSongsArr(arr: psa, completion: {[weak self] _ in
                guard let strongSelf = self else {return}
                strongSelf.songsTableView.reloadData()
                strongSelf.songsHeightConstraint.constant = CGFloat(50*(strongSelf.songsArr.count))
            })
        } else {
            songsHeightConstraint.constant = 0
        }
        if currentInstrumental.isActive {
            statusControl.selectedSegmentIndex = 0
            statusControl.selectedSegmentTintColor = .systemGreen
        } else {
            statusControl.selectedSegmentTintColor = Constants.Colors.redApp
            statusControl.selectedSegmentIndex = 1
        }
        GlobalFunctions.shared.selectPreviewURL(instrumental: currentInstrumental, completion: {[weak self] previewurl in
            guard let strongSelf = self else {return}
            guard let previewurl = previewurl else {
                strongSelf.audioURL.text = "No Preview Available"
                strongSelf.audioURL.alpha = 0.75
                return
            }
            strongSelf.audioURL.alpha = 1
            strongSelf.audioURL.text = previewurl
        })
        GlobalFunctions.shared.selectImageURL(instrumental: currentInstrumental, completion: {[weak self] aimage in
            guard let strongSelf = self else {return}
            guard let imge = aimage else {
                strongSelf.image.image = UIImage(named: "tonedeaflogo")
                strongSelf.imageURL.text = "No Image"
                strongSelf.imageURL.alpha = 0.5
                return
            }
            strongSelf.imageURL.alpha = 1
            strongSelf.imageURL.text = imge
            let imageURL = URL(string: imge)!
            if let cachedImage = imageCache.object(forKey: imageURL.absoluteString as NSString) {
                strongSelf.image.image = cachedImage
            } else {
                strongSelf.image.setImage(from: imageURL, withPlaceholder: UIImage(named: "tonedeaflogo"))
            }
            
        })
    }
    
    func setArtistsArr(arr: [String], completion: @escaping ((Error?) -> Void)) {
            artistsArr = []
            if arr != [] {
                for person in arr {
                    getPerson(personIdFull: person, completion: {[weak self] personData in
                        guard let strongSelf = self else {return}
                        strongSelf.artistsArr.append(personData)
                        completion(nil)
                    })
                }
            } else {
                artistsHeightConstraint.constant = CGFloat(50*(artistsArr.count))
            }
    }
    
    func setProducersArr(arr: [String], completion: @escaping ((Error?) -> Void)) {
            producersArr = []
            if arr != [] {
                for person in arr {
                    getPerson(personIdFull: person, completion: {[weak self] personData in
                        guard let strongSelf = self else {return}
                        strongSelf.producersArr.append(personData)
                        completion(nil)
                    })
                }
            } else {
                producersHeightConstraint.constant = CGFloat(50*(producersArr.count))
            }
    }
    
    func setAlbumsArr(arr: [String], completion: @escaping ((Error?) -> Void)) {
            albumsArr = []
            if arr != [] {
                
                for song in arr {
                    getAlbum(albumIdFull: song, completion: {[weak self] songData in
                        
                        guard let strongSelf = self else {return}
                        strongSelf.albumsArr.append(songData)
                        completion(nil)
                    })
                }
            } else {
                albumsHeightConstraint.constant = CGFloat(50*(albumsArr.count))
            }
    }
    
    func setVideosArr(arr: [String], completion: @escaping ((Error?) -> Void)) {
            videosArr = []
            if arr != [] {
                
                for video in arr {
                    getVideo(videoIdFull: video, completion: {[weak self] videoData in
                        
                        guard let strongSelf = self else {return}
                        strongSelf.videosArr.append(videoData)
                        completion(nil)
                    })
                }
            } else {
                videosHeightConstraint.constant = CGFloat(50*(videosArr.count))
            }
    }
    
    func setSongsArr(arr: [String], completion: @escaping ((Error?) -> Void)) {
            songsArr = []
            if arr != [] {
                for song in arr {
                    getSong(songIdFull: song, completion: {[weak self] songData in
                        guard let strongSelf = self else {return}
                        strongSelf.songsArr.append(songData)
                        completion(nil)
                    })
                }
            } else {
                songsHeightConstraint.constant = CGFloat(50*(songsArr.count))
            }
    }
    
    @IBAction func newInstrumentalTapped(_ sender: Any) {
        hiddenInstrumentalTextField.becomeFirstResponder()
    }

    //MARK: - Keyboard Dismissals

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @objc func dismissKeyboard2() {
        NotificationCenter.default.post(name: adminDashboardStopSpinnerNotify, object: nil)
//        personTikTokURL.textColor = .white
//        personTwitterURL.textColor = .white
//        personInstagramURL.textColor = .white
//        personSpinrillaURL.textColor = .white
//        personNapsterURL.textColor = .white
//        personTidalURL.textColor = .white
//        personDeezerURL.textColor = .white
//        personAmazonURL.textColor = .white
//        personYoutubeMusicURL.textColor = .white
//        personSoundcloudURL.textColor = .white
//        personYoutubeChannelURL.textColor = .white
//        personAppleMusicURL.textColor = .white
//        personSpotifyURL.textColor = .white
//        personLegalName.textColor = .white
        name.textColor = .white
        imageURL.textColor = .white
        audioURL.textColor = .white
        setUpPage()
        view.endEditing(true)
    }

}

extension EditInstrumentalViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func presentPhotoActionSheet() {
        let actionSheet = UIAlertController(title: "Open photo library?", message: nil, preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
        actionSheet.addAction(UIAlertAction(title: "Yes", style: .default, handler: { [weak self] _ in
            self?.openGallery()
        
        }))
        actionSheet.view.tintColor = Constants.Colors.redApp
        present(actionSheet, animated: true)
    }
    
    func openGallery() {
        let vc = UIImagePickerController()
        vc.sourceType = .photoLibrary
        vc.delegate = self
        vc.allowsEditing = true
        present(vc, animated: true)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        print("📙 \(info)")
        guard let selectedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else {
            return
        }
        
        image.image = selectedImage
        imageURL.text = "New Image Selected"
        imageURL.textColor = .green
        newImage = selectedImage
//        currentInstrumental.imageURL = "NEW"
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
}

extension EditInstrumentalViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func pickerSelected(row: Int, pickerView: UIPickerView) {
        if pickerView == pickerView {
            var arr:[InstrumentalData] = []
            arr.append(contentsOf: AllInstrumentalsInDatabaseArray)
            let a = AllInstrumentalsInDatabaseArray[row]
            currentInstrumental = arr[row]
            let b = a
            
            initialInstrumental.toneDeafAppId = b.toneDeafAppId
            initialInstrumental.duration = b.duration
            initialInstrumental.songs = b.songs
            initialInstrumental.albums = b.albums
            initialInstrumental.videos = b.videos
            initialInstrumental.merch = b.merch
            initialInstrumental.instrumentalName = b.instrumentalName
            initialInstrumental.artist = b.artist
            initialInstrumental.producers = b.producers
            initialInstrumental.songName = b.songName
            initialInstrumental.favoritesOverall = b.favoritesOverall
            initialInstrumental.manualImageURL = b.manualImageURL
            initialInstrumental.manualPreviewURL = b.manualPreviewURL
            initialInstrumental.audioURL = b.audioURL
            initialInstrumental.storeInfo = b.storeInfo
            initialInstrumental.apple = b.apple
            initialInstrumental.spotify = b.spotify
            initialInstrumental.soundcloud = b.soundcloud
            initialInstrumental.youtubeMusic = b.youtubeMusic
            initialInstrumental.amazon = b.amazon
            initialInstrumental.deezer = b.deezer
            initialInstrumental.spinrilla = b.spinrilla
            initialInstrumental.napster = b.napster
            initialInstrumental.tidal = b.tidal
            initialInstrumental.officialVideo = b.officialVideo
            initialInstrumental.verificationLevel = b.verificationLevel
            initialInstrumental.industryCerified = b.industryCerified
            initialInstrumental.isActive = b.isActive
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        var nor = 0
        if pickerView == pickerView {
           nor = AllInstrumentalsInDatabaseArray.count
        }
        return nor
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        var nor = ""
        if pickerView == pickerView {
            nor = "\(AllInstrumentalsInDatabaseArray[row].instrumentalName!) -- \(AllInstrumentalsInDatabaseArray[row].toneDeafAppId)"
        }
        return nor
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == pickerView {
        pickerSelected(row: row, pickerView: pickerView)
        }
    }
    
    func pickerViewToolbar(textField:UITextField, pickerView:UIPickerView) {
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor.init(red: 182/255, green: 0/255, blue: 3/255, alpha: 1)
        toolBar.sizeToFit()

        var doneButton = UIBarButtonItem()
        if pickerView == pickerView {
           doneButton = UIBarButtonItem(title: "Select", style: UIBarButtonItem.Style.done, target: self, action: #selector(dismissKeyboard2))
        }
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItem.Style.plain, target: self, action: #selector(dismissKeyboard))

        if currentInstrumental == nil {
            toolBar.setItems([spaceButton, doneButton], animated: false)
        }
        else
        {
            toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        }
        toolBar.isUserInteractionEnabled = true

        textField.inputView = pickerView
        textField.inputAccessoryView = toolBar
    }
}

extension EditInstrumentalViewController : UITableViewDataSource, UITableViewDelegate {
    func getPerson(personIdFull: String, completion: @escaping (PersonData) -> Void) {
        let word = personIdFull.split(separator: "Æ")
        let id = String(word[0])
        DatabaseManager.shared.fetchPersonData(person: id, completion: { result in
            switch result {
            case .success(let person):
                completion(person)
            case .failure(let err):
                print("b  bk"+err.localizedDescription)
            }
        })
    }
    
    func getAlbum(albumIdFull: String, completion: @escaping (AlbumData) -> Void) {
        let word = albumIdFull.split(separator: "Æ")
        let id = String(word[0])
        DatabaseManager.shared.findAlbumById(albumId: id, completion: { result in
            switch result {
            case .success(let album):
                completion(album)
            case .failure(let err):
                print("dsvgredfjbhxbdfzx"+err.localizedDescription)
            }
        })
    }
    
    func getVideo(videoIdFull: String, completion: @escaping (VideoData) -> Void) {
        let word = videoIdFull.split(separator: "Æ")
        let id = String(word[0])
        DatabaseManager.shared.findVideoById(videoid: id, completion: { result in
            switch result {
            case .success(let video):
                completion(video)
            case .failure(let err):
                print("dsvgredfxbdfzx"+err.localizedDescription)
            }
        })
    }
    
    func getSong(songIdFull: String, completion: @escaping (SongData) -> Void) {
        let word = songIdFull.split(separator: "Æ")
        let id = String(word[0])
        DatabaseManager.shared.findSongById(songId: id, completion: { result in
            switch result {
            case .success(let song):
                completion(song)
            case .failure(let err):
                print("dsvgredfjbhxbdfzx"+err.localizedDescription)
            }
        })
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch tableView {
        case artistsTableView:
            return artistsArr.count
        case producersTableView:
            return producersArr.count
        case albumsTableView:
            return albumsArr.count
        case videosTableView:
            return videosArr.count
        case songsTableView:
            return songsArr.count
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch tableView {
        case artistsTableView:
            let cell = tableView.dequeueReusableCell(withIdentifier: "roleEditSongCell", for: indexPath) as! RoleEditSongCell
            if !artistsArr.isEmpty {

                cell.setUp(person: artistsArr[indexPath.row])
            }
            return cell
        case producersTableView:
            let cell = tableView.dequeueReusableCell(withIdentifier: "roleEditSongCell", for: indexPath) as! RoleEditSongCell
            if !producersArr.isEmpty {

                cell.setUp(person: producersArr[indexPath.row])
            }
            return cell
        case albumsTableView:
            let cell = tableView.dequeueReusableCell(withIdentifier: "editPersonAlbumCell", for: indexPath) as! EditPersonAlbumCell
            if !albumsArr.isEmpty {
                cell.setUp(album: albumsArr[indexPath.row], artistId: currentInstrumental.toneDeafAppId)
            }
            return cell
        case videosTableView:
            let cell = tableView.dequeueReusableCell(withIdentifier: "editPersonVideoCell", for: indexPath) as! EditPersonVideoCell
            if !videosArr.isEmpty {
                cell.setUp(video: videosArr[indexPath.row], artistId: currentInstrumental.toneDeafAppId)
            }
            return cell
        case songsTableView:
            let cell = tableView.dequeueReusableCell(withIdentifier: "roleEditSongCell", for: indexPath) as! RoleEditSongCell
            if !songsArr.isEmpty {
                //print(personSongsArr[indexPath.row].songArtist, personSongsArr[indexPath.row].songProducers)
                cell.setUp(song: songsArr[indexPath.row])
            }
            return cell
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            switch tableView {
            case artistsTableView:
                artistsArr.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
                artistsHeightConstraint.constant = CGFloat(50*(artistsArr.count))
            default:
                break
            }
        }
    }
    
    
}

extension EditInstrumentalViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        switch textField {
        case hiddenInstrumentalTextField:
            if currentInstrumental == nil {
                pickerSelected(row: 0, pickerView: instrumentalPickerView)
            }
            else {
                var count = 0
                for per in AllInstrumentalsInDatabaseArray {
                    if per.toneDeafAppId == currentInstrumental.toneDeafAppId {
                        pickerSelected(row: count, pickerView: instrumentalPickerView)
                    } else {
                        count+=1
                    }
                }
            }
        default:
            break
        }
    }
}
