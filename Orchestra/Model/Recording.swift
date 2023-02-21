//
//  Recording.swift
//  Orchestra
//
//  Created by Mukesh Shakya on 10/05/2022.
//

import Foundation

class Recording: Codable {
    
    var id: Int?
    var title: String?
    var edition: String?
    var date: String?
    var duration: Int?
    var path: String?
    var image: String?
    
    enum CodingKeys: String, CodingKey {
        case id,
             title = "song_title",
             edition,
             date = "recorded_date",
             duration,
             path = "music_path",
             image = "thumbnail"
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decodeIfPresent(Int?.self, forKey: .id) ?? nil
        title = try container.decodeIfPresent(String?.self, forKey: .title) ?? nil
        edition = try container.decodeIfPresent(String?.self, forKey: .edition) ?? nil
        date = try container.decodeIfPresent(String?.self, forKey: .date) ?? nil
        duration = try container.decodeIfPresent(Int?.self, forKey: .duration) ?? nil
        path = try container.decodeIfPresent(String?.self, forKey: .path) ?? nil
        image = try container.decodeIfPresent(String?.self, forKey: .image) ?? nil
    }
    
}
