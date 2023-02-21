//
//  AppendixVideoDetailStructure.swift
//  Orchestra
//
//  Created by Mukesh Shakya on 02/08/2022.
//

import Foundation

struct AppendixVideoDetailStructure {
    
    var file: String?
    var thumbnail: String?
    var isPartBought: Bool?
    var isBought: Bool?
    var instrument: String?
    var price: String?
    var isDownloaded: Bool?
    var orchestra: AppendixVideoDetailOrchestraStructure?
    var description: String?
    var isFavourite = false
    
}

struct AppendixVideoDetailOrchestraStructure {
    
    var title: String?
    var titleJapanese: String?
    var description: String?
    var image: String?
    var organizationDiagram: String?
    var composer: String?
    var conductor: String?
    var venueTitle: String?
    var duration: String?
    var releaseDate: String?
    var organization: String?
    var businessType: String?
    var liscenceNumber: String?
    
}
