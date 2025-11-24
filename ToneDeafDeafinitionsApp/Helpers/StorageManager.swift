//
//  StorageManager.swift
//  ToneDeafDeafinitionsApp
//
//  Created by Tone Deaf on 8/1/20.
//  Copyright © 2020 GITEM Solutions. All rights reserved.
//

import AVKit
import Foundation
import FirebaseStorage

final class StorageManager {
    
    static let shared = StorageManager()
    
    private let storageRef = Storage.storage().reference()
    
    public static var audioURL:String = ""
    public static var imageURL:String = ""
    public static var videoURL:String = ""
    public static var AudioFilePath:StorageUploadTask?
    public static var ZipFilePath:StorageUploadTask?
    public static var ImageFilePath:StorageUploadTask!
    public static var VideoFilePath:StorageUploadTask!
    public static var beatDuration:String = ""
    

    
    public typealias UploadCompletion = (Result<String, Error>) -> Void
    public typealias UploadKitCompletion = (Result<StorageReference, Error>) -> Void
    public typealias UploadCompletionState = (Result<[String], Error>) -> Void
    public typealias PersonImageUploadCompletionState = (Result<String, Error>) -> Void
    public typealias SongImageUploadCompletionState = (Result<String, Error>) -> Void
    public typealias SongPreviewUploadCompletionState = (Result<String, Error>) -> Void
    
    deinit {
        print("gone")
    }
    
    public func uploadImage(with data: Data, fileName: String, completion: @escaping UploadCompletion) {
        let beatImageRef = storageRef.child("Beats").child("Unused").child(fileName).child("Images").child("TDDApp-IOS-image-\(generateRandomNumber(digits: 16))-\(fileName)")
        let imageFilePath = beatImageRef.putData(data, metadata: nil, completion: { metadata, error in
            guard error == nil else {
                print("📕 Failed to upload image")
                Utilities.showError2("Failed to upload image.", actionText: "OK")
                completion(.failure(StorageErrors.failedToUpload))
                return
            }
            beatImageRef.downloadURL(completion: { url, error in
                guard let url = url else {
                    print("📕 Failed to get image download URL \(String(describing: error))")
                    Utilities.showError2("Failed to get image download URL.", actionText: "OK")
                    completion(.failure(StorageErrors.failedToGetImageDownloadURL))
                    return
                }
                
                let urlString = url.absoluteString
                print("📙 download url: \(urlString)")
                completion(.success(urlString))
                return
            })
            
        })
        
        imageFilePath.observe(.resume, handler: { snapshot in
            print("📙 Image Upload Starting")
        })
        imageFilePath.observe(.pause, handler: { snapshot in
            
        })
        imageFilePath.observe(.progress, handler: { snapshot in
            let percentageBase = Double(snapshot.progress!.completedUnitCount) / Double(snapshot.progress!.totalUnitCount)
            let percentage = Int(round(100 * percentageBase))
            
            print("📙 Image Upload Percent: \(percentage)")
        })
        imageFilePath.observe(.success, handler: { snapshot in
            
        })
        imageFilePath.observe(.failure, handler: { snapshot in
            
            if let error = snapshot.error as NSError? {
                switch (StorageErrorCode(rawValue: error.code)) {
                case .objectNotFound:
                    print("📕 Audio file does not exist")
                case .unauthorized:
                    print("📕 Audio upload permission denied")
                case .cancelled:
                    print("📕 Audio upload canceled")
                default:
                    print("📕 Audio upload failed. Please retry. \(error.localizedDescription)")
                }
            }
        })
        print("📙 Image File Path: \(String(describing: StorageManager.ImageFilePath))")
        
    }
    
    private func putData(ref: StorageReference, data: Data, meta: StorageMetadata?, completion: @escaping UploadCompletion) {
        
        let imageFilePath = ref.putData(data, metadata: meta) {[weak self] (metadata, error) in
            guard let strongSelf = self else {return}
            
            guard error == nil else {
                print("📕 Failed to upload image")
                Utilities.showError2("Failed to upload image.", actionText: "OK")
                completion(.failure(StorageErrors.failedToUpload))
                return
            }
            
            ref.downloadURL { (url, error) in
                guard let url = url else {

                    print("📕 Failed to get image download URL \(String(describing: error))")
                    Utilities.showError2("Failed to get image download URL.", actionText: "OK")
                    completion(.failure(StorageErrors.failedToGetImageDownloadURL))
                    return
                }

                let urlString = url.absoluteString
                print("📙 download url: \(urlString)")
                completion(.success(urlString))
                return
            }
            
        }
        imageFilePath.observe(.resume, handler: { snapshot in
            print("📙 Image Upload Starting")
        })
        imageFilePath.observe(.pause, handler: { snapshot in

        })
        imageFilePath.observe(.progress, handler: { snapshot in
            let percentageBase = Double(snapshot.progress!.completedUnitCount) / Double(snapshot.progress!.totalUnitCount)
            let percentage = Int(round(100 * percentageBase))

            print("📙 Image Upload Percent: \(percentage)")
        })
        imageFilePath.observe(.success, handler: { snapshot in
            imageFilePath.removeAllObservers()
        })
        imageFilePath.observe(.failure, handler: { snapshot in

            if let error = snapshot.error as NSError? {

                switch (StorageErrorCode(rawValue: error.code)) {
                case .objectNotFound:
                    print("📕 Audio file does not exist")
                case .unauthorized:
                    print("📕 Audio upload permission denied")
                case .cancelled:
                    print("📕 Audio upload canceled")
                default:
                    print("📕 Image upload failed. Please retry. \(error.localizedDescription)")
                }
            } else {

            }
        })
        print("📙 Image File Path: \(imageFilePath)")
    }
    
