//
//  EditKitsHelper.swift
//  ToneDeafDeafinitionsApp
//
//  Created by Tone Deaf on 11/1/20.
//  Copyright © 2020 GITEM Solutions. All rights reserved.
//

import Foundation
import FirebaseDatabase
import FirebaseStorage

class EditKitsHelper {
    
    static let shared = EditKitsHelper()
    
    var initKit:MerchKitData!
    //Initial Images
    var initImages:[UIImage] = []
    var initImageDBURLs:[String] = []
    
    var currKit:MerchKitData!
    //Current Images
    var currImages:[UIImage] = []
    var currImageDBURLs:[String] = []
    
    func processName(initialKit: MerchKitData, currentKit: MerchKitData, completion: @escaping (([Error]?) -> Void)) {
        initKit = initialKit
        currKit = currentKit
        var errors:[Error] = []
        var uc1 = false
        var uc2 = false
        var uc3 = false
        var uc4 = false
        var uc5 = false
        var uc6 = false
        
        var uc7 = false
        var uc8 = false
        var uc9 = false
        var uc10 = false
        var uc11 = false
        var uc12 = false
        var uc13 = false
        var uc14 = false
        
        let bqueue = DispatchQueue(label: "myhhtdrfnhvhhvj32vkheditingQkitssssseue")
        let bgroup = DispatchGroup()
        let barray = [0,1,2,3,4,5]

        for i in barray {
            bgroup.enter()
            bqueue.async { [weak self] in
                guard let strongSelf = self else {return}
                switch i {
                case 0:
                    strongSelf.clearArtist(fromKit: strongSelf.initKit, completion: {err in
                    if let error = err {
                        errors.append(error)
                        uc1 = false
                    } else {
                        uc1 = true
                        print("name done \(i)")
                    }
                    bgroup.leave()
                })
                case 1:
                    strongSelf.clearProducers(fromKit: strongSelf.initKit, completion: {err in
                    if let error = err {
                        errors.append(error)
                        uc2 = false
                    } else {
                        uc2 = true
                        print("name done \(i)")
                    }
                    bgroup.leave()
                })
                case 2:
                    strongSelf.clearSongs(fromKit: strongSelf.initKit, completion: {err in
                        if let error = err {
                            errors.append(error)
                            uc3 = false
                        } else {
                            uc3 = true
                            print("name done \(i)")
                        }
                        bgroup.leave()
                    })
                case 3:
                    strongSelf.clearAlbums(fromKit: strongSelf.initKit, completion: {err in
                        if let error = err {
                            errors.append(error)
                            uc4 = false
                        } else {
                            uc4 = true
                            print("name done \(i)")
                        }
                        bgroup.leave()
                    })
                case 4:
                    strongSelf.clearVideos(fromKit: strongSelf.initKit, completion: {err in
                        if let error = err {
                            errors.append(error)
                            uc5 = false
                        } else {
                            uc5 = true
                            print("name done \(i)")
                        }
                        bgroup.leave()
                    })
                case 5:
                    strongSelf.clearBeats(fromKit: strongSelf.initKit, completion: {err in
                        if let error = err {
                            errors.append(error)
                            uc6 = false
                        } else {
                            uc6 = true
                            print("name done \(i)")
                        }
                        bgroup.leave()
                    })
                default:
                    print("Edit Kit Name error")
                }
            }
        }
        
        bgroup.notify(queue: DispatchQueue.main) { [weak self] in
            guard let strongSelf = self else {return}
            if uc1 == false || uc2 == false || uc3 == false || uc4 == false || uc5 == false || uc6 == false {
                completion(errors)
                return
            } else {
                let queue = DispatchQueue(label: "myhhtdrfnhvhhvjvkheditingQkitssssseue")
                let group = DispatchGroup()
                let array = [0,1,2,3,4,5,6,7]

                for i in array {
                    group.enter()
                    queue.async { [weak self] in
                        guard let strongSelf = self else {return}
                        switch i {
                        case 0:
                            strongSelf.updateArtist(fromKit: strongSelf.initKit, toKit: strongSelf.currKit, completion: {err in
                            if let error = err {
                                errors.append(error)
                                uc7 = false
                            } else {
                                uc7 = true
                                print("name done \(i)")
                            }
                            group.leave()
                        })
                        case 1:
                            strongSelf.changeMerchArray(fromKit: strongSelf.initKit, tokit: strongSelf.currKit, completion: {err in
                                if let error = err {
                                    errors.append(error)
                                    uc8 = false
                                } else {
                                    uc8 = true
                                    print("name done \(i)")
                                }
                                group.leave()
                            })
                        case 2:
                            strongSelf.updateProducers(fromKit: strongSelf.initKit, toKit: strongSelf.currKit, completion: {err in
                                if let error = err {
                                    errors.append(error)
                                    uc9 = false
                                } else {
                                    uc9 = true
                                    print("name done \(i)")
                                }
                                group.leave()
                            })
                        case 3:
                            strongSelf.updateSongs(fromKit: strongSelf.initKit, toKit: strongSelf.currKit, completion: {err in
                                if let error = err {
                                    errors.append(error)
                                    uc10 = false
                                } else {
                                    uc10 = true
                                    print("name done \(i)")
                                }
                                group.leave()
                            })
                        case 4:
                            strongSelf.updateAlbums(fromKit: strongSelf.initKit, toKit: strongSelf.currKit, completion: {err in
                                if let error = err {
                                    errors.append(error)
                                    uc11 = false
                                } else {
                                    uc11 = true
                                    print("name done \(i)")
                                }
                                group.leave()
                            })
                        case 5:
                            strongSelf.updateVideos(fromKit: strongSelf.initKit, toKit: strongSelf.currKit, completion: {err in
                                if let error = err {
                                    errors.append(error)
                                    uc12 = false
                                } else {
                                    uc12 = true
                                    print("name done \(i)")
                                }
                                group.leave()
                            })
                        case 6:
                            strongSelf.updateBeats(fromKit: strongSelf.initKit, toKit: strongSelf.currKit, completion: {err in
                                if let error = err {
                                    errors.append(error)
                                    uc13 = false
                                } else {
                                    uc13 = true
                                    print("name done \(i)")
                                }
                                group.leave()
                            })
                        case 7:
                            strongSelf.changeAllContentArray(fromKit: strongSelf.initKit, toKit: strongSelf.currKit, completion: {err in
                                if let error = err {
                                    errors.append(error)
                                    uc14 = false
                                } else {
                                    uc14 = true
                                    print("name done \(i)")
                                }
                                group.leave()
                            })
                        default:
                            print("Edit Kit Name error")
                        }
                    }
                }
                
                group.notify(queue: DispatchQueue.main) { [weak self] in
                    guard let strongSelf = self else {return}
                    if uc7 == false || uc8 == false || uc9 == false || uc10 == false || uc11 == false || uc12 == false || uc13 == false || uc14 == false {
                        completion(errors)
                        return
                    } else {
                        print("📗 Kit name updated to database successfully.")
                        completion(nil)
                        return
                    }
                }
            }
        }
    }
    
