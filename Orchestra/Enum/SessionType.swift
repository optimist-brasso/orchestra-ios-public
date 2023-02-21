//
//  SessionType.swift
//  Orchestra
//
//  Created by Mukesh Shakya on 28/06/2022.
//

import Foundation

enum SessionType: String {
    
    case part,
         premium,
         appendix,
         combo
    
    var title: String? {
        switch self {
        case .part:
            return LocalizedKey.part.value
        case .premium:
            return LocalizedKey.premiumVideo.value
        default:
            return nil
        }
    }
    
    var cartTitle: String? {
        switch self {
        case .premium:
            return LocalizedKey.premium.value
        case .combo:
            return LocalizedKey.premiumSet.value
        default:
            return nil
        }
    }
    
    var component: String? {
        switch self {
        case .part:
            return "VR"
        case .premium:
            return "Premium Video"
        case .combo:
            return rawValue.capitalized
        default:
            return nil
        }
    }

}
