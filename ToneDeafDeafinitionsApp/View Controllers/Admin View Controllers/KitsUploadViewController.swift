//
//  KitsUploadViewController.swift
//  ToneDeafDeafinitionsApp
//
//  Created by Tone Deaf on 10/26/20.
//  Copyright © 2020 GITEM Solutions. All rights reserved.
//

import UIKit
import MobileCoreServices
import FirebaseDatabase
import FirebaseStorage

protocol UploadKitsPersonsDelegate: class {
    func personAdded(_ person: PersonData)
}

protocol UploadKitsSongsDelegate: class {
    func songAdded(_ song: SongData)
}

protocol UploadKitsAlbumsDelegate: class {
    func albumAdded(_ album: AlbumData)
}

protocol UploadKitsVideosDelegate: class {
    func videoAdded(_ video: VideoData)
}

protocol UploadKitsInstrumentalsDelegate: class {
    func instrumentalAdded(_ instrumental: InstrumentalData)
}

protocol UploadKitsBeatsDelegate: class {
    func beatAdded(_ beat: BeatData)
}

class KitsUploadViewController: UIViewController, UploadKitsPersonsDelegate, UploadKitsSongsDelegate, UploadKitsAlbumsDelegate, UploadKitsVideosDelegate, UploadKitsInstrumentalsDelegate, UploadKitsBeatsDelegate {
    
