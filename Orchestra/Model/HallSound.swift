//
//  HallSound.swift
//  Orchestra
//
//  Created by Mukesh Shakya on 15/06/2022.
//

import Foundation

class HallSound: Codable {
    
    var id: Int?
    var fileLink: String?
    var image: String?
    var position: Int?
    var type: String?
    var isDownloaded = false
    var path: String?
//    var progress: Float?
    var downloadedSize: Float?
    var totalSize: Float?
    var floor: String?
    
    enum CodingKeys: String, CodingKey {
        case id,
             fileLink = "audio_file",
             image,
             position,
             type
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decodeIfPresent(Int?.self, forKey: .id) ?? nil
        fileLink = try container.decodeIfPresent(String?.self, forKey: .fileLink) ?? nil
        image = try container.decodeIfPresent(String?.self, forKey: .image) ?? nil
        position = try container.decodeIfPresent(Int?.self, forKey: .position) ?? nil
        type = try container.decodeIfPresent(String?.self, forKey: .type) ?? nil
    }
    
}
