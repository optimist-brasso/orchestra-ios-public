//
//  InstrumentDetailBuyViewInterface.swift
//  Orchestra
//
//  Created by Mukesh Shakya on 22/06/2022.
//
//

protocol InstrumentDetailBuyViewInterface: AnyObject, BaseViewInterface {
    
    func show(_ model: InstrumentDetailBuyViewModel)
    func showAddedInCart()
    func showBuySuccess()
    func show(_ error: Error)
    
}
