//
//  SettingsViewInterface.swift
//  Orchestra
//
//  Created by Mukesh Shakya on 05/04/2022.
//
//

protocol SettingsViewInterface: AnyObject {
    
    func show(_ model: SettingsViewModel)
    func show(toggle: Bool)
    func show(_ error: Error)
    
}
