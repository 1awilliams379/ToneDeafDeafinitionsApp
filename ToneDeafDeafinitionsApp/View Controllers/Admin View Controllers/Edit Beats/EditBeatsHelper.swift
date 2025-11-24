//
//  EditBeatsHelper.swift
//  ToneDeafDeafinitionsApp
//
//  Created by Tone Deaf on 10/16/20.
//  Copyright © 2020 GITEM Solutions. All rights reserved.
//

import Foundation
import FirebaseDatabase
import FirebaseStorage

class EditBeatsHelper {
    static let shared = EditBeatsHelper()
    
    var uploadCompletionStatus1:Bool!
    var uploadCompletionStatus2:Bool!
    var uploadCompletionStatus3:Bool!
    var uploadCompletionStatus4:Bool!
    var uploadCompletionStatus5:Bool!
    
    var errors:[Error] = []
    var initialSnapshot:DataSnapshot!
    var initialIDsSnapshot:DataSnapshot?
    var currInitialIDsSnapshot:DataSnapshot?
    var producerKeyRefs:[String]?
    var videoKeyRefs:[String]?
    var initialAllContentIDs:[String]?
    var initialAllBeatIDs:[String]?
    var initialPriceTypeBeatIDs:[String]?
    var initialWavFilePath:StorageReference?
    var initialExclusiveFilesPath:StorageReference?
    
    
    func update(currentBeat: BeatData, initialBeat:BeatData, newimage: UIImage?, newAudio: URL?, newWav: URL?, newExclusive: URL?, completion: @escaping ([Error]?) -> Void)  {
        Database.database().reference().child("Beats").child(initialBeat.priceType).child(initialBeat.beatID).observeSingleEvent(of: .value, with: {[weak self] snapshot in
            guard let strongSelf = self else {return}
            if snapshot.exists() {
                strongSelf.initialSnapshot = snapshot
                let queue = DispatchQueue(label: "myhjsdfhjbqrwhsdnhdjvb,sdjvnj kmlvkhQueue")
                let group = DispatchGroup()
                let array = [1]

                for i in array {
                    //print(i)
                    group.enter()
                    queue.async {
                        switch i {
                        case 1:
                            //print("null")
                            strongSelf.handlePriceType(currentBeat: currentBeat, initialBeat: initialBeat, completion: {[weak self] err in
                                guard let strongSelf = self else {return}
                                if let erro = err {
                                    strongSelf.errors.append(erro)
                                    strongSelf.uploadCompletionStatus1 = false
                                }
                                else {
                                    strongSelf.uploadCompletionStatus1 = true
                                }
                                group.leave()
                            })
                        default:
                            print("error 1")
                        }
                    }
                }
                
                group.notify(queue: DispatchQueue.main) {
                    let aqueue = DispatchQueue(label: "myhjsnhdjvb,sdjvjnbghgvjhvnj kmlvkhQueue")
                    let agroup = DispatchGroup()
                    let array = [2]

                    for i in array {
                        //print(i)
                        agroup.enter()
                        aqueue.async { [weak self] in
                            guard let strongSelf = self else {return}
                            switch i {
                            case 2:
                                //print("null")
                                strongSelf.handleNameChange(currentBeat: currentBeat, initialBeat: initialBeat, completion: {[weak self] err in
                                    guard let strongSelf = self else {return}
                                    if let erro = err {
                                        strongSelf.errors.append(erro)
                                    
                                        strongSelf.uploadCompletionStatus2 = false
                                    }
                                    else {
                                        strongSelf.uploadCompletionStatus2 = true
                                    }
                                    agroup.leave()
                                })
                            default:
                                print("error 2")
                            }
                        }
                    }
                    
                    agroup.notify(queue: DispatchQueue.main) {[weak self] in
                        guard let strongSelf = self else {return}
                        let bqueue = DispatchQueue(label: "myhjsnhdjvbsgdnarjekwsgb,sdjvnj kmlvkhQueue")
                        let bgroup = DispatchGroup()
                        let array = [3,4,5]
                        
                        for i in array {
                            //print(i)
                            bgroup.enter()
                            bqueue.async { [weak self] in
                                guard let strongSelf = self else {return}
                                switch i {
                                case 3:
                                    //print("null")
                                    strongSelf.handleImage(image: newimage, currentBeat: currentBeat, initialBeat: initialBeat, completion: {[weak self] err in
                                        guard let strongSelf = self else {return}
                                        if let erro = err {
                                            strongSelf.errors.append(erro)
                                            strongSelf.uploadCompletionStatus3 = false
                                        }
                                        else {
                                            strongSelf.uploadCompletionStatus3 = true
                                        }
                                        bgroup.leave()
                                    })
                                case 4:
                                    //print("null")
                                    strongSelf.handleWavURL(wav: newWav, currentBeat: currentBeat, initialBeat: initialBeat, completion: {[weak self] err in
                                        guard let strongSelf = self else {return}
                                        if let erro = err {
                                            strongSelf.errors.append(erro)
                                            strongSelf.uploadCompletionStatus4 = false
                                        }
                                        else {
                                            strongSelf.uploadCompletionStatus4 = true
                                        }
                                        bgroup.leave()
                                    })
                                case 5:
                                    //print("null")
                                    strongSelf.handleExclusiveFileURL(ex: newExclusive, currentBeat: currentBeat, initialBeat: initialBeat, completion: {[weak self] err in
                                        guard let strongSelf = self else {return}
                                        if let erro = err {
                                            strongSelf.errors.append(erro)
                                            strongSelf.uploadCompletionStatus5 = false
                                        }
                                        else {
                                            strongSelf.uploadCompletionStatus5 = true
                                        }
                                        bgroup.leave()
                                    })
                                default:
                                    print("error 3")
                                }
                            }
                            bgroup.notify(queue: DispatchQueue.main) {[weak self] in
                                guard let strongSelf = self else {return}
                                if strongSelf.uploadCompletionStatus1 == false || strongSelf.uploadCompletionStatus2 == false || strongSelf.uploadCompletionStatus3 == false || strongSelf.uploadCompletionStatus4 == false || strongSelf.uploadCompletionStatus5 == false {
                                    strongSelf.cancelUpdate(currentBeat: currentBeat, initialBeat: initialBeat)
                                    completion(strongSelf.errors)
                                    return
                                } else {
                                    if newWav != nil && strongSelf.initialWavFilePath != nil {
                                        strongSelf.removeOldWav()
                                    }
                                    if newExclusive != nil && strongSelf.initialExclusiveFilesPath != nil {
                                        strongSelf.removeOldExclusives()
                                    }
                                    completion(nil)
                                }
                            }
                        }
                    }
                }
            }
        })
    }
    
