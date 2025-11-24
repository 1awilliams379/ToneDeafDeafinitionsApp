//
//  SelectTonesPickItemViewController.swift
//  ToneDeafDeafinitionsApp
//
//  Created by Tone Deaf on 9/21/20.
//  Copyright © 2020 GITEM Solutions. All rights reserved.
//

import UIKit
import SkeletonView
import MarqueeLabel
import FirebaseDatabase

class SelectTonesPickItemViewController: UIViewController {
    
    @IBOutlet weak var pickTableView: UITableView!
    
    var skelvar = 0
    var array = ""
    var knownOldestPersonElement:PersonData!
    var knownOldestSongElement:SongData!
    var knownOldestVideoElement:VideoData!
    var knownOldestBeatElement:BeatData!
    var knownOldestAlbumElement:AlbumData!
    var knownOldestInstrumentalElement:InstrumentalData!
    var lastPersons:[PersonData] = []
    var lastSongs:[SongData] = []
    var lastVideos:[VideoData] = []
    var lastBeats:[BeatData] = []
    var lastAlbums:[AlbumData] = []
    var lastInstrumentals:[InstrumentalData] = []
    var lastfetchedkey:String = ""
    var all = false
    var prevPage = ""
    
    var exeptions:[Any] = []
    var selectedAlbum:AlbumData!
    var selectedVideo:VideoData!
    var selectedSong:SongData!
    var selectedPerson:PersonData!
    var newRoleArr:[String] = []
    weak var editPersonAllPersonsDelegate: EditPersonAllPersonsDelegate!
    weak var songsDelegate: EditPersonSongsDelegate!
    weak var albumsDelegate: EditPersonAlbumsDelegate!
    weak var videosDelegate: EditPersonVideosDelegate!
    weak var instrumentalsDelegate: EditPersonInstrumentalsDelegate!
    weak var editPersonBeatsDelegate: EditPersonBeatsDelegate!
    
    weak var editSongAllSongsDelegate: EditSongAllSongsDelegate!
    weak var editSongPersonsDelegate: EditSongPersonsDelegate!
    weak var editSongAlbumsDelegate: EditSongAlbumsDelegate!
    weak var editSongVideosDelegate: EditSongVideosDelegate!
    weak var editSongInstrumentalsDelegate: EditSongInstrumentalsDelegate!
    weak var editSongSongsDelegate: EditSongSongsDelegate!
    
    weak var editAlbumAllAlbumsDelegate: EditAlbumAllAlbumsDelegate!
    weak var editAlbumPersonsDelegate: EditAlbumPersonsDelegate!
    weak var editAlbumTracksDelegate: EditAlbumTracksDelegate!
    weak var editAlbumSongsDelegate: EditAlbumSongsDelegate!
    weak var editAlbumVideosDelegate: EditAlbumVideosDelegate!
    weak var editAlbumInstrumentalsDelegate: EditAlbumInstrumentalsDelegate!
    weak var editAlbumAlbumsDelegate: EditAlbumAlbumsDelegate!
    
    weak var editVideoAllVideosDelegate: EditVideoAllVideosDelegate!
    weak var editVideoPersonsDelegate: EditVideoPersonsDelegate!
    weak var editVideoSongsDelegate: EditVideoSongsDelegate!
    
    weak var uploadBeatProducersDelegate: UploadBeatProducersDelegate!
    
    weak var uploadKitsPersonsDelegate: UploadKitsPersonsDelegate!
    weak var uploadKitsSongsDelegate: UploadKitsSongsDelegate!
    weak var uploadKitsInstrumentalsDelegate: UploadKitsInstrumentalsDelegate!
    weak var uploadKitsVideosDelegate: UploadKitsVideosDelegate!
    weak var uploadKitsAlbumsDelegate: UploadKitsAlbumsDelegate!
    weak var uploadKitsBeatsDelegate: UploadKitsBeatsDelegate!
    
