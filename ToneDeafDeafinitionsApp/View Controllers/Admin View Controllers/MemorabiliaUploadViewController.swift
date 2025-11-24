//
//  MemorabiliaUploadViewController.swift
//  ToneDeafDeafinitionsApp
//
//  Created by Tone Deaf on 10/31/20.
//  Copyright © 2020 GITEM Solutions. All rights reserved.
//

import UIKit
import FirebaseDatabase

class MemorabiliaUploadColorHelper {
    var price:Double?
    var quantity:Int?
    var color:String
    
    init(price:Double?, quantity:Int?, color:String) {
        self.price = price
        self.quantity = quantity
        self.color = color
    }
}

extension MemorabiliaUploadColorHelper: Equatable {
    static func == (lhs: MemorabiliaUploadColorHelper, rhs: MemorabiliaUploadColorHelper) -> Bool {
        return lhs.color == rhs.color
    }
}

class MemorabiliaUploadViewController: UIViewController {
    
    @IBOutlet weak var scrollView1:UIScrollView!
    @IBOutlet weak var imagesTableView:UITableView!
    @IBOutlet weak var colorsTableView:UITableView!
    
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
    @IBOutlet weak var colorsTextField: UITextField! {
        didSet {
            let placeholderText = NSAttributedString(string: "Select Colors",
                                                        attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray.withAlphaComponent(0.4)])
            
            colorsTextField.attributedPlaceholder = placeholderText
        }
    }
    @IBOutlet weak var artistTextField: UITextField! {
        didSet {
            let placeholderText = NSAttributedString(string: "Select Artist",
                                                        attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray.withAlphaComponent(0.4)])
            
            artistTextField.attributedPlaceholder = placeholderText
        }
    }
    @IBOutlet weak var producerTextField: UITextField! {
        didSet {
            let placeholderText = NSAttributedString(string: "Select Producers",
                                                        attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray.withAlphaComponent(0.4)])
            
            producerTextField.attributedPlaceholder = placeholderText
        }
    }
    @IBOutlet weak var videosTextField: UITextField! {
        didSet {
            let placeholderText = NSAttributedString(string: "Select Videos",
                                                        attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray.withAlphaComponent(0.4)])
            
            videosTextField.attributedPlaceholder = placeholderText
        }
    }
    @IBOutlet weak var albumsTextField: UITextField! {
        didSet {
            let placeholderText = NSAttributedString(string: "Select Albums",
                                                        attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray.withAlphaComponent(0.4)])
            
            albumsTextField.attributedPlaceholder = placeholderText
        }
    }
    @IBOutlet weak var instrumentalsTextField: UITextField! {
        didSet {
            let placeholderText = NSAttributedString(string: "Select Instrumentals",
                                                        attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray.withAlphaComponent(0.4)])
            
            instrumentalsTextField.attributedPlaceholder = placeholderText
        }
    }
    @IBOutlet weak var beatsTextField: UITextField! {
        didSet {
            let placeholderText = NSAttributedString(string: "Select Beats",
                                                        attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray.withAlphaComponent(0.4)])
            
            beatsTextField.attributedPlaceholder = placeholderText
        }
    }
    @IBOutlet weak var songsTextField: UITextField! {
        didSet {
            let placeholderText = NSAttributedString(string: "Select Songs",
                                                        attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray.withAlphaComponent(0.4)])
            
            songsTextField.attributedPlaceholder = placeholderText
        }
    }
    
    var date:String!
    var tDAppId:String = ""
    var selectedImageArray:[UIImage] = []
    var selectedImageURLsArray:[String] = []
    var memorabiliaName:String!
    var memorabiliaDescription:String!
    var memorabiliaSubCategory:String!
    var subCategoryPickerView = UIPickerView()
    let subcategories = ["Lighters", "Keychains", "Stickers", "Collectable CDs", "Posters"]
    var colorPrice:Double?
    var colorQuantity:Int?
    var colors:[MemorabiliaUploadColorHelper] = []
    var artistPickerView = UIPickerView()
    var chosenArtist = ""
    var chosenArtistNames = ""
    var chosenArtistRef = ""
    var artistref:[String] = []
    var memorabiliaArtists:Array<String> = []
    var memorabiliaArtistsNames:[String] = []
    var producerPickerView = UIPickerView()
    var chosenProducer = ""
    var chosenProducerNames = ""
    var chosenProducerRef = ""
    var producerref:[String] = []
    var memorabiliaProducers:Array<String> = []
    var memorabiliaProducerNames:[String] = []
    var songsPickerView = UIPickerView()
    var chosenSong = ""
    var chosenSongNames = ""
    var chosenSongRef = ""
    var songref:[String] = []
    var memorabiliaSongs:Array<String> = []
    var memorabiliaSongNames:[String] = []
    var albumsPickerView = UIPickerView()
    var chosenAlbum = ""
    var chosenAlbumNames = ""
    var chosenAlbumRef = ""
    var albumref:[String] = []
    var memorabiliaAlbums:Array<String> = []
    var memorabiliaAlbumNames:[String] = []
    var videosPickerView = UIPickerView()
    var chosenVideo = ""
    var chosenVideoNames = ""
    var chosenVideoRef = ""
    var videoref:[String] = []
    var memorabiliaVideos:Array<String> = []
    var memorabiliaVideoNames:[String] = []
    var instrumentalsPickerView = UIPickerView()
    var chosenInstrumental = ""
    var chosenInstrumentalNames = ""
    var chosenInstrumentalRef = ""
    var instrumentalref:[String] = []
    var memorabiliaInstrumentals:Array<String> = []
    var memorabiliaInstrumentalNames:[String] = []
    var beatsPickerView = UIPickerView()
    var chosenBeat = ""
    var chosenBeatNames = ""
    var chosenBeatRef = ""
    var beatref:[String] = []
    var memorabiliaBeats:Array<String> = []
    var memorabiliaBeatNames:[String] = []
    
    var colorsPickerView = UIPickerView()
    var chosenColor = ""
    
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
    var totalProgress:Float = 9
    var progressCompleted:Float = 0
    var alertView:UIAlertController!

    override func viewDidLoad() {
        super.viewDidLoad()
        let nib = UINib(nibName: "Header", bundle: nil)
        imagesTableView.register(nib, forHeaderFooterViewReuseIdentifier: "TableSectionHeader")
        imagesTableView.isEditing = true
        colorsTableView.register(nib, forHeaderFooterViewReuseIdentifier: "TableSectionHeader")
        colorsTableView.isEditing = true
        setUpElements()
        dismissKeyboardOnTap()
        createObservers()
        setContentArrays()
        imagesTableView.dataSource = self
        imagesTableView.delegate = self
        colorsTableView.dataSource = self
        colorsTableView.delegate = self
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
        
        Utilities.styleTextField(priceTextField)
        addBottomLineToText(priceTextField)
        priceTextField.keyboardType = .numberPad
        
        Utilities.styleTextField(quantityTextField)
        addBottomLineToText(quantityTextField)
        quantityTextField.keyboardType = .numberPad
        
        Utilities.styleTextField(colorsTextField)
        addBottomLineToText(colorsTextField)
        colorsTextField.inputView = colorsPickerView
        colorsPickerView.delegate = self
        colorsPickerView.dataSource = self
        pickerViewToolbar(textField: colorsTextField, pickerView: colorsPickerView)
        
        Utilities.styleTextField(artistTextField)
        addBottomLineToText(artistTextField)
        artistTextField.inputView = artistPickerView
        artistPickerView.delegate = self
        artistPickerView.dataSource = self
        pickerViewToolbar(textField: artistTextField, pickerView: artistPickerView)
        
        Utilities.styleTextField(producerTextField)
        addBottomLineToText(producerTextField)
        producerTextField.inputView = producerPickerView
        producerPickerView.delegate = self
        producerPickerView.dataSource = self
        pickerViewToolbar(textField: producerTextField, pickerView: producerPickerView)
        
        Utilities.styleTextField(videosTextField)
        addBottomLineToText(videosTextField)
        videosTextField.inputView = videosPickerView
        videosPickerView.delegate = self
        videosPickerView.dataSource = self
        pickerViewToolbar(textField: videosTextField, pickerView: videosPickerView)
        
        Utilities.styleTextField(albumsTextField)
        addBottomLineToText(albumsTextField)
        albumsTextField.inputView = albumsPickerView
        albumsPickerView.delegate = self
        albumsPickerView.dataSource = self
        pickerViewToolbar(textField: albumsTextField, pickerView: albumsPickerView)
        
        Utilities.styleTextField(instrumentalsTextField)
        addBottomLineToText(instrumentalsTextField)
        instrumentalsTextField.inputView = instrumentalsPickerView
        instrumentalsPickerView.delegate = self
        instrumentalsPickerView.dataSource = self
        pickerViewToolbar(textField: instrumentalsTextField, pickerView: instrumentalsPickerView)
        
        Utilities.styleTextField(songsTextField)
        addBottomLineToText(songsTextField)
        songsTextField.inputView = songsPickerView
        songsPickerView.delegate = self
        songsPickerView.dataSource = self
        pickerViewToolbar(textField: songsTextField, pickerView: songsPickerView)
        
        Utilities.styleTextField(beatsTextField)
        addBottomLineToText(beatsTextField)
        beatsTextField.inputView = beatsPickerView
        beatsPickerView.delegate = self
        beatsPickerView.dataSource = self
        pickerViewToolbar(textField: beatsTextField, pickerView: beatsPickerView)
    }
    
    func setContentArrays() {
        DatabaseManager.shared.fetchAllArtistFromDatabase(completion: { artist in
            AllArtistInDatabaseArray = artist
        })
        DatabaseManager.shared.fetchAllProducersFromDatabase(completion: { producer in
            AllProducersInDatabaseArray = producer
        })
        DatabaseManager.shared.fetchAllSongsFromDatabase(completion: { song in
            AllSongsInDatabaseArray = song
        })
        DatabaseManager.shared.fetchAllVideosFromDatabase(completion: { video in
            //AllVideosInDatabaseArray = video
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
    }
    
    @IBAction func imageTapped(_ sender: Any) {
        presentPhotoActionSheet()
    }
    
    @IBAction func addSizeTapped(_ sender: Any) {
        guard chosenColor != "" else {
            Utilities.showError2("Color required"  ,actionText: "Ok")
            return
        }
        let colorHelper = MemorabiliaUploadColorHelper(price: nil, quantity: nil, color: chosenColor)
        if priceTextField.text != "" && priceTextField.text != "$0.00"{
            if let price = Double(priceTextField.text!.replacingOccurrences(of: "$", with: "")) {
                colorHelper.price = price
            }
        }
        if quantityTextField.text != "" {
            if let quan = Int(quantityTextField.text!) {
                colorHelper.quantity = quan
            }
        }
        
        guard !colors.contains(colorHelper) else {
            Utilities.showError2("This item in \(colorHelper.color) color is already added."  ,actionText: "Ok")
            return
        }
        colors.append(colorHelper)
        colorsTextField.text = ""
        chosenColor = ""
        colorsTableView.reloadData()
        view.layoutSubviews()
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
        guard !selectedImageArray.isEmpty else {
            Utilities.showError2("Image required"  ,actionText: "Ok")
            return
        }
        guard !colors.isEmpty else {
            Utilities.showError2("Image required"  ,actionText: "Ok")
            return
        }
        var newtot = Int(totalProgress)+selectedImageArray.count
        newtot+=colors.count
        totalProgress = Float(newtot)
        memorabiliaName = nameTextField.text!
        memorabiliaDescription = descriptionTextField.text!
        memorabiliaSubCategory = subCategoryTextField.text!
        alertView = UIAlertController(title: "Uploading \(memorabiliaName!)", message: "Preparing...", preferredStyle: .alert)
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
        let genid = StorageManager.shared.generateRandomNumber(digits: 24)
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
        let queue = DispatchQueue(label: "myhjvkhmemorabiliaQkitssssseue")
        let group = DispatchGroup()
        let array = [1,2,4,5,6,7,8,9,10,11]

        for i in array {
            print(i)
            group.enter()
            queue.async { [weak self] in
                guard let strongSelf = self else {return}
                switch i {
                case 1:
                    //print("null")
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
                    strongSelf.storeColors(completion: {[weak self] done in
                        guard let strongSelf = self else {return}
                        if done == false {
                            Utilities.showError2("Color Storing Failed.", actionText: "OK")
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
                    strongSelf.updateArtist(completion: {[weak self] done in
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
                case 6:
                    //print("null")
                    strongSelf.updateProducers(completion: {[weak self] done in
                        guard let strongSelf = self else {return}
                        if done == false {
                            Utilities.showError2("Producer Update Failed.", actionText: "OK")
                            strongSelf.uploadCompletionStatus7 = false
                        }
                        else {
                            strongSelf.uploadCompletionStatus7 = true
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
            if strongSelf.uploadCompletionStatus1 == false || strongSelf.uploadCompletionStatus2 == false || strongSelf.uploadCompletionStatus3 == false || strongSelf.uploadCompletionStatus5 == false || strongSelf.uploadCompletionStatus6 == false || strongSelf.uploadCompletionStatus7 == false || strongSelf.uploadCompletionStatus8 == false || strongSelf.uploadCompletionStatus9 == false || strongSelf.uploadCompletionStatus10 == false || strongSelf.uploadCompletionStatus11 == false || strongSelf.uploadCompletionStatus12 == false {
                strongSelf.alertView.dismiss(animated: true, completion: nil)
                Utilities.showError2("Upload Failed.", actionText: "OK")
                return
            } else {
                print("📗 Memorabilia data saved to database successfully.")
                strongSelf.alertView.dismiss(animated: true, completion: {
                    Utilities.successBarBanner("Upload successful.")
                    _ = strongSelf.navigationController?.popViewController(animated: true)
                })
            }
        }
    }
    
    func storeImages(completion: @escaping ((Bool) -> Void)) {
        let semaphore = DispatchSemaphore(value: 1)
        var tick = 0
        var imgnum = 1
        for image in selectedImageArray {
            guard let data = image.pngData() else {return}
            StorageManager.shared.uploadImage(memorabilia: data, subcat: memorabiliaSubCategory, fileName: "\(memorabiliaName!)-\(tDAppId)", completion: {[weak self] result in
                guard let strongSelf = self else {return}
                switch result {
                case .success(let url):
                    strongSelf.selectedImageURLsArray.append(url)
                    strongSelf.progressCompleted+=1
                    DispatchQueue.main.async {
                        strongSelf.progressView.progress = (strongSelf.progressCompleted/strongSelf.totalProgress)
                        print("\(strongSelf.progressCompleted) out of \(strongSelf.totalProgress)")
                    }
                    tick+=1
                    if tick == strongSelf.selectedImageArray.count {
                        Database.database().reference().child("Merch").child("\(strongSelf.tDAppId)Æ\(strongSelf.memorabiliaName!)").child("Images").setValue(strongSelf.selectedImageURLsArray)
                        completion(true)
                    }
                    imgnum+=1
                    semaphore.signal()
                case .failure(let err):
                    Utilities.showError2("Upload Failed. \(err) image: \(imgnum)", actionText: "OK")
                    completion(false)
                }
            })
            semaphore.wait()
        }
    }
    
    func storeColors(completion: @escaping ((Bool) -> Void)) {
        let semaphore = DispatchSemaphore(value: 1)
        var tick = 0
        for color in colors {
            let ref = Database.database().reference().child("Merch").child("\(tDAppId)Æ\(memorabiliaName!)").child("Colors").child(color.color)
            
            var RequiredInfoMa = [String : Any]()
            RequiredInfoMa = [
                "Color" : color.color,
                "Number of Purchases" : 0,
                "Date Restocked": date!,
                "Quantity": color.quantity as Any,
                "Retail Price": color.price as Any,
                "Description": memorabiliaDescription!
            ]
            
            ref.updateChildValues(RequiredInfoMa) {[weak self] (error, songRef) in
                guard let strongSelf = self else {return}
                if let error = error {
                    print("📕 Failed to upload \(color.color) dictionary to database: \(error)")
                    completion(false)
                    return
                } else {
                    strongSelf.progressCompleted+=1
                    DispatchQueue.main.async {
                        strongSelf.progressView.progress = (strongSelf.progressCompleted/strongSelf.totalProgress)
                        print("\(strongSelf.progressCompleted) out of \(strongSelf.totalProgress)")
                    }
                    tick+=1
                    if tick == strongSelf.colors.count {
                        completion(true)
                    }
                    semaphore.signal()
                }
            }
            semaphore.wait()
        }
    }
    
    func uploadMerchToDB(completion: @escaping ((Bool) -> Void)) {
        DispatchQueue.main.async {[weak self] in
            guard let strongSelf = self else {return}
            
            var RequiredInfoMa = [String : Any]()
            RequiredInfoMa = [
                "Tone Deaf App Id" : strongSelf.tDAppId,
                "Name" : strongSelf.memorabiliaName!,
                "Number of Favorites" : 0,
                "Number of Purchases" : 0,
                "Date Uploaded": strongSelf.date!,
                "Merch Type": "Apperal",
                "Sub Category": strongSelf.memorabiliaSubCategory!
            ]

            let RequiredRef = Database.database().reference().child("Merch").child("\(strongSelf.tDAppId)Æ\(strongSelf.memorabiliaName!)")
            RequiredRef.updateChildValues(RequiredInfoMa) { (error, songRef) in
                if let error = error {
                    print("📕 Failed to upload dictionary to database: \(error)")
                    completion(false)
                    return
                } else {
                    Database.database().reference().child("All Content IDs") .observeSingleEvent(of: .value, with: {[weak self] snap in
                        guard let strongSelf = self else {return}
                        var arr = snap.value as! [String]
                        if !arr.contains("\(strongSelf.tDAppId)Æ\(strongSelf.memorabiliaName!)") {
                            arr.append("\(strongSelf.tDAppId)Æ\(strongSelf.memorabiliaName!)")
                        }
                        Database.database().reference().child("All Content IDs").setValue(arr)
                        completion(true)
                    })
                }
            }
        }
    }
    
    func updateArtist(completion: @escaping ((Bool) -> Void)) {
        guard !artistref.isEmpty else {
            completion(true)
            return
        }
        var tick = 0
        for art in artistref {
            let ref = Database.database().reference().child("Registered Artists").child(art).child("Merch")
            ref.observeSingleEvent(of: .value, with: {[weak self] snap in
                guard let strongSelf = self else {return}
                var newArr:[String] = []
                if let val = snap.value as? [String] {
                    newArr = val
                    if !newArr.contains("\(strongSelf.tDAppId)Æ\(strongSelf.memorabiliaName!)") {
                        newArr.append("\(strongSelf.tDAppId)Æ\(strongSelf.memorabiliaName!)")
                    }
                    ref.setValue(newArr)
                    tick+=1
                    if tick == strongSelf.artistref.count {
                        Database.database().reference().child("Merch").child("\(strongSelf.tDAppId)Æ\(strongSelf.memorabiliaName!)").child("Artists").setValue(strongSelf.memorabiliaArtists)
                        completion(true)
                    }
                } else {
                    if !newArr.contains("\(strongSelf.tDAppId)Æ\(strongSelf.memorabiliaName!)") {
                        newArr.append("\(strongSelf.tDAppId)Æ\(strongSelf.memorabiliaName!)")
                    }
                    ref.setValue(newArr)
                    tick+=1
                    if tick == strongSelf.artistref.count {
                        Database.database().reference().child("Merch").child("\(strongSelf.tDAppId)Æ\(strongSelf.memorabiliaName!)").child("Artists").setValue(strongSelf.memorabiliaArtists)
                        completion(true)
                    }
                }
            })
        }
    }
    
    func updateProducers(completion: @escaping ((Bool) -> Void)) {
        guard !producerref.isEmpty else {
            completion(true)
            return
        }
        var tick = 0
        for art in producerref {
            let ref = Database.database().reference().child("Registered Producers").child(art).child("Merch")
            ref.observeSingleEvent(of: .value, with: {[weak self] snap in
                guard let strongSelf = self else {return}
                var newArr:[String] = []
                if let val = snap.value as? [String] {
                    newArr = val
                    if !newArr.contains("\(strongSelf.tDAppId)Æ\(strongSelf.memorabiliaName!)") {
                        newArr.append("\(strongSelf.tDAppId)Æ\(strongSelf.memorabiliaName!)")
                    }
                    ref.setValue(newArr)
                    tick+=1
                    if tick == strongSelf.producerref.count {
                        Database.database().reference().child("Merch").child("\(strongSelf.tDAppId)Æ\(strongSelf.memorabiliaName!)").child("Producers").setValue(strongSelf.memorabiliaProducers)
                        completion(true)
                    }
                } else {
                    if !newArr.contains("\(strongSelf.tDAppId)Æ\(strongSelf.memorabiliaName!)") {
                        newArr.append("\(strongSelf.tDAppId)Æ\(strongSelf.memorabiliaName!)")
                    }
                    ref.setValue(newArr)
                    tick+=1
                    if tick == strongSelf.producerref.count {
                        Database.database().reference().child("Merch").child("\(strongSelf.tDAppId)Æ\(strongSelf.memorabiliaName!)").child("Producers").setValue(strongSelf.memorabiliaProducers)
                        completion(true)
                    }
                }
            })
        }
    }
    
    func updateSongs(completion: @escaping ((Bool) -> Void)) {
        guard !songref.isEmpty else {
            completion(true)
            return
        }
        var tick = 0
        for son in songref {
            let ref = Database.database().reference().child("Music Content").child("Songs").child(son).child("REQUIRED").child("Merch")
            ref.observeSingleEvent(of: .value, with: {[weak self] snap in
                guard let strongSelf = self else {return}
                var newArr:[String] = []
                if let val = snap.value as? [String] {
                    newArr = val
                    if !newArr.contains("\(strongSelf.tDAppId)Æ\(strongSelf.memorabiliaName!)") {
                        newArr.append("\(strongSelf.tDAppId)Æ\(strongSelf.memorabiliaName!)")
                    }
                    ref.setValue(newArr)
                    tick+=1
                    if tick == strongSelf.songref.count {
                        Database.database().reference().child("Merch").child("\(strongSelf.tDAppId)Æ\(strongSelf.memorabiliaName!)").child("Songs").setValue(strongSelf.memorabiliaSongs)
                        completion(true)
                    }
                } else {
                    if !newArr.contains("\(strongSelf.tDAppId)Æ\(strongSelf.memorabiliaName!)") {
                        newArr.append("\(strongSelf.tDAppId)Æ\(strongSelf.memorabiliaName!)")
                    }
                    ref.setValue(newArr)
                    tick+=1
                    if tick == strongSelf.songref.count {
                        Database.database().reference().child("Merch").child("\(strongSelf.tDAppId)Æ\(strongSelf.memorabiliaName!)").child("Songs").setValue(strongSelf.memorabiliaSongs)
                        completion(true)
                    }
                }
            })
        }
    }
    
    func updateVideos(completion: @escaping ((Bool) -> Void)) {
        guard !videoref.isEmpty else {
            completion(true)
            return
        }
        var tick = 0
        for vid in videoref {
            let ref = Database.database().reference().child("Music Content").child("Videos").child(vid).child("Merch")
            ref.observeSingleEvent(of: .value, with: {[weak self] snap in
                guard let strongSelf = self else {return}
                var newArr:[String] = []
                if let val = snap.value as? [String] {
                    newArr = val
                    if !newArr.contains("\(strongSelf.tDAppId)Æ\(strongSelf.memorabiliaName!)") {
                        newArr.append("\(strongSelf.tDAppId)Æ\(strongSelf.memorabiliaName!)")
                    }
                    ref.setValue(newArr)
                    tick+=1
                    if tick == strongSelf.videoref.count {
                        Database.database().reference().child("Merch").child("\(strongSelf.tDAppId)Æ\(strongSelf.memorabiliaName!)").child("Videos").setValue(strongSelf.memorabiliaVideos)
                        completion(true)
                    }
                } else {
                    if !newArr.contains("\(strongSelf.tDAppId)Æ\(strongSelf.memorabiliaName!)") {
                        newArr.append("\(strongSelf.tDAppId)Æ\(strongSelf.memorabiliaName!)")
                    }
                    ref.setValue(newArr)
                    tick+=1
                    if tick == strongSelf.videoref.count {
                        Database.database().reference().child("Merch").child("\(strongSelf.tDAppId)Æ\(strongSelf.memorabiliaName!)").child("Videos").setValue(strongSelf.memorabiliaVideos)
                        completion(true)
                    }
                }
            })
        }
    }
    
    func updateAlbums(completion: @escaping ((Bool) -> Void)) {
        guard !albumref.isEmpty else {
            completion(true)
            return
        }
        var tick = 0
        for vid in albumref {
            let ref = Database.database().reference().child("Music Content").child("Albums").child(vid).child("REQUIRED").child("Merch")
            ref.observeSingleEvent(of: .value, with: {[weak self] snap in
                guard let strongSelf = self else {return}
                var newArr:[String] = []
                if let val = snap.value as? [String] {
                    newArr = val
                    if !newArr.contains("\(strongSelf.tDAppId)Æ\(strongSelf.memorabiliaName!)") {
                        newArr.append("\(strongSelf.tDAppId)Æ\(strongSelf.memorabiliaName!)")
                    }
                    ref.setValue(newArr)
                    tick+=1
                    if tick == strongSelf.albumref.count {
                        Database.database().reference().child("Merch").child("\(strongSelf.tDAppId)Æ\(strongSelf.memorabiliaName!)").child("Albums").setValue(strongSelf.memorabiliaAlbums)
                        completion(true)
                    }
                } else {
                    if !newArr.contains("\(strongSelf.tDAppId)Æ\(strongSelf.memorabiliaName!)") {
                        newArr.append("\(strongSelf.tDAppId)Æ\(strongSelf.memorabiliaName!)")
                    }
                    ref.setValue(newArr)
                    tick+=1
                    if tick == strongSelf.albumref.count {
                        Database.database().reference().child("Merch").child("\(strongSelf.tDAppId)Æ\(strongSelf.memorabiliaName!)").child("Albums").setValue(strongSelf.memorabiliaAlbums)
                        completion(true)
                    }
                }
            })
        }
    }
    
    func updateInstrumentals(completion: @escaping ((Bool) -> Void)) {
        guard !instrumentalref.isEmpty else {
            completion(true)
            return
        }
        var tick = 0
        for ints in instrumentalref {
            let ref = Database.database().reference().child("Music Content").child("Instrumentals").child(ints).child("Merch")
            ref.observeSingleEvent(of: .value, with: {[weak self] snap in
                guard let strongSelf = self else {return}
                var newArr:[String] = []
                if let val = snap.value as? [String] {
                    newArr = val
                    if !newArr.contains("\(strongSelf.tDAppId)Æ\(strongSelf.memorabiliaName!)") {
                        newArr.append("\(strongSelf.tDAppId)Æ\(strongSelf.memorabiliaName!)")
                    }
                    ref.setValue(newArr)
                    tick+=1
                    if tick == strongSelf.instrumentalref.count {
                        Database.database().reference().child("Merch").child("\(strongSelf.tDAppId)Æ\(strongSelf.memorabiliaName!)").child("Instrumentals").setValue(strongSelf.memorabiliaInstrumentals)
                        completion(true)
                    }
                } else {
                    if !newArr.contains("\(strongSelf.tDAppId)Æ\(strongSelf.memorabiliaName!)") {
                        newArr.append("\(strongSelf.tDAppId)Æ\(strongSelf.memorabiliaName!)")
                    }
                    ref.setValue(newArr)
                    tick+=1
                    if tick == strongSelf.instrumentalref.count {
                        Database.database().reference().child("Merch").child("\(strongSelf.tDAppId)Æ\(strongSelf.memorabiliaName!)").child("Instrumentals").setValue(strongSelf.memorabiliaInstrumentals)
                        completion(true)
                    }
                }
            })
        }
    }
    
    func updateBeats(completion: @escaping ((Bool) -> Void)) {
        guard !beatref.isEmpty else {
            completion(true)
            return
        }
        var tick = 0
        for bea in beatref {
            let word = bea.split(separator: "ß")
            let pricetype = word[0]
            let id = word[1]
            let ref = Database.database().reference().child("Beats").child(String(pricetype)).child(String(id)).child("Merch")
            ref.observeSingleEvent(of: .value, with: {[weak self] snap in
                guard let strongSelf = self else {return}
                var newArr:[String] = []
                if let val = snap.value as? [String] {
                    newArr = val
                    if !newArr.contains("\(strongSelf.tDAppId)Æ\(strongSelf.memorabiliaName!)") {
                        newArr.append("\(strongSelf.tDAppId)Æ\(strongSelf.memorabiliaName!)")
                    }
                    ref.setValue(newArr)
                    tick+=1
                    if tick == strongSelf.beatref.count {
                        Database.database().reference().child("Merch").child("\(strongSelf.tDAppId)Æ\(strongSelf.memorabiliaName!)").child("Beats").setValue(strongSelf.memorabiliaBeats)
                        completion(true)
                    }
                } else {
                    if !newArr.contains("\(strongSelf.tDAppId)Æ\(strongSelf.memorabiliaName!)") {
                        newArr.append("\(strongSelf.tDAppId)Æ\(strongSelf.memorabiliaName!)")
                    }
                    ref.setValue(newArr)
                    tick+=1
                    if tick == strongSelf.beatref.count {
                        Database.database().reference().child("Merch").child("\(strongSelf.tDAppId)Æ\(strongSelf.memorabiliaName!)").child("Beats").setValue(strongSelf.memorabiliaBeats)
                        completion(true)
                    }
                }
            })
        }
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @objc func dismissKeyboard2() {
        artistref.append(chosenArtistRef)
        memorabiliaArtists.append("\(chosenArtist.trimmingCharacters(in: .whitespacesAndNewlines))Æ\(chosenArtistNames.trimmingCharacters(in: .whitespacesAndNewlines))")
        memorabiliaArtistsNames.append(chosenArtistNames.trimmingCharacters(in: .whitespacesAndNewlines))
        artistTextField.text = memorabiliaArtistsNames.joined(separator: ", ")
        view.endEditing(true)
    }
    
    @objc func dismissKeyboard3() {
        producerref.append(chosenProducerRef)
        memorabiliaProducers.append("\(chosenProducer.trimmingCharacters(in: .whitespacesAndNewlines))Æ\(chosenProducerNames.trimmingCharacters(in: .whitespacesAndNewlines))")
        memorabiliaProducerNames.append(chosenProducerNames.trimmingCharacters(in: .whitespacesAndNewlines))
        producerTextField.text = memorabiliaProducerNames.joined(separator: ", ")
        view.endEditing(true)
    }
    
    @objc func dismissKeyboard4() {
        songref.append(chosenSongRef)
        memorabiliaSongs.append("\(chosenSong.trimmingCharacters(in: .whitespacesAndNewlines))Æ\(chosenSongNames.trimmingCharacters(in: .whitespacesAndNewlines))")
        memorabiliaSongNames.append(chosenSongNames.trimmingCharacters(in: .whitespacesAndNewlines))
        songsTextField.text = memorabiliaSongNames.joined(separator: ", ")
        view.endEditing(true)
    }
    
    @objc func dismissKeyboard5() {
        albumref.append(chosenAlbumRef)
        memorabiliaAlbums.append("\(chosenAlbum.trimmingCharacters(in: .whitespacesAndNewlines))Æ\(chosenAlbumNames.trimmingCharacters(in: .whitespacesAndNewlines))")
        memorabiliaAlbumNames.append(chosenAlbumNames.trimmingCharacters(in: .whitespacesAndNewlines))
        albumsTextField.text = memorabiliaAlbumNames.joined(separator: ", ")
        view.endEditing(true)
    }
    
    @objc func dismissKeyboard6() {
        videoref.append(chosenVideoRef)
        memorabiliaVideos.append("\(chosenVideo.trimmingCharacters(in: .whitespacesAndNewlines))Æ\(chosenVideoNames.trimmingCharacters(in: .whitespacesAndNewlines))")
        memorabiliaVideoNames.append(chosenVideoNames.trimmingCharacters(in: .whitespacesAndNewlines))
        videosTextField.text = memorabiliaVideoNames.joined(separator: ", ")
        view.endEditing(true)
    }
    
    @objc func dismissKeyboard7() {
        instrumentalref.append(chosenInstrumentalRef)
        memorabiliaInstrumentals.append("\(chosenInstrumental.trimmingCharacters(in: .whitespacesAndNewlines))Æ\(chosenInstrumentalNames.trimmingCharacters(in: .whitespacesAndNewlines))")
        memorabiliaInstrumentalNames.append(chosenInstrumentalNames.trimmingCharacters(in: .whitespacesAndNewlines))
        instrumentalsTextField.text = memorabiliaInstrumentalNames.joined(separator: ", ")
        view.endEditing(true)
    }
    
    @objc func dismissKeyboard8() {
        beatref.append(chosenBeatRef)
        memorabiliaBeats.append("\(chosenBeat.trimmingCharacters(in: .whitespacesAndNewlines))Æ\(chosenBeatNames.trimmingCharacters(in: .whitespacesAndNewlines))")
        memorabiliaBeatNames.append(chosenBeatNames.trimmingCharacters(in: .whitespacesAndNewlines))
        beatsTextField.text = memorabiliaBeatNames.joined(separator: ", ")
        view.endEditing(true)
    }
    
    func dismissKeyboardOnTap() {
        let tap = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        scrollView1.keyboardDismissMode = .onDrag
    }
}

extension MemorabiliaUploadViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableHeaderFooterView(withIdentifier: "TableSectionHeader") as! TableSectionHeader
        var sectitle = ""
        switch tableView {
        case imagesTableView:
            if selectedImageArray.count == 0 {
                sectitle = "Images"
            } else {
                sectitle = "Images (\(selectedImageArray.count))"
            }
        default:
            if colors.count == 0 {
                sectitle = "Colors"
            } else {
                sectitle = "Colors (\(colors.count))"
            }
        }
        let header = cell
        header.titleLabel.text = sectitle
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch tableView {
        case imagesTableView:
            return selectedImageArray.count
        default:
            return colors.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch tableView {
        case imagesTableView:
            let cell = tableView.dequeueReusableCell(withIdentifier: "merchUploadImageTableViewCell", for: indexPath) as! MerchUploadImageTableViewCell
            cell.funcSetUp(image: selectedImageArray[indexPath.row])
            cell.imagev.image = selectedImageArray[indexPath.row]
            cell.imagenum.text = String(indexPath.row+1)
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "merchUploadMemorabiliaColorsTableViewCell", for: indexPath) as! MerchUploadMemorabiliaColorsTableViewCell
            cell.funcSetUp(color: colors[indexPath.row])
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            switch tableView {
            case imagesTableView:
                selectedImageArray.remove(at: (indexPath).row)
                imagesTableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.fade)
                imagesTableView.reloadData()
            default:
                colors.remove(at: (indexPath).row)
                colorsTableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.fade)
                colorsTableView.reloadData()
            }
            view.layoutSubviews()
        }
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        switch tableView {
        case imagesTableView:
            let movedObject = selectedImageArray[sourceIndexPath.row]
               selectedImageArray.remove(at: sourceIndexPath.row)
            selectedImageArray.insert(movedObject, at: destinationIndexPath.row)
            imagesTableView.reloadData()
        default:
            let movedObject = colors[sourceIndexPath.row]
               colors.remove(at: sourceIndexPath.row)
            colors.insert(movedObject, at: destinationIndexPath.row)
            colorsTableView.reloadData()
        }
        view.layoutSubviews()
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        return false
    }
}

extension MemorabiliaUploadViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func presentPhotoActionSheet() {
        let actionSheet = UIAlertController(title: "Open photo library?", message: nil, preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
        actionSheet.addAction(UIAlertAction(title: "Yes", style: .default, handler: { [weak self] _ in
            self?.openGallery()
        
        }))
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

extension MemorabiliaUploadViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        var number = 0
        if pickerView == subCategoryPickerView {
            number = subcategories.count
        }
        if pickerView == artistPickerView {
            number = AllArtistInDatabaseArray.count
        }
        if pickerView == producerPickerView {
            number = AllProducersInDatabaseArray.count
        }
        if pickerView == songsPickerView {
            number = AllSongsInDatabaseArray.count
        }
        if pickerView == videosPickerView {
            number = AllVideosInDatabaseArray.count
        }
        if pickerView == albumsPickerView {
            number = AllAlbumsInDatabaseArray.count
        }
        if pickerView == beatsPickerView {
            number = AllBeatsInDatabaseArray.count
        }
        if pickerView == instrumentalsPickerView {
            number = AllInstrumentalsInDatabaseArray.count
        }
        if pickerView == colorsPickerView {
            number = colorlist.count
        }
        return number
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        var number = ""
        if pickerView == subCategoryPickerView {
            number = subcategories[row]
        }
        if pickerView == artistPickerView {
            number = "\(AllArtistInDatabaseArray[row].name ?? "artist") -- \(AllArtistInDatabaseArray[row].toneDeafAppId)"
        }
        if pickerView == producerPickerView {
            number = "\(AllProducersInDatabaseArray[row].name ?? "producer") -- \(AllProducersInDatabaseArray[row].toneDeafAppId)"
        }
        if pickerView == songsPickerView {
            number = "\(AllSongsInDatabaseArray[row].name ) -- \(AllSongsInDatabaseArray[row].toneDeafAppId)"
        }
        if pickerView == albumsPickerView {
            number = "\(AllAlbumsInDatabaseArray[row].name ) -- \(AllAlbumsInDatabaseArray[row].toneDeafAppId)"
        }
        if pickerView == beatsPickerView {
            number = "\(AllBeatsInDatabaseArray[row].name ) -- \(AllBeatsInDatabaseArray[row].toneDeafAppId)"
        }
        if pickerView == instrumentalsPickerView {
            number = "\(AllInstrumentalsInDatabaseArray[row].instrumentalName ) -- \(AllInstrumentalsInDatabaseArray[row].toneDeafAppId)"
        }
        if pickerView == videosPickerView {
            switch AllVideosInDatabaseArray[row] {
            case is YouTubeData:
                let video = AllVideosInDatabaseArray[row] as! YouTubeData
                number = "\(video.title ) -- \(video.toneDeafAppId)"
            default:
                print("other")
            }
        }
        if pickerView == colorsPickerView {
            number = colorlist[row]
        }
        return number
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == subCategoryPickerView {
            subCategoryTextField.text = subcategories[row]
        }
        if pickerView == artistPickerView {
            chosenArtist = AllArtistInDatabaseArray[row].toneDeafAppId.trimmingCharacters(in: .whitespacesAndNewlines)
            chosenArtistNames = AllArtistInDatabaseArray[row].name.trimmingCharacters(in: .whitespacesAndNewlines)
            chosenArtistRef = "\(AllArtistInDatabaseArray[row].name!)--\(AllArtistInDatabaseArray[row].dateRegisteredToApp!)--\(AllArtistInDatabaseArray[row].timeRegisteredToApp!)--\(AllArtistInDatabaseArray[row].toneDeafAppId)"
        }
        if pickerView == producerPickerView {
            chosenProducer = AllProducersInDatabaseArray[row].toneDeafAppId.trimmingCharacters(in: .whitespacesAndNewlines)
            chosenProducerNames = AllProducersInDatabaseArray[row].name.trimmingCharacters(in: .whitespacesAndNewlines)
            chosenProducerRef = "\(AllProducersInDatabaseArray[row].name!)--\(AllProducersInDatabaseArray[row].dateRegisteredToApp!)--\(AllProducersInDatabaseArray[row].timeRegisteredToApp!)--\(AllProducersInDatabaseArray[row].toneDeafAppId)"
        }
        if pickerView == songsPickerView {
            chosenSong = AllSongsInDatabaseArray[row].toneDeafAppId.trimmingCharacters(in: .whitespacesAndNewlines)
            chosenSongNames = AllSongsInDatabaseArray[row].name.trimmingCharacters(in: .whitespacesAndNewlines)
            var songart:[String] = []
            for art in AllSongsInDatabaseArray[row].songArtist {
                let word = art.split(separator: "Æ")
                let id = word[1]
                songart.append(String(id))
            }
            chosenSongRef = "\(songContentTag)--\(AllSongsInDatabaseArray[row].name)--\(songart.joined(separator: ", "))--\(AllSongsInDatabaseArray[row].toneDeafAppId)"
        }
        if pickerView == albumsPickerView {
            var songart:[String] = []
            for art in AllAlbumsInDatabaseArray[row].mainArtist {
                let word = art.split(separator: "Æ")
                let id = word[1]
                songart.append(String(id))
            }
            chosenAlbumRef = "\(albumContentTag)--\(AllAlbumsInDatabaseArray[row].name)--\(songart.joined(separator: ", "))--\(AllAlbumsInDatabaseArray[row].toneDeafAppId)"
            chosenAlbum = AllAlbumsInDatabaseArray[row].toneDeafAppId.trimmingCharacters(in: .whitespacesAndNewlines)
            chosenAlbumNames = AllAlbumsInDatabaseArray[row].name.trimmingCharacters(in: .whitespacesAndNewlines)
        }
        if pickerView == videosPickerView {
            switch AllVideosInDatabaseArray[row] {
            case is YouTubeData:
                let video = AllVideosInDatabaseArray[row] as! YouTubeData
                chosenVideoRef = "\(video.type)--\(video.title)--\(video.dateIA)--\(video.timeIA)--\(video.toneDeafAppId)"
                chosenVideo = video.toneDeafAppId.trimmingCharacters(in: .whitespacesAndNewlines)
                chosenVideoNames = video.title.trimmingCharacters(in: .whitespacesAndNewlines)
            default:
                print("other")
            }
        }
        if pickerView == instrumentalsPickerView {
            chosenInstrumentalRef = "\(instrumentalContentType)--\(AllInstrumentalsInDatabaseArray[row].instrumentalName!.replacingOccurrences(of: " (Instrumental)", with: ""))--\(AllInstrumentalsInDatabaseArray[row].dateRegisteredToApp!)--\(AllInstrumentalsInDatabaseArray[row].timeRegisteredToApp!)--\(AllInstrumentalsInDatabaseArray[row].toneDeafAppId)"
            chosenInstrumental = AllInstrumentalsInDatabaseArray[row].toneDeafAppId.trimmingCharacters(in: .whitespacesAndNewlines)
            chosenInstrumentalNames = AllInstrumentalsInDatabaseArray[row].instrumentalName!.trimmingCharacters(in: .whitespacesAndNewlines)
        }
        if pickerView == beatsPickerView {
            chosenBeatRef = "\(AllBeatsInDatabaseArray[row].priceType)ß\(AllBeatsInDatabaseArray[row].name)--\(AllBeatsInDatabaseArray[row].date)--\(AllBeatsInDatabaseArray[row].time)--\(AllBeatsInDatabaseArray[row].toneDeafAppId)"
            chosenBeat = AllBeatsInDatabaseArray[row].toneDeafAppId.trimmingCharacters(in: .whitespacesAndNewlines)
            chosenBeatNames = AllBeatsInDatabaseArray[row].name.trimmingCharacters(in: .whitespacesAndNewlines)
        }
        if pickerView == colorsPickerView {
            chosenColor = colorlist[row]
            colorsTextField.text = colorlist[row]
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
        if pickerView == artistPickerView {
           doneButton = UIBarButtonItem(title: "Add", style: UIBarButtonItem.Style.done, target: self, action: #selector(dismissKeyboard2))
        }
        if pickerView == producerPickerView {
           doneButton = UIBarButtonItem(title: "Add", style: UIBarButtonItem.Style.done, target: self, action: #selector(dismissKeyboard3))
        }
        if pickerView == songsPickerView {
           doneButton = UIBarButtonItem(title: "Add", style: UIBarButtonItem.Style.done, target: self, action: #selector(dismissKeyboard4))
        }
        if pickerView == albumsPickerView {
           doneButton = UIBarButtonItem(title: "Add", style: UIBarButtonItem.Style.done, target: self, action: #selector(dismissKeyboard5))
        }
        if pickerView == videosPickerView {
           doneButton = UIBarButtonItem(title: "Add", style: UIBarButtonItem.Style.done, target: self, action: #selector(dismissKeyboard6))
        }
        if pickerView == instrumentalsPickerView {
           doneButton = UIBarButtonItem(title: "Add", style: UIBarButtonItem.Style.done, target: self, action: #selector(dismissKeyboard7))
        }
        if pickerView == beatsPickerView {
           doneButton = UIBarButtonItem(title: "Add", style: UIBarButtonItem.Style.done, target: self, action: #selector(dismissKeyboard8))
        }
        if pickerView == colorsPickerView {
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

import MarqueeLabel

class MerchUploadMemorabiliaColorsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var priceitem: UILabel!
    @IBOutlet weak var quantity: UILabel!
    @IBOutlet weak var colorsitem: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        
    }
    
    func funcSetUp(color:MemorabiliaUploadColorHelper) {
        if let daprice = color.price {
            priceitem.text = daprice.dollarString
        } else {
            priceitem.text = "FREE"
        }
        if let daquan = color.quantity {
            quantity.text = "Qty: \(daquan)"
        } else {
            quantity.text = "Qty: SOLD OUT"
        }
        colorsitem.text = "Color: \(color.color)"
    }
}
