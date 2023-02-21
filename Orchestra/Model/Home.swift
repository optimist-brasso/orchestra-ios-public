//
//  Home.swift
//  Orchestra
//
//  Created by Mukesh Shakya on 15/04/2022.
//

import Foundation

class Home: Codable {
    
    var banners: [Banner]?
    var recommendations: [Orchestra]?
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        banners = try container.decodeIfPresent([Banner]?.self, forKey: .banners) ?? nil
        recommendations = try container.decodeIfPresent([Orchestra]?.self, forKey: .recommendations) ?? nil
    }
    
}