    //MARK: - Handle Price Type
    
    private func handlePriceType(currentBeat:BeatData, initialBeat:BeatData,completion: @escaping (Error?) -> Void)  {
        //print(initialBeat.priceType, currentBeat.priceType)
        guard currentBeat.priceType != initialBeat.priceType else {
            completion(nil)
            return
        }
        //Get the initial snap to switch
        Database.database().reference().child("Beats").child(initialBeat.priceType).child(initialBeat.beatID).observeSingleEvent(of: .value, with: {[weak self] snapshot in
            guard let strongSelf = self else {return}
            if snapshot.exists() {
                //Swap PriceTypes
                //place under current KeyId
                Database.database().reference().child("Beats").child(currentBeat.priceType).child(currentBeat.beatID).setValue(snapshot.value)
                //remove from previous KeyId
                Database.database().reference().child("Beats").child(initialBeat.priceType).child(initialBeat.beatID).removeValue()
                //Add ID to new Price type ID array
                strongSelf.addCurrBeatIDToNewIDArray(currentBeat: currentBeat, completion: { err in
                    if let erro = err {
                        completion(erro)
                        return
                    } else {
                        // Remove ID from initial price type ID Array
                        strongSelf.removeCurrBeatIDfromInitialIDArray(initialBeat: initialBeat, completion: { err in
                            if let erro = err {
                                completion(erro)
                                return
                            } else {
                                completion(nil)
                                return
                            }
                        })
                    }
                })
            } else {
                completion(BeatUpdateErrors.PriceTypeSnapshotDoesNotExist)
                return
            }
        })
    }
    
