//
//  UserDefaults.swift
//  Orchestra
//
//  Created by Rojan Shrestha on 10/04/2022.
//

import Foundation
import Foundation

extension UserDefaults {
    
    /////  AUTHORIZATION USER DEFAULTS  ////
    
    func setIsLoggedIn(value:Bool) {
        set(value, forKey: "LOGINSTATUS")
        synchronize()
    }
    
    func isLoggedIn() -> Bool{
        return bool(forKey: "LOGINSTATUS")
    }
    
    func setWalkthrough(value:Bool){
        set(value, forKey: "WALKTHROUGH")
    }
    
    func isWalkThrough() -> Bool{
        return bool(forKey: "WALKTHROUGH")
    }
    
}
