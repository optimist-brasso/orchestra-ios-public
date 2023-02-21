//
//  HallSoundDetailService.swift
//  Orchestra
//
//  Created by Mukesh Shakya on 22/04/2022.
//
//

import Foundation

class HallSoundDetailService: HallSoundDetailServiceType {
    
    var cartCount: Int {
        let cartItems: [CartItem] = DatabaseHandler.shared.fetch()
        return cartItems.count
    }
    
    var notificationCount: Int {
        let notifications: [PushNotification] = DatabaseHandler.shared.fetch(filter: "isSeen == false")
        return notifications.count
    }
    
    func fetchVrPath(of id: Int, type: String) -> String? {
        if let model: DownloadedMediaRealmModel = DatabaseHandler.shared.fetch(filter: "type == '\(OrchestraType.hallSound.rawValue)' AND orchestraId == \(id) AND sessionType == '\(type)'").first {
            return model.path
        }
        return nil
    }
    
}