    fileprivate func addCurrBeatIDToNewIDArray(currentBeat:BeatData, completion: @escaping (Error?) -> Void)  {
        Database.database().reference().child("Beats").child(currentBeat.priceType).child("\(currentBeat.priceType) Beat IDs").observeSingleEvent(of: .value, with: {[weak self] snap in
            guard let strongSelf = self else {return}
            if snap.exists() {
                strongSelf.currInitialIDsSnapshot = snap
                var arr = snap.value as! [String]
                arr.append("\(currentBeat.toneDeafAppId)Æ\(currentBeat.name)")
                Database.database().reference().child("Beats").child(currentBeat.priceType).child("\(currentBeat.priceType) Beat IDs").setValue(arr)
                completion(nil)
            } else {
                completion(BeatUpdateErrors.AllBeatIDsSnapshotDoesNotExist_addCurrBeatIDToNewIDArray)
                return
            }
        })
    }
    
    fileprivate func removeCurrBeatIDfromInitialIDArray(initialBeat:BeatData, completion: @escaping (Error?) -> Void)  {
        Database.database().reference().child("Beats").child(initialBeat.priceType).child("\(initialBeat.priceType) Beat IDs").observeSingleEvent(of: .value, with: {[weak self] snap in
            guard let strongSelf = self else {return}
            if snap.exists() {
                strongSelf.initialIDsSnapshot = snap
                let arr = snap.value as! [String]
                var newArr:[String]=[]
                for beat in arr {
                    if !beat.contains(initialBeat.toneDeafAppId) {
                        newArr.append(beat)
                    }
                }
                if newArr.count == arr.count {
                    completion(BeatUpdateErrors.BeatNotFoundInAllBeatsArray_removeCurrBeatIDfromInitialIDArray)
                    return
                } else
                if newArr.count == arr.count-1 {
                    Database.database().reference().child("Beats").child(initialBeat.priceType).child("\(initialBeat.priceType) Beat IDs").setValue(newArr)
                    completion(nil)
                    return
                } else {
                    completion(BeatUpdateErrors.AllBeatIDsCodeError100)
                    return
                }
            } else {
                completion(BeatUpdateErrors.AllBeatIDsSnapshotDoesNotExist_removeCurrBeatIDfromInitialIDArray)
                return
            }
        })
    }
    
    //MARK: - Handle Name Change
    
    private func handleNameChange(currentBeat:BeatData, initialBeat:BeatData,completion: @escaping (Error?) -> Void)  {
        guard currentBeat.name != initialBeat.name else {
            completion(nil)
            return
        }
        if currentBeat.priceType == initialBeat.priceType {
            //Get Initial Snapshot from initial price type key
            Database.database().reference().child("Beats").child(initialBeat.priceType).child(initialBeat.beatID).observeSingleEvent(of: .value, with: {[weak self] snapshot in
                guard let strongSelf = self else {return}
                guard snapshot.exists() else {
                    completion(BeatUpdateErrors.InitialBeatSnapshotDoesNotExist)
                    return
                }
                //Replace under new beatId with updated name.
                Database.database().reference().child("Beats").child(currentBeat.priceType).child(currentBeat.beatID).setValue(snapshot.value)
                //Remove the old location.
                Database.database().reference().child("Beats").child(initialBeat.priceType).child(initialBeat.beatID).removeValue()
                //Get Producer refs
                strongSelf.getProducerRefs(currentBeat: currentBeat, completion: { prorefs, err in
                    if let errrrr = err {
                        completion(errrrr)
                        return
                    } else {
                        guard let ref = prorefs else {
                            completion(BeatUpdateErrors.ProducerReferenceError)
                            return
                        }
                        //For each producer in the currentBeat, go to their beats, get the array of beats, if beat id is in the array remove it, change the name, add to array, and put back in database.
                        strongSelf.updateProducersBeatsName(refs: ref, currentBeat: currentBeat, completion: {err in
                            if let erro = err {
                                completion(erro)
                                return
                            } else {
                                //Get Video Refs
                                strongSelf.getVideoRefs(currentBeat: currentBeat, completion: { vidrefs, err in
                                    if let errrrrr = err {
                                        completion(errrrrr)
                                        return
                                    } else {
                                        guard let ref = vidrefs else {
                                            completion(BeatUpdateErrors.VideoReferenceError)
                                            return
                                        }
                                        //For each video in the currentBeat, go to its beats, get the array of beats, if beat id is in the array remove it, change the name, add to array, and put back in database.
                                        strongSelf.updateVideosBeatsName(refs: ref, currentBeat: currentBeat, completion: {err in
                                            if let erro = err {
                                                completion(erro)
                                                return
                                            } else {
                                                //For each item in the All Content, , if beat id is in the array remove it, change the name, add to array, and put back in database.
                                                strongSelf.updateAllContentBeatsName(currentBeat: currentBeat, completion: { er in
                                                    if let erro = er {
                                                        completion(erro)
                                                        return
                                                    } else {
                                                        //For each item in the CurrentBeat price type IDs array, if beat id is in the array remove it, change the name, add to array, and put back in database.
                                                        strongSelf.updateAllBeatIDsBeatName(currentBeat: currentBeat, completion: { e in
                                                            if let erro = e {
                                                                completion(erro)
                                                                return
                                                            } else {
                                                                strongSelf.updatePriceIDsBeatName(currentBeat: currentBeat, completion: { erl in
                                                                    if let erro = erl {
                                                                        completion(erro)
                                                                        return
                                                                    } else {
                                                                        //Change Beat ID && Name
                                                                        Database.database().reference().child("Beats").child(currentBeat.priceType).child(currentBeat.beatID).child("beatId").setValue(currentBeat.beatID)
                                                                        Database.database().reference().child("Beats").child(currentBeat.priceType).child(currentBeat.beatID).child("Name").setValue(currentBeat.name)
                                                                        completion(nil)
                                                                    }
                                                                })
                                                            }
                                                        })
                                                    }
                                                })
                                            }
                                        })
                                    }
                                })
                            }
                        })
                    }
                })
            })
        } else {
            
        }
    }
    
