//
//  StreamingDownloadSetting.swift
//  Orchestra
//
//  Created by Mukesh Shakya on 05/08/2022.
//

import Foundation

class StreamingDownloadSetting: Codable {
    
    var wifiStreamingOnly = true
    var mobileDataNotify = true
    var wifiDownloadOnly = true
    
    init() {
        Cacher().setValue(type: StreamingDownloadSetting.self, object: self, key: .streamingDownloadSettings)
    }
    
    init(wifiStreamingOnly: Bool, mobileDataNotify: Bool, wifiDownloadOnly: Bool) {
        self.wifiStreamingOnly = wifiStreamingOnly
        self.mobileDataNotify = mobileDataNotify
        self.wifiDownloadOnly = wifiDownloadOnly
        Cacher().setValue(type: StreamingDownloadSetting.self, object: self, key: .streamingDownloadSettings)
    }
    
}
