//
//  FilterFreeBeatCells.swift
//  ToneDeafDeafinitionsApp
//
//  Created by Tone Deaf on 8/9/20.
//  Copyright © 2020 GITEM Solutions. All rights reserved.
//

import UIKit
import BEMCheckBox
import MultiSlider
import BadgeSwift

//All Filter
let FreeBeatFilterIdex0NotificationKey = "com.gitemsolutions.filterIndex0"
let FreeBeatFilterIdex1NotificationKey = "com.gitemsolutions.filterIndex1"
let FreeBeatFilterIdex2NotificationKey = "com.gitemsolutions.filterIndex2"
let FreeBeatFilterIdex3NotificationKey = "com.gitemsolutions.filterIndex3"

let FilterIndex0Notify = Notification.Name(FreeBeatFilterIdex0NotificationKey)
let FilterIndex1Notify = Notification.Name(FreeBeatFilterIdex1NotificationKey)
let FilterIndex2Notify = Notification.Name(FreeBeatFilterIdex2NotificationKey)
let FilterIndex3Notify = Notification.Name(FreeBeatFilterIdex3NotificationKey)

//tempo
let FreeBeatFilterTempoMinNotificationKey = "com.gitemsolutions.TempoThumbMin"
let FreeBeatFilterTempoMaxNotificationKey = "com.gitemsolutions.TempoThumbMax"
let FreeBeatFilterTempoSpecifiedNotificationKey = "com.gitemsolutions.TempoThumbSpecified"
let FreeBeatFilterTempoStatusNotificationKey = "com.gitemsolutions.TempoThumbStatus"
let FreeBeatFilterTempoResetNotificationKey = "com.gitemsolutions.TempoThumbReset"

let FilterTempoMinNotify = Notification.Name(FreeBeatFilterTempoMinNotificationKey)
let FilterTempoMaxNotify = Notification.Name(FreeBeatFilterTempoMaxNotificationKey)
let FilterTempoSpecifiedNotify = Notification.Name(FreeBeatFilterTempoSpecifiedNotificationKey)
let FilterTempoStatusNotify = Notification.Name(FreeBeatFilterTempoStatusNotificationKey)
let FilterTempoResetNotify = Notification.Name(FreeBeatFilterTempoResetNotificationKey)

//Key
let FreeBeatFilterUpdatedNotificationKey = "com.gitemsolutions.filterUpdated"
//let FreeBeatFilterKeyPickerViewAddedNotificationKey = "com.gitemsolutions.filterKeyPickerViewReset"
let FreeBeatFilterKeyPickerViewResetNotificationKey = "com.gitemsolutions.filterKeyPickerViewAdded"
//let FreeBeatFilterUpdatedAddNotificationKey = "com.gitemsolutions.filterAddUpdated"
let FreeBeatFilterKeyStatusNotificationKey = "com.gitemsolutions.filterKeyStatusChanged"

let FilterKeyChangedNotify = Notification.Name(FreeBeatFilterUpdatedNotificationKey)
//let FilterKeyPickerAddedNotify = Notification.Name(FreeBeatFilterKeyPickerViewAddedNotificationKey)
let FilterKeyPickerResetNotify = Notification.Name(FreeBeatFilterKeyPickerViewResetNotificationKey)
//let FilterKeyAddChangedNotify = Notification.Name(FreeBeatFilterUpdatedAddNotificationKey)
let FilterKeyStatusNotify = Notification.Name(FreeBeatFilterKeyStatusNotificationKey)

//Type
let FreeBeatFilterTypeStatusNotificationKey = "com.gitemsolutions.filterTypeStatusChanged"
let FreeBeatFilterTypeUpdatedNotificationKey = "com.gitemsolutions.filterTypeUpdated"
let FreeBeatFilterTypeResetNotificationKey = "com.gitemsolutions.filterTypeReset"

let FilterTypeStatusNotify = Notification.Name(FreeBeatFilterTypeStatusNotificationKey)
let FilterTypeChangedNotify = Notification.Name(FreeBeatFilterTypeUpdatedNotificationKey)
let FilterTypeResetNotify = Notification.Name(FreeBeatFilterTypeResetNotificationKey)

//Type
let FreeBeatFilterSoundsStatusNotificationKey = "com.gitemsolutions.filterSoundsStatusChanged"
let FreeBeatFilterSoundsUpdatedNotificationKey = "com.gitemsolutions.filterSoundsUpdated"
let FreeBeatFilterSoundsResetNotificationKey = "com.gitemsolutions.filterSoundsReset"

let FilterSoundsStatusNotify = Notification.Name(FreeBeatFilterSoundsStatusNotificationKey)
let FilterSoundsChangedNotify = Notification.Name(FreeBeatFilterSoundsUpdatedNotificationKey)
let FilterSoundsResetNotify = Notification.Name(FreeBeatFilterSoundsResetNotificationKey)

//MARK: - Filter Side Navigation

var filterTableHeight:CGFloat = 125
var filterKeyTableHeight: CGFloat = 160
var prevFilterTableHeight:CGFloat = 40
var filterKeyTextFieldCode = 1
var keyfliteringCode = 0
var tempofilteringCode = 0
var typefilteringCode = 0
var soundsfilteringCode = 0
var producersfilteringCode = 0

var allTypeFilteringCode = 0
var darkTypeFilteringCode = 0
var melodicTypeFilteringCode = 0
var aggressiveTypeFilteringCode = 0
var smoothTypeFilteringCode = 0
var rAndBTypeFilteringCode = 0
var vibeyTypeFilteringCode = 0
var clubTypeFilteringCode = 0
var joyfulTypeFilteringCode = 0
var soulfulTypeFilteringCode = 0
var experimentalTypeFilteringCode = 0
var relaxedTypeFilteringCode = 0
var calmTypeFilteringCode = 0
var epicTypeFilteringCode = 0
var simpleTypeFilteringCode = 0
var trapTypeFilteringCode = 0

var allSoundsFilteringCode = 0
var keysSoundFilteringCode = 0
var pianoRhodesSoundFilteringCode = 0
var pianoElectricSoundFilteringCode = 0
var pianoAcousticSoundFilteringCode = 0
var pianoVinylSoundFilteringCode = 0
var organSoundFilteringCode = 0
var theraminSoundFilteringCode = 0
var whistleSoundFilteringCode = 0
var hornsSoundFilteringCode = 0
var stringsSoundFilteringCode = 0
var fluteSoundFilteringCode = 0
var padBellSoundFilteringCode = 0
var padHollowSoundFilteringCode = 0
var padAggressiveSoundFilteringCode = 0
var choirSoundFilteringCode = 0
var saxophoneSoundFilteringCode = 0
var guitarElectricSoundFilteringCode = 0
var guitarAcousticSoundFilteringCode = 0
var guitarSteelSoundFilteringCode = 0
var bellsEDMSoundFilteringCode = 0
var bellsVinylSoundFilteringCode = 0
var bellsGothicSoundFilteringCode = 0
var bellsHollowSoundFilteringCode = 0
var bellsMusicBoxSoundFilteringCode = 0
var sampleVocalSoundFilteringCode = 0
var sampleSongSoundFilteringCode = 0
var noKickSoundFilteringCode = 0
var kickSoundFilteringCode = 0
var long808SoundFilteringCode = 0
var short808SoundFilteringCode = 0
var clean808SoundFilteringCode = 0
var distorted808SoundFilteringCode = 0
var moogBassSoundFilteringCode = 0
var subBassSoundFilteringCode = 0
var synthBassDistortedSoundFilteringCode = 0
var snapSoundFilteringCode = 0
var synthBassDeepSoundFilteringCode = 0

class MenuListController: UITableViewController {
    
    static var shared = MenuListController()
    
    var items = ["Tempo", "Key", "Type", "Sounds"]
    
    override func viewDidLoad() {
    super.viewDidLoad()
        //createObservers()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        tableView.reloadData()
    }
    
//    func createObservers(){
//        NotificationCenter.default.addObserver(self, selector: #selector(MenuListController.rowheight), name: FilterKeyPickerResetNotify, object: nil)
//    }
    
    @objc func rowheight() {
        tableView.beginUpdates()
        //if hardFilterKeyReset == true {
            filterKeyTableHeight = 160
            prevFilterTableHeight = 40
        //}
        tableView.endUpdates()
    }
    
    deinit {
        print("📗filter controller Deallocated")
    }

    
    @IBAction func addAnotherKeyTapped(_ sender: Any) {
        tableView.beginUpdates()
        filterKeyTableHeight += prevFilterTableHeight
        //NotificationCenter.default.post(name: FilterKeyPickerAddedNotify, object: nil)
        tableView.endUpdates()
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.row == 0 {
            filterTableHeight = 215
        }
        if indexPath.row == 1 {
            filterTableHeight = filterKeyTableHeight
        }
        if indexPath.row == 2 {
            filterTableHeight = 340
        }
        if indexPath.row == 3 {
            filterTableHeight = 860
        }
        return filterTableHeight//Your custom row height
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let array = items[indexPath.row]
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "tempoCell", for: indexPath) as! FilterTempoTableCellController
            cell.funcSetTemp(array: array)
            return cell
        }
        else if indexPath.row == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "keyCell", for: indexPath) as! FilterKeyTableCellController
            cell.funcSetTemp(array: array)
            return cell
        } else if indexPath.row == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "typeCell", for: indexPath) as! FilterTypeTableCellController
            cell.funcSetTemp(array: array)
            return cell
        } else /*if indexPath.row == 3*/ {
            let cell = tableView.dequeueReusableCell(withIdentifier: "soundsCell", for: indexPath) as! FilterSoundsTableCellController
            cell.funcSetTemp(array: array)
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        //hardFilterKeyReset == false
        
        if indexPath.row == 0 {
            if tempofilteringCode == 0 {
                print("tempo row toggled")
                numberOfActiveFilterCells+=1
                print("number of active filter cells = \(numberOfActiveFilterCells)")
                tempofilteringCode=1
                print("tempo filtering code/ is tempo on or off = \(tempofilteringCode)")
            } else if tempofilteringCode == 1 {
                numberOfActiveFilterCells-=1
                print("number of active filter cells = \(numberOfActiveFilterCells)")
                tempofilteringCode=0
                print("tempo filtering code/ is tempo on or off = \(tempofilteringCode)")
            }
               NotificationCenter.default.post(name: FilterIndex0Notify, object: nil)
        }
        if indexPath.row == 1 {
            if keyfliteringCode == 0 {
                numberOfActiveFilterCells+=1
                print("number of active filter cells = \(numberOfActiveFilterCells)")
                keyfliteringCode=1
            } else if keyfliteringCode == 1 {
                numberOfActiveFilterCells-=1
                print("number of active filter cells = \(numberOfActiveFilterCells)")
                keyfliteringCode=0
            }
                NotificationCenter.default.post(name: FilterIndex1Notify, object: nil)
        }
        if indexPath.row == 2 {
            if typefilteringCode == 0 {
                numberOfActiveFilterCells+=1
                print("number of active filter cells = \(numberOfActiveFilterCells)")
                typefilteringCode=1
                print("type filtering code/ is type on or off = \(typefilteringCode)")
                print("Filtering code for all type boxes added up: \(allTypeFilteringCode)")
            } else if typefilteringCode == 1 {
                numberOfActiveFilterCells-=1
                print("number of active filter cells = \(numberOfActiveFilterCells)")
                typefilteringCode=0
                print("type filtering code/ is type on or off = \(typefilteringCode)")
                print("Filtering code for all type boxes added up: \(allTypeFilteringCode)")
            }
                NotificationCenter.default.post(name: FilterIndex2Notify, object: nil)
        }
        if indexPath.row == 3 {
            if soundsfilteringCode == 0 {
                numberOfActiveFilterCells+=1
                print("number of active filter cells = \(numberOfActiveFilterCells)")
                soundsfilteringCode=1
                print("sound filtering code/ is type on or off = \(soundsfilteringCode)")
                print("Filtering code for all sound boxes added up: \(allSoundsFilteringCode)")
            } else if soundsfilteringCode == 1 {
                numberOfActiveFilterCells-=1
                print("number of active filter cells = \(numberOfActiveFilterCells)")
                soundsfilteringCode=0
                print("sounds filtering code/ is type on or off = \(soundsfilteringCode)")
                print("Filtering code for all sound boxes added up: \(allSoundsFilteringCode)")
            }
                NotificationCenter.default.post(name: FilterIndex3Notify, object: nil)
        }
    }
}













//MARK: - TEMPO CELL



class FilterTempoTableCellController: UITableViewCell {
    
    @IBOutlet weak var tempoLabel: UILabel!
    @IBOutlet weak var filterTempoSlider: MultiSlider!
    @IBOutlet weak var tempoCellBadge: BadgeSwift!
    @IBOutlet weak var textFieldTempo: UITextField!
    @IBOutlet weak var tempoResetButton: UIButton!
    @IBOutlet weak var specifiedTempoLabel: UILabel!
    
    var beatTempoPickerView = UIPickerView()
    let tempo: [Int] = Array(50...200)
    
    override func awakeFromNib() {
        super.awakeFromNib()
        filterTempoSlider.value = [50,200]
        beatTempoPickerView.selectRow(100, inComponent: 0, animated: false)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func funcSetTemp(array: String) {
        filterTempoSlider.valueLabelPosition = .top
        filterTempoSlider.outerTrackColor = .gray
        filterTempoSlider.minimumValue = 50
        filterTempoSlider.maximumValue = 200
        
        textFieldTempo.inputView = beatTempoPickerView
        beatTempoPickerView.delegate = self
        beatTempoPickerView.dataSource = self
        pickerViewToolbar(textField: textFieldTempo, pickerView: beatTempoPickerView)
        
        //tempoCellBadge.alpha = 0
        
        createObservers()
    }
    
    deinit {
        print("📗tempo cell being deallocated")
        NotificationCenter.default.removeObserver(self)
    }
    
    func createObservers(){
        NotificationCenter.default.addObserver(self, selector: #selector(FilterTempoTableCellController.tempofiltering), name: FilterIndex0Notify, object: nil)
    }
    
    @objc func tempofiltering() {
        if tempofilteringCode == 1 {
            tempoCellBadge.alpha = 1
        } else if tempofilteringCode == 0 {
            tempoCellBadge.alpha = 0
        }
        NotificationCenter.default.post(name: FilterTempoStatusNotify, object: nil)
    }

    @IBAction func tempoSliderChanged(_ sender: Any) {
        MultiSliderSubStrings.shared.getTempoIndexes(thumb: filterTempoSlider.draggedThumbIndex, valueLabelJibberish: filterTempoSlider.valueLabels, completion: { [weak self] thumb, slidervalue in
            guard let strongSelf = self else {
                return
            }
            print("tempo slider modified")
            if tempofilteringCode == 0 {
                print("tempo cell was not active, adding 1 to set to on")
                numberOfActiveFilterCells+=1
                print("number of active filter cells = \(numberOfActiveFilterCells)")
            }
            currentTempoChoiceChanged = 0
            print("current tempo choiced used is slider: = \(currentTempoChoiceChanged)")
            strongSelf.tempoCellBadge.alpha = 1
            tempofilteringCode = 1
            print("tempo filtering code/ is tempo on or off = \(tempofilteringCode)")
            strongSelf.textFieldTempo.alpha = 0.4
            strongSelf.specifiedTempoLabel.alpha = 0.4
            if lastTempoChoiceChanged != currentTempoChoiceChanged {
                strongSelf.filterTempoSlider.alpha = 1
            }
            
            if thumb == 0 {
                print("Min thumb slider at \(slidervalue)")
                NotificationCenter.default.post(name: FilterTempoMinNotify, object: slidervalue)
            } else if thumb == 1 {
                print("Max thumb slider at \(slidervalue)")
                NotificationCenter.default.post(name: FilterTempoMaxNotify, object: slidervalue)
                
            }
            
        })
    }
    @IBAction func resetButtonTapped(_ sender: Any) {
        tempoCellBadge.alpha = 0
        filterTempoSlider.alpha = 1
        textFieldTempo.alpha = 0.4
        specifiedTempoLabel.alpha = 0.4
        filterTempoSlider.value = [50,200]
        if numberOfActiveFilterCells != 0 && tempofilteringCode == 1{
            numberOfActiveFilterCells-=1
        }
        textFieldTempo.text = ""
        tempofilteringCode = 0
        NotificationCenter.default.post(name: FilterTempoResetNotify, object: nil)
        
    }
    
}

extension FilterTempoTableCellController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        var number = 0
            number = tempo.count
        return number
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        var number = ""
            number = String (tempo[row])
        return number
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        currentTempoChoiceChanged = 1
        print("tempo exact picker modified")
        print("current tempo choiced used is exact: = \(currentTempoChoiceChanged)")
        if tempofilteringCode == 0 {
            print("tempo cell was not active, adding 1 to set to on")
            numberOfActiveFilterCells+=1
            print("number of active filter cells = \(numberOfActiveFilterCells)")
        }
        tempoCellBadge.alpha = 1
        tempofilteringCode = 1
        print("tempo filtering code/ is tempo on or off = \(tempofilteringCode)")
        filterTempoSlider.alpha = 0.4
        if lastTempoChoiceChanged != currentTempoChoiceChanged {
            textFieldTempo.alpha = 1
            specifiedTempoLabel.alpha = 1
        }
            textFieldTempo.text = String(tempo[row])
        NotificationCenter.default.post(name: FilterTempoSpecifiedNotify, object: tempo[row])
    }
    
