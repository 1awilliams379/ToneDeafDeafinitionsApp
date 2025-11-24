//
//  EditVideoHepler.swift
//  ToneDeafDeafinitionsApp
//
//  Created by Tone Deaf on 8/19/22.
//  Copyright © 2022 GITEM Solutions. All rights reserved.
//

import Foundation
import FirebaseDatabase
import FirebaseStorage

class EditVideoHelper {
    static let shared = EditVideoHelper()
    
    var initVideo:VideoData!
    var initStatusDict:NSDictionary!
    var initRef:DatabaseReference!
    var initURLDict:NSDictionary!
    //Initial Images
    var initImage:UIImage!
    var initImageDBURL:String!
    
    var currVideo:VideoData!
    var currStatusDict:NSDictionary!
    var currRef:DatabaseReference!
    var currURLDict:NSDictionary!
    //Current Images
    var currImage:UIImage!
    var currImageDBURL:String!
    
    //MARK: - Image
    func processImage(initialVideo: VideoData, currentVideo: VideoData, image: UIImage?, completion: @escaping ((Error?) -> Void)) {
        initVideo = initialVideo
        currVideo = currentVideo
        currImage = image
        guard currentVideo.manualThumbnailURL != initialVideo.manualThumbnailURL else {
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
                            Database.database().reference().child("Music Content").child("Videos").child("\(videoContentTag)--\(strongSelf.currVideo.title.replacingOccurrences(of: ".", with: " ").replacingOccurrences(of: "#", with: " ").replacingOccurrences(of: "$", with: " ").replacingOccurrences(of: "[", with: " ").replacingOccurrences(of: "]", with: " ").replacingOccurrences(of: ":", with: " "))--\(strongSelf.currVideo.toneDeafAppId)").child("Manual Thumbnail URL").removeValue()
                            completion(nil)
                            return
                        }
                        
                        strongSelf.storeImage(song: strongSelf.currVideo, image: strongSelf.currImage, imageURL: "curr", completion: { err in
                            if let error = err {
                                completion(error)
                                return
                            } else {
                                var array:String!
                                
                                array = strongSelf.currImageDBURL
                                Database.database().reference().child("Music Content").child("Videos").child("\(videoContentTag)--\(strongSelf.currVideo.title.replacingOccurrences(of: ".", with: " ").replacingOccurrences(of: "#", with: " ").replacingOccurrences(of: "$", with: " ").replacingOccurrences(of: "[", with: " ").replacingOccurrences(of: "]", with: " ").replacingOccurrences(of: ":", with: " "))--\(strongSelf.currVideo.toneDeafAppId)").child("Manual Thumbnail URL").setValue(array)
                                completion(nil)
                            }
                        })
                    }
                })
            }
        })
    }
    
    fileprivate func getDBURLs(completion: @escaping ((Error?) -> Void)) {
        Database.database().reference().child("Music Content").child("Videos").child("\(videoContentTag)--\(currVideo.title.replacingOccurrences(of: ".", with: " ").replacingOccurrences(of: "#", with: " ").replacingOccurrences(of: "$", with: " ").replacingOccurrences(of: "[", with: " ").replacingOccurrences(of: "]", with: " ").replacingOccurrences(of: ":", with: " "))--\(currVideo.toneDeafAppId)").child("Manual Thumbnail URL").observeSingleEvent(of: .value, with: {[weak self] snap in
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
        Storage.storage().reference().child("Image Defaults").child("Manual Videos").child("\(currVideo.toneDeafAppId)").child("Images").listAll(completion: {[weak self] listResult, err in
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
        Storage.storage().reference().child("Image Defaults").child("Manual Videos").child("\(currVideo.toneDeafAppId)").child("Images").listAll(completion: {[weak self] listResult, err in
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
                                Database.database().reference().child("Music Content").child("Videos").child("\(videoContentTag)--\(strongSelf.currVideo.title.replacingOccurrences(of: ".", with: " ").replacingOccurrences(of: "#", with: " ").replacingOccurrences(of: "$", with: " ").replacingOccurrences(of: "[", with: " ").replacingOccurrences(of: "]", with: " ").replacingOccurrences(of: ":", with: " "))--\(strongSelf.currVideo.toneDeafAppId)").child("Manual Thumbnail URL").removeValue()
                                completion(nil)
                                return
                            }
                        }
                        
                    })
                }
            }
        })
    }
    
    fileprivate func storeImage(song: VideoData, image:UIImage, imageURL:String, completion: @escaping ((Error?) -> Void)) {
        
        guard let data = image.pngData() else {
            completion(SongEditorError.imageUpdateError("Error converting image to png"))
            return}
        StorageManager.shared.uploadImage(song: data, fileName: "\(currVideo.toneDeafAppId)", completion: {[weak self] result in
            
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
    
    //MARK: - Name
    func processName(initialVideo: VideoData, currentVideo: VideoData, completion: @escaping (([Error]?) -> Void)) {
        initVideo = initialVideo
        currVideo = currentVideo
        
        initRef = Database.database().reference().child("Music Content").child("Videos").child("\(videoContentTag)--\(initVideo.title.replacingOccurrences(of: ".", with: " ").replacingOccurrences(of: "#", with: " ").replacingOccurrences(of: "$", with: " ").replacingOccurrences(of: "[", with: " ").replacingOccurrences(of: "]", with: " ").replacingOccurrences(of: ":", with: " "))--\(initVideo.toneDeafAppId)")
        currRef = Database.database().reference().child("Music Content").child("Videos").child("\(videoContentTag)--\(currVideo.title.replacingOccurrences(of: ".", with: " ").replacingOccurrences(of: "#", with: " ").replacingOccurrences(of: "$", with: " ").replacingOccurrences(of: "[", with: " ").replacingOccurrences(of: "]", with: " ").replacingOccurrences(of: ":", with: " "))--\(currVideo.toneDeafAppId)")
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
        
        let aqueue = DispatchQueue(label: "myhjvkheditingQvideoNamep1Changessseue")
        let agroup = DispatchGroup()
        agroup.enter()
        aqueue.async { [weak self] in
            guard let strongSelf = self else {return}
            strongSelf.setNewKeyForVideoInDB(initref: strongSelf.initRef, newref: strongSelf.currRef, completion: {err in
                if let error = err {
                    dataUploadCompletionStatus1 = false
                    errors.append(error)
                } else {
                    dataUploadCompletionStatus1 = true
                    print("Video name Update done \(1)")
                }
                agroup.leave()
            })
        }
        agroup.notify(queue: DispatchQueue.main) {
            if dataUploadCompletionStatus1 == false {
                completion(errors)
                return
            } else {
                let queue = DispatchQueue(label: "myhjvkheditingQvideonameChangessseue")
                let group = DispatchGroup()
                let array:[Int] = [2,3,4,5,6,7,8,9]
                for i in array {
                    group.enter()
                    queue.async { [weak self] in
                        guard let strongSelf = self else {return}
                        switch i {
                        case 2:
                            strongSelf.setNewKeyForVideoYoutubeInDB(initref: strongSelf.initRef, newref: strongSelf.currRef, completion: {err in
                                if let error = err {
                                    dataUploadCompletionStatus2 = false
                                    errors.append(error)
                                } else {
                                    dataUploadCompletionStatus2 = true
                                    print("Video name Youtube Update done \(i)")
                                }
                                group.leave()
                            })
                        case 3:
                            strongSelf.setNewKeyForVideoIGTVInDB(initref: strongSelf.initRef, newref: strongSelf.currRef, completion: {err in
                                if let error = err {
                                    dataUploadCompletionStatus3 = false
                                    errors.append(error)
                                } else {
                                    dataUploadCompletionStatus3 = true
                                    print("Video name IGTV Update done \(i)")
                                }
                                group.leave()
                            })
                        case 4:
                            strongSelf.setNewKeyForVideoInstagramInDB(initref: strongSelf.initRef, newref: strongSelf.currRef, completion: {err in
                                if let error = err {
                                    dataUploadCompletionStatus4 = false
                                    errors.append(error)
                                } else {
                                    dataUploadCompletionStatus4 = true
                                    print("Video name Instagram Update done \(i)")
                                }
                                group.leave()
                            })
                        case 5:
                            strongSelf.setNewKeyForVideoFacebookInDB(initref: strongSelf.initRef, newref: strongSelf.currRef, completion: {err in
                                if let error = err {
                                    dataUploadCompletionStatus5 = false
                                    errors.append(error)
                                } else {
                                    dataUploadCompletionStatus5 = true
                                    print("Video name Instagram Update done \(i)")
                                }
                                group.leave()
                            })
                        case 6:
                            strongSelf.setNewKeyForVideoWorldstarInDB(initref: strongSelf.initRef, newref: strongSelf.currRef, completion: {err in
                                if let error = err {
                                    dataUploadCompletionStatus6 = false
                                    errors.append(error)
                                } else {
                                    dataUploadCompletionStatus6 = true
                                    print("Video name Worldstar Update done \(i)")
                                }
                                group.leave()
                            })
                        case 7:
                            strongSelf.setNewKeyForVideoTwitterInDB(initref: strongSelf.initRef, newref: strongSelf.currRef, completion: {err in
                                if let error = err {
                                    dataUploadCompletionStatus7 = false
                                    errors.append(error)
                                } else {
                                    dataUploadCompletionStatus7 = true
                                    print("Video name Twitter Update done \(i)")
                                }
                                group.leave()
                            })
                        case 8:
                            strongSelf.setNewKeyForVideoAppleMusicInDB(initref: strongSelf.initRef, newref: strongSelf.currRef, completion: {err in
                                if let error = err {
                                    dataUploadCompletionStatus8 = false
                                    errors.append(error)
                                } else {
                                    dataUploadCompletionStatus8 = true
                                    print("Video name Apple Music Update done \(i)")
                                }
                                group.leave()
                            })
                        case 9:
                            strongSelf.setNewKeyForVideoTikTokInDB(initref: strongSelf.initRef, newref: strongSelf.currRef, completion: {err in
                                if let error = err {
                                    dataUploadCompletionStatus8 = false
                                    errors.append(error)
                                } else {
                                    dataUploadCompletionStatus8 = true
                                    print("Video name Tik Tok Update done \(i)")
                                }
                                group.leave()
                            })
                        default:
                            print("Edit Video error")
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
    
    func setNewKeyForVideoInDB(initref: DatabaseReference, newref: DatabaseReference, completion: @escaping ((Error?) -> Void)) {
        
        initref.observeSingleEvent(of: .value, with: {[weak self] result in
            guard let strongSelf = self else {return}
            newref.setValue(result.value, withCompletionBlock: { error, reference in
                if let error = error {
                    completion(error)
                    return
                }
                else {
                    initref.removeValue()
                    strongSelf.updateVideoName(newref: newref, completion: { error in
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
    
    func updateVideoName(newref: DatabaseReference, completion: @escaping ((Error?) -> Void)) {
        newref.child("Title").setValue(currVideo.title.replacingOccurrences(of: ".", with: " ").replacingOccurrences(of: "#", with: " ").replacingOccurrences(of: "$", with: " ").replacingOccurrences(of: "[", with: " ").replacingOccurrences(of: "]", with: " ").replacingOccurrences(of: ":", with: " "), withCompletionBlock: { error, reference in
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
    
    func setNewKeyForVideoYoutubeInDB(initref: DatabaseReference, newref: DatabaseReference, completion: @escaping ((Error?) -> Void)) {
        var initiref = initref
        var initkey:String!
        var currenref = newref
        var currkey:String!
        var count = 0
        
        if currVideo.youtube != nil {
            for vid in currVideo.youtube! {
                if initVideo.youtube != nil {
                    initkey = "\(vid.type)--\(initVideo.title.replacingOccurrences(of: ".", with: " ").replacingOccurrences(of: "#", with: " ").replacingOccurrences(of: "$", with: " ").replacingOccurrences(of: "[", with: " ").replacingOccurrences(of: "]", with: " ").replacingOccurrences(of: ":", with: " "))--\(vid.url.replacingOccurrences(of: "/", with: "").replacingOccurrences(of: ".", with: "").replacingOccurrences(of: "#", with: "").replacingOccurrences(of: "$", with: "").suffix(10))--\(initVideo.toneDeafAppId)"
                    currkey = "\(vid.type)--\(currVideo.title.replacingOccurrences(of: ".", with: " ").replacingOccurrences(of: "#", with: " ").replacingOccurrences(of: "$", with: " ").replacingOccurrences(of: "[", with: " ").replacingOccurrences(of: "]", with: " ").replacingOccurrences(of: ":", with: " "))--\(vid.url.replacingOccurrences(of: "/", with: "").replacingOccurrences(of: ".", with: "").replacingOccurrences(of: "#", with: "").replacingOccurrences(of: "$", with: "").suffix(10))--\(currVideo.toneDeafAppId)"
                    initiref = currenref.child("Youtube").child(initkey)
                    currenref = currenref.child("Youtube").child(currkey)
                } else {
                    completion(nil)
                    return
                }
                initiref.observeSingleEvent(of: .value, with: { result in
                    currenref.setValue(result.value, withCompletionBlock: {[weak self] error, reference in
                        guard let strongSelf = self else {return}
                        count+=1
                        if let error = error {
                            completion(error)
                            return
                        }
                        else {
                            initiref.removeValue()
                            if count == strongSelf.currVideo.youtube!.count {
                                completion(nil)
                                return
                            }
                        }
                    })
                }, withCancel: { error in
                    completion(error)
                })
            }
        }
    }
    
    func setNewKeyForVideoIGTVInDB(initref: DatabaseReference, newref: DatabaseReference, completion: @escaping ((Error?) -> Void)) {
        var initiref = initref
        var initkey:String!
        var currenref = newref
        var currkey:String!
        var count = 0
        
        if currVideo.igtv != nil {
            for vid in currVideo.igtv! {
                if initVideo.igtv != nil {
                    initkey = "\(iGTVVideoContentTag)--\(initVideo.title.replacingOccurrences(of: ".", with: " ").replacingOccurrences(of: "#", with: " ").replacingOccurrences(of: "$", with: " ").replacingOccurrences(of: "[", with: " ").replacingOccurrences(of: "]", with: " ").replacingOccurrences(of: ":", with: " "))--\(vid.url.replacingOccurrences(of: "/", with: "").replacingOccurrences(of: ".", with: "").replacingOccurrences(of: "#", with: "").replacingOccurrences(of: "$", with: "").suffix(10))--\(initVideo.toneDeafAppId)"
                    currkey = "\(iGTVVideoContentTag)--\(currVideo.title.replacingOccurrences(of: ".", with: " ").replacingOccurrences(of: "#", with: " ").replacingOccurrences(of: "$", with: " ").replacingOccurrences(of: "[", with: " ").replacingOccurrences(of: "]", with: " ").replacingOccurrences(of: ":", with: " "))--\(vid.url.replacingOccurrences(of: "/", with: "").replacingOccurrences(of: ".", with: "").replacingOccurrences(of: "#", with: "").replacingOccurrences(of: "$", with: "").suffix(10))--\(currVideo.toneDeafAppId)"
                    initiref = currenref.child("IGTV").child(initkey)
                    currenref = currenref.child("IGTV").child(currkey)
                } else {
                    completion(nil)
                    return
                }
                initiref.observeSingleEvent(of: .value, with: { result in
                    currenref.setValue(result.value, withCompletionBlock: {[weak self] error, reference in
                        guard let strongSelf = self else {return}
                        count+=1
                        if let error = error {
                            completion(error)
                            return
                        }
                        else {
                            initiref.removeValue()
                            if count == strongSelf.currVideo.igtv!.count {
                                completion(nil)
                                return
                            }
                        }
                    })
                }, withCancel: { error in
                    completion(error)
                })
            }
        }
    }
    
    func setNewKeyForVideoInstagramInDB(initref: DatabaseReference, newref: DatabaseReference, completion: @escaping ((Error?) -> Void)) {
        var initiref = initref
        var initkey:String!
        var currenref = newref
        var currkey:String!
        var count = 0
        
        if currVideo.instagramPost != nil {
            for vid in currVideo.instagramPost! {
                if initVideo.instagramPost != nil {
                    initkey = "\(instagramPostVideoContentTag)--\(initVideo.title.replacingOccurrences(of: ".", with: " ").replacingOccurrences(of: "#", with: " ").replacingOccurrences(of: "$", with: " ").replacingOccurrences(of: "[", with: " ").replacingOccurrences(of: "]", with: " ").replacingOccurrences(of: ":", with: " "))--\(vid.url.replacingOccurrences(of: "/", with: "").replacingOccurrences(of: ".", with: "").replacingOccurrences(of: "#", with: "").replacingOccurrences(of: "$", with: "").suffix(10))--\(initVideo.toneDeafAppId)"
                    currkey = "\(instagramPostVideoContentTag)--\(currVideo.title.replacingOccurrences(of: ".", with: " ").replacingOccurrences(of: "#", with: " ").replacingOccurrences(of: "$", with: " ").replacingOccurrences(of: "[", with: " ").replacingOccurrences(of: "]", with: " ").replacingOccurrences(of: ":", with: " "))--\(vid.url.replacingOccurrences(of: "/", with: "").replacingOccurrences(of: ".", with: "").replacingOccurrences(of: "#", with: "").replacingOccurrences(of: "$", with: "").suffix(10))--\(currVideo.toneDeafAppId)"
                    initiref = currenref.child("Instagram").child(initkey)
                    currenref = currenref.child("Instagram").child(currkey)
                } else {
                    completion(nil)
                    return
                }
                initiref.observeSingleEvent(of: .value, with: { result in
                    currenref.setValue(result.value, withCompletionBlock: {[weak self] error, reference in
                        guard let strongSelf = self else {return}
                        count+=1
                        if let error = error {
                            completion(error)
                            return
                        }
                        else {
                            initiref.removeValue()
                            if count == strongSelf.currVideo.instagramPost!.count {
                                completion(nil)
                                return
                            }
                        }
                    })
                }, withCancel: { error in
                    completion(error)
                })
            }
        }
    }
    
    func setNewKeyForVideoFacebookInDB(initref: DatabaseReference, newref: DatabaseReference, completion: @escaping ((Error?) -> Void)) {
        var initiref = initref
        var initkey:String!
        var currenref = newref
        var currkey:String!
        var count = 0
        
        if currVideo.facebookPost != nil {
            for vid in currVideo.facebookPost! {
                if initVideo.facebookPost != nil {
                    initkey = "\(facebookPostVideoContentTag)--\(initVideo.title.replacingOccurrences(of: ".", with: " ").replacingOccurrences(of: "#", with: " ").replacingOccurrences(of: "$", with: " ").replacingOccurrences(of: "[", with: " ").replacingOccurrences(of: "]", with: " ").replacingOccurrences(of: ":", with: " "))--\(vid.url.replacingOccurrences(of: "/", with: "").replacingOccurrences(of: ".", with: "").replacingOccurrences(of: "#", with: "").replacingOccurrences(of: "$", with: "").suffix(10))--\(initVideo.toneDeafAppId)"
                    currkey = "\(facebookPostVideoContentTag)--\(currVideo.title.replacingOccurrences(of: ".", with: " ").replacingOccurrences(of: "#", with: " ").replacingOccurrences(of: "$", with: " ").replacingOccurrences(of: "[", with: " ").replacingOccurrences(of: "]", with: " ").replacingOccurrences(of: ":", with: " "))--\(vid.url.replacingOccurrences(of: "/", with: "").replacingOccurrences(of: ".", with: "").replacingOccurrences(of: "#", with: "").replacingOccurrences(of: "$", with: "").suffix(10))--\(currVideo.toneDeafAppId)"
                    initiref = currenref.child("Facebook").child(initkey)
                    currenref = currenref.child("Facebook").child(currkey)
                } else {
                    completion(nil)
                    return
                }
                initiref.observeSingleEvent(of: .value, with: { result in
                    currenref.setValue(result.value, withCompletionBlock: {[weak self] error, reference in
                        guard let strongSelf = self else {return}
                        count+=1
                        if let error = error {
                            completion(error)
                            return
                        }
                        else {
                            initiref.removeValue()
                            if count == strongSelf.currVideo.facebookPost!.count {
                                completion(nil)
                                return
                            }
                        }
                    })
                }, withCancel: { error in
                    completion(error)
                })
            }
        }
    }
    
    func setNewKeyForVideoWorldstarInDB(initref: DatabaseReference, newref: DatabaseReference, completion: @escaping ((Error?) -> Void)) {
        var initiref = initref
        var initkey:String!
        var currenref = newref
        var currkey:String!
        var count = 0
        
        if currVideo.worldstar != nil {
            for vid in currVideo.worldstar! {
                if initVideo.worldstar != nil {
                    initkey = "\(worldstarVideoContentTag)--\(initVideo.title.replacingOccurrences(of: ".", with: " ").replacingOccurrences(of: "#", with: " ").replacingOccurrences(of: "$", with: " ").replacingOccurrences(of: "[", with: " ").replacingOccurrences(of: "]", with: " ").replacingOccurrences(of: ":", with: " "))--\(vid.url.replacingOccurrences(of: "/", with: "").replacingOccurrences(of: ".", with: "").replacingOccurrences(of: "#", with: "").replacingOccurrences(of: "$", with: "").suffix(10))--\(initVideo.toneDeafAppId)"
                    currkey = "\(worldstarVideoContentTag)--\(currVideo.title.replacingOccurrences(of: ".", with: " ").replacingOccurrences(of: "#", with: " ").replacingOccurrences(of: "$", with: " ").replacingOccurrences(of: "[", with: " ").replacingOccurrences(of: "]", with: " ").replacingOccurrences(of: ":", with: " "))--\(vid.url.replacingOccurrences(of: "/", with: "").replacingOccurrences(of: ".", with: "").replacingOccurrences(of: "#", with: "").replacingOccurrences(of: "$", with: "").suffix(10))--\(currVideo.toneDeafAppId)"
                    initiref = currenref.child("Worldstar").child(initkey)
                    currenref = currenref.child("Worldstar").child(currkey)
                } else {
                    completion(nil)
                    return
                }
                initiref.observeSingleEvent(of: .value, with: { result in
                    currenref.setValue(result.value, withCompletionBlock: {[weak self] error, reference in
                        guard let strongSelf = self else {return}
                        count+=1
                        if let error = error {
                            completion(error)
                            return
                        }
                        else {
                            initiref.removeValue()
                            if count == strongSelf.currVideo.worldstar!.count {
                                completion(nil)
                                return
                            }
                        }
                    })
                }, withCancel: { error in
                    completion(error)
                })
            }
        }
    }
    
    func setNewKeyForVideoTwitterInDB(initref: DatabaseReference, newref: DatabaseReference, completion: @escaping ((Error?) -> Void)) {
        var initiref = initref
        var initkey:String!
        var currenref = newref
        var currkey:String!
        var count = 0
        
        if currVideo.twitter != nil {
            for vid in currVideo.twitter! {
                if initVideo.twitter != nil {
                    initkey = "\(twitterVideoContentTag)--\(initVideo.title.replacingOccurrences(of: ".", with: " ").replacingOccurrences(of: "#", with: " ").replacingOccurrences(of: "$", with: " ").replacingOccurrences(of: "[", with: " ").replacingOccurrences(of: "]", with: " ").replacingOccurrences(of: ":", with: " "))--\(vid.url.replacingOccurrences(of: "/", with: "").replacingOccurrences(of: ".", with: "").replacingOccurrences(of: "#", with: "").replacingOccurrences(of: "$", with: "").suffix(10))--\(initVideo.toneDeafAppId)"
                    currkey = "\(twitterVideoContentTag)--\(currVideo.title.replacingOccurrences(of: ".", with: " ").replacingOccurrences(of: "#", with: " ").replacingOccurrences(of: "$", with: " ").replacingOccurrences(of: "[", with: " ").replacingOccurrences(of: "]", with: " ").replacingOccurrences(of: ":", with: " "))--\(vid.url.replacingOccurrences(of: "/", with: "").replacingOccurrences(of: ".", with: "").replacingOccurrences(of: "#", with: "").replacingOccurrences(of: "$", with: "").suffix(10))--\(currVideo.toneDeafAppId)"
                    initiref = currenref.child("Twitter").child(initkey)
                    currenref = currenref.child("Twitter").child(currkey)
                } else {
                    completion(nil)
                    return
                }
                initiref.observeSingleEvent(of: .value, with: { result in
                    currenref.setValue(result.value, withCompletionBlock: {[weak self] error, reference in
                        guard let strongSelf = self else {return}
                        count+=1
                        if let error = error {
                            completion(error)
                            return
                        }
                        else {
                            initiref.removeValue()
                            if count == strongSelf.currVideo.twitter!.count {
                                completion(nil)
                                return
                            }
                        }
                    })
                }, withCancel: { error in
                    completion(error)
                })
            }
        }
    }
    
    func setNewKeyForVideoAppleMusicInDB(initref: DatabaseReference, newref: DatabaseReference, completion: @escaping ((Error?) -> Void)) {
        var initiref = initref
        var initkey:String!
        var currenref = newref
        var currkey:String!
        var count = 0
        
        if currVideo.appleMusic != nil {
            for vid in currVideo.appleMusic! {
                if initVideo.appleMusic != nil {
                    initkey = "\(appleMusicContentType)--\(initVideo.title.replacingOccurrences(of: ".", with: " ").replacingOccurrences(of: "#", with: " ").replacingOccurrences(of: "$", with: " ").replacingOccurrences(of: "[", with: " ").replacingOccurrences(of: "]", with: " ").replacingOccurrences(of: ":", with: " "))--\(vid.url.replacingOccurrences(of: "/", with: "").replacingOccurrences(of: ".", with: "").replacingOccurrences(of: "#", with: "").replacingOccurrences(of: "$", with: "").suffix(10))--\(initVideo.toneDeafAppId)"
                    currkey = "\(appleMusicContentType)--\(currVideo.title.replacingOccurrences(of: ".", with: " ").replacingOccurrences(of: "#", with: " ").replacingOccurrences(of: "$", with: " ").replacingOccurrences(of: "[", with: " ").replacingOccurrences(of: "]", with: " ").replacingOccurrences(of: ":", with: " "))--\(vid.url.replacingOccurrences(of: "/", with: "").replacingOccurrences(of: ".", with: "").replacingOccurrences(of: "#", with: "").replacingOccurrences(of: "$", with: "").suffix(10))--\(currVideo.toneDeafAppId)"
                    initiref = currenref.child("Apple Music").child(initkey)
                    currenref = currenref.child("Apple Music").child(currkey)
                } else {
                    completion(nil)
                    return
                }
                initiref.observeSingleEvent(of: .value, with: { result in
                    currenref.setValue(result.value, withCompletionBlock: {[weak self] error, reference in
                        guard let strongSelf = self else {return}
                        count+=1
                        if let error = error {
                            completion(error)
                            return
                        }
                        else {
                            initiref.removeValue()
                            if count == strongSelf.currVideo.appleMusic!.count {
                                completion(nil)
                                return
                            }
                        }
                    })
                }, withCancel: { error in
                    completion(error)
                })
            }
        }
    }
    
    func setNewKeyForVideoTikTokInDB(initref: DatabaseReference, newref: DatabaseReference, completion: @escaping ((Error?) -> Void)) {
        var initiref = initref
        var initkey:String!
        var currenref = newref
        var currkey:String!
        var count = 0
        
        if currVideo.tikTok != nil {
            for vid in currVideo.tikTok! {
                if initVideo.tikTok != nil {
                    initkey = "\(tikTokVideoContentTag)--\(initVideo.title.replacingOccurrences(of: ".", with: " ").replacingOccurrences(of: "#", with: " ").replacingOccurrences(of: "$", with: " ").replacingOccurrences(of: "[", with: " ").replacingOccurrences(of: "]", with: " ").replacingOccurrences(of: ":", with: " "))--\(vid.url.replacingOccurrences(of: "/", with: "").replacingOccurrences(of: ".", with: "").replacingOccurrences(of: "#", with: "").replacingOccurrences(of: "$", with: "").suffix(10))--\(initVideo.toneDeafAppId)"
                    currkey = "\(tikTokVideoContentTag)--\(currVideo.title.replacingOccurrences(of: ".", with: " ").replacingOccurrences(of: "#", with: " ").replacingOccurrences(of: "$", with: " ").replacingOccurrences(of: "[", with: " ").replacingOccurrences(of: "]", with: " ").replacingOccurrences(of: ":", with: " "))--\(vid.url.replacingOccurrences(of: "/", with: "").replacingOccurrences(of: ".", with: "").replacingOccurrences(of: "#", with: "").replacingOccurrences(of: "$", with: "").suffix(10))--\(currVideo.toneDeafAppId)"
                    initiref = currenref.child("Tik Tok").child(initkey)
                    currenref = currenref.child("Tik Tok").child(currkey)
                } else {
                    completion(nil)
                    return
                }
                initiref.observeSingleEvent(of: .value, with: { result in
                    currenref.setValue(result.value, withCompletionBlock: {[weak self] error, reference in
                        guard let strongSelf = self else {return}
                        count+=1
                        if let error = error {
                            completion(error)
                            return
                        }
                        else {
                            initiref.removeValue()
                            if count == strongSelf.currVideo.tikTok!.count {
                                completion(nil)
                                return
                            }
                        }
                    })
                }, withCancel: { error in
                    completion(error)
                })
            }
        }
    }
    
    //MARK: - Type
    func processType(initialVideo: VideoData, currentVideo: VideoData, completion: @escaping ((Error?) -> Void)) {
        initVideo = initialVideo
        currVideo = currentVideo
        let ref = Database.database().reference().child("Music Content").child("Videos").child("\(videoContentTag)--\(currVideo.title.replacingOccurrences(of: ".", with: " ").replacingOccurrences(of: "#", with: " ").replacingOccurrences(of: "$", with: " ").replacingOccurrences(of: "[", with: " ").replacingOccurrences(of: "]", with: " ").replacingOccurrences(of: ":", with: " "))--\(currVideo.toneDeafAppId)").child("Type")
        ref.setValue(String(currVideo.type), withCompletionBlock: { error, reference in
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
    
    //MARK: - Persons
    func processPersons(initialVideo: VideoData, currentVideo: VideoData, completion: @escaping (([Error]?) -> Void)) {
        initVideo = initialVideo
        currVideo = currentVideo
        
        initRef = Database.database().reference().child("Music Content").child("Videos").child("\(videoContentTag)--\(initVideo.title.replacingOccurrences(of: ".", with: " ").replacingOccurrences(of: "#", with: " ").replacingOccurrences(of: "$", with: " ").replacingOccurrences(of: "[", with: " ").replacingOccurrences(of: "]", with: " ").replacingOccurrences(of: ":", with: " "))--\(initVideo.toneDeafAppId)")
        currRef = Database.database().reference().child("Music Content").child("Videos").child("\(videoContentTag)--\(currVideo.title.replacingOccurrences(of: ".", with: " ").replacingOccurrences(of: "#", with: " ").replacingOccurrences(of: "$", with: " ").replacingOccurrences(of: "[", with: " ").replacingOccurrences(of: "]", with: " ").replacingOccurrences(of: ":", with: " "))--\(currVideo.toneDeafAppId)")
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
        
        let aqueue = DispatchQueue(label: "myhjvkheditingQvideoPersonshfdChangessseue")
        let agroup = DispatchGroup()
        let array:[Int] = [1,2]
        for i in array {
            agroup.enter()
            aqueue.async { [weak self] in
                guard let strongSelf = self else {return}
                switch i {
                case 1:
                    strongSelf.updateVideoPersons(ref: strongSelf.currRef, completion: {err in
                        if let error = err {
                            dataUploadCompletionStatus1 = false
                            errors.append(error)
                        } else {
                            dataUploadCompletionStatus1 = true
                            print("Video person Update done \(1)")
                        }
                        agroup.leave()
                    })
                case 2:
                    strongSelf.updatePersonVideos(ref: strongSelf.currRef, completion: {err in
                        if let error = err {
                            dataUploadCompletionStatus2 = false
                            errors.append(error)
                        } else {
                            dataUploadCompletionStatus2 = true
                            print("Person Videos Update done \(1)")
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
    
    func updateVideoPersons(ref: DatabaseReference, completion: @escaping ((Error?) -> Void)) {
        var initialArtistsArrFromDB:[String]!
        if currVideo.persons!.sorted() == initVideo.persons?.sorted() {
            completion(nil)
            return
        }
        getVideoPersonsInDB(ref: ref, completion: {[weak self] persons in
            guard let strongSelf = self else {return}
            initialArtistsArrFromDB = persons.sorted()
            
            if !initialArtistsArrFromDB.isEmpty {
                var removalCounter = 0
                for i in 0 ... initialArtistsArrFromDB.count-1 {
                    if strongSelf.currVideo.persons != nil {
                        if i < strongSelf.currVideo.persons!.count {
                            if !strongSelf.currVideo.persons!.contains(initialArtistsArrFromDB[i]) {
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
            
            if strongSelf.currVideo.persons != nil {
                if !strongSelf.currVideo.persons!.isEmpty {
                    for i in 0 ... strongSelf.currVideo.persons!.count-1 {
                        if i < initialArtistsArrFromDB.count {
                            if !initialArtistsArrFromDB.contains(strongSelf.currVideo.persons![i]) {
                                initialArtistsArrFromDB.append(strongSelf.currVideo.persons![i])
                            }
                        } else {
                            initialArtistsArrFromDB.append(strongSelf.currVideo.persons![i])
                        }
                    }
                }
            }
            ref.child("Persons").setValue(initialArtistsArrFromDB.sorted(), withCompletionBlock: { error, reference in
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
    
    func getVideoPersonsInDB(ref: DatabaseReference, completion: @escaping (([String]) -> Void)) {
        ref.child("Persons").observeSingleEvent(of: .value, with: { snapshot in
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
    
    func updatePersonVideos(ref: DatabaseReference, completion: @escaping ((Error?) -> Void)) {
        var initialArtistsArrFromDB:[String]!
        var totalProgress:Int = 0
        var completedProgress:Int = 0
        if currVideo.persons!.sorted() == initVideo.persons?.sorted() {
            completion(nil)
            return
        }
        
        getVideoPersonsInDB(ref: ref, completion: {[weak self] persons in
            guard let strongSelf = self else {return}
            initialArtistsArrFromDB = persons.sorted()
            
            if !initialArtistsArrFromDB.isEmpty {
                var removalCounter = 0
                for i in 0 ... initialArtistsArrFromDB.count-1 {
                    if strongSelf.currVideo.persons != nil {
                        if i < strongSelf.currVideo.persons!.count {
                            if !strongSelf.currVideo.persons!.contains(initialArtistsArrFromDB[i]) {
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
            
            if strongSelf.currVideo.persons != nil {
                if !strongSelf.currVideo.persons!.isEmpty {
                    for i in 0 ... strongSelf.currVideo.persons!.count-1 {
                        if i < initialArtistsArrFromDB.count {
                            if !initialArtistsArrFromDB.contains(strongSelf.currVideo.persons![i]) {
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
                    if strongSelf.currVideo.persons != nil {
                        if i < strongSelf.currVideo.persons!.count {
                            if !strongSelf.currVideo.persons!.contains(initialArtistsArrFromDB[i]) {
                                strongSelf.removeVideoFromPerson(per: initialArtistsArrFromDB[i], completion: { error in
                                    completedProgress+=1
                                    if let error = error {
                                        completion(error)
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
                            strongSelf.removeVideoFromPerson(per: initialArtistsArrFromDB[i], completion: { error in
                                completedProgress+=1
                                if let error = error {
                                    completion(error)
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
                        strongSelf.removeVideoFromPerson(per: initialArtistsArrFromDB[i], completion: { error in
                            completedProgress+=1
                            if let error = error {
                                completion(error)
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
            
            if strongSelf.currVideo.persons != nil {
                if !strongSelf.currVideo.persons!.isEmpty {
                    for i in 0 ... strongSelf.currVideo.persons!.count-1 {
                        
                        if i < initialArtistsArrFromDB.count {
                            if !initialArtistsArrFromDB.contains(strongSelf.currVideo.persons![i]) {
                                strongSelf.addVideoToPerson(per: strongSelf.currVideo.persons![i], completion: { error in
                                    completedProgress+=1
                                    if let error = error {
                                        completion(error)
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
                            strongSelf.addVideoToPerson(per: strongSelf.currVideo.persons![i], completion: { error in
                                completedProgress+=1
                                if let error = error {
                                    completion(error)
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
    
    func removeVideoFromPerson(per: String, completion: @escaping ((Error?) -> Void)) {
        
        guard per.count == 6 else {
            completion(nil)
            return
        }
        DatabaseManager.shared.fetchPersonData(person: per, completion: {[weak self] result in
            guard let strongSelf = self else {return}
            switch result {
            case .success(let person):
                let ref = Database.database().reference().child("Registered Persons").child("\(person.name!)--\(person.dateRegisteredToApp!)--\(person.timeRegisteredToApp!)--\(person.toneDeafAppId)").child("Videos")
                let song = "\(strongSelf.currVideo.toneDeafAppId)"
                var arrTo:[String] = []
                if var arrrr = person.videos {
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
    
    func addVideoToPerson(per: String, completion: @escaping ((Error?) -> Void)) {
        
        guard per.count == 6 else {
            completion(nil)
            return
        }
        
        DatabaseManager.shared.fetchPersonData(person: per, completion: {[weak self] result in
            guard let strongSelf = self else {return}
            switch result {
            case .success(let person):
                let ref = Database.database().reference().child("Registered Persons").child("\(person.name!)--\(person.dateRegisteredToApp!)--\(person.timeRegisteredToApp!)--\(person.toneDeafAppId)").child("Videos")
                let song = "\(strongSelf.currVideo.toneDeafAppId)"
                var arrTo:[String] = []
                if let psong = person.videos {
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
    
    //MARK: - Videographers
    func processVideographers(initialVideo: VideoData, currentVideo: VideoData, completion: @escaping (([Error]?) -> Void)) {
        initVideo = initialVideo
        currVideo = currentVideo
        
        initRef = Database.database().reference().child("Music Content").child("Videos").child("\(videoContentTag)--\(initVideo.title.replacingOccurrences(of: ".", with: " ").replacingOccurrences(of: "#", with: " ").replacingOccurrences(of: "$", with: " ").replacingOccurrences(of: "[", with: " ").replacingOccurrences(of: "]", with: " ").replacingOccurrences(of: ":", with: " "))--\(initVideo.toneDeafAppId)")
        currRef = Database.database().reference().child("Music Content").child("Videos").child("\(videoContentTag)--\(currVideo.title.replacingOccurrences(of: ".", with: " ").replacingOccurrences(of: "#", with: " ").replacingOccurrences(of: "$", with: " ").replacingOccurrences(of: "[", with: " ").replacingOccurrences(of: "]", with: " ").replacingOccurrences(of: ":", with: " "))--\(currVideo.toneDeafAppId)")
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
        
        let aqueue = DispatchQueue(label: "myhjvkheditingQvideoVideographershfdChangessseue")
        let agroup = DispatchGroup()
        let array:[Int] = [1,2]
        for i in array {
            agroup.enter()
            aqueue.async { [weak self] in
                guard let strongSelf = self else {return}
                switch i {
                case 1:
                    strongSelf.updateVideoVideographers(ref: strongSelf.currRef, completion: {err in
                        if let error = err {
                            dataUploadCompletionStatus1 = false
                            errors.append(error)
                        } else {
                            dataUploadCompletionStatus1 = true
                            print("Video Videographer Update done \(1)")
                        }
                        agroup.leave()
                    })
                case 2:
                    strongSelf.updateVideographerVideos(ref: strongSelf.currRef, completion: {err in
                        if let error = err {
                            dataUploadCompletionStatus2 = false
                            errors.append(error)
                        } else {
                            dataUploadCompletionStatus2 = true
                            print("Videographer Videos Update done \(1)")
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
    
    func updateVideoVideographers(ref: DatabaseReference, completion: @escaping ((Error?) -> Void)) {
        var initialArtistsArrFromDB:[String]!
        if currVideo.videographers!.sorted() == initVideo.videographers?.sorted() {
            completion(nil)
            return
        }
        getVideoVideographersInDB(ref: ref, completion: {[weak self] videographers in
            guard let strongSelf = self else {return}
            initialArtistsArrFromDB = videographers.sorted()
            
            if !initialArtistsArrFromDB.isEmpty {
                var removalCounter = 0
                for i in 0 ... initialArtistsArrFromDB.count-1 {
                    if strongSelf.currVideo.videographers != nil {
                        if i < strongSelf.currVideo.videographers!.count {
                            if !strongSelf.currVideo.videographers!.contains(initialArtistsArrFromDB[i]) {
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
            
            if strongSelf.currVideo.videographers != nil {
                if !strongSelf.currVideo.videographers!.isEmpty {
                    for i in 0 ... strongSelf.currVideo.videographers!.count-1 {
                        if i < initialArtistsArrFromDB.count {
                            if !initialArtistsArrFromDB.contains(strongSelf.currVideo.videographers![i]) {
                                initialArtistsArrFromDB.append(strongSelf.currVideo.videographers![i])
                            }
                        } else {
                            initialArtistsArrFromDB.append(strongSelf.currVideo.videographers![i])
                        }
                    }
                }
            }
            ref.child("Videographers").setValue(initialArtistsArrFromDB.sorted(), withCompletionBlock: { error, reference in
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
    
    func getVideoVideographersInDB(ref: DatabaseReference, completion: @escaping (([String]) -> Void)) {
        ref.child("Videographers").observeSingleEvent(of: .value, with: { snapshot in
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
    
    func updateVideographerVideos(ref: DatabaseReference, completion: @escaping ((Error?) -> Void)) {
        var initialArtistsArrFromDB:[String]!
        var totalProgress:Int = 0
        var completedProgress:Int = 0
        if currVideo.videographers!.sorted() == initVideo.videographers?.sorted() {
            completion(nil)
            return
        }
        
        getVideoVideographersInDB(ref: ref, completion: {[weak self] videographers in
            guard let strongSelf = self else {return}
            initialArtistsArrFromDB = videographers.sorted()
            
            if !initialArtistsArrFromDB.isEmpty {
                var removalCounter = 0
                for i in 0 ... initialArtistsArrFromDB.count-1 {
                    if strongSelf.currVideo.videographers != nil {
                        if i < strongSelf.currVideo.videographers!.count {
                            if !strongSelf.currVideo.videographers!.contains(initialArtistsArrFromDB[i]) {
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
            
            if strongSelf.currVideo.videographers != nil {
                if !strongSelf.currVideo.videographers!.isEmpty {
                    for i in 0 ... strongSelf.currVideo.videographers!.count-1 {
                        if i < initialArtistsArrFromDB.count {
                            if !initialArtistsArrFromDB.contains(strongSelf.currVideo.videographers![i]) {
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
                    if strongSelf.currVideo.videographers != nil {
                        if i < strongSelf.currVideo.videographers!.count {
                            if !strongSelf.currVideo.videographers!.contains(initialArtistsArrFromDB[i]) {
                                strongSelf.removeVideoFromPerson(per: initialArtistsArrFromDB[i], completion: { error in
                                    completedProgress+=1
                                    if let error = error {
                                        completion(error)
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
                            strongSelf.removeVideoFromPerson(per: initialArtistsArrFromDB[i], completion: { error in
                                completedProgress+=1
                                if let error = error {
                                    completion(error)
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
                        strongSelf.removeVideoFromPerson(per: initialArtistsArrFromDB[i], completion: { error in
                            completedProgress+=1
                            if let error = error {
                                completion(error)
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
            
            if strongSelf.currVideo.videographers != nil {
                if !strongSelf.currVideo.videographers!.isEmpty {
                    for i in 0 ... strongSelf.currVideo.videographers!.count-1 {
                        
                        if i < initialArtistsArrFromDB.count {
                            if !initialArtistsArrFromDB.contains(strongSelf.currVideo.videographers![i]) {
                                strongSelf.addVideoToPerson(per: strongSelf.currVideo.videographers![i], completion: { error in
                                    completedProgress+=1
                                    if let error = error {
                                        completion(error)
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
                            strongSelf.addVideoToPerson(per: strongSelf.currVideo.videographers![i], completion: { error in
                                completedProgress+=1
                                if let error = error {
                                    completion(error)
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
    
    //MARK: - Youtube
    func processYoutube(initialArr: [YouTubeData]?,newArr: [YouTubeData]?, currentVideo: VideoData, completion: @escaping (([Error]?) -> Void)) {
        currVideo = currentVideo
        
        currRef = Database.database().reference().child("Music Content").child("Videos").child("\(videoContentTag)--\(currVideo.title.replacingOccurrences(of: ".", with: " ").replacingOccurrences(of: "#", with: " ").replacingOccurrences(of: "$", with: " ").replacingOccurrences(of: "[", with: " ").replacingOccurrences(of: "]", with: " ").replacingOccurrences(of: ":", with: " "))--\(currVideo.toneDeafAppId)")
        if newArr == nil && initialArr == nil {
            completion(nil)
            return
        }
        
        let semaphore = DispatchSemaphore(value: 0)
        let group = DispatchGroup()
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let strongSelf = self else {return}
            var count = 0
            if initialArr != nil {
                if newArr != nil {
                    for vid in initialArr! {
                        var present = false
                        for one in newArr! {
                            if one.url ==  vid.url {
                                present = true
                            }
                        }
                        if present == false {
                            //remove vid from initial arr
                            strongSelf.removeYoutube(itemToGo: vid, completion: { err in
                                if let err = err {
                                    
                                }
                            })
                        }
                    }
                } else {
                    //remove all initial arr items and break
                    for item in initialArr! {
                        strongSelf.removeYoutube(itemToGo: item, completion: { err in
                            if let err = err {
                                
                            }
                        })
                    }
                }
            }
            
            if newArr == nil {
                completion(nil)
                return
            }
            
            if newArr!.isEmpty {
                completion(nil)
                return
            }
            
            for item in newArr! {
                if count != 0 {
                    usleep(1000)
                }
                strongSelf.startYoutube(initialArr: initialArr, currentItem: item, index: count, completion: { err in
                    count+=1
                    if let err = err {
                        completion(err)
                        return
                    } else {
                        if count == newArr!.count {
                            completion(nil)
                            return
                        } else {
                            semaphore.signal()
                        }
                    }
                })
                semaphore.wait()
            }
        }
    }
    
    func startYoutube(initialArr: [YouTubeData]?,currentItem: YouTubeData, index:Int, completion: @escaping (([Error]?) -> Void)) {
        var errors:[Error] = []
        
        var dataUploadCompletionStatus1:Bool!
        var dataUploadCompletionStatus2:Bool!
        let queue = DispatchQueue(label: "myhjvkheditingQvideosYoutubeMusicssseue")
        let group = DispatchGroup()
        var array:[Int] = [1]
        if initialArr != nil {
            var present = false
            for item in initialArr! {
                if item.url == currentItem.url {
                    present = true
                }
            }
            if present == false {
                array = [2]
            }
        } else {
            array = [2]
        }
            
        for i in array {
            group.enter()
            queue.async { [weak self] in
                guard let strongSelf = self else {return}
                switch i {
                case 1:
                    strongSelf.processYoutubeStatus(ref: strongSelf.currRef, currentItem: currentItem, completion: {err in
                        if let error = err {
                            dataUploadCompletionStatus1 = false
                            errors.append(error)
                        } else {
                            dataUploadCompletionStatus1 = true
                            print("Youtube Status done \(i)")
                        }
                        group.leave()
                    })
                case 2:
                    strongSelf.processYoutubeURL(ref: strongSelf.currRef, currentItem: currentItem, completion: {err in
                        if let error = err {
                            dataUploadCompletionStatus2 = false
                            errors.append(error)
                        } else {
                            dataUploadCompletionStatus2 = true
                            print("Youtube URL done \(i)")
                        }
                        group.leave()
                    })
                default:
                    print("Edit Video error")
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
    
    func processYoutubeStatus(ref: DatabaseReference, currentItem: YouTubeData, completion: @escaping ((Error?) -> Void)) {
        
        ref.child("Youtube").child("\(currentItem.type)--\(currentItem.title.replacingOccurrences(of: ".", with: " ").replacingOccurrences(of: "#", with: " ").replacingOccurrences(of: "$", with: " ").replacingOccurrences(of: "[", with: " ").replacingOccurrences(of: "]", with: " ").replacingOccurrences(of: ":", with: " "))--\(currentItem.url.replacingOccurrences(of: "/", with: "").replacingOccurrences(of: ".", with: "").replacingOccurrences(of: "#", with: "").replacingOccurrences(of: "$", with: "").suffix(10))--\(currVideo.toneDeafAppId)").child("Active Status").setValue(currentItem.isActive, withCompletionBlock: { error, reference in
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
    
    func processYoutubeURL(ref: DatabaseReference, currentItem: YouTubeData, completion: @escaping ((Error?) -> Void)) {
        
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone(identifier: "EDT")
        formatter.dateFormat = "MMMM dd, yyyy"
        let currdate = formatter.string(from: Date())
        
        let timeFormatter = DateFormatter()
        timeFormatter.timeZone = TimeZone(identifier: "EDT")
        timeFormatter.dateFormat = "HH:mm:ss a"
        let currtime = timeFormatter.string(from: Date())
        
        var url = currentItem.url
        var videoId = ""
        if !url.contains("playlist") {
            if url.contains("youtu.be/") {
                videoId = String((url.suffix(11)))
            } else
            if url.contains("watch?v=") {
                if let range = url.range(of: "=") {
                    url.removeSubrange(url.startIndex..<range.lowerBound)
                }
                videoId = String(url.dropFirst())
                videoId = String(videoId.prefix(11))
                
            }
            else {
                mediumImpactGenerator.impactOccurred()
                Utilities.showError2("Youtube url parsing error", actionText: "OK")
                completion(VideoUploadErrors.youtubeURLParse)
                return
            }
            YoutubeRequest.shared.getVideos(videoId: videoId, url: url, tdAppId: currVideo.toneDeafAppId, completion: {[weak self] result in
                guard let strongSelf = self else {return}
                switch result {
                case.success(let data):
                    var ytContentKey:String!
                    switch strongSelf.currVideo.type {
                    case "Music Video":
                        ytContentKey = youtubeVideoContentTyp
                    case "Audio Video":
                        ytContentKey = youtubeAudioVideoContentType
                    case "Playlist":
                        ytContentKey = youtubePlaylistContentType
                    default:
                        ytContentKey = youtubeAltVideoContentType
                    }
                    
                    
                    let ytContentRandomKey = ("\(ytContentKey!)--\(data.title.replacingOccurrences(of: ".", with: " ").replacingOccurrences(of: "#", with: " ").replacingOccurrences(of: "$", with: " ").replacingOccurrences(of: "[", with: " ").replacingOccurrences(of: "]", with: " ").replacingOccurrences(of: ":", with: " "))--\(data.url.replacingOccurrences(of: "/", with: "").replacingOccurrences(of: ".", with: "").replacingOccurrences(of: "#", with: "").replacingOccurrences(of: "$", with: "").suffix(10))--\(strongSelf.currVideo.toneDeafAppId)")
                    
                    let VideoRef = Database.database().reference().child("Music Content").child("Videos").child("\(videoContentTag)--\(strongSelf.currVideo.title.replacingOccurrences(of: ".", with: " ").replacingOccurrences(of: "#", with: " ").replacingOccurrences(of: "$", with: " ").replacingOccurrences(of: "[", with: " ").replacingOccurrences(of: "]", with: " ").replacingOccurrences(of: ":", with: " "))--\(strongSelf.currVideo.toneDeafAppId)").child("Youtube").child(ytContentRandomKey)
                    
                    var YTInfoMap = [String : Any]()
                    YTInfoMap = [
                        "Title" : data.title,
                        "Tone Deaf App Video Id": data.toneDeafAppId,
                        "Date Uploaded To Youtube" : data.dateYT,
                        "Time Uploaded To Youtube" : data.timeYT,
                        "Time Uploaded To App" : currtime,
                        "Date Uploaded To App" : currdate,
                        "Channel Title" : data.channelTitle,
                        "Description" : data.description,
                        "Duration": data.duration,
                        "Thumbnail URL" : data.thumbnailURL,
                        "Video URL" : data.url,
                        "Views In App" : data.viewsIA,
                        "Views on Youtube" : data.viewsYT,
                        "Number of Favorites" : 0,
                        "Youtube Id" : data.youtubeId,
                        "Type": ytContentKey,
                        "Active Status": currentItem.isActive]
                    
                    VideoRef.updateChildValues(YTInfoMap) { [weak self] (error, albumRef) in
                        guard let strongSelf = self else {return}
                        if let error = error {
                            print("📕 Failed to store Youtube dictionary to database: \(error)")
                            Utilities.showError2("Failed to Store Youtube. Please try again.", actionText: "OK")
                            completion(error)
                            return
                        } else {
                            //print("📗 Youtube data for \(strongSelf.videoToUpload.title) saved to database successfully.")
                            completion(nil)
                            return
                        }
                    }
                case .failure(let error):
                    completion(error)
                }
            })
        } else {
            if url.contains("playlist?list=") {
                if let range = url.range(of: "=") {
                    url.removeSubrange(url.startIndex..<range.lowerBound)
                }
                videoId = String(url.dropFirst())
                
            }
            YoutubeRequest.shared.getVideos(playlistId: videoId, url: url, tdAppId: currVideo.toneDeafAppId, completion: {[weak self] result in
                guard let strongSelf = self else {return}
                switch result {
                case.success(let data):
                    var ytContentKey:String!
                    switch strongSelf.currVideo.type {
                    case "Music Video":
                        ytContentKey = youtubeVideoContentTyp
                    case "Audio Video":
                        ytContentKey = youtubeAudioVideoContentType
                    case "Playlist":
                        ytContentKey = youtubePlaylistContentType
                    default:
                        ytContentKey = youtubeAltVideoContentType
                    }
                    
                    
                    let ytContentRandomKey = ("\(ytContentKey!)--\(data.title.replacingOccurrences(of: ".", with: " ").replacingOccurrences(of: "#", with: " ").replacingOccurrences(of: "$", with: " ").replacingOccurrences(of: "[", with: " ").replacingOccurrences(of: "]", with: " ").replacingOccurrences(of: ":", with: " "))--\(data.url.replacingOccurrences(of: "/", with: "").replacingOccurrences(of: ".", with: "").replacingOccurrences(of: "#", with: "").replacingOccurrences(of: "$", with: "").suffix(10))--\(strongSelf.currVideo.toneDeafAppId)")
                    
                    let VideoRef = Database.database().reference().child("Music Content").child("Videos").child("\(videoContentTag)--\(strongSelf.currVideo.title.replacingOccurrences(of: ".", with: " ").replacingOccurrences(of: "#", with: " ").replacingOccurrences(of: "$", with: " ").replacingOccurrences(of: "[", with: " ").replacingOccurrences(of: "]", with: " ").replacingOccurrences(of: ":", with: " "))--\(strongSelf.currVideo.toneDeafAppId)").child("Youtube").child(ytContentRandomKey)
                    
                    var YTInfoMap = [String : Any]()
                    YTInfoMap = [
                        "Title" : data.title,
                        "Tone Deaf App Video Id": data.toneDeafAppId,
                        "Date Uploaded To Youtube" : data.dateYT,
                        "Time Uploaded To Youtube" : data.timeYT,
                        "Time Uploaded To App" : currtime,
                        "Date Uploaded To App" : currdate,
                        "Channel Title" : data.channelTitle,
                        "Description" : data.description,
                        "Duration": data.duration,
                        "Thumbnail URL" : data.thumbnailURL,
                        "Video URL" : data.url,
                        "Views In App" : data.viewsIA,
                        "Views on Youtube" : data.viewsYT,
                        "Number of Favorites" : 0,
                        "Youtube Id" : data.youtubeId,
                        "Type": ytContentKey,
                        "Active Status": currentItem.isActive]
                    
                    VideoRef.updateChildValues(YTInfoMap) { [weak self] (error, albumRef) in
                        guard let strongSelf = self else {return}
                        if let error = error {
                            print("📕 Failed to store Youtube dictionary to database: \(error)")
                            Utilities.showError2("Failed to Store Youtube. Please try again.", actionText: "OK")
                            completion(error)
                            return
                        } else {
                            //print("📗 Youtube data for \(strongSelf.videoToUpload.title) saved to database successfully.")
                            completion(nil)
                            return
                        }
                    }
                case .failure(let error):
                    completion(error)
                }
            })
        }
    }
//
    func removeYoutube(itemToGo:YouTubeData, completion: @escaping ((Error?) -> Void)) {
        currRef.child("Youtube").child("\(itemToGo.type)--\(itemToGo.title.replacingOccurrences(of: ".", with: " ").replacingOccurrences(of: "#", with: " ").replacingOccurrences(of: "$", with: " ").replacingOccurrences(of: "[", with: " ").replacingOccurrences(of: "]", with: " ").replacingOccurrences(of: ":", with: " "))--\(itemToGo.url.replacingOccurrences(of: "/", with: "").replacingOccurrences(of: ".", with: "").replacingOccurrences(of: "#", with: "").replacingOccurrences(of: "$", with: "").suffix(10))--\(currVideo.toneDeafAppId)").removeValue(completionBlock: { error, reference in
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
    
    //MARK: - IGTV
    func processIGTV(initialArr: [IGTVData]?,newArr: [IGTVData]?, currentVideo: VideoData, completion: @escaping (([Error]?) -> Void)) {
        currVideo = currentVideo
        
        currRef = Database.database().reference().child("Music Content").child("Videos").child("\(videoContentTag)--\(currVideo.title.replacingOccurrences(of: ".", with: " ").replacingOccurrences(of: "#", with: " ").replacingOccurrences(of: "$", with: " ").replacingOccurrences(of: "[", with: " ").replacingOccurrences(of: "]", with: " ").replacingOccurrences(of: ":", with: " "))--\(currVideo.toneDeafAppId)")
        if newArr == nil && initialArr == nil {
            completion(nil)
            return
        }
        
        let semaphore = DispatchSemaphore(value: 0)
        let group = DispatchGroup()
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let strongSelf = self else {return}
            var count = 0
            if initialArr != nil {
                if newArr != nil {
                    for vid in initialArr! {
                        var present = false
                        for one in newArr! {
                            if one.url ==  vid.url {
                                present = true
                            }
                        }
                        if present == false {
                            //remove vid from initial arr
                            strongSelf.removeIGTV(itemToGo: vid, completion: { err in
                                if let err = err {
                                    
                                }
                            })
                        }
                    }
                } else {
                    //remove all initial arr items and break
                    for item in initialArr! {
                        strongSelf.removeIGTV(itemToGo: item, completion: { err in
                            if let err = err {
                                
                            }
                        })
                    }
                }
            }
            
            if newArr == nil {
                completion(nil)
                return
            }
            
            if newArr!.isEmpty {
                completion(nil)
                return
            }
            
            for item in newArr! {
                if count != 0 {
                    usleep(1000)
                }
                strongSelf.startIGTV(initialArr: initialArr, currentItem: item, index: count, completion: { err in
                    count+=1
                    if let err = err {
                        completion(err)
                        return
                    } else {
                        if count == newArr!.count {
                            completion(nil)
                            return
                        } else {
                            semaphore.signal()
                        }
                    }
                })
                semaphore.wait()
            }
        }
    }
    
    func startIGTV(initialArr: [IGTVData]?,currentItem: IGTVData, index:Int, completion: @escaping (([Error]?) -> Void)) {
        var errors:[Error] = []
        
        var dataUploadCompletionStatus1:Bool!
        var dataUploadCompletionStatus2:Bool!
        let queue = DispatchQueue(label: "myhjvkheditingQvideosIGTVMusicssseue")
        let group = DispatchGroup()
        var array:[Int] = [1]
        if initialArr != nil {
            var present = false
            for item in initialArr! {
                if item.url == currentItem.url {
                    present = true
                }
            }
            if present == false {
                array = [2]
            }
        } else {
            array = [2]
        }
            
        for i in array {
            group.enter()
            queue.async { [weak self] in
                guard let strongSelf = self else {return}
                switch i {
                case 1:
                    strongSelf.processIGTVStatus(ref: strongSelf.currRef, currentItem: currentItem, completion: {err in
                        if let error = err {
                            dataUploadCompletionStatus1 = false
                            errors.append(error)
                        } else {
                            dataUploadCompletionStatus1 = true
                            print("IGTV Status done \(i)")
                        }
                        group.leave()
                    })
                case 2:
                    strongSelf.processIGTVURL(ref: strongSelf.currRef, currentItem: currentItem, completion: {err in
                        if let error = err {
                            dataUploadCompletionStatus2 = false
                            errors.append(error)
                        } else {
                            dataUploadCompletionStatus2 = true
                            print("IGTV URL done \(i)")
                        }
                        group.leave()
                    })
                default:
                    print("Edit Video error")
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
    
    func processIGTVStatus(ref: DatabaseReference, currentItem: IGTVData, completion: @escaping ((Error?) -> Void)) {
        
        ref.child("IGTV").child("\(iGTVVideoContentTag)--\(currVideo.title.replacingOccurrences(of: ".", with: " ").replacingOccurrences(of: "#", with: " ").replacingOccurrences(of: "$", with: " ").replacingOccurrences(of: "[", with: " ").replacingOccurrences(of: "]", with: " ").replacingOccurrences(of: ":", with: " "))--\(currentItem.url.replacingOccurrences(of: "/", with: "").replacingOccurrences(of: ".", with: "").replacingOccurrences(of: "#", with: "").replacingOccurrences(of: "$", with: "").suffix(10))--\(currVideo.toneDeafAppId)").child("Active Status").setValue(currentItem.isActive, withCompletionBlock: { error, reference in
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
    
    func processIGTVURL(ref: DatabaseReference, currentItem: IGTVData, completion: @escaping ((Error?) -> Void)) {
        
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone(identifier: "EDT")
        formatter.dateFormat = "MMMM dd, yyyy"
        let currdate = formatter.string(from: Date())
        
        let timeFormatter = DateFormatter()
        timeFormatter.timeZone = TimeZone(identifier: "EDT")
        timeFormatter.dateFormat = "HH:mm:ss a"
        let currtime = timeFormatter.string(from: Date())
        
        let contentRandomKey = ("\(iGTVVideoContentTag)--\(currVideo.title.replacingOccurrences(of: ".", with: " ").replacingOccurrences(of: "#", with: " ").replacingOccurrences(of: "$", with: " ").replacingOccurrences(of: "[", with: " ").replacingOccurrences(of: "]", with: " ").replacingOccurrences(of: ":", with: " "))--\(currentItem.url.replacingOccurrences(of: "/", with: "").replacingOccurrences(of: ".", with: "").replacingOccurrences(of: "#", with: "").replacingOccurrences(of: "$", with: "").suffix(10))--\(currVideo.toneDeafAppId)")
        
        let VideoRef = Database.database().reference().child("Music Content").child("Videos").child("\(videoContentTag)--\(currVideo.title.replacingOccurrences(of: ".", with: " ").replacingOccurrences(of: "#", with: " ").replacingOccurrences(of: "$", with: " ").replacingOccurrences(of: "[", with: " ").replacingOccurrences(of: "]", with: " ").replacingOccurrences(of: ":", with: " "))--\(currVideo.toneDeafAppId)").child("IGTV").child(contentRandomKey)
        
        var YTInfoMap = [String : Any]()
        YTInfoMap = [
            "Time Uploaded To App" : currtime,
            "Date Uploaded To App" : currdate,
            "Video URL" : currentItem.url,
            "Active Status": currentItem.isActive]
        
        VideoRef.updateChildValues(YTInfoMap) { [weak self] (error, albumRef) in
            guard let strongSelf = self else {return}
            if let error = error {
                print("📕 Failed to store IGTV dictionary to database: \(error)")
                Utilities.showError2("Failed to Store IGTV. Please try again.", actionText: "OK")
                completion(error)
                return
            } else {
                completion(nil)
                return
            }
        }
    }
    
    func removeIGTV(itemToGo:IGTVData, completion: @escaping ((Error?) -> Void)) {
        currRef.child("IGTV").child("\(iGTVVideoContentTag)--\(currVideo.title.replacingOccurrences(of: ".", with: " ").replacingOccurrences(of: "#", with: " ").replacingOccurrences(of: "$", with: " ").replacingOccurrences(of: "[", with: " ").replacingOccurrences(of: "]", with: " ").replacingOccurrences(of: ":", with: " "))--\(itemToGo.url.replacingOccurrences(of: "/", with: "").replacingOccurrences(of: ".", with: "").replacingOccurrences(of: "#", with: "").replacingOccurrences(of: "$", with: "").suffix(10))--\(currVideo.toneDeafAppId)").removeValue(completionBlock: { error, reference in
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
    
    //MARK: - Instagram
    func processInstagram(initialArr: [InstagramPostData]?,newArr: [InstagramPostData]?, currentVideo: VideoData, completion: @escaping (([Error]?) -> Void)) {
        currVideo = currentVideo
        
        currRef = Database.database().reference().child("Music Content").child("Videos").child("\(videoContentTag)--\(currVideo.title.replacingOccurrences(of: ".", with: " ").replacingOccurrences(of: "#", with: " ").replacingOccurrences(of: "$", with: " ").replacingOccurrences(of: "[", with: " ").replacingOccurrences(of: "]", with: " ").replacingOccurrences(of: ":", with: " "))--\(currVideo.toneDeafAppId)")
        if newArr == nil && initialArr == nil {
            completion(nil)
            return
        }
        
        let semaphore = DispatchSemaphore(value: 0)
        let group = DispatchGroup()
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let strongSelf = self else {return}
            var count = 0
            if initialArr != nil {
                if newArr != nil {
                    for vid in initialArr! {
                        var present = false
                        for one in newArr! {
                            if one.url ==  vid.url {
                                present = true
                            }
                        }
                        if present == false {
                            //remove vid from initial arr
                            strongSelf.removeInstagram(itemToGo: vid, completion: { err in
                                if let err = err {
                                    
                                }
                            })
                        }
                    }
                } else {
                    //remove all initial arr items and break
                    for item in initialArr! {
                        strongSelf.removeInstagram(itemToGo: item, completion: { err in
                            if let err = err {
                                
                            }
                        })
                    }
                }
            }
            
            if newArr == nil {
                completion(nil)
                return
            }
            
            if newArr!.isEmpty {
                completion(nil)
                return
            }
            
            for item in newArr! {
                if count != 0 {
                    usleep(1000)
                }
                strongSelf.startInstagram(initialArr: initialArr, currentItem: item, index: count, completion: { err in
                    count+=1
                    if let err = err {
                        completion(err)
                        return
                    } else {
                        if count == newArr!.count {
                            completion(nil)
                            return
                        } else {
                            semaphore.signal()
                        }
                    }
                })
                semaphore.wait()
            }
        }
    }
    
    func startInstagram(initialArr: [InstagramPostData]?,currentItem: InstagramPostData, index:Int, completion: @escaping (([Error]?) -> Void)) {
        var errors:[Error] = []
        
        var dataUploadCompletionStatus1:Bool!
        var dataUploadCompletionStatus2:Bool!
        let queue = DispatchQueue(label: "myhjvkheditingQvideosInstagramMusicssseue")
        let group = DispatchGroup()
        var array:[Int] = [1]
        if initialArr != nil {
            var present = false
            for item in initialArr! {
                if item.url == currentItem.url {
                    present = true
                }
            }
            if present == false {
                array = [2]
            }
        } else {
            array = [2]
        }
            
        for i in array {
            group.enter()
            queue.async { [weak self] in
                guard let strongSelf = self else {return}
                switch i {
                case 1:
                    strongSelf.processInstagramStatus(ref: strongSelf.currRef, currentItem: currentItem, completion: {err in
                        if let error = err {
                            dataUploadCompletionStatus1 = false
                            errors.append(error)
                        } else {
                            dataUploadCompletionStatus1 = true
                            print("IGTV Status done \(i)")
                        }
                        group.leave()
                    })
                case 2:
                    strongSelf.processInstagramURL(ref: strongSelf.currRef, currentItem: currentItem, completion: {err in
                        if let error = err {
                            dataUploadCompletionStatus2 = false
                            errors.append(error)
                        } else {
                            dataUploadCompletionStatus2 = true
                            print("IGTV URL done \(i)")
                        }
                        group.leave()
                    })
                default:
                    print("Edit Video error")
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
    
    func processInstagramStatus(ref: DatabaseReference, currentItem: InstagramPostData, completion: @escaping ((Error?) -> Void)) {
        
        ref.child("Instagram").child("\(instagramPostVideoContentTag)--\(currVideo.title.replacingOccurrences(of: ".", with: " ").replacingOccurrences(of: "#", with: " ").replacingOccurrences(of: "$", with: " ").replacingOccurrences(of: "[", with: " ").replacingOccurrences(of: "]", with: " ").replacingOccurrences(of: ":", with: " "))--\(currentItem.url.replacingOccurrences(of: "/", with: "").replacingOccurrences(of: ".", with: "").replacingOccurrences(of: "#", with: "").replacingOccurrences(of: "$", with: "").suffix(10))--\(currVideo.toneDeafAppId)").child("Active Status").setValue(currentItem.isActive, withCompletionBlock: { error, reference in
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
    
    func processInstagramURL(ref: DatabaseReference, currentItem: InstagramPostData, completion: @escaping ((Error?) -> Void)) {
        
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone(identifier: "EDT")
        formatter.dateFormat = "MMMM dd, yyyy"
        let currdate = formatter.string(from: Date())
        
        let timeFormatter = DateFormatter()
        timeFormatter.timeZone = TimeZone(identifier: "EDT")
        timeFormatter.dateFormat = "HH:mm:ss a"
        let currtime = timeFormatter.string(from: Date())
        
        let contentRandomKey = ("\(instagramPostVideoContentTag)--\(currVideo.title.replacingOccurrences(of: ".", with: " ").replacingOccurrences(of: "#", with: " ").replacingOccurrences(of: "$", with: " ").replacingOccurrences(of: "[", with: " ").replacingOccurrences(of: "]", with: " ").replacingOccurrences(of: ":", with: " "))--\(currentItem.url.replacingOccurrences(of: "/", with: "").replacingOccurrences(of: ".", with: "").replacingOccurrences(of: "#", with: "").replacingOccurrences(of: "$", with: "").suffix(10))--\(currVideo.toneDeafAppId)")
        
        let VideoRef = Database.database().reference().child("Music Content").child("Videos").child("\(videoContentTag)--\(currVideo.title.replacingOccurrences(of: ".", with: " ").replacingOccurrences(of: "#", with: " ").replacingOccurrences(of: "$", with: " ").replacingOccurrences(of: "[", with: " ").replacingOccurrences(of: "]", with: " ").replacingOccurrences(of: ":", with: " "))--\(currVideo.toneDeafAppId)").child("Instagram").child(contentRandomKey)
        
        var YTInfoMap = [String : Any]()
        YTInfoMap = [
            "Time Uploaded To App" : currtime,
            "Date Uploaded To App" : currdate,
            "Video URL" : currentItem.url,
            "Active Status": currentItem.isActive]
        
        VideoRef.updateChildValues(YTInfoMap) { [weak self] (error, albumRef) in
            guard let strongSelf = self else {return}
            if let error = error {
                print("📕 Failed to store Instagram dictionary to database: \(error)")
                Utilities.showError2("Failed to Store Instagram. Please try again.", actionText: "OK")
                completion(error)
                return
            } else {
                completion(nil)
                return
            }
        }
    }
    
    func removeInstagram(itemToGo:InstagramPostData, completion: @escaping ((Error?) -> Void)) {
        currRef.child("Instagram").child("\(instagramPostVideoContentTag)--\(currVideo.title.replacingOccurrences(of: ".", with: " ").replacingOccurrences(of: "#", with: " ").replacingOccurrences(of: "$", with: " ").replacingOccurrences(of: "[", with: " ").replacingOccurrences(of: "]", with: " ").replacingOccurrences(of: ":", with: " "))--\(itemToGo.url.replacingOccurrences(of: "/", with: "").replacingOccurrences(of: ".", with: "").replacingOccurrences(of: "#", with: "").replacingOccurrences(of: "$", with: "").suffix(10))--\(currVideo.toneDeafAppId)").removeValue(completionBlock: { error, reference in
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
    
    //MARK: - Worldstar
    func processWorldstar(initialArr: [WorldstarData]?,newArr: [WorldstarData]?, currentVideo: VideoData, completion: @escaping (([Error]?) -> Void)) {
        currVideo = currentVideo
        
        currRef = Database.database().reference().child("Music Content").child("Videos").child("\(videoContentTag)--\(currVideo.title.replacingOccurrences(of: ".", with: " ").replacingOccurrences(of: "#", with: " ").replacingOccurrences(of: "$", with: " ").replacingOccurrences(of: "[", with: " ").replacingOccurrences(of: "]", with: " ").replacingOccurrences(of: ":", with: " "))--\(currVideo.toneDeafAppId)")
        if newArr == nil && initialArr == nil {
            completion(nil)
            return
        }
        
        let semaphore = DispatchSemaphore(value: 0)
        let group = DispatchGroup()
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let strongSelf = self else {return}
            var count = 0
            if initialArr != nil {
                if newArr != nil {
                    for vid in initialArr! {
                        var present = false
                        for one in newArr! {
                            if one.url ==  vid.url {
                                present = true
                            }
                        }
                        if present == false {
                            //remove vid from initial arr
                            strongSelf.removeWorldstar(itemToGo: vid, completion: { err in
                                if let err = err {
                                    
                                }
                            })
                        }
                    }
                } else {
                    //remove all initial arr items and break
                    for item in initialArr! {
                        strongSelf.removeWorldstar(itemToGo: item, completion: { err in
                            if let err = err {
                                
                            }
                        })
                    }
                }
            }
            
            if newArr == nil {
                completion(nil)
                return
            }
            
            if newArr!.isEmpty {
                completion(nil)
                return
            }
            
            for item in newArr! {
                if count != 0 {
                    usleep(1000)
                }
                strongSelf.startWorldstar(initialArr: initialArr, currentItem: item, index: count, completion: { err in
                    count+=1
                    if let err = err {
                        completion(err)
                        return
                    } else {
                        if count == newArr!.count {
                            completion(nil)
                            return
                        } else {
                            semaphore.signal()
                        }
                    }
                })
                semaphore.wait()
            }
        }
    }
    
    func startWorldstar(initialArr: [WorldstarData]?,currentItem: WorldstarData, index:Int, completion: @escaping (([Error]?) -> Void)) {
        var errors:[Error] = []
        
        var dataUploadCompletionStatus1:Bool!
        var dataUploadCompletionStatus2:Bool!
        let queue = DispatchQueue(label: "myhjvkheditingQvideosWorldstarMusicssseue")
        let group = DispatchGroup()
        var array:[Int] = [1]
        if initialArr != nil {
            var present = false
            for item in initialArr! {
                if item.url == currentItem.url {
                    present = true
                }
            }
            if present == false {
                array = [2]
            }
        } else {
            array = [2]
        }
            
        for i in array {
            group.enter()
            queue.async { [weak self] in
                guard let strongSelf = self else {return}
                switch i {
                case 1:
                    strongSelf.processWorldstarStatus(ref: strongSelf.currRef, currentItem: currentItem, completion: {err in
                        if let error = err {
                            dataUploadCompletionStatus1 = false
                            errors.append(error)
                        } else {
                            dataUploadCompletionStatus1 = true
                            print("Worldstar Status done \(i)")
                        }
                        group.leave()
                    })
                case 2:
                    strongSelf.processWorldstarURL(ref: strongSelf.currRef, currentItem: currentItem, completion: {err in
                        if let error = err {
                            dataUploadCompletionStatus2 = false
                            errors.append(error)
                        } else {
                            dataUploadCompletionStatus2 = true
                            print("Worldstar URL done \(i)")
                        }
                        group.leave()
                    })
                default:
                    print("Edit Video error")
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
    
    func processWorldstarStatus(ref: DatabaseReference, currentItem: WorldstarData, completion: @escaping ((Error?) -> Void)) {
        
        ref.child("Worldstar").child("\(worldstarVideoContentTag)--\(currVideo.title.replacingOccurrences(of: ".", with: " ").replacingOccurrences(of: "#", with: " ").replacingOccurrences(of: "$", with: " ").replacingOccurrences(of: "[", with: " ").replacingOccurrences(of: "]", with: " ").replacingOccurrences(of: ":", with: " "))--\(currentItem.url.replacingOccurrences(of: "/", with: "").replacingOccurrences(of: ".", with: "").replacingOccurrences(of: "#", with: "").replacingOccurrences(of: "$", with: "").suffix(10))--\(currVideo.toneDeafAppId)").child("Active Status").setValue(currentItem.isActive, withCompletionBlock: { error, reference in
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
    
    func processWorldstarURL(ref: DatabaseReference, currentItem: WorldstarData, completion: @escaping ((Error?) -> Void)) {
        
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone(identifier: "EDT")
        formatter.dateFormat = "MMMM dd, yyyy"
        let currdate = formatter.string(from: Date())
        
        let timeFormatter = DateFormatter()
        timeFormatter.timeZone = TimeZone(identifier: "EDT")
        timeFormatter.dateFormat = "HH:mm:ss a"
        let currtime = timeFormatter.string(from: Date())
        
        let contentRandomKey = ("\(worldstarVideoContentTag)--\(currVideo.title.replacingOccurrences(of: ".", with: " ").replacingOccurrences(of: "#", with: " ").replacingOccurrences(of: "$", with: " ").replacingOccurrences(of: "[", with: " ").replacingOccurrences(of: "]", with: " ").replacingOccurrences(of: ":", with: " "))--\(currentItem.url.replacingOccurrences(of: "/", with: "").replacingOccurrences(of: ".", with: "").replacingOccurrences(of: "#", with: "").replacingOccurrences(of: "$", with: "").suffix(10))--\(currVideo.toneDeafAppId)")
        
        let VideoRef = Database.database().reference().child("Music Content").child("Videos").child("\(videoContentTag)--\(currVideo.title.replacingOccurrences(of: ".", with: " ").replacingOccurrences(of: "#", with: " ").replacingOccurrences(of: "$", with: " ").replacingOccurrences(of: "[", with: " ").replacingOccurrences(of: "]", with: " ").replacingOccurrences(of: ":", with: " "))--\(currVideo.toneDeafAppId)").child("Worldstar").child(contentRandomKey)
        
        var YTInfoMap = [String : Any]()
        YTInfoMap = [
            "Time Uploaded To App" : currtime,
            "Date Uploaded To App" : currdate,
            "Video URL" : currentItem.url,
            "Active Status": currentItem.isActive]
        
        VideoRef.updateChildValues(YTInfoMap) { [weak self] (error, albumRef) in
            guard let strongSelf = self else {return}
            if let error = error {
                print("📕 Failed to store Worldstar dictionary to database: \(error)")
                Utilities.showError2("Failed to Store Worldstar. Please try again.", actionText: "OK")
                completion(error)
                return
            } else {
                completion(nil)
                return
            }
        }
    }
    
    func removeWorldstar(itemToGo:WorldstarData, completion: @escaping ((Error?) -> Void)) {
        currRef.child("Worldstar").child("\(worldstarVideoContentTag)--\(currVideo.title.replacingOccurrences(of: ".", with: " ").replacingOccurrences(of: "#", with: " ").replacingOccurrences(of: "$", with: " ").replacingOccurrences(of: "[", with: " ").replacingOccurrences(of: "]", with: " ").replacingOccurrences(of: ":", with: " "))--\(itemToGo.url.replacingOccurrences(of: "/", with: "").replacingOccurrences(of: ".", with: "").replacingOccurrences(of: "#", with: "").replacingOccurrences(of: "$", with: "").suffix(10))--\(currVideo.toneDeafAppId)").removeValue(completionBlock: { error, reference in
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
    
    //MARK: - Facebook
    func processFacebook(initialArr: [FacebookPostData]?,newArr: [FacebookPostData]?, currentVideo: VideoData, completion: @escaping (([Error]?) -> Void)) {
        currVideo = currentVideo
        
        currRef = Database.database().reference().child("Music Content").child("Videos").child("\(videoContentTag)--\(currVideo.title.replacingOccurrences(of: ".", with: " ").replacingOccurrences(of: "#", with: " ").replacingOccurrences(of: "$", with: " ").replacingOccurrences(of: "[", with: " ").replacingOccurrences(of: "]", with: " ").replacingOccurrences(of: ":", with: " "))--\(currVideo.toneDeafAppId)")
        if newArr == nil && initialArr == nil {
            completion(nil)
            return
        }
        
        let semaphore = DispatchSemaphore(value: 0)
        let group = DispatchGroup()
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let strongSelf = self else {return}
            var count = 0
            if initialArr != nil {
                if newArr != nil {
                    for vid in initialArr! {
                        var present = false
                        for one in newArr! {
                            if one.url ==  vid.url {
                                present = true
                            }
                        }
                        if present == false {
                            //remove vid from initial arr
                            strongSelf.removeFacebook(itemToGo: vid, completion: { err in
                                if let err = err {
                                    
                                }
                            })
                        }
                    }
                } else {
                    //remove all initial arr items and break
                    for item in initialArr! {
                        strongSelf.removeFacebook(itemToGo: item, completion: { err in
                            if let err = err {
                                
                            }
                        })
                    }
                }
            }
            
            if newArr == nil {
                completion(nil)
                return
            }
            
            if newArr!.isEmpty {
                completion(nil)
                return
            }
            
            for item in newArr! {
                if count != 0 {
                    usleep(1000)
                }
                strongSelf.startFacebook(initialArr: initialArr, currentItem: item, index: count, completion: { err in
                    count+=1
                    if let err = err {
                        completion(err)
                        return
                    } else {
                        if count == newArr!.count {
                            completion(nil)
                            return
                        } else {
                            semaphore.signal()
                        }
                    }
                })
                semaphore.wait()
            }
        }
    }
    
    func startFacebook(initialArr: [FacebookPostData]?,currentItem: FacebookPostData, index:Int, completion: @escaping (([Error]?) -> Void)) {
        var errors:[Error] = []
        
        var dataUploadCompletionStatus1:Bool!
        var dataUploadCompletionStatus2:Bool!
        let queue = DispatchQueue(label: "myhjvkheditingQvideosFacebookMusicssseue")
        let group = DispatchGroup()
        var array:[Int] = [1]
        if initialArr != nil {
            var present = false
            for item in initialArr! {
                if item.url == currentItem.url {
                    present = true
                }
            }
            if present == false {
                array = [2]
            }
        } else {
            array = [2]
        }
            
        for i in array {
            group.enter()
            queue.async { [weak self] in
                guard let strongSelf = self else {return}
                switch i {
                case 1:
                    strongSelf.processFacebookStatus(ref: strongSelf.currRef, currentItem: currentItem, completion: {err in
                        if let error = err {
                            dataUploadCompletionStatus1 = false
                            errors.append(error)
                        } else {
                            dataUploadCompletionStatus1 = true
                            print("Facebook Status done \(i)")
                        }
                        group.leave()
                    })
                case 2:
                    strongSelf.processFacebookURL(ref: strongSelf.currRef, currentItem: currentItem, completion: {err in
                        if let error = err {
                            dataUploadCompletionStatus2 = false
                            errors.append(error)
                        } else {
                            dataUploadCompletionStatus2 = true
                            print("Facebook URL done \(i)")
                        }
                        group.leave()
                    })
                default:
                    print("Edit Video error")
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
    
    func processFacebookStatus(ref: DatabaseReference, currentItem: FacebookPostData, completion: @escaping ((Error?) -> Void)) {
        
        ref.child("Facebook").child("\(facebookPostVideoContentTag)--\(currVideo.title.replacingOccurrences(of: ".", with: " ").replacingOccurrences(of: "#", with: " ").replacingOccurrences(of: "$", with: " ").replacingOccurrences(of: "[", with: " ").replacingOccurrences(of: "]", with: " ").replacingOccurrences(of: ":", with: " "))--\(currentItem.url.replacingOccurrences(of: "/", with: "").replacingOccurrences(of: ".", with: "").replacingOccurrences(of: "#", with: "").replacingOccurrences(of: "$", with: "").suffix(10))--\(currVideo.toneDeafAppId)").child("Active Status").setValue(currentItem.isActive, withCompletionBlock: { error, reference in
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
    
    func processFacebookURL(ref: DatabaseReference, currentItem: FacebookPostData, completion: @escaping ((Error?) -> Void)) {
        
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone(identifier: "EDT")
        formatter.dateFormat = "MMMM dd, yyyy"
        let currdate = formatter.string(from: Date())
        
        let timeFormatter = DateFormatter()
        timeFormatter.timeZone = TimeZone(identifier: "EDT")
        timeFormatter.dateFormat = "HH:mm:ss a"
        let currtime = timeFormatter.string(from: Date())
        
        let contentRandomKey = ("\(facebookPostVideoContentTag)--\(currVideo.title.replacingOccurrences(of: ".", with: " ").replacingOccurrences(of: "#", with: " ").replacingOccurrences(of: "$", with: " ").replacingOccurrences(of: "[", with: " ").replacingOccurrences(of: "]", with: " ").replacingOccurrences(of: ":", with: " "))--\(currentItem.url.replacingOccurrences(of: "/", with: "").replacingOccurrences(of: ".", with: "").replacingOccurrences(of: "#", with: "").replacingOccurrences(of: "$", with: "").suffix(10))--\(currVideo.toneDeafAppId)")
        
        let VideoRef = Database.database().reference().child("Music Content").child("Videos").child("\(videoContentTag)--\(currVideo.title.replacingOccurrences(of: ".", with: " ").replacingOccurrences(of: "#", with: " ").replacingOccurrences(of: "$", with: " ").replacingOccurrences(of: "[", with: " ").replacingOccurrences(of: "]", with: " ").replacingOccurrences(of: ":", with: " "))--\(currVideo.toneDeafAppId)").child("Facebook").child(contentRandomKey)
        
        var YTInfoMap = [String : Any]()
        YTInfoMap = [
            "Time Uploaded To App" : currtime,
            "Date Uploaded To App" : currdate,
            "Video URL" : currentItem.url,
            "Active Status": currentItem.isActive]
        
        VideoRef.updateChildValues(YTInfoMap) { [weak self] (error, albumRef) in
            guard let strongSelf = self else {return}
            if let error = error {
                print("📕 Failed to store Facebook dictionary to database: \(error)")
                Utilities.showError2("Failed to Store Facebook. Please try again.", actionText: "OK")
                completion(error)
                return
            } else {
                completion(nil)
                return
            }
        }
    }
    
    func removeFacebook(itemToGo:FacebookPostData, completion: @escaping ((Error?) -> Void)) {
        currRef.child("Facebook").child("\(instagramPostVideoContentTag)--\(currVideo.title.replacingOccurrences(of: ".", with: " ").replacingOccurrences(of: "#", with: " ").replacingOccurrences(of: "$", with: " ").replacingOccurrences(of: "[", with: " ").replacingOccurrences(of: "]", with: " ").replacingOccurrences(of: ":", with: " "))--\(itemToGo.url.replacingOccurrences(of: "/", with: "").replacingOccurrences(of: ".", with: "").replacingOccurrences(of: "#", with: "").replacingOccurrences(of: "$", with: "").suffix(10))--\(currVideo.toneDeafAppId)").removeValue(completionBlock: { error, reference in
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
    
    //MARK: - Twitter
    func processTwitter(initialArr: [TwitterTweetData]?,newArr: [TwitterTweetData]?, currentVideo: VideoData, completion: @escaping (([Error]?) -> Void)) {
        currVideo = currentVideo
        
        currRef = Database.database().reference().child("Music Content").child("Videos").child("\(videoContentTag)--\(currVideo.title.replacingOccurrences(of: ".", with: " ").replacingOccurrences(of: "#", with: " ").replacingOccurrences(of: "$", with: " ").replacingOccurrences(of: "[", with: " ").replacingOccurrences(of: "]", with: " ").replacingOccurrences(of: ":", with: " "))--\(currVideo.toneDeafAppId)")
        if newArr == nil && initialArr == nil {
            completion(nil)
            return
        }
        
        let semaphore = DispatchSemaphore(value: 0)
        let group = DispatchGroup()
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let strongSelf = self else {return}
            var count = 0
            if initialArr != nil {
                if newArr != nil {
                    for vid in initialArr! {
                        var present = false
                        for one in newArr! {
                            if one.url ==  vid.url {
                                present = true
                            }
                        }
                        if present == false {
                            //remove vid from initial arr
                            strongSelf.removeTwitter(itemToGo: vid, completion: { err in
                                if let err = err {
                                    
                                }
                            })
                        }
                    }
                } else {
                    //remove all initial arr items and break
                    for item in initialArr! {
                        strongSelf.removeTwitter(itemToGo: item, completion: { err in
                            if let err = err {
                                
                            }
                        })
                    }
                }
            }
            
            if newArr == nil {
                completion(nil)
                return
            }
            
            if newArr!.isEmpty {
                completion(nil)
                return
            }
            
            for item in newArr! {
                if count != 0 {
                    usleep(1000)
                }
                strongSelf.startTwitter(initialArr: initialArr, currentItem: item, index: count, completion: { err in
                    count+=1
                    if let err = err {
                        completion(err)
                        return
                    } else {
                        if count == newArr!.count {
                            completion(nil)
                            return
                        } else {
                            semaphore.signal()
                        }
                    }
                })
                semaphore.wait()
            }
        }
    }
    
    func startTwitter(initialArr: [TwitterTweetData]?,currentItem: TwitterTweetData, index:Int, completion: @escaping (([Error]?) -> Void)) {
        var errors:[Error] = []
        
        var dataUploadCompletionStatus1:Bool!
        var dataUploadCompletionStatus2:Bool!
        let queue = DispatchQueue(label: "myhjvkheditingQvideosTwitterMusicssseue")
        let group = DispatchGroup()
        var array:[Int] = [1]
        if initialArr != nil {
            var present = false
            for item in initialArr! {
                if item.url == currentItem.url {
                    present = true
                }
            }
            if present == false {
                array = [2]
            }
        } else {
            array = [2]
        }
            
        for i in array {
            group.enter()
            queue.async { [weak self] in
                guard let strongSelf = self else {return}
                switch i {
                case 1:
                    strongSelf.processTwitterStatus(ref: strongSelf.currRef, currentItem: currentItem, completion: {err in
                        if let error = err {
                            dataUploadCompletionStatus1 = false
                            errors.append(error)
                        } else {
                            dataUploadCompletionStatus1 = true
                            print("Twitter Status done \(i)")
                        }
                        group.leave()
                    })
                case 2:
                    strongSelf.processTwitterURL(ref: strongSelf.currRef, currentItem: currentItem, completion: {err in
                        if let error = err {
                            dataUploadCompletionStatus2 = false
                            errors.append(error)
                        } else {
                            dataUploadCompletionStatus2 = true
                            print("Twitter URL done \(i)")
                        }
                        group.leave()
                    })
                default:
                    print("Edit Video error")
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
    
    func processTwitterStatus(ref: DatabaseReference, currentItem: TwitterTweetData, completion: @escaping ((Error?) -> Void)) {
        
        ref.child("Twitter").child("\(twitterVideoContentTag)--\(currVideo.title.replacingOccurrences(of: ".", with: " ").replacingOccurrences(of: "#", with: " ").replacingOccurrences(of: "$", with: " ").replacingOccurrences(of: "[", with: " ").replacingOccurrences(of: "]", with: " ").replacingOccurrences(of: ":", with: " "))--\(currentItem.url.replacingOccurrences(of: "/", with: "").replacingOccurrences(of: ".", with: "").replacingOccurrences(of: "#", with: "").replacingOccurrences(of: "$", with: "").suffix(10))--\(currVideo.toneDeafAppId)").child("Active Status").setValue(currentItem.isActive, withCompletionBlock: { error, reference in
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
    
    func processTwitterURL(ref: DatabaseReference, currentItem: TwitterTweetData, completion: @escaping ((Error?) -> Void)) {
        
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone(identifier: "EDT")
        formatter.dateFormat = "MMMM dd, yyyy"
        let currdate = formatter.string(from: Date())
        
        let timeFormatter = DateFormatter()
        timeFormatter.timeZone = TimeZone(identifier: "EDT")
        timeFormatter.dateFormat = "HH:mm:ss a"
        let currtime = timeFormatter.string(from: Date())
        
        var url = currentItem.url
        var videoId = ""
        if !url.contains("status/") {
            mediumImpactGenerator.impactOccurred()
            DispatchQueue.main.async {
                Utilities.showError2("Twitter url Invalid error", actionText: "OK")
            }
            completion(VideoUploadErrors.twitterURLInvalid)
            return
        }
        if let range = url.range(of: "status/") {
            url.removeSubrange(url.startIndex..<range.lowerBound)
        }
        let split = String(url.dropFirst(7))
        videoId = String(split.prefix(19))
        TwitterRequest.shared.getPost(mediaId: videoId, completion: {[weak self] result in
                guard let strongSelf = self else {return}
                switch result {
                case.success(let data):
                    let ytContentRandomKey = ("\(twitterVideoContentTag)--\(strongSelf.currVideo.title.replacingOccurrences(of: ".", with: " ").replacingOccurrences(of: "#", with: " ").replacingOccurrences(of: "$", with: " ").replacingOccurrences(of: "[", with: " ").replacingOccurrences(of: "]", with: " ").replacingOccurrences(of: ":", with: " "))--\(data.url.replacingOccurrences(of: "/", with: "").replacingOccurrences(of: ".", with: "").replacingOccurrences(of: "#", with: "").replacingOccurrences(of: "$", with: "").suffix(10))--\(strongSelf.currVideo.toneDeafAppId)")
                    
                    let VideoRef = Database.database().reference().child("Music Content").child("Videos").child("\(videoContentTag)--\(strongSelf.currVideo.title.replacingOccurrences(of: ".", with: " ").replacingOccurrences(of: "#", with: " ").replacingOccurrences(of: "$", with: " ").replacingOccurrences(of: "[", with: " ").replacingOccurrences(of: "]", with: " ").replacingOccurrences(of: ":", with: " "))--\(strongSelf.currVideo.toneDeafAppId)").child("Twitter").child(ytContentRandomKey)
                    
                    var mediaArray:[[String:String?]] = []
                    for obj in data.media! {
                        var dict = [
                            "URL": obj.url,
                            "Media Key": obj.mediaKey,
                            "Preview URL": obj.previewURL,
                            "Type": obj.type,
                            "Content Type": obj.contentType
                        ]
                        mediaArray.append(dict)
                    }
                    
                    var YTInfoMap = [String : Any]()
                    YTInfoMap = [
                        "Media" : mediaArray,
                        "Time Uploaded To App" : currtime,
                        "Date Uploaded To App" : currdate,
                        "Date Uploaded To Twitter" : data.dateTwitter,
                        "Text" : data.text,
                        "Video URL" : data.url,
                        "Views In App" : 0,
                        "Twitter Id" : data.twitterId,
                        "Active Status": currentItem.isActive]
                    
                    VideoRef.updateChildValues(YTInfoMap) { [weak self] (error, albumRef) in
                        guard let strongSelf = self else {return}
                        if let error = error {
                            print("📕 Failed to store Twitter dictionary to database: \(error)")
                            DispatchQueue.main.async {
                                Utilities.showError2("Failed to Store Twitter. Please try again.", actionText: "OK")
                            }
                            completion(error)
                            return
                        } else {
                            //print("📗 Youtube data for \(strongSelf.videoToUpload.title) saved to database successfully.")
                            completion(nil)
                            return
                        }
                    }
                case .failure(let error):
                    completion(error)
                }
            })
    }
    
    func removeTwitter(itemToGo:TwitterTweetData, completion: @escaping ((Error?) -> Void)) {
        currRef.child("Twitter").child("\(twitterVideoContentTag)--\(currVideo.title.replacingOccurrences(of: ".", with: " ").replacingOccurrences(of: "#", with: " ").replacingOccurrences(of: "$", with: " ").replacingOccurrences(of: "[", with: " ").replacingOccurrences(of: "]", with: " ").replacingOccurrences(of: ":", with: " "))--\(itemToGo.url.replacingOccurrences(of: "/", with: "").replacingOccurrences(of: ".", with: "").replacingOccurrences(of: "#", with: "").replacingOccurrences(of: "$", with: "").suffix(10))--\(currVideo.toneDeafAppId)").removeValue(completionBlock: { error, reference in
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
    
    //MARK: - Apple
    func processApple(initialArr: [AppleVideoData]?,newArr: [AppleVideoData]?, currentVideo: VideoData, completion: @escaping (([Error]?) -> Void)) {
        currVideo = currentVideo
        
        currRef = Database.database().reference().child("Music Content").child("Videos").child("\(videoContentTag)--\(currVideo.title.replacingOccurrences(of: ".", with: " ").replacingOccurrences(of: "#", with: " ").replacingOccurrences(of: "$", with: " ").replacingOccurrences(of: "[", with: " ").replacingOccurrences(of: "]", with: " ").replacingOccurrences(of: ":", with: " "))--\(currVideo.toneDeafAppId)")
        if newArr == nil && initialArr == nil {
            completion(nil)
            return
        }
        
        let semaphore = DispatchSemaphore(value: 0)
        let group = DispatchGroup()
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let strongSelf = self else {return}
            var count = 0
            if initialArr != nil {
                if newArr != nil {
                    for vid in initialArr! {
                        var present = false
                        for one in newArr! {
                            if one.url ==  vid.url {
                                present = true
                            }
                        }
                        if present == false {
                            //remove vid from initial arr
                            strongSelf.removeApple(itemToGo: vid, completion: { err in
                                if let err = err {
                                    
                                }
                            })
                        }
                    }
                } else {
                    //remove all initial arr items and break
                    for item in initialArr! {
                        strongSelf.removeApple(itemToGo: item, completion: { err in
                            if let err = err {
                                
                            }
                        })
                    }
                }
            }
            
            if newArr == nil {
                completion(nil)
                return
            }
            
            if newArr!.isEmpty {
                completion(nil)
                return
            }
            
            for item in newArr! {
                if count != 0 {
                    usleep(1000)
                }
                strongSelf.startApple(initialArr: initialArr, currentItem: item, index: count, completion: { err in
                    count+=1
                    if let err = err {
                        completion(err)
                        return
                    } else {
                        if count == newArr!.count {
                            completion(nil)
                            return
                        } else {
                            semaphore.signal()
                        }
                    }
                })
                semaphore.wait()
            }
        }
    }
    
    func startApple(initialArr: [AppleVideoData]?,currentItem: AppleVideoData, index:Int, completion: @escaping (([Error]?) -> Void)) {
        var errors:[Error] = []
        
        var dataUploadCompletionStatus1:Bool!
        var dataUploadCompletionStatus2:Bool!
        let queue = DispatchQueue(label: "myhjvkheditingQvideosAppleMusicssseue")
        let group = DispatchGroup()
        var array:[Int] = [1]
        if initialArr != nil {
            var present = false
            for item in initialArr! {
                if item.url == currentItem.url {
                    present = true
                }
            }
            if present == false {
                array = [2]
            }
        } else {
            array = [2]
        }
            
        for i in array {
            group.enter()
            queue.async { [weak self] in
                guard let strongSelf = self else {return}
                switch i {
                case 1:
                    strongSelf.processAppleStatus(ref: strongSelf.currRef, currentItem: currentItem, completion: {err in
                        if let error = err {
                            dataUploadCompletionStatus1 = false
                            errors.append(error)
                        } else {
                            dataUploadCompletionStatus1 = true
                            print("Twitter Status done \(i)")
                        }
                        group.leave()
                    })
                case 2:
                    strongSelf.processAppleURL(ref: strongSelf.currRef, currentItem: currentItem, completion: {err in
                        if let error = err {
                            dataUploadCompletionStatus2 = false
                            errors.append(error)
                        } else {
                            dataUploadCompletionStatus2 = true
                            print("Twitter URL done \(i)")
                        }
                        group.leave()
                    })
                default:
                    print("Edit Video error")
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
    
    func processAppleStatus(ref: DatabaseReference, currentItem: AppleVideoData, completion: @escaping ((Error?) -> Void)) {
        
        ref.child("Apple Music").child("\(appleMusicContentType)--\(currVideo.title.replacingOccurrences(of: ".", with: " ").replacingOccurrences(of: "#", with: " ").replacingOccurrences(of: "$", with: " ").replacingOccurrences(of: "[", with: " ").replacingOccurrences(of: "]", with: " ").replacingOccurrences(of: ":", with: " "))--\(currentItem.url.replacingOccurrences(of: "/", with: "").replacingOccurrences(of: ".", with: "").replacingOccurrences(of: "#", with: "").replacingOccurrences(of: "$", with: "").suffix(10))--\(currVideo.toneDeafAppId)").child("Active Status").setValue(currentItem.isActive, withCompletionBlock: { error, reference in
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
    
    func processAppleURL(ref: DatabaseReference, currentItem: AppleVideoData, completion: @escaping ((Error?) -> Void)) {
        
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone(identifier: "EDT")
        formatter.dateFormat = "MMMM dd, yyyy"
        let currdate = formatter.string(from: Date())
        
        let timeFormatter = DateFormatter()
        timeFormatter.timeZone = TimeZone(identifier: "EDT")
        timeFormatter.dateFormat = "HH:mm:ss a"
        let currtime = timeFormatter.string(from: Date())
        
        var url = currentItem.url
        var videoId = ""
        if !url.contains("music-video/") {
            mediumImpactGenerator.impactOccurred()
            Utilities.showError2("Apple Music url Invalid error", actionText: "OK")
            completion(VideoUploadErrors.appleMusicURLInvalid)
            return
        }
        videoId = String(url.suffix(10))
        AppleMusicRequest.shared.getAppleMusicVideo(id: videoId, completion: {[weak self] result in
                guard let strongSelf = self else {return}
                switch result {
                case.success(let data):
                    let ytContentRandomKey = ("\(appleMusicContentType)--\(strongSelf.currVideo.title.replacingOccurrences(of: ".", with: " ").replacingOccurrences(of: "#", with: " ").replacingOccurrences(of: "$", with: " ").replacingOccurrences(of: "[", with: " ").replacingOccurrences(of: "]", with: " ").replacingOccurrences(of: ":", with: " "))--\(data.url.replacingOccurrences(of: "/", with: "").replacingOccurrences(of: ".", with: "").replacingOccurrences(of: "#", with: "").replacingOccurrences(of: "$", with: "").suffix(10))--\(strongSelf.currVideo.toneDeafAppId)")
                    
                    let VideoRef = Database.database().reference().child("Music Content").child("Videos").child("\(videoContentTag)--\(strongSelf.currVideo.title.replacingOccurrences(of: ".", with: " ").replacingOccurrences(of: "#", with: " ").replacingOccurrences(of: "$", with: " ").replacingOccurrences(of: "[", with: " ").replacingOccurrences(of: "]", with: " ").replacingOccurrences(of: ":", with: " "))--\(strongSelf.currVideo.toneDeafAppId)").child("Apple Music").child(ytContentRandomKey)
                    
                    var SongInfoMap = [String : Any]()
                    SongInfoMap = [
                        "Name" : data.name,
                        "Artist" : data.artistName,
                        "Explicity" : data.explicity,
                        "Preview URL" : data.previewURL,
                        "ISRC" : data.isrc,
                        "Date Released On Apple" : data.dateApple,
                        "Time Uploaded To App" : currtime,
                        "Date Uploaded To App" : currdate,
                        "Duration" : data.duration,
                        "Thumbnail URL" : data.thumbnailURL,
                        "URL" : data.url,
                        "Album Name" : data.albumName,
                        "Genres" : data.genres,
                        "Track Number" : data.trackNumber,
                        "Apple Music Id" : data.appleId,
                        "Active Status": currentItem.isActive
                    ]
                    
                    VideoRef.updateChildValues(SongInfoMap) { [weak self] (error, songRef) in
                        guard let strongSelf = self else {return}
                        if let error = error {
                            print("📕 Failed to upload dictionary to database: \(error)")
                            Utilities.showError2("Failed to Upload. Please try again.", actionText: "OK")
                            completion(error)
                            return
                        } else {
                            print("kjhgfdgsdgghjkjl")
                            completion(nil)
                            print("📗 Apple data for \(strongSelf.currVideo.title) saved to database successfully.")
                            return
                        }
                    }
                case .failure(let error):
                    completion(error)
                }
            })
    }
    
    func removeApple(itemToGo:AppleVideoData, completion: @escaping ((Error?) -> Void)) {
        currRef.child("Apple Music").child("\(appleMusicContentType)--\(currVideo.title.replacingOccurrences(of: ".", with: " ").replacingOccurrences(of: "#", with: " ").replacingOccurrences(of: "$", with: " ").replacingOccurrences(of: "[", with: " ").replacingOccurrences(of: "]", with: " ").replacingOccurrences(of: ":", with: " "))--\(itemToGo.url.replacingOccurrences(of: "/", with: "").replacingOccurrences(of: ".", with: "").replacingOccurrences(of: "#", with: "").replacingOccurrences(of: "$", with: "").suffix(10))--\(currVideo.toneDeafAppId)").removeValue(completionBlock: { error, reference in
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
    
    //MARK: - Tik Tok
    func processTikTok(initialArr: [TikTokData]?,newArr: [TikTokData]?, currentVideo: VideoData, completion: @escaping (([Error]?) -> Void)) {
        currVideo = currentVideo
        
        currRef = Database.database().reference().child("Music Content").child("Videos").child("\(videoContentTag)--\(currVideo.title.replacingOccurrences(of: ".", with: " ").replacingOccurrences(of: "#", with: " ").replacingOccurrences(of: "$", with: " ").replacingOccurrences(of: "[", with: " ").replacingOccurrences(of: "]", with: " ").replacingOccurrences(of: ":", with: " "))--\(currVideo.toneDeafAppId)")
        if newArr == nil && initialArr == nil {
            completion(nil)
            return
        }
        
        let semaphore = DispatchSemaphore(value: 0)
        let group = DispatchGroup()
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let strongSelf = self else {return}
            var count = 0
            if initialArr != nil {
                if newArr != nil {
                    for vid in initialArr! {
                        var present = false
                        for one in newArr! {
                            if one.url ==  vid.url {
                                present = true
                            }
                        }
                        if present == false {
                            //remove vid from initial arr
                            strongSelf.removeTikTok(itemToGo: vid, completion: { err in
                                if let err = err {
                                    
                                }
                            })
                        }
                    }
                } else {
                    //remove all initial arr items and break
                    for item in initialArr! {
                        strongSelf.removeTikTok(itemToGo: item, completion: { err in
                            if let err = err {
                                
                            }
                        })
                    }
                }
            }
            
            if newArr == nil {
                completion(nil)
                return
            }
            
            if newArr!.isEmpty {
                completion(nil)
                return
            }
            
            for item in newArr! {
                if count != 0 {
                    usleep(1000)
                }
                strongSelf.startTikTok(initialArr: initialArr, currentItem: item, index: count, completion: { err in
                    count+=1
                    if let err = err {
                        completion(err)
                        return
                    } else {
                        if count == newArr!.count {
                            completion(nil)
                            return
                        } else {
                            semaphore.signal()
                        }
                    }
                })
                semaphore.wait()
            }
        }
    }
    
    func startTikTok(initialArr: [TikTokData]?,currentItem: TikTokData, index:Int, completion: @escaping (([Error]?) -> Void)) {
        var errors:[Error] = []
        
        var dataUploadCompletionStatus1:Bool!
        var dataUploadCompletionStatus2:Bool!
        let queue = DispatchQueue(label: "myhjvkheditingQvideosTikTokMusicssseue")
        let group = DispatchGroup()
        var array:[Int] = [1]
        if initialArr != nil {
            var present = false
            for item in initialArr! {
                if item.url == currentItem.url {
                    present = true
                }
            }
            if present == false {
                array = [2]
            }
        } else {
            array = [2]
        }
            
        for i in array {
            group.enter()
            queue.async { [weak self] in
                guard let strongSelf = self else {return}
                switch i {
                case 1:
                    strongSelf.processTikTokStatus(ref: strongSelf.currRef, currentItem: currentItem, completion: {err in
                        if let error = err {
                            dataUploadCompletionStatus1 = false
                            errors.append(error)
                        } else {
                            dataUploadCompletionStatus1 = true
                            print("TikTok Status done \(i)")
                        }
                        group.leave()
                    })
                case 2:
                    strongSelf.processTikTokURL(ref: strongSelf.currRef, currentItem: currentItem, completion: {err in
                        if let error = err {
                            dataUploadCompletionStatus2 = false
                            errors.append(error)
                        } else {
                            dataUploadCompletionStatus2 = true
                            print("TikTok URL done \(i)")
                        }
                        group.leave()
                    })
                default:
                    print("Edit Video error")
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
    
    func processTikTokStatus(ref: DatabaseReference, currentItem: TikTokData, completion: @escaping ((Error?) -> Void)) {
        
        ref.child("Tik Tok").child("\(tikTokVideoContentTag)--\(currVideo.title.replacingOccurrences(of: ".", with: " ").replacingOccurrences(of: "#", with: " ").replacingOccurrences(of: "$", with: " ").replacingOccurrences(of: "[", with: " ").replacingOccurrences(of: "]", with: " ").replacingOccurrences(of: ":", with: " "))--\(currentItem.url.replacingOccurrences(of: "/", with: "").replacingOccurrences(of: ".", with: "").replacingOccurrences(of: "#", with: "").replacingOccurrences(of: "$", with: "").suffix(10))--\(currVideo.toneDeafAppId)").child("Active Status").setValue(currentItem.isActive, withCompletionBlock: { error, reference in
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
    
    func processTikTokURL(ref: DatabaseReference, currentItem: TikTokData, completion: @escaping ((Error?) -> Void)) {
        
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone(identifier: "EDT")
        formatter.dateFormat = "MMMM dd, yyyy"
        let currdate = formatter.string(from: Date())
        
        let timeFormatter = DateFormatter()
        timeFormatter.timeZone = TimeZone(identifier: "EDT")
        timeFormatter.dateFormat = "HH:mm:ss a"
        let currtime = timeFormatter.string(from: Date())
        
        let contentRandomKey = ("\(tikTokVideoContentTag)--\(currVideo.title.replacingOccurrences(of: ".", with: " ").replacingOccurrences(of: "#", with: " ").replacingOccurrences(of: "$", with: " ").replacingOccurrences(of: "[", with: " ").replacingOccurrences(of: "]", with: " ").replacingOccurrences(of: ":", with: " "))--\(currentItem.url.replacingOccurrences(of: "/", with: "").replacingOccurrences(of: ".", with: "").replacingOccurrences(of: "#", with: "").replacingOccurrences(of: "$", with: "").suffix(10))--\(currVideo.toneDeafAppId)")
        
        let VideoRef = Database.database().reference().child("Music Content").child("Videos").child("\(videoContentTag)--\(currVideo.title.replacingOccurrences(of: ".", with: " ").replacingOccurrences(of: "#", with: " ").replacingOccurrences(of: "$", with: " ").replacingOccurrences(of: "[", with: " ").replacingOccurrences(of: "]", with: " ").replacingOccurrences(of: ":", with: " "))--\(currVideo.toneDeafAppId)").child("Tik Tok").child(contentRandomKey)
        
        var YTInfoMap = [String : Any]()
        YTInfoMap = [
            "Time Uploaded To App" : currtime,
            "Date Uploaded To App" : currdate,
            "Video URL" : currentItem.url,
            "Active Status": currentItem.isActive]
        
        VideoRef.updateChildValues(YTInfoMap) { [weak self] (error, albumRef) in
            guard let strongSelf = self else {return}
            if let error = error {
                print("📕 Failed to store TikTok dictionary to database: \(error)")
                Utilities.showError2("Failed to Store TikTok. Please try again.", actionText: "OK")
                completion(error)
                return
            } else {
                completion(nil)
                return
            }
        }
    }
    
    func removeTikTok(itemToGo:TikTokData, completion: @escaping ((Error?) -> Void)) {
        currRef.child("Tik Tok").child("\(tikTokVideoContentTag)--\(currVideo.title.replacingOccurrences(of: ".", with: " ").replacingOccurrences(of: "#", with: " ").replacingOccurrences(of: "$", with: " ").replacingOccurrences(of: "[", with: " ").replacingOccurrences(of: "]", with: " ").replacingOccurrences(of: ":", with: " "))--\(itemToGo.url.replacingOccurrences(of: "/", with: "").replacingOccurrences(of: ".", with: "").replacingOccurrences(of: "#", with: "").replacingOccurrences(of: "$", with: "").suffix(10))--\(currVideo.toneDeafAppId)").removeValue(completionBlock: { error, reference in
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
    
    //MARK: - Verification Level
    func processVerificationLevel(initialVideo: VideoData, currentVideo: VideoData, completion: @escaping ((Error?) -> Void)) {
        initVideo = initialVideo
        currVideo = currentVideo
        let ref = Database.database().reference().child("Music Content").child("Videos").child("\(videoContentTag)--\(currVideo.title.replacingOccurrences(of: ".", with: " ").replacingOccurrences(of: "#", with: " ").replacingOccurrences(of: "$", with: " ").replacingOccurrences(of: "[", with: " ").replacingOccurrences(of: "]", with: " ").replacingOccurrences(of: ":", with: " "))--\(currVideo.toneDeafAppId)").child("Verification Level")
        ref.setValue(String(currVideo.verificationLevel!), withCompletionBlock: { error, reference in
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
    func processIndustryCertification(initialVideo: VideoData, currentVideo: VideoData, completion: @escaping ((Error?) -> Void)) {
        initVideo = initialVideo
        currVideo = currentVideo
        let ref = Database.database().reference().child("Music Content").child("Videos").child("\(videoContentTag)--\(currVideo.title.replacingOccurrences(of: ".", with: " ").replacingOccurrences(of: "#", with: " ").replacingOccurrences(of: "$", with: " ").replacingOccurrences(of: "[", with: " ").replacingOccurrences(of: "]", with: " ").replacingOccurrences(of: ":", with: " "))--\(currVideo.toneDeafAppId)").child("Industry Certified")
        ref.setValue(currVideo.industryCerified!, withCompletionBlock: { error, reference in
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
    func processStatus(initialVideo: VideoData, currentVideo: VideoData, completion: @escaping ((Error?) -> Void)) {
        initVideo = initialVideo
        currVideo = currentVideo
        let ref = Database.database().reference().child("Music Content").child("Videos").child("\(videoContentTag)--\(currVideo.title.replacingOccurrences(of: ".", with: " ").replacingOccurrences(of: "#", with: " ").replacingOccurrences(of: "$", with: " ").replacingOccurrences(of: "[", with: " ").replacingOccurrences(of: "]", with: " ").replacingOccurrences(of: ":", with: " "))--\(currVideo.toneDeafAppId)").child("Active Status")
        ref.setValue(currVideo.isActive, withCompletionBlock: { error, reference in
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
