//
//  FavouriteService.swift
//  Orchestra
//
//  Created by Mukesh Shakya on 08/04/2022.
//
//

import Foundation


protocol Favourable {
    var id: Int { get set}
    var title: String { get set}
    var image: String {get set}
}
class Favourite: Codable, Favourable {
//    {
//                "id": 13,
//                "title": "Recording 20220420",
//                "title_jp": "音楽",
//                "tags": [
//                    "PR",
//                    " NEW"
//                ],
//                "record_time": "04/20/2022",
//                "duration": 10,
//                "image": "https://vrorchestra-stag.s3.ap-northeast-1.amazonaws.com/orchestras/8420633ebf30-qkkvi85bb1691b39a51fc8d00.jpg"
//            }
    var id: Int
    var title: String
    var jpTitle: String
    var recordTime: String
    var duration: Int
    var image: String
    var type: String
    var tags: [String]?
    var orchestra: Orchestra?
    var musician: Musician?
    var conductorImage: String?
    var sessionImage: String?
    var venueDiagram: String?
    
    enum CodingKeys: String, CodingKey {
        case id,
             title,
             jpTitle = "title_jp",
             recordTime = "record_time",
             duration = "duration",
             image = "image",
             type,
             tags,
             orchestra,
             musician,
             venueDiagram = "venue_diagram",
             conductorImage = "conductor_image",
             sessionImage = "session_image"
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decodeIfPresent(Int.self, forKey: .id) ?? .zero
        title = try container.decodeIfPresent(String.self, forKey: .title) ?? ""
        jpTitle = try container.decodeIfPresent(String.self, forKey: .jpTitle) ?? ""
        recordTime = try container.decodeIfPresent(String.self, forKey: .recordTime) ?? ""
        duration = try container.decodeIfPresent(Int.self, forKey: .duration) ?? .zero
        image = try container.decodeIfPresent(String.self, forKey: .image) ?? ""
        type = try container.decodeIfPresent(String.self, forKey: .type) ?? ""
        tags = try container.decodeIfPresent([String].self, forKey: .tags) ?? nil
        orchestra = try container.decodeIfPresent(Orchestra?.self, forKey: .orchestra) ?? nil
        musician = try container.decodeIfPresent(Musician?.self, forKey: .musician) ?? nil
        venueDiagram = try container.decodeIfPresent(String.self, forKey: .venueDiagram) ?? ""
        conductorImage = try container.decodeIfPresent(String.self, forKey: .conductorImage) ?? ""
        sessionImage = try container.decodeIfPresent(String.self, forKey: .sessionImage) ?? ""
    }
    
}

//{
//           "id": 7,
//           "name": "Syd Barrett ",
//           "instrument": {
//               "id": 19,
//               "name": "Guitar"
//           },
//           "image": "/uploads/musicians/logo-cwsbbfb93aaf37af141af0840-enrqu99e429c70e4ff2b72e31.png"
//       }
struct FavouritePlayer: Codable, Favourable {
    
    var title: String
    var id: Int
    var image: String
    var instrument: Instrument?
    var manufacturer: String?
    
    enum CodingKeys: String, CodingKey {
        case id,
             title = "name",
             image,
             instrument,
             manufacturer
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decodeIfPresent(Int.self, forKey: .id) ?? 0
        title = try container.decodeIfPresent(String.self, forKey: .title) ?? ""
        image = try container.decodeIfPresent(String.self, forKey: .image) ?? ""
        instrument = try container.decodeIfPresent(Instrument.self, forKey: .instrument) ?? nil
        manufacturer = try container.decodeIfPresent(String?.self, forKey: .manufacturer) ?? nil
    }
    
}

class FavouriteService: FavouriteServiceType {
    
    var cartCount: Int {
        let cartItems: [CartItem] = DatabaseHandler.shared.fetch()
        return cartItems.count
    }
    
    var notificationCount: Int {
        let notifications: [PushNotification] = DatabaseHandler.shared.fetch(filter: "isSeen == false")
        return notifications.count
    }
    
}
