//
//  RecordingSetting.swift
//  Orchestra
//
//  Created by Mukesh Shakya on 25/05/2022.
//

import Foundation

enum RecordingSetting: Int, CaseIterable {
    
    case fileFormat,
         //encodingQuality,
         samplingRate,
         bitRate
        // channel
    
    var title: String? {
        switch self {
        case .fileFormat:
            return LocalizedKey.fileFormat.value
//        case .encodingQuality:
//            return LocalizedKey.encodingQuality.value
        case .samplingRate:
            return LocalizedKey.samplingRate.value
        case .bitRate:
            return LocalizedKey.bitRate.value
//        case .channel:
//            return LocalizedKey.channel.value
        }
    }
    
    var values: [String]? {
        switch self {
        case .fileFormat:
            return ["WAV"]
//        case .encodingQuality:
//            return ["Low", "Medium", "High"]
        case .samplingRate:
            return ["11,025Hz", "22,050Hz", "44,100Hz", "48,000Hz"]
        case .bitRate:
            return ["48kbps", "64kbps", "128kbps", "192kbps", "256kbps", "320kbps"]
//        case .channel:
//            return ["Mono", "Stereo"]
        }
    }
    
}

protocol Recordable {
    var value: String { get }
    var title: String { get }
}

//enum FileFormat: Recordable, CaseIterable {
//    
//}
