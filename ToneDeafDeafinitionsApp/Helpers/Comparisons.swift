//
//  Comparisons.swift
//  ToneDeafDeafinitionsApp
//
//  Created by Tone Deaf on 8/19/20.
//  Copyright © 2020 GITEM Solutions. All rights reserved.
//

import Foundation

public class Comparisons {
    
    static let shared = Comparisons()
    
    func getSongYoutubeData(song:SongData, completion: @escaping (Array<VideoData>) -> Void) {
        var videosData:Array<VideoData> = []
        var val = 1
        for video in song.videos! {
            let word = video.split(separator: "Æ")
            let id = word[0]
            DatabaseManager.shared.findVideoById(videoid: String(id), completion: { selectedVideo in
                switch selectedVideo {
                case .success(let vid):
                    let video = vid as! VideoData
                    videosData.append(video)
                    if val == song.videos!.count {
//                        if song.name.contains("Slide") == true {
//                            
//                        }
                        completion(videosData)
                    }
                    val+=1
                case .failure(let error):
                    print("Video ID proccessing error \(error)")
                    return
                }
            })
        }
        
    }
    
    func getInstrumentalYoutubeData(instrumental:InstrumentalData, completion: @escaping (Array<YouTubeData>) -> Void) {
        var videosData:Array<YouTubeData> = []
        var val = 1
        for video in instrumental.videos! {
            let word = video.split(separator: "Æ")
            let id = word[0]
            DatabaseManager.shared.findVideoById(videoid: String(id), completion: { selectedVideo in
                switch selectedVideo {
                case .success(let vid):
                    let video = vid as! YouTubeData
                    videosData.append(video)
                    if val == instrumental.videos!.count {
//                        if song.name.contains("Slide") == true {
//
//                        }
                        completion(videosData)
                    }
                    val+=1
                case .failure(let error):
                    print("Video ID proccessing error \(error)")
                    return
                }
            })
        }
        
    }
    
    private func datefetch(_ videos: [YouTubeData],_ datearr:[Date], completion: @escaping (([Date]) -> Void))  {
        var tick = 1
        var dateArray = datearr
        for vid in videos {
            //print(vid.title)
            if vid.dateYT != "" {
                let songdate = vid.dateYT
                let date4 = songdate.date(format: "MM dd, yyyy")
                dateArray.append(date4!)
                if tick == videos.count {
                    //print(ldateArray)
                    completion(dateArray)
                }
                tick+=1
            }
        }
    }
    private func sortDates(_ datearr:[Date],_ dat:Date, completion: @escaping ((Date) -> Void))  {
        var tick = 1
        var dateArray = datearr
        var edate = dat
        for date in 0 ..< dateArray.count {
            if dateArray[date] < edate {
                edate = dateArray[date]
            }
            if tick == dateArray.count {
                completion(edate)
            }
            tick+=1
        }
    }
    
    private func ldatefetch(_ videos: [YouTubeData],_ ldatearr:[Date], completion: @escaping (([Date]) -> Void))  {
        var tick = 1
        var ldateArray = ldatearr
        if videos.count == 0 {
            completion(ldateArray)
        }
        for vid in videos {
            //print(vid.title)
            if vid.dateYT != "" {
                let songdate = vid.dateYT
                let date4 = songdate.date(format: "MM dd, yyyy")
                ldateArray.append(date4!)
                
                if tick == videos.count {
                    //print(ldateArray)
                    completion(ldateArray)
                }
                tick+=1
            }
        }
    }
    
    private func lsortDates(_ ldatearr:[Date],_ ldat:Date, completion: @escaping ((Date) -> Void))  {
        var tick = 1
        var ldateArray = ldatearr
        var ldate = ldat
        for date in 0 ..< ldateArray.count {
            if ldateArray[date] < ldate {
                ldate = ldateArray[date]
            }
            
            if tick == ldateArray.count {
                
                completion(ldate)
            }
            tick+=1
        }
    }
    
