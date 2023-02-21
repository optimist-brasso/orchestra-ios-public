//
//  ConductorDetailService.swift
//  Orchestra
//
//  Created by Mukesh Shakya on 18/04/2022.
//
//

import Foundation

class ConductorDetailService: ConductorDetailServiceType, OrchestraDetailApi {
    
    var cartCount: Int {
        let cartItems: [CartItem] = DatabaseHandler.shared.fetch()
        return cartItems.count
    }
    
    var notificationCount: Int {
        let notifications: [PushNotification] = DatabaseHandler.shared.fetch(filter: "isSeen == false")
        return notifications.count
    }
    
    
//    func savePath(of id: Int, path: String) {
//        if let orchestra: Orchestra = DatabaseHandler.shared.fetch(primaryKey: id) {
//            DatabaseHandler.shared.update {
//                orchestra.vrPath = path
//            }
//        }
//    }
    
//    func fetchOrchestra(of id: Int) -> Orchestra? {
//        return DatabaseHandler.shared.fetch(primaryKey: id)
//    }
    
    func fetchVrPath(of fileName: String?) -> String? {
        if let fileName = fileName, let model: DownloadedMediaRealmModel = DatabaseHandler.shared.fetch(filter: "fileName == '\(fileName)'").first {
            return model.path
        }
        return nil
    }
    
}
