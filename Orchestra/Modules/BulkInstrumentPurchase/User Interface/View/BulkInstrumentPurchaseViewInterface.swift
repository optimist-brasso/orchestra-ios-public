//
//  BulkInstrumentPurchaseViewInterface.swift
//  Orchestra
//
//  Created by Mukesh Shakya on 20/06/2022.
//
//

protocol BulkInstrumentPurchaseViewInterface: AnyObject, BaseViewInterface {
    
    func show(_ models: [BulkInstrumentPurchaseViewModel])
    func show(cartCount: Int)
    func show(notificationCount: Int)
    func show(title: String?, japaneseTitle: String?)
    func show(_ error: Error)
    
}
