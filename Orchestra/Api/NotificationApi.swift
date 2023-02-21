//
//  NotificationApi.swift
//  Orchestra
//
//  Created by manjil on 27/04/2022.
//

import Foundation
import RealmSwift

protocol NotificationApi { }

struct NotificationModel: Codable {
//    "id": 2,
//                "title": "Title is required",
//                "body": "Body is required×",
//                "image": null,
//                "created_at": "2022-04-25"
    var id: Int
    var title: String
    var body: String
    var image: String
    var createdAt: String
    var color: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case body
        case image
        case createdAt = "created_at"
        case color
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int.self, forKey: .id)
        title = try container.decodeIfPresent(String.self, forKey: .title) ?? ""
        body = try container.decodeIfPresent(String.self, forKey: .body) ?? ""
        image = try container.decodeIfPresent(String.self, forKey: .image) ?? ""
        createdAt = try container.decodeIfPresent(String.self, forKey: .createdAt) ?? ""
        color = try container.decodeIfPresent(String.self, forKey: .color) ?? ""
    }
}

extension  NotificationApi {
    
    func getNotificationList(completion: @escaping (Result<[NotificationModel], Error>) -> Void) {
        let endPoint = EK_EndPoint(path: "notification", method: .get)
        URLSession.shared.dataTask(request: endPoint.request()) { (result: Result<([NotificationModel], Pagination?), Error>) in
            switch result {
            case .success((let response, _)):
                completion(.success(response))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
}
