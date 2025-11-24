//
//  DatabaseHomeViewController.swift
//  ToneDeafDeafinitionsApp
//
//  Created by Tone Deaf on 7/4/22.
//  Copyright © 2022 GITEM Solutions. All rights reserved.
//

import UIKit
import FirebaseDatabase

protocol DataEnteredDelegate: AnyObject {
    func userDidEnterInformation(info: [String])
}

class DatabaseHomeViewController: UIViewController, CustomCellUpdater, DataEnteredDelegate {
    
    
    @IBOutlet weak var adminKeyLabel: UILabel!
    @IBOutlet weak var adminKeyRefreshButton: UIButton!
    @IBOutlet weak var adminKeyStack: UIView!
    
    @IBOutlet weak var dBContentAddButton: UIButton!
    
    @IBOutlet weak var drillDownLabel: MarqueeLabel!
    @IBOutlet weak var drillDownAddButton: UIButton!
    @IBOutlet weak var drillDownTableView: UITableView!
    @IBOutlet weak var drillDownHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var drillDownStack: UIView!
    var drillDownDict:NSMutableDictionary = [:]
    var drillDownArr:[Any] = []
    var prevPathway:[String] = []
    var selectedDrillDict:[NSMutableDictionary:[String]] = [:]
    
    var pathKey:String!
    var keyToGo:String!
    var nextToGo:Any!
    var headLabel:String!
    var drilledLabel:String!
    var nexted:Any!
    
    weak var delegate: DataEnteredDelegate?
    

    override func viewDidLoad() {
        super.viewDidLoad()
//        if nexted == nil {
//            drillDownStack.isHidden = true
//            setAdminKey()
//            setAllContent()
//            setAppDocumentation()
//            setBeats()
//        } else {
            setDrill()
//        }
    }
    
    deinit {
        print("📗 Database Home being deallocated from memory. OS reclaiming")
    }
    
    func setAdminKey() {
        let ref = Database.database().reference().child("Admin Key")
        ref.observeSingleEvent(of: .value, with: {[weak self] snapshot in
            guard let strongSelf = self else {return}
            if let val = snapshot.value {
                let valu = val as? String
                guard let value = valu else {return}
                strongSelf.adminKeyLabel.text = value
            }
        })
    }
    
    func setDrill() {
        if let ll = drilledLabel {
            adminKeyStack.isHidden = true
            drillDownLabel.text = ll
        } else {
            drillDownLabel.text = "Content"
            setAdminKey()
        }
        
        if let nex = nexted as? NSMutableDictionary {
//            prevPathway.append(pathKey)
            drillDownDict = nex
            drillDownTableView.delegate = self
            drillDownTableView.dataSource  = self
            drillDownTableView.reloadData()
            drillDownHeightConstraint.constant = CGFloat(30*(drillDownDict.allKeys.count))
        } else
        if let nex = nexted as? [Any] {
//            prevPathway.append(pathKey)
//            print(nex)
            drillDownArr = nex
            drillDownTableView.delegate = self
            drillDownTableView.dataSource  = self
            drillDownTableView.reloadData()
            drillDownHeightConstraint.constant = CGFloat(30*(drillDownArr.count))
        }
        else {
            let ref = Database.database().reference()
            ref.observeSingleEvent(of: .value, with: {[weak self] snapshot in
                guard let strongSelf = self else {return}
                if let val = snapshot.value {
                    let valu = val as? NSMutableDictionary
                    guard let value = valu else {return}
                    strongSelf.drillDownDict = value
                    strongSelf.drillDownDict.removeObject(forKey: "Admin Key")
                    strongSelf.drillDownTableView.delegate = self
                    strongSelf.drillDownTableView.dataSource  = self
                    strongSelf.drillDownTableView.reloadData()
                    strongSelf.drillDownHeightConstraint.constant = CGFloat(30*(strongSelf.drillDownDict.allKeys.count))
                }
            })
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        if self.isMovingFromParent {
            if self.previousViewController is DatabaseHomeViewController {
                delegate!.userDidEnterInformation(info: Array(prevPathway.dropLast(1)))
            }
            
        }
    }
    
    func userDidEnterInformation(info: Array<String>) {
            prevPathway = info
        drillDownTableView.reloadData()
        }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
//            print(prevPathway)
    }
    
    
    func updateTableView() {
        _ = self.navigationController?.popToRootViewController(animated: true)
    }
    