    fileprivate func getProducerRefs(currentBeat:BeatData, completion: @escaping ([String]?,Error?) -> Void)  {
        var producerRefs:[String] = []
        for pro in currentBeat.producers {
            let word = pro.split(separator: "Æ")
            let id = word[0]
            Database.database().reference().child("Registered Persons").observeSingleEvent(of: .value, with: {[weak self] snapshot in
                guard let strongSelf = self else {return}
                for produce in snapshot.children {
                    let data = produce as! DataSnapshot
                    let key = data.key
                    if data.key.contains(id) == true {
                        producerRefs.append(key)
                    }
                }
                strongSelf.producerKeyRefs = producerRefs
                completion(producerRefs, nil)
            })
        }
    }
    
    fileprivate func updateProducersBeatsName(refs:[String], currentBeat:BeatData, completion: @escaping (Error?) -> Void)  {
        var tick = 0
        for ref in refs {
            Database.database().reference().child("Registered Persons").child(ref).child("Beats").observeSingleEvent(of: .value, with: { snapshot in
                guard snapshot.exists() else {
                    print("errow with ref \(ref)")
                    completion(BeatUpdateErrors.ProducerBeatsSnapshotDoesNotExist)
                    return
                }
                let arr = snapshot.value as! [String]
                guard arr != [""], !arr.isEmpty else {
                    completion(nil)
                    return
                }
                var newArr:[String]=[]
                for beat in arr {
                    if beat.contains(currentBeat.toneDeafAppId) {
                        let newId = "\(currentBeat.toneDeafAppId)Æ\(currentBeat.name)"
                        newArr.append(newId)
                    } else {
                        newArr.append(beat)
                    }
                }
                guard arr.count == newArr.count else {
                    completion(BeatUpdateErrors.ProducerBeatsArrayCountDoesNotMatchInitial)
                    return
                }
                Database.database().reference().child("Registered Persons").child(ref).child("Beats").setValue(newArr)
                tick+=1
                if tick == refs.count {
                    completion(nil)
                    return
                }
            })
        }
    }
    
    fileprivate func getVideoRefs(currentBeat:BeatData, completion: @escaping ([String]?,Error?) -> Void)  {
        var videoRefs:[String] = []
        guard currentBeat.videos != [""], !currentBeat.videos.isEmpty else {
            completion(videoRefs,nil)
            return
        }
        for vid in currentBeat.videos {
            let word = vid.split(separator: "Æ")
            let id = word[0]
            Database.database().reference().child("Music Content").child("Videos").observeSingleEvent(of: .value, with: {[weak self] snapshot in
                guard let strongSelf = self else {return}
                for vide in snapshot.children {
                    let data = vide as! DataSnapshot
                    let key = data.key
                    if data.key.contains(id) == true {
                        videoRefs.append(key)
                    }
                }
                strongSelf.videoKeyRefs = videoRefs
                completion(videoRefs, nil)
            })
        }
    }
    
