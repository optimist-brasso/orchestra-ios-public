//
//  StreamingDownloadSettingsInteractor.swift
//  Orchestra
//
//  Created by Mukesh Shakya on 05/04/2022.
//
//

import Foundation

class StreamingDownloadSettingsInteractor {
    
	// MARK: Properties
    weak var output: StreamingDownloadSettingsInteractorOutput?
    private let service: StreamingDownloadSettingsServiceType
    
    // MARK: Initialization
    init(service: StreamingDownloadSettingsServiceType) {
        self.service = service
    }

    // MARK: Converting entities
    private func convert(_ model: StreamingDownloadSetting) -> StreamingDownloadSettingsStructure {
        return StreamingDownloadSettingsStructure(wifiStreamingOnly: model.wifiStreamingOnly,
                                                  mobileDataNotify: model.mobileDataNotify,
                                                  wifiDownloadOnly: model.wifiDownloadOnly)
    }
    
}

// MARK: StreamingDownloadSettings interactor input interface
extension StreamingDownloadSettingsInteractor: StreamingDownloadSettingsInteractorInput {
    
    func getData() {
        let model = Cacher().value(type: StreamingDownloadSetting.self, forKey: .streamingDownloadSettings) ?? StreamingDownloadSetting()
        output?.obtained(convert(model))
    }
    
    func submit(_ model: StreamingDownloadSettingsStructure) {
        let _ = StreamingDownloadSetting(wifiStreamingOnly: model.wifiStreamingOnly ?? false,
                                         mobileDataNotify: model.mobileDataNotify ?? false,
                                         wifiDownloadOnly: model.wifiDownloadOnly ?? false)
//        let streamingDownloadSetting = StreamingDownloadSetting()
//        streamingDownloadSetting.wifiStreamingOnly = model.wifiStreamingOnly ?? false
//        streamingDownloadSetting.mobileDataNotify = model.mobileDataNotify ?? false
//        streamingDownloadSetting.wifiDownloadOnly = model.wifiDownloadOnly ?? false
//        Cacher().setValue(type: StreamingDownloadSetting.self, object: streamingDownloadSetting, key: .streamingDownloadSettings)
    }
    
}
