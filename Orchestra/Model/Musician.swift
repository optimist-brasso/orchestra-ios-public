//
//  Player.swift
//  Orchestra
//
//  Created by Mukesh Shakya on 22/04/2022.
//

import Foundation

class Musician: Codable {
    
    var id: Int?
    var name: String?
    var instrument: Instrument?
    var image: String?
    var images: [String]?
    var band: String?
    var birthday: String?
    var bloodGroup: String?
    var birthplace: String?
    var message: String?
    var twitter: String?
    var instagram: String?
    var facebook: String?
    var youtube: String?
    var profileLink: String?
    var isFavourite: Bool?
    var performances: [Orchestra]?
    var manufacturer: String?
    
    enum CodingKeys: String, CodingKey {
        case id,
             name,
             instrument,
             image,
             images,
             band,
             birthday,
             bloodGroup = "blood_group",
             birthplace,
             message,
             twitter = "twitter_link",
             instagram = "instagram_link",
             facebook = "facebook_link",
             youtube = "youtube_link",
             profileLink = "profile_link",
             isFavourite = "is_favourite",
             performances,
             manufacturer
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decodeIfPresent(Int?.self, forKey: .id) ?? nil
        name = try container.decodeIfPresent(String?.self, forKey: .name) ?? nil
        instrument = try container.decodeIfPresent(Instrument?.self, forKey: .instrument) ?? nil
        image = try container.decodeIfPresent(String?.self, forKey: .image) ?? nil
        images = try container.decodeIfPresent([String]?.self, forKey: .images) ?? nil
        band = try container.decodeIfPresent(String?.self, forKey: .band) ?? nil
        birthday = try container.decodeIfPresent(String?.self, forKey: .birthday) ?? nil
        bloodGroup = try container.decodeIfPresent(String?.self, forKey: .bloodGroup) ?? nil
        birthplace = try container.decodeIfPresent(String?.self, forKey: .birthplace) ?? nil
        message = try container.decodeIfPresent(String?.self, forKey: .message) ?? nil
        twitter = try container.decodeIfPresent(String?.self, forKey: .twitter) ?? nil
        instagram = try container.decodeIfPresent(String?.self, forKey: .instagram) ?? nil
        facebook = try container.decodeIfPresent(String?.self, forKey: .facebook) ?? nil
        youtube = try container.decodeIfPresent(String?.self, forKey: .youtube) ?? nil
        profileLink = try container.decodeIfPresent(String?.self, forKey: .profileLink) ?? nil
        isFavourite = try container.decodeIfPresent(Bool?.self, forKey: .isFavourite) ?? nil
        performances = try container.decodeIfPresent([Orchestra]?.self, forKey: .performances) ?? nil
        manufacturer = try container.decodeIfPresent(String?.self, forKey: .manufacturer) ?? nil
    }
    
    init() {}
    
}
