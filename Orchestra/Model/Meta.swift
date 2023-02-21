//
//  Meta.swift
//  
//
//  Created by Mukesh Shakya on 05/01/2022.
//

import Foundation

struct Meta: Codable {
    
    var pagination : Pagination?
    
    enum CodingKeys: String, CodingKey {
        case pagination
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        pagination = try container.decodeIfPresent(Pagination?.self, forKey: .pagination) ?? nil
    }
    
}
