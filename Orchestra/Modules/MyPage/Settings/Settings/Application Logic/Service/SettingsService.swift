//
//  SettingsService.swift
//  Orchestra
//
//  Created by Mukesh Shakya on 05/04/2022.
//
//

import Foundation

class SettingsService: SettingsServiceType {
    
    var profile: Profile? {
        return DatabaseHandler.shared.fetch().first
    }
    
}
