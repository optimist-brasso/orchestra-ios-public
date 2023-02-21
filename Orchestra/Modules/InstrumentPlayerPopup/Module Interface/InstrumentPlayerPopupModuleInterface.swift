//
//  InstrumentPlayerPopupModuleInterface.swift
//  Orchestra
//
//  Created by Mukesh Shakya on 22/06/2022.
//
//

protocol InstrumentPlayerPopupModuleInterface: AnyObject {
    
    func viewIsReady()
    func previousModule()
    func bulkPurchase()
    func addToCart(of type: SessionType?)
    func buy(of type: SessionType?)
    func premiumVideoPlayer()
    func appendixVideoPlayer()
    
}
