//
//  CartService.swift
//  Orchestra
//
//  Created by Mukesh Shakya on 10/05/2022.
//
//

import Foundation

class CartService: CartServiceType {
    
    var notificationCount: Int {
        let notifications: [PushNotification] = DatabaseHandler.shared.fetch(filter: "isSeen == false")
        return notifications.count
    }
    
}
