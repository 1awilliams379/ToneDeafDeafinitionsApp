//
//  CView.swift
//  ToneDeafDeafinitionsApp
//
//  Created by Tone Deaf on 8/15/20.
//  Copyright © 2020 GITEM Solutions. All rights reserved.
//

import Foundation
import SwiftUI
import Combine
import SkeletonUI
import MarqueeLabel
import CDAlertView

var cViewMainMusicName = ""
var dashboardLatestContentArrayViews:[AnyView] = []

struct CView: View {
    
    var body: some View {
        
        CarouselView(itemHeight: 375, views: [
            AnyView(FeaturedMusicViewContent(array: MusicMainInfiniteScrollContentFeaturedArray1, view: "CVIEW")),
            AnyView(FeaturedMusicViewContent(array: MusicMainInfiniteScrollContentFeaturedArray2, view: "CVIEW")),
            AnyView(FeaturedMusicViewContent(array: MusicMainInfiniteScrollContentFeaturedArray3, view: "CVIEW")),
            AnyView(FeaturedMusicViewContent(array: MusicMainInfiniteScrollContentFeaturedArray4, view: "CVIEW")),
            AnyView(FeaturedMusicViewContent(array: MusicMainInfiniteScrollContentFeaturedArray5, view: "CVIEW")),
            AnyView(FeaturedMusicViewContent(array: MusicMainInfiniteScrollContentFeaturedArray6, view: "CVIEW")),
            AnyView(FeaturedMusicViewContent(array: MusicMainInfiniteScrollContentFeaturedArray7, view: "CVIEW"))
        ]).frame(width: 300, height: 375, alignment: .center)
    }
}

struct LatestView: View {
    
    var body: some View {
        
        CarouselView(itemHeight: 375, views: dashboardLatestContentArrayViews).frame(width: 300, height: 375, alignment: .center)
    }
}

struct Bottom: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.addRoundedRect(in: rect, cornerSize: CGSize(width: 5, height: 5))
        return path
    }
}


struct FeaturedMusicViewContent: View {
    var array:Array<Any>
    var view:String
    @State var uimage = Image("tonedeaflogo")
    @State var artistImageURLs:Array<String> = []
    @State private var scale: CGFloat = 1.0
    @GestureState private var isTapped = false
    @State private var favorited:Bool = false
    
    var timer:Timer {
        Timer.scheduledTimer(withTimeInterval: 2.0, repeats: false) { (timer) in
            audiofreeze = false
            print("Audio Freeze Off")
            playerTimer.invalidate()
        }
    }
    