    func clearArtist(fromKit: MerchKitData, completion: @escaping ((Error?) -> Void)) {
        guard let arr = fromKit.artists else {
            completion(nil)
            return
        }
        var tick = 0
        for dbid in arr {
            let word = dbid.split(separator: "Æ")
            let id = String(word[0])
            DatabaseManager.shared.fetchArtistData(artist: id, completion: {[weak self] artist in
                guard let strongSelf = self else {return}
                let cat = "\(artist.name!)--\(artist.dateRegisteredToApp!)--\(artist.timeRegisteredToApp!)--\(artist.toneDeafAppId)"
                let ref = Database.database().reference().child("Registered Artists").child(cat).child("Merch")
                ref.observeSingleEvent(of: .value, with: { snap in
                    var newArr:[String] = []
                    if let val = snap.value as? [String] {
                        newArr = val
                        var uparr:[String] = []
                        for i in 0..<newArr.count {
                            if !newArr[i].contains("\(fromKit.tDAppId)Æ\(fromKit.name)") {
                                uparr.append(newArr[i])
                            }
                        }
                        ref.setValue(uparr)
                        tick+=1
                        if tick == arr.count {
                            completion(nil)
                        }
                    } else {
                        var uparr:[String] = []
                        for i in 0..<newArr.count {
                            if !newArr[i].contains("\(fromKit.tDAppId)Æ\(fromKit.name)") {
                                uparr.append(newArr[i])
                            }
                        }
                        ref.setValue(uparr)
                        tick+=1
                        if tick == arr.count {
                            completion(nil)
                        }
                    }
                })
            })
        }
    }
    
    func clearProducers(fromKit: MerchKitData, completion: @escaping ((Error?) -> Void)) {
        guard let arr = fromKit.producers else {
            completion(nil)
            return
        }
        var tick = 0
        for dbid in arr {
            let word = dbid.split(separator: "Æ")
            let id = String(word[0])
//            DatabaseManager.shared.fetchPersonData(person: id, completion: {[weak self] producer in
//                guard let strongSelf = self else {return}
//                let cat = "\(producer.name!)--\(producer.dateRegisteredToApp!)--\(producer.timeRegisteredToApp!)--\(producer.toneDeafAppId)"
//                let ref = Database.database().reference().child("Registered Producers").child(cat).child("Merch")
//                ref.observeSingleEvent(of: .value, with: { snap in
//                    var newArr:[String] = []
//                    if let val = snap.value as? [String] {
//                        newArr = val
//                        var uparr:[String] = []
//                        for i in 0..<newArr.count {
//                            if !newArr[i].contains("\(fromKit.tDAppId)Æ\(fromKit.name)") {
//                                uparr.append(newArr[i])
//                            }
//                        }
//                        ref.setValue(uparr)
//                        tick+=1
//                        if tick == arr.count {
//                            completion(nil)
//                        }
//                    } else {
//                        var uparr:[String] = []
//                        for i in 0..<newArr.count {
//                            if !newArr[i].contains("\(fromKit.tDAppId)Æ\(fromKit.name)") {
//                                uparr.append(newArr[i])
//                            }
//                        }
//                        ref.setValue(uparr)
//                        tick+=1
//                        if tick == arr.count {
//                            completion(nil)
//                        }
//                    }
//                })
//            })
        }
    }
    
