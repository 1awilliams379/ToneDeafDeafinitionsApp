//
//  GlobalVariables.swift
//  ToneDeafDeafinitionsApp
//
//  Created by Tone Deaf on 8/25/20.
//  Copyright © 2020 GITEM Solutions. All rights reserved.
//




import Foundation
import UIKit

var currentAppUser:UserData!

var availableDownloadsArray: [String] = []
var downloadedFilesArray : [UserDownload] = []
let alertControllerViewTag: Int = 500

let CheckoutSuccessfulAgreeNotificationKey = "com.gitemsolutions.CheckoutSuccessfulAgreejkshdfgjkerhdfbn"
let CheckoutSuccessfulAgreeNotify = Notification.Name(CheckoutSuccessfulAgreeNotificationKey)

let OpenWebViewWithURLNotificationKey = "com.gitemsolutions.OpenWebViewWithURLjkshdfgjkerhdfbn"
let OpenWebViewWithURLNotify = Notification.Name(OpenWebViewWithURLNotificationKey)

let EditBeatVideoSelectedNotificationKey = "com.gitemsolutions.EditBeatVideoSelectedjkshdfgjkerhdfbn"
let EditBeatVideoSelectedNotify = Notification.Name(EditBeatVideoSelectedNotificationKey)

let ExpandCartHeightNotificationKey = "com.gitemsolutions.ExpandCartHeightjkshdfgjkerhdfbn"
let ExpandCartHeightNotify = Notification.Name(ExpandCartHeightNotificationKey)

let FreePaidToBeatInfoSegNotificationKey = "com.gitemsolutions.FreePaidToBeatToInfoSeg"
let FreePaidToBeatInfoSegNotify = Notification.Name(FreePaidToBeatInfoSegNotificationKey)

let DashToBeatInfoSegNotificationKey = "com.gitemsolutions.DashToBeatToInfoSeg"
let DashToBeatInfoSegNotify = Notification.Name(DashToBeatInfoSegNotificationKey)

let MusicToBeatInfoSegNotificationKey = "com.gitemsolutions.MusicToBeatToInfoSeg"
let MusicToBeatInfoSegNotify = Notification.Name(MusicToBeatInfoSegNotificationKey)

let MerchToBeatInfoSegNotificationKey = "com.gitemsolutions.MerchToBeatToInfoSeg"
let MerchToBeatInfoSegNotify = Notification.Name(MerchToBeatInfoSegNotificationKey)

let ExploreToBeatInfoSegNotificationKey = "com.gitemsolutions.ExploreToBeatToInfoSeg"
let ExploreToBeatInfoSegNotify = Notification.Name(ExploreToBeatInfoSegNotificationKey)

let GoToLoginNotificationKey = "com.gitemsolutions.GoToLoginjkshdfgjkerhdfbn"
let GoToLoginNotify = Notification.Name(GoToLoginNotificationKey)

let OpenTheDocShareNotificationKey = "com.gitemsolutions.OpenTheDocShareSeg"
let OpenTheDocShareNotify = Notification.Name(OpenTheDocShareNotificationKey)

let OpenTheCartNotificationKey = "com.gitemsolutions.OpenTheCartSeg"
let OpenTheCartNotify = Notification.Name(OpenTheCartNotificationKey)

let OpenTheCheckOutNotificationKey = "com.gitemsolutions.OpenTheCheckOutSeg"
let OpenTheCheckOutNotify = Notification.Name(OpenTheCheckOutNotificationKey)

let OpenTheShareNotificationKey = "com.gitemsolutions.OpenTheShareSeg"
let OpenTheShareNotify = Notification.Name(OpenTheShareNotificationKey)

let OpenTheAlertNotificationKey = "com.gitemsolutions.OpenTheAlertSeg"
let OpenTheAlertNotify = Notification.Name(OpenTheAlertNotificationKey)

let OpenTheAlertAdminNotificationKey = "com.gitemsolutions.OpenTheAlertAdminSeg"
let OpenTheAlertAdminNotify = Notification.Name(OpenTheAlertAdminNotificationKey)

let OpenTheSheetNotificationKey = "com.gitemsolutions.OpenTheSheetSeg"
let OpenTheSheetNotify = Notification.Name(OpenTheSheetNotificationKey)

let DownloadBeatNotificationKey = "com.gitemsolutions.DownloadBeatSeg"
let DownloadBeatNotify = Notification.Name(DownloadBeatNotificationKey)

let ArtToInfoSegNotificationKey = "com.gitemsolutions.ArtToInfoSeg"
let ArtToInfoSegNotify = Notification.Name(ArtToInfoSegNotificationKey)