    var body: some View {
        ZStack{
            Bottom().trim(from: 0, to: 0.5).offset(x: 0, y: 6).fill(Color(red: 25 / 255, green: 25 / 255, blue: 25 / 255)).frame(width: 300, height: 375, alignment: .bottom)
            VStack(spacing: 10) {
                        HStack {
                            (AsyncImage(url: URL(string: array[1] as! String)!,placeholder: Image("tonedeaflogo").resizable())).aspectRatio(contentMode: .fill).frame(width: 175, height: 175, alignment: .center).cornerRadius(4).shadow(color: .black, radius: 10, x: 5, y: 5)
                            VStack(alignment: .trailing, spacing: 10) {
                                ScrollView(.vertical, showsIndicators: false) {
                                    //Artist
                                    if ((array[6] as! Array<String>).indices.contains(0)) && ((array[6] as! Array<String>)[0]) != "" {
                                        Button(action: {
                                            DispatchQueue.global(qos: .userInitiated).async {
                                                var artid = (self.array[7] as! Array<String>)[0]
                                                if artid.contains("Æ") {
                                                    let word = (self.array[7] as! Array<String>)[0].split(separator: "Æ")
                                                    let id = word[0]
                                                    artid = String(id)
                                                }
                                                DatabaseManager.shared.fetchArtistData(artist: artid, completion: { selectedArtist in
                                                    if self.view == "CVIEW" {

                                                        currentMusicArtistInfo = selectedArtist
                                                        NotificationCenter.default.post(name: transitionFromMusicToArtistInfoNotify, object: selectedArtist)
                                                    }
                                                    if self.view == "LATEST" {
                                                        currentDashboardArtistInfo = selectedArtist
                                                        NotificationCenter.default.post(name: transitionFromDashboardToArtistInfoNotify, object: selectedArtist)
                                                    }
                                                })
                                            }
                                        }, label: {
                                            AsyncImage(url: URL(string: (array[6] as! Array<String>)[0])!, placeholder: Image("tonedeaflogo")
                                                .resizable())
                                                .aspectRatio(contentMode: .fill)
                                                .frame(width: 85, height: 85, alignment: .center)
                                            }).background(Color.gray)
                                            .cornerRadius(42.5)
                                            .buttonStyle(PlainButtonStyle())
                                        .buttonStyle(ScaleButtonStyle())
                                    }

                                    if ((array[6] as! Array<String>).indices.contains(1)) && ((array[6] as! Array<String>)[1]) != "" {
                                        Button(action: {
                                            DispatchQueue.global(qos: .userInitiated).async {
                                                var artid = (self.array[7] as! Array<String>)[1]
                                                if artid.contains("Æ") {
                                                    let word = (self.array[7] as! Array<String>)[1].split(separator: "Æ")
                                                    let id = word[0]
                                                    artid = String(id)
                                                }
                                                DatabaseManager.shared.fetchArtistData(artist: artid, completion: { selectedArtist in
                                                    if self.view == "CVIEW" {

                                                        currentMusicArtistInfo = selectedArtist
                                                        NotificationCenter.default.post(name: transitionFromMusicToArtistInfoNotify, object: selectedArtist)
                                                    }
                                                    if self.view == "LATEST" {
                                                        currentDashboardArtistInfo = selectedArtist
                                                        NotificationCenter.default.post(name: transitionFromDashboardToArtistInfoNotify, object: selectedArtist)
                                                    }
                                                })
                                            }
                                        }, label: {

                                            AsyncImage(url: URL(string: (array[6] as! Array<String>)[1])!, placeholder: Image("tonedeaflogo")
                                                .resizable())
                                                .aspectRatio(contentMode: .fill)
                                                .frame(width: 85, height: 85, alignment: .center)
                                            }).background(Color.gray)
                                            .cornerRadius(42.5)
                                            .buttonStyle(PlainButtonStyle())
                                    }

                                    if ((array[6] as! Array<String>).indices.contains(2)) && ((array[6] as! Array<String>)[2]) != "" {
                                        Button(action: {
                                            DispatchQueue.global(qos: .userInitiated).async {
                                                var artid = (self.array[7] as! Array<String>)[2]
                                                if artid.contains("Æ") {
                                                    let word = (self.array[7] as! Array<String>)[2].split(separator: "Æ")
                                                    let id = word[0]
                                                    artid = String(id)
                                                }
                                                DatabaseManager.shared.fetchArtistData(artist: artid, completion: { selectedArtist in
                                                    if self.view == "CVIEW" {

                                                        currentMusicArtistInfo = selectedArtist
                                                        NotificationCenter.default.post(name: transitionFromMusicToArtistInfoNotify, object: selectedArtist)
                                                    }
                                                    if self.view == "LATEST" {
                                                        currentDashboardArtistInfo = selectedArtist
                                                        NotificationCenter.default.post(name: transitionFromDashboardToArtistInfoNotify, object: selectedArtist)
                                                    }
                                                })
                                            }
                                        }, label: {
                                            AsyncImage(url: URL(string: (array[6] as! Array<String>)[2])!, placeholder: Image("tonedeaflogo")
                                                .resizable())
                                                .aspectRatio(contentMode: .fill)
                                                .frame(width: 85, height: 85, alignment: .center)
                                            }).background(Color.gray)
                                            .cornerRadius(42.5)
                                            .buttonStyle(PlainButtonStyle())
                                    }
                                    if ((array[6] as! Array<String>).indices.contains(3)) && ((array[6] as! Array<String>)[3]) != "" {
                                        Button(action: {
                                            DispatchQueue.global(qos: .userInitiated).async {
                                                var artid = (self.array[7] as! Array<String>)[3]
                                                if artid.contains("Æ") {
                                                    let word = (self.array[7] as! Array<String>)[3].split(separator: "Æ")
                                                    let id = word[0]
                                                    artid = String(id)
                                                }
                                                DatabaseManager.shared.fetchArtistData(artist: artid, completion: { selectedArtist in
                                                    if self.view == "CVIEW" {

                                                        currentMusicArtistInfo = selectedArtist
                                                        NotificationCenter.default.post(name: transitionFromMusicToArtistInfoNotify, object: selectedArtist)
                                                    }
                                                    if self.view == "LATEST" {
                                                        currentDashboardArtistInfo = selectedArtist
                                                        NotificationCenter.default.post(name: transitionFromDashboardToArtistInfoNotify, object: selectedArtist)
                                                    }
                                                })
                                            }
                                        }, label: {
                                            AsyncImage(url: URL(string: (array[6] as! Array<String>)[3])!, placeholder: Image("tonedeaflogo")
                                                .resizable())
                                                .aspectRatio(contentMode: .fill)
                                                .frame(width: 85, height: 85, alignment: .center)
                                            }).background(Color.gray)
                                            .cornerRadius(42.5)
                                            .buttonStyle(PlainButtonStyle())
                                    }
                                    if ((array[6] as! Array<String>).indices.contains(4)) && ((array[6] as! Array<String>)[4]) != "" {
                                        Button(action: {
                                            DispatchQueue.global(qos: .userInitiated).async {
                                                var artid = (self.array[7] as! Array<String>)[4]
                                                if artid.contains("Æ") {
                                                    let word = (self.array[7] as! Array<String>)[4].split(separator: "Æ")
                                                    let id = word[0]
                                                    artid = String(id)
                                                }
                                                DatabaseManager.shared.fetchArtistData(artist: artid, completion: { selectedArtist in
                                                    if self.view == "CVIEW" {

                                                        currentMusicArtistInfo = selectedArtist
                                                        NotificationCenter.default.post(name: transitionFromMusicToArtistInfoNotify, object: selectedArtist)
                                                    }
                                                    if self.view == "LATEST" {
                                                        currentDashboardArtistInfo = selectedArtist
                                                        NotificationCenter.default.post(name: transitionFromDashboardToArtistInfoNotify, object: selectedArtist)
                                                    }
                                                })
                                            }
                                        }, label: {
                                            AsyncImage(url: URL(string: (array[6] as! Array<String>)[4])!, placeholder: Image("tonedeaflogo")
                                                .resizable())
                                                .aspectRatio(contentMode: .fill)
                                                .frame(width: 85, height: 85, alignment: .center)
                                            }).background(Color.gray)
                                            .cornerRadius(42.5)
                                            .buttonStyle(PlainButtonStyle())
                                    }
                                    if ((array[6] as! Array<String>).indices.contains(5)) && ((array[6] as! Array<String>)[5]) != "" {
                                        Button(action: {
                                            DispatchQueue.global(qos: .userInitiated).async {
                                                var artid = (self.array[7] as! Array<String>)[5]
                                                if artid.contains("Æ") {
                                                    let word = (self.array[7] as! Array<String>)[5].split(separator: "Æ")
                                                    let id = word[0]
                                                    artid = String(id)
                                                }
                                                DatabaseManager.shared.fetchArtistData(artist: artid, completion: { selectedArtist in
                                                    if self.view == "CVIEW" {

                                                        currentMusicArtistInfo = selectedArtist
                                                        NotificationCenter.default.post(name: transitionFromMusicToArtistInfoNotify, object: selectedArtist)
                                                    }
                                                    if self.view == "LATEST" {
                                                        currentDashboardArtistInfo = selectedArtist
                                                        NotificationCenter.default.post(name: transitionFromDashboardToArtistInfoNotify, object: selectedArtist)
                                                    }
                                                })
                                            }
                                        }, label: {
                                            AsyncImage(url: URL(string: (array[6] as! Array<String>)[5])!, placeholder: Image("tonedeaflogo")
                                                .resizable())
                                                .aspectRatio(contentMode: .fill)
                                                .frame(width: 85, height: 85, alignment: .center)
                                            }).background(Color.gray)
                                            .cornerRadius(42.5)
                                            .buttonStyle(PlainButtonStyle())
                                    }
                                    //Producer
                                    if ((array[9] as! Array<String>).indices.contains(0)) && ((array[9] as! Array<String>)[0]) != "" {
                                        if !(array[7] as! Array<String>).contains((array[10] as! Array<String>)[0]) {
                                            Button(action: {
                                                DispatchQueue.global(qos: .userInitiated).async {
                                                    var proid = (self.array[10] as! Array<String>)[0]
                                                    if proid.contains("Æ") {
                                                        let word = (self.array[10] as! Array<String>)[0].split(separator: "Æ")
                                                        let id = word[0]
                                                        proid = String(id)
                                                    }
                                                    DatabaseManager.shared.fetchPersonData(person: proid, completion: { selectedProducer in
                                                        if self.view == "CVIEW" {
                                                            //                                                        currentMusicProducerInfo = selectedProducer
                                                            NotificationCenter.default.post(name: transitionFromMusicToProducerInfoNotify, object: selectedProducer)
                                                        }
                                                        if self.view == "LATEST" {
                                                            //                                                        currentDashboardProducerInfo = selectedProducer
                                                            NotificationCenter.default.post(name: transitionFromDashboardToProducerInfoNotify, object: selectedProducer)
                                                        }
                                                    })
                                                }
                                            }, label: {
                                                AsyncImage(url: URL(string: (array[9] as! Array<String>)[0])!, placeholder: Image("tonedeaflogo")
                                                    .resizable())
                                                .aspectRatio(contentMode: .fill)
                                                .frame(width: 85, height: 85, alignment: .center)
                                            }).background(Color.gray)
                                                .cornerRadius(42.5)
                                                .buttonStyle(PlainButtonStyle())
                                        }
                                    }
                                    if ((array[9] as! Array<String>).indices.contains(1)) && ((array[9] as! Array<String>)[1]) != "" {
                                        if !(array[7] as! Array<String>).contains((array[10] as! Array<String>)[1]) {
                                            Button(action: {
                                                DispatchQueue.global(qos: .userInitiated).async {
                                                    var proid = (self.array[10] as! Array<String>)[1]
                                                    if proid.contains("Æ") {
                                                        let word = (self.array[10] as! Array<String>)[1].split(separator: "Æ")
                                                        let id = word[0]
                                                        proid = String(id)
                                                    }
                                                    DatabaseManager.shared.fetchPersonData(person: proid, completion: { selectedProducer in
                                                        if self.view == "CVIEW" {
                                                            //                                                        currentMusicProducerInfo = selectedProducer
                                                            NotificationCenter.default.post(name: transitionFromMusicToProducerInfoNotify, object: selectedProducer)
                                                        }
                                                        if self.view == "LATEST" {
                                                            //                                                        currentDashboardProducerInfo = selectedProducer
                                                            NotificationCenter.default.post(name: transitionFromDashboardToProducerInfoNotify, object: selectedProducer)
                                                        }
                                                    })
                                                }
                                            }, label: {
                                                AsyncImage(url: URL(string: (array[9] as! Array<String>)[1])!, placeholder: Image("tonedeaflogo")
                                                    .resizable())
                                                .aspectRatio(contentMode: .fill)
                                                .frame(width: 85, height: 85, alignment: .center)
                                            }).background(Color.gray)
                                                .cornerRadius(42.5)
                                                .buttonStyle(PlainButtonStyle())
                                        }
                                    }
                                    if ((array[9] as! Array<String>).indices.contains(2)) && ((array[9] as! Array<String>)[2]) != "" {
                                        if !(array[7] as! Array<String>).contains((array[10] as! Array<String>)[2]) {
                                            Button(action: {
                                                DispatchQueue.global(qos: .userInitiated).async {
                                                    var proid = (self.array[10] as! Array<String>)[2]
                                                    if proid.contains("Æ") {
                                                        let word = (self.array[10] as! Array<String>)[2].split(separator: "Æ")
                                                        let id = word[0]
                                                        proid = String(id)
                                                    }
                                                    DatabaseManager.shared.fetchPersonData(person: proid, completion: { selectedProducer in
                                                        if self.view == "CVIEW" {
                                                            //                                                        currentMusicProducerInfo = selectedProducer
                                                            NotificationCenter.default.post(name: transitionFromMusicToProducerInfoNotify, object: selectedProducer)
                                                        }
                                                        if self.view == "LATEST" {
                                                            //                                                        currentDashboardProducerInfo = selectedProducer
                                                            NotificationCenter.default.post(name: transitionFromDashboardToProducerInfoNotify, object: selectedProducer)
                                                        }
                                                    })
                                                }
                                            }, label: {
                                                AsyncImage(url: URL(string: (array[9] as! Array<String>)[2])!, placeholder: Image("tonedeaflogo")
                                                    .resizable())
                                                .aspectRatio(contentMode: .fill)
                                                .frame(width: 85, height: 85, alignment: .center)
                                            }).background(Color.gray)
                                                .cornerRadius(42.5)
                                                .buttonStyle(PlainButtonStyle())
                                        }
                                    }
                                    if ((array[9] as! Array<String>).indices.contains(3)) && ((array[9] as! Array<String>)[3]) != "" {
                                        if !(array[7] as! Array<String>).contains((array[10] as! Array<String>)[3]) {
                                            Button(action: {
                                                DispatchQueue.global(qos: .userInitiated).async {
                                                    var proid = (self.array[10] as! Array<String>)[3]
                                                    if proid.contains("Æ") {
                                                        let word = (self.array[10] as! Array<String>)[3].split(separator: "Æ")
                                                        let id = word[0]
                                                        proid = String(id)
                                                    }
                                                    DatabaseManager.shared.fetchPersonData(person: proid, completion: { selectedProducer in
                                                        if self.view == "CVIEW" {
                                                            //                                                        currentMusicProducerInfo = selectedProducer
                                                            NotificationCenter.default.post(name: transitionFromMusicToProducerInfoNotify, object: selectedProducer)
                                                        }
                                                        if self.view == "LATEST" {
                                                            //                                                        currentDashboardProducerInfo = selectedProducer
                                                            NotificationCenter.default.post(name: transitionFromDashboardToProducerInfoNotify, object: selectedProducer)
                                                        }
                                                    })
                                                }
                                            }, label: {
                                                AsyncImage(url: URL(string: (array[9] as! Array<String>)[3])!, placeholder: Image("tonedeaflogo")
                                                    .resizable())
                                                .aspectRatio(contentMode: .fill)
                                                .frame(width: 85, height: 85, alignment: .center)
                                            }).background(Color.gray)
                                                .cornerRadius(42.5)
                                                .buttonStyle(PlainButtonStyle())
                                        }
                                    }

                                }.frame(width: 85, height: 175)

                            }

                        }.padding(.top, -20)
                        Divider()
                VStack(spacing: 5) {
                            HStack {
                                Text(array[0] as? String).lineLimit(1).foregroundColor(Color.white).font(.custom("AvenirNextCondensed-DemiBold", size: 22)).skeleton(with: array.isEmpty)
                                Spacer()
                                Button(action: {

                                }, label: {
                                    Image(systemName: "heart").resizable().frame(width: 25, height: 25, alignment: .center).foregroundColor(Color.white)
                                }).foregroundColor(Color.white).buttonStyle(ScaleButtonStyle())
                                if array[3] as! String != "" {
                                    Button(action: {
                                        if audiofreeze != true {
                                            playerTimer = self.timer
                                            var youtubeAlts:[String] = []
                                            let song = SongData(toneDeafAppId: "", instrumentals: [], albums: [], videos: [], merch: nil, name: "", dateRegisteredToApp: "", timeRegisteredToApp: "", songArtist: [], songProducers: [], songWriters: nil, songMixEngineer: nil, songMasteringEngineer: nil, songRecordingEngineer: nil, favoritesOverall: 0, manualImageURL: nil, manualPreviewURL: nil, apple: nil, spotify: nil, soundcloud: nil, youtubeMusic: nil, amazon: nil, deezer: nil, spinrilla: nil, napster: nil, tidal: nil, officialVideo: nil, audioVideo: nil,lyricVideo:nil, remixes: nil, isRemix:nil, isOtherVersion: nil, otherVersions: nil, explicit: nil, industryCerified: nil, verificationLevel: nil, isActive: false)
                                            let urlPlayable:URL!
                                            let prevurl = self.array[3] as! String

                                            if let url  = URL.init(string: prevurl){
                                                urlPlayable = url
                                                guard  let urlPlayable = urlPlayable else {return}
                                                let myDict = [ "url": urlPlayable, "song":song] as [String : Any]
                                                NotificationCenter.default.post(name: AudioPlayerOnSongNotify, object: myDict)
                                            }
                                        }
                                    }, label: {
                                        Image(systemName: "play.circle.fill").resizable().frame(width: 25, height: 25, alignment: .center).foregroundColor(Color.white)
                                    }).foregroundColor(Color.white)
                                }
                                Button(action: {

                                }, label: {
                                    Image("tablershare").resizable().frame(width: 25, height: 25, alignment: .center).foregroundColor(Color.white)
                                }).foregroundColor(Color.white)

                            }.padding(.trailing, 10).padding(.leading, 10)
                    VStack{
                        HStack {
//                            Text("Released: \(song.date.replacingOccurrences(of: "August ", with: "08/").replacingOccurrences(of: "January ", with: "01/").replacingOccurrences(of: "February ", with: "02/").replacingOccurrences(of: "March ", with: "03/").replacingOccurrences(of: "April ", with: "04/").replacingOccurrences(of: "May ", with: "05/").replacingOccurrences(of: "June ", with: "06/").replacingOccurrences(of: "July ", with: "07/").replacingOccurrences(of: "September ", with: "09/").replacingOccurrences(of: "October ", with: "10/").replacingOccurrences(of: "November ", with: "11/").replacingOccurrences(of: "December ", with: "12/").replacingOccurrences(of: ", ", with: "/"))").font(.custom("AvenirNextCondensed-UltraLight", size: 14))
                            Text("Released: \(array[2] as? String ?? "")").font(.custom("AvenirNextCondensed-UltraLight", size: 14)).skeleton(with: array.isEmpty)
                            Spacer()
                        }
                        HStack {
                            switch array[12] {
                            case is SongData:
                                //let song = array[12] as! SongData
                                Text("Stream Song Now").font(.custom("AvenirNextCondensed-Regular", size: 17))
                            case is VideoData:
                                Text("Watch Now").font(.custom("AvenirNextCondensed-Regular", size: 17))
                                //let video = array[12] as! VideoData
                            case is AlbumData:
                                Text("Stream Album Now").font(.custom("AvenirNextCondensed-Regular", size: 17))
                                //let album = array[12] as! AlbumData
                            default:
                                Text("Play Instrumental Now").font(.custom("AvenirNextCondensed-Regular", size: 17))
                                //let instrumental = array[12] as! InstrumentalData
                            }
                            Spacer()
                        }
                    }.padding(.leading, 10)
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 8) {
                            switch array[12] {
                            case is SongData:
                                let song = array[12] as! SongData
                                if let stringurl = song.apple?.appleSongURL {
                                    let alerticon = UIImage(named: "appleMusicIcon")!.copy(newSize: CGSize(width: 35, height: 35))
                                    Button(action: {
                                        let actionSheet = CDAlertView(title: "Open \(song.name) in Apple Music?",
                                                                      message: "If you don't have Apple Music, \(song.name) will open in Safari.", type: .custom(image: alerticon!))
                                        actionSheet.alertBackgroundColor = Constants.Colors.mediumApp
                                        actionSheet.circleFillColor = .black
                                        actionSheet.titleTextColor = .white
                                        actionSheet.messageTextColor = .white
                                        actionSheet.add(action: CDAlertViewAction(title: "Cancel", font: UIFont.systemFont(ofSize: 16), textColor: Constants.Colors.redApp, backgroundColor: Constants.Colors.mediumApp, handler: nil))
                                        actionSheet.add(action: CDAlertViewAction(title: "Open", font: UIFont.boldSystemFont(ofSize: 16), textColor: Constants.Colors.redApp, backgroundColor: Constants.Colors.mediumApp, handler: { _ in
                                            let url = URL(string: stringurl)
                                            if UIApplication.shared.canOpenURL(url!)
                                            {
                                                UIApplication.shared.open(url!, options: [:], completionHandler: nil)
                                                return true
                                            } else {
                                                //redirect to safari because the user doesn't have Instagram
                                                UIApplication.shared.open(URL(string: "http://apple.com/")!, options: [:], completionHandler: nil)
                                                return true
                                            }
                                        }))

                                        NotificationCenter.default.post(name: OpenTheAlertNotify, object: actionSheet)
                                    }, label: {
                                        Image("appleMusicIcon").renderingMode(.original).resizable().frame(width: 50, height: 50, alignment: .center)
                                    }).buttonStyle(ScaleButtonStyle())
                                }
                                if let stringurl = song.spotify?.spotifySongURL {
                                    let alerticon = UIImage(named: "SpotifyIcon")!.copy(newSize: CGSize(width: 35, height: 35))
                                    Button(action: {
                                        let actionSheet = CDAlertView(title: "Open \(song.name) in Spotify?",
                                                                      message: "If you don't have Spotify, \(song.name) will open in Safari.", type: .custom(image: alerticon!))
                                        actionSheet.alertBackgroundColor = Constants.Colors.mediumApp
                                        actionSheet.circleFillColor = .black
                                        actionSheet.titleTextColor = .white
                                        actionSheet.messageTextColor = .white
                                        actionSheet.add(action: CDAlertViewAction(title: "Cancel", font: UIFont.systemFont(ofSize: 16), textColor: Constants.Colors.redApp, backgroundColor: Constants.Colors.mediumApp, handler: nil))
                                        actionSheet.add(action: CDAlertViewAction(title: "Open", font: UIFont.boldSystemFont(ofSize: 16), textColor: Constants.Colors.redApp, backgroundColor: Constants.Colors.mediumApp, handler: { _ in
                                            let url = URL(string: stringurl)
                                            if UIApplication.shared.canOpenURL(url!)
                                            {
                                                UIApplication.shared.open(url!, options: [:], completionHandler: nil)
                                                return true
                                            } else {
                                                //redirect to safari because the user doesn't have Instagram
                                                UIApplication.shared.open(URL(string: "http://spotify.com/")!, options: [:], completionHandler: nil)
                                                return true
                                            }
                                        }))
                                        NotificationCenter.default.post(name: OpenTheAlertNotify, object: actionSheet)
                                    }, label: {
                                        Image("SpotifyIcon").renderingMode(.original).resizable().frame(width: 50, height: 50, alignment: .center).background(Color.black).cornerRadius(10)
                                    }).buttonStyle(ScaleButtonStyle())
                                }
                                if let stringurl = song.soundcloud?.url {
                                    let alerticon = UIImage(named: "soundcloudIcon")!.copy(newSize: CGSize(width: 35, height: 35))
                                    Button(action: {
                                        let actionSheet = CDAlertView(title: "Open \(song.name) in Soundcloud?",
                                                                            message: "If you don't have Soundcloud, \(song.name) will open in Safari.", type: .custom(image: alerticon!))
                                        actionSheet.alertBackgroundColor = Constants.Colors.mediumApp
                                        actionSheet.circleFillColor = .black
                                        actionSheet.titleTextColor = .white
                                        actionSheet.messageTextColor = .white
                                        actionSheet.add(action: CDAlertViewAction(title: "Cancel", font: UIFont.systemFont(ofSize: 16), textColor: Constants.Colors.redApp, backgroundColor: Constants.Colors.mediumApp, handler: nil))
                                        actionSheet.add(action: CDAlertViewAction(title: "Open", font: UIFont.boldSystemFont(ofSize: 16), textColor: Constants.Colors.redApp, backgroundColor: Constants.Colors.mediumApp, handler: { _ in
                                            let url = URL(string: stringurl)
                                            if UIApplication.shared.canOpenURL(url!)
                                            {
                                                UIApplication.shared.open(url!, options: [:], completionHandler: nil)
                                                return true
                                            } else {
                                                //redirect to safari because the user doesn't have Instagram
                                                UIApplication.shared.open(URL(string: "http://soundcloud.com/")!, options: [:], completionHandler: nil)
                                                return true
                                            }
                                        }))
                                        NotificationCenter.default.post(name: OpenTheAlertNotify, object: actionSheet)
                                    }, label: {
                                        Image("soundcloudIcon").renderingMode(.original).resizable().frame(width: 50, height: 50, alignment: .center)
                                    }).buttonStyle(ScaleButtonStyle())
                                }
                                if let stringurl = song.youtubeMusic?.url {
                                    let alerticon = UIImage(named: "youtubemusicappicon")!.copy(newSize: CGSize(width: 35, height: 35))
                                    Button(action: {
                                        let actionSheet = CDAlertView(title: "Open \(song.name) in Youtube Music?",
                                                                            message: "If you don't have Youtube Music, \(song.name) will open in Safari.", type: .custom(image: alerticon!))
                                        actionSheet.alertBackgroundColor = Constants.Colors.mediumApp
                                        actionSheet.circleFillColor = .black
                                        actionSheet.titleTextColor = .white
                                        actionSheet.messageTextColor = .white
                                        actionSheet.add(action: CDAlertViewAction(title: "Cancel", font: UIFont.systemFont(ofSize: 16), textColor: Constants.Colors.redApp, backgroundColor: Constants.Colors.mediumApp, handler: nil))
                                        actionSheet.add(action: CDAlertViewAction(title: "Open", font: UIFont.boldSystemFont(ofSize: 16), textColor: Constants.Colors.redApp, backgroundColor: Constants.Colors.mediumApp, handler: { _ in
                                            let url = URL(string: stringurl)
                                            if UIApplication.shared.canOpenURL(url!)
                                            {
                                                UIApplication.shared.open(url!, options: [:], completionHandler: nil)
                                                return true
                                            } else {
                                                //redirect to safari because the user doesn't have Instagram
                                                UIApplication.shared.open(URL(string: "http://music.youtube.com/")!, options: [:], completionHandler: nil)
                                                return true
                                            }
                                        }))
                                        NotificationCenter.default.post(name: OpenTheAlertNotify, object: actionSheet)
                                    }, label: {
                                        Image("youtubemusicappicon").renderingMode(.original).resizable().frame(width: 50, height: 50, alignment: .center).background(Color.black).cornerRadius(10)
                                    }).buttonStyle(ScaleButtonStyle())
                                }
                                if let stringurl = song.amazon?.url {
                                    let alerticon = UIImage(named: "amazonmusicappicon")!.copy(newSize: CGSize(width: 35, height: 35))
                                    Button(action: {
                                        let actionSheet = CDAlertView(title: "Open \(song.name) in Amazon Music?",
                                                                            message: "If you don't have Amazon Music, \(song.name) will open in Safari.", type: .custom(image: alerticon!))
                                        actionSheet.alertBackgroundColor = Constants.Colors.mediumApp
                                        actionSheet.circleFillColor = .black
                                        actionSheet.titleTextColor = .white
                                        actionSheet.messageTextColor = .white
                                        actionSheet.add(action: CDAlertViewAction(title: "Cancel", font: UIFont.systemFont(ofSize: 16), textColor: Constants.Colors.redApp, backgroundColor: Constants.Colors.mediumApp, handler: nil))
                                        actionSheet.add(action: CDAlertViewAction(title: "Open", font: UIFont.boldSystemFont(ofSize: 16), textColor: Constants.Colors.redApp, backgroundColor: Constants.Colors.mediumApp, handler: { _ in
                                                                        let url = URL(string: stringurl)
                                                                        if UIApplication.shared.canOpenURL(url!)
                                                                        {
                                                                            UIApplication.shared.open(url!, options: [:], completionHandler: nil)
                                                                            return true
                                                                        } else {
                                                                            //redirect to safari because the user doesn't have Instagram
                                                                                UIApplication.shared.open(URL(string: "http://amazon.com/")!, options: [:], completionHandler: nil)
                                                                            return true
                                                                        }
                                        }))
                                        NotificationCenter.default.post(name: OpenTheAlertNotify, object: actionSheet)
                                    }, label: {
                                        Image("amazonmusicappicon").renderingMode(.original).resizable().frame(width: 50, height: 50, alignment: .center).cornerRadius(10)
                                    }).buttonStyle(ScaleButtonStyle())
                                }
                                if let stringurl = song.deezer?.url {
                                    let alerticon = UIImage(named: "deezerappicon")!.copy(newSize: CGSize(width: 35, height: 35))
                                    Button(action: {
                                        let actionSheet = CDAlertView(title: "Open \(song.name) in Deezer?",
                                                                            message: "If you don't have Deezer, \(song.name) will open in Safari.", type: .custom(image: alerticon!))
                                        actionSheet.alertBackgroundColor = Constants.Colors.mediumApp
                                        actionSheet.circleFillColor = .black
                                        actionSheet.titleTextColor = .white
                                        actionSheet.messageTextColor = .white
                                        actionSheet.add(action: CDAlertViewAction(title: "Cancel", font: UIFont.systemFont(ofSize: 16), textColor: Constants.Colors.redApp, backgroundColor: Constants.Colors.mediumApp, handler: nil))
                                        actionSheet.add(action: CDAlertViewAction(title: "Open", font: UIFont.boldSystemFont(ofSize: 16), textColor: Constants.Colors.redApp, backgroundColor: Constants.Colors.mediumApp, handler: { _ in
                                                                        let url = URL(string: stringurl)
                                                                        if UIApplication.shared.canOpenURL(url!)
                                                                        {
                                                                            UIApplication.shared.open(url!, options: [:], completionHandler: nil)
                                                                            return true
                                                                        } else {
                                                                            //redirect to safari because the user doesn't have Instagram
                                                                                UIApplication.shared.open(URL(string: "http://deezer.com/")!, options: [:], completionHandler: nil)
                                                                            return true
                                                                        }
                                        }))
                                        NotificationCenter.default.post(name: OpenTheAlertNotify, object: actionSheet)
                                    }, label: {
                                        Image("deezerappicon").renderingMode(.original).resizable().frame(width: 50, height: 50, alignment: .center).cornerRadius(10)
                                    }).buttonStyle(ScaleButtonStyle())
                                }
                                if let stringurl = song.napster?.url {
                                    let alerticon = UIImage(named: "napsterappicon")!.copy(newSize: CGSize(width: 35, height: 35))
                                    Button(action: {
                                        let actionSheet = CDAlertView(title: "Open \(song.name) in Napster?",
                                                                            message: "If you don't have Napster, \(song.name) will open in Safari.", type: .custom(image: alerticon!))
                                        actionSheet.alertBackgroundColor = Constants.Colors.mediumApp
                                        actionSheet.circleFillColor = .black
                                        actionSheet.titleTextColor = .white
                                        actionSheet.messageTextColor = .white
                                        actionSheet.add(action: CDAlertViewAction(title: "Cancel", font: UIFont.systemFont(ofSize: 16), textColor: Constants.Colors.redApp, backgroundColor: Constants.Colors.mediumApp, handler: nil))
                                        actionSheet.add(action: CDAlertViewAction(title: "Open", font: UIFont.boldSystemFont(ofSize: 16), textColor: Constants.Colors.redApp, backgroundColor: Constants.Colors.mediumApp, handler: { _ in
                                                                        let url = URL(string: stringurl)
                                                                        if UIApplication.shared.canOpenURL(url!)
                                                                        {
                                                                            UIApplication.shared.open(url!, options: [:], completionHandler: nil)
                                                                            return true
                                                                        } else {
                                                                            //redirect to safari because the user doesn't have Instagram
                                                                                UIApplication.shared.open(URL(string: "http://napster.com/")!, options: [:], completionHandler: nil)
                                                                            return true
                                                                        }
                                        }))
                                        NotificationCenter.default.post(name: OpenTheAlertNotify, object: actionSheet)
                                    }, label: {
                                        Image("napsterappicon").renderingMode(.original).resizable().frame(width: 50, height: 50, alignment: .center).cornerRadius(10)
                                    }).buttonStyle(ScaleButtonStyle())
                                }
                                if let stringurl = song.spinrilla?.url {
                                    let alerticon = UIImage(named: "spinrillaappicon")!.copy(newSize: CGSize(width: 35, height: 35))
                                    Button(action: {
                                        let actionSheet = CDAlertView(title: "Open \(song.name) in Spinrilla?",
                                                                            message: "If you don't have Spinrilla, \(song.name) will open in Safari.", type: .custom(image: alerticon!))
                                        actionSheet.alertBackgroundColor = Constants.Colors.mediumApp
                                        actionSheet.circleFillColor = .black
                                        actionSheet.titleTextColor = .white
                                        actionSheet.messageTextColor = .white
                                        actionSheet.add(action: CDAlertViewAction(title: "Cancel", font: UIFont.systemFont(ofSize: 16), textColor: Constants.Colors.redApp, backgroundColor: Constants.Colors.mediumApp, handler: nil))
                                        actionSheet.add(action: CDAlertViewAction(title: "Open", font: UIFont.boldSystemFont(ofSize: 16), textColor: Constants.Colors.redApp, backgroundColor: Constants.Colors.mediumApp, handler: { _ in
                                                                        let url = URL(string: stringurl)
                                                                        if UIApplication.shared.canOpenURL(url!)
                                                                        {
                                                                            UIApplication.shared.open(url!, options: [:], completionHandler: nil)
                                                                            return true
                                                                        } else {
                                                                            //redirect to safari because the user doesn't have Instagram
                                                                                UIApplication.shared.open(URL(string: "http://spinrilla.com/")!, options: [:], completionHandler: nil)
                                                                            return true
                                                                        }
                                        }))
                                        NotificationCenter.default.post(name: OpenTheAlertNotify, object: actionSheet)
                                    }, label: {
                                        Image("spinrillaappicon").renderingMode(.original).resizable().frame(width: 50, height: 50, alignment: .center).cornerRadius(10)
                                    }).buttonStyle(ScaleButtonStyle())
                                }
                                if let stringurl = song.tidal?.url {
                                    let alerticon = UIImage(named: "tidalappicon")!.copy(newSize: CGSize(width: 35, height: 35))
                                    Button(action: {
                                        let actionSheet = CDAlertView(title: "Open \(song.name) in Tidal?",
                                                                            message: "If you don't have Tidal, \(song.name) will open in Safari.", type: .custom(image: alerticon!))
                                        actionSheet.alertBackgroundColor = Constants.Colors.mediumApp
                                        actionSheet.circleFillColor = .black
                                        actionSheet.titleTextColor = .white
                                        actionSheet.messageTextColor = .white
                                        actionSheet.add(action: CDAlertViewAction(title: "Cancel", font: UIFont.systemFont(ofSize: 16), textColor: Constants.Colors.redApp, backgroundColor: Constants.Colors.mediumApp, handler: nil))
                                        actionSheet.add(action: CDAlertViewAction(title: "Open", font: UIFont.boldSystemFont(ofSize: 16), textColor: Constants.Colors.redApp, backgroundColor: Constants.Colors.mediumApp, handler: { _ in
                                                                        let url = URL(string: stringurl)
                                                                        if UIApplication.shared.canOpenURL(url!)
                                                                        {
                                                                            UIApplication.shared.open(url!, options: [:], completionHandler: nil)
                                                                            return true
                                                                        } else {
                                                                            //redirect to safari because the user doesn't have Instagram
                                                                                UIApplication.shared.open(URL(string: "http://tidal.com/")!, options: [:], completionHandler: nil)
                                                                            return true
                                                                        }
                                        }))
                                        NotificationCenter.default.post(name: OpenTheAlertNotify, object: actionSheet)
                                    }, label: {
                                        Image("tidalappicon").renderingMode(.original).resizable().frame(width: 50, height: 50, alignment: .center).cornerRadius(10)
                                    }).buttonStyle(ScaleButtonStyle())
                                }
                            case is AlbumData:
                                let album = array[12] as! AlbumData
                                if let stringurl = album.apple?.url {
                                    let alerticon = UIImage(named: "appleMusicIcon")!.copy(newSize: CGSize(width: 35, height: 35))
                                    Button(action: {
                                        let actionSheet = CDAlertView(title: "Open \(album.name) in Apple Music?",
                                                                      message: "If you don't have Apple Music, \(album.name) will open in Safari.", type: .custom(image: alerticon!))
                                        actionSheet.alertBackgroundColor = Constants.Colors.mediumApp
                                        actionSheet.circleFillColor = .black
                                        actionSheet.titleTextColor = .white
                                        actionSheet.messageTextColor = .white
                                        actionSheet.add(action: CDAlertViewAction(title: "Cancel", font: UIFont.systemFont(ofSize: 16), textColor: Constants.Colors.redApp, backgroundColor: Constants.Colors.mediumApp, handler: nil))
                                        actionSheet.add(action: CDAlertViewAction(title: "Open", font: UIFont.boldSystemFont(ofSize: 16), textColor: Constants.Colors.redApp, backgroundColor: Constants.Colors.mediumApp, handler: { _ in
                                            let url = URL(string: stringurl)
                                            if UIApplication.shared.canOpenURL(url!)
                                            {
                                                UIApplication.shared.open(url!, options: [:], completionHandler: nil)
                                                return true
                                            } else {
                                                //redirect to safari because the user doesn't have Instagram
                                                UIApplication.shared.open(URL(string: "http://apple.com/")!, options: [:], completionHandler: nil)
                                                return true
                                            }
                                        }))

                                        NotificationCenter.default.post(name: OpenTheAlertNotify, object: actionSheet)
                                    }, label: {
                                        Image("appleMusicIcon").renderingMode(.original).resizable().frame(width: 50, height: 50, alignment: .center)
                                    }).buttonStyle(ScaleButtonStyle())
                                }
                                if let stringurl = album.spotify?.url {
                                    let alerticon = UIImage(named: "SpotifyIcon")!.copy(newSize: CGSize(width: 35, height: 35))
                                    Button(action: {
                                        let actionSheet = CDAlertView(title: "Open \(album.name) in Spotify?",
                                                                      message: "If you don't have Spotify, \(album.name) will open in Safari.", type: .custom(image: alerticon!))
                                        actionSheet.alertBackgroundColor = Constants.Colors.mediumApp
                                        actionSheet.circleFillColor = .black
                                        actionSheet.titleTextColor = .white
                                        actionSheet.messageTextColor = .white
                                        actionSheet.add(action: CDAlertViewAction(title: "Cancel", font: UIFont.systemFont(ofSize: 16), textColor: Constants.Colors.redApp, backgroundColor: Constants.Colors.mediumApp, handler: nil))
                                        actionSheet.add(action: CDAlertViewAction(title: "Open", font: UIFont.boldSystemFont(ofSize: 16), textColor: Constants.Colors.redApp, backgroundColor: Constants.Colors.mediumApp, handler: { _ in
                                            let url = URL(string: stringurl)
                                            if UIApplication.shared.canOpenURL(url!)
                                            {
                                                UIApplication.shared.open(url!, options: [:], completionHandler: nil)
                                                return true
                                            } else {
                                                //redirect to safari because the user doesn't have Instagram
                                                UIApplication.shared.open(URL(string: "http://spotify.com/")!, options: [:], completionHandler: nil)
                                                return true
                                            }
                                        }))
                                        NotificationCenter.default.post(name: OpenTheAlertNotify, object: actionSheet)
                                    }, label: {
                                        Image("SpotifyIcon").renderingMode(.original).resizable().frame(width: 50, height: 50, alignment: .center).background(Color.black).cornerRadius(10)
                                    }).buttonStyle(ScaleButtonStyle())
                                }
                                if let stringurl = album.soundcloud?.url {
                                    let alerticon = UIImage(named: "soundcloudIcon")!.copy(newSize: CGSize(width: 35, height: 35))
                                    Button(action: {
                                        let actionSheet = CDAlertView(title: "Open \(album.name) in Soundcloud?",
                                                                            message: "If you don't have Soundcloud, \(album.name) will open in Safari.", type: .custom(image: alerticon!))
                                        actionSheet.alertBackgroundColor = Constants.Colors.mediumApp
                                        actionSheet.circleFillColor = .black
                                        actionSheet.titleTextColor = .white
                                        actionSheet.messageTextColor = .white
                                        actionSheet.add(action: CDAlertViewAction(title: "Cancel", font: UIFont.systemFont(ofSize: 16), textColor: Constants.Colors.redApp, backgroundColor: Constants.Colors.mediumApp, handler: nil))
                                        actionSheet.add(action: CDAlertViewAction(title: "Open", font: UIFont.boldSystemFont(ofSize: 16), textColor: Constants.Colors.redApp, backgroundColor: Constants.Colors.mediumApp, handler: { _ in
                                            let url = URL(string: stringurl)
                                            if UIApplication.shared.canOpenURL(url!)
                                            {
                                                UIApplication.shared.open(url!, options: [:], completionHandler: nil)
                                                return true
                                            } else {
                                                //redirect to safari because the user doesn't have Instagram
                                                UIApplication.shared.open(URL(string: "http://soundcloud.com/")!, options: [:], completionHandler: nil)
                                                return true
                                            }
                                        }))
                                        NotificationCenter.default.post(name: OpenTheAlertNotify, object: actionSheet)
                                    }, label: {
                                        Image("soundcloudIcon").renderingMode(.original).resizable().frame(width: 50, height: 50, alignment: .center)
                                    }).buttonStyle(ScaleButtonStyle())
                                }
                                if let stringurl = album.youtubeMusic?.url {
                                    let alerticon = UIImage(named: "youtubemusicappicon")!.copy(newSize: CGSize(width: 35, height: 35))
                                    Button(action: {
                                        let actionSheet = CDAlertView(title: "Open \(album.name) in Youtube Music?",
                                                                            message: "If you don't have Youtube Music, \(album.name) will open in Safari.", type: .custom(image: alerticon!))
                                        actionSheet.alertBackgroundColor = Constants.Colors.mediumApp
                                        actionSheet.circleFillColor = .black
                                        actionSheet.titleTextColor = .white
                                        actionSheet.messageTextColor = .white
                                        actionSheet.add(action: CDAlertViewAction(title: "Cancel", font: UIFont.systemFont(ofSize: 16), textColor: Constants.Colors.redApp, backgroundColor: Constants.Colors.mediumApp, handler: nil))
                                        actionSheet.add(action: CDAlertViewAction(title: "Open", font: UIFont.boldSystemFont(ofSize: 16), textColor: Constants.Colors.redApp, backgroundColor: Constants.Colors.mediumApp, handler: { _ in
                                            let url = URL(string: stringurl)
                                            if UIApplication.shared.canOpenURL(url!)
                                            {
                                                UIApplication.shared.open(url!, options: [:], completionHandler: nil)
                                                return true
                                            } else {
                                                //redirect to safari because the user doesn't have Instagram
                                                UIApplication.shared.open(URL(string: "http://music.youtube.com/")!, options: [:], completionHandler: nil)
                                                return true
                                            }
                                        }))
                                        NotificationCenter.default.post(name: OpenTheAlertNotify, object: actionSheet)
                                    }, label: {
                                        Image("youtubemusicappicon").renderingMode(.original).resizable().frame(width: 50, height: 50, alignment: .center).background(Color.black).cornerRadius(10)
                                    }).buttonStyle(ScaleButtonStyle())
                                }
                                if let stringurl = album.amazon?.url {
                                    let alerticon = UIImage(named: "amazonmusicappicon")!.copy(newSize: CGSize(width: 35, height: 35))
                                    Button(action: {
                                        let actionSheet = CDAlertView(title: "Open \(album.name) in Amazon Music?",
                                                                            message: "If you don't have Amazon Music, \(album.name) will open in Safari.", type: .custom(image: alerticon!))
                                        actionSheet.alertBackgroundColor = Constants.Colors.mediumApp
                                        actionSheet.circleFillColor = .black
                                        actionSheet.titleTextColor = .white
                                        actionSheet.messageTextColor = .white
                                        actionSheet.add(action: CDAlertViewAction(title: "Cancel", font: UIFont.systemFont(ofSize: 16), textColor: Constants.Colors.redApp, backgroundColor: Constants.Colors.mediumApp, handler: nil))
                                        actionSheet.add(action: CDAlertViewAction(title: "Open", font: UIFont.boldSystemFont(ofSize: 16), textColor: Constants.Colors.redApp, backgroundColor: Constants.Colors.mediumApp, handler: { _ in
                                                                        let url = URL(string: stringurl)
                                                                        if UIApplication.shared.canOpenURL(url!)
                                                                        {
                                                                            UIApplication.shared.open(url!, options: [:], completionHandler: nil)
                                                                            return true
                                                                        } else {
                                                                            //redirect to safari because the user doesn't have Instagram
                                                                                UIApplication.shared.open(URL(string: "http://amazon.com/")!, options: [:], completionHandler: nil)
                                                                            return true
                                                                        }
                                        }))
                                        NotificationCenter.default.post(name: OpenTheAlertNotify, object: actionSheet)
                                    }, label: {
                                        Image("amazonmusicappicon").renderingMode(.original).resizable().frame(width: 50, height: 50, alignment: .center).cornerRadius(10)
                                    }).buttonStyle(ScaleButtonStyle())
                                }
                                if let stringurl = album.deezer?.url {
                                    let alerticon = UIImage(named: "deezerappicon")!.copy(newSize: CGSize(width: 35, height: 35))
                                    Button(action: {
                                        let actionSheet = CDAlertView(title: "Open \(album.name) in Deezer?",
                                                                            message: "If you don't have Deezer, \(album.name) will open in Safari.", type: .custom(image: alerticon!))
                                        actionSheet.alertBackgroundColor = Constants.Colors.mediumApp
                                        actionSheet.circleFillColor = .black
                                        actionSheet.titleTextColor = .white
                                        actionSheet.messageTextColor = .white
                                        actionSheet.add(action: CDAlertViewAction(title: "Cancel", font: UIFont.systemFont(ofSize: 16), textColor: Constants.Colors.redApp, backgroundColor: Constants.Colors.mediumApp, handler: nil))
                                        actionSheet.add(action: CDAlertViewAction(title: "Open", font: UIFont.boldSystemFont(ofSize: 16), textColor: Constants.Colors.redApp, backgroundColor: Constants.Colors.mediumApp, handler: { _ in
                                                                        let url = URL(string: stringurl)
                                                                        if UIApplication.shared.canOpenURL(url!)
                                                                        {
                                                                            UIApplication.shared.open(url!, options: [:], completionHandler: nil)
                                                                            return true
                                                                        } else {
                                                                            //redirect to safari because the user doesn't have Instagram
                                                                                UIApplication.shared.open(URL(string: "http://deezer.com/")!, options: [:], completionHandler: nil)
                                                                            return true
                                                                        }
                                        }))
                                        NotificationCenter.default.post(name: OpenTheAlertNotify, object: actionSheet)
                                    }, label: {
                                        Image("deezerappicon").renderingMode(.original).resizable().frame(width: 50, height: 50, alignment: .center).cornerRadius(10)
                                    }).buttonStyle(ScaleButtonStyle())
                                }
                                if let stringurl = album.napster?.url {
                                    let alerticon = UIImage(named: "napsterappicon")!.copy(newSize: CGSize(width: 35, height: 35))
                                    Button(action: {
                                        let actionSheet = CDAlertView(title: "Open \(album.name) in Napster?",
                                                                            message: "If you don't have Napster, \(album.name) will open in Safari.", type: .custom(image: alerticon!))
                                        actionSheet.alertBackgroundColor = Constants.Colors.mediumApp
                                        actionSheet.circleFillColor = .black
                                        actionSheet.titleTextColor = .white
                                        actionSheet.messageTextColor = .white
                                        actionSheet.add(action: CDAlertViewAction(title: "Cancel", font: UIFont.systemFont(ofSize: 16), textColor: Constants.Colors.redApp, backgroundColor: Constants.Colors.mediumApp, handler: nil))
                                        actionSheet.add(action: CDAlertViewAction(title: "Open", font: UIFont.boldSystemFont(ofSize: 16), textColor: Constants.Colors.redApp, backgroundColor: Constants.Colors.mediumApp, handler: { _ in
                                                                        let url = URL(string: stringurl)
                                                                        if UIApplication.shared.canOpenURL(url!)
                                                                        {
                                                                            UIApplication.shared.open(url!, options: [:], completionHandler: nil)
                                                                            return true
                                                                        } else {
                                                                            //redirect to safari because the user doesn't have Instagram
                                                                                UIApplication.shared.open(URL(string: "http://napster.com/")!, options: [:], completionHandler: nil)
                                                                            return true
                                                                        }
                                        }))
                                        NotificationCenter.default.post(name: OpenTheAlertNotify, object: actionSheet)
                                    }, label: {
                                        Image("napsterappicon").renderingMode(.original).resizable().frame(width: 50, height: 50, alignment: .center).cornerRadius(10)
                                    }).buttonStyle(ScaleButtonStyle())
                                }
                                if let stringurl = album.spinrilla?.url {
                                    let alerticon = UIImage(named: "spinrillaappicon")!.copy(newSize: CGSize(width: 35, height: 35))
                                    Button(action: {
                                        let actionSheet = CDAlertView(title: "Open \(album.name) in Spinrilla?",
                                                                            message: "If you don't have Spinrilla, \(album.name) will open in Safari.", type: .custom(image: alerticon!))
                                        actionSheet.alertBackgroundColor = Constants.Colors.mediumApp
                                        actionSheet.circleFillColor = .black
                                        actionSheet.titleTextColor = .white
                                        actionSheet.messageTextColor = .white
                                        actionSheet.add(action: CDAlertViewAction(title: "Cancel", font: UIFont.systemFont(ofSize: 16), textColor: Constants.Colors.redApp, backgroundColor: Constants.Colors.mediumApp, handler: nil))
                                        actionSheet.add(action: CDAlertViewAction(title: "Open", font: UIFont.boldSystemFont(ofSize: 16), textColor: Constants.Colors.redApp, backgroundColor: Constants.Colors.mediumApp, handler: { _ in
                                                                        let url = URL(string: stringurl)
                                                                        if UIApplication.shared.canOpenURL(url!)
                                                                        {
                                                                            UIApplication.shared.open(url!, options: [:], completionHandler: nil)
                                                                            return true
                                                                        } else {
                                                                            //redirect to safari because the user doesn't have Instagram
                                                                                UIApplication.shared.open(URL(string: "http://spinrilla.com/")!, options: [:], completionHandler: nil)
                                                                            return true
                                                                        }
                                        }))
                                        NotificationCenter.default.post(name: OpenTheAlertNotify, object: actionSheet)
                                    }, label: {
                                        Image("spinrillaappicon").renderingMode(.original).resizable().frame(width: 50, height: 50, alignment: .center).cornerRadius(10)
                                    }).buttonStyle(ScaleButtonStyle())
                                }
                                if let stringurl = album.tidal?.url {
                                    let alerticon = UIImage(named: "tidalappicon")!.copy(newSize: CGSize(width: 35, height: 35))
                                    Button(action: {
                                        let actionSheet = CDAlertView(title: "Open \(album.name) in Tidal?",
                                                                            message: "If you don't have Tidal, \(album.name) will open in Safari.", type: .custom(image: alerticon!))
                                        actionSheet.alertBackgroundColor = Constants.Colors.mediumApp
                                        actionSheet.circleFillColor = .black
                                        actionSheet.titleTextColor = .white
                                        actionSheet.messageTextColor = .white
                                        actionSheet.add(action: CDAlertViewAction(title: "Cancel", font: UIFont.systemFont(ofSize: 16), textColor: Constants.Colors.redApp, backgroundColor: Constants.Colors.mediumApp, handler: nil))
                                        actionSheet.add(action: CDAlertViewAction(title: "Open", font: UIFont.boldSystemFont(ofSize: 16), textColor: Constants.Colors.redApp, backgroundColor: Constants.Colors.mediumApp, handler: { _ in
                                                                        let url = URL(string: stringurl)
                                                                        if UIApplication.shared.canOpenURL(url!)
                                                                        {
                                                                            UIApplication.shared.open(url!, options: [:], completionHandler: nil)
                                                                            return true
                                                                        } else {
                                                                            //redirect to safari because the user doesn't have Instagram
                                                                                UIApplication.shared.open(URL(string: "http://tidal.com/")!, options: [:], completionHandler: nil)
                                                                            return true
                                                                        }
                                        }))
                                        NotificationCenter.default.post(name: OpenTheAlertNotify, object: actionSheet)
                                    }, label: {
                                        Image("tidalappicon").renderingMode(.original).resizable().frame(width: 50, height: 50, alignment: .center).cornerRadius(10)
                                    }).buttonStyle(ScaleButtonStyle())
                                }
                            case is VideoData:
                                let video = array[12] as! VideoData
                                if let stringurl = video.youtube {
                                    Button(action: {
                                        contentViewVideos = (stringurl)
                                        contentViewAppVideo = video
                                        NotificationCenter.default.post(name: YoutubeDashboardPopoverNotify, object: nil)
                                    }, label: {
                                        Image("youtubeLogo").renderingMode(.original).resizable().frame(width: 50, height: 50, alignment: .center)
                                    }).buttonStyle(ScaleButtonStyle())
                                }
                                if let stringurl = video.twitter {
                                    Button(action: {
                                        contentViewVideos = (stringurl)
                                        contentViewAppVideo = video
                                        NotificationCenter.default.post(name: YoutubeDashboardPopoverNotify, object: nil)
                                    }, label: {
                                        Image("twitterIcon").renderingMode(.original).resizable().frame(width: 50, height: 50, alignment: .center)
                                    }).buttonStyle(ScaleButtonStyle())
                                }
                                if let stringurl = video.instagramPost {
                                    Button(action: {
                                        contentViewVideos = (stringurl)
                                        contentViewAppVideo = video
                                        NotificationCenter.default.post(name: YoutubeDashboardPopoverNotify, object: nil)
                                    }, label: {
                                        Image("instagramIcon").renderingMode(.original).resizable().frame(width: 50, height: 50, alignment: .center)
                                    }).buttonStyle(ScaleButtonStyle())
                                }
                                if let stringurl = video.tikTok {
                                    Button(action: {
                                        contentViewVideos = (stringurl)
                                        contentViewAppVideo = video
                                        NotificationCenter.default.post(name: YoutubeDashboardPopoverNotify, object: nil)
                                    }, label: {
                                        Image("tiktok").renderingMode(.original).resizable().frame(width: 50, height: 50, alignment: .center).cornerRadius(10)
                                    }).buttonStyle(ScaleButtonStyle())
                                }
                                if let stringurl = video.facebookPost {
                                    Button(action: {
                                        contentViewVideos = (stringurl)
                                        contentViewAppVideo = video
                                        NotificationCenter.default.post(name: YoutubeDashboardPopoverNotify, object: nil)
                                    }, label: {
                                        Image("facebookIcon").renderingMode(.original).resizable().frame(width: 50, height: 50, alignment: .center).cornerRadius(10)
                                    }).buttonStyle(ScaleButtonStyle())
                                }
                            default:
                                if array[12] is InstrumentalData {
                                    let instrumental = array[12] as! InstrumentalData
                                    if instrumental.apple?.appleSongURL != nil {
                                        Button(action: {

                                        }, label: {
                                            Image("appleMusicIcon").renderingMode(.original).resizable().frame(width: 50, height: 50, alignment: .center)
                                        }).buttonStyle(ScaleButtonStyle())
                                    }
                                }
                            }
//                            if (array[11]) is VideoData || ((array[11]) is [String] && (array[11] as! [String]) != [""]) {
//                                Button(action: {
//                                    contentViewVideos = (self.array[11])
//                                    NotificationCenter.default.post(name: YoutubeDashboardPopoverNotify, object: nil)
//                                }, label: {
//                                    Image("youtubeLogo").renderingMode(.original).resizable().frame(width: 50, height: 50, alignment: .center)
//                                }).buttonStyle(ScaleButtonStyle())
//                            }
                            Spacer()
                                }.padding(.trailing, 10).padding(.leading, 10)

                            }

                        }
                    }

        }.background(AsyncImage(url: URL(string: array[1] as! String)!,placeholder: Image("tonedeaflogo").resizable()).aspectRatio(contentMode: .fill).blur(radius: 10))
    }
    
    
    
}

