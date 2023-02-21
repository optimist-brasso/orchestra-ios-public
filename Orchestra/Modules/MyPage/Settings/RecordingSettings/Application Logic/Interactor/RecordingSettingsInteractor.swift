//
//  RecordingSettingsInteractor.swift
//  Orchestra
//
//  Created by Mukesh Shakya on 25/05/2022.
//
//

import Foundation

class RecordingSettingsInteractor {
    
	// MARK: Properties
    weak var output: RecordingSettingsInteractorOutput?
    private let service: RecordingSettingsServiceType
    
    // MARK: Initialization
    init(service: RecordingSettingsServiceType) {
        self.service = service
    }

    // MARK: Converting entities
    
}

// MARK: RecordingSettings interactor input interface
extension RecordingSettingsInteractor: RecordingSettingsInteractorInput {
    
    func getData() {
        let recordingSettings = Cacher().value(type: RecordingSettings.self, forKey: .recordingSettings) ?? RecordingSettings()
        output?.obtained(RecordingSettingsStructure(fileFormat: recordingSettings.fileFormat,
                                                    encodingQuality: recordingSettings.encodingQuality,
                                                    samplingRate: recordingSettings.samplingRate,
                                                    bitRate: recordingSettings.bitRate,
                                                    channel: recordingSettings.channel))
    }
    
    func select(value: String?, of type: RecordingSetting?) {
        if let recordSettings = Cacher().value(type: RecordingSettings.self, forKey: .recordingSettings),
           let type = type {
            switch type {
            case .fileFormat:
                recordSettings.fileFormat = value
//            case .encodingQuality:
//                recordSettings.encodingQuality = value
            case .samplingRate:
                recordSettings.samplingRate = value
            case .bitRate:
                recordSettings.bitRate = value
//            case .channel:
//                recordSettings.channel = value
            }
            Cacher().setValue(type: RecordingSettings.self, object: recordSettings, key: .recordingSettings)
        }
    }
    
}
