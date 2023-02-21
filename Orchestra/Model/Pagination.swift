//
//  Pagination.swift
//  
//
//  Created by Mukesh Shakya on 05/01/2022.
//

import Foundation

public struct Pagination: Codable {
    
    public var totalPages : Int?
    public var currentPage: Int?
    var perPage: Int?
    
    enum CodingKeys: String, CodingKey {
        case totalPages = "total_pages",
             perPage = "per_page",
             currentPage = "current_page"
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        totalPages = try container.decodeIfPresent(Int?.self, forKey: .totalPages) ?? nil
        currentPage = try container.decodeIfPresent(Int?.self, forKey: .currentPage) ?? nil
        perPage = try container.decodeIfPresent(Int?.self, forKey: .perPage) ?? nil
    }
    
}
