//
//  HomeService.swift
//  Orchestra
//
//  Created by Mukesh Shakya on 06/04/2022.
//
//

import Foundation

class HomeService: HomeServiceType {
    
    var cartCount: Int {
        let cartItems: [CartItem] = DatabaseHandler.shared.fetch()
        return cartItems.count
    }
    
    var notificationCount: Int {
        let notifications: [PushNotification] = DatabaseHandler.shared.fetch(filter: "isSeen == false")
        return notifications.count
    }
    
}