    fileprivate func updateVideosBeatsName(refs:[String], currentBeat:BeatData, completion: @escaping (Error?) -> Void)  {
        var tick = 0
        if refs.isEmpty {
            completion(nil)
            return
        }
        for ref in refs {
            Database.database().reference().child("Music Content").child("Videos").child(ref).child("Beats").observeSingleEvent(of: .value, with: { snapshot in
                guard snapshot.exists() else {
                    print("errow with ref \(ref)")
                    completion(BeatUpdateErrors.ProducerBeatsSnapshotDoesNotExist)
                    return
                }
                let arr = snapshot.value as! [String]
                guard arr != [""], !arr.isEmpty else {
                    completion(nil)
                    return
                }
                var newArr:[String]=[]
                for beat in arr {
                    if beat.contains(currentBeat.toneDeafAppId) {
                        let newId = "\(currentBeat.toneDeafAppId)Æ\(currentBeat.name)"
                        newArr.append(newId)
                    } else {
                        newArr.append(beat)
                    }
                }
                guard arr.count == newArr.count else {
                    completion(BeatUpdateErrors.ProducerBeatsArrayCountDoesNotMatchInitial)
                    return
                }
                Database.database().reference().child("Music Content").child("Videos").child(ref).child("Beats").setValue(newArr)
                tick+=1
                if tick == refs.count {
                    completion(nil)
                    return
                }
            })
        }
    }
    
    fileprivate func updateAllContentBeatsName(currentBeat:BeatData, completion: @escaping (Error?) -> Void)  {
        Database.database().reference().child("All Content IDs").observeSingleEvent(of: .value, with: {[weak self] snapshot in
            guard let strongSelf = self else {return}
            guard snapshot.exists() else {
                completion(BeatUpdateErrors.AllContentSnapshotDoesNotExist)
                return
            }
            let arr = snapshot.value as! [String]
            strongSelf.initialAllContentIDs = arr
            guard arr != [""], !arr.isEmpty else {
                completion(nil)
                return
            }
            var newArr:[String]=[]
            for beat in arr {
                if beat.contains(currentBeat.toneDeafAppId) {
                    let newId = "\(currentBeat.toneDeafAppId)Æ\(currentBeat.name)"
                    newArr.append(newId)
                } else {
                    newArr.append(beat)
                }
            }
            guard arr.count == newArr.count else {
                completion(BeatUpdateErrors.AllContentArrayCountDoesNotMatchInitial)
                return
            }
            Database.database().reference().child("All Content IDs").setValue(newArr)
            completion(nil)
        })
    }
    
    fileprivate func updateAllBeatIDsBeatName(currentBeat:BeatData, completion: @escaping (Error?) -> Void)  {
        Database.database().reference().child("Beats").child("All Beat IDs").observeSingleEvent(of: .value, with: {[weak self] snapshot in
            guard let strongSelf = self else {return}
            guard snapshot.exists() else {
                completion(BeatUpdateErrors.AllBeatIDsSnapshotDoesNotExist)
                return
            }
            let arr = snapshot.value as! [String]
            strongSelf.initialAllBeatIDs = arr
            guard arr != [""], !arr.isEmpty else {
                completion(nil)
                return
            }
            var newArr:[String]=[]
            for beat in arr {
                if beat.contains(currentBeat.toneDeafAppId) {
                    let newId = "\(currentBeat.toneDeafAppId)Æ\(currentBeat.name)"
                    newArr.append(newId)
                } else {
                    newArr.append(beat)
                }
            }
            guard arr.count == newArr.count else {
                completion(BeatUpdateErrors.AllBeatIDsArrayCountDoesNotMatchInitial)
                return
            }
            Database.database().reference().child("Beats").child("All Beat IDs").setValue(newArr)
            completion(nil)
        })
    }
    