    func pickerViewToolbar(textField:UITextField, pickerView:UIPickerView) {
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor.init(red: 182/255, green: 0/255, blue: 3/255, alpha: 1)
        toolBar.sizeToFit()

        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.done, target: self, action: #selector(dismissKeyboard))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItem.Style.plain, target: self, action: #selector(dismissKeyboard))

        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true

        textField.inputView = pickerView
        textField.inputAccessoryView = toolBar
    }
    
    @objc func dismissKeyboard() {
        
        textFieldTempo.endEditing(true)
    }
    
}















//MARK: - KEY CELL


class FilterKeyTableCellController: UITableViewCell {
    @IBOutlet weak var textFieldBeatKey: UITextField!
    @IBOutlet weak var textFieldBeatKey2: UITextField!
    @IBOutlet weak var textFieldBeatKey3: UITextField!
    @IBOutlet weak var textFieldBeatKey4: UITextField!
    @IBOutlet weak var textFieldBeatKey5: UITextField!
    @IBOutlet weak var textFieldBeatKey6: UITextField!
    @IBOutlet weak var textFieldBeatKey7: UITextField!
    @IBOutlet weak var textFieldBeatKey8: UITextField!
    @IBOutlet weak var textFieldBeatKey9: UITextField!
    @IBOutlet weak var textFieldBeatKey10: UITextField!
    @IBOutlet weak var textFieldBeatKey11: UITextField!
    @IBOutlet weak var keyResetButton: UIButton!
    @IBOutlet weak var keyBadge: BadgeSwift!
    @IBOutlet weak var addAnotherKeyStack: UIStackView!
    
    var beatKeyPickerView = UIPickerView()
    
    let keys = ["C Minor/Eb Major", "Db Minor/ E Major", "D Minor/ F Major", "Eb Minor/ Gb Major", "E Minor/ G Major", "F Minor/ Ab Major", "Gb Minor/ A Major", "G Minor/ Bb Major", "Ab Minor/ B Major", "A Minor/ C Major", "Bb Minor/ Db Major", "B Minor/ D Major"]
    var keystemp:Array<String>!
    var chosentemp:Array<String> = []
    var notTheClearedOne:Array<String> = []
    var vararray:Array<String> = []
    
    var clearedone = ""
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func funcSetTemp(array: String) {
        keystemp = keys
        textFieldBeatKey.inputView = beatKeyPickerView
        textFieldBeatKey2.inputView = beatKeyPickerView
        textFieldBeatKey3.inputView = beatKeyPickerView
        textFieldBeatKey4.inputView = beatKeyPickerView
        textFieldBeatKey5.inputView = beatKeyPickerView
        textFieldBeatKey6.inputView = beatKeyPickerView
        textFieldBeatKey7.inputView = beatKeyPickerView
        textFieldBeatKey8.inputView = beatKeyPickerView
        textFieldBeatKey9.inputView = beatKeyPickerView
        textFieldBeatKey10.inputView = beatKeyPickerView
        textFieldBeatKey11.inputView = beatKeyPickerView
        
        beatKeyPickerView.delegate = self
        beatKeyPickerView.dataSource = self
        pickerViewToolbar(textField: textFieldBeatKey, pickerView: beatKeyPickerView)
        pickerViewToolbar(textField: textFieldBeatKey2, pickerView: beatKeyPickerView)
        pickerViewToolbar(textField: textFieldBeatKey3, pickerView: beatKeyPickerView)
        pickerViewToolbar(textField: textFieldBeatKey4, pickerView: beatKeyPickerView)
        pickerViewToolbar(textField: textFieldBeatKey5, pickerView: beatKeyPickerView)
        pickerViewToolbar(textField: textFieldBeatKey6, pickerView: beatKeyPickerView)
        pickerViewToolbar(textField: textFieldBeatKey7, pickerView: beatKeyPickerView)
        pickerViewToolbar(textField: textFieldBeatKey8, pickerView: beatKeyPickerView)
        pickerViewToolbar(textField: textFieldBeatKey9, pickerView: beatKeyPickerView)
        pickerViewToolbar(textField: textFieldBeatKey10, pickerView: beatKeyPickerView)
        pickerViewToolbar(textField: textFieldBeatKey11, pickerView: beatKeyPickerView)
        
        textFieldBeatKey.delegate = self
        textFieldBeatKey2.delegate = self
        textFieldBeatKey3.delegate = self
        textFieldBeatKey4.delegate = self
        textFieldBeatKey5.delegate = self
        textFieldBeatKey6.delegate = self
        textFieldBeatKey7.delegate = self
        textFieldBeatKey8.delegate = self
        textFieldBeatKey9.delegate = self
        textFieldBeatKey10.delegate = self
        textFieldBeatKey11.delegate = self
        //keyBadge.alpha = 0
        addAnotherKeyStack.isHidden = true
        
        if textFieldBeatKey.text == "" {
            addAnotherKeyStack.isHidden = true
        }
        
        createObservers()
        
        if filterKeyTableHeight > 541{
            addAnotherKeyStack.isHidden = true
        }
        
    }
    
    deinit {
        print("📗key cell being deallocated")
        NotificationCenter.default.removeObserver(self)
    }
    
   func createObservers(){
//           NotificationCenter.default.addObserver(self, selector: #selector(FilterKeyTableCellController.addPicker), name: FilterKeyPickerAddedNotify, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(FilterKeyTableCellController.keyfiltering), name: FilterIndex1Notify, object: nil)
  }
    
    @objc func keyfiltering() {
        if keyfliteringCode == 1 {
            keyBadge.alpha = 1
        } else if keyfliteringCode == 0 {
            keyBadge.alpha = 0
            
        }
        NotificationCenter.default.post(name: FilterKeyStatusNotify, object: nil)
    }
       
    @objc func addPicker(notification: NSNotification) {
        addPickerSetup()
    }

    func addPickerSetup() {
        print("adding text")
        addAnotherKeyStack.isHidden = true
        switch filterKeyTextFieldCode {
        case 1:
            textFieldBeatKey2.isHidden = false
        case 2:
            textFieldBeatKey3.isHidden = false
        case 3:
            textFieldBeatKey4.isHidden = false
        case 4:
            textFieldBeatKey5.isHidden = false
        case 5:
            textFieldBeatKey6.isHidden = false
        case 6:
            textFieldBeatKey7.isHidden = false
        case 7:
            textFieldBeatKey8.isHidden = false
        case 8:
            textFieldBeatKey9.isHidden = false
        case 9:
            textFieldBeatKey10.isHidden = false
        case 10:
            textFieldBeatKey11.isHidden = false
        default:
            print("📕 Error.")
        }
        filterKeyTextFieldCode+=1
        print(filterKeyTextFieldCode)
    }
    
    @IBAction func resetButtonTapped(_ sender: Any) {
        textFieldBeatKey.text = ""
//        textFieldBeatKey2.text = ""
//        textFieldBeatKey3.text = ""
//        textFieldBeatKey4.text = ""
//        textFieldBeatKey5.text = ""
//        textFieldBeatKey6.text = ""
//        textFieldBeatKey7.text = ""
//        textFieldBeatKey8.text = ""
//        textFieldBeatKey9.text = ""
//        textFieldBeatKey10.text = ""
//        textFieldBeatKey11.text = ""
//        textFieldBeatKey2.isHidden = true
//        textFieldBeatKey3.isHidden = true
//        textFieldBeatKey4.isHidden = true
//        textFieldBeatKey5.isHidden = true
//        textFieldBeatKey6.isHidden = true
//        textFieldBeatKey7.isHidden = true
//        textFieldBeatKey8.isHidden = true
//        textFieldBeatKey9.isHidden = true
//        textFieldBeatKey10.isHidden = true
//        textFieldBeatKey11.isHidden = true
        
        filterKeyTextFieldCode = 1

        if numberOfActiveFilterCells != 0 && keyfliteringCode == 1 {
            numberOfActiveFilterCells-=1
        }
        keyfliteringCode = 0
        //hardFilterKeyReset == true
        keyBadge.alpha = 0
        //addAnotherKeyStack.isHidden = true
        
        NotificationCenter.default.post(name: FilterKeyPickerResetNotify, object: nil)
    }
    
}

extension FilterKeyTableCellController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        var number = 0
            number = keystemp.count
        
        return number
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        var number = ""
            number = keystemp[row]
        return number
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        keyBadge.alpha = 1
        if keyfliteringCode == 0 {
            print("key cell was not active, adding 1 to set to on")
            numberOfActiveFilterCells+=1
            print("number of active filter cells = \(numberOfActiveFilterCells)")
        }
        keyfliteringCode = 1
        print("key filtering code/ is key on or off = \(keyfliteringCode)")
        
        if textFieldBeatKey.isEditing {
            textFieldBeatKey.text = keystemp[row]
            NotificationCenter.default.post(name: FilterKeyChangedNotify, object: keystemp[row])
        }
        if textFieldBeatKey2.isEditing {
            textFieldBeatKey2.text = keystemp[row]
            //NotificationCenter.default.post(name: FilterKeyAddChangedNotify, object: keystemp[row])
        }
        if textFieldBeatKey3.isEditing {
            textFieldBeatKey3.text = keystemp[row]
            //NotificationCenter.default.post(name: FilterKeyAddChangedNotify, object: keystemp[row])
        }
        if textFieldBeatKey4.isEditing {
            textFieldBeatKey4.text = keystemp[row]
           // NotificationCenter.default.post(name: FilterKeyAddChangedNotify, object: keystemp[row])
        }
        if textFieldBeatKey5.isEditing {
            textFieldBeatKey5.text = keystemp[row]
           // NotificationCenter.default.post(name: FilterKeyAddChangedNotify, object: keystemp[row])
        }
        if textFieldBeatKey6.isEditing {
            textFieldBeatKey6.text = keystemp[row]
            //NotificationCenter.default.post(name: FilterKeyAddChangedNotify, object: keystemp[row])
        }
        if textFieldBeatKey7.isEditing {
            textFieldBeatKey7.text = keystemp[row]
            //NotificationCenter.default.post(name: FilterKeyAddChangedNotify, object: keystemp[row])
        }
        if textFieldBeatKey8.isEditing {
            textFieldBeatKey8.text = keystemp[row]
            //NotificationCenter.default.post(name: FilterKeyAddChangedNotify, object: keystemp[row])
        }
        if textFieldBeatKey9.isEditing {
            textFieldBeatKey9.text = keystemp[row]
            //NotificationCenter.default.post(name: FilterKeyAddChangedNotify, object: keystemp[row])
        }
        if textFieldBeatKey10.isEditing {
            textFieldBeatKey10.text = keystemp[row]
            //NotificationCenter.default.post(name: FilterKeyAddChangedNotify, object: keystemp[row])
        }
        if textFieldBeatKey11.isEditing {
            textFieldBeatKey11.text = keystemp[row]
            //NotificationCenter.default.post(name: FilterKeyAddChangedNotify, object: keystemp[row])
        }
        if filterKeyTableHeight > 541{
            addAnotherKeyStack.isHidden = true
        } else {
            //addAnotherKeyStack.isHidden = false
        }
    }
    
//    func removeKey(value:String) {
//        guard let index = keystemp.firstIndex(of: value) else { return }
//        print("\(value) Key removed from index: \(String(describing: keystemp.firstIndex(of: value)))")
//        keystemp.remove(at: index)
//    }
//
//    func removeVarKey(value:String) {
//        guard let index = vararray.firstIndex(of: value) else { return }
//        print("\(value) Key removed from index: \(String(describing: vararray.firstIndex(of: value)))")
//        vararray.remove(at: index)
//    }
    
    func pickerViewToolbar(textField:UITextField, pickerView:UIPickerView) {
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor.init(red: 182/255, green: 0/255, blue: 3/255, alpha: 1)
        toolBar.sizeToFit()

        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.done, target: self, action: #selector(self.dismissKeyboard))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItem.Style.plain, target: self, action: #selector(self.dismissKeyboard))

        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true

        textField.inputView = pickerView
        textField.inputAccessoryView = toolBar
    }
    
    @objc func dismissKeyboard() {
        
        textFieldBeatKey.endEditing(true)
        textFieldBeatKey2.endEditing(true)
        textFieldBeatKey3.endEditing(true)
        textFieldBeatKey4.endEditing(true)
        textFieldBeatKey5.endEditing(true)
        textFieldBeatKey6.endEditing(true)
        textFieldBeatKey7.endEditing(true)
        textFieldBeatKey8.endEditing(true)
        textFieldBeatKey9.endEditing(true)
        textFieldBeatKey10.endEditing(true)
        textFieldBeatKey11.endEditing(true)
        beatKeyPickerView.reloadAllComponents()
        
    }
    
}

extension FilterKeyTableCellController: UITextFieldDelegate {
    
    public func textFieldShouldClear(_ textField: UITextField) -> Bool {
        addAnotherKeyStack.isHidden = true
        return true
    }
}












//MARK: - TYPE CELL



class FilterTypeTableCellController: UITableViewCell {
    
    
    @IBOutlet weak var typeBadge: BadgeSwift!
    
    @IBOutlet weak var datkTypeCheckBox: BEMCheckBox!
    @IBOutlet weak var melodicTypeCheckBox: BEMCheckBox!
    @IBOutlet weak var aggressiveTypeCheckBox: BEMCheckBox!
    @IBOutlet weak var smoothTypeCheckBox: BEMCheckBox!
    @IBOutlet weak var rAndBTypeCheckBox: BEMCheckBox!
    @IBOutlet weak var vibeyTypeCheckBox: BEMCheckBox!
    @IBOutlet weak var clubTypeCheckBox: BEMCheckBox!
    @IBOutlet weak var joyfulTypeCheckBox: BEMCheckBox!
    @IBOutlet weak var soulfulTypeCheckBox: BEMCheckBox!
    @IBOutlet weak var experimentalTypeCheckBox: BEMCheckBox!
    @IBOutlet weak var relaxedTypeCheckBox: BEMCheckBox!
    @IBOutlet weak var calmTypeCheckBox: BEMCheckBox!
    @IBOutlet weak var epicTypeCheckBox: BEMCheckBox!
    @IBOutlet weak var simpleTypeCheckBox: BEMCheckBox!
    @IBOutlet weak var trapTypeCheckBox: BEMCheckBox!
    
    @IBOutlet weak var typeResetButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func funcSetTemp(array: String) {
        //typeBadge.alpha = 0
        createObservers()
    }
    
    deinit {
        print("📗type cell being deallocated")
        NotificationCenter.default.removeObserver(self)
    }
    
