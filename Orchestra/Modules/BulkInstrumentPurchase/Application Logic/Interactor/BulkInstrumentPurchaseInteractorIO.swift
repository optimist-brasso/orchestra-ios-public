//
//  BulkInstrumentPurchaseInteractorIO.swift
//  Orchestra
//
//  Created by Mukesh Shakya on 20/06/2022.
//
//

protocol BulkInstrumentPurchaseInteractorInput: AnyObject {
    
    func getData()
    func buy()
    func select(at index: Int)
    func addToCart()
    func sendData()

}

protocol BulkInstrumentPurchaseInteractorOutput: AnyObject {
    
    func obtained(title: String?, japaneseTitle: String?)
    func obtained(_ models: [BulkInstrumentPurchaseStructure])
    func obtained(_ error: Error)
    func obtained(cartCount: Int)
    func obtained(notificationCount: Int)
    func obtainedConfirmationNeed()
    func obtainedSuccess()

}
