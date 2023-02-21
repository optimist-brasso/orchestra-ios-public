//
//  DownloadManager.swift
//  Orchestra
//
//  Created by Rojan Shrestha on 28/06/2022.
//

import AVFoundation
import UIKit

class DownloadManager: NSObject {
    
    static let shared = DownloadManager()
    private var urlSession: URLSession!
    
    //Active downloads
    var persistedVideos: [String: DownloadedMedia] = [:]
    
    private override init() {
        super.init()
        let backgroundConfiguration = URLSessionConfiguration.background(withIdentifier: DownloadConstants.sessionIdentifier)
        urlSession = URLSession(configuration: backgroundConfiguration,
                                delegate: self,
                                delegateQueue: nil)
    }
    
    //Download Video
    func download(_ download: DownloadedMedia) {
        if !canDownload(media: download) {
            return
        }
        //        guard let videoName = video.name else {return}
        guard let downloadURL = URL(string: download.url ?? "") else { return }
        download.task = urlSession.downloadTask(with: downloadURL)
        download.task?.resume()
        persistedVideos[download.url ?? ""] = download
        DatabaseHandler.shared.writeObjects(with: [download.realmModel])
        //            NotificationCenter.default.post(name: DownloadConstants.Notification.videoDownloadStatus.notificationName, object: nil, userInfo: [DownloadConstants.downloadStateKey: DownloadConstants.DownloadState.downloading, DownloadConstants.videoId:video.id ?? 0])
        //        }
    }
    
    func cancelDownload(_ download: DownloadedMedia) {
        if let fileName = download.fileName,
           let model: DownloadedMediaRealmModel = DatabaseHandler.shared.fetch(filter: "fileName == '\(fileName)'").first,
           let currentlyDownload = DownloadManager.shared.persistedVideos[model.url ?? ""] {
            currentlyDownload.state = .notDownloaded
            currentlyDownload.task?.cancel()
            DispatchQueue.main.async { [weak self] in
                self?.persistedVideos.removeValue(forKey: model.url ?? "")
                NotificationCenter.default.post(name: DownloadConstants.Notification.videoDownloadStatus.notificationName, object: download)
            }
        }
    }
    
    private func localFilePath(for url: URL) -> URL {
        let documentPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        return documentPath.appendingPathComponent(url.lastPathComponent)
    }
    
    func getDownloadedMedia(orchestraId: Int, type: OrchestraType, sessionType: SessionType? = nil, directionType: String? = nil, musicianId: Int? = nil) -> DownloadedMediaRealmModel? {
        switch type {
        case .conductor:
            if let model: DownloadedMediaRealmModel = DatabaseHandler.shared.fetch(filter: "type == '\(type.rawValue)' AND orchestraId == \(orchestraId)").first {
                return model
            }
        case .session:
            if let sessionType = sessionType,
               let musicianId = musicianId,
               let model: DownloadedMediaRealmModel = DatabaseHandler.shared.fetch(filter: "type == '\(type.rawValue)' AND orchestraId == \(orchestraId) AND sessionType == '\(sessionType.rawValue)' AND musicianId == \(musicianId)").first {
                return model
            }
        case .hallSound:
            if let directionType = directionType,
               let model: DownloadedMediaRealmModel = DatabaseHandler.shared.fetch(filter: "type == '\(type.rawValue)' AND orchestraId == \(orchestraId) AND sessionType == '\(directionType)'").first {
                    return model
                }
        case .player:
            break
        }
        return nil
    }
    
    func fetchDownloadedMedia(of fileName: String) -> DownloadedMediaRealmModel? {
        if let model: DownloadedMediaRealmModel = DatabaseHandler.shared.fetch(filter: "fileName == '\(fileName)'").first {
            return model
        }
        return nil
    }
    
    func clearDownloads() {
        let fileUrls = FileManager.default.urls(for: .documentDirectory)?.filter({!$0.absoluteString.contains(".realm")})
        fileUrls?.forEach({ url in
            if FileManager.default.fileExists(atPath: url.path) {
                do {
                    try FileManager.default.removeItem(atPath: url.path)
                } catch {
                    print("Could not delete file, probably read-only filesystem")
                }
            }
        })
    }
    
    private func canDownload(media: DownloadedMedia) -> Bool {
        let list = persistedVideos.map( { $0.value.fileName })
        return !list.contains(where: { $0?.fileName == media.fileName})
    }
    
    var downloadFilesCount: Int {
        let fileUrls = FileManager.default.urls(for: .documentDirectory)?.filter({!$0.absoluteString.contains(".realm")})
        return fileUrls?.count ?? .zero
    }
    
    var downloadFilesSize: String {
        let fileUrls = FileManager.default.urls(for: .documentDirectory)?.filter({!$0.absoluteString.contains(".realm")})
        var totalSize: Int64 = .zero
        fileUrls?.forEach({ url in
            totalSize += Int64(url.fileSize)
        })
        if totalSize == .zero {
            return "0 KB"
        }
        let totalSizeString = ByteCountFormatter.string(fromByteCount: Int64(totalSize), countStyle: .memory)
        return totalSizeString
    }
    
