//
//  FilterPaidBeatCells.swift
//  ToneDeafDeafinitionsApp
//
//  Created by Tone Deaf on 10/11/20.
//  Copyright © 2020 GITEM Solutions. All rights reserved.
//

import UIKit
import BEMCheckBox
import MultiSlider
import BadgeSwift

//All Filter
let PaidBeatFilterIdex0NotificationKey = "com.gitemsolutions.paidfilterIndex0"
let PaidBeatFilterIdex1NotificationKey = "com.gitemsolutions.paidfilterIndex1"
let PaidBeatFilterIdex2NotificationKey = "com.gitemsolutions.paidfilterIndex2"
let PaidBeatFilterIdex3NotificationKey = "com.gitemsolutions.paidfilterIndex3"

let PaidFilterIndex0Notify = Notification.Name(PaidBeatFilterIdex0NotificationKey)
let PaidFilterIndex1Notify = Notification.Name(PaidBeatFilterIdex1NotificationKey)
let PaidFilterIndex2Notify = Notification.Name(PaidBeatFilterIdex2NotificationKey)
let PaidFilterIndex3Notify = Notification.Name(PaidBeatFilterIdex3NotificationKey)

//tempo
let PaidBeatFilterTempoMinNotificationKey = "com.gitemsolutions.paidTempoThumbMin"
let PaidBeatFilterTempoMaxNotificationKey = "com.gitemsolutions.paidTempoThumbMax"
let PaidBeatFilterTempoSpecifiedNotificationKey = "com.gitemsolutions.paidTempoThumbSpecified"
let PaidBeatFilterTempoStatusNotificationKey = "com.gitemsolutions.paidTempoThumbStatus"
let PaidBeatFilterTempoResetNotificationKey = "com.gitemsolutions.paidTempoThumbReset"

let PaidFilterTempoMinNotify = Notification.Name(PaidBeatFilterTempoMinNotificationKey)
let PaidFilterTempoMaxNotify = Notification.Name(PaidBeatFilterTempoMaxNotificationKey)
let PaidFilterTempoSpecifiedNotify = Notification.Name(PaidBeatFilterTempoSpecifiedNotificationKey)
let PaidFilterTempoStatusNotify = Notification.Name(PaidBeatFilterTempoStatusNotificationKey)
let PaidFilterTempoResetNotify = Notification.Name(PaidBeatFilterTempoResetNotificationKey)

//Key
let PaidBeatFilterUpdatedNotificationKey = "com.gitemsolutions.paidfilterUpdated"
//let FreeBeatFilterKeyPickerViewAddedNotificationKey = "com.gitemsolutions.filterKeyPickerViewReset"
let PaidBeatFilterKeyPickerViewResetNotificationKey = "com.gitemsolutions.paidfilterKeyPickerViewAdded"
//let FreeBeatFilterUpdatedAddNotificationKey = "com.gitemsolutions.filterAddUpdated"
let PaidBeatFilterKeyStatusNotificationKey = "com.gitemsolutions.paidfilterKeyStatusChanged"

let PaidFilterKeyChangedNotify = Notification.Name(PaidBeatFilterUpdatedNotificationKey)
//let FilterKeyPickerAddedNotify = Notification.Name(FreeBeatFilterKeyPickerViewAddedNotificationKey)
let PaidFilterKeyPickerResetNotify = Notification.Name(PaidBeatFilterKeyPickerViewResetNotificationKey)
//let FilterKeyAddChangedNotify = Notification.Name(FreeBeatFilterUpdatedAddNotificationKey)
let PaidFilterKeyStatusNotify = Notification.Name(PaidBeatFilterKeyStatusNotificationKey)

//Type
let PaidBeatFilterTypeStatusNotificationKey = "com.gitemsolutions.paidfilterTypeStatusChanged"
let PaidBeatFilterTypeUpdatedNotificationKey = "com.gitemsolutions.paidfilterTypeUpdated"
let PaidBeatFilterTypeResetNotificationKey = "com.gitemsolutions.paidfilterTypeReset"

let PaidFilterTypeStatusNotify = Notification.Name(PaidBeatFilterTypeStatusNotificationKey)
let PaidFilterTypeChangedNotify = Notification.Name(PaidBeatFilterTypeUpdatedNotificationKey)
let PaidFilterTypeResetNotify = Notification.Name(PaidBeatFilterTypeResetNotificationKey)

//Type
let PaidBeatFilterSoundsStatusNotificationKey = "com.gitemsolutions.paidfilterSoundsStatusChanged"
let PaidBeatFilterSoundsUpdatedNotificationKey = "com.gitemsolutions.paidfilterSoundsUpdated"
let PaidBeatFilterSoundsResetNotificationKey = "com.gitemsolutions.paidfilterSoundsReset"

let PaidFilterSoundsStatusNotify = Notification.Name(PaidBeatFilterSoundsStatusNotificationKey)
let PaidFilterSoundsChangedNotify = Notification.Name(PaidBeatFilterSoundsUpdatedNotificationKey)
let PaidFilterSoundsResetNotify = Notification.Name(PaidBeatFilterSoundsResetNotificationKey)

//MARK: - Filter Side Navigation

var paidfilterTableHeight:CGFloat = 125
var paidfilterKeyTableHeight: CGFloat = 160
var paidprevFilterTableHeight:CGFloat = 40
var paidfilterKeyTextFieldCode = 1
var paidkeyfliteringCode = 0
var paidtempofilteringCode = 0
var paidtypefilteringCode = 0
var paidsoundsfilteringCode = 0
var paidproducersfilteringCode = 0

var paidallTypeFilteringCode = 0
var paiddarkTypeFilteringCode = 0
var paidmelodicTypeFilteringCode = 0
var paidaggressiveTypeFilteringCode = 0
var paidsmoothTypeFilteringCode = 0
var paidrAndBTypeFilteringCode = 0
var paidvibeyTypeFilteringCode = 0
var paidclubTypeFilteringCode = 0
var paidjoyfulTypeFilteringCode = 0
var paidsoulfulTypeFilteringCode = 0
var paidexperimentalTypeFilteringCode = 0
var paidrelaxedTypeFilteringCode = 0
var paidcalmTypeFilteringCode = 0
var paidepicTypeFilteringCode = 0
var paidsimpleTypeFilteringCode = 0
var paidtrapTypeFilteringCode = 0

var paidallSoundsFilteringCode = 0
var paidkeysSoundFilteringCode = 0
var paidpianoRhodesSoundFilteringCode = 0
var paidpianoElectricSoundFilteringCode = 0
var paidpianoAcousticSoundFilteringCode = 0
var paidpianoVinylSoundFilteringCode = 0
var paidorganSoundFilteringCode = 0
var paidtheraminSoundFilteringCode = 0
var paidwhistleSoundFilteringCode = 0
var paidhornsSoundFilteringCode = 0
var paidstringsSoundFilteringCode = 0
var paidfluteSoundFilteringCode = 0
var paidpadBellSoundFilteringCode = 0
var paidpadHollowSoundFilteringCode = 0
var paidpadAggressiveSoundFilteringCode = 0
var paidchoirSoundFilteringCode = 0
var paidsaxophoneSoundFilteringCode = 0
var paidguitarElectricSoundFilteringCode = 0
var paidguitarAcousticSoundFilteringCode = 0
var paidguitarSteelSoundFilteringCode = 0
var paidbellsEDMSoundFilteringCode = 0
var paidbellsVinylSoundFilteringCode = 0
var paidbellsGothicSoundFilteringCode = 0
var paidbellsHollowSoundFilteringCode = 0
var paidbellsMusicBoxSoundFilteringCode = 0
var paidsampleVocalSoundFilteringCode = 0
var paidsampleSongSoundFilteringCode = 0
var paidnoKickSoundFilteringCode = 0
var paidkickSoundFilteringCode = 0
var paidlong808SoundFilteringCode = 0
var paidshort808SoundFilteringCode = 0
var paidclean808SoundFilteringCode = 0
var paiddistorted808SoundFilteringCode = 0
var paidmoogBassSoundFilteringCode = 0
var paidsubBassSoundFilteringCode = 0
var paidsynthBassDistortedSoundFilteringCode = 0
var paidsnapSoundFilteringCode = 0
var paidsynthBassDeepSoundFilteringCode = 0

class PaidMenuListController: UITableViewController {
    
    static var shared = PaidMenuListController()
    
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
            paidfilterKeyTableHeight = 160
            paidprevFilterTableHeight = 40
        //}
        tableView.endUpdates()
    }
    
    deinit {
        print("📗paid filter controller Deallocated")
    }

    
    @IBAction func addAnotherKeyTapped(_ sender: Any) {
        tableView.beginUpdates()
        paidfilterKeyTableHeight += paidprevFilterTableHeight
        //NotificationCenter.default.post(name: FilterKeyPickerAddedNotify, object: nil)
        tableView.endUpdates()
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.row == 0 {
            paidfilterTableHeight = 215
        }
        if indexPath.row == 1 {
            paidfilterTableHeight = paidfilterKeyTableHeight
        }
        if indexPath.row == 2 {
            paidfilterTableHeight = 340
        }
        if indexPath.row == 3 {
            paidfilterTableHeight = 860
        }
        return paidfilterTableHeight//Your custom row height
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let array = items[indexPath.row]
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "paidtempoCell", for: indexPath) as! PaidFilterTempoTableCellController
            cell.funcSetTemp(array: array)
            return cell
        }
        else if indexPath.row == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "paidkeyCell", for: indexPath) as! PaidFilterKeyTableCellController
            cell.funcSetTemp(array: array)
            return cell
        } else if indexPath.row == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "paidtypeCell", for: indexPath) as! PaidFilterTypeTableCellController
            cell.funcSetTemp(array: array)
            return cell
        } else /*if indexPath.row == 3*/ {
            let cell = tableView.dequeueReusableCell(withIdentifier: "paidsoundsCell", for: indexPath) as! PaidFilterSoundsTableCellController
            cell.funcSetTemp(array: array)
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        //hardFilterKeyReset == false
        
        if indexPath.row == 0 {
            if paidtempofilteringCode == 0 {
                print("tempo row toggled")
                paidnumberOfActiveFilterCells+=1
                print("number of active filter cells = \(paidnumberOfActiveFilterCells)")
                paidtempofilteringCode=1
                print("tempo filtering code/ is tempo on or off = \(paidtempofilteringCode)")
            } else if paidtempofilteringCode == 1 {
                paidnumberOfActiveFilterCells-=1
                print("number of active filter cells = \(paidnumberOfActiveFilterCells)")
                paidtempofilteringCode=0
                print("tempo filtering code/ is tempo on or off = \(paidtempofilteringCode)")
            }
               NotificationCenter.default.post(name: PaidFilterIndex0Notify, object: nil)
        }
        if indexPath.row == 1 {
            if paidkeyfliteringCode == 0 {
                paidnumberOfActiveFilterCells+=1
                print("number of active filter cells = \(paidnumberOfActiveFilterCells)")
                paidkeyfliteringCode=1
            } else if paidkeyfliteringCode == 1 {
                paidnumberOfActiveFilterCells-=1
                print("number of active filter cells = \(paidnumberOfActiveFilterCells)")
                paidkeyfliteringCode=0
            }
                NotificationCenter.default.post(name: PaidFilterIndex1Notify, object: nil)
        }
        if indexPath.row == 2 {
            if paidtypefilteringCode == 0 {
                paidnumberOfActiveFilterCells+=1
                print("number of active filter cells = \(paidnumberOfActiveFilterCells)")
                paidtypefilteringCode=1
                print("type filtering code/ is type on or off = \(paidtypefilteringCode)")
                print("Filtering code for all type boxes added up: \(paidallTypeFilteringCode)")
            } else if paidtypefilteringCode == 1 {
                paidnumberOfActiveFilterCells-=1
                print("number of active filter cells = \(paidnumberOfActiveFilterCells)")
                paidtypefilteringCode=0
                print("type filtering code/ is type on or off = \(paidtypefilteringCode)")
                print("Filtering code for all type boxes added up: \(paidallTypeFilteringCode)")
            }
                NotificationCenter.default.post(name: PaidFilterIndex2Notify, object: nil)
        }
        if indexPath.row == 3 {
            if paidsoundsfilteringCode == 0 {
                paidnumberOfActiveFilterCells+=1
                print("number of active filter cells = \(paidnumberOfActiveFilterCells)")
                paidsoundsfilteringCode=1
                print("sound filtering code/ is type on or off = \(paidsoundsfilteringCode)")
                print("Filtering code for all sound boxes added up: \(paidallSoundsFilteringCode)")
            } else if paidsoundsfilteringCode == 1 {
                paidnumberOfActiveFilterCells-=1
                print("number of active filter cells = \(paidnumberOfActiveFilterCells)")
                paidsoundsfilteringCode=0
                print("sounds filtering code/ is type on or off = \(paidsoundsfilteringCode)")
                print("Filtering code for all sound boxes added up: \(paidallSoundsFilteringCode)")
            }
                NotificationCenter.default.post(name: PaidFilterIndex3Notify, object: nil)
        }
    }
}













//MARK: - TEMPO CELL



class PaidFilterTempoTableCellController: UITableViewCell {
    
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
        NotificationCenter.default.addObserver(self, selector: #selector(PaidFilterTempoTableCellController.tempofiltering), name: PaidFilterIndex0Notify, object: nil)
    }
    
    @objc func tempofiltering() {
        if paidtempofilteringCode == 1 {
            tempoCellBadge.alpha = 1
        } else if paidtempofilteringCode == 0 {
            tempoCellBadge.alpha = 0
        }
        NotificationCenter.default.post(name: PaidFilterTempoStatusNotify, object: nil)
    }

    @IBAction func tempoSliderChanged(_ sender: Any) {
        MultiSliderSubStrings.shared.getTempoIndexes(thumb: filterTempoSlider.draggedThumbIndex, valueLabelJibberish: filterTempoSlider.valueLabels, completion: { [weak self] thumb, slidervalue in
            guard let strongSelf = self else {
                return
            }
            print("tempo slider modified")
            if paidtempofilteringCode == 0 {
                print("tempo cell was not active, adding 1 to set to on")
                paidnumberOfActiveFilterCells+=1
                print("number of active filter cells = \(paidnumberOfActiveFilterCells)")
            }
            paidcurrentTempoChoiceChanged = 0
            print("current tempo choiced used is slider: = \(paidcurrentTempoChoiceChanged)")
            strongSelf.tempoCellBadge.alpha = 1
            paidtempofilteringCode = 1
            print("tempo filtering code/ is tempo on or off = \(paidtempofilteringCode)")
            strongSelf.textFieldTempo.alpha = 0.4
            strongSelf.specifiedTempoLabel.alpha = 0.4
            if paidlastTempoChoiceChanged != paidcurrentTempoChoiceChanged {
                strongSelf.filterTempoSlider.alpha = 1
            }
            
            if thumb == 0 {
                print("Min thumb slider at \(slidervalue)")
                NotificationCenter.default.post(name: PaidFilterTempoMinNotify, object: slidervalue)
            } else if thumb == 1 {
                print("Max thumb slider at \(slidervalue)")
                NotificationCenter.default.post(name: PaidFilterTempoMaxNotify, object: slidervalue)
                
            }
            
        })
    }
    @IBAction func resetButtonTapped(_ sender: Any) {
        tempoCellBadge.alpha = 0
        filterTempoSlider.alpha = 1
        textFieldTempo.alpha = 0.4
        specifiedTempoLabel.alpha = 0.4
        filterTempoSlider.value = [50,200]
        if paidnumberOfActiveFilterCells != 0 && paidtempofilteringCode == 1{
            paidnumberOfActiveFilterCells-=1
        }
        textFieldTempo.text = ""
        paidtempofilteringCode = 0
        NotificationCenter.default.post(name: PaidFilterTempoResetNotify, object: nil)
        
    }
    
}

