//
//  EditPersonHelper.swift
//  ToneDeafDeafinitionsApp
//
//  Created by Tone Deaf on 6/23/22.
//  Copyright © 2022 GITEM Solutions. All rights reserved.
//

import Foundation
import FirebaseDatabase
import FirebaseStorage

class EditPersonHelper {
    static let shared = EditPersonHelper()
    
    var initPerson:PersonData! 
    var initURLDict:NSDictionary!
    var initStatusDict:NSDictionary!
    var initRef:DatabaseReference!
    var initialRoles:NSMutableDictionary!
    //Initial Images
    var initImage:UIImage!
    var initImageDBURL:String!
    
    var currPerson:PersonData!
    var currStatusDict:NSDictionary!
    var currURLDict:NSDictionary!
    var currRef:DatabaseReference!
    //Current Images
    var currImage:UIImage!
    var currImageDBURL:String!
    var currentEngRoles:NSDictionary!

    //MARK: - Image
    func processImage(initialPerson: PersonData, currentPerson: PersonData, image: UIImage?, completion: @escaping ((Error?) -> Void)) {
        initPerson = initialPerson
        currPerson = currentPerson
        currImage = image
        guard currentPerson.manualImageURL != initialPerson.manualImageURL else {
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
//                            strongSelf.removeManualImageFromStorage(completion: {err in
//                                if let error = err {
//                                    completion(error)
//                                    return
//                                }
//                                else {
//                                    completion(nil)
//                                    return
//                                }
//                            })
                            Database.database().reference().child("Registered Persons").child("\(strongSelf.currPerson.name!)--\(strongSelf.currPerson.dateRegisteredToApp!)--\(strongSelf.currPerson.timeRegisteredToApp!)--\(strongSelf.currPerson.toneDeafAppId)").child("Manual Image URL").removeValue()
                            completion(nil)
                            return
                        }
                        
                        strongSelf.storeImage(person: strongSelf.currPerson, image: strongSelf.currImage, imageURL: "curr", completion: { err in
                            if let error = err {
                                completion(error)
                                return
                            } else {
                                var array:String!
                                
                                array = strongSelf.currImageDBURL
                                Database.database().reference().child("Registered Persons").child("\(strongSelf.currPerson.name!)--\(strongSelf.currPerson.dateRegisteredToApp!)--\(strongSelf.currPerson.timeRegisteredToApp!)--\(strongSelf.currPerson.toneDeafAppId)").child("Manual Image URL").setValue(array)
                                completion(nil)
                            }
                        })
                    }
                })
            }
        })
    }
    
    fileprivate func getDBURLs(completion: @escaping ((Error?) -> Void)) {
        Database.database().reference().child("Registered Persons").child("\(currPerson.name!)--\(currPerson.dateRegisteredToApp!)--\(currPerson.timeRegisteredToApp!)--\(currPerson.toneDeafAppId)").child("Manual Image URL").observeSingleEvent(of: .value, with: {[weak self] snap in
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
        Storage.storage().reference().child("Image Defaults").child("Manual Persons").child("\(currPerson.toneDeafAppId)").child("Images").listAll(completion: {[weak self] listResult, err in
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
                                completion(PersonEditorError.imageUpdateError("Storage download url error"))
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
        Storage.storage().reference().child("Image Defaults").child("Manual Persons").child("\(currPerson.toneDeafAppId)").child("Images").listAll(completion: {[weak self] listResult, err in
            guard let strongSelf = self else {return}
            
            if let error = err {
                completion(error)
                return
            } else {
                guard let listResult = listResult else {
                    return
                }
                print(listResult.items)
                
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
                                Database.database().reference().child("Registered Persons").child("\(strongSelf.currPerson.name!)--\(strongSelf.currPerson.dateRegisteredToApp!)--\(strongSelf.currPerson.timeRegisteredToApp!)--\(strongSelf.currPerson.toneDeafAppId)").child("Manual Image URL").removeValue()
                                completion(nil)
                                return
                            }
                        }
                        
                    })
                }
            }
        })
    }
    
    fileprivate func storeImage(person: PersonData, image:UIImage, imageURL:String, completion: @escaping ((Error?) -> Void)) {
        
        guard let data = image.pngData() else {
            completion(PersonEditorError.imageUpdateError("Error converting image to png"))
            return}
        StorageManager.shared.uploadImage(person: data, fileName: "\(currPerson.toneDeafAppId)", completion: {[weak self] result in
            
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
    func processName(initialPerson: PersonData, currentPerson: PersonData, completion: @escaping (([Error]?) -> Void)) {
        initPerson = initialPerson
        currPerson = currentPerson
        
        initRef = Database.database().reference().child("Registered Persons").child("\(initPerson.name!)--\(initPerson.dateRegisteredToApp!)--\(initPerson.timeRegisteredToApp!)--\(initPerson.toneDeafAppId)")
        currRef = Database.database().reference().child("Registered Persons").child("\(currPerson.name!)--\(currPerson.dateRegisteredToApp!)--\(currPerson.timeRegisteredToApp!)--\(currPerson.toneDeafAppId)")
        
        var errors:[Error] = []
        var dataUploadCompletionStatus1:Bool!
        let queue = DispatchQueue(label: "myhjvkheditingQpersonsNameChangessseue")
        let group = DispatchGroup()
        let array:[Int] = [1]
        for i in array {
            group.enter()
            queue.async { [weak self] in
                guard let strongSelf = self else {return}
                switch i {
                case 1:
                    strongSelf.setNewKeyForPersonInDB(initref: strongSelf.initRef, newref: strongSelf.currRef, completion: {err in
                        if let error = err {
                            dataUploadCompletionStatus1 = false
                            errors.append(error)
                        } else {
                            dataUploadCompletionStatus1 = true
                            print("Person name Update done \(i)")
                        }
                        group.leave()
                    })
                default:
                    print("Edit Person error")
                }
            }
        }
        
        group.notify(queue: DispatchQueue.main) {
            if dataUploadCompletionStatus1 == false {
                completion(errors)
                return
            } else {
                completion(nil)
            }
        }
        
    }
    
    func setNewKeyForPersonInDB(initref: DatabaseReference, newref: DatabaseReference, completion: @escaping ((Error?) -> Void)) {
        initref.observeSingleEvent(of: .value, with: {[weak self] result in
            guard let strongSelf = self else {return}
            newref.setValue(result.value, withCompletionBlock: { error, reference in
                if let error = error {
                    completion(error)
                    return
                }
                else {
                    initref.removeValue()
                    strongSelf.updatePersonName(newref: newref, completion: { error in
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
    
    func updatePersonName(newref: DatabaseReference, completion: @escaping ((Error?) -> Void)) {
        newref.child("Name").setValue(currPerson.name, withCompletionBlock: { error, reference in
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
    
    //MARK: - Alternate Names
    func processAlternateNames(initialPerson: PersonData, currentPerson: PersonData, completion: @escaping ((Error?) -> Void)) {
        initPerson = initialPerson
        currPerson = currentPerson
        let ref = Database.database().reference().child("Registered Persons").child("\(currPerson.name!)--\(currPerson.dateRegisteredToApp!)--\(currPerson.timeRegisteredToApp!)--\(currPerson.toneDeafAppId)").child("Alternate Names")
        ref.setValue(currPerson.alternateNames, withCompletionBlock: { error, reference in
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
    
    //MARK: - Legal Name
    func processLegalName(initialPerson: PersonData, currentPerson: PersonData, completion: @escaping ((Error?) -> Void)) {
        initPerson = initialPerson
        currPerson = currentPerson
        let ref = Database.database().reference().child("Registered Persons").child("\(currPerson.name!)--\(currPerson.dateRegisteredToApp!)--\(currPerson.timeRegisteredToApp!)--\(currPerson.toneDeafAppId)").child("Legal Name")
        ref.setValue(currPerson.legalName, withCompletionBlock: { error, reference in
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
    
    //MARK: - Main Role
    func processMainRole(initialPerson: PersonData, currentPerson: PersonData, completion: @escaping ((Error?) -> Void)) {
        initPerson = initialPerson
        currPerson = currentPerson
        let ref = Database.database().reference().child("Registered Persons").child("\(currPerson.name!)--\(currPerson.dateRegisteredToApp!)--\(currPerson.timeRegisteredToApp!)--\(currPerson.toneDeafAppId)").child("Main Role")
        ref.setValue(currPerson.mainRole, withCompletionBlock: { error, reference in
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
    
    //MARK: - Spotify
    func processSpotify(initialPerson: PersonData, currentPerson: PersonData, initialStatus:Bool?, currentStatus:Bool?, initialURL:String?, currentURL:String?, completion: @escaping (([Error]?) -> Void)) {
        initPerson = initialPerson
        currPerson = currentPerson
        var errors:[Error] = []
        initRef = Database.database().reference().child("Registered Persons").child("\(initPerson.name!)--\(initPerson.dateRegisteredToApp!)--\(initPerson.timeRegisteredToApp!)--\(initPerson.toneDeafAppId)").child("Spotify")
        currRef = Database.database().reference().child("Registered Persons").child("\(currPerson.name!)--\(currPerson.dateRegisteredToApp!)--\(currPerson.timeRegisteredToApp!)--\(currPerson.toneDeafAppId)").child("Spotify")
        
        var dataUploadCompletionStatus1:Bool!
        var dataUploadCompletionStatus2:Bool!
        let queue = DispatchQueue(label: "myhjvkheditingQpersonsSpotifyssseue")
        let group = DispatchGroup()
        var array:[Int] = []
        
        if currPerson.spotify == nil {
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
                    print("Edit Person error")
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
        ref.child("Active Status").setValue(currentStatus, withCompletionBlock: { error, reference in
            if let error = error {
                completion(PersonEditorError.spotifyUpdateError(error.localizedDescription))
                return
            }
            else {
                completion(nil)
                return
            }
        })
    }
    
    func processSpotifyURL(ref: DatabaseReference, currentStatus: Bool?, currentURL: String?, completion: @escaping ((Error?) -> Void)) {
        var spotUrl = currentURL!
        if let dotRange = spotUrl.range(of: "?") {
            spotUrl.removeSubrange(dotRange.lowerBound..<spotUrl.endIndex)
        }
        let songId = String(spotUrl.suffix(22))
        let token = (UserDefaults.standard.object(forKey: "SPTaccesstoken") as? String)!
        SpotifyRequest.shared.getArtistInfo(accessToken: token, id: songId, person: currPerson, completion: {[weak self] result in
            guard let strongSelf = self else {return}
            switch result {
            case .success(let data):
                let newDict:NSDictionary = [
                    "id": songId,
                    "Profile Image URL": data.profileImageURL!,
                    "URL": data.url!,
                    "Active Status": currentStatus!
                ]
                
                ref.setValue(newDict, withCompletionBlock: { error, reference in
                    if let error = error {
                        completion(PersonEditorError.spotifyUpdateError(error.localizedDescription))
                        return
                    }
                    else {
                        completion(nil)
                        return
                    }
                })
            case .failure(let err):
                completion(PersonEditorError.spotifyUpdateError(err.localizedDescription))
            }
        })
        
        
    }
    
    func removeSpotify(ref: DatabaseReference, completion: @escaping ((Error?) -> Void)) {
        ref.removeValue(completionBlock: { error, reference in
            if let error = error {
                completion(PersonEditorError.spotifyUpdateError(error.localizedDescription))
                return
            }
            else {
                completion(nil)
                return
            }
        })
    }
    
    //MARK: - Apple Music
    func processAppleMusic(initialPerson: PersonData, currentPerson: PersonData, initialStatus:Bool?, currentStatus:Bool?, initialURL:String?, currentURL:String?, completion: @escaping (([Error]?) -> Void)) {
        initPerson = initialPerson
        currPerson = currentPerson
        var errors:[Error] = []
        initRef = Database.database().reference().child("Registered Persons").child("\(initPerson.name!)--\(initPerson.dateRegisteredToApp!)--\(initPerson.timeRegisteredToApp!)--\(initPerson.toneDeafAppId)").child("Apple Music")
        currRef = Database.database().reference().child("Registered Persons").child("\(currPerson.name!)--\(currPerson.dateRegisteredToApp!)--\(currPerson.timeRegisteredToApp!)--\(currPerson.toneDeafAppId)").child("Apple Music")
        
        var dataUploadCompletionStatus1:Bool!
        var dataUploadCompletionStatus2:Bool!
        let queue = DispatchQueue(label: "myhjvkheditingQpersonsAppleMusicssseue")
        let group = DispatchGroup()
        var array:[Int] = []
        
        if currPerson.apple == nil {
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
                    print("Edit Person error")
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
        ref.child("Active Status").setValue(currentStatus, withCompletionBlock: { error, reference in
            if let error = error {
                completion(PersonEditorError.appleUpdateError(error.localizedDescription))
                return
            }
            else {
                completion(nil)
                return
            }
        })
    }
    
    func processAppleMusicURL(ref: DatabaseReference, currentStatus: Bool?, currentURL: String?, completion: @escaping ((Error?) -> Void)) {
        let artistId = String((currentURL!.suffix(10)))
        AppleMusicRequest.shared.getAppleMusicArtist(id: artistId, person: currPerson, completion: {[weak self] result in
            guard let strongSelf = self else {return}
            switch result {
            case .success(let data):
                let newDict:NSDictionary = [
                    "URL": data.url!,
                    "All Album IDs" : data.allAlbumIDs,
                    "id" : data.id!,
                    "Active Status": currentStatus!
                ]
                
                ref.setValue(newDict, withCompletionBlock: { error, reference in
                    if let error = error {
                        completion(PersonEditorError.appleUpdateError(error.localizedDescription))
                        return
                    }
                    else {
                        completion(nil)
                        return
                    }
                })
            case .failure(let err):
                completion(PersonEditorError.appleUpdateError(err.localizedDescription))
            }
        })
        
        
    }
    
    func removeAppleMusic(ref: DatabaseReference, completion: @escaping ((Error?) -> Void)) {
        ref.removeValue(completionBlock: { error, reference in
            if let error = error {
                completion(PersonEditorError.appleUpdateError(error.localizedDescription))
                return
            }
            else {
                completion(nil)
                return
            }
        })
    }
    
    //MARK: - Youtube
    func processYoutube(initialPerson: PersonData, currentPerson: PersonData, initialStatus:Bool?, currentStatus:Bool?, initialURL:String?, currentURL:String?, completion: @escaping (([Error]?) -> Void)) {
        initPerson = initialPerson
        currPerson = currentPerson
        var errors:[Error] = []
        initRef = Database.database().reference().child("Registered Persons").child("\(initPerson.name!)--\(initPerson.dateRegisteredToApp!)--\(initPerson.timeRegisteredToApp!)--\(initPerson.toneDeafAppId)").child("Youtube")
        currRef = Database.database().reference().child("Registered Persons").child("\(currPerson.name!)--\(currPerson.dateRegisteredToApp!)--\(currPerson.timeRegisteredToApp!)--\(currPerson.toneDeafAppId)").child("Youtube")
        
        var dataUploadCompletionStatus1:Bool!
        var dataUploadCompletionStatus2:Bool!
        let queue = DispatchQueue(label: "myhjvkheditingQpersonsYoutubessseue")
        let group = DispatchGroup()
        var array:[Int] = []
        if currPerson.youtube == nil {
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
                    strongSelf.processYoutubeStatus(ref: strongSelf.currRef, currentStatus: currentStatus, completion: {err in
                        if let error = err {
                            dataUploadCompletionStatus1 = false
                            errors.append(error)
                        } else {
                            dataUploadCompletionStatus1 = true
                            print("Youtube URL done \(i)")
                        }
                        group.leave()
                    })
                case 2:
                    strongSelf.processYoutubeURL(ref: strongSelf.currRef, currentStatus: currentStatus, currentURL: currentURL, completion: {err in
                        if let error = err {
                            dataUploadCompletionStatus2 = false
                            errors.append(error)
                        } else {
                            dataUploadCompletionStatus2 = true
                            print("Youtube URL done \(i)")
                        }
                        group.leave()
                    })
                case 3:
                    strongSelf.removeYoutube(ref: strongSelf.currRef ,completion: {err in
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
                    print("Edit Person error")
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
    
    func processYoutubeStatus(ref: DatabaseReference, currentStatus: Bool?, completion: @escaping ((Error?) -> Void)) {
        ref.child("Active Status").setValue(currentStatus, withCompletionBlock: { error, reference in
            if let error = error {
                completion(PersonEditorError.youtubeUpdateError(error.localizedDescription))
                return
            }
            else {
                completion(nil)
                return
            }
        })
    }
    
    func processYoutubeURL(ref: DatabaseReference, currentStatus: Bool?, currentURL: String?, completion: @escaping ((Error?) -> Void)) {
                let newDict:NSDictionary = [
                    "URL": currentURL!,
                    "Active Status": currentStatus!
                ]
                
                ref.setValue(newDict, withCompletionBlock: { error, reference in
                    if let error = error {
                        completion(PersonEditorError.youtubeUpdateError(error.localizedDescription))
                        return
                    }
                    else {
                        completion(nil)
                        return
                    }
                })
        
        
    }
    
    func removeYoutube(ref: DatabaseReference, completion: @escaping ((Error?) -> Void)) {
        ref.removeValue(completionBlock: { error, reference in
            if let error = error {
                completion(PersonEditorError.youtubeUpdateError(error.localizedDescription))
                return
            }
            else {
                completion(nil)
                return
            }
        })
    }
    
    //MARK: - Soundcloud
    func processSoundcloud(initialPerson: PersonData, currentPerson: PersonData, initialStatus:Bool?, currentStatus:Bool?, initialURL:String?, currentURL:String?, completion: @escaping (([Error]?) -> Void)) {
        initPerson = initialPerson
        currPerson = currentPerson
        var errors:[Error] = []
        initRef = Database.database().reference().child("Registered Persons").child("\(initPerson.name!)--\(initPerson.dateRegisteredToApp!)--\(initPerson.timeRegisteredToApp!)--\(initPerson.toneDeafAppId)").child("Soundcloud")
        currRef = Database.database().reference().child("Registered Persons").child("\(currPerson.name!)--\(currPerson.dateRegisteredToApp!)--\(currPerson.timeRegisteredToApp!)--\(currPerson.toneDeafAppId)").child("Soundcloud")
        
        var dataUploadCompletionStatus1:Bool!
        var dataUploadCompletionStatus2:Bool!
        let queue = DispatchQueue(label: "myhjvkheditingQpersonsSoundcloudssseue")
        let group = DispatchGroup()
        var array:[Int] = []
        if currPerson.soundcloud == nil {
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
                    print("Edit Person error")
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
        ref.child("Active Status").setValue(currentStatus, withCompletionBlock: { error, reference in
            if let error = error {
                completion(PersonEditorError.soundcloudUpdateError(error.localizedDescription))
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
                    "URL": currentURL!,
                    "Active Status": currentStatus!
                ]
                
                ref.setValue(newDict, withCompletionBlock: { error, reference in
                    if let error = error {
                        completion(PersonEditorError.soundcloudUpdateError(error.localizedDescription))
                        return
                    }
                    else {
                        completion(nil)
                        return
                    }
                })
        
        
    }
    
    func removeSoundcloud(ref: DatabaseReference, completion: @escaping ((Error?) -> Void)) {
        ref.removeValue(completionBlock: { error, reference in
            if let error = error {
                completion(PersonEditorError.soundcloudUpdateError(error.localizedDescription))
                return
            }
            else {
                completion(nil)
                return
            }
        })
    }
    
    //MARK: - Youtube Music
    func processYoutubeMusic(initialPerson: PersonData, currentPerson: PersonData, initialStatus:Bool?, currentStatus:Bool?, initialURL:String?, currentURL:String?, completion: @escaping (([Error]?) -> Void)) {
        initPerson = initialPerson
        currPerson = currentPerson
        var errors:[Error] = []
        initRef = Database.database().reference().child("Registered Persons").child("\(initPerson.name!)--\(initPerson.dateRegisteredToApp!)--\(initPerson.timeRegisteredToApp!)--\(initPerson.toneDeafAppId)").child("Youtube Music")
        currRef = Database.database().reference().child("Registered Persons").child("\(currPerson.name!)--\(currPerson.dateRegisteredToApp!)--\(currPerson.timeRegisteredToApp!)--\(currPerson.toneDeafAppId)").child("Youtube Music")
        
        var dataUploadCompletionStatus1:Bool!
        var dataUploadCompletionStatus2:Bool!
        let queue = DispatchQueue(label: "myhjvkheditingQpersonsYoutubeMusicssseue")
        let group = DispatchGroup()
        var array:[Int] = []
        if currPerson.youtubeMusic == nil {
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
                    print("Edit Person error")
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
        ref.child("Active Status").setValue(currentStatus, withCompletionBlock: { error, reference in
            if let error = error {
                completion(PersonEditorError.youtubeMusicUpdateError(error.localizedDescription))
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
                    "URL": currentURL!,
                    "Active Status": currentStatus!
                ]
                
                ref.setValue(newDict, withCompletionBlock: { error, reference in
                    if let error = error {
                        completion(PersonEditorError.youtubeMusicUpdateError(error.localizedDescription))
                        return
                    }
                    else {
                        completion(nil)
                        return
                    }
                })
        
        
    }
    
    func removeYoutubeMusic(ref: DatabaseReference, completion: @escaping ((Error?) -> Void)) {
        ref.removeValue(completionBlock: { error, reference in
            if let error = error {
                completion(PersonEditorError.youtubeMusicUpdateError(error.localizedDescription))
                return
            }
            else {
                completion(nil)
                return
            }
        })
    }
    
    //MARK: - Amazon
    func processAmazon(initialPerson: PersonData, currentPerson: PersonData, initialStatus:Bool?, currentStatus:Bool?, initialURL:String?, currentURL:String?, completion: @escaping (([Error]?) -> Void)) {
        initPerson = initialPerson
        currPerson = currentPerson
        var errors:[Error] = []
        initRef = Database.database().reference().child("Registered Persons").child("\(initPerson.name!)--\(initPerson.dateRegisteredToApp!)--\(initPerson.timeRegisteredToApp!)--\(initPerson.toneDeafAppId)").child("Amazon Music")
        currRef = Database.database().reference().child("Registered Persons").child("\(currPerson.name!)--\(currPerson.dateRegisteredToApp!)--\(currPerson.timeRegisteredToApp!)--\(currPerson.toneDeafAppId)").child("Amazon Music")
        
        var dataUploadCompletionStatus1:Bool!
        var dataUploadCompletionStatus2:Bool!
        let queue = DispatchQueue(label: "myhjvkheditingQpersonsAmazonssseue")
        let group = DispatchGroup()
        var array:[Int] = []
        if currPerson.amazon == nil {
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
                    print("Edit Person error")
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
        ref.child("Active Status").setValue(currentStatus, withCompletionBlock: { error, reference in
            if let error = error {
                completion(PersonEditorError.amazonUpdateError(error.localizedDescription))
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
                    "URL": currentURL!,
                    "Active Status": currentStatus!
                ]
                
                ref.setValue(newDict, withCompletionBlock: { error, reference in
                    if let error = error {
                        completion(PersonEditorError.amazonUpdateError(error.localizedDescription))
                        return
                    }
                    else {
                        completion(nil)
                        return
                    }
                })
        
        
    }
    
    func removeAmazon(ref: DatabaseReference, completion: @escaping ((Error?) -> Void)) {
        ref.removeValue(completionBlock: { error, reference in
            if let error = error {
                completion(PersonEditorError.amazonUpdateError(error.localizedDescription))
                return
            }
            else {
                completion(nil)
                return
            }
        })
    }
    
    //MARK: - Deezer
    func processDeezer(initialPerson: PersonData, currentPerson: PersonData, initialStatus:Bool?, currentStatus:Bool?, initialURL:String?, currentURL:String?, completion: @escaping (([Error]?) -> Void)) {
        initPerson = initialPerson
        currPerson = currentPerson
        var errors:[Error] = []
        initRef = Database.database().reference().child("Registered Persons").child("\(initPerson.name!)--\(initPerson.dateRegisteredToApp!)--\(initPerson.timeRegisteredToApp!)--\(initPerson.toneDeafAppId)").child("Deezer")
        currRef = Database.database().reference().child("Registered Persons").child("\(currPerson.name!)--\(currPerson.dateRegisteredToApp!)--\(currPerson.timeRegisteredToApp!)--\(currPerson.toneDeafAppId)").child("Deezer")
        
        var dataUploadCompletionStatus1:Bool!
        var dataUploadCompletionStatus2:Bool!
        let queue = DispatchQueue(label: "myhjvkheditingQpersonsDeezerssseue")
        let group = DispatchGroup()
        var array:[Int] = []
        if currPerson.deezer == nil {
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
                    print("Edit Person error")
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
        ref.child("Active Status").setValue(currentStatus, withCompletionBlock: { error, reference in
            if let error = error {
                completion(PersonEditorError.deezerUpdateError(error.localizedDescription))
                return
            }
            else {
                completion(nil)
                return
            }
        })
    }
    
    func processDeezerURL(ref: DatabaseReference, currentStatus: Bool?, currentURL: String?, completion: @escaping ((Error?) -> Void)) {
        var url = currentURL!
        var videoId = ""
        
        if !url.contains("artist/") && !url.contains("deezer.com/") {
            mediumImpactGenerator.impactOccurred()
            Utilities.showError2("Deezer url Invalid error", actionText: "OK")
            return
        }
        if let dotRange = url.range(of: "?") {
            url.removeSubrange(dotRange.lowerBound..<url.endIndex)
        }
        if let range = url.range(of: "artist/") {
            url.removeSubrange(url.startIndex..<range.lowerBound)
        }
        videoId = String(url.dropFirst(6))
         
        DeezerRequest.shared.getDeezerPerson(id: videoId, completion: { result in
            switch result {
            case .success(let data):
                let newDict:NSDictionary = [
                    "id": data.id,
                    "Name": data.name,
                    "Profile Image URL": data.profileImageURL,
                    "URL": data.url,
                    "Active Status": currentStatus!
                ]
                
                ref.setValue(newDict, withCompletionBlock: { error, reference in
                    if let error = error {
                        completion(PersonEditorError.twitterUpdateError(error.localizedDescription))
                        return
                    }
                    else {
                        completion(nil)
                        return
                    }
                })
            case .failure(let err):
                completion(PersonEditorError.twitterUpdateError(err.localizedDescription))
            }
        })
        
    }
    
    func removeDeezer(ref: DatabaseReference, completion: @escaping ((Error?) -> Void)) {
        ref.removeValue(completionBlock: { error, reference in
            if let error = error {
                completion(PersonEditorError.deezerUpdateError(error.localizedDescription))
                return
            }
            else {
                completion(nil)
                return
            }
        })
    }
    
    //MARK: - Tidal
    func processTidal(initialPerson: PersonData, currentPerson: PersonData, initialStatus:Bool?, currentStatus:Bool?, initialURL:String?, currentURL:String?, completion: @escaping (([Error]?) -> Void)) {
        initPerson = initialPerson
        currPerson = currentPerson
        var errors:[Error] = []
        initRef = Database.database().reference().child("Registered Persons").child("\(initPerson.name!)--\(initPerson.dateRegisteredToApp!)--\(initPerson.timeRegisteredToApp!)--\(initPerson.toneDeafAppId)").child("Tidal")
        currRef = Database.database().reference().child("Registered Persons").child("\(currPerson.name!)--\(currPerson.dateRegisteredToApp!)--\(currPerson.timeRegisteredToApp!)--\(currPerson.toneDeafAppId)").child("Tidal")
        
        var dataUploadCompletionStatus1:Bool!
        var dataUploadCompletionStatus2:Bool!
        let queue = DispatchQueue(label: "myhjvkheditingQpersonsTidalssseue")
        let group = DispatchGroup()
        var array:[Int] = []
        if currPerson.tidal == nil {
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
                    print("Edit Person error")
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
        ref.child("Active Status").setValue(currentStatus, withCompletionBlock: { error, reference in
            if let error = error {
                completion(PersonEditorError.tidalUpdateError(error.localizedDescription))
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
                    "URL": currentURL!,
                    "Active Status": currentStatus!
                ]
                
                ref.setValue(newDict, withCompletionBlock: { error, reference in
                    if let error = error {
                        completion(PersonEditorError.tidalUpdateError(error.localizedDescription))
                        return
                    }
                    else {
                        completion(nil)
                        return
                    }
                })
        
        
    }
    
    func removeTidal(ref: DatabaseReference, completion: @escaping ((Error?) -> Void)) {
        ref.removeValue(completionBlock: { error, reference in
            if let error = error {
                completion(PersonEditorError.tidalUpdateError(error.localizedDescription))
                return
            }
            else {
                completion(nil)
                return
            }
        })
    }
    
    //MARK: - Napster
    func processNapster(initialPerson: PersonData, currentPerson: PersonData, initialStatus:Bool?, currentStatus:Bool?, initialURL:String?, currentURL:String?, completion: @escaping (([Error]?) -> Void)) {
        initPerson = initialPerson
        currPerson = currentPerson
        var errors:[Error] = []
        initRef = Database.database().reference().child("Registered Persons").child("\(initPerson.name!)--\(initPerson.dateRegisteredToApp!)--\(initPerson.timeRegisteredToApp!)--\(initPerson.toneDeafAppId)").child("Napster")
        currRef = Database.database().reference().child("Registered Persons").child("\(currPerson.name!)--\(currPerson.dateRegisteredToApp!)--\(currPerson.timeRegisteredToApp!)--\(currPerson.toneDeafAppId)").child("Napster")
        
        var dataUploadCompletionStatus1:Bool!
        var dataUploadCompletionStatus2:Bool!
        let queue = DispatchQueue(label: "myhjvkheditingQpersonsNapsterssseue")
        let group = DispatchGroup()
        var array:[Int] = []
        if currPerson.napster == nil {
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
                    print("Edit Person error")
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
        ref.child("Active Status").setValue(currentStatus, withCompletionBlock: { error, reference in
            if let error = error {
                completion(PersonEditorError.napsterUpdateError(error.localizedDescription))
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
                    "URL": currentURL!,
                    "Active Status": currentStatus!
                ]
                
                ref.setValue(newDict, withCompletionBlock: { error, reference in
                    if let error = error {
                        completion(PersonEditorError.napsterUpdateError(error.localizedDescription))
                        return
                    }
                    else {
                        completion(nil)
                        return
                    }
                })
        
        
    }
    
    func removeNapster(ref: DatabaseReference, completion: @escaping ((Error?) -> Void)) {
        ref.removeValue(completionBlock: { error, reference in
            if let error = error {
                completion(PersonEditorError.napsterUpdateError(error.localizedDescription))
                return
            }
            else {
                completion(nil)
                return
            }
        })
    }
    
    //MARK: - Spinrilla
    func processSpinrilla(initialPerson: PersonData, currentPerson: PersonData, initialStatus:Bool?, currentStatus:Bool?, initialURL:String?, currentURL:String?, completion: @escaping (([Error]?) -> Void)) {
        initPerson = initialPerson
        currPerson = currentPerson
        var errors:[Error] = []
        initRef = Database.database().reference().child("Registered Persons").child("\(initPerson.name!)--\(initPerson.dateRegisteredToApp!)--\(initPerson.timeRegisteredToApp!)--\(initPerson.toneDeafAppId)").child("Spinrilla")
        currRef = Database.database().reference().child("Registered Persons").child("\(currPerson.name!)--\(currPerson.dateRegisteredToApp!)--\(currPerson.timeRegisteredToApp!)--\(currPerson.toneDeafAppId)").child("Spinrilla")
        
        var dataUploadCompletionStatus1:Bool!
        var dataUploadCompletionStatus2:Bool!
        let queue = DispatchQueue(label: "myhjvkheditingQpersonsSpinrillassseue")
        let group = DispatchGroup()
        var array:[Int] = []
        if currPerson.spinrilla == nil {
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
                    print("Edit Person error")
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
        ref.child("Active Status").setValue(currentStatus, withCompletionBlock: { error, reference in
            if let error = error {
                completion(PersonEditorError.spinrillaUpdateError(error.localizedDescription))
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
                    "URL": currentURL!,
                    "Active Status": currentStatus!
                ]
                
                ref.setValue(newDict, withCompletionBlock: { error, reference in
                    if let error = error {
                        completion(PersonEditorError.spinrillaUpdateError(error.localizedDescription))
                        return
                    }
                    else {
                        completion(nil)
                        return
                    }
                })
        
        
    }
    
    func removeSpinrilla(ref: DatabaseReference, completion: @escaping ((Error?) -> Void)) {
        ref.removeValue(completionBlock: { error, reference in
            if let error = error {
                completion(PersonEditorError.spinrillaUpdateError(error.localizedDescription))
                return
            }
            else {
                completion(nil)
                return
            }
        })
    }
    
    //MARK: - Twitter
    func processTwitter(initialPerson: PersonData, currentPerson: PersonData, initialStatus:Bool?, currentStatus:Bool?, initialURL:String?, currentURL:String?, completion: @escaping (([Error]?) -> Void)) {
        initPerson = initialPerson
        currPerson = currentPerson
        var errors:[Error] = []
        initRef = Database.database().reference().child("Registered Persons").child("\(initPerson.name!)--\(initPerson.dateRegisteredToApp!)--\(initPerson.timeRegisteredToApp!)--\(initPerson.toneDeafAppId)").child("Twitter")
        currRef = Database.database().reference().child("Registered Persons").child("\(currPerson.name!)--\(currPerson.dateRegisteredToApp!)--\(currPerson.timeRegisteredToApp!)--\(currPerson.toneDeafAppId)").child("Twitter")
        
        var dataUploadCompletionStatus1:Bool!
        var dataUploadCompletionStatus2:Bool!
        let queue = DispatchQueue(label: "myhjvkheditingQpersonsTwitterssseue")
        let group = DispatchGroup()
        var array:[Int] = []
        
        if currPerson.twitter == nil {
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
                    strongSelf.processTwitterStatus(ref: strongSelf.currRef, currentStatus: currentStatus, completion: {err in
                        if let error = err {
                            dataUploadCompletionStatus1 = false
                            errors.append(error)
                        } else {
                            dataUploadCompletionStatus1 = true
                            print("Twitter URL done \(i)")
                        }
                        group.leave()
                    })
                case 2:
                    strongSelf.processTwitterURL(ref: strongSelf.currRef, currentStatus: currentStatus, currentURL: currentURL, completion: {err in
                        if let error = err {
                            dataUploadCompletionStatus2 = false
                            errors.append(error)
                        } else {
                            dataUploadCompletionStatus2 = true
                            print("Twitter URL done \(i)")
                        }
                        group.leave()
                    })
                case 3:
                    strongSelf.removeTwitter(ref: strongSelf.currRef ,completion: {err in
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
                    print("Edit Person error")
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
    
    func processTwitterStatus(ref: DatabaseReference, currentStatus: Bool?, completion: @escaping ((Error?) -> Void)) {
        ref.child("Active Status").setValue(currentStatus, withCompletionBlock: { error, reference in
            if let error = error {
                completion(PersonEditorError.twitterUpdateError(error.localizedDescription))
                return
            }
            else {
                completion(nil)
                return
            }
        })
    }
    
    func processTwitterURL(ref: DatabaseReference, currentStatus: Bool?, currentURL: String?, completion: @escaping ((Error?) -> Void)) {
        var url = currentURL!
        var videoId = ""
        
        if !url.contains("twitter.com/") {
            mediumImpactGenerator.impactOccurred()
            Utilities.showError2("Twitter url Invalid error", actionText: "OK")
            return
        }
        if let dotRange = url.range(of: "?s=") {
            url.removeSubrange(dotRange.lowerBound..<url.endIndex)
        }
        if let range = url.range(of: "twitter.com/") {
            url.removeSubrange(url.startIndex..<range.lowerBound)
        }
        
        let split = String(url.dropFirst(12))
        videoId = String(split)
         
        TwitterRequest.shared.getPerson(username: videoId, completion: { result in
            switch result {
            case .success(let data):
                let newDict:NSDictionary = [
                    "id": data.twitterId,
                    "Date Created": data.dateCreated,
                    "Name": data.name,
                    "Username": data.userName,
                    "Profile Image URL": data.profileImageURL,
                    "URL": data.url,
                    "Active Status": currentStatus!
                ]
                
                ref.setValue(newDict, withCompletionBlock: { error, reference in
                    if let error = error {
                        completion(PersonEditorError.twitterUpdateError(error.localizedDescription))
                        return
                    }
                    else {
                        completion(nil)
                        return
                    }
                })
            case .failure(let err):
                completion(PersonEditorError.twitterUpdateError(err.localizedDescription))
            }
        })
        
        
    }
    
    func removeTwitter(ref: DatabaseReference, completion: @escaping ((Error?) -> Void)) {
        ref.removeValue(completionBlock: { error, reference in
            if let error = error {
                completion(PersonEditorError.twitterUpdateError(error.localizedDescription))
                return
            }
            else {
                completion(nil)
                return
            }
        })
    }
    
    //MARK: - Instagram
    func processInstagram(initialPerson: PersonData, currentPerson: PersonData, initialStatus:Bool?, currentStatus:Bool?, initialURL:String?, currentURL:String?, completion: @escaping (([Error]?) -> Void)) {
        initPerson = initialPerson
        currPerson = currentPerson
        var errors:[Error] = []
        initRef = Database.database().reference().child("Registered Persons").child("\(initPerson.name!)--\(initPerson.dateRegisteredToApp!)--\(initPerson.timeRegisteredToApp!)--\(initPerson.toneDeafAppId)").child("Instagram")
        currRef = Database.database().reference().child("Registered Persons").child("\(currPerson.name!)--\(currPerson.dateRegisteredToApp!)--\(currPerson.timeRegisteredToApp!)--\(currPerson.toneDeafAppId)").child("Instagram")
        
        var dataUploadCompletionStatus1:Bool!
        var dataUploadCompletionStatus2:Bool!
        let queue = DispatchQueue(label: "myhjvkheditingQpersonsInstagramssseue")
        let group = DispatchGroup()
        var array:[Int] = []
        if currPerson.instagram == nil {
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
                    strongSelf.processInstagramStatus(ref: strongSelf.currRef, currentStatus: currentStatus, completion: {err in
                        if let error = err {
                            dataUploadCompletionStatus1 = false
                            errors.append(error)
                        } else {
                            dataUploadCompletionStatus1 = true
                            print("Instagram URL done \(i)")
                        }
                        group.leave()
                    })
                case 2:
                    strongSelf.processInstagramURL(ref: strongSelf.currRef, currentStatus: currentStatus, currentURL: currentURL, completion: {err in
                        if let error = err {
                            dataUploadCompletionStatus2 = false
                            errors.append(error)
                        } else {
                            dataUploadCompletionStatus2 = true
                            print("Instagram URL done \(i)")
                        }
                        group.leave()
                    })
                case 3:
                    strongSelf.removeInstagram(ref: strongSelf.currRef ,completion: {err in
                        if let error = err {
                            dataUploadCompletionStatus2 = false
                            errors.append(error)
                        } else {
                            dataUploadCompletionStatus2 = true
                            print("Instagram URL done \(i)")
                        }
                        group.leave()
                    })
                default:
                    print("Edit Person error")
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
    
    func processInstagramStatus(ref: DatabaseReference, currentStatus: Bool?, completion: @escaping ((Error?) -> Void)) {
        ref.child("Active Status").setValue(currentStatus, withCompletionBlock: { error, reference in
            if let error = error {
                completion(PersonEditorError.instagramUpdateError(error.localizedDescription))
                return
            }
            else {
                completion(nil)
                return
            }
        })
    }
    
    func processInstagramURL(ref: DatabaseReference, currentStatus: Bool?, currentURL: String?, completion: @escaping ((Error?) -> Void)) {
                let newDict:NSDictionary = [
                    "URL": currentURL!,
                    "Active Status": currentStatus!
                ]
                
                ref.setValue(newDict, withCompletionBlock: { error, reference in
                    if let error = error {
                        completion(PersonEditorError.instagramUpdateError(error.localizedDescription))
                        return
                    }
                    else {
                        completion(nil)
                        return
                    }
                })
        
        
    }
    
    func removeInstagram(ref: DatabaseReference, completion: @escaping ((Error?) -> Void)) {
        ref.removeValue(completionBlock: { error, reference in
            if let error = error {
                completion(PersonEditorError.instagramUpdateError(error.localizedDescription))
                return
            }
            else {
                completion(nil)
                return
            }
        })
    }
    
    //MARK: - Facebook
    func processFacebook(initialPerson: PersonData, currentPerson: PersonData, initialStatus:Bool?, currentStatus:Bool?, initialURL:String?, currentURL:String?, completion: @escaping (([Error]?) -> Void)) {
        initPerson = initialPerson
        currPerson = currentPerson
        var errors:[Error] = []
        initRef = Database.database().reference().child("Registered Persons").child("\(initPerson.name!)--\(initPerson.dateRegisteredToApp!)--\(initPerson.timeRegisteredToApp!)--\(initPerson.toneDeafAppId)").child("Facebook")
        currRef = Database.database().reference().child("Registered Persons").child("\(currPerson.name!)--\(currPerson.dateRegisteredToApp!)--\(currPerson.timeRegisteredToApp!)--\(currPerson.toneDeafAppId)").child("Facebook")
        
        var dataUploadCompletionStatus1:Bool!
        var dataUploadCompletionStatus2:Bool!
        let queue = DispatchQueue(label: "myhjvkheditingQpersonsFacebookssseue")
        let group = DispatchGroup()
        var array:[Int] = []
        if currPerson.facebook == nil {
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
                    strongSelf.processFacebookStatus(ref: strongSelf.currRef, currentStatus: currentStatus, completion: {err in
                        if let error = err {
                            dataUploadCompletionStatus1 = false
                            errors.append(error)
                        } else {
                            dataUploadCompletionStatus1 = true
                            print("Facebook URL done \(i)")
                        }
                        group.leave()
                    })
                case 2:
                    strongSelf.processFacebookURL(ref: strongSelf.currRef, currentStatus: currentStatus, currentURL: currentURL, completion: {err in
                        if let error = err {
                            dataUploadCompletionStatus2 = false
                            errors.append(error)
                        } else {
                            dataUploadCompletionStatus2 = true
                            print("Facebook URL done \(i)")
                        }
                        group.leave()
                    })
                case 3:
                    strongSelf.removeFacebook(ref: strongSelf.currRef ,completion: {err in
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
                    print("Edit Person error")
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
    
    func processFacebookStatus(ref: DatabaseReference, currentStatus: Bool?, completion: @escaping ((Error?) -> Void)) {
        ref.child("Active Status").setValue(currentStatus, withCompletionBlock: { error, reference in
            if let error = error {
                completion(PersonEditorError.facebookUpdateError(error.localizedDescription))
                return
            }
            else {
                completion(nil)
                return
            }
        })
    }
    
    func processFacebookURL(ref: DatabaseReference, currentStatus: Bool?, currentURL: String?, completion: @escaping ((Error?) -> Void)) {
                let newDict:NSDictionary = [
                    "URL": currentURL!,
                    "Active Status": currentStatus!
                ]
                
                ref.setValue(newDict, withCompletionBlock: { error, reference in
                    if let error = error {
                        completion(PersonEditorError.facebookUpdateError(error.localizedDescription))
                        return
                    }
                    else {
                        completion(nil)
                        return
                    }
                })
        
        
    }
    
    func removeFacebook(ref: DatabaseReference, completion: @escaping ((Error?) -> Void)) {
        ref.removeValue(completionBlock: { error, reference in
            if let error = error {
                completion(PersonEditorError.facebookUpdateError(error.localizedDescription))
                return
            }
            else {
                completion(nil)
                return
            }
        })
    }
    
    //MARK: - Tik Tok
    func processTikTok(initialPerson: PersonData, currentPerson: PersonData, initialStatus:Bool?, currentStatus:Bool?, initialURL:String?, currentURL:String?, completion: @escaping (([Error]?) -> Void)) {
        initPerson = initialPerson
        currPerson = currentPerson
        var errors:[Error] = []
        initRef = Database.database().reference().child("Registered Persons").child("\(initPerson.name!)--\(initPerson.dateRegisteredToApp!)--\(initPerson.timeRegisteredToApp!)--\(initPerson.toneDeafAppId)").child("TikTok")
        currRef = Database.database().reference().child("Registered Persons").child("\(currPerson.name!)--\(currPerson.dateRegisteredToApp!)--\(currPerson.timeRegisteredToApp!)--\(currPerson.toneDeafAppId)").child("TikTok")
        
        var dataUploadCompletionStatus1:Bool!
        var dataUploadCompletionStatus2:Bool!
        var dataUploadCompletionStatus3:Bool!
        let queue = DispatchQueue(label: "myhjvkheditingQpersonsTikTokssseue")
        let group = DispatchGroup()
        var array:[Int] = []
        if currPerson.tikTok == nil {
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
                    strongSelf.processTikTokStatus(ref: strongSelf.currRef, currentStatus: currentStatus, completion: {err in
                        if let error = err {
                            dataUploadCompletionStatus1 = false
                            errors.append(error)
                        } else {
                            dataUploadCompletionStatus1 = true
                            print("TikTok URL done \(i)")
                        }
                        group.leave()
                    })
                case 2:
                    strongSelf.processTikTokURL(ref: strongSelf.currRef, currentStatus: currentStatus, currentURL: currentURL, completion: {err in
                        if let error = err {
                            dataUploadCompletionStatus2 = false
                            errors.append(error)
                        } else {
                            dataUploadCompletionStatus2 = true
                            print("TikTok URL done \(i)")
                        }
                        group.leave()
                    })
                case 3:
                    strongSelf.removeTikTok(ref: strongSelf.currRef ,completion: {err in
                        if let error = err {
                            dataUploadCompletionStatus3 = false
                            errors.append(error)
                        } else {
                            dataUploadCompletionStatus3 = true
                            print("TikTok URL done \(i)")
                        }
                        group.leave()
                    })
                default:
                    print("Edit Person error")
                }
            }
        }
        
        group.notify(queue: DispatchQueue.main) {
            if dataUploadCompletionStatus1 == false || dataUploadCompletionStatus2 == false || dataUploadCompletionStatus3 == false  {
                completion(errors)
                return
            } else {
                completion(nil)
            }
        }
    }
    
    func processTikTokStatus(ref: DatabaseReference, currentStatus: Bool?, completion: @escaping ((Error?) -> Void)) {
        ref.child("Active Status").setValue(currentStatus, withCompletionBlock: { error, reference in
            if let error = error {
                completion(PersonEditorError.tiktokUpdateError(error.localizedDescription))
                return
            }
            else {
                completion(nil)
                return
            }
        })
    }
    
    func processTikTokURL(ref: DatabaseReference, currentStatus: Bool?, currentURL: String?, completion: @escaping ((Error?) -> Void)) {
                let newDict:NSDictionary = [
                    "URL": currentURL!,
                    "Active Status": currentStatus!
                ]
                
                ref.setValue(newDict, withCompletionBlock: { error, reference in
                    if let error = error {
                        completion(PersonEditorError.tiktokUpdateError(error.localizedDescription))
                        return
                    }
                    else {
                        completion(nil)
                        return
                    }
                })
        
        
    }
    
    func removeTikTok(ref: DatabaseReference, completion: @escaping ((Error?) -> Void)) {
        ref.removeValue(completionBlock: { error, reference in
            if let error = error {
                completion(PersonEditorError.tiktokUpdateError(error.localizedDescription))
                return
            }
            else {
                completion(nil)
                return
            }
        })
    }
    
    //MARK: - Songs
    func processSongs(initialPerson: PersonData, currentPerson: PersonData, initialRoles:NSMutableDictionary,completion: @escaping (([Error]?) -> Void)) {
        initPerson = initialPerson
        currPerson = currentPerson
        if currPerson.albums == nil {
            currPerson.albums = []
        }
        self.initialRoles = initialRoles.mutableCopy() as! NSMutableDictionary
        
        var errors:[Error] = []
        initRef = Database.database().reference().child("Registered Persons").child("\(initPerson.name!)--\(initPerson.dateRegisteredToApp!)--\(initPerson.timeRegisteredToApp!)--\(initPerson.toneDeafAppId)")
        currRef = Database.database().reference().child("Registered Persons").child("\(currPerson.name!)--\(currPerson.dateRegisteredToApp!)--\(currPerson.timeRegisteredToApp!)--\(currPerson.toneDeafAppId)")
        
        var dataUploadCompletionStatus1:Bool!
        var dataUploadCompletionStatus2:Bool!
        var dataUploadCompletionStatus3:Bool!
        var dataUploadCompletionStatus4:Bool!
        let queue = DispatchQueue(label: "myhjvkheditingQpersonsSongssseue")
        let group = DispatchGroup()
        let array:[Int] = [1,2,3,4]
        for i in array {
            group.enter()
            queue.async { [weak self] in
                guard let strongSelf = self else {return}
                switch i {
                case 1:
                    strongSelf.updatePersonSongs(ref: strongSelf.currRef, completion: {err in
                        if let error = err {
                            dataUploadCompletionStatus1 = false
                            errors.append(error)
                        } else {
                            dataUploadCompletionStatus1 = true
                            print("Person Songs update done \(i)")
                        }
                        group.leave()
                    })
                case 2:
                    strongSelf.updatePersonSongRoles(ref: strongSelf.currRef, completion: {err in
                        
                        if let error = err {
                            dataUploadCompletionStatus1 = false
                            errors.append(error)
                        } else {
                            dataUploadCompletionStatus1 = true
                            print("Person Song Roles update done \(i)")
                        }
                        group.leave()
                    })
                case 3:
                    
                    DispatchQueue.global(qos: .userInitiated).async { [weak self] in
                        guard let strongSelf = self else {return}
                        strongSelf.updateSongRoles(ref: strongSelf.currRef, initialRoles: initialRoles, completion: {err in
                            if let error = err {
                                print("aww shucks")
                                dataUploadCompletionStatus3 = false
                                errors.append(error)
                            } else {
                                dataUploadCompletionStatus3 = true
                                print("Song Roles update done \(i)")
                            }
                            group.leave()
                        })
                    }
                case 4:
                    
                    DispatchQueue.global(qos: .userInitiated).async { [weak self] in
                        guard let strongSelf = self else {return}
                        strongSelf.updateSongAlbumSongs(ref: strongSelf.currRef, initialRoles: initialRoles, completion: {err in
                            
                            if let error = err {
                                print("aww shucks")
                                dataUploadCompletionStatus3 = false
                                errors.append(error)
                            } else {
                                dataUploadCompletionStatus3 = true
                                print("Song Album Songs update done \(i)")
                            }
                            group.leave()
                        })
                    }
                default:
                    print("Edit Person error")
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
    
    func updatePersonSongs(ref: DatabaseReference, completion: @escaping ((Error?) -> Void)) {
        var initialSongArrFromDB:[String]!
        if currPerson.songs == initPerson.songs {
            completion(nil)
            return
        }
        getPersonSongsInDB(ref: ref, completion: {[weak self] songs in
            guard let strongSelf = self else {return}
            initialSongArrFromDB = songs
            
            if !initialSongArrFromDB.isEmpty {
                var removalCounter = 0
                for i in 0 ... initialSongArrFromDB.count-1 {
                    if strongSelf.currPerson.songs != nil {
                        if i < strongSelf.currPerson.songs!.count {
                            if !strongSelf.currPerson.songs![i].contains(initialSongArrFromDB[i]) {
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
            
            if strongSelf.currPerson.songs != nil {
                if !strongSelf.currPerson.songs!.isEmpty {
                    for i in 0 ... strongSelf.currPerson.songs!.count-1 {
                        if i < initialSongArrFromDB.count {
                            if !initialSongArrFromDB[i].contains(strongSelf.currPerson.songs![i]) {
                                initialSongArrFromDB.append(strongSelf.currPerson.songs![i])
                            }
                        } else {
                            initialSongArrFromDB.append(strongSelf.currPerson.songs![i])
                        }
                    }
                }
            }
            ref.child("Songs").setValue(initialSongArrFromDB.sorted(), withCompletionBlock: { error, reference in
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
    
    func getPersonSongsInDB(ref: DatabaseReference, completion: @escaping (([String]) -> Void)) {
        ref.child("Songs").observeSingleEvent(of: .value, with: { snapshot in
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
    
    func updatePersonSongRoles(ref: DatabaseReference, completion: @escaping ((Error?) -> Void)) {
        var rolesInDB:NSDictionary!
        var newRoles:NSDictionary!
        if let ro = currPerson.roles {
            newRoles = ro
        }
        getPersonRolesInDB(ref: ref, completion: {[weak self] roles in
            guard let strongSelf = self else {return}
            rolesInDB = roles
//            print(String(data: try! JSONSerialization.data(withJSONObject: rolesInDB, options: .prettyPrinted), encoding: .utf8)!)
//            print(String(data: try! JSONSerialization.data(withJSONObject: newRoles, options: .prettyPrinted), encoding: .utf8)!)
            ref.child("Roles").setValue(newRoles, withCompletionBlock: { error, reference in
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
    
    func getPersonRolesInDB(ref: DatabaseReference, completion: @escaping ((NSDictionary) -> Void)) {
        ref.child("Roles").observeSingleEvent(of: .value, with: { snapshot in
            var dict:NSDictionary = [:]
            if let val = snapshot.value {
                let valu = val as? NSDictionary
                guard let value = valu else {
                    completion(dict)
                    return}
                dict = value
                completion(dict)
            } else {
                completion(dict)
            }
        })
    }
    
    func updateSongRoles(ref: DatabaseReference, initialRoles:NSMutableDictionary ,completion: @escaping ((Error?) -> Void)) {
        var initialSongArrFromDB:[String]!
        var initialeng:NSMutableDictionary!
        var artRef:DatabaseReference!
        if let eng = initialRoles["Engineer"] as? NSDictionary {
            initialeng = eng.mutableCopy() as! NSMutableDictionary
        }
        
        getPersonSongsInDB(ref: ref, completion: {[weak self] songs in
            guard let strongSelf = self else {return}
            initialSongArrFromDB = songs
            if let ro = strongSelf.currPerson.roles {
                
                if let newenggg = (ro["Engineer"] as? NSDictionary) {
                    strongSelf.currentEngRoles = newenggg
                } else {
                    strongSelf.currentEngRoles = nil
                }
                if let new = ro["Artist"] as? [String] {
                    
                    if let old = initialRoles["Artist"] as? [String] {
                        let semap = DispatchSemaphore(value: 1)
//                        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
//                            guard let strongSelf = self else {return}
                            var count = 0
                        var completioncount = 0
                        
                        if old != new {
                            for item in new {
                                if count != 0 {
                                    usleep(100)
                                }
                                count+=1
                                if !old.contains(item) {
                                    strongSelf.addPersonToSongInDB(son: item, cat: "Artist", completion: {err in
                                        if let err = err {
                                            completion(err)
                                            return
                                        } else {
                                            strongSelf.updateSongRolesP2(initialRoles: initialRoles, songs: songs, completion: {err in
                                                completioncount+=1
                                                if let err = err {
                                                    completion(err)
                                                    return
                                                } else {
                                                    
                                                    if completioncount == (old.count+new.count) {
                                                        completion(nil)
                                                    }
                                                }
                                            })
                                        }
                                    })
                                }
                                else {
                                    strongSelf.updateSongRolesP2(initialRoles: initialRoles, songs: songs, completion: {err in
                                        completioncount+=1
//                                        semap.signal()
                                        if let err = err {
                                            completion(err)
                                            return
                                        } else {
                                            if completioncount == (old.count+new.count) {
                                                completion(nil)
                                            }
                                        }
                                    })
                                }
                                print("arcount ", count, new.count)
//                                semap.wait()
                            }
                            for item in old {
                                
                                if count != 0 {
                                    usleep(100)
                                }
                                count+=1
                                if !new.contains(item) {
                                    strongSelf.removePersonFromSongInDB(son: item, cat: "Artist", completion: {err in
                                        if let err = err {
                                            completion(err)
                                            return
                                        } else {
                                            strongSelf.updateSongRolesP2(initialRoles: initialRoles, songs: songs, completion: {err in
                                                completioncount+=1
                                                //                                                    semap.signal()
                                                if let err = err {
                                                    completion(err)
                                                    return
                                                } else {
                                                    if completioncount == (old.count+new.count) {
                                                        completion(nil)
                                                    }
                                                }
                                            })
                                        }
                                    })
                                }
                                else {
                                    strongSelf.updateSongRolesP2(initialRoles: initialRoles, songs: songs, completion: {err in
                                        completioncount+=1
//                                        semap.signal()
                                        if let err = err {
                                            completion(err)
                                            return
                                        } else {
                                            if completioncount == (old.count+new.count) {
                                                completion(nil)
                                            }
                                        }
                                    })
                                }
                                print("aroldcount ", count, old.count)
//                                semap.wait()
                            }
                        } else {
                            strongSelf.updateSongRolesP2(initialRoles: initialRoles, songs: songs, completion: {err in
                                if let err = err {
                                    completion(err)
                                    return
                                } else {
                                    completion(nil)
                                }
                            })
                        }
//                        }
                    } else {
                        let semap = DispatchSemaphore(value: 1)
//                        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
//                            guard let strongSelf = self else {return}
                            var count = 0
                        var completioncount = 0
                            for item in new {
                                if count != 0 {
                                    usleep(100)
                                }
                                count+=1
                                
                                strongSelf.addPersonToSongInDB(son: item, cat: "Artist",completion: {err in
                                    if let err = err {
                                        completion(err)
                                        return
                                    } else {
                                        
                                        strongSelf.updateSongRolesP2(initialRoles: initialRoles, songs: songs, completion: {err in
                                            completioncount+=1
                                            if let err = err {
                                                completion(err)
                                                return
                                            } else {
                                                if completioncount == (new.count) {
                                                    completion(nil)
                                                }
                                            }
                                        })
                                    }
                                })
                                //semap.wait()
                            }
//                        }
                    }
                } else if let old = initialRoles["Artist"] as? [String] {
                    if let new = ro["Artist"] as? [String] {
                        let semap = DispatchSemaphore(value: 1)
//                        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
//                            guard let strongSelf = self else {return}
                            var count = 0
                        var completioncount = 0
                            for item in old {
                                if count != 0 {
                                    usleep(100)
                                }
                                count+=1
                                if !new.contains(item) {
                                    strongSelf.removePersonFromSongInDB(son: item, cat: "Artist", completion: {err in
                                        if let err = err {
                                            completion(err)
                                            return
                                        } else {
                                            strongSelf.updateSongRolesP2(initialRoles: initialRoles, songs: songs, completion: {err in
                                                completioncount+=1
                                                if let err = err {
                                                    completion(err)
                                                    return
                                                } else {
                                                    if completioncount == (old.count) {
                                                        completion(nil)
                                                    }
                                                }
                                            })
                                        }
                                    })
                                    //semap.wait()
                                }
                            }
//                        }
                    } else {
                        
                        let semap = DispatchSemaphore(value: 1)
//                        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
//                            guard let strongSelf = self else {return}
                            var count = 0
                        var completioncount = 0
                            for item in old {
                                if count != 0 {
                                    usleep(100)
                                }
                                count+=1
                                strongSelf.removePersonFromSongInDB(son: item, cat: "Artist", completion: {err in
                                    if let err = err {
                                        completion(err)
                                        return
                                    } else {
                                        strongSelf.updateSongRolesP2(initialRoles: initialRoles, songs: songs, completion: {err in
                                            completioncount+=1
                                            
                                            if let err = err {
                                                completion(err)
                                                return
                                            } else {
                                                if completioncount == (old.count) {
                                                    completion(nil)
                                                }
                                            }
                                        })
                                    }
                                })
                                //semap.wait()
                            }
                        //                        }
                    }
                } else {
                    strongSelf.updateSongRolesP2(initialRoles: initialRoles, songs: songs, completion: {err in
                        if let err = err {
                            completion(err)
                            return
                        } else {
                            completion(nil)
                        }
                    })
                }
            }
            else {
                if let arr = initialRoles["Artist"] as? [String] {
                    let semap = DispatchSemaphore(value: 1)
                    let group = DispatchGroup()
//                    DispatchQueue.global(qos: .userInitiated).async { [weak self] in
//                        guard let strongSelf = self else {return}
                        var count = 0
                    var completioncount = 0
                        for songg in arr {
                            if count != 0 {
                                usleep(100)
                            }
                            count+=1
                                //If the a song is on an album, go to the album in database and remove the person from the albums 'All Artist' node
                                        strongSelf.removePersonFromSongInDB(son: songg, cat: "Artist", completion: {err in
                                            if let err = err {
                                                completion(err)
                                                return
                                            } else {
                                                strongSelf.updateSongRolesP2(initialRoles: initialRoles, songs: songs, completion: {err in
                                                    completioncount+=1
                                                    print(completioncount, (arr.count))
                                                    
                                                    if let err = err {
                                                        completion(err)
                                                        return
                                                    } else {
                                                        if completioncount == (arr.count) {
                                                            completion(nil)
                                                        }
                                                    }
                                                })
                                            }
                                        })
                        }
                }
                else {
                    strongSelf.updateSongRolesP2(initialRoles: initialRoles, songs: songs, completion: {err in
                        if let err = err {
                            completion(err)
                            return
                        } else {
                            completion(nil)
                        }
                    })
                }
            }
        })
    }
    
    func updateSongRolesP2(initialRoles:NSMutableDictionary , songs:[String],completion: @escaping ((Error?) -> Void)) {
        var initialSongArrFromDB:[String] = songs
        var initialeng:NSMutableDictionary!
        if let eng = initialRoles["Engineer"] as? NSDictionary {
            initialeng = eng.mutableCopy() as! NSMutableDictionary
        }
        
        if let ro = currPerson.roles {
        if let new = ro["Producer"] as? [String] {
            
            if let old = initialRoles["Producer"] as? [String] {
                let semap = DispatchSemaphore(value: 1)
//                DispatchQueue.global(qos: .userInitiated).async { [weak self] in
//                    guard let strongSelf = self else {return}
                if new != old {
                    var count = 0
                    for item in new {
                        if count != 0 {
                            usleep(100)
                        }
                        count+=1
                        if !old.contains(item) {
                            //Add PersonTo song artist: song is item
                            addPersonToSongInDB(son: item, cat: "Producer", completion: {err in
                                if new.count != 1 {
//                                    //semap.signal()
                                }
                                if let err = err {
                                    completion(err)
                                    return
                                }
                            })
                        }
                        if new.count != 1 {
//                            //semap.wait()
                        }
                    }
                    for item in old {
                        if count != 0 {
                            usleep(100)
                        }
                        count+=1
                        if !new.contains(item) {
                            
                            //Add PersonTo song artist: song is item
                            removePersonFromSongInDB(son: item, cat: "Producer", completion: {err in
                                if old.count != 1 {
                                    //semap.signal()
                                }
                                if let err = err {
                                    completion(err)
                                    return
                                }
                            })
                        }
                        if old.count != 1 {
                            //semap.wait()
                        }
                    }
                }
//                }
            } else {
                let semap = DispatchSemaphore(value: 1)
                let group = DispatchGroup()
//                DispatchQueue.global(qos: .userInitiated).async { [weak self] in
//                    guard let strongSelf = self else {return}
                    var count = 0
                    
                    for item in new {
                        if count != 0 {
                            usleep(100)
                        }
                        count+=1
                        //Add PersonTo song artist: song is item
                        addPersonToSongInDB(son: item, cat: "Producer", completion: {err in
                            //semap.signal()
                            if let err = err {
                                completion(err)
                                return
                            }
                        })
                        //semap.wait()
                    }
//                }
            }
        } else if let old = initialRoles["Producer"] as? [String] {
            if let new = ro["Producer"] as? [String] {
                let semap = DispatchSemaphore(value: 1)
                let group = DispatchGroup()
//                DispatchQueue.global(qos: .userInitiated).async { [weak self] in
//                    guard let strongSelf = self else {return}
                    var count = 0
                if old != new {
                    for item in old {
                        if count != 0 {
                            usleep(100)
                        }
                        count+=1
                        if !new.contains(item) {
                            //remove person from song artist: song is item
                            removePersonFromSongInDB(son: item, cat: "Producer", completion: {err in
                                //semap.signal()
                                if let err = err {
                                    completion(err)
                                    return
                                }
                            })
                        }
                        //semap.wait()
                    }
                for item in new {
                    if count != 0 {
                        usleep(100)
                    }
                    count+=1
                    if !old.contains(item) {
                        //remove person from song artist: song is item
                        addPersonToSongInDB(son: item, cat: "Producer", completion: {err in
                            //semap.signal()
                            if let err = err {
                                completion(err)
                                return
                            }
                        })
                    }
                    //semap.wait()
                }
                }
//                }
            } else {
                let semap = DispatchSemaphore(value: 1)
                let group = DispatchGroup()
//                DispatchQueue.global(qos: .userInitiated).async { [weak self] in
//                    guard let strongSelf = self else {return}
                    var count = 0
                    for item in old {
                        if count != 0 {
                            usleep(100)
                        }
                        count+=1
                        //remove person from song artist: song is item
                        removePersonFromSongInDB(son: item, cat: "Producer", completion: {err in
                            //semap.signal()
                            if let err = err {
                                completion(err)
                                return
                            }
                        })
                        //semap.wait()
                    }
//                }
            }
        }
        if let new = ro["Writer"] as? [String] {
            if let old = initialRoles["Writer"] as? [String] {
                let semap = DispatchSemaphore(value: 1)
                let group = DispatchGroup()
//                DispatchQueue.global(qos: .userInitiated).async { [weak self] in
//                    guard let strongSelf = self else {return}
                    var count = 0
                if new != old {
                    for item in new {
                        if count != 0 {
                            usleep(100)
                        }
                        count+=1
                        if !old.contains(item) {
                            //Add PersonTo song artist: song is item
                            addPersonToSongInDB(son: item, cat: "Writer", completion: {err in
                                if new.count != 1 {
                                    //semap.signal()
                                }
                                if let err = err {
                                    completion(err)
                                    return
                                }
                            })
                        }
                        if new.count != 1 {
                            //semap.wait()
                        }
                    }
                    for item in old {
                        if count != 0 {
                            usleep(100)
                        }
                        count+=1
                        if !new.contains(item) {
                            //Add PersonTo song artist: song is item
                            removePersonFromSongInDB(son: item, cat: "Writer", completion: {err in
                                if old.count != 1 {
                                    //semap.signal()
                                }
                                if let err = err {
                                    completion(err)
                                    return
                                }
                            })
                        }
                        if old.count != 1 {
                            //semap.wait()
                        }
                    }
                }
//                }
            } else {
                let semap = DispatchSemaphore(value: 1)
                let group = DispatchGroup()
//                DispatchQueue.global(qos: .userInitiated).async { [weak self] in
//                    guard let strongSelf = self else {return}
                    var count = 0
                    for item in new {
                        if count != 0 {
                            usleep(100)
                        }
                        count+=1
                        //Add PersonTo song artist: song is item
                        addPersonToSongInDB(son: item, cat: "Writer", completion: {err in
                            //semap.signal()
                            if let err = err {
                                completion(err)
                                return
                            }
                        })
                        //semap.wait()
                    }
//                }
            }
        } else if let old = initialRoles["Writer"] as? [String] {
            if let new = ro["Writer"] as? [String] {
                let semap = DispatchSemaphore(value: 1)
                let group = DispatchGroup()
//                DispatchQueue.global(qos: .userInitiated).async { [weak self] in
//                    guard let strongSelf = self else {return}
                    var count = 0
                if new != old {
                    for item in old {
                        if count != 0 {
                            usleep(100)
                        }
                        count+=1
                        if !new.contains(item) {
                            //remove person from song artist: song is item
                            removePersonFromSongInDB(son: item, cat: "Writer", completion: {err in
                                //semap.signal()
                                if let err = err {
                                    completion(err)
                                    return
                                }
                            })
                        }
                        //semap.wait()
                    }
                for item in new {
                    if count != 0 {
                        usleep(100)
                    }
                    count+=1
                    if !old.contains(item) {
                        //remove person from song artist: song is item
                        addPersonToSongInDB(son: item, cat: "Writer", completion: {err in
                            //semap.signal()
                            if let err = err {
                                completion(err)
                                return
                            }
                        })
                    }
                    //semap.wait()
                }
                }
//                }
            } else {
                let semap = DispatchSemaphore(value: 1)
                let group = DispatchGroup()
//                DispatchQueue.global(qos: .userInitiated).async { [weak self] in
//                    guard let strongSelf = self else {return}
                    var count = 0
                    for item in old {
                        if count != 0 {
                            usleep(100)
                        }
                        count+=1
                        removePersonFromSongInDB(son: item, cat: "Writer", completion: {err in
                            //semap.signal()
                            if let err = err {
                                completion(err)
                                return
                            }
                        })
                        //semap.wait()
                    }
//                }
            }
        }
        if let newenggg = (currentEngRoles as? NSDictionary) {
            
            let newengg = newenggg.mutableCopy() as! NSMutableDictionary
            if newengg.count > 0 {
                
            if let new = newengg["Mix Engineer"] as? [String] {
                if let inieng = initialeng as? NSDictionary {
                    let initeng = inieng.mutableCopy() as! NSMutableDictionary
                    
                    if let old = initeng["Mix Engineer"] as? [String] {
                        
                        if new != old {
                            
                            let semap = DispatchSemaphore(value: 1)
//                            DispatchQueue.global(qos: .userInitiated).async { [weak self] in
//                                guard let strongSelf = self else {return}
                                var count = 0
                                for item in new {
                                    if count != 0 {
                                        usleep(100)
                                    }
                                    count+=1
                                    if !old.contains(item) {
                                        addPersonToSongInDB(son: item, cat: "Mix Engineer", completion: {err in
                                            if new.count != 1 {
                                                //semap.signal()
                                            }
                                            if let err = err {
                                                completion(err)
                                                return
                                            }
                                        })
                                    }
                                    if new.count != 1 {
                                        //semap.wait()
                                    }
                                }
                            for item in old {
                                
                                if count != 0 {
                                    usleep(100)
                                }
                                count+=1
                                
                                if !new.contains(item) {
                                    
                                    //Add PersonTo song artist: song is item
                                    removePersonFromSongInDB(son: item, cat: "Mix Engineer", completion: {err in
                                        if old.count != 1 {
                                            //semap.signal()
                                        }
                                        if let err = err {
                                            completion(err)
                                            return
                                        }
                                    })
                                }
                                if old.count != 1 {
                                    //semap.wait()
                                }
                            }
//                            }
                        }
                    } else {
                        let semap = DispatchSemaphore(value: 1)
                        let group = DispatchGroup()
//                        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
//                            guard let strongSelf = self else {return}
                            var count = 0
                            for item in new {
                                if count != 0 {
                                    usleep(100)
                                }
                                count+=1
                                //Add PersonTo song artist: song is item
                                addPersonToSongInDB(son: item, cat: "Mix Engineer", completion: {err in
                                    //semap.signal()
                                    if let err = err {
                                        completion(err)
                                        return
                                    }
                                })
                                //semap.wait()
                            }
//                        }
                    }
                } else {
                    let semap = DispatchSemaphore(value: 1)
//                    DispatchQueue.global(qos: .userInitiated).async { [weak self] in
//                        guard let strongSelf = self else {return}
                        var count = 0
                        for item in new {
                            if count != 0 {
                                usleep(100)
                            }
                            count+=1
                            //Add PersonTo song artist: song is item
                            addPersonToSongInDB(son: item, cat: "Mix Engineer", completion: {err in
                                //semap.signal()
                                if let err = err {
                                    completion(err)
                                    return
                                }
                            })
                            //semap.wait()
                        }
//                    }
                }
            }
                else if let inieng = initialeng as? NSDictionary {
                    let initeng = inieng.mutableCopy() as! NSMutableDictionary
                    if let old = initeng["Mix Engineer"] as? [String] {
                        if let new = newengg["Mix Engineer"] as? [String] {
                            
                            if new != old {
                                let semap = DispatchSemaphore(value: 1)
//                                DispatchQueue.global(qos: .userInitiated).async { [weak self] in
//                                    guard let strongSelf = self else {return}
                                    var count = 0
                                for item in old {
                                    if count != 0 {
                                        usleep(100)
                                    }
                                    count+=1
                                    if !new.contains(item) {
                                        //remove person from song artist: song is item
                                        removePersonFromSongInDB(son: item, cat: "Mix Engineer", completion: {err in
                                            //semap.signal()
                                            if let err = err {
                                                completion(err)
                                                return
                                            }
                                        })
                                    }
                                    //semap.wait()
                                    }
                                for item in new {
                                    if count != 0 {
                                        usleep(100)
                                    }
                                    count+=1
                                    if !old.contains(item) {
                                        //remove person from song artist: song is item
                                        addPersonToSongInDB(son: item, cat: "Mix Engineer", completion: {err in
                                            //semap.signal()
                                            if let err = err {
                                                completion(err)
                                                return
                                            }
                                        })
                                    }
                                    //semap.wait()
                                    }
//                                }
                            }
                        } else {
                            let semap = DispatchSemaphore(value: 1)
//                            DispatchQueue.global(qos: .userInitiated).async { [weak self] in
//                                guard let strongSelf = self else {return}
                                var count = 0
                                for item in old {
                                    if count != 0 {
                                        usleep(100)
                                    }
                                    count+=1
                                    //remove person from song artist: song is item
                                    removePersonFromSongInDB(son: item, cat: "Mix Engineer", completion: {err in
                                        //semap.signal()
                                        if let err = err {
                                            completion(err)
                                            return
                                        }
                                        
                                    })
                                    //semap.wait()
                                }
//                            }
                        }
                }
            }
                
                
                if let new = newengg["Mastering Engineer"] as? [String] {
                    if let inieng = initialeng as? NSDictionary {
                        let initeng = inieng.mutableCopy() as! NSMutableDictionary
                        if let old = initeng["Mastering Engineer"] as? [String] {
                            let semap = DispatchSemaphore(value: 1)
//                            DispatchQueue.global(qos: .userInitiated).async { [weak self] in
//                                guard let strongSelf = self else {return}
                                var count = 0
                            if new != old {
                                for item in new {
                                    if count != 0 {
                                        usleep(100)
                                    }
                                    count+=1
                                    if !old.contains(item) {
                                        //Add PersonTo song artist: song is item
                                        addPersonToSongInDB(son: item, cat: "Mastering Engineer", completion: {err in
                                            if new.count != 1 {
//                                            //semap.signal()
                                            }
                                            if let err = err {
                                                completion(err)
                                                return
                                            }
                                        })
                                    }
                                    if new.count != 1 {
//                                    //semap.wait()
                                    }
                                }
                                for item in old {
                                    if count != 0 {
                                        usleep(100)
                                    }
                                    count+=1
                                    if !new.contains(item) {
                                        //Add PersonTo song artist: song is item
                                        removePersonFromSongInDB(son: item, cat: "Mastering Engineer", completion: {err in
                                            if old.count != 1 {
//                                            //semap.signal()
                                            }
                                            if let err = err {
                                                completion(err)
                                                return
                                            }
                                        })
                                    }
                                    if old.count != 1 {
//                                    //semap.wait()
                                    }
                                }
                            }
//                            }
                        } else {
                            let semap = DispatchSemaphore(value: 1)
                                var count = 0
                            for item in new {
                                if count != 0 {
                                    usleep(100)
                                }
                                count+=1
                                //Add PersonTo song artist: song is item
                                addPersonToSongInDB(son: item, cat: "Mastering Engineer", completion: {err in
                                    //semap.signal()
                                    if let err = err {
                                        completion(err)
                                        return
                                    }
                                })
                                //semap.wait()
                            }
//                            }
                        }
                    } else {
                        
                            let semap = DispatchSemaphore(value: 1)
//                            DispatchQueue.global(qos: .userInitiated).async { [weak self] in
//                                guard let strongSelf = self else {return}
                                var count = 0
                        for item in new {
                            if count != 0 {
                                usleep(100)
                            }
                            count+=1
                            //Add PersonTo song artist: song is item
                            addPersonToSongInDB(son: item, cat: "Mastering Engineer", completion: {err in
                                //semap.signal()
                                if let err = err {
                                    completion(err)
                                    return
                                }
                            })
                            //semap.wait()
                        }
//                        }
                    }
                }
                else if let inieng = initialeng as? NSDictionary {
                    let initeng = inieng.mutableCopy() as! NSMutableDictionary
                    if let old = initeng["Mastering Engineer"] as? [String] {
                        if let new = newengg["Mastering Engineer"] as? [String] {
                            
                            if new != old {
                                let semap = DispatchSemaphore(value: 1)
                                let group = DispatchGroup()
//                                DispatchQueue.global(qos: .userInitiated).async { [weak self] in
//                                    guard let strongSelf = self else {return}
                                    var count = 0
                                for item in old {
                                    if count != 0 {
                                        usleep(100)
                                    }
                                    count+=1
                                    if !new.contains(item) {
                                        //remove person from song artist: song is item
                                        removePersonFromSongInDB(son: item, cat: "Mastering Engineer", completion: {err in
                                            //semap.signal()
                                            if let err = err {
                                                completion(err)
                                                return
                                            }
                                        })
                                    }
                                    //semap.wait()
                                }
                                for item in new {
                                    if count != 0 {
                                        usleep(100)
                                    }
                                    count+=1
                                    if !old.contains(item) {
                                        //remove person from song artist: song is item
                                        addPersonToSongInDB(son: item, cat: "Mastering Engineer", completion: {err in
                                            //semap.signal()
                                            if let err = err {
                                                completion(err)
                                                return
                                            }
                                        })
                                    }
                                    //semap.wait()
                                }
//                                }
                            }
                        } else {
                            let semap = DispatchSemaphore(value: 1)
                            let group = DispatchGroup()
//                            DispatchQueue.global(qos: .userInitiated).async { [weak self] in
//                                guard let strongSelf = self else {return}
                                var count = 0
                                for item in old {
                                    if count != 0 {
                                        usleep(100)
                                    }
                                    count+=1
                                    //remove person from song artist: song is item
                                    removePersonFromSongInDB(son: item, cat: "Mastering Engineer", completion: {err in
                                        //semap.signal()
                                        if let err = err {
                                            completion(err)
                                            return
                                        }
                                    })
                                    //semap.wait()
                                }
//                            }
                        }
                    }
                }
                
                if let new = newengg["Recording Engineer"] as? [String] {
                    if let inieng = initialeng as? NSDictionary {
                        let initeng = inieng.mutableCopy() as! NSMutableDictionary
                        if let old = initeng["Recording Engineer"] as? [String] {
                            
                            if new != old {
                                let semap = DispatchSemaphore(value: 1)
                                let group = DispatchGroup()
//                                DispatchQueue.global(qos: .userInitiated).async { [weak self] in
//                                    guard let strongSelf = self else {return}
                                    var count = 0
                                    for item in new {
                                        if count != 0 {
                                            usleep(100)
                                        }
                                        count+=1
                                        if !old.contains(item) {
                                            //Add PersonTo song artist: song is item
                                            addPersonToSongInDB(son: item, cat: "Recording Engineer", completion: {err in
                                                //semap.signal()
                                                if let err = err {
                                                    completion(err)
                                                    return
                                                }
                                            })
                                        }
                                        //semap.wait()
                                    }
                                for item in old {
                                    if count != 0 {
                                        usleep(100)
                                    }
                                    count+=1
                                    if !new.contains(item) {
                                        //Add PersonTo song artist: song is item
                                        removePersonFromSongInDB(son: item, cat: "Recording Engineer", completion: {err in
                                            //semap.signal()
                                            if let err = err {
                                                completion(err)
                                                return
                                            }
                                        })
                                    }
                                    //semap.wait()
                                }
//                                }
                            }
                        } else {
                            let semap = DispatchSemaphore(value: 1)
                            let group = DispatchGroup()
//                            DispatchQueue.global(qos: .userInitiated).async { [weak self] in
//                                guard let strongSelf = self else {return}
                                var count = 0
                                for item in new {
                                    if count != 0 {
                                        usleep(100)
                                    }
                                    count+=1
                                    //Add PersonTo song artist: song is item
                                    addPersonToSongInDB(son: item, cat: "Recording Engineer", completion: {err in
                                        //semap.signal()
                                        if let err = err {
                                            completion(err)
                                            return
                                        }
                                    })
                                    //semap.wait()
                                }
//                            }
                        }
                    } else {
                        let semap = DispatchSemaphore(value: 1)
                        let group = DispatchGroup()
//                        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
//                            guard let strongSelf = self else {return}
                            var count = 0
                            for item in new {
                                if count != 0 {
                                    usleep(100)
                                }
                                count+=1
                                //Add PersonTo song artist: song is item
                                addPersonToSongInDB(son: item, cat: "Recording Engineer", completion: {err in
                                    //semap.signal()
                                    if let err = err {
                                        completion(err)
                                        return
                                    }
                                })
                                //semap.wait()
                            }
//                        }
                    }
                }
                else if let inieng = initialeng as? NSDictionary {
                    let initeng = inieng.mutableCopy() as! NSMutableDictionary
                    if let old = initeng["Recording Engineer"] as? [String] {
                        if let new = newengg["Recording Engineer"] as? [String] {
                            if new != old {
                                let semap = DispatchSemaphore(value: 1)
//                                DispatchQueue.global(qos: .userInitiated).async { [weak self] in
//                                    guard let strongSelf = self else {return}
                                    var count = 0
                                    for item in old {
                                        if count != 0 {
                                            usleep(100)
                                        }
                                        count+=1
                                        if !new.contains(item) {
                                            //remove person from song artist: song is item
                                            removePersonFromSongInDB(son: item, cat: "Recording Engineer", completion: {err in
                                                //semap.signal()
                                                if let err = err {
                                                    completion(err)
                                                    return
                                                }
                                            })
                                        }
                                        //semap.wait()
                                    }
                                for item in new {
                                    if count != 0 {
                                        usleep(100)
                                    }
                                    count+=1
                                    if !old.contains(item) {
                                        //remove person from song artist: song is item
                                        addPersonToSongInDB(son: item, cat: "Recording Engineer", completion: {err in
                                            //semap.signal()
                                            if let err = err {
                                                completion(err)
                                                return
                                            }
                                        })
                                    }
                                    //semap.wait()
                                }
//                                }
                            }
                        } else {
                            let semap = DispatchSemaphore(value: 1)
//                            DispatchQueue.global(qos: .userInitiated).async { [weak self] in
//                                guard let strongSelf = self else {return}
                                var count = 0
                                for item in old {
                                    if count != 0 {
                                        usleep(100)
                                    }
                                    count+=1
                                    //remove person from song artist: song is item
                                    removePersonFromSongInDB(son: item, cat: "Recording Engineer", completion: {err in
                                        //semap.signal()
                                        if let err = err {
                                            completion(err)
                                            return
                                        }
                                        //                                    else {
                                        //                                        completion(nil)
                                        //                                    }
                                    })
                                    //semap.wait()
                                }
//                            }
                        }
                    }
                }
            }
            
        } else if let oldenggg = initialRoles["Engineer"] as? NSDictionary {
            let oldnegg = oldenggg.mutableCopy() as! NSMutableDictionary
            if let newengg = ro["Engineer"] as? NSMutableDictionary {
                if let new = newengg["Mix Engineer"] as? [String] {
                    if let old = initialeng["Mix Engineer"] as? [String] {
                        if new != old {
                            let semap = DispatchSemaphore(value: 1)
                            let group = DispatchGroup()
//                            DispatchQueue.global(qos: .userInitiated).async { [weak self] in
//                                guard let strongSelf = self else {return}
                                var count = 0
                                for item in new {
                                    if count != 0 {
                                        usleep(100)
                                    }
                                    count+=1
                                    if !old.contains(item) {
                                        //Add PersonTo song artist: song is item
                                        addPersonToSongInDB(son: item, cat: "Mix Engineer", completion: {err in
                                            //semap.signal()
                                            if let err = err {
                                                completion(err)
                                                return
                                            }
                                        })
                                    }
                                    //semap.wait()
                                }
                            for item in old {
                                if count != 0 {
                                    usleep(100)
                                }
                                count+=1
                                if !new.contains(item) {
                                    //Add PersonTo song artist: song is item
                                    removePersonFromSongInDB(son: item, cat: "Mix Engineer", completion: {err in
                                        //semap.signal()
                                        if let err = err {
                                            completion(err)
                                            return
                                        }
                                    })
                                }
                                //semap.wait()
                            }
//                            }
                        }
                    } else {
                        let semap = DispatchSemaphore(value: 1)
                        let group = DispatchGroup()
//                        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
//                            guard let strongSelf = self else {return}
                            var count = 0
                            for item in new {
                                if count != 0 {
                                    usleep(100)
                                }
                                count+=1
                                //Add PersonTo song artist: song is item
                                addPersonToSongInDB(son: item, cat: "Mix Engineer", completion: {err in
                                    //semap.signal()
                                    if let err = err {
                                        completion(err)
                                        return
                                    }
                                })
                                //semap.wait()
                            }
//                        }
                    }
                } else if let old = initialeng["Mix Engineer"] as? [String] {
                    if let new = newengg["Mix Engineer"] as? [String] {
                        if new != old {
                            let semap = DispatchSemaphore(value: 1)
                            let group = DispatchGroup()
//                            DispatchQueue.global(qos: .userInitiated).async { [weak self] in
//                                guard let strongSelf = self else {return}
                                var count = 0
                                for item in old {
                                    if count != 0 {
                                        usleep(100)
                                    }
                                    count+=1
                                    if !new.contains(item) {
                                        //remove person from song artist: song is item
                                        removePersonFromSongInDB(son: item, cat: "Mix Engineer", completion: {err in
                                            //semap.signal()
                                            if let err = err {
                                                completion(err)
                                                return
                                            }
                                        })
                                    }
                                    //semap.wait()
                                }
                            for item in new {
                                if count != 0 {
                                    usleep(100)
                                }
                                count+=1
                                if !old.contains(item) {
                                    //remove person from song artist: song is item
                                    addPersonToSongInDB(son: item, cat: "Mix Engineer", completion: {err in
                                        //semap.signal()
                                        if let err = err {
                                            completion(err)
                                            return
                                        }
                                    })
                                }
                                //semap.wait()
                            }
//                            }
                        }
                    } else {
                        let semap = DispatchSemaphore(value: 1)
                        let group = DispatchGroup()
//                        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
//                            guard let strongSelf = self else {return}
                            var count = 0
                            for item in old {
                                if count != 0 {
                                    usleep(100)
                                }
                                count+=1
                                //remove person from song artist: song is item
                                removePersonFromSongInDB(son: item, cat: "Mix Engineer", completion: {err in
                                    //semap.signal()
                                    if let err = err {
                                        completion(err)
                                        return
                                    }
                                })
                                //semap.wait()
                            }
//                        }
                    }
                }
                if let new = newengg["Mastering Engineer"] as? [String] {
                    
                    if let old = initialeng["Mastering Engineer"] as? [String] {
                        if new != old {
                            let semap = DispatchSemaphore(value: 1)
//                            DispatchQueue.global(qos: .userInitiated).async { [weak self] in
//                                guard let strongSelf = self else {return}
                                var count = 0
                                for item in new {
                                    if count != 0 {
                                        usleep(100)
                                    }
                                    count+=1
                                    if !old.contains(item) {
                                        //Add PersonTo song artist: song is item
                                        addPersonToSongInDB(son: item, cat: "Mastering Engineer", completion: {err in
                                            //semap.signal()
                                            if let err = err {
                                                completion(err)
                                                return
                                            }
                                        })
                                    }
                                    //semap.wait()
                                }
                            for item in old {
                                if count != 0 {
                                    usleep(100)
                                }
                                count+=1
                                if !new.contains(item) {
                                    //Add PersonTo song artist: song is item
                                    removePersonFromSongInDB(son: item, cat: "Mastering Engineer", completion: {err in
                                        //semap.signal()
                                        if let err = err {
                                            completion(err)
                                            return
                                        }
                                    })
                                }
                                //semap.wait()
                            }
//                            }
                        }
                    } else {
                        let semap = DispatchSemaphore(value: 1)
//                        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
//                            guard let strongSelf = self else {return}
                            var count = 0
                            for item in new {
                                if count != 0 {
                                    usleep(100)
                                }
                                count+=1
                                //Add PersonTo song artist: song is item
                                addPersonToSongInDB(son: item, cat: "Mastering Engineer", completion: {err in
                                    //semap.signal()
                                    if let err = err {
                                        completion(err)
                                        return
                                    }
                                })
                                //semap.wait()
                            }
//                        }
                    }
                } else if let old = initialeng["Mastering Engineer"] as? [String] {
                    if let new = newengg["Mastering Engineer"] as? [String] {
                        if new != old {
                            let semap = DispatchSemaphore(value: 1)
                            let group = DispatchGroup()
//                            DispatchQueue.global(qos: .userInitiated).async { [weak self] in
//                                guard let strongSelf = self else {return}
                                var count = 0
                                for item in old {
                                    if count != 0 {
                                        usleep(100)
                                    }
                                    count+=1
                                    if !new.contains(item) {
                                        //remove person from song artist: song is item
                                        removePersonFromSongInDB(son: item, cat: "Mastering Engineer", completion: {err in
                                            //semap.signal()
                                            if let err = err {
                                                completion(err)
                                                return
                                            }
                                            //                                            else {
                                            //                                                completion(nil)
                                            //                                            }
                                        })
                                    }
                                    //semap.wait()
                                }
                            for item in new {
                                if count != 0 {
                                    usleep(100)
                                }
                                count+=1
                                if !old.contains(item) {
                                    //remove person from song artist: song is item
                                    addPersonToSongInDB(son: item, cat: "Mastering Engineer", completion: {err in
                                        //semap.signal()
                                        if let err = err {
                                            completion(err)
                                            return
                                        }
                                        //                                            else {
                                        //                                                completion(nil)
                                        //                                            }
                                    })
                                }
                                //semap.wait()
                            }
//                            }
                        }
                    } else {
                        let semap = DispatchSemaphore(value: 1)
                        let group = DispatchGroup()
//                        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
//                            guard let strongSelf = self else {return}
                            var count = 0
                            for item in old {
                                if count != 0 {
                                    usleep(100)
                                }
                                count+=1
                                //remove person from song artist: song is item
                                removePersonFromSongInDB(son: item, cat: "Mastering Engineer", completion: {err in
                                    //semap.signal()
                                    if let err = err {
                                        completion(err)
                                        return
                                    }
                                    //                                        else {
                                    //                                            completion(nil)
                                    //                                        }
                                })
                                //semap.wait()
                            }
//                        }
                    }
                }
                if let new = newengg["Recording Engineer"] as? [String] {
                    if let old = initialeng["Recording Engineer"] as? [String] {
                        if new != old {
                            let semap = DispatchSemaphore(value: 1)
                            let group = DispatchGroup()
//                            DispatchQueue.global(qos: .userInitiated).async { [weak self] in
//                                guard let strongSelf = self else {return}
                                var count = 0
                                for item in new {
                                    if count != 0 {
                                        usleep(100)
                                    }
                                    count+=1
                                    if !old.contains(item) {
                                        //Add PersonTo song artist: song is item
                                        addPersonToSongInDB(son: item, cat: "Recording Engineer", completion: {err in
                                            //semap.signal()
                                            if let err = err {
                                                completion(err)
                                                return
                                            }
                                            //                                            else {
                                            //                                                completion(nil)
                                            //                                            }
                                        })
                                    }
                                    //semap.wait()
                                }
                            for item in old {
                                if count != 0 {
                                    usleep(100)
                                }
                                count+=1
                                if !new.contains(item) {
                                    //Add PersonTo song artist: song is item
                                    removePersonFromSongInDB(son: item, cat: "Recording Engineer", completion: {err in
                                        //semap.signal()
                                        if let err = err {
                                            completion(err)
                                            return
                                        }
                                        //                                            else {
                                        //                                                completion(nil)
                                        //                                            }
                                    })
                                }
                                //semap.wait()
                            }
//                            }
                        }
                    } else {
                        let semap = DispatchSemaphore(value: 1)
//                        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
//                            guard let strongSelf = self else {return}
                            var count = 0
                            for item in new {
                                if count != 0 {
                                    usleep(100)
                                }
                                count+=1
                                //Add PersonTo song artist: song is item
                                addPersonToSongInDB(son: item, cat: "Recording Engineer", completion: {err in
                                    //semap.signal()
                                    if let err = err {
                                        completion(err)
                                        return
                                    }
                                })
                                //semap.wait()
                            }
//                        }
                    }
                } else if let old = initialeng["Recording Engineer"] as? [String] {
                    if let new = newengg["Recording Engineer"] as? [String] {
                        if new != old {
                            let semap = DispatchSemaphore(value: 1)
//                            DispatchQueue.global(qos: .userInitiated).async { [weak self] in
//                                guard let strongSelf = self else {return}
                                var count = 0
                                for item in old {
                                    if count != 0 {
                                        usleep(100)
                                    }
                                    count+=1
                                    if !new.contains(item) {
                                        //remove person from song artist: song is item
                                        removePersonFromSongInDB(son: item, cat: "Recording Engineer", completion: {err in
                                            //semap.signal()
                                            if let err = err {
                                                completion(err)
                                                return
                                            }
                                        })
                                    }
                                    //semap.wait()
                                }
                            for item in new {
                                if count != 0 {
                                    usleep(100)
                                }
                                count+=1
                                if !old.contains(item) {
                                    //remove person from song artist: song is item
                                    addPersonToSongInDB(son: item, cat: "Recording Engineer", completion: {err in
                                        //semap.signal()
                                        if let err = err {
                                            completion(err)
                                            return
                                        }
                                    })
                                }
                                //semap.wait()
                            }
//                            }
                        }
                    } else {
                        let semap = DispatchSemaphore(value: 1)
                        let group = DispatchGroup()
//                        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
//                            guard let strongSelf = self else {return}
                            var count = 0
                            for item in old {
                                if count != 0 {
                                    usleep(100)
                                }
                                count+=1
                                removePersonFromSongInDB(son: item, cat: "Recording Engineer", completion: {err in
                                    //semap.signal()
                                    if let err = err {
                                        completion(err)
                                        return
                                    }
                                })
                                //semap.wait()
                            }
//                        }
                    }
                }
            } else {
                if let old = oldenggg["Mix Engineer"] as? [String] {
                    let semap = DispatchSemaphore(value: 1)
                    let group = DispatchGroup()
//                    DispatchQueue.global(qos: .userInitiated).async { [weak self] in
//                        guard let strongSelf = self else {return}
                        var count = 0
                        for item in old {
                            
                            //remove person from song artist: song is item
                            removePersonFromSongInDB(son: item, cat: "Mix Engineer", completion: {err in
                                //semap.signal()
                                if let err = err {
                                    completion(err)
                                    return
                                }
                            })
                            //semap.wait()
                        }
//                    }
                }
                if let old = oldenggg["Mastering Engineer"] as? [String] {
                    let semap = DispatchSemaphore(value: 1)
                    let group = DispatchGroup()
//                    DispatchQueue.global(qos: .userInitiated).async { [weak self] in
//                        guard let strongSelf = self else {return}
                        var count = 0
                        for item in old {
                            if count != 0 {
                                usleep(100)
                            }
                            count+=1
                            removePersonFromSongInDB(son: item, cat: "Mastering Engineer", completion: {err in
                                //semap.signal()
                                if let err = err {
                                    completion(err)
                                    return
                                }
                            })
                            //semap.wait()
                        }
//                    }
                }
                if let old = oldenggg["Recording Engineer"] as? [String] {
                    let semap = DispatchSemaphore(value: 1)
                    let group = DispatchGroup()
//                    DispatchQueue.global(qos: .userInitiated).async { [weak self] in
//                        guard let strongSelf = self else {return}
                        var count = 0
                        for item in old {
                            if count != 0 {
                                usleep(100)
                            }
                            count+=1
                            removePersonFromSongInDB(son: item, cat: "Recording Engineer", completion: {err in
                                //semap.signal()
                                if let err = err {
                                    completion(err)
                                    return
                                }
                            })
                            //semap.wait()
                        }
//                    }
                }
            }
        }
        }
        else {
            if let arr = initialRoles["Producer"] as? [String] {
                let semap = DispatchSemaphore(value: 1)
                let group = DispatchGroup()
//                DispatchQueue.global(qos: .userInitiated).async { [weak self] in
//                    guard let strongSelf = self else {return}
                    var count = 0
                    for songg in arr {
                        if count != 0 {
                            usleep(100)
                        }
                        count+=1
                        removePersonFromSongInDB(son: songg, cat: "Producer", completion:{ err in
                            //semap.signal()
                            if let err = err {
                                completion(err)
                                return
                            }
                        })
                        //semap.wait()
                    }
//                }
            }
            if let arr = initialRoles["Writer"] as? [String] {
                let semap = DispatchSemaphore(value: 1)
                let group = DispatchGroup()
//                DispatchQueue.global(qos: .userInitiated).async { [weak self] in
//                    guard let strongSelf = self else {return}
                    var count = 0
                    for songg in arr {
                        if count != 0 {
                            usleep(100)
                        }
                        count+=1
                        removePersonFromSongInDB(son: songg, cat: "Writer", completion:{ err in
                            //semap.signal()
                            if let err = err {
                                completion(err)
                                return
                            }
                        })
                        //semap.wait()
                    }
//                }
            }
            if let engg = initialRoles["Engineer"] as? NSMutableDictionary {
                if let arr = engg["Mix Engineer"] as? [String] {
                    let semap = DispatchSemaphore(value: 1)
                    let group = DispatchGroup()
//                    DispatchQueue.global(qos: .userInitiated).async { [weak self] in
//                        guard let strongSelf = self else {return}
                        var count = 0
                        for songg in arr {
                            if count != 0 {
                                usleep(100)
                            }
                            count+=1
                            removePersonFromSongInDB(son: songg, cat: "Mix Engineer", completion:{ err in
                                //semap.signal()
                                if let err = err {
                                    completion(err)
                                    return
                                }
                            })
                            //semap.wait()
                        }
//                    }
                }
                if let arr = engg["Mastering Engineer"] as? [String] {
                    let semap = DispatchSemaphore(value: 1)
                    let group = DispatchGroup()
//                    DispatchQueue.global(qos: .userInitiated).async { [weak self] in
//                        guard let strongSelf = self else {return}
                        var count = 0
                        for songg in arr {
                            if count != 0 {
                                usleep(100)
                            }
                            count+=1
                            removePersonFromSongInDB(son: songg, cat: "Mastering Engineer", completion:{ err in
                                //semap.signal()
                                if let err = err {
                                    completion(err)
                                    return
                                }
                            })
                            //semap.wait()
                        }
//                    }
                }
                if let arr = engg["Recording Engineer"] as? [String] {
                    let semap = DispatchSemaphore(value: 1)
                    let group = DispatchGroup()
//                    DispatchQueue.global(qos: .userInitiated).async { [weak self] in
//                        guard let strongSelf = self else {return}
                        var count = 0
                        for songg in arr {
                            if count != 0 {
                                usleep(100)
                            }
                            count+=1
                            removePersonFromSongInDB(son: songg, cat: "Recording Engineer", completion:{ err in
                                //semap.signal()
                                if let err = err {
                                    completion(err)
                                    return
                                }
                            })
                            //semap.wait()
                        }
//                    }
                }
                
            }
        }
        
        if initialSongArrFromDB == currPerson.songs {
            completion(nil)
            return
        }
        
        if !initialSongArrFromDB.isEmpty {
            let semaphore = DispatchSemaphore(value: 1)
            var count = 0
            for i in 0 ... initialSongArrFromDB.count-1 {
                if count != 0 {
                    usleep(100)
                }
                count+=1
                if currPerson.songs != nil {
                    if i < currPerson.songs!.count {
                        if !currPerson.songs![i].contains(initialSongArrFromDB[i]) {
                            removePersonFromSongInDB(son: initialSongArrFromDB[i], completion: {err in
                                if let err = err {
                                    completion(err)
                                    return
                                }
                            })
                        } else {
                        }
                    } else {
                        removePersonFromSongInDB(son: initialSongArrFromDB[i], completion: {err in
                            if let err = err {
                                completion(err)
                                return
                            }
                        })
                    }
                } else {
                    removePersonFromSongInDB(son: initialSongArrFromDB[i], completion: {err in
                        if let err = err {
                            completion(err)
                            return
                        }
                    })
                }
//                semaphore.wait()
            }
        }
        
        if currPerson.songs != nil {
            if !currPerson.songs!.isEmpty {
                let semaphore = DispatchSemaphore(value: 1)
                
                let group = DispatchGroup()
                //            DispatchQueue.global(qos: .userInitiated).async { [weak self] in
                //                guard let strongSelf = self else {return}
                var count = 0
                var songcount = 0
                for i in 0 ... currPerson.songs!.count-1 {
                    if count != 0 {
                        usleep(100)
                    }
                    count+=1
                    if i < initialSongArrFromDB.count {
                        if !initialSongArrFromDB[i].contains(currPerson.songs![i]) {
                            addPersonToSongInDB(son: currPerson.songs![i], completion: {[weak self] err in
                                guard let strongSelf = self else {return}
                                //                                semaphore.signal()
                                if let err = err {
                                    completion(err)
                                    return
                                }
                                else {
                                    
                                    songcount+=1
                                    if songcount == strongSelf.currPerson.songs!.count {
                                        completion(nil)
                                    }
                                }
                            })
                        }
                        else {
                            //                            semaphore.signal()
                            songcount+=1
                            if songcount == currPerson.songs!.count {
                                completion(nil)
                            }
                        }
                    } else {
                        addPersonToSongInDB(son: currPerson.songs![i], completion: {[weak self] err in
                            guard let strongSelf = self else {return}
                            //                            semaphore.signal()
                            if let err = err {
                                completion(err)
                                return
                            }else {
                                
                                songcount+=1
                                if songcount == strongSelf.currPerson.songs!.count {
                                    completion(nil)
                                }
                            }
                        })
                    }
                    //                    semaphore.wait()
                }
                //            }
            }
            else {
                completion(nil)
            }
        }
        else {
            completion(nil)
        }
    }
    
    func removePersonFromSongInDB(son: String, completion: @escaping ((Error?) -> Void)) {
        guard son.count == 10 else {
            completion(nil)
            return
        }
        let word = son.split(separator: "Æ")
        let id = word[0]
        DatabaseManager.shared.findSongById(songId: String(id), completion: {[weak self] result in
            guard let strongSelf = self else {return}
            switch result {
            case .success(let song):
                let ref = Database.database().reference().child("Music Content").child("Songs").child( "\(songContentTag)--\(song.name)--\(song.toneDeafAppId)").child("REQUIRED")
                let person = "\(strongSelf.currPerson.toneDeafAppId)"
                if song.songArtist.contains(person) {
                    let index = song.songArtist.firstIndex(of: person)
                    song.songArtist.remove(at: index!)
                }
                if song.songProducers.contains(person) {
                    let index = song.songProducers.firstIndex(of: person)
                    song.songProducers.remove(at: index!)
                }
                if var arrrr = song.songWriters as? [String] {
                    if arrrr.contains(person) {
                        let index = arrrr.firstIndex(of: person)
                        arrrr.remove(at: index!)
                        song.songWriters = arrrr
                    }
                }
                if var arrrr = song.songMixEngineer as? [String] {
                    if arrrr.contains(person) {
                        let index = arrrr.firstIndex(of: person)
                        arrrr.remove(at: index!)
                        song.songMixEngineer = arrrr
                    }
                }
                if var arrrr = song.songMasteringEngineer as? [String] {
                    if arrrr.contains(person) {
                        let index = arrrr.firstIndex(of: person)
                        arrrr.remove(at: index!)
                        song.songMasteringEngineer = arrrr
                    }
                }
                if var arrrr = song.songRecordingEngineer as? [String] {
                    if arrrr.contains(person) {
                        let index = arrrr.firstIndex(of: person)
                        arrrr.remove(at: index!)
                        song.songRecordingEngineer = arrrr
                    }
                }
                let update:[String : Any] = [
                    "Artist": song.songArtist,
                    "Producers": song.songProducers,
                    "Writers": song.songWriters,
                    "Engineers": [
                        "Mix Engineer": song.songMixEngineer,
                        "Mastering Engineer": song.songMasteringEngineer,
                        "Recording Engineer": song.songRecordingEngineer,
                    ]
                ]
                print(String(data: try! JSONSerialization.data(withJSONObject: update, options: .prettyPrinted), encoding: .utf8)!)
                
                ref.updateChildValues(update, withCompletionBlock: { error, reference in
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
    
    func removePersonFromSongInDB(son: String, cat:String, completion: @escaping ((Error?) -> Void)) {
        guard son.count == 10 else {
            completion(nil)
            return
        }
        
        let word = son.split(separator: "Æ")
        let id = word[0]
        DatabaseManager.shared.findSongById(songId: String(id), completion: {[weak self] result in
            guard let strongSelf = self else {return}
            switch result {
            case .success(let song):
                let person = "\(strongSelf.currPerson.toneDeafAppId)"
                var currentArtistRoles:[String] = []
                var initialArtistRoles:[String] = []
                if let ro = strongSelf.currPerson.roles?["Artist"] as? [String] {
                    currentArtistRoles = ro
                }
                if let ro = strongSelf.initialRoles["Artist"] as? [String] {
                    initialArtistRoles = ro
                }
                if initialArtistRoles.contains(son) && !currentArtistRoles.contains(son) {
                    if song.songArtist.contains(strongSelf.currPerson.toneDeafAppId) {
                        let dex = song.songArtist.firstIndex(of: strongSelf.currPerson.toneDeafAppId)
                        song.songArtist.remove(at: dex!)
                    }
                }
                if !initialArtistRoles.contains(son) && currentArtistRoles.contains(son) {
                    if !song.songArtist.contains(strongSelf.currPerson.toneDeafAppId) {
                        song.songArtist.append(strongSelf.currPerson.toneDeafAppId)
                    }
                }
                var ref = Database.database().reference().child("Music Content").child("Songs").child( "\(songContentTag)--\(song.name)--\(song.toneDeafAppId)").child("REQUIRED")
                var arrto:[String]!
                switch cat {
                case "Artist":
                    if let index = song.songArtist.firstIndex(of: person) {
                        song.songArtist.remove(at: index)
                    }
                    arrto = song.songArtist
                    ref = ref.child("Artist")
                    strongSelf.setValueArray(ref: ref, arrto: arrto, completion: { err in
                        if let err = err {
                            print("dsgsrdgvdz z av "+err.localizedDescription)
                        } else {
                            completion(nil)
                        }
                    })
                case "Producer":
                    if let index = song.songProducers.firstIndex(of: person) {
                        song.songProducers.remove(at: index)
                    }
                    arrto = song.songProducers
                    ref = ref.child("Producers")
                    strongSelf.setValueArray(ref: ref, arrto: arrto, completion: { err in
                        if let err = err {
                            print("dsgsrdgvdz z av "+err.localizedDescription)
                        } else {
                            completion(nil)
                        }
                    })
                case "Writer":
                    if var arrrrrrr = song.songWriters as? [String]{
                        if let index = arrrrrrr.firstIndex(of: person) {
                            arrrrrrr.remove(at: index)
                        }
                        song.songWriters = arrrrrrr
                        arrto = song.songWriters
                        ref = ref.child("Writers")
                        strongSelf.setValueArray(ref: ref, arrto: arrto, completion: { err in
                            if let err = err {
                                print("dsgsrdgvdz z av "+err.localizedDescription)
                            } else {
                                completion(nil)
                            }
                        })
                    }
                case "Mix Engineer":
                    if var arrrrrrr = song.songMixEngineer as? [String]{
                        if let index = arrrrrrr.firstIndex(of: person) {
                            arrrrrrr.remove(at: index)
                        }
                        song.songMixEngineer = arrrrrrr
                    }
                    arrto = song.songMixEngineer
                    ref = ref.child("Engineers").child("Mix Engineer")
                    strongSelf.setValueArray(ref: ref, arrto: arrto, completion: { err in
                        if let err = err {
                            print("dsgsrdgvdz z av "+err.localizedDescription)
                        } else {
                            completion(nil)
                        }
                    })
                case "Mastering Engineer":
                    if var arrrrrrr = song.songMasteringEngineer as? [String]{
                        if let index = arrrrrrr.firstIndex(of: person) {
                            arrrrrrr.remove(at: index)
                        }
                        song.songMasteringEngineer = arrrrrrr
                    }
                    arrto = song.songMasteringEngineer
                    ref = ref.child("Engineers").child("Mastering Engineer")
                    strongSelf.setValueArray(ref: ref, arrto: arrto, completion: { err in
                        if let err = err {
                            print("dsgsrdgvdz z av "+err.localizedDescription)
                        } else {
                            completion(nil)
                        }
                    })
                case "Recording Engineer":
                    if var arrrrrrr = song.songRecordingEngineer as? [String]{
                        if let index = arrrrrrr.firstIndex(of: person) {
                            arrrrrrr.remove(at: index)
                        }
                        song.songRecordingEngineer = arrrrrrr
                    }
                    arrto = song.songRecordingEngineer
                    ref = ref.child("Engineers").child("Recording Engineer")
                    strongSelf.setValueArray(ref: ref, arrto: arrto, completion: { err in
                        if let err = err {
                            print("dsgsrdgvdz z av "+err.localizedDescription)
                        } else {
                            completion(nil)
                        }
                    })
                default:
                    break
                }
//                print(String(data: try! JSONSerialization.data(withJSONObject: update, options: .prettyPrinted), encoding: .utf8)!)
            case .failure(let err):
                print("dsvgredfxbdfzx"+err.localizedDescription)
            }
        })
    }
    
    func addPersonToSongInDB(son: String, completion: @escaping ((Error?) -> Void)) {
        guard son.count == 10 else {
            completion(nil)
            return
        }
        let word = son.split(separator: "Æ")
        let id = word[0]
        
        DatabaseManager.shared.findSongById(songId: String(id), completion: {[weak self] result in
            guard let strongSelf = self else {return}
            switch result {
            case .success(let song):
                let ref = Database.database().reference().child("Music Content").child("Songs").child( "\(songContentTag)--\(song.name)--\(song.toneDeafAppId)").child("REQUIRED")
                let person = "\(strongSelf.currPerson.toneDeafAppId)"
                var update:[String : Any] = [
                    "Artist": song.songArtist,
                    "Producers": song.songProducers,
                    "Writers": song.songWriters,
                    "Engineers": [
                        "Mix Engineer": song.songMixEngineer,
                        "Mastering Engineer": song.songMasteringEngineer,
                        "Recording Engineer": song.songRecordingEngineer,
                    ]
                ]
                if let curroo = strongSelf.currPerson.roles {
                    if let roo = curroo["Artist"] as? [String] {
                        if roo.contains(son) {
                            if !song.songArtist.contains(person) {
                                song.songArtist.append(person)
                                update["Artist"] = song.songArtist
                            }
                        }
                    }
                    if let roo = curroo["Producer"] as? [String] {
                        if roo.contains(son) {
                            if !song.songProducers.contains(person) {
                                song.songProducers.append(person)
                                update["Producers"] = song.songProducers
                            }
                        }
                    }
                    if let roo = curroo["Writer"] as? [String] {
                        if var arrrr = song.songWriters as? [String] {
                            if roo.contains(son) {
                                if !arrrr.contains(person) {
                                    arrrr.append(person)
                                    song.songWriters = arrrr
                                    update["Writers"] = song.songWriters
                                }
                            }
                        } else {
                            var arrrr:[String] = []
                            if roo.contains(son) {
                                if !arrrr.contains(person) {
                                    arrrr.append(person)
                                    song.songWriters = arrrr
                                    update["Writers"] = song.songWriters
                                }
                            }
                        }
                    }
                    if let enggg = curroo["Engineer"] as? NSDictionary {
                        let eng = enggg.mutableCopy() as! NSMutableDictionary
                        let engDict:NSMutableDictionary = [
                            "Mix Engineer": song.songMixEngineer,
                            "Mastering Engineer": song.songMasteringEngineer,
                            "Recording Engineer": song.songRecordingEngineer
                        ]
                        if let roo = eng["Mix Engineer"] as? [String] {
                            if var arrrr = song.songMixEngineer as? [String] {
                                if roo.contains(son) {
                                    if !arrrr.contains(person) {
                                        arrrr.append(person)
                                        song.songMixEngineer = arrrr
                                    }
                                }
                            } else {
                                var arrrr:[String] = []
                                if roo.contains(son) {
                                    if !arrrr.contains(person) {
                                        arrrr.append(person)
                                        song.songMixEngineer = arrrr
                                    }
                                }
                            }
                            engDict["Mix Engineer"] = song.songMixEngineer
                        }
                        if let roo = eng["Mastering Engineer"] as? [String] {
                            if var arrrr = song.songMasteringEngineer as? [String] {
                                if roo.contains(son) {
                                    if !arrrr.contains(person) {
                                        arrrr.append(person)
                                        song.songMasteringEngineer = arrrr
                                    }
                                }
                            } else {
                                var arrrr:[String] = []
                                if roo.contains(son) {
                                    if !arrrr.contains(person) {
                                        arrrr.append(person)
                                        song.songMasteringEngineer = arrrr
                                    }
                                }
                            }
                            engDict["Mastering Engineer"] = song.songMasteringEngineer
                        }
                        if let roo = eng["Recording Engineer"] as? [String] {
                            if var arrrr = song.songRecordingEngineer as? [String] {
                                if roo.contains(son) {
                                    if !arrrr.contains(person) {
                                        arrrr.append(person)
                                        song.songRecordingEngineer = arrrr
                                        
                                    }
                                }
                            } else {
                                var arrrr:[String] = []
                                if roo.contains(son) {
                                    if !arrrr.contains(person) {
                                        arrrr.append(person)
                                        song.songRecordingEngineer = arrrr
                                    }
                                }
                            }
                            engDict["Recording Engineer"] = song.songRecordingEngineer
                        }
                        update["Engineers"] = engDict
                    }
                }
//                print(String(data: try! JSONSerialization.data(withJSONObject: update, options: .prettyPrinted), encoding: .utf8)!)
                
                ref.updateChildValues(update, withCompletionBlock: { error, reference in
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
    
    func addPersonToSongInDB(son: String, cat:String, completion: @escaping ((Error?) -> Void)) {
        guard son.count == 10 else {
            completion(nil)
            return
        }
        let word = son.split(separator: "Æ")
        let id = word[0]
//        let semap = DispatchSemaphore(value: 1)
        print(id)
        
        DatabaseManager.shared.findSongById(songId: String(id), completion: {[weak self] result in
            guard let strongSelf = self else {return}
            switch result {
            case .success(let song):
                let person = "\(strongSelf.currPerson.toneDeafAppId)"
                var currentArtistRoles:[String] = []
                var initialArtistRoles:[String] = []
                if let ro = strongSelf.currPerson.roles?["Artist"] as? [String] {
                    currentArtistRoles = ro
                }
                if let ro = strongSelf.initialRoles["Artist"] as? [String] {
                    initialArtistRoles = ro
                }
                if initialArtistRoles.contains(son) && !currentArtistRoles.contains(son) {
                    if song.songArtist.contains(strongSelf.currPerson.toneDeafAppId) {
                        let dex = song.songArtist.firstIndex(of: strongSelf.currPerson.toneDeafAppId)
                        song.songArtist.remove(at: dex!)
                    }
                }
                if !initialArtistRoles.contains(son) && currentArtistRoles.contains(son) {
                    if !song.songArtist.contains(strongSelf.currPerson.toneDeafAppId) {
                        song.songArtist.append(strongSelf.currPerson.toneDeafAppId)
                    }
                }
                var ref = Database.database().reference().child("Music Content").child("Songs").child( "\(songContentTag)--\(song.name)--\(song.toneDeafAppId)").child("REQUIRED")
                var arrto:[String]!
                switch cat {
                case "Artist":
                    if !song.songArtist.contains(person) {
                        song.songArtist.append(person)
                    }
                    arrto = song.songArtist
                    ref = ref.child("Artist")
                    strongSelf.setValueArray(ref: ref, arrto: arrto, completion: { err in
                        if let err = err {
                            print("dsgsrdgvdz z av "+err.localizedDescription)
                        } else {
                            completion(nil)
                        }
                    })
                case "Producer":
                    if !song.songProducers.contains(person) {
                        song.songProducers.append(person)
                    }
                    arrto = song.songProducers
                    ref = ref.child("Producers")
                    strongSelf.setValueArray(ref: ref, arrto: arrto, completion: { err in
                        if let err = err {
                            print("dsgsrdgvdz z av "+err.localizedDescription)
                        } else {
                            completion(nil)
                        }
                    })
                case "Writer":
                    if var arrrrrrr = song.songWriters as? [String]{
                        if !arrrrrrr.contains(person) {
                            arrrrrrr.append(person)
                            song.songWriters = arrrrrrr
                        }
                    } else {
                        song.songWriters = [person]
                    }
                    arrto = song.songWriters
                    ref = ref.child("Writers")
                    strongSelf.setValueArray(ref: ref, arrto: arrto, completion: { err in
                        if let err = err {
                            print("dsgsrdgvdz z av "+err.localizedDescription)
                        } else {
                            completion(nil)
                        }
                    })
                case "Mix Engineer":
                    if var arrrrrrr = song.songMixEngineer as? [String]{
                        if !arrrrrrr.contains(person) {
                            arrrrrrr.append(person)
                            song.songMixEngineer = arrrrrrr
                        }
                    } else {
                        song.songMixEngineer = [person]
                    }
                    arrto = song.songMixEngineer
                    ref = ref.child("Engineers").child("Mix Engineer")
                    strongSelf.setValueArray(ref: ref, arrto: arrto, completion: { err in
                        if let err = err {
                            print("dsgsrdgvdz z av "+err.localizedDescription)
                        } else {
                            completion(nil)
                        }
                    })
                case "Mastering Engineer":
                    if var arrrrrrr = song.songMasteringEngineer as? [String]{
                        if !arrrrrrr.contains(person) {
                            arrrrrrr.append(person)
                            song.songMasteringEngineer = arrrrrrr
                        }
                    } else {
                        song.songMasteringEngineer = [person]
                    }
                    arrto = song.songMasteringEngineer
                    ref = ref.child("Engineers").child("Mastering Engineer")
                    strongSelf.setValueArray(ref: ref, arrto: arrto, completion: { err in
                        if let err = err {
                            print("dsgsrdgvdz z av "+err.localizedDescription)
                        } else {
                            completion(nil)
                        }
                    })
                case "Recording Engineer":
                    if var arrrrrrr = song.songRecordingEngineer as? [String]{
                        if !arrrrrrr.contains(person) {
                            arrrrrrr.append(person)
                            song.songRecordingEngineer = arrrrrrr
                        }
                    } else {
                        song.songRecordingEngineer = [person]
                    }
                    arrto = song.songRecordingEngineer
                    ref = ref.child("Engineers").child("Recording Engineer")
                    strongSelf.setValueArray(ref: ref, arrto: arrto, completion: { err in
                        if let err = err {
                            print("dsgsrdgvdz z av "+err.localizedDescription)
                        } else {
                            completion(nil)
                        }
                    })
                default:
                    break
                }
//                print(String(data: try! JSONSerialization.data(withJSONObject: update, options: .prettyPrinted), encoding: .utf8)!)
            case .failure(let err):
                print("dsvgredfxbdfzx"+err.localizedDescription)
            }
        })
    }
    
    func updateSongAlbumSongs(ref: DatabaseReference, initialRoles:NSMutableDictionary , completion: @escaping ((Error?) -> Void)) {
        guard currPerson.roles != initialRoles else {
            completion(nil)
            return
        }
        var initialeng:NSMutableDictionary!
        var totalProgress:Int = 0
        var completedProgress:Int = 0
        if let eng = initialRoles["Engineer"] as? NSDictionary {
            initialeng = eng.mutableCopy() as! NSMutableDictionary
        }
        
        getPersonSongsInDB(ref: ref, completion: {[weak self] songs in
            guard let strongSelf = self else {return}
            
            //MARK: - Progress Setup
            if let ro = strongSelf.currPerson.roles {
                
                if let newenggg = (ro["Engineer"] as? NSDictionary) {
                    strongSelf.currentEngRoles = newenggg
                } else {
                    strongSelf.currentEngRoles = nil
                }
                if let new = ro["Artist"] as? [String] {
                    if let old = initialRoles["Artist"] as? [String] {
                        if old != new {
                            for item in new {
                                if !old.contains(item) {
                                    totalProgress+=1
                                }
                            }
                            for item in old {
                                if !new.contains(item) {
                                    totalProgress+=1
                                }
                            }
                        }
                    } else {
                            for item in new {
                                totalProgress+=1
                            }
                    }
                } else if let old = initialRoles["Artist"] as? [String] {
                    if let new = ro["Artist"] as? [String] {
                        for item in old {
                            if !new.contains(item) {
                                totalProgress+=1
                            }
                        }
                    } else {
                            for item in old {
                                totalProgress+=1
                            }
                    }
                }
                if let new = ro["Producer"] as? [String] {
                    
                    if let old = initialRoles["Producer"] as? [String] {
                        if new != old {
                            for item in new {
                                if !old.contains(item) {
                                    totalProgress+=1
                                }
                            }
                            for item in old {
                                if !new.contains(item) {
                                    totalProgress+=1
                                }
                            }
                        }
                    } else {
                            for item in new {
                                totalProgress+=1
                            }
                    }
                } else if let old = initialRoles["Producer"] as? [String] {
                    if let new = ro["Producer"] as? [String] {
                        if old != new {
                            for item in old {
                                if !new.contains(item) {
                                    totalProgress+=1
                                }
                            }
                        for item in new {
                            if !old.contains(item) {
                                totalProgress+=1
                            }
                        }
                        }
                    } else {
                            for item in old {
                                totalProgress+=1
                            }
                    }
                }
                if let new = ro["Writer"] as? [String] {
                    if let old = initialRoles["Writer"] as? [String] {
                        if new != old {
                            for item in new {
                                if !old.contains(item) {
                                    totalProgress+=1
                                }
                            }
                            for item in old {
                                if !new.contains(item) {
                                    totalProgress+=1
                                }
                            }
                        }
                    } else {
                        for item in new {
                            totalProgress+=1
                        }
                    }
                } else if let old = initialRoles["Writer"] as? [String] {
                    if let new = ro["Writer"] as? [String] {
                        if new != old {
                            for item in old {
                                if !new.contains(item) {
                                    totalProgress+=1
                                }
                            }
                        for item in new {
                            if !old.contains(item) {
                                totalProgress+=1
                            }
                        }
                        }
                    } else {
                            for item in old {
                                totalProgress+=1
                            }
                    }
                }
                if let newenggg = (strongSelf.currentEngRoles as? NSDictionary) {
                    
                    let newengg = newenggg.mutableCopy() as! NSMutableDictionary
                    if newengg.count > 0 {
                        
                    if let new = newengg["Mix Engineer"] as? [String] {
                        if let inieng = initialeng as? NSDictionary {
                            let initeng = inieng.mutableCopy() as! NSMutableDictionary
                            
                            if let old = initeng["Mix Engineer"] as? [String] {
                                
                                if new != old {
                                        for item in new {
                                            if !old.contains(item) {
                                                totalProgress+=1
                                            }
                                        }
                                    for item in old {
                                        if !new.contains(item) {
                                            totalProgress+=1
                                        }
                                    }
                                }
                            } else {
                                    for item in new {
                                        totalProgress+=1
                                    }
        //                        }
                            }
                        } else {
                                for item in new {
                                    totalProgress+=1
                                }
                        }
                    }
                        else if let inieng = initialeng as? NSDictionary {
                            let initeng = inieng.mutableCopy() as! NSMutableDictionary
                            if let old = initeng["Mix Engineer"] as? [String] {
                                if let new = newengg["Mix Engineer"] as? [String] {
                                    
                                    if new != old {
                                        for item in old {
                                            if !new.contains(item) {
                                                totalProgress+=1
                                            }
                                        }
                                        for item in new {
                                            if !old.contains(item) {
                                                totalProgress+=1
                                            }
                                        }
                                    }
                                } else {
                                    let semap = DispatchSemaphore(value: 1)
                                        for item in old {
                                            totalProgress+=1
                                        }
                                }
                        }
                    }
                        
                        
                        if let new = newengg["Mastering Engineer"] as? [String] {
                            if let inieng = initialeng as? NSDictionary {
                                let initeng = inieng.mutableCopy() as! NSMutableDictionary
                                if let old = initeng["Mastering Engineer"] as? [String] {
                                    if new != old {
                                        for item in new {
                                            if !old.contains(item) {
                                                totalProgress+=1
                                            }
                                        }
                                        for item in old {
                                            if !new.contains(item) {
                                                totalProgress+=1
                                            }
                                        }
                                    }
                                } else {
                                    for item in new {
                                        totalProgress+=1
                                    }
                                }
                            } else {
                                for item in new {
                                    totalProgress+=1
                                }
                            }
                        }
                        else if let inieng = initialeng as? NSDictionary {
                            let initeng = inieng.mutableCopy() as! NSMutableDictionary
                            if let old = initeng["Mastering Engineer"] as? [String] {
                                if let new = newengg["Mastering Engineer"] as? [String] {
                                    
                                    if new != old {
                                        for item in old {
                                            if !new.contains(item) {
                                                totalProgress+=1
                                            }
                                        }
                                        for item in new {
                                            if !old.contains(item) {
                                                totalProgress+=1
                                            }
                                        }
                                    }
                                } else {
                                        for item in old {
                                            totalProgress+=1
                                        }
                                }
                            }
                        }
                        
                        if let new = newengg["Recording Engineer"] as? [String] {
                            if let inieng = initialeng as? NSDictionary {
                                let initeng = inieng.mutableCopy() as! NSMutableDictionary
                                if let old = initeng["Recording Engineer"] as? [String] {
                                    
                                    if new != old {
                                            for item in new {
                                                if !old.contains(item) {
                                                    totalProgress+=1
                                                }
                                            }
                                        for item in old {
                                            if !new.contains(item) {
                                                totalProgress+=1
                                            }
                                        }
                                    }
                                } else {
                                        for item in new {
                                            totalProgress+=1
                                        }
                                }
                            } else {
                                    for item in new {
                                        totalProgress+=1
                                    }
                            }
                        }
                        else if let inieng = initialeng as? NSDictionary {
                            let initeng = inieng.mutableCopy() as! NSMutableDictionary
                            if let old = initeng["Recording Engineer"] as? [String] {
                                if let new = newengg["Recording Engineer"] as? [String] {
                                    if new != old {
                                            for item in old {
                                                if !new.contains(item) {
                                                    totalProgress+=1
                                                }
                                            }
                                        for item in new {
                                            if !old.contains(item) {
                                                totalProgress+=1
                                            }
                                        }
                                    }
                                } else {
                                        for item in old {
                                            totalProgress+=1
                                        }
                                }
                            }
                        }
                    }
                    
                } else if let oldenggg = initialRoles["Engineer"] as? NSDictionary {
                    let oldnegg = oldenggg.mutableCopy() as! NSMutableDictionary
                    if let newengg = ro["Engineer"] as? NSMutableDictionary {
                        if let new = newengg["Mix Engineer"] as? [String] {
                            if let old = initialeng["Mix Engineer"] as? [String] {
                                if new != old {
                                        for item in new {
                                            if !old.contains(item) {
                                                totalProgress+=1
                                            }
                                        }
                                    for item in old {
                                        if !new.contains(item) {
                                            totalProgress+=1
                                        }
                                    }
                                }
                            } else {
                                    for item in new {
                                        totalProgress+=1
                                    }
                            }
                        } else if let old = initialeng["Mix Engineer"] as? [String] {
                            if let new = newengg["Mix Engineer"] as? [String] {
                                if new != old {
                                        for item in old {
                                            if !new.contains(item) {
                                                totalProgress+=1
                                            }
                                        }
                                    for item in new {
                                        if !old.contains(item) {
                                            totalProgress+=1
                                        }
                                    }
                                }
                            } else {
                                    for item in old {
                                        totalProgress+=1
                                    }
                            }
                        }
                        if let new = newengg["Mastering Engineer"] as? [String] {
                            
                            if let old = initialeng["Mastering Engineer"] as? [String] {
                                if new != old {
                                    for item in new {
                                        if !old.contains(item) {
                                            totalProgress+=1
                                        }
                                    }
                                    for item in old {
                                        if !new.contains(item) {
                                            totalProgress+=1
                                        }
                                    }
                                }
                            } else {
                                    for item in new {
                                        totalProgress+=1
                                    }
                            }
                        } else if let old = initialeng["Mastering Engineer"] as? [String] {
                            if let new = newengg["Mastering Engineer"] as? [String] {
                                if new != old {
                                        for item in old {
                                            if !new.contains(item) {
                                                totalProgress+=1
                                            }
                                        }
                                    for item in new {
                                        if !old.contains(item) {
                                            totalProgress+=1
                                        }
                                    }
                                }
                            } else {
                                    for item in old {
                                        totalProgress+=1
                                    }
                            }
                        }
                        if let new = newengg["Recording Engineer"] as? [String] {
                            if let old = initialeng["Recording Engineer"] as? [String] {
                                if new != old {
                                        for item in new {
                                            if !old.contains(item) {
                                                totalProgress+=1
                                            }
                                        }
                                    for item in old {
                                        if !new.contains(item) {
                                            
                                            totalProgress+=1
                                        }
                                    }
                                }
                            } else {
                                    for item in new {
                                        totalProgress+=1
                                    }
                            }
                        } else if let old = initialeng["Recording Engineer"] as? [String] {
                            if let new = newengg["Recording Engineer"] as? [String] {
                                if new != old {
                                        for item in old {
                                            if !new.contains(item) {
                                                totalProgress+=1
                                            }
                                        }
                                    for item in new {
                                        if !old.contains(item) {
                                            totalProgress+=1
                                        }
                                    }
                                }
                            } else {
                                    for item in old {
                                        totalProgress+=1
                                    }
                            }
                        }
                    } else {
                        if let old = oldenggg["Mix Engineer"] as? [String] {
                                for item in old {
                                    totalProgress+=1
                                }
                        }
                        if let old = oldenggg["Mastering Engineer"] as? [String] {
                                for item in old {
                                    totalProgress+=1
                                }
                        }
                        if let old = oldenggg["Recording Engineer"] as? [String] {
                                for item in old {
                                    totalProgress+=1
                                }
                        }
                    }
                }
                
                
            }
            else {
                if let arr = initialRoles["Artist"] as? [String] {
                    for songg in arr {
                        totalProgress+=1
                    }
                }
                if let arr = initialRoles["Producer"] as? [String] {
                    for songg in arr {
                        totalProgress+=1
                    }
                }
                if let arr = initialRoles["Writer"] as? [String] {
                    for songg in arr {
                        totalProgress+=1
                    }
                }
                if let engg = initialRoles["Engineer"] as? NSMutableDictionary {
                    if let arr = engg["Mix Engineer"] as? [String] {
                        for songg in arr {
                            totalProgress+=1
                        }
                    }
                    if let arr = engg["Mastering Engineer"] as? [String] {
                        for songg in arr {
                            totalProgress+=1
                        }
                    }
                    if let arr = engg["Recording Engineer"] as? [String] {
                        for songg in arr {
                            totalProgress+=1
                        }
                    }
                    
                }
            }
            if totalProgress == 0 {
                completion(nil)
                return
            }
            
            //MARK: - Function
            if let ro = strongSelf.currPerson.roles {
                
                if let newenggg = (ro["Engineer"] as? NSDictionary) {
                    strongSelf.currentEngRoles = newenggg
                } else {
                    strongSelf.currentEngRoles = nil
                }
                if let new = ro["Artist"] as? [String] {
                    
                    if let old = initialRoles["Artist"] as? [String] {
                        let semap = DispatchSemaphore(value: 1)
                            var count = 0
                        
                        if old != new {
                            for item in new {
                                if count != 0 {
                                    usleep(100)
                                }
                                count+=1
                                if !old.contains(item) {
                                    strongSelf.updateSongAlbumSongs(son: item, cat: "Add", completion: {err in
                                        completedProgress+=1
                                        if let err = err {
                                            completion(err)
                                            return
                                        } else {
                                            if completedProgress == (totalProgress) {
                                                completion(nil)
                                                return
                                            }
                                        }
                                    })
                                }
                                print("arcount ", count, new.count)
//                                semap.wait()
                            }
                            for item in old {
                                
                                if count != 0 {
                                    usleep(100)
                                }
                                count+=1
                                if !new.contains(item) {
                                        strongSelf.updateSongAlbumSongs(son: item, cat: "Remove", completion: {err in
                                            completedProgress+=1
                                            if let err = err {
                                                completion(err)
                                                return
                                            } else {
                                                if completedProgress == (totalProgress) {
                                                    completion(nil)
                                                    return
                                                }
                                            }
                                        })
                                }
                                print("aroldcount ", count, old.count)
                                //                                semap.wait()
                            }
                        }
                        //                        }
                    } else {
                        let semap = DispatchSemaphore(value: 1)
//                        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
//                            guard let strongSelf = self else {return}
                            var count = 0
                            for item in new {
                                if count != 0 {
                                    usleep(100)
                                }
                                count+=1
                                    strongSelf.updateSongAlbumSongs(son: item, cat: "Add", completion: {err in
                                        completedProgress+=1
                                        if let err = err {
                                            completion(err)
                                            return
                                        } else {
                                            if completedProgress == (totalProgress) {
                                                completion(nil)
                                                return
                                            }
                                        }
                                    })
                                //semap.wait()
                            }
//                        }
                    }
                } else if let old = initialRoles["Artist"] as? [String] {
                    if let new = ro["Artist"] as? [String] {
                        let semap = DispatchSemaphore(value: 1)
//                        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
//                            guard let strongSelf = self else {return}
                            var count = 0
                        for item in old {
                            if count != 0 {
                                usleep(100)
                            }
                            count+=1
                            if !new.contains(item) {
                                strongSelf.updateSongAlbumSongs(son: item, cat: "Remove", completion: {err in
                                    completedProgress+=1
                                    if let err = err {
                                        completion(err)
                                        return
                                    } else {
                                        if completedProgress == (totalProgress) {
                                            completion(nil)
                                            return
                                        }
                                    }
                                })
                                //semap.wait()
                            }
                        }
                        //                        }
                    } else {
                        
                        let semap = DispatchSemaphore(value: 1)
//                        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
//                            guard let strongSelf = self else {return}
                            var count = 0
                            for item in old {
                                if count != 0 {
                                    usleep(100)
                                }
                                count+=1
                                    strongSelf.updateSongAlbumSongs(son: item, cat: "Remove", completion: {err in
                                        completedProgress+=1
                                        if let err = err {
                                            completion(err)
                                            return
                                        } else {
                                            if completedProgress == (totalProgress) {
                                                completion(nil)
                                                return
                                            }
                                        }
                                    })
                                //semap.wait()
                            }
                        //                        }
                    }
                }
                if let new = ro["Producer"] as? [String] {
                    
                    if let old = initialRoles["Producer"] as? [String] {
                        if new != old {
                            var count = 0
                            for item in new {
                                if count != 0 {
                                    usleep(100)
                                }
                                count+=1
                                if !old.contains(item) {
                                        strongSelf.updateSongAlbumSongs(son: item, cat: "Add", completion: {err in
                                            completedProgress+=1
                                            if let err = err {
                                                completion(err)
                                                return
                                            } else {
                                                if completedProgress == (totalProgress) {
                                                    completion(nil)
                                                    return
                                                }
                                            }
                                        })
                                }
                                if new.count != 1 {
        //                            //semap.wait()
                                }
                            }
                            for item in old {
                                if count != 0 {
                                    usleep(100)
                                }
                                count+=1
                                if !new.contains(item) {
                                    strongSelf.updateSongAlbumSongs(son: item, cat: "Remove", completion: {err in
                                        completedProgress+=1
                                        if let err = err {
                                            completion(err)
                                            return
                                        } else {
                                            if completedProgress == (totalProgress) {
                                                completion(nil)
                                                return
                                            }
                                        }
                                    })
                                }
                                if old.count != 1 {
                                    //semap.wait()
                                }
                            }
                        }
                    } else {
                        let semap = DispatchSemaphore(value: 1)
                        let group = DispatchGroup()
        //                DispatchQueue.global(qos: .userInitiated).async { [weak self] in
        //                    guard let strongSelf = self else {return}
                            var count = 0
                            for item in new {
                                if count != 0 {
                                    usleep(100)
                                }
                                count+=1
                                strongSelf.updateSongAlbumSongs(son: item, cat: "Add", completion: {err in
                                    completedProgress+=1
                                    
                                    if let err = err {
                                        completion(err)
                                        return
                                    } else {
                                        if completedProgress == (totalProgress) {
                                            completion(nil)
                                            return
                                        }
                                    }
                                })
                                //semap.wait()
                            }
        //                }
                    }
                } else if let old = initialRoles["Producer"] as? [String] {
                    if let new = ro["Producer"] as? [String] {
                        let semap = DispatchSemaphore(value: 1)
                        let group = DispatchGroup()
        //                DispatchQueue.global(qos: .userInitiated).async { [weak self] in
        //                    guard let strongSelf = self else {return}
                            var count = 0
                        if old != new {
                            for item in old {
                                if count != 0 {
                                    usleep(100)
                                }
                                count+=1
                                if !new.contains(item) {
                                    //remove person from song artist: song is item
                                    strongSelf.updateSongAlbumSongs(son: item, cat: "Remove", completion: {err in
                                        completedProgress+=1
                                        if let err = err {
                                            completion(err)
                                            return
                                        } else {
                                            if completedProgress == (totalProgress) {
                                                completion(nil)
                                            }
                                        }
                                    })
                                }
                                //semap.wait()
                            }
                        for item in new {
                            if count != 0 {
                                usleep(100)
                            }
                            count+=1
                            if !old.contains(item) {
                                //remove person from song artist: song is item
                                
                                strongSelf.updateSongAlbumSongs(son: item, cat: "Add", completion: {err in
                                    completedProgress+=1
                                    if let err = err {
                                        completion(err)
                                        return
                                    } else {
                                        if completedProgress == (totalProgress) {
                                            completion(nil)
                                        }
                                    }
                                })
                            }
                            //semap.wait()
                        }
                        }
        //                }
                    } else {
                        let semap = DispatchSemaphore(value: 1)
                        let group = DispatchGroup()
        //                DispatchQueue.global(qos: .userInitiated).async { [weak self] in
        //                    guard let strongSelf = self else {return}
                            var count = 0
                            for item in old {
                                if count != 0 {
                                    usleep(100)
                                }
                                count+=1
                                strongSelf.updateSongAlbumSongs(son: item, cat: "Remove", completion: {err in
                                    completedProgress+=1
                                    if let err = err {
                                        completion(err)
                                        return
                                    } else {
                                        if completedProgress == (totalProgress) {
                                            completion(nil)
                                            return
                                        }
                                    }
                                })
                                //semap.wait()
                            }
        //                }
                    }
                }
                if let new = ro["Writer"] as? [String] {
                    if let old = initialRoles["Writer"] as? [String] {
                        let semap = DispatchSemaphore(value: 1)
                        let group = DispatchGroup()
        //                DispatchQueue.global(qos: .userInitiated).async { [weak self] in
        //                    guard let strongSelf = self else {return}
                            var count = 0
                        if new != old {
                            for item in new {
                                if count != 0 {
                                    usleep(100)
                                }
                                count+=1
                                if !old.contains(item) {
                                    strongSelf.updateSongAlbumSongs(son: item, cat: "Add", completion: {err in
                                        completedProgress+=1
                                        if let err = err {
                                            completion(err)
                                            return
                                        } else {
                                            if completedProgress == (totalProgress) {
                                                completion(nil)
                                                return
                                            }
                                        }
                                    })
                                }
                                if new.count != 1 {
                                    //semap.wait()
                                }
                            }
                            for item in old {
                                if count != 0 {
                                    usleep(100)
                                }
                                count+=1
                                if !new.contains(item) {
                                    strongSelf.updateSongAlbumSongs(son: item, cat: "Remove", completion: {err in
                                        completedProgress+=1
                                        if let err = err {
                                            completion(err)
                                            return
                                        } else {
                                            //
                                            if completedProgress == (totalProgress) {
                                                completion(nil)
                                                return
                                            }
                                        }
                                    })
                                }
                                if old.count != 1 {
                                    //semap.wait()
                                }
                            }
                        }
        //                }
                    } else {
                        let semap = DispatchSemaphore(value: 1)
                        let group = DispatchGroup()
        //                DispatchQueue.global(qos: .userInitiated).async { [weak self] in
        //                    guard let strongSelf = self else {return}
                            var count = 0
                            for item in new {
                                if count != 0 {
                                    usleep(100)
                                }
                                count+=1
                                //Add PersonTo song artist: song is item
                                strongSelf.updateSongAlbumSongs(son: item, cat: "Add", completion: {err in
                                    completedProgress+=1
                                    if let err = err {
                                        completion(err)
                                        return
                                    } else {
                                        if completedProgress == (totalProgress) {
                                            completion(nil)
                                            return
                                        }
                                    }
                                })
                                //semap.wait()
                            }
        //                }
                    }
                } else if let old = initialRoles["Writer"] as? [String] {
                    if let new = ro["Writer"] as? [String] {
                        let semap = DispatchSemaphore(value: 1)
                        let group = DispatchGroup()
        //                DispatchQueue.global(qos: .userInitiated).async { [weak self] in
        //                    guard let strongSelf = self else {return}
                            var count = 0
                        if new != old {
                            for item in old {
                                if count != 0 {
                                    usleep(100)
                                }
                                count+=1
                                if !new.contains(item) {
                                    strongSelf.updateSongAlbumSongs(son: item, cat: "Remove", completion: {err in
                                        completedProgress+=1
                                        if let err = err {
                                            completion(err)
                                            return
                                        } else {
                                            if completedProgress == (totalProgress) {
                                                completion(nil)
                                                return
                                            }
                                        }
                                    })
                                }
                                //semap.wait()
                            }
                        for item in new {
                            if count != 0 {
                                usleep(100)
                            }
                            count+=1
                            if !old.contains(item) {
                                strongSelf.updateSongAlbumSongs(son: item, cat: "Add", completion: {err in
                                    completedProgress+=1
                                    if let err = err {
                                        completion(err)
                                        return
                                    } else {
                                        if completedProgress == (totalProgress) {
                                            completion(nil)
                                            return
                                        }
                                    }
                                })
                            }
                            //semap.wait()
                        }
                        }
        //                }
                    } else {
                        let semap = DispatchSemaphore(value: 1)
                        let group = DispatchGroup()
        //                DispatchQueue.global(qos: .userInitiated).async { [weak self] in
        //                    guard let strongSelf = self else {return}
                            var count = 0
                            for item in old {
                                if count != 0 {
                                    usleep(100)
                                }
                                count+=1
                                strongSelf.updateSongAlbumSongs(son: item, cat: "Remove", completion: {err in
                                    completedProgress+=1
                                    if let err = err {
                                        completion(err)
                                        return
                                    } else {
                                        if completedProgress == (totalProgress) {
                                            completion(nil)
                                            return
                                        }
                                    }
                                })
                                //semap.wait()
                            }
        //                }
                    }
                }
                if let newenggg = (strongSelf.currentEngRoles as? NSDictionary) {
                    
                    let newengg = newenggg.mutableCopy() as! NSMutableDictionary
                    if newengg.count > 0 {
                        
                    if let new = newengg["Mix Engineer"] as? [String] {
                        if let inieng = initialeng as? NSDictionary {
                            let initeng = inieng.mutableCopy() as! NSMutableDictionary
                            
                            if let old = initeng["Mix Engineer"] as? [String] {
                                
                                if new != old {
                                    
                                    let semap = DispatchSemaphore(value: 1)
        //                            DispatchQueue.global(qos: .userInitiated).async { [weak self] in
        //                                guard let strongSelf = self else {return}
                                        var count = 0
                                        for item in new {
                                            if count != 0 {
                                                usleep(100)
                                            }
                                            count+=1
                                            if !old.contains(item) {
                                                strongSelf.updateSongAlbumSongs(son: item, cat: "Add", completion: {err in
                                                    completedProgress+=1
                                                    if let err = err {
                                                        completion(err)
                                                        return
                                                    } else {
                                                        if completedProgress == (totalProgress) {
                                                            completion(nil)
                                                        }
                                                    }
                                                })
                                            }
                                        }
                                    for item in old {
                                        
                                        if count != 0 {
                                            usleep(100)
                                        }
                                        count+=1
                                        
                                        if !new.contains(item) {
                                            strongSelf.updateSongAlbumSongs(son: item, cat: "Remove", completion: {err in
                                                completedProgress+=1
                                                if let err = err {
                                                    completion(err)
                                                    return
                                                } else {
                                                    if completedProgress == (totalProgress) {
                                                        completion(nil)
                                                    }
                                                }
                                            })
                                        }
                                        if old.count != 1 {
                                            //semap.wait()
                                        }
                                    }
        //                            }
                                }
                            } else {
                                let semap = DispatchSemaphore(value: 1)
                                let group = DispatchGroup()
        //                        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
        //                            guard let strongSelf = self else {return}
                                    var count = 0
                                    for item in new {
                                        if count != 0 {
                                            usleep(100)
                                        }
                                        count+=1
                                        strongSelf.updateSongAlbumSongs(son: item, cat: "Add", completion: {err in
                                            completedProgress+=1
                                            if let err = err {
                                                completion(err)
                                                return
                                            } else {
                                                if completedProgress == (totalProgress) {
                                                    completion(nil)
                                                }
                                            }
                                        })
                                        //semap.wait()
                                    }
        //                        }
                            }
                        } else {
                            let semap = DispatchSemaphore(value: 1)
        //                    DispatchQueue.global(qos: .userInitiated).async { [weak self] in
        //                        guard let strongSelf = self else {return}
                                var count = 0
                                for item in new {
                                    if count != 0 {
                                        usleep(100)
                                    }
                                    count+=1
                                    strongSelf.updateSongAlbumSongs(son: item, cat: "Add", completion: {err in
                                        completedProgress+=1
                                        if let err = err {
                                            completion(err)
                                            return
                                        } else {
                                            if completedProgress == (totalProgress) {
                                                completion(nil)
                                                return
                                            }
                                        }
                                    })
                                }
        //                    }
                        }
                    }
                        else if let inieng = initialeng as? NSDictionary {
                            let initeng = inieng.mutableCopy() as! NSMutableDictionary
                            if let old = initeng["Mix Engineer"] as? [String] {
                                if let new = newengg["Mix Engineer"] as? [String] {
                                    
                                    if new != old {
                                        let semap = DispatchSemaphore(value: 1)
        //                                DispatchQueue.global(qos: .userInitiated).async { [weak self] in
        //                                    guard let strongSelf = self else {return}
                                            var count = 0
                                        for item in old {
                                            if count != 0 {
                                                usleep(100)
                                            }
                                            count+=1
                                            if !new.contains(item) {
                                                strongSelf.updateSongAlbumSongs(son: item, cat: "Remove", completion: {err in
                                                    completedProgress+=1
                                                    if let err = err {
                                                        completion(err)
                                                        return
                                                    } else {
                                                        if completedProgress == (totalProgress) {
                                                            completion(nil)
                                                            return
                                                        }
                                                    }
                                                })
                                            }
                                            //semap.wait()
                                            }
                                        for item in new {
                                            if count != 0 {
                                                usleep(100)
                                            }
                                            count+=1
                                            if !old.contains(item) {
                                                strongSelf.updateSongAlbumSongs(son: item, cat: "Add", completion: {err in
                                                    completedProgress+=1
                                                    if let err = err {
                                                        completion(err)
                                                        return
                                                    } else {
                                                        if completedProgress == (totalProgress) {
                                                            completion(nil)
                                                            return
                                                        }
                                                    }
                                                })
                                            }
                                            //semap.wait()
                                            }
        //                                }
                                    }
                                } else {
                                    let semap = DispatchSemaphore(value: 1)
        //                            DispatchQueue.global(qos: .userInitiated).async { [weak self] in
        //                                guard let strongSelf = self else {return}
                                        var count = 0
                                        for item in old {
                                            if count != 0 {
                                                usleep(100)
                                            }
                                            count+=1
                                            strongSelf.updateSongAlbumSongs(son: item, cat: "Remove", completion: {err in
                                                completedProgress+=1
                                                if let err = err {
                                                    completion(err)
                                                    return
                                                } else {
                                                    if completedProgress == (totalProgress) {
                                                        completion(nil)
                                                        return
                                                    }
                                                }
                                            })
                                            //semap.wait()
                                        }
        //                            }
                                }
                        }
                    }
                        
                        
                        if let new = newengg["Mastering Engineer"] as? [String] {
                            if let inieng = initialeng as? NSDictionary {
                                let initeng = inieng.mutableCopy() as! NSMutableDictionary
                                if let old = initeng["Mastering Engineer"] as? [String] {
                                    let semap = DispatchSemaphore(value: 1)
        //                            DispatchQueue.global(qos: .userInitiated).async { [weak self] in
        //                                guard let strongSelf = self else {return}
                                        var count = 0
                                    if new != old {
                                        for item in new {
                                            if count != 0 {
                                                usleep(100)
                                            }
                                            count+=1
                                            if !old.contains(item) {
                                                strongSelf.updateSongAlbumSongs(son: item, cat: "Add", completion: {err in
                                                    completedProgress+=1
                                                    if let err = err {
                                                        completion(err)
                                                        return
                                                    } else {
                                                        if completedProgress == (totalProgress) {
                                                            completion(nil)
                                                        }
                                                    }
                                                })
                                            }
                                            if new.count != 1 {
        //                                    //semap.wait()
                                            }
                                        }
                                        for item in old {
                                            if count != 0 {
                                                usleep(100)
                                            }
                                            count+=1
                                            if !new.contains(item) {
                                                //Add PersonTo song artist: song is item
                                                strongSelf.updateSongAlbumSongs(son: item, cat: "Remove", completion: {err in
                                                    completedProgress+=1
                                                    if let err = err {
                                                        completion(err)
                                                        return
                                                    } else {
                                                        if completedProgress == (totalProgress) {
                                                            completion(nil)
                                                        }
                                                    }
                                                })
                                            }
                                            if old.count != 1 {
        //                                    //semap.wait()
                                            }
                                        }
                                    }
        //                            }
                                } else {
                                    let semap = DispatchSemaphore(value: 1)
                                        var count = 0
                                    for item in new {
                                        if count != 0 {
                                            usleep(100)
                                        }
                                        count+=1
                                        strongSelf.updateSongAlbumSongs(son: item, cat: "Add", completion: {err in
                                            completedProgress+=1
                                            if let err = err {
                                                completion(err)
                                                return
                                            } else {
                                                if completedProgress == (totalProgress) {
                                                    completion(nil)
                                                }
                                            }
                                        })
                                        //semap.wait()
                                    }
        //                            }
                                }
                            } else {
                                
                                    let semap = DispatchSemaphore(value: 1)
        //                            DispatchQueue.global(qos: .userInitiated).async { [weak self] in
        //                                guard let strongSelf = self else {return}
                                        var count = 0
                                for item in new {
                                    if count != 0 {
                                        usleep(100)
                                    }
                                    count+=1
                                    strongSelf.updateSongAlbumSongs(son: item, cat: "Add", completion: {err in
                                        completedProgress+=1
                                        if let err = err {
                                            completion(err)
                                            return
                                        } else {
                                            if completedProgress == (totalProgress) {
                                                completion(nil)
                                            }
                                        }
                                    })
                                    //semap.wait()
                                }
        //                        }
                            }
                        }
                        else if let inieng = initialeng as? NSDictionary {
                            let initeng = inieng.mutableCopy() as! NSMutableDictionary
                            if let old = initeng["Mastering Engineer"] as? [String] {
                                if let new = newengg["Mastering Engineer"] as? [String] {
                                    
                                    if new != old {
                                        let semap = DispatchSemaphore(value: 1)
                                        let group = DispatchGroup()
        //                                DispatchQueue.global(qos: .userInitiated).async { [weak self] in
        //                                    guard let strongSelf = self else {return}
                                            var count = 0
                                        for item in old {
                                            if count != 0 {
                                                usleep(100)
                                            }
                                            count+=1
                                            if !new.contains(item) {
                                                strongSelf.updateSongAlbumSongs(son: item, cat: "Remove", completion: {err in
                                                    completedProgress+=1
                                                    if let err = err {
                                                        completion(err)
                                                        return
                                                    } else {
                                                        if completedProgress == (totalProgress) {
                                                            completion(nil)
                                                            return
                                                        }
                                                    }
                                                })
                                            }
                                            //semap.wait()
                                        }
                                        for item in new {
                                            if count != 0 {
                                                usleep(100)
                                            }
                                            count+=1
                                            if !old.contains(item) {
                                                strongSelf.updateSongAlbumSongs(son: item, cat: "Add", completion: {err in
                                                    completedProgress+=1
                                                    if let err = err {
                                                        completion(err)
                                                        return
                                                    } else {
                                                        if completedProgress == (totalProgress) {
                                                            completion(nil)
                                                            return
                                                        }
                                                    }
                                                })
                                            }
                                            //semap.wait()
                                        }
        //                                }
                                    }
                                } else {
                                    let semap = DispatchSemaphore(value: 1)
                                    let group = DispatchGroup()
        //                            DispatchQueue.global(qos: .userInitiated).async { [weak self] in
        //                                guard let strongSelf = self else {return}
                                        var count = 0
                                        for item in old {
                                            if count != 0 {
                                                usleep(100)
                                            }
                                            count+=1
                                            strongSelf.updateSongAlbumSongs(son: item, cat: "Remove", completion: {err in
                                                completedProgress+=1
                                                if let err = err {
                                                    completion(err)
                                                    return
                                                } else {
                                                    if completedProgress == (totalProgress) {
                                                        completion(nil)
                                                        return
                                                    }
                                                }
                                            })
                                            //semap.wait()
                                        }
        //                            }
                                }
                            }
                        }
                        
                        if let new = newengg["Recording Engineer"] as? [String] {
                            if let inieng = initialeng as? NSDictionary {
                                let initeng = inieng.mutableCopy() as! NSMutableDictionary
                                if let old = initeng["Recording Engineer"] as? [String] {
                                    
                                    if new != old {
                                        let semap = DispatchSemaphore(value: 1)
                                        let group = DispatchGroup()
        //                                DispatchQueue.global(qos: .userInitiated).async { [weak self] in
        //                                    guard let strongSelf = self else {return}
                                            var count = 0
                                            for item in new {
                                                if count != 0 {
                                                    usleep(100)
                                                }
                                                count+=1
                                                if !old.contains(item) {
                                                    strongSelf.updateSongAlbumSongs(son: item, cat: "Add", completion: {err in
                                                        completedProgress+=1
                                                        if let err = err {
                                                            completion(err)
                                                            return
                                                        } else {
                                                            if completedProgress == (totalProgress) {
                                                                completion(nil)
                                                                return
                                                            }
                                                        }
                                                    })
                                                }
                                                //semap.wait()
                                            }
                                        for item in old {
                                            if count != 0 {
                                                usleep(100)
                                            }
                                            count+=1
                                            if !new.contains(item) {
                                                strongSelf.updateSongAlbumSongs(son: item, cat: "Remove", completion: {err in
                                                    completedProgress+=1
                                                    if let err = err {
                                                        completion(err)
                                                        return
                                                    } else {
                                                        if completedProgress == (totalProgress) {
                                                            completion(nil)
                                                            return
                                                        }
                                                    }
                                                })
                                            }
                                            //semap.wait()
                                        }
        //                                }
                                    }
                                } else {
                                    let semap = DispatchSemaphore(value: 1)
                                    let group = DispatchGroup()
        //                            DispatchQueue.global(qos: .userInitiated).async { [weak self] in
        //                                guard let strongSelf = self else {return}
                                        var count = 0
                                        for item in new {
                                            if count != 0 {
                                                usleep(100)
                                            }
                                            count+=1
                                            strongSelf.updateSongAlbumSongs(son: item, cat: "Add", completion: {err in
                                                completedProgress+=1
                                                if let err = err {
                                                    completion(err)
                                                    return
                                                } else {
                                                    if completedProgress == (totalProgress) {
                                                        completion(nil)
                                                        return
                                                    }
                                                }
                                            })
                                            //semap.wait()
                                        }
        //                            }
                                }
                            } else {
                                let semap = DispatchSemaphore(value: 1)
                                let group = DispatchGroup()
        //                        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
        //                            guard let strongSelf = self else {return}
                                    var count = 0
                                    for item in new {
                                        if count != 0 {
                                            usleep(100)
                                        }
                                        count+=1
                                        strongSelf.updateSongAlbumSongs(son: item, cat: "Add", completion: {err in
                                            completedProgress+=1
                                            if let err = err {
                                                completion(err)
                                                return
                                            } else {
                                                if completedProgress == (totalProgress) {
                                                    completion(nil)
                                                    return
                                                }
                                            }
                                        })
                                        //semap.wait()
                                    }
        //                        }
                            }
                        }
                        else if let inieng = initialeng as? NSDictionary {
                            let initeng = inieng.mutableCopy() as! NSMutableDictionary
                            if let old = initeng["Recording Engineer"] as? [String] {
                                if let new = newengg["Recording Engineer"] as? [String] {
                                    if new != old {
                                        let semap = DispatchSemaphore(value: 1)
        //                                DispatchQueue.global(qos: .userInitiated).async { [weak self] in
        //                                    guard let strongSelf = self else {return}
                                            var count = 0
                                            for item in old {
                                                if count != 0 {
                                                    usleep(100)
                                                }
                                                count+=1
                                                if !new.contains(item) {
                                                    strongSelf.updateSongAlbumSongs(son: item, cat: "Remove", completion: {err in
                                                        completedProgress+=1
                                                        if let err = err {
                                                            completion(err)
                                                            return
                                                        } else {
                                                            if completedProgress == (totalProgress) {
                                                                completion(nil)
                                                                return
                                                            }
                                                        }
                                                    })
                                                }
                                                //semap.wait()
                                            }
                                        for item in new {
                                            if count != 0 {
                                                usleep(100)
                                            }
                                            count+=1
                                            if !old.contains(item) {
                                                strongSelf.updateSongAlbumSongs(son: item, cat: "Add", completion: {err in
                                                    completedProgress+=1
                                                    if let err = err {
                                                        completion(err)
                                                        return
                                                    } else {
                                                        if completedProgress == (totalProgress) {
                                                            completion(nil)
                                                            return
                                                        }
                                                    }
                                                })
                                            }
                                            //semap.wait()
                                        }
        //                                }
                                    }
                                } else {
                                    let semap = DispatchSemaphore(value: 1)
        //                            DispatchQueue.global(qos: .userInitiated).async { [weak self] in
        //                                guard let strongSelf = self else {return}
                                        var count = 0
                                        for item in old {
                                            if count != 0 {
                                                usleep(100)
                                            }
                                            count+=1
                                            strongSelf.updateSongAlbumSongs(son: item, cat: "Remove", completion: {err in
                                                completedProgress+=1
                                                if let err = err {
                                                    completion(err)
                                                    return
                                                } else {
                                                    if completedProgress == (totalProgress) {
                                                        completion(nil)
                                                        return
                                                    }
                                                }
                                            })
                                            //semap.wait()
                                        }
        //                            }
                                }
                            }
                        }
                    }
                    
                } else if let oldenggg = initialRoles["Engineer"] as? NSDictionary {
                    let oldnegg = oldenggg.mutableCopy() as! NSMutableDictionary
                    if let newengg = ro["Engineer"] as? NSMutableDictionary {
                        if let new = newengg["Mix Engineer"] as? [String] {
                            if let old = initialeng["Mix Engineer"] as? [String] {
                                if new != old {
                                    let semap = DispatchSemaphore(value: 1)
                                    let group = DispatchGroup()
        //                            DispatchQueue.global(qos: .userInitiated).async { [weak self] in
        //                                guard let strongSelf = self else {return}
                                        var count = 0
                                        for item in new {
                                            if count != 0 {
                                                usleep(100)
                                            }
                                            count+=1
                                            if !old.contains(item) {
                                                strongSelf.updateSongAlbumSongs(son: item, cat: "Add", completion: {err in
                                                    completedProgress+=1
                                                    if let err = err {
                                                        completion(err)
                                                        return
                                                    } else {
                                                        if completedProgress == (totalProgress) {
                                                            completion(nil)
                                                            return
                                                        }
                                                    }
                                                })
                                            }
                                            //semap.wait()
                                        }
                                    for item in old {
                                        if count != 0 {
                                            usleep(100)
                                        }
                                        count+=1
                                        if !new.contains(item) {
                                            strongSelf.updateSongAlbumSongs(son: item, cat: "Remove", completion: {err in
                                                completedProgress+=1
                                                if let err = err {
                                                    completion(err)
                                                    return
                                                } else {
                                                    if completedProgress == (totalProgress) {
                                                        completion(nil)
                                                        return
                                                    }
                                                }
                                            })
                                        }
                                        //semap.wait()
                                    }
        //                            }
                                }
                            } else {
                                let semap = DispatchSemaphore(value: 1)
                                let group = DispatchGroup()
        //                        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
        //                            guard let strongSelf = self else {return}
                                    var count = 0
                                    for item in new {
                                        if count != 0 {
                                            usleep(100)
                                        }
                                        count+=1
                                        strongSelf.updateSongAlbumSongs(son: item, cat: "Add", completion: {err in
                                            completedProgress+=1
                                            if let err = err {
                                                completion(err)
                                                return
                                            } else {
                                                if completedProgress == (totalProgress) {
                                                    completion(nil)
                                                    return
                                                }
                                            }
                                        })
                                        //semap.wait()
                                    }
        //                        }
                            }
                        } else if let old = initialeng["Mix Engineer"] as? [String] {
                            if let new = newengg["Mix Engineer"] as? [String] {
                                if new != old {
                                    let semap = DispatchSemaphore(value: 1)
                                    let group = DispatchGroup()
        //                            DispatchQueue.global(qos: .userInitiated).async { [weak self] in
        //                                guard let strongSelf = self else {return}
                                        var count = 0
                                        for item in old {
                                            if count != 0 {
                                                usleep(100)
                                            }
                                            count+=1
                                            if !new.contains(item) {
                                                strongSelf.updateSongAlbumSongs(son: item, cat: "Remove", completion: {err in
                                                    completedProgress+=1
                                                    if let err = err {
                                                        completion(err)
                                                        return
                                                    } else {
                                                        if completedProgress == (totalProgress) {
                                                            completion(nil)
                                                            return
                                                        }
                                                    }
                                                })
                                            }
                                            //semap.wait()
                                        }
                                    for item in new {
                                        if count != 0 {
                                            usleep(100)
                                        }
                                        count+=1
                                        if !old.contains(item) {
                                            strongSelf.updateSongAlbumSongs(son: item, cat: "Add", completion: {err in
                                                completedProgress+=1
                                                if let err = err {
                                                    completion(err)
                                                    return
                                                } else {
                                                    if completedProgress == (totalProgress) {
                                                        completion(nil)
                                                        return
                                                    }
                                                }
                                            })
                                        }
                                        //semap.wait()
                                    }
        //                            }
                                }
                            } else {
                                let semap = DispatchSemaphore(value: 1)
                                let group = DispatchGroup()
        //                        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
        //                            guard let strongSelf = self else {return}
                                    var count = 0
                                    for item in old {
                                        if count != 0 {
                                            usleep(100)
                                        }
                                        count+=1
                                        strongSelf.updateSongAlbumSongs(son: item, cat: "Remove", completion: {err in
                                            completedProgress+=1
                                            if let err = err {
                                                completion(err)
                                                return
                                            } else {
                                                if completedProgress == (totalProgress) {
                                                    completion(nil)
                                                    return
                                                }
                                            }
                                        })
                                        //semap.wait()
                                    }
        //                        }
                            }
                        }
                        if let new = newengg["Mastering Engineer"] as? [String] {
                            
                            if let old = initialeng["Mastering Engineer"] as? [String] {
                                if new != old {
                                    let semap = DispatchSemaphore(value: 1)
        //                            DispatchQueue.global(qos: .userInitiated).async { [weak self] in
        //                                guard let strongSelf = self else {return}
                                        var count = 0
                                        for item in new {
                                            if count != 0 {
                                                usleep(100)
                                            }
                                            count+=1
                                            if !old.contains(item) {
                                                strongSelf.updateSongAlbumSongs(son: item, cat: "Add", completion: {err in
                                                    completedProgress+=1
                                                    if let err = err {
                                                        completion(err)
                                                        return
                                                    } else {
                                                        if completedProgress == (totalProgress) {
                                                            completion(nil)
                                                            return
                                                        }
                                                    }
                                                })
                                            }
                                            //semap.wait()
                                        }
                                    for item in old {
                                        if count != 0 {
                                            usleep(100)
                                        }
                                        count+=1
                                        if !new.contains(item) {
                                            strongSelf.updateSongAlbumSongs(son: item, cat: "Remove", completion: {err in
                                                completedProgress+=1
                                                if let err = err {
                                                    completion(err)
                                                    return
                                                } else {
                                                    if completedProgress == (totalProgress) {
                                                        completion(nil)
                                                        return
                                                    }
                                                }
                                            })
                                        }
                                        //semap.wait()
                                    }
        //                            }
                                }
                            } else {
                                let semap = DispatchSemaphore(value: 1)
        //                        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
        //                            guard let strongSelf = self else {return}
                                    var count = 0
                                    for item in new {
                                        if count != 0 {
                                            usleep(100)
                                        }
                                        count+=1
                                        strongSelf.updateSongAlbumSongs(son: item, cat: "Add", completion: {err in
                                            completedProgress+=1
                                            if let err = err {
                                                completion(err)
                                                return
                                            } else {
                                                if completedProgress == (totalProgress) {
                                                    completion(nil)
                                                    return
                                                }
                                            }
                                        })
                                        //semap.wait()
                                    }
        //                        }
                            }
                        } else if let old = initialeng["Mastering Engineer"] as? [String] {
                            if let new = newengg["Mastering Engineer"] as? [String] {
                                if new != old {
                                    let semap = DispatchSemaphore(value: 1)
                                    let group = DispatchGroup()
        //                            DispatchQueue.global(qos: .userInitiated).async { [weak self] in
        //                                guard let strongSelf = self else {return}
                                        var count = 0
                                        for item in old {
                                            if count != 0 {
                                                usleep(100)
                                            }
                                            count+=1
                                            if !new.contains(item) {
                                                strongSelf.updateSongAlbumSongs(son: item, cat: "Remove", completion: {err in
                                                    completedProgress+=1
                                                    if let err = err {
                                                        completion(err)
                                                        return
                                                    } else {
                                                        if completedProgress == (totalProgress) {
                                                            completion(nil)
                                                            return
                                                        }
                                                    }
                                                })
                                            }
                                            //semap.wait()
                                        }
                                    for item in new {
                                        if count != 0 {
                                            usleep(100)
                                        }
                                        count+=1
                                        if !old.contains(item) {
                                            strongSelf.updateSongAlbumSongs(son: item, cat: "Add", completion: {err in
                                                completedProgress+=1
                                                if let err = err {
                                                    completion(err)
                                                    return
                                                } else {
                                                    if completedProgress == (totalProgress) {
                                                        completion(nil)
                                                        return
                                                    }
                                                }
                                            })
                                        }
                                        //semap.wait()
                                    }
        //                            }
                                }
                            } else {
                                let semap = DispatchSemaphore(value: 1)
                                let group = DispatchGroup()
        //                        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
        //                            guard let strongSelf = self else {return}
                                    var count = 0
                                    for item in old {
                                        if count != 0 {
                                            usleep(100)
                                        }
                                        count+=1
                                        strongSelf.updateSongAlbumSongs(son: item, cat: "Remove", completion: {err in
                                            completedProgress+=1
                                            if let err = err {
                                                completion(err)
                                                return
                                            } else {
                                                if completedProgress == (totalProgress) {
                                                    completion(nil)
                                                    return
                                                }
                                            }
                                        })
                                        //semap.wait()
                                    }
        //                        }
                            }
                        }
                        if let new = newengg["Recording Engineer"] as? [String] {
                            if let old = initialeng["Recording Engineer"] as? [String] {
                                if new != old {
                                    let semap = DispatchSemaphore(value: 1)
                                    let group = DispatchGroup()
        //                            DispatchQueue.global(qos: .userInitiated).async { [weak self] in
        //                                guard let strongSelf = self else {return}
                                        var count = 0
                                        for item in new {
                                            if count != 0 {
                                                usleep(100)
                                            }
                                            count+=1
                                            if !old.contains(item) {
                                                strongSelf.updateSongAlbumSongs(son: item, cat: "Add", completion: {err in
                                                    completedProgress+=1
                                                    if let err = err {
                                                        completion(err)
                                                        return
                                                    } else {
                                                        if completedProgress == (totalProgress) {
                                                            completion(nil)
                                                            return
                                                        }
                                                    }
                                                })
                                            }
                                            //semap.wait()
                                        }
                                    for item in old {
                                        if count != 0 {
                                            usleep(100)
                                        }
                                        count+=1
                                        if !new.contains(item) {
                                            strongSelf.updateSongAlbumSongs(son: item, cat: "Remove", completion: {err in
                                                completedProgress+=1
                                                if let err = err {
                                                    completion(err)
                                                    return
                                                } else {
                                                    if completedProgress == (totalProgress) {
                                                        completion(nil)
                                                        return
                                                    }
                                                }
                                            })
                                        }
                                        //semap.wait()
                                    }
        //                            }
                                }
                            } else {
                                let semap = DispatchSemaphore(value: 1)
        //                        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
        //                            guard let strongSelf = self else {return}
                                    var count = 0
                                    for item in new {
                                        if count != 0 {
                                            usleep(100)
                                        }
                                        count+=1
                                        strongSelf.updateSongAlbumSongs(son: item, cat: "Add", completion: {err in
                                            completedProgress+=1
                                            if let err = err {
                                                completion(err)
                                                return
                                            } else {
                                                if completedProgress == (totalProgress) {
                                                    completion(nil)
                                                    return
                                                }
                                            }
                                        })
                                        //semap.wait()
                                    }
        //                        }
                            }
                        } else if let old = initialeng["Recording Engineer"] as? [String] {
                            if let new = newengg["Recording Engineer"] as? [String] {
                                if new != old {
                                    let semap = DispatchSemaphore(value: 1)
        //                            DispatchQueue.global(qos: .userInitiated).async { [weak self] in
        //                                guard let strongSelf = self else {return}
                                        var count = 0
                                        for item in old {
                                            if count != 0 {
                                                usleep(100)
                                            }
                                            count+=1
                                            if !new.contains(item) {
                                                strongSelf.updateSongAlbumSongs(son: item, cat: "Remove", completion: {err in
                                                    completedProgress+=1
                                                    if let err = err {
                                                        completion(err)
                                                        return
                                                    } else {
                                                        if completedProgress == (totalProgress) {
                                                            completion(nil)
                                                            return
                                                        }
                                                    }
                                                })
                                            }
                                            //semap.wait()
                                        }
                                    for item in new {
                                        if count != 0 {
                                            usleep(100)
                                        }
                                        count+=1
                                        if !old.contains(item) {
                                            strongSelf.updateSongAlbumSongs(son: item, cat: "Add", completion: {err in
                                                completedProgress+=1
                                                if let err = err {
                                                    completion(err)
                                                    return
                                                } else {
                                                    if completedProgress == (totalProgress) {
                                                        completion(nil)
                                                        return
                                                    }
                                                }
                                            })
                                        }
                                        //semap.wait()
                                    }
        //                            }
                                }
                            } else {
                                let semap = DispatchSemaphore(value: 1)
                                let group = DispatchGroup()
        //                        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
        //                            guard let strongSelf = self else {return}
                                    var count = 0
                                    for item in old {
                                        if count != 0 {
                                            usleep(100)
                                        }
                                        count+=1
                                        strongSelf.updateSongAlbumSongs(son: item, cat: "Remove", completion: {err in
                                            completedProgress+=1
                                            if let err = err {
                                                completion(err)
                                                return
                                            } else {
                                                if completedProgress == (totalProgress) {
                                                    completion(nil)
                                                    return
                                                }
                                            }
                                        })
                                        //semap.wait()
                                    }
        //                        }
                            }
                        }
                    } else {
                        if let old = oldenggg["Mix Engineer"] as? [String] {
                            let semap = DispatchSemaphore(value: 1)
                            let group = DispatchGroup()
        //                    DispatchQueue.global(qos: .userInitiated).async { [weak self] in
        //                        guard let strongSelf = self else {return}
                                var count = 0
                                for item in old {
                                    strongSelf.updateSongAlbumSongs(son: item, cat: "Remove", completion: {err in
                                        completedProgress+=1
                                        if let err = err {
                                            completion(err)
                                            return
                                        } else {
                                            if completedProgress == (totalProgress) {
                                                completion(nil)
                                                return
                                            }
                                        }
                                    })
                                    //semap.wait()
                                }
        //                    }
                        }
                        if let old = oldenggg["Mastering Engineer"] as? [String] {
                            let semap = DispatchSemaphore(value: 1)
                            let group = DispatchGroup()
        //                    DispatchQueue.global(qos: .userInitiated).async { [weak self] in
        //                        guard let strongSelf = self else {return}
                                var count = 0
                                for item in old {
                                    if count != 0 {
                                        usleep(100)
                                    }
                                    count+=1
                                    strongSelf.updateSongAlbumSongs(son: item, cat: "Remove", completion: {err in
                                        completedProgress+=1
                                        if let err = err {
                                            completion(err)
                                            return
                                        } else {
                                            if completedProgress == (totalProgress) {
                                                completion(nil)
                                                return
                                            }
                                        }
                                    })
                                    //semap.wait()
                                }
        //                    }
                        }
                        if let old = oldenggg["Recording Engineer"] as? [String] {
                            let semap = DispatchSemaphore(value: 1)
                            let group = DispatchGroup()
        //                    DispatchQueue.global(qos: .userInitiated).async { [weak self] in
        //                        guard let strongSelf = self else {return}
                                var count = 0
                                for item in old {
                                    if count != 0 {
                                        usleep(100)
                                    }
                                    count+=1
                                    strongSelf.updateSongAlbumSongs(son: item, cat: "Remove", completion: {err in
                                        completedProgress+=1
                                        if let err = err {
                                            completion(err)
                                            return
                                        } else {
                                            if completedProgress == (totalProgress) {
                                                completion(nil)
                                                return
                                            }
                                        }
                                    })
                                    //semap.wait()
                                }
        //                    }
                        }
                    }
                }
                if let new = ro["Videographer"] as? [String] {
                    if completedProgress == (totalProgress) {
                        completion(nil)
                        return
                    }
                } else if let old = initialRoles["Videographer"] as? [String] {
                    if completedProgress == (totalProgress) {
                        completion(nil)
                        return
                    }
                }
            }
            else {
                if let arr = initialRoles["Artist"] as? [String] {
                    let semap = DispatchSemaphore(value: 1)
                    let group = DispatchGroup()
                    //                    DispatchQueue.global(qos: .userInitiated).async { [weak self] in
                    //                        guard let strongSelf = self else {return}
                    var count = 0
                    for songg in arr {
                        if count != 0 {
                            usleep(100)
                        }
                        count+=1
                        //If the a song is on an album, go to the album in database and remove the person from the albums 'All Artist' node
                        strongSelf.updateSongAlbumSongs(son: songg, cat: "Remove", completion: {err in
                            completedProgress+=1
                            if let err = err {
                                completion(err)
                                return
                            } else {
                                if completedProgress == (totalProgress) {
                                    completion(nil)
                                    return
                                }
                            }
                        })
                    }
                }
                if let arr = initialRoles["Producer"] as? [String] {
                    let semap = DispatchSemaphore(value: 1)
                    let group = DispatchGroup()
                    //                DispatchQueue.global(qos: .userInitiated).async { [weak self] in
                    //                    guard let strongSelf = self else {return}
                    var count = 0
                    var completioncount = 0
                    for songg in arr {
                        if count != 0 {
                            usleep(100)
                        }
                        count+=1
                        strongSelf.updateSongAlbumSongs(son: songg, cat: "Remove", completion: {err in
                            completedProgress+=1
                            if let err = err {
                                completion(err)
                                return
                            } else {
                                if completedProgress == (totalProgress) {
                                    completion(nil)
                                    return
                                }
                            }
                        })
                        //semap.wait()
                    }
                    //                }
                }
                if let arr = initialRoles["Writer"] as? [String] {
                    let semap = DispatchSemaphore(value: 1)
                    let group = DispatchGroup()
                    //                DispatchQueue.global(qos: .userInitiated).async { [weak self] in
                    //                    guard let strongSelf = self else {return}
                    var count = 0
                    var completioncount = 0
                    for songg in arr {
                        if count != 0 {
                            usleep(100)
                        }
                        count+=1
                        strongSelf.updateSongAlbumSongs(son: songg, cat: "Remove", completion: {err in
                            completedProgress+=1
                            if let err = err {
                                completion(err)
                                return
                            } else {
                                if completedProgress == (totalProgress) {
                                    completion(nil)
                                    return
                                }
                            }
                        })
                        //semap.wait()
                    }
                    //                }
                }
                if let engg = initialRoles["Engineer"] as? NSMutableDictionary {
                    if let arr = engg["Mix Engineer"] as? [String] {
                        let semap = DispatchSemaphore(value: 1)
                        let group = DispatchGroup()
                        //                    DispatchQueue.global(qos: .userInitiated).async { [weak self] in
                        //                        guard let strongSelf = self else {return}
                        var count = 0
                        var completioncount = 0
                        for songg in arr {
                            if count != 0 {
                                usleep(100)
                            }
                            count+=1
                            strongSelf.updateSongAlbumSongs(son: songg, cat: "Remove", completion: {err in
                                completedProgress+=1
                                if let err = err {
                                    completion(err)
                                    return
                                } else {
                                    if completedProgress == (totalProgress) {
                                        completion(nil)
                                        return
                                    }
                                }
                            })
                            //semap.wait()
                        }
                        //                    }
                    }
                    if let arr = engg["Mastering Engineer"] as? [String] {
                        let semap = DispatchSemaphore(value: 1)
                        let group = DispatchGroup()
                        //                    DispatchQueue.global(qos: .userInitiated).async { [weak self] in
                        //                        guard let strongSelf = self else {return}
                        var count = 0
                        var completioncount = 0
                        for songg in arr {
                            if count != 0 {
                                usleep(100)
                            }
                            count+=1
                            strongSelf.updateSongAlbumSongs(son: songg, cat: "Remove", completion: {err in
                                completedProgress+=1
                                if let err = err {
                                    completion(err)
                                    return
                                } else {
                                    if completedProgress == (totalProgress) {
                                        completion(nil)
                                        return
                                    }
                                }
                            })
                            //semap.wait()
                        }
                        //                    }
                    }
                    if let arr = engg["Recording Engineer"] as? [String] {
                        let semap = DispatchSemaphore(value: 1)
                        let group = DispatchGroup()
                        //                    DispatchQueue.global(qos: .userInitiated).async { [weak self] in
                        //                        guard let strongSelf = self else {return}
                        var count = 0
                        var completioncount = 0
                        for songg in arr {
                            if count != 0 {
                                usleep(100)
                            }
                            count+=1
                            strongSelf.updateSongAlbumSongs(son: songg, cat: "Remove", completion: {err in
                                completedProgress+=1
                                if let err = err {
                                    completion(err)
                                    return
                                } else {
                                    if completedProgress == (totalProgress) {
                                        completion(nil)
                                        return
                                    }
                                }
                            })
                            //semap.wait()
                        }
                        //                    }
                    }
                    
                }
                if let arr = initialRoles["Videographer"] as? [String] {
                    if completedProgress == (totalProgress) {
                        completion(nil)
                        return
                    }
                }
            }
        })
    }
    
    func updateSongAlbumSongs(son: String, cat:String, completion: @escaping ((Error?) -> Void)) {
        guard son.count == 10 else {
            completion(nil)
            return
        }
        let word = son.split(separator: "Æ")
        let id = word[0]
        
        DatabaseManager.shared.findSongById(songId: String(id), completion: {[weak self] result in
            guard let strongSelf = self else {return}
            switch result {
            case .success(let song):
//                print(String(data: try! JSONSerialization.data(withJSONObject: update, options: .prettyPrinted), encoding: .utf8)!)
                if var alb = song.albums {
                    if !alb.isEmpty {
                        if cat == "Add" {
                            
//                            if let songAlbums = song.albums {
//                                alb = Array(GlobalFunctions.shared.combine(alb,songAlbums))
//                                strongSelf.currRef.child("Albums").setValue(alb)
//                            }
                            var count = 0
                            for album in alb {
                                strongSelf.updateSongAlbumSongsAdd(son: son, alb: album, completion: { error in
                                    count+=1
                                    if let error = error {
                                        completion(error)
                                        return
                                    }
                                    else {
                                        if count == alb.count {
                                            completion(nil)
                                            return
                                        }
                                    }
                                })
                            }
                        } else {
                            var count = 0
                            for album in alb {
                                strongSelf.updateSongAlbumSongsRemove(son: son, alb: album, completion: { error in
                                    count+=1
                                    if let error = error {
                                        completion(error)
                                        return
                                    }
                                    else {
                                        var initAlbCount = alb.count
//                                        if strongSelf.initPerson.albums != strongSelf.currPerson.albums {
//                                            if let songAlbums = song.albums {
//                                                for al in songAlbums {
//                                                    let index = alb.firstIndex(of: al)
//                                                    alb.remove(at: index!)
//                                                }
//                                                strongSelf.currRef.child("Albums").setValue(alb)
//                                            }
//                                        }
//                                        if count == initAlbCount{
                                            completion(nil)
                                            return
//                                        }
                                    }
                                })
                            }
                        }
                    } else {
                        completion(nil)
                        return
                    }
                } else {
                    completion(nil)
                    return
                }
            case .failure(let err):
                print("dsvgredfxbdfzx"+err.localizedDescription)
            }
        })
    }
    
    func updateSongAlbumSongsAdd(son: String, alb:String, completion: @escaping ((Error?) -> Void)) {
        guard son.count == 8 else {
            completion(nil)
            return
        }
        let word = alb.split(separator: "Æ")
        let id = word[0]
        DatabaseManager.shared.findAlbumById(albumId: String(id), completion: {[weak self] result in
            guard let strongSelf = self else {return}
            switch result {
            case .success(let album):
                let key = "\(albumContentTag)--\(album.name)--\(album.toneDeafAppId)"
                let ref = Database.database().reference().child("Music Content").child("Albums").child(key).child("REQUIRED")
                
                var loadArr:[String]!
                let update:NSMutableDictionary = [:]
                if let curRo = strongSelf.currPerson.roles {
                    if let arr = curRo["Artist"] as? [String] {
                        if arr.contains(son) {
                            if let allArt = album.allArtists {
                                loadArr = allArt
                                if !loadArr.contains(strongSelf.currPerson.toneDeafAppId) {
                                    loadArr.append(strongSelf.currPerson.toneDeafAppId)
                                }
                            } else {
                                loadArr = [strongSelf.currPerson.toneDeafAppId]
                            }
                            update["All Artist"] = loadArr.sorted()
                        }
                    }
                    if let arr = curRo["Producer"] as? [String] {
                        if arr.contains(son) {
                            loadArr = album.producers
                            if !loadArr.contains(strongSelf.currPerson.toneDeafAppId) {
                                loadArr.append(strongSelf.currPerson.toneDeafAppId)
                            }
                        } else {
                            loadArr = [strongSelf.currPerson.toneDeafAppId]
                        }
                        update["All Producers"] = loadArr.sorted()
                    }
                    if let arr = curRo["Writer"] as? [String] {
                        if arr.contains(son) {
                            if let allArt = album.writers {
                                loadArr = allArt
                                if !loadArr.contains(strongSelf.currPerson.toneDeafAppId) {
                                    loadArr.append(strongSelf.currPerson.toneDeafAppId)
                                }
                            } else {
                                loadArr = [strongSelf.currPerson.toneDeafAppId]
                            }
                            update["All Writers"] = loadArr.sorted()
                        }
                    }
                    if let earr = curRo["Engineer"] as? NSMutableDictionary {
                        let engies:NSMutableDictionary = [:]
                        if let arr = earr["Mix Engineer"] as? [String] {
                            if arr.contains(son) {
                                if let allArt = album.mixEngineers {
                                    loadArr = allArt
                                    if !loadArr.contains(strongSelf.currPerson.toneDeafAppId) {
                                        loadArr.append(strongSelf.currPerson.toneDeafAppId)
                                    }
                                } else {
                                    loadArr = [strongSelf.currPerson.toneDeafAppId]
                                }
                                engies["Mix Engineer"] = loadArr.sorted()
                            }
                        }
                        if let arr = earr["Mastering Engineer"] as? [String] {
                            if arr.contains(son) {
                                if let allArt = album.masteringEngineers {
                                    loadArr = allArt
                                    if !loadArr.contains(strongSelf.currPerson.toneDeafAppId) {
                                        loadArr.append(strongSelf.currPerson.toneDeafAppId)
                                    }
                                } else {
                                    loadArr = [strongSelf.currPerson.toneDeafAppId]
                                }
                                engies["Mastering Engineer"] = loadArr.sorted()
                            }
                        }
                        if let arr = earr["Recording Engineer"] as? [String] {
                            if arr.contains(son) {
                                if let allArt = album.recordingEngineers {
                                    loadArr = allArt
                                    if !loadArr.contains(strongSelf.currPerson.toneDeafAppId) {
                                        loadArr.append(strongSelf.currPerson.toneDeafAppId)
                                    }
                                } else {
                                    loadArr = [strongSelf.currPerson.toneDeafAppId]
                                }
                                engies["Recording Engineer"] = loadArr.sorted()
                            }
                        }
                        update["Engineers"] = engies
                    }
                }
                
                ref.updateChildValues(update as! [AnyHashable : Any], withCompletionBlock: { error, reference in
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
    
    func updateSongAlbumSongsRemove(son: String, alb:String, completion: @escaping ((Error?) -> Void)) {
        guard son.count == 8 else {
            completion(nil)
            return
        }
        let word = alb.split(separator: "Æ")
        let id = word[0]
        DatabaseManager.shared.findAlbumById(albumId: String(id), completion: {[weak self] result in
            guard let strongSelf = self else {return}
            switch result {
            case .success(let album):
                var count = 0
                if let albsongs = album.songs {
                    for songg in albsongs {
                        if songg != son {
                            //Check to see if artist is on another song in album
                            let worde = songg.split(separator: "Æ")
                            let ide = worde[0]
                            DatabaseManager.shared.findSongById(songId: String(ide), completion: { result in
                                switch result {
                                case .success(let fsong):
                                    count+=1
                                    if count == albsongs.count {
                                        let key = "\(albumContentTag)--\(album.name)--\(album.toneDeafAppId)"
                                        let ref = Database.database().reference().child("Music Content").child("Albums").child(key).child("REQUIRED")
                                        var update:NSMutableDictionary = [:]
                                        if !fsong.songArtist.contains(strongSelf.currPerson.toneDeafAppId) {
                                            if var allArt = album.allArtists {
                                                let index = allArt.firstIndex(of: strongSelf.currPerson.toneDeafAppId)
                                                allArt.remove(at: index!)
                                                update["All Artist"] = allArt.sorted()
                                            }
                                        }
                                        if !fsong.songProducers.contains(strongSelf.currPerson.toneDeafAppId) {
                                            var allP = album.producers
                                            let index = allP.firstIndex(of: strongSelf.currPerson.toneDeafAppId)
                                            allP.remove(at: index!)
                                            update["All Producers"] = allP.sorted()
                                        }
                                        if let arr = fsong.songWriters as? [String] {
                                            if !arr.contains(strongSelf.currPerson.toneDeafAppId) {
                                                if var allArt = album.writers {
                                                    let index = allArt.firstIndex(of: strongSelf.currPerson.toneDeafAppId)
                                                    allArt.remove(at: index!)
                                                    update["All Writers"] = allArt.sorted()
                                                }
                                            }
                                        }
                                        var engies:NSMutableDictionary = [:]
                                        if let arr = fsong.songMixEngineer as? [String] {
                                            if !arr.contains(strongSelf.currPerson.toneDeafAppId) {
                                                if var allArt = album.mixEngineers {
                                                    let index = allArt.firstIndex(of: strongSelf.currPerson.toneDeafAppId)
                                                    allArt.remove(at: index!)
                                                    update["Mix Engineer"] = allArt.sorted()
                                                }
                                            }
                                        }
                                        if let arr = fsong.songMasteringEngineer as? [String] {
                                            if !arr.contains(strongSelf.currPerson.toneDeafAppId) {
                                                if var allArt = album.masteringEngineers {
                                                    let index = allArt.firstIndex(of: strongSelf.currPerson.toneDeafAppId)
                                                    allArt.remove(at: index!)
                                                    update["Mastering Engineer"] = allArt.sorted()
                                                }
                                            }
                                        }
                                        if let arr = fsong.songRecordingEngineer as? [String] {
                                            if !arr.contains(strongSelf.currPerson.toneDeafAppId) {
                                                if var allArt = album.recordingEngineers {
                                                    let index = allArt.firstIndex(of: strongSelf.currPerson.toneDeafAppId)
                                                    allArt.remove(at: index!)
                                                    update["Recording Engineer"] = allArt.sorted()
                                                }
                                            }
                                        }
                                        update["Engineers"] = engies
                                        ref.updateChildValues(update as! [AnyHashable : Any], withCompletionBlock: { error, reference in
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
                                case .failure(let err):
                                    print("dsvgredfxbdfzx"+err.localizedDescription)
                                }
                                
                            })
                        }
                        else {
                            count+=1
                            if count == albsongs.count {
                                let key = "\(albumContentTag)--\(album.name)--\(album.toneDeafAppId)"
                                let ref = Database.database().reference().child("Music Content").child("Albums").child(key).child("REQUIRED")
                                var update:NSMutableDictionary = [:]
                                if var allArt = album.allArtists {
                                    if let index = allArt.firstIndex(of: strongSelf.currPerson.toneDeafAppId) {
                                        allArt.remove(at: index)
                                        update["All Artist"] = allArt.sorted()
                                    }
                                }
                                var allP = album.producers
                                if let index = allP.firstIndex(of: strongSelf.currPerson.toneDeafAppId) {
                                    allP.remove(at: index)
                                    update["All Producers"] = allP.sorted()
                                }
                                if var allArt = album.writers {
                                    if let index = allArt.firstIndex(of: strongSelf.currPerson.toneDeafAppId) {
                                        allArt.remove(at: index)
                                        update["All Writers"] = allArt.sorted()
                                    }
                                }
                                var engies:NSMutableDictionary = [:]
                                if var allArt = album.mixEngineers {
                                    if let index = allArt.firstIndex(of: strongSelf.currPerson.toneDeafAppId) {
                                        allArt.remove(at: index)
                                        update["Mix Engineer"] = allArt.sorted()
                                    }
                                }
                                if var allArt = album.masteringEngineers {
                                    if let index = allArt.firstIndex(of: strongSelf.currPerson.toneDeafAppId) {
                                        allArt.remove(at: index)
                                        update["Mastering Engineer"] = allArt.sorted()
                                    }
                                }
                                if var allArt = album.recordingEngineers {
                                    if let index = allArt.firstIndex(of: strongSelf.currPerson.toneDeafAppId) {
                                        allArt.remove(at: index)
                                        update["Recording Engineer"] = allArt.sorted()
                                    }
                                }
                                update["Engineers"] = engies
                                ref.updateChildValues(update as! [AnyHashable : Any], withCompletionBlock: { error, reference in
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
                    }
                }
                else {
                    completion(nil)
                }
            case .failure(let err):
                print("dsvgredfxbdfzx"+err.localizedDescription)
            }
        })
        
    }
    
    
    //MARK: - Albums
    func processAlbums(initialPerson: PersonData, currentPerson: PersonData, initialRoles:NSMutableDictionary, mainArtistArr: [String], featArtistArr: [String], initmainArtistArr: [String], initfeatArtistArr: [String], completion: @escaping (([Error]?) -> Void)) {
        initPerson = initialPerson
        currPerson = currentPerson
        self.initialRoles = initialRoles.mutableCopy() as! NSMutableDictionary
        
        if currPerson.albums == nil {
            currPerson.albums = []
        }
        
        var errors:[Error] = []
        initRef = Database.database().reference().child("Registered Persons").child("\(initPerson.name!)--\(initPerson.dateRegisteredToApp!)--\(initPerson.timeRegisteredToApp!)--\(initPerson.toneDeafAppId)")
        currRef = Database.database().reference().child("Registered Persons").child("\(currPerson.name!)--\(currPerson.dateRegisteredToApp!)--\(currPerson.timeRegisteredToApp!)--\(currPerson.toneDeafAppId)")
        
        var dataUploadCompletionStatus1:Bool!
        var dataUploadCompletionStatus2:Bool!
        var dataUploadCompletionStatus3:Bool!
        let queue = DispatchQueue(label: "myhjvkheditingQpersonsAlbumssseue")
        let group = DispatchGroup()
        let array:[Int] = [1,2,3,4]
        for i in array {
            group.enter()
            queue.async { [weak self] in
                guard let strongSelf = self else {return}
                switch i {
                case 1:
                    strongSelf.updatePersonAlbums(ref: strongSelf.currRef, completion: {err in
                        if let error = err {
                            dataUploadCompletionStatus1 = false
                            errors.append(error)
                        } else {
                            dataUploadCompletionStatus1 = true
                            print("Person Albums update done \(i)")
                        }
                        group.leave()
                    })
                case 2:
                    strongSelf.updatePersonAlbumRoles(ref: strongSelf.currRef, completion: {err in
                        if let error = err {
                            dataUploadCompletionStatus1 = false
                            errors.append(error)
                        } else {
                            dataUploadCompletionStatus1 = true
                            print("Person Album Roles update done \(i)")
                        }
                        group.leave()
                    })
                case 3:
                    DispatchQueue.global(qos: .userInitiated).async { [weak self] in
                        guard let strongSelf = self else {return}
                        strongSelf.updateAlbumRoles(ref: strongSelf.currRef, initialRoles: initialRoles, mainArtistArr: mainArtistArr, featArtistArr: featArtistArr, initmainArtistArr: initmainArtistArr, initfeatArtistArr: initfeatArtistArr, completion: {err in
                            if let error = err {
                                print("aww shucks")
                                dataUploadCompletionStatus3 = false
                                errors.append(error)
                            } else {
                                dataUploadCompletionStatus3 = true
                                print("Album Roles update done \(i)")
                            }
                            group.leave()
                        })
                    }
                case 4:
                    DispatchQueue.global(qos: .userInitiated).async { [weak self] in
                        guard let strongSelf = self else {return}
                        strongSelf.updateAlbumSubArtistRoles(ref: strongSelf.currRef, initialRoles: initialRoles, mainArtistArr: mainArtistArr, featArtistArr: featArtistArr, initmainArtistArr: initmainArtistArr, initfeatArtistArr: initfeatArtistArr, completion: {err in
                            if let error = err {
                                print("aww shucks")
                                dataUploadCompletionStatus3 = false
                                errors.append(contentsOf: errors)
                            } else {
                                dataUploadCompletionStatus3 = true
                                print("Update Album Sub Artist Roles update done \(i)")
                            }
                            group.leave()
                        })
                    }
                default:
                    print("Edit Person error")
                }
            }
        }
        
        group.notify(queue: DispatchQueue.main) {
            if dataUploadCompletionStatus1 == false || dataUploadCompletionStatus2 == false || dataUploadCompletionStatus3 == false {
                completion(errors)
                return
            } else {
                completion(nil)
            }
        }
    }
    
    func updatePersonAlbums(ref: DatabaseReference, completion: @escaping ((Error?) -> Void)) {
        var initialAlbumArrFromDB:[String]!
        if initPerson.albums == currPerson.albums {
            completion(nil)
            return
        }
        getPersonAlbumsInDB(ref: ref, completion: {[weak self] albums in
            guard let strongSelf = self else {return}
            initialAlbumArrFromDB = albums
            
            if !initialAlbumArrFromDB.isEmpty {
                var removalCounter = 0
                for i in 0 ... initialAlbumArrFromDB.count-1 {
                    if let curralb = strongSelf.currPerson.albums as? [String] {
                        if i < curralb.count {
                            if !curralb[i].contains(initialAlbumArrFromDB[i]) {
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
            if let curralb = strongSelf.currPerson.albums as? [String] {
                if !curralb.isEmpty {
                    for i in 0 ... curralb.count-1 {
                        if i < initialAlbumArrFromDB.count {
                            if !initialAlbumArrFromDB[i].contains(strongSelf.currPerson.albums![i]) {
                                initialAlbumArrFromDB.append(strongSelf.currPerson.albums![i])
                            }
                        } else {
                            initialAlbumArrFromDB.append(strongSelf.currPerson.albums![i])
                        }
                    }
                }
            }
            ref.child("Albums").setValue(initialAlbumArrFromDB.sorted(), withCompletionBlock: { error, reference in
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
    
    func updatePersonAlbumRoles(ref: DatabaseReference, completion: @escaping ((Error?) -> Void)) {
        var rolesInDB:NSDictionary!
        var newRoles:NSDictionary!
        if let ro = currPerson.roles {
            newRoles = ro
        }
        
        getPersonRolesInDB(ref: ref, completion: {[weak self] roles in
            guard let strongSelf = self else {return}
            rolesInDB = roles
            
            ref.child("Roles").setValue(newRoles, withCompletionBlock: { error, reference in
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
    
    func updateAlbumRoles(ref: DatabaseReference, initialRoles:NSMutableDictionary , mainArtistArr: [String], featArtistArr: [String], initmainArtistArr: [String], initfeatArtistArr: [String], completion: @escaping ((Error?) -> Void)) {
        var initialSongArrFromDB:[String]!
        var initialeng:NSMutableDictionary!
        var artRef:DatabaseReference!
        if let eng = initialRoles["Engineer"] as? NSDictionary {
            initialeng = eng.mutableCopy() as! NSMutableDictionary
        }
        
        getPersonAlbumsInDB(ref: ref, completion: {[weak self] albums in
            guard let strongSelf = self else {return}
            initialSongArrFromDB = albums
            
            if let ro = strongSelf.currPerson.roles {
                if !mainArtistArr.isEmpty {
                    if var arti = ro["Artist"] as? [String] {
                        for artist in mainArtistArr {
                            if !arti.contains(artist) {
                                arti.append(artist)
                            }
                        }
                        ro["Artist"] = arti
                    } else {
                        var arti:[String] = []
                        for artist in mainArtistArr {
                            if !arti.contains(artist) {
                                arti.append(artist)
                            }
                        }
                        ro["Artist"] = arti
                    }
                }
                
                if let newenggg = (ro["Engineer"] as? NSDictionary) {
                    strongSelf.currentEngRoles = newenggg
                } else {
                    strongSelf.currentEngRoles = nil
                }
                if let new = ro["Artist"] as? [String] {
                    
                    if let old = initialRoles["Artist"] as? [String] {
                        let semap = DispatchSemaphore(value: 1)
//                        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
//                            guard let strongSelf = self else {return}
                            var count = 0
                        var completioncount = 0
                        
                        if old != new {
                            for item in new {
                                if count != 0 {
                                    usleep(100)
                                }
                                count+=1
                                if !old.contains(item) {
                                    //Add PersonTo song artist: song is item
                                    strongSelf.addPersonToAlbumInDB(son: item, cat: "Artist", mainArtistArr: mainArtistArr, featArtistArr: featArtistArr, completion: {err in
                                        if let err = err {
                                            completion(err)
                                            return
                                        } else {
                                            strongSelf.updateAlbumRolesP2(initialRoles: initialRoles, albums: albums, mainArtistArr: mainArtistArr, featArtistArr: featArtistArr, completion: {err in
                                                completioncount+=1
                                                if let err = err {
                                                    completion(err)
                                                    return
                                                } else {
                                                    
                                                    if completioncount == (old.count+new.count) {
                                                        completion(nil)
                                                    }
                                                }
                                            })
                                        }
                                    })
                                }
                                else {
                                    strongSelf.updateAlbumRolesP2(initialRoles: initialRoles, albums: albums, mainArtistArr: mainArtistArr, featArtistArr: featArtistArr, completion: {err in
                                        completioncount+=1
//                                        semap.signal()
                                        if let err = err {
                                            completion(err)
                                            return
                                        } else {
                                            if completioncount == (old.count+new.count) {
                                                completion(nil)
                                            }
                                        }
                                    })
                                }
//                                semap.wait()
                            }
                            for item in old {
                                
                                if count != 0 {
                                    usleep(100)
                                }
                                count+=1
                                if !new.contains(item) {
                                    strongSelf.removePersonFromAlbumInDB(son: item, cat: "Artist", mainArtistArr: mainArtistArr, featArtistArr: featArtistArr, completion: {err in
                                        if let err = err {
                                            completion(err)
                                            return
                                        } else {
                                            strongSelf.updateAlbumRolesP2(initialRoles: initialRoles, albums: albums, mainArtistArr: mainArtistArr, featArtistArr: featArtistArr, completion: {err in
                                                completioncount+=1
                                                //                                                    semap.signal()
                                                if let err = err {
                                                    completion(err)
                                                    return
                                                } else {
                                                    if completioncount == (old.count+new.count) {
                                                        completion(nil)
                                                    }
                                                }
                                            })
                                        }
                                    })
                                }
                                else {
                                    strongSelf.updateAlbumRolesP2(initialRoles: initialRoles, albums: albums, mainArtistArr: mainArtistArr, featArtistArr: featArtistArr, completion: {err in
                                        completioncount+=1
//                                        semap.signal()
                                        if let err = err {
                                            completion(err)
                                            return
                                        } else {
                                            if completioncount == (old.count+new.count) {
                                                completion(nil)
                                            }
                                        }
                                    })
                                }
                                print("aroldcount ", count, old.count)
//                                semap.wait()
                            }
                        } else {
                            strongSelf.updateAlbumRolesP2(initialRoles: initialRoles, albums: albums, mainArtistArr: mainArtistArr, featArtistArr: featArtistArr, completion: {err in
                                if let err = err {
                                    completion(err)
                                    return
                                } else {
                                    completion(nil)
                                }
                            })
                        }
//                        }
                    } else {
                        let semap = DispatchSemaphore(value: 1)
//                        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
//                            guard let strongSelf = self else {return}
                            var count = 0
                        var completioncount = 0
                            for item in new {
                                if count != 0 {
                                    usleep(100)
                                }
                                count+=1
                                
                                strongSelf.addPersonToAlbumInDB(son: item, cat: "Artist", mainArtistArr: mainArtistArr, featArtistArr: featArtistArr,completion: {err in
                                    if let err = err {
                                        completion(err)
                                        return
                                    } else {
                                        
                                        strongSelf.updateAlbumRolesP2(initialRoles: initialRoles, albums: albums, mainArtistArr: mainArtistArr, featArtistArr: featArtistArr, completion: {err in
                                            completioncount+=1
                                            if let err = err {
                                                completion(err)
                                                return
                                            } else {
                                                if completioncount == (new.count) {
                                                    completion(nil)
                                                }
                                            }
                                        })
                                    }
                                })
                            }
//                        }
                    }
                } else if let old = initialRoles["Artist"] as? [String] {
                    if let new = ro["Artist"] as? [String] {
                        let semap = DispatchSemaphore(value: 1)
//                        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
//                            guard let strongSelf = self else {return}
                            var count = 0
                        var completioncount = 0
                            for item in old {
                                if count != 0 {
                                    usleep(100)
                                }
                                count+=1
                                if !new.contains(item) {
                                    strongSelf.removePersonFromAlbumInDB(son: item, cat: "Artist", mainArtistArr: mainArtistArr, featArtistArr: featArtistArr, completion: {err in
                                        if let err = err {
                                            completion(err)
                                            return
                                        } else {
                                            strongSelf.updateAlbumRolesP2(initialRoles: initialRoles, albums: albums, mainArtistArr: mainArtistArr, featArtistArr: featArtistArr, completion: {err in
                                                completioncount+=1
                                                if let err = err {
                                                    completion(err)
                                                    return
                                                } else {
                                                    if completioncount == (old.count) {
                                                        completion(nil)
                                                    }
                                                }
                                            })
                                        }
                                    })
                                }
                            }
//                        }
                    } else {
                        
                        let semap = DispatchSemaphore(value: 1)
//                        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
//                            guard let strongSelf = self else {return}
                            var count = 0
                        var completioncount = 0
                            for item in old {
                                if count != 0 {
                                    usleep(100)
                                }
                                count+=1
                                strongSelf.removePersonFromAlbumInDB(son: item, cat: "Artist", mainArtistArr: mainArtistArr, featArtistArr: featArtistArr, completion: {err in
                                    if let err = err {
                                        completion(err)
                                        return
                                    } else {
                                        strongSelf.updateAlbumRolesP2(initialRoles: initialRoles, albums: albums, mainArtistArr: mainArtistArr, featArtistArr: featArtistArr, completion: {err in
                                            completioncount+=1
                                            if let err = err {
                                                completion(err)
                                                return
                                            } else {
                                                if completioncount == (old.count) {
                                                    completion(nil)
                                                }
                                            }
                                        })
                                    }
                                })
                            }
//                        }
                    }
                } else {
                    
                    strongSelf.updateAlbumRolesP2(initialRoles: initialRoles, albums: albums, mainArtistArr: mainArtistArr, featArtistArr: featArtistArr, completion: {err in
                        if let err = err {
                            completion(err)
                            return
                        } else {
                            completion(nil)
                        }
                    })
                }
            }
            else {
                if let arr = initialRoles["Artist"] as? [String] {
                    let semap = DispatchSemaphore(value: 1)
                    let group = DispatchGroup()
//                    DispatchQueue.global(qos: .userInitiated).async { [weak self] in
//                        guard let strongSelf = self else {return}
                        var count = 0
                    var completioncount = 0
                        for songg in arr {
                            if count != 0 {
                                usleep(100)
                            }
                            count+=1
                            strongSelf.removePersonFromAlbumInDB(son: songg, cat: "Artist", mainArtistArr: mainArtistArr, featArtistArr: featArtistArr, completion: {err in
                                if let err = err {
                                    completion(err)
                                    return
                                } else {
                                    strongSelf.updateAlbumRolesP2(initialRoles: initialRoles, albums: albums, mainArtistArr: mainArtistArr, featArtistArr: featArtistArr, completion: {err in
                                        completioncount+=1
                                        if let err = err {
                                            completion(err)
                                            return
                                        } else {
                                            if completioncount == (arr.count) {
                                                completion(nil)
                                            }
                                        }
                                    })
                                }
                            })
                        }
                }
                else {
                    strongSelf.updateAlbumRolesP2(initialRoles: initialRoles, albums: albums, mainArtistArr: mainArtistArr, featArtistArr: featArtistArr, completion: {err in
                        if let err = err {
                            completion(err)
                            return
                        } else {
                            completion(nil)
                        }
                    })
                }
            }
        })
    }
    
    func updateAlbumRolesP2(initialRoles:NSMutableDictionary , albums:[String], mainArtistArr: [String], featArtistArr: [String],completion: @escaping ((Error?) -> Void)) {
        var initialAlbumArrFromDB:[String] = albums
        var initialeng:NSMutableDictionary!
        if let eng = initialRoles["Engineer"] as? NSDictionary {
            initialeng = eng.mutableCopy() as! NSMutableDictionary
        }
        
        if let ro = currPerson.roles {
        if let new = ro["Producer"] as? [String] {
            
            if let old = initialRoles["Producer"] as? [String] {
                let semap = DispatchSemaphore(value: 1)
//                DispatchQueue.global(qos: .userInitiated).async { [weak self] in
//                    guard let strongSelf = self else {return}
                if new != old {
                    var count = 0
                    for item in new {
                        if count != 0 {
                            usleep(100)
                        }
                        count+=1
                        if !old.contains(item) {
                            //Add PersonTo song artist: song is item
                            addPersonToAlbumInDB(son: item, cat: "Producer", mainArtistArr: mainArtistArr, featArtistArr: featArtistArr, completion: {err in
                                if new.count != 1 {
//                                    //semap.signal()
                                }
                                if let err = err {
                                    completion(err)
                                    return
                                }
                            })
                        }
                        if new.count != 1 {
//                            //semap.wait()
                        }
                    }
                    for item in old {
                        if count != 0 {
                            usleep(100)
                        }
                        count+=1
                        if !new.contains(item) {
                            
                            //Add PersonTo song artist: song is item
                            removePersonFromAlbumInDB(son: item, cat: "Producer", mainArtistArr: mainArtistArr, featArtistArr: featArtistArr, completion: {err in
                                if old.count != 1 {
                                    //semap.signal()
                                }
                                if let err = err {
                                    completion(err)
                                    return
                                }
                            })
                        }
                        if old.count != 1 {
                            //semap.wait()
                        }
                    }
                }
//                }
            } else {
                let semap = DispatchSemaphore(value: 1)
                let group = DispatchGroup()
//                DispatchQueue.global(qos: .userInitiated).async { [weak self] in
//                    guard let strongSelf = self else {return}
                    var count = 0
                    
                    for item in new {
                        if count != 0 {
                            usleep(100)
                        }
                        count+=1
                        //Add PersonTo song artist: song is item
                        addPersonToAlbumInDB(son: item, cat: "Producer", mainArtistArr: mainArtistArr, featArtistArr: featArtistArr, completion: {err in
                            //semap.signal()
                            if let err = err {
                                completion(err)
                                return
                            }
                        })
                        //semap.wait()
                    }
//                }
            }
        } else if let old = initialRoles["Producer"] as? [String] {
            if let new = ro["Producer"] as? [String] {
                let semap = DispatchSemaphore(value: 1)
                let group = DispatchGroup()
//                DispatchQueue.global(qos: .userInitiated).async { [weak self] in
//                    guard let strongSelf = self else {return}
                    var count = 0
                if old != new {
                    for item in old {
                        if count != 0 {
                            usleep(100)
                        }
                        count+=1
                        if !new.contains(item) {
                            //remove person from song artist: song is item
                            removePersonFromAlbumInDB(son: item, cat: "Producer", mainArtistArr: mainArtistArr, featArtistArr: featArtistArr, completion: {err in
                                //semap.signal()
                                if let err = err {
                                    completion(err)
                                    return
                                }
                            })
                        }
                        //semap.wait()
                    }
                for item in new {
                    if count != 0 {
                        usleep(100)
                    }
                    count+=1
                    if !old.contains(item) {
                        //remove person from song artist: song is item
                        addPersonToAlbumInDB(son: item, cat: "Producer", mainArtistArr: mainArtistArr, featArtistArr: featArtistArr, completion: {err in
                            //semap.signal()
                            if let err = err {
                                completion(err)
                                return
                            }
                        })
                    }
                    //semap.wait()
                }
                }
//                }
            } else {
                let semap = DispatchSemaphore(value: 1)
                let group = DispatchGroup()
//                DispatchQueue.global(qos: .userInitiated).async { [weak self] in
//                    guard let strongSelf = self else {return}
                    var count = 0
                    for item in old {
                        if count != 0 {
                            usleep(100)
                        }
                        count+=1
                        //remove person from song artist: song is item
                        removePersonFromAlbumInDB(son: item, cat: "Producer", mainArtistArr: mainArtistArr, featArtistArr: featArtistArr, completion: {err in
                            //semap.signal()
                            if let err = err {
                                completion(err)
                                return
                            }
                        })
                        //semap.wait()
                    }
//                }
            }
        }
        if let new = ro["Writer"] as? [String] {
            if let old = initialRoles["Writer"] as? [String] {
                let semap = DispatchSemaphore(value: 1)
                let group = DispatchGroup()
//                DispatchQueue.global(qos: .userInitiated).async { [weak self] in
//                    guard let strongSelf = self else {return}
                    var count = 0
                if new != old {
                    for item in new {
                        if count != 0 {
                            usleep(100)
                        }
                        count+=1
                        if !old.contains(item) {
                            //Add PersonTo song artist: song is item
                            addPersonToAlbumInDB(son: item, cat: "Writer", mainArtistArr: mainArtistArr, featArtistArr: featArtistArr, completion: {err in
                                if new.count != 1 {
                                    //semap.signal()
                                }
                                if let err = err {
                                    completion(err)
                                    return
                                }
                            })
                        }
                        if new.count != 1 {
                            //semap.wait()
                        }
                    }
                    for item in old {
                        if count != 0 {
                            usleep(100)
                        }
                        count+=1
                        if !new.contains(item) {
                            //Add PersonTo song artist: song is item
                            removePersonFromAlbumInDB(son: item, cat: "Writer", mainArtistArr: mainArtistArr, featArtistArr: featArtistArr, completion: {err in
                                if old.count != 1 {
                                    //semap.signal()
                                }
                                if let err = err {
                                    completion(err)
                                    return
                                }
                            })
                        }
                        if old.count != 1 {
                            //semap.wait()
                        }
                    }
                }
//                }
            } else {
                let semap = DispatchSemaphore(value: 1)
                let group = DispatchGroup()
//                DispatchQueue.global(qos: .userInitiated).async { [weak self] in
//                    guard let strongSelf = self else {return}
                    var count = 0
                    for item in new {
                        if count != 0 {
                            usleep(100)
                        }
                        count+=1
                        //Add PersonTo song artist: song is item
                        addPersonToAlbumInDB(son: item, cat: "Writer", mainArtistArr: mainArtistArr, featArtistArr: featArtistArr, completion: {err in
                            //semap.signal()
                            if let err = err {
                                completion(err)
                                return
                            }
                        })
                        //semap.wait()
                    }
//                }
            }
        } else if let old = initialRoles["Writer"] as? [String] {
            if let new = ro["Writer"] as? [String] {
                let semap = DispatchSemaphore(value: 1)
                let group = DispatchGroup()
//                DispatchQueue.global(qos: .userInitiated).async { [weak self] in
//                    guard let strongSelf = self else {return}
                    var count = 0
                if new != old {
                    for item in old {
                        if count != 0 {
                            usleep(100)
                        }
                        count+=1
                        if !new.contains(item) {
                            //remove person from song artist: song is item
                            removePersonFromAlbumInDB(son: item, cat: "Writer", mainArtistArr: mainArtistArr, featArtistArr: featArtistArr, completion: {err in
                                //semap.signal()
                                if let err = err {
                                    completion(err)
                                    return
                                }
                            })
                        }
                        //semap.wait()
                    }
                for item in new {
                    if count != 0 {
                        usleep(100)
                    }
                    count+=1
                    if !old.contains(item) {
                        //remove person from song artist: song is item
                        addPersonToAlbumInDB(son: item, cat: "Writer", mainArtistArr: mainArtistArr, featArtistArr: featArtistArr, completion: {err in
                            //semap.signal()
                            if let err = err {
                                completion(err)
                                return
                            }
                        })
                    }
                    //semap.wait()
                }
                }
//                }
            } else {
                let semap = DispatchSemaphore(value: 1)
                let group = DispatchGroup()
//                DispatchQueue.global(qos: .userInitiated).async { [weak self] in
//                    guard let strongSelf = self else {return}
                    var count = 0
                    for item in old {
                        if count != 0 {
                            usleep(100)
                        }
                        count+=1
                        removePersonFromAlbumInDB(son: item, cat: "Writer", mainArtistArr: mainArtistArr, featArtistArr: featArtistArr, completion: {err in
                            //semap.signal()
                            if let err = err {
                                completion(err)
                                return
                            }
                        })
                        //semap.wait()
                    }
//                }
            }
        }
        if let newenggg = (currentEngRoles as? NSDictionary) {
            
            let newengg = newenggg.mutableCopy() as! NSMutableDictionary
            if newengg.count > 0 {
                
            if let new = newengg["Mix Engineer"] as? [String] {
                if let inieng = initialeng as? NSDictionary {
                    let initeng = inieng.mutableCopy() as! NSMutableDictionary
                    
                    if let old = initeng["Mix Engineer"] as? [String] {
                        
                        if new != old {
                            
                            let semap = DispatchSemaphore(value: 1)
//                            DispatchQueue.global(qos: .userInitiated).async { [weak self] in
//                                guard let strongSelf = self else {return}
                                var count = 0
                                for item in new {
                                    if count != 0 {
                                        usleep(100)
                                    }
                                    count+=1
                                    if !old.contains(item) {
                                        addPersonToAlbumInDB(son: item, cat: "Mix Engineer", mainArtistArr: mainArtistArr, featArtistArr: featArtistArr, completion: {err in
                                            if new.count != 1 {
                                                //semap.signal()
                                            }
                                            if let err = err {
                                                completion(err)
                                                return
                                            }
                                        })
                                    }
                                    if new.count != 1 {
                                        //semap.wait()
                                    }
                                }
                            for item in old {
                                
                                if count != 0 {
                                    usleep(100)
                                }
                                count+=1
                                
                                if !new.contains(item) {
                                    
                                    //Add PersonTo song artist: song is item
                                    removePersonFromAlbumInDB(son: item, cat: "Mix Engineer", mainArtistArr: mainArtistArr, featArtistArr: featArtistArr, completion: {err in
                                        if old.count != 1 {
                                            //semap.signal()
                                        }
                                        if let err = err {
                                            completion(err)
                                            return
                                        }
                                    })
                                }
                                if old.count != 1 {
                                    //semap.wait()
                                }
                            }
//                            }
                        }
                    } else {
                        let semap = DispatchSemaphore(value: 1)
                        let group = DispatchGroup()
//                        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
//                            guard let strongSelf = self else {return}
                            var count = 0
                            for item in new {
                                if count != 0 {
                                    usleep(100)
                                }
                                count+=1
                                //Add PersonTo song artist: song is item
                                addPersonToAlbumInDB(son: item, cat: "Mix Engineer", mainArtistArr: mainArtistArr, featArtistArr: featArtistArr, completion: {err in
                                    //semap.signal()
                                    if let err = err {
                                        completion(err)
                                        return
                                    }
                                })
                                //semap.wait()
                            }
//                        }
                    }
                } else {
                    let semap = DispatchSemaphore(value: 1)
//                    DispatchQueue.global(qos: .userInitiated).async { [weak self] in
//                        guard let strongSelf = self else {return}
                        var count = 0
                        for item in new {
                            if count != 0 {
                                usleep(100)
                            }
                            count+=1
                            //Add PersonTo song artist: song is item
                            addPersonToAlbumInDB(son: item, cat: "Mix Engineer", mainArtistArr: mainArtistArr, featArtistArr: featArtistArr, completion: {err in
                                //semap.signal()
                                if let err = err {
                                    completion(err)
                                    return
                                }
                            })
                            //semap.wait()
                        }
//                    }
                }
            }
                else if let inieng = initialeng as? NSDictionary {
                    let initeng = inieng.mutableCopy() as! NSMutableDictionary
                    if let old = initeng["Mix Engineer"] as? [String] {
                        if let new = newengg["Mix Engineer"] as? [String] {
                            
                            if new != old {
                                let semap = DispatchSemaphore(value: 1)
//                                DispatchQueue.global(qos: .userInitiated).async { [weak self] in
//                                    guard let strongSelf = self else {return}
                                    var count = 0
                                for item in old {
                                    if count != 0 {
                                        usleep(100)
                                    }
                                    count+=1
                                    if !new.contains(item) {
                                        //remove person from song artist: song is item
                                        removePersonFromAlbumInDB(son: item, cat: "Mix Engineer", mainArtistArr: mainArtistArr, featArtistArr: featArtistArr, completion: {err in
                                            //semap.signal()
                                            if let err = err {
                                                completion(err)
                                                return
                                            }
                                        })
                                    }
                                    //semap.wait()
                                    }
                                for item in new {
                                    if count != 0 {
                                        usleep(100)
                                    }
                                    count+=1
                                    if !old.contains(item) {
                                        //remove person from song artist: song is item
                                        removePersonFromAlbumInDB(son: item, cat: "Mix Engineer", mainArtistArr: mainArtistArr, featArtistArr: featArtistArr, completion: {err in
                                            //semap.signal()
                                            if let err = err {
                                                completion(err)
                                                return
                                            }
                                        })
                                    }
                                    //semap.wait()
                                    }
//                                }
                            }
                        } else {
                            let semap = DispatchSemaphore(value: 1)
//                            DispatchQueue.global(qos: .userInitiated).async { [weak self] in
//                                guard let strongSelf = self else {return}
                                var count = 0
                                for item in old {
                                    if count != 0 {
                                        usleep(100)
                                    }
                                    count+=1
                                    //remove person from song artist: song is item
                                    removePersonFromAlbumInDB(son: item, cat: "Mix Engineer", mainArtistArr: mainArtistArr, featArtistArr: featArtistArr, completion: {err in
                                        //semap.signal()
                                        if let err = err {
                                            completion(err)
                                            return
                                        }
                                        
                                    })
                                    //semap.wait()
                                }
//                            }
                        }
                }
            }
                
                
                if let new = newengg["Mastering Engineer"] as? [String] {
                    if let inieng = initialeng as? NSDictionary {
                        let initeng = inieng.mutableCopy() as! NSMutableDictionary
                        if let old = initeng["Mastering Engineer"] as? [String] {
                            let semap = DispatchSemaphore(value: 1)
//                            DispatchQueue.global(qos: .userInitiated).async { [weak self] in
//                                guard let strongSelf = self else {return}
                                var count = 0
                            if new != old {
                                for item in new {
                                    if count != 0 {
                                        usleep(100)
                                    }
                                    count+=1
                                    if !old.contains(item) {
                                        //Add PersonTo song artist: song is item
                                        addPersonToAlbumInDB(son: item, cat: "Mastering Engineer", mainArtistArr: mainArtistArr, featArtistArr: featArtistArr, completion: {err in
                                            if new.count != 1 {
//                                            //semap.signal()
                                            }
                                            if let err = err {
                                                completion(err)
                                                return
                                            }
                                        })
                                    }
                                    if new.count != 1 {
//                                    //semap.wait()
                                    }
                                }
                                for item in old {
                                    if count != 0 {
                                        usleep(100)
                                    }
                                    count+=1
                                    if !new.contains(item) {
                                        //Add PersonTo song artist: song is item
                                        removePersonFromAlbumInDB(son: item, cat: "Mastering Engineer", mainArtistArr: mainArtistArr, featArtistArr: featArtistArr, completion: {err in
                                            if old.count != 1 {
//                                            //semap.signal()
                                            }
                                            if let err = err {
                                                completion(err)
                                                return
                                            }
                                        })
                                    }
                                    if old.count != 1 {
//                                    //semap.wait()
                                    }
                                }
                            }
//                            }
                        } else {
                            let semap = DispatchSemaphore(value: 1)
                                var count = 0
                            for item in new {
                                if count != 0 {
                                    usleep(100)
                                }
                                count+=1
                                //Add PersonTo song artist: song is item
                                addPersonToAlbumInDB(son: item, cat: "Mastering Engineer", mainArtistArr: mainArtistArr, featArtistArr: featArtistArr, completion: {err in
                                    //semap.signal()
                                    if let err = err {
                                        completion(err)
                                        return
                                    }
                                })
                                //semap.wait()
                            }
//                            }
                        }
                    } else {
                        
                            let semap = DispatchSemaphore(value: 1)
//                            DispatchQueue.global(qos: .userInitiated).async { [weak self] in
//                                guard let strongSelf = self else {return}
                                var count = 0
                        for item in new {
                            if count != 0 {
                                usleep(100)
                            }
                            count+=1
                            //Add PersonTo song artist: song is item
                            addPersonToAlbumInDB(son: item, cat: "Mastering Engineer", mainArtistArr: mainArtistArr, featArtistArr: featArtistArr, completion: {err in
                                //semap.signal()
                                if let err = err {
                                    completion(err)
                                    return
                                }
                            })
                            //semap.wait()
                        }
//                        }
                    }
                }
                else if let inieng = initialeng as? NSDictionary {
                    let initeng = inieng.mutableCopy() as! NSMutableDictionary
                    if let old = initeng["Mastering Engineer"] as? [String] {
                        if let new = newengg["Mastering Engineer"] as? [String] {
                            
                            if new != old {
                                let semap = DispatchSemaphore(value: 1)
                                let group = DispatchGroup()
//                                DispatchQueue.global(qos: .userInitiated).async { [weak self] in
//                                    guard let strongSelf = self else {return}
                                    var count = 0
                                for item in old {
                                    if count != 0 {
                                        usleep(100)
                                    }
                                    count+=1
                                    if !new.contains(item) {
                                        //remove person from song artist: song is item
                                        removePersonFromAlbumInDB(son: item, cat: "Mastering Engineer", mainArtistArr: mainArtistArr, featArtistArr: featArtistArr, completion: {err in
                                            //semap.signal()
                                            if let err = err {
                                                completion(err)
                                                return
                                            }
                                        })
                                    }
                                    //semap.wait()
                                }
                                for item in new {
                                    if count != 0 {
                                        usleep(100)
                                    }
                                    count+=1
                                    if !old.contains(item) {
                                        //remove person from song artist: song is item
                                        addPersonToAlbumInDB(son: item, cat: "Mastering Engineer", mainArtistArr: mainArtistArr, featArtistArr: featArtistArr, completion: {err in
                                            //semap.signal()
                                            if let err = err {
                                                completion(err)
                                                return
                                            }
                                        })
                                    }
                                    //semap.wait()
                                }
//                                }
                            }
                        } else {
                            let semap = DispatchSemaphore(value: 1)
                            let group = DispatchGroup()
//                            DispatchQueue.global(qos: .userInitiated).async { [weak self] in
//                                guard let strongSelf = self else {return}
                                var count = 0
                                for item in old {
                                    if count != 0 {
                                        usleep(100)
                                    }
                                    count+=1
                                    //remove person from song artist: song is item
                                    removePersonFromAlbumInDB(son: item, cat: "Mastering Engineer", mainArtistArr: mainArtistArr, featArtistArr: featArtistArr, completion: {err in
                                        //semap.signal()
                                        if let err = err {
                                            completion(err)
                                            return
                                        }
                                    })
                                    //semap.wait()
                                }
//                            }
                        }
                    }
                }
                
                if let new = newengg["Recording Engineer"] as? [String] {
                    if let inieng = initialeng as? NSDictionary {
                        let initeng = inieng.mutableCopy() as! NSMutableDictionary
                        if let old = initeng["Recording Engineer"] as? [String] {
                            
                            if new != old {
                                let semap = DispatchSemaphore(value: 1)
                                let group = DispatchGroup()
//                                DispatchQueue.global(qos: .userInitiated).async { [weak self] in
//                                    guard let strongSelf = self else {return}
                                    var count = 0
                                    for item in new {
                                        if count != 0 {
                                            usleep(100)
                                        }
                                        count+=1
                                        if !old.contains(item) {
                                            //Add PersonTo song artist: song is item
                                            addPersonToAlbumInDB(son: item, cat: "Recording Engineer", mainArtistArr: mainArtistArr, featArtistArr: featArtistArr, completion: {err in
                                                //semap.signal()
                                                if let err = err {
                                                    completion(err)
                                                    return
                                                }
                                            })
                                        }
                                        //semap.wait()
                                    }
                                for item in old {
                                    if count != 0 {
                                        usleep(100)
                                    }
                                    count+=1
                                    if !new.contains(item) {
                                        //Add PersonTo song artist: song is item
                                        removePersonFromAlbumInDB(son: item, cat: "Recording Engineer", mainArtistArr: mainArtistArr, featArtistArr: featArtistArr, completion: {err in
                                            //semap.signal()
                                            if let err = err {
                                                completion(err)
                                                return
                                            }
                                        })
                                    }
                                    //semap.wait()
                                }
//                                }
                            }
                        } else {
                            let semap = DispatchSemaphore(value: 1)
                            let group = DispatchGroup()
//                            DispatchQueue.global(qos: .userInitiated).async { [weak self] in
//                                guard let strongSelf = self else {return}
                                var count = 0
                                for item in new {
                                    if count != 0 {
                                        usleep(100)
                                    }
                                    count+=1
                                    //Add PersonTo song artist: song is item
                                    addPersonToAlbumInDB(son: item, cat: "Recording Engineer", mainArtistArr: mainArtistArr, featArtistArr: featArtistArr, completion: {err in
                                        //semap.signal()
                                        if let err = err {
                                            completion(err)
                                            return
                                        }
                                    })
                                    //semap.wait()
                                }
//                            }
                        }
                    } else {
                        let semap = DispatchSemaphore(value: 1)
                        let group = DispatchGroup()
//                        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
//                            guard let strongSelf = self else {return}
                            var count = 0
                            for item in new {
                                if count != 0 {
                                    usleep(100)
                                }
                                count+=1
                                //Add PersonTo song artist: song is item
                                addPersonToAlbumInDB(son: item, cat: "Recording Engineer", mainArtistArr: mainArtistArr, featArtistArr: featArtistArr, completion: {err in
                                    //semap.signal()
                                    if let err = err {
                                        completion(err)
                                        return
                                    }
                                })
                                //semap.wait()
                            }
//                        }
                    }
                }
                else if let inieng = initialeng as? NSDictionary {
                    let initeng = inieng.mutableCopy() as! NSMutableDictionary
                    if let old = initeng["Recording Engineer"] as? [String] {
                        if let new = newengg["Recording Engineer"] as? [String] {
                            if new != old {
                                let semap = DispatchSemaphore(value: 1)
//                                DispatchQueue.global(qos: .userInitiated).async { [weak self] in
//                                    guard let strongSelf = self else {return}
                                    var count = 0
                                    for item in old {
                                        if count != 0 {
                                            usleep(100)
                                        }
                                        count+=1
                                        if !new.contains(item) {
                                            //remove person from song artist: song is item
                                            removePersonFromAlbumInDB(son: item, cat: "Recording Engineer", mainArtistArr: mainArtistArr, featArtistArr: featArtistArr, completion: {err in
                                                //semap.signal()
                                                if let err = err {
                                                    completion(err)
                                                    return
                                                }
                                            })
                                        }
                                        //semap.wait()
                                    }
                                for item in new {
                                    if count != 0 {
                                        usleep(100)
                                    }
                                    count+=1
                                    if !old.contains(item) {
                                        //remove person from song artist: song is item
                                        addPersonToAlbumInDB(son: item, cat: "Recording Engineer", mainArtistArr: mainArtistArr, featArtistArr: featArtistArr, completion: {err in
                                            //semap.signal()
                                            if let err = err {
                                                completion(err)
                                                return
                                            }
                                        })
                                    }
                                    //semap.wait()
                                }
//                                }
                            }
                        } else {
                            let semap = DispatchSemaphore(value: 1)
//                            DispatchQueue.global(qos: .userInitiated).async { [weak self] in
//                                guard let strongSelf = self else {return}
                                var count = 0
                                for item in old {
                                    if count != 0 {
                                        usleep(100)
                                    }
                                    count+=1
                                    //remove person from song artist: song is item
                                    removePersonFromAlbumInDB(son: item, cat: "Recording Engineer", mainArtistArr: mainArtistArr, featArtistArr: featArtistArr, completion: {err in
                                        //semap.signal()
                                        if let err = err {
                                            completion(err)
                                            return
                                        }
                                        //                                    else {
                                        //                                        completion(nil)
                                        //                                    }
                                    })
                                    //semap.wait()
                                }
//                            }
                        }
                    }
                }
            }
            
        } else if let oldenggg = initialRoles["Engineer"] as? NSDictionary {
            let oldnegg = oldenggg.mutableCopy() as! NSMutableDictionary
            if let newengg = ro["Engineer"] as? NSMutableDictionary {
                if let new = newengg["Mix Engineer"] as? [String] {
                    if let old = initialeng["Mix Engineer"] as? [String] {
                        if new != old {
                            let semap = DispatchSemaphore(value: 1)
                            let group = DispatchGroup()
//                            DispatchQueue.global(qos: .userInitiated).async { [weak self] in
//                                guard let strongSelf = self else {return}
                                var count = 0
                                for item in new {
                                    if count != 0 {
                                        usleep(100)
                                    }
                                    count+=1
                                    if !old.contains(item) {
                                        //Add PersonTo song artist: song is item
                                        addPersonToAlbumInDB(son: item, cat: "Mix Engineer", mainArtistArr: mainArtistArr, featArtistArr: featArtistArr, completion: {err in
                                            //semap.signal()
                                            if let err = err {
                                                completion(err)
                                                return
                                            }
                                        })
                                    }
                                    //semap.wait()
                                }
                            for item in old {
                                if count != 0 {
                                    usleep(100)
                                }
                                count+=1
                                if !new.contains(item) {
                                    //Add PersonTo song artist: song is item
                                    removePersonFromAlbumInDB(son: item, cat: "Mix Engineer", mainArtistArr: mainArtistArr, featArtistArr: featArtistArr, completion: {err in
                                        //semap.signal()
                                        if let err = err {
                                            completion(err)
                                            return
                                        }
                                    })
                                }
                                //semap.wait()
                            }
//                            }
                        }
                    } else {
                        let semap = DispatchSemaphore(value: 1)
                        let group = DispatchGroup()
//                        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
//                            guard let strongSelf = self else {return}
                            var count = 0
                            for item in new {
                                if count != 0 {
                                    usleep(100)
                                }
                                count+=1
                                //Add PersonTo song artist: song is item
                                addPersonToAlbumInDB(son: item, cat: "Mix Engineer", mainArtistArr: mainArtistArr, featArtistArr: featArtistArr, completion: {err in
                                    //semap.signal()
                                    if let err = err {
                                        completion(err)
                                        return
                                    }
                                })
                                //semap.wait()
                            }
//                        }
                    }
                } else if let old = initialeng["Mix Engineer"] as? [String] {
                    if let new = newengg["Mix Engineer"] as? [String] {
                        if new != old {
                            let semap = DispatchSemaphore(value: 1)
                            let group = DispatchGroup()
//                            DispatchQueue.global(qos: .userInitiated).async { [weak self] in
//                                guard let strongSelf = self else {return}
                                var count = 0
                                for item in old {
                                    if count != 0 {
                                        usleep(100)
                                    }
                                    count+=1
                                    if !new.contains(item) {
                                        //remove person from song artist: song is item
                                        removePersonFromAlbumInDB(son: item, cat: "Mix Engineer", mainArtistArr: mainArtistArr, featArtistArr: featArtistArr, completion: {err in
                                            //semap.signal()
                                            if let err = err {
                                                completion(err)
                                                return
                                            }
                                        })
                                    }
                                    //semap.wait()
                                }
                            for item in new {
                                if count != 0 {
                                    usleep(100)
                                }
                                count+=1
                                if !old.contains(item) {
                                    //remove person from song artist: song is item
                                    addPersonToAlbumInDB(son: item, cat: "Mix Engineer", mainArtistArr: mainArtistArr, featArtistArr: featArtistArr, completion: {err in
                                        //semap.signal()
                                        if let err = err {
                                            completion(err)
                                            return
                                        }
                                    })
                                }
                                //semap.wait()
                            }
//                            }
                        }
                    } else {
                        let semap = DispatchSemaphore(value: 1)
                        let group = DispatchGroup()
//                        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
//                            guard let strongSelf = self else {return}
                            var count = 0
                            for item in old {
                                if count != 0 {
                                    usleep(100)
                                }
                                count+=1
                                //remove person from song artist: song is item
                                removePersonFromAlbumInDB(son: item, cat: "Mix Engineer", mainArtistArr: mainArtistArr, featArtistArr: featArtistArr, completion: {err in
                                    //semap.signal()
                                    if let err = err {
                                        completion(err)
                                        return
                                    }
                                })
                                //semap.wait()
                            }
//                        }
                    }
                }
                if let new = newengg["Mastering Engineer"] as? [String] {
                    
                    if let old = initialeng["Mastering Engineer"] as? [String] {
                        if new != old {
                            let semap = DispatchSemaphore(value: 1)
//                            DispatchQueue.global(qos: .userInitiated).async { [weak self] in
//                                guard let strongSelf = self else {return}
                                var count = 0
                                for item in new {
                                    if count != 0 {
                                        usleep(100)
                                    }
                                    count+=1
                                    if !old.contains(item) {
                                        //Add PersonTo song artist: song is item
                                        addPersonToAlbumInDB(son: item, cat: "Mastering Engineer", mainArtistArr: mainArtistArr, featArtistArr: featArtistArr, completion: {err in
                                            //semap.signal()
                                            if let err = err {
                                                completion(err)
                                                return
                                            }
                                        })
                                    }
                                    //semap.wait()
                                }
                            for item in old {
                                if count != 0 {
                                    usleep(100)
                                }
                                count+=1
                                if !new.contains(item) {
                                    //Add PersonTo song artist: song is item
                                    removePersonFromAlbumInDB(son: item, cat: "Mastering Engineer", mainArtistArr: mainArtistArr, featArtistArr: featArtistArr, completion: {err in
                                        //semap.signal()
                                        if let err = err {
                                            completion(err)
                                            return
                                        }
                                    })
                                }
                                //semap.wait()
                            }
//                            }
                        }
                    } else {
                        let semap = DispatchSemaphore(value: 1)
//                        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
//                            guard let strongSelf = self else {return}
                            var count = 0
                            for item in new {
                                if count != 0 {
                                    usleep(100)
                                }
                                count+=1
                                //Add PersonTo song artist: song is item
                                addPersonToAlbumInDB(son: item, cat: "Mastering Engineer", mainArtistArr: mainArtistArr, featArtistArr: featArtistArr, completion: {err in
                                    //semap.signal()
                                    if let err = err {
                                        completion(err)
                                        return
                                    }
                                })
                                //semap.wait()
                            }
//                        }
                    }
                } else if let old = initialeng["Mastering Engineer"] as? [String] {
                    if let new = newengg["Mastering Engineer"] as? [String] {
                        if new != old {
                            let semap = DispatchSemaphore(value: 1)
                            let group = DispatchGroup()
//                            DispatchQueue.global(qos: .userInitiated).async { [weak self] in
//                                guard let strongSelf = self else {return}
                                var count = 0
                                for item in old {
                                    if count != 0 {
                                        usleep(100)
                                    }
                                    count+=1
                                    if !new.contains(item) {
                                        //remove person from song artist: song is item
                                        removePersonFromAlbumInDB(son: item, cat: "Mastering Engineer", mainArtistArr: mainArtistArr, featArtistArr: featArtistArr, completion: {err in
                                            //semap.signal()
                                            if let err = err {
                                                completion(err)
                                                return
                                            }
                                            //                                            else {
                                            //                                                completion(nil)
                                            //                                            }
                                        })
                                    }
                                    //semap.wait()
                                }
                            for item in new {
                                if count != 0 {
                                    usleep(100)
                                }
                                count+=1
                                if !old.contains(item) {
                                    //remove person from song artist: song is item
                                    addPersonToAlbumInDB(son: item, cat: "Mastering Engineer", mainArtistArr: mainArtistArr, featArtistArr: featArtistArr, completion: {err in
                                        //semap.signal()
                                        if let err = err {
                                            completion(err)
                                            return
                                        }
                                        //                                            else {
                                        //                                                completion(nil)
                                        //                                            }
                                    })
                                }
                                //semap.wait()
                            }
//                            }
                        }
                    } else {
                        let semap = DispatchSemaphore(value: 1)
                        let group = DispatchGroup()
//                        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
//                            guard let strongSelf = self else {return}
                            var count = 0
                            for item in old {
                                if count != 0 {
                                    usleep(100)
                                }
                                count+=1
                                //remove person from song artist: song is item
                                removePersonFromAlbumInDB(son: item, cat: "Mastering Engineer", mainArtistArr: mainArtistArr, featArtistArr: featArtistArr, completion: {err in
                                    //semap.signal()
                                    if let err = err {
                                        completion(err)
                                        return
                                    }
                                    //                                        else {
                                    //                                            completion(nil)
                                    //                                        }
                                })
                                //semap.wait()
                            }
//                        }
                    }
                }
                if let new = newengg["Recording Engineer"] as? [String] {
                    if let old = initialeng["Recording Engineer"] as? [String] {
                        if new != old {
                            let semap = DispatchSemaphore(value: 1)
                            let group = DispatchGroup()
//                            DispatchQueue.global(qos: .userInitiated).async { [weak self] in
//                                guard let strongSelf = self else {return}
                                var count = 0
                                for item in new {
                                    if count != 0 {
                                        usleep(100)
                                    }
                                    count+=1
                                    if !old.contains(item) {
                                        //Add PersonTo song artist: song is item
                                        addPersonToAlbumInDB(son: item, cat: "Recording Engineer", mainArtistArr: mainArtistArr, featArtistArr: featArtistArr, completion: {err in
                                            //semap.signal()
                                            if let err = err {
                                                completion(err)
                                                return
                                            }
                                            //                                            else {
                                            //                                                completion(nil)
                                            //                                            }
                                        })
                                    }
                                    //semap.wait()
                                }
                            for item in old {
                                if count != 0 {
                                    usleep(100)
                                }
                                count+=1
                                if !new.contains(item) {
                                    //Add PersonTo song artist: song is item
                                    removePersonFromAlbumInDB(son: item, cat: "Recording Engineer", mainArtistArr: mainArtistArr, featArtistArr: featArtistArr, completion: {err in
                                        //semap.signal()
                                        if let err = err {
                                            completion(err)
                                            return
                                        }
                                        //                                            else {
                                        //                                                completion(nil)
                                        //                                            }
                                    })
                                }
                                //semap.wait()
                            }
//                            }
                        }
                    } else {
                        let semap = DispatchSemaphore(value: 1)
//                        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
//                            guard let strongSelf = self else {return}
                            var count = 0
                            for item in new {
                                if count != 0 {
                                    usleep(100)
                                }
                                count+=1
                                //Add PersonTo song artist: song is item
                                addPersonToAlbumInDB(son: item, cat: "Recording Engineer", mainArtistArr: mainArtistArr, featArtistArr: featArtistArr, completion: {err in
                                    //semap.signal()
                                    if let err = err {
                                        completion(err)
                                        return
                                    }
                                })
                                //semap.wait()
                            }
//                        }
                    }
                } else if let old = initialeng["Recording Engineer"] as? [String] {
                    if let new = newengg["Recording Engineer"] as? [String] {
                        if new != old {
                            let semap = DispatchSemaphore(value: 1)
//                            DispatchQueue.global(qos: .userInitiated).async { [weak self] in
//                                guard let strongSelf = self else {return}
                                var count = 0
                                for item in old {
                                    if count != 0 {
                                        usleep(100)
                                    }
                                    count+=1
                                    if !new.contains(item) {
                                        //remove person from song artist: song is item
                                        removePersonFromAlbumInDB(son: item, cat: "Recording Engineer", mainArtistArr: mainArtistArr, featArtistArr: featArtistArr, completion: {err in
                                            //semap.signal()
                                            if let err = err {
                                                completion(err)
                                                return
                                            }
                                        })
                                    }
                                    //semap.wait()
                                }
                            for item in new {
                                if count != 0 {
                                    usleep(100)
                                }
                                count+=1
                                if !old.contains(item) {
                                    //remove person from song artist: song is item
                                    addPersonToAlbumInDB(son: item, cat: "Recording Engineer", mainArtistArr: mainArtistArr, featArtistArr: featArtistArr, completion: {err in
                                        //semap.signal()
                                        if let err = err {
                                            completion(err)
                                            return
                                        }
                                    })
                                }
                                //semap.wait()
                            }
//                            }
                        }
                    } else {
                        let semap = DispatchSemaphore(value: 1)
                        let group = DispatchGroup()
//                        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
//                            guard let strongSelf = self else {return}
                            var count = 0
                            for item in old {
                                if count != 0 {
                                    usleep(100)
                                }
                                count+=1
                                removePersonFromAlbumInDB(son: item, cat: "Recording Engineer", mainArtistArr: mainArtistArr, featArtistArr: featArtistArr, completion: {err in
                                    //semap.signal()
                                    if let err = err {
                                        completion(err)
                                        return
                                    }
                                })
                                //semap.wait()
                            }
//                        }
                    }
                }
            } else {
                if let old = oldenggg["Mix Engineer"] as? [String] {
                    let semap = DispatchSemaphore(value: 1)
                    let group = DispatchGroup()
//                    DispatchQueue.global(qos: .userInitiated).async { [weak self] in
//                        guard let strongSelf = self else {return}
                        var count = 0
                        for item in old {
                            
                            //remove person from song artist: song is item
                            removePersonFromAlbumInDB(son: item, cat: "Mix Engineer", mainArtistArr: mainArtistArr, featArtistArr: featArtistArr, completion: {err in
                                //semap.signal()
                                if let err = err {
                                    completion(err)
                                    return
                                }
                            })
                            //semap.wait()
                        }
//                    }
                }
                if let old = oldenggg["Mastering Engineer"] as? [String] {
                    let semap = DispatchSemaphore(value: 1)
                    let group = DispatchGroup()
//                    DispatchQueue.global(qos: .userInitiated).async { [weak self] in
//                        guard let strongSelf = self else {return}
                        var count = 0
                        for item in old {
                            if count != 0 {
                                usleep(100)
                            }
                            count+=1
                            removePersonFromAlbumInDB(son: item, cat: "Mastering Engineer", mainArtistArr: mainArtistArr, featArtistArr: featArtistArr, completion: {err in
                                //semap.signal()
                                if let err = err {
                                    completion(err)
                                    return
                                }
                            })
                            //semap.wait()
                        }
//                    }
                }
                if let old = oldenggg["Recording Engineer"] as? [String] {
                    let semap = DispatchSemaphore(value: 1)
                    let group = DispatchGroup()
//                    DispatchQueue.global(qos: .userInitiated).async { [weak self] in
//                        guard let strongSelf = self else {return}
                        var count = 0
                        for item in old {
                            if count != 0 {
                                usleep(100)
                            }
                            count+=1
                            removePersonFromAlbumInDB(son: item, cat: "Recording Engineer", mainArtistArr: mainArtistArr, featArtistArr: featArtistArr, completion: {err in
                                //semap.signal()
                                if let err = err {
                                    completion(err)
                                    return
                                }
                            })
                            //semap.wait()
                        }
//                    }
                }
            }
        }
        }
        else {
            if let arr = initialRoles["Producer"] as? [String] {
                let semap = DispatchSemaphore(value: 1)
                let group = DispatchGroup()
//                DispatchQueue.global(qos: .userInitiated).async { [weak self] in
//                    guard let strongSelf = self else {return}
                    var count = 0
                    for songg in arr {
                        if count != 0 {
                            usleep(100)
                        }
                        count+=1
                        removePersonFromAlbumInDB(son: songg, cat: "Producer", mainArtistArr: mainArtistArr, featArtistArr: featArtistArr, completion:{ err in
                            //semap.signal()
                            if let err = err {
                                completion(err)
                                return
                            }
                        })
                        //semap.wait()
                    }
//                }
            }
            if let arr = initialRoles["Writer"] as? [String] {
                let semap = DispatchSemaphore(value: 1)
                let group = DispatchGroup()
//                DispatchQueue.global(qos: .userInitiated).async { [weak self] in
//                    guard let strongSelf = self else {return}
                    var count = 0
                    for songg in arr {
                        if count != 0 {
                            usleep(100)
                        }
                        count+=1
                        removePersonFromAlbumInDB(son: songg, cat: "Writer", mainArtistArr: mainArtistArr, featArtistArr: featArtistArr, completion:{ err in
                            //semap.signal()
                            if let err = err {
                                completion(err)
                                return
                            }
                        })
                        //semap.wait()
                    }
//                }
            }
            if let engg = initialRoles["Engineer"] as? NSMutableDictionary {
                if let arr = engg["Mix Engineer"] as? [String] {
                    let semap = DispatchSemaphore(value: 1)
                    let group = DispatchGroup()
//                    DispatchQueue.global(qos: .userInitiated).async { [weak self] in
//                        guard let strongSelf = self else {return}
                        var count = 0
                        for songg in arr {
                            if count != 0 {
                                usleep(100)
                            }
                            count+=1
                            removePersonFromAlbumInDB(son: songg, cat: "Mix Engineer", mainArtistArr: mainArtistArr, featArtistArr: featArtistArr, completion:{ err in
                                //semap.signal()
                                if let err = err {
                                    completion(err)
                                    return
                                }
                            })
                            //semap.wait()
                        }
//                    }
                }
                if let arr = engg["Mastering Engineer"] as? [String] {
                    let semap = DispatchSemaphore(value: 1)
                    let group = DispatchGroup()
//                    DispatchQueue.global(qos: .userInitiated).async { [weak self] in
//                        guard let strongSelf = self else {return}
                        var count = 0
                        for songg in arr {
                            if count != 0 {
                                usleep(100)
                            }
                            count+=1
                            removePersonFromAlbumInDB(son: songg, cat: "Mastering Engineer", mainArtistArr: mainArtistArr, featArtistArr: featArtistArr, completion:{ err in
                                //semap.signal()
                                if let err = err {
                                    completion(err)
                                    return
                                }
                            })
                            //semap.wait()
                        }
//                    }
                }
                if let arr = engg["Recording Engineer"] as? [String] {
                    let semap = DispatchSemaphore(value: 1)
                    let group = DispatchGroup()
//                    DispatchQueue.global(qos: .userInitiated).async { [weak self] in
//                        guard let strongSelf = self else {return}
                        var count = 0
                        for songg in arr {
                            if count != 0 {
                                usleep(100)
                            }
                            count+=1
                            removePersonFromAlbumInDB(son: songg, cat: "Recording Engineer", mainArtistArr: mainArtistArr, featArtistArr: featArtistArr, completion:{ err in
                                //semap.signal()
                                if let err = err {
                                    completion(err)
                                    return
                                }
                            })
                            //semap.wait()
                        }
//                    }
                }
                
            }
        }
        
        if initialAlbumArrFromDB == currPerson.albums
        {
            completion(nil)
            return
        }
        
        if !initialAlbumArrFromDB.isEmpty {
            let semaphore = DispatchSemaphore(value: 1)
            var count = 0
            for i in 0 ... initialAlbumArrFromDB.count-1 {
                if count != 0 {
                    usleep(100)
                }
                count+=1
                if currPerson.albums != nil {
                    if i < currPerson.albums!.count {
                        if !currPerson.albums![i].contains(initialAlbumArrFromDB[i]) {
                            removePersonFromAlbumInDB(son: initialAlbumArrFromDB[i], mainArtistArr: mainArtistArr, featArtistArr: featArtistArr, completion: {err in
                                //                            semaphore.signal()
                                if let err = err {
                                    completion(err)
                                    return
                                }
                            })
                        } else {
                            //                        semaphore.signal()
                        }
                    } else {
                        removePersonFromAlbumInDB(son: initialAlbumArrFromDB[i], mainArtistArr: mainArtistArr, featArtistArr: featArtistArr, completion: {err in
                            if let err = err {
                                completion(err)
                                return
                            }
                        })
                    }
                } else {
                    removePersonFromAlbumInDB(son: initialAlbumArrFromDB[i], mainArtistArr: mainArtistArr, featArtistArr: featArtistArr, completion: {err in
                        if let err = err {
                            completion(err)
                            return
                        }
                    })
                }
            }
        }
        if currPerson.albums != nil {
            if !currPerson.albums!.isEmpty {
                let semaphore = DispatchSemaphore(value: 1)
                
                let group = DispatchGroup()
                //            DispatchQueue.global(qos: .userInitiated).async { [weak self] in
                //                guard let strongSelf = self else {return}
                var count = 0
                var songcount = 0
                for i in 0 ... currPerson.albums!.count-1 {
                    if count != 0 {
                        usleep(100)
                    }
                    count+=1
                    if i < initialAlbumArrFromDB.count {
                        if !initialAlbumArrFromDB[i].contains(currPerson.albums![i]) {
                            addPersonToAlbumInDB(son: currPerson.albums![i], mainArtistArr: mainArtistArr, featArtistArr: featArtistArr, completion: {[weak self] err in
                                guard let strongSelf = self else {return}
                                //                                semaphore.signal()
                                if let err = err {
                                    completion(err)
                                    return
                                }
                                else {
                                    
                                    songcount+=1
                                    if songcount == strongSelf.currPerson.albums!.count {
                                        completion(nil)
                                    }
                                }
                            })
                        }
                        else {
                            //                            semaphore.signal()
                            songcount+=1
                            if songcount == currPerson.albums!.count {
                                completion(nil)
                            }
                        }
                    } else {
                        addPersonToAlbumInDB(son: currPerson.albums![i], mainArtistArr: mainArtistArr, featArtistArr: featArtistArr, completion: {[weak self] err in
                            guard let strongSelf = self else {return}
                            //                            semaphore.signal()
                            if let err = err {
                                completion(err)
                                return
                            }else {
                                
                                songcount+=1
                                if songcount == strongSelf.currPerson.albums!.count {
                                    completion(nil)
                                }
                            }
                        })
                    }
                    //                    semaphore.wait()
                }
                //            }
            }
            else {
                completion(nil)
            }
        }
        else {
            completion(nil)
        }
    }
    
    func removePersonFromAlbumInDB(son: String, mainArtistArr:[String], featArtistArr:[String], completion: @escaping ((Error?) -> Void)) {
        guard son.count == 8 else {
            completion(nil)
            return
        }
        let word = son.split(separator: "Æ")
        let id = word[0]
        DatabaseManager.shared.findAlbumById(albumId: String(id), completion: {[weak self] result in
            guard let strongSelf = self else {return}
            switch result {
            case .success(let album):
                let ref = Database.database().reference().child("Music Content").child("Albums").child( "\(albumContentTag)--\(album.name)--\(album.toneDeafAppId)").child("REQUIRED")
                let person = "\(strongSelf.currPerson.toneDeafAppId)"
                if album.mainArtist.contains(person) {
                    let index = album.mainArtist.firstIndex(of: person)
                    album.mainArtist.remove(at: index!)
                }
                if var arrrr = album.allArtists as? [String] {
                    if arrrr.contains(person) {
                        let index = arrrr.firstIndex(of: person)
                        arrrr.remove(at: index!)
                        album.allArtists = arrrr
                    }
                }
                if album.producers.contains(person) {
                    let index = album.producers.firstIndex(of: person)
                    album.producers.remove(at: index!)
                }
                if var arrrr = album.writers as? [String] {
                    if arrrr.contains(person) {
                        let index = arrrr.firstIndex(of: person)
                        arrrr.remove(at: index!)
                        album.writers = arrrr
                    }
                }
                if var arrrr = album.mixEngineers as? [String] {
                    if arrrr.contains(person) {
                        let index = arrrr.firstIndex(of: person)
                        arrrr.remove(at: index!)
                        album.mixEngineers = arrrr
                    }
                }
                if var arrrr = album.masteringEngineers as? [String] {
                    if arrrr.contains(person) {
                        let index = arrrr.firstIndex(of: person)
                        arrrr.remove(at: index!)
                        album.masteringEngineers = arrrr
                    }
                }
                if var arrrr = album.recordingEngineers as? [String] {
                    if arrrr.contains(person) {
                        let index = arrrr.firstIndex(of: person)
                        arrrr.remove(at: index!)
                        album.recordingEngineers = arrrr
                    }
                }
                let update:[String : Any] = [
                    "Main Artist": album.mainArtist,
                    "All Artist": album.allArtists,
                    "All Producers": album.producers,
                    "All Writers": album.writers,
                    "Engineers": [
                        "Mix Engineer": album.mixEngineers,
                        "Mastering Engineer": album.masteringEngineers,
                        "Recording Engineer": album.recordingEngineers,
                    ]
                ]
                
                ref.updateChildValues(update, withCompletionBlock: { error, reference in
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
    
    func removePersonFromAlbumInDB(son: String, cat:String, mainArtistArr:[String], featArtistArr:[String], completion: @escaping ((Error?) -> Void)) {
        guard son.count == 8 else {
            completion(nil)
            return
        }
        let word = son.split(separator: "Æ")
        let id = word[0]
        DatabaseManager.shared.findAlbumById(albumId: String(id), completion: {[weak self] result in
            guard let strongSelf = self else {return}
            switch result {
            case .success(let album):
                let person = "\(strongSelf.currPerson.toneDeafAppId)"
                var currentArtistRoles:[String] = []
                var initialArtistRoles:[String] = []
                if let ro = strongSelf.currPerson.roles?["Artist"] as? [String] {
                    currentArtistRoles = ro
                }
                if let ro = strongSelf.initialRoles["Artist"] as? [String] {
                    initialArtistRoles = ro
                }
                if initialArtistRoles.contains(son) && !currentArtistRoles.contains(son) {
                    if album.mainArtist.contains(strongSelf.currPerson.toneDeafAppId) {
                        let dex = album.mainArtist.firstIndex(of: strongSelf.currPerson.toneDeafAppId)
                        album.mainArtist.remove(at: dex!)
                    }
                }
                if !initialArtistRoles.contains(son) && currentArtistRoles.contains(son) {
                    if !album.mainArtist.contains(strongSelf.currPerson.toneDeafAppId) {
                        album.mainArtist.append(strongSelf.currPerson.toneDeafAppId)
                    }
                }
                var ref = Database.database().reference().child("Music Content").child("Albums").child( "\(albumContentTag)--\(album.name)--\(album.toneDeafAppId)").child("REQUIRED")
                var ref1 = Database.database().reference().child("Music Content").child("Albums").child( "\(albumContentTag)--\(album.name)--\(album.toneDeafAppId)").child("REQUIRED")
                var arrto:[String]!
                switch cat {
                case "Artist":
                    if let index = album.mainArtist.firstIndex(of: person) {
                        album.mainArtist.remove(at: index)
                    }
                    arrto = album.mainArtist
                    ref = ref.child("Main Artist")
                    if var arrrrrrr = album.allArtists as? [String]{
                        if let index = arrrrrrr.firstIndex(of: person) {
                            arrrrrrr.remove(at: index)
                        }
                        album.allArtists = arrrrrrr
                        arrto = album.allArtists
                        ref1 = ref1.child("All Artist")
                    }
                case "Producer":
                    if let index = album.producers.firstIndex(of: person) {
                        album.producers.remove(at: index)
                    }
                    arrto = album.producers
                    ref = ref.child("All Producers")
                case "Writer":
                    if var arrrrrrr = album.writers as? [String]{
                        if let index = arrrrrrr.firstIndex(of: person) {
                            arrrrrrr.remove(at: index)
                        }
                        album.writers = arrrrrrr
                        arrto = album.writers
                        ref = ref.child("All Writers")
                    }
                case "Mix Engineer":
                    if var arrrrrrr = album.mixEngineers as? [String]{
                        if let index = arrrrrrr.firstIndex(of: person) {
                            arrrrrrr.remove(at: index)
                        }
                        album.mixEngineers = arrrrrrr
                    }
                    arrto = album.mixEngineers
                    ref = ref.child("Engineers").child("Mix Engineer")
                case "Mastering Engineer":
                    if var arrrrrrr = album.masteringEngineers as? [String]{
                        if let index = arrrrrrr.firstIndex(of: person) {
                            arrrrrrr.remove(at: index)
                        }
                        album.masteringEngineers = arrrrrrr
                    }
                    arrto = album.masteringEngineers
                    ref = ref.child("Engineers").child("Mastering Engineer")
                case "Recording Engineer":
                    if var arrrrrrr = album.recordingEngineers as? [String]{
                        if let index = arrrrrrr.firstIndex(of: person) {
                            arrrrrrr.remove(at: index)
                        }
                        album.recordingEngineers = arrrrrrr
                    }
                    arrto = album.recordingEngineers
                    ref = ref.child("Engineers").child("Recording Engineer")
                default:
                    break
                }
//                print(String(data: try! JSONSerialization.data(withJSONObject: update, options: .prettyPrinted), encoding: .utf8)!)
                
                ref.setValue(arrto.sorted(), withCompletionBlock: { error, reference in
                    if let error = error {
                        completion(error)
                        return
                    }
                    else {
                        if cat != "Artist" {
                            completion(nil)
                            return
                        }
                    }
                })
                if cat == "Artist" {
                    ref1.setValue(arrto.sorted(), withCompletionBlock: { error, reference in
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
            case .failure(let err):
                print("dsvgredfxbdfzx"+err.localizedDescription)
            }
        })
    }
    
    func addPersonToAlbumInDB(son: String, mainArtistArr:[String], featArtistArr:[String], completion: @escaping ((Error?) -> Void)) {
        guard son.count == 8 else {
            completion(nil)
            return
        }
        let word = son.split(separator: "Æ")
        let id = word[0]
        
        DatabaseManager.shared.findAlbumById(albumId: String(id), completion: {[weak self] result in
            guard let strongSelf = self else {return}
            switch result {
            case .success(let album):
                let ref = Database.database().reference().child("Music Content").child("Albums").child( "\(albumContentTag)--\(album.name)--\(album.toneDeafAppId)").child("REQUIRED")
                let person = "\(strongSelf.currPerson.toneDeafAppId)"
                var update:[String : Any] = [
                    "Main Artist": album.mainArtist,
                    "All Artist": album.allArtists,
                    "All Producers": album.producers,
                    "All Writers": album.writers,
                    "Engineers": [
                        "Mix Engineer": album.mixEngineers,
                        "Mastering Engineer": album.masteringEngineers,
                        "Recording Engineer": album.recordingEngineers,
                    ]
                ]
                if let curroo = strongSelf.currPerson.roles {
                    if let roo = curroo["Artist"] as? [String] {
                        if roo.contains(son) {
                            if mainArtistArr.contains(son) {
                                if !album.mainArtist.contains(person) {
                                    album.mainArtist.append(person)
                                }
                                update["Main Artist"] = album.mainArtist
                            }
                            if featArtistArr.contains(son) {
                                if var allArt = album.allArtists as? [String] {
                                    if !allArt.contains(person) {
                                        allArt.append(person)
                                        album.allArtists = allArt
                                    }
                                } else {
                                    album.allArtists = [person]
                                }
                                update["All Artist"] = album.allArtists
                            }
                        }
                    }
                    if let roo = curroo["Producer"] as? [String] {
                        if roo.contains(son) {
                            if !album.producers.contains(person) {
                                album.producers.append(person)
                                update["All Producers"] = album.producers
                            }
                        }
                    }
                    if var arrrr = album.writers as? [String] {
                        if let roo = curroo["Writer"] as? [String] {
                            if roo.contains(son) {
                                if !arrrr.contains(person) {
                                    arrrr.append(person)
                                    album.writers = arrrr
                                    update["All Writers"] = album.writers
                                }
                            }
                        }
                    }
                    if let eng = curroo["Engineer"] as? NSDictionary {
                        let engDict:NSMutableDictionary = [
                            "Mix Engineer": album.mixEngineers,
                            "Mastering Engineer": album.masteringEngineers,
                            "Recording Engineer": album.recordingEngineers
                        ]
                        if var arrrr = album.mixEngineers as? [String] {
                            if let roo = eng["Mix Engineer"] as? [String] {
                                if roo.contains(son) {
                                    if !arrrr.contains(person) {
                                        arrrr.append(person)
                                        album.mixEngineers = arrrr
                                    }
                                }
                            }
                            engDict["Mix Engineer"] = album.mixEngineers
                        } else {
                            var arrrr:[String] = []
                            if let roo = eng["Mix Engineer"] as? [String] {
                                if roo.contains(son) {
                                    if !arrrr.contains(person) {
                                        arrrr.append(person)
                                        album.mixEngineers = arrrr
                                    }
                                }
                            }
                            engDict["Mix Engineer"] = album.mixEngineers
                        }
                        if var arrrr = album.masteringEngineers as? [String] {
                            if let roo = eng["Mastering Engineer"] as? [String] {
                                if roo.contains(son) {
                                    if !arrrr.contains(person) {
                                        arrrr.append(person)
                                        album.masteringEngineers = arrrr
                                    }
                                }
                            }
                            engDict["Mastering Engineer"] = album.masteringEngineers
                        } else {
                            var arrrr:[String] = []
                            if let roo = eng["Mastering Engineer"] as? [String] {
                                if roo.contains(son) {
                                    if !arrrr.contains(person) {
                                        arrrr.append(person)
                                        album.masteringEngineers = arrrr
                                    }
                                }
                            }
                            engDict["Mastering Engineer"] = album.masteringEngineers
                        }
                        if var arrrr = album.recordingEngineers as? [String] {
                            if let roo = eng["Recording Engineer"] as? [String] {
                                if roo.contains(son) {
                                    if !arrrr.contains(person) {
                                        arrrr.append(person)
                                        album.recordingEngineers = arrrr
                                        
                                    }
                                }
                            }
                            engDict["Recording Engineer"] = album.recordingEngineers
                        } else {
                            var arrrr:[String] = []
                            if let roo = eng["Recording Engineer"] as? [String] {
                                if roo.contains(son) {
                                    if !arrrr.contains(person) {
                                        arrrr.append(person)
                                        album.recordingEngineers = arrrr
                                    }
                                }
                            }
                            engDict["Recording Engineer"] = album.recordingEngineers
                        }
                        update["Engineers"] = engDict
                    }
                }
//                print(String(data: try! JSONSerialization.data(withJSONObject: update, options: .prettyPrinted), encoding: .utf8)!)
                
                ref.updateChildValues(update, withCompletionBlock: { error, reference in
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
    
    func addPersonToAlbumInDB(son: String, cat:String, mainArtistArr:[String], featArtistArr:[String], completion: @escaping ((Error?) -> Void)) {
        guard son.count == 8 else {
            completion(nil)
            return
        }
        let word = son.split(separator: "Æ")
        let id = word[0]
//        let semap = DispatchSemaphore(value: 1)
        print(id)
        
        DatabaseManager.shared.findAlbumById(albumId: String(id), completion: {[weak self] result in
            guard let strongSelf = self else {return}
            switch result {
            case .success(let album):
                let person = "\(strongSelf.currPerson.toneDeafAppId)"
                var ref = Database.database().reference().child("Music Content").child("Albums").child( "\(albumContentTag)--\(album.name)--\(album.toneDeafAppId)").child("REQUIRED")
                var arrto:[String]!
                let update:NSMutableDictionary = [:]
                switch cat {
                case "Artist":
                    if mainArtistArr.contains(String(id)) {
                        if !album.mainArtist.contains(person) {
                            album.mainArtist.append(person)
                        }
                        update["Main Artist"] = album.mainArtist.sorted()
                    }
                    if featArtistArr.contains(son) {
                        if var allArt = album.allArtists as? [String]{
                            if !allArt.contains(person) {
                                allArt.append(person)
                                album.allArtists = allArt.sorted()
                            }
                        } else {
                            album.allArtists = [person]
                        }
                        update["All Artist"] = album.allArtists
                    }
                case "Producer":
                    if !album.producers.contains(person) {
                        album.producers.append(person)
                    }
                    arrto = album.producers.sorted()
                    ref = ref.child("All Producers")
                case "Writer":
                    if var arrrrrrr = album.writers as? [String]{
                        if !arrrrrrr.contains(person) {
                            arrrrrrr.append(person)
                            album.writers = arrrrrrr.sorted()
                        }
                    } else {
                        album.writers = [person]
                    }
                    arrto = album.writers
                    ref = ref.child("All Writers")
                case "Mix Engineer":
                    if var arrrrrrr = album.mixEngineers as? [String]{
                        if !arrrrrrr.contains(person) {
                            arrrrrrr.append(person)
                            album.mixEngineers = arrrrrrr.sorted()
                        }
                    } else {
                        album.mixEngineers = [person]
                    }
                    arrto = album.mixEngineers
                    ref = ref.child("Engineers").child("Mix Engineer")
                case "Mastering Engineer":
                    if var arrrrrrr = album.masteringEngineers as? [String]{
                        if !arrrrrrr.contains(person) {
                            arrrrrrr.append(person)
                            album.masteringEngineers = arrrrrrr.sorted()
                        }
                    } else {
                        album.masteringEngineers = [person]
                    }
                    arrto = album.masteringEngineers
                    ref = ref.child("Engineers").child("Mastering Engineer")
                case "Recording Engineer":
                    if var arrrrrrr = album.recordingEngineers as? [String]{
                        if !arrrrrrr.contains(person) {
                            arrrrrrr.append(person)
                            album.recordingEngineers = arrrrrrr.sorted()
                        }
                    } else {
                        album.recordingEngineers = [person]
                    }
                    arrto = album.recordingEngineers
                    ref = ref.child("Engineers").child("Recording Engineer")
                default:
                    break
                }
//                print(String(data: try! JSONSerialization.data(withJSONObject: update, options: .prettyPrinted), encoding: .utf8)!)
                print(ref)
                
                switch cat {
                case "Artist":
                    ref.updateChildValues(update as! [AnyHashable : Any], withCompletionBlock: { error, reference in
    //                    semap.signal()
                        if let error = error {
                            completion(error)
                            return
                        }
                        else {
                            completion(nil)
                            return
                        }
                    })
                default:
                    ref.setValue(arrto.sorted(), withCompletionBlock: { error, reference in
    //                    semap.signal()
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
            case .failure(let err):
                print("dsvgredfxbdfzx"+err.localizedDescription)
            }
        })
    }
    
    func updateAlbumSubArtistRoles(ref: DatabaseReference, initialRoles:NSMutableDictionary , mainArtistArr: [String], featArtistArr: [String], initmainArtistArr: [String], initfeatArtistArr: [String], completion: @escaping (([Error]?) -> Void)) {
        var totalProgress = 0
        var completedProgress = 0
        var errors:[Error] = []
        if initfeatArtistArr == featArtistArr && initmainArtistArr == mainArtistArr {
            completion(nil)
        }
        if initmainArtistArr != mainArtistArr {
            for alb in initmainArtistArr {
                if !mainArtistArr.contains(alb) {
                    //remove album from main artist role in DB for album
                    totalProgress+=1
                }
            }
            for alb in mainArtistArr {
                if !initmainArtistArr.contains(alb) {
                    totalProgress+=1
                    //add album from main artist role in DB for album\
                }
            }
        }
        if initfeatArtistArr != featArtistArr {
            for alb in initfeatArtistArr {
                if !featArtistArr.contains(alb) {
                   //remove album from main artist role in DB for album
                    totalProgress+=1
                }
            }
            for alb in featArtistArr {
                if !initfeatArtistArr.contains(alb) {
                    //add album from main artist role in DB for album
                    totalProgress+=1
                }
            }
        }
        
        if initmainArtistArr != mainArtistArr {
            for alb in initmainArtistArr {
                if !mainArtistArr.contains(alb) {
                    //remove album from main artist role in DB for album
                    removeAlbumSubArtRoleInDB(alb: alb, cat: "Main", completion: { err in
                        completedProgress+=1
                        if let err = err {
                            errors.append(err)
                            if completedProgress == totalProgress {
                                completion(errors)
                                return
                            }
                        } else {
                            if completedProgress == totalProgress {
                                if errors.isEmpty {
                                    completion(nil)
                                    return
                                } else {
                                    completion(errors)
                                    return
                                }
                            }
                        }
                    })
                }
            }
            for alb in mainArtistArr {
                if !initmainArtistArr.contains(alb) {
                    //add album from main artist role in DB for album
                    addAlbumSubArtRoleInDB(alb: alb, cat: "Main", completion: { err in
                        completedProgress+=1
                        if let err = err {
                            errors.append(err)
                            if completedProgress == totalProgress {
                                completion(errors)
                                return
                            }
                        } else {
                            if completedProgress == totalProgress {
                                if errors.isEmpty {
                                    completion(nil)
                                    return
                                } else {
                                    completion(errors)
                                    return
                                }
                            }
                        }
                    })
                }
            }
        }
        if initfeatArtistArr != featArtistArr {
            for alb in initfeatArtistArr {
                if !featArtistArr.contains(alb) {
                   //remove album from main artist role in DB for album
                    removeAlbumSubArtRoleInDB(alb: alb, cat: "Feat", completion: { err in
                        completedProgress+=1
                        if let err = err {
                            errors.append(err)
                            if completedProgress == totalProgress {
                                completion(errors)
                                return
                            }
                        } else {
                            if completedProgress == totalProgress {
                                if errors.isEmpty {
                                    completion(nil)
                                    return
                                } else {
                                    completion(errors)
                                    return
                                }
                            }
                        }
                    })
                }
            }
            for alb in featArtistArr {
                if !initfeatArtistArr.contains(alb) {
                    //add album from main artist role in DB for album
                    addAlbumSubArtRoleInDB(alb: alb, cat: "Feat", completion: { err in
                        completedProgress+=1
                        if let err = err {
                            errors.append(err)
                            if completedProgress == totalProgress {
                                completion(errors)
                                return
                            }
                        } else {
                            if completedProgress == totalProgress {
                                if errors.isEmpty {
                                    completion(nil)
                                    return
                                } else {
                                    completion(errors)
                                    return
                                }
                            }
                        }
                    })
                }
            }
        }
    }
    
    func addAlbumSubArtRoleInDB(alb: String, cat:String, completion: @escaping ((Error?) -> Void)) {
        guard alb.count == 8 else {
            completion(nil)
            return
        }
        DatabaseManager.shared.findAlbumById(albumId: alb, completion: {[weak self] result in
            guard let strongSelf = self else {return}
            switch result {
            case .success(let album):
                let person = "\(strongSelf.currPerson.toneDeafAppId)"
                var albref = Database.database().reference().child("Music Content").child("Albums").child( "\(albumContentTag)--\(album.name)--\(album.toneDeafAppId)").child("REQUIRED")
                var arrto:[String]!
                switch cat {
                case "Main":
                    if !album.mainArtist.contains(person) {
                        album.mainArtist.append(person)
                    }
                    arrto = album.mainArtist
                    albref = albref.child("Main Artist")
                case "Feat":
                    if var allArt = album.allArtists as? [String]{
                        if !allArt.contains(person) {
                            allArt.append(person)
                            album.allArtists = allArt
                        }
                    } else {
                        album.allArtists = [person]
                    }
                    arrto = album.allArtists
                    albref = albref.child("All Artist")
                default:
                    break
                }
                
                albref.setValue(arrto.sorted(), withCompletionBlock: { error, reference in
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
                print("dsvgrdsavgsedfxbdfzx"+err.localizedDescription)
            }
        })
    }
    
    func removeAlbumSubArtRoleInDB(alb: String, cat:String, completion: @escaping ((Error?) -> Void)) {
        guard alb.count == 8 else {
            completion(nil)
            return
        }
        DatabaseManager.shared.findAlbumById(albumId: alb, completion: {[weak self] result in
            guard let strongSelf = self else {return}
            switch result {
            case .success(let album):
                let person = "\(strongSelf.currPerson.toneDeafAppId)"
                var albref = Database.database().reference().child("Music Content").child("Albums").child( "\(albumContentTag)--\(album.name)--\(album.toneDeafAppId)").child("REQUIRED")
                var arrto:[String]!
                switch cat {
                case "Main":
                    if let index = album.mainArtist.firstIndex(of: person) {
                        album.mainArtist.remove(at: index)
                    }
                    arrto = album.mainArtist
                    albref = albref.child("Main Artist")
                case "Feat":
                    if var allArt = album.allArtists as? [String]{
                        if let index = allArt.firstIndex(of: person) {
                            allArt.remove(at: index)
                        }
                        album.allArtists = allArt
                    }
                    arrto = album.allArtists
                    albref = albref.child("All Artist")
                default:
                    break
                }
                
                albref.setValue(arrto.sorted(), withCompletionBlock: { error, reference in
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
                print("dsvgrdsavgsedfxbdfzx"+err.localizedDescription)
            }
        })
    }
    
    //MARK: - Videos
    func processVideos(initialPerson: PersonData, currentPerson: PersonData, initialRoles:NSMutableDictionary, videoPersonsArr: [String], initvideoPersonArr: [String], completion: @escaping (([Error]?) -> Void)) {
        initPerson = initialPerson
        currPerson = currentPerson
        self.initialRoles = initialRoles.mutableCopy() as! NSMutableDictionary
        
        if currPerson.albums == nil {
            currPerson.albums = []
        }
        
        var errors:[Error] = []
        initRef = Database.database().reference().child("Registered Persons").child("\(initPerson.name!)--\(initPerson.dateRegisteredToApp!)--\(initPerson.timeRegisteredToApp!)--\(initPerson.toneDeafAppId)")
        currRef = Database.database().reference().child("Registered Persons").child("\(currPerson.name!)--\(currPerson.dateRegisteredToApp!)--\(currPerson.timeRegisteredToApp!)--\(currPerson.toneDeafAppId)")
        
        var dataUploadCompletionStatus1:Bool!
        var dataUploadCompletionStatus2:Bool!
        var dataUploadCompletionStatus3:Bool!
        var dataUploadCompletionStatus4:Bool!
        let queue = DispatchQueue(label: "myhjvkheditingQpersonsVideossseue")
        let group = DispatchGroup()
        let array:[Int] = [1,2,3,4]
        for i in array {
            group.enter()
            queue.async { [weak self] in
                guard let strongSelf = self else {return}
                switch i {
                case 1:
                    strongSelf.updatePersonVideos(ref: strongSelf.currRef, completion: {err in
                        if let error = err {
                            dataUploadCompletionStatus1 = false
                            errors.append(error)
                        } else {
                            dataUploadCompletionStatus1 = true
                            print("Person Videos update done \(i)")
                        }
                        group.leave()
                    })
                case 2:
                    strongSelf.updatePersonVideoRoles(ref: strongSelf.currRef, completion: {err in
                        if let error = err {
                            dataUploadCompletionStatus2 = false
                            errors.append(error)
                        } else {
                            dataUploadCompletionStatus2 = true
                            print("Person Video Roles update done \(i)")
                        }
                        group.leave()
                    })
                case 3:
                    DispatchQueue.global(qos: .userInitiated).async { [weak self] in
                        guard let strongSelf = self else {return}
                        strongSelf.updateVideoVideographerRoles(ref: strongSelf.currRef, initialRoles: initialRoles, completion: {err in
                            if let error = err {
                                print("aww shucks")
                                dataUploadCompletionStatus3 = false
                                errors.append(error)
                            } else {
                                dataUploadCompletionStatus3 = true
                                print("Video Roles update done \(i)")
                            }
                            group.leave()
                        })
                    }
                case 4:
                    DispatchQueue.global(qos: .userInitiated).async { [weak self] in
                        guard let strongSelf = self else {return}
                        strongSelf.updateVideoPersonRoles(ref: strongSelf.currRef, videoPersonsArr: videoPersonsArr, initvideoPersonArr: initvideoPersonArr, completion: {err in
                            if let error = err {
                                print("aww shucks")
                                dataUploadCompletionStatus4 = false
                                errors.append(error)
                            } else {
                                dataUploadCompletionStatus4 = true
                                print("Video Person Roles update done \(i)")
                            }
                            group.leave()
                        })
                    }
                default:
                    print("Edit Person error")
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
    
    func updatePersonVideos(ref: DatabaseReference, completion: @escaping ((Error?) -> Void)) {
        var initialVideoArrFromDB:[String]!
        if initPerson.videos == currPerson.videos {
            completion(nil)
            return
        }
        getPersonVideosInDB(ref: ref, completion: {[weak self] videos in
            guard let strongSelf = self else {return}
            initialVideoArrFromDB = videos
            
            if !initialVideoArrFromDB.isEmpty {
                var removalCounter = 0
                for i in 0 ... initialVideoArrFromDB.count-1 {
                    if let curralb = strongSelf.currPerson.videos as? [String] {
                        if i < curralb.count {
                            if !curralb.contains(initialVideoArrFromDB[i]) {
                                let index = initialVideoArrFromDB.firstIndex(of: initialVideoArrFromDB[i])
                                initialVideoArrFromDB.remove(at: index!)
                                removalCounter+=1
                            }
                        } else {
                            let index = initialVideoArrFromDB.firstIndex(of: initialVideoArrFromDB[i-removalCounter])
                            initialVideoArrFromDB.remove(at: index!)
                            removalCounter+=1
                        }
                    } else {
                        let index = initialVideoArrFromDB.firstIndex(of: initialVideoArrFromDB[i-removalCounter])
                        initialVideoArrFromDB.remove(at: index!)
                        removalCounter+=1
                    }
                }
            }
            if let curralb = strongSelf.currPerson.videos as? [String] {
                if !curralb.isEmpty {
                    for i in 0 ... curralb.count-1 {
                        if i < initialVideoArrFromDB.count {
                            if !initialVideoArrFromDB.contains(strongSelf.currPerson.videos![i]) {
                                initialVideoArrFromDB.append(strongSelf.currPerson.videos![i])
                            }
                        } else {
                            initialVideoArrFromDB.append(strongSelf.currPerson.videos![i])
                        }
                    }
                }
            }
            ref.child("Videos").setValue(initialVideoArrFromDB.sorted(), withCompletionBlock: { error, reference in
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
    
    func getPersonVideosInDB(ref: DatabaseReference, completion: @escaping (([String]) -> Void)) {
        ref.child("Videos").observeSingleEvent(of: .value, with: { snapshot in
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
    
    func updatePersonVideoRoles(ref: DatabaseReference, completion: @escaping ((Error?) -> Void)) {
        var rolesInDB:NSDictionary!
        var newRoles:NSDictionary!
        if let ro = currPerson.roles {
            newRoles = ro
        }
        
        getPersonRolesInDB(ref: ref, completion: {[weak self] roles in
            guard let strongSelf = self else {return}
            rolesInDB = roles
            ref.child("Roles").setValue(newRoles, withCompletionBlock: { error, reference in
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
    
    func updateVideoVideographerRoles(ref: DatabaseReference, initialRoles:NSMutableDictionary, completion: @escaping ((Error?) -> Void)) {
        var initialVideoArrFromDB:[String]!
        var artRef:DatabaseReference!
        
        getPersonVideosInDB(ref: ref, completion: {[weak self] videos in
            guard let strongSelf = self else {return}
            initialVideoArrFromDB = videos
            
            if let ro = strongSelf.currPerson.roles {
                if let new = ro["Videographer"] as? [String] {
                    
                    if let old = initialRoles["Videographer"] as? [String] {
                        var count = 0
                        var completioncount = 0
                        if old != new {
                            for item in new {
                                if count != 0 {
                                    usleep(100)
                                }
                                count+=1
                                if !old.contains(item) {
                                    strongSelf.addPersonToVideoInDB(son: item, cat: "Videographer", completion: {err in
                                        completioncount+=1
                                        if let err = err {
                                            completion(err)
                                            return
                                        } else {
                                            if completioncount == (old.count+new.count) {
                                                completion(nil)
                                            }
                                        }
                                    })
                                }
                                else {
                                    completioncount+=1
                                    if completioncount == (old.count+new.count) {
                                        completion(nil)
                                    }
                                }
                            }
                            for item in old {
                                if count != 0 {
                                    usleep(100)
                                }
                                count+=1
                                if !new.contains(item) {
                                    strongSelf.removePersonFromVideoInDB(son: item, cat: "Videographer", completion: {err in
                                        completioncount+=1
                                        if let err = err {
                                            completion(err)
                                            return
                                        } else {
                                            if completioncount == (old.count+new.count) {
                                                completion(nil)
                                            }
                                        }
                                    })
                                }
                                else {
                                    completioncount+=1
                                    if completioncount == (old.count+new.count) {
                                        completion(nil)
                                    }
                                }
                            }
                        } else {
                            completion(nil)
                        }
                    } else {
                        var count = 0
                        var completioncount = 0
                        for item in new {
                            if count != 0 {
                                usleep(100)
                            }
                            count+=1
                            strongSelf.addPersonToVideoInDB(son: item, cat: "Videographer", completion: {err in
                                completioncount+=1
                                if let err = err {
                                    completion(err)
                                    return
                                } else {
                                    if completioncount == (new.count) {
                                        completion(nil)
                                    }
                                }
                            })
                        }
                    }
                } else if let old = initialRoles["Videographer"] as? [String] {
                    if let new = ro["Videographer"] as? [String] {
                        var count = 0
                        var completioncount = 0
                        for item in old {
                            if count != 0 {
                                usleep(100)
                            }
                            count+=1
                            if !new.contains(item) {
                                strongSelf.removePersonFromVideoInDB(son: item, cat: "Videographer", completion: {err in
                                    completioncount+=1
                                    if let err = err {
                                        completion(err)
                                        return
                                    } else {
                                        if completioncount == (old.count+new.count) {
                                            completion(nil)
                                        }
                                    }
                                })
                            }
                        }
                        for item in new {
                            if count != 0 {
                                usleep(100)
                            }
                            count+=1
                            if !old.contains(item) {
                                strongSelf.addPersonToVideoInDB(son: item, cat: "Videographer", completion: {err in
                                    completioncount+=1
                                    if let err = err {
                                        completion(err)
                                        return
                                    } else {
                                        if completioncount == (old.count+new.count) {
                                            completion(nil)
                                        }
                                    }
                                })
                            }
                        }
                    } else {
                        var count = 0
                        var completioncount = 0
                        for item in old {
                            if count != 0 {
                                usleep(100)
                            }
                            count+=1
                            strongSelf.removePersonFromVideoInDB(son: item, cat: "Videographer", completion: {err in
                                completioncount+=1
                                if let err = err {
                                    completion(err)
                                    return
                                } else {
                                    if completioncount == (old.count) {
                                        completion(nil)
                                    }
                                }
                            })
                        }
                    }
                } else {
                    completion(nil)
                }
            }
            else {
                if let arr = initialRoles["Videographer"] as? [String] {
                    var count = 0
                    var completioncount = 0
                    for songg in arr {
                        if count != 0 {
                            usleep(100)
                        }
                        count+=1
                        strongSelf.removePersonFromVideoInDB(son: songg, cat: "Videographer", completion: {err in
                            completioncount+=1
                            if let err = err {
                                completion(err)
                                return
                            } else {
                                if completioncount == (arr.count) {
                                    completion(nil)
                                }
                            }
                        })
                    }
                }
                else {
                    completion(nil)
                }
            }
        })
    }
    
    func addPersonToVideoInDB(son: String, cat:String, completion: @escaping ((Error?) -> Void)) {
        guard son.count == 9 else {
            completion(nil)
            return
        }
        
        DatabaseManager.shared.findVideoById(videoid: son, completion: {[weak self] result in
            guard let strongSelf = self else {return}
            switch result {
            case .success(let video):
                let person = "\(strongSelf.currPerson.toneDeafAppId)"
                var ref = Database.database().reference().child("Music Content").child("Videos").child( "\(videoContentTag)--\(video.title.replacingOccurrences(of: ".", with: " ").replacingOccurrences(of: "#", with: " ").replacingOccurrences(of: "$", with: " ").replacingOccurrences(of: "[", with: " ").replacingOccurrences(of: "]", with: " ").replacingOccurrences(of: ":", with: " "))--\(video.toneDeafAppId)")
                var arrto:[String]!
                switch cat {
                case "Videographer":
                    if var arrrrrrr = video.videographers as? [String]{
                        if !arrrrrrr.contains(person) {
                            arrrrrrr.append(person)
                            video.videographers = arrrrrrr
                        }
                    } else {
                        video.videographers = [person]
                    }
                    arrto = video.videographers
                    ref = ref.child("Videographers")
                    strongSelf.setValueArray(ref: ref, arrto: arrto, completion: { err in
                        if let err = err {
                            print("dsgsrdgvdz z av "+err.localizedDescription)
                        } else {
                            completion(nil)
                        }
                    })
                case "Person":
                    if var arrrrrrr = video.persons as? [String] {
                        if !arrrrrrr.contains(person) {
                            arrrrrrr.append(person)
                            video.persons = arrrrrrr
                        }
                    } else {
                        video.persons = [person]
                    }
                    arrto = video.persons
                    ref = ref.child("Persons")
                    strongSelf.setValueArray(ref: ref, arrto: arrto, completion: { err in
                        if let err = err {
                            print("dsgsrdgvdz z av "+err.localizedDescription)
                        } else {
                            completion(nil)
                        }
                    })
                default:
                    break
                }
            case .failure(let err):
                print("dsvgredfxbdfzx"+err.localizedDescription)
            }
        })
    }
    
    func removePersonFromVideoInDB(son: String, cat:String, completion: @escaping ((Error?) -> Void)) {
        guard son.count == 9 else {
            completion(nil)
            return
        }
        DatabaseManager.shared.findVideoById(videoid: son, completion: {[weak self] result in
            guard let strongSelf = self else {return}
            switch result {
            case .success(let video):
                let person = "\(strongSelf.currPerson.toneDeafAppId)"
                var ref = Database.database().reference().child("Music Content").child("Videos").child( "\(videoContentTag)--\(video.title.replacingOccurrences(of: ".", with: " ").replacingOccurrences(of: "#", with: " ").replacingOccurrences(of: "$", with: " ").replacingOccurrences(of: "[", with: " ").replacingOccurrences(of: "]", with: " ").replacingOccurrences(of: ":", with: " "))--\(video.toneDeafAppId)")
                var arrto:[String]!
                switch cat {
                case "Videographer":
                    if var arrrrrrr = video.videographers as? [String]{
                        if let index = arrrrrrr.firstIndex(of: person) {
                            arrrrrrr.remove(at: index)
                        }
                        video.videographers = arrrrrrr
                        arrto = video.videographers
                        ref = ref.child("Videographers")
                        strongSelf.setValueArray(ref: ref, arrto: arrto, completion: { err in
                            if let err = err {
                                print("dsgsrdgvdz z av "+err.localizedDescription)
                            } else {
                                completion(nil)
                            }
                        })
                    } else {
                        completion(nil)
                    }
                case "Person":
                    if var arrrrrrr = video.persons as? [String]{
                        if let index = arrrrrrr.firstIndex(of: person) {
                            arrrrrrr.remove(at: index)
                        }
                        video.persons = arrrrrrr
                        arrto = video.persons
                        ref = ref.child("Persons")
                        strongSelf.setValueArray(ref: ref, arrto: arrto, completion: { err in
                            if let err = err {
                                print("dsgsrdgvdz z av "+err.localizedDescription)
                            } else {
                                completion(nil)
                            }
                        })
                    } else {
                        completion(nil)
                    }
                default:
                    break
                }
            case .failure(let err):
                print("dsvgredfxbdfzx"+err.localizedDescription)
            }
        })
    }
    
    func updateVideoPersonRoles(ref: DatabaseReference, videoPersonsArr: [String], initvideoPersonArr: [String], completion: @escaping ((Error?) -> Void)) {
        guard videoPersonsArr != initvideoPersonArr else {
            completion(nil)
            return
        }
        var count = 0
        var completioncount = 0
        if initvideoPersonArr != videoPersonsArr {
            for item in videoPersonsArr {
                if count != 0 {
                    usleep(100)
                }
                count+=1
                if !initvideoPersonArr.contains(item) {
                    addPersonToVideoInDB(son: item, cat: "Person", completion: {err in
                        completioncount+=1
                        if let err = err {
                            completion(err)
                            return
                        } else {
                            if completioncount == (initvideoPersonArr.count+videoPersonsArr.count) {
                                completion(nil)
                            }
                        }
                    })
                }
                else {
                    completioncount+=1
                    if completioncount == (initvideoPersonArr.count+videoPersonsArr.count) {
                        completion(nil)
                    }
                }
            }
            for item in initvideoPersonArr {
                if count != 0 {
                    usleep(100)
                }
                count+=1
                if !videoPersonsArr.contains(item) {
                    removePersonFromVideoInDB(son: item, cat: "Person", completion: {err in
                        completioncount+=1
                        if let err = err {
                            completion(err)
                            return
                        } else {
                            if completioncount == (initvideoPersonArr.count+videoPersonsArr.count) {
                                completion(nil)
                            }
                        }
                    })
                }
                else {
                    completioncount+=1
                    if completioncount == (initvideoPersonArr.count+videoPersonsArr.count) {
                        completion(nil)
                    }
                }
            }
        } else {
            completion(nil)
        }
    }
    
    //MARK: - Instrumentals
    func processInstrumentals(initialPerson: PersonData, currentPerson: PersonData, initialRoles:NSMutableDictionary,completion: @escaping (([Error]?) -> Void)) {
        initPerson = initialPerson
        currPerson = currentPerson
        if currPerson.albums == nil {
            currPerson.albums = []
        }
        self.initialRoles = initialRoles.mutableCopy() as! NSMutableDictionary
        
        var errors:[Error] = []
        initRef = Database.database().reference().child("Registered Persons").child("\(initPerson.name!)--\(initPerson.dateRegisteredToApp!)--\(initPerson.timeRegisteredToApp!)--\(initPerson.toneDeafAppId)")
        currRef = Database.database().reference().child("Registered Persons").child("\(currPerson.name!)--\(currPerson.dateRegisteredToApp!)--\(currPerson.timeRegisteredToApp!)--\(currPerson.toneDeafAppId)")
        
        var dataUploadCompletionStatus1:Bool!
        var dataUploadCompletionStatus2:Bool!
        var dataUploadCompletionStatus3:Bool!
        var dataUploadCompletionStatus4:Bool!
        let queue = DispatchQueue(label: "myhjvkheditingQpersonsInstrumentalssseue")
        let group = DispatchGroup()
        let array:[Int] = [1,2,3,4]
        for i in array {
            group.enter()
            queue.async { [weak self] in
                guard let strongSelf = self else {return}
                switch i {
                case 1:
                    strongSelf.updatePersonInstrumentals(ref: strongSelf.currRef, completion: {err in
                        if let error = err {
                            dataUploadCompletionStatus1 = false
                            errors.append(error)
                        } else {
                            dataUploadCompletionStatus1 = true
                            print("Person Instrumentals update done \(i)")
                        }
                        group.leave()
                    })
                case 2:
                    strongSelf.updatePersonInstrumentalRoles(ref: strongSelf.currRef, completion: {err in
                        
                        if let error = err {
                            dataUploadCompletionStatus1 = false
                            errors.append(error)
                        } else {
                            dataUploadCompletionStatus1 = true
                            print("Person Instrumental Roles update done \(i)")
                        }
                        group.leave()
                    })
                case 3:
                    
                    DispatchQueue.global(qos: .userInitiated).async { [weak self] in
                        guard let strongSelf = self else {return}
                        strongSelf.updateInstrumentalRoles(ref: strongSelf.currRef, initialRoles: initialRoles, completion: {err in
                            if let error = err {
                                print("aww shucks")
                                dataUploadCompletionStatus3 = false
                                errors.append(error)
                            } else {
                                dataUploadCompletionStatus3 = true
                                print("Instrumental Roles update done \(i)")
                            }
                            group.leave()
                        })
                    }
                case 4:
                    
                    DispatchQueue.global(qos: .userInitiated).async { [weak self] in
                        guard let strongSelf = self else {return}
                        strongSelf.updateInstrumentalAlbumInstrumentals(ref: strongSelf.currRef, initialRoles: initialRoles, completion: {err in
                            
                            if let error = err {
                                print("aww shucks")
                                dataUploadCompletionStatus3 = false
                                errors.append(error)
                            } else {
                                dataUploadCompletionStatus3 = true
                                print("Instrumental Album Instrumentals update done \(i)")
                            }
                            group.leave()
                        })
                    }
                default:
                    print("Edit Person error")
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
    
    func updatePersonInstrumentals(ref: DatabaseReference, completion: @escaping ((Error?) -> Void)) {
        var initialInstrumentalArrFromDB:[String]!
        if currPerson.instrumentals == initPerson.instrumentals {
            completion(nil)
            return
        }
        getPersonInstrumentalsInDB(ref: ref, completion: {[weak self] instrumentals in
            guard let strongSelf = self else {return}
            initialInstrumentalArrFromDB = instrumentals
            
            if !initialInstrumentalArrFromDB.isEmpty {
                var removalCounter = 0
                for i in 0 ... initialInstrumentalArrFromDB.count-1 {
                    if strongSelf.currPerson.instrumentals != nil {
                        if i < strongSelf.currPerson.instrumentals!.count {
                            if !strongSelf.currPerson.instrumentals![i].contains(initialInstrumentalArrFromDB[i]) {
                                let index = initialInstrumentalArrFromDB.firstIndex(of: initialInstrumentalArrFromDB[i])
                                initialInstrumentalArrFromDB.remove(at: index!)
                                removalCounter+=1
                            }
                        } else {
                            let index = initialInstrumentalArrFromDB.firstIndex(of: initialInstrumentalArrFromDB[i-removalCounter])
                            initialInstrumentalArrFromDB.remove(at: index!)
                            removalCounter+=1
                        }
                    } else {
                        let index = initialInstrumentalArrFromDB.firstIndex(of: initialInstrumentalArrFromDB[i-removalCounter])
                        initialInstrumentalArrFromDB.remove(at: index!)
                        removalCounter+=1
                    }
                }
            }
            if strongSelf.currPerson.instrumentals != nil {
                if !strongSelf.currPerson.instrumentals!.isEmpty {
                    for i in 0 ... strongSelf.currPerson.instrumentals!.count-1 {
                        if i < initialInstrumentalArrFromDB.count {
                            if !initialInstrumentalArrFromDB[i].contains(strongSelf.currPerson.instrumentals![i]) {
                                initialInstrumentalArrFromDB.append(strongSelf.currPerson.instrumentals![i])
                            }
                        } else {
                            initialInstrumentalArrFromDB.append(strongSelf.currPerson.instrumentals![i])
                        }
                    }
                }
            }
            ref.child("Instrumentals").setValue(initialInstrumentalArrFromDB.sorted(), withCompletionBlock: { error, reference in
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
    
    func getPersonInstrumentalsInDB(ref: DatabaseReference, completion: @escaping (([String]) -> Void)) {
        ref.child("Instrumentals").observeSingleEvent(of: .value, with: { snapshot in
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
    
    func updatePersonInstrumentalRoles(ref: DatabaseReference, completion: @escaping ((Error?) -> Void)) {
        var rolesInDB:NSDictionary!
        var newRoles:NSDictionary!
        if let ro = currPerson.roles {
            newRoles = ro
        }
        getPersonRolesInDB(ref: ref, completion: {[weak self] roles in
            guard let strongSelf = self else {return}
            rolesInDB = roles
            ref.child("Roles").setValue(newRoles, withCompletionBlock: { error, reference in
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
    
    func updateInstrumentalRoles(ref: DatabaseReference, initialRoles:NSMutableDictionary ,completion: @escaping ((Error?) -> Void)) {
        var initialInstrumentalArrFromDB:[String]!
        var initialeng:NSMutableDictionary!
        var artRef:DatabaseReference!
        if let eng = initialRoles["Engineer"] as? NSDictionary {
            initialeng = eng.mutableCopy() as! NSMutableDictionary
        }
        
        getPersonInstrumentalsInDB(ref: ref, completion: {[weak self] instrumentals in
            guard let strongSelf = self else {return}
            initialInstrumentalArrFromDB = instrumentals
            if let ro = strongSelf.currPerson.roles {
                
                if let newenggg = (ro["Engineer"] as? NSDictionary) {
                    strongSelf.currentEngRoles = newenggg
                } else {
                    strongSelf.currentEngRoles = nil
                }
                if let new = ro["Artist"] as? [String] {
                    
                    if let old = initialRoles["Artist"] as? [String] {
                        let semap = DispatchSemaphore(value: 1)
//                        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
//                            guard let strongSelf = self else {return}
                            var count = 0
                        var completioncount = 0
                        
                        if old != new {
                            for item in new {
                                if count != 0 {
                                    usleep(100)
                                }
                                count+=1
                                if !old.contains(item) {
                                    strongSelf.addPersonToInstrumentalInDB(son: item, cat: "Artist", completion: {err in
                                        if let err = err {
                                            completion(err)
                                            return
                                        } else {
                                            strongSelf.updateInstrumentalRolesP2(initialRoles: initialRoles, songs: instrumentals, completion: {err in
                                                completioncount+=1
                                                if let err = err {
                                                    completion(err)
                                                    return
                                                } else {
                                                    
                                                    if completioncount == (old.count+new.count) {
                                                        completion(nil)
                                                    }
                                                }
                                            })
                                        }
                                    })
                                }
                                else {
                                    strongSelf.updateInstrumentalRolesP2(initialRoles: initialRoles, songs: instrumentals, completion: {err in
                                        completioncount+=1
//                                        semap.signal()
                                        if let err = err {
                                            completion(err)
                                            return
                                        } else {
                                            if completioncount == (old.count+new.count) {
                                                completion(nil)
                                            }
                                        }
                                    })
                                }
                                print("arcount ", count, new.count)
//                                semap.wait()
                            }
                            for item in old {
                                
                                if count != 0 {
                                    usleep(100)
                                }
                                count+=1
                                if !new.contains(item) {
                                    strongSelf.removePersonFromInstrumentalInDB(son: item, cat: "Artist", completion: {err in
                                        if let err = err {
                                            completion(err)
                                            return
                                        } else {
                                            strongSelf.updateInstrumentalRolesP2(initialRoles: initialRoles, songs: instrumentals, completion: {err in
                                                completioncount+=1
                                                //                                                    semap.signal()
                                                if let err = err {
                                                    completion(err)
                                                    return
                                                } else {
                                                    if completioncount == (old.count+new.count) {
                                                        completion(nil)
                                                    }
                                                }
                                            })
                                        }
                                    })
                                }
                                else {
                                    strongSelf.updateInstrumentalRolesP2(initialRoles: initialRoles, songs: instrumentals, completion: {err in
                                        completioncount+=1
//                                        semap.signal()
                                        if let err = err {
                                            completion(err)
                                            return
                                        } else {
                                            if completioncount == (old.count+new.count) {
                                                completion(nil)
                                            }
                                        }
                                    })
                                }
                                print("aroldcount ", count, old.count)
//                                semap.wait()
                            }
                        } else {
                            strongSelf.updateInstrumentalRolesP2(initialRoles: initialRoles, songs: instrumentals, completion: {err in
                                if let err = err {
                                    completion(err)
                                    return
                                } else {
                                    completion(nil)
                                }
                            })
                        }
//                        }
                    } else {
                        let semap = DispatchSemaphore(value: 1)
//                        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
//                            guard let strongSelf = self else {return}
                            var count = 0
                        var completioncount = 0
                            for item in new {
                                if count != 0 {
                                    usleep(100)
                                }
                                count+=1
                                
                                strongSelf.addPersonToInstrumentalInDB(son: item, cat: "Artist",completion: {err in
                                    if let err = err {
                                        completion(err)
                                        return
                                    } else {
                                        
                                        strongSelf.updateInstrumentalRolesP2(initialRoles: initialRoles, songs: instrumentals, completion: {err in
                                            completioncount+=1
                                            if let err = err {
                                                completion(err)
                                                return
                                            } else {
                                                if completioncount == (new.count) {
                                                    completion(nil)
                                                }
                                            }
                                        })
                                    }
                                })
                                //semap.wait()
                            }
//                        }
                    }
                } else if let old = initialRoles["Artist"] as? [String] {
                    if let new = ro["Artist"] as? [String] {
                        let semap = DispatchSemaphore(value: 1)
//                        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
//                            guard let strongSelf = self else {return}
                            var count = 0
                        var completioncount = 0
                            for item in old {
                                if count != 0 {
                                    usleep(100)
                                }
                                count+=1
                                if !new.contains(item) {
                                    strongSelf.removePersonFromInstrumentalInDB(son: item, cat: "Artist", completion: {err in
                                        if let err = err {
                                            completion(err)
                                            return
                                        } else {
                                            strongSelf.updateInstrumentalRolesP2(initialRoles: initialRoles, songs: instrumentals, completion: {err in
                                                completioncount+=1
                                                if let err = err {
                                                    completion(err)
                                                    return
                                                } else {
                                                    if completioncount == (old.count) {
                                                        completion(nil)
                                                    }
                                                }
                                            })
                                        }
                                    })
                                    //semap.wait()
                                }
                            }
//                        }
                    } else {
                        
                        let semap = DispatchSemaphore(value: 1)
//                        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
//                            guard let strongSelf = self else {return}
                            var count = 0
                        var completioncount = 0
                            for item in old {
                                if count != 0 {
                                    usleep(100)
                                }
                                count+=1
                                strongSelf.removePersonFromInstrumentalInDB(son: item, cat: "Artist", completion: {err in
                                    if let err = err {
                                        completion(err)
                                        return
                                    } else {
                                        strongSelf.updateInstrumentalRolesP2(initialRoles: initialRoles, songs: instrumentals, completion: {err in
                                            completioncount+=1
                                            
                                            if let err = err {
                                                completion(err)
                                                return
                                            } else {
                                                if completioncount == (old.count) {
                                                    completion(nil)
                                                }
                                            }
                                        })
                                    }
                                })
                                //semap.wait()
                            }
                        //                        }
                    }
                } else {
                    strongSelf.updateInstrumentalRolesP2(initialRoles: initialRoles, songs: instrumentals, completion: {err in
                        if let err = err {
                            completion(err)
                            return
                        } else {
                            completion(nil)
                        }
                    })
                }
            }
            else {
                if let arr = initialRoles["Artist"] as? [String] {
                    let semap = DispatchSemaphore(value: 1)
                    let group = DispatchGroup()
//                    DispatchQueue.global(qos: .userInitiated).async { [weak self] in
//                        guard let strongSelf = self else {return}
                        var count = 0
                    var completioncount = 0
                        for songg in arr {
                            if count != 0 {
                                usleep(100)
                            }
                            count+=1
                                //If the a song is on an album, go to the album in database and remove the person from the albums 'All Artist' node
                                        strongSelf.removePersonFromInstrumentalInDB(son: songg, cat: "Artist", completion: {err in
                                            if let err = err {
                                                completion(err)
                                                return
                                            } else {
                                                strongSelf.updateInstrumentalRolesP2(initialRoles: initialRoles, songs: instrumentals, completion: {err in
                                                    completioncount+=1
                                                    print(completioncount, (arr.count))
                                                    
                                                    if let err = err {
                                                        completion(err)
                                                        return
                                                    } else {
                                                        if completioncount == (arr.count) {
                                                            completion(nil)
                                                        }
                                                    }
                                                })
                                            }
                                        })
                        }
                }
                else {
                    strongSelf.updateInstrumentalRolesP2(initialRoles: initialRoles, songs: instrumentals, completion: {err in
                        if let err = err {
                            completion(err)
                            return
                        } else {
                            completion(nil)
                        }
                    })
                }
            }
        })
    }
    
    func updateInstrumentalRolesP2(initialRoles:NSMutableDictionary , songs:[String],completion: @escaping ((Error?) -> Void)) {
        var initialInstrumentalArrFromDB:[String] = songs
        var initialeng:NSMutableDictionary!
        if let eng = initialRoles["Engineer"] as? NSDictionary {
            initialeng = eng.mutableCopy() as! NSMutableDictionary
        }
        
        if let ro = currPerson.roles {
        if let new = ro["Producer"] as? [String] {
            
            if let old = initialRoles["Producer"] as? [String] {
                let semap = DispatchSemaphore(value: 1)
//                DispatchQueue.global(qos: .userInitiated).async { [weak self] in
//                    guard let strongSelf = self else {return}
                if new != old {
                    var count = 0
                    for item in new {
                        if count != 0 {
                            usleep(100)
                        }
                        count+=1
                        if !old.contains(item) {
                            //Add PersonTo song artist: song is item
                            addPersonToInstrumentalInDB(son: item, cat: "Producer", completion: {err in
                                if new.count != 1 {
//                                    //semap.signal()
                                }
                                if let err = err {
                                    completion(err)
                                    return
                                }
                            })
                        }
                        if new.count != 1 {
//                            //semap.wait()
                        }
                    }
                    for item in old {
                        if count != 0 {
                            usleep(100)
                        }
                        count+=1
                        if !new.contains(item) {
                            
                            //Add PersonTo song artist: song is item
                            removePersonFromInstrumentalInDB(son: item, cat: "Producer", completion: {err in
                                if old.count != 1 {
                                    //semap.signal()
                                }
                                if let err = err {
                                    completion(err)
                                    return
                                }
                            })
                        }
                        if old.count != 1 {
                            //semap.wait()
                        }
                    }
                }
//                }
            } else {
                let semap = DispatchSemaphore(value: 1)
                let group = DispatchGroup()
//                DispatchQueue.global(qos: .userInitiated).async { [weak self] in
//                    guard let strongSelf = self else {return}
                    var count = 0
                    
                    for item in new {
                        if count != 0 {
                            usleep(100)
                        }
                        count+=1
                        //Add PersonTo song artist: song is item
                        addPersonToInstrumentalInDB(son: item, cat: "Producer", completion: {err in
                            //semap.signal()
                            if let err = err {
                                completion(err)
                                return
                            }
                        })
                        //semap.wait()
                    }
//                }
            }
        } else if let old = initialRoles["Producer"] as? [String] {
            if let new = ro["Producer"] as? [String] {
                let semap = DispatchSemaphore(value: 1)
                let group = DispatchGroup()
//                DispatchQueue.global(qos: .userInitiated).async { [weak self] in
//                    guard let strongSelf = self else {return}
                    var count = 0
                if old != new {
                    for item in old {
                        if count != 0 {
                            usleep(100)
                        }
                        count+=1
                        if !new.contains(item) {
                            //remove person from song artist: song is item
                            removePersonFromInstrumentalInDB(son: item, cat: "Producer", completion: {err in
                                //semap.signal()
                                if let err = err {
                                    completion(err)
                                    return
                                }
                            })
                        }
                        //semap.wait()
                    }
                for item in new {
                    if count != 0 {
                        usleep(100)
                    }
                    count+=1
                    if !old.contains(item) {
                        //remove person from song artist: song is item
                        addPersonToInstrumentalInDB(son: item, cat: "Producer", completion: {err in
                            //semap.signal()
                            if let err = err {
                                completion(err)
                                return
                            }
                        })
                    }
                    //semap.wait()
                }
                }
//                }
            } else {
                let semap = DispatchSemaphore(value: 1)
                let group = DispatchGroup()
//                DispatchQueue.global(qos: .userInitiated).async { [weak self] in
//                    guard let strongSelf = self else {return}
                    var count = 0
                    for item in old {
                        if count != 0 {
                            usleep(100)
                        }
                        count+=1
                        //remove person from song artist: song is item
                        removePersonFromInstrumentalInDB(son: item, cat: "Producer", completion: {err in
                            //semap.signal()
                            if let err = err {
                                completion(err)
                                return
                            }
                        })
                        //semap.wait()
                    }
//                }
            }
        }
        if let newenggg = (currentEngRoles as? NSDictionary) {
            
            let newengg = newenggg.mutableCopy() as! NSMutableDictionary
            if newengg.count > 0 {
                
            if let new = newengg["Mix Engineer"] as? [String] {
                if let inieng = initialeng as? NSDictionary {
                    let initeng = inieng.mutableCopy() as! NSMutableDictionary
                    
                    if let old = initeng["Mix Engineer"] as? [String] {
                        
                        if new != old {
                            
                            let semap = DispatchSemaphore(value: 1)
//                            DispatchQueue.global(qos: .userInitiated).async { [weak self] in
//                                guard let strongSelf = self else {return}
                                var count = 0
                                for item in new {
                                    if count != 0 {
                                        usleep(100)
                                    }
                                    count+=1
                                    if !old.contains(item) {
                                        addPersonToInstrumentalInDB(son: item, cat: "Mix Engineer", completion: {err in
                                            if new.count != 1 {
                                                //semap.signal()
                                            }
                                            if let err = err {
                                                completion(err)
                                                return
                                            }
                                        })
                                    }
                                    if new.count != 1 {
                                        //semap.wait()
                                    }
                                }
                            for item in old {
                                
                                if count != 0 {
                                    usleep(100)
                                }
                                count+=1
                                
                                if !new.contains(item) {
                                    
                                    //Add PersonTo song artist: song is item
                                    removePersonFromInstrumentalInDB(son: item, cat: "Mix Engineer", completion: {err in
                                        if old.count != 1 {
                                            //semap.signal()
                                        }
                                        if let err = err {
                                            completion(err)
                                            return
                                        }
                                    })
                                }
                                if old.count != 1 {
                                    //semap.wait()
                                }
                            }
//                            }
                        }
                    } else {
                        let semap = DispatchSemaphore(value: 1)
                        let group = DispatchGroup()
//                        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
//                            guard let strongSelf = self else {return}
                            var count = 0
                            for item in new {
                                if count != 0 {
                                    usleep(100)
                                }
                                count+=1
                                //Add PersonTo song artist: song is item
                                addPersonToInstrumentalInDB(son: item, cat: "Mix Engineer", completion: {err in
                                    //semap.signal()
                                    if let err = err {
                                        completion(err)
                                        return
                                    }
                                })
                                //semap.wait()
                            }
//                        }
                    }
                } else {
                    let semap = DispatchSemaphore(value: 1)
//                    DispatchQueue.global(qos: .userInitiated).async { [weak self] in
//                        guard let strongSelf = self else {return}
                        var count = 0
                        for item in new {
                            if count != 0 {
                                usleep(100)
                            }
                            count+=1
                            //Add PersonTo song artist: song is item
                            addPersonToInstrumentalInDB(son: item, cat: "Mix Engineer", completion: {err in
                                //semap.signal()
                                if let err = err {
                                    completion(err)
                                    return
                                }
                            })
                            //semap.wait()
                        }
//                    }
                }
            }
                else if let inieng = initialeng as? NSDictionary {
                    let initeng = inieng.mutableCopy() as! NSMutableDictionary
                    if let old = initeng["Mix Engineer"] as? [String] {
                        if let new = newengg["Mix Engineer"] as? [String] {
                            
                            if new != old {
                                let semap = DispatchSemaphore(value: 1)
//                                DispatchQueue.global(qos: .userInitiated).async { [weak self] in
//                                    guard let strongSelf = self else {return}
                                    var count = 0
                                for item in old {
                                    if count != 0 {
                                        usleep(100)
                                    }
                                    count+=1
                                    if !new.contains(item) {
                                        //remove person from song artist: song is item
                                        removePersonFromInstrumentalInDB(son: item, cat: "Mix Engineer", completion: {err in
                                            //semap.signal()
                                            if let err = err {
                                                completion(err)
                                                return
                                            }
                                        })
                                    }
                                    //semap.wait()
                                    }
                                for item in new {
                                    if count != 0 {
                                        usleep(100)
                                    }
                                    count+=1
                                    if !old.contains(item) {
                                        //remove person from song artist: song is item
                                        addPersonToInstrumentalInDB(son: item, cat: "Mix Engineer", completion: {err in
                                            //semap.signal()
                                            if let err = err {
                                                completion(err)
                                                return
                                            }
                                        })
                                    }
                                    //semap.wait()
                                    }
//                                }
                            }
                        } else {
                            let semap = DispatchSemaphore(value: 1)
//                            DispatchQueue.global(qos: .userInitiated).async { [weak self] in
//                                guard let strongSelf = self else {return}
                                var count = 0
                                for item in old {
                                    if count != 0 {
                                        usleep(100)
                                    }
                                    count+=1
                                    //remove person from song artist: song is item
                                    removePersonFromInstrumentalInDB(son: item, cat: "Mix Engineer", completion: {err in
                                        //semap.signal()
                                        if let err = err {
                                            completion(err)
                                            return
                                        }
                                        
                                    })
                                    //semap.wait()
                                }
//                            }
                        }
                }
            }
                
                
                if let new = newengg["Mastering Engineer"] as? [String] {
                    if let inieng = initialeng as? NSDictionary {
                        let initeng = inieng.mutableCopy() as! NSMutableDictionary
                        if let old = initeng["Mastering Engineer"] as? [String] {
                            let semap = DispatchSemaphore(value: 1)
//                            DispatchQueue.global(qos: .userInitiated).async { [weak self] in
//                                guard let strongSelf = self else {return}
                                var count = 0
                            if new != old {
                                for item in new {
                                    if count != 0 {
                                        usleep(100)
                                    }
                                    count+=1
                                    if !old.contains(item) {
                                        //Add PersonTo song artist: song is item
                                        addPersonToInstrumentalInDB(son: item, cat: "Mastering Engineer", completion: {err in
                                            if new.count != 1 {
//                                            //semap.signal()
                                            }
                                            if let err = err {
                                                completion(err)
                                                return
                                            }
                                        })
                                    }
                                    if new.count != 1 {
//                                    //semap.wait()
                                    }
                                }
                                for item in old {
                                    if count != 0 {
                                        usleep(100)
                                    }
                                    count+=1
                                    if !new.contains(item) {
                                        //Add PersonTo song artist: song is item
                                        removePersonFromInstrumentalInDB(son: item, cat: "Mastering Engineer", completion: {err in
                                            if old.count != 1 {
//                                            //semap.signal()
                                            }
                                            if let err = err {
                                                completion(err)
                                                return
                                            }
                                        })
                                    }
                                    if old.count != 1 {
//                                    //semap.wait()
                                    }
                                }
                            }
//                            }
                        } else {
                            let semap = DispatchSemaphore(value: 1)
                                var count = 0
                            for item in new {
                                if count != 0 {
                                    usleep(100)
                                }
                                count+=1
                                //Add PersonTo song artist: song is item
                                addPersonToInstrumentalInDB(son: item, cat: "Mastering Engineer", completion: {err in
                                    //semap.signal()
                                    if let err = err {
                                        completion(err)
                                        return
                                    }
                                })
                                //semap.wait()
                            }
//                            }
                        }
                    } else {
                        
                            let semap = DispatchSemaphore(value: 1)
//                            DispatchQueue.global(qos: .userInitiated).async { [weak self] in
//                                guard let strongSelf = self else {return}
                                var count = 0
                        for item in new {
                            if count != 0 {
                                usleep(100)
                            }
                            count+=1
                            //Add PersonTo song artist: song is item
                            addPersonToInstrumentalInDB(son: item, cat: "Mastering Engineer", completion: {err in
                                //semap.signal()
                                if let err = err {
                                    completion(err)
                                    return
                                }
                            })
                            //semap.wait()
                        }
//                        }
                    }
                }
                else if let inieng = initialeng as? NSDictionary {
                    let initeng = inieng.mutableCopy() as! NSMutableDictionary
                    if let old = initeng["Mastering Engineer"] as? [String] {
                        if let new = newengg["Mastering Engineer"] as? [String] {
                            
                            if new != old {
                                let semap = DispatchSemaphore(value: 1)
                                let group = DispatchGroup()
//                                DispatchQueue.global(qos: .userInitiated).async { [weak self] in
//                                    guard let strongSelf = self else {return}
                                    var count = 0
                                for item in old {
                                    if count != 0 {
                                        usleep(100)
                                    }
                                    count+=1
                                    if !new.contains(item) {
                                        //remove person from song artist: song is item
                                        removePersonFromInstrumentalInDB(son: item, cat: "Mastering Engineer", completion: {err in
                                            //semap.signal()
                                            if let err = err {
                                                completion(err)
                                                return
                                            }
                                        })
                                    }
                                    //semap.wait()
                                }
                                for item in new {
                                    if count != 0 {
                                        usleep(100)
                                    }
                                    count+=1
                                    if !old.contains(item) {
                                        //remove person from song artist: song is item
                                        addPersonToInstrumentalInDB(son: item, cat: "Mastering Engineer", completion: {err in
                                            //semap.signal()
                                            if let err = err {
                                                completion(err)
                                                return
                                            }
                                        })
                                    }
                                    //semap.wait()
                                }
//                                }
                            }
                        } else {
                            let semap = DispatchSemaphore(value: 1)
                            let group = DispatchGroup()
//                            DispatchQueue.global(qos: .userInitiated).async { [weak self] in
//                                guard let strongSelf = self else {return}
                                var count = 0
                                for item in old {
                                    if count != 0 {
                                        usleep(100)
                                    }
                                    count+=1
                                    //remove person from song artist: song is item
                                    removePersonFromInstrumentalInDB(son: item, cat: "Mastering Engineer", completion: {err in
                                        //semap.signal()
                                        if let err = err {
                                            completion(err)
                                            return
                                        }
                                    })
                                    //semap.wait()
                                }
//                            }
                        }
                    }
                }
            }
            
        } else if let oldenggg = initialRoles["Engineer"] as? NSDictionary {
            let oldnegg = oldenggg.mutableCopy() as! NSMutableDictionary
            if let newengg = ro["Engineer"] as? NSMutableDictionary {
                if let new = newengg["Mix Engineer"] as? [String] {
                    if let old = initialeng["Mix Engineer"] as? [String] {
                        if new != old {
                            let semap = DispatchSemaphore(value: 1)
                            let group = DispatchGroup()
//                            DispatchQueue.global(qos: .userInitiated).async { [weak self] in
//                                guard let strongSelf = self else {return}
                                var count = 0
                                for item in new {
                                    if count != 0 {
                                        usleep(100)
                                    }
                                    count+=1
                                    if !old.contains(item) {
                                        //Add PersonTo song artist: song is item
                                        addPersonToInstrumentalInDB(son: item, cat: "Mix Engineer", completion: {err in
                                            //semap.signal()
                                            if let err = err {
                                                completion(err)
                                                return
                                            }
                                        })
                                    }
                                    //semap.wait()
                                }
                            for item in old {
                                if count != 0 {
                                    usleep(100)
                                }
                                count+=1
                                if !new.contains(item) {
                                    //Add PersonTo song artist: song is item
                                    removePersonFromInstrumentalInDB(son: item, cat: "Mix Engineer", completion: {err in
                                        //semap.signal()
                                        if let err = err {
                                            completion(err)
                                            return
                                        }
                                    })
                                }
                                //semap.wait()
                            }
//                            }
                        }
                    } else {
                        let semap = DispatchSemaphore(value: 1)
                        let group = DispatchGroup()
//                        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
//                            guard let strongSelf = self else {return}
                            var count = 0
                            for item in new {
                                if count != 0 {
                                    usleep(100)
                                }
                                count+=1
                                //Add PersonTo song artist: song is item
                                addPersonToInstrumentalInDB(son: item, cat: "Mix Engineer", completion: {err in
                                    //semap.signal()
                                    if let err = err {
                                        completion(err)
                                        return
                                    }
                                })
                                //semap.wait()
                            }
//                        }
                    }
                } else if let old = initialeng["Mix Engineer"] as? [String] {
                    if let new = newengg["Mix Engineer"] as? [String] {
                        if new != old {
                            let semap = DispatchSemaphore(value: 1)
                            let group = DispatchGroup()
//                            DispatchQueue.global(qos: .userInitiated).async { [weak self] in
//                                guard let strongSelf = self else {return}
                                var count = 0
                                for item in old {
                                    if count != 0 {
                                        usleep(100)
                                    }
                                    count+=1
                                    if !new.contains(item) {
                                        //remove person from song artist: song is item
                                        removePersonFromInstrumentalInDB(son: item, cat: "Mix Engineer", completion: {err in
                                            //semap.signal()
                                            if let err = err {
                                                completion(err)
                                                return
                                            }
                                        })
                                    }
                                    //semap.wait()
                                }
                            for item in new {
                                if count != 0 {
                                    usleep(100)
                                }
                                count+=1
                                if !old.contains(item) {
                                    //remove person from song artist: song is item
                                    addPersonToInstrumentalInDB(son: item, cat: "Mix Engineer", completion: {err in
                                        //semap.signal()
                                        if let err = err {
                                            completion(err)
                                            return
                                        }
                                    })
                                }
                                //semap.wait()
                            }
//                            }
                        }
                    } else {
                        let semap = DispatchSemaphore(value: 1)
                        let group = DispatchGroup()
//                        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
//                            guard let strongSelf = self else {return}
                            var count = 0
                            for item in old {
                                if count != 0 {
                                    usleep(100)
                                }
                                count+=1
                                //remove person from song artist: song is item
                                removePersonFromInstrumentalInDB(son: item, cat: "Mix Engineer", completion: {err in
                                    //semap.signal()
                                    if let err = err {
                                        completion(err)
                                        return
                                    }
                                })
                                //semap.wait()
                            }
//                        }
                    }
                }
                if let new = newengg["Mastering Engineer"] as? [String] {
                    
                    if let old = initialeng["Mastering Engineer"] as? [String] {
                        if new != old {
                            let semap = DispatchSemaphore(value: 1)
//                            DispatchQueue.global(qos: .userInitiated).async { [weak self] in
//                                guard let strongSelf = self else {return}
                                var count = 0
                                for item in new {
                                    if count != 0 {
                                        usleep(100)
                                    }
                                    count+=1
                                    if !old.contains(item) {
                                        //Add PersonTo song artist: song is item
                                        addPersonToInstrumentalInDB(son: item, cat: "Mastering Engineer", completion: {err in
                                            //semap.signal()
                                            if let err = err {
                                                completion(err)
                                                return
                                            }
                                        })
                                    }
                                    //semap.wait()
                                }
                            for item in old {
                                if count != 0 {
                                    usleep(100)
                                }
                                count+=1
                                if !new.contains(item) {
                                    //Add PersonTo song artist: song is item
                                    removePersonFromInstrumentalInDB(son: item, cat: "Mastering Engineer", completion: {err in
                                        //semap.signal()
                                        if let err = err {
                                            completion(err)
                                            return
                                        }
                                    })
                                }
                                //semap.wait()
                            }
//                            }
                        }
                    } else {
                        let semap = DispatchSemaphore(value: 1)
//                        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
//                            guard let strongSelf = self else {return}
                            var count = 0
                            for item in new {
                                if count != 0 {
                                    usleep(100)
                                }
                                count+=1
                                //Add PersonTo song artist: song is item
                                addPersonToInstrumentalInDB(son: item, cat: "Mastering Engineer", completion: {err in
                                    //semap.signal()
                                    if let err = err {
                                        completion(err)
                                        return
                                    }
                                })
                                //semap.wait()
                            }
//                        }
                    }
                } else if let old = initialeng["Mastering Engineer"] as? [String] {
                    if let new = newengg["Mastering Engineer"] as? [String] {
                        if new != old {
                            let semap = DispatchSemaphore(value: 1)
                            let group = DispatchGroup()
//                            DispatchQueue.global(qos: .userInitiated).async { [weak self] in
//                                guard let strongSelf = self else {return}
                                var count = 0
                                for item in old {
                                    if count != 0 {
                                        usleep(100)
                                    }
                                    count+=1
                                    if !new.contains(item) {
                                        //remove person from song artist: song is item
                                        removePersonFromInstrumentalInDB(son: item, cat: "Mastering Engineer", completion: {err in
                                            //semap.signal()
                                            if let err = err {
                                                completion(err)
                                                return
                                            }
                                            //                                            else {
                                            //                                                completion(nil)
                                            //                                            }
                                        })
                                    }
                                    //semap.wait()
                                }
                            for item in new {
                                if count != 0 {
                                    usleep(100)
                                }
                                count+=1
                                if !old.contains(item) {
                                    //remove person from song artist: song is item
                                    addPersonToInstrumentalInDB(son: item, cat: "Mastering Engineer", completion: {err in
                                        //semap.signal()
                                        if let err = err {
                                            completion(err)
                                            return
                                        }
                                        //                                            else {
                                        //                                                completion(nil)
                                        //                                            }
                                    })
                                }
                                //semap.wait()
                            }
//                            }
                        }
                    } else {
                        let semap = DispatchSemaphore(value: 1)
                        let group = DispatchGroup()
//                        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
//                            guard let strongSelf = self else {return}
                            var count = 0
                            for item in old {
                                if count != 0 {
                                    usleep(100)
                                }
                                count+=1
                                //remove person from song artist: song is item
                                removePersonFromInstrumentalInDB(son: item, cat: "Mastering Engineer", completion: {err in
                                    //semap.signal()
                                    if let err = err {
                                        completion(err)
                                        return
                                    }
                                    //                                        else {
                                    //                                            completion(nil)
                                    //                                        }
                                })
                                //semap.wait()
                            }
//                        }
                    }
                }
            } else {
                if let old = oldenggg["Mix Engineer"] as? [String] {
                    let semap = DispatchSemaphore(value: 1)
                    let group = DispatchGroup()
//                    DispatchQueue.global(qos: .userInitiated).async { [weak self] in
//                        guard let strongSelf = self else {return}
                        var count = 0
                        for item in old {
                            
                            //remove person from song artist: song is item
                            removePersonFromInstrumentalInDB(son: item, cat: "Mix Engineer", completion: {err in
                                //semap.signal()
                                if let err = err {
                                    completion(err)
                                    return
                                }
                            })
                            //semap.wait()
                        }
//                    }
                }
                if let old = oldenggg["Mastering Engineer"] as? [String] {
                    let semap = DispatchSemaphore(value: 1)
                    let group = DispatchGroup()
//                    DispatchQueue.global(qos: .userInitiated).async { [weak self] in
//                        guard let strongSelf = self else {return}
                        var count = 0
                        for item in old {
                            if count != 0 {
                                usleep(100)
                            }
                            count+=1
                            removePersonFromInstrumentalInDB(son: item, cat: "Mastering Engineer", completion: {err in
                                //semap.signal()
                                if let err = err {
                                    completion(err)
                                    return
                                }
                            })
                            //semap.wait()
                        }
//                    }
                }
            }
        }
        }
        else {
            if let arr = initialRoles["Producer"] as? [String] {
                let semap = DispatchSemaphore(value: 1)
                let group = DispatchGroup()
//                DispatchQueue.global(qos: .userInitiated).async { [weak self] in
//                    guard let strongSelf = self else {return}
                    var count = 0
                    for songg in arr {
                        if count != 0 {
                            usleep(100)
                        }
                        count+=1
                        removePersonFromInstrumentalInDB(son: songg, cat: "Producer", completion:{ err in
                            //semap.signal()
                            if let err = err {
                                completion(err)
                                return
                            }
                        })
                        //semap.wait()
                    }
//                }
            }
            if let engg = initialRoles["Engineer"] as? NSMutableDictionary {
                if let arr = engg["Mix Engineer"] as? [String] {
                    let semap = DispatchSemaphore(value: 1)
                    let group = DispatchGroup()
//                    DispatchQueue.global(qos: .userInitiated).async { [weak self] in
//                        guard let strongSelf = self else {return}
                        var count = 0
                        for songg in arr {
                            if count != 0 {
                                usleep(100)
                            }
                            count+=1
                            removePersonFromInstrumentalInDB(son: songg, cat: "Mix Engineer", completion:{ err in
                                //semap.signal()
                                if let err = err {
                                    completion(err)
                                    return
                                }
                            })
                            //semap.wait()
                        }
//                    }
                }
                if let arr = engg["Mastering Engineer"] as? [String] {
                    let semap = DispatchSemaphore(value: 1)
                    let group = DispatchGroup()
//                    DispatchQueue.global(qos: .userInitiated).async { [weak self] in
//                        guard let strongSelf = self else {return}
                        var count = 0
                        for songg in arr {
                            if count != 0 {
                                usleep(100)
                            }
                            count+=1
                            removePersonFromInstrumentalInDB(son: songg, cat: "Mastering Engineer", completion:{ err in
                                //semap.signal()
                                if let err = err {
                                    completion(err)
                                    return
                                }
                            })
                            //semap.wait()
                        }
//                    }
                }
                
            }
        }
        
        if initialInstrumentalArrFromDB == currPerson.instrumentals {
            completion(nil)
            return
        }
        
        if !initialInstrumentalArrFromDB.isEmpty {
            let semaphore = DispatchSemaphore(value: 1)
            var count = 0
            for i in 0 ... initialInstrumentalArrFromDB.count-1 {
                if count != 0 {
                    usleep(100)
                }
                count+=1
                if currPerson.instrumentals != nil {
                    if i < currPerson.instrumentals!.count {
                        if !currPerson.instrumentals![i].contains(initialInstrumentalArrFromDB[i]) {
                            removePersonFromInstrumentalInDB(son: initialInstrumentalArrFromDB[i], completion: {err in
                                //                            semaphore.signal()
                                if let err = err {
                                    completion(err)
                                    return
                                }
                                //                                else {
                                //                                    completion(nil)
                                //                                }
                            })
                        } else {
                            //                        semaphore.signal()
                        }
                    } else {
                        removePersonFromInstrumentalInDB(son: initialInstrumentalArrFromDB[i], completion: {err in
                            //                        semaphore.signal()
                            if let err = err {
                                completion(err)
                                return
                            }
                            //                            else {
                            //                                completion(nil)
                            //                            }
                        })
                    }
                } else {
                    removePersonFromInstrumentalInDB(son: initialInstrumentalArrFromDB[i], completion: {err in
                        //                        semaphore.signal()
                        if let err = err {
                            completion(err)
                            return
                        }
                    })
                }
                //                semaphore.wait()
            }
        }
        if currPerson.instrumentals != nil {
            if !currPerson.instrumentals!.isEmpty {
                let semaphore = DispatchSemaphore(value: 1)
                
                let group = DispatchGroup()
                //            DispatchQueue.global(qos: .userInitiated).async { [weak self] in
                //                guard let strongSelf = self else {return}
                var count = 0
                var songcount = 0
                for i in 0 ... currPerson.instrumentals!.count-1 {
                    if count != 0 {
                        usleep(100)
                    }
                    count+=1
                    if i < initialInstrumentalArrFromDB.count {
                        if !initialInstrumentalArrFromDB[i].contains(currPerson.instrumentals![i]) {
                            addPersonToInstrumentalInDB(son: currPerson.instrumentals![i], completion: {[weak self] err in
                                guard let strongSelf = self else {return}
                                //                                semaphore.signal()
                                if let err = err {
                                    completion(err)
                                    return
                                }
                                else {
                                    
                                    songcount+=1
                                    if songcount == strongSelf.currPerson.instrumentals!.count {
                                        completion(nil)
                                    }
                                }
                            })
                        }
                        else {
                            //                            semaphore.signal()
                            songcount+=1
                            if songcount == currPerson.instrumentals!.count {
                                completion(nil)
                            }
                        }
                    } else {
                        addPersonToInstrumentalInDB(son: currPerson.instrumentals![i], completion: {[weak self] err in
                            guard let strongSelf = self else {return}
                            //                            semaphore.signal()
                            if let err = err {
                                completion(err)
                                return
                            }else {
                                
                                songcount+=1
                                if songcount == strongSelf.currPerson.instrumentals!.count {
                                    completion(nil)
                                }
                            }
                        })
                    }
                    //                    semaphore.wait()
                }
                //            }
            }
            else {
                completion(nil)
            }
        }
        else {
            completion(nil)
        }
    }
    
    func removePersonFromInstrumentalInDB(son: String, completion: @escaping ((Error?) -> Void)) {
        guard son.count == 12 else {
            completion(nil)
            return
        }
        let word = son.split(separator: "Æ")
        let id = word[0]
        DatabaseManager.shared.findInstrumentalById(instrumentalId: String(id), completion: {[weak self] result in
            guard let strongSelf = self else {return}
            switch result {
            case .success(let song):
                let ref = Database.database().reference().child("Music Content").child("Instrumentals").child( "\(instrumentalContentType)--\(song.songName!)--\(song.toneDeafAppId)")
                let person = "\(strongSelf.currPerson.toneDeafAppId)"
                if var arrrr = song.artist as? [String] {
                    if arrrr.contains(person) {
                        let index = arrrr.firstIndex(of: person)
                        arrrr.remove(at: index!)
                        song.artist = arrrr
                    }
                }
                if song.producers.contains(person) {
                    let index = song.producers.firstIndex(of: person)
                    song.producers.remove(at: index!)
                }
                if var arrrr = song.mixEngineer as? [String] {
                    if arrrr.contains(person) {
                        let index = arrrr.firstIndex(of: person)
                        arrrr.remove(at: index!)
                        song.mixEngineer = arrrr
                    }
                }
                if var arrrr = song.masteringEngineer as? [String] {
                    if arrrr.contains(person) {
                        let index = arrrr.firstIndex(of: person)
                        arrrr.remove(at: index!)
                        song.masteringEngineer = arrrr
                    }
                }
                let update:[String : Any] = [
                    "Artist": song.artist,
                    "Producers": song.producers,
                    "Engineers": [
                        "Mix Engineer": song.mixEngineer,
                        "Mastering Engineer": song.masteringEngineer
                    ]
                ]
                print(String(data: try! JSONSerialization.data(withJSONObject: update, options: .prettyPrinted), encoding: .utf8)!)
                
                ref.updateChildValues(update, withCompletionBlock: { error, reference in
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
    
    func removePersonFromInstrumentalInDB(son: String, cat:String, completion: @escaping ((Error?) -> Void)) {
        guard son.count == 12 else {
            completion(nil)
            return
        }
        
        DatabaseManager.shared.findInstrumentalById(instrumentalId: son, completion: {[weak self] result in
            guard let strongSelf = self else {return}
            switch result {
            case .success(let song):
                let person = "\(strongSelf.currPerson.toneDeafAppId)"
                var currentArtistRoles:[String] = []
                var initialArtistRoles:[String] = []
                if let ro = strongSelf.currPerson.roles?["Artist"] as? [String] {
                    currentArtistRoles = ro
                }
                if let ro = strongSelf.initialRoles["Artist"] as? [String] {
                    initialArtistRoles = ro
                }
                if initialArtistRoles.contains(son) && !currentArtistRoles.contains(son) {
                    if var artArr = song.artist {
                        if artArr.contains(strongSelf.currPerson.toneDeafAppId) {
                            let dex = artArr.firstIndex(of: strongSelf.currPerson.toneDeafAppId)
                            artArr.remove(at: dex!)
                        }
                    }
                }
                if !initialArtistRoles.contains(son) && currentArtistRoles.contains(son) {
                    if var artArr = song.artist {
                        if !artArr.contains(strongSelf.currPerson.toneDeafAppId) {
                            artArr.append(strongSelf.currPerson.toneDeafAppId)
                        }
                    }
                }
                var ref = Database.database().reference().child("Music Content").child("Instrumentals").child( "\(instrumentalContentType)--\(song.songName!)--\(song.toneDeafAppId)")
                var arrto:[String]!
                switch cat {
                case "Artist":
                    if var arrrrrrr = song.artist as? [String]{
                        if let index = arrrrrrr.firstIndex(of: person) {
                            arrrrrrr.remove(at: index)
                        }
                        song.artist = arrrrrrr
                        arrto = song.artist
                        ref = ref.child("Artist")
                        strongSelf.setValueArray(ref: ref, arrto: arrto, completion: { err in
                            if let err = err {
                                print("dsgsrdgvdz z av "+err.localizedDescription)
                            } else {
                                completion(nil)
                            }
                        })
                    } else {
                        completion(nil)
                    }
                case "Producer":
                    if let index = song.producers.firstIndex(of: person) {
                        song.producers.remove(at: index)
                    }
                    arrto = song.producers
                    ref = ref.child("Producers")
                    strongSelf.setValueArray(ref: ref, arrto: arrto, completion: { err in
                        if let err = err {
                            print("dsgsrdgvdz z av "+err.localizedDescription)
                        } else {
                            completion(nil)
                        }
                    })
                case "Mix Engineer":
                    if var arrrrrrr = song.mixEngineer as? [String]{
                        if let index = arrrrrrr.firstIndex(of: person) {
                            arrrrrrr.remove(at: index)
                        }
                        song.mixEngineer = arrrrrrr
                    }
                    arrto = song.mixEngineer
                    ref = ref.child("Engineers").child("Mix Engineer")
                    strongSelf.setValueArray(ref: ref, arrto: arrto, completion: { err in
                        if let err = err {
                            print("dsgsrdgvdz z av "+err.localizedDescription)
                        } else {
                            completion(nil)
                        }
                    })
                case "Mastering Engineer":
                    if var arrrrrrr = song.masteringEngineer as? [String]{
                        if let index = arrrrrrr.firstIndex(of: person) {
                            arrrrrrr.remove(at: index)
                        }
                        song.masteringEngineer = arrrrrrr
                    }
                    arrto = song.masteringEngineer
                    ref = ref.child("Engineers").child("Mastering Engineer")
                    strongSelf.setValueArray(ref: ref, arrto: arrto, completion: { err in
                        if let err = err {
                            print("dsgsrdgvdz z av "+err.localizedDescription)
                        } else {
                            completion(nil)
                        }
                    })
                default:
                    break
                }
//                print(String(data: try! JSONSerialization.data(withJSONObject: update, options: .prettyPrinted), encoding: .utf8)!)
            case .failure(let err):
                print("dsvgredfxbdfzx"+err.localizedDescription)
            }
        })
    }
    
    func addPersonToInstrumentalInDB(son: String, completion: @escaping ((Error?) -> Void)) {
        guard son.count == 12 else {
            completion(nil)
            return
        }
        DatabaseManager.shared.findInstrumentalById(instrumentalId: son, completion: {[weak self] result in
            guard let strongSelf = self else {return}
            switch result {
            case .success(let song):
                let ref = Database.database().reference().child("Music Content").child("Instrumentals").child( "\(instrumentalContentType)--\(song.songName!)--\(song.toneDeafAppId)")
                let person = "\(strongSelf.currPerson.toneDeafAppId)"
                var update:[String : Any] = [
                    "Artist": song.artist,
                    "Producers": song.producers,
                    "Engineers": [
                        "Mix Engineer": song.mixEngineer,
                        "Mastering Engineer": song.masteringEngineer,
                    ]
                ]
                if let curroo = strongSelf.currPerson.roles {
                    if let roo = curroo["Artist"] as? [String] {
                        if var arrrr = song.artist as? [String] {
                            if roo.contains(son) {
                                if !arrrr.contains(person) {
                                    arrrr.append(person)
                                    song.artist = arrrr
                                    update["Artist"] = song.artist
                                }
                            }
                        } else {
                            var arrrr:[String] = []
                            if roo.contains(son) {
                                if !arrrr.contains(person) {
                                    arrrr.append(person)
                                    song.artist = arrrr
                                    update["Artist"] = song.artist
                                }
                            }
                        }
                    }
                    if let roo = curroo["Producer"] as? [String] {
                        if roo.contains(son) {
                            if !song.producers.contains(person) {
                                song.producers.append(person)
                                update["Producers"] = song.producers
                            }
                        }
                    }
                    if let enggg = curroo["Engineer"] as? NSDictionary {
                        let eng = enggg.mutableCopy() as! NSMutableDictionary
                        let engDict:NSMutableDictionary = [
                            "Mix Engineer": song.mixEngineer,
                            "Mastering Engineer": song.masteringEngineer
                        ]
                        if let roo = eng["Mix Engineer"] as? [String] {
                            if var arrrr = song.mixEngineer as? [String] {
                                if roo.contains(son) {
                                    if !arrrr.contains(person) {
                                        arrrr.append(person)
                                        song.mixEngineer = arrrr
                                    }
                                }
                            } else {
                                var arrrr:[String] = []
                                if roo.contains(son) {
                                    if !arrrr.contains(person) {
                                        arrrr.append(person)
                                        song.mixEngineer = arrrr
                                    }
                                }
                            }
                            engDict["Mix Engineer"] = song.mixEngineer
                        }
                        if let roo = eng["Mastering Engineer"] as? [String] {
                            if var arrrr = song.masteringEngineer as? [String] {
                                if roo.contains(son) {
                                    if !arrrr.contains(person) {
                                        arrrr.append(person)
                                        song.masteringEngineer = arrrr
                                    }
                                }
                            } else {
                                var arrrr:[String] = []
                                if roo.contains(son) {
                                    if !arrrr.contains(person) {
                                        arrrr.append(person)
                                        song.masteringEngineer = arrrr
                                    }
                                }
                            }
                            engDict["Mastering Engineer"] = song.masteringEngineer
                        }
                        update["Engineers"] = engDict
                    }
                }
//                print(String(data: try! JSONSerialization.data(withJSONObject: update, options: .prettyPrinted), encoding: .utf8)!)
                
                ref.updateChildValues(update, withCompletionBlock: { error, reference in
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
    
    func addPersonToInstrumentalInDB(son: String, cat:String, completion: @escaping ((Error?) -> Void)) {
        guard son.count == 12 else {
            completion(nil)
            return
        }
        
        DatabaseManager.shared.findInstrumentalById(instrumentalId: son, completion: {[weak self] result in
            guard let strongSelf = self else {return}
            switch result {
            case .success(let song):
                let person = "\(strongSelf.currPerson.toneDeafAppId)"
                var currentArtistRoles:[String] = []
                var initialArtistRoles:[String] = []
                if let ro = strongSelf.currPerson.roles?["Artist"] as? [String] {
                    currentArtistRoles = ro
                }
                if let ro = strongSelf.initialRoles["Artist"] as? [String] {
                    initialArtistRoles = ro
                }
                if initialArtistRoles.contains(son) && !currentArtistRoles.contains(son) {
                    if var artArr = song.artist {
                        if artArr.contains(strongSelf.currPerson.toneDeafAppId) {
                            let dex = artArr.firstIndex(of: strongSelf.currPerson.toneDeafAppId)
                            artArr.remove(at: dex!)
                        }
                    }
                }
                if !initialArtistRoles.contains(son) && currentArtistRoles.contains(son) {
                    if var artArr = song.artist {
                        if !artArr.contains(strongSelf.currPerson.toneDeafAppId) {
                            artArr.append(strongSelf.currPerson.toneDeafAppId)
                        }
                    }
                }
                var ref = Database.database().reference().child("Music Content").child("Instrumentals").child( "\(instrumentalContentType)--\(song.songName!)--\(song.toneDeafAppId)")
                var arrto:[String]!
                switch cat {
                case "Artist":
                    if var arrrrrrr = song.artist as? [String]{
                        if !arrrrrrr.contains(person) {
                            arrrrrrr.append(person)
                            song.artist = arrrrrrr
                        }
                    } else {
                        song.artist = [person]
                    }
                    arrto = song.artist
                    ref = ref.child("Artist")
                    strongSelf.setValueArray(ref: ref, arrto: arrto, completion: { err in
                        if let err = err {
                            print("dsgsrdgvdz z av "+err.localizedDescription)
                        } else {
                            completion(nil)
                        }
                    })
                case "Producer":
                    if !song.producers.contains(person) {
                        song.producers.append(person)
                    }
                    arrto = song.producers
                    ref = ref.child("Producers")
                    strongSelf.setValueArray(ref: ref, arrto: arrto, completion: { err in
                        if let err = err {
                            print("dsgsrdgvdz z av "+err.localizedDescription)
                        } else {
                            completion(nil)
                        }
                    })
                case "Mix Engineer":
                    if var arrrrrrr = song.mixEngineer as? [String]{
                        if !arrrrrrr.contains(person) {
                            arrrrrrr.append(person)
                            song.mixEngineer = arrrrrrr
                        }
                    } else {
                        song.mixEngineer = [person]
                    }
                    arrto = song.mixEngineer
                    ref = ref.child("Engineers").child("Mix Engineer")
                    strongSelf.setValueArray(ref: ref, arrto: arrto, completion: { err in
                        if let err = err {
                            print("dsgsrdgvdz z av "+err.localizedDescription)
                        } else {
                            completion(nil)
                        }
                    })
                case "Mastering Engineer":
                    if var arrrrrrr = song.masteringEngineer as? [String]{
                        if !arrrrrrr.contains(person) {
                            arrrrrrr.append(person)
                            song.masteringEngineer = arrrrrrr
                        }
                    } else {
                        song.masteringEngineer = [person]
                    }
                    arrto = song.masteringEngineer
                    ref = ref.child("Engineers").child("Mastering Engineer")
                    strongSelf.setValueArray(ref: ref, arrto: arrto, completion: { err in
                        if let err = err {
                            print("dsgsrdgvdz z av "+err.localizedDescription)
                        } else {
                            completion(nil)
                        }
                    })
                default:
                    break
                }
//                print(String(data: try! JSONSerialization.data(withJSONObject: update, options: .prettyPrinted), encoding: .utf8)!)
            case .failure(let err):
                print("dsvgredfxbdfzx"+err.localizedDescription)
            }
        })
    }
    
    func updateInstrumentalAlbumInstrumentals(ref: DatabaseReference, initialRoles:NSMutableDictionary , completion: @escaping ((Error?) -> Void)) {
        guard currPerson.roles != initialRoles else {
            completion(nil)
            return
        }
        var initialeng:NSMutableDictionary!
        var totalProgress:Int = 0
        var completedProgress:Int = 0
        if let eng = initialRoles["Engineer"] as? NSDictionary {
            initialeng = eng.mutableCopy() as! NSMutableDictionary
        }
        
        getPersonInstrumentalsInDB(ref: ref, completion: {[weak self] songs in
            guard let strongSelf = self else {return}
            
            //MARK: - Progress Setup
            if let ro = strongSelf.currPerson.roles {
                
                if let newenggg = (ro["Engineer"] as? NSDictionary) {
                    strongSelf.currentEngRoles = newenggg
                } else {
                    strongSelf.currentEngRoles = nil
                }
                if let new = ro["Artist"] as? [String] {
                    if let old = initialRoles["Artist"] as? [String] {
                        if old != new {
                            for item in new {
                                if !old.contains(item) {
                                    totalProgress+=1
                                }
                            }
                            for item in old {
                                if !new.contains(item) {
                                    totalProgress+=1
                                }
                            }
                        }
                    } else {
                            for item in new {
                                totalProgress+=1
                            }
                    }
                } else if let old = initialRoles["Artist"] as? [String] {
                    if let new = ro["Artist"] as? [String] {
                        for item in old {
                            if !new.contains(item) {
                                totalProgress+=1
                            }
                        }
                    } else {
                            for item in old {
                                totalProgress+=1
                            }
                    }
                }
                if let new = ro["Producer"] as? [String] {
                    
                    if let old = initialRoles["Producer"] as? [String] {
                        if new != old {
                            for item in new {
                                if !old.contains(item) {
                                    totalProgress+=1
                                }
                            }
                            for item in old {
                                if !new.contains(item) {
                                    totalProgress+=1
                                }
                            }
                        }
                    } else {
                            for item in new {
                                totalProgress+=1
                            }
                    }
                } else if let old = initialRoles["Producer"] as? [String] {
                    if let new = ro["Producer"] as? [String] {
                        if old != new {
                            for item in old {
                                if !new.contains(item) {
                                    totalProgress+=1
                                }
                            }
                        for item in new {
                            if !old.contains(item) {
                                totalProgress+=1
                            }
                        }
                        }
                    } else {
                            for item in old {
                                totalProgress+=1
                            }
                    }
                }
                if let newenggg = (strongSelf.currentEngRoles as? NSDictionary) {
                    
                    let newengg = newenggg.mutableCopy() as! NSMutableDictionary
                    if newengg.count > 0 {
                        
                    if let new = newengg["Mix Engineer"] as? [String] {
                        if let inieng = initialeng as? NSDictionary {
                            let initeng = inieng.mutableCopy() as! NSMutableDictionary
                            
                            if let old = initeng["Mix Engineer"] as? [String] {
                                
                                if new != old {
                                        for item in new {
                                            if !old.contains(item) {
                                                totalProgress+=1
                                            }
                                        }
                                    for item in old {
                                        if !new.contains(item) {
                                            totalProgress+=1
                                        }
                                    }
                                }
                            } else {
                                    for item in new {
                                        totalProgress+=1
                                    }
        //                        }
                            }
                        } else {
                                for item in new {
                                    totalProgress+=1
                                }
                        }
                    }
                        else if let inieng = initialeng as? NSDictionary {
                            let initeng = inieng.mutableCopy() as! NSMutableDictionary
                            if let old = initeng["Mix Engineer"] as? [String] {
                                if let new = newengg["Mix Engineer"] as? [String] {
                                    
                                    if new != old {
                                        for item in old {
                                            if !new.contains(item) {
                                                totalProgress+=1
                                            }
                                        }
                                        for item in new {
                                            if !old.contains(item) {
                                                totalProgress+=1
                                            }
                                        }
                                    }
                                } else {
                                    let semap = DispatchSemaphore(value: 1)
                                        for item in old {
                                            totalProgress+=1
                                        }
                                }
                        }
                    }
                        
                        
                        if let new = newengg["Mastering Engineer"] as? [String] {
                            if let inieng = initialeng as? NSDictionary {
                                let initeng = inieng.mutableCopy() as! NSMutableDictionary
                                if let old = initeng["Mastering Engineer"] as? [String] {
                                    if new != old {
                                        for item in new {
                                            if !old.contains(item) {
                                                totalProgress+=1
                                            }
                                        }
                                        for item in old {
                                            if !new.contains(item) {
                                                totalProgress+=1
                                            }
                                        }
                                    }
                                } else {
                                    for item in new {
                                        totalProgress+=1
                                    }
                                }
                            } else {
                                for item in new {
                                    totalProgress+=1
                                }
                            }
                        }
                        else if let inieng = initialeng as? NSDictionary {
                            let initeng = inieng.mutableCopy() as! NSMutableDictionary
                            if let old = initeng["Mastering Engineer"] as? [String] {
                                if let new = newengg["Mastering Engineer"] as? [String] {
                                    
                                    if new != old {
                                        for item in old {
                                            if !new.contains(item) {
                                                totalProgress+=1
                                            }
                                        }
                                        for item in new {
                                            if !old.contains(item) {
                                                totalProgress+=1
                                            }
                                        }
                                    }
                                } else {
                                        for item in old {
                                            totalProgress+=1
                                        }
                                }
                            }
                        }
                    }
                    
                } else if let oldenggg = initialRoles["Engineer"] as? NSDictionary {
                    let oldnegg = oldenggg.mutableCopy() as! NSMutableDictionary
                    if let newengg = ro["Engineer"] as? NSMutableDictionary {
                        if let new = newengg["Mix Engineer"] as? [String] {
                            if let old = initialeng["Mix Engineer"] as? [String] {
                                if new != old {
                                        for item in new {
                                            if !old.contains(item) {
                                                totalProgress+=1
                                            }
                                        }
                                    for item in old {
                                        if !new.contains(item) {
                                            totalProgress+=1
                                        }
                                    }
                                }
                            } else {
                                    for item in new {
                                        totalProgress+=1
                                    }
                            }
                        } else if let old = initialeng["Mix Engineer"] as? [String] {
                            if let new = newengg["Mix Engineer"] as? [String] {
                                if new != old {
                                        for item in old {
                                            if !new.contains(item) {
                                                totalProgress+=1
                                            }
                                        }
                                    for item in new {
                                        if !old.contains(item) {
                                            totalProgress+=1
                                        }
                                    }
                                }
                            } else {
                                    for item in old {
                                        totalProgress+=1
                                    }
                            }
                        }
                        if let new = newengg["Mastering Engineer"] as? [String] {
                            
                            if let old = initialeng["Mastering Engineer"] as? [String] {
                                if new != old {
                                    for item in new {
                                        if !old.contains(item) {
                                            totalProgress+=1
                                        }
                                    }
                                    for item in old {
                                        if !new.contains(item) {
                                            totalProgress+=1
                                        }
                                    }
                                }
                            } else {
                                    for item in new {
                                        totalProgress+=1
                                    }
                            }
                        } else if let old = initialeng["Mastering Engineer"] as? [String] {
                            if let new = newengg["Mastering Engineer"] as? [String] {
                                if new != old {
                                        for item in old {
                                            if !new.contains(item) {
                                                totalProgress+=1
                                            }
                                        }
                                    for item in new {
                                        if !old.contains(item) {
                                            totalProgress+=1
                                        }
                                    }
                                }
                            } else {
                                    for item in old {
                                        totalProgress+=1
                                    }
                            }
                        }
                    } else {
                        if let old = oldenggg["Mix Engineer"] as? [String] {
                                for item in old {
                                    totalProgress+=1
                                }
                        }
                        if let old = oldenggg["Mastering Engineer"] as? [String] {
                                for item in old {
                                    totalProgress+=1
                                }
                        }
                    }
                }
                
                
            }
            else {
                if let arr = initialRoles["Artist"] as? [String] {
                    for songg in arr {
                        totalProgress+=1
                    }
                }
                if let arr = initialRoles["Producer"] as? [String] {
                    for songg in arr {
                        totalProgress+=1
                    }
                }
                if let engg = initialRoles["Engineer"] as? NSMutableDictionary {
                    if let arr = engg["Mix Engineer"] as? [String] {
                        for songg in arr {
                            totalProgress+=1
                        }
                    }
                    if let arr = engg["Mastering Engineer"] as? [String] {
                        for songg in arr {
                            totalProgress+=1
                        }
                    }
                    
                }
            }
            if totalProgress == 0 {
                completion(nil)
                return
            }
            //MARK: - Function
            if let ro = strongSelf.currPerson.roles {
                
                if let newenggg = (ro["Engineer"] as? NSDictionary) {
                    strongSelf.currentEngRoles = newenggg
                } else {
                    strongSelf.currentEngRoles = nil
                }
                if let new = ro["Artist"] as? [String] {
                    
                    if let old = initialRoles["Artist"] as? [String] {
                        let semap = DispatchSemaphore(value: 1)
                            var count = 0
                        
                        if old != new {
                            for item in new {
                                if count != 0 {
                                    usleep(100)
                                }
                                count+=1
                                if !old.contains(item) {
                                    strongSelf.updateInstrumentalAlbumInstrumentals(son: item, cat: "Add", completion: {err in
                                        completedProgress+=1
                                        if let err = err {
                                            completion(err)
                                            return
                                        } else {
                                            if completedProgress == (totalProgress) {
                                                completion(nil)
                                                return
                                            }
                                        }
                                    })
                                }
                                print("arcount ", count, new.count)
//                                semap.wait()
                            }
                            for item in old {
                                
                                if count != 0 {
                                    usleep(100)
                                }
                                count+=1
                                if !new.contains(item) {
                                        strongSelf.updateInstrumentalAlbumInstrumentals(son: item, cat: "Remove", completion: {err in
                                            completedProgress+=1
                                            if let err = err {
                                                completion(err)
                                                return
                                            } else {
                                                if completedProgress == (totalProgress) {
                                                    completion(nil)
                                                    return
                                                }
                                            }
                                        })
                                }
                                print("aroldcount ", count, old.count)
                                //                                semap.wait()
                            }
                        }
                        //                        }
                    } else {
                        let semap = DispatchSemaphore(value: 1)
//                        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
//                            guard let strongSelf = self else {return}
                            var count = 0
                            for item in new {
                                if count != 0 {
                                    usleep(100)
                                }
                                count+=1
                                    strongSelf.updateInstrumentalAlbumInstrumentals(son: item, cat: "Add", completion: {err in
                                        completedProgress+=1
                                        if let err = err {
                                            completion(err)
                                            return
                                        } else {
                                            if completedProgress == (totalProgress) {
                                                completion(nil)
                                                return
                                            }
                                        }
                                    })
                                //semap.wait()
                            }
//                        }
                    }
                } else if let old = initialRoles["Artist"] as? [String] {
                    if let new = ro["Artist"] as? [String] {
                        let semap = DispatchSemaphore(value: 1)
//                        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
//                            guard let strongSelf = self else {return}
                            var count = 0
                        for item in old {
                            if count != 0 {
                                usleep(100)
                            }
                            count+=1
                            if !new.contains(item) {
                                strongSelf.updateInstrumentalAlbumInstrumentals(son: item, cat: "Remove", completion: {err in
                                    completedProgress+=1
                                    if let err = err {
                                        completion(err)
                                        return
                                    } else {
                                        if completedProgress == (totalProgress) {
                                            completion(nil)
                                            return
                                        }
                                    }
                                })
                                //semap.wait()
                            }
                        }
                        //                        }
                    } else {
                        
                        let semap = DispatchSemaphore(value: 1)
//                        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
//                            guard let strongSelf = self else {return}
                            var count = 0
                            for item in old {
                                if count != 0 {
                                    usleep(100)
                                }
                                count+=1
                                    strongSelf.updateInstrumentalAlbumInstrumentals(son: item, cat: "Remove", completion: {err in
                                        completedProgress+=1
                                        if let err = err {
                                            completion(err)
                                            return
                                        } else {
                                            if completedProgress == (totalProgress) {
                                                completion(nil)
                                                return
                                            }
                                        }
                                    })
                                //semap.wait()
                            }
                        //                        }
                    }
                }
                if let new = ro["Producer"] as? [String] {
                    
                    if let old = initialRoles["Producer"] as? [String] {
                        if new != old {
                            var count = 0
                            for item in new {
                                if count != 0 {
                                    usleep(100)
                                }
                                count+=1
                                if !old.contains(item) {
                                        strongSelf.updateInstrumentalAlbumInstrumentals(son: item, cat: "Add", completion: {err in
                                            completedProgress+=1
                                            if let err = err {
                                                completion(err)
                                                return
                                            } else {
                                                if completedProgress == (totalProgress) {
                                                    completion(nil)
                                                    return
                                                }
                                            }
                                        })
                                }
                                if new.count != 1 {
        //                            //semap.wait()
                                }
                            }
                            for item in old {
                                if count != 0 {
                                    usleep(100)
                                }
                                count+=1
                                if !new.contains(item) {
                                    strongSelf.updateInstrumentalAlbumInstrumentals(son: item, cat: "Remove", completion: {err in
                                        completedProgress+=1
                                        if let err = err {
                                            completion(err)
                                            return
                                        } else {
                                            if completedProgress == (totalProgress) {
                                                completion(nil)
                                                return
                                            }
                                        }
                                    })
                                }
                                if old.count != 1 {
                                    //semap.wait()
                                }
                            }
                        }
                    } else {
                        let semap = DispatchSemaphore(value: 1)
                        let group = DispatchGroup()
        //                DispatchQueue.global(qos: .userInitiated).async { [weak self] in
        //                    guard let strongSelf = self else {return}
                            var count = 0
                            for item in new {
                                if count != 0 {
                                    usleep(100)
                                }
                                count+=1
                                strongSelf.updateInstrumentalAlbumInstrumentals(son: item, cat: "Add", completion: {err in
                                    completedProgress+=1
                                    
                                    if let err = err {
                                        completion(err)
                                        return
                                    } else {
                                        if completedProgress == (totalProgress) {
                                            completion(nil)
                                            return
                                        }
                                    }
                                })
                                //semap.wait()
                            }
        //                }
                    }
                } else if let old = initialRoles["Producer"] as? [String] {
                    if let new = ro["Producer"] as? [String] {
                        let semap = DispatchSemaphore(value: 1)
                        let group = DispatchGroup()
        //                DispatchQueue.global(qos: .userInitiated).async { [weak self] in
        //                    guard let strongSelf = self else {return}
                            var count = 0
                        if old != new {
                            for item in old {
                                if count != 0 {
                                    usleep(100)
                                }
                                count+=1
                                if !new.contains(item) {
                                    //remove person from song artist: song is item
                                    strongSelf.updateInstrumentalAlbumInstrumentals(son: item, cat: "Remove", completion: {err in
                                        completedProgress+=1
                                        if let err = err {
                                            completion(err)
                                            return
                                        } else {
                                            if completedProgress == (totalProgress) {
                                                completion(nil)
                                            }
                                        }
                                    })
                                }
                                //semap.wait()
                            }
                        for item in new {
                            if count != 0 {
                                usleep(100)
                            }
                            count+=1
                            if !old.contains(item) {
                                //remove person from song artist: song is item
                                
                                strongSelf.updateInstrumentalAlbumInstrumentals(son: item, cat: "Add", completion: {err in
                                    completedProgress+=1
                                    if let err = err {
                                        completion(err)
                                        return
                                    } else {
                                        if completedProgress == (totalProgress) {
                                            completion(nil)
                                        }
                                    }
                                })
                            }
                            //semap.wait()
                        }
                        }
        //                }
                    } else {
                        let semap = DispatchSemaphore(value: 1)
                        let group = DispatchGroup()
        //                DispatchQueue.global(qos: .userInitiated).async { [weak self] in
        //                    guard let strongSelf = self else {return}
                            var count = 0
                            for item in old {
                                if count != 0 {
                                    usleep(100)
                                }
                                count+=1
                                strongSelf.updateInstrumentalAlbumInstrumentals(son: item, cat: "Remove", completion: {err in
                                    completedProgress+=1
                                    if let err = err {
                                        completion(err)
                                        return
                                    } else {
                                        if completedProgress == (totalProgress) {
                                            completion(nil)
                                            return
                                        }
                                    }
                                })
                                //semap.wait()
                            }
        //                }
                    }
                }
                if let newenggg = (strongSelf.currentEngRoles as? NSDictionary) {
                    
                    let newengg = newenggg.mutableCopy() as! NSMutableDictionary
                    if newengg.count > 0 {
                        
                    if let new = newengg["Mix Engineer"] as? [String] {
                        if let inieng = initialeng as? NSDictionary {
                            let initeng = inieng.mutableCopy() as! NSMutableDictionary
                            
                            if let old = initeng["Mix Engineer"] as? [String] {
                                
                                if new != old {
                                    
                                    let semap = DispatchSemaphore(value: 1)
        //                            DispatchQueue.global(qos: .userInitiated).async { [weak self] in
        //                                guard let strongSelf = self else {return}
                                        var count = 0
                                        for item in new {
                                            if count != 0 {
                                                usleep(100)
                                            }
                                            count+=1
                                            if !old.contains(item) {
                                                strongSelf.updateInstrumentalAlbumInstrumentals(son: item, cat: "Add", completion: {err in
                                                    completedProgress+=1
                                                    if let err = err {
                                                        completion(err)
                                                        return
                                                    } else {
                                                        if completedProgress == (totalProgress) {
                                                            completion(nil)
                                                        }
                                                    }
                                                })
                                            }
                                        }
                                    for item in old {
                                        
                                        if count != 0 {
                                            usleep(100)
                                        }
                                        count+=1
                                        
                                        if !new.contains(item) {
                                            strongSelf.updateInstrumentalAlbumInstrumentals(son: item, cat: "Remove", completion: {err in
                                                completedProgress+=1
                                                if let err = err {
                                                    completion(err)
                                                    return
                                                } else {
                                                    if completedProgress == (totalProgress) {
                                                        completion(nil)
                                                    }
                                                }
                                            })
                                        }
                                        if old.count != 1 {
                                            //semap.wait()
                                        }
                                    }
        //                            }
                                }
                            } else {
                                let semap = DispatchSemaphore(value: 1)
                                let group = DispatchGroup()
        //                        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
        //                            guard let strongSelf = self else {return}
                                    var count = 0
                                    for item in new {
                                        if count != 0 {
                                            usleep(100)
                                        }
                                        count+=1
                                        strongSelf.updateInstrumentalAlbumInstrumentals(son: item, cat: "Add", completion: {err in
                                            completedProgress+=1
                                            if let err = err {
                                                completion(err)
                                                return
                                            } else {
                                                if completedProgress == (totalProgress) {
                                                    completion(nil)
                                                }
                                            }
                                        })
                                        //semap.wait()
                                    }
        //                        }
                            }
                        } else {
                            let semap = DispatchSemaphore(value: 1)
        //                    DispatchQueue.global(qos: .userInitiated).async { [weak self] in
        //                        guard let strongSelf = self else {return}
                                var count = 0
                                for item in new {
                                    if count != 0 {
                                        usleep(100)
                                    }
                                    count+=1
                                    strongSelf.updateInstrumentalAlbumInstrumentals(son: item, cat: "Add", completion: {err in
                                        completedProgress+=1
                                        if let err = err {
                                            completion(err)
                                            return
                                        } else {
                                            if completedProgress == (totalProgress) {
                                                completion(nil)
                                                return
                                            }
                                        }
                                    })
                                }
        //                    }
                        }
                    }
                        else if let inieng = initialeng as? NSDictionary {
                            let initeng = inieng.mutableCopy() as! NSMutableDictionary
                            if let old = initeng["Mix Engineer"] as? [String] {
                                if let new = newengg["Mix Engineer"] as? [String] {
                                    
                                    if new != old {
                                        let semap = DispatchSemaphore(value: 1)
        //                                DispatchQueue.global(qos: .userInitiated).async { [weak self] in
        //                                    guard let strongSelf = self else {return}
                                            var count = 0
                                        for item in old {
                                            if count != 0 {
                                                usleep(100)
                                            }
                                            count+=1
                                            if !new.contains(item) {
                                                strongSelf.updateInstrumentalAlbumInstrumentals(son: item, cat: "Remove", completion: {err in
                                                    completedProgress+=1
                                                    if let err = err {
                                                        completion(err)
                                                        return
                                                    } else {
                                                        if completedProgress == (totalProgress) {
                                                            completion(nil)
                                                            return
                                                        }
                                                    }
                                                })
                                            }
                                            //semap.wait()
                                            }
                                        for item in new {
                                            if count != 0 {
                                                usleep(100)
                                            }
                                            count+=1
                                            if !old.contains(item) {
                                                strongSelf.updateInstrumentalAlbumInstrumentals(son: item, cat: "Add", completion: {err in
                                                    completedProgress+=1
                                                    if let err = err {
                                                        completion(err)
                                                        return
                                                    } else {
                                                        if completedProgress == (totalProgress) {
                                                            completion(nil)
                                                            return
                                                        }
                                                    }
                                                })
                                            }
                                            //semap.wait()
                                            }
        //                                }
                                    }
                                } else {
                                    let semap = DispatchSemaphore(value: 1)
        //                            DispatchQueue.global(qos: .userInitiated).async { [weak self] in
        //                                guard let strongSelf = self else {return}
                                        var count = 0
                                        for item in old {
                                            if count != 0 {
                                                usleep(100)
                                            }
                                            count+=1
                                            strongSelf.updateInstrumentalAlbumInstrumentals(son: item, cat: "Remove", completion: {err in
                                                completedProgress+=1
                                                if let err = err {
                                                    completion(err)
                                                    return
                                                } else {
                                                    if completedProgress == (totalProgress) {
                                                        completion(nil)
                                                        return
                                                    }
                                                }
                                            })
                                            //semap.wait()
                                        }
        //                            }
                                }
                        }
                    }
                        
                        
                        if let new = newengg["Mastering Engineer"] as? [String] {
                            if let inieng = initialeng as? NSDictionary {
                                let initeng = inieng.mutableCopy() as! NSMutableDictionary
                                if let old = initeng["Mastering Engineer"] as? [String] {
                                    let semap = DispatchSemaphore(value: 1)
        //                            DispatchQueue.global(qos: .userInitiated).async { [weak self] in
        //                                guard let strongSelf = self else {return}
                                        var count = 0
                                    if new != old {
                                        for item in new {
                                            if count != 0 {
                                                usleep(100)
                                            }
                                            count+=1
                                            if !old.contains(item) {
                                                strongSelf.updateInstrumentalAlbumInstrumentals(son: item, cat: "Add", completion: {err in
                                                    completedProgress+=1
                                                    if let err = err {
                                                        completion(err)
                                                        return
                                                    } else {
                                                        if completedProgress == (totalProgress) {
                                                            completion(nil)
                                                        }
                                                    }
                                                })
                                            }
                                            if new.count != 1 {
        //                                    //semap.wait()
                                            }
                                        }
                                        for item in old {
                                            if count != 0 {
                                                usleep(100)
                                            }
                                            count+=1
                                            if !new.contains(item) {
                                                //Add PersonTo song artist: song is item
                                                strongSelf.updateInstrumentalAlbumInstrumentals(son: item, cat: "Remove", completion: {err in
                                                    completedProgress+=1
                                                    if let err = err {
                                                        completion(err)
                                                        return
                                                    } else {
                                                        if completedProgress == (totalProgress) {
                                                            completion(nil)
                                                        }
                                                    }
                                                })
                                            }
                                            if old.count != 1 {
        //                                    //semap.wait()
                                            }
                                        }
                                    }
        //                            }
                                } else {
                                    let semap = DispatchSemaphore(value: 1)
                                        var count = 0
                                    for item in new {
                                        if count != 0 {
                                            usleep(100)
                                        }
                                        count+=1
                                        strongSelf.updateInstrumentalAlbumInstrumentals(son: item, cat: "Add", completion: {err in
                                            completedProgress+=1
                                            if let err = err {
                                                completion(err)
                                                return
                                            } else {
                                                if completedProgress == (totalProgress) {
                                                    completion(nil)
                                                }
                                            }
                                        })
                                        //semap.wait()
                                    }
        //                            }
                                }
                            } else {
                                
                                    let semap = DispatchSemaphore(value: 1)
        //                            DispatchQueue.global(qos: .userInitiated).async { [weak self] in
        //                                guard let strongSelf = self else {return}
                                        var count = 0
                                for item in new {
                                    if count != 0 {
                                        usleep(100)
                                    }
                                    count+=1
                                    strongSelf.updateInstrumentalAlbumInstrumentals(son: item, cat: "Add", completion: {err in
                                        completedProgress+=1
                                        if let err = err {
                                            completion(err)
                                            return
                                        } else {
                                            if completedProgress == (totalProgress) {
                                                completion(nil)
                                            }
                                        }
                                    })
                                    //semap.wait()
                                }
        //                        }
                            }
                        }
                        else if let inieng = initialeng as? NSDictionary {
                            let initeng = inieng.mutableCopy() as! NSMutableDictionary
                            if let old = initeng["Mastering Engineer"] as? [String] {
                                if let new = newengg["Mastering Engineer"] as? [String] {
                                    
                                    if new != old {
                                        let semap = DispatchSemaphore(value: 1)
                                        let group = DispatchGroup()
        //                                DispatchQueue.global(qos: .userInitiated).async { [weak self] in
        //                                    guard let strongSelf = self else {return}
                                            var count = 0
                                        for item in old {
                                            if count != 0 {
                                                usleep(100)
                                            }
                                            count+=1
                                            if !new.contains(item) {
                                                strongSelf.updateInstrumentalAlbumInstrumentals(son: item, cat: "Remove", completion: {err in
                                                    completedProgress+=1
                                                    if let err = err {
                                                        completion(err)
                                                        return
                                                    } else {
                                                        if completedProgress == (totalProgress) {
                                                            completion(nil)
                                                            return
                                                        }
                                                    }
                                                })
                                            }
                                            //semap.wait()
                                        }
                                        for item in new {
                                            if count != 0 {
                                                usleep(100)
                                            }
                                            count+=1
                                            if !old.contains(item) {
                                                strongSelf.updateInstrumentalAlbumInstrumentals(son: item, cat: "Add", completion: {err in
                                                    completedProgress+=1
                                                    if let err = err {
                                                        completion(err)
                                                        return
                                                    } else {
                                                        if completedProgress == (totalProgress) {
                                                            completion(nil)
                                                            return
                                                        }
                                                    }
                                                })
                                            }
                                            //semap.wait()
                                        }
        //                                }
                                    }
                                } else {
                                    let semap = DispatchSemaphore(value: 1)
                                    let group = DispatchGroup()
        //                            DispatchQueue.global(qos: .userInitiated).async { [weak self] in
        //                                guard let strongSelf = self else {return}
                                        var count = 0
                                        for item in old {
                                            if count != 0 {
                                                usleep(100)
                                            }
                                            count+=1
                                            strongSelf.updateInstrumentalAlbumInstrumentals(son: item, cat: "Remove", completion: {err in
                                                completedProgress+=1
                                                if let err = err {
                                                    completion(err)
                                                    return
                                                } else {
                                                    if completedProgress == (totalProgress) {
                                                        completion(nil)
                                                        return
                                                    }
                                                }
                                            })
                                            //semap.wait()
                                        }
        //                            }
                                }
                            }
                        }
                    }
                    
                } else if let oldenggg = initialRoles["Engineer"] as? NSDictionary {
                    let oldnegg = oldenggg.mutableCopy() as! NSMutableDictionary
                    if let newengg = ro["Engineer"] as? NSMutableDictionary {
                        if let new = newengg["Mix Engineer"] as? [String] {
                            if let old = initialeng["Mix Engineer"] as? [String] {
                                if new != old {
                                    let semap = DispatchSemaphore(value: 1)
                                    let group = DispatchGroup()
        //                            DispatchQueue.global(qos: .userInitiated).async { [weak self] in
        //                                guard let strongSelf = self else {return}
                                        var count = 0
                                        for item in new {
                                            if count != 0 {
                                                usleep(100)
                                            }
                                            count+=1
                                            if !old.contains(item) {
                                                strongSelf.updateInstrumentalAlbumInstrumentals(son: item, cat: "Add", completion: {err in
                                                    completedProgress+=1
                                                    if let err = err {
                                                        completion(err)
                                                        return
                                                    } else {
                                                        if completedProgress == (totalProgress) {
                                                            completion(nil)
                                                            return
                                                        }
                                                    }
                                                })
                                            }
                                            //semap.wait()
                                        }
                                    for item in old {
                                        if count != 0 {
                                            usleep(100)
                                        }
                                        count+=1
                                        if !new.contains(item) {
                                            strongSelf.updateInstrumentalAlbumInstrumentals(son: item, cat: "Remove", completion: {err in
                                                completedProgress+=1
                                                if let err = err {
                                                    completion(err)
                                                    return
                                                } else {
                                                    if completedProgress == (totalProgress) {
                                                        completion(nil)
                                                        return
                                                    }
                                                }
                                            })
                                        }
                                        //semap.wait()
                                    }
        //                            }
                                }
                            } else {
                                let semap = DispatchSemaphore(value: 1)
                                let group = DispatchGroup()
        //                        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
        //                            guard let strongSelf = self else {return}
                                    var count = 0
                                    for item in new {
                                        if count != 0 {
                                            usleep(100)
                                        }
                                        count+=1
                                        strongSelf.updateInstrumentalAlbumInstrumentals(son: item, cat: "Add", completion: {err in
                                            completedProgress+=1
                                            if let err = err {
                                                completion(err)
                                                return
                                            } else {
                                                if completedProgress == (totalProgress) {
                                                    completion(nil)
                                                    return
                                                }
                                            }
                                        })
                                        //semap.wait()
                                    }
        //                        }
                            }
                        } else if let old = initialeng["Mix Engineer"] as? [String] {
                            if let new = newengg["Mix Engineer"] as? [String] {
                                if new != old {
                                    let semap = DispatchSemaphore(value: 1)
                                    let group = DispatchGroup()
        //                            DispatchQueue.global(qos: .userInitiated).async { [weak self] in
        //                                guard let strongSelf = self else {return}
                                        var count = 0
                                        for item in old {
                                            if count != 0 {
                                                usleep(100)
                                            }
                                            count+=1
                                            if !new.contains(item) {
                                                strongSelf.updateInstrumentalAlbumInstrumentals(son: item, cat: "Remove", completion: {err in
                                                    completedProgress+=1
                                                    if let err = err {
                                                        completion(err)
                                                        return
                                                    } else {
                                                        if completedProgress == (totalProgress) {
                                                            completion(nil)
                                                            return
                                                        }
                                                    }
                                                })
                                            }
                                            //semap.wait()
                                        }
                                    for item in new {
                                        if count != 0 {
                                            usleep(100)
                                        }
                                        count+=1
                                        if !old.contains(item) {
                                            strongSelf.updateInstrumentalAlbumInstrumentals(son: item, cat: "Add", completion: {err in
                                                completedProgress+=1
                                                if let err = err {
                                                    completion(err)
                                                    return
                                                } else {
                                                    if completedProgress == (totalProgress) {
                                                        completion(nil)
                                                        return
                                                    }
                                                }
                                            })
                                        }
                                        //semap.wait()
                                    }
        //                            }
                                }
                            } else {
                                let semap = DispatchSemaphore(value: 1)
                                let group = DispatchGroup()
        //                        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
        //                            guard let strongSelf = self else {return}
                                    var count = 0
                                    for item in old {
                                        if count != 0 {
                                            usleep(100)
                                        }
                                        count+=1
                                        strongSelf.updateInstrumentalAlbumInstrumentals(son: item, cat: "Remove", completion: {err in
                                            completedProgress+=1
                                            if let err = err {
                                                completion(err)
                                                return
                                            } else {
                                                if completedProgress == (totalProgress) {
                                                    completion(nil)
                                                    return
                                                }
                                            }
                                        })
                                        //semap.wait()
                                    }
        //                        }
                            }
                        }
                        if let new = newengg["Mastering Engineer"] as? [String] {
                            
                            if let old = initialeng["Mastering Engineer"] as? [String] {
                                if new != old {
                                    let semap = DispatchSemaphore(value: 1)
        //                            DispatchQueue.global(qos: .userInitiated).async { [weak self] in
        //                                guard let strongSelf = self else {return}
                                        var count = 0
                                        for item in new {
                                            if count != 0 {
                                                usleep(100)
                                            }
                                            count+=1
                                            if !old.contains(item) {
                                                strongSelf.updateInstrumentalAlbumInstrumentals(son: item, cat: "Add", completion: {err in
                                                    completedProgress+=1
                                                    if let err = err {
                                                        completion(err)
                                                        return
                                                    } else {
                                                        if completedProgress == (totalProgress) {
                                                            completion(nil)
                                                            return
                                                        }
                                                    }
                                                })
                                            }
                                            //semap.wait()
                                        }
                                    for item in old {
                                        if count != 0 {
                                            usleep(100)
                                        }
                                        count+=1
                                        if !new.contains(item) {
                                            strongSelf.updateInstrumentalAlbumInstrumentals(son: item, cat: "Remove", completion: {err in
                                                completedProgress+=1
                                                if let err = err {
                                                    completion(err)
                                                    return
                                                } else {
                                                    if completedProgress == (totalProgress) {
                                                        completion(nil)
                                                        return
                                                    }
                                                }
                                            })
                                        }
                                        //semap.wait()
                                    }
        //                            }
                                }
                            } else {
                                let semap = DispatchSemaphore(value: 1)
        //                        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
        //                            guard let strongSelf = self else {return}
                                    var count = 0
                                    for item in new {
                                        if count != 0 {
                                            usleep(100)
                                        }
                                        count+=1
                                        strongSelf.updateInstrumentalAlbumInstrumentals(son: item, cat: "Add", completion: {err in
                                            completedProgress+=1
                                            if let err = err {
                                                completion(err)
                                                return
                                            } else {
                                                if completedProgress == (totalProgress) {
                                                    completion(nil)
                                                    return
                                                }
                                            }
                                        })
                                        //semap.wait()
                                    }
        //                        }
                            }
                        } else if let old = initialeng["Mastering Engineer"] as? [String] {
                            if let new = newengg["Mastering Engineer"] as? [String] {
                                if new != old {
                                    let semap = DispatchSemaphore(value: 1)
                                    let group = DispatchGroup()
        //                            DispatchQueue.global(qos: .userInitiated).async { [weak self] in
        //                                guard let strongSelf = self else {return}
                                        var count = 0
                                        for item in old {
                                            if count != 0 {
                                                usleep(100)
                                            }
                                            count+=1
                                            if !new.contains(item) {
                                                strongSelf.updateInstrumentalAlbumInstrumentals(son: item, cat: "Remove", completion: {err in
                                                    completedProgress+=1
                                                    if let err = err {
                                                        completion(err)
                                                        return
                                                    } else {
                                                        if completedProgress == (totalProgress) {
                                                            completion(nil)
                                                            return
                                                        }
                                                    }
                                                })
                                            }
                                            //semap.wait()
                                        }
                                    for item in new {
                                        if count != 0 {
                                            usleep(100)
                                        }
                                        count+=1
                                        if !old.contains(item) {
                                            strongSelf.updateInstrumentalAlbumInstrumentals(son: item, cat: "Add", completion: {err in
                                                completedProgress+=1
                                                if let err = err {
                                                    completion(err)
                                                    return
                                                } else {
                                                    if completedProgress == (totalProgress) {
                                                        completion(nil)
                                                        return
                                                    }
                                                }
                                            })
                                        }
                                        //semap.wait()
                                    }
        //                            }
                                }
                            } else {
                                let semap = DispatchSemaphore(value: 1)
                                let group = DispatchGroup()
        //                        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
        //                            guard let strongSelf = self else {return}
                                    var count = 0
                                    for item in old {
                                        if count != 0 {
                                            usleep(100)
                                        }
                                        count+=1
                                        strongSelf.updateInstrumentalAlbumInstrumentals(son: item, cat: "Remove", completion: {err in
                                            completedProgress+=1
                                            if let err = err {
                                                completion(err)
                                                return
                                            } else {
                                                if completedProgress == (totalProgress) {
                                                    completion(nil)
                                                    return
                                                }
                                            }
                                        })
                                        //semap.wait()
                                    }
        //                        }
                            }
                        }
                    } else {
                        if let old = oldenggg["Mix Engineer"] as? [String] {
                            let semap = DispatchSemaphore(value: 1)
                            let group = DispatchGroup()
        //                    DispatchQueue.global(qos: .userInitiated).async { [weak self] in
        //                        guard let strongSelf = self else {return}
                                var count = 0
                                for item in old {
                                    strongSelf.updateInstrumentalAlbumInstrumentals(son: item, cat: "Remove", completion: {err in
                                        completedProgress+=1
                                        if let err = err {
                                            completion(err)
                                            return
                                        } else {
                                            if completedProgress == (totalProgress) {
                                                completion(nil)
                                                return
                                            }
                                        }
                                    })
                                    //semap.wait()
                                }
        //                    }
                        }
                        if let old = oldenggg["Mastering Engineer"] as? [String] {
                            let semap = DispatchSemaphore(value: 1)
                            let group = DispatchGroup()
        //                    DispatchQueue.global(qos: .userInitiated).async { [weak self] in
        //                        guard let strongSelf = self else {return}
                                var count = 0
                                for item in old {
                                    if count != 0 {
                                        usleep(100)
                                    }
                                    count+=1
                                    strongSelf.updateInstrumentalAlbumInstrumentals(son: item, cat: "Remove", completion: {err in
                                        completedProgress+=1
                                        if let err = err {
                                            completion(err)
                                            return
                                        } else {
                                            if completedProgress == (totalProgress) {
                                                completion(nil)
                                                return
                                            }
                                        }
                                    })
                                    //semap.wait()
                                }
        //                    }
                        }
                    }
                }
                if let new = ro["Videographer"] as? [String] {
                    if completedProgress == (totalProgress) {
                        completion(nil)
                        return
                    }
                } else if let old = initialRoles["Videographer"] as? [String] {
                    if completedProgress == (totalProgress) {
                        completion(nil)
                        return
                    }
                }
            }
            else {
                if let arr = initialRoles["Artist"] as? [String] {
                    let semap = DispatchSemaphore(value: 1)
                    let group = DispatchGroup()
                    //                    DispatchQueue.global(qos: .userInitiated).async { [weak self] in
                    //                        guard let strongSelf = self else {return}
                    var count = 0
                    for songg in arr {
                        if count != 0 {
                            usleep(100)
                        }
                        count+=1
                        //If the a song is on an album, go to the album in database and remove the person from the albums 'All Artist' node
                        strongSelf.updateInstrumentalAlbumInstrumentals(son: songg, cat: "Remove", completion: {err in
                            completedProgress+=1
                            if let err = err {
                                completion(err)
                                return
                            } else {
                                if completedProgress == (totalProgress) {
                                    completion(nil)
                                    return
                                }
                            }
                        })
                    }
                }
                if let arr = initialRoles["Producer"] as? [String] {
                    let semap = DispatchSemaphore(value: 1)
                    let group = DispatchGroup()
                    //                DispatchQueue.global(qos: .userInitiated).async { [weak self] in
                    //                    guard let strongSelf = self else {return}
                    var count = 0
                    var completioncount = 0
                    for songg in arr {
                        if count != 0 {
                            usleep(100)
                        }
                        count+=1
                        strongSelf.updateInstrumentalAlbumInstrumentals(son: songg, cat: "Remove", completion: {err in
                            completedProgress+=1
                            if let err = err {
                                completion(err)
                                return
                            } else {
                                if completedProgress == (totalProgress) {
                                    completion(nil)
                                    return
                                }
                            }
                        })
                        //semap.wait()
                    }
                    //                }
                }
                if let engg = initialRoles["Engineer"] as? NSMutableDictionary {
                    if let arr = engg["Mix Engineer"] as? [String] {
                        let semap = DispatchSemaphore(value: 1)
                        let group = DispatchGroup()
                        //                    DispatchQueue.global(qos: .userInitiated).async { [weak self] in
                        //                        guard let strongSelf = self else {return}
                        var count = 0
                        var completioncount = 0
                        for songg in arr {
                            if count != 0 {
                                usleep(100)
                            }
                            count+=1
                            strongSelf.updateInstrumentalAlbumInstrumentals(son: songg, cat: "Remove", completion: {err in
                                completedProgress+=1
                                if let err = err {
                                    completion(err)
                                    return
                                } else {
                                    if completedProgress == (totalProgress) {
                                        completion(nil)
                                        return
                                    }
                                }
                            })
                            //semap.wait()
                        }
                        //                    }
                    }
                    if let arr = engg["Mastering Engineer"] as? [String] {
                        let semap = DispatchSemaphore(value: 1)
                        let group = DispatchGroup()
                        //                    DispatchQueue.global(qos: .userInitiated).async { [weak self] in
                        //                        guard let strongSelf = self else {return}
                        var count = 0
                        var completioncount = 0
                        for songg in arr {
                            if count != 0 {
                                usleep(100)
                            }
                            count+=1
                            strongSelf.updateInstrumentalAlbumInstrumentals(son: songg, cat: "Remove", completion: {err in
                                completedProgress+=1
                                if let err = err {
                                    completion(err)
                                    return
                                } else {
                                    if completedProgress == (totalProgress) {
                                        completion(nil)
                                        return
                                    }
                                }
                            })
                            //semap.wait()
                        }
                        //                    }
                    }
                    
                }
                if let arr = initialRoles["Videographer"] as? [String] {
                    if completedProgress == (totalProgress) {
                        completion(nil)
                        return
                    }
                }
            }
        })
    }
    
    func updateInstrumentalAlbumInstrumentals(son: String, cat:String, completion: @escaping ((Error?) -> Void)) {
        guard son.count == 12 else {
            completion(nil)
            return
        }
        DatabaseManager.shared.findInstrumentalById(instrumentalId:son, completion: {[weak self] result in
            guard let strongSelf = self else {return}
            switch result {
            case .success(let song):
//                print(String(data: try! JSONSerialization.data(withJSONObject: update, options: .prettyPrinted), encoding: .utf8)!)
                if var alb = song.albums {
                    if !alb.isEmpty {
                        if cat == "Add" {
                            
//                            if let songAlbums = song.albums {
//                                alb = Array(GlobalFunctions.shared.combine(alb,songAlbums))
//                                strongSelf.currRef.child("Albums").setValue(alb)
//                            }
                            var count = 0
                            for album in alb {
                                strongSelf.updateInstrumentalAlbumInstrumentalsAdd(son: son, alb: album, completion: { error in
                                    count+=1
                                    if let error = error {
                                        completion(error)
                                        return
                                    }
                                    else {
                                        if count == alb.count {
                                            completion(nil)
                                            return
                                        }
                                    }
                                })
                            }
                        } else {
                            var count = 0
                            for album in alb {
                                strongSelf.updateInstrumentalAlbumInstrumentalsRemove(son: son, alb: album, completion: { error in
                                    count+=1
                                    if let error = error {
                                        completion(error)
                                        return
                                    }
                                    else {
                                        var initAlbCount = alb.count
//                                        if strongSelf.initPerson.albums != strongSelf.currPerson.albums {
//                                            if let songAlbums = song.albums {
//                                                for al in songAlbums {
//                                                    let index = alb.firstIndex(of: al)
//                                                    alb.remove(at: index!)
//                                                }
//                                                strongSelf.currRef.child("Albums").setValue(alb)
//                                            }
//                                        }
//                                        if count == initAlbCount{
                                            completion(nil)
                                            return
//                                        }
                                    }
                                })
                            }
                        }
                    } else {
                        completion(nil)
                        return
                    }
                } else {
                    completion(nil)
                    return
                }
            case .failure(let err):
                print("dsvgredfxbdfzx"+err.localizedDescription)
            }
        })
    }
    
    func updateInstrumentalAlbumInstrumentalsAdd(son: String, alb:String, completion: @escaping ((Error?) -> Void)) {
        guard son.count == 8 else {
            completion(nil)
            return
        }
        let word = alb.split(separator: "Æ")
        let id = word[0]
        DatabaseManager.shared.findAlbumById(albumId: String(id), completion: {[weak self] result in
            guard let strongSelf = self else {return}
            switch result {
            case .success(let album):
                let key = "\(albumContentTag)--\(album.name)--\(album.toneDeafAppId)"
                let ref = Database.database().reference().child("Music Content").child("Albums").child(key).child("REQUIRED")
                
                var loadArr:[String]!
                let update:NSMutableDictionary = [:]
                if let curRo = strongSelf.currPerson.roles {
                    if let arr = curRo["Artist"] as? [String] {
                        if arr.contains(son) {
                            if let allArt = album.allArtists {
                                loadArr = allArt
                                if !loadArr.contains(strongSelf.currPerson.toneDeafAppId) {
                                    loadArr.append(strongSelf.currPerson.toneDeafAppId)
                                }
                            } else {
                                loadArr = [strongSelf.currPerson.toneDeafAppId]
                            }
                            update["All Artist"] = loadArr
                        }
                    }
                    if let arr = curRo["Producer"] as? [String] {
                        if arr.contains(son) {
                            loadArr = album.producers
                            if !loadArr.contains(strongSelf.currPerson.toneDeafAppId) {
                                loadArr.append(strongSelf.currPerson.toneDeafAppId)
                            }
                        } else {
                            loadArr = [strongSelf.currPerson.toneDeafAppId]
                        }
                        update["All Producers"] = loadArr
                    }
                    if let arr = curRo["Writer"] as? [String] {
                        if arr.contains(son) {
                            if let allArt = album.writers {
                                loadArr = allArt
                                if !loadArr.contains(strongSelf.currPerson.toneDeafAppId) {
                                    loadArr.append(strongSelf.currPerson.toneDeafAppId)
                                }
                            } else {
                                loadArr = [strongSelf.currPerson.toneDeafAppId]
                            }
                            update["All Writers"] = loadArr
                        }
                    }
                    if let earr = curRo["Engineer"] as? NSMutableDictionary {
                        let engies:NSMutableDictionary = [:]
                        if let arr = earr["Mix Engineer"] as? [String] {
                            if arr.contains(son) {
                                if let allArt = album.mixEngineers {
                                    loadArr = allArt
                                    if !loadArr.contains(strongSelf.currPerson.toneDeafAppId) {
                                        loadArr.append(strongSelf.currPerson.toneDeafAppId)
                                    }
                                } else {
                                    loadArr = [strongSelf.currPerson.toneDeafAppId]
                                }
                                engies["Mix Engineer"] = loadArr
                            }
                        }
                        if let arr = earr["Mastering Engineer"] as? [String] {
                            if arr.contains(son) {
                                if let allArt = album.masteringEngineers {
                                    loadArr = allArt
                                    if !loadArr.contains(strongSelf.currPerson.toneDeafAppId) {
                                        loadArr.append(strongSelf.currPerson.toneDeafAppId)
                                    }
                                } else {
                                    loadArr = [strongSelf.currPerson.toneDeafAppId]
                                }
                                engies["Mastering Engineer"] = loadArr
                            }
                        }
                        if let arr = earr["Recording Engineer"] as? [String] {
                            if arr.contains(son) {
                                if let allArt = album.recordingEngineers {
                                    loadArr = allArt
                                    if !loadArr.contains(strongSelf.currPerson.toneDeafAppId) {
                                        loadArr.append(strongSelf.currPerson.toneDeafAppId)
                                    }
                                } else {
                                    loadArr = [strongSelf.currPerson.toneDeafAppId]
                                }
                                engies["Recording Engineer"] = loadArr
                            }
                        }
                        update["Engineers"] = engies
                    }
                }
                
                ref.updateChildValues(update as! [AnyHashable : Any], withCompletionBlock: { error, reference in
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
    
    func updateInstrumentalAlbumInstrumentalsRemove(son: String, alb:String, completion: @escaping ((Error?) -> Void)) {
        guard son.count == 8 else {
            completion(nil)
            return
        }
        let word = alb.split(separator: "Æ")
        let id = word[0]
        DatabaseManager.shared.findAlbumById(albumId: String(id), completion: {[weak self] result in
            guard let strongSelf = self else {return}
            switch result {
            case .success(let album):
                var count = 0
                if let albsongs = album.instrumentals {
                    for songg in albsongs {
                        if songg != son {
                            //Check to see if artist is on another song in album
                            DatabaseManager.shared.findInstrumentalById(instrumentalId: songg, completion: { result in
                                switch result {
                                case .success(let fsong):
                                    count+=1
                                    if count == albsongs.count {
                                        let key = "\(albumContentTag)--\(album.name)--\(album.toneDeafAppId)"
                                        let ref = Database.database().reference().child("Music Content").child("Albums").child(key).child("REQUIRED")
                                        var update:NSMutableDictionary = [:]
                                        
                                        if let arr = fsong.artist as? [String] {
                                            if !arr.contains(strongSelf.currPerson.toneDeafAppId) {
                                                if var allArt = album.allArtists {
                                                    let index = allArt.firstIndex(of: strongSelf.currPerson.toneDeafAppId)
                                                    allArt.remove(at: index!)
                                                    update["All Artist"] = allArt.sorted()
                                                }
                                            }
                                        }
                                        if !fsong.producers.contains(strongSelf.currPerson.toneDeafAppId) {
                                            var allP = album.producers
                                            let index = allP.firstIndex(of: strongSelf.currPerson.toneDeafAppId)
                                            allP.remove(at: index!)
                                            update["All Producers"] = allP.sorted()
                                        }
                                        var engies:NSMutableDictionary = [:]
                                        if let arr = fsong.mixEngineer as? [String] {
                                            if !arr.contains(strongSelf.currPerson.toneDeafAppId) {
                                                if var allArt = album.mixEngineers {
                                                    let index = allArt.firstIndex(of: strongSelf.currPerson.toneDeafAppId)
                                                    allArt.remove(at: index!)
                                                    update["Mix Engineer"] = allArt.sorted()
                                                }
                                            }
                                        }
                                        if let arr = fsong.masteringEngineer as? [String] {
                                            if !arr.contains(strongSelf.currPerson.toneDeafAppId) {
                                                if var allArt = album.masteringEngineers {
                                                    let index = allArt.firstIndex(of: strongSelf.currPerson.toneDeafAppId)
                                                    allArt.remove(at: index!)
                                                    update["Mastering Engineer"] = allArt.sorted()
                                                }
                                            }
                                        }
                                        update["Engineers"] = engies
                                        ref.updateChildValues(update as! [AnyHashable : Any], withCompletionBlock: { error, reference in
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
                                case .failure(let err):
                                    print("dsvgredfxbdfzx"+err.localizedDescription)
                                }
                                
                            })
                        }
                        else {
                            count+=1
                            if count == albsongs.count {
                                let key = "\(albumContentTag)--\(album.name)--\(album.toneDeafAppId)"
                                let ref = Database.database().reference().child("Music Content").child("Albums").child(key).child("REQUIRED")
                                var update:NSMutableDictionary = [:]
                                if var allArt = album.allArtists {
                                    if let index = allArt.firstIndex(of: strongSelf.currPerson.toneDeafAppId) {
                                        allArt.remove(at: index)
                                        update["All Artist"] = allArt.sorted()
                                    }
                                }
                                var allP = album.producers
                                if let index = allP.firstIndex(of: strongSelf.currPerson.toneDeafAppId) {
                                    allP.remove(at: index)
                                    update["All Producers"] = allP.sorted()
                                }
                                if var allArt = album.writers {
                                    if let index = allArt.firstIndex(of: strongSelf.currPerson.toneDeafAppId) {
                                        allArt.remove(at: index)
                                        update["All Writers"] = allArt.sorted()
                                    }
                                }
                                var engies:NSMutableDictionary = [:]
                                if var allArt = album.mixEngineers {
                                    if let index = allArt.firstIndex(of: strongSelf.currPerson.toneDeafAppId) {
                                        allArt.remove(at: index)
                                        update["Mix Engineer"] = allArt.sorted()
                                    }
                                }
                                if var allArt = album.masteringEngineers {
                                    if let index = allArt.firstIndex(of: strongSelf.currPerson.toneDeafAppId) {
                                        allArt.remove(at: index)
                                        update["Mastering Engineer"] = allArt.sorted()
                                    }
                                }
                                if var allArt = album.recordingEngineers {
                                    if let index = allArt.firstIndex(of: strongSelf.currPerson.toneDeafAppId) {
                                        allArt.remove(at: index)
                                        update["Recording Engineer"] = allArt.sorted()
                                    }
                                }
                                update["Engineers"] = engies
                                ref.updateChildValues(update as! [AnyHashable : Any], withCompletionBlock: { error, reference in
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
                    }
                }
                else {
                    completion(nil)
                }
            case .failure(let err):
                print("dsvgredfxbdfzx"+err.localizedDescription)
            }
        })
        
    }
    
    //MARK: - Beats
    func processBeats(initialPerson: PersonData, currentPerson: PersonData, completion: @escaping (([Error]?) -> Void)) {
        initPerson = initialPerson
        currPerson = currentPerson
        
        if currPerson.beats == nil {
            currPerson.beats = []
        }
        
        var errors:[Error] = []
        initRef = Database.database().reference().child("Registered Persons").child("\(initPerson.name!)--\(initPerson.dateRegisteredToApp!)--\(initPerson.timeRegisteredToApp!)--\(initPerson.toneDeafAppId)")
        currRef = Database.database().reference().child("Registered Persons").child("\(currPerson.name!)--\(currPerson.dateRegisteredToApp!)--\(currPerson.timeRegisteredToApp!)--\(currPerson.toneDeafAppId)")
        
        var dataUploadCompletionStatus1:Bool!
        var dataUploadCompletionStatus2:Bool!
        var dataUploadCompletionStatus3:Bool!
        var dataUploadCompletionStatus4:Bool!
        let queue = DispatchQueue(label: "myhjvkheditingQpersonsBeatssseue")
        let group = DispatchGroup()
        let array:[Int] = [1,2]
        for i in array {
            group.enter()
            queue.async { [weak self] in
                guard let strongSelf = self else {return}
                switch i {
                case 1:
                    strongSelf.updatePersonBeats(ref: strongSelf.currRef, completion: {err in
                        if let error = err {
                            dataUploadCompletionStatus1 = false
                            errors.append(error)
                        } else {
                            dataUploadCompletionStatus1 = true
                            print("Person Beats update done \(i)")
                        }
                        group.leave()
                    })
                case 2:
                    DispatchQueue.global(qos: .userInitiated).async { [weak self] in
                        guard let strongSelf = self else {return}
                        strongSelf.updateBeatProducers(ref: strongSelf.currRef, completion: {err in
                            if let error = err {
                                print("aww shucks")
                                dataUploadCompletionStatus2 = false
                                errors.append(error)
                            } else {
                                dataUploadCompletionStatus2 = true
                                print("Beat Producers update done \(i)")
                            }
                            group.leave()
                        })
                    }
                default:
                    print("Edit Person error")
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
    
    func updatePersonBeats(ref: DatabaseReference, completion: @escaping ((Error?) -> Void)) {
        var initialVideoArrFromDB:[String]!
        if initPerson.beats == currPerson.beats {
            completion(nil)
            return
        }
        getPersonBeatsInDB(ref: ref, completion: {[weak self] beats in
            guard let strongSelf = self else {return}
            initialVideoArrFromDB = beats
            
            if !initialVideoArrFromDB.isEmpty {
                var removalCounter = 0
                for i in 0 ... initialVideoArrFromDB.count-1 {
                    if let curralb = strongSelf.currPerson.beats as? [String] {
                        if i < curralb.count {
                            if !curralb[i].contains(initialVideoArrFromDB[i]) {
                                let index = initialVideoArrFromDB.firstIndex(of: initialVideoArrFromDB[i])
                                initialVideoArrFromDB.remove(at: index!)
                                removalCounter+=1
                            }
                        } else {
                            let index = initialVideoArrFromDB.firstIndex(of: initialVideoArrFromDB[i-removalCounter])
                            initialVideoArrFromDB.remove(at: index!)
                            removalCounter+=1
                        }
                    } else {
                        let index = initialVideoArrFromDB.firstIndex(of: initialVideoArrFromDB[i-removalCounter])
                        initialVideoArrFromDB.remove(at: index!)
                        removalCounter+=1
                    }
                }
            }
            if let curralb = strongSelf.currPerson.beats as? [String] {
                if !curralb.isEmpty {
                    for i in 0 ... curralb.count-1 {
                        if i < initialVideoArrFromDB.count {
                            if !initialVideoArrFromDB[i].contains(strongSelf.currPerson.beats![i]) {
                                initialVideoArrFromDB.append(strongSelf.currPerson.beats![i])
                            }
                        } else {
                            initialVideoArrFromDB.append(strongSelf.currPerson.beats![i])
                        }
                    }
                }
            }
            ref.child("Beats").setValue(initialVideoArrFromDB.sorted(), withCompletionBlock: { error, reference in
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
    
    func getPersonBeatsInDB(ref: DatabaseReference, completion: @escaping (([String]) -> Void)) {
        ref.child("Beats").observeSingleEvent(of: .value, with: { snapshot in
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
    
    func updateBeatProducers(ref: DatabaseReference, completion: @escaping ((Error?) -> Void)) {
        var initialVideoArrFromDB:[String]!
        if initPerson.beats == currPerson.beats {
            completion(nil)
            return
        }
        initialVideoArrFromDB = initPerson.beats
        if initialVideoArrFromDB == nil {
            initialVideoArrFromDB = []
        }
        
        if let _ = initialVideoArrFromDB as? [String] {
            if !initialVideoArrFromDB.isEmpty {
                var removalCounter = 0
                var completioncount = 0
                for i in 0 ... initialVideoArrFromDB.count-1 {
                    if let curralb = currPerson.beats as? [String] {
                        if i < curralb.count {
                            if !curralb[i].contains(initialVideoArrFromDB[i]) {
                                removePersonFromBeatInDB(son: initialVideoArrFromDB[i], cat: "Producer", completion: {err in
                                    completioncount+=1
                                    if let err = err {
                                        completion(err)
                                        return
                                    } else {
                                        if completioncount == (curralb.count+initialVideoArrFromDB.count) {
                                            completion(nil)
                                        }
                                    }
                                    
                                })
                            } else {
                                completioncount+=1
                                if completioncount == (curralb.count+initialVideoArrFromDB.count) {
                                    completion(nil)
                                }
                            }
                        } else {
                            removePersonFromBeatInDB(son: initialVideoArrFromDB[i], cat: "Producer", completion: {err in
                                completioncount+=1
                                if let err = err {
                                    completion(err)
                                    return
                                } else {
                                    if completioncount == (curralb.count+initialVideoArrFromDB.count) {
                                        completion(nil)
                                    }
                                }
                                
                            })
                        }
                    } else {
                        removePersonFromBeatInDB(son: initialVideoArrFromDB[i], cat: "Producer", completion: {err in
                            completioncount+=1
                            if let err = err {
                                completion(err)
                                return
                            } else {
                                if completioncount == (initialVideoArrFromDB.count) {
                                    completion(nil)
                                }
                            }
                            
                        })
                    }
                }
            }
        }
        if let curralb = currPerson.beats as? [String] {
            var completioncount = 0
            if !curralb.isEmpty {
                for i in 0 ... curralb.count-1 {
                    if i < initialVideoArrFromDB.count {
                        if !initialVideoArrFromDB[i].contains(currPerson.beats![i]) {
                            addPersonToBeatInDB(son: currPerson.beats![i], cat: "Producer", completion: {err in
                                completioncount+=1
                                if let err = err {
                                    completion(err)
                                    return
                                } else {
                                    if completioncount == (curralb.count+initialVideoArrFromDB.count) {
                                        completion(nil)
                                    }
                                }
                                
                            })
                        } else {
                            completioncount+=1
                            if completioncount == (curralb.count+initialVideoArrFromDB.count) {
                                completion(nil)
                            }
                        }
                    } else {
                        addPersonToBeatInDB(son: currPerson.beats![i], cat: "Producer", completion: {err in
                            completioncount+=1
                            if let err = err {
                                completion(err)
                                return
                            } else {
                                if completioncount == (curralb.count+initialVideoArrFromDB.count) {
                                    completion(nil)
                                }
                            }
                            
                        })
                    }
                }
            } else {
                completioncount+=1
                if completioncount == (curralb.count+initialVideoArrFromDB.count) {
                    completion(nil)
                }
            }
        }
    }
    
    func addPersonToBeatInDB(son: String, cat:String, completion: @escaping ((Error?) -> Void)) {
        guard son.count == 14 else {
            completion(nil)
            return
        }
        
        DatabaseManager.shared.findBeatById(beatId: son, completion: {[weak self] result in
            guard let strongSelf = self else {return}
            switch result {
            case .success(let beat):
                let person = "\(strongSelf.currPerson.toneDeafAppId)"
                var ref = Database.database().reference().child("Beats").child( "\(beatContentTag)--\(beat.name)--\(beat.toneDeafAppId)")
                var arrto:[String]!
                switch cat {
                case "Producer":
                    if var arrrrrrr = beat.producers as? [String] {
                        if !arrrrrrr.contains(person) {
                            arrrrrrr.append(person)
                            beat.producers = arrrrrrr.sorted()
                        }
                    } else {
                        beat.producers = [person]
                    }
                    arrto = beat.producers
                    ref = ref.child("Producers")
                    strongSelf.setValueArray(ref: ref, arrto: arrto, completion: { err in
                        if let err = err {
                            print("dsgsrdgvdz z av "+err.localizedDescription)
                        } else {
                            completion(nil)
                        }
                    })
                default:
                    break
                }
                    
            case .failure(let err):
                print("dsvgredfxbdfzx"+err.localizedDescription)
            }
        })
    }
    
    func removePersonFromBeatInDB(son: String, cat:String, completion: @escaping ((Error?) -> Void)) {
        guard son.count == 14 else {
            completion(nil)
            return
        }
        DatabaseManager.shared.findBeatById(beatId: son, completion: {[weak self] result in
            guard let strongSelf = self else {return}
            switch result {
            case .success(let beat):
                let person = "\(strongSelf.currPerson.toneDeafAppId)"
                var ref = Database.database().reference().child("Beats").child( "\(beatContentTag)--\(beat.name)--\(beat.toneDeafAppId)")
                var arrto:[String]!
                switch cat {
                case "Producer":
                    if var arrrrrrr = beat.producers as? [String]{
                        if let index = arrrrrrr.firstIndex(of: person) {
                            arrrrrrr.remove(at: index)
                        }
                        beat.producers = arrrrrrr
                        arrto = beat.producers
                        ref = ref.child("Producers")
                        strongSelf.setValueArray(ref: ref, arrto: arrto, completion: { err in
                            if let err = err {
                                print("dsgsrdgvdz z av "+err.localizedDescription)
                            } else {
                                completion(nil)
                            }
                        })
                    } else {
                        completion(nil)
                    }
                default:
                    break
                }
            case .failure(let err):
                print("dsvgredfxbdfzx"+err.localizedDescription)
            }
        })
    }
    
    //MARK: - Verification Level
    func processVerificationLevel(initialPerson: PersonData, currentPerson: PersonData, completion: @escaping ((Error?) -> Void)) {
        initPerson = initialPerson
        currPerson = currentPerson
        let ref = Database.database().reference().child("Registered Persons").child("\(currPerson.name!)--\(currPerson.dateRegisteredToApp!)--\(currPerson.timeRegisteredToApp!)--\(currPerson.toneDeafAppId)").child("Verification Level")
        ref.setValue(String(currPerson.verificationLevel!), withCompletionBlock: { error, reference in
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
    func processIndustryCertification(initialPerson: PersonData, currentPerson: PersonData, completion: @escaping ((Error?) -> Void)) {
        initPerson = initialPerson
        currPerson = currentPerson
        let ref = Database.database().reference().child("Registered Persons").child("\(currPerson.name!)--\(currPerson.dateRegisteredToApp!)--\(currPerson.timeRegisteredToApp!)--\(currPerson.toneDeafAppId)").child("Industry Certified")
        ref.setValue(currPerson.industryCerified!, withCompletionBlock: { error, reference in
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
    func processStatus(initialPerson: PersonData, currentPerson: PersonData, completion: @escaping ((Error?) -> Void)) {
        initPerson = initialPerson
        currPerson = currentPerson
        let ref = Database.database().reference().child("Registered Persons").child("\(currPerson.name!)--\(currPerson.dateRegisteredToApp!)--\(currPerson.timeRegisteredToApp!)--\(currPerson.toneDeafAppId)").child("Active Status")
        ref.setValue(currPerson.isActive, withCompletionBlock: { error, reference in
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
    func cancelUpdate(initialPerson: PersonData, currentPerson: PersonData, initialStatus:NSDictionary, currentStatus:NSDictionary, initialURL:NSDictionary, currentURL:NSDictionary, completion: @escaping (([Error]?) -> Void)) {
        currPerson = currentPerson
        currURLDict = currentURL
        currStatusDict = currentStatus
        initPerson = initialPerson
        initURLDict = initialURL
        initStatusDict = initialStatus
        
        var errors:[Error] = []
        initRef = Database.database().reference().child("Registered Persons").child("\(initPerson.name!)--\(initPerson.dateRegisteredToApp!)--\(initPerson.timeRegisteredToApp!)--\(initPerson.toneDeafAppId)")
        currRef = Database.database().reference().child("Registered Persons").child("\(currPerson.name!)--\(currPerson.dateRegisteredToApp!)--\(currPerson.timeRegisteredToApp!)--\(currPerson.toneDeafAppId)")
        
        var dataUploadCompletionStatus1:Bool!
        var dataUploadCompletionStatus2:Bool!
        var dataUploadCompletionStatus3:Bool!
        var dataUploadCompletionStatus4:Bool!
        let queue = DispatchQueue(label: "myhjvkheditingQpersonsCancelssseue")
        let group = DispatchGroup()
        var array:[Int] = []
        if currRef != initRef {
//            array.append(1)
        }
        if currentPerson.manualImageURL != initialPerson.manualImageURL || initImage != currImage {
            array.append(2)
        }
        if currPerson.legalName != initPerson.legalName {
            array.append(4)
        }
        if currPerson.legalName != initPerson.legalName {
            array.append(4)
        }
        if currPerson.alternateNames != initPerson.alternateNames {
            array.append(5)
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
                case 4:
                    strongSelf.revertLegalName(completion: {err in
                        if let error = err {
                            dataUploadCompletionStatus4 = false
                            errors.append(error)
                        } else {
                            dataUploadCompletionStatus4 = true
                            print("Legal Name revert done \(i)")
                        }
                        group.leave()
                    })
                case 5:
                    strongSelf.revertLegalName(completion: {err in
                        if let error = err {
                            dataUploadCompletionStatus3 = false
                            errors.append(error)
                        } else {
                            dataUploadCompletionStatus3 = true
                            print("Alternate Names revert done \(i)")
                        }
                        group.leave()
                    })
                default:
                    print("Edit Person error")
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
        initRef.child("Manual Image URL").setValue(initPerson.manualImageURL, withCompletionBlock: { error, reference in
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
    
    
    //MARK: - Revert Name
    func revertName() {
        
    }
    
    //MARK: - Revert Legal Name
    func revertLegalName(completion: @escaping ((Error?) -> Void)) {
        initRef.child("Legal Name").setValue(initPerson.legalName, withCompletionBlock: { error, reference in
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
    
    //MARK: - Revert Alternate Names
    func revertAlternateNames(completion: @escaping ((Error?) -> Void)) {
        initRef.child("Alternate Names").setValue(initPerson.alternateNames, withCompletionBlock: { error, reference in
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
    
    //MARK: - UTILITIES
    func setValueArray(ref: DatabaseReference,arrto: [String], completion: @escaping ((Error?) -> Void)) {
        var arrTo = arrto
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
    }
}

enum PersonEditorError: Error {
    case imageUpdateError(String)
    case nameUpdateError(String)
    case spotifyUpdateError(String)
    case appleUpdateError(String)
    case youtubeUpdateError(String)
    case soundcloudUpdateError(String)
    case youtubeMusicUpdateError(String)
    case amazonUpdateError(String)
    case deezerUpdateError(String)
    case tidalUpdateError(String)
    case napsterUpdateError(String)
    case spinrillaUpdateError(String)
    case twitterUpdateError(String)
    case instagramUpdateError(String)
    case facebookUpdateError(String)
    case tiktokUpdateError(String)
}