    func getEarliestReleaseDate(song: SongData, completion: @escaping ((String) -> Void))  {
        var earliestDate = ""
        var dateArray:[Date] = []
        var edate = Date()
        var date1:Date?
        var date2:Date?
        var date3:Date?
        var date4:Date?
        var date5:Date?
        var date6:Date?
        if song.spotify?.spotifyDateSPT != "" {
            let songdate = song.spotify!.spotifyDateSPT
            //print(songdate)
            date1 = songdate.date(format: "MM dd, yyyy")
            dateArray.append(date1!)
        }
        
        if song.soundcloud?.releaseDate != nil {
            
            guard let songdate = song.soundcloud?.releaseDate else {
                fatalError()
            }
            //print(songdate)
            date2 = songdate.date(format: "MM dd, yyyy")
            dateArray.append(date2!)
        }
        if song.spinrilla?.releaseDate != nil {
            guard let songdate = song.spinrilla?.releaseDate else {
                fatalError()
            }
            //print(songdate)
            date3 = songdate.date(format: "MM dd, yyyy")
            dateArray.append(date3!)
        }
        if song.officialVideo != nil {
//            getSongYoutubeData(song: song, completion: {[weak self] videos in
//                guard let strongSelf = self else {return}
//                strongSelf.datefetch(videos, dateArray, completion: { dates in
//                    dateArray = dates
//
//                strongSelf.sortDates(dateArray, edate, completion: {dat in
//                    edate = dat
//                        let formatter = DateFormatter()
//                        formatter.dateStyle = .long
//                        earliestDate = formatter.string(from: edate)
//                        //print(earliestDate)
//                        completion(earliestDate)
//                    })
//                })
//            })
        }
        if song.audioVideo != nil {
            
        }
        if song.lyricVideo != nil {
            
        }
        else {
            if song.name == "Dream" {
                print(dateArray)
                print(edate)
                
            }
            sortDates(dateArray, edate, completion: {[weak self] dat in
                guard let strongSelf = self else {return}
                edate = dat
                let formatter = DateFormatter()
                formatter.dateStyle = .long
                earliestDate = formatter.string(from: edate)
                //print(earliestDate)
                
                completion(earliestDate)
            })
        }
    }
    
    func getEarliestReleaseDate(instrumental: InstrumentalData, completion: @escaping ((String) -> Void))  {
        var earliestDate = ""
        var dateArray:[Date] = []
        var edate = Date()
        var date1:Date?
        var date2:Date?
        var date3:Date?
        var date4:Date?
        var date5:Date?
        var date6:Date?
        if instrumental.spotify?.spotifyDateSPT != "" {
            let songdate = instrumental.spotify?.spotifyDateSPT 
            //print(songdate)
            date1 = songdate!.date(format: "MM dd, yyyy")
            dateArray.append(date1!)
        }
        if instrumental.dateRegisteredToApp != "" {
            let songdate = instrumental.dateRegisteredToApp
            //print(songdate)
            date2 = songdate?.date(format: "MM dd, yyyy")
            dateArray.append(date2!)
        }
        if instrumental.soundcloud?.releaseDate != nil {
            guard let songdate = instrumental.soundcloud?.releaseDate else {
                fatalError()
            }
            //print(songdate)
            date3 = songdate.date(format: "MM dd, yyyy")
            dateArray.append(date3!)
        }
        if instrumental.spinrilla?.releaseDate != nil {
            guard let songdate = instrumental.spinrilla?.releaseDate else {
                fatalError()
            }
            //print(songdate)
            date4 = songdate.date(format: "MM dd, yyyy")
            dateArray.append(date4!)
        }
        if instrumental.videos != [""] {
            getInstrumentalYoutubeData(instrumental: instrumental, completion: {[weak self] videos in
                guard let strongSelf = self else {return}
                strongSelf.datefetch(videos, dateArray, completion: { dates in
                    dateArray = dates
                
                strongSelf.sortDates(dateArray, edate, completion: {dat in
                    edate = dat
                        let formatter = DateFormatter()
                        formatter.dateStyle = .long
                        earliestDate = formatter.string(from: edate)
                        //print(earliestDate)
                        completion(earliestDate)
                    })
                })
            })
        } else {
            sortDates(dateArray, edate, completion: {[weak self] dat in
                guard let strongSelf = self else {return}
                edate = dat
                let formatter = DateFormatter()
                formatter.dateStyle = .long
                earliestDate = formatter.string(from: edate)
                //print(earliestDate)
                
                completion(earliestDate)
            })
        }
    }
    
