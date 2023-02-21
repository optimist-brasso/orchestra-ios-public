//
//  BillingHistoryStructure.swift
//  Orchestra
//
//  Created by rohit lama on 11/05/2022.
//

import Foundation

struct BillingHistoryMonthlyStructure {
    
    var date: String?
    var items: [BillingHistoryStructure]?
    var total: Double?
    
}

struct BillingHistoryStructure {
    
    var title: String?
    var date: String?
    var price: Double?
    var type: OrchestraType?
    var instrument: String?
    var isPremium: Bool?
    var sessionType: SessionType?
    var musician: String?
    
}

