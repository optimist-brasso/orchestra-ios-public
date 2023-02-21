//
//  SettingsModuleInterface.swift
//  Orchestra
//
//  Created by Mukesh Shakya on 05/04/2022.
//
//

protocol SettingsModuleInterface: AnyObject {
    
    func viewIsReady()
    func streamingDownloadSettings()
    func recordingSettings()
    func dataManagementSettings()
    func toggleNotificationStatus()
    
}