    var freeMemory: String {
//        return DiskStatus.freeDiskSpace
//        guard let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return "N/A"}
//        do {
//            let values = try url.resourceValues(forKeys: [.volumeAvailableCapacityForImportantUsageKey])
//            if let capacity = values.volumeAvailableCapacityForImportantUsage {
//                return ByteCountFormatter.string(fromByteCount: capacity, countStyle: .memory)
//            } else {
//                return "N/A"
//            }
//        } catch {
//            return "N/A"
//        }
        let documentDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).last!
        guard
            let systemAttributes = try? FileManager.default.attributesOfFileSystem(forPath: documentDirectory),
            let freeSize = systemAttributes[.systemFreeSize] as? NSNumber
        else {
            // something failed
            return "N/A"
        }
        return ByteCountFormatter.string(fromByteCount: freeSize.int64Value, countStyle: .memory)
    }
    
}

extension DownloadManager: URLSessionDownloadDelegate, URLSessionDelegate {
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        DispatchQueue.main.async { [weak self] in
            if let fileName = task.originalRequest?.url?.absoluteString.fileName,
               let realmModel: DownloadedMediaRealmModel = DownloadManager.shared.fetchDownloadedMedia(of: fileName) {
                let model = realmModel.normalModel
                self?.cancelDownload(model)
            }
            if let error = error as? NSError,
               error.code == 28 {
                DownloadConstants.Notification.videoDownloadStatus.fire(withObject: error)
            }
        }
    }
        
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        guard let sourceUrl = downloadTask.originalRequest?.url else {
            return
        }
        updateDownloadCount { _ in }
        let destinationUrl = localFilePath(for: sourceUrl)
        let fileManager = FileManager.default
        try? fileManager.removeItem(at: destinationUrl)
        do {
            try fileManager.copyItem(at: location, to: destinationUrl)
            guard let url = downloadTask.originalRequest?.url?.absoluteString,
                let download = persistedVideos[url]
            else {
                return
            }
            persistedVideos.removeValue(forKey: url)
            download.state = .downloaded
            download.path = destinationUrl.absoluteString
            DispatchQueue.main.async {
                let realmModel = download.realmModel
                DatabaseHandler.shared.writeObjects(with: [realmModel])
                NotificationCenter.default.post(name: DownloadConstants.Notification.videoDownloadStatus.notificationName, object: download)
            }
        } catch let error {
            print("Could not copy file to disk: \(error.localizedDescription)")
        }
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        guard let url = downloadTask.originalRequest?.url?.absoluteString,
            let download = persistedVideos[url] else { return }
        if download.totalSize == nil {
            download.totalSize = Float(totalBytesExpectedToWrite)
        }
        download.downloadedSize = Float(totalBytesWritten)
        download.state = .downloading
//        download.totalSize = Float(totalBytesExpectedToWrite)
        download.progress = Float(totalBytesWritten) / Float(totalBytesExpectedToWrite)
        DispatchQueue.main.async {
            print("Video download progress of file name: \(download.fileName ?? ""): \(download.progress), total: \(download.totalSize ?? .zero)")
            NotificationCenter.default.post(name: DownloadConstants.Notification.videoDownloadStatus.notificationName, object: download)
            //            print("Downloading of: \(download.name)", download.progress)
        }
    }
    
    func urlSessionDidFinishEvents(forBackgroundURLSession session: URLSession) {
        DispatchQueue.main.async {
            if let appDelegate = UIApplication.shared.delegate as? AppDelegate,
               let completionHandler = appDelegate.backgroundCompletionHandler {
                appDelegate.backgroundCompletionHandler = nil
                completionHandler()
            }
        }
    }
    
}

class DiskStatus {
    
    class func MBFormatter(_ bytes: Int64) -> String {
        let formatter = ByteCountFormatter()
        formatter.allowedUnits = ByteCountFormatter.Units.useMB
        formatter.countStyle = ByteCountFormatter.CountStyle.decimal
        formatter.includesUnit = false
        return formatter.string(fromByteCount: bytes) as String
    }
    
    class var totalDiskSpace: String {
        get {
            return ByteCountFormatter.string(fromByteCount: totalDiskSpaceInBytes, countStyle: ByteCountFormatter.CountStyle.file)
        }
    }
    
    class var freeDiskSpace: String {
        get {
            return ByteCountFormatter.string(fromByteCount: freeDiskSpaceInBytes, countStyle: .memory)
        }
    }
    
    class var usedDiskSpace: String {
        get {
            return ByteCountFormatter.string(fromByteCount: usedDiskSpaceInBytes, countStyle: .memory)
        }
    }
    
    class var totalDiskSpaceInBytes: Int64 {
        get {
            do {
                let systemAttributes = try FileManager.default.attributesOfFileSystem(forPath: NSHomeDirectory() as String)
                let space = (systemAttributes[FileAttributeKey.systemSize] as? NSNumber)?.int64Value
                return space!
            } catch {
                return .zero
            }
        }
    }
    
    class var freeDiskSpaceInBytes:Int64 {
        get {
            do {
                let systemAttributes = try FileManager.default.attributesOfFileSystem(forPath: NSHomeDirectory() as String)
                let freeSpace = (systemAttributes[.systemFreeSize] as? NSNumber)?.int64Value
                return freeSpace!
            } catch {
                return .zero
            }
        }
    }
    
    class var usedDiskSpaceInBytes:Int64 {
        get {
            let usedSpace = totalDiskSpaceInBytes - freeDiskSpaceInBytes
            return usedSpace
        }
    }
    
}

//MARK: DownloadCountApi
extension DownloadManager: DownloadCountApi {}
