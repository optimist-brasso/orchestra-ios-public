//
//  AppendixVideoDetailViewModel.swift
//  Orchestra
//
//  Created by Mukesh Shakya on 02/08/2022.
//

import Foundation

struct AppendixVideoDetailViewModel {
    
    var file: String?
    var thumbnail: String?
    var isPartBought: Bool?
    var isBought: Bool?
    var instrument: String?
    var price: String?
    var isDownloaded: Bool?
    var orchestra: AppendixVideoDetailOrchestraViewModel?
    var description: String?
    var isFavourite: Bool
    
}

struct AppendixVideoDetailOrchestraViewModel {
    
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
