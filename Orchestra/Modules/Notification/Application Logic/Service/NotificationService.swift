//
//  NotificationService.swift
//  Orchestra
//
//  Created by Rojan Shrestha on 07/04/2022.
//
//

import Foundation

class NotificationService: NotificationServiceType {
    
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
