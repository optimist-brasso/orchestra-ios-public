//
//  ApiResponse.swift
//  
//
//  Created by Mukesh Shakya on 05/01/2022.
//

import Foundation

public struct ApiResponse<T: Codable>: Container {
    
    var data: T?
    var errors: [ResponseMessage]?
    var meta: Meta?
    var hasData: Bool {
        return data != nil
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        data = try container.decodeIfPresent(T?.self, forKey: .data) ?? nil
        errors = try container.decodeIfPresent([ResponseMessage]?.self, forKey: .errors) ?? nil
        meta = try container.decodeIfPresent(Meta?.self, forKey: .meta) ?? nil
    }
    
}