    @IBOutlet weak var scrollView1:UIScrollView!
    @IBOutlet weak var imagesTableView:UITableView!
    @IBOutlet weak var personTableView: UITableView!
    @IBOutlet weak var personHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var videosTableView: UITableView!
    @IBOutlet weak var videosHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var songsTableView: UITableView!
    @IBOutlet weak var songsHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var albumsTableView: UITableView!
    @IBOutlet weak var albumsHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var instrumaentalsTableView: UITableView!
    @IBOutlet weak var instrumentalsHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var beatsTableView: UITableView!
    @IBOutlet weak var beatsHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var pickImage: UIImageView!
    @IBOutlet weak var uploadButton: UIButton!
    @IBOutlet weak var nameTextField: UITextField! {
        didSet {
            let placeholderText = NSAttributedString(string: "Name",
                                                        attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray.withAlphaComponent(0.4)])
            
            nameTextField.attributedPlaceholder = placeholderText
        }
    }
    @IBOutlet weak var descriptionTextField: UITextView!
    @IBOutlet weak var subCategoryTextField: UITextField! {
        didSet {
            let placeholderText = NSAttributedString(string: "Select",
                                                        attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray.withAlphaComponent(0.4)])
            
            subCategoryTextField.attributedPlaceholder = placeholderText
        }
    }
    @IBOutlet weak var fileTextField: UITextField! {
        didSet {
            let placeholderText = NSAttributedString(string: "Select File",
                                                        attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray.withAlphaComponent(0.4)])
            
            fileTextField.attributedPlaceholder = placeholderText
        }
    }
    @IBOutlet weak var audioPreviewTextField: UITextField! {
        didSet {
            let placeholderText = NSAttributedString(string: "Select Preview",
                                                        attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray.withAlphaComponent(0.4)])
            
            audioPreviewTextField.attributedPlaceholder = placeholderText
        }
    }
    @IBOutlet weak var priceTextField: CurrencyTextField! {
        didSet {
            let placeholderText = NSAttributedString(string: "Price",
                                                        attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray.withAlphaComponent(0.4)])
            
            priceTextField.attributedPlaceholder = placeholderText
        }
    }
    @IBOutlet weak var quantityTextField: UITextField! {
        didSet {
            let placeholderText = NSAttributedString(string: "Quantity",
                                                        attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray.withAlphaComponent(0.4)])
            
            quantityTextField.attributedPlaceholder = placeholderText
        }
    }
    
    var date:String!
    var tDAppId:String = ""
    var selectedImageArray:[UIImage] = []
    var selectedImageURLsArray:[String] = []
    var arr = ""
    var prevPage = ""
    var currentFileType = ""
    var newAudio:URL!
    var newExclusive:URL!
    var selectedPreviewAudioURL:URL!
    var previewURL:String!
    var selectedFileURL:URL!
    var fileURL: String!
    var kitName:String!
    var kitSubCategory:String!
    var kitDescription:String!
    var subCategoryPickerView = UIPickerView()
    let subcategories = ["Loop Kits", "Drum Kits", "Sound Kit (Loop & Drum)"]
    var kitPrice:Double?
    var kitQuantity:Int?
    var chosenVideo:VideoData!
    var videoArr:[VideoData] = []
    var videonames:[String] = []
    var chosenPerson:PersonData!
    var personArr:[PersonData] = []
    var personnames:[String] = []
    var chosenSong:SongData!
    var songArr:[SongData] = []
    var songnames:[String] = []
    var chosenAlbum:AlbumData!
    var albumArr:[AlbumData] = []
    var albumnames:[String] = []
    var chosenInstrumental:InstrumentalData!
    var instrumentalArr:[InstrumentalData] = []
    var instrumentalnames:[String] = []
    var chosenBeat:BeatData!
    var beatArr:[BeatData] = []
    var beatnames:[String] = []
    
    var uploadCompletionStatus1:Bool!
    var uploadCompletionStatus2:Bool!
    var uploadCompletionStatus3:Bool!
    var uploadCompletionStatus4:Bool!
    var uploadCompletionStatus5:Bool!
    var uploadCompletionStatus6:Bool!
    var uploadCompletionStatus7:Bool!
    var uploadCompletionStatus8:Bool!
    var uploadCompletionStatus9:Bool!
    var uploadCompletionStatus10:Bool!
    var uploadCompletionStatus11:Bool!
    var uploadCompletionStatus12:Bool!
    var uploadCompletionStatus13:Bool!
    var uploadCompletionStatus14:Bool!
    
    var progressView:UIProgressView!
    var totalProgress:Float = 5
    var progressCompleted:Float = 0
    var alertView:UIAlertController!

    override func viewDidLoad() {
        super.viewDidLoad()
        let nib = UINib(nibName: "Header", bundle: nil)
        imagesTableView.register(nib, forHeaderFooterViewReuseIdentifier: "TableSectionHeader")
        imagesTableView.isEditing = true
        setUpElements()
        dismissKeyboardOnTap()
        createObservers()
        setContentArrays()
        imagesTableView.dataSource = self
        imagesTableView.delegate = self
        DatabaseManager.shared.fetchAllPersonsFromDatabase(completion: {person in
            AllPersonsInDatabaseArray = person
        })
        DatabaseManager.shared.fetchAllAlbumsFromDatabase(completion: {person in
            AllAlbumsInDatabaseArray = person
        })
        DatabaseManager.shared.fetchAllSongsFromDatabase(completion: {person in
            AllSongsInDatabaseArray = person
        })
        DatabaseManager.shared.fetchAllInstrumentalsFromDatabase(completion: {person in
            AllInstrumentalsInDatabaseArray = person
        })
        DatabaseManager.shared.fetchAllBeatsFromDatabase(completion: {person in
            AllBeatsInDatabaseArray = person
        })
        DatabaseManager.shared.fetchAllVideosFromDatabase(completion: {person in
            AllVideosInDatabaseArray = person
        })
    }
    
    func createObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {

      guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {

        // if keyboard size is not available for some reason, dont do anything
        return
      }
        
        let contentInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: keyboardSize.height , right: 0.0)
        scrollView1.contentInset = contentInsets
        scrollView1.scrollIndicatorInsets = contentInsets
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        // move back the root view origin to zero
        let contentInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
        
        
        // reset back the content inset to zero after keyboard is gone
        scrollView1.contentInset = contentInsets
        scrollView1.scrollIndicatorInsets = contentInsets
        view.frame.origin.y = 0
    }
    
    func setUpElements() {
        Utilities.styleTextField(nameTextField)
        addBottomLineToText(nameTextField)
        
        Utilities.styleTextField(subCategoryTextField)
        addBottomLineToText(subCategoryTextField)
        subCategoryTextField.inputView = subCategoryPickerView
        subCategoryPickerView.delegate = self
        subCategoryPickerView.dataSource = self
        pickerViewToolbar(textField: subCategoryTextField, pickerView: subCategoryPickerView)
        
        Utilities.styleTextField(fileTextField)
        addBottomLineToText(fileTextField)
        
        Utilities.styleTextField(audioPreviewTextField)
        addBottomLineToText(audioPreviewTextField)
        
        Utilities.styleTextField(priceTextField)
        addBottomLineToText(priceTextField)
        priceTextField.keyboardType = .numberPad
        
        Utilities.styleTextField(quantityTextField)
        addBottomLineToText(quantityTextField)
        quantityTextField.keyboardType = .numberPad
        
        videosTableView.delegate = self
        videosTableView.dataSource = self
        videosHeightConstraint.constant = CGFloat(50*(videoArr.count))
        personTableView.delegate = self
        personTableView.dataSource = self
        personHeightConstraint.constant = CGFloat(50*(personArr.count))
        songsTableView.delegate = self
        songsTableView.dataSource = self
        songsHeightConstraint.constant = CGFloat(50*(songArr.count))
        albumsTableView.delegate = self
        albumsTableView.dataSource = self
        albumsHeightConstraint.constant = CGFloat(50*(albumArr.count))
        instrumaentalsTableView.delegate = self
        instrumaentalsTableView.dataSource = self
        instrumentalsHeightConstraint.constant = CGFloat(50*(instrumentalArr.count))
        beatsTableView.dataSource = self
        beatsTableView.delegate = self
        beatsHeightConstraint.constant = CGFloat(50*(beatArr.count))
    }
    
    func setContentArrays() {
        DatabaseManager.shared.fetchAllPersonsFromDatabase(completion: { person in
            AllPersonsInDatabaseArray = person
        })
        DatabaseManager.shared.fetchAllSongsFromDatabase(completion: { song in
            AllSongsInDatabaseArray = song
        })
        DatabaseManager.shared.fetchAllVideosFromDatabase(completion: { video in
            AllVideosInDatabaseArray = video
        })
        DatabaseManager.shared.fetchAllAlbumsFromDatabase(completion: { album in
            AllAlbumsInDatabaseArray = album
        })
        DatabaseManager.shared.fetchAllInstrumentalsFromDatabase(completion: { instrumental in
            AllInstrumentalsInDatabaseArray = instrumental
        })
        DatabaseManager.shared.fetchAllBeatsFromDatabase(completion: { beat in
            AllBeatsInDatabaseArray = beat
        })
        DatabaseManager.shared.fetchAllVideosFromDatabase(completion: {person in
            AllVideosInDatabaseArray = person
        })
    }
    
    @IBAction func imageTapped(_ sender: Any) {
        presentPhotoActionSheet()
    }
    
    @IBAction func fileTapped(_ sender: Any) {
        openFiles(type: "zip")
    }

    @IBAction func audioPreviewTapped(_ sender: Any) {
        openFiles(type: "mp3")
    }
    
    @IBAction func addPersonTapped(_ sender: Any) {
        arr = "person"
        prevPage = "uploadKits"
        performSegue(withIdentifier: "uploadKitsToTonesPick", sender: nil)
    }
    
    func personAdded(_ person: PersonData) {
        lightImpactGenerator.impactOccurred(intensity: 0.75)
        guard !personArr.contains(person) else {
            mediumImpactGenerator.impactOccurred()
            Utilities.showError2("Person already added.", actionText: "OK")
            return}
        if !personArr.contains(person) {
            personArr.append(person)
        } else {
            let dex = personArr.firstIndex(of: person)
            personArr[dex!] = person
        }
        DispatchQueue.main.async {[weak self]  in
            guard let strongSelf = self else {return}
            strongSelf.personArr.sort(by: {$0.name < $1.name})
            strongSelf.personTableView.reloadData()
            if strongSelf.personArr.count < 6 {
                strongSelf.personHeightConstraint.constant = CGFloat(50*(strongSelf.personArr.count))
            } else {
                strongSelf.personHeightConstraint.constant = CGFloat(270)
            }
        }
    }
    
    @IBAction func addAlbumTapped(_ sender: Any) {
        arr = "album"
        prevPage = "uploadKits"
        performSegue(withIdentifier: "uploadKitsToTonesPick", sender: nil)
    }
    
    func albumAdded(_ album: AlbumData) {
        lightImpactGenerator.impactOccurred(intensity: 0.75)
        guard !albumArr.contains(album) else {
            mediumImpactGenerator.impactOccurred()
            Utilities.showError2("Album already added.", actionText: "OK")
            return}
        if !albumArr.contains(album) {
            albumArr.append(album)
        } else {
            let dex = albumArr.firstIndex(of: album)
            albumArr[dex!] = album
        }
        DispatchQueue.main.async {[weak self]  in
            guard let strongSelf = self else {return}
            strongSelf.albumArr.sort(by: {$0.name < $1.name})
            strongSelf.albumsTableView.reloadData()
            if strongSelf.albumArr.count < 6 {
                strongSelf.albumsHeightConstraint.constant = CGFloat(50*(strongSelf.albumArr.count))
            } else {
                strongSelf.albumsHeightConstraint.constant = CGFloat(270)
            }
        }
    }
    
    @IBAction func addInstrumentalTapped(_ sender: Any) {
        arr = "instrumental"
        prevPage = "uploadKits"
        performSegue(withIdentifier: "uploadKitsToTonesPick", sender: nil)
    }
    
    func instrumentalAdded(_ instrumental: InstrumentalData) {
        lightImpactGenerator.impactOccurred(intensity: 0.75)
        guard !instrumentalArr.contains(instrumental) else {
            mediumImpactGenerator.impactOccurred()
            Utilities.showError2("Instrumental already added.", actionText: "OK")
            return}
        if !instrumentalArr.contains(instrumental) {
            instrumentalArr.append(instrumental)
        } else {
            let dex = instrumentalArr.firstIndex(of: instrumental)
            instrumentalArr[dex!] = instrumental
        }
        DispatchQueue.main.async {[weak self]  in
            guard let strongSelf = self else {return}
            strongSelf.instrumentalArr.sort(by: {$0.instrumentalName! < $1.instrumentalName!})
            strongSelf.instrumaentalsTableView.reloadData()
            if strongSelf.instrumentalArr.count < 6 {
                strongSelf.instrumentalsHeightConstraint.constant = CGFloat(50*(strongSelf.instrumentalArr.count))
            } else {
                strongSelf.instrumentalsHeightConstraint.constant = CGFloat(270)
            }
        }
    }
    
    @IBAction func addBeatTapped(_ sender: Any) {
        arr = "beat"
        prevPage = "uploadKits"
        performSegue(withIdentifier: "uploadKitsToTonesPick", sender: nil)
    }
    
    func beatAdded(_ beat: BeatData) {
        lightImpactGenerator.impactOccurred(intensity: 0.75)
        guard !beatArr.contains(beat) else {
            mediumImpactGenerator.impactOccurred()
            Utilities.showError2("Beat already added.", actionText: "OK")
            return}
        if !beatArr.contains(beat) {
            beatArr.append(beat)
        } else {
            let dex = beatArr.firstIndex(of: beat)
            beatArr[dex!] = beat
        }
        DispatchQueue.main.async {[weak self]  in
            guard let strongSelf = self else {return}
            strongSelf.beatArr.sort(by: {$0.name < $1.name})
            strongSelf.beatsTableView.reloadData()
            if strongSelf.beatArr.count < 6 {
                strongSelf.beatsHeightConstraint.constant = CGFloat(50*(strongSelf.beatArr.count))
            } else {
                strongSelf.beatsHeightConstraint.constant = CGFloat(270)
            }
        }
    }
    
    @IBAction func addVideoTapped(_ sender: Any) {
        arr = "video"
        prevPage = "uploadKits"
        performSegue(withIdentifier: "uploadKitsToTonesPick", sender: nil)
    }
    
    func videoAdded(_ video: VideoData) {
        lightImpactGenerator.impactOccurred(intensity: 0.75)
        guard !videoArr.contains(video) else {
            mediumImpactGenerator.impactOccurred()
            Utilities.showError2("Video already added.", actionText: "OK")
            return}
        if !videoArr.contains(video) {
            videoArr.append(video)
        } else {
            let dex = videoArr.firstIndex(of: video)
            videoArr[dex!] = video
        }
        DispatchQueue.main.async {[weak self]  in
            guard let strongSelf = self else {return}
            strongSelf.videoArr.sort(by: {$0.title < $1.title})
            strongSelf.videosTableView.reloadData()
            if strongSelf.videoArr.count < 6 {
                strongSelf.videosHeightConstraint.constant = CGFloat(50*(strongSelf.videoArr.count))
            } else {
                strongSelf.videosHeightConstraint.constant = CGFloat(270)
            }
        }
    }
    
    @IBAction func addSongTapped(_ sender: Any) {
        arr = "song"
        prevPage = "uploadKits"
        performSegue(withIdentifier: "uploadKitsToTonesPick", sender: nil)
    }
    
    func songAdded(_ song: SongData) {
        lightImpactGenerator.impactOccurred(intensity: 0.75)
        guard !songArr.contains(song) else {
            mediumImpactGenerator.impactOccurred()
            Utilities.showError2("Song already added.", actionText: "OK")
            return}
        if !songArr.contains(song) {
            songArr.append(song)
        } else {
            let dex = songArr.firstIndex(of: song)
            songArr[dex!] = song
        }
        DispatchQueue.main.async {[weak self]  in
            guard let strongSelf = self else {return}
            strongSelf.songArr.sort(by: {$0.name < $1.name})
            strongSelf.songsTableView.reloadData()
            if strongSelf.songArr.count < 6 {
                strongSelf.songsHeightConstraint.constant = CGFloat(50*(strongSelf.songArr.count))
            } else {
                strongSelf.songsHeightConstraint.constant = CGFloat(270)
            }
        }
    }
    
    @IBAction func uploadTapped(_ sender: Any) {
        date = getCurrentLocalDate()
        guard nameTextField.text != "" else {
            Utilities.showError2("Name required" ,actionText: "Ok")
            return
        }
        guard subCategoryTextField.text != "" else {
            Utilities.showError2("Sub Category required"  ,actionText: "Ok")
            return
        }
        guard descriptionTextField.text != "" else {
            Utilities.showError2("Description required"  ,actionText: "Ok")
            return
        }
        guard selectedFileURL != nil else {
            Utilities.showError2("File required"  ,actionText: "Ok")
            return
        }
        guard selectedPreviewAudioURL != nil else {
            Utilities.showError2("Preview required"  ,actionText: "Ok")
            return
        }
        guard !selectedImageArray.isEmpty else {
            Utilities.showError2("Image required"  ,actionText: "Ok")
            return
        }
        if priceTextField.text != "" && priceTextField.text != "$0.00"{
            if let price = Double(priceTextField.text!.replacingOccurrences(of: "$", with: "")) {
                kitPrice = price
            }
        }
        if quantityTextField.text != "" {
            if let quan = Int(quantityTextField.text!) {
                kitQuantity = quan
            }
        }
        kitName = nameTextField.text!
        kitDescription = descriptionTextField.text!
        kitSubCategory = subCategoryTextField.text!
        alertView = UIAlertController(title: "Uploading \(kitName!)", message: "Preparing...", preferredStyle: .alert)
        alertView.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alertView.view.tintColor = Constants.Colors.redApp
        //  Show it to your users
        present(alertView, animated: true, completion: { [weak self] in
            guard let strongSelf = self else {return}
            //  Add your progressbar after alert is shown (and measured)
            let margin:CGFloat = 8.0
            let rect = CGRect(x: margin, y: 72.0, width: strongSelf.alertView.view.frame.width - margin * 2.0 , height: 1.5)
            strongSelf.progressView = UIProgressView(frame: rect)
            strongSelf.progressView.alpha = 0
            strongSelf.progressView!.progress = 0
            strongSelf.progressView!.tintColor = Constants.Colors.redApp
            strongSelf.alertView.view.addSubview(strongSelf.progressView!)
            UIView.animate(withDuration: 0.2, animations: {
                strongSelf.progressView.alpha = 1
                strongSelf.view.layoutSubviews()
            })
            strongSelf.generateAppId()
        })
    }
    
    func generateAppId() {
        let genid = StorageManager.shared.generateRandomNumber(digits: 22)
        DatabaseManager.shared.checkIfAppIdExists(appid: genid, completion: { [weak self] result in
            guard let strongSelf = self else {return}
            if result == true {
                strongSelf.generateAppId()
            } else {
                strongSelf.uploadCompletionStatus1 = true
                strongSelf.progressCompleted+=1
                strongSelf.progressView.progress = (strongSelf.progressCompleted/strongSelf.totalProgress)
                print("\(strongSelf.progressCompleted) out of \(strongSelf.totalProgress)")
                strongSelf.tDAppId = genid
                strongSelf.gatherUploadData()
            }
        })
    }
    
    func gatherUploadData() {
        
        let queue = DispatchQueue(label: "myhjvkhQkitssssseue")
        let group = DispatchGroup()
        var array = [2,3,4,7,8,9,10,11,1]
        if !personArr.isEmpty {
            array.append(5)
        }
        if !albumArr.isEmpty {
            array.append(7)
        }
        if !songArr.isEmpty {
            array.append(8)
        }
        if !videoArr.isEmpty {
            array.append(9)
        }
        if !instrumentalArr.isEmpty {
            array.append(10)
        }
        if !beatArr.isEmpty {
            array.append(11)
        }
        for i in array {
            group.enter()
            queue.async { [weak self] in
                guard let strongSelf = self else {return}
                switch i {
                case 1:
                    strongSelf.storeImages(completion: {[weak self] done in
                        guard let strongSelf = self else {return}
                        if done == false {
                            Utilities.showError2("Image Storing Failed.", actionText: "OK")
                            strongSelf.uploadCompletionStatus2 = false
                        }
                        else {
                            
                            strongSelf.uploadCompletionStatus2 = true
                            print("done \(i)")
                        }
                        group.leave()
                    })
                case 2:
                    
                    //print("null")
                    strongSelf.storeAudioPreview(completion: {[weak self] done in
                        guard let strongSelf = self else {return}
                        if done == false {
                            Utilities.showError2("Preview Storing Failed.", actionText: "OK")
                            strongSelf.uploadCompletionStatus3 = false
                        }
                        else {
                            strongSelf.uploadCompletionStatus3 = true
                            strongSelf.progressCompleted+=1
                            DispatchQueue.main.async {
                                strongSelf.progressView.progress = (strongSelf.progressCompleted/strongSelf.totalProgress)
                                print("\(strongSelf.progressCompleted) out of \(strongSelf.totalProgress)")
                                
                            }
                            print("done \(i)")
                        }
                        group.leave()
                    })
                case 3:
                    
                    //print("null")
                    strongSelf.storeFile(completion: {[weak self] done in
                        guard let strongSelf = self else {return}
                        if done == false {
                            Utilities.showError2("File Storing Failed.", actionText: "OK")
                            strongSelf.uploadCompletionStatus4 = false
                        }
                        else {
                            strongSelf.uploadCompletionStatus4 = true
                            strongSelf.progressCompleted+=1
                            DispatchQueue.main.async {
                                strongSelf.progressView.progress = (strongSelf.progressCompleted/strongSelf.totalProgress)
                                print("\(strongSelf.progressCompleted) out of \(strongSelf.totalProgress)")
                                
                            }
                            print("done \(i)")
                        }
                        group.leave()
                    })
                case 4:
                    
                    //print("null")
                    strongSelf.uploadMerchToDB(completion: {[weak self] done in
                        guard let strongSelf = self else {return}
                        if done == false {
                            Utilities.showError2("Merch Storing Failed.", actionText: "OK")
                            strongSelf.uploadCompletionStatus5 = false
                        }
                        else {
                            strongSelf.uploadCompletionStatus5 = true
                            strongSelf.progressCompleted+=1
                            DispatchQueue.main.async {
                                strongSelf.progressView.progress = (strongSelf.progressCompleted/strongSelf.totalProgress)
                                print("\(strongSelf.progressCompleted) out of \(strongSelf.totalProgress)")
                                
                            }
                            print("done \(i)")
                        }
                        group.leave()
                    })
                case 5:
                    //print("null")
                    strongSelf.updatePerson(completion: {[weak self] done in
                        guard let strongSelf = self else {return}
                        if done == false {
                            Utilities.showError2("Artist Update Failed.", actionText: "OK")
                            strongSelf.uploadCompletionStatus6 = false
                        }
                        else {
                            strongSelf.uploadCompletionStatus6 = true
                            strongSelf.progressCompleted+=1
                            DispatchQueue.main.async {
                                strongSelf.progressView.progress = (strongSelf.progressCompleted/strongSelf.totalProgress)
                                print("\(strongSelf.progressCompleted) out of \(strongSelf.totalProgress)")
                                
                            }
                            print("done \(i)")
                        }
                        group.leave()
                    })
                case 7:
                    //print("null")
                    strongSelf.updateAlbums(completion: {[weak self] done in
                        guard let strongSelf = self else {return}
                        if done == false {
                            Utilities.showError2("Album Update Failed.", actionText: "OK")
                            strongSelf.uploadCompletionStatus8 = false
                        }
                        else {
                            strongSelf.uploadCompletionStatus8 = true
                            strongSelf.progressCompleted+=1
                            DispatchQueue.main.async {
                                strongSelf.progressView.progress = (strongSelf.progressCompleted/strongSelf.totalProgress)
                                print("\(strongSelf.progressCompleted) out of \(strongSelf.totalProgress)")

                            }
                            print("done \(i)")
                        }
                        group.leave()
                    })
                case 8:
                    //print("null")
                    strongSelf.updateSongs(completion: {[weak self] done in
                        guard let strongSelf = self else {return}
                        if done == false {
                            Utilities.showError2("Song Update Failed.", actionText: "OK")
                            strongSelf.uploadCompletionStatus9 = false
                        }
                        else {
                            strongSelf.uploadCompletionStatus9 = true
                            strongSelf.progressCompleted+=1
                            DispatchQueue.main.async {
                                strongSelf.progressView.progress = (strongSelf.progressCompleted/strongSelf.totalProgress)
                                print("\(strongSelf.progressCompleted) out of \(strongSelf.totalProgress)")

                            }
                            print("done \(i)")
                        }
                        group.leave()
                    })
                case 9:
                    //print("null")
                    strongSelf.updateVideos(completion: {[weak self] done in
                        guard let strongSelf = self else {return}
                        if done == false {
                            Utilities.showError2("Video Update Failed.", actionText: "OK")
                            strongSelf.uploadCompletionStatus10 = false
                        }
                        else {
                            strongSelf.uploadCompletionStatus10 = true
                            strongSelf.progressCompleted+=1
                            DispatchQueue.main.async {
                                strongSelf.progressView.progress = (strongSelf.progressCompleted/strongSelf.totalProgress)
                                print("\(strongSelf.progressCompleted) out of \(strongSelf.totalProgress)")

                            }
                            print("done \(i)")
                        }
                        group.leave()
                    })
                case 10:
                    //print("null")
                    strongSelf.updateInstrumentals(completion: {[weak self] done in
                        guard let strongSelf = self else {return}
                        if done == false {
                            Utilities.showError2("Instrumental Update Failed.", actionText: "OK")
                            strongSelf.uploadCompletionStatus11 = false
                        }
                        else {
                            strongSelf.uploadCompletionStatus11 = true
                            strongSelf.progressCompleted+=1
                            DispatchQueue.main.async {
                                strongSelf.progressView.progress = (strongSelf.progressCompleted/strongSelf.totalProgress)
                                print("\(strongSelf.progressCompleted) out of \(strongSelf.totalProgress)")

                            }
                            print("done \(i)")
                        }
                        group.leave()
                    })
                case 11:
                    //print("null")
                    strongSelf.updateBeats(completion: {[weak self] done in
                        guard let strongSelf = self else {return}
                        if done == false {
                            Utilities.showError2("Beats Update Failed.", actionText: "OK")
                            strongSelf.uploadCompletionStatus12 = false
                        }
                        else {
                            strongSelf.uploadCompletionStatus12 = true
                            strongSelf.progressCompleted+=1
                            DispatchQueue.main.async {
                                strongSelf.progressView.progress = (strongSelf.progressCompleted/strongSelf.totalProgress)
                                print("\(strongSelf.progressCompleted) out of \(strongSelf.totalProgress)")

                            }
                            print("done \(i)")
                        }
                        group.leave()
                    })
                default:
                    print("Kit error")
                }
            }
        }
        
        group.notify(queue: DispatchQueue.main) { [weak self] in
            guard let strongSelf = self else {return}
            if strongSelf.uploadCompletionStatus1 == false || strongSelf.uploadCompletionStatus2 == false || strongSelf.uploadCompletionStatus3 == false || strongSelf.uploadCompletionStatus4 == false || strongSelf.uploadCompletionStatus5 == false || strongSelf.uploadCompletionStatus6 == false || strongSelf.uploadCompletionStatus7 == false || strongSelf.uploadCompletionStatus8 == false || strongSelf.uploadCompletionStatus9 == false || strongSelf.uploadCompletionStatus10 == false || strongSelf.uploadCompletionStatus11 == false || strongSelf.uploadCompletionStatus12 == false {
                strongSelf.alertView.dismiss(animated: true, completion: nil)
                Utilities.showError2("Upload Failed.", actionText: "OK")
                return
            } else {
                
                print("📗 Kit data saved to database successfully.")
                strongSelf.alertView.dismiss(animated: true, completion: {
                    Utilities.successBarBanner("Upload successful.")
                    _ = strongSelf.navigationController?.popViewController(animated: true)
                })
            }
        }
    }
    
    func storeImages(completion: @escaping ((Bool) -> Void)) {
        let semaphore = DispatchSemaphore(value: 1)
        var uploadCount = 0
        var urlArr:[String] = []
        var imagearr:[Data] = []
        for image in selectedImageArray {
            guard let data = image.pngData() else {return}
            imagearr.append(data)
        }
        for data in imagearr {
            StorageManager.shared.uploadImage(kit: data, fileName: "\(tDAppId)", completion: {[weak self] result in
                guard let strongSelf = self else {return}
                switch result {
                case .success(let ImageRef):
                    ImageRef.downloadURL(completion: { url, error in
                        guard let url = url else {

                            print("📕 Failed to get image download URL \(String(describing: error))")
                            Utilities.showError2("Failed to get image download URL.", actionText: "OK")
                            completion(false)
                            return
                        }

                        let urlString = url.absoluteString
                        print("📙 download url: \(urlString)")
                        uploadCount+=1
                        urlArr.append(urlString)
                        
                        if uploadCount == strongSelf.selectedImageArray.count {
                            strongSelf.selectedImageURLsArray = urlArr
                            strongSelf.progressCompleted+=1
                            DispatchQueue.main.async {
                                strongSelf.progressView.progress = (strongSelf.progressCompleted/strongSelf.totalProgress)
                                print("\(strongSelf.progressCompleted) out of \(strongSelf.totalProgress)")
                            }
                            
                            Database.database().reference().child("Merch").child("\(strongSelf.tDAppId)").child("Images").setValue(strongSelf.selectedImageURLsArray)
                            
                            completion(true)
                            return
                        } else {
//                            semaphore.signal()
                        }
                        return
                    })
                case .failure(let err):
                    Utilities.showError2("Upload Failed. \(err) due to image.", actionText: "OK")
                    completion(false)
                    return
                }
            })
//            semaphore.wait()
        }
    }
    
    func storeAudioPreview(completion: @escaping ((Bool) -> Void)) {
        StorageManager.shared.uploadAudio(kit: selectedPreviewAudioURL, fileName: "\(tDAppId)", completion: {[weak self] result in
            guard let strongSelf = self else {return}
            switch result {
            case .success(let url):
                strongSelf.previewURL = url
                Database.database().reference().child("Merch").child("\(strongSelf.tDAppId)").child("Preview URL").setValue(strongSelf.previewURL)
                completion(true)
            case .failure(let err):
                Utilities.showError2("Preview Upload Failed. \(err)", actionText: "OK")
                completion(false)
            }
        })
    }
    
    func storeFile(completion: @escaping ((Bool) -> Void)) {
        StorageManager.shared.uploadFile(url: selectedFileURL, fileName: "\(tDAppId)", completion: {[weak self] result in
            guard let strongSelf = self else {return}
            switch result {
            case .success(let url):
                strongSelf.fileURL = url
                Database.database().reference().child("Merch").child("\(strongSelf.tDAppId)").child("File URL").setValue(strongSelf.fileURL)
                completion(true)
            case .failure(let err):
                Utilities.showError2("File Upload Failed. \(err)", actionText: "OK")
                completion(false)
            }
        })
    }
    
    func uploadMerchToDB(completion: @escaping ((Bool) -> Void)) {
        DispatchQueue.main.async {[weak self] in
            guard let strongSelf = self else {return}
            
            var RequiredInfoMa = [String : Any]()
            RequiredInfoMa = [
                "Tone Deaf App Id" : strongSelf.tDAppId,
                "Name" : strongSelf.kitName!,
                "Number of Favorites" : 0,
                "Number of Purchases" : 0,
                "Date Uploaded": strongSelf.date!,
                "Merch Type": "Kit",
                "Description": strongSelf.kitDescription!,
                "Sub Category": strongSelf.kitSubCategory!,
                "Quantity": strongSelf.kitQuantity as Any,
                "Retail Price": strongSelf.kitPrice as Any,
                "Active Status": false
            ]

            let RequiredRef = Database.database().reference().child("Merch").child("\(strongSelf.tDAppId)")
            RequiredRef.updateChildValues(RequiredInfoMa) { (error, songRef) in
                if let error = error {
                    print("📕 Failed to upload dictionary to database: \(error)")
                    completion(false)
                    return
                } else {
                    Database.database().reference().child("All Content IDs") .observeSingleEvent(of: .value, with: {[weak self] snap in
                        guard let strongSelf = self else {return}
                        var arr = snap.value as! [String]
                        if !arr.contains("\(strongSelf.tDAppId)") {
                            arr.append("\(strongSelf.tDAppId)")
                        }
                        Database.database().reference().child("All Content IDs").setValue(arr)
                        completion(true)
                    })
                }
            }
        }
    }
    
    func updatePerson(completion: @escaping ((Bool) -> Void)) {
        guard !personArr.isEmpty else {
            completion(true)
            return
        }
        var tick = 0
        for art in personArr {
            let cat = "\(art.name!)--\(art.dateRegisteredToApp!)--\(art.timeRegisteredToApp!)--\(art.toneDeafAppId)"
            let ref = Database.database().reference().child("Registered Persons").child(cat).child("Merch")
            ref.observeSingleEvent(of: .value, with: {[weak self] snap in
                guard let strongSelf = self else {return}
                var newArr:[String] = []
                if let val = snap.value as? [String] {
                    newArr = val
                    if !newArr.contains("\(strongSelf.tDAppId)") {
                        newArr.append("\(strongSelf.tDAppId)")
                    }
                    ref.setValue(newArr)
                    tick+=1
                    if tick == strongSelf.personArr.count {
                        var arrrr:[String] = []
                        for item in strongSelf.personArr {
                            if !arrrr.contains(item.toneDeafAppId) {
                                arrrr.append(item.toneDeafAppId)
                            }
                        }
                        Database.database().reference().child("Merch").child("\(strongSelf.tDAppId)").child("Persons").setValue(arrrr)
                        completion(true)
                    }
                } else {
                    if !newArr.contains("\(strongSelf.tDAppId)") {
                        newArr.append("\(strongSelf.tDAppId)")
                    }
                    ref.setValue(newArr)
                    tick+=1
                    if tick == strongSelf.personArr.count {
                        var arrrr:[String] = []
                        for item in strongSelf.personArr {
                            if !arrrr.contains(item.toneDeafAppId) {
                                arrrr.append(item.toneDeafAppId)
                            }
                        }
                        Database.database().reference().child("Merch").child("\(strongSelf.tDAppId)").child("Persons").setValue(arrrr)
                        completion(true)
                    }
                }
            })
        }
    }
    
    func updateSongs(completion: @escaping ((Bool) -> Void)) {
        guard !songArr.isEmpty else {
            completion(true)
            return
        }
        var tick = 0
        for son in songArr {
            let cat = "\(songContentTag)--\(son.name)--\(son.toneDeafAppId)"
            let ref = Database.database().reference().child("Music Content").child("Songs").child(cat).child("REQUIRED").child("Merch")
            ref.observeSingleEvent(of: .value, with: {[weak self] snap in
                guard let strongSelf = self else {return}
                var newArr:[String] = []
                if let val = snap.value as? [String] {
                    newArr = val
                    if !newArr.contains("\(strongSelf.tDAppId)") {
                        newArr.append("\(strongSelf.tDAppId)")
                    }
                    ref.setValue(newArr)
                    tick+=1
                    if tick == strongSelf.songArr.count {
                        var arrrr:[String] = []
                        for item in strongSelf.songArr {
                            if !arrrr.contains(item.toneDeafAppId) {
                                arrrr.append(item.toneDeafAppId)
                            }
                        }
                        Database.database().reference().child("Merch").child("\(strongSelf.tDAppId)").child("Songs").setValue(arrrr)
                        completion(true)
                    }
                } else {
                    if !newArr.contains("\(strongSelf.tDAppId)") {
                        newArr.append("\(strongSelf.tDAppId)")
                    }
                    ref.setValue(newArr)
                    tick+=1
                    if tick == strongSelf.songArr.count {
                        var arrrr:[String] = []
                        for item in strongSelf.songArr {
                            if !arrrr.contains(item.toneDeafAppId) {
                                arrrr.append(item.toneDeafAppId)
                            }
                        }
                        Database.database().reference().child("Merch").child("\(strongSelf.tDAppId)").child("Songs").setValue(arrrr)
                        completion(true)
                    }
                }
            })
        }
    }

    func updateVideos(completion: @escaping ((Bool) -> Void)) {
        guard !videoArr.isEmpty else {
            completion(true)
            return
        }
        var tick = 0
        for vid in videoArr {
            let cat = "\(videoContentTag)--\(vid.title.replacingOccurrences(of: ".", with: " ").replacingOccurrences(of: "#", with: " ").replacingOccurrences(of: "$", with: " ").replacingOccurrences(of: "[", with: " ").replacingOccurrences(of: "]", with: " ").replacingOccurrences(of: ":", with: " "))--\(vid.toneDeafAppId)"
            let ref = Database.database().reference().child("Music Content").child("Videos").child(cat).child("Merch")
            ref.observeSingleEvent(of: .value, with: {[weak self] snap in
                guard let strongSelf = self else {return}
                var newArr:[String] = []
                if let val = snap.value as? [String] {
                    newArr = val
                    if !newArr.contains("\(strongSelf.tDAppId)") {
                        newArr.append("\(strongSelf.tDAppId)")
                    }
                    ref.setValue(newArr)
                    tick+=1
                    if tick == strongSelf.videoArr.count {
                        var arrrr:[String] = []
                        for item in strongSelf.videoArr {
                            if !arrrr.contains(item.toneDeafAppId) {
                                arrrr.append(item.toneDeafAppId)
                            }
                        }
                        Database.database().reference().child("Merch").child("\(strongSelf.tDAppId)").child("Videos").setValue(arrrr)
                        completion(true)
                    }
                } else {
                    if !newArr.contains("\(strongSelf.tDAppId)") {
                        newArr.append("\(strongSelf.tDAppId)")
                    }
                    ref.setValue(newArr)
                    tick+=1
                    if tick == strongSelf.videoArr.count {
                        var arrrr:[String] = []
                        for item in strongSelf.videoArr {
                            if !arrrr.contains(item.toneDeafAppId) {
                                arrrr.append(item.toneDeafAppId)
                            }
                        }
                        Database.database().reference().child("Merch").child("\(strongSelf.tDAppId)").child("Videos").setValue(arrrr)
                        completion(true)
                    }
                }
            })
        }
    }

    func updateAlbums(completion: @escaping ((Bool) -> Void)) {
        guard !albumArr.isEmpty else {
            completion(true)
            return
        }
        var tick = 0
        for vid in albumArr {
            let cat = "\(albumContentTag)--\(vid.name)--\(vid.toneDeafAppId)"
            let ref = Database.database().reference().child("Music Content").child("Albums").child(cat).child("REQUIRED").child("Merch")
            ref.observeSingleEvent(of: .value, with: {[weak self] snap in
                guard let strongSelf = self else {return}
                var newArr:[String] = []
                if let val = snap.value as? [String] {
                    newArr = val
                    if !newArr.contains("\(strongSelf.tDAppId)") {
                        newArr.append("\(strongSelf.tDAppId)")
                    }
                    ref.setValue(newArr)
                    tick+=1
                    if tick == strongSelf.albumArr.count {
                        var arrrr:[String] = []
                        for item in strongSelf.albumArr {
                            if !arrrr.contains(item.toneDeafAppId) {
                                arrrr.append(item.toneDeafAppId)
                            }
                        }
                        Database.database().reference().child("Merch").child("\(strongSelf.tDAppId)").child("Albums").setValue(arrrr)
                        completion(true)
                    }
                } else {
                    if !newArr.contains("\(strongSelf.tDAppId)") {
                        newArr.append("\(strongSelf.tDAppId)")
                    }
                    ref.setValue(newArr)
                    tick+=1
                    if tick == strongSelf.albumArr.count {
                        var arrrr:[String] = []
                        for item in strongSelf.albumArr {
                            if !arrrr.contains(item.toneDeafAppId) {
                                arrrr.append(item.toneDeafAppId)
                            }
                        }
                        Database.database().reference().child("Merch").child("\(strongSelf.tDAppId)").child("Albums").setValue(arrrr)
                        completion(true)
                    }
                }
            })
        }
    }

    func updateInstrumentals(completion: @escaping ((Bool) -> Void)) {
        guard !instrumentalArr.isEmpty else {
            completion(true)
            return
        }
        var tick = 0
        for ints in instrumentalArr {
            let cat = "\(instrumentalContentType)--\(ints.songName!)--\(ints.toneDeafAppId)"
            let ref = Database.database().reference().child("Music Content").child("Instrumentals").child(cat).child("Merch")
            ref.observeSingleEvent(of: .value, with: {[weak self] snap in
                guard let strongSelf = self else {return}
                var newArr:[String] = []
                if let val = snap.value as? [String] {
                    newArr = val
                    if !newArr.contains("\(strongSelf.tDAppId)") {
                        newArr.append("\(strongSelf.tDAppId)")
                    }
                    ref.setValue(newArr)
                    tick+=1
                    if tick == strongSelf.instrumentalArr.count {
                        var arrrr:[String] = []
                        for item in strongSelf.instrumentalArr {
                            if !arrrr.contains(item.toneDeafAppId) {
                                arrrr.append(item.toneDeafAppId)
                            }
                        }
                        Database.database().reference().child("Merch").child("\(strongSelf.tDAppId)").child("Instrumentals").setValue(arrrr)
                        completion(true)
                    }
                } else {
                    if !newArr.contains("\(strongSelf.tDAppId)") {
                        newArr.append("\(strongSelf.tDAppId)")
                    }
                    ref.setValue(newArr)
                    tick+=1
                    if tick == strongSelf.instrumentalArr.count {
                        var arrrr:[String] = []
                        for item in strongSelf.instrumentalArr {
                            if !arrrr.contains(item.toneDeafAppId) {
                                arrrr.append(item.toneDeafAppId)
                            }
                        }
                        Database.database().reference().child("Merch").child("\(strongSelf.tDAppId)").child("Instrumentals").setValue(arrrr)
                        completion(true)
                    }
                }
            })
        }
    }

    func updateBeats(completion: @escaping ((Bool) -> Void)) {
        guard !beatArr.isEmpty else {
            completion(true)
            return
        }
        var tick = 0
        for bea in beatArr {
            let cat = "\(beatContentTag)--\(bea.name)--\(bea.toneDeafAppId)"
            
            let ref = Database.database().reference().child("Beats").child(cat).child("Merch")
            ref.observeSingleEvent(of: .value, with: {[weak self] snap in
                guard let strongSelf = self else {return}
                var newArr:[String] = []
                if let val = snap.value as? [String] {
                    newArr = val
                    if !newArr.contains("\(strongSelf.tDAppId)") {
                        newArr.append("\(strongSelf.tDAppId)")
                    }
                    ref.setValue(newArr)
                    tick+=1
                    if tick == strongSelf.beatArr.count {
                        var arrrr:[String] = []
                        for item in strongSelf.beatArr {
                            if !arrrr.contains(item.toneDeafAppId) {
                                arrrr.append(item.toneDeafAppId)
                            }
                        }
                        Database.database().reference().child("Merch").child("\(strongSelf.tDAppId)").child("Beats").setValue(arrrr)
                        completion(true)
                    }
                } else {
                    if !newArr.contains("\(strongSelf.tDAppId)") {
                        newArr.append("\(strongSelf.tDAppId)")
                    }
                    ref.setValue(newArr)
                    tick+=1
                    if tick == strongSelf.beatArr.count {
                        var arrrr:[String] = []
                        for item in strongSelf.beatArr {
                            if !arrrr.contains(item.toneDeafAppId) {
                                arrrr.append(item.toneDeafAppId)
                            }
                        }
                        Database.database().reference().child("Merch").child("\(strongSelf.tDAppId)").child("Beats").setValue(arrrr)
                        completion(true)
                    }
                }
            })
        }
    }
    
    //MARK: - Segues
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "uploadKitsToTonesPick" {
            if let viewController: SelectTonesPickItemViewController = segue.destination as? SelectTonesPickItemViewController {
                viewController.array = arr
                viewController.prevPage = prevPage
                if prevPage == "uploadKits" {
                    switch arr {
                    case "video":
                        viewController.exeptions = videoArr
                        viewController.uploadKitsVideosDelegate = self
                    case "song":
                        viewController.exeptions = songArr
                        viewController.uploadKitsSongsDelegate = self
                    case "person":
                        viewController.exeptions = personArr
                        viewController.uploadKitsPersonsDelegate = self
                    case "instrumental":
                        viewController.exeptions = instrumentalArr
                        viewController.uploadKitsInstrumentalsDelegate = self
                    case "album":
                        viewController.exeptions = albumArr
                        viewController.uploadKitsAlbumsDelegate = self
                    case "beat":
                        viewController.exeptions = beatArr
                        viewController.uploadKitsBeatsDelegate = self
                    default:
                        break
                    }
                }
//                if prevPage == "editVideoAll" {
//                    viewController.editVideoAllVideosDelegate = self
//                }
            }
        }
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func dismissKeyboardOnTap() {
        let tap = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        scrollView1.keyboardDismissMode = .onDrag
    }
    
}

