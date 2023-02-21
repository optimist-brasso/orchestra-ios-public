//
//  SplashService.swift
//  Orchestra
//
//  Created by Rojan Shrestha on 12/04/2022.
//
//

import Foundation

class SplashService: SplashServiceType {
    
    var readNotificationIds: [Int]? {
        let notifications: [PushNotification] = DatabaseHandler.shared.fetch(filter: "isSeen == true")
        return notifications.compactMap({$0.id})
    }
    
    var unreadNotificationCount: Int? {
        let notifications: [PushNotification] = DatabaseHandler.shared.fetch(filter: "isSeen == false")
        return notifications.count
    }
    
}
