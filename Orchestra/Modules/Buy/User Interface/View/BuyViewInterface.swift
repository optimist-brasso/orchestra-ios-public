//
//  BuyViewInterface.swift
//  Orchestra
//
//  Created by Mukesh Shakya on 26/04/2022.
//
//



protocol BuyViewInterface: AnyObject, BaseViewInterface {
    
    func show(_ model: BuyViewModel)
    func show(_ error: Error)
    
}
