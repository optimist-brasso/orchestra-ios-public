//
//  SignupInteractorIO.swift
//  Orchestra
//
//  Created by Rojan Shrestha on 14/02/2022.
//
//


protocol SignupInteractorInput: AnyObject {
    
    func signupWithLine()
    func signupWithFacebook()
    func signupWithEmail()

}

protocol SignupInteractorOutput: AnyObject {
    
    func obtainedSuccess()
    func obtained(_ error: Error)

}
