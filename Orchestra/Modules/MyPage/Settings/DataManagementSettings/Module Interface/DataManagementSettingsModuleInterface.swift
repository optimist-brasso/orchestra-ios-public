//
//  DataManagementSettingsModuleInterface.swift
//  Orchestra
//
//  Created by Mukesh Shakya on 25/05/2022.
//
//

protocol DataManagementSettingsModuleInterface: AnyObject {
    
    func viewIsReady()
    func deleteCache()
    func deleteDownload()
    
}
