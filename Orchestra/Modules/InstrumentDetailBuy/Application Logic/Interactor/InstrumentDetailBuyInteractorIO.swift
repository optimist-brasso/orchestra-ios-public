//
//  InstrumentDetailBuyInteractorIO.swift
//  Orchestra
//
//  Created by Mukesh Shakya on 22/06/2022.
//
//

protocol InstrumentDetailBuyInteractorInput: AnyObject {
    
    func getData()
    func addToCart()
    func cart()
    func buy()

}

protocol InstrumentDetailBuyInteractorOutput: AnyObject {
    
    func obtained(_ model: InstrumentDetailBuyStructure)
    func obtained(_ error: Error)
    func obtainedAddedInCart()
    func obtainedBuySuccess()
    func obtainedProduct()

}
