//
//  MyPageContentInteractorIO.swift
//  Orchestra
//
//  Created by Mukesh Shakya on 05/04/2022.
//
//

protocol MyPageContentInteractorInput: AnyObject {
    
    func getData()
    func logout()

}

protocol MyPageContentInteractorOutput: AnyObject {
    
    func obtainedLoggedIn(status: Bool)
    func obtainedSocialLogin(status: Bool)
    func obtainedLogoutSuccess()
    func obtained(_ error: Error)

}
