//
//  BillingHistory.swift
//  Orchestra
//
//  Created by rohit lama on 17/05/2022.
//

import Foundation

class BillingHistory: Codable {
    
    var id: Int?
    var title: String?
    var japaneseTitle: String?
    var duration: String?
    var date: String?
    var price: Double?
    var type: String?
    var instrument: String?
    var isPremium: Bool?
    var sessionType: String?
    var musician: String?
    
    enum CodingKeys: String, CodingKey {
        case id,
             title,
             japaneseTitle = "title_jp",
             duration,
             date,
             price,
             type,
             instrument,
             isPremium = "is_premium",
             sessionType = "session_type",
             musician = "musician_name"
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decodeIfPresent(Int?.self, forKey: .id) ?? nil
        title = try container.decodeIfPresent(String?.self, forKey: .title) ?? nil
        japaneseTitle = try container.decodeIfPresent(String?.self, forKey: .japaneseTitle) ?? nil
        duration = try container.decodeIfPresent(String?.self, forKey: .duration) ?? nil
        date = try container.decodeIfPresent(String?.self, forKey: .date) ?? nil
        price = try container.decodeIfPresent(Double?.self, forKey: .price) ?? nil
        type = try container.decodeIfPresent(String?.self, forKey: .type) ?? nil
        instrument = try container.decodeIfPresent(String?.self, forKey: .instrument) ?? nil
        isPremium = try container.decodeIfPresent(Bool?.self, forKey: .isPremium) ?? nil
        sessionType = try container.decodeIfPresent(String?.self, forKey: .sessionType) ?? nil
        musician = try container.decodeIfPresent(String?.self, forKey: .musician) ?? nil
    }
    
}
