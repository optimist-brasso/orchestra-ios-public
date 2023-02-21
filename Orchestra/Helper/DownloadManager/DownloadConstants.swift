//
//  DownloadConstants.swift
//  Orchestra
//
//  Created by Rojan Shrestha on 28/06/2022.
//

import Foundation

struct DownloadConstants {
    
    static let downloadStateKey = "DownloadStateKey"
    static let videoId = "VideoId"
    static let sessionIdentifier = "Brasso-Identifier"
    static let localUrl = "LocalUrl"
    
    
    enum DownloadState: String {
        case notDownloaded,
             downloading,
             downloaded
    }
    
    enum DownloadTypes: String {
        case instument
        case conductor
    }
    
    struct Notification {
        
        let name: String
        
        var notificationName: NSNotification.Name {
            return NSNotification.Name(rawValue: name)
        }
        
        func fire(withObject object: Any? = nil) {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: name), object: object)
        }
        
        static let videoDownloadStatus = Notification(name: "VideoDownloadStatus")
        static let downloadComplete = Notification(name: "DownloadComplete")
    }
    
}
