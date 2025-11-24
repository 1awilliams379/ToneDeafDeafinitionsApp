//
//  EditKitsViewController.swift
//  ToneDeafDeafinitionsApp
//
//  Created by Tone Deaf on 11/1/20.
//  Copyright © 2020 GITEM Solutions. All rights reserved.
//

import UIKit

class EditKitsViewController: UIViewController {
    
    @IBOutlet weak var scrollView1: UIScrollView!
    @IBOutlet weak var imagesTableView: UITableView!
    @IBOutlet weak var artistsTableView: UITableView!
    @IBOutlet weak var producersTableView: UITableView!
    @IBOutlet weak var songsTableView: UITableView!
    @IBOutlet weak var albumsTableView: UITableView!
    @IBOutlet weak var videosTableView: UITableView!
    @IBOutlet weak var instrumentalsTableView: UITableView!
    @IBOutlet weak var beatsTableView: UITableView!
    
    @IBOutlet weak var imagesHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var artistsHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var producersHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var songsHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var videosHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var albumsHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var instrumentalsHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var beatsHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var merchImage: UIImageView!
    @IBOutlet weak var merchImageURL: UILabel!
    @IBOutlet weak var merchName: UILabel!
    @IBOutlet weak var merchSubCategory: UILabel!
    @IBOutlet weak var merchDescription: UILabel!
    @IBOutlet weak var merchFileURL: UILabel!
    @IBOutlet weak var merchPreviewAudioURL: UILabel!
    @IBOutlet weak var merchQuantity: UILabel!
    @IBOutlet weak var merchRetailPrice: UILabel!
    @IBOutlet weak var merchSalePrice: UILabel!
    
    let subcategories = ["Loop Kits", "Drum Kits", "Sound Kit (Loop & Drum)"]
    
    var kitPickerView = UIPickerView()
    var merchSubCategoryPickerView = UIPickerView()
    var merchSalePricePickerView = UIPickerView()
    var merchArtistsPickerView = UIPickerView()
    var merchProducersPickerView = UIPickerView()
    var merchAlbumsPickerView = UIPickerView()
    var merchSongsPickerView = UIPickerView()
    var merchVideosPickerView = UIPickerView()
    var merchInstrumentalsPickerView = UIPickerView()
    var merchBeatsPickerView = UIPickerView()
    
    var currentMerch:MerchKitData!
    let initialMerch = MerchKitData(date: Date(), description: "", fileURL: "", imageURLs: [], merchType: "", name: "", quantity: 0, numberOfPurchases: 0, numberOfFavorites: 0, previewURL: "", retailPrice: 0.0, salePrice: nil, subcategory: "", tDAppId: "", artists: nil, producers: nil, songs: nil, albums: nil, videos: nil, instrumentals: nil, beats: nil)

