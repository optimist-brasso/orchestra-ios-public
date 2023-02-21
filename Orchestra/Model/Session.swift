//
//  Session.swift
//  Orchestra
//
//  Created by PRAKASH CHANDRA AWAL on 5/5/22.
//

import Foundation

class Session: Codable {
    
    var id: Int?
    var image: String?
    var orchestra: Orchestra?
    var musician: Musician?
    var instrument: Instrument?
    var layouts: [SessionLayout]?
    
    enum CodingKeys: String, CodingKey {
        case id,
             image = "base_image",
             layouts,
             orchestra,
             musician,
             instrument
    }
     
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decodeIfPresent(Int?.self, forKey: .id) ?? nil
        image = try container.decodeIfPresent(String?.self, forKey: .image) ?? nil
        layouts = try container.decodeIfPresent([SessionLayout]?.self, forKey: .layouts) ?? nil
        orchestra = try container.decodeIfPresent(Orchestra?.self, forKey: .orchestra) ?? nil
        musician = try container.decodeIfPresent(Musician?.self, forKey: .musician) ?? nil
        instrument = try container.decodeIfPresent(Instrument?.self, forKey: .instrument) ?? nil
    }
    
}

class SessionLayout: Codable {
    
    var identifier: String
    var label: String
    var w: Double
    var h: Double
    var x: String
    var y: String
    var instrumentId: Int?
    var instrument: String?
    var musicianId: Int?
    var musicianImage: String?
    var musician: String?
    var description: String?
    var isPartBought: Bool?
    
    enum CodingKeys: String, CodingKey {
        case identifier,
             label,
             w,
             h,
             x,
             y,
             instrumentId = "instrument_id",
             instrument = "instrument_title",
             musicianId = "musician_id",
             musician = "instrument_musician",
             musicianImage = "musician_image",
             description
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        identifier = try container.decode(String.self, forKey: .identifier)
        label = try container.decodeIfPresent(String.self, forKey: .label) ?? ""
        w = try container.decode(Double.self, forKey: .w)
        h = try container.decodeIfPresent(Double.self, forKey: .h) ?? .zero
        x = try container.decode(String.self, forKey: .x)
        y = try container.decodeIfPresent(String.self, forKey: .y) ?? ""
        instrumentId = try container.decodeIfPresent(Int?.self, forKey: .instrumentId) ?? nil
        instrument = try container.decodeIfPresent(String?.self, forKey: .instrument) ?? nil
        musicianId = try container.decodeIfPresent(Int?.self, forKey: .musicianId) ?? nil
        musician = try container.decodeIfPresent(String?.self, forKey: .musician) ?? nil
        musicianImage = try container.decodeIfPresent(String?.self, forKey: .musicianImage) ?? nil
        description = try container.decodeIfPresent(String?.self, forKey: .description) ?? nil
    }
    
}
