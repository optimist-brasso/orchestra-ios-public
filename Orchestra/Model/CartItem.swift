//
//  CartItem.swift
//  Orchestra
//
//  Created by Mukesh Shakya on 11/05/2022.
//

import Foundation
import RealmSwift

class CartItem: Object, Codable {
    
    @Persisted (primaryKey: true) var id: Int?
    @Persisted var orchestraId: Int?
    @Persisted var orchestraType: String?
    @Persisted var sessionType: String?
    @Persisted var isPremium: Bool?
    @Persisted var title: String?
    @Persisted var titleJapanese: String?
    @Persisted var price: Double?
    @Persisted var instrument: String?
    @Persisted var musicianId: Int?
    @Persisted var musician: String?
    @Persisted var instrumentId: Int?
    
    
    var isSelected = false
    
    enum CodingKeys: String, CodingKey {
        case id,
             orchestraId = "orchestra_id",
             orchestraType = "type",
             sessionType = "session_type",
             isPremium = "is_premium",
             title,
             titleJapanese = "title_jp",
             price,
             instrument,
             musicianId = "musician_id",
             musician = "musician_name",
             instrumentId = "instrument_id"
    }
    
    required init(from decoder: Decoder) throws {
        super.init()
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decodeIfPresent(Int?.self, forKey: .id) ?? nil
        orchestraId = try container.decodeIfPresent(Int?.self, forKey: .orchestraId) ?? nil
        orchestraType = try container.decodeIfPresent(String?.self, forKey: .orchestraType) ?? nil
        sessionType = try container.decodeIfPresent(String?.self, forKey: .sessionType) ?? nil
        isPremium = try container.decodeIfPresent(Bool?.self, forKey: .isPremium) ?? nil
        title = try container.decodeIfPresent(String?.self, forKey: .title) ?? nil
        titleJapanese = try container.decodeIfPresent(String?.self, forKey: .titleJapanese) ?? nil
        price = try container.decodeIfPresent(Double?.self, forKey: .price) ?? nil
        instrument = try container.decodeIfPresent(String?.self, forKey: .instrument) ?? nil
        musicianId = try container.decodeIfPresent(Int?.self, forKey: .musicianId) ?? nil
        musician = try container.decodeIfPresent(String?.self, forKey: .musician) ?? nil
        instrumentId = try container.decodeIfPresent(Int?.self, forKey: .instrumentId) ?? nil
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(orchestraId, forKey: .orchestraId)
        try container.encode(orchestraType, forKey: .orchestraType)
        try container.encode(sessionType, forKey: .sessionType)
        try container.encode(isPremium, forKey: .isPremium)
        try container.encode(title, forKey: .title)
        try container.encode(titleJapanese, forKey: .titleJapanese)
        try container.encode(price, forKey: .price)
        try container.encode(instrument, forKey: .instrument)
        try container.encode(musicianId, forKey: .musicianId)
        try container.encode(instrumentId, forKey: .instrumentId)
    }
    
    override init() {}
    
    var iapCartItem: IAPCartItem {
        let model = IAPCartItem()
        model.id = id
        model.orchestraId = orchestraId
        model.orchestraType = orchestraType
        model.sessionType = sessionType
        model.musicianId = musicianId
        model.price = price
        return model
    }
    
}

class IAPCartItem: Codable {
    
    var id: Int?
    var orchestraId: Int?
    var orchestraType: String?
    var sessionType: String?
    var musicianId: Int?
    var identifier: String?
    var price: Double?

    enum CodingKeys: String, CodingKey {
        case id,
             orchestraId = "orchestra_id",
             orchestraType = "type",
             sessionType = "session_type",
             musicianId = "musician_id",
             identifier = "product_identifier",
             price
    }
    
//    required init(from decoder: Decoder) throws {
//        let container = try decoder.container(keyedBy: CodingKeys.self)
//        id = try container.decodeIfPresent(Int?.self, forKey: .id) ?? nil
//        orchestraId = try container.decodeIfPresent(Int?.self, forKey: .orchestraId) ?? nil
//        orchestraType = try container.decodeIfPresent(String?.self, forKey: .orchestraType) ?? nil
//        sessionType = try container.decodeIfPresent(String?.self, forKey: .sessionType) ?? nil
//        musicianId = try container.decodeIfPresent(Int?.self, forKey: .musicianId) ?? nil
//        identifier = try container.decodeIfPresent(String?.self, forKey: .identifier) ?? nil
//    }
    
    init() {}
    
}