extension PaidFilterTempoTableCellController: UIPickerViewDelegate, UIPickerViewDataSource {
    
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
        paidcurrentTempoChoiceChanged = 1
        print("tempo exact picker modified")
        print("current tempo choiced used is exact: = \(paidcurrentTempoChoiceChanged)")
        if paidtempofilteringCode == 0 {
            print("tempo cell was not active, adding 1 to set to on")
            paidnumberOfActiveFilterCells+=1
            print("number of active filter cells = \(paidnumberOfActiveFilterCells)")
        }
        tempoCellBadge.alpha = 1
        paidtempofilteringCode = 1
        print("tempo filtering code/ is tempo on or off = \(paidtempofilteringCode)")
        filterTempoSlider.alpha = 0.4
        if paidlastTempoChoiceChanged != paidcurrentTempoChoiceChanged {
            textFieldTempo.alpha = 1
            specifiedTempoLabel.alpha = 1
        }
            textFieldTempo.text = String(tempo[row])
        NotificationCenter.default.post(name: PaidFilterTempoSpecifiedNotify, object: tempo[row])
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


class PaidFilterKeyTableCellController: UITableViewCell {
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
        NotificationCenter.default.addObserver(self, selector: #selector(PaidFilterKeyTableCellController.keyfiltering), name: PaidFilterIndex1Notify, object: nil)
  }
    
    @objc func keyfiltering() {
        if paidkeyfliteringCode == 1 {
            keyBadge.alpha = 1
        } else if paidkeyfliteringCode == 0 {
            keyBadge.alpha = 0
            
        }
        NotificationCenter.default.post(name: PaidFilterKeyStatusNotify, object: nil)
    }
       
    @objc func addPicker(notification: NSNotification) {
        addPickerSetup()
    }

    func addPickerSetup() {
        print("adding text")
        addAnotherKeyStack.isHidden = true
        switch paidfilterKeyTextFieldCode {
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
        paidfilterKeyTextFieldCode+=1
        print(paidfilterKeyTextFieldCode)
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
        
        paidfilterKeyTextFieldCode = 1

        if paidnumberOfActiveFilterCells != 0 && paidkeyfliteringCode == 1 {
            paidnumberOfActiveFilterCells-=1
        }
        paidkeyfliteringCode = 0
        //hardFilterKeyReset == true
        keyBadge.alpha = 0
        //addAnotherKeyStack.isHidden = true
        
        NotificationCenter.default.post(name: PaidFilterKeyPickerResetNotify, object: nil)
    }
    
}

extension PaidFilterKeyTableCellController: UIPickerViewDelegate, UIPickerViewDataSource {
    
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
        if paidkeyfliteringCode == 0 {
            print("key cell was not active, adding 1 to set to on")
            paidnumberOfActiveFilterCells+=1
            print("number of active filter cells = \(paidnumberOfActiveFilterCells)")
        }
        paidkeyfliteringCode = 1
        print("key filtering code/ is key on or off = \(paidkeyfliteringCode)")
        
