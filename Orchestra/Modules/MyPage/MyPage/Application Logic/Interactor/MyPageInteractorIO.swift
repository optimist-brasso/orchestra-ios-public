//
//  MyPageInteractorIO.swift
//  Orchestra
//
//  Created by Mukesh Shakya on 05/04/2022.
//  Copyright © 2022 Orchestra. All rights reserved.
//

protocol MyPageInteractorInput: AnyObject {
    
    func getData()
    func checkLoginStatus()
    func logout()
    
}

protocol MyPageInteractorOutput: AnyObject {
    
    func obtainedLoginStatus(_ status: Bool)
    func obtained(cartCount: Int)
    func obtained(notificationCount: Int)
    func openLogoutView()
    func obtained(_ error: Error)
    func obtainedSuccess()
    
}
