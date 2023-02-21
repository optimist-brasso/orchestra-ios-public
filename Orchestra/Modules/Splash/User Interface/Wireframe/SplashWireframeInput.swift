//
//  SplashWireframeInput.swift
//  Orchestra
//
//  Created by Rojan Shrestha on 12/04/2022.
//
//

import Foundation


protocol SplashWireframeInput: WireframeInput {
    
    func openEditProfile(for email: String?)
    func openHome()
    
}