extension KitsUploadViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if tableView == imagesTableView {
            return 70
        }
        else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if tableView == imagesTableView {
            let cell = tableView.dequeueReusableHeaderFooterView(withIdentifier: "TableSectionHeader") as! TableSectionHeader
            var sectitle = ""
            if selectedImageArray.count == 0 {
                sectitle = "Images"
            } else {
                sectitle = "Images (\(selectedImageArray.count))"
            }
            let header = cell
            header.titleLabel.text = sectitle
            return cell
        } else {
            return UIView()
        }
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch tableView {
        case videosTableView:
            return videoArr.count
        case personTableView:
            return personArr.count
        case songsTableView:
            return songArr.count
        case albumsTableView:
            return albumArr.count
        case instrumaentalsTableView:
            return instrumentalArr.count
        case beatsTableView:
            return beatArr.count
        case imagesTableView:
            return selectedImageArray.count
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            switch tableView {
            case videosTableView:
                let cell = tableView.dequeueReusableCell(withIdentifier: "editPersonVideoCell", for: indexPath) as! EditPersonVideoCell
                if !videoArr.isEmpty {
                    cell.setUp(video: videoArr[indexPath.row])
                }
                return cell
            case personTableView:
                let cell = tableView.dequeueReusableCell(withIdentifier: "roleEditSongCell", for: indexPath) as! RoleEditSongCell
                if !personArr.isEmpty {
                    cell.setUp(person: personArr[indexPath.row])
                }
                return cell
            case songsTableView:
                let cell = tableView.dequeueReusableCell(withIdentifier: "roleEditSongCell", for: indexPath) as! RoleEditSongCell
                if !songArr.isEmpty {
                    cell.setUp(song: songArr[indexPath.row])
                }
                return cell
            case albumsTableView:
                let cell = tableView.dequeueReusableCell(withIdentifier: "editPersonAlbumCell", for: indexPath) as! EditPersonAlbumCell
                if !albumArr.isEmpty {
                    cell.setUp(album: albumArr[indexPath.row], artistId: "")
                }
                return cell
            case instrumaentalsTableView:
                let cell = tableView.dequeueReusableCell(withIdentifier: "roleEditSongCell", for: indexPath) as! RoleEditSongCell
                if !instrumentalArr.isEmpty {
                    cell.setUp(instrumental: instrumentalArr[indexPath.row])
                }
                return cell
            case beatsTableView:
                let cell = tableView.dequeueReusableCell(withIdentifier: "roleEditSongCell", for: indexPath) as! RoleEditSongCell
                if !beatArr.isEmpty {
                    cell.setUp(beat: beatArr[indexPath.row])
                }
                return cell
            case imagesTableView:
                let cell = tableView.dequeueReusableCell(withIdentifier: "merchUploadImageTableViewCell", for: indexPath) as! MerchUploadImageTableViewCell
                cell.funcSetUp(image: selectedImageArray[indexPath.row])
                cell.imagev.image = selectedImageArray[indexPath.row]
                cell.imagenum.text = String(indexPath.row+1)
                return cell
            default:
                return UITableViewCell()
            }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            switch tableView {
            case videosTableView:
                videoArr.remove(at: indexPath.row)
                videosTableView.reloadData()
                videosHeightConstraint.constant = CGFloat(50*(videoArr.count))
            case personTableView:
                personArr.remove(at: indexPath.row)
                personTableView.reloadData()
                personHeightConstraint.constant = CGFloat(50*(personArr.count))
            case songsTableView:
                songArr.remove(at: indexPath.row)
                songsTableView.reloadData()
                songsHeightConstraint.constant = CGFloat(50*(songArr.count))
            case albumsTableView:
                albumArr.remove(at: indexPath.row)
                albumsTableView.reloadData()
                albumsHeightConstraint.constant = CGFloat(50*(albumArr.count))
            case instrumaentalsTableView:
                instrumentalArr.remove(at: indexPath.row)
                instrumaentalsTableView.reloadData()
                instrumentalsHeightConstraint.constant = CGFloat(50*(instrumentalArr.count))
            case beatsTableView:
                beatArr.remove(at: indexPath.row)
                beatsTableView.reloadData()
                beatsHeightConstraint.constant = CGFloat(50*(beatArr.count))
            case imagesTableView:
                selectedImageArray.remove(at: (indexPath).row)
                imagesTableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.fade)
                imagesTableView.reloadData()
                view.layoutSubviews()
            default:
                break
            }
        }
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        if tableView == imagesTableView {
            let movedObject = selectedImageArray[sourceIndexPath.row]
            selectedImageArray.remove(at: sourceIndexPath.row)
            selectedImageArray.insert(movedObject, at: destinationIndexPath.row)
            imagesTableView.reloadData()
            view.layoutSubviews()
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        if tableView == imagesTableView {
            return true
        } else {
            return false
        }
    }

    func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
}

