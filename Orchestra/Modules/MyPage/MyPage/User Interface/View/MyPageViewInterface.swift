//
//  MyPageViewInterface.swift
//  Orchestra
//
//  Created by Mukesh Shakya on 05/04/2022.
//  Copyright © 2022 Orchestra. All rights reserved.
//



protocol MyPageViewInterface: AnyObject, BaseViewInterface {
    
    func showLoginNeed(for mode: OpenMode?)
    func show(cartCount: Int)
    func show(notificationCount: Int)
    func showLogoutView(_ interactionStatus: Bool)
    func show(_ error: Error)
    
}
