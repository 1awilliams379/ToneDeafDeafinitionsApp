//
//  EditSongHelper.swift
//  ToneDeafDeafinitionsApp
//
//  Created by Tone Deaf on 8/8/22.
//  Copyright © 2022 GITEM Solutions. All rights reserved.
//

import Foundation
import FirebaseDatabase
import FirebaseStorage

class EditSongHelper {
    static let shared = EditSongHelper()
    
    var initSong:SongData!
    var initStatusDict:NSDictionary!
    var initRef:DatabaseReference!
    var initURLDict:NSDictionary!
    //Initial Images
    var initImage:UIImage!
    var initImageDBURL:String!
    //Initial Preview
    var initPreview:URL!
    var initPreviewDBURL:String!
    
    var currSong:SongData!
    var currStatusDict:NSDictionary!
    var currRef:DatabaseReference!
    var currURLDict:NSDictionary!
    //Current Images
    var currImage:UIImage!
    var currImageDBURL:String!
    //Current Preview
    var currPreview:URL!
    var currPreviewDBURL:String!
    
    //MARK: - Image
    func processImage(initialSong: SongData, currentSong: SongData, image: UIImage?, completion: @escaping ((Error?) -> Void)) {
        initSong = initialSong
        currSong = currentSong
        currImage = image
        guard currentSong.manualImageURL != initialSong.manualImageURL else {
            completion(nil)
            return
        }
        
        getDBURLs(completion: {[weak self] err in
            guard let strongSelf = self else {return}
            if let error = err {
                completion(error)
                return
            } else {
                
                strongSelf.getInitialImageFromStorage(completion: { err in
                    if let error = err {
                        completion(error)
                        return
                    } else {
                        guard strongSelf.currImage != nil else {
                            Database.database().reference().child("Music Content").child("Songs").child("\(songContentTag)--\(strongSelf.currSong.name)--\(strongSelf.currSong.toneDeafAppId)").child("REQUIRED").child("Manual Image URL").removeValue()
                            completion(nil)
                            return
                        }
                        
                        strongSelf.storeImage(song: strongSelf.currSong, image: strongSelf.currImage, imageURL: "curr", completion: { err in
                            if let error = err {
                                completion(error)
                                return
                            } else {
                                var array:String!
                                
                                array = strongSelf.currImageDBURL
                                Database.database().reference().child("Music Content").child("Songs").child("\(songContentTag)--\(strongSelf.currSong.name)--\(strongSelf.currSong.toneDeafAppId)").child("REQUIRED").child("Manual Image URL").setValue(array)
                                completion(nil)
                            }
                        })
                    }
                })
            }
        })
    }
    
    fileprivate func getDBURLs(completion: @escaping ((Error?) -> Void)) {
        Database.database().reference().child("Music Content").child("Songs").child("\(songContentTag)--\(currSong.name)--\(currSong.toneDeafAppId)").child("REQUIRED").child("Manual Image URL").observeSingleEvent(of: .value, with: {[weak self] snap in
                guard let strongSelf = self else {return}
                if let arr = snap.value as? String {
                    strongSelf.initImageDBURL = arr
                    completion(nil)
                } else {
                    completion(nil)
                    return
                }
            })
    }
    
    fileprivate func getInitialImageFromStorage(completion: @escaping ((Error?) -> Void)) {
        Storage.storage().reference().child("Image Defaults").child("Manual Songs").child("\(currSong.toneDeafAppId)").child("Images").listAll(completion: {[weak self] listResult, err in
            guard let strongSelf = self else {return}
            
            if let error = err {
                completion(error)
                return
            } else {
                guard let listResult = listResult else {
                    return
                }
                
                var tick = 0
                guard listResult.items.count != 0 else {
                    completion(nil)
                    return
                }
                for file in listResult.items {
                    
                    file.downloadURL(completion: { url,err in
                        if let error = err {
                            completion(error)
                            return
                        } else {
                            guard let url = url else {
                                completion(SongEditorError.imageUpdateError("Storage download url error"))
                                return
                            }
                            url.getImage(completion: { newimg in
                                tick+=1
                                strongSelf.initImage = (newimg)
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
    
    fileprivate func removeManualImageFromStorage(completion: @escaping ((Error?) -> Void)) {
        Storage.storage().reference().child("Image Defaults").child("Manual Songs").child("\(currSong.toneDeafAppId)").child("Images").listAll(completion: {[weak self] listResult, err in
            guard let strongSelf = self else {return}
            
            if let error = err {
                completion(error)
                return
            } else {
                guard let listResult = listResult else {
                    return
                }
//                print(listResult.items)
                
                var tick = 0
                guard listResult.items.count != 0 else {
                    completion(nil)
                    return
                }
                for file in listResult.items {
                    
                    file.delete(completion: { err in
                        if let error = err {
                            completion(error)
                            return
                        }
                        else {
                            tick+=1
                            if tick == listResult.items.count {
                                Database.database().reference().child("Music Content").child("Songs").child("\(songContentTag)--\(strongSelf.currSong.name)--\(strongSelf.currSong.toneDeafAppId)").child("REQUIRED").child("Manual Image URL").removeValue()
                                completion(nil)
                                return
                            }
                        }
                        
                    })
                }
            }
        })
    }
    
    fileprivate func storeImage(song: SongData, image:UIImage, imageURL:String, completion: @escaping ((Error?) -> Void)) {
        
        guard let data = image.pngData() else {
            completion(SongEditorError.imageUpdateError("Error converting image to png"))
            return}
        StorageManager.shared.uploadImage(song: data, fileName: "\(currSong.toneDeafAppId)", completion: {[weak self] result in
            
            guard let strongSelf = self else {return}
            switch result {
            case .success(let url):
                switch imageURL {
                case "curr":
                    strongSelf.currImageDBURL = url
                default:
                    strongSelf.initImageDBURL = url
                }
                completion(nil)
            case .failure(let err):
                completion(err)
            }
        })
    }
    
    //MARK: - Preview
    func processPreview(initialSong: SongData, currentSong: SongData, audio: URL?, completion: @escaping ((Error?) -> Void)) {
        initSong = initialSong
        currSong = currentSong
        currPreview = audio
        guard currentSong.manualPreviewURL != initialSong.manualPreviewURL else {
            completion(nil)
            return
        }
        
        getPreviewDBURLs(completion: {[weak self] err in
            guard let strongSelf = self else {return}
            if let error = err {
                completion(error)
                return
            } else {
                
                strongSelf.getInitialPreviewFromStorage(completion: { err in
                    if let error = err {
                        completion(error)
                        return
                    } else {
                        guard strongSelf.currPreview != nil else {
                            Database.database().reference().child("Music Content").child("Songs").child("\(songContentTag)--\(strongSelf.currSong.name)--\(strongSelf.currSong.toneDeafAppId)").child("REQUIRED").child("Manual Preview URL").removeValue()
                            completion(nil)
                            return
                        }
                        
                        strongSelf.storePreview(song: strongSelf.currSong, preview: strongSelf.currPreview, previewURL: "curr", completion: { err in
                            if let error = err {
                                completion(error)
                                return
                            } else {
                                var array:String!
                                
                                array = strongSelf.currPreviewDBURL
                                Database.database().reference().child("Music Content").child("Songs").child("\(songContentTag)--\(strongSelf.currSong.name)--\(strongSelf.currSong.toneDeafAppId)").child("REQUIRED").child("Manual Preview URL").setValue(array)
                                completion(nil)
                            }
                        })
                    }
                })
            }
        })
    }
    
    fileprivate func getPreviewDBURLs(completion: @escaping ((Error?) -> Void)) {
        Database.database().reference().child("Music Content").child("Songs").child("\(songContentTag)--\(currSong.name)--\(currSong.toneDeafAppId)").child("REQUIRED").child("Manual Preview URL").observeSingleEvent(of: .value, with: {[weak self] snap in
                guard let strongSelf = self else {return}
                if let arr = snap.value as? String {
                    strongSelf.initPreviewDBURL = arr
                    completion(nil)
                } else {
                    completion(nil)
                    return
                }
            })
    }
    
    fileprivate func getInitialPreviewFromStorage(completion: @escaping ((Error?) -> Void)) {
        Storage.storage().reference().child("Audio Defaults").child("Manual Songs").child("\(currSong.toneDeafAppId)").child("Previews").listAll(completion: {[weak self] listResult, err in
            guard let strongSelf = self else {return}
            
            if let error = err {
                completion(error)
                return
            } else {
                guard let listResult = listResult else {
                    return
                }
                
                var tick = 0
                guard listResult.items.count != 0 else {
                    completion(nil)
                    return
                }
                for file in listResult.items {
                    
                    file.downloadURL(completion: { url,err in
                        if let error = err {
                            completion(error)
                            return
                        } else {
                            guard let url = url else {
                                completion(SongEditorError.previewUpdateError("Storage download url error"))
                                return
                            }
                            tick+=1
                            strongSelf.initPreview = url
                            file.delete(completion: { err in
                                if let error = err {
                                    completion(error)
                                    return
                                }
                            })
                            if tick == listResult.items.count {
                                completion(nil)
                            }
                        }
                    })
                }
            }
        })
    }
    
    fileprivate func removeManualPreviewFromStorage(completion: @escaping ((Error?) -> Void)) {
        Storage.storage().reference().child("Audio Defaults").child("Manual Songs").child("\(currSong.toneDeafAppId)").child("Previews").listAll(completion: {[weak self] listResult, err in
            guard let strongSelf = self else {return}
            
            if let error = err {
                completion(error)
                return
            } else {
                guard let listResult = listResult else {
                    return
                }
//                print(listResult.items)
                
                var tick = 0
                guard listResult.items.count != 0 else {
                    completion(nil)
                    return
                }
                for file in listResult.items {
                    
                    file.delete(completion: { err in
                        if let error = err {
                            completion(error)
                            return
                        }
                        else {
                            tick+=1
                            if tick == listResult.items.count {
                                Database.database().reference().child("Music Content").child("Songs").child("\(songContentTag)--\(strongSelf.currSong.name)--\(strongSelf.currSong.toneDeafAppId)").child("REQUIRED").child("Manual Preview URL").removeValue()
                                completion(nil)
                                return
                            }
                        }
                        
                    })
                }
            }
        })
    }
    
    fileprivate func storePreview(song: SongData, preview:URL, previewURL:String, completion: @escaping ((Error?) -> Void)) {
        StorageManager.shared.uploadPreview(song: preview, fileName: "\(currSong.toneDeafAppId)", completion: {[weak self] result in
            
            guard let strongSelf = self else {return}
            switch result {
            case .success(let url):
                switch previewURL {
                case "curr":
                    strongSelf.currPreviewDBURL = url
                default:
                    strongSelf.initPreviewDBURL = url
                }
                completion(nil)
            case .failure(let err):
                completion(err)
            }
        })
    }
    
    //MARK: - Name
    func processName(initialSong: SongData, currentSong: SongData, completion: @escaping (([Error]?) -> Void)) {
        initSong = initialSong
        currSong = currentSong
        
        initRef = Database.database().reference().child("Music Content").child("Songs").child("\(songContentTag)--\(initSong.name)--\(initSong.toneDeafAppId)")
        currRef = Database.database().reference().child("Music Content").child("Songs").child("\(songContentTag)--\(currSong.name)--\(currSong.toneDeafAppId)")
        var errors:[Error] = []
        var dataUploadCompletionStatus1:Bool!
        var dataUploadCompletionStatus2:Bool!
        var dataUploadCompletionStatus3:Bool!
        var dataUploadCompletionStatus4:Bool!
        var dataUploadCompletionStatus5:Bool!
        var dataUploadCompletionStatus6:Bool!
        var dataUploadCompletionStatus7:Bool!
        var dataUploadCompletionStatus8:Bool!
        var dataUploadCompletionStatus9:Bool!
        var dataUploadCompletionStatus10:Bool!
        
        let aqueue = DispatchQueue(label: "myhjvkheditingQsongNamep1Changessseue")
        let agroup = DispatchGroup()
        agroup.enter()
        aqueue.async { [weak self] in
            guard let strongSelf = self else {return}
            strongSelf.setNewKeyForSongInDB(initref: strongSelf.initRef, newref: strongSelf.currRef, completion: {err in
                if let error = err {
                    dataUploadCompletionStatus1 = false
                    errors.append(error)
                } else {
                    dataUploadCompletionStatus1 = true
                    print("Song name Update done \(1)")
                }
                agroup.leave()
            })
        }
        agroup.notify(queue: DispatchQueue.main) {
            if dataUploadCompletionStatus1 == false {
                completion(errors)
                return
            } else {
                let queue = DispatchQueue(label: "myhjvkheditingQsongNameChangessseue")
                let group = DispatchGroup()
                let array:[Int] = [2,3,4,5,6,7,8,9,10]
                for i in array {
                    group.enter()
                    queue.async { [weak self] in
                        guard let strongSelf = self else {return}
                        switch i {
                        case 2:
                            strongSelf.setNewKeyForSongSpotifyInDB(initref: strongSelf.initRef, newref: strongSelf.currRef, completion: {err in
                                if let error = err {
                                    dataUploadCompletionStatus2 = false
                                    errors.append(error)
                                } else {
                                    dataUploadCompletionStatus2 = true
                                    print("Song name Spotify Update done \(i)")
                                }
                                group.leave()
                            })
                        case 3:
                            strongSelf.setNewKeyForSongAppleInDB(initref: strongSelf.initRef, newref: strongSelf.currRef, completion: {err in
                                if let error = err {
                                    dataUploadCompletionStatus3 = false
                                    errors.append(error)
                                } else {
                                    dataUploadCompletionStatus3 = true
                                    print("Song name Apple Update done \(i)")
                                }
                                group.leave()
                            })
                        case 4:
                            strongSelf.setNewKeyForSongSoundcloudInDB(initref: strongSelf.initRef, newref: strongSelf.currRef, completion: {err in
                                if let error = err {
                                    dataUploadCompletionStatus4 = false
                                    errors.append(error)
                                } else {
                                    dataUploadCompletionStatus4 = true
                                    print("Song name Soundcloud Update done \(i)")
                                }
                                group.leave()
                            })
                        case 5:
                            strongSelf.setNewKeyForSongYoutubeMusicInDB(initref: strongSelf.initRef, newref: strongSelf.currRef, completion: {err in
                                if let error = err {
                                    dataUploadCompletionStatus5 = false
                                    errors.append(error)
                                } else {
                                    dataUploadCompletionStatus5 = true
                                    print("Song name Youtube Music Update done \(i)")
                                }
                                group.leave()
                            })
                        case 6:
                            strongSelf.setNewKeyForSongAmazonInDB(initref: strongSelf.initRef, newref: strongSelf.currRef, completion: {err in
                                if let error = err {
                                    dataUploadCompletionStatus6 = false
                                    errors.append(error)
                                } else {
                                    dataUploadCompletionStatus6 = true
                                    print("Song name Amazon Update done \(i)")
                                }
                                group.leave()
                            })
                        case 7:
                            strongSelf.setNewKeyForSongDeezerInDB(initref: strongSelf.initRef, newref: strongSelf.currRef, completion: {err in
                                if let error = err {
                                    dataUploadCompletionStatus7 = false
                                    errors.append(error)
                                } else {
                                    dataUploadCompletionStatus7 = true
                                    print("Song name Deezer Update done \(i)")
                                }
                                group.leave()
                            })
                        case 8:
                            strongSelf.setNewKeyForSongTidalInDB(initref: strongSelf.initRef, newref: strongSelf.currRef, completion: {err in
                                if let error = err {
                                    dataUploadCompletionStatus8 = false
                                    errors.append(error)
                                } else {
                                    dataUploadCompletionStatus8 = true
                                    print("Song name Tidal Update done \(i)")
                                }
                                group.leave()
                            })
                        case 9:
                            strongSelf.setNewKeyForSongNapsterInDB(initref: strongSelf.initRef, newref: strongSelf.currRef, completion: {err in
                                if let error = err {
                                    dataUploadCompletionStatus9 = false
                                    errors.append(error)
                                } else {
                                    dataUploadCompletionStatus9 = true
                                    print("Song name Napster Update done \(i)")
                                }
                                group.leave()
                            })
                        case 10:
                            strongSelf.setNewKeyForSongSpinrillaInDB(initref: strongSelf.initRef, newref: strongSelf.currRef, completion: {err in
                                if let error = err {
                                    dataUploadCompletionStatus10 = false
                                    errors.append(error)
                                } else {
                                    dataUploadCompletionStatus10 = true
                                    print("Song name Spinrilla Update done \(i)")
                                }
                                group.leave()
                            })
                        default:
                            print("Edit Song error")
                        }
                    }
                }
                
                group.notify(queue: DispatchQueue.main) {
                    if dataUploadCompletionStatus1 == false || dataUploadCompletionStatus2 == false || dataUploadCompletionStatus3 == false || dataUploadCompletionStatus4 == false || dataUploadCompletionStatus5 == false || dataUploadCompletionStatus6 == false || dataUploadCompletionStatus7 == false || dataUploadCompletionStatus8 == false || dataUploadCompletionStatus9 == false || dataUploadCompletionStatus10 == false {
                        completion(errors)
                        return
                    } else {
                        completion(nil)
                    }
                }
            }
        }
        
    }
    
    func setNewKeyForSongInDB(initref: DatabaseReference, newref: DatabaseReference, completion: @escaping ((Error?) -> Void)) {
        initref.observeSingleEvent(of: .value, with: {[weak self] result in
            guard let strongSelf = self else {return}
            newref.setValue(result.value, withCompletionBlock: { error, reference in
                if let error = error {
                    completion(error)
                    return
                }
                else {
                    initref.removeValue()
                    strongSelf.updateSongName(newref: newref, completion: { error in
                        if let error = error {
                            completion(error)
                            return
                        }
                        else {
                            completion(nil)
                            return
                        }
                    })
                }
            })
        }, withCancel: { error in
            completion(error)
        })
    }
    
    func updateSongName(newref: DatabaseReference, completion: @escaping ((Error?) -> Void)) {
        newref.child("REQUIRED").child("Name").setValue(currSong.name, withCompletionBlock: { error, reference in
            if let error = error {
                completion(error)
                return
            }
            else {
                completion(nil)
                return
            }
        })
    }
    
    func setNewKeyForSongSpotifyInDB(initref: DatabaseReference, newref: DatabaseReference, completion: @escaping ((Error?) -> Void)) {
        var initiref = initref
        var initkey:String!
        var currenref = newref
        var currkey:String!
        if initSong.spotify != nil {
            initkey = "\(spotifyMusicContentType)--\(initSong.name)--\(initSong.dateRegisteredToApp!)--\(initSong.timeRegisteredToApp!)"
            currkey = "\(spotifyMusicContentType)--\(currSong.name)--\(currSong.dateRegisteredToApp!)--\(currSong.timeRegisteredToApp!)"
            initiref = currenref.child(initkey)
            currenref = currenref.child(currkey)
        } else {
            completion(nil)
            return
        }
        initiref.observeSingleEvent(of: .value, with: { result in
            currenref.setValue(result.value, withCompletionBlock: { error, reference in
                if let error = error {
                    completion(error)
                    return
                }
                else {
                    initiref.removeValue()
                    completion(nil)
                    return
                }
            })
        }, withCancel: { error in
            completion(error)
        })
    }
    
    func setNewKeyForSongAppleInDB(initref: DatabaseReference, newref: DatabaseReference, completion: @escaping ((Error?) -> Void)) {
        var initiref = initref
        var initkey:String!
        var currenref = newref
        var currkey:String!
        if initSong.apple != nil {
            initkey = "\(appleMusicContentType)--\(initSong.name)--\(initSong.dateRegisteredToApp!)--\(initSong.timeRegisteredToApp!)"
            currkey = "\(appleMusicContentType)--\(currSong.name)--\(currSong.dateRegisteredToApp!)--\(currSong.timeRegisteredToApp!)"
            initiref = currenref.child(initkey)
            currenref = currenref.child(currkey)
        } else {
            completion(nil)
            return
        }
        initiref.observeSingleEvent(of: .value, with: { result in
            currenref.setValue(result.value, withCompletionBlock: { error, reference in
                if let error = error {
                    completion(error)
                    return
                }
                else {
                    initiref.removeValue()
                    completion(nil)
                    return
                }
            })
        }, withCancel: { error in
            completion(error)
        })
    }
    
    func setNewKeyForSongSoundcloudInDB(initref: DatabaseReference, newref: DatabaseReference, completion: @escaping ((Error?) -> Void)) {
        var initiref = initref
        var initkey:String!
        var currenref = newref
        var currkey:String!
        if initSong.soundcloud != nil {
            initkey = "\(soundcloudMusicContentType)--\(initSong.name)--\(initSong.dateRegisteredToApp!)--\(initSong.timeRegisteredToApp!)"
            currkey = "\(soundcloudMusicContentType)--\(currSong.name)--\(currSong.dateRegisteredToApp!)--\(currSong.timeRegisteredToApp!)"
            initiref = currenref.child(initkey)
            currenref = currenref.child(currkey)
        } else {
            completion(nil)
            return
        }
        initiref.observeSingleEvent(of: .value, with: { result in
            currenref.setValue(result.value, withCompletionBlock: { error, reference in
                if let error = error {
                    completion(error)
                    return
                }
                else {
                    initiref.removeValue()
                    completion(nil)
                    return
                }
            })
        }, withCancel: { error in
            completion(error)
        })
    }
    
    func setNewKeyForSongYoutubeMusicInDB(initref: DatabaseReference, newref: DatabaseReference, completion: @escaping ((Error?) -> Void)) {
        var initiref = initref
        var initkey:String!
        var currenref = newref
        var currkey:String!
        if initSong.youtubeMusic != nil {
            initkey = "\(youtubeMusicContentType)--\(initSong.name)--\(initSong.dateRegisteredToApp!)--\(initSong.timeRegisteredToApp!)"
            currkey = "\(youtubeMusicContentType)--\(currSong.name)--\(currSong.dateRegisteredToApp!)--\(currSong.timeRegisteredToApp!)"
            initiref = currenref.child(initkey)
            currenref = currenref.child(currkey)
        } else {
            completion(nil)
            return
        }
        initiref.observeSingleEvent(of: .value, with: { result in
            currenref.setValue(result.value, withCompletionBlock: { error, reference in
                if let error = error {
                    completion(error)
                    return
                }
                else {
                    initiref.removeValue()
                    completion(nil)
                    return
                }
            })
        }, withCancel: { error in
            completion(error)
        })
    }
    
    func setNewKeyForSongAmazonInDB(initref: DatabaseReference, newref: DatabaseReference, completion: @escaping ((Error?) -> Void)) {
        var initiref = initref
        var initkey:String!
        var currenref = newref
        var currkey:String!
        if initSong.amazon != nil {
            initkey = "\(amazonMusicContentType)--\(initSong.name)--\(initSong.dateRegisteredToApp!)--\(initSong.timeRegisteredToApp!)"
            currkey = "\(amazonMusicContentType)--\(currSong.name)--\(currSong.dateRegisteredToApp!)--\(currSong.timeRegisteredToApp!)"
            initiref = currenref.child(initkey)
            currenref = currenref.child(currkey)
        } else {
            completion(nil)
            return
        }
        initiref.observeSingleEvent(of: .value, with: { result in
            currenref.setValue(result.value, withCompletionBlock: { error, reference in
                if let error = error {
                    completion(error)
                    return
                }
                else {
                    initiref.removeValue()
                    completion(nil)
                    return
                }
            })
        }, withCancel: { error in
            completion(error)
        })
    }
    
    func setNewKeyForSongDeezerInDB(initref: DatabaseReference, newref: DatabaseReference, completion: @escaping ((Error?) -> Void)) {
        var initiref = initref
        var initkey:String!
        var currenref = newref
        var currkey:String!
        if initSong.deezer != nil {
            initkey = "\(deezerMusicContentType)--\(initSong.name)--\(initSong.dateRegisteredToApp!)--\(initSong.timeRegisteredToApp!)"
            currkey = "\(deezerMusicContentType)--\(currSong.name)--\(currSong.dateRegisteredToApp!)--\(currSong.timeRegisteredToApp!)"
            initiref = currenref.child(initkey)
            currenref = currenref.child(currkey)
        } else {
            completion(nil)
            return
        }
        initiref.observeSingleEvent(of: .value, with: { result in
            currenref.setValue(result.value, withCompletionBlock: { error, reference in
                if let error = error {
                    completion(error)
                    return
                }
                else {
                    initiref.removeValue()
                    completion(nil)
                    return
                }
            })
        }, withCancel: { error in
            completion(error)
        })
    }
    
    func setNewKeyForSongTidalInDB(initref: DatabaseReference, newref: DatabaseReference, completion: @escaping ((Error?) -> Void)) {
        var initiref = initref
        var initkey:String!
        var currenref = newref
        var currkey:String!
        if initSong.tidal != nil {
            initkey = "\(tidalMusicContentType)--\(initSong.name)--\(initSong.dateRegisteredToApp!)--\(initSong.timeRegisteredToApp!)"
            currkey = "\(tidalMusicContentType)--\(currSong.name)--\(currSong.dateRegisteredToApp!)--\(currSong.timeRegisteredToApp!)"
            initiref = currenref.child(initkey)
            currenref = currenref.child(currkey)
        } else {
            completion(nil)
            return
        }
        initiref.observeSingleEvent(of: .value, with: { result in
            currenref.setValue(result.value, withCompletionBlock: { error, reference in
                if let error = error {
                    completion(error)
                    return
                }
                else {
                    initiref.removeValue()
                    completion(nil)
                    return
                }
            })
        }, withCancel: { error in
            completion(error)
        })
    }
    
    func setNewKeyForSongNapsterInDB(initref: DatabaseReference, newref: DatabaseReference, completion: @escaping ((Error?) -> Void)) {
        var initiref = initref
        var initkey:String!
        var currenref = newref
        var currkey:String!
        if initSong.napster != nil {
            initkey = "\(napsterMusicContentType)--\(initSong.name)--\(initSong.dateRegisteredToApp!)--\(initSong.timeRegisteredToApp!)"
            currkey = "\(napsterMusicContentType)--\(currSong.name)--\(currSong.dateRegisteredToApp!)--\(currSong.timeRegisteredToApp!)"
            initiref = currenref.child(initkey)
            currenref = currenref.child(currkey)
        } else {
            completion(nil)
            return
        }
        initiref.observeSingleEvent(of: .value, with: { result in
            currenref.setValue(result.value, withCompletionBlock: { error, reference in
                if let error = error {
                    completion(error)
                    return
                }
                else {
                    initiref.removeValue()
                    completion(nil)
                    return
                }
            })
        }, withCancel: { error in
            completion(error)
        })
    }
    
    func setNewKeyForSongSpinrillaInDB(initref: DatabaseReference, newref: DatabaseReference, completion: @escaping ((Error?) -> Void)) {
        var initiref = initref
        var initkey:String!
        var currenref = newref
        var currkey:String!
        if initSong.spinrilla != nil {
            initkey = "\(spinrillaMusicContentType)--\(initSong.name)--\(initSong.dateRegisteredToApp!)--\(initSong.timeRegisteredToApp!)"
            currkey = "\(spinrillaMusicContentType)--\(currSong.name)--\(currSong.dateRegisteredToApp!)--\(currSong.timeRegisteredToApp!)"
            initiref = currenref.child(initkey)
            currenref = currenref.child(currkey)
        } else {
            completion(nil)
            return
        }
        initiref.observeSingleEvent(of: .value, with: { result in
            currenref.setValue(result.value, withCompletionBlock: { error, reference in
                if let error = error {
                    completion(error)
                    return
                }
                else {
                    initiref.removeValue()
                    completion(nil)
                    return
                }
            })
        }, withCancel: { error in
            completion(error)
        })
    }
    
    //MARK: - Artists
    func processArtists(initialSong: SongData, currentSong: SongData, completion: @escaping (([Error]?) -> Void)) {
        initSong = initialSong
        currSong = currentSong
        
        initRef = Database.database().reference().child("Music Content").child("Songs").child("\(songContentTag)--\(initSong.name)--\(initSong.toneDeafAppId)")
        currRef = Database.database().reference().child("Music Content").child("Songs").child("\(songContentTag)--\(currSong.name)--\(currSong.toneDeafAppId)")
        var errors:[Error] = []
        var dataUploadCompletionStatus1:Bool!
        var dataUploadCompletionStatus2:Bool!
        var dataUploadCompletionStatus3:Bool!
        var dataUploadCompletionStatus4:Bool!
        var dataUploadCompletionStatus5:Bool!
        var dataUploadCompletionStatus6:Bool!
        var dataUploadCompletionStatus7:Bool!
        var dataUploadCompletionStatus8:Bool!
        var dataUploadCompletionStatus9:Bool!
        var dataUploadCompletionStatus10:Bool!
        
        let aqueue = DispatchQueue(label: "myhjvkheditingQsongArtisthfdChangessseue")
        let agroup = DispatchGroup()
        let array:[Int] = [1,2,3,4]
        for i in array {
            agroup.enter()
            aqueue.async { [weak self] in
                guard let strongSelf = self else {return}
                switch i {
                case 1:
                    strongSelf.updateSongArtists(ref: strongSelf.currRef, completion: {err in
                        if let error = err {
                            dataUploadCompletionStatus1 = false
                            errors.append(error)
                        } else {
                            dataUploadCompletionStatus1 = true
                            print("Song artist Update done \(1)")
                        }
                        agroup.leave()
                    })
                case 2:
                    strongSelf.updateArtistSongs(ref: strongSelf.currRef, completion: {err in
                        if let error = err {
                            dataUploadCompletionStatus2 = false
                            errors.append(error)
                        } else {
                            dataUploadCompletionStatus2 = true
                            print("Artist songs Update done \(1)")
                        }
                        agroup.leave()
                    })
                case 3:
                    strongSelf.updateArtistRoles(ref: strongSelf.currRef, completion: {err in
                        if let error = err {
                            dataUploadCompletionStatus3 = false
                            errors.append(error)
                        } else {
                            dataUploadCompletionStatus3 = true
                            print("Artist roles Update done \(1)")
                        }
                        agroup.leave()
                    })
                case 4:
                    strongSelf.updateAlbumArtist(ref: strongSelf.currRef, completion: {err in
                        if let error = err {
                            dataUploadCompletionStatus3 = false
                            errors.append(error)
                        } else {
                            dataUploadCompletionStatus3 = true
                            print("Artist roles Update done \(1)")
                        }
                        agroup.leave()
                    })
                default:
                    break
                }
            }
        }
        agroup.notify(queue: DispatchQueue.main) {
            if dataUploadCompletionStatus1 == false || dataUploadCompletionStatus2 == false || dataUploadCompletionStatus3 == false || dataUploadCompletionStatus4 == false  {
                completion(errors)
                return
            } else {
                completion(nil)
            }
        }
    }
    
    func updateSongArtists(ref: DatabaseReference, completion: @escaping ((Error?) -> Void)) {
        var initialArtistsArrFromDB:[String]!
        if currSong.songArtist.sorted() == initSong.songArtist.sorted() {
            completion(nil)
            return
        }
        getSongArtistsInDB(ref: ref, completion: {[weak self] persons in
            guard let strongSelf = self else {return}
            initialArtistsArrFromDB = persons.sorted()
            
            if !initialArtistsArrFromDB.isEmpty {
                var removalCounter = 0
                for i in 0 ... initialArtistsArrFromDB.count-1 {
                    if strongSelf.currSong.songArtist != nil {
                        if i < strongSelf.currSong.songArtist.count {
                            if !strongSelf.currSong.songArtist[i].contains(initialArtistsArrFromDB[i]) {
                                let index = initialArtistsArrFromDB.firstIndex(of: initialArtistsArrFromDB[i])
                                initialArtistsArrFromDB.remove(at: index!)
                                removalCounter+=1
                            }
                        } else {
                            let index = initialArtistsArrFromDB.firstIndex(of: initialArtistsArrFromDB[i-removalCounter])
                            initialArtistsArrFromDB.remove(at: index!)
                            removalCounter+=1
                        }
                    } else {
                        let index = initialArtistsArrFromDB.firstIndex(of: initialArtistsArrFromDB[i-removalCounter])
                        initialArtistsArrFromDB.remove(at: index!)
                        removalCounter+=1
                    }
                }
            }
            
            if strongSelf.currSong.songArtist != nil {
                if !strongSelf.currSong.songArtist.isEmpty {
                    for i in 0 ... strongSelf.currSong.songArtist.count-1 {
                        if i < initialArtistsArrFromDB.count {
                            if !initialArtistsArrFromDB[i].contains(strongSelf.currSong.songArtist[i]) {
                                initialArtistsArrFromDB.append(strongSelf.currSong.songArtist[i])
                            }
                        } else {
                            initialArtistsArrFromDB.append(strongSelf.currSong.songArtist[i])
                        }
                    }
                }
            }
            ref.child("REQUIRED").child("Artist").setValue(initialArtistsArrFromDB.sorted(), withCompletionBlock: { error, reference in
                if let error = error {
                    completion(error)
                    return
                }
                else {
                    completion(nil)
                    return
                }
            })
            
        })
    }
    
    func getSongArtistsInDB(ref: DatabaseReference, completion: @escaping (([String]) -> Void)) {
        ref.child("REQUIRED").child("Artist").observeSingleEvent(of: .value, with: { snapshot in
            var mysongsArray:[String] = []
            if let val = snapshot.value {
                let valu = val as? [String]
                guard let value = valu else {
                    completion(mysongsArray)
                    return}
                if value[0] != "" {
                    mysongsArray = value
                }
                completion(mysongsArray)
            } else {
                completion(mysongsArray)
            }
        })
    }
    
    func updateArtistSongs(ref: DatabaseReference, completion: @escaping ((Error?) -> Void)) {
        var initialArtistsArrFromDB:[String]!
        var totalProgress:Int = 0
        var completedProgress:Int = 0
        if currSong.songArtist.sorted() == initSong.songArtist.sorted() {
            completion(nil)
            return
        }
        
        getSongArtistsInDB(ref: ref, completion: {[weak self] persons in
            guard let strongSelf = self else {return}
            initialArtistsArrFromDB = persons.sorted()
            
            if !initialArtistsArrFromDB.isEmpty {
                var removalCounter = 0
                for i in 0 ... initialArtistsArrFromDB.count-1 {
                    if strongSelf.currSong.songArtist != nil {
                        if i < strongSelf.currSong.songArtist.count {
                            if !strongSelf.currSong.songArtist[i].contains(initialArtistsArrFromDB[i]) {
                                totalProgress+=1
                            }
                        } else {
                            totalProgress+=1
                        }
                    } else {
                        totalProgress+=1
                    }
                }
            }
            
            if strongSelf.currSong.songArtist != nil {
                if !strongSelf.currSong.songArtist.isEmpty {
                    for i in 0 ... strongSelf.currSong.songArtist.count-1 {
                        if i < initialArtistsArrFromDB.count {
                            if !initialArtistsArrFromDB[i].contains(strongSelf.currSong.songArtist[i]) {
                                totalProgress+=1
                            }
                        } else {
                            totalProgress+=1
                        }
                    }
                }
            }
            
            if !initialArtistsArrFromDB.isEmpty {
                for i in 0 ... initialArtistsArrFromDB.count-1 {
                    if strongSelf.currSong.songArtist != nil {
                        if i < strongSelf.currSong.songArtist.count {
                            if !strongSelf.currSong.songArtist[i].contains(initialArtistsArrFromDB[i]) {
                                strongSelf.removeSongFromPerson(per: initialArtistsArrFromDB[i], completion: { error in
                                    completedProgress+=1
                                    if let error = error {
                                        completion(error)
                                        return
                                    } else {
                                        if completedProgress == totalProgress {
                                            completion(nil)
                                            return
                                        }
                                    }
                                })
                            }
                        } else {
                            strongSelf.removeSongFromPerson(per: initialArtistsArrFromDB[i], completion: { error in
                                completedProgress+=1
                                if let error = error {
                                    completion(error)
                                    return
                                } else {
                                    if completedProgress == totalProgress {
                                        completion(nil)
                                        return
                                    }
                                }
                            })
                        }
                    } else {
                        strongSelf.removeSongFromPerson(per: initialArtistsArrFromDB[i], completion: { error in
                            completedProgress+=1
                            if let error = error {
                                completion(error)
                                return
                            } else {
                                if completedProgress == totalProgress {
                                    completion(nil)
                                    return
                                }
                            }
                        })
                    }
                }
            }
            
            if strongSelf.currSong.songArtist != nil {
                if !strongSelf.currSong.songArtist.isEmpty {
                    for i in 0 ... strongSelf.currSong.songArtist.count-1 {
                        if i < initialArtistsArrFromDB.count {
                            if !initialArtistsArrFromDB[i].contains(strongSelf.currSong.songArtist[i]) {
                                strongSelf.addSongToPerson(per: strongSelf.currSong.songArtist[i], completion: { error in
                                    completedProgress+=1
                                    if let error = error {
                                        completion(error)
                                        return
                                    } else {
                                        if completedProgress == totalProgress {
                                            completion(nil)
                                            return
                                        }
                                    }
                                })
                            }
                        } else {
                            strongSelf.addSongToPerson(per: strongSelf.currSong.songArtist[i], completion: { error in
                                completedProgress+=1
                                if let error = error {
                                    completion(error)
                                    return
                                } else {
                                    if completedProgress == totalProgress {
                                        completion(nil)
                                        return
                                    }
                                }
                            })
                        }
                    }
                }
            }
            
        })
    }
    
    func removeSongFromPerson(per: String, completion: @escaping ((Error?) -> Void)) {
        guard per.count == 6 else {
            completion(nil)
            return
        }
        var present:Bool = false
        if currSong.songArtist.contains(per) {
            present = true
        }
        if currSong.songProducers.contains(per) {
            present = true
        }
        if currSong.songWriters != nil {
            if currSong.songWriters!.contains(per) {
                present = true
            }
        }
        if currSong.songMixEngineer != nil {
            if currSong.songMixEngineer!.contains(per) {
                present = true
            }
        }
        if currSong.songMasteringEngineer != nil {
            if currSong.songMasteringEngineer!.contains(per) {
                present = true
            }
        }
        if currSong.songRecordingEngineer != nil {
            if currSong.songRecordingEngineer!.contains(per) {
                present = true
            }
        }
        if present == true {
            completion(nil)
            return
        }
        DatabaseManager.shared.fetchPersonData(person: per, completion: {[weak self] result in
            guard let strongSelf = self else {return}
            switch result {
            case .success(let person):
                let ref = Database.database().reference().child("Registered Persons").child("\(person.name!)--\(person.dateRegisteredToApp!)--\(person.timeRegisteredToApp!)--\(person.toneDeafAppId)").child("Songs")
                let song = "\(strongSelf.currSong.toneDeafAppId)"
                var arrTo:[String] = []
                if var arrrr = person.songs {
                    if arrrr.contains(song) {
                        let index = arrrr.firstIndex(of: song)
                        arrrr.remove(at: index!)
                        arrTo = arrrr
                    } else {
                        arrTo = arrrr
                    }
                }
                else {
                    completion(nil)
                    return
                }
                
                ref.setValue(arrTo.sorted(), withCompletionBlock: { error, reference in
                    if let error = error {
                        completion(error)
                        return
                    }
                    else {
                        completion(nil)
                        return
                    }
                })
            case .failure(let err):
                print("dsvgredfxbdfzx"+err.localizedDescription)
            }
        })
    }
    
    func addSongToPerson(per: String, completion: @escaping ((Error?) -> Void)) {
        guard per.count == 6 else {
            completion(nil)
            return
        }
        
        DatabaseManager.shared.fetchPersonData(person: per, completion: {[weak self] result in
            guard let strongSelf = self else {return}
            switch result {
            case .success(let person):
                let ref = Database.database().reference().child("Registered Persons").child("\(person.name!)--\(person.dateRegisteredToApp!)--\(person.timeRegisteredToApp!)--\(person.toneDeafAppId)").child("Songs")
                let song = "\(strongSelf.currSong.toneDeafAppId)"
                var arrTo:[String] = []
                if let psong = person.songs {
                    arrTo = psong
                    if !psong.contains(song) {
                        arrTo.append(song)
                    }
                } else {
                    arrTo = []
                    arrTo.append(song)
                }
                
                ref.setValue(arrTo.sorted(), withCompletionBlock: { error, reference in
                    if let error = error {
                        completion(error)
                        return
                    }
                    else {
                        completion(nil)
                        return
                    }
                })
            case .failure(let err):
                print("dsvgredfxbdfzx"+err.localizedDescription)
            }
        })
    }
    
    func updateArtistRoles(ref: DatabaseReference, completion: @escaping ((Error?) -> Void)) {
        var initialArtistsArrFromDB:[String]!
        var totalProgress:Int = 0
        var completedProgress:Int = 0
        if currSong.songArtist.sorted() == initSong.songArtist.sorted() {
            completion(nil)
            return
        }
        
        getSongArtistsInDB(ref: ref, completion: {[weak self] persons in
            guard let strongSelf = self else {return}
            initialArtistsArrFromDB = persons.sorted()
            
            if !initialArtistsArrFromDB.isEmpty {
                for i in 0 ... initialArtistsArrFromDB.count-1 {
                    if strongSelf.currSong.songArtist != nil {
                        if i < strongSelf.currSong.songArtist.count {
                            if !strongSelf.currSong.songArtist[i].contains(initialArtistsArrFromDB[i]) {
                                totalProgress+=1
                            }
                        } else {
                            totalProgress+=1
                        }
                    } else {
                        totalProgress+=1
                    }
                }
            }
            
            if strongSelf.currSong.songArtist != nil {
                if !strongSelf.currSong.songArtist.isEmpty {
                    for i in 0 ... strongSelf.currSong.songArtist.count-1 {
                        if i < initialArtistsArrFromDB.count {
                            if !initialArtistsArrFromDB[i].contains(strongSelf.currSong.songArtist[i]) {
                                totalProgress+=1
                            }
                        } else {
                            totalProgress+=1
                        }
                    }
                }
            }
            
            if !initialArtistsArrFromDB.isEmpty {
                for i in 0 ... initialArtistsArrFromDB.count-1 {
                    if strongSelf.currSong.songArtist != nil {
                        if i < strongSelf.currSong.songArtist.count {
                            if !strongSelf.currSong.songArtist[i].contains(initialArtistsArrFromDB[i]) {
                                strongSelf.removeSongFromArtistRoles(per: initialArtistsArrFromDB[i], completion: { error in
                                    completedProgress+=1
                                    if let error = error {
                                        completion(error)
                                        return
                                    } else {
                                        if completedProgress == totalProgress {
                                            completion(nil)
                                            return
                                        }
                                    }
                                })
                            }
                        } else {
                            strongSelf.removeSongFromArtistRoles(per: initialArtistsArrFromDB[i], completion: { error in
                                completedProgress+=1
                                if let error = error {
                                    completion(error)
                                    return
                                } else {
                                    if completedProgress == totalProgress {
                                        completion(nil)
                                        return
                                    }
                                }
                            })
                        }
                    } else {
                        strongSelf.removeSongFromArtistRoles(per: initialArtistsArrFromDB[i], completion: { error in
                            completedProgress+=1
                            if let error = error {
                                completion(error)
                                return
                            } else {
                                if completedProgress == totalProgress {
                                    completion(nil)
                                    return
                                }
                            }
                        })
                    }
                }
            }
            
            if strongSelf.currSong.songArtist != nil {
                if !strongSelf.currSong.songArtist.isEmpty {
                    for i in 0 ... strongSelf.currSong.songArtist.count-1 {
                        if i < initialArtistsArrFromDB.count {
                            if !initialArtistsArrFromDB[i].contains(strongSelf.currSong.songArtist[i]) {
                                strongSelf.addSongToArtistRoles(per: strongSelf.currSong.songArtist[i], completion: { error in
                                    completedProgress+=1
                                    if let error = error {
                                        completion(error)
                                        return
                                    } else {
                                        if completedProgress == totalProgress {
                                            completion(nil)
                                            return
                                        }
                                    }
                                })
                            }
                        } else {
                            strongSelf.addSongToArtistRoles(per: strongSelf.currSong.songArtist[i], completion: { error in
                                completedProgress+=1
                                if let error = error {
                                    completion(error)
                                    return
                                } else {
                                    if completedProgress == totalProgress {
                                        completion(nil)
                                        return
                                    }
                                }
                            })
                        }
                    }
                }
            }
            
        })
    }
    
    func removeSongFromArtistRoles(per: String, completion: @escaping ((Error?) -> Void)) {
        guard per.count == 6 else {
            completion(nil)
            return
        }
        DatabaseManager.shared.fetchPersonData(person: per, completion: {[weak self] result in
            guard let strongSelf = self else {return}
            switch result {
            case .success(let person):
                let ref = Database.database().reference().child("Registered Persons").child("\(person.name!)--\(person.dateRegisteredToApp!)--\(person.timeRegisteredToApp!)--\(person.toneDeafAppId)").child("Roles").child("Artist")
                let song = "\(strongSelf.currSong.toneDeafAppId)"
                var arrTo:[String] = []
                if let roles = person.roles {
                    if var art = roles["Artist"] as? [String] {
                        if art.contains(song) {
                            let index = art.firstIndex(of: song)
                            art.remove(at: index!)
                            arrTo = art
                        }
                    }
                }
                
                ref.setValue(arrTo.sorted(), withCompletionBlock: { error, reference in
                    if let error = error {
                        completion(error)
                        return
                    }
                    else {
                        completion(nil)
                        return
                    }
                })
            case .failure(let err):
                print("dsvgredfxbdfzx"+err.localizedDescription)
            }
        })
    }
    
    func addSongToArtistRoles(per: String, completion: @escaping ((Error?) -> Void)) {
        guard per.count == 6 else {
            completion(nil)
            return
        }
        
        DatabaseManager.shared.fetchPersonData(person: per, completion: {[weak self] result in
            guard let strongSelf = self else {return}
            switch result {
            case .success(let person):
                let ref = Database.database().reference().child("Registered Persons").child("\(person.name!)--\(person.dateRegisteredToApp!)--\(person.timeRegisteredToApp!)--\(person.toneDeafAppId)").child("Roles").child("Artist")
                let song = "\(strongSelf.currSong.toneDeafAppId)"
                var arrTo:[String] = []
                
                if let roles = person.roles {
                    if var art = roles["Artist"] as? [String] {
                        if !art.contains(song) {
                            art.append(song)
                            arrTo = art
                        }
                    } else {
                        arrTo = [song]
                    }
                } else {
                    arrTo = [song]
                }
                
                ref.setValue(arrTo.sorted(), withCompletionBlock: { error, reference in
                    if let error = error {
                        completion(error)
                        return
                    }
                    else {
                        completion(nil)
                        return
                    }
                })
            case .failure(let err):
                print("dsvgredfxbdfzx"+err.localizedDescription)
            }
        })
    }
    
    func updateAlbumArtist(ref: DatabaseReference, completion: @escaping ((Error?) -> Void)) {
        var initialArtistsArrFromDB:[String]!
        var totalProgress:Int = 0
        var completedProgress:Int = 0
        if currSong.songArtist.sorted() == initSong.songArtist.sorted() {
            completion(nil)
            return
        }
        if currSong.albums == nil {
            completion(nil)
            return
        }
        if currSong.albums!.isEmpty {
            completion(nil)
            return
        }
        
        let albums = currSong.albums!
        
        getSongArtistsInDB(ref: ref, completion: {[weak self] persons in
            guard let strongSelf = self else {return}
            initialArtistsArrFromDB = persons.sorted()
            
            if !initialArtistsArrFromDB.isEmpty {
                for i in 0 ... initialArtistsArrFromDB.count-1 {
                    if strongSelf.currSong.songArtist != nil {
                        if i < strongSelf.currSong.songArtist.count {
                            if !strongSelf.currSong.songArtist[i].contains(initialArtistsArrFromDB[i]) {
                                for alb in albums {
                                    totalProgress+=1
                                }
                            }
                        } else {
                            for alb in albums {
                                totalProgress+=1
                            }
                        }
                    } else {
                        for alb in albums {
                            totalProgress+=1
                        }
                    }
                }
            }
            
            if strongSelf.currSong.songArtist != nil {
                if !strongSelf.currSong.songArtist.isEmpty {
                    for i in 0 ... strongSelf.currSong.songArtist.count-1 {
                        if i < initialArtistsArrFromDB.count {
                            if !initialArtistsArrFromDB[i].contains(strongSelf.currSong.songArtist[i]) {
                                for alb in albums {
                                    totalProgress+=1
                                }
                            }
                        } else {
                            for alb in albums {
                                totalProgress+=1
                            }
                        }
                    }
                }
            }
            
            if !initialArtistsArrFromDB.isEmpty {
                for i in 0 ... initialArtistsArrFromDB.count-1 {
                    if strongSelf.currSong.songArtist != nil {
                        if i < strongSelf.currSong.songArtist.count {
                            if !strongSelf.currSong.songArtist[i].contains(initialArtistsArrFromDB[i]) {
                                for alb in albums {
                                    strongSelf.removeArtistFromAlbum(alb: alb, per: initialArtistsArrFromDB[i], completion: { error in
                                        completedProgress+=1
                                        if let error = error {
                                            completion(error)
                                            return
                                        } else {
                                            if completedProgress == totalProgress {
                                                completion(nil)
                                                return
                                            }
                                        }
                                    })
                                }
                            }
                        } else {
                            for alb in albums {
                                strongSelf.removeArtistFromAlbum(alb: alb, per: initialArtistsArrFromDB[i], completion: { error in
                                    completedProgress+=1
                                    if let error = error {
                                        completion(error)
                                        return
                                    } else {
                                        if completedProgress == totalProgress {
                                            completion(nil)
                                            return
                                        }
                                    }
                                })
                            }
                        }
                    } else {
                        for alb in albums {
                            strongSelf.removeArtistFromAlbum(alb: alb, per: initialArtistsArrFromDB[i], completion: { error in
                                completedProgress+=1
                                if let error = error {
                                    completion(error)
                                    return
                                } else {
                                    if completedProgress == totalProgress {
                                        completion(nil)
                                        return
                                    }
                                }
                            })
                        }
                    }
                }
            }
            
            if strongSelf.currSong.songArtist != nil {
                if !strongSelf.currSong.songArtist.isEmpty {
                    for i in 0 ... strongSelf.currSong.songArtist.count-1 {
                        if i < initialArtistsArrFromDB.count {
                            if !initialArtistsArrFromDB[i].contains(strongSelf.currSong.songArtist[i]) {
                                for album in albums {
                                    strongSelf.addArtistToAlbum(alb: album, per: strongSelf.currSong.songArtist[i], completion: { error in
                                        completedProgress+=1
                                        if let error = error {
                                            completion(error)
                                            return
                                        } else {
                                            if completedProgress == totalProgress {
                                                completion(nil)
                                                return
                                            }
                                        }
                                    })
                                }
                            }
                        } else {
                            for album in albums {
                                strongSelf.addArtistToAlbum(alb: album, per: strongSelf.currSong.songArtist[i], completion: { error in
                                    completedProgress+=1
                                    if let error = error {
                                        completion(error)
                                        return
                                    } else {
                                        if completedProgress == totalProgress {
                                            completion(nil)
                                            return
                                        }
                                    }
                                })
                            }
                        }
                    }
                }
            }
            
        })
    }
    
    func removeArtistFromAlbum(alb: String, per: String, completion: @escaping ((Error?) -> Void)) {
        guard alb.count == 8 else {
            completion(nil)
            return
        }
        DatabaseManager.shared.findAlbumById(albumId: alb, completion: {[weak self] result in
            guard let strongSelf = self else {return}
            switch result {
            case .success(let album):
                let ref = Database.database().reference().child("Music Content").child("Albums").child("\(albumContentTag)--\(album.name)--\(album.toneDeafAppId)").child("REQUIRED").child("All Artist")
                var arrTo:[String] = []
                DatabaseManager.shared.fetchPersonData(person: per, completion: { result in
                    guard let strongSelf = self else {return}
                    switch result {
                    case .success(let person):
                        var roleMArkedOnAnotherSong:Bool = false
                        if let asong = album.songs {
                            for song in asong {
                                if let proles = person.roles {
                                    if let parr = proles["Artist"] as? [String] {
                                        if parr.contains(song) {
                                            if song != strongSelf.currSong.toneDeafAppId {
                                                roleMArkedOnAnotherSong = true
                                            }
                                        }
                                    }
                                }
                            }
                        }
                        if let asong = album.instrumentals {
                            for song in asong {
                                if let proles = person.roles {
                                    if let parr = proles["Artist"] as? [String] {
                                        if parr.contains(song) {
                                            if song != strongSelf.currSong.toneDeafAppId {
                                                roleMArkedOnAnotherSong = true
                                            }
                                        }
                                    }
                                }
                            }
                        }
                        if roleMArkedOnAnotherSong == false {
                            if var arrr = album.allArtists {
                                let index = arrr.firstIndex(of: per)
                                arrr.remove(at: index!)
                                arrTo = arrr
                            }
                            ref.setValue(arrTo.sorted(), withCompletionBlock: { error, reference in
                                if let error = error {
                                    completion(error)
                                    return
                                }
                                else {
                                    strongSelf.removeAlbumFromPersonArtist(alb: alb, per: per, completion: { error in
                                        if let error = error {
                                            completion(error)
                                            return
                                        }
                                        else {
                                            completion(nil)
                                            return
                                        }
                                    })
                                }
                            })
                        } else {
                            completion(nil)
                        }
                        
                    case .failure(let err):
                        print("dsvgredfxbdfzx"+err.localizedDescription)
                    }
                    
                })
            case .failure(let err):
                print("dsvgredfxbdfzx"+err.localizedDescription)
            }
        })
    }
    
    func addArtistToAlbum(alb: String,per: String, completion: @escaping ((Error?) -> Void)) {
        guard alb.count == 8 else {
            completion(nil)
            return
        }
        
        DatabaseManager.shared.findAlbumById(albumId: alb, completion: {[weak self] result in
            guard let strongSelf = self else {return}
            switch result {
            case .success(let album):
                let ref = Database.database().reference().child("Music Content").child("Albums").child("\(albumContentTag)--\(album.name)--\(album.toneDeafAppId)").child("REQUIRED").child("All Artist")
                var arrTo:[String] = []
                
                if var arrr = album.allArtists {
                    if !arrr.contains(per) {
                        arrr.append(per)
                    }
                    arrTo = arrr
                } else {
                    arrTo = [per]
                }
                
                ref.setValue(arrTo.sorted(), withCompletionBlock: { error, reference in
                    if let error = error {
                        completion(error)
                        return
                    }
                    else {
                        strongSelf.addAlbumToPersonArtist(alb: [alb], per: per, completion: { error in
                            if let error = error {
                                completion(error)
                                return
                            }
                            else {
                                completion(nil)
                                return
                            }
                        })
                        
                    }
                })
            case .failure(let err):
                print("dsvgredfxbdfzx"+err.localizedDescription)
            }
        })
    }
    
    func addAlbumToPersonArtist(alb: [String],per: String, completion: @escaping ((Error?) -> Void)) {
        DatabaseManager.shared.fetchPersonData(person: per, completion: {[weak self] result in
            guard let strongSelf = self else {return}
            switch result {
            case .success(let person):
                let ref = Database.database().reference().child("Registered Persons").child("\(person.name!)--\(person.dateRegisteredToApp!)--\(person.timeRegisteredToApp!)--\(person.toneDeafAppId)").child("Albums")
                var arrTo:[String] = []
                
                strongSelf.getPersonAlbumsInDB(ref: Database.database().reference().child("Registered Persons").child("\(person.name!)--\(person.dateRegisteredToApp!)--\(person.timeRegisteredToApp!)--\(person.toneDeafAppId)"), completion: { albumns in
                    var albbums = albumns
                    for element in alb {
                        if !albbums.contains(element) {
                            albbums.append(element)
                            arrTo = albbums
                        } else {
                            arrTo = albbums
                        }
                    }
                    
                    ref.setValue(arrTo.sorted(), withCompletionBlock: { error, reference in
                        if let error = error {
                            completion(error)
                            return
                        }
                        else {
                            let ref2 = Database.database().reference().child("Registered Persons").child("\(person.name!)--\(person.dateRegisteredToApp!)--\(person.timeRegisteredToApp!)--\(person.toneDeafAppId)").child("Roles").child("Artist")
                            var arrTo2:[String] = []
                            if let currole = person.roles {
                                if var arrrry = currole["Artist"] as? [String] {
                                    for element in alb {
                                        if !arrrry.contains(element) {
                                            arrrry.append(element)
                                            arrTo2 = arrrry.sorted()
                                        } else {
                                            arrTo2 = arrrry.sorted()
                                        }
                                    }
                                } else {
                                    arrTo2 = alb
                                }
                            } else {
                                arrTo2 = alb
                            }
                            ref2.setValue(arrTo2.sorted(), withCompletionBlock: { error, reference in
                                if let error = error {
                                    completion(error)
                                    return
                                }
                                else {
                                    completion(nil)
                                    return
                                }
                            })
                        }
                    })
                })
            case .failure(let err):
                print("dsvgredfxbdfzx"+err.localizedDescription)
            }
        })
    }
    
    func removeAlbumFromPersonArtist(alb: String,per: String, completion: @escaping ((Error?) -> Void)) {
        DatabaseManager.shared.fetchPersonData(person: per, completion: {[weak self] result in
            guard let strongSelf = self else {return}
            switch result {
            case .success(let person):
                let ref = Database.database().reference().child("Registered Persons").child("\(person.name!)--\(person.dateRegisteredToApp!)--\(person.timeRegisteredToApp!)--\(person.toneDeafAppId)").child("Albums")
                var arrTo:[String] = []
                if var albbums = person.albums {
                    if let index = albbums.firstIndex(of: alb) {
                        albbums.remove(at: index)
                    }
                    for element in strongSelf.removedAlbs {
                        if albbums.contains(element) {
                            if let index = albbums.firstIndex(of: element) {
                                albbums.remove(at: index)
                            }
                        }
                    }
                    arrTo = albbums
                }
                ref.setValue(arrTo.sorted(), withCompletionBlock: { error, reference in
                    if let error = error {
                        completion(error)
                        return
                    }
                    else {
                        let ref2 = Database.database().reference().child("Registered Persons").child("\(person.name!)--\(person.dateRegisteredToApp!)--\(person.timeRegisteredToApp!)--\(person.toneDeafAppId)").child("Roles").child("Artist")
                        var arrTo2:[String] = []
                        if let currole = person.roles {
                            if var arrrry = currole["Artist"] as? [String] {
                                if let index = arrrry.firstIndex(of: alb) {
                                    arrrry.remove(at: index)
                                }
                                for element in strongSelf.removedAlbs {
                                    if arrrry.contains(element) {
                                        if let index = arrrry.firstIndex(of: element) {
                                            arrrry.remove(at: index)
                                        }
                                    }
                                }
                                arrTo2 = arrrry.sorted()
                            }
                        }
                        if !strongSelf.removedAlbs.contains(alb) {
                            strongSelf.removedAlbs.append(alb)
                        }
                        ref2.setValue(arrTo2.sorted(), withCompletionBlock: { error, reference in
                            if let error = error {
                                completion(error)
                                return
                            }
                            else {
                                completion(nil)
                                return
                            }
                        })
                    }
                })
            case .failure(let err):
                print("dsvgredfxbdfzx"+err.localizedDescription)
            }
        })
    }
    
    //MARK: - Producers
    func processProducers(initialSong: SongData, currentSong: SongData, completion: @escaping (([Error]?) -> Void)) {
        initSong = initialSong
        currSong = currentSong
        
        initRef = Database.database().reference().child("Music Content").child("Songs").child("\(songContentTag)--\(initSong.name)--\(initSong.toneDeafAppId)")
        currRef = Database.database().reference().child("Music Content").child("Songs").child("\(songContentTag)--\(currSong.name)--\(currSong.toneDeafAppId)")
        var errors:[Error] = []
        var dataUploadCompletionStatus1:Bool!
        var dataUploadCompletionStatus2:Bool!
        var dataUploadCompletionStatus3:Bool!
        var dataUploadCompletionStatus4:Bool!
        var dataUploadCompletionStatus5:Bool!
        var dataUploadCompletionStatus6:Bool!
        var dataUploadCompletionStatus7:Bool!
        var dataUploadCompletionStatus8:Bool!
        var dataUploadCompletionStatus9:Bool!
        var dataUploadCompletionStatus10:Bool!
        
        let aqueue = DispatchQueue(label: "myhjvkheditingQsongProducerhfdChangessseue")
        let agroup = DispatchGroup()
        let array:[Int] = [1,2,3,4]
        for i in array {
            agroup.enter()
            aqueue.async { [weak self] in
                guard let strongSelf = self else {return}
                switch i {
                case 1:
                    strongSelf.updateSongProducers(ref: strongSelf.currRef, completion: {err in
                        if let error = err {
                            dataUploadCompletionStatus1 = false
                            errors.append(error)
                        } else {
                            dataUploadCompletionStatus1 = true
                            print("Song Producer Update done \(1)")
                        }
                        agroup.leave()
                    })
                case 2:
                    strongSelf.updateProducerSongs(ref: strongSelf.currRef, completion: {err in
                        if let error = err {
                            dataUploadCompletionStatus2 = false
                            errors.append(error)
                        } else {
                            dataUploadCompletionStatus2 = true
                            print("Producer songs Update done \(1)")
                        }
                        agroup.leave()
                    })
                case 3:
                    strongSelf.updateProducerRoles(ref: strongSelf.currRef, completion: {err in
                        if let error = err {
                            dataUploadCompletionStatus3 = false
                            errors.append(error)
                        } else {
                            dataUploadCompletionStatus3 = true
                            print("Producer roles Update done \(1)")
                        }
                        agroup.leave()
                    })
                case 4:
                    strongSelf.updateAlbumProducer(ref: strongSelf.currRef, completion: {err in
                        if let error = err {
                            dataUploadCompletionStatus3 = false
                            errors.append(error)
                        } else {
                            dataUploadCompletionStatus3 = true
                            print("Producer roles Update done \(1)")
                        }
                        agroup.leave()
                    })
                default:
                    break
                }
            }
        }
        agroup.notify(queue: DispatchQueue.main) {
            if dataUploadCompletionStatus1 == false || dataUploadCompletionStatus2 == false || dataUploadCompletionStatus3 == false || dataUploadCompletionStatus4 == false {
                completion(errors)
                return
            } else {
                completion(nil)
            }
        }
    }
    
    func updateSongProducers(ref: DatabaseReference, completion: @escaping ((Error?) -> Void)) {
        var initialArtistsArrFromDB:[String]!
        if currSong.songProducers.sorted() == initSong.songProducers.sorted() {
            completion(nil)
            return
        }
        getSongProducersInDB(ref: ref, completion: {[weak self] persons in
            guard let strongSelf = self else {return}
            initialArtistsArrFromDB = persons.sorted()
            
            if !initialArtistsArrFromDB.isEmpty {
                var removalCounter = 0
                for i in 0 ... initialArtistsArrFromDB.count-1 {
                    if strongSelf.currSong.songProducers != nil {
                        if i < strongSelf.currSong.songProducers.count {
                            if !strongSelf.currSong.songProducers[i].contains(initialArtistsArrFromDB[i]) {
                                let index = initialArtistsArrFromDB.firstIndex(of: initialArtistsArrFromDB[i])
                                initialArtistsArrFromDB.remove(at: index!)
                                removalCounter+=1
                            }
                        } else {
                            let index = initialArtistsArrFromDB.firstIndex(of: initialArtistsArrFromDB[i-removalCounter])
                            initialArtistsArrFromDB.remove(at: index!)
                            removalCounter+=1
                        }
                    } else {
                        let index = initialArtistsArrFromDB.firstIndex(of: initialArtistsArrFromDB[i-removalCounter])
                        initialArtistsArrFromDB.remove(at: index!)
                        removalCounter+=1
                    }
                }
            }
            
            if strongSelf.currSong.songProducers != nil {
                if !strongSelf.currSong.songProducers.isEmpty {
                    for i in 0 ... strongSelf.currSong.songProducers.count-1 {
                        if i < initialArtistsArrFromDB.count {
                            if !initialArtistsArrFromDB[i].contains(strongSelf.currSong.songProducers[i]) {
                                initialArtistsArrFromDB.append(strongSelf.currSong.songProducers[i])
                            }
                        } else {
                            initialArtistsArrFromDB.append(strongSelf.currSong.songProducers[i])
                        }
                    }
                }
            }
            ref.child("REQUIRED").child("Producers").setValue(initialArtistsArrFromDB.sorted(), withCompletionBlock: { error, reference in
                if let error = error {
                    completion(error)
                    return
                }
                else {
                    completion(nil)
                    return
                }
            })
            
        })
    }
    
    func getSongProducersInDB(ref: DatabaseReference, completion: @escaping (([String]) -> Void)) {
        ref.child("REQUIRED").child("Producers").observeSingleEvent(of: .value, with: { snapshot in
            var mysongsArray:[String] = []
            if let val = snapshot.value {
                let valu = val as? [String]
                guard let value = valu else {
                    completion(mysongsArray)
                    return}
                if value[0] != "" {
                    mysongsArray = value
                }
                completion(mysongsArray)
            } else {
                completion(mysongsArray)
            }
        })
    }
    
    func updateProducerSongs(ref: DatabaseReference, completion: @escaping ((Error?) -> Void)) {
        var initialArtistsArrFromDB:[String]!
        var totalProgress:Int = 0
        var completedProgress:Int = 0
        if currSong.songProducers.sorted() == initSong.songProducers.sorted() {
            completion(nil)
            return
        }
        
        getSongProducersInDB(ref: ref, completion: {[weak self] persons in
            guard let strongSelf = self else {return}
            initialArtistsArrFromDB = persons.sorted()
            
            if !initialArtistsArrFromDB.isEmpty {
                var removalCounter = 0
                for i in 0 ... initialArtistsArrFromDB.count-1 {
                    if strongSelf.currSong.songProducers != nil {
                        if i < strongSelf.currSong.songProducers.count {
                            if !strongSelf.currSong.songProducers[i].contains(initialArtistsArrFromDB[i]) {
                                totalProgress+=1
                            }
                        } else {
                            totalProgress+=1
                        }
                    } else {
                        totalProgress+=1
                    }
                }
            }
            
            if strongSelf.currSong.songProducers != nil {
                if !strongSelf.currSong.songProducers.isEmpty {
                    for i in 0 ... strongSelf.currSong.songProducers.count-1 {
                        if i < initialArtistsArrFromDB.count {
                            if !initialArtistsArrFromDB[i].contains(strongSelf.currSong.songProducers[i]) {
                                totalProgress+=1
                            }
                        } else {
                            totalProgress+=1
                        }
                    }
                }
            }
            
            if !initialArtistsArrFromDB.isEmpty {
                for i in 0 ... initialArtistsArrFromDB.count-1 {
                    if strongSelf.currSong.songProducers != nil {
                        if i < strongSelf.currSong.songProducers.count {
                            if !strongSelf.currSong.songProducers[i].contains(initialArtistsArrFromDB[i]) {
                                strongSelf.removeSongFromPerson(per: initialArtistsArrFromDB[i], completion: { error in
                                    completedProgress+=1
                                    if let error = error {
                                        completion(error)
                                        return
                                    } else {
                                        if completedProgress == totalProgress {
                                            completion(nil)
                                            return
                                        }
                                    }
                                })
                            }
                        } else {
                            strongSelf.removeSongFromPerson(per: initialArtistsArrFromDB[i], completion: { error in
                                completedProgress+=1
                                if let error = error {
                                    completion(error)
                                    return
                                } else {
                                    if completedProgress == totalProgress {
                                        completion(nil)
                                        return
                                    }
                                }
                            })
                        }
                    } else {
                        strongSelf.removeSongFromPerson(per: initialArtistsArrFromDB[i], completion: { error in
                            completedProgress+=1
                            if let error = error {
                                completion(error)
                                return
                            } else {
                                if completedProgress == totalProgress {
                                    completion(nil)
                                    return
                                }
                            }
                        })
                    }
                }
            }
            
            if strongSelf.currSong.songProducers != nil {
                if !strongSelf.currSong.songProducers.isEmpty {
                    for i in 0 ... strongSelf.currSong.songProducers.count-1 {
                        if i < initialArtistsArrFromDB.count {
                            if !initialArtistsArrFromDB[i].contains(strongSelf.currSong.songProducers[i]) {
                                strongSelf.addSongToPerson(per: strongSelf.currSong.songProducers[i], completion: { error in
                                    completedProgress+=1
                                    if let error = error {
                                        completion(error)
                                        return
                                    } else {
                                        if completedProgress == totalProgress {
                                            completion(nil)
                                            return
                                        }
                                    }
                                })
                            }
                        } else {
                            strongSelf.addSongToPerson(per: strongSelf.currSong.songProducers[i], completion: { error in
                                completedProgress+=1
                                if let error = error {
                                    completion(error)
                                    return
                                } else {
                                    if completedProgress == totalProgress {
                                        completion(nil)
                                        return
                                    }
                                }
                            })
                        }
                    }
                }
            }
            
        })
    }
    
    func updateProducerRoles(ref: DatabaseReference, completion: @escaping ((Error?) -> Void)) {
        var initialArtistsArrFromDB:[String]!
        var totalProgress:Int = 0
        var completedProgress:Int = 0
        if currSong.songProducers.sorted() == initSong.songProducers.sorted() {
            completion(nil)
            return
        }
        
        getSongProducersInDB(ref: ref, completion: {[weak self] persons in
            guard let strongSelf = self else {return}
            initialArtistsArrFromDB = persons.sorted()
            
            if !initialArtistsArrFromDB.isEmpty {
                for i in 0 ... initialArtistsArrFromDB.count-1 {
                    if strongSelf.currSong.songProducers != nil {
                        if i < strongSelf.currSong.songProducers.count {
                            if !strongSelf.currSong.songProducers[i].contains(initialArtistsArrFromDB[i]) {
                                totalProgress+=1
                            }
                        } else {
                            totalProgress+=1
                        }
                    } else {
                        totalProgress+=1
                    }
                }
            }
            
            if strongSelf.currSong.songProducers != nil {
                if !strongSelf.currSong.songProducers.isEmpty {
                    for i in 0 ... strongSelf.currSong.songProducers.count-1 {
                        if i < initialArtistsArrFromDB.count {
                            if !initialArtistsArrFromDB[i].contains(strongSelf.currSong.songProducers[i]) {
                                totalProgress+=1
                            }
                        } else {
                            totalProgress+=1
                        }
                    }
                }
            }
            
            if !initialArtistsArrFromDB.isEmpty {
                for i in 0 ... initialArtistsArrFromDB.count-1 {
                    if strongSelf.currSong.songProducers != nil {
                        if i < strongSelf.currSong.songProducers.count {
                            if !strongSelf.currSong.songProducers[i].contains(initialArtistsArrFromDB[i]) {
                                strongSelf.removeSongFromProducerRoles(per: initialArtistsArrFromDB[i], completion: { error in
                                    completedProgress+=1
                                    if let error = error {
                                        completion(error)
                                        return
                                    } else {
                                        if completedProgress == totalProgress {
                                            completion(nil)
                                            return
                                        }
                                    }
                                })
                            }
                        } else {
                            strongSelf.removeSongFromProducerRoles(per: initialArtistsArrFromDB[i], completion: { error in
                                completedProgress+=1
                                if let error = error {
                                    completion(error)
                                    return
                                } else {
                                    if completedProgress == totalProgress {
                                        completion(nil)
                                        return
                                    }
                                }
                            })
                        }
                    } else {
                        strongSelf.removeSongFromProducerRoles(per: initialArtistsArrFromDB[i], completion: { error in
                            completedProgress+=1
                            if let error = error {
                                completion(error)
                                return
                            } else {
                                if completedProgress == totalProgress {
                                    completion(nil)
                                    return
                                }
                            }
                        })
                    }
                }
            }
            
            if strongSelf.currSong.songProducers != nil {
                if !strongSelf.currSong.songProducers.isEmpty {
                    for i in 0 ... strongSelf.currSong.songProducers.count-1 {
                        if i < initialArtistsArrFromDB.count {
                            if !initialArtistsArrFromDB[i].contains(strongSelf.currSong.songProducers[i]) {
                                strongSelf.addSongToProducerRoles(per: strongSelf.currSong.songProducers[i], completion: { error in
                                    completedProgress+=1
                                    if let error = error {
                                        completion(error)
                                        return
                                    } else {
                                        if completedProgress == totalProgress {
                                            completion(nil)
                                            return
                                        }
                                    }
                                })
                            }
                        } else {
                            strongSelf.addSongToProducerRoles(per: strongSelf.currSong.songProducers[i], completion: { error in
                                completedProgress+=1
                                if let error = error {
                                    completion(error)
                                    return
                                } else {
                                    if completedProgress == totalProgress {
                                        completion(nil)
                                        return
                                    }
                                }
                            })
                        }
                    }
                }
            }
            
        })
    }
    
    func removeSongFromProducerRoles(per: String, completion: @escaping ((Error?) -> Void)) {
        guard per.count == 6 else {
            completion(nil)
            return
        }
        DatabaseManager.shared.fetchPersonData(person: per, completion: {[weak self] result in
            guard let strongSelf = self else {return}
            switch result {
            case .success(let person):
                let ref = Database.database().reference().child("Registered Persons").child("\(person.name!)--\(person.dateRegisteredToApp!)--\(person.timeRegisteredToApp!)--\(person.toneDeafAppId)").child("Roles").child("Producer")
                let song = "\(strongSelf.currSong.toneDeafAppId)"
                var arrTo:[String] = []
                if let roles = person.roles {
                    if var art = roles["Producer"] as? [String] {
                        if art.contains(song) {
                            let index = art.firstIndex(of: song)
                            art.remove(at: index!)
                            arrTo = art
                        }
                    }
                }
                
                ref.setValue(arrTo.sorted(), withCompletionBlock: { error, reference in
                    if let error = error {
                        completion(error)
                        return
                    }
                    else {
                        completion(nil)
                        return
                    }
                })
            case .failure(let err):
                print("dsvgredfxbdfzx"+err.localizedDescription)
            }
        })
    }
    
    func addSongToProducerRoles(per: String, completion: @escaping ((Error?) -> Void)) {
        guard per.count == 6 else {
            completion(nil)
            return
        }
        
        DatabaseManager.shared.fetchPersonData(person: per, completion: {[weak self] result in
            guard let strongSelf = self else {return}
            switch result {
            case .success(let person):
                let ref = Database.database().reference().child("Registered Persons").child("\(person.name!)--\(person.dateRegisteredToApp!)--\(person.timeRegisteredToApp!)--\(person.toneDeafAppId)").child("Roles").child("Producer")
                let song = "\(strongSelf.currSong.toneDeafAppId)"
                var arrTo:[String] = []
                
                if let roles = person.roles {
                    if var art = roles["Producer"] as? [String] {
                        if !art.contains(song) {
                            art.append(song)
                        }
                        arrTo = art
                    } else {
                        arrTo = [song]
                    }
                } else {
                    arrTo = [song]
                }
                
                ref.setValue(arrTo.sorted(), withCompletionBlock: { error, reference in
                    if let error = error {
                        completion(error)
                        return
                    }
                    else {
                        completion(nil)
                        return
                    }
                })
            case .failure(let err):
                print("dsvgredfxbdfzx"+err.localizedDescription)
            }
        })
    }
    
    func updateAlbumProducer(ref: DatabaseReference, completion: @escaping ((Error?) -> Void)) {
        var initialArtistsArrFromDB:[String]!
        var totalProgress:Int = 0
        var completedProgress:Int = 0
        if currSong.songProducers.sorted() == initSong.songProducers.sorted() {
            completion(nil)
            return
        }
        if currSong.albums == nil {
            completion(nil)
            return
        }
        if currSong.albums!.isEmpty {
            completion(nil)
            return
        }
        
        let albums = currSong.albums!
        
        getSongProducersInDB(ref: ref, completion: {[weak self] persons in
            guard let strongSelf = self else {return}
            initialArtistsArrFromDB = persons.sorted()
            
            if !initialArtistsArrFromDB.isEmpty {
                for i in 0 ... initialArtistsArrFromDB.count-1 {
                    if strongSelf.currSong.songProducers != nil {
                        if i < strongSelf.currSong.songProducers.count {
                            if !strongSelf.currSong.songProducers[i].contains(initialArtistsArrFromDB[i]) {
                                for alb in albums {
                                    totalProgress+=1
                                }
                            }
                        } else {
                            for alb in albums {
                                totalProgress+=1
                            }
                        }
                    } else {
                        for alb in albums {
                            totalProgress+=1
                        }
                    }
                }
            }
            
            if strongSelf.currSong.songProducers != nil {
                if !strongSelf.currSong.songProducers.isEmpty {
                    for i in 0 ... strongSelf.currSong.songProducers.count-1 {
                        if i < initialArtistsArrFromDB.count {
                            if !initialArtistsArrFromDB[i].contains(strongSelf.currSong.songProducers[i]) {
                                for alb in albums {
                                    totalProgress+=1
                                }
                            }
                        } else {
                            for alb in albums {
                                totalProgress+=1
                            }
                        }
                    }
                }
            }
            
            if !initialArtistsArrFromDB.isEmpty {
                for i in 0 ... initialArtistsArrFromDB.count-1 {
                    if strongSelf.currSong.songProducers != nil {
                        if i < strongSelf.currSong.songProducers.count {
                            if !strongSelf.currSong.songProducers[i].contains(initialArtistsArrFromDB[i]) {
                                for alb in albums {
                                    strongSelf.removeProducerFromAlbum(alb: alb, per: initialArtistsArrFromDB[i], completion: { error in
                                        completedProgress+=1
                                        if let error = error {
                                            completion(error)
                                            return
                                        } else {
                                            if completedProgress == totalProgress {
                                                completion(nil)
                                                return
                                            }
                                        }
                                    })
                                }
                            }
                        } else {
                            for alb in albums {
                                strongSelf.removeProducerFromAlbum(alb: alb, per: initialArtistsArrFromDB[i], completion: { error in
                                    completedProgress+=1
                                    if let error = error {
                                        completion(error)
                                        return
                                    } else {
                                        if completedProgress == totalProgress {
                                            completion(nil)
                                            return
                                        }
                                    }
                                })
                            }
                        }
                    } else {
                        for alb in albums {
                            strongSelf.removeProducerFromAlbum(alb: alb, per: initialArtistsArrFromDB[i], completion: { error in
                                completedProgress+=1
                                if let error = error {
                                    completion(error)
                                    return
                                } else {
                                    if completedProgress == totalProgress {
                                        completion(nil)
                                        return
                                    }
                                }
                            })
                        }
                    }
                }
            }
            
            if strongSelf.currSong.songProducers != nil {
                if !strongSelf.currSong.songProducers.isEmpty {
                    for i in 0 ... strongSelf.currSong.songProducers.count-1 {
                        if i < initialArtistsArrFromDB.count {
                            if !initialArtistsArrFromDB[i].contains(strongSelf.currSong.songProducers[i]) {
                                for album in albums {
                                    strongSelf.addProducerToAlbum(alb: album, per: strongSelf.currSong.songProducers[i], completion: { error in
                                        completedProgress+=1
                                        if let error = error {
                                            completion(error)
                                            return
                                        } else {
                                            if completedProgress == totalProgress {
                                                completion(nil)
                                                return
                                            }
                                        }
                                    })
                                }
                            }
                        } else {
                            for album in albums {
                                strongSelf.addProducerToAlbum(alb: album, per: strongSelf.currSong.songProducers[i], completion: { error in
                                    completedProgress+=1
                                    if let error = error {
                                        completion(error)
                                        return
                                    } else {
                                        if completedProgress == totalProgress {
                                            completion(nil)
                                            return
                                        }
                                    }
                                })
                            }
                        }
                    }
                }
            }
            
        })
    }
    
    func removeProducerFromAlbum(alb: String, per: String, completion: @escaping ((Error?) -> Void)) {
        guard alb.count == 8 else {
            completion(nil)
            return
        }
        DatabaseManager.shared.findAlbumById(albumId: alb, completion: {[weak self] result in
            guard let strongSelf = self else {return}
            switch result {
            case .success(let album):
                let ref = Database.database().reference().child("Music Content").child("Albums").child("\(albumContentTag)--\(album.name)--\(album.toneDeafAppId)").child("REQUIRED").child("All Producers")
                var arrTo:[String] = []
                DatabaseManager.shared.fetchPersonData(person: per, completion: { result in
                    guard let strongSelf = self else {return}
                    switch result {
                    case .success(let person):
                        var roleMArkedOnAnotherSong:Bool = false
                        if let asong = album.songs {
                            for song in asong {
                                if let proles = person.roles {
                                    if let parr = proles["Producer"] as? [String] {
                                        if parr.contains(song) {
                                            if song != strongSelf.currSong.toneDeafAppId {
                                                roleMArkedOnAnotherSong = true
                                            }
                                        }
                                    }
                                }
                            }
                        }
                        if let asong = album.instrumentals {
                            for song in asong {
                                if let proles = person.roles {
                                    if let parr = proles["Producer"] as? [String] {
                                        if parr.contains(song) {
                                            if song != strongSelf.currSong.toneDeafAppId {
                                                roleMArkedOnAnotherSong = true
                                            }
                                        }
                                    }
                                }
                            }
                        }
                        if roleMArkedOnAnotherSong == false {
                            var arrr = album.producers
                            let index = arrr.firstIndex(of: per)
                            arrr.remove(at: index!)
                            arrTo = arrr
                            ref.setValue(arrTo.sorted(), withCompletionBlock: { error, reference in
                                if let error = error {
                                    completion(error)
                                    return
                                }
                                else {
                                    strongSelf.removeAlbumFromPersonProducer(alb: alb, per: per, completion: { error in
                                        if let error = error {
                                            completion(error)
                                            return
                                        }
                                        else {
                                            completion(nil)
                                            return
                                        }
                                    })
                                }
                            })
                        } else {
                            completion(nil)
                        }
                        
                    case .failure(let err):
                        print("dsvgredfxbdfzx"+err.localizedDescription)
                    }
                    
                })
            case .failure(let err):
                print("dsvgredfxbdfzx"+err.localizedDescription)
            }
        })
    }
    
    func addProducerToAlbum(alb: String,per: String, completion: @escaping ((Error?) -> Void)) {
        guard alb.count == 8 else {
            completion(nil)
            return
        }
        
        DatabaseManager.shared.findAlbumById(albumId: alb, completion: {[weak self] result in
            guard let strongSelf = self else {return}
            switch result {
            case .success(let album):
                let ref = Database.database().reference().child("Music Content").child("Albums").child("\(albumContentTag)--\(album.name)--\(album.toneDeafAppId)").child("REQUIRED").child("All Producers")
                var arrTo:[String] = []
                
                var arrr = album.producers
                if !arrr.contains(per) {
                    arrr.append(per)
                }
                arrTo = arrr
                
                
                ref.setValue(arrTo.sorted(), withCompletionBlock: { error, reference in
                    if let error = error {
                        completion(error)
                        return
                    }
                    else {
                        strongSelf.addAlbumToPersonProducer(alb: [alb], per: per, completion: { error in
                            if let error = error {
                                completion(error)
                                return
                            }
                            else {
                                completion(nil)
                                return
                            }
                        })
                        
                    }
                })
            case .failure(let err):
                print("dsvgredfxbdfzx"+err.localizedDescription)
            }
        })
    }
    
    func addAlbumToPersonProducer(alb: [String],per: String, completion: @escaping ((Error?) -> Void)) {
        DatabaseManager.shared.fetchPersonData(person: per, completion: {[weak self] result in
            guard let strongSelf = self else {return}
            switch result {
            case .success(let person):
                let ref = Database.database().reference().child("Registered Persons").child("\(person.name!)--\(person.dateRegisteredToApp!)--\(person.timeRegisteredToApp!)--\(person.toneDeafAppId)").child("Albums")
                var arrTo:[String] = []
                strongSelf.getPersonAlbumsInDB(ref: Database.database().reference().child("Registered Persons").child("\(person.name!)--\(person.dateRegisteredToApp!)--\(person.timeRegisteredToApp!)--\(person.toneDeafAppId)"), completion: { albumns in
                    var albbums = albumns
                    for element in alb {
                        if !albbums.contains(element) {
                            albbums.append(element)
                            arrTo = albbums
                        } else {
                            arrTo = albbums
                        }
                    }
                    ref.setValue(arrTo.sorted(), withCompletionBlock: { error, reference in
                        if let error = error {
                            completion(error)
                            return
                        }
                        else {
                            let ref2 = Database.database().reference().child("Registered Persons").child("\(person.name!)--\(person.dateRegisteredToApp!)--\(person.timeRegisteredToApp!)--\(person.toneDeafAppId)").child("Roles").child("Producer")
                            var arrTo2:[String] = []
                            if let currole = person.roles {
                                if var arrrry = currole["Producer"] as? [String] {
                                    for element in alb {
                                        if !arrrry.contains(element) {
                                            arrrry.append(element)
                                            arrTo2 = arrrry.sorted()
                                        } else {
                                            arrTo2 = arrrry.sorted()
                                        }
                                    }
                                } else {
                                    arrTo2 = alb
                                }
                            } else {
                                arrTo2 = alb
                            }
                            ref2.setValue(arrTo2.sorted(), withCompletionBlock: { error, reference in
                                if let error = error {
                                    completion(error)
                                    return
                                }
                                else {
                                    completion(nil)
                                    return
                                }
                            })
                        }
                    })
                })
            case .failure(let err):
                print("dsvgredfxbdfzx"+err.localizedDescription)
            }
        })
    }
    
    func removeAlbumFromPersonProducer(alb: String,per: String, completion: @escaping ((Error?) -> Void)) {
        DatabaseManager.shared.fetchPersonData(person: per, completion: {[weak self] result in
            guard let strongSelf = self else {return}
            switch result {
            case .success(let person):
                let ref = Database.database().reference().child("Registered Persons").child("\(person.name!)--\(person.dateRegisteredToApp!)--\(person.timeRegisteredToApp!)--\(person.toneDeafAppId)").child("Albums")
                var arrTo:[String] = []
                if var albbums = person.albums {
                    if let index = albbums.firstIndex(of: alb) {
                        albbums.remove(at: index)
                    }
                    for element in strongSelf.removedAlbs {
                        if albbums.contains(element) {
                            if let index = albbums.firstIndex(of: element) {
                                albbums.remove(at: index)
                            }
                        }
                    }
                    arrTo = albbums
                }
                ref.setValue(arrTo.sorted(), withCompletionBlock: { error, reference in
                    if let error = error {
                        completion(error)
                        return
                    }
                    else {
                        let ref2 = Database.database().reference().child("Registered Persons").child("\(person.name!)--\(person.dateRegisteredToApp!)--\(person.timeRegisteredToApp!)--\(person.toneDeafAppId)").child("Roles").child("Producer")
                        var arrTo2:[String] = []
                        if let currole = person.roles {
                            if var arrrry = currole["Producer"] as? [String] {
                                if let index = arrrry.firstIndex(of: alb) {
                                    arrrry.remove(at: index)
                                }
                                for element in strongSelf.removedAlbs {
                                    if arrrry.contains(element) {
                                        if let index = arrrry.firstIndex(of: element) {
                                            arrrry.remove(at: index)
                                        }
                                    }
                                }
                                arrTo2 = arrrry.sorted()
                            }
                        }
                        if !strongSelf.removedAlbs.contains(alb) {
                            strongSelf.removedAlbs.append(alb)
                        }
                        ref2.setValue(arrTo2.sorted(), withCompletionBlock: { error, reference in
                            if let error = error {
                                completion(error)
                                return
                            }
                            else {
                                completion(nil)
                                return
                            }
                        })
                    }
                })
            case .failure(let err):
                print("dsvgredfxbdfzx"+err.localizedDescription)
            }
        })
    }
    
    //MARK: - Writers
    func processWriters(initialSong: SongData, currentSong: SongData, completion: @escaping (([Error]?) -> Void)) {
        initSong = initialSong
        currSong = currentSong
        
        initRef = Database.database().reference().child("Music Content").child("Songs").child("\(songContentTag)--\(initSong.name)--\(initSong.toneDeafAppId)")
        currRef = Database.database().reference().child("Music Content").child("Songs").child("\(songContentTag)--\(currSong.name)--\(currSong.toneDeafAppId)")
        var errors:[Error] = []
        var dataUploadCompletionStatus1:Bool!
        var dataUploadCompletionStatus2:Bool!
        var dataUploadCompletionStatus3:Bool!
        var dataUploadCompletionStatus4:Bool!
        var dataUploadCompletionStatus5:Bool!
        var dataUploadCompletionStatus6:Bool!
        var dataUploadCompletionStatus7:Bool!
        var dataUploadCompletionStatus8:Bool!
        var dataUploadCompletionStatus9:Bool!
        var dataUploadCompletionStatus10:Bool!
        
        let aqueue = DispatchQueue(label: "myhjvkheditingQsongWriterhfdChangessseue")
        let agroup = DispatchGroup()
        let array:[Int] = [1,2,3,4]
        for i in array {
            agroup.enter()
            aqueue.async { [weak self] in
                guard let strongSelf = self else {return}
                switch i {
                case 1:
                    strongSelf.updateSongWriters(ref: strongSelf.currRef, completion: {err in
                        if let error = err {
                            dataUploadCompletionStatus1 = false
                            errors.append(error)
                        } else {
                            dataUploadCompletionStatus1 = true
                            print("Song Writer Update done \(1)")
                        }
                        agroup.leave()
                    })
                case 2:
                    strongSelf.updateWriterSongs(ref: strongSelf.currRef, completion: {err in
                        if let error = err {
                            dataUploadCompletionStatus2 = false
                            errors.append(error)
                        } else {
                            dataUploadCompletionStatus2 = true
                            print("Writer songs Update done \(1)")
                        }
                        agroup.leave()
                    })
                case 3:
                    strongSelf.updateWriterRoles(ref: strongSelf.currRef, completion: {err in
                        if let error = err {
                            dataUploadCompletionStatus3 = false
                            errors.append(error)
                        } else {
                            dataUploadCompletionStatus3 = true
                            print("Writer roles Update done \(1)")
                        }
                        agroup.leave()
                    })
                case 4:
                    strongSelf.updateAlbumWriter(ref: strongSelf.currRef, completion: {err in
                        if let error = err {
                            dataUploadCompletionStatus3 = false
                            errors.append(error)
                        } else {
                            dataUploadCompletionStatus3 = true
                            print("Writer roles Update done \(1)")
                        }
                        agroup.leave()
                    })
                default:
                    break
                }
            }
        }
        agroup.notify(queue: DispatchQueue.main) {
            if dataUploadCompletionStatus1 == false || dataUploadCompletionStatus2 == false || dataUploadCompletionStatus3 == false || dataUploadCompletionStatus4 == false {
                completion(errors)
                return
            } else {
                completion(nil)
            }
        }
    }
    
    func updateSongWriters(ref: DatabaseReference, completion: @escaping ((Error?) -> Void)) {
        var initialArtistsArrFromDB:[String]!
        
        if currSong.songWriters!.sorted() == initSong.songWriters?.sorted() {
            completion(nil)
            return
        }
        getSongWritersInDB(ref: ref, completion: {[weak self] persons in
            guard let strongSelf = self else {return}
            initialArtistsArrFromDB = persons.sorted()
            
            if !initialArtistsArrFromDB.isEmpty {
                var removalCounter = 0
                for i in 0 ... initialArtistsArrFromDB.count-1 {
                    if strongSelf.currSong.songWriters != nil {
                        if i < strongSelf.currSong.songWriters!.count {
                            if !strongSelf.currSong.songWriters![i].contains(initialArtistsArrFromDB[i]) {
                                let index = initialArtistsArrFromDB.firstIndex(of: initialArtistsArrFromDB[i])
                                initialArtistsArrFromDB.remove(at: index!)
                                removalCounter+=1
                            }
                        } else {
                            let index = initialArtistsArrFromDB.firstIndex(of: initialArtistsArrFromDB[i-removalCounter])
                            initialArtistsArrFromDB.remove(at: index!)
                            removalCounter+=1
                        }
                    } else {
                        let index = initialArtistsArrFromDB.firstIndex(of: initialArtistsArrFromDB[i-removalCounter])
                        initialArtistsArrFromDB.remove(at: index!)
                        removalCounter+=1
                    }
                }
            }
            
            if strongSelf.currSong.songWriters != nil {
                if !strongSelf.currSong.songWriters!.isEmpty {
                    for i in 0 ... strongSelf.currSong.songWriters!.count-1 {
                        if i < initialArtistsArrFromDB.count {
                            if !initialArtistsArrFromDB[i].contains(strongSelf.currSong.songWriters![i]) {
                                initialArtistsArrFromDB.append(strongSelf.currSong.songWriters![i])
                            }
                        } else {
                            initialArtistsArrFromDB.append(strongSelf.currSong.songWriters![i])
                        }
                    }
                }
            }
            ref.child("REQUIRED").child("Writers").setValue(initialArtistsArrFromDB.sorted(), withCompletionBlock: { error, reference in
                if let error = error {
                    completion(error)
                    return
                }
                else {
                    completion(nil)
                    return
                }
            })
            
        })
    }
    
    func getSongWritersInDB(ref: DatabaseReference, completion: @escaping (([String]) -> Void)) {
        ref.child("REQUIRED").child("Writers").observeSingleEvent(of: .value, with: { snapshot in
            var mysongsArray:[String] = []
            if let val = snapshot.value {
                let valu = val as? [String]
                guard let value = valu else {
                    completion(mysongsArray)
                    return}
                if value[0] != "" {
                    mysongsArray = value
                }
                completion(mysongsArray)
            } else {
                completion(mysongsArray)
            }
        })
    }
    
    func updateWriterSongs(ref: DatabaseReference, completion: @escaping ((Error?) -> Void)) {
        var initialArtistsArrFromDB:[String]!
        var totalProgress:Int = 0
        var completedProgress:Int = 0
        if currSong.songWriters!.sorted() == initSong.songWriters?.sorted() {
            completion(nil)
            return
        }
        
        getSongWritersInDB(ref: ref, completion: {[weak self] persons in
            guard let strongSelf = self else {return}
            initialArtistsArrFromDB = persons.sorted()
            
            if !initialArtistsArrFromDB.isEmpty {
                var removalCounter = 0
                for i in 0 ... initialArtistsArrFromDB.count-1 {
                    if strongSelf.currSong.songWriters != nil {
                        if i < strongSelf.currSong.songWriters!.count {
                            if !strongSelf.currSong.songWriters![i].contains(initialArtistsArrFromDB[i]) {
                                totalProgress+=1
                            }
                        } else {
                            totalProgress+=1
                        }
                    } else {
                        totalProgress+=1
                    }
                }
            }
            
            if strongSelf.currSong.songWriters != nil {
                if !strongSelf.currSong.songWriters!.isEmpty {
                    for i in 0 ... strongSelf.currSong.songWriters!.count-1 {
                        if i < initialArtistsArrFromDB.count {
                            if !initialArtistsArrFromDB[i].contains(strongSelf.currSong.songWriters![i]) {
                                totalProgress+=1
                            }
                        } else {
                            totalProgress+=1
                        }
                    }
                }
            }
            
            if !initialArtistsArrFromDB.isEmpty {
                for i in 0 ... initialArtistsArrFromDB.count-1 {
                    if strongSelf.currSong.songWriters != nil {
                        if i < strongSelf.currSong.songWriters!.count {
                            if !strongSelf.currSong.songWriters![i].contains(initialArtistsArrFromDB[i]) {
                                strongSelf.removeSongFromPerson(per: initialArtistsArrFromDB[i], completion: { error in
                                    completedProgress+=1
                                    if let error = error {
                                        completion(error)
                                        return
                                    } else {
                                        if completedProgress == totalProgress {
                                            completion(nil)
                                            return
                                        }
                                    }
                                })
                            }
                        } else {
                            strongSelf.removeSongFromPerson(per: initialArtistsArrFromDB[i], completion: { error in
                                completedProgress+=1
                                if let error = error {
                                    completion(error)
                                    return
                                } else {
                                    if completedProgress == totalProgress {
                                        completion(nil)
                                        return
                                    }
                                }
                            })
                        }
                    } else {
                        strongSelf.removeSongFromPerson(per: initialArtistsArrFromDB[i], completion: { error in
                            completedProgress+=1
                            if let error = error {
                                completion(error)
                                return
                            } else {
                                if completedProgress == totalProgress {
                                    completion(nil)
                                    return
                                }
                            }
                        })
                    }
                }
            }
            
            if strongSelf.currSong.songWriters != nil {
                if !strongSelf.currSong.songWriters!.isEmpty {
                    for i in 0 ... strongSelf.currSong.songWriters!.count-1 {
                        if i < initialArtistsArrFromDB.count {
                            if !initialArtistsArrFromDB[i].contains(strongSelf.currSong.songWriters![i]) {
                                strongSelf.addSongToPerson(per: strongSelf.currSong.songWriters![i], completion: { error in
                                    completedProgress+=1
                                    if let error = error {
                                        completion(error)
                                        return
                                    } else {
                                        if completedProgress == totalProgress {
                                            completion(nil)
                                            return
                                        }
                                    }
                                })
                            }
                        } else {
                            strongSelf.addSongToPerson(per: strongSelf.currSong.songWriters![i], completion: { error in
                                completedProgress+=1
                                if let error = error {
                                    completion(error)
                                    return
                                } else {
                                    if completedProgress == totalProgress {
                                        completion(nil)
                                        return
                                    }
                                }
                            })
                        }
                    }
                }
            }
            
        })
    }
    
    func updateWriterRoles(ref: DatabaseReference, completion: @escaping ((Error?) -> Void)) {
        var initialArtistsArrFromDB:[String]!
        var totalProgress:Int = 0
        var completedProgress:Int = 0
        if currSong.songWriters!.sorted() == initSong.songWriters?.sorted() {
            completion(nil)
            return
        }
        
        getSongWritersInDB(ref: ref, completion: {[weak self] persons in
            guard let strongSelf = self else {return}
            initialArtistsArrFromDB = persons.sorted()
            
            if !initialArtistsArrFromDB.isEmpty {
                for i in 0 ... initialArtistsArrFromDB.count-1 {
                    if strongSelf.currSong.songWriters != nil {
                        if i < strongSelf.currSong.songWriters!.count {
                            if !strongSelf.currSong.songWriters![i].contains(initialArtistsArrFromDB[i]) {
                                totalProgress+=1
                            }
                        } else {
                            totalProgress+=1
                        }
                    } else {
                        totalProgress+=1
                    }
                }
            }
            
            if strongSelf.currSong.songWriters != nil {
                if !strongSelf.currSong.songWriters!.isEmpty {
                    for i in 0 ... strongSelf.currSong.songWriters!.count-1 {
                        if i < initialArtistsArrFromDB.count {
                            if !initialArtistsArrFromDB[i].contains(strongSelf.currSong.songWriters![i]) {
                                totalProgress+=1
                            }
                        } else {
                            totalProgress+=1
                        }
                    }
                }
            }
            
            if !initialArtistsArrFromDB.isEmpty {
                for i in 0 ... initialArtistsArrFromDB.count-1 {
                    if strongSelf.currSong.songWriters != nil {
                        if i < strongSelf.currSong.songWriters!.count {
                            if !strongSelf.currSong.songWriters![i].contains(initialArtistsArrFromDB[i]) {
                                strongSelf.removeSongFromWriterRoles(per: initialArtistsArrFromDB[i], completion: { error in
                                    completedProgress+=1
                                    if let error = error {
                                        completion(error)
                                        return
                                    } else {
                                        if completedProgress == totalProgress {
                                            completion(nil)
                                            return
                                        }
                                    }
                                })
                            }
                        } else {
                            strongSelf.removeSongFromWriterRoles(per: initialArtistsArrFromDB[i], completion: { error in
                                completedProgress+=1
                                if let error = error {
                                    completion(error)
                                    return
                                } else {
                                    if completedProgress == totalProgress {
                                        completion(nil)
                                        return
                                    }
                                }
                            })
                        }
                    } else {
                        strongSelf.removeSongFromWriterRoles(per: initialArtistsArrFromDB[i], completion: { error in
                            completedProgress+=1
                            if let error = error {
                                completion(error)
                                return
                            } else {
                                if completedProgress == totalProgress {
                                    completion(nil)
                                    return
                                }
                            }
                        })
                    }
                }
            }
            
            if strongSelf.currSong.songWriters != nil {
                if !strongSelf.currSong.songWriters!.isEmpty {
                    for i in 0 ... strongSelf.currSong.songWriters!.count-1 {
                        if i < initialArtistsArrFromDB.count {
                            if !initialArtistsArrFromDB[i].contains(strongSelf.currSong.songWriters![i]) {
                                strongSelf.addSongToWriterRoles(per: strongSelf.currSong.songWriters![i], completion: { error in
                                    completedProgress+=1
                                    if let error = error {
                                        completion(error)
                                        return
                                    } else {
                                        if completedProgress == totalProgress {
                                            completion(nil)
                                            return
                                        }
                                    }
                                })
                            }
                        } else {
                            strongSelf.addSongToWriterRoles(per: strongSelf.currSong.songWriters![i], completion: { error in
                                completedProgress+=1
                                if let error = error {
                                    completion(error)
                                    return
                                } else {
                                    if completedProgress == totalProgress {
                                        completion(nil)
                                        return
                                    }
                                }
                            })
                        }
                    }
                }
            }
            
        })
    }
    
    func removeSongFromWriterRoles(per: String, completion: @escaping ((Error?) -> Void)) {
        guard per.count == 6 else {
            completion(nil)
            return
        }
        DatabaseManager.shared.fetchPersonData(person: per, completion: {[weak self] result in
            guard let strongSelf = self else {return}
            switch result {
            case .success(let person):
                let ref = Database.database().reference().child("Registered Persons").child("\(person.name!)--\(person.dateRegisteredToApp!)--\(person.timeRegisteredToApp!)--\(person.toneDeafAppId)").child("Roles").child("Writer")
                let song = "\(strongSelf.currSong.toneDeafAppId)"
                var arrTo:[String] = []
                if let roles = person.roles {
                    if var art = roles["Writer"] as? [String] {
                        if art.contains(song) {
                            let index = art.firstIndex(of: song)
                            art.remove(at: index!)
                            arrTo = art
                        }
                    }
                }
                
                ref.setValue(arrTo.sorted(), withCompletionBlock: { error, reference in
                    if let error = error {
                        completion(error)
                        return
                    }
                    else {
                        completion(nil)
                        return
                    }
                })
            case .failure(let err):
                print("dsvgredfxbdfzx"+err.localizedDescription)
            }
        })
    }
    
    func addSongToWriterRoles(per: String, completion: @escaping ((Error?) -> Void)) {
        guard per.count == 6 else {
            completion(nil)
            return
        }
        
        DatabaseManager.shared.fetchPersonData(person: per, completion: {[weak self] result in
            guard let strongSelf = self else {return}
            switch result {
            case .success(let person):
                let ref = Database.database().reference().child("Registered Persons").child("\(person.name!)--\(person.dateRegisteredToApp!)--\(person.timeRegisteredToApp!)--\(person.toneDeafAppId)").child("Roles").child("Writer")
                let song = "\(strongSelf.currSong.toneDeafAppId)"
                var arrTo:[String] = []
                
                if let roles = person.roles {
                    if var art = roles["Writer"] as? [String] {
                        if !art.contains(song) {
                            art.append(song)
                        }
                        arrTo = art
                    } else {
                        arrTo = [song]
                    }
                } else {
                    arrTo = [song]
                }
                
                ref.setValue(arrTo.sorted(), withCompletionBlock: { error, reference in
                    if let error = error {
                        completion(error)
                        return
                    }
                    else {
                        completion(nil)
                        return
                    }
                })
            case .failure(let err):
                print("dsvgredfxbdfzx"+err.localizedDescription)
            }
        })
    }
    
    func updateAlbumWriter(ref: DatabaseReference, completion: @escaping ((Error?) -> Void)) {
        var initialArtistsArrFromDB:[String]!
        var totalProgress:Int = 0
        var completedProgress:Int = 0
        if currSong.songWriters!.sorted() == initSong.songWriters?.sorted() {
            completion(nil)
            return
        }
        if currSong.albums == nil {
            completion(nil)
            return
        }
        if currSong.albums!.isEmpty {
            completion(nil)
            return
        }
        
        let albums = currSong.albums!
        
        getSongWritersInDB(ref: ref, completion: {[weak self] persons in
            guard let strongSelf = self else {return}
            initialArtistsArrFromDB = persons.sorted()
            
            if !initialArtistsArrFromDB.isEmpty {
                for i in 0 ... initialArtistsArrFromDB.count-1 {
                    if strongSelf.currSong.songWriters != nil {
                        if i < strongSelf.currSong.songWriters!.count {
                            if !strongSelf.currSong.songWriters![i].contains(initialArtistsArrFromDB[i]) {
                                for alb in albums {
                                    totalProgress+=1
                                }
                            }
                        } else {
                            for alb in albums {
                                totalProgress+=1
                            }
                        }
                    } else {
                        for alb in albums {
                            totalProgress+=1
                        }
                    }
                }
            }
            
            if strongSelf.currSong.songWriters != nil {
                if !strongSelf.currSong.songWriters!.isEmpty {
                    for i in 0 ... strongSelf.currSong.songWriters!.count-1 {
                        if i < initialArtistsArrFromDB.count {
                            if !initialArtistsArrFromDB[i].contains(strongSelf.currSong.songWriters![i]) {
                                for alb in albums {
                                    totalProgress+=1
                                }
                            }
                        } else {
                            for alb in albums {
                                totalProgress+=1
                            }
                        }
                    }
                }
            }
            
            if !initialArtistsArrFromDB.isEmpty {
                for i in 0 ... initialArtistsArrFromDB.count-1 {
                    if strongSelf.currSong.songWriters != nil {
                        if i < strongSelf.currSong.songWriters!.count {
                            if !strongSelf.currSong.songWriters![i].contains(initialArtistsArrFromDB[i]) {
                                for alb in albums {
                                    strongSelf.removeWriterFromAlbum(alb: alb, per: initialArtistsArrFromDB[i], completion: { error in
                                        completedProgress+=1
                                        if let error = error {
                                            completion(error)
                                            return
                                        } else {
                                            if completedProgress == totalProgress {
                                                completion(nil)
                                                return
                                            }
                                        }
                                    })
                                }
                            }
                        } else {
                            for alb in albums {
                                strongSelf.removeWriterFromAlbum(alb: alb, per: initialArtistsArrFromDB[i], completion: { error in
                                    completedProgress+=1
                                    if let error = error {
                                        completion(error)
                                        return
                                    } else {
                                        if completedProgress == totalProgress {
                                            completion(nil)
                                            return
                                        }
                                    }
                                })
                            }
                        }
                    } else {
                        for alb in albums {
                            strongSelf.removeWriterFromAlbum(alb: alb, per: initialArtistsArrFromDB[i], completion: { error in
                                completedProgress+=1
                                if let error = error {
                                    completion(error)
                                    return
                                } else {
                                    if completedProgress == totalProgress {
                                        completion(nil)
                                        return
                                    }
                                }
                            })
                        }
                    }
                }
            }
            
            if strongSelf.currSong.songWriters != nil {
                if !strongSelf.currSong.songWriters!.isEmpty {
                    for i in 0 ... strongSelf.currSong.songWriters!.count-1 {
                        if i < initialArtistsArrFromDB.count {
                            if !initialArtistsArrFromDB[i].contains(strongSelf.currSong.songWriters![i]) {
                                for album in albums {
                                    strongSelf.addWriterToAlbum(alb: album, per: strongSelf.currSong.songWriters![i], completion: { error in
                                        completedProgress+=1
                                        if let error = error {
                                            completion(error)
                                            return
                                        } else {
                                            if completedProgress == totalProgress {
                                                completion(nil)
                                                return
                                            }
                                        }
                                    })
                                }
                            }
                        } else {
                            for album in albums {
                                strongSelf.addWriterToAlbum(alb: album, per: strongSelf.currSong.songWriters![i], completion: { error in
                                    completedProgress+=1
                                    if let error = error {
                                        completion(error)
                                        return
                                    } else {
                                        if completedProgress == totalProgress {
                                            completion(nil)
                                            return
                                        }
                                    }
                                })
                            }
                        }
                    }
                }
            }
            
        })
    }
    
    func removeWriterFromAlbum(alb: String, per: String, completion: @escaping ((Error?) -> Void)) {
        guard alb.count == 8 else {
            completion(nil)
            return
        }
        DatabaseManager.shared.findAlbumById(albumId: alb, completion: {[weak self] result in
            guard let strongSelf = self else {return}
            switch result {
            case .success(let album):
                let ref = Database.database().reference().child("Music Content").child("Albums").child("\(albumContentTag)--\(album.name)--\(album.toneDeafAppId)").child("REQUIRED").child("All Writers")
                var arrTo:[String] = []
                DatabaseManager.shared.fetchPersonData(person: per, completion: { result in
                    guard let strongSelf = self else {return}
                    switch result {
                    case .success(let person):
                        var roleMArkedOnAnotherSong:Bool = false
                        if let asong = album.songs {
                            for song in asong {
                                if let proles = person.roles {
                                    if let parr = proles["Writer"] as? [String] {
                                        if parr.contains(song) {
                                            if song != strongSelf.currSong.toneDeafAppId {
                                                roleMArkedOnAnotherSong = true
                                            }
                                        }
                                    }
                                }
                            }
                        }
                        if let asong = album.instrumentals {
                            for song in asong {
                                if let proles = person.roles {
                                    if let parr = proles["Writer"] as? [String] {
                                        if parr.contains(song) {
                                            if song != strongSelf.currSong.toneDeafAppId {
                                                roleMArkedOnAnotherSong = true
                                            }
                                        }
                                    }
                                }
                            }
                        }
                        if roleMArkedOnAnotherSong == false {
                            if var arrr = album.writers {
                                let index = arrr.firstIndex(of: per)
                                arrr.remove(at: index!)
                                arrTo = arrr
                            } else {
                                var arrr:[String] = []
                                let index = arrr.firstIndex(of: per)
                                arrr.remove(at: index!)
                                arrTo = arrr
                            }
                            ref.setValue(arrTo.sorted(), withCompletionBlock: { error, reference in
                                if let error = error {
                                    completion(error)
                                    return
                                }
                                else {
                                    strongSelf.removeAlbumFromPersonWriter(alb: alb, per: per, completion: { error in
                                        if let error = error {
                                            completion(error)
                                            return
                                        }
                                        else {
                                            completion(nil)
                                            return
                                        }
                                    })
                                }
                            })
                        } else {
                            completion(nil)
                        }
                        
                    case .failure(let err):
                        print("dsvgredfxbdfzx"+err.localizedDescription)
                    }
                    
                })
            case .failure(let err):
                print("dsvgredfxbdfzx"+err.localizedDescription)
            }
        })
    }
    
    func addWriterToAlbum(alb: String,per: String, completion: @escaping ((Error?) -> Void)) {
        guard alb.count == 8 else {
            completion(nil)
            return
        }
        
        DatabaseManager.shared.findAlbumById(albumId: alb, completion: {[weak self] result in
            guard let strongSelf = self else {return}
            switch result {
            case .success(let album):
                let ref = Database.database().reference().child("Music Content").child("Albums").child("\(albumContentTag)--\(album.name)--\(album.toneDeafAppId)").child("REQUIRED").child("All Writers")
                var arrTo:[String] = []
                
                if var arrr = album.writers {
                    if !arrr.contains(per) {
                        arrr.append(per)
                    }
                    arrTo = arrr
                } else {
                    var arrr:[String] = []
                    arrr.append(per)
                    arrTo = arrr
                }
                
                
                ref.setValue(arrTo.sorted(), withCompletionBlock: { error, reference in
                    if let error = error {
                        completion(error)
                        return
                    }
                    else {
                        strongSelf.addAlbumToPersonWriter(alb: [alb], per: per, completion: { error in
                            if let error = error {
                                completion(error)
                                return
                            }
                            else {
                                completion(nil)
                                return
                            }
                        })
                        
                    }
                })
            case .failure(let err):
                print("dsvgredfxbdfzx"+err.localizedDescription)
            }
        })
    }
    
    func addAlbumToPersonWriter(alb: [String],per: String, completion: @escaping ((Error?) -> Void)) {
        DatabaseManager.shared.fetchPersonData(person: per, completion: {[weak self] result in
            guard let strongSelf = self else {return}
            switch result {
            case .success(let person):
                let ref = Database.database().reference().child("Registered Persons").child("\(person.name!)--\(person.dateRegisteredToApp!)--\(person.timeRegisteredToApp!)--\(person.toneDeafAppId)").child("Albums")
                var arrTo:[String] = []
                strongSelf.getPersonAlbumsInDB(ref: Database.database().reference().child("Registered Persons").child("\(person.name!)--\(person.dateRegisteredToApp!)--\(person.timeRegisteredToApp!)--\(person.toneDeafAppId)"), completion: { albumns in
                    var albbums = albumns
                    for element in alb {
                        if !albbums.contains(element) {
                            albbums.append(element)
                            arrTo = albbums
                        } else {
                            arrTo = albbums
                        }
                    }
                    ref.setValue(arrTo.sorted(), withCompletionBlock: { error, reference in
                        if let error = error {
                            completion(error)
                            return
                        }
                        else {
                            let ref2 = Database.database().reference().child("Registered Persons").child("\(person.name!)--\(person.dateRegisteredToApp!)--\(person.timeRegisteredToApp!)--\(person.toneDeafAppId)").child("Roles").child("Writer")
                            var arrTo2:[String] = []
                            if let currole = person.roles {
                                if var arrrry = currole["Writer"] as? [String] {
                                    for element in alb {
                                        if !arrrry.contains(element) {
                                            arrrry.append(element)
                                            arrTo2 = arrrry.sorted()
                                        } else {
                                            arrTo2 = arrrry.sorted()
                                        }
                                    }
                                } else {
                                    arrTo2 = alb
                                }
                            } else {
                                arrTo2 = alb
                            }
                            ref2.setValue(arrTo2.sorted(), withCompletionBlock: { error, reference in
                                if let error = error {
                                    completion(error)
                                    return
                                }
                                else {
                                    completion(nil)
                                    return
                                }
                            })
                        }
                    })
                })
            case .failure(let err):
                print("dsvgredfxbdfzx"+err.localizedDescription)
            }
        })
    }
    
    func removeAlbumFromPersonWriter(alb: String,per: String, completion: @escaping ((Error?) -> Void)) {
        DatabaseManager.shared.fetchPersonData(person: per, completion: {[weak self] result in
            guard let strongSelf = self else {return}
            switch result {
            case .success(let person):
                let ref = Database.database().reference().child("Registered Persons").child("\(person.name!)--\(person.dateRegisteredToApp!)--\(person.timeRegisteredToApp!)--\(person.toneDeafAppId)").child("Albums")
                var arrTo:[String] = []
                if var albbums = person.albums {
                    if let index = albbums.firstIndex(of: alb) {
                        albbums.remove(at: index)
                    }
                    for element in strongSelf.removedAlbs {
                        if albbums.contains(element) {
                            if let index = albbums.firstIndex(of: element) {
                                albbums.remove(at: index)
                            }
                        }
                    }
                    arrTo = albbums
                }
                ref.setValue(arrTo.sorted(), withCompletionBlock: { error, reference in
                    if let error = error {
                        completion(error)
                        return
                    }
                    else {
                        let ref2 = Database.database().reference().child("Registered Persons").child("\(person.name!)--\(person.dateRegisteredToApp!)--\(person.timeRegisteredToApp!)--\(person.toneDeafAppId)").child("Roles").child("Writer")
                        var arrTo2:[String] = []
                        if let currole = person.roles {
                            if var arrrry = currole["Writer"] as? [String] {
                                if let index = arrrry.firstIndex(of: alb) {
                                    arrrry.remove(at: index)
                                }
                                for element in strongSelf.removedAlbs {
                                    if arrrry.contains(element) {
                                        if let index = arrrry.firstIndex(of: element) {
                                            arrrry.remove(at: index)
                                        }
                                    }
                                }
                                arrTo2 = arrrry.sorted()
                            }
                        }
                        if !strongSelf.removedAlbs.contains(alb) {
                            strongSelf.removedAlbs.append(alb)
                        }
                        ref2.setValue(arrTo2.sorted(), withCompletionBlock: { error, reference in
                            if let error = error {
                                completion(error)
                                return
                            }
                            else {
                                completion(nil)
                                return
                            }
                        })
                    }
                })
            case .failure(let err):
                print("dsvgredfxbdfzx"+err.localizedDescription)
            }
        })
    }
    
    //MARK: - Mix Engineers
    func processMixEngineers(initialSong: SongData, currentSong: SongData, completion: @escaping (([Error]?) -> Void)) {
        initSong = initialSong
        currSong = currentSong
        
        initRef = Database.database().reference().child("Music Content").child("Songs").child("\(songContentTag)--\(initSong.name)--\(initSong.toneDeafAppId)")
        currRef = Database.database().reference().child("Music Content").child("Songs").child("\(songContentTag)--\(currSong.name)--\(currSong.toneDeafAppId)")
        var errors:[Error] = []
        var dataUploadCompletionStatus1:Bool!
        var dataUploadCompletionStatus2:Bool!
        var dataUploadCompletionStatus3:Bool!
        var dataUploadCompletionStatus4:Bool!
        var dataUploadCompletionStatus5:Bool!
        var dataUploadCompletionStatus6:Bool!
        var dataUploadCompletionStatus7:Bool!
        var dataUploadCompletionStatus8:Bool!
        var dataUploadCompletionStatus9:Bool!
        var dataUploadCompletionStatus10:Bool!
        
        let aqueue = DispatchQueue(label: "myhjvkheditingQsongMixEngineerhfdChangessseue")
        let agroup = DispatchGroup()
        let array:[Int] = [1,2,3,4]
        for i in array {
            agroup.enter()
            aqueue.async { [weak self] in
                guard let strongSelf = self else {return}
                switch i {
                case 1:
                    strongSelf.updateSongMixEngineers(ref: strongSelf.currRef, completion: {err in
                        if let error = err {
                            dataUploadCompletionStatus1 = false
                            errors.append(error)
                        } else {
                            dataUploadCompletionStatus1 = true
                            print("Song MixEngineer Update done \(1)")
                        }
                        agroup.leave()
                    })
                case 2:
                    strongSelf.updateMixEngineerSongs(ref: strongSelf.currRef, completion: {err in
                        if let error = err {
                            dataUploadCompletionStatus2 = false
                            errors.append(error)
                        } else {
                            dataUploadCompletionStatus2 = true
                            print("MixEngineer Songs Update done \(1)")
                        }
                        agroup.leave()
                    })
                case 3:
                    strongSelf.updateMixEngineerRoles(ref: strongSelf.currRef, completion: {err in
                        if let error = err {
                            dataUploadCompletionStatus3 = false
                            errors.append(error)
                        } else {
                            dataUploadCompletionStatus3 = true
                            print("MixEngineer roles Update done \(1)")
                        }
                        agroup.leave()
                    })
                case 4:
                    strongSelf.updateAlbumMixEngineer(ref: strongSelf.currRef, completion: {err in
                        if let error = err {
                            dataUploadCompletionStatus4 = false
                            errors.append(error)
                        } else {
                            dataUploadCompletionStatus4 = true
                            print("MixEngineer Album roles Update done \(1)")
                        }
                        agroup.leave()
                    })
                default:
                    break
                }
            }
        }
        agroup.notify(queue: DispatchQueue.main) {
            if dataUploadCompletionStatus1 == false || dataUploadCompletionStatus2 == false || dataUploadCompletionStatus3 == false || dataUploadCompletionStatus4 == false {
                completion(errors)
                return
            } else {
                completion(nil)
            }
        }
    }
    
    func updateSongMixEngineers(ref: DatabaseReference, completion: @escaping ((Error?) -> Void)) {
        var initialArtistsArrFromDB:[String]!
        if currSong.songMixEngineer!.sorted() == initSong.songMixEngineer?.sorted() {
            completion(nil)
            return
        }
        getSongMixEngineersInDB(ref: ref, completion: {[weak self] persons in
            guard let strongSelf = self else {return}
            initialArtistsArrFromDB = persons.sorted()
            
            if !initialArtistsArrFromDB.isEmpty {
                var removalCounter = 0
                for i in 0 ... initialArtistsArrFromDB.count-1 {
                    if strongSelf.currSong.songMixEngineer != nil {
                        if i < strongSelf.currSong.songMixEngineer!.count {
                            if !strongSelf.currSong.songMixEngineer![i].contains(initialArtistsArrFromDB[i]) {
                                let index = initialArtistsArrFromDB.firstIndex(of: initialArtistsArrFromDB[i])
                                initialArtistsArrFromDB.remove(at: index!)
                                removalCounter+=1
                            }
                        } else {
                            let index = initialArtistsArrFromDB.firstIndex(of: initialArtistsArrFromDB[i-removalCounter])
                            initialArtistsArrFromDB.remove(at: index!)
                            removalCounter+=1
                        }
                    } else {
                        let index = initialArtistsArrFromDB.firstIndex(of: initialArtistsArrFromDB[i-removalCounter])
                        initialArtistsArrFromDB.remove(at: index!)
                        removalCounter+=1
                    }
                }
            }
            
            if strongSelf.currSong.songMixEngineer != nil {
                if !strongSelf.currSong.songMixEngineer!.isEmpty {
                    for i in 0 ... strongSelf.currSong.songMixEngineer!.count-1 {
                        if i < initialArtistsArrFromDB.count {
                            if !initialArtistsArrFromDB[i].contains(strongSelf.currSong.songMixEngineer![i]) {
                                initialArtistsArrFromDB.append(strongSelf.currSong.songMixEngineer![i])
                            }
                        } else {
                            initialArtistsArrFromDB.append(strongSelf.currSong.songMixEngineer![i])
                        }
                    }
                }
            }
            ref.child("REQUIRED").child("Engineers").child("Mix Engineer").setValue(initialArtistsArrFromDB.sorted(), withCompletionBlock: { error, reference in
                if let error = error {
                    completion(error)
                    return
                }
                else {
                    completion(nil)
                    return
                }
            })
            
        })
    }
    
    func getSongMixEngineersInDB(ref: DatabaseReference, completion: @escaping (([String]) -> Void)) {
        ref.child("REQUIRED").child("Engineers").child("Mix Engineer").observeSingleEvent(of: .value, with: { snapshot in
            var mysongsArray:[String] = []
            if let val = snapshot.value {
                let valu = val as? [String]
                guard let value = valu else {
                    completion(mysongsArray)
                    return}
                if value[0] != "" {
                    mysongsArray = value
                }
                completion(mysongsArray)
            } else {
                completion(mysongsArray)
            }
        })
    }
    
    func updateMixEngineerSongs(ref: DatabaseReference, completion: @escaping ((Error?) -> Void)) {
        var initialArtistsArrFromDB:[String]!
        var totalProgress:Int = 0
        var completedProgress:Int = 0
        if currSong.songMixEngineer!.sorted() == initSong.songMixEngineer?.sorted() {
            completion(nil)
            return
        }
        
        getSongMixEngineersInDB(ref: ref, completion: {[weak self] persons in
            guard let strongSelf = self else {return}
            initialArtistsArrFromDB = persons.sorted()
            
            if !initialArtistsArrFromDB.isEmpty {
                var removalCounter = 0
                for i in 0 ... initialArtistsArrFromDB.count-1 {
                    if strongSelf.currSong.songMixEngineer != nil {
                        if i < strongSelf.currSong.songMixEngineer!.count {
                            if !strongSelf.currSong.songMixEngineer![i].contains(initialArtistsArrFromDB[i]) {
                                totalProgress+=1
                            }
                        } else {
                            totalProgress+=1
                        }
                    } else {
                        totalProgress+=1
                    }
                }
            }
            
            if strongSelf.currSong.songMixEngineer != nil {
                if !strongSelf.currSong.songMixEngineer!.isEmpty {
                    for i in 0 ... strongSelf.currSong.songMixEngineer!.count-1 {
                        if i < initialArtistsArrFromDB.count {
                            if !initialArtistsArrFromDB[i].contains(strongSelf.currSong.songMixEngineer![i]) {
                                totalProgress+=1
                            }
                        } else {
                            totalProgress+=1
                        }
                    }
                }
            }
            
            if !initialArtistsArrFromDB.isEmpty {
                for i in 0 ... initialArtistsArrFromDB.count-1 {
                    if strongSelf.currSong.songMixEngineer != nil {
                        if i < strongSelf.currSong.songMixEngineer!.count {
                            if !strongSelf.currSong.songMixEngineer![i].contains(initialArtistsArrFromDB[i]) {
                                strongSelf.removeSongFromPerson(per: initialArtistsArrFromDB[i], completion: { error in
                                    completedProgress+=1
                                    if let error = error {
                                        completion(error)
                                        return
                                    } else {
                                        if completedProgress == totalProgress {
                                            completion(nil)
                                            return
                                        }
                                    }
                                })
                            }
                        } else {
                            strongSelf.removeSongFromPerson(per: initialArtistsArrFromDB[i], completion: { error in
                                completedProgress+=1
                                if let error = error {
                                    completion(error)
                                    return
                                } else {
                                    if completedProgress == totalProgress {
                                        completion(nil)
                                        return
                                    }
                                }
                            })
                        }
                    } else {
                        strongSelf.removeSongFromPerson(per: initialArtistsArrFromDB[i], completion: { error in
                            completedProgress+=1
                            if let error = error {
                                completion(error)
                                return
                            } else {
                                if completedProgress == totalProgress {
                                    completion(nil)
                                    return
                                }
                            }
                        })
                    }
                }
            }
            
            if strongSelf.currSong.songMixEngineer != nil {
                if !strongSelf.currSong.songMixEngineer!.isEmpty {
                    for i in 0 ... strongSelf.currSong.songMixEngineer!.count-1 {
                        if i < initialArtistsArrFromDB.count {
                            if !initialArtistsArrFromDB[i].contains(strongSelf.currSong.songMixEngineer![i]) {
                                strongSelf.addSongToPerson(per: strongSelf.currSong.songMixEngineer![i], completion: { error in
                                    completedProgress+=1
                                    if let error = error {
                                        completion(error)
                                        return
                                    } else {
                                        if completedProgress == totalProgress {
                                            completion(nil)
                                            return
                                        }
                                    }
                                })
                            }
                        } else {
                            strongSelf.addSongToPerson(per: strongSelf.currSong.songMixEngineer![i], completion: { error in
                                completedProgress+=1
                                if let error = error {
                                    completion(error)
                                    return
                                } else {
                                    if completedProgress == totalProgress {
                                        completion(nil)
                                        return
                                    }
                                }
                            })
                        }
                    }
                }
            }
            
        })
    }
    
    func updateMixEngineerRoles(ref: DatabaseReference, completion: @escaping ((Error?) -> Void)) {
        var initialArtistsArrFromDB:[String]!
        var totalProgress:Int = 0
        var completedProgress:Int = 0
        if currSong.songMixEngineer!.sorted() == initSong.songMixEngineer?.sorted() {
            completion(nil)
            return
        }
        
        getSongMixEngineersInDB(ref: ref, completion: {[weak self] persons in
            guard let strongSelf = self else {return}
            initialArtistsArrFromDB = persons.sorted()
            
            if !initialArtistsArrFromDB.isEmpty {
                for i in 0 ... initialArtistsArrFromDB.count-1 {
                    if strongSelf.currSong.songMixEngineer != nil {
                        if i < strongSelf.currSong.songMixEngineer!.count {
                            if !strongSelf.currSong.songMixEngineer![i].contains(initialArtistsArrFromDB[i]) {
                                totalProgress+=1
                            }
                        } else {
                            totalProgress+=1
                        }
                    } else {
                        totalProgress+=1
                    }
                }
            }
            
            if strongSelf.currSong.songMixEngineer != nil {
                if !strongSelf.currSong.songMixEngineer!.isEmpty {
                    for i in 0 ... strongSelf.currSong.songMixEngineer!.count-1 {
                        if i < initialArtistsArrFromDB.count {
                            if !initialArtistsArrFromDB[i].contains(strongSelf.currSong.songMixEngineer![i]) {
                                totalProgress+=1
                            }
                        } else {
                            totalProgress+=1
                        }
                    }
                }
            }
            
            if !initialArtistsArrFromDB.isEmpty {
                for i in 0 ... initialArtistsArrFromDB.count-1 {
                    if strongSelf.currSong.songMixEngineer != nil {
                        if i < strongSelf.currSong.songMixEngineer!.count {
                            if !strongSelf.currSong.songMixEngineer![i].contains(initialArtistsArrFromDB[i]) {
                                strongSelf.removeSongFromMixEngineerRoles(per: initialArtistsArrFromDB[i], completion: { error in
                                    completedProgress+=1
                                    if let error = error {
                                        completion(error)
                                        return
                                    } else {
                                        if completedProgress == totalProgress {
                                            completion(nil)
                                            return
                                        }
                                    }
                                })
                            }
                        } else {
                            strongSelf.removeSongFromMixEngineerRoles(per: initialArtistsArrFromDB[i], completion: { error in
                                completedProgress+=1
                                if let error = error {
                                    completion(error)
                                    return
                                } else {
                                    if completedProgress == totalProgress {
                                        completion(nil)
                                        return
                                    }
                                }
                            })
                        }
                    } else {
                        strongSelf.removeSongFromMixEngineerRoles(per: initialArtistsArrFromDB[i], completion: { error in
                            completedProgress+=1
                            if let error = error {
                                completion(error)
                                return
                            } else {
                                if completedProgress == totalProgress {
                                    completion(nil)
                                    return
                                }
                            }
                        })
                    }
                }
            }
            
            if strongSelf.currSong.songMixEngineer != nil {
                if !strongSelf.currSong.songMixEngineer!.isEmpty {
                    for i in 0 ... strongSelf.currSong.songMixEngineer!.count-1 {
                        if i < initialArtistsArrFromDB.count {
                            if !initialArtistsArrFromDB[i].contains(strongSelf.currSong.songMixEngineer![i]) {
                                strongSelf.addSongToMixEngineerRoles(per: strongSelf.currSong.songMixEngineer![i], completion: { error in
                                    completedProgress+=1
                                    if let error = error {
                                        completion(error)
                                        return
                                    } else {
                                        if completedProgress == totalProgress {
                                            completion(nil)
                                            return
                                        }
                                    }
                                })
                            }
                        } else {
                            strongSelf.addSongToMixEngineerRoles(per: strongSelf.currSong.songMixEngineer![i], completion: { error in
                                completedProgress+=1
                                if let error = error {
                                    completion(error)
                                    return
                                } else {
                                    if completedProgress == totalProgress {
                                        completion(nil)
                                        return
                                    }
                                }
                            })
                        }
                    }
                }
            }
            
        })
    }
    
    func removeSongFromMixEngineerRoles(per: String, completion: @escaping ((Error?) -> Void)) {
        guard per.count == 6 else {
            completion(nil)
            return
        }
        DatabaseManager.shared.fetchPersonData(person: per, completion: {[weak self] result in
            guard let strongSelf = self else {return}
            switch result {
            case .success(let person):
                let ref = Database.database().reference().child("Registered Persons").child("\(person.name!)--\(person.dateRegisteredToApp!)--\(person.timeRegisteredToApp!)--\(person.toneDeafAppId)").child("Roles").child("Engineer").child("Mix Engineer")
                let song = "\(strongSelf.currSong.toneDeafAppId)"
                var arrTo:[String] = []
                if let roles = person.roles {
                    if let eng = roles["Engineer"] as? NSDictionary {
                        let engDict = eng.mutableCopy() as! NSMutableDictionary
                        if var art = engDict["Mix Engineer"] as? [String] {
                            if art.contains(song) {
                                let index = art.firstIndex(of: song)
                                art.remove(at: index!)
                                arrTo = art
                            }
                        }
                    }
                }
                
                ref.setValue(arrTo.sorted(), withCompletionBlock: { error, reference in
                    if let error = error {
                        completion(error)
                        return
                    }
                    else {
                        completion(nil)
                        return
                    }
                })
            case .failure(let err):
                print("dsvgredfxbdfzx"+err.localizedDescription)
            }
        })
    }
    
    func addSongToMixEngineerRoles(per: String, completion: @escaping ((Error?) -> Void)) {
        guard per.count == 6 else {
            completion(nil)
            return
        }
        
        DatabaseManager.shared.fetchPersonData(person: per, completion: {[weak self] result in
            guard let strongSelf = self else {return}
            switch result {
            case .success(let person):
                let ref = Database.database().reference().child("Registered Persons").child("\(person.name!)--\(person.dateRegisteredToApp!)--\(person.timeRegisteredToApp!)--\(person.toneDeafAppId)").child("Roles").child("Engineer").child("Mix Engineer")
                let song = "\(strongSelf.currSong.toneDeafAppId)"
                var arrTo:[String] = []
                
                if let roles = person.roles {
                    if let eng = roles["Engineer"] as? NSDictionary {
                        let engDict = eng.mutableCopy() as! NSMutableDictionary
                        if var art = engDict["Mix Engineer"] as? [String] {
                            if !art.contains(song) {
                                art.append(song)
                                arrTo = art
                            } else {
                                arrTo = art
                            }
                        } else {
                            arrTo = [song]
                        }
                    } else {
                        arrTo = [song]
                    }
                } else {
                    arrTo = [song]
                }
                
                ref.setValue(arrTo.sorted(), withCompletionBlock: { error, reference in
                    if let error = error {
                        completion(error)
                        return
                    }
                    else {
                        completion(nil)
                        return
                    }
                })
            case .failure(let err):
                print("dsvgredfxbdfzx"+err.localizedDescription)
            }
        })
    }
    
    func updateAlbumMixEngineer(ref: DatabaseReference, completion: @escaping ((Error?) -> Void)) {
        var initialArtistsArrFromDB:[String]!
        var totalProgress:Int = 0
        var completedProgress:Int = 0
        if currSong.songMixEngineer!.sorted() == initSong.songMixEngineer?.sorted() {
            completion(nil)
            return
        }
        if currSong.albums == nil {
            completion(nil)
            return
        }
        if currSong.albums!.isEmpty {
            completion(nil)
            return
        }
        
        let albums = currSong.albums!
        
        getSongMixEngineersInDB(ref: ref, completion: {[weak self] persons in
            guard let strongSelf = self else {return}
            initialArtistsArrFromDB = persons.sorted()
            
            if !initialArtistsArrFromDB.isEmpty {
                for i in 0 ... initialArtistsArrFromDB.count-1 {
                    if strongSelf.currSong.songMixEngineer != nil {
                        if i < strongSelf.currSong.songMixEngineer!.count {
                            if !strongSelf.currSong.songMixEngineer![i].contains(initialArtistsArrFromDB[i]) {
                                for alb in albums {
                                    totalProgress+=1
                                }
                            }
                        } else {
                            for alb in albums {
                                totalProgress+=1
                            }
                        }
                    } else {
                        for alb in albums {
                            totalProgress+=1
                        }
                    }
                }
            }
            
            if strongSelf.currSong.songMixEngineer != nil {
                if !strongSelf.currSong.songMixEngineer!.isEmpty {
                    for i in 0 ... strongSelf.currSong.songMixEngineer!.count-1 {
                        if i < initialArtistsArrFromDB.count {
                            if !initialArtistsArrFromDB[i].contains(strongSelf.currSong.songMixEngineer![i]) {
                                for alb in albums {
                                    totalProgress+=1
                                }
                            }
                        } else {
                            for alb in albums {
                                totalProgress+=1
                            }
                        }
                    }
                }
            }
            
            if !initialArtistsArrFromDB.isEmpty {
                for i in 0 ... initialArtistsArrFromDB.count-1 {
                    if strongSelf.currSong.songMixEngineer != nil {
                        if i < strongSelf.currSong.songMixEngineer!.count {
                            if !strongSelf.currSong.songMixEngineer![i].contains(initialArtistsArrFromDB[i]) {
                                for alb in albums {
                                    strongSelf.removeMixEngineerFromAlbum(alb: alb, per: initialArtistsArrFromDB[i], completion: { error in
                                        completedProgress+=1
                                        if let error = error {
                                            completion(error)
                                            return
                                        } else {
                                            if completedProgress == totalProgress {
                                                completion(nil)
                                                return
                                            }
                                        }
                                    })
                                }
                            }
                        } else {
                            for alb in albums {
                                strongSelf.removeMixEngineerFromAlbum(alb: alb, per: initialArtistsArrFromDB[i], completion: { error in
                                    completedProgress+=1
                                    if let error = error {
                                        completion(error)
                                        return
                                    } else {
                                        if completedProgress == totalProgress {
                                            completion(nil)
                                            return
                                        }
                                    }
                                })
                            }
                        }
                    } else {
                        for alb in albums {
                            strongSelf.removeMixEngineerFromAlbum(alb: alb, per: initialArtistsArrFromDB[i], completion: { error in
                                completedProgress+=1
                                if let error = error {
                                    completion(error)
                                    return
                                } else {
                                    if completedProgress == totalProgress {
                                        completion(nil)
                                        return
                                    }
                                }
                            })
                        }
                    }
                }
            }
            
            if strongSelf.currSong.songMixEngineer != nil {
                if !strongSelf.currSong.songMixEngineer!.isEmpty {
                    for i in 0 ... strongSelf.currSong.songMixEngineer!.count-1 {
                        if i < initialArtistsArrFromDB.count {
                            if !initialArtistsArrFromDB[i].contains(strongSelf.currSong.songMixEngineer![i]) {
                                for album in albums {
                                    strongSelf.addMixEngineerToAlbum(alb: album, per: strongSelf.currSong.songMixEngineer![i], completion: { error in
                                        completedProgress+=1
                                        if let error = error {
                                            completion(error)
                                            return
                                        } else {
                                            if completedProgress == totalProgress {
                                                completion(nil)
                                                return
                                            }
                                        }
                                    })
                                }
                            }
                        } else {
                            for album in albums {
                                strongSelf.addMixEngineerToAlbum(alb: album, per: strongSelf.currSong.songMixEngineer![i], completion: { error in
                                    completedProgress+=1
                                    if let error = error {
                                        completion(error)
                                        return
                                    } else {
                                        if completedProgress == totalProgress {
                                            completion(nil)
                                            return
                                        }
                                    }
                                })
                            }
                        }
                    }
                }
            }
            
        })
    }
    
    func removeMixEngineerFromAlbum(alb: String, per: String, completion: @escaping ((Error?) -> Void)) {
        guard alb.count == 8 else {
            completion(nil)
            return
        }
        DatabaseManager.shared.findAlbumById(albumId: alb, completion: {[weak self] result in
            guard let strongSelf = self else {return}
            switch result {
            case .success(let album):
                let ref = Database.database().reference().child("Music Content").child("Albums").child("\(albumContentTag)--\(album.name)--\(album.toneDeafAppId)").child("REQUIRED").child("Engineers").child("Mix Engineer")
                var arrTo:[String] = []
                DatabaseManager.shared.fetchPersonData(person: per, completion: { result in
                    guard let strongSelf = self else {return}
                    switch result {
                    case .success(let person):
                        var roleMArkedOnAnotherSong:Bool = false
                        if let asong = album.songs {
                            for song in asong {
                                if let proles = person.roles {
                                    if let eng = proles["Engineer"] as? NSDictionary {
                                        let engdict = eng.mutableCopy() as! NSMutableDictionary
                                        if let parr = engdict["Mix Engineer"] as? [String] {
                                            if parr.contains(song) {
                                                if song != strongSelf.currSong.toneDeafAppId {
                                                    roleMArkedOnAnotherSong = true
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                        if let asong = album.instrumentals {
                            for song in asong {
                                if let proles = person.roles {
                                    if let eng = proles["Engineer"] as? NSDictionary {
                                        let engdict = eng.mutableCopy() as! NSMutableDictionary
                                        if let parr = engdict["Mix Engineer"] as? [String] {
                                            if parr.contains(song) {
                                                if song != strongSelf.currSong.toneDeafAppId {
                                                    roleMArkedOnAnotherSong = true
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                        if roleMArkedOnAnotherSong == false {
                            if var arrr = album.mixEngineers {
                                let index = arrr.firstIndex(of: per)
                                arrr.remove(at: index!)
                                arrTo = arrr
                            } else {
                                var arrr:[String] = []
                                let index = arrr.firstIndex(of: per)
                                arrr.remove(at: index!)
                                arrTo = arrr
                            }
                            ref.setValue(arrTo.sorted(), withCompletionBlock: { error, reference in
                                if let error = error {
                                    completion(error)
                                    return
                                }
                                else {
                                    strongSelf.removeAlbumFromPersonMixEngineer(alb: alb, per: per, completion: { error in
                                        if let error = error {
                                            completion(error)
                                            return
                                        }
                                        else {
                                            completion(nil)
                                            return
                                        }
                                    })
                                }
                            })
                        } else {
                            completion(nil)
                        }
                        
                    case .failure(let err):
                        print("dsvgredfxbdfzx"+err.localizedDescription)
                    }
                    
                })
            case .failure(let err):
                print("dsvgredfxbdfzx"+err.localizedDescription)
            }
        })
    }
    
    func addMixEngineerToAlbum(alb: String,per: String, completion: @escaping ((Error?) -> Void)) {
        guard alb.count == 8 else {
            completion(nil)
            return
        }
        
        DatabaseManager.shared.findAlbumById(albumId: alb, completion: {[weak self] result in
            guard let strongSelf = self else {return}
            switch result {
            case .success(let album):
                let ref = Database.database().reference().child("Music Content").child("Albums").child("\(albumContentTag)--\(album.name)--\(album.toneDeafAppId)").child("REQUIRED").child("Engineers").child("Mix Engineer")
                var arrTo:[String] = []
                
                if var arrr = album.mixEngineers {
                    if !arrr.contains(per) {
                        arrr.append(per)
                        arrTo = arrr
                    } else {
                        arrTo = arrr
                    }
                } else {
                    var arrr:[String] = []
                    arrr.append(per)
                    arrTo = arrr
                }
                
                
                ref.setValue(arrTo.sorted(), withCompletionBlock: { error, reference in
                    if let error = error {
                        completion(error)
                        return
                    }
                    else {
                        strongSelf.addAlbumToPersonMixEngineer(alb: [alb], per: per, completion: { error in
                            if let error = error {
                                completion(error)
                                return
                            }
                            else {
                                completion(nil)
                                return
                            }
                        })
                        
                    }
                })
            case .failure(let err):
                print("dsvgredfxbdfzx"+err.localizedDescription)
            }
        })
    }
    
    func addAlbumToPersonMixEngineer(alb: [String],per: String, completion: @escaping ((Error?) -> Void)) {
        DatabaseManager.shared.fetchPersonData(person: per, completion: {[weak self] result in
            guard let strongSelf = self else {return}
            switch result {
            case .success(let person):
                let ref = Database.database().reference().child("Registered Persons").child("\(person.name!)--\(person.dateRegisteredToApp!)--\(person.timeRegisteredToApp!)--\(person.toneDeafAppId)").child("Albums")
                var arrTo:[String] = []
                strongSelf.getPersonAlbumsInDB(ref: Database.database().reference().child("Registered Persons").child("\(person.name!)--\(person.dateRegisteredToApp!)--\(person.timeRegisteredToApp!)--\(person.toneDeafAppId)"), completion: { albumns in
                    var albbums = albumns
                    for element in alb {
                        if !albbums.contains(element) {
                            albbums.append(element)
                            arrTo = albbums
                        } else {
                            arrTo = albbums
                        }
                    }
                    ref.setValue(arrTo.sorted(), withCompletionBlock: { error, reference in
                        if let error = error {
                            completion(error)
                            return
                        }
                        else {
                            let ref2 = Database.database().reference().child("Registered Persons").child("\(person.name!)--\(person.dateRegisteredToApp!)--\(person.timeRegisteredToApp!)--\(person.toneDeafAppId)").child("Roles").child("Engineer").child("Mix Engineer")
                            var arrTo2:[String] = []
                            if let currole = person.roles {
                                if let eng = currole["Engineer"] as? NSDictionary {
                                    let engDict = eng.mutableCopy() as! NSMutableDictionary
                                    if var arrrry = engDict["Mix Engineer"] as? [String] {
                                        for element in alb {
                                            if !arrrry.contains(element) {
                                                arrrry.append(element)
                                                arrTo2 = arrrry.sorted()
                                            } else {
                                                arrTo2 = arrrry.sorted()
                                            }
                                        }
                                    } else {
                                        arrTo2 = alb
                                    }
                                } else {
                                    arrTo2 = alb
                                }
                            } else {
                                arrTo2 = alb
                            }
                            ref2.setValue(arrTo2.sorted(), withCompletionBlock: { error, reference in
                                if let error = error {
                                    completion(error)
                                    return
                                }
                                else {
                                    completion(nil)
                                    return
                                }
                            })
                        }
                    })
                })
            case .failure(let err):
                print("dsvgredfxbdfzx"+err.localizedDescription)
            }
        })
    }
    
    func removeAlbumFromPersonMixEngineer(alb: String,per: String, completion: @escaping ((Error?) -> Void)) {
        DatabaseManager.shared.fetchPersonData(person: per, completion: {[weak self] result in
            guard let strongSelf = self else {return}
            switch result {
            case .success(let person):
                let ref = Database.database().reference().child("Registered Persons").child("\(person.name!)--\(person.dateRegisteredToApp!)--\(person.timeRegisteredToApp!)--\(person.toneDeafAppId)").child("Albums")
                var arrTo:[String] = []
                if var albbums = person.albums {
                    if let index = albbums.firstIndex(of: alb) {
                        albbums.remove(at: index)
                    }
                    for element in strongSelf.removedAlbs {
                        if albbums.contains(element) {
                            if let index = albbums.firstIndex(of: element) {
                                albbums.remove(at: index)
                            }
                        }
                    }
                    arrTo = albbums
                }
                ref.setValue(arrTo.sorted(), withCompletionBlock: { error, reference in
                    if let error = error {
                        completion(error)
                        return
                    }
                    else {
                        let ref2 = Database.database().reference().child("Registered Persons").child("\(person.name!)--\(person.dateRegisteredToApp!)--\(person.timeRegisteredToApp!)--\(person.toneDeafAppId)").child("Roles").child("Engineer").child("Mix Engineer")
                        var arrTo2:[String] = []
                        if let currole = person.roles {
                            if let eng = currole["Engineer"] as? NSDictionary {
                                let engDict = eng.mutableCopy() as! NSMutableDictionary
                                if var arrrry = engDict["Mix Engineer"] as? [String] {
                                    if let index = arrrry.firstIndex(of: alb){
                                        arrrry.remove(at: index)
                                    }
                                    for element in strongSelf.removedAlbs {
                                        if arrrry.contains(element) {
                                            if let index = arrrry.firstIndex(of: element) {
                                                arrrry.remove(at: index)
                                            }
                                        }
                                    }
                                    arrTo2 = arrrry.sorted()
                                }
                            }
                        }
                        if !strongSelf.removedAlbs.contains(alb) {
                            strongSelf.removedAlbs.append(alb)
                        }
                        ref2.setValue(arrTo2.sorted(), withCompletionBlock: { error, reference in
                            if let error = error {
                                completion(error)
                                return
                            }
                            else {
                                completion(nil)
                                return
                            }
                        })
                    }
                })
            case .failure(let err):
                print("dsvgredfxbdfzx"+err.localizedDescription)
            }
        })
    }
    
    //MARK: - Mastering Engineers
    func processMasteringEngineers(initialSong: SongData, currentSong: SongData, completion: @escaping (([Error]?) -> Void)) {
        initSong = initialSong
        currSong = currentSong
        
        initRef = Database.database().reference().child("Music Content").child("Songs").child("\(songContentTag)--\(initSong.name)--\(initSong.toneDeafAppId)")
        currRef = Database.database().reference().child("Music Content").child("Songs").child("\(songContentTag)--\(currSong.name)--\(currSong.toneDeafAppId)")
        var errors:[Error] = []
        var dataUploadCompletionStatus1:Bool!
        var dataUploadCompletionStatus2:Bool!
        var dataUploadCompletionStatus3:Bool!
        var dataUploadCompletionStatus4:Bool!
        var dataUploadCompletionStatus5:Bool!
        var dataUploadCompletionStatus6:Bool!
        var dataUploadCompletionStatus7:Bool!
        var dataUploadCompletionStatus8:Bool!
        var dataUploadCompletionStatus9:Bool!
        var dataUploadCompletionStatus10:Bool!
        
        let aqueue = DispatchQueue(label: "myhjvkheditingQsongMasterEngineerhfdChangessseue")
        let agroup = DispatchGroup()
        let array:[Int] = [1,2,3,4]
        for i in array {
            agroup.enter()
            aqueue.async { [weak self] in
                guard let strongSelf = self else {return}
                switch i {
                case 1:
                    strongSelf.updateSongMasteringEngineers(ref: strongSelf.currRef, completion: {err in
                        if let error = err {
                            dataUploadCompletionStatus1 = false
                            errors.append(error)
                        } else {
                            dataUploadCompletionStatus1 = true
                            print("Song MasteringEngineer Update done \(1)")
                        }
                        agroup.leave()
                    })
                case 2:
                    strongSelf.updateMasteringEngineerSongs(ref: strongSelf.currRef, completion: {err in
                        if let error = err {
                            dataUploadCompletionStatus2 = false
                            errors.append(error)
                        } else {
                            dataUploadCompletionStatus2 = true
                            print("MasteringEngineer Songs Update done \(1)")
                        }
                        agroup.leave()
                    })
                case 3:
                    strongSelf.updateMasteringEngineerRoles(ref: strongSelf.currRef, completion: {err in
                        if let error = err {
                            dataUploadCompletionStatus3 = false
                            errors.append(error)
                        } else {
                            dataUploadCompletionStatus3 = true
                            print("MasteringEngineer roles Update done \(1)")
                        }
                        agroup.leave()
                    })
                case 4:
                    strongSelf.updateAlbumMasteringEngineer(ref: strongSelf.currRef, completion: {err in
                        if let error = err {
                            dataUploadCompletionStatus4 = false
                            errors.append(error)
                        } else {
                            dataUploadCompletionStatus4 = true
                            print("MasteringEngineer Album roles Update done \(1)")
                        }
                        agroup.leave()
                    })
                default:
                    break
                }
            }
        }
        agroup.notify(queue: DispatchQueue.main) {
            if dataUploadCompletionStatus1 == false || dataUploadCompletionStatus2 == false || dataUploadCompletionStatus3 == false || dataUploadCompletionStatus4 == false {
                completion(errors)
                return
            } else {
                completion(nil)
            }
        }
    }
    
    func updateSongMasteringEngineers(ref: DatabaseReference, completion: @escaping ((Error?) -> Void)) {
        var initialArtistsArrFromDB:[String]!
        if currSong.songMasteringEngineer!.sorted() == initSong.songMasteringEngineer?.sorted() {
            completion(nil)
            return
        }
        getSongMasteringEngineersInDB(ref: ref, completion: {[weak self] persons in
            guard let strongSelf = self else {return}
            initialArtistsArrFromDB = persons.sorted()
            
            if !initialArtistsArrFromDB.isEmpty {
                var removalCounter = 0
                for i in 0 ... initialArtistsArrFromDB.count-1 {
                    if strongSelf.currSong.songMasteringEngineer != nil {
                        if i < strongSelf.currSong.songMasteringEngineer!.count {
                            if !strongSelf.currSong.songMasteringEngineer![i].contains(initialArtistsArrFromDB[i]) {
                                let index = initialArtistsArrFromDB.firstIndex(of: initialArtistsArrFromDB[i])
                                initialArtistsArrFromDB.remove(at: index!)
                                removalCounter+=1
                            }
                        } else {
                            let index = initialArtistsArrFromDB.firstIndex(of: initialArtistsArrFromDB[i-removalCounter])
                            initialArtistsArrFromDB.remove(at: index!)
                            removalCounter+=1
                        }
                    } else {
                        let index = initialArtistsArrFromDB.firstIndex(of: initialArtistsArrFromDB[i-removalCounter])
                        initialArtistsArrFromDB.remove(at: index!)
                        removalCounter+=1
                    }
                }
            }
            
            if strongSelf.currSong.songMasteringEngineer != nil {
                if !strongSelf.currSong.songMasteringEngineer!.isEmpty {
                    for i in 0 ... strongSelf.currSong.songMasteringEngineer!.count-1 {
                        if i < initialArtistsArrFromDB.count {
                            if !initialArtistsArrFromDB[i].contains(strongSelf.currSong.songMasteringEngineer![i]) {
                                initialArtistsArrFromDB.append(strongSelf.currSong.songMasteringEngineer![i])
                            }
                        } else {
                            initialArtistsArrFromDB.append(strongSelf.currSong.songMasteringEngineer![i])
                        }
                    }
                }
            }
            ref.child("REQUIRED").child("Engineers").child("Mastering Engineer").setValue(initialArtistsArrFromDB.sorted(), withCompletionBlock: { error, reference in
                if let error = error {
                    completion(error)
                    return
                }
                else {
                    completion(nil)
                    return
                }
            })
            
        })
    }
    
    func getSongMasteringEngineersInDB(ref: DatabaseReference, completion: @escaping (([String]) -> Void)) {
        ref.child("REQUIRED").child("Engineers").child("Mastering Engineer").observeSingleEvent(of: .value, with: { snapshot in
            var mysongsArray:[String] = []
            if let val = snapshot.value {
                let valu = val as? [String]
                guard let value = valu else {
                    completion(mysongsArray)
                    return}
                if value[0] != "" {
                    mysongsArray = value
                }
                completion(mysongsArray)
            } else {
                completion(mysongsArray)
            }
        })
    }
    
    func updateMasteringEngineerSongs(ref: DatabaseReference, completion: @escaping ((Error?) -> Void)) {
        var initialArtistsArrFromDB:[String]!
        var totalProgress:Int = 0
        var completedProgress:Int = 0
        if currSong.songMasteringEngineer!.sorted() == initSong.songMasteringEngineer?.sorted() {
            completion(nil)
            return
        }
        
        getSongMasteringEngineersInDB(ref: ref, completion: {[weak self] persons in
            guard let strongSelf = self else {return}
            initialArtistsArrFromDB = persons.sorted()
            
            if !initialArtistsArrFromDB.isEmpty {
                var removalCounter = 0
                for i in 0 ... initialArtistsArrFromDB.count-1 {
                    if strongSelf.currSong.songMasteringEngineer != nil {
                        if i < strongSelf.currSong.songMasteringEngineer!.count {
                            if !strongSelf.currSong.songMasteringEngineer![i].contains(initialArtistsArrFromDB[i]) {
                                totalProgress+=1
                            }
                        } else {
                            totalProgress+=1
                        }
                    } else {
                        totalProgress+=1
                    }
                }
            }
            
            if strongSelf.currSong.songMasteringEngineer != nil {
                if !strongSelf.currSong.songMasteringEngineer!.isEmpty {
                    for i in 0 ... strongSelf.currSong.songMasteringEngineer!.count-1 {
                        if i < initialArtistsArrFromDB.count {
                            if !initialArtistsArrFromDB[i].contains(strongSelf.currSong.songMasteringEngineer![i]) {
                                totalProgress+=1
                            }
                        } else {
                            totalProgress+=1
                        }
                    }
                }
            }
            
            if !initialArtistsArrFromDB.isEmpty {
                for i in 0 ... initialArtistsArrFromDB.count-1 {
                    if strongSelf.currSong.songMasteringEngineer != nil {
                        if i < strongSelf.currSong.songMasteringEngineer!.count {
                            if !strongSelf.currSong.songMasteringEngineer![i].contains(initialArtistsArrFromDB[i]) {
                                strongSelf.removeSongFromPerson(per: initialArtistsArrFromDB[i], completion: { error in
                                    completedProgress+=1
                                    if let error = error {
                                        completion(error)
                                        return
                                    } else {
                                        if completedProgress == totalProgress {
                                            completion(nil)
                                            return
                                        }
                                    }
                                })
                            }
                        } else {
                            strongSelf.removeSongFromPerson(per: initialArtistsArrFromDB[i], completion: { error in
                                completedProgress+=1
                                if let error = error {
                                    completion(error)
                                    return
                                } else {
                                    if completedProgress == totalProgress {
                                        completion(nil)
                                        return
                                    }
                                }
                            })
                        }
                    } else {
                        strongSelf.removeSongFromPerson(per: initialArtistsArrFromDB[i], completion: { error in
                            completedProgress+=1
                            if let error = error {
                                completion(error)
                                return
                            } else {
                                if completedProgress == totalProgress {
                                    completion(nil)
                                    return
                                }
                            }
                        })
                    }
                }
            }
            
            if strongSelf.currSong.songMasteringEngineer != nil {
                if !strongSelf.currSong.songMasteringEngineer!.isEmpty {
                    for i in 0 ... strongSelf.currSong.songMasteringEngineer!.count-1 {
                        if i < initialArtistsArrFromDB.count {
                            if !initialArtistsArrFromDB[i].contains(strongSelf.currSong.songMasteringEngineer![i]) {
                                strongSelf.addSongToPerson(per: strongSelf.currSong.songMasteringEngineer![i], completion: { error in
                                    completedProgress+=1
                                    if let error = error {
                                        completion(error)
                                        return
                                    } else {
                                        if completedProgress == totalProgress {
                                            completion(nil)
                                            return
                                        }
                                    }
                                })
                            }
                        } else {
                            strongSelf.addSongToPerson(per: strongSelf.currSong.songMasteringEngineer![i], completion: { error in
                                completedProgress+=1
                                if let error = error {
                                    completion(error)
                                    return
                                } else {
                                    if completedProgress == totalProgress {
                                        completion(nil)
                                        return
                                    }
                                }
                            })
                        }
                    }
                }
            }
            
        })
    }
    
    func updateMasteringEngineerRoles(ref: DatabaseReference, completion: @escaping ((Error?) -> Void)) {
        var initialArtistsArrFromDB:[String]!
        var totalProgress:Int = 0
        var completedProgress:Int = 0
        if currSong.songMasteringEngineer!.sorted() == initSong.songMasteringEngineer?.sorted() {
            completion(nil)
            return
        }
        
        getSongMasteringEngineersInDB(ref: ref, completion: {[weak self] persons in
            guard let strongSelf = self else {return}
            initialArtistsArrFromDB = persons.sorted()
            
            if !initialArtistsArrFromDB.isEmpty {
                for i in 0 ... initialArtistsArrFromDB.count-1 {
                    if strongSelf.currSong.songMasteringEngineer != nil {
                        if i < strongSelf.currSong.songMasteringEngineer!.count {
                            if !strongSelf.currSong.songMasteringEngineer![i].contains(initialArtistsArrFromDB[i]) {
                                totalProgress+=1
                            }
                        } else {
                            totalProgress+=1
                        }
                    } else {
                        totalProgress+=1
                    }
                }
            }
            
            if strongSelf.currSong.songMasteringEngineer != nil {
                if !strongSelf.currSong.songMasteringEngineer!.isEmpty {
                    for i in 0 ... strongSelf.currSong.songMasteringEngineer!.count-1 {
                        if i < initialArtistsArrFromDB.count {
                            if !initialArtistsArrFromDB[i].contains(strongSelf.currSong.songMasteringEngineer![i]) {
                                totalProgress+=1
                            }
                        } else {
                            totalProgress+=1
                        }
                    }
                }
            }
            
            if !initialArtistsArrFromDB.isEmpty {
                for i in 0 ... initialArtistsArrFromDB.count-1 {
                    if strongSelf.currSong.songMasteringEngineer != nil {
                        if i < strongSelf.currSong.songMasteringEngineer!.count {
                            if !strongSelf.currSong.songMasteringEngineer![i].contains(initialArtistsArrFromDB[i]) {
                                strongSelf.removeSongFromMasteringEngineerRoles(per: initialArtistsArrFromDB[i], completion: { error in
                                    completedProgress+=1
                                    if let error = error {
                                        completion(error)
                                        return
                                    } else {
                                        if completedProgress == totalProgress {
                                            completion(nil)
                                            return
                                        }
                                    }
                                })
                            }
                        } else {
                            strongSelf.removeSongFromMasteringEngineerRoles(per: initialArtistsArrFromDB[i], completion: { error in
                                completedProgress+=1
                                if let error = error {
                                    completion(error)
                                    return
                                } else {
                                    if completedProgress == totalProgress {
                                        completion(nil)
                                        return
                                    }
                                }
                            })
                        }
                    } else {
                        strongSelf.removeSongFromMasteringEngineerRoles(per: initialArtistsArrFromDB[i], completion: { error in
                            completedProgress+=1
                            if let error = error {
                                completion(error)
                                return
                            } else {
                                if completedProgress == totalProgress {
                                    completion(nil)
                                    return
                                }
                            }
                        })
                    }
                }
            }
            
            if strongSelf.currSong.songMasteringEngineer != nil {
                if !strongSelf.currSong.songMasteringEngineer!.isEmpty {
                    for i in 0 ... strongSelf.currSong.songMasteringEngineer!.count-1 {
                        if i < initialArtistsArrFromDB.count {
                            if !initialArtistsArrFromDB[i].contains(strongSelf.currSong.songMasteringEngineer![i]) {
                                strongSelf.addSongToMasteringEngineerRoles(per: strongSelf.currSong.songMasteringEngineer![i], completion: { error in
                                    completedProgress+=1
                                    if let error = error {
                                        completion(error)
                                        return
                                    } else {
                                        if completedProgress == totalProgress {
                                            completion(nil)
                                            return
                                        }
                                    }
                                })
                            }
                        } else {
                            strongSelf.addSongToMasteringEngineerRoles(per: strongSelf.currSong.songMasteringEngineer![i], completion: { error in
                                completedProgress+=1
                                if let error = error {
                                    completion(error)
                                    return
                                } else {
                                    if completedProgress == totalProgress {
                                        completion(nil)
                                        return
                                    }
                                }
                            })
                        }
                    }
                }
            }
            
        })
    }
    
    func removeSongFromMasteringEngineerRoles(per: String, completion: @escaping ((Error?) -> Void)) {
        guard per.count == 6 else {
            completion(nil)
            return
        }
        DatabaseManager.shared.fetchPersonData(person: per, completion: {[weak self] result in
            guard let strongSelf = self else {return}
            switch result {
            case .success(let person):
                let ref = Database.database().reference().child("Registered Persons").child("\(person.name!)--\(person.dateRegisteredToApp!)--\(person.timeRegisteredToApp!)--\(person.toneDeafAppId)").child("Roles").child("Engineer").child("Mastering Engineer")
                let song = "\(strongSelf.currSong.toneDeafAppId)"
                var arrTo:[String] = []
                if let roles = person.roles {
                    if let eng = roles["Engineer"] as? NSDictionary {
                        let engDict = eng.mutableCopy() as! NSMutableDictionary
                        if var art = engDict["Mastering Engineer"] as? [String] {
                            if art.contains(song) {
                                let index = art.firstIndex(of: song)
                                art.remove(at: index!)
                                arrTo = art
                            }
                        }
                    }
                }
                
                ref.setValue(arrTo.sorted(), withCompletionBlock: { error, reference in
                    if let error = error {
                        completion(error)
                        return
                    }
                    else {
                        completion(nil)
                        return
                    }
                })
            case .failure(let err):
                print("dsvgredfxbdfzx"+err.localizedDescription)
            }
        })
    }
    
    func addSongToMasteringEngineerRoles(per: String, completion: @escaping ((Error?) -> Void)) {
        guard per.count == 6 else {
            completion(nil)
            return
        }
        
        DatabaseManager.shared.fetchPersonData(person: per, completion: {[weak self] result in
            guard let strongSelf = self else {return}
            switch result {
            case .success(let person):
                let ref = Database.database().reference().child("Registered Persons").child("\(person.name!)--\(person.dateRegisteredToApp!)--\(person.timeRegisteredToApp!)--\(person.toneDeafAppId)").child("Roles").child("Engineer").child("Mastering Engineer")
                let song = "\(strongSelf.currSong.toneDeafAppId)"
                var arrTo:[String] = []
                
                if let roles = person.roles {
                    if let eng = roles["Engineer"] as? NSDictionary {
                        let engDict = eng.mutableCopy() as! NSMutableDictionary
                        if var art = engDict["Mastering Engineer"] as? [String] {
                            if !art.contains(song) {
                                art.append(song)
                                arrTo = art
                            } else {
                                arrTo = art
                            }
                        } else {
                            arrTo = [song]
                        }
                    } else {
                        arrTo = [song]
                    }
                } else {
                    arrTo = [song]
                }
                
                ref.setValue(arrTo.sorted(), withCompletionBlock: { error, reference in
                    if let error = error {
                        completion(error)
                        return
                    }
                    else {
                        completion(nil)
                        return
                    }
                })
            case .failure(let err):
                print("dsvgredfxbdfzx"+err.localizedDescription)
            }
        })
    }
    
    func updateAlbumMasteringEngineer(ref: DatabaseReference, completion: @escaping ((Error?) -> Void)) {
        var initialArtistsArrFromDB:[String]!
        var totalProgress:Int = 0
        var completedProgress:Int = 0
        if currSong.songMasteringEngineer!.sorted() == initSong.songMasteringEngineer?.sorted() {
            completion(nil)
            return
        }
        if currSong.albums == nil {
            completion(nil)
            return
        }
        if currSong.albums!.isEmpty {
            completion(nil)
            return
        }
        
        let albums = currSong.albums!
        
        getSongMasteringEngineersInDB(ref: ref, completion: {[weak self] persons in
            guard let strongSelf = self else {return}
            initialArtistsArrFromDB = persons.sorted()
            
            if !initialArtistsArrFromDB.isEmpty {
                for i in 0 ... initialArtistsArrFromDB.count-1 {
                    if strongSelf.currSong.songMasteringEngineer != nil {
                        if i < strongSelf.currSong.songMasteringEngineer!.count {
                            if !strongSelf.currSong.songMasteringEngineer![i].contains(initialArtistsArrFromDB[i]) {
                                for alb in albums {
                                    totalProgress+=1
                                }
                            }
                        } else {
                            for alb in albums {
                                totalProgress+=1
                            }
                        }
                    } else {
                        for alb in albums {
                            totalProgress+=1
                        }
                    }
                }
            }
            
            if strongSelf.currSong.songMasteringEngineer != nil {
                if !strongSelf.currSong.songMasteringEngineer!.isEmpty {
                    for i in 0 ... strongSelf.currSong.songMasteringEngineer!.count-1 {
                        if i < initialArtistsArrFromDB.count {
                            if !initialArtistsArrFromDB[i].contains(strongSelf.currSong.songMasteringEngineer![i]) {
                                for alb in albums {
                                    totalProgress+=1
                                }
                            }
                        } else {
                            for alb in albums {
                                totalProgress+=1
                            }
                        }
                    }
                }
            }
            
            if !initialArtistsArrFromDB.isEmpty {
                for i in 0 ... initialArtistsArrFromDB.count-1 {
                    if strongSelf.currSong.songMasteringEngineer != nil {
                        if i < strongSelf.currSong.songMasteringEngineer!.count {
                            if !strongSelf.currSong.songMasteringEngineer![i].contains(initialArtistsArrFromDB[i]) {
                                for alb in albums {
                                    strongSelf.removeMasteringEngineerFromAlbum(alb: alb, per: initialArtistsArrFromDB[i], completion: { error in
                                        completedProgress+=1
                                        if let error = error {
                                            completion(error)
                                            return
                                        } else {
                                            if completedProgress == totalProgress {
                                                completion(nil)
                                                return
                                            }
                                        }
                                    })
                                }
                            }
                        } else {
                            for alb in albums {
                                strongSelf.removeMasteringEngineerFromAlbum(alb: alb, per: initialArtistsArrFromDB[i], completion: { error in
                                    completedProgress+=1
                                    if let error = error {
                                        completion(error)
                                        return
                                    } else {
                                        if completedProgress == totalProgress {
                                            completion(nil)
                                            return
                                        }
                                    }
                                })
                            }
                        }
                    } else {
                        for alb in albums {
                            strongSelf.removeMasteringEngineerFromAlbum(alb: alb, per: initialArtistsArrFromDB[i], completion: { error in
                                completedProgress+=1
                                if let error = error {
                                    completion(error)
                                    return
                                } else {
                                    if completedProgress == totalProgress {
                                        completion(nil)
                                        return
                                    }
                                }
                            })
                        }
                    }
                }
            }
            
            if strongSelf.currSong.songMasteringEngineer != nil {
                if !strongSelf.currSong.songMasteringEngineer!.isEmpty {
                    for i in 0 ... strongSelf.currSong.songMasteringEngineer!.count-1 {
                        if i < initialArtistsArrFromDB.count {
                            if !initialArtistsArrFromDB[i].contains(strongSelf.currSong.songMasteringEngineer![i]) {
                                for album in albums {
                                    strongSelf.addMasteringEngineerToAlbum(alb: album, per: strongSelf.currSong.songMasteringEngineer![i], completion: { error in
                                        completedProgress+=1
                                        if let error = error {
                                            completion(error)
                                            return
                                        } else {
                                            if completedProgress == totalProgress {
                                                completion(nil)
                                                return
                                            }
                                        }
                                    })
                                }
                            }
                        } else {
                            for album in albums {
                                strongSelf.addMasteringEngineerToAlbum(alb: album, per: strongSelf.currSong.songMasteringEngineer![i], completion: { error in
                                    completedProgress+=1
                                    if let error = error {
                                        completion(error)
                                        return
                                    } else {
                                        if completedProgress == totalProgress {
                                            completion(nil)
                                            return
                                        }
                                    }
                                })
                            }
                        }
                    }
                }
            }
            
        })
    }
    
    func removeMasteringEngineerFromAlbum(alb: String, per: String, completion: @escaping ((Error?) -> Void)) {
        guard alb.count == 8 else {
            completion(nil)
            return
        }
        DatabaseManager.shared.findAlbumById(albumId: alb, completion: {[weak self] result in
            guard let strongSelf = self else {return}
            switch result {
            case .success(let album):
                let ref = Database.database().reference().child("Music Content").child("Albums").child("\(albumContentTag)--\(album.name)--\(album.toneDeafAppId)").child("REQUIRED").child("Engineers").child("Mastering Engineer")
                var arrTo:[String] = []
                DatabaseManager.shared.fetchPersonData(person: per, completion: { result in
                    guard let strongSelf = self else {return}
                    switch result {
                    case .success(let person):
                        var roleMArkedOnAnotherSong:Bool = false
                        if let asong = album.songs {
                            for song in asong {
                                if let proles = person.roles {
                                    if let eng = proles["Engineer"] as? NSDictionary {
                                        let engdict = eng.mutableCopy() as! NSMutableDictionary
                                        if let parr = engdict["Mastering Engineer"] as? [String] {
                                            if parr.contains(song) {
                                                if song != strongSelf.currSong.toneDeafAppId {
                                                    roleMArkedOnAnotherSong = true
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                        if let asong = album.instrumentals {
                            for song in asong {
                                if let proles = person.roles {
                                    if let eng = proles["Engineer"] as? NSDictionary {
                                        let engdict = eng.mutableCopy() as! NSMutableDictionary
                                        if let parr = engdict["Mastering Engineer"] as? [String] {
                                            if parr.contains(song) {
                                                if song != strongSelf.currSong.toneDeafAppId {
                                                    roleMArkedOnAnotherSong = true
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                        if roleMArkedOnAnotherSong == false {
                            if var arrr = album.masteringEngineers {
                                let index = arrr.firstIndex(of: per)
                                arrr.remove(at: index!)
                                arrTo = arrr
                            } else {
                                var arrr:[String] = []
                                let index = arrr.firstIndex(of: per)
                                arrr.remove(at: index!)
                                arrTo = arrr
                            }
                            ref.setValue(arrTo.sorted(), withCompletionBlock: { error, reference in
                                if let error = error {
                                    completion(error)
                                    return
                                }
                                else {
                                    strongSelf.removeAlbumFromPersonMasteringEngineer(alb: alb, per: per, completion: { error in
                                        if let error = error {
                                            completion(error)
                                            return
                                        }
                                        else {
                                            completion(nil)
                                            return
                                        }
                                    })
                                }
                            })
                        } else {
                            completion(nil)
                        }
                        
                    case .failure(let err):
                        print("dsvgredfxbdfzx"+err.localizedDescription)
                    }
                    
                })
            case .failure(let err):
                print("dsvgredfxbdfzx"+err.localizedDescription)
            }
        })
    }
    
    func addMasteringEngineerToAlbum(alb: String,per: String, completion: @escaping ((Error?) -> Void)) {
        guard alb.count == 8 else {
            completion(nil)
            return
        }
        
        DatabaseManager.shared.findAlbumById(albumId: alb, completion: {[weak self] result in
            guard let strongSelf = self else {return}
            switch result {
            case .success(let album):
                let ref = Database.database().reference().child("Music Content").child("Albums").child("\(albumContentTag)--\(album.name)--\(album.toneDeafAppId)").child("REQUIRED").child("Engineers").child("Mastering Engineer")
                var arrTo:[String] = []
                
                if var arrr = album.masteringEngineers {
                    if !arrr.contains(per) {
                        arrr.append(per)
                        arrTo = arrr
                    } else {
                        arrTo = arrr
                    }
                } else {
                    var arrr:[String] = []
                    arrr.append(per)
                    arrTo = arrr
                }
                
                
                ref.setValue(arrTo.sorted(), withCompletionBlock: { error, reference in
                    if let error = error {
                        completion(error)
                        return
                    }
                    else {
                        strongSelf.addAlbumToPersonMasteringEngineer(alb: [alb], per: per, completion: { error in
                            if let error = error {
                                completion(error)
                                return
                            }
                            else {
                                completion(nil)
                                return
                            }
                        })
                        
                    }
                })
            case .failure(let err):
                print("dsvgredfxbdfzx"+err.localizedDescription)
            }
        })
    }
    
    func addAlbumToPersonMasteringEngineer(alb: [String],per: String, completion: @escaping ((Error?) -> Void)) {
        DatabaseManager.shared.fetchPersonData(person: per, completion: {[weak self] result in
            guard let strongSelf = self else {return}
            switch result {
            case .success(let person):
                let ref = Database.database().reference().child("Registered Persons").child("\(person.name!)--\(person.dateRegisteredToApp!)--\(person.timeRegisteredToApp!)--\(person.toneDeafAppId)").child("Albums")
                var arrTo:[String] = []
                strongSelf.getPersonAlbumsInDB(ref: Database.database().reference().child("Registered Persons").child("\(person.name!)--\(person.dateRegisteredToApp!)--\(person.timeRegisteredToApp!)--\(person.toneDeafAppId)"), completion: { albumns in
                    var albbums = albumns
                    for element in alb {
                        if !albbums.contains(element) {
                            albbums.append(element)
                            arrTo = albbums
                        } else {
                            arrTo = albbums
                        }
                    }
                    ref.setValue(arrTo.sorted(), withCompletionBlock: { error, reference in
                        if let error = error {
                            completion(error)
                            return
                        }
                        else {
                            let ref2 = Database.database().reference().child("Registered Persons").child("\(person.name!)--\(person.dateRegisteredToApp!)--\(person.timeRegisteredToApp!)--\(person.toneDeafAppId)").child("Roles").child("Engineer").child("Mastering Engineer")
                            var arrTo2:[String] = []
                            if let currole = person.roles {
                                if let eng = currole["Engineer"] as? NSDictionary {
                                    let engDict = eng.mutableCopy() as! NSMutableDictionary
                                    if var arrrry = engDict["Mastering Engineer"] as? [String] {
                                        for element in alb {
                                            if !arrrry.contains(element) {
                                                arrrry.append(element)
                                                arrTo2 = arrrry.sorted()
                                            } else {
                                                arrTo2 = arrrry.sorted()
                                            }
                                        }
                                    } else {
                                        arrTo2 = alb
                                    }
                                } else {
                                    arrTo2 = alb
                                }
                            } else {
                                arrTo2 = alb
                            }
                            ref2.setValue(arrTo2.sorted(), withCompletionBlock: { error, reference in
                                if let error = error {
                                    completion(error)
                                    return
                                }
                                else {
                                    completion(nil)
                                    return
                                }
                            })
                        }
                    })
                })
            case .failure(let err):
                print("dsvgredfxbdfzx"+err.localizedDescription)
            }
        })
    }
    
    func removeAlbumFromPersonMasteringEngineer(alb: String,per: String, completion: @escaping ((Error?) -> Void)) {
        DatabaseManager.shared.fetchPersonData(person: per, completion: {[weak self] result in
            guard let strongSelf = self else {return}
            switch result {
            case .success(let person):
                let ref = Database.database().reference().child("Registered Persons").child("\(person.name!)--\(person.dateRegisteredToApp!)--\(person.timeRegisteredToApp!)--\(person.toneDeafAppId)").child("Albums")
                var arrTo:[String] = []
                if var albbums = person.albums {
                    if let index = albbums.firstIndex(of: alb) {
                        albbums.remove(at: index)
                    }
                    for element in strongSelf.removedAlbs {
                        if albbums.contains(element) {
                            if let index = albbums.firstIndex(of: element) {
                                albbums.remove(at: index)
                            }
                        }
                    }
                    arrTo = albbums
                }
                ref.setValue(arrTo.sorted(), withCompletionBlock: { error, reference in
                    if let error = error {
                        completion(error)
                        return
                    }
                    else {
                        let ref2 = Database.database().reference().child("Registered Persons").child("\(person.name!)--\(person.dateRegisteredToApp!)--\(person.timeRegisteredToApp!)--\(person.toneDeafAppId)").child("Roles").child("Engineer").child("Mastering Engineer")
                        var arrTo2:[String] = []
                        if let currole = person.roles {
                            if let eng = currole["Engineer"] as? NSDictionary {
                                let engDict = eng.mutableCopy() as! NSMutableDictionary
                                if var arrrry = engDict["Mastering Engineer"] as? [String] {
                                    if let index = arrrry.firstIndex(of: alb) {
                                        arrrry.remove(at: index)
                                    }
                                    for element in strongSelf.removedAlbs {
                                        if arrrry.contains(element) {
                                            if let index = arrrry.firstIndex(of: element) {
                                                arrrry.remove(at: index)
                                            }
                                        }
                                    }
                                    arrTo2 = arrrry.sorted()
                                }
                            }
                        }
                        if !strongSelf.removedAlbs.contains(alb) {
                            strongSelf.removedAlbs.append(alb)
                        }
                        ref2.setValue(arrTo2.sorted(), withCompletionBlock: { error, reference in
                            if let error = error {
                                completion(error)
                                return
                            }
                            else {
                                completion(nil)
                                return
                            }
                        })
                    }
                })
            case .failure(let err):
                print("dsvgredfxbdfzx"+err.localizedDescription)
            }
        })
    }
    
    //MARK: - Recording Engineers
    func processRecordingEngineers(initialSong: SongData, currentSong: SongData, completion: @escaping (([Error]?) -> Void)) {
        initSong = initialSong
        currSong = currentSong
        
        initRef = Database.database().reference().child("Music Content").child("Songs").child("\(songContentTag)--\(initSong.name)--\(initSong.toneDeafAppId)")
        currRef = Database.database().reference().child("Music Content").child("Songs").child("\(songContentTag)--\(currSong.name)--\(currSong.toneDeafAppId)")
        var errors:[Error] = []
        var dataUploadCompletionStatus1:Bool!
        var dataUploadCompletionStatus2:Bool!
        var dataUploadCompletionStatus3:Bool!
        var dataUploadCompletionStatus4:Bool!
        var dataUploadCompletionStatus5:Bool!
        var dataUploadCompletionStatus6:Bool!
        var dataUploadCompletionStatus7:Bool!
        var dataUploadCompletionStatus8:Bool!
        var dataUploadCompletionStatus9:Bool!
        var dataUploadCompletionStatus10:Bool!
        
        let aqueue = DispatchQueue(label: "myhjvkheditingQsongRecordingEngineerhfdChangessseue")
        let agroup = DispatchGroup()
        let array:[Int] = [1,2,3,4]
        for i in array {
            agroup.enter()
            aqueue.async { [weak self] in
                guard let strongSelf = self else {return}
                switch i {
                case 1:
                    strongSelf.updateSongRecordingEngineers(ref: strongSelf.currRef, completion: {err in
                        if let error = err {
                            dataUploadCompletionStatus1 = false
                            errors.append(error)
                        } else {
                            dataUploadCompletionStatus1 = true
                            print("Song RecordingEngineer Update done \(1)")
                        }
                        agroup.leave()
                    })
                case 2:
                    strongSelf.updateRecordingEngineerSongs(ref: strongSelf.currRef, completion: {err in
                        if let error = err {
                            dataUploadCompletionStatus2 = false
                            errors.append(error)
                        } else {
                            dataUploadCompletionStatus2 = true
                            print("RecordingEngineer Songs Update done \(1)")
                        }
                        agroup.leave()
                    })
                case 3:
                    strongSelf.updateRecordingEngineerRoles(ref: strongSelf.currRef, completion: {err in
                        if let error = err {
                            dataUploadCompletionStatus3 = false
                            errors.append(error)
                        } else {
                            dataUploadCompletionStatus3 = true
                            print("RecordingEngineer roles Update done \(1)")
                        }
                        agroup.leave()
                    })
                case 4:
                    strongSelf.updateAlbumRecordingEngineer(ref: strongSelf.currRef, completion: {err in
                        if let error = err {
                            dataUploadCompletionStatus4 = false
                            errors.append(error)
                        } else {
                            dataUploadCompletionStatus4 = true
                            print("RecordingEngineer Album roles Update done \(1)")
                        }
                        agroup.leave()
                    })
                default:
                    break
                }
            }
        }
        agroup.notify(queue: DispatchQueue.main) {
            if dataUploadCompletionStatus1 == false || dataUploadCompletionStatus2 == false || dataUploadCompletionStatus3 == false || dataUploadCompletionStatus4 == false {
                completion(errors)
                return
            } else {
                completion(nil)
            }
        }
    }
    
    func updateSongRecordingEngineers(ref: DatabaseReference, completion: @escaping ((Error?) -> Void)) {
        var initialArtistsArrFromDB:[String]!
        if currSong.songRecordingEngineer!.sorted() == initSong.songRecordingEngineer?.sorted() {
            completion(nil)
            return
        }
        getSongRecordingEngineersInDB(ref: ref, completion: {[weak self] persons in
            guard let strongSelf = self else {return}
            initialArtistsArrFromDB = persons.sorted()
            
            if !initialArtistsArrFromDB.isEmpty {
                var removalCounter = 0
                for i in 0 ... initialArtistsArrFromDB.count-1 {
                    if strongSelf.currSong.songRecordingEngineer != nil {
                        if i < strongSelf.currSong.songRecordingEngineer!.count {
                            if !strongSelf.currSong.songRecordingEngineer![i].contains(initialArtistsArrFromDB[i]) {
                                let index = initialArtistsArrFromDB.firstIndex(of: initialArtistsArrFromDB[i])
                                initialArtistsArrFromDB.remove(at: index!)
                                removalCounter+=1
                            }
                        } else {
                            let index = initialArtistsArrFromDB.firstIndex(of: initialArtistsArrFromDB[i-removalCounter])
                            initialArtistsArrFromDB.remove(at: index!)
                            removalCounter+=1
                        }
                    } else {
                        let index = initialArtistsArrFromDB.firstIndex(of: initialArtistsArrFromDB[i-removalCounter])
                        initialArtistsArrFromDB.remove(at: index!)
                        removalCounter+=1
                    }
                }
            }
            
            if strongSelf.currSong.songRecordingEngineer != nil {
                if !strongSelf.currSong.songRecordingEngineer!.isEmpty {
                    for i in 0 ... strongSelf.currSong.songRecordingEngineer!.count-1 {
                        if i < initialArtistsArrFromDB.count {
                            if !initialArtistsArrFromDB[i].contains(strongSelf.currSong.songRecordingEngineer![i]) {
                                initialArtistsArrFromDB.append(strongSelf.currSong.songRecordingEngineer![i])
                            }
                        } else {
                            initialArtistsArrFromDB.append(strongSelf.currSong.songRecordingEngineer![i])
                        }
                    }
                }
            }
            ref.child("REQUIRED").child("Engineers").child("Recording Engineer").setValue(initialArtistsArrFromDB.sorted(), withCompletionBlock: { error, reference in
                if let error = error {
                    completion(error)
                    return
                }
                else {
                    completion(nil)
                    return
                }
            })
            
        })
    }
    
    func getSongRecordingEngineersInDB(ref: DatabaseReference, completion: @escaping (([String]) -> Void)) {
        ref.child("REQUIRED").child("Engineers").child("Recording Engineer").observeSingleEvent(of: .value, with: { snapshot in
            var mysongsArray:[String] = []
            if let val = snapshot.value {
                let valu = val as? [String]
                guard let value = valu else {
                    completion(mysongsArray)
                    return}
                if value[0] != "" {
                    mysongsArray = value
                }
                completion(mysongsArray)
            } else {
                completion(mysongsArray)
            }
        })
    }
    
    func updateRecordingEngineerSongs(ref: DatabaseReference, completion: @escaping ((Error?) -> Void)) {
        var initialArtistsArrFromDB:[String]!
        var totalProgress:Int = 0
        var completedProgress:Int = 0
        if currSong.songRecordingEngineer!.sorted() == initSong.songRecordingEngineer?.sorted() {
            completion(nil)
            return
        }
        
        getSongRecordingEngineersInDB(ref: ref, completion: {[weak self] persons in
            guard let strongSelf = self else {return}
            initialArtistsArrFromDB = persons.sorted()
            
            if !initialArtistsArrFromDB.isEmpty {
                var removalCounter = 0
                for i in 0 ... initialArtistsArrFromDB.count-1 {
                    if strongSelf.currSong.songRecordingEngineer != nil {
                        if i < strongSelf.currSong.songRecordingEngineer!.count {
                            if !strongSelf.currSong.songRecordingEngineer![i].contains(initialArtistsArrFromDB[i]) {
                                totalProgress+=1
                            }
                        } else {
                            totalProgress+=1
                        }
                    } else {
                        totalProgress+=1
                    }
                }
            }
            
            if strongSelf.currSong.songRecordingEngineer != nil {
                if !strongSelf.currSong.songRecordingEngineer!.isEmpty {
                    for i in 0 ... strongSelf.currSong.songRecordingEngineer!.count-1 {
                        if i < initialArtistsArrFromDB.count {
                            if !initialArtistsArrFromDB[i].contains(strongSelf.currSong.songRecordingEngineer![i]) {
                                totalProgress+=1
                            }
                        } else {
                            totalProgress+=1
                        }
                    }
                }
            }
            
            if !initialArtistsArrFromDB.isEmpty {
                for i in 0 ... initialArtistsArrFromDB.count-1 {
                    if strongSelf.currSong.songRecordingEngineer != nil {
                        if i < strongSelf.currSong.songRecordingEngineer!.count {
                            if !strongSelf.currSong.songRecordingEngineer![i].contains(initialArtistsArrFromDB[i]) {
                                strongSelf.removeSongFromPerson(per: initialArtistsArrFromDB[i], completion: { error in
                                    completedProgress+=1
                                    if let error = error {
                                        completion(error)
                                        return
                                    } else {
                                        if completedProgress == totalProgress {
                                            completion(nil)
                                            return
                                        }
                                    }
                                })
                            }
                        } else {
                            strongSelf.removeSongFromPerson(per: initialArtistsArrFromDB[i], completion: { error in
                                completedProgress+=1
                                if let error = error {
                                    completion(error)
                                    return
                                } else {
                                    if completedProgress == totalProgress {
                                        completion(nil)
                                        return
                                    }
                                }
                            })
                        }
                    } else {
                        strongSelf.removeSongFromPerson(per: initialArtistsArrFromDB[i], completion: { error in
                            completedProgress+=1
                            if let error = error {
                                completion(error)
                                return
                            } else {
                                if completedProgress == totalProgress {
                                    completion(nil)
                                    return
                                }
                            }
                        })
                    }
                }
            }
            
            if strongSelf.currSong.songRecordingEngineer != nil {
                if !strongSelf.currSong.songRecordingEngineer!.isEmpty {
                    for i in 0 ... strongSelf.currSong.songRecordingEngineer!.count-1 {
                        if i < initialArtistsArrFromDB.count {
                            if !initialArtistsArrFromDB[i].contains(strongSelf.currSong.songRecordingEngineer![i]) {
                                strongSelf.addSongToPerson(per: strongSelf.currSong.songRecordingEngineer![i], completion: { error in
                                    completedProgress+=1
                                    if let error = error {
                                        completion(error)
                                        return
                                    } else {
                                        if completedProgress == totalProgress {
                                            completion(nil)
                                            return
                                        }
                                    }
                                })
                            }
                        } else {
                            strongSelf.addSongToPerson(per: strongSelf.currSong.songRecordingEngineer![i], completion: { error in
                                completedProgress+=1
                                if let error = error {
                                    completion(error)
                                    return
                                } else {
                                    if completedProgress == totalProgress {
                                        completion(nil)
                                        return
                                    }
                                }
                            })
                        }
                    }
                }
            }
            
        })
    }
    
    func updateRecordingEngineerRoles(ref: DatabaseReference, completion: @escaping ((Error?) -> Void)) {
        var initialArtistsArrFromDB:[String]!
        var totalProgress:Int = 0
        var completedProgress:Int = 0
        if currSong.songRecordingEngineer!.sorted() == initSong.songRecordingEngineer?.sorted() {
            completion(nil)
            return
        }
        
        getSongRecordingEngineersInDB(ref: ref, completion: {[weak self] persons in
            guard let strongSelf = self else {return}
            initialArtistsArrFromDB = persons.sorted()
            
            if !initialArtistsArrFromDB.isEmpty {
                for i in 0 ... initialArtistsArrFromDB.count-1 {
                    if strongSelf.currSong.songRecordingEngineer != nil {
                        if i < strongSelf.currSong.songRecordingEngineer!.count {
                            if !strongSelf.currSong.songRecordingEngineer![i].contains(initialArtistsArrFromDB[i]) {
                                totalProgress+=1
                            }
                        } else {
                            totalProgress+=1
                        }
                    } else {
                        totalProgress+=1
                    }
                }
            }
            
            if strongSelf.currSong.songRecordingEngineer != nil {
                if !strongSelf.currSong.songRecordingEngineer!.isEmpty {
                    for i in 0 ... strongSelf.currSong.songRecordingEngineer!.count-1 {
                        if i < initialArtistsArrFromDB.count {
                            if !initialArtistsArrFromDB[i].contains(strongSelf.currSong.songRecordingEngineer![i]) {
                                totalProgress+=1
                            }
                        } else {
                            totalProgress+=1
                        }
                    }
                }
            }
            
            if !initialArtistsArrFromDB.isEmpty {
                for i in 0 ... initialArtistsArrFromDB.count-1 {
                    if strongSelf.currSong.songRecordingEngineer != nil {
                        if i < strongSelf.currSong.songRecordingEngineer!.count {
                            if !strongSelf.currSong.songRecordingEngineer![i].contains(initialArtistsArrFromDB[i]) {
                                strongSelf.removeSongFromRecordingEngineerRoles(per: initialArtistsArrFromDB[i], completion: { error in
                                    completedProgress+=1
                                    if let error = error {
                                        completion(error)
                                        return
                                    } else {
                                        if completedProgress == totalProgress {
                                            completion(nil)
                                            return
                                        }
                                    }
                                })
                            }
                        } else {
                            strongSelf.removeSongFromRecordingEngineerRoles(per: initialArtistsArrFromDB[i], completion: { error in
                                completedProgress+=1
                                if let error = error {
                                    completion(error)
                                    return
                                } else {
                                    if completedProgress == totalProgress {
                                        completion(nil)
                                        return
                                    }
                                }
                            })
                        }
                    } else {
                        strongSelf.removeSongFromRecordingEngineerRoles(per: initialArtistsArrFromDB[i], completion: { error in
                            completedProgress+=1
                            if let error = error {
                                completion(error)
                                return
                            } else {
                                if completedProgress == totalProgress {
                                    completion(nil)
                                    return
                                }
                            }
                        })
                    }
                }
            }
            
            if strongSelf.currSong.songRecordingEngineer != nil {
                if !strongSelf.currSong.songRecordingEngineer!.isEmpty {
                    for i in 0 ... strongSelf.currSong.songRecordingEngineer!.count-1 {
                        if i < initialArtistsArrFromDB.count {
                            if !initialArtistsArrFromDB[i].contains(strongSelf.currSong.songRecordingEngineer![i]) {
                                strongSelf.addSongToRecordingEngineerRoles(per: strongSelf.currSong.songRecordingEngineer![i], completion: { error in
                                    completedProgress+=1
                                    if let error = error {
                                        completion(error)
                                        return
                                    } else {
                                        if completedProgress == totalProgress {
                                            completion(nil)
                                            return
                                        }
                                    }
                                })
                            }
                        } else {
                            strongSelf.addSongToRecordingEngineerRoles(per: strongSelf.currSong.songRecordingEngineer![i], completion: { error in
                                completedProgress+=1
                                if let error = error {
                                    completion(error)
                                    return
                                } else {
                                    if completedProgress == totalProgress {
                                        completion(nil)
                                        return
                                    }
                                }
                            })
                        }
                    }
                }
            }
            
        })
    }
    
    func removeSongFromRecordingEngineerRoles(per: String, completion: @escaping ((Error?) -> Void)) {
        guard per.count == 6 else {
            completion(nil)
            return
        }
        DatabaseManager.shared.fetchPersonData(person: per, completion: {[weak self] result in
            guard let strongSelf = self else {return}
            switch result {
            case .success(let person):
                let ref = Database.database().reference().child("Registered Persons").child("\(person.name!)--\(person.dateRegisteredToApp!)--\(person.timeRegisteredToApp!)--\(person.toneDeafAppId)").child("Roles").child("Engineer").child("Recording Engineer")
                let song = "\(strongSelf.currSong.toneDeafAppId)"
                var arrTo:[String] = []
                if let roles = person.roles {
                    if let eng = roles["Engineer"] as? NSDictionary {
                        let engDict = eng.mutableCopy() as! NSMutableDictionary
                        if var art = engDict["Recording Engineer"] as? [String] {
                            if art.contains(song) {
                                let index = art.firstIndex(of: song)
                                art.remove(at: index!)
                                arrTo = art
                            }
                        }
                    }
                }
                
                ref.setValue(arrTo.sorted(), withCompletionBlock: { error, reference in
                    if let error = error {
                        completion(error)
                        return
                    }
                    else {
                        completion(nil)
                        return
                    }
                })
            case .failure(let err):
                print("dsvgredfxbdfzx"+err.localizedDescription)
            }
        })
    }
    
    func addSongToRecordingEngineerRoles(per: String, completion: @escaping ((Error?) -> Void)) {
        guard per.count == 6 else {
            completion(nil)
            return
        }
        
        DatabaseManager.shared.fetchPersonData(person: per, completion: {[weak self] result in
            guard let strongSelf = self else {return}
            switch result {
            case .success(let person):
                let ref = Database.database().reference().child("Registered Persons").child("\(person.name!)--\(person.dateRegisteredToApp!)--\(person.timeRegisteredToApp!)--\(person.toneDeafAppId)").child("Roles").child("Engineer").child("Recording Engineer")
                let song = "\(strongSelf.currSong.toneDeafAppId)"
                var arrTo:[String] = []
                
                if let roles = person.roles {
                    if let eng = roles["Engineer"] as? NSDictionary {
                        let engDict = eng.mutableCopy() as! NSMutableDictionary
                        if var art = engDict["Recording Engineer"] as? [String] {
                            if !art.contains(song) {
                                art.append(song)
                                arrTo = art
                            } else {
                                arrTo = art
                            }
                        } else {
                            arrTo = [song]
                        }
                    } else {
                        arrTo = [song]
                    }
                } else {
                    arrTo = [song]
                }
                
                ref.setValue(arrTo.sorted(), withCompletionBlock: { error, reference in
                    if let error = error {
                        completion(error)
                        return
                    }
                    else {
                        completion(nil)
                        return
                    }
                })
            case .failure(let err):
                print("dsvgredfxbdfzx"+err.localizedDescription)
            }
        })
    }
    
    func updateAlbumRecordingEngineer(ref: DatabaseReference, completion: @escaping ((Error?) -> Void)) {
        var initialArtistsArrFromDB:[String]!
        var totalProgress:Int = 0
        var completedProgress:Int = 0
        if currSong.songRecordingEngineer!.sorted() == initSong.songRecordingEngineer?.sorted() {
            completion(nil)
            return
        }
        if currSong.albums == nil {
            completion(nil)
            return
        }
        if currSong.albums!.isEmpty {
            completion(nil)
            return
        }
        
        let albums = currSong.albums!
        
        getSongRecordingEngineersInDB(ref: ref, completion: {[weak self] persons in
            guard let strongSelf = self else {return}
            initialArtistsArrFromDB = persons.sorted()
            
            if !initialArtistsArrFromDB.isEmpty {
                for i in 0 ... initialArtistsArrFromDB.count-1 {
                    if strongSelf.currSong.songRecordingEngineer != nil {
                        if i < strongSelf.currSong.songRecordingEngineer!.count {
                            if !strongSelf.currSong.songRecordingEngineer![i].contains(initialArtistsArrFromDB[i]) {
                                for alb in albums {
                                    totalProgress+=1
                                }
                            }
                        } else {
                            for alb in albums {
                                totalProgress+=1
                            }
                        }
                    } else {
                        for alb in albums {
                            totalProgress+=1
                        }
                    }
                }
            }
            
            if strongSelf.currSong.songRecordingEngineer != nil {
                if !strongSelf.currSong.songRecordingEngineer!.isEmpty {
                    for i in 0 ... strongSelf.currSong.songRecordingEngineer!.count-1 {
                        if i < initialArtistsArrFromDB.count {
                            if !initialArtistsArrFromDB[i].contains(strongSelf.currSong.songRecordingEngineer![i]) {
                                for alb in albums {
                                    totalProgress+=1
                                }
                            }
                        } else {
                            for alb in albums {
                                totalProgress+=1
                            }
                        }
                    }
                }
            }
            
            if !initialArtistsArrFromDB.isEmpty {
                for i in 0 ... initialArtistsArrFromDB.count-1 {
                    if strongSelf.currSong.songRecordingEngineer != nil {
                        if i < strongSelf.currSong.songRecordingEngineer!.count {
                            if !strongSelf.currSong.songRecordingEngineer![i].contains(initialArtistsArrFromDB[i]) {
                                for alb in albums {
                                    strongSelf.removeRecordingEngineerFromAlbum(alb: alb, per: initialArtistsArrFromDB[i], completion: { error in
                                        completedProgress+=1
                                        if let error = error {
                                            completion(error)
                                            return
                                        } else {
                                            if completedProgress == totalProgress {
                                                completion(nil)
                                                return
                                            }
                                        }
                                    })
                                }
                            }
                        } else {
                            for alb in albums {
                                strongSelf.removeRecordingEngineerFromAlbum(alb: alb, per: initialArtistsArrFromDB[i], completion: { error in
                                    completedProgress+=1
                                    if let error = error {
                                        completion(error)
                                        return
                                    } else {
                                        if completedProgress == totalProgress {
                                            completion(nil)
                                            return
                                        }
                                    }
                                })
                            }
                        }
                    } else {
                        for alb in albums {
                            strongSelf.removeRecordingEngineerFromAlbum(alb: alb, per: initialArtistsArrFromDB[i], completion: { error in
                                completedProgress+=1
                                if let error = error {
                                    completion(error)
                                    return
                                } else {
                                    if completedProgress == totalProgress {
                                        completion(nil)
                                        return
                                    }
                                }
                            })
                        }
                    }
                }
            }
            
            if strongSelf.currSong.songRecordingEngineer != nil {
                if !strongSelf.currSong.songRecordingEngineer!.isEmpty {
                    for i in 0 ... strongSelf.currSong.songRecordingEngineer!.count-1 {
                        if i < initialArtistsArrFromDB.count {
                            if !initialArtistsArrFromDB[i].contains(strongSelf.currSong.songRecordingEngineer![i]) {
                                for album in albums {
                                    strongSelf.addRecordingEngineerToAlbum(alb: album, per: strongSelf.currSong.songRecordingEngineer![i], completion: { error in
                                        completedProgress+=1
                                        if let error = error {
                                            completion(error)
                                            return
                                        } else {
                                            if completedProgress == totalProgress {
                                                completion(nil)
                                                return
                                            }
                                        }
                                    })
                                }
                            }
                        } else {
                            for album in albums {
                                strongSelf.addRecordingEngineerToAlbum(alb: album, per: strongSelf.currSong.songRecordingEngineer![i], completion: { error in
                                    completedProgress+=1
                                    if let error = error {
                                        completion(error)
                                        return
                                    } else {
                                        if completedProgress == totalProgress {
                                            completion(nil)
                                            return
                                        }
                                    }
                                })
                            }
                        }
                    }
                }
            }
            
        })
    }
    
    func removeRecordingEngineerFromAlbum(alb: String, per: String, completion: @escaping ((Error?) -> Void)) {
        guard alb.count == 8 else {
            completion(nil)
            return
        }
        DatabaseManager.shared.findAlbumById(albumId: alb, completion: {[weak self] result in
            guard let strongSelf = self else {return}
            switch result {
            case .success(let album):
                let ref = Database.database().reference().child("Music Content").child("Albums").child("\(albumContentTag)--\(album.name)--\(album.toneDeafAppId)").child("REQUIRED").child("Engineers").child("Recording Engineer")
                var arrTo:[String] = []
                DatabaseManager.shared.fetchPersonData(person: per, completion: { result in
                    guard let strongSelf = self else {return}
                    switch result {
                    case .success(let person):
                        var roleMArkedOnAnotherSong:Bool = false
                        if let asong = album.songs {
                            for song in asong {
                                if let proles = person.roles {
                                    if let eng = proles["Engineer"] as? NSDictionary {
                                        let engdict = eng.mutableCopy() as! NSMutableDictionary
                                        if let parr = engdict["Recording Engineer"] as? [String] {
                                            if parr.contains(song) {
                                                if song != strongSelf.currSong.toneDeafAppId {
                                                    roleMArkedOnAnotherSong = true
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                        if let asong = album.instrumentals {
                            for song in asong {
                                if let proles = person.roles {
                                    if let eng = proles["Engineer"] as? NSDictionary {
                                        let engdict = eng.mutableCopy() as! NSMutableDictionary
                                        if let parr = engdict["Recording Engineer"] as? [String] {
                                            if parr.contains(song) {
                                                if song != strongSelf.currSong.toneDeafAppId {
                                                    roleMArkedOnAnotherSong = true
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                        if roleMArkedOnAnotherSong == false {
                            if var arrr = album.recordingEngineers {
                                let index = arrr.firstIndex(of: per)
                                arrr.remove(at: index!)
                                arrTo = arrr
                            } else {
                                var arrr:[String] = []
                                let index = arrr.firstIndex(of: per)
                                arrr.remove(at: index!)
                                arrTo = arrr
                            }
                            ref.setValue(arrTo.sorted(), withCompletionBlock: { error, reference in
                                if let error = error {
                                    completion(error)
                                    return
                                }
                                else {
                                    strongSelf.removeAlbumFromPersonRecordingEngineer(alb: alb, per: per, completion: { error in
                                        if let error = error {
                                            completion(error)
                                            return
                                        }
                                        else {
                                            completion(nil)
                                            return
                                        }
                                    })
                                }
                            })
                        } else {
                            completion(nil)
                        }
                        
                    case .failure(let err):
                        print("dsvgredfxbdfzx"+err.localizedDescription)
                    }
                    
                })
            case .failure(let err):
                print("dsvgredfxbdfzx"+err.localizedDescription)
            }
        })
    }
    
    func addRecordingEngineerToAlbum(alb: String,per: String, completion: @escaping ((Error?) -> Void)) {
        guard alb.count == 8 else {
            completion(nil)
            return
        }
        
        DatabaseManager.shared.findAlbumById(albumId: alb, completion: {[weak self] result in
            guard let strongSelf = self else {return}
            switch result {
            case .success(let album):
                let ref = Database.database().reference().child("Music Content").child("Albums").child("\(albumContentTag)--\(album.name)--\(album.toneDeafAppId)").child("REQUIRED").child("Engineers").child("Recording Engineer")
                var arrTo:[String] = []
                
                if var arrr = album.masteringEngineers {
                    if !arrr.contains(per) {
                        arrr.append(per)
                        arrTo = arrr
                    } else {
                        arrTo = arrr
                    }
                } else {
                    var arrr:[String] = []
                    arrr.append(per)
                    arrTo = arrr
                }
                
                
                ref.setValue(arrTo.sorted(), withCompletionBlock: { error, reference in
                    if let error = error {
                        completion(error)
                        return
                    }
                    else {
                        strongSelf.addAlbumToPersonRecordingEngineer(alb: [alb], per: per, completion: { error in
                            if let error = error {
                                completion(error)
                                return
                            }
                            else {
                                completion(nil)
                                return
                            }
                        })
                        
                    }
                })
            case .failure(let err):
                print("dsvgredfxbdfzx"+err.localizedDescription)
            }
        })
    }
    
    func addAlbumToPersonRecordingEngineer(alb: [String],per: String, completion: @escaping ((Error?) -> Void)) {
        DatabaseManager.shared.fetchPersonData(person: per, completion: {[weak self] result in
            guard let strongSelf = self else {return}
            switch result {
            case .success(let person):
                let ref = Database.database().reference().child("Registered Persons").child("\(person.name!)--\(person.dateRegisteredToApp!)--\(person.timeRegisteredToApp!)--\(person.toneDeafAppId)").child("Albums")
                var arrTo:[String] = []
                strongSelf.getPersonAlbumsInDB(ref: Database.database().reference().child("Registered Persons").child("\(person.name!)--\(person.dateRegisteredToApp!)--\(person.timeRegisteredToApp!)--\(person.toneDeafAppId)"), completion: { albumns in
                    var albbums = albumns
                    for element in alb {
                        if !albbums.contains(element) {
                            albbums.append(element)
                            arrTo = albbums
                        } else {
                            arrTo = albbums
                        }
                    }
                    ref.setValue(arrTo.sorted(), withCompletionBlock: { error, reference in
                        if let error = error {
                            completion(error)
                            return
                        }
                        else {
                            let ref2 = Database.database().reference().child("Registered Persons").child("\(person.name!)--\(person.dateRegisteredToApp!)--\(person.timeRegisteredToApp!)--\(person.toneDeafAppId)").child("Roles").child("Engineer").child("Recording Engineer")
                            var arrTo2:[String] = []
                            if let currole = person.roles {
                                if let eng = currole["Engineer"] as? NSDictionary {
                                    let engDict = eng.mutableCopy() as! NSMutableDictionary
                                    if var arrrry = engDict["Recording Engineer"] as? [String] {
                                        for element in alb {
                                            if !arrrry.contains(element) {
                                                arrrry.append(element)
                                                arrTo2 = arrrry.sorted()
                                            } else {
                                                arrTo2 = arrrry.sorted()
                                            }
                                        }
                                    } else {
                                        arrTo2 = alb
                                    }
                                } else {
                                    arrTo2 = alb
                                }
                            } else {
                                arrTo2 = alb
                            }
                            ref2.setValue(arrTo2.sorted(), withCompletionBlock: { error, reference in
                                if let error = error {
                                    completion(error)
                                    return
                                }
                                else {
                                    completion(nil)
                                    return
                                }
                            })
                        }
                    })
                })
            case .failure(let err):
                print("dsvgredfxbdfzx"+err.localizedDescription)
            }
        })
    }
    
    func removeAlbumFromPersonRecordingEngineer(alb: String,per: String, completion: @escaping ((Error?) -> Void)) {
        DatabaseManager.shared.fetchPersonData(person: per, completion: {[weak self] result in
            guard let strongSelf = self else {return}
            switch result {
            case .success(let person):
                let ref = Database.database().reference().child("Registered Persons").child("\(person.name!)--\(person.dateRegisteredToApp!)--\(person.timeRegisteredToApp!)--\(person.toneDeafAppId)").child("Albums")
                var arrTo:[String] = []
                if var albbums = person.albums {
                    if let index = albbums.firstIndex(of: alb) {
                        albbums.remove(at: index)
                    }
                    for element in strongSelf.removedAlbs {
                        if albbums.contains(element) {
                            if let index = albbums.firstIndex(of: element) {
                                albbums.remove(at: index)
                            }
                        }
                    }
                    arrTo = albbums
                }
                ref.setValue(arrTo.sorted(), withCompletionBlock: { error, reference in
                    if let error = error {
                        completion(error)
                        return
                    }
                    else {
                        let ref2 = Database.database().reference().child("Registered Persons").child("\(person.name!)--\(person.dateRegisteredToApp!)--\(person.timeRegisteredToApp!)--\(person.toneDeafAppId)").child("Roles").child("Engineer").child("Recording Engineer")
                        var arrTo2:[String] = []
                        if let currole = person.roles {
                            if let eng = currole["Engineer"] as? NSDictionary {
                                let engDict = eng.mutableCopy() as! NSMutableDictionary
                                if var arrrry = engDict["Recording Engineer"] as? [String] {
                                    if let index = arrrry.firstIndex(of: alb) {
                                        arrrry.remove(at: index)
                                    }
                                    for element in strongSelf.removedAlbs {
                                        if arrrry.contains(element) {
                                            if let index = arrrry.firstIndex(of: element) {
                                                arrrry.remove(at: index)
                                            }
                                        }
                                    }
                                    arrTo2 = arrrry.sorted()
                                }
                            }
                        }
                        if !strongSelf.removedAlbs.contains(alb) {
                            strongSelf.removedAlbs.append(alb)
                        }
                        ref2.setValue(arrTo2.sorted(), withCompletionBlock: { error, reference in
                            if let error = error {
                                completion(error)
                                return
                            }
                            else {
                                completion(nil)
                                return
                            }
                        })
                    }
                })
            case .failure(let err):
                print("dsvgredfxbdfzx"+err.localizedDescription)
            }
        })
    }
    
    //MARK: - Spotify
    func processSpotify(initialSong: SongData, currentSong: SongData, initialStatus:Bool?, currentStatus:Bool?, initialURL:String?, currentURL:String?, completion: @escaping (([Error]?) -> Void)) {
        initSong = initialSong
        currSong = currentSong
        var errors:[Error] = []
        initRef = Database.database().reference().child("Music Content").child("Songs").child("\(songContentTag)--\(currSong.name)--\(currSong.toneDeafAppId)")
        currRef = Database.database().reference().child("Music Content").child("Songs").child("\(songContentTag)--\(currSong.name)--\(currSong.toneDeafAppId)")
        
        var dataUploadCompletionStatus1:Bool!
        var dataUploadCompletionStatus2:Bool!
        let queue = DispatchQueue(label: "myhjvkheditingQsongsSpotifyssseue")
        let group = DispatchGroup()
        var array:[Int] = []
        
        if currSong.spotify == nil {
            array.append(3)
        } else {
            if initialStatus != currentStatus {
                array.append(1)
            }
            if currentURL != initialURL {
                array.append(2)
            }
        }
        for i in array {
            group.enter()
            queue.async { [weak self] in
                guard let strongSelf = self else {return}
                switch i {
                case 1:
                    strongSelf.processSpotifyStatus(ref: strongSelf.currRef, currentStatus: currentStatus, completion: {err in
                        if let error = err {
                            dataUploadCompletionStatus1 = false
                            errors.append(error)
                        } else {
                            dataUploadCompletionStatus1 = true
                            print("Spotify URL done \(i)")
                        }
                        group.leave()
                    })
                case 2:
                    strongSelf.processSpotifyURL(ref: strongSelf.currRef, currentStatus: currentStatus, currentURL: currentURL, completion: {err in
                        if let error = err {
                            dataUploadCompletionStatus2 = false
                            errors.append(error)
                        } else {
                            dataUploadCompletionStatus2 = true
                            print("Spotify URL done \(i)")
                        }
                        group.leave()
                    })
                case 3:
                    strongSelf.removeSpotify(ref: strongSelf.currRef ,completion: {err in
                        if let error = err {
                            dataUploadCompletionStatus2 = false
                            errors.append(error)
                        } else {
                            dataUploadCompletionStatus2 = true
                            print("Spotify URL done \(i)")
                        }
                        group.leave()
                    })
                default:
                    print("Edit Song error")
                }
            }
        }
        
        group.notify(queue: DispatchQueue.main) {
            if dataUploadCompletionStatus1 == false || dataUploadCompletionStatus2 == false {
                completion(errors)
                return
            } else {
                completion(nil)
            }
        }
    }
    
    func processSpotifyStatus(ref: DatabaseReference, currentStatus: Bool?, completion: @escaping ((Error?) -> Void)) {
        ref.child("\(spotifyMusicContentType)--\(currSong.name)--\(currSong.dateRegisteredToApp!)--\(currSong.timeRegisteredToApp!)").child("Active Status").setValue(currentStatus, withCompletionBlock: { error, reference in
            if let error = error {
                completion(SongEditorError.spotifyUpdateError(error.localizedDescription))
                return
            }
            else {
                completion(nil)
                return
            }
        })
    }
    
    func processSpotifyURL(ref: DatabaseReference, currentStatus: Bool?, currentURL: String?, completion: @escaping ((Error?) -> Void)) {
        let nref = ref.child("\(spotifyMusicContentType)--\(currSong.name)--\(currSong.dateRegisteredToApp!)--\(currSong.timeRegisteredToApp!)")
        var spotUrl = currentURL!
        if let dotRange = spotUrl.range(of: "?") {
            spotUrl.removeSubrange(dotRange.lowerBound..<spotUrl.endIndex)
        }
        let songId = String(spotUrl.suffix(22))
        let token = (UserDefaults.standard.object(forKey: "SPTaccesstoken") as? String)!
        SpotifyRequest.shared.getTrackInfo(accessToken: token, id: songId, completion: { result in
            switch result {
            case .success(let song):
                let newDict:NSDictionary = [
                    "Name" : song.spotifyName,
                    "Artist 1" : song.spotifyArtist1,
                    "Artist 1 URL" : song.spotifyArtist1URL,
                    "Artist 2" : song.spotifyArtist2,
                    "Artist 2 URL" : song.spotifyArtist2URL,
                    "Artist 3" : song.spotifyArtist3,
                    "Artist 3 URL" : song.spotifyArtist3URL,
                    "Artist 4" : song.spotifyArtist4,
                    "Artist 4 URL" : song.spotifyArtist4URL,
                    "Artist 5" : song.spotifyArtist5,
                    "Artist 5 URL" : song.spotifyArtist5URL,
                    "Artist 6" : song.spotifyArtist6,
                    "Artist 6 URL" : song.spotifyArtis6URL,
                    "Explicity" : song.spotifyExplicity,
                    "Preview URL" : song.spotifyPreviewURL,
                    "ISRC" : song.spotifyISRC,
                    "Date Released On Spotify" : song.spotifyDateSPT,
                    "Time Uploaded To App" : song.spotifyTimeIA,
                    "Date Uploaded To App" : song.spotifyDateIA,
                    "Duration" : song.spotifyDuration,
                    "Artwork URL" : song.spotifyArtworkURL,
                    "Song URL" : song.spotifySongURL,
                    "Number of Favorites" : song.spotifyFavorites,
                    "Track Number" : song.spotifyTrackNumber,
                    "Album Type" : song.spotifyAlbumType,
                    "Spotify Id" : song.spotifyId,
                    "Active Status": currentStatus
                ]
                
                nref.setValue(newDict, withCompletionBlock: { error, reference in
                    if let error = error {
                        completion(SongEditorError.spotifyUpdateError(error.localizedDescription))
                        return
                    }
                    else {
                        completion(nil)
                        return
                    }
                })
            case .failure(let err):
                completion(SongEditorError.spotifyUpdateError(err.localizedDescription))
            }
        })
        
        
    }
    
    func removeSpotify(ref: DatabaseReference, completion: @escaping ((Error?) -> Void)) {
        ref.child("\(spotifyMusicContentType)--\(currSong.name)--\(currSong.dateRegisteredToApp!)--\(currSong.timeRegisteredToApp!)").removeValue(completionBlock: { error, reference in
            if let error = error {
                completion(SongEditorError.spotifyUpdateError(error.localizedDescription))
                return
            }
            else {
                completion(nil)
                return
            }
        })
    }
    
    //MARK: - Apple Music
    func processAppleMusic(initialSong: SongData, currentSong: SongData, initialStatus:Bool?, currentStatus:Bool?, initialURL:String?, currentURL:String?, completion: @escaping (([Error]?) -> Void)) {
        initSong = initialSong
        currSong = currentSong
        var errors:[Error] = []
        initRef = Database.database().reference().child("Music Content").child("Songs").child("\(songContentTag)--\(initSong.name)--\(initSong.toneDeafAppId)")
        currRef = Database.database().reference().child("Music Content").child("Songs").child("\(songContentTag)--\(currSong.name)--\(currSong.toneDeafAppId)")
        
        var dataUploadCompletionStatus1:Bool!
        var dataUploadCompletionStatus2:Bool!
        let queue = DispatchQueue(label: "myhjvkheditingQsongsAppleMusicssseue")
        let group = DispatchGroup()
        var array:[Int] = []
        
        if currSong.apple == nil {
            array.append(3)
        } else {
            if initialStatus != currentStatus {
                array.append(1)
            }
            if currentURL != initialURL {
                array.append(2)
            }
        }
        for i in array {
            group.enter()
            queue.async { [weak self] in
                guard let strongSelf = self else {return}
                switch i {
                case 1:
                    strongSelf.processAppleMusicStatus(ref: strongSelf.currRef, currentStatus: currentStatus, completion: {err in
                        if let error = err {
                            dataUploadCompletionStatus1 = false
                            errors.append(error)
                        } else {
                            dataUploadCompletionStatus1 = true
                            print("AppleMusic status done \(i)")
                        }
                        group.leave()
                    })
                case 2:
                    strongSelf.processAppleMusicURL(ref: strongSelf.currRef, currentStatus: currentStatus, currentURL: currentURL, completion: {err in
                        if let error = err {
                            dataUploadCompletionStatus2 = false
                            errors.append(error)
                        } else {
                            dataUploadCompletionStatus2 = true
                            print("AppleMusic URL done \(i)")
                        }
                        group.leave()
                    })
                case 3:
                    strongSelf.removeAppleMusic(ref: strongSelf.currRef ,completion: {err in
                        if let error = err {
                            dataUploadCompletionStatus2 = false
                            errors.append(error)
                        } else {
                            dataUploadCompletionStatus2 = true
                            print("AppleMusic URL remove done \(i)")
                        }
                        group.leave()
                    })
                default:
                    print("Edit Song error")
                }
            }
        }
        
        group.notify(queue: DispatchQueue.main) {
            if dataUploadCompletionStatus1 == false || dataUploadCompletionStatus2 == false {
                completion(errors)
                return
            } else {
                completion(nil)
            }
        }
    }
    
    func processAppleMusicStatus(ref: DatabaseReference, currentStatus: Bool?, completion: @escaping ((Error?) -> Void)) {
        ref.child("\(appleMusicContentType)--\(currSong.name)--\(currSong.dateRegisteredToApp!)--\(currSong.timeRegisteredToApp!)").child("Active Status").setValue(currentStatus, withCompletionBlock: { error, reference in
            if let error = error {
                completion(SongEditorError.appleUpdateError(error.localizedDescription))
                return
            }
            else {
                completion(nil)
                return
            }
        })
    }
    
    func processAppleMusicURL(ref: DatabaseReference, currentStatus: Bool?, currentURL: String?, completion: @escaping ((Error?) -> Void)) {
        let nref = ref.child("\(appleMusicContentType)--\(currSong.name)--\(currSong.dateRegisteredToApp!)--\(currSong.timeRegisteredToApp!)")
        let url = currentURL!
        let songId = String((url.suffix(10)))
        AppleMusicRequest.shared.getAppleMusicSong(id: songId, completion: { result in
            switch result {
            case .success(let song):
                let newDict:NSDictionary = [
                    "Name" : song.appleName,
                    "Artist" : song.appleArtist,
                    "Explicity" : song.appleExplicity,
                    "Preview URL" : song.applePreviewURL,
                    "ISRC" : song.appleISRC,
                    "Date Released On Apple" : song.appleDateAPPL,
                    "Time Uploaded To App" : song.appleTimeIA,
                    "Date Uploaded To App" : song.appleDateIA,
                    "Duration" : song.appleDuration,
                    "Artwork URL" : song.appleArtworkURL,
                    "Song URL" : song.appleSongURL,
                    "Album Name" : song.appleAlbumName,
                    "Composers" : song.applecomposers,
                    "Genres" : song.appleGenres,
                    "Number of Favorites" : song.appleFavorites,
                    "Track Number" : song.appleTrackNumber,
                    "Apple Music Id" : song.appleMusicId,
                    "Active Status": currentStatus
                ]
                
                nref.setValue(newDict, withCompletionBlock: { error, reference in
                    if let error = error {
                        completion(SongEditorError.appleUpdateError(error.localizedDescription))
                        return
                    }
                    else {
                        completion(nil)
                        return
                    }
                })
            case .failure(let err):
                completion(SongEditorError.appleUpdateError(err.localizedDescription))
            }
        })
        
        
    }
    
    func removeAppleMusic(ref: DatabaseReference, completion: @escaping ((Error?) -> Void)) {
        ref.child("\(appleMusicContentType)--\(currSong.name)--\(currSong.dateRegisteredToApp!)--\(currSong.timeRegisteredToApp!)").removeValue(completionBlock: { error, reference in
            if let error = error {
                completion(SongEditorError.appleUpdateError(error.localizedDescription))
                return
            }
            else {
                completion(nil)
                return
            }
        })
    }
    
    //MARK: - Soundcloud
    func processSoundcloud(initialSong: SongData, currentSong: SongData, initialStatus:Bool?, currentStatus:Bool?, initialURL:String?, currentURL:String?, completion: @escaping (([Error]?) -> Void)) {
        initSong = initialSong
        currSong = currentSong
        var errors:[Error] = []
        initRef = Database.database().reference().child("Music Content").child("Songs").child("\(songContentTag)--\(initSong.name)--\(initSong.toneDeafAppId)")
        currRef = Database.database().reference().child("Music Content").child("Songs").child("\(songContentTag)--\(currSong.name)--\(currSong.toneDeafAppId)")
        
        var dataUploadCompletionStatus1:Bool!
        var dataUploadCompletionStatus2:Bool!
        let queue = DispatchQueue(label: "myhjvkheditingQsongsSoundcloudssseue")
        let group = DispatchGroup()
        var array:[Int] = []
        if currSong.soundcloud == nil {
            array.append(3)
        } else {
            if initialStatus != currentStatus {
                array.append(1)
            }
            if currentURL != initialURL {
                array.append(2)
            }
        }
        for i in array {
            group.enter()
            queue.async { [weak self] in
                guard let strongSelf = self else {return}
                switch i {
                case 1:
                    strongSelf.processSoundcloudStatus(ref: strongSelf.currRef, currentStatus: currentStatus, completion: {err in
                        if let error = err {
                            dataUploadCompletionStatus1 = false
                            errors.append(error)
                        } else {
                            dataUploadCompletionStatus1 = true
                            print("Soundcloud URL done \(i)")
                        }
                        group.leave()
                    })
                case 2:
                    strongSelf.processSoundcloudURL(ref: strongSelf.currRef, currentStatus: currentStatus, currentURL: currentURL, completion: {err in
                        if let error = err {
                            dataUploadCompletionStatus2 = false
                            errors.append(error)
                        } else {
                            dataUploadCompletionStatus2 = true
                            print("Soundcloud URL done \(i)")
                        }
                        group.leave()
                    })
                case 3:
                    strongSelf.removeSoundcloud(ref: strongSelf.currRef ,completion: {err in
                        if let error = err {
                            dataUploadCompletionStatus2 = false
                            errors.append(error)
                        } else {
                            dataUploadCompletionStatus2 = true
                            print("Soundcloud URL done \(i)")
                        }
                        group.leave()
                    })
                default:
                    print("Edit Song error")
                }
            }
        }
        
        group.notify(queue: DispatchQueue.main) {
            if dataUploadCompletionStatus1 == false || dataUploadCompletionStatus2 == false {
                completion(errors)
                return
            } else {
                completion(nil)
            }
        }
    }
    
    func processSoundcloudStatus(ref: DatabaseReference, currentStatus: Bool?, completion: @escaping ((Error?) -> Void)) {
        ref.child("\(soundcloudMusicContentType)--\(currSong.name)--\(currSong.dateRegisteredToApp!)--\(currSong.timeRegisteredToApp!)").child("Active Status").setValue(currentStatus, withCompletionBlock: { error, reference in
            if let error = error {
                completion(SongEditorError.soundcloudUpdateError(error.localizedDescription))
                return
            }
            else {
                completion(nil)
                return
            }
        })
    }
    
    func processSoundcloudURL(ref: DatabaseReference, currentStatus: Bool?, currentURL: String?, completion: @escaping ((Error?) -> Void)) {
                let newDict:NSDictionary = [
                    "url": currentURL!,
                    "Active Status": currentStatus!
                ]
                
                ref.child("\(soundcloudMusicContentType)--\(currSong.name)--\(currSong.dateRegisteredToApp!)--\(currSong.timeRegisteredToApp!)").setValue(newDict, withCompletionBlock: { error, reference in
                    if let error = error {
                        completion(SongEditorError.soundcloudUpdateError(error.localizedDescription))
                        return
                    }
                    else {
                        completion(nil)
                        return
                    }
                })
        
        
    }
    
    func removeSoundcloud(ref: DatabaseReference, completion: @escaping ((Error?) -> Void)) {
        ref.child("\(soundcloudMusicContentType)--\(currSong.name)--\(currSong.dateRegisteredToApp!)--\(currSong.timeRegisteredToApp!)").removeValue(completionBlock: { error, reference in
            if let error = error {
                completion(SongEditorError.soundcloudUpdateError(error.localizedDescription))
                return
            }
            else {
                completion(nil)
                return
            }
        })
    }
    
    //MARK: - Youtube Music
    func processYoutubeMusic(initialSong: SongData, currentSong: SongData, initialStatus:Bool?, currentStatus:Bool?, initialURL:String?, currentURL:String?, completion: @escaping (([Error]?) -> Void)) {
        initSong = initialSong
        currSong = currentSong
        var errors:[Error] = []
        initRef = Database.database().reference().child("Music Content").child("Songs").child("\(songContentTag)--\(initSong.name)--\(initSong.toneDeafAppId)")
        currRef = Database.database().reference().child("Music Content").child("Songs").child("\(songContentTag)--\(currSong.name)--\(currSong.toneDeafAppId)")
        
        var dataUploadCompletionStatus1:Bool!
        var dataUploadCompletionStatus2:Bool!
        let queue = DispatchQueue(label: "myhjvkheditingQsongsYoutubeMusicssseue")
        let group = DispatchGroup()
        var array:[Int] = []
        if currSong.youtubeMusic == nil {
            array.append(3)
        } else {
            if initialStatus != currentStatus {
                array.append(1)
            }
            if currentURL != initialURL {
                array.append(2)
            }
        }
        for i in array {
            group.enter()
            queue.async { [weak self] in
                guard let strongSelf = self else {return}
                switch i {
                case 1:
                    strongSelf.processYoutubeMusicStatus(ref: strongSelf.currRef, currentStatus: currentStatus, completion: {err in
                        if let error = err {
                            dataUploadCompletionStatus1 = false
                            errors.append(error)
                        } else {
                            dataUploadCompletionStatus1 = true
                            print("Youtube Music URL done \(i)")
                        }
                        group.leave()
                    })
                case 2:
                    strongSelf.processYoutubeMusicURL(ref: strongSelf.currRef, currentStatus: currentStatus, currentURL: currentURL, completion: {err in
                        if let error = err {
                            dataUploadCompletionStatus2 = false
                            errors.append(error)
                        } else {
                            dataUploadCompletionStatus2 = true
                            print("Youtube Music URL done \(i)")
                        }
                        group.leave()
                    })
                case 3:
                    strongSelf.removeYoutubeMusic(ref: strongSelf.currRef,completion: {err in
                        if let error = err {
                            dataUploadCompletionStatus2 = false
                            errors.append(error)
                        } else {
                            dataUploadCompletionStatus2 = true
                            print("Youtube Music URL done \(i)")
                        }
                        group.leave()
                    })
                default:
                    print("Edit Song error")
                }
            }
        }
        
        group.notify(queue: DispatchQueue.main) {
            if dataUploadCompletionStatus1 == false || dataUploadCompletionStatus2 == false {
                completion(errors)
                return
            } else {
                completion(nil)
            }
        }
    }
    
    func processYoutubeMusicStatus(ref: DatabaseReference, currentStatus: Bool?, completion: @escaping ((Error?) -> Void)) {
        ref.child("\(youtubeMusicContentType)--\(currSong.name)--\(currSong.dateRegisteredToApp!)--\(currSong.timeRegisteredToApp!)").child("Active Status").setValue(currentStatus, withCompletionBlock: { error, reference in
            if let error = error {
                completion(SongEditorError.youtubeMusicUpdateError(error.localizedDescription))
                return
            }
            else {
                completion(nil)
                return
            }
        })
    }
    
    func processYoutubeMusicURL(ref: DatabaseReference, currentStatus: Bool?, currentURL: String?, completion: @escaping ((Error?) -> Void)) {
                let newDict:NSDictionary = [
                    "url": currentURL!,
                    "Active Status": currentStatus!
                ]
                
                ref.child("\(youtubeMusicContentType)--\(currSong.name)--\(currSong.dateRegisteredToApp!)--\(currSong.timeRegisteredToApp!)").setValue(newDict, withCompletionBlock: { error, reference in
                    if let error = error {
                        completion(SongEditorError.youtubeMusicUpdateError(error.localizedDescription))
                        return
                    }
                    else {
                        completion(nil)
                        return
                    }
                })
        
        
    }
    
    func removeYoutubeMusic(ref: DatabaseReference, completion: @escaping ((Error?) -> Void)) {
        ref.child("\(youtubeMusicContentType)--\(currSong.name)--\(currSong.dateRegisteredToApp!)--\(currSong.timeRegisteredToApp!)").removeValue(completionBlock: { error, reference in
            if let error = error {
                completion(SongEditorError.youtubeMusicUpdateError(error.localizedDescription))
                return
            }
            else {
                completion(nil)
                return
            }
        })
    }
    
    //MARK: - Amazon
    func processAmazon(initialSong: SongData, currentSong: SongData, initialStatus:Bool?, currentStatus:Bool?, initialURL:String?, currentURL:String?, completion: @escaping (([Error]?) -> Void)) {
        initSong = initialSong
        currSong = currentSong
        var errors:[Error] = []
        initRef = Database.database().reference().child("Music Content").child("Songs").child("\(songContentTag)--\(initSong.name)--\(initSong.toneDeafAppId)")
        currRef = Database.database().reference().child("Music Content").child("Songs").child("\(songContentTag)--\(currSong.name)--\(currSong.toneDeafAppId)")
        
        var dataUploadCompletionStatus1:Bool!
        var dataUploadCompletionStatus2:Bool!
        let queue = DispatchQueue(label: "myhjvkheditingQsongsAmazonssseue")
        let group = DispatchGroup()
        var array:[Int] = []
        if currSong.amazon == nil {
            array.append(3)
        } else {
            if initialStatus != currentStatus {
                array.append(1)
            }
            if currentURL != initialURL {
                array.append(2)
            }
        }
        for i in array {
            group.enter()
            queue.async { [weak self] in
                guard let strongSelf = self else {return}
                switch i {
                case 1:
                    strongSelf.processAmazonStatus(ref: strongSelf.currRef, currentStatus: currentStatus, completion: {err in
                        if let error = err {
                            dataUploadCompletionStatus1 = false
                            errors.append(error)
                        } else {
                            dataUploadCompletionStatus1 = true
                            print("Amazon URL done \(i)")
                        }
                        group.leave()
                    })
                case 2:
                    strongSelf.processAmazonURL(ref: strongSelf.currRef, currentStatus: currentStatus, currentURL: currentURL, completion: {err in
                        if let error = err {
                            dataUploadCompletionStatus2 = false
                            errors.append(error)
                        } else {
                            dataUploadCompletionStatus2 = true
                            print("Amazon URL done \(i)")
                        }
                        group.leave()
                    })
                case 3:
                    strongSelf.removeAmazon(ref: strongSelf.currRef,completion: {err in
                        if let error = err {
                            dataUploadCompletionStatus2 = false
                            errors.append(error)
                        } else {
                            dataUploadCompletionStatus2 = true
                            print("Amazon URL done \(i)")
                        }
                        group.leave()
                    })
                default:
                    print("Edit Song error")
                }
            }
        }
        
        group.notify(queue: DispatchQueue.main) {
            if dataUploadCompletionStatus1 == false || dataUploadCompletionStatus2 == false {
                completion(errors)
                return
            } else {
                completion(nil)
            }
        }
    }
    
    func processAmazonStatus(ref: DatabaseReference, currentStatus: Bool?, completion: @escaping ((Error?) -> Void)) {
        ref.child("\(amazonMusicContentType)--\(currSong.name)--\(currSong.dateRegisteredToApp!)--\(currSong.timeRegisteredToApp!)").child("Active Status").setValue(currentStatus, withCompletionBlock: { error, reference in
            if let error = error {
                completion(SongEditorError.amazonUpdateError(error.localizedDescription))
                return
            }
            else {
                completion(nil)
                return
            }
        })
    }
    
    func processAmazonURL(ref: DatabaseReference, currentStatus: Bool?, currentURL: String?, completion: @escaping ((Error?) -> Void)) {
                let newDict:NSDictionary = [
                    "url": currentURL!,
                    "Active Status": currentStatus!
                ]
                
                ref.child("\(amazonMusicContentType)--\(currSong.name)--\(currSong.dateRegisteredToApp!)--\(currSong.timeRegisteredToApp!)").setValue(newDict, withCompletionBlock: { error, reference in
                    if let error = error {
                        completion(SongEditorError.amazonUpdateError(error.localizedDescription))
                        return
                    }
                    else {
                        completion(nil)
                        return
                    }
                })
        
        
    }
    
    func removeAmazon(ref: DatabaseReference, completion: @escaping ((Error?) -> Void)) {
        ref.child("\(amazonMusicContentType)--\(currSong.name)--\(currSong.dateRegisteredToApp!)--\(currSong.timeRegisteredToApp!)").removeValue(completionBlock: { error, reference in
            if let error = error {
                completion(SongEditorError.amazonUpdateError(error.localizedDescription))
                return
            }
            else {
                completion(nil)
                return
            }
        })
    }
    
    //MARK: - Deezer
    func processDeezer(initialSong: SongData, currentSong: SongData, initialStatus:Bool?, currentStatus:Bool?, initialURL:String?, currentURL:String?, completion: @escaping (([Error]?) -> Void)) {
        initSong = initialSong
        currSong = currentSong
        var errors:[Error] = []
        initRef = Database.database().reference().child("Music Content").child("Songs").child("\(songContentTag)--\(initSong.name)--\(initSong.toneDeafAppId)")
        currRef = Database.database().reference().child("Music Content").child("Songs").child("\(songContentTag)--\(currSong.name)--\(currSong.toneDeafAppId)")
        
        var dataUploadCompletionStatus1:Bool!
        var dataUploadCompletionStatus2:Bool!
        let queue = DispatchQueue(label: "myhjvkheditingQsongsDeezerssseue")
        let group = DispatchGroup()
        var array:[Int] = []
        if currSong.deezer == nil {
            array.append(3)
        } else {
            if initialStatus != currentStatus {
                array.append(1)
            }
            if currentURL != initialURL {
                array.append(2)
            }
        }
        for i in array {
            group.enter()
            queue.async { [weak self] in
                guard let strongSelf = self else {return}
                switch i {
                case 1:
                    strongSelf.processDeezerStatus(ref: strongSelf.currRef, currentStatus: currentStatus, completion: {err in
                        if let error = err {
                            dataUploadCompletionStatus1 = false
                            errors.append(error)
                        } else {
                            dataUploadCompletionStatus1 = true
                            print("Deezer URL done \(i)")
                        }
                        group.leave()
                    })
                case 2:
                    strongSelf.processDeezerURL(ref: strongSelf.currRef, currentStatus: currentStatus, currentURL: currentURL, completion: {err in
                        if let error = err {
                            dataUploadCompletionStatus2 = false
                            errors.append(error)
                        } else {
                            dataUploadCompletionStatus2 = true
                            print("Deezer URL done \(i)")
                        }
                        group.leave()
                    })
                case 3:
                    strongSelf.removeDeezer(ref: strongSelf.currRef,completion: {err in
                        if let error = err {
                            dataUploadCompletionStatus2 = false
                            errors.append(error)
                        } else {
                            dataUploadCompletionStatus2 = true
                            print("Deezer URL done \(i)")
                        }
                        group.leave()
                    })
                default:
                    print("Edit Song error")
                }
            }
        }
        
        group.notify(queue: DispatchQueue.main) {
            if dataUploadCompletionStatus1 == false || dataUploadCompletionStatus2 == false {
                completion(errors)
                return
            } else {
                completion(nil)
            }
        }
    }
    
    func processDeezerStatus(ref: DatabaseReference, currentStatus: Bool?, completion: @escaping ((Error?) -> Void)) {
        ref.child("\(deezerMusicContentType)--\(currSong.name)--\(currSong.dateRegisteredToApp!)--\(currSong.timeRegisteredToApp!)").child("Active Status").setValue(currentStatus, withCompletionBlock: { error, reference in
            if let error = error {
                completion(SongEditorError.deezerUpdateError(error.localizedDescription))
                return
            }
            else {
                completion(nil)
                return
            }
        })
    }
    
    func processDeezerURL(ref: DatabaseReference, currentStatus: Bool?, currentURL: String?, completion: @escaping ((Error?) -> Void)) {
        var deezUrl = currentURL!
        if let dotRange = deezUrl.range(of: "?") {
            deezUrl.removeSubrange(dotRange.lowerBound..<deezUrl.endIndex)
        }
        if let range = deezUrl.range(of: "track/") {
            deezUrl.removeSubrange(deezUrl.startIndex..<range.lowerBound)
        }
        
        let albumId = String(deezUrl.dropFirst(6))
        
        DeezerRequest.shared.getDeezerSong(id: albumId, completion: {[weak self] result in
            guard let strongSelf = self else {return}
            switch result {
            case .success(let song):
                let newDict:NSDictionary = [
                    "Name" : song.name,
                    "Artist" : song.artist,
                    "Preview URL" : song.previewURL,
                    "ISRC" : song.isrc,
                    "Date Released On Deezer" : song.deezerDate,
                    "Time Registered To App" : song.timeIA!,
                    "Date Registered To App" : song.dateIA!,
                    "Duration" : song.duration,
                    "Artwork URL" : song.imageurl,
                    "Song URL" : song.url,
                    "Deezer Music Id" : song.deezerID,
                    "Active Status" : currentStatus
                ]
                
                ref.child("\(deezerMusicContentType)--\(strongSelf.currSong.name)--\(strongSelf.currSong.dateRegisteredToApp!)--\(strongSelf.currSong.timeRegisteredToApp!)").setValue(newDict, withCompletionBlock: { error, reference in
                    if let error = error {
                        completion(SongEditorError.deezerUpdateError(error.localizedDescription))
                        return
                    }
                    else {
                        completion(nil)
                        return
                    }
                })
            case .failure(let err):
                completion(SongEditorError.deezerUpdateError(err.localizedDescription))
            }
        })
        
    }
    
    func removeDeezer(ref: DatabaseReference, completion: @escaping ((Error?) -> Void)) {
        ref.child("\(deezerMusicContentType)--\(currSong.name)--\(currSong.dateRegisteredToApp!)--\(currSong.timeRegisteredToApp!)").removeValue(completionBlock: { error, reference in
            if let error = error {
                completion(SongEditorError.deezerUpdateError(error.localizedDescription))
                return
            }
            else {
                completion(nil)
                return
            }
        })
    }
    
    //MARK: - Tidal
    func processTidal(initialSong: SongData, currentSong: SongData, initialStatus:Bool?, currentStatus:Bool?, initialURL:String?, currentURL:String?, completion: @escaping (([Error]?) -> Void)) {
        initSong = initialSong
        currSong = currentSong
        var errors:[Error] = []
        initRef = Database.database().reference().child("Music Content").child("Songs").child("\(songContentTag)--\(initSong.name)--\(initSong.toneDeafAppId)")
        currRef = Database.database().reference().child("Music Content").child("Songs").child("\(songContentTag)--\(currSong.name)--\(currSong.toneDeafAppId)")
        
        var dataUploadCompletionStatus1:Bool!
        var dataUploadCompletionStatus2:Bool!
        let queue = DispatchQueue(label: "myhjvkheditingQsongsTidalssseue")
        let group = DispatchGroup()
        var array:[Int] = []
        if currSong.tidal == nil {
            array.append(3)
        } else {
            if initialStatus != currentStatus {
                array.append(1)
            }
            if currentURL != initialURL {
                array.append(2)
            }
        }
        for i in array {
            group.enter()
            queue.async { [weak self] in
                guard let strongSelf = self else {return}
                switch i {
                case 1:
                    strongSelf.processTidalStatus(ref: strongSelf.currRef, currentStatus: currentStatus, completion: {err in
                        if let error = err {
                            dataUploadCompletionStatus1 = false
                            errors.append(error)
                        } else {
                            dataUploadCompletionStatus1 = true
                            print("Tidal URL done \(i)")
                        }
                        group.leave()
                    })
                case 2:
                    strongSelf.processTidalURL(ref: strongSelf.currRef, currentStatus: currentStatus, currentURL: currentURL, completion: {err in
                        if let error = err {
                            dataUploadCompletionStatus2 = false
                            errors.append(error)
                        } else {
                            dataUploadCompletionStatus2 = true
                            print("Tidal URL done \(i)")
                        }
                        group.leave()
                    })
                case 3:
                    strongSelf.removeTidal(ref: strongSelf.currRef ,completion: {err in
                        if let error = err {
                            dataUploadCompletionStatus2 = false
                            errors.append(error)
                        } else {
                            dataUploadCompletionStatus2 = true
                            print("Tidal URL done \(i)")
                        }
                        group.leave()
                    })
                default:
                    print("Edit Song error")
                }
            }
        }
        
        group.notify(queue: DispatchQueue.main) {
            if dataUploadCompletionStatus1 == false || dataUploadCompletionStatus2 == false {
                completion(errors)
                return
            } else {
                completion(nil)
            }
        }
    }
    
    func processTidalStatus(ref: DatabaseReference, currentStatus: Bool?, completion: @escaping ((Error?) -> Void)) {
        ref.child("\(tidalMusicContentType)--\(currSong.name)--\(currSong.dateRegisteredToApp!)--\(currSong.timeRegisteredToApp!)").child("Active Status").setValue(currentStatus, withCompletionBlock: { error, reference in
            if let error = error {
                completion(SongEditorError.tidalUpdateError(error.localizedDescription))
                return
            }
            else {
                completion(nil)
                return
            }
        })
    }
    
    func processTidalURL(ref: DatabaseReference, currentStatus: Bool?, currentURL: String?, completion: @escaping ((Error?) -> Void)) {
                let newDict:NSDictionary = [
                    "url": currentURL!,
                    "Active Status": currentStatus!
                ]
                
                ref.child("\(tidalMusicContentType)--\(currSong.name)--\(currSong.dateRegisteredToApp!)--\(currSong.timeRegisteredToApp!)").setValue(newDict, withCompletionBlock: { error, reference in
                    if let error = error {
                        completion(SongEditorError.tidalUpdateError(error.localizedDescription))
                        return
                    }
                    else {
                        completion(nil)
                        return
                    }
                })
        
        
    }
    
    func removeTidal(ref: DatabaseReference, completion: @escaping ((Error?) -> Void)) {
        ref.child("\(tidalMusicContentType)--\(currSong.name)--\(currSong.dateRegisteredToApp!)--\(currSong.timeRegisteredToApp!)").removeValue(completionBlock: { error, reference in
            if let error = error {
                completion(SongEditorError.tidalUpdateError(error.localizedDescription))
                return
            }
            else {
                completion(nil)
                return
            }
        })
    }
    
    //MARK: - Napster
    func processNapster(initialSong: SongData, currentSong: SongData, initialStatus:Bool?, currentStatus:Bool?, initialURL:String?, currentURL:String?, completion: @escaping (([Error]?) -> Void)) {
        initSong = initialSong
        currSong = currentSong
        var errors:[Error] = []
        initRef = Database.database().reference().child("Music Content").child("Songs").child("\(songContentTag)--\(initSong.name)--\(initSong.toneDeafAppId)")
        currRef = Database.database().reference().child("Music Content").child("Songs").child("\(songContentTag)--\(currSong.name)--\(currSong.toneDeafAppId)")
        
        var dataUploadCompletionStatus1:Bool!
        var dataUploadCompletionStatus2:Bool!
        let queue = DispatchQueue(label: "myhjvkheditingQsongsNapsterssseue")
        let group = DispatchGroup()
        var array:[Int] = []
        if currSong.napster == nil {
            array.append(3)
        } else {
            if initialStatus != currentStatus {
                array.append(1)
            }
            if currentURL != initialURL {
                array.append(2)
            }
        }
        for i in array {
            group.enter()
            queue.async { [weak self] in
                guard let strongSelf = self else {return}
                switch i {
                case 1:
                    strongSelf.processNapsterStatus(ref: strongSelf.currRef, currentStatus: currentStatus, completion: {err in
                        if let error = err {
                            dataUploadCompletionStatus1 = false
                            errors.append(error)
                        } else {
                            dataUploadCompletionStatus1 = true
                            print("Napster URL done \(i)")
                        }
                        group.leave()
                    })
                case 2:
                    strongSelf.processNapsterURL(ref: strongSelf.currRef, currentStatus: currentStatus, currentURL: currentURL, completion: {err in
                        if let error = err {
                            dataUploadCompletionStatus2 = false
                            errors.append(error)
                        } else {
                            dataUploadCompletionStatus2 = true
                            print("Napster URL done \(i)")
                        }
                        group.leave()
                    })
                case 3:
                    strongSelf.removeNapster(ref: strongSelf.currRef,completion: {err in
                        if let error = err {
                            dataUploadCompletionStatus2 = false
                            errors.append(error)
                        } else {
                            dataUploadCompletionStatus2 = true
                            print("Napster URL done \(i)")
                        }
                        group.leave()
                    })
                default:
                    print("Edit Song error")
                }
            }
        }
        
        group.notify(queue: DispatchQueue.main) {
            if dataUploadCompletionStatus1 == false || dataUploadCompletionStatus2 == false {
                completion(errors)
                return
            } else {
                completion(nil)
            }
        }
    }
    
    func processNapsterStatus(ref: DatabaseReference, currentStatus: Bool?, completion: @escaping ((Error?) -> Void)) {
        ref.child("\(napsterMusicContentType)--\(currSong.name)--\(currSong.dateRegisteredToApp!)--\(currSong.timeRegisteredToApp!)").child("Active Status").setValue(currentStatus, withCompletionBlock: { error, reference in
            if let error = error {
                completion(SongEditorError.napsterUpdateError(error.localizedDescription))
                return
            }
            else {
                completion(nil)
                return
            }
        })
    }
    
    func processNapsterURL(ref: DatabaseReference, currentStatus: Bool?, currentURL: String?, completion: @escaping ((Error?) -> Void)) {
                let newDict:NSDictionary = [
                    "url": currentURL!,
                    "Active Status": currentStatus!
                ]
                
                ref.child("\(napsterMusicContentType)--\(currSong.name)--\(currSong.dateRegisteredToApp!)--\(currSong.timeRegisteredToApp!)").setValue(newDict, withCompletionBlock: { error, reference in
                    if let error = error {
                        completion(SongEditorError.napsterUpdateError(error.localizedDescription))
                        return
                    }
                    else {
                        completion(nil)
                        return
                    }
                })
        
        
    }
    
    func removeNapster(ref: DatabaseReference, completion: @escaping ((Error?) -> Void)) {
        ref.child("\(napsterMusicContentType)--\(currSong.name)--\(currSong.dateRegisteredToApp!)--\(currSong.timeRegisteredToApp!)").removeValue(completionBlock: { error, reference in
            if let error = error {
                completion(SongEditorError.napsterUpdateError(error.localizedDescription))
                return
            }
            else {
                completion(nil)
                return
            }
        })
    }
    
    //MARK: - Spinrilla
    func processSpinrilla(initialSong: SongData, currentSong: SongData, initialStatus:Bool?, currentStatus:Bool?, initialURL:String?, currentURL:String?, completion: @escaping (([Error]?) -> Void)) {
        initSong = initialSong
        currSong = currentSong
        var errors:[Error] = []
        initRef = Database.database().reference().child("Music Content").child("Songs").child("\(songContentTag)--\(initSong.name)--\(initSong.toneDeafAppId)")
        currRef = Database.database().reference().child("Music Content").child("Songs").child("\(songContentTag)--\(currSong.name)--\(currSong.toneDeafAppId)")
        
        var dataUploadCompletionStatus1:Bool!
        var dataUploadCompletionStatus2:Bool!
        let queue = DispatchQueue(label: "myhjvkheditingQsongsSpinrillassseue")
        let group = DispatchGroup()
        var array:[Int] = []
        if currSong.spinrilla == nil {
            array.append(3)
        } else {
            if initialStatus != currentStatus {
                array.append(1)
            }
            if currentURL != initialURL {
                array.append(2)
            }
        }
        for i in array {
            group.enter()
            queue.async { [weak self] in
                guard let strongSelf = self else {return}
                switch i {
                case 1:
                    strongSelf.processSpinrillaStatus(ref: strongSelf.currRef, currentStatus: currentStatus, completion: {err in
                        if let error = err {
                            dataUploadCompletionStatus1 = false
                            errors.append(error)
                        } else {
                            dataUploadCompletionStatus1 = true
                            print("Spinrilla URL done \(i)")
                        }
                        group.leave()
                    })
                case 2:
                    strongSelf.processSpinrillaURL(ref: strongSelf.currRef, currentStatus: currentStatus, currentURL: currentURL, completion: {err in
                        if let error = err {
                            dataUploadCompletionStatus2 = false
                            errors.append(error)
                        } else {
                            dataUploadCompletionStatus2 = true
                            print("Spinrilla URL done \(i)")
                        }
                        group.leave()
                    })
                case 3:
                    strongSelf.removeSpinrilla(ref: strongSelf.currRef ,completion: {err in
                        if let error = err {
                            dataUploadCompletionStatus2 = false
                            errors.append(error)
                        } else {
                            dataUploadCompletionStatus2 = true
                            print("Spinrilla URL done \(i)")
                        }
                        group.leave()
                    })
                default:
                    print("Edit Song error")
                }
            }
        }
        
        group.notify(queue: DispatchQueue.main) {
            if dataUploadCompletionStatus1 == false || dataUploadCompletionStatus2 == false {
                completion(errors)
                return
            } else {
                completion(nil)
            }
        }
    }
    
    func processSpinrillaStatus(ref: DatabaseReference, currentStatus: Bool?, completion: @escaping ((Error?) -> Void)) {
        ref.child("\(spinrillaMusicContentType)--\(currSong.name)--\(currSong.dateRegisteredToApp!)--\(currSong.timeRegisteredToApp!)").child("Active Status").setValue(currentStatus, withCompletionBlock: { error, reference in
            if let error = error {
                completion(SongEditorError.spinrillaUpdateError(error.localizedDescription))
                return
            }
            else {
                completion(nil)
                return
            }
        })
    }
    
    func processSpinrillaURL(ref: DatabaseReference, currentStatus: Bool?, currentURL: String?, completion: @escaping ((Error?) -> Void)) {
                let newDict:NSDictionary = [
                    "url": currentURL!,
                    "Active Status": currentStatus!
                ]
                
                ref.child("\(spinrillaMusicContentType)--\(currSong.name)--\(currSong.dateRegisteredToApp!)--\(currSong.timeRegisteredToApp!)").setValue(newDict, withCompletionBlock: { error, reference in
                    if let error = error {
                        completion(SongEditorError.spinrillaUpdateError(error.localizedDescription))
                        return
                    }
                    else {
                        completion(nil)
                        return
                    }
                })
        
        
    }
    
    func removeSpinrilla(ref: DatabaseReference, completion: @escaping ((Error?) -> Void)) {
        ref.child("\(spinrillaMusicContentType)--\(currSong.name)--\(currSong.dateRegisteredToApp!)--\(currSong.timeRegisteredToApp!)").removeValue(completionBlock: { error, reference in
            if let error = error {
                completion(SongEditorError.spinrillaUpdateError(error.localizedDescription))
                return
            }
            else {
                completion(nil)
                return
            }
        })
    }
    
    
    //MARK: - Albums
    var removedAlbs:[String] = []
    func processAlbums(initialSong: SongData, currentSong: SongData, initAlbumTrackArr:NSDictionary, albumTrackArr: NSDictionary,completion: @escaping (([Error]?) -> Void)) {
        initSong = initialSong
        currSong = currentSong
        removedAlbs = []
        
        initRef = Database.database().reference().child("Music Content").child("Songs").child("\(songContentTag)--\(initSong.name)--\(initSong.toneDeafAppId)")
        currRef = Database.database().reference().child("Music Content").child("Songs").child("\(songContentTag)--\(currSong.name)--\(currSong.toneDeafAppId)")
        var errors:[Error] = []
        var dataUploadCompletionStatus1:Bool!
        var dataUploadCompletionStatus2:Bool!
        var dataUploadCompletionStatus3:Bool!
        var dataUploadCompletionStatus4:Bool!
        var dataUploadCompletionStatus5:Bool!
        var dataUploadCompletionStatus6:Bool!
        var dataUploadCompletionStatus7:Bool!
        var dataUploadCompletionStatus8:Bool!
        var dataUploadCompletionStatus9:Bool!
        var dataUploadCompletionStatus10:Bool!
        var dataUploadCompletionStatus11:Bool!
        var dataUploadCompletionStatus12:Bool!
        var dataUploadCompletionStatus13:Bool!
        var dataUploadCompletionStatus14:Bool!
        var dataUploadCompletionStatus15:Bool!
        
        let aqueue = DispatchQueue(label: "myhjvkheditingQsongAlbumshfdChangessseue")
        let agroup = DispatchGroup()
        let array:[Int] = [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15]
        for i in array {
            agroup.enter()
            aqueue.async { [weak self] in
                guard let strongSelf = self else {return}
                switch i {
                case 1:
                    strongSelf.updateSongAlbums(ref: strongSelf.currRef, completion: {err in
                        if let error = err {
                            dataUploadCompletionStatus1 = false
                            errors.append(error)
                        } else {
                            dataUploadCompletionStatus1 = true
                            print("Song Albums Update done \(i)")
                        }
                        agroup.leave()
                    })
                    //Update Album Songs
                case 2:
                    strongSelf.updateAlbumSongs(ref: strongSelf.currRef, completion: {err in
                        if let error = err {
                            dataUploadCompletionStatus2 = false
                            errors.append(error)
                        } else {
                            dataUploadCompletionStatus2 = true
                            print("Album Songs Update done \(i)")
                        }
                        agroup.leave()
                    })
                    //Update Album Tracks
                case 3:
                    strongSelf.updateAlbumTracks(ref: strongSelf.currRef, initAlbumTrackArr:initAlbumTrackArr, albumTrackArr: albumTrackArr, completion: {err in
                        if let error = err {
                            dataUploadCompletionStatus3 = false
                            errors.append(error)
                        } else {
                            dataUploadCompletionStatus3 = true
                            print("Album Tracks Update done \(i)")
                        }
                        agroup.leave()
                    })
                case 4:
                    strongSelf.updateAlbumsArtists(ref: strongSelf.currRef, completion: {err in
                        if let error = err {
                            dataUploadCompletionStatus4 = false
                            errors.append(error)
                        } else {
                            dataUploadCompletionStatus4 = true
                            print("Albums Artists Update done \(i)")
                        }
                        agroup.leave()
                    })
                case 5:
                    strongSelf.updateArtistAlbums(ref: strongSelf.currRef, completion: {err in
                        if let error = err {
                            dataUploadCompletionStatus5 = false
                            errors.append(error)
                        } else {
                            dataUploadCompletionStatus5 = true
                            print("Artist Albums Update done \(i)")
                        }
                        agroup.leave()
                    })
                case 6:
                    strongSelf.updateAlbumsProducers(ref: strongSelf.currRef, completion: {err in
                        if let error = err {
                            dataUploadCompletionStatus6 = false
                            errors.append(error)
                        } else {
                            dataUploadCompletionStatus6 = true
                            print("Albums Producers Update done \(i)")
                        }
                        agroup.leave()
                    })
                case 7:
                    strongSelf.updateProducerAlbums(ref: strongSelf.currRef, completion: {err in
                        if let error = err {
                            dataUploadCompletionStatus7 = false
                            errors.append(error)
                        } else {
                            dataUploadCompletionStatus7 = true
                            print("Producer Albums Update done \(i)")
                        }
                        agroup.leave()
                    })
                case 8:
                    strongSelf.updateAlbumsWriters(ref: strongSelf.currRef, completion: {err in
                        if let error = err {
                            dataUploadCompletionStatus8 = false
                            errors.append(error)
                        } else {
                            dataUploadCompletionStatus8 = true
                            print("Albums Writers Update done \(i)")
                        }
                        agroup.leave()
                    })
                case 9:
                    strongSelf.updateWriterAlbums(ref: strongSelf.currRef, completion: {err in
                        if let error = err {
                            dataUploadCompletionStatus9 = false
                            errors.append(error)
                        } else {
                            dataUploadCompletionStatus9 = true
                            print("Writer Albums Update done \(i)")
                        }
                        agroup.leave()
                    })
                case 10:
                    strongSelf.updateAlbumsMixEngineers(ref: strongSelf.currRef, completion: {err in
                        if let error = err {
                            dataUploadCompletionStatus10 = false
                            errors.append(error)
                        } else {
                            dataUploadCompletionStatus10 = true
                            print("Albums Mix Engineers Update done \(i)")
                        }
                        agroup.leave()
                    })
                case 11:
                    strongSelf.updateMixEngineerAlbums(ref: strongSelf.currRef, completion: {err in
                        if let error = err {
                            dataUploadCompletionStatus11 = false
                            errors.append(error)
                        } else {
                            dataUploadCompletionStatus11 = true
                            print("Mix Engineer Albums Update done \(i)")
                        }
                        agroup.leave()
                    })
                case 12:
                    strongSelf.updateAlbumsMasteringEngineers(ref: strongSelf.currRef, completion: {err in
                        if let error = err {
                            dataUploadCompletionStatus12 = false
                            errors.append(error)
                        } else {
                            dataUploadCompletionStatus12 = true
                            print("Albums Mix Engineers Update done \(i)")
                        }
                        agroup.leave()
                    })
                case 13:
                    strongSelf.updateMasteringEngineerAlbums(ref: strongSelf.currRef, completion: {err in
                        if let error = err {
                            dataUploadCompletionStatus13 = false
                            errors.append(error)
                        } else {
                            dataUploadCompletionStatus13 = true
                            print("Mastering Engineer Albums Update done \(i)")
                        }
                        agroup.leave()
                    })
                case 14:
                    strongSelf.updateAlbumsRecordingEngineers(ref: strongSelf.currRef, completion: {err in
                        if let error = err {
                            dataUploadCompletionStatus14 = false
                            errors.append(error)
                        } else {
                            dataUploadCompletionStatus14 = true
                            print("Albums Recording Engineers Update done \(i)")
                        }
                        agroup.leave()
                    })
                case 15:
                    strongSelf.updateRecordingEngineerAlbums(ref: strongSelf.currRef, completion: {err in
                        if let error = err {
                            dataUploadCompletionStatus15 = false
                            errors.append(error)
                        } else {
                            dataUploadCompletionStatus15 = true
                            print("Recording Engineer Albums Update done \(i)")
                        }
                        agroup.leave()
                    })
                    //update producers
                    //update writers
                    //update engineers
                default:
                    break
                }
            }
        }
        agroup.notify(queue: DispatchQueue.main) {
            if dataUploadCompletionStatus1 == false || dataUploadCompletionStatus2 == false || dataUploadCompletionStatus3 == false || dataUploadCompletionStatus4 == false || dataUploadCompletionStatus5 == false || dataUploadCompletionStatus6 == false || dataUploadCompletionStatus7 == false || dataUploadCompletionStatus8 == false || dataUploadCompletionStatus9 == false || dataUploadCompletionStatus10 == false || dataUploadCompletionStatus11 == false || dataUploadCompletionStatus12 == false || dataUploadCompletionStatus13 == false || dataUploadCompletionStatus14 == false || dataUploadCompletionStatus15 == false {
                completion(errors)
                return
            } else {
                completion(nil)
            }
        }
    }
    
    func updateSongAlbums(ref: DatabaseReference, completion: @escaping ((Error?) -> Void)) {
        
        var initialSongArrFromDB:[String]!
        if currSong.albums == initSong.albums {
            completion(nil)
            return
        }
        getSongAlbumsInDB(ref: ref, completion: {[weak self] albums in
            guard let strongSelf = self else {return}
            initialSongArrFromDB = albums
            
            if !initialSongArrFromDB.isEmpty {
                var removalCounter = 0
                for i in 0 ... initialSongArrFromDB.count-1 {
                    if strongSelf.currSong.albums != nil {
                        if i < strongSelf.currSong.albums!.count {
                            if !strongSelf.currSong.albums![i].contains(initialSongArrFromDB[i]) {
                                let index = initialSongArrFromDB.firstIndex(of: initialSongArrFromDB[i])
                                initialSongArrFromDB.remove(at: index!)
                                removalCounter+=1
                            }
                        } else {
                            let index = initialSongArrFromDB.firstIndex(of: initialSongArrFromDB[i-removalCounter])
                            initialSongArrFromDB.remove(at: index!)
                            removalCounter+=1
                        }
                    } else {
                        let index = initialSongArrFromDB.firstIndex(of: initialSongArrFromDB[i-removalCounter])
                        initialSongArrFromDB.remove(at: index!)
                        removalCounter+=1
                    }
                }
            }
            
            if strongSelf.currSong.albums != nil {
                if !strongSelf.currSong.albums!.isEmpty {
                    for i in 0 ... strongSelf.currSong.albums!.count-1 {
                        if i < initialSongArrFromDB.count {
                            if !initialSongArrFromDB[i].contains(strongSelf.currSong.albums![i]) {
                                initialSongArrFromDB.append(strongSelf.currSong.albums![i])
                            }
                        } else {
                            initialSongArrFromDB.append(strongSelf.currSong.albums![i])
                        }
                    }
                }
            }
            ref.child("REQUIRED").child("Albums").setValue(initialSongArrFromDB.sorted(), withCompletionBlock: { error, reference in
                if let error = error {
                    completion(error)
                    return
                }
                else {
                    completion(nil)
                    return
                }
            })
            
        })
    }
    
    func getSongAlbumsInDB(ref: DatabaseReference, completion: @escaping (([String]) -> Void)) {
        ref.child("REQUIRED").child("Albums").observeSingleEvent(of: .value, with: { snapshot in
            var mysongsArray:[String] = []
            if let val = snapshot.value {
                let valu = val as? [String]
                guard let value = valu else {
                    completion(mysongsArray)
                    return}
                if value[0] != "" {
                    mysongsArray = value
                }
                completion(mysongsArray)
            } else {
                completion(mysongsArray)
            }
        })
    }
    
    func updateAlbumSongs(ref: DatabaseReference, completion: @escaping ((Error?) -> Void)) {
        var initialArtistsArrFromDB:[String]!
        var totalProgress:Int = 0
        var completedProgress:Int = 0
        if currSong.albums!.sorted() == initSong.albums?.sorted() {
            completion(nil)
            return
        }
        
        getSongAlbumsInDB(ref: ref, completion: {[weak self] persons in
            guard let strongSelf = self else {return}
            initialArtistsArrFromDB = persons.sorted()
            
            if !initialArtistsArrFromDB.isEmpty {
                for i in 0 ... initialArtistsArrFromDB.count-1 {
                    if strongSelf.currSong.albums != nil {
                        if i < strongSelf.currSong.albums!.count {
                            if !strongSelf.currSong.albums![i].contains(initialArtistsArrFromDB[i]) {
                                totalProgress+=1
                            }
                        } else {
                            totalProgress+=1
                        }
                    } else {
                        totalProgress+=1
                    }
                }
            }
            
            if strongSelf.currSong.albums != nil {
                if !strongSelf.currSong.albums!.isEmpty {
                    for i in 0 ... strongSelf.currSong.albums!.count-1 {
                        if i < initialArtistsArrFromDB.count {
                            if !initialArtistsArrFromDB[i].contains(strongSelf.currSong.albums![i]) {
                                totalProgress+=1
                            }
                        } else {
                            totalProgress+=1
                        }
                    }
                }
            }
            
            if !initialArtistsArrFromDB.isEmpty {
                for i in 0 ... initialArtistsArrFromDB.count-1 {
                    if strongSelf.currSong.albums != nil {
                        if i < strongSelf.currSong.albums!.count {
                            if !strongSelf.currSong.albums![i].contains(initialArtistsArrFromDB[i]) {
                                strongSelf.removeSongFromAlbum(alb: initialArtistsArrFromDB[i], completion: { error in
                                    completedProgress+=1
                                    if let error = error {
                                        completion(error)
                                        return
                                    } else {
                                        if completedProgress == totalProgress {
                                            completion(nil)
                                            return
                                        }
                                    }
                                })
                            }
                        } else {
                            strongSelf.removeSongFromAlbum(alb: initialArtistsArrFromDB[i], completion: { error in
                                completedProgress+=1
                                if let error = error {
                                    completion(error)
                                    return
                                } else {
                                    if completedProgress == totalProgress {
                                        completion(nil)
                                        return
                                    }
                                }
                            })
                        }
                    } else {
                        strongSelf.removeSongFromAlbum(alb: initialArtistsArrFromDB[i], completion: { error in
                            completedProgress+=1
                            if let error = error {
                                completion(error)
                                return
                            } else {
                                if completedProgress == totalProgress {
                                    completion(nil)
                                    return
                                }
                            }
                        })
                    }
                }
            }
            
            if strongSelf.currSong.albums != nil {
                if !strongSelf.currSong.albums!.isEmpty {
                    for i in 0 ... strongSelf.currSong.albums!.count-1 {
                        if i < initialArtistsArrFromDB.count {
                            if !initialArtistsArrFromDB[i].contains(strongSelf.currSong.albums![i]) {
                                strongSelf.addSongToAlbum(alb: strongSelf.currSong.albums![i], completion: { error in
                                    completedProgress+=1
                                    if let error = error {
                                        completion(error)
                                        return
                                    } else {
                                        if completedProgress == totalProgress {
                                            completion(nil)
                                            return
                                        }
                                    }
                                })
                            }
                        } else {
                            strongSelf.addSongToAlbum(alb: strongSelf.currSong.albums![i], completion: { error in
                                completedProgress+=1
                                if let error = error {
                                    completion(error)
                                    return
                                } else {
                                    if completedProgress == totalProgress {
                                        completion(nil)
                                        return
                                    }
                                }
                            })
                        }
                    }
                }
            }
            
        })
    }
    
    func removeSongFromAlbum(alb: String, completion: @escaping ((Error?) -> Void)) {
        guard alb.count == 8 else {
            completion(nil)
            return
        }
        DatabaseManager.shared.findAlbumById(albumId: alb, completion: {[weak self] result in
            guard let strongSelf = self else {return}
            switch result {
            case .success(let album):
                let ref = Database.database().reference().child("Music Content").child("Albums").child( "\(albumContentTag)--\(album.name)--\(album.toneDeafAppId)").child("REQUIRED").child("Songs")
                let song = "\(strongSelf.currSong.toneDeafAppId)"
                var arrto:[String] = []
                if var arrrr = album.songs as? [String] {
                    if arrrr.contains(song) {
                        let index = arrrr.firstIndex(of: song)
                        arrrr.remove(at: index!)
                        album.songs = arrrr.sorted()
                        arrto = arrrr.sorted()
                    }
                }
                
                ref.setValue(arrto, withCompletionBlock: { error, reference in
                    if let error = error {
                        completion(error)
                        return
                    }
                    else {
                        completion(nil)
                        return
                    }
                })
            case .failure(let err):
                print("dsvgredfxbdfzx"+err.localizedDescription)
            }
        })
    }
    
    func addSongToAlbum(alb: String, completion: @escaping ((Error?) -> Void)) {
        guard alb.count == 8 else {
            completion(nil)
            return
        }
        
        DatabaseManager.shared.findAlbumById(albumId: alb, completion: {[weak self] result in
            guard let strongSelf = self else {return}
            switch result {
            case .success(let album):
                let ref = Database.database().reference().child("Music Content").child("Albums").child( "\(albumContentTag)--\(album.name)--\(album.toneDeafAppId)").child("REQUIRED").child("Songs")
                let song = "\(strongSelf.currSong.toneDeafAppId)"
                var arrto:[String] = []
                if var allArt = album.songs {
                    if !allArt.contains(song) {
                        allArt.append(song)
                        arrto = allArt.sorted()
                    }
                } else {
                    arrto = [song]
                }
                ref.setValue(arrto, withCompletionBlock: { error, reference in
                    if let error = error {
                        completion(error)
                        return
                    }
                    else {
                        completion(nil)
                        return
                    }
                })
            case .failure(let err):
                print("dsvgredfxbdfzx"+err.localizedDescription)
            }
        })
    }
    
    func updateAlbumTracks(ref: DatabaseReference, initAlbumTrackArr:NSDictionary, albumTrackArr: NSDictionary, completion: @escaping ((Error?) -> Void)) {
        var initialArtistsArrFromDB:[String]!
        var totalProgress:Int = 0
        var completedProgress:Int = 0
//        if currSong.albums!.sorted() == initSong.albums?.sorted() {
//            completion(nil)
//            return
//        }
        if initAlbumTrackArr == albumTrackArr {
            completion(nil)
            return
        }
        
        getSongAlbumsInDB(ref: ref, completion: {[weak self] persons in
            guard let strongSelf = self else {return}
            initialArtistsArrFromDB = persons.sorted()
            
            for (key, _) in initAlbumTrackArr {
                if albumTrackArr[key] == nil {
                    totalProgress+=1
                } else {
                    totalProgress+=1
                }
            }
            
            for (key, _) in albumTrackArr {
                totalProgress+=1
            }
            
            if totalProgress == 0 {
                completion(nil)
                return
            }
            
            for (key, _) in initAlbumTrackArr {
                if albumTrackArr[key] == nil {
                    strongSelf.removeSongFromAlbumTracks(alb: key as! String, initAlbumTrackArr:initAlbumTrackArr, albumTrackArr: albumTrackArr, completion: { error in
                        completedProgress+=1
                        if let error = error {
                            completion(error)
                            return
                        } else {
                            if completedProgress == totalProgress {
                                completion(nil)
                                return
                            }
                        }
                    })
                } else {
                    strongSelf.addSongToAlbumTracks(alb: key as! String, initAlbumTrackArr:initAlbumTrackArr, albumTrackArr: albumTrackArr, completion: { error in
                        completedProgress+=1
                        if let error = error {
                            completion(error)
                            return
                        } else {
                            if completedProgress == totalProgress {
                                completion(nil)
                                return
                            }
                        }
                    })
                }
            }
            
            for (key, _) in albumTrackArr {
                strongSelf.addSongToAlbumTracks(alb: key as! String, initAlbumTrackArr:initAlbumTrackArr, albumTrackArr: albumTrackArr, completion: { error in
                    completedProgress+=1
                    if let error = error {
                        completion(error)
                        return
                    } else {
                        if completedProgress == totalProgress {
                            completion(nil)
                            return
                        }
                    }
                })
            }
            
        })
    }
    
    func removeSongFromAlbumTracks(alb: String, initAlbumTrackArr:NSDictionary, albumTrackArr: NSDictionary, completion: @escaping ((Error?) -> Void)) {
        guard alb.count == 8 else {
            completion(nil)
            return
        }
        DatabaseManager.shared.findAlbumById(albumId: alb, completion: {[weak self] result in
            guard let strongSelf = self else {return}
            switch result {
            case .success(let album):
                let ref = Database.database().reference().child("Music Content").child("Albums").child( "\(albumContentTag)--\(album.name)--\(album.toneDeafAppId)").child("REQUIRED").child("Tracks")
                var arrto:[String:String] = album.tracks
                 arrto.removeValue(forKey: "Track \(initAlbumTrackArr[album.toneDeafAppId]!)")
                ref.setValue(arrto, withCompletionBlock: { error, reference in
                    if let error = error {
                        completion(error)
                        return
                    }
                    else {
                        completion(nil)
                        return
                    }
                })
            case .failure(let err):
                print("dsvgredfxbdfzx"+err.localizedDescription)
            }
        })
    }
    
    func addSongToAlbumTracks(alb: String, initAlbumTrackArr:NSDictionary, albumTrackArr: NSDictionary, completion: @escaping ((Error?) -> Void)) {
        guard alb.count == 8 else {
            completion(nil)
            return
        }
        
        DatabaseManager.shared.findAlbumById(albumId: alb, completion: {[weak self] result in
            guard let strongSelf = self else {return}
            switch result {
            case .success(let album):
                let ref = Database.database().reference().child("Music Content").child("Albums").child( "\(albumContentTag)--\(album.name)--\(album.toneDeafAppId)").child("REQUIRED").child("Tracks")
                var arrto:[String:String] = album.tracks
                arrto["Track \(albumTrackArr[album.toneDeafAppId]!)"] = strongSelf.currSong.toneDeafAppId
                ref.setValue(arrto, withCompletionBlock: { error, reference in
                    if let error = error {
                        completion(error)
                        return
                    }
                    else {
                        completion(nil)
                        return
                    }
                })
            case .failure(let err):
                print("dsvgredfxbdfzx"+err.localizedDescription)
            }
        })
    }
    
    func removeAlbumFromPersonRole(alb: String,per: String, cat:String) {
        DatabaseManager.shared.fetchPersonData(person: per, completion: {[weak self] result in
            guard let strongSelf = self else {return}
            switch result {
            case .success(let person):
                var ref2:DatabaseReference!
                switch cat {
                case "Artist", "Producer", "Writer":
                    ref2 = Database.database().reference().child("Registered Persons").child("\(person.name!)--\(person.dateRegisteredToApp!)--\(person.timeRegisteredToApp!)--\(person.toneDeafAppId)").child("Roles").child(cat)
                default:
                    ref2 = Database.database().reference().child("Registered Persons").child("\(person.name!)--\(person.dateRegisteredToApp!)--\(person.timeRegisteredToApp!)--\(person.toneDeafAppId)").child("Roles").child("Engineer").child(cat)
                }
                var arrTo2:[String] = []
                if let currole = person.roles {
                    switch cat {
                    case "Artist", "Producer", "Writer":
                        if var arrrry = currole[cat] as? [String] {
                            if let index = arrrry.firstIndex(of: alb) {
                                arrrry.remove(at: index)
                            }
                            
                            for element in strongSelf.removedAlbs {
                                if arrrry.contains(element) {
                                    if let index = arrrry.firstIndex(of: element) {
                                        arrrry.remove(at: index)
                                    }
                                }
                            }
                            arrTo2 = arrrry.sorted()
                            person.roles![cat] = arrTo2
                        }
                    default:
                        if let eng = currole["Engineer"] as? NSDictionary {
                            let engDict = eng.mutableCopy() as! NSMutableDictionary
                            if var arrrry = engDict[cat] as? [String] {
                                if let index = arrrry.firstIndex(of: alb){
                                    arrrry.remove(at: index)
                                }
                                for element in strongSelf.removedAlbs {
                                    if arrrry.contains(element) {
                                        if let index = arrrry.firstIndex(of: element) {
                                            arrrry.remove(at: index)
                                        }
                                    }
                                }
                                arrTo2 = arrrry.sorted()
                                engDict[cat] = arrTo2
                                person.roles!["Engineer"] = engDict
                            }
                        }
                    }
                }
                if !strongSelf.removedAlbs.contains(alb) {
                    strongSelf.removedAlbs.append(alb)
                }
                ref2.setValue(arrTo2.sorted(), withCompletionBlock: { error, reference in
                    if let error = error {
//                        completion(error)
                        return
                    }
                    else {
//                        completion(nil)
                        return
                    }
                })
            case .failure(let err):
                print("dsvgredfxbdfzx"+err.localizedDescription)
            }
        })
    }
    
    func updateAlbumsArtists(ref: DatabaseReference, completion: @escaping ((Error?) -> Void)) {
        var initialArtistsArrFromDB:[String]!
        var totalProgress:Int = 0
        var completedProgress:Int = 0
        if currSong.albums!.sorted() == initSong.albums?.sorted() {
            completion(nil)
            return
        }
        
        getSongAlbumsInDB(ref: ref, completion: {[weak self] persons in
            guard let strongSelf = self else {return}
            initialArtistsArrFromDB = persons.sorted()
            
            if !initialArtistsArrFromDB.isEmpty {
                for i in 0 ... initialArtistsArrFromDB.count-1 {
                    if strongSelf.currSong.albums != nil {
                        if i < strongSelf.currSong.albums!.count {
                            if !strongSelf.currSong.albums![i].contains(initialArtistsArrFromDB[i]) {
                                totalProgress+=1
                            }
                        } else {
                            totalProgress+=1
                        }
                    } else {
                        totalProgress+=1
                    }
                }
            }
            
            if strongSelf.currSong.albums != nil {
                if !strongSelf.currSong.albums!.isEmpty {
                    for i in 0 ... strongSelf.currSong.albums!.count-1 {
                        if i < initialArtistsArrFromDB.count {
                            if !initialArtistsArrFromDB[i].contains(strongSelf.currSong.albums![i]) {
                                totalProgress+=1
                            }
                        } else {
                            totalProgress+=1
                        }
                    }
                }
            }
            
            if totalProgress == 0 {
                completion(nil)
            }
            
            if !initialArtistsArrFromDB.isEmpty {
                for i in 0 ... initialArtistsArrFromDB.count-1 {
                    if strongSelf.currSong.albums != nil {
                        if i < strongSelf.currSong.albums!.count {
                            if !strongSelf.currSong.albums![i].contains(initialArtistsArrFromDB[i]) {
                                strongSelf.removeArtistFromAlbum(alb: initialArtistsArrFromDB[i], completion: { error in
                                    completedProgress+=1
                                    if let error = error {
                                        completion(error)
                                        return
                                    } else {
                                        if completedProgress == totalProgress {
                                            completion(nil)
                                            return
                                        }
                                    }
                                })
                            }
                        } else {
                            strongSelf.removeArtistFromAlbum(alb: initialArtistsArrFromDB[i], completion: { error in
                                completedProgress+=1
                                if let error = error {
                                    completion(error)
                                    return
                                } else {
                                    if completedProgress == totalProgress {
                                        completion(nil)
                                        return
                                    }
                                }
                            })
                        }
                    } else {
                        strongSelf.removeArtistFromAlbum(alb: initialArtistsArrFromDB[i], completion: { error in
                            completedProgress+=1
                            if let error = error {
                                completion(error)
                                return
                            } else {
                                if completedProgress == totalProgress {
                                    completion(nil)
                                    return
                                }
                            }
                        })
                    }
                }
            }
            
            if strongSelf.currSong.albums != nil {
                if !strongSelf.currSong.albums!.isEmpty {
                    for i in 0 ... strongSelf.currSong.albums!.count-1 {
                        if i < initialArtistsArrFromDB.count {
                            if !initialArtistsArrFromDB[i].contains(strongSelf.currSong.albums![i]) {
                                strongSelf.addArtistToAlbum(alb: strongSelf.currSong.albums![i], completion: { error in
                                    completedProgress+=1
                                    if let error = error {
                                        completion(error)
                                        return
                                    } else {
                                        if completedProgress == totalProgress {
                                            completion(nil)
                                            return
                                        }
                                    }
                                })
                            }
                        } else {
                            strongSelf.addArtistToAlbum(alb: strongSelf.currSong.albums![i], completion: { error in
                                completedProgress+=1
                                if let error = error {
                                    completion(error)
                                    return
                                } else {
                                    if completedProgress == totalProgress {
                                        completion(nil)
                                        return
                                    }
                                }
                            })
                        }
                    }
                }
            }
            
        })
    }
    
    func removeArtistFromAlbum(alb: String, completion: @escaping ((Error?) -> Void)) {
        guard alb.count == 8 else {
            completion(nil)
            return
        }
        
        DatabaseManager.shared.findAlbumById(albumId: alb, completion: {[weak self] result in
            guard let strongSelf = self else {return}
            switch result {
            case .success(let album):
                let ref = Database.database().reference().child("Music Content").child("Albums").child( "\(albumContentTag)--\(album.name)--\(album.toneDeafAppId)").child("REQUIRED").child("All Artist")
                var arrto:[String] = []
                var personcount = 0
                for per in strongSelf.currSong.songArtist {
                    var roleMArkedOnAnotherSong:Bool = false
                    var roleMArkedOnAnotherSongAll:Bool = false
                    var subcount = 0
                    if let arr2 = album.songs {
                        for song in arr2 {
                            DatabaseManager.shared.findSongById(songId: song, completion: {[weak self] result in
                                guard let strongSelf = self else {return}
                                switch result {
                                case .success(let song):
                                    subcount+=1
                                    if song.toneDeafAppId != strongSelf.currSong.toneDeafAppId {
                                        if song.songProducers.contains(per) {
                                            roleMArkedOnAnotherSongAll = true
                                        }
                                        if song.songArtist.contains(per) {
                                            roleMArkedOnAnotherSongAll = true
                                            roleMArkedOnAnotherSong = true
                                        }
                                        if let _ = song.songWriters {
                                            if song.songWriters!.contains(per) {
                                                roleMArkedOnAnotherSongAll = true
                                            }
                                        }
                                        if let _ = song.songMixEngineer {
                                            if song.songMixEngineer!.contains(per) {
                                                roleMArkedOnAnotherSongAll = true
                                            }
                                        }
                                        if let _ = song.songMasteringEngineer {
                                            if song.songMasteringEngineer!.contains(per) {
                                                roleMArkedOnAnotherSongAll = true
                                            }
                                        }
                                        if let _ = song.songRecordingEngineer {
                                            if song.songRecordingEngineer!.contains(per) {
                                                roleMArkedOnAnotherSongAll = true
                                            }
                                        }
                                    }
                                    if subcount == album.tracks.count {
                                        if roleMArkedOnAnotherSong == false {
                                            if let ttt = album.allArtists {
                                                arrto = ttt
                                                if arrto.contains(per) {
                                                    let index = arrto.firstIndex(of: per)
                                                    arrto.remove(at: index!)
                                                    arrto = arrto.sorted()
                                                }
                                            }
                                            strongSelf.removeAlbumFromPersonRole(alb: alb, per: per, cat: "Artist")
                                        } else {
                                            if let ttt = album.allArtists {
                                                arrto = ttt.sorted()
                                            }
                                        }
                                        
                                        ref.setValue(arrto, withCompletionBlock: { error, reference in
                                            if let error = error {
                                                completion(error)
                                                return
                                            }
                                            else {
                                                if roleMArkedOnAnotherSongAll == false {
                                                    strongSelf.removeAlbumFromPersonArtist(alb: alb, per: per, completion: { error in
                                                        personcount+=1
                                                        if let error = error {
                                                            completion(error)
                                                            return
                                                        }
                                                        else {
                                                            if personcount == strongSelf.currSong.songArtist.count {
                                                                completion(nil)
                                                                return
                                                            }
                                                        }
                                                    })
                                                } else {
                                                    personcount+=1
                                                    if personcount == strongSelf.currSong.songArtist.count {
                                                        completion(nil)
                                                        return
                                                    }
                                                }
                                            }
                                        })
                                    }
                                case .failure(let err):
                                    print("dsvgredfxbdfzx"+err.localizedDescription)
                                }
                            })
                        }
                    }
                    if let inst = album.instrumentals {
                        for song in inst {
                            DatabaseManager.shared.findInstrumentalById(instrumentalId: song, completion: {[weak self] result in
                                guard let strongSelf = self else {return}
                                switch result {
                                case .success(let song):
                                    subcount+=1
                                    if let saa = song.artist {
                                        if saa.contains(per) {
                                            roleMArkedOnAnotherSong = true
                                            roleMArkedOnAnotherSongAll = true
                                        }
                                    }
                                    if song.producers.contains(per) {
                                        roleMArkedOnAnotherSongAll = true
                                    }
                                    if let saa = song.mixEngineer {
                                        if saa.contains(per) {
                                            roleMArkedOnAnotherSongAll = true
                                        }
                                    }
                                    if let saa = song.masteringEngineer {
                                        if saa.contains(per) {
                                            roleMArkedOnAnotherSongAll = true
                                        }
                                    }
                                    if subcount == album.tracks.count {
                                        if roleMArkedOnAnotherSong == false {
                                            if let ttt = album.allArtists {
                                                arrto = ttt
                                                if arrto.contains(per) {
                                                    let index = arrto.firstIndex(of: per)
                                                    arrto.remove(at: index!)
                                                    arrto = arrto.sorted()
                                                }
                                            }
                                            strongSelf.removeAlbumFromPersonRole(alb: alb, per: per, cat: "Artist")
                                        } else {
                                            if let ttt = album.allArtists {
                                                arrto = ttt.sorted()
                                            }
                                        }
                                        ref.setValue(arrto, withCompletionBlock: { error, reference in
                                            if let error = error {
                                                completion(error)
                                                return
                                            }
                                            else {
                                                if roleMArkedOnAnotherSongAll == false {
                                                    strongSelf.removeAlbumFromPersonArtist(alb: alb, per: per, completion: { error in
                                                        personcount+=1
                                                        if let error = error {
                                                            completion(error)
                                                            return
                                                        }
                                                        else {
                                                            if personcount == strongSelf.currSong.songArtist.count {
                                                                completion(nil)
                                                                return
                                                            }
                                                        }
                                                    })
                                                } else {
                                                    personcount+=1
                                                    if personcount == strongSelf.currSong.songArtist.count {
                                                        completion(nil)
                                                        return
                                                    }
                                                }
                                            }
                                        })
                                    }
                                case .failure(let err):
                                    print("dsvgredfxbdfzx"+err.localizedDescription)
                                }
                            })
                        }
                    }
                }
                
            case .failure(let err):
                print("dsvgredfxbdfzx"+err.localizedDescription)
            }
        })
    }
    
    func addArtistToAlbum(alb: String, completion: @escaping ((Error?) -> Void)) {
        guard alb.count == 8 else {
            completion(nil)
            return
        }
        
        DatabaseManager.shared.findAlbumById(albumId: alb, completion: {[weak self] result in
            guard let strongSelf = self else {return}
            switch result {
            case .success(let album):
                let ref = Database.database().reference().child("Music Content").child("Albums").child( "\(albumContentTag)--\(album.name)--\(album.toneDeafAppId)").child("REQUIRED").child("All Artist")
                var arrto:[String] = []
                for per in strongSelf.currSong.songArtist {
                    if var arrr = album.allArtists {
                        arrto = arrr
                        if !arrto.contains(per) {
                            arrto.append(per)
                        }
                        arrto.sort()
                    } else {
                        arrto = [per]
                    }
                }
                
                ref.setValue(arrto, withCompletionBlock: { error, reference in
                    if let error = error {
                        completion(error)
                        return
                    }
                    else {
                        completion(nil)
                        return
                    }
                })
            case .failure(let err):
                print("dsvgredfxbdfzx"+err.localizedDescription)
            }
        })
    }
    
    func updateArtistAlbums(ref: DatabaseReference, completion: @escaping ((Error?) -> Void)) {
        var initialArtistsArrFromDB:[String]!
        var totalProgress:Int = 0
        var completedProgress:Int = 0
        if currSong.albums!.sorted() == initSong.albums?.sorted() {
            completion(nil)
            return
        }
        
        getSongAlbumsInDB(ref: ref, completion: {[weak self] persons in
            guard let strongSelf = self else {return}
            initialArtistsArrFromDB = persons.sorted()
            
            if !initialArtistsArrFromDB.isEmpty {
                for i in 0 ... initialArtistsArrFromDB.count-1 {
                    if strongSelf.currSong.albums != nil {
                        if i < strongSelf.currSong.albums!.count {
                            if !strongSelf.currSong.albums![i].contains(initialArtistsArrFromDB[i]) {
                                for per in strongSelf.currSong.songArtist {
//                                    totalProgress+=1
                                }
                            }
                        } else {
                            for per in strongSelf.currSong.songArtist {
//                                totalProgress+=1
                            }
                        }
                    } else {
                        for per in strongSelf.currSong.songArtist {
//                            totalProgress+=1
                        }
                    }
                }
            }
            
            if strongSelf.currSong.albums != nil {
                var counter = 0
                if !strongSelf.currSong.albums!.isEmpty {
                    for i in 0 ... strongSelf.currSong.albums!.count-1 {
                        if i < initialArtistsArrFromDB.count {
                            if !initialArtistsArrFromDB[i].contains(strongSelf.currSong.albums![i]) {
                                counter+=1
                                if counter == strongSelf.currSong.albums!.count {
                                    for per in strongSelf.currSong.songArtist {
                                        totalProgress+=1
                                    }
                                }
                            }
                        } else {
                            counter+=1
                            if counter == strongSelf.currSong.albums!.count {
                                for per in strongSelf.currSong.songArtist {
                                    totalProgress+=1
                                }
                            }
                        }
                    }
                }
            }
            
            
            if totalProgress == 0 {
                completion(nil)
                return
            }
            
//            if !initialArtistsArrFromDB.isEmpty {
//                for i in 0 ... initialArtistsArrFromDB.count-1 {
//                    if strongSelf.currSong.albums != nil {
//                        if i < strongSelf.currSong.albums!.count {
//                            if !strongSelf.currSong.albums![i].contains(initialArtistsArrFromDB[i]) {
//                                for per in strongSelf.currSong.songArtist {
//                                    strongSelf.removeAlbumFromPersonArtist(alb: initialArtistsArrFromDB[i], per: per, completion: { error in
//                                        completedProgress+=1
//                                        if let error = error {
//                                            completion(error)
//                                            return
//                                        } else {
//                                            if completedProgress == totalProgress {
//                                                completion(nil)
//                                                return
//                                            }
//                                        }
//                                    })
//                                }
//                            }
//                        } else {
//                            for per in strongSelf.currSong.songArtist {
//                                strongSelf.removeAlbumFromPersonArtist(alb: initialArtistsArrFromDB[i], per: per, completion: { error in
//                                    completedProgress+=1
//                                    if let error = error {
//                                        completion(error)
//                                        return
//                                    } else {
//                                        if completedProgress == totalProgress {
//                                            completion(nil)
//                                            return
//                                        }
//                                    }
//                                })
//                            }
//                        }
//                    } else {
//                        for per in strongSelf.currSong.songArtist {
//                            strongSelf.removeAlbumFromPersonArtist(alb: initialArtistsArrFromDB[i], per: per, completion: { error in
//                                completedProgress+=1
//                                if let error = error {
//                                    completion(error)
//                                    return
//                                } else {
//                                    if completedProgress == totalProgress {
//                                        completion(nil)
//                                        return
//                                    }
//                                }
//                            })
//                        }
//                    }
//                }
//            }
            var counter = 0
            var arrayToAdd:[String] = []
            if strongSelf.currSong.albums != nil {
                if !strongSelf.currSong.albums!.isEmpty {
                    for i in 0 ... strongSelf.currSong.albums!.count-1 {
                        if i < initialArtistsArrFromDB.count {
                            if !initialArtistsArrFromDB[i].contains(strongSelf.currSong.albums![i]) {
                                arrayToAdd.append(strongSelf.currSong.albums![i])
                                counter+=1
                                if counter == strongSelf.currSong.albums!.count {
                                    for per in strongSelf.currSong.songArtist {
                                        strongSelf.addAlbumToPersonArtist(alb: arrayToAdd, per: per, completion: { error in
                                            completedProgress+=1
                                            if let error = error {
                                                completion(error)
                                                return
                                            } else {
                                                if completedProgress == totalProgress {
                                                    completion(nil)
                                                    return
                                                }
                                            }
                                        })
                                    }
                                }
                            }
                        } else {
                            arrayToAdd.append(strongSelf.currSong.albums![i])
                            counter+=1
                            if counter == strongSelf.currSong.albums!.count {
                                for per in strongSelf.currSong.songArtist {
                                    strongSelf.addAlbumToPersonArtist(alb: arrayToAdd, per: per, completion: { error in
                                        completedProgress+=1
                                        if let error = error {
                                            completion(error)
                                            return
                                        } else {
                                            if completedProgress == totalProgress {
                                                completion(nil)
                                                return
                                            }
                                        }
                                    })
                                }
                            }
                        }
                    }
                }
            }
            
        })
    }
    
    func updateAlbumsProducers(ref: DatabaseReference, completion: @escaping ((Error?) -> Void)) {
        var initialArtistsArrFromDB:[String]!
        var totalProgress:Int = 0
        var completedProgress:Int = 0
        if currSong.albums!.sorted() == initSong.albums?.sorted() {
            completion(nil)
            return
        }
        
        getSongAlbumsInDB(ref: ref, completion: {[weak self] persons in
            guard let strongSelf = self else {return}
            initialArtistsArrFromDB = persons.sorted()
            
            if !initialArtistsArrFromDB.isEmpty {
                for i in 0 ... initialArtistsArrFromDB.count-1 {
                    if strongSelf.currSong.albums != nil {
                        if i < strongSelf.currSong.albums!.count {
                            if !strongSelf.currSong.albums![i].contains(initialArtistsArrFromDB[i]) {
                                totalProgress+=1
                            }
                        } else {
                            totalProgress+=1
                        }
                    } else {
                        totalProgress+=1
                    }
                }
            }
            
            if strongSelf.currSong.albums != nil {
                if !strongSelf.currSong.albums!.isEmpty {
                    for i in 0 ... strongSelf.currSong.albums!.count-1 {
                        if i < initialArtistsArrFromDB.count {
                            if !initialArtistsArrFromDB[i].contains(strongSelf.currSong.albums![i]) {
                                totalProgress+=1
                            }
                        } else {
                            totalProgress+=1
                        }
                    }
                }
            }
            
            if !initialArtistsArrFromDB.isEmpty {
                for i in 0 ... initialArtistsArrFromDB.count-1 {
                    if strongSelf.currSong.albums != nil {
                        if i < strongSelf.currSong.albums!.count {
                            if !strongSelf.currSong.albums![i].contains(initialArtistsArrFromDB[i]) {
                                strongSelf.removeProducerFromAlbum(alb: initialArtistsArrFromDB[i], completion: { error in
                                    completedProgress+=1
                                    if let error = error {
                                        completion(error)
                                        return
                                    } else {
                                        if completedProgress == totalProgress {
                                            completion(nil)
                                            return
                                        }
                                    }
                                })
                            }
                        } else {
                            strongSelf.removeProducerFromAlbum(alb: initialArtistsArrFromDB[i], completion: { error in
                                completedProgress+=1
                                if let error = error {
                                    completion(error)
                                    return
                                } else {
                                    if completedProgress == totalProgress {
                                        completion(nil)
                                        return
                                    }
                                }
                            })
                        }
                    } else {
                        strongSelf.removeProducerFromAlbum(alb: initialArtistsArrFromDB[i], completion: { error in
                            completedProgress+=1
                            if let error = error {
                                completion(error)
                                return
                            } else {
                                if completedProgress == totalProgress {
                                    completion(nil)
                                    return
                                }
                            }
                        })
                    }
                }
            }
            
            if totalProgress == 0 {
                completion(nil)
            }
            
            if strongSelf.currSong.albums != nil {
                if !strongSelf.currSong.albums!.isEmpty {
                    for i in 0 ... strongSelf.currSong.albums!.count-1 {
                        if i < initialArtistsArrFromDB.count {
                            if !initialArtistsArrFromDB[i].contains(strongSelf.currSong.albums![i]) {
                                strongSelf.addProducerToAlbum(alb: strongSelf.currSong.albums![i], completion: { error in
                                    completedProgress+=1
                                    if let error = error {
                                        completion(error)
                                        return
                                    } else {
                                        if completedProgress == totalProgress {
                                            completion(nil)
                                            return
                                        }
                                    }
                                })
                            }
                        } else {
                            strongSelf.addProducerToAlbum(alb: strongSelf.currSong.albums![i], completion: { error in
                                completedProgress+=1
                                if let error = error {
                                    completion(error)
                                    return
                                } else {
                                    if completedProgress == totalProgress {
                                        completion(nil)
                                        return
                                    }
                                }
                            })
                        }
                    }
                }
            }
            
        })
    }
    
    func removeProducerFromAlbum(alb: String, completion: @escaping ((Error?) -> Void)) {
        guard alb.count == 8 else {
            completion(nil)
            return
        }
        
        DatabaseManager.shared.findAlbumById(albumId: alb, completion: {[weak self] result in
            guard let strongSelf = self else {return}
            switch result {
            case .success(let album):
                let ref = Database.database().reference().child("Music Content").child("Albums").child( "\(albumContentTag)--\(album.name)--\(album.toneDeafAppId)").child("REQUIRED").child("All Producers")
                var arrto:[String] = album.producers
                var personcount = 0
                for per in strongSelf.currSong.songProducers {
                    var roleMArkedOnAnotherSong:Bool = false
                    var roleMArkedOnAnotherSongAll:Bool = false
                    var subcount = 0
                    if let arr2 = album.songs {
                        for song in arr2 {
                            DatabaseManager.shared.findSongById(songId: song, completion: {[weak self] result in
                                guard let strongSelf = self else {return}
                                switch result {
                                case .success(let song):
                                    subcount+=1
                                    if song.toneDeafAppId != strongSelf.currSong.toneDeafAppId {
                                        if song.songProducers.contains(per) {
                                            roleMArkedOnAnotherSongAll = true
                                            roleMArkedOnAnotherSong = true
                                        }
                                        if song.songArtist.contains(per) {
                                            roleMArkedOnAnotherSongAll = true
                                        }
                                        if let _ = song.songWriters {
                                            if song.songWriters!.contains(per) {
                                                roleMArkedOnAnotherSongAll = true
                                            }
                                        }
                                        if let _ = song.songMixEngineer {
                                            if song.songMixEngineer!.contains(per) {
                                                roleMArkedOnAnotherSongAll = true
                                            }
                                        }
                                        if let _ = song.songMasteringEngineer {
                                            if song.songMasteringEngineer!.contains(per) {
                                                roleMArkedOnAnotherSongAll = true
                                            }
                                        }
                                        if let _ = song.songRecordingEngineer {
                                            if song.songRecordingEngineer!.contains(per) {
                                                roleMArkedOnAnotherSongAll = true
                                            }
                                        }
                                    }
                                    if subcount == album.tracks.count {
                                        if roleMArkedOnAnotherSong == false {
                                            arrto = album.producers
                                            if arrto.contains(per) {
                                                let index = arrto.firstIndex(of: per)
                                                arrto.remove(at: index!)
                                                arrto = arrto.sorted()
                                            }
                                            strongSelf.removeAlbumFromPersonRole(alb: alb, per: per, cat: "Producer")
                                        } else {
                                            arrto = album.producers.sorted()
                                        }
                                        ref.setValue(arrto, withCompletionBlock: { error, reference in
                                            if let error = error {
                                                completion(error)
                                                return
                                            }
                                            else {
                                                if roleMArkedOnAnotherSongAll == false {
                                                    strongSelf.removeAlbumFromPersonProducer(alb: alb, per: per, completion: { error in
                                                        personcount+=1
                                                        if let error = error {
                                                            completion(error)
                                                            return
                                                        }
                                                        else {
                                                            if personcount == strongSelf.currSong.songProducers.count {
                                                                completion(nil)
                                                                return
                                                            }
                                                        }
                                                    })
                                                } else {
                                                    personcount+=1
                                                    if personcount == strongSelf.currSong.songProducers.count {
                                                        completion(nil)
                                                        return
                                                    }
                                                }
                                            }
                                        })
                                    }
                                case .failure(let err):
                                    print("dsvgredfxbdfzx"+err.localizedDescription)
                                }
                            })
                        }
                    }
                    if let inst = album.instrumentals {
                        for song in inst {
                            DatabaseManager.shared.findInstrumentalById(instrumentalId: song, completion: {[weak self] result in
                                guard let strongSelf = self else {return}
                                switch result {
                                case .success(let song):
                                    subcount+=1
                                    if let saa = song.artist {
                                        if saa.contains(per) {
                                            roleMArkedOnAnotherSongAll = true
                                        }
                                    }
                                    if song.producers.contains(per) {
                                        roleMArkedOnAnotherSongAll = true
                                        roleMArkedOnAnotherSong = true
                                    }
                                    if let saa = song.mixEngineer {
                                        if saa.contains(per) {
                                            roleMArkedOnAnotherSongAll = true
                                        }
                                    }
                                    if let saa = song.masteringEngineer {
                                        if saa.contains(per) {
                                            roleMArkedOnAnotherSongAll = true
                                        }
                                    }
                                    if subcount == album.tracks.count {
                                        if roleMArkedOnAnotherSong == false {
                                            arrto = album.producers
                                            if arrto.contains(per) {
                                                let index = arrto.firstIndex(of: per)
                                                arrto.remove(at: index!)
                                                arrto = arrto.sorted()
                                            }
                                            strongSelf.removeAlbumFromPersonRole(alb: alb, per: per, cat: "Producer")
                                        } else {
                                            arrto = album.producers.sorted()
                                        }
                                        
                                        ref.setValue(arrto, withCompletionBlock: { error, reference in
                                            if let error = error {
                                                completion(error)
                                                return
                                            }
                                            else {
                                                if roleMArkedOnAnotherSongAll == false {
                                                    strongSelf.removeAlbumFromPersonProducer(alb: alb, per: per, completion: { error in
                                                        personcount+=1
                                                        if let error = error {
                                                            completion(error)
                                                            return
                                                        }
                                                        else {
                                                            if personcount == strongSelf.currSong.songProducers.count {
                                                                completion(nil)
                                                                return
                                                            }
                                                        }
                                                    })
                                                } else {
                                                    personcount+=1
                                                    if personcount == strongSelf.currSong.songProducers.count {
                                                        completion(nil)
                                                        return
                                                    }
                                                }
                                            }
                                        })
                                    }
                                case .failure(let err):
                                    print("dsvgredfxbdfzx"+err.localizedDescription)
                                }
                            })
                        }
                    }
                }
                
            case .failure(let err):
                print("dsvgredfxbdfzx"+err.localizedDescription)
            }
        })
    }
    
    func addProducerToAlbum(alb: String, completion: @escaping ((Error?) -> Void)) {
        guard alb.count == 8 else {
            completion(nil)
            return
        }
        
        DatabaseManager.shared.findAlbumById(albumId: alb, completion: {[weak self] result in
            guard let strongSelf = self else {return}
            switch result {
            case .success(let album):
                let ref = Database.database().reference().child("Music Content").child("Albums").child( "\(albumContentTag)--\(album.name)--\(album.toneDeafAppId)").child("REQUIRED").child("All Producers")
                var arrto:[String] = []
                for per in strongSelf.currSong.songProducers {
                    arrto = album.producers
                    if !arrto.contains(per) {
                        arrto.append(per)
                    }
                    arrto.sort()
                }
                
                ref.setValue(arrto, withCompletionBlock: { error, reference in
                    if let error = error {
                        completion(error)
                        return
                    }
                    else {
                        completion(nil)
                        return
                    }
                })
            case .failure(let err):
                print("dsvgredfxbdfzx"+err.localizedDescription)
            }
        })
    }
    
    func updateProducerAlbums(ref: DatabaseReference, completion: @escaping ((Error?) -> Void)) {
        var initialArtistsArrFromDB:[String]!
        var totalProgress:Int = 0
        var completedProgress:Int = 0
        if currSong.albums!.sorted() == initSong.albums?.sorted() {
            completion(nil)
            return
        }
        
        getSongAlbumsInDB(ref: ref, completion: {[weak self] persons in
            guard let strongSelf = self else {return}
            initialArtistsArrFromDB = persons.sorted()
            
            if !initialArtistsArrFromDB.isEmpty {
                for i in 0 ... initialArtistsArrFromDB.count-1 {
                    if strongSelf.currSong.albums != nil {
                        if i < strongSelf.currSong.albums!.count {
                            if !strongSelf.currSong.albums![i].contains(initialArtistsArrFromDB[i]) {
                                for per in strongSelf.currSong.songProducers {
//                                    totalProgress+=1
                                }
                            }
                        } else {
                            for per in strongSelf.currSong.songProducers {
//                                totalProgress+=1
                            }
                        }
                    } else {
                        for per in strongSelf.currSong.songProducers {
//                            totalProgress+=1
                        }
                    }
                }
            }
            
            if strongSelf.currSong.albums != nil {
                var counter = 0
                if !strongSelf.currSong.albums!.isEmpty {
                    for i in 0 ... strongSelf.currSong.albums!.count-1 {
                        if i < initialArtistsArrFromDB.count {
                            if !initialArtistsArrFromDB[i].contains(strongSelf.currSong.albums![i]) {
                                counter+=1
                                if counter == strongSelf.currSong.albums!.count {
                                    for per in strongSelf.currSong.songProducers {
                                        totalProgress+=1
                                    }
                                }
                            }
                        } else {
                            counter+=1
                            if counter == strongSelf.currSong.albums!.count {
                                for per in strongSelf.currSong.songProducers {
                                    totalProgress+=1
                                }
                            }
                        }
                    }
                }
            }
            
            
            if totalProgress == 0 {
                completion(nil)
            }
            
//            if !initialArtistsArrFromDB.isEmpty {
//                for i in 0 ... initialArtistsArrFromDB.count-1 {
//                    if strongSelf.currSong.albums != nil {
//                        if i < strongSelf.currSong.albums!.count {
//                            if !strongSelf.currSong.albums![i].contains(initialArtistsArrFromDB[i]) {
//                                for per in strongSelf.currSong.songArtist {
//                                    strongSelf.removeAlbumFromPersonArtist(alb: initialArtistsArrFromDB[i], per: per, completion: { error in
//                                        completedProgress+=1
//                                        if let error = error {
//                                            completion(error)
//                                            return
//                                        } else {
//                                            if completedProgress == totalProgress {
//                                                completion(nil)
//                                                return
//                                            }
//                                        }
//                                    })
//                                }
//                            }
//                        } else {
//                            for per in strongSelf.currSong.songArtist {
//                                strongSelf.removeAlbumFromPersonArtist(alb: initialArtistsArrFromDB[i], per: per, completion: { error in
//                                    completedProgress+=1
//                                    if let error = error {
//                                        completion(error)
//                                        return
//                                    } else {
//                                        if completedProgress == totalProgress {
//                                            completion(nil)
//                                            return
//                                        }
//                                    }
//                                })
//                            }
//                        }
//                    } else {
//                        for per in strongSelf.currSong.songArtist {
//                            strongSelf.removeAlbumFromPersonArtist(alb: initialArtistsArrFromDB[i], per: per, completion: { error in
//                                completedProgress+=1
//                                if let error = error {
//                                    completion(error)
//                                    return
//                                } else {
//                                    if completedProgress == totalProgress {
//                                        completion(nil)
//                                        return
//                                    }
//                                }
//                            })
//                        }
//                    }
//                }
//            }
            var counter = 0
            var arrayToAdd:[String] = []
            if strongSelf.currSong.albums != nil {
                if !strongSelf.currSong.albums!.isEmpty {
                    for i in 0 ... strongSelf.currSong.albums!.count-1 {
                        if i < initialArtistsArrFromDB.count {
                            if !initialArtistsArrFromDB[i].contains(strongSelf.currSong.albums![i]) {
                                arrayToAdd.append(strongSelf.currSong.albums![i])
                                counter+=1
                                if counter == strongSelf.currSong.albums!.count {
                                    for per in strongSelf.currSong.songProducers {
                                        strongSelf.addAlbumToPersonProducer(alb: arrayToAdd, per: per, completion: { error in
                                            completedProgress+=1
                                            if let error = error {
                                                completion(error)
                                                return
                                            } else {
                                                if completedProgress == totalProgress {
                                                    completion(nil)
                                                    return
                                                }
                                            }
                                        })
                                    }
                                }
                            }
                        } else {
                            arrayToAdd.append(strongSelf.currSong.albums![i])
                            counter+=1
                            if counter == strongSelf.currSong.albums!.count {
                                for per in strongSelf.currSong.songProducers {
                                    strongSelf.addAlbumToPersonProducer(alb: arrayToAdd, per: per, completion: { error in
                                        completedProgress+=1
                                        if let error = error {
                                            completion(error)
                                            return
                                        } else {
                                            if completedProgress == totalProgress {
                                                completion(nil)
                                                return
                                            }
                                        }
                                    })
                                }
                            }
                        }
                    }
                }
            }
            
        })
    }
    
    func updateAlbumsWriters(ref: DatabaseReference, completion: @escaping ((Error?) -> Void)) {
        var initialArtistsArrFromDB:[String]!
        var totalProgress:Int = 0
        var completedProgress:Int = 0
        if currSong.albums!.sorted() == initSong.albums?.sorted() {
            completion(nil)
            return
        }
        
        getSongAlbumsInDB(ref: ref, completion: {[weak self] persons in
            guard let strongSelf = self else {return}
            initialArtistsArrFromDB = persons.sorted()
            
            if !initialArtistsArrFromDB.isEmpty {
                for i in 0 ... initialArtistsArrFromDB.count-1 {
                    if strongSelf.currSong.albums != nil {
                        if i < strongSelf.currSong.albums!.count {
                            if !strongSelf.currSong.albums![i].contains(initialArtistsArrFromDB[i]) {
                                totalProgress+=1
                            }
                        } else {
                            totalProgress+=1
                        }
                    } else {
                        totalProgress+=1
                    }
                }
            }
            
            if strongSelf.currSong.albums != nil {
                if !strongSelf.currSong.albums!.isEmpty {
                    for i in 0 ... strongSelf.currSong.albums!.count-1 {
                        if i < initialArtistsArrFromDB.count {
                            if !initialArtistsArrFromDB[i].contains(strongSelf.currSong.albums![i]) {
                                totalProgress+=1
                            }
                        } else {
                            totalProgress+=1
                        }
                    }
                }
            }
            
            if totalProgress == 0 {
                completion(nil)
            }
            
            if !initialArtistsArrFromDB.isEmpty {
                for i in 0 ... initialArtistsArrFromDB.count-1 {
                    if strongSelf.currSong.albums != nil {
                        if i < strongSelf.currSong.albums!.count {
                            if !strongSelf.currSong.albums![i].contains(initialArtistsArrFromDB[i]) {
                                strongSelf.removeWriterFromAlbum(alb: initialArtistsArrFromDB[i], completion: { error in
                                    completedProgress+=1
                                    if let error = error {
                                        completion(error)
                                        return
                                    } else {
                                        if completedProgress == totalProgress {
                                            completion(nil)
                                            return
                                        }
                                    }
                                })
                            }
                        } else {
                            strongSelf.removeWriterFromAlbum(alb: initialArtistsArrFromDB[i], completion: { error in
                                completedProgress+=1
                                if let error = error {
                                    completion(error)
                                    return
                                } else {
                                    if completedProgress == totalProgress {
                                        completion(nil)
                                        return
                                    }
                                }
                            })
                        }
                    } else {
                        strongSelf.removeWriterFromAlbum(alb: initialArtistsArrFromDB[i], completion: { error in
                            completedProgress+=1
                            if let error = error {
                                completion(error)
                                return
                            } else {
                                if completedProgress == totalProgress {
                                    completion(nil)
                                    return
                                }
                            }
                        })
                    }
                }
            }
            
            if strongSelf.currSong.albums != nil {
                if !strongSelf.currSong.albums!.isEmpty {
                    for i in 0 ... strongSelf.currSong.albums!.count-1 {
                        if i < initialArtistsArrFromDB.count {
                            if !initialArtistsArrFromDB[i].contains(strongSelf.currSong.albums![i]) {
                                strongSelf.addWriterToAlbum(alb: strongSelf.currSong.albums![i], completion: { error in
                                    completedProgress+=1
                                    if let error = error {
                                        completion(error)
                                        return
                                    } else {
                                        if completedProgress == totalProgress {
                                            completion(nil)
                                            return
                                        }
                                    }
                                })
                            }
                        } else {
                            strongSelf.addWriterToAlbum(alb: strongSelf.currSong.albums![i], completion: { error in
                                completedProgress+=1
                                if let error = error {
                                    completion(error)
                                    return
                                } else {
                                    if completedProgress == totalProgress {
                                        completion(nil)
                                        return
                                    }
                                }
                            })
                        }
                    }
                }
            }
            
        })
    }
    
    func removeWriterFromAlbum(alb: String, completion: @escaping ((Error?) -> Void)) {
        guard alb.count == 8 else {
            completion(nil)
            return
        }
        
        if let arrrry = currSong.songWriters {
            DatabaseManager.shared.findAlbumById(albumId: alb, completion: {[weak self] result in
                guard let strongSelf = self else {return}
                switch result {
                case .success(let album):
                    let ref = Database.database().reference().child("Music Content").child("Albums").child( "\(albumContentTag)--\(album.name)--\(album.toneDeafAppId)").child("REQUIRED").child("All Writers")
                    var arrto:[String] = []
                    var personcount = 0
                    for per in arrrry {
                        var subcount = 0
                        var roleMArkedOnAnotherSong:Bool = false
                        var roleMArkedOnAnotherSongAll = false
                        if let arr2 = album.songs {
                            for song in arr2 {
                                DatabaseManager.shared.findSongById(songId: song, completion: {[weak self] result in
                                    guard let strongSelf = self else {return}
                                    switch result {
                                    case .success(let song):
                                        subcount+=1
                                        if song.toneDeafAppId != strongSelf.currSong.toneDeafAppId {
                                            if song.songProducers.contains(per) {
                                                roleMArkedOnAnotherSongAll = true
                                            }
                                            if song.songArtist.contains(per) {
                                                roleMArkedOnAnotherSongAll = true
                                            }
                                            if let _ = song.songWriters {
                                                if song.songWriters!.contains(per) {
                                                    roleMArkedOnAnotherSong = true
                                                    roleMArkedOnAnotherSongAll = true
                                                }
                                            }
                                            if let _ = song.songMixEngineer {
                                                if song.songMixEngineer!.contains(per) {
                                                    roleMArkedOnAnotherSongAll = true
                                                }
                                            }
                                            if let _ = song.songMasteringEngineer {
                                                if song.songMasteringEngineer!.contains(per) {
                                                    roleMArkedOnAnotherSongAll = true
                                                }
                                            }
                                            if let _ = song.songRecordingEngineer {
                                                if song.songRecordingEngineer!.contains(per) {
                                                    roleMArkedOnAnotherSongAll = true
                                                }
                                            }
                                        }
                                        if subcount == album.tracks.count {
                                            if roleMArkedOnAnotherSong == false {
                                                if let arrrr = album.writers {
                                                    arrto = arrrr
                                                    if arrto.contains(per) {
                                                        let index = arrto.firstIndex(of: per)
                                                        arrto.remove(at: index!)
                                                        arrto = arrto.sorted()
                                                    }
                                                }
                                                strongSelf.removeAlbumFromPersonRole(alb: alb, per: per, cat: "Writer")
                                            } else {
                                                if let arrrr = album.writers {
                                                    arrto = arrrr.sorted()
                                                }
                                            }
                                            ref.setValue(arrto, withCompletionBlock: { error, reference in
                                                if let error = error {
                                                    completion(error)
                                                    return
                                                }
                                                else {
                                                    if roleMArkedOnAnotherSongAll == false {
                                                        strongSelf.removeAlbumFromPersonWriter(alb: alb, per: per, completion: { error in
                                                            personcount+=1
                                                            if let error = error {
                                                                completion(error)
                                                                return
                                                            }
                                                            else {
                                                                if personcount == arrrry.count {
                                                                    completion(nil)
                                                                    return
                                                                }
                                                            }
                                                        })
                                                    } else {
                                                        personcount+=1
                                                        if personcount == arrrry.count {
                                                            completion(nil)
                                                            return
                                                        }
                                                    }
                                                }
                                            })
                                        }
                                    case .failure(let err):
                                        print("dsvgredfxbdfzx"+err.localizedDescription)
                                    }
                                })
                            }
                        }
                        if let inst = album.instrumentals {
                            for song in inst {
                                DatabaseManager.shared.findInstrumentalById(instrumentalId: song, completion: {[weak self] result in
                                    guard let strongSelf = self else {return}
                                    switch result {
                                    case .success(let song):
                                        subcount+=1
                                        if let saa = song.artist {
                                            if saa.contains(per) {
                                                roleMArkedOnAnotherSongAll = true
                                            }
                                        }
                                        if song.producers.contains(per) {
                                            roleMArkedOnAnotherSongAll = true
                                        }
                                        if let saa = song.mixEngineer {
                                            if saa.contains(per) {
                                                roleMArkedOnAnotherSongAll = true
                                            }
                                        }
                                        if let saa = song.masteringEngineer {
                                            if saa.contains(per) {
                                                roleMArkedOnAnotherSongAll = true
                                            }
                                        }
                                        if subcount == album.tracks.count {
                                            if roleMArkedOnAnotherSong == false {
                                                if let ttt = album.writers {
                                                    arrto = ttt
                                                    if arrto.contains(per) {
                                                        let index = arrto.firstIndex(of: per)
                                                        arrto.remove(at: index!)
                                                        arrto = arrto.sorted()
                                                    }
                                                }
                                                strongSelf.removeAlbumFromPersonRole(alb: alb, per: per, cat: "Writer")
                                            } else {
                                                if let ttt = album.writers {
                                                    arrto = ttt.sorted()
                                                }
                                            }
                                            ref.setValue(arrto, withCompletionBlock: { error, reference in
                                                if let error = error {
                                                    completion(error)
                                                    return
                                                }
                                                else {
                                                    if roleMArkedOnAnotherSongAll == false {
                                                        strongSelf.removeAlbumFromPersonWriter(alb: alb, per: per, completion: { error in
                                                            personcount+=1
                                                            if let error = error {
                                                                completion(error)
                                                                return
                                                            }
                                                            else {
                                                                if personcount == arrrry.count {
                                                                    completion(nil)
                                                                    return
                                                                }
                                                            }
                                                        })
                                                    } else {
                                                        personcount+=1
                                                        if personcount == arrrry.count {
                                                            completion(nil)
                                                            return
                                                        }
                                                    }
                                                }
                                            })
                                        }
                                    case .failure(let err):
                                        print("dsvgredfxbdfzx"+err.localizedDescription)
                                    }
                                })
                            }
                        }
                    }
                    
                case .failure(let err):
                    print("dsvgredfxbdfzx"+err.localizedDescription)
                }
            })
        } else {
            completion(nil)
        }
    }
    
    func addWriterToAlbum(alb: String, completion: @escaping ((Error?) -> Void)) {
        guard alb.count == 8 else {
            completion(nil)
            return
        }
        if let arrrry = currSong.songWriters {
            DatabaseManager.shared.findAlbumById(albumId: alb, completion: {[weak self] result in
                guard let strongSelf = self else {return}
                switch result {
                case .success(let album):
                    let ref = Database.database().reference().child("Music Content").child("Albums").child( "\(albumContentTag)--\(album.name)--\(album.toneDeafAppId)").child("REQUIRED").child("All Writers")
                    var arrto:[String] = []
                    for per in arrrry {
                        if var arrr = album.writers {
                            arrto = arrr
                            if !arrto.contains(per) {
                                arrto.append(per)
                            }
                            arrto.sort()
                        } else {
                            arrto = [per]
                        }
                    }
                    
                    ref.setValue(arrto, withCompletionBlock: { error, reference in
                        if let error = error {
                            completion(error)
                            return
                        }
                        else {
                            completion(nil)
                            return
                        }
                    })
                case .failure(let err):
                    print("dsvgredfxbdfzx"+err.localizedDescription)
                }
            })
        } else {
            completion(nil)
        }
    }
    
    func updateWriterAlbums(ref: DatabaseReference, completion: @escaping ((Error?) -> Void)) {
        var initialArtistsArrFromDB:[String]!
        var totalProgress:Int = 0
        var completedProgress:Int = 0
        if currSong.albums!.sorted() == initSong.albums?.sorted() {
            completion(nil)
            return
        }
        
        getSongAlbumsInDB(ref: ref, completion: {[weak self] persons in
            guard let strongSelf = self else {return}
            initialArtistsArrFromDB = persons.sorted()
            
            if !initialArtistsArrFromDB.isEmpty {
                for i in 0 ... initialArtistsArrFromDB.count-1 {
                    if strongSelf.currSong.albums != nil {
                        if i < strongSelf.currSong.albums!.count {
                            if !strongSelf.currSong.albums![i].contains(initialArtistsArrFromDB[i]) {
                                if strongSelf.currSong.songWriters != nil {
                                    for per in strongSelf.currSong.songWriters! {
                                        //                                    totalProgress+=1
                                    }
                                }
                            }
                        } else {
                            if strongSelf.currSong.songWriters != nil {
                                for per in strongSelf.currSong.songWriters! {
                                    //                                totalProgress+=1
                                }
                            }
                        }
                    } else {
                        if strongSelf.currSong.songWriters != nil {
                            for per in strongSelf.currSong.songWriters! {
                                //                            totalProgress+=1
                            }
                        }
                    }
                }
            }
            
            if strongSelf.currSong.albums != nil {
                var counter = 0
                if !strongSelf.currSong.albums!.isEmpty {
                    for i in 0 ... strongSelf.currSong.albums!.count-1 {
                        if i < initialArtistsArrFromDB.count {
                            if !initialArtistsArrFromDB[i].contains(strongSelf.currSong.albums![i]) {
                                counter+=1
                                if counter == strongSelf.currSong.albums!.count {
                                    if strongSelf.currSong.songWriters != nil {
                                        for per in strongSelf.currSong.songWriters! {
                                            totalProgress+=1
                                        }
                                    }
                                }
                            }
                        } else {
                            counter+=1
                            if counter == strongSelf.currSong.albums!.count {
                                if strongSelf.currSong.songWriters != nil {
                                    for per in strongSelf.currSong.songWriters! {
                                        totalProgress+=1
                                    }
                                }
                            }
                        }
                    }
                }
            }
            
            
            if totalProgress == 0 {
                completion(nil)
            }
            
//            if !initialArtistsArrFromDB.isEmpty {
//                for i in 0 ... initialArtistsArrFromDB.count-1 {
//                    if strongSelf.currSong.albums != nil {
//                        if i < strongSelf.currSong.albums!.count {
//                            if !strongSelf.currSong.albums![i].contains(initialArtistsArrFromDB[i]) {
//                                for per in strongSelf.currSong.songArtist {
//                                    strongSelf.removeAlbumFromPersonArtist(alb: initialArtistsArrFromDB[i], per: per, completion: { error in
//                                        completedProgress+=1
//                                        if let error = error {
//                                            completion(error)
//                                            return
//                                        } else {
//                                            if completedProgress == totalProgress {
//                                                completion(nil)
//                                                return
//                                            }
//                                        }
//                                    })
//                                }
//                            }
//                        } else {
//                            for per in strongSelf.currSong.songArtist {
//                                strongSelf.removeAlbumFromPersonArtist(alb: initialArtistsArrFromDB[i], per: per, completion: { error in
//                                    completedProgress+=1
//                                    if let error = error {
//                                        completion(error)
//                                        return
//                                    } else {
//                                        if completedProgress == totalProgress {
//                                            completion(nil)
//                                            return
//                                        }
//                                    }
//                                })
//                            }
//                        }
//                    } else {
//                        for per in strongSelf.currSong.songArtist {
//                            strongSelf.removeAlbumFromPersonArtist(alb: initialArtistsArrFromDB[i], per: per, completion: { error in
//                                completedProgress+=1
//                                if let error = error {
//                                    completion(error)
//                                    return
//                                } else {
//                                    if completedProgress == totalProgress {
//                                        completion(nil)
//                                        return
//                                    }
//                                }
//                            })
//                        }
//                    }
//                }
//            }
            var counter = 0
            var arrayToAdd:[String] = []
            if strongSelf.currSong.albums != nil {
                if !strongSelf.currSong.albums!.isEmpty {
                    for i in 0 ... strongSelf.currSong.albums!.count-1 {
                        if i < initialArtistsArrFromDB.count {
                            if !initialArtistsArrFromDB[i].contains(strongSelf.currSong.albums![i]) {
                                arrayToAdd.append(strongSelf.currSong.albums![i])
                                counter+=1
                                if counter == strongSelf.currSong.albums!.count {
                                    if strongSelf.currSong.songWriters != nil {
                                        for per in strongSelf.currSong.songWriters! {
                                            strongSelf.addAlbumToPersonWriter(alb: arrayToAdd, per: per, completion: { error in
                                                completedProgress+=1
                                                if let error = error {
                                                    completion(error)
                                                    return
                                                } else {
                                                    if completedProgress == totalProgress {
                                                        completion(nil)
                                                        return
                                                    }
                                                }
                                            })
                                        }
                                    }
                                }
                            }
                        } else {
                            arrayToAdd.append(strongSelf.currSong.albums![i])
                            counter+=1
                            if counter == strongSelf.currSong.albums!.count {
                                if strongSelf.currSong.songWriters != nil {
                                    for per in strongSelf.currSong.songWriters! {
                                        strongSelf.addAlbumToPersonWriter(alb: arrayToAdd, per: per, completion: { error in
                                            completedProgress+=1
                                            if let error = error {
                                                completion(error)
                                                return
                                            } else {
                                                if completedProgress == totalProgress {
                                                    completion(nil)
                                                    return
                                                }
                                            }
                                        })
                                    }
                                }
                            }
                        }
                    }
                }
            }
            
        })
    }
    
    func updateAlbumsMixEngineers(ref: DatabaseReference, completion: @escaping ((Error?) -> Void)) {
        var initialArtistsArrFromDB:[String]!
        var totalProgress:Int = 0
        var completedProgress:Int = 0
        if currSong.albums!.sorted() == initSong.albums?.sorted() {
            completion(nil)
            return
        }
        
        getSongAlbumsInDB(ref: ref, completion: {[weak self] persons in
            guard let strongSelf = self else {return}
            initialArtistsArrFromDB = persons.sorted()
            
            if !initialArtistsArrFromDB.isEmpty {
                for i in 0 ... initialArtistsArrFromDB.count-1 {
                    if strongSelf.currSong.albums != nil {
                        if i < strongSelf.currSong.albums!.count {
                            if !strongSelf.currSong.albums![i].contains(initialArtistsArrFromDB[i]) {
                                totalProgress+=1
                            }
                        } else {
                            totalProgress+=1
                        }
                    } else {
                        totalProgress+=1
                    }
                }
            }
            
            if strongSelf.currSong.albums != nil {
                if !strongSelf.currSong.albums!.isEmpty {
                    for i in 0 ... strongSelf.currSong.albums!.count-1 {
                        if i < initialArtistsArrFromDB.count {
                            if !initialArtistsArrFromDB[i].contains(strongSelf.currSong.albums![i]) {
                                totalProgress+=1
                            }
                        } else {
                            totalProgress+=1
                        }
                    }
                }
            }
            
            if totalProgress == 0 {
                completion(nil)
            }
            
            if !initialArtistsArrFromDB.isEmpty {
                for i in 0 ... initialArtistsArrFromDB.count-1 {
                    if strongSelf.currSong.albums != nil {
                        if i < strongSelf.currSong.albums!.count {
                            if !strongSelf.currSong.albums![i].contains(initialArtistsArrFromDB[i]) {
                                strongSelf.removeMixEngineerFromAlbum(alb: initialArtistsArrFromDB[i], completion: { error in
                                    completedProgress+=1
                                    if let error = error {
                                        completion(error)
                                        return
                                    } else {
                                        if completedProgress == totalProgress {
                                            completion(nil)
                                            return
                                        }
                                    }
                                })
                            }
                        } else {
                            strongSelf.removeMixEngineerFromAlbum(alb: initialArtistsArrFromDB[i], completion: { error in
                                completedProgress+=1
                                if let error = error {
                                    completion(error)
                                    return
                                } else {
                                    if completedProgress == totalProgress {
                                        completion(nil)
                                        return
                                    }
                                }
                            })
                        }
                    } else {
                        strongSelf.removeMixEngineerFromAlbum(alb: initialArtistsArrFromDB[i], completion: { error in
                            completedProgress+=1
                            if let error = error {
                                completion(error)
                                return
                            } else {
                                if completedProgress == totalProgress {
                                    completion(nil)
                                    return
                                }
                            }
                        })
                    }
                }
            }
            
            if strongSelf.currSong.albums != nil {
                if !strongSelf.currSong.albums!.isEmpty {
                    for i in 0 ... strongSelf.currSong.albums!.count-1 {
                        if i < initialArtistsArrFromDB.count {
                            if !initialArtistsArrFromDB[i].contains(strongSelf.currSong.albums![i]) {
                                strongSelf.addMixEngineerToAlbum(alb: strongSelf.currSong.albums![i], completion: { error in
                                    completedProgress+=1
                                    if let error = error {
                                        completion(error)
                                        return
                                    } else {
                                        if completedProgress == totalProgress {
                                            completion(nil)
                                            return
                                        }
                                    }
                                })
                            }
                        } else {
                            strongSelf.addMixEngineerToAlbum(alb: strongSelf.currSong.albums![i], completion: { error in
                                completedProgress+=1
                                if let error = error {
                                    completion(error)
                                    return
                                } else {
                                    if completedProgress == totalProgress {
                                        completion(nil)
                                        return
                                    }
                                }
                            })
                        }
                    }
                }
            }
            
        })
    }
    
    func removeMixEngineerFromAlbum(alb: String, completion: @escaping ((Error?) -> Void)) {
        guard alb.count == 8 else {
            completion(nil)
            return
        }
        if let arrrry = currSong.songMixEngineer {
        DatabaseManager.shared.findAlbumById(albumId: alb, completion: {[weak self] result in
            guard let strongSelf = self else {return}
            switch result {
            case .success(let album):
                let ref = Database.database().reference().child("Music Content").child("Albums").child( "\(albumContentTag)--\(album.name)--\(album.toneDeafAppId)").child("REQUIRED").child("Engineers").child("Mix Engineer")
                var arrto:[String] = []
                var personcount = 0
                for per in arrrry {
                    var subcount = 0
                    var roleMArkedOnAnotherSong:Bool = false
                    var roleMArkedOnAnotherSongAll:Bool = false
                    if let arr2 = album.songs {
                        for song in arr2 {
                            DatabaseManager.shared.findSongById(songId: song, completion: {[weak self] result in
                                guard let strongSelf = self else {return}
                                switch result {
                                case .success(let song):
                                    subcount+=1
                                    if song.toneDeafAppId != strongSelf.currSong.toneDeafAppId {
                                        if song.songProducers.contains(per) {
                                            roleMArkedOnAnotherSongAll = true
                                        }
                                        if song.songArtist.contains(per) {
                                            roleMArkedOnAnotherSongAll = true
                                        }
                                        if let _ = song.songWriters {
                                            if song.songWriters!.contains(per) {
                                                roleMArkedOnAnotherSongAll = true
                                            }
                                        }
                                        if let _ = song.songMixEngineer {
                                            if song.songMixEngineer!.contains(per) {
                                                roleMArkedOnAnotherSongAll = true
                                                roleMArkedOnAnotherSong = true
                                            }
                                        }
                                        if let _ = song.songMasteringEngineer {
                                            if song.songMasteringEngineer!.contains(per) {
                                                roleMArkedOnAnotherSongAll = true
                                            }
                                        }
                                        if let _ = song.songRecordingEngineer {
                                            if song.songRecordingEngineer!.contains(per) {
                                                roleMArkedOnAnotherSongAll = true
                                            }
                                        }
                                    }
                                    if subcount == album.tracks.count {
                                        if roleMArkedOnAnotherSong == false {
                                            if let arrrr = album.mixEngineers {
                                                arrto = arrrr
                                                if arrto.contains(per) {
                                                    let index = arrto.firstIndex(of: per)
                                                    arrto.remove(at: index!)
                                                    arrto = arrto.sorted()
                                                }
                                            }
                                            strongSelf.removeAlbumFromPersonRole(alb: alb, per: per, cat: "Mix Engineer")
                                        } else {
                                            if let arrrr = album.mixEngineers {
                                                arrto = arrrr.sorted()
                                            }
                                        }
                                        ref.setValue(arrto, withCompletionBlock: { error, reference in
                                            if let error = error {
                                                completion(error)
                                                return
                                            }
                                            else {
                                                if roleMArkedOnAnotherSongAll == false {
                                                    strongSelf.removeAlbumFromPersonMixEngineer(alb: alb, per: per, completion: { error in
                                                        personcount+=1
                                                        if let error = error {
                                                            completion(error)
                                                            return
                                                        }
                                                        else {
                                                            if personcount == arrrry.count {
                                                                completion(nil)
                                                                return
                                                            }
                                                        }
                                                    })
                                                } else {
                                                    personcount+=1
                                                    if personcount == arrrry.count {
                                                        completion(nil)
                                                        return
                                                    }
                                                }
                                            }
                                        })
                                    }
                                case .failure(let err):
                                    print("dsvgredfxbdfzx"+err.localizedDescription)
                                }
                            })
                        }
                    }
                    if let inst = album.instrumentals {
                        for song in inst {
                            DatabaseManager.shared.findInstrumentalById(instrumentalId: song, completion: {[weak self] result in
                                guard let strongSelf = self else {return}
                                switch result {
                                case .success(let song):
                                    subcount+=1
                                    if song.toneDeafAppId != strongSelf.currSong.toneDeafAppId {
                                        
                                        if let saa = song.artist {
                                            if saa.contains(per) {
                                                roleMArkedOnAnotherSongAll = true
                                            }
                                        }
                                        if song.producers.contains(per) {
                                            roleMArkedOnAnotherSongAll = true
                                        }
                                        if let saa = song.mixEngineer {
                                            if saa.contains(per) {
                                                roleMArkedOnAnotherSong = true
                                                roleMArkedOnAnotherSongAll = true
                                            }
                                        }
                                        if let saa = song.masteringEngineer {
                                            if saa.contains(per) {
                                                roleMArkedOnAnotherSongAll = true
                                            }
                                        }
                                    }
                                    if subcount == album.tracks.count {
                                        if roleMArkedOnAnotherSong == false {
                                            if let ttt = album.mixEngineers {
                                                arrto = ttt
                                                if arrto.contains(per) {
                                                    let index = arrto.firstIndex(of: per)
                                                    arrto.remove(at: index!)
                                                    arrto = arrto.sorted()
                                                }
                                            }
                                            strongSelf.removeAlbumFromPersonRole(alb: alb, per: per, cat: "Mix Engineer")
                                        } else {
                                            if let ttt = album.mixEngineers {
                                                arrto = ttt.sorted()
                                            }
                                        }
                                        ref.setValue(arrto, withCompletionBlock: { error, reference in
                                            if let error = error {
                                                completion(error)
                                                return
                                            }
                                            else {
                                                if roleMArkedOnAnotherSongAll == false {
                                                    strongSelf.removeAlbumFromPersonMixEngineer(alb: alb, per: per, completion: { error in
                                                        personcount+=1
                                                        if let error = error {
                                                            completion(error)
                                                            return
                                                        }
                                                        else {
                                                            if personcount == arrrry.count {
                                                                completion(nil)
                                                                return
                                                            }
                                                        }
                                                    })
                                                } else {
                                                    personcount+=1
                                                    if personcount == arrrry.count {
                                                        completion(nil)
                                                        return
                                                    }
                                                }
                                            }
                                        })
                                    }
                                case .failure(let err):
                                    print("dsvgredfxbdfzx"+err.localizedDescription)
                                }
                            })
                        }
                    }
                }
                
            case .failure(let err):
                print("dsvgredfxbdfzx"+err.localizedDescription)
            }
        })
        } else {
            completion(nil)
        }
    }
    
    func addMixEngineerToAlbum(alb: String, completion: @escaping ((Error?) -> Void)) {
        guard alb.count == 8 else {
            completion(nil)
            return
        }
        
        if let arrry = currSong.songMixEngineer {
            DatabaseManager.shared.findAlbumById(albumId: alb, completion: {[weak self] result in
                guard let strongSelf = self else {return}
                switch result {
                case .success(let album):
                    let ref = Database.database().reference().child("Music Content").child("Albums").child( "\(albumContentTag)--\(album.name)--\(album.toneDeafAppId)").child("REQUIRED").child("Engineers").child("Mix Engineer")
                    var arrto:[String] = []
                    for per in arrry {
                        if var arrr = album.mixEngineers {
                            arrto = arrr
                            if !arrto.contains(per) {
                                arrto.append(per)
                            }
                            arrto.sort()
                        } else {
                            arrto = [per]
                        }
                    }
                    
                    ref.setValue(arrto, withCompletionBlock: { error, reference in
                        if let error = error {
                            completion(error)
                            return
                        }
                        else {
                            completion(nil)
                            return
                        }
                    })
                case .failure(let err):
                    print("dsvgredfxbdfzx"+err.localizedDescription)
                }
            })
        } else {
            completion(nil)
        }
    }
    
    func updateMixEngineerAlbums(ref: DatabaseReference, completion: @escaping ((Error?) -> Void)) {
        var initialArtistsArrFromDB:[String]!
        var totalProgress:Int = 0
        var completedProgress:Int = 0
        if currSong.albums!.sorted() == initSong.albums?.sorted() {
            completion(nil)
            return
        }
        
        getSongAlbumsInDB(ref: ref, completion: {[weak self] persons in
            guard let strongSelf = self else {return}
            initialArtistsArrFromDB = persons.sorted()
            
            if !initialArtistsArrFromDB.isEmpty {
                for i in 0 ... initialArtistsArrFromDB.count-1 {
                    if strongSelf.currSong.albums != nil {
                        if i < strongSelf.currSong.albums!.count {
                            if !strongSelf.currSong.albums![i].contains(initialArtistsArrFromDB[i]) {
                                if strongSelf.currSong.songMixEngineer != nil {
                                    for per in strongSelf.currSong.songMixEngineer! {
                                        //                                    totalProgress+=1
                                    }
                                }
                            }
                        } else {
                            if strongSelf.currSong.songMixEngineer != nil {
                                for per in strongSelf.currSong.songMixEngineer! {
                                    //                                totalProgress+=1
                                }
                            }
                        }
                    } else {
                        if strongSelf.currSong.songMixEngineer != nil {
                            for per in strongSelf.currSong.songMixEngineer! {
                                //                            totalProgress+=1
                            }
                        }
                    }
                }
            }
            
            if strongSelf.currSong.albums != nil {
                var counter = 0
                if !strongSelf.currSong.albums!.isEmpty {
                    for i in 0 ... strongSelf.currSong.albums!.count-1 {
                        if i < initialArtistsArrFromDB.count {
                            if !initialArtistsArrFromDB[i].contains(strongSelf.currSong.albums![i]) {
                                counter+=1
                                if counter == strongSelf.currSong.albums!.count {
                                    if strongSelf.currSong.songMixEngineer != nil {
                                        for per in strongSelf.currSong.songMixEngineer! {
                                            totalProgress+=1
                                        }
                                    }
                                }
                            }
                        } else {
                            counter+=1
                            if counter == strongSelf.currSong.albums!.count {
                                if strongSelf.currSong.songMixEngineer != nil {
                                    for per in strongSelf.currSong.songMixEngineer! {
                                        totalProgress+=1
                                    }
                                }
                            }
                        }
                    }
                }
            }
            
            
            if totalProgress == 0 {
                completion(nil)
            }
            
//            if !initialArtistsArrFromDB.isEmpty {
//                for i in 0 ... initialArtistsArrFromDB.count-1 {
//                    if strongSelf.currSong.albums != nil {
//                        if i < strongSelf.currSong.albums!.count {
//                            if !strongSelf.currSong.albums![i].contains(initialArtistsArrFromDB[i]) {
//                                for per in strongSelf.currSong.songArtist {
//                                    strongSelf.removeAlbumFromPersonArtist(alb: initialArtistsArrFromDB[i], per: per, completion: { error in
//                                        completedProgress+=1
//                                        if let error = error {
//                                            completion(error)
//                                            return
//                                        } else {
//                                            if completedProgress == totalProgress {
//                                                completion(nil)
//                                                return
//                                            }
//                                        }
//                                    })
//                                }
//                            }
//                        } else {
//                            for per in strongSelf.currSong.songArtist {
//                                strongSelf.removeAlbumFromPersonArtist(alb: initialArtistsArrFromDB[i], per: per, completion: { error in
//                                    completedProgress+=1
//                                    if let error = error {
//                                        completion(error)
//                                        return
//                                    } else {
//                                        if completedProgress == totalProgress {
//                                            completion(nil)
//                                            return
//                                        }
//                                    }
//                                })
//                            }
//                        }
//                    } else {
//                        for per in strongSelf.currSong.songArtist {
//                            strongSelf.removeAlbumFromPersonArtist(alb: initialArtistsArrFromDB[i], per: per, completion: { error in
//                                completedProgress+=1
//                                if let error = error {
//                                    completion(error)
//                                    return
//                                } else {
//                                    if completedProgress == totalProgress {
//                                        completion(nil)
//                                        return
//                                    }
//                                }
//                            })
//                        }
//                    }
//                }
//            }
            var counter = 0
            var arrayToAdd:[String] = []
            if strongSelf.currSong.albums != nil {
                if !strongSelf.currSong.albums!.isEmpty {
                    for i in 0 ... strongSelf.currSong.albums!.count-1 {
                        if i < initialArtistsArrFromDB.count {
                            if !initialArtistsArrFromDB[i].contains(strongSelf.currSong.albums![i]) {
                                arrayToAdd.append(strongSelf.currSong.albums![i])
                                counter+=1
                                if counter == strongSelf.currSong.albums!.count {
                                    if strongSelf.currSong.songMixEngineer != nil {
                                        for per in strongSelf.currSong.songMixEngineer! {
                                            strongSelf.addAlbumToPersonMixEngineer(alb: arrayToAdd, per: per, completion: { error in
                                                completedProgress+=1
                                                if let error = error {
                                                    completion(error)
                                                    return
                                                } else {
                                                    if completedProgress == totalProgress {
                                                        completion(nil)
                                                        return
                                                    }
                                                }
                                            })
                                        }
                                    }
                                }
                            }
                        } else {
                            arrayToAdd.append(strongSelf.currSong.albums![i])
                            counter+=1
                            if counter == strongSelf.currSong.albums!.count {
                                if strongSelf.currSong.songMixEngineer != nil {
                                    for per in strongSelf.currSong.songMixEngineer! {
                                        strongSelf.addAlbumToPersonMixEngineer(alb: arrayToAdd, per: per, completion: { error in
                                            completedProgress+=1
                                            if let error = error {
                                                completion(error)
                                                return
                                            } else {
                                                if completedProgress == totalProgress {
                                                    completion(nil)
                                                    return
                                                }
                                            }
                                        })
                                    }
                                }
                            }
                        }
                    }
                }
            }
            
        })
    }
    
    func updateAlbumsMasteringEngineers(ref: DatabaseReference, completion: @escaping ((Error?) -> Void)) {
        var initialArtistsArrFromDB:[String]!
        var totalProgress:Int = 0
        var completedProgress:Int = 0
        if currSong.albums!.sorted() == initSong.albums?.sorted() {
            completion(nil)
            return
        }
        
        getSongAlbumsInDB(ref: ref, completion: {[weak self] persons in
            guard let strongSelf = self else {return}
            initialArtistsArrFromDB = persons.sorted()
            
            if !initialArtistsArrFromDB.isEmpty {
                for i in 0 ... initialArtistsArrFromDB.count-1 {
                    if strongSelf.currSong.albums != nil {
                        if i < strongSelf.currSong.albums!.count {
                            if !strongSelf.currSong.albums![i].contains(initialArtistsArrFromDB[i]) {
                                totalProgress+=1
                            }
                        } else {
                            totalProgress+=1
                        }
                    } else {
                        totalProgress+=1
                    }
                }
            }
            
            if strongSelf.currSong.albums != nil {
                if !strongSelf.currSong.albums!.isEmpty {
                    for i in 0 ... strongSelf.currSong.albums!.count-1 {
                        if i < initialArtistsArrFromDB.count {
                            if !initialArtistsArrFromDB[i].contains(strongSelf.currSong.albums![i]) {
                                totalProgress+=1
                            }
                        } else {
                            totalProgress+=1
                        }
                    }
                }
            }
            
            if totalProgress == 0 {
                completion(nil)
            }
            
            if !initialArtistsArrFromDB.isEmpty {
                for i in 0 ... initialArtistsArrFromDB.count-1 {
                    if strongSelf.currSong.albums != nil {
                        if i < strongSelf.currSong.albums!.count {
                            if !strongSelf.currSong.albums![i].contains(initialArtistsArrFromDB[i]) {
                                strongSelf.removeMasteringEngineerFromAlbum(alb: initialArtistsArrFromDB[i], completion: { error in
                                    completedProgress+=1
                                    if let error = error {
                                        completion(error)
                                        return
                                    } else {
                                        if completedProgress == totalProgress {
                                            completion(nil)
                                            return
                                        }
                                    }
                                })
                            }
                        } else {
                            strongSelf.removeMasteringEngineerFromAlbum(alb: initialArtistsArrFromDB[i], completion: { error in
                                completedProgress+=1
                                if let error = error {
                                    completion(error)
                                    return
                                } else {
                                    if completedProgress == totalProgress {
                                        completion(nil)
                                        return
                                    }
                                }
                            })
                        }
                    } else {
                        strongSelf.removeMasteringEngineerFromAlbum(alb: initialArtistsArrFromDB[i], completion: { error in
                            completedProgress+=1
                            if let error = error {
                                completion(error)
                                return
                            } else {
                                if completedProgress == totalProgress {
                                    completion(nil)
                                    return
                                }
                            }
                        })
                    }
                }
            }
            
            if strongSelf.currSong.albums != nil {
                if !strongSelf.currSong.albums!.isEmpty {
                    for i in 0 ... strongSelf.currSong.albums!.count-1 {
                        if i < initialArtistsArrFromDB.count {
                            if !initialArtistsArrFromDB[i].contains(strongSelf.currSong.albums![i]) {
                                strongSelf.addMasteringEngineerToAlbum(alb: strongSelf.currSong.albums![i], completion: { error in
                                    completedProgress+=1
                                    if let error = error {
                                        completion(error)
                                        return
                                    } else {
                                        if completedProgress == totalProgress {
                                            completion(nil)
                                            return
                                        }
                                    }
                                })
                            }
                        } else {
                            strongSelf.addMasteringEngineerToAlbum(alb: strongSelf.currSong.albums![i], completion: { error in
                                completedProgress+=1
                                if let error = error {
                                    completion(error)
                                    return
                                } else {
                                    if completedProgress == totalProgress {
                                        completion(nil)
                                        return
                                    }
                                }
                            })
                        }
                    }
                }
            }
            
        })
    }
    
    func removeMasteringEngineerFromAlbum(alb: String, completion: @escaping ((Error?) -> Void)) {
        guard alb.count == 8 else {
            completion(nil)
            return
        }
        if let arrrry = currSong.songMasteringEngineer {
        DatabaseManager.shared.findAlbumById(albumId: alb, completion: {[weak self] result in
            guard let strongSelf = self else {return}
            switch result {
            case .success(let album):
                let ref = Database.database().reference().child("Music Content").child("Albums").child( "\(albumContentTag)--\(album.name)--\(album.toneDeafAppId)").child("REQUIRED").child("Engineers").child("Mastering Engineer")
                var arrto:[String] = []
                var personcount = 0
                for per in arrrry {
                    var subcount = 0
                    var roleMArkedOnAnotherSong:Bool = false
                    var roleMArkedOnAnotherSongAll:Bool = false
                    if let arr2 = album.songs {
                        for song in arr2 {
                            DatabaseManager.shared.findSongById(songId: song, completion: {[weak self] result in
                                guard let strongSelf = self else {return}
                                switch result {
                                case .success(let song):
                                    subcount+=1
                                    if song.toneDeafAppId != strongSelf.currSong.toneDeafAppId {
                                        if song.songProducers.contains(per) {
                                            roleMArkedOnAnotherSongAll = true
                                        }
                                        if song.songArtist.contains(per) {
                                            roleMArkedOnAnotherSongAll = true
                                        }
                                        if let _ = song.songWriters {
                                            if song.songWriters!.contains(per) {
                                                roleMArkedOnAnotherSongAll = true
                                            }
                                        }
                                        if let _ = song.songMixEngineer {
                                            if song.songMixEngineer!.contains(per) {
                                                roleMArkedOnAnotherSongAll = true
                                            }
                                        }
                                        if let _ = song.songMasteringEngineer {
                                            if song.songMasteringEngineer!.contains(per) {
                                                roleMArkedOnAnotherSongAll = true
                                                roleMArkedOnAnotherSong = true
                                            }
                                        }
                                        if let _ = song.songRecordingEngineer {
                                            if song.songRecordingEngineer!.contains(per) {
                                                roleMArkedOnAnotherSongAll = true
                                            }
                                        }
                                    }
                                    if subcount == album.tracks.count {
                                        if roleMArkedOnAnotherSong == false {
                                            if let arrrr = album.masteringEngineers {
                                                arrto = arrrr
                                                if arrto.contains(per) {
                                                    let index = arrto.firstIndex(of: per)
                                                    arrto.remove(at: index!)
                                                    arrto = arrto.sorted()
                                                }
                                            }
                                            strongSelf.removeAlbumFromPersonRole(alb: alb, per: per, cat: "Mastering Engineer")
                                        } else {
                                            if let arrrr = album.masteringEngineers {
                                                arrto = arrrr.sorted()
                                            }
                                        }
                                        ref.setValue(arrto, withCompletionBlock: { error, reference in
                                            if let error = error {
                                                completion(error)
                                                return
                                            }
                                            else {
                                                if roleMArkedOnAnotherSongAll == false {
                                                    strongSelf.removeAlbumFromPersonMasteringEngineer(alb: alb, per: per, completion: { error in
                                                        personcount+=1
                                                        if let error = error {
                                                            completion(error)
                                                            return
                                                        }
                                                        else {
                                                            if personcount == arrrry.count {
                                                                completion(nil)
                                                                return
                                                            }
                                                        }
                                                    })
                                                } else {
                                                    personcount+=1
                                                    if personcount == arrrry.count {
                                                        completion(nil)
                                                        return
                                                    }
                                                }
                                            }
                                        })
                                    }
                                case .failure(let err):
                                    print("dsvgredfxbdfzx"+err.localizedDescription)
                                }
                            })
                        }
                    }
                    if let inst = album.instrumentals {
                        for song in inst {
                            DatabaseManager.shared.findInstrumentalById(instrumentalId: song, completion: {[weak self] result in
                                guard let strongSelf = self else {return}
                                switch result {
                                case .success(let song):
                                    subcount+=1
                                    if song.toneDeafAppId != strongSelf.currSong.toneDeafAppId {
                                        
                                        if let saa = song.artist {
                                            if saa.contains(per) {
                                                roleMArkedOnAnotherSongAll = true
                                            }
                                        }
                                        if song.producers.contains(per) {
                                            roleMArkedOnAnotherSongAll = true
                                        }
                                        if let saa = song.mixEngineer {
                                            if saa.contains(per) {
                                                roleMArkedOnAnotherSongAll = true
                                            }
                                        }
                                        if let saa = song.masteringEngineer {
                                            if saa.contains(per) {
                                                roleMArkedOnAnotherSong = true
                                                roleMArkedOnAnotherSongAll = true
                                            }
                                        }
                                    }
                                    if subcount == album.tracks.count {
                                        if roleMArkedOnAnotherSong == false {
                                            if let ttt = album.masteringEngineers {
                                                arrto = ttt
                                                if arrto.contains(per) {
                                                    let index = arrto.firstIndex(of: per)
                                                    arrto.remove(at: index!)
                                                    arrto = arrto.sorted()
                                                }
                                            }
                                            strongSelf.removeAlbumFromPersonRole(alb: alb, per: per, cat: "Mastering Engineer")
                                        } else {
                                            if let ttt = album.masteringEngineers {
                                                arrto = ttt.sorted()
                                            }
                                        }
                                        ref.setValue(arrto, withCompletionBlock: { error, reference in
                                            if let error = error {
                                                completion(error)
                                                return
                                            }
                                            else {
                                                if roleMArkedOnAnotherSongAll == false {
                                                    strongSelf.removeAlbumFromPersonMasteringEngineer(alb: alb, per: per, completion: { error in
                                                        personcount+=1
                                                        if let error = error {
                                                            completion(error)
                                                            return
                                                        }
                                                        else {
                                                            if personcount == arrrry.count {
                                                                completion(nil)
                                                                return
                                                            }
                                                        }
                                                    })
                                                } else {
                                                    personcount+=1
                                                    if personcount == arrrry.count {
                                                        completion(nil)
                                                        return
                                                    }
                                                }
                                            }
                                        })
                                    }
                                case .failure(let err):
                                    print("dsvgredfxbdfzx"+err.localizedDescription)
                                }
                            })
                        }
                    }
                }
                
            case .failure(let err):
                print("dsvgredfxbdfzx"+err.localizedDescription)
            }
        })
        } else {
            completion(nil)
        }
    }
    
    func addMasteringEngineerToAlbum(alb: String, completion: @escaping ((Error?) -> Void)) {
        guard alb.count == 8 else {
            completion(nil)
            return
        }
        
        if let arrry = currSong.songMasteringEngineer {
            DatabaseManager.shared.findAlbumById(albumId: alb, completion: {[weak self] result in
                guard let strongSelf = self else {return}
                switch result {
                case .success(let album):
                    let ref = Database.database().reference().child("Music Content").child("Albums").child( "\(albumContentTag)--\(album.name)--\(album.toneDeafAppId)").child("REQUIRED").child("Engineers").child("Mastering Engineer")
                    var arrto:[String] = []
                    for per in arrry {
                        if var arrr = album.masteringEngineers {
                            arrto = arrr
                            if !arrto.contains(per) {
                                arrto.append(per)
                            }
                            arrto.sort()
                        } else {
                            arrto = [per]
                        }
                    }
                    
                    ref.setValue(arrto, withCompletionBlock: { error, reference in
                        if let error = error {
                            completion(error)
                            return
                        }
                        else {
                            completion(nil)
                            return
                        }
                    })
                case .failure(let err):
                    print("dsvgredfxbdfzx"+err.localizedDescription)
                }
            })
        } else {
            completion(nil)
        }
    }
    
    func updateMasteringEngineerAlbums(ref: DatabaseReference, completion: @escaping ((Error?) -> Void)) {
        var initialArtistsArrFromDB:[String]!
        var totalProgress:Int = 0
        var completedProgress:Int = 0
        if currSong.albums!.sorted() == initSong.albums?.sorted() {
            completion(nil)
            return
        }
        
        getSongAlbumsInDB(ref: ref, completion: {[weak self] persons in
            guard let strongSelf = self else {return}
            initialArtistsArrFromDB = persons.sorted()
            
            if !initialArtistsArrFromDB.isEmpty {
                for i in 0 ... initialArtistsArrFromDB.count-1 {
                    if strongSelf.currSong.albums != nil {
                        if i < strongSelf.currSong.albums!.count {
                            if !strongSelf.currSong.albums![i].contains(initialArtistsArrFromDB[i]) {
                                if strongSelf.currSong.songMasteringEngineer != nil {
                                    for per in strongSelf.currSong.songMasteringEngineer! {
                                        //                                    totalProgress+=1
                                    }
                                }
                            }
                        } else {
                            if strongSelf.currSong.songMasteringEngineer != nil {
                                for per in strongSelf.currSong.songMasteringEngineer! {
                                    //                                totalProgress+=1
                                }
                            }
                        }
                    } else {
                        if strongSelf.currSong.songMasteringEngineer != nil {
                            for per in strongSelf.currSong.songMasteringEngineer! {
                                //                            totalProgress+=1
                            }
                        }
                    }
                }
            }
            
            if strongSelf.currSong.albums != nil {
                var counter = 0
                if !strongSelf.currSong.albums!.isEmpty {
                    for i in 0 ... strongSelf.currSong.albums!.count-1 {
                        if i < initialArtistsArrFromDB.count {
                            if !initialArtistsArrFromDB[i].contains(strongSelf.currSong.albums![i]) {
                                counter+=1
                                if counter == strongSelf.currSong.albums!.count {
                                    if strongSelf.currSong.songMasteringEngineer != nil {
                                        for per in strongSelf.currSong.songMasteringEngineer! {
                                            totalProgress+=1
                                        }
                                    }
                                }
                            }
                        } else {
                            counter+=1
                            if counter == strongSelf.currSong.albums!.count {
                                if strongSelf.currSong.songMasteringEngineer != nil {
                                    for per in strongSelf.currSong.songMasteringEngineer! {
                                        totalProgress+=1
                                    }
                                }
                            }
                        }
                    }
                }
            }
            
            
            if totalProgress == 0 {
                completion(nil)
            }
            
//            if !initialArtistsArrFromDB.isEmpty {
//                for i in 0 ... initialArtistsArrFromDB.count-1 {
//                    if strongSelf.currSong.albums != nil {
//                        if i < strongSelf.currSong.albums!.count {
//                            if !strongSelf.currSong.albums![i].contains(initialArtistsArrFromDB[i]) {
//                                for per in strongSelf.currSong.songArtist {
//                                    strongSelf.removeAlbumFromPersonArtist(alb: initialArtistsArrFromDB[i], per: per, completion: { error in
//                                        completedProgress+=1
//                                        if let error = error {
//                                            completion(error)
//                                            return
//                                        } else {
//                                            if completedProgress == totalProgress {
//                                                completion(nil)
//                                                return
//                                            }
//                                        }
//                                    })
//                                }
//                            }
//                        } else {
//                            for per in strongSelf.currSong.songArtist {
//                                strongSelf.removeAlbumFromPersonArtist(alb: initialArtistsArrFromDB[i], per: per, completion: { error in
//                                    completedProgress+=1
//                                    if let error = error {
//                                        completion(error)
//                                        return
//                                    } else {
//                                        if completedProgress == totalProgress {
//                                            completion(nil)
//                                            return
//                                        }
//                                    }
//                                })
//                            }
//                        }
//                    } else {
//                        for per in strongSelf.currSong.songArtist {
//                            strongSelf.removeAlbumFromPersonArtist(alb: initialArtistsArrFromDB[i], per: per, completion: { error in
//                                completedProgress+=1
//                                if let error = error {
//                                    completion(error)
//                                    return
//                                } else {
//                                    if completedProgress == totalProgress {
//                                        completion(nil)
//                                        return
//                                    }
//                                }
//                            })
//                        }
//                    }
//                }
//            }
            var counter = 0
            var arrayToAdd:[String] = []
            if strongSelf.currSong.albums != nil {
                if !strongSelf.currSong.albums!.isEmpty {
                    for i in 0 ... strongSelf.currSong.albums!.count-1 {
                        if i < initialArtistsArrFromDB.count {
                            if !initialArtistsArrFromDB[i].contains(strongSelf.currSong.albums![i]) {
                                arrayToAdd.append(strongSelf.currSong.albums![i])
                                counter+=1
                                if counter == strongSelf.currSong.albums!.count {
                                    if strongSelf.currSong.songMasteringEngineer != nil {
                                        for per in strongSelf.currSong.songMasteringEngineer! {
                                            strongSelf.addAlbumToPersonMasteringEngineer(alb: arrayToAdd, per: per, completion: { error in
                                                completedProgress+=1
                                                if let error = error {
                                                    completion(error)
                                                    return
                                                } else {
                                                    if completedProgress == totalProgress {
                                                        completion(nil)
                                                        return
                                                    }
                                                }
                                            })
                                        }
                                    }
                                }
                            }
                        } else {
                            arrayToAdd.append(strongSelf.currSong.albums![i])
                            counter+=1
                            if counter == strongSelf.currSong.albums!.count {
                                if strongSelf.currSong.songMasteringEngineer != nil {
                                    for per in strongSelf.currSong.songMasteringEngineer! {
                                        strongSelf.addAlbumToPersonMasteringEngineer(alb: arrayToAdd, per: per, completion: { error in
                                            completedProgress+=1
                                            if let error = error {
                                                completion(error)
                                                return
                                            } else {
                                                if completedProgress == totalProgress {
                                                    completion(nil)
                                                    return
                                                }
                                            }
                                        })
                                    }
                                }
                            }
                        }
                    }
                }
            }
            
        })
    }
    
    func updateAlbumsRecordingEngineers(ref: DatabaseReference, completion: @escaping ((Error?) -> Void)) {
        var initialArtistsArrFromDB:[String]!
        var totalProgress:Int = 0
        var completedProgress:Int = 0
        if currSong.albums!.sorted() == initSong.albums?.sorted() {
            completion(nil)
            return
        }
        
        getSongAlbumsInDB(ref: ref, completion: {[weak self] persons in
            guard let strongSelf = self else {return}
            initialArtistsArrFromDB = persons.sorted()
            
            if !initialArtistsArrFromDB.isEmpty {
                for i in 0 ... initialArtistsArrFromDB.count-1 {
                    if strongSelf.currSong.albums != nil {
                        if i < strongSelf.currSong.albums!.count {
                            if !strongSelf.currSong.albums![i].contains(initialArtistsArrFromDB[i]) {
                                totalProgress+=1
                            }
                        } else {
                            totalProgress+=1
                        }
                    } else {
                        totalProgress+=1
                    }
                }
            }
            
            if strongSelf.currSong.albums != nil {
                if !strongSelf.currSong.albums!.isEmpty {
                    for i in 0 ... strongSelf.currSong.albums!.count-1 {
                        if i < initialArtistsArrFromDB.count {
                            if !initialArtistsArrFromDB[i].contains(strongSelf.currSong.albums![i]) {
                                totalProgress+=1
                            }
                        } else {
                            totalProgress+=1
                        }
                    }
                }
            }
            
            if totalProgress == 0 {
                completion(nil)
            }
            
            if !initialArtistsArrFromDB.isEmpty {
                for i in 0 ... initialArtistsArrFromDB.count-1 {
                    if strongSelf.currSong.albums != nil {
                        if i < strongSelf.currSong.albums!.count {
                            if !strongSelf.currSong.albums![i].contains(initialArtistsArrFromDB[i]) {
                                strongSelf.removeRecordingEngineerFromAlbum(alb: initialArtistsArrFromDB[i], completion: { error in
                                    completedProgress+=1
                                    if let error = error {
                                        completion(error)
                                        return
                                    } else {
                                        if completedProgress == totalProgress {
                                            completion(nil)
                                            return
                                        }
                                    }
                                })
                            }
                        } else {
                            strongSelf.removeRecordingEngineerFromAlbum(alb: initialArtistsArrFromDB[i], completion: { error in
                                completedProgress+=1
                                if let error = error {
                                    completion(error)
                                    return
                                } else {
                                    if completedProgress == totalProgress {
                                        completion(nil)
                                        return
                                    }
                                }
                            })
                        }
                    } else {
                        strongSelf.removeRecordingEngineerFromAlbum(alb: initialArtistsArrFromDB[i], completion: { error in
                            completedProgress+=1
                            if let error = error {
                                completion(error)
                                return
                            } else {
                                if completedProgress == totalProgress {
                                    completion(nil)
                                    return
                                }
                            }
                        })
                    }
                }
            }
            
            
            if strongSelf.currSong.albums != nil {
                if !strongSelf.currSong.albums!.isEmpty {
                    for i in 0 ... strongSelf.currSong.albums!.count-1 {
                        if i < initialArtistsArrFromDB.count {
                            if !initialArtistsArrFromDB[i].contains(strongSelf.currSong.albums![i]) {
                                strongSelf.addRecordingEngineerToAlbum(alb: strongSelf.currSong.albums![i], completion: { error in
                                    completedProgress+=1
                                    if let error = error {
                                        completion(error)
                                        return
                                    } else {
                                        if completedProgress == totalProgress {
                                            completion(nil)
                                            return
                                        }
                                    }
                                })
                            }
                        } else {
                            strongSelf.addRecordingEngineerToAlbum(alb: strongSelf.currSong.albums![i], completion: { error in
                                completedProgress+=1
                                if let error = error {
                                    completion(error)
                                    return
                                } else {
                                    if completedProgress == totalProgress {
                                        completion(nil)
                                        return
                                    }
                                }
                            })
                        }
                    }
                }
            }
            
        })
    }
    
    func removeRecordingEngineerFromAlbum(alb: String, completion: @escaping ((Error?) -> Void)) {
        guard alb.count == 8 else {
            completion(nil)
            return
        }
        if let arrrry = currSong.songRecordingEngineer {
        DatabaseManager.shared.findAlbumById(albumId: alb, completion: {[weak self] result in
            guard let strongSelf = self else {return}
            switch result {
            case .success(let album):
                let ref = Database.database().reference().child("Music Content").child("Albums").child( "\(albumContentTag)--\(album.name)--\(album.toneDeafAppId)").child("REQUIRED").child("Engineers").child("Recording Engineer")
                var arrto:[String] = []
                var personcount = 0
                for per in arrrry {
                    var subcount = 0
                    var roleMArkedOnAnotherSong:Bool = false
                    var roleMArkedOnAnotherSongAll:Bool = false
                    if let arr2 = album.songs {
                        for song in arr2 {
                            DatabaseManager.shared.findSongById(songId: song, completion: {[weak self] result in
                                guard let strongSelf = self else {return}
                                switch result {
                                case .success(let song):
                                    subcount+=1
                                    if song.toneDeafAppId != strongSelf.currSong.toneDeafAppId {
                                        if song.songProducers.contains(per) {
                                            roleMArkedOnAnotherSongAll = true
                                        }
                                        if song.songArtist.contains(per) {
                                            roleMArkedOnAnotherSongAll = true
                                        }
                                        if let _ = song.songWriters {
                                            if song.songWriters!.contains(per) {
                                                roleMArkedOnAnotherSongAll = true
                                            }
                                        }
                                        if let _ = song.songMixEngineer {
                                            if song.songMixEngineer!.contains(per) {
                                                roleMArkedOnAnotherSongAll = true
                                            }
                                        }
                                        if let _ = song.songMasteringEngineer {
                                            if song.songMasteringEngineer!.contains(per) {
                                                roleMArkedOnAnotherSongAll = true
                                            }
                                        }
                                        if let _ = song.songRecordingEngineer {
                                            if song.songRecordingEngineer!.contains(per) {
                                                roleMArkedOnAnotherSongAll = true
                                                roleMArkedOnAnotherSong = true
                                            }
                                        }
                                    }
                                    if subcount == album.tracks.count {
                                        if roleMArkedOnAnotherSong == false {
                                            if let arrrr = album.recordingEngineers {
                                                arrto = arrrr
                                                if arrto.contains(per) {
                                                    let index = arrto.firstIndex(of: per)
                                                    arrto.remove(at: index!)
                                                    arrto = arrto.sorted()
                                                }
                                            }
                                            strongSelf.removeAlbumFromPersonRole(alb: alb, per: per, cat: "Recording Engineer")
                                        } else {
                                            if let arrrr = album.recordingEngineers {
                                                arrto = arrrr.sorted()
                                            }
                                        }
                                        ref.setValue(arrto, withCompletionBlock: { error, reference in
                                            if let error = error {
                                                completion(error)
                                                return
                                            }
                                            else {
                                                if roleMArkedOnAnotherSongAll == false {
                                                    strongSelf.removeAlbumFromPersonRecordingEngineer(alb: alb, per: per, completion: { error in
                                                        personcount+=1
                                                        if let error = error {
                                                            completion(error)
                                                            return
                                                        }
                                                        else {
                                                            if personcount == arrrry.count {
                                                                completion(nil)
                                                                return
                                                            }
                                                        }
                                                    })
                                                } else {
                                                    personcount+=1
                                                    if personcount == arrrry.count {
                                                        completion(nil)
                                                        return
                                                    }
                                                }
                                            }
                                        })
                                    }
                                case .failure(let err):
                                    print("dsvgredfxbdfzx"+err.localizedDescription)
                                }
                            })
                        }
                    }
                    if let inst = album.instrumentals {
                        for song in inst {
                            DatabaseManager.shared.findInstrumentalById(instrumentalId: song, completion: {[weak self] result in
                                guard let strongSelf = self else {return}
                                switch result {
                                case .success(let song):
                                    subcount+=1
                                    
                                    if let saa = song.artist {
                                        if saa.contains(per) {
                                            roleMArkedOnAnotherSongAll = true
                                        }
                                    }
                                    if song.producers.contains(per) {
                                        roleMArkedOnAnotherSongAll = true
                                    }
                                    if let saa = song.mixEngineer {
                                        if saa.contains(per) {
                                            roleMArkedOnAnotherSongAll = true
                                        }
                                    }
                                    if let saa = song.masteringEngineer {
                                        if saa.contains(per) {
                                            roleMArkedOnAnotherSongAll = true
                                        }
                                    }
                                    if subcount == album.tracks.count {
                                        if roleMArkedOnAnotherSong == false {
                                            if let ttt = album.recordingEngineers {
                                                arrto = ttt
                                                if arrto.contains(per) {
                                                    let index = arrto.firstIndex(of: per)
                                                    arrto.remove(at: index!)
                                                    arrto = arrto.sorted()
                                                }
                                            }
                                            strongSelf.removeAlbumFromPersonRole(alb: alb, per: per, cat: "Recording Engineer")
                                        } else {
                                            if let ttt = album.recordingEngineers {
                                                arrto = ttt.sorted()
                                            }
                                        }
                                        ref.setValue(arrto, withCompletionBlock: { error, reference in
                                            if let error = error {
                                                completion(error)
                                                return
                                            }
                                            else {
                                                if roleMArkedOnAnotherSongAll == false {
                                                    strongSelf.removeAlbumFromPersonRecordingEngineer(alb: alb, per: per, completion: { error in
                                                        personcount+=1
                                                        if let error = error {
                                                            completion(error)
                                                            return
                                                        }
                                                        else {
                                                            if personcount == arrrry.count {
                                                                completion(nil)
                                                                return
                                                            }
                                                        }
                                                    })
                                                } else {
                                                    personcount+=1
                                                    if personcount == arrrry.count {
                                                        completion(nil)
                                                        return
                                                    }
                                                }
                                            }
                                        })
                                    }
                                case .failure(let err):
                                    print("dsvgredfxbdfzx"+err.localizedDescription)
                                }
                            })
                        }
                    }
                }
                
            case .failure(let err):
                print("dsvgredfxbdfzx"+err.localizedDescription)
            }
        })
        } else {
            completion(nil)
        }
    }
    
    func addRecordingEngineerToAlbum(alb: String, completion: @escaping ((Error?) -> Void)) {
        guard alb.count == 8 else {
            completion(nil)
            return
        }
        
        if let arrry = currSong.songRecordingEngineer {
            DatabaseManager.shared.findAlbumById(albumId: alb, completion: {[weak self] result in
                guard let strongSelf = self else {return}
                switch result {
                case .success(let album):
                    let ref = Database.database().reference().child("Music Content").child("Albums").child( "\(albumContentTag)--\(album.name)--\(album.toneDeafAppId)").child("REQUIRED").child("Engineers").child("Recording Engineer")
                    var arrto:[String] = []
                    for per in arrry {
                        if var arrr = album.recordingEngineers {
                            arrto = arrr
                            if !arrto.contains(per) {
                                arrto.append(per)
                            }
                            arrto.sort()
                        } else {
                            arrto = [per]
                        }
                    }
                    
                    ref.setValue(arrto, withCompletionBlock: { error, reference in
                        if let error = error {
                            completion(error)
                            return
                        }
                        else {
                            completion(nil)
                            return
                        }
                    })
                case .failure(let err):
                    print("dsvgredfxbdfzx"+err.localizedDescription)
                }
            })
        } else {
            completion(nil)
        }
    }
    
    func updateRecordingEngineerAlbums(ref: DatabaseReference, completion: @escaping ((Error?) -> Void)) {
        var initialArtistsArrFromDB:[String]!
        var totalProgress:Int = 0
        var completedProgress:Int = 0
        if currSong.albums!.sorted() == initSong.albums?.sorted() {
            completion(nil)
            return
        }
        
        getSongAlbumsInDB(ref: ref, completion: {[weak self] persons in
            guard let strongSelf = self else {return}
            initialArtistsArrFromDB = persons.sorted()
            
            if !initialArtistsArrFromDB.isEmpty {
                for i in 0 ... initialArtistsArrFromDB.count-1 {
                    if strongSelf.currSong.albums != nil {
                        if i < strongSelf.currSong.albums!.count {
                            if !strongSelf.currSong.albums![i].contains(initialArtistsArrFromDB[i]) {
                                if strongSelf.currSong.songRecordingEngineer != nil {
                                    for per in strongSelf.currSong.songRecordingEngineer! {
                                        //                                    totalProgress+=1
                                    }
                                }
                            }
                        } else {
                            if strongSelf.currSong.songRecordingEngineer != nil {
                                for per in strongSelf.currSong.songRecordingEngineer! {
                                    //                                totalProgress+=1
                                }
                            }
                        }
                    } else {
                        if strongSelf.currSong.songRecordingEngineer != nil {
                            for per in strongSelf.currSong.songRecordingEngineer! {
                                //                            totalProgress+=1
                            }
                        }
                    }
                }
            }
            
            if strongSelf.currSong.albums != nil {
                var counter = 0
                if !strongSelf.currSong.albums!.isEmpty {
                    for i in 0 ... strongSelf.currSong.albums!.count-1 {
                        if i < initialArtistsArrFromDB.count {
                            if !initialArtistsArrFromDB[i].contains(strongSelf.currSong.albums![i]) {
                                counter+=1
                                if counter == strongSelf.currSong.albums!.count {
                                    if strongSelf.currSong.songRecordingEngineer != nil {
                                        for per in strongSelf.currSong.songRecordingEngineer! {
                                            totalProgress+=1
                                        }
                                    }
                                }
                            }
                        } else {
                            counter+=1
                            if counter == strongSelf.currSong.albums!.count {
                                if strongSelf.currSong.songRecordingEngineer != nil {
                                    for per in strongSelf.currSong.songRecordingEngineer! {
                                        totalProgress+=1
                                    }
                                }
                            }
                        }
                    }
                }
            }
            
            
            if totalProgress == 0 {
                completion(nil)
            }
            
//            if !initialArtistsArrFromDB.isEmpty {
//                for i in 0 ... initialArtistsArrFromDB.count-1 {
//                    if strongSelf.currSong.albums != nil {
//                        if i < strongSelf.currSong.albums!.count {
//                            if !strongSelf.currSong.albums![i].contains(initialArtistsArrFromDB[i]) {
//                                for per in strongSelf.currSong.songArtist {
//                                    strongSelf.removeAlbumFromPersonArtist(alb: initialArtistsArrFromDB[i], per: per, completion: { error in
//                                        completedProgress+=1
//                                        if let error = error {
//                                            completion(error)
//                                            return
//                                        } else {
//                                            if completedProgress == totalProgress {
//                                                completion(nil)
//                                                return
//                                            }
//                                        }
//                                    })
//                                }
//                            }
//                        } else {
//                            for per in strongSelf.currSong.songArtist {
//                                strongSelf.removeAlbumFromPersonArtist(alb: initialArtistsArrFromDB[i], per: per, completion: { error in
//                                    completedProgress+=1
//                                    if let error = error {
//                                        completion(error)
//                                        return
//                                    } else {
//                                        if completedProgress == totalProgress {
//                                            completion(nil)
//                                            return
//                                        }
//                                    }
//                                })
//                            }
//                        }
//                    } else {
//                        for per in strongSelf.currSong.songArtist {
//                            strongSelf.removeAlbumFromPersonArtist(alb: initialArtistsArrFromDB[i], per: per, completion: { error in
//                                completedProgress+=1
//                                if let error = error {
//                                    completion(error)
//                                    return
//                                } else {
//                                    if completedProgress == totalProgress {
//                                        completion(nil)
//                                        return
//                                    }
//                                }
//                            })
//                        }
//                    }
//                }
//            }
            var counter = 0
            var arrayToAdd:[String] = []
            if strongSelf.currSong.albums != nil {
                if !strongSelf.currSong.albums!.isEmpty {
                    for i in 0 ... strongSelf.currSong.albums!.count-1 {
                        if i < initialArtistsArrFromDB.count {
                            if !initialArtistsArrFromDB[i].contains(strongSelf.currSong.albums![i]) {
                                arrayToAdd.append(strongSelf.currSong.albums![i])
                                counter+=1
                                if counter == strongSelf.currSong.albums!.count {
                                    if strongSelf.currSong.songRecordingEngineer != nil {
                                        for per in strongSelf.currSong.songRecordingEngineer! {
                                            strongSelf.addAlbumToPersonRecordingEngineer(alb: arrayToAdd, per: per, completion: { error in
                                                completedProgress+=1
                                                if let error = error {
                                                    completion(error)
                                                    return
                                                } else {
                                                    if completedProgress == totalProgress {
                                                        completion(nil)
                                                        return
                                                    }
                                                }
                                            })
                                        }
                                    }
                                }
                            }
                        } else {
                            arrayToAdd.append(strongSelf.currSong.albums![i])
                            counter+=1
                            if counter == strongSelf.currSong.albums!.count {
                                if strongSelf.currSong.songRecordingEngineer != nil {
                                    for per in strongSelf.currSong.songRecordingEngineer! {
                                        strongSelf.addAlbumToPersonRecordingEngineer(alb: arrayToAdd, per: per, completion: { error in
                                            completedProgress+=1
                                            if let error = error {
                                                completion(error)
                                                return
                                            } else {
                                                if completedProgress == totalProgress {
                                                    completion(nil)
                                                    return
                                                }
                                            }
                                        })
                                    }
                                }
                            }
                        }
                    }
                }
            }
            
        })
    }
    
    func getPersonAlbumsInDB(ref: DatabaseReference, completion: @escaping (([String]) -> Void)) {
        ref.child("Albums").observeSingleEvent(of: .value, with: { snapshot in
            var mysongsArray:[String] = []
            if let val = snapshot.value {
                let valu = val as? [String]
                guard let value = valu else {
                    completion(mysongsArray)
                    return}
                if value[0] != "" {
                    mysongsArray = value
                }
                completion(mysongsArray)
            } else {
                completion(mysongsArray)
            }
        })
    }
    
    //MARK: - Videos
    func processVideos(initialSong: SongData, currentSong: SongData, completion: @escaping (([Error]?) -> Void)) {
        initSong = initialSong
        currSong = currentSong
        
        initRef = Database.database().reference().child("Music Content").child("Songs").child("\(songContentTag)--\(initSong.name)--\(initSong.toneDeafAppId)")
        currRef = Database.database().reference().child("Music Content").child("Songs").child("\(songContentTag)--\(currSong.name)--\(currSong.toneDeafAppId)")
        var errors:[Error] = []
        var dataUploadCompletionStatus1:Bool!
        var dataUploadCompletionStatus2:Bool!
        
        let aqueue = DispatchQueue(label: "myhjvkheditingQsongVideoshfdChangessseue")
        let agroup = DispatchGroup()
        let array:[Int] = [1,2]
        for i in array {
            agroup.enter()
            aqueue.async { [weak self] in
                guard let strongSelf = self else {return}
                switch i {
                case 1:
                    strongSelf.updateSongVideos(ref: strongSelf.currRef, completion: {err in
                        if let error = err {
                            dataUploadCompletionStatus1 = false
                            errors.append(error)
                        } else {
                            dataUploadCompletionStatus1 = true
                            print("Song Videos Update done \(i)")
                        }
                        agroup.leave()
                    })
                case 2:
                    strongSelf.updateVideoSongs(ref: strongSelf.currRef, completion: {err in
                        if let error = err {
                            dataUploadCompletionStatus1 = false
                            errors.append(error)
                        } else {
                            dataUploadCompletionStatus1 = true
                            print("Video Songs Update done \(i)")
                        }
                        agroup.leave()
                    })
                default:
                    break
                }
            }
        }
        agroup.notify(queue: DispatchQueue.main) {
            if dataUploadCompletionStatus1 == false || dataUploadCompletionStatus2 == false {
                completion(errors)
                return
            } else {
                completion(nil)
            }
        }
    }
    
    func updateSongVideos(ref: DatabaseReference, completion: @escaping ((Error?) -> Void)) {
        var initialSongArrFromDB:[String]!
        
        ref.child("Videos").child("Official").child("id").setValue(currSong.officialVideo)
        ref.child("Videos").child("Audio").child("id").setValue(currSong.audioVideo)
        ref.child("Videos").child("Lyric").child("id").setValue(currSong.lyricVideo)
        
        if currSong.videos == initSong.videos {
            completion(nil)
            return
        }
        getSongVideosInDB(ref: ref, completion: {[weak self] videos in
            guard let strongSelf = self else {return}
            initialSongArrFromDB = videos
            
            if !initialSongArrFromDB.isEmpty {
                var removalCounter = 0
                for i in 0 ... initialSongArrFromDB.count-1 {
                    if strongSelf.currSong.videos != nil {
                        if i < strongSelf.currSong.videos!.count {
                            if !strongSelf.currSong.videos![i].contains(initialSongArrFromDB[i]) {
                                let index = initialSongArrFromDB.firstIndex(of: initialSongArrFromDB[i])
                                initialSongArrFromDB.remove(at: index!)
                                removalCounter+=1
                            }
                        } else {
                            let index = initialSongArrFromDB.firstIndex(of: initialSongArrFromDB[i-removalCounter])
                            initialSongArrFromDB.remove(at: index!)
                            removalCounter+=1
                        }
                    } else {
                        let index = initialSongArrFromDB.firstIndex(of: initialSongArrFromDB[i-removalCounter])
                        initialSongArrFromDB.remove(at: index!)
                        removalCounter+=1
                    }
                }
            }
            
            if strongSelf.currSong.videos != nil {
                if !strongSelf.currSong.videos!.isEmpty {
                    for i in 0 ... strongSelf.currSong.videos!.count-1 {
                        if i < initialSongArrFromDB.count {
                            if !initialSongArrFromDB[i].contains(strongSelf.currSong.videos![i]) {
                                initialSongArrFromDB.append(strongSelf.currSong.videos![i])
                            }
                        } else {
                            initialSongArrFromDB.append(strongSelf.currSong.videos![i])
                        }
                    }
                }
            }
            ref.child("REQUIRED").child("Videos").setValue(initialSongArrFromDB.sorted(), withCompletionBlock: { error, reference in
                if let error = error {
                    completion(error)
                    return
                }
                else {
                    completion(nil)
                    return
                }
            })
            
        })
        
    }
    
    func getSongVideosInDB(ref: DatabaseReference, completion: @escaping (([String]) -> Void)) {
        ref.child("REQUIRED").child("Videos").observeSingleEvent(of: .value, with: { snapshot in
            var mysongsArray:[String] = []
            if let val = snapshot.value {
                let valu = val as? [String]
                guard let value = valu else {
                    completion(mysongsArray)
                    return}
                if value[0] != "" {
                    mysongsArray = value
                }
                completion(mysongsArray)
            } else {
                completion(mysongsArray)
            }
        })
    }
    
    func updateVideoSongs(ref: DatabaseReference, completion: @escaping ((Error?) -> Void)) {
        var initialArtistsArrFromDB:[String]!
        var totalProgress:Int = 0
        var completedProgress:Int = 0
        if currSong.videos!.sorted() == initSong.videos?.sorted() {
            completion(nil)
            return
        }
        
        getSongVideosInDB(ref: ref, completion: {[weak self] persons in
            guard let strongSelf = self else {return}
            initialArtistsArrFromDB = persons.sorted()
            
            if !initialArtistsArrFromDB.isEmpty {
                for i in 0 ... initialArtistsArrFromDB.count-1 {
                    if strongSelf.currSong.videos != nil {
                        if i < strongSelf.currSong.videos!.count {
                            if !strongSelf.currSong.videos![i].contains(initialArtistsArrFromDB[i]) {
                                totalProgress+=1
                            }
                        } else {
                            totalProgress+=1
                        }
                    } else {
                        totalProgress+=1
                    }
                }
            }
            
            if strongSelf.currSong.videos != nil {
                if !strongSelf.currSong.videos!.isEmpty {
                    for i in 0 ... strongSelf.currSong.videos!.count-1 {
                        if i < initialArtistsArrFromDB.count {
                            if !initialArtistsArrFromDB[i].contains(strongSelf.currSong.videos![i]) {
                                totalProgress+=1
                            }
                        } else {
                            totalProgress+=1
                        }
                    }
                }
            }
            
            if totalProgress == 0 {
                completion(nil)
            }
            
            if !initialArtistsArrFromDB.isEmpty {
                for i in 0 ... initialArtistsArrFromDB.count-1 {
                    if strongSelf.currSong.videos != nil {
                        if i < strongSelf.currSong.videos!.count {
                            if !strongSelf.currSong.videos![i].contains(initialArtistsArrFromDB[i]) {
                                strongSelf.removeSongFromVideo(vid: initialArtistsArrFromDB[i], completion: { error in
                                    completedProgress+=1
                                    if let error = error {
                                        completion(error)
                                        return
                                    } else {
                                        if completedProgress == totalProgress {
                                            completion(nil)
                                            return
                                        }
                                    }
                                })
                            }
                        } else {
                            strongSelf.removeSongFromVideo(vid: initialArtistsArrFromDB[i], completion: { error in
                                completedProgress+=1
                                if let error = error {
                                    completion(error)
                                    return
                                } else {
                                    if completedProgress == totalProgress {
                                        completion(nil)
                                        return
                                    }
                                }
                            })
                        }
                    } else {
                        strongSelf.removeSongFromVideo(vid: initialArtistsArrFromDB[i], completion: { error in
                            completedProgress+=1
                            if let error = error {
                                completion(error)
                                return
                            } else {
                                if completedProgress == totalProgress {
                                    completion(nil)
                                    return
                                }
                            }
                        })
                    }
                }
            }
            
            if strongSelf.currSong.videos != nil {
                if !strongSelf.currSong.videos!.isEmpty {
                    for i in 0 ... strongSelf.currSong.videos!.count-1 {
                        if i < initialArtistsArrFromDB.count {
                            if !initialArtistsArrFromDB[i].contains(strongSelf.currSong.videos![i]) {
                                strongSelf.addSongToVideo(vid: strongSelf.currSong.videos![i], completion: { error in
                                    completedProgress+=1
                                    if let error = error {
                                        completion(error)
                                        return
                                    } else {
                                        if completedProgress == totalProgress {
                                            completion(nil)
                                            return
                                        }
                                    }
                                })
                            }
                        } else {
                            strongSelf.addSongToVideo(vid: strongSelf.currSong.videos![i], completion: { error in
                                completedProgress+=1
                                if let error = error {
                                    completion(error)
                                    return
                                } else {
                                    if completedProgress == totalProgress {
                                        completion(nil)
                                        return
                                    }
                                }
                            })
                        }
                    }
                }
            }
            
        })
    }
    
    func removeSongFromVideo(vid: String, completion: @escaping ((Error?) -> Void)) {
        guard vid.count == 9 else {
            completion(nil)
            return
        }
        DatabaseManager.shared.findVideoById(videoid: vid, completion: {[weak self] result in
            guard let strongSelf = self else {return}
            switch result {
            case .success(let video):
                let ref = Database.database().reference().child("Music Content").child("Videos").child( "\(videoContentTag)--\(video.title.replacingOccurrences(of: ".", with: " ").replacingOccurrences(of: "#", with: " ").replacingOccurrences(of: "$", with: " ").replacingOccurrences(of: "[", with: " ").replacingOccurrences(of: "]", with: " ").replacingOccurrences(of: ":", with: " "))--\(video.toneDeafAppId)").child("Songs")
                let song = "\(strongSelf.currSong.toneDeafAppId)"
                var arrto:[String] = []
                if var arrrr = video.songs as? [String] {
                    if arrrr.contains(song) {
                        let index = arrrr.firstIndex(of: song)
                        arrrr.remove(at: index!)
                        video.songs = arrrr.sorted()
                        arrto = arrrr.sorted()
                    }
                }
                
                ref.setValue(arrto, withCompletionBlock: { error, reference in
                    if let error = error {
                        completion(error)
                        return
                    }
                    else {
                        completion(nil)
                        return
                    }
                })
            case .failure(let err):
                print("dsvgredfxbdfzx"+err.localizedDescription)
            }
        })
    }
    
    func addSongToVideo(vid: String, completion: @escaping ((Error?) -> Void)) {
        guard vid.count == 9 else {
            completion(nil)
            return
        }
        
        DatabaseManager.shared.findVideoById(videoid: vid, completion: {[weak self] result in
            guard let strongSelf = self else {return}
            switch result {
            case .success(let video):
                let ref = Database.database().reference().child("Music Content").child("Videos").child( "\(videoContentTag)--\(video.title.replacingOccurrences(of: ".", with: " ").replacingOccurrences(of: "#", with: " ").replacingOccurrences(of: "$", with: " ").replacingOccurrences(of: "[", with: " ").replacingOccurrences(of: "]", with: " ").replacingOccurrences(of: ":", with: " "))--\(video.toneDeafAppId)").child("Songs")
                let song = "\(strongSelf.currSong.toneDeafAppId)"
                var arrto:[String] = []
                if var allArt = video.songs {
                    if !allArt.contains(song) {
                        allArt.append(song)
                        arrto = allArt.sorted()
                    }
                } else {
                    arrto = [song]
                }
                ref.setValue(arrto, withCompletionBlock: { error, reference in
                    if let error = error {
                        completion(error)
                        return
                    }
                    else {
                        completion(nil)
                        return
                    }
                })
            case .failure(let err):
                print("dsvgredfxbdfzx"+err.localizedDescription)
            }
        })
    }
    
    //MARK: - Instrumentals
    func processInstrumentals(initialSong: SongData, currentSong: SongData, completion: @escaping (([Error]?) -> Void)) {
        initSong = initialSong
        currSong = currentSong
        
        initRef = Database.database().reference().child("Music Content").child("Songs").child("\(songContentTag)--\(initSong.name)--\(initSong.toneDeafAppId)")
        currRef = Database.database().reference().child("Music Content").child("Songs").child("\(songContentTag)--\(currSong.name)--\(currSong.toneDeafAppId)")
        var errors:[Error] = []
        var dataUploadCompletionStatus1:Bool!
        var dataUploadCompletionStatus2:Bool!
        
        let aqueue = DispatchQueue(label: "myhjvkheditingQsongInstrumentalsshfdChangessseue")
        let agroup = DispatchGroup()
        let array:[Int] = [1,2]
        for i in array {
            agroup.enter()
            aqueue.async { [weak self] in
                guard let strongSelf = self else {return}
                switch i {
                case 1:
                    strongSelf.updateSongInstrumentals(ref: strongSelf.currRef, completion: {err in
                        if let error = err {
                            dataUploadCompletionStatus1 = false
                            errors.append(error)
                        } else {
                            dataUploadCompletionStatus1 = true
                            print("Song Instrumentals Update done \(i)")
                        }
                        agroup.leave()
                    })
                case 2:
                    strongSelf.updateInstrumentalSongs(ref: strongSelf.currRef, completion: {err in
                        if let error = err {
                            dataUploadCompletionStatus1 = false
                            errors.append(error)
                        } else {
                            dataUploadCompletionStatus1 = true
                            print("Instrumental Songs Update done \(i)")
                        }
                        agroup.leave()
                    })
                default:
                    break
                }
            }
        }
        agroup.notify(queue: DispatchQueue.main) {
            if dataUploadCompletionStatus1 == false || dataUploadCompletionStatus2 == false {
                completion(errors)
                return
            } else {
                completion(nil)
            }
        }
    }
    
    func updateSongInstrumentals(ref: DatabaseReference, completion: @escaping ((Error?) -> Void)) {
        var initialSongArrFromDB:[String]!
        
        if currSong.instrumentals == initSong.instrumentals {
            completion(nil)
            return
        }
        getSongInstrumentalsInDB(ref: ref, completion: {[weak self] instrumentals in
            guard let strongSelf = self else {return}
            initialSongArrFromDB = instrumentals
            
            if !initialSongArrFromDB.isEmpty {
                var removalCounter = 0
                for i in 0 ... initialSongArrFromDB.count-1 {
                    if strongSelf.currSong.instrumentals != nil {
                        if i < strongSelf.currSong.instrumentals!.count {
                            if !strongSelf.currSong.instrumentals![i].contains(initialSongArrFromDB[i]) {
                                let index = initialSongArrFromDB.firstIndex(of: initialSongArrFromDB[i])
                                initialSongArrFromDB.remove(at: index!)
                                removalCounter+=1
                            }
                        } else {
                            let index = initialSongArrFromDB.firstIndex(of: initialSongArrFromDB[i-removalCounter])
                            initialSongArrFromDB.remove(at: index!)
                            removalCounter+=1
                        }
                    } else {
                        let index = initialSongArrFromDB.firstIndex(of: initialSongArrFromDB[i-removalCounter])
                        initialSongArrFromDB.remove(at: index!)
                        removalCounter+=1
                    }
                }
            }
            
            if strongSelf.currSong.instrumentals != nil {
                if !strongSelf.currSong.instrumentals!.isEmpty {
                    for i in 0 ... strongSelf.currSong.instrumentals!.count-1 {
                        if i < initialSongArrFromDB.count {
                            if !initialSongArrFromDB[i].contains(strongSelf.currSong.instrumentals![i]) {
                                initialSongArrFromDB.append(strongSelf.currSong.instrumentals![i])
                            }
                        } else {
                            initialSongArrFromDB.append(strongSelf.currSong.instrumentals![i])
                        }
                    }
                }
            }
            ref.child("REQUIRED").child("Instrumentals").setValue(initialSongArrFromDB.sorted(), withCompletionBlock: { error, reference in
                if let error = error {
                    completion(error)
                    return
                }
                else {
                    completion(nil)
                    return
                }
            })
            
        })
        
    }
    
    func getSongInstrumentalsInDB(ref: DatabaseReference, completion: @escaping (([String]) -> Void)) {
        ref.child("REQUIRED").child("Instrumentals").observeSingleEvent(of: .value, with: { snapshot in
            var mysongsArray:[String] = []
            if let val = snapshot.value {
                let valu = val as? [String]
                guard let value = valu else {
                    completion(mysongsArray)
                    return}
                if value[0] != "" {
                    mysongsArray = value
                }
                completion(mysongsArray)
            } else {
                completion(mysongsArray)
            }
        })
    }
    
    func updateInstrumentalSongs(ref: DatabaseReference, completion: @escaping ((Error?) -> Void)) {
        var initialArtistsArrFromDB:[String]!
        var totalProgress:Int = 0
        var completedProgress:Int = 0
        if currSong.instrumentals!.sorted() == initSong.instrumentals?.sorted() {
            completion(nil)
            return
        }
        
        getSongInstrumentalsInDB(ref: ref, completion: {[weak self] persons in
            guard let strongSelf = self else {return}
            initialArtistsArrFromDB = persons.sorted()
            
            if !initialArtistsArrFromDB.isEmpty {
                for i in 0 ... initialArtistsArrFromDB.count-1 {
                    if strongSelf.currSong.instrumentals != nil {
                        if i < strongSelf.currSong.instrumentals!.count {
                            if !strongSelf.currSong.instrumentals![i].contains(initialArtistsArrFromDB[i]) {
                                totalProgress+=1
                            }
                        } else {
                            totalProgress+=1
                        }
                    } else {
                        totalProgress+=1
                    }
                }
            }
            
            if strongSelf.currSong.instrumentals != nil {
                if !strongSelf.currSong.instrumentals!.isEmpty {
                    for i in 0 ... strongSelf.currSong.instrumentals!.count-1 {
                        if i < initialArtistsArrFromDB.count {
                            if !initialArtistsArrFromDB[i].contains(strongSelf.currSong.instrumentals![i]) {
                                totalProgress+=1
                            }
                        } else {
                            totalProgress+=1
                        }
                    }
                }
            }
            
            if totalProgress == 0 {
                completion(nil)
            }
            
            if !initialArtistsArrFromDB.isEmpty {
                for i in 0 ... initialArtistsArrFromDB.count-1 {
                    if strongSelf.currSong.instrumentals != nil {
                        if i < strongSelf.currSong.instrumentals!.count {
                            if !strongSelf.currSong.instrumentals![i].contains(initialArtistsArrFromDB[i]) {
                                strongSelf.removeSongFromInstrumental(inst: initialArtistsArrFromDB[i], completion: { error in
                                    completedProgress+=1
                                    if let error = error {
                                        completion(error)
                                        return
                                    } else {
                                        if completedProgress == totalProgress {
                                            completion(nil)
                                            return
                                        }
                                    }
                                })
                            }
                        } else {
                            strongSelf.removeSongFromInstrumental(inst: initialArtistsArrFromDB[i], completion: { error in
                                completedProgress+=1
                                if let error = error {
                                    completion(error)
                                    return
                                } else {
                                    if completedProgress == totalProgress {
                                        completion(nil)
                                        return
                                    }
                                }
                            })
                        }
                    } else {
                        strongSelf.removeSongFromInstrumental(inst: initialArtistsArrFromDB[i], completion: { error in
                            completedProgress+=1
                            if let error = error {
                                completion(error)
                                return
                            } else {
                                if completedProgress == totalProgress {
                                    completion(nil)
                                    return
                                }
                            }
                        })
                    }
                }
            }
            
            if strongSelf.currSong.instrumentals != nil {
                if !strongSelf.currSong.instrumentals!.isEmpty {
                    for i in 0 ... strongSelf.currSong.instrumentals!.count-1 {
                        if i < initialArtistsArrFromDB.count {
                            if !initialArtistsArrFromDB[i].contains(strongSelf.currSong.instrumentals![i]) {
                                strongSelf.addSongToInstrumental(inst: strongSelf.currSong.instrumentals![i], completion: { error in
                                    completedProgress+=1
                                    if let error = error {
                                        completion(error)
                                        return
                                    } else {
                                        if completedProgress == totalProgress {
                                            completion(nil)
                                            return
                                        }
                                    }
                                })
                            }
                        } else {
                            strongSelf.addSongToInstrumental(inst: strongSelf.currSong.instrumentals![i], completion: { error in
                                completedProgress+=1
                                if let error = error {
                                    completion(error)
                                    return
                                } else {
                                    if completedProgress == totalProgress {
                                        completion(nil)
                                        return
                                    }
                                }
                            })
                        }
                    }
                }
            }
            
        })
    }
    
    func removeSongFromInstrumental(inst: String, completion: @escaping ((Error?) -> Void)) {
        guard inst.count == 12 else {
            completion(nil)
            return
        }
        DatabaseManager.shared.findInstrumentalById(instrumentalId: inst, completion: {[weak self] result in
            guard let strongSelf = self else {return}
            switch result {
            case .success(let instrumental):
                let ref = Database.database().reference().child("Music Content").child("Instrumentals").child( "\(instrumentalContentType)--\(instrumental.songName!)--\(instrumental.toneDeafAppId)").child("Songs")
                let song = "\(strongSelf.currSong.toneDeafAppId)"
                var arrto:[String] = []
                if var arrrr = instrumental.songs as? [String] {
                    if arrrr.contains(song) {
                        let index = arrrr.firstIndex(of: song)
                        arrrr.remove(at: index!)
                        instrumental.songs = arrrr.sorted()
                        arrto = arrrr.sorted()
                    }
                }
                
                ref.setValue(arrto, withCompletionBlock: { error, reference in
                    if let error = error {
                        completion(error)
                        return
                    }
                    else {
                        completion(nil)
                        return
                    }
                })
            case .failure(let err):
                print("dsvgredfxbdfzx"+err.localizedDescription)
            }
        })
    }
    
    func addSongToInstrumental(inst: String, completion: @escaping ((Error?) -> Void)) {
        guard inst.count == 12 else {
            completion(nil)
            return
        }
        
        DatabaseManager.shared.findInstrumentalById(instrumentalId: inst, completion: {[weak self] result in
            guard let strongSelf = self else {return}
            switch result {
            case .success(let instrumental):
                let ref = Database.database().reference().child("Music Content").child("Instrumentals").child( "\(instrumentalContentType)--\(instrumental.songName!)--\(instrumental.toneDeafAppId)").child("Songs")
                let song = "\(strongSelf.currSong.toneDeafAppId)"
                var arrto:[String] = []
                if var allArt = instrumental.songs {
                    if !allArt.contains(song) {
                        allArt.append(song)
                        arrto = allArt.sorted()
                    }
                } else {
                    arrto = [song]
                }
                ref.setValue(arrto, withCompletionBlock: { error, reference in
                    if let error = error {
                        completion(error)
                        return
                    }
                    else {
                        completion(nil)
                        return
                    }
                })
            case .failure(let err):
                print("dsvgredfxbdfzx"+err.localizedDescription)
            }
        })
    }
    
    //MARK: - Explicity
    func processExplicity(initialSong: SongData, currentSong: SongData, completion: @escaping ((Error?) -> Void)) {
        initSong = initialSong
        currSong = currentSong
        let ref = Database.database().reference().child("Music Content").child("Songs").child("\(songContentTag)--\(currSong.name)--\(currSong.toneDeafAppId)").child("REQUIRED").child("Explicit")
        ref.setValue(currSong.explicit, withCompletionBlock: { error, reference in
            if let error = error {
                completion(error)
                return
            }
            else {
                completion(nil)
                return
            }
        })
    }
    
    //MARK: - Remixes
    func processRemixes(initialSong: SongData, currentSong: SongData, completion: @escaping (([Error]?) -> Void)) {
        initSong = initialSong
        currSong = currentSong
        var errors:[Error] = []
        initRef = Database.database().reference().child("Music Content").child("Songs").child("\(songContentTag)--\(initSong.name)--\(initSong.toneDeafAppId)")
        currRef = Database.database().reference().child("Music Content").child("Songs").child("\(songContentTag)--\(currSong.name)--\(currSong.toneDeafAppId)")
        var dataUploadCompletionStatus1:Bool!
        var dataUploadCompletionStatus2:Bool!
        
        let aqueue = DispatchQueue(label: "myhjvkheditingQsongRemixshfdChangessseue")
        let agroup = DispatchGroup()
        let array:[Int] = [1,2]
        for i in array {
            agroup.enter()
            aqueue.async { [weak self] in
                guard let strongSelf = self else {return}
                switch i {
                case 1:
                    strongSelf.updateSongRemixes(ref: strongSelf.currRef, completion: {err in
                        if let error = err {
                            dataUploadCompletionStatus1 = false
                            errors.append(error)
                        } else {
                            dataUploadCompletionStatus1 = true
                            print("Song Remixes Update done \(i)")
                        }
                        agroup.leave()
                    })
                case 2:
                    strongSelf.updateRemixSongIsRemix(ref: strongSelf.currRef, completion: {err in
                        if let error = err {
                            dataUploadCompletionStatus1 = false
                            errors.append(error)
                        } else {
                            dataUploadCompletionStatus1 = true
                            print("Remix Song Is Remix Update done \(i)")
                        }
                        agroup.leave()
                    })
                default:
                    break
                }
            }
        }
        agroup.notify(queue: DispatchQueue.main) {
            if dataUploadCompletionStatus1 == false || dataUploadCompletionStatus2 == false {
                completion(errors)
                return
            } else {
                completion(nil)
            }
        }
    }
    
    func updateSongRemixes(ref: DatabaseReference, completion: @escaping ((Error?) -> Void)) {
        
        var initialSongArrFromDB:[String]!
        if currSong.remixes == initSong.remixes {
            completion(nil)
            return
        }
        getSongRemixesInDB(ref: ref, completion: {[weak self] remixes in
            guard let strongSelf = self else {return}
            initialSongArrFromDB = remixes
            
            if !initialSongArrFromDB.isEmpty {
                var removalCounter = 0
                for i in 0 ... initialSongArrFromDB.count-1 {
                    if strongSelf.currSong.remixes != nil {
                        if i < strongSelf.currSong.remixes!.count {
                            if !strongSelf.currSong.remixes!.contains(initialSongArrFromDB[i]) {
                                let index = initialSongArrFromDB.firstIndex(of: initialSongArrFromDB[i])
                                initialSongArrFromDB.remove(at: index!)
                                removalCounter+=1
                            }
                        } else {
                            let index = initialSongArrFromDB.firstIndex(of: initialSongArrFromDB[i-removalCounter])
                            initialSongArrFromDB.remove(at: index!)
                            removalCounter+=1
                        }
                    } else {
                        let index = initialSongArrFromDB.firstIndex(of: initialSongArrFromDB[i-removalCounter])
                        initialSongArrFromDB.remove(at: index!)
                        removalCounter+=1
                    }
                }
            }
            
            if strongSelf.currSong.remixes != nil {
                if !strongSelf.currSong.remixes!.isEmpty {
                    for i in 0 ... strongSelf.currSong.remixes!.count-1 {
                        if i < initialSongArrFromDB.count {
                            if !initialSongArrFromDB.contains(strongSelf.currSong.remixes![i]) {
                                initialSongArrFromDB.append(strongSelf.currSong.remixes![i])
                            }
                        } else {
                            initialSongArrFromDB.append(strongSelf.currSong.remixes![i])
                        }
                    }
                }
            }
            ref.child("REQUIRED").child("Remixes").setValue(initialSongArrFromDB.sorted(), withCompletionBlock: { error, reference in
                if let error = error {
                    completion(error)
                    return
                }
                else {
                    completion(nil)
                    return
                }
            })
            
        })
    }
    
    func getSongRemixesInDB(ref: DatabaseReference, completion: @escaping (([String]) -> Void)) {
        ref.child("REQUIRED").child("Remixes").observeSingleEvent(of: .value, with: { snapshot in
            var mysongsArray:[String] = []
            if let val = snapshot.value {
                let valu = val as? [String]
                guard let value = valu else {
                    completion(mysongsArray)
                    return}
                if value[0] != "" {
                    mysongsArray = value
                }
                completion(mysongsArray)
            } else {
                completion(mysongsArray)
            }
        })
    }
    
    func updateRemixSongIsRemix(ref: DatabaseReference, completion: @escaping ((Error?) -> Void)) {
        var initialArtistsArrFromDB:[String]!
        var totalProgress:Int = 0
        var completedProgress:Int = 0
        if currSong.remixes!.sorted() == initSong.remixes?.sorted() {
            completion(nil)
            return
        }
        
        getSongRemixesInDB(ref: ref, completion: {[weak self] persons in
            guard let strongSelf = self else {return}
            initialArtistsArrFromDB = persons.sorted()
            
            if !initialArtistsArrFromDB.isEmpty {
                for i in 0 ... initialArtistsArrFromDB.count-1 {
                    if strongSelf.currSong.remixes != nil {
                        if i < strongSelf.currSong.remixes!.count {
                            if !strongSelf.currSong.remixes!.contains(initialArtistsArrFromDB[i]) {
                                totalProgress+=1
                            }
                        } else {
                            totalProgress+=1
                        }
                    } else {
                        totalProgress+=1
                    }
                }
            }
            
            if strongSelf.currSong.remixes != nil {
                if !strongSelf.currSong.remixes!.isEmpty {
                    for i in 0 ... strongSelf.currSong.remixes!.count-1 {
                        if i < initialArtistsArrFromDB.count {
                            if !initialArtistsArrFromDB.contains(strongSelf.currSong.remixes![i]) {
                                totalProgress+=1
                            }
                        } else {
                            totalProgress+=1
                        }
                    }
                }
            }
            
            if totalProgress == 0 {
                completion(nil)
                return
            }
            
            if !initialArtistsArrFromDB.isEmpty {
                for i in 0 ... initialArtistsArrFromDB.count-1 {
                    if strongSelf.currSong.remixes != nil {
                        if i < strongSelf.currSong.remixes!.count {
                            if !strongSelf.currSong.remixes!.contains(initialArtistsArrFromDB[i]) {
                                strongSelf.removeIsRemixFromSong(son: initialArtistsArrFromDB[i], completion: { error in
                                    completedProgress+=1
                                    if let error = error {
                                        completion(error)
                                        return
                                    } else {
                                        if completedProgress == totalProgress {
                                            completion(nil)
                                            return
                                        }
                                    }
                                })
                            }
                        } else {
                            strongSelf.removeIsRemixFromSong(son: initialArtistsArrFromDB[i], completion: { error in
                                completedProgress+=1
                                if let error = error {
                                    completion(error)
                                    return
                                } else {
                                    if completedProgress == totalProgress {
                                        completion(nil)
                                        return
                                    }
                                }
                            })
                        }
                    } else {
                        strongSelf.removeIsRemixFromSong(son: initialArtistsArrFromDB[i], completion: { error in
                            completedProgress+=1
                            if let error = error {
                                completion(error)
                                return
                            } else {
                                if completedProgress == totalProgress {
                                    completion(nil)
                                    return
                                }
                            }
                        })
                    }
                }
            }
            
            if strongSelf.currSong.remixes != nil {
                if !strongSelf.currSong.remixes!.isEmpty {
                    for i in 0 ... strongSelf.currSong.remixes!.count-1 {
                        if i < initialArtistsArrFromDB.count {
                            if !initialArtistsArrFromDB[i].contains(strongSelf.currSong.remixes![i]) {
                                strongSelf.addIsRemixToSong(son: strongSelf.currSong.remixes![i], completion: { error in
                                    completedProgress+=1
                                    if let error = error {
                                        completion(error)
                                        return
                                    } else {
                                        if completedProgress == totalProgress {
                                            completion(nil)
                                            return
                                        }
                                    }
                                })
                            }
                        } else {
                            strongSelf.addIsRemixToSong(son: strongSelf.currSong.remixes![i], completion: { error in
                                completedProgress+=1
                                if let error = error {
                                    completion(error)
                                    return
                                } else {
                                    if completedProgress == totalProgress {
                                        completion(nil)
                                        return
                                    }
                                }
                            })
                        }
                    }
                }
            }
            
        })
    }
    
    func removeIsRemixFromSong(son: String, completion: @escaping ((Error?) -> Void)) {
        guard son.count == 10 else {
            completion(nil)
            return
        }
        DatabaseManager.shared.findSongById(songId: son, completion: {[weak self] result in
            guard let strongSelf = self else {return}
            switch result {
            case .success(let song):
                let ref = Database.database().reference().child("Music Content").child("Songs").child( "\(songContentTag)--\(song.name)--\(song.toneDeafAppId)").child("REQUIRED").child("Remix")
                
                ref.removeValue(completionBlock: { error, reference in
                    if let error = error {
                        completion(error)
                        return
                    }
                    else {
                        completion(nil)
                        return
                    }
                })
            case .failure(let err):
                print("dsvgredfxbdfzx"+err.localizedDescription)
            }
        })
    }
    
    func addIsRemixToSong(son: String, completion: @escaping ((Error?) -> Void)) {
        guard son.count == 10 else {
            completion(nil)
            return
        }
        DatabaseManager.shared.findSongById(songId: son, completion: {[weak self] result in
            guard let strongSelf = self else {return}
            switch result {
            case .success(let song):
                let ref = Database.database().reference().child("Music Content").child("Songs").child( "\(songContentTag)--\(song.name)--\(song.toneDeafAppId)").child("REQUIRED").child("Remix")
                let stansong = "\(strongSelf.currSong.toneDeafAppId)"
                let arrto:NSDictionary = [
                    "Standard Edition": stansong,
                    "Status": true
                ]
                
                ref.setValue(arrto, withCompletionBlock: { error, reference in
                    if let error = error {
                        completion(error)
                        return
                    }
                    else {
                        completion(nil)
                        return
                    }
                })
            case .failure(let err):
                print("dsvgredfxbdfzx"+err.localizedDescription)
            }
        })
    }
    
    //MARK: - Other Versions
    func processOtherVersions(initialSong: SongData, currentSong: SongData, completion: @escaping (([Error]?) -> Void)) {
        initSong = initialSong
        currSong = currentSong
        var errors:[Error] = []
        initRef = Database.database().reference().child("Music Content").child("Songs").child("\(songContentTag)--\(initSong.name)--\(initSong.toneDeafAppId)")
        currRef = Database.database().reference().child("Music Content").child("Songs").child("\(songContentTag)--\(currSong.name)--\(currSong.toneDeafAppId)")
        var dataUploadCompletionStatus1:Bool!
        var dataUploadCompletionStatus2:Bool!
        
        let aqueue = DispatchQueue(label: "myhjvkheditingQsongOtherVersionshfdChangessseue")
        let agroup = DispatchGroup()
        let array:[Int] = [1,2]
        for i in array {
            agroup.enter()
            aqueue.async { [weak self] in
                guard let strongSelf = self else {return}
                switch i {
                case 1:
                    strongSelf.updateSongOtherVersions(ref: strongSelf.currRef, completion: {err in
                        if let error = err {
                            dataUploadCompletionStatus1 = false
                            errors.append(error)
                        } else {
                            dataUploadCompletionStatus1 = true
                            print("Song Other Versions Update done \(i)")
                        }
                        agroup.leave()
                    })
                case 2:
                    strongSelf.updateOtherVersionsSongIsOtherVersion(ref: strongSelf.currRef, completion: {err in
                        if let error = err {
                            dataUploadCompletionStatus1 = false
                            errors.append(error)
                        } else {
                            dataUploadCompletionStatus1 = true
                            print("Other Version Song Is Other Version Update done \(i)")
                        }
                        agroup.leave()
                    })
                default:
                    break
                }
            }
        }
        agroup.notify(queue: DispatchQueue.main) {
            if dataUploadCompletionStatus1 == false || dataUploadCompletionStatus2 == false {
                completion(errors)
                return
            } else {
                completion(nil)
            }
        }
    }
    
    func updateSongOtherVersions(ref: DatabaseReference, completion: @escaping ((Error?) -> Void)) {
        
        var initialSongArrFromDB:[String]!
        if currSong.otherVersions == initSong.otherVersions {
            completion(nil)
            return
        }
        getSongOtherVersionsInDB(ref: ref, completion: {[weak self] otherVersions in
            guard let strongSelf = self else {return}
            initialSongArrFromDB = otherVersions
            
            if !initialSongArrFromDB.isEmpty {
                var removalCounter = 0
                for i in 0 ... initialSongArrFromDB.count-1 {
                    if strongSelf.currSong.otherVersions != nil {
                        if i < strongSelf.currSong.otherVersions!.count {
                            if !strongSelf.currSong.otherVersions!.contains(initialSongArrFromDB[i]) {
                                let index = initialSongArrFromDB.firstIndex(of: initialSongArrFromDB[i])
                                initialSongArrFromDB.remove(at: index!)
                                removalCounter+=1
                            }
                        } else {
                            let index = initialSongArrFromDB.firstIndex(of: initialSongArrFromDB[i-removalCounter])
                            initialSongArrFromDB.remove(at: index!)
                            removalCounter+=1
                        }
                    } else {
                        let index = initialSongArrFromDB.firstIndex(of: initialSongArrFromDB[i-removalCounter])
                        initialSongArrFromDB.remove(at: index!)
                        removalCounter+=1
                    }
                }
            }
            
            if strongSelf.currSong.otherVersions != nil {
                if !strongSelf.currSong.otherVersions!.isEmpty {
                    for i in 0 ... strongSelf.currSong.otherVersions!.count-1 {
                        if i < initialSongArrFromDB.count {
                            if !initialSongArrFromDB.contains(strongSelf.currSong.otherVersions![i]) {
                                initialSongArrFromDB.append(strongSelf.currSong.otherVersions![i])
                            }
                        } else {
                            initialSongArrFromDB.append(strongSelf.currSong.otherVersions![i])
                        }
                    }
                }
            }
            ref.child("REQUIRED").child("Other Versions").setValue(initialSongArrFromDB.sorted(), withCompletionBlock: { error, reference in
                if let error = error {
                    completion(error)
                    return
                }
                else {
                    completion(nil)
                    return
                }
            })
            
        })
    }
    
    func getSongOtherVersionsInDB(ref: DatabaseReference, completion: @escaping (([String]) -> Void)) {
        ref.child("REQUIRED").child("Other Versions").observeSingleEvent(of: .value, with: { snapshot in
            var mysongsArray:[String] = []
            if let val = snapshot.value {
                let valu = val as? [String]
                guard let value = valu else {
                    completion(mysongsArray)
                    return}
                if value[0] != "" {
                    mysongsArray = value
                }
                completion(mysongsArray)
            } else {
                completion(mysongsArray)
            }
        })
    }
    
    func updateOtherVersionsSongIsOtherVersion(ref: DatabaseReference, completion: @escaping ((Error?) -> Void)) {
        var initialArtistsArrFromDB:[String]!
        var totalProgress:Int = 0
        var completedProgress:Int = 0
        if currSong.otherVersions!.sorted() == initSong.otherVersions?.sorted() {
            completion(nil)
            return
        }
        
        getSongOtherVersionsInDB(ref: ref, completion: {[weak self] persons in
            guard let strongSelf = self else {return}
            initialArtistsArrFromDB = persons.sorted()
            
            if !initialArtistsArrFromDB.isEmpty {
                for i in 0 ... initialArtistsArrFromDB.count-1 {
                    if strongSelf.currSong.otherVersions != nil {
                        if i < strongSelf.currSong.otherVersions!.count {
                            if !strongSelf.currSong.otherVersions!.contains(initialArtistsArrFromDB[i]) {
                                totalProgress+=1
                            }
                        } else {
                            totalProgress+=1
                        }
                    } else {
                        totalProgress+=1
                    }
                }
            }
            
            if strongSelf.currSong.otherVersions != nil {
                if !strongSelf.currSong.otherVersions!.isEmpty {
                    for i in 0 ... strongSelf.currSong.otherVersions!.count-1 {
                        if i < initialArtistsArrFromDB.count {
                            if !initialArtistsArrFromDB.contains(strongSelf.currSong.otherVersions![i]) {
                                totalProgress+=1
                            }
                        } else {
                            totalProgress+=1
                        }
                    }
                }
            }
            
            if totalProgress == 0 {
                completion(nil)
                return
            }
            
            if !initialArtistsArrFromDB.isEmpty {
                for i in 0 ... initialArtistsArrFromDB.count-1 {
                    if strongSelf.currSong.otherVersions != nil {
                        if i < strongSelf.currSong.otherVersions!.count {
                            if !strongSelf.currSong.otherVersions!.contains(initialArtistsArrFromDB[i]) {
                                strongSelf.removeIsOtherVersionsFromSong(son: initialArtistsArrFromDB[i], completion: { error in
                                    completedProgress+=1
                                    if let error = error {
                                        completion(error)
                                        return
                                    } else {
                                        if completedProgress == totalProgress {
                                            completion(nil)
                                            return
                                        }
                                    }
                                })
                            }
                        } else {
                            strongSelf.removeIsOtherVersionsFromSong(son: initialArtistsArrFromDB[i], completion: { error in
                                completedProgress+=1
                                if let error = error {
                                    completion(error)
                                    return
                                } else {
                                    if completedProgress == totalProgress {
                                        completion(nil)
                                        return
                                    }
                                }
                            })
                        }
                    } else {
                        strongSelf.removeIsOtherVersionsFromSong(son: initialArtistsArrFromDB[i], completion: { error in
                            completedProgress+=1
                            if let error = error {
                                completion(error)
                                return
                            } else {
                                if completedProgress == totalProgress {
                                    completion(nil)
                                    return
                                }
                            }
                        })
                    }
                }
            }
            
            if strongSelf.currSong.otherVersions != nil {
                if !strongSelf.currSong.otherVersions!.isEmpty {
                    for i in 0 ... strongSelf.currSong.otherVersions!.count-1 {
                        if i < initialArtistsArrFromDB.count {
                            if !initialArtistsArrFromDB[i].contains(strongSelf.currSong.otherVersions![i]) {
                                strongSelf.addIsOtherVersionsToSong(son: strongSelf.currSong.otherVersions![i], completion: { error in
                                    completedProgress+=1
                                    if let error = error {
                                        completion(error)
                                        return
                                    } else {
                                        if completedProgress == totalProgress {
                                            completion(nil)
                                            return
                                        }
                                    }
                                })
                            }
                        } else {
                            strongSelf.addIsOtherVersionsToSong(son: strongSelf.currSong.otherVersions![i], completion: { error in
                                completedProgress+=1
                                if let error = error {
                                    completion(error)
                                    return
                                } else {
                                    if completedProgress == totalProgress {
                                        completion(nil)
                                        return
                                    }
                                }
                            })
                        }
                    }
                }
            }
            
        })
    }
    
    func removeIsOtherVersionsFromSong(son: String, completion: @escaping ((Error?) -> Void)) {
        guard son.count == 10 else {
            completion(nil)
            return
        }
        DatabaseManager.shared.findSongById(songId: son, completion: {[weak self] result in
            guard let strongSelf = self else {return}
            switch result {
            case .success(let song):
                let ref = Database.database().reference().child("Music Content").child("Songs").child( "\(songContentTag)--\(song.name)--\(song.toneDeafAppId)").child("REQUIRED").child("Other Version")
                
                ref.removeValue(completionBlock: { error, reference in
                    if let error = error {
                        completion(error)
                        return
                    }
                    else {
                        completion(nil)
                        return
                    }
                })
            case .failure(let err):
                print("dsvgredfxbdfzx"+err.localizedDescription)
            }
        })
    }
    
    func addIsOtherVersionsToSong(son: String, completion: @escaping ((Error?) -> Void)) {
        guard son.count == 10 else {
            completion(nil)
            return
        }
        DatabaseManager.shared.findSongById(songId: son, completion: {[weak self] result in
            guard let strongSelf = self else {return}
            switch result {
            case .success(let song):
                let ref = Database.database().reference().child("Music Content").child("Songs").child( "\(songContentTag)--\(song.name)--\(song.toneDeafAppId)").child("REQUIRED").child("Other Version")
                let stansong = "\(strongSelf.currSong.toneDeafAppId)"
                let arrto:NSDictionary = [
                    "Standard Edition": stansong,
                    "Status": true
                ]
                
                ref.setValue(arrto, withCompletionBlock: { error, reference in
                    if let error = error {
                        completion(error)
                        return
                    }
                    else {
                        completion(nil)
                        return
                    }
                })
            case .failure(let err):
                print("dsvgredfxbdfzx"+err.localizedDescription)
            }
        })
    }
    
    //MARK: - IsRemixes
    func processIsRemixes(initialSong: SongData, currentSong: SongData,initSE: String?, completion: @escaping (([Error]?) -> Void)) {
        initSong = initialSong
        currSong = currentSong
        var errors:[Error] = []
        initRef = Database.database().reference().child("Music Content").child("Songs").child("\(songContentTag)--\(initSong.name)--\(initSong.toneDeafAppId)")
        currRef = Database.database().reference().child("Music Content").child("Songs").child("\(songContentTag)--\(currSong.name)--\(currSong.toneDeafAppId)")
        var dataUploadCompletionStatus1:Bool!
        var dataUploadCompletionStatus2:Bool!
        
        let aqueue = DispatchQueue(label: "myhjvkheditingQsongRemixshfdChangessseue")
        let agroup = DispatchGroup()
        let array:[Int] = [1,2]
        for i in array {
            agroup.enter()
            aqueue.async { [weak self] in
                guard let strongSelf = self else {return}
                switch i {
                case 1:
                    strongSelf.updateRemixSongRemixes(ref: strongSelf.currRef,initSE:initSE, completion: {err in
                        if let error = err {
                            dataUploadCompletionStatus1 = false
                            errors.append(error)
                        } else {
                            dataUploadCompletionStatus1 = true
                            print("Remix Song Remixes Update done \(i)")
                        }
                        agroup.leave()
                    })
                case 2:
                    strongSelf.updateSongIsRemix(ref: strongSelf.currRef, completion: {err in
                        if let error = err {
                            dataUploadCompletionStatus1 = false
                            errors.append(error)
                        } else {
                            dataUploadCompletionStatus1 = true
                            print("Song Is Remix Update done \(i)")
                        }
                        agroup.leave()
                    })
                default:
                    break
                }
            }
        }
        agroup.notify(queue: DispatchQueue.main) {
            if dataUploadCompletionStatus1 == false || dataUploadCompletionStatus2 == false {
                completion(errors)
                return
            } else {
                completion(nil)
            }
        }
    }
    
    func updateSongIsRemix(ref: DatabaseReference, completion: @escaping ((Error?) -> Void)) {
//        if currSong.isRemix == initSong.isRemix {
//            completion(nil)
//            return
//        }
        var arrto:NSDictionary!
        let ref = ref.child("REQUIRED").child("Remix")
        if currSong.isRemix != nil {
            arrto = [
                "Standard Edition": currSong.isRemix?.standardEdition,
                "Status": true
            ]
        }
        
        ref.setValue(arrto, withCompletionBlock: { error, reference in
            if let error = error {
                completion(error)
                return
            }
            else {
                completion(nil)
                return
            }
        })
    }
    
    func updateRemixSongRemixes(ref: DatabaseReference,initSE: String?, completion: @escaping ((Error?) -> Void)) {
        var totalProgress:Int = 0
        var completedProgress:Int = 0
        
        if currSong.isRemix?.standardEdition == nil && initSE == nil {
            completion(nil)
            return
        }
        if currSong.isRemix?.standardEdition == initSE {
            completion(nil)
            return
        }
        
        if initSE != nil {
            totalProgress+=1
            if currSong.isRemix?.standardEdition != nil {
                totalProgress+=1
            }
        } else {
            if currSong.isRemix?.standardEdition != nil {
                totalProgress+=1
            }
        }
        
        if totalProgress == 0 {
            completion(nil)
            return
        }
        
        if initSE != nil {
            removeSongFromRemixes(son: initSE!, completion: { error in
                completedProgress+=1
                if let error = error {
                    completion(error)
                    return
                } else {
                    if completedProgress == totalProgress {
                        completion(nil)
                        return
                    }
                }
            })
            if currSong.isRemix?.standardEdition != nil {
                addSongToRemixes(son: currSong.isRemix!.standardEdition!, completion: { error in
                    completedProgress+=1
                    if let error = error {
                        completion(error)
                        return
                    } else {
                        if completedProgress == totalProgress {
                            completion(nil)
                            return
                        }
                    }
                })
            }
        } else {
            if currSong.isRemix?.standardEdition != nil {
                addSongToRemixes(son: currSong.isRemix!.standardEdition!, completion: { error in
                    completedProgress+=1
                    if let error = error {
                        completion(error)
                        return
                    } else {
                        if completedProgress == totalProgress {
                            completion(nil)
                            return
                        }
                    }
                })
            }
        }
    }
    
    func removeSongFromRemixes(son: String, completion: @escaping ((Error?) -> Void)) {
        guard son.count == 10 else {
            completion(nil)
            return
        }
        DatabaseManager.shared.findSongById(songId: son, completion: {[weak self] result in
            guard let strongSelf = self else {return}
            switch result {
            case .success(let song):
                let ref = Database.database().reference().child("Music Content").child("Songs").child( "\(songContentTag)--\(song.name)--\(song.toneDeafAppId)").child("REQUIRED").child("Remixes")
                var arrto:[String] = []
                if var arrrr = song.remixes {
                    if arrrr.contains(strongSelf.currSong.toneDeafAppId) {
                        let index = arrrr.firstIndex(of: strongSelf.currSong.toneDeafAppId)
                        arrrr.remove(at: index!)
                        song.remixes = arrrr.sorted()
                        arrto = arrrr.sorted()
                    }
                }
                ref.setValue(arrto, withCompletionBlock: { error, reference in
                    if let error = error {
                        completion(error)
                        return
                    }
                    else {
                        completion(nil)
                        return
                    }
                })
            case .failure(let err):
                print("dsvgredfxbdfzx"+err.localizedDescription)
            }
        })
    }
    
    func addSongToRemixes(son: String, completion: @escaping ((Error?) -> Void)) {
        guard son.count == 10 else {
            completion(nil)
            return
        }
        DatabaseManager.shared.findSongById(songId: son, completion: {[weak self] result in
            guard let strongSelf = self else {return}
            switch result {
            case .success(let song):
                let ref = Database.database().reference().child("Music Content").child("Songs").child( "\(songContentTag)--\(song.name)--\(song.toneDeafAppId)").child("REQUIRED").child("Remixes")
                var arrto:[String] = []
                if var allArt = song.remixes {
                    if !allArt.contains(strongSelf.currSong.toneDeafAppId) {
                        allArt.append(strongSelf.currSong.toneDeafAppId)
                        arrto = allArt.sorted()
                    }
                } else {
                    arrto = [strongSelf.currSong.toneDeafAppId]
                }
                ref.setValue(arrto, withCompletionBlock: { error, reference in
                    if let error = error {
                        completion(error)
                        return
                    }
                    else {
                        completion(nil)
                        return
                    }
                })
            case .failure(let err):
                print("dsvgredfxbdfzx"+err.localizedDescription)
            }
        })
    }
    
    //MARK: - IsOtherVersions
    func processIsOtherVersions(initialSong: SongData, currentSong: SongData,initSE: String?, completion: @escaping (([Error]?) -> Void)) {
        initSong = initialSong
        currSong = currentSong
        var errors:[Error] = []
        initRef = Database.database().reference().child("Music Content").child("Songs").child("\(songContentTag)--\(initSong.name)--\(initSong.toneDeafAppId)")
        currRef = Database.database().reference().child("Music Content").child("Songs").child("\(songContentTag)--\(currSong.name)--\(currSong.toneDeafAppId)")
        var dataUploadCompletionStatus1:Bool!
        var dataUploadCompletionStatus2:Bool!
        
        let aqueue = DispatchQueue(label: "myhjvkheditingQsongOtherVersionshfdChangessseue")
        let agroup = DispatchGroup()
        let array:[Int] = [1,2]
        for i in array {
            agroup.enter()
            aqueue.async { [weak self] in
                guard let strongSelf = self else {return}
                switch i {
                case 1:
                    strongSelf.updateOtherVersionSongOtherVersions(ref: strongSelf.currRef,initSE:initSE, completion: {err in
                        if let error = err {
                            dataUploadCompletionStatus1 = false
                            errors.append(error)
                        } else {
                            dataUploadCompletionStatus1 = true
                            print("OtherVersion Song OtherVersions Update done \(i)")
                        }
                        agroup.leave()
                    })
                case 2:
                    strongSelf.updateSongIsOtherVersion(ref: strongSelf.currRef, completion: {err in
                        if let error = err {
                            dataUploadCompletionStatus1 = false
                            errors.append(error)
                        } else {
                            dataUploadCompletionStatus1 = true
                            print("Song Is OtherVersion Update done \(i)")
                        }
                        agroup.leave()
                    })
                default:
                    break
                }
            }
        }
        agroup.notify(queue: DispatchQueue.main) {
            if dataUploadCompletionStatus1 == false || dataUploadCompletionStatus2 == false {
                completion(errors)
                return
            } else {
                completion(nil)
            }
        }
    }
    
    func updateSongIsOtherVersion(ref: DatabaseReference, completion: @escaping ((Error?) -> Void)) {
//        if currSong.isRemix == initSong.isRemix {
//            completion(nil)
//            return
//        }
        var arrto:NSDictionary!
        let ref = ref.child("REQUIRED").child("Other Version")
        if currSong.isOtherVersion != nil {
            arrto = [
                "Standard Edition": currSong.isOtherVersion?.standardEdition,
                "Status": true
            ]
        }
        
        ref.setValue(arrto, withCompletionBlock: { error, reference in
            if let error = error {
                completion(error)
                return
            }
            else {
                completion(nil)
                return
            }
        })
    }
    
    func updateOtherVersionSongOtherVersions(ref: DatabaseReference,initSE: String?, completion: @escaping ((Error?) -> Void)) {
        var totalProgress:Int = 0
        var completedProgress:Int = 0
        
        if currSong.isOtherVersion?.standardEdition == nil && initSE == nil {
            completion(nil)
            return
        }
        if currSong.isOtherVersion?.standardEdition == initSE {
            completion(nil)
            return
        }
        
        if initSE != nil {
            totalProgress+=1
            if currSong.isOtherVersion?.standardEdition != nil {
                totalProgress+=1
            }
        } else {
            if currSong.isOtherVersion?.standardEdition != nil {
                totalProgress+=1
            }
        }
        
        if totalProgress == 0 {
            completion(nil)
            return
        }
        
        if initSE != nil {
            removeSongFromOtherVersions(son: initSE!, completion: { error in
                completedProgress+=1
                if let error = error {
                    completion(error)
                    return
                } else {
                    if completedProgress == totalProgress {
                        completion(nil)
                        return
                    }
                }
            })
            if currSong.isOtherVersion?.standardEdition != nil {
                addSongToOtherVersions(son: currSong.isOtherVersion!.standardEdition!, completion: { error in
                    completedProgress+=1
                    if let error = error {
                        completion(error)
                        return
                    } else {
                        if completedProgress == totalProgress {
                            completion(nil)
                            return
                        }
                    }
                })
            }
        } else {
            if currSong.isOtherVersion?.standardEdition != nil {
                addSongToOtherVersions(son: currSong.isOtherVersion!.standardEdition!, completion: { error in
                    completedProgress+=1
                    if let error = error {
                        completion(error)
                        return
                    } else {
                        if completedProgress == totalProgress {
                            completion(nil)
                            return
                        }
                    }
                })
            }
        }
    }
    
    func removeSongFromOtherVersions(son: String, completion: @escaping ((Error?) -> Void)) {
        guard son.count == 10 else {
            completion(nil)
            return
        }
        DatabaseManager.shared.findSongById(songId: son, completion: {[weak self] result in
            guard let strongSelf = self else {return}
            switch result {
            case .success(let song):
                let ref = Database.database().reference().child("Music Content").child("Songs").child( "\(songContentTag)--\(song.name)--\(song.toneDeafAppId)").child("REQUIRED").child("Other Versions")
                var arrto:[String] = []
                if var arrrr = song.otherVersions {
                    if arrrr.contains(strongSelf.currSong.toneDeafAppId) {
                        let index = arrrr.firstIndex(of: strongSelf.currSong.toneDeafAppId)
                        arrrr.remove(at: index!)
                        song.otherVersions = arrrr.sorted()
                        arrto = arrrr.sorted()
                    }
                }
                ref.setValue(arrto, withCompletionBlock: { error, reference in
                    if let error = error {
                        completion(error)
                        return
                    }
                    else {
                        completion(nil)
                        return
                    }
                })
            case .failure(let err):
                print("dsvgredfxbdfzx"+err.localizedDescription)
            }
        })
    }
    
    func addSongToOtherVersions(son: String, completion: @escaping ((Error?) -> Void)) {
        guard son.count == 10 else {
            completion(nil)
            return
        }
        DatabaseManager.shared.findSongById(songId: son, completion: {[weak self] result in
            guard let strongSelf = self else {return}
            switch result {
            case .success(let song):
                let ref = Database.database().reference().child("Music Content").child("Songs").child( "\(songContentTag)--\(song.name)--\(song.toneDeafAppId)").child("REQUIRED").child("Other Versions")
                var arrto:[String] = []
                if var allArt = song.otherVersions {
                    if !allArt.contains(strongSelf.currSong.toneDeafAppId) {
                        allArt.append(strongSelf.currSong.toneDeafAppId)
                        arrto = allArt.sorted()
                    }
                } else {
                    arrto = [strongSelf.currSong.toneDeafAppId]
                }
                ref.setValue(arrto, withCompletionBlock: { error, reference in
                    if let error = error {
                        completion(error)
                        return
                    }
                    else {
                        completion(nil)
                        return
                    }
                })
            case .failure(let err):
                print("dsvgredfxbdfzx"+err.localizedDescription)
            }
        })
    }
    
    //MARK: - Verification Level
    func processVerificationLevel(initialSong: SongData, currentSong: SongData, completion: @escaping ((Error?) -> Void)) {
        initSong = initialSong
        currSong = currentSong
        let ref = Database.database().reference().child("Music Content").child("Songs").child("\(songContentTag)--\(currSong.name)--\(currSong.toneDeafAppId)").child("REQUIRED").child("Verification Level")
        ref.setValue(String(currSong.verificationLevel!), withCompletionBlock: { error, reference in
            if let error = error {
                completion(error)
                return
            }
            else {
                completion(nil)
                return
            }
        })
    }
    
    //MARK: - Industry Certification
    func processIndustryCertification(initialSong: SongData, currentSong: SongData, completion: @escaping ((Error?) -> Void)) {
        initSong = initialSong
        currSong = currentSong
        let ref = Database.database().reference().child("Music Content").child("Songs").child("\(songContentTag)--\(currSong.name)--\(currSong.toneDeafAppId)").child("REQUIRED").child("Industry Certified")
        ref.setValue(currSong.industryCerified!, withCompletionBlock: { error, reference in
            if let error = error {
                completion(error)
                return
            }
            else {
                completion(nil)
                return
            }
        })
    }
    
    //MARK: - Status
    func processStatus(initialSong: SongData, currentSong: SongData, completion: @escaping ((Error?) -> Void)) {
        initSong = initialSong
        currSong = currentSong
        let ref = Database.database().reference().child("Music Content").child("Songs").child("\(songContentTag)--\(currSong.name)--\(currSong.toneDeafAppId)").child("REQUIRED").child("Active Status")
        ref.setValue(currSong.isActive, withCompletionBlock: { error, reference in
            if let error = error {
                completion(error)
                return
            }
            else {
                completion(nil)
                return
            }
        })
    }
    
    //MARK: - Cancel
    func cancelUpdate(initialSong: SongData, currentSong: SongData, initialStatus:NSDictionary, currentStatus:NSDictionary, initialURL:NSDictionary, currentURL:NSDictionary, completion: @escaping (([Error]?) -> Void)) {
        currSong = currentSong
        currURLDict = currentURL
        currStatusDict = currentStatus
        initSong = initialSong
        initURLDict = initialURL
        initStatusDict = initialStatus
        
        var errors:[Error] = []
        initRef = Database.database().reference().child("Music Content").child("Songs").child("\(songContentTag)--\(initSong.name)--\(initSong.toneDeafAppId)").child("REQUIRED")
        currRef = Database.database().reference().child("Music Content").child("Songs").child("\(songContentTag)--\(currSong.name)--\(currSong.toneDeafAppId)").child("REQUIRED")
        
        var dataUploadCompletionStatus1:Bool!
        var dataUploadCompletionStatus2:Bool!
        var dataUploadCompletionStatus3:Bool!
        var dataUploadCompletionStatus4:Bool!
        let queue = DispatchQueue(label: "myhjvkheditingQsongsCancelssseue")
        let group = DispatchGroup()
        var array:[Int] = []
        if currRef != initRef {
//            array.append(1)
        }
        if currentSong.manualImageURL != initialSong.manualImageURL || initImage != currImage {
            array.append(2)
        }
        for i in array {
            group.enter()
            queue.async { [weak self] in
                guard let strongSelf = self else {return}
                switch i {
                case 2:
                    strongSelf.revertImage(completion: {err in
                        if let error = err {
                            dataUploadCompletionStatus2 = false
                            errors.append(error)
                        } else {
                            dataUploadCompletionStatus2 = true
                            print("Image revert done \(i)")
                        }
                        group.leave()
                    })
                default:
                    print("Edit Song error")
                }
            }
        }
        
        group.notify(queue: DispatchQueue.main) {
            if dataUploadCompletionStatus1 == false || dataUploadCompletionStatus2 == false || dataUploadCompletionStatus3 == false || dataUploadCompletionStatus4 == false {
                completion(errors)
                return
            } else {
                completion(nil)
            }
        }
    }
    
    //MARK: - Revert Image
    func revertImage(completion: @escaping ((Error?) -> Void)) {
        initRef.child("Manual Image URL").setValue(initSong.manualImageURL, withCompletionBlock: { error, reference in
            if let error = error {
                completion(error)
                return
            }
            else {
                completion(nil)
                return
            }
        })
    }
    
}
    
enum SongEditorError: Error {
    case imageUpdateError(String)
    case previewUpdateError(String)
    case nameUpdateError(String)
    case spotifyUpdateError(String)
    case appleUpdateError(String)
    case soundcloudUpdateError(String)
    case youtubeMusicUpdateError(String)
    case amazonUpdateError(String)
    case deezerUpdateError(String)
    case tidalUpdateError(String)
    case napsterUpdateError(String)
    case spinrillaUpdateError(String)
}
