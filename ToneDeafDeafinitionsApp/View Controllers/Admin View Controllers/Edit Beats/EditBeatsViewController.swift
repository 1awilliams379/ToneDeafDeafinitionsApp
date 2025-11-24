//
//  EditBeatsViewController.swift
//  ToneDeafDeafinitionsApp
//
//  Created by Tone Deaf on 10/16/20.
//  Copyright © 2020 GITEM Solutions. All rights reserved.
//

import UIKit
import MobileCoreServices

class EditBeatsViewController: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var beatTypesTableView: UITableView!
    @IBOutlet weak var beatSoundsTableView: UITableView!
    @IBOutlet weak var beatProducersTableView: UITableView!
    @IBOutlet weak var beatVideosTableView: UITableView!
    
    @IBOutlet weak var typesHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var soundsHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var producersHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var videosHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var beatImage: UIImageView!
    @IBOutlet weak var beatName: UILabel!
    @IBOutlet weak var beatAudioURL: UILabel!
    @IBOutlet weak var beatImageURL: UILabel!
    @IBOutlet weak var beatTempo: UILabel!
    @IBOutlet weak var beatKey: UILabel!
    @IBOutlet weak var beatSoundcloudAudioURL: UILabel!
    @IBOutlet weak var beatSoundcloudImageURL: UILabel!
    @IBOutlet weak var beatSoundcloudDate: UILabel!
    @IBOutlet weak var beatYoutube: UILabel!
    @IBOutlet weak var beatPrice: UISegmentedControl!
    @IBOutlet weak var beatMP3Price: UILabel!
    @IBOutlet weak var beatWavPrice: UILabel!
    @IBOutlet weak var beatExclusivePrice: UILabel!
    @IBOutlet weak var beatWavURL: UILabel!
    @IBOutlet weak var beatExclusiveURL: UILabel!
    
    let keys = Constants.Beats.keys
    var types = Constants.Beats.types
    var sounds = Constants.Beats.sounds
    let tempo: [Int] = Array(50...200)
    var beatKeyPickerView = UIPickerView()
    var beatTempoPickerView = UIPickerView()
    var beatPickerView = UIPickerView()
    var beatTypesPickerView = UIPickerView()
    var beatSoundsPickerView = UIPickerView()
    var beatProducersPickerView = UIPickerView()
    var beatSoundcloudDatePickerView = UIDatePicker()
    
    var currentBeat:BeatData!
    let initialBeat = BeatData(duration: "", name: "", toneDeafAppId: "", producers: [""], date: "", downloads: 0, mp3Price: 0.0, wavPrice: 0.0, exclusivePrice: 0.0, time: "", tempo: 0, datetime: "", audioURL: "", imageURL: "", beatID: "", priceType: "", types: [], sounds: [], exclusiveFilesURL: nil, wavURL: nil, officialVideo: nil, videos: [], soundcloud: nil, key: "", merch: nil, isActive: nil)
    
    let hiddenBeatTextField =  UITextField(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    let hiddenTempoTextField =  UITextField(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    let hiddenKeyTextField =  UITextField(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    let hiddenTypesTextField =  UITextField(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    let hiddenSoundsTextField =  UITextField(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    let hiddenProducersTextField =  UITextField(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    let hiddenSoundcloudDateTextField =  UITextField(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    
    var newImage:UIImage!
    var currentFileType = ""
    var newAudio:URL!
    var newKey:String!
    var newTempo:Int!
    var btype:String!
    var sound:String!
    var producer:ProducerData!
    var newWav:URL!
    var newExclusive:URL!
    var arr = ""
    var ogPrice = ""
    var newPrice:String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createObservers()
        DatabaseManager.shared.fetchAllBeatsFromDatabase(completion: { allbeats in
            AllBeatsInDatabaseArray = allbeats
        })
        if AllPersonsInDatabaseArray == nil {
            DatabaseManager.shared.fetchAllPersonsFromDatabase(completion: { allpros in
                AllPersonsInDatabaseArray = allpros
            })
        }
        setUpElements()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        hiddenBeatTextField.becomeFirstResponder()
    }
    
    func createObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(addVideo(notification:)), name: EditBeatVideoSelectedNotify, object: nil)
    }
    
    deinit {
        print("📗 Edit Beat view controller deinitialized.")
        NotificationCenter.default.removeObserver(self)
    }
    
    func setUpElements() {
        sounds.sort()
        types.sort()
        view.addSubview(hiddenBeatTextField)
        hiddenBeatTextField.isHidden = true
        hiddenBeatTextField.inputView = beatPickerView
        beatPickerView.delegate = self
        beatPickerView.dataSource = self
        pickerViewToolbar(textField: hiddenBeatTextField, pickerView: beatPickerView)
        view.addSubview(hiddenTempoTextField)
        hiddenBeatTextField.delegate = self
        hiddenTempoTextField.isHidden = true
        hiddenTempoTextField.inputView = beatTempoPickerView
        beatTempoPickerView.delegate = self
        beatTempoPickerView.dataSource = self
        pickerViewToolbar(textField: hiddenTempoTextField, pickerView: beatTempoPickerView)
        view.addSubview(hiddenKeyTextField)
        hiddenKeyTextField.isHidden = true
        hiddenKeyTextField.inputView = beatTempoPickerView
        beatKeyPickerView.delegate = self
        beatKeyPickerView.dataSource = self
        pickerViewToolbar(textField: hiddenKeyTextField, pickerView: beatKeyPickerView)
        view.addSubview(hiddenTypesTextField)
        hiddenTypesTextField.isHidden = true
        hiddenTypesTextField.inputView = beatTypesPickerView
        beatTypesPickerView.delegate = self
        beatTypesPickerView.dataSource = self
        pickerViewToolbar(textField: hiddenTypesTextField, pickerView: beatTypesPickerView)
        view.addSubview(hiddenSoundsTextField)
        hiddenSoundsTextField.isHidden = true
        hiddenSoundsTextField.inputView = beatSoundsPickerView
        beatSoundsPickerView.delegate = self
        beatSoundsPickerView.dataSource = self
        pickerViewToolbar(textField: hiddenSoundsTextField, pickerView: beatSoundsPickerView)
        view.addSubview(hiddenProducersTextField)
        hiddenProducersTextField.isHidden = true
        hiddenProducersTextField.inputView = beatProducersPickerView
        beatProducersPickerView.delegate = self
        beatProducersPickerView.dataSource = self
        pickerViewToolbar(textField: hiddenProducersTextField, pickerView: beatProducersPickerView)
        view.addSubview(hiddenSoundcloudDateTextField)
        hiddenSoundcloudDateTextField.isHidden = true
        hiddenSoundcloudDateTextField.inputView = beatSoundcloudDatePickerView
        beatSoundcloudDatePickerView.timeZone = NSTimeZone.system
        beatSoundcloudDatePickerView.addTarget(self, action: #selector(datePickerValueChanged(_:)), for: .valueChanged)
    }
    
    func setUpPage() {
        beatTypesTableView.delegate = self
        beatTypesTableView.dataSource = self
        beatTypesTableView.reloadData()
        typesHeightConstraint.constant = CGFloat(50*(currentBeat.types.count))
        beatSoundsTableView.delegate = self
        beatSoundsTableView.dataSource = self
        beatSoundsTableView.reloadData()
        soundsHeightConstraint.constant = CGFloat(50*(currentBeat.sounds.count))
        beatProducersTableView.delegate = self
        beatProducersTableView.dataSource = self
        beatProducersTableView.reloadData()
        producersHeightConstraint.constant = CGFloat(50*(currentBeat.producers.count))
        beatVideosTableView.delegate = self
        beatVideosTableView.dataSource = self
        beatVideosTableView.reloadData()
        videosHeightConstraint.constant = CGFloat(50*(currentBeat.videos.count))
        beatName.text = currentBeat.name
        beatAudioURL.text = currentBeat.audioURL
        beatImageURL.text = currentBeat.imageURL
        beatTempo.text = String(currentBeat.tempo)
        beatKey.text = currentBeat.key
        beatSoundcloudAudioURL.text = currentBeat.soundcloud?.url
        beatSoundcloudImageURL.text = currentBeat.soundcloud?.imageurl
        beatSoundcloudDate.text = currentBeat.soundcloud?.releaseDate
        switch currentBeat.priceType {
        case "Free":
            beatMP3Price.text = "Mp3 FREE"
            beatPrice.selectedSegmentIndex = 0
        default:
            beatMP3Price.text = "Mp3 \(currentBeat.mp3Price?.dollarString)"
            beatPrice.selectedSegmentIndex = 1
        }
        beatYoutube.text = currentBeat.officialVideo
        beatWavPrice.text = "Wav: \(currentBeat.wavPrice?.dollarString)"
        beatExclusivePrice.text = "Exclusive: \(currentBeat.exclusivePrice?.dollarString)"
        beatWavURL.text = currentBeat.wavURL
        beatExclusiveURL.text = currentBeat.exclusiveFilesURL
        let imageURL = URL(string: currentBeat.imageURL)!
        if let cachedImage = imageCache.object(forKey: imageURL.absoluteString as NSString) {
            beatImage.image = cachedImage
        } else {
            beatImage.setImage(from: imageURL, withPlaceholder: UIImage(named: "tonedeaflogo"))
        }
    }
    
    @objc func addVideo(notification: Notification) {
        let vid = (notification.object as AnyObject)
        switch vid {
        case is YouTubeData:
            let youtube = vid as! YouTubeData
            let id = "\(youtube.toneDeafAppId)Æ\(youtube.title)"
            currentBeat.videos.append(id)
            beatVideosTableView.reloadData()
            videosHeightConstraint.constant = CGFloat(50*(currentBeat.videos.count))
        default:
            print("jgh")
        }
    }
    
    @objc func datePickerValueChanged(_ sender: UIDatePicker){
        let dateFormatter: DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM dd, yyyy"
        let selectedDate: String = dateFormatter.string(from: sender.date)
        currentBeat.soundcloud?.releaseDate = selectedDate
        beatSoundcloudDate.text = selectedDate
        beatSoundcloudDate.textColor = .green
        view.endEditing(true)
    }
    
    func openPriceController(mp3: String) {
        let alertC = UIAlertController(title: "Change Mp3 Lease Price",
                                                message: "Please type in a price.",
                                                preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Mp3 Lease", style: .default, handler: {[weak self] _ in
            guard let strongSelf = self else {return}
            let field = alertC.textFields![0]
            if field.text != "" {
                guard let name = field.text else {return}
                strongSelf.currentBeat.mp3Price = Double(name)
                strongSelf.beatMP3Price.textColor = .green
                strongSelf.beatMP3Price.text = name
                alertC.dismiss(animated: true, completion: nil)
            } else {
                alertC.dismiss(animated: true, completion: nil)
            }
        })
        alertC.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alertC.addAction(okAction)
        alertC.addTextField()
        alertC.view.tintColor = Constants.Colors.redApp
        self.present(alertC, animated: true)
    }
    func openPriceController(wav: String) {
        let alertC = UIAlertController(title: "Change Wav Lease Price",
                                                message: "Please type in a price.",
                                                preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Wav Lease", style: .default, handler: {[weak self] _ in
            guard let strongSelf = self else {return}
            let field = alertC.textFields![0]
            if field.text != "" {
                guard let name = field.text else {return}
                strongSelf.currentBeat.wavPrice = Double(name)
                strongSelf.beatWavPrice.textColor = .green
                strongSelf.beatWavPrice.text = name
                alertC.dismiss(animated: true, completion: nil)
            } else {
                alertC.dismiss(animated: true, completion: nil)
            }
        })
        alertC.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alertC.addAction(okAction)
        alertC.addTextField()
        alertC.view.tintColor = Constants.Colors.redApp
        self.present(alertC, animated: true)
    }
    func openPriceController(exclusive: String) {
        let alertC = UIAlertController(title: "Change Exclusive Liscene Price",
                                                message: "Please type in a price.",
                                                preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Exclusive Liscene", style: .default, handler: {[weak self] _ in
            guard let strongSelf = self else {return}
            let field = alertC.textFields![0]
            if field.text != "" {
                guard let name = field.text else {return}
                strongSelf.currentBeat.exclusivePrice = Double(name)
                strongSelf.beatExclusivePrice.textColor = .green
                strongSelf.beatExclusivePrice.text = name
                alertC.dismiss(animated: true, completion: nil)
            } else {
                alertC.dismiss(animated: true, completion: nil)
            }
        })
        alertC.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alertC.addAction(okAction)
        alertC.addTextField()
        alertC.view.tintColor = Constants.Colors.redApp
        self.present(alertC, animated: true)
    }
    func openSCController(url: String) {
        let alertC = UIAlertController(title: "Change Soundcloud URL",
                                                message: "Please type in a url.",
                                                preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Change", style: .default, handler: {[weak self] _ in
            guard let strongSelf = self else {return}
            let field = alertC.textFields![0]
            if field.text != "" {
                guard let name = field.text else {return}
                if strongSelf.currentBeat.soundcloud != nil {
                    guard let SC = strongSelf.currentBeat.soundcloud else {return}
                    SC.url = name
                } else {
                    let SC = SoundcloudSongData(url: name, imageurl: nil, releaseDate: nil, isActive: false)
                    strongSelf.currentBeat.soundcloud = SC
                }
                strongSelf.beatSoundcloudAudioURL.textColor = .green
                strongSelf.beatSoundcloudAudioURL.text = name
                alertC.dismiss(animated: true, completion: nil)
            } else {
                alertC.dismiss(animated: true, completion: nil)
            }
        })
        alertC.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alertC.addAction(okAction)
        alertC.addTextField()
        alertC.view.tintColor = Constants.Colors.redApp
        self.present(alertC, animated: true)
    }
    func openSCController(imageurl: String) {
        let alertC = UIAlertController(title: "Change Soundcloud URL",
                                                message: "Please type in a url.",
                                                preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Change", style: .default, handler: {[weak self] _ in
            guard let strongSelf = self else {return}
            let field = alertC.textFields![0]
            if field.text != "" {
                guard let name = field.text else {return}
                if strongSelf.currentBeat.soundcloud != nil {
                    guard let SC = strongSelf.currentBeat.soundcloud else {return}
                    SC.imageurl = name
                } else {
                    return
                }
                strongSelf.beatSoundcloudImageURL.textColor = .green
                strongSelf.beatSoundcloudImageURL.text = name
                alertC.dismiss(animated: true, completion: nil)
            } else {
                alertC.dismiss(animated: true, completion: nil)
            }
        })
        alertC.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alertC.addAction(okAction)
        alertC.addTextField()
        alertC.view.tintColor = Constants.Colors.redApp
        self.present(alertC, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "editbeattotonespicksegue" {
            if let viewController: SelectTonesPickItemViewController = segue.destination as? SelectTonesPickItemViewController {
                viewController.array = arr
            }
        }
    }
    
    @IBAction func changeImageTapped(_ sender: Any) {
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
                strongSelf.beatName.text = name
                strongSelf.beatName.textColor = .green
                strongSelf.currentBeat.name = name
                strongSelf.currentBeat.beatID = "\(name)--\(strongSelf.currentBeat.date)--\(strongSelf.currentBeat.time)--\(strongSelf.currentBeat.toneDeafAppId)"
                alertC.dismiss(animated: true, completion: nil)
            } else {
                alertC.dismiss(animated: true, completion: nil)
            }
        })
        alertC.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alertC.addAction(okAction)
        alertC.addTextField()
        alertC.view.tintColor = Constants.Colors.redApp
        self.present(alertC, animated: true)
    }
    
    @IBAction func changeAudioTapped(_ sender: Any) {
        openFiles(type: "mp3")
    }
    
    @IBAction func changeTempoTapped(_ sender: Any) {
        hiddenTempoTextField.becomeFirstResponder()
    }
    
    @IBAction func changeKeyTapped(_ sender: Any) {
        hiddenKeyTextField.becomeFirstResponder()
    }
    
    @IBAction func addTypesTapped(_ sender: Any) {
        hiddenTypesTextField.becomeFirstResponder()
    }
    
    @IBAction func addSoundsTapped(_ sender: Any) {
        hiddenSoundsTextField.becomeFirstResponder()
    }
    
    @IBAction func addProducersTapped(_ sender: Any) {
        hiddenProducersTextField.becomeFirstResponder()
    }
    
    @IBAction func addVideosTapped(_ sender: Any) {
        arr = "editbeatvideo"
        performSegue(withIdentifier: "editbeattotonespicksegue", sender: sender)
    }
    
    @IBAction func changeSoundcloudTapped(_ sender: Any) {
        let alertC = UIAlertController(title: "Change Soundclod Data",
                                                message: "Select a data type to change.",
                                                preferredStyle: .alert)
        let mp3Action = UIAlertAction(title: "Url", style: .default, handler: {[weak self] _ in
            guard let strongSelf = self else {return}
            strongSelf.openSCController(url: "hkjhfcg")
                alertC.dismiss(animated: true, completion: nil)
        })
        let wavAction = UIAlertAction(title: "Image URL", style: .default, handler: {[weak self] _ in
            guard let strongSelf = self else {return}
            strongSelf.openSCController(imageurl: "hkjhfcg")
                alertC.dismiss(animated: true, completion: nil)
        })
        let exAction = UIAlertAction(title: "Release Date", style: .default, handler: {[weak self] _ in
            guard let strongSelf = self else {return}
            strongSelf.hiddenSoundcloudDateTextField.becomeFirstResponder()
                alertC.dismiss(animated: true, completion: nil)
        })
        alertC.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alertC.addAction(mp3Action)
        if currentBeat.soundcloud != nil {
            alertC.addAction(wavAction)
            alertC.addAction(exAction)
        }
        alertC.view.tintColor = Constants.Colors.redApp
        self.present(alertC, animated: true)
    }
    
    @IBAction func changeYoutubeTapped(_ sender: Any) {
        let alertC = UIAlertController(title: "Change URL",
                                                message: "Please type in a Youtube URL.",
                                                preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Change", style: .default, handler: {[weak self] _ in
            guard let strongSelf = self else {return}
            let field = alertC.textFields![0]
            if field.text != "" {
                guard let youtube = field.text else {return}
                strongSelf.beatYoutube.text = youtube
                strongSelf.beatYoutube.textColor = .green
                strongSelf.currentBeat.officialVideo = youtube
                alertC.dismiss(animated: true, completion: nil)
            } else {
                alertC.dismiss(animated: true, completion: nil)
            }
        })
        alertC.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alertC.addAction(okAction)
        alertC.addTextField()
        alertC.view.tintColor = Constants.Colors.redApp
        self.present(alertC, animated: true)
    }
    
    @IBAction func typeOfPriceChanged(_ sender: UISegmentedControl) {
        print(sender.selectedSegmentIndex)
        print(currentBeat.priceType, initialBeat.priceType)
        if sender.selectedSegmentIndex == 0 {
            currentBeat.priceType = "Free"
        } else {
            currentBeat.priceType = "Paid"
        }
    }
    
    @IBAction func changePricesTapped(_ sender: Any) {
        let alertC = UIAlertController(title: "Change Prices",
                                                message: "Seclect a price to change.",
                                                preferredStyle: .alert)
        let mp3Action = UIAlertAction(title: "Mp3 Lease", style: .default, handler: {[weak self] _ in
            guard let strongSelf = self else {return}
            strongSelf.openPriceController(mp3: "hkjhfcg")
                alertC.dismiss(animated: true, completion: nil)
        })
        let wavAction = UIAlertAction(title: "Wav Lease", style: .default, handler: {[weak self] _ in
            guard let strongSelf = self else {return}
            strongSelf.openPriceController(wav: "hkjhfcg")
                alertC.dismiss(animated: true, completion: nil)
        })
        let exAction = UIAlertAction(title: "Exclusive License", style: .default, handler: {[weak self] _ in
            guard let strongSelf = self else {return}
            strongSelf.openPriceController(exclusive: "hkjhfcg")
                alertC.dismiss(animated: true, completion: nil)
        })
        alertC.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        if beatPrice.selectedSegmentIndex != 0 {
            alertC.addAction(mp3Action)
        }
        alertC.addAction(wavAction)
        alertC.addAction(exAction)
        alertC.view.tintColor = Constants.Colors.redApp
        self.present(alertC, animated: true)
    }
    
    @IBAction func changeWavURL(_ sender: Any) {
        openFiles(type: "wav")
    }
    
    @IBAction func chaneExclusiveURLTapped(_ sender: Any) {
        openFiles(type: "exclusive")
    }
    
    @IBAction func updateTapped(_ sender: Any) {
        if currentBeat.priceType == "Paid" && currentBeat.mp3Price == nil && currentBeat.wavPrice == nil && currentBeat.exclusivePrice == nil {
            Utilities.showError2("Can not be Paid beat with no price set.", actionText: "OK")
            return
        }
        let progressHUD = ProgressHUD(text: "Updating...")
        self.view.addSubview(progressHUD)
        EditBeatsHelper.shared.update(currentBeat: currentBeat, initialBeat: initialBeat, newimage: newImage, newAudio: newAudio, newWav: newWav, newExclusive: newExclusive, completion: {[weak self] updateerror in
            guard let strongSelf = self else {return}
            progressHUD.stopAnimation()
            progressHUD.removeFromSuperview()
            if let error = updateerror {
                Utilities.showError2("Update Failed. \(error)", actionText: "OK")
                return
            } else {
                print("📗 Beat data updated in database successfully.")
                Utilities.successBarBanner("Update successful.")
                _ = strongSelf.navigationController?.popViewController(animated: true)
            }
        })
        //If newImage != nil, upload newImage to Database and update beat
        //Update Beat name to currentBeat Name in database
        //If newAudio != nil, upload newAudio to Database and update beat
        //Update Beat key to currentBeat key in database
        //Update Beat tempo to currentBeat tempo in database
        //If currentBeat.types != initialBeat.types, Update in database.
        //If currentBeat.sounds != initialBeat.sounds, Update in database.
        //If currentBeat.producers != initialBeat.producers, Update in database.
        //If currentBeat.soundcloud.releaseDate != initialBeat.soundcloud.releaseDate, Update in database.
        //If currentBeat.youtube != initialBeat.youtube,Graph youtube request and Update in database.
        //If currentBeat.mp3 != initialBeat.mp3, Update in database.
        //If currentBeat.wav != initialBeat.wav, Update in database.
        //If currentBeat.ex != initialBeat.ex, Update in database.
        //If currentBeat.priceType != initialBeat.priceType, Update in database.
        //If newWav != nil, upload newWav to Database and update beat
        //If newExclusive != nil, upload newExclusive to Database and update beat
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @objc func dismissKeyboard2() {
        setUpPage()
        view.endEditing(true)
    }
    
    @objc func dismissKeyboard3() {
        currentBeat.key = newKey
        beatKey.text = newKey
        beatKey.textColor = .green
        view.endEditing(true)
    }
    
    @objc func dismissKeyboard4() {
        currentBeat.tempo = newTempo
        beatTempo.text = String(newTempo)
        beatTempo.textColor = .green
        view.endEditing(true)
    }
    
    @objc func dismissKeyboard5() {
        if !currentBeat.types.contains(btype) {
            currentBeat.types.append(btype)
            beatTypesTableView.reloadData()
            typesHeightConstraint.constant = CGFloat(50*(currentBeat.types.count))
        }
        view.endEditing(true)
    }
    
    @objc func dismissKeyboard6() {
        if !currentBeat.sounds.contains(sound) {
            currentBeat.sounds.append(sound)
            beatSoundsTableView.reloadData()
            soundsHeightConstraint.constant = CGFloat(50*(currentBeat.sounds.count))
        }
        view.endEditing(true)
    }
    
    @objc func dismissKeyboard7() {
        let id = "\(producer.toneDeafAppId)Æ\(producer.name!)"
        if !currentBeat.producers.contains(id) {
            currentBeat.producers.append(id)
            beatProducersTableView.reloadData()
            producersHeightConstraint.constant = CGFloat(50*(currentBeat.producers.count))
        }
        view.endEditing(true)
    }
    
}