    func createObservers(){
        NotificationCenter.default.addObserver(self, selector: #selector(FilterTypeTableCellController.typefiltering), name: FilterIndex2Notify, object: nil)
    }
    
    @objc func typefiltering() {
        if typefilteringCode == 1 {
            typeBadge.alpha = 1
        } else if typefilteringCode == 0 {
            typeBadge.alpha = 0
            
        }
        NotificationCenter.default.post(name: FilterTypeStatusNotify, object: nil)
    }
    
    @IBAction func filterTypeResetButtonTapped(_ sender: Any) {
        if numberOfActiveFilterCells != 0 && typefilteringCode == 1 {
            numberOfActiveFilterCells-=1
        }
        typefilteringCode = 0
        allTypeFilteringCode = 0
        darkTypeFilteringCode = 0
        melodicTypeFilteringCode = 0
        aggressiveTypeFilteringCode = 0
        smoothTypeFilteringCode = 0
        rAndBTypeFilteringCode = 0
        vibeyTypeFilteringCode = 0
        clubTypeFilteringCode = 0
        joyfulTypeFilteringCode = 0
        soulfulTypeFilteringCode = 0
        experimentalTypeFilteringCode = 0
        relaxedTypeFilteringCode = 0
        calmTypeFilteringCode = 0
        epicTypeFilteringCode = 0
        simpleTypeFilteringCode = 0
        trapTypeFilteringCode = 0
        
        typeBadge.alpha = 0
        datkTypeCheckBox.on = false
        melodicTypeCheckBox.on = false
        aggressiveTypeCheckBox.on = false
        smoothTypeCheckBox.on = false
        rAndBTypeCheckBox.on = false
        vibeyTypeCheckBox.on = false
        clubTypeCheckBox.on = false
        joyfulTypeCheckBox.on = false
        soulfulTypeCheckBox.on = false
        experimentalTypeCheckBox.on = false
        relaxedTypeCheckBox.on = false
        calmTypeCheckBox.on = false
        epicTypeCheckBox.on = false
        simpleTypeCheckBox.on = false
        trapTypeCheckBox.on = false
        
        NotificationCenter.default.post(name: FilterTypeResetNotify, object: nil)
    }
    
    @IBAction func DarkTypeChanged(_ sender: Any) {
        typeBadge.alpha = 1
        if darkTypeFilteringCode == 0 {
            if typefilteringCode == 0 {
                numberOfActiveFilterCells+=1
                print("Number of active filtering cells is: \(numberOfActiveFilterCells)")
            }
            typefilteringCode = 1
            print("type filtering cell is active, type filtering code is: \(typefilteringCode)")
            allTypeFilteringCode += 1
            print("Filtering code for all type boxes added up: \(allTypeFilteringCode)")
            darkTypeFilteringCode = 1
            print("Dark type filtering activated, type filtering code is: \(darkTypeFilteringCode)")
        } else if darkTypeFilteringCode == 1 {
            if allTypeFilteringCode > 1 {
                if typefilteringCode == 0 {
                    typeBadge.alpha = 1
                    typefilteringCode = 1
                    numberOfActiveFilterCells+=1
                    print("Number of active filtering cells is: \(numberOfActiveFilterCells)")
                }
            }
            if allTypeFilteringCode == 1 {
                typeBadge.alpha = 0
                typefilteringCode = 0
                if numberOfActiveFilterCells != 0 {
                    numberOfActiveFilterCells-=1
                }
                print("Number of active filtering cells is: \(numberOfActiveFilterCells)")
                print("No type filter checkboxes active, type filtering code is: \(typefilteringCode)")
                print("No type filter checkboxes active, alltypefiltering code is: \(allTypeFilteringCode-1)")
            }
            allTypeFilteringCode -= 1
            print("Filtering code for all type boxes added up: \(allTypeFilteringCode)")
            darkTypeFilteringCode = 0
            print("Melodic type filtering deactivated, type filtering code is: \(darkTypeFilteringCode)")
        }
        NotificationCenter.default.post(name: FilterTypeChangedNotify, object: "Dark")
    }
    
    @IBAction func melodicTypeChanged(_ sender: Any) {
        typeBadge.alpha = 1
        if melodicTypeFilteringCode == 0 {
            if typefilteringCode == 0 {
                numberOfActiveFilterCells+=1
                print("Number of active filtering cells is: \(numberOfActiveFilterCells)")
            }
            typefilteringCode = 1
            print("type filtering cell is active, type filtering code is: \(typefilteringCode)")
            allTypeFilteringCode += 1
            print("Filtering code for all type boxes added up: \(allTypeFilteringCode)")
            melodicTypeFilteringCode = 1
            print("Melodic type filtering activated, type filtering code is: \(melodicTypeFilteringCode)")
        } else if melodicTypeFilteringCode == 1 {
            if allTypeFilteringCode > 1 {
                if typefilteringCode == 0 {
                    typeBadge.alpha = 1
                    typefilteringCode = 1
                    numberOfActiveFilterCells+=1
                    print("Number of active filtering cells is: \(numberOfActiveFilterCells)")
                }
            }
            if allTypeFilteringCode == 1 {
                typeBadge.alpha = 0
                typefilteringCode = 0
                if numberOfActiveFilterCells != 0 {
                    numberOfActiveFilterCells-=1
                }
                print("Number of active filtering cells is: \(numberOfActiveFilterCells)")
                print("No type filter checkboxes active, type filtering code is: \(typefilteringCode)")
                print("No type filter checkboxes active, alltypefiltering code is: \(allTypeFilteringCode)")
            }
            allTypeFilteringCode -= 1
            print("Filtering code for all type boxes added up: \(allTypeFilteringCode)")
            melodicTypeFilteringCode = 0
            print("Melodic type filtering deactivated, type filtering code is: \(melodicTypeFilteringCode)")
        }
        NotificationCenter.default.post(name: FilterTypeChangedNotify, object: "Melodic")
    }
    
    @IBAction func aggressiveTypeChanged(_ sender: Any) {
        typeBadge.alpha = 1
        if aggressiveTypeFilteringCode == 0 {
            if typefilteringCode == 0 {
                numberOfActiveFilterCells+=1
                print("Number of active filtering cells is: \(numberOfActiveFilterCells)")
            }
            typefilteringCode = 1
            print("type filtering cell is active, type filtering code is: \(typefilteringCode)")
            allTypeFilteringCode += 1
            print("Filtering code for all type boxes added up: \(allTypeFilteringCode)")
            aggressiveTypeFilteringCode = 1
        } else if aggressiveTypeFilteringCode == 1 {
            if allTypeFilteringCode > 1 {
                if typefilteringCode == 0 {
                    typeBadge.alpha = 1
                    typefilteringCode = 1
                    numberOfActiveFilterCells+=1
                    print("Number of active filtering cells is: \(numberOfActiveFilterCells)")
                }
            }
            if allTypeFilteringCode == 1 {
                typeBadge.alpha = 0
                typefilteringCode = 0
                if numberOfActiveFilterCells != 0 {
                    numberOfActiveFilterCells-=1
                }
                print("Number of active filtering cells is: \(numberOfActiveFilterCells)")
                print("No type filter checkboxes active, type filtering code is: \(typefilteringCode)")
                print("No type filter checkboxes active, alltypefiltering code is: \(allTypeFilteringCode)")
            }
            allTypeFilteringCode -= 1
            print("Filtering code for all type boxes added up: \(allTypeFilteringCode)")
            aggressiveTypeFilteringCode = 0
        }
        NotificationCenter.default.post(name: FilterTypeChangedNotify, object: "Aggressive")
    }
    
    @IBAction func smoothTypeChanged(_ sender: Any) {
        typeBadge.alpha = 1
        if smoothTypeFilteringCode == 0 {
            if typefilteringCode == 0 {
                numberOfActiveFilterCells+=1
                print("Number of active filtering cells is: \(numberOfActiveFilterCells)")
            }
            typefilteringCode = 1
            print("type filtering cell is active, type filtering code is: \(typefilteringCode)")
            allTypeFilteringCode += 1
            print("Filtering code for all type boxes added up: \(allTypeFilteringCode)")
            smoothTypeFilteringCode = 1
        } else if smoothTypeFilteringCode == 1 {
            if allTypeFilteringCode > 1 {
                if typefilteringCode == 0 {
                    typeBadge.alpha = 1
                    typefilteringCode = 1
                    numberOfActiveFilterCells+=1
                    print("Number of active filtering cells is: \(numberOfActiveFilterCells)")
                }
            }
            if allTypeFilteringCode == 1 {
                typeBadge.alpha = 0
                typefilteringCode = 0
                if numberOfActiveFilterCells != 0 {
                    numberOfActiveFilterCells-=1
                }
                print("Number of active filtering cells is: \(numberOfActiveFilterCells)")
                print("No type filter checkboxes active, type filtering code is: \(typefilteringCode)")
                print("No type filter checkboxes active, alltypefiltering code is: \(allTypeFilteringCode)")
            }
            allTypeFilteringCode -= 1
            print("Filtering code for all type boxes added up: \(allTypeFilteringCode)")
            smoothTypeFilteringCode = 0
        }
        NotificationCenter.default.post(name: FilterTypeChangedNotify, object: "Smooth")
    }
    
    @IBAction func rAndBTypeChanged(_ sender: Any) {
        typeBadge.alpha = 1
        if rAndBTypeFilteringCode == 0 {
            if typefilteringCode == 0 {
                numberOfActiveFilterCells+=1
                print("Number of active filtering cells is: \(numberOfActiveFilterCells)")
            }
            typefilteringCode = 1
            print("type filtering cell is active, type filtering code is: \(typefilteringCode)")
            allTypeFilteringCode += 1
            print("Filtering code for all type boxes added up: \(allTypeFilteringCode)")
            rAndBTypeFilteringCode = 1
        } else if rAndBTypeFilteringCode == 1 {
            if allTypeFilteringCode > 1 {
                if typefilteringCode == 0 {
                    typeBadge.alpha = 1
                    typefilteringCode = 1
                    numberOfActiveFilterCells+=1
                    print("Number of active filtering cells is: \(numberOfActiveFilterCells)")
                }
            }
            if allTypeFilteringCode == 1 {
                typeBadge.alpha = 0
                typefilteringCode = 0
                if numberOfActiveFilterCells != 0 {
                    numberOfActiveFilterCells-=1
                }
                print("Number of active filtering cells is: \(numberOfActiveFilterCells)")
                print("No type filter checkboxes active, type filtering code is: \(typefilteringCode)")
                print("No type filter checkboxes active, alltypefiltering code is: \(allTypeFilteringCode)")
            }
            allTypeFilteringCode -= 1
            print("Filtering code for all type boxes added up: \(allTypeFilteringCode)")
            rAndBTypeFilteringCode = 0
        }
        NotificationCenter.default.post(name: FilterTypeChangedNotify, object: "R&B")
    }
    
    @IBAction func vibeyTypeChanged(_ sender: Any) {
        typeBadge.alpha = 1
        if vibeyTypeFilteringCode == 0 {
            if typefilteringCode == 0 {
                numberOfActiveFilterCells+=1
                print("Number of active filtering cells is: \(numberOfActiveFilterCells)")
            }
            typefilteringCode = 1
            print("type filtering cell is active, type filtering code is: \(typefilteringCode)")
            allTypeFilteringCode += 1
            print("Filtering code for all type boxes added up: \(allTypeFilteringCode)")
            vibeyTypeFilteringCode = 1
        } else if vibeyTypeFilteringCode == 1 {
            if allTypeFilteringCode > 1 {
                if typefilteringCode == 0 {
                    typeBadge.alpha = 1
                    typefilteringCode = 1
                    numberOfActiveFilterCells+=1
                    print("Number of active filtering cells is: \(numberOfActiveFilterCells)")
                }
            }
            if allTypeFilteringCode == 1 {
                typeBadge.alpha = 0
                typefilteringCode = 0
                if numberOfActiveFilterCells != 0 {
                    numberOfActiveFilterCells-=1
                }
                print("Number of active filtering cells is: \(numberOfActiveFilterCells)")
                print("No type filter checkboxes active, type filtering code is: \(typefilteringCode)")
                print("No type filter checkboxes active, alltypefiltering code is: \(allTypeFilteringCode)")
            }
            allTypeFilteringCode -= 1
            print("Filtering code for all type boxes added up: \(allTypeFilteringCode)")
            vibeyTypeFilteringCode = 0
        }
        NotificationCenter.default.post(name: FilterTypeChangedNotify, object: "Vibey")
    }
    
    @IBAction func clubTypeChanged(_ sender: Any) {
        typeBadge.alpha = 1
        if clubTypeFilteringCode == 0 {
            if typefilteringCode == 0 {
                numberOfActiveFilterCells+=1
                print("Number of active filtering cells is: \(numberOfActiveFilterCells)")
            }
            typefilteringCode = 1
            print("type filtering cell is active, type filtering code is: \(typefilteringCode)")
            allTypeFilteringCode += 1
            print("Filtering code for all type boxes added up: \(allTypeFilteringCode)")
            clubTypeFilteringCode = 1
        } else if clubTypeFilteringCode == 1 {
            if allTypeFilteringCode > 1 {
                if typefilteringCode == 0 {
                    typeBadge.alpha = 1
                    typefilteringCode = 1
                    numberOfActiveFilterCells+=1
                    print("Number of active filtering cells is: \(numberOfActiveFilterCells)")
                }
            }
            if allTypeFilteringCode == 1 {
                typeBadge.alpha = 0
                typefilteringCode = 0
                if numberOfActiveFilterCells != 0 {
                    numberOfActiveFilterCells-=1
                }
                print("Number of active filtering cells is: \(numberOfActiveFilterCells)")
                print("No type filter checkboxes active, type filtering code is: \(typefilteringCode)")
                print("No type filter checkboxes active, alltypefiltering code is: \(allTypeFilteringCode)")
            }
            allTypeFilteringCode -= 1
            print("Filtering code for all type boxes added up: \(allTypeFilteringCode)")
            clubTypeFilteringCode = 0
        }
        NotificationCenter.default.post(name: FilterTypeChangedNotify, object: "Club")
    }
    
    @IBAction func joyfulTypeChanged(_ sender: Any) {
        typeBadge.alpha = 1
        if joyfulTypeFilteringCode == 0 {
            if typefilteringCode == 0 {
                numberOfActiveFilterCells+=1
                print("Number of active filtering cells is: \(numberOfActiveFilterCells)")
            }
            typefilteringCode = 1
            print("type filtering cell is active, type filtering code is: \(typefilteringCode)")
            allTypeFilteringCode += 1
            print("Filtering code for all type boxes added up: \(allTypeFilteringCode)")
            joyfulTypeFilteringCode = 1
        } else if joyfulTypeFilteringCode == 1 {
            if allTypeFilteringCode > 1 {
                if typefilteringCode == 0 {
                    typeBadge.alpha = 1
                    typefilteringCode = 1
                    numberOfActiveFilterCells+=1
                    print("Number of active filtering cells is: \(numberOfActiveFilterCells)")
                }
            }
            if allTypeFilteringCode == 1 {
                typeBadge.alpha = 0
                typefilteringCode = 0
                if numberOfActiveFilterCells != 0 {
                    numberOfActiveFilterCells-=1
                }
                print("Number of active filtering cells is: \(numberOfActiveFilterCells)")
                print("No type filter checkboxes active, type filtering code is: \(typefilteringCode)")
                print("No type filter checkboxes active, alltypefiltering code is: \(allTypeFilteringCode)")
            }
            allTypeFilteringCode -= 1
            print("Filtering code for all type boxes added up: \(allTypeFilteringCode)")
            joyfulTypeFilteringCode = 0
        }
        NotificationCenter.default.post(name: FilterTypeChangedNotify, object: "Joyful")
    }
    
    @IBAction func soulfulTypeChanged(_ sender: Any) {
        typeBadge.alpha = 1
        if soulfulTypeFilteringCode == 0 {
            if typefilteringCode == 0 {
                numberOfActiveFilterCells+=1
                print("Number of active filtering cells is: \(numberOfActiveFilterCells)")
            }
            typefilteringCode = 1
            print("type filtering cell is active, type filtering code is: \(typefilteringCode)")
            allTypeFilteringCode += 1
            print("Filtering code for all type boxes added up: \(allTypeFilteringCode)")
            soulfulTypeFilteringCode = 1
        } else if soulfulTypeFilteringCode == 1 {
            if allTypeFilteringCode > 1 {
                if typefilteringCode == 0 {
                    typeBadge.alpha = 1
                    typefilteringCode = 1
                    numberOfActiveFilterCells+=1
                    print("Number of active filtering cells is: \(numberOfActiveFilterCells)")
                }
            }
            if allTypeFilteringCode == 1 {
                typeBadge.alpha = 0
                typefilteringCode = 0
                if numberOfActiveFilterCells != 0 {
                    numberOfActiveFilterCells-=1
                }
                print("Number of active filtering cells is: \(numberOfActiveFilterCells)")
                print("No type filter checkboxes active, type filtering code is: \(typefilteringCode)")
                print("No type filter checkboxes active, alltypefiltering code is: \(allTypeFilteringCode)")
            }
            allTypeFilteringCode -= 1
            print("Filtering code for all type boxes added up: \(allTypeFilteringCode)")
            soulfulTypeFilteringCode = 0
        }
        NotificationCenter.default.post(name: FilterTypeChangedNotify, object: "Soulful")
    }
    
    @IBAction func experimentalTypeChanged(_ sender: Any) {
        typeBadge.alpha = 1
        if experimentalTypeFilteringCode == 0 {
            if typefilteringCode == 0 {
                numberOfActiveFilterCells+=1
                print("Number of active filtering cells is: \(numberOfActiveFilterCells)")
            }
            typefilteringCode = 1
            print("type filtering cell is active, type filtering code is: \(typefilteringCode)")
            allTypeFilteringCode += 1
            print("Filtering code for all type boxes added up: \(allTypeFilteringCode)")
            experimentalTypeFilteringCode = 1
        } else if experimentalTypeFilteringCode == 1 {
            if allTypeFilteringCode > 1 {
                if typefilteringCode == 0 {
                    typeBadge.alpha = 1
                    typefilteringCode = 1
                    numberOfActiveFilterCells+=1
                    print("Number of active filtering cells is: \(numberOfActiveFilterCells)")
                }
            }
            if allTypeFilteringCode == 1 {
                typeBadge.alpha = 0
                typefilteringCode = 0
                if numberOfActiveFilterCells != 0 {
                    numberOfActiveFilterCells-=1
                }
                print("Number of active filtering cells is: \(numberOfActiveFilterCells)")
                print("No type filter checkboxes active, type filtering code is: \(typefilteringCode)")
                print("No type filter checkboxes active, alltypefiltering code is: \(allTypeFilteringCode)")
            }
            allTypeFilteringCode -= 1
            print("Filtering code for all type boxes added up: \(allTypeFilteringCode)")
            experimentalTypeFilteringCode = 0
        }
        NotificationCenter.default.post(name: FilterTypeChangedNotify, object: "Experimental")
    }
    
    @IBAction func relaxedTypeChanged(_ sender: Any) {
        typeBadge.alpha = 1
        if relaxedTypeFilteringCode == 0 {
            if typefilteringCode == 0 {
                numberOfActiveFilterCells+=1
                print("Number of active filtering cells is: \(numberOfActiveFilterCells)")
            }
            typefilteringCode = 1
            print("type filtering cell is active, type filtering code is: \(typefilteringCode)")
            allTypeFilteringCode += 1
            print("Filtering code for all type boxes added up: \(allTypeFilteringCode)")
            relaxedTypeFilteringCode = 1
        } else if relaxedTypeFilteringCode == 1 {
            if allTypeFilteringCode > 1 {
                if typefilteringCode == 0 {
                    typeBadge.alpha = 1
                    typefilteringCode = 1
                    numberOfActiveFilterCells+=1
                    print("Number of active filtering cells is: \(numberOfActiveFilterCells)")
                }
            }
            if allTypeFilteringCode == 1 {
                typeBadge.alpha = 0
                typefilteringCode = 0
                if numberOfActiveFilterCells != 0 {
                    numberOfActiveFilterCells-=1
                }
                print("Number of active filtering cells is: \(numberOfActiveFilterCells)")
                print("No type filter checkboxes active, type filtering code is: \(typefilteringCode)")
                print("No type filter checkboxes active, alltypefiltering code is: \(allTypeFilteringCode)")
            }
            allTypeFilteringCode -= 1
            print("Filtering code for all type boxes added up: \(allTypeFilteringCode)")
            relaxedTypeFilteringCode = 0
        }
        NotificationCenter.default.post(name: FilterTypeChangedNotify, object: "Relaxed")
    }
    
    @IBAction func calmTypeChanged(_ sender: Any) {
        typeBadge.alpha = 1
        if calmTypeFilteringCode == 0 {
            if typefilteringCode == 0 {
                numberOfActiveFilterCells+=1
                print("Number of active filtering cells is: \(numberOfActiveFilterCells)")
            }
            typefilteringCode = 1
            print("type filtering cell is active, type filtering code is: \(typefilteringCode)")
            allTypeFilteringCode += 1
            print("Filtering code for all type boxes added up: \(allTypeFilteringCode)")
            calmTypeFilteringCode = 1
        } else if calmTypeFilteringCode == 1 {
            if allTypeFilteringCode > 1 {
                if typefilteringCode == 0 {
                    typeBadge.alpha = 1
                    typefilteringCode = 1
                    numberOfActiveFilterCells+=1
                    print("Number of active filtering cells is: \(numberOfActiveFilterCells)")
                }
            }
            if allTypeFilteringCode == 1 {
                typeBadge.alpha = 0
                typefilteringCode = 0
                if numberOfActiveFilterCells != 0 {
                    numberOfActiveFilterCells-=1
                }
                print("Number of active filtering cells is: \(numberOfActiveFilterCells)")
                print("No type filter checkboxes active, type filtering code is: \(typefilteringCode)")
                print("No type filter checkboxes active, alltypefiltering code is: \(allTypeFilteringCode)")
            }
            allTypeFilteringCode -= 1
            print("Filtering code for all type boxes added up: \(allTypeFilteringCode)")
            calmTypeFilteringCode = 0
        }
        NotificationCenter.default.post(name: FilterTypeChangedNotify, object: "Calm")
    }
    
    @IBAction func epicTypeChanged(_ sender: Any) {
        typeBadge.alpha = 1
        if epicTypeFilteringCode == 0 {
            if typefilteringCode == 0 {
                numberOfActiveFilterCells+=1
                print("Number of active filtering cells is: \(numberOfActiveFilterCells)")
            }
            typefilteringCode = 1
            print("type filtering cell is active, type filtering code is: \(typefilteringCode)")
            allTypeFilteringCode += 1
            print("Filtering code for all type boxes added up: \(allTypeFilteringCode)")
            epicTypeFilteringCode = 1
        } else if epicTypeFilteringCode == 1 {
            if allTypeFilteringCode > 1 {
                if typefilteringCode == 0 {
                    typeBadge.alpha = 1
                    typefilteringCode = 1
                    numberOfActiveFilterCells+=1
                    print("Number of active filtering cells is: \(numberOfActiveFilterCells)")
                }
            }
            if allTypeFilteringCode == 1 {
                typeBadge.alpha = 0
                typefilteringCode = 0
                if numberOfActiveFilterCells != 0 {
                    numberOfActiveFilterCells-=1
                }
                print("Number of active filtering cells is: \(numberOfActiveFilterCells)")
                print("No type filter checkboxes active, type filtering code is: \(typefilteringCode)")
                print("No type filter checkboxes active, alltypefiltering code is: \(allTypeFilteringCode)")
            }
            allTypeFilteringCode -= 1
            print("Filtering code for all type boxes added up: \(allTypeFilteringCode)")
            epicTypeFilteringCode = 0
        }
        NotificationCenter.default.post(name: FilterTypeChangedNotify, object: "Epic")
    }
    
    @IBAction func simpleTypeChanged(_ sender: Any) {
        typeBadge.alpha = 1
        if simpleTypeFilteringCode == 0 {
            if typefilteringCode == 0 {
                numberOfActiveFilterCells+=1
                print("Number of active filtering cells is: \(numberOfActiveFilterCells)")
            }
            typefilteringCode = 1
            print("type filtering cell is active, type filtering code is: \(typefilteringCode)")
            allTypeFilteringCode += 1
            print("Filtering code for all type boxes added up: \(allTypeFilteringCode)")
            simpleTypeFilteringCode = 1
        } else if simpleTypeFilteringCode == 1 {
            if allTypeFilteringCode > 1 {
                if typefilteringCode == 0 {
                    typeBadge.alpha = 1
                    typefilteringCode = 1
                    numberOfActiveFilterCells+=1
                    print("Number of active filtering cells is: \(numberOfActiveFilterCells)")
                }
            }
            if allTypeFilteringCode == 1 {
                typeBadge.alpha = 0
                typefilteringCode = 0
                if numberOfActiveFilterCells != 0 {
                    numberOfActiveFilterCells-=1
                }
                print("Number of active filtering cells is: \(numberOfActiveFilterCells)")
                print("No type filter checkboxes active, type filtering code is: \(typefilteringCode)")
                print("No type filter checkboxes active, alltypefiltering code is: \(allTypeFilteringCode)")
            }
            allTypeFilteringCode -= 1
            print("Filtering code for all type boxes added up: \(allTypeFilteringCode)")
            simpleTypeFilteringCode = 0
        }
        NotificationCenter.default.post(name: FilterTypeChangedNotify, object: "Simple")
    }
    
    @IBAction func trapTypeChanged(_ sender: Any) {
        typeBadge.alpha = 1
        if trapTypeFilteringCode == 0 {
            if typefilteringCode == 0 {
                numberOfActiveFilterCells+=1
                print("Number of active filtering cells is: \(numberOfActiveFilterCells)")
            }
            typefilteringCode = 1
            print("type filtering cell is active, type filtering code is: \(typefilteringCode)")
            allTypeFilteringCode += 1
            print("Filtering code for all type boxes added up: \(allTypeFilteringCode)")
            trapTypeFilteringCode = 1
        } else if trapTypeFilteringCode == 1 {
            if allTypeFilteringCode > 1 {
                if typefilteringCode == 0 {
                    typeBadge.alpha = 1
                    typefilteringCode = 1
                    numberOfActiveFilterCells+=1
                    print("Number of active filtering cells is: \(numberOfActiveFilterCells)")
                }
            }
            if allTypeFilteringCode == 1 {
                typeBadge.alpha = 0
                typefilteringCode = 0
                if numberOfActiveFilterCells != 0 {
                    numberOfActiveFilterCells-=1
                }
                print("Number of active filtering cells is: \(numberOfActiveFilterCells)")
                print("No type filter checkboxes active, type filtering code is: \(typefilteringCode)")
                print("No type filter checkboxes active, alltypefiltering code is: \(allTypeFilteringCode)")
            }
            allTypeFilteringCode -= 1
            print("Filtering code for all type boxes added up: \(allTypeFilteringCode)")
            trapTypeFilteringCode = 0
        }
        NotificationCenter.default.post(name: FilterTypeChangedNotify, object: "Trap")
    }
    
}












//MARK: - Sounds CELL



class FilterSoundsTableCellController: UITableViewCell {
    
