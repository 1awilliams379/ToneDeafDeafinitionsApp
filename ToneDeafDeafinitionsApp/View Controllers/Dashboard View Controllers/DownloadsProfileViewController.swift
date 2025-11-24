//
//  DownloadsProfileViewController.swift
//  ToneDeafDeafinitionsApp
//
//  Created by Tone Deaf on 10/14/20.
//  Copyright © 2020 GITEM Solutions. All rights reserved.
//

import UIKit
import MZDownloadManager
import MarqueeLabel

class DownloadsProfileViewController: UIViewController {
    
    @IBOutlet weak var currentDownloadsTableView:UITableView!
    @IBOutlet weak var downloadedTableView:UITableView!
    
    @IBOutlet weak var currentHeightConstraint:NSLayoutConstraint!
    @IBOutlet weak var downloadedHeightConstraint:NSLayoutConstraint!
    
    var currentDownloadSelectedIndexPath : IndexPath!
    var downloadedSelectedIndexPath    : IndexPath?
    var fileManger           : FileManager = FileManager.default
    
    let downloadManager = DownloadManager.shared.downloadManager

    override func viewDidLoad() {
        super.viewDidLoad()
        let nib = UINib(nibName: "Header", bundle: nil)
        downloadedTableView.tableFooterView = UIView()
        currentDownloadsTableView.tableFooterView = UIView()
        downloadedTableView.register(nib, forHeaderFooterViewReuseIdentifier: "TableSectionHeader")
        currentDownloadsTableView.register(nib, forHeaderFooterViewReuseIdentifier: "TableSectionHeader")
        createObservers()
        currentDownloadsTableView.delegate = self
        currentDownloadsTableView.dataSource = self
        downloadedTableView.delegate = self
        downloadedTableView.dataSource = self
        setUpDownloadsArray()
        currentHeightConstraint.constant = CGFloat(70+(downloadManager.downloadingArray.count*138))
    }
    
    func createObservers() {
        NotificationCenter.default.removeObserver(self)
        NotificationCenter.default.addObserver(self, selector: #selector(downloadRequestStarted(notification:)), name: DownloadStartedNotify, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(downloadRequestFinished(notification:)), name: DownloadEndedNotify, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(downloadRequestDidUpdateProgress(notification:)), name: DownloadProgressNotify, object: nil)
    }
    
    func setUpDownloadsArray() {
        downloadedFilesArray = []
        //print(currentAppUser.downloads)
        for dload in currentAppUser.downloads {
            if dload.destinationPath != nil {
                downloadedFilesArray.append(dload)
            }
        }
        downloadedTableView.reloadData()
        downloadedHeightConstraint.constant = CGFloat(70+(downloadedFilesArray.count*80))
        UIView.animate(withDuration: 0.5) {[weak self] in
            guard let strongSelf = self else {return}
            strongSelf.view.layoutSubviews()
        }
        
    }
    
    func refreshCellForIndex(_ downloadModel: MZDownloadModel, index: Int) {
        let indexPath = IndexPath.init(row: index, section: 0)
        let cell = currentDownloadsTableView.cellForRow(at: indexPath)
        if let cell = cell {
            let downloadCell = cell as! CurrentDownloadsCell
            downloadCell.updateCellForRowAtIndexPath(indexPath, downloadModel: downloadModel)
        }
    }
    
}

extension DownloadsProfileViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if self.tableView(tableView, numberOfRowsInSection: section) > 0 {
            return 70
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableHeaderFooterView(withIdentifier: "TableSectionHeader") as! TableSectionHeader
        var sectitle = ""
        
        switch tableView {
        case downloadedTableView:
            sectitle = "Previously Downloaded"
        default:
            sectitle = "In Progress"
        }
        let header = cell
        header.titleLabel.text = sectitle
        
        return cell
        
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch tableView {
        case downloadedTableView:
            return 80
        default:
            return 138
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch tableView {
        case downloadedTableView:
            let cellIdentifier : NSString = "downloadedFileCell"
            let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier as String, for: indexPath) as! downloadedFileCell
            
            cell.funcSetTemp(item: downloadedFilesArray[(indexPath as NSIndexPath).row])
            
            return cell
        default:
            let cellIdentifier : String = "currentDownloadsCell"
            let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! CurrentDownloadsCell
            
            let downloadModel = downloadManager.downloadingArray[indexPath.row]
            cell.updateCellForRowAtIndexPath(indexPath, downloadModel: downloadModel)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch tableView {
        case downloadedTableView:
            return downloadedFilesArray.count
        default:
            return downloadManager.downloadingArray.count
        }
    }
    