        if textFieldBeatKey.isEditing {
            textFieldBeatKey.text = keystemp[row]
            NotificationCenter.default.post(name: PaidFilterKeyChangedNotify, object: keystemp[row])
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
        if paidfilterKeyTableHeight > 541{
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

extension PaidFilterKeyTableCellController: UITextFieldDelegate {
    
    public func textFieldShouldClear(_ textField: UITextField) -> Bool {
        addAnotherKeyStack.isHidden = true
        return true
    }
}












//MARK: - TYPE CELL



class PaidFilterTypeTableCellController: UITableViewCell {
    
    
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
        NotificationCenter.default.addObserver(self, selector: #selector(PaidFilterTypeTableCellController.typefiltering), name: PaidFilterIndex2Notify, object: nil)
    }
    
    @objc func typefiltering() {
        if paidtypefilteringCode == 1 {
            typeBadge.alpha = 1
        } else if paidtypefilteringCode == 0 {
            typeBadge.alpha = 0
            
        }
        NotificationCenter.default.post(name: PaidFilterTypeStatusNotify, object: nil)
    }
    
    @IBAction func filterTypeResetButtonTapped(_ sender: Any) {
        if paidnumberOfActiveFilterCells != 0 && paidtypefilteringCode == 1 {
            paidnumberOfActiveFilterCells-=1
        }
        paidtypefilteringCode = 0
        paidallTypeFilteringCode = 0
        paiddarkTypeFilteringCode = 0
        paidmelodicTypeFilteringCode = 0
        paidaggressiveTypeFilteringCode = 0
        paidsmoothTypeFilteringCode = 0
        paidrAndBTypeFilteringCode = 0
        paidvibeyTypeFilteringCode = 0
        paidclubTypeFilteringCode = 0
        paidjoyfulTypeFilteringCode = 0
        paidsoulfulTypeFilteringCode = 0
        paidexperimentalTypeFilteringCode = 0
        paidrelaxedTypeFilteringCode = 0
        paidcalmTypeFilteringCode = 0
        paidepicTypeFilteringCode = 0
        paidsimpleTypeFilteringCode = 0
        paidtrapTypeFilteringCode = 0
        
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
        
        NotificationCenter.default.post(name: PaidFilterTypeResetNotify, object: nil)
    }
    
    @IBAction func DarkTypeChanged(_ sender: Any) {
        typeBadge.alpha = 1
        if paiddarkTypeFilteringCode == 0 {
            if paidtypefilteringCode == 0 {
                paidnumberOfActiveFilterCells+=1
                print("Number of active filtering cells is: \(paidnumberOfActiveFilterCells)")
            }
            paidtypefilteringCode = 1
            print("type filtering cell is active, type filtering code is: \(paidtypefilteringCode)")
            paidallTypeFilteringCode += 1
            print("Filtering code for all type boxes added up: \(paidallTypeFilteringCode)")
            paiddarkTypeFilteringCode = 1
            print("Dark type filtering activated, type filtering code is: \(paiddarkTypeFilteringCode)")
        } else if paiddarkTypeFilteringCode == 1 {
            if paidallTypeFilteringCode > 1 {
                if paidtypefilteringCode == 0 {
                    typeBadge.alpha = 1
                    paidtypefilteringCode = 1
                    paidnumberOfActiveFilterCells+=1
                    print("Number of active filtering cells is: \(paidnumberOfActiveFilterCells)")
                }
            }
            if paidallTypeFilteringCode == 1 {
                typeBadge.alpha = 0
                paidtypefilteringCode = 0
                if paidnumberOfActiveFilterCells != 0 {
                    paidnumberOfActiveFilterCells-=1
                }
                print("Number of active filtering cells is: \(paidnumberOfActiveFilterCells)")
                print("No type filter checkboxes active, type filtering code is: \(paidtypefilteringCode)")
                print("No type filter checkboxes active, alltypefiltering code is: \(paidallTypeFilteringCode-1)")
            }
            paidallTypeFilteringCode -= 1
            print("Filtering code for all type boxes added up: \(paidallTypeFilteringCode)")
            paiddarkTypeFilteringCode = 0
            print("Melodic type filtering deactivated, type filtering code is: \(paiddarkTypeFilteringCode)")
        }
        NotificationCenter.default.post(name: PaidFilterTypeChangedNotify, object: "Dark")
    }
    
    @IBAction func melodicTypeChanged(_ sender: Any) {
        typeBadge.alpha = 1
        if paidmelodicTypeFilteringCode == 0 {
            if paidtypefilteringCode == 0 {
                paidnumberOfActiveFilterCells+=1
                print("Number of active filtering cells is: \(paidnumberOfActiveFilterCells)")
            }
            paidtypefilteringCode = 1
            print("type filtering cell is active, type filtering code is: \(paidtypefilteringCode)")
            paidallTypeFilteringCode += 1
            print("Filtering code for all type boxes added up: \(paidallTypeFilteringCode)")
            paidmelodicTypeFilteringCode = 1
            print("Melodic type filtering activated, type filtering code is: \(paidmelodicTypeFilteringCode)")
        } else if paidmelodicTypeFilteringCode == 1 {
            if paidallTypeFilteringCode > 1 {
                if paidtypefilteringCode == 0 {
                    typeBadge.alpha = 1
                    paidtypefilteringCode = 1
                    paidnumberOfActiveFilterCells+=1
                    print("Number of active filtering cells is: \(paidnumberOfActiveFilterCells)")
                }
            }
            if paidallTypeFilteringCode == 1 {
                typeBadge.alpha = 0
                paidtypefilteringCode = 0
                if paidnumberOfActiveFilterCells != 0 {
                    paidnumberOfActiveFilterCells-=1
                }
                print("Number of active filtering cells is: \(paidnumberOfActiveFilterCells)")
                print("No type filter checkboxes active, type filtering code is: \(paidtypefilteringCode)")
                print("No type filter checkboxes active, alltypefiltering code is: \(paidallTypeFilteringCode)")
            }
            paidallTypeFilteringCode -= 1
            print("Filtering code for all type boxes added up: \(paidallTypeFilteringCode)")
            paidmelodicTypeFilteringCode = 0
            print("Melodic type filtering deactivated, type filtering code is: \(paidmelodicTypeFilteringCode)")
        }
        NotificationCenter.default.post(name: PaidFilterTypeChangedNotify, object: "Melodic")
    }
    
    @IBAction func aggressiveTypeChanged(_ sender: Any) {
        typeBadge.alpha = 1
        if paidaggressiveTypeFilteringCode == 0 {
            if paidtypefilteringCode == 0 {
                paidnumberOfActiveFilterCells+=1
                print("Number of active filtering cells is: \(paidnumberOfActiveFilterCells)")
            }
            paidtypefilteringCode = 1
            print("type filtering cell is active, type filtering code is: \(paidtypefilteringCode)")
            paidallTypeFilteringCode += 1
            print("Filtering code for all type boxes added up: \(paidallTypeFilteringCode)")
            paidaggressiveTypeFilteringCode = 1
        } else if paidaggressiveTypeFilteringCode == 1 {
            if paidallTypeFilteringCode > 1 {
                if paidtypefilteringCode == 0 {
                    typeBadge.alpha = 1
                    paidtypefilteringCode = 1
                    paidnumberOfActiveFilterCells+=1
                    print("Number of active filtering cells is: \(paidnumberOfActiveFilterCells)")
                }
            }
            if paidallTypeFilteringCode == 1 {
                typeBadge.alpha = 0
                paidtypefilteringCode = 0
                if paidnumberOfActiveFilterCells != 0 {
                    paidnumberOfActiveFilterCells-=1
                }
                print("Number of active filtering cells is: \(paidnumberOfActiveFilterCells)")
                print("No type filter checkboxes active, type filtering code is: \(paidtypefilteringCode)")
                print("No type filter checkboxes active, alltypefiltering code is: \(paidallTypeFilteringCode)")
            }
            paidallTypeFilteringCode -= 1
            print("Filtering code for all type boxes added up: \(allTypeFilteringCode)")
            paidaggressiveTypeFilteringCode = 0
        }
        NotificationCenter.default.post(name: PaidFilterTypeChangedNotify, object: "Aggressive")
    }
    
    @IBAction func smoothTypeChanged(_ sender: Any) {
        typeBadge.alpha = 1
        if paidsmoothTypeFilteringCode == 0 {
            if paidtypefilteringCode == 0 {
                paidnumberOfActiveFilterCells+=1
                print("Number of active filtering cells is: \(paidnumberOfActiveFilterCells)")
            }
            paidtypefilteringCode = 1
            print("type filtering cell is active, type filtering code is: \(paidtypefilteringCode)")
            paidallTypeFilteringCode += 1
            print("Filtering code for all type boxes added up: \(paidallTypeFilteringCode)")
            paidsmoothTypeFilteringCode = 1
        } else if paidsmoothTypeFilteringCode == 1 {
            if paidallTypeFilteringCode > 1 {
                if paidtypefilteringCode == 0 {
                    typeBadge.alpha = 1
                    paidtypefilteringCode = 1
                    paidnumberOfActiveFilterCells+=1
                    print("Number of active filtering cells is: \(paidnumberOfActiveFilterCells)")
                }
            }
            if paidallTypeFilteringCode == 1 {
                typeBadge.alpha = 0
                paidtypefilteringCode = 0
                if paidnumberOfActiveFilterCells != 0 {
                    paidnumberOfActiveFilterCells-=1
                }
                print("Number of active filtering cells is: \(paidnumberOfActiveFilterCells)")
                print("No type filter checkboxes active, type filtering code is: \(paidtypefilteringCode)")
                print("No type filter checkboxes active, alltypefiltering code is: \(paidallTypeFilteringCode)")
            }
            paidallTypeFilteringCode -= 1
            print("Filtering code for all type boxes added up: \(paidallTypeFilteringCode)")
            paidsmoothTypeFilteringCode = 0
        }
        NotificationCenter.default.post(name: PaidFilterTypeChangedNotify, object: "Smooth")
    }
    
    @IBAction func rAndBTypeChanged(_ sender: Any) {
        typeBadge.alpha = 1
        if paidrAndBTypeFilteringCode == 0 {
            if paidtypefilteringCode == 0 {
                paidnumberOfActiveFilterCells+=1
                print("Number of active filtering cells is: \(paidnumberOfActiveFilterCells)")
            }
            paidtypefilteringCode = 1
            print("type filtering cell is active, type filtering code is: \(paidtypefilteringCode)")
            paidallTypeFilteringCode += 1
            print("Filtering code for all type boxes added up: \(paidallTypeFilteringCode)")
            paidrAndBTypeFilteringCode = 1
        } else if paidrAndBTypeFilteringCode == 1 {
            if paidallTypeFilteringCode > 1 {
                if paidtypefilteringCode == 0 {
                    typeBadge.alpha = 1
                    paidtypefilteringCode = 1
                    paidnumberOfActiveFilterCells+=1
                    print("Number of active filtering cells is: \(paidnumberOfActiveFilterCells)")
                }
            }
            if paidallTypeFilteringCode == 1 {
                typeBadge.alpha = 0
                paidtypefilteringCode = 0
                if paidnumberOfActiveFilterCells != 0 {
                    paidnumberOfActiveFilterCells-=1
                }
                print("Number of active filtering cells is: \(paidnumberOfActiveFilterCells)")
                print("No type filter checkboxes active, type filtering code is: \(paidtypefilteringCode)")
                print("No type filter checkboxes active, alltypefiltering code is: \(paidallTypeFilteringCode)")
            }
            paidallTypeFilteringCode -= 1
            print("Filtering code for all type boxes added up: \(paidallTypeFilteringCode)")
            paidrAndBTypeFilteringCode = 0
        }
        NotificationCenter.default.post(name: PaidFilterTypeChangedNotify, object: "R&B")
    }
    
    @IBAction func vibeyTypeChanged(_ sender: Any) {
        typeBadge.alpha = 1
        if paidvibeyTypeFilteringCode == 0 {
            if paidtypefilteringCode == 0 {
                paidnumberOfActiveFilterCells+=1
                print("Number of active filtering cells is: \(paidnumberOfActiveFilterCells)")
            }
            paidtypefilteringCode = 1
            print("type filtering cell is active, type filtering code is: \(paidtypefilteringCode)")
            paidallTypeFilteringCode += 1
            print("Filtering code for all type boxes added up: \(paidallTypeFilteringCode)")
            paidvibeyTypeFilteringCode = 1
        } else if paidvibeyTypeFilteringCode == 1 {
            if paidallTypeFilteringCode > 1 {
                if paidtypefilteringCode == 0 {
                    typeBadge.alpha = 1
                    paidtypefilteringCode = 1
                    paidnumberOfActiveFilterCells+=1
                    print("Number of active filtering cells is: \(paidnumberOfActiveFilterCells)")
                }
            }
            if paidallTypeFilteringCode == 1 {
                typeBadge.alpha = 0
                paidtypefilteringCode = 0
                if paidnumberOfActiveFilterCells != 0 {
                    paidnumberOfActiveFilterCells-=1
                }
                print("Number of active filtering cells is: \(paidnumberOfActiveFilterCells)")
                print("No type filter checkboxes active, type filtering code is: \(paidtypefilteringCode)")
                print("No type filter checkboxes active, alltypefiltering code is: \(paidallTypeFilteringCode)")
            }
            paidallTypeFilteringCode -= 1
            print("Filtering code for all type boxes added up: \(paidallTypeFilteringCode)")
            paidvibeyTypeFilteringCode = 0
        }
        NotificationCenter.default.post(name: PaidFilterTypeChangedNotify, object: "Vibey")
    }
    
    @IBAction func clubTypeChanged(_ sender: Any) {
        typeBadge.alpha = 1
        if paidclubTypeFilteringCode == 0 {
            if paidtypefilteringCode == 0 {
                paidnumberOfActiveFilterCells+=1
                print("Number of active filtering cells is: \(paidnumberOfActiveFilterCells)")
            }
            paidtypefilteringCode = 1
            print("type filtering cell is active, type filtering code is: \(paidtypefilteringCode)")
            paidallTypeFilteringCode += 1
            print("Filtering code for all type boxes added up: \(paidallTypeFilteringCode)")
            paidclubTypeFilteringCode = 1
        } else if paidclubTypeFilteringCode == 1 {
            if paidallTypeFilteringCode > 1 {
                if paidtypefilteringCode == 0 {
                    typeBadge.alpha = 1
                    paidtypefilteringCode = 1
                    paidnumberOfActiveFilterCells+=1
                    print("Number of active filtering cells is: \(paidnumberOfActiveFilterCells)")
                }
            }
            if paidallTypeFilteringCode == 1 {
                typeBadge.alpha = 0
                paidtypefilteringCode = 0
                if paidnumberOfActiveFilterCells != 0 {
                    paidnumberOfActiveFilterCells-=1
                }
                print("Number of active filtering cells is: \(paidnumberOfActiveFilterCells)")
                print("No type filter checkboxes active, type filtering code is: \(paidtypefilteringCode)")
                print("No type filter checkboxes active, alltypefiltering code is: \(paidallTypeFilteringCode)")
            }
            paidallTypeFilteringCode -= 1
            print("Filtering code for all type boxes added up: \(allTypeFilteringCode)")
            paidclubTypeFilteringCode = 0
        }
        NotificationCenter.default.post(name: PaidFilterTypeChangedNotify, object: "Club")
    }
    
    @IBAction func joyfulTypeChanged(_ sender: Any) {
        typeBadge.alpha = 1
        if paidjoyfulTypeFilteringCode == 0 {
            if paidtypefilteringCode == 0 {
                paidnumberOfActiveFilterCells+=1
                print("Number of active filtering cells is: \(paidnumberOfActiveFilterCells)")
            }
            paidtypefilteringCode = 1
            print("type filtering cell is active, type filtering code is: \(paidtypefilteringCode)")
            paidallTypeFilteringCode += 1
            print("Filtering code for all type boxes added up: \(paidallTypeFilteringCode)")
            paidjoyfulTypeFilteringCode = 1
        } else if paidjoyfulTypeFilteringCode == 1 {
            if paidallTypeFilteringCode > 1 {
                if paidtypefilteringCode == 0 {
                    typeBadge.alpha = 1
                    paidtypefilteringCode = 1
                    paidnumberOfActiveFilterCells+=1
                    print("Number of active filtering cells is: \(paidnumberOfActiveFilterCells)")
                }
            }
            if paidallTypeFilteringCode == 1 {
                typeBadge.alpha = 0
                paidtypefilteringCode = 0
                if paidnumberOfActiveFilterCells != 0 {
                    paidnumberOfActiveFilterCells-=1
                }
                print("Number of active filtering cells is: \(paidnumberOfActiveFilterCells)")
                print("No type filter checkboxes active, type filtering code is: \(paidtypefilteringCode)")
                print("No type filter checkboxes active, alltypefiltering code is: \(paidallTypeFilteringCode)")
            }
            paidallTypeFilteringCode -= 1
            print("Filtering code for all type boxes added up: \(paidallTypeFilteringCode)")
            paidjoyfulTypeFilteringCode = 0
        }
        NotificationCenter.default.post(name: PaidFilterTypeChangedNotify, object: "Joyful")
    }
    
    @IBAction func soulfulTypeChanged(_ sender: Any) {
        typeBadge.alpha = 1
        if paidsoulfulTypeFilteringCode == 0 {
            if paidtypefilteringCode == 0 {
                paidnumberOfActiveFilterCells+=1
                print("Number of active filtering cells is: \(paidnumberOfActiveFilterCells)")
            }
            paidtypefilteringCode = 1
            print("type filtering cell is active, type filtering code is: \(paidtypefilteringCode)")
            paidallTypeFilteringCode += 1
            print("Filtering code for all type boxes added up: \(paidallTypeFilteringCode)")
            paidsoulfulTypeFilteringCode = 1
        } else if paidsoulfulTypeFilteringCode == 1 {
            if paidallTypeFilteringCode > 1 {
                if paidtypefilteringCode == 0 {
                    typeBadge.alpha = 1
                    paidtypefilteringCode = 1
                    paidnumberOfActiveFilterCells+=1
                    print("Number of active filtering cells is: \(paidnumberOfActiveFilterCells)")
                }
            }
            if paidallTypeFilteringCode == 1 {
                typeBadge.alpha = 0
                paidtypefilteringCode = 0
                if paidnumberOfActiveFilterCells != 0 {
                    paidnumberOfActiveFilterCells-=1
                }
                print("Number of active filtering cells is: \(paidnumberOfActiveFilterCells)")
                print("No type filter checkboxes active, type filtering code is: \(paidtypefilteringCode)")
                print("No type filter checkboxes active, alltypefiltering code is: \(paidallTypeFilteringCode)")
            }
            paidallTypeFilteringCode -= 1
            print("Filtering code for all type boxes added up: \(paidallTypeFilteringCode)")
            paidsoulfulTypeFilteringCode = 0
        }
        NotificationCenter.default.post(name: PaidFilterTypeChangedNotify, object: "Soulful")
    }
    
    @IBAction func experimentalTypeChanged(_ sender: Any) {
        typeBadge.alpha = 1
        if paidexperimentalTypeFilteringCode == 0 {
            if paidtypefilteringCode == 0 {
                paidnumberOfActiveFilterCells+=1
                print("Number of active filtering cells is: \(paidnumberOfActiveFilterCells)")
            }
            paidtypefilteringCode = 1
            print("type filtering cell is active, type filtering code is: \(paidtypefilteringCode)")
            paidallTypeFilteringCode += 1
            print("Filtering code for all type boxes added up: \(paidallTypeFilteringCode)")
            paidexperimentalTypeFilteringCode = 1
        } else if paidexperimentalTypeFilteringCode == 1 {
            if paidallTypeFilteringCode > 1 {
                if paidtypefilteringCode == 0 {
                    typeBadge.alpha = 1
                    paidtypefilteringCode = 1
                    paidnumberOfActiveFilterCells+=1
                    print("Number of active filtering cells is: \(paidnumberOfActiveFilterCells)")
                }
            }
            if paidallTypeFilteringCode == 1 {
                typeBadge.alpha = 0
                paidtypefilteringCode = 0
                if paidnumberOfActiveFilterCells != 0 {
                    paidnumberOfActiveFilterCells-=1
                }
                print("Number of active filtering cells is: \(paidnumberOfActiveFilterCells)")
                print("No type filter checkboxes active, type filtering code is: \(paidtypefilteringCode)")
                print("No type filter checkboxes active, alltypefiltering code is: \(paidallTypeFilteringCode)")
            }
            paidallTypeFilteringCode -= 1
            print("Filtering code for all type boxes added up: \(paidallTypeFilteringCode)")
            paidexperimentalTypeFilteringCode = 0
        }
        NotificationCenter.default.post(name: PaidFilterTypeChangedNotify, object: "Experimental")
    }
    
    @IBAction func relaxedTypeChanged(_ sender: Any) {
        typeBadge.alpha = 1
        if paidrelaxedTypeFilteringCode == 0 {
            if paidtypefilteringCode == 0 {
                paidnumberOfActiveFilterCells+=1
                print("Number of active filtering cells is: \(paidnumberOfActiveFilterCells)")
            }
            paidtypefilteringCode = 1
            print("type filtering cell is active, type filtering code is: \(paidtypefilteringCode)")
            paidallTypeFilteringCode += 1
            print("Filtering code for all type boxes added up: \(paidallTypeFilteringCode)")
            paidrelaxedTypeFilteringCode = 1
        } else if paidrelaxedTypeFilteringCode == 1 {
            if paidallTypeFilteringCode > 1 {
                if paidtypefilteringCode == 0 {
                    typeBadge.alpha = 1
                    paidtypefilteringCode = 1
                    paidnumberOfActiveFilterCells+=1
                    print("Number of active filtering cells is: \(paidnumberOfActiveFilterCells)")
                }
            }
            if paidallTypeFilteringCode == 1 {
                typeBadge.alpha = 0
                paidtypefilteringCode = 0
                if paidnumberOfActiveFilterCells != 0 {
                    paidnumberOfActiveFilterCells-=1
                }
                print("Number of active filtering cells is: \(paidnumberOfActiveFilterCells)")
                print("No type filter checkboxes active, type filtering code is: \(paidtypefilteringCode)")
                print("No type filter checkboxes active, alltypefiltering code is: \(paidallTypeFilteringCode)")
            }
            paidallTypeFilteringCode -= 1
            print("Filtering code for all type boxes added up: \(paidallTypeFilteringCode)")
            paidrelaxedTypeFilteringCode = 0
        }
        NotificationCenter.default.post(name: PaidFilterTypeChangedNotify, object: "Relaxed")
    }
    
    @IBAction func calmTypeChanged(_ sender: Any) {
        typeBadge.alpha = 1
        if paidcalmTypeFilteringCode == 0 {
            if paidtypefilteringCode == 0 {
                paidnumberOfActiveFilterCells+=1
                print("Number of active filtering cells is: \(paidnumberOfActiveFilterCells)")
            }
            paidtypefilteringCode = 1
            print("type filtering cell is active, type filtering code is: \(paidtypefilteringCode)")
            paidallTypeFilteringCode += 1
            print("Filtering code for all type boxes added up: \(paidallTypeFilteringCode)")
            paidcalmTypeFilteringCode = 1
        } else if paidcalmTypeFilteringCode == 1 {
            if paidallTypeFilteringCode > 1 {
                if paidtypefilteringCode == 0 {
                    typeBadge.alpha = 1
                    paidtypefilteringCode = 1
                    paidnumberOfActiveFilterCells+=1
                    print("Number of active filtering cells is: \(paidnumberOfActiveFilterCells)")
                }
            }
            if paidallTypeFilteringCode == 1 {
                typeBadge.alpha = 0
                paidtypefilteringCode = 0
                if paidnumberOfActiveFilterCells != 0 {
                    paidnumberOfActiveFilterCells-=1
                }
                print("Number of active filtering cells is: \(paidnumberOfActiveFilterCells)")
                print("No type filter checkboxes active, type filtering code is: \(paidtypefilteringCode)")
                print("No type filter checkboxes active, alltypefiltering code is: \(paidallTypeFilteringCode)")
            }
            paidallTypeFilteringCode -= 1
            print("Filtering code for all type boxes added up: \(paidallTypeFilteringCode)")
            paidcalmTypeFilteringCode = 0
        }
        NotificationCenter.default.post(name: PaidFilterTypeChangedNotify, object: "Calm")
    }
    
    @IBAction func epicTypeChanged(_ sender: Any) {
        typeBadge.alpha = 1
        if paidepicTypeFilteringCode == 0 {
            if paidtypefilteringCode == 0 {
                paidnumberOfActiveFilterCells+=1
                print("Number of active filtering cells is: \(paidnumberOfActiveFilterCells)")
            }
            paidtypefilteringCode = 1
            print("type filtering cell is active, type filtering code is: \(paidtypefilteringCode)")
            paidallTypeFilteringCode += 1
            print("Filtering code for all type boxes added up: \(paidallTypeFilteringCode)")
            paidepicTypeFilteringCode = 1
        } else if paidepicTypeFilteringCode == 1 {
            if paidallTypeFilteringCode > 1 {
                if paidtypefilteringCode == 0 {
                    typeBadge.alpha = 1
                    paidtypefilteringCode = 1
                    paidnumberOfActiveFilterCells+=1
                    print("Number of active filtering cells is: \(paidnumberOfActiveFilterCells)")
                }
            }
            if paidallTypeFilteringCode == 1 {
                typeBadge.alpha = 0
                paidtypefilteringCode = 0
                if paidnumberOfActiveFilterCells != 0 {
                    paidnumberOfActiveFilterCells-=1
                }
                print("Number of active filtering cells is: \(paidnumberOfActiveFilterCells)")
                print("No type filter checkboxes active, type filtering code is: \(paidtypefilteringCode)")
                print("No type filter checkboxes active, alltypefiltering code is: \(paidallTypeFilteringCode)")
            }
            paidallTypeFilteringCode -= 1
            print("Filtering code for all type boxes added up: \(paidallTypeFilteringCode)")
            paidepicTypeFilteringCode = 0
        }
        NotificationCenter.default.post(name: PaidFilterTypeChangedNotify, object: "Epic")
    }
    
    @IBAction func simpleTypeChanged(_ sender: Any) {
        typeBadge.alpha = 1
        if paidsimpleTypeFilteringCode == 0 {
            if paidtypefilteringCode == 0 {
                paidnumberOfActiveFilterCells+=1
                print("Number of active filtering cells is: \(paidnumberOfActiveFilterCells)")
            }
            paidtypefilteringCode = 1
            print("type filtering cell is active, type filtering code is: \(paidtypefilteringCode)")
            paidallTypeFilteringCode += 1
            print("Filtering code for all type boxes added up: \(paidallTypeFilteringCode)")
            paidsimpleTypeFilteringCode = 1
        } else if paidsimpleTypeFilteringCode == 1 {
            if paidallTypeFilteringCode > 1 {
                if paidtypefilteringCode == 0 {
                    typeBadge.alpha = 1
                    paidtypefilteringCode = 1
                    paidnumberOfActiveFilterCells+=1
                    print("Number of active filtering cells is: \(paidnumberOfActiveFilterCells)")
                }
            }
            if paidallTypeFilteringCode == 1 {
                typeBadge.alpha = 0
                paidtypefilteringCode = 0
                if paidnumberOfActiveFilterCells != 0 {
                    paidnumberOfActiveFilterCells-=1
                }
                print("Number of active filtering cells is: \(paidnumberOfActiveFilterCells)")
                print("No type filter checkboxes active, type filtering code is: \(paidtypefilteringCode)")
                print("No type filter checkboxes active, alltypefiltering code is: \(paidallTypeFilteringCode)")
            }
            paidallTypeFilteringCode -= 1
            print("Filtering code for all type boxes added up: \(paidallTypeFilteringCode)")
            paidsimpleTypeFilteringCode = 0
        }
        NotificationCenter.default.post(name: PaidFilterTypeChangedNotify, object: "Simple")
    }
    
    @IBAction func trapTypeChanged(_ sender: Any) {
        typeBadge.alpha = 1
        if paidtrapTypeFilteringCode == 0 {
            if paidtypefilteringCode == 0 {
                paidnumberOfActiveFilterCells+=1
                print("Number of active filtering cells is: \(paidnumberOfActiveFilterCells)")
            }
            paidtypefilteringCode = 1
            print("type filtering cell is active, type filtering code is: \(paidtypefilteringCode)")
            paidallTypeFilteringCode += 1
            print("Filtering code for all type boxes added up: \(paidallTypeFilteringCode)")
            paidtrapTypeFilteringCode = 1
        } else if paidtrapTypeFilteringCode == 1 {
            if paidallTypeFilteringCode > 1 {
                if paidtypefilteringCode == 0 {
                    typeBadge.alpha = 1
                    paidtypefilteringCode = 1
                    paidnumberOfActiveFilterCells+=1
                    print("Number of active filtering cells is: \(paidnumberOfActiveFilterCells)")
                }
            }
            if paidallTypeFilteringCode == 1 {
                typeBadge.alpha = 0
                paidtypefilteringCode = 0
                if paidnumberOfActiveFilterCells != 0 {
                    paidnumberOfActiveFilterCells-=1
                }
                print("Number of active filtering cells is: \(paidnumberOfActiveFilterCells)")
                print("No type filter checkboxes active, type filtering code is: \(paidtypefilteringCode)")
                print("No type filter checkboxes active, alltypefiltering code is: \(paidallTypeFilteringCode)")
            }
            paidallTypeFilteringCode -= 1
            print("Filtering code for all type boxes added up: \(paidallTypeFilteringCode)")
            paidtrapTypeFilteringCode = 0
        }
        NotificationCenter.default.post(name: PaidFilterTypeChangedNotify, object: "Trap")
    }
    
}












//MARK: - Sounds CELL



class PaidFilterSoundsTableCellController: UITableViewCell {
    
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
        NotificationCenter.default.addObserver(self, selector: #selector(PaidFilterSoundsTableCellController.soundfiltering), name: PaidFilterIndex3Notify, object: nil)
    }

    @objc func soundfiltering() {
        if paidsoundsfilteringCode == 1 {
            soundsBadge.alpha = 1
        } else if paidsoundsfilteringCode == 0 {
            soundsBadge.alpha = 0

        }
        NotificationCenter.default.post(name: PaidFilterSoundsStatusNotify, object: nil)
    }
    
    
    @IBAction func keysSoundCheckBoxTapped(_ sender: Any) {
        soundsBadge.alpha = 1
        if paidkeysSoundFilteringCode == 0 {
            if paidsoundsfilteringCode == 0 {
                paidnumberOfActiveFilterCells+=1
                print("Number of active filtering cells is: \(paidnumberOfActiveFilterCells)")
            }
            paidsoundsfilteringCode = 1
            print("sounds filtering cell is active, sounds filtering code is: \(paidsoundsfilteringCode)")
            paidallSoundsFilteringCode += 1
            print("Filtering code for all sounds boxes added up: \(paidallSoundsFilteringCode)")
            paidkeysSoundFilteringCode = 1
        } else if paidkeysSoundFilteringCode == 1 {
            if paidallSoundsFilteringCode > 1 {
                if paidsoundsfilteringCode == 0 {
                    soundsBadge.alpha = 1
                    paidsoundsfilteringCode = 1
                    paidnumberOfActiveFilterCells+=1
                    print("Number of active filtering cells is: \(paidnumberOfActiveFilterCells)")
                }
            }
            if paidallSoundsFilteringCode == 1 {
                soundsBadge.alpha = 0
                paidsoundsfilteringCode = 0
                if paidnumberOfActiveFilterCells != 0 {
                    paidnumberOfActiveFilterCells-=1
                }
                print("Number of active filtering cells is: \(paidnumberOfActiveFilterCells)")
                print("No sounds filter checkboxes active, sounds filtering code is: \(paidsoundsfilteringCode)")
                print("No sounds filter checkboxes active, allsoundsfiltering code is: \(paidallSoundsFilteringCode)")
            }
            paidallSoundsFilteringCode -= 1
            print("Filtering code for all type boxes added up: \(paidallSoundsFilteringCode)")
            paidkeysSoundFilteringCode = 0
        }
        NotificationCenter.default.post(name: PaidFilterSoundsChangedNotify, object: "Keys")
    }
    
    @IBAction func pianoAcousticSoundCheckBoxTapped(_ sender: Any) {
        soundsBadge.alpha = 1
        if paidpianoAcousticSoundFilteringCode == 0 {
            if paidsoundsfilteringCode == 0 {
                paidnumberOfActiveFilterCells+=1
                print("Number of active filtering cells is: \(paidnumberOfActiveFilterCells)")
            }
            paidsoundsfilteringCode = 1
            print("sounds filtering cell is active, sounds filtering code is: \(paidsoundsfilteringCode)")
            paidallSoundsFilteringCode += 1
            print("Filtering code for all sounds boxes added up: \(paidallSoundsFilteringCode)")
            paidpianoAcousticSoundFilteringCode = 1
        } else if paidpianoAcousticSoundFilteringCode == 1 {
            if paidallSoundsFilteringCode > 1 {
                if paidsoundsfilteringCode == 0 {
                    soundsBadge.alpha = 1
                    paidsoundsfilteringCode = 1
                    paidnumberOfActiveFilterCells+=1
                    print("Number of active filtering cells is: \(paidnumberOfActiveFilterCells)")
                }
            }
            if paidallSoundsFilteringCode == 1 {
                soundsBadge.alpha = 0
                paidsoundsfilteringCode = 0
                if paidnumberOfActiveFilterCells != 0 {
                    paidnumberOfActiveFilterCells-=1
                }
                print("Number of active filtering cells is: \(paidnumberOfActiveFilterCells)")
                print("No sounds filter checkboxes active, sounds filtering code is: \(paidsoundsfilteringCode)")
                print("No sounds filter checkboxes active, allsoundsfiltering code is: \(paidallSoundsFilteringCode)")
            }
            paidallSoundsFilteringCode -= 1
            print("Filtering code for all type boxes added up: \(paidallSoundsFilteringCode)")
            paidpianoAcousticSoundFilteringCode = 0
        }
        NotificationCenter.default.post(name: PaidFilterSoundsChangedNotify, object: "Piano Acoustic")
    }
    
    @IBAction func pianoVinylSoundCheckBoxTapped(_ sender: Any) {
        soundsBadge.alpha = 1
        if paidpianoVinylSoundFilteringCode == 0 {
            if paidsoundsfilteringCode == 0 {
                paidnumberOfActiveFilterCells+=1
                print("Number of active filtering cells is: \(paidnumberOfActiveFilterCells)")
            }
            paidsoundsfilteringCode = 1
            print("sounds filtering cell is active, sounds filtering code is: \(paidsoundsfilteringCode)")
            paidallSoundsFilteringCode += 1
            print("Filtering code for all sounds boxes added up: \(paidallSoundsFilteringCode)")
            paidpianoVinylSoundFilteringCode = 1
        } else if paidpianoVinylSoundFilteringCode == 1 {
            if paidallSoundsFilteringCode > 1 {
                if paidsoundsfilteringCode == 0 {
                    soundsBadge.alpha = 1
                    paidsoundsfilteringCode = 1
                    paidnumberOfActiveFilterCells+=1
                    print("Number of active filtering cells is: \(paidnumberOfActiveFilterCells)")
                }
            }
            if paidallSoundsFilteringCode == 1 {
                soundsBadge.alpha = 0
                paidsoundsfilteringCode = 0
                if paidnumberOfActiveFilterCells != 0 {
                    paidnumberOfActiveFilterCells-=1
                }
                print("Number of active filtering cells is: \(paidnumberOfActiveFilterCells)")
                print("No sounds filter checkboxes active, sounds filtering code is: \(paidsoundsfilteringCode)")
                print("No sounds filter checkboxes active, allsoundsfiltering code is: \(paidallSoundsFilteringCode)")
            }
            paidallSoundsFilteringCode -= 1
            print("Filtering code for all type boxes added up: \(paidallSoundsFilteringCode)")
            paidpianoVinylSoundFilteringCode = 0
        }
        NotificationCenter.default.post(name: PaidFilterSoundsChangedNotify, object: "Piano Vinyl")
    }
    
    @IBAction func pianoElectricSoundCheckBoxTapped(_ sender: Any) {
        soundsBadge.alpha = 1
        if paidpianoElectricSoundFilteringCode == 0 {
            if paidsoundsfilteringCode == 0 {
                paidnumberOfActiveFilterCells+=1
                print("Number of active filtering cells is: \(paidnumberOfActiveFilterCells)")
            }
            paidsoundsfilteringCode = 1
            print("sounds filtering cell is active, sounds filtering code is: \(paidsoundsfilteringCode)")
            paidallSoundsFilteringCode += 1
            print("Filtering code for all sounds boxes added up: \(paidallSoundsFilteringCode)")
            paidpianoElectricSoundFilteringCode = 1
        } else if paidpianoElectricSoundFilteringCode == 1 {
            if paidallSoundsFilteringCode > 1 {
                if paidsoundsfilteringCode == 0 {
                    soundsBadge.alpha = 1
                    paidsoundsfilteringCode = 1
                    paidnumberOfActiveFilterCells+=1
                    print("Number of active filtering cells is: \(paidnumberOfActiveFilterCells)")
                }
            }
            if paidallSoundsFilteringCode == 1 {
                soundsBadge.alpha = 0
                paidsoundsfilteringCode = 0
                if paidnumberOfActiveFilterCells != 0 {
                    paidnumberOfActiveFilterCells-=1
                }
                print("Number of active filtering cells is: \(paidnumberOfActiveFilterCells)")
                print("No sounds filter checkboxes active, sounds filtering code is: \(paidsoundsfilteringCode)")
                print("No sounds filter checkboxes active, allsoundsfiltering code is: \(paidallSoundsFilteringCode)")
            }
            paidallSoundsFilteringCode -= 1
            print("Filtering code for all type boxes added up: \(paidallSoundsFilteringCode)")
            paidpianoElectricSoundFilteringCode = 0
        }
        NotificationCenter.default.post(name: PaidFilterSoundsChangedNotify, object: "Piano Electric")
    }
    
    @IBAction func pianoRhodesSoundCheckBoxTapped(_ sender: Any) {
        soundsBadge.alpha = 1
        if paidpianoRhodesSoundFilteringCode == 0 {
            if paidsoundsfilteringCode == 0 {
                paidnumberOfActiveFilterCells+=1
                print("Number of active filtering cells is: \(paidnumberOfActiveFilterCells)")
            }
            paidsoundsfilteringCode = 1
            print("sounds filtering cell is active, sounds filtering code is: \(paidsoundsfilteringCode)")
            paidallSoundsFilteringCode += 1
            print("Filtering code for all sounds boxes added up: \(paidallSoundsFilteringCode)")
            paidpianoRhodesSoundFilteringCode = 1
        } else if paidpianoRhodesSoundFilteringCode == 1 {
            if paidallSoundsFilteringCode > 1 {
                if paidsoundsfilteringCode == 0 {
                    soundsBadge.alpha = 1
                    paidsoundsfilteringCode = 1
                    paidnumberOfActiveFilterCells+=1
                    print("Number of active filtering cells is: \(paidnumberOfActiveFilterCells)")
                }
            }
            if paidallSoundsFilteringCode == 1 {
                soundsBadge.alpha = 0
                paidsoundsfilteringCode = 0
                if paidnumberOfActiveFilterCells != 0 {
                    paidnumberOfActiveFilterCells-=1
                }
                print("Number of active filtering cells is: \(paidnumberOfActiveFilterCells)")
                print("No sounds filter checkboxes active, sounds filtering code is: \(paidsoundsfilteringCode)")
                print("No sounds filter checkboxes active, allsoundsfiltering code is: \(paidallSoundsFilteringCode)")
            }
            paidallSoundsFilteringCode -= 1
            print("Filtering code for all type boxes added up: \(paidallSoundsFilteringCode)")
            paidpianoRhodesSoundFilteringCode = 0
        }
        NotificationCenter.default.post(name: PaidFilterSoundsChangedNotify, object: "Piano Rhodes")
    }
    
    @IBAction func organSoundCheckBoxTapped(_ sender: Any) {
        soundsBadge.alpha = 1
        if paidorganSoundFilteringCode == 0 {
            if paidsoundsfilteringCode == 0 {
                paidnumberOfActiveFilterCells+=1
                print("Number of active filtering cells is: \(paidnumberOfActiveFilterCells)")
            }
            paidsoundsfilteringCode = 1
            print("sounds filtering cell is active, sounds filtering code is: \(paidsoundsfilteringCode)")
            paidallSoundsFilteringCode += 1
            print("Filtering code for all sounds boxes added up: \(paidallSoundsFilteringCode)")
            paidorganSoundFilteringCode = 1
        } else if paidorganSoundFilteringCode == 1 {
            if paidallSoundsFilteringCode > 1 {
                if paidsoundsfilteringCode == 0 {
                    soundsBadge.alpha = 1
                    paidsoundsfilteringCode = 1
                    paidnumberOfActiveFilterCells+=1
                    print("Number of active filtering cells is: \(paidnumberOfActiveFilterCells)")
                }
            }
            if paidallSoundsFilteringCode == 1 {
                soundsBadge.alpha = 0
                paidsoundsfilteringCode = 0
                if paidnumberOfActiveFilterCells != 0 {
                    paidnumberOfActiveFilterCells-=1
                }
                print("Number of active filtering cells is: \(paidnumberOfActiveFilterCells)")
                print("No sounds filter checkboxes active, sounds filtering code is: \(paidsoundsfilteringCode)")
                print("No sounds filter checkboxes active, allsoundsfiltering code is: \(paidallSoundsFilteringCode)")
            }
            paidallSoundsFilteringCode -= 1
            print("Filtering code for all type boxes added up: \(paidallSoundsFilteringCode)")
            paidorganSoundFilteringCode = 0
        }
        NotificationCenter.default.post(name: PaidFilterSoundsChangedNotify, object: "Organ")
    }
    
    @IBAction func theraminSoundCheckBoxTapped(_ sender: Any) {
        soundsBadge.alpha = 1
        if paidtheraminSoundFilteringCode == 0 {
            if paidsoundsfilteringCode == 0 {
                paidnumberOfActiveFilterCells+=1
                print("Number of active filtering cells is: \(paidnumberOfActiveFilterCells)")
            }
            paidsoundsfilteringCode = 1
            print("sounds filtering cell is active, sounds filtering code is: \(paidsoundsfilteringCode)")
            paidallSoundsFilteringCode += 1
            print("Filtering code for all sounds boxes added up: \(paidallSoundsFilteringCode)")
            paidtheraminSoundFilteringCode = 1
        } else if paidtheraminSoundFilteringCode == 1 {
            if paidallSoundsFilteringCode > 1 {
                if paidsoundsfilteringCode == 0 {
                    soundsBadge.alpha = 1
                    paidsoundsfilteringCode = 1
                    paidnumberOfActiveFilterCells+=1
                    print("Number of active filtering cells is: \(paidnumberOfActiveFilterCells)")
                }
            }
            if paidallSoundsFilteringCode == 1 {
                soundsBadge.alpha = 0
                paidsoundsfilteringCode = 0
                if paidnumberOfActiveFilterCells != 0 {
                    paidnumberOfActiveFilterCells-=1
                }
                print("Number of active filtering cells is: \(paidnumberOfActiveFilterCells)")
                print("No sounds filter checkboxes active, sounds filtering code is: \(paidsoundsfilteringCode)")
                print("No sounds filter checkboxes active, allsoundsfiltering code is: \(paidallSoundsFilteringCode)")
            }
            paidallSoundsFilteringCode -= 1
            print("Filtering code for all type boxes added up: \(paidallSoundsFilteringCode)")
            paidtheraminSoundFilteringCode = 0
        }
        NotificationCenter.default.post(name: PaidFilterSoundsChangedNotify, object: "Theramin")
    }
    
    @IBAction func whistleSoundCheckBoxTapped(_ sender: Any) {
        soundsBadge.alpha = 1
        if paidwhistleSoundFilteringCode == 0 {
            if paidsoundsfilteringCode == 0 {
                paidnumberOfActiveFilterCells+=1
                print("Number of active filtering cells is: \(paidnumberOfActiveFilterCells)")
            }
            paidsoundsfilteringCode = 1
            print("sounds filtering cell is active, sounds filtering code is: \(paidsoundsfilteringCode)")
            paidallSoundsFilteringCode += 1
            print("Filtering code for all sounds boxes added up: \(paidallSoundsFilteringCode)")
            paidwhistleSoundFilteringCode = 1
        } else if paidwhistleSoundFilteringCode == 1 {
            if paidallSoundsFilteringCode > 1 {
                if paidsoundsfilteringCode == 0 {
                    soundsBadge.alpha = 1
                    paidsoundsfilteringCode = 1
                    paidnumberOfActiveFilterCells+=1
                    print("Number of active filtering cells is: \(paidnumberOfActiveFilterCells)")
                }
            }
            if paidallSoundsFilteringCode == 1 {
                soundsBadge.alpha = 0
                paidsoundsfilteringCode = 0
                if paidnumberOfActiveFilterCells != 0 {
                    paidnumberOfActiveFilterCells-=1
                }
                print("Number of active filtering cells is: \(paidnumberOfActiveFilterCells)")
                print("No sounds filter checkboxes active, sounds filtering code is: \(paidsoundsfilteringCode)")
                print("No sounds filter checkboxes active, allsoundsfiltering code is: \(paidallSoundsFilteringCode)")
            }
            paidallSoundsFilteringCode -= 1
            print("Filtering code for all type boxes added up: \(paidallSoundsFilteringCode)")
            paidwhistleSoundFilteringCode = 0
        }
        NotificationCenter.default.post(name: PaidFilterSoundsChangedNotify, object: "Whistle")
    }
    
    @IBAction func hornsSoundCheckBoxTapped(_ sender: Any) {
        soundsBadge.alpha = 1
        if paidhornsSoundFilteringCode == 0 {
            if paidsoundsfilteringCode == 0 {
                paidnumberOfActiveFilterCells+=1
                print("Number of active filtering cells is: \(paidnumberOfActiveFilterCells)")
            }
            paidsoundsfilteringCode = 1
            print("sounds filtering cell is active, sounds filtering code is: \(paidsoundsfilteringCode)")
            paidallSoundsFilteringCode += 1
            print("Filtering code for all sounds boxes added up: \(paidallSoundsFilteringCode)")
            paidhornsSoundFilteringCode = 1
        } else if paidhornsSoundFilteringCode == 1 {
            if paidallSoundsFilteringCode > 1 {
                if paidsoundsfilteringCode == 0 {
                    soundsBadge.alpha = 1
                    paidsoundsfilteringCode = 1
                    paidnumberOfActiveFilterCells+=1
                    print("Number of active filtering cells is: \(paidnumberOfActiveFilterCells)")
                }
            }
            if paidallSoundsFilteringCode == 1 {
                soundsBadge.alpha = 0
                paidsoundsfilteringCode = 0
                if paidnumberOfActiveFilterCells != 0 {
                    paidnumberOfActiveFilterCells-=1
                }
                print("Number of active filtering cells is: \(paidnumberOfActiveFilterCells)")
                print("No sounds filter checkboxes active, sounds filtering code is: \(paidsoundsfilteringCode)")
                print("No sounds filter checkboxes active, allsoundsfiltering code is: \(paidallSoundsFilteringCode)")
            }
            paidallSoundsFilteringCode -= 1
            print("Filtering code for all type boxes added up: \(paidallSoundsFilteringCode)")
            paidhornsSoundFilteringCode = 0
        }
        NotificationCenter.default.post(name: PaidFilterSoundsChangedNotify, object: "Horns")
    }
    
    @IBAction func stringsSoundCheckBoxTapped(_ sender: Any) {
        soundsBadge.alpha = 1
        if paidstringsSoundFilteringCode == 0 {
            if paidsoundsfilteringCode == 0 {
                paidnumberOfActiveFilterCells+=1
                print("Number of active filtering cells is: \(paidnumberOfActiveFilterCells)")
            }
            paidsoundsfilteringCode = 1
            print("sounds filtering cell is active, sounds filtering code is: \(paidsoundsfilteringCode)")
            paidallSoundsFilteringCode += 1
            print("Filtering code for all sounds boxes added up: \(paidallSoundsFilteringCode)")
            paidstringsSoundFilteringCode = 1
        } else if paidstringsSoundFilteringCode == 1 {
            if paidallSoundsFilteringCode > 1 {
                if paidsoundsfilteringCode == 0 {
                    soundsBadge.alpha = 1
                    paidsoundsfilteringCode = 1
                    paidnumberOfActiveFilterCells+=1
                    print("Number of active filtering cells is: \(paidnumberOfActiveFilterCells)")
                }
            }
            if paidallSoundsFilteringCode == 1 {
                soundsBadge.alpha = 0
                paidsoundsfilteringCode = 0
                if paidnumberOfActiveFilterCells != 0 {
                    paidnumberOfActiveFilterCells-=1
                }
                print("Number of active filtering cells is: \(paidnumberOfActiveFilterCells)")
                print("No sounds filter checkboxes active, sounds filtering code is: \(paidsoundsfilteringCode)")
                print("No sounds filter checkboxes active, allsoundsfiltering code is: \(paidallSoundsFilteringCode)")
            }
            paidallSoundsFilteringCode -= 1
            print("Filtering code for all type boxes added up: \(paidallSoundsFilteringCode)")
            paidstringsSoundFilteringCode = 0
        }
        NotificationCenter.default.post(name: PaidFilterSoundsChangedNotify, object: "Strings")
    }
    
    @IBAction func fluteSoundCheckBoxTapped(_ sender: Any) {
        soundsBadge.alpha = 1
        if paidfluteSoundFilteringCode == 0 {
            if paidsoundsfilteringCode == 0 {
                paidnumberOfActiveFilterCells+=1
                print("Number of active filtering cells is: \(paidnumberOfActiveFilterCells)")
            }
            paidsoundsfilteringCode = 1
            print("sounds filtering cell is active, sounds filtering code is: \(paidsoundsfilteringCode)")
            paidallSoundsFilteringCode += 1
            print("Filtering code for all sounds boxes added up: \(paidallSoundsFilteringCode)")
            paidfluteSoundFilteringCode = 1
        } else if paidfluteSoundFilteringCode == 1 {
            if paidallSoundsFilteringCode > 1 {
                if paidsoundsfilteringCode == 0 {
                    soundsBadge.alpha = 1
                    paidsoundsfilteringCode = 1
                    paidnumberOfActiveFilterCells+=1
                    print("Number of active filtering cells is: \(paidnumberOfActiveFilterCells)")
                }
            }
            if paidallSoundsFilteringCode == 1 {
                soundsBadge.alpha = 0
                paidsoundsfilteringCode = 0
                if paidnumberOfActiveFilterCells != 0 {
                    paidnumberOfActiveFilterCells-=1
                }
                print("Number of active filtering cells is: \(paidnumberOfActiveFilterCells)")
                print("No sounds filter checkboxes active, sounds filtering code is: \(paidsoundsfilteringCode)")
                print("No sounds filter checkboxes active, allsoundsfiltering code is: \(paidallSoundsFilteringCode)")
            }
            paidallSoundsFilteringCode -= 1
            print("Filtering code for all type boxes added up: \(paidallSoundsFilteringCode)")
            paidfluteSoundFilteringCode = 0
        }
        NotificationCenter.default.post(name: PaidFilterSoundsChangedNotify, object: "Flute")
    }
    
    @IBAction func padBellSoundCheckBoxTapped(_ sender: Any) {
        soundsBadge.alpha = 1
        if paidpadBellSoundFilteringCode == 0 {
            if paidsoundsfilteringCode == 0 {
                paidnumberOfActiveFilterCells+=1
                print("Number of active filtering cells is: \(paidnumberOfActiveFilterCells)")
            }
            paidsoundsfilteringCode = 1
            print("sounds filtering cell is active, sounds filtering code is: \(paidsoundsfilteringCode)")
            paidallSoundsFilteringCode += 1
            print("Filtering code for all sounds boxes added up: \(paidallSoundsFilteringCode)")
            paidpadBellSoundFilteringCode = 1
        } else if paidpadBellSoundFilteringCode == 1 {
            if paidallSoundsFilteringCode > 1 {
                if paidsoundsfilteringCode == 0 {
                    soundsBadge.alpha = 1
                    paidsoundsfilteringCode = 1
                    paidnumberOfActiveFilterCells+=1
                    print("Number of active filtering cells is: \(paidnumberOfActiveFilterCells)")
                }
            }
            if paidallSoundsFilteringCode == 1 {
                soundsBadge.alpha = 0
                paidsoundsfilteringCode = 0
                if paidnumberOfActiveFilterCells != 0 {
                    paidnumberOfActiveFilterCells-=1
                }
                print("Number of active filtering cells is: \(paidnumberOfActiveFilterCells)")
                print("No sounds filter checkboxes active, sounds filtering code is: \(paidsoundsfilteringCode)")
                print("No sounds filter checkboxes active, allsoundsfiltering code is: \(paidallSoundsFilteringCode)")
            }
            paidallSoundsFilteringCode -= 1
            print("Filtering code for all type boxes added up: \(paidallSoundsFilteringCode)")
            paidpadBellSoundFilteringCode = 0
        }
        NotificationCenter.default.post(name: PaidFilterSoundsChangedNotify, object: "Pad Bell")
    }
    
    @IBAction func padHollowSoundCheckBoxTapped(_ sender: Any) {
        soundsBadge.alpha = 1
        if paidpadHollowSoundFilteringCode == 0 {
            if paidsoundsfilteringCode == 0 {
                paidnumberOfActiveFilterCells+=1
                print("Number of active filtering cells is: \(paidnumberOfActiveFilterCells)")
            }
            paidsoundsfilteringCode = 1
            print("sounds filtering cell is active, sounds filtering code is: \(paidsoundsfilteringCode)")
            paidallSoundsFilteringCode += 1
            print("Filtering code for all sounds boxes added up: \(paidallSoundsFilteringCode)")
            paidpadHollowSoundFilteringCode = 1
        } else if paidpadHollowSoundFilteringCode == 1 {
            if paidallSoundsFilteringCode > 1 {
                if paidsoundsfilteringCode == 0 {
                    soundsBadge.alpha = 1
                    paidsoundsfilteringCode = 1
                    paidnumberOfActiveFilterCells+=1
                    print("Number of active filtering cells is: \(paidnumberOfActiveFilterCells)")
                }
            }
            if paidallSoundsFilteringCode == 1 {
                soundsBadge.alpha = 0
                paidsoundsfilteringCode = 0
                if paidnumberOfActiveFilterCells != 0 {
                    paidnumberOfActiveFilterCells-=1
                }
                print("Number of active filtering cells is: \(paidnumberOfActiveFilterCells)")
                print("No sounds filter checkboxes active, sounds filtering code is: \(paidsoundsfilteringCode)")
                print("No sounds filter checkboxes active, allsoundsfiltering code is: \(paidallSoundsFilteringCode)")
            }
            paidallSoundsFilteringCode -= 1
            print("Filtering code for all type boxes added up: \(paidallSoundsFilteringCode)")
            paidpadHollowSoundFilteringCode = 0
        }
        NotificationCenter.default.post(name: PaidFilterSoundsChangedNotify, object: "Pad Hollow")
    }
    
    @IBAction func padAggressiveSoundCheckBoxTapped(_ sender: Any) {
        soundsBadge.alpha = 1
        if paidpadAggressiveSoundFilteringCode == 0 {
            if paidsoundsfilteringCode == 0 {
                paidnumberOfActiveFilterCells+=1
                print("Number of active filtering cells is: \(paidnumberOfActiveFilterCells)")
            }
            paidsoundsfilteringCode = 1
            print("sounds filtering cell is active, sounds filtering code is: \(paidsoundsfilteringCode)")
            paidallSoundsFilteringCode += 1
            print("Filtering code for all sounds boxes added up: \(paidallSoundsFilteringCode)")
            paidpadAggressiveSoundFilteringCode = 1
        } else if paidpadAggressiveSoundFilteringCode == 1 {
            if paidallSoundsFilteringCode > 1 {
                if paidsoundsfilteringCode == 0 {
                    soundsBadge.alpha = 1
                    paidsoundsfilteringCode = 1
                    paidnumberOfActiveFilterCells+=1
                    print("Number of active filtering cells is: \(paidnumberOfActiveFilterCells)")
                }
            }
            if paidallSoundsFilteringCode == 1 {
                soundsBadge.alpha = 0
                paidsoundsfilteringCode = 0
                if paidnumberOfActiveFilterCells != 0 {
                    paidnumberOfActiveFilterCells-=1
                }
                print("Number of active filtering cells is: \(paidnumberOfActiveFilterCells)")
                print("No sounds filter checkboxes active, sounds filtering code is: \(paidsoundsfilteringCode)")
                print("No sounds filter checkboxes active, allsoundsfiltering code is: \(paidallSoundsFilteringCode)")
            }
            paidallSoundsFilteringCode -= 1
            print("Filtering code for all type boxes added up: \(paidallSoundsFilteringCode)")
            paidpadAggressiveSoundFilteringCode = 0
        }
        NotificationCenter.default.post(name: PaidFilterSoundsChangedNotify, object: "Pad Aggressive")
    }
    
    @IBAction func choirSoundCheckBoxTapped(_ sender: Any) {
        soundsBadge.alpha = 1
        if paidchoirSoundFilteringCode == 0 {
            if paidsoundsfilteringCode == 0 {
                paidnumberOfActiveFilterCells+=1
                print("Number of active filtering cells is: \(paidnumberOfActiveFilterCells)")
            }
            paidsoundsfilteringCode = 1
            print("sounds filtering cell is active, sounds filtering code is: \(paidsoundsfilteringCode)")
            paidallSoundsFilteringCode += 1
            print("Filtering code for all sounds boxes added up: \(paidallSoundsFilteringCode)")
            paidchoirSoundFilteringCode = 1
        } else if paidchoirSoundFilteringCode == 1 {
            if paidallSoundsFilteringCode > 1 {
                if paidsoundsfilteringCode == 0 {
                    soundsBadge.alpha = 1
                    paidsoundsfilteringCode = 1
                    paidnumberOfActiveFilterCells+=1
                    print("Number of active filtering cells is: \(paidnumberOfActiveFilterCells)")
                }
            }
            if paidallSoundsFilteringCode == 1 {
                soundsBadge.alpha = 0
                paidsoundsfilteringCode = 0
                if paidnumberOfActiveFilterCells != 0 {
                    paidnumberOfActiveFilterCells-=1
                }
                print("Number of active filtering cells is: \(paidnumberOfActiveFilterCells)")
                print("No sounds filter checkboxes active, sounds filtering code is: \(paidsoundsfilteringCode)")
                print("No sounds filter checkboxes active, allsoundsfiltering code is: \(paidallSoundsFilteringCode)")
            }
            paidallSoundsFilteringCode -= 1
            print("Filtering code for all type boxes added up: \(paidallSoundsFilteringCode)")
            paidchoirSoundFilteringCode = 0
        }
        NotificationCenter.default.post(name: PaidFilterSoundsChangedNotify, object: "Choir")
    }
    
    @IBAction func saxophoneSoundCheckBoxTapped(_ sender: Any) {
        soundsBadge.alpha = 1
        if paidsaxophoneSoundFilteringCode == 0 {
            if paidsoundsfilteringCode == 0 {
                paidnumberOfActiveFilterCells+=1
                print("Number of active filtering cells is: \(paidnumberOfActiveFilterCells)")
            }
            paidsoundsfilteringCode = 1
            print("sounds filtering cell is active, sounds filtering code is: \(paidsoundsfilteringCode)")
            paidallSoundsFilteringCode += 1
            print("Filtering code for all sounds boxes added up: \(paidallSoundsFilteringCode)")
            paidsaxophoneSoundFilteringCode = 1
        } else if paidsaxophoneSoundFilteringCode == 1 {
            if paidallSoundsFilteringCode > 1 {
                if paidsoundsfilteringCode == 0 {
                    soundsBadge.alpha = 1
                    paidsoundsfilteringCode = 1
                    paidnumberOfActiveFilterCells+=1
                    print("Number of active filtering cells is: \(paidnumberOfActiveFilterCells)")
                }
            }
            if paidallSoundsFilteringCode == 1 {
                soundsBadge.alpha = 0
                paidsoundsfilteringCode = 0
                if paidnumberOfActiveFilterCells != 0 {
                    paidnumberOfActiveFilterCells-=1
                }
                print("Number of active filtering cells is: \(paidnumberOfActiveFilterCells)")
                print("No sounds filter checkboxes active, sounds filtering code is: \(paidsoundsfilteringCode)")
                print("No sounds filter checkboxes active, allsoundsfiltering code is: \(paidallSoundsFilteringCode)")
            }
            paidallSoundsFilteringCode -= 1
            print("Filtering code for all type boxes added up: \(paidallSoundsFilteringCode)")
            paidsaxophoneSoundFilteringCode = 0
        }
        NotificationCenter.default.post(name: PaidFilterSoundsChangedNotify, object: "Saxophone")
    }
    
    @IBAction func guitarElectricSoundCheckBoxTapped(_ sender: Any) {
        soundsBadge.alpha = 1
        if paidguitarElectricSoundFilteringCode == 0 {
            if paidsoundsfilteringCode == 0 {
                paidnumberOfActiveFilterCells+=1
                print("Number of active filtering cells is: \(paidnumberOfActiveFilterCells)")
            }
            paidsoundsfilteringCode = 1
            print("sounds filtering cell is active, sounds filtering code is: \(paidsoundsfilteringCode)")
            paidallSoundsFilteringCode += 1
            print("Filtering code for all sounds boxes added up: \(paidallSoundsFilteringCode)")
            paidguitarElectricSoundFilteringCode = 1
        } else if paidguitarElectricSoundFilteringCode == 1 {
            if paidallSoundsFilteringCode > 1 {
                if paidsoundsfilteringCode == 0 {
                    soundsBadge.alpha = 1
                    paidsoundsfilteringCode = 1
                    paidnumberOfActiveFilterCells+=1
                    print("Number of active filtering cells is: \(paidnumberOfActiveFilterCells)")
                }
            }
            if paidallSoundsFilteringCode == 1 {
                soundsBadge.alpha = 0
                paidsoundsfilteringCode = 0
                if paidnumberOfActiveFilterCells != 0 {
                    paidnumberOfActiveFilterCells-=1
                }
                print("Number of active filtering cells is: \(paidnumberOfActiveFilterCells)")
                print("No sounds filter checkboxes active, sounds filtering code is: \(paidsoundsfilteringCode)")
                print("No sounds filter checkboxes active, allsoundsfiltering code is: \(paidallSoundsFilteringCode)")
            }
            paidallSoundsFilteringCode -= 1
            print("Filtering code for all type boxes added up: \(paidallSoundsFilteringCode)")
            paidguitarElectricSoundFilteringCode = 0
        }
        NotificationCenter.default.post(name: PaidFilterSoundsChangedNotify, object: "Guitar Electric")
    }
    
    @IBAction func guitarAcousticSoundCheckBoxTapped(_ sender: Any) {
        soundsBadge.alpha = 1
        if paidguitarAcousticSoundFilteringCode == 0 {
            if paidsoundsfilteringCode == 0 {
                paidnumberOfActiveFilterCells+=1
                print("Number of active filtering cells is: \(paidnumberOfActiveFilterCells)")
            }
            paidsoundsfilteringCode = 1
            print("sounds filtering cell is active, sounds filtering code is: \(paidsoundsfilteringCode)")
            paidallSoundsFilteringCode += 1
            print("Filtering code for all sounds boxes added up: \(paidallSoundsFilteringCode)")
            paidguitarAcousticSoundFilteringCode = 1
        } else if paidguitarAcousticSoundFilteringCode == 1 {
            if paidallSoundsFilteringCode > 1 {
                if paidsoundsfilteringCode == 0 {
                    soundsBadge.alpha = 1
                    paidsoundsfilteringCode = 1
                    paidnumberOfActiveFilterCells+=1
                    print("Number of active filtering cells is: \(paidnumberOfActiveFilterCells)")
                }
            }
            if paidallSoundsFilteringCode == 1 {
                soundsBadge.alpha = 0
                paidsoundsfilteringCode = 0
                if paidnumberOfActiveFilterCells != 0 {
                    paidnumberOfActiveFilterCells-=1
                }
                print("Number of active filtering cells is: \(paidnumberOfActiveFilterCells)")
                print("No sounds filter checkboxes active, sounds filtering code is: \(paidsoundsfilteringCode)")
                print("No sounds filter checkboxes active, allsoundsfiltering code is: \(paidallSoundsFilteringCode)")
            }
            paidallSoundsFilteringCode -= 1
            print("Filtering code for all type boxes added up: \(paidallSoundsFilteringCode)")
            paidguitarAcousticSoundFilteringCode = 0
        }
        NotificationCenter.default.post(name: PaidFilterSoundsChangedNotify, object: "Guitar Acoustic")
    }
    
    @IBAction func guitarSteelSoundCheckBoxTapped(_ sender: Any) {
        soundsBadge.alpha = 1
        if paidguitarSteelSoundFilteringCode == 0 {
            if paidsoundsfilteringCode == 0 {
                paidnumberOfActiveFilterCells+=1
                print("Number of active filtering cells is: \(paidnumberOfActiveFilterCells)")
            }
            paidsoundsfilteringCode = 1
            print("sounds filtering cell is active, sounds filtering code is: \(paidsoundsfilteringCode)")
            paidallSoundsFilteringCode += 1
            print("Filtering code for all sounds boxes added up: \(paidallSoundsFilteringCode)")
            paidguitarSteelSoundFilteringCode = 1
        } else if paidguitarSteelSoundFilteringCode == 1 {
            if paidallSoundsFilteringCode > 1 {
                if paidsoundsfilteringCode == 0 {
                    soundsBadge.alpha = 1
                    paidsoundsfilteringCode = 1
                    paidnumberOfActiveFilterCells+=1
                    print("Number of active filtering cells is: \(paidnumberOfActiveFilterCells)")
                }
            }
            if paidallSoundsFilteringCode == 1 {
                soundsBadge.alpha = 0
                paidsoundsfilteringCode = 0
                if paidnumberOfActiveFilterCells != 0 {
                    paidnumberOfActiveFilterCells-=1
                }
                print("Number of active filtering cells is: \(paidnumberOfActiveFilterCells)")
                print("No sounds filter checkboxes active, sounds filtering code is: \(paidsoundsfilteringCode)")
                print("No sounds filter checkboxes active, allsoundsfiltering code is: \(paidallSoundsFilteringCode)")
            }
            paidallSoundsFilteringCode -= 1
            print("Filtering code for all type boxes added up: \(allSoundsFilteringCode)")
            paidguitarSteelSoundFilteringCode = 0
        }
        NotificationCenter.default.post(name: PaidFilterSoundsChangedNotify, object: "Guitar Steel")
    }
    
    @IBAction func bellsEDMSoundCheckBoxTapped(_ sender: Any) {
        soundsBadge.alpha = 1
        if paidbellsEDMSoundFilteringCode == 0 {
            if paidsoundsfilteringCode == 0 {
                paidnumberOfActiveFilterCells+=1
                print("Number of active filtering cells is: \(paidnumberOfActiveFilterCells)")
            }
            paidsoundsfilteringCode = 1
            print("sounds filtering cell is active, sounds filtering code is: \(paidsoundsfilteringCode)")
            paidallSoundsFilteringCode += 1
            print("Filtering code for all sounds boxes added up: \(paidallSoundsFilteringCode)")
            paidbellsEDMSoundFilteringCode = 1
        } else if paidbellsEDMSoundFilteringCode == 1 {
            if paidallSoundsFilteringCode > 1 {
                if paidsoundsfilteringCode == 0 {
                    soundsBadge.alpha = 1
                    paidsoundsfilteringCode = 1
                    paidnumberOfActiveFilterCells+=1
                    print("Number of active filtering cells is: \(paidnumberOfActiveFilterCells)")
                }
            }
            if paidallSoundsFilteringCode == 1 {
                soundsBadge.alpha = 0
                paidsoundsfilteringCode = 0
                if paidnumberOfActiveFilterCells != 0 {
                    paidnumberOfActiveFilterCells-=1
                }
                print("Number of active filtering cells is: \(paidnumberOfActiveFilterCells)")
                print("No sounds filter checkboxes active, sounds filtering code is: \(paidsoundsfilteringCode)")
                print("No sounds filter checkboxes active, allsoundsfiltering code is: \(paidallSoundsFilteringCode)")
            }
            paidallSoundsFilteringCode -= 1
            print("Filtering code for all type boxes added up: \(paidallSoundsFilteringCode)")
            paidbellsEDMSoundFilteringCode = 0
        }
        NotificationCenter.default.post(name: PaidFilterSoundsChangedNotify, object: "Bells EDM")
    }
    
    @IBAction func bellsVinylSoundCheckBoxTapped(_ sender: Any) {
        soundsBadge.alpha = 1
        if paidbellsVinylSoundFilteringCode == 0 {
            if paidsoundsfilteringCode == 0 {
                paidnumberOfActiveFilterCells+=1
                print("Number of active filtering cells is: \(paidnumberOfActiveFilterCells)")
            }
            paidsoundsfilteringCode = 1
            print("sounds filtering cell is active, sounds filtering code is: \(paidsoundsfilteringCode)")
            paidallSoundsFilteringCode += 1
            print("Filtering code for all sounds boxes added up: \(allSoundsFilteringCode)")
            paidbellsVinylSoundFilteringCode = 1
        } else if paidbellsVinylSoundFilteringCode == 1 {
            if paidallSoundsFilteringCode > 1 {
                if paidsoundsfilteringCode == 0 {
                    soundsBadge.alpha = 1
                    paidsoundsfilteringCode = 1
                    paidnumberOfActiveFilterCells+=1
                    print("Number of active filtering cells is: \(paidnumberOfActiveFilterCells)")
                }
            }
            if paidallSoundsFilteringCode == 1 {
                soundsBadge.alpha = 0
                paidsoundsfilteringCode = 0
                if paidnumberOfActiveFilterCells != 0 {
                    paidnumberOfActiveFilterCells-=1
                }
                print("Number of active filtering cells is: \(paidnumberOfActiveFilterCells)")
                print("No sounds filter checkboxes active, sounds filtering code is: \(paidsoundsfilteringCode)")
                print("No sounds filter checkboxes active, allsoundsfiltering code is: \(paidallSoundsFilteringCode)")
            }
            paidallSoundsFilteringCode -= 1
            print("Filtering code for all type boxes added up: \(paidallSoundsFilteringCode)")
            paidbellsVinylSoundFilteringCode = 0
        }
        NotificationCenter.default.post(name: PaidFilterSoundsChangedNotify, object: "Bells Vinyl")
    }
    
    @IBAction func bellsGothicSoundCheckBoxTapped(_ sender: Any) {
        soundsBadge.alpha = 1
        if paidbellsGothicSoundFilteringCode == 0 {
            if paidsoundsfilteringCode == 0 {
                paidnumberOfActiveFilterCells+=1
                print("Number of active filtering cells is: \(paidnumberOfActiveFilterCells)")
            }
            paidsoundsfilteringCode = 1
            print("sounds filtering cell is active, sounds filtering code is: \(paidsoundsfilteringCode)")
            paidallSoundsFilteringCode += 1
            print("Filtering code for all sounds boxes added up: \(paidallSoundsFilteringCode)")
            paidbellsGothicSoundFilteringCode = 1
        } else if bellsGothicSoundFilteringCode == 1 {
            if paidallSoundsFilteringCode > 1 {
                if paidsoundsfilteringCode == 0 {
                    soundsBadge.alpha = 1
                    paidsoundsfilteringCode = 1
                    paidnumberOfActiveFilterCells+=1
                    print("Number of active filtering cells is: \(paidnumberOfActiveFilterCells)")
                }
            }
            if paidallSoundsFilteringCode == 1 {
                soundsBadge.alpha = 0
                paidsoundsfilteringCode = 0
                if paidnumberOfActiveFilterCells != 0 {
                    paidnumberOfActiveFilterCells-=1
                }
                print("Number of active filtering cells is: \(paidnumberOfActiveFilterCells)")
                print("No sounds filter checkboxes active, sounds filtering code is: \(paidsoundsfilteringCode)")
                print("No sounds filter checkboxes active, allsoundsfiltering code is: \(paidallSoundsFilteringCode)")
            }
            paidallSoundsFilteringCode -= 1
            print("Filtering code for all type boxes added up: \(paidallSoundsFilteringCode)")
            paidbellsGothicSoundFilteringCode = 0
        }
        NotificationCenter.default.post(name: PaidFilterSoundsChangedNotify, object: "Bells Gothic")
    }
    
    @IBAction func bellsHollowSoundCheckBoxTapped(_ sender: Any) {
        soundsBadge.alpha = 1
        if paidbellsHollowSoundFilteringCode == 0 {
            if paidsoundsfilteringCode == 0 {
                paidnumberOfActiveFilterCells+=1
                print("Number of active filtering cells is: \(paidnumberOfActiveFilterCells)")
            }
            paidsoundsfilteringCode = 1
            print("sounds filtering cell is active, sounds filtering code is: \(paidsoundsfilteringCode)")
            paidallSoundsFilteringCode += 1
            print("Filtering code for all sounds boxes added up: \(paidallSoundsFilteringCode)")
            paidbellsHollowSoundFilteringCode = 1
        } else if paidbellsHollowSoundFilteringCode == 1 {
            if paidallSoundsFilteringCode > 1 {
                if paidsoundsfilteringCode == 0 {
                    soundsBadge.alpha = 1
                    paidsoundsfilteringCode = 1
                    paidnumberOfActiveFilterCells+=1
                    print("Number of active filtering cells is: \(paidnumberOfActiveFilterCells)")
                }
            }
            if paidallSoundsFilteringCode == 1 {
                soundsBadge.alpha = 0
                paidsoundsfilteringCode = 0
                if paidnumberOfActiveFilterCells != 0 {
                    paidnumberOfActiveFilterCells-=1
                }
                print("Number of active filtering cells is: \(paidnumberOfActiveFilterCells)")
                print("No sounds filter checkboxes active, sounds filtering code is: \(paidsoundsfilteringCode)")
                print("No sounds filter checkboxes active, allsoundsfiltering code is: \(paidallSoundsFilteringCode)")
            }
            paidallSoundsFilteringCode -= 1
            print("Filtering code for all type boxes added up: \(paidallSoundsFilteringCode)")
            paidbellsHollowSoundFilteringCode = 0
        }
        NotificationCenter.default.post(name: PaidFilterSoundsChangedNotify, object: "Bells Hollow")
    }
    
    @IBAction func bellsMusicBoxSoundCheckBoxTapped(_ sender: Any) {
        soundsBadge.alpha = 1
        if paidbellsMusicBoxSoundFilteringCode == 0 {
            if paidsoundsfilteringCode == 0 {
                paidnumberOfActiveFilterCells+=1
                print("Number of active filtering cells is: \(paidnumberOfActiveFilterCells)")
            }
            paidsoundsfilteringCode = 1
            print("sounds filtering cell is active, sounds filtering code is: \(paidsoundsfilteringCode)")
            paidallSoundsFilteringCode += 1
            print("Filtering code for all sounds boxes added up: \(paidallSoundsFilteringCode)")
            paidbellsMusicBoxSoundFilteringCode = 1
        } else if paidbellsMusicBoxSoundFilteringCode == 1 {
            if paidallSoundsFilteringCode > 1 {
                if paidsoundsfilteringCode == 0 {
                    soundsBadge.alpha = 1
                    paidsoundsfilteringCode = 1
                    paidnumberOfActiveFilterCells+=1
                    print("Number of active filtering cells is: \(paidnumberOfActiveFilterCells)")
                }
            }
            if paidallSoundsFilteringCode == 1 {
                soundsBadge.alpha = 0
                paidsoundsfilteringCode = 0
                if paidnumberOfActiveFilterCells != 0 {
                    paidnumberOfActiveFilterCells-=1
                }
                print("Number of active filtering cells is: \(paidnumberOfActiveFilterCells)")
                print("No sounds filter checkboxes active, sounds filtering code is: \(paidsoundsfilteringCode)")
                print("No sounds filter checkboxes active, allsoundsfiltering code is: \(paidallSoundsFilteringCode)")
            }
            paidallSoundsFilteringCode -= 1
            print("Filtering code for all type boxes added up: \(paidallSoundsFilteringCode)")
            paidbellsMusicBoxSoundFilteringCode = 0
        }
        NotificationCenter.default.post(name: PaidFilterSoundsChangedNotify, object: "Bells Music Box")
    }
    
    @IBAction func sampleVocalSoundCheckBoxTapped(_ sender: Any) {
        soundsBadge.alpha = 1
        if paidsampleVocalSoundFilteringCode == 0 {
            if paidsoundsfilteringCode == 0 {
                paidnumberOfActiveFilterCells+=1
                print("Number of active filtering cells is: \(paidnumberOfActiveFilterCells)")
            }
            paidsoundsfilteringCode = 1
            print("sounds filtering cell is active, sounds filtering code is: \(paidsoundsfilteringCode)")
            paidallSoundsFilteringCode += 1
            print("Filtering code for all sounds boxes added up: \(paidallSoundsFilteringCode)")
            paidsampleVocalSoundFilteringCode = 1
        } else if paidsampleVocalSoundFilteringCode == 1 {
            if paidallSoundsFilteringCode > 1 {
                if paidsoundsfilteringCode == 0 {
                    soundsBadge.alpha = 1
                    paidsoundsfilteringCode = 1
                    paidnumberOfActiveFilterCells+=1
                    print("Number of active filtering cells is: \(paidnumberOfActiveFilterCells)")
                }
            }
            if paidallSoundsFilteringCode == 1 {
                soundsBadge.alpha = 0
                paidsoundsfilteringCode = 0
                if paidnumberOfActiveFilterCells != 0 {
                    paidnumberOfActiveFilterCells-=1
                }
                print("Number of active filtering cells is: \(paidnumberOfActiveFilterCells)")
                print("No sounds filter checkboxes active, sounds filtering code is: \(paidsoundsfilteringCode)")
                print("No sounds filter checkboxes active, allsoundsfiltering code is: \(paidallSoundsFilteringCode)")
            }
            paidallSoundsFilteringCode -= 1
            print("Filtering code for all type boxes added up: \(paidallSoundsFilteringCode)")
            paidsampleVocalSoundFilteringCode = 0
        }
        NotificationCenter.default.post(name: PaidFilterSoundsChangedNotify, object: "Sample Vocal")
    }
    
    @IBAction func sampleSongSoundCheckBoxTapped(_ sender: Any) {
        soundsBadge.alpha = 1
        if paidsampleSongSoundFilteringCode == 0 {
            if paidsoundsfilteringCode == 0 {
                paidnumberOfActiveFilterCells+=1
                print("Number of active filtering cells is: \(paidnumberOfActiveFilterCells)")
            }
            paidsoundsfilteringCode = 1
            print("sounds filtering cell is active, sounds filtering code is: \(paidsoundsfilteringCode)")
            paidallSoundsFilteringCode += 1
            print("Filtering code for all sounds boxes added up: \(paidallSoundsFilteringCode)")
            paidsampleSongSoundFilteringCode = 1
        } else if paidsampleSongSoundFilteringCode == 1 {
            if paidallSoundsFilteringCode > 1 {
                if paidsoundsfilteringCode == 0 {
                    soundsBadge.alpha = 1
                    paidsoundsfilteringCode = 1
                    paidnumberOfActiveFilterCells+=1
                    print("Number of active filtering cells is: \(paidnumberOfActiveFilterCells)")
                }
            }
            if paidallSoundsFilteringCode == 1 {
                soundsBadge.alpha = 0
                paidsoundsfilteringCode = 0
                if paidnumberOfActiveFilterCells != 0 {
                    paidnumberOfActiveFilterCells-=1
                }
                print("Number of active filtering cells is: \(paidnumberOfActiveFilterCells)")
                print("No sounds filter checkboxes active, sounds filtering code is: \(paidsoundsfilteringCode)")
                print("No sounds filter checkboxes active, allsoundsfiltering code is: \(paidallSoundsFilteringCode)")
            }
            paidallSoundsFilteringCode -= 1
            print("Filtering code for all type boxes added up: \(paidallSoundsFilteringCode)")
            paidsampleSongSoundFilteringCode = 0
        }
        NotificationCenter.default.post(name: PaidFilterSoundsChangedNotify, object: "Sample Song")
    }
    
    @IBAction func noKickSoundCheckBoxTapped(_ sender: Any) {
        soundsBadge.alpha = 1
        if paidnoKickSoundFilteringCode == 0 {
            if paidsoundsfilteringCode == 0 {
                paidnumberOfActiveFilterCells+=1
                print("Number of active filtering cells is: \(paidnumberOfActiveFilterCells)")
            }
            paidsoundsfilteringCode = 1
            print("sounds filtering cell is active, sounds filtering code is: \(paidsoundsfilteringCode)")
            paidallSoundsFilteringCode += 1
            print("Filtering code for all sounds boxes added up: \(paidallSoundsFilteringCode)")
            paidnoKickSoundFilteringCode = 1
        } else if paidnoKickSoundFilteringCode == 1 {
            if paidallSoundsFilteringCode > 1 {
                if paidsoundsfilteringCode == 0 {
                    soundsBadge.alpha = 1
                    paidsoundsfilteringCode = 1
                    paidnumberOfActiveFilterCells+=1
                    print("Number of active filtering cells is: \(paidnumberOfActiveFilterCells)")
                }
            }
            if paidallSoundsFilteringCode == 1 {
                soundsBadge.alpha = 0
                paidsoundsfilteringCode = 0
                if paidnumberOfActiveFilterCells != 0 {
                    paidnumberOfActiveFilterCells-=1
                }
                print("Number of active filtering cells is: \(paidnumberOfActiveFilterCells)")
                print("No sounds filter checkboxes active, sounds filtering code is: \(paidsoundsfilteringCode)")
                print("No sounds filter checkboxes active, allsoundsfiltering code is: \(paidallSoundsFilteringCode)")
            }
            paidallSoundsFilteringCode -= 1
            print("Filtering code for all type boxes added up: \(paidallSoundsFilteringCode)")
            paidnoKickSoundFilteringCode = 0
        }
        NotificationCenter.default.post(name: PaidFilterSoundsChangedNotify, object: "No Kick")
    }
    
    @IBAction func kickSoundCheckBoxTapped(_ sender: Any) {
        soundsBadge.alpha = 1
        if paidkickSoundFilteringCode == 0 {
            if paidsoundsfilteringCode == 0 {
                paidnumberOfActiveFilterCells+=1
                print("Number of active filtering cells is: \(paidnumberOfActiveFilterCells)")
            }
            paidsoundsfilteringCode = 1
            print("sounds filtering cell is active, sounds filtering code is: \(paidsoundsfilteringCode)")
            paidallSoundsFilteringCode += 1
            print("Filtering code for all sounds boxes added up: \(paidallSoundsFilteringCode)")
            paidkickSoundFilteringCode = 1
        } else if paidkickSoundFilteringCode == 1 {
            if paidallSoundsFilteringCode > 1 {
                if paidsoundsfilteringCode == 0 {
                    soundsBadge.alpha = 1
                    paidsoundsfilteringCode = 1
                    paidnumberOfActiveFilterCells+=1
                    print("Number of active filtering cells is: \(paidnumberOfActiveFilterCells)")
                }
            }
            if paidallSoundsFilteringCode == 1 {
                soundsBadge.alpha = 0
                paidsoundsfilteringCode = 0
                if paidnumberOfActiveFilterCells != 0 {
                    paidnumberOfActiveFilterCells-=1
                }
                print("Number of active filtering cells is: \(paidnumberOfActiveFilterCells)")
                print("No sounds filter checkboxes active, sounds filtering code is: \(paidsoundsfilteringCode)")
                print("No sounds filter checkboxes active, allsoundsfiltering code is: \(paidallSoundsFilteringCode)")
            }
            paidallSoundsFilteringCode -= 1
            print("Filtering code for all type boxes added up: \(paidallSoundsFilteringCode)")
            paidkickSoundFilteringCode = 0
        }
        NotificationCenter.default.post(name: PaidFilterSoundsChangedNotify, object: "Kick")
    }
    
    @IBAction func long808SoundCheckBoxTapped(_ sender: Any) {
        soundsBadge.alpha = 1
        if paidlong808SoundFilteringCode == 0 {
            if paidsoundsfilteringCode == 0 {
                paidnumberOfActiveFilterCells+=1
                print("Number of active filtering cells is: \(paidnumberOfActiveFilterCells)")
            }
            paidsoundsfilteringCode = 1
            print("sounds filtering cell is active, sounds filtering code is: \(paidsoundsfilteringCode)")
            paidallSoundsFilteringCode += 1
            print("Filtering code for all sounds boxes added up: \(paidallSoundsFilteringCode)")
            paidlong808SoundFilteringCode = 1
        } else if paidlong808SoundFilteringCode == 1 {
            if paidallSoundsFilteringCode > 1 {
                if paidsoundsfilteringCode == 0 {
                    soundsBadge.alpha = 1
                    paidsoundsfilteringCode = 1
                    paidnumberOfActiveFilterCells+=1
                    print("Number of active filtering cells is: \(paidnumberOfActiveFilterCells)")
                }
            }
            if paidallSoundsFilteringCode == 1 {
                soundsBadge.alpha = 0
                paidsoundsfilteringCode = 0
                if paidnumberOfActiveFilterCells != 0 {
                    paidnumberOfActiveFilterCells-=1
                }
                print("Number of active filtering cells is: \(paidnumberOfActiveFilterCells)")
                print("No sounds filter checkboxes active, sounds filtering code is: \(paidsoundsfilteringCode)")
                print("No sounds filter checkboxes active, allsoundsfiltering code is: \(paidallSoundsFilteringCode)")
            }
            paidallSoundsFilteringCode -= 1
            print("Filtering code for all type boxes added up: \(allSoundsFilteringCode)")
            paidlong808SoundFilteringCode = 0
        }
        NotificationCenter.default.post(name: PaidFilterSoundsChangedNotify, object: "808 Long")
    }
    
    @IBAction func short808SoundCheckBoxTapped(_ sender: Any) {
        soundsBadge.alpha = 1
        if short808SoundFilteringCode == 0 {
            if paidsoundsfilteringCode == 0 {
                paidnumberOfActiveFilterCells+=1
                print("Number of active filtering cells is: \(paidnumberOfActiveFilterCells)")
            }
            paidsoundsfilteringCode = 1
            print("sounds filtering cell is active, sounds filtering code is: \(paidsoundsfilteringCode)")
            paidallSoundsFilteringCode += 1
            print("Filtering code for all sounds boxes added up: \(paidallSoundsFilteringCode)")
            paidshort808SoundFilteringCode = 1
        } else if paidshort808SoundFilteringCode == 1 {
            if paidallSoundsFilteringCode > 1 {
                if paidsoundsfilteringCode == 0 {
                    soundsBadge.alpha = 1
                    paidsoundsfilteringCode = 1
                    paidnumberOfActiveFilterCells+=1
                    print("Number of active filtering cells is: \(paidnumberOfActiveFilterCells)")
                }
            }
            if paidallSoundsFilteringCode == 1 {
                soundsBadge.alpha = 0
                paidsoundsfilteringCode = 0
                if paidnumberOfActiveFilterCells != 0 {
                    paidnumberOfActiveFilterCells-=1
                }
                print("Number of active filtering cells is: \(paidnumberOfActiveFilterCells)")
                print("No sounds filter checkboxes active, sounds filtering code is: \(paidsoundsfilteringCode)")
                print("No sounds filter checkboxes active, allsoundsfiltering code is: \(paidallSoundsFilteringCode)")
            }
            paidallSoundsFilteringCode -= 1
            print("Filtering code for all type boxes added up: \(paidallSoundsFilteringCode)")
            paidshort808SoundFilteringCode = 0
        }
        NotificationCenter.default.post(name: PaidFilterSoundsChangedNotify, object: "808 Short")
    }
    
    @IBAction func cleanSoundCheckBoxTapped(_ sender: Any) {
        soundsBadge.alpha = 1
        if paidclean808SoundFilteringCode == 0 {
            if paidsoundsfilteringCode == 0 {
                paidnumberOfActiveFilterCells+=1
                print("Number of active filtering cells is: \(paidnumberOfActiveFilterCells)")
            }
            paidsoundsfilteringCode = 1
            print("sounds filtering cell is active, sounds filtering code is: \(paidsoundsfilteringCode)")
            paidallSoundsFilteringCode += 1
            print("Filtering code for all sounds boxes added up: \(paidallSoundsFilteringCode)")
            paidclean808SoundFilteringCode = 1
        } else if paidclean808SoundFilteringCode == 1 {
            if paidallSoundsFilteringCode > 1 {
                if paidsoundsfilteringCode == 0 {
                    soundsBadge.alpha = 1
                    paidsoundsfilteringCode = 1
                    paidnumberOfActiveFilterCells+=1
                    print("Number of active filtering cells is: \(paidnumberOfActiveFilterCells)")
                }
            }
            if paidallSoundsFilteringCode == 1 {
                soundsBadge.alpha = 0
                paidsoundsfilteringCode = 0
                if paidnumberOfActiveFilterCells != 0 {
                    paidnumberOfActiveFilterCells-=1
                }
                print("Number of active filtering cells is: \(paidnumberOfActiveFilterCells)")
                print("No sounds filter checkboxes active, sounds filtering code is: \(paidsoundsfilteringCode)")
                print("No sounds filter checkboxes active, allsoundsfiltering code is: \(paidallSoundsFilteringCode)")
            }
            paidallSoundsFilteringCode -= 1
            print("Filtering code for all type boxes added up: \(paidallSoundsFilteringCode)")
            paidclean808SoundFilteringCode = 0
        }
        NotificationCenter.default.post(name: PaidFilterSoundsChangedNotify, object: "808 Clean")
    }
    
    @IBAction func distorted808SoundCheckBoxTapped(_ sender: Any) {
        soundsBadge.alpha = 1
        if paiddistorted808SoundFilteringCode == 0 {
            if paidsoundsfilteringCode == 0 {
                paidnumberOfActiveFilterCells+=1
                print("Number of active filtering cells is: \(paidnumberOfActiveFilterCells)")
            }
            paidsoundsfilteringCode = 1
            print("sounds filtering cell is active, sounds filtering code is: \(paidsoundsfilteringCode)")
            paidallSoundsFilteringCode += 1
            print("Filtering code for all sounds boxes added up: \(paidallSoundsFilteringCode)")
            paiddistorted808SoundFilteringCode = 1
        } else if paiddistorted808SoundFilteringCode == 1 {
            if paidallSoundsFilteringCode > 1 {
                if paidsoundsfilteringCode == 0 {
                    soundsBadge.alpha = 1
                    paidsoundsfilteringCode = 1
                    paidnumberOfActiveFilterCells+=1
                    print("Number of active filtering cells is: \(paidnumberOfActiveFilterCells)")
                }
            }
            if paidallSoundsFilteringCode == 1 {
                soundsBadge.alpha = 0
                paidsoundsfilteringCode = 0
                if paidnumberOfActiveFilterCells != 0 {
                    paidnumberOfActiveFilterCells-=1
                }
                print("Number of active filtering cells is: \(paidnumberOfActiveFilterCells)")
                print("No sounds filter checkboxes active, sounds filtering code is: \(paidsoundsfilteringCode)")
                print("No sounds filter checkboxes active, allsoundsfiltering code is: \(paidallSoundsFilteringCode)")
            }
            paidallSoundsFilteringCode -= 1
            print("Filtering code for all type boxes added up: \(paidallSoundsFilteringCode)")
            paiddistorted808SoundFilteringCode = 0
        }
        NotificationCenter.default.post(name: PaidFilterSoundsChangedNotify, object: "808 Distorted")
    }
    
    @IBAction func moogBassSoundCheckBoxTapped(_ sender: Any) {
        soundsBadge.alpha = 1
        if paidmoogBassSoundFilteringCode == 0 {
            if paidsoundsfilteringCode == 0 {
                paidnumberOfActiveFilterCells+=1
                print("Number of active filtering cells is: \(paidnumberOfActiveFilterCells)")
            }
            paidsoundsfilteringCode = 1
            print("sounds filtering cell is active, sounds filtering code is: \(paidsoundsfilteringCode)")
            paidallSoundsFilteringCode += 1
            print("Filtering code for all sounds boxes added up: \(paidallSoundsFilteringCode)")
            paidmoogBassSoundFilteringCode = 1
        } else if paidmoogBassSoundFilteringCode == 1 {
            if paidallSoundsFilteringCode > 1 {
                if paidsoundsfilteringCode == 0 {
                    soundsBadge.alpha = 1
                    paidsoundsfilteringCode = 1
                    paidnumberOfActiveFilterCells+=1
                    print("Number of active filtering cells is: \(paidnumberOfActiveFilterCells)")
                }
            }
            if paidallSoundsFilteringCode == 1 {
                soundsBadge.alpha = 0
                paidsoundsfilteringCode = 0
                if paidnumberOfActiveFilterCells != 0 {
                    paidnumberOfActiveFilterCells-=1
                }
                print("Number of active filtering cells is: \(paidnumberOfActiveFilterCells)")
                print("No sounds filter checkboxes active, sounds filtering code is: \(paidsoundsfilteringCode)")
                print("No sounds filter checkboxes active, allsoundsfiltering code is: \(paidallSoundsFilteringCode)")
            }
            paidallSoundsFilteringCode -= 1
            print("Filtering code for all type boxes added up: \(paidallSoundsFilteringCode)")
            paidmoogBassSoundFilteringCode = 0
        }
        NotificationCenter.default.post(name: PaidFilterSoundsChangedNotify, object: "Moog Bass")
    }
    
    @IBAction func subBassSoundCheckBoxTapped(_ sender: Any) {
        soundsBadge.alpha = 1
        if paidsubBassSoundFilteringCode == 0 {
            if paidsoundsfilteringCode == 0 {
                paidnumberOfActiveFilterCells+=1
                print("Number of active filtering cells is: \(paidnumberOfActiveFilterCells)")
            }
            paidsoundsfilteringCode = 1
            print("sounds filtering cell is active, sounds filtering code is: \(paidsoundsfilteringCode)")
            paidallSoundsFilteringCode += 1
            print("Filtering code for all sounds boxes added up: \(paidallSoundsFilteringCode)")
            paidsubBassSoundFilteringCode = 1
        } else if paidsubBassSoundFilteringCode == 1 {
            if paidallSoundsFilteringCode > 1 {
                if paidsoundsfilteringCode == 0 {
                    soundsBadge.alpha = 1
                    paidsoundsfilteringCode = 1
                    paidnumberOfActiveFilterCells+=1
                    print("Number of active filtering cells is: \(paidnumberOfActiveFilterCells)")
                }
            }
            if paidallSoundsFilteringCode == 1 {
                soundsBadge.alpha = 0
                paidsoundsfilteringCode = 0
                if paidnumberOfActiveFilterCells != 0 {
                    paidnumberOfActiveFilterCells-=1
                }
                print("Number of active filtering cells is: \(paidnumberOfActiveFilterCells)")
                print("No sounds filter checkboxes active, sounds filtering code is: \(paidsoundsfilteringCode)")
                print("No sounds filter checkboxes active, allsoundsfiltering code is: \(paidallSoundsFilteringCode)")
            }
            paidallSoundsFilteringCode -= 1
            print("Filtering code for all type boxes added up: \(paidallSoundsFilteringCode)")
            paidsubBassSoundFilteringCode = 0
        }
        NotificationCenter.default.post(name: PaidFilterSoundsChangedNotify, object: "Sub Bass")
    }
    
    @IBAction func synthBassDistortedSoundCheckBoxTapped(_ sender: Any) {
        soundsBadge.alpha = 1
        if paidsynthBassDistortedSoundFilteringCode == 0 {
            if paidsoundsfilteringCode == 0 {
                paidnumberOfActiveFilterCells+=1
                print("Number of active filtering cells is: \(paidnumberOfActiveFilterCells)")
            }
            paidsoundsfilteringCode = 1
            print("sounds filtering cell is active, sounds filtering code is: \(paidsoundsfilteringCode)")
            paidallSoundsFilteringCode += 1
            print("Filtering code for all sounds boxes added up: \(paidallSoundsFilteringCode)")
            paidsynthBassDistortedSoundFilteringCode = 1
        } else if paidsynthBassDistortedSoundFilteringCode == 1 {
            if paidallSoundsFilteringCode > 1 {
                if paidsoundsfilteringCode == 0 {
                    soundsBadge.alpha = 1
                    paidsoundsfilteringCode = 1
                    paidnumberOfActiveFilterCells+=1
                    print("Number of active filtering cells is: \(paidnumberOfActiveFilterCells)")
                }
            }
            if paidallSoundsFilteringCode == 1 {
                soundsBadge.alpha = 0
                paidsoundsfilteringCode = 0
                if paidnumberOfActiveFilterCells != 0 {
                    paidnumberOfActiveFilterCells-=1
                }
                print("Number of active filtering cells is: \(paidnumberOfActiveFilterCells)")
                print("No sounds filter checkboxes active, sounds filtering code is: \(paidsoundsfilteringCode)")
                print("No sounds filter checkboxes active, allsoundsfiltering code is: \(paidallSoundsFilteringCode)")
            }
            paidallSoundsFilteringCode -= 1
            print("Filtering code for all type boxes added up: \(paidallSoundsFilteringCode)")
            paidsynthBassDistortedSoundFilteringCode = 0
        }
        NotificationCenter.default.post(name: PaidFilterSoundsChangedNotify, object: "Synth Bass Distorted")
    }
    
    @IBAction func snapSoundCheckBoxTapped(_ sender: Any) {
        soundsBadge.alpha = 1
        if paidsnapSoundFilteringCode == 0 {
            if paidsoundsfilteringCode == 0 {
                paidnumberOfActiveFilterCells+=1
                print("Number of active filtering cells is: \(paidnumberOfActiveFilterCells)")
            }
            paidsoundsfilteringCode = 1
            print("sounds filtering cell is active, sounds filtering code is: \(paidsoundsfilteringCode)")
            paidallSoundsFilteringCode += 1
            print("Filtering code for all sounds boxes added up: \(paidallSoundsFilteringCode)")
            paidsnapSoundFilteringCode = 1
        } else if paidsnapSoundFilteringCode == 1 {
            if paidallSoundsFilteringCode > 1 {
                if paidsoundsfilteringCode == 0 {
                    soundsBadge.alpha = 1
                    paidsoundsfilteringCode = 1
                    paidnumberOfActiveFilterCells+=1
                    print("Number of active filtering cells is: \(paidnumberOfActiveFilterCells)")
                }
            }
            if paidallSoundsFilteringCode == 1 {
                soundsBadge.alpha = 0
                paidsoundsfilteringCode = 0
                if paidnumberOfActiveFilterCells != 0 {
                    paidnumberOfActiveFilterCells-=1
                }
                print("Number of active filtering cells is: \(paidnumberOfActiveFilterCells)")
                print("No sounds filter checkboxes active, sounds filtering code is: \(paidsoundsfilteringCode)")
                print("No sounds filter checkboxes active, allsoundsfiltering code is: \(paidallSoundsFilteringCode)")
            }
            paidallSoundsFilteringCode -= 1
            print("Filtering code for all type boxes added up: \(paidallSoundsFilteringCode)")
            paidsnapSoundFilteringCode = 0
        }
        NotificationCenter.default.post(name: PaidFilterSoundsChangedNotify, object: "Snap")
    }
    
    @IBAction func synthBassDeepSoundCheckBoxTapped(_ sender: Any) {
        soundsBadge.alpha = 1
        if paidsynthBassDeepSoundFilteringCode == 0 {
            if paidsoundsfilteringCode == 0 {
                paidnumberOfActiveFilterCells+=1
                print("Number of active filtering cells is: \(paidnumberOfActiveFilterCells)")
            }
            paidsoundsfilteringCode = 1
            print("sounds filtering cell is active, sounds filtering code is: \(paidsoundsfilteringCode)")
            paidallSoundsFilteringCode += 1
            print("Filtering code for all sounds boxes added up: \(paidallSoundsFilteringCode)")
            paidsynthBassDeepSoundFilteringCode = 1
        } else if paidsynthBassDeepSoundFilteringCode == 1 {
            if paidallSoundsFilteringCode > 1 {
                if paidsoundsfilteringCode == 0 {
                    soundsBadge.alpha = 1
                    paidsoundsfilteringCode = 1
                    paidnumberOfActiveFilterCells+=1
                    print("Number of active filtering cells is: \(paidnumberOfActiveFilterCells)")
                }
            }
            if paidallSoundsFilteringCode == 1 {
                soundsBadge.alpha = 0
                paidsoundsfilteringCode = 0
                if paidnumberOfActiveFilterCells != 0 {
                    paidnumberOfActiveFilterCells-=1
                }
                print("Number of active filtering cells is: \(paidnumberOfActiveFilterCells)")
                print("No sounds filter checkboxes active, sounds filtering code is: \(paidsoundsfilteringCode)")
                print("No sounds filter checkboxes active, allsoundsfiltering code is: \(paidallSoundsFilteringCode)")
            }
            paidallSoundsFilteringCode -= 1
            print("Filtering code for all type boxes added up: \(paidallSoundsFilteringCode)")
            paidsynthBassDeepSoundFilteringCode = 0
        }
        NotificationCenter.default.post(name: PaidFilterSoundsChangedNotify, object: "Synth Bass Deep")
    }
    
}

