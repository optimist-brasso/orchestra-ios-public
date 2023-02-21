//
//  BuyPointService.swift
//  Orchestra
//
//  Created by Mukesh Shakya on 26/09/2022.
//
//

import Foundation

class BuyPointService: BuyPointServiceType {
    
    var points: Int {
        let profile: Profile? = DatabaseHandler.shared.fetch().first
        return profile?.points ?? .zero
    }
    
    var cartCount: Int {
        let cartItems: [CartItem] = DatabaseHandler.shared.fetch()
        return cartItems.count
    }
    
    var notificationCount: Int {
        let notifications: [PushNotification] = DatabaseHandler.shared.fetch(filter: "isSeen == false")
        return notifications.count
    }
    
}