    private func putFile(ref: StorageReference, data: URL, meta: StorageMetadata?, completion: @escaping UploadCompletion) {
        
        let imageFilePath = ref.putFile(from: data, metadata: meta) {[weak self] (metadata, error) in
            guard let strongSelf = self else {return}
            
            guard error == nil else {
                print("📕 Failed to upload image")
                Utilities.showError2("Failed to upload image.", actionText: "OK")
                completion(.failure(StorageErrors.failedToUpload))
                return
            }
            
            ref.downloadURL { (url, error) in
                guard let url = url else {

                    print("📕 Failed to get image download URL \(String(describing: error))")
                    Utilities.showError2("Failed to get image download URL.", actionText: "OK")
                    completion(.failure(StorageErrors.failedToGetImageDownloadURL))
                    return
                }

                let urlString = url.absoluteString
                print("📙 download url: \(urlString)")
                completion(.success(urlString))
                return
            }
            
        }
        imageFilePath.observe(.resume, handler: { snapshot in
            print("📙 Image Upload Starting")
        })
        imageFilePath.observe(.pause, handler: { snapshot in

        })
        imageFilePath.observe(.progress, handler: { snapshot in
            let percentageBase = Double(snapshot.progress!.completedUnitCount) / Double(snapshot.progress!.totalUnitCount)
            let percentage = Int(round(100 * percentageBase))

            print("📙 Image Upload Percent: \(percentage)")
        })
        imageFilePath.observe(.success, handler: { snapshot in
            imageFilePath.removeAllObservers()
        })
        imageFilePath.observe(.failure, handler: { snapshot in

            if let error = snapshot.error as NSError? {

                switch (StorageErrorCode(rawValue: error.code)) {
                case .objectNotFound:
                    print("📕 Audio file does not exist")
                case .unauthorized:
                    print("📕 Audio upload permission denied")
                case .cancelled:
                    print("📕 Audio upload canceled")
                default:
                    print("📕 Image upload failed. Please retry. \(error.localizedDescription)")
                }
            } else {

            }
        })
        print("📙 Image File Path: \(imageFilePath)")
    }
    
    func finishPutData(ref:StorageReference, completion: @escaping UploadCompletion) {
        ref.downloadURL(completion: {[weak self] url, error in
            guard let url = url else {

                print("📕 Failed to get image download URL \(String(describing: error))")
                Utilities.showError2("Failed to get image download URL.", actionText: "OK")
                completion(.failure(StorageErrors.failedToGetImageDownloadURL))
                return
            }

            let urlString = url.absoluteString
            print("📙 download url: \(urlString)")
            completion(.success(urlString))
            return
        })
    }
    
    public func uploadImage(person data: Data, fileName: String, completion: @escaping PersonImageUploadCompletionState) {
        var uploadedImageUrl:String!
        let ImageRef = storageRef.child("Image Defaults").child("Manual Persons").child(fileName).child("Images").child("TDDApp-IOS-image-\(generateRandomNumber(digits: 16))-\(fileName)")
        putData(ref: ImageRef, data: data, meta: nil, completion: { result in
            switch result {
            case .success(let url):
                uploadedImageUrl = url
                completion(.success(uploadedImageUrl))
                return
            case .failure(let err):
                print(err)
            }
        })
    }
    
    public func uploadImage(song data: Data, fileName: String, completion: @escaping PersonImageUploadCompletionState) {
        var uploadedImageUrl:String!
        let ImageRef = storageRef.child("Image Defaults").child("Manual Songs").child(fileName).child("Images").child("TDDApp-IOS-image-\(generateRandomNumber(digits: 16))-\(fileName)")
        putData(ref: ImageRef, data: data, meta: nil, completion: { result in
            switch result {
            case .success(let url):
                uploadedImageUrl = url
                completion(.success(uploadedImageUrl))
                return
            case .failure(let err):
                print(err)
            }
        })
    }
    
    public func uploadImage(album data: Data, fileName: String, completion: @escaping PersonImageUploadCompletionState) {
        var uploadedImageUrl:String!
        let ImageRef = storageRef.child("Image Defaults").child("Manual Albums").child(fileName).child("Images").child("TDDApp-IOS-image-\(generateRandomNumber(digits: 16))-\(fileName)")
        putData(ref: ImageRef, data: data, meta: nil, completion: { result in
            switch result {
            case .success(let url):
                uploadedImageUrl = url
                completion(.success(uploadedImageUrl))
                return
            case .failure(let err):
                print(err)
            }
        })
    }
    