    func clearSongs(fromKit: MerchKitData, completion: @escaping ((Error?) -> Void)) {
        guard let arr = fromKit.songs else {
            completion(nil)
            return
        }
        var tick = 0
        for dbid in arr {
            let word = dbid.split(separator: "Æ")
            let id = String(word[0])
            DatabaseManager.shared.findSongById(songId: id, completion: {[weak self] result in
                guard let strongSelf = self else {return}
                switch result {
                case .success(let song):
                    var songart:[String] = []
                    for art in song.songArtist {
                        let word = art.split(separator: "Æ")
                        let id = word[0]
                        songart.append(String(id))
                    }
                    let cat = "\(songContentTag)--\(song.name)--\(songart.joined(separator: ", "))--\(song.toneDeafAppId)"
                    let ref = Database.database().reference().child("Music Content").child("Songs").child(cat).child("REQUIRED").child("Merch")
                    ref.observeSingleEvent(of: .value, with: { snap in
                        var newArr:[String] = []
                        if let val = snap.value as? [String] {
                            newArr = val
                            var uparr:[String] = []
                            for i in 0..<newArr.count {
                                if !newArr[i].contains("\(fromKit.tDAppId)Æ\(fromKit.name)") {
                                    uparr.append(newArr[i])
                                }
                            }
                            ref.setValue(uparr)
                            tick+=1
                            if tick == arr.count {
                                completion(nil)
                            }
                        } else {
                            var uparr:[String] = []
                            for i in 0..<newArr.count {
                                if !newArr[i].contains("\(fromKit.tDAppId)Æ\(fromKit.name)") {
                                    uparr.append(newArr[i])
                                }
                            }
                            ref.setValue(uparr)
                            tick+=1
                            if tick == arr.count {
                                completion(nil)
                            }
                        }
                    })
                case .failure(let err):
                completion(err)
                return
                }
            })
        }
    }
    
    func clearAlbums(fromKit: MerchKitData, completion: @escaping ((Error?) -> Void)) {
        guard let arr = fromKit.albums else {
            completion(nil)
            return
        }
        var tick = 0
        for dbid in arr {
            let word = dbid.split(separator: "Æ")
            let id = String(word[0])
            DatabaseManager.shared.findAlbumById(albumId: id, completion: {[weak self] result in
                guard let strongSelf = self else {return}
                switch result {
                case .success(let album):
                    var songart:[String] = []
                    for art in album.mainArtist {
                        let word = art.split(separator: "Æ")
                        let id = word[0]
                        songart.append(String(id))
                    }
                    let cat = "\(albumContentTag)--\(album.name)--\(songart.joined(separator: ", "))--\(album.toneDeafAppId)"
                    let ref = Database.database().reference().child("Music Content").child("Albums").child(cat).child("REQUIRED").child("Merch")
                    ref.observeSingleEvent(of: .value, with: { snap in
                        var newArr:[String] = []
                        if let val = snap.value as? [String] {
                            newArr = val
                            var uparr:[String] = []
                            for i in 0..<newArr.count {
                                if !newArr[i].contains("\(strongSelf.initKit.tDAppId)Æ\(strongSelf.initKit.name)") {
                                    uparr.append(newArr[i])
                                }
                            }
                            ref.setValue(uparr)
                            tick+=1
                            if tick == arr.count {
                                completion(nil)
                            }
                        } else {
                            var uparr:[String] = []
                            for i in 0..<newArr.count {
                                if !newArr[i].contains("\(strongSelf.initKit.tDAppId)Æ\(strongSelf.initKit.name)") {
                                    uparr.append(newArr[i])
                                }
                            }
                            ref.setValue(uparr)
                            tick+=1
                            if tick == arr.count {
                                completion(nil)
                            }
                        }
                    })
                case .failure(let err):
                completion(err)
                return
                }
            })
        }
    }
    
    func clearVideos(fromKit: MerchKitData, completion: @escaping ((Error?) -> Void)) {
        guard let arr = fromKit.videos else {
            completion(nil)
            return
        }
        var tick = 0
        for dbid in arr {
            let word = dbid.split(separator: "Æ")
            let id = String(word[0])
            DatabaseManager.shared.findVideoById(videoid: id, completion: {[weak self] result in
                guard let strongSelf = self else {return}
                switch result {
                case .success(let video):
                    switch video {
                    case is YouTubeData:
                        let youtube = video as! YouTubeData
                        let cat = "\(youtube.type)--\(youtube.title)--\(youtube.dateIA)--\(youtube.timeIA)--\(youtube.toneDeafAppId)"
                        let ref = Database.database().reference().child("Music Content").child("Videos").child(cat).child("Merch")
                        ref.observeSingleEvent(of: .value, with: { snap in
                            var newArr:[String] = []
                            if let val = snap.value as? [String] {
                                newArr = val
                                var uparr:[String] = []
                                for i in 0..<newArr.count {
                                    if !newArr[i].contains("\(fromKit.tDAppId)Æ\(fromKit.name)") {
                                        uparr.append(newArr[i])
                                    }
                                }
                                ref.setValue(uparr)
                                tick+=1
                                if tick == arr.count {
                                    completion(nil)
                                }
                            } else {
                                var uparr:[String] = []
                                for i in 0..<newArr.count {
                                    if !newArr[i].contains("\(fromKit.tDAppId)Æ\(fromKit.name)") {
                                        uparr.append(newArr[i])
                                    }
                                }
                                ref.setValue(uparr)
                                tick+=1
                                if tick == arr.count {
                                    completion(nil)
                                }
                            }
                        })
                    default:
                        print("gfrderss")
                    }
                case .failure(let err):
                completion(err)
                return
                }
            })
        }
    }
    
