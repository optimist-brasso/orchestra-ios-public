//
//  UserLoginInteractorIO.swift
//  Orchestra
//
//  Created by Rojan Shrestha on 17/02/2022.
//
//

protocol UserLoginInteractorInput: AnyObject {
    
    func login(with username: String?, and password: String?)
    func signupWithLine()
    func signupWithFacebook()
    func signupWithTwitter(from view: UserLoginViewInterface)
    func signupWithApple(user: AppleUser)
    
}

protocol UserLoginInteractorOutput: AnyObject {
    
    func obtainedSuccess()
    func obtained(_ error: Error)
    func showLoading()
    func hideLoading()
    func obtainedProfileUpdateNeed()
    
}