let ProToInfoSegNotificationKey = "com.gitemsolutions.PRoToInfoSeg"
let ProToInfoSegNotify = Notification.Name(ProToInfoSegNotificationKey)

let GoToSearchTabNotificationKey = "com.gitemsolutions.GoToSearchTab"
let GoToSearchTabNotify = Notification.Name(GoToSearchTabNotificationKey)

let RemoveTabNotificationKey = "com.gitemsolutions.RemoveGoToSearchTab"
let RemoveTabNotify = Notification.Name(RemoveTabNotificationKey)

let YoutubeDashboardPopoverNotificationKey = "com.gitemsolutions.YoutubeVideoPlayerDashboardPopover"
let YoutubeDashboardPopoverNotify = Notification.Name(YoutubeDashboardPopoverNotificationKey)

var contentViewVideos:Any!
var contentViewAppVideo:VideoData!

let YoutubePlayNotificationKey = "com.gitemsolutions.YoutubeVideoPlayerPlay"
let YoutubePlayNotify = Notification.Name(YoutubePlayNotificationKey)
var currentPlayingYoutubeVideo:YouTubeData!

let transitionExploreToBeatsReceivedNotificationKey = "com.gitemsolutions.transitionExploreToBeatsReceived"
let transitionExploreToBeatsNotify = Notification.Name(transitionExploreToBeatsReceivedNotificationKey)

let transitionAllOfToArtReceivedNotificationKey = "com.gitemsolutions.transitionFromAllOfToArtReceived"
let transitionAllOfToArtNotify = Notification.Name(transitionAllOfToArtReceivedNotificationKey)

let transitionAllOfToProReceivedNotificationKey = "com.gitemsolutions.transitionFromAllOfToProReceived"
let transitionAllOfToProNotify = Notification.Name(transitionAllOfToProReceivedNotificationKey)

let transitionAllOfToInfoReceivedNotificationKey = "com.gitemsolutions.transitionFromAllOfToInfoReceived"
let transitionAllOfToInfoNotify = Notification.Name(transitionAllOfToInfoReceivedNotificationKey)

let transitionFromExploreToMerchInfoNotificationKey = "com.gitemsolutions.transitionFromExploreToMerchInfo"
let transitionFromExploreToMerchInfoNotify = Notification.Name(transitionFromExploreToMerchInfoNotificationKey)

let transitionExploreToAllOfReceivedNotificationKey = "com.gitemsolutions.transitionFromExploreToAllOfReceived"
let transitionExploreToAllOfNotify = Notification.Name(transitionExploreToAllOfReceivedNotificationKey)

let transitionExploreToDetailInfoReceivedNotificationKey = "com.gitemsolutions.transitionFromExploreToDetailInfoReceived"
let transitionExploreToDetailInfoNotify = Notification.Name(transitionExploreToDetailInfoReceivedNotificationKey)

let transitionFromExploreToArtistInfoNotificationKey = "com.gitemsolutions.transitionFromExploreToArtistInfo"
let transitionFromExploreToArtistInfoNotify = Notification.Name(transitionFromExploreToArtistInfoNotificationKey)

let transitionFromExploreToProducerInfoNotificationKey = "com.gitemsolutions.transitionFromExploreToProducerInfo"
let transitionFromExploreToProducerInfoNotify = Notification.Name(transitionFromExploreToProducerInfoNotificationKey)

let transitionDashToDetailInfoReceivedNotificationKey = "com.gitemsolutions.transitionFromDashboardToDetailInfoReceived"
let transitionDashToDetailInfoNotify = Notification.Name(transitionDashToDetailInfoReceivedNotificationKey)

let transitionMusicToDetailInfoReceivedNotificationKey = "com.gitemsolutions.transitionFromMusicToDetailInfoReceived"
let transitionMusicToDetailInfoNotify = Notification.Name(transitionMusicToDetailInfoReceivedNotificationKey)

let transitionDashToArtistInfoReceivedNotificationKey = "com.gitemsolutions.transitionFromDashboardToArtistInfoReceived"
let transitionDashToArtistInfoNotify = Notification.Name(transitionDashToArtistInfoReceivedNotificationKey)

let transitionMusicToArtistInfoReceivedNotificationKey = "com.gitemsolutions.transitionFromMusicToArtistInfoReceived"
let transitionMusicToArtistInfoNotify = Notification.Name(transitionMusicToArtistInfoReceivedNotificationKey)

let transitionDashToProducerInfoReceivedNotificationKey = "com.gitemsolutions.transitionFromDashboardToProducerInfoReceived"
let transitionDashToProducerInfoNotify = Notification.Name(transitionDashToProducerInfoReceivedNotificationKey)