    let hiddenSubCategoryTextField =  UITextField(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    let hiddenSaleTextField =  UITextField(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    let hiddenKitTextField =  UITextField(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    let hiddenArtistsTextField =  UITextField(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    let hiddenProducersTextField =  UITextField(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    let hiddenAlbumsTextField =  UITextField(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    let hiddenSongsTextField =  UITextField(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    let hiddenVideosTextField =  UITextField(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    let hiddenInstrumentalsTextField =  UITextField(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    let hiddenBeatsTextField =  UITextField(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    let percents: [Int] = Array(0...100)
    
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
    
    var selectedImageArray:[UIImage] = []
    var selectedImageURLsArray:[String] = []
    var currentFileType = ""
    var newAudio:URL!
    var newSubCat:String!
    var newTempo:Int!
    var btype:String!
    var sound:String!
    var artist:ArtistData!
    var producer:ProducerData!
    var song:SongData!
    var album:AlbumData!
    var video:AnyObject!
    var instrumental:InstrumentalData!
    var beat:BeatData!
    var newWav:URL!
    var newExclusive:URL!
    var arr = ""
    var ogPrice = ""
    var salePrice:Double!
    var SalePercentage:Double!
    
    var initImageArray:[UIImage] = []
    
    var progressView:UIProgressView!
    var totalProgress:Float = 7
    var progressCompleted:Float = 0
    var alertView:UIAlertController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createObservers()
        DatabaseManager.shared.fetchAllMerchKits(completion: { kits in
            AllKitsInDatabaseArray = kits
        })
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
        setUpElements()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        hiddenKitTextField.becomeFirstResponder()
    }
    
    func createObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        //NotificationCenter.default.addObserver(self, selector: #selector(addVideo(notification:)), name: EditMerchVideoSelectedNotify, object: nil)
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
    
    deinit {
        print("📗 Edit Kits view controller deinitialized.")
        NotificationCenter.default.removeObserver(self)
    }
    
    func setUpElements() {
        view.addSubview(hiddenKitTextField)
        hiddenKitTextField.isHidden = true
        hiddenKitTextField.inputView = kitPickerView
        kitPickerView.delegate = self
        kitPickerView.dataSource = self
        pickerViewToolbar(textField: hiddenKitTextField, pickerView: kitPickerView)
        
        view.addSubview(hiddenSubCategoryTextField)
        hiddenSubCategoryTextField.isHidden = true
        hiddenSubCategoryTextField.inputView = merchSubCategoryPickerView
        merchSubCategoryPickerView.delegate = self
        merchSubCategoryPickerView.dataSource = self
        pickerViewToolbar(textField: hiddenSubCategoryTextField, pickerView: merchSubCategoryPickerView)
        
        view.addSubview(hiddenArtistsTextField)
        hiddenArtistsTextField.isHidden = true
        hiddenArtistsTextField.inputView = merchArtistsPickerView
        merchArtistsPickerView.delegate = self
        merchArtistsPickerView.dataSource = self
        pickerViewToolbar(textField: hiddenArtistsTextField, pickerView: merchArtistsPickerView)
        
        view.addSubview(hiddenSongsTextField)
        hiddenSongsTextField.isHidden = true
        hiddenSongsTextField.inputView = merchSongsPickerView
        merchSongsPickerView.delegate = self
        merchSongsPickerView.dataSource = self
        pickerViewToolbar(textField: hiddenSongsTextField, pickerView: merchSongsPickerView)
        
        view.addSubview(hiddenAlbumsTextField)
        hiddenAlbumsTextField.isHidden = true
        hiddenAlbumsTextField.inputView = merchAlbumsPickerView
        merchAlbumsPickerView.delegate = self
        merchAlbumsPickerView.dataSource = self
        pickerViewToolbar(textField: hiddenAlbumsTextField, pickerView: merchAlbumsPickerView)
        
        view.addSubview(hiddenProducersTextField)
        hiddenProducersTextField.isHidden = true
        hiddenProducersTextField.inputView = merchProducersPickerView
        merchProducersPickerView.delegate = self
        merchProducersPickerView.dataSource = self
        pickerViewToolbar(textField: hiddenProducersTextField, pickerView: merchProducersPickerView)
        
        view.addSubview(hiddenVideosTextField)
        hiddenVideosTextField.isHidden = true
        hiddenVideosTextField.inputView = merchVideosPickerView
        merchVideosPickerView.delegate = self
        merchVideosPickerView.dataSource = self
        pickerViewToolbar(textField: hiddenVideosTextField, pickerView: merchVideosPickerView)
        
        view.addSubview(hiddenInstrumentalsTextField)
        hiddenInstrumentalsTextField.isHidden = true
        hiddenInstrumentalsTextField.inputView = merchInstrumentalsPickerView
        merchInstrumentalsPickerView.delegate = self
        merchInstrumentalsPickerView.dataSource = self
        pickerViewToolbar(textField: hiddenInstrumentalsTextField, pickerView: merchInstrumentalsPickerView)
        
        view.addSubview(hiddenBeatsTextField)
        hiddenBeatsTextField.isHidden = true
        hiddenBeatsTextField.inputView = merchBeatsPickerView
        merchBeatsPickerView.delegate = self
        merchBeatsPickerView.dataSource = self
        pickerViewToolbar(textField: hiddenBeatsTextField, pickerView: merchBeatsPickerView)
        
        view.addSubview(hiddenSaleTextField)
        hiddenSaleTextField.isHidden = true
        hiddenSaleTextField.inputView = merchSalePricePickerView
        merchSalePricePickerView.delegate = self
        merchSalePricePickerView.dataSource = self
        pickerViewToolbar(textField: hiddenSaleTextField, pickerView: merchSalePricePickerView)
        
    }
    
    func setUpPage() {
        selectedImageArray = []
        var tick = 0
        for img in currentMerch.imageURLs {
            let imageURL = URL(string: img)!
            imageURL.getImage(completion: {[weak self] image in
                guard let strongSelf = self else {return}
                strongSelf.selectedImageArray.append(image)
                strongSelf.initImageArray.append(image)
                tick+=1
                if tick == strongSelf.currentMerch.imageURLs.count {
                    DispatchQueue.main.async {
                        strongSelf.imagesTableView.delegate = self
                        strongSelf.imagesTableView.dataSource = self
                        strongSelf.imagesTableView.reloadData()
                        strongSelf.imagesHeightConstraint.constant = CGFloat(60*(strongSelf.selectedImageArray.count))
                        strongSelf.view.layoutSubviews()
                    }
                    
                }
            })
        }
        imagesTableView.isEditing = true
        artistsTableView.delegate = self
        artistsTableView.dataSource = self
        artistsTableView.reloadData()
        artistsHeightConstraint.constant = CGFloat(50*(currentMerch.artists?.count ?? 0))
        producersTableView.delegate = self
        producersTableView.dataSource = self
        producersTableView.reloadData()
        producersHeightConstraint.constant = CGFloat(50*(currentMerch.producers?.count ?? 0))
        songsTableView.delegate = self
        songsTableView.dataSource = self
        songsTableView.reloadData()
        songsHeightConstraint.constant = CGFloat(50*(currentMerch.songs?.count ?? 0))
        videosTableView.delegate = self
        videosTableView.dataSource = self
        videosTableView.reloadData()
        videosHeightConstraint.constant = CGFloat(50*(currentMerch.videos?.count ?? 0))
        albumsTableView.delegate = self
        albumsTableView.dataSource = self
        albumsTableView.reloadData()
        albumsHeightConstraint.constant = CGFloat(50*(currentMerch.albums?.count ?? 0))
        instrumentalsTableView.delegate = self
        instrumentalsTableView.dataSource = self
        instrumentalsTableView.reloadData()
        instrumentalsHeightConstraint.constant = CGFloat(50*(currentMerch.instrumentals?.count ?? 0))
        beatsTableView.delegate = self
        beatsTableView.dataSource = self
        beatsTableView.reloadData()
        beatsHeightConstraint.constant = CGFloat(50*(currentMerch.beats?.count ?? 0))
        merchName.text = currentMerch.name
        merchSubCategory.text = currentMerch.subcategory
        merchFileURL.text = currentMerch.fileURL
        merchPreviewAudioURL.text = currentMerch.previewURL
        merchImageURL.text = currentMerch.imageURLs[0]
        merchDescription.text = currentMerch.description
        if let qua = currentMerch.quantity {
            merchQuantity.text = String(qua)
        } else {
            merchQuantity.text = "∞"
        }
        merchRetailPrice.text = currentMerch.retailPrice.dollarString
        if let sale = currentMerch.salePrice {
            merchSalePrice.text = "\((sale*100).rounded())%(\((sale*currentMerch.retailPrice).dollarString))"
        } else {
            merchSalePrice.text = "N/A - Not On Sale"
        }
        let imageURL = URL(string: currentMerch.imageURLs[0])!
        if let cachedImage = imageCache.object(forKey: imageURL.absoluteString as NSString) {
            merchImage.image = cachedImage
        } else {
            merchImage.setImage(from: imageURL, withPlaceholder: UIImage(named: "tonedeaflogo"))
        }
        
    }
    
    @IBAction func addImageTapped(_ sender: Any) {
        presentPhotoActionSheet()
    }
    
    @IBAction func changeNameTapped(_ sender: Any) {
        let alertC = UIAlertController(title: "Change Name",
                                                message: "Please type in a name.",
                                                preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Change", style: .default, handler: {[weak self] _ in
            guard let strongSelf = self else {return}
            let field = alertC.textFields![0]
            if field.text != "" {
                guard let name = field.text else {return}
                strongSelf.merchName.text = name
                strongSelf.merchName.textColor = .green
                strongSelf.currentMerch.name = name
                alertC.dismiss(animated: true, completion: nil)
            } else {
                alertC.dismiss(animated: true, completion: nil)
            }
        })
        alertC.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alertC.addAction(okAction)
        alertC.addTextField()
        let field = alertC.textFields![0]
        field.text = currentMerch.name
        alertC.view.tintColor = Constants.Colors.redApp
        self.present(alertC, animated: true)
    }
    
    @IBAction func changeSubCatTapped(_ sender: Any) {
        hiddenSubCategoryTextField.becomeFirstResponder()
    }
    
    @IBAction func changeDescriptionTapped(_ sender: Any) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
        let textView = UITextView()
        textView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        let controller = UIViewController()
        
        textView.frame = controller.view.frame
        textView.text = merchDescription.text
        controller.view.addSubview(textView)
        
        alert.setValue(controller, forKey: "contentViewController")
        
        let height: NSLayoutConstraint = NSLayoutConstraint(item: alert.view!, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: view.frame.height * 0.8)
        alert.view.addConstraint(height)
        let okAction = UIAlertAction(title: "Change", style: .default, handler: {[weak self] _ in
            guard let strongSelf = self else {return}
            if textView.text != "" {
                guard let descript = textView.text else {return}
                strongSelf.merchDescription.text = descript
                strongSelf.merchDescription.textColor = .green
                strongSelf.currentMerch.description = descript
                alert.dismiss(animated: true, completion: nil)
            } else {
                alert.dismiss(animated: true, completion: nil)
            }
        })
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func changeQuantityTapped(_ sender: Any) {
        let alertC = UIAlertController(title: "Change Quantity",
                                                message: "Please type in a quantity.",
                                                preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Change", style: .default, handler: {[weak self] _ in
            guard let strongSelf = self else {return}
            let field = alertC.textFields![0]
            if field.text != "" {
                guard let quan = field.text else {return}
                strongSelf.merchQuantity.text = quan
                strongSelf.merchQuantity.textColor = .green
                guard let quant = Int(quan) else {
                    Utilities.showError2("Quantity Text Field Error", actionText: "OK")
                    return
                }
                strongSelf.currentMerch.quantity = quant
                alertC.dismiss(animated: true, completion: nil)
            } else {
                strongSelf.merchQuantity.text = "∞"
                strongSelf.merchQuantity.textColor = .green
                alertC.dismiss(animated: true, completion: nil)
            }
        })
        alertC.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alertC.addAction(okAction)
        alertC.addTextField()
        let field = alertC.textFields![0]
        if let qua = currentMerch.quantity {
            field.text = String(qua)
        } else {
            field.text = "∞"
        }
        field.keyboardType = .numberPad
        alertC.view.tintColor = Constants.Colors.redApp
        self.present(alertC, animated: true)
    }
    
    @IBAction func changeRetailTapped(_ sender: Any) {
        let alertC = UIAlertController(title: "Change Retail Price",
                                                message: "Please type in a price.",
                                                preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Change", style: .default, handler: {[weak self] _ in
            guard let strongSelf = self else {return}
            let field = alertC.textFields![0]
            if field.text != "" || field.text != strongSelf.merchRetailPrice.text {
                guard let pri = field.text else {return}
                strongSelf.merchRetailPrice.textColor = .green
                guard let pric = Double(pri) else {
                    Utilities.showError2("Retail Price Text Field Error", actionText: "OK")
                    return
                }
                strongSelf.merchRetailPrice.text = pric.dollarString
                if let sale = strongSelf.currentMerch.salePrice {
                    let ns = pric*sale
                    strongSelf.currentMerch.salePrice =  sale
                    strongSelf.salePrice = sale
                    strongSelf.merchSalePrice.text = "\(Int(sale*100))%(\(ns.dollarString))"
                    strongSelf.merchSalePrice.textColor = .green
                }
                strongSelf.currentMerch.retailPrice = Double(pric.dollarString.replacingOccurrences(of: "$", with: ""))!
                alertC.dismiss(animated: true, completion: nil)
            } else {
                alertC.dismiss(animated: true, completion: nil)
            }
        })
        alertC.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alertC.addAction(okAction)
        alertC.addTextField()
        let field = alertC.textFields![0]
        field.text = String(currentMerch.retailPrice)
        field.keyboardType = .decimalPad
        alertC.view.tintColor = Constants.Colors.redApp
        self.present(alertC, animated: true)
    }
    
    @IBAction func changeSaleTapped(_ sender: Any) {
        hiddenSaleTextField.becomeFirstResponder()
    }
    
    @IBAction func addArtistTapped(_ sender: Any) {
        hiddenArtistsTextField.becomeFirstResponder()
    }
    
    @IBAction func addProducersTapped(_ sender: Any) {
        hiddenProducersTextField.becomeFirstResponder()
    }
    
    @IBAction func addSongsTapped(_ sender: Any) {
        hiddenSongsTextField.becomeFirstResponder()
    }
    
    @IBAction func addAlbumsTapped(_ sender: Any) {
        hiddenAlbumsTextField.becomeFirstResponder()
    }
    
    @IBAction func addVideosTapped(_ sender: Any) {
        hiddenVideosTextField.becomeFirstResponder()
    }
    
    @IBAction func addInstrumentalsTapped(_ sender: Any) {
        hiddenInstrumentalsTextField.becomeFirstResponder()
    }
    
    @IBAction func addBeatsTapped(_ sender: Any) {
        hiddenBeatsTextField.becomeFirstResponder()
    }
    
    @IBAction func updateTapped(_ sender: Any) {
        guard !selectedImageArray.isEmpty else {
            Utilities.showError2("Image required"  ,actionText: "Ok")
            return
        }
        guard merchName.text != "" else {
            Utilities.showError2("Name required" ,actionText: "Ok")
            return
        }
        alertView = UIAlertController(title: "Updating \(merchName.text!)", message: "Preparing...", preferredStyle: .alert)
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
            strongSelf.proceedUpdate()
        })
//        let progressHUD = ProgressHUD(text: "Updating...")
//        self.view.addSubview(progressHUD)
//        EditBeatsHelper.shared.update(currentBeat: currentBeat, initialBeat: initialBeat, newimage: newImage, newAudio: newAudio, newWav: newWav, newExclusive: newExclusive, completion: {[weak self] updateerror in
//            guard let strongSelf = self else {return}
//            progressHUD.stopAnimation()
//            progressHUD.removeFromSuperview()
//            if let error = updateerror {
//                Utilities.showError2("Update Failed. \(error)", actionText: "OK")
//                return
//            } else {
//                print("📗 Beat data updated in database successfully.")
//                Utilities.successBarBanner("Update successful.")
//                _ = strongSelf.navigationController?.popViewController(animated: true)
//            }
//        })
    }
    
    func proceedUpdate() {
        let queue = DispatchQueue(label: "myhjvkheditingQkitssssseue")
        let group = DispatchGroup()
        let array = [1,2,3,4,5,6,14]

        for i in array {
            group.enter()
            queue.async { [weak self] in
                guard let strongSelf = self else {return}
                switch i {
                case 1:
                    strongSelf.processName(completion: {err in
                        if let errors = err {
                            for error in errors {
                                Utilities.showError2("Name Proccessing Failed: \(error)", actionText: "OK")
                            }
                            strongSelf.uploadCompletionStatus1 = false
                        } else {
                            strongSelf.progressCompleted+=1
                            DispatchQueue.main.async {
                                strongSelf.progressView.progress = (strongSelf.progressCompleted/strongSelf.totalProgress)
                                print("\(strongSelf.progressCompleted) out of \(strongSelf.totalProgress)")
                            }
                            strongSelf.uploadCompletionStatus1 = true
                            print("done \(i)")
                        }
                        group.leave()
                    })
                case 2:
                    strongSelf.processSubCat(completion: {err in
                        if let error = err {
                                Utilities.showError2("Sub Cat Proccessing Failed: \(error)", actionText: "OK")
                            strongSelf.uploadCompletionStatus2 = false
                        } else {
                            strongSelf.progressCompleted+=1
                            DispatchQueue.main.async {
                                strongSelf.progressView.progress = (strongSelf.progressCompleted/strongSelf.totalProgress)
                                print("\(strongSelf.progressCompleted) out of \(strongSelf.totalProgress)")
                            }
                            strongSelf.uploadCompletionStatus2 = true
                            print("done \(i)")
                        }
                        group.leave()
                    })
                case 3:
                    strongSelf.processDescription(completion: {err in
                        if let error = err {
                                Utilities.showError2("Description Proccessing Failed: \(error)", actionText: "OK")
                            strongSelf.uploadCompletionStatus3 = false
                        } else {
                            strongSelf.progressCompleted+=1
                            DispatchQueue.main.async {
                                strongSelf.progressView.progress = (strongSelf.progressCompleted/strongSelf.totalProgress)
                                print("\(strongSelf.progressCompleted) out of \(strongSelf.totalProgress)")
                            }
                            strongSelf.uploadCompletionStatus3 = true
                            print("done \(i)")
                        }
                        group.leave()
                    })
                case 4:
                    strongSelf.processQuantity(completion: {err in
                        if let error = err {
                            Utilities.showError2("Quantity Proccessing Failed: \(error)", actionText: "OK")
                            strongSelf.uploadCompletionStatus4 = false
                        } else {
                            strongSelf.progressCompleted+=1
                            DispatchQueue.main.async {
                                strongSelf.progressView.progress = (strongSelf.progressCompleted/strongSelf.totalProgress)
                                print("\(strongSelf.progressCompleted) out of \(strongSelf.totalProgress)")
                            }
                            strongSelf.uploadCompletionStatus4 = true
                            print("done \(i)")
                        }
                        group.leave()
                    })
                case 5:
                    strongSelf.processRetail(completion: {err in
                        if let error = err {
                            Utilities.showError2("Retail Price Proccessing Failed: \(error)", actionText: "OK")
                            strongSelf.uploadCompletionStatus5 = false
                        } else {
                            strongSelf.progressCompleted+=1
                            DispatchQueue.main.async {
                                strongSelf.progressView.progress = (strongSelf.progressCompleted/strongSelf.totalProgress)
                                print("\(strongSelf.progressCompleted) out of \(strongSelf.totalProgress)")
                            }
                            strongSelf.uploadCompletionStatus5 = true
                            print("done \(i)")
                        }
                        group.leave()
                    })
                case 6:
                    strongSelf.processSale(completion: {err in
                        if let error = err {
                            Utilities.showError2("Sale Price Proccessing Failed: \(error)", actionText: "OK")
                            strongSelf.uploadCompletionStatus6 = false
                        } else {
                            strongSelf.progressCompleted+=1
                            DispatchQueue.main.async {
                                strongSelf.progressView.progress = (strongSelf.progressCompleted/strongSelf.totalProgress)
                                print("\(strongSelf.progressCompleted) out of \(strongSelf.totalProgress)")
                            }
                            strongSelf.uploadCompletionStatus6 = true
                            print("done \(i)")
                        }
                        group.leave()
                    })
                case 14:
                    strongSelf.processImages(completion: {err, imgnum in
                        if let error = err {
                            if let inum = imgnum {
                                Utilities.showError2("Image \(inum) Proccessing Failed: \(error)", actionText: "OK")
                            } else {
                                Utilities.showError2("Image Proccessing Failed: \(error)", actionText: "OK")
                            }
                            strongSelf.uploadCompletionStatus14 = false
                        } else {
                            strongSelf.progressCompleted+=1
                            DispatchQueue.main.async {
                                strongSelf.progressView.progress = (strongSelf.progressCompleted/strongSelf.totalProgress)
                                print("\(strongSelf.progressCompleted) out of \(strongSelf.totalProgress)")
                            }
                            strongSelf.uploadCompletionStatus14 = true
                            print("done \(i)")
                        }
                        group.leave()
                    })
                default:
                    print("Edit Kit error")
                }
            }
        }
        
        group.notify(queue: DispatchQueue.main) { [weak self] in
            guard let strongSelf = self else {return}
            if strongSelf.uploadCompletionStatus1 == false || strongSelf.uploadCompletionStatus2 == false || strongSelf.uploadCompletionStatus3 == false || strongSelf.uploadCompletionStatus4 == false || strongSelf.uploadCompletionStatus5 == false {
                strongSelf.alertView.dismiss(animated: true, completion: nil)
                Utilities.showError2("Upload Failed.", actionText: "OK")
                return
            } else {
                print("📗 Kit data updated to database successfully.")
                strongSelf.alertView.dismiss(animated: true, completion: {
                    Utilities.successBarBanner("Update successful.")
                    _ = strongSelf.navigationController?.popViewController(animated: true)
                })
            }
        }
    }
    
    func processImages(completion: @escaping ((Error?, Int?) -> Void)) {
        guard selectedImageArray != initImageArray else {
            completion(nil,nil)
            return
        }
        EditKitsHelper.shared.processImage(initialKit: initialMerch,currentKit: currentMerch,images: selectedImageArray, completion: {[weak self] err,imgnum in
            guard let strongSelf = self else {return}
            if let error = err {
                completion(error, imgnum)
                return
            } else {
                completion(nil, nil)
                return
            }
        })
    }
    
    func processName(completion: @escaping (([Error]?) -> Void)) {
        guard currentMerch.name != initialMerch.name else {
            completion(nil)
            return
        }
        EditKitsHelper.shared.processName(initialKit: initialMerch,currentKit: currentMerch, completion: {[weak self] err in
            guard let strongSelf = self else {return}
            if let error = err {
                completion(error)
                return
            } else {
                completion(nil)
                return
            }
        })
    }
    
    func processSubCat(completion: @escaping ((Error?) -> Void)) {
        guard currentMerch.subcategory != initialMerch.subcategory else {
            completion(nil)
            return
        }
        EditKitsHelper.shared.processSubCat(initialKit: initialMerch,currentKit: currentMerch, completion: {[weak self] err in
            guard let strongSelf = self else {return}
            if let error = err {
                completion(error)
                return
            } else {
                completion(nil)
                return
            }
        })
    }
    
    func processDescription(completion: @escaping ((Error?) -> Void)) {
        guard currentMerch.description != initialMerch.description else {
            completion(nil)
            return
        }
        EditKitsHelper.shared.processDescription(initialKit: initialMerch,currentKit: currentMerch, completion: {[weak self] err in
            guard let strongSelf = self else {return}
            if let error = err {
                completion(error)
                return
            } else {
                completion(nil)
                return
            }
        })
    }
    
    func processQuantity(completion: @escaping ((Error?) -> Void)) {
        guard currentMerch.quantity != initialMerch.quantity else {
            completion(nil)
            return
        }
        EditKitsHelper.shared.processQuantity(initialKit: initialMerch,currentKit: currentMerch, completion: {[weak self] err in
            guard let strongSelf = self else {return}
            if let error = err {
                completion(error)
                return
            } else {
                completion(nil)
                return
            }
        })
    }
    
    func processRetail(completion: @escaping ((Error?) -> Void)) {
        guard currentMerch.retailPrice != initialMerch.retailPrice else {
            completion(nil)
            return
        }
        EditKitsHelper.shared.processRetail(initialKit: initialMerch,currentKit: currentMerch, completion: {[weak self] err in
            guard let strongSelf = self else {return}
            if let error = err {
                completion(error)
                return
            } else {
                completion(nil)
                return
            }
        })
    }
    
    func processSale(completion: @escaping ((Error?) -> Void)) {
        guard currentMerch.salePrice != initialMerch.salePrice else {
            completion(nil)
            return
        }
        EditKitsHelper.shared.processSale(initialKit: initialMerch,currentKit: currentMerch, completion: {[weak self] err in
            guard let strongSelf = self else {return}
            if let error = err {
                completion(error)
                return
            } else {
                completion(nil)
                return
            }
        })
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @objc func dismissKeyboard2() {
        setUpPage()
        view.endEditing(true)
    }
    
    @objc func dismissKeyboard3() {
        currentMerch.subcategory = newSubCat
        merchSubCategory.text = newSubCat
        merchSubCategory.textColor = .green
        view.endEditing(true)
    }
    
    @objc func dismissKeyboard4() {
        let id = "\(song.toneDeafAppId)Æ\(song.name)"
        if currentMerch.songs == nil {
            currentMerch.songs = [id]
            songsTableView.reloadData()
            songsHeightConstraint.constant = CGFloat(50*(currentMerch.songs!.count))
        } else {
            if !currentMerch.songs!.contains(id) {
                currentMerch.songs!.append(id)
                songsTableView.reloadData()
                songsHeightConstraint.constant = CGFloat(50*(currentMerch.songs!.count))
            }
        }
        view.endEditing(true)
    }
    
    @objc func dismissKeyboard5() {
        let id = "\(album.toneDeafAppId)Æ\(album.name)"
        if currentMerch.albums == nil {
            currentMerch.albums = [id]
            albumsTableView.reloadData()
            albumsHeightConstraint.constant = CGFloat(50*(currentMerch.albums!.count))
        } else {
            if !currentMerch.albums!.contains(id) {
                currentMerch.albums!.append(id)
                albumsTableView.reloadData()
                albumsHeightConstraint.constant = CGFloat(50*(currentMerch.albums!.count))
            }
        }
        view.endEditing(true)
    }
    
    @objc func dismissKeyboard6() {
        let id = "\(artist.toneDeafAppId)Æ\(artist.name!)"
        if currentMerch.artists == nil {
            currentMerch.artists = [id]
            artistsTableView.reloadData()
            artistsHeightConstraint.constant = CGFloat(50*(currentMerch.artists!.count))
        } else {
            if !currentMerch.artists!.contains(id) {
                currentMerch.artists!.append(id)
                artistsTableView.reloadData()
                artistsHeightConstraint.constant = CGFloat(50*(currentMerch.artists!.count))
            }
        }
        view.endEditing(true)
    }
    
    @objc func dismissKeyboard7() {
        let id = "\(producer.toneDeafAppId)Æ\(producer.name!)"
        if currentMerch.producers == nil {
            currentMerch.producers = [id]
            producersTableView.reloadData()
            producersHeightConstraint.constant = CGFloat(50*(currentMerch.producers!.count))
        } else {
            if !currentMerch.producers!.contains(id) {
                currentMerch.producers!.append(id)
                producersTableView.reloadData()
                producersHeightConstraint.constant = CGFloat(50*(currentMerch.producers!.count))
            }
        }
        view.endEditing(true)
    }
    
    @objc func dismissKeyboard8() {
        switch video {
        case is YouTubeData:
            let youtube = video as! YouTubeData
            let id = "\(youtube.toneDeafAppId)Æ\(youtube.title)"
            if currentMerch.videos == nil {
                currentMerch.videos = [id]
                producersTableView.reloadData()
                producersHeightConstraint.constant = CGFloat(50*(currentMerch.videos!.count))
            } else {
                if !currentMerch.videos!.contains(id) {
                    currentMerch.videos!.append(id)
                    videosTableView.reloadData()
                    videosHeightConstraint.constant = CGFloat(50*(currentMerch.videos!.count))
                }
            }
        default:
            print("hjhgfd")
        }
        view.endEditing(true)
    }
    
    @objc func dismissKeyboard9() {
        let id = "\(instrumental.toneDeafAppId)Æ\(instrumental.instrumentalName)"
        if currentMerch.instrumentals == nil {
            currentMerch.instrumentals = [id]
            instrumentalsTableView.reloadData()
            instrumentalsHeightConstraint.constant = CGFloat(50*(currentMerch.instrumentals!.count))
        } else {
            if !currentMerch.instrumentals!.contains(id) {
                currentMerch.instrumentals!.append(id)
                instrumentalsTableView.reloadData()
                instrumentalsHeightConstraint.constant = CGFloat(50*(currentMerch.instrumentals!.count))
            }
        }
        view.endEditing(true)
    }
    
    @objc func dismissKeyboard10() {
        let id = "\(beat.toneDeafAppId)Æ\(beat.name)"
        if currentMerch.beats == nil {
            currentMerch.beats = [id]
            beatsTableView.reloadData()
            beatsHeightConstraint.constant = CGFloat(50*(currentMerch.beats!.count))
        } else {
            if !currentMerch.beats!.contains(id) {
                currentMerch.beats!.append(id)
                beatsTableView.reloadData()
                beatsHeightConstraint.constant = CGFloat(50*(currentMerch.beats!.count))
            }
        }
        view.endEditing(true)
    }
    
    @objc func dismissKeyboard11() {
        merchSalePrice.text = "\(SalePercentage*100)%(\(salePrice!.dollarString))"
        merchSalePrice.textColor = .green
        currentMerch.salePrice = SalePercentage
        view.endEditing(true)
    }
}

extension EditKitsViewController : UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch tableView {
        case imagesTableView:
            return selectedImageArray.count
        case producersTableView:
            return currentMerch.producers?.count ?? 0
        case videosTableView:
            return currentMerch.videos?.count ?? 0
        case artistsTableView:
            return currentMerch.artists?.count ?? 0
        case songsTableView:
            return currentMerch.songs?.count ?? 0
        case albumsTableView:
            return currentMerch.albums?.count ?? 0
        case beatsTableView:
            return currentMerch.beats?.count ?? 0
        default:
            return currentMerch.instrumentals?.count ?? 0
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
        case artistsTableView:
            let cell = tableView.dequeueReusableCell(withIdentifier: "editBeatTypeCell", for: indexPath) as! EditBeatTypeTableCell
            if let arr = currentMerch.artists {
                cell.name.text = arr[indexPath.row]
            }
            return cell
        case producersTableView:
            let cell = tableView.dequeueReusableCell(withIdentifier: "editBeatTypeCell", for: indexPath) as! EditBeatTypeTableCell
            if let arr = currentMerch.producers {
                cell.name.text = arr[indexPath.row]
            }
            return cell
        case songsTableView:
            let cell = tableView.dequeueReusableCell(withIdentifier: "editBeatTypeCell", for: indexPath) as! EditBeatTypeTableCell
            if let arr = currentMerch.songs {
                cell.name.text = arr[indexPath.row]
            }
            return cell
        case albumsTableView:
            let cell = tableView.dequeueReusableCell(withIdentifier: "editBeatTypeCell", for: indexPath) as! EditBeatTypeTableCell
            if let arr = currentMerch.albums {
                cell.name.text = arr[indexPath.row]
            }
            return cell
        case videosTableView:
            let cell = tableView.dequeueReusableCell(withIdentifier: "editBeatTypeCell", for: indexPath) as! EditBeatTypeTableCell
            if let arr = currentMerch.videos {
                cell.name.text = arr[indexPath.row]
            }
            return cell
        case beatsTableView:
            let cell = tableView.dequeueReusableCell(withIdentifier: "editBeatTypeCell", for: indexPath) as! EditBeatTypeTableCell
            if let arr = currentMerch.beats {
                cell.name.text = arr[indexPath.row]
            }
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "editBeatTypeCell", for: indexPath) as! EditBeatTypeTableCell
            if let arr = currentMerch.instrumentals {
                cell.name.text = arr[indexPath.row]
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            switch tableView {
            case imagesTableView:
                selectedImageArray.remove(at: (indexPath).row)
                imagesTableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.fade)
                imagesHeightConstraint.constant = CGFloat(60*(selectedImageArray.count))
                imagesTableView.reloadData()
                view.layoutSubviews()
            case artistsTableView:
                currentMerch.artists!.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
                artistsHeightConstraint.constant = CGFloat(50*(currentMerch.artists!.count))
            case producersTableView:
                currentMerch.producers!.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
                producersHeightConstraint.constant = CGFloat(50*(currentMerch.producers!.count))
            case songsTableView:
                currentMerch.songs!.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
                songsHeightConstraint.constant = CGFloat(50*(currentMerch.songs!.count))
            case videosTableView:
                currentMerch.videos!.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
                videosHeightConstraint.constant = CGFloat(50*(currentMerch.videos!.count))
            case albumsTableView:
                currentMerch.albums!.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
                albumsHeightConstraint.constant = CGFloat(50*(currentMerch.albums!.count))
            case beatsTableView:
                currentMerch.beats!.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
                beatsHeightConstraint.constant = CGFloat(50*(currentMerch.beats!.count))
            default:
                currentMerch.instrumentals!.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
                instrumentalsHeightConstraint.constant = CGFloat(50*(currentMerch.instrumentals!.count))
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
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
        return true
    }

    func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        return false
    }
}

extension EditKitsViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        var nor = 0
        if pickerView == kitPickerView {
           nor = AllKitsInDatabaseArray.count
        } else if pickerView == merchSubCategoryPickerView {
            nor = subcategories.count
        } else if pickerView == merchArtistsPickerView {
            nor = AllArtistInDatabaseArray.count
        } else if pickerView == merchSongsPickerView {
            nor = AllSongsInDatabaseArray.count
        } else if pickerView == merchVideosPickerView {
            nor = AllVideosInDatabaseArray.count
        } else if pickerView == merchAlbumsPickerView {
            nor = AllAlbumsInDatabaseArray.count
        } else if pickerView == merchInstrumentalsPickerView {
            nor = AllInstrumentalsInDatabaseArray.count
        } else if pickerView == merchBeatsPickerView {
            nor = AllBeatsInDatabaseArray.count
        } else if pickerView == merchProducersPickerView {
            nor = AllProducersInDatabaseArray.count
        } else if pickerView == merchSalePricePickerView {
            nor = percents.count
        }
        return nor
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        var nor = ""
        if pickerView == kitPickerView {
            nor = "\(AllKitsInDatabaseArray[row].name ) -- \(AllKitsInDatabaseArray[row].tDAppId)"
        } else if pickerView == merchSubCategoryPickerView {
            nor = subcategories[row]
        } else if pickerView == merchArtistsPickerView {
            nor = "\(AllArtistInDatabaseArray[row].name ?? "artist") -- \(AllArtistInDatabaseArray[row].toneDeafAppId)"
        } else if pickerView == merchSongsPickerView {
            nor = "\(AllSongsInDatabaseArray[row].name ) -- \(AllSongsInDatabaseArray[row].toneDeafAppId)"
        } else if pickerView == merchVideosPickerView {
            switch AllVideosInDatabaseArray[row] {
            case is YouTubeData:
                let youtube = AllVideosInDatabaseArray[row] as! YouTubeData
                nor = "\(youtube.title) -- \(youtube.toneDeafAppId)"
            default:
                print("dsgjroiushgjvsd")
            }
        } else if pickerView == merchAlbumsPickerView {
            nor = "\(AllAlbumsInDatabaseArray[row].name ) -- \(AllAlbumsInDatabaseArray[row].toneDeafAppId)"
        }
        else if pickerView == merchInstrumentalsPickerView {
            nor = "\(AllInstrumentalsInDatabaseArray[row].instrumentalName ) -- \(AllInstrumentalsInDatabaseArray[row].toneDeafAppId)"
        } else if pickerView == merchBeatsPickerView {
            nor = "\(AllBeatsInDatabaseArray[row].name ) -- \(AllBeatsInDatabaseArray[row].toneDeafAppId)"
        } else if pickerView == merchProducersPickerView {
            nor = "\(AllProducersInDatabaseArray[row].name ?? "artist") -- \(AllProducersInDatabaseArray[row].toneDeafAppId)"
        } else if pickerView == merchSalePricePickerView {
            let percent = percents[row]
            let percentage = Double(Double(percent)/100)
            let sale = (percentage*currentMerch.retailPrice)
            nor = "\(percent)% - \(sale.dollarString)"
        }
        return nor
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == kitPickerView {
            currentMerch = AllKitsInDatabaseArray[row]
            let b = AllKitsInDatabaseArray[row]
            initialMerch.name = b.name
            initialMerch.description = b.description
            initialMerch.tDAppId = b.tDAppId
            initialMerch.producers = b.producers
            initialMerch.date = b.date
            initialMerch.videos = b.videos
            initialMerch.fileURL = b.fileURL
            initialMerch.imageURLs = b.imageURLs
            initialMerch.merchType = b.merchType
            initialMerch.quantity = b.quantity
            initialMerch.numberOfPurchases = b.numberOfPurchases
            initialMerch.numberOfFavorites = b.numberOfFavorites
            initialMerch.previewURL = b.previewURL
            initialMerch.retailPrice = b.retailPrice
            initialMerch.salePrice = b.salePrice
            initialMerch.subcategory = b.subcategory
            initialMerch.artists = b.artists
            initialMerch.songs = b.songs
            initialMerch.albums = b.albums
            initialMerch.instrumentals = b.instrumentals
            initialMerch.beats = b.beats
        } else if pickerView == merchSubCategoryPickerView {
            newSubCat = subcategories[row]
        } else if pickerView == merchSongsPickerView {
            song = AllSongsInDatabaseArray[row]
        } else if pickerView == merchAlbumsPickerView {
            album = AllAlbumsInDatabaseArray[row]
        } else if pickerView == merchVideosPickerView {
            video = AllVideosInDatabaseArray[row]
        } else if pickerView == merchBeatsPickerView {
            beat = AllBeatsInDatabaseArray[row]
        } else if pickerView == merchInstrumentalsPickerView {
            instrumental = AllInstrumentalsInDatabaseArray[row]
        } else if pickerView == merchProducersPickerView {
            producer = AllProducersInDatabaseArray[row]
        } else if pickerView == merchArtistsPickerView {
            artist = AllArtistInDatabaseArray[row]
        } else if pickerView == merchSalePricePickerView {
            let percent = percents[row]
            let percentage = Double(Double(percent)/100)
            let sale = percentage*currentMerch.retailPrice
            salePrice = sale
            SalePercentage = percentage
        }
    }
    
    func pickerViewToolbar(textField:UITextField, pickerView:UIPickerView) {
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor.init(red: 182/255, green: 0/255, blue: 3/255, alpha: 1)
        toolBar.sizeToFit()

        var doneButton = UIBarButtonItem()
        if pickerView == kitPickerView {
           doneButton = UIBarButtonItem(title: "Select", style: UIBarButtonItem.Style.done, target: self, action: #selector(dismissKeyboard2))
        }
        if pickerView == merchSubCategoryPickerView {
           doneButton = UIBarButtonItem(title: "Select", style: UIBarButtonItem.Style.done, target: self, action: #selector(dismissKeyboard3))
        }
        if pickerView == merchSongsPickerView {
           doneButton = UIBarButtonItem(title: "Select", style: UIBarButtonItem.Style.done, target: self, action: #selector(dismissKeyboard4))
        }
        if pickerView == merchAlbumsPickerView {
           doneButton = UIBarButtonItem(title: "Select", style: UIBarButtonItem.Style.done, target: self, action: #selector(dismissKeyboard5))
        }
        if pickerView == merchArtistsPickerView {
           doneButton = UIBarButtonItem(title: "Select", style: UIBarButtonItem.Style.done, target: self, action: #selector(dismissKeyboard6))
        }
        if pickerView == merchProducersPickerView {
           doneButton = UIBarButtonItem(title: "Select", style: UIBarButtonItem.Style.done, target: self, action: #selector(dismissKeyboard7))
        }
        if pickerView == merchVideosPickerView {
           doneButton = UIBarButtonItem(title: "Select", style: UIBarButtonItem.Style.done, target: self, action: #selector(dismissKeyboard8))
        }
        if pickerView == merchInstrumentalsPickerView {
           doneButton = UIBarButtonItem(title: "Select", style: UIBarButtonItem.Style.done, target: self, action: #selector(dismissKeyboard9))
        }
        if pickerView == merchBeatsPickerView {
           doneButton = UIBarButtonItem(title: "Select", style: UIBarButtonItem.Style.done, target: self, action: #selector(dismissKeyboard10))
        }
        if pickerView == merchSalePricePickerView {
           doneButton = UIBarButtonItem(title: "Select", style: UIBarButtonItem.Style.done, target: self, action: #selector(dismissKeyboard11))
        }
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItem.Style.plain, target: self, action: #selector(dismissKeyboard))

        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true

        textField.inputView = pickerView
        textField.inputAccessoryView = toolBar
    }
}

extension EditKitsViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
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
        
        merchImage.image = selectedImage
        merchImageURL.text = "New Image Selected"
        merchImageURL.textColor = .green
        selectedImageArray.append(selectedImage)
        imagesTableView.reloadData()
        imagesHeightConstraint.constant = CGFloat(50*(selectedImageArray.count))
        view.layoutSubviews()
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
}

