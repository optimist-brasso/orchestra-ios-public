//
//  UserLoginModuleInterface.swift
//  Orchestra
//
//  Created by Rojan Shrestha on 17/02/2022.
//
//

protocol UserLoginModuleInterface: AnyObject {
    
    func login(with username: String?, and password: String?)
    func signupWithLine()
    func signupWithTwitter()
    func signupWithFacebook()
    func registerWithEmail()
    func forgotPassword()
    func signupWithApple(user: AppleUser)
    func home()
    
}
