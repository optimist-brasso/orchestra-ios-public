//
//  IAPProduct.swift
//  Orchestra
//
//  Created by Mukesh Shakya on 18/07/2022.
//

import Foundation

//enum PaymentTerm: Int {
//    
//    case weekly = 0
//    case monthly
//    case biMonthly
//    case triMonthly
//    case quaterly
//    case yearly
//    
//}

struct IAPProduct {
    
    var cartItem: IAPCartItem?
    var identifier: String
    var localizedPrice: String
//    public var term: PaymentTerm
    var amount: Double
    var currency: String
    var regionCode: String
    
}

struct InAppPurchase {
    
    public var product: IAPProduct?
    public var receiptData: Data
    public var receiptValue: String
    public var purchasedDate: Date?
    
}
