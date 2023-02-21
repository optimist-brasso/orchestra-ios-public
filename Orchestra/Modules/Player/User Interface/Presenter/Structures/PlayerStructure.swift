//
//  PlayerStructure.swift
//  Orchestra
//
//  Created by Mukesh Shakya on 25/04/2022.
//

import Foundation

struct PlayerStructure {
    
    var id: Int?
    var name: String?
    var images: [String]?
    var band: String?
    var birthday: String?
    var bloodGroup: String?
    var birthplace: String?
    var message: String?
    var profileLink: String?
    var twitter: String?
    var instagram: String?
    var facebook: String?
    var youtube: String?
    var performances: [PlayerPerformanceStructure]?
    var isFavourite: Bool?
    var manufacturer: String?
    var instrument: String?
    var instrumentId: Int?
    
}
