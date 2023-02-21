//
//  PremiumVideoDetailsStructure.swift
//  Orchestra
//
//  Created by Mukesh Shakya on 29/06/2022.
//

import Foundation

struct PremiumVideoDetailsStructure {
    
    var instrument: String?
    var musician: String?
    var file: String?
    var thumbnail: String?
    var description: String?
    var orchestra: PremiumVideoDetailsOrchestraStructure?
    var isPartBought: Bool?
    var isBought: Bool?
    var price: String?
    var isDownloaded: Bool?
    var isFavourite: Bool
    
}

struct PremiumVideoDetailsOrchestraStructure {
    
    var title: String?
    var titleJapanese: String?
    var description: String?
    var composer: String?
    var conductor: String?
    var venueTitle: String?
    var venueDescription: String?
    var duration: String?
    var releaseDate: String?
    var image: String?
    var organization: String?
    var businessType: String?
    var liscenceNumber: String?
    var organizationDiagram: String?
    var band: String?
    
}