    //This Is what Starts The download
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch tableView {
        case downloadedTableView:
            print("jvdn")
        default:
                currentDownloadSelectedIndexPath = indexPath
                let downloadModel = downloadManager.downloadingArray[indexPath.row]
                showAppropriateActionController(downloadModel.status)
                tableView.deselectRow(at: indexPath, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if tableView == downloadedTableView {
//            let fileName : NSString = downloadedFilesArray[(indexPath as NSIndexPath).row] as NSString
//            let fileURL  : URL = URL(fileURLWithPath: (soundDirPathString as NSString).appendingPathComponent(fileName as String))
//
//            do {
//                try fileManger.removeItem(at: fileURL)
//                downloadedFilesArray.remove(at: (indexPath as NSIndexPath).row)
//                downloadedTableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.fade)
//            } catch let error as NSError {
//                debugPrint("Error while deleting file: \(error)")
//            }
        }
    }
}

extension DownloadsProfileViewController {
    func showAppropriateActionController(_ requestStatus: String) {
        
        if requestStatus == TaskStatus.downloading.description() {
            self.showAlertControllerForPause()
        } else if requestStatus == TaskStatus.failed.description() {
            self.showAlertControllerForRetry()
        } else if requestStatus == TaskStatus.paused.description() {
            self.showAlertControllerForStart()
        }
    }
    