    func getEarliestReleaseDate(video: VideoData, completion: @escaping ((String) -> Void))  {
        var earliestDate = ""
        var dateArray:[Date] = []
        var edate = Date()
        var date1:Date?
        var date2:Date?
        var date3:Date?
        var date4:Date?
        var date5:Date?
        var date6:Date?
        if video.youtube != nil {
            for vid in video.youtube! {
                let songdate = vid.dateYT
                date1 = songdate.date(format: "MM dd, yyyy")
                dateArray.append(date1!)
            }
        }
        if video.appleMusic != nil {
            for vid in video.appleMusic! {
                let songdate = vid.dateApple
                date1 = songdate.date(format: "MM dd, yyyy")
                dateArray.append(date1!)
            }
        }
        if video.twitter != nil {
            for vid in video.twitter! {
                let songdate = vid.dateTwitter!
                date1 = songdate.date(format: "MM dd, yyyy")
                dateArray.append(date1!)
            }
        }
        if video.youtube == nil && video.appleMusic == nil && video.twitter == nil {
            let songdate = video.dateIA
            date1 = songdate.date(format: "MM dd, yyyy")
            dateArray.append(date1!)
        }
        sortDates(dateArray, edate, completion: {[weak self] dat in
            guard let strongSelf = self else {return}
            edate = dat
            let formatter = DateFormatter()
            formatter.dateStyle = .long
            earliestDate = formatter.string(from: edate)
            //print(earliestDate)
            
            completion(earliestDate)
        })
    }
    
    func getEarliestReleaseDate(album: AlbumData, completion: @escaping ((String) -> Void))  {
        var earliestDate = ""
        var dateArray:[Date] = []
        var edate = Date()
        var date1:Date?
        var date2:Date?
        var date3:Date?
        var date4:Date?
        var date5:Date?
        var date6:Date?
        if album.spotify?.dateReleasedSpotify != "" {
            let songdate = album.spotify!.dateReleasedSpotify
            //print(songdate)
            date1 = songdate.date(format: "MM dd, yyyy")
            dateArray.append(date1!)
        }
        
        if album.soundcloud?.releaseDate != nil {
            
            guard let songdate = album.soundcloud?.releaseDate else {
                fatalError()
            }
            //print(songdate)
            date2 = songdate.date(format: "MM dd, yyyy")
            dateArray.append(date2!)
        }
        if album.spinrilla?.releaseDate != nil {
            guard let songdate = album.spinrilla?.releaseDate else {
                fatalError()
            }
            //print(songdate)
            date3 = songdate.date(format: "MM dd, yyyy")
            dateArray.append(date3!)
        }
//        if album.officialAlbumVideo != nil {
//            getSongYoutubeData(song: song, completion: {[weak self] videos in
//                guard let strongSelf = self else {return}
//                strongSelf.datefetch(videos, dateArray, completion: { dates in
//                    dateArray = dates
//
//                strongSelf.sortDates(dateArray, edate, completion: {dat in
//                    edate = dat
//                        let formatter = DateFormatter()
//                        formatter.dateStyle = .long
//                        earliestDate = formatter.string(from: edate)
//                        //print(earliestDate)
//                        completion(earliestDate)
//                    })
//                })
//            })
//        }
//        else {
            sortDates(dateArray, edate, completion: {[weak self] dat in
                guard let strongSelf = self else {return}
                edate = dat
                let formatter = DateFormatter()
                formatter.dateStyle = .long
                earliestDate = formatter.string(from: edate)
                //print(earliestDate)
                
                completion(earliestDate)
            })
//        }
    }
    
