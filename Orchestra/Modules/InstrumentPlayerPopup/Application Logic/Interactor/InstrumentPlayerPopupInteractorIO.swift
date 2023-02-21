//
//  InstrumentPlayerPopupInteractorIO.swift
//  Orchestra
//
//  Created by Mukesh Shakya on 22/06/2022.
//
//

protocol InstrumentPlayerPopupInteractorInput: AnyObject {
    
    func getData()
    func sendData()
    func addToCart(of type: SessionType?)
    func buy(of type: SessionType?)

}

protocol InstrumentPlayerPopupInteractorOutput: AnyObject {
    
    func obtained(_ model: InstrumentPlayerPopupStructure)
    func obtainedSuccess()
    func obtained(_ error: Error)
    func obtainedProduct()

}
