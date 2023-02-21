//
//  DownloadedMedia.swift
//  Orchestra
//
//  Created by Mukesh Shakya on 07/07/2022.
//

import Foundation
import RealmSwift

class DownloadedMediaRealmModel: Object {
    
    @Persisted (primaryKey: true) var id: Int?
//    @Persisted var orchestraId: Int?
//    @Persisted var type: String?
//    @Persisted var sessionType: String?
//    @Persisted var musicianId: Int?
    @Persisted var url: String?
    @Persisted var path: String?
    @Persisted var fileName: String?
    var task: URLSessionDownloadTask?
    var state: DownloadConstants.DownloadState = .notDownloaded
    var progress: Float = .zero
    var downloadedSize: Float?
    var totalSize: Float?
    
    override init() {
    }
    
//    override static func primaryKey() -> String? {
//        return "id"
//    }
    
//    func incrementID() -> Int {
//        let realm = try! Realm()
//        print("Icremented ID: \(realm.objects(DownloadedMedia.self).max(ofProperty: "id") as Int? ?? 0)")
//        return (realm.objects(DownloadedMedia.self).max(ofProperty: "id") as Int? ?? 0) + 1
//    }
    
//    var normalModel: DownloadModel {
//        return DownloadModel(id: id, url: url, type: type, sessionType: sessionType)
//    }
    var normalModel: DownloadedMedia {
        let model = DownloadedMedia()
        model.id = id
//        model.orchestraId = orchestraId
//        model.type = type
//        model.sessionType = sessionType
//        model.musicianId = musicianId
        model.url = url
        model.path = path
        model.task = task
        model.state = state
        model.progress = progress
        model.downloadedSize = downloadedSize
        model.totalSize = totalSize
        model.fileName = fileName
        return model
    }
    
}

class DownloadedMedia {
    
    var id: Int?
//    var orchestraId: Int?
//    var type: String?
//    var sessionType: String?
//    var musicianId: Int?
    var url: String?
    var path: String?
    var task: URLSessionDownloadTask?
    var state: DownloadConstants.DownloadState = .notDownloaded
    var progress: Float = 0
    var downloadedSize: Float?
    var totalSize: Float?
    var fileName: String?
    
    var realmModel: DownloadedMediaRealmModel {
        let model = DownloadedMediaRealmModel()
        model.id = id
//        model.orchestraId = orchestraId
//        model.type = type
//        model.sessionType = sessionType
//        model.musicianId = musicianId
        model.url = url
        model.path = path
        model.task = task
        model.state = state
        model.progress = progress
        model.downloadedSize = downloadedSize
        model.totalSize = totalSize
        model.fileName = fileName
        return model
    }
    
}
