//
//  StreamingDownloadSettingsModuleInterface.swift
//  Orchestra
//
//  Created by Mukesh Shakya on 05/04/2022.
//
//

protocol StreamingDownloadSettingsModuleInterface: AnyObject {
    
    func viewIsReady()
    func submit(_ model: StreamingDownloadSettingsViewModel)
    
}