extension EditBeatsViewController : UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch tableView {
        case beatTypesTableView:
            return currentBeat.types.count
        case beatProducersTableView:
            return currentBeat.producers.count
        case beatVideosTableView:
            return currentBeat.videos.count
        default:
            return currentBeat.sounds.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch tableView {
        case beatTypesTableView:
            let cell = tableView.dequeueReusableCell(withIdentifier: "editBeatTypeCell", for: indexPath) as! EditBeatTypeTableCell
            cell.name.text = currentBeat.types[indexPath.row]
            return cell
        case beatProducersTableView:
            let cell = tableView.dequeueReusableCell(withIdentifier: "editBeatTypeCell", for: indexPath) as! EditBeatTypeTableCell
            cell.name.text = currentBeat.producers[indexPath.row]
            return cell
        case beatVideosTableView:
            let cell = tableView.dequeueReusableCell(withIdentifier: "editBeatTypeCell", for: indexPath) as! EditBeatTypeTableCell
            cell.name.text = currentBeat.videos[indexPath.row]
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "editBeatTypeCell", for: indexPath) as! EditBeatTypeTableCell
            cell.name.text = currentBeat.sounds[indexPath.row]
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            switch tableView {
            case beatTypesTableView:
                currentBeat.types.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
                typesHeightConstraint.constant = CGFloat(50*(currentBeat.types.count))
            case beatProducersTableView:
                currentBeat.producers.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
                producersHeightConstraint.constant = CGFloat(50*(currentBeat.producers.count))
            case beatVideosTableView:
                currentBeat.videos.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
                videosHeightConstraint.constant = CGFloat(50*(currentBeat.videos.count))
            default:
                currentBeat.sounds.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
                soundsHeightConstraint.constant = CGFloat(50*(currentBeat.sounds.count))
            }
        }
    }
    
    
}

