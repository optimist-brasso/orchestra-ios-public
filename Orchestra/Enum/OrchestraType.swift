//
//  OrchestraType.swift
//  Orchestra
//
//  Created by Mukesh Shakya on 07/04/2022.
//

import Foundation
import UIKit.UIImage

enum OrchestraType: String {
    
    case conductor,
         session,
         hallSound = "hall_sound",
         player
    
    var title: String? {
        switch self {
        case .conductor:
            return "Conductor"
        case .session:
            return "Session"
        case .hallSound:
            return "Hall Sound"
        case .player:
            return "Player"
        }
    }
    
    var image: UIImage? {
        switch self {
        case .conductor:
            return UIImage(named: "conductor")
        case .session:
            return UIImage(named: "session")
        case .hallSound:
            return UIImage(named: "hall sound")
        case .player:
            return UIImage(named: "player")
        }
    }
    
    var searchPlaceholder: String? {
        switch self {
        case .conductor:
            return LocalizedKey.searchPlaceholder.value
        case .session, .hallSound, .player:
            return LocalizedKey.homeListingSearchPlaceholder.value
        }
    }
    
    var component: String? {
        switch self {
        case .hallSound:
            return "Hall Sound"
        case .session,
                .conductor,
                .player:
            return nil
        }
    }
    
}
