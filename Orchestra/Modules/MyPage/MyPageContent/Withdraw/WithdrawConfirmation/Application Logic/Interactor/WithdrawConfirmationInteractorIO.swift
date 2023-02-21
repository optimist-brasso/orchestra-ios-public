//
//  WithdrawConfirmationInteractorIO.swift
//  Orchestra
//
//  Created by Mukesh Shakya on 13/07/2022.
//
//

protocol WithdrawConfirmationInteractorInput: AnyObject {
    
    func withdraw()
    func logout()

}

protocol WithdrawConfirmationInteractorOutput: AnyObject {
    
    func obtainedSuccess()
    func obtained(_ error: Error)

}
