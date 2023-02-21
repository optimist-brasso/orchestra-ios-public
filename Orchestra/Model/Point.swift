//
//  Point.swift
//  Orchestra
//
//  Created by Mukesh Shakya on 26/09/2022.
//

import Foundation

class PointBundle: Codable {
    
    var id: Int?
    var title: String?
    var price: Double?
    var image: String?
    var description: String?
    var identifier: String?
    var status: String?
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int?.self, forKey: .id) ?? nil
        title = try container.decodeIfPresent(String?.self, forKey: .title) ?? nil
        price = try container.decodeIfPresent(Double?.self, forKey: .price) ?? nil
        image = try container.decode(String?.self, forKey: .image) ?? nil
        description = try container.decodeIfPresent(String?.self, forKey: .description) ?? nil
        identifier = try container.decode(String?.self, forKey: .identifier) ?? nil
        status = try container.decode(String?.self, forKey: .status) ?? nil
    }
    
}

class PointHistory: Codable {
    var paidPoint: Int
    var freePoint: Int
    var price: Int
    var purchaseDate: String
    var firstExpiry: Expiry?
    var secondExpiry: Expiry?
    var bundleList: [BundleList]
    
    enum CodingKeys: String, CodingKey {
        case paidPoint = "paid_point",
             freePoint = "free_point",
             price,
             purchaseDate = "purchase_date",
             firstExpiry = "first_expiry",
             secondExpiry = "second_expiry",
             bundleList = "bundle_list"
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        bundleList = try container.decodeIfPresent([BundleList].self, forKey: .bundleList) ?? []
        paidPoint = try container.decodeIfPresent(Int.self, forKey: .paidPoint) ?? .zero
        freePoint = try container.decodeIfPresent(Int.self, forKey: .freePoint) ?? .zero
        price = try container.decodeIfPresent(Int.self, forKey: .price) ?? .zero
        purchaseDate = try container.decodeIfPresent(String.self, forKey: .purchaseDate) ?? ""
        firstExpiry = try container.decodeIfPresent(Expiry?.self, forKey: .firstExpiry) ?? nil
        secondExpiry = try container.decodeIfPresent(Expiry?.self, forKey: .secondExpiry) ?? nil
    }
    
}

class Expiry: Codable {
    
    var date: String
    var point: Int?
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        point  = try container.decodeIfPresent(Int?.self, forKey: .point) ?? nil
        date = try container.decodeIfPresent(String.self, forKey: .date) ?? ""
    }
    
}

//class SecondExpiry: Codable {
//    var date: String
//
//    required init(from decoder: Decoder) throws {
//        let container = try decoder.container(keyedBy: CodingKeys.self)
//        date  = try container.decodeIfPresent(String.self, forKey: .date) ?? ""
//    }
//}

class BundleList: Codable {
    
    var id: Int
    var paidPoint: Int
    var freePoint: Int
    var price: Int
    var status: String
    var identifier: String
    
    enum CodingKeys: String, CodingKey {
        case id,
             paidPoint = "paid_point",
             freePoint = "free_point",
             price,
             status,
             identifier
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id  = try container.decodeIfPresent(Int.self, forKey: .id) ?? .zero
        paidPoint = try container.decodeIfPresent(Int.self, forKey: .paidPoint) ?? .zero
        freePoint = try container.decodeIfPresent(Int.self, forKey: .freePoint) ?? .zero
        price = try container.decodeIfPresent(Int.self, forKey: .price) ?? .zero
        status = try container.decodeIfPresent(String.self, forKey: .status) ?? ""
        identifier = try container.decodeIfPresent(String.self, forKey: .identifier) ?? ""
    }
    
}

//{
//            "id": 1,
//            "date": "2023-10-13T05:39:26.203Z",
//            "point": 40
//        }

class Point: Codable {
    
    var id: Int
    var date: String
    var point: Int
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id  = try container.decodeIfPresent(Int.self, forKey: .id) ?? .zero
        point = try container.decodeIfPresent(Int.self, forKey: .point) ?? .zero
        date = try container.decodeIfPresent(String.self, forKey: .date) ?? ""
    }
    
}