    func removeNode(indexPath: IndexPath) {
        let alertC = UIAlertController(title: "Are You Sure?",
                                       message: "Are you sure you wish to delete this node pair?",
                                       preferredStyle: .alert)
        
        let changeAction = UIAlertAction(title: "Delete", style: .destructive, handler: {[weak self] _ in
            guard let strongSelf = self else {return}
            var path = ""
            if strongSelf.drillDownDict.count > 0 {
                path = "\(strongSelf.prevPathway.joined(separator: "/"))/\(strongSelf.drillDownDict.allKeys[indexPath.row])"
                strongSelf.drillDownDict.removeObject(forKey: strongSelf.drillDownDict.allKeys[indexPath.row])
                strongSelf.drillDownHeightConstraint.constant = CGFloat(30*(strongSelf.drillDownDict.allKeys.count))
            }
            else {
                path = "\(strongSelf.prevPathway.joined(separator: "/"))/\(indexPath.row)"
                strongSelf.drillDownArr.remove(at: indexPath.row)
                strongSelf.drillDownHeightConstraint.constant = CGFloat(30*(strongSelf.drillDownArr.count))
            }
            Database.database().reference().child(path).removeValue()
            strongSelf.drillDownTableView.reloadData()
            strongSelf.updateTableView()
            alertC.dismiss(animated: true, completion: nil)
        })
        alertC.addAction(UIAlertAction(title: "Keep", style: .cancel, handler: nil))
        alertC.addAction(changeAction)
        alertC.view.tintColor = UIColor.init(red: 182/255, green: 0/255, blue: 3/255, alpha: 1)
        alertC.view.tintColor = Constants.Colors.redApp
        
        NotificationCenter.default.post(name: OpenTheAlertAdminNotify, object: alertC)
        
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "databaseToDatabaseDrillDown" {
            if let viewController: DatabaseHomeViewController = segue.destination as? DatabaseHomeViewController {
                viewController.nexted = nextToGo
                viewController.drilledLabel = headLabel
                viewController.prevPathway = prevPathway
                viewController.delegate = self
            }
        }
    }
    
    @IBAction func addDBEntryTapped(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc3 = storyboard.instantiateViewController(identifier: "databaseAddViewController") as DatabaseAddViewController
        vc3.preferredContentSize = CGSize(width: 350, height: 220) // 4 default cell heights.
        let constraintWidth = NSLayoutConstraint(
            item: vc3.view!, attribute: NSLayoutConstraint.Attribute.width, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute:
                NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: 350)
        vc3.view.addConstraint(constraintWidth)
        var ll = "Content"
        if drilledLabel != nil {
            ll = drilledLabel!
        }
        let alertC = UIAlertController(title: "Add to '\(ll)' node",
                                       message: "",
                                       preferredStyle: .alert)
        alertC.setValue(vc3, forKey: "contentViewController")
        let editAction = UIAlertAction(title: "Add", style: .default, handler: {[weak self] _ in
            guard let strongSelf = self else {return}
            let node = vc3.nodeTextfield.text
            let key = vc3.keyTextfield.text
            let value = vc3.valueTextField.text
            var dict:NSDictionary = [:]
            print(strongSelf.prevPathway)
            var path = "\(strongSelf.prevPathway.joined(separator: "/"))"
            
            guard key != "" else {
                mediumImpactGenerator.impactOccurred()
                Utilities.showError2("Key can not be blank.", actionText: "OK")
                return
            }
            if vc3.nodeCheckbox.on {
                guard node != "" else {
                    mediumImpactGenerator.impactOccurred()
                    Utilities.showError2("Node can not be blank.", actionText: "OK")
                    return
                }
                path = "\(strongSelf.prevPathway.joined(separator: "/"))/\(node!)"
                dict = [
                    key!:value
                    ]
                let nodeDict = [
                    node : dict
                ]
                if strongSelf.drillDownArr.count > 0 {
                    strongSelf.drillDownArr.append(nodeDict)
                    strongSelf.drillDownTableView.reloadData()
                    strongSelf.drillDownHeightConstraint.constant = CGFloat(30*(strongSelf.drillDownArr.count))
                } else {
                    strongSelf.drillDownDict.setValue(dict, forKey: node!)
                    strongSelf.drillDownTableView.reloadData()
                    strongSelf.drillDownHeightConstraint.constant = CGFloat(30*(strongSelf.drillDownDict.allKeys.count))
                }
            }
            else {
                dict = [key!:value]
                if strongSelf.drillDownArr.count > 0 {
                    strongSelf.drillDownArr.append(value!)
                    strongSelf.drillDownTableView.reloadData()
                    strongSelf.drillDownHeightConstraint.constant = CGFloat(30*(strongSelf.drillDownArr.count))
                } else {
                    strongSelf.drillDownDict.setValue(value, forKey: key!)
                    strongSelf.drillDownTableView.reloadData()
                    strongSelf.drillDownHeightConstraint.constant = CGFloat(30*(strongSelf.drillDownDict.allKeys.count))
                }
            }
            
//            print(strongSelf.drillDownDict, strongSelf.drillDownArr)
            
            Database.database().reference().child(path).child(key!).setValue(value)
            strongSelf.updateTableView()
            Utilities.successBarBanner("Path added successfully.")
            alertC.dismiss(animated: true, completion: nil)
        })
        alertC.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alertC.addAction(editAction)
        alertC.view.tintColor = UIColor.init(red: 182/255, green: 0/255, blue: 3/255, alpha: 1)
        alertC.view.tintColor = Constants.Colors.redApp
        
        NotificationCenter.default.post(name: OpenTheAlertAdminNotify, object: alertC)
    }
    
}