class ImageLoader: ObservableObject {
    @Published var image: UIImage?
    private let url: URL
    

    init(url: URL) {
        self.url = url
    }
    
    private var cancellable: AnyCancellable?
    
    deinit {
        cancellable?.cancel()
    }

    func load() {
        cancellable = URLSession.shared.dataTaskPublisher(for: url)
            .map { UIImage(data: $0.data) }
            .replaceError(with: nil)
            .receive(on: DispatchQueue.main)
            .assign(to: \.image, on: self)
    }
    
    func cancel() {
        cancellable?.cancel()
    }
}

struct AsyncImage<Placeholder: View>: View {
    @ObservedObject private var loader: ImageLoader
    private let placeholder: Placeholder?
    
    init(url: URL, placeholder: Placeholder? = nil) {
        loader = ImageLoader(url: url)
        self.placeholder = placeholder
    }

    var body: some View {
        image
            .onAppear(perform: loader.load)
            .onDisappear(perform: loader.cancel)
    }
    
    private var image: some View {
        Group {
            if loader.image != nil {
                Image(uiImage: loader.image!)
                    .renderingMode(.original)
                    .resizable()
            } else {
                placeholder
            }
        }
    }
}



public class CarouselViewFunctions {
    
    static let shared = CarouselViewFunctions()
    
    var prevurl:String!
    var urlPlayable:URL!
    var currentSong:SongData!
    var artimage:UIImage!
    
    func setPreviewButton(array: SongData) -> String {
        currentSong = array
        if let prevurl = array.apple?.applePreviewURL {
            if let url  = URL.init(string: prevurl){
                urlPlayable = url
            }
        } else
        if let prevurl = array.spotify?.spotifyPreviewURL {
            if let url  = URL.init(string: prevurl){
                urlPlayable = url
            }
        }
        return prevurl
    }
    
    func getArtwork(song: String) -> UIImage {
        var imageurl = ""
        if song != "" {
            imageurl = song
        }
        
        do {
            if let url = URL.init(string: imageurl) {
                let data = try Data.init(contentsOf: url)
                artimage = UIImage(data: data) ?? UIImage(named: "tonedeaflogo")!
            }
            
            
        } catch{
            
        }
        return artimage
    }
    
    @objc func playertimerset() {
        audiofreeze = false
        print("Audio Freeze Off")
        playerTimer.invalidate()
    }
    
}

struct CView_Previews: PreviewProvider {
    static var previews: some View {
        CView()
    }
}

class PopoverContentController:UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
}

struct ScaleButtonStyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.8 : 1)
    }
}
