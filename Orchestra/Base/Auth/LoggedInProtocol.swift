//
//  LoggedInProtocol.swift
//  
//
//  Created by Mukesh Shakya on 11/04/2022.
//

import Foundation

public protocol LoggedInProtocol {
    
    var isLoggedIn: Bool { get }
    var isSocialLogin: Bool { get }
    
}

public extension LoggedInProtocol {
    
    var isLoggedIn: Bool {
        return Auth.shared.oAuth?.accessToken != nil
    }
    
    var isSocialLogin: Bool {
        return Auth.shared.oAuth?.isFromSocialMedia ?? false
    }
    
}
