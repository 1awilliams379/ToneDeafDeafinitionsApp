//
//  MainSearchResultsTableTableViewController.swift
//  ToneDeafDeafinitionsApp
//
//  Created by Tone Deaf on 9/29/20.
//  Copyright © 2020 GITEM Solutions. All rights reserved.
//

import UIKit
import SkeletonView

class MainSearchResultsTableTableViewController: UITableViewController, SkeletonTableViewDataSource {
    
    static let shared = MainSearchResultsTableTableViewController()
    
    @IBOutlet var resultsTableView: UITableView!
    @IBOutlet weak var resultstableviewheight: NSLayoutConstraint!
    
    var allContent:[String] = []
    var allSongs:[String] = []
    var allVideos:[String] = []
    var allArtist:[String] = []
    var allProducers:[String] = []
    var allAlbums:[String] = []
    var allMerch:[String] = []
    var allBeats:[String] = []
    var allInstrumentals:[String] = []
    
    var searchedContent:[String] = []
    
    var infoDetailContent:Any!
    var artistInfo:ArtistData!
    var producerInfo:ProducerData!
    
    var searchedSongsData:[SongData] = []
    var searchedVideosData:[Any] = []
    var searchedArtistData:[ArtistData] = []
    var searchedProducersData:[ProducerData] = []
    var searchedAlbumsData:[AlbumData] = []
    var searchedBeatsData:[BeatData] = []
    var searchedMerchData:[MerchData] = []
    var searchedInstrumentalsData:[InstrumentalData] = []
    
    let progressHUD = ProgressHUD(text: "Fetching...")
    var data:[[Any]]!
    
    var intialLoad = false
    var skelvar = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        dismissKeyboardOnTap()
        let nib = UINib(nibName: "Header", bundle: nil)
        navigationController?.navigationBar.prefersLargeTitles = false
        resultsTableView.showsVerticalScrollIndicator = false
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        resultsTableView.register(nib, forHeaderFooterViewReuseIdentifier: "TableSectionHeader")
        resultsTableView.delegate = self
        resultsTableView.dataSource = self
        self.navigationController?.navigationItem.largeTitleDisplayMode = .never
        setTable(completion: {
            
        })
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
        else {
          // if keyboard size is not available for some reason, dont do anything
          return
        }

        let contentInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: keyboardSize.height , right: 0.0)
        resultsTableView.contentInset = contentInsets
        resultsTableView.scrollIndicatorInsets = contentInsets
      }

      @objc func keyboardWillHide(notification: NSNotification) {
        let contentInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
            
        
        // reset back the content inset to zero after keyboard is gone
        resultsTableView.contentInset = contentInsets
        resultsTableView.scrollIndicatorInsets = contentInsets
      }
    
    override func viewWillAppear(_ animated: Bool) {
        if intialLoad == false {
            self.view.addSubview(progressHUD)
        }
        resultsTableView.isHidden=false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if skelvar == 0 {
            resultsTableView.isSkeletonable = true
            tableView.showAnimatedGradientSkeleton(usingGradient: .init(baseColor: UIColor.init(red: 22/255, green: 22/255, blue: 22/255, alpha: 1)), animation: nil, transition: .crossDissolve(0.25))
        }
        skelvar+=1
//        UIView.animate(withDuration: 0.3) { [weak self] in
//            guard let strongSelf = self else {return}
//            strongSelf.navigationController?.navigationBar.isHidden = true
//            strongSelf.view.layoutSubviews()
//        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        //resultsTableView.isHidden = true
    }
    
    func dismissKeyboardOnTap() {
        let tap = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        self.tableView.keyboardDismissMode = .onDrag
    }
    
    func hideskeleton(tableview: UITableView) {
        skelvar+=1
        DispatchQueue.main.async { [weak self] in
            guard let strongSelf = self else {return}
            print("Hiding skeleton")
            tableview.stopSkeletonAnimation()
            tableview.hideSkeleton(reloadDataAfter: true, transition: .crossDissolve(0.25))
            tableview.reloadData()
            //strongSelf.resultstableviewheight.constant = strongSelf.tableView.contentSize.height
            strongSelf.view.layoutSubviews()
        }
    }
    
    func setTable(completion: @escaping (() -> Void)) {
        data = [searchedArtistData,searchedProducersData,searchedMerchData,searchedSongsData,searchedVideosData,searchedAlbumsData,searchedBeatsData,searchedInstrumentalsData]
//        let queue = DispatchQueue(label: "myakjjkbxcjhacekbfjkndsmdsfhzjvb,hds ZKfhcuewsQueue")
//        let group = DispatchGroup()
//        let array = [1, 2, 3]
//
//        for i in array {
//            group.enter()
//            queue.async { [weak self] in
//                guard let strongSelf = self else {return}
//                switch i {
//                case 1:
//                    strongSelf.getContent {
//                        <#code#>
//                    }
//                default:
//                    print("kjhgf")
//                }
//            }
//        }
//        group.notify(queue: DispatchQueue.main) { [weak self] in
//            guard let strongSelf = self else {return}
//            print("done!")
//            completion()
//        }
        getContent(completion: {[weak self] in
            guard let strongSelf = self else {return}
//            strongSelf.getRandomContent(completion: {
            strongSelf.hideskeleton(tableview: strongSelf.resultsTableView)
            strongSelf.progressHUD.stopAnimation()
            strongSelf.progressHUD.removeFromSuperview()
            strongSelf.intialLoad = true
//            })
            completion()
        })
    }
    
    func getContent(completion: @escaping (() -> Void)) {
        DatabaseManager.shared.fetchAllContentFromDatabase(completion: {[weak self] content in
            guard let strongSelf = self else {return}
            strongSelf.allContent = content
            for dbid in content {
                let word = dbid.split(separator: "Æ")
                let rawid = word[0]
                switch String(rawid).count {
                case 5:
                    strongSelf.allProducers.append(dbid)
                case 6:
                    strongSelf.allArtist.append(dbid)
                case 8:
                    strongSelf.allAlbums.append(dbid)
                case 9:
                    strongSelf.allVideos.append(dbid)
                case 10:
                    strongSelf.allSongs.append(dbid)
                case 12:
                    strongSelf.allInstrumentals.append(dbid)
                case 13...14:
                    strongSelf.allBeats.append(dbid)
                case 20...24:
                    strongSelf.allMerch.append(dbid)
                default://14
                    print("")
                }
            }
            completion()
        })
    }
    