extension KitsUploadViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func presentPhotoActionSheet() {
        let actionSheet = UIAlertController(title: "Open photo library?", message: nil, preferredStyle: .alert)
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
        selectedImageArray.append(selectedImage)
        imagesTableView.reloadData()
        view.layoutSubviews()
       //beatImage.image = selectedImage
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
}

extension KitsUploadViewController: UIDocumentPickerDelegate {
    
    func openFiles(type: String) {
        let documentPicker:UIDocumentPickerViewController!
        currentFileType = type
        switch type {
        case "mp3":
            documentPicker = UIDocumentPickerViewController(documentTypes: [kUTTypeMP3 as String], in: .import)
        default:
            documentPicker = UIDocumentPickerViewController(documentTypes: [kUTTypeZipArchive as String], in: .import)
        }
        documentPicker.delegate = self
        documentPicker.allowsMultipleSelection = false
        present(documentPicker, animated: true, completion: nil)
    }
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        let newUrls = urls.compactMap { (url: URL) -> URL? in
            // Create file URL to temporary folder
            var tempURL = URL(fileURLWithPath: NSTemporaryDirectory())
            // Apend filename (name+extension) to URL
            tempURL.appendPathComponent(url.lastPathComponent)
            do {
                // If file with same name exists remove it (replace file with new one)
                if FileManager.default.fileExists(atPath: tempURL.path) {
                    try FileManager.default.removeItem(atPath: tempURL.path)
                }
                // Move file from app_id-Inbox to tmp/filename
                try FileManager.default.moveItem(atPath: url.path, toPath: tempURL.path)
                return tempURL
            } catch {
                print(error.localizedDescription)
                return nil
            }
        }
        print(newUrls.first!)
        