    public func uploadImage(kit dataarr: Data, fileName: String, completion: @escaping UploadKitCompletion) {
            let ImageRef = storageRef.child("Merch").child("Kits").child(fileName).child("Images").child("TDDApp-IOS-image-\(generateRandomNumber(digits: 16))-\(fileName)")
            putDataImage(ref: ImageRef, data: dataarr, meta: nil, completion: { result in
                switch result {
                case .success(_):
                    completion(.success(ImageRef))
                    return
                case .failure(let err):
                    print(err)
                }
            })
    }
    
    private func putDataImage(ref: StorageReference, data: Data, meta: StorageMetadata?, completion: @escaping UploadCompletion) {
        
        let imageFilePath = ref.putData(data, metadata: meta) {[weak self] (metadata, error) in
            guard let strongSelf = self else {return}
            
            guard error == nil else {
                print("📕 Failed to upload image")
                Utilities.showError2("Failed to upload image.", actionText: "OK")
                completion(.failure(StorageErrors.failedToUpload))
                return
            }
            
            completion(.success(""))
            
        }
        imageFilePath.observe(.resume, handler: { snapshot in
            print("📙 Image Upload Starting")
        })
        imageFilePath.observe(.pause, handler: { snapshot in

        })
        imageFilePath.observe(.progress, handler: { snapshot in
            let percentageBase = Double(snapshot.progress!.completedUnitCount) / Double(snapshot.progress!.totalUnitCount)
            let percentage = Int(round(100 * percentageBase))

            print("📙 Image Upload Percent: \(percentage)")
        })
        imageFilePath.observe(.success, handler: { snapshot in
            print("📙 Image Upload Done")
            imageFilePath.cancel()
            imageFilePath.removeAllObservers()
        })
        imageFilePath.observe(.failure, handler: { snapshot in

            if let error = snapshot.error as NSError? {

                switch (StorageErrorCode(rawValue: error.code)) {
                case .objectNotFound:
                    print("📕 Audio file does not exist")
                case .unauthorized:
                    print("📕 Audio upload permission denied")
                case .cancelled:
                    print("📕 Audio upload canceled")
                default:
                    print("📕 Image upload failed. Please retry. \(error.localizedDescription)")
                }
            } else {

            }
        })
        print("📙 Image File Path: \(imageFilePath)")
    }
    
    public func uploadImage(apperal data: Data, subcat:String, fileName: String, completion: @escaping UploadCompletion) {
        let ImageRef = storageRef.child("Merch").child("Apperal").child(subcat).child(fileName).child("Images").child("TDDApp-IOS-image-\(generateRandomNumber(digits: 16))-\(fileName)")
        StorageManager.ImageFilePath = ImageRef.putData(data, metadata: nil, completion: { metadata, error in
            guard error == nil else {
                print("📕 Failed to upload image")
                Utilities.showError2("Failed to upload image.", actionText: "OK")
                completion(.failure(StorageErrors.failedToUpload))
                return
            }
            ImageRef.downloadURL(completion: {url, error in
                guard let url = url else {
                    print("📕 Failed to get image download URL \(String(describing: error))")
                    Utilities.showError2("Failed to get image download URL.", actionText: "OK")
                    completion(.failure(StorageErrors.failedToGetImageDownloadURL))
                    return
                }
                
                let urlString = url.absoluteString
                print("📙 download url: \(urlString)")
                completion(.success(urlString))
                return
            })
            
        })
        
        StorageManager.ImageFilePath!.observe(.resume, handler: { snapshot in
            print("📙 Image Upload Starting")
        })
        StorageManager.ImageFilePath!.observe(.pause, handler: { snapshot in
            
        })
        StorageManager.ImageFilePath!.observe(.progress, handler: { snapshot in
            let percentageBase = Double(snapshot.progress!.completedUnitCount) / Double(snapshot.progress!.totalUnitCount)
            let percentage = Int(round(100 * percentageBase))
            
            print("📙 Image Upload Percent: \(percentage)")
        })
        StorageManager.ImageFilePath!.observe(.success, handler: { snapshot in
            
        })
        StorageManager.ImageFilePath!.observe(.failure, handler: { snapshot in
            if let error = snapshot.error as NSError? {
                switch (StorageErrorCode(rawValue: error.code)) {
                case .objectNotFound:
                    print("📕 Audio file does not exist")
                case .unauthorized:
                    print("📕 Audio upload permission denied")
                case .cancelled:
                    print("📕 Audio upload canceled")
                default:
                    print("📕 Audio upload failed. Please retry. \(error.localizedDescription)")
                }
            }
        })
        print("📙 Image File Path: \(String(describing: StorageManager.ImageFilePath))")
        
    }
    