    func getLatestReleaseDate(song: SongData, completion: @escaping ((Date) -> Void))  {
        var ldateArray:[Date] = []
        var ldate = Date()
        var latestDate = ""
        var date1:Date?
        var date2:Date?
        var date3:Date?
        var date4:Date?
        var date5:Date?
        var date6:Date?
        if song.spotify?.spotifyDateSPT != "" {
            ldateArray = []
            let songdate = song.spotify!.spotifyDateSPT
            //print(songdate)
            date1 = songdate.date(format: "MM dd, yyyy")
            ldateArray.append(date1!)
        }
        if song.soundcloud?.releaseDate != nil {
            
            guard let songdate = song.soundcloud?.releaseDate else {
                fatalError()
            }
            //print(songdate)
            date2 = songdate.date(format: "MM dd, yyyy")
            ldateArray.append(date2!)
        }
        if song.spinrilla?.releaseDate != nil {
            guard let songdate = song.spinrilla?.releaseDate else {
                fatalError()
            }
            //print(songdate)
            date3 = songdate.date(format: "MM dd, yyyy")
            ldateArray.append(date3!)
        }
//        if !song.videos!.isEmpty {
//            if song.videos![0] != "" {
//                getSongYoutubeData(song: song, completion: {[weak self] videos in
//                    guard let strongSelf = self else {return}
//                    strongSelf.ldatefetch(videos, ldateArray, completion: { dates in
//                        ldateArray = dates
//                        strongSelf.lsortDates(ldateArray, ldate, completion: {dat in
//                            ldate = dat
//                            let formatter = DateFormatter()
//                            formatter.dateStyle = .long
//                            latestDate = formatter.string(from: ldate)
//                            completion(ldate)
//                        })
//                    })
//                })
//            } else {
//                lsortDates(ldateArray, ldate, completion: {[weak self] dat in
//
//                    guard let strongSelf = self else {return}
//                    ldate = dat
//                    let formatter = DateFormatter()
//                    formatter.dateStyle = .long
//                    latestDate = formatter.string(from: ldate)
//                    //print(strongSelf.ldate)
//                    completion(ldate)
//                })
//            }
//        }
//        else {
            lsortDates(ldateArray, ldate, completion: {[weak self] dat in
                
                guard let strongSelf = self else {return}
                ldate = dat
                let formatter = DateFormatter()
                formatter.dateStyle = .long
                latestDate = formatter.string(from: ldate)
                //print(strongSelf.ldate)
                completion(ldate)
            })
//        }
        
        //print(latestDate)
    }
    
    func getLatestReleaseDate(video: VideoData, completion: @escaping ((Date) -> Void))  {
        var ldateArray:[Date] = []
        var ldate = Date()
        var latestDate = ""
        var date1:Date?
        var date2:Date?
        var date3:Date?
        var date4:Date?
        var date5:Date?
        var date6:Date?
        
        if video.youtube != nil {
            for vid in video.youtube! {
                let songdate = vid.dateYT
                date1 = songdate.date(format: "MM dd, yyyy")
                ldateArray.append(date1!)
            }
        }
        if video.appleMusic != nil {
            for vid in video.appleMusic! {
                let songdate = vid.dateApple
                date1 = songdate.date(format: "MM dd, yyyy")
                ldateArray.append(date1!)
            }
        }
        if video.twitter != nil {
            for vid in video.twitter! {
                let songdate = vid.dateTwitter!
                date1 = songdate.date(format: "MM dd, yyyy")
                ldateArray.append(date1!)
            }
        }
        if video.youtube == nil && video.appleMusic == nil  && video.twitter == nil {
            let songdate = video.dateIA
            date1 = songdate.date(format: "MM dd, yyyy")
            ldateArray.append(date1!)
        }
//        if !song.videos!.isEmpty {
//            if song.videos![0] != "" {
//                getSongYoutubeData(song: song, completion: {[weak self] videos in
//                    guard let strongSelf = self else {return}
//                    strongSelf.ldatefetch(videos, ldateArray, completion: { dates in
//                        ldateArray = dates
//                        strongSelf.lsortDates(ldateArray, ldate, completion: {dat in
//                            ldate = dat
//                            let formatter = DateFormatter()
//                            formatter.dateStyle = .long
//                            latestDate = formatter.string(from: ldate)
//                            completion(ldate)
//                        })
//                    })
//                })
//            } else {
//                lsortDates(ldateArray, ldate, completion: {[weak self] dat in
//
//                    guard let strongSelf = self else {return}
//                    ldate = dat
//                    let formatter = DateFormatter()
//                    formatter.dateStyle = .long
//                    latestDate = formatter.string(from: ldate)
//                    //print(strongSelf.ldate)
//                    completion(ldate)
//                })
//            }
//        }
//        else {
            lsortDates(ldateArray, ldate, completion: {[weak self] dat in
                
                guard let strongSelf = self else {return}
                ldate = dat
                let formatter = DateFormatter()
                formatter.dateStyle = .long
                latestDate = formatter.string(from: ldate)
                //print(strongSelf.ldate)
                completion(ldate)
            })
//        }
        
        //print(latestDate)
    }
    
