//
//  CheckoutConfirmationModuleInterface.swift
//  Orchestra
//
//  Created by Mukesh Shakya on 10/06/2022.
//
//

protocol CheckoutConfirmationModuleInterface: AnyObject {
    
    func previousModule()
    func checkout(with password: String?)
    
}