    func clearBeats(fromKit: MerchKitData, completion: @escaping ((Error?) -> Void)) {
        guard let arr = fromKit.beats else {
            completion(nil)
            return
        }
        var tick = 0
        for dbid in arr {
            let word = dbid.split(separator: "Æ")
            let id = String(word[0])
            DatabaseManager.shared.findBeatById(beatId: id, completion: {[weak self] result in
                guard let strongSelf = self else {return}
                switch result {
                case .success(let beat):
                    let ref = Database.database().reference().child("Beats").child("Instrumentals").child(beat.priceType).child(beat.beatID).child("Merch")
                    ref.observeSingleEvent(of: .value, with: { snap in
                        var newArr:[String] = []
                        if let val = snap.value as? [String] {
                            newArr = val
                            var uparr:[String] = []
                            for i in 0..<newArr.count {
                                if !newArr[i].contains("\(fromKit.tDAppId)Æ\(fromKit.name)") {
                                    uparr.append(newArr[i])
                                }
                            }
                            ref.setValue(uparr)
                            tick+=1
                            if tick == arr.count {
                                completion(nil)
                            }
                        } else {
                            var uparr:[String] = []
                            for i in 0..<newArr.count {
                                if !newArr[i].contains("\(fromKit.tDAppId)Æ\(fromKit.name)") {
                                    uparr.append(newArr[i])
                                }
                            }
                            ref.setValue(uparr)
                            tick+=1
                            if tick == arr.count {
                                completion(nil)
                            }
                        }
                    })
                case .failure(let err):
                completion(err)
                return
                }
            })
        }
    }
    
    func changeMerchArray(fromKit: MerchKitData, tokit:MerchKitData, completion: @escaping ((Error?) -> Void)) {
        let ref = Database.database().reference().child("Merch").child("\(fromKit.tDAppId)Æ\(fromKit.name)")
        let ref2 = Database.database().reference().child("Merch").child("\(tokit.tDAppId)Æ\(tokit.name)")
        ref.observeSingleEvent(of: .value, with: { snap in
            var newArr:[String] = []
            if let val = snap.value {
                ref2.setValue(val)
                ref2.child("Name").setValue(tokit.name)
                ref.removeValue()
                completion(nil)
            } else {
                completion(KitEditorError.nameUpdateError("Initial Merch snapshot is null"))
            }
        })
        
    }
    
    func changeAllContentArray(fromKit: MerchKitData, toKit:MerchKitData, completion: @escaping ((Error?) -> Void)) {
        let ref = Database.database().reference().child("All Content IDs")
        ref.observeSingleEvent(of: .value, with: { snap in
            var newArr:[String] = []
            if let val = snap.value as? [String] {
                newArr = val
                var uparr:[String] = []
                for i in 0..<newArr.count {
                    if !newArr[i].contains("\(fromKit.tDAppId)Æ\(fromKit.name)") {
                        uparr.append(newArr[i])
                    }
                }
                uparr.append("\(toKit.tDAppId)Æ\(toKit.name)")
                ref.setValue(uparr)
                    completion(nil)
            } else {
                var uparr:[String] = []
                for i in 0..<newArr.count {
                    if !newArr[i].contains("\(fromKit.tDAppId)Æ\(fromKit.name)") {
                        uparr.append(newArr[i])
                    }
                }
                uparr.append("\(toKit.tDAppId)Æ\(toKit.name)")
                ref.setValue(uparr)
                    completion(nil)
            }
        })
        
    }
    
    
    func updateArtist(fromKit: MerchKitData, toKit: MerchKitData, completion: @escaping ((Error?) -> Void)) {
        guard let arr = toKit.artists else {
            completion(nil)
            return
        }
        var tick = 0
        for dbid in arr {
            let word = dbid.split(separator: "Æ")
            let id = String(word[0])
            DatabaseManager.shared.fetchArtistData(artist: id, completion: {[weak self] artist in
                guard let strongSelf = self else {return}
                let cat = "\(artist.name!)--\(artist.dateRegisteredToApp!)--\(artist.timeRegisteredToApp!)--\(artist.toneDeafAppId)"
                let ref = Database.database().reference().child("Registered Artists").child(cat).child("Merch")
                ref.observeSingleEvent(of: .value, with: { snap in
                    var newArr:[String] = []
                    if let val = snap.value as? [String] {
                        newArr = val
                        var uparr:[String] = []
                        for i in 0..<newArr.count {
                            if !newArr[i].contains("\(fromKit.tDAppId)Æ\(fromKit.name)") {
                                uparr.append(newArr[i])
                            }
                        }
                        uparr.append("\(toKit.tDAppId)Æ\(toKit.name)")
                        ref.setValue(uparr)
                        tick+=1
                        if tick == arr.count {
                            completion(nil)
                        }
                    } else {
                        var uparr:[String] = ["\(toKit.tDAppId)Æ\(toKit.name)"]
                        for i in 0..<newArr.count {
                            if !newArr[i].contains("\(fromKit.tDAppId)Æ\(fromKit.name)") {
                                uparr.append(newArr[i])
                            }
                        }
                        ref.setValue(uparr)
                        tick+=1
                        if tick == arr.count {
                            completion(nil)
                        }
                    }
                })
            })
        }
    }
    
    func updateProducers(fromKit: MerchKitData, toKit: MerchKitData, completion: @escaping ((Error?) -> Void)) {
        guard let arr = toKit.producers else {
            completion(nil)
            return
        }
        var tick = 0
        for dbid in arr {
            let word = dbid.split(separator: "Æ")
            let id = String(word[0])
//            DatabaseManager.shared.fetchPersonData(person: id, completion: {[weak self] producer in
//                guard let strongSelf = self else {return}
//                let cat = "\(producer.name!)--\(producer.dateRegisteredToApp!)--\(producer.timeRegisteredToApp!)--\(producer.toneDeafAppId)"
//                let ref = Database.database().reference().child("Registered Producers").child(cat).child("Merch")
//                ref.observeSingleEvent(of: .value, with: { snap in
//                    var newArr:[String] = []
//                    if let val = snap.value as? [String] {
//                        newArr = val
//                        var uparr:[String] = []
//                        for i in 0..<newArr.count {
//                            if !newArr[i].contains("\(fromKit.tDAppId)Æ\(fromKit.name)") {
//                                uparr.append(newArr[i])
//                            }
//                        }
//                        uparr.append("\(toKit.tDAppId)Æ\(toKit.name)")
//                        ref.setValue(uparr)
//                        tick+=1
//                        if tick == arr.count {
//                            completion(nil)
//                        }
//                    } else {
//                        var uparr:[String] = []
//                        for i in 0..<newArr.count {
//                            if !newArr[i].contains("\(fromKit.tDAppId)Æ\(fromKit.name)") {
//                                uparr.append(newArr[i])
//                            }
//                        }
//                        uparr.append("\(toKit.tDAppId)Æ\(toKit.name)")
//                        ref.setValue(uparr)
//                        tick+=1
//                        if tick == arr.count {
//                            completion(nil)
//                        }
//                    }
//                })
//            })
        }
    }
    