    func getLatestReleaseDate(album: AlbumData, completion: @escaping ((Date) -> Void))  {
        var ldateArray:[Date] = []
        var ldate = Date()
        var latestDate = ""
        var date1:Date?
        var date2:Date?
        var date3:Date?
        var date4:Date?
        var date5:Date?
        var date6:Date?
        if album.spotify?.dateReleasedSpotify != "" {
            ldateArray = []
            let songdate = album.spotify!.dateReleasedSpotify
            //print(songdate)
            date1 = songdate.date(format: "MM dd, yyyy")
            ldateArray.append(date1!)
        }
        if album.soundcloud?.releaseDate != nil {
            
            guard let songdate = album.soundcloud?.releaseDate else {
                fatalError()
            }
            //print(songdate)
            date2 = songdate.date(format: "MM dd, yyyy")
            ldateArray.append(date2!)
        }
        if album.spinrilla?.releaseDate != nil {
            guard let songdate = album.spinrilla?.releaseDate else {
                fatalError()
            }
            //print(songdate)
            date3 = songdate.date(format: "MM dd, yyyy")
            ldateArray.append(date3!)
        }
//        if !song.videos!.isEmpty {
//            if song.videos![0] != "" {
//                getSongYoutubeData(song: song, completion: {[weak self] videos in
//                    guard let strongSelf = self else {return}
//                    strongSelf.ldatefetch(videos, ldateArray, completion: { dates in
//                        ldateArray = dates
//                        strongSelf.lsortDates(ldateArray, ldate, completion: {dat in
//                            ldate = dat
//                            let formatter = DateFormatter()
//                            formatter.dateStyle = .long
//                            latestDate = formatter.string(from: ldate)
//                            completion(ldate)
//                        })
//                    })
//                })
//            } else {
//                lsortDates(ldateArray, ldate, completion: {[weak self] dat in
//
//                    guard let strongSelf = self else {return}
//                    ldate = dat
//                    let formatter = DateFormatter()
//                    formatter.dateStyle = .long
//                    latestDate = formatter.string(from: ldate)
//                    //print(strongSelf.ldate)
//                    completion(ldate)
//                })
//            }
//        }
//        else {
            lsortDates(ldateArray, ldate, completion: {[weak self] dat in
                
                guard let strongSelf = self else {return}
                ldate = dat
                let formatter = DateFormatter()
                formatter.dateStyle = .long
                latestDate = formatter.string(from: ldate)
                //print(strongSelf.ldate)
                completion(ldate)
            })
//        }
        
        //print(latestDate)
    }
}

extension String {
func date(format: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.timeZone = TimeZone(identifier: "EDT")
        let date = dateFormatter.date(from: self)
        return date
    }
}
