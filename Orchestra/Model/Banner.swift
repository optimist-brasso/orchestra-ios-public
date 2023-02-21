//
//  Banner.swift
//  Orchestra
//
//  Created by Mukesh Shakya on 15/04/2022.
//

import Foundation

class Banner: Codable {
    
    var id: Int?
    var title: String?
    var image: String?
    var link: BannerLink?
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decodeIfPresent(Int?.self, forKey: .id) ?? nil
        title = try container.decodeIfPresent(String?.self, forKey: .title) ?? nil
        link = try container.decodeIfPresent(BannerLink?.self, forKey: .link) ?? nil
        image = try container.decodeIfPresent(String?.self, forKey: .image) ?? nil
    }
    
}

class BannerLink: Codable {
    
    var type: String?
    var url: String?
    var description: String?
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        type = try container.decodeIfPresent(String?.self, forKey: .type) ?? nil
        url = try container.decodeIfPresent(String?.self, forKey: .url) ?? nil
        description = try container.decodeIfPresent(String?.self, forKey: .description) ?? nil
    }
    
}