    @IBOutlet weak var soundsBadge: BadgeSwift!
    @IBOutlet weak var keysSoundCheckBox: BEMCheckBox!
    @IBOutlet weak var pianoAcousticSoundCheckBox: BEMCheckBox!
    @IBOutlet weak var pianoVinylSoundCheckBox: BEMCheckBox!
    @IBOutlet weak var pianoElectricSoundCheckBox: BEMCheckBox!
    @IBOutlet weak var pianoRhodesSoundCheckBox: BEMCheckBox!
    @IBOutlet weak var organSoundCheckBox: BEMCheckBox!
    @IBOutlet weak var theraminSoundCheckBox: BEMCheckBox!
    @IBOutlet weak var whistleSoundCheckBox: BEMCheckBox!
    @IBOutlet weak var hornsSoundCheckBox: BEMCheckBox!
    @IBOutlet weak var stringsSoundCheckBox: BEMCheckBox!
    @IBOutlet weak var fluteSoundCheckBox: BEMCheckBox!
    @IBOutlet weak var padBellSoundCheckBox: BEMCheckBox!
    @IBOutlet weak var padHollowSoundCheckBox: BEMCheckBox!
    @IBOutlet weak var choirSoundCheckBox: BEMCheckBox!
    @IBOutlet weak var saxophoneSoundCheckBox: BEMCheckBox!
    @IBOutlet weak var guitarElectricSoundCheckBox: BEMCheckBox!
    @IBOutlet weak var guitarAcousticSoundCheckBox: BEMCheckBox!
    @IBOutlet weak var guitarSteelSoundCheckBox: BEMCheckBox!
    @IBOutlet weak var bellsEDMSoundCheckBox: BEMCheckBox!
    @IBOutlet weak var bellsVinylSoundCheckBox: BEMCheckBox!
    @IBOutlet weak var bellsGothicSoundCheckBox: BEMCheckBox!
    @IBOutlet weak var bellsHollowSoundCheckBox: BEMCheckBox!
    @IBOutlet weak var bellsMusicBok: BEMCheckBox!
    @IBOutlet weak var sampleVocal: BEMCheckBox!
    @IBOutlet weak var sampleSongSoundCheckBox: BEMCheckBox!
    @IBOutlet weak var noKickSoundCheckBox: BEMCheckBox!
    @IBOutlet weak var kickSoundCheckBox: BEMCheckBox!
    @IBOutlet weak var long808SoundCheckBox: BEMCheckBox!
    @IBOutlet weak var short808SoundCheckBox: BEMCheckBox!
    @IBOutlet weak var clean808SoundCheckBox: BEMCheckBox!
    @IBOutlet weak var distorted808SoundCheckBox: BEMCheckBox!
    @IBOutlet weak var moogBassSoundCheckBox: BEMCheckBox!
    @IBOutlet weak var subBassSoundCheckBox: BEMCheckBox!
    @IBOutlet weak var synthBassDistortedSoundCheckBox: BEMCheckBox!
    @IBOutlet weak var snapSoundCheckBox: BEMCheckBox!
    @IBOutlet weak var synthBassDeepSoundCheckBox: BEMCheckBox!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func funcSetTemp(array: String) {
        //soundsBadge.alpha = 0
        createObservers()
    }
    
    deinit {
        print("📗sound cell being deallocated")
        NotificationCenter.default.removeObserver(self)
    }

