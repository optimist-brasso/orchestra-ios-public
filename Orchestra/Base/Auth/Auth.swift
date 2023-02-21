//
//  Auth.swift
//  
//
//  Created by Mukesh Shakya on 06/01/2022.
//

import Foundation
import UIKit.UIDevice

public class Auth: NSObject {
    
    static let shared = Auth()
    let baseUrl: String = {return Configuration.conf?.baseURL ?? ""}()
    
    var oAuth: AuthModel? {
        return KeyChainManager.standard.retrieve(type: AuthModel.self, forKey: EK_GlobalConstants.authKey)
    }
    
    func isTokenValid() -> Bool {
        if let time = Auth.shared.oAuth?.expiresIn, let date = Auth.shared.oAuth?.date {
            let expiryDate = date.addingTimeInterval(time)
            return Date().compare(expiryDate) == ComparisonResult.orderedAscending
        }
        return false
    }
    
}
