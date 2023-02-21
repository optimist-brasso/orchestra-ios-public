//
//  Bundle+Extension.swift
//  Orchestra
//
//  Created by Mukesh Shakya on 05/04/2022.
//

import Foundation

extension Bundle {
    
    var releaseVersionNumber: String {
        return infoDictionary?["CFBundleShortVersionString"] as? String ?? ""
    }
    
}
