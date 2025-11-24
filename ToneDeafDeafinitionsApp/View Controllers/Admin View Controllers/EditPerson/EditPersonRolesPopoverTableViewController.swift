//
//  EditPersonRolesPopoverTableViewController.swift
//  ToneDeafDeafinitionsApp
//
//  Created by Tone Deaf on 6/26/22.
//  Copyright © 2022 GITEM Solutions. All rights reserved.
//

import UIKit
import MarqueeLabel
import BEMCheckBox

class EditPersonRolesPopoverTableViewController: UITableViewController {

    var skelvar = 0
    var initialLoad = false
    var data:[[YouTubeData]]!
    var roleArr:[String] = ["Artist", "Producer", "Writer", "Mix Engineer", "Mastering Engineer", "Recording Engineer"]
    @IBOutlet var tableViewPopover: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        data = []
        initialLoad = false
        //self.tableView.register(EditRolePopoverTableCellController.self, forCellReuseIdentifier: "editRolePopoverTableCell")
        let queue = DispatchQueue(label: "daskfhajbd,xjvc.km ueue")
        let group = DispatchGroup()
        let array = [1]

        for i in array {
            //print(i)
            group.enter()
            queue.async { [weak self] in
                guard let strongSelf = self else {return}
                switch i {
                case 1:
                    //print("null")
                    strongSelf.setUpTable(completion: {
                        DispatchQueue.main.async {
                            strongSelf.initialLoad = true
                            strongSelf.tableViewPopover.reloadData()
                        }
                        print("done \(i)")
                        group.leave()
                    })
                default:
                    print("error")
                }
            }
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //tableview.showAnimatedSkeleton(usingColor: .wetAsphalt, transition: .crossDissolve(0.25))
    }
    
    func setUpTable(completion: @escaping () -> Void) {
        
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return roleArr.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "editRolePopoverTableCell", for: indexPath) as! EditRolePopoverTableCellController
        cell.funcSetTemp(rolechoice: roleArr[indexPath.row])
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let currentCell = tableView.cellForRow(at: indexPath) as! EditRolePopoverTableCellController
        
        if currentCell.role.text == "Official Video" {
            for i in 0 ... roleArr.count {
                if let cell = tableView.cellForRow(at: IndexPath(row: i, section: 0)) as? EditRolePopoverTableCellController {
                    if cell.role.text != "Official Video" {
                        cell.checkbox.setOn(false, animated: true)
                    }
                }
            }
        }
        if currentCell.role.text == "Audio Video" {
            for i in 0 ... roleArr.count {
                if let cell = tableView.cellForRow(at: IndexPath(row: i, section: 0)) as? EditRolePopoverTableCellController {
                    if cell.role.text != "Audio Video" {
                        cell.checkbox.setOn(false, animated: true)
                    }
                }
            }
            
        }
        if currentCell.role.text == "Lyric Video" {
            for i in 0 ... roleArr.count {
                if let cell = tableView.cellForRow(at: IndexPath(row: i, section: 0)) as? EditRolePopoverTableCellController {
                    if cell.role.text != "Lyric Video" {
                        cell.checkbox.setOn(false, animated: true)
                    }
                }
            }
            
        }
        if currentCell.role.text == "Other Video" {
            for i in 0 ... roleArr.count {
                if let cell = tableView.cellForRow(at: IndexPath(row: i, section: 0)) as? EditRolePopoverTableCellController {
                    if cell.role.text != "Other Video" {
                        cell.checkbox.setOn(false, animated: true)
                    }
                }
            }
            
        }
        
        if currentCell.checkbox.on {
            currentCell.checkbox.setOn(false, animated: true)
            if currentCell.role.text == "Main Artist" {
                let featCell = tableView.cellForRow(at: IndexPath(row: 1, section: 0)) as! EditRolePopoverTableCellController
                featCell.isUserInteractionEnabled = true
                featCell.checkbox.alpha = 1
                featCell.role.alpha = 1
                featCell.checkbox.setOn(false, animated: true)
            }
        } else {
            currentCell.checkbox.setOn(true, animated: true)
            if currentCell.role.text == "Main Artist" {
                let featCell = tableView.cellForRow(at: IndexPath(row: 1, section: 0)) as! EditRolePopoverTableCellController
                featCell.isUserInteractionEnabled = false
                featCell.checkbox.alpha = 0.5
                featCell.role.alpha = 0.5
                featCell.checkbox.setOn(true, animated: true)
            }
        }
        tableView.deselectRow(at: indexPath, animated: false)
    }

}

class EditRolePopoverTableCellController: UITableViewCell {
    
    @IBOutlet weak var role: UILabel!
    @IBOutlet weak var checkbox: BEMCheckBox!
    
    func funcSetTemp(rolechoice: String) {
        role.text = rolechoice
        if rolechoice == "Main Artist" {
            checkbox.isUserInteractionEnabled = false
        }
    }
    
    @IBAction func checkboxTapped(_ sender: Any) {
        
    }
    
}

class RolePopoverTableViewController: UITableView {
    override var intrinsicContentSize: CGSize {
        layoutIfNeeded()
        return CGSize(width: UIView.noIntrinsicMetric, height: contentSize.height)
    }
}


