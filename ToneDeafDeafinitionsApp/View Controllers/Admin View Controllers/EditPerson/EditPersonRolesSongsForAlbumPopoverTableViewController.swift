//
//  EditPersonRolesSongsForAlbumPopoverTableViewController.swift
//  ToneDeafDeafinitionsApp
//
//  Created by Tone Deaf on 7/31/22.
//  Copyright © 2022 GITEM Solutions. All rights reserved.
//

import UIKit
import MarqueeLabel
import BEMCheckBox

class EditPersonRolesSongsForAlbumPopoverTableViewController: UITableViewController {

    var skelvar = 0
    var initialLoad = false
    var data:[[YouTubeData]]!
    var trackArr:[String:String] = [:]
    @IBOutlet var tableViewPopover: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        data = []
        initialLoad = false
        //self.tableView.register(EditRolePopoverTableCellController.self, forCellReuseIdentifier: "editRolePopoverTableCell")
        let queue = DispatchQueue(label: "daskfhajbbvjghd,xjvc.km ueue")
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
        return trackArr.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "editRolesSongsForAlbumPopoverTableCellController", for: indexPath) as! EditRolesSongsForAlbumPopoverTableCellController
        let trackNums = Array(trackArr.keys)
        var tNum:[Int] = []
        for val in trackNums {
            let num = val.dropFirst(6)
            tNum.append(Int(num)!)
            tNum.sort()
        }
        cell.funcSetTemp(rolechoice: trackArr["Track \(tNum[indexPath.row])"]!, trackNum: "Track \(tNum[indexPath.row])")
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let currentCell = tableView.cellForRow(at: indexPath) as! EditRolesSongsForAlbumPopoverTableCellController
        if currentCell.checkbox.on {
            currentCell.checkbox.setOn(false, animated: true)
        } else {
            currentCell.checkbox.setOn(true, animated: true)
        }
        tableView.deselectRow(at: indexPath, animated: false)
    }

}

class EditRolesSongsForAlbumPopoverTableCellController: UITableViewCell {
    
    @IBOutlet weak var sngTitle: MarqueeLabel!
    @IBOutlet weak var trackNum: MarqueeLabel!
    @IBOutlet weak var appId: MarqueeLabel!
    @IBOutlet weak var checkbox: BEMCheckBox!
    
    func funcSetTemp(rolechoice: String, trackNum:String) {
        
        switch rolechoice.count {
        case 10:
            DatabaseManager.shared.findSongById(songId: rolechoice, completion: {[weak self] result in
                guard let strongSelf = self else {return}
                switch result {
                case.success(let song):
                        strongSelf.trackNum.text = trackNum
                    strongSelf.sngTitle.text = song.name
                    strongSelf.appId.text = song.toneDeafAppId
                case.failure(let err):
                    print("EditRolesSongsForAlbumPopoverTableCellControllerError ", err)
                }
            })
        case 12:
            DatabaseManager.shared.findInstrumentalById(instrumentalId: rolechoice, completion: {[weak self] result in
                guard let strongSelf = self else {return}
                switch result {
                case.success(let instrumental):
                        strongSelf.trackNum.text = trackNum
                    strongSelf.sngTitle.text = instrumental.instrumentalName
                    strongSelf.appId.text = instrumental.toneDeafAppId
                case.failure(let err):
                    print("EditRolesSongsForAlbumPopoverTableCellControllerError ", err)
                }
            })
        case 6:
            DatabaseManager.shared.fetchPersonData(person: rolechoice, completion: {[weak self] result in
                guard let strongSelf = self else {return}
                switch result {
                case.success(let person):
                    if !trackNum.contains("BLANK") {
                        strongSelf.trackNum.text = trackNum
                        strongSelf.trackNum.isHidden = true
                    }
                    else {
                        strongSelf.trackNum.text = ""
                    }
                    
                    strongSelf.sngTitle.text = person.name
                    strongSelf.appId.text = person.toneDeafAppId
                case.failure(let err):
                    print("EditRolesSongsForAlbumPopoverTableCellControllerError ", err)
                }
            })
        default:
            break
        }
    }
    
    @IBAction func checkboxTapped(_ sender: Any) {
        
    }
    
}

