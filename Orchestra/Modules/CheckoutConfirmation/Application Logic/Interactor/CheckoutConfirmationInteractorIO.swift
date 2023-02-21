//
//  CheckoutConfirmationInteractorIO.swift
//  Orchestra
//
//  Created by Mukesh Shakya on 10/06/2022.
//
//

protocol CheckoutConfirmationInteractorInput: AnyObject {
    
    func checkout(with password: String?)

}

protocol CheckoutConfirmationInteractorOutput: AnyObject {
    
    func obtainedSuccess()
    func obtained(_ error: Error)

}