    func updateSongs(fromKit: MerchKitData, toKit: MerchKitData, completion: @escaping ((Error?) -> Void)) {
        guard let arr = toKit.songs else {
            completion(nil)
            return
        }
        var tick = 0
        for dbid in arr {
            let word = dbid.split(separator: "Æ")
            let id = String(word[0])
            DatabaseManager.shared.findSongById(songId: id, completion: {[weak self] result in
                guard let strongSelf = self else {return}
                switch result {
                case .success(let song):
                    var songart:[String] = []
                    for art in song.songArtist {
                        let word = art.split(separator: "Æ")
                        let id = word[0]
                        songart.append(String(id))
                    }
                    let cat = "\(songContentTag)--\(song.name)--\(songart.joined(separator: ", "))--\(song.toneDeafAppId)"
                    let ref = Database.database().reference().child("Music Content").child("Songs").child(cat).child("REQUIRED").child("Merch")
                    ref.observeSingleEvent(of: .value, with: { snap in
                        var newArr:[String] = []
                        if let val = snap.value as? [String] {
                            newArr = val
                            var uparr:[String] = []
                            for i in 0..<newArr.count {
                                if !newArr[i].contains("\(fromKit.tDAppId)Æ\(fromKit.name)") {
                                    uparr.append(newArr[i])
                                }
                            }
                            uparr.append("\(toKit.tDAppId)Æ\(toKit.name)")
                            ref.setValue(uparr)
                            tick+=1
                            if tick == arr.count {
                                completion(nil)
                            }
                        } else {
                            var uparr:[String] = []
                            for i in 0..<newArr.count {
                                if !newArr[i].contains("\(fromKit.tDAppId)Æ\(fromKit.name)") {
                                    uparr.append(newArr[i])
                                }
                            }
                            uparr.append("\(toKit.tDAppId)Æ\(toKit.name)")
                            ref.setValue(uparr)
                            tick+=1
                            if tick == arr.count {
                                completion(nil)
                            }
                        }
                    })
                case .failure(let err):
                completion(err)
                return
                }
            })
        }
    }
    
    func updateAlbums(fromKit: MerchKitData, toKit: MerchKitData, completion: @escaping ((Error?) -> Void)) {
        guard let arr = toKit.albums else {
            completion(nil)
            return
        }
        var tick = 0
        for dbid in arr {
            let word = dbid.split(separator: "Æ")
            let id = String(word[0])
            DatabaseManager.shared.findAlbumById(albumId: id, completion: {[weak self] result in
                guard let strongSelf = self else {return}
                switch result {
                case .success(let album):
                    var songart:[String] = []
                    for art in album.mainArtist {
                        let word = art.split(separator: "Æ")
                        let id = word[0]
                        songart.append(String(id))
                    }
                    let cat = "\(albumContentTag)--\(album.name)--\(songart.joined(separator: ", "))--\(album.toneDeafAppId)"
                    let ref = Database.database().reference().child("Music Content").child("Albums").child(cat).child("REQUIRED").child("Merch")
                    ref.observeSingleEvent(of: .value, with: { snap in
                        var newArr:[String] = []
                        if let val = snap.value as? [String] {
                            newArr = val
                            var uparr:[String] = []
                            for i in 0..<newArr.count {
                                if !newArr[i].contains("\(fromKit.tDAppId)Æ\(fromKit.name)") {
                                    uparr.append(newArr[i])
                                }
                            }
                            uparr.append("\(toKit.tDAppId)Æ\(toKit.name)")
                            ref.setValue(uparr)
                            tick+=1
                            if tick == arr.count {
                                completion(nil)
                            }
                        } else {
                            var uparr:[String] = []
                            for i in 0..<newArr.count {
                                if !newArr[i].contains("\(fromKit.tDAppId)Æ\(fromKit.name)") {
                                    uparr.append(newArr[i])
                                }
                            }
                            uparr.append("\(toKit.tDAppId)Æ\(toKit.name)")
                            ref.setValue(uparr)
                            tick+=1
                            if tick == arr.count {
                                completion(nil)
                            }
                        }
                    })
                case .failure(let err):
                completion(err)
                return
                }
            })
        }
    }
    