//    func getRandomContent(completion: @escaping (() -> Void)) {
//
//    }

    // MARK: - Table view data source
    func collectionSkeletonView(_ skeletonView: UITableView, cellIdentifierForRowAt indexPath: IndexPath) -> ReusableCellIdentifier {
            return "infoDetailCell"
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if self.tableView(tableView, numberOfRowsInSection: section) > 0 {
            return 70
        } else {
            return 0
        }
    }

    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = self.tableView.dequeueReusableHeaderFooterView(withIdentifier: "TableSectionHeader") as! TableSectionHeader
        var sectitle = ""
        
        if section == 0 {
            if self.tableView(tableView, numberOfRowsInSection: section) > 0 {
                sectitle = "Artists"
            } else {
                return nil
            }
        } else if section == 1 {
            if self.tableView(tableView, numberOfRowsInSection: section) > 0 {
                sectitle = "Producers"
            } else {
                return nil
            }
        } else if section == 2 {
            if self.tableView(tableView, numberOfRowsInSection: section) > 0 {
                sectitle = "Merchandise"
            } else {
                return nil
            }
        } else if section == 3 {
            if self.tableView(tableView, numberOfRowsInSection: section) > 0 {
                sectitle = "Songs"
            } else {
                return nil
            }
        } else if section == 4 {
            if self.tableView(tableView, numberOfRowsInSection: section) > 0 {
                sectitle = "Videos"
            } else {
                return nil
            }
        } else if section == 5 {
            if self.tableView(tableView, numberOfRowsInSection: section) > 0 {
                sectitle = "Albums"
            } else {
                return nil
            }
        } else if section == 6 {
            if self.tableView(tableView, numberOfRowsInSection: section) > 0 {
                sectitle = "Beats"
            } else {
                return nil
            }
        }
        else {
            if self.tableView(tableView, numberOfRowsInSection: section) > 0 {
                sectitle = "Instrumentals"
            } else {
                return nil
            }
        }
        let header = cell
        header.titleLabel.text = sectitle
        
        return cell
        
        
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        var numberOfSections = 1
        if data != nil, !data.isEmpty {
            numberOfSections = data.count
        }
        return numberOfSections
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var numberOfRows = 0
        if data != nil, !data.isEmpty {
            numberOfRows = data[section].count
        }
        return numberOfRows
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return 80
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "infoDetailCell", for: indexPath) as! InfoDetailTableCell
            if !searchedArtistData.isEmpty {
                let video = data[indexPath.section][indexPath.row] as! ArtistData
                cell.funcSetTemp(artist: video)
            }
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "infoDetailCell", for: indexPath) as! InfoDetailTableCell
            if !searchedProducersData.isEmpty {
                let video = data[indexPath.section][indexPath.row] as! ProducerData
                cell.funcSetTemp(producer: video)
            }
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "infoDetailCell", for: indexPath) as! InfoDetailTableCell
            if !searchedMerchData.isEmpty {
                let merch = data[indexPath.section][indexPath.row] as! MerchData
                cell.funcSetTemp(merch: merch)
            }
            return cell
        case 3:
            let cell = tableView.dequeueReusableCell(withIdentifier: "infoDetailCell", for: indexPath) as! InfoDetailTableCell
            if !searchedSongsData.isEmpty {
                
                let video = data[indexPath.section][indexPath.row] as! SongData
                cell.funcSetTemp(song: video)
            }
            return cell
        case 4:
            let cell = tableView.dequeueReusableCell(withIdentifier: "infoVideoDetailCell", for: indexPath) as! InfoVideoDetailTableCell
            if !searchedVideosData.isEmpty {
                let video = data[indexPath.section][indexPath.row] as! VideoData
                cell.funcSetTemp(video: video)
            }
            return cell
        case 5:
            let cell = tableView.dequeueReusableCell(withIdentifier: "infoDetailCell", for: indexPath) as! InfoDetailTableCell
            if !searchedAlbumsData.isEmpty {
                let video = data[indexPath.section][indexPath.row] as! AlbumData
                cell.funcSetTemp(album: video)
            }
            return cell
        case 6:
            let cell = tableView.dequeueReusableCell(withIdentifier: "infoDetailCell", for: indexPath) as! InfoDetailTableCell
            if !searchedBeatsData.isEmpty {
                let beat = data[indexPath.section][indexPath.row] as! BeatData
                cell.funcSetTemp(beat: beat)
            }
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "infoDetailCell", for: indexPath) as! InfoDetailTableCell
            if !searchedInstrumentalsData.isEmpty {
                let video = data[indexPath.section][indexPath.row] as! InstrumentalData
                cell.funcSetTemp(instrumental: video)
            }
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        switch indexPath.section {
        case 0:
            let artist = data[indexPath.section][indexPath.row] as! ArtistData
            NotificationCenter.default.post(name: transitionFromExploreToArtistInfoNotify, object: artist)
        case 1:
            let producer = data[indexPath.section][indexPath.row] as! ProducerData
            NotificationCenter.default.post(name: transitionFromExploreToProducerInfoNotify, object: producer)
        case 2:
            print("srbsdf")
            let merch = data[indexPath.section][indexPath.row] as! MerchData
            NotificationCenter.default.post(name: transitionFromExploreToMerchInfoNotify, object: merch)
        case 3:
            let song = data[indexPath.section][indexPath.row] as! SongData
            NotificationCenter.default.post(name: transitionExploreToDetailInfoNotify, object: song)
        case 4:
            let video = data[indexPath.section][indexPath.row] as AnyObject
            NotificationCenter.default.post(name: transitionExploreToDetailInfoNotify, object: video)
        case 5:
            let album = data[indexPath.section][indexPath.row] as! AlbumData
            NotificationCenter.default.post(name: transitionExploreToDetailInfoNotify, object: album)
        case 6:
            let beat = data[indexPath.section][indexPath.row] as! BeatData
        default:
            let instrumental = data[indexPath.section][indexPath.row] as! InstrumentalData
            NotificationCenter.default.post(name: transitionExploreToDetailInfoNotify, object: instrumental)
        }
    }
    
    func search(searchText: String, completion: @escaping (() -> Void)) {
        var tick = 0
        var limit = 7
        searchedArtistData = []
        searchedProducersData = []
        searchedMerchData = []
        searchedSongsData = []
        searchedContent = []
        searchedBeatsData = []
        searchedAlbumsData = []
        searchedVideosData = []
        searchedInstrumentalsData = []
        
        DatabaseManager.shared.searchMerch(text: searchText, limit: 7, completion: {[weak self] array in
            guard let strongSelf = self else {return}
            strongSelf.searchedMerchData = array
            strongSelf.data = [strongSelf.searchedArtistData,strongSelf.searchedProducersData,strongSelf.searchedMerchData,strongSelf.searchedSongsData,strongSelf.searchedVideosData,strongSelf.searchedAlbumsData,strongSelf.searchedBeatsData,strongSelf.searchedInstrumentalsData]
            tick+=1
            if tick == limit {
                completion()
                return
            }
        })
        DatabaseManager.shared.searchSongs(text: searchText, limit: 7, completion: {[weak self] array in
            guard let strongSelf = self else {return}
            strongSelf.searchedSongsData = array
            strongSelf.data = [strongSelf.searchedArtistData,strongSelf.searchedProducersData,strongSelf.searchedMerchData,strongSelf.searchedSongsData,strongSelf.searchedVideosData,strongSelf.searchedAlbumsData,strongSelf.searchedBeatsData,strongSelf.searchedInstrumentalsData]
            tick+=1
            if tick == limit {
                completion()
                return
            }
        })
        DatabaseManager.shared.searchAlbums(text: searchText, limit: 7, completion: {[weak self] array in
            guard let strongSelf = self else {return}
            strongSelf.searchedAlbumsData = array
            strongSelf.data = [strongSelf.searchedArtistData,strongSelf.searchedProducersData,strongSelf.searchedMerchData,strongSelf.searchedSongsData,strongSelf.searchedVideosData,strongSelf.searchedAlbumsData,strongSelf.searchedBeatsData,strongSelf.searchedInstrumentalsData]
            tick+=1
            if tick == limit {
                completion()
                return
            }
        })
        DatabaseManager.shared.searchInstrumentals(text: searchText, limit: 7, completion: {[weak self] array in
            guard let strongSelf = self else {return}
            strongSelf.searchedInstrumentalsData = array
            strongSelf.data = [strongSelf.searchedArtistData,strongSelf.searchedProducersData,strongSelf.searchedMerchData,strongSelf.searchedSongsData,strongSelf.searchedVideosData,strongSelf.searchedAlbumsData,strongSelf.searchedBeatsData,strongSelf.searchedInstrumentalsData]
            tick+=1
            if tick == limit {
                completion()
                return
            }
        })
        DatabaseManager.shared.searchVideos(text: searchText, limit: 7, completion: {[weak self] array in
            guard let strongSelf = self else {return}
            strongSelf.searchedVideosData = array
            strongSelf.data = [strongSelf.searchedArtistData,strongSelf.searchedProducersData,strongSelf.searchedMerchData,strongSelf.searchedSongsData,strongSelf.searchedVideosData,strongSelf.searchedAlbumsData,strongSelf.searchedBeatsData,strongSelf.searchedInstrumentalsData]
            tick+=1
            if tick == limit {
                completion()
                return
            }
        })
        DatabaseManager.shared.searchBeats(text: searchText, limit: 7, completion: {[weak self] array in
            guard let strongSelf = self else {return}
            strongSelf.searchedBeatsData = array
            strongSelf.data = [strongSelf.searchedArtistData,strongSelf.searchedProducersData,strongSelf.searchedMerchData,strongSelf.searchedSongsData,strongSelf.searchedVideosData,strongSelf.searchedAlbumsData,strongSelf.searchedBeatsData,strongSelf.searchedInstrumentalsData]
            tick+=1
            if tick == limit {
                completion()
                return
            }
        })
        DatabaseManager.shared.searchArtists(text: searchText, limit: 7, completion: {[weak self] array in
            guard let strongSelf = self else {return}
            strongSelf.searchedArtistData = array
            strongSelf.data = [strongSelf.searchedArtistData,strongSelf.searchedProducersData,strongSelf.searchedMerchData,strongSelf.searchedSongsData,strongSelf.searchedVideosData,strongSelf.searchedAlbumsData,strongSelf.searchedBeatsData,strongSelf.searchedInstrumentalsData]
            tick+=1
            if tick == limit {
                completion()
                return
            }
        })
        DatabaseManager.shared.searchProducers(text: searchText, limit: 7, completion: {[weak self] array in
            guard let strongSelf = self else {return}
            strongSelf.searchedProducersData = array
            strongSelf.data = [strongSelf.searchedArtistData,strongSelf.searchedProducersData,strongSelf.searchedMerchData,strongSelf.searchedSongsData,strongSelf.searchedVideosData,strongSelf.searchedAlbumsData,strongSelf.searchedBeatsData,strongSelf.searchedInstrumentalsData]
            tick+=1
            if tick == limit {
                completion()
                return
            }
        })
    }

}
extension MainSearchResultsTableTableViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        searchController.searchBar.backgroundImage = UIImage()
        if searchController.searchBar.text == "" {
                searchedArtistData = []
                searchedProducersData = []
            searchedMerchData = []
                searchedSongsData = []
                searchedContent = []
                searchedBeatsData = []
                searchedAlbumsData = []
                searchedVideosData = []
                searchedInstrumentalsData = []
                resultsTableView.reloadData()
                //resultstableviewheight.constant = resultsTableView.contentSize.height
                view.layoutSubviews()
            }
            else {
                searchedArtistData = []
                searchedProducersData = []
                searchedMerchData = []
                searchedSongsData = []
                searchedContent = []
                searchedBeatsData = []
                searchedAlbumsData = []
                searchedVideosData = []
                searchedInstrumentalsData = []
                
                search(searchText: searchController.searchBar.text!, completion: {
                    
                    DispatchQueue.main.async {[weak self] in
                        guard let strongSelf = self else {return}
                        
                        strongSelf.resultsTableView.reloadData()
                        //strongSelf.resultstableviewheight.constant = strongSelf.resultsTableView.contentSize.height
                        strongSelf.view.layoutSubviews()
                        
                    }
                })
                
            }
            
        }
}
