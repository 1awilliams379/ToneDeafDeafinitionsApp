//
//  EditAlbumHelper.swift
//  ToneDeafDeafinitionsApp
//
//  Created by Tone Deaf on 8/14/22.
//  Copyright © 2022 GITEM Solutions. All rights reserved.
//

import Foundation
import FirebaseDatabase
import FirebaseStorage

class EditAlbumHelper {
    static let shared = EditAlbumHelper()
    
    var initAlbum:AlbumData!
    var initStatusDict:NSDictionary!
    var initRef:DatabaseReference!
    var initURLDict:NSDictionary!
    //Initial Images
    var initImage:UIImage!
    var initImageDBURL:String!
    //Initial Preview
    var initPreview:URL!
    var initPreviewDBURL:String!
    
    var currAlbum:AlbumData!
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
    func processImage(initialAlbum: AlbumData, currentAlbum: AlbumData, image: UIImage?, completion: @escaping ((Error?) -> Void)) {
        initAlbum = initialAlbum
        currAlbum = currentAlbum
        currImage = image
        guard currentAlbum.manualImageURL != initialAlbum.manualImageURL else {
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
                            Database.database().reference().child("Music Content").child("Albums").child("\(albumContentTag)--\(strongSelf.currAlbum.name)--\(strongSelf.currAlbum.toneDeafAppId)").child("REQUIRED").child("Manual Image URL").removeValue()
                            completion(nil)
                            return
                        }
                        
                        strongSelf.storeImage(album: strongSelf.currAlbum, image: strongSelf.currImage, imageURL: "curr", completion: { err in
                            if let error = err {
                                completion(error)
                                return
                            } else {
                                var array:String!
                                
                                array = strongSelf.currImageDBURL
                                Database.database().reference().child("Music Content").child("Albums").child("\(albumContentTag)--\(strongSelf.currAlbum.name)--\(strongSelf.currAlbum.toneDeafAppId)").child("REQUIRED").child("Manual Image URL").setValue(array)
                                completion(nil)
                            }
                        })
                    }
                })
            }
        })
    }
    
    fileprivate func getDBURLs(completion: @escaping ((Error?) -> Void)) {
        Database.database().reference().child("Music Content").child("Albums").child("\(albumContentTag)--\(currAlbum.name)--\(currAlbum.toneDeafAppId)").child("REQUIRED").child("Manual Image URL").observeSingleEvent(of: .value, with: {[weak self] snap in
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
        Storage.storage().reference().child("Image Defaults").child("Manual Albums").child("\(currAlbum.toneDeafAppId)").child("Images").listAll(completion: {[weak self] listResult, err in
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
                                completion(AlbumEditorError.imageUpdateError("Storage download url error"))
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
        Storage.storage().reference().child("Image Defaults").child("Manual Albums").child("\(currAlbum.toneDeafAppId)").child("Images").listAll(completion: {[weak self] listResult, err in
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
                                Database.database().reference().child("Music Content").child("Albums").child("\(albumContentTag)--\(strongSelf.currAlbum.name)--\(strongSelf.currAlbum.toneDeafAppId)").child("REQUIRED").child("Manual Image URL").removeValue()
                                completion(nil)
                                return
                            }
                        }
                        
                    })
                }
            }
        })
    }
    
    fileprivate func storeImage(album: AlbumData, image:UIImage, imageURL:String, completion: @escaping ((Error?) -> Void)) {
        
        guard let data = image.pngData() else {
            completion(AlbumEditorError.imageUpdateError("Error converting image to png"))
            return}
        StorageManager.shared.uploadImage(album: data, fileName: "\(currAlbum.toneDeafAppId)", completion: {[weak self] result in
            
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
    func processPreview(initialAlbum: AlbumData, currentAlbum: AlbumData, audio: URL?, completion: @escaping ((Error?) -> Void)) {
        initAlbum = initialAlbum
        currAlbum = currentAlbum
        currPreview = audio
        guard currentAlbum.manualPreviewURL != initialAlbum.manualPreviewURL else {
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
                            Database.database().reference().child("Music Content").child("Albums").child("\(albumContentTag)--\(strongSelf.currAlbum.name)--\(strongSelf.currAlbum.toneDeafAppId)").child("REQUIRED").child("Manual Preview URL").removeValue()
                            completion(nil)
                            return
                        }
                        
                        strongSelf.storePreview(album: strongSelf.currAlbum, preview: strongSelf.currPreview, previewURL: "curr", completion: { err in
                            if let error = err {
                                completion(error)
                                return
                            } else {
                                var array:String!
                                
                                array = strongSelf.currPreviewDBURL
                                Database.database().reference().child("Music Content").child("Albums").child("\(albumContentTag)--\(strongSelf.currAlbum.name)--\(strongSelf.currAlbum.toneDeafAppId)").child("REQUIRED").child("Manual Preview URL").setValue(array)
                                completion(nil)
                            }
                        })
                    }
                })
            }
        })
    }
    
    fileprivate func getPreviewDBURLs(completion: @escaping ((Error?) -> Void)) {
        Database.database().reference().child("Music Content").child("Albums").child("\(albumContentTag)--\(currAlbum.name)--\(currAlbum.toneDeafAppId)").child("REQUIRED").child("Manual Preview URL").observeSingleEvent(of: .value, with: {[weak self] snap in
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
        Storage.storage().reference().child("Audio Defaults").child("Manual Albums").child("\(currAlbum.toneDeafAppId)").child("Previews").listAll(completion: {[weak self] listResult, err in
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
                                completion(AlbumEditorError.previewUpdateError("Storage download url error"))
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
        Storage.storage().reference().child("Audio Defaults").child("Manual Albums").child("\(currAlbum.toneDeafAppId)").child("Previews").listAll(completion: {[weak self] listResult, err in
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
                                Database.database().reference().child("Music Content").child("Albums").child("\(albumContentTag)--\(strongSelf.currAlbum.name)--\(strongSelf.currAlbum.toneDeafAppId)").child("REQUIRED").child("Manual Preview URL").removeValue()
                                completion(nil)
                                return
                            }
                        }
                        
                    })
                }
            }
        })
    }
    
    fileprivate func storePreview(album: AlbumData, preview:URL, previewURL:String, completion: @escaping ((Error?) -> Void)) {
        StorageManager.shared.uploadPreview(album: preview, fileName: "\(currAlbum.toneDeafAppId)", completion: {[weak self] result in
            
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
    func processName(initialAlbum: AlbumData, currentAlbum: AlbumData, completion: @escaping (([Error]?) -> Void)) {
        initAlbum = initialAlbum
        currAlbum = currentAlbum
        
        initRef = Database.database().reference().child("Music Content").child("Albums").child("\(albumContentTag)--\(initAlbum.name)--\(initAlbum.toneDeafAppId)")
        currRef = Database.database().reference().child("Music Content").child("Albums").child("\(albumContentTag)--\(currAlbum.name)--\(currAlbum.toneDeafAppId)")
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
        
        let aqueue = DispatchQueue(label: "myhjvkheditingQalbumNamep1Changessseue")
        let agroup = DispatchGroup()
        agroup.enter()
        aqueue.async { [weak self] in
            guard let strongSelf = self else {return}
            strongSelf.setNewKeyForAlbumInDB(initref: strongSelf.initRef, newref: strongSelf.currRef, completion: {err in
                if let error = err {
                    dataUploadCompletionStatus1 = false
                    errors.append(error)
                } else {
                    dataUploadCompletionStatus1 = true
                    print("Album name Update done \(1)")
                }
                agroup.leave()
            })
        }
        agroup.notify(queue: DispatchQueue.main) {
            if dataUploadCompletionStatus1 == false {
                completion(errors)
                return
            } else {
                let queue = DispatchQueue(label: "myhjvkheditingQalbumNameChangessseue")
                let group = DispatchGroup()
                let array:[Int] = [2,3,4,5,6,7,8,9,10]
                for i in array {
                    group.enter()
                    queue.async { [weak self] in
                        guard let strongSelf = self else {return}
                        switch i {
                        case 2:
                            strongSelf.setNewKeyForAlbumSpotifyInDB(initref: strongSelf.initRef, newref: strongSelf.currRef, completion: {err in
                                if let error = err {
                                    dataUploadCompletionStatus2 = false
                                    errors.append(error)
                                } else {
                                    dataUploadCompletionStatus2 = true
                                    print("Album name Spotify Update done \(i)")
                                }
                                group.leave()
                            })
                        case 3:
                            strongSelf.setNewKeyForAlbumAppleInDB(initref: strongSelf.initRef, newref: strongSelf.currRef, completion: {err in
                                if let error = err {
                                    dataUploadCompletionStatus3 = false
                                    errors.append(error)
                                } else {
                                    dataUploadCompletionStatus3 = true
                                    print("Album name Apple Update done \(i)")
                                }
                                group.leave()
                            })
                        case 4:
                            strongSelf.setNewKeyForAlbumSoundcloudInDB(initref: strongSelf.initRef, newref: strongSelf.currRef, completion: {err in
                                if let error = err {
                                    dataUploadCompletionStatus4 = false
                                    errors.append(error)
                                } else {
                                    dataUploadCompletionStatus4 = true
                                    print("Album name Soundcloud Update done \(i)")
                                }
                                group.leave()
                            })
                        case 5:
                            strongSelf.setNewKeyForAlbumYoutubeMusicInDB(initref: strongSelf.initRef, newref: strongSelf.currRef, completion: {err in
                                if let error = err {
                                    dataUploadCompletionStatus5 = false
                                    errors.append(error)
                                } else {
                                    dataUploadCompletionStatus5 = true
                                    print("Album name Youtube Music Update done \(i)")
                                }
                                group.leave()
                            })
                        case 6:
                            strongSelf.setNewKeyForAlbumAmazonInDB(initref: strongSelf.initRef, newref: strongSelf.currRef, completion: {err in
                                if let error = err {
                                    dataUploadCompletionStatus6 = false
                                    errors.append(error)
                                } else {
                                    dataUploadCompletionStatus6 = true
                                    print("Album name Amazon Update done \(i)")
                                }
                                group.leave()
                            })
                        case 7:
                            strongSelf.setNewKeyForAlbumDeezerInDB(initref: strongSelf.initRef, newref: strongSelf.currRef, completion: {err in
                                if let error = err {
                                    dataUploadCompletionStatus7 = false
                                    errors.append(error)
                                } else {
                                    dataUploadCompletionStatus7 = true
                                    print("Album name Deezer Update done \(i)")
                                }
                                group.leave()
                            })
                        case 8:
                            strongSelf.setNewKeyForAlbumTidalInDB(initref: strongSelf.initRef, newref: strongSelf.currRef, completion: {err in
                                if let error = err {
                                    dataUploadCompletionStatus8 = false
                                    errors.append(error)
                                } else {
                                    dataUploadCompletionStatus8 = true
                                    print("Album name Tidal Update done \(i)")
                                }
                                group.leave()
                            })
                        case 9:
                            strongSelf.setNewKeyForAlbumNapsterInDB(initref: strongSelf.initRef, newref: strongSelf.currRef, completion: {err in
                                if let error = err {
                                    dataUploadCompletionStatus9 = false
                                    errors.append(error)
                                } else {
                                    dataUploadCompletionStatus9 = true
                                    print("Album name Napster Update done \(i)")
                                }
                                group.leave()
                            })
                        case 10:
                            strongSelf.setNewKeyForAlbumSpinrillaInDB(initref: strongSelf.initRef, newref: strongSelf.currRef, completion: {err in
                                if let error = err {
                                    dataUploadCompletionStatus10 = false
                                    errors.append(error)
                                } else {
                                    dataUploadCompletionStatus10 = true
                                    print("Album name Spinrilla Update done \(i)")
                                }
                                group.leave()
                            })
                        default:
                            print("Edit Album error")
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
    
    func setNewKeyForAlbumInDB(initref: DatabaseReference, newref: DatabaseReference, completion: @escaping ((Error?) -> Void)) {
        initref.observeSingleEvent(of: .value, with: {[weak self] result in
            guard let strongSelf = self else {return}
            newref.setValue(result.value, withCompletionBlock: { error, reference in
                if let error = error {
                    completion(error)
                    return
                }
                else {
                    initref.removeValue()
                    strongSelf.updateAlbumName(newref: newref, completion: { error in
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
    
    func updateAlbumName(newref: DatabaseReference, completion: @escaping ((Error?) -> Void)) {
        newref.child("REQUIRED").child("Name").setValue(currAlbum.name, withCompletionBlock: { error, reference in
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
    
    func setNewKeyForAlbumSpotifyInDB(initref: DatabaseReference, newref: DatabaseReference, completion: @escaping ((Error?) -> Void)) {
        var initiref = initref
        var initkey:String!
        var currenref = newref
        var currkey:String!
        if initAlbum.spotify != nil {
            initkey = "\(spotifyMusicContentType)--\(initAlbum.name)--\(initAlbum.dateRegisteredToApp)--\(initAlbum.timeRegisteredToApp)"
            currkey = "\(spotifyMusicContentType)--\(currAlbum.name)--\(currAlbum.dateRegisteredToApp)--\(currAlbum.timeRegisteredToApp)"
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
    
    func setNewKeyForAlbumAppleInDB(initref: DatabaseReference, newref: DatabaseReference, completion: @escaping ((Error?) -> Void)) {
        var initiref = initref
        var initkey:String!
        var currenref = newref
        var currkey:String!
        if initAlbum.apple != nil {
            initkey = "\(appleMusicContentType)--\(initAlbum.name)--\(initAlbum.dateRegisteredToApp)--\(initAlbum.timeRegisteredToApp)"
            currkey = "\(appleMusicContentType)--\(currAlbum.name)--\(currAlbum.dateRegisteredToApp)--\(currAlbum.timeRegisteredToApp)"
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
    
    func setNewKeyForAlbumSoundcloudInDB(initref: DatabaseReference, newref: DatabaseReference, completion: @escaping ((Error?) -> Void)) {
        var initiref = initref
        var initkey:String!
        var currenref = newref
        var currkey:String!
        if initAlbum.soundcloud != nil {
            initkey = "\(soundcloudMusicContentType)--\(initAlbum.name)--\(initAlbum.dateRegisteredToApp)--\(initAlbum.timeRegisteredToApp)"
            currkey = "\(soundcloudMusicContentType)--\(currAlbum.name)--\(currAlbum.dateRegisteredToApp)--\(currAlbum.timeRegisteredToApp)"
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
    
    func setNewKeyForAlbumYoutubeMusicInDB(initref: DatabaseReference, newref: DatabaseReference, completion: @escaping ((Error?) -> Void)) {
        var initiref = initref
        var initkey:String!
        var currenref = newref
        var currkey:String!
        if initAlbum.youtubeMusic != nil {
            initkey = "\(youtubeMusicContentType)--\(initAlbum.name)--\(initAlbum.dateRegisteredToApp)--\(initAlbum.timeRegisteredToApp)"
            currkey = "\(youtubeMusicContentType)--\(currAlbum.name)--\(currAlbum.dateRegisteredToApp)--\(currAlbum.timeRegisteredToApp)"
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
    
    func setNewKeyForAlbumAmazonInDB(initref: DatabaseReference, newref: DatabaseReference, completion: @escaping ((Error?) -> Void)) {
        var initiref = initref
        var initkey:String!
        var currenref = newref
        var currkey:String!
        if initAlbum.amazon != nil {
            initkey = "\(amazonMusicContentType)--\(initAlbum.name)--\(initAlbum.dateRegisteredToApp)--\(initAlbum.timeRegisteredToApp)"
            currkey = "\(amazonMusicContentType)--\(currAlbum.name)--\(currAlbum.dateRegisteredToApp)--\(currAlbum.timeRegisteredToApp)"
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
    
    func setNewKeyForAlbumDeezerInDB(initref: DatabaseReference, newref: DatabaseReference, completion: @escaping ((Error?) -> Void)) {
        var initiref = initref
        var initkey:String!
        var currenref = newref
        var currkey:String!
        if initAlbum.deezer != nil {
            initkey = "\(deezerMusicContentType)--\(initAlbum.name)--\(initAlbum.dateRegisteredToApp)--\(initAlbum.timeRegisteredToApp)"
            currkey = "\(deezerMusicContentType)--\(currAlbum.name)--\(currAlbum.dateRegisteredToApp)--\(currAlbum.timeRegisteredToApp)"
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
    
    func setNewKeyForAlbumTidalInDB(initref: DatabaseReference, newref: DatabaseReference, completion: @escaping ((Error?) -> Void)) {
        var initiref = initref
        var initkey:String!
        var currenref = newref
        var currkey:String!
        if initAlbum.tidal != nil {
            initkey = "\(tidalMusicContentType)--\(initAlbum.name)--\(initAlbum.dateRegisteredToApp)--\(initAlbum.timeRegisteredToApp)"
            currkey = "\(tidalMusicContentType)--\(currAlbum.name)--\(currAlbum.dateRegisteredToApp)--\(currAlbum.timeRegisteredToApp)"
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
    
    func setNewKeyForAlbumNapsterInDB(initref: DatabaseReference, newref: DatabaseReference, completion: @escaping ((Error?) -> Void)) {
        var initiref = initref
        var initkey:String!
        var currenref = newref
        var currkey:String!
        if initAlbum.napster != nil {
            initkey = "\(napsterMusicContentType)--\(initAlbum.name)--\(initAlbum.dateRegisteredToApp)--\(initAlbum.timeRegisteredToApp)"
            currkey = "\(napsterMusicContentType)--\(currAlbum.name)--\(currAlbum.dateRegisteredToApp)--\(currAlbum.timeRegisteredToApp)"
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
    
    func setNewKeyForAlbumSpinrillaInDB(initref: DatabaseReference, newref: DatabaseReference, completion: @escaping ((Error?) -> Void)) {
        var initiref = initref
        var initkey:String!
        var currenref = newref
        var currkey:String!
        if initAlbum.spinrilla != nil {
            initkey = "\(spinrillaMusicContentType)--\(initAlbum.name)--\(initAlbum.dateRegisteredToApp)--\(initAlbum.timeRegisteredToApp)"
            currkey = "\(spinrillaMusicContentType)--\(currAlbum.name)--\(currAlbum.dateRegisteredToApp)--\(currAlbum.timeRegisteredToApp)"
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
    
    //MARK: - Main Artists
    func processMainArtists(initialAlbum: AlbumData, currentAlbum: AlbumData, completion: @escaping (([Error]?) -> Void)) {
        initAlbum = initialAlbum
        currAlbum = currentAlbum
        
        initRef = Database.database().reference().child("Music Content").child("Albums").child("\(albumContentTag)--\(initAlbum.name)--\(initAlbum.toneDeafAppId)")
        currRef = Database.database().reference().child("Music Content").child("Albums").child("\(albumContentTag)--\(currAlbum.name)--\(currAlbum.toneDeafAppId)")
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
        
        let aqueue = DispatchQueue(label: "myhjvkheditingQalbumMainArtisthfdChangessseue")
        let agroup = DispatchGroup()
        let array:[Int] = [1,2]
        for i in array {
            agroup.enter()
            aqueue.async { [weak self] in
                guard let strongSelf = self else {return}
                switch i {
                case 1:
                    strongSelf.updateAlbumMainArtists(ref: strongSelf.currRef, completion: {err in
                        if let error = err {
                            dataUploadCompletionStatus1 = false
                            errors.append(error)
                        } else {
                            dataUploadCompletionStatus1 = true
                            print("Album main artist Update done \(1)")
                        }
                        agroup.leave()
                    })
                case 2:
                    strongSelf.updateMainArtistAlbums(ref: strongSelf.currRef, completion: {err in
                        if let error = err {
                            dataUploadCompletionStatus2 = false
                            errors.append(error)
                        } else {
                            dataUploadCompletionStatus2 = true
                            print("Main Artist albums Update done \(1)")
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
    
    func updateAlbumMainArtists(ref: DatabaseReference, completion: @escaping ((Error?) -> Void)) {
        var initialArtistsArrFromDB:[String]!
        if currAlbum.mainArtist.sorted() == initAlbum.mainArtist.sorted() {
            completion(nil)
            return
        }
        getAlbumMainArtistsInDB(ref: ref, completion: {[weak self] persons in
            guard let strongSelf = self else {return}
            initialArtistsArrFromDB = persons.sorted()
            
            if !initialArtistsArrFromDB.isEmpty {
                var removalCounter = 0
                for i in 0 ... initialArtistsArrFromDB.count-1 {
                    if strongSelf.currAlbum.mainArtist != nil {
                        if i < strongSelf.currAlbum.mainArtist.count {
                            if !strongSelf.currAlbum.mainArtist[i].contains(initialArtistsArrFromDB[i]) {
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
            
            if strongSelf.currAlbum.mainArtist != nil {
                if !strongSelf.currAlbum.mainArtist.isEmpty {
                    for i in 0 ... strongSelf.currAlbum.mainArtist.count-1 {
                        if i < initialArtistsArrFromDB.count {
                            if !initialArtistsArrFromDB[i].contains(strongSelf.currAlbum.mainArtist[i]) {
                                initialArtistsArrFromDB.append(strongSelf.currAlbum.mainArtist[i])
                            }
                        } else {
                            initialArtistsArrFromDB.append(strongSelf.currAlbum.mainArtist[i])
                        }
                    }
                }
            }
            ref.child("REQUIRED").child("Main Artist").setValue(initialArtistsArrFromDB.sorted(), withCompletionBlock: { error, reference in
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
    
    func getAlbumMainArtistsInDB(ref: DatabaseReference, completion: @escaping (([String]) -> Void)) {
        ref.child("REQUIRED").child("Main Artist").observeSingleEvent(of: .value, with: { snapshot in
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
    
    func updateMainArtistAlbums(ref: DatabaseReference, completion: @escaping ((Error?) -> Void)) {
        var initialArtistsArrFromDB:[String]!
        var totalProgress:Int = 0
        var completedProgress:Int = 0
        if currAlbum.mainArtist.sorted() == initAlbum.mainArtist.sorted() {
            completion(nil)
            return
        }
        
        getAlbumMainArtistsInDB(ref: ref, completion: {[weak self] persons in
            guard let strongSelf = self else {return}
            initialArtistsArrFromDB = persons.sorted()
            
            if !initialArtistsArrFromDB.isEmpty {
                var removalCounter = 0
                for i in 0 ... initialArtistsArrFromDB.count-1 {
                    if strongSelf.currAlbum.mainArtist != nil {
                        if i < strongSelf.currAlbum.mainArtist.count {
                            if !strongSelf.currAlbum.mainArtist[i].contains(initialArtistsArrFromDB[i]) {
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
            
            if strongSelf.currAlbum.mainArtist != nil {
                if !strongSelf.currAlbum.mainArtist.isEmpty {
                    for i in 0 ... strongSelf.currAlbum.mainArtist.count-1 {
                        if i < initialArtistsArrFromDB.count {
                            if !initialArtistsArrFromDB[i].contains(strongSelf.currAlbum.mainArtist[i]) {
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
                    if strongSelf.currAlbum.mainArtist != nil {
                        if i < strongSelf.currAlbum.mainArtist.count {
                            if !strongSelf.currAlbum.mainArtist[i].contains(initialArtistsArrFromDB[i]) {
                                strongSelf.removeAlbumFromPerson(per: initialArtistsArrFromDB[i], completion: { error in
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
                            strongSelf.removeAlbumFromPerson(per: initialArtistsArrFromDB[i], completion: { error in
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
                        strongSelf.removeAlbumFromPerson(per: initialArtistsArrFromDB[i], completion: { error in
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
            
            if strongSelf.currAlbum.mainArtist != nil {
                if !strongSelf.currAlbum.mainArtist.isEmpty {
                    for i in 0 ... strongSelf.currAlbum.mainArtist.count-1 {
                        if i < initialArtistsArrFromDB.count {
                            if !initialArtistsArrFromDB[i].contains(strongSelf.currAlbum.mainArtist[i]) {
                                strongSelf.addAlbumToPerson(per: strongSelf.currAlbum.mainArtist[i], completion: { error in
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
                            strongSelf.addAlbumToPerson(per: strongSelf.currAlbum.mainArtist[i], completion: { error in
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
    
    func removeAlbumFromPerson(per: String, completion: @escaping ((Error?) -> Void)) {
        guard per.count == 6 else {
            completion(nil)
            return
        }
        var present:Bool = false
        if currAlbum.mainArtist.contains(per) {
            present = true
        }
        if currAlbum.allArtists != nil {
            if currAlbum.allArtists!.contains(per) {
                present = true
            }
        }
        if currAlbum.producers.contains(per) {
            present = true
        }
        if currAlbum.writers != nil {
            if currAlbum.writers!.contains(per) {
                present = true
            }
        }
        if currAlbum.mixEngineers != nil {
            if currAlbum.mixEngineers!.contains(per) {
                present = true
            }
        }
        if currAlbum.masteringEngineers != nil {
            if currAlbum.masteringEngineers!.contains(per) {
                present = true
            }
        }
        if currAlbum.recordingEngineers != nil {
            if currAlbum.recordingEngineers!.contains(per) {
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
                let ref = Database.database().reference().child("Registered Persons").child("\(person.name!)--\(person.dateRegisteredToApp!)--\(person.timeRegisteredToApp!)--\(person.toneDeafAppId)").child("Albums")
                let song = "\(strongSelf.currAlbum.toneDeafAppId)"
                var arrTo:[String] = []
                if var arrrr = person.albums {
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
    
    func addAlbumToPerson(per: String, completion: @escaping ((Error?) -> Void)) {
        guard per.count == 6 else {
            completion(nil)
            return
        }
        
        DatabaseManager.shared.fetchPersonData(person: per, completion: {[weak self] result in
            guard let strongSelf = self else {return}
            switch result {
            case .success(let person):
                let ref = Database.database().reference().child("Registered Persons").child("\(person.name!)--\(person.dateRegisteredToApp!)--\(person.timeRegisteredToApp!)--\(person.toneDeafAppId)").child("Albums")
                let song = "\(strongSelf.currAlbum.toneDeafAppId)"
                var arrTo:[String] = []
                if let psong = person.albums {
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
    
    //MARK: - All Artists
    func processAllArtists(initialAlbum: AlbumData, currentAlbum: AlbumData, completion: @escaping (([Error]?) -> Void)) {
        initAlbum = initialAlbum
        currAlbum = currentAlbum
        
        initRef = Database.database().reference().child("Music Content").child("Albums").child("\(albumContentTag)--\(initAlbum.name)--\(initAlbum.toneDeafAppId)")
        currRef = Database.database().reference().child("Music Content").child("Albums").child("\(albumContentTag)--\(currAlbum.name)--\(currAlbum.toneDeafAppId)")
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
        
        let aqueue = DispatchQueue(label: "myhjvkheditingQalbumAllArtisthfdChangessseue")
        let agroup = DispatchGroup()
        let array:[Int] = [1,2,3]
        for i in array {
            agroup.enter()
            aqueue.async { [weak self] in
                guard let strongSelf = self else {return}
                switch i {
                case 1:
                    strongSelf.updateAlbumAllArtists(ref: strongSelf.currRef, completion: {err in
                        if let error = err {
                            dataUploadCompletionStatus1 = false
                            errors.append(error)
                        } else {
                            dataUploadCompletionStatus1 = true
                            print("Album all artist Update done \(1)")
                        }
                        agroup.leave()
                    })
                case 2:
                    strongSelf.updateAllArtistAlbums(ref: strongSelf.currRef, completion: {err in
                        if let error = err {
                            dataUploadCompletionStatus2 = false
                            errors.append(error)
                        } else {
                            dataUploadCompletionStatus2 = true
                            print("All Artist albums Update done \(1)")
                        }
                        agroup.leave()
                    })
                case 3:
                    strongSelf.updateAllArtistRoles(ref: strongSelf.currRef, completion: {err in
                        if let error = err {
                            dataUploadCompletionStatus3 = false
                            errors.append(error)
                        } else {
                            dataUploadCompletionStatus3 = true
                            print("All Artist roles Update done \(1)")
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
    
    func updateAlbumAllArtists(ref: DatabaseReference, completion: @escaping ((Error?) -> Void)) {
        var initialArtistsArrFromDB:[String]!
        if currAlbum.allArtists!.sorted() == initAlbum.allArtists?.sorted() {
            completion(nil)
            return
        }
        getAlbumAllArtistsInDB(ref: ref, completion: {[weak self] persons in
            guard let strongSelf = self else {return}
            initialArtistsArrFromDB = persons.sorted()
            
            if !initialArtistsArrFromDB.isEmpty {
                var removalCounter = 0
                for i in 0 ... initialArtistsArrFromDB.count-1 {
                    if strongSelf.currAlbum.allArtists != nil {
                        if i < strongSelf.currAlbum.allArtists!.count {
                            if !strongSelf.currAlbum.allArtists![i].contains(initialArtistsArrFromDB[i]) {
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
            
            if strongSelf.currAlbum.allArtists != nil {
                if !strongSelf.currAlbum.allArtists!.isEmpty {
                    for i in 0 ... strongSelf.currAlbum.allArtists!.count-1 {
                        if i < initialArtistsArrFromDB.count {
                            if !initialArtistsArrFromDB[i].contains(strongSelf.currAlbum.allArtists![i]) {
                                initialArtistsArrFromDB.append(strongSelf.currAlbum.allArtists![i])
                            }
                        } else {
                            initialArtistsArrFromDB.append(strongSelf.currAlbum.allArtists![i])
                        }
                    }
                }
            }
            ref.child("REQUIRED").child("All Artist").setValue(initialArtistsArrFromDB.sorted(), withCompletionBlock: { error, reference in
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
    
    func getAlbumAllArtistsInDB(ref: DatabaseReference, completion: @escaping (([String]) -> Void)) {
        ref.child("REQUIRED").child("All Artist").observeSingleEvent(of: .value, with: { snapshot in
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
    
    func updateAllArtistAlbums(ref: DatabaseReference, completion: @escaping ((Error?) -> Void)) {
        var initialArtistsArrFromDB:[String]!
        var totalProgress:Int = 0
        var completedProgress:Int = 0
        if currAlbum.allArtists!.sorted() == initAlbum.allArtists?.sorted() {
            completion(nil)
            return
        }
        
        getAlbumAllArtistsInDB(ref: ref, completion: {[weak self] persons in
            guard let strongSelf = self else {return}
            initialArtistsArrFromDB = persons.sorted()
            
            if !initialArtistsArrFromDB.isEmpty {
                var removalCounter = 0
                for i in 0 ... initialArtistsArrFromDB.count-1 {
                    if strongSelf.currAlbum.allArtists != nil {
                        if i < strongSelf.currAlbum.allArtists!.count {
                            if !strongSelf.currAlbum.allArtists![i].contains(initialArtistsArrFromDB[i]) {
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
            
            if strongSelf.currAlbum.allArtists != nil {
                if !strongSelf.currAlbum.allArtists!.isEmpty {
                    for i in 0 ... strongSelf.currAlbum.allArtists!.count-1 {
                        if i < initialArtistsArrFromDB.count {
                            if !initialArtistsArrFromDB[i].contains(strongSelf.currAlbum.allArtists![i]) {
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
                    if strongSelf.currAlbum.allArtists != nil {
                        if i < strongSelf.currAlbum.allArtists!.count {
                            if !strongSelf.currAlbum.allArtists![i].contains(initialArtistsArrFromDB[i]) {
                                strongSelf.removeAlbumFromPerson(per: initialArtistsArrFromDB[i], completion: { error in
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
                            strongSelf.removeAlbumFromPerson(per: initialArtistsArrFromDB[i], completion: { error in
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
                        strongSelf.removeAlbumFromPerson(per: initialArtistsArrFromDB[i], completion: { error in
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
            
            if strongSelf.currAlbum.allArtists != nil {
                if !strongSelf.currAlbum.allArtists!.isEmpty {
                    for i in 0 ... strongSelf.currAlbum.allArtists!.count-1 {
                        if i < initialArtistsArrFromDB.count {
                            if !initialArtistsArrFromDB[i].contains(strongSelf.currAlbum.allArtists![i]) {
                                strongSelf.addAlbumToPerson(per: strongSelf.currAlbum.allArtists![i], completion: { error in
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
                            strongSelf.addAlbumToPerson(per: strongSelf.currAlbum.allArtists![i], completion: { error in
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
    
    func updateAllArtistRoles(ref: DatabaseReference, completion: @escaping ((Error?) -> Void)) {
        var initialArtistsArrFromDB:[String]!
        var totalProgress:Int = 0
        var completedProgress:Int = 0
        if currAlbum.allArtists!.sorted() == initAlbum.allArtists?.sorted() {
            completion(nil)
            return
        }
        
        getAlbumAllArtistsInDB(ref: ref, completion: {[weak self] persons in
            guard let strongSelf = self else {return}
            initialArtistsArrFromDB = persons.sorted()
            
            if !initialArtistsArrFromDB.isEmpty {
                for i in 0 ... initialArtistsArrFromDB.count-1 {
                    if strongSelf.currAlbum.allArtists != nil {
                        if i < strongSelf.currAlbum.allArtists!.count {
                            if !strongSelf.currAlbum.allArtists![i].contains(initialArtistsArrFromDB[i]) {
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
            
            if strongSelf.currAlbum.allArtists != nil {
                if !strongSelf.currAlbum.allArtists!.isEmpty {
                    for i in 0 ... strongSelf.currAlbum.allArtists!.count-1 {
                        if i < initialArtistsArrFromDB.count {
                            if !initialArtistsArrFromDB[i].contains(strongSelf.currAlbum.allArtists![i]) {
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
                    if strongSelf.currAlbum.allArtists != nil {
                        if i < strongSelf.currAlbum.allArtists!.count {
                            if !strongSelf.currAlbum.allArtists![i].contains(initialArtistsArrFromDB[i]) {
                                strongSelf.removeAlbumFromAllArtistRoles(per: initialArtistsArrFromDB[i], completion: { error in
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
                            strongSelf.removeAlbumFromAllArtistRoles(per: initialArtistsArrFromDB[i], completion: { error in
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
                        strongSelf.removeAlbumFromAllArtistRoles(per: initialArtistsArrFromDB[i], completion: { error in
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
            
            if strongSelf.currAlbum.allArtists != nil {
                if !strongSelf.currAlbum.allArtists!.isEmpty {
                    for i in 0 ... strongSelf.currAlbum.allArtists!.count-1 {
                        if i < initialArtistsArrFromDB.count {
                            if !initialArtistsArrFromDB[i].contains(strongSelf.currAlbum.allArtists![i]) {
                                strongSelf.addAlbumToAllArtistRoles(per: strongSelf.currAlbum.allArtists![i], completion: { error in
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
                            strongSelf.addAlbumToAllArtistRoles(per: strongSelf.currAlbum.allArtists![i], completion: { error in
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
    
    func removeAlbumFromAllArtistRoles(per: String, completion: @escaping ((Error?) -> Void)) {
        guard per.count == 6 else {
            completion(nil)
            return
        }
        DatabaseManager.shared.fetchPersonData(person: per, completion: {[weak self] result in
            guard let strongSelf = self else {return}
            switch result {
            case .success(let person):
                let ref = Database.database().reference().child("Registered Persons").child("\(person.name!)--\(person.dateRegisteredToApp!)--\(person.timeRegisteredToApp!)--\(person.toneDeafAppId)").child("Roles").child("Artist")
                let song = "\(strongSelf.currAlbum.toneDeafAppId)"
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
    
    func addAlbumToAllArtistRoles(per: String, completion: @escaping ((Error?) -> Void)) {
        guard per.count == 6 else {
            completion(nil)
            return
        }
        
        DatabaseManager.shared.fetchPersonData(person: per, completion: {[weak self] result in
            guard let strongSelf = self else {return}
            switch result {
            case .success(let person):
                let ref = Database.database().reference().child("Registered Persons").child("\(person.name!)--\(person.dateRegisteredToApp!)--\(person.timeRegisteredToApp!)--\(person.toneDeafAppId)").child("Roles").child("Artist")
                let song = "\(strongSelf.currAlbum.toneDeafAppId)"
                var arrTo:[String] = []
                
                if let roles = person.roles {
                    if var art = roles["Artist"] as? [String] {
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
    
    //MARK: - Producers
    func processProducers(initialAlbum: AlbumData, currentAlbum: AlbumData, completion: @escaping (([Error]?) -> Void)) {
        initAlbum = initialAlbum
        currAlbum = currentAlbum
        
        initRef = Database.database().reference().child("Music Content").child("Albums").child("\(albumContentTag)--\(initAlbum.name)--\(initAlbum.toneDeafAppId)")
        currRef = Database.database().reference().child("Music Content").child("Albums").child("\(albumContentTag)--\(currAlbum.name)--\(currAlbum.toneDeafAppId)")
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
        
        let aqueue = DispatchQueue(label: "myhjvkheditingQalbumProducershfdChangessseue")
        let agroup = DispatchGroup()
        let array:[Int] = [1,2,3]
        for i in array {
            agroup.enter()
            aqueue.async { [weak self] in
                guard let strongSelf = self else {return}
                switch i {
                case 1:
                    strongSelf.updateAlbumProducers(ref: strongSelf.currRef, completion: {err in
                        if let error = err {
                            dataUploadCompletionStatus1 = false
                            errors.append(error)
                        } else {
                            dataUploadCompletionStatus1 = true
                            print("Album Producers Update done \(1)")
                        }
                        agroup.leave()
                    })
                case 2:
                    strongSelf.updateProducerAlbums(ref: strongSelf.currRef, completion: {err in
                        if let error = err {
                            dataUploadCompletionStatus2 = false
                            errors.append(error)
                        } else {
                            dataUploadCompletionStatus2 = true
                            print("Producer albums Update done \(1)")
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
    
    func updateAlbumProducers(ref: DatabaseReference, completion: @escaping ((Error?) -> Void)) {
        var initialArtistsArrFromDB:[String]!
        if currAlbum.producers.sorted() == initAlbum.producers.sorted() {
            completion(nil)
            return
        }
        getAlbumProducersInDB(ref: ref, completion: {[weak self] persons in
            guard let strongSelf = self else {return}
            initialArtistsArrFromDB = persons.sorted()
            
            if !initialArtistsArrFromDB.isEmpty {
                var removalCounter = 0
                for i in 0 ... initialArtistsArrFromDB.count-1 {
                    if strongSelf.currAlbum.producers != nil {
                        if i < strongSelf.currAlbum.producers.count {
                            if !strongSelf.currAlbum.producers[i].contains(initialArtistsArrFromDB[i]) {
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
            
            if strongSelf.currAlbum.producers != nil {
                if !strongSelf.currAlbum.producers.isEmpty {
                    for i in 0 ... strongSelf.currAlbum.producers.count-1 {
                        if i < initialArtistsArrFromDB.count {
                            if !initialArtistsArrFromDB[i].contains(strongSelf.currAlbum.producers[i]) {
                                initialArtistsArrFromDB.append(strongSelf.currAlbum.producers[i])
                            }
                        } else {
                            initialArtistsArrFromDB.append(strongSelf.currAlbum.producers[i])
                        }
                    }
                }
            }
            ref.child("REQUIRED").child("All Producers").setValue(initialArtistsArrFromDB.sorted(), withCompletionBlock: { error, reference in
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
    
    func getAlbumProducersInDB(ref: DatabaseReference, completion: @escaping (([String]) -> Void)) {
        ref.child("REQUIRED").child("All Producers").observeSingleEvent(of: .value, with: { snapshot in
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
    
    func updateProducerAlbums(ref: DatabaseReference, completion: @escaping ((Error?) -> Void)) {
        var initialArtistsArrFromDB:[String]!
        var totalProgress:Int = 0
        var completedProgress:Int = 0
        if currAlbum.producers.sorted() == initAlbum.producers.sorted() {
            completion(nil)
            return
        }
        
        getAlbumProducersInDB(ref: ref, completion: {[weak self] persons in
            guard let strongSelf = self else {return}
            initialArtistsArrFromDB = persons.sorted()
            
            if !initialArtistsArrFromDB.isEmpty {
                var removalCounter = 0
                for i in 0 ... initialArtistsArrFromDB.count-1 {
                    if strongSelf.currAlbum.producers != nil {
                        if i < strongSelf.currAlbum.producers.count {
                            if !strongSelf.currAlbum.producers[i].contains(initialArtistsArrFromDB[i]) {
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
            
            if strongSelf.currAlbum.producers != nil {
                if !strongSelf.currAlbum.producers.isEmpty {
                    for i in 0 ... strongSelf.currAlbum.producers.count-1 {
                        if i < initialArtistsArrFromDB.count {
                            if !initialArtistsArrFromDB[i].contains(strongSelf.currAlbum.producers[i]) {
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
                    if strongSelf.currAlbum.producers != nil {
                        if i < strongSelf.currAlbum.producers.count {
                            if !strongSelf.currAlbum.producers[i].contains(initialArtistsArrFromDB[i]) {
                                strongSelf.removeAlbumFromPerson(per: initialArtistsArrFromDB[i], completion: { error in
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
                            strongSelf.removeAlbumFromPerson(per: initialArtistsArrFromDB[i], completion: { error in
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
                        strongSelf.removeAlbumFromPerson(per: initialArtistsArrFromDB[i], completion: { error in
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
            
            if strongSelf.currAlbum.producers != nil {
                if !strongSelf.currAlbum.producers.isEmpty {
                    for i in 0 ... strongSelf.currAlbum.producers.count-1 {
                        if i < initialArtistsArrFromDB.count {
                            if !initialArtistsArrFromDB[i].contains(strongSelf.currAlbum.producers[i]) {
                                strongSelf.addAlbumToPerson(per: strongSelf.currAlbum.producers[i], completion: { error in
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
                            strongSelf.addAlbumToPerson(per: strongSelf.currAlbum.producers[i], completion: { error in
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
        if currAlbum.producers.sorted() == initAlbum.producers.sorted() {
            completion(nil)
            return
        }
        
        getAlbumProducersInDB(ref: ref, completion: {[weak self] persons in
            guard let strongSelf = self else {return}
            initialArtistsArrFromDB = persons.sorted()
            
            if !initialArtistsArrFromDB.isEmpty {
                for i in 0 ... initialArtistsArrFromDB.count-1 {
                    if strongSelf.currAlbum.producers != nil {
                        if i < strongSelf.currAlbum.producers.count {
                            if !strongSelf.currAlbum.producers[i].contains(initialArtistsArrFromDB[i]) {
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
            
            if strongSelf.currAlbum.producers != nil {
                if !strongSelf.currAlbum.producers.isEmpty {
                    for i in 0 ... strongSelf.currAlbum.producers.count-1 {
                        if i < initialArtistsArrFromDB.count {
                            if !initialArtistsArrFromDB[i].contains(strongSelf.currAlbum.producers[i]) {
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
                    if strongSelf.currAlbum.producers != nil {
                        if i < strongSelf.currAlbum.producers.count {
                            if !strongSelf.currAlbum.producers[i].contains(initialArtistsArrFromDB[i]) {
                                strongSelf.removeAlbumFromProducerRoles(per: initialArtistsArrFromDB[i], completion: { error in
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
                            strongSelf.removeAlbumFromProducerRoles(per: initialArtistsArrFromDB[i], completion: { error in
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
                        strongSelf.removeAlbumFromProducerRoles(per: initialArtistsArrFromDB[i], completion: { error in
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
            
            if strongSelf.currAlbum.producers != nil {
                if !strongSelf.currAlbum.producers.isEmpty {
                    for i in 0 ... strongSelf.currAlbum.producers.count-1 {
                        if i < initialArtistsArrFromDB.count {
                            if !initialArtistsArrFromDB[i].contains(strongSelf.currAlbum.producers[i]) {
                                strongSelf.addAlbumToProducerRoles(per: strongSelf.currAlbum.producers[i], completion: { error in
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
                            strongSelf.addAlbumToProducerRoles(per: strongSelf.currAlbum.producers[i], completion: { error in
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
    
    func removeAlbumFromProducerRoles(per: String, completion: @escaping ((Error?) -> Void)) {
        guard per.count == 6 else {
            completion(nil)
            return
        }
        DatabaseManager.shared.fetchPersonData(person: per, completion: {[weak self] result in
            guard let strongSelf = self else {return}
            switch result {
            case .success(let person):
                let ref = Database.database().reference().child("Registered Persons").child("\(person.name!)--\(person.dateRegisteredToApp!)--\(person.timeRegisteredToApp!)--\(person.toneDeafAppId)").child("Roles").child("Producer")
                let song = "\(strongSelf.currAlbum.toneDeafAppId)"
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
    
    func addAlbumToProducerRoles(per: String, completion: @escaping ((Error?) -> Void)) {
        guard per.count == 6 else {
            completion(nil)
            return
        }
        
        DatabaseManager.shared.fetchPersonData(person: per, completion: {[weak self] result in
            guard let strongSelf = self else {return}
            switch result {
            case .success(let person):
                let ref = Database.database().reference().child("Registered Persons").child("\(person.name!)--\(person.dateRegisteredToApp!)--\(person.timeRegisteredToApp!)--\(person.toneDeafAppId)").child("Roles").child("Producer")
                let song = "\(strongSelf.currAlbum.toneDeafAppId)"
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
    
    //MARK: - Writers
    func processWriters(initialAlbum: AlbumData, currentAlbum: AlbumData, completion: @escaping (([Error]?) -> Void)) {
        initAlbum = initialAlbum
        currAlbum = currentAlbum
        
        initRef = Database.database().reference().child("Music Content").child("Albums").child("\(albumContentTag)--\(initAlbum.name)--\(initAlbum.toneDeafAppId)")
        currRef = Database.database().reference().child("Music Content").child("Albums").child("\(albumContentTag)--\(currAlbum.name)--\(currAlbum.toneDeafAppId)")
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
        
        let aqueue = DispatchQueue(label: "myhjvkheditingQalbumWritershfdChangessseue")
        let agroup = DispatchGroup()
        let array:[Int] = [1,2,3]
        for i in array {
            agroup.enter()
            aqueue.async { [weak self] in
                guard let strongSelf = self else {return}
                switch i {
                case 1:
                    strongSelf.updateAlbumWriters(ref: strongSelf.currRef, completion: {err in
                        if let error = err {
                            dataUploadCompletionStatus1 = false
                            errors.append(error)
                        } else {
                            dataUploadCompletionStatus1 = true
                            print("Album Writers Update done \(1)")
                        }
                        agroup.leave()
                    })
                case 2:
                    strongSelf.updateWriterAlbums(ref: strongSelf.currRef, completion: {err in
                        if let error = err {
                            dataUploadCompletionStatus2 = false
                            errors.append(error)
                        } else {
                            dataUploadCompletionStatus2 = true
                            print("Writer albums Update done \(1)")
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
    
    func updateAlbumWriters(ref: DatabaseReference, completion: @escaping ((Error?) -> Void)) {
        var initialArtistsArrFromDB:[String]!
        if currAlbum.writers!.sorted() == initAlbum.writers?.sorted() {
            completion(nil)
            return
        }
        getAlbumWritersInDB(ref: ref, completion: {[weak self] persons in
            guard let strongSelf = self else {return}
            initialArtistsArrFromDB = persons.sorted()
            
            if !initialArtistsArrFromDB.isEmpty {
                var removalCounter = 0
                for i in 0 ... initialArtistsArrFromDB.count-1 {
                    if strongSelf.currAlbum.writers != nil {
                        if i < strongSelf.currAlbum.writers!.count {
                            if !strongSelf.currAlbum.writers![i].contains(initialArtistsArrFromDB[i]) {
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
            
            if strongSelf.currAlbum.writers != nil {
                if !strongSelf.currAlbum.writers!.isEmpty {
                    for i in 0 ... strongSelf.currAlbum.writers!.count-1 {
                        if i < initialArtistsArrFromDB.count {
                            if !initialArtistsArrFromDB[i].contains(strongSelf.currAlbum.writers![i]) {
                                initialArtistsArrFromDB.append(strongSelf.currAlbum.writers![i])
                            }
                        } else {
                            initialArtistsArrFromDB.append(strongSelf.currAlbum.writers![i])
                        }
                    }
                }
            }
            ref.child("REQUIRED").child("All Writers").setValue(initialArtistsArrFromDB.sorted(), withCompletionBlock: { error, reference in
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
    
    func getAlbumWritersInDB(ref: DatabaseReference, completion: @escaping (([String]) -> Void)) {
        ref.child("REQUIRED").child("All Writers").observeSingleEvent(of: .value, with: { snapshot in
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
    
    func updateWriterAlbums(ref: DatabaseReference, completion: @escaping ((Error?) -> Void)) {
        var initialArtistsArrFromDB:[String]!
        var totalProgress:Int = 0
        var completedProgress:Int = 0
        if currAlbum.writers!.sorted() == initAlbum.writers?.sorted() {
            completion(nil)
            return
        }
        
        getAlbumWritersInDB(ref: ref, completion: {[weak self] persons in
            guard let strongSelf = self else {return}
            initialArtistsArrFromDB = persons.sorted()
            
            if !initialArtistsArrFromDB.isEmpty {
                var removalCounter = 0
                for i in 0 ... initialArtistsArrFromDB.count-1 {
                    if strongSelf.currAlbum.writers != nil {
                        if i < strongSelf.currAlbum.writers!.count {
                            if !strongSelf.currAlbum.writers![i].contains(initialArtistsArrFromDB[i]) {
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
            
            if strongSelf.currAlbum.writers != nil {
                if !strongSelf.currAlbum.writers!.isEmpty {
                    for i in 0 ... strongSelf.currAlbum.writers!.count-1 {
                        if i < initialArtistsArrFromDB.count {
                            if !initialArtistsArrFromDB[i].contains(strongSelf.currAlbum.writers![i]) {
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
                    if strongSelf.currAlbum.writers != nil {
                        if i < strongSelf.currAlbum.writers!.count {
                            if !strongSelf.currAlbum.writers![i].contains(initialArtistsArrFromDB[i]) {
                                strongSelf.removeAlbumFromPerson(per: initialArtistsArrFromDB[i], completion: { error in
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
                            strongSelf.removeAlbumFromPerson(per: initialArtistsArrFromDB[i], completion: { error in
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
                        strongSelf.removeAlbumFromPerson(per: initialArtistsArrFromDB[i], completion: { error in
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
            
            if strongSelf.currAlbum.writers != nil {
                if !strongSelf.currAlbum.writers!.isEmpty {
                    for i in 0 ... strongSelf.currAlbum.writers!.count-1 {
                        if i < initialArtistsArrFromDB.count {
                            if !initialArtistsArrFromDB[i].contains(strongSelf.currAlbum.writers![i]) {
                                strongSelf.addAlbumToPerson(per: strongSelf.currAlbum.writers![i], completion: { error in
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
                            strongSelf.addAlbumToPerson(per: strongSelf.currAlbum.writers![i], completion: { error in
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
        if currAlbum.writers!.sorted() == initAlbum.writers?.sorted() {
            completion(nil)
            return
        }
        
        getAlbumWritersInDB(ref: ref, completion: {[weak self] persons in
            guard let strongSelf = self else {return}
            initialArtistsArrFromDB = persons.sorted()
            
            if !initialArtistsArrFromDB.isEmpty {
                for i in 0 ... initialArtistsArrFromDB.count-1 {
                    if strongSelf.currAlbum.writers != nil {
                        if i < strongSelf.currAlbum.writers!.count {
                            if !strongSelf.currAlbum.writers![i].contains(initialArtistsArrFromDB[i]) {
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
            
            if strongSelf.currAlbum.writers != nil {
                if !strongSelf.currAlbum.writers!.isEmpty {
                    for i in 0 ... strongSelf.currAlbum.writers!.count-1 {
                        if i < initialArtistsArrFromDB.count {
                            if !initialArtistsArrFromDB[i].contains(strongSelf.currAlbum.writers![i]) {
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
                    if strongSelf.currAlbum.writers != nil {
                        if i < strongSelf.currAlbum.writers!.count {
                            if !strongSelf.currAlbum.writers![i].contains(initialArtistsArrFromDB[i]) {
                                strongSelf.removeAlbumFromWriterRoles(per: initialArtistsArrFromDB[i], completion: { error in
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
                            strongSelf.removeAlbumFromWriterRoles(per: initialArtistsArrFromDB[i], completion: { error in
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
                        strongSelf.removeAlbumFromWriterRoles(per: initialArtistsArrFromDB[i], completion: { error in
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
            
            if strongSelf.currAlbum.writers != nil {
                if !strongSelf.currAlbum.writers!.isEmpty {
                    for i in 0 ... strongSelf.currAlbum.writers!.count-1 {
                        if i < initialArtistsArrFromDB.count {
                            if !initialArtistsArrFromDB[i].contains(strongSelf.currAlbum.writers![i]) {
                                strongSelf.addAlbumToWriterRoles(per: strongSelf.currAlbum.writers![i], completion: { error in
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
                            strongSelf.addAlbumToWriterRoles(per: strongSelf.currAlbum.writers![i], completion: { error in
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
    
    func removeAlbumFromWriterRoles(per: String, completion: @escaping ((Error?) -> Void)) {
        guard per.count == 6 else {
            completion(nil)
            return
        }
        DatabaseManager.shared.fetchPersonData(person: per, completion: {[weak self] result in
            guard let strongSelf = self else {return}
            switch result {
            case .success(let person):
                let ref = Database.database().reference().child("Registered Persons").child("\(person.name!)--\(person.dateRegisteredToApp!)--\(person.timeRegisteredToApp!)--\(person.toneDeafAppId)").child("Roles").child("Writer")
                let song = "\(strongSelf.currAlbum.toneDeafAppId)"
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
    
    func addAlbumToWriterRoles(per: String, completion: @escaping ((Error?) -> Void)) {
        guard per.count == 6 else {
            completion(nil)
            return
        }
        
        DatabaseManager.shared.fetchPersonData(person: per, completion: {[weak self] result in
            guard let strongSelf = self else {return}
            switch result {
            case .success(let person):
                let ref = Database.database().reference().child("Registered Persons").child("\(person.name!)--\(person.dateRegisteredToApp!)--\(person.timeRegisteredToApp!)--\(person.toneDeafAppId)").child("Roles").child("Writer")
                let song = "\(strongSelf.currAlbum.toneDeafAppId)"
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
    
    //MARK: - Mix Engineers
    func processMixEngineers(initialAlbum: AlbumData, currentAlbum: AlbumData, completion: @escaping (([Error]?) -> Void)) {
        initAlbum = initialAlbum
        currAlbum = currentAlbum
        
        initRef = Database.database().reference().child("Music Content").child("Albums").child("\(albumContentTag)--\(initAlbum.name)--\(initAlbum.toneDeafAppId)")
        currRef = Database.database().reference().child("Music Content").child("Albums").child("\(albumContentTag)--\(currAlbum.name)--\(currAlbum.toneDeafAppId)")
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
        
        let aqueue = DispatchQueue(label: "myhjvkheditingQalbumMixEngineershfdChangessseue")
        let agroup = DispatchGroup()
        let array:[Int] = [1,2,3]
        for i in array {
            agroup.enter()
            aqueue.async { [weak self] in
                guard let strongSelf = self else {return}
                switch i {
                case 1:
                    strongSelf.updateAlbumMixEngineers(ref: strongSelf.currRef, completion: {err in
                        if let error = err {
                            dataUploadCompletionStatus1 = false
                            errors.append(error)
                        } else {
                            dataUploadCompletionStatus1 = true
                            print("Album MixEngineer Update done \(1)")
                        }
                        agroup.leave()
                    })
                case 2:
                    strongSelf.updateMixEngineerAlbums(ref: strongSelf.currRef, completion: {err in
                        if let error = err {
                            dataUploadCompletionStatus2 = false
                            errors.append(error)
                        } else {
                            dataUploadCompletionStatus2 = true
                            print("MixEngineer albums Update done \(1)")
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
    
    func updateAlbumMixEngineers(ref: DatabaseReference, completion: @escaping ((Error?) -> Void)) {
        var initialArtistsArrFromDB:[String]!
        if currAlbum.mixEngineers!.sorted() == initAlbum.mixEngineers?.sorted() {
            completion(nil)
            return
        }
        getAlbumMixEngineersInDB(ref: ref, completion: {[weak self] persons in
            guard let strongSelf = self else {return}
            initialArtistsArrFromDB = persons.sorted()
            
            if !initialArtistsArrFromDB.isEmpty {
                var removalCounter = 0
                for i in 0 ... initialArtistsArrFromDB.count-1 {
                    if strongSelf.currAlbum.mixEngineers != nil {
                        if i < strongSelf.currAlbum.mixEngineers!.count {
                            if !strongSelf.currAlbum.mixEngineers![i].contains(initialArtistsArrFromDB[i]) {
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
            
            if strongSelf.currAlbum.mixEngineers != nil {
                if !strongSelf.currAlbum.mixEngineers!.isEmpty {
                    for i in 0 ... strongSelf.currAlbum.mixEngineers!.count-1 {
                        if i < initialArtistsArrFromDB.count {
                            if !initialArtistsArrFromDB[i].contains(strongSelf.currAlbum.mixEngineers![i]) {
                                initialArtistsArrFromDB.append(strongSelf.currAlbum.mixEngineers![i])
                            }
                        } else {
                            initialArtistsArrFromDB.append(strongSelf.currAlbum.mixEngineers![i])
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
    
    func getAlbumMixEngineersInDB(ref: DatabaseReference, completion: @escaping (([String]) -> Void)) {
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
    
    func updateMixEngineerAlbums(ref: DatabaseReference, completion: @escaping ((Error?) -> Void)) {
        var initialArtistsArrFromDB:[String]!
        var totalProgress:Int = 0
        var completedProgress:Int = 0
        if currAlbum.mixEngineers!.sorted() == initAlbum.mixEngineers?.sorted() {
            completion(nil)
            return
        }
        
        getAlbumMixEngineersInDB(ref: ref, completion: {[weak self] persons in
            guard let strongSelf = self else {return}
            initialArtistsArrFromDB = persons.sorted()
            
            if !initialArtistsArrFromDB.isEmpty {
                var removalCounter = 0
                for i in 0 ... initialArtistsArrFromDB.count-1 {
                    if strongSelf.currAlbum.mixEngineers != nil {
                        if i < strongSelf.currAlbum.mixEngineers!.count {
                            if !strongSelf.currAlbum.mixEngineers![i].contains(initialArtistsArrFromDB[i]) {
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
            
            if strongSelf.currAlbum.mixEngineers != nil {
                if !strongSelf.currAlbum.mixEngineers!.isEmpty {
                    for i in 0 ... strongSelf.currAlbum.mixEngineers!.count-1 {
                        if i < initialArtistsArrFromDB.count {
                            if !initialArtistsArrFromDB[i].contains(strongSelf.currAlbum.mixEngineers![i]) {
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
                    if strongSelf.currAlbum.mixEngineers != nil {
                        if i < strongSelf.currAlbum.mixEngineers!.count {
                            if !strongSelf.currAlbum.mixEngineers![i].contains(initialArtistsArrFromDB[i]) {
                                strongSelf.removeAlbumFromPerson(per: initialArtistsArrFromDB[i], completion: { error in
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
                            strongSelf.removeAlbumFromPerson(per: initialArtistsArrFromDB[i], completion: { error in
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
                        strongSelf.removeAlbumFromPerson(per: initialArtistsArrFromDB[i], completion: { error in
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
            
            if strongSelf.currAlbum.mixEngineers != nil {
                if !strongSelf.currAlbum.mixEngineers!.isEmpty {
                    for i in 0 ... strongSelf.currAlbum.mixEngineers!.count-1 {
                        if i < initialArtistsArrFromDB.count {
                            if !initialArtistsArrFromDB[i].contains(strongSelf.currAlbum.mixEngineers![i]) {
                                strongSelf.addAlbumToPerson(per: strongSelf.currAlbum.mixEngineers![i], completion: { error in
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
                            strongSelf.addAlbumToPerson(per: strongSelf.currAlbum.mixEngineers![i], completion: { error in
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
        if currAlbum.mixEngineers!.sorted() == initAlbum.mixEngineers?.sorted() {
            completion(nil)
            return
        }
        
        getAlbumMixEngineersInDB(ref: ref, completion: {[weak self] persons in
            guard let strongSelf = self else {return}
            initialArtistsArrFromDB = persons.sorted()
            
            if !initialArtistsArrFromDB.isEmpty {
                for i in 0 ... initialArtistsArrFromDB.count-1 {
                    if strongSelf.currAlbum.mixEngineers != nil {
                        if i < strongSelf.currAlbum.mixEngineers!.count {
                            if !strongSelf.currAlbum.mixEngineers![i].contains(initialArtistsArrFromDB[i]) {
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
            
            if strongSelf.currAlbum.mixEngineers != nil {
                if !strongSelf.currAlbum.mixEngineers!.isEmpty {
                    for i in 0 ... strongSelf.currAlbum.mixEngineers!.count-1 {
                        if i < initialArtistsArrFromDB.count {
                            if !initialArtistsArrFromDB[i].contains(strongSelf.currAlbum.mixEngineers![i]) {
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
                    if strongSelf.currAlbum.mixEngineers != nil {
                        if i < strongSelf.currAlbum.mixEngineers!.count {
                            if !strongSelf.currAlbum.mixEngineers![i].contains(initialArtistsArrFromDB[i]) {
                                strongSelf.removeAlbumFromMixEngineerRoles(per: initialArtistsArrFromDB[i], completion: { error in
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
                            strongSelf.removeAlbumFromMixEngineerRoles(per: initialArtistsArrFromDB[i], completion: { error in
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
                        strongSelf.removeAlbumFromMixEngineerRoles(per: initialArtistsArrFromDB[i], completion: { error in
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
            
            if strongSelf.currAlbum.mixEngineers != nil {
                if !strongSelf.currAlbum.mixEngineers!.isEmpty {
                    for i in 0 ... strongSelf.currAlbum.mixEngineers!.count-1 {
                        if i < initialArtistsArrFromDB.count {
                            if !initialArtistsArrFromDB[i].contains(strongSelf.currAlbum.mixEngineers![i]) {
                                strongSelf.addAlbumToMixEngineerRoles(per: strongSelf.currAlbum.mixEngineers![i], completion: { error in
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
                            strongSelf.addAlbumToMixEngineerRoles(per: strongSelf.currAlbum.mixEngineers![i], completion: { error in
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
    
    func removeAlbumFromMixEngineerRoles(per: String, completion: @escaping ((Error?) -> Void)) {
        guard per.count == 6 else {
            completion(nil)
            return
        }
        DatabaseManager.shared.fetchPersonData(person: per, completion: {[weak self] result in
            guard let strongSelf = self else {return}
            switch result {
            case .success(let person):
                let ref = Database.database().reference().child("Registered Persons").child("\(person.name!)--\(person.dateRegisteredToApp!)--\(person.timeRegisteredToApp!)--\(person.toneDeafAppId)").child("Roles").child("Engineer").child("Mix Engineer")
                let song = "\(strongSelf.currAlbum.toneDeafAppId)"
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
    
    func addAlbumToMixEngineerRoles(per: String, completion: @escaping ((Error?) -> Void)) {
        guard per.count == 6 else {
            completion(nil)
            return
        }
        
        DatabaseManager.shared.fetchPersonData(person: per, completion: {[weak self] result in
            guard let strongSelf = self else {return}
            switch result {
            case .success(let person):
                let ref = Database.database().reference().child("Registered Persons").child("\(person.name!)--\(person.dateRegisteredToApp!)--\(person.timeRegisteredToApp!)--\(person.toneDeafAppId)").child("Roles").child("Engineer").child("Mix Engineer")
                let song = "\(strongSelf.currAlbum.toneDeafAppId)"
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
    
    //MARK: - Mastering Engineers
    func processMasteringEngineers(initialAlbum: AlbumData, currentAlbum: AlbumData, completion: @escaping (([Error]?) -> Void)) {
        initAlbum = initialAlbum
        currAlbum = currentAlbum
        
        initRef = Database.database().reference().child("Music Content").child("Albums").child("\(albumContentTag)--\(initAlbum.name)--\(initAlbum.toneDeafAppId)")
        currRef = Database.database().reference().child("Music Content").child("Albums").child("\(albumContentTag)--\(currAlbum.name)--\(currAlbum.toneDeafAppId)")
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
        
        let aqueue = DispatchQueue(label: "myhjvkheditingQalbumMasteringEngineershfdChangessseue")
        let agroup = DispatchGroup()
        let array:[Int] = [1,2,3]
        for i in array {
            agroup.enter()
            aqueue.async { [weak self] in
                guard let strongSelf = self else {return}
                switch i {
                case 1:
                    strongSelf.updateAlbumMasteringEngineers(ref: strongSelf.currRef, completion: {err in
                        if let error = err {
                            dataUploadCompletionStatus1 = false
                            errors.append(error)
                        } else {
                            dataUploadCompletionStatus1 = true
                            print("Album MasteringEngineer Update done \(1)")
                        }
                        agroup.leave()
                    })
                case 2:
                    strongSelf.updateMasteringEngineerAlbums(ref: strongSelf.currRef, completion: {err in
                        if let error = err {
                            dataUploadCompletionStatus2 = false
                            errors.append(error)
                        } else {
                            dataUploadCompletionStatus2 = true
                            print("MasteringEngineer albums Update done \(1)")
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
    
    func updateAlbumMasteringEngineers(ref: DatabaseReference, completion: @escaping ((Error?) -> Void)) {
        var initialArtistsArrFromDB:[String]!
        if currAlbum.masteringEngineers!.sorted() == initAlbum.masteringEngineers?.sorted() {
            completion(nil)
            return
        }
        getAlbumMasteringEngineersInDB(ref: ref, completion: {[weak self] persons in
            guard let strongSelf = self else {return}
            initialArtistsArrFromDB = persons.sorted()
            
            if !initialArtistsArrFromDB.isEmpty {
                var removalCounter = 0
                for i in 0 ... initialArtistsArrFromDB.count-1 {
                    if strongSelf.currAlbum.masteringEngineers != nil {
                        if i < strongSelf.currAlbum.masteringEngineers!.count {
                            if !strongSelf.currAlbum.masteringEngineers![i].contains(initialArtistsArrFromDB[i]) {
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
            
            if strongSelf.currAlbum.masteringEngineers != nil {
                if !strongSelf.currAlbum.masteringEngineers!.isEmpty {
                    for i in 0 ... strongSelf.currAlbum.masteringEngineers!.count-1 {
                        if i < initialArtistsArrFromDB.count {
                            if !initialArtistsArrFromDB[i].contains(strongSelf.currAlbum.masteringEngineers![i]) {
                                initialArtistsArrFromDB.append(strongSelf.currAlbum.masteringEngineers![i])
                            }
                        } else {
                            initialArtistsArrFromDB.append(strongSelf.currAlbum.masteringEngineers![i])
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
    
    func getAlbumMasteringEngineersInDB(ref: DatabaseReference, completion: @escaping (([String]) -> Void)) {
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
    
    func updateMasteringEngineerAlbums(ref: DatabaseReference, completion: @escaping ((Error?) -> Void)) {
        var initialArtistsArrFromDB:[String]!
        var totalProgress:Int = 0
        var completedProgress:Int = 0
        if currAlbum.masteringEngineers!.sorted() == initAlbum.masteringEngineers?.sorted() {
            completion(nil)
            return
        }
        
        getAlbumMasteringEngineersInDB(ref: ref, completion: {[weak self] persons in
            guard let strongSelf = self else {return}
            initialArtistsArrFromDB = persons.sorted()
            
            if !initialArtistsArrFromDB.isEmpty {
                var removalCounter = 0
                for i in 0 ... initialArtistsArrFromDB.count-1 {
                    if strongSelf.currAlbum.masteringEngineers != nil {
                        if i < strongSelf.currAlbum.masteringEngineers!.count {
                            if !strongSelf.currAlbum.masteringEngineers![i].contains(initialArtistsArrFromDB[i]) {
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
            
            if strongSelf.currAlbum.masteringEngineers != nil {
                if !strongSelf.currAlbum.masteringEngineers!.isEmpty {
                    for i in 0 ... strongSelf.currAlbum.masteringEngineers!.count-1 {
                        if i < initialArtistsArrFromDB.count {
                            if !initialArtistsArrFromDB[i].contains(strongSelf.currAlbum.masteringEngineers![i]) {
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
                    if strongSelf.currAlbum.masteringEngineers != nil {
                        if i < strongSelf.currAlbum.masteringEngineers!.count {
                            if !strongSelf.currAlbum.masteringEngineers![i].contains(initialArtistsArrFromDB[i]) {
                                strongSelf.removeAlbumFromPerson(per: initialArtistsArrFromDB[i], completion: { error in
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
                            strongSelf.removeAlbumFromPerson(per: initialArtistsArrFromDB[i], completion: { error in
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
                        strongSelf.removeAlbumFromPerson(per: initialArtistsArrFromDB[i], completion: { error in
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
            
            if strongSelf.currAlbum.masteringEngineers != nil {
                if !strongSelf.currAlbum.masteringEngineers!.isEmpty {
                    for i in 0 ... strongSelf.currAlbum.masteringEngineers!.count-1 {
                        if i < initialArtistsArrFromDB.count {
                            if !initialArtistsArrFromDB[i].contains(strongSelf.currAlbum.masteringEngineers![i]) {
                                strongSelf.addAlbumToPerson(per: strongSelf.currAlbum.masteringEngineers![i], completion: { error in
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
                            strongSelf.addAlbumToPerson(per: strongSelf.currAlbum.masteringEngineers![i], completion: { error in
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
        if currAlbum.masteringEngineers!.sorted() == initAlbum.masteringEngineers?.sorted() {
            completion(nil)
            return
        }
        
        getAlbumMasteringEngineersInDB(ref: ref, completion: {[weak self] persons in
            guard let strongSelf = self else {return}
            initialArtistsArrFromDB = persons.sorted()
            
            if !initialArtistsArrFromDB.isEmpty {
                for i in 0 ... initialArtistsArrFromDB.count-1 {
                    if strongSelf.currAlbum.masteringEngineers != nil {
                        if i < strongSelf.currAlbum.masteringEngineers!.count {
                            if !strongSelf.currAlbum.masteringEngineers![i].contains(initialArtistsArrFromDB[i]) {
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
            
            if strongSelf.currAlbum.masteringEngineers != nil {
                if !strongSelf.currAlbum.masteringEngineers!.isEmpty {
                    for i in 0 ... strongSelf.currAlbum.masteringEngineers!.count-1 {
                        if i < initialArtistsArrFromDB.count {
                            if !initialArtistsArrFromDB[i].contains(strongSelf.currAlbum.masteringEngineers![i]) {
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
                    if strongSelf.currAlbum.masteringEngineers != nil {
                        if i < strongSelf.currAlbum.masteringEngineers!.count {
                            if !strongSelf.currAlbum.masteringEngineers![i].contains(initialArtistsArrFromDB[i]) {
                                strongSelf.removeAlbumFromMasteringEngineerRoles(per: initialArtistsArrFromDB[i], completion: { error in
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
                            strongSelf.removeAlbumFromMasteringEngineerRoles(per: initialArtistsArrFromDB[i], completion: { error in
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
                        strongSelf.removeAlbumFromMasteringEngineerRoles(per: initialArtistsArrFromDB[i], completion: { error in
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
            
            if strongSelf.currAlbum.masteringEngineers != nil {
                if !strongSelf.currAlbum.masteringEngineers!.isEmpty {
                    for i in 0 ... strongSelf.currAlbum.masteringEngineers!.count-1 {
                        if i < initialArtistsArrFromDB.count {
                            if !initialArtistsArrFromDB[i].contains(strongSelf.currAlbum.masteringEngineers![i]) {
                                strongSelf.addAlbumToMasteringEngineerRoles(per: strongSelf.currAlbum.masteringEngineers![i], completion: { error in
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
                            strongSelf.addAlbumToMasteringEngineerRoles(per: strongSelf.currAlbum.masteringEngineers![i], completion: { error in
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
    
    func removeAlbumFromMasteringEngineerRoles(per: String, completion: @escaping ((Error?) -> Void)) {
        guard per.count == 6 else {
            completion(nil)
            return
        }
        DatabaseManager.shared.fetchPersonData(person: per, completion: {[weak self] result in
            guard let strongSelf = self else {return}
            switch result {
            case .success(let person):
                let ref = Database.database().reference().child("Registered Persons").child("\(person.name!)--\(person.dateRegisteredToApp!)--\(person.timeRegisteredToApp!)--\(person.toneDeafAppId)").child("Roles").child("Engineer").child("Mastering Engineer")
                let song = "\(strongSelf.currAlbum.toneDeafAppId)"
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
    
    func addAlbumToMasteringEngineerRoles(per: String, completion: @escaping ((Error?) -> Void)) {
        guard per.count == 6 else {
            completion(nil)
            return
        }
        
        DatabaseManager.shared.fetchPersonData(person: per, completion: {[weak self] result in
            guard let strongSelf = self else {return}
            switch result {
            case .success(let person):
                let ref = Database.database().reference().child("Registered Persons").child("\(person.name!)--\(person.dateRegisteredToApp!)--\(person.timeRegisteredToApp!)--\(person.toneDeafAppId)").child("Roles").child("Engineer").child("Mastering Engineer")
                let song = "\(strongSelf.currAlbum.toneDeafAppId)"
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
    
    //MARK: - Recording Engineers
    func processRecordingEngineers(initialAlbum: AlbumData, currentAlbum: AlbumData, completion: @escaping (([Error]?) -> Void)) {
        initAlbum = initialAlbum
        currAlbum = currentAlbum
        
        initRef = Database.database().reference().child("Music Content").child("Albums").child("\(albumContentTag)--\(initAlbum.name)--\(initAlbum.toneDeafAppId)")
        currRef = Database.database().reference().child("Music Content").child("Albums").child("\(albumContentTag)--\(currAlbum.name)--\(currAlbum.toneDeafAppId)")
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
        
        let aqueue = DispatchQueue(label: "myhjvkheditingQalbumRecordingEngineershfdChangessseue")
        let agroup = DispatchGroup()
        let array:[Int] = [1,2,3]
        for i in array {
            agroup.enter()
            aqueue.async { [weak self] in
                guard let strongSelf = self else {return}
                switch i {
                case 1:
                    strongSelf.updateAlbumRecordingEngineers(ref: strongSelf.currRef, completion: {err in
                        if let error = err {
                            dataUploadCompletionStatus1 = false
                            errors.append(error)
                        } else {
                            dataUploadCompletionStatus1 = true
                            print("Album RecordingEngineer Update done \(1)")
                        }
                        agroup.leave()
                    })
                case 2:
                    strongSelf.updateRecordingEngineerAlbums(ref: strongSelf.currRef, completion: {err in
                        if let error = err {
                            dataUploadCompletionStatus2 = false
                            errors.append(error)
                        } else {
                            dataUploadCompletionStatus2 = true
                            print("RecordingEngineer albums Update done \(1)")
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
    
    func updateAlbumRecordingEngineers(ref: DatabaseReference, completion: @escaping ((Error?) -> Void)) {
        var initialArtistsArrFromDB:[String]!
        if currAlbum.recordingEngineers!.sorted() == initAlbum.recordingEngineers?.sorted() {
            completion(nil)
            return
        }
        getAlbumRecordingEngineersInDB(ref: ref, completion: {[weak self] persons in
            guard let strongSelf = self else {return}
            initialArtistsArrFromDB = persons.sorted()
            
            if !initialArtistsArrFromDB.isEmpty {
                var removalCounter = 0
                for i in 0 ... initialArtistsArrFromDB.count-1 {
                    if strongSelf.currAlbum.recordingEngineers != nil {
                        if i < strongSelf.currAlbum.recordingEngineers!.count {
                            if !strongSelf.currAlbum.recordingEngineers![i].contains(initialArtistsArrFromDB[i]) {
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
            
            if strongSelf.currAlbum.recordingEngineers != nil {
                if !strongSelf.currAlbum.recordingEngineers!.isEmpty {
                    for i in 0 ... strongSelf.currAlbum.recordingEngineers!.count-1 {
                        if i < initialArtistsArrFromDB.count {
                            if !initialArtistsArrFromDB[i].contains(strongSelf.currAlbum.recordingEngineers![i]) {
                                initialArtistsArrFromDB.append(strongSelf.currAlbum.recordingEngineers![i])
                            }
                        } else {
                            initialArtistsArrFromDB.append(strongSelf.currAlbum.recordingEngineers![i])
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
    
    func getAlbumRecordingEngineersInDB(ref: DatabaseReference, completion: @escaping (([String]) -> Void)) {
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
    
    func updateRecordingEngineerAlbums(ref: DatabaseReference, completion: @escaping ((Error?) -> Void)) {
        var initialArtistsArrFromDB:[String]!
        var totalProgress:Int = 0
        var completedProgress:Int = 0
        if currAlbum.recordingEngineers!.sorted() == initAlbum.recordingEngineers?.sorted() {
            completion(nil)
            return
        }
        
        getAlbumRecordingEngineersInDB(ref: ref, completion: {[weak self] persons in
            guard let strongSelf = self else {return}
            initialArtistsArrFromDB = persons.sorted()
            
            if !initialArtistsArrFromDB.isEmpty {
                var removalCounter = 0
                for i in 0 ... initialArtistsArrFromDB.count-1 {
                    if strongSelf.currAlbum.recordingEngineers != nil {
                        if i < strongSelf.currAlbum.recordingEngineers!.count {
                            if !strongSelf.currAlbum.recordingEngineers![i].contains(initialArtistsArrFromDB[i]) {
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
            
            if strongSelf.currAlbum.recordingEngineers != nil {
                if !strongSelf.currAlbum.recordingEngineers!.isEmpty {
                    for i in 0 ... strongSelf.currAlbum.recordingEngineers!.count-1 {
                        if i < initialArtistsArrFromDB.count {
                            if !initialArtistsArrFromDB[i].contains(strongSelf.currAlbum.recordingEngineers![i]) {
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
                    if strongSelf.currAlbum.recordingEngineers != nil {
                        if i < strongSelf.currAlbum.recordingEngineers!.count {
                            if !strongSelf.currAlbum.recordingEngineers![i].contains(initialArtistsArrFromDB[i]) {
                                strongSelf.removeAlbumFromPerson(per: initialArtistsArrFromDB[i], completion: { error in
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
                            strongSelf.removeAlbumFromPerson(per: initialArtistsArrFromDB[i], completion: { error in
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
                        strongSelf.removeAlbumFromPerson(per: initialArtistsArrFromDB[i], completion: { error in
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
            
            if strongSelf.currAlbum.recordingEngineers != nil {
                if !strongSelf.currAlbum.recordingEngineers!.isEmpty {
                    for i in 0 ... strongSelf.currAlbum.recordingEngineers!.count-1 {
                        if i < initialArtistsArrFromDB.count {
                            if !initialArtistsArrFromDB[i].contains(strongSelf.currAlbum.recordingEngineers![i]) {
                                strongSelf.addAlbumToPerson(per: strongSelf.currAlbum.recordingEngineers![i], completion: { error in
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
                            strongSelf.addAlbumToPerson(per: strongSelf.currAlbum.recordingEngineers![i], completion: { error in
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
        if currAlbum.recordingEngineers!.sorted() == initAlbum.recordingEngineers?.sorted() {
            completion(nil)
            return
        }
        
        getAlbumRecordingEngineersInDB(ref: ref, completion: {[weak self] persons in
            guard let strongSelf = self else {return}
            initialArtistsArrFromDB = persons.sorted()
            
            if !initialArtistsArrFromDB.isEmpty {
                for i in 0 ... initialArtistsArrFromDB.count-1 {
                    if strongSelf.currAlbum.recordingEngineers != nil {
                        if i < strongSelf.currAlbum.recordingEngineers!.count {
                            if !strongSelf.currAlbum.recordingEngineers![i].contains(initialArtistsArrFromDB[i]) {
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
            
            if strongSelf.currAlbum.recordingEngineers != nil {
                if !strongSelf.currAlbum.recordingEngineers!.isEmpty {
                    for i in 0 ... strongSelf.currAlbum.recordingEngineers!.count-1 {
                        if i < initialArtistsArrFromDB.count {
                            if !initialArtistsArrFromDB[i].contains(strongSelf.currAlbum.recordingEngineers![i]) {
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
                    if strongSelf.currAlbum.recordingEngineers != nil {
                        if i < strongSelf.currAlbum.recordingEngineers!.count {
                            if !strongSelf.currAlbum.recordingEngineers![i].contains(initialArtistsArrFromDB[i]) {
                                strongSelf.removeAlbumFromRecordingEngineerRoles(per: initialArtistsArrFromDB[i], completion: { error in
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
                            strongSelf.removeAlbumFromRecordingEngineerRoles(per: initialArtistsArrFromDB[i], completion: { error in
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
                        strongSelf.removeAlbumFromRecordingEngineerRoles(per: initialArtistsArrFromDB[i], completion: { error in
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
            
            if strongSelf.currAlbum.recordingEngineers != nil {
                if !strongSelf.currAlbum.recordingEngineers!.isEmpty {
                    for i in 0 ... strongSelf.currAlbum.recordingEngineers!.count-1 {
                        if i < initialArtistsArrFromDB.count {
                            if !initialArtistsArrFromDB[i].contains(strongSelf.currAlbum.recordingEngineers![i]) {
                                strongSelf.addAlbumToRecordingEngineerRoles(per: strongSelf.currAlbum.recordingEngineers![i], completion: { error in
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
                            strongSelf.addAlbumToRecordingEngineerRoles(per: strongSelf.currAlbum.recordingEngineers![i], completion: { error in
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
    
    func removeAlbumFromRecordingEngineerRoles(per: String, completion: @escaping ((Error?) -> Void)) {
        guard per.count == 6 else {
            completion(nil)
            return
        }
        DatabaseManager.shared.fetchPersonData(person: per, completion: {[weak self] result in
            guard let strongSelf = self else {return}
            switch result {
            case .success(let person):
                let ref = Database.database().reference().child("Registered Persons").child("\(person.name!)--\(person.dateRegisteredToApp!)--\(person.timeRegisteredToApp!)--\(person.toneDeafAppId)").child("Roles").child("Engineer").child("Recording Engineer")
                let song = "\(strongSelf.currAlbum.toneDeafAppId)"
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
    
    func addAlbumToRecordingEngineerRoles(per: String, completion: @escaping ((Error?) -> Void)) {
        guard per.count == 6 else {
            completion(nil)
            return
        }
        
        DatabaseManager.shared.fetchPersonData(person: per, completion: {[weak self] result in
            guard let strongSelf = self else {return}
            switch result {
            case .success(let person):
                let ref = Database.database().reference().child("Registered Persons").child("\(person.name!)--\(person.dateRegisteredToApp!)--\(person.timeRegisteredToApp!)--\(person.toneDeafAppId)").child("Roles").child("Engineer").child("Recording Engineer")
                let song = "\(strongSelf.currAlbum.toneDeafAppId)"
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
    
    //MARK: - Spotify
    func processSpotify(initialAlbum: AlbumData, currentAlbum: AlbumData, initialStatus:Bool?, currentStatus:Bool?, initialURL:String?, currentURL:String?, completion: @escaping (([Error]?) -> Void)) {
        initAlbum = initialAlbum
        currAlbum = currentAlbum
        var errors:[Error] = []
        initRef = Database.database().reference().child("Music Content").child("Albums").child("\(albumContentTag)--\(currAlbum.name)--\(currAlbum.toneDeafAppId)")
        currRef = Database.database().reference().child("Music Content").child("Albums").child("\(albumContentTag)--\(currAlbum.name)--\(currAlbum.toneDeafAppId)")
        
        var dataUploadCompletionStatus1:Bool!
        var dataUploadCompletionStatus2:Bool!
        let queue = DispatchQueue(label: "myhjvkheditingQalbumsSpotifyssseue")
        let group = DispatchGroup()
        var array:[Int] = []
        
        if currAlbum.spotify == nil {
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
        ref.child("\(spotifyMusicContentType)--\(currAlbum.name)--\(currAlbum.dateRegisteredToApp)--\(currAlbum.timeRegisteredToApp)").child("Active Status").setValue(currentStatus, withCompletionBlock: { error, reference in
            if let error = error {
                completion(AlbumEditorError.spotifyUpdateError(error.localizedDescription))
                return
            }
            else {
                completion(nil)
                return
            }
        })
    }
    
    func processSpotifyURL(ref: DatabaseReference, currentStatus: Bool?, currentURL: String?, completion: @escaping ((Error?) -> Void)) {
        let nref = ref.child("\(spotifyMusicContentType)--\(currAlbum.name)--\(currAlbum.dateRegisteredToApp)--\(currAlbum.timeRegisteredToApp)")
        var spotUrl = currentURL!
        if let dotRange = spotUrl.range(of: "?") {
            spotUrl.removeSubrange(dotRange.lowerBound..<spotUrl.endIndex)
        }
        let albumId = String(spotUrl.suffix(22))
        let token = (UserDefaults.standard.object(forKey: "SPTaccesstoken") as? String)!
        SpotifyRequest.shared.getAlbumInfo(accessToken: token, id: albumId, completion: { result in
            switch result {
            case .success(let song):
                let newDict:NSDictionary = [
                    "Name" : song.name,
                    "Artists" : song.artist,
                    "UPC" : song.upc,
                    "Date Released On Spotify" : song.dateReleasedSpotify,
                    "Time Uploaded To App" : song.timeIA,
                    "Date Uploaded To App" : song.dateIA,
                    "Artwork URL" : song.imageURL,
                    "Album URL" : song.url,
                    "Album URI" : song.uri,
                    "Number of Favorites" : 0,
                    "Number of Tracks" : song.trackNumberTotal,
                    "Spotify Id" : song.spotifyId,
                    "Active Status" : currentStatus
                ]
                
                nref.setValue(newDict, withCompletionBlock: { error, reference in
                    if let error = error {
                        completion(AlbumEditorError.spotifyUpdateError(error.localizedDescription))
                        return
                    }
                    else {
                        completion(nil)
                        return
                    }
                })
            case .failure(let err):
                completion(AlbumEditorError.spotifyUpdateError(err.localizedDescription))
            }
        })
        
        
    }
    
    func removeSpotify(ref: DatabaseReference, completion: @escaping ((Error?) -> Void)) {
        ref.child("\(spotifyMusicContentType)--\(currAlbum.name)--\(currAlbum.dateRegisteredToApp)--\(currAlbum.timeRegisteredToApp)").removeValue(completionBlock: { error, reference in
            if let error = error {
                completion(AlbumEditorError.spotifyUpdateError(error.localizedDescription))
                return
            }
            else {
                completion(nil)
                return
            }
        })
    }
    
    //MARK: - Apple Music
    func processAppleMusic(initialAlbum: AlbumData, currentAlbum: AlbumData, initialStatus:Bool?, currentStatus:Bool?, initialURL:String?, currentURL:String?, completion: @escaping (([Error]?) -> Void)) {
        initAlbum = initialAlbum
        currAlbum = currentAlbum
        var errors:[Error] = []
        initRef = Database.database().reference().child("Music Content").child("Albums").child("\(albumContentTag)--\(initAlbum.name)--\(initAlbum.toneDeafAppId)")
        currRef = Database.database().reference().child("Music Content").child("Albums").child("\(albumContentTag)--\(currAlbum.name)--\(currAlbum.toneDeafAppId)")
        
        var dataUploadCompletionStatus1:Bool!
        var dataUploadCompletionStatus2:Bool!
        let queue = DispatchQueue(label: "myhjvkheditingQalbumsAppleMusicssseue")
        let group = DispatchGroup()
        var array:[Int] = []
        
        if currAlbum.apple == nil {
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
        ref.child("\(appleMusicContentType)--\(currAlbum.name)--\(currAlbum.dateRegisteredToApp)--\(currAlbum.timeRegisteredToApp)").child("Active Status").setValue(currentStatus, withCompletionBlock: { error, reference in
            if let error = error {
                completion(AlbumEditorError.appleUpdateError(error.localizedDescription))
                return
            }
            else {
                completion(nil)
                return
            }
        })
    }
    
    func processAppleMusicURL(ref: DatabaseReference, currentStatus: Bool?, currentURL: String?, completion: @escaping ((Error?) -> Void)) {
        let nref = ref.child("\(appleMusicContentType)--\(currAlbum.name)--\(currAlbum.dateRegisteredToApp)--\(currAlbum.timeRegisteredToApp)")
        let url = currentURL!
        let songId = String((url.suffix(10)))
        AppleMusicRequest.shared.getAppleMusicAlbum(id: songId, completion: { result in
            switch result {
            case .success(let song):
                let newDict:NSDictionary = [
                    "Name" : song.name,
                    "Artists" : song.artist,
                    "Date Released On Apple" : song.dateReleasedApple,
                    "Time Uploaded To App" : song.timeIA,
                    "Date Uploaded To App" : song.dateIA,
                    "Artwork URL" : song.imageURL,
                    "Album URL" : song.url,
                    "Number of Favorites" : 0,
                    "Number of Tracks" : song.trackCount,
                    "Apple Music Id" : song.appleId,
                    "Active Status" : currentStatus
                ]
                
                nref.setValue(newDict, withCompletionBlock: { error, reference in
                    if let error = error {
                        completion(AlbumEditorError.appleUpdateError(error.localizedDescription))
                        return
                    }
                    else {
                        completion(nil)
                        return
                    }
                })
            case .failure(let err):
                completion(AlbumEditorError.appleUpdateError(err.localizedDescription))
            }
        })
        
        
    }
    
    func removeAppleMusic(ref: DatabaseReference, completion: @escaping ((Error?) -> Void)) {
        ref.child("\(appleMusicContentType)--\(currAlbum.name)--\(currAlbum.dateRegisteredToApp)--\(currAlbum.timeRegisteredToApp)").removeValue(completionBlock: { error, reference in
            if let error = error {
                completion(AlbumEditorError.appleUpdateError(error.localizedDescription))
                return
            }
            else {
                completion(nil)
                return
            }
        })
    }
    
    //MARK: - Soundcloud
    func processSoundcloud(initialAlbum: AlbumData, currentAlbum: AlbumData, initialStatus:Bool?, currentStatus:Bool?, initialURL:String?, currentURL:String?, completion: @escaping (([Error]?) -> Void)) {
        initAlbum = initialAlbum
        currAlbum = currentAlbum
        var errors:[Error] = []
        initRef = Database.database().reference().child("Music Content").child("Albums").child("\(albumContentTag)--\(initAlbum.name)--\(initAlbum.toneDeafAppId)")
        currRef = Database.database().reference().child("Music Content").child("Albums").child("\(albumContentTag)--\(currAlbum.name)--\(currAlbum.toneDeafAppId)")
        
        var dataUploadCompletionStatus1:Bool!
        var dataUploadCompletionStatus2:Bool!
        let queue = DispatchQueue(label: "myhjvkheditingQalbumsSoundcloudssseue")
        let group = DispatchGroup()
        var array:[Int] = []
        if currAlbum.soundcloud == nil {
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
        ref.child("\(soundcloudMusicContentType)--\(currAlbum.name)--\(currAlbum.dateRegisteredToApp)--\(currAlbum.timeRegisteredToApp)").child("Active Status").setValue(currentStatus, withCompletionBlock: { error, reference in
            if let error = error {
                completion(AlbumEditorError.soundcloudUpdateError(error.localizedDescription))
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
                
                ref.child("\(soundcloudMusicContentType)--\(currAlbum.name)--\(currAlbum.dateRegisteredToApp)--\(currAlbum.timeRegisteredToApp)").setValue(newDict, withCompletionBlock: { error, reference in
                    if let error = error {
                        completion(AlbumEditorError.soundcloudUpdateError(error.localizedDescription))
                        return
                    }
                    else {
                        completion(nil)
                        return
                    }
                })
        
        
    }
    
    func removeSoundcloud(ref: DatabaseReference, completion: @escaping ((Error?) -> Void)) {
        ref.child("\(soundcloudMusicContentType)--\(currAlbum.name)--\(currAlbum.dateRegisteredToApp)--\(currAlbum.timeRegisteredToApp)").removeValue(completionBlock: { error, reference in
            if let error = error {
                completion(AlbumEditorError.soundcloudUpdateError(error.localizedDescription))
                return
            }
            else {
                completion(nil)
                return
            }
        })
    }
    
    //MARK: - Youtube Music
    func processYoutubeMusic(initialAlbum: AlbumData, currentAlbum: AlbumData, initialStatus:Bool?, currentStatus:Bool?, initialURL:String?, currentURL:String?, completion: @escaping (([Error]?) -> Void)) {
        initAlbum = initialAlbum
        currAlbum = currentAlbum
        var errors:[Error] = []
        initRef = Database.database().reference().child("Music Content").child("Albums").child("\(albumContentTag)--\(initAlbum.name)--\(initAlbum.toneDeafAppId)")
        currRef = Database.database().reference().child("Music Content").child("Albums").child("\(albumContentTag)--\(currAlbum.name)--\(currAlbum.toneDeafAppId)")
        
        var dataUploadCompletionStatus1:Bool!
        var dataUploadCompletionStatus2:Bool!
        let queue = DispatchQueue(label: "myhjvkheditingQalbumsYoutubeMusicssseue")
        let group = DispatchGroup()
        var array:[Int] = []
        if currAlbum.youtubeMusic == nil {
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
        ref.child("\(youtubeMusicContentType)--\(currAlbum.name)--\(currAlbum.dateRegisteredToApp)--\(currAlbum.timeRegisteredToApp)").child("Active Status").setValue(currentStatus, withCompletionBlock: { error, reference in
            if let error = error {
                completion(AlbumEditorError.youtubeMusicUpdateError(error.localizedDescription))
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
                
                ref.child("\(youtubeMusicContentType)--\(currAlbum.name)--\(currAlbum.dateRegisteredToApp)--\(currAlbum.timeRegisteredToApp)").setValue(newDict, withCompletionBlock: { error, reference in
                    if let error = error {
                        completion(AlbumEditorError.youtubeMusicUpdateError(error.localizedDescription))
                        return
                    }
                    else {
                        completion(nil)
                        return
                    }
                })
        
        
    }
    
    func removeYoutubeMusic(ref: DatabaseReference, completion: @escaping ((Error?) -> Void)) {
        ref.child("\(youtubeMusicContentType)--\(currAlbum.name)--\(currAlbum.dateRegisteredToApp)--\(currAlbum.timeRegisteredToApp)").removeValue(completionBlock: { error, reference in
            if let error = error {
                completion(AlbumEditorError.youtubeMusicUpdateError(error.localizedDescription))
                return
            }
            else {
                completion(nil)
                return
            }
        })
    }
    
    //MARK: - Amazon
    func processAmazon(initialAlbum: AlbumData, currentAlbum: AlbumData, initialStatus:Bool?, currentStatus:Bool?, initialURL:String?, currentURL:String?, completion: @escaping (([Error]?) -> Void)) {
        initAlbum = initialAlbum
        currAlbum = currentAlbum
        var errors:[Error] = []
        initRef = Database.database().reference().child("Music Content").child("Albums").child("\(albumContentTag)--\(initAlbum.name)--\(initAlbum.toneDeafAppId)")
        currRef = Database.database().reference().child("Music Content").child("Albums").child("\(albumContentTag)--\(currAlbum.name)--\(currAlbum.toneDeafAppId)")
        
        var dataUploadCompletionStatus1:Bool!
        var dataUploadCompletionStatus2:Bool!
        let queue = DispatchQueue(label: "myhjvkheditingQalbumsAmazonssseue")
        let group = DispatchGroup()
        var array:[Int] = []
        if currAlbum.amazon == nil {
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
        ref.child("\(amazonMusicContentType)--\(currAlbum.name)--\(currAlbum.dateRegisteredToApp)--\(currAlbum.timeRegisteredToApp)").child("Active Status").setValue(currentStatus, withCompletionBlock: { error, reference in
            if let error = error {
                completion(AlbumEditorError.amazonUpdateError(error.localizedDescription))
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
                
                ref.child("\(amazonMusicContentType)--\(currAlbum.name)--\(currAlbum.dateRegisteredToApp)--\(currAlbum.timeRegisteredToApp)").setValue(newDict, withCompletionBlock: { error, reference in
                    if let error = error {
                        completion(AlbumEditorError.amazonUpdateError(error.localizedDescription))
                        return
                    }
                    else {
                        completion(nil)
                        return
                    }
                })
        
        
    }
    
    func removeAmazon(ref: DatabaseReference, completion: @escaping ((Error?) -> Void)) {
        ref.child("\(amazonMusicContentType)--\(currAlbum.name)--\(currAlbum.dateRegisteredToApp)--\(currAlbum.timeRegisteredToApp)").removeValue(completionBlock: { error, reference in
            if let error = error {
                completion(AlbumEditorError.amazonUpdateError(error.localizedDescription))
                return
            }
            else {
                completion(nil)
                return
            }
        })
    }
    
    //MARK: - Deezer
    func processDeezer(initialAlbum: AlbumData, currentAlbum: AlbumData, initialStatus:Bool?, currentStatus:Bool?, initialURL:String?, currentURL:String?, completion: @escaping (([Error]?) -> Void)) {
        initAlbum = initialAlbum
        currAlbum = currentAlbum
        var errors:[Error] = []
        initRef = Database.database().reference().child("Music Content").child("Albums").child("\(albumContentTag)--\(initAlbum.name)--\(initAlbum.toneDeafAppId)")
        currRef = Database.database().reference().child("Music Content").child("Albums").child("\(albumContentTag)--\(currAlbum.name)--\(currAlbum.toneDeafAppId)")
        
        var dataUploadCompletionStatus1:Bool!
        var dataUploadCompletionStatus2:Bool!
        let queue = DispatchQueue(label: "myhjvkheditingQalbumsDeezerssseue")
        let group = DispatchGroup()
        var array:[Int] = []
        if currAlbum.deezer == nil {
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
        ref.child("\(deezerMusicContentType)--\(currAlbum.name)--\(currAlbum.dateRegisteredToApp)--\(currAlbum.timeRegisteredToApp)").child("Active Status").setValue(currentStatus, withCompletionBlock: { error, reference in
            if let error = error {
                completion(AlbumEditorError.deezerUpdateError(error.localizedDescription))
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
        if let range = deezUrl.range(of: "album/") {
            deezUrl.removeSubrange(deezUrl.startIndex..<range.lowerBound)
        }
        let albumId = String(deezUrl.dropFirst(6))
        
        DeezerRequest.shared.getDeezerAlbum(id: albumId, completion: {[weak self] result in
            guard let strongSelf = self else {return}
            switch result {
            case .success(let song):
                let newDict:NSDictionary = [
                    "Name" : song.name!,
                    "Artist" : song.artist!,
                    "UPC" : song.upc!,
                    "Date Released On Deezer" : song.deezerDate!,
                    "Time Uploaded To App" : song.timeIA,
                    "Date Uploaded To App" : song.dateIA,
                    "Duration" : song.duration!,
                    "Artwork URL" : song.imageurl!,
                    "Album URL" : song.url!,
                    "Deezer Music Id" : song.deezerID!,
                    "Active Status" : currentStatus
                ]
                
                ref.child("\(deezerMusicContentType)--\(strongSelf.currAlbum.name)--\(strongSelf.currAlbum.dateRegisteredToApp)--\(strongSelf.currAlbum.timeRegisteredToApp)").setValue(newDict, withCompletionBlock: { error, reference in
                    if let error = error {
                        completion(AlbumEditorError.deezerUpdateError(error.localizedDescription))
                        return
                    }
                    else {
                        completion(nil)
                        return
                    }
                })
            case .failure(let err):
                completion(AlbumEditorError.deezerUpdateError(err.localizedDescription))
            }
        })
        
    }
    
    func removeDeezer(ref: DatabaseReference, completion: @escaping ((Error?) -> Void)) {
        ref.child("\(deezerMusicContentType)--\(currAlbum.name)--\(currAlbum.dateRegisteredToApp)--\(currAlbum.timeRegisteredToApp)").removeValue(completionBlock: { error, reference in
            if let error = error {
                completion(AlbumEditorError.deezerUpdateError(error.localizedDescription))
                return
            }
            else {
                completion(nil)
                return
            }
        })
    }
    
    //MARK: - Tidal
    func processTidal(initialAlbum: AlbumData, currentAlbum: AlbumData, initialStatus:Bool?, currentStatus:Bool?, initialURL:String?, currentURL:String?, completion: @escaping (([Error]?) -> Void)) {
        initAlbum = initialAlbum
        currAlbum = currentAlbum
        var errors:[Error] = []
        initRef = Database.database().reference().child("Music Content").child("Albums").child("\(albumContentTag)--\(initAlbum.name)--\(initAlbum.toneDeafAppId)")
        currRef = Database.database().reference().child("Music Content").child("Albums").child("\(albumContentTag)--\(currAlbum.name)--\(currAlbum.toneDeafAppId)")
        
        var dataUploadCompletionStatus1:Bool!
        var dataUploadCompletionStatus2:Bool!
        let queue = DispatchQueue(label: "myhjvkheditingQalbumsTidalssseue")
        let group = DispatchGroup()
        var array:[Int] = []
        if currAlbum.tidal == nil {
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
        ref.child("\(tidalMusicContentType)--\(currAlbum.name)--\(currAlbum.dateRegisteredToApp)--\(currAlbum.timeRegisteredToApp)").child("Active Status").setValue(currentStatus, withCompletionBlock: { error, reference in
            if let error = error {
                completion(AlbumEditorError.tidalUpdateError(error.localizedDescription))
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
                
                ref.child("\(tidalMusicContentType)--\(currAlbum.name)--\(currAlbum.dateRegisteredToApp)--\(currAlbum.timeRegisteredToApp)").setValue(newDict, withCompletionBlock: { error, reference in
                    if let error = error {
                        completion(AlbumEditorError.tidalUpdateError(error.localizedDescription))
                        return
                    }
                    else {
                        completion(nil)
                        return
                    }
                })
        
        
    }
    
    func removeTidal(ref: DatabaseReference, completion: @escaping ((Error?) -> Void)) {
        ref.child("\(tidalMusicContentType)--\(currAlbum.name)--\(currAlbum.dateRegisteredToApp)--\(currAlbum.timeRegisteredToApp)").removeValue(completionBlock: { error, reference in
            if let error = error {
                completion(AlbumEditorError.tidalUpdateError(error.localizedDescription))
                return
            }
            else {
                completion(nil)
                return
            }
        })
    }
    
    //MARK: - Napster
    func processNapster(initialAlbum: AlbumData, currentAlbum: AlbumData, initialStatus:Bool?, currentStatus:Bool?, initialURL:String?, currentURL:String?, completion: @escaping (([Error]?) -> Void)) {
        initAlbum = initialAlbum
        currAlbum = currentAlbum
        var errors:[Error] = []
        initRef = Database.database().reference().child("Music Content").child("Albums").child("\(albumContentTag)--\(initAlbum.name)--\(initAlbum.toneDeafAppId)")
        currRef = Database.database().reference().child("Music Content").child("Albums").child("\(albumContentTag)--\(currAlbum.name)--\(currAlbum.toneDeafAppId)")
        
        var dataUploadCompletionStatus1:Bool!
        var dataUploadCompletionStatus2:Bool!
        let queue = DispatchQueue(label: "myhjvkheditingQalbumsNapsterssseue")
        let group = DispatchGroup()
        var array:[Int] = []
        if currAlbum.napster == nil {
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
        ref.child("\(napsterMusicContentType)--\(currAlbum.name)--\(currAlbum.dateRegisteredToApp)--\(currAlbum.timeRegisteredToApp)").child("Active Status").setValue(currentStatus, withCompletionBlock: { error, reference in
            if let error = error {
                completion(AlbumEditorError.napsterUpdateError(error.localizedDescription))
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
                
                ref.child("\(napsterMusicContentType)--\(currAlbum.name)--\(currAlbum.dateRegisteredToApp)--\(currAlbum.timeRegisteredToApp)").setValue(newDict, withCompletionBlock: { error, reference in
                    if let error = error {
                        completion(AlbumEditorError.napsterUpdateError(error.localizedDescription))
                        return
                    }
                    else {
                        completion(nil)
                        return
                    }
                })
        
        
    }
    
    func removeNapster(ref: DatabaseReference, completion: @escaping ((Error?) -> Void)) {
        ref.child("\(napsterMusicContentType)--\(currAlbum.name)--\(currAlbum.dateRegisteredToApp)--\(currAlbum.timeRegisteredToApp)").removeValue(completionBlock: { error, reference in
            if let error = error {
                completion(AlbumEditorError.napsterUpdateError(error.localizedDescription))
                return
            }
            else {
                completion(nil)
                return
            }
        })
    }
    
    //MARK: - Spinrilla
    func processSpinrilla(initialAlbum: AlbumData, currentAlbum: AlbumData, initialStatus:Bool?, currentStatus:Bool?, initialURL:String?, currentURL:String?, completion: @escaping (([Error]?) -> Void)) {
        initAlbum = initialAlbum
        currAlbum = currentAlbum
        var errors:[Error] = []
        initRef = Database.database().reference().child("Music Content").child("Albums").child("\(albumContentTag)--\(initAlbum.name)--\(initAlbum.toneDeafAppId)")
        currRef = Database.database().reference().child("Music Content").child("Albums").child("\(albumContentTag)--\(currAlbum.name)--\(currAlbum.toneDeafAppId)")
        
        var dataUploadCompletionStatus1:Bool!
        var dataUploadCompletionStatus2:Bool!
        let queue = DispatchQueue(label: "myhjvkheditingQalbumsSpinrillassseue")
        let group = DispatchGroup()
        var array:[Int] = []
        if currAlbum.spinrilla == nil {
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
        ref.child("\(spinrillaMusicContentType)--\(currAlbum.name)--\(currAlbum.dateRegisteredToApp)--\(currAlbum.timeRegisteredToApp)").child("Active Status").setValue(currentStatus, withCompletionBlock: { error, reference in
            if let error = error {
                completion(AlbumEditorError.spinrillaUpdateError(error.localizedDescription))
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
                
                ref.child("\(spinrillaMusicContentType)--\(currAlbum.name)--\(currAlbum.dateRegisteredToApp)--\(currAlbum.timeRegisteredToApp)").setValue(newDict, withCompletionBlock: { error, reference in
                    if let error = error {
                        completion(AlbumEditorError.spinrillaUpdateError(error.localizedDescription))
                        return
                    }
                    else {
                        completion(nil)
                        return
                    }
                })
        
        
    }
    
    func removeSpinrilla(ref: DatabaseReference, completion: @escaping ((Error?) -> Void)) {
        ref.child("\(spinrillaMusicContentType)--\(currAlbum.name)--\(currAlbum.dateRegisteredToApp)--\(currAlbum.timeRegisteredToApp)").removeValue(completionBlock: { error, reference in
            if let error = error {
                completion(AlbumEditorError.spinrillaUpdateError(error.localizedDescription))
                return
            }
            else {
                completion(nil)
                return
            }
        })
    }
    
    //MARK: - Tracks
    func processTracks(initialAlbum: AlbumData, currentAlbum: AlbumData, completion: @escaping (([Error]?) -> Void)) {
        initAlbum = initialAlbum
        currAlbum = currentAlbum
        var errors:[Error] = []
        initRef = Database.database().reference().child("Music Content").child("Albums").child("\(albumContentTag)--\(initAlbum.name)--\(initAlbum.toneDeafAppId)")
        currRef = Database.database().reference().child("Music Content").child("Albums").child("\(albumContentTag)--\(currAlbum.name)--\(currAlbum.toneDeafAppId)")
        
        var dataUploadCompletionStatus1:Bool!
        var dataUploadCompletionStatus2:Bool!
        let queue = DispatchQueue(label: "myhjvkheditingQtracksAlbumssseue")
        let group = DispatchGroup()
        var array:[Int] = [1]
        for i in array {
            group.enter()
            queue.async { [weak self] in
                guard let strongSelf = self else {return}
                switch i {
                case 1:
                    strongSelf.updateAlbumTracks(ref: strongSelf.currRef, completion: {err in
                        if let error = err {
                            dataUploadCompletionStatus1 = false
                            errors.append(error)
                        } else {
                            dataUploadCompletionStatus1 = true
                            print("Album Tracks done \(i)")
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
    
    func updateAlbumTracks(ref: DatabaseReference, completion: @escaping ((Error?) -> Void)) {
        var tracksInDB:[String:String]!
        if currAlbum.tracks == initAlbum.tracks {
            completion(nil)
            return
        }
        tracksInDB = currAlbum.tracks
        ref.child("REQUIRED").child("Tracks").setValue(tracksInDB, withCompletionBlock: {[weak self] error, reference in
            guard let strongSelf = self else {return}
            if let error = error {
                completion(error)
                return
            }
            else {
                ref.child("REQUIRED").child("Number Of Tracks").setValue(strongSelf.currAlbum.tracks.count)
                completion(nil)
                return
            }
        })
    }
    
    //MARK: - Songs
    func processSongs(initialAlbum: AlbumData, currentAlbum: AlbumData, completion: @escaping (([Error]?) -> Void)) {
        initAlbum = initialAlbum
        currAlbum = currentAlbum
        var errors:[Error] = []
        initRef = Database.database().reference().child("Music Content").child("Albums").child("\(albumContentTag)--\(initAlbum.name)--\(initAlbum.toneDeafAppId)")
        currRef = Database.database().reference().child("Music Content").child("Albums").child("\(albumContentTag)--\(currAlbum.name)--\(currAlbum.toneDeafAppId)")
        
        var dataUploadCompletionStatus1:Bool!
        var dataUploadCompletionStatus2:Bool!
        let aqueue = DispatchQueue(label: "myhjvkheditingQalbumsSongssseue")
        let agroup = DispatchGroup()
        let array:[Int] = [1,2]
        for i in array {
            agroup.enter()
            aqueue.async { [weak self] in
                guard let strongSelf = self else {return}
                switch i {
                case 1:
                    strongSelf.updateAlbumSongs(ref: strongSelf.currRef, completion: {err in
                        if let error = err {
                            dataUploadCompletionStatus1 = false
                            errors.append(error)
                        } else {
                            dataUploadCompletionStatus1 = true
                            print("Album songs update done \(i)")
                        }
                        agroup.leave()
                    })
                case 2:
                    strongSelf.updateSongAlbums(ref: strongSelf.currRef, completion: {err in
                        if let error = err {
                            dataUploadCompletionStatus2 = false
                            errors.append(error)
                        } else {
                            dataUploadCompletionStatus2 = true
                            print("Song albums update done \(i)")
                        }
                        agroup.leave()
                    })
                default:
                    print("Edit Song error")
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
    
    func updateAlbumSongs(ref: DatabaseReference, completion: @escaping ((Error?) -> Void)) {
        var initialArtistsArrFromDB:[String]!
        if currAlbum.songs!.sorted() == initAlbum.songs?.sorted() {
            completion(nil)
            return
        }
        getAlbumSongsInDB(ref: ref, completion: {[weak self] songs in
            guard let strongSelf = self else {return}
            initialArtistsArrFromDB = songs.sorted()
            
            if !initialArtistsArrFromDB.isEmpty {
                var removalCounter = 0
                for i in 0 ... initialArtistsArrFromDB.count-1 {
                    if strongSelf.currAlbum.songs != nil {
                        if i < strongSelf.currAlbum.songs!.count {
                            if i <= initialArtistsArrFromDB.count-removalCounter {
                                if !strongSelf.currAlbum.songs!.contains(initialArtistsArrFromDB[i]) {
                                    let index = initialArtistsArrFromDB.firstIndex(of: initialArtistsArrFromDB[i])
                                    initialArtistsArrFromDB.remove(at: index!)
                                    removalCounter+=1
                                }
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
            
            if strongSelf.currAlbum.songs != nil {
                if !strongSelf.currAlbum.songs!.isEmpty {
                    for i in 0 ... strongSelf.currAlbum.songs!.count-1 {
                        if i < initialArtistsArrFromDB.count {
                            if !initialArtistsArrFromDB.contains(strongSelf.currAlbum.songs![i]) {
                                initialArtistsArrFromDB.append(strongSelf.currAlbum.songs![i])
                            }
                        } else {
                            initialArtistsArrFromDB.append(strongSelf.currAlbum.songs![i])
                        }
                    }
                }
            }
            ref.child("REQUIRED").child("Songs").setValue(initialArtistsArrFromDB.sorted(), withCompletionBlock: { error, reference in
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
    
    func getAlbumSongsInDB(ref: DatabaseReference, completion: @escaping (([String]) -> Void)) {
        ref.child("REQUIRED").child("Songs").observeSingleEvent(of: .value, with: { snapshot in
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
    
    func updateSongAlbums(ref: DatabaseReference, completion: @escaping ((Error?) -> Void)) {
        var initialArtistsArrFromDB:[String]!
        var totalProgress:Int = 0
        var completedProgress:Int = 0
        if currAlbum.songs!.sorted() == initAlbum.songs?.sorted() {
            completion(nil)
            return
        }
        
        getAlbumSongsInDB(ref: ref, completion: {[weak self] songs in
            guard let strongSelf = self else {return}
            initialArtistsArrFromDB = songs.sorted()
            
            if !initialArtistsArrFromDB.isEmpty {
                var removalCounter = 0
                for i in 0 ... initialArtistsArrFromDB.count-1 {
                    if strongSelf.currAlbum.songs != nil {
                        if i < strongSelf.currAlbum.songs!.count {
                            if !strongSelf.currAlbum.songs!.contains(initialArtistsArrFromDB[i]) {
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
            
            if strongSelf.currAlbum.songs != nil {
                if !strongSelf.currAlbum.songs!.isEmpty {
                    for i in 0 ... strongSelf.currAlbum.songs!.count-1 {
                        if i < initialArtistsArrFromDB.count {
                            if !initialArtistsArrFromDB.contains(strongSelf.currAlbum.songs![i]) {
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
                    if strongSelf.currAlbum.songs != nil {
                        if i < strongSelf.currAlbum.songs!.count {
                            if !strongSelf.currAlbum.songs!.contains(initialArtistsArrFromDB[i]) {
                                strongSelf.removeAlbumFromSong(son: initialArtistsArrFromDB[i], completion: { error in
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
                            strongSelf.removeAlbumFromSong(son: initialArtistsArrFromDB[i], completion: { error in
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
                        strongSelf.removeAlbumFromSong(son: initialArtistsArrFromDB[i], completion: { error in
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
            
            if strongSelf.currAlbum.songs != nil {
                if !strongSelf.currAlbum.songs!.isEmpty {
                    for i in 0 ... strongSelf.currAlbum.songs!.count-1 {
                        if i < initialArtistsArrFromDB.count {
                            if !initialArtistsArrFromDB.contains(strongSelf.currAlbum.songs![i]) {
                                strongSelf.addAlbumToSong(son: strongSelf.currAlbum.songs![i], completion: { error in
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
                            strongSelf.addAlbumToSong(son: strongSelf.currAlbum.songs![i], completion: { error in
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
    
    func removeAlbumFromSong(son: String, completion: @escaping ((Error?) -> Void)) {
        guard son.count == 10 else {
            completion(nil)
            return
        }
        DatabaseManager.shared.findSongById(songId: son, completion: {[weak self] result in
            guard let strongSelf = self else {return}
            switch result {
            case .success(let song):
                let ref = Database.database().reference().child("Music Content").child("Songs").child("\(songContentTag)--\(song.name)--\(song.toneDeafAppId)").child("REQUIRED").child("Albums")
                let album = "\(strongSelf.currAlbum.toneDeafAppId)"
                var arrTo:[String] = []
                if var arrrr = song.albums {
                    if arrrr.contains(album) {
                        let index = arrrr.firstIndex(of: album)
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
    
    func addAlbumToSong(son: String, completion: @escaping ((Error?) -> Void)) {
        guard son.count == 10 else {
            completion(nil)
            return
        }
        
        DatabaseManager.shared.findSongById(songId: son, completion: {[weak self] result in
            guard let strongSelf = self else {return}
            switch result {
            case .success(let song):
                let ref = Database.database().reference().child("Music Content").child("Songs").child("\(songContentTag)--\(song.name)--\(song.toneDeafAppId)").child("REQUIRED").child("Albums")
                let album = "\(strongSelf.currAlbum.toneDeafAppId)"
                var arrTo:[String] = []
                if let psong = song.albums {
                    arrTo = psong
                    if !psong.contains(album) {
                        arrTo.append(album)
                    }
                } else {
                    arrTo = []
                    arrTo.append(album)
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
    
    //MARK: - Videos
    func processVideos(initialAlbum: AlbumData, currentAlbum: AlbumData, completion: @escaping (([Error]?) -> Void)) {
        initAlbum = initialAlbum
        currAlbum = currentAlbum
        
        initRef = Database.database().reference().child("Music Content").child("Albums").child("\(albumContentTag)--\(initAlbum.name)--\(initAlbum.toneDeafAppId)")
        currRef = Database.database().reference().child("Music Content").child("Albums").child("\(albumContentTag)--\(currAlbum.name)--\(currAlbum.toneDeafAppId)")
        var errors:[Error] = []
        var dataUploadCompletionStatus1:Bool!
        var dataUploadCompletionStatus2:Bool!
        
        let aqueue = DispatchQueue(label: "myhjvkheditingQalbumVideoshfdChangessseue")
        let agroup = DispatchGroup()
        let array:[Int] = [1,2]
        for i in array {
            agroup.enter()
            aqueue.async { [weak self] in
                guard let strongSelf = self else {return}
                switch i {
                case 1:
                    strongSelf.updateAlbumVideos(ref: strongSelf.currRef, completion: {err in
                        if let error = err {
                            dataUploadCompletionStatus1 = false
                            errors.append(error)
                        } else {
                            dataUploadCompletionStatus1 = true
                            print("Album Videos Update done \(i)")
                        }
                        agroup.leave()
                    })
                case 2:
                    strongSelf.updateVideoAlbums(ref: strongSelf.currRef, completion: {err in
                        if let error = err {
                            dataUploadCompletionStatus1 = false
                            errors.append(error)
                        } else {
                            dataUploadCompletionStatus1 = true
                            print("Video Albums Update done \(i)")
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
    
    func updateAlbumVideos(ref: DatabaseReference, completion: @escaping ((Error?) -> Void)) {
        var initialAlbumArrFromDB:[String]!
        
        ref.child("Videos").child("Official").child("id").setValue(currAlbum.officialAlbumVideo)
        
        if currAlbum.videos == initAlbum.videos {
            completion(nil)
            return
        }
        getAlbumVideosInDB(ref: ref, completion: {[weak self] videos in
            guard let strongSelf = self else {return}
            initialAlbumArrFromDB = videos
            
            if !initialAlbumArrFromDB.isEmpty {
                var removalCounter = 0
                for i in 0 ... initialAlbumArrFromDB.count-1 {
                    if strongSelf.currAlbum.videos != nil {
                        if i < strongSelf.currAlbum.videos!.count {
                            if !strongSelf.currAlbum.videos![i].contains(initialAlbumArrFromDB[i]) {
                                let index = initialAlbumArrFromDB.firstIndex(of: initialAlbumArrFromDB[i])
                                initialAlbumArrFromDB.remove(at: index!)
                                removalCounter+=1
                            }
                        } else {
                            let index = initialAlbumArrFromDB.firstIndex(of: initialAlbumArrFromDB[i-removalCounter])
                            initialAlbumArrFromDB.remove(at: index!)
                            removalCounter+=1
                        }
                    } else {
                        let index = initialAlbumArrFromDB.firstIndex(of: initialAlbumArrFromDB[i-removalCounter])
                        initialAlbumArrFromDB.remove(at: index!)
                        removalCounter+=1
                    }
                }
            }
            
            if strongSelf.currAlbum.videos != nil {
                if !strongSelf.currAlbum.videos!.isEmpty {
                    for i in 0 ... strongSelf.currAlbum.videos!.count-1 {
                        if i < initialAlbumArrFromDB.count {
                            if !initialAlbumArrFromDB[i].contains(strongSelf.currAlbum.videos![i]) {
                                initialAlbumArrFromDB.append(strongSelf.currAlbum.videos![i])
                            }
                        } else {
                            initialAlbumArrFromDB.append(strongSelf.currAlbum.videos![i])
                        }
                    }
                }
            }
            ref.child("REQUIRED").child("Videos").setValue(initialAlbumArrFromDB.sorted(), withCompletionBlock: { error, reference in
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
    
    func getAlbumVideosInDB(ref: DatabaseReference, completion: @escaping (([String]) -> Void)) {
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
    
    func updateVideoAlbums(ref: DatabaseReference, completion: @escaping ((Error?) -> Void)) {
        var initialArtistsArrFromDB:[String]!
        var totalProgress:Int = 0
        var completedProgress:Int = 0
        if currAlbum.videos!.sorted() == initAlbum.videos?.sorted() {
            completion(nil)
            return
        }
        
        getAlbumVideosInDB(ref: ref, completion: {[weak self] persons in
            guard let strongSelf = self else {return}
            initialArtistsArrFromDB = persons.sorted()
            
            if !initialArtistsArrFromDB.isEmpty {
                for i in 0 ... initialArtistsArrFromDB.count-1 {
                    if strongSelf.currAlbum.videos != nil {
                        if i < strongSelf.currAlbum.videos!.count {
                            if !strongSelf.currAlbum.videos![i].contains(initialArtistsArrFromDB[i]) {
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
            
            if strongSelf.currAlbum.videos != nil {
                if !strongSelf.currAlbum.videos!.isEmpty {
                    for i in 0 ... strongSelf.currAlbum.videos!.count-1 {
                        if i < initialArtistsArrFromDB.count {
                            if !initialArtistsArrFromDB[i].contains(strongSelf.currAlbum.videos![i]) {
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
                    if strongSelf.currAlbum.videos != nil {
                        if i < strongSelf.currAlbum.videos!.count {
                            if !strongSelf.currAlbum.videos![i].contains(initialArtistsArrFromDB[i]) {
                                strongSelf.removeAlbumFromVideo(vid: initialArtistsArrFromDB[i], completion: { error in
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
                            strongSelf.removeAlbumFromVideo(vid: initialArtistsArrFromDB[i], completion: { error in
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
                        strongSelf.removeAlbumFromVideo(vid: initialArtistsArrFromDB[i], completion: { error in
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
            
            if strongSelf.currAlbum.videos != nil {
                if !strongSelf.currAlbum.videos!.isEmpty {
                    for i in 0 ... strongSelf.currAlbum.videos!.count-1 {
                        if i < initialArtistsArrFromDB.count {
                            if !initialArtistsArrFromDB[i].contains(strongSelf.currAlbum.videos![i]) {
                                strongSelf.addAlbumToVideo(vid: strongSelf.currAlbum.videos![i], completion: { error in
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
                            strongSelf.addAlbumToVideo(vid: strongSelf.currAlbum.videos![i], completion: { error in
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
    
    func removeAlbumFromVideo(vid: String, completion: @escaping ((Error?) -> Void)) {
        guard vid.count == 9 else {
            completion(nil)
            return
        }
        DatabaseManager.shared.findVideoById(videoid: vid, completion: {[weak self] result in
            guard let strongSelf = self else {return}
            switch result {
            case .success(let video):
                let ref = Database.database().reference().child("Music Content").child("Videos").child( "\(videoContentTag)--\(video.title.replacingOccurrences(of: ".", with: " ").replacingOccurrences(of: "#", with: " ").replacingOccurrences(of: "$", with: " ").replacingOccurrences(of: "[", with: " ").replacingOccurrences(of: "]", with: " ").replacingOccurrences(of: ":", with: " "))--\(video.toneDeafAppId)").child("Albums")
                let song = "\(strongSelf.currAlbum.toneDeafAppId)"
                var arrto:[String] = []
                if var arrrr = video.albums as? [String] {
                    if arrrr.contains(song) {
                        let index = arrrr.firstIndex(of: song)
                        arrrr.remove(at: index!)
                        video.albums = arrrr.sorted()
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
    
    func addAlbumToVideo(vid: String, completion: @escaping ((Error?) -> Void)) {
        guard vid.count == 9 else {
            completion(nil)
            return
        }
        
        DatabaseManager.shared.findVideoById(videoid: vid, completion: {[weak self] result in
            guard let strongSelf = self else {return}
            switch result {
            case .success(let video):
                let ref = Database.database().reference().child("Music Content").child("Videos").child( "\(videoContentTag)--\(video.title.replacingOccurrences(of: ".", with: " ").replacingOccurrences(of: "#", with: " ").replacingOccurrences(of: "$", with: " ").replacingOccurrences(of: "[", with: " ").replacingOccurrences(of: "]", with: " ").replacingOccurrences(of: ":", with: " "))--\(video.toneDeafAppId)").child("Albums")
                let song = "\(strongSelf.currAlbum.toneDeafAppId)"
                var arrto:[String] = []
                if var allArt = video.albums {
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
    
    //MARK: - Songs
    func processInstrumentals(initialAlbum: AlbumData, currentAlbum: AlbumData, completion: @escaping (([Error]?) -> Void)) {
        initAlbum = initialAlbum
        currAlbum = currentAlbum
        var errors:[Error] = []
        initRef = Database.database().reference().child("Music Content").child("Albums").child("\(albumContentTag)--\(initAlbum.name)--\(initAlbum.toneDeafAppId)")
        currRef = Database.database().reference().child("Music Content").child("Albums").child("\(albumContentTag)--\(currAlbum.name)--\(currAlbum.toneDeafAppId)")
        
        var dataUploadCompletionStatus1:Bool!
        var dataUploadCompletionStatus2:Bool!
        let aqueue = DispatchQueue(label: "myhjvkheditingQalbumsInstrumentalsssseue")
        let agroup = DispatchGroup()
        let array:[Int] = [1,2]
        for i in array {
            agroup.enter()
            aqueue.async { [weak self] in
                guard let strongSelf = self else {return}
                switch i {
                case 1:
                    strongSelf.updateAlbumInstrumentals(ref: strongSelf.currRef, completion: {err in
                        if let error = err {
                            dataUploadCompletionStatus1 = false
                            errors.append(error)
                        } else {
                            dataUploadCompletionStatus1 = true
                            print("Album Instrumentals update done \(i)")
                        }
                        agroup.leave()
                    })
                case 2:
                    strongSelf.updateInstrumentalAlbums(ref: strongSelf.currRef, completion: {err in
                        if let error = err {
                            dataUploadCompletionStatus2 = false
                            errors.append(error)
                        } else {
                            dataUploadCompletionStatus2 = true
                            print("Instrumental albums update done \(i)")
                        }
                        agroup.leave()
                    })
                default:
                    print("Edit Instrumental error")
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
    
    func updateAlbumInstrumentals(ref: DatabaseReference, completion: @escaping ((Error?) -> Void)) {
        var initialArtistsArrFromDB:[String]!
        if currAlbum.instrumentals!.sorted() == initAlbum.instrumentals?.sorted() {
            completion(nil)
            return
        }
        getAlbumInstrumentalsInDB(ref: ref, completion: {[weak self] instrumentals in
            guard let strongSelf = self else {return}
            initialArtistsArrFromDB = instrumentals.sorted()
            
            if !initialArtistsArrFromDB.isEmpty {
                var removalCounter = 0
                for i in 0 ... initialArtistsArrFromDB.count-1 {
                    if strongSelf.currAlbum.instrumentals != nil {
                        if i < strongSelf.currAlbum.instrumentals!.count {
                            if i <= initialArtistsArrFromDB.count-removalCounter {
                                if !strongSelf.currAlbum.instrumentals!.contains(initialArtistsArrFromDB[i]) {
                                    let index = initialArtistsArrFromDB.firstIndex(of: initialArtistsArrFromDB[i])
                                    initialArtistsArrFromDB.remove(at: index!)
                                    removalCounter+=1
                                }
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
            
            if strongSelf.currAlbum.instrumentals != nil {
                if !strongSelf.currAlbum.instrumentals!.isEmpty {
                    for i in 0 ... strongSelf.currAlbum.instrumentals!.count-1 {
                        if i < initialArtistsArrFromDB.count {
                            if !initialArtistsArrFromDB.contains(strongSelf.currAlbum.instrumentals![i]) {
                                initialArtistsArrFromDB.append(strongSelf.currAlbum.instrumentals![i])
                            }
                        } else {
                            initialArtistsArrFromDB.append(strongSelf.currAlbum.instrumentals![i])
                        }
                    }
                }
            }
            ref.child("REQUIRED").child("Instrumentals").setValue(initialArtistsArrFromDB.sorted(), withCompletionBlock: { error, reference in
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
    
    func getAlbumInstrumentalsInDB(ref: DatabaseReference, completion: @escaping (([String]) -> Void)) {
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
    
    func updateInstrumentalAlbums(ref: DatabaseReference, completion: @escaping ((Error?) -> Void)) {
        var initialArtistsArrFromDB:[String]!
        var totalProgress:Int = 0
        var completedProgress:Int = 0
        if currAlbum.instrumentals!.sorted() == initAlbum.instrumentals?.sorted() {
            completion(nil)
            return
        }
        
        getAlbumInstrumentalsInDB(ref: ref, completion: {[weak self] instrumentals in
            guard let strongSelf = self else {return}
            initialArtistsArrFromDB = instrumentals.sorted()
            
            if !initialArtistsArrFromDB.isEmpty {
                var removalCounter = 0
                for i in 0 ... initialArtistsArrFromDB.count-1 {
                    if strongSelf.currAlbum.instrumentals != nil {
                        if i < strongSelf.currAlbum.instrumentals!.count {
                            if !strongSelf.currAlbum.instrumentals!.contains(initialArtistsArrFromDB[i]) {
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
            
            if strongSelf.currAlbum.instrumentals != nil {
                if !strongSelf.currAlbum.instrumentals!.isEmpty {
                    for i in 0 ... strongSelf.currAlbum.instrumentals!.count-1 {
                        if i < initialArtistsArrFromDB.count {
                            if !initialArtistsArrFromDB.contains(strongSelf.currAlbum.instrumentals![i]) {
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
                    if strongSelf.currAlbum.instrumentals != nil {
                        if i < strongSelf.currAlbum.instrumentals!.count {
                            if !strongSelf.currAlbum.instrumentals!.contains(initialArtistsArrFromDB[i]) {
                                strongSelf.removeAlbumFromInstrumental(son: initialArtistsArrFromDB[i], completion: { error in
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
                            strongSelf.removeAlbumFromInstrumental(son: initialArtistsArrFromDB[i], completion: { error in
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
                        strongSelf.removeAlbumFromInstrumental(son: initialArtistsArrFromDB[i], completion: { error in
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
            
            if strongSelf.currAlbum.instrumentals != nil {
                if !strongSelf.currAlbum.instrumentals!.isEmpty {
                    for i in 0 ... strongSelf.currAlbum.instrumentals!.count-1 {
                        if i < initialArtistsArrFromDB.count {
                            if !initialArtistsArrFromDB.contains(strongSelf.currAlbum.instrumentals![i]) {
                                strongSelf.addAlbumToInstrumental(son: strongSelf.currAlbum.instrumentals![i], completion: { error in
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
                            strongSelf.addAlbumToInstrumental(son: strongSelf.currAlbum.instrumentals![i], completion: { error in
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
    
    func removeAlbumFromInstrumental(son: String, completion: @escaping ((Error?) -> Void)) {
        guard son.count == 12 else {
            completion(nil)
            return
        }
        DatabaseManager.shared.findInstrumentalById(instrumentalId: son, completion: {[weak self] result in
            guard let strongSelf = self else {return}
            switch result {
            case .success(let song):
                let ref = Database.database().reference().child("Music Content").child("Instrumentals").child("\(instrumentalContentType)--\(song.songName!)--\(song.toneDeafAppId)").child("Albums")
                let album = "\(strongSelf.currAlbum.toneDeafAppId)"
                var arrTo:[String] = []
                if var arrrr = song.albums {
                    if arrrr.contains(album) {
                        let index = arrrr.firstIndex(of: album)
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
    
    func addAlbumToInstrumental(son: String, completion: @escaping ((Error?) -> Void)) {
        guard son.count == 12 else {
            completion(nil)
            return
        }
        DatabaseManager.shared.findInstrumentalById(instrumentalId: son, completion: {[weak self] result in
            guard let strongSelf = self else {return}
            switch result {
            case .success(let song):
                let ref = Database.database().reference().child("Music Content").child("Instrumentals").child("\(instrumentalContentType)--\(song.songName!)--\(song.toneDeafAppId)").child("Albums")
                let album = "\(strongSelf.currAlbum.toneDeafAppId)"
                var arrTo:[String] = []
                if let psong = song.albums {
                    arrTo = psong
                    if !psong.contains(album) {
                        arrTo.append(album)
                    }
                } else {
                    arrTo = []
                    arrTo.append(album)
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
    
    //MARK: - Verification Level
    func processVerificationLevel(initialAlbum: AlbumData, currentAlbum: AlbumData, completion: @escaping ((Error?) -> Void)) {
        initAlbum = initialAlbum
        currAlbum = currentAlbum
        let ref = Database.database().reference().child("Music Content").child("Albums").child("\(albumContentTag)--\(currAlbum.name)--\(currAlbum.toneDeafAppId)").child("REQUIRED").child("Verification Level")
        ref.setValue(String(currAlbum.verificationLevel!), withCompletionBlock: { error, reference in
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
    
    //MARK: - Deluxe
    func processDeluxe(initialAlbum: AlbumData, currentAlbum: AlbumData, completion: @escaping (([Error]?) -> Void)) {
        initAlbum = initialAlbum
        currAlbum = currentAlbum
        var errors:[Error] = []
        initRef = Database.database().reference().child("Music Content").child("Albums").child("\(albumContentTag)--\(initAlbum.name)--\(initAlbum.toneDeafAppId)")
        currRef = Database.database().reference().child("Music Content").child("Albums").child("\(albumContentTag)--\(currAlbum.name)--\(currAlbum.toneDeafAppId)")
        var dataUploadCompletionStatus1:Bool!
        var dataUploadCompletionStatus2:Bool!
        
        let aqueue = DispatchQueue(label: "myhjvkheditingQalbumDeluxesshfdChangessseue")
        let agroup = DispatchGroup()
        let array:[Int] = [1,2]
        for i in array {
            agroup.enter()
            aqueue.async { [weak self] in
                guard let strongSelf = self else {return}
                switch i {
                case 1:
                    strongSelf.updateAlbumDeluxes(ref: strongSelf.currRef, completion: {err in
                        if let error = err {
                            dataUploadCompletionStatus1 = false
                            errors.append(error)
                        } else {
                            dataUploadCompletionStatus1 = true
                            print("Album Deluxes Update done \(i)")
                        }
                        agroup.leave()
                    })
                case 2:
                    strongSelf.updateDeluxeAlbumisDeluxe(ref: strongSelf.currRef, completion: {err in
                        if let error = err {
                            dataUploadCompletionStatus1 = false
                            errors.append(error)
                        } else {
                            dataUploadCompletionStatus1 = true
                            print("Deluxe Album Is Deluxe Update done \(i)")
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
    
    func updateAlbumDeluxes(ref: DatabaseReference, completion: @escaping ((Error?) -> Void)) {
        
        var initialAlbumArrFromDB:[String]!
        if currAlbum.deluxes == initAlbum.deluxes {
            completion(nil)
            return
        }
        getAlbumDeluxesInDB(ref: ref, completion: {[weak self] deluxes in
            guard let strongSelf = self else {return}
            initialAlbumArrFromDB = deluxes
            
            if !initialAlbumArrFromDB.isEmpty {
                var removalCounter = 0
                for i in 0 ... initialAlbumArrFromDB.count-1 {
                    if strongSelf.currAlbum.deluxes != nil {
                        if i < strongSelf.currAlbum.deluxes!.count {
                            if !strongSelf.currAlbum.deluxes!.contains(initialAlbumArrFromDB[i]) {
                                let index = initialAlbumArrFromDB.firstIndex(of: initialAlbumArrFromDB[i])
                                initialAlbumArrFromDB.remove(at: index!)
                                removalCounter+=1
                            }
                        } else {
                            let index = initialAlbumArrFromDB.firstIndex(of: initialAlbumArrFromDB[i-removalCounter])
                            initialAlbumArrFromDB.remove(at: index!)
                            removalCounter+=1
                        }
                    } else {
                        let index = initialAlbumArrFromDB.firstIndex(of: initialAlbumArrFromDB[i-removalCounter])
                        initialAlbumArrFromDB.remove(at: index!)
                        removalCounter+=1
                    }
                }
            }
            
            if strongSelf.currAlbum.deluxes != nil {
                if !strongSelf.currAlbum.deluxes!.isEmpty {
                    for i in 0 ... strongSelf.currAlbum.deluxes!.count-1 {
                        if i < initialAlbumArrFromDB.count {
                            if !initialAlbumArrFromDB.contains(strongSelf.currAlbum.deluxes![i]) {
                                initialAlbumArrFromDB.append(strongSelf.currAlbum.deluxes![i])
                            }
                        } else {
                            initialAlbumArrFromDB.append(strongSelf.currAlbum.deluxes![i])
                        }
                    }
                }
            }
            ref.child("REQUIRED").child("Deluxes").setValue(initialAlbumArrFromDB.sorted(), withCompletionBlock: { error, reference in
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
    
    func getAlbumDeluxesInDB(ref: DatabaseReference, completion: @escaping (([String]) -> Void)) {
        ref.child("REQUIRED").child("Deluxes").observeSingleEvent(of: .value, with: { snapshot in
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
    
    func updateDeluxeAlbumisDeluxe(ref: DatabaseReference, completion: @escaping ((Error?) -> Void)) {
        var initialArtistsArrFromDB:[String]!
        var totalProgress:Int = 0
        var completedProgress:Int = 0
        if currAlbum.deluxes!.sorted() == initAlbum.deluxes?.sorted() {
            completion(nil)
            return
        }
        
        getAlbumDeluxesInDB(ref: ref, completion: {[weak self] persons in
            guard let strongSelf = self else {return}
            initialArtistsArrFromDB = persons.sorted()
            
            if !initialArtistsArrFromDB.isEmpty {
                for i in 0 ... initialArtistsArrFromDB.count-1 {
                    if strongSelf.currAlbum.deluxes != nil {
                        if i < strongSelf.currAlbum.deluxes!.count {
                            if !strongSelf.currAlbum.deluxes!.contains(initialArtistsArrFromDB[i]) {
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
            
            if strongSelf.currAlbum.deluxes != nil {
                if !strongSelf.currAlbum.deluxes!.isEmpty {
                    for i in 0 ... strongSelf.currAlbum.deluxes!.count-1 {
                        if i < initialArtistsArrFromDB.count {
                            if !initialArtistsArrFromDB.contains(strongSelf.currAlbum.deluxes![i]) {
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
                    if strongSelf.currAlbum.deluxes != nil {
                        if i < strongSelf.currAlbum.deluxes!.count {
                            if !strongSelf.currAlbum.deluxes!.contains(initialArtistsArrFromDB[i]) {
                                strongSelf.removeisDeluxeFromAlbum(son: initialArtistsArrFromDB[i], completion: { error in
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
                            strongSelf.removeisDeluxeFromAlbum(son: initialArtistsArrFromDB[i], completion: { error in
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
                        strongSelf.removeisDeluxeFromAlbum(son: initialArtistsArrFromDB[i], completion: { error in
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
            
            if strongSelf.currAlbum.deluxes != nil {
                if !strongSelf.currAlbum.deluxes!.isEmpty {
                    for i in 0 ... strongSelf.currAlbum.deluxes!.count-1 {
                        if i < initialArtistsArrFromDB.count {
                            if !initialArtistsArrFromDB[i].contains(strongSelf.currAlbum.deluxes![i]) {
                                strongSelf.addisDeluxeToAlbum(son: strongSelf.currAlbum.deluxes![i], completion: { error in
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
                            strongSelf.addisDeluxeToAlbum(son: strongSelf.currAlbum.deluxes![i], completion: { error in
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
    
    func removeisDeluxeFromAlbum(son: String, completion: @escaping ((Error?) -> Void)) {
        guard son.count == 8 else {
            completion(nil)
            return
        }
        DatabaseManager.shared.findAlbumById(albumId: son, completion: {[weak self] result in
            guard let strongSelf = self else {return}
            switch result {
            case .success(let song):
                let ref = Database.database().reference().child("Music Content").child("Albums").child( "\(albumContentTag)--\(song.name)--\(song.toneDeafAppId)").child("REQUIRED").child("Deluxe")
                
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
    
    func addisDeluxeToAlbum(son: String, completion: @escaping ((Error?) -> Void)) {
        guard son.count == 8 else {
            completion(nil)
            return
        }
        DatabaseManager.shared.findAlbumById(albumId: son, completion: {[weak self] result in
            guard let strongSelf = self else {return}
            switch result {
            case .success(let song):
                let ref = Database.database().reference().child("Music Content").child("Albums").child( "\(albumContentTag)--\(song.name)--\(song.toneDeafAppId)").child("REQUIRED").child("Deluxe")
                let stansong = "\(strongSelf.currAlbum.toneDeafAppId)"
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
    func processOtherVersions(initialAlbum: AlbumData, currentAlbum: AlbumData, completion: @escaping (([Error]?) -> Void)) {
        initAlbum = initialAlbum
        currAlbum = currentAlbum
        var errors:[Error] = []
        initRef = Database.database().reference().child("Music Content").child("Albums").child("\(albumContentTag)--\(initAlbum.name)--\(initAlbum.toneDeafAppId)")
        currRef = Database.database().reference().child("Music Content").child("Albums").child("\(albumContentTag)--\(currAlbum.name)--\(currAlbum.toneDeafAppId)")
        var dataUploadCompletionStatus1:Bool!
        var dataUploadCompletionStatus2:Bool!
        
        let aqueue = DispatchQueue(label: "myhjvkheditingQalbumOtherVersionshfdChangessseue")
        let agroup = DispatchGroup()
        let array:[Int] = [1,2]
        for i in array {
            agroup.enter()
            aqueue.async { [weak self] in
                guard let strongSelf = self else {return}
                switch i {
                case 1:
                    strongSelf.updateAlbumOtherVersions(ref: strongSelf.currRef, completion: {err in
                        if let error = err {
                            dataUploadCompletionStatus1 = false
                            errors.append(error)
                        } else {
                            dataUploadCompletionStatus1 = true
                            print("Album Other Versions Update done \(i)")
                        }
                        agroup.leave()
                    })
                case 2:
                    strongSelf.updateOtherVersionsAlbumIsOtherVersion(ref: strongSelf.currRef, completion: {err in
                        if let error = err {
                            dataUploadCompletionStatus1 = false
                            errors.append(error)
                        } else {
                            dataUploadCompletionStatus1 = true
                            print("Other Version Album Is Other Version Update done \(i)")
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
    
    func updateAlbumOtherVersions(ref: DatabaseReference, completion: @escaping ((Error?) -> Void)) {
        
        var initialAlbumArrFromDB:[String]!
        if currAlbum.otherVersions == initAlbum.otherVersions {
            completion(nil)
            return
        }
        getAlbumOtherVersionsInDB(ref: ref, completion: {[weak self] otherVersions in
            guard let strongSelf = self else {return}
            initialAlbumArrFromDB = otherVersions
            
            if !initialAlbumArrFromDB.isEmpty {
                var removalCounter = 0
                for i in 0 ... initialAlbumArrFromDB.count-1 {
                    if strongSelf.currAlbum.otherVersions != nil {
                        if i < strongSelf.currAlbum.otherVersions!.count {
                            if !strongSelf.currAlbum.otherVersions!.contains(initialAlbumArrFromDB[i]) {
                                let index = initialAlbumArrFromDB.firstIndex(of: initialAlbumArrFromDB[i])
                                initialAlbumArrFromDB.remove(at: index!)
                                removalCounter+=1
                            }
                        } else {
                            let index = initialAlbumArrFromDB.firstIndex(of: initialAlbumArrFromDB[i-removalCounter])
                            initialAlbumArrFromDB.remove(at: index!)
                            removalCounter+=1
                        }
                    } else {
                        let index = initialAlbumArrFromDB.firstIndex(of: initialAlbumArrFromDB[i-removalCounter])
                        initialAlbumArrFromDB.remove(at: index!)
                        removalCounter+=1
                    }
                }
            }
            
            if strongSelf.currAlbum.otherVersions != nil {
                if !strongSelf.currAlbum.otherVersions!.isEmpty {
                    for i in 0 ... strongSelf.currAlbum.otherVersions!.count-1 {
                        if i < initialAlbumArrFromDB.count {
                            if !initialAlbumArrFromDB.contains(strongSelf.currAlbum.otherVersions![i]) {
                                initialAlbumArrFromDB.append(strongSelf.currAlbum.otherVersions![i])
                            }
                        } else {
                            initialAlbumArrFromDB.append(strongSelf.currAlbum.otherVersions![i])
                        }
                    }
                }
            }
            ref.child("REQUIRED").child("Other Versions").setValue(initialAlbumArrFromDB.sorted(), withCompletionBlock: { error, reference in
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
    
    func getAlbumOtherVersionsInDB(ref: DatabaseReference, completion: @escaping (([String]) -> Void)) {
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
    
    func updateOtherVersionsAlbumIsOtherVersion(ref: DatabaseReference, completion: @escaping ((Error?) -> Void)) {
        var initialArtistsArrFromDB:[String]!
        var totalProgress:Int = 0
        var completedProgress:Int = 0
        if currAlbum.otherVersions!.sorted() == initAlbum.otherVersions?.sorted() {
            completion(nil)
            return
        }
        
        getAlbumOtherVersionsInDB(ref: ref, completion: {[weak self] persons in
            guard let strongSelf = self else {return}
            initialArtistsArrFromDB = persons.sorted()
            
            if !initialArtistsArrFromDB.isEmpty {
                for i in 0 ... initialArtistsArrFromDB.count-1 {
                    if strongSelf.currAlbum.otherVersions != nil {
                        if i < strongSelf.currAlbum.otherVersions!.count {
                            if !strongSelf.currAlbum.otherVersions!.contains(initialArtistsArrFromDB[i]) {
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
            
            if strongSelf.currAlbum.otherVersions != nil {
                if !strongSelf.currAlbum.otherVersions!.isEmpty {
                    for i in 0 ... strongSelf.currAlbum.otherVersions!.count-1 {
                        if i < initialArtistsArrFromDB.count {
                            if !initialArtistsArrFromDB.contains(strongSelf.currAlbum.otherVersions![i]) {
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
                    if strongSelf.currAlbum.otherVersions != nil {
                        if i < strongSelf.currAlbum.otherVersions!.count {
                            if !strongSelf.currAlbum.otherVersions!.contains(initialArtistsArrFromDB[i]) {
                                strongSelf.removeIsOtherVersionsFromAlbum(son: initialArtistsArrFromDB[i], completion: { error in
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
                            strongSelf.removeIsOtherVersionsFromAlbum(son: initialArtistsArrFromDB[i], completion: { error in
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
                        strongSelf.removeIsOtherVersionsFromAlbum(son: initialArtistsArrFromDB[i], completion: { error in
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
            
            if strongSelf.currAlbum.otherVersions != nil {
                if !strongSelf.currAlbum.otherVersions!.isEmpty {
                    for i in 0 ... strongSelf.currAlbum.otherVersions!.count-1 {
                        if i < initialArtistsArrFromDB.count {
                            if !initialArtistsArrFromDB[i].contains(strongSelf.currAlbum.otherVersions![i]) {
                                strongSelf.addIsOtherVersionsToAlbum(son: strongSelf.currAlbum.otherVersions![i], completion: { error in
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
                            strongSelf.addIsOtherVersionsToAlbum(son: strongSelf.currAlbum.otherVersions![i], completion: { error in
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
    
    func removeIsOtherVersionsFromAlbum(son: String, completion: @escaping ((Error?) -> Void)) {
        guard son.count == 8 else {
            completion(nil)
            return
        }
        DatabaseManager.shared.findAlbumById(albumId:  son, completion: {[weak self] result in
            guard let strongSelf = self else {return}
            switch result {
            case .success(let song):
                let ref = Database.database().reference().child("Music Content").child("Albums").child( "\(albumContentTag)--\(song.name)--\(song.toneDeafAppId)").child("REQUIRED").child("Other Version")
                
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
    
    func addIsOtherVersionsToAlbum(son: String, completion: @escaping ((Error?) -> Void)) {
        guard son.count == 8 else {
            completion(nil)
            return
        }
        DatabaseManager.shared.findAlbumById(albumId: son, completion: {[weak self] result in
            guard let strongSelf = self else {return}
            switch result {
            case .success(let song):
                let ref = Database.database().reference().child("Music Content").child("Albums").child( "\(albumContentTag)--\(song.name)--\(song.toneDeafAppId)").child("REQUIRED").child("Other Version")
                let stansong = "\(strongSelf.currAlbum.toneDeafAppId)"
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
    
    //MARK: - isDeluxees
    func processisDeluxees(initialAlbum: AlbumData, currentAlbum: AlbumData,initSE: String?, completion: @escaping (([Error]?) -> Void)) {
        initAlbum = initialAlbum
        currAlbum = currentAlbum
        var errors:[Error] = []
        initRef = Database.database().reference().child("Music Content").child("Albums").child("\(albumContentTag)--\(initAlbum.name)--\(initAlbum.toneDeafAppId)")
        currRef = Database.database().reference().child("Music Content").child("Albums").child("\(albumContentTag)--\(currAlbum.name)--\(currAlbum.toneDeafAppId)")
        var dataUploadCompletionStatus1:Bool!
        var dataUploadCompletionStatus2:Bool!
        
        let aqueue = DispatchQueue(label: "myhjvkheditingQalbumDeluxeshfdChangessseue")
        let agroup = DispatchGroup()
        let array:[Int] = [1,2]
        for i in array {
            agroup.enter()
            aqueue.async { [weak self] in
                guard let strongSelf = self else {return}
                switch i {
                case 1:
                    strongSelf.updateDeluxeAlbumDeluxes(ref: strongSelf.currRef,initSE:initSE, completion: {err in
                        if let error = err {
                            dataUploadCompletionStatus1 = false
                            errors.append(error)
                        } else {
                            dataUploadCompletionStatus1 = true
                            print("Deluxe Album Deluxes Update done \(i)")
                        }
                        agroup.leave()
                    })
                case 2:
                    strongSelf.updateAlbumisDeluxe(ref: strongSelf.currRef, completion: {err in
                        if let error = err {
                            dataUploadCompletionStatus1 = false
                            errors.append(error)
                        } else {
                            dataUploadCompletionStatus1 = true
                            print("Album Is Deluxe Update done \(i)")
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
    
    func updateAlbumisDeluxe(ref: DatabaseReference, completion: @escaping ((Error?) -> Void)) {
//        if currAlbum.isDeluxe == initAlbum.isDeluxe {
//            completion(nil)
//            return
//        }
        var arrto:NSDictionary!
        let ref = ref.child("REQUIRED").child("Deluxe")
        if currAlbum.isDeluxe != nil {
            arrto = [
                "Standard Edition": currAlbum.isDeluxe?.standardEdition,
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
    
    func updateDeluxeAlbumDeluxes(ref: DatabaseReference,initSE: String?, completion: @escaping ((Error?) -> Void)) {
        var totalProgress:Int = 0
        var completedProgress:Int = 0
        
        if currAlbum.isDeluxe?.standardEdition == nil && initSE == nil {
            completion(nil)
            return
        }
        if currAlbum.isDeluxe?.standardEdition == initSE {
            completion(nil)
            return
        }
        
        if initSE != nil {
            totalProgress+=1
            if currAlbum.isDeluxe?.standardEdition != nil {
                totalProgress+=1
            }
        } else {
            if currAlbum.isDeluxe?.standardEdition != nil {
                totalProgress+=1
            }
        }
        
        if totalProgress == 0 {
            completion(nil)
            return
        }
        
        if initSE != nil {
            removeAlbumFromDeluxes(son: initSE!, completion: { error in
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
            if currAlbum.isDeluxe?.standardEdition != nil {
                addAlbumToDeluxes(son: currAlbum.isDeluxe!.standardEdition!, completion: { error in
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
            if currAlbum.isDeluxe?.standardEdition != nil {
                addAlbumToDeluxes(son: currAlbum.isDeluxe!.standardEdition!, completion: { error in
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
    
    func removeAlbumFromDeluxes(son: String, completion: @escaping ((Error?) -> Void)) {
        guard son.count == 8 else {
            completion(nil)
            return
        }
        DatabaseManager.shared.findAlbumById(albumId: son, completion: {[weak self] result in
            guard let strongSelf = self else {return}
            switch result {
            case .success(let song):
                let ref = Database.database().reference().child("Music Content").child("Albums").child( "\(albumContentTag)--\(song.name)--\(song.toneDeafAppId)").child("REQUIRED").child("Deluxes")
                var arrto:[String] = []
                if var arrrr = song.deluxes {
                    if arrrr.contains(strongSelf.currAlbum.toneDeafAppId) {
                        let index = arrrr.firstIndex(of: strongSelf.currAlbum.toneDeafAppId)
                        arrrr.remove(at: index!)
                        song.deluxes = arrrr.sorted()
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
    
    func addAlbumToDeluxes(son: String, completion: @escaping ((Error?) -> Void)) {
        guard son.count == 8 else {
            completion(nil)
            return
        }
        DatabaseManager.shared.findAlbumById(albumId: son, completion: {[weak self] result in
            guard let strongSelf = self else {return}
            switch result {
            case .success(let song):
                let ref = Database.database().reference().child("Music Content").child("Albums").child( "\(albumContentTag)--\(song.name)--\(song.toneDeafAppId)").child("REQUIRED").child("Deluxes")
                var arrto:[String] = []
                if var allArt = song.deluxes {
                    if !allArt.contains(strongSelf.currAlbum.toneDeafAppId) {
                        allArt.append(strongSelf.currAlbum.toneDeafAppId)
                        arrto = allArt.sorted()
                    }
                } else {
                    arrto = [strongSelf.currAlbum.toneDeafAppId]
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
    func processIsOtherVersions(initialAlbum: AlbumData, currentAlbum: AlbumData,initSE: String?, completion: @escaping (([Error]?) -> Void)) {
        initAlbum = initialAlbum
        currAlbum = currentAlbum
        var errors:[Error] = []
        initRef = Database.database().reference().child("Music Content").child("Albums").child("\(albumContentTag)--\(initAlbum.name)--\(initAlbum.toneDeafAppId)")
        currRef = Database.database().reference().child("Music Content").child("Albums").child("\(albumContentTag)--\(currAlbum.name)--\(currAlbum.toneDeafAppId)")
        var dataUploadCompletionStatus1:Bool!
        var dataUploadCompletionStatus2:Bool!
        
        let aqueue = DispatchQueue(label: "myhjvkheditingQalbumOtherVersionshfdChangessseue")
        let agroup = DispatchGroup()
        let array:[Int] = [1,2]
        for i in array {
            agroup.enter()
            aqueue.async { [weak self] in
                guard let strongSelf = self else {return}
                switch i {
                case 1:
                    strongSelf.updateOtherVersionAlbumOtherVersions(ref: strongSelf.currRef,initSE:initSE, completion: {err in
                        if let error = err {
                            dataUploadCompletionStatus1 = false
                            errors.append(error)
                        } else {
                            dataUploadCompletionStatus1 = true
                            print("OtherVersion Album OtherVersions Update done \(i)")
                        }
                        agroup.leave()
                    })
                case 2:
                    strongSelf.updateAlbumIsOtherVersion(ref: strongSelf.currRef, completion: {err in
                        if let error = err {
                            dataUploadCompletionStatus1 = false
                            errors.append(error)
                        } else {
                            dataUploadCompletionStatus1 = true
                            print("Album Is OtherVersion Update done \(i)")
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
    
    func updateAlbumIsOtherVersion(ref: DatabaseReference, completion: @escaping ((Error?) -> Void)) {
//        if currAlbum.isDeluxe == initAlbum.isDeluxe {
//            completion(nil)
//            return
//        }
        var arrto:NSDictionary!
        let ref = ref.child("REQUIRED").child("Other Version")
        if currAlbum.isOtherVersion != nil {
            arrto = [
                "Standard Edition": currAlbum.isOtherVersion?.standardEdition,
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
    
    func updateOtherVersionAlbumOtherVersions(ref: DatabaseReference,initSE: String?, completion: @escaping ((Error?) -> Void)) {
        var totalProgress:Int = 0
        var completedProgress:Int = 0
        
        if currAlbum.isOtherVersion?.standardEdition == nil && initSE == nil {
            completion(nil)
            return
        }
        if currAlbum.isOtherVersion?.standardEdition == initSE {
            completion(nil)
            return
        }
        
        if initSE != nil {
            totalProgress+=1
            if currAlbum.isOtherVersion?.standardEdition != nil {
                totalProgress+=1
            }
        } else {
            if currAlbum.isOtherVersion?.standardEdition != nil {
                totalProgress+=1
            }
        }
        
        if totalProgress == 0 {
            completion(nil)
            return
        }
        
        if initSE != nil {
            removeAlbumFromOtherVersions(son: initSE!, completion: { error in
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
            if currAlbum.isOtherVersion?.standardEdition != nil {
                addAlbumToOtherVersions(son: currAlbum.isOtherVersion!.standardEdition!, completion: { error in
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
            if currAlbum.isOtherVersion?.standardEdition != nil {
                addAlbumToOtherVersions(son: currAlbum.isOtherVersion!.standardEdition!, completion: { error in
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
    
    func removeAlbumFromOtherVersions(son: String, completion: @escaping ((Error?) -> Void)) {
        guard son.count == 8 else {
            completion(nil)
            return
        }
        DatabaseManager.shared.findAlbumById(albumId: son, completion: {[weak self] result in
            guard let strongSelf = self else {return}
            switch result {
            case .success(let song):
                let ref = Database.database().reference().child("Music Content").child("Albums").child( "\(albumContentTag)--\(song.name)--\(song.toneDeafAppId)").child("REQUIRED").child("Other Versions")
                var arrto:[String] = []
                if var arrrr = song.otherVersions {
                    if arrrr.contains(strongSelf.currAlbum.toneDeafAppId) {
                        let index = arrrr.firstIndex(of: strongSelf.currAlbum.toneDeafAppId)
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
    
    func addAlbumToOtherVersions(son: String, completion: @escaping ((Error?) -> Void)) {
        guard son.count == 8 else {
            completion(nil)
            return
        }
        DatabaseManager.shared.findAlbumById(albumId: son, completion: {[weak self] result in
            guard let strongSelf = self else {return}
            switch result {
            case .success(let song):
                let ref = Database.database().reference().child("Music Content").child("Albums").child( "\(albumContentTag)--\(song.name)--\(song.toneDeafAppId)").child("REQUIRED").child("Other Versions")
                var arrto:[String] = []
                if var allArt = song.otherVersions {
                    if !allArt.contains(strongSelf.currAlbum.toneDeafAppId) {
                        allArt.append(strongSelf.currAlbum.toneDeafAppId)
                        arrto = allArt.sorted()
                    }
                } else {
                    arrto = [strongSelf.currAlbum.toneDeafAppId]
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
    
    //MARK: - Industry Certification
    func processIndustryCertification(initialAlbum: AlbumData, currentAlbum: AlbumData, completion: @escaping ((Error?) -> Void)) {
        initAlbum = initialAlbum
        currAlbum = currentAlbum
        let ref = Database.database().reference().child("Music Content").child("Albums").child("\(albumContentTag)--\(currAlbum.name)--\(currAlbum.toneDeafAppId)").child("REQUIRED").child("Industry Certified")
        ref.setValue(currAlbum.industryCerified!, withCompletionBlock: { error, reference in
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
    func processStatus(initialAlbum: AlbumData, currentAlbum: AlbumData, completion: @escaping ((Error?) -> Void)) {
        initAlbum = initialAlbum
        currAlbum = currentAlbum
        let ref = Database.database().reference().child("Music Content").child("Albums").child("\(albumContentTag)--\(currAlbum.name)--\(currAlbum.toneDeafAppId)").child("REQUIRED").child("Active Status")
        ref.setValue(currAlbum.isActive, withCompletionBlock: { error, reference in
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

enum AlbumEditorError: Error {
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