    func updateVideos(fromKit: MerchKitData, toKit: MerchKitData, completion: @escaping ((Error?) -> Void)) {
        guard let arr = toKit.videos else {
            completion(nil)
            return
        }
        var tick = 0
        for dbid in arr {
            let word = dbid.split(separator: "Æ")
            let id = String(word[0])
            DatabaseManager.shared.findVideoById(videoid: id, completion: {[weak self] result in
                guard let strongSelf = self else {return}
                switch result {
                case .success(let video):
                    switch video {
                    case is YouTubeData:
                        let youtube = video as! YouTubeData
                        let cat = "\(youtube.type)--\(youtube.title)--\(youtube.dateIA)--\(youtube.timeIA)--\(youtube.toneDeafAppId)"
                        let ref = Database.database().reference().child("Music Content").child("Videos").child(cat).child("Merch")
                        ref.observeSingleEvent(of: .value, with: { snap in
                            var newArr:[String] = []
                            if let val = snap.value as? [String] {
                                newArr = val
                                var uparr:[String] = []
                                for i in 0..<newArr.count {
                                    if !newArr[i].contains("\(fromKit.tDAppId)Æ\(fromKit.name)") {
                                        uparr.append(newArr[i])
                                    }
                                }
                                uparr.append("\(toKit.tDAppId)Æ\(toKit.name)")
                                ref.setValue(uparr)
                                tick+=1
                                if tick == arr.count {
                                    completion(nil)
                                }
                            } else {
                                var uparr:[String] = []
                                for i in 0..<newArr.count {
                                    if !newArr[i].contains("\(fromKit.tDAppId)Æ\(fromKit.name)") {
                                        uparr.append(newArr[i])
                                    }
                                }
                                uparr.append("\(toKit.tDAppId)Æ\(toKit.name)")
                                ref.setValue(uparr)
                                tick+=1
                                if tick == arr.count {
                                    completion(nil)
                                }
                            }
                        })
                    default:
                        print("gfrderss")
                    }
                case .failure(let err):
                completion(err)
                return
                }
            })
        }
    }
    
    func updateBeats(fromKit: MerchKitData, toKit: MerchKitData, completion: @escaping ((Error?) -> Void)) {
        guard let arr = toKit.beats else {
            completion(nil)
            return
        }
        var tick = 0
        for dbid in arr {
            let word = dbid.split(separator: "Æ")
            let id = String(word[0])
            DatabaseManager.shared.findBeatById(beatId: id, completion: {[weak self] result in
                guard let strongSelf = self else {return}
                switch result {
                case .success(let beat):
                    let ref = Database.database().reference().child("Beats").child("Instrumentals").child(beat.priceType).child(beat.beatID).child("Merch")
                    ref.observeSingleEvent(of: .value, with: { snap in
                        var newArr:[String] = []
                        if let val = snap.value as? [String] {
                            newArr = val
                            var uparr:[String] = []
                            for i in 0..<newArr.count {
                                if !newArr[i].contains("\(fromKit.tDAppId)Æ\(fromKit.name)") {
                                    uparr.append(newArr[i])
                                }
                            }
                            uparr.append("\(toKit.tDAppId)Æ\(toKit.name)")
                            ref.setValue(uparr)
                            tick+=1
                            if tick == arr.count {
                                completion(nil)
                            }
                        } else {
                            var uparr:[String] = []
                            for i in 0..<newArr.count {
                                if !newArr[i].contains("\(fromKit.tDAppId)Æ\(fromKit.name)") {
                                    uparr.append(newArr[i])
                                }
                            }
                            uparr.append("\(toKit.tDAppId)Æ\(toKit.name)")
                            ref.setValue(uparr)
                            tick+=1
                            if tick == arr.count {
                                completion(nil)
                            }
                        }
                    })
                case .failure(let err):
                completion(err)
                return
                }
            })
        }
    }
    
    
    
    
    
    func processSubCat(initialKit: MerchKitData, currentKit: MerchKitData, completion: @escaping ((Error?) -> Void)) {
        initKit = initialKit
        currKit = currentKit
        var errors:[Error] = []
        Database.database().reference().child("Merch").child("\(currKit.tDAppId)Æ\(currKit.name)").child("Sub Category").setValue(currKit.subcategory)
        completion(nil)
    }
    
    
    
    
    
    func processDescription(initialKit: MerchKitData, currentKit: MerchKitData, completion: @escaping ((Error?) -> Void)) {
        initKit = initialKit
        currKit = currentKit
        var errors:[Error] = []
        Database.database().reference().child("Merch").child("\(currKit.tDAppId)Æ\(currKit.name)").child("Description").setValue(currKit.description)
        completion(nil)
    }
    
    func processQuantity(initialKit: MerchKitData, currentKit: MerchKitData, completion: @escaping ((Error?) -> Void)) {
        initKit = initialKit
        currKit = currentKit
        var errors:[Error] = []
        Database.database().reference().child("Merch").child("\(currKit.tDAppId)Æ\(currKit.name)").child("Quantity").setValue(currKit.quantity)
        completion(nil)
    }
    
    func processRetail(initialKit: MerchKitData, currentKit: MerchKitData, completion: @escaping ((Error?) -> Void)) {
        initKit = initialKit
        currKit = currentKit
        var errors:[Error] = []
        Database.database().reference().child("Merch").child("\(currKit.tDAppId)Æ\(currKit.name)").child("Retail Price").setValue(currKit.retailPrice)
        completion(nil)
    }
    