    fileprivate func updatePriceIDsBeatName(currentBeat:BeatData, completion: @escaping (Error?) -> Void)  {
        Database.database().reference().child("Beats").child(currentBeat.priceType).child("\(currentBeat.priceType) Beat IDs").observeSingleEvent(of: .value, with: {[weak self] snapshot in
            guard let strongSelf = self else {return}
            guard snapshot.exists() else {
                completion(BeatUpdateErrors.AllPriceIDsSnapshotDoesNotExist)
                return
            }
            let arr = snapshot.value as! [String]
            strongSelf.initialPriceTypeBeatIDs = arr
            guard arr != [""], !arr.isEmpty else {
                completion(nil)
                return
            }
            var newArr:[String]=[]
            for beat in arr {
                if beat.contains(currentBeat.toneDeafAppId) {
                    let newId = "\(currentBeat.toneDeafAppId)Æ\(currentBeat.name)"
                    newArr.append(newId)
                } else {
                    newArr.append(beat)
                }
            }
            guard arr.count == newArr.count else {
                completion(BeatUpdateErrors.AllPriceIDsArrayCountDoesNotMatchInitial)
                return
            }
            Database.database().reference().child("Beats").child(currentBeat.priceType).child("\(currentBeat.priceType) Beat IDs").setValue(newArr)
            completion(nil)
        })
    }
    
    //MARK: - Handle Image Change
    
    private func handleImage(image: UIImage?, currentBeat:BeatData, initialBeat:BeatData,completion: @escaping (Error?) -> Void)  {
        guard let image = image else {
            completion(nil)
            return
        }
        let pathOfImagePeingReplaced = "Beats/"
    }
    
    //MARK: - Handle Wav Change
    private func handleWavURL(wav: URL?, currentBeat:BeatData, initialBeat:BeatData,completion: @escaping (Error?) -> Void)  {
        guard let wav = wav else {
            completion(nil)
            return
        }
        Storage.storage().reference().child("/Beats/\(currentBeat.priceType)/\(currentBeat.beatID)/Beat Wav/").listAll(completion: {[weak self] result, error in
            guard let strongSelf = self else {return}
            if let error = error {
                completion(error)
            } else {
                guard let result = result else {
                    return
                }
                if !result.items.isEmpty {
                    for wav in result.items {
                        strongSelf.initialWavFilePath = wav
                        print(wav)
                    }
                }
                StorageManager.shared.uploadWavAudio(with: currentBeat, url: wav, fileName: currentBeat.beatID, type: "beat", completion: { result in
                    switch result {
                    case.success(let downloadURL):
                        Database.database().reference().child("Beats").child(currentBeat.priceType).child(currentBeat.beatID).child("Wav URL").setValue(downloadURL)
                        completion(nil)
                    case .failure(let err):
                        completion(err)
                        return
                    }
                    
                })
            }
        })
    }
    
    func removeOldWav() {
        initialWavFilePath!.delete(completion: nil)
    }
    
    //MARK: - Handle Exclusive File Change
    private func handleExclusiveFileURL(ex: URL?, currentBeat:BeatData, initialBeat:BeatData,completion: @escaping (Error?) -> Void)  {
        guard let ex = ex else {
            completion(nil)
            return
        }
        Storage.storage().reference().child("/Beats/\(currentBeat.priceType)/\(currentBeat.beatID)/Beat Exclusive Files/").listAll(completion: {[weak self] result, error in
            guard let strongSelf = self else {return}
            if let error = error {
                completion(error)
            } else {
                guard let result = result else {
                    return
                }
                if !result.items.isEmpty {
                    for exfiles in result.items {
                        strongSelf.initialExclusiveFilesPath = exfiles
                        print(exfiles)
                    }
                }
                StorageManager.shared.uploadExclusiveFilesZip(with: currentBeat, url: ex, fileName: currentBeat.beatID, type: "beat", completion: { result in
                    switch result {
                    case.success(let downloadURL):
                        Database.database().reference().child("Beats").child(currentBeat.priceType).child(currentBeat.beatID).child("Exclusive Files URL").setValue(downloadURL)
                        completion(nil)
                    case .failure(let err):
                        completion(err)
                        return
                    }
                    
                })
            }
        })
    }
    
    func removeOldExclusives() {
        initialExclusiveFilesPath!.delete(completion: nil)
    }
    