extension DatabaseHomeViewController : UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch tableView {
        case drillDownTableView:
            if drillDownDict.count > 0 {
                return drillDownDict.allKeys.count
            }
            if drillDownArr.count > 0 {
                return drillDownArr.count
            }
            else {
                return 0
            }
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch tableView {
        case drillDownTableView:
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "databaseLabelCell", for: indexPath) as! DatabaseLabelCell
            cell.delegate = self
            if drillDownDict.allKeys.count > 0 {
                let typee = drillDownDict.allValues[indexPath.row]
                if typee is NSArray || typee is NSDictionary {
                    cell.setUp(keyl: drillDownDict.allKeys[indexPath.row] as! String, more: drillDownDict, go: indexPath.row, prevPath: prevPathway)
                }
                else {
                    cell.setUp(dictitem: drillDownDict.allValues[indexPath.row], keyl: drillDownDict.allKeys[indexPath.row] as! String, prevPath: prevPathway)
                }
            }
            if drillDownArr.count > 0 {
                
                cell.setUp(dictitem: drillDownArr[indexPath.row], keyl: String(indexPath.row), prevPath: prevPathway)
            }
            else {
                
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
        let cell = tableView.cellForRow(at: indexPath) as! DatabaseLabelCell
        
        if cell.moreItems != nil {
            if let nex =  cell.moreItems as? NSDictionary {
                nextToGo = nex[Array(nex.allKeys)[indexPath.row]]
                headLabel = Array(nex.allKeys)[indexPath.row] as! String
                if !cell.pathway.contains(cell.keyToGo) {
                    cell.pathway.append(cell.keyToGo)
                }
                prevPathway = cell.pathway
                if nextToGo is NSDictionary || nextToGo is Array<Any> {
                        performSegue(withIdentifier: "databaseToDatabaseDrillDown", sender: nil)
                }
            }
        } else {
            
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            switch tableView {
            case drillDownTableView:
                removeNode(indexPath: indexPath)
            default:
                break
            }
        }
    }
    
    
}

import MarqueeLabel

protocol CustomCellUpdater: class { // the name of the protocol you can put any
    func updateTableView()
}

class DatabaseLabelCell: UITableViewCell {
    
    @IBOutlet weak var value: MarqueeLabel!
    @IBOutlet weak var key: MarqueeLabel!
    @IBOutlet weak var chev: UIImageView!
    let pasteboard = UIPasteboard.general
    
    var moreItems:Any!
    var keyForLP:String!
    var valueForLP:String!
    var pathway:[String]!
    var keyToGo:String!
    
    weak var delegate: CustomCellUpdater?

