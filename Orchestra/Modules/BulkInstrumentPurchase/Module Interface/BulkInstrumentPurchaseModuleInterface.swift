//
//  BulkInstrumentPurchaseModuleInterface.swift
//  Orchestra
//
//  Created by Mukesh Shakya on 20/06/2022.
//
//

protocol BulkInstrumentPurchaseModuleInterface: AnyObject {
    
    func viewIsReady()
    func previousModule()
    func buy()
    func notification()
    func cart()
    func select(at index: Int)
    func addToCart()
    
}
