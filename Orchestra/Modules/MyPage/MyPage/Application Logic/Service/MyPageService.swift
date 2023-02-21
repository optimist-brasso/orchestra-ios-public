//
//  MyPageService.swift
//  Orchestra
//
//  Created by Mukesh Shakya on 05/04/2022.
//  Copyright © 2022 Orchestra. All rights reserved.
//

import Foundation

class MyPageService: MyPageServiceType {
    
    var cartCount: Int {
        let cartItems: [CartItem] = DatabaseHandler.shared.fetch()
        return cartItems.count
    }
    
    var notificationCount: Int {
        let notifications: [PushNotification] = DatabaseHandler.shared.fetch(filter: "isSeen == false")
        return notifications.count
    }
    
}