    public func uploadImage(memorabilia data: Data, subcat:String, fileName: String, completion: @escaping UploadCompletion) {
        let ImageRef = storageRef.child("Merch").child("Memorabilia").child(subcat).child(fileName).child("Images").child("TDDApp-IOS-image-\(generateRandomNumber(digits: 16))-\(fileName)")
        StorageManager.ImageFilePath = ImageRef.putData(data, metadata: nil, completion: { metadata, error in
            guard error == nil else {
                print("📕 Failed to upload image")
                Utilities.showError2("Failed to upload image.", actionText: "OK")
                completion(.failure(StorageErrors.failedToUpload))
                return
            }
            ImageRef.downloadURL(completion: {url, error in
                guard let url = url else {
                    print("📕 Failed to get image download URL \(String(describing: error))")
                    Utilities.showError2("Failed to get image download URL.", actionText: "OK")
                    completion(.failure(StorageErrors.failedToGetImageDownloadURL))
                    return
                }
                
                let urlString = url.absoluteString
                print("📙 download url: \(urlString)")
                completion(.success(urlString))
                return
            })
            
        })
        
        StorageManager.ImageFilePath!.observe(.resume, handler: { snapshot in
            print("📙 Image Upload Starting")
        })
        StorageManager.ImageFilePath!.observe(.pause, handler: { snapshot in
            
        })
        StorageManager.ImageFilePath!.observe(.progress, handler: { snapshot in
            let percentageBase = Double(snapshot.progress!.completedUnitCount) / Double(snapshot.progress!.totalUnitCount)
            let percentage = Int(round(100 * percentageBase))
            
            print("📙 Image Upload Percent: \(percentage)")
        })
        StorageManager.ImageFilePath!.observe(.success, handler: { snapshot in
            
        })
        StorageManager.ImageFilePath!.observe(.failure, handler: { snapshot in
            if let error = snapshot.error as NSError? {
                switch (StorageErrorCode(rawValue: error.code)) {
                case .objectNotFound:
                    print("📕 Audio file does not exist")
                case .unauthorized:
                    print("📕 Audio upload permission denied")
                case .cancelled:
                    print("📕 Audio upload canceled")
                default:
                    print("📕 Audio upload failed. Please retry. \(error.localizedDescription)")
                }
            }
        })
        print("📙 Image File Path: \(String(describing: StorageManager.ImageFilePath))")
        
    }
    
    
    
    public func uploadPreview(song data: URL, fileName: String, completion: @escaping SongPreviewUploadCompletionState) {
        var uploadedImageUrl:String!
        let previewRef = storageRef.child("Audio Defaults").child("Manual Songs").child(fileName).child("Previews").child("TDDApp-IOS-image-\(generateRandomNumber(digits: 16))-\(fileName)")
        putFile(ref: previewRef, data: data, meta: nil, completion: { result in
            switch result {
            case .success(let url):
                uploadedImageUrl = url
                completion(.success(uploadedImageUrl))
                return
            case .failure(let err):
                print(err)
            }
        })
    }
    
    public func uploadPreview(album data: URL, fileName: String, completion: @escaping SongPreviewUploadCompletionState) {
        var uploadedImageUrl:String!
        let previewRef = storageRef.child("Audio Defaults").child("Manual Albums").child(fileName).child("Previews").child("TDDApp-IOS-image-\(generateRandomNumber(digits: 16))-\(fileName)")
        putFile(ref: previewRef, data: data, meta: nil, completion: { result in
            switch result {
            case .success(let url):
                uploadedImageUrl = url
                completion(.success(uploadedImageUrl))
                return
            case .failure(let err):
                print(err)
            }
        })
    }
    
