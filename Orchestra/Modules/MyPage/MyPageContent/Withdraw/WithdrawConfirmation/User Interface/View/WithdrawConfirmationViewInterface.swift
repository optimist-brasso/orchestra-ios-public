//
//  WithdrawConfirmationViewInterface.swift
//  Orchestra
//
//  Created by Mukesh Shakya on 13/07/2022.
//
//

protocol WithdrawConfirmationViewInterface: AnyObject, BaseViewInterface {
    
    func showSuccess()
    func show(_ error: Error)
    
}
