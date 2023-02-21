//
//  SplashInteractorIO.swift
//  Orchestra
//
//  Created by Rojan Shrestha on 12/04/2022.
//
//

protocol SplashInteractorInput: AnyObject {
    
    func getData()

}

protocol SplashInteractorOutput: AnyObject {
    
    func obtainedSuccess()
    func obtained(_ error: Error)
    func obtainedProfileUpdateNeed(for email: String?)

}