    public func uploadAudio(with url: URL, fileName: String, type: String, completion: @escaping UploadCompletion) {
        var beatAudioRef:StorageReference = storageRef
        let key:String = fileName
        if type == "beat" {
            beatAudioRef = storageRef.child("Beats").child("Unused").child(key).child("Audio").child("TDDApp-IOS-audio-\(generateRandomNumber(digits: 16))-\(key)")
        } else if type == "instrumental" {
            beatAudioRef = storageRef.child("Beats").child("Instrumentals").child(key).child("TDDApp-IOS-audio-\(generateRandomNumber(digits: 16))-\(key)")
        }
        let metadata  = StorageMetadata()
        metadata.contentType = "audio/mpeg"
        StorageManager.AudioFilePath = beatAudioRef.putFile(from: url, metadata: nil, completion: {[weak self] metadata, error in
            guard let strongSelf = self else {return}
            guard error == nil else {
                print("📕 Failed to upload audio \(String(describing: error))")
                Utilities.showError2("Failed to upload audio.", actionText: "OK")
                completion(.failure(StorageErrors.failedToUpload))
                return
            }
            beatAudioRef.downloadURL(completion: {url, error in
                guard let url = url else {
                    print("📕 Failed to get audio download URL \(String(describing: error))")
                    Utilities.showError2("Failed to get audio download URL.", actionText: "OK")
                    completion(.failure(StorageErrors.failedToGetAudioDownloadURL))
                    return
                }
                
                let audioAsset = AVURLAsset.init(url: url, options: nil)
                let duration = audioAsset.duration
                let durationInSeconds = CMTimeGetSeconds(duration)
                let durationInSecondsRound = Int(roundf(Float(durationInSeconds))/1)
                let durationInMinues = strongSelf.timeFormatted(totalSeconds: durationInSecondsRound)
                StorageManager.beatDuration = durationInMinues
                print("📙 duration: \(StorageManager.beatDuration)")
                
                let urlString = url.absoluteString
                StorageManager.audioURL = urlString
                print("📙 download url: \(urlString)")
                completion(.success(urlString))
                
                return
            })
            
        })
        
        StorageManager.AudioFilePath!.observe(.resume, handler: { snapshot in
            print("📙 Audio Upload Starting")
        })
        StorageManager.AudioFilePath!.observe(.pause, handler: { snapshot in
            
        })
        StorageManager.AudioFilePath!.observe(.progress, handler: { snapshot in
            let percentageBase = Double(snapshot.progress!.completedUnitCount) / Double(snapshot.progress!.totalUnitCount)
            let percentage = Int(round(100 * percentageBase))
            
            print("📙 Audio upload percentage: \(percentage)")
        })
        StorageManager.AudioFilePath!.observe(.success, handler: { snapshot in
            
        })
        StorageManager.AudioFilePath!.observe(.failure, handler: { snapshot in
            if let error = snapshot.error as NSError? {
                switch (StorageErrorCode(rawValue: error.code)) {
                case .objectNotFound:
                    print("📕 Audio file does not exist")
                case .unauthorized:
                    print("📕 Audio upload permission denied")
                case .cancelled:
                    print("📕 Audio upload canceled")
                default:
                    print("📕 Audio upload failed. Please retry. \(error.localizedDescription)")
                }
            }
        })
        print("📙 Audio File Path: \(String(describing: StorageManager.AudioFilePath))")
        
    }
    
    public func uploadAudio(kit url: URL, fileName: String, completion: @escaping UploadCompletion) {
        let AudioRef = storageRef.child("Merch").child("Kits").child(fileName).child("Audio").child("TDDApp-IOS-audio-\(generateRandomNumber(digits: 16))-\(fileName)")
        let metadata  = StorageMetadata()
        metadata.contentType = "audio/mpeg"
        StorageManager.AudioFilePath = AudioRef.putFile(from: url, metadata: nil, completion: {[weak self] metadata, error in
            guard let strongSelf = self else {return}
            guard error == nil else {
                print("📕 Failed to upload audio \(String(describing: error))")
                Utilities.showError2("Failed to upload audio.", actionText: "OK")
                completion(.failure(StorageErrors.failedToUpload))
                return
            }
            AudioRef.downloadURL(completion: {url, error in
                guard let url = url else {
                    print("📕 Failed to get audio download URL \(String(describing: error))")
                    Utilities.showError2("Failed to get audio download URL.", actionText: "OK")
                    completion(.failure(StorageErrors.failedToGetAudioDownloadURL))
                    return
                }
                
                let audioAsset = AVURLAsset.init(url: url, options: nil)
                let duration = audioAsset.duration
                let durationInSeconds = CMTimeGetSeconds(duration)
                let durationInSecondsRound = Int(roundf(Float(durationInSeconds))/1)
                let durationInMinues = strongSelf.timeFormatted(totalSeconds: durationInSecondsRound)
                
                let urlString = url.absoluteString
                print("📙 download url: \(urlString)")
                completion(.success(urlString))
                
                return
            })
            
        })
        
        StorageManager.AudioFilePath!.observe(.resume, handler: { snapshot in
            print("📙 Audio Upload Starting")
        })
        StorageManager.AudioFilePath!.observe(.pause, handler: { snapshot in
            
        })
        StorageManager.AudioFilePath!.observe(.progress, handler: { snapshot in
            let percentageBase = Double(snapshot.progress!.completedUnitCount) / Double(snapshot.progress!.totalUnitCount)
            let percentage = Int(round(100 * percentageBase))
            
            print("📙 Audio upload percentage: \(percentage)")
        })
        StorageManager.AudioFilePath!.observe(.success, handler: { snapshot in
            
        })
        StorageManager.AudioFilePath!.observe(.failure, handler: { snapshot in
            if let error = snapshot.error as NSError? {
                switch (StorageErrorCode(rawValue: error.code)) {
                case .objectNotFound:
                    print("📕 Audio file does not exist")
                case .unauthorized:
                    print("📕 Audio upload permission denied")
                case .cancelled:
                    print("📕 Audio upload canceled")
                default:
                    print("📕 Audio upload failed. Please retry. \(error.localizedDescription)")
                }
            }
        })
        print("📙 Audio File Path: \(String(describing: StorageManager.AudioFilePath))")
        
    }
    
