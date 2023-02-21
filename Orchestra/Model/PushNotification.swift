//
//  PushNotification.swift
//  Orchestra
//
//  Created by Mukesh Shakya on 08/06/2022.
//

import RealmSwift

class PushNotification: Object, Codable {
    
    @Persisted (primaryKey: true) var id: Int = .zero
    @Persisted var title: String = ""
    @Persisted var body: String = ""
    @Persisted var image: String = ""
    @Persisted var createdAt: String = ""
    @Persisted var color: String = ""
    @Persisted var isSeen = false
    
    enum CodingKeys: String, CodingKey {
        case id,
             title,
             body,
             image,
             createdAt = "created_at",
             color,
             isSeen = "seen_status"
    }
    
    override init() {
        super.init()
    }
    
    required init(from decoder: Decoder) throws {
        super.init()
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int.self, forKey: .id)
        title = try container.decodeIfPresent(String.self, forKey: .title) ?? ""
        body = try container.decodeIfPresent(String.self, forKey: .body) ?? ""
        image = try container.decodeIfPresent(String.self, forKey: .image) ?? ""
        createdAt = try container.decodeIfPresent(String.self, forKey: .createdAt) ?? ""
        color = try container.decodeIfPresent(String.self, forKey: .color) ?? ""
        isSeen = try container.decodeIfPresent(Bool.self, forKey: .isSeen) ?? false
    }
    
}
