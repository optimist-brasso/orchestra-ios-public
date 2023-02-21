//
//  Profile.swift
//  Orchestra
//
//  Created by Mukesh Shakya on 18/04/2022.
//

import Foundation
import RealmSwift

//class Profession: Object, Decodable {
////    {
////                    "id": 1001,
////                    "title": "小中学生",
////                    "createdAt": "2022-04-04T08:02:20.704Z",
////                    "updatedAt": "2022-04-04T08:02:20.704Z"
////                },
//
//    @Persisted (primaryKey: true) var id: Int
//    @Persisted var title = ""
//
//
//    enum CodingKeys: String, CodingKey {
//        case id
//        case title
//    }
//
//    override init() {
//        super.init()
//    }
//    required init(from decoder: Decoder) throws {
//        super.init()
//        let container = try decoder.container(keyedBy: CodingKeys.self)
//        self.id = try container.decode(Int.self, forKey: .id)
//        title = try container.decode(String.self, forKey: .title)
//    }
//
//}
class Profile: Object, Codable {
    
    @Persisted (primaryKey: true) var id: Int
    @Persisted var name: String?
    @Persisted var username: String?
    @Persisted var gender: String?
    @Persisted var musicalInstrument: String?
    @Persisted var address: String?
    @Persisted var postalCode: String?
    @Persisted var dob: String?
    @Persisted var email: String?
    @Persisted var profession: String?
    @Persisted var image: String?
    @Persisted var selfIntroduction: String?
    @Persisted var profileStatus: Bool?
    @Persisted var points: Int?
    @Persisted var notificationStatus: Bool?
    
    enum CodingKeys: String, CodingKey {
        case id,
             name = "name",
             username,
             gender,
             musicalInstrument = "music_instrument",
             address,
             postalCode = "postal_code",
             dob,
             email,
             profession = "professional",
             image = "profile_image",
             selfIntroduction = "short_description",
             profileStatus = "profile_status",
             points = "total_points",
             notificationStatus = "notification_status"
    }
    
    override init() {
        super.init()
    }
    
    required init(from decoder: Decoder) throws {
        super.init()
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decodeIfPresent(Int.self, forKey: .id) ?? .zero
        name = try container.decodeIfPresent(String?.self, forKey: .name) ?? nil
        username = try container.decodeIfPresent(String?.self, forKey: .username) ?? nil
        gender = try container.decodeIfPresent(String?.self, forKey: .gender) ?? nil
        musicalInstrument = try container.decodeIfPresent(String?.self, forKey: .musicalInstrument) ?? nil
        address = try container.decodeIfPresent(String?.self, forKey: .address) ?? nil
        postalCode = try container.decodeIfPresent(String?.self, forKey: .postalCode) ?? nil
        dob = try container.decodeIfPresent(String?.self, forKey: .dob) ?? nil
        email = try container.decodeIfPresent(String?.self, forKey: .email) ?? nil
        profession = try container.decodeIfPresent(String?.self, forKey: .profession) ?? nil
        image = try container.decodeIfPresent(String?.self, forKey: .image) ?? nil
        selfIntroduction = try container.decodeIfPresent(String?.self, forKey: .selfIntroduction) ?? nil
        profileStatus = try container.decodeIfPresent(Bool?.self, forKey: .profileStatus) ?? nil
        points = try container.decodeIfPresent(Int?.self, forKey: .points) ?? nil
        notificationStatus = try container.decodeIfPresent(Bool?.self, forKey: .notificationStatus) ?? nil
    }
    
}
