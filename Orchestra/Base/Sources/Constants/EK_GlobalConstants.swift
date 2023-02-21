//
//  EK_GlobalConstants.swift
//  
//
//  Created by Mukesh Shakya on 05/01/2022.
//

import Foundation

public struct EK_GlobalConstants {
    
    static let authKey = "ENTER_YOUR_AUTH_KEY_HERE"
    
    public struct Error {
        static let internetConnectionOffline = NSError(domain: "No_internet", code: 1234, userInfo: [NSLocalizedDescriptionKey: LocalizedKey.noInternet.value])
        public static let oops = NSError(domain: "something_wrong", code: 1234, userInfo: [NSLocalizedDescriptionKey: LocalizedKey.oops.value])
        static let passwordMismatch = NSError(domain: "password_mismatch", code: 1234, userInfo: [NSLocalizedDescriptionKey: LocalizedKey.newAndConfirmPasswordSame.value])
    }
    
    public struct Notification {
        
        let name: String
        
        public var notificationName: NSNotification.Name {
            return NSNotification.Name(rawValue: self.name)
        }
        
        func fire(withObject object: Any? = nil) {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: self.name), object: object)
        }
        
        public static let statusCodeNeedsToBeHandled: Notification = Notification(name: "statusCodeNeedsToBeHandled")
        
    }
    
}
