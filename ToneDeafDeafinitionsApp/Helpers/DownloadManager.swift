//
//  DownloadManager.swift
//  ToneDeafDeafinitionsApp
//
//  Created by Tone Deaf on 10/14/20.
//  Copyright © 2020 GITEM Solutions. All rights reserved.
//

import Foundation
import MZDownloadManager
import FirebaseDatabase

let DownloadStartedNotificationKey = "com.gitemsolutions.DownloadStartedjkshdfgjkerhdfbn"
let DownloadStartedNotify = Notification.Name(DownloadStartedNotificationKey)

let DownloadEndedNotificationKey = "com.gitemsolutions.DownloadEndedjkshdfgjkerhdfbn"
let DownloadEndedNotify = Notification.Name(DownloadEndedNotificationKey)

let DownloadProgressNotificationKey = "com.gitemsolutions.DownloadProgressjkshdfgjkerhdfbn"
let DownloadProgressNotify = Notification.Name(DownloadProgressNotificationKey)

class DownloadManager {
    
    static let shared = DownloadManager()
    
    var currentBeat:BeatData!
    var extent:String!
    
    lazy var downloadManager: MZDownloadManager = {
        [unowned self] in
        let sessionIdentifer: String = "com.gitemSolutions.MZDownloadManager.BackgroundSession"
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        var completion = appDelegate.backgroundSessionCompletionHandler
        
        let downloadmanager = MZDownloadManager(session: sessionIdentifer, delegate: self, completion: completion)
        return downloadmanager
        }()
    
    var fileManger           : FileManager = FileManager.default
    //var mzDownloadingViewObj: DownloadsProfileViewController?
    let myDownloadPath = MZUtility.baseFilePath + "/My Downloads/TDApp"
    var filePath:String!
    
    
    func printDownloads() {
        do {
            let documentURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            let Path = documentURL.appendingPathComponent("My Downloads").absoluteURL
            let directoryContents = try FileManager.default.contentsOfDirectory(at: Path, includingPropertiesForKeys: nil, options: [])
            print(directoryContents)
        }
        catch {
            print(error.localizedDescription)
        }
    }
    
    func startDownload(beat:BeatData, exten: String) {
        currentBeat = beat
        extent = exten
        if !FileManager.default.fileExists(atPath: myDownloadPath) {
            do {
                try FileManager.default.createDirectory(atPath: myDownloadPath, withIntermediateDirectories: true, attributes:nil)
                print("directory created at \(myDownloadPath)")
            } catch let error as NSError {
                print("error while creating dir : \(error.localizedDescription)");
            }
        }
        //printDownloads()
        
        let fileURL  : NSString = beat.audioURL as NSString
        var proarray:[String] = []
        for pro in beat.producers {
            let word = pro.split(separator: "Æ")
            let name = word[1]
            proarray.append(String(name))
        }
        let fileName : NSString = ("\(beat.name) Produced by [\(proarray.joined(separator: ", "))] \(beat.tempo)BPM \(beat.key.replacingOccurrences(of: "/ ", with: "-")).mp3") as NSString
        filePath = myDownloadPath + "/" + (fileName as String)
        if FileManager().fileExists(atPath: filePath) {
            print("The file already exists at path")
            
        } else {
            downloadManager.addDownloadTask((fileName as String), fileURL: fileURL as String, destinationPath: myDownloadPath)
        }
    }
    
}

extension DownloadManager: MZDownloadManagerDelegate {
    func downloadRequestStarted(_ downloadModel: MZDownloadModel, index: Int) {
        let myDict:[String:Any] = ["dlm":downloadModel, "index":index]
        NotificationCenter.default.post(name: DownloadStartedNotify, object: myDict)
//        let indexPath = IndexPath.init(row: index, section: 0)
//        currentDownloadsTableView.insertRows(at: [indexPath], with: UITableView.RowAnimation.fade)
//        currentHeightConstraint.constant = CGFloat(downloadManager.downloadingArray.count*120)
//        view.layoutSubviews()
    }
    
    func downloadRequestDidPopulatedInterruptedTasks(_ downloadModels: [MZDownloadModel]) {
//        currentDownloadsTableView.reloadData()
//        currentHeightConstraint.constant = CGFloat(downloadManager.downloadingArray.count*120)
//        view.layoutSubviews()
    }
    
    func downloadRequestDidUpdateProgress(_ downloadModel: MZDownloadModel, index: Int) {
        let myDict:[String:Any] = ["dlm":downloadModel, "index":index]
        NotificationCenter.default.post(name: DownloadProgressNotify, object: myDict)
//        refreshCellForIndex(downloadModel, index: index)
    }
    
