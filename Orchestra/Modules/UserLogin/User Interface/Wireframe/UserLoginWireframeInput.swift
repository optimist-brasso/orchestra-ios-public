//
//  UserLoginWireframeInput.swift
//  Orchestra
//
//  Created by Rojan Shrestha on 17/02/2022.
//
//

import Foundation


protocol UserLoginWireframeInput: WireframeInput {
    
    var openMode: OpenMode? { get set }
    func openHomePage()
    func openRegister()
    func openForgotPassword()
    func openEditProfile()
    
}
