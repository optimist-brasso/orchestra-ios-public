//
//  BulkInstrumentPurchaseViewModel.swift
//  Orchestra
//
//  Created by Mukesh Shakya on 28/06/2022.
//

import Foundation

struct BulkInstrumentPurchaseViewModel {
    
    var id: Int?
    var musician: String?
    var image: String?
    var instrument: String?
    var isPartBought: Bool
    var isCurrentlySelected: Bool = false
    var isPremiumBought: Bool
    
}