        switch currentFileType {
        case "mp3":
            newAudio = newUrls.first
            guard newAudio == newUrls.first else {
                return
            }
        default:
            newExclusive = newUrls.first
            guard newExclusive == newUrls.first else {
                return
            }
        }
        
        let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        var sandboxFileURL:URL!
        switch currentFileType {
        case "mp3":
            sandboxFileURL = dir.appendingPathComponent(newAudio!.lastPathComponent)
        default:
            sandboxFileURL = dir.appendingPathComponent(newExclusive!.lastPathComponent)
        }
        
        if FileManager.default.fileExists(atPath: sandboxFileURL.path) {
            switch currentFileType {
            case "mp3":
                audioPreviewTextField.text = newAudio!.lastPathComponent as String
                selectedPreviewAudioURL = newAudio
            default:
                fileTextField.text = newExclusive!.lastPathComponent as String
                selectedFileURL = newExclusive
            }
        }
        else {
            do {
                switch currentFileType {
                case "mp3":
                    try FileManager.default.copyItem(at: newAudio!, to: sandboxFileURL)
                    audioPreviewTextField.text = newAudio!.lastPathComponent as String
                    selectedPreviewAudioURL = newAudio
                default:
                    try FileManager.default.copyItem(at: newExclusive!, to: sandboxFileURL)
                    fileTextField.text = newExclusive!.lastPathComponent as String
                    selectedFileURL = newExclusive
                }
            }
            catch {
                print("Error: \(error)")
            }
        }
    }
    
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        
    }
}

extension KitsUploadViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        var number = 0
        if pickerView == subCategoryPickerView {
            number = subcategories.count
        }
        return number
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        var number = ""
        if pickerView == subCategoryPickerView {
            number = subcategories[row]
        }
        return number
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == subCategoryPickerView {
            subCategoryTextField.text = subcategories[row]
        }
    }
    
    func pickerViewToolbar(textField:UITextField, pickerView:UIPickerView) {
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor.init(red: 182/255, green: 0/255, blue: 3/255, alpha: 1)
        toolBar.sizeToFit()
        var doneButton = UIBarButtonItem()
        var cancelButton = UIBarButtonItem()
        if pickerView == subCategoryPickerView {
            doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.done, target: self, action: #selector(dismissKeyboard))
        }
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        if pickerView != subCategoryPickerView {
            cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItem.Style.plain, target: self, action: #selector(dismissKeyboard))
        }

        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true

        textField.inputView = pickerView
        textField.inputAccessoryView = toolBar
    }
}


class MerchUploadImageTableViewCell: UITableViewCell {
    
    @IBOutlet weak var imagev:UIImageView!
    @IBOutlet weak var imagenum:UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        
    }
    
    func funcSetUp(image:UIImage) {
        
    }
}