    deinit {
        AllSongsInDatabaseArray = nil
        print("📗 Select Tones Pick view controller deinitialized.")
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        skelvar = 0
        pickTableView.delegate = self
        pickTableView.dataSource = self
        all = false
        lastfetchedkey = ""
        switch array {
        case "track" :
            hideskeleton(tableview: pickTableView)
        case "person" :
            if prevPage == "uploadBeat" || prevPage == "uploadKits" || prevPage == "editSong" || prevPage == "editAlbum" || prevPage == "editVideo" {
                let exceptions = exeptions as! [PersonData]
                AllPersonsInDatabaseArray = nil
                knownOldestSongElement = nil
                lastfetchedkey = ""
                DatabaseManager.shared.fetchAllPersonsFromDatabase(page: 10, exceptions: exceptions, completion: {[weak self] persons in
                    guard let strongSelf = self else {return}
                    guard !persons.isEmpty else {
                        strongSelf.pickTableView.isHidden = true
                        return
                    }
                    AllPersonsInDatabaseArray = persons
                    strongSelf.lastPersons = persons
                    strongSelf.knownOldestPersonElement = AllPersonsInDatabaseArray.last
                    strongSelf.lastfetchedkey = "\(strongSelf.knownOldestPersonElement.name!)--\(strongSelf.knownOldestPersonElement.dateRegisteredToApp!)--\(strongSelf.knownOldestPersonElement.timeRegisteredToApp!)--\(strongSelf.knownOldestPersonElement.toneDeafAppId)"
                    strongSelf.hideskeleton(tableview: strongSelf.pickTableView)
                })
            }
            if prevPage == "adminDash" || prevPage == "editPersonAll" {
                DatabaseManager.shared.fetchAllPersonsFromDatabase(page: 10, completion: {[weak self] persons in
                    guard let strongSelf = self else {return}
                    guard !persons.isEmpty else {
                        strongSelf.pickTableView.isHidden = true
                        return
                        
                    }
                    AllPersonsInDatabaseArray = persons
                    strongSelf.lastPersons = persons
                    strongSelf.knownOldestPersonElement = AllPersonsInDatabaseArray.last
                    strongSelf.lastfetchedkey = "\(strongSelf.knownOldestPersonElement.name!)--\(strongSelf.knownOldestPersonElement.dateRegisteredToApp!)--\(strongSelf.knownOldestPersonElement.timeRegisteredToApp!)--\(strongSelf.knownOldestPersonElement.toneDeafAppId)"
                    strongSelf.hideskeleton(tableview: strongSelf.pickTableView)
                })
            }
        case "song":
            if prevPage == "editPerson" || prevPage == "uploadKits" || prevPage == "editAlbum" || prevPage == "editSong" || prevPage == "editVideo" {
                let exceptions = exeptions as! [SongData]
                AllSongsInDatabaseArray = nil
                knownOldestSongElement = nil
                lastfetchedkey = ""
                DatabaseManager.shared.fetchAllSongsFromDatabase(page: 10, exceptions: exceptions, completion: {[weak self] songs in
                    print("songs ", songs)
                    guard let strongSelf = self else {return}
                    guard !songs.isEmpty else {
                        strongSelf.pickTableView.isHidden = true
                        return
                    }
                    AllSongsInDatabaseArray = songs
                    strongSelf.lastSongs = songs
                    strongSelf.knownOldestSongElement = AllSongsInDatabaseArray.last
                    strongSelf.lastfetchedkey = "\(songContentTag)--\(strongSelf.knownOldestSongElement.name)--\(strongSelf.knownOldestSongElement.toneDeafAppId)"
                    strongSelf.hideskeleton(tableview: strongSelf.pickTableView)
                })
            } else {
                if AllSongsInDatabaseArray == nil {
                    DatabaseManager.shared.fetchAllSongsFromDatabase(page: 10, completion: {[weak self] songs in
                        guard let strongSelf = self else {return}
                        guard !songs.isEmpty else {
                            strongSelf.pickTableView.isHidden = true
                            return
                            
                        }
                        AllSongsInDatabaseArray = songs
                        strongSelf.lastSongs = songs
                        strongSelf.knownOldestSongElement = AllSongsInDatabaseArray.last
                        strongSelf.lastfetchedkey = "\(songContentTag)--\(strongSelf.knownOldestSongElement.name)--\(strongSelf.knownOldestSongElement.toneDeafAppId)"
                        strongSelf.hideskeleton(tableview: strongSelf.pickTableView)
                    })
                } else {
                    knownOldestSongElement = AllSongsInDatabaseArray.last
                    lastfetchedkey = "\(songContentTag)--\(knownOldestSongElement.name)--\(knownOldestSongElement.toneDeafAppId)"
                    hideskeleton(tableview: pickTableView)
                }
            }
        case "video":
                if prevPage == "editPerson" || prevPage == "uploadKits" || prevPage == "editSong" || prevPage == "editAlbum" {
                    let exceptions = exeptions as! [VideoData]
                    AllVideosInDatabaseArray = nil
                    knownOldestVideoElement = nil
                    lastfetchedkey = ""
                    DatabaseManager.shared.fetchAllVideosFromDatabase(page: 10, exceptions: exceptions, completion: {[weak self] videos in
                        print("videos ", videos)
                        
                        guard let strongSelf = self else {return}
                        guard !videos.isEmpty else {
                            strongSelf.pickTableView.isHidden = true
                            return
                        }
                        AllVideosInDatabaseArray = videos
                        strongSelf.lastVideos = videos
                        strongSelf.knownOldestVideoElement = AllVideosInDatabaseArray.last
                        var songart:[String] = []
                            strongSelf.lastfetchedkey = ("\(videoContentTag)--\(strongSelf.knownOldestVideoElement.title.replacingOccurrences(of: ".", with: " ").replacingOccurrences(of: "#", with: " ").replacingOccurrences(of: "$", with: " ").replacingOccurrences(of: "[", with: " ").replacingOccurrences(of: "]", with: " ").replacingOccurrences(of: ":", with: " "))--\(strongSelf.knownOldestVideoElement.toneDeafAppId)")
                        strongSelf.hideskeleton(tableview: strongSelf.pickTableView)
                    })
                } else {
            if AllVideosInDatabaseArray == nil {
                DatabaseManager.shared.fetchAllVideosFromDatabase(page: 10, completion: {[weak self] videos in
                    guard let strongSelf = self else {return}
                    AllVideosInDatabaseArray = videos
                    strongSelf.lastVideos = videos
                    strongSelf.knownOldestVideoElement = AllVideosInDatabaseArray.last
                    var songart:[String] = []
                        strongSelf.lastfetchedkey = ("\(videoContentTag)--\(strongSelf.knownOldestVideoElement.title.replacingOccurrences(of: ".", with: " ").replacingOccurrences(of: "#", with: " ").replacingOccurrences(of: "$", with: " ").replacingOccurrences(of: "[", with: " ").replacingOccurrences(of: "]", with: " ").replacingOccurrences(of: ":", with: " "))--\(strongSelf.knownOldestVideoElement.toneDeafAppId)")
                    strongSelf.hideskeleton(tableview: strongSelf.pickTableView)
                })
            } else {
                knownOldestVideoElement = AllVideosInDatabaseArray.last
                var songart:[String] = []
                    lastfetchedkey = ("\(videoContentTag)--\(knownOldestVideoElement.title.replacingOccurrences(of: ".", with: " ").replacingOccurrences(of: "#", with: " ").replacingOccurrences(of: "$", with: " ").replacingOccurrences(of: "[", with: " ").replacingOccurrences(of: "]", with: " ").replacingOccurrences(of: ":", with: " "))--\(knownOldestVideoElement.toneDeafAppId)")
                hideskeleton(tableview: pickTableView)
            }
        }
        case "editbeatvideo":
            if AllVideosInDatabaseArray == nil {
                DatabaseManager.shared.fetchAllVideosFromDatabase(page: 10, completion: {[weak self] videos in
                    guard let strongSelf = self else {return}
                    AllVideosInDatabaseArray = videos
                    strongSelf.lastVideos = videos
                    strongSelf.knownOldestVideoElement = AllVideosInDatabaseArray.last
                    var songart:[String] = []
                    switch strongSelf.knownOldestVideoElement {
                    case is YouTubeData:
                        let video = strongSelf.knownOldestVideoElement as! YouTubeData
                        //                    for art in video.artist {
                        //                        let word = art.split(separator: "Æ")
                        //                        let id = word[1]
                        //                        songart.append(String(id))
                        //                    }
                        strongSelf.lastfetchedkey = ("\(video.type)--\(video.title.replacingOccurrences(of: ".", with: " ").replacingOccurrences(of: "#", with: " ").replacingOccurrences(of: "$", with: " ").replacingOccurrences(of: "[", with: " ").replacingOccurrences(of: "]", with: " ").replacingOccurrences(of: ":", with: " "))--\(video.toneDeafAppId)")
                    default:
                        print("that other thang")
                    }
                    strongSelf.hideskeleton(tableview: strongSelf.pickTableView)
                })
            } else {
                knownOldestVideoElement = AllVideosInDatabaseArray.last
                var songart:[String] = []
                switch knownOldestVideoElement {
                case is YouTubeData:
                    let video = knownOldestVideoElement as! YouTubeData
                    //                for art in video.artist {
                    //                    let word = art.split(separator: "Æ")
                    //                    let id = word[1]
                    //                    songart.append(String(id))
                    //                }
                    lastfetchedkey = ("\(video.type)--\(video.title.replacingOccurrences(of: ".", with: " ").replacingOccurrences(of: "#", with: " ").replacingOccurrences(of: "$", with: " ").replacingOccurrences(of: "[", with: " ").replacingOccurrences(of: "]", with: " ").replacingOccurrences(of: ":", with: " "))--\(video.toneDeafAppId)")
                default:
                    print("that other thang")
                }
                hideskeleton(tableview: pickTableView)
            }
        case "beat":
            if prevPage == "editPerson" || prevPage == "uploadKits" {
                let exceptions = exeptions as! [BeatData]
                AllBeatsInDatabaseArray = nil
                knownOldestBeatElement = nil
                lastfetchedkey = ""
                DatabaseManager.shared.fetchAllBeatsFromDatabase(page: 10, exceptions: exceptions, completion: {[weak self] beats in
                    guard let strongSelf = self else {return}
                    guard !beats.isEmpty else {
                        strongSelf.pickTableView.isHidden = true
                        return
                    }
                    AllBeatsInDatabaseArray = beats
                    strongSelf.lastBeats = beats
                    strongSelf.knownOldestBeatElement = AllBeatsInDatabaseArray.last
                    strongSelf.lastfetchedkey = "\(beatContentTag)--\(strongSelf.knownOldestBeatElement.name)--\(strongSelf.knownOldestBeatElement.toneDeafAppId)"
                    strongSelf.hideskeleton(tableview: strongSelf.pickTableView)
                })
            } else {
                if AllBeatsInDatabaseArray == nil {
                    DatabaseManager.shared.fetchAllBeatsFromDatabase(page: 10, price: "Free", completion: {[weak self] beats in
                        guard let strongSelf = self else {return}
                        AllBeatsInDatabaseArray = beats
                        strongSelf.lastBeats = beats
                        strongSelf.knownOldestBeatElement = AllBeatsInDatabaseArray.last
                        strongSelf.lastfetchedkey = strongSelf.knownOldestBeatElement.beatID
                        strongSelf.hideskeleton(tableview: strongSelf.pickTableView)
                    })
                } else {
                    knownOldestBeatElement = AllBeatsInDatabaseArray.last
                    lastfetchedkey = knownOldestBeatElement.beatID
                    hideskeleton(tableview: pickTableView)
                }
            }
        case "album":
            if prevPage == "editPerson" || prevPage == "editSong"  || prevPage == "editAlbum" || prevPage == "uploadKits" {
                let exceptions = exeptions as! [AlbumData]
                AllAlbumsInDatabaseArray = nil
                knownOldestAlbumElement = nil
                lastfetchedkey = ""
                DatabaseManager.shared.fetchAllAlbumsFromDatabase(page: 10, exceptions: exceptions, completion: {[weak self] albums in
                    print("albums ", albums)
                    guard let strongSelf = self else {return}
                    guard !albums.isEmpty else {
                        strongSelf.pickTableView.isHidden = true
                        return
                    }
                    AllAlbumsInDatabaseArray = albums
                    strongSelf.lastAlbums = albums
                    strongSelf.knownOldestAlbumElement = AllAlbumsInDatabaseArray.last
                    strongSelf.lastfetchedkey = "\(albumContentTag)--\(strongSelf.knownOldestAlbumElement.name)--\(strongSelf.knownOldestAlbumElement.toneDeafAppId)"
                    strongSelf.hideskeleton(tableview: strongSelf.pickTableView)
                })
            } else {
                if AllAlbumsInDatabaseArray == nil {
                    DatabaseManager.shared.fetchAllAlbumsFromDatabase(page: 10, completion: {[weak self] albums in
                        
                        guard let strongSelf = self else {return}
                        AllAlbumsInDatabaseArray = albums
                        strongSelf.lastAlbums = albums
                        strongSelf.knownOldestAlbumElement = AllAlbumsInDatabaseArray.last
                        strongSelf.lastfetchedkey = "\(albumContentTag)--\(strongSelf.knownOldestAlbumElement.name)--\(strongSelf.knownOldestAlbumElement.toneDeafAppId)"
                        strongSelf.hideskeleton(tableview: strongSelf.pickTableView)
                    })
                } else {
                    knownOldestAlbumElement = AllAlbumsInDatabaseArray.last
                    lastfetchedkey = "\(albumContentTag)--\(knownOldestAlbumElement.name)--\(knownOldestAlbumElement.toneDeafAppId)"
                    hideskeleton(tableview: pickTableView)
                }
                
            }
        default:
            if prevPage == "editPerson" || prevPage == "editSong" || prevPage == "editAlbum" || prevPage == "uploadKits" {
                let exceptions = exeptions as! [InstrumentalData]
                AllInstrumentalsInDatabaseArray = nil
                knownOldestInstrumentalElement = nil
                lastfetchedkey = ""
                DatabaseManager.shared.fetchAllInstrumentalsFromDatabase(page: 10, exceptions: exceptions, completion: {[weak self] instrumentals in
                    guard let strongSelf = self else {return}
                    guard !instrumentals.isEmpty else {
                        strongSelf.pickTableView.isHidden = true
                        return
                    }
                    AllInstrumentalsInDatabaseArray = instrumentals
                    strongSelf.lastInstrumentals = instrumentals
                    strongSelf.knownOldestInstrumentalElement = AllInstrumentalsInDatabaseArray.last
                    strongSelf.lastfetchedkey = "\(instrumentalContentType)--\(strongSelf.knownOldestInstrumentalElement.songName!)--\(strongSelf.knownOldestInstrumentalElement.toneDeafAppId)"
                    strongSelf.hideskeleton(tableview: strongSelf.pickTableView)
                })
            } else {
                if AllInstrumentalsInDatabaseArray == nil {
                    DatabaseManager.shared.fetchAllInstrumentalsFromDatabase(page: 10, completion: {[weak self] instrumentals in
                        guard let strongSelf = self else {return}
                        AllInstrumentalsInDatabaseArray = instrumentals
                        strongSelf.lastInstrumentals = instrumentals
                        strongSelf.knownOldestInstrumentalElement = AllInstrumentalsInDatabaseArray.last
                        strongSelf.lastfetchedkey = ("\(instrumentalContentType )--\(strongSelf.knownOldestInstrumentalElement.songName!)--\(strongSelf.knownOldestInstrumentalElement.dateRegisteredToApp ?? "")--\(strongSelf.knownOldestInstrumentalElement.timeRegisteredToApp ?? "")--\(strongSelf.knownOldestInstrumentalElement.toneDeafAppId)")
                        strongSelf.hideskeleton(tableview: strongSelf.pickTableView)
                    })
                } else {
                    knownOldestInstrumentalElement = AllInstrumentalsInDatabaseArray.last
                    lastfetchedkey = ("\(instrumentalContentType)--\(knownOldestInstrumentalElement.songName!)--\( knownOldestInstrumentalElement.dateRegisteredToApp ?? "")--\(knownOldestInstrumentalElement.timeRegisteredToApp ?? "")--\(knownOldestInstrumentalElement.toneDeafAppId)")
                    hideskeleton(tableview: pickTableView)
                }
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if skelvar == 0 {
            pickTableView.isSkeletonable = true
            pickTableView.showAnimatedGradientSkeleton(usingGradient: .init(baseColor: UIColor.init(red: 22/255, green: 22/255, blue: 22/255, alpha: 1)), animation: nil, transition: .crossDissolve(0.25))
        }
        
    skelvar+=1
        //tableview.showAnimatedSkeleton(usingColor: .wetAsphalt, transition: .crossDissolve(0.25))
    }
    
    func openConfirmation(video: VideoData) {
        switch prevPage {
        case "adminDash":
            selectedVideo = video
            performSegue(withIdentifier: "tonesPickToEditVideo", sender: nil)
            _ = self.navigationController?.viewControllers.removeAll { $0 is SelectTonesPickItemViewController }
        case "editVideoAll":
            editVideoAllVideosDelegate.selectedVideo(video)
            _ = self.navigationController?.popViewController(animated: true)
        case "uploadKits":
            let actionSheet = UIAlertController(title: "Add",
                                                message: "Are you sure you want to add \(video.title)?",
                                                preferredStyle: .alert)
            actionSheet.addAction(UIAlertAction(title: "Yes",
                                                style: .default,
                                                handler: { [weak self] _ in
                                                    guard let strongSelf = self else {return}
                strongSelf.uploadKitsVideosDelegate.videoAdded(video)
                _ = strongSelf.navigationController?.popViewController(animated: true)
                
            }))
            
            actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            actionSheet.view.tintColor = Constants.Colors.redApp
            
            present(actionSheet, animated: true)
        case "editPerson":
            newRoleArr = []
            alertController = UIAlertController(title: "Add \(video.title)",
                                                    message: "Select Roles",
                                                    preferredStyle: .alert)
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc3 = storyboard.instantiateViewController(identifier: "editPersonRolesPopoverTableViewController") as
            EditPersonRolesPopoverTableViewController
            vc3.preferredContentSize = CGSize(width: 350, height: 120)
            vc3.tableView.isScrollEnabled = false
            alertController.setValue(vc3, forKey: "contentViewController")
            vc3.roleArr = ["Videographer", "Other Person"]
            vc3.tableViewPopover.reloadData()
            
            let addAction = UIAlertAction(title: "Add", style: .default, handler: {[weak self] _ in
                guard let strongSelf = self else {return}
                let cc = alertController.value(forKey: "contentViewController") as! EditPersonRolesPopoverTableViewController
                for i in 1 ... (cc.roleArr.count) {
                    let dex = i-1
                    if let cell = cc.tableViewPopover.cellForRow(at: IndexPath(row: dex, section: 0)) as? EditRolePopoverTableCellController {
                        if cell.checkbox.on {
                            strongSelf.newRoleArr.append(cell.role.text!)
                        }
                    }
                }
                strongSelf.videosDelegate.videoAdded([strongSelf.newRoleArr:video])
                _ = strongSelf.navigationController?.popViewController(animated: true)
            })

            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
            { (action) in
                // ...
            }
            alertController.addAction(cancelAction)
            alertController.addAction(addAction)
            alertController.view.tintColor = Constants.Colors.redApp

            
            alertController.view.tintColor = UIColor.init(red: 182/255, green: 0/255, blue: 3/255, alpha: 1)
            self.present(alertController, animated: true)
            {
                // ...
            }
        case "editAlbum":
            newRoleArr = []
            alertController = UIAlertController(title: "Add \(video.title)",
                                                    message: "Select the videos relationship to the album",
                                                    preferredStyle: .alert)
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc3 = storyboard.instantiateViewController(identifier: "editPersonRolesPopoverTableViewController") as
            EditPersonRolesPopoverTableViewController
            vc3.preferredContentSize = CGSize(width: 350, height: 240)
            vc3.tableView.isScrollEnabled = false
            alertController.setValue(vc3, forKey: "contentViewController")
            vc3.roleArr = ["Official Video", "Other Video"]
            vc3.tableViewPopover.reloadData()
            
            let addAction = UIAlertAction(title: "Add", style: .default, handler: {[weak self] _ in
                guard let strongSelf = self else {return}
                let cc = alertController.value(forKey: "contentViewController") as! EditPersonRolesPopoverTableViewController
                for i in 1 ... (cc.roleArr.count) {
                    let dex = i-1
                    if let cell = cc.tableViewPopover.cellForRow(at: IndexPath(row: dex, section: 0)) as? EditRolePopoverTableCellController {
                        if cell.checkbox.on {
                            strongSelf.editAlbumVideosDelegate.videoAdded([cell.role.text!:video])
                            _ = strongSelf.navigationController?.popViewController(animated: true)
                        }
                    }
                }
            })

            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
            { (action) in
                // ...
            }
            alertController.addAction(cancelAction)
            alertController.addAction(addAction)
            alertController.view.tintColor = Constants.Colors.redApp

            self.present(alertController, animated: true)
            {
                // ...
            }
        case "editSong":
            newRoleArr = []
            alertController = UIAlertController(title: "Add \(video.title)",
                                                    message: "Select the videos relationship to the song",
                                                    preferredStyle: .alert)
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc3 = storyboard.instantiateViewController(identifier: "editPersonRolesPopoverTableViewController") as
            EditPersonRolesPopoverTableViewController
            vc3.preferredContentSize = CGSize(width: 350, height: 240)
            vc3.tableView.isScrollEnabled = false
            alertController.setValue(vc3, forKey: "contentViewController")
            vc3.roleArr = ["Official Video","Audio Video","Lyric Video", "Other Video"]
            vc3.tableViewPopover.reloadData()
            
            let addAction = UIAlertAction(title: "Add", style: .default, handler: {[weak self] _ in
                guard let strongSelf = self else {return}
                let cc = alertController.value(forKey: "contentViewController") as! EditPersonRolesPopoverTableViewController
                for i in 1 ... (cc.roleArr.count) {
                    let dex = i-1
                    if let cell = cc.tableViewPopover.cellForRow(at: IndexPath(row: dex, section: 0)) as? EditRolePopoverTableCellController {
                        if cell.checkbox.on {
                            strongSelf.editSongVideosDelegate.videoAdded([cell.role.text!:video])
                            _ = strongSelf.navigationController?.popViewController(animated: true)
                        }
                    }
                }
            })

            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
            { (action) in
                // ...
            }
            alertController.addAction(cancelAction)
            alertController.addAction(addAction)
            alertController.view.tintColor = Constants.Colors.redApp

            self.present(alertController, animated: true)
            {
                // ...
            }
        default:
        let actionSheet:UIAlertController!
            actionSheet = UIAlertController(title: "Update",
                                                message: "Are you sure you want to change Tone's Pick(video) to \(video.title)?",
                preferredStyle: .actionSheet)
            actionSheet.addAction(UIAlertAction(title: "Yes",
                                                style: .default,
                                                handler: { [weak self] _ in
                                                    guard let strongSelf = self else {return}
                                                    Database.database().reference().child("Current Featured Content").child("Tones Picks").child("Video").removeValue()
                let key = ("\(videoContentTag)--\(video.title.replacingOccurrences(of: ".", with: " ").replacingOccurrences(of: "#", with: " ").replacingOccurrences(of: "$", with: " ").replacingOccurrences(of: "[", with: " ").replacingOccurrences(of: "]", with: " ").replacingOccurrences(of: ":", with: " "))--\(video.dateIA)--\(video.timeIA)--\(video.toneDeafAppId)")
                                                    let ref1 = Database.database().reference().child("Music Content").child("Videos").child(key)
                                                    let ref2 = Database.database().reference().child("Current Featured Content").child("Tones Picks").child("Video").child(key)
                                                    ref1.observeSingleEvent(of: .value, with: { snap in
                                                        ref2.setValue(snap.value)
                                                    })
                                                    _ = strongSelf.navigationController?.popViewController(animated: true)
            }))
            actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            
            present(actionSheet, animated: true)
    }
        
    }
    
    func openConfirmation(editbeatvideo: AnyObject) {
        let actionSheet:UIAlertController!
        switch editbeatvideo {
        case is YouTubeData:
            let vid = editbeatvideo as! YouTubeData
            actionSheet = UIAlertController(title: "Update",
                                                message: "Select \(vid.title)?",
                preferredStyle: .actionSheet)
            actionSheet.addAction(UIAlertAction(title: "Yes",
                                                style: .default,
                                                handler: { [weak self] _ in
                                                    guard let strongSelf = self else {return}
                                                    NotificationCenter.default.post(name: EditBeatVideoSelectedNotify, object: vid)
                                                    strongSelf.dismiss(animated: true, completion: nil)
            }))
            actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            
            present(actionSheet, animated: true)
        default:
            print("same ole s")
        }
        
    }
    
    func openConfirmation(person: PersonData) {
        switch prevPage {
        case "uploadKits":
            let actionSheet = UIAlertController(title: "Add",
                                                message: "Are you sure you want to add \(person.name!)?",
                                                preferredStyle: .alert)
            actionSheet.addAction(UIAlertAction(title: "Yes",
                                                style: .default,
                                                handler: { [weak self] _ in
                                                    guard let strongSelf = self else {return}
                strongSelf.uploadKitsPersonsDelegate.personAdded(person)
                _ = strongSelf.navigationController?.popViewController(animated: true)
                
            }))
            
            actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            actionSheet.view.tintColor = Constants.Colors.redApp
            
            present(actionSheet, animated: true)
        case "editVideo":
            let actionSheet = UIAlertController(title: "Add",
                                                message: "Are you sure you want to add \(person.name!)?",
                                                preferredStyle: .alert)
            actionSheet.addAction(UIAlertAction(title: "Yes",
                                                style: .default,
                                                handler: { [weak self] _ in
                                                    guard let strongSelf = self else {return}
                strongSelf.editVideoPersonsDelegate.personAdded(person)
                _ = strongSelf.navigationController?.popViewController(animated: true)
                
            }))
            
            actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            actionSheet.view.tintColor = Constants.Colors.redApp
            
            present(actionSheet, animated: true)
        case "editAlbum":
            let actionSheet = UIAlertController(title: "Add",
                                                message: "Are you sure you want to add \(person.name!)?",
                                                preferredStyle: .alert)
            actionSheet.addAction(UIAlertAction(title: "Yes",
                                                style: .default,
                                                handler: { [weak self] _ in
                                                    guard let strongSelf = self else {return}
                strongSelf.editAlbumPersonsDelegate.personAdded(person)
                _ = strongSelf.navigationController?.popViewController(animated: true)
                
            }))
            
            actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            actionSheet.view.tintColor = Constants.Colors.redApp
            
            present(actionSheet, animated: true)
        case "editSong":
            let actionSheet = UIAlertController(title: "Add",
                                                message: "Are you sure you want to add \(person.name!)?",
                                                preferredStyle: .alert)
            actionSheet.addAction(UIAlertAction(title: "Yes",
                                                style: .default,
                                                handler: { [weak self] _ in
                                                    guard let strongSelf = self else {return}
                strongSelf.editSongPersonsDelegate.personAdded(person)
                _ = strongSelf.navigationController?.popViewController(animated: true)
                
            }))
            
            actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            actionSheet.view.tintColor = Constants.Colors.redApp
            
            present(actionSheet, animated: true)
        case "uploadBeat":
            let actionSheet = UIAlertController(title: "Add",
                                                message: "Are you sure you want to add \(person.name!)?",
                                                preferredStyle: .alert)
            actionSheet.addAction(UIAlertAction(title: "Yes",
                                                style: .default,
                                                handler: { [weak self] _ in
                                                    guard let strongSelf = self else {return}
                strongSelf.uploadBeatProducersDelegate.producerAdded(person)
                _ = strongSelf.navigationController?.popViewController(animated: true)
                
            }))
            
            actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            actionSheet.view.tintColor = Constants.Colors.redApp
            
            present(actionSheet, animated: true)
        case "adminDash":
            selectedPerson = person
            performSegue(withIdentifier: "tonesPickToEditPerson", sender: nil)
            _ = self.navigationController?.viewControllers.removeAll { $0 is SelectTonesPickItemViewController }
        case "editPersonAll":
            editPersonAllPersonsDelegate.personSelected(person)
            _ = self.navigationController?.popViewController(animated: true)
        default:
            break
        }
    }
    
    func openConfirmation(track: Any) {
        switch track {
        case is SongData:
            let song = track as! SongData
            alertController = UIAlertController(title: "Add \(song.name)",
                                                    message: "Enter track number",
                                                    preferredStyle: .alert)
            
            let addAction = UIAlertAction(title: "Add", style: .default, handler: {[weak self] _ in
                guard let strongSelf = self else {return}
                let field = alertController.textFields![0]
                if let tack = field.text {
                    if tack != "" {
                        if let track = Int(tack) {
                            if track > 40 {
                                mediumImpactGenerator.impactOccurred()
                                Utilities.showError2("Track number can't be over 40", actionText: "OK")
                                alertController.dismiss(animated: true, completion: nil)
                            } else {
                                    strongSelf.editAlbumTracksDelegate.trackAdded([String(track):song])
                                _ = strongSelf.navigationController?.popViewController(animated: true)
                            }
                        } else {
                            mediumImpactGenerator.impactOccurred()
                            Utilities.showError2("Track number invalid", actionText: "OK")
                            alertController.dismiss(animated: true, completion: nil)
                        }
                    } else {
                        mediumImpactGenerator.impactOccurred()
                        Utilities.showError2("Track number required", actionText: "OK")
                        alertController.dismiss(animated: true, completion: nil)
                    }
                } else {
                    mediumImpactGenerator.impactOccurred()
                    Utilities.showError2("Track number required", actionText: "OK")
                    alertController.dismiss(animated: true, completion: nil)
                }
            })
            alertController.addAction(addAction)
        case is InstrumentalData:
            let song = track as! InstrumentalData
            alertController = UIAlertController(title: "Add \(song.instrumentalName)",
                                                    message: "Enter track number",
                                                    preferredStyle: .alert)
            
            let addAction = UIAlertAction(title: "Add", style: .default, handler: {[weak self] _ in
                guard let strongSelf = self else {return}
                let field = alertController.textFields![0]
                if let tack = field.text {
                    if tack != "" {
                        if let track = Int(tack) {
                            if track > 40 {
                                mediumImpactGenerator.impactOccurred()
                                Utilities.showError2("Track number can't be over 40", actionText: "OK")
                                alertController.dismiss(animated: true, completion: nil)
                            } else {
                                    strongSelf.editAlbumTracksDelegate.trackAdded([String(track):song])
                                _ = strongSelf.navigationController?.popViewController(animated: true)
                            }
                        } else {
                            mediumImpactGenerator.impactOccurred()
                            Utilities.showError2("Track number invalid", actionText: "OK")
                            alertController.dismiss(animated: true, completion: nil)
                        }
                    } else {
                        mediumImpactGenerator.impactOccurred()
                        Utilities.showError2("Track number required", actionText: "OK")
                        alertController.dismiss(animated: true, completion: nil)
                    }
                } else {
                    mediumImpactGenerator.impactOccurred()
                    Utilities.showError2("Track number required", actionText: "OK")
                    alertController.dismiss(animated: true, completion: nil)
                }
            })
            alertController.addAction(addAction)
        default:
            break
        }
            

            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
            { (action) in
                
            }
            alertController.addAction(cancelAction)
            alertController.addTextField()
            let field = alertController.textFields![0]
            field.keyboardType = .numberPad
            alertController.view.tintColor = Constants.Colors.redApp

            
            alertController.view.tintColor = UIColor.init(red: 182/255, green: 0/255, blue: 3/255, alpha: 1)
            self.present(alertController, animated: true)
            {
                // ...
            }
        
    }
    
    func openConfirmation(song: SongData) {
        switch prevPage {
        case "adminDash":
            selectedSong = song
            performSegue(withIdentifier: "tonesPickToEditSong", sender: nil)
            _ = self.navigationController?.viewControllers.removeAll { $0 is SelectTonesPickItemViewController }
        case "editSongAll":
            editSongAllSongsDelegate.songSelected(song)
            _ = self.navigationController?.popViewController(animated: true)
        case "uploadKits":
            let actionSheet = UIAlertController(title: "Add",
                                                message: "Are you sure you want to add \(song.name)?",
                                                preferredStyle: .alert)
            actionSheet.addAction(UIAlertAction(title: "Yes",
                                                style: .default,
                                                handler: { [weak self] _ in
                                                    guard let strongSelf = self else {return}
                strongSelf.uploadKitsSongsDelegate.songAdded(song)
                _ = strongSelf.navigationController?.popViewController(animated: true)
                
            }))
            
            actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            actionSheet.view.tintColor = Constants.Colors.redApp
            
            present(actionSheet, animated: true)
        case "editVideo":
            newRoleArr = []
            alertController = UIAlertController(title: "Add \(song.name)",
                                                    message: "Select the videos relationship to \(song.name)",
                                                    preferredStyle: .alert)
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc3 = storyboard.instantiateViewController(identifier: "editPersonRolesPopoverTableViewController") as
            EditPersonRolesPopoverTableViewController
            vc3.preferredContentSize = CGSize(width: 350, height: 240)
            vc3.tableView.isScrollEnabled = false
            alertController.setValue(vc3, forKey: "contentViewController")
            vc3.roleArr = ["Official Video","Audio Video","Lyric Video", "Other Video"]
            vc3.tableViewPopover.reloadData()
            
            let addAction = UIAlertAction(title: "Add", style: .default, handler: {[weak self] _ in
                guard let strongSelf = self else {return}
                let cc = alertController.value(forKey: "contentViewController") as! EditPersonRolesPopoverTableViewController
                for i in 1 ... (cc.roleArr.count) {
                    let dex = i-1
                    if let cell = cc.tableViewPopover.cellForRow(at: IndexPath(row: dex, section: 0)) as? EditRolePopoverTableCellController {
                        if cell.checkbox.on {
                            strongSelf.editVideoSongsDelegate.songAdded([cell.role.text!:song])
                            _ = strongSelf.navigationController?.popViewController(animated: true)
                        }
                    }
                }
            })

            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
            { (action) in
                // ...
            }
            alertController.addAction(cancelAction)
            alertController.addAction(addAction)
            alertController.view.tintColor = Constants.Colors.redApp

            self.present(alertController, animated: true)
            {
                // ...
            }
        case "editSong":
            newRoleArr = []
            alertController = UIAlertController(title: "Add \(song.name)",
                                                message: "Are you sure?",
                                                preferredStyle: .alert)
            
            let addAction = UIAlertAction(title: "Add", style: .default, handler: {[weak self] _ in
                guard let strongSelf = self else {return}
                strongSelf.editSongSongsDelegate.songAdded(song)
                _ = strongSelf.navigationController?.popViewController(animated: true)
            })
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
            { (action) in
                // ...
            }
            alertController.addAction(cancelAction)
            alertController.addAction(addAction)
            alertController.view.tintColor = Constants.Colors.redApp
            alertController.view.tintColor = UIColor.init(red: 182/255, green: 0/255, blue: 3/255, alpha: 1)
            self.present(alertController, animated: true)
            {
                // ...
            }
        case "editPerson":
            newRoleArr = []
            alertController = UIAlertController(title: "Add \(song.name)",
                                                    message: "Select Roles",
                                                    preferredStyle: .alert)
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc3 = storyboard.instantiateViewController(identifier: "editPersonRolesPopoverTableViewController") as
            EditPersonRolesPopoverTableViewController
            vc3.preferredContentSize = CGSize(width: 350, height: 350) // 4 default cell heights.
            alertController.setValue(vc3, forKey: "contentViewController")
            
            let addAction = UIAlertAction(title: "Add", style: .default, handler: {[weak self] _ in
                guard let strongSelf = self else {return}
                let cc = alertController.value(forKey: "contentViewController") as! EditPersonRolesPopoverTableViewController
                for i in 1 ... (cc.roleArr.count) {
                    let cell = cc.tableViewPopover.cellForRow(at: IndexPath(row: i-1, section: 0)) as! EditRolePopoverTableCellController
                    if cell.checkbox.on {
                        strongSelf.newRoleArr.append(cell.role.text!)
                    }
                }
//                let id = "\(song.toneDeafAppId)Æ\(song.name)"
                strongSelf.songsDelegate.songAdded([strongSelf.newRoleArr:song])
                _ = strongSelf.navigationController?.popViewController(animated: true)
            })

            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
            { (action) in
                // ...
            }
            alertController.addAction(cancelAction)
            alertController.addAction(addAction)
            alertController.view.tintColor = Constants.Colors.redApp

            self.present(alertController, animated: true)
            {
                // ...
            }
        case "editAlbum":
            alertController = UIAlertController(title: "Add \(song.name)",
                                                    message: "Enter track number (Leave blank if song is not in tracklist)",
                                                    preferredStyle: .alert)
            
            let addAction = UIAlertAction(title: "Add", style: .default, handler: {[weak self] _ in
                guard let strongSelf = self else {return}
                let field = alertController.textFields![0]
                if let tack = field.text {
                    if tack != "" {
                        if let track = Int(tack) {
                            if track > 40 {
                                mediumImpactGenerator.impactOccurred()
                                Utilities.showError2("Track number can't be over 40", actionText: "OK")
                                alertController.dismiss(animated: true, completion: nil)
                            } else {
    //                            if album.tracks["Track \(track)"] != nil {
    //                                mediumImpactGenerator.impactOccurred()
    //                                Utilities.showError2("Album already has a track in that position.", actionText: "OK")
    //                            }
    //                            else {
                                    strongSelf.editAlbumSongsDelegate.songAdded([String(track):song])
    //                            }
                                _ = strongSelf.navigationController?.popViewController(animated: true)
                            }
                        } else {
                            mediumImpactGenerator.impactOccurred()
                            Utilities.showError2("Track number invalid", actionText: "OK")
                            alertController.dismiss(animated: true, completion: nil)
                        }
                    } else {
                        strongSelf.editAlbumSongsDelegate.songAdded([nil:song])
                    _ = strongSelf.navigationController?.popViewController(animated: true)
                    }
                } else {
                    strongSelf.editAlbumSongsDelegate.songAdded([nil:song])
                _ = strongSelf.navigationController?.popViewController(animated: true)
                }
            })

            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
            { (action) in
                
            }
            alertController.addAction(cancelAction)
            alertController.addAction(addAction)
            alertController.addTextField()
            let field = alertController.textFields![0]
            field.keyboardType = .numberPad
            alertController.view.tintColor = Constants.Colors.redApp

            
            alertController.view.tintColor = UIColor.init(red: 182/255, green: 0/255, blue: 3/255, alpha: 1)
            self.present(alertController, animated: true)
            {
                // ...
            }
        default:
            let actionSheet = UIAlertController(title: "Update",
                                                message: "Are you sure you want to change Tone's Pick(song) to \(song.name)?",
                preferredStyle: .actionSheet)
            actionSheet.addAction(UIAlertAction(title: "Yes",
                                                style: .default,
                                                handler: { [weak self] _ in
                                                    guard let strongSelf = self else {return}
                                                    Database.database().reference().child("Current Featured Content").child("Tones Picks").child("Song").removeValue()
                                                    var songart:[String] = []
                                                    for art in song.songArtist {
                                                        let word = art.split(separator: "Æ")
                                                        let id = word[1]
                                                        songart.append(String(id))
                                                    }
                                                    let key = "\(songContentTag)--\(song.name)--\(songart.joined(separator: ", "))--\(song.toneDeafAppId)"
                                                    let ref1 = Database.database().reference().child("Music Content").child("Songs").child(key)
                                                    let ref2 = Database.database().reference().child("Current Featured Content").child("Tones Picks").child("Song").child(key)
                                                    ref1.observeSingleEvent(of: .value, with: { snap in
                                                        ref2.setValue(snap.value)
                                                    })
                
            }))
            
            actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            
            present(actionSheet, animated: true)
        }
    }
    
    func openConfirmation(beat: BeatData) {
        switch prevPage {
        case "uploadKits":
            let actionSheet = UIAlertController(title: "Add",
                                                message: "Are you sure you want to add \(beat.name)?",
                                                preferredStyle: .alert)
            actionSheet.addAction(UIAlertAction(title: "Yes",
                                                style: .default,
                                                handler: { [weak self] _ in
                                                    guard let strongSelf = self else {return}
                strongSelf.uploadKitsBeatsDelegate.beatAdded(beat)
                _ = strongSelf.navigationController?.popViewController(animated: true)
                
            }))
            
            actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            actionSheet.view.tintColor = Constants.Colors.redApp
            
            present(actionSheet, animated: true)
        case "editPerson":
            newRoleArr = []
            alertController = UIAlertController(title: "Add \(beat.name)",
                                                    message: "Are you sure?",
                                                    preferredStyle: .alert)
            
            let addAction = UIAlertAction(title: "Add", style: .default, handler: {[weak self] _ in
                guard let strongSelf = self else {return}
                strongSelf.editPersonBeatsDelegate.beatAdded(beat)
                _ = strongSelf.navigationController?.popViewController(animated: true)
            })

            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
            { (action) in
                // ...
            }
            alertController.addAction(cancelAction)
            alertController.addAction(addAction)
            alertController.view.tintColor = Constants.Colors.redApp

            self.present(alertController, animated: true)
            {
                // ...
            }
        default:
            
            let actionSheet = UIAlertController(title: "Update",
                                                message: "Are you sure you want to change Tone's Pick(beat) to \(beat.name)?",
                preferredStyle: .actionSheet)
            actionSheet.addAction(UIAlertAction(title: "Yes",
                                                style: .default,
                                                handler: { [weak self] _ in
                                                    guard let strongSelf = self else {return}
                                                    Database.database().reference().child("Current Featured Content").child("Tones Picks").child("Beat").removeValue()
                                                    let key = beat.beatID
                                                    let ref1 = Database.database().reference().child("Beats").child("Free").child(key)
                                                    let ref2 = Database.database().reference().child("Current Featured Content").child("Tones Picks").child("Beat").child(key)
                                                    ref1.observeSingleEvent(of: .value, with: { snap in
                                                        ref2.setValue(snap.value)
                                                    })
                                                    _ = strongSelf.navigationController?.popViewController(animated: true)
            }))
            
            actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            
            present(actionSheet, animated: true)
        }
    }
    
    func openConfirmation(album: AlbumData) {
        switch prevPage {
        case "adminDash":
            selectedAlbum = album
            performSegue(withIdentifier: "tonesPickToEditAlbum", sender: nil)
            _ = self.navigationController?.viewControllers.removeAll { $0 is SelectTonesPickItemViewController }
        case "editAlbumAll":
            editAlbumAllAlbumsDelegate.selectedAlbum(album)
            _ = self.navigationController?.popViewController(animated: true)
        case "uploadKits":
            let actionSheet = UIAlertController(title: "Add",
                                                message: "Are you sure you want to add \(album.name)?",
                                                preferredStyle: .alert)
            actionSheet.addAction(UIAlertAction(title: "Yes",
                                                style: .default,
                                                handler: { [weak self] _ in
                                                    guard let strongSelf = self else {return}
                strongSelf.uploadKitsAlbumsDelegate.albumAdded(album)
                _ = strongSelf.navigationController?.popViewController(animated: true)
                
            }))
            
            actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            actionSheet.view.tintColor = Constants.Colors.redApp
            
            present(actionSheet, animated: true)
        case "editAlbum":
            newRoleArr = []
            alertController = UIAlertController(title: "Add \(album.name)",
                                                message: "Are you sure?",
                                                preferredStyle: .alert)
            
            let addAction = UIAlertAction(title: "Add", style: .default, handler: {[weak self] _ in
                guard let strongSelf = self else {return}
                strongSelf.editAlbumAlbumsDelegate.albumAdded(album)
                _ = strongSelf.navigationController?.popViewController(animated: true)
            })
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
            { (action) in
                // ...
            }
            alertController.addAction(cancelAction)
            alertController.addAction(addAction)
            alertController.view.tintColor = Constants.Colors.redApp
            alertController.view.tintColor = UIColor.init(red: 182/255, green: 0/255, blue: 3/255, alpha: 1)
            self.present(alertController, animated: true)
            {
                // ...
            }
        case "editSong":
            alertController = UIAlertController(title: "Add \(album.name)",
                                                    message: "Enter track number (Leave blank if song is not in tracklist)",
                                                    preferredStyle: .alert)
            
            let addAction = UIAlertAction(title: "Add", style: .default, handler: {[weak self] _ in
                guard let strongSelf = self else {return}
                let field = alertController.textFields![0]
                if let tack = field.text {
                    if tack != "" {
                        if let track = Int(tack) {
                            if track > 40 {
                                mediumImpactGenerator.impactOccurred()
                                Utilities.showError2("Track number can't be over 40", actionText: "OK")
                                alertController.dismiss(animated: true, completion: nil)
                            } else {
                                strongSelf.editSongAlbumsDelegate.albumAdded([String(track):album])
                                _ = strongSelf.navigationController?.popViewController(animated: true)
                            }
                        } else {
                            mediumImpactGenerator.impactOccurred()
                            Utilities.showError2("Track number invalid", actionText: "OK")
                            alertController.dismiss(animated: true, completion: nil)
                        }
                    } else {
                        strongSelf.editSongAlbumsDelegate.albumAdded([nil:album])
                        _ = strongSelf.navigationController?.popViewController(animated: true)
                    }
                } else {
                    strongSelf.editSongAlbumsDelegate.albumAdded([nil:album])
                    _ = strongSelf.navigationController?.popViewController(animated: true)
                }
            })
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
            { (action) in
                
            }
            alertController.addAction(cancelAction)
            alertController.addAction(addAction)
            alertController.addTextField()
            let field = alertController.textFields![0]
            field.keyboardType = .numberPad
            alertController.view.tintColor = Constants.Colors.redApp

            
            alertController.view.tintColor = UIColor.init(red: 182/255, green: 0/255, blue: 3/255, alpha: 1)
            self.present(alertController, animated: true)
            {
                // ...
            }
        case "editPerson":
            newRoleArr = []
            alertController = UIAlertController(title: "Add \(album.name)",
                                                    message: "Select Roles",
                                                    preferredStyle: .alert)
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc3 = storyboard.instantiateViewController(identifier: "editPersonRolesPopoverTableViewController") as
            EditPersonRolesPopoverTableViewController
            vc3.preferredContentSize = CGSize(width: 350, height: 420) // 4 default cell heights.
            alertController.setValue(vc3, forKey: "contentViewController")
            vc3.roleArr.remove(at: 0)
            vc3.roleArr.insert("Featured Artist", at: 0)
            vc3.roleArr.insert("Main Artist", at: 0)
            vc3.tableViewPopover.reloadData()
            
            let addAction = UIAlertAction(title: "Add", style: .default, handler: {[weak self] _ in
                guard let strongSelf = self else {return}
                let cc = alertController.value(forKey: "contentViewController") as! EditPersonRolesPopoverTableViewController
                for i in 1 ... (cc.roleArr.count) {
                    let dex = i-1
                    if let cell = cc.tableViewPopover.cellForRow(at: IndexPath(row: dex, section: 0)) as? EditRolePopoverTableCellController {
                        if cell.checkbox.on {
                            strongSelf.newRoleArr.append(cell.role.text!)
                        }
                    }
                }
                strongSelf.albumsDelegate.albumAdded([strongSelf.newRoleArr:album])
                _ = strongSelf.navigationController?.popViewController(animated: true)
            })

            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
            { (action) in
                // ...
            }
            alertController.addAction(cancelAction)
            alertController.addAction(addAction)
            alertController.view.tintColor = Constants.Colors.redApp

            
            alertController.view.tintColor = UIColor.init(red: 182/255, green: 0/255, blue: 3/255, alpha: 1)
            self.present(alertController, animated: true)
            {
                // ...
            }
        default:
            let actionSheet = UIAlertController(title: "Update",
                                                message: "Are you sure you want to change Tone's Pick(album) to \(album.name)?",
                                                preferredStyle: .actionSheet)
            actionSheet.addAction(UIAlertAction(title: "Yes",
                                                style: .default,
                                                handler: { [weak self] _ in
                guard let strongSelf = self else {return}
                Database.database().reference().child("Current Featured Content").child("Tones Picks").child("Album").removeValue()
                var songart:[String] = []
                for art in album.mainArtist {
                    let word = art.split(separator: "Æ")
                    let id = word[1]
                    songart.append(String(id))
                }
                let key = "\(albumContentTag)--\(album.name)--\(songart.joined(separator: ", "))--\(album.toneDeafAppId)"
                let ref1 = Database.database().reference().child("Music Content").child("Albums").child(key)
                let ref2 = Database.database().reference().child("Current Featured Content").child("Tones Picks").child("Album").child(key)
                ref1.observeSingleEvent(of: .value, with: { snap in
                    ref2.setValue(snap.value)
                })
                _ = strongSelf.navigationController?.popViewController(animated: true)
            }))
            
            actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            
            present(actionSheet, animated: true)
        }
    }
    
    func openConfirmation(instrumental: InstrumentalData) {
        switch prevPage {
        case "uploadKits":
            let actionSheet = UIAlertController(title: "Add",
                                                message: "Are you sure you want to add \(instrumental.instrumentalName!)?",
                                                preferredStyle: .alert)
            actionSheet.addAction(UIAlertAction(title: "Yes",
                                                style: .default,
                                                handler: { [weak self] _ in
                                                    guard let strongSelf = self else {return}
                strongSelf.uploadKitsInstrumentalsDelegate.instrumentalAdded(instrumental)
                _ = strongSelf.navigationController?.popViewController(animated: true)
                
            }))
            
            actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            actionSheet.view.tintColor = Constants.Colors.redApp
            
            present(actionSheet, animated: true)
        case "editPerson":
            newRoleArr = []
            alertController = UIAlertController(title: "Add \(instrumental.instrumentalName!)",
                                                message: "Select Roles",
                                                preferredStyle: .alert)
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc3 = storyboard.instantiateViewController(identifier: "editPersonRolesPopoverTableViewController") as
            EditPersonRolesPopoverTableViewController
            vc3.preferredContentSize = CGSize(width: 350, height: 240) // 4 default cell heights.
            vc3.roleArr.remove(at: 5)
            vc3.roleArr.remove(at: 2)
            vc3.tableView.isScrollEnabled = false
            alertController.setValue(vc3, forKey: "contentViewController")
            
            let addAction = UIAlertAction(title: "Add", style: .default, handler: {[weak self] _ in
                guard let strongSelf = self else {return}
                let cc = alertController.value(forKey: "contentViewController") as! EditPersonRolesPopoverTableViewController
                for i in 1 ... (cc.roleArr.count) {
                    let cell = cc.tableViewPopover.cellForRow(at: IndexPath(row: i-1, section: 0)) as! EditRolePopoverTableCellController
                    if cell.checkbox.on {
                        strongSelf.newRoleArr.append(cell.role.text!)
                    }
                }
                //                let id = "\(song.toneDeafAppId)Æ\(song.name)"
                strongSelf.instrumentalsDelegate.instrumentalAdded([strongSelf.newRoleArr:instrumental])
                _ = strongSelf.navigationController?.popViewController(animated: true)
            })
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
            { (action) in
                // ...
            }
            alertController.addAction(cancelAction)
            alertController.addAction(addAction)
            alertController.view.tintColor = Constants.Colors.redApp
            
            
            alertController.view.tintColor = UIColor.init(red: 182/255, green: 0/255, blue: 3/255, alpha: 1)
            self.present(alertController, animated: true)
            {
                // ...
            }
        case "editSong":
            newRoleArr = []
            alertController = UIAlertController(title: "Add \(instrumental.instrumentalName!)",
                                                message: "Are you sure?",
                                                preferredStyle: .alert)
            
            let addAction = UIAlertAction(title: "Add", style: .default, handler: {[weak self] _ in
                guard let strongSelf = self else {return}
                strongSelf.editSongInstrumentalsDelegate.instrumentalAdded(instrumental)
                _ = strongSelf.navigationController?.popViewController(animated: true)
            })
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
            { (action) in
                // ...
            }
            alertController.addAction(cancelAction)
            alertController.addAction(addAction)
            alertController.view.tintColor = Constants.Colors.redApp
            
            
            alertController.view.tintColor = UIColor.init(red: 182/255, green: 0/255, blue: 3/255, alpha: 1)
            self.present(alertController, animated: true)
            {
                // ...
            }
        case "editAlbum":
            alertController = UIAlertController(title: "Add \(instrumental.instrumentalName!)",
                                                    message: "Enter track number (Leave blank if instrumental is not in tracklist)",
                                                    preferredStyle: .alert)
            
            let addAction = UIAlertAction(title: "Add", style: .default, handler: {[weak self] _ in
                guard let strongSelf = self else {return}
                let field = alertController.textFields![0]
                if let tack = field.text {
                    if tack != "" {
                        if let track = Int(tack) {
                            if track > 40 {
                                mediumImpactGenerator.impactOccurred()
                                Utilities.showError2("Track number can't be over 40", actionText: "OK")
                                alertController.dismiss(animated: true, completion: nil)
                            } else {
                                    strongSelf.editAlbumInstrumentalsDelegate.instrumentalAdded([String(track):instrumental])
                                _ = strongSelf.navigationController?.popViewController(animated: true)
                            }
                        } else {
                            mediumImpactGenerator.impactOccurred()
                            Utilities.showError2("Track number invalid", actionText: "OK")
                            alertController.dismiss(animated: true, completion: nil)
                        }
                    } else {
                        strongSelf.editAlbumInstrumentalsDelegate.instrumentalAdded([nil:instrumental])
                    _ = strongSelf.navigationController?.popViewController(animated: true)
                    }
                } else {
                    strongSelf.editAlbumInstrumentalsDelegate.instrumentalAdded([nil:instrumental])
                _ = strongSelf.navigationController?.popViewController(animated: true)
                }
            })

            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
            { (action) in
                
            }
            alertController.addAction(cancelAction)
            alertController.addAction(addAction)
            alertController.addTextField()
            let field = alertController.textFields![0]
            field.keyboardType = .numberPad
            alertController.view.tintColor = Constants.Colors.redApp

            
            alertController.view.tintColor = UIColor.init(red: 182/255, green: 0/255, blue: 3/255, alpha: 1)
            self.present(alertController, animated: true)
            {
                // ...
            }
        default:
            let actionSheet = UIAlertController(title: "Update",
                                                message: "Are you sure you want to change Tone's Pick(instrumental) to \(instrumental.instrumentalName)?",
                                                preferredStyle: .actionSheet)
            actionSheet.addAction(UIAlertAction(title: "Yes",
                                                style: .default,
                                                handler: { [weak self] _ in
                guard let strongSelf = self else {return}
                Database.database().reference().child("Current Featured Content").child("Tones Picks").child("Instrumental").removeValue()
                let key = ("\(instrumentalContentType ?? "")--\(instrumental.songName)--\(instrumental.dateRegisteredToApp ?? "")--\(instrumental.timeRegisteredToApp ?? "")--\(instrumental.toneDeafAppId)")
                let ref1 = Database.database().reference().child("Music Content").child("Instrumentals").child(key)
                let ref2 = Database.database().reference().child("Current Featured Content").child("Tones Picks").child("Instrumental").child(key)
                ref1.observeSingleEvent(of: .value, with: { snap in
                    ref2.setValue(snap.value)
                })
                _ = strongSelf.navigationController?.popViewController(animated: true)
            }))
            
            actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            
            present(actionSheet, animated: true)
        }
    }
    
    func hideskeleton(tableview: UITableView) {
        skelvar+=1
        DispatchQueue.main.async {
        tableview.stopSkeletonAnimation()
        tableview.hideSkeleton(reloadDataAfter: false, transition: .crossDissolve(0.25))
        tableview.reloadData()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "tonesPickToEditPerson" {
            if let viewController: EditPersonViewController = segue.destination as? EditPersonViewController {
                viewController.currentPerson = selectedPerson
            }
        }
        if segue.identifier == "tonesPickToEditSong" {
            if let viewController: EditSongViewController = segue.destination as? EditSongViewController {
                viewController.currentSong = selectedSong
            }
        }
        if segue.identifier == "tonesPickToEditAlbum" {
            if let viewController: EditAlbumViewController = segue.destination as? EditAlbumViewController {
                viewController.currentAlbum = selectedAlbum
            }
        }
        if segue.identifier == "tonesPickToEditVideo" {
            if let viewController: EditVideoViewController = segue.destination as? EditVideoViewController {
                viewController.currentVideo = selectedVideo
            }
        }
    }

}

extension SelectTonesPickItemViewController: UITableViewDelegate, UITableViewDataSource, SkeletonTableViewDataSource {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        switch array {
        case "video":
                let exceptions = exeptions as! [VideoData]
                if prevPage == "editPerson" || prevPage == "editSong" || prevPage == "editAlbum" || prevPage == "uploadKits" {
                    guard AllVideosInDatabaseArray != nil else { return }
                    guard all != true else {return}
                    guard indexPath.row == AllVideosInDatabaseArray.count-1 else {return}
                    DatabaseManager.shared.fetchAllVideosFromDatabase(page: 10, end: lastfetchedkey, exceptions: exceptions, completion: {[weak self] videos in
                        guard let strongSelf = self else {return}
                        if videos == strongSelf.lastVideos {
                            strongSelf.all = true
                            return
                        }
                        strongSelf.lastVideos = videos
                        for videos in videos {
                            if !AllVideosInDatabaseArray.contains(videos) {
                                AllVideosInDatabaseArray.append(videos)
                            }
                        }
                        strongSelf.knownOldestVideoElement = AllVideosInDatabaseArray.last
                        var songart:[String] = []
                            strongSelf.lastfetchedkey = ("\(videoContentTag)--\(strongSelf.knownOldestVideoElement.title.replacingOccurrences(of: ".", with: " ").replacingOccurrences(of: "#", with: " ").replacingOccurrences(of: "$", with: " ").replacingOccurrences(of: "[", with: " ").replacingOccurrences(of: "]", with: " ").replacingOccurrences(of: ":", with: " "))--\(strongSelf.knownOldestVideoElement.toneDeafAppId)")
                        strongSelf.pickTableView.reloadData()
                    })
                }
                else {
            guard AllVideosInDatabaseArray != nil else { return }
            guard all != true else {return}
            guard indexPath.row == AllVideosInDatabaseArray.count-1 else {return}
            DatabaseManager.shared.fetchAllVideosFromDatabase(page: 10, end: lastfetchedkey, completion: {[weak self] videos in
                guard let strongSelf = self else {return}
                if videos == strongSelf.lastVideos {
                    strongSelf.all = true
                    return
                }
                strongSelf.lastVideos = videos
                for song in videos {
                    if !AllVideosInDatabaseArray.contains(song) {
                        AllVideosInDatabaseArray.append(song)
                    }
                }
                strongSelf.lastVideos = videos
                for videos in videos {
                    if !AllVideosInDatabaseArray.contains(videos) {
                        AllVideosInDatabaseArray.append(videos)
                    }
                }
                strongSelf.knownOldestVideoElement = AllVideosInDatabaseArray.last
                var songart:[String] = []
                    strongSelf.lastfetchedkey = ("\(videoContentTag)--\(strongSelf.knownOldestVideoElement.title.replacingOccurrences(of: ".", with: " ").replacingOccurrences(of: "#", with: " ").replacingOccurrences(of: "$", with: " ").replacingOccurrences(of: "[", with: " ").replacingOccurrences(of: "]", with: " ").replacingOccurrences(of: ":", with: " "))--\(strongSelf.knownOldestVideoElement.toneDeafAppId)")
                strongSelf.pickTableView.reloadData()
            })
        }
        case "editbeatvideo":
            guard AllVideosInDatabaseArray != nil else { return }
            guard all != true else {return}
            guard indexPath.row == AllVideosInDatabaseArray.count-1 else {return}
            DatabaseManager.shared.fetchAllVideosFromDatabase(page: 10, end: lastfetchedkey, completion: {[weak self] videos in
                guard let strongSelf = self else {return}
                switch videos.last {
                case is YouTubeData:
                    let last = videos.last as! YouTubeData
                    if strongSelf.lastVideos.last is YouTubeData {
                        let lv = strongSelf.lastVideos.last as! YouTubeData
                        if lv == last {
                            strongSelf.all = true
                            return
                        }
                    }
                default:
                    print("sumn")
                }
                strongSelf.lastVideos = videos
                for song in videos {
                        AllVideosInDatabaseArray.append(song)
                }
                strongSelf.lastVideos = videos
                strongSelf.knownOldestVideoElement = AllVideosInDatabaseArray.last
                var songart:[String] = []
                switch strongSelf.knownOldestVideoElement {
                case is YouTubeData:
                    let video = strongSelf.knownOldestVideoElement as! YouTubeData
                    strongSelf.lastfetchedkey = ("\(video.type)--\(video.title.replacingOccurrences(of: ".", with: " ").replacingOccurrences(of: "#", with: " ").replacingOccurrences(of: "$", with: " ").replacingOccurrences(of: "[", with: " ").replacingOccurrences(of: "]", with: " ").replacingOccurrences(of: ":", with: " "))--\(video.toneDeafAppId)")
                    default:
                    print("that other thang")
                }
                strongSelf.pickTableView.reloadData()
            })
        default:
            switch array {
            case "person":
                if prevPage == "uploadBeat" || prevPage == "uploadKits" || prevPage == "editSong" || prevPage == "editAlbum" || prevPage == "editVideo" {
                    let exceptions = exeptions as! [PersonData]
                    guard AllPersonsInDatabaseArray != nil else { return }
                    guard all != true else {return}
                    guard indexPath.row == AllPersonsInDatabaseArray.count-1 else {return}
                    DatabaseManager.shared.fetchAllPersonsFromDatabase(page: 10, end: lastfetchedkey, exceptions: exceptions, completion: {[weak self] persons in
                        guard let strongSelf = self else {return}
                        if persons == strongSelf.lastPersons {
                            strongSelf.all = true
                            return
                        }
                        strongSelf.lastPersons = persons
                        for song in persons {
                            if !AllPersonsInDatabaseArray.contains(song) {
                                AllPersonsInDatabaseArray.append(song)
                            }
                        }
                        strongSelf.knownOldestPersonElement = AllPersonsInDatabaseArray.last
                        strongSelf.lastfetchedkey = "\(strongSelf.knownOldestPersonElement.name!)--\(strongSelf.knownOldestPersonElement.dateRegisteredToApp!)--\(strongSelf.knownOldestPersonElement.timeRegisteredToApp!)--\(strongSelf.knownOldestPersonElement.toneDeafAppId)"
                        strongSelf.pickTableView.reloadData()
                    })
                }
                if prevPage == "adminDash" || prevPage == "editPersonAll" {
                    guard AllPersonsInDatabaseArray != nil else { return }
                    guard all != true else {return}
                    guard indexPath.row == AllPersonsInDatabaseArray.count-1 else {return}
                    DatabaseManager.shared.fetchAllPersonsFromDatabase(page: 10, end: lastfetchedkey, completion: {[weak self] persons in
                        guard let strongSelf = self else {return}
                        if persons == strongSelf.lastPersons {
                            strongSelf.all = true
                            return
                        }
                        strongSelf.lastPersons = persons
                        for song in persons {
                            if !AllPersonsInDatabaseArray.contains(song) {
                                AllPersonsInDatabaseArray.append(song)
                            }
                        }
                        strongSelf.knownOldestPersonElement = AllPersonsInDatabaseArray.last
                        strongSelf.lastfetchedkey = "\(strongSelf.knownOldestPersonElement.name!)--\(strongSelf.knownOldestPersonElement.dateRegisteredToApp!)--\(strongSelf.knownOldestPersonElement.timeRegisteredToApp!)--\(strongSelf.knownOldestPersonElement.toneDeafAppId)"
                        strongSelf.pickTableView.reloadData()
                    })
                }
            case "song":
                if prevPage == "editPerson" || prevPage == "editAlbum" || prevPage == "editSong" || prevPage == "editVideo" || prevPage == "uploadKits" {
                    let exceptions = exeptions as! [SongData]
                    guard AllSongsInDatabaseArray != nil else { return }
                    guard all != true else {return}
                    guard indexPath.row == AllSongsInDatabaseArray.count-1 else {return}
                    DatabaseManager.shared.fetchAllSongsFromDatabase(page: 10, end: lastfetchedkey, exceptions: exceptions, completion: {[weak self] songs in
                        guard let strongSelf = self else {return}
                        if songs == strongSelf.lastSongs {
                            strongSelf.all = true
                            return
                        }
                        strongSelf.lastSongs = songs
                        for song in songs {
                            if !AllSongsInDatabaseArray.contains(song) {
                                AllSongsInDatabaseArray.append(song)
                            }
                        }
                        strongSelf.knownOldestSongElement = AllSongsInDatabaseArray.last
                        strongSelf.lastfetchedkey =  "\(songContentTag)--\(strongSelf.knownOldestSongElement.name)--\(strongSelf.knownOldestSongElement.toneDeafAppId)"
                        strongSelf.pickTableView.reloadData()
                    })
                }
                else {
                    guard AllSongsInDatabaseArray != nil else { return }
                    guard all != true else {return}
                    guard indexPath.row == AllSongsInDatabaseArray.count-1 else {return}
                    DatabaseManager.shared.fetchAllSongsFromDatabase(page: 10, end: lastfetchedkey, completion: {[weak self] songs in
                        guard let strongSelf = self else {return}
                        if songs == strongSelf.lastSongs {
                            strongSelf.all = true
                            return
                        }
                        strongSelf.lastSongs = songs
                        for song in songs {
                            if !AllSongsInDatabaseArray.contains(song) {
                                AllSongsInDatabaseArray.append(song)
                            }
                        }
                        strongSelf.knownOldestSongElement = AllSongsInDatabaseArray.last
                        strongSelf.lastfetchedkey =  "\(songContentTag)--\(strongSelf.knownOldestSongElement.name)--\(strongSelf.knownOldestSongElement.toneDeafAppId)"
                        strongSelf.pickTableView.reloadData()
                    })
                }
            case "beat":
                if prevPage == "editPerson" || prevPage == "uploadKits" {
                    let exceptions = exeptions as! [BeatData]
                    guard AllBeatsInDatabaseArray != nil else { return }
                    guard all != true else {return}
                    guard indexPath.row == AllBeatsInDatabaseArray.count-1 else {return}
                    DatabaseManager.shared.fetchAllBeatsFromDatabase(page: 10, end: lastfetchedkey, exceptions: exceptions, completion: {[weak self] beats in
                        guard let strongSelf = self else {return}
                        if beats == strongSelf.lastBeats {
                            strongSelf.all = true
                            return
                        }
                        print(beats == strongSelf.lastBeats)
                        print(beats)
                        print(strongSelf.lastBeats)
                        strongSelf.lastBeats = beats
                        for song in beats {
                            if !AllBeatsInDatabaseArray.contains(song) {
                                AllBeatsInDatabaseArray.append(song)
                            }
                        }
                        strongSelf.knownOldestBeatElement = AllBeatsInDatabaseArray.last
                        strongSelf.lastfetchedkey =  "\(beatContentTag)--\(strongSelf.knownOldestBeatElement.name)--\(strongSelf.knownOldestBeatElement.toneDeafAppId)"
                        strongSelf.pickTableView.reloadData()
                    })
                }
                else {
                    guard AllBeatsInDatabaseArray != nil else { return }
                    guard all != true else {return}
                    guard indexPath.row == AllBeatsInDatabaseArray.count-1 else {return}
                    DatabaseManager.shared.fetchAllBeatsFromDatabase(page: 10, price: "Free", end: lastfetchedkey, completion: {[weak self] beats in
                        guard let strongSelf = self else {return}
                        if beats == strongSelf.lastBeats {
                            strongSelf.all = true
                            return
                        }
                        strongSelf.lastBeats = beats
                        for beat in beats {
                            if !AllBeatsInDatabaseArray.contains(beat) {
                                AllBeatsInDatabaseArray.append(beat)
                            }
                        }
                        strongSelf.knownOldestBeatElement = AllBeatsInDatabaseArray.last
                        strongSelf.lastfetchedkey = strongSelf.knownOldestBeatElement.beatID
                        strongSelf.pickTableView.reloadData()
                    })
                }
            case "album":
                if prevPage == "editPerson" || prevPage == "editSong" || prevPage == "editAlbum" || prevPage == "uploadKits" {
                    let exceptions = exeptions as! [AlbumData]
                    guard AllAlbumsInDatabaseArray != nil else { return }
                    guard all != true else {return}
                    guard indexPath.row == AllAlbumsInDatabaseArray.count-1 else {return}
                    DatabaseManager.shared.fetchAllAlbumsFromDatabase(page: 10, end: lastfetchedkey, exceptions: exceptions, completion: {[weak self] albums in
                        guard let strongSelf = self else {return}
                        if albums == strongSelf.lastAlbums {
                            strongSelf.all = true
                            return
                        }
                        strongSelf.lastAlbums = albums
                        for song in albums {
                            if !AllAlbumsInDatabaseArray.contains(song) {
                                AllAlbumsInDatabaseArray.append(song)
                            }
                        }
                        strongSelf.knownOldestAlbumElement = AllAlbumsInDatabaseArray.last
                        strongSelf.lastfetchedkey = "\(albumContentTag)--\(strongSelf.knownOldestAlbumElement.name)--\(strongSelf.knownOldestAlbumElement.toneDeafAppId)"
                        strongSelf.pickTableView.reloadData()
                    })
                }
                else {
                    guard AllAlbumsInDatabaseArray != nil else { return }
                    guard all != true else {return}
                    guard indexPath.row == AllAlbumsInDatabaseArray.count-1 else {return}
                    DatabaseManager.shared.fetchAllAlbumsFromDatabase(page: 10, end: lastfetchedkey, completion: {[weak self] albums in
                        guard let strongSelf = self else {return}
                        if albums == strongSelf.lastAlbums{
                            strongSelf.all = true
                            return
                        }
                        strongSelf.lastAlbums = albums
                        for song in albums {
                            if !AllAlbumsInDatabaseArray.contains(song) {
                                AllAlbumsInDatabaseArray.append(song)
                            }
                        }
                        strongSelf.knownOldestAlbumElement = AllAlbumsInDatabaseArray.last
                        strongSelf.lastfetchedkey = "\(albumContentTag)--\(strongSelf.knownOldestAlbumElement.name)--\(strongSelf.knownOldestAlbumElement.toneDeafAppId)"
                        strongSelf.pickTableView.reloadData()
                    })
                }
            default:
                if prevPage == "editPerson" || prevPage == "editSong" || prevPage == "editAlbum" || prevPage == "uploadKits" {
                    let exceptions = exeptions as! [InstrumentalData]
                    guard AllInstrumentalsInDatabaseArray != nil else { return }
                    guard all != true else {return}
                    guard indexPath.row == AllInstrumentalsInDatabaseArray.count-1 else {return}
                    DatabaseManager.shared.fetchAllInstrumentalsFromDatabase(page: 10, exceptions: exceptions, end: lastfetchedkey, completion: {[weak self] instrumentals in
                        guard let strongSelf = self else {return}
                        if instrumentals == strongSelf.lastInstrumentals {
                            strongSelf.all = true
                            return
                        }
                        strongSelf.lastInstrumentals = instrumentals
                        for song in instrumentals {
                            if !AllInstrumentalsInDatabaseArray.contains(song) {
                                AllInstrumentalsInDatabaseArray.append(song)
                            }
                        }
                        strongSelf.knownOldestInstrumentalElement = AllInstrumentalsInDatabaseArray.last
                        strongSelf.lastfetchedkey = ("\(instrumentalContentType )--\(strongSelf.knownOldestInstrumentalElement.songName!)--\(strongSelf.knownOldestInstrumentalElement.toneDeafAppId)")
                        strongSelf.pickTableView.reloadData()
                    })
                }
                else {
                    guard AllInstrumentalsInDatabaseArray != nil else { return }
                    guard all != true else {return}
                    guard indexPath.row == AllInstrumentalsInDatabaseArray.count-1 else {return}
                    DatabaseManager.shared.fetchAllInstrumentalsFromDatabase(page: 10, end: lastfetchedkey, completion: {[weak self] instrumentals in
                        guard let strongSelf = self else {return}
                        if instrumentals == strongSelf.lastInstrumentals{
                            strongSelf.all = true
                            return
                        }
                        strongSelf.lastInstrumentals = instrumentals
                        for song in instrumentals {
                            if !AllInstrumentalsInDatabaseArray.contains(song) {
                                AllInstrumentalsInDatabaseArray.append(song)
                            }
                        }
                        strongSelf.knownOldestInstrumentalElement = AllInstrumentalsInDatabaseArray.last
                        strongSelf.lastfetchedkey = ("\(instrumentalContentType )--\(strongSelf.knownOldestInstrumentalElement.songName!)--\(strongSelf.knownOldestInstrumentalElement.toneDeafAppId)")
                        strongSelf.pickTableView.reloadData()
                    })
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var nor = 0
        switch array {
        case "video":
            if AllVideosInDatabaseArray != nil,!AllVideosInDatabaseArray.isEmpty {
            nor = AllVideosInDatabaseArray.count
            }
        case "editbeatvideo":
            if AllVideosInDatabaseArray != nil,!AllVideosInDatabaseArray.isEmpty {
            nor = AllVideosInDatabaseArray.count
            }
        default:
            switch array {
            case "person":
                if AllPersonsInDatabaseArray != nil,!AllPersonsInDatabaseArray.isEmpty {
                    nor = AllPersonsInDatabaseArray.count
                }
            case "track":
                if exeptions != nil,!exeptions.isEmpty {
                    nor = exeptions.count
                }
            case "song":
                if AllSongsInDatabaseArray != nil,!AllSongsInDatabaseArray.isEmpty {
                    nor = AllSongsInDatabaseArray.count
                }
            case "beat":
                if AllBeatsInDatabaseArray != nil,!AllBeatsInDatabaseArray.isEmpty {
                nor = AllBeatsInDatabaseArray.count
                }
            case "album":
                if AllAlbumsInDatabaseArray != nil,!AllAlbumsInDatabaseArray.isEmpty {
                    nor = AllAlbumsInDatabaseArray.count
                }
                
            default:
                if AllInstrumentalsInDatabaseArray != nil,!AllInstrumentalsInDatabaseArray.isEmpty {
                nor = AllInstrumentalsInDatabaseArray.count
                }
            }
        }
        return nor
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch array {
        case "video":
            let cell = tableView.dequeueReusableCell(withIdentifier: "videostonespickcell", for: indexPath) as! TonesPickVideoTableViewCellController
            if AllVideosInDatabaseArray != nil,!AllVideosInDatabaseArray.isEmpty {
                let array = AllVideosInDatabaseArray[indexPath.row]
                cell.funcSetTemp(video: array)
            }
            return cell
        case "editbeatvideo":
            let cell = tableView.dequeueReusableCell(withIdentifier: "videostonespickcell", for: indexPath) as! TonesPickVideoTableViewCellController
            if AllVideosInDatabaseArray != nil,!AllVideosInDatabaseArray.isEmpty {
                let array = AllVideosInDatabaseArray[indexPath.row]
                cell.funcSetTemp(video: array)
            }
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "songalbumbeattinstrumentaltonespickcell", for: indexPath) as! TonesPickSongBeatAlbumInstrumentalTableViewCellController
            switch array {
            case "person":
                if AllPersonsInDatabaseArray != nil,!AllPersonsInDatabaseArray.isEmpty {
                    let array = AllPersonsInDatabaseArray[indexPath.row]
                    cell.funcSetTemp(person: array)
                }
            case "track":
                if exeptions != nil,!exeptions.isEmpty {
                    let array = exeptions[indexPath.row]
                    switch array{
                    case is SongData:
                        let item = array as! SongData
                        cell.funcSetTemp(song: item)
                    case is InstrumentalData:
                        let item = array as! InstrumentalData
                        cell.funcSetTemp(instrumental: item)
                    default:
                        break
                    }
                }
            case "song":
                if AllSongsInDatabaseArray != nil,!AllSongsInDatabaseArray.isEmpty {
                    let array = AllSongsInDatabaseArray[indexPath.row]
                    cell.funcSetTemp(song: array)
                }
            case "beat":
                if AllBeatsInDatabaseArray != nil,!AllBeatsInDatabaseArray.isEmpty {
                    let array = AllBeatsInDatabaseArray[indexPath.row]
                    cell.funcSetTemp(beat: array)
                }
            case "album":
                if AllAlbumsInDatabaseArray != nil,!AllAlbumsInDatabaseArray.isEmpty {
                    
                    let array = AllAlbumsInDatabaseArray[indexPath.row]
                    cell.funcSetTemp(album: array)
                }
            default:
                if AllInstrumentalsInDatabaseArray != nil,!AllInstrumentalsInDatabaseArray.isEmpty {
                    let array = AllInstrumentalsInDatabaseArray[indexPath.row]
                    cell.funcSetTemp(instrumental: array)
                }
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        switch array {
        case "video":
            openConfirmation(video: AllVideosInDatabaseArray[indexPath.row])
        case "editbeatvideo":
            openConfirmation(editbeatvideo: AllVideosInDatabaseArray[indexPath.row])
        default:
            switch array {
            case "person":
                openConfirmation(person: AllPersonsInDatabaseArray[indexPath.row])
            case "track":
                openConfirmation(track: exeptions[indexPath.row])
            case "song":
                openConfirmation(song: AllSongsInDatabaseArray[indexPath.row])
            case "beat":
                openConfirmation(beat: AllBeatsInDatabaseArray[indexPath.row])
            case "album":
                openConfirmation(album: AllAlbumsInDatabaseArray[indexPath.row])
            default:
                openConfirmation(instrumental: AllInstrumentalsInDatabaseArray[indexPath.row])
            }
        }
    }
    
    func collectionSkeletonView(_ skeletonView: UITableView, cellIdentifierForRowAt indexPath: IndexPath) -> ReusableCellIdentifier {
        var ray = ""
        switch array {
        case "video":
            ray = "videostonespickcell"
        case "editbeatvideo":
            ray = "videostonespickcell"
        default:
            ray = "songalbumbeattinstrumentaltonespickcell"
        }
        return ray
    }
    
    
}

class TonesPickVideoTableViewCellController: UITableViewCell {
    
    @IBOutlet weak var name: MarqueeLabel!
    @IBOutlet weak var artistproducer: MarqueeLabel!
    @IBOutlet weak var appId: MarqueeLabel!
    @IBOutlet weak var artwork: UIImageView!
    
    override func prepareForReuse() {
        artwork.image = nil
        name.text = ""
        artistproducer.text = ""
        appId.text = ""
    }
    
    func funcSetTemp(video: VideoData) {
        artwork.image = nil
        name.text = ""
        artistproducer.text = ""
        appId.text = ""
        name.text = video.title
        appId.text = video.toneDeafAppId
        var songart:[String] = []
        if video.videographers != nil {
            if !video.videographers!.isEmpty {
                GlobalFunctions.shared.getPersonNames(arr: video.videographers!, completion: {[weak self] per, err in
                    guard let strongSelf = self else {return}
                    if let err = err {
                        print("Error setting names: ", err)
                    } else if let per = per {
                        songart = per
                        if video.persons == nil {
                            strongSelf.artistproducer.text = "\(GlobalFunctions.shared.combine(songart).joined(separator: ", "))"
                        }
                    } else {
                        print("Error setting names: Reason Unknown")
                    }
                })
            }
        }
        var songapro:[String] = []
        if video.persons != nil {
            if !video.persons!.isEmpty {
                GlobalFunctions.shared.getPersonNames(arr: video.persons!, completion: {[weak self] per, err in
                    guard let strongSelf = self else {return}
                    if let err = err {
                        print("Error setting names: ", err)
                    } else if let per = per {
                        songapro = per
                        strongSelf.artistproducer.text = "\(GlobalFunctions.shared.combine(songart,songapro).joined(separator: ", "))"
                    } else {
                        print("Error setting names: Reason Unknown")
                    }
                })
            }
        }
        
        GlobalFunctions.shared.selectImageURL(video: video, completion: {[weak self] aimage in
            guard let strongSelf = self else {return}
            strongSelf.artwork.image = nil
            guard let img = aimage else {
                let defaultimg = UIImage(named: "tonedeaflogo")!
                strongSelf.artwork.image = defaultimg
                return
            }
            let imageURL = URL(string: img)!
            if let cachedImage = imageCache.object(forKey: imageURL.absoluteString as NSString) {
                strongSelf.artwork.image = cachedImage
                return
            } else {
                strongSelf.artwork.setImage(from: imageURL, withPlaceholder: UIImage(named: "tonedeaflogo"))
                return
            }
        })
    }
}

class TonesPickSongBeatAlbumInstrumentalTableViewCellController: UITableViewCell {
    
    @IBOutlet weak var name: MarqueeLabel!
    @IBOutlet weak var artistproducer: MarqueeLabel!
    @IBOutlet weak var appId: MarqueeLabel!
    @IBOutlet weak var artwork: UIImageView!
    
    override func prepareForReuse() {
        artwork.image = nil
        name.text = ""
        artistproducer.text = ""
        appId.text = ""
    }
    
    func funcSetTemp(person: PersonData) {
        artwork.image = nil
        name.text = person.name
        appId.text = person.toneDeafAppId
        artistproducer.text = ""
        var imageurl = ""
        GlobalFunctions.shared.selectImageURL(person: person, completion: {[weak self] ur in
            guard let strongSelf = self else {return}
            if ur != nil {
                imageurl = ur!
                guard let imageURL = URL(string: imageurl) else {
                    strongSelf.artwork.image = UIImage(named: "defaultuser")
                    return
                }
                if let cachedImage = imageCache.object(forKey: imageURL.absoluteString as NSString) {
                    strongSelf.artwork.image = cachedImage
                } else {
                    strongSelf.artwork.setImage(from: imageURL, withPlaceholder: UIImage(named: "tonedeaflogo"))
                }
            } else {
                strongSelf.artwork.image = UIImage(named: "defaultuser")
            }
            
        })
    }
    
    func funcSetTemp(song: SongData) {
        artwork.image = nil
        name.text = song.name
        if song.isRemix != nil {
            name.text = "\(song.name) [Remix]"
        }
        appId.text = song.toneDeafAppId
        var songart:[String] = []
        GlobalFunctions.shared.getPersonNames(arr: song.songArtist, completion: { per, err in
            if let err = err {
                print("Error setting names: ", err)
            } else if let per = per {
                songart = per
            } else {
                print("Error setting names: Reason Unknown")
            }
        })
        var songapro:[String] = []
        GlobalFunctions.shared.getPersonNames(arr: song.songProducers, completion: {[weak self] per, err in
            guard let strongSelf = self else {return}
            if let err = err {
                print("Error setting names: ", err)
            } else if let per = per {
                songapro = per
                strongSelf.artistproducer.text = "\(songart.joined(separator: ", ")), \(songapro.joined(separator: ", "))"
            } else {
                print("Error setting names: Reason Unknown")
            }
        })
        var imageurl = ""
        GlobalFunctions.shared.selectImageURL(song: song, completion: {[weak self] ur in
            guard let strongSelf = self else {return}
            if ur != nil {
                imageurl = ur!
                guard let imageURL = URL(string: imageurl) else {
                    strongSelf.artwork.image = UIImage(named: "defaultuser")
                    return
                }
                if let cachedImage = imageCache.object(forKey: imageURL.absoluteString as NSString) {
                    strongSelf.artwork.image = cachedImage
                } else {
                    strongSelf.artwork.setImage(from: imageURL, withPlaceholder: UIImage(named: "tonedeaflogo"))
                }
            } else {
                strongSelf.artwork.image = UIImage(named: "defaultuser")
            }
            
        })
    }
    func funcSetTemp(beat: BeatData) {
        artwork.image = nil
        name.text = beat.name
        appId.text = beat.toneDeafAppId
        var songapro:[String] = []
        GlobalFunctions.shared.getPersonNames(arr: beat.producers, completion: { per, err in
            if let err = err {
                print("Error setting names: ", err)
            } else if let per = per {
                songapro = per
            } else {
                print("Error setting names: Reason Unknown")
            }
        })
        artistproducer.text = "\(songapro.joined(separator: ", "))"
        let imageURL = URL(string: beat.imageURL)!
        if let cachedImage = imageCache.object(forKey: imageURL.absoluteString as NSString) {
            artwork.image = cachedImage
        } else {
            artwork.setImage(from: imageURL, withPlaceholder: UIImage(named: "tonedeaflogo"))
        }
        
    }
    func funcSetTemp(album: AlbumData) {
        artwork.image = nil
        name.text = album.name
        if album.isDeluxe != nil {
            name.text = "\(album.name) [Deluxe]"
        }
        appId.text = album.toneDeafAppId
        var songart:[String] = []
        GlobalFunctions.shared.getPersonNames(arr: album.mainArtist, completion: { per, err in
            if let err = err {
                print("Error setting names: ", err)
            } else if let per = per {
                songart = per
            } else {
                print("Error setting names: Reason Unknown")
            }
        })
        var songapro:[String] = []
        GlobalFunctions.shared.getPersonNames(arr: album.producers, completion: {[weak self] per, err in
            guard let strongSelf = self else {return}
            if let err = err {
                print("Error setting names: ", err)
            } else if let per = per {
                songapro = per
                strongSelf.artistproducer.text = "\(songart.joined(separator: ", ")), \(songapro.joined(separator: ", "))"
            } else {
                print("Error setting names: Reason Unknown")
            }
        })
        GlobalFunctions.shared.selectImageURL(album: album, completion: {[weak self] aimage in
            guard let strongSelf = self else {return}
            guard let img = aimage else {
                let defaultimg = UIImage(named: "defaultuser")!
                strongSelf.artwork.image = defaultimg
                return
            }
            let imageURL = URL(string: img)!
            if let cachedImage = imageCache.object(forKey: imageURL.absoluteString as NSString) {
                strongSelf.artwork.image = cachedImage
                return
            } else {
                strongSelf.artwork.setImage(from: imageURL, withPlaceholder: UIImage(named: "tonedeaflogo"))
                return
            }
        })
    }
    func funcSetTemp(instrumental: InstrumentalData) {
        artwork.image = nil
        name.text = instrumental.instrumentalName
        appId.text = instrumental.toneDeafAppId
        var songapro:[String] = []
        GlobalFunctions.shared.getPersonNames(arr: instrumental.producers, completion: { per, err in
            if let err = err {
                print("Error setting names: ", err)
            } else if let per = per {
                songapro = per
            } else {
                print("Error setting names: Reason Unknown")
            }
        })
        artistproducer.text = "\(songapro.joined(separator: ", "))"
        GlobalFunctions.shared.selectImageURL(instrumental: instrumental, completion: {[weak self] aimage in
            guard let strongSelf = self else {return}
            guard let imge = aimage else {
                return
            }
            let imageURL = URL(string: imge)!
            if let cachedImage = imageCache.object(forKey: imageURL.absoluteString as NSString) {
                strongSelf.artwork.image = cachedImage
            } else {
                strongSelf.artwork.setImage(from: imageURL, withPlaceholder: UIImage(named: "tonedeaflogo"))
            }
            
        })
    }
    
    func getYoutubeData(song:SongData, completion: @escaping (Array<YouTubeData>, Array<String>) -> Void) {
        var videosData:Array<YouTubeData> = []
        var youtubeimageURLs:Array<String> = []
        var val = 1
        if !song.videos!.isEmpty {
            if song.videos![0] != "" {
                for video in song.videos! {
                    let word = video.split(separator: "Æ")
                    let id = word[0]
                    DatabaseManager.shared.findVideoById(videoid: String(id), completion: { selectedVideo in
                        switch selectedVideo {
                        case .success(let vid):
                            let video = vid as! YouTubeData
                            videosData.append(video)
                            if video.thumbnailURL != "" {
                                youtubeimageURLs.append(video.thumbnailURL)
                            }
                            if val == song.videos!.count {
                                completion(videosData, youtubeimageURLs)
                            }
                            val+=1
                        case .failure(let error):
                            print("Video ID proccessing error \(error)")
                            if val == song.videos!.count {
                                completion(videosData, youtubeimageURLs)
                            }
                            val+=1
                        }
                    })
                }
            } else {
                completion(videosData, youtubeimageURLs)
            }
        } else {
            completion(videosData, youtubeimageURLs)
        }
        
    }
    
    func getYoutubeData(instrumental:InstrumentalData, completion: @escaping (Array<YouTubeData>, Array<String>) -> Void) {
        var videosData:Array<YouTubeData> = []
        var youtubeimageURLs:Array<String> = []
        var val = 1
        if !instrumental.videos!.isEmpty {
            if instrumental.videos![0] != "" {
                for video in instrumental.videos! {
                    let word = video.split(separator: "Æ")
                    let id = word[0]
                    DatabaseManager.shared.findVideoById(videoid: String(id), completion: { selectedVideo in
                        switch selectedVideo {
                        case .success(let vid):
                            let video = vid as! YouTubeData
                            videosData.append(video)
                            if video.thumbnailURL != "" {
                                youtubeimageURLs.append(video.thumbnailURL)
                            }
                            if val == instrumental.videos!.count {
                                completion(videosData, youtubeimageURLs)
                            }
                            val+=1
                        case .failure(let error):
                            print("Video ID proccessing error \(error)")
                            if val == instrumental.videos!.count {
                                completion(videosData, youtubeimageURLs)
                            }
                            val+=1
                        }
                    })
                }
            } else {
                completion(videosData, youtubeimageURLs)
            }
        } else {
            completion(videosData, youtubeimageURLs)
        }
        
    }
}