    public func uploadWavAudio(with beat:BeatData, url: URL, fileName: String, type: String, completion: @escaping UploadCompletion) {
        var beatAudioRef:StorageReference = storageRef
        if type == "beat" {
            beatAudioRef = storageRef.child("Beats").child(beat.priceType).child(beat.beatID).child("Beat Wav").child("TDDApp-IOS-audio-\(generateRandomNumber(digits: 16))-\(beat.beatID)")
        }
//        else if type == "instrumental" {
//            beatAudioRef = storageRef.child("Beats").child("Instrumentals").child(instrumentalRandomKey).child("Wav").child("TDDApp-IOS-audio-\(generateRandomNumber(digits: 16))-\(instrumentalRandomKey)")
//        }
        let metadata  = StorageMetadata()
        metadata.contentType = "audio/wav"
        StorageManager.AudioFilePath = beatAudioRef.putFile(from: url, metadata: nil, completion: {[weak self] metadata, error in
            guard let strongSelf = self else {return}
            guard error == nil else {
                print("📕 Failed to upload audio \(String(describing: error))")
                Utilities.showError2("Failed to upload audio.", actionText: "OK")
                completion(.failure(StorageErrors.failedToUpload))
                return
            }
            beatAudioRef.downloadURL(completion: {url, error in
                guard let url = url else {
                    print("📕 Failed to get audio download URL \(String(describing: error))")
                    Utilities.showError2("Failed to get audio download URL.", actionText: "OK")
                    completion(.failure(StorageErrors.failedToGetAudioDownloadURL))
                    return
                }
                
                let audioAsset = AVURLAsset.init(url: url, options: nil)
                let duration = audioAsset.duration
                let durationInSeconds = CMTimeGetSeconds(duration)
                let durationInSecondsRound = Int(roundf(Float(durationInSeconds))/1)
                let durationInMinues = strongSelf.timeFormatted(totalSeconds: durationInSecondsRound)
                StorageManager.beatDuration = durationInMinues
                print("📙 duration: \(StorageManager.beatDuration)")
                
                let urlString = url.absoluteString
                StorageManager.audioURL = urlString
                print("📙 download url: \(urlString)")
                completion(.success(urlString))
                
                return
            })
            
        })
        
        StorageManager.AudioFilePath!.observe(.resume, handler: { snapshot in
            print("📙 Audio Upload Starting")
        })
        StorageManager.AudioFilePath!.observe(.pause, handler: { snapshot in
            
        })
        StorageManager.AudioFilePath!.observe(.progress, handler: { snapshot in
            let percentageBase = Double(snapshot.progress!.completedUnitCount) / Double(snapshot.progress!.totalUnitCount)
            let percentage = Int(round(100 * percentageBase))
            
            print("📙 Audio upload percentage: \(percentage)")
        })
        StorageManager.AudioFilePath!.observe(.success, handler: { snapshot in
            
        })
        StorageManager.AudioFilePath!.observe(.failure, handler: { snapshot in
            if let error = snapshot.error as NSError? {
                switch (StorageErrorCode(rawValue: error.code)) {
                case .objectNotFound:
                    print("📕 Audio file does not exist")
                case .unauthorized:
                    print("📕 Audio upload permission denied")
                case .cancelled:
                    print("📕 Audio upload canceled")
                default:
                    print("📕 Audio upload failed. Please retry. \(error.localizedDescription)")
                }
            }
        })
        print("📙 Audio File Path: \(String(describing: StorageManager.AudioFilePath))")
        
    }
    
