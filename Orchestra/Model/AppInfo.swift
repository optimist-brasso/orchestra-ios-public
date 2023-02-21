//
//  AppInfo.swift
//  Orchestra
//
//  Created by manjil on 07/04/2022.
//

import Foundation
import RealmSwift

class AppInfo: Object, Decodable {
    @Persisted (primaryKey: true) var id: String = "1"
    @Persisted var configureData: ConfigData?
    @Persisted var profession: List<Profession>
    
    enum CodingKeys: String, CodingKey {
        case configureData = "configData"
        case profession
    }
    
    override init() {
        super.init()
    }
    
    required init(from decoder: Decoder) throws {
        super.init()
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = "1"
        configureData = try container.decode(ConfigData.self, forKey: .configureData)
        let profession = try container.decode([Profession].self, forKey: .profession)
       
        profession.forEach {  self.profession.append($0) }
    }
    
}

class ConfigData: Object, Decodable {
    @Persisted (primaryKey: true) var id: String = "1"
    @Persisted var profileImageSize = ""
    @Persisted var profileImageType = ""
    
    enum CodingKeys: String, CodingKey {
        case profileImageSize = "profile_image_size"
        case profileImageType = "profile_image_type"
    }
    
    override init() {
        super.init()
    }
    
    required init(from decoder: Decoder) throws {
        super.init()
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = "1"
        profileImageSize = try container.decodeIfPresent(String.self, forKey: .profileImageSize) ?? ""
        profileImageType = try container.decodeIfPresent(String.self, forKey: .profileImageType) ?? ""
    }
}

class Profession: Object, Decodable {
//    {
//                    "id": 1001,
//                    "title": "小中学生",
//                    "createdAt": "2022-04-04T08:02:20.704Z",
//                    "updatedAt": "2022-04-04T08:02:20.704Z"
//                },
    
    @Persisted (primaryKey: true) var id: Int
    @Persisted var title = ""
    
    
    enum CodingKeys: String, CodingKey {
        case id
        case title 
    }
    
    override init() {
        super.init()
    }
    required init(from decoder: Decoder) throws {
        super.init()
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int.self, forKey: .id)
        title = try container.decode(String.self, forKey: .title)
    }
    
}
