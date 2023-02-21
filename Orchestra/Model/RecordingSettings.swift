//
//  RecordSettings.swift
//  Orchestra
//
//  Created by Mukesh Shakya on 25/05/2022.
//

import Foundation

class RecordingSettings: Codable {
    
    var fileFormat: String?
    var encodingQuality: String?
    var samplingRate: String?
    var bitRate: String?
    var channel: String?
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        fileFormat = try container.decodeIfPresent(String?.self, forKey: .fileFormat) ?? nil
        encodingQuality = try container.decodeIfPresent(String?.self, forKey: .encodingQuality) ?? nil
        samplingRate = try container.decodeIfPresent(String?.self, forKey: .samplingRate) ?? nil
        bitRate = try container.decodeIfPresent(String?.self, forKey: .bitRate) ?? nil
        channel = try container.decodeIfPresent(String?.self, forKey: .channel) ?? nil
    }
    
    init() {
        fileFormat = RecordingSetting.fileFormat.values?.first
        encodingQuality = nil //RecordingSetting.encodingQuality.values?.first
        samplingRate = RecordingSetting.samplingRate.values?.first
        bitRate = RecordingSetting.bitRate.values?.first
        channel = nil //RecordingSetting.channel.values?.first
        Cacher().setValue(type: RecordingSettings.self, object: self, key: .recordingSettings)
    }
    
}
