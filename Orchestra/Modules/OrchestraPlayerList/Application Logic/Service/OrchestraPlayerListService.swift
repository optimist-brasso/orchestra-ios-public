//
//  OrchestraPlayerListService.swift
//  Orchestra
//
//  Created by Mukesh Shakya on 20/07/2022.
//
//

import Foundation

class OrchestraPlayerListService: OrchestraPlayerListServiceType {
    
    var cartCount: Int {
        let cartItems: [CartItem] = DatabaseHandler.shared.fetch()
        return cartItems.count
    }
    
    var notificationCount: Int {
        let notifications: [PushNotification] = DatabaseHandler.shared.fetch(filter: "isSeen == false")
        return notifications.count
    }
    
}