let transitionMusicToProducerInfoReceivedNotificationKey = "com.gitemsolutions.transitionFromMusicToProducerInfoReceived"
let transitionMusicToProducerInfoNotify = Notification.Name(transitionMusicToProducerInfoReceivedNotificationKey)

let transitionToProducerInfoReceivedNotificationKey = "com.gitemsolutions.transitionFromDashboardToProducerInfoReceived"
let transitionToProducerInfoNotify = Notification.Name(transitionToProducerInfoReceivedNotificationKey)

let transitionFromMusicToArtistInfoNotificationKey = "com.gitemsolutions.transitionFromMusicToArtistInfo"
let transitionFromDashboardToArtistInfoNotificationKey = "com.gitemsolutions.transitionFromDashboardToArtistInfo"

let transitionFromMusicToArtistInfoNotify = Notification.Name(transitionFromMusicToArtistInfoNotificationKey)
let transitionFromDashboardToArtistInfoNotify = Notification.Name(transitionFromDashboardToArtistInfoNotificationKey)

let transitionFromMusicToProducerInfoNotificationKey = "com.gitemsolutions.transitionFromMusicToProducerInfo"
let transitionFromDashboardToProducerInfoNotificationKey = "com.gitemsolutions.transitionFromDashboardToProducerInfo"

let transitionFromMusicToProducerInfoNotify = Notification.Name(transitionFromMusicToProducerInfoNotificationKey)
let transitionFromDashboardToProducerInfoNotify = Notification.Name(transitionFromDashboardToProducerInfoNotificationKey)

let adminDashboardStartSpinnerNotificationKey = "com.gitemsolutions.adminDashboardStartSpinnerNotificationKey"
let adminDashboardStartSpinnerNotify = Notification.Name(adminDashboardStartSpinnerNotificationKey)
let adminDashboardStopSpinnerNotificationKey = "com.gitemsolutions.adminDashboardStopSpinnerNotificationKey"
let adminDashboardStopSpinnerNotify = Notification.Name(adminDashboardStopSpinnerNotificationKey)


let AlbumNewSongAddedNotificationKey = "com.gitemsolutions.AlbumNewSongAdded"
let AlbumNewSongAddedNotify = Notification.Name(AlbumNewSongAddedNotificationKey)

let EditAlbumSongNotificationKey = "com.gitemsolutions.editAlbumSongUpload"
let EditAlbumSongUploadNotify = Notification.Name(EditAlbumSongNotificationKey)

var AllPersonsInDatabaseArray:[PersonData]!
var AllPersonsInDatabaseCount:Int!
var AllArtistInDatabaseArray:[ArtistData]!
var AllArtistInDatabaseCount:Int!
var AllProducersInDatabaseArray:[ProducerData]!
var AllProducersInDatabaseCount:Int!
var AllSongsInDatabaseArray:[SongData]!
var AllInstrumentalsInDatabaseArray:[InstrumentalData]!
var AllAlbumsInDatabaseArray:[AlbumData]!
var AllBeatsInDatabaseArray:[BeatData]!
var AllVideosInDatabaseArray:[VideoData]!
var AllKitsInDatabaseArray:[MerchKitData]!
var AllServicesInDatabaseArray:[MerchServiceData]!
var AllApperalInDatabaseArray:[MerchApperalData]!
var AllMemorabiliaInDatabaseArray:[MerchMemorabiliaData]!
var AllInstrumentalSaleInDatabaseArray:[MerchInstrumentalData]!
var AllMerchInDatabaseArray:[MerchData]!

var MusicMainInfiniteScrollContentFeaturedArray:[AnyObject] = []
var MusicLatestSongsContentArray:[SongData] = []
var MusicFeaturedArtistContentArray:[ArtistData] = []
var MusicLatestVideosContentArray:[AnyObject] = []
var MusicInstrumentalContentArray:[InstrumentalData] = []

var ArtistSongsWithToneAllArrayDashboard:Array<SongData> = []
var ArtistSongsWithToneAllArrayMusic:Array<SongData> = []
var ArtistSongsWithToneAllArray:Array<SongData> = []

var ArtistVideosWithToneAllArrayDashboard:Array<AnyObject> = []
var ArtistVideosWithToneAllArrayMusic:Array<AnyObject> = []
var ArtistVideosWithToneAllArray:Array<AnyObject> = []

var ArtistAlbumsWithToneAllArrayDashboard:Array<AlbumData> = []
var ArtistAlbumsWithToneAllArrayMusic:Array<AlbumData> = []
var ArtistAlbumsWithToneAllArray:Array<AlbumData> = []

