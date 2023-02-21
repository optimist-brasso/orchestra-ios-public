//
//  InstrumentDetailService.swift
//  Orchestra
//
//  Created by Mukesh Shakya on 6/13/22.
//
//

import Foundation

class InstrumentDetailService: InstrumentDetailServiceType {
    
    var cartCount: Int {
        let cartItems: [CartItem] = DatabaseHandler.shared.fetch()
        return cartItems.count
    }
    
    var notificationCount: Int {
        let notifications: [PushNotification] = DatabaseHandler.shared.fetch(filter: "isSeen == false")
        return notifications.count
    }
    
    func fetchVrPath(of fileName: String?) -> String? {
//    func fetchVrPath(of id: Int, musicianId: Int, isTrailer: Bool) -> String? {
        if let fileName = fileName,
           let model: DownloadedMediaRealmModel = DatabaseHandler.shared.fetch(filter: "fileName == '\(fileName)'").first {
            return model.path
        }
        return nil
    }
    
}
