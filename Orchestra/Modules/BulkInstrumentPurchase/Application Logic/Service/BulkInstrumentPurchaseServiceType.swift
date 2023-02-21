//
//  BulkInstrumentPurchaseServiceType.swift
//  Orchestra
//
//  Created by Mukesh Shakya on 20/06/2022.
//
//

import Foundation

protocol BulkInstrumentPurchaseServiceType: AnyObject, OrchestraInstrumentApi, AddToCartApi {
    
    var cartCount: Int { get }
    var notificationCount: Int { get }
    
}
