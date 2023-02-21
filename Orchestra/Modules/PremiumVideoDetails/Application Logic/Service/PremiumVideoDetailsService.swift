//
//  PremiumVideoDetailsService.swift
//  Orchestra
//
//  Created by Mukesh Shakya on 22/06/2022.
//
//

import Foundation

class PremiumVideoDetailsService: PremiumVideoDetailsServiceType {
    
    var cartCount: Int {
        let cartItems: [CartItem] = DatabaseHandler.shared.fetch()
        return cartItems.count
    }
    
    var notificationCount: Int {
        let notifications: [PushNotification] = DatabaseHandler.shared.fetch(filter: "isSeen == false")
        return notifications.count
    }
    
    func fetchVrPath(of fileName: String?) -> String? {
        if let fileName = fileName,
           let model: DownloadedMediaRealmModel = DatabaseHandler.shared.fetch(filter: "fileName == '\(fileName)'").first {
            return model.path
        }
        return nil
    }
    
}
