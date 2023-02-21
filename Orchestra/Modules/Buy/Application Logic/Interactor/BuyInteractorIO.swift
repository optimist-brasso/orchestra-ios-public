//
//  BuyInteractorIO.swift
//  Orchestra
//
//  Created by Mukesh Shakya on 26/04/2022.
//
//

protocol BuyInteractorInput: AnyObject {
    
    func getData()
    func buy()
    func addToCart()

}

protocol BuyInteractorOutput: AnyObject {
    
    func obtained(_ model: BuyStructure)
    func obtainedSuccess()
    func obtainedProduct()
    func obtained(_ error: Error)

}