    func processSale(initialKit: MerchKitData, currentKit: MerchKitData, completion: @escaping ((Error?) -> Void)) {
        initKit = initialKit
        currKit = currentKit
        var errors:[Error] = []
        Database.database().reference().child("Merch").child("\(currKit.tDAppId)Æ\(currKit.name)").child("Sale Price").setValue(currKit.salePrice)
        completion(nil)
    }
    
    
    func processImage(initialKit: MerchKitData, currentKit: MerchKitData, images: [UIImage], completion: @escaping ((Error?, Int?) -> Void)) {
        initKit = initialKit
        currKit = currentKit
        initImages = []
        currImages = images
        getDBURLs(completion: {[weak self] err in
            guard let strongSelf = self else {return}
            if let error = err {
                strongSelf.cancelUpdate(completion: {_ in
                    completion(error, nil)
                    return
                })
            } else {
                strongSelf.setInitialImagesArray(completion: { err in
                    if let error = err {
                        strongSelf.cancelUpdate(completion: {_ in
                            completion(error, nil)
                            return
                        })
                    } else {
                        strongSelf.storeImages(kit: currentKit, images: strongSelf.currImages, imageURLs: "curr", completion: { err in
                            if let error = err {
                                strongSelf.cancelUpdate(completion: {_ in
                                    completion(error, nil)
                                    return
                                })
                            } else {
                                var array:[String]!
                                
                                array = strongSelf.currImageDBURLs
                                Database.database().reference().child("Merch").child("\(currentKit.tDAppId)Æ\(currentKit.name)").child("Images").setValue(array)
                                completion(nil,nil)
                            }
                        })
                    }
                })
            }
        })
    }
    
    func getDBURLs(completion: @escaping ((Error?) -> Void)) {
            Database.database().reference().child("Merch").child("\(initKit.tDAppId)Æ\(initKit.name)").child("Images").observeSingleEvent(of: .value, with: {[weak self] snap in
                guard let strongSelf = self else {return}
                if let arr = snap.value as? [String] {
                    strongSelf.initImageDBURLs = arr
                    completion(nil)
                } else {
                    completion(KitEditorError.imageUpdateError("Image URLs not found in Database."))
                    return
                }
            })
    }
    
    func setInitialImagesArray(completion: @escaping ((Error?) -> Void)) {
        Storage.storage().reference().child("Merch").child("Kits").child("\(initKit.tDAppId)").child("Images").listAll(completion: {[weak self] listResult, err in
            guard let strongSelf = self else {return}
            if let error = err {
                completion(error)
                return
            } else {
                var tick = 0
                
                    guard let listResult = listResult else {
                        return
                    }
                for file in listResult.items {
                    
                    file.downloadURL(completion: { url,err in
                        if let error = err {
                            completion(error)
                            return
                        } else {
                            guard let url = url else {
                                return
                            }
                            url.getImage(completion: { newimg in
                                tick+=1
                                strongSelf.initImages.append(newimg)
                                file.delete(completion: { err in
                                    if let error = err {
                                        completion(error)
                                        return
                                    }
                                })
                                if tick == listResult.items.count {
                                    completion(nil)
                                }
                            })
                        }
                    })
                }
            }
        })
    }
    
    func storeImages(kit: MerchKitData, images:[UIImage], imageURLs:String, completion: @escaping ((Error?) -> Void)) {
        var dataarr:[Data] = []
        for image in images {
            guard let data = image.pngData() else {return}
            dataarr.append(data)
        }
//        StorageManager.shared.uploadImage(kit: dataarr, fileName: "\(kit.tDAppId)", completion: {[weak self] result in
//
//            guard let strongSelf = self else {return}
//            switch result {
//            case .success(let url):
//                switch imageURLs {
//                case "curr":
//                    strongSelf.currImageDBURLs = url
//                default:
//                    strongSelf.initImageDBURLs = url
//                }
//                completion(nil)
//            case .failure(let err):
//                completion(err)
//            }
//        })
    }
    
    func cancelUpdate(completion: @escaping ((Error?) -> Void)) {
        // Name
        revertName()
        // Sub Category
        Database.database().reference().child("Merch").child("\(initKit.tDAppId)Æ\(initKit.name)").child("Sub Category").setValue(initKit.subcategory)
        // Description
        Database.database().reference().child("Merch").child("\(initKit.tDAppId)Æ\(initKit.name)").child("Description").setValue(initKit.description)
        // Quantity
        Database.database().reference().child("Merch").child("\(initKit.tDAppId)Æ\(initKit.name)").child("Quantity").setValue(initKit.quantity)
        // Retail Price
        Database.database().reference().child("Merch").child("\(initKit.tDAppId)Æ\(initKit.name)").child("Retail Price").setValue(initKit.retailPrice)
        // Sale Price
        Database.database().reference().child("Merch").child("\(initKit.tDAppId)Æ\(initKit.name)").child("Sale Price").setValue(initKit.salePrice)
        // Images
        Database.database().reference().child("Merch").child("\(initKit.tDAppId)Æ\(initKit.name)").child("Images").setValue(initImageDBURLs)
        Storage.storage().reference().child("Merch").child("Kits").child("\(initKit.tDAppId)").child("Images").delete(completion: {[weak self] err in
            guard let strongSelf = self else {return}
            strongSelf.storeImages(kit: strongSelf.initKit, images: strongSelf.initImages, imageURLs: "init", completion: {_ in
            })
        })
    }
    