    func yourFunctionWhichDoesNotHaveASender() {
        delegate!.updateTableView()
    }
    
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        chev.isHidden = true
//        pathway = []
    }
    
    func setUp(arrayitem: String, keyl:String, prevPath: [String]) {
        pathway = prevPath
        keyToGo = keyl
        keyForLP = keyl
        setPress()
        valueForLP = arrayitem
        value.text = arrayitem
        key.text = keyl + ":"
    }
    
    func setUp(dictitem: String, keyl:String, prevPath: [String]) {
        pathway = prevPath
        keyToGo = keyl
        keyForLP = keyl
        setPress()
        var dit = dictitem
        if dictitem == "" {
            dit = "\"\""
        }
        chev.isHidden = true
        valueForLP = dit
        value.text = dit
        key.text = keyl + ": "
    }
    
    func setUp(dictitem: Any, keyl:String, prevPath: [String]) {
        pathway = prevPath
        keyToGo = keyl
        keyForLP = keyl
        setPress()
        switch dictitem {
        case is String:
            let dc = dictitem as! String
            var dit = dc
            if dc == "" {
                dit = "\"\""
            }
            chev.isHidden = true
            valueForLP = dit
            value.text = dit
            key.text = keyl + ": "
        case is Int:
            let dc = dictitem as! Int
            let dit = String(dc)
            chev.isHidden = true
            valueForLP = dit
            value.text = dit
            key.text = keyl + ": "
        case is Bool:
            let dc = dictitem as! Bool
            let dit = String(dc)
            chev.isHidden = true
            valueForLP = dit
            value.text = dit
            key.text = keyl + ": "
        default:
            break
        }
    }
    
    func setUp(keyl:String , more: NSDictionary, go:Int, prevPath: [String]) {
        pathway = prevPath
        keyToGo = keyl
        keyForLP = keyl
        setPress()
        moreItems = more
        chev.isHidden = false
        valueForLP = ""
        value.text = ""
        key.text = keyl
    }
    
    func setPress() {
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(longPress(guesture:)))
        longPress.minimumPressDuration = 0.5
        longPress.delegate = self
        self.contentView.addGestureRecognizer(longPress)
    }
    
    @objc func longPress(guesture: UILongPressGestureRecognizer) {
            switch guesture.state {
            case UIGestureRecognizer.State.began:
//                print(pathway)
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let vc3 = storyboard.instantiateViewController(identifier: "databaseEditViewController") as DatabaseEditViewController
                vc3.preferredContentSize = CGSize(width: 350, height: 100) // 4 default cell heights.
                let constraintWidth = NSLayoutConstraint(
                    item: vc3.view!, attribute: NSLayoutConstraint.Attribute.width, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute:
                        NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: 350)
                vc3.view.addConstraint(constraintWidth)
                
                let alertC = UIAlertController(title: keyForLP,
                                               message: "",
                                               preferredStyle: .alert)
                alertC.setValue(vc3, forKey: "contentViewController")
                let editAction = UIAlertAction(title: "Edit", style: .default, handler: {[weak self] _ in
                    guard let strongSelf = self else {return}
                    alertC.dismiss(animated: true, completion: nil)
                    strongSelf.openChangeAlert()
                })
                let keyAction = UIAlertAction(title: "Copy Key", style: .default, handler: {[weak self] _ in
                    guard let strongSelf = self else {return}
                    strongSelf.pasteboard.string = strongSelf.keyForLP
                    alertC.dismiss(animated: true, completion: nil)
                    Utilities.successBanner("Key copied to clipboard")
                })
                let valueAction = UIAlertAction(title: "Copy Value", style: .default, handler: {[weak self] _ in
                    guard let strongSelf = self else {return}
                    strongSelf.pasteboard.string = strongSelf.valueForLP
                    alertC.dismiss(animated: true, completion: nil)
                    Utilities.successBanner("Value copied to clipboard")
                })
                alertC.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                alertC.addAction(keyAction)
                alertC.view.tintColor = UIColor.init(red: 182/255, green: 0/255, blue: 3/255, alpha: 1)
                alertC.view.tintColor = Constants.Colors.redApp
                
                if valueForLP == "" {
                    vc3.valueStackView.isHidden = true
                } else {
                    vc3.valueStackView.isHidden = false
                    vc3.valueLabel.text = valueForLP
                    alertC.addAction(valueAction)
                }
                alertC.addAction(editAction)
                
                vc3.keyLabel.text = keyForLP
                
                NotificationCenter.default.post(name: OpenTheAlertAdminNotify, object: alertC)
                return
            case UIGestureRecognizer.State.changed:
                break
            case UIGestureRecognizer.State.ended:
                break
                
            default:
                break
            }
    }
    
    func openChangeAlert() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc3 = storyboard.instantiateViewController(identifier: "databaseEditViewController") as DatabaseEditViewController
        vc3.preferredContentSize = CGSize(width: 350, height: 100) // 4 default cell heights.
        let constraintWidth = NSLayoutConstraint(
            item: vc3.view!, attribute: NSLayoutConstraint.Attribute.width, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute:
                NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: 350)
        vc3.view.addConstraint(constraintWidth)
        
        let alertC = UIAlertController(title: keyForLP,
                                       message: "",
                                       preferredStyle: .alert)
        alertC.setValue(vc3, forKey: "contentViewController")
        
        let changeAction = UIAlertAction(title: "Change", style: .default, handler: {[weak self] _ in
            guard let strongSelf = self else {return}
            var newKey:String!
            var newValue:String!
            if vc3.keyTextfield.text != strongSelf.keyForLP && vc3.keyTextfield.text != "" {
                newKey = vc3.keyTextfield.text
            }
            else {
                newKey = strongSelf.keyForLP
            }
            
            if vc3.valueTextField.text != strongSelf.valueForLP {
                newValue = vc3.valueTextField.text
            }
            strongSelf.areYouSureAlert(newKey: newKey, newValue: newValue)
            alertC.dismiss(animated: true, completion: nil)
        })
        
        vc3.keyLabel.isHidden = true
        vc3.keyTextfield.isHidden = false
        vc3.keyTextfield.text = keyForLP
        vc3.valueLabel.isHidden = true
        vc3.valueTextField.isHidden = false
        vc3.valueTextField.text = valueForLP
        changeAction.isEnabled = true
        alertC.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alertC.addAction(changeAction)
        alertC.view.tintColor = UIColor.init(red: 182/255, green: 0/255, blue: 3/255, alpha: 1)
        alertC.view.tintColor = Constants.Colors.redApp
        
        if valueForLP == "" {
            vc3.valueStackView.isHidden = true
        } else {
            vc3.valueStackView.isHidden = false
        }
        
        NotificationCenter.default.post(name: OpenTheAlertAdminNotify, object: alertC)
    }
    
    func areYouSureAlert(newKey: String, newValue: String?) {
        let alertC = UIAlertController(title: "Are You Sure?",
                                       message: "Are you sure you wish to modify this key/value pair?",
                                       preferredStyle: .alert)
        
        let changeAction = UIAlertAction(title: "Modify", style: .destructive, handler: {[weak self] _ in
            guard let strongSelf = self else {return}
            var path = ""
            if newValue != nil && newKey == strongSelf.keyForLP{
                path = "\(strongSelf.pathway.joined(separator: "/"))/\(newKey)"
                Database.database().reference().child(path).setValue(newValue)
                strongSelf.yourFunctionWhichDoesNotHaveASender()
                Utilities.successBarBanner("Value updtated.")
            } else if newKey != strongSelf.keyForLP && newValue == nil {
                if let items = strongSelf.moreItems as? NSDictionary {
                    path = "\(strongSelf.pathway.joined(separator: "/"))/\(newKey)"
                    let oldpath = "\(strongSelf.pathway.joined(separator: "/"))/\(strongSelf.keyForLP!)"
                    let ket = items[strongSelf.keyForLP!]
                    
                    Database.database().reference().child(path).setValue(ket)
                    Database.database().reference().child(oldpath).removeValue()
                    strongSelf.yourFunctionWhichDoesNotHaveASender()
                    Utilities.successBarBanner("Key updtated.")
                }
                if let items = strongSelf.moreItems as? NSArray {
                }
            } else if newValue != nil && newKey != strongSelf.keyForLP! {
                
                path = "\(strongSelf.pathway.joined(separator: "/"))/\(newKey)"
                let oldpath = "\(strongSelf.pathway.joined(separator: "/"))/\(strongSelf.keyForLP!)"
                Database.database().reference().child(path).setValue(newValue)
                Database.database().reference().child(oldpath).removeValue()
                strongSelf.yourFunctionWhichDoesNotHaveASender()
                Utilities.successBarBanner("Key/Value pair updtated.")
            }
            else {
                print("nothing to change")
            }
                alertC.dismiss(animated: true, completion: nil)
        })
        alertC.addAction(UIAlertAction(title: "Keep", style: .cancel, handler: nil))
        alertC.addAction(changeAction)
        alertC.view.tintColor = UIColor.init(red: 182/255, green: 0/255, blue: 3/255, alpha: 1)
        alertC.view.tintColor = Constants.Colors.redApp
        
        NotificationCenter.default.post(name: OpenTheAlertAdminNotify, object: alertC)
    }
}