    public func uploadExclusiveFilesZip(with beat:BeatData, url: URL, fileName: String, type: String, completion: @escaping UploadCompletion) {
        var beatAudioRef:StorageReference = storageRef
        if type == "beat" {
            beatAudioRef = storageRef.child("Beats").child(beat.priceType).child(beat.beatID).child("Beat Exclusive Files").child("TDDApp-IOS-audio-\(generateRandomNumber(digits: 16))-\(beat.beatID)")
        }
//        else if type == "instrumental" {
//            beatAudioRef = storageRef.child("Beats").child("Instrumentals").child(instrumentalRandomKey).child("Wav").child("TDDApp-IOS-audio-\(generateRandomNumber(digits: 16))-\(instrumentalRandomKey)")
//        }
        let metadata  = StorageMetadata()
        metadata.contentType = ""
        StorageManager.AudioFilePath = beatAudioRef.putFile(from: url, metadata: nil, completion: {[weak self] metadata, error in
            guard let strongSelf = self else {return}
            guard error == nil else {
                print("📕 Failed to upload audio \(String(describing: error))")
                Utilities.showError2("Failed to upload audio.", actionText: "OK")
                completion(.failure(StorageErrors.failedToUpload))
                return
            }
            beatAudioRef.downloadURL(completion: {url, error in
                guard let url = url else {
                    print("📕 Failed to get audio download URL \(String(describing: error))")
                    Utilities.showError2("Failed to get audio download URL.", actionText: "OK")
                    completion(.failure(StorageErrors.failedToGetAudioDownloadURL))
                    return
                }
                
                let audioAsset = AVURLAsset.init(url: url, options: nil)
                let duration = audioAsset.duration
                let durationInSeconds = CMTimeGetSeconds(duration)
                let durationInSecondsRound = Int(roundf(Float(durationInSeconds))/1)
                let durationInMinues = strongSelf.timeFormatted(totalSeconds: durationInSecondsRound)
                StorageManager.beatDuration = durationInMinues
                print("📙 duration: \(StorageManager.beatDuration)")
                
                let urlString = url.absoluteString
                StorageManager.audioURL = urlString
                print("📙 download url: \(urlString)")
                completion(.success(urlString))
                
                return
            })
            
        })
        
        StorageManager.AudioFilePath!.observe(.resume, handler: { snapshot in
            print("📙 Audio Upload Starting")
        })
        StorageManager.AudioFilePath!.observe(.pause, handler: { snapshot in
            
        })
        StorageManager.AudioFilePath!.observe(.progress, handler: { snapshot in
            let percentageBase = Double(snapshot.progress!.completedUnitCount) / Double(snapshot.progress!.totalUnitCount)
            let percentage = Int(round(100 * percentageBase))
            
            print("📙 Audio upload percentage: \(percentage)")
        })
        StorageManager.AudioFilePath!.observe(.success, handler: { snapshot in
            
        })
        StorageManager.AudioFilePath!.observe(.failure, handler: { snapshot in
            if let error = snapshot.error as NSError? {
                switch (StorageErrorCode(rawValue: error.code)) {
                case .objectNotFound:
                    print("📕 Audio file does not exist")
                case .unauthorized:
                    print("📕 Audio upload permission denied")
                case .cancelled:
                    print("📕 Audio upload canceled")
                default:
                    print("📕 Audio upload failed. Please retry. \(error.localizedDescription)")
                }
            }
        })
        print("📙 Audio File Path: \(String(describing: StorageManager.AudioFilePath))")
        
    }
    
    public func uploadFile(url: URL, fileName: String, completion: @escaping UploadCompletion) {
        let FileRef = storageRef.child("Merch").child("Kits").child(fileName).child("File").child("TDDApp-IOS-file-\(generateRandomNumber(digits: 16))-\(fileName)")
//        else if type == "instrumental" {
//            beatAudioRef = storageRef.child("Beats").child("Instrumentals").child(instrumentalRandomKey).child("Wav").child("TDDApp-IOS-audio-\(generateRandomNumber(digits: 16))-\(instrumentalRandomKey)")
//        }
        let metadata  = StorageMetadata()
        metadata.contentType = ""
        StorageManager.AudioFilePath = FileRef.putFile(from: url, metadata: nil, completion: {[weak self] metadata, error in
            guard let strongSelf = self else {return}
            guard error == nil else {
                print("📕 Failed to upload audio \(String(describing: error))")
                Utilities.showError2("Failed to upload audio.", actionText: "OK")
                completion(.failure(StorageErrors.failedToUpload))
                return
            }
            FileRef.downloadURL(completion: {url, error in
                guard let url = url else {
                    print("📕 Failed to get audio download URL \(String(describing: error))")
                    Utilities.showError2("Failed to get audio download URL.", actionText: "OK")
                    completion(.failure(StorageErrors.failedToGetAudioDownloadURL))
                    return
                }
                
                let audioAsset = AVURLAsset.init(url: url, options: nil)
                let duration = audioAsset.duration
                let durationInSeconds = CMTimeGetSeconds(duration)
                let durationInSecondsRound = Int(roundf(Float(durationInSeconds))/1)
                let durationInMinues = strongSelf.timeFormatted(totalSeconds: durationInSecondsRound)
                
                let urlString = url.absoluteString
                print("📙 download url: \(urlString)")
                completion(.success(urlString))
                
                return
            })
            
        })
        
        StorageManager.AudioFilePath!.observe(.resume, handler: { snapshot in
            print("📙 Zip Upload Starting")
        })
        StorageManager.AudioFilePath!.observe(.pause, handler: { snapshot in
            
        })
        StorageManager.AudioFilePath!.observe(.progress, handler: { snapshot in
            if let snap = snapshot.progress {
            let percentageBase = Double(snap.completedUnitCount) / Double(snap.totalUnitCount)
            let percentage = Int(round(100 * percentageBase))
            
            print("📙 Zip upload percentage: \(percentage)")
            }
        })
        StorageManager.AudioFilePath!.observe(.success, handler: { snapshot in
            
        })
        StorageManager.AudioFilePath!.observe(.failure, handler: { snapshot in
            if let error = snapshot.error as NSError? {
                switch (StorageErrorCode(rawValue: error.code)) {
                case .objectNotFound:
                    print("📕 Zip file does not exist")
                case .unauthorized:
                    print("📕 Zip upload permission denied")
                case .cancelled:
                    print("📕 Zip upload canceled")
                default:
                    print("📕 Zip upload failed. Please retry. \(error.localizedDescription)")
                }
            }
        })
        print("📙 Audio File Path: \(String(describing: StorageManager.AudioFilePath))")
        
    }
    