    func revertName() {
        var uc1 = false
        var uc2 = false
        var uc3 = false
        var uc4 = false
        var uc5 = false
        var uc6 = false
        
        var uc7 = false
        var uc8 = false
        var uc9 = false
        var uc10 = false
        var uc11 = false
        var uc12 = false
        var uc13 = false
        var uc14 = false
        
        let bqueue = DispatchQueue(label: "myhhtdrfnhvhhvj32vkheditingQkitssssseue")
        let bgroup = DispatchGroup()
        let barray = [0,1,2,3,4,5]

        for i in barray {
            bgroup.enter()
            bqueue.async { [weak self] in
                guard let strongSelf = self else {return}
                switch i {
                case 0:
                    strongSelf.clearArtist(fromKit: strongSelf.currKit, completion: {err in
                    if let error = err {
                        fatalError()
                        uc1 = false
                    } else {
                        uc1 = true
                        print("name done \(i)")
                    }
                    bgroup.leave()
                })
                case 1:
                    strongSelf.clearProducers(fromKit: strongSelf.currKit, completion: {err in
                    if let error = err {
                        fatalError()
                        uc2 = false
                    } else {
                        uc2 = true
                        print("name done \(i)")
                    }
                    bgroup.leave()
                })
                case 2:
                    strongSelf.clearSongs(fromKit: strongSelf.currKit, completion: {err in
                        if let error = err {
                            fatalError()
                            uc3 = false
                        } else {
                            uc3 = true
                            print("name done \(i)")
                        }
                        bgroup.leave()
                    })
                case 3:
                    strongSelf.clearAlbums(fromKit: strongSelf.currKit, completion: {err in
                        if let error = err {
                            fatalError()
                            uc4 = false
                        } else {
                            uc4 = true
                            print("name done \(i)")
                        }
                        bgroup.leave()
                    })
                case 4:
                    strongSelf.clearVideos(fromKit: strongSelf.currKit, completion: {err in
                        if let error = err {
                            fatalError()
                            uc5 = false
                        } else {
                            uc5 = true
                            print("name done \(i)")
                        }
                        bgroup.leave()
                    })
                case 5:
                    strongSelf.clearBeats(fromKit: strongSelf.currKit, completion: {err in
                        if let error = err {
                            fatalError()
                            uc6 = false
                        } else {
                            uc6 = true
                            print("name done \(i)")
                        }
                        bgroup.leave()
                    })
                default:
                    print("Edit Kit Name error")
                }
            }
        }
        
        bgroup.notify(queue: DispatchQueue.main) { [weak self] in
            guard let strongSelf = self else {return}
            if uc1 == false || uc2 == false || uc3 == false || uc4 == false || uc5 == false || uc6 == false {
                fatalError()
                return
            } else {
                let queue = DispatchQueue(label: "myhhtdrfnhvhhvjvkheditingQkitssssseue")
                let group = DispatchGroup()
                let array = [0,1,2,3,4,5,6,7]

                for i in array {
                    group.enter()
                    queue.async { [weak self] in
                        guard let strongSelf = self else {return}
                        switch i {
                        case 0:
                            strongSelf.updateArtist(fromKit: strongSelf.currKit, toKit: strongSelf.initKit, completion: {err in
                            if let error = err {
                                fatalError()
                                uc7 = false
                            } else {
                                uc7 = true
                                print("name done \(i)")
                            }
                            group.leave()
                        })
                        case 1:
                            strongSelf.changeMerchArray(fromKit: strongSelf.currKit, tokit: strongSelf.initKit, completion: {err in
                                if let error = err {
                                    fatalError()
                                    uc8 = false
                                } else {
                                    uc8 = true
                                    print("name done \(i)")
                                }
                                group.leave()
                            })
                        case 2:
                            strongSelf.updateProducers(fromKit: strongSelf.currKit, toKit: strongSelf.initKit, completion: {err in
                                if let error = err {
                                    fatalError()
                                    uc9 = false
                                } else {
                                    uc9 = true
                                    print("name done \(i)")
                                }
                                group.leave()
                            })
                        case 3:
                            strongSelf.updateSongs(fromKit: strongSelf.currKit, toKit: strongSelf.initKit, completion: {err in
                                if let error = err {
                                    fatalError()
                                    uc10 = false
                                } else {
                                    uc10 = true
                                    print("name done \(i)")
                                }
                                group.leave()
                            })
                        case 4:
                            strongSelf.updateAlbums(fromKit: strongSelf.currKit, toKit: strongSelf.initKit, completion: {err in
                                if let error = err {
                                    fatalError()
                                    uc11 = false
                                } else {
                                    uc11 = true
                                    print("name done \(i)")
                                }
                                group.leave()
                            })
                        case 5:
                            strongSelf.updateVideos(fromKit: strongSelf.currKit, toKit: strongSelf.initKit, completion: {err in
                                if let error = err {
                                    fatalError()
                                    uc12 = false
                                } else {
                                    uc12 = true
                                    print("name done \(i)")
                                }
                                group.leave()
                            })
                        case 6:
                            strongSelf.updateBeats(fromKit: strongSelf.currKit, toKit: strongSelf.initKit, completion: {err in
                                if let error = err {
                                    fatalError()
                                    uc13 = false
                                } else {
                                    uc13 = true
                                    print("name done \(i)")
                                }
                                group.leave()
                            })
                        case 7:
                            strongSelf.changeAllContentArray(fromKit: strongSelf.currKit, toKit: strongSelf.initKit, completion: {err in
                                if let error = err {
                                    fatalError()
                                    uc14 = false
                                } else {
                                    uc14 = true
                                    print("name done \(i)")
                                }
                                group.leave()
                            })
                        default:
                            print("Edit Kit Name error")
                        }
                    }
                }
                
                group.notify(queue: DispatchQueue.main) { [weak self] in
                    guard let strongSelf = self else {return}
                    if uc7 == false || uc8 == false || uc9 == false || uc10 == false || uc11 == false || uc12 == false || uc13 == false || uc14 == false {
                        fatalError()
                        return
                    } else {
                        print("📗 Kit name reverted successfully.")
                        return
                    }
                }
            }
        }
    }
    
}

enum KitEditorError: Error {
    case imageUpdateError(String)
    case nameUpdateError(String)
}

