//
//  RecordingSettingsModuleInterface.swift
//  Orchestra
//
//  Created by Mukesh Shakya on 25/05/2022.
//
//

protocol RecordingSettingsModuleInterface: AnyObject {
    
    func viewIsReady()
    func select(value: String?, of type: RecordingSetting?)
    
}