    func createObservers(){
        NotificationCenter.default.addObserver(self, selector: #selector(FilterSoundsTableCellController.soundfiltering), name: FilterIndex3Notify, object: nil)
    }

    @objc func soundfiltering() {
        if soundsfilteringCode == 1 {
            soundsBadge.alpha = 1
        } else if soundsfilteringCode == 0 {
            soundsBadge.alpha = 0

        }
        NotificationCenter.default.post(name: FilterSoundsStatusNotify, object: nil)
    }
    
    
    @IBAction func keysSoundCheckBoxTapped(_ sender: Any) {
        soundsBadge.alpha = 1
        if keysSoundFilteringCode == 0 {
            if soundsfilteringCode == 0 {
                numberOfActiveFilterCells+=1
                print("Number of active filtering cells is: \(numberOfActiveFilterCells)")
            }
            soundsfilteringCode = 1
            print("sounds filtering cell is active, sounds filtering code is: \(soundsfilteringCode)")
            allSoundsFilteringCode += 1
            print("Filtering code for all sounds boxes added up: \(allSoundsFilteringCode)")
            keysSoundFilteringCode = 1
        } else if keysSoundFilteringCode == 1 {
            if allSoundsFilteringCode > 1 {
                if soundsfilteringCode == 0 {
                    soundsBadge.alpha = 1
                    soundsfilteringCode = 1
                    numberOfActiveFilterCells+=1
                    print("Number of active filtering cells is: \(numberOfActiveFilterCells)")
                }
            }
            if allSoundsFilteringCode == 1 {
                soundsBadge.alpha = 0
                soundsfilteringCode = 0
                if numberOfActiveFilterCells != 0 {
                    numberOfActiveFilterCells-=1
                }
                print("Number of active filtering cells is: \(numberOfActiveFilterCells)")
                print("No sounds filter checkboxes active, sounds filtering code is: \(soundsfilteringCode)")
                print("No sounds filter checkboxes active, allsoundsfiltering code is: \(allSoundsFilteringCode)")
            }
            allSoundsFilteringCode -= 1
            print("Filtering code for all type boxes added up: \(allSoundsFilteringCode)")
            keysSoundFilteringCode = 0
        }
        NotificationCenter.default.post(name: FilterSoundsChangedNotify, object: "Keys")
    }
    
    @IBAction func pianoAcousticSoundCheckBoxTapped(_ sender: Any) {
        soundsBadge.alpha = 1
        if pianoAcousticSoundFilteringCode == 0 {
            if soundsfilteringCode == 0 {
                numberOfActiveFilterCells+=1
                print("Number of active filtering cells is: \(numberOfActiveFilterCells)")
            }
            soundsfilteringCode = 1
            print("sounds filtering cell is active, sounds filtering code is: \(soundsfilteringCode)")
            allSoundsFilteringCode += 1
            print("Filtering code for all sounds boxes added up: \(allSoundsFilteringCode)")
            pianoAcousticSoundFilteringCode = 1
        } else if pianoAcousticSoundFilteringCode == 1 {
            if allSoundsFilteringCode > 1 {
                if soundsfilteringCode == 0 {
                    soundsBadge.alpha = 1
                    soundsfilteringCode = 1
                    numberOfActiveFilterCells+=1
                    print("Number of active filtering cells is: \(numberOfActiveFilterCells)")
                }
            }
            if allSoundsFilteringCode == 1 {
                soundsBadge.alpha = 0
                soundsfilteringCode = 0
                if numberOfActiveFilterCells != 0 {
                    numberOfActiveFilterCells-=1
                }
                print("Number of active filtering cells is: \(numberOfActiveFilterCells)")
                print("No sounds filter checkboxes active, sounds filtering code is: \(soundsfilteringCode)")
                print("No sounds filter checkboxes active, allsoundsfiltering code is: \(allSoundsFilteringCode)")
            }
            allSoundsFilteringCode -= 1
            print("Filtering code for all type boxes added up: \(allSoundsFilteringCode)")
            pianoAcousticSoundFilteringCode = 0
        }
        NotificationCenter.default.post(name: FilterSoundsChangedNotify, object: "Piano Acoustic")
    }
    
    @IBAction func pianoVinylSoundCheckBoxTapped(_ sender: Any) {
        soundsBadge.alpha = 1
        if pianoVinylSoundFilteringCode == 0 {
            if soundsfilteringCode == 0 {
                numberOfActiveFilterCells+=1
                print("Number of active filtering cells is: \(numberOfActiveFilterCells)")
            }
            soundsfilteringCode = 1
            print("sounds filtering cell is active, sounds filtering code is: \(soundsfilteringCode)")
            allSoundsFilteringCode += 1
            print("Filtering code for all sounds boxes added up: \(allSoundsFilteringCode)")
            pianoVinylSoundFilteringCode = 1
        } else if pianoVinylSoundFilteringCode == 1 {
            if allSoundsFilteringCode > 1 {
                if soundsfilteringCode == 0 {
                    soundsBadge.alpha = 1
                    soundsfilteringCode = 1
                    numberOfActiveFilterCells+=1
                    print("Number of active filtering cells is: \(numberOfActiveFilterCells)")
                }
            }
            if allSoundsFilteringCode == 1 {
                soundsBadge.alpha = 0
                soundsfilteringCode = 0
                if numberOfActiveFilterCells != 0 {
                    numberOfActiveFilterCells-=1
                }
                print("Number of active filtering cells is: \(numberOfActiveFilterCells)")
                print("No sounds filter checkboxes active, sounds filtering code is: \(soundsfilteringCode)")
                print("No sounds filter checkboxes active, allsoundsfiltering code is: \(allSoundsFilteringCode)")
            }
            allSoundsFilteringCode -= 1
            print("Filtering code for all type boxes added up: \(allSoundsFilteringCode)")
            pianoVinylSoundFilteringCode = 0
        }
        NotificationCenter.default.post(name: FilterSoundsChangedNotify, object: "Piano Vinyl")
    }
    
    @IBAction func pianoElectricSoundCheckBoxTapped(_ sender: Any) {
        soundsBadge.alpha = 1
        if pianoElectricSoundFilteringCode == 0 {
            if soundsfilteringCode == 0 {
                numberOfActiveFilterCells+=1
                print("Number of active filtering cells is: \(numberOfActiveFilterCells)")
            }
            soundsfilteringCode = 1
            print("sounds filtering cell is active, sounds filtering code is: \(soundsfilteringCode)")
            allSoundsFilteringCode += 1
            print("Filtering code for all sounds boxes added up: \(allSoundsFilteringCode)")
            pianoElectricSoundFilteringCode = 1
        } else if pianoElectricSoundFilteringCode == 1 {
            if allSoundsFilteringCode > 1 {
                if soundsfilteringCode == 0 {
                    soundsBadge.alpha = 1
                    soundsfilteringCode = 1
                    numberOfActiveFilterCells+=1
                    print("Number of active filtering cells is: \(numberOfActiveFilterCells)")
                }
            }
            if allSoundsFilteringCode == 1 {
                soundsBadge.alpha = 0
                soundsfilteringCode = 0
                if numberOfActiveFilterCells != 0 {
                    numberOfActiveFilterCells-=1
                }
                print("Number of active filtering cells is: \(numberOfActiveFilterCells)")
                print("No sounds filter checkboxes active, sounds filtering code is: \(soundsfilteringCode)")
                print("No sounds filter checkboxes active, allsoundsfiltering code is: \(allSoundsFilteringCode)")
            }
            allSoundsFilteringCode -= 1
            print("Filtering code for all type boxes added up: \(allSoundsFilteringCode)")
            pianoElectricSoundFilteringCode = 0
        }
        NotificationCenter.default.post(name: FilterSoundsChangedNotify, object: "Piano Electric")
    }
    
    @IBAction func pianoRhodesSoundCheckBoxTapped(_ sender: Any) {
        soundsBadge.alpha = 1
        if pianoRhodesSoundFilteringCode == 0 {
            if soundsfilteringCode == 0 {
                numberOfActiveFilterCells+=1
                print("Number of active filtering cells is: \(numberOfActiveFilterCells)")
            }
            soundsfilteringCode = 1
            print("sounds filtering cell is active, sounds filtering code is: \(soundsfilteringCode)")
            allSoundsFilteringCode += 1
            print("Filtering code for all sounds boxes added up: \(allSoundsFilteringCode)")
            pianoRhodesSoundFilteringCode = 1
        } else if pianoRhodesSoundFilteringCode == 1 {
            if allSoundsFilteringCode > 1 {
                if soundsfilteringCode == 0 {
                    soundsBadge.alpha = 1
                    soundsfilteringCode = 1
                    numberOfActiveFilterCells+=1
                    print("Number of active filtering cells is: \(numberOfActiveFilterCells)")
                }
            }
            if allSoundsFilteringCode == 1 {
                soundsBadge.alpha = 0
                soundsfilteringCode = 0
                if numberOfActiveFilterCells != 0 {
                    numberOfActiveFilterCells-=1
                }
                print("Number of active filtering cells is: \(numberOfActiveFilterCells)")
                print("No sounds filter checkboxes active, sounds filtering code is: \(soundsfilteringCode)")
                print("No sounds filter checkboxes active, allsoundsfiltering code is: \(allSoundsFilteringCode)")
            }
            allSoundsFilteringCode -= 1
            print("Filtering code for all type boxes added up: \(allSoundsFilteringCode)")
            pianoRhodesSoundFilteringCode = 0
        }
        NotificationCenter.default.post(name: FilterSoundsChangedNotify, object: "Piano Rhodes")
    }
    
    @IBAction func organSoundCheckBoxTapped(_ sender: Any) {
        soundsBadge.alpha = 1
        if organSoundFilteringCode == 0 {
            if soundsfilteringCode == 0 {
                numberOfActiveFilterCells+=1
                print("Number of active filtering cells is: \(numberOfActiveFilterCells)")
            }
            soundsfilteringCode = 1
            print("sounds filtering cell is active, sounds filtering code is: \(soundsfilteringCode)")
            allSoundsFilteringCode += 1
            print("Filtering code for all sounds boxes added up: \(allSoundsFilteringCode)")
            organSoundFilteringCode = 1
        } else if organSoundFilteringCode == 1 {
            if allSoundsFilteringCode > 1 {
                if soundsfilteringCode == 0 {
                    soundsBadge.alpha = 1
                    soundsfilteringCode = 1
                    numberOfActiveFilterCells+=1
                    print("Number of active filtering cells is: \(numberOfActiveFilterCells)")
                }
            }
            if allSoundsFilteringCode == 1 {
                soundsBadge.alpha = 0
                soundsfilteringCode = 0
                if numberOfActiveFilterCells != 0 {
                    numberOfActiveFilterCells-=1
                }
                print("Number of active filtering cells is: \(numberOfActiveFilterCells)")
                print("No sounds filter checkboxes active, sounds filtering code is: \(soundsfilteringCode)")
                print("No sounds filter checkboxes active, allsoundsfiltering code is: \(allSoundsFilteringCode)")
            }
            allSoundsFilteringCode -= 1
            print("Filtering code for all type boxes added up: \(allSoundsFilteringCode)")
            organSoundFilteringCode = 0
        }
        NotificationCenter.default.post(name: FilterSoundsChangedNotify, object: "Organ")
    }
    
    @IBAction func theraminSoundCheckBoxTapped(_ sender: Any) {
        soundsBadge.alpha = 1
        if theraminSoundFilteringCode == 0 {
            if soundsfilteringCode == 0 {
                numberOfActiveFilterCells+=1
                print("Number of active filtering cells is: \(numberOfActiveFilterCells)")
            }
            soundsfilteringCode = 1
            print("sounds filtering cell is active, sounds filtering code is: \(soundsfilteringCode)")
            allSoundsFilteringCode += 1
            print("Filtering code for all sounds boxes added up: \(allSoundsFilteringCode)")
            theraminSoundFilteringCode = 1
        } else if theraminSoundFilteringCode == 1 {
            if allSoundsFilteringCode > 1 {
                if soundsfilteringCode == 0 {
                    soundsBadge.alpha = 1
                    soundsfilteringCode = 1
                    numberOfActiveFilterCells+=1
                    print("Number of active filtering cells is: \(numberOfActiveFilterCells)")
                }
            }
            if allSoundsFilteringCode == 1 {
                soundsBadge.alpha = 0
                soundsfilteringCode = 0
                if numberOfActiveFilterCells != 0 {
                    numberOfActiveFilterCells-=1
                }
                print("Number of active filtering cells is: \(numberOfActiveFilterCells)")
                print("No sounds filter checkboxes active, sounds filtering code is: \(soundsfilteringCode)")
                print("No sounds filter checkboxes active, allsoundsfiltering code is: \(allSoundsFilteringCode)")
            }
            allSoundsFilteringCode -= 1
            print("Filtering code for all type boxes added up: \(allSoundsFilteringCode)")
            theraminSoundFilteringCode = 0
        }
        NotificationCenter.default.post(name: FilterSoundsChangedNotify, object: "Theramin")
    }
    
    @IBAction func whistleSoundCheckBoxTapped(_ sender: Any) {
        soundsBadge.alpha = 1
        if whistleSoundFilteringCode == 0 {
            if soundsfilteringCode == 0 {
                numberOfActiveFilterCells+=1
                print("Number of active filtering cells is: \(numberOfActiveFilterCells)")
            }
            soundsfilteringCode = 1
            print("sounds filtering cell is active, sounds filtering code is: \(soundsfilteringCode)")
            allSoundsFilteringCode += 1
            print("Filtering code for all sounds boxes added up: \(allSoundsFilteringCode)")
            whistleSoundFilteringCode = 1
        } else if whistleSoundFilteringCode == 1 {
            if allSoundsFilteringCode > 1 {
                if soundsfilteringCode == 0 {
                    soundsBadge.alpha = 1
                    soundsfilteringCode = 1
                    numberOfActiveFilterCells+=1
                    print("Number of active filtering cells is: \(numberOfActiveFilterCells)")
                }
            }
            if allSoundsFilteringCode == 1 {
                soundsBadge.alpha = 0
                soundsfilteringCode = 0
                if numberOfActiveFilterCells != 0 {
                    numberOfActiveFilterCells-=1
                }
                print("Number of active filtering cells is: \(numberOfActiveFilterCells)")
                print("No sounds filter checkboxes active, sounds filtering code is: \(soundsfilteringCode)")
                print("No sounds filter checkboxes active, allsoundsfiltering code is: \(allSoundsFilteringCode)")
            }
            allSoundsFilteringCode -= 1
            print("Filtering code for all type boxes added up: \(allSoundsFilteringCode)")
            whistleSoundFilteringCode = 0
        }
        NotificationCenter.default.post(name: FilterSoundsChangedNotify, object: "Whistle")
    }
    
    @IBAction func hornsSoundCheckBoxTapped(_ sender: Any) {
        soundsBadge.alpha = 1
        if hornsSoundFilteringCode == 0 {
            if soundsfilteringCode == 0 {
                numberOfActiveFilterCells+=1
                print("Number of active filtering cells is: \(numberOfActiveFilterCells)")
            }
            soundsfilteringCode = 1
            print("sounds filtering cell is active, sounds filtering code is: \(soundsfilteringCode)")
            allSoundsFilteringCode += 1
            print("Filtering code for all sounds boxes added up: \(allSoundsFilteringCode)")
            hornsSoundFilteringCode = 1
        } else if hornsSoundFilteringCode == 1 {
            if allSoundsFilteringCode > 1 {
                if soundsfilteringCode == 0 {
                    soundsBadge.alpha = 1
                    soundsfilteringCode = 1
                    numberOfActiveFilterCells+=1
                    print("Number of active filtering cells is: \(numberOfActiveFilterCells)")
                }
            }
            if allSoundsFilteringCode == 1 {
                soundsBadge.alpha = 0
                soundsfilteringCode = 0
                if numberOfActiveFilterCells != 0 {
                    numberOfActiveFilterCells-=1
                }
                print("Number of active filtering cells is: \(numberOfActiveFilterCells)")
                print("No sounds filter checkboxes active, sounds filtering code is: \(soundsfilteringCode)")
                print("No sounds filter checkboxes active, allsoundsfiltering code is: \(allSoundsFilteringCode)")
            }
            allSoundsFilteringCode -= 1
            print("Filtering code for all type boxes added up: \(allSoundsFilteringCode)")
            hornsSoundFilteringCode = 0
        }
        NotificationCenter.default.post(name: FilterSoundsChangedNotify, object: "Horns")
    }
    
    @IBAction func stringsSoundCheckBoxTapped(_ sender: Any) {
        soundsBadge.alpha = 1
        if stringsSoundFilteringCode == 0 {
            if soundsfilteringCode == 0 {
                numberOfActiveFilterCells+=1
                print("Number of active filtering cells is: \(numberOfActiveFilterCells)")
            }
            soundsfilteringCode = 1
            print("sounds filtering cell is active, sounds filtering code is: \(soundsfilteringCode)")
            allSoundsFilteringCode += 1
            print("Filtering code for all sounds boxes added up: \(allSoundsFilteringCode)")
            stringsSoundFilteringCode = 1
        } else if stringsSoundFilteringCode == 1 {
            if allSoundsFilteringCode > 1 {
                if soundsfilteringCode == 0 {
                    soundsBadge.alpha = 1
                    soundsfilteringCode = 1
                    numberOfActiveFilterCells+=1
                    print("Number of active filtering cells is: \(numberOfActiveFilterCells)")
                }
            }
            if allSoundsFilteringCode == 1 {
                soundsBadge.alpha = 0
                soundsfilteringCode = 0
                if numberOfActiveFilterCells != 0 {
                    numberOfActiveFilterCells-=1
                }
                print("Number of active filtering cells is: \(numberOfActiveFilterCells)")
                print("No sounds filter checkboxes active, sounds filtering code is: \(soundsfilteringCode)")
                print("No sounds filter checkboxes active, allsoundsfiltering code is: \(allSoundsFilteringCode)")
            }
            allSoundsFilteringCode -= 1
            print("Filtering code for all type boxes added up: \(allSoundsFilteringCode)")
            stringsSoundFilteringCode = 0
        }
        NotificationCenter.default.post(name: FilterSoundsChangedNotify, object: "Strings")
    }
    
    @IBAction func fluteSoundCheckBoxTapped(_ sender: Any) {
        soundsBadge.alpha = 1
        if fluteSoundFilteringCode == 0 {
            if soundsfilteringCode == 0 {
                numberOfActiveFilterCells+=1
                print("Number of active filtering cells is: \(numberOfActiveFilterCells)")
            }
            soundsfilteringCode = 1
            print("sounds filtering cell is active, sounds filtering code is: \(soundsfilteringCode)")
            allSoundsFilteringCode += 1
            print("Filtering code for all sounds boxes added up: \(allSoundsFilteringCode)")
            fluteSoundFilteringCode = 1
        } else if fluteSoundFilteringCode == 1 {
            if allSoundsFilteringCode > 1 {
                if soundsfilteringCode == 0 {
                    soundsBadge.alpha = 1
                    soundsfilteringCode = 1
                    numberOfActiveFilterCells+=1
                    print("Number of active filtering cells is: \(numberOfActiveFilterCells)")
                }
            }
            if allSoundsFilteringCode == 1 {
                soundsBadge.alpha = 0
                soundsfilteringCode = 0
                if numberOfActiveFilterCells != 0 {
                    numberOfActiveFilterCells-=1
                }
                print("Number of active filtering cells is: \(numberOfActiveFilterCells)")
                print("No sounds filter checkboxes active, sounds filtering code is: \(soundsfilteringCode)")
                print("No sounds filter checkboxes active, allsoundsfiltering code is: \(allSoundsFilteringCode)")
            }
            allSoundsFilteringCode -= 1
            print("Filtering code for all type boxes added up: \(allSoundsFilteringCode)")
            fluteSoundFilteringCode = 0
        }
        NotificationCenter.default.post(name: FilterSoundsChangedNotify, object: "Flute")
    }
    
    @IBAction func padBellSoundCheckBoxTapped(_ sender: Any) {
        soundsBadge.alpha = 1
        if padBellSoundFilteringCode == 0 {
            if soundsfilteringCode == 0 {
                numberOfActiveFilterCells+=1
                print("Number of active filtering cells is: \(numberOfActiveFilterCells)")
            }
            soundsfilteringCode = 1
            print("sounds filtering cell is active, sounds filtering code is: \(soundsfilteringCode)")
            allSoundsFilteringCode += 1
            print("Filtering code for all sounds boxes added up: \(allSoundsFilteringCode)")
            padBellSoundFilteringCode = 1
        } else if padBellSoundFilteringCode == 1 {
            if allSoundsFilteringCode > 1 {
                if soundsfilteringCode == 0 {
                    soundsBadge.alpha = 1
                    soundsfilteringCode = 1
                    numberOfActiveFilterCells+=1
                    print("Number of active filtering cells is: \(numberOfActiveFilterCells)")
                }
            }
            if allSoundsFilteringCode == 1 {
                soundsBadge.alpha = 0
                soundsfilteringCode = 0
                if numberOfActiveFilterCells != 0 {
                    numberOfActiveFilterCells-=1
                }
                print("Number of active filtering cells is: \(numberOfActiveFilterCells)")
                print("No sounds filter checkboxes active, sounds filtering code is: \(soundsfilteringCode)")
                print("No sounds filter checkboxes active, allsoundsfiltering code is: \(allSoundsFilteringCode)")
            }
            allSoundsFilteringCode -= 1
            print("Filtering code for all type boxes added up: \(allSoundsFilteringCode)")
            padBellSoundFilteringCode = 0
        }
        NotificationCenter.default.post(name: FilterSoundsChangedNotify, object: "Pad Bell")
    }
    
    @IBAction func padHollowSoundCheckBoxTapped(_ sender: Any) {
        soundsBadge.alpha = 1
        if padHollowSoundFilteringCode == 0 {
            if soundsfilteringCode == 0 {
                numberOfActiveFilterCells+=1
                print("Number of active filtering cells is: \(numberOfActiveFilterCells)")
            }
            soundsfilteringCode = 1
            print("sounds filtering cell is active, sounds filtering code is: \(soundsfilteringCode)")
            allSoundsFilteringCode += 1
            print("Filtering code for all sounds boxes added up: \(allSoundsFilteringCode)")
            padHollowSoundFilteringCode = 1
        } else if padHollowSoundFilteringCode == 1 {
            if allSoundsFilteringCode > 1 {
                if soundsfilteringCode == 0 {
                    soundsBadge.alpha = 1
                    soundsfilteringCode = 1
                    numberOfActiveFilterCells+=1
                    print("Number of active filtering cells is: \(numberOfActiveFilterCells)")
                }
            }
            if allSoundsFilteringCode == 1 {
                soundsBadge.alpha = 0
                soundsfilteringCode = 0
                if numberOfActiveFilterCells != 0 {
                    numberOfActiveFilterCells-=1
                }
                print("Number of active filtering cells is: \(numberOfActiveFilterCells)")
                print("No sounds filter checkboxes active, sounds filtering code is: \(soundsfilteringCode)")
                print("No sounds filter checkboxes active, allsoundsfiltering code is: \(allSoundsFilteringCode)")
            }
            allSoundsFilteringCode -= 1
            print("Filtering code for all type boxes added up: \(allSoundsFilteringCode)")
            padHollowSoundFilteringCode = 0
        }
        NotificationCenter.default.post(name: FilterSoundsChangedNotify, object: "Pad Hollow")
    }
    
    @IBAction func padAggressiveSoundCheckBoxTapped(_ sender: Any) {
        soundsBadge.alpha = 1
        if padAggressiveSoundFilteringCode == 0 {
            if soundsfilteringCode == 0 {
                numberOfActiveFilterCells+=1
                print("Number of active filtering cells is: \(numberOfActiveFilterCells)")
            }
            soundsfilteringCode = 1
            print("sounds filtering cell is active, sounds filtering code is: \(soundsfilteringCode)")
            allSoundsFilteringCode += 1
            print("Filtering code for all sounds boxes added up: \(allSoundsFilteringCode)")
            padAggressiveSoundFilteringCode = 1
        } else if padAggressiveSoundFilteringCode == 1 {
            if allSoundsFilteringCode > 1 {
                if soundsfilteringCode == 0 {
                    soundsBadge.alpha = 1
                    soundsfilteringCode = 1
                    numberOfActiveFilterCells+=1
                    print("Number of active filtering cells is: \(numberOfActiveFilterCells)")
                }
            }
            if allSoundsFilteringCode == 1 {
                soundsBadge.alpha = 0
                soundsfilteringCode = 0
                if numberOfActiveFilterCells != 0 {
                    numberOfActiveFilterCells-=1
                }
                print("Number of active filtering cells is: \(numberOfActiveFilterCells)")
                print("No sounds filter checkboxes active, sounds filtering code is: \(soundsfilteringCode)")
                print("No sounds filter checkboxes active, allsoundsfiltering code is: \(allSoundsFilteringCode)")
            }
            allSoundsFilteringCode -= 1
            print("Filtering code for all type boxes added up: \(allSoundsFilteringCode)")
            padAggressiveSoundFilteringCode = 0
        }
        NotificationCenter.default.post(name: FilterSoundsChangedNotify, object: "Pad Aggressive")
    }
    
    @IBAction func choirSoundCheckBoxTapped(_ sender: Any) {
        soundsBadge.alpha = 1
        if choirSoundFilteringCode == 0 {
            if soundsfilteringCode == 0 {
                numberOfActiveFilterCells+=1
                print("Number of active filtering cells is: \(numberOfActiveFilterCells)")
            }
            soundsfilteringCode = 1
            print("sounds filtering cell is active, sounds filtering code is: \(soundsfilteringCode)")
            allSoundsFilteringCode += 1
            print("Filtering code for all sounds boxes added up: \(allSoundsFilteringCode)")
            choirSoundFilteringCode = 1
        } else if choirSoundFilteringCode == 1 {
            if allSoundsFilteringCode > 1 {
                if soundsfilteringCode == 0 {
                    soundsBadge.alpha = 1
                    soundsfilteringCode = 1
                    numberOfActiveFilterCells+=1
                    print("Number of active filtering cells is: \(numberOfActiveFilterCells)")
                }
            }
            if allSoundsFilteringCode == 1 {
                soundsBadge.alpha = 0
                soundsfilteringCode = 0
                if numberOfActiveFilterCells != 0 {
                    numberOfActiveFilterCells-=1
                }
                print("Number of active filtering cells is: \(numberOfActiveFilterCells)")
                print("No sounds filter checkboxes active, sounds filtering code is: \(soundsfilteringCode)")
                print("No sounds filter checkboxes active, allsoundsfiltering code is: \(allSoundsFilteringCode)")
            }
            allSoundsFilteringCode -= 1
            print("Filtering code for all type boxes added up: \(allSoundsFilteringCode)")
            choirSoundFilteringCode = 0
        }
        NotificationCenter.default.post(name: FilterSoundsChangedNotify, object: "Choir")
    }
    
    @IBAction func saxophoneSoundCheckBoxTapped(_ sender: Any) {
        soundsBadge.alpha = 1
        if saxophoneSoundFilteringCode == 0 {
            if soundsfilteringCode == 0 {
                numberOfActiveFilterCells+=1
                print("Number of active filtering cells is: \(numberOfActiveFilterCells)")
            }
            soundsfilteringCode = 1
            print("sounds filtering cell is active, sounds filtering code is: \(soundsfilteringCode)")
            allSoundsFilteringCode += 1
            print("Filtering code for all sounds boxes added up: \(allSoundsFilteringCode)")
            saxophoneSoundFilteringCode = 1
        } else if saxophoneSoundFilteringCode == 1 {
            if allSoundsFilteringCode > 1 {
                if soundsfilteringCode == 0 {
                    soundsBadge.alpha = 1
                    soundsfilteringCode = 1
                    numberOfActiveFilterCells+=1
                    print("Number of active filtering cells is: \(numberOfActiveFilterCells)")
                }
            }
            if allSoundsFilteringCode == 1 {
                soundsBadge.alpha = 0
                soundsfilteringCode = 0
                if numberOfActiveFilterCells != 0 {
                    numberOfActiveFilterCells-=1
                }
                print("Number of active filtering cells is: \(numberOfActiveFilterCells)")
                print("No sounds filter checkboxes active, sounds filtering code is: \(soundsfilteringCode)")
                print("No sounds filter checkboxes active, allsoundsfiltering code is: \(allSoundsFilteringCode)")
            }
            allSoundsFilteringCode -= 1
            print("Filtering code for all type boxes added up: \(allSoundsFilteringCode)")
            saxophoneSoundFilteringCode = 0
        }
        NotificationCenter.default.post(name: FilterSoundsChangedNotify, object: "Saxophone")
    }
    
    @IBAction func guitarElectricSoundCheckBoxTapped(_ sender: Any) {
        soundsBadge.alpha = 1
        if guitarElectricSoundFilteringCode == 0 {
            if soundsfilteringCode == 0 {
                numberOfActiveFilterCells+=1
                print("Number of active filtering cells is: \(numberOfActiveFilterCells)")
            }
            soundsfilteringCode = 1
            print("sounds filtering cell is active, sounds filtering code is: \(soundsfilteringCode)")
            allSoundsFilteringCode += 1
            print("Filtering code for all sounds boxes added up: \(allSoundsFilteringCode)")
            guitarElectricSoundFilteringCode = 1
        } else if guitarElectricSoundFilteringCode == 1 {
            if allSoundsFilteringCode > 1 {
                if soundsfilteringCode == 0 {
                    soundsBadge.alpha = 1
                    soundsfilteringCode = 1
                    numberOfActiveFilterCells+=1
                    print("Number of active filtering cells is: \(numberOfActiveFilterCells)")
                }
            }
            if allSoundsFilteringCode == 1 {
                soundsBadge.alpha = 0
                soundsfilteringCode = 0
                if numberOfActiveFilterCells != 0 {
                    numberOfActiveFilterCells-=1
                }
                print("Number of active filtering cells is: \(numberOfActiveFilterCells)")
                print("No sounds filter checkboxes active, sounds filtering code is: \(soundsfilteringCode)")
                print("No sounds filter checkboxes active, allsoundsfiltering code is: \(allSoundsFilteringCode)")
            }
            allSoundsFilteringCode -= 1
            print("Filtering code for all type boxes added up: \(allSoundsFilteringCode)")
            guitarElectricSoundFilteringCode = 0
        }
        NotificationCenter.default.post(name: FilterSoundsChangedNotify, object: "Guitar Electric")
    }
    
    @IBAction func guitarAcousticSoundCheckBoxTapped(_ sender: Any) {
        soundsBadge.alpha = 1
        if guitarAcousticSoundFilteringCode == 0 {
            if soundsfilteringCode == 0 {
                numberOfActiveFilterCells+=1
                print("Number of active filtering cells is: \(numberOfActiveFilterCells)")
            }
            soundsfilteringCode = 1
            print("sounds filtering cell is active, sounds filtering code is: \(soundsfilteringCode)")
            allSoundsFilteringCode += 1
            print("Filtering code for all sounds boxes added up: \(allSoundsFilteringCode)")
            guitarAcousticSoundFilteringCode = 1
        } else if guitarAcousticSoundFilteringCode == 1 {
            if allSoundsFilteringCode > 1 {
                if soundsfilteringCode == 0 {
                    soundsBadge.alpha = 1
                    soundsfilteringCode = 1
                    numberOfActiveFilterCells+=1
                    print("Number of active filtering cells is: \(numberOfActiveFilterCells)")
                }
            }
            if allSoundsFilteringCode == 1 {
                soundsBadge.alpha = 0
                soundsfilteringCode = 0
                if numberOfActiveFilterCells != 0 {
                    numberOfActiveFilterCells-=1
                }
                print("Number of active filtering cells is: \(numberOfActiveFilterCells)")
                print("No sounds filter checkboxes active, sounds filtering code is: \(soundsfilteringCode)")
                print("No sounds filter checkboxes active, allsoundsfiltering code is: \(allSoundsFilteringCode)")
            }
            allSoundsFilteringCode -= 1
            print("Filtering code for all type boxes added up: \(allSoundsFilteringCode)")
            guitarAcousticSoundFilteringCode = 0
        }
        NotificationCenter.default.post(name: FilterSoundsChangedNotify, object: "Guitar Acoustic")
    }
    
    @IBAction func guitarSteelSoundCheckBoxTapped(_ sender: Any) {
        soundsBadge.alpha = 1
        if guitarSteelSoundFilteringCode == 0 {
            if soundsfilteringCode == 0 {
                numberOfActiveFilterCells+=1
                print("Number of active filtering cells is: \(numberOfActiveFilterCells)")
            }
            soundsfilteringCode = 1
            print("sounds filtering cell is active, sounds filtering code is: \(soundsfilteringCode)")
            allSoundsFilteringCode += 1
            print("Filtering code for all sounds boxes added up: \(allSoundsFilteringCode)")
            guitarSteelSoundFilteringCode = 1
        } else if guitarSteelSoundFilteringCode == 1 {
            if allSoundsFilteringCode > 1 {
                if soundsfilteringCode == 0 {
                    soundsBadge.alpha = 1
                    soundsfilteringCode = 1
                    numberOfActiveFilterCells+=1
                    print("Number of active filtering cells is: \(numberOfActiveFilterCells)")
                }
            }
            if allSoundsFilteringCode == 1 {
                soundsBadge.alpha = 0
                soundsfilteringCode = 0
                if numberOfActiveFilterCells != 0 {
                    numberOfActiveFilterCells-=1
                }
                print("Number of active filtering cells is: \(numberOfActiveFilterCells)")
                print("No sounds filter checkboxes active, sounds filtering code is: \(soundsfilteringCode)")
                print("No sounds filter checkboxes active, allsoundsfiltering code is: \(allSoundsFilteringCode)")
            }
            allSoundsFilteringCode -= 1
            print("Filtering code for all type boxes added up: \(allSoundsFilteringCode)")
            guitarSteelSoundFilteringCode = 0
        }
        NotificationCenter.default.post(name: FilterSoundsChangedNotify, object: "Guitar Steel")
    }
    
    @IBAction func bellsEDMSoundCheckBoxTapped(_ sender: Any) {
        soundsBadge.alpha = 1
        if bellsEDMSoundFilteringCode == 0 {
            if soundsfilteringCode == 0 {
                numberOfActiveFilterCells+=1
                print("Number of active filtering cells is: \(numberOfActiveFilterCells)")
            }
            soundsfilteringCode = 1
            print("sounds filtering cell is active, sounds filtering code is: \(soundsfilteringCode)")
            allSoundsFilteringCode += 1
            print("Filtering code for all sounds boxes added up: \(allSoundsFilteringCode)")
            bellsEDMSoundFilteringCode = 1
        } else if bellsEDMSoundFilteringCode == 1 {
            if allSoundsFilteringCode > 1 {
                if soundsfilteringCode == 0 {
                    soundsBadge.alpha = 1
                    soundsfilteringCode = 1
                    numberOfActiveFilterCells+=1
                    print("Number of active filtering cells is: \(numberOfActiveFilterCells)")
                }
            }
            if allSoundsFilteringCode == 1 {
                soundsBadge.alpha = 0
                soundsfilteringCode = 0
                if numberOfActiveFilterCells != 0 {
                    numberOfActiveFilterCells-=1
                }
                print("Number of active filtering cells is: \(numberOfActiveFilterCells)")
                print("No sounds filter checkboxes active, sounds filtering code is: \(soundsfilteringCode)")
                print("No sounds filter checkboxes active, allsoundsfiltering code is: \(allSoundsFilteringCode)")
            }
            allSoundsFilteringCode -= 1
            print("Filtering code for all type boxes added up: \(allSoundsFilteringCode)")
            bellsEDMSoundFilteringCode = 0
        }
        NotificationCenter.default.post(name: FilterSoundsChangedNotify, object: "Bells EDM")
    }
    
    @IBAction func bellsVinylSoundCheckBoxTapped(_ sender: Any) {
        soundsBadge.alpha = 1
        if bellsVinylSoundFilteringCode == 0 {
            if soundsfilteringCode == 0 {
                numberOfActiveFilterCells+=1
                print("Number of active filtering cells is: \(numberOfActiveFilterCells)")
            }
            soundsfilteringCode = 1
            print("sounds filtering cell is active, sounds filtering code is: \(soundsfilteringCode)")
            allSoundsFilteringCode += 1
            print("Filtering code for all sounds boxes added up: \(allSoundsFilteringCode)")
            bellsVinylSoundFilteringCode = 1
        } else if bellsVinylSoundFilteringCode == 1 {
            if allSoundsFilteringCode > 1 {
                if soundsfilteringCode == 0 {
                    soundsBadge.alpha = 1
                    soundsfilteringCode = 1
                    numberOfActiveFilterCells+=1
                    print("Number of active filtering cells is: \(numberOfActiveFilterCells)")
                }
            }
            if allSoundsFilteringCode == 1 {
                soundsBadge.alpha = 0
                soundsfilteringCode = 0
                if numberOfActiveFilterCells != 0 {
                    numberOfActiveFilterCells-=1
                }
                print("Number of active filtering cells is: \(numberOfActiveFilterCells)")
                print("No sounds filter checkboxes active, sounds filtering code is: \(soundsfilteringCode)")
                print("No sounds filter checkboxes active, allsoundsfiltering code is: \(allSoundsFilteringCode)")
            }
            allSoundsFilteringCode -= 1
            print("Filtering code for all type boxes added up: \(allSoundsFilteringCode)")
            bellsVinylSoundFilteringCode = 0
        }
        NotificationCenter.default.post(name: FilterSoundsChangedNotify, object: "Bells Vinyl")
    }
    
    @IBAction func bellsGothicSoundCheckBoxTapped(_ sender: Any) {
        soundsBadge.alpha = 1
        if bellsGothicSoundFilteringCode == 0 {
            if soundsfilteringCode == 0 {
                numberOfActiveFilterCells+=1
                print("Number of active filtering cells is: \(numberOfActiveFilterCells)")
            }
            soundsfilteringCode = 1
            print("sounds filtering cell is active, sounds filtering code is: \(soundsfilteringCode)")
            allSoundsFilteringCode += 1
            print("Filtering code for all sounds boxes added up: \(allSoundsFilteringCode)")
            bellsGothicSoundFilteringCode = 1
        } else if bellsGothicSoundFilteringCode == 1 {
            if allSoundsFilteringCode > 1 {
                if soundsfilteringCode == 0 {
                    soundsBadge.alpha = 1
                    soundsfilteringCode = 1
                    numberOfActiveFilterCells+=1
                    print("Number of active filtering cells is: \(numberOfActiveFilterCells)")
                }
            }
            if allSoundsFilteringCode == 1 {
                soundsBadge.alpha = 0
                soundsfilteringCode = 0
                if numberOfActiveFilterCells != 0 {
                    numberOfActiveFilterCells-=1
                }
                print("Number of active filtering cells is: \(numberOfActiveFilterCells)")
                print("No sounds filter checkboxes active, sounds filtering code is: \(soundsfilteringCode)")
                print("No sounds filter checkboxes active, allsoundsfiltering code is: \(allSoundsFilteringCode)")
            }
            allSoundsFilteringCode -= 1
            print("Filtering code for all type boxes added up: \(allSoundsFilteringCode)")
            bellsGothicSoundFilteringCode = 0
        }
        NotificationCenter.default.post(name: FilterSoundsChangedNotify, object: "Bells Gothic")
    }
    
    @IBAction func bellsHollowSoundCheckBoxTapped(_ sender: Any) {
        soundsBadge.alpha = 1
        if bellsHollowSoundFilteringCode == 0 {
            if soundsfilteringCode == 0 {
                numberOfActiveFilterCells+=1
                print("Number of active filtering cells is: \(numberOfActiveFilterCells)")
            }
            soundsfilteringCode = 1
            print("sounds filtering cell is active, sounds filtering code is: \(soundsfilteringCode)")
            allSoundsFilteringCode += 1
            print("Filtering code for all sounds boxes added up: \(allSoundsFilteringCode)")
            bellsHollowSoundFilteringCode = 1
        } else if bellsHollowSoundFilteringCode == 1 {
            if allSoundsFilteringCode > 1 {
                if soundsfilteringCode == 0 {
                    soundsBadge.alpha = 1
                    soundsfilteringCode = 1
                    numberOfActiveFilterCells+=1
                    print("Number of active filtering cells is: \(numberOfActiveFilterCells)")
                }
            }
            if allSoundsFilteringCode == 1 {
                soundsBadge.alpha = 0
                soundsfilteringCode = 0
                if numberOfActiveFilterCells != 0 {
                    numberOfActiveFilterCells-=1
                }
                print("Number of active filtering cells is: \(numberOfActiveFilterCells)")
                print("No sounds filter checkboxes active, sounds filtering code is: \(soundsfilteringCode)")
                print("No sounds filter checkboxes active, allsoundsfiltering code is: \(allSoundsFilteringCode)")
            }
            allSoundsFilteringCode -= 1
            print("Filtering code for all type boxes added up: \(allSoundsFilteringCode)")
            bellsHollowSoundFilteringCode = 0
        }
        NotificationCenter.default.post(name: FilterSoundsChangedNotify, object: "Bells Hollow")
    }
    
    @IBAction func bellsMusicBoxSoundCheckBoxTapped(_ sender: Any) {
        soundsBadge.alpha = 1
        if bellsMusicBoxSoundFilteringCode == 0 {
            if soundsfilteringCode == 0 {
                numberOfActiveFilterCells+=1
                print("Number of active filtering cells is: \(numberOfActiveFilterCells)")
            }
            soundsfilteringCode = 1
            print("sounds filtering cell is active, sounds filtering code is: \(soundsfilteringCode)")
            allSoundsFilteringCode += 1
            print("Filtering code for all sounds boxes added up: \(allSoundsFilteringCode)")
            bellsMusicBoxSoundFilteringCode = 1
        } else if bellsMusicBoxSoundFilteringCode == 1 {
            if allSoundsFilteringCode > 1 {
                if soundsfilteringCode == 0 {
                    soundsBadge.alpha = 1
                    soundsfilteringCode = 1
                    numberOfActiveFilterCells+=1
                    print("Number of active filtering cells is: \(numberOfActiveFilterCells)")
                }
            }
            if allSoundsFilteringCode == 1 {
                soundsBadge.alpha = 0
                soundsfilteringCode = 0
                if numberOfActiveFilterCells != 0 {
                    numberOfActiveFilterCells-=1
                }
                print("Number of active filtering cells is: \(numberOfActiveFilterCells)")
                print("No sounds filter checkboxes active, sounds filtering code is: \(soundsfilteringCode)")
                print("No sounds filter checkboxes active, allsoundsfiltering code is: \(allSoundsFilteringCode)")
            }
            allSoundsFilteringCode -= 1
            print("Filtering code for all type boxes added up: \(allSoundsFilteringCode)")
            bellsMusicBoxSoundFilteringCode = 0
        }
        NotificationCenter.default.post(name: FilterSoundsChangedNotify, object: "Bells Music Box")
    }
    
    @IBAction func sampleVocalSoundCheckBoxTapped(_ sender: Any) {
        soundsBadge.alpha = 1
        if sampleVocalSoundFilteringCode == 0 {
            if soundsfilteringCode == 0 {
                numberOfActiveFilterCells+=1
                print("Number of active filtering cells is: \(numberOfActiveFilterCells)")
            }
            soundsfilteringCode = 1
            print("sounds filtering cell is active, sounds filtering code is: \(soundsfilteringCode)")
            allSoundsFilteringCode += 1
            print("Filtering code for all sounds boxes added up: \(allSoundsFilteringCode)")
            sampleVocalSoundFilteringCode = 1
        } else if sampleVocalSoundFilteringCode == 1 {
            if allSoundsFilteringCode > 1 {
                if soundsfilteringCode == 0 {
                    soundsBadge.alpha = 1
                    soundsfilteringCode = 1
                    numberOfActiveFilterCells+=1
                    print("Number of active filtering cells is: \(numberOfActiveFilterCells)")
                }
            }
            if allSoundsFilteringCode == 1 {
                soundsBadge.alpha = 0
                soundsfilteringCode = 0
                if numberOfActiveFilterCells != 0 {
                    numberOfActiveFilterCells-=1
                }
                print("Number of active filtering cells is: \(numberOfActiveFilterCells)")
                print("No sounds filter checkboxes active, sounds filtering code is: \(soundsfilteringCode)")
                print("No sounds filter checkboxes active, allsoundsfiltering code is: \(allSoundsFilteringCode)")
            }
            allSoundsFilteringCode -= 1
            print("Filtering code for all type boxes added up: \(allSoundsFilteringCode)")
            sampleVocalSoundFilteringCode = 0
        }
        NotificationCenter.default.post(name: FilterSoundsChangedNotify, object: "Sample Vocal")
    }
    
    @IBAction func sampleSongSoundCheckBoxTapped(_ sender: Any) {
        soundsBadge.alpha = 1
        if sampleSongSoundFilteringCode == 0 {
            if soundsfilteringCode == 0 {
                numberOfActiveFilterCells+=1
                print("Number of active filtering cells is: \(numberOfActiveFilterCells)")
            }
            soundsfilteringCode = 1
            print("sounds filtering cell is active, sounds filtering code is: \(soundsfilteringCode)")
            allSoundsFilteringCode += 1
            print("Filtering code for all sounds boxes added up: \(allSoundsFilteringCode)")
            sampleSongSoundFilteringCode = 1
        } else if sampleSongSoundFilteringCode == 1 {
            if allSoundsFilteringCode > 1 {
                if soundsfilteringCode == 0 {
                    soundsBadge.alpha = 1
                    soundsfilteringCode = 1
                    numberOfActiveFilterCells+=1
                    print("Number of active filtering cells is: \(numberOfActiveFilterCells)")
                }
            }
            if allSoundsFilteringCode == 1 {
                soundsBadge.alpha = 0
                soundsfilteringCode = 0
                if numberOfActiveFilterCells != 0 {
                    numberOfActiveFilterCells-=1
                }
                print("Number of active filtering cells is: \(numberOfActiveFilterCells)")
                print("No sounds filter checkboxes active, sounds filtering code is: \(soundsfilteringCode)")
                print("No sounds filter checkboxes active, allsoundsfiltering code is: \(allSoundsFilteringCode)")
            }
            allSoundsFilteringCode -= 1
            print("Filtering code for all type boxes added up: \(allSoundsFilteringCode)")
            sampleSongSoundFilteringCode = 0
        }
        NotificationCenter.default.post(name: FilterSoundsChangedNotify, object: "Sample Song")
    }
    
    @IBAction func noKickSoundCheckBoxTapped(_ sender: Any) {
        soundsBadge.alpha = 1
        if noKickSoundFilteringCode == 0 {
            if soundsfilteringCode == 0 {
                numberOfActiveFilterCells+=1
                print("Number of active filtering cells is: \(numberOfActiveFilterCells)")
            }
            soundsfilteringCode = 1
            print("sounds filtering cell is active, sounds filtering code is: \(soundsfilteringCode)")
            allSoundsFilteringCode += 1
            print("Filtering code for all sounds boxes added up: \(allSoundsFilteringCode)")
            noKickSoundFilteringCode = 1
        } else if noKickSoundFilteringCode == 1 {
            if allSoundsFilteringCode > 1 {
                if soundsfilteringCode == 0 {
                    soundsBadge.alpha = 1
                    soundsfilteringCode = 1
                    numberOfActiveFilterCells+=1
                    print("Number of active filtering cells is: \(numberOfActiveFilterCells)")
                }
            }
            if allSoundsFilteringCode == 1 {
                soundsBadge.alpha = 0
                soundsfilteringCode = 0
                if numberOfActiveFilterCells != 0 {
                    numberOfActiveFilterCells-=1
                }
                print("Number of active filtering cells is: \(numberOfActiveFilterCells)")
                print("No sounds filter checkboxes active, sounds filtering code is: \(soundsfilteringCode)")
                print("No sounds filter checkboxes active, allsoundsfiltering code is: \(allSoundsFilteringCode)")
            }
            allSoundsFilteringCode -= 1
            print("Filtering code for all type boxes added up: \(allSoundsFilteringCode)")
            noKickSoundFilteringCode = 0
        }
        NotificationCenter.default.post(name: FilterSoundsChangedNotify, object: "No Kick")
    }
    
    @IBAction func kickSoundCheckBoxTapped(_ sender: Any) {
        soundsBadge.alpha = 1
        if kickSoundFilteringCode == 0 {
            if soundsfilteringCode == 0 {
                numberOfActiveFilterCells+=1
                print("Number of active filtering cells is: \(numberOfActiveFilterCells)")
            }
            soundsfilteringCode = 1
            print("sounds filtering cell is active, sounds filtering code is: \(soundsfilteringCode)")
            allSoundsFilteringCode += 1
            print("Filtering code for all sounds boxes added up: \(allSoundsFilteringCode)")
            kickSoundFilteringCode = 1
        } else if kickSoundFilteringCode == 1 {
            if allSoundsFilteringCode > 1 {
                if soundsfilteringCode == 0 {
                    soundsBadge.alpha = 1
                    soundsfilteringCode = 1
                    numberOfActiveFilterCells+=1
                    print("Number of active filtering cells is: \(numberOfActiveFilterCells)")
                }
            }
            if allSoundsFilteringCode == 1 {
                soundsBadge.alpha = 0
                soundsfilteringCode = 0
                if numberOfActiveFilterCells != 0 {
                    numberOfActiveFilterCells-=1
                }
                print("Number of active filtering cells is: \(numberOfActiveFilterCells)")
                print("No sounds filter checkboxes active, sounds filtering code is: \(soundsfilteringCode)")
                print("No sounds filter checkboxes active, allsoundsfiltering code is: \(allSoundsFilteringCode)")
            }
            allSoundsFilteringCode -= 1
            print("Filtering code for all type boxes added up: \(allSoundsFilteringCode)")
            kickSoundFilteringCode = 0
        }
        NotificationCenter.default.post(name: FilterSoundsChangedNotify, object: "Kick")
    }
    
    @IBAction func long808SoundCheckBoxTapped(_ sender: Any) {
        soundsBadge.alpha = 1
        if long808SoundFilteringCode == 0 {
            if soundsfilteringCode == 0 {
                numberOfActiveFilterCells+=1
                print("Number of active filtering cells is: \(numberOfActiveFilterCells)")
            }
            soundsfilteringCode = 1
            print("sounds filtering cell is active, sounds filtering code is: \(soundsfilteringCode)")
            allSoundsFilteringCode += 1
            print("Filtering code for all sounds boxes added up: \(allSoundsFilteringCode)")
            long808SoundFilteringCode = 1
        } else if long808SoundFilteringCode == 1 {
            if allSoundsFilteringCode > 1 {
                if soundsfilteringCode == 0 {
                    soundsBadge.alpha = 1
                    soundsfilteringCode = 1
                    numberOfActiveFilterCells+=1
                    print("Number of active filtering cells is: \(numberOfActiveFilterCells)")
                }
            }
            if allSoundsFilteringCode == 1 {
                soundsBadge.alpha = 0
                soundsfilteringCode = 0
                if numberOfActiveFilterCells != 0 {
                    numberOfActiveFilterCells-=1
                }
                print("Number of active filtering cells is: \(numberOfActiveFilterCells)")
                print("No sounds filter checkboxes active, sounds filtering code is: \(soundsfilteringCode)")
                print("No sounds filter checkboxes active, allsoundsfiltering code is: \(allSoundsFilteringCode)")
            }
            allSoundsFilteringCode -= 1
            print("Filtering code for all type boxes added up: \(allSoundsFilteringCode)")
            long808SoundFilteringCode = 0
        }
        NotificationCenter.default.post(name: FilterSoundsChangedNotify, object: "808 Long")
    }
    
    @IBAction func short808SoundCheckBoxTapped(_ sender: Any) {
        soundsBadge.alpha = 1
        if short808SoundFilteringCode == 0 {
            if soundsfilteringCode == 0 {
                numberOfActiveFilterCells+=1
                print("Number of active filtering cells is: \(numberOfActiveFilterCells)")
            }
            soundsfilteringCode = 1
            print("sounds filtering cell is active, sounds filtering code is: \(soundsfilteringCode)")
            allSoundsFilteringCode += 1
            print("Filtering code for all sounds boxes added up: \(allSoundsFilteringCode)")
            short808SoundFilteringCode = 1
        } else if short808SoundFilteringCode == 1 {
            if allSoundsFilteringCode > 1 {
                if soundsfilteringCode == 0 {
                    soundsBadge.alpha = 1
                    soundsfilteringCode = 1
                    numberOfActiveFilterCells+=1
                    print("Number of active filtering cells is: \(numberOfActiveFilterCells)")
                }
            }
            if allSoundsFilteringCode == 1 {
                soundsBadge.alpha = 0
                soundsfilteringCode = 0
                if numberOfActiveFilterCells != 0 {
                    numberOfActiveFilterCells-=1
                }
                print("Number of active filtering cells is: \(numberOfActiveFilterCells)")
                print("No sounds filter checkboxes active, sounds filtering code is: \(soundsfilteringCode)")
                print("No sounds filter checkboxes active, allsoundsfiltering code is: \(allSoundsFilteringCode)")
            }
            allSoundsFilteringCode -= 1
            print("Filtering code for all type boxes added up: \(allSoundsFilteringCode)")
            short808SoundFilteringCode = 0
        }
        NotificationCenter.default.post(name: FilterSoundsChangedNotify, object: "808 Short")
    }
    
    @IBAction func cleanSoundCheckBoxTapped(_ sender: Any) {
        soundsBadge.alpha = 1
        if clean808SoundFilteringCode == 0 {
            if soundsfilteringCode == 0 {
                numberOfActiveFilterCells+=1
                print("Number of active filtering cells is: \(numberOfActiveFilterCells)")
            }
            soundsfilteringCode = 1
            print("sounds filtering cell is active, sounds filtering code is: \(soundsfilteringCode)")
            allSoundsFilteringCode += 1
            print("Filtering code for all sounds boxes added up: \(allSoundsFilteringCode)")
            clean808SoundFilteringCode = 1
        } else if clean808SoundFilteringCode == 1 {
            if allSoundsFilteringCode > 1 {
                if soundsfilteringCode == 0 {
                    soundsBadge.alpha = 1
                    soundsfilteringCode = 1
                    numberOfActiveFilterCells+=1
                    print("Number of active filtering cells is: \(numberOfActiveFilterCells)")
                }
            }
            if allSoundsFilteringCode == 1 {
                soundsBadge.alpha = 0
                soundsfilteringCode = 0
                if numberOfActiveFilterCells != 0 {
                    numberOfActiveFilterCells-=1
                }
                print("Number of active filtering cells is: \(numberOfActiveFilterCells)")
                print("No sounds filter checkboxes active, sounds filtering code is: \(soundsfilteringCode)")
                print("No sounds filter checkboxes active, allsoundsfiltering code is: \(allSoundsFilteringCode)")
            }
            allSoundsFilteringCode -= 1
            print("Filtering code for all type boxes added up: \(allSoundsFilteringCode)")
            clean808SoundFilteringCode = 0
        }
        NotificationCenter.default.post(name: FilterSoundsChangedNotify, object: "808 Clean")
    }
    
    @IBAction func distorted808SoundCheckBoxTapped(_ sender: Any) {
        soundsBadge.alpha = 1
        if distorted808SoundFilteringCode == 0 {
            if soundsfilteringCode == 0 {
                numberOfActiveFilterCells+=1
                print("Number of active filtering cells is: \(numberOfActiveFilterCells)")
            }
            soundsfilteringCode = 1
            print("sounds filtering cell is active, sounds filtering code is: \(soundsfilteringCode)")
            allSoundsFilteringCode += 1
            print("Filtering code for all sounds boxes added up: \(allSoundsFilteringCode)")
            distorted808SoundFilteringCode = 1
        } else if distorted808SoundFilteringCode == 1 {
            if allSoundsFilteringCode > 1 {
                if soundsfilteringCode == 0 {
                    soundsBadge.alpha = 1
                    soundsfilteringCode = 1
                    numberOfActiveFilterCells+=1
                    print("Number of active filtering cells is: \(numberOfActiveFilterCells)")
                }
            }
            if allSoundsFilteringCode == 1 {
                soundsBadge.alpha = 0
                soundsfilteringCode = 0
                if numberOfActiveFilterCells != 0 {
                    numberOfActiveFilterCells-=1
                }
                print("Number of active filtering cells is: \(numberOfActiveFilterCells)")
                print("No sounds filter checkboxes active, sounds filtering code is: \(soundsfilteringCode)")
                print("No sounds filter checkboxes active, allsoundsfiltering code is: \(allSoundsFilteringCode)")
            }
            allSoundsFilteringCode -= 1
            print("Filtering code for all type boxes added up: \(allSoundsFilteringCode)")
            distorted808SoundFilteringCode = 0
        }
        NotificationCenter.default.post(name: FilterSoundsChangedNotify, object: "808 Distorted")
    }
    
    @IBAction func moogBassSoundCheckBoxTapped(_ sender: Any) {
        soundsBadge.alpha = 1
        if moogBassSoundFilteringCode == 0 {
            if soundsfilteringCode == 0 {
                numberOfActiveFilterCells+=1
                print("Number of active filtering cells is: \(numberOfActiveFilterCells)")
            }
            soundsfilteringCode = 1
            print("sounds filtering cell is active, sounds filtering code is: \(soundsfilteringCode)")
            allSoundsFilteringCode += 1
            print("Filtering code for all sounds boxes added up: \(allSoundsFilteringCode)")
            moogBassSoundFilteringCode = 1
        } else if moogBassSoundFilteringCode == 1 {
            if allSoundsFilteringCode > 1 {
                if soundsfilteringCode == 0 {
                    soundsBadge.alpha = 1
                    soundsfilteringCode = 1
                    numberOfActiveFilterCells+=1
                    print("Number of active filtering cells is: \(numberOfActiveFilterCells)")
                }
            }
            if allSoundsFilteringCode == 1 {
                soundsBadge.alpha = 0
                soundsfilteringCode = 0
                if numberOfActiveFilterCells != 0 {
                    numberOfActiveFilterCells-=1
                }
                print("Number of active filtering cells is: \(numberOfActiveFilterCells)")
                print("No sounds filter checkboxes active, sounds filtering code is: \(soundsfilteringCode)")
                print("No sounds filter checkboxes active, allsoundsfiltering code is: \(allSoundsFilteringCode)")
            }
            allSoundsFilteringCode -= 1
            print("Filtering code for all type boxes added up: \(allSoundsFilteringCode)")
            moogBassSoundFilteringCode = 0
        }
        NotificationCenter.default.post(name: FilterSoundsChangedNotify, object: "Moog Bass")
    }
    
    @IBAction func subBassSoundCheckBoxTapped(_ sender: Any) {
        soundsBadge.alpha = 1
        if subBassSoundFilteringCode == 0 {
            if soundsfilteringCode == 0 {
                numberOfActiveFilterCells+=1
                print("Number of active filtering cells is: \(numberOfActiveFilterCells)")
            }
            soundsfilteringCode = 1
            print("sounds filtering cell is active, sounds filtering code is: \(soundsfilteringCode)")
            allSoundsFilteringCode += 1
            print("Filtering code for all sounds boxes added up: \(allSoundsFilteringCode)")
            subBassSoundFilteringCode = 1
        } else if subBassSoundFilteringCode == 1 {
            if allSoundsFilteringCode > 1 {
                if soundsfilteringCode == 0 {
                    soundsBadge.alpha = 1
                    soundsfilteringCode = 1
                    numberOfActiveFilterCells+=1
                    print("Number of active filtering cells is: \(numberOfActiveFilterCells)")
                }
            }
            if allSoundsFilteringCode == 1 {
                soundsBadge.alpha = 0
                soundsfilteringCode = 0
                if numberOfActiveFilterCells != 0 {
                    numberOfActiveFilterCells-=1
                }
                print("Number of active filtering cells is: \(numberOfActiveFilterCells)")
                print("No sounds filter checkboxes active, sounds filtering code is: \(soundsfilteringCode)")
                print("No sounds filter checkboxes active, allsoundsfiltering code is: \(allSoundsFilteringCode)")
            }
            allSoundsFilteringCode -= 1
            print("Filtering code for all type boxes added up: \(allSoundsFilteringCode)")
            subBassSoundFilteringCode = 0
        }
        NotificationCenter.default.post(name: FilterSoundsChangedNotify, object: "Sub Bass")
    }
    
    @IBAction func synthBassDistortedSoundCheckBoxTapped(_ sender: Any) {
        soundsBadge.alpha = 1
        if synthBassDistortedSoundFilteringCode == 0 {
            if soundsfilteringCode == 0 {
                numberOfActiveFilterCells+=1
                print("Number of active filtering cells is: \(numberOfActiveFilterCells)")
            }
            soundsfilteringCode = 1
            print("sounds filtering cell is active, sounds filtering code is: \(soundsfilteringCode)")
            allSoundsFilteringCode += 1
            print("Filtering code for all sounds boxes added up: \(allSoundsFilteringCode)")
            synthBassDistortedSoundFilteringCode = 1
        } else if synthBassDistortedSoundFilteringCode == 1 {
            if allSoundsFilteringCode > 1 {
                if soundsfilteringCode == 0 {
                    soundsBadge.alpha = 1
                    soundsfilteringCode = 1
                    numberOfActiveFilterCells+=1
                    print("Number of active filtering cells is: \(numberOfActiveFilterCells)")
                }
            }
            if allSoundsFilteringCode == 1 {
                soundsBadge.alpha = 0
                soundsfilteringCode = 0
                if numberOfActiveFilterCells != 0 {
                    numberOfActiveFilterCells-=1
                }
                print("Number of active filtering cells is: \(numberOfActiveFilterCells)")
                print("No sounds filter checkboxes active, sounds filtering code is: \(soundsfilteringCode)")
                print("No sounds filter checkboxes active, allsoundsfiltering code is: \(allSoundsFilteringCode)")
            }
            allSoundsFilteringCode -= 1
            print("Filtering code for all type boxes added up: \(allSoundsFilteringCode)")
            synthBassDistortedSoundFilteringCode = 0
        }
        NotificationCenter.default.post(name: FilterSoundsChangedNotify, object: "Synth Bass Distorted")
    }
    
    @IBAction func snapSoundCheckBoxTapped(_ sender: Any) {
        soundsBadge.alpha = 1
        if snapSoundFilteringCode == 0 {
            if soundsfilteringCode == 0 {
                numberOfActiveFilterCells+=1
                print("Number of active filtering cells is: \(numberOfActiveFilterCells)")
            }
            soundsfilteringCode = 1
            print("sounds filtering cell is active, sounds filtering code is: \(soundsfilteringCode)")
            allSoundsFilteringCode += 1
            print("Filtering code for all sounds boxes added up: \(allSoundsFilteringCode)")
            snapSoundFilteringCode = 1
        } else if snapSoundFilteringCode == 1 {
            if allSoundsFilteringCode > 1 {
                if soundsfilteringCode == 0 {
                    soundsBadge.alpha = 1
                    soundsfilteringCode = 1
                    numberOfActiveFilterCells+=1
                    print("Number of active filtering cells is: \(numberOfActiveFilterCells)")
                }
            }
            if allSoundsFilteringCode == 1 {
                soundsBadge.alpha = 0
                soundsfilteringCode = 0
                if numberOfActiveFilterCells != 0 {
                    numberOfActiveFilterCells-=1
                }
                print("Number of active filtering cells is: \(numberOfActiveFilterCells)")
                print("No sounds filter checkboxes active, sounds filtering code is: \(soundsfilteringCode)")
                print("No sounds filter checkboxes active, allsoundsfiltering code is: \(allSoundsFilteringCode)")
            }
            allSoundsFilteringCode -= 1
            print("Filtering code for all type boxes added up: \(allSoundsFilteringCode)")
            snapSoundFilteringCode = 0
        }
        NotificationCenter.default.post(name: FilterSoundsChangedNotify, object: "Snap")
    }
    
    @IBAction func synthBassDeepSoundCheckBoxTapped(_ sender: Any) {
        soundsBadge.alpha = 1
        if synthBassDeepSoundFilteringCode == 0 {
            if soundsfilteringCode == 0 {
                numberOfActiveFilterCells+=1
                print("Number of active filtering cells is: \(numberOfActiveFilterCells)")
            }
            soundsfilteringCode = 1
            print("sounds filtering cell is active, sounds filtering code is: \(soundsfilteringCode)")
            allSoundsFilteringCode += 1
            print("Filtering code for all sounds boxes added up: \(allSoundsFilteringCode)")
            synthBassDeepSoundFilteringCode = 1
        } else if synthBassDeepSoundFilteringCode == 1 {
            if allSoundsFilteringCode > 1 {
                if soundsfilteringCode == 0 {
                    soundsBadge.alpha = 1
                    soundsfilteringCode = 1
                    numberOfActiveFilterCells+=1
                    print("Number of active filtering cells is: \(numberOfActiveFilterCells)")
                }
            }
            if allSoundsFilteringCode == 1 {
                soundsBadge.alpha = 0
                soundsfilteringCode = 0
                if numberOfActiveFilterCells != 0 {
                    numberOfActiveFilterCells-=1
                }
                print("Number of active filtering cells is: \(numberOfActiveFilterCells)")
                print("No sounds filter checkboxes active, sounds filtering code is: \(soundsfilteringCode)")
                print("No sounds filter checkboxes active, allsoundsfiltering code is: \(allSoundsFilteringCode)")
            }
            allSoundsFilteringCode -= 1
            print("Filtering code for all type boxes added up: \(allSoundsFilteringCode)")
            synthBassDeepSoundFilteringCode = 0
        }
        NotificationCenter.default.post(name: FilterSoundsChangedNotify, object: "Synth Bass Deep")
    }
    
}