    //MARK: - Cancel Change
    private func cancelUpdate(currentBeat: BeatData, initialBeat:BeatData) {
        if currentBeat.beatID != initialBeat.beatID || currentBeat.priceType != initialBeat.priceType {
            Database.database().reference().child("Beats").child(currentBeat.priceType).child(currentBeat.beatID).removeValue()
        }
        Database.database().reference().child("Beats").child(initialBeat.priceType).child(initialBeat.beatID).setValue(initialSnapshot!.value)
        if let initIds = initialIDsSnapshot {
            Database.database().reference().child("Beats").child(initialBeat.priceType).child("\(initialBeat.priceType) Beat IDs").setValue(initIds.value)
        }
        if let currInit = currInitialIDsSnapshot {
            Database.database().reference().child("Beats").child(currentBeat.priceType).child("\(currentBeat.priceType) Beat IDs").setValue(currInit.value)
        }
        if currentBeat.name != initialBeat.name {
            cancelNameUpdate(currentBeat: currentBeat, initialBeat: initialBeat)
        }
    }
    
    private func cancelNameUpdate(currentBeat: BeatData, initialBeat:BeatData) {
        if let refs = producerKeyRefs {
            for ref in refs {
                Database.database().reference().child("Registered Persons").child(ref).child("Beats").observeSingleEvent(of: .value, with: { snapshot in
                    let arr = snapshot.value as! [String]
                    var newArr:[String]=[]
                    for beat in arr {
                        if beat.contains(currentBeat.toneDeafAppId) {
                            let newId = "\(initialBeat.toneDeafAppId)Æ\(initialBeat.name)"
                            newArr.append(newId)
                        } else {
                            newArr.append(beat)
                        }
                    }
                    Database.database().reference().child("Registered Persons").child(ref).child("Beats").setValue(newArr)
                })
            }
        }
        if let refs = videoKeyRefs {
            for ref in refs {
                Database.database().reference().child("Music Content").child("Videos").child(ref).child("Beats").observeSingleEvent(of: .value, with: { snapshot in
                    let arr = snapshot.value as! [String]
                    var newArr:[String]=[]
                    for beat in arr {
                        if beat.contains(currentBeat.toneDeafAppId) {
                            let newId = "\(initialBeat.toneDeafAppId)Æ\(initialBeat.name)"
                            newArr.append(newId)
                        } else {
                            newArr.append(beat)
                        }
                    }
                    Database.database().reference().child("Music Content").child("Videos").child(ref).child("Beats").setValue(newArr)
                })
            }
        }
        if let arr = initialAllContentIDs {
            Database.database().reference().child("All Content IDs").setValue(arr)
        }
        if let arr = initialAllBeatIDs {
            Database.database().reference().child("Beats").child("All Beat IDs").setValue(arr)
        }
        if let arr = initialPriceTypeBeatIDs {
            Database.database().reference().child("Beats").child(initialBeat.priceType).child("\(initialBeat.priceType) Beat IDs").setValue(arr)
        }
        if currentBeat.priceType == initialBeat.priceType {
            Database.database().reference().child("Beats").child(initialBeat.priceType).child(initialBeat.beatID).child("beatId").setValue(initialBeat.beatID)
            Database.database().reference().child("Beats").child(initialBeat.priceType).child(initialBeat.beatID).child("Name").setValue(initialBeat.name)
        }
    }
}

public enum BeatUpdateErrors: Error {
    case AllContentSnapshotDoesNotExist
    case AllContentArrayCountDoesNotMatchInitial
    case AllBeatIDsSnapshotDoesNotExist
    case AllBeatIDsArrayCountDoesNotMatchInitial
    case AllPriceIDsSnapshotDoesNotExist
    case AllPriceIDsArrayCountDoesNotMatchInitial
    case PriceTypeSnapshotDoesNotExist
    case InitialBeatSnapshotDoesNotExist
    case CurrentBeatSnapshotDoesNotExist
    case ProducerReferenceError
    case VideoReferenceError
    case ProducerBeatsSnapshotDoesNotExist
    case ProducerBeatsArrayCountDoesNotMatchInitial
    case AllBeatIDsSnapshotDoesNotExist_addCurrBeatIDToNewIDArray
    case AllBeatIDsSnapshotDoesNotExist_removeCurrBeatIDfromInitialIDArray
    case BeatNotFoundInAllBeatsArray_removeCurrBeatIDfromInitialIDArray
    case AllBeatIDsCodeError100
}