    public func uploadHighlightReel(with url: URL, completion: @escaping UploadCompletion) {
        let reelRef = storageRef.child("HighLight Video").child("video")
        let videoFilePath = reelRef.putFile(from: url, metadata: nil, completion: { metadata, error in
            guard error == nil else {
                print("📕 Failed to upload image")
                Utilities.showError2("Failed to upload image.", actionText: "OK")
                completion(.failure(StorageErrors.failedToUpload))
                return
            }
            reelRef.downloadURL(completion: {url, error in
                guard let url = url else {
                    print("📕 Failed to get image download URL \(String(describing: error))")
                    Utilities.showError2("Failed to get image download URL.", actionText: "OK")
                    completion(.failure(StorageErrors.failedToGetImageDownloadURL))
                    return
                }
                
                let urlString = url.absoluteString
                print("📙 download url: \(urlString)")
                completion(.success(urlString))
                return
            })
            
        })
        
        videoFilePath.observe(.resume, handler: { snapshot in
            print("📙 Reel Upload Starting")
        })
        videoFilePath.observe(.pause, handler: { snapshot in
            
        })
        videoFilePath.observe(.progress, handler: { snapshot in
//            BeatUploadViewController.GlobalVariable.shapeLayer.strokeEnd = 0
            let percentageBase = Double(snapshot.progress!.completedUnitCount) / Double(snapshot.progress!.totalUnitCount)
            let percentage = Int(round(100 * percentageBase))
            
            print("📙 Reel Upload Percent: \(percentage)")
            
//            DispatchQueue.main.async {
//                BeatUploadViewController.GlobalVariable.statusLabel.text = "\(BeatUploadViewController.GlobalVariable.beatName) Image"
//                BeatUploadViewController.GlobalVariable.percentageLabel.text = String("\(percentage)%")
//                BeatUploadViewController.GlobalVariable.shapeLayer.strokeEnd = CGFloat(percentageBase)
//                BeatUploadViewController.GlobalVariable.shapeLayer.strokeColor = UIColor.init(red: 202/255, green: 0/255, blue: 3/255, alpha: 1).cgColor
//                BeatUploadViewController.GlobalVariable.pulsatingLayer.fillColor = UIColor.init(red: 182/255, green: 0/255, blue: 3/255, alpha: 0.75).cgColor
//                if percentage == 100{
//                    BeatUploadViewController.GlobalVariable.shapeLayer.strokeColor = UIColor.init(red: 0/255, green: 150/255, blue: 0/255, alpha: 0.9).cgColor
//                    BeatUploadViewController.GlobalVariable.pulsatingLayer.fillColor = UIColor.init(red: 0/255, green: 100/255, blue: 0/255, alpha: 0.75).cgColor
//                } else {
//                    BeatUploadViewController.GlobalVariable.shapeLayer.strokeColor = UIColor.init(red: 202/255, green: 0/255, blue: 3/255, alpha: 1).cgColor
//                    BeatUploadViewController.GlobalVariable.pulsatingLayer.fillColor = UIColor.init(red: 182/255, green: 0/255, blue: 3/255, alpha: 0.75).cgColor
//                }
//            }
        })
        videoFilePath.observe(.success, handler: { snapshot in
            
        })
        videoFilePath.observe(.failure, handler: { snapshot in
            
            if let error = snapshot.error as NSError? {
                switch (StorageErrorCode(rawValue: error.code)) {
                case .objectNotFound:
                    print("📕 Reel file does not exist")
                case .unauthorized:
                    print("📕 Reel upload permission denied")
                case .cancelled:
                    print("📕 Reel upload canceled")
                default:
                    print("📕 Reel upload failed. Please retry. \(error.localizedDescription)")
                }
            }
        })
        print("📙 Reel File Path: \(String(describing: StorageManager.ImageFilePath))")
        
    }
    
    public func getDownloadURL(_ path: String, completion: @escaping (Result<String, Error>) -> Void) {
        let reference = Storage.storage().reference().child(path)
        
        reference.downloadURL(completion: { url, error in
            guard let url = url, error == nil else {
                completion(.failure(StorageErrors.failedToGetImageDownloadURL))
                return
            }
            let urlString = url.absoluteString
            StorageManager.imageURL = urlString
            print("📙 download url: \(urlString)")
            completion(.success(urlString))
            return
        })
    }
    
    func generateRandomNumber(digits:Int) -> String {
        var number = String()
        for _ in 1...digits {
           number += "\(Int.random(in: 1...9))"
        }
        return number
    }
    
    func timeFormatted(totalSeconds: Int) -> String {
       let seconds: Int = totalSeconds % 60
       let minutes: Int = (totalSeconds / 60) % 60
       //let hours: Int = totalSeconds / 3600
       return String(format: "%02d:%02d", minutes, seconds)
    }
}

func generateRandomNumber(digits:Int) -> String {
    var number = String()
    for _ in 1...digits {
       number += "\(Int.random(in: 1...9))"
    }
    return number
}

enum StorageErrors: Error {
    case failedToUpload
    case failedToGetImageDownloadURL
    case failedToGetAudioDownloadURL
}


