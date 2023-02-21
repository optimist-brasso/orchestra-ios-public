//
//  BuyPointInteractorIO.swift
//  Orchestra
//
//  Created by Mukesh Shakya on 26/09/2022.
//
//

protocol BuyPointInteractorInput: AnyObject {
    
    func getData(showAlert: Bool)
    func buy(at index: String)

}

protocol BuyPointInteractorOutput: AnyObject {
    
    func obtained(_ models: PointHistory)
    func obtainedSuccess(with message: String?)
    func obtained(_ error: Error)
    func obtained(points: String)
    func obtained(cartCount: Int)
    func obtained(notificationCount: Int)

}