    func downloadRequestDidPaused(_ downloadModel: MZDownloadModel, index: Int) {
        let myDict:[String:Any] = ["dlm":downloadModel, "index":index]
        NotificationCenter.default.post(name: DownloadProgressNotify, object: myDict)
//        refreshCellForIndex(downloadModel, index: index)
    }
    
    func downloadRequestDidResumed(_ downloadModel: MZDownloadModel, index: Int) {
        let myDict:[String:Any] = ["dlm":downloadModel, "index":index]
        NotificationCenter.default.post(name: DownloadProgressNotify, object: myDict)
        //refreshCellForIndex(downloadModel, index: index)
    }
    
    func downloadRequestCanceled(_ downloadModel: MZDownloadModel, index: Int) {
        
//        safelyDismissAlertController()
//
//        let indexPath = IndexPath.init(row: index, section: 0)
//        currentDownloadsTableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.left)
//        currentHeightConstraint.constant = CGFloat(downloadManager.downloadingArray.count*120)
//        view.layoutSubviews()
    }
    
    func downloadRequestFinished(_ downloadModel: MZDownloadModel, index: Int) {
            
            let myDict:[String:Any] = ["dlm":downloadModel, "index":index]
            let id = "\(currentBeat.toneDeafAppId)Æ\(currentBeat.name)"
            let datee = getCurrentLocalDate()
            let dateFormatter = DateFormatter()
            dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
            let date = dateFormatter.date(from:datee)!
            var isthere = false
            for dloade in currentAppUser.downloads {
                if id == dloade.dbid {
                    isthere = true
                    dloade.timestamp = date
                    dloade.destinationPath = filePath
                    Database.database().reference().child("Users").child(currentAppUser.uid).child("Downloads").child(id).child("Timestamp").setValue(datee)
                    Database.database().reference().child("Users").child(currentAppUser.uid).child("Downloads").child(id).child("Destination Path").setValue(filePath)
                    NotificationCenter.default.post(name: DownloadEndedNotify, object: myDict)
                    return
                }
            }
            if isthere == false && !currentAppUser.downloads.contains(UserDownload(name:currentBeat.name+extent, dbid: id, timestamp: date, downloadURL: currentBeat.audioURL, destinationPath: downloadModel.destinationPath)){
                currentAppUser.downloads.append(UserDownload(name:currentBeat.name+extent, dbid: id, timestamp: date, downloadURL: currentBeat.audioURL, destinationPath: downloadModel.destinationPath))
                downloadedFilesArray = []
                for dload in currentAppUser.downloads {
                    if dload.destinationPath != nil {
                        downloadedFilesArray.append(dload)
                    }
                }
                DatabaseManager.shared.getBeatDownloads(currentBeat: currentBeat, completion: {[weak self] dloads in
                    guard let strongSelf = self else {return}
                    var num = dloads
                    num+=1
                    print(num)
                    Database.database().reference().child("Beats").child(strongSelf.currentBeat.priceType).child(strongSelf.currentBeat.beatID).child("Number of Downloads").setValue(num)
                })
                var RequiredInfoMap = [String : Any]()
                RequiredInfoMap = [
                    "Name" : currentBeat.name+extent,
                    "Timestamp" : datee,
                    "Download URL" : currentBeat.audioURL,
                    "Destination Path" : filePath!
                ]
                
                let RequiredRef = Database.database().reference().child("Users").child(currentAppUser.uid).child("Downloads").child(id)
                RequiredRef.updateChildValues(RequiredInfoMap) { [weak self] (error, songRef) in
                    guard let strongSelf = self else {return}
                    if let error = error {
                        print("📕 Failed to upload dictionary to database: \(error)")
                        Utilities.showError2("Failed to Upload. Please try again.", actionText: "OK")
                        return
                    } else {
                        NotificationCenter.default.post(name: DownloadEndedNotify, object: myDict)
                    }
                }
            }
        
    }
    
    func downloadRequestDidFailedWithError(_ error: NSError, downloadModel: MZDownloadModel, index: Int) {
//        self.safelyDismissAlertController()
//        self.refreshCellForIndex(downloadModel, index: index)
//
//        debugPrint("Error while downloading file: \(String(describing: downloadModel.fileName))  Error: \(String(describing: error))")
    }
    
    //Oppotunity to handle destination does not exists error
    //This delegate will be called on the session queue so handle it appropriately
    func downloadRequestDestinationDoestNotExists(_ downloadModel: MZDownloadModel, index: Int, location: URL) {
        
        let myDownloadPath = MZUtility.baseFilePath+"/My Downloads/TDApp"
        if !FileManager.default.fileExists(atPath: myDownloadPath) {
            try! FileManager.default.createDirectory(atPath: myDownloadPath, withIntermediateDirectories: true, attributes: nil)
        }
        try! FileManager.default.moveItem(at: location, to: URL(fileURLWithPath: filePath))
        debugPrint("Default folder path: \(myDownloadPath)")
    }
}
