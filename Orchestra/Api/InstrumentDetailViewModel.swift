//
//  InstrumentDetailViewModel.swift
//  Orchestra
//
//  Created by Mukesh Shakya on 24/06/2022.
//

import Foundation

struct InstrumentDetailViewModel {
    
    var name: String?
    var musician: String?
    var vrFile: String?
    var vrThumbnail: String?
    var description: String?
    var orchestra: InstrumentDetailOrchestraViewModel?
    var isBought: Bool?
    var isPremiumBought: Bool?
    var price: String?
    var isDownloaded: Bool?
    var isFavourite: Bool
    
}

struct InstrumentDetailOrchestraViewModel {
    
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