extension EditBeatsViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        var nor = 0
        if pickerView == beatPickerView {
           nor = AllBeatsInDatabaseArray.count
        } else if pickerView == beatKeyPickerView {
            nor = keys.count
        } else if pickerView == beatTempoPickerView {
            nor = tempo.count
        } else if pickerView == beatTypesPickerView {
            nor = types.count
        } else if pickerView == beatSoundsPickerView {
            nor = sounds.count
        } else if pickerView == beatProducersPickerView {
            nor = AllProducersInDatabaseArray.count
        }
        return nor
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        var nor = ""
        if pickerView == beatPickerView {
           nor = "\(AllBeatsInDatabaseArray[row].name ?? "artist") -- \(AllBeatsInDatabaseArray[row].toneDeafAppId)"
        } else if pickerView == beatKeyPickerView {
            nor = keys[row]
        } else if pickerView == beatTempoPickerView {
            nor = String(tempo[row])
        } else if pickerView == beatProducersPickerView {
            nor = "\(AllProducersInDatabaseArray[row].name ?? "artist") -- \(AllProducersInDatabaseArray[row].toneDeafAppId)"
         } else if pickerView == beatTypesPickerView {
             nor = types[row]
         } else if pickerView == beatSoundsPickerView {
             nor = sounds[row]
         }
        return nor
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == beatPickerView {
            currentBeat = AllBeatsInDatabaseArray[row]
            let b = AllBeatsInDatabaseArray[row]
            initialBeat.name = b.name
            initialBeat.duration = b.duration
            initialBeat.toneDeafAppId = b.toneDeafAppId
            initialBeat.producers = b.producers
            initialBeat.date = b.date
            initialBeat.downloads = b.downloads
            initialBeat.mp3Price = b.mp3Price
            initialBeat.wavPrice = b.wavPrice
            initialBeat.exclusivePrice = b.exclusivePrice
            initialBeat.time = b.time
            initialBeat.tempo = b.tempo
            initialBeat.datetime = b.datetime
            initialBeat.audioURL = b.audioURL
            initialBeat.imageURL = b.imageURL
            initialBeat.beatID = b.beatID
            initialBeat.priceType = b.priceType
            initialBeat.types = b.types
            initialBeat.sounds = b.sounds
            initialBeat.exclusiveFilesURL = b.exclusiveFilesURL
            initialBeat.wavURL = b.wavURL
            initialBeat.officialVideo = b.officialVideo
            initialBeat.videos = b.videos
            initialBeat.soundcloud = b.soundcloud
            initialBeat.key = b.key
            
            ogPrice = initialBeat.priceType
        } else if pickerView == beatKeyPickerView {
            newKey = keys[row]
        } else if pickerView == beatTempoPickerView {
            newTempo = tempo[row]
        } else if pickerView == beatTypesPickerView {
            btype = types[row]
        } else if pickerView == beatSoundsPickerView {
            sound = sounds[row]
        } else if pickerView == beatProducersPickerView {
            producer = AllProducersInDatabaseArray[row]
        }
    }
    
    func pickerViewToolbar(textField:UITextField, pickerView:UIPickerView) {
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor.init(red: 182/255, green: 0/255, blue: 3/255, alpha: 1)
        toolBar.sizeToFit()

        var doneButton = UIBarButtonItem()
        if pickerView == beatPickerView {
           doneButton = UIBarButtonItem(title: "Select", style: UIBarButtonItem.Style.done, target: self, action: #selector(dismissKeyboard2))
        }
        if pickerView == beatKeyPickerView {
           doneButton = UIBarButtonItem(title: "Select", style: UIBarButtonItem.Style.done, target: self, action: #selector(dismissKeyboard3))
        }
        if pickerView == beatTempoPickerView {
           doneButton = UIBarButtonItem(title: "Select", style: UIBarButtonItem.Style.done, target: self, action: #selector(dismissKeyboard4))
        }
        if pickerView == beatTypesPickerView {
           doneButton = UIBarButtonItem(title: "Select", style: UIBarButtonItem.Style.done, target: self, action: #selector(dismissKeyboard5))
        }
        if pickerView == beatSoundsPickerView {
           doneButton = UIBarButtonItem(title: "Select", style: UIBarButtonItem.Style.done, target: self, action: #selector(dismissKeyboard6))
        }
        if pickerView == beatProducersPickerView {
           doneButton = UIBarButtonItem(title: "Select", style: UIBarButtonItem.Style.done, target: self, action: #selector(dismissKeyboard7))
        }
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItem.Style.plain, target: self, action: #selector(dismissKeyboard))
        if currentBeat == nil {
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

class EditBeatTypeTableCell: UITableViewCell {
    
    @IBOutlet weak var name: UILabel!
    
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        
    }
}

extension EditBeatsViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
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
        
        beatImage.image = selectedImage
        beatImageURL.text = "New Image Selected"
        beatImageURL.textColor = .green
        newImage = selectedImage
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
}

extension EditBeatsViewController: UIDocumentPickerDelegate {
    
    func openFiles(type: String) {
        let documentPicker:UIDocumentPickerViewController!
        currentFileType = type
        switch type {
        case "mp3":
            documentPicker = UIDocumentPickerViewController(documentTypes: [kUTTypeMP3 as String], in: .import)
        case "wav":
            documentPicker = UIDocumentPickerViewController(documentTypes: [kUTTypeWaveformAudio as String], in: .import)
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
        case "wav":
            newWav = newUrls.first
            guard newWav == newUrls.first else {
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
        case "wav":
            sandboxFileURL = dir.appendingPathComponent(newWav!.lastPathComponent)
        default:
            sandboxFileURL = dir.appendingPathComponent(newExclusive!.lastPathComponent)
        }
        
        if FileManager.default.fileExists(atPath: sandboxFileURL.path) {
            switch currentFileType {
            case "mp3":
                beatAudioURL.text = newAudio!.lastPathComponent as String
                beatAudioURL.textColor = .green
            case "wav":
                beatWavURL.text = newWav!.lastPathComponent as String
                beatWavURL.textColor = .green
            default:
                beatExclusiveURL.text = newExclusive!.lastPathComponent as String
                beatExclusiveURL.textColor = .green
            }
        }
        else {
            do {
                switch currentFileType {
                case "mp3":
                    try FileManager.default.copyItem(at: newAudio!, to: sandboxFileURL)
                    beatAudioURL.text = newAudio!.lastPathComponent as String
                    beatAudioURL.textColor = .green
                case "wav":
                    try FileManager.default.copyItem(at: newWav!, to: sandboxFileURL)
                    beatWavURL.text = newWav!.lastPathComponent as String
                    beatWavURL.textColor = .green
                default:
                    try FileManager.default.copyItem(at: newExclusive!, to: sandboxFileURL)
                    beatExclusiveURL.text = newExclusive!.lastPathComponent as String
                    beatExclusiveURL.textColor = .green
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

extension EditBeatsViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        switch textField {
        case hiddenBeatTextField:
            if currentBeat == nil {
                let row = 0
                currentBeat = AllBeatsInDatabaseArray[row]
                let b = AllBeatsInDatabaseArray[row]
                initialBeat.name = b.name
                initialBeat.duration = b.duration
                initialBeat.toneDeafAppId = b.toneDeafAppId
                initialBeat.producers = b.producers
                initialBeat.date = b.date
                initialBeat.downloads = b.downloads
                initialBeat.mp3Price = b.mp3Price
                initialBeat.wavPrice = b.wavPrice
                initialBeat.exclusivePrice = b.exclusivePrice
                initialBeat.time = b.time
                initialBeat.tempo = b.tempo
                initialBeat.datetime = b.datetime
                initialBeat.audioURL = b.audioURL
                initialBeat.imageURL = b.imageURL
                initialBeat.beatID = b.beatID
                initialBeat.priceType = b.priceType
                initialBeat.types = b.types
                initialBeat.sounds = b.sounds
                initialBeat.exclusiveFilesURL = b.exclusiveFilesURL
                initialBeat.wavURL = b.wavURL
                initialBeat.officialVideo = b.officialVideo
                initialBeat.videos = b.videos
                initialBeat.soundcloud = b.soundcloud
                initialBeat.key = b.key
                
                ogPrice = initialBeat.priceType
            }
            else {
                var row = 0
                for per in AllBeatsInDatabaseArray {
                    if per.toneDeafAppId == currentBeat.toneDeafAppId {
                        currentBeat = AllBeatsInDatabaseArray[row]
                        let b = AllBeatsInDatabaseArray[row]
                        initialBeat.name = b.name
                        initialBeat.duration = b.duration
                        initialBeat.toneDeafAppId = b.toneDeafAppId
                        initialBeat.producers = b.producers
                        initialBeat.date = b.date
                        initialBeat.downloads = b.downloads
                        initialBeat.mp3Price = b.mp3Price
                        initialBeat.wavPrice = b.wavPrice
                        initialBeat.exclusivePrice = b.exclusivePrice
                        initialBeat.time = b.time
                        initialBeat.tempo = b.tempo
                        initialBeat.datetime = b.datetime
                        initialBeat.audioURL = b.audioURL
                        initialBeat.imageURL = b.imageURL
                        initialBeat.beatID = b.beatID
                        initialBeat.priceType = b.priceType
                        initialBeat.types = b.types
                        initialBeat.sounds = b.sounds
                        initialBeat.exclusiveFilesURL = b.exclusiveFilesURL
                        initialBeat.wavURL = b.wavURL
                        initialBeat.officialVideo = b.officialVideo
                        initialBeat.videos = b.videos
                        initialBeat.soundcloud = b.soundcloud
                        initialBeat.key = b.key
                        
                        ogPrice = initialBeat.priceType
                    
                    } else {
                        row+=1
                    }
                }
            }
        default:
            break
        }
    }
}