var ArtistMerchWithToneAllArrayDashboard:Array<MerchData> = []
var ArtistMerchWithToneAllArrayMusic:Array<MerchData> = []
var ArtistMerchWithToneAllArray:Array<MerchData> = []

var searchedArtistSongsWithToneAllArrayDashboard:Array<SongData> = []
var searchedArtistSongsWithToneAllArrayMusic:Array<SongData> = []
var searchedArtistSongsWithToneAllArray:Array<SongData> = []

var searchedArtistVideosWithToneAllArrayDashboard:Array<AnyObject> = []
var searchedArtistVideosWithToneAllArrayMusic:Array<AnyObject> = []
var searchedArtistVideosWithToneAllArray:Array<AnyObject> = []

var searchedArtistAlbumsWithToneAllArrayDashboard:Array<AlbumData> = []
var searchedArtistAlbumsWithToneAllArrayMusic:Array<AlbumData> = []
var searchedArtistAlbumsWithToneAllArray:Array<AlbumData> = []

var searchedArtistMerchWithToneAllArrayDashboard:Array<MerchData> = []
var searchedArtistMerchWithToneAllArrayMusic:Array<MerchData> = []
var searchedArtistMerchWithToneAllArray:Array<MerchData> = []

var ProducerSongsWithToneAllArrayDashboard:Array<SongData> = []
var ProducerSongsWithToneAllArrayMusic:Array<SongData> = []
var ProducerSongsWithToneAllArray:Array<SongData> = []

var ProducerVideosWithToneAllArrayDashboard:Array<AnyObject> = []
var ProducerVideosWithToneAllArrayMusic:Array<AnyObject> = []
var ProducerVideosWithToneAllArray:Array<AnyObject> = []

var ProducerAlbumsWithToneAllArrayDashboard:Array<AlbumData> = []
var ProducerAlbumsWithToneAllArrayMusic:Array<AlbumData> = []
var ProducerAlbumsWithToneAllArray:Array<AlbumData> = []

var ProducerMerchWithToneAllArrayDashboard:Array<MerchData> = []
var ProducerMerchWithToneAllArrayMusic:Array<MerchData> = []
var ProducerMerchWithToneAllArray:Array<MerchData> = []

var ProducerBeatsWithToneAllArrayDashboard:Array<BeatData> = []
var ProducerBeatsWithToneAllArrayMusic:Array<BeatData> = []
var ProducerBeatsWithToneAllArray:Array<BeatData> = []

var ProducerInstrumentalsWithToneFiveArrayDashboard:Array<InstrumentalData> = []
var ProducerInstrumentalsWithToneFiveArrayMusic:Array<InstrumentalData> = []
var ProducerInstrumentalsWithToneFiveArray:Array<InstrumentalData> = []

var searchedProducerSongsWithToneAllArrayDashboard:Array<SongData> = []
var searchedProducerSongsWithToneAllArrayMusic:Array<SongData> = []
var searchedProducerSongsWithToneAllArray:Array<SongData> = []

var searchedProducerVideosWithToneAllArrayDashboard:Array<AnyObject> = []
var searchedProducerVideosWithToneAllArrayMusic:Array<AnyObject> = []
var searchedProducerVideosWithToneAllArray:Array<AnyObject> = []

var searchedProducerAlbumsWithToneAllArrayDashboard:Array<AlbumData> = []
var searchedProducerAlbumsWithToneAllArrayMusic:Array<AlbumData> = []
var searchedProducerAlbumsWithToneAllArray:Array<AlbumData> = []

var searchedProducerMerchWithToneAllArrayDashboard:Array<MerchData> = []
var searchedProducerMerchWithToneAllArrayMusic:Array<MerchData> = []
var searchedProducerMerchWithToneAllArray:Array<MerchData> = []

var searchedProducerBeatsWithToneAllArrayDashboard:Array<BeatData> = []
var searchedProducerBeatsWithToneAllArrayMusic:Array<BeatData> = []
var searchedProducerBeatsWithToneAllArray:Array<BeatData> = []

var searchedProducerInstrumentalsWithToneAllArrayDashboard:Array<InstrumentalData> = []
var searchedProducerInstrumentalsWithToneAllArrayMusic:Array<InstrumentalData> = []
var searchedProducerInstrumentalsWithToneAllArray:Array<InstrumentalData> = []

var previousProducerSongsWithToneAllArrayDashboard:Array<SongData> = []
var previousProducerSongsWithToneAllArrayMusic:Array<SongData> = []
var previousProducerSongsWithToneAllArray:Array<SongData> = []

