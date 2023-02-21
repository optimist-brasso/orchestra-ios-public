//
//  MyPageServiceType.swift
//  Orchestra
//
//  Created by Mukesh Shakya on 05/04/2022.
//  Copyright © 2022 Orchestra. All rights reserved.
//



protocol MyPageServiceType: AnyObject, LoggedInProtocol {
    
    var cartCount: Int { get }
    var notificationCount: Int { get }
    
}
