//
//  ResponseMessage.swift
//  
//
//  Created by Mukesh Shakya on 05/01/2022.
//

import Foundation

public struct ResponseMessage: Codable {
    
    public var title : String?
    public var detail : String?
    public var code: String?
    
    init(detail: String) {
        self.detail = detail
    }
    
    enum CodingKeys: String, CodingKey {
        case title
        case detail
        case code
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        title = try container.decodeIfPresent(String?.self, forKey: .title) ?? nil
        detail = try container.decodeIfPresent(String?.self, forKey: .detail) ?? nil
        code = try container.decodeIfPresent(String?.self, forKey: .code) ?? nil
    }
    
}