    func showAlertControllerForPause() {
        
        let pauseAction = UIAlertAction(title: "Pause", style: .default) { (alertAction: UIAlertAction) in
            self.downloadManager.pauseDownloadTaskAtIndex(self.currentDownloadSelectedIndexPath.row)
        }
        
        let removeAction = UIAlertAction(title: "Remove", style: .destructive) { (alertAction: UIAlertAction) in
            self.downloadManager.cancelTaskAtIndex(self.currentDownloadSelectedIndexPath.row)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alertController.view.tag = alertControllerViewTag
        alertController.addAction(pauseAction)
        alertController.addAction(removeAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func showAlertControllerForRetry() {
        
        let retryAction = UIAlertAction(title: "Retry", style: .default) { (alertAction: UIAlertAction) in
            self.downloadManager.retryDownloadTaskAtIndex(self.currentDownloadSelectedIndexPath.row)
        }
        
        let removeAction = UIAlertAction(title: "Remove", style: .destructive) { (alertAction: UIAlertAction) in
            self.downloadManager.cancelTaskAtIndex(self.currentDownloadSelectedIndexPath.row)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alertController.view.tag = alertControllerViewTag
        alertController.addAction(retryAction)
        alertController.addAction(removeAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func showAlertControllerForStart() {
        
        let startAction = UIAlertAction(title: "Start", style: .default) { (alertAction: UIAlertAction) in
            self.downloadManager.resumeDownloadTaskAtIndex(self.currentDownloadSelectedIndexPath.row)
        }
        
        let removeAction = UIAlertAction(title: "Remove", style: .destructive) { (alertAction: UIAlertAction) in
            self.downloadManager.cancelTaskAtIndex(self.currentDownloadSelectedIndexPath.row)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alertController.view.tag = alertControllerViewTag
        alertController.addAction(startAction)
        alertController.addAction(removeAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func safelyDismissAlertController() {
        /***** Dismiss alert controller if and only if it exists and it belongs to MZDownloadManager *****/
        /***** E.g App will eventually crash if download is completed and user tap remove *****/
        /***** As it was already removed from the array *****/
        if let controller = self.presentedViewController {
            guard controller is UIAlertController && controller.view.tag == alertControllerViewTag else {
                return
            }
            controller.dismiss(animated: true, completion: nil)
        }
    }
}

extension DownloadsProfileViewController {
    @objc func downloadRequestStarted(notification:Notification) {
        let myDict = (notification.object as! [String:Any])
        let index = myDict["index"] as! Int
        //let dlmodel = myDict["dlm"] as! MZDownloadModel
        let indexPath = IndexPath.init(row: index, section: 0)
        currentDownloadsTableView.insertRows(at: [indexPath], with: UITableView.RowAnimation.fade)
        currentHeightConstraint.constant = CGFloat(70+(downloadManager.downloadingArray.count*138))
        UIView.animate(withDuration: 0.5) {[weak self] in
            guard let strongSelf = self else {return}
            strongSelf.view.layoutSubviews()
        }
    }

    func downloadRequestDidPopulatedInterruptedTasks(_ dxownloadModels: [MZDownloadModel]) {
        currentDownloadsTableView.reloadData()
        currentHeightConstraint.constant = CGFloat(70+(downloadManager.downloadingArray.count*138))
        UIView.animate(withDuration: 0.5) {[weak self] in
            guard let strongSelf = self else {return}
            strongSelf.view.layoutSubviews()
        }
    }

    @objc func downloadRequestDidUpdateProgress(notification: Notification) {
        let myDict = (notification.object as! [String:Any])
        let index = myDict["index"] as! Int
        let dlmodel = myDict["dlm"] as! MZDownloadModel
        refreshCellForIndex(dlmodel, index: index)
    }

    func downloadRequestDidPaused(_ downloadModel: MZDownloadModel, index: Int) {
        refreshCellForIndex(downloadModel, index: index)
    }

    func downloadRequestDidResumed(_ downloadModel: MZDownloadModel, index: Int) {
        refreshCellForIndex(downloadModel, index: index)
    }

    func downloadRequestCanceled(_ downloadModel: MZDownloadModel, index: Int) {

        safelyDismissAlertController()

        let indexPath = IndexPath.init(row: index, section: 0)
        currentDownloadsTableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.left)
        currentHeightConstraint.constant = CGFloat(70+(downloadManager.downloadingArray.count*138))
        UIView.animate(withDuration: 0.5) {[weak self] in
            guard let strongSelf = self else {return}
            strongSelf.view.layoutSubviews()
        }
    }

    @objc func downloadRequestFinished(notification: Notification) {
        let myDict = (notification.object as! [String:Any])
        let index = myDict["index"] as! Int
        safelyDismissAlertController()

        downloadManager.presentNotificationForDownload("Ok", notifBody: "Download did completed")

        let indexPath = IndexPath.init(row: index, section: 0)
        currentDownloadsTableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.left)
        currentHeightConstraint.constant = CGFloat(70+(downloadManager.downloadingArray.count*138))
        //let docDirectoryPath : NSString = (MZUtility.baseFilePath as NSString).appendingPathComponent(downloadModel.fileName) as NSString
        //downloadedFilesArray.append(docDirectoryPath.lastPathComponent)
        //print(downloadedFilesArray)
        downloadedTableView.reloadData()
        downloadedTableView.reloadSections(IndexSet(integer: 0), with: UITableView.RowAnimation.fade)
        downloadedHeightConstraint.constant = CGFloat(70+(downloadedFilesArray.count*80))
        UIView.animate(withDuration: 0.5) {[weak self] in
            guard let strongSelf = self else {return}
            strongSelf.view.layoutSubviews()
        }
    }

    func downloadRequestDidFailedWithError(_ error: NSError, downloadModel: MZDownloadModel, index: Int) {
        self.safelyDismissAlertController()
        self.refreshCellForIndex(downloadModel, index: index)

        debugPrint("Error while downloading file: \(String(describing: downloadModel.fileName))  Error: \(String(describing: error))")
    }

    //Oppotunity to handle destination does not exists error
    //This delegate will be called on the session queue so handle it appropriately
    func downloadRequestDestinationDoestNotExists(_ downloadModel: MZDownloadModel, index: Int, location: URL) {
        let myDownloadPath = MZUtility.baseFilePath + "/Default folder"
        if !FileManager.default.fileExists(atPath: myDownloadPath) {
            try! FileManager.default.createDirectory(atPath: myDownloadPath, withIntermediateDirectories: true, attributes: nil)
        }
        let fileName = MZUtility.getUniqueFileNameWithPath((myDownloadPath as NSString).appendingPathComponent(downloadModel.fileName as String) as NSString)
        let path =  myDownloadPath + "/" + (fileName as String)
        try! FileManager.default.moveItem(at: location, to: URL(fileURLWithPath: path))
        debugPrint("Default folder path: \(myDownloadPath)")
    }
}

class CurrentDownloadsCell: UITableViewCell {

    @IBOutlet var lblTitle : UILabel?
    @IBOutlet var lblDetails : UILabel?
    @IBOutlet var progressDownload : UIProgressView?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func updateCellForRowAtIndexPath(_ indexPath : IndexPath, downloadModel: MZDownloadModel) {
        
        lblTitle?.text = "File Title: \(downloadModel.fileName!)"
        progressDownload?.progress = downloadModel.progress
        
        var remainingTime: String = ""
        if downloadModel.progress == 1.0 {
            remainingTime = "Please wait..."
        } else if let _ = downloadModel.remainingTime {
            if (downloadModel.remainingTime?.hours)! > 0 {
                remainingTime = "\(downloadModel.remainingTime!.hours) Hours "
            }
            if (downloadModel.remainingTime?.minutes)! > 0 {
                remainingTime = remainingTime + "\(downloadModel.remainingTime!.minutes) Min "
            }
            if (downloadModel.remainingTime?.seconds)! > 0 {
                remainingTime = remainingTime + "\(downloadModel.remainingTime!.seconds) sec"
            }
        } else {
            remainingTime = "Calculating..."
        }
        
        var fileSize = "Getting information..."
        if let _ = downloadModel.file?.size {
            fileSize = String(format: "%.2f %@", (downloadModel.file?.size)!, (downloadModel.file?.unit)!)
        }

        var speed = "Calculating..."
        if let _ = downloadModel.speed?.speed {
            speed = String(format: "%.2f %@/sec", (downloadModel.speed?.speed)!, (downloadModel.speed?.unit)!)
        }
        
        var downloadedFileSize = "Calculating..."
        if let _ = downloadModel.downloadedFile?.size {
            downloadedFileSize = String(format: "%.2f %@", (downloadModel.downloadedFile?.size)!, (downloadModel.downloadedFile?.unit)!)
        }
        
        let detailLabelText = NSMutableString()
        detailLabelText.appendFormat("File Size: \(fileSize)\nDownloaded: \(downloadedFileSize) (%.2f%%)\nSpeed: \(speed)\nTime Left: \(remainingTime)\nStatus: \(downloadModel.status)" as NSString, downloadModel.progress * 100.0)
        lblDetails?.text = detailLabelText as String
    }
}

import NVActivityIndicatorView

class downloadedFileCell:UITableViewCell {
    
    @IBOutlet weak var spinner:NVActivityIndicatorView!
    @IBOutlet weak var itemName:MarqueeLabel!
    @IBOutlet weak var itemDetail:MarqueeLabel!
    @IBOutlet weak var itemImage:UIImageView!
    @IBOutlet weak var moreButton:UIButton!
    @IBOutlet weak var downloadButton:UIButton!
    
    var currbeat:BeatData!
    var item:UserDownload!
    
    deinit {
        spinner.stopAnimating()
    }
    
    override func prepareForReuse() {
        downloadButton.isHidden = false
        spinner.stopAnimating()
        currbeat = nil
        item = nil
        itemImage.image = nil
    }
    
    func funcSetTemp(item:UserDownload) {
        self.item = item
        itemImage.layer.cornerRadius = 7
        let word = item.dbid.split(separator: "Æ")
        let id = word[0]
        setBeatInfo(id: String(id))
        itemName.text = item.name
        addGestures()
    }
    
    func addGestures() {
        downloadButton.addTarget(self, action: #selector(downloadTapped), for: .touchUpInside)
    }
    
    func checkFileDownload(destination: String) {
        if FileManager().fileExists(atPath: destination) {
            downloadButton.isHidden = true
            print("File is currently downloaded on device.")
        } else {
            print("File is no longer on device.")
            downloadButton.isHidden = false
        }
    }
    
    func setBeatInfo(id: String) {
        DatabaseManager.shared.findBeatById(beatId: id, completion: {[weak self] result in
            guard let strongSelf = self else {return}
            switch result {
            case .success(let beat):
                strongSelf.currbeat = beat
                let imageURL = URL(string: beat.imageURL)!
                if let cachedImage = imageCache.object(forKey: imageURL.absoluteString as NSString) {
                    strongSelf.itemImage.image = cachedImage
                } else {
                    strongSelf.itemImage.setImage(from: imageURL, withPlaceholder: UIImage(named: "tonedeaflogo"))
                }
                guard let path = strongSelf.item.destinationPath else {return}
                strongSelf.checkFileDownload(destination: path)
            case .failure(let errr):
            print(errr)
            }
        })
    }
    
    @objc func downloadTapped() {
        downloadButton.isHidden = true
        spinner.startAnimating()
        let ex = item.name.suffix(4)
        DownloadManager.shared.startDownload(beat: currbeat, exten: String(ex))
    }
}

