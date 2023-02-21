//
//  BulkInstrumentBuyConfirmationInteractorIO.swift
//  Orchestra
//
//  Created by Mukesh Shakya on 21/06/2022.
//
//

protocol BulkInstrumentBuyConfirmationInteractorInput: AnyObject {
    
    func getData()
    func buy()
    func addToCart()
    func cart()
    
}

protocol BulkInstrumentBuyConfirmationInteractorOutput: AnyObject {
    
    func obtained(title: String?, japaneseTitle: String?)
    func obtained(_ error: Error)
    func obtained(_ buySuccess: Bool, total: String)

}
