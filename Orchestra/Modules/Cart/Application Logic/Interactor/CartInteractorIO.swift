//
//  CartInteractorIO.swift
//  Orchestra
//
//  Created by Mukesh Shakya on 10/05/2022.
//
//

protocol CartInteractorInput: AnyObject {

    func getData(isRefresh: Bool)
    func remove(at index: Int)
    func select(at index: Int)
    func buy(withConfirmation: Bool)
    func sendData()
    
}

protocol CartInteractorOutput: AnyObject {
    
    func obtained(_ models: [CartStructure])
    func obtained(_ hasMoreData: Bool)
    func obtained(_ error: Error)
    func obtainedSuccess(with message: String)
    func obtainedCheckoutConfirmationNeed()
    func obtained(_ notificationCount: Int)
    func obtainedProduct()

}