var previousProducerVideosWithToneAllArrayDashboard:Array<AnyObject> = []
var previousProducerVideosWithToneAllArrayMusic:Array<AnyObject> = []

var previousProducerAlbumsWithToneAllArrayDashboard:Array<AlbumData> = []
var previousProducerAlbumsWithToneAllArrayMusic:Array<AlbumData> = []

var previousProducerBeatsWithToneAllArrayDashboard:Array<BeatData> = []
var previousProducerBeatsWithToneAllArrayMusic:Array<BeatData> = []

var previousArtistSongsWithToneAllArrayDashboard:Array<SongData> = []
var previousArtistSongsWithToneAllArrayMusic:Array<SongData> = []
var previousArtistSongsWithToneAllArray:Array<SongData> = []

var previousProducerInstrumentalsWithToneAllArrayDashboard:Array<InstrumentalData> = []
var previousProducerInstrumentalsWithToneAllArrayMusic:Array<InstrumentalData> = []

var dashboardLatestContentArray1:Array<Any> = []
var dashboardLatestContentArray2:Array<Any> = []
var dashboardLatestContentArray3:Array<Any> = []
var dashboardLatestContentArray4:Array<Any> = []
var dashboardLatestContentArray5:Array<Any> = []
var dashboardLatestContentArray6:Array<Any> = []
var dashboardLatestContentArray7:Array<Any> = []

var musicAllTableViewFeaturedContentDataTimer: Timer!
var musicAllTableViewLatestSongsDataTimer: Timer!
var musicAllTableViewLatestVideosDataTimer: Timer!
var musicAllTableViewFeaturedArtistDataTimer: Timer!
var musicAllTableViewInstrumentalsDataTimer: Timer!

var playerTimer: Timer!
var audiofreeze = false

var currentMusicArtistInfo:ArtistData!
var currentDashboardArtistInfo:ArtistData!
var recievedArtistData:ArtistData!

var currentMusicProducerInfo:ProducerData!
var currentDashboardProducerInfo:ProducerData!
var recievedProducerData:ProducerData!

var popOverIndicator:String!

var browseArray:[Any] = []
var discoverArray:[Any] = []
var producerdiscoverArray:[ProducerData] = []
var artistdiscoverArray:[ArtistData] = []
var songdiscoverArray:[SongData] = []
var videodiscoverArray:[AnyObject] = []
var albumdiscoverArray:[AlbumData] = []
var beatdiscoverArray:[BeatData] = []
var instrumentaldiscoverArray:[InstrumentalData] = []

var albumUploadSongsArray:[AlbumSong] = []

let lightImpactGenerator = UIImpactFeedbackGenerator(style: .light)
let mediumImpactGenerator = UIImpactFeedbackGenerator(style: .medium)
let heavyImpactGenerator = UIImpactFeedbackGenerator(style: .heavy)

var sizelist = ["OSFA","XXS","XS","S","M","L","XL","XXL","XXXL"]
var colorlist = ["Multi-Color", "Black", "White", "Charcoal", "Dark Gray", "Light Gray","Blue","Navy", "Light Blue", "Red", "Maroon","Yellow","Orange","Green", "Olive", "Pink", "Brown", "Tan","Cream"]

class AlbumSong {
    var trackNumber:Int
    var song:Any
    
    init(trackNumber:Int, song:Any) {
        self.trackNumber = trackNumber
        self.song = song
    }
}

class InfoTransition {
    var view:String
    var artist:String
    
    init(view:String, artist:String) {
        self.view = view
        self.artist = artist
    }
}

class LatestBeatData {
    var date:Date
    var beat:BeatData
    
    init(date:Date, beat:BeatData) {
        self.date = date
        self.beat = beat
    }
}

class TableSectionHeader: UITableViewHeaderFooterView {
    @IBOutlet weak var titleLabel: UILabel!
}

extension Double {
    var dollarString:String {
        return String(format: "$%.2f", self)
    }
}

extension UIImage {
    func copy(newSize: CGSize, retina: Bool = true) -> UIImage? {
        // In next line, pass 0 to use the current device's pixel scaling factor (and thus account for Retina resolution).
        // Pass 1 to force exact pixel size.
        UIGraphicsBeginImageContextWithOptions(
            /* size: */ newSize,
            /* opaque: */ false,
            /* scale: */ retina ? 0 : 1
        )
        defer { UIGraphicsEndImageContext() }

        self.draw(in: CGRect(origin: .zero, size: newSize))
        return UIGraphicsGetImageFromCurrentImageContext()
    }
}

class TableSectionHeaderSmall: UITableViewHeaderFooterView {
    @IBOutlet weak var titleLabel: UILabel!
}

