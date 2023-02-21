//
//  BulkInstrumentBuyConfirmationModuleInterface.swift
//  Orchestra
//
//  Created by Mukesh Shakya on 21/06/2022.
//
//

protocol BulkInstrumentBuyConfirmationModuleInterface: AnyObject {
    
    func viewIsReady()
    func buy()
    func addToCart()
    func previousModule()
    func cart()
    
}
