//
//  FreePointService.swift
//  Orchestra
//
//  Created by manjil on 21/10/2022.
//

import Foundation

protocol FreePointServiceType: PointListApi, ProfileApi,  MyPageServiceType {
}

class FreePointService: FreePointServiceType {
    var cartCount: Int {
        let cartItems: [CartItem] = DatabaseHandler.shared.fetch()
        return cartItems.count
    }
    
    var notificationCount: Int {
        let notifications: [PushNotification] = DatabaseHandler.shared.fetch(filter: "isSeen == false")
        return notifications.count
    }
    
}
