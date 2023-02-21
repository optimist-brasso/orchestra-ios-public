//
//  MyPageContentViewInterface.swift
//  Orchestra
//
//  Created by Mukesh Shakya on 05/04/2022.
//
//



protocol MyPageContentViewInterface: AnyObject, BaseViewInterface {
    
    func showLoggedIn(status: Bool)
    func showSocialLogin(status: Bool)
    func show(_ error: Error)
    
}
