//
//  NotificationDetailService.swift
//  Orchestra
//
//  Created by Rojan Shrestha on 07/04/2022.
//
//

import Foundation

class NotificationDetailService: NotificationDetailServiceType {
    var notificationCount: Int {
        let notifications: [PushNotification] = DatabaseHandler.shared.fetch(filter: "isSeen == false")
        return notifications.count
    }
    
    
    var cartCount: Int {
        let cartItems: [CartItem] = DatabaseHandler.shared.fetch()
        return cartItems.count
    }
    
    func read(of id: Int?) {
        guard let id = id,
              let notificationRealmModel: PushNotification = DatabaseHandler.shared.fetch(primaryKey: id) else {
            return
        }
        DatabaseHandler.shared.update {
            notificationRealmModel.isSeen = true
        }
    }
    
}
